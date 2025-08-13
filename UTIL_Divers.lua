-- helps the CampaignMaker 
-- appeler par BAT_FirstMission ou BAT_SkipMission
-- avec la commmande w2
-- Supprime un Groupe entier en donnant son numero de groupe
------------------------------------------------------------------------------------------------------- 
-- Last Modification updateFunction_d
if not versionDCE then versionDCE = {} end
versionDCE["UTIL_Divers.lua"] = "1.4.26"
------------------------------------------------------------------------------------------------------- 
-- cleancode_a				(a springCleaning)
-- adjustment_a				(a ajout dataMap)
-- updateFunction_d			(d helpBalancePower())(c KillTarget())(b fuelConsumption())(a DelGroup())
-- modification M38_n		Check and Help CampaignMaker (n: delete Ngroug)
------------------------------------------------------------------------------------------------------- 



require("Active/oob_ground")
dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_Data.lua")
dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_DataMap.lua")
dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_Functions.lua")


-- debugKT = true

print("START UTIL_Divers ArgTools "..tostring(ArgTools))

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

local debugKT = true

local function activeInactiveGround(targetName, active, dead)
	-- print("UtilKT activeInactiveGround tostring "..tostring(targetName).." active " ..tostring(active).." dead "..tostring(dead))
	local inactive = true
	if active then
		inactive = false
	end

	for side_name,side in pairs(oob_ground) do
		for country_n,country in pairs(side) do
			if country.vehicle then
				for group_n, group in pairs(country.vehicle.group) do
					if targetName == group.name then
						for unit_n, unit in pairs(group.units) do


							if dead then
								unit.dead = true														--mark unit as dead in oob_ground
								unit.dead_last = true													--mark unit as died in last mission
								print("UKT oob_ground dead  vehicle "..unit.name)
							else
								unit.DCE_inactive = inactive
								print("UKT oob_ground PasseIn/Active vehicle "..unit.name)

							end
						end
						if not dead then
							group.DCE_inactive = inactive
							print("UKT oob_ground PasseIn/Active vehicle "..group.name)
						end
					end
				end
			end
			if country.static then
				for group_n, group in pairs(country.static.group) do
					if targetName == group.name then
						for unit_n, unit in pairs(group.units) do

							if dead then
								unit.dead = true														--mark unit as dead in oob_ground
								unit.dead_last = true													--mark unit as died in last mission
								print("UKT oob_ground dead  static "..unit.name)
							else
								unit.DCE_inactive = inactive
								print("UKT oob_ground PasseIn/Active static "..unit.name)

							end
						end
						if not dead then
							group.DCE_inactive = inactive
							print("UKT oob_ground PasseIn/Active static "..group.name)

						end
					end
				end
			end
			if country.ship then
				for group_n,group in pairs(country.ship.group) do
					if targetName == group.name then
						for unit_n,unit in pairs(group.units) do


							if dead then
								unit.dead = true														--mark unit as dead in oob_ground
								unit.dead_last = true													--mark unit as died in last mission
								print("UKT oob_ground dead  ship "..unit.name)
							else
								unit.DCE_inactive = inactive
								print("UKT oob_ground PasseIn/Active ship "..unit.name)
							end
						end
						if not dead then
							group.DCE_inactive = inactive
							print("UKT oob_ground PasseIn/Active ship "..group.name)
						end
					end
				end
			end
		end
	end
end

