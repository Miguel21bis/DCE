--To run during mission to detect targets by EWR and launch interceptors
--Script attached to mission and executed via trigger
--Requires GCIdata.lua to be attached and run in mission in order to get access to table GCI
------------------------------------------------------------------------------------------------------- 
-- last modification debug_d
if not versionDCE then versionDCE = {} end
versionDCE["Mission Scripts/GCIscript.lua"] = "1.4.23"
------------------------------------------------------------------------------------------------------- 
-- cleanCode_b					(b springCleaning)
-- debug_d						(d CheckPointInPoly_XY_2, XZ au lieu XY)(c getcategory again)(b unit category, tks ldnz)(a getheading Z)
-- adjustment_d					(d targetPlane)(c no Inter In Bad Side) in wrongSide)(b: intercept)(a recherche blocage)
-- modification M11_j			Multiplayer
------------------------------------------------------------------------------------------------------- 

env.info("DCE_GCI START LOADING GCIscript.lua "..tostring(versionDCE["Mission Scripts/GCIscript.lua"]))

ControlTime = 0

env.info("DCE_GCI INIT loading GCIScript")
env.info("DCE_GCI Unit.Category.AIRPLANE A: "..tostring(Unit.Category.AIRPLANE))
env.info("DCE_GCI Unit.Category.HELICOPTER B: "..tostring(Unit.Category.HELICOPTER))

--example of data structure for table GCI supplied by GCIdata.lua
--[[
GCI = {
	EWR = {
		["blue"] = {
			["EWR 1"] = true,
			["EWR 2"] = true,
		},
		["red"] = {},
	},
	Interceptor = {
		["blue"] = {
			base = {
				["base_XYZ"] = {
					ready30 = {},
					ready15 = {},
					ready15_n = 0,
					ready = {},
					ready_n = 0,
				},
			},
			assigned = {},
		},
		["red"] = {
			base = {
				["base_XYZ"] = {
					ready30 = {},
					ready15 = {},
					ready15_n = 1,
					ready = {
						[1] = {
							name = "Flight 1",
							number = 2,
							range = 150000,
							x = 123,
							y = 123,
							tot_from,
							tot_to,
							airdromeId,
							time = -900,
						},
					},
					ready_n = 1,
				},
			},
			assigned = {},
		}
	}
}
]]--

--function to return a new point offset from an initial point
--TODO ATTENTION si la fonction n arrive pas , renommer en GETHEADINGGEO
-- function GetOffsetPointIM(point, heading, distance)
-- 	return {
-- 		x = point.x + math.cos(math.rad(heading)) * distance,
-- 		y = point.y + math.sin(math.rad(heading)) * distance
-- 	}
-- end
--function to return heading between two vector2 points
function GetHeadingIM(p1, p2)

	local deltax = p2.x - p1.x
	local deltay = p2.y - p1.y
	if (deltax > 0) and (deltay == 0) then
		return 0
	elseif (deltax > 0) and (deltay > 0) then
		return math.deg(math.atan(deltay / deltax))
	elseif (deltax == 0) and (deltay > 0) then
		return 90
	elseif (deltax < 0) and (deltay > 0) then
		return 90 - math.deg(math.atan(deltax / deltay))
	elseif (deltax < 0) and (deltay == 0) then
		return 180
	elseif (deltax < 0) and (deltay < 0) then
		return 180 + math.deg(math.atan(deltay / deltax))
	elseif (deltax == 0) and (deltay < 0) then
		return 270
	elseif (deltax > 0) and (deltay < 0) then
		return 270 - math.deg(math.atan(deltax / deltay))
	else
		return 0
	end
end


local ErrorMsg = ""																				--variable to store script status in case of error

--target tracks
local target_tracks = {
	["blue"] = {},
	["red"] = {}
}

