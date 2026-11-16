--=======================================================================================
-- ATO_FP_40_Spawn.lua  (appelé par ATO_FlightPlan.lua, via Include)
-- Fonctions d'apparition et d'activation des groupes (spawnOn, activate_*, modify_Activate_GroupTime),
-- démarrage des tâches IA (start_Set_Ai_Task) et chapitre bombardement (createBombingChapter).
-- Le code ci-dessous est celui d'origine ; seuls changent debugTxt_AtoFP et is_helicopter,
-- qui sont maintenant lus dans la table AtoFP (partagée avec le fichier principal).
--=======================================================================================

-- Pont avec ATO_FlightPlan.lua
local debugStart = AtoFP.debugStart
local dbg = AtoFP.dbg
local testDeckPlace = AtoFP.testDeckPlace
--= = = = = = = =  = = = = = = = = = =  = = = = = = = = = =  ==  = = =


--modify_activate_group_time
local function modify_Activate_GroupTime(arg_Group, arg_AirSpawnTime, from)

	dbg("AtoFP_modify_Activate_GroupTime() passe A "..tostring(arg_AirSpawnTime).." from: "..tostring(from))

	-- arg_Group['uncontrolled'] = true -- ATTENTION, non surtout pas, cela depend
	local found = false
	for trig_n = 1, #mission.trigrules do
		if mission.trigrules[trig_n] and mission.trigrules[trig_n].actions and mission.trigrules[trig_n].actions[1] then
			if mission.trigrules[trig_n].actions[1].group and mission.trigrules[trig_n].actions[1].group == arg_Group.groupId then

				
				if mission.trigrules[trig_n].rules and mission.trigrules[trig_n].rules[1] then
					if mission.trigrules[trig_n].rules[1].flag then
						
						dbg("AtoFP_modify_Activate_GroupTime() passe Z, RETURN, activate by flag found ")
						return
					end
				end

				if arg_AirSpawnTime == -1 then
					arg_AirSpawnTime = 0
				end

				mission.trigrules[trig_n].rules[1].seconds = arg_AirSpawnTime
				-- dbg("AtoFP passe 1Bc seconds (after) "..tostring(mission.trigrules[trig_n].rules[1].seconds))

				-- conditions[44] = 'return(c_time_after(2233.512158504) )',
				mission.trig.conditions[trig_n] = "return(c_time_after(" .. arg_AirSpawnTime .. ") )"
				dbg("AtoFP_modify_Activate_GroupTime() B find groupId "..arg_Group.groupId.." trig_n: "..tostring(trig_n))
				found = true
			end
		end
	end

	if not found then
		DebugFLIGHT = DebugFLIGHT .. "\n".." AtoFP_modify_Activate_GroupTime() C ERROR: NO TRIGGER FOUND groupId "..tostring(arg_Group.groupId).." from: "..tostring(from)
	end
end

