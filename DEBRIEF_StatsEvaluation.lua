--To evaluate the DCS debrief.log and update the campaign status files
--Initiated by DEBRIEF_Master.lua
-------------------------------------------------------------------------------------------------------
-- last modification:  debug_m
if not versionDCE then versionDCE = {} end
versionDCE["DEBRIEF_StatsEvaluation.lua"] = "2.9.71"
------------------------------------------------------------------------------------------------------- 

if Debug.debug then
	print("START DEBRIEF_StatsEvaluation.lua "..versionDCE["DEBRIEF_StatsEvaluation.lua"].." =-=-=-=-=-=-=-=-=-=-=-=-=-=-=")
end

local t0 = os.clock()
local t_a  = 0
local t_b = 0
local t_c = 0

local t_bomb = 0
local t_runway = 0
local t_task = 0
local t_LL = 0
local t_SAR = 0
local t_hit = 0

--Global variable
packstats = {}	--track stats for player package
-- taille d'une cellule de la grille spatiale (en mètres)
GridCellSize = 1000


if not AcceptedMission then
	oob_air = DeepCopy(oob_air)
	oob_ground = DeepCopy(oob_ground)
	targetlist = DeepCopy(targetlist)
	clientstats = DeepCopy(clientstats)
	camp = DeepCopy(camp)
	camp_ZoneSAR = DeepCopy(camp_ZoneSAR)
	oob_scen = DeepCopy(oob_scen)

	print()
else

	oob_air = nil
	dofile("Active/oob_air.lua")
	oob_air = oob_air or {} -- Assurez que c'est une table, même après un reset

	oob_ground = nil
	dofile("Active/oob_ground.lua")
	

	--clean All Id 
	AllIdGroupImport = false
	AllIdUnitImport = false

	-- GetAllId()

	--TODO attention, surveiller les conséquences de ces lignes plus bas (est-ce que ça double? ou revient à 0?)
	targetlist = nil
	dofile("Active/targetlist.lua")

	clientstats = nil
	dofile("Active/clientstats.lua")

	camp = nil

	--camp full type A
	dofile("Active/camp_status.lua")

	--camp light type B
	local campExport = loadfile("camp_status.lua")()												--camp_status
	
	if campL then
		--merge camp full and camp light
		for k,v in pairs(camp) do
			for kk,vv in pairs(campL) do
				if k == kk then
					v = vv
				end
			end	
		end	

		-- add keys from campL that are not in camp
		for kk,vv in pairs(campL) do
			if not camp[kk] then
				camp[kk] = vv
			end
		end
	end

	
	camp.mission = camp.mission + 1

	camp_ZoneSAR = nil

	local zoneSARFile = "Active/camp_ZoneSAR.lua"
	local testPath = io.open(zoneSARFile, "r")																--cette maniere de chercer la presence d un fichier evite un plantage
	if testPath ~= nil then																					--check si le fichier existe dans ScriptsMod
		io.close(testPath)
		require("Active/camp_ZoneSAR")																--zoneSAR
	end

	oob_scen = nil
	dofile("Active/oob_scen.lua")

end

require("Active/last_Mission")

dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_UpdateSAR.lua")

--reset air oob last mission stats
for side_name,side in pairs(oob_air) do														--iterate through all sides
	for unit_n,unit in pairs(side) do														--iterate through all air units
		unit.score_last = {
			kills_air = 0,
			kills_ground = 0,
			kills_ship = 0,
			lost = 0,
			damaged = 0,
			ready = 0
		}
	end
end

--reset ground oob last mission stats
for side_name,side in pairs(oob_ground) do													--side table(red/blue)											
	for country_n,country in pairs(side) do													--country table (number array)
		if country.vehicle then																--if country has vehicles
			for group_n,group in pairs(country.vehicle.group) do							--groups table (number array)
				for unit_n,unit in pairs(group.units) do									--units table (number array)	
					unit.dead_last = false													--reset unit died in last mission
					if unit.lasthit then unit.lasthit = false end
				end
			end
		end
		if country.static then																--if country has static objects
			for group_n,group in pairs(country.static.group) do								--groups table (number array)
				group.dead_last = nil
				for unit_n,unit in pairs(group.units) do									--units table (number array)	
					unit.dead_last = false													--reset unit died in last mission
				end
			end
		end
		if country.ship then																--if country has ships
			for group_n,group in pairs(country.ship.group) do								--groups table (number array)
				for unit_n,unit in pairs(group.units) do									--units table (number array)	
					unit.dead_last = false													--reset unit died in last mission
				end
			end
		end
	end
end

for side_name, targets in pairs(targetlist) do													--iterate through targetlist
	for targetN, target in pairs(targets) do												--iterate through targets
		target.alive_last = nil
		if target.elements and target.elements[1].x then									--if the target has subelements and is a scenery object target (element has x coordinate)		
			for element_n,element in pairs(target.elements) do								--iterate through target elements
				element.dead_last = false													--reset element died in last mission
				element.lasthit = false
			end
		end
	end
end

local initTabValues = {
	kills_air = 0,
	kills_ground = 0,
	kills_ship = 0,
	mission = 0,
	crash = 0,
	eject = 0,
	dead = 0,
	POW = 0,
	MIA = 0,
	rescued = 0,
	rescue = 0,
	-- score_last = {
	-- 	kills_air = 0,
	-- 	kills_ground = 0,
	-- 	kills_ship = 0,
	-- 	mission = 0,
	-- 	crash = 0,
	-- 	Time_Crash = 0,
	-- 	eject = 0,
	-- 	Time_Eject = 0,
	-- 	POW = 0,
	-- 	Time_POW = 0,
	-- 	MIA = 0,
	-- 	rescued = 0,
	-- 	Time_rescued = 0,
	-- 	rescue = 0,
	-- 	Time_rescue = 0,
	-- 	Time_MIA = 0,
	-- 	dead = 0,
	-- 	Time_Dead = 0,
	-- }
}

--ajoute les key manquantes si cette update se fait en cours de campaggne
for init_k, init_v in pairs(initTabValues) do
	if type(init_v) ~= "table" then
		for client, clientStat in pairs(clientstats) do
			for client_k, client_v in pairs(clientStat) do
				if type(client_v) ~= "table" then

					if not clientStat[init_k] then
						clientStat[init_k] = 0
					end

				end
			end
		end
	end

end

--reset client last mission stats
for k,v in pairs(clientstats) do

	v.score_last = {
		kills_air = 0,
		kills_ground = 0,
		kills_ship = 0,
		mission = 0,
		crash = 0,
		eject = 0,
		dead = 0,
		POW = 0,
		MIA = 0,
		rescued = 0,
		rescue = 0,

		Time_rescue = 0,
		Time_rescued = 0,
		Time_Crash = 0,
		Time_Eject = 0,
		Time_POW = 0,
		Time_MIA = 0,
		Time_Dead = 0,
	}
end

local clientControl = {}																	--local table to store which client controls which unit
local hitTbl_KillerByTarget = {}																		--local table to store who was the last hitter to hit a unit
local health_table = {}																		--local table to store health of a hit unit
local client_hit_table = {}																	--local table to store if a client has hit a unit
local logistic_table = {}																	--local table to store if landing logistic plane
local statutObject = {}
local clientstatsDetail = {}


--function to add new clients to clientstats
local function addClient(name)

	local tabValues = {
		kills_air = 0,
		kills_ground = 0,
		kills_ship = 0,
		mission = 0,
		crash = 0,
		eject = 0,
		dead = 0,
		POW = 0,
		MIA = 0,
		rescued = 0,
		rescue = 0,
		score_last = {
			kills_air = 0,
			kills_ground = 0,
			kills_ship = 0,
			mission = 0,
			crash = 0,
			Time_Crash = 0,
			eject = 0,
			Time_Eject = 0,
			POW = 0,
			Time_POW = 0,
			MIA = 0,
			rescued = 0,
			Time_rescued = 0,
			rescue = 0,
			Time_rescue = 0,
			Time_MIA = 0,
			dead = 0,
			Time_Dead = 0,
		}
	}

	if clientstats[name] == nil then														--if client has no previous stats entry, create a new one
		clientstats[name] = tabValues
	else
		--ajoute les clefs manquantes pour rétrocomtabilité
		for key, value in pairs(tabValues) do
			local foundKey = false
			for clientK, clientV in pairs(clientstats[name]) do
				if key == clientK then
					foundKey = true
					break
				end

			end
			if not foundKey then
				clientstats[name][key] = 0
			end
		end
	end