local function activeInactiveTarget(targetName, active, pourcent, side, dead)
	local inactive = true
	if active then
		inactive = false
	end

	if targetName ~= nil and not dead then
		activeInactiveGround(targetName, active)

		for side_name, targets in pairs(targetlist) do											--iterate through targetlist
			for targetN, target in pairs(targets) do										--iterate through targets
				if targetName == target.titleName then

					target["inactive"] = inactive
					print("UKT targetlist PasseIn/Active ship "..targetName)
				end
			end
		end
	elseif dead == true then
		for side_name, targets in pairs(targetlist) do											--iterate through targetlist
			for targetN, target in pairs(targets) do										--iterate through targets
				if targetName == target.titleName then
					if target.elements then
						for element_n,element in pairs(target.elements) do
							if element.dead then											--element was already dead previously
								element.dead_last = false									--mark element as not died in last mission
							else
								element.dead = true
								print("UKT targetlist dead target "..element.name)

								-- activeInactiveGround(targetName, active, dead)
								activeInactiveGround(element.name, 	nil, 	dead)

							end
						end
					end


				end
			end
		end

		-- activeInactiveGround(targetName, active, dead)
		activeInactiveGround(targetName, 	nil, 	dead)
	else
		local i = 1
		local nbDesactive = 0

		--compte le nombre de cible
		local nbCible = 0
		for targetN, target in pairs(targetlist[side]) do										--iterate through targets
			if target.task and target.task ~= "Intercept" and target.task ~= "CAP" and target.task ~= "AWACS" and target.task ~= "Refueling"  and target.task ~= "Transport"  and target.task ~= "SAR" then
				nbCible = nbCible+1
			end
		end

		local randomDesactive = math.random(1, nbCible)

		repeat
			i=i+1
			local iCible = 0
			for targetN, target in pairs(targetlist[side]) do										--iterate through targets
				if target.task and target.task ~= "Intercept" and target.task ~= "CAP" and target.task ~= "AWACS" and target.task ~= "Refueling"  and target.task ~= "Transport"  and target.task ~= "SAR" then
					iCible = iCible+1
					if iCible == randomDesactive and target["inactive"] ~= inactive then

						target["inactive"] = inactive
						activeInactiveGround(target.titleName, active)
						nbDesactive = nbDesactive + 1
						break

					end
				end
			end

		until (nbDesactive/nbCible *100 )> pourcent  or i>2000

	end
end


local function checkGroundFirst(pourcent, side, active )

	local inactive = true
	if active then
		inactive = false
	end

	local nbDesactive = 0

	--compte le nombre de cible
	local nbCible = 0
	for country_n, country in pairs(oob_ground[side]) do
		if country.vehicle then
			for group_n, group in pairs(country.vehicle.group) do

				nbCible = nbCible + #group.units

			end
		end
	end

	print("UtilKT nbCible "..nbCible.." pourcent: "..pourcent)

	repeat
		local randomCible = math.random(1, nbCible)

		-- print("UtilKT randomCible "..randomCible.." nbDesactive "..nbDesactive)
		local breakOn = false
		for country_n,country in pairs(oob_ground[side]) do

			local i_cible = 0

			if country.vehicle then

				for group_n, group in pairs(country.vehicle.group) do
					for unit_n, unit in pairs(group.units) do
						i_cible = i_cible + 1

						if i_cible == randomCible then

							if not unit.DCE_inactive or (unit.DCE_inactive ~= inactive) then
								unit.DCE_inactive = inactive
								nbDesactive = nbDesactive + 1

								print("UKT                                     activeInactiveGround PasseIn/Active "..unit.name)
								breakOn = true
							end
						end
						if breakOn then break end
					end

				end
			end
			if breakOn then break end
		end

		-- print("UtilKT nbDesactive "..nbDesactive)

	until (nbDesactive/nbCible *100 )> pourcent

	-- print("UtilKT nbDesactive "..nbDesactive.." nbCible: "..nbCible.." nbDesactive/nbCible "..tostring(nbDesactive/nbCible *100))


	--si tous les véhicules ont été desactivé et qu'ils font partie du targetlist, on desactive le target de targetlist
	for country_n, country in pairs(oob_ground[side]) do
		if country.vehicle then
			for group_n, group in pairs(country.vehicle.group) do

				local totalUnit = #group.units
				local sumUnitDesactive = 0

				for unit_n, unit in pairs(group.units) do
					if unit.DCE_inactive and  unit.DCE_inactive == true then
						sumUnitDesactive = sumUnitDesactive +1
					end
				end

				if sumUnitDesactive >= totalUnit then

					print("UKT activeInactiveTarget inactive "..group.name)
					activeInactiveTarget(group.name, false)
				end

			end
		end
	end


end

