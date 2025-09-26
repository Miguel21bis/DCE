--To evaluate the DCS debrief.log and update the campaign status files
--Initiated by DEBRIEF_Master.lua
-------------------------------------------------------------------------------------------------------
-- last modification:  debug_m
if not versionDCE then versionDCE = {} end
versionDCE["DEBRIEF_StatsEvaluation.lua"] = "1.8.68"
------------------------------------------------------------------------------------------------------- 
-- debug_m						(m events[e].target or "nil")(l package stats)(k task inc)(j element.x)(i inconnu events[e].initiator)(g mission+1) hit name)(h take debrief camp_status)(g some kills are not counted)(f debrief bug)(e pilotName)(c:equipage compte 2X)(b transport)(a: nom cible peut ressembler à nom AirUnit)
-- cleancode_h					(h springCleaning)
-- adjustment_i					(i Debug/statsClientDetails) (g soldat inconnu)(f reveals the SAM that have already fired)
-- modification M66_a			bombOnRunway
-- modification M61_a			SAR
-- modification M50_a			Records landings for later use in logistics (C-130, Transport...)
-- modification M19_f			Repair SAM
-- modification M11A_be			Multiplayer	(be camp.client)(y: force same package)
------------------------------------------------------------------------------------------------------- 

--Global variable
packstats = {}	--track stats for player package

if not AcceptedMission then
	oob_air = Deepcopy(oob_air)
	oob_ground = Deepcopy(oob_ground)
	targetlist = Deepcopy(targetlist)
	clientstats = Deepcopy(clientstats)
	camp = Deepcopy(camp)
	camp_ZoneSAR = Deepcopy(camp_ZoneSAR)
	oob_scen = Deepcopy(oob_scen)

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

	local campExport = loadfile("camp_status.lua")()												--camp_status
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

-- print(" targetlist D1: "..tostring(camp_triggers))
-- print(" targetlist D2: "..tostring(camp_triggers[1]["name"]))

require("Active/last_Mission")

dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_UpdateSAR.lua")

-- print("DebriefStatsEvaluation Initialisation AcceptedMission? "..tostring(AcceptedMission))

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

local client_control = {}																	--local table to store which client controls which unit
local hit_table = {}																		--local table to store who was the last hitter to hit a unit
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
		client_control[events[e].initiator] = events[e].initiatorPilotName								--store which unit name (initiaror) is controllen by cliend (PilotName)
	end
end

for e = 1, #events do																					--iterate through all events
	if events[e].pilotName then
		-- print("DebriefSE e: "..tostring(e).." pilotName: "..tostring( events[e].pilotName).." initiator: "..tostring(events[e].initiator))
	end

	if events[e].initiator and string.find(events[e].initiator, "parachut") then
		events[e].initiator = tostring(events[e].pilotName)
	end

	if events[e].pilotName and type(events[e].pilotName) == "string" and events[e].pilotName ~= "nil" then	--event is by a client
		addClient(events[e].pilotName)
		client_control[events[e].initiator] = events[e].pilotName								--store which unit name (initiaror) is controllen by cliend (PilotName)
	end
end

