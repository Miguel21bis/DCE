--To generate a flight route from base to target, evading as much threats as possible
--Returns route points, route lenght and route threat level (unavoided threats)
--Initiated by Main_NextMission.lua
-------------------------------------------------------------------------------------------------------
-- 2.9.0 : - hélicoptères : seuil de survol de la cible abaissé (heliOverflyLimit), Egress plus proche,
--           Egress à 90 deg fixe (pas de balayage 5 deg), distance allongée jusqu'à sortir de la menace de la cible
--           et ne plus repasser sur elle,
--           points Assemble / Join / Split moins loin de la base (constantes heli* ci-dessous)
--         - ancien relevé d'altitude hélico (AltiHelicoMap / createPolyAltiHelico) retiré : ne tournait jamais
--         - PERF : contexte de menaces partagé entre les appels (caches conservés d'un GetRoute à l'autre),
--           clés de cache numériques, rejet rapide par boîte englobante, pas de copie de tables à chaque lecture
-------------------------------------------------------------------------------------------------------
if not versionDCE then versionDCE = {} end
versionDCE["ATO_RouteGenerator.lua"] = "2.9.0"
-------------------------------------------------------------------------------------------------------

local assemblePlanePtDist = 20000		-- point Assemble à 20 km de la base (avions)
local assembleHeliPtDist  = 2000		-- point Assemble à 2 km de la base (hélicos)
local planeJoinMinDist    = 15000		-- distance mini base -> Join / Split (avions)
local heliJoinMinDist     = 5000		-- idem hélicos
local heliJoinMaxDist     = 8000		-- distance maxi base -> Join / Split (hélicos, la montée est courte)
local planeOverflyLimit   = 15000		-- au dela de ce standoff, la cible n'est pas survolée (avions)
local heliOverflyLimit    = 3000		-- idem hélicos : canon/roquettes (~2 km) survolent, missiles à allonge non
local heliRunOutSeconds   = 30			-- secondes de dégagement après le tir avant l'Egress (hélicos, 90 s pour les avions)
local heliEgressClearance = 3500	-- hélicos : le retour Egress->base doit passer au moins à cette distance de la cible (m)
local heliEgressStep      = 1000	-- hélicos : pas d'allongement de la distance d'Egress (cap fixe à 90 deg) (m)
local heliEgressMaxDist   = 20000	-- hélicos : distance d'Egress maximale (m)

local floor = math.floor


-- Checks if two lines intersect (or line segments if seg is true)
local function findIntersect(l1p1, l1p2, l2p1, l2p2)
	local l1p1x, l1p1y, l1p2x, l1p2y = l1p1.x, l1p1.y, l1p2.x, l1p2.y
	local l2p1x, l2p1y, l2p2x, l2p2y = l2p1.x, l2p1.y, l2p2.x, l2p2.y

	local a1, b1 = l1p2y - l1p1y, l1p1x - l1p2x
	local a2, b2 = l2p2y - l2p1y, l2p1x - l2p2x
	local c1 = a1 * l1p1x + b1 * l1p1y
	local c2 = a2 * l2p1x + b2 * l2p1y

	local det = a1 * b2 - a2 * b1
	if det == 0 then return false, "The lines are parallel." end

	local x = (b2 * c1 - b1 * c2) / det
	local y = (a1 * c2 - a2 * c1) / det

	local min, max = math.min, math.max
	if not (min(l1p1x, l1p2x) <= x and x <= max(l1p1x, l1p2x) and min(l1p1y, l1p2y) <= y and y <= max(l1p1y, l1p2y))
	or not (min(l2p1x, l2p2x) <= x and x <= max(l2p1x, l2p2x) and min(l2p1y, l2p2y) <= y and y <= max(l2p1y, l2p2y)) then
		return false, "The lines don't intersect."
	end

	return x, y
end