--=========

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
			
			print(typePlane.." ("..loadoutName..")")
			

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
					print("hCruise from Data_divers: " ..loadout.hCruise)
				end
			else
				print("loadout.hCruise: " ..loadout.hCruise)
			end
			
			if not loadout.vCruise then
				if Data_divers and Data_divers[typePlane] and Data_divers[typePlane].vCruise then
					loadout.vCruise = Data_divers[typePlane].vCruise
					print("vCruise from Data_divers: " ..loadout.vCruise)
				end
			else
				print("loadout.vCruise: " ..loadout.vCruise)
			end


			for vi = 1, 10 do

				if nbGroup == 1 then
					altTest = loadout.hCruise
					viTest = loadout.vCruise
				else
					viTest = loadout.vCruise - 25
				end

				for ai = 1, 10 do
				
					if nbGroup == 2 then
						altTest = loadout.hCruise - 1640
						if altTest < 100 then altTest = 100 end
					end
					
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

					-- print(unitName)

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
					
					-- if nbGroup > 2 then
						-- altTest = altTest + 328.084
					-- end

					nbGroup = nbGroup + 1

				end --for alti

				if nbGroup > 2 then
					altTest = altTest + 328.084
				-- elseif nbGroup == 2 then
					-- break
				end

			end -- for speed

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

					-- print(unitName)

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
	miz:zipAddFile("l10n/DEFAULT/collectFuelData.lua", "../../../ScriptsMod."..VersionPackageICM.."/Mission Scripts/collectFuelData.lua")

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

