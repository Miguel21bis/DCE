-- DCE_Airlift.lua : logistique aerienne wargame, cote mission (DCS)
-- Donnees : campL.wargame_airlift (flights, zones, cargos, payload) ecrites par MAIN_NextMission.lua
-- IA : stationnaire (Orbit vitesse 1) au point Load puis au point Drop, validation vivant + vitesse faible
--      a moins de radius du point pendant holdS secondes.
-- Joueur : menu F10 "Airlift" (construit une fois par unite, jamais modifie ensuite) : charger (pose dans la zone Load),
--          decharger (pose dans la zone Drop), etat du chargement, marquer les zones (fumigene de jour / fusee de nuit).
--          Marquage auto : zone Load a l'approche (une fois par vie), zone Drop a 4 km puis rallumage a 500 m.
--          Les charges elinguees (static cargo) sont creditees quand elles restent holdS secondes dans la zone Drop.
-- Sortie : wargame_airlift_deliveries.lua (dans PathDCE), lu par DEBRIEF_Master.lua
-- Tous les messages du journal DCS commencent par "DCE_Airlift:".

if AirliftMod and AirliftMod.started then return end

AirliftMod = { started = true, deliveries = {}, ai = {}, cargos = {}, onboard = {}, slots = {}, markId = 7300,
	menus = {}, grp = {}, want = {}, ignored = {}, busy = {}, op = {}, opN = 0, nextScan = 0,
	mk = {}, hint = {}, near = {}, nextSmoke = 0 }
local M = AirliftMod

local PERIOD   = 2		--s, pas du detecteur
local APPROACH = 600	--m, distance a laquelle l'IA est mise en stationnaire
local ABORT_S  = 240	--s, abandon du stationnaire IA si la validation n'arrive pas
local LOAD_S   = 10		--s, delai de chargement joueur
local LANDED_AGL, LANDED_V = 3, 2		--joueur : "pose"
local HOVER_V = 6		--IA : vitesse max consideree comme stationnaire
local BUSY_MAX = 90		--s, une operation joueur plus vieille que ca ne bloque plus les clics
local BUILD_DELAY = 3	--s, delai entre la naissance du joueur et la creation de son menu F10 (et entre deux essais)
local SCAN_S = 6		--s, periode du balayage de securite des joueurs
local REBUILD_ON_BIRTH = false	--true : a chaque respawn, le sous-menu de l'unite est supprime puis recree (a n'activer que si le menu disparait apres un respawn)
local SMOKE_S = 300		--s, duree d'un fumigene (jour)
local LIGHT_S = 60		--s, duree supposee d'une fusee (nuit) : au dela, la zone est consideree eteinte
local SMOKE_CHECK = 4	--s, periode de controle des marquages
local LOAD_NEAR = 3000	--m, zone de chargement : marquage (une fois par vie) quand le joueur s'approche a moins de ca
local DROP_FAR, DROP_NEAR = 4000, 500	--m, zone de depose : marquage a 4 km, rallumage a 500 m si eteint
local NIGHT_FROM, NIGHT_TO = 20.5 * 3600, 5.5 * 3600	--s depuis minuit (heure de la mission) : de nuit, fusees au lieu de fumigenes
local EV_BIRTH = (world and world.event and world.event.S_EVENT_BIRTH) or 15
local EV_ENTER = (world and world.event and world.event.S_EVENT_PLAYER_ENTER_UNIT) or 20

local function log(m) env.info("DCE_Airlift: "..tostring(m)) end

local function dist2(a, b)
	local dx, dy = a.x - b.x, a.y - b.y
	return math.sqrt(dx * dx + dy * dy)
end

local function sideId(side) if side == "red" then return 1 end return 2 end

