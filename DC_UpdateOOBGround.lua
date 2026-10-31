--To put vehicles and ships from ground OOB into next mission
--Initiated by MAIN_NextMission.lua
-------------------------------------------------------------------------------------------------------
-- last modification: debug_c
if not versionDCE then versionDCE = {} end
versionDCE["DC_UpdateOOBGround.lua"] = "1.4.14"
-------------------------------------------------------------------------------------------------------
-- debug_c					(c unitId en double: faute de frappe UnitId corrigée + traces Debug/WargameTrace.log)
-- debug_b					(ShipHealth < 66%)(a id duplicates)
-- cleancode_a				(a springCleaning)
-- modification M64_c		adds elements of a new base_mission (c ship)(b: update Type & groupId)
-- modification M33_f		frequence des FARP selon db_airbase
-------------------------------------------------------------------------------------------------------
if Debug.debug then
	print("START DC_UpdateOOBGround.lua "..versionDCE["DC_UpdateOOBGround.lua"].." =-=-=-=-=-=-=-=-=-=-=-=-=-=-=")
end

--trace dans Debug/WargameTrace.log (fonction définie dans FUNC_File.lua)
--important = true : aussi en console + BugList
local function oobTrace(msg, important)
	if WgTrace then
		WgTrace(msg, important)
	elseif important then
		print(msg)
	end
end

if WgTraceSection then
	WgTraceSection("DC_UpdateOOBGround "..versionDCE["DC_UpdateOOBGround.lua"])
