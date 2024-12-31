-- helps the CampaignMaker 
-- appeler par BAT_FirstMission ou BAT_SkipMission
-- avec la commmande w2
-- Supprime un Groupe entier en donnant son numero de groupe
------------------------------------------------------------------------------------------------------- 
-- Last Modification cleancode_a
if not versionDCE then versionDCE = {} end
versionDCE["UTIL_Divers.lua"] = "1.3.22"
------------------------------------------------------------------------------------------------------- 
-- cleancode_a				(a springCleaning)
-- adjustment_a				(a ajout dataMap)
-- modification M38_n		Check and Help CampaignMaker (n: delete Ngroug)
------------------------------------------------------------------------------------------------------- 



require("Active/oob_ground")
dofile("../../../ScriptsMod."..versionPackageICM.."/UTIL_Data.lua")
dofile("../../../ScriptsMod."..versionPackageICM.."/UTIL_DataMap.lua")
dofile("../../../ScriptsMod."..versionPackageICM.."/UTIL_Functions.lua")


-- debugKT = true

function DelGroup(NGroup)
	FoundN_Group = 0
	for side_name,side in pairs(oob_ground) do														--side table(red/blue)											
		for country_n,country in pairs(side) do														--country table (number array)
			if country.vehicle then																	--if country has vehicles
				for group_n,group in pairs(country.vehicle.group) do								--groups table (number array)
					if NGroup == group.groupId then

						FoundN_Group = group_n
						print("UtilD DelGroup table.remove vehicle "..group.name.." "..group.units[1].name)
						break
					end
				end
				if FoundN_Group ~= 0 then table.remove(country.vehicle.group, FoundN_Group ) end
			end
			if country.static and FoundN_Group == 0 then																--if country has static objects	
				for group_n,group in pairs(country.static.group) do								--groups table (number array)
					if NGroup == group.groupId then

						FoundN_Group = group_n
						print("UtilD DelGroup table.remove static "..group.name.." "..group.units[1].name)
						break
					end
				end
				print("UtilD DelGroup passe B ")
				if FoundN_Group ~= 0 then table.remove(country.static.group, FoundN_Group )  print("UtilD DelGroup passe C "..FoundN_Group) end
			end
			if country.ship  and FoundN_Group == 0  then																--if country has ships
				for group_n,group in pairs(country.ship.group) do								--groups table (number array)
					if NGroup == group.groupId then

						FoundN_Group = group_n
						print("UtilD DelGroup table.remove ship "..group.name.." "..group.units[1].name)
						break
					end
				end
				if FoundN_Group ~= 0 then table.remove(country.ship.group, FoundN_Group ) end
			end
		end
	end
end

if ArgTools == "DelGroup" then
	--===================================================================================
	-- Ecran N 1



	repeat
		local input = 0
		local inputString = ""

		print("N  de groupe a supprimer ")				--ask for user confirmation
		print("(S) Stop script ?")
		inputString = string.lower(io.read())

		if inputString == "s" then
			break
		else
			-- Convertir inputString en nombre
			local convertedInput = tonumber(inputString) -- Conversion potentiellement nil
			if convertedInput then
				input = convertedInput -- Assigner seulement si la conversion a réussi
				DelGroup(input)
			else
				print("Erreur : Entrée invalide. Veuillez entrer un nombre.")
			end
		end


		io.write( "\n")

	until  input == "s" or inputString == "s"

	io.write( "\n")

	local ground_str = "oob_ground = " .. TableSerialization(oob_ground, 0)						--make a string
	local groundFile = io.open("Active/oob_ground.lua", "w") or error("Failed to open debug file")
	groundFile:write(ground_str)																--save new data
	groundFile:close()

	StopBug = true

	os.execute 'pause'
	os.exit()

