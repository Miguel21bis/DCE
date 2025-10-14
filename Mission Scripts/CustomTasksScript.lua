-- --To provide custom AI Attack Tasks 
--Script attached to mission and executed via trigger
--Functions accessed via LUA Run Script on waypoint
------------------------------------------------------------------------------------------------------- 
-- last modification:  M68_b cleanCode_d
if not versionDCE then versionDCE = {} end
versionDCE["Mission Scripts/CustomTasksScript.lua"] = "1.9.44"
------------------------------------------------------------------------------------------------------- 
-- Reglage_n				(n force RTB)(m stopcondition)(l escorte)(k CVN to CV)(j altitudeEnabled true)(h GetHeading)(global path)(f rejoin debug)(e more scheduleFunction) (d landingImpossible denivelé)(c: limit =  1 ?)(b: orbit infini) all ["groupAttack"] = false,
-- cleanCode_d				(c GetCategory)(b springCleaning)
-- Debug_h					(fgh: CAS AttackUnit)(e: static id -1)(d: Checking) creates custom files to observe (c: Helicopter)(b: strike bombing)(a: strike ASM B52)

-- modification M74_a		mix static, vehicle and map elements in a Target.
-- modification M68_b		add AFAC task (b CustomDesignation)
-- modification M61_j		SAR (j noSAR in wrongSide)(d Custom_Altitude-follow the valleys)(b debug+shifts task injections) 
-- modification M54_b		revoir CustomTaskScript et TaskBombing (b: add duration)
-- modification M45_a		compatible with 2.7.0

------------------------------------------------------------------------------------------------------- 