-- Détecte si le segment [A, B] croise la frontière ennemie (polygone ou liste de polygones)
function CheckENY_BorderCrossPoint(A, B, enemyBoundary)
	-- enemyBoundary peut être un polygone (table de points) ou une liste de polygones
	local function checkPoly(poly)
		for i = 1, #poly do
			local p1 = poly[i]
			local p2 = poly[i % #poly + 1] -- boucle sur le dernier segment
			local x, y = findIntersect(A, B, p1, p2)
			if x and y then
				return {x = x, y = y}
			end
		end
		return nil
	end

	-- Si c'est une liste de polygones
	if type(enemyBoundary[1]) == "table" and enemyBoundary[1].x == nil then
		for _, poly in ipairs(enemyBoundary) do
			local cross = checkPoly(poly)
			if cross then
				return cross
			end
		end
	else
		-- Un seul polygone
		return checkPoly(enemyBoundary)
	end

	return nil
end


-- Copie indépendante d'une liste de menaces (les listes en cache sont partagées et ne doivent jamais être modifiées)
local function copyThreatTable(src)
	local dst = {}
	for i = 1, #src do
		local t = src[i]
		dst[i] = {
			class = t.class,
			x = t.x,
			y = t.y,
			range = t.range,
			level = t.level,
			SEAD_offset = t.SEAD_offset,
			approachfactor = t.approachfactor
		}
	end
	return dst
end


-------------------------------------------------------------------------------------------------------
-- CONTEXTE DE MENACES
-- Tout ce qui ne dépend que du camp ennemi, du jour/nuit, de hélico oui/non, de EWR évitées et des deux
-- altitudes (croisière / attaque) est calculé une seule fois puis conservé d'un GetRoute à l'autre :
-- table des menaces, menaces par segment, routes de contournement. Si les bases de menaces changent
-- (nombre, position, portée), le contexte est refait tout seul. RouteGenResetCache() force la remise à zéro.
-------------------------------------------------------------------------------------------------------
local routeContexts = {}
local routeContextCount = 0
local routeContextMax = 80

function RouteGenResetCache()
	routeContexts = {}
	routeContextCount = 0
end

-- horizon radar, mémorisé (même couple élévation/altitude = même résultat)
local horizonMemo = {}
local function radarHorizon(h1, h2)
	local byH1 = horizonMemo[h1]
	if not byH1 then
		byH1 = {}
		horizonMemo[h1] = byH1
	end
	local v = byH1[h2]
	if v then return v end

	local r = 8500000											--radius of earth (actual value 6371000 currected for refraction of radio waves)
	local d1 = math.sqrt((r + h1) * (r + h1) - r * r)			--distance from radar height to earth tangent point
	local d2 = math.sqrt((r + h2) * (r + h2) - r * r)			--distance from target altitude to earth tangent point
	local alpha1 = math.deg(math.atan(d1 / r))
	local alpha2 = math.deg(math.atan(d2 / r))
	local u1 = 2 * r * math.pi / 360 * alpha1
	local u2 = 2 * r * math.pi / 360 * alpha2
	v = u1 + u2													--total ground distance from radar to target
	byH1[h2] = v
	return v
end

-- empreinte des bases de menaces : détecte un changement entre deux générations
local function threatFingerprint(enemySide)
	local n, a, b = 0, 0, 0
	for _, t in pairs(groundthreats[enemySide]) do
		n = n + 1
		a = a + t.x + t.range
		b = b + t.y + (t.level or 0)
	end
	for _, t in pairs(EWR_DB[enemySide]) do
		n = n + 1
		a = a + t.x + t.range
		b = b + t.y
	end
	for _, t in pairs(Fighterthreats[enemySide]) do
		n = n + 1
		a = a + t.x + t.range
		b = b + t.y + (t.level or 0)
	end
	return n .. "/" .. a .. "/" .. b
end

local function newRouteContext(enemySide, time, is_helicopter, hCruise, hAttack, avoidEWR, fingerprint)
	local ctx = {
		fingerprint = fingerprint,
		gtRef = groundthreats[enemySide],
		ewrRef = EWR_DB[enemySide],
		fighters = Fighterthreats[enemySide],
		hCruise = hCruise,
		hAttack = hAttack,
		avoidEWR = avoidEWR,
		ground = {},		--menaces sol par altitude
		ewr = {},			--EWR/AWACS par altitude
		legFine = {},		--menaces par segment (précision 50 m)
		legCoarse = {},		--menaces par segment (précision 100 m, recherche de chemin)
		ewrPairs = {},		--couples EWR / chasseurs dépendants, par altitude
		paths = {},			--routes de contournement déjà trouvées
	}

	--M28 les helicoptere peuvent voir toutes les défense, meme celles hidden
	ctx.ground[hCruise] = {}
	ctx.ground[hAttack] = {}
	for threat_n, threat in pairs(groundthreats[enemySide]) do
		if (time == "day" or threat.night == true) and (not threat.hidden or is_helicopter) then
			local threatentry = {
				class = threat.class,
				SEAD_offset = threat.SEAD_offset,
				x = threat.x,
				y = threat.y,
				range = threat.range,
				type = threat.type,
			}
			if threat.min_alt <= hCruise and threat.max_alt >= hCruise then					--threat covers cruise alt
				local maxrange = radarHorizon(threat.elevation, hCruise + 100)				--maximal range due to radar horizon (alt +100 m for safety)
				if maxrange < threat.range then
					threatentry.range = maxrange
				end
				if hCruise <= 100 then
					threatentry.level = threat.level / 2									--only 50% of threat level is applied as low level clutter bonus
				else
					threatentry.level = threat.level
				end
				table.insert(ctx.ground[hCruise], threatentry)
			end
			if hCruise ~= hAttack then														--attack alt is different than cruise alt
				if threat.min_alt <= hAttack and threat.max_alt >= hAttack then				--threat covers attack alt
					threatentry.range = threat.range
					local maxrange = radarHorizon(threat.elevation, hAttack + 100)
					if maxrange < threat.range then
						threatentry.range = maxrange
					end
					if hAttack <= 100 then
						threatentry.level = threat.level / 2
					else
						threatentry.level = threat.level
					end
					table.insert(ctx.ground[hAttack], threatentry)
				end
			end
		end
	end

	ctx.ewr[hCruise] = {}
	ctx.ewr[hAttack] = {}
	for threat_n, threat in pairs(EWR_DB[enemySide]) do
		local cruisethreatentry = {
			class = threat.class,
			x = threat.x,
			y = threat.y,
			range = threat.range,
		}
		if threat.min_alt <= hCruise and threat.max_alt >= hCruise then
			local maxrange = radarHorizon(threat.elevation, hCruise + 100)
			if maxrange < threat.range then
				cruisethreatentry.range = maxrange
			end
			table.insert(ctx.ewr[hCruise], cruisethreatentry)
		end
		local attackthreatentry = {
			class = threat.class,
			x = threat.x,
			y = threat.y,
			range = threat.range,
		}
		if threat.min_alt <= hAttack and threat.max_alt >= hAttack then
			local maxrange = radarHorizon(threat.elevation, hAttack + 100)
			if maxrange < threat.range then
				attackthreatentry.range = maxrange
			end
			table.insert(ctx.ewr[hAttack], attackthreatentry)
		end
	end

	return ctx
end

local function getRouteContext(enemySide, time, is_helicopter, hCruise, hAttack, avoidEWR)
	local fp = threatFingerprint(enemySide)
	local key = enemySide .. "|" .. tostring(time) .. "|" .. (is_helicopter and "H" or "P") .. "|" .. (avoidEWR and "E" or "-") .. "|" .. hCruise .. "|" .. hAttack
	local ctx = routeContexts[key]

	if ctx and ctx.fingerprint == fp and ctx.gtRef == groundthreats[enemySide]
	and ctx.ewrRef == EWR_DB[enemySide] and ctx.fighters == Fighterthreats[enemySide] then
		return ctx
	end

	if not ctx then
		routeContextCount = routeContextCount + 1
		if routeContextCount > routeContextMax then			--garde-fou mémoire
			RouteGenResetCache()
			routeContextCount = 1
		end
	end

	ctx = newRouteContext(enemySide, time, is_helicopter, hCruise, hAttack, avoidEWR, fp)
	routeContexts[key] = ctx
	return ctx
end


-------------------------------------------------------------------------------------------------------
-- CLES DE CACHE NUMERIQUES (pas de chaînes de caractères : plus rapide, pas d'allocation)
-------------------------------------------------------------------------------------------------------
local function pointCode(p, q)
	return (floor(p.x / q) + 50000) * 100000 + (floor(p.y / q) + 50000)
end

local function pointKey(p)
	return floor(p.x + 0.5) .. "," .. floor(p.y + 0.5)
end

-- cache par segment (A->B == B->A), par altitude, avec une précision de q mètres
local function cachedLeg(cache, q, p1, p2, alt, compute, ctx)
	local c1, c2 = pointCode(p1, q), pointCode(p2, q)
	if c1 > c2 then c1, c2 = c2, c1 end

	local byAlt = cache[alt]
	if not byAlt then
		byAlt = {}
		cache[alt] = byAlt
	end
	local byC1 = byAlt[c1]
	if not byC1 then
		byC1 = {}
		byAlt[c1] = byC1
	end
	local v = byC1[c2]
	if v == nil then
		v = compute(ctx, p1, p2, alt)
		byC1[c2] = v
	end
	return v
end

-- retourne true si ce segment (ordonné p1->p2, altitude, instance) a déjà été exploré, sinon le marque
local function markExplored(cache, p1, p2, alt, instance)
	local c1, c2 = pointCode(p1, 100), pointCode(p2, 100)

	local byInst = cache[instance]
	if not byInst then
		byInst = {}
		cache[instance] = byInst
	end
	local byAlt = byInst[alt]
	if not byAlt then
		byAlt = {}
		byInst[alt] = byAlt
	end
	local byC1 = byAlt[c1]
	if not byC1 then
		byC1 = {}
		byAlt[c1] = byC1
	end
	if byC1[c2] then return true end
	byC1[c2] = true
	return false
end


-------------------------------------------------------------------------------------------------------
-- MENACES SUR UN SEGMENT
-- Retourne une liste de menaces {class,x,y,range,level,SEAD_offset,approachfactor}.
-- La liste est PARTAGEE (cache) : ne jamais la modifier, utiliser copyThreatTable() si besoin.
-------------------------------------------------------------------------------------------------------

-- couples (EWR, chasseurs qui en dépendent et dont les zones se recoupent), calculés une fois par altitude
local function ewrFighterPairs(ctx, leg_alt)
	local list = ctx.ewrPairs[leg_alt]
	if list then return list end

	list = {}
	local ewrs = ctx.ewr[leg_alt]
	local fighters = ctx.fighters
	for e = 1, #ewrs do
		local ewr = ewrs[e]
		if ewr.class == "EWR" then										--only EWR, ignore AWACS (too large area to avoid)
			local dependents = {}
			for f = 1, #fighters do
				local fg = fighters[f]
				local ewr_required = false
				if fg.class == "CAP" then
					if leg_alt >= 3000 then
						ewr_required = false							--CAP does not need ewr at high altitude
					elseif fg.LDSD then
						ewr_required = false							--look down/shoot down capable
					else
						ewr_required = true
					end
				elseif fg.class == "Intercept" then
					ewr_required = true									--needs early warning to take off
				end
				if ewr_required and GetDistance(ewr, fg) < ewr.range + fg.range then
					dependents[#dependents + 1] = fg
				end
			end
			if #dependents > 0 then
				list[#list + 1] = {ewr = ewr, fighters = dependents}
			end
		end
	end

	ctx.ewrPairs[leg_alt] = list
	return list
end

local function legThreatsRaw(ctx, p1, p2, leg_alt)
	local tbl = {}

	-- boîte englobante du segment : une menace dont le cercle ne la touche pas ne peut pas être sur le segment
	local minx, maxx, miny, maxy = p1.x, p2.x, p1.y, p2.y
	if minx > maxx then minx, maxx = maxx, minx end
	if miny > maxy then miny, maxy = maxy, miny end

	--check ground threats
	local ground = ctx.ground[leg_alt]
	for t = 1, #ground do
		local th = ground[t]
		local r = th.range
		if th.x + r >= minx and th.x - r <= maxx and th.y + r >= miny and th.y - r <= maxy then
			local d = GetTangentDistance(p1, p2, th)
			if d < r then															--route passes threat
				tbl[#tbl + 1] = {
					class = th.class,
					x = th.x,
					y = th.y,
					range = r,
					level = th.level,
					SEAD_offset = th.SEAD_offset,
					approachfactor = 1 - d / r,										--factor how close route passes to threat (1 = on top)
				}
			end
		end
	end

	--check EWR threats (only if loadout should avoid them)
	if ctx.avoidEWR then
		local pairsList = ewrFighterPairs(ctx, leg_alt)
		for i = 1, #pairsList do
			local ewr = pairsList[i].ewr
			local dependents = pairsList[i].fighters
			local bestFactor, bestLevel = 0, nil
			local dEwr = nil
			for f = 1, #dependents do
				local fg = dependents[f]
				if GetTangentDistance(p1, p2, fg) < fg.range then					--route leg is in range of fighterthreat
					dEwr = dEwr or GetTangentDistance(p1, p2, ewr)
					if dEwr < ewr.range then										--route leg is in range of ewr
						local approachfactor = 1 - dEwr / ewr.range
						if approachfactor > bestFactor then
							bestFactor = approachfactor
							bestLevel = fg.level									--capability level of fighter becomes threat level of EWR station
						end
					end
				end
			end
			if bestFactor > 0 then
				tbl[#tbl + 1] = {
					class = ewr.class,
					x = ewr.x,
					y = ewr.y,
					range = ewr.range,
					level = bestLevel,
					approachfactor = bestFactor,
				}
			end
		end
	end

	return tbl
end

local function legThreats(ctx, p1, p2, leg_alt)
	return cachedLeg(ctx.legFine, 50, p1, p2, leg_alt, legThreatsRaw, ctx)
end

local function legThreatsCoarse(ctx, p1, p2, leg_alt)
	return cachedLeg(ctx.legCoarse, 100, p1, p2, leg_alt, legThreatsRaw, ctx)
end

-- retire (sans modifier la liste en cache) les menaces qui couvrent déjà p1 ou pEnd : on ne peut pas les éviter
local function dropCoveredThreats(threat, p1, pEnd)
	local kept = nil
	for t = 1, #threat do
		local th = threat[t]
		local r2 = th.range * th.range
		local dx1, dy1 = p1.x - th.x, p1.y - th.y
		local dx2, dy2 = pEnd.x - th.x, pEnd.y - th.y
		if dx1 * dx1 + dy1 * dy1 <= r2 or dx2 * dx2 + dy2 * dy2 <= r2 then
			if not kept then
				kept = {}
				for i = 1, t - 1 do kept[i] = threat[i] end
			end
		elseif kept then
			kept[#kept + 1] = th
		end
	end
	return kept or threat
end


-------------------------------------------------------------------------------------------------------
-- RECHERCHE D'UNE ROUTE DE CONTOURNEMENT DES MENACES entre deux points
-- Retourne {navpoints = {...}, dist = ..., threats = ...}. Résultat conservé dans le contexte.
-------------------------------------------------------------------------------------------------------
local function findPathCtx(ctx, from, to)

	local pathKey = pointKey(from) .. "|" .. pointKey(to)
	local cachedPath = ctx.paths[pathKey]
	if cachedPath then return cachedPath end

	local hAttack = ctx.hAttack
	local exploredLegCache = {}					--segments déjà explorés
	local queue = {}							--file des FindPathLeg à exécuter (chaque exécution peut en ajouter)
	local navRoutes = {}						--toutes les routes possibles trouvées
	local direct_distance = GetDistance(from, to)
	local no_threat_route = {}					--par altitude : instance à laquelle une route sans menace a été trouvée
	local bestRouteScore = math.huge			--Branch & Bound : meilleur score (distance + menace) connu

	local function FindPathLeg(point1, point2, pointEnd, distance, arg_route, instance, leg_alt)

		instance = instance + 1

		if markExplored(exploredLegCache, point1, point2, leg_alt, instance) then
			return
		end

		--also try a low variant (first instance only, if attack alt is lower than cruise alt)
		if instance == 1 and leg_alt > hAttack then
			queue[#queue + 1] = {point1, point2, pointEnd, distance + 1, arg_route, instance - 1, hAttack}	--distance + 1 : léger biais contre la route basse
		end

		--abort unneeded pathfinding after a no-threat route has been found at this altitude
		if no_threat_route[leg_alt] and instance > no_threat_route[leg_alt] then
			return
		end

		local distance_remain = GetDistance(point1, pointEnd)
		local threat = legThreatsCoarse(ctx, point1, point2, leg_alt)

		--sum of threat factors from point1 to the end
		local threatsum = 0
		if point2 == pointEnd then
			for t = 1, #threat do
				threatsum = threatsum + threat[t].approachfactor
			end
		else
			local threat2 = legThreatsCoarse(ctx, point1, pointEnd, leg_alt)
			for t = 1, #threat2 do
				threatsum = threatsum + threat2[t].approachfactor
			end
		end

		-- Branch & Bound : on coupe si le score minimal possible est déjà pire que la meilleure route connue
		local score = distance + distance_remain + threatsum * direct_distance
		if score >= bestRouteScore then
			return
		end

		--save the current route variant directly to end before trying to refine it further
		navRoutes[#navRoutes + 1] = {navpoints = arg_route, dist = distance + distance_remain, threats = threatsum}
		bestRouteScore = score

		if threatsum == 0 then													--there are no threats to end
			return
		end

		--ignore threats that directly cover point1 or pointEnd (cannot be avoided)
		threat = dropCoveredThreats(threat, point1, pointEnd)

		if instance > 7 then
			return
		elseif distance + distance_remain > (direct_distance * 3.5) then
			return
		elseif #threat == 0 then												--no more avoidable threats on this leg
			if point2 == pointEnd then
				no_threat_route[leg_alt] = instance								--cancels subsequent route finding at this altitude
				return
			else
				distance = distance + GetDistance(point1, point2)
				arg_route[#arg_route + 1] = point2
				queue[#queue + 1] = {point2, pointEnd, pointEnd, distance, arg_route, instance, leg_alt}
			end
		else																	--there is a threat on leg : try left and right side alternates
			local point1_point2_heading = GetHeadingDegre(point1, point2)
			for s = 1, -1, -2 do
				local point2alt = GetOffsetPoint(threat[1], point1_point2_heading + (s * 90), threat[1].range * 4 / 3)
				local threat_leg = dropCoveredThreats(legThreatsCoarse(ctx, point1, point2alt, leg_alt), point1, pointEnd)

				if #threat_leg == 0 then										--no threat between point1 and point2alt
					local distance_alt = distance + GetDistance(point1, point2alt)
					local route_alt = {}
					for k = 1, #arg_route do
						route_alt[k] = {x = arg_route[k].x, y = arg_route[k].y}
					end
					route_alt[#route_alt + 1] = point2alt
					queue[#queue + 1] = {point2alt, pointEnd, pointEnd, distance_alt, route_alt, instance, leg_alt}
				else															--threat between point1 and point2alt : find new route to point2alt
					queue[#queue + 1] = {point1, point2alt, pointEnd, distance, arg_route, instance, leg_alt}
				end
			end
		end
	end

	queue[1] = {from, to, to, 0, {}, 0, ctx.hCruise}

	local q = 1
	while queue[q] do
		local a = queue[q]
		FindPathLeg(a[1], a[2], a[3], a[4], a[5], a[6], a[7])
		q = q + 1
	end

	--Determine best nav route
	local temp_route = {
		navpoints = {},
		dist = direct_distance
	}
	for n = 1, #navRoutes do
		if n == 1 then
			temp_route = navRoutes[n]
		elseif navRoutes[n].threats < temp_route.threats or (navRoutes[n].threats == temp_route.threats and navRoutes[n].dist < temp_route.dist) then
			temp_route = navRoutes[n]
		end
	end

	ctx.paths[pathKey] = temp_route
	return temp_route
end


-------------------------------------------------------------------------------------------------------
-- GetRoute
-------------------------------------------------------------------------------------------------------
function GetRoute(basePoint, target, profile, sideName, task, time, multipackn, multipackmax, unit, viaFARP)		--enemy: "blue" or "red"; time: "day" or "night"

	local route = {}															--table to store the route to be built
	local route_axis = GetHeadingDegre(target, basePoint)						--axis base-target
	local standoff																--standoff distance of attack WP from target
	local enemySide_name = DCS_ENI_Side[sideName]								--determine enemy side (opposite of unit side)

	local is_helicopter = false
	if IsHelicopter[unit.type] then
		is_helicopter = true
	end

	-- hélicos : la cible est survolée dès que le standoff est court, les armes à allonge tirent depuis le point Attack
	local overflyLimit = planeOverflyLimit
	if is_helicopter then overflyLimit = heliOverflyLimit end

	-- altitude randomization
	local new_hCruise = nil
	local altitudeOffset = 0
	if profile.hCruise and profile.hCruise > 2000 then

		local randomChance = math.random(0,100)

		if randomChance < 50 then
			altitudeOffset = math.random(100,200) * 10
		elseif randomChance < 70 then
			altitudeOffset = math.random(0,100) * 10
		end

		altitudeOffset = altitudeOffset * (math.random(0,1) * 2 - 1)

		new_hCruise = math.max( 300, profile.hCruise + altitudeOffset )
	else
		new_hCruise = profile.hCruise
	end

	-- contexte de menaces (partagé entre les appels, voir plus haut)
	local ctx = getRouteContext(enemySide_name, time, is_helicopter, new_hCruise, profile.hAttack, profile.avoid_EWR and true or false)

	local function threatOnLeg(point1, point2, leg_alt)
		return legThreats(ctx, point1, point2, leg_alt)
	end

	local function findPath(from, to)
		return findPathCtx(ctx, from, to)
	end

	-- distance base -> Join / Split : montée/descente, mais jamais trop près de la base ni (hélicos) trop loin
	local minLegDist = planeJoinMinDist
	if is_helicopter then minLegDist = heliJoinMinDist end
	local function legDistance(distance, firstLegDist)
		if is_helicopter and distance > heliJoinMaxDist then
			distance = heliJoinMaxDist
		end
		if distance >= firstLegDist then								--climb/descend distance bigger than distance to first WP
			return firstLegDist / 3 * 2									--point is 2/3 to first WP
		elseif distance < minLegDist then
			return minLegDist
		end
		return distance
	end

	-- point Join : sur l'axe base -> firstPoint
	local function computeJoinPoint(firstPoint, alt, pitchFactor)
		local heading = GetHeadingDegre(basePoint, firstPoint)
		local distance = legDistance(math.abs((alt - basePoint.h) * pitchFactor), GetDistance(basePoint, firstPoint))
		return GetOffsetPoint(basePoint, heading, distance)
	end

	-- point Assemble : sur l'axe base -> joinPoint
	local function computeAssemblyPoint(joinPoint)
		local offsetDist = assemblePlanePtDist
		if is_helicopter then offsetDist = assembleHeliPtDist end
		local heading = GetHeadingDegre(basePoint, joinPoint)
		if GetDistance(basePoint, joinPoint) < offsetDist then offsetDist = offsetDist * 2 / 3 end
		return GetOffsetPoint(basePoint, heading, offsetDist)
	end

	-- niveau de menace cumulé d'un segment pour le choix de l'IP / de l'Egress.
	-- weighted = true : pondéré par l'approche de la menace (IP et Egress des frappes), sinon longueur dans la menace seule
	local function legThreatLevel(p1, p2, weighted)
		local threat = threatOnLeg(p1, p2, profile.hAttack)
		local total_threat_level = 0
		local ewr_penality = false
		for t = 1, #threat do
			local th = threat[t]
			if th.class == "EWR" then
				if ewr_penality == false then
					total_threat_level = total_threat_level + 0.1		--small bias for routes under an EWR (multiple EWR do not add up)
					ewr_penality = true
				end
			elseif weighted then
				local closest_approach = GetTangentDistance(p1, p2, th)
				local closest_approach_factor = 1 - closest_approach / th.range		--1 = on top, 0 not at all
				local lenght_in_threat = GetTangentLenght(p1, p2, th, th.range)
				total_threat_level = total_threat_level + th.level * (lenght_in_threat / (th.range * 2)) * closest_approach_factor
			else
				total_threat_level = total_threat_level + GetTangentLenght(p1, p2, th, th.range) / (th.range * 2) * th.level
			end
		end
		return total_threat_level
	end

	-- distance à parcourir depuis A (cap heading) avant d'entrer dans le premier cercle de menace
	-- (0 = déjà dans un cercle). Sert à placer les points de descente / montée.
	local function distanceToThreatCircles(A, heading, threat)
		local distance = 100000000
		for t = 1, #threat do
			local p1_t_heading = GetHeadingDegre(A, threat[t])
			local alpha = math.abs(heading - p1_t_heading)						--angle beteen route and p1-threat
			if alpha > 180 then
				alpha = math.abs(alpha - 360)
			end
			local p1_t = GetDistance(A, threat[t])
			local p1_p90t = math.cos(math.rad(alpha)) * p1_t					--distance between p1 and point on route perpendicular to threat
			local p90t_t = p1_t * math.sin(math.rad(alpha))						--distance between threat and that point
			local p90t_pC = math.sqrt(threat[t].range * threat[t].range - p90t_t * p90t_t)
			local p1_pC = p1_p90t - p90t_pC										--distance from p1 to point on route intersecting threat circle
			if p1_pC <= 0 then													--intersection point is ahead of p1
				if threat[t].invert then										--area outside of EWR range is the threat area
					distance = -p1_pC
				else
					distance = 0
					break														--p1 is already within a threat circle
				end
			elseif p1_pC < distance then
				distance = p1_pC
			end
		end
		return distance
	end

	-- réduit la portée des EWR aux zones de chasseurs (le profil haute altitude n'est menacé que là)
	local function reduceEWRRanges(threat, A, B)
		local fighters = ctx.fighters
		for t = 1, #threat do
			if threat[t].class == "EWR" then
				local newEWRrange = 0											--reduce EWR range to point where route enters the first fighter threat
				for f = 1, #fighters do
					if GetTangentDistance(A, B, fighters[f]) < fighters[f].range then
						local heading1 = GetHeadingDegre(A, B)					--route heading
						local heading2 = GetHeadingDegre(A, fighters[f])		--heading to center of threat circle
						local alpha = math.abs(heading1 - heading2)
						if alpha > 180 then
							alpha = math.abs(alpha - 360)
						end
						alpha = math.rad(alpha)
						local a = fighters[f].range
						local b = GetDistance(A, fighters[f])
						local beta = math.asin(b / (a / math.sin(alpha)))		--sinus sentence
						beta = math.pi - beta									--only the second angle is valid
						local gamma = math.pi - alpha - beta
						local c = a / math.sin(alpha) * math.sin(gamma)			--distance from A to point intersecting threat circle
						local p = GetOffsetPoint(A, heading1, c)
						local EWR_p = GetDistance(threat[t], p)
						if EWR_p < threat[t].range and EWR_p > newEWRrange then
							newEWRrange = EWR_p
						end

						local heading_p_t = GetHeadingDegre(p, fighters[f])
						local heading_p_EWR = GetHeadingDegre(p, threat[t])
						local angle = math.abs(heading_p_t - heading_p_EWR)
						if angle > 180 then
							angle = math.abs(angle - 360)
						end
						if angle > 90 then
							threat[t].invert = true								--the threat circle of EWR is outside of the interception area!
						end
					end
				end
				if newEWRrange > 0 then
					threat[t].range = newEWRrange
				end
			end
		end
	end


	----- find a route depending on task -----
	if task == "Strike" or task == "Anti-ship Strike" or task == "Reconnaissance" or task == "CSAR" or task == "Runway Attack" then

		--///////////////////==========================================================
		--set Initial Point IP
		--///////////////////==========================================================
		local initialPoint = {}
		local base_target_route = findPath(basePoint, target)					--find the safest route between basePoint and target

		local ideal_axis														--ideal axis of the IP
		if #base_target_route.navpoints == 0 then
			ideal_axis = route_axis												--ideal IP is on base-target axis
		else
			ideal_axis = GetHeadingDegre(target, base_target_route.navpoints[#base_target_route.navpoints])	--ideal IP is on target-last navpoint axis
		end

		if profile.standoff then
			standoff = profile.standoff											--use value from loadout profile
		else
			standoff = profile.hAttack + profile.vAttack * 30					--standoff distance is attack alt plus 30 seconds at attack speed
			if is_helicopter then
				if task == "SAR" or task == "CSAR" then
					standoff = 0
				end
			elseif standoff < 7000 then											--standoff should be at least 7000m
				standoff = 7000
			end
		end

		do
			local ip_distance													--distance from target to IP
			local ip_distance_A = standoff + profile.vAttack * 60				--standoff range + 60 seconds run in at attack speed

			-- Temps de chute en fonction de l'altitude, distance horizontale parcourue pendant la chute
			local t_drop = math.sqrt(2 * profile.hAttack / 9.81)
			local drop_distance = profile.vAttack * t_drop

			-- Distance IP = standoff + distance de chute + marge de stabilisation (30 s)
			local ip_distance_B = standoff + drop_distance + profile.vAttack * 30

			if ip_distance_B < ip_distance_A then
				ip_distance = ip_distance_A
			else
				ip_distance = ip_distance_B
			end

			if profile.ingress then												--ingress distance is defined in loadout
				ip_distance = standoff + profile.ingress
			end
			local IP_table = {}													--table to store all possible IPs

			local maxAttackOffset = 90
			if profile.MaxAttackOffset then
				maxAttackOffset = profile.MaxAttackOffset
			end

			local heading_min = ideal_axis - maxAttackOffset					--lowest heading from target to IP
			local heading_max = ideal_axis + maxAttackOffset					--highest heading from target to IP
			if multipackmax > 1 then											--if this is part of a multi package attack
				ideal_axis = heading_min + (multipackn - 1) / (multipackmax - 1) * (maxAttackOffset * 2)	--distribute ideal axis evenly across maximal left/right offset
			end

			for n = 0, 180, 5 do												--find IP by evaluating threat level in 5 deg steps
				if initialPoint.x then											--break loop if an IP is set
					break
				end
				for m = 1, -1, -2 do											--try left and right option for each offset from ideal axis
					local ip_heading = ideal_axis + (n * m)
					if (ip_heading >= heading_min and ip_heading <= heading_max) or task == "CSAR" then
						local draft_IP = GetOffsetPoint(target, ip_heading, ip_distance)
						local draft_attackPoint = target
						if standoff > overflyLimit then							--standoff beyond the overfly limit : target will not be overflown
							draft_attackPoint = GetOffsetPoint(target, ip_heading, standoff)
						end

						local total_threat_level = legThreatLevel(draft_IP, draft_attackPoint, true)

						if total_threat_level == 0 then							--no threat : make this the IP and stop evaluation
							initialPoint = draft_IP
							initialPoint["ip_distance"] = ip_distance
							break
						else
							table.insert(IP_table, {point = draft_IP, ip_distance = ip_distance, threat = total_threat_level})
						end
					end
				end
			end

			if initialPoint.x == nil then										--if IP is not yet set, find the best from IP table
				local current_threat = 1000000
				for n = 1, #IP_table do
					local roundedThreat = math.floor(IP_table[n].threat * 10000000000) / 10000000000	--round threat value to remove rounding errors
					if roundedThreat < current_threat then
						initialPoint = IP_table[n].point
						initialPoint["ip_distance"] = IP_table[n].ip_distance
						current_threat = roundedThreat
					end
				end
			end
		end

		--///////////////////==========================================================
		--set attack point
		--///////////////////==========================================================
		local target_ip_heading = GetHeadingDegre(target, initialPoint)
		local attackPoint = GetOffsetPoint(target, target_ip_heading, standoff)	--attack point is standoff range from target on straight IP-target line

		--///////////////////==========================================================
		--set egress point
		--///////////////////==========================================================
		local egressPoint = {}
		do
			local egress_point_start											--point from where egress is initiated (target or attack point depending on standoff)
			local egress_table = {}
			local runOutSeconds = 90											--secondes de dégagement avant l'Egress
			if is_helicopter then runOutSeconds = heliRunOutSeconds end

			local egress_distance = standoff + profile.vAttack * runOutSeconds
			if profile.egress then
				egress_distance = standoff + profile.egress
			end

			local egress_heading

			if task == "Strike" or task == "Anti-ship Strike" or task == "Runway Attack" then

				if standoff <= overflyLimit then								--target will be overflown. Optimal egress should be 90 deg offset from ingress in direction of RTB
					egress_point_start = target

					if GetDeltaHeading(route_axis, target_ip_heading) > 0 then	--homebase is on left side of ingress heading
						egress_heading = target_ip_heading + 90
					else														--homebase is on right side of ingress heading
						egress_heading = target_ip_heading - 90
					end
				else															--stand off attack : optimal egress is in direction of home base
					egress_point_start = attackPoint
					egress_distance = profile.vAttack * runOutSeconds
					if profile.egress then
						egress_distance = profile.egress
					end
					egress_heading = GetHeadingDegre(attackPoint, basePoint)
				end

				if is_helicopter and standoff <= overflyLimit then
					--hélico qui survole la cible : cap fixe à 90 deg de l'entrée (côté base), sans balayage d'angle.
					--Si ce n'est pas suffisant, on allonge la distance jusqu'à (1) sortir des zones de menace
					--qui couvrent la cible et (2) ne plus repasser près de la cible en rentrant à la base.
					local distance = egress_distance
					local maxDistance = math.max(heliEgressMaxDist, egress_distance)
					local draft_egress = GetOffsetPoint(egress_point_start, egress_heading, distance)
					while distance < maxDistance do
						local clear = true
						local threat = threatOnLeg(egress_point_start, draft_egress, profile.hAttack)
						for t = 1, #threat do
							if threat[t].class ~= "EWR" and GetDistance(draft_egress, threat[t]) <= threat[t].range then
								clear = false									--l'Egress est encore dans une zone de menace
								break
							end
						end
						if clear and GetTangentDistance(draft_egress, basePoint, target) < heliEgressClearance then
							clear = false									--le retour vers la base repasse trop près de la cible
						end
						if clear then break end
						distance = math.min(distance + heliEgressStep, maxDistance)
						draft_egress = GetOffsetPoint(egress_point_start, egress_heading, distance)
					end
					egressPoint = draft_egress
				else
				for n = 0, 180, 5 do											--egress between egress heading and +/- 180 deg offset in 5 deg steps
					if egressPoint.x then
						break
					end
					for m = 1, -1, -2 do
						local egress_try = egress_heading + n * m
						local deltaIngress = GetDeltaHeading(egress_try, target_ip_heading)
						if deltaIngress >= 15 or deltaIngress <= -15 then		--valid egresses must be at least 15 deg offset from ingress
							local draft_egress = GetOffsetPoint(egress_point_start, egress_try, egress_distance)
							local total_threat_level = legThreatLevel(egress_point_start, draft_egress, true)
							if total_threat_level == 0 then
								egressPoint = draft_egress
								break
							else
								table.insert(egress_table, {point = draft_egress, threat = total_threat_level})
							end
						end
					end
				end
				end

			elseif task == "Reconnaissance" or task == "CSAR" then

				if task == "CSAR" then
					egress_distance = 0
				end
				egress_heading = GetHeadingDegre(initialPoint, target)
				for n = 0, 30, 5 do												--egress between egress heading and +/- 30 deg offset in 5 deg steps
					if egressPoint.x then
						break
					end
					for m = 1, -1, -2 do
						local draft_egress = GetOffsetPoint(target, egress_heading + n * m, egress_distance)
						local total_threat_level = legThreatLevel(target, draft_egress, false)
						if total_threat_level == 0 then
							egressPoint = draft_egress
							break
						else
							table.insert(egress_table, {point = draft_egress, threat = total_threat_level})
						end
					end
				end
			end

			if egressPoint.x == nil then										--if egress is not yet set, find the best from egress table
				local current_threat = 1000000
				for n = 1, #egress_table do
					if egress_table[n].threat < current_threat then
						egressPoint = egress_table[n].point
						current_threat = egress_table[n].threat
					end
				end
			end
		end

		--set outbound and inbound routes
		local outbound_navRoute = findPath(basePoint, initialPoint)				--find the safest route between basePoint and initialPoint
		local inbound_navRoute = findPath(basePoint, egressPoint)				--find the safest route between egressPoint and basePoint

		--///////////////////==========================================================
		--set form-up point (Join), split point (Split) and assemble point
		--///////////////////==========================================================
		local joinFirst = initialPoint											--join point is between basePoint and the first nav point (or the IP)
		if #outbound_navRoute.navpoints > 0 then joinFirst = outbound_navRoute.navpoints[1] end
		local joinPoint = computeJoinPoint(joinFirst, new_hCruise, 10)			--climb 6 deg pitch

		local splitFirst = egressPoint
		if #inbound_navRoute.navpoints > 0 then splitFirst = inbound_navRoute.navpoints[1] end
		local splitPoint = computeJoinPoint(splitFirst, new_hCruise, 4)			--descend 15 deg pitch

		local assemblyPoint = computeAssemblyPoint(joinPoint)

		--build complete route if virtual air base, in the AIR ;), Spawn
		-- Miguel21 modification M16.d : SpawnAir B1b & B-52 need BaseAirStart = true in db_aibase
		if basePoint.BaseAirStart == true then

			table.insert(route, {x = basePoint.x, y = basePoint.y, id = "Spawn", alt = new_hCruise })
			table.insert(route, {x = joinPoint.x, y = joinPoint.y, id = "Join", alt = new_hCruise, hCruiseREF = profile.hCruiseREF})

		elseif is_helicopter and viaFARP then
			table.insert(route, {x = basePoint.x, y = basePoint.y, id = "Taxi", alt = basePoint.h})
			table.insert(route, {x = basePoint.x, y = basePoint.y, id = "Departure", alt = basePoint.h })
			table.insert(route, {x = assemblyPoint.x, y = assemblyPoint.y, id = "Assemble", alt = new_hCruise })
			table.insert(route, {x = joinPoint.x, y = joinPoint.y, id = "Join", alt = new_hCruise , hCruiseREF = profile.hCruiseREF})
			table.insert(route, {x = viaFARP.x, y = viaFARP.y, id = "LandRefuel", alt = viaFARP.h })
		else
			table.insert(route, {x = basePoint.x, y = basePoint.y, id = "Taxi", alt = basePoint.h})
			table.insert(route, {x = basePoint.x, y = basePoint.y, id = "Departure", alt = basePoint.h })
			table.insert(route, {x = assemblyPoint.x, y = assemblyPoint.y, id = "Assemble", alt = new_hCruise })
			table.insert(route, {x = joinPoint.x, y = joinPoint.y, id = "Join", alt = new_hCruise , hCruiseREF = profile.hCruiseREF})
		end

		for n = 1, #outbound_navRoute.navpoints do
			table.insert(route, {x = outbound_navRoute.navpoints[n].x, y = outbound_navRoute.navpoints[n].y, id = "Nav", alt = new_hCruise, debug = "Nav_A"})
		end

		-- Heavy bomber helper waypoint
		if Data_divers[unit.type] and Data_divers[unit.type].heavyBomber then

			local lastWp = route[#route]
			local distJoinIP = GetDistance(lastWp, initialPoint)

			if distJoinIP > 150000 then

				local headingPreIP = GetHeadingDegre(initialPoint, lastWp)
				local preIPDistance = math.min(100000, math.max(50000, math.floor(distJoinIP * 0.25)))
				local preIP = GetOffsetPoint(initialPoint, headingPreIP, preIPDistance)

				table.insert(route, {
					x = preIP.x,
					y = preIP.y,
					id = "PreIP",
					alt = profile.hAttack,
					debug = "HeavyBomber_PreIP "..preIPDistance
				})
			end
		end

		-- Décalage visuel des multipackages sur la même cible
		local attackTargetOffset = 0
		if multipackmax and multipackmax > 1 then
			local center = (multipackmax + 1) / 2
			attackTargetOffset = (multipackn - center) * 300
		end

		-- Décalage latéral du point Attack
		if attackTargetOffset ~= 0 then
			local attackHeading = GetHeadingDegre(initialPoint, initialPoint)
			attackPoint = GetOffsetPoint(attackPoint, attackHeading + 90, attackTargetOffset)
		end

		table.insert(route, {x = initialPoint.x, y = initialPoint.y, id = "IP", alt = profile.hAttack, debug = "ip_distance: "..initialPoint.ip_distance})
		table.insert(route, {x = attackPoint.x, y = attackPoint.y, id = "Attack", alt = profile.hAttack})

		if standoff <= overflyLimit then										--target is overflown. For higher standoff, Target is only inserted after route lenght and threats are calculated
			table.insert(route, {x = target.x, y = target.y, id = "Target", alt = profile.hAttack})
		end

		table.insert(route, {x = egressPoint.x, y = egressPoint.y, id = "Egress", alt = profile.hAttack})

		for n = #inbound_navRoute.navpoints, 1, -1 do
			table.insert(route, {x = inbound_navRoute.navpoints[n].x, y = inbound_navRoute.navpoints[n].y, id = "Nav", alt = new_hCruise, debug = "Nav_B"})
		end

		table.insert(route, {x = splitPoint.x, y = splitPoint.y, id = "Split", alt = new_hCruise})
		table.insert(route, {x = basePoint.x, y = basePoint.y, id = "Land", alt = new_hCruise})

		--///////////////////==========================================================
		--set descend and climb points in route
		if new_hCruise > profile.hAttack then									--cruise higher than attack altitude : a descend and a climb point must be inserted

			--descend point
			for n = 3, #route - 2 do											--iterate through route between join and split point
				if route[n].alt == new_hCruise then

					local threat = {}											--threats on leg at high alt default to 0 as an earlier change in altitude is of no advantage
					if profile.hAttack < 1000 then								--if attack alt is at low altitude, collect actual threats to determine descend point
						threat = copyThreatTable(threatOnLeg(route[n], route[n + 1], new_hCruise))
					end

					reduceEWRRanges(threat, route[n], route[n + 1])

					if #threat == 0 then										--no threat on route
						if route[n].alt > route[n + 1].alt then					--but route segment is the descend leg
							local heading = GetHeadingDegre(route[n + 1], route[n])
							local distance = math.abs((new_hCruise - profile.hAttack)) * 6		--6 times the altitude difference (~-10 deg pitch)
							if distance < GetDistance(route[n + 1], route[n]) then
								local descendPoint = GetOffsetPoint(route[n + 1], heading, distance)
								descendPoint.id = "Nav"
								descendPoint.debug = "Nav_C"
								descendPoint.alt = new_hCruise
								table.insert(route, n + 1, descendPoint)
							end
							break
						end
					else														--threats on route leg : make the descend on this route leg
						for m = n, #route do									--all subsequent waypoints until IP to low alt
							if route[m + 1] and route[m + 1].alt and route[m + 1].alt == new_hCruise then
								route[m + 1].alt = profile.hAttack
							else
								break
							end
						end

						local heading = GetHeadingDegre(route[n], route[n + 1])
						local distance = distanceToThreatCircles(route[n], heading, threat)

						if distance == 0 then									--p1 is already within a threat circle : alter p1 to low level instead
							route[n].alt = profile.hAttack
						else													--descend point is beyond of route[n]
							local descendPointEnd = GetOffsetPoint(route[n], heading, distance)
							descendPointEnd.id = "Nav"
							descendPointEnd.debug = "Nav_D"
							descendPointEnd.alt = profile.hAttack
							table.insert(route, n + 1, descendPointEnd)
							local descend_distance = (new_hCruise - profile.hAttack) * 6
							if descend_distance < distance then
								local descendPointStart = GetOffsetPoint(route[n], heading, (distance - descend_distance))
								descendPointStart.id = "Nav"
								descendPointStart.debug = "descendPointStart_Nav_D2"
								descendPointStart.alt = new_hCruise
								table.insert(route, n + 1, descendPointStart)
							end
						end
						break
					end
				end
			end

			--climb point
			for n = #route - 1, 4, -1 do										--iterate through route backwards between split and join point
				if route[n].alt == new_hCruise then

					local threat = {}
					if profile.hAttack < 1000 then
						threat = copyThreatTable(threatOnLeg(route[n], route[n - 1], new_hCruise))
					end

					reduceEWRRanges(threat, route[n], route[n - 1])

					if #threat == 0 then
						if route[n].alt > route[n - 1].alt then					--but route segment is the climb leg
							local heading = GetHeadingDegre(route[n - 1], route[n])
							local distance = math.abs((new_hCruise - profile.hAttack)) * 10		--10 times the altitude difference (~-6 deg pitch)
							if distance < GetDistance(route[n - 1], route[n]) then
								local climbPoint = GetOffsetPoint(route[n - 1], heading, distance)
								climbPoint.id = "Nav"
								climbPoint.debug = "Nav_E"
								climbPoint.alt = new_hCruise
								table.insert(route, n, climbPoint)
							end
							break
						end
					else														--threats on route leg : make the climb on this route leg
						for m = n, 1, -1 do										--all previous waypoints until Egress to low alt
							if route[m - 1] and route[m - 1].alt == new_hCruise then
								route[m - 1].alt = profile.hAttack
							else
								break
							end
						end

						local heading = GetHeadingDegre(route[n], route[n - 1])
						local distance = distanceToThreatCircles(route[n], heading, threat)

						if distance == 0 then
							route[n].alt = profile.hAttack
						else
							local climbPointStart = GetOffsetPoint(route[n], heading, distance)
							climbPointStart.id = "Nav"
							climbPointStart.debug = "Nav_F"
							climbPointStart.alt = profile.hAttack
							table.insert(route, n, climbPointStart)
							local climb_distance = (new_hCruise - profile.hAttack) * 10
							if climb_distance < distance then
								local climbPointEnd = GetOffsetPoint(route[n + 1], heading, (distance - climb_distance))
								climbPointEnd.id = "Nav"
								climbPointEnd.debug = "Nav_F2"
								climbPointEnd.alt = new_hCruise
								table.insert(route, n + 1, climbPointEnd)
							end
						end
						break
					end
				end
			end

		elseif new_hCruise < profile.hAttack then								--cruise lower than attack altitude : a descend and a climb point must be inserted
			for n = 3, #route - 2 do
				if route[n].alt < route[n + 1].alt then							--climb route leg
					local heading = GetHeadingDegre(route[n + 1], route[n])
					local distance = math.abs((new_hCruise - profile.hAttack) * 10)
					if distance < GetDistance(route[n], route[n + 1]) then
						local climbPoint = GetOffsetPoint(route[n + 1], heading, distance)
						climbPoint.id = "Nav"
						climbPoint.debug = "Nav_G"
						climbPoint.alt = new_hCruise
						table.insert(route, n + 1, climbPoint)
					end
					break
				end
			end
			for n = 3, #route - 2 do
				if route[n].alt > route[n + 1].alt then							--descend route leg
					local heading = GetHeadingDegre(route[n], route[n + 1])
					local distance = math.abs((new_hCruise - profile.hAttack) * 10)
					if distance < GetDistance(route[n + 1], route[n]) then
						local descendPoint = GetOffsetPoint(route[n], heading, distance)
						descendPoint.id = "Nav"
						descendPoint.debug = "Nav_H"
						descendPoint.alt = new_hCruise
						table.insert(route, n + 1, descendPoint)
					end
					break
				end
			end
		end

	elseif task == "Fighter Sweep" then

		--set outbound and inbound routes
		local sweepStart = target												--start point of sweep
		local sweepEnd															--end point of sweep
		if target.MultiPoints then												--the sweep target has multiple points
			sweepEnd = target.MultiPoints[#target.MultiPoints]					--sweep ends at last point
		else
			sweepEnd = target
		end

		local outbound_navRoute = findPath(basePoint, sweepStart)				--find the safest outbound route
		local inbound_navRoute = findPath(basePoint, sweepEnd)					--find the safest inbound route

		--set form-up point
		local joinFirst = sweepStart
		if #outbound_navRoute.navpoints > 0 then joinFirst = outbound_navRoute.navpoints[1] end
		local joinPoint = computeJoinPoint(joinFirst, new_hCruise, 7)			--climb 8 deg pitch

		--set split point
		local splitFirst = sweepEnd
		if #inbound_navRoute.navpoints > 0 then splitFirst = inbound_navRoute.navpoints[1] end
		local splitPoint = computeJoinPoint(splitFirst, new_hCruise, 7)			--descend 8 deg pitch

		local assemblyPoint = computeAssemblyPoint(joinPoint)

		--build complete route
		table.insert(route, {x = basePoint.x, y = basePoint.y, id = "Taxi", alt = basePoint.h})
		table.insert(route, {x = basePoint.x, y = basePoint.y, id = "Departure", alt = basePoint.h })
		table.insert(route, {x = assemblyPoint.x, y = assemblyPoint.y, id = "Assemble", alt = new_hCruise })
		table.insert(route, {x = joinPoint.x, y = joinPoint.y, id = "Join", alt = new_hCruise, hCruiseREF = profile.hCruiseREF})
		for n = 1, #outbound_navRoute.navpoints do
			table.insert(route, {x = outbound_navRoute.navpoints[n].x, y = outbound_navRoute.navpoints[n].y, id = "Nav", alt = new_hCruise, debug = "Nav_I"})
		end
		if target.MultiPoints then												--the sweep target has multiple points
			for n = 1, #target.MultiPoints do
				table.insert(route, {x = target.MultiPoints[n].x, y = target.MultiPoints[n].y, id = "Sweep", alt = profile.hAttack})
			end
		else
			table.insert(route, {x = target.x, y = target.y, id = "Sweep", alt = profile.hAttack})
		end
		for n = #inbound_navRoute.navpoints, 1, -1 do
			table.insert(route, {x = inbound_navRoute.navpoints[n].x, y = inbound_navRoute.navpoints[n].y, id = "Nav", alt = new_hCruise, debug = "Nav_J"})
		end
		table.insert(route, {x = splitPoint.x, y = splitPoint.y, id = "Split", alt = new_hCruise})
		table.insert(route, {x = basePoint.x, y = basePoint.y, id = "Land", alt = new_hCruise})


	elseif task == "CAP" or task == "AWACS" or task == "Refueling" or task == "AFAC" then

		--set orbit points (orbit leg 3 minutes)
		local orbit_lenght = profile.vAttack * 180

		local axeStart = route_axis + 90
		local axeEnd = route_axis - 90
		if target.axis then
			axeStart = target.axis
			axeEnd = target.axis + 180
		end

		local orbitStart = GetOffsetPoint(target, axeStart, orbit_lenght / 2)
		local orbitEnd = GetOffsetPoint(target, axeEnd, orbit_lenght / 2)

		--set outbound and inbound routes
		local outbound_navRoute = findPath(basePoint, orbitStart)				--find the safest outbound route
		local inbound_navRoute = findPath(basePoint, orbitEnd)					--find the safest inbound route

		if not basePoint.h then
			print("basePoint "..tostring(basePoint.name))
		end

		--set form-up point
		local joinFirst = orbitStart
		if #outbound_navRoute.navpoints > 0 then joinFirst = outbound_navRoute.navpoints[1] end
		local joinPoint = computeJoinPoint(joinFirst, new_hCruise, 7)

		--set split point
		local splitFirst = orbitEnd
		if #inbound_navRoute.navpoints > 0 then splitFirst = inbound_navRoute.navpoints[1] end
		local splitPoint = computeJoinPoint(splitFirst, new_hCruise, 7)

		local assemblyPoint = computeAssemblyPoint(joinPoint)

		--build complete route
		table.insert(route, {x = basePoint.x, y = basePoint.y, id = "Taxi", alt =  basePoint.h})
		table.insert(route, {x = basePoint.x, y = basePoint.y, id = "Departure", alt = basePoint.h})
		table.insert(route, {x = assemblyPoint.x, y = assemblyPoint.y, id = "Assemble", alt = new_hCruise })
		table.insert(route, {x = joinPoint.x, y = joinPoint.y, id = "Join", alt = new_hCruise, hCruiseREF = profile.hCruiseREF})
		for n = 1, #outbound_navRoute.navpoints do
			table.insert(route, {x = outbound_navRoute.navpoints[n].x, y = outbound_navRoute.navpoints[n].y, id = "Nav", alt = new_hCruise})
		end

		local tempAlt = profile.hAttack
		if target.alt then
			tempAlt = target.alt
		end

		table.insert(route, {x = orbitStart.x, y = orbitStart.y, id = "Station", alt = tempAlt})
		table.insert(route, {x = orbitEnd.x, y = orbitEnd.y, id = "Station", alt = tempAlt})
		for n = #inbound_navRoute.navpoints, 1, -1 do
			table.insert(route, {x = inbound_navRoute.navpoints[n].x, y = inbound_navRoute.navpoints[n].y, id = "Nav", alt = new_hCruise})
		end
		table.insert(route, {x = splitPoint.x, y = splitPoint.y, id = "Split", alt = new_hCruise})
		table.insert(route, {x = basePoint.x, y = basePoint.y, id = "Land", alt = new_hCruise})


		--climb and descend points
		if new_hCruise < profile.hAttack then									--cruise lower than attack altitude
			for n = 3, #route - 2 do
				if route[n].alt < route[n + 1].alt then							--climb route leg
					local heading = GetHeadingDegre(route[n + 1], route[n])
					local distance = math.abs((new_hCruise - profile.hAttack) * 12)
					if distance < GetDistance(route[n], route[n + 1]) then
						local climbPoint = GetOffsetPoint(route[n + 1], heading, distance)
						climbPoint.id = "Nav"
						climbPoint.debug = "Nav_K"
						climbPoint.alt = new_hCruise
						table.insert(route, n + 1, climbPoint)
					end
					break
				end
			end
			for n = 3, #route - 2 do
				if route[n].alt > route[n + 1].alt then							--descend route leg
					local heading = GetHeadingDegre(route[n], route[n + 1])
					local distance = math.abs((new_hCruise - profile.hAttack) * 10)
					if distance < GetDistance(route[n + 1], route[n]) then
						local descendPoint = GetOffsetPoint(route[n], heading, distance)
						descendPoint.id = "Nav"
						descendPoint.debug = "Nav_L"
						descendPoint.alt = new_hCruise
						table.insert(route, n + 1, descendPoint)
					end
					break
				end
			end
		elseif new_hCruise > profile.hAttack then
			for n = 3, #route - 2 do
				if route[n].alt < route[n + 1].alt then							--climb route leg
					local heading = GetHeadingDegre(route[n], route[n + 1])
					local distance = math.abs((new_hCruise - profile.hAttack) * 10)
					if distance < GetDistance(route[n], route[n + 1]) then
						local climbPoint = GetOffsetPoint(route[n], heading, distance)
						climbPoint.id = "Nav"
						climbPoint.debug = "Nav_M"
						climbPoint.alt = new_hCruise
						table.insert(route, n + 1, climbPoint)
					end
					break
				end
			end
			for n = 3, #route - 2 do
				if route[n].alt > route[n + 1].alt then							--descend route leg
					local heading = GetHeadingDegre(route[n + 1], route[n])
					local distance = math.abs((new_hCruise - profile.hAttack) * 10)
					if distance < GetDistance(route[n + 1], route[n]) then
						local descendPoint = GetOffsetPoint(route[n + 1], heading, distance)
						descendPoint.id = "Nav"
						descendPoint.debug = "Nav_N"
						descendPoint.alt = new_hCruise
						table.insert(route, n + 1, descendPoint)
					end
					break
				end
			end
		end


	elseif task == "Transport" or task == "Nothing" then

		--set outbound route
		local outbound_navRoute = findPath(basePoint, target)					--find the safest outbound route

		--set form-up point
		local joinFirst = target
		if #outbound_navRoute.navpoints > 0 then joinFirst = outbound_navRoute.navpoints[1] end
		local joinPoint = computeJoinPoint(joinFirst, profile.hCruise, 7)

		--set split point
		local splitPoint = {}
		do
			local point															--split point is between target and this point
			if #outbound_navRoute.navpoints == 0 then
				point = joinPoint
			else
				point = outbound_navRoute.navpoints[#outbound_navRoute.navpoints]
			end
			local heading = GetHeadingDegre(target, point)
			local distance = legDistance(math.abs((new_hCruise - basePoint.h) * 7), GetDistance(basePoint, point))
			splitPoint = GetOffsetPoint(target, heading, distance)
		end

		local assemblyPoint = computeAssemblyPoint(joinPoint)

		table.insert(route, {x = basePoint.x, y = basePoint.y, id = "Taxi", alt = basePoint.h})
		table.insert(route, {x = basePoint.x, y = basePoint.y, id = "Departure", alt = basePoint.h })
		table.insert(route, {x = assemblyPoint.x, y = assemblyPoint.y, id = "Assemble", alt = new_hCruise })
		table.insert(route, {x = joinPoint.x, y = joinPoint.y, id = "Join", alt = new_hCruise})
		table.insert(route, {x = splitPoint.x, y = splitPoint.y, id = "Split", alt = new_hCruise})
		table.insert(route, {x = target.x, y = target.y, id = "Land", alt = new_hCruise})
	end


	if task == "Reconnaissance" then
		-- ajout des WPT in et out, entrée et sortie de la zone ENI
		if camp.boundary and camp.boundary[enemySide_name] and camp.boundary[enemySide_name] ~= nil then

			local new_route = {}

			for n = 1, #route - 1 do
				-- copier le waypoint courant (copie superficielle pour éviter de référencer la même table)
				local wp = route[n]
				local wp_copy = {}
				for k, v in pairs(wp) do wp_copy[k] = v end
				new_route[#new_route + 1] = wp_copy

				-- test de crossing entre route[n] et route[n+1]
				local ourBoundary = camp.boundary[sideName]
				local ourSideOfBorder_A = false
				local ourSideOfBorder_B = false
				if ourBoundary then
					ourSideOfBorder_A = CheckPointInPolygon(route[n], ourBoundary)
					ourSideOfBorder_B = CheckPointInPolygon(route[n + 1], ourBoundary)
				end

				local enemyBorderCrossPoint = CheckENY_BorderCrossPoint(route[n], route[n + 1], camp.boundary[enemySide_name])

				if enemyBorderCrossPoint then
					local newPoint = {
						x = enemyBorderCrossPoint.x,
						y = enemyBorderCrossPoint.y,
						alt = route[n + 1].alt,
					}

					if ourSideOfBorder_A == true and ourSideOfBorder_B == false then
						newPoint.id = "Border In"
					elseif ourSideOfBorder_A == false and ourSideOfBorder_B == true then
						newPoint.id = "Border Out"
					else
						newPoint.id = "Border"
					end

					new_route[#new_route + 1] = newPoint
				end
			end

			-- ajouter le dernier waypoint (copie aussi)
			if route[#route] then
				local last = {}
				for k, v in pairs(route[#route]) do last[k] = v end
				new_route[#new_route + 1] = last
			end

			-- remplacer la table route par la nouvelle table
			route = new_route
		end
	end


	--measure lenght of complete route
	local route_lenght = 0
	for n = 1, #route - 1 do
		route_lenght = route_lenght + GetDistance(route[n], route[n + 1])
	end
	route.lenght = route_lenght

	if DebugRoute then
		print("AtoRG passe BB route.lenght "..tostring(route.lenght))
	end

	--evaluate threat level of complete route
	do
		route.threats = {}														--table to store threats for route

		--ground threats
		route.threats.ground = {}
		for n = 1, #route - 1 do												--iterate through all route segements
			local A, B = route[n], route[n + 1]
			local minx, maxx, miny, maxy = A.x, B.x, A.y, B.y
			if minx > maxx then minx, maxx = maxx, minx end
			if miny > maxy then miny, maxy = maxy, miny end

			for alt, threat in pairs(ctx.ground) do								--iterate through all ground threat altitudes
				if B.alt <= alt then											--route segement is in threat altitude
					for t = 1, #threat do
						local th = threat[t]
						local r = th.range
						if th.x + r >= minx and th.x - r <= maxx and th.y + r >= miny and th.y - r <= maxy then
							local distance = GetTangentDistance(A, B, th)		--distance of route segment to threat
							if distance < r then								--route segment is in range of threat
								local adjusted_threat = th.level - (th.level / r * distance)	--threat adjusted to distance to route leg
								local key = th.x .. "/" .. th.y
								local entry = route.threats.ground[key]
								if entry then
									if entry.level < adjusted_threat then
										entry.level = adjusted_threat
									end
								else
									route.threats.ground[key] = {
										level = adjusted_threat,
										offset = th.SEAD_offset
									}
								end
								if th.class == "SAM" then
									if A.SEAD_radius then
										if r > A.SEAD_radius then				--find longest ranging threat that route segment penetrates
											A.SEAD_radius = r
										end
									else
										A.SEAD_radius = r
									end
								end
							end
						end
					end
				end
			end
		end

		--air threats
		route.threats.air = {}
		local fighters = ctx.fighters
		for t = 1, #fighters do
			local fg = fighters[t]
			if fg.class == "CAP" or fg.class == "Intercept" then
				for n = 1, #route - 1 do

					local route_leg_alt
					local route_leg_band
					if route[n].alt >= 3000 and route[n + 1].alt >= 3000 then
						route_leg_alt = new_hCruise
						route_leg_band = "high"
					else
						route_leg_alt = profile.hAttack
						route_leg_band = "low"
					end

					if GetTangentDistance(route[n], route[n + 1], fg) < fg.range then		--route segment is in range of fighter threat
						local ewr_required												--whether ewr is required for the fighter to be a threat
						if fg.class == "CAP" then
							if route_leg_band == "high" then
								ewr_required = false									--CAP does not need ewr to be a threat
							elseif fg.LDSD then
								ewr_required = false									--look down/shoot down capable
							end
							-- ATO_RG_Debug02 quand les EWR sont détruits : on active les CAP, si les CAP ont besoin d'EWR c'est nul
						elseif fg.class == "Intercept" then
							ewr_required = true											--needs early warning to take off
						end

						if ewr_required == true then
							local break_loop = false
							local ewrs = ctx.ewr[route_leg_alt]
							for e = 1, #ewrs do
								if GetDistance(ewrs[e], fg) < ewrs[e].range + fg.range then		--fighter operation area and ewr coverage are overlapping
									if GetTangentDistance(route[n], route[n + 1], ewrs[e]) < ewrs[e].range then	--route leg is in range of ewr/awacs
										if route.threats.air[fg.name] then
											if route.threats.air[fg.name].level < fg.level then
												route.threats.air[fg.name].level = fg.level
											end
										else
											route.threats.air[fg.name] = {
												level = fg.level,
											}
										end
										break_loop = true
										break											--ewr loop
									end
								end
							end
							if break_loop == true then
								break													--route segment loop : go to next threat
							end
						else															--no ewr is needed for fighter to be a threat
							if route.threats.air[fg.name] then
								if route.threats.air[fg.name].level < fg.level then
									route.threats.air[fg.name].level = fg.level
								end
							else
								route.threats.air[fg.name] = {
									level = fg.level,
								}
							end
							break														--route segment loop : go to next threat
						end
					end
				end
			end
		end

		--combine route threats
		route.threats.SEAD_offset = 0											--counter for SEAD sorties required to offset ground threats
		route.threats.ground_total = 0.5										--cummulative route ground threat level (0.5 = no threat)
		route.threats.air_total = 0.5											--cummulative route air threat level (0.5 = no threat)

		for k, v in pairs(route.threats.ground) do
			route.threats.SEAD_offset = route.threats.SEAD_offset + v.offset
			route.threats.ground_total = route.threats.ground_total + v.level
		end
		for k, v in pairs(route.threats.air) do
			route.threats.air_total = route.threats.air_total + v.level
		end
	end


	if standoff and standoff > overflyLimit then								--standoff beyond the overfly limit : Target point has not yet been inserted
		for r = 1, #route do
			if route[r].id == "Attack" then
				local toTarget = GetHeadingDegre(route[r], target)
				-- Target au plus à 5 km de l'Attack, et à mi-chemin de la cible pour un standoff court (hélicos) : on ne survole pas la cible
				local towards_target = GetOffsetPoint(route[r], toTarget, math.min(5000, standoff / 2))
				table.insert(route, r + 1, {x = towards_target.x, y = towards_target.y, id = "Target", alt = profile.hAttack})
				break
			end
		end
	end

	return route
end



function GetEscortRoute(basePoint, orig_route, task, loadouts, unitEscort, mainUnit)	--get the escort route given the escort start point and an existing package route

	--make a local copy of the route table forwarded as function argument (otherwise the original route gets adjusted
	local route = DeepCopy(orig_route)

	-- décalage latéral permanent de l'escorte
	local escortOffset = 300

	if math.random(0,1) == 1 then
		escortOffset = -escortOffset
	end

	if route and #route <= 4 then return end

	-- ne recopie pas le Spawn des B1b et B-52 en apparation sur une base virtuel en alti
	if route[1].id == "Spawn" then
		route[1].id = "Taxi"
	end

	route[1].id = "Taxi"
	route[1].x = basePoint.x													--modify route to start at escort start point
	route[1].y = basePoint.y
	route[1].alt = basePoint.h

	-- chercher un waypoint "Departure" existant
	local departurIndex = nil
	for i, w in ipairs(route) do
		if w.id == "Departure" then
			departurIndex = i
			break
		end
	end

	if not departurIndex then
		local tempDeparture = {
			id = "Departure",
			x = basePoint.x,
			y = basePoint.y,
			alt = basePoint.h,
		}
		table.insert(route, 2, tempDeparture)
	else
		route[2].x = basePoint.x
		route[2].y = basePoint.y
		route[2].alt = basePoint.h
	end

	-- change l'altitude des differents role, sinon, Strike Escorte et SEAD sont à la meme alti, pas bien
	local randomAlti = math.random(4500, 7600)
	if IsHelicopter[unitEscort.type] then
		if loadouts.hCruise then
			randomAlti = math.random(loadouts.hCruise*2/3, loadouts.hCruise)
		else
			randomAlti = math.random(0, 700)
		end
	end


	--******************* w route ************************
	for w = 1, #route do

		if not IsHelicopter[unitEscort.type] then
			if loadouts.hAttack then
				-- ne pas avoir d'avion haute altitude en escorte TBA
				if route[w].id == "IP" or route[w].id == "Attack" or route[w].id == "Target" or route[w].id == "Egress" then
					route[w].alt = loadouts.hAttack
				end
			else
				route[w].alt = randomAlti
			end
		else
			route[w].alt = randomAlti
		end

		if IsHelicopter[mainUnit.type] and not IsHelicopter[unitEscort.type] then
			-- les avions escorte d helicopter doivent etre a leur alti conso
			route[w].alt = route[w].alt + randomAlti
		end

		if route[w].id == "Land" then
			route[w].alt = basePoint.h
		end
	end


	-- décale tous les waypoints hérités du MAIN
	for w = 3, #route - 2 do

		local heading

		if route[w + 1] then
			heading = GetHeadingDegre(route[w], route[w + 1])
		else
			heading = GetHeadingDegre(route[w - 1], route[w])
		end

		local offsetPoint = GetOffsetPoint(route[w], heading + 90, escortOffset)

		route[w].x = offsetPoint.x
		route[w].y = offsetPoint.y
	end

	--adjust route for escort joining the package
	local join_distance = 99999999												--shortest distance from escort start point to package route leg
	local jointWP
	for n = 4, #route - 1 do													--iterate through route points from Join Point on
		local d = GetTangentDistance(route[n], route[n + 1], basePoint)
		if d < join_distance then												--distance to this route leg is shorter than to previous leg
			join_distance = d													--set new shortest join distance
			jointWP = n
		else																	--distance to this route leg is longer than to previous leg
			break																--stop searching
		end
		if route[n + 1].id == "IP" then											--only search to IP
			break
		end
	end

	if not IsHelicopter[unitEscort.type] then
		local heading = 0
		for n, wpt in ipairs(route) do
			if wpt.id == "Join" then
				heading = GetHeadingDegre(route[jointWP], basePoint)
				break
			end
		end

		local assemblyPoint = GetOffsetPoint(basePoint, heading, assemblePlanePtDist)

		local altitude = AltitudeCruise * 2 / 3

		if Data_divers[unitEscort.type] and Data_divers[unitEscort.type].hCruise then
			altitude = Data_divers[unitEscort.type].hCruise * 2 / 3
		end

		-- chercher un waypoint "Assemble" existant
		local assembleIndex = nil
		for i, w in ipairs(route) do
			if w.id == "Assemble" then
				assembleIndex = i
				break
			end
		end

		if assembleIndex then
			-- mettre à jour l'existant
			route[assembleIndex].x = assemblyPoint.x
			route[assembleIndex].y = assemblyPoint.y
			route[assembleIndex].alt = altitude
		else
			-- insérer en position 3 sans remplacer
			table.insert(route, 3, { x = assemblyPoint.x, y = assemblyPoint.y, id = "Assemble", alt = altitude })
		end

	end


	if GetDistance(basePoint, route[jointWP]) == join_distance then				--shortest distance to route leg is to first leg waypoint
		route[4].x = route[jointWP].x
		route[4].y = route[jointWP].y
	elseif GetDistance(basePoint, route[jointWP + 1]) == join_distance then		--shortest distance to route leg is to second leg waypoint
		route[4].x = route[jointWP + 1].x
		route[4].y = route[jointWP + 1].y
	else																		--shortest distance to route leg is between first and second leg waypoint
		local join_heading
		local heading1 = GetHeadingDegre(route[jointWP], route[jointWP + 1])
		local heading2 = GetHeadingDegre(route[jointWP], basePoint)
		if heading1 - heading2 > 180 then
			heading1 = heading1 - 360
		elseif heading2 - heading1 > 180 then
			heading2 = heading2 - 360
		end
		if heading1 <= heading2 then
			join_heading = heading1 - 90
		else
			join_heading = heading1 + 90
		end
		local mod_joinPoint = GetOffsetPoint(basePoint, join_heading, join_distance)	--modify the Joint Point to be between route leg jointWP 1 and 2
		route[4].x = mod_joinPoint.x
		route[4].y = mod_joinPoint.y
	end
	-- (ATO_RG_Debug03 : les anciennes boucles table.remove, vides depuis longtemps, ont été retirées)


	--adjust route for escort to leave the package
	local split_distance = 99999999												--shortest distance from escort end point to package route leg
	for n = #route - 1, 2, -1 do												--iterate backwards through route points from Split Point on
		local d = GetTangentDistance(route[n], route[n - 1], basePoint)
		if d < split_distance then												--distance to this route leg is shorter than to previous leg
			split_distance = d													--set new shortest split distance
			jointWP = n
		else																	--distance to this route leg is longer than to previous leg
			break																--stop searching
		end
		if route[n - 1].id == "Egress" then										--only search to Egress
			break
		end
	end


	if mainUnit.task == "Transport" or mainUnit.task == "Nothing" then

		--comme le groupe Transport n'a pas de retour vers sa base de départ, on se doit d'en créer pour ses escortes
		--ajoute le wpt land
		table.insert(route, { x = basePoint.x, y = basePoint.y, id = "Land", alt = basePoint.h })

		--renomme l'ancien wpt land en attack
		route[#route - 1].id = "Target"
		local targetPoint = route[#route - 1]

		--renomme le wpt join en TransmitMessage
		local altMax = 0
		for n = 1, #route do
			if route[n].id == "Split" then
				route[n].id = "Nav"
				route[n].debug = "Nav_O"
			end
			if route[n].alt > altMax then
				altMax = route[n].alt
			end
		end

		--ajoute le WPT Egress pour obtenir un CERCLE d'attente
		local egressPoint = {}
		do
			local heading = GetHeadingDegre(targetPoint, route[#route - 2])
			egressPoint = GetOffsetPoint(targetPoint, heading, 5000)
		end

		table.insert(route, #route, { x = egressPoint.x, y = egressPoint.y, id = "Egress", alt = altMax })

		--ajoute un WPT Split
		local newPoint = {}
		do
			local heading = GetHeadingDegre(basePoint, targetPoint)

			local distance = math.abs((altMax - basePoint.h) * 4)				--distance to descend from cruise alt to base elevation with 15 deg pitch
			if distance >= GetDistance(basePoint, targetPoint) then				--descend distance bigger than distance to last WP
				distance = GetDistance(basePoint, targetPoint) / 3 * 2			--join point is 2/3 to last WP
			elseif distance < 15000 then										--descend distance less than 15 km
				distance = 15000												--split point should be at least 15 km from base
			end

			newPoint = GetOffsetPoint(basePoint, heading, distance)
		end

		table.insert(route, #route, { x = newPoint.x, y = newPoint.y, id = "Split", alt = altMax })

	else	--pour les escortes de tous les autres task main

		route[#route].x = basePoint.x											--modify route to end at escort land point
		route[#route].y = basePoint.y

		--INFO ne pas supprimer, cela evite aux ESCORT de suivre les bombers jusqu'a leur base
		if GetDistance(basePoint, route[jointWP]) == split_distance then
			route[#route - 1].x = route[jointWP].x
			route[#route - 1].y = route[jointWP].y
			for n = #route - 2, jointWP, -1 do
				table.remove(route, n)
			end
		elseif GetDistance(basePoint, route[jointWP - 1]) == split_distance then
			route[#route - 1].x = route[jointWP - 1].x
			route[#route - 1].y = route[jointWP - 1].y
			for n = #route - 2, jointWP - 1, -1 do
				table.remove(route, n)
			end
		else --if a point between last Nav and Split Point is closest to escort land point
			local split_heading
			local heading1 = GetHeadingDegre(route[jointWP], route[jointWP - 1])
			local heading2 = GetHeadingDegre(route[jointWP], basePoint)
			if heading1 - heading2 > 180 then
				heading1 = heading1 - 360
			elseif heading2 - heading1 > 180 then
				heading2 = heading2 - 360
			end
			if heading1 <= heading2 then
				split_heading = heading1 - 90
			else
				split_heading = heading1 + 90
			end
			local mod_splitPoint = GetOffsetPoint(basePoint, split_heading, split_distance)	--modify the Split Point to be between last Nav and old Split Point
			route[#route - 1].x = mod_splitPoint.x
			route[#route - 1].y = mod_splitPoint.y
			for n = #route - 2, jointWP, -1 do
				table.remove(route, n)
			end
		end

		--ajoute un WPT descent, proche de la base si necessaire, cela permet aux escortes (notamment) de se poser correctement.
		local newPoint = {}
		local heading
		if IsHelicopter[unitEscort.type] then
			if GetDistance(basePoint, route[#route - 1]) > 5000 then
				heading = GetHeadingDegre(basePoint, route[#route - 1])
				newPoint = GetOffsetPoint(basePoint, heading, 10000)
				table.insert(route, #route, { x = newPoint.x, y = newPoint.y, id = "WPT Before Landind", alt = route[#route - 1].alt })
			end
		else
			heading = GetHeadingDegre(basePoint, route[#route - 1])
			newPoint = GetOffsetPoint(basePoint, heading, 30000)
			table.insert(route, #route, { x = newPoint.x, y = newPoint.y, id = "WPT Before Landing", alt = route[#route - 1].alt })
		end
	end

	--measure lenght of complete route
	local route_lenght = 0
	for n = 1, #route - 1 do
		route_lenght = route_lenght + GetDistance(route[n], route[n + 1])
	end
	route.lenght = route_lenght

	if DebugRoute then
		print("AtoRG passe CC route.lenght "..tostring(route.lenght))
	end

	return route
end
