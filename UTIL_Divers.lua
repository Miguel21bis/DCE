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

					io.write(i.." : ( "..unitType.." )( "..task..")("..loadoutName..")")

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


	for type , loadouts in PairsByKeys(SelectedLoadout) do
		for loadoutName , loadout in PairsByKeys(loadouts) do
			-- io.write(i.." : ( "..type.." )("..loadoutName..")".."\n")

			local altTest = loadout.hCruise + 3000
			local viTest = loadout.vCruise + 50

			for i = 1, 6 do
				viTest = loadout.vCruise + 50

				for k = 1, 6 do

					

					local n = 1
					local units = {}

					local unitName = groupName .. "-" .. n

					units[n] =
					{
						["alt"] = waypoints[1].alt,
						["heading"] = 0,
						["callsign"] = GetCallsign(flight[f].country, f, n, "Nothing", 1),
						["psi"] = 0,
						["livery_id"] = flight[f].livery,
						["type"] = flight[f].type,
						["x"] = define_x ,
						["y"] = define_y ,
						["name"] = unitName,
						-- ["payload"] = flight[f].loadout.stores,
						["payload"] = {
							["pylons"] = loadout.stores.pylons,
							["fuel"] = fuelTemp,
							["flare"] = loadout.stores.flare,
							["chaff"] = loadout.stores.chaff,
							["gun"] =  loadout.stores.gun,										-- ATO_FP_Debug04 Gun = 0 uniquement sur un Flight
							['DCE_payloadtName'] = loadout.name,
						},
						["AddPropAircraft"] = loadout.AddPropAircraft,
						["speed"] = waypoints[1].speed,
						["unitId"] = GenerateIDUnit(unitName),
						["alt_type"] = waypoints[1].alt_type,
						["skill"] = "High",
						["hardpoint_racks"] = true,
		
					}


				
					viTest = viTest - 15
				end

				altTest = altTest - 1000
			
			end

			

		end

	end


	mission["coalition"]["red"]["plane"] =
	{
		["group"] = groupEntries
	}











	os.execute 'pause'
	os.exit()

end