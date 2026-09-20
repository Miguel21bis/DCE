-- DCE_Background
-- Sous-systèmes qui tournent en tâche de fond, auto-démarrés via timer.scheduleFunction
-- (aucun n'est appelé depuis un menu radio ni depuis un autre fichier Mission Scripts) :
-- évitement de zones SAM (hotSpotSAM/chooseBestHotspot/avoidArea/airRetreat), EWR vocal
-- (EWR_speaking/EWR_magic), monitoring joueur (MonitorPlayerAircraftActivity/EventHandler2),
-- surveillance du pont porte-avions (CarrierDeckMonitor) et dashboard de perf (showPerformance).
-- Doit être chargé après DCE_Util_Common.lua (dont ces fonctions dépendent) et après
-- AddCommandRadioF10.lua (dont il reprend la suite logique).
-------------------------------------------------------------------------------------------------------
-- Extrait de AddCommandRadioF10.lua le 19/09/2026 (Chantier B2 - réorganisation DCE InGame) :
-- code repris tel quel, aucune logique modifiée.
-------------------------------------------------------------------------------------------------------
if not versionDCE then versionDCE = {} end
versionDCE["Mission Scripts/DCE_Background.lua"] = "1.0.0"
-------------------------------------------------------------------------------------------------------

env.info("DCE START LOADING DCE_Background.lua "..tostring(versionDCE["Mission Scripts/DCE_Background.lua"]))


local function hotSpotSAM()
    if not campL.groundthreats then return end

    DCE_hotspotGrid = {}

    for sideName, antiAirCover in pairs(campL.groundthreats) do
        DCE_hotspotGrid[sideName] = {}

        for _, cover in ipairs(antiAirCover) do
            if cover.class == "SAM" then
                local cx = math.floor(cover.x / DCE_hotspotCellSize)
                local cy = math.floor(cover.y / DCE_hotspotCellSize)
                local key = cx .. ":" .. cy

                local cell = DCE_hotspotGrid[sideName][key]
                if not cell then
                    cell = { sumX = 0, sumY = 0, count = 0 }
                    DCE_hotspotGrid[sideName][key] = cell
                end

                cell.sumX = cell.sumX + cover.x
                cell.sumY = cell.sumY + cover.y
                cell.count = cell.count + 1
            end
        end
    end
end


--[[ local function hotSpotSAMOLD()
    if not campL.groundthreats then return end

    local clusterThreshold = 100000 -- Distance max pour regrouper les SAMs

    for sideName, antiAirCover in pairs(campL.groundthreats) do
        local clusters = {}

        -- Parcourir chaque SAM
        for _, cover in ipairs(antiAirCover) do
            local addedToCluster = false

			if cover.class == "SAM" then
				-- Ajouter le SAM à un cluster existant s'il est proche
				for _, cluster in ipairs(clusters) do
					local dist = calculateDistance(cover.x, cover.y, cluster.centerX, cluster.centerY)
					if dist <= clusterThreshold then
						cluster.totalWeight = cluster.totalWeight + 1
						cluster.sumX = cluster.sumX + cover.x
						cluster.sumY = cluster.sumY + cover.y
						cluster.centerX = cluster.sumX / cluster.totalWeight
						cluster.centerY = cluster.sumY / cluster.totalWeight
						addedToCluster = true
						break
					end
				end

				-- Si aucun cluster n'est trouvé, en créer un nouveau
				if not addedToCluster then
					table.insert(clusters, {
						totalWeight = 1,
						sumX = cover.x,
						sumY = cover.y,
						centerX = cover.x,
						centerY = cover.y,
					})
				end
			end
        end

        -- Sauvegarder les clusters comme des hotspots
        hotSpotAirDefense[sideName] = {}
        for _, cluster in ipairs(clusters) do
            table.insert(hotSpotAirDefense[sideName], { x = cluster.centerX, y = cluster.centerY })
        end
    end
end ]]


local function chooseBestHotspot(pos, sideName)
    local grid = DCE_hotspotGrid[sideName]
    if not grid then return nil end

    local cx = math.floor(pos.x / DCE_hotspotCellSize)
    local cy = math.floor(pos.y / DCE_hotspotCellSize)

    local best = nil
    local bestDist = math.huge

    for dx = -1, 1 do
        for dy = -1, 1 do
            local key = (cx + dx) .. ":" .. (cy + dy)
            local cell = grid[key]

            if cell and cell.count > 0 then
                local hx = cell.sumX / cell.count
                local hy = cell.sumY / cell.count

                local d = calculateDistance(pos.x, pos.y, hx, hy)
                if d < bestDist then
                    bestDist = d
                    best = { x = hx, y = hy }
                end
            end
        end
    end

    return best
end


-- surveillance des avions bloqués sur porte-avions
-- pourquoi : éviter blocages deck crew ou taxi bug



CarrierDeckMonitor = {}

CarrierDeckMonitor.watch = {}

CarrierDeckMonitor.minRelSpeed = 0.5
CarrierDeckMonitor.slowSpeed = 0.3
CarrierDeckMonitor.maxIdleTime = 240
CarrierDeckMonitor.maxSlowTime = 240
CarrierDeckMonitor.checkInterval = 5

function getCarrierUnderUnit(unit)

    local p = unit:getPoint()

    for _,cv in ipairs(DCE_carriers) do

        local carrier = Unit.getByName(cv.name)

        if carrier and carrier:isExist() then

            local cp = carrier:getPoint()

            local dx = p.x - cp.x
            local dz = p.z - cp.z

            local dist = math.sqrt(dx*dx + dz*dz)

            if dist < 150 then
                return carrier
            end

        end

    end

    return nil
end

-- vitesse relative avion / carrier
function CarrierDeckMonitor.getRelativeSpeed(unit, carrier)

    local v1 = unit:getVelocity()
    local v2 = carrier:getVelocity()

    local dx = v1.x - v2.x
    local dy = v1.y - v2.y
    local dz = v1.z - v2.z

	local result = math.sqrt(dx*dx + dy*dy + dz*dz)

	env.info("DCE_CarrierDeckMonitor.getRelativeSpeed() "..unit:getName().." carrier="..carrier:getName().." relSpeed="..string.format("%.2f", result))

    return result

end


-- vérification
function CarrierDeckMonitor.check()

    for name,data in pairs(CarrierDeckMonitor.watch) do

        if data.unit:isExist() and data.carrier:isExist() then

            local relSpeed = CarrierDeckMonitor.getRelativeSpeed(data.unit, data.carrier)

			-- détection début roulage
			if not data.taxiStarted then

				if relSpeed > CarrierDeckMonitor.minRelSpeed then
					data.taxiStarted = true
					env.info("CarrierDeckMonitor taxi started "..name)
				end

				-- tant que l'avion ne roule pas, on ne surveille rien
				-- on passe simplement à l'unité suivante
			else

				env.info("DCE_CarrierDeckMonitor.check() A "..name.." relSpeed="..string.format("%.2f", relSpeed).." idle="..data.idle.." slow="..data.slow)

				if relSpeed < CarrierDeckMonitor.minRelSpeed then
					data.idle = data.idle + CarrierDeckMonitor.checkInterval
				else
					data.idle = 0
				end


				if relSpeed < CarrierDeckMonitor.slowSpeed then
					data.slow = data.slow + CarrierDeckMonitor.checkInterval
				else
					data.slow = 0
				end

				env.info("DCE_CarrierDeckMonitor.check() B "..name.." relSpeed="..string.format("%.2f", relSpeed).." idle="..data.idle.." slow="..data.slow)
				
				if data.idle > CarrierDeckMonitor.maxIdleTime or data.slow > CarrierDeckMonitor.maxSlowTime then
					env.info("DCE_CarrierDeckMonitor.check() C "..name.." relSpeed="..string.format("%.2f", relSpeed).." idle="..data.idle.." slow="..data.slow.." => BLOCKED")
					
					local unit = data.unit

					if unit and unit:isExist() then

						local uName = unit:getName()

						trigger.action.outText(
							"Carrier ops: aircraft "..uName.." removed (deck blockage)",
							10
						)

						env.info("CarrierDeckMonitor removed blocked aircraft "..uName)

						unit:destroy()

					end

					-- CarrierDeckMonitor.watch[name] = nil
					CarrierDeckMonitor.watch[data.unit:getName()] = nil

				end
			end

        else
            -- CarrierDeckMonitor.watch[name] = nil
			CarrierDeckMonitor.watch[data.unit:getName()] = nil
        end

    end


    timer.scheduleFunction(
        CarrierDeckMonitor.check,
        nil,
        timer.getTime() + CarrierDeckMonitor.checkInterval
    )

end



CarrierDeckMonitor.handler = {}

function CarrierDeckMonitor.handler:onEvent(event)

    if not event.initiator then return end

    local unit = event.initiator

	-- moteur démarré
	if event.id == world.event.S_EVENT_ENGINE_STARTUP then

		if not unit:getDesc() then return end

   		 if unit:getDesc().category ~= Unit.Category.AIRPLANE then return end

		local carrier = getCarrierUnderUnit(unit)

		if carrier then

			CarrierDeckMonitor.watch[unit:getName()] = {
				unit = unit,
				carrier = carrier,
				idle = 0,
				slow = 0,
				taxiStarted = false
			}

			env.info("CarrierDeckMonitor: watching "..unit:getName())

		end

	end


    -- décollage
    if event.id == world.event.S_EVENT_TAKEOFF then

        CarrierDeckMonitor.watch[unit:getName()] = nil

    end

end


world.addEventHandler(CarrierDeckMonitor.handler)

CarrierDeckMonitor.check()


local function getGroupReferencePoint(gp)
	local units = gp:getUnits()
	if not units then return nil end

	local sx, sy, count = 0, 0, 0

	for _, u in ipairs(units) do
		if u and u:isActive() and u:inAir() then
			local p = u:getPoint()
			sx = sx + p.x
			sy = sy + p.z
			count = count + 1
		end
	end

	if count == 0 then return nil end
	return { x = sx / count, y = sy / count }
end


-- interdit aux CAP et Intercepteur d'entrer dans une zone SAM connu
local function avoidArea()

	local t0
	if campL.debug then
    	t0 = os.clock()
	end
	
	local debug_avoidArea = false

    if not campL.groundthreats then
		if not AnnonceOneOunce["avoidArea"] then
			env.info("ACRF10_avoidArea DCE_ERROR RETURN no camp.groundthreats")
			AnnonceOneOunce["avoidArea"] = true
		end
        return
	end

	local current_time = timer.getTime()

	for _, sideNum in ipairs({coalition.side.BLUE, coalition.side.RED}) do

		local groups = coalition.getGroups(sideNum, Group.Category.AIRPLANE)

		for _, gp in pairs(groups) do
			local gpName = Group.getName(gp)
			local gpGid = Group.getID(gp)
			local nowTime = timer.getTime()

			local passTimer = true
			if (flightPlanTimer[gpGid] and nowTime < flightPlanTimer[gpGid] + 30) then
				passTimer = false
				-- env.info("ACRF10_avoidArea A "..tostring(gpName).." "..tostring(passTimer))
			end

			if (string.find(gpName,"CAP") or string.find(gpName,"Intercept")) and passTimer then
				-- local wingman = gp:getUnits()
				-- for wingmanN, unitObj in ipairs(wingman) do
				-- 	if unitObj and unitObj:isActive() and unitObj:inAir() then

				-- 		local ctr
				-- 		if wingmanN == 1 then												--for leader
				-- 			ctr = gp:getController()							--get controller of group
				-- 		else														--for wingmen
				-- 			ctr = wingman[wingmanN]:getController()						--get controller of individual aircraft in flight
				-- 			ctr:setOption(AI.Option.Air.id.REACTION_ON_THREAT, 2) 	--set to evade fire again, as controller for individual unit does not take over options from parent group
				-- 		end

				-- 		local eni_side_name = DCS_ENI_Side[CoalitionIdToName[sideNum]]

				-- 		for threatN, threat in pairs(campL.groundthreats[eni_side_name]) do
				-- 			if threat and threat.class and threat.class == "SAM"  then

				-- 				local currentPointVec3 = unitObj:getPoint()
				-- 				local currentPointXY = {
				-- 					x = currentPointVec3.x,
				-- 					y = currentPointVec3.z,
				-- 					z = currentPointVec3.y,
				-- 						}
						
				-- 				local distance = math.sqrt(math.pow(threat.x - currentPointXY.x, 2) + math.pow(threat.y - currentPointXY.y, 2))

				-- 				-- if debug_avoidArea or (distance and distance <= threat.range) then
				-- 				if debug_avoidArea or (distance and distance <= ((2 / 3) * threat.range)) then

				local groupPoint = getGroupReferencePoint(gp)
				if groupPoint then

                    
					local currentPointXY = {
						x = groupPoint.x,
						y = groupPoint.y,
						z = 0,
							}
					
					local eni_side_name = DCS_ENI_Side[CoalitionIdToName[sideNum]]
                    local threatHit = nil
					-- local threat = nil

					for _, threatData in pairs(campL.groundthreats[eni_side_name]) do
						
						if threatData and threatData.class == "SAM" then
							local dx = threatData.x - groupPoint.x
							local dy = threatData.y - groupPoint.y
							local dist = math.sqrt(dx * dx + dy * dy)

							if dist <= ((2 / 3) * threatData.range) then
								threatHit = threatData
								-- threat = threatData
								break
							end
						end
					end

					if threatHit then
						--ajoute ici les variables vraiment utile
						-- local unitName = unitObj:getName()
						-- local callSign = unitObj:getCallsign()
						-- local description = unitObj:getDesc()
						local speedMax = 300
						local speedCruise = 300
						local altiCruise = 7600
                        local ctr = gp:getController() --get controller of group
						
						-- if description then
						-- 	if description.speedMax then
						-- 		speedMax = description.speedMax
						-- 	end
						-- 	if description.speedMax0 then
						-- 		speedCruise = description.speedMax0 / 2
						-- 	end
						-- 	if description.Hmax then
						-- 		altiCruise = description.Hmax / 3
						-- 	end
						-- end
						
						env.info( "ACRF10_avoidArea I4_______  ")

						local foundGroup = false
						local breaktab = false
						-- local cap_group = {
						-- 	name = "",
						-- 	from = 0,
						-- 	to = 0,
						-- 	task = {},
						-- 	base = {
						-- 		x = 0,
						-- 		y = 0 ,
						-- 	},
						-- 	orbitCAP = {
						-- 		x = 0,
						-- 		y = 0 ,
						-- 		altitude = 0,
						-- 		speed = 0,
						-- 	},
						-- 	sation1 = {},
						-- 	sation2 = {},
						-- }
						
						
						local cap_group = DCE_groupRouteCache[gpGid]
                        if not cap_group then
                            env.info("DCE_Bug avoidArea: no cache for " .. gpName)
                            break
                        end
						

                        if cap_group.to ~= 0 then
							local switchtask = {
									id = "SwitchWaypoint",
										params = {
											goToWaypointIndex = cap_group.to,
											fromWaypointIndex = cap_group.from
									}
								}

							ctr:resetTask()
							ctr:setCommand(switchtask)
						end

						local pointOfCoverage = chooseBestHotspot(currentPointXY, CoalitionIdToName[sideNum])
						local altCircle = altiCruise + (math.random(1,10) * 10)
						local timeCircle = current_time

						if cap_group.orbitCAP.altitude ~= 0 then
							altiCruise = cap_group.orbitCAP.altitude
						elseif altiCruise < currentPointXY.z then
							altiCruise = currentPointXY.z
						end

						if cap_group.orbitCAP.speed ~= 0 then
							speedCruise = cap_group.orbitCAP.speed
						end

                        if cap_group.orbitCAP.altitude ~= 0 then
                            altCircle = cap_group.orbitCAP.altitude
                            timeCircle = timeCircle + 150
                        else
                            --temps d orbit pour intercepteur
                            timeCircle = timeCircle + 900
                        end
						
						local threat = threatHit

						local flightPlan

						if pointOfCoverage then

							-- env.info( "ACRF10_avoidArea K1_______ currentPointXY.y: "..tostring(currentPointXY.y).." threat.y "..tostring(threat.y))

							local oppositePoint_x, oppositePoint_y = getOppositePointOnCircle(currentPointXY, threat)

							flightPlan = {
								id = 'Mission',
								params = {
									route = {
										points = {
											{
												x = currentPointXY.x,
												y = currentPointXY.y,
												speed = speedMax,
												speed_locked = true,
												ETA_locked = false,
												alt = altiCruise,
												action = "Turning Point",
												type = "Turning Point",
												name = "Found pointOfCoverage"
											},
											{
												x = oppositePoint_x,
												y = oppositePoint_y,
												speed = speedCruise,
												alt = altiCruise,
												speed_locked = true,
												ETA_locked = false,
												action = "Turning Point",
												type = "Turning Point"
											},
											--point à mi chemin entre le point 2 et 4
											{
												x = pointOfCoverage.x ,
												y = pointOfCoverage.y ,
												speed = speedCruise,
												alt = altiCruise,
												speed_locked = true,
												ETA_locked = false,
												action = "Turning Point",
												type = "Turning Point",
												['task'] = {
													['id'] = 'ComboTask',
													['params'] = {
														['tasks'] = {
															[1] =
															{
																["enabled"] = true,
																["name"] = "Interdiction combat AA",
																["id"] = "WrappedAction",
																["auto"] = false,
																["number"] = 1,
																["params"] =
																{
																	["action"] =
																	{
																		["id"] = "Option",
																		["params"] =
																		{
																			["name"] = 14,
																			["value"] = false,
																		}, -- end of ["params"]
																	}, -- end of ["action"]
																}, -- end of ["params"]
															}, -- end of [2]
															[2] =
															{
																["number"] = 2,
																["auto"] = false,
																["id"] = "WrappedAction",
																["name"] = "regleEngagement: feu a volonté",
																["enabled"] = true,
																["params"] =
																{
																	["action"] =
																	{
																		["id"] = "Option",
																		["params"] =
																		{
																			["value"] = 0,
																			["name"] = 0,
																		}, -- end of ["params"]
																	}, -- end of ["action"]
																}, -- end of ["params"]
															}, -- end of [1]
															[3] =
															{
																["enabled"] = true,
																["auto"] = false,
																["id"] = "WrappedAction",
																["name"] = "interdire la pc",
																["number"] = 3,
																["params"] =
																{
																	["action"] =
																	{
																		["id"] = "Option",
																		["params"] =
																		{
																			["value"] = false,
																			["name"] = 16,
																		}, -- end of ["params"]
																	}, -- end of ["action"]
																}, -- end of ["params"]
															}, -- end of [2]
															[4] = {
																['enabled'] = true,
																['auto'] = false,
																['id'] = 'ControlledTask',
																['number'] = 4,
																['params'] = {
																	['task'] = {
																		['id'] = 'EngageTargetsInZone',
																		['params'] = {
																			['targetTypes'] = {
																				[1] = 'Air',
																				[2] = 'Cruise missiles',
																			},
																			['value'] = 'Air;Cruise missiles;',
																			['priority'] = 0,
																			x = pointOfCoverage.x ,
																			y = pointOfCoverage.y ,
																			['zoneRadius'] = 50000,
																		},
																	},
																},
															},
															[5] = {
																['enabled'] = true,
																['auto'] = false,
																['id'] = 'ControlledTask',
																['number'] = 5,
																['params'] = {
																	['task'] = {
																		['id'] = 'Orbit',
																		['params'] = {
																			['altitude'] = altCircle,
																			['pattern'] = 'Race-Track',
																			['speed'] = speedCruise,
																		},
																	},
																	['stopCondition'] = {
																		['time'] = timeCircle,
																	},

																},
															},


														},
													},
												},

											},

											{
												x = cap_group.base.x,
												y = cap_group.base.y,
												speed = speedCruise,
												action = "Landing",
												type = "Land"
											}
										}
									}
								}
							}

							-- env.info( "ACRF10_avoidArea K2_______ #CAP_group.sation1: "..tostring(#CAP_group.sation1))
							if cap_group.sation1 ~= nil and cap_group.sation2 ~= nil and cap_group.orbitCAP.altitude ~= 0 then

								local numPoints = #flightPlan.params.route.points
								local indexForStation1 = numPoints
								local indexForStation2 = numPoints +1 -- Station2 viendra après Station1

								-- Insérer station1 et station2 à des indices fixes
								table.insert(flightPlan.params.route.points, indexForStation1, cap_group.sation1)
								table.insert(flightPlan.params.route.points, indexForStation2, cap_group.sation2)

							end

						else --if NOT pointOfCoverage then

							-- local position = unitObj:getPosition()
							
							env.info( "ACRF10_avoidArea L_______ currentPointXY.y: "..tostring(currentPointXY.y).." threat.y "..tostring(threat.y))

							local oppositePoint_x, oppositePoint_y = getOppositePointOnCircle(currentPointXY, threat)

							flightPlan = {
								id = 'Mission',
								params = {
									route = {
										points = {
											{
												x = currentPointXY.x,
												y = currentPointXY.y,
												speed = speedMax,
												speed_locked = true,
												alt = altiCruise,
												ETA_locked = false,
												action = "Turning Point",
												type = "Turning Point",
												name = "NOFound pointOfCoverage"
											},
											{
												x = oppositePoint_x,
												y = oppositePoint_y,
												speed = speedCruise,
												alt = altiCruise,
												speed_locked = true,
												ETA_locked = false,
												action = "Turning Point",
												type = "Turning Point"
											},
											--point à mi chemin entre le point 2 et 4
											{
												x = (oppositePoint_x + cap_group.base.x ) / 2,
												y = (oppositePoint_y + cap_group.base.y ) / 2,
												speed = speedCruise,
												alt = altiCruise,
												speed_locked = true,
												ETA_locked = false,
												action = "Turning Point",
												type = "Turning Point",
												-- cntrl:setOption(AI.Option.Air.id.PROHIBIT_AA, false)
											},
											{
												x = cap_group.base.x,
												y = cap_group.base.y,
												speed = speedCruise,
												action = "Landing",
												type = "Land"
											}
										}
									}
								}
							}

						end

                        if not foundGroup then
							-- env.info( "ACRF10_avoidArea Z        NO foundGroup "..tostring(unitName).." "..callSign )
							env.info( "DCE_Bug ACRF10_avoidArea Z        NO foundGroup ")
						end

						if flightPlan then
							ctr:resetTask()
							-- ctr:setOption(AI.Option.Air.id.REACTION_ON_THREAT, AI.Option.Air.val.EVADE_FIRE)
							ctr:setOption(AI.Option.Air.id.REACTION_ON_THREAT, 2)
							ctr:setOption(AI.Option.Air.id.PROHIBIT_AA, true) -- Désactiver l'engagement A/A
							ctr:setTask(flightPlan)
							flightPlanTimer[gpGid] = nowTime
							-- _affiche(flightPlanTimer, "ACRF10_avoidArea Z2 flightPlanTimer")
						end

                        if campL.debug then
							
							local timeSearchEngage = timer.getTime() + 5
							local logStr = "flightPlan = " .. TableSerialization(flightPlan, 0)
							local flightNameClean = gpName:gsub('[%p%c%s]', '_')
							local logFile = io.open(PathDCE.."Debug\\"..flightNameClean.."_"..timeSearchEngage.."_avoidArea.lua", "w")

                            env.info("DCE_avoidArea: NewFlightPlan to " .. tostring(flightNameClean))
							
							if logFile then
								logFile:write(logStr)
								logFile:close()
							else
								env.info("DCE_ERROR DCE_avoidArea: Failed to open log file for writing.")
							end

							-- env.info("DCE_avoidArea ZZZ " .. tostring(unitName))
						end

						break -- il est entre dans une zone interdite, on l evacue et on s arrete là
					end
				end
			end
		end
		-- 		end
		-- 	end
		-- end
	end


	local groups = coalition.getGroups(coalition.side.BLUE, Group.Category.AIRPLANE)

	if campL.debug then
		local dt = os.clock() - t0
		Perf_A = Perf_A + dt
		Perf_A_N = Perf_A_N + 1
	end

	return timer.getTime() + 5
end

-- modification M32	E-2C automatic retreat 
local function airRetreat()

	local t0
	if campL.debug then
		t0 = os.clock()
	end

	local current_time = timer.getTime()

	local groups = coalition.getGroups(coalition.side.BLUE, Group.Category.AIRPLANE)

	for i, gp in pairs(groups) do

		local gpName = Group.getName(gp)

		if string.find(gpName,"AWACS") then
			local units = gp:getUnits()
			local unit = units[1]

			-- if _unit and _unit:getTypeName() == "E-2C" and _unit:isActive() and _unit:inAir() then
            if unit and unit:isActive() and unit:inAir() then
                local isAwacsCarrier = nil
				if unit:getTypeName() == "E-2C" then
					isAwacsCarrier = true
				end
				local awacsVec3 = unit:getPoint()
				local gpGid = Group.getID(gp)
				-- local nameAwacs = unit:getName()
				if not RetreatTimeGp then RetreatTimeGp = {} end
				if not RetreatTimeGp[gpGid] then RetreatTimeGp[gpGid] = {} end
				if not RetreatTimeGp[gpGid].rTime then RetreatTimeGp[gpGid].rTime = 0  end

				if unit and current_time > RetreatTimeGp[gpGid].rTime then							--if _unit exists
					local ctr = unit:getGroup():getController()										--get _unit controller
					local ctrGroup = gp:getController() -- Récupère le contrôleur du GROUPE (sinon, l injectrion de task sur l unit leader fait planter DCS)
					local targets = ctr:getDetectedTargets()											--get detected targets of this EWR
					for t = 1, #targets do																--iterate through detected targets
						if targets[t].object and current_time > RetreatTimeGp[gpGid].rTime then
							local objCat = Object.getCategory(targets[t].object)								--get object category
							if objCat == Object.Category.UNIT then												--object is a _unit
								local desc = targets[t].object:getDesc()								--get descriptor descriptor
								local descAwacs = unit:getDesc()

								if desc.category == Unit.Category.AIRPLANE and (desc.attributes["Battle airplanes"] or desc.attributes.Fighters)  then												--descriptor category is airplane 
									--To know what attributes the object type has, look for the unit type script in sub-directories planes/, helicopter/s, vehicles, navy/ of ./Scripts/Database/ directory.
									--and desc.attributs ~= "Battleplane" and desc.attributs ~= "Fighter"

									local targetVec3 = targets[t].object:getPoint()					--get target point					
									local distance = math.sqrt(math.pow(awacsVec3.x - targetVec3.x, 2) + math.pow(awacsVec3.z - targetVec3.z, 2))

									if distance < 100000 then
									-- if distance < 150000 then 

										local callsign = unit:getCallsign()
										env.info("ACRF10 DCE AWACS |03b|: Order to Retire "..distance)
										env.info("ACRF10 DCE AWACS |03c|: Order to Retire "..callsign.." Retreat to the aircraft carrier")
										trigger.action.outText(callsign.." Retreat to the aircraft carrier",10)

										--active le waypoint du PA										
										RetreatTimeGp[gpGid].rTime = current_time + 300

										local carrierDistance = 99999999
										local retreat_x = 0
                                        local retreat_y = 0
										if isAwacsCarrier and not campL.Aircraft_Carriers then
											for coalition_name,coal in pairs(env.mission.coalition) do
												if coalition_name == "blue" then
													for country_n,country in ipairs(coal.country) do
														if country.ship then
															for group_n,group in ipairs(country.ship.group) do
																local groupCarrier = Group.getByName(group.name)													--get carrier group
																if groupCarrier then																				--group exists
																	local carrier = groupCarrier:getUnit(1)															--get group leader (assumed to be the carrier)								
																	local Desc = carrier:getDesc()
																	if Desc.attributes.AircraftCarrier or Desc.attributes["Aircraft Carriers"] then
																		local carrierVec3 = carrier:getPoint()
																		local carrierTestDist = math.sqrt(math.pow(carrierVec3.x - awacsVec3.x, 2) + math.pow(carrierVec3.z - awacsVec3.z, 2))
																		if carrierTestDist < carrierDistance then
																			retreat_x = carrierVec3.x
																			retreat_y = carrierVec3.z
																			carrierDistance =  carrierTestDist
																		end
																	end
																end
															end
														end
													end
												end
											end
                                        elseif campL.Aircraft_Carriers then
											for sideCarrier, carriers in ipairs(campL.Aircraft_Carriers) do
												for group_n, carrier in ipairs(carriers) do
													local carrierGroup = Group.getByName(carrier.name) --get carrier group
													if carrierGroup then --group exists
														local carrierUnit = carrierGroup:getUnit(1) --get group leader (assumed to be the carrier)								
														
														local carrierVec3 = carrier:getPoint()
														local carrierTestDist = math.sqrt(math.pow( carrierVec3.x - awacsVec3.x, 2) + math.pow(carrierVec3.z - awacsVec3.z, 2))
														if carrierTestDist < carrierDistance then
															retreat_x = carrierVec3.x
															retreat_y = carrierVec3.z
															carrierDistance = carrierTestDist
															
														end
													end
												end
											end
										end


										-- for _coalition, coalition in pairs(env.mission.coalition) do
										-- 	if _coalition  == "blue" then
										-- 		for countryN, _country in pairs(coalition.country) do
										-- 			if _country.plane then
										-- 				for groupN, _group in pairs(_country.plane.group) do
										-- 					if _group.groupId == gpGid then

										local retreatRoute = MissGroupByName[gpName].route.points
										
										-- -- si aucun CVN n'a été trouvé, on prend comme position de retraite l'ID "land"
										-- if retreat_x == 0 then
										-- 	for key, value in ipairs(_group.route.points) do				-- recherche de la position safe du PA et une alti						
										-- 		if value.type == 'Land' then
										-- 			retreat_x = value.x
										-- 			retreat_y = value.y
										-- 		end
										-- 	end
										-- end
										-- si aucun CVN n'a été trouvé, on prend comme position de retraite l'ID "land"
										if retreat_x == 0 or not isAwacsCarrier then
											local lastWpt = retreatRoute[#retreatRoute]
											retreat_x = lastWpt.x
											retreat_y = lastWpt.y
										end

										-- local retreatRoute = {}

										-- retreatRoute = Deepcopy(_group.route.points)

										-- ajoute comme premier wpt leur position initial pour garder la fonction AWACS
										local firstWPT = {
											['alt'] = awacsVec3.y,
											['type'] = 'Turning Point',
											['action'] = 'Turning Point',
											['alt_type'] = 'BARO',
											['speed_locked'] = true,
											['y'] = awacsVec3.z,
											['x'] = awacsVec3.x,
											['formation_template'] = '',
											['speed'] = descAwacs.speedMax,
											['ETA_locked'] = true,
											['task'] = {
												['id'] = 'ComboTask',
												['params'] = {
													['tasks'] = {
														[1] = {
															['enabled'] = true,
															['auto'] = false,
															['id'] = 'ControlledTask',
															['number'] = 1,
															['params'] = {
																['task'] = {
																	['id'] = 'AWACS',
																	['params'] = {
																	},
																},
															},
														},
														[2] = {
															['enabled'] = true,
															['auto'] = false,
															['id'] = 'WrappedAction',
															['number'] = 2,
															['params'] = {
																['action'] = {
																	['id'] = 'Option',
																	['params'] = {
																		['variantIndex'] = 1,
																		['value'] = 458753,
																		['name'] = 5,
																		['formationIndex'] = 7,
																	},
																},
															},
														},
														[3] = {
															['enabled'] = true,
															['auto'] = true,
															['id'] = 'WrappedAction',
															['number'] = 3,
															['params'] = {
																['action'] = {
																	['id'] = 'EPLRS',
																	['params'] = {
																		['value'] = true,
																		['groupId'] = 1,
																	},
																},
															},
														},
														[4] = {
															['enabled'] = true,
															['auto'] = false,
															['id'] = 'WrappedAction',
															['number'] = 4,
															['params'] = {
																['action'] = {
																	['id'] = 'Option',
																	['params'] = {
																		['value'] = 2,
																		['name'] = 1,
																	},
																},
															},
														},
													},
												},
											},
											['ETA'] = 0,
										}


										table.insert(retreatRoute, 1, firstWPT)

										--modifie les coordonées du premier wpt initial
										retreatRoute[2].x = retreat_x
										retreatRoute[2].y = retreat_y
										retreatRoute[2].alt = awacsVec3.y
										retreatRoute[2].speed_locked = true
										retreatRoute[2].ETA_locked = false
										retreatRoute[2].speed = descAwacs.speedMax
										retreatRoute[2].ETA = RetreatTimeGp[gpGid].rTime

										local idTasks = #retreatRoute[2].task.params.tasks
										local orbitRetreat = {

											['enabled'] = true,
											['auto'] = false,
											['id'] = 'ControlledTask',
											['number'] = idTasks+2,
											['params'] = {
												['task'] = {
													['id'] = 'Orbit',
													['params'] = {
														['altitude'] = 7315.2,
														['pattern'] = 'Circle',
														['speed'] = 138.889,
													},
												},
												['stopCondition'] = {
													['time'] = RetreatTimeGp[gpGid].rTime,
												},
											},

										}

										retreatRoute[2].task.params.tasks[idTasks +1] =  orbitRetreat

										--ajoute la task awacs au premier wpt pour garder la fonction awacs operationnel
										local TaskAwacs = {

												['enabled'] = true,
												['auto'] = false,
												['id'] = 'ControlledTask',
												['number'] = 1,
												['params'] = {
													['task'] = {
														['id'] = 'AWACS',
														['params'] = {
														},
													},
												},

											}
										table.insert(retreatRoute[2].task.params.tasks, 1, TaskAwacs)

										--renumerote les number des task																	
										for j=1, #retreatRoute[1].task.params.tasks do
											retreatRoute[1].task.params.tasks[j].number = i
										end

										local mission = {														--define mission for retreat AWACS
												id = 'Mission',
												params = {
													route = {
														points = retreatRoute
													},
												}
											}


										-- local logStr = "mission = " .. TableSerialization(mission, 0)
										-- local logFile = io.open(PathDCE.."_"..nameAwacs.."_".. "Mission_AWACSretreatRoute.lua", "w")
										-- logFile:write(logStr)
										-- logFile:close()	

										Controller.setTask(ctrGroup, mission)										--activate task with mission for retreat AWACS
										-- 					end
										-- 				end
										-- 			end
										-- 		end
										-- 	end
										-- end
									end
								end
							end
						end
					end
				end
			end
		end
	end

	if campL.debug then
		local dt = os.clock() - t0
		Perf_C = Perf_C + dt
		Perf_C_N = Perf_C_N + 1
	end
	
	return timer.getTime() + 31
end


local function EWR_speaking(arg)
	local i = 6
	if arg[3] then
		i = arg[3]
	end
	local speakingTime = 30

	speakingTime = speakingTime - i*3

	trigger.action.outTextForUnit(arg[1], arg[2], speakingTime, false)

end


-- Fonction pour envoyer un texte transformé en audio via TTS
-- local function sendTTSMessage(freq, modulation, text)
-- local function sendTTSMessage(arg)

-- 	local freq, modulation, text = arg[1], arg[2],arg[3]

-- 	local duration = SRSAudio.transmitTTS( -- Utilise la fonction TTS de SRS
-- 		freq,        -- Fréquence en Hz
-- 		modulation,  -- "AM" ou "FM"
-- 		text         -- Texte à convertir en audio
-- 	)
-- 	if duration then
-- 		trigger.action.outText("DCE_sendTTSMessage : Message TTS diffusé sur " .. freq / 1000000 .. " MHz (durée: " .. duration .. " s)", 10)
-- 	else
-- 		trigger.action.outText("DCE_sendTTSMessage Erreur lors de la diffusion TTS. freq: "..tostring(freq), 10)
-- 		trigger.action.outText("DCE_sendTTSMessage Erreur lors de la diffusion TTS. modulation: "..tostring(modulation), 10)
-- 		trigger.action.outText("DCE_sendTTSMessage Erreur lors de la diffusion TTS. text: "..tostring(text), 10)
-- 	end
-- end




local function EWR_magic()

	local t0
	if campL.debug then
		t0 = os.clock()
	end

	local target_tracks = {
		["blue"] = {},
		["red"] = {}
	}

	--EWR target detection
	ErrorMsg = "DCE_EWR_magic target detection."																--Error message in case follow on code fails
	for ewr_side, ewr_table in pairs(GCI.EWR) do													--iterate through sides in EWR table
		for ewr_name, bool in pairs(ewr_table) do													--iterate through EWR radars	
			ErrorMsg = "DCE_EWR_magic target detection: "	.. ewr_name											--Error message in case follow on code fails
			local unit = Unit.getByName(ewr_name)													--get EWR unit
			if unit then																			--if unit exists
				local ctr = unit:getGroup():getController()											--get unit controller
				local targets = ctr:getDetectedTargets()											--get detected targets of this EWR

				for t = 1, #targets do																--iterate through detected targets
					if targets[t].object then
						local target = targets[t].object
						local objCat

						if target then
							objCat = Object.getCategory(target)
						end


						if objCat and objCat == Object.Category.UNIT then

							-- local unitCat = Unit.getCategory(target) -- toujours cassé

							local desc = target:getDesc()
							local unitCat = desc.category

							if unitCat and (unitCat == Unit.Category.AIRPLANE or unitCat == Unit.Category.HELICOPTER) then

								if target:isActive() and target:inAir() then

									local target_unitId = target:getID()
									local targetVec3 = target:getPoint()
									local target_pos = target:getPosition() -- Obtenir la position et l'orientation de la cible

									-- Heading (cap)
									local heading = math.atan2(target_pos.x.z, target_pos.x.x)
									heading = math.deg(heading) -- Conversion en degrés
									if heading < 0 then
										heading = heading + 360 -- Ajuster pour avoir un angle positif (0-360°)
									end
									-- Arrondi au multiple de 5 le plus proche
									heading = math.floor((heading + 2.5) / 5) * 5

									local targetCoalitionId = target:getCoalition() -- Récupère la coalition de la cible

									local target_typeName = Object.getTypeName(target)

									target_tracks[ewr_side][target_unitId] = {
										pointVec3 = targetVec3,
										category = unitCat,
										qte = 1,
										heading = heading,
										coalition = targetCoalitionId,
										typeName = target_typeName,
										position = target_pos,
									}
								end

							end
						end
					end
				end
			end
		end
	end


	--##############################################################
	--regroupement des tracks, pour eviter d'en avoir de trop
	--################################################################
	local groupedTracks = {} -- Table pour stocker les groupes regroupés
	local groupingDistance = 4000 -- Distance maximale en mètres
	local altitudeTolerance = 2000 -- Tolérance d'altitude en mètres
	local orientationTolerance = 180 -- Tolérance de cap en degrés

	-- Fonction pour calculer la distance entre deux points 3D
	local function getDistance3D(point1, point2)
		local dx = point1.x - point2.x
		local dy = point1.y - point2.y
		local dz = point1.z - point2.z
		return math.sqrt(dx^2 + dy^2 + dz^2)
	end

	-- Parcourir chaque coalition dans target_tracks
	for coalitionName, coalitionTracks in pairs(target_tracks) do
		groupedTracks[coalitionName] = {} -- Initialiser la table pour cette coalition

		-- Itérer sur les avions de la coalition
		for trackId, trackData in pairs(coalitionTracks) do
			local foundGroup = false

			-- Vérifier si ce track correspond à un groupe existant
			for _, group in ipairs(groupedTracks[coalitionName]) do
				if getDistance3D(group.pointVec3, trackData.pointVec3) <= groupingDistance
					and math.abs(group.pointVec3.y - trackData.pointVec3.y) <= altitudeTolerance
					and math.abs((group.heading - trackData.heading) % 360) <= orientationTolerance
					and group.typeName == trackData.typeName then

					-- Incrémenter le nombre d'avions dans le groupe
					group.qte = group.qte + 1
					foundGroup = true
					break
				end
			end

			-- Si aucun groupe trouvé, créer un nouveau groupe avec les données de cet avion
			if not foundGroup then
				table.insert(groupedTracks[coalitionName], {
					category = trackData.category,
					coalition = trackData.coalition,
					heading = trackData.heading,
					pointVec3 = trackData.pointVec3,
					qte = 1, -- Initialement 1 avion
					typeName = trackData.typeName,
					position = trackData.position,
				})
			end
		end
	end


	local function roundTo2NmUp(number)
		-- Diviser le nombre par 2 pour travailler avec des pas de 2 NM
		local scaled = number / 2
		-- Arrondir à l'entier supérieur le plus proche
		local rounded = math.ceil(scaled)
		-- Revenir à l'échelle d'origine en multipliant par 2
		return rounded * 2
	end


	local function calculateAspect(arg_myPosVec3, arg_Enemy)
		local aspect = "UNKNOWN"

		local enemyPos = arg_Enemy.position
		local forward = enemyPos.x -- Forward vector (direction de l'ennemi)
		local targetPosVec3 = arg_Enemy.pointVec3 -- Position de l'ennemi

		-- Calcul du vecteur relatif de l'ennemi à moi
		local dx = arg_myPosVec3.x - targetPosVec3.x
		local dz = arg_myPosVec3.z - targetPosVec3.z
		local relative = {x = dx, z = dz}

		-- Produit scalaire pour l'angle
		local dot_product = forward.x * relative.x + forward.z * relative.z
		local magnitude_forward = math.sqrt(forward.x^2 + forward.z^2)
		local magnitude_relative = math.sqrt(relative.x^2 + relative.z^2)
		local angle = math.deg(math.acos(dot_product / (magnitude_forward * magnitude_relative)))

		-- Produit vectoriel pour le signe
		local cross_product = forward.x * relative.z - forward.z * relative.x
		if cross_product < 0 then
			angle = -angle -- Angle négatif si à gauche
		end

		-- Déterminer l'aspect en fonction des seuils logiques
		if angle > -25 and angle < 25 then
			aspect = "HOT" -- Approche directe
		elseif angle > -70 and angle < 70 then
			aspect = "FLANK" -- Oblique
		elseif angle > -110 and angle < 110 then
			aspect = "BEAM" -- Perpendiculaire
		elseif angle > -180 and angle < 180 then
			aspect = "DRAG" -- S'éloigne obliquement
		else
			aspect = "COLD" -- Fuite directe
		end

		return aspect, angle
	end


	-- Définir les camps et catégories à parcourir
	local coalitions = {coalition.side.BLUE, coalition.side.RED}
	local categories = {Group.Category.AIRPLANE, Group.Category.HELICOPTER}
	local locTimer = timer.getTime()


	for _, sideNum in ipairs(coalitions) do
		for categoryN, category in ipairs(categories) do
			-- Obtenir les groupes pour le camp et la catégorie
			local groups = coalition.getGroups(sideNum, category)

			for gpN, gp in pairs(groups) do
				local wingman = gp:getUnits()
				for winmanN, _unit in ipairs(wingman) do
					if _unit and _unit:isActive() then --and _unit:inAir()
						local playerName =  _unit:getPlayerName()
						local unitName = _unit:getName()

						local trucName
						if playerName and EWR_optionPlayer[playerName] and EWR_optionPlayer[playerName].EWR_on then
							trucName = playerName
						end

						if unitName and EWR_optionPlayer[unitName] and EWR_optionPlayer[unitName].EWR_on then
							trucName = unitName
						end

						if EWR_optionPlayer[trucName] and ( not EWR_optionPlayer[trucName]["lasTime"] or EWR_optionPlayer[trucName]["lasTime"] +15  < locTimer) then

							local t0b
							if campL.debug then
                            	t0b = os.clock()
							end
							
							local player = _unit
							local playerId = Unit.getID(player)
							local playerVec3 = player:getPoint()				--get target point

							local playerCoalitionId = player:getCoalition()
							local sidePlayerName = CoalitionIdToName[playerCoalitionId]
							local sideENI_Name = DCS_ENI_Side[sidePlayerName]

							local targetTracks_km_thisPlayer = {}

							for  _, targets in pairs(groupedTracks) do
								for _, target in pairs(targets) do
									if target and type(target) == "table" and target.pointVec3.x and target.pointVec3.y then

										-- Calcul de la distance
										local dx = target.pointVec3.x - playerVec3.x
										local dz = target.pointVec3.z - playerVec3.z
										local distance = math.sqrt(dx^2 + dz^2)

										if (distance/1000) <= EWR_Magic_DISTANCE_KM then
											
											--attention ici on stocke une table avec la distance
											-- target.distance = distance
                                            -- table.insert(targetTracks_km_thisPlayer, target)
											
											table.insert(targetTracks_km_thisPlayer, {
												target = target,     -- référence globale
												distance = distance -- donnée privée du joueur
                                            })
										
										end
									end
								end
							end

							-- triage de la table en fonction de la distance
							table.sort(targetTracks_km_thisPlayer, function(a,b) return a.distance < b.distance  end)

							local i = 1
							local plotContactDetected = {
								red = {},
								blue = {},
							}
							-- for trackN, target in pairs(targetTracks_km_thisPlayer) do
							for trackN, item in ipairs(targetTracks_km_thisPlayer) do
								local target = item.target -- le vrai track EWR
                                local distance = item.distance -- la distance privée du joueur
								
								-- Conversion des distances
								local distanceKm = math.floor(distance / 1000) -- En kilomètres
								local displayDistance, displayAltitude, displayDistUnit, displayAltUnit

								if campL.unitSystem and campL.unitSystem == "metric" then
									displayDistance = math.ceil(distance / 4000) * 4000 -- En mètres, arrondi à 4 km près
									displayAltitude = math.ceil(target.pointVec3.y / 1000) * 1000 -- Altitude en mètres, arrondi à 1000m
									displayDistUnit = "m"
									displayAltUnit = "m"
								else
									displayDistance = roundTo2NmUp(distance / 1852) -- En miles nautiques, arrondi à 2 Nm près
									displayAltitude = math.floor((target.pointVec3.y * 3.281) / 1000) * 1000 -- Altitude en pieds	
									displayDistUnit = "NM"
									displayAltUnit = "ft"
								end


								-- Calcul du bearing
								local dx = target.pointVec3.x - playerVec3.x
								local dz = target.pointVec3.z - playerVec3.z
								local angleRad = math.atan2(dz, dx) -- Angle en radians
								local bearing = math.deg(angleRad) -- Conversion en degrés
								if bearing < 0 then
									bearing = bearing + 360 -- Ajuster pour un cap de 0 à 360°
								end

								-- Arrondi au multiple de 5 le plus proche
								bearing = math.floor((bearing + 2.5) / 5) * 5

								local aspect = ""
								local sideIFF = "Contact"
								local sideContact = ""
								if target.coalition and target.coalition ~= 0 and target.coalition ~= playerCoalitionId then
									sideIFF = "ENEMY"
									sideContact = sideENI_Name
									aspect = calculateAspect(playerVec3, target)
								else
									sideIFF = "Friend"
									sideContact = sidePlayerName
								end

								local catTarget = "aircraft"
								if target.category and target.category == Unit.Category.HELICOPTER then
									catTarget = "helicopter"
									aspect = ""
								end

								local oldSoluce = false
								if oldSoluce then
									-- Affichage si la distance est dans les limites
									if (distanceKm > 2 ) or (distanceKm <= 2 and sideIFF == "ENEMY" ) then

										-- local freq = camp.EWR_frequency[coalitionIdNumeric[sideNum]][1]
										local speak = target.qte.." "..sideIFF.." "..catTarget.." "..tostring(aspect).." Bearing: "..string.format("%.0f", bearing).."° |  Distance: "..tostring(displayDistance).." "..displayDistUnit.." | Altitude: "..tostring(displayAltitude).." "..displayAltUnit

										timer.scheduleFunction(EWR_speaking, {playerId, speak}, timer.getTime() + (i*3))
										-- timer.scheduleFunction(sendTTSMessage, {freq, "AM", speak}, timer.getTime() + (i*2))

										EWR_optionPlayer[trucName]["lasTime"] = locTimer
										i = i + 1
										if i > 6 then break end
									end
								else
									-- Affichage si la distance est dans les limites
									if (distanceKm > 2) or (distanceKm <= 2 and sideIFF == "ENEMY" ) then
										-- local freq = camp.EWR_frequency[coalitionIdNumeric[sideNum]][1]
										local speak = target.qte.." "..sideIFF.." "..catTarget.." "..tostring(aspect).." Bearing: "..string.format("%.0f", bearing).."° |  Distance: "..tostring(displayDistance).." "..displayDistUnit.." | Altitude: "..tostring(displayAltitude).." "..displayAltUnit

										local annonce = {
											distanceKm = distanceKm,
											speak = speak,
											qte = target.qte,
											target_pointVec3 = target.pointVec3,
											playerPointVec3 = playerVec3,
											bearing = bearing,
										}

										table.insert(plotContactDetected[sideContact], annonce)

									end
								end
							end

							-- Affichage si la distance est dans les limites
							if (plotContactDetected ) then
								local bearingFriend = {}
								for annonceN, annonce in pairs(plotContactDetected[sideENI_Name]) do
									timer.scheduleFunction(EWR_speaking, {playerId, annonce.speak, i}, timer.getTime() + (i*3))
									-- timer.scheduleFunction(sendTTSMessage, {freq, "AM", speak}, timer.getTime() + (i*2))

									EWR_optionPlayer[trucName]["lasTime"] = locTimer
									i = i + 1
									if i >= 4 then break end

									if i == 1 then
										bearingFriend[1] = annonce.bearing
									elseif i == 2 then
										bearingFriend[2] = annonce.bearing
									end

								end

								for j = 1, #bearingFriend do
									env.info("DCE_plotContactDetected_b passe C_A j: "..tostring(j))

									for annonceN, annonce in pairs(plotContactDetected[sidePlayerName]) do
										env.info("DCE_plotContactDetected_b passe C_B annonce: "..tostring(annonce.speak))

										-- Normaliser les angles
										local bearingFriendAngle = NormalizeAngle(bearingFriend[j].bearing)
										local annonceAngle = NormalizeAngle(annonce.bearing)

										-- Calculer la différence absolue en tenant compte du cercle
										local diff = math.abs(annonceAngle - bearingFriendAngle)
										diff = math.min(diff, 360 - diff) -- Prendre en compte l'enroulement

										if diff <= 20 then
											timer.scheduleFunction(EWR_speaking, {playerId, annonce.speak, i}, timer.getTime() + (i * 3))
											-- timer.scheduleFunction(sendTTSMessage, {freq, "AM", speak}, timer.getTime() + (i*2))
										end
									end
								end

							end

							if campL.debug then
								local dtb = os.clock() - t0b
								Perf_Bb = Perf_Bb + dtb
								Perf_B_Nb = Perf_B_Nb + 1
							end


						end
					end
				end
			end
		end
	end

	if campL.debug then
		local dt = os.clock() - t0
		Perf_B = Perf_B + dt
		Perf_B_N = Perf_B_N + 1
	end
	
	return timer.getTime() + 60

end


--////////////////////////////////////////////////////////////////////////////////////////////
--test EWR (fin)


function MonitorPlayerAircraftActivity(arg)

    local arg_inOut = arg[1]
	local arg_playerName = arg[2]
	local arg_aircraftName = arg[3]
	local arg_category = arg[4]
	local groupObject = arg[5]

	env.info("DCE_MonitorPlayerAircraftActivity A "..arg_inOut.." // "..tostring(arg_aircraftName))

	env.info("DCE_MonitorPlayerAircraftActivity B1 "..tostring(groupObject))
	local gid
	if groupObject then
		gid = groupObject:getID()
	end
	env.info("DCE_MonitorPlayerAircraftActivity B2 "..tostring(gid))
	
	if arg_inOut == "in" then
		env.info("DCE_MonitorPlayerAircraftActivity C IN: "..tostring(arg_playerName).." in "..tostring(arg_aircraftName) )
		PlayerInOutAircraft[arg_playerName] = {
			inOut = arg_inOut,
			aircraftName = arg_aircraftName,
			category = arg_category,
			groupObject = groupObject,
			gid = gid,
		}
	elseif arg_inOut == "out" then
		env.info("DCE_MonitorPlayerAircraftActivity D OUT: "..tostring(arg_playerName).." out of "..tostring(arg_aircraftName) )
		if PlayerInOutAircraft[arg_playerName] then
			PlayerInOutAircraft[arg_playerName] = nil
		end
    else
		env.info("DCE_MonitorPlayerAircraftActivity E ERROR: arg_inOut unknown " .. tostring(arg_playerName) .. " arg_inOut: " .. tostring(arg_inOut) .. " aircraft: " .. tostring(arg_aircraftName))
	end

end


local eventsSurvey2 = {
	[world.event.S_EVENT_BIRTH] = true,--
	[world.event.S_EVENT_PLAYER_LEAVE_UNIT] = true,--

	[world.event.S_EVENT_DEAD] = true,--
	[world.event.S_EVENT_LAND] = true,--
	[world.event.S_EVENT_CRASH] = true,--
	[world.event.S_EVENT_PILOT_DEAD] = true,--
	[world.event.S_EVENT_DETAILED_FAILURE] = true,--
	[world.event.S_EVENT_AI_ABORT_MISSION] = true,--
	[world.event.S_EVENT_EMERGENCY_LANDING] = true,--
	[world.event.S_EVENT_KILL] = true,--

}

EventHandler2 = {}
function EventHandler2:onEvent(event)
	if eventsSurvey2[event.id] then
		local idLabel = "inc"
		local current_time = timer.getTime()

		if event and event.id and Info_event and Info_event[tonumber(event.id)] then
			idLabel = tostring(Info_event[tonumber(event.id)])
		end

		if event.id == world.event.S_EVENT_BIRTH and event.initiator then
			local obj_Category = Object.getCategory(event.initiator)

			-- on ignore les statics
			if obj_Category ~= Object.Category.STATIC then
				if event.initiator.getID then
					local unitId = event.initiator:getID()

					if unitId then
						-- init cache
						if not Cache_UnitCategoryByGetID[unitId] then
							Cache_UnitCategoryByGetID[unitId] = {}
						end

						local desc = event.initiator:getDesc()
						if desc and desc.category ~= nil then
							Cache_UnitCategoryByGetID[unitId].category = desc.category
						end
					end
				end

				if event.initiator.getPlayerName and event.initiator.getGroup then
					local playerName = event.initiator:getPlayerName()
					local groupObject = event.initiator:getGroup()

					-- env.info("DCE_EventHandler2 B playerName." .. tostring(playerName))

					if groupObject and groupObject.getID then
						local gpGid = groupObject:getID()
						local flightName = event.initiator:getName()
						local groupName = groupObject:getName()

						if playerName then
							env.info("DCE_EventHandler2 C0. playerName " ..
							tostring(playerName) ..
							" gpGid." .. tostring(gpGid) .. " groupObject." .. tostring(groupObject))

							if gpGid and groupObject then
								env.info("DCE_EventHandler2 C1 playerName S_EVENT_BIRTH. MAKE addFuncs() ")
								addFuncs(gpGid, groupObject, playerName)

								local desc = event.initiator:getDesc()
								env.info("DCE_EventHandler2 C2. desc" .. tostring(desc))
								if desc and desc.category == Unit.Category.HELICOPTER then
									timer.scheduleFunction(MonitorPlayerAircraftActivity,
										{ "in", playerName, flightName, desc.category, groupObject }, current_time + 1)
								end
							end
						else
							if gpGid and groupObject then
								if not SatusGroupAircraft[groupName] then
									SatusGroupAircraft[groupName] = {
										["spawn"] = false,
										["takeoff"] = false,
										["landing"] = false,
										["task"] = "",
										["waypoints"] = {}, -- suivi des waypoints
									}
								end

								local passEscort = false

								-- if string.find(string.lower(groupName), "escort") then
								-- 	passEscort = true


								-- 	--TODO a supprimer une fois les tests finitos
								-- 	if campL.debug then
								-- 		EWR_ON(flightName)
								-- 	end
								-- end

								if groupObject and passEscort then
									-- local route = DCE_GetRoute(flightName, sideName)
									-- local route = DCE_GetRoute(groupName)
									local route = DCE_GetRoute(groupName)

									-- env.info("DCE_Perf Perf_Tot " .. tostring(Perf_Tot))

									if route and #route > 0 then
										SatusGroupAircraft[groupName]["waypoints"] = route
										SatusGroupAircraft[groupName]["task"] = "escort"
									end
								end
							end
						end
					end
				end



				if event.initiator then
					local unit = event.initiator
					if unit and unit.getPlayerName and unit:getPlayerName() then
						local name = unit:getPlayerName()
						local uName = unit:getName()
						env.info("DCE_EventHandler2 D Joueur détecté: " .. name .. " (unité: " .. uName .. ")")
						Players[uName] = name
					end
				end
			end

		elseif event.id == world.event.S_EVENT_PLAYER_LEAVE_UNIT then
			-- Quand un joueur quitte un slot
			if event.initiator and event.initiator.getPlayerName then
				local playerName = event.initiator:getPlayerName()

				if playerName and EWR_optionPlayer[playerName] then
					EWR_optionPlayer[playerName] = nil
				end
				-- requestEWRMenuRebuild(gid, groupObject)
			end

		elseif not event.place then
			if event.subPlace then
				if event.initiator and event.initiator.getPlayerName then
					local playerName = event.initiator:getPlayerName()
					local groupObject = event.initiator:getGroup()

					if groupObject and groupObject.getID then
						local gpGid = groupObject:getID() --1300: attempt to index a nil value
						if gpGid and groupObject and playerName then
							env.info("DCE_EventHandler2 E playerName event.subPlace MAKE addFuncs()")
							addFuncs(gpGid, groupObject, playerName)
						end
					end
				end
			elseif event.id == world.event.S_EVENT_LAND or event.id == world.event.S_EVENT_CRASH or event.id == world.event.S_EVENT_DETAILED_FAILURE or event.id == world.event.S_EVENT_AI_ABORT_MISSION
				or event.id == world.event.S_EVENT_EMERGENCY_LANDING then
				if event.initiator and not event.initiator.getPlayerName then
					local eventVec3 = event.initiator:getPoint()
					local wreckVec3
					if eventVec3 and eventVec3.x then
						wreckVec3 = {
							x = eventVec3.x,
							y = land.getHeight({ x = eventVec3.x, y = eventVec3.z }),
							z = eventVec3.z,
						}
						env.info("DCE_GroundDamagedFlyingMachine F1 wreckVec3 alti " .. tostring(wreckVec3.y))
					end

					if wreckVec3.y <= 100 then
						env.info("DCE_GroundDamagedFlyingMachine G getPlayerName detected ? ")

						local name = event.initiator:getName()
						local life = event.initiator:getLife()
						local init_life = event.initiator:getLife0()
						local lifePourcent = 100
						-- local isPlayer = false
						if init_life then
							lifePourcent = life / init_life * 100
						end

						env.info("DCE_GroundDamagedFlyingMachine H2 init_life " ..
						tostring(init_life) .. " life: " .. tostring(life))
						env.info("DCE_GroundDamagedFlyingMachine H3 event.initiator.id_ " ..
						tostring(event.initiator.id_))



						if lifePourcent < 100 and lifePourcent >= 1 then
							env.info("DCE_GroundDamagedFlyingMachine I detected ? event.initiator.id_ " ..
							tostring(event.initiator.id_))

							local crashVec3 = event.initiator:getPoint()
							local typeLand = land.getSurfaceType({ x = crashVec3.x, y = crashVec3.z })

							--TODO ajouter une proximité Base & Farp pour ne pas le faire dessus
							if typeLand ~= land.SurfaceType.WATER and typeLand ~= land.SurfaceType.RUNWAY then
								local Group = event.initiator:getGroup()
								local gpGid = Group:getID()
								local categoryId = event.initiator:getDesc().category

								local countryId = event.initiator:getCountry()
								local countryName = string.lower(country.name[countryId])
								local coalitionId = event.initiator:getCoalition()
								local sideName = CoalitionIdToName[tonumber(coalitionId)]

								local eventData = {
									name = name,
									SurfaceType = typeLand,
									aircraftType = event.initiator:getTypeName(),
									lifePourcent = lifePourcent,
									crashPointVec3 = crashVec3,
									unit = event.initiator,
									gpGid = gpGid,
									idLabel = idLabel,
									categoryId = categoryId,
									coalitionId = coalitionId,
									initiatorMissionID = event.initiator:getID(),
									countryId = countryId,
									countryName = countryName,
									sideName = sideName,
									initiator_id_ = event.initiator.id_,
								}

								if not GroundDamagedFlyingMachine[event.initiator.id_] then GroundDamagedFlyingMachine[event.initiator.id_] = {} end
								table.insert(GroundDamagedFlyingMachine[event.initiator.id_], eventData)

								if campL.debug then
									local logStr = "DamagedFM = " .. TableSerialization(GroundDamagedFlyingMachine, 0)
									local grpnameClean = name:gsub('[%p%c%s]', '_')
									local logFile = io.open(
									PathDCE ..
									"Debug\\" ..
									event.initiator.id_ .. "_" .. grpnameClean ..
									"_" .. "DamagedFM_" .. current_time .. ".lua", "w")
									if logFile then
										logFile:write(logStr)
										logFile:close()
									else
										env.info("DCE_GroundDamagedFlyingMachine: Failed to open log file for writing.")
									end
								end
							end
						end
					end
				end
			end
		elseif event.id == world.event.S_EVENT_DEAD or event.id == world.event.S_EVENT_PILOT_DEAD or event.id == world.event.S_EVENT_KILL then
			local playerName = event.initiator:getPlayerName()
			if playerName then
				local desc = event.initiator:getDesc()
				if desc and desc.category == Unit.Category.HELICOPTER then
					local aircraftName = event.initiator:getName()
					timer.scheduleFunction(MonitorPlayerAircraftActivity,
						{ "out", playerName, aircraftName, desc.category }, current_time + 1)
				end
			end

			--TODO controler si c'est utile
			if event.initiator and event.initiator.id_ then
				for n, damageds in pairs(GroundDamagedFlyingMachine) do
					local toRemove = {} -- Table pour stocker les clés à supprimer

					for initiatorId, damaged in pairs(damageds) do
						env.info("DCE_GroundDamagedFlyingMachine S_EVENT_KILL n: " ..
						n .. " initiatorId: " .. tostring(initiatorId))

						if initiatorId == event.initiator.id_ then
							env.info("DCE_GroundDamagedFlyingMachine S_EVENT_KILL delete initiatorId: " ..
							tostring(initiatorId))
							table.insert(toRemove, initiatorId)
						end
					end

					-- Supprimer les entrées après avoir parcouru la table
					for _, initiatorId in ipairs(toRemove) do
						damageds[initiatorId] = nil
					end
				end
			end
		end
	end
end

world.addEventHandler(EventHandler2)


local function showPerformance()

	env.info("DCE_showPerformance, bingo(): " .. tonumber(Bingo_time) .. " n: " .. tonumber(Bingo_calls) .. " /n: " .. tonumber(Bingo_time / Bingo_calls))
	env.info("DCE_showPerformance, avoidAera(): " .. tonumber(Perf_A) .." n: ".. tonumber(Perf_A_N).." /n: ".. tonumber(Perf_A / Perf_A_N))
	env.info("DCE_showPerformance, EWR_magic(): " .. tonumber(Perf_B) .." n: ".. tonumber(Perf_B_N).. " /n " .. tonumber(Perf_B / Perf_B_N))
	env.info("DCE_showPerformance, EWR_magic()Player: " .. tonumber(Perf_Bb) .." n: ".. tonumber(Perf_B_Nb).. " /n " .. tonumber(Perf_Bb / Perf_B_Nb))
	
	env.info("DCE_showPerformance, airRetreat(): " .. tonumber(Perf_C) .." n: ".. tonumber(Perf_B_N).. " /n " .. tonumber(Perf_C / Perf_C_N))
	env.info("DCE_showPerformance, LoopSAR(): " .. tonumber(Perf_D) .." n: ".. tonumber(Perf_D_N).. " /n " .. tonumber(Perf_D / Perf_D_N))
	env.info("DCE_showPerformance, loopAFAC_CAS(): " .. tonumber(Perf_F) .." n: ".. tonumber(Perf_F_N).. " /n " .. tonumber(Perf_F / Perf_F_N))

	env.info("DCE_showPerformance, trackBomb(): " .. tonumber(Perf_E) .." n: ".. tonumber(Perf_E_N).. " /n " .. tonumber(Perf_E / Perf_E_N))
	env.info("DCE_showPerformance, updateTrackedBombs(): " .. tonumber(Perf_H) .." n: ".. tonumber(Perf_H_N).. " /n " .. tonumber(Perf_H / Perf_H_N))
	env.info("DCE_showPerformance, destructionScenaryInZone(): " .. tonumber(Perf_J) .." n: ".. tonumber(Perf_J_N).. " /n " .. tonumber(Perf_J / Perf_J_N))


	env.info("DCE_showPerformance_B_40, Custom_Altitude(): " ..
	tonumber(Perf_K) .. " n: " .. tonumber(Perf_K_N) .. " /n " .. tonumber(Perf_K / Perf_K_N))

	
	env.info("DCE_showPerformance, Custom_SAR(): " .. tonumber(Perf_L) .. " n: " .. tonumber(Perf_L_N) .. " /n " .. tonumber(Perf_L / Perf_L_N))
	env.info("DCE_showPerformance, ARM_Defence_Script(): " .. tonumber(Perf_M) .. " n: " .. tonumber(Perf_M_N) .. " /n " .. tonumber(Perf_M / Perf_M_N))
	env.info("DCE_showPerformance, CheckImmediatSAR(): " .. tonumber(Perf_S) .. " n: " .. tonumber(Perf_S_N) .. " /n " .. tonumber(Perf_S / Perf_S_N))
	env.info("DCE_showPerformance, CheckRtbAirbase(): " ..
        tonumber(Perf_I) .. " n: " .. tonumber(Perf_I_N) .. " /n " .. tonumber(Perf_I / Perf_I_N))
		
	env.info("DCE_showPerformance, CustomGroupAttack(): " ..
        tonumber(Perf_P) .. " n: " .. tonumber(Perf_P_N) .. " /n " .. tonumber(Perf_P / Perf_P_N))

	env.info("DCE_showPerformance, CustomMixClassAttack(): " ..
		tonumber(Perf_Q) .. " n: " .. tonumber(Perf_Q_N) .. " /n " .. tonumber(Perf_Q / Perf_Q_N))

	env.info("DCE_showPerformance, EventsTrackers: " ..
		tonumber(Perf_O) .. " n: " .. tonumber(Perf_O_N) .. " /n " .. tonumber(Perf_O / Perf_O_N))

    
	_affiche(Perf_EventsT, "Perf_EventsT: ")
		
		
	return timer.getTime() + 120

end


--/////////////////////////bootstrap (repris tel quel depuis AddCommandRadioF10.lua)
timer.scheduleFunction(hotSpotSAM, nil, timer.getTime() + 0.03) --creation de la table de couverture anti aérienne AMI

timer.scheduleFunction(airRetreat, nil, timer.getTime() + 6)

timer.scheduleFunction(avoidArea, nil, timer.getTime() + 7)

timer.scheduleFunction(EWR_magic, nil, timer.getTime() + 31)

if campL.debug then --ça, ça ne marche pas
	timer.scheduleFunction(showPerformance, nil, timer.getTime() + 30)
end

env.info("DCE_Background END OF LOADING")
