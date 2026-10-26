-- DCE_Convoys
-- Spawn dynamique des convois routiers de campL.wargame_convoys, au début de la mission.
-- Convoi n : spawn à DELAY_FIRST + (n-1) * DELAY_STEP secondes après le chargement du script (5 s, 6 s, 7 s...).
--
-- Si la campagne ne fournit pas campL.wargame_convoys, le script se contente d'écrire une ligne
-- dans dcs.log et ne fait rien d'autre : la campagne ne gère pas les convois dynamiques.
--
-- Méthode (pas de MIST, pas de MOOSE, pas de findPathOnRoads) :
--   * le convoi est posé sur la route la plus proche de "from", véhicules espacés de SPACING m
--   * chaque point de "route" (sauf les doublons de from/to) est recalé sur la route la plus
--     proche (land.getClosestPointOnRoads) et devient un waypoint "On Road" :
--     DCS trouve seul son chemin entre deux waypoints
--   * le dernier waypoint est "to" en "Off Road" pour rejoindre le supplyPoint
--   * vitesse : 2/3 de la vitesse nominale sur route, 50 % sur le dernier tronçon hors route
--
-- Sécurités : campL n'est lu qu'une seconde avant le premier spawn (l'ordre de chargement des
-- scripts n'a donc pas d'importance), chaque appel DCS est protégé par pcall, chaque convoi est
-- traité séparément (un convoi qui échoue ne gêne pas les autres), aucune variable globale.
-- Ne dépend d'aucun autre fichier du projet (seul campL est lu, et PathDCE / TableSerialization
-- uniquement pour le fichier de debug, s'ils existent).
-------------------------------------------------------------------------------------------------------
-- RÉGLAGES : on ne modifie que ces lignes
-------------------------------------------------------------------------------------------------------
local SPAWN_ACTIVE  = true  -- true  = crée réellement les convois
                            -- false = mode essai : calcule tout et écrit dans dcs.log, ne crée AUCUN groupe
local DELAY_FIRST   = 5     -- s : délai de spawn du convoi n°1
local DELAY_STEP    = 1     -- s : délai ajouté à chaque convoi suivant (n°2 = 6 s, n°3 = 7 s...)
local SNAP_MAX      = 2000  -- m : un point de route plus loin que ça d'une route est ignoré
local MERGE_DIST    = 50    -- m : deux points consécutifs plus proches que ça après recalage sont fusionnés
local SPACING       = 20    -- m : espace entre deux véhicules au spawn
local SPEED_ROAD    = 2 / 3 -- part de la vitesse nominale sur route
local SPEED_OFFROAD = 0.5   -- part de la vitesse nominale hors route
local SPEED_DEFAULT = 18    -- m/s : vitesse nominale si DCS ne la donne pas (environ 65 km/h)
local SPEED_MIN     = 5     -- m/s : vitesse nominale minimale acceptée (en dessous, elle est corrigée)
local SPEED_MAX     = 30    -- m/s : vitesse nominale maximale acceptée (au dessus, elle est corrigée)
local MAX_CONVOYS   = 20    -- nombre maximum de convois traités (protection contre une table aberrante)
local MAX_VEHICLES  = 40    -- nombre maximum de véhicules par convoi
local MAX_ROUTE     = 100   -- nombre maximum de points de route lus par convoi
local CHECK_DELAY   = 60    -- s : délai avant le contrôle "le convoi roule-t-il ?" (écrit seulement dans dcs.log)
local RETRY_STEP    = 2     -- s : si campL n'existe pas encore, on réessaie toutes les RETRY_STEP secondes...
local MAX_TRIES     = 4     -- ...pendant MAX_TRIES essais au total

local TAG = "DCE_Convoys: "

local function log(msg)
	if env and env.info then
		pcall(env.info, TAG .. tostring(msg))
	end
end

-------------------------------------------------------------------------------------------------------
-- Petits outils
-------------------------------------------------------------------------------------------------------

-- distance entre deux points (x, y)
local function dist(x1, y1, x2, y2)
	local dx = x2 - x1
	local dy = y2 - y1
	return math.sqrt(dx * dx + dy * dy)
end

