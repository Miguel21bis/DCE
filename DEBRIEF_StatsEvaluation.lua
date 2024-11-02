--To evaluate the DCS debrief.log and update the campaign status files
--Initiated by DEBRIEF_Master.lua
-------------------------------------------------------------------------------------------------------
-- last modification:  debug_j
if not versionDCE then versionDCE = {} end
versionDCE["DEBRIEF_StatsEvaluation.lua"] = "1.8.64"
------------------------------------------------------------------------------------------------------- 
-- debug_j						(j element.x)(i inconnu events[e].initiator)(g mission+1) hit name)(h take debrief camp_status)(g some kills are not counted)(f debrief bug)(e initiatorPilotName)(c:equipage compte 2X)(b transport)(a: nom cible peut ressembler à nom AirUnit)
-- cleanCode_g
-- adjustment_i					(i Debug/statsClientDetails) (g soldat inconnu)(f reveals the SAM that have already fired)
-- modification M66_a			bombOnRunway
-- modification M61_a			SAR
-- modification M50_a			Records landings for later use in logistics (C-130, Transport...)
-- modification M19_f			Repair SAM
-- modification M11A_be			Multiplayer	(be camp.client)(y: force same package)
------------------------------------------------------------------------------------------------------- 

if not acceptedMission or acceptedMission == nil then
	oob_air = deepcopy(oob_air)
	oob_ground = deepcopy(oob_ground)
	targetlist = deepcopy(targetlist)
	clientstats = deepcopy(clientstats)
	camp = deepcopy(camp)
	camp_ZoneSAR = deepcopy(camp_ZoneSAR)

	print()
else



	--TODO targetlist est repris à 0 ici, pas top
	oob_air = nil
	dofile("Active/oob_air.lua")

	oob_ground = nil
	dofile("Active/oob_ground.lua")

	--clean All Id 
	allIdGroupImport = false
	allIdUnitImport = false

	getAllId()

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
	local TestPath = io.open(zoneSARFile, "r")																--cette maniere de chercer la presence d un fichier evite un plantage
	if TestPath ~= nil then																					--check si le fichier existe dans ScriptsMod
		io.close(TestPath)
		require("Active/camp_ZoneSAR")																--zoneSAR
	end

end

require("Active/last_Mission")

dofile("../../../ScriptsMod."..versionPackageICM.."/DC_UpdateSAR.lua")

-- print("DebriefStatsEvaluation Initialisation acceptedMission? "..tostring(acceptedMission))
-- os.execute 'pause'

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
				end
			end
		end
		if country.static then																--if country has static objects
			for group_n,group in pairs(country.static.group) do								--groups table (number array)
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
		if target.elements and target.elements[1].x then									--if the target has subelements and is a scenery object target (element has x coordinate)
			for element_n,element in pairs(target.elements) do								--iterate through target elements
				element.dead_last = false													--reset element died in last mission
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
local function AddClient(name)
	
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

		-- --ajoute les clefs manquantes de la table score_last  pour rétrocomtabilité
		-- for key, value in pairs(tabValues.score_last) do
		-- 	local foundKey = false
		-- 	for clientK, clientV in pairs(clientstats[name].score_last) do
		-- 		if key == clientK then
		-- 			foundKey = true
		-- 			print("DebriefSE foundKey "..key)
		-- 			break
		-- 		end

		-- 	end
		-- 	if not foundKey then
		-- 		print("DebriefSE NOT foundKey "..key)
		-- 		os.execute 'pause'
		-- 		clientstats[name].score_last[key] = 0
		-- 	end
		-- end
		

	end
end

--track stats for player package
packstats = {}
if camp.client then
	-- local testN = 999
	-- --recupere la plus petite valeur de pack, le strike est surement dedans
	-- for _N, value in pairs(camp.MultiPlayer.pack_n) do
		-- N_Pack = tonumber(_N)
		-- if testN > N_Pack then
			-- testN = N_Pack	
		-- end
	-- end	
	-- local packN = testN	
	-- camp.player = camp.client[packN]
	
	
	local packN = 1
	--recupere la valeur du pack qui est striker
	for nClient, pack_ in pairs(camp.client) do
		if string.find(pack_["pack"]["main"][1]["task"] , "Strike") then
			packN = nClient
			break
		end
	end
	
	camp.player = camp.client[packN]