-- modification M37.l SuperCarrier (l: ajout alt et speed aux unites)(i: option deck air catapult)
--Spawn OnDeck, OnCatapult or OnAir
local function spawnOn(arg_Spawn, arg_Waypoints, arg_Group, arg_Pn, arg_SpawnTime, arg_From, arg_Flight, arg_f, arg_Role)
	arg_Spawn = string.lower(arg_Spawn)

	dbg("AtoFP_spawnOn() A SpawnOn() "..arg_Spawn.." |arg_SpawnTime: "..arg_SpawnTime.." from: "..tostring(arg_From).." Missionfunc: "..tostring(Missionfunc))

	-- ATO_FP_Debug_k
	local alt_Role = 0
	if arg_Role == "SEAD" then
		alt_Role = 1
	elseif arg_Role == "Escort" then
		alt_Role = 2
	end

	if arg_Spawn == "air" then
		dbg("AtoFP_spawnOn() B AIR ")

		if arg_Waypoints[1]["alt"] <= 500 and not AtoFP.is_helicopter then arg_Waypoints[1]["alt"] = 500 end

		local altBase = arg_Waypoints[1]["alt"]
		if db_airbases[arg_Flight[arg_f].base].elevation then
			altBase = db_airbases[arg_Flight[arg_f].base].elevation
		end
		local altStep = 500
		local speed = 200
		if AtoFP.is_helicopter then
			altStep = 50
			speed = arg_Flight[arg_f].loadout.vCruise / 4 * 3
		end

		if arg_Waypoints[1]["speed"] then
			speed = arg_Waypoints[1]["speed"]
		end

		arg_Waypoints[1]["action"] = "Turning Point"
		arg_Waypoints[1]["type"] = "Turning Point"

		local psi = 0
		local heading = 0

		if arg_Waypoints[2] then
			local dx = arg_Waypoints[2].x - arg_Waypoints[1].x
			local dy = arg_Waypoints[2].y - arg_Waypoints[1].y

			heading = math.atan2(dx, dy)
			psi = -heading
		end

		arg_Waypoints[1]["alt"] = altBase + (arg_Pn * altStep) + (alt_Role * 33)
		arg_Waypoints[1]["speed"] = speed
		-- arg_Waypoints[1]["ETA"] = spawnTime
		arg_Waypoints[1]["ETA"] = arg_SpawnTime

		arg_Group.start_time = arg_SpawnTime

		if arg_Waypoints[1].helipadId then
			arg_Waypoints[1].helipadId = nil
		end
		if arg_Waypoints[1].linkUnit then
			arg_Waypoints[1].linkUnit = nil
		end

		dbg("AtoFP_spawnOn() A SpawnOn() Turning Point "..arg_Spawn.." from: "..tostring(arg_From).." Missionfunc: "..tostring(Missionfunc))


		local alt = 150

		if AtoFP.is_helicopter then 											-- M6.1 sauf helicopter			
			if db_airbases[arg_Flight[arg_f].base].elevation then							--airbase has defined elevation
				alt = alt + db_airbases[arg_Flight[arg_f].base].elevation					--make alt above base
			end
			arg_Waypoints[1]["alt"] = alt  + (arg_Pn * 10) + alt_Role * 33
		end

		-- anti collision entre packages différents
		local spawnHash = math.abs(
			math.floor(arg_Waypoints[1].x / 1000) +
			math.floor(arg_Waypoints[1].y / 1000)
		)

		local spacing = 500 -- Mets ici la distance minimale souhaitée (en mètres)

		local spawnOffsetX = ((spawnHash % 7) - 3) * spacing * 2
		local spawnOffsetY = (((math.floor(spawnHash / 7)) % 7) - 3) * spacing * 2

		
		if AtoFP.is_helicopter then spacing = 100 end

		for	n = 1, #arg_Group.units do

			if arg_Flight[arg_f].task ~= "AFAC" then
				-- arg_Group.units[n].x = ((arg_Pn-1) * spacing) + ((arg_f-1) * spacing) + arg_Group.units[n].x + (spacing * n)	--ANTI-COLLISION A
				-- arg_Group.units[n].y = ((arg_Pn-1) * spacing) + ((arg_f-1) * spacing) + arg_Group.units[n].y + (spacing * n)	--ANTI-COLLISION A
				
				arg_Group.units[n].x = spawnOffsetX +
					((arg_Pn-1) * spacing) +
					((arg_f-1) * spacing) +
					arg_Group.units[n].x +
					(spacing * n)

				arg_Group.units[n].y = spawnOffsetY +
					((arg_Pn-1) * spacing) +
					((arg_f-1) * spacing) +
					arg_Group.units[n].y +
					(spacing * n)
				
				arg_Group.units[n].alt = ((arg_Pn-1) * spacing/1.2) + ((arg_f-1) * spacing) + arg_Waypoints[1]["alt"] + (spacing * n) 		--ANTI-COLLISION A
			end

			arg_Group.units[n].speed = speed
			arg_Group.units[n].psi = psi
			arg_Group.units[n].heading = heading

			if AtoFP.is_helicopter then
				-- group.units[n]["alt"] = alt  + (Pn * 10) + alt_Role * 11
				arg_Group.units[n].alt = ((arg_Pn-1) * spacing/1.2) + ((arg_f-1) * spacing) + arg_Waypoints[1]["alt"] + (spacing * n) 		--ANTI-COLLISION A
				-- group.units[n]["alt"] = waypoints[1]["alt"]
				arg_Group.units[n].speed = speed
			else
				-- group.units[n]["alt"] = waypoints[1]["alt"] + (Pn * 500) + alt_Role * 33
				-- group.units[n]["alt"] = waypoints[1]["alt"]
			end
		end

		--///---enleve la task demarrage--///---
		--///---enleve la task demarrage--///---
		arg_Group['uncontrolled'] = false
		arg_Group['tasks'] = {}														--supprime le tasks start

		--si le tasks START est supprimé, il faut aussi le supprimer des trigrules &Co
		local found_trigN
		for trig_n = 1, #mission.trigrules do
			if mission.trigrules[trig_n] and mission.trigrules[trig_n].actions and mission.trigrules[trig_n].actions[1] then
				if mission.trigrules[trig_n].actions[1].set_ai_task and mission.trigrules[trig_n].actions[1].set_ai_task[1] and mission.trigrules[trig_n].actions[1].set_ai_task[1] == arg_Group.groupId then
					if mission.trigrules[trig_n].actions[1]["predicate"] == "a_set_ai_task" then

						found_trigN = trig_n
						dbg("AtoFP_spawnOn() C0b supprime start_Set_Ai_Task groupId "..arg_Group.groupId.." trig_n: "..tostring(trig_n))
						break


					end
				end
			end
		end

		-- supprime le trigrule start_Set_Ai_Task
		if found_trigN then
			table.remove(mission.trigrules, found_trigN)
			table.remove(mission.trig.flag, found_trigN)
			table.remove(mission.trig.conditions, found_trigN)
			table.remove(mission.trig.actions, found_trigN)
			table.remove(mission.trig.func, found_trigN)

		end
		--///---enleve la task demarrage--///---
		--///---enleve la task demarrage--///---

		if arg_SpawnTime and arg_SpawnTime > 1 and Missionfunc then	--not group["TrigActivate"] and
			dbg("AtoFP_spawnOn() C0  ")

			arg_Group['lateActivation'] = true											--make group late activation "en vol"

			local activateGroupExist = false
			for n , trigrule in pairs(mission.trigrules) do
				if type(trigrule) == "table" then
					if trigrule.actions and trigrule.actions[1] and trigrule.actions[1].group == arg_Group.groupId then
						if trigrule.actions[1]["predicate"] == "a_activate_group" then

							activateGroupExist = true
							dbg("AtoFP_spawnOn() C1 activateGroupExist ")
						end
					end
				end
			end

			if not activateGroupExist then
				dbg("AtoFP_spawnOn() C2 activateGroupExist ")

				arg_Group.start_time = arg_SpawnTime

				local trig_n = #mission.trig.actions + 1
				Missionfunc = Missionfunc + 1
				mission.trig.func[trig_n] = "if mission.trig.conditions[" .. trig_n .. "]() then mission.trig.actions[" .. trig_n .. "]() end"
				mission.trig.flag[trig_n] = true
				mission.trig.conditions[trig_n] = "return(c_time_after(" .. arg_SpawnTime .. ") )"
				mission.trig.actions[trig_n] = "a_activate_group(" .. arg_Group.groupId .. "); mission.trig.func[" .. trig_n .. "]=nil;"	-- ATO_FP_Debug02 Interceptor error nb trigger
				mission.trigrules[trig_n] = {
					['rules'] = {
						[1] = {
							["seconds"] = arg_SpawnTime,
							["predicate"] = "c_time_after",
						},
					},
					['eventlist'] = '',
					['comment'] = 'Trigger ' .. trig_n,
					['predicate'] = 'triggerOnce',
					['actions'] = {
						[1] = {
							["group"] = arg_Group.groupId,
							["predicate"] = "a_activate_group",
						},
					}
				}

			end
		end

		-- remet l'horaire d'origine sur activate
		local passModified = true
		if mission.trigrules and mission.trigrules[trig_n] and mission.trigrules[trig_n].rules and mission.trigrules[trig_n].rules[1] then
			if mission.trigrules[trig_n].rules[1].flag then
				passModified = false
			end
		end
		if passModified then
			modify_Activate_GroupTime(arg_Group, arg_SpawnTime, debug.getinfo(1).currentline)
		end

		--supprime les avions initialement prévu sur le pont, puisque maintenant, ils spawnent en vol
		if testDeckPlace and testDeckPlace[arg_Flight[arg_f].base] then
			local deckList = testDeckPlace[arg_Flight[arg_f].base]
			if deckList then
				for i = #deckList, 1, -1 do
					if deckList[i].groupName == arg_Flight[arg_f].name then
						if debugStart then
							AtoFP.debugTxt_AtoFP = AtoFP.debugTxt_AtoFP .. "\n" .. ("AtoFP RemovetestDeckPlace i " .. tostring(i) .. " " .. tostring(deckList[i].groupName))
						end
						table.remove(deckList, i)
					end
				end
			end
		end

		dbg("AtoFP_spawnOn(AIR) arg_Group.uncontrolled "..tostring(arg_Group.uncontrolled))


	elseif arg_Spawn == "catapult" then

		dbg("AtoFP_spawnOn() CATAPULT D ")

		arg_Waypoints[1]["action"] = "From Runway"
		arg_Waypoints[1]["type"] = "TakeOff"
		arg_Waypoints[1]["alt"] = 0
		arg_Group.uncontrolled = false											-- sur cata, les F14 IA bloquent
	end