elseif ArgTools == "fuelConsumption" then

	print("Felicitation, fuelConsumption va commencer ^^: \n")

	local typeTaskLoadouts = {}

	-- parse toutes les unités et rempli le tab tabTaskAvailable pour etre sur de proposer toutes les task proposé active 
	for side , squads in PairsByKeys(oob_air) do
		-- print() print(side..":")

		for squadN , squad in PairsByKeys(squads) do

			for task, taskBool in PairsByKeys(squad.tasks) do
				if taskBool then

					if not typeTaskLoadouts[side] then typeTaskLoadouts[side] = {} end
					if not typeTaskLoadouts[side][squad.type] then typeTaskLoadouts[side][squad.type] = {} end
					if not typeTaskLoadouts[side][squad.type][task] then typeTaskLoadouts[side][squad.type][task] = {} end

					for loadoutName, loadout in pairs(db_loadouts[squad.type][task]) do
						typeTaskLoadouts[side][squad.type][task][loadoutName] = loadout
					end

				end
			end

		end
	end

	local tabIndex = {}
	local i = 0
	for side , typeTaskLoadout in PairsByKeys(typeTaskLoadouts) do
		print() print(side..":")
		for unitType , byTasks in PairsByKeys(typeTaskLoadout) do
			for task , loadouts in PairsByKeys(byTasks) do
				for loadoutName , loadout in PairsByKeys(loadouts) do
					local testHcruise = tostring(loadout.hCruise)
					local test_vCruise = tostring(loadout.vCruise)
					io.write(i.." : ( "..unitType.." )( "..task..")("..loadoutName..")(hCruise: "..tostring(testHcruise).." m)(vCruise: "..tostring(test_vCruise).." m/s)")

					tabIndex[i]= {
						[unitType] = {
							[loadoutName] = loadout,
						}
					}

					io.write("\n")
					i = i+1
				end
			end
		end
	end

	-- for i , typeLoadouts in PairsByKeys(tabIndex) do
	-- 	for type , loadouts in PairsByKeys(typeLoadouts) do
	-- 		for loadoutName , loadout in PairsByKeys(loadouts) do
	-- 			io.write(i.." : ( "..type.." )("..loadoutName..")".."\n")
	-- 		end

	-- 	end
	-- end
	--===================================================================================
	-- Ecran N°5 Selection Nombre d'avion Multiplayer
	repeat
		local choixB = tonumber(io.stdin:read())
		if  tabIndex[choixB] then

			SelectedLoadout = tabIndex[choixB]

		else
			print("\nInvalid entry.\n")
		end
	until   tabIndex[choixB]

	io.write( "\n")


	----- unpack template mission file ----
	local minizip = require('minizip')

	local zipFile = minizip.unzOpen("Init/base_mission.miz", 'rb')

	zipFile:unzLocateFile('mission')
	local misStr = zipFile:unzReadAllCurrentFile()
	local misStrFunc = loadstring(misStr)()

	zipFile:unzLocateFile('options')
	local optStr = zipFile:unzReadAllCurrentFile()
	local optStrFunc = loadstring(optStr)()

	zipFile:unzLocateFile('warehouses')
	local warStr = zipFile:unzReadAllCurrentFile()
	local warStrFunc = loadstring(warStr)()

	zipFile:unzLocateFile('l10n/DEFAULT/dictionary')
	local dicStr = zipFile:unzReadAllCurrentFile()
	local dicStrFunc = loadstring(dicStr)()

	zipFile:unzLocateFile('l10n/DEFAULT/mapResource')
	local resStr = zipFile:unzReadAllCurrentFile()
	local resStrFunc = loadstring(resStr)()

	zipFile:unzClose()

	print("mission.version "..mission.version)



	mission.drawings = nil
	mission["trig"] =
	{
		["actions"] =
		{
		}, -- end of ["actions"]
		["events"] =
		{
		}, -- end of ["events"]
		["custom"] =
		{
		}, -- end of ["custom"]
		["func"] =
		{
		}, -- end of ["func"]
		["flag"] =
		{
		}, -- end of ["flag"]
		["conditions"] =
		{
		}, -- end of ["conditions"]
		["customStartup"] =
		{
		}, -- end of ["customStartup"]
		["funcStartup"] =
		{
		}, -- end of ["funcStartup"]
	}

	for side, sideTab in pairs(mission.coalition) do
		for countryN, countryTab in pairs(sideTab.country) do
			if countryTab.helicopter then countryTab.helicopter = nil end
			if countryTab.ship then countryTab.ship = nil end
			if countryTab.static then countryTab.static = nil end
			if countryTab.vehicle then countryTab.vehicle = nil end
			if countryTab.plane then countryTab.plane = {} end
		end
	end


	mission["failures"] =
	{
	}

	mission["triggers"] =
	{
		["zones"] =
		{}
	}



	local groupEntries = {}

	local nbGroup = 1

	for typePlane , loadouts in PairsByKeys(SelectedLoadout) do
		for loadoutName , loadout in PairsByKeys(loadouts) do
			-- io.write(i.." : ( "..type.." )("..loadoutName..")".."\n")

			if not mission["coalition"]["red"]["country"][1]["plane"] then mission["coalition"]["red"]["country"][1]["plane"] = {} end
			if not mission["coalition"]["red"]["country"][1]["plane"]["group"] then
				mission["coalition"]["red"]["country"][1]["plane"] =
				{
					["group"] = {}

				}
			end

			local altTest
			local viTest

			if not loadout.hCruise then
				if Data_divers and Data_divers[typePlane] and Data_divers[typePlane].hCruise then
					loadout.hCruise = Data_divers[typePlane].hCruise
				end
			end
			
			if not loadout.vCruise then
				if Data_divers and Data_divers[typePlane] and Data_divers[typePlane].vCruise then
					loadout.vCruise = Data_divers[typePlane].vCruise
				end
			end


			for vi = 1, 10 do

				if nbGroup == 1 then
					altTest = loadout.hCruise
					viTest = loadout.vCruise
				elseif nbGroup == 2 then
					altTest = loadout.hCruise - 3048
				else
					viTest = loadout.vCruise - 25
				end

				for ai = 1, 10 do

					local init_x = mission.coalition.red.bullseye.x + (nbGroup * 500 )
					local init_y = mission.coalition.red.bullseye.y + (nbGroup * 500 )

					local bis_x = init_x + 300000
					local bis_y = init_y

					local route =
					{
						["points"] =
						{
							[1] =
							{
								["ETA"] = 0,
								["ETA_locked"] = true,
								["action"] = "Turning Point",
								["alt"] = altTest,
								["alt_type"] = "RADIO",
								["formation_template"] = "",
								["name"] = "",
								["speed"] = viTest,
								["speed_locked"] = true,
								["task"] =
								{
									["id"] = "ComboTask",
									["params"] =
									{
										["tasks"] = {}
									},
								},
								["type"] = "Turning Point",
								["x"] = init_x,
								["y"] = init_y,
							},
							[2] =
							{
								["ETA"] = 100000/viTest,
								["ETA_locked"] = false,
								["action"] = "Turning Point",
								["alt"] = altTest,
								["alt_type"] = "BARO",
								["formation_template"] = "",
								["name"] = "",
								["speed"] = viTest,
								["speed_locked"] = true,
								["task"] =
								{
									["id"] = "ComboTask",
									["params"] =
									{
										["tasks"] = {}
									},
								},
								["type"] = "Turning Point",
								["x"] = bis_x,
								["y"] = bis_y,
							},
						},
					}

					local n = 1
					local units = {}

					local groupName = "FuelConsumption - " .. nbGroup
					if nbGroup == 1 then
						groupName = "ORIGINE LOADOUT "..nbGroup.." alt: "..altTest.." Vi: "..viTest
					elseif nbGroup >= 2 then
						groupName = "OrReglage LOADOUT "..nbGroup.." alt: "..altTest.." Vi: "..viTest
					end

					local unitName = groupName .. " -n- " .. n

					print(unitName)

					units[n] =
					{
						["alt"] = altTest,
						["speed"] = viTest,
						["heading"] = 0,
						-- ["callsign"] = GetCallsign(flight[f].country, f, n, "Nothing", 1),
						["psi"] = 0,
						-- ["livery_id"] = flight[f].livery,
						["type"] = typePlane,
						["x"] = init_x ,
						["y"] = init_y ,
						["name"] = unitName,
						["payload"] = {
							["pylons"] = loadout.stores.pylons,
							["fuel"] = loadout.stores.fuel,
							["flare"] = loadout.stores.flare,
							["chaff"] = loadout.stores.chaff,
							["gun"] =  loadout.stores.gun,
							['DCE_payloadtName'] = loadout.name,
						},
						["AddPropAircraft"] = loadout.AddPropAircraft,
						["unitId"] = GenerateIDUnit(unitName),
						["alt_type"] = "BARO",
						["skill"] = "High",
						["hardpoint_racks"] = true,

					}


					local groupEntries =
					{
						-- ['frequency'] = frequencyIni +1,
						['taskSelected'] = true,
						['modulation'] = 0,
						['groupId'] = GenerateIDGroup(),
						['tasks'] = {
						},
						['route'] = route,
						-- ['hidden'] = true,
						['units'] = units,
						['radioSet'] = true,
						["name"] = groupName,
						['communication'] = true,
						['x'] = init_x,
						['y'] = init_y,
						['start_time'] = 1,
						['task'] = 0,
						['uncontrolled'] = false,

					}


					table.insert(mission["coalition"]["red"]["country"][1]["plane"]["group"], groupEntries)

					if nbGroup >= 2 then
						viTest = viTest + 5
					end

					nbGroup = nbGroup + 1

				end

				if nbGroup >= 2 then
					altTest = altTest + 30.48
				elseif nbGroup == 2 then
					break
				end

			end

		--****************************************************************************
		print("**************")
		--****************************************************************************
			altTest = 3280.84
			-- viTest

			for vi = 1, 10 do

				viTest = 110

				for ai = 1, 15 do

					local init_x = mission.coalition.red.bullseye.x + (nbGroup * 500 )
					local init_y = mission.coalition.red.bullseye.y + (nbGroup * 500 )

					local bis_x = init_x + 300000
					local bis_y = init_y

					local route =
					{
						["points"] =
						{
							[1] =
							{
								["ETA"] = 0,
								["ETA_locked"] = true,
								["action"] = "Turning Point",
								["alt"] = altTest,
								["alt_type"] = "RADIO",
								["formation_template"] = "",
								["name"] = "",
								["speed"] = viTest,
								["speed_locked"] = true,
								["task"] =
								{
									["id"] = "ComboTask",
									["params"] =
									{
										["tasks"] = {}
									},
								},
								["type"] = "Turning Point",
								["x"] = init_x,
								["y"] = init_y,
							},
							[2] =
							{
								["ETA"] = 100000/viTest,
								["ETA_locked"] = false,
								["action"] = "Turning Point",
								["alt"] = altTest,
								["alt_type"] = "BARO",
								["formation_template"] = "",
								["name"] = "",
								["speed"] = viTest,
								["speed_locked"] = true,
								["task"] =
								{
									["id"] = "ComboTask",
									["params"] =
									{
										["tasks"] = {}
									},
								},
								["type"] = "Turning Point",
								["x"] = bis_x,
								["y"] = bis_y,
							},
						},
					}

					local n = 1
					local units = {}

					local groupName = "FuelConsumption - " .. nbGroup

					groupName = groupName.." alt: "..altTest.." Vi: "..viTest

					local unitName = groupName .. " -n- " .. n

					print(unitName)

					units[n] =
					{
						["alt"] = altTest,
						["speed"] = viTest,
						["heading"] = 0,
						-- ["callsign"] = GetCallsign(flight[f].country, f, n, "Nothing", 1),
						["psi"] = 0,
						-- ["livery_id"] = flight[f].livery,
						["type"] = typePlane,
						["x"] = init_x ,
						["y"] = init_y ,
						["name"] = unitName,
						["payload"] = {
							["pylons"] = loadout.stores.pylons,
							["fuel"] = loadout.stores.fuel,
							["flare"] = loadout.stores.flare,
							["chaff"] = loadout.stores.chaff,
							["gun"] =  loadout.stores.gun,
							['DCE_payloadtName'] = loadout.name,
						},
						["AddPropAircraft"] = loadout.AddPropAircraft,
						["unitId"] = GenerateIDUnit(unitName),
						["alt_type"] = "BARO",
						["skill"] = "High",
						["hardpoint_racks"] = true,

					}


					local groupEntries =
					{
						-- ['frequency'] = frequencyIni +1,
						['taskSelected'] = true,
						['modulation'] = 0,
						['groupId'] = GenerateIDGroup(),
						['tasks'] = {
						},
						['route'] = route,
						-- ['hidden'] = true,
						['units'] = units,
						['radioSet'] = true,
						["name"] = groupName,
						['communication'] = true,
						['x'] = init_x,
						['y'] = init_y,
						['start_time'] = 1,
						['task'] = 0,
						['uncontrolled'] = false,

					}


					table.insert(mission["coalition"]["red"]["country"][1]["plane"]["group"], groupEntries)

					viTest = viTest + 20

					nbGroup = nbGroup + 1

				end

				altTest = altTest + 609.6

			end
		end

	end

	-- local trig_n =  #mission.trig.actions + 1
	local trig_n =  1
	mapResource =
	{
	} -- end of mapResource

	local filename = "collectFuelData.lua"
	local rule = nil

	rule = nil

	local predicate = ""

	local predicate1 = "triggerStart"
	local predicate2 = 'a_do_script_file'

	mission.maxDictId = mission.maxDictId + 1
	mapResource["ResKey_Action_" .. mission.maxDictId] = filename
	mission.trig.funcStartup[trig_n] = "if mission.trig.conditions[" .. trig_n .. "]() then mission.trig.actions[" .. trig_n .. "]() end"
	mission.trig.flag[trig_n] = true
	mission.trig.conditions[trig_n] = "return(true)"

	mission.trig.actions[trig_n] = "a_do_script_file(getValueResourceByKey(\"ResKey_Action_" .. mission.maxDictId .. "\"));"


	mission.trigrules[trig_n] = {
		['rules'] = { rule },
		['eventlist'] = '',
		['comment'] = 'Trigger ' .. trig_n,
		['predicate'] = predicate1,
		['actions'] = {
			[1] = {
				['file'] = 'ResKey_Action_' .. mission.maxDictId,
				['predicate'] = predicate2,
				-- ['ai_task'] = {
				-- 	[1] = '',
				-- 	[2] = '',
				-- },
			},
		},
	}

	mission["forcedOptions"] =
	{
		["RBDAI"] = true,
		["accidental_failures"] = false,
		["birds"] = 0,
		["civTraffic"] = "",
		["cockpitStatusBarAllowed"] = false,
		["cockpitVisualRM"] = true,
		["externalViews"] = true,
		["labels"] = 0,
		["miniHUD"] = false,
		["optionsView"] = "optview_all",
		["permitCrash"] = true,
		["userMarks"] = true,
		["wakeTurbulence"] = false,
	}


	print("UtilDivers ajout avec (normalement du succes^^) de "..nbGroup.." groupe d'avion")


	----- convert tables back to strings for insertion into content files -----
	local misStr = "mission = " .. TableSerialization(mission, 0)
	local optStr = "options = " .. TableSerialization(options, 0)
	local warStr = "warehouses = " .. TableSerialization(warehouses, 0)
	local dicStr = "dictionary = " .. TableSerialization(dictionary, 0)
	local resStr = "mapResource = " .. TableSerialization(mapResource, 0)
	-- local gciStr = "GCI = " .. TableSerialization(GCI, 0)

	----- create temporary content files of new mission file -----
	local misFile = io.open("misFile.lua", "w") or error("Failed to open debug file")
	misFile:write(misStr)
	misFile:close()

	local optFile = io.open("optFile.lua", "w") or error("Failed to open debug file")
	optFile:write(optStr)
	optFile:close()

	local warFile = io.open("warFile.lua", "w") or error("Failed to open debug file")
	warFile:write(warStr)
	warFile:close()

	local dicFile = io.open("dicFile.lua", "w") or error("Failed to open debug file")
	dicFile:write(dicStr)
	dicFile:close()

	local resFile = io.open("resFile.lua", "w")	 or error("Failed to open debug file")
	resFile:write(resStr)
	resFile:close()

	-- local gciFile = io.open("GCIdata.lua", "w") or error("Failed to open debug file")
	-- gciFile:write(gciStr)
	-- gciFile:close()


	-- local miz = minizip.zipCreate("Debug/mission_fuelConsumption.miz")
	local miz = minizip.zipCreate("mission_fuelConsumption.miz")

	miz:zipAddFile("mission", "misFile.lua")
	miz:zipAddFile("options", "optFile.lua")
	miz:zipAddFile("warehouses", "warFile.lua")
	miz:zipAddFile("l10n/DEFAULT/dictionary", "dicFile.lua")
	miz:zipAddFile("l10n/DEFAULT/mapResource", "resFile.lua")

	-- miz:zipAddFile("l10n/DEFAULT/GCIdata.lua", "GCIdata.lua")
	miz:zipAddFile("l10n/DEFAULT/collectFuelData.lua", "../../../ScriptsMod."..versionPackageICM.."/Mission Scripts/collectFuelData.lua")

	miz:zipClose()




	----- remove temporary content files -----
	os.remove("misFile.lua")
	os.remove("optFile.lua")
	os.remove("warFile.lua")
	os.remove("dicFile.lua")
	os.remove("resFile.lua")
	os.remove("GCIdata.lua")

	local miss_str = "mission = " .. TableSerialization(mission, 0)
	local missFile = io.open("Debug/mission_fuelConsumption.lua", "w") or error("Failed to open debug file")
	missFile:write(miss_str)
	missFile:close()

	os.execute 'pause'
	os.exit()

end