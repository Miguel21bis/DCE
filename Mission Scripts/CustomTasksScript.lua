-- --To provide custom AI Attack Tasks 
--Script attached to mission and executed via trigger
--Functions accessed via LUA Run Script on waypoint
------------------------------------------------------------------------------------------------------- 
-- last modification:  M61_j
if not versionDCE then versionDCE = {} end
versionDCE["Mission Scripts\CustomTasksScript.lua"] = "1.9.38"
------------------------------------------------------------------------------------------------------- 
-- Reglage_n				(n force RTB)(m stopcondition)(l escorte)(k CVN to CV)(j altitudeEnabled true)(h GetHeading)(global path)(f rejoin debug)(e more scheduleFunction) (d landingImpossible denivelé)(c: limit =  1 ?)(b: orbit infini) all ["groupAttack"] = false,
-- cleanCode_a
-- Debug_h					(fgh: CAS AttackUnit)(e: static id -1)(d: Checking) creates custom files to observe (c: Helicopter)(b: strike bombing)(a: strike ASM B52)

-- modification M74_a		mix static, vehicle and map elements in a Target.
-- modification M68_a		add AFAC task
-- modification M61_j		SAR (j noSAR in wrongSide)(d Custom_Altitude-follow the valleys)(b debug+shifts task injections) 
-- modification M54_b		revoir CustomTaskScript et TaskBombing (b: add duration)
-- modification M45_a		compatible with 2.7.0

------------------------------------------------------------------------------------------------------- 



AFAC_available = {}				--liste les AFAC en position


local varFpsLeak = false
local varFpsLeak_B = false
local selectedTransport = 0			--util pour embarked
local agendaSeconde = {}
local AttackCounter	= {}													--table to count how many flights have already attacked and distribute subsequent attacks accordingly

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
function CustomGroupAttack(FlightName, TargetName, expend, weaponType, attackType, attackAlt, id_task)
	if varFpsLeak then return end
	env.info("DCE_CustomGroupAttack start| "..tostring(FlightName))

	-- Weapon.Category
	-- SHELL     0
	-- MISSILE   1
	-- ROCKET    2
	-- BOMB      3

	local function Execute(arg)
		local cntrl = arg[1]
		local ComboTask = arg[2]
		local n = arg[3]
		local current_time = timer.getTime()

		if camp.debug then
			--export custom mission log
			local logStr = "ComboTask = " .. TableSerialization(ComboTask, 0)
			local FlightNameClean = FlightName:gsub('[%p%c%s]', '_')
			local logFile = io.open(PathDCE.."Debug\\"..FlightNameClean.."_"..n.."_".. "CustomGroupAttack".."_"..tostring(current_time)..".lua", "w")
			if logFile then
				logFile:write(logStr)
				logFile:close()
			else
				env.info("DCE_CustomGroupAttack: Failed to open log file for writing.")
			end
		end

		cntrl:pushTask(ComboTask)									--push task to front of task list	

		env.info("DCE_CustomGroupAttack | fin")
	end

	local TargetGroup = Group.getByName(TargetName)						--get target group
	if TargetGroup then													--target group exists
		local idTypeStrike = "Bombing"
		-- if (weaponType == 4161536 or weaponType == 14) and id_task == "CAS" then	-- Guided bombs or ASM M54_a
		if id_task == "CAS" or id_task == "Pinpoint Strike" then												--  M54_a		
			idTypeStrike  = "AttackUnit"
		else
			idTypeStrike  = "Bombing"
		end

		if AttackCounter[TargetName] then								--counter with number of flights that have already attacked this target
			AttackCounter[TargetName] = AttackCounter[TargetName] + 1	--increase counter by one
		else															--no flight has attacked this target yet
			AttackCounter[TargetName] = 1								--set to one
		end
		local AttackN = AttackCounter[TargetName]

		local target = TargetGroup:getUnits()							--get target units

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
				num = num + AttackN - 1										--increase target number to adjust for previous attacks
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
				if ((expend == "Auto" or target[num]:getDesc().category == 3) and idTypeStrike == "AttackUnit") or idTypeStrike == "AttackUnit"  then		--if auto expend or target unit is a ship
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

				if expend == "All" and t > 1 and weaponType ~= "ASM" then
					env.info("DCE_CustomGroupAttack: passe G3 ")
					break
				end

				env.info("DCE_CustomGroupAttack |"..tostring(FlightName).."| |"..tostring(task_entry["id"]))

				table.insert(ComboTask.params.tasks, task_entry)
			end

			if n > 1 and EgressWP.x then												--for all wingmen
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

			local nextSecond = math.ceil(timer.getTime()) + 1
			if agendaSeconde[nextSecond] then
				local i = 1
				repeat
					nextSecond = nextSecond + 1
					i = i + 1
				until not agendaSeconde[nextSecond] or i > 1000
				agendaSeconde[nextSecond] = true
			else
				agendaSeconde[nextSecond] = true
			end
			timer.scheduleFunction(Execute, {cntrl, ComboTask, n} ,nextSecond)
			-- timer.scheduleFunction(Execute, {cntrl, ComboTask, n} , timer.getTime() + n*0.5)

		end		--local function Execute(n)
	end
end