end


--activate_group_withFlag
local function activate_Group_WithFlag(group, flag, from)

	dbg("AtoFP_activate_Group_WithFlag() passe A  "..tostring(flag).." from: "..tostring(from))

	group['uncontrolled'] = false
	group['lateActivation'] = true

	local trig_n =  #mission.trig.actions + 1
	Missionfunc = Missionfunc + 1 																	--M11.o
	mission.trig.func[trig_n] = "if mission.trig.conditions[" .. trig_n .. "]() then mission.trig.actions[" .. trig_n .. "]() end"
	mission.trig.flag[trig_n] = true
	mission.trig.conditions[trig_n] = "return(c_flag_is_true(" .. flag .. ") )"
	mission.trig.actions[trig_n] = "a_activate_group(" .. group.groupId .. "); mission.trig.func[" .. trig_n .. "]=nil;"
	mission.trigrules[trig_n] = {
		['rules'] = {
			[1] = {
				["flag"] = flag,
				["predicate"] = "c_flag_is_true",
				["zone"] = "",
			},
		},
		['eventlist'] = '',
		['comment'] = 'Trigger ' .. trig_n,
		['predicate'] = 'triggerOnce',
		['actions'] = {
			[1] = {
				["group"] = group.groupId,
				["predicate"] = "a_activate_group",
			},
		}
	}