local function GCI_Cycle()
	local current_time = timer.getTime()
	--remove old targets from target_tracks
	ErrorMsg = "Remove old tracks."																--Error message in case follow on code fails
	for track_side, side in pairs(target_tracks) do												--iterate through sides in target tracks table
		for target_name, target in pairs(side) do												--iterate through targets
			ErrorMsg = "Remove old tracks: " .. target_name .. " no time stamp."				--Error message in case follow on code fails
			if target.time + 300 < current_time then											--if target was not detected for more than 5 minutes
				target.assigned = 0
				target.number = 0																--make target void
			end
		end
	end

	--update assigned interceptors table
	ErrorMsg = "Update interceptor table."														--Error message in case follow on code fails
	for side_name, side in pairs(GCI.Interceptor) do											--iterate through sides in Interceptor table	
		for base_name, base in pairs(side.base) do													--iterate through bases in Interceptor table
			--move ready 15 flights to ready
			while #base.ready < base.ready_n and base.ready15[1] and base.ready15[1].time + 1800 < current_time do		--less interceptor flights are ready than planned AND ready15 flights exist AND flight must be in ready15 since 15 minutes to move up (when coming from ready30, otherwise time is -900 for no delay)														
				base.ready15[1].time = current_time												--reset timer so that flight will not become ready until 15 minutes have passed
				table.insert(base.ready, base.ready15[1])										--move ready15 flight to ready
				table.remove(base.ready15, 1)													--move ready15 flight to ready		
			end

			--move ready 30 flights to ready 15
			while #base.ready15 < base.ready15_n and base.ready30[1] and base.ready30[1].time + 3600 < current_time do							--less interceptor flights are ready15 than planned AND ready30 flights exist															
				base.ready30[1].time = current_time												--set timer so that flight will not become ready15 until 15 minutes have passed
				table.insert(base.ready15, base.ready30[1])										--move ready30 flight to ready15
				table.remove(base.ready30, 1)													--move ready30 flight to ready15	
			end
		end

		for flight_name, flight in pairs(side.assigned) do										--iterate through assigned interceptors
			ErrorMsg = "Update interceptor table: "	.. 	flight_name								--Error message in case follow on code fails
			local group = Group.getByName(flight_name)											--get group of flight
			if group then
				local units = group:getUnits()													--get alive units array of group
				local difference = #units - flight.number										--number of of interceptors that died since last cylce										
				target_tracks[side_name][flight.target].assigned = target_tracks[side_name][flight.target].assigned + difference	--remove dead interceptors from assigned number of target track
				flight.number = #units															--store new number of interceptors
			else																				--group doesnt exist
				target_tracks[side_name][flight.target].assigned = target_tracks[side_name][flight.target].assigned - flight.number	--remove dead interceptors from assigned number of target track
				side.assigned[flight_name] = nil												--remove flight from Interceptors table
			end
			if target_tracks[side_name][flight.target].assigned < 0 then						--make sure that assigned number of target track is not negative (lost track resets number to 0 and dead interceptor can further subtract form that)
				target_tracks[side_name][flight.target].assigned = 0
			end
		end
	end

	--EWR target detection
	ErrorMsg = "EWR target detection."																--Error message in case follow on code fails
	for ewr_side, ewr_table in pairs(GCI.EWR) do													--iterate through sides in EWR table
		for ewr_name, bool in pairs(ewr_table) do													--iterate through EWR radars	
			ErrorMsg = "EWR target detection: "	.. ewr_name											--Error message in case follow on code fails
			local unit = Unit.getByName(ewr_name)													--get EWR unit
			if unit then																			--if unit exists
				local ctr = unit:getGroup():getController()											--get unit controller
				local targets = ctr:getDetectedTargets()											--get detected targets of this EWR
				local track_update = {}																--local table to store which group tracks were already updated (to prevent multiple detected targets from the same group to update same track)
				for t = 1, #targets do																--iterate through detected targets
					--le radar peut aussi detecter les missiles, il faut donc prouver que c'est une unité avant toute chose
					if targets[t].object and Object.getCategory(targets[t].object) == Object.Category.UNIT then
						
						local objCat = Object.getCategory(targets[t].object)
						
						local targetDesc = targets[t].object:getDesc()
						local txtA = ""

						local targetCat = targetDesc.category
						-- env.info("DCE_Gci A_C targetCat "..tostring(targetCat))

						-- _affiche(targetDesc, "DCE_Gci A_C2 targetDesc ")

						local isExist = targets[t].object:isExist()
						local inAir = targets[t].object:inAir()

						if isExist and inAir and targetCat and (targetCat == Unit.Category.AIRPLANE or targetCat == Unit.Category.HELICOPTER) then
							local targetGpObject = targets[t].object:getGroup()
							local target_name = targetGpObject:getName()			--get target group name
							-- env.info("DCE_Gci A_D² ")

							if track_update[target_name] == nil then							--the target track for this group has not yet been updated
								-- env.info("DCE_Gci A_E "..tostring(target_name))	
								track_update[target_name] = true								--the target track for this group is updated
								local target_number = targetGpObject:getUnits()	--get target group size
								local target_pointVec3 = targets[t].object:getPoint()				--get target point
								local target_typeName = targetGpObject:getUnit(1):getTypeName()
								-- env.info("DCE_Gci A_G "..tostring(target_typeName))
								ErrorMsg = "EWR target detection: " .. ewr_name	.. "; Target: " .. target_name 	--Error message in case follow on code fails

								if target_tracks[ewr_side][target_name] then					--existing track
									if target_tracks[ewr_side][target_name].time > current_time - 30 then	--last detection was within 30 seconds
										target_tracks[ewr_side][target_name].history = target_tracks[ewr_side][target_name].history + 1		--increase detection history by one
									else																	--last detection is older than 30 seconds
										target_tracks[ewr_side][target_name].history = 0					--reset detection history to 0
									end
									target_tracks[ewr_side][target_name].number = #target_number
									target_tracks[ewr_side][target_name].time = current_time
									target_tracks[ewr_side][target_name].pointVec3 = target_pointVec3
									target_tracks[ewr_side][target_name].category = targetDesc.category
									-- target_tracks[ewr_side][target_name].target_Type = targetDesc.typeName
								else															--new track
									target_tracks[ewr_side][target_name] = {
										number = #target_number,								--number of aircraft in traget group
										time = current_time,									--time of current detection
										pointVec3 = target_pointVec3, --position of this target group
										typeName = target_typeName,
										history = 0,											--number of detections in sequence
										assigned = 0,											--number of interceptors assigned to this target group
										category = targetCat,
										-- target_Type = targetDesc.typeName,
									}

								end
							end
						end
					end
				end
			end
		end
	end

	--assign interceptors to targets
	ErrorMsg = "Assign interceptors."																--Error message in case follow on code fails
	for track_side, side in pairs(target_tracks) do													--iterate throug sides in target_tracks table
		-- env.info("DCE_Gci B_1 track_side: "..track_side)

		for target_name, target in pairs(side) do													--iterate through targets
			-- env.info("DCE_Gci B_2 "..tostring(target_name))
			ErrorMsg = "Assign interceptors; Target: " .. target_name								--Error message in case follow on code fails
			
			if target.history > 0 then																--target was detected at least two times in sequence
				-- env.info("DCE_Gci B_3 ")

				--ne declenche les intercepteur que si les ENI franchissent la frontiere
				-- ou si le target est entre chez nous et chez eux (zone tampon ou eau international)
				local ourSideOfBorder = false
				local enemySideOfBorder = false
				local authorizedInter = false

				if camp.boundary and camp.boundary[track_side] and camp.boundary[track_side] ~= nil then
					-- env.info("DCE_Gci B_4 ")

					ourSideOfBorder =  CheckPointInPoly_XY_3({x=target.pointVec3.x,y=target.pointVec3.z}, camp.boundary[track_side])

					enemySideOfBorder =  CheckPointInPoly_XY_3({x=target.pointVec3.x,y=target.pointVec3.z}, camp.boundary[DCS_ENI_Side[track_side]])

					-- if enemySideOfBorder then
					-- 	--pour info
					-- 	env.info("DCE_Gci B_5 enemySideOfBorder "..tostring(enemySideOfBorder))
					-- end

					if ourSideOfBorder then

						authorizedInter = true
						-- env.info("DCE_Gci B_6 ourSideOfBorder "..tostring(ourSideOfBorder))

					elseif not ourSideOfBorder and not enemySideOfBorder then

						authorizedInter = true
						-- env.info("DCE_Gci B_7 zone tampon authorizedInter "..tostring(authorizedInter))

					else
						-- --check si le target est sur la mere
						-- local surfaceType = land.getSurfaceType({x = target.point.x, y = target.point.z})
						-- if surfaceType == land.SurfaceType.WATER then
						-- 	local landFound = false

						-- 	for _, rad in ipairs({0, math.pi / 2, math.pi, 3 * math.pi / 2}) do
						-- 		local dist = 10000
						-- 		local sondageLand = GetOffsetPoint({x=target.point.x, y=target.point.z}, rad, dist)
						-- 		surfaceType = land.getSurfaceType(sondageLand)

						-- 		if surfaceType ~= land.SurfaceType.WATER then
						-- 			landFound = true
						-- 			break
						-- 		end
						-- 	end
							

						-- 	if not landFound then
						-- 		authorizedInter = true
						-- 		env.info("DCE_Gci Passe B_C10 WATER sur, No Land Found ")
						-- 	end
							
						-- end
					end
				else
					authorizedInter = true
				end

				-- env.info("DCE_Gci B_8 authorizedInter: "..tostring(authorizedInter).." | target.assigned<? "..tostring(target.assigned).." target.number"..tostring(target.number))

				if authorizedInter and target.assigned < target.number then												--if target has less interceptors assigned than it has aircraft in group
					-- env.info("DCE_Gci C0 ")	
					--find all flights in range to intercept target
					local eligible_flights = {}														--table of flights eligible for interception of this target
					local goodTargetType = true
					for base_name, base in pairs(GCI.Interceptor[track_side].base) do				--iterate through bases in GCI table
						if base.targetPlane then 
							goodTargetType = false
							for tPlaneN, tPlane in pairs(base.targetPlane) do
								if tPlane == target.typeName then
									goodTargetType = true
									break
								end
							end
						end
					
						-- env.info("DCE_Gci C1 goodTargetType: "..tostring(goodTargetType))

						if goodTargetType then
							-- env.info("DCE_Gci C2 base_name: "..tostring(base_name))
							for flight_n, flight in pairs(base.ready) do								--iterate through ready interceptor flights
								-- env.info("DCE_Gci C3")

								if flight.time + 900 < current_time then								--interceptor flight has moved to ready status (from ready15) longer than 15 minutes ago and is ready for action (time is -900 for flight starting ready at mission start).
									ErrorMsg = "Assign interceptors; Target: " .. target_name .. "; Interceptor: " .. flight.name						--Error message in case follow on code fails
									
									-- if current_time >= flight.tot_from and current_time <= flight.tot_to then											--flight can operate at current time							
										local distance = math.sqrt(math.pow(target.pointVec3.x - flight.x, 2) + math.pow(target.pointVec3.z - flight.y, 2))		--distance between interceptor airbase and target
										-- env.info("DCE_Gci C5 distance: "..tostring(distance).." <?range: "..tostring(flight.range))
										
										if distance < flight.range then									--target is in interception range
											-- env.info("DCE_Gci C6")
											
											eligible_flights[flight.name] = distance					--store flight name and interception distance in table
										end
									-- end
								end
							end
						end


					end

					--select the flight closest to target for interception
					local selected_flight															--currently selected flight for interception
					local selected_distance = 9999999												--interception distance of currently selected flight
					for flight_name, distance in pairs(eligible_flights) do							--iterate through eligible flights
						if distance < selected_distance then										--if distance of current flight is lower than of currently selected flight
							selected_flight = flight_name											--select this flight instead
							selected_distance = distance											--make this the new distance
						end
					end

					-- env.info("DCE_Gci N selected_flight: "..tostring(selected_flight))

					--assign selected flight to target
					ErrorMsg = "Assign interceptors; Target: " .. target_name .. "; Select Flight."					--Error message in case follow on code fails
					local launchedInterceptorOK = false

					if selected_flight then
						-- env.info("DCE_Gci D1 target_name: "..tostring(target_name))

						for base_name, base in pairs(GCI.Interceptor[track_side].base) do				--iterate through bases in GCI table
							-- env.info("DCE_Gci D2 base_name: "..tostring(base_name))
						
							for flight_n, flight in pairs(base.ready) do								--iterate through ready interceptor flights						
								-- env.info("DCE_Gci D3 flight_n: "..tostring(flight_n))
								
								if flight.name == selected_flight then									--find selected interceptor flight in ready table
									-- env.info("DCE_Gci D4 flight.name: "..tostring(flight.name))
									
									trigger.action.setUserFlag(flight.flag, true)						--set flag true to launch interceptor
									-- trigger.action.outText(selected_flight .. " 01 launched to intercept " .. target_name, 15)	--FOR DEBUG
									
									local groupObj = Group.getByName(selected_flight)

									if groupObj then
										local isExist = groupObj:isExist()
										-- local inAir = targets[t].object:inAir()
										if not isExist then 
											-- env.info("DCE_Gci D5 group doesnt exist, break "..tostring(selected_flight))
											break

										end
									else

										-- env.info("DCE_Gci D6 groupObj doesnt exist, break "..tostring(selected_flight))
										break
									end
									
									local idInfo = groupObj:getID()

									-- on replace les vecteurs dans un repere x/y/z/
									local newTarget = {}
									newTarget.point = {}
									newTarget.point.x = target.pointVec3.x
									newTarget.point.y = target.pointVec3.z
									newTarget.point.z = target.pointVec3.y

									target.altitude = math.floor(target.pointVec3.y / 1000) * 1000
									target.distance_Km = math.floor(selected_distance / 10000) * 10
									target.distance = selected_distance
									local testBearing = math.floor(GetHeadingIM(flight, newTarget.point))
									target.bearing = math.floor(GetHeading({x=flight.x, y=flight.y}, {x=target.pointVec3.x, y=target.pointVec3.z} ))



									env.info("DCE_Gci "..selected_flight .. " launched to intercept: " .. target.number .." | "..target.typeName.." |Bearing: "..target.bearing.. " |testBearing: "..testBearing.." |Angel: "..target.altitude.." |Distance: "..target.distance_Km.." Km")

									trigger.action.outTextForGroup(idInfo, selected_flight .. " launched to intercept: " .. target.number .." "..target.typeName.." Bearing: "..target.bearing.." Angel: "..target.altitude.." Distance: "..target.distance_Km.." Km", 60 , true)

									-- trigger.action.outSoundForCoalition(_side, "l10n/DEFAULT/alarme.wav" )

									trigger.action.outSoundForGroup(idInfo, "l10n/DEFAULT/alarme.wav" )

									--***********************************************************************************
									--***********************************************************************************
									-- env.info( "DCE_Gci D8 distance: "..tostring(target.distance).." altitude: "..target.altitude)
									local distance2 = target.distance/3
									local weaponType = 1069547520					--automatique
									local point_1 = GetOffsetPoint(flight, target.bearing, distance2/2)

									if target.category == 0 then             --avion
										distance2 = (target.distance/3)*2
										-- env.info( "DCE_Gci D9 avion "..tostring(distance2))
										weaponType = 1069547520					--automatique
									elseif  target.category == 1 then             --helico
										distance2 = target.distance/3
										-- env.info( "DCE_Gci D10 helico "..tostring(distance2))
										weaponType = 4194304						--Short Range Missile (Fox2)
									end

									local point_2 = GetOffsetPoint(flight, target.bearing, distance2)

									local distance3 = (target.distance/3)*2
									local point_3 = GetOffsetPoint(flight, target.bearing, distance3)
									point_3.x = point_3.x + 1000
									point_3.y = point_3.y + 1000
									local distAfterPt3 = math.sqrt(math.pow(point_2.x - point_3.x, 2) + math.pow(point_2.y - point_3.y, 2))
									local distRTB = math.sqrt(math.pow(point_3.x - flight.x, 2) + math.pow(point_3.y - flight.y, 2))
									local speed = 250      --mur du son 350 Atl0 293 Atl10000m

									--assign mission task to interceptor flight
									ErrorMsg = "Assign interceptors; Target: " .. target_name .. "; Selected Flight: " .. selected_flight				--Error message in case follow on code fails
									
									local function AssignMission()												--function to set interception mission (to be executed with 2 seconds delay, in order for the group to activate first)

										local ctr = Group.getByName(selected_flight):getController()			--get controller of interceptor group

										local flightAir = Group.getByName(selected_flight)
										local leader = flightAir:getUnit(1)
										local descIntercept = leader:getDesc()
										--mig23 speedMax0 388 m.s
										--["speedMax"] = 693.25,

										if descIntercept and descIntercept.speedMax0 then
											speed = descIntercept.speedMax0 * 0.8

										end


										if camp.debug and descIntercept then
											--export custom mission log
											local logStr = "descIntercept = " .. TableSerialization(descIntercept, 0)
											local FlightNameClean = selected_flight:gsub('[%p%c%s]', '_')
											local logFile = io.open(PathDCE.."Debug\\"..FlightNameClean.."_".. "DESCRIPT_INTER".."_"..tostring(current_time)..".lua", "w")
											if logFile then
												logFile:write(logStr)
												logFile:close()
											else
												env.info("DCE_Gci E1 DCE_DESCRIPT_INTER: Failed to open log file for writing.")
											end
										end

										-- env.info( " A intercept target_name : "..tostring(target_name) )
										local GrpObjt =  Group.getByName(target_name)

										if not GrpObjt or GrpObjt == nil then
											return
										end

										-- env.info( "DCE_Gci E2 intercept GrpObjt : "..tostring(GrpObjt) )
										local target_id = GrpObjt:getID()
										-- env.info( "DCE_Gci E3 intercept target_id: "..tostring(target_id) )

										target_id = Group.getByName(target_name):getID()					--get target group ID --TODO BUG 287: attempt to index a nil value stack traceback:
										local Mission = {														--define mission for interceptor group
											id = 'Mission',
											params = {
												route = {
													["points"] = {
														[1] = {
															["alt"] = 2000,
															["type"] = "Turning Point",
															["action"] = "Turning Point",
															["alt_type"] = "BARO",
															["formation_template"] = "",
															["ETA"] = tonumber((distance2 / speed) + current_time) ,
															["y"] = point_1.y,
															["x"] = point_1.x,
															["speed"] = tonumber(speed),
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
																				["groupId"] = target_id,
																				["priority"] = 1,
																				["weaponType"] = weaponType,
																			},
																		},

																	},
																},
															},
															["speed_locked"] = true,
														},
														[2] = {
															["alt"] = target.altitude + 500,
															["type"] = "Turning Point",
															["action"] = "Turning Point",
															["alt_type"] = "BARO",
															["formation_template"] = "",
															["ETA"] = tonumber((distance2 / speed) + current_time) ,
															["y"] = point_2.y,
															["x"] = point_2.x,
															["speed"] = tonumber(speed),
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
																				["groupId"] = target_id,
																				["priority"] = 1,
																				["weaponType"] = weaponType,
																			},
																		},
																		[2] = {
																			["number"] = 2,
																			["auto"] = false,
																			["id"] = "ControlledTask",
																			["enabled"] = true,
																			["params"] = {
																				["task"] = {
																					["id"] = "Orbit",
																					["params"] = {
																						["altitude"] = target.altitude + 500,
																						["pattern"] = "Circle",
																						["speed"] = 200,
																					},
																				},
																				["stopCondition"] = {
																					["time"] = current_time + 1200,
																				}
																			}
																		},

																	},
																},
															},
															["speed_locked"] = true,
														},
														[3] = {
															["alt"] = 4000,
															["type"] = "Turning Point",
															["action"] = "Turning Point",
															["alt_type"] = "BARO",
															["formation_template"] = "",
															["ETA"] = tonumber((distAfterPt3 / speed) + current_time),
															["y"] = point_3.y,
															["x"] = point_3.x,
															["speed"] = tonumber(speed),
															["ETA_locked"] = false,
															["task"] = {
																["id"] = "ComboTask",
																["params"] = {
																	["tasks"] = {
																		[1] =
																		{
																			["enabled"] = true,
																			["key"] = "CAP",
																			["id"] = "EngageTargets",
																			["number"] = 1,
																			["auto"] = true,
																			["params"] =
																			{
																				["targetTypes"] =
																				{
																					[1] = "Air",
																				}, -- end of ["targetTypes"]
																				["priority"] = 0,
																			}, -- end of ["params"]
																			["maxDistEnabled"] = true,
                                                               				["maxDist"] = 40000,
																		}, -- end of [1]

																		[2] = {
																			["number"] = 2,
																			["auto"] = false,
																			["id"] = "ControlledTask",
																			["enabled"] = true,
																			["params"] = {
																				["task"] = {
																					["id"] = "Orbit",
																					["params"] = {
																						["altitude"] = 4000,
																						["pattern"] = "Circle",
																						["speed"] = 200,
																					},
																				},
																				["stopCondition"] = {
																					["time"] = current_time + 1200,
																				}
																			}
																		},
																	},
																},
															},
															["speed_locked"] = true,
														},
														[4] = {
															["alt"] = 2000,
															["type"] = "Land",
															["action"] = "Landing",
															["airdromeId"] = flight.airdromeId,
															["alt_type"] = "BARO",
															["formation_template"] = "",
															["ETA"] = tonumber((distRTB / speed) + current_time),
															["y"] = flight.y,
															["x"] = flight.x,
															["speed"] = tonumber(speed),
															["ETA_locked"] = false,
															["task"] = {
																["id"] = "ComboTask",
																["params"] = {
																	["tasks"] = {
																	},
																},
															},
															["speed_locked"] = true,
														},
													},
												}
											}
										}
										Controller.setTask(ctr, Mission)																			--activate task with mission for interceptor group

										if camp.debug then
											--export custom mission log
											local logStr = "ComboTask = " .. TableSerialization(Mission, 0)
											local FlightNameClean = selected_flight:gsub('[%p%c%s]', '_')
											local logFile = io.open(PathDCE.."Debug\\"..FlightNameClean.."_".. "INTERCEPTOR".."_"..tostring(current_time)..".lua", "w")
											if logFile then
												logFile:write(logStr)
												logFile:close()
											else
												env.info("DCE_INTERCEPTOR: Failed to open log file for writing.")
											end
										end

									end

									timer.scheduleFunction(AssignMission, nil, timer.getTime() + 2)													--set intercept mission with 2 seconds delay

									ErrorMsg = "Assign interceptors; Target: " .. target_name .. "; Selected Flight: " .. selected_flight .. "; Update GCI Table."				--Error message in case follow on code fails

									launchedInterceptorOK = true

									GCI.Interceptor[track_side].assigned[selected_flight] = GCI.Interceptor[track_side].base[base_name].ready[flight_n]	--move flight from ready to assigned status
									table.remove(GCI.Interceptor[track_side].base[base_name].ready, flight_n)											--move flight from ready to assigned status
									GCI.Interceptor[track_side].assigned[selected_flight].target = target_name										--store target name
									target.assigned = target.assigned + GCI.Interceptor[track_side].assigned[selected_flight].number				--mark target as assigned for interception

									if camp.debug then
										--export custom mission log
										local logStr = "GCI = " .. TableSerialization(GCI, 0)
										local logFile = io.open(PathDCE.."Debug\\GCI".."_".. "TABLE".."_"..tostring(current_time)..".lua", "w")
										if logFile then
											logFile:write(logStr)
											logFile:close()
										else
											env.info("DCE_GCI TABLE: Failed to open log file for writing.")
										end
									end

									break
								end
								if launchedInterceptorOK then
									break
								end
							end
							if launchedInterceptorOK then
								break
							end
						end
					end
				end
			end
		end
	end

	ControlTime = timer.getTime()																--update ControlTime to tell ControlFunction() that cylce is still running
	return timer.getTime() + 18																	--repeat GCI cycle every 18 seconds (revolution time of 1L13 EWR radar)
end
timer.scheduleFunction(GCI_Cycle, nil, timer.getTime() + 1)										--start GCI cylce


--Control function to report when GCI_Cylce() stopped working
local function ControlFunction()
	if ControlTime + 30 < timer.getTime() then													--if ControlTime was not updated since 30 seconds
		trigger.action.outText("GCI_Cycle() Error: " .. ErrorMsg, 60)							--print error
		env.info("DCE_GCI_Cycle() Error: " .. ErrorMsg)
	else
		return timer.getTime() + 15
	end
end
timer.scheduleFunction(ControlFunction, nil, timer.getTime() + 2)

env.info("DCE_GCI END OF LOADING GCIScript")