local tabTransport = {}
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
		hit_table[target] = events[e].initiator												--store who hits a target (subsequent hits overwrite previous hits)
		statutObject[target].hit = true
		health_table[target] = events[e].health												--store health of the target
		client_hit_table[target] = client_control[initiator]						--store client name that has hit a unit (stores nil  if hitter is not a client)

	elseif eventType == "crash" and events[e].initiator then
		--oob loss update for crashed aircraft
		if statutObject[initiator].kill == false   then --and  statutObject[initiator] ~= "unit lost"
			local crash_side																				--local variable to store the side of the crashed aircraft
			for killer_side_name,killer_side in pairs(oob_air) do											--iterate through all sides
				-- if killer_side_name and type(killer_side) == "table" then
					for killer_unit_n,killer_unit in pairs(killer_side) do										--iterate through all air units
						if events[e].initiator and string.find(events[e].initiator, " " .. killer_unit.name .. " ", 1, true) then		--if the crashed aircraft name is part of air unit name
							crash_side = killer_side_name														--store side of the crashed aircraft
							killer_unit.roster.lost = killer_unit.roster.lost + 1								--increase loss counter of air unit
							killer_unit.score_last.lost = killer_unit.score_last.lost + 1						--increase loss counter for this mission of air unit
							killer_unit.roster.ready = killer_unit.roster.ready - 1								--decrease number of ready aircraft of air unit
							killer_unit.score_last.ready = killer_unit.score_last.ready + 1						--decrease number of ready aircraft for this mission of air unit
							addPackstats(events[e].initiator, "lost", events[e])											--check if loss was in player package

							--client stats for crashes
							if client_control[initiator] and ( (events[e].t - clientstats[client_control[initiator]].score_last.Time_Crash) >   30) then											--if crashed aircraft is a client

							-- if client_control[initiator]  then											--if crashed aircraft is a client


								clientstats[client_control[initiator]].crash = clientstats[client_control[initiator]].crash + 1	--store crash for client
								clientstats[client_control[initiator]].score_last.crash =  clientstats[client_control[initiator]].score_last.crash + 1			--store crash for client
								clientstats[client_control[initiator]].score_last.Time_Crash = events[e].t

							end
							break
						end
					end
				-- end
			end

			--oob kill update for crashed aircraft
			for killer_side_name,killer_side in pairs(oob_air) do											--iterate through all sides
				for killer_unit_n,killer_unit in pairs(killer_side) do										--iterate through all air units
					if hit_table[initiator] ~= nil then											--check if the crashed aircraft has a hit entry
						if string.find(hit_table[initiator], " " .. killer_unit.name .. " ", 1, true) then			--if the hitting unit is part of air unit name
							if crash_side ~= killer_side_name then											--make sure that hitting unit and crashed aircraft are not on same side (friendly fire is not awarded as kill)
								killer_unit.score.kills_air = killer_unit.score.kills_air + 1				--award air kill to air unit
								killer_unit.score_last.kills_air = killer_unit.score_last.kills_air + 1		--increase kill counter for this mission of air unit
								addPackstats(hit_table[initiator], "kill_air", events[e])					--check if kill was in player package

								--client stats for kills
								-- if client_hit_table[initiator] then								--if crashed aircraft was hit by a client
								if client_control[initiator] and ( (events[e].t - clientstats[client_control[initiator]].score_last.Time_kills_air) >   30) then											--if crashed aircraft is a client

									clientstats[client_hit_table[initiator]].kills_air = clientstats[client_hit_table[initiator]].kills_air + 1	--award air kill to client
									clientstats[client_hit_table[initiator]].score_last.kills_air = clientstats[client_hit_table[initiator]].score_last.kills_air + 1
								end
								break
							end
						end
					end
				end
			end
			if hit_table[initiator] then
				hit_table[initiator] = nil															--once kills for the dead aircraft are awarded, remove it from the hit_table. The aircraft remaining in the hit_table after completed log evaluation are only damaged.
			end
		end
		statutObject[initiator].crash = true

	elseif eventType == "kill" then
		--oob loss update for crashed aircraft
		local targetSide																				--local variable to store the side of the crashed aircraft
		local targetIsPlane
		local killerIsPlane
		local tagBreak
		for target_side_name, target_side in pairs(oob_air) do											--iterate through all sides
			if target_side_name and type(target_side) == "table" then

				for target_unit_n, target_unit in pairs(target_side) do										--iterate through all air units
					if events[e].target and string.find(events[e].target, "Manhunt") then
						targetIsPlane = false

						addPackstats(hit_table[target], "kill_ground", events[e])						--check if kill was in player package

						clientstats[client_control[initiator]].kills_ground = clientstats[client_control[initiator]].kills_ground + 1							--award gound kill to client
						clientstats[client_control[initiator]].score_last.kills_ground = clientstats[client_control[initiator]].score_last.kills_ground + 1		--award ground kill to client

						local item = {
							event = events[e],
							unit = events[e].target,
						}
							
						tagBreak = true
						break
					elseif events[e].target and string.find(events[e].target, " " .. target_unit.name .. " ", 1, true) then		--if the crashed aircraft name is part of air unit name
						targetIsPlane = true
						targetSide = target_side_name														--store side of the crashed aircraft
						target_unit.roster.lost = target_unit.roster.lost + 1								--increase loss counter of air unit
						target_unit.score_last.lost = target_unit.score_last.lost + 1						--increase loss counter for this mission of air unit
						target_unit.roster.ready = target_unit.roster.ready - 1								--decrease number of ready aircraft of air unit
						target_unit.score_last.ready = target_unit.score_last.ready + 1						--decrease number of ready aircraft for this mission of air unit
						addPackstats(events[e].target, "lost", events[e])											--check if loss was in player package

						--client stats for crashes
						if client_control[target] and ( (events[e].t - clientstats[client_control[target]].score_last.Time_Crash) >   30) then											--if crashed aircraft is a client

							clientstats[client_control[target]].crash = clientstats[client_control[target]].crash + 1	--store crash for client
							clientstats[client_control[target]].score_last.crash =  clientstats[client_control[target]].score_last.crash + 1			--store crash for client
							clientstats[client_control[target]].score_last.Time_Crash = events[e].t

						end
						tagBreak = true
						break
					end
				end
				if tagBreak then break end
			end
		end

		--oob kill update for crashed aircraft
		if targetIsPlane then
			for killer_side_name, killer_side in pairs(oob_air) do											--iterate through all sides
				for killer_unit_n, killer_unit in pairs(killer_side) do										--iterate through all air units
					--hit_table[target] = events[e].initiator
					if hit_table[target] ~= nil then											--check if the crashed aircraft has a hit entry
						if string.find(hit_table[target], " " .. killer_unit.name .. " ", 1, true) then			--if the hitting unit is part of air unit name
							killerIsPlane = true
							killer_unit.score.kills_air = killer_unit.score.kills_air + 1				--award air kill to air unit
							killer_unit.score_last.kills_air = killer_unit.score_last.kills_air + 1		--increase kill counter for this mission of air unit
							addPackstats(hit_table[target], "kill_air", events[e])					--check if kill was in player package

							--client stats for kills
							if client_hit_table[target] then								--if crashed aircraft was hit by a client

								clientstats[client_hit_table[target]].kills_air = clientstats[client_hit_table[target]].kills_air + 1	--award air kill to client
								clientstats[client_hit_table[target]].score_last.kills_air = clientstats[client_hit_table[target]].score_last.kills_air + 1
							end
							break
						end
					end
				end
			end

		end

		-- --recherche le nom du SAM pour le reveler au yeux du monde ^^
		-- if not killerIsPlane and  events[e].initiator ~= nil then
		-- 	local tagbreak = false
		-- 	for side_name, side in pairs(oob_ground) do																--iterate through sides
		-- 		for countryN, country in pairs(side) do															--iterate through countries
		-- 			for categorieN, categories in pairs(country) do
		-- 				if type(categories) == "table" and categories.group then
		-- 					for _group, groups in pairs(categories) do
		-- 						for groupN, group in pairs(groups) do
		-- 							for unitN, unit in ipairs(group.units) do	
		-- 								if unit.name == events[e].initiator and not string.find(unit.name, "Soldier")  then
		-- 									group.hidden = false
		-- 									tagbreak = true

		-- 									break
		-- 								end
		-- 								if tagbreak then break end
		-- 							end
		-- 							if tagbreak then break end
		-- 						end
		-- 						if tagbreak then break end
		-- 					end
		-- 				end
		-- 				if tagbreak then break end
		-- 			end
		-- 			if tagbreak then break end
		-- 		end
		-- 		if tagbreak then break end
		-- 	end

		-- end

		if  targetIsPlane  and  hit_table[target] then
			hit_table[target] = nil															--once kills for the dead aircraft are awarded, remove it from the hit_table. The aircraft remaining in the hit_table after completed log evaluation are only damaged.
			-- if string.find(events[e].target, "152 Filo") then
			-- 	print("hit_table " ..events[e].target.." "..tostring(hit_table[target]))
			-- end
		end

		-- ["statLost"] = 
		-- {
		-- 	["red"] = 
		-- 	{
		-- 		["C-130"] = 
		-- 		{
		-- 			["Transport"] = 
		-- 			{
		-- 				["Escort"] = true,
		-- 			},

		-- 		},
		-- 	},
		-- },

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
		if client_control[initiator] and ( (events[e].t - clientstats[client_control[initiator]].score_last.Time_Eject) >   30)  then														--if ejected pilot is a client

			clientstats[client_control[initiator]].eject = clientstats[client_control[initiator]].eject + 1	--store ejection for client
			clientstats[client_control[initiator]].score_last.eject =  clientstats[client_control[initiator]].score_last.eject + 1						--store eject for client
			clientstats[client_control[initiator]].score_last.Time_Eject = events[e].t

			if statutObject[initiator]["unit lost"] then
				clientstats[client_control[initiator]].dead = clientstats[client_control[initiator]].dead - 1	--store death for client
				clientstats[client_control[initiator]].score_last.dead =  clientstats[client_control[initiator]].score_last.dead - 1						--store dead pilot for client
				clientstats[client_control[initiator]].score_last.Time_Dead = 0
				statutObject[initiator]["pilot dead"] =  false
				statutObject[initiator]["unit lost"] =  false
			end
		end
		statutObject[initiator].eject = true
	elseif eventType == "pilot dead" and events[e].initiator then
		--client stats for dead pilots
		if client_control[initiator] and ( (events[e].t - clientstats[client_control[initiator]].score_last.Time_Dead) >   30) then														--if dead pilot is a client
			clientstats[client_control[initiator]].dead = clientstats[client_control[initiator]].dead + 1	--store death for client
			clientstats[client_control[initiator]].score_last.dead =  clientstats[client_control[initiator]].score_last.dead + 1						--store dead pilot for client
			clientstats[client_control[initiator]].score_last.Time_Dead = events[e].t
		end
		statutObject[initiator]["pilot dead"] =  true

	elseif eventType == "pilot land" and events[e].initiator then

		--client stats for landing pilots
		if client_control[initiator] and ( (events[e].t - clientstats[client_control[initiator]].score_last.Time_MIA) >   30) then														--if landing pilot is a client
			clientstats[client_control[initiator]].MIA = clientstats[client_control[initiator]].MIA + 1	--store MIA for client
			clientstats[client_control[initiator]].score_last.MIA =  1						--store MIA pilot for client
			clientstats[client_control[initiator]].score_last.Time_MIA = events[e].t

			-- print("DebriefSE initiator "..tostring(events[e].initiator).." MIA: "..tostring(clientstats[client_control[initiator]].MIA))

		end
		statutObject[initiator]["pilot land"] = true

	elseif eventType == "takeoff" and events[e].initiator then
		--client stats for flown missions
		if client_control[initiator] then														--if take off is by a client
			if clientstats[client_control[initiator]].score_last.mission == 0 then			--client has no take off logged yet for this mission
				clientstats[client_control[initiator]].mission = clientstats[client_control[initiator]].mission + 1	--increase flown mission number
				clientstats[client_control[initiator]].score_last.mission = 1					--store mission for client
			end
		end
		statutObject[initiator].takeoff = true

	elseif eventType == "embarkedEjectedPilot" then
		--l'initiator sauve quelqu'un
		if client_control[initiator] and ( (events[e].t - clientstats[client_control[initiator]].score_last.Time_rescue ) > 30) then
			clientstats[client_control[initiator]].rescue  = clientstats[client_control[initiator]].rescue  + 1
			clientstats[client_control[initiator]].score_last.rescue  = clientstats[client_control[initiator]].score_last.rescue + 1
			clientstats[client_control[initiator]].score_last.Time_rescue =  events[e].t
		end
		--le pilote sauvé est le target
		if client_control[target] and ( (events[e].t - clientstats[client_control[target]].score_last.Time_rescued ) > 30) then
			clientstats[client_control[target]].rescued  = clientstats[client_control[target]].rescued  + 1
			clientstats[client_control[target]].score_last.rescued  = clientstats[client_control[target]].score_last.rescued + 1
			clientstats[client_control[target]].score_last.Time_rescued =  events[e].t

			clientstats[client_control[target]].MIA = clientstats[client_control[target]].MIA - 1
			clientstats[client_control[target]].score_last.MIA =  -1
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
		if client_control[initiator] then														--if take off is by a client
			if clientstats[client_control[initiator]].score_last.mission == 0 then			--client has no take off logged yet for this mission
				clientstats[client_control[initiator]].mission = clientstats[client_control[initiator]].mission + 1	--increase flown mission number
				clientstats[client_control[initiator]].score_last.mission = 1					--store mission for client
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

	elseif (eventType == "dead" or eventType == "unit lost") and events[e].initiator then

		--client stats for dead pilots
		if client_control[initiator] and ( (events[e].t - clientstats[client_control[initiator]].score_last.Time_Dead) >   30) then
		-- if client_control[initiator]  then														--if dead pilot is a client

			clientstats[client_control[initiator]].dead = clientstats[client_control[initiator]].dead + 1	--store death for client
			clientstats[client_control[initiator]].score_last.dead =  clientstats[client_control[initiator]].score_last.dead + 1						--store dead pilot for client
			clientstats[client_control[initiator]].score_last.Time_Dead = events[e].t
			statutObject[initiator]["pilot dead"] =  true
			if eventType == "unit lost" then
				statutObject[initiator]["unit lost"] = true
			end
		end


		--ground/naval/static loss events																--iterate through all the sub-tables of the oob_ground files and try to find the matching unitId of the dead unit (vehicle/ship/static)
		if eventType == "unit lost" then																		--hit events
			statutObject[initiator]["unit lost"] = true
		end

		for side_name,side in pairs(oob_ground) do														--side table(red/blue)											
			for country_n,country in pairs(side) do														--country table (number array)
				if country.vehicle then																	--if country has vehicles
					for group_n,group in pairs(country.vehicle.group) do								--groups table (number array)
						for unit_n,unit in pairs(group.units) do										--units table (number array)					
							-- if unit.unitId == tonumber(events[e].initiatorMissionID) then				--check if unitId matches initiatorMissionID (string, needs to be converted to number)
							if unit.name == events[e].initiator and not unit.dead then

								-- if unit.name == events[e].initiator then

									unit.dead = true														--mark unit as dead in oob_ground
									unit.dead_last = true													--mark unit as died in last mission
									unit.CheckDay = camp.date.CampTotalTimeS                            -- ajoute la date de destruction		 Miguel21 modification M19 : Repair SAM	

									--award ground kill to air unit
									if hit_table[initiator] ~= nil then														--check if dead vehicle has a hit entry
										for killer_side_name,killer_side in pairs(oob_air) do											--iterate through all sides
											for killer_unit_n,killer_unit in pairs(killer_side) do										--iterate through all air units
												if string.find(hit_table[initiator], " " .. killer_unit.name .. " ", 1, true) then	--if the hitting unit is part of air unit name
													if side_name ~= killer_side_name then												--make sure that hitting unit is not on same side as dead unit (friendly fire gives no kills)
														killer_unit.score.kills_ground = killer_unit.score.kills_ground + 1				--award ground kill to air unit
														killer_unit.score_last.kills_ground = killer_unit.score_last.kills_ground + 1
														addPackstats(hit_table[initiator], "kill_ground", events[e])						--check if kill was in player package

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
													break
												end
											end
										end
										hit_table[initiator] = nil							--after kills are assigned, remove hit unit from hit_table
									end
									break
								-- else
								-- 	print("Debrief Ne trouve pas "..events[e].initiatorMissionID.." "..events[e].initiator)
								-- end
							end
						end
					end
				end
				if country.ship then																--if country has ships
					for group_n,group in pairs(country.ship.group) do								--groups table (number array)
						for unit_n,unit in pairs(group.units) do									--units table (number array)
							-- if unit.unitId == tonumber(events[e].initiatorMissionID) then			--check if unitId matches initiatorMissionID (string, needs to be converted to number)
							if unit.name == events[e].initiator  and not unit.dead then
								unit.dead = true													--mark unit as dead in oob_ground
								unit.dead_last = true												--mark unit as died in last mission
								unit.CheckDay = camp.date.CampTotalTimeS                            -- ajoute la date de destruction		 Miguel21 modification M19 : Repair SAM	
								camp.ShipHealth[unit.name] = 0										--mark unit has 0 health for briefing/Debriefing
								camp.ShipDamagedLast[unit.name] = true								--mark ship took damage in last mission for briefing/Debriefing

								--award ship kill to air unit
								if hit_table[initiator] ~= nil then														--check if dead ship has a hit entry
									for killer_side_name,killer_side in pairs(oob_air) do											--iterate through all sides
										for killer_unit_n,killer_unit in pairs(killer_side) do										--iterate through all air units
											if string.find(hit_table[initiator], " " .. killer_unit.name .. " ", 1, true) then	--if the hitting unit is part of air unit name
												if side_name ~= killer_side_name then												--make sure that hitting unit is not on same side as dead unit (friendly fire gives no kills)
													killer_unit.score.kills_ship = killer_unit.score.kills_ship + 1					--award ship kill to air unit
													killer_unit.score_last.kills_ship = killer_unit.score_last.kills_ship + 1
													addPackstats(hit_table[initiator], "kill_ship", events[e])						--check if kill was in player package

													--award ship kill to client
													if client_hit_table[initiator] then									--if dead ship was hit by a client
														clientstats[client_hit_table[initiator]].kills_ship = clientstats[client_hit_table[initiator]].kills_ship + 1							--award ship kill to client
														clientstats[client_hit_table[initiator]].score_last.kills_ship = clientstats[client_hit_table[initiator]].score_last.kills_ship + 1		--award ship kill to client
													end
												end
												break
											end
										end
									end
									hit_table[initiator] = nil							--after kills are assigned, remove hit unit from hit_table
								end
								break
							end
						end
					end
				end
				if country.static then																--if country has static objects
					for group_n,group in pairs(country.static.group) do								--groups table (number array)
						for unit_n,unit in pairs(group.units) do									--units table (number array)
						
							if unit.name == events[e].initiator and not unit.dead then
								if unit.dead ~= true then											--unit is not yet dead (some static objects that are spawned in a destroyed state are logged dead at mission start, these must be excluded here)
									group.dead = true												--mark group as dead in oob_ground (static objects can be set as group.dead and spawned in a destroyed state)
									if group.linkOffset then										--static unit was linked to a carrier
										group.linkOffset = false									--unlink  dead static from carrier
										group.x = 2000000
										group.y = 2000000
										group.units[1].x = 2000000
										group.units[1].y = 2000000
										group.route.points[1].x = 2000000
										group.route.points[1].y = 2000000
									end
									group.hidden = true	--TODO si le vehicle revit, il faudrait lui coller le hidden d'origine											--hide dead static object
									unit.dead = true												--mark unit as dead in oob_ground (this is for the targetlist)
									unit.dead_last = true											--mark unit as died in last mission
									unit.CheckDay = camp.date.CampTotalTimeS                            -- ajoute la date de destruction		 Miguel21 modification M19 : Repair SAM	

									--award ground kill to air unit
									if hit_table[initiator] ~= nil then														--check if dead static has a hit entry
										for killer_side_name,killer_side in pairs(oob_air) do											--iterate through all sides
											for killer_unit_n,killer_unit in pairs(killer_side) do										--iterate through all air units
												if string.find(hit_table[initiator], " " .. killer_unit.name .. " ", 1, true) then	--if the hitting unit is part of air unit name
													if side_name ~= killer_side_name then												--make sure that hitting unit is not on same side as dead unit (friendly fire gives no kills)
														killer_unit.score.kills_ground = killer_unit.score.kills_ground + 1				--award ground kill to air unit
														killer_unit.score_last.kills_ground = killer_unit.score_last.kills_ground + 1
														addPackstats(hit_table[initiator], "kill_ground", events[e])						--check if kill was in player package

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
													break
												end
											end
										end
										hit_table[initiator] = nil						--after kills are assigned, remove hit unit from hit_table
									end
									break
								end
							end
						end
					end
				end
			end
		end
	end