elseif ArgTools == "KillTarget" then

	--===================================================================================
	-- Ecran N 0 Choix Num mission
	print("Actuel Num de mission "..camp.mission)
	print("Change number of mission or press \"Enter\".\n")				--ask for user confirmation

	

	local input, input2

	input = tonumber(io.stdin:read())
	if input and input ~= nil and input > 0 and input < 100 then
		camp.mission = input
	end


	repeat
		local tableTargetlist = {}
		local i = 1
		local tableTargetlist = {
				["blue"] = {},
				["red"] = {},
				}
		for side, targets in PairsByKeys(targetlist) do														--iterate through sides in targetlist						
			for targetN, target in PairsByKeys(targets) do												--iterate through all hostile targets
				if target.task and target.task ~= "Intercept" and target.task ~= "CAP" and target.task ~= "AWACS" and target.task ~= "Refueling"  and target.task ~= "Transport"  and target.task ~= "SAR" then
					local active = false
					if not target.inactive or target.inactive == nil  then
						active = true
					end
					if active then
						local draftTarget = {
								["name"] = tostring(target.titleName),
								["priority"] = tonumber(target.priority),
								["alive"] = tonumber(target.alive),
								["active"] = active,

								}

						table.insert(tableTargetlist[side], draftTarget)

						i = i +1
					end
				end
			end
		end

		for side, targets in PairsByKeys(targetlist) do														--iterate through sides in targetlist						
			for targetN, target in PairsByKeys(targets) do												--iterate through all hostile targets
				if target.task and target.task ~= "Intercept" and target.task ~= "CAP" and target.task ~= "AWACS" and target.task ~= "Refueling"  and target.task ~= "Transport"  and target.task ~= "SAR" then
					local active = false
					if not target.inactive or target.inactive == nil  then
						active = true
					end
					if not active then
						local draftTarget = {
								["name"] = tostring(target.titleName),
								["priority"] = tonumber(target.priority),
								["alive"] = tonumber(target.alive),
								["active"] = active,

								}

						table.insert(tableTargetlist[side], draftTarget)

						i = i +1
					end
				end
			end
		end

		-- table.sort(tableTargetlist["red"], function(a,b) return a.priority > b.priority  end)
		-- table.sort(tableTargetlist["blue"], function(a,b) return a.priority > b.priority  end)

		-- table.sort(tableTargetlist["red"], function(a, b) return a.type:upper() < b.type:upper() end)
		-- table.sort(tableTargetlist["blue"], function(a, b) return a.type:upper() < b.type:upper() end)

		-- table.sort(oobAirSide, function(a, b) return a.type:upper() < b.type:upper() end)

		local tabIndex = {}
		for side, Targetlist in PairsByKeys(tableTargetlist) do
			local jMax, ownerSide
			if side == "red" then
				ownerSide = "blue coalition"
				jMax = #tableTargetlist["red"]
			else
				ownerSide = "red coalition"
				jMax = #tableTargetlist["blue"]
			end
			local j = 1

			local Ckey = 0
			print() print(ownerSide..":")
			for key, value in PairsByKeys(Targetlist) do
				if  j <= jMax and value.active  then
					if side == "red" then
						Ckey = key + #tableTargetlist["blue"]															--permet de n'afficher qu'un nombre continue pour les 2 camps
					else
						Ckey = key
					end
					io.write(  Ckey.." "..tostring(value.name) .."  "..tostring(value.alive).." % Actif? "..tostring(value.active).."\n")
					if not tabIndex[Ckey]  then tabIndex[Ckey] = {} end
					tabIndex[Ckey]["side"] = side
					j = j+1
				end
			end

			for key, value in PairsByKeys(Targetlist) do
				if  j <= jMax and not value.active  then
					if side == "red" then
						Ckey = key + #tableTargetlist["blue"]															--permet de n'afficher qu'un nombre continue pour les 2 camps
					else
						Ckey = key
					end
					io.write(  Ckey.." "..tostring(value.name) .."  "..tostring(value.alive).." % Actif? "..tostring(value.active).."\n")
					if not tabIndex[Ckey]  then tabIndex[Ckey] = {} end
					tabIndex[Ckey]["side"] = side
					j = j+1
				end
			end
		end

		print()
		print("(dead)      : kills the numbered taget")
		print("(actif)     : activate/deactivate targets, add/delete vehicles/static associated")
		print("(pourcentA) : eactivates TARGET in bulk, by percentage")
		print("(pourcentB) : deactivates any VEHICLE in random and mass, by percentage")
		print("(S)         : Stop script ")
		print()

		local active
		repeat
			dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_UpdateTargetlist.lua")							--ce n'est pas un doublon, il faut garder les 2 Update
			dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_CheckTriggers.lua")
			dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_UpdateOOBGround.lua")		-- add oob_ground in mission.coalition..... don't forget ^^



			local inputString = string.lower(io.stdin:read())
			if inputString == "s" then
				break
			elseif inputString == "pourcenta" then
				print(" enter the percentage value of RED ground groups to be deactivated (targetlist.blue)")
				inputString = string.lower(io.stdin:read())
				local pourcentDesactive = tonumber(inputString)
				active = false
				activeInactiveTarget(nil, active, pourcentDesactive, "blue")

				print(" enter the percentage value of BLUE ground groups to be deactivated (targetlist.red)")
				inputString = string.lower(io.stdin:read())
				local pourcentDesactive = tonumber(inputString)
				active = false
				activeInactiveTarget(nil, active, pourcentDesactive, "red")

				print("(S) Stop script ?")

			elseif inputString == "pourcentb" then
				print(" enter the percentage value of BLUE ground groups to be deactivated")
				inputString = string.lower(io.stdin:read())
				local pourcentDesactive = tonumber(inputString)
				active = false
				checkGroundFirst(  pourcentDesactive, "blue", active)

				print(" enter the percentage value of RED ground groups to be deactivated")
				inputString = string.lower(io.stdin:read())
				local pourcentDesactive = tonumber(inputString)
				active = false
				checkGroundFirst(  pourcentDesactive, "red", active)

				print("(S) Stop script ?")

			elseif inputString == "dead" then
				print(" enter the number of the target to Killer ")

				inputString = string.lower(io.stdin:read())

				input = tonumber(inputString)

				if (input == nil or input == "") then input = 999 end

				if input >  #tableTargetlist["blue"] then
					Ckey = input - #tableTargetlist["blue"]
				else
					Ckey = input
				end

				if  tabIndex[input] then
					local side = tabIndex[input]["side"]
					local dead = true

					print(" passe activeInactiveTarget? "..tostring(dead))

					--activeInactiveTarget(targetName,					 active, pourcent, side, dead)
					activeInactiveTarget(tableTargetlist[side][Ckey].name, nil, 	nil,	nil,  dead)

					print("\n"..tableTargetlist[side][Ckey].name.."\n")
				else
					print("\nInvalid entry.\n")
				end

				print("(S) Stop script ?")


			elseif inputString == "actif" then
				print(" enter the number of the target to be activated/deactivated ")
				print(" i: inactivate, a: activate ")
				print(" 37i: for example: deactivate target 37 ")

				inputString = string.lower(io.stdin:read())

				input = tonumber(inputString)

				local active

				active = string.sub (inputString, -1)

				if tostring(active) == "a" then
					active = true
					input = inputString:sub(1, -2)

				elseif tostring(active) == "i" then
					active = false
					input = inputString:sub(1, -2)

				end

				input = tonumber(input)

				if (input == nil or input == "") then input = 999 end
				if input >  #tableTargetlist["blue"] then
					Ckey = input - #tableTargetlist["blue"]
				else
					Ckey = input
				end

				if  tabIndex[input] then
					local side = tabIndex[input]["side"]

					--activeInactiveTarget(targetName,					 active, pourcent, side, dead)
					activeInactiveTarget(tableTargetlist[side][Ckey].name, active, 	nil,	nil,  nil)

					print("\n"..tableTargetlist[side][Ckey].name.."\n")
				else
					print("\nInvalid entry.\n")
				end

				print("(S) Stop script ?")


			else
				input = tonumber(inputString)
			end



			dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_UpdateTargetlist.lua")		--ce n'est pas un doublon, il faut garder les 2 Update
			dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_CheckTriggers.lua")
			dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_UpdateOOBGround.lua")		-- add oob_ground in mission.coalition..... don't forget ^^



		until  tabIndex[input] or inputString == "s"
		io.write( "\n")



		print("(S) Stop script ?")
		print("(enter) to start again.\n")
		input2 = string.lower(io.stdin:read())

	until  input2 == "s"
	io.write( "\n")

	ArgTools = ""

