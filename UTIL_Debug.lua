--Various debug file exports
--Initiated by MAIN_NextMission.lua (unless disabled there)
-------------------------------------------------------------------------------------------------------
-- last modification: cleancode_c
if not versionDCE then versionDCE = {} end
versionDCE["UTIL_Debug.lua"] = "1.3.12"
------------------------------------------------------------------------------------------------------- 


if Debug.debug then

	local ato_str = "ATO = " .. TableSerialization(ATO, 0)
	local atoFile = io.open("Debug/ATO_UtilDebug.lua", "w") or error("Failed to open debug ATO_UtilDebug file")
	atoFile:write(ato_str)
	atoFile:close()


	local ground_str = "groundthreats = " .. TableSerialization(groundthreats, 0)
	local air_str = "Fighterthreats = " .. TableSerialization(Fighterthreats, 0)
	local ewr_str = "ewr = " .. TableSerialization(EWR_DB, 0)
	local threatFile = io.open("Debug/threat_UtilDebug.lua", "w") or error("Failed to open debug file")
	threatFile:write(ground_str .. "\n\n" .. air_str .. "\n\n" .. ewr_str)
	threatFile:close()
	
	
	local available_str = "Aircraft_availability = " .. TableSerialization(AcftAvail, 0)
	local availableFile = io.open("Debug/AircraftAvailability_UtilDebug.lua", "w") or error("Failed to open debug threat_UtilDebug file")
	availableFile:write(available_str)
	availableFile:close()

	-- local camp_str = "freqence_package_AtoFP = " .. TableSerialization(Package_freq, 0)			--make a string
	-- local campFile = io.open("Debug/Package_freq__UtilDebug.lua", "w") or error("Failed to open debug Package_freq__UtilDebug file")
	-- campFile:write(camp_str)																	--save new data
	-- campFile:close()

	local file_str = "GCI = " .. TableSerialization(GCI, 0)			--make a string
	local file_File = io.open("Debug/GCI_Data_UtilDebug.lua", "w") or error("Failed to open debug GCI_Data_UtilDebug file")
	file_File:write(file_str)																	--save new data
	file_File:close()

	file_str = "EWR = " .. TableSerialization(EWR_DB, 0)			--make a string
	file_File = io.open("Debug/EWR_UtilDebug.lua", "w") or error("Failed to open debug EWR_UtilDebug file")
	file_File:write(file_str)																	--save new data
	file_File:close()

	local test_str = "PayloadRestricted = " .. TableSerialization(PayloadRestricted, 0)						--make a string
	local testFile = io.open("Debug/loadout_restrictied_UtilDebug.lua", "w") or error("Failed to open debug loadout_restrictied_UtilDebug file")
	testFile:write(test_str)															--save new data
	testFile:close()


	--recherche Debug/BugList.lua
	local fileName = "Debug/BugList.lua"
	local testPath = io.open(fileName, "r")										--cette maniere de chercer la presence d un fichier evite un plantage
	if testPath ~= nil and MissionInstance == 1 then														--check si le fichier existe 
		io.close(testPath)
		os.execute('start "BugList" "notepad.exe" "Debug/BugList.lua"')			--open the BugList file with notepad
	end

end

--compte le nombre d'élément dans la mission.
local NbGrPlane, NbGrHelico, NbGrShip, NbGrvehicle, NbGrStatic = 0, 0, 0, 0, 0 
local NbPlane, NbHelico, NbShip, Nbvehicle, NbStatic = 0, 0, 0, 0, 0

for _side,side in pairs(mission.coalition) do	
	for _country, country in pairs(side.country) do
		if country.plane  then
			NbGrPlane = NbGrPlane + #country.plane.group
			for Ngroup, group in ipairs(country.plane.group) do
				NbPlane = NbPlane + #group.units
			end
		end
		if country.helicopter  then
			NbGrHelico = NbGrHelico + #country.helicopter.group
			for Ngroup, group in ipairs(country.helicopter.group) do
				NbHelico = NbHelico + #group.units
			end
		end
		if country.ship  then
			NbGrShip = NbGrShip + #country.ship.group
			for Ngroup, group in ipairs(country.ship.group) do
				NbShip = NbShip + #group.units
			end
		end
		if country.vehicle  then
			NbGrvehicle = NbGrvehicle + #country.vehicle.group
			for Ngroup, group in ipairs(country.vehicle.group) do
				Nbvehicle = Nbvehicle + #group.units
			end
		end
		if country.static  then
			NbGrStatic = NbGrStatic + #country.static.group
			for Ngroup, group in ipairs(country.static.group) do
				NbStatic = NbStatic + #group.units
			end
		end
	end