end

--activate_group_time_after
local function activate_group_time_after(group, airSpawnTime, from)

	--ça tombe bien, on ne fait pas sur le sixpack
	group['lateActivation'] = true --incompatible avec l'activation sur sixpack
	
	dbg("AtoFP passe 1B activate_group_time_after |lateActivation| "..tostring(group['lateActivation']).."|"..tostring(from))

	local trig_n =  #mission.trig.actions + 1
	Missionfunc = Missionfunc + 1
	mission.trig.func[trig_n] = "if mission.trig.conditions[" .. trig_n .. "]() then mission.trig.actions[" .. trig_n .. "]() end"
	mission.trig.flag[trig_n] = true
	mission.trig.conditions[trig_n] = "return(c_time_after(" .. airSpawnTime .. ") )"
	mission.trig.actions[trig_n] = "a_activate_group(" .. group.groupId .. "); mission.trig.func[" .. trig_n .. "]=nil;"
	mission.trigrules[trig_n] = {
		['rules'] = {
			[1] = {
				["seconds"] = airSpawnTime,
				["predicate"] = "c_time_after",
			},
		},
		['eventlist'] = '',
		['comment'] = 'Trigger ' .. trig_n,
		['predicate'] = 'triggerOnce',
		['actions'] = {
			[1] = {
				["group"] = group.groupId,
				["predicate"] = "a_activate_group",
			},
		}
	}
end

