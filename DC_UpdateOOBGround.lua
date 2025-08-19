--To put vehicles and ships from ground OOB into next mission
--Initiated by MAIN_NextMission.lua
-------------------------------------------------------------------------------------------------------
-- last modification: debug_b
if not versionDCE then versionDCE = {} end
versionDCE["DC_UpdateOOBGround.lua"] = "1.4.12"
------------------------------------------------------------------------------------------------------- 
-- debug_b					(ShipHealth < 66%)(a id duplicates)
-- cleancode_a				(a springCleaning)
-- modification M64_c		adds elements of a new base_mission (c ship)(b: update Type & groupId)
-- modification M33_f		frequence des FARP selon db_airbase
------------------------------------------------------------------------------------------------------- 


for coal_name,coal in pairs(oob_ground) do												--go through sides(red/blue)	
	for country_n,country in ipairs(coal) do											--go through countries
		if country.static then															--country has ships
			for group_n,group in ipairs(country.static.group) do							--go through groups
				for n = 1, #group.units do												--ship group found
					if group.units[n].type == 'FARP' then
					end
					if group.units[n].type == 'FARP' and db_airbases[group.units[n].name] and db_airbases[group.units[n].name].ATC_frequency then
						group.units[n].heliport_frequency = db_airbases[group.units[n].name].ATC_frequency
					end
				end
			end
		end
	end
end


--disable carriers as air bases if they are damaged, destroyed or do not have a 100% probability
-- for basename,base in pairs(db_airbases) do															--iterate through airbases
-- 	if base.unitname then																			--if airbase is a carrier, find the unit in the OOB Ground
-- 		for coal_name,coal in pairs(oob_ground) do													--go through sides(red/blue)	
-- 			for country_n,country in ipairs(coal) do												--go through countries
-- 				if country.ship then																--country has ships
-- 					for groupn,group in pairs(country.ship.group) do								--group table
-- 						for unitn,unit in pairs(group.units) do										--units table
-- 							if unit.name == base.unitname then										--respective unit found
-- 								if unit.dead or (camp.ShipHealth and camp.ShipHealth[unit.name] and camp.ShipHealth[unit.name] < 66) or (group.probability and group.probability < 1) then	 --unit is dead, damaged or its group has a probability that is not 100%
-- 									base.x = nil													--remove base coordinates to prevent sortie generation from this abse
-- 									base.y = nil
-- 								end
-- 							end
-- 						end
-- 					end
-- 				end
-- 			end
-- 		end
-- 	end
-- end

function GetNewId(allIdUsed, max, min)
	--renumerote automatiquement le groupId en doublon

	local nTentative = 0
	local found = false
	local testId = 1
	if min > 1 then
		repeat
			testId = math.random(1,min)
			if not allIdUsed[testId] then
				found = true
			end
			nTentative = nTentative + 1
		until found or nTentative > 50
	end

	if not found then
		repeat
			testId = math.random(min,max)
			if not allIdUsed[testId] then
				found = true
			end
			nTentative = nTentative + 1
		until found or nTentative > 500
	end
	
	if not found then
		testId =  max + 1
	end

	if testId > max then
		max = testId
	end
	if testId < min then
		min = testId
	end

	allIdUsed[testId] = testId

	return testId
end