end

local infoPopulate = "\n\n"
infoPopulate = infoPopulate .."Number of aircraft groups: "..tostring(NbGrPlane).." |Number of planes: "..tostring(NbPlane).."\n"
infoPopulate = infoPopulate .."Number of helicopter groups: "..tostring(NbGrHelico).." |Number of helicopters: "..tostring(NbHelico).."\n"
infoPopulate = infoPopulate .."Number of ship groups: "..tostring(NbGrShip).." |Number of ships: "..tostring(NbShip).."\n"
infoPopulate = infoPopulate .."Number of vehicle groups: "..tostring(NbGrvehicle).." |Number of vehicules: "..tostring(Nbvehicle).."\n"
infoPopulate = infoPopulate .."Number of static groups: "..tostring(NbGrStatic).." |Number of statics: "..tostring(NbStatic).."\n\n"

print(infoPopulate)

DebugFLIGHT = DebugFLIGHT .. infoPopulate

local debugFLIGHTFile = io.open("Debug/debugFlight.txt", "w") or error("Failed to open debug file")
debugFLIGHTFile:write(DebugFLIGHT)																		--save new data
debugFLIGHTFile:close()


--recherche si toutes les cibles des packages existent dans la mission
function CustomGroupAttack(FlightName, TargetName, expend, weaponType, attackType, attackAlt, id_task)

	local target = TargetName
	-- if TargetList_InThisMission[target] then

	-- 	-- print("DcB found target: "..target)
	-- else
	-- 	print("DcB NOT found target: "..tostring(target))
	-- end

	local foundTarget = false
		for coalition_name, coal in pairs(mission.coalition) do
			for country_n, country in pairs(coal.country) do
				if country.static and country.static.group then
						for group_n, group in pairs(country.static.group) do
						if group.name == target then
							-- print("DcB found STATIC target: "..target)
							foundTarget = true
							break
						end
					end
				end
				if foundTarget then break end
			end
			if foundTarget then break end
		end

		if not foundTarget then
			for coalition_name, coal in pairs(mission.coalition) do
				for country_n, country in pairs(coal.country) do
					if country.vehicle and country.vehicle.group then
							for group_n, group in pairs(country.vehicle.group) do
							if group.name == target then
								-- print("DcB found vehicle target: "..target)
								foundTarget = true
								break
							end
						end
					end
					if foundTarget then break end
				end
				if foundTarget then break end
			end			
		end

		if not foundTarget then
			local txtBug = "UtilD NOT found CustomGroupAttack target: "..tostring(target)
			-- table.insert(BugList, txtBug)
			AddLog(txtBug)
		end

end

function CustomStaticAttack(FlightName, TargetList, expend, weaponType, attackType, attackAlt, id_task)
	if type(TargetList) == "table" then
		for targetN, target in pairs(TargetList) do	
			
			local foundTarget = false
			for coalition_name, coal in pairs(mission.coalition) do
				for country_n, country in pairs(coal.country) do
					if country.static and country.static.group then
						 for group_n, group in pairs(country.static.group) do
							if group.name == target then
								-- print("DcB found STATIC target: "..target)
								foundTarget = true
								break
							end
						end
					end
					if foundTarget then break end
				end
				if foundTarget then break end
			end

			if not foundTarget then
				for coalition_name, coal in pairs(mission.coalition) do
					for country_n, country in pairs(coal.country) do
						if country.vehicle and country.vehicle.group then
							 for group_n, group in pairs(country.vehicle.group) do
								if group.name == target then
									-- print("DcB found vehicle target: "..target)
									foundTarget = true
									break
								end
							end
						end
						if foundTarget then break end
					end
					if foundTarget then break end
				end			
			end

			if not foundTarget then
				local txtBug = "UutilD NOT found CustomStaticAttack target: "..tostring(target)
				-- table.insert(BugList, txtBug)
				AddLog(txtBug)
			end

		end
	end
end

for coalition_name, coal in pairs(mission.coalition) do
    for country_n, country in pairs(coal.country) do
		if country.plane and country.plane.group then
			 for group_n, group in pairs(country.plane.group) do
                 if group.route then
                    for point_n, point in pairs(group.route.points) do
                        if point.task.params.tasks and type(point.task.params.tasks) == "table" then
                            for task_n, task in pairs(point.task.params.tasks) do
                               if type(task) == "table" and task.params and task.params.action and task.params.action.params and task.params.action.params.command then
										
									if string.find(task.params.action.params.command,"CustomStaticAttack" ) then
										local f = loadstring(task.params.action.params.command)()
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