elseif ArgTools == "helpBalancePower" then

	local balance = {}

	local balanceTS = {}
	local tabMaxSum = {}


	for side, unit in pairs(oob_air) do
		for n = 1, #unit do
			if unit[n].inactive ~= true and db_airbases[unit[n].base] and db_airbases[unit[n].base].inactive ~= true then
				local plane = unit[n].type
				for task,task_bool in pairs(unit[n].tasks) do

					if task_bool then
						local temp_Draft_sorties = {}														--temporary table to hold additional draft sorties with escorts assigned
						--get possible loadouts
						local unit_loadouts = {}														--table to hold all loadouts for this aircraft type and task
						for loadout_name, ltable in pairs(db_loadouts[unit[n].type][task]) do			--iterate through all loadouts for the aircraft type and task
							ltable.name = loadout_name
							unit_loadouts[#unit_loadouts+1] = ltable
						end

						-- ajoute dans une table les informations aux plus hautes valeurs
						if unit[n].number > 0 and db_loadouts[unit[n].type][task]  then																				--has ready aircraft

							local somme = 0
							local sum_fireP = 0
							for l = 1, #unit_loadouts do
								sum_fireP = sum_fireP +  unit_loadouts[l].firepower
								
								-- local break_loop = false
								for m = 1, 6 do

									if not tabMaxSum[side] then tabMaxSum[side] = {} end
									if not tabMaxSum[side][m] then tabMaxSum[side][m] = {}  tabMaxSum[side][m]["sum"] = 0 end

									if ((sum_fireP )  /#unit_loadouts) > tabMaxSum[side][m]["sum"] then

										-- tabMaxSum[side][m] = nil
										tabMaxSum[side][m] = {
											["sum"] = (sum_fireP )  /#unit_loadouts,
											["plane"] = plane,
											["task"] = task,
											["name"] = unit_loadouts[l].name,
											["firepower"] = unit_loadouts[l].firepower,
											-- ["capability"] = unit_loadouts[l].capability,
											["nbLoadout"] = #unit_loadouts
										}
										-- break_loop = true
										-- break

									end
									-- if break_loop then break end
								end
							end

							--(sum_fireP  /#unit_loadouts) pour calculer la moyenne des firepowers
							-- aditionne ici les plus hautes valeurs

							if not balanceTS[task] then 
								balanceTS[task] = {
									["blue"] = 
									{
										["numberblue"] = 0,
										["sommeblue"] = 0,
									},
									["red"] = 
									{
										["numberred"] = 0,
										["sommered"] = 0,
									},
								} 
							end
		
							if task == "Escort" or task == "CAP" or task == "Intercept" then
								somme = ((sum_fireP )  /#unit_loadouts)  * unit[n].number
								balanceTS[task][side]["somme"..side] = balanceTS[task][side]["somme"..side] + somme
								balanceTS[task][side]["number"..side] = balanceTS[task][side]["number"..side] + unit[n].number

							else
								somme = (sum_fireP  /#unit_loadouts)  * unit[n].number
								balanceTS[task][side]["somme"..side] = balanceTS[task][side]["somme"..side] + somme
								balanceTS[task][side]["number"..side] = balanceTS[task][side]["number"..side] + unit[n].number

							end

						end
					end

				end

			end

		end

	end

	-- if Debug.debug then
	-- 	local camp_str = "BalancePower = " .. TableSerialization(balanceTS, 0)						--make a string
	-- 	local campFile = io.open("Debug/BalancePower.lua", "w")  or error("Failed to open debug file")
	-- 	campFile:write(camp_str)																		--save new data
	-- 	campFile:close()
	-- end

	print()
	print("The 6 highest values of each camp:")
	_affiche(tabMaxSum)

	function Space(txt, space_)
		space_ = space_ - string.len(tostring(txt))

		for n = 1, space_ * 1.0 do	 --for n = 1, space_ * 1.5 do														
			txt = txt .. " "																	--add 1.5 spaces for every missing letter
		end

		return txt

	end

	local s = "\\n"																	--make a list with details of the player waypoints

	local entries = {																			--list entries that are making up the navigaion overview

		[1] = {
			lookup = "task",
			header = "Task",
			str_length = 20,
		},
		[2] = {
			lookup = "numberblue",
			header = "Nb Blue",
			str_length = 8,
		},
		[3] = {
			lookup = "sommeblue",
			header = "TotFirepowerBlue",
			str_length = 16,
		},
		[4] = {
			lookup = "numberred",
			header = "Nb Red",
			str_length = 8,
		},
		[5] = {
			lookup = "sommered",
			header = "TotFirepowerRed",
			str_length = 16,
		},
	}

	--build the list header
	for e = 1, #entries do																		--iterate through all entries
		s = s .. entries[e].header																--add entry of this waypoint to list
																								--if this is not the last entry of the waypoints, add spaces to the next entry	
		local space = entries[e].str_length + 0 - string.len(tostring(entries[e].header))		--calculate number of spaces that need to be added for alignement (string length of largest entry of same type + 3 - length of current entry = number of spaces)
		entries[e]["space"] = space
		for n = 1, space * 1.0 do
			s = s .. " "																		--add 1.5 spaces for every missing letter
		end

	end
	s = s .. "\\n"


	local test = ""
	for task, _side in pairs(balanceTS) do
		for e = 1, #entries do
			local entry = ""
			if entries[e].lookup == "task" then
				entry = Space(task, entries[e].str_length)
			end
			s = s.. entry
		end


		for side, _value in pairs(_side) do
			for e = 1, #entries do
				-- io.write("D")
				local entry = ""

				if entries[e].lookup == "number"..side then
					entry = ""..Space(balanceTS[task][side]["number"..side], entries[e].str_length)
					-- io.write("|E_/"..entry.."/")
				elseif entries[e].lookup == "somme"..side then
					entry = ""..Space(balanceTS[task][side]["somme"..side], entries[e].str_length)
					-- io.write("|F_/"..entry.."/")
				end
				s = s.. entry
			end
		end

		s = s .. "\\n"

	end
	print()
	print("Nb: ".." Number of plane in oob_air_init ")
	-- print("CAP or Escorte or Intercept Tot : ".." Tot = ((sum_firepower * sum_capability)  /#unit_loadouts)  * unit[n].number ")
	print("Example Tot :                       ".." Tot = ((sum_firepower)  /#unit_loadouts)  * unit[n].number ")
	local DebugTXT = StringToTxt(s)
	print("UTIL_HBP HelpBalancePwer "..DebugTXT)
	print()
	print("You can change oob_air_init.lua or db_loadout.lua file ")
	print("And touch any key for restart the script without closing/opening a dos windows ")


	--===================================================================================
    --===================================================================================
	
elseif ArgTools == "missionWithIcone" then

    --===================================================================================
    --===================================================================================	
	

	print("Felicitation, missionWithIcone va commencer ^^: \n")


	----- unpack template mission file ----
	local minizip = require('minizip')

	local zipFile = minizip.unzOpen("Init/base_mission.miz", 'rb')

	zipFile:unzLocateFile('mission')
	local misStr = zipFile:unzReadAllCurrentFile()
	local misStrFunc_ = loadstring(misStr)()

	zipFile:unzLocateFile('options')
	local optStr = zipFile:unzReadAllCurrentFile()
	local optStrFunc_ = loadstring(optStr)()

	zipFile:unzLocateFile('warehouses')
	local warStr = zipFile:unzReadAllCurrentFile()
	local warStrFunc_ = loadstring(warStr)()

	zipFile:unzLocateFile('l10n/DEFAULT/dictionary')
	local dicStr = zipFile:unzReadAllCurrentFile()
	local dicStrFunc_ = loadstring(dicStr)()

	zipFile:unzLocateFile('l10n/DEFAULT/mapResource')
	local resStr = zipFile:unzReadAllCurrentFile()
	local resStrFunc_ = loadstring(resStr)()

	zipFile:unzClose()

	print("mission.version " .. mission.version)



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

	for side_, sideTab in pairs(mission.coalition) do
		for countryN_, countryTab in pairs(sideTab.country) do
			if countryTab.helicopter then countryTab.helicopter = nil end
			-- if countryTab.ship then countryTab.ship = nil end
			-- if countryTab.static then countryTab.static = nil end
			-- if countryTab.vehicle then countryTab.vehicle = nil end
			if countryTab.plane then countryTab.plane = {} end
		end
	end


	mission["failures"] =
	{
	}

	-- mission["triggers"] =
	-- {
	-- 	["zones"] =
	-- 	{}
	-- }


	-- local trig_n =  #mission.trig.actions + 1
	local trig_n = 1


	local filename = "collectObjetMap.lua"
	local rule = nil

	rule = nil

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


	----- convert tables back to strings for insertion into content files -----
	misStr = "mission = " .. TableSerialization(mission, 0)
	optStr = "options = " .. TableSerialization(options, 0)
	warStr = "warehouses = " .. TableSerialization(warehouses, 0)
	dicStr = "dictionary = " .. TableSerialization(dictionary, 0)
	-- resStr = "mapResource = " .. TableSerialization(mapResource, 0)

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

	local resFile = io.open("resFile.lua", "w") or error("Failed to open debug file")
	resFile:write(resStr)
	resFile:close()

	local miz = minizip.zipCreate("Init/mission_collectObjetMap.miz")

	miz:zipAddFile("mission", "misFile.lua")
	miz:zipAddFile("options", "optFile.lua")
	miz:zipAddFile("warehouses", "warFile.lua")
	miz:zipAddFile("l10n/DEFAULT/dictionary", "dicFile.lua")
    miz:zipAddFile("l10n/DEFAULT/mapResource", "resFile.lua")
	miz:zipAddFile("l10n/DEFAULT/camp_status.lua", "Active/camp_status.lua")

	-- 3. Ajout au zip (à la fin de ton script)
	miz:zipAddFile("l10n/DEFAULT/collectObjetMap.lua", "collectObjetMap.lua")

	miz:zipClose()




	----- remove temporary content files -----
	os.remove("misFile.lua")
	os.remove("optFile.lua")
	os.remove("warFile.lua")
	os.remove("dicFile.lua")
	os.remove("resFile.lua")
	os.remove("collectObjetMap.lua")

	-- local miss_str = "mission = " .. TableSerialization(mission, 0)
	-- local missFile = io.open("Init/mission_collectObjetMap.lua", "w") or error("Failed to open debug file")
	-- missFile:write(miss_str)
	-- missFile:close()

	os.execute 'pause'
    os.exit()
	
end


print("FIN UTIL_Divers ArgTools "..tostring(ArgTools))