--start_set_ai_task
local function start_Set_Ai_Task(arg_group, aiStart_Time, flag, from)

	arg_group['uncontrolled'] = true

	dbg("AtoFP tasks_Start start_set_ai_task uncontrolled|"..tostring(arg_group['uncontrolled']).."|"..tostring(from))

	if flag then
		dbg("c_flag_is_true|"..tostring(flag))
	else
		dbg("c_time_after|"..tostring(aiStart_Time))
	end

	-- local trig_n = Missionfunc + #mission.trig.funcStartup + 1										--next available trigger number
	local trig_n = #mission.trig.actions + 1
	Missionfunc = Missionfunc + 1
	mission.trig.func[trig_n] = "if mission.trig.conditions[" .. trig_n .. "]() then mission.trig.actions[" .. trig_n .. "]() end"
	mission.trig.flag[trig_n] = true
	if aiStart_Time then
		mission.trig.conditions[trig_n] = "return(c_time_after(" .. aiStart_Time .. ") )"
	elseif flag then
		mission.trig.conditions[trig_n] = "return(c_flag_is_true(" .. GCI.Flag .. ") )"
	end
	mission.trig.actions[trig_n] = "a_set_ai_task(" .. arg_group.groupId .. ", 1); mission.trig.func[" .. trig_n .. "]=nil;"
	mission.trigrules[trig_n] = {
		-- ['rules'] = {
		-- 	[1] = {
		-- 		["seconds"] = aiStart_Time,
		-- 		["predicate"] = "c_time_after",
		-- 		["zone"] = "",
		-- 	},
		-- },
		['eventlist'] = '',
		['comment'] = 'Trigger_' .. arg_group.name,
		['predicate'] = 'triggerOnce',
		['actions'] = {
			[1] = {
				["predicate"] = "a_set_ai_task",
				["set_ai_task"] = {
					[1] = arg_group.groupId,
					[2] = 1,
				}
			},
		},
	}
	if aiStart_Time then
		mission.trigrules[trig_n]['rules'] = {
			[1] = {
				["seconds"] = aiStart_Time,
				["predicate"] = "c_time_after",
				-- ["zone"] = "",
			}
		}
	elseif flag then
		mission.trigrules[trig_n]['rules'] = {
			[1] = {
				["flag"] = GCI.Flag,
				["predicate"] = "c_flag_is_true",
				-- ["zone"] = "",
			}
		}
	end
	--triggered action to start uncontrolled group
	arg_group['tasks'] = {
		[1] = {
			["number"] = 1,
			["name"] = arg_group.name,
			["id"] = "WrappedAction",
			["auto"] = false,
			["enabled"] = true,
			["params"] = {
				["action"] = {
					["id"] = "Start",
					["params"] = {},
				},
			},
		},
	}
end