end

-- local camp_str = "DEBRIEF_States = " .. TableSerialization(camp.player, 0)						--make a string
-- local campFile = io.open("DebugDEBRIEF_States.lua", "w")										--open targetlist file
-- campFile:write(camp_str)																		--save new data
-- campFile:close()

for role_name, role in pairs(camp.player.pack) do														--iterate through roles in player package
	for flight_n, flight in pairs(role) do																--iterate through flights
		for n = 1, flight.number do
			local unitname = "Pack " .. camp.player.pack_n .. " - " .. flight.name .. " - " .. flight.task .. " " .. flight_n .. "-" .. n
			packstats[unitname] = {
				kills_air = 0,
				kills_ground = 0,
				kills_ship = 0,
				lost = 0,
			}
		end
	end
end
-- end
--function to check if a kill loss is attributed to the player package
local function AddPackstats(unitname, event)
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
	-- if events[e].initiatorPilotName then
	-- 	print("DebriefSE e: "..tostring(e).." initiatorPilotName: "..tostring( events[e].initiatorPilotName).." initiator: "..tostring(events[e].initiator))
	-- end
	
	if events[e].initiator and string.find(events[e].initiator, "parachut") then			
		events[e].initiator = tostring(events[e].initiatorPilotName)
	end
	
	if events[e].initiatorPilotName and events[e].initiatorPilotName ~= nil  and events[e].initiatorPilotName ~= "nil" then	 															--event is by a client
		AddClient(events[e].initiatorPilotName)
		client_control[events[e].initiator] = events[e].initiatorPilotName								--store which unit name (initiaror) is controllen by cliend (PilotName)
	end
end

