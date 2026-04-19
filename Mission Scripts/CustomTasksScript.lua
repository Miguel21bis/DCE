-- --To provide custom AI Attack Tasks 
--Script attached to mission and executed via trigger
--Functions accessed via LUA Run Script on waypoint
------------------------------------------------------------------------------------------------------- 
if not versionDCE then versionDCE = {} end
versionDCE["Mission Scripts/CustomTasksScript.lua"] = "2.12.51"
------------------------------------------------------------------------------------------------------- 

env.info("### DCE START CustomIntercept.lua " .. versionDCE["Mission Scripts/CustomTasksScript.lua"] .. " =-=-=-=-=-=-=-=-=-=-=-=-=-=-=")

GroupStateMemory = GroupStateMemory or {}


local selectedTransport = 0			--util pour embarked
local attackCounter	= {}
local falseCycleCount = {}												--table to count how many flights have already attacked and distribute subsequent attacks accordingly

--TODO encore utile?
local baseFullName =
{
	["Sukhumi"]  = "Sukhumi-Babushara";
	["Anapa"]  = "Anapa-Vityazevo";
	["Maykop"]  = "Maykop-Khanskaya";
	["Sochi"]  = "Sochi-Adler";
	["Senaki"]  = "Senaki-Kolkhi";
	["Mineralnye"]  = "Mineralnye Vody";
	["Tbilisi"]  = "Tbilisi-Lochini";
}