end

-- pack_n
if camp.player then

	camp.player.pack = camp.player.package[camp.player.pack_n]

elseif camp.client then --par defaut, compatible avec les anciens debrief

	camp["player"] = {
		["pack"] = camp.client[1].pack
	}

	camp.player.role = camp.client[1].role
	camp.player.flight = camp.client[1].flight
	camp.player.side = camp.client[1].side
	camp.player.airbase = camp.client[1].airbase
	camp.player.pack_n = camp.client[1].pack_n
	camp.player.task = camp.client[1].task
	camp.player.tgt_wp = camp.client[1].tgt_wp
	camp.player.unitname = camp.client[1].unitname

end

	local camp_str = "camp.player = " .. TableSerialization(camp.player, 0)
	local campFile = io.open("Debug/camp_player.lua", "w") or error("Failed to open debug file")
	campFile:write(camp_str)
	campFile:close()

for roleName, role in pairs(camp.player.pack) do														--iterate through roles in player package
	for flightN, flight in pairs(role) do																--iterate through flights
		if type(flight) == "table" and flight.units then
			for unitN, unit in pairs(flight.units) do
				packstats[unit.name] = {
					kills_air = 0,
					kills_ground = 0,
					kills_ship = 0,
					lost = 0,
				}
			end
		end
	end
end

-- end
--function to check if a kill loss is attributed to the player package
local function addPackstats(unitname, event, eventTable)

	unitname = unitname:gsub("Recovery ", "")

	if packstats[unitname] then																			--aircraft was part of the package
		if event == "kill_air" then
			packstats[unitname].kills_air = packstats[unitname].kills_air + 1
		elseif event == "kill_ground" then
			packstats[unitname].kills_ground = packstats[unitname].kills_ground + 1
		elseif event == "kill_ship" then
			packstats[unitname].kills_ship = packstats[unitname].kills_ship + 1
		elseif event == "lost" then
			packstats[unitname].lost = packstats[unitname].lost + 1
		end
	end
end

local c_b = os.clock()

--prepare client stats
for e = 1, #events do																					--iterate through all events
	if events[e].initiatorPilotName then
		-- print("DebriefSE e: "..tostring(e).." initiatorPilotName: "..tostring( events[e].initiatorPilotName).." initiator: "..tostring(events[e].initiator))
	end

	if events[e].initiator and string.find(events[e].initiator, "parachut") then
		events[e].initiator = tostring(events[e].initiatorPilotName)
	end

	if events[e].initiatorPilotName and type(events[e].initiatorPilotName) == "string" and events[e].initiatorPilotName ~= "nil" then	--event is by a client
		addClient(events[e].initiatorPilotName)
		clientControl[events[e].initiator] = events[e].initiatorPilotName								--store which unit name (initiaror) is controllen by cliend (PilotName)
	end
end

for e = 1, #events do																					--iterate through all events
	
	-- print("A events[e].initiator "..tostring(events[e].initiator))
	-- _affiche( events[e], "events[e]: ")
	-- _affiche( clientControl, "clientControl: ")

	if events[e].initiator then
		if events[e].pilotName then
			-- print("DebriefSE e: "..tostring(e).." pilotName: "..tostring( events[e].pilotName).." initiator: "..tostring(events[e].initiator))
		end

		if events[e].initiator and string.find(events[e].initiator, "parachut") then
			events[e].initiator = tostring(events[e].pilotName)
		end

		if events[e].pilotName and type(events[e].pilotName) == "string" and events[e].pilotName ~= "nil" then	--event is by a client
			addClient(events[e].pilotName)
			clientControl[events[e].initiator] = events[e].pilotName								--store which unit name (initiaror) is controllen by cliend (PilotName)
		end
	end
end

local tabTransport = {}

--------------------------------------------------------
-- cache de résolution des killers air (clé = initiator)
--------------------------------------------------------
AirKillerCache = {}

-- échappe les caractères spéciaux Lua pattern
-- nécessaire pour un string.find fiable
local function escapePattern(str)
	return str:gsub("(%W)", "%%%1")
end

----------------------------------------------------------------
-- INDEX DES SQUADRONS AIR (clé = nom échappé)
----------------------------------------------------------------

AirSquadronIndex = {}   -- [{ pattern=..., unit=..., side=... }]

for sideName, side in pairs(oob_air) do
	for _, unit in pairs(side) do
		unit.side = sideName

		table.insert(AirSquadronIndex, {
			pattern = escapePattern(unit.name),
			unit    = unit,
			side    = sideName,
		})
	end
end


--------------------------------------------------------
-- résout un initiator DCS vers une unité air (avec cache)
--------------------------------------------------------
local function resolveAirSquad(initiator)
	if not initiator then return nil end

	-- 1) cache hit (y compris false)
	if AirKillerCache[initiator] ~= nil then
		return AirKillerCache[initiator]
	end

	-- 2) recherche dans l’index des squadrons
	for _, entry in ipairs(AirSquadronIndex) do
		if string.find(initiator, entry.pattern, 1) then
			AirKillerCache[initiator] = entry.unit
			return entry.unit
		end
	end

	-- 3) aucun match (on mémorise aussi l’échec)
	AirKillerCache[initiator] = false
	return nil
end
-- index direct des unités ground par nom
GroundUnitByName = {}        -- ["SAM-1"] = { unit=ref, side=..., class=... }

for sideName, side in pairs(oob_ground) do
	for _, country in pairs(side) do
		for class, typetable in pairs(country) do
			if type(typetable) == "table" and typetable.group then
				for _, group in pairs(typetable.group) do
					for _, unit in pairs(group.units) do
						unit["class"] = class
						unit["side"] = sideName

						GroundUnitByName[unit.name] = unit
					end
				end
			end
		end
	end
end


-- pré-calcul des targets "structure"
-- évite le scan string.lower / string.find à chaque explosion
for _, sides in pairs(targetlist) do
	for _, target in pairs(sides) do
		target.isStructure = false
		if target.attributes then
			for _, attr in pairs(target.attributes) do
				local a = string.lower(attr)
				if a == "structure" or a == "building" then
					target.isStructure = true
					break
				end
			end
		end
	end
end