end

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

--log damaged aircraft in oob_air
for hit_unit,hitter in pairs(hit_table) do													--iterate through all remaining entries in the hit_table (all destroyed aircraft are removed meanwhile, damaged remain)
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


-- Fonction de distance entre deux points 3D
local function distanceBombe(a, b)
    local dx = a.x - b.x
    local dy = (a.y or 0) - (b.y or 0)
    local dz = a.z - b.z
    return math.sqrt(dx*dx + dy*dy + dz*dz)
end

-- Fonction principale de fusion
local function fusionner_bombes(scen_log, rayon_max, temps_max)
	local bombes = {}
	local autres = {}

	-- Séparation bombes et autres objets
	for k, v in pairs(scen_log) do
		if type(v) == "table" and v.event == "BOMB_IMPACT" then
			table.insert(bombes, {key = k, data = v})
		else
			autres[k] = v
		end
	end

	local groupes = {}
	local used = {}

	for i = 1, #bombes do
		local bi = bombes[i]
		if not used[bi.key] then
			local groupe = {bi}
			used[bi.key] = true
			for j = i + 1, #bombes do
				local bj = bombes[j]
				if not used[bj.key] then
					local dist = distanceBombe(bi.data, bj.data)
					local delta_t = math.abs(bi.data.time - bj.data.time)
					if dist <= rayon_max and delta_t <= temps_max then
						table.insert(groupe, bj)
						used[bj.key] = true
					end
				end
			end
			table.insert(groupes, groupe)
		end
	end

    -- Fusion des groupes
    local resultat = {}
    local compteur = 1

    for _, groupe in ipairs(groupes) do
        if #groupe == 1 then
            local unique = groupe[1]
            resultat[unique.key] = unique.data
        else
            local total_mass = 0
            local total_x, total_y, total_z, total_t = 0, 0, 0, 0
            local noms = {}

            for _, item in ipairs(groupe) do
                local d = item.data
                total_mass = total_mass + (d.tntEquivalent or d.explosiveMass or d.warheadMass or 0)
                total_x = total_x + d.x
                total_y = total_y + (d.y or 0)
                total_z = total_z + d.z
                total_t = total_t + d.time
                noms[d.weaponName or "UNKNOWN"] = true
            end

            local n = #groupe
            local key = "BOMB_FUSED_" .. compteur
            compteur = compteur + 1
            local noms_concat = ""
            for name, _ in pairs(noms) do
                noms_concat = noms_concat .. name .. "+"
            end
            noms_concat = noms_concat:sub(1, -2)

            resultat[key] = {
                event = "BOMB_IMPACT",
                explosiveMass = total_mass,
                -- tntEquivalent = total_mass,
                -- warheadMass = total_mass,
                weaponName = noms_concat,
                time = total_t / n,
                x = total_x / n,
                y = total_y / n,
                z = total_z / n,
                fusionCount = n,
                fusedFrom = (function()
                    local f = {}
                    for _, b in ipairs(groupe) do table.insert(f, b.key) end
                    return f
                end)()
            }
        end
    end

    -- Réintégration des autres objets
    for k, v in pairs(autres) do
        resultat[k] = v
    end

    return resultat