----- attack group -----
--allows each wingman of a flight to attack its own target in a vahicle/ship group simultaneously, then proceed to Egress point to join up (flight would not climb during egress if wingmen would joing leader imediately after attack)
function CustomGroupAttack(flightName, targetName, expend, weaponType, attackType, attackAlt, taskId)
	
	env.info("DCE_CustomGroupAttack start| "..tostring(flightName))

	local t0
	if campL.debug then
		t0 = os.clock()
		Perf_P_N = Perf_P_N + 1
	end

	-- Weapon.Category
	-- SHELL     0
	-- MISSILE   1
	-- ROCKET    2
	-- BOMB      3

	local function execute(arg)
		local arg2_Cntrl = arg[1]
		local arg2_ComboTask = arg[2]
		local arg2_n = arg[3]
		local current_time = timer.getTime()

		if campL.debug then
			--export custom mission log
			local logStr = "ComboTask = " .. TableSerialization(arg2_ComboTask, 0)
			local flightNameClean = flightName:gsub('[%p%c%s]', '_')
			local logFile = io.open(PathDCE.."Debug\\"..flightNameClean.."_"..arg2_n.."_".. "CustomGroupAttack".."_"..tostring(current_time)..".lua", "w")
			if logFile then
				logFile:write(logStr)
				logFile:close()
			else
				env.info("DCE_CustomGroupAttack: Failed to open log file for writing.")
			end
		end

		arg2_Cntrl:pushTask(arg2_ComboTask)									--push task to front of task list	

		env.info("DCE_CustomGroupAttack | fin")
	end

	local targetGroup = Group.getByName(targetName)						--get target group
    if targetGroup then                          --target group exists
        local idTypeStrike = "Bombing"
        -- if (weaponType == 4161536 or weaponType == 14) and id_task == "CAS" then	-- Guided bombs or ASM M54_a
        if taskId == "CAS" or taskId == "Pinpoint Strike" then --  M54_a		
            idTypeStrike = "AttackUnit"
        else
            idTypeStrike = "Bombing"
        end

        if attackCounter[targetName] then                    --counter with number of flights that have already attacked this target
            attackCounter[targetName] = attackCounter[targetName] + 1 --increase counter by one
        else                                                 --no flight has attacked this target yet
            attackCounter[targetName] = 1                    --set to one
        end
        local attackN = attackCounter[targetName]

        local target = targetGroup:getUnits() --get target units

        if attackType ~= "Dive" then
            attackType = nil
        end

        local flight = Group.getByName(flightName) --get group of attacking flight
        local wingman = flight:getUnits()    --get list of units from attacking flights

        local egressWP

        local flightPlan = MissGroupByName[flightName].route.points
        for w = 1, #flightPlan do        --iterate through all group waypoints
            if string.find(flightPlan[w].name, "Egress") then
                egressWP = flightPlan[w] --store Egress waypoint
                break
            end
        end

        --[[ for coalition_name,coal in pairs(env.mission.coalition) do
			local stop = false
			for country_n,country in pairs(coal.country) do
				if country.plane then
					for group_n,group in pairs(country.plane.group) do
						-- if FlightName == env.getValueDictByKey(group.name) then								--find group in env.mission
						if flightName == group.name then
							for w = 1, #group.route.points do												--iterate through all group waypoints
								-- if string.find(env.getValueDictByKey(group.route.points[w].name), "Egress") then		--find egress waypoint
								if string.find(group.route.points[w].name, "Egress") then
									egressWP = group.route.points[w]										--store Egress waypoint
									stop = true
									break
								end
							end
						end
						if stop then
							break
						end
					end
				end
				if country.helicopter then
					for group_n,group in pairs(country.helicopter.group) do
						-- if FlightName == env.getValueDictByKey(group.name) then								--find group in env.mission
						if flightName == group.name then
							for w = 1, #group.route.points do												--iterate through all group waypoints
								-- if string.find(env.getValueDictByKey(group.route.points[w].name), "Egress") then		--find egress waypoint
								if string.find(group.route.points[w].name, "Egress") then
									egressWP = group.route.points[w]										--store Egress waypoint
									stop = true
									break
								end
							end
						end
						if stop then
							break
						end
					end
				end
				if stop then
					break
				end
			end
			if stop then
				break
			end
		end ]]

        for n = 1, #wingman do         --iterate through all aircraft in flight
            local cntrl
            if n == 1 then             --for leader
                cntrl = flight:getController() --get controller of group
            else                       --for wingmen
                cntrl = wingman[n]:getController() --get controller of individual aircraft in flight
                -- cntrl:resetTask()					
                -- cntrl:setOption(AI.Option.Air.id.REACTION_ON_THREAT, 2) 	--set to evade fire again, as controller for individual unit does not take over options from parent group
            end

            -- local unitObj = flight:getUnit(n)
            -- local ammo = unitObj:getAmmo()
            -- for k,v in pairs(ammo) do
            -- 	local ammo_string = "wingmann "..n.." count: "..tostring(v.count).." t: ".. tostring(v.desc.category).." typeName: ".. tostring(v.desc.typeName)
            -- 	env.info("DCE_CustomGroupAttack: ammo_string |"..ammo_string)
            -- end


            local comboTask = { --define combo task to hold multiple attack tasks
                id = 'ComboTask',
                params = {
                    tasks = {},
                },
            }

            for t = #target, 1, -1 do --iterate thourgh targets
                if not target[t]:isExist() then
                    -- env.info("DCE_CustomGroupAttack |"..tostring(t))
                    table.remove(target, t)
                end
            end

            for t = 1, #target do --iterate thourgh targets
                --each wingman gets one attack task for each target
                local num = t + math.ceil((n - 1) * (#target / #wingman)) --distribute target numbers across flight
                num = num + attackN - 1                       --increase target number to adjust for previous attacks
                while num > #target do
                    num = num - #target
                end

                -- env.info("DCE_CustomGroupAttack num? |"..tostring(num))

                local task_entry = { --define attack task
                    ["enabled"] = true,
                    ["auto"] = false,
                    ["id"] = "Bombing",
                    ["number"] = #comboTask.params.tasks + 1,
                    ["params"] = {
                        ["x"] = target[num]:getPoint().x,
                        ["y"] = target[num]:getPoint().z,
                        ["expend"] = expend,
                        ["weaponType"] = tonumber(weaponType),
                        ["groupAttack"] = false,
                        ["attackType"] = attackType,
                        ["attackQtyLimit"] = false,
                        ["attackQty"] = 1,
                        -- ["altitudeEdited"] = true,
                        ["altitudeEnabled"] = true,
                        ["altitude"] = tonumber(attackAlt),
                        ["directionEnabled"] = false,
                        ["direction"] = 0,
                    },
                }

                if attackAlt and tonumber(attackAlt) > 0 then
                    task_entry.altitudeEnabled = true
                end

                --auto expend
                if ((expend == "Auto" or target[num]:getDesc().category == 3) and idTypeStrike == "AttackUnit") or idTypeStrike == "AttackUnit" then --if auto expend or target unit is a ship
                    local existId = tonumber(target[num]:getID())
                    env.info("DCE_CustomGroupAttack existId? |" .. tostring(existId))
                    if existId then
                        task_entry.id = "AttackUnit" --attack unit instead of bombing task
                        task_entry.params.unitId = existId
                    end

                    -- if existId ~= nil and existId ~= false  then
                    -- 	env.info("DCE_CustomGroupAttack: passe G2 ")
                    -- end
                end

                if expend == "All" and t > 1 and weaponType ~= "ASM" then
                    -- env.info("DCE_CustomGroupAttack: passe G3 ")
                    break
                end

                env.info("DCE_CustomGroupAttack |" .. tostring(flightName) .. "| |" .. tostring(task_entry["id"]))

                table.insert(comboTask.params.tasks, task_entry)
            end

            if n > 1 and egressWP.x then --for all wingmen
                local missionTask = { --mission task to store go-to Egress waypoint task for wingmen (wingmen need to fly to Egress individually, otherwise out-of-formation flight will not climb during egress)
                    id = 'Mission',
                    params = {
                        route = {
                            points = {}
                        }
                    }
                }
                table.insert(missionTask.params.route.points, egressWP)                                  --add egress waypoint into MissionTask
                missionTask.params.route.points[1].x = missionTask.params.route.points[1].x +
                math.random(-500, 500)                                                                   --add some randomness to egress waypoint location to prevent all aircraft in flight converging on same point
                missionTask.params.route.points[1].y = missionTask.params.route.points[1].y + math.random(-500, 500)
                missionTask.params.route.points[1].alt = missionTask.params.route.points[1].alt + math.random(-100, 100)
                table.insert(comboTask.params.tasks, missionTask) --add mission task fly to Egress waypoint individually, where the task will end and the wingmen will join their leader
            end

            -- local nextSecond = math.ceil(timer.getTime()) + 1
            -- if AgendaSeconde[nextSecond] then
            -- 	local i = 1
            -- 	repeat
            -- 		nextSecond = nextSecond + 1
            -- 		i = i + 1
            -- 	until not AgendaSeconde[nextSecond] or i > 1000
            -- 	AgendaSeconde[nextSecond] = true
            -- else
            -- 	AgendaSeconde[nextSecond] = true
            -- end
            -- timer.scheduleFunction(execute, {cntrl, comboTask, n} ,nextSecond)

            execute()
        end
    end
	if campL.debug then
		local dt = os.clock() - t0
		Perf_P = Perf_P + dt
	end
end


----- attack multiple static objects -----
--allows each wingman of a flight to attack its own individual target simultaneously, then proceed to Egress point to join up (flight would not climb during egress if wingmen would joing leader imediately after attack)
function CustomStaticAttack(flightName, targetList, expend, weaponType, attackType, attackAlt, id_task)
	
	env.info("DCE_CustomStaticAttack | start| "..tostring(flightName))

	local function execute(arg)
		local cntrl = arg[1]
		local comboTask = arg[2]
		local n = arg[3]
		local current_time = timer.getTime()

		if campL.debug then
			--export custom mission log
			local logStr = "ComboTask = " .. TableSerialization(comboTask, 0)
			local FlightNameClean = flightName:gsub('[%p%c%s]', '_')
			local logFile = io.open(PathDCE.."Debug\\"..FlightNameClean.."_"..n.."_".. "CustomStaticAttack_"..tostring(current_time)..".lua", "w")
			if logFile then
				logFile:write(logStr)
				logFile:close()
			else
				env.info("DCE_CustomStaticAttack: Failed to open log file for writing.")
			end
		end

		cntrl:pushTask(comboTask)									--push task to front of task list	

		env.info("DCE_CustomStaticAttack | fin")
	end

	local idTypeStrike  = "Bombing"
	if id_task == "CAS" then												--  M54_a		
		idTypeStrike  = "AttackUnit"
	else
		idTypeStrike  = "Bombing"
	end

	if attackCounter[targetList[1]] then									--counter with number of flights that have already attacked this target
		attackCounter[targetList[1]] = attackCounter[targetList[1]] + 1		--increase counter by one
	else																	--no flight has attacked this target yet
		attackCounter[targetList[1]] = 1									--set to one
	end
	local AttackN = attackCounter[targetList[1]]

	env.info("DCE_CustomStaticAttack : AttackN "..tostring(AttackN))

	if attackType ~= "Dive" then
		attackType = nil
	end

	local flight = Group.getByName(flightName)						--get group of attacking flight
	local wingman = flight:getUnits()								--get list of units from attacking flights

	local EgressWP
	for coalition_name,coal in pairs(env.mission.coalition) do
		local stop = false
		for country_n,country in pairs(coal.country) do
			if country.plane then
				for group_n,group in pairs(country.plane.group) do
					-- if FlightName == env.getValueDictByKey(group.name) then								--find group in env.mission
					if flightName == group.name then
						for w = 1, #group.route.points do												--iterate through all group waypoints
							-- if string.find(env.getValueDictByKey(group.route.points[w].name), "Egress") then		--find egress waypoint
							if string.find(group.route.points[w].name, "Egress") then
								EgressWP = group.route.points[w]										--store Egress waypoint
								stop = true
								break
							end
						end
					end
					if stop then
						break
					end
				end
			end
			if country.helicopter then
				for group_n,group in pairs(country.helicopter.group) do
					-- if FlightName == env.getValueDictByKey(group.name) then								--find group in env.mission
					if flightName == group.name then
						for w = 1, #group.route.points do												--iterate through all group waypoints
							-- if string.find(env.getValueDictByKey(group.route.points[w].name), "Egress") then		--find egress waypoint
							if string.find(group.route.points[w].name, "Egress") then
								EgressWP = group.route.points[w]										--store Egress waypoint
								stop = true
								break
							end
						end
					end
					if stop then
						break
					end
				end
			end
			if stop then
				break
			end
		end
		if stop then
			break
		end
	end

	for n = 1, #wingman do											--iterate through all aircraft in flight
		local cntrl
		if n == 1 then												--for leader
			cntrl = flight:getController()							--get controller of group
		else														--for wingmen
			cntrl = wingman[n]:getController()						--get controller of individual aircraft in flight
			cntrl:setOption(AI.Option.Air.id.REACTION_ON_THREAT, 2) 	--set to evade fire again, as controller for individual unit does not take over options from parent group
		end

		local ComboTask = {											--define combo task to hold multiple attack tasks
			id = 'ComboTask',
			params = {
				tasks = {},
			},
		}

		for t = 1, #targetList do									--iterate thourgh targets

			--each wingman gets one attack task for each target	
			local num = t + math.ceil((n - 1) * (#targetList / #wingman))	--distribute target numbers across flight
			num = num + AttackN - 1											--increase target number to adjust for previous attacks
			while num > #targetList do
				num = num - #targetList
			end

			local staticName = targetList[num]
			local staticTemp = false

			env.info("DCE_CustomStaticAttack :StaticName AA |"..tostring(staticName).."|")

			if  StaticObject.getByName(staticName) then
				staticTemp = StaticObject.getByName(staticName)
				env.info("DCE_CustomStaticAttack found BB |"..tostring(staticName).."|")
			else
				staticName = staticName.."-1"
				staticTemp = StaticObject.getByName(staticName)
				if staticTemp then
					env.info("DCE_CustomStaticAttack found CC-1 |"..tostring(staticName).."|")
				end
			end

			if staticTemp then							--make sure that static object still exists

				-- local targetID = StaticObject.getByName(TargetList[num]):getID()	--get static object ID
				local targetID = staticTemp:getID()	--get static object ID

				local task_entry = {									--define attack task
					["enabled"] = true,
					["auto"] = false,
					["id"] = idTypeStrike,
					["number"] = #ComboTask.params.tasks + 1,
					["params"] = {
						["x"] = staticTemp:getPoint().x,
						["y"] = staticTemp:getPoint().z,
						["expend"] = expend,
						["weaponType"] = tonumber(weaponType),
						["groupAttack"] = false,
						["attackType"] = attackType,
						["attackQtyLimit"] = false,
						["attackQty"] = 1,
						-- ["altitudeEdited"] = true,
						["altitudeEnabled"] = true,
						["altitude"] = tonumber(attackAlt),
						["directionEnabled"] = false,
						["direction"] = 0,
					},
				}

				-- --auto expend
				-- if expend == "Auto" and id_task == "CAS" then
					-- task_entry["id"] = "AttackUnit"
					-- task_entry.params["unitId"] = targetID
					-- task_entry.params["attackQtyLimit"] = false
				-- end


				--auto expend
				if  idTypeStrike == "AttackUnit" then
					task_entry["id"] = "AttackUnit"
					task_entry.params["unitId"] = tonumber(targetID)
					task_entry.params["attackQtyLimit"] = false
					task_entry.params["x"] = nil
					task_entry.params["y"] = nil
				end

				-- ["stopCondition"] = 
				-- {
				-- 	["time"] = tonumber(UntilTime),
				-- 	-- ["duration"] = tonumber(var_duration),
				-- }

				env.info("DCE_CustomStaticAttack: CustomStaticAttack DD |"..tostring(flightName).."| |"..tostring(task_entry["id"]))

				table.insert(ComboTask.params.tasks, task_entry)

				-- local nextSecond = math.ceil(timer.getTime()) + 1
				-- if AgendaSeconde[nextSecond] then
				-- 	local i = 1
				-- 	repeat
				-- 		nextSecond = nextSecond + 1
				-- 		i = i + 1
				-- 	until not AgendaSeconde[nextSecond] or i > 1000	
				-- 	AgendaSeconde[nextSecond] = true
				-- else
				-- 	AgendaSeconde[nextSecond] = true
				-- end

				-- timer.scheduleFunction(execute, {cntrl, ComboTask, n} , nextSecond)	

			end
		end

		local nextSecond = math.ceil(timer.getTime()) + 1
		if AgendaSeconde[nextSecond] then
			local i = 1
			repeat
				nextSecond = nextSecond + 1
				i = i + 1
			until not AgendaSeconde[nextSecond] or i > 1000
			AgendaSeconde[nextSecond] = true
		else
			AgendaSeconde[nextSecond] = true
		end

		timer.scheduleFunction(execute, {cntrl, ComboTask, n} , nextSecond)

	end
end

----- attack multiple all class objects -----
--allows each wingman of a flight to attack its own individual target simultaneously, then proceed to Egress point to join up (flight would not climb during egress if wingmen would joing leader imediately after attack)
function CustomMixClassAttack(flightName, targetList, expend, weaponType, attackType, attackAlt, id_task)
	
    env.info("DCE_CustomMixClassAttack | start| " .. tostring(flightName))
	
	local t0
	if campL.debug then
		t0 = os.clock()
		Perf_Q_N = Perf_Q_N + 1
	end

	--{cntrl, comboTask, n}
	local function execute(arg)
		local cntrl = arg[1]
		local comboTask = arg[2]
		local n = arg[3]
		local current_time = timer.getTime()

		if campL.debug then
			--export custom mission log
			local logStr = "ComboTask = " .. TableSerialization(comboTask, 0)
			local flightNameClean = flightName:gsub('[%p%c%s]', '_')
			local logFile = io.open(PathDCE.."Debug\\"..flightNameClean.."_"..n.."_".. "CustomMixClasscAttack_"..tostring(current_time)..".lua", "w")
			if logFile then
				logFile:write(logStr)
				logFile:close()
			else
				-- env.info("DCE_CustomMixClassAttack: Failed to open log file for writing.")
			end
		end

		cntrl:pushTask(comboTask)									--push task to front of task list	

		-- env.info("DCE_CustomMixClassAttack | fin")
	end

	local idTypeStrike  = "Bombing"
	-- if id_task == "CAS" then												--  M54_a		
	-- 	idTypeStrike  = "AttackUnit"  --TODO a confirmer que cela fonctionne sur un static	
	-- end

	if attackCounter[targetList[1]] then									--counter with number of flights that have already attacked this target
		attackCounter[targetList[1]] = attackCounter[targetList[1]] + 1		--increase counter by one
	else																	--no flight has attacked this target yet
		attackCounter[targetList[1]] = 1									--set to one
	end
	local AttackN = attackCounter[targetList[1]]

	-- env.info("DCE_CustomMixClassAttack : AttackN "..tostring(AttackN))

	if attackType ~= "Dive" then
		attackType = nil
	end

	local flight = Group.getByName(flightName)						--get group of attacking flight
	local wingman = flight:getUnits()								--get list of units from attacking flights

	local EgressWP
	for coalition_name,coal in pairs(env.mission.coalition) do
		local stop = false
		for country_n,country in pairs(coal.country) do
			if country.plane then
				for group_n,group in pairs(country.plane.group) do
					-- if flightName == env.getValueDictByKey(group.name) then								--find group in env.mission
					if flightName == group.name then
						for w = 1, #group.route.points do												--iterate through all group waypoints
							-- if string.find(env.getValueDictByKey(group.route.points[w].name), "Egress") then		--find egress waypoint
							if string.find(group.route.points[w].name, "Egress") then
								EgressWP = group.route.points[w]										--store Egress waypoint
								stop = true
								break
							end
						end
					end
					if stop then
						break
					end
				end
			end
			if country.helicopter then
				for group_n,group in pairs(country.helicopter.group) do
					-- if flightName == env.getValueDictByKey(group.name) then								--find group in env.mission
					if flightName == group.name then
						for w = 1, #group.route.points do												--iterate through all group waypoints
							-- if string.find(env.getValueDictByKey(group.route.points[w].name), "Egress") then		--find egress waypoint
							if string.find(group.route.points[w].name, "Egress") then
								EgressWP = group.route.points[w]										--store Egress waypoint
								stop = true
								break
							end
						end
					end
					if stop then
						break
					end
				end
			end
			if stop then
				break
			end
		end
		if stop then
			break
		end
	end

    for n = 1, #wingman do                                 --iterate through all aircraft in flight
        local cntrl
        if n == 1 then                                     --for leader
            cntrl = flight:getController()                 --get controller of group
        else                                               --for wingmen
            cntrl = wingman[n]:getController()             --get controller of individual aircraft in flight
            cntrl:setOption(AI.Option.Air.id.REACTION_ON_THREAT, 2) --set to evade fire again, as controller for individual unit does not take over options from parent group
        end

        local comboTask = { --define combo task to hold multiple attack tasks
            id = 'ComboTask',
            params = {
                tasks = {},
            },
        }

        for t = 1, #targetList do --iterate thourgh targets
            --each wingman gets one attack task for each target	
            local num = t + math.ceil((n - 1) * (#targetList / #wingman)) --distribute target numbers across flight
            num = num + AttackN - 1                              --increase target number to adjust for previous attacks
            while num > #targetList do
                num = num - #targetList
            end

            local targetName = targetList[num][1]
            local targetClass = targetList[num][2]
            local targetX = tostring(targetList[num][3])
            local targetY = tostring(targetList[num][4])
            local targetTemp = false
            local targetTempPos = {}
            local targetID

            -- env.info("DCE_CustomMixClassAttack :targetName AA |"..tostring(targetName).."|targetClass: "..tostring(targetClass))

            if targetClass == "static" then
                targetTemp = StaticObject.getByName(targetName)
                if targetTemp then
                    targetTempPos = {
                        x = targetTemp:getPoint().x,
                        y = targetTemp:getPoint().z,
                    }
                    -- idTypeStrike  = "AttackUnit"
                    -- targetID = targetTemp:getID()

                    idTypeStrike  = "Bombing"

                    -- env.info("DCE_CustomMixClassAttack static found BB1 |"..tostring(targetName).."|")
                    -- _affiche(targetTemp, "targetName StaticObject.getByName")
                end
            elseif (targetClass == "MapObject" or targetClass == nil or targetClass == "nil") then
                targetTempPos = {
                    x = targetX,
                    y = targetY,
                }
                targetTemp    = true
                idTypeStrike  = "Bombing"

                -- env.info("DCE_CustomMixClassAttack MapObject found BB2 |"..tostring(targetName).."|")
            elseif targetClass == "nil" then
                targetTempPos = {
                    x = targetX,
                    y = targetY,
                }
                targetTemp    = true
                idTypeStrike  = "Bombing"

                -- env.info("DCE_CustomMixClassAttack MapObject found BB22 |"..tostring(targetName).."|")
            else --if targetClass == "vehicle" then
                targetTemp = Unit.getByName(targetName)
                if targetTemp then
                    targetTempPos = {
                        x = targetTemp:getPoint().x,
                        y = targetTemp:getPoint().z,
                    }
                    -- idTypeStrike  = "AttackUnit"
                    -- targetID = targetTemp:getID()

                    idTypeStrike  = "Bombing"

                    -- env.info("DCE_CustomMixClassAttack vehicle found BB3 |"..tostring(targetName).."|")
                end
            end

            if targetTemp then --make sure that static object still exists
                -- env.info("DCE_CustomMixClassAttack: DD1 ")

                local task_entry = { --define attack task
                    ["enabled"] = true,
                    ["auto"] = false,
                    ["id"] = idTypeStrike,
                    ["number"] = #comboTask.params.tasks + 1,
                    ["name"] = "task: " .. tostring(id_task) .. " class: " .. tostring(targetClass),
                    ["params"] = {
                        ["x"] = targetTempPos.x,
                        ["y"] = targetTempPos.y,
                        ["expend"] = expend,
                        ["weaponType"] = tonumber(weaponType),
                        ["groupAttack"] = false,
                        ["attackType"] = attackType,
                        ["attackQtyLimit"] = false,
                        ["attackQty"] = 1,
                        -- ["altitudeEdited"] = true,
                        ["altitudeEnabled"] = true,
                        ["altitude"] = tonumber(attackAlt),
                        ["directionEnabled"] = false,
                        ["direction"] = 0,
                    },
                }

                --auto expend
                if idTypeStrike == "AttackUnit" then
                    task_entry["id"] = "AttackUnit"
                    task_entry.params["unitId"] = tonumber(targetID)
                    task_entry.params["attackQtyLimit"] = false
                    task_entry.params["x"] = nil
                    task_entry.params["y"] = nil
                end

                -- ["stopCondition"] =
                -- {
                -- 	["time"] = tonumber(UntilTime),
                -- 	-- ["duration"] = tonumber(var_duration),
                -- }

                -- env.info("DCE_CustomMixClassAttack: CustomStaticAttack DD |"..tostring(flightName).."| |"..tostring(task_entry["id"]))

                table.insert(comboTask.params.tasks, task_entry)
            end
        end

        -- local nextSecond = math.ceil(timer.getTime()) + 1
        -- if AgendaSeconde[nextSecond] then
        --     local i = 1
        --     repeat
        --         nextSecond = nextSecond + 1
        --         i = i + 1
        --     until not AgendaSeconde[nextSecond] or i > 1000
        --     AgendaSeconde[nextSecond] = true
        -- else
        --     AgendaSeconde[nextSecond] = true
        -- end

        -- timer.scheduleFunction(execute, { cntrl, comboTask, n }, nextSecond)

        execute({ cntrl, comboTask, n })
		
    end
	
    if campL.debug then
        local dt = os.clock() - t0
		Perf_Q = Perf_Q + dt
    end
	
end
----- attack multiple map objects -----
--allows each wingman of a flight to attack its own individual target simultaneously, then proceed to Egress point to join up (flight would not climb during egress if wingmen would joing leader imediately after attack)
function CustomMapObjectAttack(FlightName, TargetList, expend, weaponType, attackType, attackAlt, id_task)
	
	env.info("DCE_CustomMapObjectAttack:  | start| "..tostring(FlightName))

	local idTypeStrike  = "Bombing"

	local function execute(arg)
		local cntrl = arg[1]
		local ComboTask = arg[2]
		local n = arg[3]
		local current_time = timer.getTime()

		if campL.debug then
			--export custom mission log
			local logStr = "ComboTask = " .. TableSerialization(ComboTask, 0)
			local FlightNameClean = FlightName:gsub('[%p%c%s]', '_')
			local logFile = io.open(PathDCE.."Debug\\"..FlightNameClean.."_"..n.."_CustomMapObjectAttack_"..tostring(current_time)..".lua", "w")
			if logFile then
				logFile:write(logStr)
				logFile:close()
			else
				env.info("DCE_CustomMapObjectAttack: Failed to open log file for writing.")
			end
		end

		cntrl:pushTask(ComboTask)									--push task to front of task list	

		env.info("DCE_CustomMapObjectAttack | fin")
	end


	-- if id_task == "CAS" then
	-- 	idTypeStrike  = "Bombing"											--  M54_a
	-- end

	if attackCounter[TargetList[1].x .. TargetList[1].y] then															--counter with number of flights that have already attacked this target
		attackCounter[TargetList[1].x .. TargetList[1].y] = attackCounter[TargetList[1].x .. TargetList[1].y] + 1		--increase counter by one
	else																												--no flight has attacked this target yet
		attackCounter[TargetList[1].x .. TargetList[1].y] = 1															--set to one
	end
	local AttackN = attackCounter[TargetList[1].x .. TargetList[1].y]

	if attackType ~= "Dive" then
		attackType = nil
	end

	local flight = Group.getByName(FlightName)						--get group of attacking flight
	local wingman = flight:getUnits()								--get list of units from attacking flights

	local EgressWP
	for coalition_name,coal in pairs(env.mission.coalition) do
		local stop = false
		for country_n,country in pairs(coal.country) do
			if country.plane then
				for group_n,group in pairs(country.plane.group) do
					-- if FlightName == env.getValueDictByKey(group.name) then								--find group in env.mission
					if FlightName == group.name then
						for w = 1, #group.route.points do												--iterate through all group waypoints
							-- if string.find(env.getValueDictByKey(group.route.points[w].name), "Egress") then		--find egress waypoint
							if string.find(group.route.points[w].name, "Egress") then
								EgressWP = group.route.points[w]										--store Egress waypoint
								stop = true
								break
							end
						end
					end
					if stop then
						break
					end
				end
			end
			if country.helicopter then
				for group_n,group in pairs(country.helicopter.group) do
					-- if FlightName == env.getValueDictByKey(group.name) then								--find group in env.mission
					if FlightName == group.name then
						for w = 1, #group.route.points do												--iterate through all group waypoints
							-- if string.find(env.getValueDictByKey(group.route.points[w].name), "Egress") then		--find egress waypoint
							if string.find(group.route.points[w].name, "Egress") then
								EgressWP = group.route.points[w]										--store Egress waypoint
								stop = true
								break
							end
						end
					end
					if stop then
						break
					end
				end
			end
			if stop then
				break
			end
		end
		if stop then
			break
		end
	end

	for n = 1, #wingman do											--iterate through all aircraft in flight
		local cntrl
		if n == 1 then												--for leader
			cntrl = flight:getController()							--get controller of group
		else														--for wingmen
			cntrl = wingman[n]:getController()						--get controller of individual aircraft in flight
			cntrl:setOption(AI.Option.Air.id.REACTION_ON_THREAT, 2) 	--set to evade fire again, as controller for individual unit does not take over options from parent group
		end

		local ComboTask = {											--define combo task to hold multiple attack tasks
			id = 'ComboTask',
			params = {
				tasks = {},
			},
		}

		for t = 1, #TargetList do									--iterate thourgh targets

			--each wingman gets one attack task for each target
			local num = t + math.ceil((n - 1) * (#TargetList / #wingman))	--distribute target numbers across flight
			num = num + AttackN - 1											--increase target number to adjust for previous attacks
			while num > #TargetList do
				num = num - #TargetList
			end

			local task_entry = {									--define attack task
				["enabled"] = true,
				["auto"] = false,
				["id"] = idTypeStrike,
				["number"] = #ComboTask.params.tasks + 1,
				["params"] = {
					["x"] = TargetList[num].x,
					["y"] = TargetList[num].y,
					["expend"] = expend,
					["weaponType"] = tonumber(weaponType),
					["groupAttack"] = false,
					["attackType"] = attackType,
					-- ["attackQtyLimit"] = false,
					["attackQty"] = 1,
					["altitudeEdited"] = true,
					["altitudeEnabled"] = true,
					["altitude"] = tonumber(attackAlt),
					["directionEnabled"] = false,
					["direction"] = 0,
				},
			}

			--auto expend
			if expend == "Auto" and id_task ~= "CAS" then
				task_entry["id"] = "AttackMapObject"
				-- task_entry.params["attackQtyLimit"] = false		-- + CTS_debug12 strike ASM B52 , bizarrement, lorsque attackQtyLimit=true cela permet de tirer tous les missiles d'un coup
			end

			if expend == "All" and #ComboTask.params.tasks == 1 then
				env.info("DCE_CustomMapObjectAttack: All break "..tostring(#ComboTask.params.tasks))
				break
			elseif expend == "Half" and #ComboTask.params.tasks == 2 then
				env.info("DCE_CustomMapObjectAttack: Half break "..tostring(#ComboTask.params.tasks))
				break
			end

			env.info("DCE_CustomMapObjectAttack |"..tostring(FlightName).."| |"..tostring(task_entry["id"]).."|#tasks|"..tostring(#ComboTask.params.tasks))

			table.insert(ComboTask.params.tasks, task_entry)
		end


		local nextSecond = math.ceil(timer.getTime()) + 1
		if AgendaSeconde[nextSecond] then
			local i = 1
			repeat
				nextSecond = nextSecond + 1
				i = i + 1
			until not AgendaSeconde[nextSecond] or i > 1000
			AgendaSeconde[nextSecond] = true
		else
			AgendaSeconde[nextSecond] = true
		end

		timer.scheduleFunction(execute, {cntrl, ComboTask, n} , nextSecond)


	end
end


----- attack aircraft on ground -----
--allows each wingman of a flight to attack its own target aircraft on ground simultaneously, then proceed to Egress point to join up (flight would not climb during egress if wingmen would joing leader imediately after attack)
function CustomAirbaseAttack(FlightName, TargetPos, expend, weaponType, attackType, attackAlt)
	
	if attackCounter[TargetPos.x .. TargetPos.y] then													--counter with number of flights that have already attacked this target
		attackCounter[TargetPos.x .. TargetPos.y] = attackCounter[TargetPos.x .. TargetPos.y] + 1		--increase counter by one
	else																								--no flight has attacked this target yet
		attackCounter[TargetPos.x .. TargetPos.y] = 1													--set to one
	end
	local AttackN = attackCounter[TargetPos.x .. TargetPos.y]

	if attackType ~= "Dive" then
		attackType = nil
	end

	local flight = Group.getByName(FlightName)						--get group of attacking flight
	local wingman = flight:getUnits()								--get list of units from attacking flights

	local EgressWP
	for coalition_name,coal in pairs(env.mission.coalition) do
		local stop = false
		for country_n,country in pairs(coal.country) do
			if country.plane then
				for group_n,group in pairs(country.plane.group) do
					-- if FlightName == env.getValueDictByKey(group.name) then								--find group in env.mission
					if FlightName == group.name then
						for w = 1, #group.route.points do												--iterate through all group waypoints
							-- if string.find(env.getValueDictByKey(group.route.points[w].name), "Egress") then		--find egress waypoint
							if string.find(group.route.points[w].name, "Egress") then
								EgressWP = group.route.points[w]										--store Egress waypoint
								stop = true
								break
							end
						end
					end
					if stop then
						break
					end
				end
			end
			if country.helicopter then
				for group_n,group in pairs(country.helicopter.group) do
					-- if FlightName == env.getValueDictByKey(group.name) then								--find group in env.mission
					if FlightName == group.name then
						for w = 1, #group.route.points do												--iterate through all group waypoints
							-- if string.find(env.getValueDictByKey(group.route.points[w].name), "Egress") then		--find egress waypoint
							if string.find(group.route.points[w].name, "Egress") then
								EgressWP = group.route.points[w]										--store Egress waypoint
								stop = true
								break
							end
						end
					end
					if stop then
						break
					end
				end
			end
			if stop then
				break
			end
		end
		if stop then
			break
		end
	end

	--search for aircraft on ground and build target list
	local TargetList = {}

	local function Found(u)
		if u:getCoalition() ~= wingman[1]:getCoalition() then								--unit is hostile
			local desc = u:getDesc()														--get unit description
			if desc.category == 0 or desc.category == 1 then								--unit is an aircraft or helicopter
				if u:inAir() == false then													--aircraft is on ground
					local uV = u:getVelocity()												--get aircraft speed
					if (desc.category == 0 and uV.x == 0 and uV.y == 0 and uV.z == 0) or desc.category == 1 then	--aircraft is stationary/parked	(doesn't work for helicopters because for helos getVelocity returns IAS not absolute speed)	
						local uPvec3 = u:getPoint()												--get aircraft point
						table.insert(TargetList, {x = uPvec3.x, y = uPvec3.z})						--insert x-y coordinates into targetlist
					end
				end
			end
		end
		return true																			--continue search
	end

	local SearchArea = {
		id = world.VolumeType.SPHERE,
		params = {
			point = {
				x = TargetPos.x,
				y = land.getHeight({TargetPos.x, TargetPos.y}),
				z = TargetPos.y,
			},
			radius = 4500
		}
	}
	world.searchObjects(Object.Category.UNIT, SearchArea, Found)

	if #TargetList > 0 then												--if there is a target
		for n = 1, #wingman do											--iterate through all aircraft in flight
			local cntrl
			if n == 1 then												--for leader
				cntrl = flight:getController()							--get controller of group
			else														--for wingmen
				cntrl = wingman[n]:getController()						--get controller of individual aircraft in flight
				cntrl:setOption(AI.Option.Air.id.REACTION_ON_THREAT, 2) 	--set to evade fire again, as controller for individual unit does not take over options from parent group
			end

			local ComboTask = {											--define combo task to hold multiple attack tasks
				id = 'ComboTask',
				params = {
					tasks = {},
				},
			}

			local num = 1 + math.ceil((n - 1) * (#TargetList / #wingman))	--distribute target numbers across flight
			num = num + AttackN - 1											--increase target number to adjust for previous attacks
			while num > #TargetList do
				num = num - #TargetList
			end

			local task_entry = {									--define attack task
				["enabled"] = true,
				["auto"] = false,
				["id"] = "Bombing",
				["number"] = #ComboTask.params.tasks + 1,
				["params"] = {
					["x"] = TargetList[num].x,
					["y"] = TargetList[num].y,
					["expend"] = expend,
					["weaponType"] = weaponType,
					["groupAttack"] = false,
					["attackType"] = attackType,
					-- ["attackQtyLimit"] = true,
					["attackQty"] = 1,
					["altitudeEdited"] = true,
					["altitudeEnabled"] = true,
					["altitude"] = attackAlt,
					["directionEnabled"] = false,
					["direction"] = 0,
				},
			}

			table.insert(ComboTask.params.tasks, task_entry)

			if n > 1 then												--for all wingmen
				local MissionTask = {									--mission task to store go-to Egress waypoint task for wingmen (wingmen need to fly to Egress individually, otherwise out-of-formation flight will not climb during egress)
					id = 'Mission',
					params = {
						route = {
							points = {}
						}
					}
				}
				table.insert(MissionTask.params.route.points, EgressWP)	--add egress waypoint into MissionTask
				MissionTask.params.route.points[1].x = MissionTask.params.route.points[1].x + math.random(-500, 500)	--add some randomness to egress waypoint location to prevent all aircraft in flight converging on same point
				MissionTask.params.route.points[1].y = MissionTask.params.route.points[1].y + math.random(-500, 500)
				MissionTask.params.route.points[1].alt = MissionTask.params.route.points[1].alt + math.random(-100, 100)
				table.insert(ComboTask.params.tasks, MissionTask)		--add mission task fly to Egress waypoint individually, where the task will end and the wingmen will join their leader
			end

			if campL.debug then
				local logStr = "ComboTask = " .. TableSerialization(ComboTask, 0)
				local FlightNameClean = FlightName:gsub('[%p%c%s]', '_')
				local logFile = io.open(PathDCE.."Debug\\"..FlightNameClean.."_"..n.."_".. "CustomAirbaseAttack.lua", "w")
				if logFile then
					logFile:write(logStr)
					logFile:close()
				else
					env.info("DCE_CustomAirbaseAttack: Failed to open log file for writing.")
				end
			end

			cntrl:pushTask(ComboTask)									--push task to front of task list
		end
	end
end


----- rejoin flight -----
--resets tasks of individual wingmen to rejoin the flight
function CustomRejoin(FlightName)
	

	-- local test = true
	-- if test then return end

	env.info("DCE_CustomRejoin | start| "..tostring(FlightName))

	local function execute(cntrl)
		cntrl:resetTask()												--reset task (wingman will rejoin with leader)

		if campL.debug then

			env.info("DCE_CustomRejoin | execute | cntrl:resetTask()| "..tostring(cntrl).." actualtime: "..tostring(timer.getTime()))
			_affiche(cntrl, "DCE_CustomRejoin cntrl")

		end
	end

	local flight = Group.getByName(FlightName)						--get group of attacking flight
	local wingman = flight:getUnits()								--get list of units from attacking flights
	-- for n = 2, #wingman do
	for n = 2, #wingman do											--iterate through wingmen in flight
		local cntrl = wingman[n]:getController()					--get controller of individual aircraft in flight

		local nextSecond = math.ceil(timer.getTime()) + 1
		if AgendaSeconde[nextSecond] then
			local i = 1
			repeat
				nextSecond = nextSecond + 1
				i = i + 1
			until not AgendaSeconde[nextSecond] or i > 1000
			AgendaSeconde[nextSecond] = true
		else
			AgendaSeconde[nextSecond] = true
		end
		env.info("DCE_CustomRejoin: | next_execute| "..tostring(FlightName).." wingman: "..n.." actualtime: "..tostring(timer.getTime()).." nextSecond: "..tostring(nextSecond))
		timer.scheduleFunction(execute, cntrl, nextSecond)
	end

end

----- target illumination with flares -----
function CustomFlareAttack(FlightName, tgt_x, tgt_y, grp_name, expend, weaponType, attackType, attackAlt)
	
	if attackType ~= "Dive" then
		attackType = nil
	end
	if tgt_x == "n/a" and tgt_y == "n/a" then						--if the coordinates are n/a, then the target is a vehicle/ship group
		local tgt_grp = Group.getByName(grp_name)					--get target group
		local tgt_units = tgt_grp:getUnits()						--get target units 
		local tgt_p_vec3 = tgt_units[1]:getPoint()						--get group leader point
		tgt_x = tgt_p_vec3.x
		tgt_y = tgt_p_vec3.z
	end

	local flight = Group.getByName(FlightName)						--get group of attacking flight
	local wingman = flight:getUnits()								--get list of units from attacking flights

	local EgressWP
	for coalition_name,coal in pairs(env.mission.coalition) do
		local stop = false
		for country_n,country in pairs(coal.country) do
			if country.plane then
				for group_n,group in pairs(country.plane.group) do
					-- if FlightName == env.getValueDictByKey(group.name) then								--find group in env.mission
					if FlightName == group.name then
						for w = 1, #group.route.points do												--iterate through all group waypoints
							-- if string.find(env.getValueDictByKey(group.route.points[w].name), "Egress") then		--find egress waypoint
							if string.find(group.route.points[w].name, "Egress") then
								EgressWP = group.route.points[w]										--store Egress waypoint
								stop = true
								break
							end
						end
					end
					if stop then
						break
					end
				end
			end
			if country.helicopter then
				for group_n,group in pairs(country.helicopter.group) do
					-- if FlightName == env.getValueDictByKey(group.name) then								--find group in env.mission
					if FlightName == group.name then
						for w = 1, #group.route.points do												--iterate through all group waypoints
							-- if string.find(env.getValueDictByKey(group.route.points[w].name), "Egress") then		--find egress waypoint
							if string.find(group.route.points[w].name, "Egress") then
								EgressWP = group.route.points[w]										--store Egress waypoint
								stop = true
								break
							end
						end
					end
					if stop then
						break
					end
				end
			end
			if stop then
				break
			end
		end
		if stop then
			break
		end
	end

	for n = 1, #wingman do											--iterate through all aircraft in flight
		local cntrl
		if n == 1 then												--for leader
			cntrl = flight:getController()							--get controller of group
		else														--for wingmen
			cntrl = wingman[n]:getController()						--get controller of individual aircraft in flight
			cntrl:setOption(AI.Option.Air.id.REACTION_ON_THREAT, 2) 	--set to evade fire again, as controller for individual unit does not take over options from parent group
		end

		local ComboTask = {											--define combo task to hold multiple attack tasks
			id = 'ComboTask',
			params = {
				tasks = {
					[1] = {											--define attack task
						["number"] = 1,
						["auto"] = false,
						["id"] = "Bombing",
						["enabled"] = true,
						["params"] =
						{
							["x"] = tgt_x,
							["y"] = tgt_y,
							["direction"] = 0,
							["attackQtyLimit"] = false,
							["attackQty"] = 1,
							["expend"] = expend,
							["altitudeEdited"] = true,
							["altitudeEnabled"] = true,
							["altitude"] = attackAlt,
							["directionEnabled"] = false,
							["groupAttack"] = false,
							["weaponType"] = weaponType,
							["attackType"] = attackType,
						},
					}
				},
			},
		}

		if n > 1 then												--for all wingmen
			local MissionTask = {									--mission task to store go-to Egress waypoint task for wingmen (wingmen need to fly to Egress individually, otherwise out-of-formation flight will not climb during egress)
				id = 'Mission',
				params = {
					route = {
						points = {}
					}
				}
			}
			table.insert(MissionTask.params.route.points, EgressWP)	--add egress waypoint into MissionTask
			MissionTask.params.route.points[1].x = MissionTask.params.route.points[1].x + math.random(-500, 500)	--add some randomness to egress waypoint location to prevent all aircraft in flight converging on same point
			MissionTask.params.route.points[1].y = MissionTask.params.route.points[1].y + math.random(-500, 500)
			MissionTask.params.route.points[1].alt = MissionTask.params.route.points[1].alt + math.random(-100, 100)
			table.insert(ComboTask.params.tasks, MissionTask)		--add mission task fly to Egress waypoint individually, where the task will end and the wingmen will join their leader
		end

		cntrl:pushTask(ComboTask)									--push task to front of task list
	end
end


----- target laser/fumigene illumination -----
function CustomLaserDesignation(FlightName, target, class, laserCode)
	
	local laser														--variable to hold the laser spot

	if laserCode and laserCode ~= "nil" then


		if class == "vehicle" then										--target is a vehicle/ship group

			local function designationCycle()							--laser designation cycle function
				if laser and laser ~= nil then											--if there is already an existing laser spot
					laser:destroy()										--destroy it
					env.info("DCE_CustomLaserDesignation laser/destroy ")
				end

				local group = Group.getByName(target)					--get target group
				local units = group:getUnits()							--get target units

				local flight = Group.getByName(FlightName)				--get group of designating flight
				if flight then
					local wingman = flight:getUnits()						--get list of units from designating flights

					if wingman[1] and units[1] then							--if target group has a leader unit left
						local posVec3 = units[1]:getPoint()						--get target position
						laser = Spot.createLaser(wingman[1], nil, posVec3, laserCode)	--start laser spot
					end
				end

				if laser and laser ~= nil then											--if there is a new laser spot
					return timer.getTime() + 2							--repeat designation cylce in 2 seconds
				else													--if no laser spot was created
					return												--stop designation cycle
				end
			end
			timer.scheduleFunction(designationCycle, nil, timer.getTime() + 1)	--start designation cylce

		elseif class == "static" then									--targets are static objects
			local u = 0													--TargetList counter

			local function designationCycle()							--laser designation cycle function
				if laser and laser ~= nil then											--if there is already an existing laser spot
					laser:destroy()										--destroy it
					env.info("DCE_CustomLaserDesignation designationCycle static/laser/destroy ")
				end

				repeat
					u = u + 1											--iterate through all target elements
				until StaticObject.getByName(target[u]) or u == #target		--repeat until first alive static object is found in TargetList or end of TargetList is reached

				local static = StaticObject.getByName(target[u])		--get static object

				local flight = Group.getByName(FlightName)				--get group of designating flight
				local wingman = flight:getUnits()						--get list of units from designating flights

				if wingman[1] and static then							--if flight leader and static object are alive
					local posVec3 = static:getPoint()						--get target position
					laser = Spot.createLaser(wingman[1], nil, posVec3, laserCode)	--start laser spot
				end

				if laser and laser ~= nil then											--if there is a new laser spot
					return timer.getTime() + 2							--repeat designation cylce in 2 seconds
				else													--if no laser spot was created
					return												--stop designation cycle
				end
			end
			timer.scheduleFunction(designationCycle, nil, timer.getTime() + 1)	--start designation cylce

		elseif class == "scenery" then									--targets are scenery objects
			local u = 0													--TargetList counter

			local function designationCycle()							--laser designation cycle function
				if laser and laser ~= nil then											--if there is already an existing laser spot
					laser:destroy()										--destroy it
					env.info("DCE_CustomLaserDesignation designationCycle scenerylaser/destroy ")
				end

				repeat
					u = u + 1											--iterate through all target elements

					local scenery
					local function IfFound(obj)							--function to run if scenery object is found
						scenery = obj									--store scenery object
					end

					local SearchArea = {								--scenery object search area centered on target position
						id = world.VolumeType.SPHERE,
						params = {
							point = {
								x = target[u].x,
								y = land.getHeight({x = target[u].x, y = target[u].y}),
								z = target[u].y
							},
							radius = 1
						}
					}
					world.searchObjects(Object.Category.SCENERY, SearchArea, IfFound)	--search for scenery object at target position
				until scenery or u == #target							--repeat until first alive scenery object is found in TargetList or end of TargetList is reached

				local flight = Group.getByName(FlightName)				--get group of designating flight
				local wingman = flight:getUnits()						--get list of units from designating flights

				if wingman[1]	then									--if flight leader is alive
					local pos = {										--get target position
						x = target[u].x,
						y = land.getHeight({x = target[u].x, y = target[u].y}),
						z = target[u].y
					}
					laser = Spot.createLaser(wingman[1], nil, pos, laserCode)	--start laser spot
				end

				if laser and laser ~= nil  then											--if there is a new laser spot
					return timer.getTime() + 2							--repeat designation cylce in 2 seconds
				else													--if no laser spot was created
					return												--stop designation cycle
				end
			end
			timer.scheduleFunction(designationCycle, nil, timer.getTime() + 1)	--start designation cylce
		end
	end



end

----- CustomDesignationAFAC -----
function CustomDesignationAFAC_OLD(afacFlightName, refX, refY, laserCode)
	

	-- local function distanceVisibilite(altitude)
	-- 	local k = 60 / math.sqrt(7620)  -- Coefficient basé sur la première donnée
	-- 	return k * math.sqrt(altitude)
	-- end

	local function distanceVisibilite(altitude_avion, altitude_terrain)
		-- Vérifie que l'altitude de l'avion est au-dessus du terrain
		if altitude_avion <= altitude_terrain then
			return 0  -- Si l'avion est au sol ou en dessous du terrain, il ne voit rien
		end

		local hauteur_effective = altitude_avion - altitude_terrain
		local k = 60000 / math.sqrt(7620)  -- Conversion en mètres (60 km -> 60000 m)

		return k * math.sqrt(hauteur_effective)
	end

	env.info("DCE_AFAC() AA : START "..tostring(afacFlightName))
	trigger.action.outText("AFAC : START "..tostring(afacFlightName), 15)

	local laser														--variable to hold the laser spot
	local smokeDuration = 300

	local flightGroup = Group.getByName(afacFlightName)
	local coalitionId = flightGroup:getCoalition()
	local unitsAFAC = flightGroup:getUnits()
	local unitAFAC = unitsAFAC[1]

	if unitAFAC and unitAFAC:isExist() then
		AFAC_available[afacFlightName] = {
				["unitAFAC"] = unitAFAC,
				-- ["gpGid"] = 0,
			}
			env.info("DCE_AFAC() AAb : unitAFAC:isExist "..tostring(afacFlightName))
	else
		AFAC_available[afacFlightName] = nil
		env.info("DCE_AFAC() AAc : else AFAC_available = nil "..tostring(afacFlightName))
	end

	local afacPosVec3 = unitAFAC:getPoint()
	local afacAlt = afacPosVec3.y
	local terrainAlt = land.getHeight({x = afacPosVec3.x, y = afacPosVec3.z})
	local distVisibility = distanceVisibilite(afacAlt, terrainAlt)
	-- env.info("DCE_AFAC() BB : afacFlightName "..tostring(afacFlightName).." afacAlt: "..tostring(afacAlt).." terrainAlt: "..tostring(terrainAlt).." distVisibility: "..tostring(distVisibility))

	--recupere les dynamique ****
	local groundGroups = coalition.getGroups(CoalitionIdToENI_Id[coalitionId], Group.Category.GROUND)
	local unitGroundSelected_A = {}
	local unitGroundSelected_B = {}

	for i, gp in pairs(groundGroups) do
		local gpName = Group.getName(gp)
		local groundUnits = gp:getUnits()

		for n=1, #groundUnits do

			local grndUnit = groundUnits[n]
			if  grndUnit:isActive()  then

				local description = grndUnit:getDesc()

				local life = description.life
				local unitPosVec3 = grndUnit:getPoint()
				-- local gpGid = Group.getID(gp)
				local UnitId = Unit.getID(grndUnit)
				-- local unitCallsign = grndUnit:getCallsign()
				local unitTypeName = grndUnit:getTypeName()

				local distance = math.floor(math.sqrt(math.pow(unitPosVec3.x - refX, 2) + math.pow(unitPosVec3.z - refY, 2)))

				if distance < distVisibility then

					local item = {
						unitGround = grndUnit,
						unitTypeName = unitTypeName,
						unitPosVec3 = unitPosVec3,
						desc = description,
						distance = distance,
						life = life,
						UnitId = UnitId,
						isStatic = false,

					}

					table.insert(unitGroundSelected_A, item)

				end
			end
		end
	end



	--recupere les static ****
	local statics = coalition.getStaticObjects(CoalitionIdToENI_Id[coalitionId])
	-- _affiche(statics, "DCE_AFAC () statics ")

	for _, static in pairs(statics) do
		local stName = Object.getName(static)

		local stLife = static:getLife()
		if stLife > 0 then

			local desc = static:getDesc()
			-- _affiche(desc , "CTS_desc ")

			--typeName: Camouflage04
			--["type"] = "Camouflage04",

			-- 2025-03-17 17:46:19.194 INFO    SCRIPTING (Main): DCE_AFAC() AA : START Pack 22 - 504th FAC - AFAC 1
			-- 2025-03-17 17:46:19.194 INFO    SCRIPTING (Main): DCE_AFAC() BB : afacFlightName Pack 22 - 504th FAC - AFAC 1 afacAlt: 593.51824187668 distVisibility: 16.745217794847
			-- 2025-03-17 17:46:19.198 INFO    SCRIPTING (Main): CTS_description life: 2
			-- 2025-03-17 17:46:19.198 INFO    SCRIPTING (Main): CTS_description _origin: Massun92-Assetpack
			-- 2025-03-17 17:46:19.198 INFO    SCRIPTING (Main): CTS_description category: 4
			-- 2025-03-17 17:46:19.198 INFO    SCRIPTING (Main): CTS_description displayName: M92 Camouflage 04
			-- 2025-03-17 17:46:19.198 INFO    SCRIPTING (Main): CTS_description typeName: Camouflage04
			-- 2025-03-17 17:46:19.198 INFO    SCRIPTING (Main): CTS_description box:
			-- 2025-03-17 17:46:19.198 INFO    SCRIPTING (Main): CTS_description   min:
			-- 2025-03-17 17:46:19.198 INFO    SCRIPTING (Main): CTS_description     y: -1
			-- 2025-03-17 17:46:19.198 INFO    SCRIPTING (Main): CTS_description     x: -7.0383772850037
			-- 2025-03-17 17:46:19.198 INFO    SCRIPTING (Main): CTS_description     z: -5.4064841270447
			-- 2025-03-17 17:46:19.198 INFO    SCRIPTING (Main): CTS_description   max:
			-- 2025-03-17 17:46:19.198 INFO    SCRIPTING (Main): CTS_description     y: 3.2793908119202
			-- 2025-03-17 17:46:19.198 INFO    SCRIPTING (Main): CTS_description     x: 7.0352449417114
			-- 2025-03-17 17:46:19.198 INFO    SCRIPTING (Main): CTS_description     z: 5.4133296012878
			-- 2025-03-17 17:46:19.198 INFO    SCRIPTING (Main): CTS_description life: 2

			local life = desc.life
			local unitPosVec3 = static:getPoint()
			local UnitId = static:getID()
			local unitTypeName = static:getTypeName()

			local distance = math.floor(math.sqrt(math.pow(unitPosVec3.x - refX, 2) + math.pow(unitPosVec3.z - refY, 2)))

			-- if category ~= "Fortifications" and distance < 50000 then
			if distance < distVisibility and not string.find(string.lower(desc.typeName) , "sandbag") then

				local lineOfSight = land.isVisible(afacPosVec3, unitPosVec3)

				if lineOfSight then
					local item = {
						unitGround = static,
						unitTypeName = unitTypeName,
						name = stName,
						unitPosVec3 = unitPosVec3,
						desc = desc,
						distance = distance,
						life = life,
						UnitId = UnitId,
						isStatic = true,

					}

					table.insert(unitGroundSelected_A, item)
				else
					-- env.info("DCE_AFAC () :EEc lineOfSight OFF  "..tostring(unitTypeName).." lineOfSight: "..tostring(lineOfSight))
				end

			end
		end
	end

	table.sort(unitGroundSelected_A, function(a,b) return a.distance < b.distance  end)

	for i = 1, 60 do
		table.insert(unitGroundSelected_B, unitGroundSelected_A[i])
	end
	unitGroundSelected_A = nil

	env.info("DCE_AFAC () :FF nb of unitGroundSelected_B: "..tostring(#unitGroundSelected_B))

	-- for _, target in pairs(unitGroundSelected_B) do
	-- 	_affiche(target, "DCE_AFAC () target_B.target ")
	-- end

	local actuelTarget = 0
	local designUnitId = 0


	local function designationCycle()							--laser/Smoke designation cycle function

		local timerDesignate = 0

		-- _affiche(AFAC_available, "DCE_AFAC () available ")

		-- if AFAC_available[afacFlightName] and AFAC_available[afacFlightName]["gpGid"] then
		-- 	env.info("DCE_AFAC () :GG1 ")
		-- 	trigger.action.outTextForGroup(AFAC_available[afacFlightName]["gpGid"],"AFAC : passe GG1", 15, false)	
		-- end


		if unitAFAC and unitAFAC:isExist() then

			local gpGid
			if AFAC_available[afacFlightName] and AFAC_available[afacFlightName]["gpGid"] then
				gpGid = AFAC_available[afacFlightName]["gpGid"]
			end
			--detecte si l'AFAC rentre:
			local distAFAC_Pattern = math.floor(math.sqrt(math.pow(afacPosVec3.x - refX, 2) + math.pow(afacPosVec3.z - refY, 2)))

			-- env.info("DCE_AFAC () :GG2 distAFAC_Pattern "..tostring(distAFAC_Pattern))
			-- trigger.action.outText("AFAC : passe GG2 distance: "..tostring(distAFAC_Pattern), 15)

			if distAFAC_Pattern < 150000 then

				for i, target in pairs(unitGroundSelected_B) do

					if i >= #unitGroundSelected_B then

						-- env.info("DCE_AFAC () :II plus aucune cible dans la table ")

						-- if AFAC_available[afacFlightName] and AFAC_available[afacFlightName]["gpGid"] then
						-- 	trigger.action.outTextForGroup(AFAC_available[afacFlightName]["gpGid"],"AFAC : plus aucune cible dans la table", 15, false)
						-- end

						if AFAC_available[afacFlightName] and AFAC_available[afacFlightName] then
							trigger.action.outTextForGroup(AFAC_available[afacFlightName],"AFAC : plus aucune cible dans la table", 15, false)
						end

						if laser and laser ~= nil  then
							laser:destroy()
							-- env.info("DCE_CustomLaserDesignation CustomDesignationAFAC ")
							designUnitId = 0
						end

						return

					elseif not target.isStatic and (not target.unitGround:isExist() or not target.unitGround:isActive() or target.unitGround:getLife() <= 0) then

						env.info("DCE_AFAC () cette cible notStatic est déjà détruite :JJa "..tostring(unitGroundSelected_B[i].unitTypeName).." "..tostring(unitGroundSelected_B[i].UnitId))

					elseif target.isStatic and (not Object.isExist(target.unitGround) or target.unitGround:getLife() <= 0) then

						env.info("DCE_AFAC () cette cible isStatic est déjà détruite :JJb "..tostring(unitGroundSelected_B[i].unitTypeName).." "..tostring(unitGroundSelected_B[i].UnitId))

					else

						if unitGroundSelected_B[i].UnitId == designUnitId then

							env.info("DCE_AFAC () :JJJ_2  meme cible "..tostring(unitGroundSelected_B[i].unitTypeName).." "..tostring(unitGroundSelected_B[i].UnitId) )

							if AFAC_available[afacFlightName] and AFAC_available[afacFlightName]["gpGid"] then

								trigger.action.outTextForGroup(AFAC_available[afacFlightName]["gpGid"],"AFAC Same Target : "..tostring(unitGroundSelected_B[i].unitTypeName).." laserCode: "..tostring(laserCode), 15, false)

								if unitGroundSelected_B[i].LLpos then
									trigger.action.outTextForGroup(AFAC_available[afacFlightName]["gpGid"],"AFAC Target Position: "..tostring(unitGroundSelected_B[i].LLpos), 15, false)
								end
							end

							break

						elseif unitGroundSelected_B[i].UnitId ~= designUnitId then
							-- nextTarget = i
							actuelTarget = i

							env.info("DCE_AFAC () :JJJ_3  nouvelle cible UnitId "..tostring(unitGroundSelected_B[i].unitTypeName).." "..tostring(unitGroundSelected_B[i].UnitId).." ~= ? designUnitId"..tostring(designUnitId))
							if AFAC_available[afacFlightName] and AFAC_available[afacFlightName]["gpGid"] then
								trigger.action.outTextForGroup(AFAC_available[afacFlightName]["gpGid"],"AFAC NEW Target : "..tostring(unitGroundSelected_B[i].unitTypeName), 15, false)
							end

							break
						else
							env.info("DCE_AFAC () :JJJ_4  ELSE BUG i "..i)
							-- _affiche(unitGroundSelected_B[i], "unitGroundSelected_B[i] bug ")
							trigger.action.outText("AFAC BUG detecté", 15)
							break
						end
					end


				end


				-- --TODO pour test seulement, à supprimer en prod
				-- if laser and laser ~= nil and unitGroundSelected_B[actuelTarget].UnitId and unitGroundSelected_B[actuelTarget].TimeLase and (unitGroundSelected_B[actuelTarget].TimeLase +120) > timer.getTime() then

				-- 	local nbActifTarget = {}
				-- 	for n, target in pairs(unitGroundSelected_B) do	
				-- 		if not target.isStatic and (not target.unitGround:isExist() or not target.unitGround:isActive() or target.unitGround:getLife() <= 0) then

				-- 		elseif target.isStatic and ( not Object.isExist(target.unitGround) or target.unitGround:getLife() <= 0) then

				-- 		else
				-- 			table.insert(nbActifTarget, n)
				-- 		end
				-- 	end

				-- 	if nbActifTarget and #nbActifTarget > 0 then
				-- 		for r = 1, 8 do
				-- 			local rand = math.random(1, #nbActifTarget)

				-- 			env.info("DCE_AFAC () r: "..r.." :rand A "..tostring(rand).." nbActifTarget[rand]: "..tostring(nbActifTarget[rand]))

				-- 			unitGroundSelected_B[nbActifTarget[rand]].unitGround:destroy()

				-- 			env.info("DCE_AFAC () :kill pour test B "..unitGroundSelected_B[nbActifTarget[rand]].UnitId)
				-- 			trigger.action.outText("AFAC kill pour test "..unitGroundSelected_B[nbActifTarget[rand]].UnitId, 15)
				-- 		end
				-- 	else
				-- 		env.info("DCE_AFAC () :kill pour test C "..unitGroundSelected_B[actuelTarget].UnitId)
				-- 		unitGroundSelected_B[actuelTarget].unitGround:destroy()
				-- 	end

				-- 	unitGroundSelected_B[actuelTarget].TimeLase = timer.getTime()
				-- end



				if unitAFAC then

					if unitGroundSelected_B[actuelTarget] and designUnitId == nil then
						local pos = unitGroundSelected_B[actuelTarget].unitPos

						if laserCode and laserCode ~= "nil" and laser == nil then
							laser = Spot.createLaser(unitAFAC, nil, pos, laserCode)	--start laser spot
						elseif laserCode == "nil" then
							trigger.action.smoke(pos, SmokeColor_TargetDesignation)
							timerDesignate = timer.getTime()
							env.info("DCE_AFAC () K create smokeColor.Red ")
							trigger.action.outTextForGroup(AFAC_available[afacFlightName][gpGid],"DCE_AFAC () K nextUnit create smokeColor.Red ", 15, false)
						end


						designUnitId = unitGroundSelected_B[actuelTarget].UnitId
						local LLposNstring, LLposEstring = LLtool.LLstrings(pos)
						local LLpos = ' N ' .. LLposNstring .. '   E ' .. LLposEstring
						unitGroundSelected_B[actuelTarget]["LLpos"] = LLpos
						unitGroundSelected_B[actuelTarget]["TimeLase"] = timer.getTime()

						if laserCode and laserCode ~= "nil" and gpGid then
							env.info("DCE_AFAC () : LL createLaser laserCode: "..tostring(laserCode))
							trigger.action.outTextForGroup(gpGid,"AFAC createLaser laserCode: "..tostring(laserCode), 30, false)
						end

						if gpGid then
							trigger.action.outTextForGroup(gpGid,"AFAC target position: "..tostring(LLpos), 30, false)
						end

					elseif unitGroundSelected_B[actuelTarget] and designUnitId ~= unitGroundSelected_B[actuelTarget].UnitId then

						local pos = unitGroundSelected_B[actuelTarget].unitPos

						if laserCode and laserCode ~= "nil" then
							laser:setPoint(pos)
						else
							trigger.action.smoke(pos, SmokeColor_TargetDesignation)
							timerDesignate = timer.getTime()
							env.info("DCE_AFAC () M create smokeColor.Red ")
							if gpGid then
								trigger.action.outTextForGroup(gpGid,"DCE_AFAC () M nextUnit create smokeColor.Red ", 15, false)
							end
						end

						designUnitId = unitGroundSelected_B[actuelTarget].UnitId

						local LLposNstring, LLposEstring = LLtool.LLstrings(pos)
						local LLpos = ' N ' .. LLposNstring .. '   E ' .. LLposEstring
						unitGroundSelected_B[actuelTarget]["LLpos"] = LLpos
						unitGroundSelected_B[actuelTarget]["TimeLase"] = timer.getTime()

						env.info("DCE_AFAC () : LL setPoint laserCode: "..tostring(laserCode))

						if gpGid then
							if laserCode and laserCode ~= "nil" then
								trigger.action.outTextForGroup(gpGid,"AFAC setPoint laserCode: "..tostring(laserCode), 30, false)
							end
							trigger.action.outTextForGroup(gpGid,"AFAC target position: "..tostring(LLpos), 30, false)
						end
					end
				end



			else --if distAFAC_Pattern < 150000 then

				-- _affiche(unitAFAC, "unitAFAC ")
				env.info("DCE_AFAC () :ZZ  Reaper  Trop loin, fin du laser distAFAC_Pattern > 150km? "..tostring(distAFAC_Pattern))
				if gpGid then
					trigger.action.outTextForGroup(gpGid,"AFAC DCE_CD_AFAC() :ZZ  AFAC Trop loin, fin du laser distAFAC_Pattern > 150km? "..tostring(distAFAC_Pattern), 15, false)
				end
				if laser and laser ~= nil  then
					laser:destroy()
					designUnitId = 0

					env.info("DCE_AFAC () :ZZ2  laser:destroy	 ")

				end
			end

		else	--if unitAFAC and unitAFAC:isExist()  then


			env.info("DCE_AFAC () :ZZ  Reaper Dead  ")
			if AFAC_available[afacFlightName] and AFAC_available[afacFlightName]["gpGid"] then
				trigger.action.outTextForGroup(AFAC_available[afacFlightName]["gpGid"],"AFAC DCE_CD_AFAC() :ZZ  Reaper Dead or not isExist ", 15, false)
			end
			if laser and laser ~= nil  then
				laser:destroy()
				designUnitId = 0
				env.info("DCE_AFAC () :ZZ2  laser:destroy	 ")
			end

			if AFAC_available[afacFlightName]  then
				env.info("DCE_AFAC () :ZZ3 AFAC_available = nil "..tostring(afacFlightName))
				AFAC_available[afacFlightName] = nil
			end
			return

		end



		if laser and laser ~= nil then											--if there is a new laser spot
			env.info("DCE_AFAC () :Z return Laser timer  ")
			return timer.getTime() + 60							--repeat designation cylce in 60 seconds										--stop designation cycle
		end

		if timer.getTime() > timerDesignate + smokeDuration then
			env.info("DCE_AFAC () :Z return smoke timer  ")
			return timer.getTime() + 60
		end
	end

	timer.scheduleFunction(designationCycle, nil, timer.getTime() + 15)	--start designation cylce

	env.info("DCE_CustomDesignationAFAC : FIN "..tostring(afacFlightName))
	trigger.action.outText("AFAC : FIN "..tostring(afacFlightName), 15)

end


-----************** CustomDesignationAFAC ************-----
-----************** CustomDesignationAFAC ************-----
------************** CustomDesignationAFAC ************-----
---	-- Contient toutes les unités sol par coalition
-- AFAC_groundCache = {
-- 	[1] = {}, -- RED
-- 	[2] = {}, -- BLUE
-- }

AFAC_lastCacheUpdate = 0
AFAC_CACHE_PERIOD = 600 -- secondes entre 2 reconstructions
AFAC_MaxRange = 10000 -- portée max de détection des cibles par l'AFAC

-- Empêche les AFAC de relancer une désignation trop souvent
AFAC_lastRun = {}   -- [afacName] = time
AFAC_isRunning = {} -- [afacName] = true/false
AFAC_COOLDOWN = 120 -- secondes entre 2 désignations (120)

AFAC_RouteCache = {} -- [afacName] = stationRoutePart

-- Taille d’une cellule en mètres
AFAC_GRID_SIZE = 10000 -- 10 km

-- Cache spatial
AFAC_groundGrid = {}
AFAC_groundGridStamp = -math.huge

AFAC_DEBUG_FORCE_KILL = false -- true pour activer
AFAC_DEBUG_KILL_PERIOD = 35   -- secondes
AFAC_DEBUG_lastKill = {}



local function afacGetCell(x)
    return math.floor(x / AFAC_GRID_SIZE)
end

-- AFAC_UpdateGroundCache()
-- Sert à reconstruire périodiquement la liste des unités sol et statics pour AFAC
-- Pourquoi : remplacer coalition.getGroups() + getStaticObjects() dans CustomDesignationAFAC()
function AFAC_UpdateGroundCache()

	local now = timer.getTime()
	if now - AFAC_groundGridStamp < AFAC_CACHE_PERIOD then
		return
	end
	AFAC_groundGridStamp = now

	AFAC_groundGrid = {}

	for side = 1, 2 do
		local groups = coalition.getGroups(side, Group.Category.GROUND)
		for _, group in ipairs(groups) do
			local units = group:getUnits()
			for _, unit in ipairs(units) do
				if unit:isExist() then
					local p = unit:getPoint()
					local cx = afacGetCell(p.x)
					local cy = afacGetCell(p.z)

					AFAC_groundGrid[cx] = AFAC_groundGrid[cx] or {}
					AFAC_groundGrid[cx][cy] = AFAC_groundGrid[cx][cy] or {}

					AFAC_groundGrid[cx][cy][#AFAC_groundGrid[cx][cy] + 1] = {
						unit = unit,
						x = p.x,
						y = p.z,
                        alt = p.y,
						side = side
					}
				end
			end
		end
	end

	if campL.debug then
		local logStr = "AFAC_groundGrid = " .. TableSerialization(AFAC_groundGrid, 0)
		local logFile = io.open(PathDCE .. "Debug\\AFAC_groundGrid.lua", "w")
		if logFile then
			logFile:write(logStr)
			logFile:close()
		else
			env.info("DCE_AFAC : Failed to open log AFAC_groundGrid file for writing.")
		end
	end


end



function AFAC_DebugTick(afacName, flagName)
    if not AFAC_DEBUG_FORCE_KILL then return end

    local t = timer.getTime()
    local last = AFAC_DEBUG_lastKill[afacName] or 0

    if t - last > AFAC_DEBUG_KILL_PERIOD then
        AFAC_DEBUG_lastKill[afacName] = t
        trigger.action.setUserFlag(flagName, 1)
        env.info("DCE_AFAC DEBUG : fake target destroyed for " .. afacName)
    end
end

local function extractStationPart(route)
	for i = 1, #route do
		if route[i].briefing_name == "Station" then
			local t = {}
			for j = i, #route do
				t[#t + 1] = route[j]
			end
			return t
		end
	end
	return nil
end


local function distanceVisibilite(altitude_avion, altitude_terrain)
	-- Vérifie que l'altitude de l'avion est au-dessus du terrain
	if altitude_avion <= altitude_terrain then
		return 0  -- Si l'avion est au sol ou en dessous du terrain, il ne voit rien
	end

	local hauteur_effective = altitude_avion - altitude_terrain
	local k = 60000 / math.sqrt(7620)  -- Conversion en mètres (60 km -> 60000 m)

	return k * math.sqrt(hauteur_effective)
end

function CustomDesignationAFAC(afac_Name, refX, refY, laserCode)

	local now = timer.getTime()

	-- Si l'AFAC est déjà en train de gérer un target, on bloque
	if AFAC_isRunning[afac_Name] then
		return
	end

	-- Cooldown temporel
	if AFAC_lastRun[afac_Name] and (now - AFAC_lastRun[afac_Name]) < AFAC_COOLDOWN then
		return
	end

	-- On verrouille cet AFAC (SEULEMENT après avoir passé le cooldown)
	AFAC_isRunning[afac_Name] = true
	AFAC_lastRun[afac_Name] = now


	-- Met à jour le cache AFAC si nécessaire
	-- Pourquoi : éviter de rescanner la carte à chaque appel AFAC
	AFAC_UpdateGroundCache()
	

	local laser														--variable to hold the laser spot
	local flightGroup = Group.getByName(afac_Name)
	local coalitionId = flightGroup:getCoalition()
	local unitsAFAC = flightGroup:getUnits()
	local unitAFAC = unitsAFAC[1]

	if unitAFAC and unitAFAC:isExist() then

		coalitionId = unitAFAC:getCoalition()

		AFAC_available[afac_Name] = {
				["unitAFAC"] = unitAFAC,
				["sideNum"] = coalitionId,
			}

	else
		AFAC_available[afac_Name] = nil
		return
	end

	local afacPosVec3 = unitAFAC:getPoint()
	local afacAlt = afacPosVec3.y
	-- local terrainAlt = land.getHeight({x = afacPosVec3.x, y = afacPosVec3.z})
	-- local distVisibility = distanceVisibilite(afacAlt, terrainAlt)

	-- local unitGroundSelected_A = {}
	local unitGroundSelected_B = {}

	local ax = afacPosVec3.x
	local ay = afacPosVec3.z
	local range = AFAC_MaxRange
	local cellRadius = math.ceil(range / AFAC_GRID_SIZE)

	local cx = afacGetCell(ax)
	local cy = afacGetCell(ay)

	local range2 = range * range
	local best = {}
	local bestCount = 0
	local MAX_PRESELECT = 50   -- ne jamais dépasser


	for gx = cx - cellRadius, cx + cellRadius do
		local col = AFAC_groundGrid[gx]
		if col then
			for gy = cy - cellRadius, cy + cellRadius do
				local cell = col[gy]
				if cell then
					for ic = 1, #cell do
						local u = cell[ic]

						if u.side ~= coalitionId then

							local dx = u.x - ax
							local dy = u.y - ay
							local dist2 = dx*dx + dy*dy

							if dist2 < range2 then
								bestCount = bestCount + 1
								best[bestCount] = { u = u, d2 = dist2 }

								if bestCount > MAX_PRESELECT then
									-- on jette le plus loin
									local worst = 1
									for k = 2, bestCount do
										if best[k].d2 > best[worst].d2 then
											worst = k
										end
									end
									best[worst] = best[bestCount]
									bestCount = bestCount - 1
								end
							end
						end
					end
				end
			end
		end
	end

	for i = 1, bestCount do
		local u = best[i].u
		local obj = u.unit

		local unitPosVec3 = { x = u.x, y = u.alt, z = u.y }

		if land.isVisible(afacPosVec3, unitPosVec3) then
			local desc = obj:getDesc()
			if desc then
				local typeName = desc.typeName or ""
				if not string.find(typeName:lower(), "sandbag") then
					unitGroundSelected_B[#unitGroundSelected_B+1] = {
						unitGround = obj,
						unitTypeName = typeName,
						unitPosVec3 = unitPosVec3,
						desc = desc,
						distance = math.sqrt(best[i].d2),
						life = desc.life or 0,
						UnitId = obj:getID(),
						isStatic = (Object.getCategory(obj) == Object.Category.STATIC),
					}
				end
			end
		end
	end

	-- env.info("DCE_AFAC() DCE_INFO #unitGroundSelected_B " .. tostring(#unitGroundSelected_B))

	--**** choisi THE target ^^ ****
	local target = next(unitGroundSelected_B) and unitGroundSelected_B[next(unitGroundSelected_B)] or nil

	if not target then
		-- Libère le verrou si aucune cible trouvée
		AFAC_isRunning[afac_Name] = false
		return
	end

	-- set la partie FLAG du target pour suivre son etat et déclencher l'arret de l orbit et le passage au target suivant
	trigger.action.setUserFlag("targetDestroyed_Flag_"..target.UnitId, 0)
	AFAC_targetStatus[target.UnitId] = target

	local gpGid
	if AFAC_available[afac_Name] and AFAC_available[afac_Name]["gpGid"] then
		gpGid = AFAC_available[afac_Name]["gpGid"]
	end

	local targetPosVec3 = target.unitPosVec3

	if laserCode and laserCode ~= "nil" and laser == nil then
		-- env.info("DCE_AFAC () : J createLaser laserCode: "..tostring(arg_LaserCode))
		laser = Spot.createLaser(unitAFAC, nil, targetPosVec3, laserCode)	--start laser spot
	else
		trigger.action.smoke(targetPosVec3, SmokeColor_TargetDesignation)
		-- env.info("DCE_AFAC () K create smokeColor.Red ")

		AFAC_available[afac_Name]["smokeData"] = {
			time = timer.getTime(),
			targetPosVec3 = targetPosVec3,
			sideNum = coalitionId,
		}

	end

	local LLposNstring, LLposEstring = LLtool.LLstrings(targetPosVec3)
	local LLpos = ' N ' .. LLposNstring .. '   E ' .. LLposEstring
	target["LLpos"] = LLpos

	if gpGid then
		if laserCode and laserCode ~= "nil"  then
			trigger.action.outTextForGroup(gpGid,"AFAC createLaser laserCode: "..tostring(laserCode), 30, false)
		end

		if target.LLpos then
			trigger.action.outTextForGroup(gpGid,"AFAC Target Position: "..tostring(target.LLpos), 30, false)
		end
	end


	--************///////////////////////////////////////////////////////////////////////////////////////////////////////////////
	local ctr = flightGroup:getController() -- Récupère le contrôleur du GROUPE (sinon, l injectrion de task sur l unit leader fait planter DCS)
	local descAfac = unitAFAC:getDesc()


	if not AFAC_RouteCache[afac_Name] then
		local group = MissGroupByName[afac_Name]
		if group then
			AFAC_RouteCache[afac_Name] = extractStationPart(group.route.points) or {}
		end
	end

	local modFPlan = Deepcopy(AFAC_RouteCache[afac_Name])

    if not modFPlan then
		return
	end

	local targetDestroyed_Flag = "targetDestroyed_Flag_"..target.UnitId
	local current_time = timer.getTime()

	local new_way = {
		[1] = {
			['y'] = afacPosVec3.z,
			['x'] = afacPosVec3.x,
			['speed'] = descAfac.speedMax * 2/3,
			['action'] = 'Turning Point',
			['alt'] = afacPosVec3.y,

			['type'] = 'Turning Point',
			['alt_type'] = 'BARO',
			['speed_locked'] = true,
			['formation_template'] = '',
			['ETA_locked'] = true,
			["name"] = "AFAC_WPT1",
			['ETA'] = current_time + 1,
			['task'] = {
				['id'] = 'ComboTask',
				['params'] = {
					['tasks'] = {
						[1] =
						{
							["auto"] = true,
							["enabled"] = true,
							["id"] = "WrappedAction",
							["name"] = "INTERDIRE emergency jettison: TRUE (Departure/Spawn)",
							["number"] = 1,
							["params"] =
							{
								["action"] =
								{
									["id"] = "Option",
									["params"] =
									{
										["name"] = 15,
										["value"] = true,
									},
								},
							},
						},
						[2] =
						{
							["auto"] = true,
							["enabled"] = true,
							["id"] = "WrappedAction",
							["name"] = "reaction to threats  avoidance of fire (Departure/Spawn)",
							["number"] = 2,
							["params"] =
							{
								["action"] =
								{
									["id"] = "Option",
									["params"] =
									{
										["name"] = 1,
										["value"] = 2,
									},
								},
							},
						},
						-- [3] = 
						-- {
						-- 	["auto"] = true,
						-- 	["enabled"] = false,
						-- 	["id"] = "FAC",
						-- 	["number"] = 3,
						-- 	["params"] = 
						-- 	{
						-- 		["callname"] = 1,
						-- 		["datalink"] = true,
						-- 		-- ["designation"] = "Auto",
						-- 		["frequency"] = 267000000,
						-- 		["modulation"] = 0,
						-- 		["number"] = 4,
						-- 	},
						-- },
					},
				},
			},
		},
		[2] = {
			['alt'] = afacPosVec3.y,
			['type'] = 'Turning Point',
			['action'] = 'Turning Point',
			['alt_type'] = 'BARO',
			['speed_locked'] = true,
			['y'] = targetPosVec3.z ,
			['x'] = targetPosVec3.x ,
			['formation_template'] = '',
			['speed'] = descAfac.speedMax * 2/3,
			['ETA_locked'] = false,
			["name"] = "AFAC_WPT2",
			["task"] =
			{
				["id"] = "ComboTask",
				["params"] =
				{
					["tasks"] =
					{
						[1] =
						{
							["number"] = 1,
							["auto"] = false,
							["id"] = "WrappedAction",
							["name"] = "partie script",
							["enabled"] = true,
							["params"] =
							{
								["action"] =
								{
									["id"] = "Script",
									["params"] =
									{
										-- ["command"] = "env.info(\"DCE_AFAC_Mission WPT2 C \")",
										["command"] = "AFAC_DebugTick('"..afac_Name.."','"..targetDestroyed_Flag.."')",

									}, -- end of ["params"]
								}, -- end of ["action"]
							}, -- end of ["params"]
						}, -- end of [1]
						[2] =
						{
							["number"] = 2,
							["auto"] = false,
							["id"] = "ControlledTask",
							["name"] = "orbit Ancre marqueur 222 est on",
							["enabled"] = true,
							["params"] =
							{
								-- ["task"] =
								-- {
								-- 	["id"] = "Orbit",
								-- 	["params"] =
								-- 	{
								-- 		["altitude"] = afacPos.y,
								-- 		["pattern"] = "Circle",
								-- 		["speed"] = descAfac.speedMax * 2/3,
								-- 		["speedEdited"] = true,
								-- 	}, -- end of ["params"]
								-- }, -- end of ["task"]
								-- ["stopCondition"] =
								-- {
								-- 	["duration"] = 300,
								-- }, -- end of ["stopCondition"]

								["task"] =
								{
									["id"] = "Orbit",
									["params"] =
									{
										["altitude"] = afacPosVec3.y,
										["pattern"] = "Anchored",
										["hotLegDir"] = 2.6354471705114,
										["speed"] = descAfac.speedMax * 2/3,
										["legLength"] = 5550,
										["clockWise"] = true,
										["width"] = 1850,
									}, -- end of ["params"]
								}, -- end of ["task"]
								["stopCondition"] =
								{
									["userFlag"] = targetDestroyed_Flag,
									["userFlagValue"] = true,
								}, -- end of ["stopCondition"]
							}, -- end of ["params"]
						},
						[3] =
						{
							["number"] = 3,
							["auto"] = false,
							["id"] = "WrappedAction",
							["name"] = "partie script",
							["enabled"] = true,
							["params"] =
							{
								["action"] =
								{
									["id"] = "Script",
									["params"] =
									{
										["command"] = "env.info(\"DCE_AFAC_Mission WPT2 D \")",
									}, -- end of ["params"]
								}, -- end of ["action"]
							}, -- end of ["params"]
						}, -- end of [1]
					},
				},
			},

			['ETA'] = current_time + 60,
		},
		[3] = {
			['alt'] = afacPosVec3.y,
			['type'] = 'Turning Point',
			['action'] = 'Turning Point',
			['alt_type'] = 'BARO',
			['speed_locked'] = true,
			['y'] = tonumber(refY) ,
			['x'] = tonumber(refX) ,
			['formation_template'] = '',
			['speed'] = descAfac.speedMax * 2/3,
			['ETA_locked'] = false,
			['ETA'] = current_time + 300,
			["name"] = "AFAC_WPT3",
			["task"] =
			{
				["id"] = "ComboTask",
				["params"] =
				{
					["tasks"] =
					{
						[1] =
						{
							["number"] = 1,
							["auto"] = false,
							["id"] = "WrappedAction",
							["name"] = "partie script",
							["enabled"] = true,
							["params"] =
							{
								["action"] =
								{
									["id"] = "Script",
									["params"] =
									{
										-- ["command"] = "env.info(\"DCE_AFAC_Mission WPT3 Ea getUserFlag \"..trigger.misc.getUserFlag( "..targetDestroyed_Flag.. ")\")",
										["command"] = "env.info(\"DCE_AFAC_Mission WPT3 Ea getUserFlag \" .. trigger.misc.getUserFlag(\""..targetDestroyed_Flag.. "\"))",
									}, -- end of ["params"]
								}, -- end of ["action"]
							}, -- end of ["params"]
						}, -- end of [1]




						[2] =
						{
							["number"] = 2,
							["auto"] = false,
							["id"] = "WrappedAction",
							["name"] = "partie script",
							["enabled"] = true,
							["params"] =
							{
								["action"] =
								{
									["id"] = "Script",
									["params"] =
									{
										["command"] = "env.info(\"DCE_AFAC_Mission WPT3 Eb \")",
									}, -- end of ["params"]
								}, -- end of ["action"]
							}, -- end of ["params"]
						}, -- end of [1]
						[3] =
						{
							["auto"] = false,
							["enabled"] = true,
							["id"] = "WrappedAction",
							["number"] = 3,
							["params"] =
							{
								["action"] =
								{
									["id"] = "Script",
									["params"] =
									{
										--afacFlightName, refX, refY
										["command"] = "CustomDesignationAFAC('" .. afac_Name .. "', '" .. refX .. "', '" .. refY .. "',  'nil')",
									},
								},
							},
						},
						[4] =
						{
							["number"] = 4,
							["auto"] = false,
							["id"] = "WrappedAction",
							["name"] = "partie script",
							["enabled"] = true,
							["params"] =
							{
								["action"] =
								{
									["id"] = "Script",
									["params"] =
									{
										["command"] = "env.info(\"DCE_AFAC_Mission WPT3 F \")",
									}, -- end of ["params"]
								}, -- end of ["action"]
							}, -- end of ["params"]
						}, -- end of [1]
					},
				},
			},

		},

	}

	local newRoute = {} -- Nouvelle table

	-- Ajouter les éléments de new_way en premier
	for j = 1, #new_way do
		newRoute[j] = new_way[j]
	end

	-- ajoute les anciens wpt aux nouveau
	local startIndex = #new_way +1
	for _, v in ipairs(modFPlan) do
		newRoute[startIndex] = v
		startIndex = startIndex + 1
	end


	-- recalcul les ETA
	local i = 1
	while newRoute[i] do

		if i >= 5 then  -- Arrêter la boucle après le 3ème enregistrement
			break
		end

		if i >= 2 then
			local deltaTime = newRoute[i]["ETA"] - newRoute[i-1]["ETA"]
			local deltaDist = GetDistance(
				{x = newRoute[i].x, y = newRoute[i].y },
				{x = newRoute[i-1].x, y = newRoute[i-1].y }
			)

			local eta_Minimum
			if deltaDist and descAfac.speedMax then
				eta_Minimum = deltaDist / (descAfac.speedMax * 2/3)
			else
				-- Sortir uniquement de la boucle, mais pas de la fonction
				env.info("DCE_AFAC () passe O6 DCE_ERROR BREAK ")
				break
			end

			if eta_Minimum and deltaTime < eta_Minimum then
				newRoute[i]["ETA"] = newRoute[i-1]["ETA"] + eta_Minimum + 300
			end
		end

		i = i + 1
	end


	local newMission = {
			id = 'Mission',
			params = {
				airborne = true,
				route = {
					points = newRoute
				},
			}
		}

	-- if campL.debug then
	-- 	local logStr = "afac = " .. TableSerialization(newMission, 0)
	-- 	local flightNameClean = afac_Name:gsub('[%p%c%s]', '_')
	-- 	local logFile = io.open(PathDCE.."Debug\\"..flightNameClean.."_AFAC_"..current_time..".lua", "w")
	-- 	if logFile then
	-- 		logFile:write(logStr)
	-- 		logFile:close()
	-- 	else
	-- 		env.info("DCE_AFAC : Failed to open log file for writing.")
	-- 	end
	-- end

	ctr:resetTask() 			-- Efface les tâches existantes
	ctr:setTask(newMission)

	-- LastInjectAFAC[afac_Name] = timer.getTime() 	--update last injection time

	-- Libère l'AFAC pour la prochaine désignation
	AFAC_isRunning[afac_Name] = false

end


function CustomSearchThenEngage(groupName, radius, targetType, searchTime)
	
	-- simple, friendly version with a small cache to avoid calling getDesc()/getPlayerName() every loop
	
	local MIN_SEARCH_RADIUS = 30000
	local HELICOPTER_ZONE_RADIUS = 15000
	local ENGAGE_DURATION = 25	--50
	local RECHECK_INTERVAL = 30	--60
	local CACHE_TTL = 60 -- seconds: don't re-call heavy APIs more often than this

	radius = tonumber(radius) or MIN_SEARCH_RADIUS
	if radius < MIN_SEARCH_RADIUS then radius = MIN_SEARCH_RADIUS end

	if CustomSearchThenEngageActive == nil then CustomSearchThenEngageActive = {} end
	if CustomSearchThenEngageActive[groupName] then
		-- env.info("DCE_CustomSearchThenEngage: already active for " .. tostring(groupName))
		return
	end
	CustomSearchThenEngageActive[groupName] = true

	-- per-unit cache kept by the closure
    local unitCache = {} -- unitId -> { playerName, desc, lastUpdate }
	
	-- cache de l'unité active (évite getUnits() en boucle)
	local activeUnit = nil
	
	-- cache état et position
	local lastAirCheck = 0
	local lastInAir = false

	local lastPosTime = 0
	local lastPos = nil

	local AIR_CHECK_INTERVAL = 10
	local POSITION_UPDATE_INTERVAL = 20

	-- Rafraîchit le cache d'une unité (infos statiques + joueur)
	-- Objectif : éviter pcall() et appels DCS coûteux répétés
	local function refreshUnitCache(u)

		-- garde-fous DCS suffisants (pcall inutile ici)
		if not u or not u.isExist or not u:isExist() then return nil end

		local id = u:getID()
		if not id then return nil end

		local now = timer.getTime()
		local c = unitCache[id]

		if not c then
			c = { static = false, dynamic = false }
			unitCache[id] = c
		end

		-- ===== STATIC (getDesc) : une seule fois par unité =====
		if c.static == false then
			local desc = u:getDesc()
			c.static = desc or nil
		end

		-- ===== DYNAMIC (playerName) : une seule fois =====
		if c.dynamic == false then
			local pname = u:getPlayerName()
			c.dynamic = pname or nil
		end

		return {
			playerName = c.dynamic,
			desc = c.static,
			lastUpdate = now
		}
	end


	local function buildTask(isHelo, x, y, rad)
		local zone = isHelo and HELICOPTER_ZONE_RADIUS or rad
		return {
			id = 'ControlledTask',
			params = {
				task = {
					enabled = true,
					auto = false,
					id = 'EngageTargetsInZone',
					number = 1,
					params = {
						targetTypes = { targetType },
						x = x,
						y = y,
						priority = 0,
						zoneRadius = zone,
					}
				},
				stopCondition = { duration = ENGAGE_DURATION }
			}
		}
	end

	-- retourne l'unité active sans rescanner si possible
	local function getActiveUnit(flight)
		if activeUnit then
			if activeUnit:isExist() and activeUnit:isActive() then
				return activeUnit
			end
			activeUnit = nil
		end

		local units = flight:getUnits()
		for i = 1, #units do
			local u = units[i]
			if u and u:isExist() and u:isActive() then
				activeUnit = u
				return u
			end
		end

		return nil
	end

	-- loop called by timer
    local function loop(_, t)
		
        local next_time = nil
        local flight = Group.getByName(groupName)

        if flight and type(flight.isExist) == 'function' and flight:isExist() then

			local element = getActiveUnit(flight)

            if element then
                -- if group is landing stop the loop
                if SatusGroupAircraft and SatusGroupAircraft[groupName] and SatusGroupAircraft[groupName]["landing"] then
                    -- env.info("DCE_CustomSearchThenEngage RETURN landing " .. tostring(groupName))
                    CustomSearchThenEngageActive[groupName] = nil
                    next_time = nil
                else
                   local now = timer.getTime()

					if now - lastAirCheck > AIR_CHECK_INTERVAL then
						lastInAir = element:inAir()
						lastAirCheck = now
					end

					if lastInAir then

                        -- refresh cached infos (playerName, desc) but cache limits calls
                        local cached = refreshUnitCache(element)
                        if not (cached and cached.playerName) then
                            local cntrl = flight:getController()
                            if cntrl then
                                -- local pos = element:getPoint()
								if not lastPos or (now - lastPosTime > POSITION_UPDATE_INTERVAL) then
									lastPos = element:getPoint()
									lastPosTime = now
								end

                                local pos = lastPos
								local elementId = element:getID()
								local catEntry = elementId and Cache_UnitCategoryByGetID[elementId]
								local isHelo = (catEntry and catEntry.category == Unit.Category.HELICOPTER)
                                local task = buildTask(isHelo, pos.x, pos.z, radius)

								if isHelo then
									env.info("DCE_CustomSearchThenEngage: isHelo: " .. tostring(groupName))
								end

                                cntrl:setOption(AI.Option.Air.id.PROHIBIT_AG, true)
                                local okPush, errPush = pcall(function() cntrl:pushTask(task) end)
                                if not okPush then
                                    env.info("DCE_CustomSearchThenEngage: pushTask failed: " .. tostring(errPush))
                                end

                                next_time = t + RECHECK_INTERVAL
                            else
                                next_time = t + RECHECK_INTERVAL
                            end
                        else
                            -- player onboard, recheck later
                            next_time = t + RECHECK_INTERVAL
                        end
                    else
                        -- not in air, recheck later
                        next_time = t + RECHECK_INTERVAL
                    end
                end
            else
                -- no active element found, recheck later
                next_time = t + RECHECK_INTERVAL
            end
        else
            -- flight gone -> cleanup
            CustomSearchThenEngageActive[groupName] = nil
            next_time = nil
        end

		return next_time
    end
	
	timer.scheduleFunction(loop, nil, timer.getTime() + 1)
end



local MAX_INTERCEPT_RANGE = 100000 -- mètres
local REEVAL_INTERVAL = 15
local interceptorsActive = {}
local groupTargetMemory = {}
-- local callSign = Unit.getCallsign(interUnitObj)
-- local gpGid = Group.getID(interGroupObj)

-- if BingoPlaneTab[gpGid] and BingoPlaneTab[gpGid][callSign] then
-- 	return
-- end

function CustomIntercept(argTargetName, argInterName, argFriendSide, argSpeed, argPosX, argPosY)
	
	-- Mémoire d'état (CAP / INTERCEPT) pour éviter de réinjecter les missions inutilement
	GroupStateMemory = GroupStateMemory or {}

	local interGroupObj = Group.getByName(argInterName)
	if not interGroupObj or not interGroupObj:isExist() then
		interceptorsActive[argInterName] = nil
		groupTargetMemory[argInterName] = nil
		return
	end

	local interUnitObj = interGroupObj:getUnit(1)
	if not interUnitObj or not interUnitObj:isExist() then
		interceptorsActive[argInterName] = nil
		groupTargetMemory[argInterName] = nil
		return
	end

	-- -- Si l'avion est posé, inutile de continuer
    -- if not interUnitObj:inAir() then
    --     if campL.debug then
    --         env.info("DCE_Custom_Intercept A : " .. argInterName .. " has landed — stopping logic.")
    --     end
		
	-- 	interceptorsActive[argInterName] = nil
	-- 	groupTargetMemory[argInterName] = nil
	-- 	GroupStateMemory[argInterName] = nil
	-- 	return
	-- end

	-- Si l'avion est réellement posé (et pas en phase de décollage), inutile de continuer
	local vel = interUnitObj:getVelocity()
	local speed = math.sqrt(vel.x * vel.x + vel.y * vel.y + vel.z * vel.z)
	local alt = interUnitObj:getPoint().y

	-- seuils tolérants pour éviter faux négatif au décollage
	if not interUnitObj:inAir() and speed < 50 and alt < 5 then
        if campL.debug then
            env.info("DCE_Custom_Intercept A : " .. argInterName .. " has landed — stopping logic.")
        end
		
		interceptorsActive[argInterName] = nil
		groupTargetMemory[argInterName] = nil
		GroupStateMemory[argInterName] = nil
		return
	end

	local friendCoalition = (argFriendSide == "red") and coalition.side.RED or coalition.side.BLUE
	local enemyCoalition = (friendCoalition == coalition.side.RED) and coalition.side.BLUE or coalition.side.RED
	local enemyGroups = coalition.getGroups(enemyCoalition)
    if not enemyGroups then
        return
	end

	local interPos = interUnitObj:getPoint()
	local bestTarget, bestScore = nil, math.huge

	local lastTarget = groupTargetMemory[argInterName]
	if lastTarget and lastTarget:isExist() then
		local tgtUnit = lastTarget:getUnit(1)
		if tgtUnit and tgtUnit:isExist() and tgtUnit:inAir() then
			local tgtPos = tgtUnit:getPoint()
			local dx, dz = tgtPos.x - interPos.x, tgtPos.z - interPos.z
			local dist = math.sqrt(dx * dx + dz * dz)
			if dist < 10000 then
				bestTarget = lastTarget
				if campL.debug then
					env.info("DCE_Custom_Intercept: " ..argInterName .. " still engaging " .. lastTarget:getName() .. " (" .. math.floor(dist) .. "m)")
				end
			end
		else
			-- cible morte ou invalide → purge mémoire
			groupTargetMemory[argInterName] = nil
		end
	end

	if not bestTarget then
		for _, group in pairs(enemyGroups) do
			local unit = group:getUnit(1)
			if unit and unit:isExist() and unit:inAir() then
				local p = unit:getPoint()
				local v = unit:getVelocity()
				local dx, dz = p.x - interPos.x, p.z - interPos.z
				local dist2 = dx * dx + dz * dz
				if dist2 < (MAX_INTERCEPT_RANGE * MAX_INTERCEPT_RANGE) then
					local dist = math.sqrt(dist2)
					local dot = dx * v.x + dz * v.z
					local approaching = dot < 0
					local score = approaching and dist * 0.6 or dist
					if score < bestScore then
						bestTarget, bestScore = group, score
					end
				end
			end
		end
	end

    local ctr = interGroupObj:getController()
	
	local fuel = interUnitObj:getFuel()
	local desc = interUnitObj:getDesc()

    if campL.debug then
        env.info(string.format(
            "DEBUG %s | inAir=%s | speed=%.1f | fuel=%.2f | state=%s | target=%s",
            argInterName,
            tostring(interUnitObj:inAir()),
            math.sqrt(interUnitObj:getVelocity().x ^ 2 + interUnitObj:getVelocity().z ^ 2),
            fuel or -1,
            tostring(GroupStateMemory[argInterName]),
            tostring(groupTargetMemory[argInterName] and groupTargetMemory[argInterName]:getName() or "nil")
        ))
    end


	if bestTarget then
		local sameTarget = (groupTargetMemory[argInterName] == bestTarget)
		local newTargetName = bestTarget:getName()

        -- if not sameTarget then
		if not sameTarget or GroupStateMemory[argInterName] ~= "INTERCEPT" then
            GroupStateMemory[argInterName] = "INTERCEPT"
			
			if campL.debug then
				env.info("DCE_Custom_Intercept C : " .. argInterName .. " switching to new target " .. newTargetName)
			end
			-- ctr:resetTask() --si on utilise ceci, il faut ensuite coller une mission 

			timer.scheduleFunction(function()
				if interGroupObj and interGroupObj:isExist() then
					local targetGpId = bestTarget:getID()
					local weaponType = 1069547520
					local interceptTask = {
						id = 'EngageGroup',
						params = {
							visible = false,
							groupId = targetGpId,
							priority = 1,
							weaponType = weaponType,
						},
					}
					local ctr2 = interGroupObj:getController()
					if ctr2 then
						ctr2:pushTask(interceptTask)
						
                        if campL.debug then
                            env.info("DCE_Custom_Intercept B : " ..
                            argInterName .. " engaging " .. tostring(newTargetName))
                            local current_time = timer.getTime()
                            local logStr = "params = " .. TableSerialization(interceptTask, 0)
                            local flightNameClean = argInterName:gsub('[%p%c%s]', '_')
                            local logFile = io.open(
                                PathDCE .. "Debug\\" .. flightNameClean ..
                                "_" .. "Custom_Intercept" .. "_" .. tostring(current_time) .. ".lua", "w")
                            if logFile then
                                logFile:write(logStr)
                                logFile:close()
                            end
                        end
						
					end
				end
			end, {}, timer.getTime() + 1.5)
			groupTargetMemory[argInterName] = bestTarget
		else
			if campL.debug then
				env.info("DCE_Custom_Intercept E : " .. argInterName .. " already targeting " .. newTargetName)
			end
		end
	else
		-- Aucune cible disponible : mise en orbite
		-- Si déjà en CAP, ne rien faire
        if GroupStateMemory[argInterName] == "CAP" then
            if campL.debug then
                env.info("DCE_Custom_Intercept: " .. argInterName .. " already in CAP — no change.")
            end
            return
        end
		
		local capMission = {
			id = 'Mission',
			params = {
				route = {
					points = {
						[1] = {
							type = "Turning Point",
							action = "Turning Point",
							x = interPos.x + 1000,
							y = interPos.z + 1000,
							alt = 6000,
							speed = argSpeed or 250,
							task = {
								id = "ComboTask",
								params = {
									tasks = {
										[1] = {
											id = 'EngageTargets',
											auto = true,
											enabled = true,
											params = {
												targetTypes = { "Air" },
												priority = 0,
												maxDist = 80000,
												maxDistEnabled = true,
											},
										},
										[2] = {
											id = 'Orbit',
											enabled = true,
											auto = false,
											params = {
												pattern = 'Circle',
												speed = argSpeed or 250,
												altitude = 6000,
											},
										},
									},
								},
							},
						},
					},
				},
			},
		}

        ctr:resetTask()
		
		ctr:setTask(capMission)

		GroupStateMemory[argInterName] = "CAP"

		if campL.debug then
            env.info("DCE_Custom_Intercept F CAP : " .. argInterName .. " now in CAP mission.")
			
			local current_time = timer.getTime()
			local logStr = "params = " .. TableSerialization(capMission, 0)
			local flightNameClean = argInterName:gsub('[%p%c%s]', '_')
			local logFile = io.open( PathDCE .. "Debug\\" .. flightNameClean .. "_" .. "Custom_Intercept" .. "_" .. tostring(current_time) .. ".lua", "w")
			if logFile then
				logFile:write(logStr)
				logFile:close()
			end

		end

	end

	-- Réévaluation périodique
    if not interceptorsActive[argInterName] then
		
		interceptorsActive[argInterName] = true
		timer.scheduleFunction(function()
			interceptorsActive[argInterName] = nil
			if interGroupObj and interGroupObj:isExist() then
				CustomIntercept(nil, argInterName, argFriendSide, argSpeed, argPosX, argPosY)
			end
		end, {}, timer.getTime() + REEVAL_INTERVAL)
	end
end



----------------------------------------------------------------------------------------------------
----- ForceToLand -----
----------------------------------------------------------------------------------------------------
function Custom_ForceToLand(argGroupName, argSpeed, argAltLanding, argLandingX, argLandingY, argLinkUnit)
    

	env.info( "DCE_Custom_ForceToLand A0 argFlightName |"..tostring(argGroupName).."| argLandingX |"..tostring(argLandingX).."| argLandingY |"..tostring(argLandingY).."| argLinkUnit |"..tostring(argLinkUnit))

	env.info("DCE_Custom_ForceToLand A1 start func() " .. tostring(argGroupName) )

	local groupObj = Group.getByName(argGroupName)
	if groupObj and groupObj:isExist() then
		-- local leaderObj = groupObj:getUnit(1)
	
		-- local units = groupObj:getUnits()
		-- for _, unitObj in ipairs(units) do
        -- if unit and unit:isExist() and unit:isActive() and unit:inAir() then
		
		local unitObj = groupObj:getUnit(1)
		if unitObj and unitObj:isExist() then
			local leaderPosVec3 = unitObj:getPoint()

			local landingPos = { x = argLandingX, y = argLandingY }
			local curPos = { x = leaderPosVec3.x, y = leaderPosVec3.z }
			local initLinkUnit = nil

			if landingPos.x and curPos.y then

				local dist = GetDistance(curPos, landingPos)

				if SatusGroupAircraft and SatusGroupAircraft[argGroupName] then
					local oldRoute = SatusGroupAircraft[argGroupName]["waypoints"]
					initLinkUnit = #oldRoute > 0 and oldRoute[#oldRoute].linkUnit or nil
					SatusGroupAircraft[argGroupName]["forcedLanding"] = true
				else
					env.info(string.format("DCE_Custom_ForceToLand B BUG NO SatusGroupAircraft with " ..
					tostring(argGroupName)))
				end
				local varLinkUnit = argLinkUnit or initLinkUnit

				-- forcer l'atterrissage et marquer

				env.info(string.format("DCE_Custom_ForceToLand C forced landing for %s (dist=%.0f)", argGroupName,
				dist))

				-- Construire une mission simple : WP courant (Turning Point) -> WP atterrissage (Land)
				local newRoute = {
					id = 'Mission',
					params = {
						route = {
							points = {
								[1] = {
									action = "Turning Point",
									type = "Turning Point",
									x = curPos.x,
									y = curPos.y,
									alt = leaderPosVec3.y or 500,
									alt_type = "BARO",
									speed = argSpeed or 230,
									ETA_locked = false,
									task = { id = "ComboTask", params = { tasks = {} } },
								},
								[2] = nil -- on remplira ci-dessous selon landingWp
							}
						}
					}
				}

				-- Si landingWp contient un linkUnit (base/ship), on le réutilise pour avoir un "vrai" landing
				local landPoint = {
					action = "Landing",
					type = "Land",
					alt = argAltLanding or 0,
					alt_type = "RADIO",
					speed = argSpeed or 230,
					x = landingPos.x,
					y = landingPos.y,
					ETA_locked = false,
					task = { id = "ComboTask", params = { tasks = {} } },
				}

				if varLinkUnit then
					landPoint.linkUnit = varLinkUnit
					landPoint.helipadId = varLinkUnit
				end

				newRoute.params.route.points[2] = landPoint

				-- Appliquer en remplaçant la mission : Controller.setTask
				local ctrl = groupObj:getController()
				if ctrl then
                    -- On utilise pcall pour éviter crash si API différente
					
					-- local ok, err = pcall(function()
					-- 	Controller.setTask(ctrl, newRoute)
                    -- end)
					
                    Controller.setTask(ctrl, newRoute)
					
					-- if not ok then
					-- 	env.info("DCE_Custom_ForceToLand D Controller.setTask failed: " .. tostring(err))
					-- 	return false
					-- end
					env.info("DCE_Custom_ForceToLand E  mission d'atterrissage appliquée pour " .. tostring(groupObj:getName()))
					return true
				end



				if campL.debug then
					--export custom mission log
					local current_time = timer.getTime()
					local logStr = "newRoute = " .. TableSerialization(newRoute, 0)
					local flightNameClean = argGroupName:gsub('[%p%c%s]', '_')
					local logFile = io.open(
					PathDCE .. "Debug\\" .. flightNameClean .. "_" .. "Custom_ForceToLand" .. "_" .. tostring(current_time) .. ".lua", "w")
					if logFile then
						logFile:write(logStr)
						logFile:close()
					else
						env.info("DCE_Custom_ForceToLand F Failed to open log file for writing.")
					end
				end
				-- break
			else
				env.info("DCE_Custom_ForceToLand Z ERROR missing landingPos or curPos")
				_affiche(landingPos, "DCE_Custom_ForceToLand C landingPos")
				_affiche(curPos, "DCE_Custom_ForceToLand D curPos")
			end
		end
	end
end


----------------------------------------------------------------------------------------------------
----- orbit position task -----
----------------------------------------------------------------------------------------------------

--lets flight orbit at the current position the task was applied (regardless of waypoints)
function OrbitPosition(arg_FlightName, arg_Alt, arg_Speed, arg_UntilTime)
	
	local flight = Group.getByName(arg_FlightName)							--get group
	local current_time0 = timer.getTime()
	-- env.info(
	-- 	"DCE_Orbit A, grpname |"..tostring(arg_FlightName).."|Alt|"..tostring(arg_Alt).."|Speed|"
	-- 	..tostring(arg_Speed).."|UntilTime|"..tostring(arg_UntilTime).."|current_time0|"..tostring(current_time0)
	-- )

	local function execute()
		-- env.info("DCE_Orbit B ")

		if flight then														--group still exists

			local current_time = timer.getTime()
			env.info( "DCE_Orbit C "..tostring(arg_FlightName).." "..tostring(current_time))

			-- local var_duration = tonumber(UntilTime) - current_time

			local leader = flight:getUnit(1)								--get first unit in group
			local cntrl = flight:getController()							--get controller of group
			local posVec3 = leader:getPoint()									--get position

			local task_entry = {
				["enabled"] = true,
				["auto"] = false,
				["id"] = "ControlledTask",
				["number"] = 1,
				["params"] =
				{
					["task"] =
					{
						["id"] = "Orbit",
						["params"] =
						{
							["altitude"] = arg_Alt,
							["pattern"] = "Circle",
							["speed"] = arg_Speed,
							["point"] = { x = posVec3.x, y = posVec3.z},
						},
					},
					["stopCondition"] =
					{
						["time"] = tonumber(arg_UntilTime),
						-- ["duration"] = tonumber(var_duration),
					}
				}
			}
			cntrl:pushTask(task_entry)										--set task for group

			-- if campL.debug then
			-- 	local logStr = "OrbitPosition = " .. TableSerialization(task_entry, 0)
			-- 	local flightNameClean = arg_FlightName:gsub('[%p%c%s]', '_')
			-- 	local logFile = io.open(PathDCE.."Debug\\"..flightNameClean.."_".. "OrbitPosition_"..current_time..".lua", "w")
			-- 	if logFile then
			-- 		logFile:write(logStr)
			-- 		logFile:close()
			-- 	else
			-- 		env.info("DCE_OrbitPosition: Failed to open log file for writing.")
			-- 	end
			-- end
		end
	end

	timer.scheduleFunction(execute, nil, timer.getTime() + 2)

end


----------------------------------------------------------------------------------------------------
------------------------------------ RTB task ------------------------------------------------------
----------------------------------------------------------------------------------------------------

--actualizes the xy position of the CV/base to assign a correct position to WPT landing
function Custom_RTB_2_Base(grpname, BaseName, speed, alt)
	
	env.info( "Custom_RTB_2_Base A, grpname |"..tostring(grpname).."|"..tostring(BaseName).."|"..tostring(speed).."|"..tostring(alt))

	local function execute()

		local flight = Group.getByName(grpname)								--get Group
		local gpGid = Group.getID(flight)
		local leader = flight:getUnit(1)									--get first unit in group
		local base = Unit.getByName(BaseName)								--trouve le CV si c'en est un

		if not base or base == nil then
			base = Airbase.getByName(BaseName)								--trouve la base si c'est un Airbase

			if not base or base == nil then									--trouve la base si le nom est incomplet
				if  baseFullName[BaseName] then
					BaseName =  baseFullName[BaseName]
					base = Airbase.getByName(BaseName)
					env.info( "Custom_RTB_2_Base B, BaseName |"..tostring(BaseName).."| base |"..tostring(base))
				end
			end

			env.info( "Custom_RTB_2_Base C, BaseName |"..tostring(BaseName).."| base |"..tostring(base))
			-- _affiche(base, "Custom_RTB_2_Base D base")
		end

		if leader and base  then													--unit still exists

			-- env.info( "Custom_RTB_2_Base, PASSE if flight and Base ")
			-- trigger.action.outText( "Custom_RTB_2_Base, PASSE if flight and Base ", 30)

			local posFlightVec3 = leader:getPoint()									--get position
			local pt_start = {
				x = posFlightVec3.x,
				y = posFlightVec3.z,
				z = posFlightVec3.y,
			}

			local posBaseVec3 = base:getPoint()										--get position	
			local uId = base:getID()
			local pt_landing = {
				x = posBaseVec3.x,
				y = posBaseVec3.z,
				z = posBaseVec3.y,
				Id = uId,
			}

			local current_time = timer.getTime()
			local distance01 = math.sqrt(math.pow(pt_start.x - pt_landing.x, 2) + math.pow(pt_start.y - pt_landing.y, 2))

			local route = {}
			route = {
					[1] =
					{
						["alt"] = tonumber(pt_start.z + 100),
						["action"] = "Turning Point",
						["type"] = "Turning Point",
						["alt_type"] = "BARO",
						["speed"] = speed,
						["task"] =
						{
							["id"] = "ComboTask",
							["params"] =
							{
								["tasks"] =
								{
								}, -- end of ["tasks"]
							}, -- end of ["params"]
						}, -- end of ["task"]
						["ETA"] = current_time + 1 ,
						["ETA_locked"] = true,
						["y"] = pt_start.y,
						["x"] = pt_start.x,
						["name"] = "",
						["formation_template"] = "",
						["speed_locked"] = true,
					}, -- end of [1]  
				[2] =
				{
					["alt"] = tonumber((pt_start.z + pt_landing.z + 100) / 2),
					["action"] = "Landing",
					["alt_type"] = "BARO",
					["speed"] = speed,
					["task"] =
					{
						["id"] = "ComboTask",
						["params"] =
						{
							["tasks"] =
							{
							}, -- end of ["tasks"]
						}, -- end of ["params"]
					}, -- end of ["task"]
					["type"] = "Land",
					["ETA"] = (distance01 / speed) + current_time,
					["ETA_locked"] = false,
					["y"] = pt_landing.y,
					["x"] = pt_landing.x,
					["name"] = "",
					["formation_template"] = "",
					["speed_locked"] = true,
					['linkUnit'] = pt_landing.Id,
					['helipadId'] = pt_landing.Id,
				}
			}

			local Mission = {
				id = 'Mission',
				params = {
					route = {
						points = route
					}
				}
			}

			if campL.debug then
				local logStr = "Custom_RTB_2_Base = " .. TableSerialization(Mission, 0)
				local grpnameClean = grpname:gsub('[%p%c%s]', '_')
				local logFile = io.open(PathDCE.."Debug\\"..grpnameClean.."_".. "Custom_RTB_2_Base.lua", "w")
				if logFile then
					logFile:write(logStr)
					logFile:close()
				else
					env.info("DCE_Custom_RTB_2_Base: Failed to open log file for writing.")
				end
			end
			env.info( "Custom_RTB_2_Base M,  setTask ")

			--ajoute le plan de vol dans db, pour utiliser plus tard si necessaire, car DCS ne garde pas en env.mission les plan de vol ajouté à l'arrache
			LastInjectFlightPlan[gpGid] = Mission

			local ctr = flight:getController()
			Controller.setTask(ctr, Mission)


		end
	end

	timer.scheduleFunction(execute, nil, timer.getTime() + 1)

end	--Custom_RTB_2_Base


----------------------------------------------------------------------------------------------------
------------------------------------ Custom_AddWptSAR task ------------------------------------------
----------------------------------------------------------------------------------------------------

--ajoute des wpt lorsqu'il trouve un EjectedPilot en plus
function Custom_AddWptSAR(grpname, baseName, mgrsChute, speed, alt)
	

	local current_time = timer.getTime()
	env.info( "current_time: "..tostring(current_time).." Custom_AddWptSAR A, grpname |"..tostring(grpname).."|"..tostring(baseName).."|"..tostring(speed).."|"..tostring(alt))

	local function execute()
		local flight = Group.getByName(grpname)
		local coalitionId = tostring(flight:getCoalition())						--obligé pour le string, car 0 est impossible en numerotation de table	
		local leader = flight:getUnit(1)
		local base = Unit.getByName(baseName)								--trouve le CV si c'en est un
		local  gpGid = Group.getID(flight)

		if not base or base == nil then
			base = Airbase.getByName(baseName)								--trouve la base si c'est un Airbase

			if not base or base == nil then									--trouve la base si le nom est incomplet
				if  baseFullName[baseName] then
					baseName = baseFullName[baseName]
					base = Airbase.getByName(baseName)
				end
			end
		end

		if leader and base  then
			local posFlightVec3 = leader:getPoint()
			local pt_start = {
				x = posFlightVec3.x,
				y = posFlightVec3.z,
				z = posFlightVec3.y,
			}
			local pt_dest = {
				x = 0,
				y = 0,
				z = 0,
				Id = 0,
			}
			local fuelPercent = Unit.getFuel(leader)

			local posBaseVec3 = base:getPoint()
			local uId = base:getID()

			local pt_landing = {
				x = posBaseVec3.x,
				y = posBaseVec3.z,
				z = posBaseVec3.y,
				Id = uId,
			}

			current_time = timer.getTime()
			local distanceLanding = math.sqrt(math.pow(pt_start.x - pt_landing.x, 2) + math.pow(pt_start.y - pt_landing.y, 2))
			local selectedDistance = 999999
			local nb_survivor = 0

			for MGRS_Chute, zone in pairs(ZoneSAR) do
				for N_Pilot, uPilot in ipairs(zone) do
					if  string.lower(uPilot.sideName) ==  coalitionId[coalitionId]  then
						if uPilot.name and uPilot.embarked ~= true  and (uPilot.status ==  "MIA" or uPilot.status ==  "EVAC_possible" )  then
							local distance = math.sqrt(math.pow(pt_start.x - uPilot.x, 2) + math.pow(pt_start.y - uPilot.y, 2))
							if distance < selectedDistance then
								selectedDistance = distance
								pt_dest = uPilot
								nb_survivor = nb_survivor + 1
							end
						end
					end
				end
			end

			local newRoute = {}
			if nb_survivor >= 1 and fuelPercent >= 0.5 and selectedDistance < 30001 then

				local distance01 = math.sqrt(math.pow(pt_start.x - pt_dest.x, 2) + math.pow(pt_start.y - pt_dest.y, 2))
				local heading = GetHeading({x=pt_dest.x, y=pt_dest.y} , {x=pt_landing.x, y=pt_landing.y} )
				local pt_inter = GetOffsetPoint({x=pt_dest.x, y=pt_dest.y}, heading , 1000 )

				pt_inter.alti = land.getHeight({x =pt_inter.x, y = pt_inter.y})

				newRoute = {
					[1] =
						{
							["alt"] = tonumber(pt_start.z + 100),
							["action"] = "Turning Point",
							["type"] = "Turning Point",
							["alt_type"] = "BARO",
							["name"] = "if nb_survivor >= 1",
							["speed"] = tonumber(speed),
							["task"] =
							{
								["id"] = "ComboTask",
								["params"] =
								{
									["tasks"] =
									{
										[1] =
										{
											["enabled"] = true,
											["auto"] = false,
											["id"] = "WrappedAction",
											["number"] = 1,
											["params"] =
											{
												["action"] =
												{
													["id"] = "Script",
													["params"] =
													{
														["command"] = "Custom_Altitude('" .. grpname .. "',  '  nil  ', '" .. "1" .. "')",
													},
												},
											},
										}, -- end of [2]	
									}, -- end of ["tasks"]
								}, -- end of ["params"]
							}, -- end of ["task"]
							["ETA"] = current_time ,
							["ETA_locked"] = true,
							["y"] = pt_start.y,
							["x"] = pt_start.x,
							["formation_template"] = "",
							["speed_locked"] = true,
						}, -- end of [1]  
					[2] =
					{
						["alt"] = tonumber(pt_dest.z + 100),
						["action"] = "Turning Point",
						["alt_type"] = "BARO",
						["speed"] = tonumber(speed),
						["task"] =
						{
							["id"] = "ComboTask",
							["params"] =
							{
								["tasks"] =
								{
								}, -- end of ["tasks"]
							}, -- end of ["params"]
						}, -- end of ["task"]
						["type"] = "Turning Point",
						["ETA"] = current_time + 1 ,
						["ETA_locked"] = false,
						["y"] = pt_dest.y,
						["x"] = pt_dest.x,
						["name"] = "",
						["formation_template"] = "",
						["speed_locked"] = true,
					},
					[3] =
					{
						["alt"] = tonumber(pt_dest.z + 100),
						["action"] = "Turning Point",
						["alt_type"] = "BARO",
						["speed"] = tonumber(speed),
						["task"] =
						{
							["id"] = "ComboTask",
							["params"] =
							{
								["tasks"] =
								{
									[1] =
									{

										["enabled"] = true,
										["auto"] = false,
										["id"] = "WrappedAction",
										["number"] = 1,
										["params"] =
										{
											["action"] =
											{
												["id"] = "Script",
												["params"] =
												{
													["command"] = "Custom_SAR('" .. grpname .. "', '" .. baseName .. "', '" .. pt_landing.x .. "', '" .. pt_landing.y .. "', '" .. mgrsChute .. "', '" .. speed .. "', '" .. alt .. "')",
												}, -- end of ["params"]
											}, -- end of ["action"]
										}, -- end of ["params"]
									}, -- end of [1]					
								}, -- end of ["tasks"]
							}, -- end of ["params"]
						}, -- end of ["task"]
						["type"] = "Turning Point",
						["ETA"] = (distance01 / speed) + current_time ,
						["ETA_locked"] = false,
						["y"] = pt_dest.y,
						["x"] = pt_dest.x,
						["name"] = "",
						["formation_template"] = "",
						["speed_locked"] = true,
					},
					[4] =
					{
						["alt"] = tonumber(pt_inter.alti + 250),
						["action"] = "Turning Point",
						["alt_type"] = "BARO",
						["speed"] = tonumber(speed),
						["task"] =
						{
							["id"] = "ComboTask",
							["params"] =
							{
								["tasks"] =
								{
									[1] =
									{
										["enabled"] = true,
										["auto"] = false,
										["id"] = "WrappedAction",
										["number"] = 2,
										["params"] =
										{
											["action"] =
											{
												["id"] = "Script",
												["params"] =
												{
													["command"] = "Custom_Altitude('" .. grpname .. "',  '  nil  ', '" .. "4" .. "')",
												},
											},
										},
									}, -- end of [2]
								}, -- end of ["tasks"]
							}, -- end of ["params"]
						}, -- end of ["task"]
						["type"] = "Turning Point",
						["ETA"] = current_time + 1 ,
						["ETA_locked"] = false,
						["y"] = pt_inter.y,
						["x"] = pt_inter.x,
						["name"] = "",
						["formation_template"] = "",
						["speed_locked"] = true,
					},
					[5] =
					{
						["alt"] = tonumber((pt_dest.z + pt_landing.z + 100) / 2),
						["action"] = "Landing",
						["alt_type"] = "BARO",
						["speed"] = tonumber(speed),
						["task"] =
						{
							["id"] = "ComboTask",
							["params"] =
							{
								["tasks"] =
								{
								}, -- end of ["tasks"]
							}, -- end of ["params"]
						}, -- end of ["task"]
						["type"] = "Land",
						["ETA"] = (distanceLanding / speed) + current_time,
						["ETA_locked"] = false,
						["y"] = pt_landing.y,
						["x"] = pt_landing.x,
						["name"] = "",
						["formation_template"] = "",
						["speed_locked"] = true,
						['linkUnit'] = tonumber(pt_landing.Id),
						['helipadId'] = tonumber(pt_landing.Id),
					}
				}
			else	--if nb_survivor >= 1 and FuelPercent >= 0.5 and selectedDistance < 30001 then 
					--si rien d'autre, on rentre à la base

				--reprise de la route originale pour rentrer, en supprimant la partie INGRESS
				if string.find(grpname, "CSAR") then
					local copyRoute = {}
					local foundAeronef = false

					for tblGrpId, value in pairs(LastInjectFlightPlan) do
						if tblGrpId == gpGid then
							copyRoute = Deepcopy(value.params.route.points)
							foundAeronef = true
							break
						end
					end

                    if not foundAeronef then
						
						copyRoute = MissGroupByName[grpname].route

						-- for _coalition, coalition in pairs(env.mission.coalition) do
						-- 	for Ncountry, _country in pairs(coalition.country) do
						-- 		if _country.helicopter then
						-- 			for Ngroup, _group in pairs(_country.helicopter.group) do
						-- 				if _group.groupId == gpGid then
						-- 					copyRoute = Deepcopy(_group.route.points)
						-- 					foundAeronef = true
						-- 					break
						-- 				end
						-- 			end
						-- 		end
						-- 		if foundAeronef then break end
						-- 	end
						-- 	if foundAeronef then break end
						-- end
					end

					local attackPoint = 0
					for Npoint, point in ipairs(copyRoute) do
						if point.name == "Attack" then
							attackPoint = Npoint
							break
						end
					end

					-- table.remove(copyRoute, Npoint)
					-- www
					--https://stackoverflow.com/questions/12394841/safely-remove-items-from-an-array-table-while-iterating
					-- nouvelle façon de supprimer des elements d'une table, sans le tps ultra long de table.remove
					if foundAeronef and attackPoint > 0 then
						local n=#copyRoute
						for i=1,n do
							if i < attackPoint-1 then
								copyRoute[i]=nil
							end
						end

						local j=0
						for i=1,n do
							if copyRoute[i]~=nil then
								j=j+1
								copyRoute[j]=copyRoute[i]
							end
						end
						for i=j+1,n do
							copyRoute[i]=nil
						end

						copyRoute[1].ETA_locked = true

						copyRoute[1]["task"] =
						{
							["id"] = "ComboTask",
							["params"] =
							{
								["tasks"] =
								{
									[1] =
									{
										["enabled"] = true,
										["auto"] = false,
										["id"] = "WrappedAction",
										["number"] = 1,
										["params"] =
										{
											["action"] =
											{
												["id"] = "Script",
												["params"] =
												{
													["command"] = "Custom_Altitude('" .. grpname .. "',  '  nil  ', '" .. "1" .. "')",
												},
											},
										},
									}, -- end of [1]
								}, -- end of ["tasks"]
							}, -- end of ["params"]
						} -- end of ["task"]

						--pour calculer l'altitude max du relief entre position actuel et wpt suivant
						copyRoute[1].x = pt_start.x
						copyRoute[1].y = pt_start.y
						copyRoute[1]["alt"] = tonumber(pt_start.z + 100)

						newRoute = copyRoute
					else
						return
					end
				else	--if string.find(grpname, "CSAR") then


					newRoute = {
						[1] =
							{
								["alt"] = tonumber(pt_start.z + 100),
								["action"] = "Turning Point",
								["type"] = "Turning Point",
								["alt_type"] = "BARO",
								["name"] = "ELSE SAR&Autre",
								["speed"] = tonumber(speed),
								["task"] =
								{
									["id"] = "ComboTask",
									["params"] =
									{
										["tasks"] =
										{
											[1] =
											{
												["enabled"] = true,
												["auto"] = false,
												["id"] = "WrappedAction",
												["number"] = 1,
												["params"] =
												{
													["action"] =
													{
														["id"] = "Script",
														["params"] =
														{
														 ["command"] = "Custom_Altitude('" .. grpname .. "',  '  nil  ', '" .. "1" .. "')",
														},
													},
												},
											}, -- end of [2]
										}, -- end of ["tasks"]
									}, -- end of ["params"]
								}, -- end of ["task"]
								["ETA"] = current_time + 1 ,
								["ETA_locked"] = true,
								["y"] = pt_start.y,
								["x"] = pt_start.x,
								["formation_template"] = "",
								["speed_locked"] = true,
							}, -- end of [1]  
						[2] =
						{
							["alt"] = tonumber((pt_dest.z + pt_landing.z + 100) / 2),
							["action"] = "Landing",
							["alt_type"] = "BARO",
							["speed"] = tonumber(speed),
							["task"] =
							{
								["id"] = "ComboTask",
								["params"] =
								{
									["tasks"] =
									{
									}, -- end of ["tasks"]
								}, -- end of ["params"]
							}, -- end of ["task"]
							["type"] = "Land",
							["ETA"] = (distanceLanding / speed) + current_time,
							["ETA_locked"] = false,
							["y"] = pt_landing.y,
							["x"] = pt_landing.x,
							["name"] = "",
							["formation_template"] = "",
							["speed_locked"] = true,
							['linkUnit'] = tonumber(pt_landing.Id),
							['helipadId'] = tonumber(pt_landing.Id),
						}
					}
				end	--else CSAR
			end

			local Mission = {
				id = 'Mission',
				params = {
					route = {
						points = newRoute
					}
				}
			}

			if campL.debug then
				local logStr = "Custom_AddWptSAR = " .. TableSerialization(Mission, 0)
				local grpnameClean = grpname:gsub('[%p%c%s]', '_')
				local logFile = io.open(PathDCE.."Debug\\"..grpnameClean.."_Custom_AddWptSAR_"..current_time..".lua", "w")
				if logFile then
					logFile:write(logStr)
					logFile:close()
				end
			end

			LastInjectFlightPlan[gpGid] = Mission
			local ctr = flight:getController()
			Controller.setTask(ctr, Mission)

			--ajoute le plan de vol dans db, pour utiliser plus tard si necessaire, car DCS ne garde pas en env.mission les plan de vol ajouté à l'arrache


		end
	end

	timer.scheduleFunction(execute, nil, timer.getTime() + 1)


end	--Custom_AddWptSAR


----------------------------------------------------------------------------------------------------
-------------------------------------------- SAR task ----------------------------------------------
----------------------------------------------------------------------------------------------------

--Makes a personalized approach depending on the presence of a landing point or a soldier or the sea 
function Custom_SAR(grpname, baseName, baseNameX, baseNameY, mgrsChute, speed, alt)
	
    local current_time = timer.getTime()
	local t0
	
    local function execute()
		if campL.debug then
			t0 = os.clock()
			Perf_L_N = Perf_L_N + 1
		end
	
		current_time = timer.getTime()
		local flight = Group.getByName(grpname)								--get Group
		local leader = flight:getUnit(1)									--get first unit in group
		local base = Unit.getByName(baseName)								--get unit
		local grpCoalitionId = tostring(flight:getCoalition())
		local gpGid = Group.getID(flight)

		local posFlightVec3 = leader:getPoint()									--get position
		local currentPos = {
			x = posFlightVec3.x,
			y = posFlightVec3.z,
			z = posFlightVec3.y,
		}

		-- local uSAR_Speed = speed /2 *3
		local pt_dest = {
			x = 0,
			y = 0,
			z = 0,
			Id = 0,
			SoldierGroupID = 0,
			landingPossible = false,
			uPilotName = "",
		}

		local posBaseVec3
		local uId
		local baseNameZ = land.getHeight({x = baseNameX, y = baseNameY})
		local pt_landing = {
			x = baseNameX,
			y = baseNameY,
			z = baseNameZ,
		}

		--TODO CV est aussi une base, il faut donc lui coller l'alti, ici aussi

		if base then
			posBaseVec3 = base:getPoint()
			uId = base:getID()

			pt_landing.x = posBaseVec3.x
			pt_landing.y = posBaseVec3.z
			pt_landing.Id = uId

		end

		--TODO ajouter la distinction par camp (???)
		local posEjectPilotVec3

		local selected_distance = 9999999
		local selectedEjection = {}

		for MGRS_Chute, zone in pairs(ZoneSAR) do
			for N_Pilot, uPilot in ipairs(zone) do
				if  string.lower(uPilot.sideName) ==  CoalitionIdAlphaToName[grpCoalitionId]  then
					local authorisesRescue = true
					local wrongSide = false
					local eny_Side = DCS_ENI_Side[uPilot.sideName]
					if campL.boundary and campL.boundary[eny_Side] and campL.boundary[eny_Side] ~= nil then
						wrongSide =  CheckPointInPoly_XY_2({x=uPilot.pos.x,y=uPilot.pos.y} , campL.boundary[eny_Side])
						if wrongSide  then
							authorisesRescue = false
						end
					end

					if authorisesRescue and uPilot.name and uPilot.name ~= nil and not uPilot.embarked then

						local unitPilot = Unit.getByName(uPilot.name)
						local temp_x, temp_y, temp_z = 0, 0, 0
						local distance = 0
						local temp_SoldierGroupID = 0
						local temp_landingPossible = uPilot.landingPossible

						if uPilot.pos.surfaceType == 3 then												--dans l'eau: pas de soldat
							temp_x, temp_y, temp_z = uPilot.pos.x, uPilot.pos.y, uPilot.pos.z
							temp_SoldierGroupID = 0
						elseif unitPilot and unitPilot ~= nil then
							posEjectPilotVec3 = unitPilot:getPoint()
							temp_x, temp_y, temp_z = posEjectPilotVec3.x, posEjectPilotVec3.z, posEjectPilotVec3.y
							temp_SoldierGroupID = unitPilot:getGroup():getID()
							-- temp_landingPossible = unitPilot.landingPossible

						end

						distance = math.sqrt(math.pow(currentPos.x - temp_x, 2) + math.pow(currentPos.y - temp_y, 2))

						if distance <= 15000 and distance < selected_distance  then
							selected_distance = distance

							pt_dest.x = temp_x
							pt_dest.y = temp_y
							pt_dest.z = temp_z
							pt_dest.landingPossible = temp_landingPossible

							selectedEjection = uPilot

							pt_dest.SoldierGroupID = temp_SoldierGroupID
							pt_dest.uPilotName = uPilot.name
						end
					end
				end
			end
		end

		-- si pas de présence de soldat, simulant le piloteEjecté: on sort (cas des ejected en mer, par exemple)
		if pt_dest.x == 0 then
            -- env.info( "Custom_SAR Ib RETURN ************* ")
			if campL.debug then
				local dt = os.clock() - t0
				Perf_L = Perf_L + dt
			end
			return
		end

		local distanceLanding = math.sqrt(math.pow(currentPos.x - pt_landing.x, 2) + math.pow(currentPos.y - pt_landing.y, 2))
		local headingRTB = GetHeading({x=pt_dest.x, y=pt_dest.y} , {x=pt_landing.x, y=pt_landing.y} )
		-- local distanceRTB = distanceLanding/2
		local distanceRTB = 1500
		local pointRTB = GetOffsetPoint({x=pt_dest.x, y=pt_dest.y}, headingRTB, distanceRTB)
		local pointRTBz = land.getHeight({x =pointRTB.x, y = pointRTB.y})
		local pt50m
		selectedTransport = 1

		--test tous les cas: landing or not
		if pt_dest.SoldierGroupID == 0 or pt_dest.theatreCercle == false then
			-- si pas Id soldier: ejectedPilot sur l eau, on ne se pose pas
			pt_dest.landingPossible = false

		elseif pt_dest.landingPossible then

			--on tente la position  50m plus loin que l'ejectedPilot pour ne par lui tomber dessus
			pt50m = GetOffsetPoint({x=pt_dest.x, y=pt_dest.y}, 0, 50 )

			local certitudeLand  = true     --on est sur que le terrain n'est pas en partie, de l'eau
			local altiMax = 0
			local altiMin = 999999
			for angle = 0, 360, 45 do

				local sondagePt = GetOffsetPoint({x=pt50m.x, y=pt50m.y}, angle, 25 )
				local sondageAlti = land.getHeight({x =sondagePt.x, y = sondagePt.y})
				local typeLand = land.getSurfaceType({x =sondagePt.x, y = sondagePt.y})
				if typeLand ~= 1 then
					certitudeLand = false
				end
				if sondageAlti > altiMax then
					altiMax = sondageAlti
				end
				if sondageAlti < altiMin then
					altiMin = sondageAlti
				end
			end
			local testDeniv = altiMax - altiMin

			if testDeniv < 5 and certitudeLand then
				-- si le denivelé est faible, on se pose
				pt_dest.landingPossible = true
			else
				-- si le denivelé est faible, on se pose
				pt_dest.landingPossible = false
			end

		end

		-- le debut de la route, identique pour tous
		local route = {
			[1] =
				{
					["alt"] = currentPos.z,
					["action"] = "Turning Point",
					["type"] = "Turning Point",
					["alt_type"] = "BARO",
					["speed"] = tonumber(speed),
					["task"] =
					{
						["id"] = "ComboTask",
						["params"] =
						{
							["tasks"] =
							{
							}, -- end of ["tasks"]
						}, -- end of ["params"]
					}, -- end of ["task"]
					["ETA"] = current_time ,
					["ETA_locked"] = true,
					["y"] = currentPos.y,
					["x"] = currentPos.x,
					["name"] = "Custom_SAR() A",
					["formation_template"] = "",
					["speed_locked"] = true,
				}, -- end of [1]  
			[2] =
			{
				["alt"] = pt_dest.z + 150 ,
				["action"] = "Turning Point",
				["alt_type"] = "BARO",
				["speed"] = tonumber(speed),
				["task"] =
				{
					["id"] = "ComboTask",
					["params"] =
					{
						["tasks"] =
						{
						}, -- end of ["tasks"]
					}, -- end of ["params"]
				}, -- end of ["task"]
				["type"] = "Turning Point",
				["ETA"] =  (selected_distance / speed) + current_time ,
				["ETA_locked"] = false,
				["y"] = pt_dest.y,
				["x"] = pt_dest.x,
				["name"] = "",
				["formation_template"] = "",
				["speed_locked"] = true,
			},
			[3] =
			{
				["alt"] = pt_dest.z + 150,
				["action"] = "Turning Point",
				["alt_type"] = "BARO",
				["speed"] = tonumber(speed),
				["task"] =
				{
					["id"] = "ComboTask",
					["params"] =
					{
						["tasks"] =
						{
						}, -- end of ["tasks"]
					}, -- end of ["params"]
				}, -- end of ["task"]
				["type"] = "Turning Point",
				["ETA"] =  (selected_distance / speed) + current_time + 2 ,
				["ETA_locked"] = false,
				["y"] = pt_dest.y,
				["x"] = pt_dest.x,
				["name"] = "",
				["formation_template"] = "",
				["speed_locked"] = true,
			},	--[3] = 
			[4] =
			{
				["alt"] = pointRTBz + 150 ,
				["action"] = "Turning Point",
				["alt_type"] = "BARO",
				["speed"] = tonumber(speed),
				["task"] =
				{
					["id"] = "ComboTask",
					["params"] =
					{
						["tasks"] =
						{
						[1] =
							{
								["enabled"] = true,
								["auto"] = false,
								["id"] = "WrappedAction",
								["number"] = 1,
								["params"] =
								{
									["action"] =
									{
										["id"] = "Script",
										["params"] =
										{
											["command"] = "Custom_Altitude('" .. grpname .. "',  '  nil  ', '" .. "4" .. "')",
										},
									},
								},
							}, -- end of [1]
						}, -- end of ["tasks"]
					}, -- end of ["params"]
				}, -- end of ["task"]
				["type"] = "Turning Point",
				["ETA"] =  (distanceRTB / speed) + current_time ,
				["ETA_locked"] = false,
				["y"] = pointRTB.y,
				["x"] = pointRTB.x,
				["name"] = "",
				["formation_template"] = "",
				["speed_locked"] = true,
			},
			[5] =
			{
				["alt"] = tonumber(pt_landing.z + 100),
				["action"] = "Landing",
				["alt_type"] = "BARO",
				["speed"] = tonumber(speed),
				["task"] =
				{
					["id"] = "ComboTask",
					["params"] =
					{
						["tasks"] =
						{
						}, -- end of ["tasks"]
					}, -- end of ["params"]
				}, -- end of ["task"]
				["type"] = "Land",
				["ETA"] = (distanceLanding / speed) + current_time,
				["ETA_locked"] = false,
				["y"] = tonumber(pt_landing.y),
				["x"] = tonumber(pt_landing.x),
				["name"] = "",
				["formation_template"] = "",
				["speed_locked"] = true,
				['linkUnit'] = tonumber(pt_landing.Id),
				['helipadId'] = tonumber(pt_landing.Id),
			},
		}


		if pt_dest.SoldierGroupID == 0 and pt_dest.landingPossible then

			route[3]["task"] =
			{
				["id"] = "ComboTask",
				["name"] = "Custom_SAR() B",
				["params"] =
				{
					["tasks"] =
					{
						[1] =
						{
							["number"] = 1,
							["auto"] = false,
							["id"] = "ControlledTask",
							["enabled"] = true,
							["params"] =
							{
								["task"] =
								{
									["id"] = "Orbit",
									["params"] =
									{
										["speedEdited"] = true,
										["pattern"] = "Circle",
										["speed"] = 0,		--["speed"] = 0.27777777777778,
										["altitude"] = pt_dest.z + 80,
										["altitudeEdited"] = true,
									}, -- end of ["params"]
								}, -- end of ["task"]
								["stopCondition"] =
								{
									["duration"] = 90,
								}, -- end of ["stopCondition"]
							}, -- end of ["params"]
						},
						[2] =
						{
							["enabled"] = true,
							["auto"] = false,
							["id"] = "WrappedAction",
							["number"] = 2,
							["params"] =
							{
								["action"] =
								{
									["id"] = "Script",
									["params"] =
									{
										["command"] = "Custom_AddWptSAR('" .. grpname .. "', '" .. baseName .. "', '" .. mgrsChute .. "', '" .. speed .. "', '" .. alt ..  "')",
									}, -- end of ["params"]
								}, -- end of ["action"]
							}, -- end of ["params"]
						}, -- end of [2]
						-- [3] = 
						-- {
						-- 	["enabled"] = true,
						-- 	["auto"] = false,
						-- 	["id"] = "WrappedAction",
						-- 	["number"] = 3,
						-- 	["params"] = 
						-- 	{
						-- 		["action"] = 
						-- 		{
						-- 			["id"] = "Script",
						-- 			["params"] = 
						-- 			{
						-- 				["command"] = "Custom_Altitude('" .. grpname .. "',  '  nil  ', '" .."3".. "')",
						-- 			},
						-- 		},
						-- 	},
						-- }, -- end of [3]
					}, -- end of ["tasks"]
				}, -- end of ["params"]

			}


		elseif pt_dest.landingPossible then

			env.info( "Custom_SAR Z  ")

			selectedTransport = selectedTransport + 1

			-- env.info( "Custom_SAR M selectedTransport "..tostring(selectedTransport))

			route[3]["task"] =
			{
				["id"] = "ComboTask",
				["name"] = "Custom_SAR() C",
				["params"] =
				{
					["tasks"] =
					{
						[1] =
						{
							["enabled"] = true,
							["auto"] = false,
							["id"] = "Embarking",
							["number"] = 1,
							["params"] =
							{
								["selectedTransport"] = tonumber(selectedTransport),
								["distributionFlag"] = false,
								["groupsForEmbarking"] =
								{
									[1] = tonumber(pt_dest.SoldierGroupID),
								}, -- end of ["groupsForEmbarking"]
								["durationFlag"] = true,
								["y"] = pt50m.y,
								["x"] = pt50m.x,
								["distribution"] =
									{
										[tonumber(selectedTransport)] =
										{
											[1] = tonumber(pt_dest.SoldierGroupID),
										}, -- end of [1]
									}, -- end of ["distribution"]
									["duration"] = 800,
							}, -- end of ["params"]
						}, -- end of [1]
						[2] =
						{
							["enabled"] = true,
							["auto"] = false,
							["id"] = "WrappedAction",
							["number"] = 2,
							["params"] =
							{
								["action"] =
								{
									["id"] = "Script",
									["params"] =
									{
										["command"] = "DespawnSoldierAliasPilot('" .. pt_dest.uPilotName .. "')",
									},
								},
							},

						},
						[3] =
						{
							["enabled"] = true,
							["auto"] = false,
							["id"] = "WrappedAction",
							["number"] = 3,
							["params"] =
							{
								["action"] =
								{
									["id"] = "Script",
									["params"] =
									{
																				["command"] = "Custom_AddWptSAR('" .. grpname .. "', '" .. baseName .. "', '" .. mgrsChute .. "', '" .. speed .. "', '" .. alt .. "')",
									}, -- end of ["params"]
								}, -- end of ["action"]
							}, -- end of ["params"]
						}, -- end of [3]
						-- [4] = 
						-- {
						-- 	["enabled"] = true,
						-- 	["auto"] = false,
						-- 	["id"] = "WrappedAction",
						-- 	["number"] = 4,
						-- 	["params"] = 
						-- 	{
						-- 		["action"] = 
						-- 		{
						-- 			["id"] = "Script",
						-- 			["params"] = 
						-- 			{
						-- 				["command"] = "Custom_Altitude('" .. grpname .. "',  '  nil  ', '" .."3".. "')",
						-- 			},
						-- 		},
						-- 	},
						-- }, -- end of [4]
					}, -- end of ["tasks"]
				}, -- end of ["params"]

			}	--route[3]["task"]

			-- env.info( "Custom_SAR N testDeniv < 5 landingPossible? (norm OUI) "..tostring(selectedEjection.landingPossible))


		elseif not pt_dest.landingPossible then
			-- testDeniv > 5  ( le denivellé est trop important, l helico se pose pas)

			route[3]["task"] =
			{
				["id"] = "ComboTask",
				["name"] = "Custom_SAR() D",
				["params"] =
				{
					["tasks"] =
					{
						[1] =
						{
							["number"] = 1,
							["auto"] = false,
							["id"] = "ControlledTask",
							["enabled"] = true,
							["params"] =
							{
								["task"] =
								{
									["id"] = "Follow",
									["params"] =
									{
										["lastWptIndexFlagChangedManually"] = true,
										["groupId"] = tonumber(pt_dest.SoldierGroupID),
										["lastWptIndexFlag"] = false,
										["pos"] =
										{
											["y"] = 60,
											["x"] = 0,
											["z"] = 0,
										}, -- end of ["pos"]
									}, -- end of ["params"]
								}, -- end of ["task"]
								["stopCondition"] =
								{
									["duration"] = 150,
								}, -- end of ["stopCondition"]
							}, -- end of ["params"]
						},
						[2] =
						{
							["enabled"] = true,
							["auto"] = false,
							["id"] = "WrappedAction",
							["number"] = 2,
							["params"] =
							{
								["action"] =
								{
									["id"] = "Script",
									["params"] =
									{
										["command"] = "DespawnSoldierAliasPilot('" .. pt_dest.uPilotName .. "')",
									},
								},
							},

						},
						[3] =
						{
							["enabled"] = true,
							["auto"] = false,
							["id"] = "WrappedAction",
							["number"] = 3,
							["params"] =
							{
								["action"] =
								{
									["id"] = "Script",
									["params"] =
									{
										["command"] = "Custom_AddWptSAR('" .. grpname .. "', '" .. baseName .. "', '" .. mgrsChute ..  "', '" .. speed ..  "', '" .. alt ..  "')",
									}, -- end of ["params"]
								}, -- end of ["action"]
							}, -- end of ["params"]
						}, -- end of [2]

					}, -- end of ["tasks"]
				}, -- end of ["params"]

			}	--route[3]["task"]

			if not pt_dest.SoldierGroupID or pt_dest.SoldierGroupID == 0 then

				route[3]["task"]["params"]["tasks"][1]["params"]["task"] =
				{
					["id"] = "Orbit",
					["params"] =
					{
						["speedEdited"] = true,
						["name"] = "Custom_SAR() E",
						["pattern"] = "Circle",
						["speed"] = 0,		--["speed"] = 0.27777777777778,
						["altitude"] = 10,
						["altitudeEdited"] = true,
					}, -- end of ["params"]
				}

			end

			selectedEjection.landingPossible = false
			-- env.info( "Custom_SAR O testDeniv > 5 landingPossible? (norm NON) "..tostring(selectedEjection.landingPossible))

		end

		local mission = {
			id = 'Mission',
			params = {
				route = {
					points = route
				}
			}
		}

		if campL.debug then
			local logStr = "Custom_SAR = " .. TableSerialization(mission, 0)
			local grpnameClean = grpname:gsub('[%p%c%s]', '_')
			local logFile = io.open(PathDCE.."Debug\\"..grpnameClean.."_".. "Custom_SAR_"..current_time..".lua", "w")
			if logFile then
				logFile:write(logStr)
				logFile:close()
			else
				env.info("DCE_Custom_SAR_: Failed to open log file for writing.")
			end
		end
		-- env.info( "Custom_SAR, PASSE setTask PathDCE: "..tostring(PathDCE))

		--ajoute le plan de vol dans db, pour utiliser plus tard si necessaire, car DCS ne garde pas en env.mission les plan de vol ajouté à l'arrache
		LastInjectFlightPlan[gpGid] = mission

		local ctr = flight:getController()
		Controller.setTask(ctr, mission)

		if campL.debug then
			local dt = os.clock() - t0
			Perf_L = Perf_L + dt
		end

	end     --fin execute

	timer.scheduleFunction(execute, nil, timer.getTime() + 1)

end	--Custom_SAR



--[[ ----------------------------------------------------------------------------------------------------
------------------------------------- Custom_Altitude task -----------------------------------------
----------------------------------------------------------------------------------------------------



-- =========================================
-- Cache terrain LOCAL Custom_Altitude
-- Pourquoi : réduire drastiquement les appels land.getHeight
-- Résolution volontairement grossière (hélico)
-- =========================================
local terrainCache = {}
local terrainCellSize = 100  -- mètres (50–150 ok pour hélico)

local function getTerrainCachedLocal(x, y)
	local cx = math.floor(x / terrainCellSize)
	local cy = math.floor(y / terrainCellSize)
	local key = cx .. ":" .. cy

	if terrainCache[key] then
		TerrainStats_Cache_N = TerrainStats_Cache_N + 1
		return terrainCache[key]
	end

	local h = land.getHeight({ x = x, y = y })
	terrainCache[key] = h
	TerrainStats_N = TerrainStats_N + 1
	return h
end


local function getOffset(pt, hdg, dist)
    return GetOffsetPoint(pt, hdg, dist)
end

--------------------------------------------------
-- Trajet simple terrain plat
--------------------------------------------------
local function ComputeFlatPath(p1, p2, addAlti)

	local terrainAlt = getTerrainCachedLocal(p2.x, p2.y)
	local alt = terrainAlt + addAlti

	return {
		{
			x = p2.x,
			y = p2.y,
			alt = alt,
			alt_type = "RADIO"
		}
	}
end

--------------------------------------------------
-- Scan léger colline
--------------------------------------------------

local function ComputeHillPath(p1, p2, addAlti)

    local path = {}

    local cur = p1
    local step = 2000
	-- local step = interval
	local compteur = 1

    while GetDistance2D(cur,p2) > step do

        local hdg = GetHeading(cur,p2)

        local bestAlt = math.huge
        local bestP = nil

        for a=-10,10,5 do

            local p = getOffset(cur,hdg+a,step)
            local h = getTerrainCachedLocal(p.x,p.y)

            if h < bestAlt then
                bestAlt = h
                bestP = p
            end
			compteur = compteur + 1
        end

        if not bestP then break end

        table.insert(path,{
            x = bestP.x,
            y = bestP.y,
            alt = bestAlt + addAlti + 250,
            alt_type = "RADIO"
        })

        cur = bestP
    end
	return path, compteur
end



local function IsInValley(cur, hdg)
    local frontAlt = 0
    local sideAlt  = 0

    -- devant
    for d = 500, 3000, 500 do
        local p = getOffset(cur, hdg, d)
        local alt = getTerrainCachedLocal(p.x, p.y)

        if alt > frontAlt then
            frontAlt = alt
        end
    end

    -- côtés
    for _, a in ipairs({ -60, 60 }) do
        for d = 500, 2000, 500 do
            local p = getOffset(cur, hdg + a, d)
            local alt = getTerrainCachedLocal(p.x, p.y)

            if alt > sideAlt then
                sideAlt = alt
            end
        end
    end

    -- vallée = côtés plus hauts que devant
    if sideAlt > frontAlt + 150 then
        return true
    end

    return false
end

local function FindValleyDirection(cur, pEnd)
	local base = GetHeading(cur, pEnd)

	local bestHdg = base
	local bestAlt = math.huge

	for ang = -70, 70, 10 do
		local h = base + ang
		local maxAlt = 0

		-- for d = 1000, 6000, 1000 do
		-- 	local p = getOffset(cur, h, d)
		-- 	local alt = getTerrainCachedLocal(p.x, p.y)

		-- 	if alt > maxAlt then
		-- 		maxAlt = alt
		-- 	end
		-- end

		local prevAlt = nil

		-- for d = 1000, 8000, 800 do
		for d = 1000, 20000, 1200 do
			local p = getOffset(cur, h, d)
			local alt = getTerrainCachedLocal(p.x, p.y)

			if prevAlt then
				local slope = alt - prevAlt

				-- montée brutale = probablement un mur
				if slope > 400 then
					maxAlt = maxAlt + 2000
				end
			end

			if alt > maxAlt then
				maxAlt = alt
			end

			prevAlt = alt
		end

		if maxAlt < bestAlt then
			bestAlt = maxAlt
			bestHdg = h
		end
	end

	return bestHdg
end

local function FindGlobalPass(cur, pEnd)

    local base = GetHeading(cur, pEnd)

    local bestHdg = base
    local bestScore = math.huge

    for ang = -90, 90, 5 do
        local h = base + ang

        local maxAlt = 0

        for d = 2000, 25000, 1500 do
            local p = getOffset(cur, h, d)
            local alt = getTerrainCachedLocal(p.x, p.y)

            if alt > maxAlt then
                maxAlt = alt
            end
        end

        -- pénalise l'éloignement de la cible
        local dev = math.abs(ang) * 20

        local score = maxAlt + dev

        if score < bestScore then
            bestScore = score
            bestHdg = h
        end
    end

    return bestHdg
end


--------------------------------------------------
-- Scan vallée complet (montagne)
--------------------------------------------------
local function ComputeMountainPath(pStart, pEnd, addAlti, altiMax)

    if GetDistance2D(pStart, pEnd) < 100 then
        return { pEnd }, 1
    end

	local path = {}

	local cur = {
		x = pStart.x,
		y = pStart.y
	}

	-- local corridorHdg = FindValleyDirection(cur, pEnd)
	local corridorHdg = FindGlobalPass(cur, pEnd)
	if not corridorHdg then
		corridorHdg = GetHeading(cur, pEnd)
	end
	local maxIter = 50
	local dist = GetDistance2D(cur, pEnd)

	local step = 800
	if dist > 15000 then
		step = 2000
	elseif dist > 7000 then
		step = 1200
	elseif dist < 4000 then
		step = 400
	end

	local compteur = 1
	local lastDist = dist

	-- cônes progressifs
	-- local searchCones = { 15, 30, 60, 90 }
	
	local wasInValley = false

	for i = 1, maxIter do
        local hdg = corridorHdg

		-- détecte vallée AVANT
		local inValley = IsInValley(cur, hdg)

		if wasInValley and not inValley then
			-- tolérance : on garde le mode vallée encore 1 tour
			inValley = true
		end

		if inValley then
			TerrainStats_DETAIL["inValley"] = TerrainStats_DETAIL["inValley"] + 1
		else
			TerrainStats_DETAIL["outValley"] = TerrainStats_DETAIL["outValley"] + 1
		end

		-- sortie de vallée
		if wasInValley and not inValley then
			TerrainStats_DETAIL["exitValleyCount"] = TerrainStats_DETAIL["exitValleyCount"] + 1
		end

		wasInValley = inValley
		
        if inValley and step < 700 then
			step = 700
		end

		-- recalcul axe seulement si utile
		-- if i % 5 == 0 and not inValley then
		if i % 3 == 0 and not inValley then
			corridorHdg = FindValleyDirection(cur, pEnd)
			hdg = corridorHdg
		end

		local bestPoint = nil
		local bestAlt   = 0
		local bestScore = math.huge

		------------------------------------------------
		-- Recherche progressive
		------------------------------------------------
        local startDist = GetDistance2D(cur, pEnd)
		
		local cones

		if inValley then
			-- on est dans un couloir → on fonce
			cones = { 10 }
		else
			-- recherche normale
			cones = { 15, 30, 60, 90 }
		end


		local function SearchWithCones(conesTable)
			local found = false

			for _, cone in ipairs(conesTable) do
				for ang = -cone, cone, 5 do
					local h = hdg + ang
					local p = getOffset(cur, h, step)

					local alt = getTerrainCachedLocal(p.x, p.y)
					local requiredAlt = alt + addAlti + 250

					local valid = true

					if altiMax and requiredAlt > altiMax then
						valid = false
					end

					if valid then
						local dx = p.x - pEnd.x
						local dy = p.y - pEnd.y
						local distEnd = math.sqrt(dx * dx + dy * dy)

						local score = alt + distEnd * 0.3

						if score < bestScore and distEnd < startDist then
							
							bestScore = score
							bestPoint = p
							bestAlt   = alt
							found     = true
						end
					end

					compteur = compteur + 1
				end

				if found then
					break
				end
			end

			return found
		end
		
		local found = false

		-- 1) recherche normale
		found = SearchWithCones(cones)

		-- 2) secours si bloqué
		if not found then
			local rescueCones = { 90, 120, 150 }

			found = SearchWithCones(rescueCones)
		end

		-- 3) abandon
		if not found then
			break
		end

		------------------------------------------------
		-- Sécurité
		------------------------------------------------
		---if not bestPoint then
		if not bestPoint then
			break
		end

		------------------------------------------------
		-- Ajout waypoint
		------------------------------------------------
		table.insert(path, {
			x = bestPoint.x,
			y = bestPoint.y,
			alt = bestAlt + addAlti + 250,
			alt_type = "BARO"
		})

		cur = bestPoint

		local d = GetDistance2D(cur, pEnd)

		-- pas de progression → stop
		if d >= lastDist then
			break
		end

		lastDist = d

		-- proche destination
		if d < 1500 then
			break
		end
	end

	return path, compteur
end



--------------------------------------------------
-- Analyse grossière du terrain entre 2 points
-- Retour : "FLAT" | "HILL" | "MOUNTAIN"
--------------------------------------------------

local function analyseTerrainZone(p)
	
	local step = 1000
	local minAlt = 999999
	local maxAlt = 0

	for dx = -1, 1 do
		for dy = -1, 1 do
			local x = p.x + dx * step
			local y = p.y + dy * step

			local h = getTerrainCachedLocal(x, y)

			if h < minAlt then minAlt = h end
			if h > maxAlt then maxAlt = h end

		end
	end

	local diff = maxAlt - minAlt

	if diff < 80 then
		return "FLAT"
	elseif diff < 250 then
		return "HILL"
	else
		return "MOUNTAIN"
	end
end

local terrainZoneCache = {}
local function getTerrainZone(p)
	local gx = math.floor(p.x / 5000)
	local gy = math.floor(p.y / 5000)

	local key = gx .. ":" .. gy

	local v = terrainZoneCache[key]
	if v then
		return v
	end

	-- Analyse réelle
	local zone = analyseTerrainZone(p)

	terrainZoneCache[key] = zone
	return zone
end

AltiMaxHeli = {
	["AH-64D"] = 3505,
	["AH-64D_BLK_II"] = 2990,
	["SH-3D"] = 2500,
	["SA342M"] = 2000,
	["SA342L"] = 2000,
	["SA342Minigun"] = 2000,
	["Mi-8MT"] = 3960,
	["Mi-24P"] = 1500,
	["Mi-26"] = 1500,

}

--adapte l'altitude aux chaines montagneuse
function Custom_Altitude(grpName, wptAlti, wptTag)

	env.info("DEBUG: A Custom_Altitude() " .. tostring(grpName))

    local t_init
	TerrainStats_N = 0
    TerrainStats_Cache_N = 0
	TerrainStats_DETAIL = {
		["inValley"] = 0,
		["outValley"] = 0,
		["exitValleyCount"] = 0,
		["coneA"] = 0,
		["coneB"] = 0,
		["coneC"] = 0,

	}

	if campL.debug then
		t_init = os.clock()
		Perf_K_N = Perf_K_N + 1
	end

	if not Perf_CustAlt then
		Perf_CustAlt = {}
	end
	if not Perf_CustAlt[grpName] then
		Perf_CustAlt[grpName] = {
			N_Hill = 0,
			N_Mountain = 0,
			N_Flat = 0,
			timeTotal = 0,
			timeExecute = 0,
		}
	end

	if wptTag then
		wptTag = tonumber(wptTag) or 0
	else
		wptTag = 0
	end
	
	if not wptAlti or wptAlti == nil then
		wptAlti = 1
	end
	local current_time = timer.getTime()

    local function execute()

		local t0 = campL.debug and os.clock()

		current_time = timer.getTime()
		local flight = Group.getByName(grpName)

		local selectedMember
		local wingman = flight:getUnits()

		for memberN, _unit in ipairs(wingman) do
			if _unit and _unit:isExist() and _unit:isActive() and _unit:inAir() then
				selectedMember = _unit
				break
			end
		end

		if not selectedMember then
			if campL.debug then
				local dt = os.clock() - t_init
				Perf_K = Perf_K + dt
			end
			return
		end

		local ctr = selectedMember:getGroup():getController()
		local actualPositionVec3 = selectedMember:getPoint()
		local actualPositionXY = {
			x = actualPositionVec3.x,
			y = actualPositionVec3.z,
		}

		local addAlti = 150
		local str_selectedMember = selectedMember:getTypeName()

		-- local str_selectedMember = selectedMember:getTypeName()
		if type(str_selectedMember) ~= "string" then
			if campL.debug then
				local dt = os.clock() - t_init
				Perf_K = Perf_K + dt
			end
			return
		end


		if ctr then

			local gpGid = Group.getID(flight)
			local foundAeronef = false
			local copyRoute = {}

			local typeHeli = MissGroupByName[grpName]["units"][1]["type"]
			local altiMax = AltiMaxHeli[typeHeli]
			env.info("DCE_CA: altiMax " .. tostring(altiMax) .. " typeHeli: " .. tostring(typeHeli))

            for tblGrpId, value in pairs(LastInjectFlightPlan) do
                if tblGrpId == gpGid then
                    copyRoute = Deepcopy(value.params.route.points)
					-- env.info("DEBUG: S #copyRoute " .. tostring(#copyRoute) .. " wptTag: " .. tostring(wptTag))
                    foundAeronef = true
                    break
                end
            end


			 if not foundAeronef then
				copyRoute = MissGroupByName[grpName]["route"]["points"]

				-- env.info("DEBUG: T #copyRoute " .. tostring(#copyRoute))
			end

			--enleve le script Custom_Altitude pour eviter de le reinjecter et d avoir une boucle
			if wptTag and wptTag ~= nil then
				for pointN, point in ipairs(copyRoute) do
					if tonumber(pointN) == wptTag then
						copyRoute[tonumber(pointN)].name = "deleteBeforHere"
						if point.task and point.task.params and point.task.params.tasks then
							for Ntask , taskFinal in ipairs(point.task.params.tasks)  do
								if taskFinal and taskFinal.params and taskFinal.params.action and taskFinal.params.action.id == "Script" then
									if taskFinal.params.action.params and  taskFinal.params.action.params.command and string.find(taskFinal.params.action.params.command,"Custom_Altitude") then

										point.task.params.tasks[Ntask] = nil

										-- env.info( "Custom_Altitude, E1_f set name = deleteBeforHere  Npoint "..tostring(Npoint))
									end
								end
							end
						end
					end
				end
			else
				for Npoint, point in ipairs(copyRoute)  do
					local distance = math.sqrt(math.pow(point.x - actualPositionVec3.x, 2) + math.pow(point.y - actualPositionVec3.z, 2))
					if distance < 1000 then
						if point.task and point.task.params and point.task.params.tasks then
							for Ntask , taskFinal in ipairs(point.task.params.tasks)  do
								if taskFinal and taskFinal.params and taskFinal.params.action and taskFinal.params.action.id == "Script" then
									if taskFinal.params.action.params and  taskFinal.params.action.params.command and string.find(taskFinal.params.action.params.command,"Custom_Altitude") then

										point.task.params.tasks[Ntask] = nil

									end
								end
							end
						end

					end
				end
			end

			-- env.info("DEBUG: U #copyRoute " .. tostring(#copyRoute) .. " wptTag: " .. tostring(wptTag))
			if wptTag and wptTag > 0 then
				for i = #copyRoute, 1, -1 do
					if i <= wptTag then
						table.remove(copyRoute, i)
					end
				end
			end
			-- env.info("DEBUG: V #copyRoute " .. tostring(#copyRoute))

			--cherche la prochaine action pour ne pas trop calculer de wpt intermedaire
			local nWptNextCustom = 9999
			for Npoint, point in ipairs(copyRoute)  do
				if point.task and point.task.params and point.task.params.tasks then
					for Ntask, taskFinal in ipairs(point.task.params.tasks)  do
						if taskFinal and taskFinal.params and taskFinal.params.action and taskFinal.params.action.id == "Script" then
							if taskFinal.params.action.params and taskFinal.params.action.params.command
                                and (string.find(taskFinal.params.action.params.command, "Custom_SAR")
                                    or string.find(taskFinal.params.action.params.command, "Custom_AddWptSAR")
									or string.find(taskFinal.params.action.params.command, "Custom_Altitude")
									) then

								local convertedNpoint = tonumber(Npoint) -- Conversion sécurisée
								if convertedNpoint then
									nWptNextCustom = convertedNpoint
								end

							end
						end
					end
				end
			end


            local copyRoute2 = {}
			
			for n = 1, #copyRoute - 1 do
				
				if n > nWptNextCustom then    --ne pas ajouter trop de wpt, sinon ça plante DCS (75 wpt max)
					break
				end

				if n == 1 then    --force la position de l'etat actuel
					copyRoute[1].x = actualPositionXY.x
					copyRoute[1].y = actualPositionXY.y
				end

                --actualise l'alti:
				copyRoute[n].alt = getTerrainCachedLocal(copyRoute[n].x, copyRoute[n].y)
				copyRoute[n].alt_type = "RADIO"

                table.insert(copyRoute2, copyRoute[n])
				--l'alti de consigne pour n est n-1
				if n > 1 then
					copyRoute2[#copyRoute2 - 1].alt = copyRoute2[#copyRoute2].alt
				end
				
				local dx = copyRoute[n].x - copyRoute[n + 1].x
				local dy = copyRoute[n].y - copyRoute[n + 1].y

				local distance = math.sqrt(dx * dx + dy * dy)
				
				local terrainType = "FLAT"

				local dist2 = GetDistance2D(copyRoute[n], copyRoute[n+1])

                if dist2 < 1 then
					--on ne fait rien, on garde le wpt initial et le suivant
					terrainType = "FLAT"
				else
					if distance > 1 then

						local stepScan = distance / 10

						if stepScan < 1 then
							stepScan = distance
						end

						for scanDist = 0, distance, stepScan do

							local pScan = getOffset(
								copyRoute[n],
								GetHeading(copyRoute[n], copyRoute[n+1]),
								scanDist
							)

							local zoneType = getTerrainZone(pScan)

							if zoneType == "MOUNTAIN" then
								terrainType = "MOUNTAIN"
								break

							elseif zoneType == "HILL" and terrainType ~= "MOUNTAIN" then
								terrainType = "HILL"
							end
						end
					end
				end


				local path = nil
				local compteurN = 0

                if terrainType == "FLAT" then
					
                    Perf_CustAlt[grpName]["N_Flat"] = Perf_CustAlt[grpName]["N_Flat"] + 1
					
				elseif terrainType == "HILL" then
				
					path, compteurN = ComputeHillPath(
						copyRoute2[#copyRoute2],
						copyRoute[n + 1],
						addAlti
					)
					
					if compteurN then
						Perf_CustAlt[grpName]["N_Hill"] = Perf_CustAlt[grpName]["N_Hill"] + compteurN
					else
						env.info("DCE_BUG N_Hill compteurN nil ")
					end
					if not path or #path == 0 then
						env.info("DEBUG: no bestNode, path HILL == 0")
						path = {
							copyRoute[n + 1]
						}
					end
					if #copyRoute2 + #path > 70 then
						break
					end
					for _, p in ipairs(path) do
						local wpt = {
							x = p.x,
							y = p.y,
							alt = p.alt,
							name = "AddByCustAlt HILL",
							alt_type = p.alt_type,
							speed = copyRoute[n].speed,
							action = "Fly Over Point",
							type = "Turning Point"
						}
						if #copyRoute2 >= 70 then
							break
						end

						table.insert(copyRoute2, wpt)
						--l'alti de consigne pour n est n-1
						if n > 1 then
							copyRoute2[#copyRoute2 - 1].alt = copyRoute2[#copyRoute2].alt
						end
					end
				else	--terrainType == "Mountain"

					local setTrail = false

					path, compteurN = ComputeMountainPath(
						copyRoute2[#copyRoute2],
						copyRoute[n + 1],
						addAlti,
						altiMax
					)
					if compteurN then
						Perf_CustAlt[grpName]["N_Mountain"] = Perf_CustAlt[grpName]["N_Mountain"] + compteurN
					else
						env.info("DCE_BUG N_Mountain compteurN nil ")
					end

					if not path or #path == 0 then
						env.info("DEBUG: no bestNode, path Mountain == 0")
						path = {
							copyRoute[n + 1]
						}
					end
					if #copyRoute2 + #path > 70 then
						break
					end
					for _, p in ipairs(path) do
						local wpt = {
							x = p.x,
							y = p.y,
							name = "AddByCustAlt Mountain",
							alt = p.alt,
							alt_type = p.alt_type,
							speed = copyRoute[n].speed,
							action = "Fly Over Point",
							type = "Turning Point",
							task = 
							{
								["id"] = "ComboTask",
								["params"] = 
								{
									["tasks"] = 
									{
									},
								},
							},
						}
						
						-- pour passer dans les vallées, il faut etre en file indienne trail
						if not setTrail then

							wpt.task = wpt.task or {}
							wpt.task.params = wpt.task.params or {}
							
							wpt.task.params.tasks =
							{
								["enabled"] = true,
								["auto"] = false,
								["id"] = "WrappedAction",
								["number"] = 1,
								["params"] =
								{
									["action"] =
									{
										["id"] = "Option",
										["params"] =
										{
											["value"] = 720896,
											["name"] = 5,
											["formationIndex"] = 11,
										},
									}, 
								},
							}
							setTrail = true
						end

						if #copyRoute2 >= 70 then
							break
						end
						
						table.insert(copyRoute2, wpt)
						--l'alti de consigne pour n est n-1
						if n > 1 then
							copyRoute2[#copyRoute2 - 1].alt = copyRoute2[#copyRoute2].alt
						end
					end

				end

                if #copyRoute2 > 50 then break end
				
			end


            --ajoute les waypoint apres nWptNextCustom, de copyRoute dans copyRoute2 sans modification d'altitude
			for n = nWptNextCustom + 1, #copyRoute do
				table.insert(copyRoute2, copyRoute[n])
			end

			local mission = {
					id = 'Mission',
					params = {
						route = {
							points = copyRoute2
						},
					}
				}

			if campL.debug then
				local logStr = "Mission = " .. TableSerialization(mission, 0)
				local grpnameClean = grpName:gsub('[%p%c%s]', '_')
				local logFile = io.open(
				PathDCE .. "Debug\\Custom_Altitude_" .. grpnameClean .. "_C_A_" .. current_time ..
				".lua", "w")
				if logFile then
					logFile:write(logStr)
					logFile:close()
				else
					env.info("DCE_Custom_Altitude_: Failed to open log file for writing.")
				end
			end

			Controller.setTask(ctr, mission)

			LastInjectFlightPlan[gpGid] = mission
			
		end
	

		if campL.debug then
			local dt = os.clock() - t0
			Perf_CustAlt[grpName].timeExecute = dt
		end
	end

	execute()
		
	if campL.debug then
		local dt = os.clock() - t_init
		Perf_K = Perf_K + dt
		Perf_CustAlt[grpName]["timeTotal"] = dt

		Perf_CustAlt[grpName].N_Terrain = TerrainStats_N
        Perf_CustAlt[grpName].TerrainStats_Cache_N = TerrainStats_Cache_N
		Perf_CustAlt[grpName].Detail = TerrainStats_DETAIL

        _affiche(Perf_CustAlt, "Perf_CustAlt: ")
		
	end

end ]]

----------------------------------------------------------------------------------------------------
------------------------------------- Custom_Altitude task -----------------------------------------
----------------------------------------------------------------------------------------------------
-- cache global du relief pour eviter les appels repetes a land.getHeight
TerrainHeightCache = {}

-- retourne l'altitude terrain avec mise en cache (precision par pas de 50m)
-- pourquoi: evite des milliers d'appels couteux a land.getHeight
function GetTerrainHeightCached(arg_x, arg_y)
	local qx = math.floor(arg_x / 50)
	local qy = math.floor(arg_y / 50)
	local key = qx .. "_" .. qy

	local cached = TerrainHeightCache[key]
	if cached then
		TerrainStats_Cache_N = TerrainStats_Cache_N + 1
		return cached
	end

	local h = land.getHeight({ x = arg_x, y = arg_y })
    TerrainHeightCache[key] = h
	
    TerrainStats_N = TerrainStats_N + 1
	
	return h
end




-- =========================================
-- Cache terrain LOCAL Custom_Altitude
-- Pourquoi : réduire drastiquement les appels land.getHeight
-- Résolution volontairement grossière (hélico)
-- =========================================
-- local terrainCache = {}
-- local terrainCellSize = 100  -- mètres (50–150 ok pour hélico)

-- local function getTerrainCachedLocal(x, y)
-- 	local cx = math.floor(x / terrainCellSize)
-- 	local cy = math.floor(y / terrainCellSize)
-- 	local key = cx .. ":" .. cy

-- 	if terrainCache[key] then
-- 		TerrainStats_Cache_N = TerrainStats_Cache_N + 1
-- 		return terrainCache[key]
-- 	end

-- 	local h = land.getHeight({ x = x, y = y })
-- 	terrainCache[key] = h
-- 	return h
-- end

AltiMaxHeli = {
	["UH-1H"] = 2000,
	["AH-64D"] = 3505,
	["AH-64D_BLK_II"] = 2990,
	["SH-3D"] = 2500,
	["SA342M"] = 2000,
	["SA342L"] = 2000,
	["SA342Minigun"] = 2000,
	["Mi-8MT"] = 3960,
	["Mi-24P"] = 1500,
	["Mi-24V"] = 1500,
	["Mi-26"] = 1500,

}



--adapte l'altitude aux chaines montagneuse
function Custom_Altitude(grpName, wptAlti, wptTag)
	
    local t_init
	
	TerrainStats_N = 0
    TerrainStats_Cache_N = 0
	
	if campL.debug then
		t_init = os.clock()
		Perf_K_N = Perf_K_N + 1
	end

    if not Perf_CustAlt then
        Perf_CustAlt = {}
    end
	
	if not Perf_CustAlt[grpName] then
		Perf_CustAlt[grpName] = {
			-- N_interval = 0,
			N_addHeading = 0,
			timeTotal = 0,
            TerrainStats_N = 0,
			TerrainStats_Cache_N = 0,
			N_interval = 0,
		}
	end


	if wptTag then
		wptTag = tonumber(wptTag) or 0
	else
		wptTag = 0
	end
	
    if not wptAlti or wptAlti == nil then
        wptAlti = 1
        env.info("Custom_Altitude, B1 wptAlti  11|" .. tostring(grpName) .. " |wptAlti: " .. tostring(wptAlti))
    end
	
    local current_time = timer.getTime()

	local localTerrainCache = {}
	
	local function getTerrainLocal(x, y)
		local k = math.floor(x / 50) .. "_" .. math.floor(y / 50)

		local h = localTerrainCache[k]
		if not h then
			h = GetTerrainHeightCached(x, y)
			localTerrainCache[k] = h
		end
		return h
	end

	-- =================================================
	-- Cherche un point bas proche (vallée locale)
	-- Pourquoi : sauver un WP trop haut
	-- =================================================
	local function findNearbyValley(origin, heading, maxDist)
		local best = nil
		local bestAlt = 999999

		for angle = -90, 90, 15 do
			local hdg = heading + angle

			for d = 200, maxDist, 200 do
				local p = GetOffsetPoint(origin, hdg, d)
				local h = getTerrainLocal(p.x, p.y)

				if h < bestAlt then
					bestAlt = h
					best = p
				end
			end
		end

		return best, bestAlt
	end

	local function execute()
		-- current_time = timer.getTime()
		local flight = Group.getByName(grpName)

		local selectedMember
		local wingman = flight:getUnits()

		local injectTrail = false

		for memberN, _unit in ipairs(wingman) do
			if _unit and _unit:isExist() and _unit:isActive() and _unit:inAir() then
				selectedMember = _unit
				break
			end
		end

		if not selectedMember then
			local dt = os.clock() - t_init
			Perf_K = Perf_K + dt
			return
		end

		local ctr = selectedMember:getGroup():getController()
		local actualPositionVec3 = selectedMember:getPoint()
		local actualPositionXY = {
			x = actualPositionVec3.x,
			y = actualPositionVec3.z,
		}

		local addAlti = 150
		local str_selectedMember = selectedMember:getTypeName()

		-- local str_selectedMember = selectedMember:getTypeName()
		if type(str_selectedMember) ~= "string" then
			local dt = os.clock() - t_init
			Perf_K = Perf_K + dt
			return
		end

		if (str_selectedMember == "Mi-24P" or str_selectedMember == "UH-1H") then
			addAlti = 250
		end

		if ctr then
			local gpGid = Group.getID(flight)
			local foundAeronef = false
			local copyRoute = {}

			for tblGrpId, value in pairs(LastInjectFlightPlan) do
				if tblGrpId == gpGid then
					copyRoute = Deepcopy(value.params.route.points)
					foundAeronef = true
					break
				end
			end

			if not foundAeronef then
				copyRoute = MissGroupByName[grpName]["route"]["points"]
			end

			--enleve le script Custom_Altitude pour eviter de le reinjecter et d avoir une boucle
			if wptTag and wptTag ~= nil then
				for pointN, point in ipairs(copyRoute) do
					if tonumber(pointN) == wptTag then
						copyRoute[tonumber(pointN)].name = "deleteBeforHere"
						if point.task and point.task.params and point.task.params.tasks then
							for Ntask, taskFinal in ipairs(point.task.params.tasks) do
								if taskFinal and taskFinal.params and taskFinal.params.action and taskFinal.params.action.id == "Script" then
									if taskFinal.params.action.params and taskFinal.params.action.params.command and string.find(taskFinal.params.action.params.command, "Custom_Altitude") then
										point.task.params.tasks[Ntask] = nil

										-- env.info( "Custom_Altitude, E1_f set name = deleteBeforHere  Npoint "..tostring(Npoint))
									end
								end
							end
						end
					end
				end
			else
				for pointN, point in ipairs(copyRoute) do
					local distance = math.sqrt(math.pow(point.x - actualPositionVec3.x, 2) + math.pow(point.y - actualPositionVec3.z, 2))
					if distance < 1000 then
						if point.task and point.task.params and point.task.params.tasks then
							for Ntask, taskFinal in ipairs(point.task.params.tasks) do
								if taskFinal and taskFinal.params and taskFinal.params.action and taskFinal.params.action.id == "Script" then
									if taskFinal.params.action.params and taskFinal.params.action.params.command and string.find(taskFinal.params.action.params.command, "Custom_Altitude") then
										point.task.params.tasks[Ntask] = nil
									end
								end
							end
						end
					end
				end
			end

			if wptTag and wptTag > 0 then
				for i = #copyRoute, 1, -1 do
					if i <= wptTag then
						table.remove(copyRoute, i)
						env.info("CustomAlti F removing wpt Npoint: " .. tostring(i) .. " wptTag: " .. tostring(wptTag))
					end
				end
			end

			--cherche la prochaine action pour ne pas trop calculer de wpt intermedaire
			local nWptNextCustom = 9999
			for pointN, point in ipairs(copyRoute) do
				-- env.info("CustomAlti G checking Npoint: " .. tostring(Npoint))
				if point.task and point.task.params and point.task.params.tasks then
					for taskN, taskFinal in ipairs(point.task.params.tasks) do
						if taskFinal and taskFinal.params and taskFinal.params.action and taskFinal.params.action.id == "Script" then
							if taskFinal.params.action.params and taskFinal.params.action.params.command then
                                print("DCE Custom_Altitude G5 pointN: "..pointN.." command: "..tostring(taskFinal.params.action.params.command))
								if (string.find(taskFinal.params.action.params.command, "Custom_SAR")
                                    or string.find(taskFinal.params.action.params.command, "Custom_AddWptSAR")
									or string.find(taskFinal.params.action.params.command, "Custom_Altitude"))
                                then
									env.info("DCE Custom_Altitude G6 " )
									local convertedNpoint = tonumber(pointN) -- Conversion sécurisée
									if convertedNpoint then
                                        nWptNextCustom = convertedNpoint
										env.info("DCE Custom_Altitude G7 nWptNextCustom: " .. nWptNextCustom)
									end
								end
							end
						end
					end
				end
			end


			local copyRoute2 = {}
			env.info("DCE Custom_Altitude H nWptNextCustom: " .. tostring(nWptNextCustom))

			local valleyHeading = nil

            for n = 1, #copyRoute - 1 do
				

				-- =========================================
				-- Template waypoint Custom_Altitude
				-- Pourquoi : éviter allocations Lua répétées
				-- =========================================
				local baseInterWpt = {
					speed_locked = true,
					type = "Turning Point",
					action = "Fly Over Point",
					alt_type = "BARO",
					formation_template = "",
					name = "from Cus_tom_Alti_tude",
					ETA_locked = false,
					task = {
						id = "ComboTask",
						params = {
							tasks = {}
						}
					}
				}

				if n >= nWptNextCustom then --ne pas ajouter trop de wpt, sinon ça plante DCS (75 wpt max)
					break
				end

                if n == 1 then --force la position de l'etat actuel
                    copyRoute[1].x = actualPositionXY.x
                    copyRoute[1].y = actualPositionXY.y
                end
				--actualise l'alti:
				copyRoute[n].alt = GetTerrainHeightCached(copyRoute[n].x, copyRoute[n].y)
				copyRoute[n].alt_type = "BARO"

				local typeHeli = MissGroupByName[grpName]["units"][1]["type"]
				-- local altiHoover = AltiMaxHeli[typeHeli]
				local altiMaxHeli = AltiMaxHeli[typeHeli] or 99999

				local terrainAlt = copyRoute[n].alt

                -- if altiMaxHeli and altiMaxHeli >= copyRoute[n].alt then--C-


				--E+
				-- Anticipation relief frontal
				local lookAheadMax = 15000 -- 15 km
				local step = 800 -- pas de sondage
				local futureMax = 0

				local origin1 = {
					x = copyRoute[n].x,
					y = copyRoute[n].y
				}

				local hdg1 = GetHeading(
					origin1,
					{ x = copyRoute[n + 1].x, y = copyRoute[n + 1].y }
				)

                for d = 2000, lookAheadMax, step do
                    local p = GetOffsetPoint(origin1, hdg1, d)
                    local h = GetTerrainHeightCached(p.x, p.y)

                    if h > futureMax then
                        futureMax = h
                    end
                end

				local needValley = false

				-- Danger immédiat
				if terrainAlt > altiMaxHeli then
					needValley = true
				end

				-- Danger futur
				if futureMax + 150 > altiMaxHeli then
					needValley = true
				end
				--E+



				--C+
				-- =====================================
				-- Correction WPT trop haut → vallée
				-- Pourquoi : éviter d’ignorer le point
				-- =====================================

				local goto_skip = false

				-- Si trop haut pour l'hélico → tentative de correction
				-- if terrainAlt > altiMaxHeli then--E-
				if needValley then--E+
					local origin = {
						x = copyRoute[n].x,
						y = copyRoute[n].y
					}

					local hdg = GetHeading(
						origin,
						{ x = copyRoute[n + 1].x, y = copyRoute[n + 1].y }
					)

					-- Recherche vallée proche
					if findNearbyValley then
						local newPos, newAlt = findNearbyValley(origin, hdg, 20000)

						if newPos and newAlt then
							-- Déplacement du WPT
							copyRoute[n].x = newPos.x
							copyRoute[n].y = newPos.y
							copyRoute[n].alt = newAlt + 50

							-- Recalcul terrain
							terrainAlt = GetTerrainHeightCached(
								newPos.x,
								newPos.y
							)

							env.info("Custom_Altitude: WPT déplacé vers vallée")
						else
							goto_skip = true
						end
					else
						goto_skip = true
					end
				end


				-- Si toujours impossible → on ignore
				if goto_skip then
					env.info("Custom_Altitude: A WPT ignoré (pas de vallée)")
				else
				--C+

					env.info("Custom_Altitude: B " .. terrainAlt .. " <=? " .. altiMaxHeli)
					
                    if terrainAlt <= altiMaxHeli then
						
                        env.info("Custom_Altitude: C pass OK ")
						
						table.insert(copyRoute2, copyRoute[n])
						--l'alti de consigne pour n est n-1
						if n > 1 and #copyRoute2 >= 2 and copyRoute2[#copyRoute2 - 1] and copyRoute2[#copyRoute2 - 1].alt then
							copyRoute2[#copyRoute2 - 1].alt = copyRoute2[#copyRoute2].alt
						end	
						

						-- local distance = math.sqrt(math.pow(copyRoute[n].x - copyRoute[n + 1].x, 2) + math.pow(copyRoute[n].y - copyRoute[n + 1].y, 2))
						local dx = copyRoute[n].x - copyRoute[n + 1].x
						local dy = copyRoute[n].y - copyRoute[n + 1].y

						local distance = math.sqrt(dx * dx + dy * dy)
						
						-- local heading = GetHeading({ x = copyRoute[n].x, y = copyRoute[n].y }, { x = copyRoute[n + 1].x, y = copyRoute[n + 1].y })--E-
						
						--E+
						local heading

                        if valleyHeading then
                            heading = valleyHeading
                        else
                            heading = GetHeading(
                                { x = copyRoute[n].x, y = copyRoute[n].y },
                                { x = copyRoute[n + 1].x, y = copyRoute[n + 1].y }
                            )
                        end
						--E+
						
						local altiMax = 1

						-- local origineN = #copyRoute2
						-- local distInterWpt = 0
						local sondagePt, sondageAlti, selectedPoint, headingAlt
						local interDistance = 2500 --7500m ou 2500 m --B-
						local oldAltiMax = 0
						local oldHeadingAlt = 0

						selectedPoint = { x = copyRoute[n].x, y = copyRoute[n].y }
						oldAltiMax = GetTerrainHeightCached(selectedPoint.x, selectedPoint.y)

						--[[ --B+
						-- =========================================
						-- Pré-analyse rapide du segment
						-- Pourquoi : estimer relief global
						-- =========================================

						local roughMin = 999999
						local roughMax = 0

						for d = 0, math.min(distance, 3000), 800 do
							local p = GetOffsetPoint(
								{ x = copyRoute[n].x, y = copyRoute[n].y },
								heading,
								d
							)

							local h = GetTerrainHeightCached(p.x, p.y)

							if h < roughMin then roughMin = h end
							if h > roughMax then roughMax = h end
						end

						local roughDiff = roughMax - roughMin

						local interDistance

						if roughDiff > 900 then
							interDistance = 1200
						elseif roughDiff > 400 then
							interDistance = 1800
						else
							interDistance = 2500
						end
						--B+ ]]

						
						for interval = 1, distance, interDistance do
							if interval == 1 then
								-- selectedPoint = {x=copyRoute[n].x, y=copyRoute[n].y}
								-- oldAltiMax = land.getHeight({x =selectedPoint.x, y = selectedPoint.y})
							else
								-- prend le nouveau cap pour aller du point precedent calculé au futur point prévu par l'ancienne route
                                -- heading = GetHeading({ x = selectedPoint.x, y = selectedPoint.y }, { x = copyRoute[n + 1].x, y = copyRoute[n + 1].y })--E-
								--E+
                                if valleyHeading then
                                    heading = valleyHeading
                                else
                                    heading = GetHeading(
                                        { x = selectedPoint.x, y = selectedPoint.y },
                                        { x = copyRoute[n + 1].x, y = copyRoute[n + 1].y }
                                    )
                                end
								--E+
							end

							-- =========================================
							-- PREFILTRE terrain : faut-il chercher une vallée ?
							-- Pourquoi : éviter addHeading coûteux en terrain plat
							-- =========================================
							local preMin = 999999
							local preMax = 0

							for d = 0, interDistance, 500 do--B-
							-- for d = 0, interDistance, 800 do--B+
								local p = GetOffsetPoint(selectedPoint, heading, d)
								local h = GetTerrainHeightCached(p.x, p.y)

								if h < preMin then preMin = h end
								if h > preMax then preMax = h end
							end

							local preDiff = preMax - preMin

							-- Terrain peu accidenté → pas de recherche vallée
							local skipValleySearch = (preDiff < 200)--B-
							-- local skipValleySearch = (preDiff < 250)--B+

							local addHeadingMin = -5
							local addHeadingMax = 5
							local addDistance = 1000
							local altiMin0 = 999999
							local altiMax0 = 0
							local diffHeading = 10


							if not skipValleySearch then
								-- regarde la topographie devant l helico
								--si c est montagneux, on augmente le nb de wpt, sinon on ne fait rien ou presque
								for addHeading = -90, 90 do
									for interval0 = 0, 1500, 150 do
										local headingAlt0 = heading + addHeading
										local sondagePt0 = GetOffsetPoint(selectedPoint, headingAlt0, interval0)
										sondageAlti = GetTerrainHeightCached(sondagePt0.x, sondagePt0.y)--B-

										if altiMin0 >= sondageAlti then
											altiMin0 = sondageAlti
										end
										if altiMax0 <= sondageAlti then
											altiMax0 = sondageAlti
										end
									end
								end
							end

							local diffAlti0 = altiMax0 - altiMin0

							if diffAlti0 >= 900 then
								interDistance = 1200
							elseif diffAlti0 >= 500 then
								interDistance = 1800
							end

							if diffAlti0 >= 450 and diffAlti0 < 950 then
								addHeadingMin = -25
								addHeadingMax = 25
								addDistance = 1100
								diffHeading = 1
							elseif diffAlti0 >= 950 then
								addHeadingMin = -50
								addHeadingMax = 50
								addDistance = 400
								diffHeading = 5
							end

							local sumAlti = {}

							-- Réduction dynamique de la recherche angulaire
							if oldHeadingAlt ~= 0 and math.abs(oldHeadingAlt - heading) < 5 then
								addHeadingMin = math.max(addHeadingMin, -15)
								addHeadingMax = math.min(addHeadingMax, 15)
							end

							--B+
							-- local centerHeading = 0
							-- if oldHeadingAlt ~= 0 then
							-- 	centerHeading = oldHeadingAlt - heading
							-- end
							--B+

							--cumul les alti pour trouver la plus petite sur les differents chemin calculé
							-- calcul pour la prochaine tranche de 5000m
							-- for AddHeading = -30 , 30 do
							for addHeading = addHeadingMin, addHeadingMax do--B-
							-- for addHeading = math.max(addHeadingMin, centerHeading - 15), math.min(addHeadingMax, centerHeading + 15) do--B+
								Perf_CustAlt[grpName]["N_addHeading"] = Perf_CustAlt[grpName]["N_addHeading"] + 1

								local addHeading_str = tostring(addHeading)

								for interval0 = addDistance, interDistance, addDistance do
									headingAlt = heading + addHeading
									sondagePt = GetOffsetPoint(selectedPoint, headingAlt, interval0)
									sondageAlti = GetTerrainHeightCached(sondagePt.x, sondagePt.y)--B-
									-- sondageAlti = getTerrainLocal(sondagePt.x, sondagePt.y)--B+
								
									if not sumAlti[addHeading_str] then
										sumAlti[addHeading_str] = {}
									end
									if not sumAlti[addHeading_str]["sum"] then sumAlti[addHeading_str]["sum"] = 0 end
									if not sumAlti[addHeading_str]["altiMax"] then sumAlti[addHeading_str]["altiMax"] = 0 end
									if not sumAlti[addHeading_str]["distance"] then sumAlti[addHeading_str]["distance"] = 0 end


									sumAlti[addHeading_str]["sum"] = sumAlti[addHeading_str]["sum"] + sondageAlti
									sumAlti[addHeading_str]["distance"] = interval0

									if sumAlti[addHeading_str]["altiMax"] < sondageAlti then
										sumAlti[addHeading_str]["altiMax"] = sondageAlti
									end
								end

								
								--regarde l'alti max sur une tres longue distance, pour ne pas s orienter vers une trop grande montagne
								for interval0 = 600, 10000, 500 do--B-
								-- for interval0 = 600, 10000, 800 do--B+
							
									Perf_CustAlt[grpName]["N_interval"] = Perf_CustAlt[grpName]["N_interval"] + 1

									headingAlt = heading + addHeading
									sondagePt = GetOffsetPoint(selectedPoint, headingAlt, interval0)
									-- sondageAlti = GetTerrainHeightCached(sondagePt.x, sondagePt.y) --B-
									sondageAlti = getTerrainLocal(sondagePt.x, sondagePt.y)--B+
								
									-- if sondageAlti > 3000 then--B+
									-- 	break
									-- end


									if not sumAlti[addHeading_str] then
										sumAlti[addHeading_str] = {}
									end
									if not sumAlti[addHeading_str]["altiMaxLong"] then sumAlti[addHeading_str]["altiMaxLong"] = 0 end

									if sumAlti[addHeading_str]["altiMaxLong"] < sondageAlti then
										sumAlti[addHeading_str]["altiMaxLong"] = sondageAlti

									end
								end

							end


							if skipValleySearch then
								sumAlti = {
									["0"] = {
										sum = preMax,
										altiMax = preMax,
										altiMaxLong = preMax,
										distance = interDistance
									}
                                }
								valleyHeading = nil --E+
							end

							


							--selectionne la route ou la somme d'alti est la plus faible, cela fait suivre les vallees :)
							-- et evite toutes les directions où l'alti est trop haute
							local selectHdg = 0
							local selectSum = 999999

							--regarde si au moins un cap est inferieur à l altiMaxLong
							local foundLowAltiMaxLong = false
							for addHdg_N, value in pairs(sumAlti) do
								if sumAlti[tostring(addHdg_N)].altiMaxLong < 2500 then
									foundLowAltiMaxLong = true
									break
								end
							end


							for addHdg_N, value in pairs(sumAlti) do
								local addHdg_N_str = tostring(addHdg_N)
								if foundLowAltiMaxLong then
									if sumAlti[addHdg_N_str].sum < selectSum and sumAlti[addHdg_N_str].altiMaxLong < 3500 then
										selectSum = sumAlti[addHdg_N_str].sum
										local convertHdg = tonumber(addHdg_N)
										if convertHdg then
											selectHdg = convertHdg
										end
									end
								elseif sumAlti[addHdg_N_str].sum < selectSum then
									selectSum = sumAlti[addHdg_N_str].sum
									local convertHdg = tonumber(addHdg_N)
									if convertHdg then
										selectHdg = convertHdg
									end
								end
							end

                            -- altiMax = sumAlti[tostring(selectHdg)].altiMax--C-
							--C+
							local sel = sumAlti[tostring(selectHdg)]
							if not sel then break end
                            altiMax = sel.altiMax
							--C+

							headingAlt = heading + tonumber(selectHdg)
							valleyHeading = headingAlt--E+

							local selectedPointNew = GetOffsetPoint(selectedPoint, headingAlt,
								sumAlti[tostring(selectHdg)].distance)
							selectedPoint = selectedPointNew

							local printAltiMaxLong = 0
							if sumAlti[tostring(selectHdg)] and sumAlti[tostring(selectHdg)].altiMaxLong then
								printAltiMaxLong = math.floor(sumAlti[tostring(selectHdg)].altiMaxLong)
							end

							local alt_type = "BARO"
							
							if (math.abs(oldAltiMax - altiMax) > 300 or math.abs(oldHeadingAlt - headingAlt) > diffHeading) then
								oldAltiMax = altiMax
								oldHeadingAlt = headingAlt
							
								
								-- Altitude calculée par terrain
								local alti = altiMax + addAlti

								-- Sécurité montagne lointaine
								-- if printAltiMaxLong >= 3500 then
								if printAltiMaxLong >= 3500 then
									alti = printAltiMaxLong + addAlti
								end
								
								-- Sécurité minimale au-dessus du sol
								local ground = GetTerrainHeightCached(selectedPoint.x, selectedPoint.y)

								if alti < ground + 50 then
									alti = ground + 50
								end

								-- Construction légère du waypoint
								local interWpt = {}
								for k, v in pairs(baseInterWpt) do
									interWpt[k] = v
								end

								interWpt.x = selectedPoint.x
								interWpt.y = selectedPoint.y
								interWpt.alt = tonumber(alti)
								interWpt.alt_type = tostring(alt_type)
								interWpt.speed = tonumber(copyRoute[n].speed)
								interWpt.ETA = (interval / copyRoute[n].speed) + copyRoute[n].ETA

								-- pour passer dans les vallées, il faut etre en file indienne trail
								--TODO revenir à une formation standart si on sort des vallées ou relief
								--diffHeading = 1
								if not injectTrail and (#copyRoute2 == 2)  then
									interWpt.task.params.tasks =
									{
										["enabled"] = true,
										["auto"] = false,
										["id"] = "WrappedAction",
										["number"] = 1,
										["params"] =
										{
											["action"] =
											{
												["id"] = "Option",
												["params"] =
												{
													["value"] = 720896,
													["name"] = 5,
													["formationIndex"] = 11,
												}, -- end of ["params"]
											}, -- end of ["action"]
										}, -- end of ["params"]
									}

									injectTrail = true
								end

								if alti > altiMaxHeli then
									table.insert(copyRoute2, interWpt)

									--l'alti de consigne pour n est n-1
									if n > 1 and #copyRoute2 >= 2 and copyRoute2[#copyRoute2 - 1] and copyRoute2[#copyRoute2 - 1].alt then
										copyRoute2[#copyRoute2 - 1].alt = copyRoute2[#copyRoute2].alt
									end
								end


								altiMax = 1
							end
							if #copyRoute2 > 50 then break end
						end
					end
				end

				--ajuste l'altitude des wpt d origine:
				-- if origineN > 1 then
				-- 	-- local altitude = land.getHeight({ x = copyRoute2[origineN].x, y = copyRoute2[origineN].y })
				-- 	local altitude = getTerrainCachedLocal(copyRoute2[origineN].x, copyRoute2[origineN].y)
				-- 	if copyRoute2[origineN - 1].alt > altitude then
				-- 		altitude = copyRoute2[origineN - 1].alt
				-- 	end
				-- 	copyRoute2[origineN].alt = altitude
				-- end
			end

			-- --supprime le premier wpt, sinon l'helico revient sur ses pas.
			-- table.remove(copyRoute2, 1)

			--ajoute les waypoint apres nWptNextCustom, de copyRoute dans copyRoute2 sans modification d'altitude
            for n = nWptNextCustom + 1, #copyRoute do
                table.insert(copyRoute2, copyRoute[n])
            end

			local mission = {
				id = 'Mission',
				params = {
					route = {
						points = copyRoute2
					},
				}
			}

			if campL.debug then
				local logStr = "Mission = " .. TableSerialization(mission, 0)
				local grpnameClean = grpName:gsub('[%p%c%s]', '_')
				local logFile = io.open(
					PathDCE .. "Debug\\Custom_Altitude_" .. grpnameClean .. "_C_A_" .. current_time ..
					".lua", "w")
				if logFile then
					logFile:write(logStr)
					logFile:close()
				else
					env.info("DCE_Custom_Altitude_: Failed to open log file for writing.")
				end
			end

			Controller.setTask(ctr, mission) --activate task with mission for retreat AWACS
		end

	end


	execute()

	if campL.debug then
		local dt = os.clock() - t_init
		Perf_K = Perf_K + dt
		Perf_CustAlt[grpName]["timeTotal"] = dt

		Perf_CustAlt[grpName].TerrainStats_N = TerrainStats_N
		Perf_CustAlt[grpName].TerrainStats_Cache_N = TerrainStats_Cache_N

		_affiche(Perf_CustAlt, "Perf_CustAlt: ")
	end
	
end