local function ser(v, ind)
	ind = ind or ""
	if type(v) == "table" then
		local keys = {}
		for k in pairs(v) do keys[#keys + 1] = k end
		table.sort(keys, function(a, b) return tostring(a) < tostring(b) end)
		local out = { "{\n" }
		for _, k in ipairs(keys) do
			local ks = (type(k) == "string") and string.format("%q", k) or tostring(k)
			out[#out + 1] = ind.."\t["..ks.."] = "..ser(v[k], ind.."\t")..",\n"
		end
		out[#out + 1] = ind.."}"
		return table.concat(out)
	elseif type(v) == "string" then
		return string.format("%q", v)
	end
	return tostring(v)
end

local function writeResult()
	if not (PathDCE and io and io.open) then
		log("ecriture impossible (PathDCE ou io absent)")
		return
	end
	local air = {}
	for _, s in ipairs(M.slots) do air[s] = 0 end
	for _, d in ipairs(M.deliveries) do air[d.slot] = (air[d.slot] or 0) + d.kg end
	local f = io.open(PathDCE.."wargame_airlift_deliveries.lua", "w")
	if not f then
		log("ecriture impossible : "..PathDCE.."wargame_airlift_deliveries.lua")
		return
	end
	f:write("wargame_airlift_deliveries = "..ser({ mission = campL and campL.mission, deliveries = M.deliveries, air = air }).."\n")
	f:close()
end

local function say(side, txt, t)
	pcall(function() trigger.action.outTextForCoalition(sideId(side), txt, t or 15) end)
end

local function addDelivery(slot, side, kg, by, group)
	kg = math.floor(kg + 0.5)
	table.insert(M.deliveries, { slot = slot, side = side, kg = kg, by = by, group = group, t = math.floor(timer.getTime()) })
	log("LIVRAISON slot="..slot.." kg="..kg.." par="..tostring(by).." groupe="..tostring(group))
	writeResult()
	say(side, "Airlift "..slot..": "..kg.." kg livres ("..tostring(by)..")")
end

-------------------------------------------------------------------------------------------
-- IA : retrouver les groupes dans env.mission par les coordonnees des waypoints Load / Drop
-------------------------------------------------------------------------------------------
local function dictName(n)
	if type(n) == "string" and env.getValueDictByKey and string.find(n, "^DictKey_") then
		return env.getValueDictByKey(n)
	end
	return n
end

local function scanMission(cfg)
	local m = env.mission
	if not m or not m.coalition then log("env.mission absent : IA non suivie") return end

	for _, coal in pairs(m.coalition) do
		for _, ctry in pairs(coal.country or {}) do
			local h = ctry.helicopter
			if h and h.group then
				for _, g in pairs(h.group) do
					local pts = g.route and g.route.points
					local isAI = true
					for _, u in pairs(g.units or {}) do
						if u.skill == "Client" or u.skill == "Player" then isAI = false end
					end
					if pts and isAI then
						for _, f in ipairs(cfg.flights) do
							local seq = {}
							for i, w in ipairs(pts) do
								if w.x and w.y then
									if dist2(w, f.load) <= 5 then seq[#seq + 1] = { kind = "load", idx = i } end
									if dist2(w, f.drop) <= 5 then seq[#seq + 1] = { kind = "drop", idx = i } end
								end
							end
							local nL, nD = 0, 0
							for _, s in ipairs(seq) do
								if s.kind == "load" then nL = nL + 1 else nD = nD + 1 end
							end
							if nL >= 1 and nD >= 1 then		--un vol d'une autre cible qui partage seulement le point Load n'est pas retenu
								local st = { name = dictName(g.name), pts = pts, seq = seq, f = f, pos = 1, phase = "route" }
								f.nGroups = (f.nGroups or 0) + 1
								table.insert(M.ai, st)
								log("IA suivie: "..tostring(st.name).." slot="..f.slot.." etapes="..#seq)
							end
						end
					end
				end
			end
		end
	end
	if #M.ai == 0 and #cfg.flights > 0 then
		log("ATTENTION : "..#cfg.flights.." vol(s) attendu(s) mais aucun groupe IA trouve par coordonnees")
	end
end

local function holdHere(st, u, pt)
	pcall(function()
		local ctrl = Group.getByName(st.name):getController()
		local alt = land.getHeight({ x = pt.x, y = pt.y }) + 15
		ctrl:setTask({ id = "Orbit", params = { pattern = "Circle", point = { x = pt.x, y = pt.y }, speed = 1, altitude = alt } })
	end)
end

local function resume(st, step, u)
	local ok, err = pcall(function()
		local ctrl = Group.getByName(st.name):getController()
		local p = u:getPoint()
		local newPts = { { x = p.x, y = p.z, alt = p.y, alt_type = "BARO", type = "Turning Point", action = "Turning Point",
			speed = 40, ETA = 0, ETA_locked = false, speed_locked = true, task = { id = "ComboTask", params = { tasks = {} } } } }
		for i = step.idx + 1, #st.pts do newPts[#newPts + 1] = st.pts[i] end
		if #newPts > 1 then
			ctrl:setTask({ id = "Mission", params = { airborne = true, route = { points = newPts } } })
		end
	end)
	if not ok then log("ERREUR reprise de route "..tostring(st.name)..": "..tostring(err)) end
end

local function tickAI(cfg, st, now)
	local grp = Group.getByName(st.name)
	if not grp or not grp:isExist() or st.done then return end
	local u = grp:getUnit(1)
	if not u or not u:isExist() then return end

	local step = st.seq[st.pos]
	if not step then st.done = true return end

	local target = (step.kind == "load") and st.f.load or st.f.drop
	local p = u:getPoint()
	local d = dist2({ x = p.x, y = p.z }, target)
	local v = u:getVelocity()
	local sp = math.sqrt(v.x * v.x + v.z * v.z)

	if st.phase == "route" then
		if d <= APPROACH then
			st.phase, st.hoverT0, st.inT, st.validated = "hover", now, nil, false
			holdHere(st, u, target)
			log("STATIONNAIRE "..step.kind.." "..st.name.." d="..math.floor(d).." m")
		end
	else
		if d <= cfg.radius and sp <= HOVER_V then
			st.inT = st.inT or now
		else
			st.inT = nil
		end

		if st.inT and not st.validated and now - st.inT >= cfg.holdS then
			st.validated = true
			log("VALIDE "..step.kind.." "..st.name.." slot="..st.f.slot)
			if step.kind == "load" then
				st.loaded = true
			elseif st.loaded then
				st.loaded = false
				--kgPlanned est le total prevu pour la cible : partage entre les groupes IA qui la servent (pas de sur-credit)
				addDelivery(st.f.slot, st.f.side, st.f.kgPlanned / (math.max(st.f.N, 1) * math.max(st.f.nGroups or 1, 1)), "AI", st.name)
			end
		end

		local timeout = (now - st.hoverT0) >= ABORT_S
		if (st.inT and now - st.inT >= cfg.aiHoverS) or timeout then
			if timeout and not st.validated then log("ABANDON stationnaire "..step.kind.." "..st.name.." (delai)") end
			st.pos = st.pos + 1
			st.phase = "route"
			resume(st, step, u)
		end
	end
end

-------------------------------------------------------------------------------------------
-- Charges au sol (static cargo) et zones
-------------------------------------------------------------------------------------------
local function spawnCargos(cfg)
	for _, c in ipairs(cfg.cargos or {}) do
		local cid = (c.side == "red") and country.id.RUSSIA or country.id.USA
		local ok, err = pcall(coalition.addStaticObject, cid, {
			category = "Cargos", type = c.typeName or "ammo_cargo", name = c.name, mass = c.kg, canCargo = true,
			x = c.x, y = c.y, heading = c.heading or 0,
		})
		if ok then
			table.insert(M.cargos, { name = c.name, slot = c.slot, side = c.side, kg = c.kg, x = c.x, y = c.y })
			log("charge "..c.name.." "..c.kg.." kg posee")
		else
			log("ERREUR charge "..tostring(c.name)..": "..tostring(err))
		end
	end
end

local function drawZones(cfg)
	for _, z in ipairs(cfg.zones or {}) do
		pcall(function()
			M.markId = M.markId + 1
			local col = (z.kind == "load") and { 0, 0.6, 1, 0.8 } or { 1, 0.5, 0, 0.8 }
			local fill = { col[1], col[2], col[3], 0.12 }
			trigger.action.circleToAll(sideId(z.side), M.markId, { x = z.x, y = land.getHeight({ x = z.x, y = z.y }), z = z.y }, z.radius, col, fill, 1, true)
			M.markId = M.markId + 1
			trigger.action.textToAll(sideId(z.side), M.markId, { x = z.x, y = land.getHeight({ x = z.x, y = z.y }), z = z.y + z.radius },
				col, { 0, 0, 0, 0 }, 14, true, string.upper(z.kind).." "..z.slot)
		end)
	end
end

-- charges elinguees : creditees si elles restent holdS secondes immobiles dans une zone Drop du meme slot
local function tickCargos(cfg, now)
	for _, c in ipairs(M.cargos) do
		if not c.taken and not c.delivered then
			local so = StaticObject.getByName(c.name)
			if so and so:isExist() then
				local p = so:getPoint()
				local pos = { x = p.x, y = p.z }
				local moved = dist2(pos, c)
				local still = c.last and dist2(pos, c.last) < 1
				c.last = pos
				local zone
				for _, z in ipairs(cfg.zones) do
					if z.kind == "drop" and z.side == c.side and dist2(pos, z) <= z.radius then zone = z end
				end
				if zone and moved > 50 and still then
					c.inT = c.inT or now
					if now - c.inT >= cfg.holdS then
						c.delivered = true
						pcall(function() so:destroy() end)
						addDelivery(zone.slot, c.side, c.kg, "sling", c.name)
					end
				else
					c.inT = nil
				end
			elseif c.last then
				c.taken = true		--detruite en vol : perdue
				log("charge perdue: "..c.name)
			end
		end
	end
end

-------------------------------------------------------------------------------------------
-- Joueur : menu F10
-- Regles (sources : wiki Hoggit, forums ED, issue VEAF/CTLD #257 d'octobre 2026) :
--  1. Le menu est construit UNE FOIS par unite, puis ne change plus : aucun removeItem pendant
--     la mission. DCS recycle l'id d'une entree supprimee pour la prochaine entree creee : un
--     joueur dont l'ecran F10 est reste ouvert declenche alors la mauvaise commande.
--  2. Une seule fonction de rappel (onCommand), protegee par pcall. Elle ne recoit que des chaines
--     (nom d'unite + action) et relit tout l'etat au moment du clic : une commande declenchee a
--     tort ne peut rien faire hors de son contexte (zone, pose, charge a bord).
--  3. Construction retardee apres S_EVENT_BIRTH (S_EVENT_PLAYER_ENTER_UNIT n'est pas fiable en
--     multijoueur) + balayage de securite des joueurs toutes les 6 s (solo, evenement manque).
--  4. Dans un groupe de plusieurs unites, on ne sait pas qui a clique : un sous-menu par unite.
-------------------------------------------------------------------------------------------
local function unitState(u)
	local p = u:getPoint()
	local v = u:getVelocity()
	local sp = math.sqrt(v.x * v.x + v.z * v.z)
	local agl = p.y - land.getHeight({ x = p.x, y = p.z })
	return { x = p.x, y = p.z }, sp, agl
end

local function nearestZone(cfg, kind, side, pos)
	for _, z in ipairs(cfg.zones or {}) do
		if z.kind == kind and z.side == side and dist2(pos, z) <= z.radius then return z end
	end
end

local function sideOf(u)
	if u:getCoalition() == 1 then return "red" end
	return "blue"
end

--message au groupe du joueur (et pas a toute la coalition)
local function sayUnit(u, txt, t)
	pcall(function()
		local g = u:getGroup()
		if g then trigger.action.outTextForGroup(g:getID(), txt, t or 10) end
	end)
end

-- une operation (chargement / dechargement) a la fois par unite ; un respawn l'annule
local function beginOp(name)
	M.opN = M.opN + 1
	M.op[name] = M.opN
	M.busy[name] = timer.getTime()
	return M.opN
end

local function endOp(name, id)
	if M.op[name] == id then
		M.op[name] = nil
		M.busy[name] = nil
	end
end

local function clearPrefix(t, name)
	local pre = name.."|"
	for k in pairs(t) do
		if string.sub(k, 1, #pre) == pre then t[k] = nil end
	end
end

local function resetUnit(name)
	clearPrefix(M.hint, name)
	clearPrefix(M.near, name)
	M.onboard[name] = nil
	M.op[name] = nil
	M.busy[name] = nil
end

local function finishLoad(cfg, name, id, z, all)
	if M.op[name] ~= id then return end
	local u = Unit.getByName(name)
	if not u or not u:isExist() then return end
	local pos, sp, agl = unitState(u)
	if agl > LANDED_AGL or sp > LANDED_V or dist2(pos, z) > z.radius then
		sayUnit(u, "Airlift: chargement interrompu.", 8)
		return
	end
	local side = sideOf(u)
	local cap = (cfg.payload and cfg.payload[u:getTypeName()]) or 1000
	local ob = M.onboard[name]
	if not ob then
		ob = { kg = 0, items = {} }
		M.onboard[name] = ob
	end

	--on lit la position reelle de la caisse (elle a pu etre deplacee), pas celle de sa creation
	local cands = {}
	for _, c in ipairs(M.cargos) do
		if not c.taken and not c.delivered and c.side == side then
			local so = StaticObject.getByName(c.name)
			if so and so:isExist() then
				local p = so:getPoint()
				if dist2({ x = p.x, y = p.z }, z) <= z.radius then cands[#cands + 1] = { c = c, so = so } end
			end
		end
	end
	table.sort(cands, function(a, b) return a.c.kg > b.c.kg end)

	local n = 0
	for _, e in ipairs(cands) do
		if ob.kg + e.c.kg <= cap and (all or n == 0) then
			pcall(function() e.so:destroy() end)
			e.c.taken = true
			ob.kg = ob.kg + e.c.kg
			table.insert(ob.items, e.c)
			n = n + 1
		end
	end
	if n == 0 then
		sayUnit(u, "Airlift: rien a charger (aucune charge ne rentre ou zone vide). Capacite "..cap.." kg.", 10)
	else
		log("CHARGE joueur="..tostring(u:getPlayerName()).." caisses="..n.." total="..ob.kg.." kg")
		sayUnit(u, "Airlift: "..n.." charge(s) a bord, total "..ob.kg.." kg (capacite "..cap.." kg).", 12)
	end
end

local function finishUnload(cfg, name, id, z)
	if M.op[name] ~= id then return end
	local u = Unit.getByName(name)
	if not u or not u:isExist() then return end
	local pos, sp, agl = unitState(u)
	if agl > LANDED_AGL or sp > LANDED_V or dist2(pos, z) > z.radius then
		sayUnit(u, "Airlift: dechargement interrompu.", 8)
		return
	end
	local ob = M.onboard[name]
	if not ob or ob.kg <= 0 then return end
	--tout ce qui est a bord est credite au point de ravitaillement de cette zone de depose
	local kg = ob.kg
	for _, c in ipairs(ob.items) do c.delivered = true end
	M.onboard[name] = nil
	addDelivery(z.slot, sideOf(u), kg, tostring(u:getPlayerName() or name), name)
end

local function startOp(cfg, u, kind, all)
	local name = u:getName()
	local side = sideOf(u)
	local pos, sp, agl = unitState(u)
	local z, delay
	if kind == "load" then
		z = nearestZone(cfg, "load", side, pos)
		if not z then sayUnit(u, "Airlift: vous n'etes pas dans une zone de chargement.", 8) return end
		delay = LOAD_S
	else
		local ob = M.onboard[name]
		if not ob or ob.kg <= 0 then sayUnit(u, "Airlift: rien a bord.", 8) return end
		z = nearestZone(cfg, "drop", side, pos)
		if not z then sayUnit(u, "Airlift: vous n'etes pas dans une zone de depose.", 8) return end
		delay = cfg.holdS or 30
	end
	if agl > LANDED_AGL or sp > LANDED_V then
		sayUnit(u, "Airlift: posez-vous pour "..((kind == "load") and "charger." or "decharger."), 8)
		return
	end
	local id = beginOp(name)
	sayUnit(u, "Airlift: "..((kind == "load") and "chargement" or "dechargement").." en cours, ne decollez pas ("..delay.." s).", delay)
	timer.scheduleFunction(function()
		local ok, err
		if kind == "load" then
			ok, err = pcall(finishLoad, cfg, name, id, z, all)
		else
			ok, err = pcall(finishUnload, cfg, name, id, z)
		end
		if not ok then log("ERREUR fin d'operation "..kind.." "..name..": "..tostring(err)) end
		endOp(name, id)
		return nil
	end, nil, timer.getTime() + delay)
end

local function cmdStatus(u)
	local ob = M.onboard[u:getName()]
	if not ob or ob.kg <= 0 then sayUnit(u, "Airlift: rien a bord.", 8) return end
	local t = {}
	for _, c in ipairs(ob.items) do t[#t + 1] = tostring(c.kg) end
	sayUnit(u, "Airlift a bord: "..ob.kg.." kg ["..table.concat(t, ", ").."]", 12)
end

-------------------------------------------------------------------------------------------
-- Marquage des zones : fumigenes de jour, fusees de nuit (vert = chargement, rouge = depose)
-- Automatique (approche) et sur demande (menu F10). Un marquage encore actif n'est jamais relance.
-------------------------------------------------------------------------------------------
local function isNight()
	local ok, t = pcall(timer.getAbsTime)
	if not ok or type(t) ~= "number" then return false end
	t = t % 86400
	return t >= NIGHT_FROM or t < NIGHT_TO
end

local function markActive(zi, now)
	local m = M.mk[zi]
	return m ~= nil and (now - m.t) < m.dur
end

-- chargement : 1 marqueur au centre ; depose : 3 marqueurs a 120 degres, a 80 % du rayon
local function launchMark(zi, z, now)
	local night = isNight()
	local col = (z.kind == "load") and 0 or 1		--0 = vert, 1 = rouge (memes valeurs pour smoke et signalFlare)
	local pts = {}
	if z.kind == "load" then
		pts[1] = { x = z.x, y = z.y }
	else
		local r = (z.radius or 100) * 0.8
		for k = 0, 2 do
			local a = math.rad(k * 120)
			pts[#pts + 1] = { x = z.x + r * math.cos(a), y = z.y + r * math.sin(a) }
		end
	end
	local anyOk = false
	for _, p in ipairs(pts) do
		local ok, err = pcall(function()
			local v3 = { x = p.x, y = land.getHeight({ x = p.x, y = p.y }), z = p.y }
			if night then trigger.action.signalFlare(v3, col, 0) else trigger.action.smoke(v3, col) end
		end)
		if ok then anyOk = true else log("ERREUR marquage de zone: "..tostring(err)) end
	end
	if anyOk then M.mk[zi] = { t = now, dur = night and LIGHT_S or SMOKE_S } end
	return anyOk, night
end

local function whereIs(pos, z)
	local d = dist2(pos, z)
	local brg = math.deg(math.atan2(z.y - pos.y, z.x - pos.x)) % 360
	return d, brg
end

local function hasCargoAt(z, side)
	for _, c in ipairs(M.cargos) do
		if not c.taken and not c.delivered and c.side == side and c.slot == z.slot then return true end
	end
	return false
end

-- lance le marquage si la zone n'est pas deja marquee, et previent le joueur
local function ensureMark(u, zi, z, pos, intro)
	local now = timer.getTime()
	local d, brg = whereIs(pos, z)
	local where = string.format("%s a %.1f km, cap %03d", intro, d / 1000, math.floor(brg + 0.5) % 360)
	if markActive(zi, now) then
		local m = M.mk[zi]
		sayUnit(u, "Airlift: "..where..". Marquage deja actif (encore "..math.floor(m.dur - (now - m.t)).." s).", 12)
		return
	end
	local ok, night = launchMark(zi, z, now)
	if not ok then
		sayUnit(u, "Airlift: "..where..". Marquage impossible.", 12)
		return
	end
	local color = (z.kind == "load") and "vert" or "rouge"
	local what
	if night then what = (z.kind == "load") and "fusee" or "3 fusees" else what = (z.kind == "load") and "fumigene" or "3 fumigenes" end
	sayUnit(u, "Airlift: "..where..". "..what.." "..color.." lance(s).", 12)
end

-- demande F10 : zone la plus proche du type voulu pour le camp du joueur
local function cmdMark(u, kind)
	local cfg = campL and campL.wargame_airlift
	local pos = unitState(u)
	local side = sideOf(u)
	local best, bestD
	for zi, z in ipairs(cfg and cfg.zones or {}) do
		if z.kind == kind and z.side == side then
			local d = dist2(pos, z)
			if not bestD or d < bestD then best, bestD = zi, d end
		end
	end
	if not best then
		sayUnit(u, "Airlift: aucune zone de "..((kind == "load") and "chargement" or "depose").." pour votre camp.", 8)
		return
	end
	ensureMark(u, best, cfg.zones[best], pos, (kind == "load") and "Zone de chargement" or "Zone de depose")
end

local function tickSmoke(cfg, now)
	if now < M.nextSmoke then return end
	M.nextSmoke = now + SMOKE_CHECK
	local zones = cfg.zones or {}
	if #zones == 0 then return end
	for name in pairs(M.menus) do
		local u = Unit.getByName(name)
		if u and u:isExist() and u:getPlayerName() then
			local pos = unitState(u)
			local side = sideOf(u)
			for zi, z in ipairs(zones) do
				if z.side == side then
					local d = dist2(pos, z)
					local k = name.."|"..zi
					if z.kind == "load" then
						--une seule fois par vie, des que le joueur est a moins de LOAD_NEAR (ou deja dans la zone a la naissance)
						if d <= LOAD_NEAR and not M.hint[k] and hasCargoAt(z, side) then
							M.hint[k] = true
							ensureMark(u, zi, z, pos, "Zone de chargement")
						end
					elseif z.kind == "drop" then
						if d > DROP_FAR + 500 then
							M.near[k] = nil		--parti loin : la prochaine approche redeclenchera
						elseif d <= DROP_FAR and not M.near[k] then
							M.near[k] = true
							ensureMark(u, zi, z, pos, "Zone de depose")
						end
						if d <= DROP_NEAR and not markActive(zi, now) then
							ensureMark(u, zi, z, pos, "Zone de depose")
						end
					end
				end
			end
		end
	end
end

local function handleCommand(arg)
	if type(arg) ~= "table" or type(arg.u) ~= "string" or type(arg.a) ~= "string" then return end
	local cfg = campL and campL.wargame_airlift
	if not cfg then return end
	local u = Unit.getByName(arg.u)
	if not u or not u:isExist() then return end
	if arg.a == "status" then
		cmdStatus(u)
		return
	end
	if arg.a == "mkload" then cmdMark(u, "load") return end
	if arg.a == "mkdrop" then cmdMark(u, "drop") return end
	if arg.a ~= "all" and arg.a ~= "one" and arg.a ~= "unload" then return end
	if not u:getPlayerName() then sayUnit(u, "Airlift: unite non pilotee par un joueur.", 8) return end
	local b = M.busy[arg.u]
	if b and timer.getTime() - b < BUSY_MAX then
		sayUnit(u, "Airlift: operation deja en cours.", 6)
		return
	end
	if arg.a == "unload" then
		startOp(cfg, u, "unload", false)
	else
		startOp(cfg, u, "load", arg.a == "all")
	end
end

--seule fonction donnee a missionCommands : rien ne remonte jusqu'a DCS
local function onCommand(arg)
	local ok, err = pcall(handleCommand, arg)
	if not ok then log("ERREUR commande F10: "..tostring(err)) end
end

-- construction du menu ; retourne "done", "skip" (rien a faire) ou "retry" (reessayer plus tard)
local function buildMenu(name)
	if M.menus[name] then return "done" end
	local u = Unit.getByName(name)
	if not u or not u:isExist() then return "retry" end
	if not u:getPlayerName() then return "retry" end
	local g = u:getGroup()
	if not g then return "retry" end
	if g:getCategory() ~= Group.Category.HELICOPTER then
		M.ignored[name] = true
		return "skip"
	end

	local gid = g:getID()
	local rec = M.grp[gid]
	if not rec then
		local size = 1
		local okS, s = pcall(function() return g:getInitialSize() end)
		if okS and type(s) == "number" then
			size = s
		else
			local us = g:getUnits()
			size = us and #us or 1
		end
		if size > 9 then log("ATTENTION groupe de "..size.." unites : limite de 10 entrees par menu F10") end
		rec = { single = (size <= 1) }
		M.grp[gid] = rec
	end

	--on reserve la place avant de creer, pour ne jamais creer deux fois les memes entrees
	local mine = { gid = gid }
	M.menus[name] = mine
	local ok, err = pcall(function()
		if not rec.root then rec.root = missionCommands.addSubMenuForGroup(gid, "Airlift") end
		local parent = rec.root
		if rec.single then
			mine.isRoot = true
		else
			local label = tostring(u:getCallsign() or name)
			parent = missionCommands.addSubMenuForGroup(gid, label, rec.root)
		end
		mine.path = parent
		missionCommands.addCommandForGroup(gid, "Charger au maximum", parent, onCommand, { u = name, a = "all" })
		missionCommands.addCommandForGroup(gid, "Charger 1 charge", parent, onCommand, { u = name, a = "one" })
		missionCommands.addCommandForGroup(gid, "Decharger", parent, onCommand, { u = name, a = "unload" })
		missionCommands.addCommandForGroup(gid, "Etat du chargement", parent, onCommand, { u = name, a = "status" })
		missionCommands.addCommandForGroup(gid, "Marquer zone de chargement", parent, onCommand, { u = name, a = "mkload" })
		missionCommands.addCommandForGroup(gid, "Marquer zone de depose", parent, onCommand, { u = name, a = "mkdrop" })
	end)
	if not ok then
		log("ERREUR construction menu "..name..": "..tostring(err))
		--le menu n'est pas encore affiche au joueur : on peut nettoyer sans risque de commande decalee
		if mine.path then pcall(missionCommands.removeItemForGroup, gid, mine.path) end
		if mine.isRoot then rec.root = nil end
		M.menus[name] = nil
		return "retry"
	end
	log("menu F10 cree pour "..name.." (groupe "..gid..(rec.single and ", unite seule)" or ", sous-menu par unite)"))
	return "done"
end

--uniquement a la naissance de l'unite (ecran F10 neuf) et seulement si REBUILD_ON_BIRTH est vrai
local function removeMenu(name)
	local mine = M.menus[name]
	if not mine then return end
	if mine.path then pcall(missionCommands.removeItemForGroup, mine.gid, mine.path) end
	if mine.isRoot and M.grp[mine.gid] then M.grp[mine.gid].root = nil end
	M.menus[name] = nil
end

local function wantMenu(name, now)
	M.want[name] = { tries = 0, due = now + BUILD_DELAY }
end

local function onWorldEvent(e)
	if type(e) ~= "table" then return end
	if e.id ~= EV_BIRTH and e.id ~= EV_ENTER then return end
	if not (campL and campL.wargame_airlift) then return end
	local u = e.initiator
	if not u or not u.getPlayerName or not u.getName then return end
	if not u:getPlayerName() then return end		--IA ou statique
	local name = u:getName()
	if M.ignored[name] then return end
	resetUnit(name)		--nouvelle vie : charge perdue, operation annulee
	if M.menus[name] and REBUILD_ON_BIRTH then removeMenu(name) end
	wantMenu(name, timer.getTime())
end

local function tickMenus(now)
	--1. constructions en attente
	for name, w in pairs(M.want) do
		if now >= w.due then
			local res = buildMenu(name)
			if res == "done" or res == "skip" then
				M.want[name] = nil
			else
				w.tries = w.tries + 1
				if w.tries >= 10 then
					log("abandon de la construction du menu pour "..name.." apres 10 essais")
					M.want[name] = nil
				else
					w.due = now + BUILD_DELAY
				end
			end
		end
	end
	--2. filet de securite : joueurs deja presents sans menu (solo, evenement manque)
	if now < M.nextScan then return end
	M.nextScan = now + SCAN_S
	for _, cid in ipairs({ 1, 2 }) do
		local ok, players = pcall(coalition.getPlayers, cid)
		if ok and type(players) == "table" then
			for _, u in ipairs(players) do
				local okN, name = pcall(function() return u:getName() end)
				if okN and name and not M.menus[name] and not M.want[name] and not M.ignored[name] then
					wantMenu(name, now)
				end
			end
		end
	end
end

-------------------------------------------------------------------------------------------
-- Demarrage
-------------------------------------------------------------------------------------------
local function tick(_, now)
	local cfg = campL and campL.wargame_airlift
	if cfg then
		for _, st in ipairs(M.ai) do
			local ok, err = pcall(tickAI, cfg, st, now)
			if not ok then log("ERREUR tickAI: "..tostring(err)) end
		end
		pcall(tickCargos, cfg, now)
		local okS, errS = pcall(tickSmoke, cfg, now)
		if not okS then log("ERREUR tickSmoke: "..tostring(errS)) end
		local okM, errM = pcall(tickMenus, now)
		if not okM then log("ERREUR tickMenus: "..tostring(errM)) end
	end
	return now + PERIOD
end

local function start(_, now)
	local cfg = campL and campL.wargame_airlift
	if not cfg then
		log("pas de campL.wargame_airlift : module inactif")
		return nil
	end
	for _, z in ipairs(cfg.zones or {}) do
		local known = false
		for _, s in ipairs(M.slots) do if s == z.slot then known = true end end
		if not known then M.slots[#M.slots + 1] = z.slot end
	end
	--zones : si scriptsMod les a ecrites dans le .miz (trigger zones), on les relit par leur nom (une seule source)
	for _, z in ipairs(cfg.zones or {}) do
		if z.zoneName then
			local ok, tz = pcall(trigger.misc.getZone, z.zoneName)
			if ok and tz and tz.point then
				z.x, z.y, z.radius = tz.point.x, tz.point.z, tz.radius
			else
				log("zone "..z.zoneName.." introuvable dans la mission : valeurs de campL conservees")
			end
		end
	end
	log("demarrage : vols="..#(cfg.flights or {}).." zones="..#(cfg.zones or {}).." charges="..#(cfg.cargos or {}))
	M.handler = { onEvent = function(self, e)
		local ok, err = pcall(onWorldEvent, e)
		if not ok then log("ERREUR evenement: "..tostring(err)) end
	end }
	local okH, errH = pcall(world.addEventHandler, M.handler)
	if not okH then log("ERREUR addEventHandler: "..tostring(errH)) end
	scanMission(cfg)
	spawnCargos(cfg)
	drawZones(cfg)
	writeResult()		--ecrase le fichier de la mission precedente
	timer.scheduleFunction(tick, nil, now + PERIOD)
	return nil
end

timer.scheduleFunction(start, nil, timer.getTime() + 6)