local function createBombingChapter(arg_idTask, arg_Flight, arg_Wpt, arg_WeaponType, arg_AttackType, arg_AttackAlt, arg_Element, arg_From, arg_TypeCible )

	dbg("AtoFP passe function createBombingChapter id_task:  "..tostring(arg_idTask).." |element.name: "..tostring(arg_Element.name).." |from: "..tostring(arg_From))

	local stopLoop = false
	-- cherche xy des elements dans la table oob_ground s'ils n'existent pas dans la table targetlist
	if (arg_idTask == "AttackUnit" or arg_idTask == "Bombing" or arg_idTask == "AttackMapObject") and arg_Element ~= nil then
		if not (arg_Flight.target.elements) or not (arg_Element) or not( arg_Element.x) then

			-- print("AtoFP PASSE A not elements xy  "..tostring(flight.target_name).." || "..tostring(element.name))

			for sideName, oob in pairs(oob_ground) do
				for country_n, country in pairs(oob_ground[sideName]) do						--iterate through countries
					if country.static then
						for group_n, group in pairs(country.static.group) do				--iterate through groups in country.static.group table
							for unit_n, unit in pairs(group.units) do									--Iterate through elements of target						
								if unit.name == arg_Flight.target_name or unit.name == arg_Element.name then
									arg_Element.x = unit.x
									arg_Element.y = unit.y
									print("AtoFP passe XD find target "..tostring(group.name))
									stopLoop = true
								elseif  group.name == arg_Flight.target_name or group.name == arg_Element.name then
									arg_Element.x = unit.x
									arg_Element.y = unit.y
									print("AtoFP passe ZD find target "..tostring(group.name))
									stopLoop = true
								end
								if stopLoop then break end
							end
							if stopLoop then break end
						end
						if stopLoop then break end
					end
					if country.vehicle then
						for group_n, group in pairs(country.vehicle.group) do				--iterate through groups in country.static.group table
							for unit_n, unit in pairs(group.units) do									--Iterate through elements of target						
								-- print("AtoFP passe ZC_b group.name "..tostring(group.name).." || "..tostring(arg_Flight.target.name))

								-- if group.name == unit.name then
								if unit.name == arg_Flight.target_name or unit.name == arg_Element.name then
									arg_Element.x = unit.x
									arg_Element.y = unit.y
									-- print("AtoFP passe ZD find target "..tostring(group.name))
									stopLoop = true
								elseif  group.name == arg_Flight.target_name or group.name == arg_Element.name then
									arg_Element.x = unit.x
									arg_Element.y = unit.y
									-- print("AtoFP passe ZD find target "..tostring(group.name))
									stopLoop = true
								end
								if stopLoop then break end
							end
							if stopLoop then break end
						end
						if stopLoop then break end
					end
					if stopLoop then break end
				end
				if stopLoop then break end
			end
		end
	end

	local taskEnable = false
	if arg_Flight.player or arg_Flight.client then
		taskEnable = true
	end

	local task_entry = {}

	if arg_idTask == "AttackGroup" then
		-- print("AtoFP CBC passe M AttackGroup ")
		task_entry = {
			["enabled"] = taskEnable,
			["auto"] = false,
			["id"] = arg_idTask,
			["number"] = #arg_Wpt["task"]["params"]["tasks"] + 1,
			["params"] =
			{
				["groupId"] = arg_Flight.target.groupId,
				["weaponType"] = arg_WeaponType,
				["expend"] = arg_Flight.loadout.expend,
				["attackType"] = arg_Flight.loadout.attackType,
			}
		}
	elseif arg_idTask == "AttackUnit" then
		-- print("AtoFP CBC passe N AttackUnit ")
		task_entry = {
			["enabled"] = taskEnable,
			["auto"] = false,
			["id"] = "AttackUnit",
			["number"] = #arg_Wpt["task"]["params"]["tasks"] + 1,
			["params"] = {
				["x"] = arg_Element.x,
				["y"] = arg_Element.y,
				["unitId"] = arg_Element.unitId,
				["expend"] = arg_Flight.loadout.expend,
				["weaponType"] = arg_WeaponType,
				["groupAttack"] = false,
				["attackType"] = arg_AttackType,
				["attackQtyLimit"] = true,
				["attackQty"] = 1,
				["altitudeEdited"] = true,
				["altitudeEnabled"] = true,
				["altitude"] = arg_AttackAlt,
				["directionEnabled"] = false,
				["direction"] = 0,
			},
		}
	elseif arg_idTask == "Bombing" then
		if not arg_Element.x then
			DebugFLIGHT = DebugFLIGHT .. "\n"..("AtoFp (arg_idTask == Bombing) noX "..arg_Element.name.." |from| "..tostring(arg_From))
		end

		task_entry = {									--define attack task
			["enabled"] = taskEnable,
			["auto"] = false,
			["id"] = "Bombing",
			["number"] = #arg_Wpt["task"]["params"]["tasks"] + 1,
			["params"] = {
				["x"] = arg_Element.x,
				["y"] = arg_Element.y,
				["expend"] = arg_Flight.loadout.expend,
				["weaponType"] = arg_WeaponType,
				["groupAttack"] = false,
				["attackType"] = arg_AttackType,
				["attackQtyLimit"] = true,
				["attackQty"] = 1,
				["altitudeEdited"] = true,
				["altitudeEnabled"] = true,
				["altitude"] = arg_AttackAlt,
				["directionEnabled"] = false,
				["direction"] = 0,
			},
		}
	elseif arg_idTask == "AttackMapObject" then
		task_entry = {
			["enabled"] = taskEnable,
			["auto"] = false,
			["id"] = "AttackMapObject",
			["number"] = #arg_Wpt["task"]["params"]["tasks"] + 1,
			["params"] = {
				["x"] = arg_Element.x,
				["y"] = arg_Element.y,
				["weaponType"] = arg_WeaponType,
				["expend"] = arg_Flight.loadout.expend,
				["direction"] = 0,
				["attackQtyLimit"] = false,
				["attackQty"] = 1,
				["directionEnabled"] = false,
				["groupAttack"] = true,
				["altitude"] = 2000,
				["altitudeEnabled"] = false,
			},
		}
	elseif arg_idTask == "" then
		DebugFLIGHT = DebugFLIGHT .. "\n"..("AtoFp no id_task from "..tostring(arg_From))
	end

	return task_entry
end

--= = = = = = = =  = = = = = = = = = =  = = = = = = = = = =  ==  = = =
-- Ce que ce fichier rend à ATO_FlightPlan.lua
AtoFP.modify_Activate_GroupTime = modify_Activate_GroupTime
AtoFP.spawnOn = spawnOn
AtoFP.activate_Group_WithFlag = activate_Group_WithFlag
AtoFP.activate_group_time_after = activate_group_time_after
AtoFP.start_Set_Ai_Task = start_Set_Ai_Task
AtoFP.createBombingChapter = createBombingChapter