local varFpsLeak = false
local varFpsLeak_B = false
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
function CustomGroupAttack(arg_FlightName, arg_TargetName, arg_Expend, arg_WeaponType, arg_AttackType, arg_AttackAlt, arg_Id_task)
	if varFpsLeak then return end
	env.info("DCE_CustomGroupAttack start| "..tostring(arg_FlightName))

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

		if camp.debug then
			--export custom mission log
			local logStr = "ComboTask = " .. TableSerialization(arg2_ComboTask, 0)
			local flightNameClean = arg_FlightName:gsub('[%p%c%s]', '_')
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

	local targetGroup = Group.getByName(arg_TargetName)						--get target group
	if targetGroup then													--target group exists
		local idTypeStrike = "Bombing"
		-- if (weaponType == 4161536 or weaponType == 14) and id_task == "CAS" then	-- Guided bombs or ASM M54_a
		if arg_Id_task == "CAS" or arg_Id_task == "Pinpoint Strike" then												--  M54_a		
			idTypeStrike  = "AttackUnit"
		else
			idTypeStrike  = "Bombing"
		end

		if attackCounter[arg_TargetName] then								--counter with number of flights that have already attacked this target
			attackCounter[arg_TargetName] = attackCounter[arg_TargetName] + 1	--increase counter by one
		else															--no flight has attacked this target yet
			attackCounter[arg_TargetName] = 1								--set to one
		end
		local attackN = attackCounter[arg_TargetName]

		local target = targetGroup:getUnits()							--get target units

		if arg_AttackType ~= "Dive" then
			arg_AttackType = nil
		end

		local flight = Group.getByName(arg_FlightName)						--get group of attacking flight
		local wingman = flight:getUnits()								--get list of units from attacking flights

		local egressWP
		for coalition_name,coal in pairs(env.mission.coalition) do
			local stop = false
			for country_n,country in pairs(coal.country) do
				if country.plane then
					for group_n,group in pairs(country.plane.group) do
						-- if FlightName == env.getValueDictByKey(group.name) then								--find group in env.mission
						if arg_FlightName == group.name then
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
						if arg_FlightName == group.name then
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
		end

		for n = 1, #wingman do											--iterate through all aircraft in flight
			local cntrl
			if n == 1 then												--for leader
				cntrl = flight:getController()							--get controller of group
			else														--for wingmen
				cntrl = wingman[n]:getController()						--get controller of individual aircraft in flight
				-- cntrl:resetTask()					
				-- cntrl:setOption(AI.Option.Air.id.REACTION_ON_THREAT, 2) 	--set to evade fire again, as controller for individual unit does not take over options from parent group
			end

			local unitObj = flight:getUnit(n)
			local ammo = unitObj:getAmmo()
			for k,v in pairs(ammo) do
				local ammo_string = "wingmann "..n.." count: "..tostring(v.count).." t: ".. tostring(v.desc.category).." typeName: ".. tostring(v.desc.typeName)
				env.info("DCE_CustomGroupAttack: ammo_string |"..ammo_string)
			end


			local ComboTask = {											--define combo task to hold multiple attack tasks
				id = 'ComboTask',
				params = {
					tasks = {},
				},
			}

			for t = #target, 1, -1 do										--iterate thourgh targets
				if not target[t]:isExist() then
					env.info("DCE_CustomGroupAttack |"..tostring(t))
					table.remove(target, t)
				end
			end

			for t = 1, #target do										--iterate thourgh targets

				--each wingman gets one attack task for each target
				local num = t + math.ceil((n - 1) * (#target / #wingman))	--distribute target numbers across flight
				num = num + attackN - 1										--increase target number to adjust for previous attacks
				while num > #target do
					num = num - #target
				end

				env.info("DCE_CustomGroupAttack num? |"..tostring(num))

				local task_entry = {									--define attack task
					["enabled"] = true,
					["auto"] = false,
					["id"] =  "Bombing",
					["number"] = #ComboTask.params.tasks + 1,
					["params"] = {
						["x"] = target[num]:getPoint().x,
						["y"] = target[num]:getPoint().z,
						["expend"] = arg_Expend,
						["weaponType"] = tonumber(arg_WeaponType),
						["groupAttack"] = false,
						["attackType"] = arg_AttackType,
						["attackQtyLimit"] = false,
						["attackQty"] = 1,
						-- ["altitudeEdited"] = true,
						["altitudeEnabled"] = true,
						["altitude"] = tonumber(arg_AttackAlt),
						["directionEnabled"] = false,
						["direction"] = 0,
					},
				}

				if arg_AttackAlt and tonumber(arg_AttackAlt) > 0 then
					task_entry.altitudeEnabled = true
				end

				--auto expend
				if ((arg_Expend == "Auto" or target[num]:getDesc().category == 3) and idTypeStrike == "AttackUnit") or idTypeStrike == "AttackUnit"  then		--if auto expend or target unit is a ship
					local existId = tonumber(target[num]:getID())
					env.info("DCE_CustomGroupAttack existId? |"..tostring(existId))
					if existId   then
						env.info("DCE_CustomGroupAttack: passe G1 ")
						task_entry.id = "AttackUnit"									--attack unit instead of bombing task
						task_entry.params.unitId = existId
					end

					if existId ~= nil and existId ~= false  then
						env.info("DCE_CustomGroupAttack: passe G2 ")
					end
				end

				if arg_Expend == "All" and t > 1 and arg_WeaponType ~= "ASM" then
					env.info("DCE_CustomGroupAttack: passe G3 ")
					break
				end

				env.info("DCE_CustomGroupAttack |"..tostring(arg_FlightName).."| |"..tostring(task_entry["id"]))

				table.insert(ComboTask.params.tasks, task_entry)
			end

			if n > 1 and egressWP.x then												--for all wingmen
				local MissionTask = {									--mission task to store go-to Egress waypoint task for wingmen (wingmen need to fly to Egress individually, otherwise out-of-formation flight will not climb during egress)
					id = 'Mission',
					params = {
						route = {
							points = {}
						}
					}
				}
				table.insert(MissionTask.params.route.points, egressWP)	--add egress waypoint into MissionTask
				MissionTask.params.route.points[1].x = MissionTask.params.route.points[1].x + math.random(-500, 500)	--add some randomness to egress waypoint location to prevent all aircraft in flight converging on same point
				MissionTask.params.route.points[1].y = MissionTask.params.route.points[1].y + math.random(-500, 500)
				MissionTask.params.route.points[1].alt = MissionTask.params.route.points[1].alt + math.random(-100, 100)
				table.insert(ComboTask.params.tasks, MissionTask)		--add mission task fly to Egress waypoint individually, where the task will end and the wingmen will join their leader
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
			timer.scheduleFunction(execute, {cntrl, ComboTask, n} ,nextSecond)
			-- timer.scheduleFunction(execute, {cntrl, ComboTask, n} , timer.getTime() + n*0.5)

		end		--local function execute(n)
	end
end


----- attack multiple static objects -----
--allows each wingman of a flight to attack its own individual target simultaneously, then proceed to Egress point to join up (flight would not climb during egress if wingmen would joing leader imediately after attack)
function CustomStaticAttack(flightName, targetList, expend, weaponType, attackType, attackAlt, id_task)
	if varFpsLeak then return end
	env.info("DCE_CustomStaticAttack | start| "..tostring(flightName))

	local function execute(arg)
		local cntrl = arg[1]
		local comboTask = arg[2]
		local n = arg[3]
		local current_time = timer.getTime()

		if camp.debug then
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
	if varFpsLeak then return end
	env.info("DCE_CustomMixClassAttack | start| "..tostring(flightName))

	--{cntrl, comboTask, n}
	local function execute(arg)
		local cntrl = arg[1]
		local comboTask = arg[2]
		local n = arg[3]
		local current_time = timer.getTime()

		if camp.debug then
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

	for n = 1, #wingman do											--iterate through all aircraft in flight
		local cntrl
		if n == 1 then												--for leader
			cntrl = flight:getController()							--get controller of group
		else														--for wingmen
			cntrl = wingman[n]:getController()						--get controller of individual aircraft in flight
			cntrl:setOption(AI.Option.Air.id.REACTION_ON_THREAT, 2) 	--set to evade fire again, as controller for individual unit does not take over options from parent group
		end

		local comboTask = {											--define combo task to hold multiple attack tasks
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
					targetTempPos ={
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
				targetTempPos ={
					x = targetX,
					y = targetY,
				}
				targetTemp = true
				idTypeStrike  = "Bombing"

				-- env.info("DCE_CustomMixClassAttack MapObject found BB2 |"..tostring(targetName).."|")
				
			elseif  targetClass == "nil" then
				targetTempPos ={
					x = targetX,
					y = targetY,
				}
				targetTemp = true
				idTypeStrike  = "Bombing"

				-- env.info("DCE_CustomMixClassAttack MapObject found BB22 |"..tostring(targetName).."|")
				
			else --if targetClass == "vehicle" then
				targetTemp = Unit.getByName(targetName)
				if targetTemp then
					targetTempPos ={
						x = targetTemp:getPoint().x,
						y = targetTemp:getPoint().z,
					}
					-- idTypeStrike  = "AttackUnit"
					-- targetID = targetTemp:getID()

					idTypeStrike  = "Bombing"

					-- env.info("DCE_CustomMixClassAttack vehicle found BB3 |"..tostring(targetName).."|")
				end
			end

			if targetTemp then							--make sure that static object still exists
				-- env.info("DCE_CustomMixClassAttack: DD1 ")

				local task_entry = {									--define attack task
					["enabled"] = true,
					["auto"] = false,
					["id"] = idTypeStrike,
					["name"] = "task: "..tostring(id_task).." class: "..tostring(targetClass),
					["number"] = #comboTask.params.tasks + 1,
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
				if  idTypeStrike == "AttackUnit" then
					task_entry["id"] = "AttackUnit"
					task_entry.params["unitId"] = tonumber(targetID)
					task_entry.params["attackQtyLimit"] = false
					task_entry.params["x"] = nil
					task_entry.params["y"] = nil
				end

				-- env.info("DCE_CustomMixClassAttack: DD2 |"..tostring(FlightName).."| |"..tostring(task_entry["id"]))

				table.insert(comboTask.params.tasks, task_entry)

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

		timer.scheduleFunction(execute, {cntrl, comboTask, n} , nextSecond)

	end
end
----- attack multiple map objects -----
--allows each wingman of a flight to attack its own individual target simultaneously, then proceed to Egress point to join up (flight would not climb during egress if wingmen would joing leader imediately after attack)
function CustomMapObjectAttack(FlightName, TargetList, expend, weaponType, attackType, attackAlt, id_task)
	if varFpsLeak then return end
	env.info("DCE_CustomMapObjectAttack:  | start| "..tostring(FlightName))

	local idTypeStrike  = "Bombing"

	local function execute(arg)
		local cntrl = arg[1]
		local ComboTask = arg[2]
		local n = arg[3]
		local current_time = timer.getTime()

		if camp.debug then
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
	if varFpsLeak then return end
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

			if camp.debug then
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
	if varFpsLeak then return end

	-- local test = true
	-- if test then return end

	env.info("DCE_CustomRejoin | start| "..tostring(FlightName))

	local function execute(cntrl)
		cntrl:resetTask()												--reset task (wingman will rejoin with leader)

		if camp.debug then

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
	if varFpsLeak then return end
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
	if varFpsLeak then return end
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
	if varFpsLeak then return end

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

	env.info("DCE_CustomDesignationAFAC() AA : START "..tostring(afacFlightName))
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
			env.info("DCE_CustomDesignationAFAC() AAb : unitAFAC:isExist "..tostring(afacFlightName))
	else
		AFAC_available[afacFlightName] = nil
		env.info("DCE_CustomDesignationAFAC() AAc : else AFAC_available = nil "..tostring(afacFlightName))
	end

	local afacPosVec3 = unitAFAC:getPoint()
	local afacAlt = afacPosVec3.y
	local terrainAlt = land.getHeight({x = afacPosVec3.x, y = afacPosVec3.z})
	local distVisibility = distanceVisibilite(afacAlt, terrainAlt)
	-- env.info("DCE_CustomDesignationAFAC() BB : afacFlightName "..tostring(afacFlightName).." afacAlt: "..tostring(afacAlt).." terrainAlt: "..tostring(terrainAlt).." distVisibility: "..tostring(distVisibility))

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

			-- 2025-03-17 17:46:19.194 INFO    SCRIPTING (Main): DCE_CustomDesignationAFAC() AA : START Pack 22 - 504th FAC - AFAC 1
			-- 2025-03-17 17:46:19.194 INFO    SCRIPTING (Main): DCE_CustomDesignationAFAC() BB : afacFlightName Pack 22 - 504th FAC - AFAC 1 afacAlt: 593.51824187668 distVisibility: 16.745217794847
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
function CustomDesignationAFAC(arg_AFAC_F_Name, arg_refX, arg_refY, arg_LaserCode)
	if varFpsLeak then return end
	
    env.info("DCE_CustomDesignationAFAC() AA : START " .. tostring(arg_AFAC_F_Name))
	
	if LastInjecAFAC[arg_AFAC_F_Name] and LastInjecAFAC[arg_AFAC_F_Name] < timer.getTime() + 30 then
		env.info("DCE_CustomDesignationAFAC() DCE_ERROR AFAC 00 BUG RETURN : "..tostring(arg_AFAC_F_Name).." LastInjecAFAC: "..tostring(LastInjecAFAC[arg_AFAC_F_Name]))
		return
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

	local laser														--variable to hold the laser spot
	local flightGroup = Group.getByName(arg_AFAC_F_Name)
	local coalitionId = flightGroup:getCoalition()
	local unitsAFAC = flightGroup:getUnits()
	local unitAFAC = unitsAFAC[1]

	if unitAFAC and unitAFAC:isExist() then

		coalitionId = unitAFAC:getCoalition()
		
		AFAC_available[arg_AFAC_F_Name] = {
				["unitAFAC"] = unitAFAC,
				["sideNum"] = coalitionId,
			}

	else
		AFAC_available[arg_AFAC_F_Name] = nil
		env.info("DCE_CustomDesignationAFAC() DCE_INFO AAc : else "..tostring(arg_AFAC_F_Name))
		return
	end

	local afacPosVec3 = unitAFAC:getPoint()
	local afacAlt = afacPosVec3.y
	local terrainAlt = land.getHeight({x = afacPosVec3.x, y = afacPosVec3.z})
	local distVisibility = distanceVisibilite(afacAlt, terrainAlt)

	--****--****--****--**** ********--****--****--**** ********--****--****--**** ********--****--****--**** ****
	--**** recupere les dynamique ****
	--****--****--****--**** ********--****--****--**** ********--****--****--**** ********--****--****--**** ****
	local groundGroups = coalition.getGroups(CoalitionIdToENI_Id[coalitionId], Group.Category.GROUND)
	local unitGroundSelected_A = {}
	local unitGroundSelected_B = {}

	for i, gp in pairs(groundGroups) do
		local groundUnits = gp:getUnits()
		for n=1, #groundUnits do
			local grndUnit = groundUnits[n]
			if grndUnit:isActive()  then

				local description = grndUnit:getDesc()
				local life = description.life
				local unitPosVec3 = grndUnit:getPoint()
				local UnitId = Unit.getID(grndUnit)
				local unitTypeName = grndUnit:getTypeName()
				local distance = math.floor(math.sqrt(math.pow(unitPosVec3.x - arg_refX, 2) + math.pow(unitPosVec3.z - arg_refY, 2)))
				
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


	--****--****--****--**** ********--****--****--**** ********--****--****--**** ********--****--****--**** ****
	--**** recupere les static ****
	--****--****--****--**** ********--****--****--**** ********--****--****--**** ********--****--****--**** ****
    local statics = coalition.getStaticObjects(CoalitionIdToENI_Id[coalitionId])
	
    for _, static in pairs(statics) do
		local stName = Object.getName(static)
		local stLife = static:getLife()

		if stLife > 0 then

			local desc = static:getDesc()
			local life = desc.life
			local unitPosVec3 = static:getPoint()
			local UnitId = static:getID()
			local unitTypeName = static:getTypeName()
			local distance = math.floor(math.sqrt(math.pow(unitPosVec3.x - arg_refX, 2) + math.pow(unitPosVec3.z - arg_refY, 2)))

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

	--**** choisi THE target ^^ ****
	local target = next(unitGroundSelected_B) and unitGroundSelected_B[next(unitGroundSelected_B)] or nil

	if not target then
		return
	end

	-- set la partie FLAG du target pour suivre son etat et déclencher l'arret de l orbit et le passage au target suivant
	trigger.action.setUserFlag("targetDestroyed_Flag_"..target.UnitId, 0)
	AFAC_targetStatus[target.UnitId] = target

	local gpGid
	if AFAC_available[arg_AFAC_F_Name] and AFAC_available[arg_AFAC_F_Name]["gpGid"] then
		gpGid = AFAC_available[arg_AFAC_F_Name]["gpGid"]
	end

	local targetPosVec3 = target.unitPosVec3

	if arg_LaserCode and arg_LaserCode ~= "nil" and laser == nil then
		-- env.info("DCE_AFAC () : J createLaser laserCode: "..tostring(arg_LaserCode))
		laser = Spot.createLaser(unitAFAC, nil, targetPosVec3, arg_LaserCode)	--start laser spot
	else
		trigger.action.smoke(targetPosVec3, SmokeColor_TargetDesignation)
		-- env.info("DCE_AFAC () K create smokeColor.Red ")

		AFAC_available[arg_AFAC_F_Name]["smokeData"] = {
			time = timer.getTime(),
			targetPosVec3 = targetPosVec3,
			sideNum = coalitionId,
		}

	end

	local LLposNstring, LLposEstring = LLtool.LLstrings(targetPosVec3)
	local LLpos = ' N ' .. LLposNstring .. '   E ' .. LLposEstring
	target["LLpos"] = LLpos

	if gpGid then
		if arg_LaserCode and arg_LaserCode ~= "nil"  then
			trigger.action.outTextForGroup(gpGid,"AFAC createLaser laserCode: "..tostring(arg_LaserCode), 30, false)
		end

		if target.LLpos then
			trigger.action.outTextForGroup(gpGid,"AFAC Target Position: "..tostring(target.LLpos), 30, false)
		end
	end


	--************///////////////////////////////////////////////////////////////////////////////////////////////////////////////
	local ctr = flightGroup:getController() -- Récupère le contrôleur du GROUPE (sinon, l injectrion de task sur l unit leader fait planter DCS)
	local descAfac = unitAFAC:getDesc()
	local modFPlan = {}
    local foundAfacRoute
	
	for _, coalition in pairs(env.mission.coalition) do
		for _, _country in pairs(coalition.country) do
			if _country.plane then
				for _, _group in pairs(_country.plane.group) do
					if _group.name and _group.name == arg_AFAC_F_Name then
						--copie de l'ancienne route
						modFPlan = Deepcopy(_group.route.points)
						foundAfacRoute = true
						break
					end
				end
			end
			if foundAfacRoute then break end
		end
		if foundAfacRoute then break end
	end

	if not foundAfacRoute then
		env.info("DCE_AFAC () : DCE_INFO not foundAfacRoute RETURN ")
		return
	end


	local i = 1
	while modFPlan[i] do
		if modFPlan[i]["briefing_name"] == "Station" then
			break -- Arrête la suppression dès qu'on trouve "Station"
		end
		table.remove(modFPlan, i) -- Supprime l'élément à l'index `i`
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
										["command"] = "env.info(\"DCE_AFAC_Mission WPT2 C \")",
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
			['y'] = tonumber(arg_refY) ,
			['x'] = tonumber(arg_refX) ,
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
										["command"] = "CustomDesignationAFAC('" .. arg_AFAC_F_Name .. "', '" .. arg_refX .. "', '" .. arg_refY .. "',  'nil')",
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

	-- -- Ajouter les éléments de new_way en premier
	-- for j = 1, 3 do
	-- 	newRoute[j] = new_way[j]
	-- end

	-- ajoute les anciens wpt aux nouveau
	local startIndex = #new_way +1
	for _, v in ipairs(modFPlan) do
		newRoute[startIndex] = v
		startIndex = startIndex + 1
	end


	-- recalcul les ETA
	i = 1
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

	if camp.debug then
		local logStr = "afac = " .. TableSerialization(newMission, 0)
		local flightNameClean = arg_AFAC_F_Name:gsub('[%p%c%s]', '_')
		local logFile = io.open(PathDCE.."Debug\\"..flightNameClean.."_AFAC_"..current_time..".lua", "w")
		if logFile then
			logFile:write(logStr)
			logFile:close()
		else
			env.info("DCE_AFAC : Failed to open log file for writing.")
		end
	end

	ctr:resetTask() 			-- Efface les tâches existantes
	ctr:setTask(newMission)

	LastInjecAFAC[arg_AFAC_F_Name] = timer.getTime() 	--update last injection time

	env.info("DCE_AFAC Z nouvelle mission injectee")

end

function CustomSearchThenEngageTEST(flightName, radius, targetType, searchTime)
	if varFpsLeak then return end

	env.info("DCE_CustomSearchThenEngage A START func() "..tostring(flightName))

	if not radius or radius <= 40000 then
		radius = 40000
	end
	if not searchTime then
		searchTime = timer.getTime() + 1800
	end

	if not falseCycleCount[flightName] then falseCycleCount[flightName] = 0 end

	local function ApplyEngageTargetsInZoneTask()
		local elementInAir = false
		local flight = Group.getByName(flightName)
		if flight then
			local units = flight:getUnits()
			for _, unit in ipairs(units) do
				if unit and unit:isExist() and unit:isActive() and unit:inAir() then
					elementInAir = true
					break
				end
			end

			if elementInAir then
				local element = units[1]
				if element and element:getPlayerName() == nil then
					local desc = element:getDesc()
					local cat = desc and desc.category or nil
					local cntrl = flight:getController()
					local posVec3 = element:getPoint()

					local task_entry = {
						id = 'ControlledTask',
						params = {
							task = {
								enabled = true,
								auto = false,
								id = "EngageTargetsInZone",
								number = 1,
								params = {
									targetTypes = { targetType },
									x = posVec3.x,
									y = posVec3.z,
									value = targetType .. ";",
									priority = 0,
									zoneRadius = radius,
								}
							},
							stopCondition = {
								duration = 50,
							}
						}
					}

					if cat == Unit.Category.HELICOPTER then
						task_entry.params.task.params.zoneRadius = 15000
					end

					cntrl:pushTask(task_entry)
					env.info(" Task pushed to group: "..flightName)

					return true
				end
			end
		end
		return false
	end

	local function checkLoop()
		local success = ApplyEngageTargetsInZoneTask()
		if success then
			falseCycleCount[flightName] = 0
			env.info("DCE_CustomSearchThenEngage  TASK applied to "..flightName)
		else
			falseCycleCount[flightName] = falseCycleCount[flightName] + 1
			env.info("DCE_CustomSearchThenEngage  NOT ready ("..falseCycleCount[flightName]..") for "..flightName)

			if falseCycleCount[flightName] < 20 then
				timer.scheduleFunction(checkLoop, nil, timer.getTime() + 30) -- retry dans 30s
			else
				env.info("DCE_CustomSearchThenEngage  ABANDONNE après trop d'échecs: "..flightName)
				falseCycleCount[flightName] = nil
			end
		end
	end

	--  Lancement du suivi initial différé (ex : 30s pour laisser le temps au taxi/départ)
	timer.scheduleFunction(checkLoop, nil, timer.getTime() + 30)
end


----- search then engage task -----
--allows to engage targets within a set distance from own group. CAUTION: Once this function is running, it group can no longer receive waypoint actions (DCS treats engage task set via script as never completed)!
function CustomSearchThenEngage(flightName, radius, targetType, searchTime)
-- "CustomSearchThenEngage(\'Pack 7 - 923rd-1 FR - Fighter Sweep 1\', 20000, \'Air\',2864.5791359112)"
	if varFpsLeak then return end

	env.info( "DCE_CustomSearchThenEngage A start func() "..tostring(flightName).."| radius |"..tostring(radius).."| targetType |"..tostring(targetType).."| searchTime |"..tostring(searchTime))

	if not radius or radius == nil or radius <= 30000 then
		radius = 30000
	end
	if not searchTime or searchTime == nil then
		searchTime = timer.getTime() + 1800
	end

	local function applyEngageTargetsInZoneTask()							--engage targets in zone task needs to be applied continously to update zone position to group position
		
		local elementInAir = false
		local elementExist = false
		local flight = Group.getByName(flightName)							--get group
		
		if flight then														--group still exists
			-- env.info( "DCE_CustomSearchThenEngage B0 "..flightName)

			local element = flight:getUnit(1)								--get first unit in group

			if SatusGroupAircraft[flightName] and (SatusGroupAircraft[flightName]["takeoff"] and not SatusGroupAircraft[flightName]["landing"]) then
				elementInAir = true
			end

			if element and element.inAir and element:inAir() then
				elementInAir = true
			end

			if SatusGroupAircraft[flightName] and SatusGroupAircraft[flightName]["landing"] then
				elementInAir = false
				env.info( "DCE_CustomSearchThenEngage B1_99 RETURN landing")
				return
			end

			if element and element:isExist() and element:isActive()  then--and element:inAir()
				elementExist = true
				-- env.info( "DCE_CustomSearchThenEngage B1b getUnit(1) elementInAir = true ")
			else
				local wingman = flight:getUnits()								--get list of units from attacking flights
				for n = 2, #wingman do
					element = flight:getUnit(n)

					-- env.info( "DCE_CustomSearchThenEngage B2 element "..tostring(element).." element:isExist() "..tostring(element and element:isExist()).." element:isActive() "..tostring(element and element:isActive()).." element:inAir() "..tostring(element and element:inAir()))

					if element and element:isExist() and element:isActive()  then--and element:inAir()
						elementExist = true
						-- env.info( "DCE_CustomSearchThenEngage B2b else n puis break n: "..n)
						break
					end
				end
				-- env.info( "DCE_CustomSearchThenEngage B98 fin else ")
			end

			if not elementExist then
				env.info( "DCE_CustomSearchThenEngage B99 RETURN not elementExist")
				return
			end

			local RTB = false
			local gpGid = ""
			local callSign = ""
			local cat
			if element and element:getPlayerName() == nil and not RTB then
				gpGid = Group.getID(flight)
				callSign = Unit.getCallsign(element)
				-- cat = Group.getCategory(flight)	--ne fonctionne plus (ne pas prendre getCategory pour les unit)

				--detecte si l'helico se pose proche d'une FARP BASE
				local desc = element:getDesc()
				cat = desc.category

				if BingoPlaneTab[gpGid] and BingoPlaneTab[gpGid][callSign] then
					-- _affiche(BingoPlaneTab, "DCE_CustomSearchThenEngage C BingoPlaneTab")
					-- env.info( "DCE_CustomSearchThenEngage C2 RETURN RTB true "..flightName)
					return
				end

				-- env.info( "DCE_CustomSearchThenEngage D1 gpGid "..tostring(gpGid).." callSign "..tostring(callSign).." RTB "..tostring(RTB).." elementInAir "..tostring(elementInAir))
				
			end

			if elementInAir and cat and element and element:getPlayerName() == nil  then	--and not RTB

				local cntrl = flight:getController()						--get controller of group
				local posVec3 = element:getPoint()							--get position
				local task_entry = {}

				if cat == Unit.Category.AIRPLANE then  --0 Airplane
					task_entry = {										--define engage task		
						id = 'ControlledTask',
						params = {
							task = {
								enabled = true,
								auto = false,
								id = "EngageTargetsInZone",
								number = 1,
								params = {
									targetTypes = { targetType },
									x = posVec3.x,
									y = posVec3.z,
									value = targetType .. ";",
									priority = 0,
									zoneRadius = radius,
								}
							},
							stopCondition = {
								duration = 59,
							}
						}
					}

									
				cntrl:setOption(AI.Option.Air.id.PROHIBIT_AG, true)
				
				elseif cat == Unit.Category.HELICOPTER then  -- 1 helo
					task_entry = {
						id = 'ControlledTask',
						params = {
							task = {
								enabled = true,
								auto = false,
								id = "EngageTargetsInZone",
								number = 1,
								params = {
									targetTypes = { "Helicopters" },
									x = posVec3.x,
									y = posVec3.z,
									value = targetType .. ";",
									priority = 0,
									zoneRadius = 15000,
								}
							},
							stopCondition = {
								duration = 59,
							}
						}
					}
				end

				cntrl:pushTask(task_entry)		--ERROR 2785: Task id missed


				-- if camp.debug then
				-- 	local current_time = timer.getTime() + 5
				-- 	local logStr = "task_entry = " .. TableSerialization(task_entry, 0)
				-- 	local flightNameClean = flightName:gsub('[%p%c%s]', '_')
				-- 	local logFile = io.open(PathDCE.."Debug\\"..flightNameClean.."_"..current_time.."_".. "_CustomSearchThenEngage.lua", "w")
				-- 	if logFile then
				-- 		logFile:write(logStr)
				-- 		logFile:close()
				-- 	else
				-- 		env.info("DCE_CustomSearchThenEngage : Failed to open log file for writing.")
				-- 	end

				-- 	env.info( "DCE_CustomSearchThenEngage M : "..tostring(flightName).."| targetType |"..tostring(targetType).."| Radius |"..tostring(radius).." |ACTUALtime| "..timer.getTime())
				-- end

				-- env.info( "DCE_CustomSearchThenEngage O timer 60")
				return timer.getTime() + 60									--repeat function every 60 seconds

			end
		end

		-- env.info( "DCE_CustomSearchThenEngage P timer 120")
		return timer.getTime() + 120									--repeat function every 60 seconds
	end

	local nextTenth = (math.ceil(timer.getTime()) + 0.1 ) * 10
	if ScheduleTenth[nextTenth] then
		local i = 1
		repeat
			nextTenth = nextTenth + 1
			i = i + 1
		until not ScheduleTenth[nextTenth] or i > 1000
		ScheduleTenth[nextTenth] = true
	else
		ScheduleTenth[nextTenth] = true
	end

	-- env.info( "DCE_CustomSearchThenEngage R scheduleFunction")
	timer.scheduleFunction(applyEngageTargetsInZoneTask, nil, (nextTenth/10))			--schedule function

end --FIN CustomSearchThenEngage


function CustomIntercept(argTargetName, argInterName, argFriendSide, argSpeed, argPosX, argPosY)
	if varFpsLeak then return end

	env.info( "DCE_Custom_Intercept A start func() "..tostring(argTargetName).."| arg_PosX |"..tostring(argPosX).."| arg_PosY |"..tostring(argPosY))

	argPosX = tonumber(argPosX)
    argPosY = tonumber(argPosY)
    argSpeed = tonumber(argSpeed)
	local interObj = Group.getByName(argInterName)
	local selected_distance = 999999999
    local enyCoalName = coalition.side.RED

	env.info( "DCE_Custom_Intercept B")
	
	if argFriendSide == "blue" then
		argFriendSide = coalition.side.BLUE
	end

    local groups = coalition.getGroups(enyCoalName)
    local selected_group = nil
    local selected_PtVec3 = nil
	
    env.info("DCE_Custom_Intercept C1")
	
    for i, groupObj in pairs(groups) do
		
		local unitObj = groupObj:getUnit(1)

		env.info("DCE_Custom_Intercept C2 i "..i .." groupObj "..tostring(groupObj).." unitObj "..tostring(unitObj))
		
		--and unitObj.isActive and unitObj:isActive() and unitObj.isExist and unitObj:isExist()
		if unitObj and unitObj.inAir and unitObj:inAir() then
			
			local uPointVec3 = unitObj:getPoint()
			env.info("DCE_Custom_Intercept C3 inAir uPointVec3.x: "..tostring(uPointVec3.x).." uPointVec3.z "..tostring(uPointVec3.z))
			env.info("DCE_Custom_Intercept C4 math.abs(uPointVec3.x - argPosX): "..tostring(math.abs(uPointVec3.x - argPosX)))
			env.info("DCE_Custom_Intercept C5 math.abs(uPointVec3.z - argPosY): "..tostring(math.abs(uPointVec3.z - argPosY)))
			
            if math.abs(uPointVec3.x - argPosX) < 150000 and math.abs(uPointVec3.z - argPosY) < 150000 then
                -- Calcul précis seulement pour les avions proches

                local tempDistance = math.sqrt(math.pow(uPointVec3.x - argPosX, 2) + math.pow(uPointVec3.z - argPosY, 2))

				env.info("DCE_Custom_Intercept C6 tempDistance before: " .. tostring(tempDistance).." <? selected_distance "..tostring(selected_distance))
				
                if tempDistance < selected_distance then
					env.info("DCE_Custom_Intercept C7  " )
                    selected_distance = tempDistance
                    selected_group = groupObj
                    selected_PtVec3 = uPointVec3
                end
            end

		end

    end
	
	env.info("DCE_Custom_Intercept D selected_group: "..tostring(selected_group).." selected_PtVec3: "..tostring(selected_PtVec3))
	
    if selected_group and selected_PtVec3 then

		local targetGpId = selected_group:getID()
        local weaponType = 1069547520 --automatique
		
		env.info( "DCE_Custom_Intercept E")

		local mission = { --define mission for interceptor group
		id = 'Mission',
			params = {
				route = {
					["points"] = {
						[1] =
						{
							["alt"] = selected_PtVec3.y,
							["type"] = "Turning Point",
							["action"] = "Turning Point",
							["alt_type"] = "BARO",
							["formation_template"] = "",
							["y"] = selected_PtVec3.z,
							["x"] = selected_PtVec3.x,
							["speed"] = argSpeed,
							["ETA_locked"] = false,
							["task"] = {
								["id"] = "ComboTask",
								["params"] = {
									["tasks"] = {

										[1] = {
											["enabled"] = true,
											["number"] = 1,
											["auto"] = false,
											["id"] = "EngageGroup",
											["params"] = {
												["visible"] = false,
												["groupId"] = targetGpId,
												["priority"] = 1,
												["weaponType"] = weaponType,
											},
										},

									},
								},
								["speed_locked"] = true,
							},
						},
					},
				}
			}
		}

		env.info( "DCE_Custom_Intercept F")

		local ctr = interObj:getController()
        -- Controller.setTask(ctr, mission)	-- ecrase la mission precedente

		-- Stop toute action en cours
		ctr:setCommand({ id = 'StopRoute', params = { value = true } })

		-- Supprime la tâche active si bloquante
		ctr:popTask()

		-- Prépare et injecte l’interception

		local interceptTask = {
			id = 'EngageGroup',
			["params"] = {
				["visible"] = false,
				["groupId"] = targetGpId,
				["priority"] = 1,
				["weaponType"] = weaponType,
			},
		}
		ctr:pushTask(interceptTask)

		env.info("DCE_Custom_Intercept G")

		
		if camp.debug then
			--export custom mission log
			local current_time = timer.getTime()
			local logStr = "params = " .. TableSerialization(interceptTask, 0)
			local flightNameClean = argInterName:gsub('[%p%c%s]', '_')
			local logFile = io.open(
			PathDCE .. "Debug\\" .. flightNameClean .. "_" .. "Custom_Intercept" .. "_" .. tostring(current_time) .. ".lua", "w")
			if logFile then
				logFile:write(logStr)
				logFile:close()
			else
				env.info("DCE_INTERCEPTOR: Failed to open log file for writing.")
			end
		end

			
	end

end


----------------------------------------------------------------------------------------------------
----- Follow task -----
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
----- orbit position task -----
----------------------------------------------------------------------------------------------------

--lets flight orbit at the current position the task was applied (regardless of waypoints)
function OrbitPosition(arg_FlightName, arg_Alt, arg_Speed, arg_UntilTime)
	if varFpsLeak then return end
	local flight = Group.getByName(arg_FlightName)							--get group
	local current_time0 = timer.getTime()
	env.info(
		"DCE_Orbit A, grpname |"..tostring(arg_FlightName).."|Alt|"..tostring(arg_Alt).."|Speed|"
		..tostring(arg_Speed).."|UntilTime|"..tostring(arg_UntilTime).."|current_time0|"..tostring(current_time0)
	)

	local function execute()
		env.info("DCE_Orbit B ")

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

			if camp.debug then
				local logStr = "OrbitPosition = " .. TableSerialization(task_entry, 0)
				local flightNameClean = arg_FlightName:gsub('[%p%c%s]', '_')
				local logFile = io.open(PathDCE.."Debug\\"..flightNameClean.."_".. "OrbitPosition_"..current_time..".lua", "w")
				if logFile then
					logFile:write(logStr)
					logFile:close()
				else
					env.info("DCE_OrbitPosition: Failed to open log file for writing.")
				end
			end
		end
	end

	timer.scheduleFunction(execute, nil, timer.getTime() + 2)

end


----------------------------------------------------------------------------------------------------
------------------------------------ RTB task ------------------------------------------------------
----------------------------------------------------------------------------------------------------

--actualizes the xy position of the CV/base to assign a correct position to WPT landing
function Custom_RTB_2_Base(grpname, BaseName, speed, alt)
	if varFpsLeak_B then return end
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

			if camp.debug then
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
function Custom_AddWptSAR(grpname, BaseName, mgrsChute, speed, alt)
	if varFpsLeak_B then return end

	local current_time = timer.getTime()
	env.info( "current_time: "..tostring(current_time).." Custom_AddWptSAR A, grpname |"..tostring(grpname).."|"..tostring(BaseName).."|"..tostring(speed).."|"..tostring(alt))

	local function execute()
		local flight = Group.getByName(grpname)
		local coalitionId = tostring(flight:getCoalition())						--obligé pour le string, car 0 est impossible en numerotation de table	
		local leader = flight:getUnit(1)
		local base = Unit.getByName(BaseName)								--trouve le CV si c'en est un
		local  gpGid = Group.getID(flight)

		if not base or base == nil then
			base = Airbase.getByName(BaseName)								--trouve la base si c'est un Airbase

			if not base or base == nil then									--trouve la base si le nom est incomplet
				if  baseFullName[BaseName] then
					BaseName = baseFullName[BaseName]
					base = Airbase.getByName(BaseName)
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
														["command"] = "Custom_Altitude('" .. grpname .. "',  '  nil  ', '" .."1".. "')",
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
																-- Custom_SAR(grpname, BaseName, BaseNameX, BaseNameY, mgrsChute, speed, alt)
													["command"] = "Custom_SAR('" .. grpname .. "', '" .. BaseName .. "', '" .. pt_landing.x .. "', '" .. pt_landing.y .. "', '" .. mgrsChute .. "', '" .. speed .. "', '" .. alt ..  "')",
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
													["command"] = "Custom_Altitude('" .. grpname .. "',  '  nil  ', '" .."4".. "')",
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
						for _coalition, coalition in pairs(env.mission.coalition) do
							for Ncountry, _country in pairs(coalition.country) do
								if _country.helicopter then
									for Ngroup, _group in pairs(_country.helicopter.group) do
										if _group.groupId == gpGid then
											copyRoute = Deepcopy(_group.route.points)
											foundAeronef = true
											break
										end
									end
								end
								if foundAeronef then break end
							end
							if foundAeronef then break end
						end
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
													["command"] = "Custom_Altitude('" .. grpname .. "',  '  nil  ', '" .."1".. "')",
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
															["command"] = "Custom_Altitude('" .. grpname .. "',  '  nil  ', '" .."1".. "')",
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

			if camp.debug then
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
	if varFpsLeak_B then return end
	local current_time = timer.getTime()
	local function execute()
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
					if camp.boundary and camp.boundary[eny_Side] and camp.boundary[eny_Side] ~= nil then
						wrongSide =  CheckPointInPoly_XY_2({x=uPilot.pos.x,y=uPilot.pos.y} , camp.boundary[eny_Side])
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
											["command"] = "Custom_Altitude('" .. grpname .. "', '  nil  ', '" .."4".. "')",
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
										["command"] = "DespawnSoldierAliasPilot('"..pt_dest.uPilotName.."')",
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
										["command"] = "DespawnSoldierAliasPilot('"..pt_dest.uPilotName.."')",
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

		if camp.debug then
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

	end     --fin execute

	timer.scheduleFunction(execute, nil, timer.getTime() + 1)

end	--Custom_SAR



----------------------------------------------------------------------------------------------------
------------------------------------- Custom_Altitude task -----------------------------------------
----------------------------------------------------------------------------------------------------

--adapte l'altitude aux chaines montagneuse
function Custom_Altitude(arg_grpName, arg_wptAlti, arg_wptTag)
	if varFpsLeak_B then return end

	if arg_wptTag then
		arg_wptTag = tonumber(arg_wptTag)
	else
		arg_wptTag = 0
	end
	if not arg_wptAlti or arg_wptAlti == nil then
		arg_wptAlti = 1
		env.info( "Custom_Altitude, A wptAlti  |"..tostring(arg_grpName).." |wptAlti: "..tostring(arg_wptAlti))
	end
	local current_time = timer.getTime()
	env.info( "current_time: "..tostring(current_time).." Custom_Altitude, B wptAlti  |"..tostring(arg_grpName).." |wptAlti: "..tostring(arg_wptAlti))

	local function execute()
		current_time = timer.getTime()
		local flight = Group.getByName(arg_grpName)

		-- local selectedMember = flight:getUnits(1)
		local selectedMember
		local wingman = flight:getUnits()
		
		for memberN, _unit in ipairs(wingman) do
			if _unit and _unit:isExist() and _unit:isActive()  and _unit:inAir() then
				selectedMember = _unit
				break
			end
		end

		if not selectedMember then
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
			return
		end

		if  (str_selectedMember == "Mi-24P" or str_selectedMember == "UH-1H") then
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
				for _coalition, coalition in pairs(env.mission.coalition) do
					for Ncountry, _country in pairs(coalition.country) do
						if _country.helicopter then
							for Ngroup, _group in pairs(_country.helicopter.group) do
								if _group.groupId == gpGid then
									copyRoute = Deepcopy(_group.route.points)
									foundAeronef = true
									break
								end
							end
						end
						if foundAeronef then break end
					end
					if foundAeronef then break end
				end
			end

			--enleve le script Custom_Altitude pour eviter de le reinjecter et d avoir une boucle
			if arg_wptTag and arg_wptTag ~= nil then
				for Npoint, point in ipairs(copyRoute)  do
					if tonumber(Npoint) == tonumber( arg_wptTag) then
						copyRoute[tonumber(Npoint)].name = "deleteBeforHere"
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

			if arg_wptTag and arg_wptTag > 0 then
				for i = #copyRoute, 1, -1 do
					if i <= arg_wptTag then
						table.remove(copyRoute, i)
					end
				end
			end

			--cherche la prochaine action pour ne pas trop calculer de wpt intermedaire
			local nWptNextCustom = 9999
			for Npoint, point in ipairs(copyRoute)  do
				if point.task and point.task.params and point.task.params.tasks then
					for Ntask, taskFinal in ipairs(point.task.params.tasks)  do
						if taskFinal and taskFinal.params and taskFinal.params.action and taskFinal.params.action.id == "Script" then
							if taskFinal.params.action.params and taskFinal.params.action.params.command
							and ( string.find(taskFinal.params.action.params.command,"Custom_SAR") or string.find(taskFinal.params.action.params.command,"Custom_AddWptSAR")  ) then

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
			local altiWpt = {}

			for n = 1, #copyRoute - 1  do
				if n > nWptNextCustom then    --ne pas ajouter trop de wpt, sinon ça plante DCS (75 wpt max)
					break
				end

				if n == 1 then    --force la position de l'etat actuel
					copyRoute[1].x = actualPositionXY.x
					copyRoute[1].y = actualPositionXY.y
				end

				table.insert(copyRoute2, copyRoute[n])

				local distance = math.sqrt(math.pow(copyRoute[n].x - copyRoute[n+1].x, 2) + math.pow(copyRoute[n].y - copyRoute[n+1].y, 2))
				local heading = GetHeading({x=copyRoute[n].x, y=copyRoute[n].y} , {x=copyRoute[n+1].x, y=copyRoute[n+1].y} )
				local altiMax = 1

				local origineN = #copyRoute2
				local distInterWpt = 0
				local sondagePt, sondageAlti, selectedPoint, headingAlt
				local interDistance = 2500	--7500m ou 2500 m
				local oldAltiMax = 0
				local oldHeadingAlt = 0

				selectedPoint = {x=copyRoute[n].x, y=copyRoute[n].y}
				oldAltiMax = land.getHeight({x =selectedPoint.x, y = selectedPoint.y})

				for interval = 1, distance, interDistance do

					if interval == 1 then
						-- selectedPoint = {x=copyRoute[n].x, y=copyRoute[n].y}
						-- oldAltiMax = land.getHeight({x =selectedPoint.x, y = selectedPoint.y})
					else
						-- prend le nouveau cap pour aller du point precedent calculé au futur point prévu par l'ancienne route
						heading = GetHeading({x=selectedPoint.x, y=selectedPoint.y} , {x=copyRoute[n+1].x, y=copyRoute[n+1].y} )
					end

					local addHeadingMin = -5
					local addHeadingMax = 5
					local addDistance = 1000
					local altiMin0 = 999999
					local altiMax0 = 0
					local diffHeading = 10


					--regarde la topographie devant l helico
					--si c est montagneux, on augmente le nb de wpt, sinon on ne fait rien ou presque
					for addHeading = -90 , 90 do
						for interval0 = 0, 1500 , 150 do
							local headingAlt0 = heading + addHeading
							local sondagePt0 = GetOffsetPoint(selectedPoint, headingAlt0 , interval0 )
							sondageAlti = land.getHeight({x =sondagePt0.x, y = sondagePt0.y})

							if altiMin0 >= sondageAlti then
								altiMin0 = sondageAlti
							end
							if altiMax0 <= sondageAlti then
								altiMax0 = sondageAlti
							end
						end
					end

					local diffAlti0 = altiMax0 - altiMin0

					if diffAlti0 >= 450 and  diffAlti0 < 950 then
						addHeadingMin = -25
						addHeadingMax = 25
						addDistance = 1100
						diffHeading = 1
					elseif  diffAlti0 >= 950 then
						addHeadingMin = -50
						addHeadingMax = 50
						addDistance = 400
						diffHeading = 5
					end

					local sumAlti = {}

					--cumul les alti pour trouver la plus petite sur les differents chemin calculé
					-- calcul pour la prochaine tranche de 5000m
					-- for AddHeading = -30 , 30 do
					for addHeading = addHeadingMin , addHeadingMax do
						for interval0 = addDistance, interDistance , addDistance do
							headingAlt = heading + addHeading
							sondagePt = GetOffsetPoint(selectedPoint, headingAlt , interval0 )
							sondageAlti = land.getHeight({x =sondagePt.x, y = sondagePt.y})

							if not sumAlti[tostring(addHeading)] then
								sumAlti[tostring(addHeading)] = {}
							end
							if not sumAlti[tostring(addHeading)]["sum"]  then sumAlti[tostring(addHeading)]["sum"]  = 0 end
							if not sumAlti[tostring(addHeading)]["altiMax"]  then sumAlti[tostring(addHeading)]["altiMax"]  = 0 end
							if not sumAlti[tostring(addHeading)]["distance"]  then sumAlti[tostring(addHeading)]["distance"]  = 0 end


							sumAlti[tostring(addHeading)]["sum"] = sumAlti[tostring(addHeading)]["sum"]  + sondageAlti
							sumAlti[tostring(addHeading)]["distance"]  = interval0

							if sumAlti[tostring(addHeading)]["altiMax"] < sondageAlti then
								sumAlti[tostring(addHeading)]["altiMax"] = sondageAlti
							end
						end

						--regarde l'alti max sur une tres longue distance, pour ne pas s orienter vers une trop grande montagne
						for interval0 = 600 , 10000 , 500 do
							headingAlt = heading + addHeading
							sondagePt = GetOffsetPoint(selectedPoint, headingAlt , interval0 )
							sondageAlti = land.getHeight({x =sondagePt.x, y = sondagePt.y})

							if not sumAlti[tostring(addHeading)] then
								sumAlti[tostring(addHeading)] = {}
							end
							if not sumAlti[tostring(addHeading)]["altiMaxLong"]  then sumAlti[tostring(addHeading)]["altiMaxLong"]  = 0 end

							if sumAlti[tostring(addHeading)]["altiMaxLong"] < sondageAlti then
								sumAlti[tostring(addHeading)]["altiMaxLong"] = sondageAlti

								if sumAlti[tostring(addHeading)]["altiMaxLong"] < 3500 then
									-- env.info( "CustomTS Pf BBB_b sondageAlti: "..tostring(AddHeading).." altiMaxLong: "..tostring(sondageAlti).."")
								end
							end
						end
					end


					--selection la route ou la somme d'alti est la plus faible, cela fait suivre les vallees :)
					-- et evite toutes les directions où l'alti est trop haute
					local selectHdg = 0
					local selectSum = 999999

					--regarde si au moins un cap est inferieur à l altiMaxLong
					local foundLowAltiMaxLong = false
					for addHdg_N, value in pairs(sumAlti) do
						if  sumAlti[tostring(addHdg_N)].altiMaxLong < 2500 then
							foundLowAltiMaxLong = true
							break
						end
					end


					for NaddHdg, value in pairs(sumAlti) do

						if foundLowAltiMaxLong then
							if sumAlti[tostring(NaddHdg)].sum < selectSum and  sumAlti[tostring(NaddHdg)].altiMaxLong < 3500 then
								selectSum = sumAlti[tostring(NaddHdg)].sum
								local convertHdg = tonumber(NaddHdg)
								if convertHdg then
									selectHdg = convertHdg
								end
							end
						elseif sumAlti[tostring(NaddHdg)].sum < selectSum then
							selectSum = sumAlti[tostring(NaddHdg)].sum
							local convertHdg = tonumber(NaddHdg)
							if convertHdg then
								selectHdg = convertHdg
							end
						end
					end

					altiMax = sumAlti[tostring(selectHdg)].altiMax

					headingAlt = heading + tonumber(selectHdg)

					local selectedPointNew = GetOffsetPoint(selectedPoint, headingAlt , sumAlti[tostring(selectHdg)].distance )
					selectedPoint = selectedPointNew

					local printAltiMaxLong =  0
					if sumAlti[tostring(selectHdg)] and sumAlti[tostring(selectHdg)].altiMaxLong then
						printAltiMaxLong =  math.floor(sumAlti[tostring(selectHdg)].altiMaxLong)
					end

					local alt_type = "BARO"
					if math.abs(oldAltiMax - altiMax) < 175 then
						alt_type = "RADIO"
					end

					if (math.abs(oldAltiMax - altiMax) > 300 or  math.abs(oldHeadingAlt - headingAlt) > diffHeading )  then

						oldAltiMax = altiMax
						oldHeadingAlt =  headingAlt
						distInterWpt = 0
						local alti = altiMax + addAlti
						if printAltiMaxLong >= 3500 then
							alti = printAltiMaxLong + addAlti
						end
						local interWpt = {

							['speed_locked'] = true,
							['type'] = 'Turning Point',
							['action'] = 'Fly Over Point',
							-- ['alt_type'] = '"'..tostring(alt_type)..'"',
							['alt_type'] = tostring(alt_type),
							['ETA'] = (interval / copyRoute[n].speed) + copyRoute[n].ETA ,
							['y'] = selectedPoint.y,
							['x'] = selectedPoint.x,
							['name'] = 'from Cus_tom_Alti_tude interWpt: '..tostring(#copyRoute2),
							['formation_template'] = '',
							['speed'] = tonumber(copyRoute[n].speed),
							['ETA_locked'] = false,
							['task'] = {
								['id'] = 'ComboTask',
								['params'] = {
									['tasks'] = {
									},
								},
							},
							['alt'] = tonumber(alti),
						}

						-- pour passer dans les vallées, il faut etre en file indienne trail
						--TODO revenir à une formation standart si on sort des vallées ou relief
						--diffHeading = 1
						if #copyRoute2 == 2 or #copyRoute2 == 3 then
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
						end

						table.insert(copyRoute2, interWpt)

						altiMax = 1

					end
					if #copyRoute2 > 50 then break end
				end

				--ajuste l'altitude des wpt d origine:
				if origineN > 1  then
					local altitude =  land.getHeight({x =copyRoute2[origineN].x, y = copyRoute2[origineN].y})
					if copyRoute2[origineN-1].alt > altitude then
						altitude = copyRoute2[origineN-1].alt
					end
					copyRoute2[origineN].alt = altitude
				end
			end

			-- --supprime le premier wpt, sinon l'helico revient sur ses pas.
			-- table.remove(copyRoute2, 1)

			local Mission = {
					id = 'Mission',
					params = {
						route = {
							points = copyRoute2
						},
					}
				}

			if camp.debug then
				local logStr = "Mission = " .. TableSerialization(Mission, 0)
				local grpnameClean = arg_grpName:gsub('[%p%c%s]', '_')
				local logFile = io.open(PathDCE.."Debug\\"..grpnameClean.."_".. "Custom_Altitude_"..current_time..".lua", "w")
				if logFile then
					logFile:write(logStr)
					logFile:close()
				else
					env.info("DCE_Custom_Altitude_: Failed to open log file for writing.")
				end
			end

			Controller.setTask(ctr, Mission)										--activate task with mission for retreat AWACS

			env.info( "Custom_Altitude, FIN_O |"..tostring(ctr))
		end

		env.info( "Custom_Altitude, FIN_P")
	end

	local nextSecond = math.ceil(timer.getTime()) + 1

	if AgendaSeconde[nextSecond] then
		local i = 1
		repeat
			nextSecond = nextSecond + 1
			i = i + 1
		until not AgendaSeconde[nextSecond] or i > 1000

		AgendaSeconde[nextSecond] = true

		if i > 1000 then
			env.info( "Custom_Altitude, DCE_ERROR BOUCLE ")
		end
	else
		AgendaSeconde[nextSecond] = true
	end

	timer.scheduleFunction(execute, nil, nextSecond)

	-- timer.scheduleFunction(execute, nil, timer.getTime() + 1)
end