-- modification M64_a		adds elements of a new base_mission
-- ajoute dans oob_ground les nouveaux éléments d'un nouveau base_mission en cours de campagne
for missSideName, side in pairs(mission.coalition) do
    for missCountryN, missCountry in pairs(side.country) do
        for missCategory, missGroups in pairs(missCountry) do
			-- print("DcUOOBG 01 missGroups " ..tostring(missSideName) ..tostring(missCountryN) .. tostring(missCategory) .. " missGroups " .. tostring(missGroups))

			if type(missGroups) == "table" and missGroups.group then
                -- print("DcUOOBG 02  " )
				
				for missGroupN, missGroup in ipairs(missGroups.group) do
					-- print("DcUOOBG 03 missGroupN " .. missGroupN)
					local foundGroup = false
					for obC_n, obCountry in pairs(oob_ground[missSideName]) do
						if obCountry[missCategory] then
							for oobGroupN, oobGroup in ipairs(obCountry[missCategory].group) do
								
								if oobGroup.name == missGroup.name then
									foundGroup = true

									--met à jour les GroupId qui peuvent changer, si le base_mission à été changé aussi
									if oobGroup.groupId ~= missGroup.groupId then
										oobGroup.groupId = missGroup.groupId
									end
									
									--met à jour les unitId qui peuvent changer, si le base_mission à été changé aussi
									-- tres important pour lier les pistes (FARP, base, CV CVN ) aux warehouses
									for oobUnitN, oobUnit in ipairs(oobGroup.units) do
										if warehouses.warehouses[missGroup.units[oobUnitN].unitId] then
											if oobUnit.unitId ~= missGroup.units[oobUnitN].unitId then
												oobUnit.unitId = missGroup.units[oobUnitN].unitId

												print("DcUOOBG miseAJour_ warehouses Id-- -- > C " .. missCategory .. " " .. oobUnit.type.." Id From missGroup.units "..missGroup.units[oobUnitN].unitId)
												os.execute 'pause'
											end
										end
									end

									--met à jour les l'Id des CV et CVN de db_airbases si celui ci a changé
									for missUnitN, missUnit in ipairs(missGroup.units) do
										if missUnit.name == db_airbases[missUnit.name] and db_airbases[missUnit.name].airdromeId then
											if db_airbases[missUnit.name].airdromeId ~= missUnit.unitId then
												db_airbases[missUnit.name].airdromeId = missUnit.unitId
												print("DcUOOBG miseAJour_Id-- -- > E  " .. missCategory .. ":: new airdromeId: " .. db_airbases[missUnit.name].airdromeId)
												os.execute 'pause'
											end
										end
									end


									--regarde si les type ont changé, mais uniquement ceux qui ne sont pas dans targetlist
									--car les elements Dead sont déjà enlevé et fou le bordel
									local isTarget = false
									for targetSide, targets in pairs(targetlist) do
										for targetN, target in pairs(targets) do
											if target.name == oobGroup.name then
												isTarget = true
												break
											end
										end
										if isTarget then break end
									end

									if not isTarget then
										if #missGroup.units ~= #oobGroup.units then
											oobGroup.units = missGroup.units
										else
											for oobUnitN, oobUnit in ipairs(oobGroup.units) do
												if oobUnit.type ~= missGroup.units[oobUnitN].type then
													oobUnit = missGroup.units[oobUnitN]

													-- print("DcUOOBG -- -- -- > D " .. missCategory .. ":: new type2: " .. oobUnit.type)
												end
											end
										end
									end
								end
							end
						end
					end

					if not foundGroup then
						-- ["id"] = 80,
						-- ["name"] = "CJTF Blue",

						if not oob_ground[missSideName][missCountryN] then 
							-- if #oob_ground[missSideName] ~= missCountryN then
							-- 	print("DcUOoBG futur bug, #country ne correspond pas avec le nouvel element ajouté")
							-- 	print("#oob_ground[missSideName] "..tostring(#oob_ground[missSideName]).." missCountryN: "..missCountryN)
							-- end
							
							oob_ground[missSideName][missCountryN] = {
								["id"] = missCountry.id,
								["name"] = tostring(missCountry.name),
								[missCategory] = {
									group = {}
								}
							}
						end

						-- print("DcUOOBG vehicle: no foundGroup  "..tostring(missSideName).." missCountryN "..tostring(missCountryN).." g "..tostring(g))

						table.insert(oob_ground[missSideName][missCountryN][missCategory].group, missGroup)
						-- print("DcUOOBG vehicle: no foundGroup => table.insert: "..missSideName.." "..missGroup.name)
					end
				end
			end
		end
	end
end


--TODO est ce vraiment utile? a quoi ça servait? de supprimer une FARP qui bouge sur BASE_Mission?

-- for side_name, side in pairs(oob_ground) do														--iterate through countries
-- 	for country_n, obCountry in pairs(side) do	
-- 		if obCountry.vehicle then																			--country has vehicles
-- 			-- for t = #threat, 1, -1 do
-- 			for o = #obCountry.vehicle.group, 1, -1 do														--iterate through vehicle groups
-- 				if  string.find(string.lower(oobGroup.name),"farp") then
-- 					local foundGroup = false
-- 					for countryN, country in pairs(mission.coalition[side_name].country) do															--iterate through countries
-- 						if country.vehicle then																			--country has vehicles
-- 							for g = 1, #country.vehicle.group do
-- 								if oobGroup.name == country.vehicle.group[g].name then
-- 									foundGroup = true
-- 								end
-- 							end
-- 						end
-- 					end
-- 					if not foundGroup then
-- 						print("DcUOOBG remove vehicle: no foundGroup: "..side_name.." "..oobGroup.name)
-- 						table.remove(oob_ground[side_name][country_n].vehicle.group, o)
-- 						-- table.insert(tabRemoveGroupe, o)
						
-- 					end
-- 				end
-- 			end
-- 		end

-- 		if obCountry.static then
-- 			for o = #obCountry.static.group, 1, -1 do
-- 				if string.find(string.lower(obCountry.static.group[o].name),"farp") then
-- 					local foundGroup = false
-- 					for countryN, country in pairs(mission.coalition[side_name].country) do
-- 						if country.static then
-- 							for g = 1, #country.static.group do
-- 								if obCountry.static.group[o].name == country.static.group[g].name then
-- 									foundGroup = true
-- 								end
-- 							end
-- 						end
-- 					end
-- 					if not foundGroup then
-- 						print("DcUOOBG remove static: no foundGroup: "..side_name.." "..obCountry.static.group[o].name)
-- 						table.remove(oob_ground[side_name][country_n].static.group, o)
-- 						-- table.insert(tabRemoveGroupe, o)
						
-- 					end
-- 				end
-- 			end
-- 		end
-- 	end
-- end

--check les doublons de name, groupId et unitId
local GroupId = {}
local UnitId = {}

local minGroupId = 999999
local maxGroupId = 0
local minUnitId = 999999
local maxUnitId = 0

for side_name, side in pairs(oob_ground) do														--iterate through countries
	for country_n, country_ in pairs(side) do
		for categorie, categorie_ in pairs(country_) do
				
			if type(categorie_) == "table" and categorie_.group then
				for _group, group in pairs(categorie_) do
					for groupN, group_ in pairs(group) do

						if group_.groupId > maxGroupId then
							maxGroupId = group_.groupId
						end
						if group_.groupId < minGroupId then
							minGroupId = group_.groupId
						end

						if not  GroupId[group_.groupId] then
							GroupId[group_.groupId] = group_.groupId
						end

						for unitN, unit in ipairs(group_.units) do
							if not  UnitId[unit.unitId] then
								UnitId[unit.unitId] = unit.unitId
							end
							-- print("DcUoob unit.unitId: "..tostring(unit.unitId).." maxUnitId: "..tostring(maxUnitId))
							if unit.unitId > maxUnitId then
								maxUnitId = unit.unitId
							end
							if unit.unitId < minUnitId then
								minUnitId = unit.unitId
							end
						end
					end	
				end
			end
		end
	end
end



local name = {}
local groupIdError = {}
local groupId_2 = {}
local unitId_2 = {}

for side_name, side in pairs(oob_ground) do														--iterate through countries
	for country_n, country_ in pairs(side) do
		for categorie, categorie_ in pairs(country_) do
				
			if type(categorie_) == "table" and categorie_.group then
				for _group, group in pairs(categorie_) do
					for groupN, group_ in pairs(group) do

						if not  name[group_.name] then
							name[group_.name] = group_.name
						else
							-- print("DcUOOBG error, duplicate of |"..categorie.."| name |".. name[group_.name] .."|and|"..tostring(group_.name))
						end

						if not  groupId_2[group_.groupId] then
							groupId_2[group_.groupId] = group_.groupId
						else
						-- 	print("DcUOOBG error, duplicate of |"..categorie.."| GroupId |".. GroupId[group_.groupId].."|and|"..tostring(group_.name)
						-- )

						-- 	table.insert(groupIdError,group_.name )

						group_.groupId = GetNewId(GroupId, maxGroupId, minGroupId)
						-- print("DcUOOBG error, duplicate groupId |"..categorie.."| name |" ..tostring(group_.name).." NewGroupId "..group_.groupId)
						end

						for unitN, unit in ipairs(group_.units) do
							if not  unitId_2[unit.unitId] then
								unitId_2[unit.unitId] = unit.UnitId
							else
								-- print("DcUOOBG error, duplicate of |"..categorie.."| UnitId |".. name[group_.UnitId] .."|and|"..tostring(group_.name))

								unit.UnitId = GetNewId(UnitId, maxUnitId, minUnitId)
								-- print("DcUOOBG error, duplicate UnitId |"..categorie.."| name |" ..tostring(group_.name).." NewUnitId "..unit.UnitId)
							end
						
						end
					end	
				end
			end
		end
	end
end


--******************************************************************************************************************************
--******************************************************************************************************************************
-- CORE
--******************************************************************************************************************************
--******************************************************************************************************************************


mission.coalition.blue.country = Deepcopy(oob_ground.blue)											--copy blue oob into mission
mission.coalition.red.country = Deepcopy(oob_ground.red)											--copy red oob into mission

--iterate through all vehicles and ships to remove those marked as dead during previous Debriefings (static objects need not be removed, as these are spawned in a destroyed state)
for k1,v1 in pairs(mission.coalition) do															--side table(red/blue)	
	for k2,v2 in pairs(v1.country) do																--country table (number array)
		if v2.vehicle then																			--if country has vehicles
			local n = 1
			local nEnd = #v2.vehicle.group
			repeat																					--groups table (number array)
				local m = 1
				local mEnd = #v2.vehicle.group[n].units
				repeat																				--units table (number array)
					if v2.vehicle.group[n].units[m].dead then
						
						--dead units are replaced by dead static objects
						if v2.static == nil then													--country table has no other static objects
							v2.static = {															--create static objects table
								group = {}															--create group subtable
							}
						end
						
						local dead_static_group = {													--define dead static group to replace dead unit 
							["heading"] = v2.vehicle.group[n].units[m].heading,						--set static group heading according to dead unit
							["route"] = {
								["points"] = 
								{
									[1] = 
									{
										["alt"] = 0,
										["type"] = "",
										["name"] = "",
										["y"] = v2.vehicle.group[n].units[m].y,
										["speed"] = 0,
										["x"] = v2.vehicle.group[n].units[m].x,
										["formation_template"] = "",
										["action"] = "",
									},
								},
							},
							["groupId"] = GenerateIDGroup(),
							["hidden"] = true,
							["units"] = {
								[1] = {
									["category"] = "Unarmed",
									["canCargo"] = false,
									["type"] = v2.vehicle.group[n].units[m].type,
									["unitId"] = GenerateIDUnit("DcUooBG dead "..v2.vehicle.group[n].units[m].name),
									["y"] = v2.vehicle.group[n].units[m].y,
									["x"] = v2.vehicle.group[n].units[m].x,
									["name"] = v2.vehicle.group[n].units[m].name,
									["heading"] = v2.vehicle.group[n].units[m].heading,
								},
							},
							["y"] = v2.vehicle.group[n].units[m].y,
							["x"] = v2.vehicle.group[n].units[m].x,
							["name"] = "Dead Static " .. v2.vehicle.group[n].units[m].name,
							["dead"] = true,
						}
						table.insert(v2.static.group, dead_static_group)							--add group to static table
						
						--remove dead unit from vehicle table
						if #v2.vehicle.group[n].units == 1 then										--if group has only one unit
							table.remove(v2.vehicle.group, n)										--remove group of dead unit from group table
							n = n - 1
							nEnd = nEnd - 1
						else
							table.remove(v2.vehicle.group[n].units, m)								--remove dead unit from units table
							v2.vehicle.group[n].route.points[1].x = v2.vehicle.group[n].units[1].x	--update group position to position of first units
							v2.vehicle.group[n].route.points[1].y = v2.vehicle.group[n].units[1].y	--update group position to position of first units
							m = m - 1
							mEnd = mEnd - 1
						end
					end
					m = m + 1
				until m > mEnd
				n = n + 1
			until n > nEnd
		end
		if v2.ship then																				--if country has ships
			local n = 1
			local nEnd = #v2.ship.group
			repeat																					--groups table (number array)
				local m = 1
				local mEnd = #v2.ship.group[n].units
				repeat																				--units table (number array)	
					if v2.ship.group[n].units[m].dead then
						if #v2.ship.group[n].units == 1 then										--if group has only one unit
							table.remove(v2.ship.group, n)											--remove group of dead unit from group table
							n = n - 1
							nEnd = nEnd - 1
						else
							table.remove(v2.ship.group[n].units, m)									--remove dead unit from units table
							m = m - 1
							mEnd = mEnd - 1
						end
					end
					m = m + 1
				until m > mEnd
				n = n + 1
			until n > nEnd
		end
	end
end

for k1, v1 in pairs(mission.coalition) do															--side table(red/blue)	
	for k2, v2 in pairs(v1.country) do																--country table (number array)
		if v2.vehicle then																			--if country has vehicles
			for nGroup = #v2.vehicle.group, 1, -1 do
				local group = v2.vehicle.group[nGroup]

				for nUnit = #group.units, 1, -1 do
					local unit = group.units[nUnit]

					if unit.DCE_inactive then
						
						print("DcUOoB                remove unit.vehicle "..unit.name.." nUnit: "..nUnit)
						
						table.remove(group.units, nUnit)
					end
				end


				if group.DCE_inactive then
					print("DcUOoB                remove group.vehicle "..group.name.." nGroup: "..nGroup)
					
					table.remove(v2.vehicle.group,nGroup)
				end
			end
		elseif v2.static then																			--if country has vehicles
			for nGroup = #v2.static.group, 1, -1 do
				local group = v2.static.group[nGroup]
				
				for nUnit = #group.units, 1, -1 do
					local unit = group.units[nUnit]

					if unit.DCE_inactive then
						
						print("DcUOoB                remove unit.static "..unit.name.." nUnit: "..nUnit)
						
						table.remove(group.units, nUnit)
					end
				end

				if group.DCE_inactive then
					print("DcUOoB                remove static "..group.name.." nGroup: "..nGroup)
					
					table.remove(v2.static.group,nGroup)
				end
			end
		end
	end
end