-- distance arrondie en mètres, pour les logs (jamais d'erreur, même si la valeur est nil)
local function meters(d)
	return math.floor(tonumber(d) or 0)
end

-- vrai nombre raisonnable : ni nil, ni NaN, ni infini, ni valeur délirante
local function isNum(v)
	return type(v) == "number" and v == v and v > -1e8 and v < 1e8
end

local function isPoint(p)
	return type(p) == "table" and isNum(p.x) and isNum(p.y)
end

-- Route la plus proche de (x, y).
-- ATTENTION : land.getClosestPointOnRoads renvoie DEUX nombres (x, y), pas une table.
-- Renvoie x, y, distance au point de départ ; ou nil si DCS ne trouve rien de valable.
local function snapToRoad(x, y)
	if not (land and land.getClosestPointOnRoads) then
		return nil
	end
	local ok, rx, ry = pcall(land.getClosestPointOnRoads, "roads", x, y)
	if not ok or not isNum(rx) or not isNum(ry) then
		return nil
	end
	return rx, ry, dist(x, y, rx, ry)
end

-- Ce que DCS sait d'un type de véhicule : { known = existe pour DCS, speed = vitesse max en m/s ou false }
local typeCache = {}

local function getTypeInfo(typeName)
	local info = typeCache[typeName]
	if info == nil then
		info = { known = false, speed = false }
		if Unit and Unit.getDescByName then
			local ok, desc = pcall(Unit.getDescByName, typeName)
			if ok and type(desc) == "table" then
				info.known = true
				if isNum(desc.speedMax) and desc.speedMax > 0 then
					info.speed = desc.speedMax
				end
			end
		end
		typeCache[typeName] = info
	end
	return info
end

-- true si le point (x, y) est dans l'eau (mer, lac, eau peu profonde). false si terre ou si on ne sait pas.
local function isWater(x, y)
	if not (land and land.getSurfaceType and land.SurfaceType) then
		return false
	end
	local ok, surface = pcall(land.getSurfaceType, { x = x, y = y })
	if not ok or type(surface) ~= "number" then
		return false
	end
	return surface == land.SurfaceType.WATER or surface == land.SurfaceType.SHALLOW_WATER
end

-- Un waypoint de route pour un groupe terrestre.
-- action = "On Road" ou "Off Road" (comment le groupe rejoint ce point)
local function makeWaypoint(x, y, action, speed)
	return {
		["x"] = x,
		["y"] = y,
		["alt"] = 0,
		["alt_type"] = "BARO",
		["type"] = "Turning Point",
		["action"] = action,
		["speed"] = speed,
		["speed_locked"] = true,
		["ETA"] = 0,
		["ETA_locked"] = false,
		["formation_template"] = "",
		["name"] = "",
		["task"] = {
			["id"] = "ComboTask",
			["params"] = {
				["tasks"] = {},
			},
		},
	}
end

-------------------------------------------------------------------------------------------------------
-- Calcul du plan d'un convoi (aucun appel qui crée quoi que ce soit dans le jeu)
-------------------------------------------------------------------------------------------------------
local function buildPlan(convoy)

	-- 1. contrôles de base : si une donnée manque, on abandonne ce convoi proprement
	if type(convoy) ~= "table" then
		return nil, "entrée invalide"
	end
	if type(convoy.name) ~= "string" or convoy.name == "" then
		return nil, "pas de name"
	end
	if not isNum(convoy.countryId) or convoy.countryId < 0 or convoy.countryId ~= math.floor(convoy.countryId) then
		return nil, "countryId invalide"
	end
	if not isPoint(convoy.from) or not isPoint(convoy.to) then
		return nil, "from ou to invalide"
	end

	local vehicles = {}
	if type(convoy.vehicles) == "table" then
		for i = 1, table.maxn(convoy.vehicles) do
			if type(convoy.vehicles[i]) == "string" and convoy.vehicles[i] ~= "" then
				if #vehicles < MAX_VEHICLES then
					table.insert(vehicles, convoy.vehicles[i])
				else
					log(convoy.name .. " ATTENTION : plus de " .. MAX_VEHICLES .. " véhicules, les suivants sont ignorés")
					break
				end
			end
		end
	end
	if #vehicles == 0 then
		return nil, "aucun véhicule"
	end

	local from = convoy.from
	local to = convoy.to
	local route = {}
	local routeCount = 0
	if type(convoy.route) == "table" then
		route = convoy.route
		routeCount = table.maxn(route)
		if routeCount > MAX_ROUTE then
			log(convoy.name .. " ATTENTION : " .. routeCount .. " points de route, seuls les " .. MAX_ROUTE .. " premiers sont lus")
			routeCount = MAX_ROUTE
		end
	end

	-- 2. types de véhicules : on demande à DCS si chaque type existe et quelle est sa vitesse max
	local infos = {}
	local apiWorks = false
	for i = 1, #vehicles do
		infos[i] = getTypeInfo(vehicles[i])
		if infos[i].known then
			apiWorks = true
		end
	end

	-- si DCS reconnaît au moins un type, un type qu'il ne reconnaît pas est une faute de nom : on l'écarte
	-- (si DCS ne reconnaît aucun type, on ne peut rien conclure : on garde tout)
	-- vitesse nominale = celle du véhicule le plus lent du convoi
	local checked = {}
	local nominal = nil
	for i = 1, #vehicles do
		local info = infos[i]
		if apiWorks and not info.known then
			log(convoy.name .. " véhicule " .. i .. " " .. vehicles[i] .. " : type inconnu de DCS, écarté")
		else
			table.insert(checked, vehicles[i])
			log(convoy.name .. " véhicule " .. i .. " " .. vehicles[i] .. " : vitesse max DCS = " .. tostring(info.speed))
			if info.speed and (not nominal or info.speed < nominal) then
				nominal = info.speed
			end
		end
	end
	vehicles = checked
	if #vehicles == 0 then
		return nil, "aucun véhicule de type connu"
	end

	if not nominal then
		nominal = SPEED_DEFAULT
		log(convoy.name .. " vitesse DCS introuvable, valeur par défaut " .. nominal .. " m/s")
	elseif nominal < SPEED_MIN or nominal > SPEED_MAX then
		log(convoy.name .. " ATTENTION : vitesse DCS " .. nominal .. " m/s hors de [" .. SPEED_MIN .. " ; " .. SPEED_MAX .. "], corrigée")
		if nominal < SPEED_MIN then
			nominal = SPEED_MIN
		else
			nominal = SPEED_MAX
		end
	end
	local speedRoad = nominal * SPEED_ROAD
	local speedOff = nominal * SPEED_OFFROAD

	-- 3. point de départ : sur la route la plus proche de "from"
	local start
	local startOnRoad = false
	local sx, sy, sd = snapToRoad(from.x, from.y)
	if sx and sd <= SNAP_MAX then
		start = { x = sx, y = sy }
		startOnRoad = true
		log(convoy.name .. " from recalé sur la route, éloignement " .. meters(sd) .. " m")
	else
		start = { x = from.x, y = from.y }
		log(convoy.name .. " ATTENTION : aucune route à moins de " .. SNAP_MAX .. " m de from, spawn sur from tel quel")
	end

	-- 4. points de route : on saute les doublons de from/to, on recale les autres
	local kept = {}
	local last = start
	for i = 1, routeCount do
		local p = route[i]
		local zone = "?"
		if type(p) == "table" and p.zone then
			zone = tostring(p.zone)
		end

		if not isPoint(p) then
			log(convoy.name .. " route[" .. i .. "] " .. zone .. " : point invalide, ignoré")
		elseif dist(p.x, p.y, from.x, from.y) < 1 then
			log(convoy.name .. " route[" .. i .. "] " .. zone .. " : doublon de from, ignoré")
		elseif dist(p.x, p.y, to.x, to.y) < 1 then
			log(convoy.name .. " route[" .. i .. "] " .. zone .. " : doublon de to, ignoré")
		else
			local rx, ry, rd = snapToRoad(p.x, p.y)
			if not rx then
				log(convoy.name .. " route[" .. i .. "] " .. zone .. " : aucune route trouvée, ignoré")
			elseif rd > SNAP_MAX then
				log(convoy.name .. " route[" .. i .. "] " .. zone .. " : route à " .. meters(rd) .. " m (> " .. SNAP_MAX .. "), ignoré")
			elseif dist(rx, ry, last.x, last.y) < MERGE_DIST then
				log(convoy.name .. " route[" .. i .. "] " .. zone .. " : route à " .. meters(rd) .. " m, fusionné avec le point précédent")
			else
				log(convoy.name .. " route[" .. i .. "] " .. zone .. " : route à " .. meters(rd) .. " m, gardé")
				last = { x = rx, y = ry }
				table.insert(kept, last)
			end
		end
	end

	-- aucune route nulle part (départ et points de route) : ce convoi ne peut pas rouler sur route.
	-- On l'abandonne plutôt que de lui faire traverser le terrain en hors-route.
	if not startOnRoad and #kept == 0 then
		return nil, "aucune route trouvée (ni au départ, ni sur les points de route)"
	end
	if isWater(start.x, start.y) then
		return nil, "point de départ dans l'eau"
	end

	-- pour information seulement : où est la destination par rapport à la route et à l'eau ?
	local tx, ty, td = snapToRoad(to.x, to.y)
	if tx then
		log(convoy.name .. " to (destination) à " .. meters(td) .. " m de la route la plus proche")
	else
		log(convoy.name .. " to (destination) : aucune route trouvée à proximité")
	end
	if isWater(to.x, to.y) then
		log(convoy.name .. " ATTENTION : to (destination) est dans l'eau, le convoi ne pourra pas l'atteindre")
	end

	-- 5. cap du convoi : vers le premier point gardé, sinon vers la destination
	local target = to
	if kept[1] then
		target = kept[1]
	end
	local heading = math.atan2(target.y - start.y, target.x - start.x)
	if heading < 0 then
		heading = heading + 2 * math.pi
	end

	-- 6. positions des véhicules : le 1er sur le point de départ, les suivants derrière lui,
	--    espacés de SPACING m, re-posés sur la route si DCS en trouve une juste à côté
	--    Chaque véhicule est placé par rapport au précédent : l'espacement reste donc toujours correct,
	--    même si la route s'arrête ou tourne juste derrière le point de départ.
	local positions = { { x = start.x, y = start.y } }
	local placed = { vehicles[1] }
	for k = 2, #vehicles do
		local prev = positions[#positions]
		local px = prev.x - math.cos(heading) * SPACING
		local py = prev.y - math.sin(heading) * SPACING
		local final = { x = px, y = py }
		local rx, ry, rd = snapToRoad(px, py)
		if rx and rd <= 60 then
			local dPrev = dist(rx, ry, prev.x, prev.y)
			-- on accepte le recalage seulement s'il garde l'espacement à peu près correct
			-- avec le véhicule précédent ET s'il ne retombe pas sur un véhicule déjà placé
			-- (cas d'une route qui s'arrête au point de départ : le recalage ramènerait tout le monde au même endroit)
			if dPrev >= SPACING * 0.5 and dPrev <= SPACING * 1.5 then
				local free = true
				for j = 1, #positions do
					if dist(rx, ry, positions[j].x, positions[j].y) < SPACING * 0.5 then
						free = false
						break
					end
				end
				if free then
					final = { x = rx, y = ry }
				end
			end
		end
		if isWater(final.x, final.y) then
			-- un véhicule posé dans l'eau serait perdu : on l'écarte, le convoi est simplement plus court
			log(convoy.name .. " véhicule " .. k .. " " .. vehicles[k] .. " : position dans l'eau, écarté")
		else
			table.insert(positions, final)
			table.insert(placed, vehicles[k])
		end
	end

	-- 7. waypoints : départ, points gardés (On Road), puis la destination (Off Road)
	local wps = {}
	table.insert(wps, makeWaypoint(start.x, start.y, "On Road", speedRoad))
	for i = 1, #kept do
		table.insert(wps, makeWaypoint(kept[i].x, kept[i].y, "On Road", speedRoad))
	end
	table.insert(wps, makeWaypoint(to.x, to.y, "Off Road", speedOff))

	log(convoy.name .. " plan : " .. #placed .. "/" .. #vehicles .. " véhicules, " .. #kept .. " points de route gardés sur " ..
		routeCount .. ", " .. #wps .. " waypoints, vitesse route " .. string.format("%.1f", speedRoad) ..
		" m/s, hors route " .. string.format("%.1f", speedOff) .. " m/s")

	return {
		name = convoy.name,
		countryId = convoy.countryId,
		vehicles = placed,
		start = start,
		heading = heading,
		positions = positions,
		wps = wps,
	}
end

-- Transforme le plan en table acceptée par coalition.addGroup
local function buildGroupData(plan)
	local units = {}
	for i = 1, #plan.vehicles do
		units[i] = {
			["type"] = plan.vehicles[i],
			["name"] = plan.name .. "_U" .. i,
			["x"] = plan.positions[i].x,
			["y"] = plan.positions[i].y,
			["heading"] = plan.heading,
			["skill"] = "Average",
			["playerCanDrive"] = false,
		}
	end

	return {
		["name"] = plan.name,
		["task"] = "Ground Nothing",
		["taskSelected"] = true,
		["tasks"] = {},
		["start_time"] = 0,
		["hidden"] = false,
		["uncontrollable"] = false,
		["x"] = plan.start.x,
		["y"] = plan.start.y,
		["units"] = units,
		["route"] = {
			["points"] = plan.wps,
		},
	}
end

-- Fichier de debug (seulement si campL.debug), même principe que les autres scripts DCE
local function dumpGroupData(name, groupData)
	if not (campL and campL.debug and PathDCE and TableSerialization and io and io.open) then
		return
	end
	local ok, err = pcall(function()
		local clean = tostring(name):gsub("[%p%c%s]", "_")
		local f = io.open(PathDCE .. "Debug\\" .. clean .. "_convoy_plan.lua", "w")
		if f then
			f:write("groupData = " .. TableSerialization(groupData, 0))
			f:close()
		else
			log("debug : impossible d'ouvrir le fichier pour " .. tostring(name))
		end
	end)
	if not ok then
		log("debug : erreur d'écriture " .. tostring(err))
	end
end

-------------------------------------------------------------------------------------------------------
-- Contrôle après le spawn : écrit dans dcs.log si le convoi roule (ne modifie rien dans le jeu)
-------------------------------------------------------------------------------------------------------
local function checkMove(arg, time)
	local ok, err = pcall(function()
		local g = Group.getByName(arg.name)
		if not g then
			log(arg.name .. " contrôle : le groupe n'existe plus (détruit ?)")
			return
		end
		local u = g:getUnit(1)
		if not (u and u:isExist()) then
			log(arg.name .. " contrôle : le premier véhicule n'existe plus")
			return
		end
		local p = u:getPoint()
		local d = dist(p.x, p.z, arg.x, arg.y)
		if d < 50 then
			log(arg.name .. " contrôle ATTENTION : le convoi n'a presque pas bougé en " .. CHECK_DELAY .. " s (" .. meters(d) .. " m)")
		else
			log(arg.name .. " contrôle OK : le convoi roule (" .. meters(d) .. " m parcourus en " .. CHECK_DELAY .. " s)")
		end
	end)
	if not ok then
		log("ERREUR contrôle " .. tostring(arg and arg.name) .. " : " .. tostring(err))
	end
	return nil
end

-------------------------------------------------------------------------------------------------------
-- Traitement d'un convoi (appelé par le timer)
-------------------------------------------------------------------------------------------------------
local function processConvoy(arg)
	local convoy = arg.convoy
	local label = "convoi n°" .. tostring(arg.n)
	if type(convoy) == "table" and convoy.name then
		label = label .. " " .. tostring(convoy.name)
	end
	log(label .. " : calcul du plan")

	local plan, err = buildPlan(convoy)
	if not plan then
		log(label .. " ABANDON : " .. tostring(err))
		return
	end

	local groupData = buildGroupData(plan)
	dumpGroupData(plan.name, groupData)

	-- un groupe de ce nom existe déjà : on ne crée rien
	if Group.getByName(plan.name) then
		log(label .. " : un groupe de ce nom existe déjà, spawn ignoré")
		return
	end
	for i = 1, #plan.vehicles do
		if Unit.getByName(plan.name .. "_U" .. i) then
			log(label .. " : l'unité " .. plan.name .. "_U" .. i .. " existe déjà, spawn ignoré")
			return
		end
	end

	if not SPAWN_ACTIVE then
		log(label .. " : mode essai, aucun groupe créé (SPAWN_ACTIVE = false)")
		return
	end

	local ok, res = pcall(coalition.addGroup, plan.countryId, Group.Category.GROUND, groupData)
	if not ok then
		log(label .. " ÉCHEC addGroup : " .. tostring(res))
		return
	end

	local created = Group.getByName(plan.name)
	if not (res or created) then
		log(label .. " ÉCHEC : addGroup n'a rien créé (countryId " .. tostring(plan.countryId) .. " absent du .miz ?)")
		return
	end

	local size = "?"
	if created then
		local okSize, n = pcall(function() return created:getSize() end)
		if okSize and n then
			size = tostring(n)
		end
	end
	log(label .. " : groupe créé (" .. size .. "/" .. #plan.vehicles .. " véhicules)")

	-- contrôle de mouvement dans CHECK_DELAY secondes (log seulement)
	local okSched, errSched = pcall(function()
		timer.scheduleFunction(checkMove, { name = plan.name, x = plan.start.x, y = plan.start.y }, timer.getTime() + CHECK_DELAY)
	end)
	if not okSched then
		log(label .. " : contrôle de mouvement non planifié : " .. tostring(errSched))
	end
end

-- Fonction appelée par le timer : un convoi qui plante ne doit jamais gêner les autres
local function runConvoy(arg, time)
	local ok, err = pcall(processConvoy, arg)
	if not ok then
		log("ERREUR convoi n°" .. tostring(arg and arg.n) .. " : " .. tostring(err))
	end
	return nil -- ne pas se replanifier
end

-------------------------------------------------------------------------------------------------------
-- Démarrage
-------------------------------------------------------------------------------------------------------

-- Lit campL et planifie un timer par convoi.
-- Renvoie "wait" si campL n'existe pas encore (on réessaiera), nil dans tous les autres cas.
local function planAll(t0)
	local okRead, camp = pcall(function() return campL end)
	if not okRead or type(camp) ~= "table" then
		return "wait"
	end

	local convoys = camp.wargame_convoys
	if type(convoys) ~= "table" then
		log("pas de campL.wargame_convoys : la campagne ne gère pas les convois dynamiques, rien à faire")
		return nil
	end

	local last = table.maxn(convoys)
	if last == 0 then
		log("campL.wargame_convoys est vide, rien à faire")
		return nil
	end
	if last > MAX_CONVOYS then
		log("ATTENTION : " .. last .. " convois, seuls les " .. MAX_CONVOYS .. " premiers sont traités")
		last = MAX_CONVOYS
	end

	local count = 0
	for n = 1, last do
		local convoy = convoys[n]
		if type(convoy) ~= "table" then
			log("convoi n°" .. n .. " : entrée invalide, ignorée")
		else
			-- heure de spawn : t0 + 5 s, 6 s, 7 s... (jamais dans le passé)
			local when = t0 + DELAY_FIRST + (n - 1) * DELAY_STEP
			local okSched, errSched = pcall(function()
				local minWhen = timer.getTime() + 0.1
				if when < minWhen then
					when = minWhen
				end
				timer.scheduleFunction(runConvoy, { n = n, convoy = convoy }, when)
			end)
			if okSched then
				count = count + 1
			else
				log("convoi n°" .. n .. " : planification impossible : " .. tostring(errSched))
			end
		end
	end

	local mode = "mode essai (logs seulement)"
	if SPAWN_ACTIVE then
		mode = "spawn actif"
	end
	log(count .. " convoi(s) planifié(s), " .. mode)
	return nil
end

-- Appelée par un timer peu avant le premier spawn : campL est lu à ce moment-là seulement.
local function launch(arg, time)
	arg.tries = arg.tries + 1
	local ok, result = pcall(planAll, arg.t0)
	if not ok then
		log("ERREUR au démarrage : " .. tostring(result))
		return nil
	end
	if result == "wait" then
		if arg.tries < MAX_TRIES then
			log("campL pas encore disponible, nouvel essai dans " .. RETRY_STEP .. " s (essai " .. arg.tries .. "/" .. MAX_TRIES .. ")")
			return time + RETRY_STEP
		end
		log("campL introuvable après " .. MAX_TRIES .. " essais : la campagne ne gère pas les convois dynamiques, rien à faire")
	end
	return nil
end

local function init()
	local t0 = timer.getTime()
	-- on lit campL 1 s avant le premier spawn (au plus tôt 0,5 s après le chargement)
	local launchDelay = DELAY_FIRST - 1
	if launchDelay < 0.5 then
		launchDelay = 0.5
	end
	timer.scheduleFunction(launch, { t0 = t0, tries = 0 }, t0 + launchDelay)
	log("chargé, lecture de campL dans " .. launchDelay .. " s")
end

local ok, err = pcall(init)
if not ok then
	log("ERREUR au chargement : " .. tostring(err))
end