----- attack multiple static objects -----
--allows each wingman of a flight to attack its own individual target simultaneously, then proceed to Egress point to join up (flight would not climb during egress if wingmen would joing leader imediately after attack)
function CustomStaticAttack(FlightName, TargetList, expend, weaponType, attackType, attackAlt, id_task)
	if varFpsLeak then return end
	env.info("DCE_CustomStaticAttack | start| "..tostring(FlightName))

	local function Execute(arg)
		local cntrl = arg[1]
		local ComboTask = arg[2]
		local n = arg[3]
		local current_time = timer.getTime()

		if camp.debug then
			--export custom mission log
			local logStr = "ComboTask = " .. TableSerialization(ComboTask, 0)
			local FlightNameClean = FlightName:gsub('[%p%c%s]', '_')
			local logFile = io.open(PathDCE.."Debug\\"..FlightNameClean.."_"..n.."_".. "CustomStaticAttack_"..tostring(current_time)..".lua", "w")
			if logFile then
				logFile:write(logStr)
				logFile:close()
			else
				env.info("DCE_CustomStaticAttack: Failed to open log file for writing.")
			end
		end

		cntrl:pushTask(ComboTask)									--push task to front of task list	

		env.info("DCE_CustomStaticAttack | fin")
	end

	local idTypeStrike  = "Bombing"
	if id_task == "CAS" then												--  M54_a		
		idTypeStrike  = "AttackUnit"
	else
		idTypeStrike  = "Bombing"
	end

	if AttackCounter[TargetList[1]] then									--counter with number of flights that have already attacked this target
		AttackCounter[TargetList[1]] = AttackCounter[TargetList[1]] + 1		--increase counter by one
	else																	--no flight has attacked this target yet
		AttackCounter[TargetList[1]] = 1									--set to one
	end
	local AttackN = AttackCounter[TargetList[1]]

	env.info("DCE_CustomStaticAttack : AttackN "..tostring(AttackN))

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

			local StaticName = TargetList[num]
			local StaticTemp = false

			env.info("DCE_CustomStaticAttack :StaticName AA |"..tostring(StaticName).."|")

			if  StaticObject.getByName(StaticName) then
				StaticTemp = StaticObject.getByName(StaticName)
				env.info("DCE_CustomStaticAttack found BB |"..tostring(StaticName).."|")
			else
				StaticName = StaticName.."-1"
				StaticTemp = StaticObject.getByName(StaticName)
				if StaticTemp then
					env.info("DCE_CustomStaticAttack found CC-1 |"..tostring(StaticName).."|")
				end
			end

			if StaticTemp then							--make sure that static object still exists

				-- local TargetID = StaticObject.getByName(TargetList[num]):getID()	--get static object ID
				local TargetID = StaticTemp:getID()	--get static object ID

				local task_entry = {									--define attack task
					["enabled"] = true,
					["auto"] = false,
					["id"] = idTypeStrike,
					["number"] = #ComboTask.params.tasks + 1,
					["params"] = {
						["x"] = StaticTemp:getPoint().x,
						["y"] = StaticTemp:getPoint().z,
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
					-- task_entry.params["unitId"] = TargetID
					-- task_entry.params["attackQtyLimit"] = false
				-- end


				--auto expend
				if  idTypeStrike == "AttackUnit" then
					task_entry["id"] = "AttackUnit"
					task_entry.params["unitId"] = tonumber(TargetID)
					task_entry.params["attackQtyLimit"] = false
					task_entry.params["x"] = nil
					task_entry.params["y"] = nil
				end

				-- ["stopCondition"] = 
				-- {
				-- 	["time"] = tonumber(UntilTime),
				-- 	-- ["duration"] = tonumber(var_duration),
				-- }

				env.info("DCE_CustomStaticAttack: CustomStaticAttack DD |"..tostring(FlightName).."| |"..tostring(task_entry["id"]))

				table.insert(ComboTask.params.tasks, task_entry)

				-- local nextSecond = math.ceil(timer.getTime()) + 1
				-- if agendaSeconde[nextSecond] then
				-- 	local i = 1
				-- 	repeat
				-- 		nextSecond = nextSecond + 1
				-- 		i = i + 1
				-- 	until not agendaSeconde[nextSecond] or i > 1000	
				-- 	agendaSeconde[nextSecond] = true
				-- else
				-- 	agendaSeconde[nextSecond] = true
				-- end

				-- timer.scheduleFunction(Execute, {cntrl, ComboTask, n} , nextSecond)	

			end
		end

		local nextSecond = math.ceil(timer.getTime()) + 1
		if agendaSeconde[nextSecond] then
			local i = 1
			repeat
				nextSecond = nextSecond + 1
				i = i + 1
			until not agendaSeconde[nextSecond] or i > 1000
			agendaSeconde[nextSecond] = true
		else
			agendaSeconde[nextSecond] = true
		end

		timer.scheduleFunction(Execute, {cntrl, ComboTask, n} , nextSecond)

	end
end

----- attack multiple all class objects -----
--allows each wingman of a flight to attack its own individual target simultaneously, then proceed to Egress point to join up (flight would not climb during egress if wingmen would joing leader imediately after attack)
function CustomMixClassAttack(FlightName, TargetList, expend, weaponType, attackType, attackAlt, id_task)
	if varFpsLeak then return end
	env.info("DCE_CustomMixClassAttack | start| "..tostring(FlightName))

	local function Execute(arg)
		local cntrl = arg[1]
		local ComboTask = arg[2]
		local n = arg[3]
		local current_time = timer.getTime()

		if camp.debug then
			--export custom mission log
			local logStr = "ComboTask = " .. TableSerialization(ComboTask, 0)
			local FlightNameClean = FlightName:gsub('[%p%c%s]', '_')
			local logFile = io.open(PathDCE.."Debug\\"..FlightNameClean.."_"..n.."_".. "CustomMixClasscAttack_"..tostring(current_time)..".lua", "w")
			if logFile then
				logFile:write(logStr)
				logFile:close()
			else
				env.info("DCE_CustomMixClassAttack: Failed to open log file for writing.")
			end
		end

		cntrl:pushTask(ComboTask)									--push task to front of task list	

		env.info("DCE_CustomMixClassAttack | fin")
	end

	local idTypeStrike  = "Bombing"
	-- if id_task == "CAS" then												--  M54_a		
	-- 	idTypeStrike  = "AttackUnit"  --TODO a confirmer que cela fonctionne sur un static	
	-- end

	if AttackCounter[TargetList[1]] then									--counter with number of flights that have already attacked this target
		AttackCounter[TargetList[1]] = AttackCounter[TargetList[1]] + 1		--increase counter by one
	else																	--no flight has attacked this target yet
		AttackCounter[TargetList[1]] = 1									--set to one
	end
	local AttackN = AttackCounter[TargetList[1]]

	env.info("DCE_CustomMixClassAttack : AttackN "..tostring(AttackN))

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

			local targetName = TargetList[num][1]
			local targetClass = TargetList[num][2]
			local targetX = tostring(TargetList[num][3])
			local targetY = tostring(TargetList[num][4])
			local targetTemp = false
			local targetTempPos = {}
			local TargetID

			env.info("DCE_CustomMixClassAttack :targetName AA |"..tostring(targetName).."|targetClass: "..tostring(targetClass))

			if targetClass == "static" then
				targetTemp = StaticObject.getByName(targetName)
				if targetTemp then
					targetTempPos ={
						x = targetTemp:getPoint().x,
						y = targetTemp:getPoint().z,
					}
					-- idTypeStrike  = "AttackUnit"
					-- TargetID = targetTemp:getID()

					idTypeStrike  = "Bombing"

					env.info("DCE_CustomMixClassAttack static found BB1 |"..tostring(targetName).."|")
					_affiche(targetTemp, "targetName StaticObject.getByName")
				end

			elseif (targetClass == "MapObject" or targetClass == nil or targetClass == "nil") then
				targetTempPos ={
					x = targetX,
					y = targetY,
				}
				targetTemp = true
				idTypeStrike  = "Bombing"

				env.info("DCE_CustomMixClassAttack MapObject found BB2 |"..tostring(targetName).."|")
				_affiche(targetTemp, "targetName Unit.getByName")

			elseif  targetClass == "nil" then
				targetTempPos ={
					x = targetX,
					y = targetY,
				}
				targetTemp = true
				idTypeStrike  = "Bombing"

				env.info("DCE_CustomMixClassAttack MapObject found BB22 |"..tostring(targetName).."|")
				_affiche(targetTemp, "targetName Unit.getByName")

			else --if targetClass == "vehicle" then
				targetTemp = Unit.getByName(targetName)
				if targetTemp then
					targetTempPos ={
						x = targetTemp:getPoint().x,
						y = targetTemp:getPoint().z,
					}
					-- idTypeStrike  = "AttackUnit"
					-- TargetID = targetTemp:getID()

					idTypeStrike  = "Bombing"

					env.info("DCE_CustomMixClassAttack vehicle found BB3 |"..tostring(targetName).."|")
					_affiche(targetTemp, "targetName Unit.getByName")
				end
			end

			if targetTemp then							--make sure that static object still exists
				env.info("DCE_CustomMixClassAttack: DD1 ")

				-- local TargetID = targetTemp:getID()	--get static object ID

				local task_entry = {									--define attack task
					["enabled"] = true,
					["auto"] = false,
					["id"] = idTypeStrike,
					["name"] = "task: "..tostring(id_task).." class: "..tostring(targetClass),
					["number"] = #ComboTask.params.tasks + 1,
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
					task_entry.params["unitId"] = tonumber(TargetID)
					task_entry.params["attackQtyLimit"] = false
					task_entry.params["x"] = nil
					task_entry.params["y"] = nil
				end

				env.info("DCE_CustomMixClassAttack: DD2 |"..tostring(FlightName).."| |"..tostring(task_entry["id"]))

				table.insert(ComboTask.params.tasks, task_entry)

			end
		end

		local nextSecond = math.ceil(timer.getTime()) + 1
		if agendaSeconde[nextSecond] then
			local i = 1
			repeat
				nextSecond = nextSecond + 1
				i = i + 1
			until not agendaSeconde[nextSecond] or i > 1000
			agendaSeconde[nextSecond] = true
		else
			agendaSeconde[nextSecond] = true
		end

		timer.scheduleFunction(Execute, {cntrl, ComboTask, n} , nextSecond)

	end
end
----- attack multiple map objects -----
--allows each wingman of a flight to attack its own individual target simultaneously, then proceed to Egress point to join up (flight would not climb during egress if wingmen would joing leader imediately after attack)
function CustomMapObjectAttack(FlightName, TargetList, expend, weaponType, attackType, attackAlt, id_task)
	if varFpsLeak then return end
	env.info("DCE_CustomMapObjectAttack:  | start| "..tostring(FlightName))

	local idTypeStrike  = "Bombing"

	local function Execute(arg)
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

	if AttackCounter[TargetList[1].x .. TargetList[1].y] then															--counter with number of flights that have already attacked this target
		AttackCounter[TargetList[1].x .. TargetList[1].y] = AttackCounter[TargetList[1].x .. TargetList[1].y] + 1		--increase counter by one
	else																												--no flight has attacked this target yet
		AttackCounter[TargetList[1].x .. TargetList[1].y] = 1															--set to one
	end
	local AttackN = AttackCounter[TargetList[1].x .. TargetList[1].y]

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
		if agendaSeconde[nextSecond] then
			local i = 1
			repeat
				nextSecond = nextSecond + 1
				i = i + 1
			until not agendaSeconde[nextSecond] or i > 1000
			agendaSeconde[nextSecond] = true
		else
			agendaSeconde[nextSecond] = true
		end

		timer.scheduleFunction(Execute, {cntrl, ComboTask, n} , nextSecond)


	end
end


----- attack aircraft on ground -----
--allows each wingman of a flight to attack its own target aircraft on ground simultaneously, then proceed to Egress point to join up (flight would not climb during egress if wingmen would joing leader imediately after attack)
function CustomAirbaseAttack(FlightName, TargetPos, expend, weaponType, attackType, attackAlt)
	if varFpsLeak then return end
	if AttackCounter[TargetPos.x .. TargetPos.y] then													--counter with number of flights that have already attacked this target
		AttackCounter[TargetPos.x .. TargetPos.y] = AttackCounter[TargetPos.x .. TargetPos.y] + 1		--increase counter by one
	else																								--no flight has attacked this target yet
		AttackCounter[TargetPos.x .. TargetPos.y] = 1													--set to one
	end
	local AttackN = AttackCounter[TargetPos.x .. TargetPos.y]

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
						local uP = u:getPoint()												--get aircraft point
						table.insert(TargetList, {x = uP.x, y = uP.z})						--insert x-y coordinates into targetlist
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

	local function Execute(cntrl)
		cntrl:resetTask()												--reset task (wingman will rejoin with leader)

		if camp.debug then

			env.info("DCE_CustomRejoin | Execute | cntrl:resetTask()| "..tostring(cntrl).." actualtime: "..tostring(timer.getTime()))
			_affiche(cntrl, "DCE_CustomRejoin cntrl")

		end
	end

	local flight = Group.getByName(FlightName)						--get group of attacking flight
	local wingman = flight:getUnits()								--get list of units from attacking flights
	-- for n = 2, #wingman do
	for n = 2, #wingman do											--iterate through wingmen in flight
		local cntrl = wingman[n]:getController()					--get controller of individual aircraft in flight

		local nextSecond = math.ceil(timer.getTime()) + 1
		if agendaSeconde[nextSecond] then
			local i = 1
			repeat
				nextSecond = nextSecond + 1
				i = i + 1
			until not agendaSeconde[nextSecond] or i > 1000
			agendaSeconde[nextSecond] = true
		else
			agendaSeconde[nextSecond] = true
		end
		env.info("DCE_CustomRejoin: | next_Execute| "..tostring(FlightName).." wingman: "..n.." actualtime: "..tostring(timer.getTime()).." nextSecond: "..tostring(nextSecond))
		timer.scheduleFunction(Execute, cntrl, nextSecond)
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
		local tgt_p = tgt_units[1]:getPoint()						--get group leader point
		tgt_x = tgt_p.x
		tgt_y = tgt_p.z
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


----- target laser illumination -----
function CustomLaserDesignation(FlightName, target, class, LaserCode)
	if varFpsLeak then return end
	local laser														--variable to hold the laser spot

	if class == "vehicle" then										--target is a vehicle/ship group

		local function DesignationCycle()							--laser designation cycle function
			if laser and laser ~= nil then											--if there is already an existing laser spot
				laser:destroy()										--destroy it
			end

			local group = Group.getByName(target)					--get target group
			local units = group:getUnits()							--get target units

			local flight = Group.getByName(FlightName)				--get group of designating flight
			if flight then
				local wingman = flight:getUnits()						--get list of units from designating flights

				if wingman[1] and units[1] then							--if target group has a leader unit left
					local pos = units[1]:getPoint()						--get target position
					laser = Spot.createLaser(wingman[1], nil, pos, LaserCode)	--start laser spot
				end
			end

			if laser and laser ~= nil then											--if there is a new laser spot
				return timer.getTime() + 2							--repeat designation cylce in 2 seconds
			else													--if no laser spot was created
				return												--stop designation cycle
			end
		end
		timer.scheduleFunction(DesignationCycle, nil, timer.getTime() + 1)	--start designation cylce

	elseif class == "static" then									--targets are static objects
		local u = 0													--TargetList counter

		local function DesignationCycle()							--laser designation cycle function
			if laser and laser ~= nil then											--if there is already an existing laser spot
				laser:destroy()										--destroy it
			end

			repeat
				u = u + 1											--iterate through all target elements
			until StaticObject.getByName(target[u]) or u == #target		--repeat until first alive static object is found in TargetList or end of TargetList is reached

			local static = StaticObject.getByName(target[u])		--get static object

			local flight = Group.getByName(FlightName)				--get group of designating flight
			local wingman = flight:getUnits()						--get list of units from designating flights

			if wingman[1] and static then							--if flight leader and static object are alive
				local pos = static:getPoint()						--get target position
				laser = Spot.createLaser(wingman[1], nil, pos, LaserCode)	--start laser spot
			end

			if laser and laser ~= nil then											--if there is a new laser spot
				return timer.getTime() + 2							--repeat designation cylce in 2 seconds
			else													--if no laser spot was created
				return												--stop designation cycle
			end
		end
		timer.scheduleFunction(DesignationCycle, nil, timer.getTime() + 1)	--start designation cylce

	elseif class == "scenery" then									--targets are scenery objects
		local u = 0													--TargetList counter

		local function DesignationCycle()							--laser designation cycle function
			if laser and laser ~= nil then											--if there is already an existing laser spot
				laser:destroy()										--destroy it
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
				laser = Spot.createLaser(wingman[1], nil, pos, LaserCode)	--start laser spot
			end

			if laser and laser ~= nil  then											--if there is a new laser spot
				return timer.getTime() + 2							--repeat designation cylce in 2 seconds
			else													--if no laser spot was created
				return												--stop designation cycle
			end
		end
		timer.scheduleFunction(DesignationCycle, nil, timer.getTime() + 1)	--start designation cylce
	end
end

----- target laser illumination -----
function CustomLaserDesignationAFAC(AfacFlightName, refX, refY, LaserCode)
	if varFpsLeak then return end

	env.info("DCE_CustomLaserDesignationAFAC AA : START "..tostring(AfacFlightName))
	trigger.action.outText("AFAC : START "..tostring(AfacFlightName), 15)

	local laser														--variable to hold the laser spot

	local flightGroup = Group.getByName(AfacFlightName)
	local Coalition = flightGroup:getCoalition()
	local unitsAFAC = flightGroup:getUnits()
	local unitAFAC = unitsAFAC[1]

	if unitAFAC and  unitAFAC:isExist()  then
		AFAC_available[AfacFlightName] = {
				["unitAFAC"] = unitAFAC,
				-- ["gpGid"] = 0,
			}
	else
		AFAC_available[AfacFlightName] = nil
	end

	--recupere les dynamique
	local GroundGroups = coalition.getGroups(coalitionIdNumericENI[Coalition], Group.Category.GROUND)
	local unitGroundSelected_A = {}
	local unitGroundSelected_B = {}

	for i, gp in pairs(GroundGroups) do
		local gpName = Group.getName(gp)
		local units = gp:getUnits()

		for n=1, #units do

			local _unit = units[n]
			if  _unit:isActive()  then

				local description = _unit:getDesc()

				local life = description.life
				local unitPos = _unit:getPoint()
				local gpGid = Group.getID(gp)
				local UnitId = Unit.getID(_unit)
				local unitCallsign = _unit:getCallsign()
				local unitTypeName = _unit:getTypeName()

				local distance = math.floor(math.sqrt(math.pow(unitPos.x - refX, 2) + math.pow(unitPos.z - refY, 2)))
				env.info("DCE_CustomLaserDesignationAFAC :DD_2a  "..distance)

				if distance < 50000 then

					env.info("DCE_CustomLaserDesignationAFAC :EEa  "..tostring(unitTypeName))

					local item = {
						unitGround = _unit,
						unitTypeName = unitTypeName,
						unitPos = unitPos,
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



	--recupere les static
	local statics = coalition.getStaticObjects(coalitionIdNumericENI[Coalition])
	_affiche(statics, "statics CustomTS")

	for i, static in pairs(statics) do
		local stName = Object.getName(static)
		-- local units = gp:getUnits()

		-- for n=1, #units do

			-- local _unit = units[n]
			env.info("DCE_CustomLaserDesignationAFAC :BB1  "..stName)

			local stLife = static:getLife()
			env.info("DCE_CustomLaserDesignationAFAC :BB2  "..stLife)

			if  stLife > 0  then

				env.info("DCE_CustomLaserDesignationAFAC :CC  "..stName)

				local description = static:getDesc()

				local life = description.life
				local unitPos = static:getPoint()
				local UnitId = static:getID()
				local unitTypeName = static:getTypeName()

				local distance = math.floor(math.sqrt(math.pow(unitPos.x - refX, 2) + math.pow(unitPos.z - refY, 2)))
				env.info("DCE_CustomLaserDesignationAFAC :DD_2b  "..distance)

				if distance < 50000 then

					env.info("DCE_CustomLaserDesignationAFAC :EEb  "..tostring(unitTypeName))

					local item = {
						unitGround = static,
						unitTypeName = unitTypeName,
						name = stName,
						unitPos = unitPos,
						desc = description,
						distance = distance,
						life = life,
						UnitId = UnitId,
						isStatic = true,

					}

					table.insert(unitGroundSelected_A, item)

				end
			end
		-- end
	end

	table.sort(unitGroundSelected_A, function(a,b) return a.distance < b.distance  end)

	for i = 1, 60 do
		table.insert(unitGroundSelected_B, unitGroundSelected_A[i])
	end
	unitGroundSelected_A = nil

	-- table.sort(unitGroundSelected_B, function(a,b) return a.life > b.life  end)

	env.info("DCE_CustomLaserDesignationAFAC :FF  "..tostring(#unitGroundSelected_B))

	for i, target in pairs(unitGroundSelected_B) do

		_affiche(target, "unitGroundSelected_B.target CustomLaserDesignationAFAC")
	end

	local actuelTarget = 0
	local nextTarget = 0
	local laseUnitId = 0

	local function DesignationCycle()							--laser designation cycle function

		_affiche(AFAC_available, "AFAC_available DesignationCycle")

		if AFAC_available[AfacFlightName] and AFAC_available[AfacFlightName]["gpGid"] then
			env.info("DCE_CustomLaserDesignationAFAC :GG1 ")
			-- trigger.action.outTextForGroup(AFAC_available[AfacFlightName]["gpGid"],"AFAC : passe GG1", 15, false)	
		end
		if unitAFAC and  unitAFAC:isExist()  then

			--detecte si l'AFAC rentre:
			local AfacPos = unitAFAC:getPoint()
			local distAFAC_Pattern = math.floor(math.sqrt(math.pow(AfacPos.x - refX, 2) + math.pow(AfacPos.z - refY, 2)))

			env.info("DCE_CustomLaserDesignationAFAC :GG2 distAFAC_Pattern "..tostring(distAFAC_Pattern))
			-- trigger.action.outText("AFAC : passe GG2 distance: "..tostring(distAFAC_Pattern), 15)	

			if  distAFAC_Pattern < 150000 then

				for i, target in pairs(unitGroundSelected_B) do

					if i >= #unitGroundSelected_B then
						env.info("DCE_CustomLaserDesignationAFAC :II plus aucune cible dans la table ")
						if AFAC_available[AfacFlightName] and AFAC_available[AfacFlightName]["gpGid"] then
							trigger.action.outTextForGroup(AFAC_available[AfacFlightName]["gpGid"],"AFAC : plus aucune cible dans la table", 15, false)
						end
							if laser and laser ~= nil  then
								laser:destroy()
								laseUnitId = 0
							end
						return
					elseif not target.isStatic and (not target.unitGround:isExist() or not target.unitGround:isActive() or target.unitGround:getLife() <= 0) then

						env.info("DCE_CustomLaserDesignationAFAC cette cible est déjà détruite :JJa "..tostring(unitGroundSelected_B[i].unitTypeName).." "..tostring(unitGroundSelected_B[i].UnitId))

					elseif target.isStatic and (not Object.isExist(target.unitGround) or  target.unitGround:getLife() <= 0) then

						env.info("DCE_CustomLaserDesignationAFAC cette cible est déjà détruite :JJb "..tostring(unitGroundSelected_B[i].unitTypeName).." "..tostring(unitGroundSelected_B[i].UnitId))

					else
						if unitGroundSelected_B[i].UnitId == laseUnitId then

							env.info("DCE_CustomLaserDesignationAFAC :JJJ_2  meme cible "..tostring(unitGroundSelected_B[i].unitTypeName).." "..tostring(unitGroundSelected_B[i].UnitId) )
							if AFAC_available[AfacFlightName] and AFAC_available[AfacFlightName]["gpGid"] then
								trigger.action.outTextForGroup(AFAC_available[AfacFlightName]["gpGid"],"AFAC Same Target : "..tostring(unitGroundSelected_B[i].unitTypeName).." LaserCode: "..tostring(LaserCode), 15, false)
							end

							if unitGroundSelected_B[i].LLpos and AFAC_available[AfacFlightName] and AFAC_available[AfacFlightName]["gpGid"]  then
								trigger.action.outTextForGroup(AFAC_available[AfacFlightName]["gpGid"],"AFAC Target Position: "..tostring(unitGroundSelected_B[i].LLpos), 15, false)
							end
							break
						elseif unitGroundSelected_B[i].UnitId ~= laseUnitId then
							-- nextTarget = i
							actuelTarget = i

							env.info("DCE_CustomLaserDesignationAFAC :JJJ_3  nouvelle cible UnitId "..tostring(unitGroundSelected_B[i].unitTypeName).." "..tostring(unitGroundSelected_B[i].UnitId).." ~= ? laseUnitId"..tostring(laseUnitId))
							if AFAC_available[AfacFlightName] and AFAC_available[AfacFlightName]["gpGid"] then
								trigger.action.outTextForGroup(AFAC_available[AfacFlightName]["gpGid"],"AFAC NEW Target : "..tostring(unitGroundSelected_B[i].unitTypeName), 15, false)
							end

							break
						else
							env.info("DCE_CustomLaserDesignationAFAC :JJJ_4  ELSE BUG i "..i)
							_affiche(unitGroundSelected_B[i], "unitGroundSelected_B[i] bug")
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

				-- 			env.info("DCE_CustomLaserDesignationAFAC r: "..r.." :rand A "..tostring(rand).." nbActifTarget[rand]: "..tostring(nbActifTarget[rand]))

				-- 			unitGroundSelected_B[nbActifTarget[rand]].unitGround:destroy()

				-- 			env.info("DCE_CustomLaserDesignationAFAC :kill pour test B "..unitGroundSelected_B[nbActifTarget[rand]].UnitId)
				-- 			trigger.action.outText("AFAC kill pour test "..unitGroundSelected_B[nbActifTarget[rand]].UnitId, 15)
				-- 		end
				-- 	else
				-- 		env.info("DCE_CustomLaserDesignationAFAC :kill pour test C "..unitGroundSelected_B[actuelTarget].UnitId)
				-- 		unitGroundSelected_B[actuelTarget].unitGround:destroy()
				-- 	end

				-- 	unitGroundSelected_B[actuelTarget].TimeLase = timer.getTime()
				-- end

				if unitAFAC then

					if  unitGroundSelected_B[actuelTarget] and laser == nil then
						local pos = unitGroundSelected_B[actuelTarget].unitPos
						laser = Spot.createLaser(unitAFAC, nil, pos, LaserCode)	--start laser spot

						laseUnitId = unitGroundSelected_B[actuelTarget].UnitId

						local LLposNstring, LLposEstring = LLtool.LLstrings(pos)

						local LLpos = ' N ' .. LLposNstring .. '   E ' .. LLposEstring

						unitGroundSelected_B[actuelTarget]["LLpos"] = LLpos

						unitGroundSelected_B[actuelTarget]["TimeLase"] = timer.getTime()

						env.info("DCE_CustomLaserDesignationAFAC : LL createLaser LaserCode: "..tostring(LaserCode))
						if AFAC_available[AfacFlightName] and AFAC_available[AfacFlightName]["gpGid"] then
							trigger.action.outTextForGroup(AFAC_available[AfacFlightName]["gpGid"],"AFAC createLaser LaserCode: "..tostring(LaserCode), 30, false)
							trigger.action.outTextForGroup(AFAC_available[AfacFlightName]["gpGid"],"AFAC target position: "..tostring(LLpos), 30, false)
						end

					elseif  unitGroundSelected_B[actuelTarget]  and laseUnitId ~= unitGroundSelected_B[actuelTarget].UnitId then


						local pos = unitGroundSelected_B[actuelTarget].unitPos
						laser:setPoint(pos)

						laseUnitId = unitGroundSelected_B[actuelTarget].UnitId

						local LLposNstring, LLposEstring = LLtool.LLstrings(pos)

						local LLpos = ' N ' .. LLposNstring .. '   E ' .. LLposEstring

						unitGroundSelected_B[actuelTarget]["LLpos"] = LLpos

						unitGroundSelected_B[actuelTarget]["TimeLase"] = timer.getTime()

						env.info("DCE_CustomLaserDesignationAFAC : LL setPoint LaserCode: "..tostring(LaserCode))
						if AFAC_available[AfacFlightName] and AFAC_available[AfacFlightName]["gpGid"] then
							trigger.action.outTextForGroup(AFAC_available[AfacFlightName]["gpGid"],"AFAC setPoint LaserCode: "..tostring(LaserCode), 30, false)
							trigger.action.outTextForGroup(AFAC_available[AfacFlightName]["gpGid"],"AFAC target position: "..tostring(LLpos), 30, false)
						end
					end
				end

			else

				_affiche(unitAFAC, "unitAFAC")
				env.info("DCE_CustomLaserDesignationAFAC :ZZ  Reaper  Trop loin, fin du laser distAFAC_Pattern > 150km? "..tostring(distAFAC_Pattern))
				if AFAC_available[AfacFlightName] and AFAC_available[AfacFlightName]["gpGid"] then
					trigger.action.outTextForGroup(AFAC_available[AfacFlightName]["gpGid"],"AFAC DCE_CustomLaserDesignationAFAC :ZZ  Reaper Trop loin, fin du laser distAFAC_Pattern > 150km? "..tostring(distAFAC_Pattern), 15, false)
				end
				if laser and laser ~= nil  then
					laser:destroy()
					laseUnitId = 0

					env.info("DCE_CustomLaserDesignationAFAC :ZZ2  laser:destroy()	 ")

				end
			end

		else
			_affiche(unitAFAC, "unitAFAC")
			env.info("DCE_CustomLaserDesignationAFAC :ZZ  Reaper Dead  ")
			if AFAC_available[AfacFlightName] and AFAC_available[AfacFlightName]["gpGid"] then
				trigger.action.outTextForGroup(AFAC_available[AfacFlightName]["gpGid"],"AFAC DCE_CustomLaserDesignationAFAC :ZZ  Reaper Dead or not isExist ", 15, false)
			end
			if laser and laser ~= nil  then
				laser:destroy()
				laseUnitId = 0
				env.info("DCE_CustomLaserDesignationAFAC :ZZ2  laser:destroy()	 ")
			end

			if AFAC_available[AfacFlightName]  then
				AFAC_available[AfacFlightName] = nil
			end
			return
		end



		if laser and laser ~= nil then											--if there is a new laser spot
			env.info("DCE_CustomLaserDesignationAFAC :MM  ")

			return timer.getTime() + 60							--repeat designation cylce in 2 seconds										--stop designation cycle
		end
	end

	--detecte si l'AFAC rentre:
	local AfacPos = unitAFAC:getPoint()
	local distAFAC_Pattern = math.floor(math.sqrt(math.pow(AfacPos.x - refX, 2) + math.pow(AfacPos.z - refY, 2)))

	timer.scheduleFunction(DesignationCycle, nil, timer.getTime() + 60)	--start designation cylce


	env.info("DCE_CustomLaserDesignationAFAC : FIN "..tostring(AfacFlightName))
	trigger.action.outText("AFAC : FIN "..tostring(AfacFlightName), 15)

end
----- search then engage task -----
--allows to engage targets within a set distance from own group. CAUTION: Once this function is running, it group can no longer receive waypoint actions (DCS treats engage task set via script as never completed)!
function CustomSearchThenEngage(FlightName, Radius, TargetType, searchTime)
	if varFpsLeak then return end

	if not Radius or Radius == nil or Radius <= 80000 then
		Radius = 80000
	end
	if not searchTime or searchTime == nil then
		searchTime = timer.getTime() + 1800
	end

	local function ApplyEngageTargetsInZoneTask()							--engage targets in zone task needs to be applied continously to update zone position to group position

		local flight = Group.getByName(FlightName)							--get group
		if flight then														--group still exists

			local element = flight:getUnit(1)								--get first unit in group

			if not element   then
				local wingman = flight:getUnits()								--get list of units from attacking flights
				for n = 2, #wingman do
					element = flight:getUnit(n)
					if element then
						break
					end
				end
			end

			local RTB = false
			local gpGid = ""
			local callSign = ""
			local cat
			if element and element:getPlayerName() == nil and not RTB then
				gpGid = Group.getID(flight)
				callSign = Unit.getCallsign(element)
				cat = Group.getCategory(flight)

				if tabBingoPlane[gpGid] and tabBingoPlane[gpGid][callSign] then
					RTB = true
				end
			end

			if cat and element and element:getPlayerName() == nil and not RTB then

				local cntrl = flight:getController()						--get controller of group
				local pos = element:getPoint()								--get position
				local task_entry = {}

				if cat == 0 then  --Airplane
					task_entry = {										--define engage task		
						id = 'ControlledTask',
						params = {
							task = {
								["enabled"] = true,
								["auto"] = false,
								["id"] = "EngageTargetsInZone",
								["number"] = 1,		--TODO attention, est-ce vraiment le nombre 1?
								["params"] = {
									["targetTypes"] = {
										[1] = TargetType,
									},
									["x"] = pos.x,
									["y"] = pos.z,
									["value"] = TargetType .. ";",
									["priority"] = 0,
									["zoneRadius"] = Radius,
								}
							},
							stopCondition = {
								duration = 50,									--task is valid for 6 seconds only (after 5 seconds it is joined by the next iteration with updated zone position)
							}
						}
					}
				elseif cat == 1 then  -- helo
					task_entry = {										--define engage task		
						id = 'ControlledTask',
						params = {
							task = {
								["enabled"] = true,
								["auto"] = false,
								["id"] = "EngageTargetsInZone",
								["number"] = 1,		--TODO attention, est-ce vraiment le nombre 1?
								["params"] = {
									["targetTypes"] = { "Helicopters"},
									["x"] = pos.x,
									["y"] = pos.z,
									["value"] = TargetType .. ";",
									["priority"] = 0,
									["zoneRadius"] = 15000,
								}
							},
							stopCondition = {
								duration = 50,									--task is valid for 6 seconds only (after 5 seconds it is joined by the next iteration with updated zone position)
							}
						}
					}
				end

				cntrl:pushTask(task_entry)									--set task for group

				-- if camp.debug and cat == 1 then
				-- 	local TimeSearchEngage = timer.getTime() + 5
				-- 	local logStr = "task_entry = " .. TableSerialization(task_entry, 0)
				-- 	local FlightNameClean = FlightName:gsub('[%p%c%s]', '_')
				-- 	local logFile = io.open(path.."Debug\\"..FlightNameClean.."_"..TimeSearchEngage.."_".. "_CustomSearchThenEngage.lua", "w")
				-- 	logFile:write(logStr)
				-- 	logFile:close()				

				-- 	env.info( "DCE_CustomSearchThenEngage EEE "..tostring(FlightName).."| TargetType |"..tostring(TargetType).."| Radius |"..tostring(Radius))
				-- end

				local nextSecond = math.ceil(timer.getTime()) + 60
				if agendaSeconde[nextSecond] then
					local i = 1
					repeat
						nextSecond = nextSecond + 1
						i = i + 1
					until not agendaSeconde[nextSecond] or i > 1000
					agendaSeconde[nextSecond] = true
				else
					agendaSeconde[nextSecond] = true
				end

				return nextSecond									--repeat function every 5 seconds	

			end
		end
	end

	local nextSecond = math.ceil(timer.getTime()) + 1
	if agendaSeconde[nextSecond] then
		local i = 1
		repeat
			nextSecond = nextSecond + 1
			i = i + 1
		until not agendaSeconde[nextSecond] or i > 1000
		agendaSeconde[nextSecond] = true
	else
		agendaSeconde[nextSecond] = true
	end

	-- env.info( "DCE_CustomSearchThenEngage GGG "..tostring(FlightName).." timer.getTime(): "..tostring(timer.getTime())
	-- .." searchTime: "..tostring(searchTime)
	-- )

	if timer.getTime() > searchTime then
		env.info( "CustomSearchThenEngage timer.getTime() > searchTime return "..tostring(FlightName).."  searchTime: "..tostring(searchTime))
		return
	end
	timer.scheduleFunction(ApplyEngageTargetsInZoneTask, nil, nextSecond)			--schedule function

	-- timer.scheduleFunction(ApplyEngageTargetsInZoneTask, nil, timer.getTime() + 1)			--schedule function
end


----------------------------------------------------------------------------------------------------
----- orbit position task -----
----------------------------------------------------------------------------------------------------

--lets flight orbit at the current position the task was applied (regardless of waypoints)
function OrbitPosition(FlightName, Alt, Speed, UntilTime)
	if varFpsLeak then return end
	local flight = Group.getByName(FlightName)							--get group
	local current_time0 = timer.getTime()
	env.info(
		"DCE_Orbit A, grpname |"..tostring(FlightName).."|Alt|"..tostring(Alt).."|Speed|"
		..tostring(Speed).."|UntilTime|"..tostring(UntilTime).."|current_time0|"..tostring(current_time0)
	)

	local function Execute()
		env.info("DCE_Orbit B ")

		if flight then														--group still exists


			local current_time = timer.getTime()
			env.info( "DCE_Orbit C "..tostring(FlightName)..tostring(current_time))

			-- local var_duration = tonumber(UntilTime) - current_time

			local leader = flight:getUnit(1)								--get first unit in group
			local cntrl = flight:getController()							--get controller of group
			local pos = leader:getPoint()									--get position

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
							["altitude"] = Alt,
							["pattern"] = "Circle",
							["speed"] = Speed,
							["point"] = { x = pos.x, y = pos.z},
						},
					},
					["stopCondition"] =
					{
						["time"] = tonumber(UntilTime),
						-- ["duration"] = tonumber(var_duration),
					}
				}
			}
			cntrl:pushTask(task_entry)										--set task for group

			if camp.debug then
				local logStr = "OrbitPosition = " .. TableSerialization(task_entry, 0)
				local FlightNameClean = FlightName:gsub('[%p%c%s]', '_')
				local logFile = io.open(PathDCE.."Debug\\"..FlightNameClean.."_".. "OrbitPosition_"..current_time..".lua", "w")
				if logFile then
					logFile:write(logStr)
					logFile:close()
				else
					env.info("DCE_OrbitPosition: Failed to open log file for writing.")
				end
			end
		end
	end

	timer.scheduleFunction(Execute, nil, timer.getTime() + 2)

end


----------------------------------------------------------------------------------------------------
------------------------------------ RTB task ------------------------------------------------------
----------------------------------------------------------------------------------------------------

--actualizes the xy position of the CV/base to assign a correct position to WPT landing
function Custom_RTB_2_Base(grpname, BaseName, speed, alt)
	if varFpsLeak_B then return end
	env.info( "Custom_RTB_2_Base A, grpname |"..tostring(grpname).."|"..tostring(BaseName).."|"..tostring(speed).."|"..tostring(alt))

	local function Execute()

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

			local posFlight = leader:getPoint()									--get position
			local pt_start = {
				x2d = posFlight.x,
				y2d = posFlight.z,
				z2d = posFlight.y,
			}

			local posBase = base:getPoint()										--get position	
			local uId = base:getID()
			local pt_landing = {
				x2d = posBase.x,
				y2d = posBase.z,
				z2d = posBase.y,
				Id = uId,
			}

			local current_time = timer.getTime()
			local distance01 = math.sqrt(math.pow(pt_start.x2d - pt_landing.x2d, 2) + math.pow(pt_start.y2d - pt_landing.y2d, 2))

			local route = {}
			route = {
					[1] =
					{
						["alt"] = tonumber(pt_start.z2d + 100),
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
						["y"] = pt_start.y2d,
						["x"] = pt_start.x2d,
						["name"] = "",
						["formation_template"] = "",
						["speed_locked"] = true,
					}, -- end of [1]  
				[2] =
				{
					["alt"] = tonumber((pt_start.z2d + pt_landing.z2d + 100) / 2),
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
					["y"] = pt_landing.y2d,
					["x"] = pt_landing.x2d,
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

	timer.scheduleFunction(Execute, nil, timer.getTime() + 1)

end	--Custom_RTB_2_Base


----------------------------------------------------------------------------------------------------
------------------------------------ Custom_AddWptSAR task ------------------------------------------
----------------------------------------------------------------------------------------------------

--ajoute des wpt lorsqu'il trouve un EjectedPilot en plus
function Custom_AddWptSAR(grpname, BaseName, mgrsChute, speed, alt)
	if varFpsLeak_B then return end

	local current_time = timer.getTime()
	env.info( "current_time: "..tostring(current_time).." Custom_AddWptSAR A, grpname |"..tostring(grpname).."|"..tostring(BaseName).."|"..tostring(speed).."|"..tostring(alt))

	local function Execute()
		local current_time = timer.getTime()
		env.info( "current_time: "..tostring(current_time).." Custom_AddWptSAR B, grpname |"..tostring(grpname).."|"..tostring(BaseName).."|"..tostring(speed).."|"..tostring(alt))

		local flight = Group.getByName(grpname)
		local grpSide = tostring(flight:getCoalition())						--obligé pour le string, car 0 est impossible en numerotation de table	
		local leader = flight:getUnit(1)
		local base = Unit.getByName(BaseName)								--trouve le CV si c'en est un
		local  gpGid = Group.getID(flight)

		if not base or base == nil then
			base = Airbase.getByName(BaseName)								--trouve la base si c'est un Airbase

			if not base or base == nil then									--trouve la base si le nom est incomplet
				if  baseFullName[BaseName] then
					BaseName = baseFullName[BaseName]
					base = Airbase.getByName(BaseName)
					env.info( "Custom_AddWptSAR B2, BaseName |"..tostring(BaseName).."| base |"..tostring(base))
				else
					env.info( "Custom_AddWptSAR B3, BaseName |"..tostring(BaseName).."| base |"..tostring(base))
				end
			end

			env.info( "Custom_AddWptSAR C, BaseName |"..tostring(BaseName).."| base |"..tostring(base))
			-- _affiche(base, "Custom_AddWptSAR D base")
		end

		if leader and base  then
			local posFlight = leader:getPoint()
			local pt_start = {
				x2d = posFlight.x,
				y2d = posFlight.z,
				z2d = posFlight.y,
			}
			local pt_dest = {
				x2d = 0,
				y2d = 0,
				z2d = 0,
				Id = 0,
			}
			local FuelPercent = Unit.getFuel(leader)

			local posBase = base:getPoint()
			local uId = base:getID()

			local pt_landing = {
				x2d = posBase.x,
				y2d = posBase.z,
				z2d = posBase.y,
				Id = uId,
			}

			local current_time = timer.getTime()
			local distanceLanding = math.sqrt(math.pow(pt_start.x2d - pt_landing.x2d, 2) + math.pow(pt_start.y2d - pt_landing.y2d, 2))

			-- _affiche(zoneSAR, "Custom_AddWptSAR E zoneSAR")

			local selectedDistance = 999999
			local nb_survivor = 0

			for MGRS_Chute, zone in pairs(zoneSAR) do
				for N_Pilot, uPilot in ipairs(zone) do
					env.info( "Custom_AddWptSAR F  "..tostring(uPilot.name).."|"..tostring(mgrsChute).."|"..tostring(uPilot.status))

					if  string.lower(uPilot.side) ==  coalitionId[grpSide]  then
						if uPilot.name and uPilot.embarked ~= true  and (uPilot.status ==  "MIA" or uPilot.status ==  "EVAC_possible" )  then
							env.info( "Custom_AddWptSAR G "..tostring(uPilot.name).."|"..tostring(mgrsChute).."|"..tostring(uPilot.status))

							local distance = math.sqrt(math.pow(pt_start.x2d - uPilot.x2d, 2) + math.pow(pt_start.y2d - uPilot.y2d, 2))
							if distance < selectedDistance then
								selectedDistance = distance
								pt_dest = uPilot
								nb_survivor = nb_survivor + 1
								env.info( "Custom_AddWptSAR H no_rescue  "..tostring(nb_survivor))
							end
						end
					end
				end
			end

			env.info( "Custom_AddWptSAR nb_survivor  "..tostring(nb_survivor).." FuelPercent: "..tostring(FuelPercent))
			env.info( "Custom_AddWptSAR pt_start.c2d  "..tostring(pt_start.x2d).." pt_start.y2d: "..tostring(pt_start.y2d))

			local newRoute = {}
			if nb_survivor >= 1 and FuelPercent >= 0.5 and selectedDistance < 30001 then
				if selectedDistance > 30000 then
					env.info( "Custom_AddWptSAR I, CompteRenduEtonnement distance trop longue, la recuperation devrait etre verticale "..selectedDistance)
				end

				env.info( "Custom_AddWptSAR J, TENTE nouveau WPT distance "..selectedDistance)

				local distance01 = math.sqrt(math.pow(pt_start.x2d - pt_dest.x2d, 2) + math.pow(pt_start.y2d - pt_dest.y2d, 2))

				-- local distance = math.sqrt(math.pow(copyRoute[n].x - copyRoute[n+1].x, 2) + math.pow(copyRoute[n].y - copyRoute[n+1].y, 2))
				local heading = GetHeading({x=pt_dest.x2d, y=pt_dest.y2d} , {x=pt_landing.x2d, y=pt_landing.y2d} )
				local pt_inter = GetOffsetPoint({x=pt_dest.x2d, y=pt_dest.y2d}, heading , 1000 )
				env.info( "Custom_AddWptSAR K, pt_inter.x "..tostring(pt_inter.x))

				pt_inter.alti = land.getHeight({x =pt_inter.x, y = pt_inter.y})


				newRoute = {
					[1] =
						{
							["alt"] = tonumber(pt_start.z2d + 100),
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
							["y"] = pt_start.y2d,
							["x"] = pt_start.x2d,
							["formation_template"] = "",
							["speed_locked"] = true,
						}, -- end of [1]  
					[2] =
					{
						["alt"] = tonumber(pt_dest.z2d + 100),
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
						["y"] = pt_dest.y2d,
						["x"] = pt_dest.x2d,
						["name"] = "",
						["formation_template"] = "",
						["speed_locked"] = true,
					},
					[3] =
					{
						["alt"] = tonumber(pt_dest.z2d + 100),
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
																-- Custom_SAR(grpname, BaseName, BaseNameX2d, BaseNameY2d, mgrsChute, speed, alt)
													["command"] = "Custom_SAR('" .. grpname .. "', '" .. BaseName .. "', '" .. pt_landing.x2d .. "', '" .. pt_landing.y2d .. "', '" .. mgrsChute .. "', '" .. speed .. "', '" .. alt ..  "')",
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
						["y"] = pt_dest.y2d,
						["x"] = pt_dest.x2d,
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
						["alt"] = tonumber((pt_dest.z2d + pt_landing.z2d + 100) / 2),
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
						["y"] = pt_landing.y2d,
						["x"] = pt_landing.x2d,
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
					-- local  gpGid = Group.getID(flight)
					local copyRoute = {}
					local foundAeronef = false

					env.info( "Custom_AddWptSAR CSAR M  "..tostring(gpGid) )

					for tblGrpId, value in pairs(LastInjectFlightPlan) do
						env.info( "Custom_AddWptSAR CSAR N  tblGrpId "..tostring(tblGrpId) )

						if tblGrpId == gpGid then
							env.info( "Custom_AddWptSAR CSAR O  foundAeronef " )

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
						env.info( "Custom_AddWptSAR CSAR P  foundAeronef and attackPoint > 0 " )
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
						copyRoute[1].x = pt_start.x2d
						copyRoute[1].y = pt_start.y2d
						copyRoute[1]["alt"] = tonumber(pt_start.z2d + 100)

						newRoute = copyRoute
					else
						return
					end
				else	--if string.find(grpname, "CSAR") then


					newRoute = {
						[1] =
							{
								["alt"] = tonumber(pt_start.z2d + 100),
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
								["y"] = pt_start.y2d,
								["x"] = pt_start.x2d,
								["formation_template"] = "",
								["speed_locked"] = true,
							}, -- end of [1]  
						[2] =
						{
							["alt"] = tonumber((pt_dest.z2d + pt_landing.z2d + 100) / 2),
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
							["y"] = pt_landing.y2d,
							["x"] = pt_landing.x2d,
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
				else
					env.info("DCE_Custom_AddWptSAR: Failed to open log file for writing.")
				end
			end

			LastInjectFlightPlan[gpGid] = Mission
			env.info( "Custom_AddWptSAR Y  LastInjectFlightPlan setTask Debut " )

			local ctr = flight:getController()
			Controller.setTask(ctr, Mission)

			env.info( "Custom_AddWptSAR Z  setTask Fin " )

			--ajoute le plan de vol dans db, pour utiliser plus tard si necessaire, car DCS ne garde pas en env.mission les plan de vol ajouté à l'arrache


		end
	end

	timer.scheduleFunction(Execute, nil, timer.getTime() + 1)


end	--Custom_AddWptSAR


----------------------------------------------------------------------------------------------------
-------------------------------------------- SAR task ----------------------------------------------
----------------------------------------------------------------------------------------------------

--Makes a personalized approach depending on the presence of a landing point or a soldier or the sea 
function Custom_SAR(grpname, BaseName, BaseNameX2d, BaseNameY2d, mgrsChute, speed, alt)
	if varFpsLeak_B then return end
	local current_time = timer.getTime()
	env.info( "Custom_SAR A0 current_time: "..tostring(current_time).." grpname |"..tostring(grpname).."|"..tostring(BaseName).."|"..tostring(mgrsChute))

	local function Execute()
		local current_time = timer.getTime()
		env.info( "Custom_SAR B1, current_time: "..tostring(current_time))
		env.info( "Custom_SAR BB2, grpname |"..tostring(grpname).."|"..tostring(BaseName).."|"..tostring(mgrsChute).."|"..tostring(current_time))

		local flight = Group.getByName(grpname)								--get Group
		local leader = flight:getUnit(1)									--get first unit in group
		local Base = Unit.getByName(BaseName)								--get unit
		local grpSide = tostring(flight:getCoalition())
		local gpGid = Group.getID(flight)

		local posFlight = leader:getPoint()									--get position
		local currentPos = {
			x2d = posFlight.x,
			y2d = posFlight.z,
			z2d = posFlight.y,
		}

		local SarSpeed = speed /2 *3
		local pt_dest = {
			x2d = 0,
			y2d = 0,
			z2d = 0,
			Id = 0,
			SoldierGroupID = 0,
			landingPossible = false,
			uPilotName = "",
		}

		local posBase
		local uId
		local BaseNameZ2d = land.getHeight({x = BaseNameX2d, y = BaseNameY2d})
		local pt_landing = {
			x2d = BaseNameX2d,
			y2d = BaseNameY2d,
			z2d = BaseNameZ2d,
		}

		--TODO CV est aussi une base, il faut donc lui coller l'alti, ici aussi

		if Base  then
			posBase = Base:getPoint()
			uId = Base:getID()

			pt_landing.x2d = posBase.x
			pt_landing.y2d = posBase.z
			pt_landing.Id = uId

		end

		--TODO ajouter la distinction par camp (???)
		local PosEjectPilot

		local selected_distance = 9999999
		local selectedEjection = {}

		for MGRS_Chute, zone in pairs(zoneSAR) do
			env.info( "Custom_SAR C grpSide: " ..tostring(grpSide).."| MGRS_Chute: "..tostring(MGRS_Chute).." "..current_time)

			for N_Pilot, uPilot in ipairs(zone) do
				env.info( "Custom_SAR D1 uPilot.side: "..tostring(uPilot.side).."| coalitionId[grpSide]: "..tostring(coalitionId[grpSide]))

				if  string.lower(uPilot.side) ==  coalitionId[grpSide]  then
					env.info( "Custom_SAR DD2 uPilot.name: "..tostring(uPilot.name).."| uPilot.embarked: "..tostring(uPilot.embarked))

					local authorisesRescue = true
					local wrongSide = false
					local ENI_Side = DCS_ENI_Side[uPilot.side]
					if camp.boundary and camp.boundary[ENI_Side] and camp.boundary[ENI_Side] ~= nil then
						wrongSide =  CheckPointInPoly2({x=uPilot.x2d,y=uPilot.y2d} , camp.boundary[ENI_Side])
						env.info( "Custom_SAR DD3?  boundary wrongSide ? __"..tostring(wrongSide))
						if wrongSide  then
							authorisesRescue = false
						end
					end

					if authorisesRescue and uPilot.name and uPilot.name ~= nil and not uPilot.embarked then

						local unitPilot = Unit.getByName(uPilot.name)
						local temp_x2d, temp_y2d, temp_z2d = 0, 0, 0
						local distance = 0
						local temp_SoldierGroupID = 0
						local temp_landingPossible = uPilot.landingPossible


						env.info( "Custom_SAR E "..tostring(unitPilot).." |SurfaceType: "..tostring(uPilot.SurfaceType).." "..tostring(uPilot.name))

						if uPilot.SurfaceType == 3 then												--dans l'eau: pas de soldat
							env.info( "Custom_SAR F")

							temp_x2d, temp_y2d, temp_z2d = uPilot.x2d, uPilot.y2d, uPilot.z2d
							temp_SoldierGroupID = 0
						elseif unitPilot and unitPilot ~= nil then
							env.info( "Custom_SAR G")

							PosEjectPilot = unitPilot:getPoint()
							temp_x2d, temp_y2d, temp_z2d = PosEjectPilot.x, PosEjectPilot.z, PosEjectPilot.y
							temp_SoldierGroupID = unitPilot:getGroup():getID()
							-- temp_landingPossible = unitPilot.landingPossible

						end

						-- distance = math.sqrt(math.pow(currentPos.x2d - PosEjectPilot.x, 2) + math.pow(currentPos.y2d - PosEjectPilot.z, 2))
						distance = math.sqrt(math.pow(currentPos.x2d - temp_x2d, 2) + math.pow(currentPos.y2d - temp_y2d, 2))
						env.info( "Custom_SAR H1 distance: "..tostring(distance))

						if distance <= 15000 and distance < selected_distance  then
							env.info( "Custom_SAR HH2 ")

							selected_distance = distance

							pt_dest.x2d = temp_x2d
							pt_dest.y2d = temp_y2d
							pt_dest.z2d = temp_z2d
							pt_dest.landingPossible = temp_landingPossible

							selectedEjection = uPilot

							env.info( "Custom_SAR HHH3 landingPossible: "..tostring(pt_dest.landingPossible))

							pt_dest.SoldierGroupID = temp_SoldierGroupID
							pt_dest.uPilotName = uPilot.name
						end
					end
				end
			end
		end

		if selectedEjection.name then
			env.info( "Custom_SAR Ia selectedEjection.name: "..tostring(selectedEjection.name))
		end

		-- si pas de présence de soldat, simulant le piloteEjecté: on sort (cas des ejected en mer, par exemple)
		if pt_dest.x2d == 0 then
			env.info( "Custom_SAR Ib RETURN ************* ")
			return
		end

		local distanceLanding = math.sqrt(math.pow(currentPos.x2d - pt_landing.x2d, 2) + math.pow(currentPos.y2d - pt_landing.y2d, 2))
		local headingRTB = GetHeading({x=pt_dest.x2d, y=pt_dest.y2d} , {x=pt_landing.x2d, y=pt_landing.y2d} )
		-- local distanceRTB = distanceLanding/2
		local distanceRTB = 1500
		local pointRTB = GetOffsetPoint({x=pt_dest.x2d, y=pt_dest.y2d}, headingRTB, distanceRTB)
		local pointRTBz = land.getHeight({x =pointRTB.x, y = pointRTB.y})
		local pt50m
		local selectedTransport = 1

		--test tous les cas: landing or not
		if pt_dest.SoldierGroupID == 0 or pt_dest.theatreCercle == false then
			-- si pas Id soldier: ejectedPilot sur l eau, on ne se pose pas
			pt_dest.landingPossible = false

		elseif pt_dest.landingPossible then

			--on tente la position  50m plus loin que l'ejectedPilot pour ne par lui tomber dessus
			pt50m = GetOffsetPoint({x=pt_dest.x2d, y=pt_dest.y2d}, 0, 50 )

			env.info( "Custom_SAR Y NEW pt_dest LANDING "..tostring(pt50m.x).." "..tostring(pt50m.y))

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

			env.info( "Custom_SAR W test altiMin altiMax "..tostring(altiMax).." "..tostring(altiMin).." |testDeniv: "..tonumber(testDeniv))

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
					["alt"] = currentPos.z2d,
					["action"] = "Turning Point",
					["type"] = "Turning Point",
					["alt_type"] = "BARO",
					["speed"] = tonumber(SarSpeed),
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
					["y"] = currentPos.y2d,
					["x"] = currentPos.x2d,
					["name"] = "",
					["formation_template"] = "",
					["speed_locked"] = true,
				}, -- end of [1]  
			[2] =
			{
				["alt"] = pt_dest.z2d + 150 ,
				["action"] = "Turning Point",
				["alt_type"] = "BARO",
				["speed"] = tonumber(SarSpeed),
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
				["ETA"] =  (selected_distance / SarSpeed) + current_time ,
				["ETA_locked"] = false,
				["y"] = pt_dest.y2d,
				["x"] = pt_dest.x2d,
				["name"] = "",
				["formation_template"] = "",
				["speed_locked"] = true,
			},
			[3] =
			{
				["alt"] = pt_dest.z2d + 150,
				["action"] = "Turning Point",
				["alt_type"] = "BARO",
				["speed"] = tonumber(SarSpeed),
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
				["ETA"] =  (selected_distance / SarSpeed) + current_time + 2 ,
				["ETA_locked"] = false,
				["y"] = pt_dest.y2d,
				["x"] = pt_dest.x2d,
				["name"] = "",
				["formation_template"] = "",
				["speed_locked"] = true,
			},	--[3] = 
			[4] =
			{
				["alt"] = pointRTBz + 150 ,
				["action"] = "Turning Point",
				["alt_type"] = "BARO",
				["speed"] = tonumber(SarSpeed),
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
				["alt"] = tonumber(pt_landing.z2d + 100),
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
				["y"] = tonumber(pt_landing.y2d),
				["x"] = tonumber(pt_landing.x2d),
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
										["altitude"] = pt_dest.z2d + 80,
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
										["command"] = "Custom_AddWptSAR('" .. grpname .. "', '" .. BaseName .. "', '" .. mgrsChute .. "', '" .. speed .. "', '" .. alt ..  "')",
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

			env.info( "Custom_SAR M selectedTransport "..tostring(selectedTransport))

			route[3]["task"] =
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
										["command"] = "Custom_AddWptSAR('" .. grpname .. "', '" .. BaseName .. "', '" .. mgrsChute .. "', '" .. speed .. "', '" .. alt .. "')",
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

			env.info( "Custom_SAR N testDeniv < 5 landingPossible? (norm OUI) "..tostring(selectedEjection.landingPossible))


		elseif not pt_dest.landingPossible then
			-- testDeniv > 5  ( le denivellé est trop important, l helico se pose pas)

			route[3]["task"] =
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
										["command"] = "Custom_AddWptSAR('" .. grpname .. "', '" .. BaseName .. "', '" .. mgrsChute ..  "', '" .. speed ..  "', '" .. alt ..  "')",
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
						["pattern"] = "Circle",
						["speed"] = 0,		--["speed"] = 0.27777777777778,
						["altitude"] = 10,
						["altitudeEdited"] = true,
					}, -- end of ["params"]
				}

			end

			selectedEjection.landingPossible = false
			env.info( "Custom_SAR O testDeniv > 5 landingPossible? (norm NON) "..tostring(selectedEjection.landingPossible))

		end

		local Mission = {
			id = 'Mission',
			params = {
				route = {
					points = route
				}
			}
		}

		if camp.debug then
			local logStr = "Custom_SAR = " .. TableSerialization(Mission, 0)
			local grpnameClean = grpname:gsub('[%p%c%s]', '_')
			local logFile = io.open(PathDCE.."Debug\\"..grpnameClean.."_".. "Custom_SAR_"..current_time..".lua", "w")
			if logFile then
				logFile:write(logStr)
				logFile:close()
			else
				env.info("DCE_Custom_SAR_: Failed to open log file for writing.")
			end
		end
		env.info( "Custom_SAR, PASSE setTask PathDCE: "..tostring(PathDCE))

		--ajoute le plan de vol dans db, pour utiliser plus tard si necessaire, car DCS ne garde pas en env.mission les plan de vol ajouté à l'arrache
		LastInjectFlightPlan[gpGid] = Mission

		local ctr = flight:getController()
		Controller.setTask(ctr, Mission)

	end     --fin Execute

	timer.scheduleFunction(Execute, nil, timer.getTime() + 1)

end	--Custom_SAR



----------------------------------------------------------------------------------------------------
------------------------------------- Custom_Altitude task -----------------------------------------
----------------------------------------------------------------------------------------------------

--adapte l'altitude aux chaines montagneuse
function Custom_Altitude(grpname, wptAlti, wptTag)
	if varFpsLeak_B then return end

	if wptTag then
		wptTag = tonumber(wptTag)
	else
		wptTag = 0
	end
	if not wptAlti or wptAlti == nil then
		wptAlti = 1
		env.info( "Custom_Altitude, A wptAlti  |"..tostring(grpname).." |wptAlti: "..tostring(wptAlti))
	end
	local current_time = timer.getTime()
	env.info( "current_time: "..tostring(current_time).." Custom_Altitude, B wptAlti  |"..tostring(grpname).." |wptAlti: "..tostring(wptAlti))

	local function Execute()
		local current_time = timer.getTime()
		local flight = Group.getByName(grpname)

		local selectedMember = flight:getUnits(1)
		local wingman = flight:getUnits()
		-- for memberN, _unit in ipairs(wingman) do											
			-- if _unit and _unit:isActive() and _unit:inAir() then
				-- selectedMember = _unit
			-- end
		-- end

		for memberN, _unit in ipairs(wingman) do
			if _unit and _unit:isActive() and _unit:inAir() then
				selectedMember = _unit
			end
		end

		if not selectedMember or not selectedMember:isExist() then
			env.info(" Custom_Altitude, C1 selectedMember Erreur : selectedMember est invalide ou inexistant.")

			return
		end

		env.info( "current_time: "..tostring(current_time).." Custom_Altitude, C2 selectedMember |"..tostring(selectedMember))


		local ctr = selectedMember:getGroup():getController()
		local current_time = timer.getTime()
		local actualPosition = selectedMember:getPoint()
		local actualPositionXY = {
			x = actualPosition.x,
			y = actualPosition.z,
		}

		-- local leader = flight:getUnit(1)		
		-- local ctr = leader:getGroup():getController()
		-- local current_time = timer.getTime()
		-- local actualPosition = leader:getPoint()
		-- local actualPositionXY = {
		-- 	x = actualPosition.x,
		-- 	y = actualPosition.z,
		-- }

		local addAlti = 150
		local str_selectedMember = selectedMember:getTypeName()

		env.info( "current_time: "..tostring(current_time).." Custom_Altitude, C3 str_selectedMember |"..tostring(str_selectedMember))

		local str_selectedMember = selectedMember:getTypeName()
		if type(str_selectedMember) ~= "string" then
			env.info("Custom_Altitude, C4 Erreur : str_selectedMember n'est pas une chaîne.")
			return
		end

		if  (str_selectedMember == "Mi-24P" or str_selectedMember == "UH-1H") then
			addAlti = 250
		end

		if ctr then

			local  gpGid = Group.getID(flight)
			local foundAeronef = false
			local copyRoute = {}

			env.info( "Custom_Altitude, D gpGid? |"..tostring(gpGid))

			for tblGrpId, value in pairs(LastInjectFlightPlan) do
				if tblGrpId == gpGid then
					copyRoute = Deepcopy(value.params.route.points)
					foundAeronef = true
					env.info( "Custom_Altitude, D2_a found LastInjectFlightPlan tblGrpId |"..tostring(tblGrpId))
					break
				end
			end

			if not foundAeronef then
				env.info( "Custom_Altitude, E |")

				for _coalition, coalition in pairs(env.mission.coalition) do
					for Ncountry, _country in pairs(coalition.country) do
						if _country.helicopter then
							for Ngroup, _group in pairs(_country.helicopter.group) do
								if _group.groupId == gpGid then
									copyRoute = Deepcopy(_group.route.points)
									foundAeronef = true
									env.info( "Custom_Altitude, D2_b found foundAeronef _group.groupId |"..tostring(_group.groupId ))
									break
								end
							end
						end
						if foundAeronef then break end
					end
					if foundAeronef then break end
				end
			end

			env.info( "Custom_Altitude, E1a wptTag  "..tostring(wptTag))

			--enleve le script Custom_Altitude pour eviter de le reinjecter et d avoir une boucle
			if wptTag and wptTag ~= nil then
				for Npoint, point in ipairs(copyRoute)  do
					if tonumber(Npoint) == tonumber( wptTag) then
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

					local distance = math.sqrt(math.pow(point.x - actualPosition.x, 2) + math.pow(point.y - actualPosition.z, 2))
					if distance < 1000 then
						env.info( "Custom_Altitude, F1_ga   ")

						if point.task and point.task.params and point.task.params.tasks then
							for Ntask , taskFinal in ipairs(point.task.params.tasks)  do
								if taskFinal and taskFinal.params and taskFinal.params.action and taskFinal.params.action.id == "Script" then
									if taskFinal.params.action.params and  taskFinal.params.action.params.command and string.find(taskFinal.params.action.params.command,"Custom_Altitude") then

										env.info( "Custom_Altitude, F1_gb   ")

										point.task.params.tasks[Ntask] = nil

									end
								end
							end
						end

					end
				end
			end

			--enleve le script Custom_Altitude pour eviter de le reinjecter et d avoir une boucle
			-- local deleteBeforHere = false
			-- for m = #copyRoute, 1, -1 do
			-- 	--deleteBeforHere
			-- 	if copyRoute[m].name == "deleteBeforHere" then
			-- 		deleteBeforHere = true
			-- 	elseif deleteBeforHere then
			-- 		table.remove(copyRoute, m)
			-- 	end
			-- end

			--enleve le script Custom_Altitude pour eviter de le reinjecter et d avoir une boucle
			-- if wptTag and wptTag > 0 then

			-- 	-- Créer une copie du tableau pour éviter les problèmes d'indexation
			-- 	local copy = {}
			-- 	for i, v in ipairs(copyRoute) do
			-- 		table.insert(copy, v)
			-- 	end

			-- 	-- Supprimer les éléments du tableau d'origine
			-- 	for i = #copy, 1, -1 do
			-- 		if i <= wptTag then
			-- 			table.remove(copyRoute, i)
			-- 		end
			-- 	end
			-- end

			if wptTag and wptTag > 0 then
				for i = #copyRoute, 1, -1 do
					if i <= wptTag then
						table.remove(copyRoute, i)
					end
				end
			end


			if camp.debug then
				local logStr = "Mission = " .. TableSerialization(copyRoute, 0)
				local grpnameClean = grpname:gsub('[%p%c%s]', '_')
				local logFile = io.open(PathDCE.."Debug\\"..grpnameClean.."_".. "Custom_Altitude_copyRoute_"..current_time..".lua", "w")
				if logFile then
					logFile:write(logStr)
					logFile:close()
				else
					env.info("DCE_Custom_Altitude_copyRoute: Failed to open log file for writing.")
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

								-- env.info( "Custom_Altitude, F1_h find N Next Custom : "..tostring(Npoint))
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
					-- env.info( "Custom_Altitude, Gb break : "..tostring(n))
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
				local sondagePt
				local sondageAlti
				local selectedPoint
				local headingAlt
				local interDistance = 2500	--7500m ou 2500 m
				local oldAltiMax = 0
				local oldHeadingAlt = 0

				selectedPoint = {x=copyRoute[n].x, y=copyRoute[n].y}
				oldAltiMax = land.getHeight({x =selectedPoint.x, y = selectedPoint.y})

				for interval = 1, distance  , interDistance do

					if interval == 1 then
						-- selectedPoint = {x=copyRoute[n].x, y=copyRoute[n].y}
						-- oldAltiMax = land.getHeight({x =selectedPoint.x, y = selectedPoint.y})
					else
						-- prend le nouveau cap pour aller du point precedent calculé au futur point prévu par l'ancienne route
						heading = GetHeading({x=selectedPoint.x, y=selectedPoint.y} , {x=copyRoute[n+1].x, y=copyRoute[n+1].y} )
					end

					local AddHeadingMin = -5
					local AddHeadingMax = 5
					local AddDistance = 1000
					local altiMin0 = 999999
					local altiMax0 = 0
					local diffHeading = 10


					--regarde la topographie devant l helico
					--si c est montagneux, on augmente le nb de wpt, sinon on ne fait rien ou presque
					for AddHeading = -90 , 90 do
						for interval0 = 0, 1500 , 150 do
							local headingAlt0 = heading + AddHeading
							local sondagePt0 = GetOffsetPoint(selectedPoint, headingAlt0 , interval0 )
							local sondageAlti = land.getHeight({x =sondagePt0.x, y = sondagePt0.y})

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
						AddHeadingMin = -25
						AddHeadingMax = 25
						AddDistance = 1100
						diffHeading = 1
					elseif  diffAlti0 >= 950 then
						AddHeadingMin = -50
						AddHeadingMax = 50
						AddDistance = 400
						diffHeading = 5
					end

					local sumAlti = {}

					--cumul les alti pour trouver la plus petite sur les differents chemin calculé
					-- calcul pour la prochaine tranche de 5000m
					-- for AddHeading = -30 , 30 do
					for AddHeading = AddHeadingMin , AddHeadingMax do
						for interval0 = AddDistance, interDistance , AddDistance do
							headingAlt = heading + AddHeading
							sondagePt = GetOffsetPoint(selectedPoint, headingAlt , interval0 )
							sondageAlti = land.getHeight({x =sondagePt.x, y = sondagePt.y})

							if not sumAlti[tostring(AddHeading)] then
								sumAlti[tostring(AddHeading)] = {}
							end
							if not sumAlti[tostring(AddHeading)]["sum"]  then sumAlti[tostring(AddHeading)]["sum"]  = 0 end
							if not sumAlti[tostring(AddHeading)]["altiMax"]  then sumAlti[tostring(AddHeading)]["altiMax"]  = 0 end
							if not sumAlti[tostring(AddHeading)]["distance"]  then sumAlti[tostring(AddHeading)]["distance"]  = 0 end


							sumAlti[tostring(AddHeading)]["sum"] = sumAlti[tostring(AddHeading)]["sum"]  + sondageAlti
							sumAlti[tostring(AddHeading)]["distance"]  = interval0

							if sumAlti[tostring(AddHeading)]["altiMax"] < sondageAlti then
								sumAlti[tostring(AddHeading)]["altiMax"] = sondageAlti
							end
						end

						--regarde l'alti max sur une tres longue distance, pour ne pas s orienter vers une trop grande montagne
						for interval0 = 600 , 10000 , 500 do
							headingAlt = heading + AddHeading
							sondagePt = GetOffsetPoint(selectedPoint, headingAlt , interval0 )
							sondageAlti = land.getHeight({x =sondagePt.x, y = sondagePt.y})

							if not sumAlti[tostring(AddHeading)] then
								sumAlti[tostring(AddHeading)] = {}
							end
							if not sumAlti[tostring(AddHeading)]["altiMaxLong"]  then sumAlti[tostring(AddHeading)]["altiMaxLong"]  = 0 end

							if sumAlti[tostring(AddHeading)]["altiMaxLong"] < sondageAlti then
								sumAlti[tostring(AddHeading)]["altiMaxLong"] = sondageAlti

								if sumAlti[tostring(AddHeading)]["altiMaxLong"] < 3500 then
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
					for NaddHdg, value in pairs(sumAlti) do
						if  sumAlti[tostring(NaddHdg)].altiMaxLong < 2500 then
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

					local PrintAltiMaxLong =  0
					if sumAlti[tostring(selectHdg)] and sumAlti[tostring(selectHdg)].altiMaxLong then
						PrintAltiMaxLong =  math.floor(sumAlti[tostring(selectHdg)].altiMaxLong)
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
						if PrintAltiMaxLong >= 3500 then
							alti = PrintAltiMaxLong + addAlti
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

						-- env.info( "CustomTS x #copyRoute2: "..tostring(#copyRoute2))


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
				local grpnameClean = grpname:gsub('[%p%c%s]', '_')
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

	if agendaSeconde[nextSecond] then
		local i = 1
		repeat
			nextSecond = nextSecond + 1
			i = i + 1
		until not agendaSeconde[nextSecond] or i > 1000

		agendaSeconde[nextSecond] = true

		if i > 1000 then
			env.info( "Custom_Altitude, ERROR BOUCLE ")
		end
	else
		agendaSeconde[nextSecond] = true
	end

	timer.scheduleFunction(Execute, nil, nextSecond)

	-- timer.scheduleFunction(Execute, nil, timer.getTime() + 1)
end