--evaluate log events
for e = 1, #events do

	local initiator = events[e].initiator or "nil"
	local target = events[e].target or "nil"
	local eventType = events[e].type or "nil"

	if initiator and not statutObject[initiator] then
		statutObject[initiator] = {
			birth = false,
			hit = false,
			kill = false,
			crash = false,
			eject = false,
			takeoff = false,
			["pilot land"] = false,
			["pilot dead"] = false,
			["unit lost"] = false,

		}
	end

	if target and not statutObject[target] then
		statutObject[target] = {
			birth = false,
			hit = false,
			kill = false,
			crash = false,
			eject = false,
			takeoff = false,
			["pilot land"] = false,
			["pilot dead"] = false,
			["unit lost"] = false,

		}
	end

	--review all events for stats updates
	if eventType == "birth" then																		--hit events
		statutObject[initiator] = {
			birth = true,
			hit = false,
			kill = false,
			crash = false,
			eject = false,
			takeoff = false,
			["pilot land"] = false,
			["pilot dead"] = false,
			["unit lost"] = false,

		}
	-- elseif eventType == "unit lost" then																		--hit events
	-- 	statutObject[initiator]["unit lost"] = true

	-- elseif eventType == "hit"  and  not statutObject[target]["unit lost"] then				--  statutObject[target] ~= "unit lost"														--hit events
	elseif eventType == "hit" and target and not statutObject[target].kill and not statutObject[target].crash then
		hitTbl_KillerByTarget[target] = initiator												--store who hits a target (subsequent hits overwrite previous hits)
		statutObject[target].hit = true
		health_table[target] = events[e].health												--store health of the target
		client_hit_table[target] = clientControl[initiator]						--store client name that has hit a unit (stores nil  if hitter is not a client)

	elseif eventType == "crash" and initiator then
		--oob loss update for crashed aircraft
		if statutObject[initiator].kill == false   then --and  statutObject[initiator] ~= "unit lost"
			local crash_side																				--local variable to store the side of the crashed aircraft
			
			local crash_squad = resolveAirSquad(initiator)
			if crash_squad then

			-- for killer_side_name,killer_side in pairs(oob_air) do											--iterate through all sides
			-- 	for killer_unit_n,killer_unit in pairs(killer_side) do										--iterate through all air units
			-- 		if events[e].initiator and string.find(events[e].initiator, " " .. killer_unit.name .. " ", 1, true) then		--if the crashed aircraft name is part of air unit name
				
			
				crash_side = crash_squad.side														--store side of the crashed aircraft
				crash_squad.roster.lost = crash_squad.roster.lost + 1								--increase loss counter of air unit
				crash_squad.score_last.lost = crash_squad.score_last.lost + 1						--increase loss counter for this mission of air unit
				crash_squad.roster.ready = crash_squad.roster.ready - 1								--decrease number of ready aircraft of air unit
				crash_squad.score_last.ready = crash_squad.score_last.ready + 1						--decrease number of ready aircraft for this mission of air unit
				addPackstats(initiator, "lost", events[e])											--check if loss was in player package

				--client stats for crashes
				if clientControl[initiator] and ( (events[e].t - clientstats[clientControl[initiator]].score_last.Time_Crash) >   30) then											--if crashed aircraft is a client

					clientstats[clientControl[initiator]].crash = clientstats[clientControl[initiator]].crash + 1	--store crash for client
					clientstats[clientControl[initiator]].score_last.crash =  clientstats[clientControl[initiator]].score_last.crash + 1			--store crash for client
					clientstats[clientControl[initiator]].score_last.Time_Crash = events[e].t

				end
			end

			--oob kill update for crashed aircraft
			-- for killer_side_name,killer_side in pairs(oob_air) do											--iterate through all sides
			-- 	for killer_unit_n,killer_unit in pairs(killer_side) do										--iterate through all air units
			if hitTbl_KillerByTarget[initiator] ~= nil then											--check if the crashed aircraft has a hit entry
				-- if string.find(hit_table[initiator], " " .. killer_unit.name .. " ", 1, true) then			--if the hitting unit is part of air unit name
					
				local killer_squad = resolveAirSquad(hitTbl_KillerByTarget[initiator])
				if killer_squad then

					if crash_side ~= killer_squad.side then											--make sure that hitting unit and crashed aircraft are not on same side (friendly fire is not awarded as kill)
						killer_squad.score.kills_air = killer_squad.score.kills_air + 1				--award air kill to air unit
						killer_squad.score_last.kills_air = killer_squad.score_last.kills_air + 1		--increase kill counter for this mission of air unit
						addPackstats(hitTbl_KillerByTarget[initiator], "kill_air", events[e])					--check if kill was in player package

						--client stats for kills
						-- if client_hit_table[initiator] then								--if crashed aircraft was hit by a client
						if clientControl[initiator] and ( (events[e].t - clientstats[clientControl[initiator]].score_last.Time_kills_air) >   30) then											--if crashed aircraft is a client

							clientstats[client_hit_table[initiator]].kills_air = clientstats[client_hit_table[initiator]].kills_air + 1	--award air kill to client
							clientstats[client_hit_table[initiator]].score_last.kills_air = clientstats[client_hit_table[initiator]].score_last.kills_air + 1
						end
					end
				end
			end

			if hitTbl_KillerByTarget[initiator] then
				hitTbl_KillerByTarget[initiator] = nil															--once kills for the dead aircraft are awarded, remove it from the hit_table. The aircraft remaining in the hit_table after completed log evaluation are only damaged.
			end
		end
		statutObject[initiator].crash = true

	elseif eventType == "kill" then
		--oob loss update for crashed aircraft
		local targetSide																				--local variable to store the side of the crashed aircraft
		local targetIsPlane
		local killerIsPlane
		-- local tagBreak

		-- for target_side_name, target_side in pairs(oob_air) do											--iterate through all sides
		-- 	if target_side_name and type(target_side) == "table" then
		-- 		for target_unit_n, target_unit in pairs(target_side) do										--iterate through all air units
					
		local target_unit = resolveAirSquad(target)
		if target_unit then

			targetIsPlane = true
			targetSide = target_unit.side														--store side of the crashed aircraft
			target_unit.roster.lost = target_unit.roster.lost + 1								--increase loss counter of air unit
			target_unit.score_last.lost = target_unit.score_last.lost + 1						--increase loss counter for this mission of air unit
			target_unit.roster.ready = target_unit.roster.ready - 1								--decrease number of ready aircraft of air unit
			target_unit.score_last.ready = target_unit.score_last.ready + 1						--decrease number of ready aircraft for this mission of air unit
			addPackstats(target, "lost", events[e])											--check if loss was in player package

			--client stats for crashes
			if clientControl[target] and ( (events[e].t - clientstats[clientControl[target]].score_last.Time_Crash) >   30) then											--if crashed aircraft is a client

				clientstats[clientControl[target]].crash = clientstats[clientControl[target]].crash + 1	--store crash for client
				clientstats[clientControl[target]].score_last.crash =  clientstats[clientControl[target]].score_last.crash + 1			--store crash for client
				clientstats[clientControl[target]].score_last.Time_Crash = events[e].t

			end

			--oob kill update for crashed aircraft

			-- for killer_side_name, killer_side in pairs(oob_air) do											--iterate through all sides
			-- 	for killer_unit_n, killer_unit in pairs(killer_side) do										--iterate through all air units
			-- 		if hitTbl_KillerByTarget[target] ~= nil then											--check if the crashed aircraft has a hit entry
			-- 			if string.find(hitTbl_KillerByTarget[target], " " .. killer_unit.name .. " ", 1, true) then			--if the hitting unit is part of air unit name
			if hitTbl_KillerByTarget[target] ~= nil then				
				local killer_unit = resolveAirSquad(hitTbl_KillerByTarget[target])
				if killer_unit then
				
					killerIsPlane = true
					killer_unit.score.kills_air = killer_unit.score.kills_air + 1				--award air kill to air unit
					killer_unit.score_last.kills_air = killer_unit.score_last.kills_air + 1		--increase kill counter for this mission of air unit
					addPackstats(hitTbl_KillerByTarget[target], "kill_air", events[e])					--check if kill was in player package

					--client stats for kills
					if client_hit_table[target] then								--if crashed aircraft was hit by a client

						clientstats[client_hit_table[target]].kills_air = clientstats[client_hit_table[target]].kills_air + 1	--award air kill to client
						clientstats[client_hit_table[target]].score_last.kills_air = clientstats[client_hit_table[target]].score_last.kills_air + 1
					end
				end
			end

			--?????????????what?????????????
			-- if targetIsPlane and hitTbl_KillerByTarget[target] then
			-- 	hitTbl_KillerByTarget[target] = nil															--once kills for the dead aircraft are awarded, remove it from the hit_table. The aircraft remaining in the hit_table after completed log evaluation are only damaged.
			-- end

		elseif target and string.find(target, "Manhunt") then

			targetIsPlane = false

			addPackstats(hitTbl_KillerByTarget[target], "kill_ground", events[e])						--check if kill was in player package

			clientstats[clientControl[initiator]].kills_ground = clientstats[clientControl[initiator]].kills_ground + 1							--award gound kill to client
			clientstats[clientControl[initiator]].score_last.kills_ground = clientstats[clientControl[initiator]].score_last.kills_ground + 1		--award ground kill to client

			local item = {
				event = events[e],
				unit = events[e].target,
			}

		end



		if targetIsPlane and last_Mission then

			local task = "inc"
			local targetName = ""
			local lostType = ""
			local tagbreak = false

			for _side, side in pairs(last_Mission.coalition) do
				for _country, country in pairs(side.country) do
					if _side == targetSide then
						for chapterName, chapter in pairs(country) do
							if type(chapter) == "table" and chapter.group then
								for Ngroup, group in pairs(chapter.group) do
									for n=1, #group.units do
										if group.units[n].unitId == tonumber(events[e].targetMissionID) then
											task = group.task
											targetName = group.DCE_targetName
											lostType = group.units[n].type
											tagbreak = true
											break
										end
									end
									if tagbreak then break end
								end
							end
							if tagbreak then break end
						end
					end
					if tagbreak then break end
				end
				if tagbreak then break end
			end

			if targetName == nil then
				targetName = "test"
			 end

			if tagbreak == false then _affiche(events[e], "DebriefSE NothingFound in relation to last_Mission ") end

			if not task then task = "inc" end

			if not camp.statLost then camp.statLost = {} end
			if not camp.statLost[targetSide] then camp.statLost[targetSide] = {} end
			if not camp.statLost[targetSide][targetName] then camp.statLost[targetSide][targetName] = {} end

			if not camp.statLost[targetSide][targetName][lostType] then camp.statLost[targetSide][targetName][lostType] = {} end
			if not camp.statLost[targetSide][targetName][lostType][task] then
				camp.statLost[targetSide][targetName][lostType][task] = {
					nbTotal = 0,
					nbKillerIsPlane = 0,
					nbKillerIsSAM = 0,
					lastMission = camp.mission,
				}
			end

			if killerIsPlane then

				camp.statLost[targetSide][targetName][lostType][task].nbTotal = camp.statLost[targetSide][targetName][lostType][task].nbTotal + 1
				camp.statLost[targetSide][targetName][lostType][task].nbKillerIsPlane = camp.statLost[targetSide][targetName][lostType][task].nbKillerIsPlane + 1
				camp.statLost[targetSide][targetName][lostType][task].lastMission = camp.mission
			else
				camp.statLost[targetSide][targetName][lostType][task].nbKillerIsSAM = camp.statLost[targetSide][targetName][lostType][task].nbKillerIsSAM + 1
				camp.statLost[targetSide][targetName][lostType][task].lastMission = camp.mission
			end
		end

		statutObject[target].kill = true

	elseif eventType == "eject" and events[e].initiator then
		--client stats for ejections
		if clientControl[initiator] and ( (events[e].t - clientstats[clientControl[initiator]].score_last.Time_Eject) >   30)  then														--if ejected pilot is a client

			clientstats[clientControl[initiator]].eject = clientstats[clientControl[initiator]].eject + 1	--store ejection for client
			clientstats[clientControl[initiator]].score_last.eject =  clientstats[clientControl[initiator]].score_last.eject + 1						--store eject for client
			clientstats[clientControl[initiator]].score_last.Time_Eject = events[e].t

			if statutObject[initiator]["unit lost"] then
				clientstats[clientControl[initiator]].dead = clientstats[clientControl[initiator]].dead - 1	--store death for client
				clientstats[clientControl[initiator]].score_last.dead =  clientstats[clientControl[initiator]].score_last.dead - 1						--store dead pilot for client
				clientstats[clientControl[initiator]].score_last.Time_Dead = 0
				statutObject[initiator]["pilot dead"] =  false
				statutObject[initiator]["unit lost"] =  false
			end
		end
		statutObject[initiator].eject = true
	elseif eventType == "pilot dead" and events[e].initiator then
		--client stats for dead pilots
		if clientControl[initiator] and ( (events[e].t - clientstats[clientControl[initiator]].score_last.Time_Dead) >   30) then														--if dead pilot is a client
			clientstats[clientControl[initiator]].dead = clientstats[clientControl[initiator]].dead + 1	--store death for client
			clientstats[clientControl[initiator]].score_last.dead =  clientstats[clientControl[initiator]].score_last.dead + 1						--store dead pilot for client
			clientstats[clientControl[initiator]].score_last.Time_Dead = events[e].t
		end
		statutObject[initiator]["pilot dead"] =  true

	elseif eventType == "pilot land" and events[e].initiator then

		--client stats for landing pilots
		if clientControl[initiator] and ( (events[e].t - clientstats[clientControl[initiator]].score_last.Time_MIA) >   30) then														--if landing pilot is a client
			clientstats[clientControl[initiator]].MIA = clientstats[clientControl[initiator]].MIA + 1	--store MIA for client
			clientstats[clientControl[initiator]].score_last.MIA =  1						--store MIA pilot for client
			clientstats[clientControl[initiator]].score_last.Time_MIA = events[e].t

			-- print("DebriefSE initiator "..tostring(events[e].initiator).." MIA: "..tostring(clientstats[client_control[initiator]].MIA))

		end
		statutObject[initiator]["pilot land"] = true

	elseif eventType == "takeoff" and events[e].initiator then
		--client stats for flown missions
		if clientControl[initiator] then														--if take off is by a client
			if clientstats[clientControl[initiator]].score_last.mission == 0 then			--client has no take off logged yet for this mission
				clientstats[clientControl[initiator]].mission = clientstats[clientControl[initiator]].mission + 1	--increase flown mission number
				clientstats[clientControl[initiator]].score_last.mission = 1					--store mission for client
			end
		end
		statutObject[initiator].takeoff = true

	elseif eventType == "embarkedEjectedPilot" then
		--l'initiator sauve quelqu'un
		if clientControl[initiator] and ( (events[e].t - clientstats[clientControl[initiator]].score_last.Time_rescue ) > 30) then
			clientstats[clientControl[initiator]].rescue  = clientstats[clientControl[initiator]].rescue  + 1
			clientstats[clientControl[initiator]].score_last.rescue  = clientstats[clientControl[initiator]].score_last.rescue + 1
			clientstats[clientControl[initiator]].score_last.Time_rescue =  events[e].t
		end
		--le pilote sauvé est le target
		if clientControl[target] and ( (events[e].t - clientstats[clientControl[target]].score_last.Time_rescued ) > 30) then
			clientstats[clientControl[target]].rescued  = clientstats[clientControl[target]].rescued  + 1
			clientstats[clientControl[target]].score_last.rescued  = clientstats[clientControl[target]].score_last.rescued + 1
			clientstats[clientControl[target]].score_last.Time_rescued =  events[e].t

			clientstats[clientControl[target]].MIA = clientstats[clientControl[target]].MIA - 1
			clientstats[clientControl[target]].score_last.MIA =  -1
		end
		--le pilote sauvé est le target (prise en compte du PilotName s'il existe)
		if clientstats[events[e].targetPilotName] and ( (events[e].t - clientstats[events[e].targetPilotName].score_last.Time_rescued ) > 30) then
			clientstats[events[e].targetPilotName].rescued  = clientstats[events[e].targetPilotName].rescued  + 1
			clientstats[events[e].targetPilotName].score_last.rescued  = clientstats[events[e].targetPilotName].score_last.rescued + 1
			clientstats[events[e].targetPilotName].score_last.Time_rescued =  events[e].t

			clientstats[events[e].targetPilotName].MIA = clientstats[events[e].targetPilotName].MIA - 1
			clientstats[events[e].targetPilotName].score_last.MIA =  -1
		end

	elseif eventType == "land" then
		--client stats for land
		if clientControl[initiator] then														--if take off is by a client
			if clientstats[clientControl[initiator]].score_last.mission == 0 then			--client has no take off logged yet for this mission
				clientstats[clientControl[initiator]].mission = clientstats[clientControl[initiator]].mission + 1	--increase flown mission number
				clientstats[clientControl[initiator]].score_last.mission = 1					--store mission for client
			end
		end

		if events[e].initiator and string.find(events[e].initiator,"Transport") and not tabTransport[initiator] then
			local payload  = 0

			if PayloadType[events[e].type_name] then
				payload  = PayloadType[events[e].type_name]																--see UTIL_Data.lua
			end

			if events[e].place then
				if db_airbases[events[e].place]  then
					if not db_airbases[events[e].place].logistic then
						db_airbases[events[e].place].logistic = 0
					end
					db_airbases[events[e].place].logistic = db_airbases[events[e].place].logistic + payload
					tabTransport[initiator] = true
				elseif db_airbases[events[e].place.." Airbase"] then
					if not db_airbases[events[e].place.." Airbase"].logistic then
						db_airbases[events[e].place.." Airbase"].logistic = 0
					end
					db_airbases[events[e].place.." Airbase"].logistic = db_airbases[events[e].place.." Airbase"].logistic + payload
					tabTransport[initiator] = true
				end
			end
		end

		if events[e].initiator then	statutObject[initiator].land = true end

	elseif (eventType == "dead" or eventType == "unit lost") and initiator then

		--client stats for dead pilots
		if clientControl[initiator] and ( (events[e].t - clientstats[clientControl[initiator]].score_last.Time_Dead) > 30) then
	
			clientstats[clientControl[initiator]].dead = clientstats[clientControl[initiator]].dead + 1	--store death for client
			clientstats[clientControl[initiator]].score_last.dead =  clientstats[clientControl[initiator]].score_last.dead + 1						--store dead pilot for client
			clientstats[clientControl[initiator]].score_last.Time_Dead = events[e].t
			statutObject[initiator]["pilot dead"] =  true
			if eventType == "unit lost" then
				statutObject[initiator]["unit lost"] = true
			end
		end

		--ground/naval/static loss events																--iterate through all the sub-tables of the oob_ground files and try to find the matching unitId of the dead unit (vehicle/ship/static)
		if eventType == "unit lost" then																		--hit events
			statutObject[initiator]["unit lost"] = true
		end

		-- for side_name,side in pairs(oob_ground) do														--side table(red/blue)											
		-- 	for country_n,country in pairs(side) do														--country table (number array)
				
		local unit = GroundUnitByName[initiator]
		if unit then
		
			if unit.class == "vehicle" then
				unit.dead = true														--mark unit as dead in oob_ground
				unit.dead_last = true													--mark unit as died in last mission
				unit.CheckDay = camp.date.CampTotalTimeS                            -- ajoute la date de destruction		 Miguel21 modification M19 : Repair SAM	

				--award ground kill to air unit
				if hitTbl_KillerByTarget[initiator] ~= nil then														--check if dead vehicle has a hit entry
					-- for killer_side_name,killer_side in pairs(oob_air) do											--iterate through all sides
					-- 	for killer_unit_n,killer_unit in pairs(killer_side) do										--iterate through all air units
					-- 		if string.find(hitTbl_KillerByTarget[initiator], " " .. killer_unit.name .. " ", 1, true) then	--if the hitting unit is part of air unit name
								
					local killer_unit = resolveAirSquad(hitTbl_KillerByTarget[initiator])
					if killer_unit then
						if unit.side ~= killer_unit.side then
							killer_unit.score.kills_ground = killer_unit.score.kills_ground + 1				--award ground kill to air unit
							killer_unit.score_last.kills_ground = killer_unit.score_last.kills_ground + 1
							addPackstats(hitTbl_KillerByTarget[initiator], "kill_ground", events[e])						--check if kill was in player package

							--award ground kill to client
							if client_hit_table[initiator] then									--if dead vehicle was hit by a client
								clientstats[client_hit_table[initiator]].kills_ground = clientstats[client_hit_table[initiator]].kills_ground + 1							--award gound kill to client
								clientstats[client_hit_table[initiator]].score_last.kills_ground = clientstats[client_hit_table[initiator]].score_last.kills_ground + 1		--award ground kill to client

								local item = {
									event = events[e],
									unit = unit,
								}

								if not clientstatsDetail[client_hit_table[initiator]] then clientstatsDetail[client_hit_table[initiator]] = {} end
								table.insert(clientstatsDetail[client_hit_table[initiator]], item)

							end
						end
					end
					hitTbl_KillerByTarget[initiator] = nil							--after kills are assigned, remove hit unit from hit_table
				end
								
			elseif unit.class == "ship" then

				unit.CheckDay = camp.date.CampTotalTimeS                            -- ajoute la date de destruction		 Miguel21 modification M19 : Repair SAM	
				camp.ShipHealth[unit.name] = 0										--mark unit has 0 health for briefing/Debriefing
				camp.ShipDamagedLast[unit.name] = true								--mark ship took damage in last mission for briefing/Debriefing

				--award ship kill to air unit
				if hitTbl_KillerByTarget[initiator] ~= nil then														--check if dead ship has a hit entry
					-- for killer_side_name,killer_side in pairs(oob_air) do											--iterate through all sides
					-- 	for killer_unit_n,killer_unit in pairs(killer_side) do										--iterate through all air units
					-- 		if string.find(hitTbl_KillerByTarget[initiator], " " .. killer_unit.name .. " ", 1, true) then	--if the hitting unit is part of air unit name
					-- 			if unit.side ~= killer_side_name then												--make sure that hitting unit is not on same side as dead unit (friendly fire gives no kills)
									
					local killer_unit = resolveAirSquad(hitTbl_KillerByTarget[initiator])
					if killer_unit then
						if unit.side ~= killer_unit.side then
							killer_unit.score.kills_ship = killer_unit.score.kills_ship + 1					--award ship kill to air unit
							killer_unit.score_last.kills_ship = killer_unit.score_last.kills_ship + 1
							addPackstats(hitTbl_KillerByTarget[initiator], "kill_ship", events[e])						--check if kill was in player package

							--award ship kill to client
							if client_hit_table[initiator] then									--if dead ship was hit by a client
								clientstats[client_hit_table[initiator]].kills_ship = clientstats[client_hit_table[initiator]].kills_ship + 1							--award ship kill to client
								clientstats[client_hit_table[initiator]].score_last.kills_ship = clientstats[client_hit_table[initiator]].score_last.kills_ship + 1		--award ship kill to client
							end
						end
					end
					hitTbl_KillerByTarget[initiator] = nil							--after kills are assigned, remove hit unit from hit_table
				end

			elseif unit.class == "static" then																--if country has static objects
				-- for group_n,group in pairs(country.static.group) do								--groups table (number array)
				-- 	for unit_n,unit in pairs(group.units) do									--units table (number array)
					
				if unit.name == initiator and not unit.dead then
--TODO, placer ce code dans update_oobGround
					-- if unit.dead ~= true then											--unit is not yet dead (some static objects that are spawned in a destroyed state are logged dead at mission start, these must be excluded here)
					-- group.dead = true												--mark group as dead in oob_ground (static objects can be set as group.dead and spawned in a destroyed state)
					-- if group.linkOffset then										--static unit was linked to a carrier
					-- 	group.linkOffset = false									--unlink  dead static from carrier
					-- 	group.x = 2000000
					-- 	group.y = 2000000
					-- 	group.units[1].x = 2000000
					-- 	group.units[1].y = 2000000
					-- 	group.route.points[1].x = 2000000
					-- 	group.route.points[1].y = 2000000
					-- end
					-- group.hidden = true	--TODO si le vehicle revit, il faudrait lui coller le hidden d'origine											--hide dead static object
					unit.dead = true												--mark unit as dead in oob_ground (this is for the targetlist)
					unit.dead_last = true											--mark unit as died in last mission
					unit.CheckDay = camp.date.CampTotalTimeS                            -- ajoute la date de destruction		 Miguel21 modification M19 : Repair SAM	

					--award ground kill to air unit
					if hitTbl_KillerByTarget[initiator] ~= nil then														--check if dead static has a hit entry
						-- for killer_side_name,killer_side in pairs(oob_air) do											--iterate through all sides
						-- 	for killer_unit_n,killer_unit in pairs(killer_side) do										--iterate through all air units
						-- 		if string.find(hitTbl_KillerByTarget[initiator], " " .. killer_unit.name .. " ", 1, true) then	--if the hitting unit is part of air unit name
						-- 			if side_name ~= killer_side_name then												--make sure that hitting unit is not on same side as dead unit (friendly fire gives no kills)
										
						local killer_unit = resolveAirSquad(hitTbl_KillerByTarget[initiator])
						if killer_unit then
							if unit.side ~= killer_unit.side then
						
								killer_unit.score.kills_ground = killer_unit.score.kills_ground + 1				--award ground kill to air unit
								killer_unit.score_last.kills_ground = killer_unit.score_last.kills_ground + 1
								addPackstats(hitTbl_KillerByTarget[initiator], "kill_ground", events[e])						--check if kill was in player package

								--award ground kill to client
								if client_hit_table[initiator] then									--if dead static was hit by a client
									clientstats[client_hit_table[initiator]].kills_ground = clientstats[client_hit_table[initiator]].kills_ground + 1							--award ground kill to client
									clientstats[client_hit_table[initiator]].score_last.kills_ground = clientstats[client_hit_table[initiator]].score_last.kills_ground + 1		--award ground kill to client

									local item = {
										event = events[e],
										unit = unit,
									}

									if not clientstatsDetail[client_hit_table[initiator]] then clientstatsDetail[client_hit_table[initiator]] = {} end
									table.insert(clientstatsDetail[client_hit_table[initiator]], item)

								end
							end
						end
						hitTbl_KillerByTarget[initiator] = nil						--after kills are assigned, remove hit unit from hit_table
					end
				end
			end
		end
	end
end

t_b = t_b + (os.clock() - c_b)

local c_SAR = os.clock()

--parse camp_ZoneSAR pour mettre à jour les POW
if camp_ZoneSAR then
	for side, zones in pairs(camp_ZoneSAR) do
		for zoneName, zone in pairs(zones) do
			for pilotN, ejectedPilot in ipairs(zone) do
				--client stats for POW
				if clientstats[ejectedPilot.initiatorPilotName] and ejectedPilot.status == "POW" then														--if take off is by a client
					if clientstats[ejectedPilot.initiatorPilotName].score_last.POW == 0 then			--client has no take off logged yet for this mission
						clientstats[ejectedPilot.initiatorPilotName].POW = clientstats[ejectedPilot.initiatorPilotName].POW + 1	--increase flown mission number
						clientstats[ejectedPilot.initiatorPilotName].score_last.POW = 1					--store mission for client
					end
				end
			end
		end
	end
else
	print("DebriefSE ne trouve pas la table/fichier camp_ZoneSAR ")
end

if camp_ZoneSAR then
	for side, zones in pairs(camp_ZoneSAR) do
		for zoneName, zone in pairs(zones) do
			for pilotN, ejectedPilot in ipairs(zone) do
				--client stats for POW
				if clientstats[ejectedPilot.pilotName] and ejectedPilot.status == "POW" then														--if take off is by a client
					if clientstats[ejectedPilot.pilotName].score_last.POW == 0 then			--client has no take off logged yet for this mission
						clientstats[ejectedPilot.pilotName].POW = clientstats[ejectedPilot.pilotName].POW + 1	--increase flown mission number
						clientstats[ejectedPilot.pilotName].score_last.POW = 1					--store mission for client
					end
				end
			end
		end
	end
else
	print("DebriefSE ne trouve pas la table/fichier camp_ZoneSAR ")
end

t_SAR = t_SAR + (os.clock() - c_SAR)

local c_hit = os.clock()

--log damaged aircraft in oob_air
for hit_unit,hitter in pairs(hitTbl_KillerByTarget) do													--iterate through all remaining entries in the hit_table (all destroyed aircraft are removed meanwhile, damaged remain)
	for side_name,side in pairs(oob_air) do													--iterate through all sides
		for unit_n,unit in pairs(side) do													--iterate through all air units
			if string.find(hit_unit, " " .. unit.name .. " ", 1, true) and health_table[hit_unit] then					--if hit unit is part of air unit name
				if  health_table[hit_unit] > 50 then											--if health of hit unit is bigger than 50%
					unit.roster.damaged = unit.roster.damaged + 1							--increase counter for damaged aircraft total
					unit.score_last.damaged = unit.score_last.damaged + 1					--increase counter for damaged aircraft in last mission
				else																		--if health of hit unit is lower than 50%, the aircraft is written off
					unit.roster.lost = unit.roster.lost + 1									--increase counter for lost aircraft total
					unit.score_last.lost = unit.score_last.lost + 1							--increase counter for lost aircraft in last mission

					--oob ground kill update for written off aircraft
					for killer_side_name,killer_side in pairs(oob_air) do											--iterate through all sides
						for killer_unit_n,killer_unit in pairs(killer_side) do										--iterate through all air units
							if string.find(hitter, " " .. killer_unit.name .. " ", 1, true) then					--if the hitter unit is part of air unit name
								if side_name ~= killer_side_name then												--make sure that killer unit and hit aircraft are not on same side (friendly fire is not awarded as kill)
									killer_unit.score.kills_ground = killer_unit.score.kills_ground + 1				--award ground kill to air unit
									killer_unit.score_last.kills_ground = killer_unit.score_last.kills_ground + 1	--increase kill counter for this mission of air unit
									addPackstats(hitter, "kill_ground", nil)												--check if kill was in player package

									--client stats for kills
									if client_hit_table[hit_unit] then												--if hitter was a client
										clientstats[client_hit_table[hit_unit]].kills_ground = clientstats[client_hit_table[hit_unit]].kills_ground + 1								--award ground kill to client
										clientstats[client_hit_table[hit_unit]].score_last.kills_ground = clientstats[client_hit_table[hit_unit]].score_last.kills_ground + 1
									end
									break
								end
							end
						end
					end

				end
				unit.roster.ready = unit.roster.ready - 1									--decrease number of ready aircraft of air unit
				unit.score_last.ready = unit.score_last.ready + 1							--decrease number of ready aircraft for this mission of air unit
			end
		end
	end
end

t_hit = t_hit + (os.clock() - c_hit)


-- Exemple d’appel avec rayon de 15 mètres et fenêtre de 2 secondes
--TODO reactiver ici la function, désactivé pour test
-- scen_log = fusionner_bombes(scen_log, 100, 2)

local scen_str = "scen_log = " .. TableSerialization(scen_log, 0)							--make a string
local scenFile = io.open("Debug/scen_log.lua", "w") or error("Failed to open debug file")
scenFile:write(scen_str)																	--save new data
scenFile:close()

local c_bomb = os.clock()


-- calcule l'indice de cellule pour une coordonnée monde
-- utile pour mapper une position X ou Y vers la grille
-- la taille de cellule est définie par GridCellSize
-- permet un regroupement spatial simple et rapide
local function getCellIndex(value)
	return math.floor(value / GridCellSize)
end

-- construit la grille spatiale à partir des targets
-- utile pour éviter les comparaisons explosion vs tous les éléments
-- chaque élément est inséré une seule fois dans la grille
-- la grille est réutilisée pour tous les scen du debrief
local function buildSpatialGrid(targetlist)
	local grid = {}

	for sideName, targets in pairs(targetlist) do
		for _, target in pairs(targets) do
			if target.elements then
				for _, element in pairs(target.elements) do
					if element.x and element.y then
						local cx = getCellIndex(element.x)
						local cy = getCellIndex(element.y)
						grid[cx] = grid[cx] or {}
						grid[cx][cy] = grid[cx][cy] or {}
						table.insert(grid[cx][cy], {
							element = element,
							target = target,
							sideName = sideName,
						})
					end
				end
			end
		end
	end

	return grid
end

-- index des statics par nom
-- utile car évite un scan complet de oob_ground à chaque destruction
-- chaque static est stocké par son nom comme clé
-- permet un accès direct et immédiat au bâtiment à détruire
local oobStaticByName = {}
for _, side in pairs(oob_ground) do
	for _, country in pairs(side) do
		if country.static then
			for _, group in pairs(country.static.group or {}) do
				for _, unit in pairs(group.units or {}) do
					oobStaticByName[unit.name] = unit
				end
			end
		end
	end
end

-- pré-calcul des targets structure
-- utile car évite de scanner les attributs texte à chaque explosion
-- chaque target est analysée une seule fois au chargement du debrief
-- un flag target.isStructure est ensuite utilisé directement
for _, sides in pairs(targetlist) do
	for _, target in pairs(sides) do
		target.isStructure = false
		if target.attributes then
			for _, attr in pairs(target.attributes) do
				local a = attr:lower()
				if a:find("structure", 1, true) or a:find("building", 1, true) then
					target.isStructure = true
					break
				end
			end
		end
	end
end

-- construction de la grille spatiale
local spatialGrid = buildSpatialGrid(targetlist)

-- local c_bomb = os.clock()

for scenName, scen in pairs(scen_log) do

	if not (scen.sceneryTypeName and scen.sceneryTypeName:find("FOREST", 1, true)) then
		if scen.x and scen.y then

			-- radius calculé une fois
			if scen.explosiveMass and scen.event ~= "BOMB_IMPACT" then
				scen.correctedRadius = 4.0 * (scen.explosiveMass)^(1/3)
			else
				scen.correctedRadius = RayonDamaged
			end
			local radius2 = scen.correctedRadius * scen.correctedRadius

			if not scen.lasthit and scen.initiator then
				scen.lasthit = scen.initiator
			end

			-- cellule du scen
			local cx = getCellIndex(scen.x)
			local cy = getCellIndex(scen.y)


			-- if scen.initiator then print("A scen "..tostring(scenName).." at ("..tostring(scen.x)..","..tostring(scen.y)..") initiated by "..tostring(scen.initiator).." with radius "..tostring(scen.correctedRadius)) end

			-- récupération de la cellule du scen et de ses voisines
			-- utile car une explosion ne peut affecter que les zones proches
			-- seules 9 cellules maximum sont analysées
			-- réduit drastiquement le nombre de calculs de distance
			for dx = -1, 1 do
				for dy = -1, 1 do
					local col = spatialGrid[cx + dx]
					if col then
						local cell = col[cy + dy]
						if cell then
							for _, entry in pairs(cell) do
								
								local element = entry.element
								local target = entry.target
								-- local sideName = entry.sideName

								if element.x and not element.lasthit then --and not element.dead 
									local dx2 = scen.x - element.x
									local dy2 = scen.y - element.y
									local dist2 = dx2*dx2 + dy2*dy2
									-- if scen.initiator then print("G element "..tostring(element.name).." scen.name: "..tostring(scen.name).." distance2 "..tostring(dist2).." radius2 "..tostring(radius2)) end
									
									if dist2 <= radius2 then
										
										-- if scen.initiator then print("H element "..tostring(element.name).." is within radius at distance "..tostring(math.sqrt(dist2))) end
										-- print("H element.dead = true "..tostring(element.name)..", destroying it: scenName: "..scenName.." is within radius at distance "..tostring(math.sqrt(dist2)))

										element.dead = true
										element.dead_last = true
										element.CheckDay = camp.date.CampTotalTimeS
										scen.lifePourcent = 0

										-- destruction du static associé
										if target.isStructure then
											-- if scen.initiator then print("I target "..tostring(target.titleName).." is a structure, destroying static "..tostring(element.name)) end
											
											local foundElement = oobStaticByName[element.name]
											if foundElement then

												-- if scen.initiator then print("J found oob static "..tostring(foundElement.name)..", destroying it") end
												
												foundElement.dead = true
												foundElement.dead_last = true
												foundElement.CheckDay = camp.date.CampTotalTimeS
											end
										end

										-- print("H0 element.name "..tostring(element.name).." destroyed by scen "..tostring(scenName).." at ("..tostring(scen.x)..","..tostring(scen.y)..")")
										-- print("H1 element.lasthit "..tostring(element.lasthit).." scen.lasthit "..tostring(scen.lasthit))
										
										
										-- attribution kill------------------------
										-- attribution kill-------------------------
										-- attribution kill-------------------------
										if not element.lasthit and scen.lasthit then
											element.lasthit = scen.lasthit

											-- print("I element.lasthit set to scen.lasthit "..tostring(scen.lasthit))

											local killerSquad = resolveAirSquad(scen.lasthit)
											-- print("perte structure scen.lasthit "..tostring(scen.lasthit).." killerSquad "..tostring(killerSquad and killerSquad.name))
											if killerSquad then
												
												-- print("K killerSquad "..tostring(killerSquad.name).." destroyed element "..tostring(element.name).." of target "..tostring(target.titleName))
												
												killerSquad.score.kills_ground = killerSquad.score.kills_ground + 1
												killerSquad.score_last.kills_ground = killerSquad.score_last.kills_ground + 1
												addPackstats(scen.lasthit, "kill_ground", nil)

												if clientControl[scen.lasthit] then
													local cid = clientControl[scen.lasthit]
													clientstats[cid].kills_ground = clientstats[cid].kills_ground + 1
													clientstats[cid].score_last.kills_ground = clientstats[cid].score_last.kills_ground + 1

													clientstatsDetail[cid] = clientstatsDetail[cid] or {}
													table.insert(clientstatsDetail[cid], {
														event = scenName,
														target_name = target.titleName,
														element = element,
													})
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
end

t_bomb = t_bomb + (os.clock() - c_bomb)


local c_runway = os.clock()

-- RunwayLife[Id] = {
-- 	name = tostring(b:getName()),
-- 	baseObject = b,
-- 	life0 = baseLife0,
-- 	life = 3600,
-- 	pointVec3 = pointVec3,
-- }
--evaluate destroyed runway objects
if camp.RunwayLife then
	for id, runway in pairs(camp.RunwayLife) do													--iterate through destroyed scenery objects

		if runway.life < 3600 and runway.name then
			for side_name, targets in pairs(targetlist) do											--iterate through targetlist
				for targetN, target in pairs(targets) do										--iterate through targets				
					if target.db_airbaseName and target.db_airbaseName == runway.name and string.lower(target.attributes[1]) == "runway" then		--if the target has subelements and is a scenery object target (element has x coordinate)

						local aliveTemp = math.floor((runway.life/3600) * 100)

						if aliveTemp < target.alive then
							target.alive = aliveTemp
							target.CheckDay = camp.date.CampTotalTimeS							-- ajoute la date de destruction
						end

						if aliveTemp < 100 then
							target.CheckDay = camp.date.CampTotalTimeS
							local nbRunwayPartDead = #target.elements -  (#target.elements * aliveTemp/100)

							for i=1, #target.elements do
								if i > nbRunwayPartDead then break end
								target.elements[i].dead = true
								target.elements[i].dead_last = true									--mark element as died in last mission
								target.elements[i].CheckDay = camp.date.CampTotalTimeS

								-- print("DebriefSE runway "..target.elements[i].name.." i: "..i)
							end
							-- print("DebriefSE aliveTemp "..aliveTemp.." nbRunwayPartDead: "..nbRunwayPartDead)
						end


						if aliveTemp < 50 then
							target.ATO = false
						end
					end
				end
			end
		end
	end
end

-- statLost = 
-- {
-- 	["blue"] = 
-- 	{
-- 		["test"] = 
-- 		{
-- 			["AH-64D_BLK_II"] = 
-- 			{
-- 				["Ground Attack"] = 
-- 				{
-- 					["nbKillerIsSAM"] = 1,
-- 					["lastMission"] = 2,
-- 					["nbKillerIsPlane"] = 0,
-- 					["nbTotal"] = 0,
-- 				},
-- 			},
-- 			["M-2000C"] = 
-- 			{
-- 				["CAS"] = 
-- 				{
-- 					["nbKillerIsSAM"] = 2,
-- 					["lastMission"] = 2,
-- 					["nbKillerIsPlane"] = 0,
-- 					["nbTotal"] = 0,
-- 				},
-- 			},
if camp.statLost then

	local noNeedTask = {
		Escort = true,
		CAP = true,
		SEAD = true,
	}

	for LostSide, LostSides in pairs(camp.statLost) do
		for targetName, targets in pairs(LostSides) do
			for LostTypeName, LostTypes in pairs(targets) do

				for LostTaskName, LostTasks in pairs(LostTypes) do

					if LostTaskName == "CAS" or LostTaskName == "Ground Attack" or LostTaskName == "Pinpoint Strike" then
						LostTaskName = "Strike"
					end
					if (LostTasks.lastMission + 4) < camp.mission  then
						LostTypes[LostTaskName] = nil
					elseif noNeedTask[LostTaskName] == nil then
						--ajoute des TASK lié aux types d'avions et à leur task lors qu'on en perd beaucoup
						if LostTasks.nbKillerIsPlane >= 4 or (LostTasks.nbKillerIsPlane >= 2 and LostTaskName == "Transport" )  then
							if not camp.newTaskRequest then camp.newTaskRequest = {} end
							if not camp.newTaskRequest[LostSide] then camp.newTaskRequest[LostSide] = {} end
							if not camp.newTaskRequest[LostSide][LostTypeName] then camp.newTaskRequest[LostSide][LostTypeName] = {} end
							if not camp.newTaskRequest[LostSide][LostTypeName][LostTaskName] then camp.newTaskRequest[LostSide][LostTypeName][LostTaskName] = {} end
							if not camp.newTaskRequest[LostSide][LostTypeName][LostTaskName].Escort then
								camp.newTaskRequest[LostSide][LostTypeName][LostTaskName].Escort = camp.mission
							end


						elseif LostTasks.nbKillerIsSAM >= 4 or (LostTasks.nbKillerIsSAM >= 2 and LostTaskName == "Transport" )  then
							if not camp.newTaskRequest then camp.newTaskRequest = {} end
							if not camp.newTaskRequest[LostSide] then camp.newTaskRequest[LostSide] = {} end
							if not camp.newTaskRequest[LostSide][LostTypeName] then camp.newTaskRequest[LostSide][LostTypeName] = {} end
							if not camp.newTaskRequest[LostSide][LostTypeName][LostTaskName] then camp.newTaskRequest[LostSide][LostTypeName][LostTaskName] = {} end
							if not camp.newTaskRequest[LostSide][LostTypeName][LostTaskName].SEAD then
								camp.newTaskRequest[LostSide][LostTypeName][LostTaskName].SEAD = camp.mission
							end

						end

						--newTaskPerTarget
						--ajoute des TASK lié aux Target visé,

						if LostTasks.nbKillerIsPlane >= 4 or (LostTasks.nbKillerIsPlane >= 2 and LostTaskName == "Transport" )  then
							if not camp.newTaskPerTarget then camp.newTaskPerTarget = {} end
							if not camp.newTaskPerTarget[targetName] then camp.newTaskPerTarget[targetName] = {} end
							if not camp.newTaskPerTarget[targetName]["tasks"] then
								camp.newTaskPerTarget[targetName] = {
									tasks = {},
									lastNumMission = camp.mission,
									difficult = 0,
								}
							end
							if not camp.newTaskPerTarget[targetName]["tasks"].Escort then
								camp.newTaskPerTarget[targetName]["tasks"].Escort = 0
							end
							camp.newTaskPerTarget[targetName]["tasks"].Escort = 1 + camp.newTaskPerTarget[targetName]["tasks"].Escort
							camp.newTaskPerTarget[targetName].lastNumMission = camp.mission
							camp.newTaskPerTarget[targetName].difficult = 1 + camp.newTaskPerTarget[targetName].difficult

						elseif LostTasks.nbKillerIsSAM >= 4 or (LostTasks.nbKillerIsSAM >= 2 and LostTaskName == "Transport" )  then
							if not camp.newTaskPerTarget then camp.newTaskPerTarget = {} end
							if not camp.newTaskPerTarget[targetName] then camp.newTaskPerTarget[targetName] = {} end
							if not camp.newTaskPerTarget[targetName]["tasks"] then
								camp.newTaskPerTarget[targetName] = {
									tasks = {},
									lastNumMission = camp.mission,
									difficult = 0,
								}
							end
							if not camp.newTaskPerTarget[targetName]["tasks"].SEAD then
								camp.newTaskPerTarget[targetName]["tasks"].SEAD = 0
							end
							camp.newTaskPerTarget[targetName]["tasks"].SEAD = 1 + camp.newTaskPerTarget[targetName]["tasks"].SEAD
							camp.newTaskPerTarget[targetName].lastNumMission = camp.mission
							camp.newTaskPerTarget[targetName].difficult = 1 + camp.newTaskPerTarget[targetName].difficult

						end
					end
				end

			end
		end
	end
end
t_runway = t_runway + (os.clock() - c_runway)

local c_task = os.clock()

if Debug.debug and camp.newTaskRequest then
	local _Str = "newTaskRequest = " .. TableSerialization(camp.newTaskRequest, 0)
	local trigFile = io.open("Debug/newTaskRequest.lua", "w") or error("Failed to open debug file")
	trigFile:write(_Str)
	trigFile:close()

	_Str = "newTaskPerTarget = " .. TableSerialization(camp.newTaskPerTarget, 0)
	trigFile = io.open("Debug/newTaskPerTarget.lua", "w") or error("Failed to open debug file")
	trigFile:write(_Str)
	trigFile:close()
end
		-- ["newTaskRequest"] = 
		-- {
		-- 	["red"] = 
		-- 	{
		-- 		["C-130"] = 
		-- 		{
		-- 			["Transport"] = 
		-- 			{
		-- 				["Escort"] = 5,
		-- 			},

		-- 		},
		-- 	},
		-- },


		-- newTaskRequest = 
		-- {
		-- 	["red"] = 
		-- 	{
		-- 		["C-130"] = 
		-- 		{
		-- 			["Escort"] = 2,
		-- 		},
		-- 	},
		-- }

--supprime les nouveaux rNewTasks s'ils leurs ajouts sont vieux (date de plus de x mission)
if camp.newTaskRequest then
	for rSide, rSides in pairs(camp.newTaskRequest) do
		for rTypeName, rTypes in pairs(rSides) do
			for taskName, NewTasks in pairs(rTypes) do
				for newTaskName, missionNumber in pairs(NewTasks) do
					if missionNumber + 4 < camp.mission  then
						NewTasks[newTaskName] = nil
					end
				end
			end
		end
	end
end

t_task = t_task + (os.clock() - c_task)

local c_LL = os.clock()
-- Merge Mission_LL_Positions into LL_Positions (Active/LL_Positions.lua)
LL_Positions = nil
local posFile = "Active/LL_Positions.lua"
local testPath = io.open(posFile, "r")
if testPath ~= nil then
	io.close(testPath)
	-- load existing positions file (expected to set LL_Positions)
	dofile(posFile)
	LL_Positions = LL_Positions or {}

	-- If there's mission provided positions, merge them in
	if Mission_LL_Positions and type(Mission_LL_Positions) == "table" then
		for m_key, m_positions in pairs(Mission_LL_Positions) do
			-- ensure target key exists
			if not LL_Positions[m_key] or type(LL_Positions[m_key]) ~= "table" then
				LL_Positions[m_key] = {}
			end

			-- merge each position
			if type(m_positions) == "table" then
				for _, m_pos in ipairs(m_positions) do
					local merged = false
					-- try to detect duplicates by (x,y) or (lat,lon)
					for i, pos in ipairs(LL_Positions[m_key]) do
						if pos and m_pos then
							if pos.x and m_pos.x and pos.y and m_pos.y then
								if pos.x == m_pos.x and pos.y == m_pos.y then
									-- overwrite existing entry with mission one
									LL_Positions[m_key][i] = m_pos
									merged = true
									break
								end
							elseif pos.lat and m_pos.lat and pos.lon and m_pos.lon then
								if pos.lat == m_pos.lat and pos.lon == m_pos.lon then
									LL_Positions[m_key][i] = m_pos
									merged = true
									break
								end
							end
						end
					end
					if not merged then
						table.insert(LL_Positions[m_key], m_pos)
					end
				end
			else
				-- not a table (fallback), just assign
				LL_Positions[m_key] = m_positions
			end
		end
	end

else
	-- no existing file -> use mission positions or empty table
	LL_Positions = Mission_LL_Positions or {}
end

-- Persist merged LL_Positions back to Active/LL_Positions.lua
local ok, err = pcall(function()
	local f, ferr = io.open(posFile, "w")
	if not f then
		error("Failed to open " .. tostring(posFile) .. " for write: " .. tostring(ferr))
	end
	local str = "LL_Positions = " .. TableSerialization(LL_Positions, 0)
	f:write(str)
	f:close()
end)
if not ok then
	-- on failure, log error but don't crash
	if Debug and Debug.debug then
		local errFile = io.open("Debug/LL_Positions_write_error.txt", "w")
		if errFile then
			errFile:write(tostring(err))
			errFile:close()
		end
	end
end

t_LL = t_LL + (os.clock() - c_LL)


local c_c = os.clock()

if Debug.debug  then
	local _Str = "targetlistA = " .. TableSerialization(targetlist, 0)
	local trigFile = io.open("Debug/targetlist_DEBRIEF_StatsEvaluation.lua", "w") or error("Failed to open debug file")
	trigFile:write(_Str)
	trigFile:close()
end

if Debug.debug and camp.statLost then
	local _Str = "statLost = " .. TableSerialization(camp.statLost, 0)
	local trigFile = io.open("Debug/statLost.lua", "w") or error("Failed to open debug file")
	trigFile:write(_Str)
	trigFile:close()
end

local _Str = "statLost = " .. TableSerialization(clientstatsDetail, 0)
local trigFile = io.open("Debug/statsClientDetails.lua", "w") or error("Failed to open debug file")
trigFile:write(_Str)
trigFile:close()


t_c = t_c + (os.clock() - c_c)


-- AddLog(string.format(
-- 	"PERF DEBRIEF_SE: total=%.2fs | t_a=%.2fs | t_b=%.2fs | t_c=%.2fs | t_bomb=%.2fs | t_runway=%.2fs | t_task=%.2fs | t_LL=%.2fs | t_SAR=%.2fs | t_hit=%.2fs |",
-- 	os.clock() - t0,
-- 	t_a,
-- 	t_b,
-- 	t_c,
--  	t_bomb,
--  	t_runway,
--  	t_task,
--  	t_LL,
-- 	t_SAR,
-- 	t_hit
-- ))


if Debug.debug then
	print("FIN DEBRIEF_StatsEvaluation.lua "..versionDCE["DEBRIEF_StatsEvaluation.lua"].." =-=-=-=-=-=-=-=-=-=-=-=-=-=-=")
end


