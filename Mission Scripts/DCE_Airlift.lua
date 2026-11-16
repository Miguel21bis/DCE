-- DCE_Airlift.lua : logistique aerienne wargame, cote mission (DCS)
-- Donnees : campL.wargame_airlift (flights, zones, cargos, payload) ecrites par MAIN_NextMission.lua
-- IA : stationnaire (Orbit vitesse 1) au point Load puis au point Drop, validation vivant + vitesse faible
--      a moins de radius du point pendant holdS secondes.
-- Joueur : crochet et cargo interne natifs de DCS. Menu F10 "Airlift" (construit une fois par unite, jamais modifie ensuite) :
--          pour tous : marquer les zones (fumigene de jour / fusee de nuit) ;
--          en plus, pour les types listes dans simTypes : charger (pose dans la zone Load), decharger (pose dans la zone Drop), etat.
--          Marquage auto : zone Load a l'approche (une fois par vie), zone Drop a 4 km puis rallumage a 500 m.
--          Les charges elinguees (static cargo) sont creditees quand elles restent holdS secondes dans la zone Drop.
-- Sortie : chaque livraison est ajoutee a CustomLog (type "airlift delivery"), ecrit dans MissionEventsLog.lua a la fin de la mission par EventsTracker
-- Tous les messages du journal DCS commencent par "DCE_Airlift:".
--
-- LEGENDE DES LIGNES DE DIAGNOSTIC (chercher "CARGO-" dans dcs.log ; chaque ligne porte t = temps de mission en s)
--   CARGO-SPAWN    creation d'une caisse de la mission (type, kg demandes, position, relecture)
--   CARGO-SLING    vie d'une caisse posee par le script : mobile/immobile, zone DROP, chrono, credit ou cause de non-credit
--   CARGO-SIM      chargement/dechargement simule F10 (demande, refus et cause, charge, decharge, perte au respawn)
--   CARGO-MARK     fumigene/fusee de zone : declencheur (auto-approche, auto-500m, menu, naissance-silencieux), resultat
--   CARGO-EVT      evenement DCS recu (premiere occurrence de chaque id, evenements dont l'acteur est un statique/cargo, ids 47 et 48)
--   CARGO-PROCHE   Unit.getNearestCargos d'un helico joueur (a chaque changement de la liste)
--   CARGO-CREDIT   credit des caisses dynamiques (F8) : transportee, chrono en zone DROP, CREDITEE (kg) ou cause de remise a zero
--   CARGO-ZONE     decor (Object.Category.SCENERY) trouve dans chaque zone de depose au demarrage
--   CARGO-OBJ      observation par balayage : APPARU / ETAT / DISPARU / REAPPARU d'un objet cargo ou statique de type caisse
--   CARGO-ENTREPOT inventaire des entrepots (bases/FARP proches des zones) : etat initial puis differences
--   CARGO-OBS      limite de lignes atteinte
-- Aucune de ces lignes ne modifie la mission : observation seule, rien n'est credite par elles.

if AirliftMod and AirliftMod.started then return end

AirliftMod = { started = true, deliveries = {}, ai = {}, cargos = {}, onboard = {}, slots = {}, markId = 7300,
	menus = {}, grp = {}, want = {}, ignored = {}, busy = {}, op = {}, opN = 0, nextScan = 0,
	mk = {}, hint = {}, near = {}, nextSmoke = 0, nextWatch = 0, watch = {}, unknownEv = 0,
	born = {}, known = {}, obs = {}, scanN = 0, nextObs = 0, nextWh = 0, wh = {}, obsLines = 0, evSeen = {}, evLines = 0 }
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
local LOST_S = 60		--s, une charge introuvable depuis ce delai est consideree perdue (accrochee = parfois non interrogeable)
local SMOKE_CHECK = 4	--s, periode de controle des marquages
local LOAD_NEAR = 3000	--m, zone de chargement : marquage (une fois par vie) quand le joueur s'approche a moins de ca
local DROP_FAR, DROP_NEAR = 4000, 500	--m, zone de depose : marquage a 4 km, rallumage a 500 m si eteint
local NIGHT_FROM, NIGHT_TO = 20.5 * 3600, 5.5 * 3600	--s depuis minuit (heure de la mission) : de nuit, fusees au lieu de fumigenes
local OBS_S, OBS_R, OBS_MAX = 6, 1500, 600	--s periode du balayage des objets ; m rayon autour des zones ; nombre max de lignes CARGO-OBJ/ENTREPOT
local WH_S, WH_R, WH_ITEMS = 30, 20000, 600	--s periode des inventaires d'entrepot ; m distance max zone-base ; nb max d'entrees par inventaire
local CARRY_D, FREE_D = 3, 5	--m : caisse "en soute" si a moins de CARRY_D d'un aeronef ; "decharge" si a plus de FREE_D
local EV_MAX = 300			--nombre max de lignes CARGO-EVT liees a des statiques/cargos
local EV_BIRTH = (world and world.event and world.event.S_EVENT_BIRTH) or 15
local EV_ENTER = (world and world.event and world.event.S_EVENT_PLAYER_ENTER_UNIT) or 20

local function log(m) env.info("DCE_Airlift: "..tostring(m)) end

local callIf, describeObj		--definies plus bas (diagnostic)

--ligne de diagnostic : "CARGO-<tag> t=<temps de mission>"
local function clog(tag, msg)
	local okT, t = pcall(timer.getTime)
	log("CARGO-"..tag.." t="..math.floor((okT and tonumber(t)) or 0).." "..tostring(msg))
end

local function fp(p) return math.floor(p.x + 0.5)..","..math.floor(p.y + 0.5) end

local function dist2(a, b)
	local dx, dy = a.x - b.x, a.y - b.y
	return math.sqrt(dx * dx + dy * dy)
end

local function sideId(side) if side == "red" then return 1 end return 2 end

local function say(side, txt, t)
	pcall(function() trigger.action.outTextForCoalition(sideId(side), txt, t or 15) end)
end

local function addDelivery(slot, side, kg, by, group)
	kg = math.floor(kg + 0.5)
	table.insert(M.deliveries, { slot = slot, side = side, kg = kg, by = by, group = group, t = math.floor(timer.getTime()) })
	log("LIVRAISON slot="..slot.." kg="..kg.." par="..tostring(by).." groupe="..tostring(group))
	if CustomLog then
		table.insert(CustomLog, { t = timer.getTime(), infoEvent = "DCE_AIRLIFT_DELIVERY", type = "airlift delivery", slot = slot, side = side, kg = kg, by = by, group = group })
	else
		log("ERREUR CustomLog absent : livraison "..slot.." "..kg.." kg NON transmise au debriefing")
	end
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
			M.known[c.name] = true
			log("charge "..c.name.." "..c.kg.." kg posee")
			local so = StaticObject.getByName(c.name)
			clog("SPAWN", c.name.." type="..tostring(c.typeName or "ammo_cargo").." kg_demandes="..tostring(c.kg).." slot="..tostring(c.slot)
				.." cote="..tostring(c.side).." pos="..fp(c).." relue="..(so and ("<"..describeObj(so)..">") or "INTROUVABLE apres creation"))
		else
			log("ERREUR charge "..tostring(c.name)..": "..tostring(err))
			clog("SPAWN", tostring(c.name).." ECHEC creation : "..tostring(err))
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

-- charges elinguees (crochet DCS natif) : creditees si elles restent holdS secondes immobiles dans une zone Drop du camp,
-- apres avoir ete deplacees de plus de 50 m. La charge livree RESTE sur place (c.delivered empeche le double comptage).
-- Les lignes CARGO-SLING suivent chaque changement d'etat (voir la legende en haut du fichier).
local function tickCargos(cfg, now)
	local zones = cfg.zones or {}
	local hold = cfg.holdS or 30
	for _, c in ipairs(M.cargos) do
		if not c.taken and not c.delivered then
			local so = StaticObject.getByName(c.name)
			if so and so:isExist() then
				if c.gone then
					clog("SLING", c.name.." de nouveau interrogeable apres "..math.floor(now - c.gone).." s")
					c.gone = nil
				end
				local p = so:getPoint()
				local pos = { x = p.x, y = p.z }
				local moved = dist2(pos, c)
				local still = (c.last ~= nil) and dist2(pos, c.last) < 1
				local agl = p.y - land.getHeight({ x = p.x, y = p.z })
				c.last = pos
				if moved > 2 and not c.movedLogged then
					c.movedLogged = true
					log("charge accrochee/deplacee "..c.name.." ("..math.floor(moved).." m de son point de depart)")
					clog("SLING", c.name.." deplacee de "..math.floor(moved).." m (chargee a la main OU accrochee : ce log ne les distingue pas) pos="..fp(pos).." agl="..math.floor(agl))
				end
				local st = still and "immobile" or "mobile"
				if still then c.stillSince = c.stillSince or now else c.stillSince = nil end
				if c.movedLogged and c.state ~= st then
					clog("SLING", c.name.." "..st.." pos="..fp(pos).." agl="..math.floor(agl).." deplacee="..math.floor(moved).." m")
				end
				c.state = st
				local zone
				for _, z in ipairs(zones) do
					if z.kind == "drop" and z.side == c.side and dist2(pos, z) <= z.radius then zone = z end
				end
				if zone and not c.zoneLogged then
					c.zoneLogged = zone.slot
					c.ncLogged = nil
					log("charge "..c.name.." entree en zone DROP "..tostring(zone.slot).." (deplacee de "..math.floor(moved).." m)")
					clog("SLING", c.name.." ENTREE zone DROP "..tostring(zone.slot).." deplacee="..math.floor(moved).." m "..st)
				elseif not zone and c.zoneLogged then
					clog("SLING", c.name.." SORTIE zone DROP "..tostring(c.zoneLogged).." sans credit")
					c.zoneLogged = nil
				end
				if zone and moved > 50 and still then
					if not c.inT then
						c.inT = now
						clog("SLING", c.name.." chrono "..hold.." s demarre (zone "..tostring(zone.slot)..", deplacee "..math.floor(moved).." m, immobile)")
					end
					if now - c.inT >= hold then
						c.delivered = true
						clog("SLING", c.name.." CREDITEE immobile "..math.floor(now - c.inT).." s dans zone "..tostring(zone.slot).." ("..c.kg.." kg)")
						addDelivery(zone.slot, c.side, c.kg, "sling", c.name)
					end
				else
					if c.inT then
						local why = (not zone) and "sortie de zone" or ((moved <= 50) and "deplacement insuffisant" or "de nouveau mobile")
						clog("SLING", c.name.." chrono remis a zero apres "..math.floor(now - c.inT).." s : "..why)
					end
					c.inT = nil
					if zone and still and moved <= 50 and c.stillSince and now - c.stillSince >= hold and not c.ncLogged then
						c.ncLogged = true
						clog("SLING", c.name.." NON-CREDITEE : immobile "..math.floor(now - c.stillSince).." s en zone mais deplacement "..math.floor(moved).." m <= 50 m (la caisse n'a pas ete transportee)")
					end
				end
			elseif c.last then
				--introuvable : peut-etre accrochee et non interrogeable, on ne conclut qu'apres LOST_S
				if not c.gone then
					c.gone = now
					log("charge introuvable "..c.name.." (accrochee ?)")
					clog("SLING", c.name.." INTROUVABLE (derniere pos="..fp(c.last)..")")
				elseif now - c.gone >= LOST_S then
					c.taken = true
					log("charge perdue: "..c.name)
					clog("SLING", c.name.." PERDUE (introuvable depuis "..LOST_S.." s, derniere pos="..fp(c.last)..")")
				end
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

-- vrai si ce type d'helico garde le chargement simule par menu F10 (campL.wargame_airlift.simTypes) ;
-- les autres utilisent le crochet et le cargo interne natifs de DCS
local function isSim(u)
	local cfg = campL and campL.wargame_airlift
	local st = cfg and cfg.simTypes
	if type(st) ~= "table" then return false end
	local ok, t = pcall(function() return u:getTypeName() end)
	if not ok or t == nil then return false end
	return st[t] and true or false
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
	local ob = M.onboard[name]
	if ob and ob.kg > 0 then clog("SIM", name.." PERDU a la naissance : "..ob.kg.." kg de charge simulee abandonnes") end
	M.born[name] = true		--premier passage de tickSmoke : pas de marquage automatique pour ce qui est deja a portee
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
		clog("SIM", name.." chargement INTERROMPU agl="..math.floor(agl).." v="..string.format("%.1f", sp).." d_zone="..math.floor(dist2(pos, z)))
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
		clog("SIM", name.." chargement : RIEN (candidates="..#cands.." capacite="..cap.." deja_a_bord="..ob.kg..")")
	else
		log("CHARGE joueur="..tostring(u:getPlayerName()).." caisses="..n.." total="..ob.kg.." kg")
		clog("SIM", name.." CHARGE caisses="..n.." total="..ob.kg.." kg capacite="..cap.." candidates="..#cands)
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
		clog("SIM", name.." dechargement INTERROMPU agl="..math.floor(agl).." v="..string.format("%.1f", sp).." d_zone="..math.floor(dist2(pos, z)))
		return
	end
	local ob = M.onboard[name]
	if not ob or ob.kg <= 0 then return end
	--tout ce qui est a bord est credite au point de ravitaillement de cette zone de depose
	local kg = ob.kg
	clog("SIM", name.." DECHARGE zone="..tostring(z.slot).." kg="..kg.." caisses="..#ob.items)
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
		if not z then sayUnit(u, "Airlift: vous n'etes pas dans une zone de chargement.", 8) clog("SIM", name.." demande load REFUSEE : hors zone de chargement") return end
		delay = LOAD_S
	else
		local ob = M.onboard[name]
		if not ob or ob.kg <= 0 then sayUnit(u, "Airlift: rien a bord.", 8) clog("SIM", name.." demande unload REFUSEE : rien a bord") return end
		z = nearestZone(cfg, "drop", side, pos)
		if not z then sayUnit(u, "Airlift: vous n'etes pas dans une zone de depose.", 8) clog("SIM", name.." demande unload REFUSEE : hors zone de depose") return end
		delay = cfg.holdS or 30
	end
	if agl > LANDED_AGL or sp > LANDED_V then
		sayUnit(u, "Airlift: posez-vous pour "..((kind == "load") and "charger." or "decharger."), 8)
		clog("SIM", name.." demande "..kind.." REFUSEE : pas pose (agl="..math.floor(agl).." v="..string.format("%.1f", sp)..")")
		return
	end
	local id = beginOp(name)
	clog("SIM", name.." demande "..kind.." ACCEPTEE zone="..tostring(z.slot).." delai="..delay.." s")
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
local function ensureMark(u, zi, z, pos, intro, why)
	local now = timer.getTime()
	local d, brg = whereIs(pos, z)
	local where = string.format("%s a %.1f km, cap %03d", intro, d / 1000, math.floor(brg + 0.5) % 360)
	if markActive(zi, now) then
		local m = M.mk[zi]
		sayUnit(u, "Airlift: "..where..". Marquage deja actif (encore "..math.floor(m.dur - (now - m.t)).." s).", 12)
		clog("MARK", u:getName().." zone="..zi.." ("..z.kind.." "..tostring(z.slot)..") declencheur="..tostring(why).." : deja actif, encore "..math.floor(m.dur - (now - m.t)).." s, rien lance")
		return
	end
	local ok, night = launchMark(zi, z, now)
	if not ok then
		sayUnit(u, "Airlift: "..where..". Marquage impossible.", 12)
		clog("MARK", u:getName().." zone="..zi.." ("..z.kind.." "..tostring(z.slot)..") declencheur="..tostring(why).." : ECHEC du lancement")
		return
	end
	local color = (z.kind == "load") and "vert" or "rouge"
	local what
	if night then what = (z.kind == "load") and "fusee" or "3 fusees" else what = (z.kind == "load") and "fumigene" or "3 fumigenes" end
	sayUnit(u, "Airlift: "..where..". "..what.." "..color.." lance(s).", 12)
	clog("MARK", u:getName().." zone="..zi.." ("..z.kind.." "..tostring(z.slot)..") declencheur="..tostring(why).." : "..what.." "..color
		.." nuit="..tostring(night).." distance="..math.floor(d).." m duree="..(night and LIGHT_S or SMOKE_S).." s")
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
	ensureMark(u, best, cfg.zones[best], pos, (kind == "load") and "Zone de chargement" or "Zone de depose", "menu")
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
			local born = M.born[name]
			local quiet = {}
			for zi, z in ipairs(zones) do
				if z.side == side then
					local d = dist2(pos, z)
					local k = name.."|"..zi
					if z.kind == "load" then
						--une seule fois par vie, des que le joueur est a moins de LOAD_NEAR
						if d <= LOAD_NEAR and not M.hint[k] and hasCargoAt(z, side) then
							M.hint[k] = true
							if born then
								quiet[#quiet + 1] = k
							else
								ensureMark(u, zi, z, pos, "Zone de chargement", "auto-approche")
							end
						end
					elseif z.kind == "drop" then
						if d > DROP_FAR + 500 then
							M.near[k] = nil		--parti loin : la prochaine approche redeclenchera
						elseif d <= DROP_FAR and not M.near[k] then
							M.near[k] = true
							if born then
								quiet[#quiet + 1] = k
							else
								ensureMark(u, zi, z, pos, "Zone de depose", "auto-approche")
							end
						end
						if d <= DROP_NEAR and not born and not markActive(zi, now) then
							ensureMark(u, zi, z, pos, "Zone de depose", "auto-500m")
						end
					end
				end
			end
			if born then
				--naissance (ou menu tout juste cree) : ce qui est deja a portee est marque "deja annonce" sans rien lancer
				M.born[name] = nil
				clog("MARK", "silencieux a la naissance unite="..name.." zones="..(#quiet > 0 and table.concat(quiet, ",") or "aucune a portee"))
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
	if arg.a == "status" or arg.a == "all" or arg.a == "one" or arg.a == "unload" then
		if not isSim(u) then return end		--type natif DCS : pas de chargement simule
	end
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
		clog("SIM", arg.u.." demande "..arg.a.." REFUSEE : operation deja en cours")
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

	local sim = isSim(u)
	local gid = g:getID()
	local rec = M.grp[gid]
	if not rec then
		local size = 1
		--getInitialSize() peut renvoyer une valeur aberrante (vu : 604556874) : on compte les unites, et on ne garde
		--getInitialSize que si la valeur est plausible
		local okU, us = pcall(function() return g:getUnits() end)
		if okU and type(us) == "table" and #us >= 1 then
			size = #us
		else
			local okS, s = pcall(function() return g:getInitialSize() end)
			if okS and type(s) == "number" and s >= 1 and s <= 50 then size = s end
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
		if sim then		--chargement simule : seulement pour les types listes dans simTypes
			missionCommands.addCommandForGroup(gid, "Charger au maximum", parent, onCommand, { u = name, a = "all" })
			missionCommands.addCommandForGroup(gid, "Charger 1 charge", parent, onCommand, { u = name, a = "one" })
			missionCommands.addCommandForGroup(gid, "Decharger", parent, onCommand, { u = name, a = "unload" })
			missionCommands.addCommandForGroup(gid, "Etat du chargement", parent, onCommand, { u = name, a = "status" })
		end
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
	if M.born[name] == nil then M.born[name] = true end		--joueur deja present au demarrage (pas de BIRTH) : meme regle
	log("menu F10 cree pour "..name.." ("..(sim and "chargement simule" or "marquage seul, cargo DCS natif")..", groupe "..gid..(rec.single and ", unite seule)" or ", sous-menu par unite)"))
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

-- Etape 3 : observation du cargo interne natif (F8). On ECRIT dans le journal, on ne credite RIEN.
local CARGO_EV = {}		--id d'evenement -> nom
local EV_NAME = {}		--id -> nom, pour reperer les evenements que cette version de DCS envoie sans nom connu
local UNKNOWN_EV_MAX = 40	--nombre maximum de lignes "evenement inconnu" dans le journal
local function initCargoEvents()
	--diagnostic : tout ce que cette version de DCS declare dans world.event
	local nTot, idMax, cargoNames = 0, -1, {}
	if world and type(world.event) == "table" then
		for k, v in pairs(world.event) do
			nTot = nTot + 1
			if type(v) == "number" then
				EV_NAME[v] = tostring(k)
				if v > idMax then idMax = v end
			end
			if string.find(string.upper(tostring(k)), "CARGO", 1, true) then cargoNames[#cargoNames + 1] = tostring(k).."="..tostring(v) end
		end
	end
	table.sort(cargoNames)
	log("DIAG world.event : "..nTot.." entrees, id max "..idMax..", noms contenant CARGO : "..(#cargoNames > 0 and table.concat(cargoNames, ", ") or "aucun"))
	for _, n in ipairs({ "S_EVENT_NEW_DYNAMIC_CARGO", "S_EVENT_DYNAMIC_CARGO_LOADED",
			"S_EVENT_DYNAMIC_CARGO_UNLOADED", "S_EVENT_DYNAMIC_CARGO_REMOVED" }) do
		local id = world and world.event and world.event[n]
		if id ~= nil then
			CARGO_EV[id] = n
			log("evenement cargo ecoute: "..n.." ("..tostring(id)..")")
		else
			log("evenement cargo ABSENT de cette version de DCS: "..n)
		end
	end
end

callIf = function(o, fn)		--o:fn() sous pcall ; nil si la methode n'existe pas
	local okF, f = pcall(function() return o[fn] end)
	if not okF or type(f) ~= "function" then return nil end
	local ok, r = pcall(f, o)
	if ok then return r end
	return nil
end

describeObj = function(o)
	local parts = {}
	local n = callIf(o, "getName")
	if n ~= nil then parts[#parts + 1] = "nom="..tostring(n) end
	local t = callIf(o, "getTypeName")
	if t ~= nil then parts[#parts + 1] = "type="..tostring(t) end
	local dn = callIf(o, "getCargoDisplayName")
	if dn ~= nil then parts[#parts + 1] = "affiche="..tostring(dn) end
	local w = callIf(o, "getCargoWeight")
	if w == nil then w = callIf(o, "getMass") end
	if w ~= nil then parts[#parts + 1] = "poids="..tostring(w) end
	local cat = callIf(o, "getCategory")
	if cat ~= nil then parts[#parts + 1] = "categorie="..tostring(cat) end
	local d = callIf(o, "getDesc")
	if type(d) == "table" then
		local dk = {}
		for k, v in pairs(d) do
			if type(v) == "number" or type(v) == "string" or type(v) == "boolean" then dk[#dk + 1] = tostring(k).."="..tostring(v) end
		end
		table.sort(dk)
		if #dk > 0 then parts[#parts + 1] = "desc{"..table.concat(dk, ",", 1, math.min(#dk, 10)).."}" end
	end
	local pl = callIf(o, "getPlayerName")
	if pl ~= nil then parts[#parts + 1] = "joueur="..tostring(pl) end
	local p = callIf(o, "getPoint")
	if type(p) == "table" and p.x and p.z then
		parts[#parts + 1] = string.format("pos=%d,%d", math.floor(p.x), math.floor(p.z))
	end
	if #parts == 0 then return "?" end
	return table.concat(parts, " ")
end

local function logCargoEvent(e)
	local keys = {}
	for k in pairs(e) do keys[#keys + 1] = k end
	table.sort(keys, function(a, b) return tostring(a) < tostring(b) end)
	local out = {}
	for _, k in ipairs(keys) do
		local v = e[k]
		if type(v) == "string" or type(v) == "number" or type(v) == "boolean" then
			out[#out + 1] = tostring(k).."="..tostring(v)
		elseif v ~= nil then
			out[#out + 1] = tostring(k).."=<"..describeObj(v)..">"
		end
	end
	log("CARGO-EVT "..tostring(CARGO_EV[e.id] or EV_NAME[e.id] or ("inconnu "..tostring(e.id))).." t="..math.floor(timer.getTime()).." "..table.concat(out, " ; "))
end

local function onWorldEvent(e)
	if type(e) ~= "table" then return end
	if e.id ~= nil and CARGO_EV[e.id] then
		logCargoEvent(e)
		return
	end
	if type(e.id) == "number" then
		--premiere occurrence de chaque id (toujours) ; ensuite seulement : acteur/cible statique ou cargo (categorie 3 ou 6), ids 47 et 48
		local first = not M.evSeen[e.id]
		local obj = false
		if not first and M.evLines < EV_MAX then
			for _, key in ipairs({ "initiator", "target" }) do
				local o = e[key]
				if type(o) == "table" then
					local c = callIf(o, "getCategory")
					if c == 3 or c == 6 then obj = true end
				end
			end
		end
		if first or ((obj or e.id == 47 or e.id == 48) and M.evLines < EV_MAX) then
			M.evSeen[e.id] = true
			if not first then M.evLines = M.evLines + 1 end
			if first and not EV_NAME[e.id] then log("DIAG evenement inconnu id="..e.id.." (absent de world.event)") end
			pcall(logCargoEvent, e)
		end
	end
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

-- Diagnostic : caisses que "voit" l'helicoptere du joueur (Unit.getNearestCargos). On journalise a chaque CHANGEMENT de la liste :
-- on y verra apparaitre une caisse creee par le menu F8, puis disparaitre quand elle est chargee a bord.
local function tickCargoWatch(now)
	if now < M.nextWatch then return end
	M.nextWatch = now + SMOKE_CHECK
	for name in pairs(M.menus) do
		local u = Unit.getByName(name)
		if u and u:isExist() and u:getPlayerName() then
			local list = callIf(u, "getNearestCargos")
			local parts = {}
			if type(list) == "table" then
				for i = 1, math.min(#list, 8) do parts[#parts + 1] = describeObj(list[i]) end
			end
			local sig = tostring(list ~= nil and #parts or "nil").."|"..table.concat(parts, " ; ")
			if M.watch[name] ~= sig then
				M.watch[name] = sig
				if list == nil then
					log("CARGO-PROCHE "..name.." : getNearestCargos indisponible pour ce type")
				else
					log("CARGO-PROCHE "..name.." : "..#parts.." caisse(s) visible(s) [ "..table.concat(parts, " ; ").." ]")
				end
			end
		end
	end
end

-- Observation : balayage des objets cargo/statiques autour des zones et des joueurs, et inventaires d'entrepot.
-- Sert a savoir ce que DCS cree et fait disparaitre quand une caisse est chargee, deposee ou larguee. Rien n'est credite ici.
local function nearestAircraftRaw(pos)
	local best, bd, bagl
	local function try(u)
		if u and u:isExist() then
			local p = u:getPoint()
			local d = dist2(pos, { x = p.x, y = p.z })
			if not bd or d < bd then best, bd, bagl = u:getName(), d, p.y - land.getHeight({ x = p.x, y = p.z }) end
		end
	end
	for name in pairs(M.menus) do try(Unit.getByName(name)) end
	for _, st in ipairs(M.ai) do
		local g = Group.getByName(st.name)
		if g and g:isExist() then try(g:getUnit(1)) end
	end
	return best, bd, bagl
end

local function nearestAircraft(pos)
	local best, bd, bagl = nearestAircraftRaw(pos)
	if not best then return "aucun" end
	return best.." d="..math.floor(bd).." m agl="..math.floor(bagl)
end

local function zoneOf(cfg, pos)
	local best, bd
	for _, z in ipairs(cfg.zones or {}) do
		local d = dist2(pos, z)
		if not bd or d < bd then best, bd = z, d end
	end
	if not best then return "aucune zone" end
	local r = best.radius or 0
	return best.kind.." "..tostring(best.slot).." d="..math.floor(bd).."/"..math.floor(r).." m "..((bd <= r) and "DANS" or "hors")
end

-- credit des caisses dynamiques (menu F8 / elingage / largage) : une caisse est creditee quand elle a ete transportee
-- (vue a moins de CARRY_D d'un aeronef, ou deplacee de plus de 50 m) puis reste immobile holdS secondes dans une zone
-- de depose de son camp, a plus de FREE_D de tout aeronef. Une seule fois par nom. Les caisses du script (M.known) restent
-- gerees par tickCargos.
local function creditStep(cfg, now, n, o, rec, pos)
	if rec.credited then return end
	local an, ad = nearestAircraftRaw(pos)
	if an and ad <= CARRY_D then
		if not rec.carried then
			rec.carried = true
			clog("CREDIT", n.." transportee : en soute de "..an.." (d="..math.floor(ad).." m)")
		end
		local au = Unit.getByName(an)
		if au and au:isExist() then
			rec.side = sideOf(au)
			rec.by = au:getPlayerName() or an
		end
	end
	if not rec.carried and dist2(pos, { x = rec.x0, y = rec.y0 }) > 50 then
		rec.carried = true
		clog("CREDIT", n.." transportee : deplacee de plus de 50 m (elingage ou largage) pos="..fp(pos).." aeronef le plus proche : "..tostring(an).." d="..tostring(ad and math.floor(ad)))
		if an and ad <= 300 and not rec.side then		--elingage / largage : le camp est celui de l'aeronef qui vient de passer
			local au = Unit.getByName(an)
			if au and au:isExist() then
				rec.side = sideOf(au)
				rec.by = au:getPlayerName() or an
			end
		end
	end
	if not rec.carried then return end
	local side = rec.side
	if not side then
		local c = callIf(o, "getCoalition")
		if c == 1 then side = "red" elseif c == 2 then side = "blue" end
	end
	if not side then		--dernier recours : camp de la zone de depose dans laquelle elle se trouve
		for _, z in ipairs(cfg.zones or {}) do
			if z.kind == "drop" and dist2(pos, z) <= z.radius then side = z.side end
		end
		if side and not rec.noSide then
			rec.noSide = true
			clog("CREDIT", n.." camp inconnu : deduit de la zone de depose ("..side..")")
		end
	end
	if not side then return end
	local zone
	for _, z in ipairs(cfg.zones or {}) do
		if z.kind == "drop" and z.side == side and dist2(pos, z) <= z.radius then zone = z end
	end
	local hold = cfg.holdS or 30
	if zone and rec.state == "immobile" and (not ad or ad > FREE_D) then
		if not rec.inT then
			rec.inT = now
			clog("CREDIT", n.." chrono "..hold.." s demarre : immobile en zone "..tostring(zone.slot).." (aeronef le plus proche "..(an and math.floor(ad) or "aucun").." m)")
		end
		if now - rec.inT >= hold then
			local kg = callIf(o, "getCargoWeight")
			if type(kg) ~= "number" then kg = callIf(o, "getMass") end
			if type(kg) ~= "number" or kg <= 0 then
				clog("CREDIT", n.." poids illisible ("..tostring(kg).."), nouvel essai plus tard")
				rec.inT = now
				return
			end
			rec.credited = true
			clog("CREDIT", n.." CREDITEE "..math.floor(kg + 0.5).." kg zone "..tostring(zone.slot).." camp "..side.." par "..tostring(rec.by))
			addDelivery(zone.slot, side, kg, rec.by or "?", n)
		end
	elseif rec.inT then
		local why = (not zone) and "hors zone de depose" or ((rec.state ~= "immobile") and "mobile" or "trop pres d'un aeronef")
		clog("CREDIT", n.." chrono remis a zero apres "..math.floor(now - rec.inT).." s : "..why)
		rec.inT = nil
	end
end

local function olog(tag, msg)
	if M.obsLines >= OBS_MAX then
		if not M.obsCap then
			M.obsCap = true
			clog("OBS", "limite de "..OBS_MAX.." lignes CARGO-OBJ/ENTREPOT atteinte : plus de lignes")
		end
		return
	end
	M.obsLines = M.obsLines + 1
	clog(tag, msg)
end

local function cargoLike(n, ty)
	local s = string.lower(tostring(n).." "..tostring(ty))
	for _, w in ipairs({ "cargo", "crate", "container", "ammo", "barrel", "pallet", "box", "sling", "iso", "fuel" }) do
		if string.find(s, w, 1, true) then return true end
	end
	return false
end

-- contenu "entrepot" d'une caisse (Warehouse.getCargoAsWarehouse, DCS 2.9.6+), en resume
local function crateContent(o)
	local out = "n/a"
	pcall(function()
		local w = Warehouse.getCargoAsWarehouse(o)
		if not w then out = "aucun" return end
		local inv = w:getInventory()
		local t, cnt = {}, { n = 0 }
		local function walk(x, pre, dep)
			if dep > 4 or cnt.n >= 12 then return end
			for k, v in pairs(x) do
				if type(v) == "number" and v ~= 0 then t[#t + 1] = pre.."/"..tostring(k).."="..v cnt.n = cnt.n + 1
				elseif type(v) == "table" then walk(v, pre.."/"..tostring(k), dep + 1) end
			end
		end
		if type(inv) == "table" then walk(inv, "", 0) end
		table.sort(t)
		out = (#t > 0) and table.concat(t, " ") or "vide"
	end)
	return out
end

local function tickObserve(cfg, now)
	if now < M.nextObs then return end
	M.nextObs = now + OBS_S
	local centers = {}
	for _, z in ipairs(cfg.zones or {}) do
		centers[#centers + 1] = { x = z.x, y = z.y, r = math.max(OBS_R, z.radius or 0), l = z.kind.." "..tostring(z.slot) }
	end
	for name in pairs(M.menus) do
		local u = Unit.getByName(name)
		if u and u:isExist() then
			local p = u:getPoint()
			centers[#centers + 1] = { x = p.x, y = p.z, r = 300, l = "joueur "..name }
		end
	end
	local cats = {}
	if Object and Object.Category then
		if Object.Category.CARGO then cats[#cats + 1] = { Object.Category.CARGO, "CARGO" } end
		if Object.Category.STATIC then cats[#cats + 1] = { Object.Category.STATIC, "STATIC" } end
	end
	local cur = {}
	for _, c in ipairs(centers) do
		for _, cat in ipairs(cats) do
			pcall(function()
				local vol = { id = world.VolumeType.SPHERE, params = {
					point = { x = c.x, y = land.getHeight({ x = c.x, y = c.y }), z = c.y }, radius = c.r } }
				world.searchObjects(cat[1], vol, function(o)
					local okN, n = pcall(function() return o:getName() end)
					if okN and n and not cur[n] then cur[n] = { o = o, cat = cat[2], near = c.l } end
					return true
				end)
			end)
		end
	end
	M.scanN = M.scanN + 1
	for n, e in pairs(cur) do
		local o = e.o
		local ty = callIf(o, "getTypeName")
		if e.cat == "CARGO" or M.known[n] or cargoLike(n, ty) then
			local p = callIf(o, "getPoint")
			if type(p) == "table" and p.x and p.z then
				local pos = { x = p.x, y = p.z }
				local agl = p.y - land.getHeight({ x = p.x, y = p.z })
				local v = callIf(o, "getVelocity")
				local sp = (type(v) == "table" and v.x and v.z) and math.sqrt(v.x * v.x + v.z * v.z) or -1
				local rec = M.obs[n]
				if not rec then
					rec = { x = pos.x, y = pos.y, x0 = pos.x, y0 = pos.y, state = "immobile", scan = M.scanN }
					M.obs[n] = rec
					olog("OBJ", "APPARU "..n.." ["..e.cat.."] pres de "..e.near.." zone_la_plus_proche="..zoneOf(cfg, pos).." pos="..fp(pos).." agl="..math.floor(agl)
						.." v="..string.format("%.1f", sp).." connue_du_script="..(M.known[n] and "oui" or "non")
						.." aeronef_proche="..nearestAircraft(pos).." <"..describeObj(o).."> contenu="..crateContent(o))
				else
					if rec.gone then
						rec.gone = nil
						olog("OBJ", "REAPPARU "..n.." pos="..fp(pos).." aeronef_proche="..nearestAircraft(pos))
					end
					local moved = dist2(pos, rec)
					local st = (moved > 0.5) and "mobile" or "immobile"
					if rec.state ~= st then
						rec.state = st
						olog("OBJ", "ETAT "..n.." "..st.." zone_la_plus_proche="..zoneOf(cfg, pos).." pos="..fp(pos).." agl="..math.floor(agl).." v="..string.format("%.1f", sp)
							.." deplace_depuis_dernier_balayage="..string.format("%.1f", moved).." m aeronef_proche="..nearestAircraft(pos))
					end
					rec.x, rec.y, rec.scan = pos.x, pos.y, M.scanN
				end
				if e.cat == "CARGO" and not M.known[n] then
					local okC, errC = pcall(creditStep, cfg, now, n, o, rec, pos)
					if not okC then log("ERREUR credit caisse "..n..": "..tostring(errC)) end
				end
			end
		end
	end
	for n, rec in pairs(M.obs) do
		if rec.scan ~= M.scanN and not rec.gone then
			rec.gone = true
			local q = StaticObject.getByName(n)
			olog("OBJ", "DISPARU "..n.." derniere pos="..fp(rec).." interrogeable_par_nom="..((q and q:isExist()) and "OUI" or "non")
				.." aeronef_proche_de_la_derniere_pos="..nearestAircraft(rec).." (peut aussi avoir quitte la zone observee)")
		end
	end
end

-- inventaires d'entrepot des bases/FARP proches des zones : on ne journalise que les differences
local function flatten(t, prefix, out, dep, cnt)
	if dep > 4 then return end
	for k, v in pairs(t) do
		if cnt.n >= WH_ITEMS then return end
		local key = prefix.."/"..tostring(k)
		if type(v) == "number" then
			out[key] = v
			cnt.n = cnt.n + 1
		elseif type(v) == "table" then
			flatten(v, key, out, dep + 1, cnt)
		end
	end
end

local function tickWarehouse(cfg, now)
	if now < M.nextWh then return end
	M.nextWh = now + WH_S
	local zones = cfg.zones or {}
	if #zones == 0 then return end
	local okA, bases = pcall(world.getAirbases)
	if not okA or type(bases) ~= "table" then return end
	for _, ab in ipairs(bases) do
		local bn = callIf(ab, "getName")
		local bp = callIf(ab, "getPoint")
		if bn and type(bp) == "table" and bp.x then
			local near = false
			for _, z in ipairs(zones) do
				if dist2({ x = bp.x, y = bp.z }, z) <= WH_R then near = true break end
			end
			local w = near and callIf(ab, "getWarehouse")
			if w then
				local snap, cnt = {}, { n = 0 }
				local inv = callIf(w, "getInventory")
				local invInfo = {}
				if type(inv) == "table" then
					flatten(inv, "inv", snap, 0, cnt)
					for k, v in pairs(inv) do
						local c = 0
						if type(v) == "table" then for _ in pairs(v) do c = c + 1 end end
						invInfo[#invInfo + 1] = tostring(k).."="..(type(v) == "table" and (c.." entrees") or tostring(v))
					end
					table.sort(invInfo)
				end
				for liq = 0, 3 do
					local ok, v = pcall(function() return w:getLiquidAmount(liq) end)
					if ok and type(v) == "number" then snap["liq/"..liq] = v end
				end
				local prev = M.wh[bn]
				if not prev then
					olog("ENTREPOT", bn.." (type="..tostring(callIf(ab, "getTypeName"))..", cote="..tostring(callIf(ab, "getCoalition"))..") ETAT INITIAL : "
						..cnt.n.." valeurs ; inventaire{"..table.concat(invInfo, ", ").."} ; liquides 0="..tostring(snap["liq/0"])
						.." 1="..tostring(snap["liq/1"]).." 2="..tostring(snap["liq/2"]).." 3="..tostring(snap["liq/3"])
						..(cnt.n == 0 and " ; INVENTAIRE VIDE (illimite ?)" or ""))
				else
					local lines = 0
					for k, v in pairs(snap) do
						if prev[k] ~= v and lines < 20 then
							lines = lines + 1
							olog("ENTREPOT", bn.." "..k.." : "..tostring(prev[k]).." -> "..tostring(v).." (delta "..tostring(v - (prev[k] or 0))..")")
						end
					end
					for k, v in pairs(prev) do
						if snap[k] == nil and lines < 20 then
							lines = lines + 1
							olog("ENTREPOT", bn.." "..k.." : "..tostring(v).." -> absent")
						end
					end
				end
				M.wh[bn] = snap
			end
		end
	end
end

-- decor present dans chaque zone de depose (a lancer une fois au demarrage, apres le nettoyage fait par la mission)
local function scanScenery(cfg)
	if not (Object and Object.Category and Object.Category.SCENERY and world and world.searchObjects) then
		clog("ZONE", "Object.Category.SCENERY indisponible : pas de balayage du decor")
		return
	end
	for _, z in ipairs(cfg.zones or {}) do
		if z.kind == "drop" then
			local n, types = 0, {}
			local ok, err = pcall(function()
				local vol = { id = world.VolumeType.SPHERE, params = {
					point = { x = z.x, y = land.getHeight({ x = z.x, y = z.y }), z = z.y }, radius = z.radius or 100 } }
				world.searchObjects(Object.Category.SCENERY, vol, function(o)
					n = n + 1
					if n <= 2000 then
						local t = callIf(o, "getTypeName") or callIf(o, "getName") or "?"
						types[tostring(t)] = (types[tostring(t)] or 0) + 1
					end
					return true
				end)
			end)
			local keys = {}
			for k in pairs(types) do keys[#keys + 1] = k end
			table.sort(keys, function(a, b) return types[a] > types[b] end)
			local parts = {}
			for i = 1, math.min(#keys, 8) do parts[#parts + 1] = keys[i].."="..types[keys[i]] end
			clog("ZONE", "drop "..tostring(z.slot).." rayon="..math.floor(z.radius or 0).." m : "..n.." objet(s) de decor"
				..(ok and "" or " (ERREUR "..tostring(err)..")")..(#parts > 0 and " ["..table.concat(parts, ", ").."]" or "")
				.." (les arbres ne sont peut-etre pas detectables)")
		end
	end
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
		local okW, errW = pcall(tickCargoWatch, now)
		if not okW then log("ERREUR tickCargoWatch: "..tostring(errW)) end
		local okO, errO = pcall(tickObserve, cfg, now)
		if not okO then log("ERREUR tickObserve: "..tostring(errO)) end
		local okH, errH = pcall(tickWarehouse, cfg, now)
		if not okH then log("ERREUR tickWarehouse: "..tostring(errH)) end
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
	initCargoEvents()
	M.handler = { onEvent = function(self, e)
		local ok, err = pcall(onWorldEvent, e)
		if not ok then log("ERREUR evenement: "..tostring(err)) end
	end }
	local okH, errH = pcall(world.addEventHandler, M.handler)
	if not okH then log("ERREUR addEventHandler: "..tostring(errH)) end
	scanMission(cfg)
	spawnCargos(cfg)
	drawZones(cfg)
	pcall(scanScenery, cfg)
	timer.scheduleFunction(tick, nil, now + PERIOD)
	return nil
end

-- DIAGNOSTIC TEMPORAIRE "DCE_Clear:" : nettoyage ME des zones WG_CLEAR_SCPT_* (arbres / batiments), t=0, 6 et 60 s
-- a supprimer une fois le probleme tranche
local function clearZoneList()
	local list = {}
	local zs = env and env.mission and env.mission.triggers and env.mission.triggers.zones
	for _, z in pairs(zs or {}) do
		if type(z.name) == "string" and string.sub(z.name, 1, 14) == "WG_CLEAR_SCPT_" then list[#list + 1] = z.name end
	end
	table.sort(list)
	return list
end

local function clearCount(tz, cat)
	local n, types = 0, {}
	local vol = { id = world.VolumeType.SPHERE, params = {
		point = { x = tz.point.x, y = land.getHeight({ x = tz.point.x, y = tz.point.z }), z = tz.point.z }, radius = tz.radius } }
	world.searchObjects(cat, vol, function(o)
		n = n + 1
		if n <= 500 then
			local t = tostring(callIf(o, "getTypeName") or "?")
			types[t] = (types[t] or 0) + 1
		end
		return true
	end)
	local keys = {}
	for k in pairs(types) do keys[#keys + 1] = k end
	table.sort(keys, function(a, b) return types[a] > types[b] end)
	local parts = {}
	for i = 1, math.min(#keys, 5) do parts[#parts + 1] = keys[i].."="..types[keys[i]] end
	return n, table.concat(parts, ",")
end

local clearFirst = {}
local function clearDiag(arg)
	local t = arg.t
	local function say(m) env.info("DCE_Clear: t="..t.." "..m) end
	local ok, err = pcall(function()
		if t == 0 then
			--triggers : presents dans le .miz ? (comment contenant "WG airlift")
			local nt = 0
			for _, r in pairs((env and env.mission and env.mission.trigrules) or {}) do
				if type(r) == "table" and type(r.comment) == "string" and string.find(r.comment, "WG airlift", 1, true) then
					nt = nt + 1
					say("trigrule '"..r.comment.."' type="..tostring(r.eventlist or r.predicate))
				end
			end
			say("triggers WG airlift dans le .miz : "..nt.." (attendu 2)")
		end
		local names = clearZoneList()
		if #names == 0 then say("AUCUNE zone WG_CLEAR_SCPT_* dans env.mission.triggers.zones") end
		for _, name in ipairs(names) do
			local tz = trigger.misc.getZone(name)
			if not tz or not tz.point then
				say(name.." : trigger.misc.getZone = nil (zone absente)")
			else
				local ns, ts = clearCount(tz, Object.Category.SCENERY)
				local nb, tb = clearCount(tz, Object.Category.STATIC)
				local before = clearFirst[name]
				say(name.." x="..math.floor(tz.point.x).." z="..math.floor(tz.point.z).." r="..math.floor(tz.radius)
					.." decor="..ns..(before and (" (t=0: "..before..")") or "").." ["..ts.."] statics="..nb.." ["..tb.."]")
				if t == 0 then clearFirst[name] = ns end
			end
		end
	end)
	if not ok then say("ERREUR "..tostring(err)) end
end

for _, dt in ipairs({ 0, 6, 60 }) do
	timer.scheduleFunction(function() clearDiag({ t = dt }) end, nil, timer.getTime() + dt + 0.5)
end

timer.scheduleFunction(start, nil, timer.getTime() + 6)