end

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
-- 	if base.unitname then																	--if airbase is a carrier, find the unit in the OOB Ground
-- 		for coal_name,coal in pairs(oob_ground) do													--go through sides(red/blue)
-- 			for country_n,country in ipairs(coal) do												--go through countries
-- 				if country.ship then														--country has ships
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
local dbgM64Added = 0
local dbgM64GroupIdChanged = 0
local dbgM64UnitsReplaced = 0
local dbgM64WargameCollision = 0

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

									--un groupe de base_mission porte le nom d'un groupe wargame : ne devrait jamais arriver
									if oobGroup.wargameFormationId then
										dbgM64WargameCollision = dbgM64WargameCollision + 1
										oobTrace("DcUOOBG ATTENTION M64: le groupe |"..tostring(missGroup.name).."| de base_mission porte le nom d'un groupe wargame (formationId "..tostring(oobGroup.wargameFormationId)..", groupId oob "..tostring(oobGroup.groupId)..", groupId base_mission "..tostring(missGroup.groupId)..")", true)
									end

									--met à jour les GroupId qui peuvent changer, si le base_mission à été changé aussi
									if oobGroup.groupId ~= missGroup.groupId then
										dbgM64GroupIdChanged = dbgM64GroupIdChanged + 1
										oobTrace("  M64 groupId remplace par celui de base_mission : |"..tostring(oobGroup.name).."| "..tostring(oobGroup.groupId).." -> "..tostring(missGroup.groupId)..(oobGroup.wargameFormationId and " (WARGAME)" or ""))
										oobGroup.groupId = missGroup.groupId
									end

									--met à jour les unitId qui peuvent changer, si le base_mission à été changé aussi
									-- tres important pour lier les pistes (FARP, base, CV CVN ) aux warehouses
									for oobUnitN, oobUnit in ipairs(oobGroup.units) do
										if oobUnitN and missGroup.units[oobUnitN] then
											local unitId = missGroup.units[oobUnitN].unitId

											if unitId and warehouses.warehouses[unitId] then
												if oobUnit.unitId ~= unitId then
													oobTrace("  M64 unitId warehouse remplace : |"..tostring(oobUnit.name).."| "..tostring(oobUnit.unitId).." -> "..tostring(unitId))
													oobUnit.unitId = unitId

													print("DcUOOBG miseAJour_ warehouses Id-- -- > C " .. missCategory .. " " .. oobUnit.type.." Id From missGroup.units "..missGroup.units[oobUnitN].unitId)
													os.execute 'pause'
												end
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
											dbgM64UnitsReplaced = dbgM64UnitsReplaced + 1
											oobTrace("  M64 units remplacees par celles de base_mission : |"..tostring(oobGroup.name).."| "..#oobGroup.units.." -> "..#missGroup.units.." unite(s)"..(oobGroup.wargameFormationId and " (WARGAME)" or ""))
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
							oobTrace("  M64 country cree oob_ground."..missSideName.."["..tostring(missCountryN).."] |"..tostring(missCountry.name).."|")
						end

						-- print("DcUOOBG vehicle: no foundGroup  "..tostring(missSideName).." missCountryN "..tostring(missCountryN).." g "..tostring(g))

						table.insert(oob_ground[missSideName][missCountryN][missCategory].group, missGroup)
						dbgM64Added = dbgM64Added + 1
						oobTrace("  M64 AJOUT groupe de base_mission absent de oob_ground : |"..tostring(missGroup.name).."| oob_ground."..missSideName.."["..tostring(missCountryN).."]."..missCategory.." groupId "..tostring(missGroup.groupId).." units "..#(missGroup.units or {}))
						if WgLooksLikeWargameName and WgLooksLikeWargameName(missGroup.name) then
							oobTrace("DcUOOBG ATTENTION M64: groupe ajoute depuis base_mission avec un nom de type wargame |"..tostring(missGroup.name).."|", true)
						end
						-- print("DcUOOBG vehicle: no foundGroup => table.insert: "..missSideName.." "..missGroup.name)
					end
				end
			end
		end
	end
end

oobTrace("DcUOOBG M64 : "..dbgM64Added.." groupe(s) ajoute(s) depuis base_mission, "..dbgM64GroupIdChanged.." groupId remplace(s), "
	..dbgM64UnitsReplaced.." groupe(s) aux units remplacees, "..dbgM64WargameCollision.." collision(s) de nom avec un groupe wargame", (dbgM64Added + dbgM64WargameCollision) > 0)


--TODO est ce vraiment utile? a quoi ça servait? de supprimer une FARP qui bouge sur BASE_Mission?

-- for side_name, side in pairs(oob_ground) do														--iterate through countries
-- 	for country_n, obCountry in pairs(side) do
-- 		if obCountry.vehicle then																	--country has vehicles
-- 			-- for t = #threat, 1, -1 do
-- 			for o = #obCountry.vehicle.group, 1, -1 do														--iterate through vehicle groups
-- 				if  string.find(string.lower(oobGroup.name),"farp") then
-- 					local foundGroup = false
-- 					for countryN, country in pairs(mission.coalition[side_name].country) do															--iterate through countries
-- 						if country.vehicle then																	--country has vehicles
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
local groupId_owner = {}							--[groupId] = nom du 1er groupe qui le porte (trace)
local unitId_owner = {}								--[unitId] = nom de la 1ere unité qui le porte (trace)
local dbgDupName = 0
local dbgDupGroupId = 0
local dbgDupUnitId = 0

--pistes (FARP, heliports) d'abord : leur unitId est aussi la cle de leur warehouse.
--En cas de doublon ce sont donc les AUTRES unites qui sont renumerotees, jamais la piste.
local function IsPisteUnit(unit)
	return unit.category == "Heliports" or string.find(tostring(unit.type), "FARP", 1, true) ~= nil
end

local unitId_piste = {}							--[unitId] = unite piste qui possede cet id
for side_name, side in pairs(oob_ground) do
	for country_n, country_ in pairs(side) do
		for categorie, categorie_ in pairs(country_) do
			if type(categorie_) == "table" and categorie_.group then
				for groupN, group_ in ipairs(categorie_.group) do
					for unitN, unit in ipairs(group_.units) do
						if IsPisteUnit(unit) and not unitId_2[unit.unitId] then
							unitId_2[unit.unitId] = unit.unitId
							unitId_owner[unit.unitId] = unit.name
							unitId_piste[unit.unitId] = unit
						end
					end
				end
			end
		end
	end
end

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
							dbgDupName = dbgDupName + 1
							oobTrace("  NOM DE GROUPE EN DOUBLE (non corrige) : |"..tostring(group_.name).."| oob_ground."..side_name.."."..categorie..(group_.wargameFormationId and " (WARGAME)" or ""))
						end

						if not  groupId_2[group_.groupId] then
							groupId_2[group_.groupId] = group_.groupId
							groupId_owner[group_.groupId] = group_.name
						else
						-- 	print("DcUOOBG error, duplicate of |"..categorie.."| GroupId |".. GroupId[group_.groupId].."|and|"..tostring(group_.name)
						-- )

						-- 	table.insert(groupIdError,group_.name )

							local oldGroupId = group_.groupId
							group_.groupId = GetNewId(GroupId, maxGroupId, minGroupId)
							dbgDupGroupId = dbgDupGroupId + 1
							oobTrace("  GROUPID EN DOUBLE renumerote : |"..tostring(group_.name).."| "..tostring(oldGroupId).." -> "..tostring(group_.groupId)
								.." (deja porte par |"..tostring(groupId_owner[oldGroupId]).."|)"..(group_.wargameFormationId and " (WARGAME, le groupId du bloc targetlist sera recale par nom)" or ""), group_.wargameFormationId ~= nil)
							-- print("DcUOOBG error, duplicate groupId |"..categorie.."| name |" ..tostring(group_.name).." NewGroupId "..group_.groupId)
						end

						for unitN, unit in ipairs(group_.units) do
							if not  unitId_2[unit.unitId] or unitId_piste[unit.unitId] == unit then
								unitId_2[unit.unitId] = unit.unitId
								unitId_owner[unit.unitId] = unit.name
							else
								-- print("DcUOOBG error, duplicate of |"..categorie.."| UnitId |".. name[group_.UnitId] .."|and|"..tostring(group_.name))

								local oldUnitId = unit.unitId
								unit.unitId = GetNewId(UnitId, maxUnitId, minUnitId)
								dbgDupUnitId = dbgDupUnitId + 1
								oobTrace("  UNITID EN DOUBLE renumerote : |"..tostring(unit.name).."| (groupe |"..tostring(group_.name).."|) "..tostring(oldUnitId).." -> "..tostring(unit.unitId)
									.." (deja porte par |"..tostring(unitId_owner[oldUnitId]).."|)"..(group_.wargameFormationId and " (WARGAME)" or ""))
								-- print("DcUOOBG error, duplicate UnitId |"..categorie.."| name |" ..tostring(group_.name).." NewUnitId "..unit.unitId)
							end

						end
					end
				end
			end
		end
	end
end

oobTrace("DcUOOBG doublons : "..dbgDupName.." nom(s) de groupe en double, "..dbgDupGroupId.." groupId renumerote(s), "..dbgDupUnitId.." unitId renumerote(s)",
	(dbgDupName + dbgDupGroupId + dbgDupUnitId) > 0)

--contrôle de cohérence wargame : état final de oob_ground/targetlist juste avant la copie dans la mission
if WargameCheckConsistency then
	WargameCheckConsistency("DC_UpdateOOBGround avant CORE")
end


--******************************************************************************************************************************
--******************************************************************************************************************************
-- CORE
--******************************************************************************************************************************
--******************************************************************************************************************************


mission.coalition.blue.country = DeepCopy(oob_ground.blue)											--copy blue oob into mission
mission.coalition.red.country = DeepCopy(oob_ground.red)											--copy red oob into mission

local dbgWargameDeadStatic = 0						--unités wargame dead transformées en "Dead Static" dans la mission

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

						if v2.vehicle.group[n].wargameFormationId then
							dbgWargameDeadStatic = dbgWargameDeadStatic + 1
							oobTrace("  CORE unite wargame dead -> Dead Static : |"..tostring(v2.vehicle.group[n].units[m].name).."| groupe |"..tostring(v2.vehicle.group[n].name).."|")
						end

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
									["unitId"] = GenerateIDUnit("DcUooBG dead "..v2.vehicle.group[n].units[m].name, v2.vehicle.group[n].units[m].type),
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
						if group.wargameFormationId then
							oobTrace("  CORE unite wargame DCE_inactive retiree de la mission : |"..tostring(unit.name).."| groupe |"..tostring(group.name).."|")
						end

						table.remove(group.units, nUnit)
					end
				end


				if group.DCE_inactive then
					print("DcUOoB                remove group.vehicle "..group.name.." nGroup: "..nGroup)
					if group.wargameFormationId then
						oobTrace("  CORE groupe wargame DCE_inactive retire de la mission : |"..tostring(group.name).."|")
					end

					table.remove(v2.vehicle.group,nGroup)
				end
			end
		end
		if v2.static then																			--if country has vehicles
			for nGroup = #v2.static.group, 1, -1 do
				local group = v2.static.group[nGroup]

				for nUnit = #group.units, 1, -1 do
					local unit = group.units[nUnit]

					if unit.DCE_inactive then

						print("DcUOoB                remove unit.static "..unit.name.." nUnit: "..nUnit)
						if group.wargameFormationId then
							oobTrace("  CORE unite wargame (static) DCE_inactive retiree de la mission : |"..tostring(unit.name).."| groupe |"..tostring(group.name).."|")
						end

						table.remove(group.units, nUnit)
					end
				end

				if group.DCE_inactive then
					print("DcUOoB                remove static "..group.name.." nGroup: "..nGroup)
					if group.wargameFormationId then
						oobTrace("  CORE groupe wargame (static) DCE_inactive retire de la mission : |"..tostring(group.name).."|")
					end

					table.remove(v2.static.group,nGroup)
				end
			end
		end
	end
end

oobTrace("DcUOOBG CORE : "..dbgWargameDeadStatic.." unite(s) wargame dead transformee(s) en Dead Static dans la mission", dbgWargameDeadStatic > 0)

if WgTraceFlush then
	WgTraceFlush()
end