end

-- Exemple d’appel avec rayon de 15 mètres et fenêtre de 2 secondes
scen_log = fusionner_bombes(scen_log, 100, 2)

local scen_str = "scen_log = " .. TableSerialization(scen_log, 0)							--make a string
local scenFile = io.open("Debug/scen_log.lua", "w") or error("Failed to open debug file")
scenFile:write(scen_str)																	--save new data
scenFile:close()

--evaluate destroyed scenery objects
for scen_name, scen in pairs(scen_log) do													--iterate through destroyed scenery objects

	local passeOK = true
	-- local isForest = false
	if scen.sceneryTypeName and string.find(scen.sceneryTypeName, "FOREST")  then
		passeOK = false
	end

	if scen.x and scen.y and passeOK then

		for side_name, targets in pairs(targetlist) do											--iterate through targetlist
			for targetN, target in pairs(targets) do										--iterate through targets				
			
				local passStructure = false
				if target.attributes then
					for attributN, attribut in pairs(target.attributes) do
						local attrLower = string.lower(attribut)
						if string.find(attrLower, "structure") or string.find(attrLower, "building") then
							passStructure = true
						end
					end
				end

				if target.elements  then
					for element_n, element in pairs(target.elements) do						--iterate through target elements
						if element.x then

							local distance = math.floor(math.sqrt((scen.x - element.x)^2 + (scen.y - element.y)^2))					--calculate distance between dead scenery and target element						
							local correctedRadius = RayonDamaged
							if  scen.event == "BOMB_IMPACT_ZONE" or element.class == "static" then
								correctedRadius = 15 -- 15 m
								
							elseif scen.explosiveMass and not scen.event == "BOMB_IMPACT" then
								local k_val = 4.0  -- k = 4 par défaut, typique pour bâtiments légers
								correctedRadius = k_val * (scen.explosiveMass)^(1/3)
							end

							if not scen.lasthit and scen.initiator then
								scen.lasthit = scen.initiator
							end

							if distance <= correctedRadius  then
								
								-- print("DebriefSE =========--> B1 "..tostring(scen.lasthit).." event?: "..tostring(scen.event).." correctedRadius: "..correctedRadius )

								-- print("DebriefSE ========--> B2 distance: "..tostring(distance).." between scenaryName: "..tostring(scen.scenaryName).." sceneryTypeName: "..tostring(scen.sceneryTypeName).." and element.name: "..tostring(element.name))
								
								--plus bas, ne pas l'enlever, car il peut y avoir plusieurs detection de destruction, et cela fausse le resultat car detecté déjà detruit
								if element.dead then	--and element.CheckDay and element.CheckDay < camp.date.CampTotalTimeS 
									-- element.dead_last = false									--mark element as not died in last mission
									-- print("DebriefSE  - --> C1 "..tostring(scen.scenaryName).." and "..tostring(element.name).." element already dead (dead?) "..tostring(element.dead).." "..tostring(element.CheckDay).." "..tostring(camp.date.CampTotalTimeS))
								else
									-- print("DebriefSE  - --> C2 "..tostring(scen.scenaryName).." and "..tostring(element.name).." element not dead yet (dead?) "..tostring(element.dead).." "..tostring(element.CheckDay).." "..tostring(camp.date.CampTotalTimeS))
									element.dead = true											--mark element as dead
									element.dead_last = true									--mark element as died in last mission
									element.CheckDay = camp.date.CampTotalTimeS									-- ajoute la date de destruction		 Miguel21 modification M19.f : Repair SAM	

									scen.lifePourcent = 0

									-- si c'est un static batiment, on casse le batiment aussi dans oob_ground
									if passStructure then
										for sideName, side in pairs(oob_ground) do
											for countryN, country in pairs(side) do
												for class, typetable in pairs(country) do
													if class == "static" then	--class == "vehicle" or class == "ship" or 
														for groupN, group in pairs(typetable.group) do
															for unitN, unit in pairs(group.units) do
																if  element.name == unit.name then
																	unit['dead'] = true
																	unit['dead_last'] = true
																	unit.CheckDay = camp.date.CampTotalTimeS

																end
															end
														end
													end
												end
											end
										end
									end
								end

								if element.dead and not element.lasthit then
									--award ground kill to air unit
									if scen.lasthit ~= nil then																			--check if dead scenery has a hit entry
										
										element.lasthit = scen.lasthit
										
										for killer_side_name,killer_side in pairs(oob_air) do											--iterate through all sides
											for killer_unit_n,killer_unit in pairs(killer_side) do										--iterate through all air units
												if string.find(scen.lasthit, " " .. killer_unit.name .. " ", 1, true) then				--if the hitting unit is part of air unit name
													if side_name == killer_side_name then												--make sure that hitting unit is hitting a target of his own side (friendly fire gives no kills)
														killer_unit.score.kills_ground = killer_unit.score.kills_ground + 1				--award ground kill to air unit
														killer_unit.score_last.kills_ground = killer_unit.score_last.kills_ground + 1
														addPackstats(scen.lasthit, "kill_ground", nil)										--check if kill was in player package

														-- print("DebriefSE  kill_ground - - --> E")

														--award ground kill to client
														if client_control[scen.lasthit] then											--if dead scenery was hit by a client
															clientstats[client_control[scen.lasthit]].kills_ground = clientstats[client_control[scen.lasthit]].kills_ground + 1							--award ground kill to client
															clientstats[client_control[scen.lasthit]].score_last.kills_ground = clientstats[client_control[scen.lasthit]].score_last.kills_ground + 1	--award ground kill to client


															local item = {
																event = scen_name,
																target_name = target.titleName,
																element = element,
															}

															if not clientstatsDetail[client_control[scen.lasthit]] then clientstatsDetail[client_control[scen.lasthit]] = {} end
															table.insert(clientstatsDetail[client_control[scen.lasthit]], item)


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
	end
end

-- print("DebriefSE AAA "..tostring(targetlist.blue[8].elements[2].name).." dead? "..tostring(targetlist.blue[8].elements[2].dead))

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

if Debug.debug then
	camp_str = "clientstats = " .. TableSerialization(clientstats, 0)						--make a string
	campFile = io.open("Debug/DEBRIEF_clientstats.lua", "w") or error("Failed to open debug file")
	campFile:write(camp_str)															--save new data
	campFile:close()
end


-- print(" targetlist E1: "..tostring(camp_triggers))
-- print(" targetlist E2: "..tostring(camp_triggers[1]["name"]))
-- CheckTarget("Vihn Power Plant", "Debrief Z")