local tabTransport = {}
--evaluate log events
for e = 1, #events do	
	
	-- _affiche(events[e], "DebriefSE events[e] "..e)
	
	if events[e].initiator and not statutObject[events[e].initiator] then
		statutObject[events[e].initiator] = {
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

	if events[e].target and not statutObject[events[e].target] then
		statutObject[events[e].target] = {
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
	if events[e].type == "birth" then																		--hit events
		statutObject[events[e].initiator] = {
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
	-- elseif events[e].type == "unit lost" then																		--hit events
	-- 	statutObject[events[e].initiator]["unit lost"] = true
				
	-- elseif events[e].type == "hit"  and  not statutObject[events[e].target]["unit lost"] then				--  statutObject[events[e].target] ~= "unit lost"														--hit events
	elseif events[e].type == "hit"  and  not statutObject[events[e].target].kill  and  not statutObject[events[e].target].crash then
		hit_table[events[e].target] = events[e].initiator												--store who hits a target (subsequent hits overwrite previous hits)
		statutObject[events[e].target].hit = true
		health_table[events[e].target] = events[e].health												--store health of the target
		client_hit_table[events[e].target] = client_control[events[e].initiator]						--store client name that has hit a unit (stores nil  if hitter is not a client)
		
	elseif events[e].type == "crash" and events[e].initiator then
		--oob loss update for crashed aircraft
		if statutObject[events[e].initiator].kill == false   then --and  statutObject[events[e].initiator] ~= "unit lost"
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
							AddPackstats(events[e].initiator, "lost")											--check if loss was in player package
							
							--client stats for crashes
							if client_control[events[e].initiator] and ( (events[e].t - clientstats[client_control[events[e].initiator]].score_last.Time_Crash) >   30) then											--if crashed aircraft is a client
							
								clientstats[client_control[events[e].initiator]].crash = clientstats[client_control[events[e].initiator]].crash + 1	--store crash for client
								clientstats[client_control[events[e].initiator]].score_last.crash =  1			--store crash for client
								clientstats[client_control[events[e].initiator]].score_last.Time_Crash = events[e].t
							
							end
							break
						end
					end
				-- end
			end
			
			--oob kill update for crashed aircraft
			for killer_side_name,killer_side in pairs(oob_air) do											--iterate through all sides
				for killer_unit_n,killer_unit in pairs(killer_side) do										--iterate through all air units
					if hit_table[events[e].initiator] ~= nil then											--check if the crashed aircraft has a hit entry
						if string.find(hit_table[events[e].initiator], " " .. killer_unit.name .. " ", 1, true) then			--if the hitting unit is part of air unit name
							if crash_side ~= killer_side_name then											--make sure that hitting unit and crashed aircraft are not on same side (friendly fire is not awarded as kill)
								killer_unit.score.kills_air = killer_unit.score.kills_air + 1				--award air kill to air unit
								killer_unit.score_last.kills_air = killer_unit.score_last.kills_air + 1		--increase kill counter for this mission of air unit
								AddPackstats(hit_table[events[e].initiator], "kill_air")					--check if kill was in player package
								
								--client stats for kills
								if client_hit_table[events[e].initiator] then								--if crashed aircraft was hit by a client
									clientstats[client_hit_table[events[e].initiator]].kills_air = clientstats[client_hit_table[events[e].initiator]].kills_air + 1	--award air kill to client
									clientstats[client_hit_table[events[e].initiator]].score_last.kills_air = clientstats[client_hit_table[events[e].initiator]].score_last.kills_air + 1
								end
								break
							end
						end
					end
				end
			end
			if hit_table[events[e].initiator] then
				hit_table[events[e].initiator] = nil															--once kills for the dead aircraft are awarded, remove it from the hit_table. The aircraft remaining in the hit_table after completed log evaluation are only damaged.
			end
		end
		statutObject[events[e].initiator].crash = true

	elseif events[e].type == "kill" then
		--oob loss update for crashed aircraft
		local targetSide																				--local variable to store the side of the crashed aircraft
		local targetIsPlane
		local killerIsPlane
		for target_side_name, target_side in pairs(oob_air) do											--iterate through all sides
			if target_side_name and type(target_side) == "table" then
				-- print("DebriefSE B")
				-- print("DebriefSE "..tostring(events[e].target).." | "..tostring(events[e].targetPilotName).." |target_side_name: "..tostring(killer_side_name).." table? "..type(killer_side))
			
				for target_unit_n, target_unit in pairs(target_side) do										--iterate through all air units
					if events[e].target and string.find(events[e].target, " " .. target_unit.name .. " ", 1, true) then		--if the crashed aircraft name is part of air unit name
						targetIsPlane = true
						targetSide = target_side_name														--store side of the crashed aircraft
						target_unit.roster.lost = target_unit.roster.lost + 1								--increase loss counter of air unit
						target_unit.score_last.lost = target_unit.score_last.lost + 1						--increase loss counter for this mission of air unit
						target_unit.roster.ready = target_unit.roster.ready - 1								--decrease number of ready aircraft of air unit
						target_unit.score_last.ready = target_unit.score_last.ready + 1						--decrease number of ready aircraft for this mission of air unit
						AddPackstats(events[e].target, "lost")											--check if loss was in player package
						
						--client stats for crashes
						if client_control[events[e].target] and ( (events[e].t - clientstats[client_control[events[e].target]].score_last.Time_Crash) >   30) then											--if crashed aircraft is a client
						
							clientstats[client_control[events[e].target]].crash = clientstats[client_control[events[e].target]].crash + 1	--store crash for client
							clientstats[client_control[events[e].target]].score_last.crash =  1			--store crash for client
							clientstats[client_control[events[e].target]].score_last.Time_Crash = events[e].t
						
						end
						break
					end
				end
			end
		end
		
		--oob kill update for crashed aircraft
		if targetIsPlane then
			for killer_side_name, killer_side in pairs(oob_air) do											--iterate through all sides
				for killer_unit_n, killer_unit in pairs(killer_side) do										--iterate through all air units
					--hit_table[events[e].target] = events[e].initiator
					if hit_table[events[e].target] ~= nil then											--check if the crashed aircraft has a hit entry
						if string.find(hit_table[events[e].target], " " .. killer_unit.name .. " ", 1, true) then			--if the hitting unit is part of air unit name
							killerIsPlane = true
							killer_unit.score.kills_air = killer_unit.score.kills_air + 1				--award air kill to air unit
							killer_unit.score_last.kills_air = killer_unit.score_last.kills_air + 1		--increase kill counter for this mission of air unit
							AddPackstats(hit_table[events[e].target], "kill_air")					--check if kill was in player package
							
							--client stats for kills
							if client_hit_table[events[e].target] then								--if crashed aircraft was hit by a client
								clientstats[client_hit_table[events[e].target]].kills_air = clientstats[client_hit_table[events[e].target]].kills_air + 1	--award air kill to client
								clientstats[client_hit_table[events[e].target]].score_last.kills_air = clientstats[client_hit_table[events[e].target]].score_last.kills_air + 1
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

		if  targetIsPlane  and  hit_table[events[e].target] then
			hit_table[events[e].target] = nil															--once kills for the dead aircraft are awarded, remove it from the hit_table. The aircraft remaining in the hit_table after completed log evaluation are only damaged.
			-- if string.find(events[e].target, "152 Filo") then
			-- 	print("hit_table " ..events[e].target.." "..tostring(hit_table[events[e].target]))
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

			local task = ""
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

		statutObject[events[e].target].kill = true

	elseif events[e].type == "eject" and events[e].initiator then
		--client stats for ejections
		if client_control[events[e].initiator] and ( (events[e].t - clientstats[client_control[events[e].initiator]].score_last.Time_Eject) >   30)  then														--if ejected pilot is a client

			clientstats[client_control[events[e].initiator]].eject = clientstats[client_control[events[e].initiator]].eject + 1	--store ejection for client
			clientstats[client_control[events[e].initiator]].score_last.eject =  1						--store eject for client
			clientstats[client_control[events[e].initiator]].score_last.Time_Eject = events[e].t
		end
		statutObject[events[e].initiator].eject = true
	elseif events[e].type == "pilot dead" and events[e].initiator then
		--client stats for dead pilots
		if client_control[events[e].initiator] and ( (events[e].t - clientstats[client_control[events[e].initiator]].score_last.Time_Dead) >   30) then														--if dead pilot is a client
			clientstats[client_control[events[e].initiator]].dead = clientstats[client_control[events[e].initiator]].dead + 1	--store death for client
			clientstats[client_control[events[e].initiator]].score_last.dead =  1						--store dead pilot for client
			clientstats[client_control[events[e].initiator]].score_last.Time_Dead = events[e].t
		end
		statutObject[events[e].initiator]["pilot dead"] =  true

	elseif events[e].type == "pilot land" and events[e].initiator then

		--client stats for landing pilots
		if client_control[events[e].initiator] and ( (events[e].t - clientstats[client_control[events[e].initiator]].score_last.Time_MIA) >   30) then														--if landing pilot is a client
			clientstats[client_control[events[e].initiator]].MIA = clientstats[client_control[events[e].initiator]].MIA + 1	--store MIA for client
			clientstats[client_control[events[e].initiator]].score_last.MIA =  1						--store MIA pilot for client
			clientstats[client_control[events[e].initiator]].score_last.Time_MIA = events[e].t
		
			-- print("DebriefSE initiator "..tostring(events[e].initiator).." MIA: "..tostring(clientstats[client_control[events[e].initiator]].MIA))
		
		end
		statutObject[events[e].initiator]["pilot land"] = true

	elseif events[e].type == "takeoff" and events[e].initiator then
		--client stats for flown missions
		if client_control[events[e].initiator] then														--if take off is by a client
			if clientstats[client_control[events[e].initiator]].score_last.mission == 0 then			--client has no take off logged yet for this mission
				clientstats[client_control[events[e].initiator]].mission = clientstats[client_control[events[e].initiator]].mission + 1	--increase flown mission number
				clientstats[client_control[events[e].initiator]].score_last.mission = 1					--store mission for client
			end
		end
		statutObject[events[e].initiator].takeoff = true

	elseif events[e].type == "embarkedEjectedPilot" then
		if client_control[events[e].initiator] and ( (events[e].t - clientstats[client_control[events[e].initiator]].score_last.Time_rescued ) >   30) then														
			if clientstats[client_control[events[e].initiator]].score_last.rescued  == 0 then			
				clientstats[client_control[events[e].initiator]].rescued  = clientstats[client_control[events[e].initiator]].rescued  + 1	
				clientstats[client_control[events[e].initiator]].score_last.rescued  = 1					
				clientstats[client_control[events[e].initiator]].score_last.Time_rescued =  events[e].t

				clientstats[client_control[events[e].initiator]].MIA = clientstats[client_control[events[e].initiator]].MIA - 1	
				clientstats[client_control[events[e].initiator]].score_last.MIA =  -1						
			end
		end

	elseif events[e].type == "land" then
		--client stats for land
		if client_control[events[e].initiator] then														--if take off is by a client
			if clientstats[client_control[events[e].initiator]].score_last.mission == 0 then			--client has no take off logged yet for this mission
				clientstats[client_control[events[e].initiator]].mission = clientstats[client_control[events[e].initiator]].mission + 1	--increase flown mission number
				clientstats[client_control[events[e].initiator]].score_last.mission = 1					--store mission for client
			end		
		end

		if events[e].initiator and string.find(events[e].initiator,"Transport") and not tabTransport[events[e].initiator] then
			local payload  = 0
			
			if payloadType[events[e].type_name] then
				payload  = payloadType[events[e].type_name]																--see UTIL_Data.lua
			end
			
			if events[e].place then
				if db_airbases[events[e].place]  then					
					if not db_airbases[events[e].place].logistic then
						db_airbases[events[e].place].logistic = 0
					end
					db_airbases[events[e].place].logistic = db_airbases[events[e].place].logistic + payload 
					tabTransport[events[e].initiator] = true
				elseif db_airbases[events[e].place.." Airbase"] then
					if not db_airbases[events[e].place.." Airbase"].logistic then
						db_airbases[events[e].place.." Airbase"].logistic = 0
					end
					db_airbases[events[e].place.." Airbase"].logistic = db_airbases[events[e].place.." Airbase"].logistic + payload
					tabTransport[events[e].initiator] = true				
				end
			end
		end

		if events[e].initiator then	statutObject[events[e].initiator].land = true end
		
	elseif (events[e].type == "dead" or events[e].type == "unit lost") and events[e].initiator then
		--ground/naval/static loss events																--iterate through all the sub-tables of the oob_ground files and try to find the matching unitId of the dead unit (vehicle/ship/static)
		local debugShow = false

		if events[e].type == "unit lost" then																		--hit events
			statutObject[events[e].initiator]["unit lost"] = true
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
									if hit_table[events[e].initiator] ~= nil then														--check if dead vehicle has a hit entry
										for killer_side_name,killer_side in pairs(oob_air) do											--iterate through all sides
											for killer_unit_n,killer_unit in pairs(killer_side) do										--iterate through all air units
												if string.find(hit_table[events[e].initiator], " " .. killer_unit.name .. " ", 1, true) then	--if the hitting unit is part of air unit name
													if side_name ~= killer_side_name then												--make sure that hitting unit is not on same side as dead unit (friendly fire gives no kills)
														killer_unit.score.kills_ground = killer_unit.score.kills_ground + 1				--award ground kill to air unit
														killer_unit.score_last.kills_ground = killer_unit.score_last.kills_ground + 1
														AddPackstats(hit_table[events[e].initiator], "kill_ground")						--check if kill was in player package
														
														--award ground kill to client
														if client_hit_table[events[e].initiator] then									--if dead vehicle was hit by a client
															clientstats[client_hit_table[events[e].initiator]].kills_ground = clientstats[client_hit_table[events[e].initiator]].kills_ground + 1							--award gound kill to client
															clientstats[client_hit_table[events[e].initiator]].score_last.kills_ground = clientstats[client_hit_table[events[e].initiator]].score_last.kills_ground + 1		--award ground kill to client
														
															local item = {
																event = events[e],
																unit = unit,
															}
															
															if not clientstatsDetail[client_hit_table[events[e].initiator]] then clientstatsDetail[client_hit_table[events[e].initiator]] = {} end
															table.insert(clientstatsDetail[client_hit_table[events[e].initiator]], item)
															
														end
													end
													break
												end
											end
										end
										hit_table[events[e].initiator] = nil							--after kills are assigned, remove hit unit from hit_table
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
								camp.ShipHealth[unit.name] = 0										--mark unit has 0 health for briefing/debriefing
								camp.ShipDamagedLast[unit.name] = true								--mark ship took damage in last mission for briefing/debriefing
								
								--award ship kill to air unit
								if hit_table[events[e].initiator] ~= nil then														--check if dead ship has a hit entry
									for killer_side_name,killer_side in pairs(oob_air) do											--iterate through all sides
										for killer_unit_n,killer_unit in pairs(killer_side) do										--iterate through all air units
											if string.find(hit_table[events[e].initiator], " " .. killer_unit.name .. " ", 1, true) then	--if the hitting unit is part of air unit name
												if side_name ~= killer_side_name then												--make sure that hitting unit is not on same side as dead unit (friendly fire gives no kills)
													killer_unit.score.kills_ship = killer_unit.score.kills_ship + 1					--award ship kill to air unit
													killer_unit.score_last.kills_ship = killer_unit.score_last.kills_ship + 1
													AddPackstats(hit_table[events[e].initiator], "kill_ship")						--check if kill was in player package
													
													--award ship kill to client
													if client_hit_table[events[e].initiator] then									--if dead ship was hit by a client
														clientstats[client_hit_table[events[e].initiator]].kills_ship = clientstats[client_hit_table[events[e].initiator]].kills_ship + 1							--award ship kill to client
														clientstats[client_hit_table[events[e].initiator]].score_last.kills_ship = clientstats[client_hit_table[events[e].initiator]].score_last.kills_ship + 1		--award ship kill to client
													end
												end
												break
											end
										end
									end
									hit_table[events[e].initiator] = nil							--after kills are assigned, remove hit unit from hit_table
								end
								break
							end
						end
					end
				end
				if country.static then																--if country has static objects
					for group_n,group in pairs(country.static.group) do								--groups table (number array)
						for unit_n,unit in pairs(group.units) do									--units table (number array)
							local show = false
							-- if string.find(events[e].initiator, "Khasab ") 
							-- and string.find(unit.name, "Khasab ") 
							-- then 
							-- 	-- print("DebriefSE initiator |"..tostring(events[e].initiator).."| unit.name |"..tostring(unit.name).."|") 
							-- 	show = true
							-- end
							if unit.name == events[e].initiator  and not unit.dead then
								if show then print("DebriefSE    passe AA ") end
								if unit.dead ~= true then											--unit is not yet dead (some static objects that are spawned in a destroyed state are logged dead at mission start, these must be excluded here)
									if show then print("DebriefSE       passe BB ") end
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
									group.hidden = true												--hide dead static object
									unit.dead = true												--mark unit as dead in oob_ground (this is for the targetlist)
									unit.dead_last = true											--mark unit as died in last mission
									unit.CheckDay = camp.date.CampTotalTimeS                            -- ajoute la date de destruction		 Miguel21 modification M19 : Repair SAM	
									
									--award ground kill to air unit
									if hit_table[events[e].initiator] ~= nil then														--check if dead static has a hit entry
										for killer_side_name,killer_side in pairs(oob_air) do											--iterate through all sides
											for killer_unit_n,killer_unit in pairs(killer_side) do										--iterate through all air units
												if string.find(hit_table[events[e].initiator], " " .. killer_unit.name .. " ", 1, true) then	--if the hitting unit is part of air unit name
													if side_name ~= killer_side_name then												--make sure that hitting unit is not on same side as dead unit (friendly fire gives no kills)
														killer_unit.score.kills_ground = killer_unit.score.kills_ground + 1				--award ground kill to air unit
														killer_unit.score_last.kills_ground = killer_unit.score_last.kills_ground + 1
														AddPackstats(hit_table[events[e].initiator], "kill_ground")						--check if kill was in player package
														
														--award ground kill to client
														if client_hit_table[events[e].initiator] then									--if dead static was hit by a client
															clientstats[client_hit_table[events[e].initiator]].kills_ground = clientstats[client_hit_table[events[e].initiator]].kills_ground + 1							--award ground kill to client
															clientstats[client_hit_table[events[e].initiator]].score_last.kills_ground = clientstats[client_hit_table[events[e].initiator]].score_last.kills_ground + 1		--award ground kill to client
															
															local item = {
																event = events[e],
																unit = unit,
															}
															
															if not clientstatsDetail[client_hit_table[events[e].initiator]] then clientstatsDetail[client_hit_table[events[e].initiator]] = {} end
															table.insert(clientstatsDetail[client_hit_table[events[e].initiator]], item)
															
														end
													end
													break
												end
											end
										end
										hit_table[events[e].initiator] = nil						--after kills are assigned, remove hit unit from hit_table
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
									AddPackstats(hitter, "kill_ground")												--check if kill was in player package
									
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


--evaluate destroyed scenery objects
for scen_name,scen in pairs(scen_log) do													--iterate through destroyed scenery objects
	-- if scen.x and scen.z and (scen.lifeActual1s /scen.hightLife < 0.75) then																--scenery object has x and z coordinates
	local passePourcent = false
	if scen.lifePourcent and scen.lifePourcent <= 99 then
		passePourcent = true
	end
	if scen.x and scen.z and passePourcent then
		for side_name, targets in pairs(targetlist) do											--iterate through targetlist
			for targetN, target in pairs(targets) do										--iterate through targets				
				if target.elements  then
					for element_n,element in pairs(target.elements) do						--iterate through target elements
						if element.x then
						
							-- print("DebriefSE element E "..tostring(element.name))
							
							-- if math.floor(scen.x) == math.floor(element.x) and math.floor(scen.z) == math.floor(element.y) then		--dead scenery is this element						
							-- scen.lifePourcent < 100 and
							-- if   (scen.x <= element.x + 50 and scen.x > element.x - 50) and (scen.z <= element.y + 50 and scen.z > element.y - 50) then								
							if (scen.x <= element.x + 100 and scen.x > element.x - 100) and (scen.z <= element.y + 100 and scen.z > element.y - 100) then	
								-- if element.dead and element.CheckDay and element.CheckDay < camp.date.CampTotalTimeS then
								if element.dead then											--element was already dead previously
									element.dead_last = false									--mark element as not died in last mission
								else
									element.dead = true											--mark element as dead
									element.dead_last = true									--mark element as died in last mission
									element.CheckDay = camp.date.CampTotalTimeS									-- ajoute la date de destruction		 Miguel21 modification M19.f : Repair SAM	
									
									--award ground kill to air unit
									if scen.lasthit ~= nil then																			--check if dead scenery has a hit entry
										for killer_side_name,killer_side in pairs(oob_air) do											--iterate through all sides
											for killer_unit_n,killer_unit in pairs(killer_side) do										--iterate through all air units
												if string.find(scen.lasthit, " " .. killer_unit.name .. " ", 1, true) then				--if the hitting unit is part of air unit name
													if side_name == killer_side_name then												--make sure that hitting unit is hitting a target of his own side (friendly fire gives no kills)
														killer_unit.score.kills_ground = killer_unit.score.kills_ground + 1				--award ground kill to air unit
														killer_unit.score_last.kills_ground = killer_unit.score_last.kills_ground + 1
														AddPackstats(scen.lasthit, "kill_ground")										--check if kill was in player package
														
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
													-- break
												end
											end
										end
									end
									-- break
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
-- os.execute 'pause'

-- runwayLife[Id] = {
-- 	name = tostring(b:getName()),
-- 	baseObject = b,
-- 	life0 = baseLife0,
-- 	life = 3600,
-- 	point = point,
-- }
--evaluate destroyed runway objects
if camp.runwayLife then
	for id, runway in pairs(camp.runwayLife) do													--iterate through destroyed scenery objects

		if runway.life < 3600 and runway.name then
			for side_name, targets in pairs(targetlist) do											--iterate through targetlist
				for targetN, target in pairs(targets) do										--iterate through targets				
					if target.db_airbaseName and target.db_airbaseName == runway.name and target.attributes[1] == "Runway" then		--if the target has subelements and is a scenery object target (element has x coordinate)
						
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
							-- os.execute 'pause'
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

	noNeedTask = {
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
	local trigFile = io.open("Debug/newTaskRequest.lua", "w")
	trigFile:write(_Str)
	trigFile:close()

	local _Str = "newTaskPerTarget = " .. TableSerialization(camp.newTaskPerTarget, 0)
	local trigFile = io.open("Debug/newTaskPerTarget.lua", "w")
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


--local _Str = "targetlistA = " .. TableSerialization(targetlist, 0)
--local trigFile = io.open("Debug/targetlistA.lua", "w")
--trigFile:write(_Str)
--trigFile:close()

if Debug.debug and camp.statLost then
	local _Str = "statLost = " .. TableSerialization(camp.statLost, 0)
	local trigFile = io.open("Debug/statLost.lua", "w")
	trigFile:write(_Str)
	trigFile:close()
end



local _Str = "statLost = " .. TableSerialization(clientstatsDetail, 0)
local trigFile = io.open("Debug/statsClientDetails.lua", "w")
trigFile:write(_Str)
trigFile:close()
