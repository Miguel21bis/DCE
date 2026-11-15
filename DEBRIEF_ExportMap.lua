--To export the incidents of the mission (kills, losses, ejections, destroyed ground objects, bomb impacts) for the events map of DCE_Manager
--Initiated by DEBRIEF_Master.lua, right after DEBRIEF_Text.lua (oob_air / oob_ground / targetlist are already updated in memory here)
--Writes: Debriefing/DebriefEvents <mission>.lua  (one file per mission, kept so old debriefs can be shown again on the map)
-------------------------------------------------------------------------------------------------------
if not versionDCE then versionDCE = {} end
versionDCE["DEBRIEF_ExportMap.lua"] = "1.1.0"
-------------------------------------------------------------------------------------------------------

--format du fichier (version = 1) :
--debriefEvents = {
--	version, mission, campaign, date = {day, month, year}, campTime, nbIncidents, unmatched,
--	incidents = {
--		{ id, t, kind, name, flight, side, category, type, pilot,
--		  x, y, z, posSrc,                              --position DCS (x = nord, y = est), nil si inconnue
--		  killer, killerFlight, killerSide, killerType, killerCategory, friendly,
--		  target, element, status, weapon, mass, cause, info },
--	},
--	unitPlayers = { ["Pack 11 - 4th TFS - Escort 1-2"] = "player name", ... }		--player of each aircraft
--	flights = { ["Pack 1 - 469th TFS - Escort 1"] = { side, category, points = { {x, y}, ... }, units = { {name, client}, ... } }, ... }	--vols de la mission jouee
--	players = { ["Pack 11 - 4th TFS - Escort 1"] = { "player name", ... }, ... }		--players (clients) of each flight, from the pilotName of the events
--}
--kind : air_lost, ground_kill, ship_kill, static_kill, scenery_kill, eject, pilot_dead, pilot_sar, bomb
--scenery_kill : decor detruit ; "target" (nom de la cible de la target map) n'est rempli que si ce decor appartient a une cible
--posSrc : eject (position exacte) / sar_approx (point d'atterrissage du pilote, approximatif) / oob_start (position de depart dans la mission, approximative) / scen (decor) / sar / impact
--pilot_sar : "unit" = avion du pilote, "current" = vrai si le pilote vient de CETTE mission (sinon pilote d'une mission precedente, toujours a recuperer)

--Tout est dans un pcall : si l'export plante, le debrief continue normalement
local function ExportMap()

	local incidents = {}
	local unmatched = 0
	local seen = {}																					--un seul incident par nom de victime

	local function add(inc)
		inc.id = #incidents + 1
		table.insert(incidents, inc)
	end

	local function escapePattern(str)
		return (string.gsub(str, "(%W)", "%%%1"))
	end

	--nom de vol : "Pack 21 - 4th TFS - Strike 1-4" -> "Pack 21 - 4th TFS - Strike 1"
	local function flightOf(name)
		if not name then return nil end
		return (string.gsub(name, "%-%d+$", ""))
	end

	----------------------------------------------------------------
	-- index des squadrons air : on reprend celui de DEBRIEF_StatsEvaluation s'il existe
	----------------------------------------------------------------
	local squadIndex = AirSquadronIndex
	if not squadIndex then
		squadIndex = {}
		for sideName, side in pairs(oob_air) do
			for _, unit in pairs(side) do
				table.insert(squadIndex, { pattern = escapePattern(unit.name), unit = unit, side = sideName })
			end
		end
	end

	local airCache = {}
	local function airSquad(name)
		if not name then return nil end
		local c = airCache[name]
		if c ~= nil then return c or nil end
		for _, entry in ipairs(squadIndex) do
			if string.find(name, entry.pattern, 1) then
				airCache[name] = entry
				return entry
			end
		end
		airCache[name] = false
		return nil
	end

	----------------------------------------------------------------
	-- index des unites de la mission jouee (last_Mission) : type, categorie, tache, position de depart
	----------------------------------------------------------------
	local unitInfo = {}

	--vols de la mission jouee : camp, plan de vol (waypoints) et avions (client = slot joueur) ; l'ancien fichier mission n'est plus necessaire pour les afficher
	local flights = {}
	local function exportFlight(group, sideName, chapterName)
		local fl = { side = sideName, category = chapterName, points = {}, units = {} }
		local pts = group.route and group.route.points
		if type(pts) == "table" then
			local keys = {}
			for k in pairs(pts) do
				if type(k) == "number" then table.insert(keys, k) end
			end
			table.sort(keys)
			for _, k in ipairs(keys) do
				local p = pts[k]
				if type(p) == "table" and p.x and p.y then
					table.insert(fl.points, { x = p.x, y = p.y })
				end
			end
		end
		local names = {}
		for _, u in pairs(group.units or {}) do
			if u.name then
				table.insert(names, u.name)
				fl.units[#names] = { name = u.name, client = (u.skill == "Client" or u.skill == "Player") or false }
			end
		end
		return fl
	end
	if last_Mission and last_Mission.coalition then
		for sideName, sideTab in pairs(last_Mission.coalition) do
			for _, country in pairs(sideTab.country or {}) do
				for chapterName, chapter in pairs(country) do
					if type(chapter) == "table" and chapter.group then
						for _, group in pairs(chapter.group) do
							if (chapterName == "plane" or chapterName == "helicopter") and group.name then
								flights[group.name] = exportFlight(group, sideName, chapterName)
							end
							for _, u in pairs(group.units or {}) do
								if u.name then
									unitInfo[u.name] = {
										type = u.type,
										category = chapterName,										--plane / helicopter / vehicle / ship / static
										side = sideName,
										x = u.x,
										y = u.y,
										task = group.task,
										targetName = group.DCE_targetName,
									}
								end
							end
						end
					end
				end
			end
		end
	end

	--qui est cette unite ? (pour le tueur) -> camp, vol, type, categorie
	local function who(name)
		if not name then return nil, nil, nil, nil end
		local sq = airSquad(name)
		if sq then
			local ui = unitInfo[name]
			return sq.side, flightOf(name), ui and ui.type, (ui and ui.category) or "plane"
		end
		local g = GroundUnitByName and GroundUnitByName[name]
		if g then
			return g.side, nil, g.type, g.class
		end
		return nil, nil, nil, nil
	end

	local function setKiller(inc, killerName, victimSide)
		if not killerName then return end
		local side, flight, ktype, kcat = who(killerName)
		inc.killer = killerName
		inc.killerSide = side
		inc.killerFlight = flight
		inc.killerType = ktype
		inc.killerCategory = kcat
		if side and victimSide and side == victimSide then
			inc.friendly = true																		--tir fratricide : pas un kill pour les stats
		end
	end

	----------------------------------------------------------------
	-- premier passage sur les events : dernier tireur par cible, position des victimes, noms des pilotes
	----------------------------------------------------------------
	local lastHitter = {}
	local posOf = {}																				--[victime] = { x, y, z, src, t } (premiere position valable)
	local pilotOf = {}

	--seuls ces events donnent la position de la victime elle-meme (pas hit/kill/shot : ce sont celles du tireur)
	local posTypes = {
		["pilot seat separation"] = true,
		["crash"] = true,
		["eject"] = true,
		["unit lost"] = true,
		["dead"] = true,
		["pilot dead"] = true,
	}

	for e = 1, #events do
		local ev = events[e]
		local tp = ev.type

		if ev.initiator then
			local p = ev.pilotName
			if type(p) ~= "string" or p == "nil" then p = ev.initiatorPilotName end
			if type(p) == "string" and p ~= "nil" then pilotOf[ev.initiator] = p end
		end

		if tp == "hit" and ev.target and ev.initiator then
			lastHitter[ev.target] = ev.initiator
		elseif ev.x and ev.y and ev.initiator and posTypes[tp] and not posOf[ev.initiator] then
			posOf[ev.initiator] = { x = ev.x, y = ev.y, z = ev.z, src = (tp == "pilot seat separation") and "eject" or tp, t = ev.t or 0 }
		end
	end

	----------------------------------------------------------------
	-- avions perdus (kill / crash) : un incident par avion
	----------------------------------------------------------------
	for e = 1, #events do
		local ev = events[e]
		local tp = ev.type

		if (tp == "kill" and ev.target) or (tp == "crash" and ev.initiator) then
			local victim = (tp == "kill") and ev.target or ev.initiator
			local sq = airSquad(victim)

			if sq then
				if not seen[victim] then
					seen[victim] = true

					local ui = unitInfo[victim]
					local inc = {
						t = ev.t,
						kind = "air_lost",
						name = victim,
						flight = flightOf(victim),
						side = sq.side,
						category = (ui and ui.category) or "plane",
						type = ui and ui.type,
						pilot = pilotOf[victim],
						cause = tp,																	--kill (abattu) / crash (sans tireur connu, ou tireur = dernier hit)
					}

					local killer = (tp == "kill") and ev.initiator or lastHitter[victim]
					setKiller(inc, killer, sq.side)

					local p = posOf[victim]
					if p and math.abs(p.t - (ev.t or 0)) <= 300 then
						inc.x, inc.y, inc.z, inc.posSrc = p.x, p.y, p.z, p.src
					end

					add(inc)
				end
			elseif tp == "kill" and type(victim) ~= "number" then
				unmatched = unmatched + 1															--kill sur autre chose qu'un avion (Manhunt...) ; les decors (numeros) sont traites plus bas
			end
		end
	end

	----------------------------------------------------------------
	-- unites sol / navires / statiques detruits pendant cette mission (dead_last est pose par DEBRIEF_StatsEvaluation)
	----------------------------------------------------------------
	for e = 1, #events do
		local ev = events[e]
		local tp = ev.type

		if (tp == "dead" or tp == "unit lost") and ev.initiator and not seen[ev.initiator] then
			local g = GroundUnitByName and GroundUnitByName[ev.initiator]

			--t > 5 : les statiques deja detruits au demarrage de la mission sont logges "dead" a t = 0
			if g and g.dead_last and (ev.t or 0) > 5 then
				seen[ev.initiator] = true

				local kind = "ground_kill"
				if g.class == "ship" then
					kind = "ship_kill"
				elseif g.class == "static" then
					kind = "static_kill"
				end

				local inc = {
					t = ev.t,
					kind = kind,
					name = g.name,
					side = g.side,
					category = g.class,
					type = g.type,
					x = g.x,
					y = g.y,
					posSrc = (g.x and g.y) and "oob_start" or nil,
				}
				setKiller(inc, lastHitter[ev.initiator], g.side)
				add(inc)
			end
		end
	end

	----------------------------------------------------------------
	-- decors detruits : un "kill" dont la cible est un numero (id de l'objet) -> position dans scen_log, tueur et heure dans le kill
	----------------------------------------------------------------
	local sceneryGrid = {}																			--grille de 100 m, pour retrouver ces decors depuis targetlist
	local function cellKey(x, y)
		return math.floor(x / 100) .. ":" .. math.floor(y / 100)
	end

	if type(scen_log) == "table" then
		for e = 1, #events do
			local ev = events[e]
			if ev.type == "kill" and type(ev.target) == "number" and not seen[ev.target] then
				local s = scen_log[ev.target]
				if s and s.x and s.y then
					seen[ev.target] = true
					local typeName = s.Desc and s.Desc.typeName
					if not (typeName and string.find(typeName, "FOREST", 1, true)) then			--les forets ne comptent pas (comme dans DEBRIEF_StatsEvaluation)
						local inc = {
							t = ev.t,
							kind = "scenery_kill",
							name = tostring(ev.target),
							side = ev.targetSideName,
							category = "scenery",
							type = typeName,
							x = s.x, y = s.y, z = s.z,
							posSrc = "scen",
						}
						setKiller(inc, ev.initiator, nil)
						add(inc)

						local key = cellKey(s.x, s.y)
						sceneryGrid[key] = sceneryGrid[key] or {}
						table.insert(sceneryGrid[key], inc)
					end
				end
			end
		end
	end

	--incident de decor deja exporte a moins de 30 m de ce point ?
	local function findScenery(x, y)
		local cx, cy = math.floor(x / 100), math.floor(y / 100)
		for dx = -1, 1 do
			for dy = -1, 1 do
				local list = sceneryGrid[(cx + dx) .. ":" .. (cy + dy)]
				if list then
					for _, inc in ipairs(list) do
						local ddx, ddy = inc.x - x, inc.y - y
						if ddx * ddx + ddy * ddy <= 900 then
							return inc
						end
					end
				end
			end
		end
		return nil
	end

	----------------------------------------------------------------
	-- elements de decor des cibles (target map) detruits : le lien decor -> cible est deja fait par DEBRIEF_StatsEvaluation
	----------------------------------------------------------------
	if targetlist then
		for sideKey, targets in pairs(targetlist) do
			local owner = (sideKey == "blue") and "red" or "blue"									--le proprietaire de la cible est l'inverse de la cle targetlist
			for _, target in pairs(targets) do
				if type(target) == "table" and target.elements then
					for _, el in pairs(target.elements) do
						if type(el) == "table" and el.dead_last and el.x and el.y and not seen[el.name] then
							seen[el.name] = true

							local found = findScenery(el.x, el.y)
							if found then
								--meme objet que le kill d'un id de decor : on lui ajoute juste le lien vers la cible
								found.target = target.titleName
								found.side = owner
								found.element = el.name
							else
								local inc = {
									kind = "scenery_kill",
									name = el.name,
									side = owner,
									category = "scenery",
									type = el.type,
									x = el.x,
									y = el.y,
									posSrc = "scen",
									target = target.titleName,
								}
								setKiller(inc, el.lasthit, owner)
								add(inc)
							end
						end
					end
				end
			end
		end
	end

	----------------------------------------------------------------
	-- ejections, pilotes morts
	----------------------------------------------------------------
	local pilotDeadSeen = {}
	for e = 1, #events do
		local ev = events[e]
		local tp = ev.type

		if tp == "pilot seat separation" and ev.initiator and ev.x and ev.y then
			local sq = airSquad(ev.initiator)
			add({
				t = ev.t,
				kind = "eject",
				name = ev.initiator,
				flight = flightOf(ev.initiator),
				side = sq and sq.side or ev.initiatorSideName,
				category = "pilot",
				pilot = pilotOf[ev.initiator],
				x = ev.x, y = ev.y, z = ev.z,
				posSrc = "eject",
			})
		elseif tp == "pilot dead" and ev.initiator and not pilotDeadSeen[ev.initiator] then
			pilotDeadSeen[ev.initiator] = true
			local sq = airSquad(ev.initiator)
			local inc = {
				t = ev.t,
				kind = "pilot_dead",
				name = ev.initiator,
				flight = flightOf(ev.initiator),
				side = sq and sq.side or ev.initiatorSideName,
				category = "pilot",
				pilot = pilotOf[ev.initiator],
			}
			if ev.x and ev.y then
				inc.x, inc.y, inc.z, inc.posSrc = ev.x, ev.y, ev.z, "eject"
			end
			add(inc)
		end
	end

	----------------------------------------------------------------
	-- pilotes au sol (zoneSAR de cette mission)
	----------------------------------------------------------------
	--zoneSAR contient aussi les pilotes des missions precedentes pas encore recuperes : "current" = pilote de CETTE mission
	local sarByUnit = {}
	if type(zoneSAR) == "table" then
		for zoneName, list in pairs(zoneSAR) do
			if type(list) == "table" then
				for _, p in ipairs(list) do
					if type(p) == "table" and p.pos and p.pos.x and p.pos.y then
						local pname = p.name or p.pilotName or p.initiator
						local unit = p.initiator
						local missionNo
						if type(pname) == "string" then
							local mm, uu = string.match(pname, "^Mis(%d+)_Pilot_(.-)_Nb%d+$")			--nom fabrique par DCE_EventsTracker : Mis<n>_Pilot_<unite>_Nb<k>
							if mm then
								missionNo = tonumber(mm)
								unit = unit or uu
							end
						end

						local inc = {
							kind = "pilot_sar",
							name = pname,
							unit = unit,
							flight = flightOf(unit),
							side = p.sideName,
							category = "pilot",
							x = p.pos.x, y = p.pos.y, z = p.pos.z,
							posSrc = "sar",
							status = p.status,
							info = zoneName,
							missionNo = missionNo,
							current = (missionNo == nil) or (missionNo == tonumber(camp.mission)),
						}
						add(inc)
						if inc.current and unit then
							sarByUnit[unit] = inc
						end
					end
				end
			end
		end
	end

	--avion perdu sans position : on prend le point d'atterrissage de son pilote (approximatif : le parachute derive)
	for _, inc in ipairs(incidents) do
		if inc.kind == "air_lost" and not inc.x then
			local sar = sarByUnit[inc.name]
			if sar then
				inc.x, inc.y, inc.z, inc.posSrc = sar.x, sar.y, sar.z, "sar_approx"
			end
		end
	end

	----------------------------------------------------------------
	-- impacts de bombes (scen_destroyed)
	----------------------------------------------------------------
	if type(scen_log) == "table" then
		for _, s in pairs(scen_log) do
			if (s.event == "BOMB_IMPACT" or s.event == "BOMB_IMPACT_ZONE") and s.x and s.y then
				local inc = {
					t = s.time,
					kind = "bomb",
					category = "weapon",
					x = s.x, y = s.y, z = s.z,
					posSrc = "impact",
					weapon = s.weaponName,
					mass = s.explosiveMass,
					info = s.event,
				}
				setKiller(inc, s.initiator, nil)
				inc.side = inc.killerSide
				add(inc)
			end
		end
	end

	----------------------------------------------------------------
	-- tri par heure, puis ecriture
	----------------------------------------------------------------
	table.sort(incidents, function(a, b)
		local ta, tb = a.t or 0, b.t or 0
		if ta ~= tb then return ta < tb end
		return a.id < b.id
	end)
	for i, inc in ipairs(incidents) do
		inc.id = i
	end

	--joueurs par vol : pilotOf[unite] = nom du joueur -> players[vol] = { noms }
	local players = {}
	local unitPlayers = {}
	for unit, pname in pairs(pilotOf) do
		unitPlayers[unit] = pname
		local fl = flightOf(unit)
		if fl then
			players[fl] = players[fl] or {}
			local already = false
			for _, n in ipairs(players[fl]) do
				if n == pname then already = true end
			end
			if not already then table.insert(players[fl], pname) end
		end
	end
	for _, list in pairs(players) do
		table.sort(list)
	end

	local out = {
		version = 1,
		mission = camp.mission,
		campaign = camp.title,
		date = { day = camp.date.day, month = camp.date.month, year = camp.date.year },
		campTime = camp.time,
		nbIncidents = #incidents,
		unmatched = unmatched,
		incidents = incidents,
		players = players,
		unitPlayers = unitPlayers,
		flights = flights,
	}

	local path = "Debriefing/DebriefEvents " .. tostring(camp.mission) .. ".lua"
	local f = io.open(path, "w")
	if not f then
		error("cannot write " .. path)
	end
	f:write("debriefEvents = " .. TableSerialization(out, 0))
	f:close()

	if DCEM_MachineMode then
		print("##DCEM_DEBRIEFEVENTS_PATH##" .. path)
	end
	if Debug and Debug.debug then
		print("DEBRIEF_ExportMap : " .. #incidents .. " incident(s) written in " .. path)
	end
end

local ok, err = pcall(ExportMap)
if not ok then
	print("DEBRIEF_ExportMap : export failed, debriefing continues. " .. tostring(err))
	local errFile = io.open("Debug/ExportMap_error.txt", "w")
	if errFile then
		errFile:write(tostring(err))
		errFile:close()
	end
end
