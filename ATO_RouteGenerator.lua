--To generate a flight route from base to target, evading as much threats as possible
--Returns route points, route lenght and route threat level (unavoided threats)
--Initiated by Main_NextMission.lua
------------------------------------------------------------------------------------------------------- 
-- last modification:  cleancode_a
if not versionDCE then versionDCE = {} end
versionDCE["ATO_RouteGenerator.lua"] = "1.8.48"
------------------------------------------------------------------------------------------------------- 
-- cleancode_a				(d springCleaning)
-- adjustment_n				(n create assemblyPoint)(m add AFAC task)(l alti heli)k alti station on target)(j does not fly over the target)(i escort Transport)(h alti escorte helicoptere)(fg add axis patern)(e unit.helicopter)(d escort too low) (c: climb refueling)(a:alti diff en fonction du role dans le meme package)
-- Debug_e					(e SEAD SAm)(d route[m + 1])(c:supprime trop de waypoint lors de l'escorte)(b:quand les EWR sont d�truit: on active les CAP, si les CAP on besoin d'EWR c'est nul)(a:target ligne 473 Reconnaissance)
-- modification M66_a		add Runway Attack
-- modification M61_a		SAR
-- modification M16_d		SpawnAir B1b & B-52 need BaseAirStart = true in db_aibase
-- modification M38_t		Check and Help CampaignMaker (t debug info) 
-- modification M06_a		helicoptere playable
------------------------------------------------------------------------------------------------------- 


local debugRoute = false

local deltaT = 0.15		-- deltaT = 0.25
local assemblePointDistance = 20000


--https://love2d.org/forums/viewtopic.php?t=88719
-- Checks if two lines intersect (or line segments if seg is true)
-- Lines are given as four numbers (two coordinates)
-- function math.findIntersect(l1p1x,l1p1y, l1p2x,l1p2y, l2p1x,l2p1y, l2p2x,l2p2y, seg1, seg2)
-- function findIntersect(l1p1, l1p2, l2p1, l2p2)
-- 	local l1p1x,l1p1y, l1p2x,l1p2y, l2p1x,l2p1y, l2p2x,l2p2y = l1p1.x, l1p1.y, l1p2.x, l1p2.y, l2p1.x, l2p1.y, l2p2.x, l2p2.y
-- 	local seg1, seg2 = true, true
-- 	local a1,b1,a2,b2 = l1p2y-l1p1y, l1p1x-l1p2x, l2p2y-l2p1y, l2p1x-l2p2x
-- 	local c1,c2 = a1*l1p1x+b1*l1p1y, a2*l2p1x+b2*l2p1y
-- 	local det,x,y = a1*b2 - a2*b1
-- 	if det==0 then return false, "The lines are parallel." end
-- 	x,y = (b2*c1-b1*c2)/det, (a1*c2-a2*c1)/det
-- 	if seg1 or seg2 then
-- 		local min,max = math.min, math.max
-- 		if seg1 and not (min(l1p1x,l1p2x) <= x and x <= max(l1p1x,l1p2x) and min(l1p1y,l1p2y) <= y and y <= max(l1p1y,l1p2y)) or
-- 			seg2 and not (min(l2p1x,l2p2x) <= x and x <= max(l2p1x,l2p2x) and min(l2p1y,l2p2y) <= y and y <= max(l2p1y,l2p2y)) then
-- 			return false, "The lines don't intersect."
-- 		end
-- 	end
-- 	return x,y
-- end

local function findIntersect(l1p1, l1p2, l2p1, l2p2)
    local l1p1x, l1p1y, l1p2x, l1p2y = l1p1.x, l1p1.y, l1p2.x, l1p2.y
    local l2p1x, l2p1y, l2p2x, l2p2y = l2p1.x, l2p1.y, l2p2.x, l2p2.y

    local seg1, seg2 = true, true
    local a1, b1 = l1p2y - l1p1y, l1p1x - l1p2x
    local a2, b2 = l2p2y - l2p1y, l2p1x - l2p2x
    local c1 = a1 * l1p1x + b1 * l1p1y
    local c2 = a2 * l2p1x + b2 * l2p1y

    local det = a1 * b2 - a2 * b1
    if det == 0 then return false, "The lines are parallel." end

    local x = (b2 * c1 - b1 * c2) / det
    local y = (a1 * c2 - a2 * c1) / det

    if seg1 or seg2 then
        local min, max = math.min, math.max
        if (seg1 and not (min(l1p1x, l1p2x) <= x and x <= max(l1p1x, l1p2x) and
                          min(l1p1y, l1p2y) <= y and y <= max(l1p1y, l1p2y))) or
           (seg2 and not (min(l2p1x, l2p2x) <= x and x <= max(l2p1x, l2p2x) and
                          min(l2p1y, l2p2y) <= y and y <= max(l2p1y, l2p2y))) then
            return false, "The lines don't intersect."
        end
    end

    return x, y
end


local function createPolyAltiHelico(unitHelico, hHover)
	-- print("AtoRouteG A unitHelico "..unitHelico.." hHover "..hHover)

	local tempAlti = {}
	for mapName, layers in pairs(AltitudeFloor) do
		-- print("AtoRouteG B mapName "..mapName)

		if string.lower(mapName) == string.lower(mission.theatre) then
			for alti, layer in pairs(layers) do
				-- print("AtoRouteG C alti "..alti)

				if alti >= hHover then
					-- print("AtoRouteG D mapY "..tostring(layer[1].mapY))

					--structure relevant des dessins de ligne de l editeur de mission
					if layer[1].mapY then
						for PolyN = 1, #layer do

							if layer[PolyN] and layer[PolyN].mapX then
								for pointN, point in ipairs(layer[PolyN].points) do

									-- print("AtoRouteG E mapY "..tostring(layer[1].mapY))

									if not tempAlti[PolyN] then tempAlti[PolyN] = {} end

									tempAlti[PolyN][pointN] = {
										x = point.x + layer[PolyN].mapX,
										y = point.y + layer[PolyN].mapY,
									}

								end
							else
								tempAlti[#tempAlti + 1 ] = layer
							end
						end
					--structure épuré, issue d un plan de vol, avec un seul polygone
					else
						tempAlti[1] = layer
					end

				end
			end
		end
	end

	if not AltiHelicoMap[unitHelico] then AltiHelicoMap[unitHelico] = {} end
	if not AltiHelicoMap[unitHelico][hHover] then AltiHelicoMap[unitHelico][hHover] = {} end

	AltiHelicoMap[unitHelico][hHover] = tempAlti

	-- local camp_str = "AltiHelicoMap = " .. TableSerialization(AltiHelicoMap[unitHelico], 0)						--make a string
	-- local campFile = io.open("Debug/AltiHelicoMap_AtoGenerator_"..unitHelico..".lua", "w")										--open targetlist file
	-- campFile:write(camp_str)																		--save new data
	-- campFile:close()

end

function GetRoute(basePoint, target, profile, enemy, task, time, multipackn, multipackmax, unit, idDraftPackage)							--enemy: "blue" or "red"; time: "day" or "night" -- Miguel21 modification M06 : helicoptere playable (ajout variable helico)

	local i_timmer01 = 0
	local route = {}																									--table to store the route to be built
	local route_axis = GetHeading(target, basePoint)																--axis base-target
	local standoff																										--standoff distance of attack WP from target

	local is_helicopter = false
	if IsHelicopter[unit.type]  then
		is_helicopter = true
	end

	if not AltiHelicoMap[unit.type] then
		if is_helicopter then
			if IsHelicopter[unit.type] and IsHelicopter[unit.type]["hHover"] then
				createPolyAltiHelico(unit.type, IsHelicopter[unit.type].hHover)
			else
				createPolyAltiHelico(unit.type, 1500)
			end
		end
	end

	local before = os.clock()

	--function to return radar horizon
	local function RadarHorizon(h1, h2)
		local r = 8500000																										--radius of earth (actual value 6371000 currected for refraction of radio waves)
		local d1 = math.sqrt(math.pow(r + h1, 2) - math.pow(r, 2))															--distance from radar height to earth tangent point
		local d2 = math.sqrt(math.pow(r + h2, 2) - math.pow(r, 2))															--distance from target altitude to earth tangent point
		local alpha1 = math.deg(math.atan(d1 / r))																			--angle between radar and earth tangent point
		local alpha2 = math.deg(math.atan(d2 / r))																			--angle beteen target and earth tangent point
		local u1 = 2 * r * math.pi / 360 * alpha1																				--ground distance from radar to earth tangent point
		local u2 = 2 * r * math.pi / 360 * alpha2																				--ground distance from target to earth tangent point
		return u1 + u2																									--return total ground distance from radar to target
	end


	--local threat table adjusted for cruise and attack altitudes
	local threat_table = {
		ground = {},
		ewr = {},
	}

	--M28 les helicoptere peuvent voir toutes les d�fense, meme celles hidden
	-- local HiddenCheck = true																						-- l'avion vole haut et vite et ne voit pas les menaces
	-- if helicopter then HiddenCheck = true end																		-- l'helicoptere vole bas et voit les menaces, meme cach�
	threat_table.ground[profile.hCruise] = {}
	threat_table.ground[profile.hAttack] = {}
	for threat_n,threat in pairs(groundthreats[enemy]) do																--iterate through ground threats
		if (time == "day" or threat.night == true) and (not threat.hidden or is_helicopter)  then							--and threat.hidden == HiddenCheck										--during day or threat is night capable to be counted as threat
			local threatentry = {
				class = threat.class,
				SEAD_offset = threat.SEAD_offset,
				x = threat.x,
				y = threat.y,
				range = threat.range,
				type = threat.type,
			}
			if threat.min_alt <= profile.hCruise and threat.max_alt >= profile.hCruise then								--threat covers cruise alt
				local maxrange = RadarHorizon(threat.elevation, profile.hCruise + 100)									--get the maximal range due to radar horizon (profile alt +100 m for safety)
				if maxrange < threat.range then																			--maximal range due to radar horizon is smaller than threat range
					threatentry.range = maxrange																		--use maximal range due to radar horizon
				end
				if profile.hCruise <= 100 then																			--if alt is lower than 100m
					threatentry.level = threat.level / 2																--only 50% of threat level is applied as low level clutter bonus
				else																									--alt is higher than 100m
					threatentry.level = threat.level																	--full threat level is applied
				end
				table.insert(threat_table.ground[profile.hCruise], threatentry)
			end
			if profile.hCruise ~= profile.hAttack then																	--attack alt is different than cruise alt
				if threat.min_alt <= profile.hAttack and threat.max_alt >= profile.hAttack then							--threat covers attack alt		
					threatentry.range = threat.range
					local maxrange = RadarHorizon(threat.elevation, profile.hAttack + 100)								--get the maximal range due to radar horizon (profile alt +100 m for safety)
					if maxrange < threat.range then																		--maximal range due to radar horizon is smaller than threat range
						threatentry.range = maxrange																	--use maximal range due to radar horizon
					end
					if profile.hAttack <= 100 then																		--if alt is lower than 100m
						threatentry.level = threat.level / 2															--only 50% of threat level is applied as low level clutter bonus
					else																								--alt is higher than 100m
						threatentry.level = threat.level																--full threat level is applied
					end
					table.insert(threat_table.ground[profile.hAttack], threatentry)
				end
			end
		end
	end

	threat_table.ewr[profile.hCruise] = {}
	threat_table.ewr[profile.hAttack] = {}
	for threat_n,threat in pairs(ewr[enemy]) do																			--iterate through ewr threats
		local cruisethreatentry = {
			class = threat.class,
			x = threat.x,
			y = threat.y,
			range = threat.range,
		}
		if threat.min_alt <= profile.hCruise and threat.max_alt >= profile.hCruise then									--threat covers cruise alt
			local maxrange = RadarHorizon(threat.elevation, profile.hCruise + 100)										--get the maximal range due to radar horizon (profile alt +100 m for safety)
			if maxrange < threat.range then																				--maximal range due to radar horizon is smaller than threat range
				cruisethreatentry.range = maxrange																			--use maximal range due to radar horizon
			end
			table.insert(threat_table.ewr[profile.hCruise], cruisethreatentry)
		end
		local attackthreatentry = {
			class = threat.class,
			x = threat.x,
			y = threat.y,
			range = threat.range,
		}
		if threat.min_alt <= profile.hAttack and threat.max_alt >= profile.hAttack then									--threat covers attack alt		
			local maxrange = RadarHorizon(threat.elevation, profile.hAttack + 100)										--get the maximal range due to radar horizon (profile alt +100 m for safety)
			if maxrange < threat.range then																				--maximal range due to radar horizon is smaller than threat range
				attackthreatentry.range = maxrange																		--use maximal range due to radar horizon
			end
			table.insert(threat_table.ewr[profile.hAttack], attackthreatentry)
		end
	end

	local after = os.clock()
	if debugRoute and after >= before + deltaT  then print() print("|Part 1: "..before.."-"..after.." |") end


	--function to check if a line between two points runs through a threat. Returns a table of threats
	local function ThreatOnLeg(point1, point2, leg_alt)
		local tbl = {}																									--local table to collect threats on route leg
		local before = os.clock()
		local tempB = 0

		--check ground threats
		for t = 1, #threat_table.ground[leg_alt] do																		--iterate through all ground threats
			local threat_route_distance = GetTangentDistance(point1, point2, threat_table.ground[leg_alt][t])			--get closest distance from threat to route between point 1 and point 2
			if threat_route_distance < threat_table.ground[leg_alt][t].range then										--if route passes threat
				table.insert(tbl, threat_table.ground[leg_alt][t])
				local approachfactor = 1 - threat_route_distance / threat_table.ground[leg_alt][t].range				--factor how close route passes to threat (1 = on top)
				tbl[#tbl].approachfactor = approachfactor
			end
		end


		--check EWR threats
		if profile.avoid_EWR then																							--only count EWR asd threats if loadout should avoid them
			for e = 1, #threat_table.ewr[leg_alt] do																		--iterate through all ewr/awacs
				if threat_table.ewr[leg_alt][e].class == "EWR" then															--only do for EWR, ignore AWACS (too large area to avoid)

					local entry = {
						approachfactor = 0
					}

					tempB = #fighterthreats[enemy]
					for t = 1, #fighterthreats[enemy] do																	--iterate through all fighter threats
						local ewr_required																					--boolean whether ewr is required for the fighter to be a threat
						if fighterthreats[enemy][t].class == "CAP" then														--if the fighter is CAP
							if leg_alt >= 3000 then																			--if route leg is at high altitude
								ewr_required = false																		--CAP does not need ewr to be a threat
							else																							--if route leg is at low altitude
								if fighterthreats[enemy][t].LDSD then														--if fighter is look down/shoot down capable
									ewr_required = false																	--CAP does not need ewr to be a threat
								else																						--if fighter is not look down/shoot down capable
									ewr_required = true																		--CAP needs ewr to be a threat
								end
							end
						elseif fighterthreats[enemy][t].class == "Intercept" then											--if the fighter is an interceptor
							ewr_required = true																				--ewr is required for fighter to be a threat (needs early warning to take off)
						end

						if ewr_required == true then																		--EWR stations that can command fighters that require ewr guidance are counted as threats (AWACS and fighter areas are ignored, since these are too large areas to avoid anyway)
							if GetDistance(threat_table.ewr[leg_alt][e], fighterthreats[enemy][t]) < threat_table.ewr[leg_alt][e].range + fighterthreats[enemy][t].range then	--if fighterthreats and ewr are overlapping
								if GetTangentDistance(point1, point2, fighterthreats[enemy][t]) < fighterthreats[enemy][t].range then								--if route leg is in range of fighterthreat
									if GetTangentDistance(point1, point2, threat_table.ewr[leg_alt][e]) < threat_table.ewr[leg_alt][e].range then					--if route leg is in range of ewr
										local approachfactor = 1 - GetTangentDistance(point1, point2, threat_table.ewr[leg_alt][e]) / threat_table.ewr[leg_alt][e].range		--factor how close route passes to threat (1 = on top)
										if approachfactor > entry.approachfactor then										--approach factor is higher than current entry for this ewr
											entry = threat_table.ewr[leg_alt][e]											--make this ewr the entry
											entry.level = fighterthreats[enemy][t].level									--capability level of fighter becomes new threat level of EWR station
											entry.approachfactor = approachfactor											--factor how close route passes to threat (1 = on top)
										end
									end
								end
							end
						end
					end

					if entry.approachfactor > 0 then																		--if an approach factor for this ewr was found
						table.insert(tbl, entry)																			--save ewr station as threat on this leg
					end
				end
			end
		end
		local after = os.clock()
		if debugRoute and after >= before + deltaT  then print() print("|ThreatOnLeg: "..before.."-"..after.." |#fighterthreats "..tempB) end

		return tbl
	end


	--function to define a set of nav points to make a route between two points that evades threats
	local function FindPath(from, to)

		i_timmer01 = i_timmer01 +1
		local FindPathLegTable = {}																									--table to store the the FindPathLeg functions for execution
		local NavRoutes = {}																										--table to temporary store all possible nav routes
		local direct_distance = GetDistance(from, to)																				--distance of direct path between start and end of route
		local no_threat_route = {}																									--to collect route branches that found a no threat route in order to cancel other arms of that branch

		local berfor = os.clock()
		local afterInterB = os.clock()

		local function FindPathLeg(point1, point2, pointEnd, distance, route, instance, leg_alt)									--find a route between point1 and point2		



			local afterInter = os.clock()
			if debugRoute and  afterInter >= berfor + 0.10  then print() print("|FindPath D: "..afterInter - berfor.." |") end

			instance = instance + 1																									--increase instance of the function

			local freeRouteX, freeRouteY
			local createRoute = false
			-- local seg1, seg2 = true, true
			local tooHighReliefB = false
			-- if unit.helicopter then
			if is_helicopter then
				for Npoly, poly in ipairs(AltiHelicoMap) do
					for n = 1 , #poly - 1 do
						freeRouteX, freeRouteY = findIntersect(point1, point2, poly[n], poly[n+1])
						if freeRouteX then
							tooHighReliefB = true
							break
						end
					end
					if tooHighReliefB then break end
				end
			end

			-- local freeRouteX, freeRouteY = false, false
			-- local createRoute = false
			-- local tooHighReliefB = false

			-- if is_helicopter then
			-- 	for Npoly, poly in ipairs(AltiHelicoMap) do
			-- 		for n = 1, #poly - 1 do
			-- 			local intersectX, intersectY = findIntersect(point1, point2, poly[n], poly[n+1])
			-- 			if intersectX then
			-- 				freeRouteX, freeRouteY = intersectX, intersectY
			-- 				tooHighReliefB = true
			-- 				break
			-- 			end
			-- 		end
			-- 		if tooHighReliefB then break end
			-- 	end
			-- end


			--also try a low variant
			if instance == 1 and leg_alt > profile.hAttack and not tooHighReliefB  then	--and not tooHighReliefB																	--in first instance also make a low level route if attack alt is lower than cruise alt
				-- table.insert(FindPathLegTable, {point1, point2, pointEnd, distance + 1, route, instance - 1, profile.hAttack})		--try leg again low (do not increase instance), increase distance slighly to introduce a bias against going low compared to the identical route high
					FindPathLegTable[#FindPathLegTable+1] = {point1, point2, pointEnd, distance + 1, route, instance - 1, profile.hAttack}
			end

			--abort unneeded pathfing after a valid route has been found
			if no_threat_route[leg_alt] and instance > no_threat_route[leg_alt] and not tooHighReliefB then												--if a no threat route has been found for this altitue, stop subsequent route branches(parallel instances of the no threat route are still checked as they might be shorter)
				return																												--stop this route branch
			end

			local distance_remain = GetDistance(point1, pointEnd)																	--remaining distance to end
			local threat = ThreatOnLeg(point1, point2, leg_alt)																		--get the threat between point1 and point2

			--save the current route variant directly to end before trying to refine it further
			local threatsum = 0																										--sum of threats from current point1 to end
			if point2 == pointEnd then																								--if point2 is the pointEnd
				for t = 1, #threat do
					threatsum = threatsum + threat[t].approachfactor																--sum the factors of each threat (1 = on top, 0 = tangential)
				end
			else
				local threat2 = ThreatOnLeg(point1, pointEnd, leg_alt)																--get the threat between point1 and pointEnd
				for t = 1, #threat2 do
					threatsum = threatsum + threat2[t].approachfactor																--sum the factors of each threat (1 = on top, 0 = tangential)
				end
			end

			if not tooHighReliefB then
				-- table.insert(NavRoutes, {navpoints = route, dist = distance + distance_remain, threats = threatsum})					--save route variant directly to end from current route branch
				NavRoutes[#NavRoutes+1] = {navpoints = route, dist = distance + distance_remain, threats = threatsum}
			end

			if threatsum == 0 and not tooHighReliefB then																									--there are no threats to end (also no unavoidable threats)
				return																											--abort this route branch
			end

			--ignore threats that directly cover point1 or pointEnd
			for t = #threat, 1, -1 do																								--iterate through threats from back to front
				if GetDistance(point1, threat[t]) <= threat[t].range or GetDistance(pointEnd, threat[t]) <= threat[t].range then	--if threat is in range of point1 or pointEnd it cannot be avoided and must be ignored
					table.remove(threat, t)																							--remove threat
				end
			end

			if instance > 7 then																									--if function instance is bigger than 7
				return																												--abort this route branch
			elseif distance + distance_remain > (direct_distance * 3.5) then														--if total route distance is bigger than 1.5 times the direct distance
				return																												--abort this route branch
			-- elseif #threat == 0 and tooHighReliefB  then
			elseif #threat == 0 and not tooHighReliefB then	--and not is_helicopter 																								--if no more threats on remaining route
				if point2 == pointEnd and not tooHighReliefB then																							--if point2 is the pointEnd
					no_threat_route[leg_alt] = instance																				--variable that will cancel subsequent route finding at this altitude (parallel branches of the same instance are still being checked)
					return 																										--abort further route finding
				elseif not tooHighReliefB then																												--if point2 is not the end
					distance = distance + GetDistance(point1, point2)																--complete route distance of this variant up to point2
					-- table.insert(route, point2)																						--add point2 to route
					route[#route+1] =  point2
					-- table.insert(FindPathLegTable, {point2, pointEnd, pointEnd, distance, route, instance, leg_alt})				--continue find route from point2 to end
					FindPathLegTable[#FindPathLegTable+1] = {point2, pointEnd, pointEnd, distance, route, instance, leg_alt}
				end

			elseif #threat > 0 and not tooHighReliefB then																													--if there is a threat on leg			
				--find left/right side alternates around threat
				local point1_point2_heading = GetHeading(point1, point2)														--get heading from point1 to point2
				for s = 1, -1, -2 do																							--repeat twice for left and right side
					local point2alt = GetOffsetPoint(threat[1], point1_point2_heading + (s * 90), threat[1].range * 4/3)		--get alternate point2 on left/right side of current threat (1/3 out of threat range)

					local tooHighReliefC = false
					if is_helicopter then
						for Npoly, poly in ipairs(AltiHelicoMap) do
							for n = 1 , #poly - 1 do
								local freeRouteC = findIntersect(point1, point2alt, poly[n], poly[n+1])
								if freeRouteC then
									tooHighReliefC = true
									break
								end
							end
							if tooHighReliefC then break end
						end
					end

					local threat_leg = ThreatOnLeg(point1, point2alt, leg_alt)													--get threat between point1 and alternate point2

					--ignore threats that point1 is already in
					for t = #threat_leg, 1, -1 do																				--iterate through threats from back to front
						if GetDistance(point1, threat_leg[t]) <= threat_leg[t].range or GetDistance(pointEnd, threat_leg[t]) <= threat_leg[t].range then	--if threat is in range of point1 or pointEnd it cannot be avoided and must be ignored
							table.remove(threat_leg, t)																			--remove threat
						end
					end

					if not tooHighReliefC then
						if #threat_leg == 0 then																					--if there is no threat between point 1 and alternate point2
							local distance_alt = distance + GetDistance(point1, point2alt)											--complete route distance of this variant up to point2alt
							local route_alt = {}																					--make a local copy of the route up to now
							for k, v in pairs(route) do
								route_alt[k] = {
									x = v.x,
									y = v.y,
								}
							end
							-- table.insert(route_alt, point2alt)																		--add point2alt to this route variant
							route_alt[#route_alt+1] =  point2alt
							-- table.insert(FindPathLegTable, {point2alt, pointEnd, pointEnd, distance_alt, route_alt, instance, leg_alt})	--continue route from point2alt
							FindPathLegTable[#FindPathLegTable+1] = {point2alt, pointEnd, pointEnd, distance_alt, route_alt, instance, leg_alt}
						else																										--if there is a threat between point1 and point2alt
							-- table.insert(FindPathLegTable, {point1, point2alt, pointEnd, distance, route, instance, leg_alt})		--find new route to point2alt
							FindPathLegTable[#FindPathLegTable+1] = {point1, point2alt, pointEnd, distance, route, instance, leg_alt}
						end
					end
				end

				local afterInter = os.clock()
				if debugRoute and  afterInter >= afterInterB + deltaT  then print() print("|FindPathLeg B not tooHighReliefB: "..afterInter - afterInterB.." |") end
				local afterInterB = os.clock()

			elseif tooHighReliefB == true and freeRouteX then
				--find left/right side alternates around threat
				local point1_point2_heading = GetHeading(point1, point2)														--get heading from point1 to point2
				local fx, fy = freeRouteX, freeRouteY
				for n=1, 1 do
					for s = 1, -1, -2 do																							--repeat twice for left and right side
						local point2alt = GetOffsetPoint({x=fx, y=fy}, point1_point2_heading + (s * 90), 50000 * n)		--get alternate point2 on left/right side of current threat (1/3 out of threat range)

						local testX, testY
						local tooHighReliefC2 = false
						if is_helicopter then
							for Npoly, poly in ipairs(AltiHelicoMap) do
								for p = 1 , #poly - 1 do
									testX, testY = findIntersect(point1, point2alt, poly[p], poly[p+1])
									if testX then
										tooHighReliefC2 = true
										fx, fy = testX, testY
										break
									end
								end
								if tooHighReliefC2 then break end
							end
						end

						if not tooHighReliefC2 then																					--if there is no threat between point 1 and alternate point2
						-- 	if is_helicopter then print("AtoRG CCC2 ba passe instance "..instance) end

						-- 	local distance_alt = distance + GetDistance(point1, point2alt)											--complete route distance of this variant up to point2alt
						-- 	local route_alt = {}																					--make a local copy of the route up to now
						-- 	for k, v in pairs(route) do
						-- 		route_alt[k] = {
						-- 			x = v.x,
						-- 			y = v.y,
						-- 		}
						-- 	end
						-- 	table.insert(route_alt, point2alt)																		--add point2alt to this route variant
						-- 	table.insert(FindPathLegTable, {point2alt, pointEnd, pointEnd, distance_alt, route_alt, instance, leg_alt})	--continue route from point2alt
						-- else																										--if there is a threat between point1 and point2alt
							-- if is_helicopter then print("AtoRG CCC2 bb passe instance "..instance) end


							-- table.insert(FindPathLegTable, {point1, point2alt, pointEnd, distance, route, instance, leg_alt})		--find new route to point2alt
							FindPathLegTable[#FindPathLegTable+1] = {point1, point2alt, pointEnd, distance, route, instance, leg_alt}

						end

					end
				end
			end

			if is_helicopter and  #FindPathLegTable == 1 then
				local test = {																						--local table to store the currently selected optimal route
				routeImpossible = true,
				}

				return test
			end

		end		--function FindPathLeg()

		table.insert(FindPathLegTable, {from, to, to, 0, {}, 0, profile.hCruise})									--insert first instance of FindPathLeg to find a route between start and end point. arguments: start, end, final end (same), initial route distance 0, initial route empty {}, initial instance of the function 0, cruise alt

		for num,arg in ipairs(FindPathLegTable) do																	--go through table of FindPathLegt functions and execute them. Each FindPathLegt functions can add more instances of same function for execution at end of table
			i_timmer01 = i_timmer01 +1
			if is_helicopter then
				--  print("AtoRG BOUCLE FOR C "..tostring(num))
			end

			local result = FindPathLeg(arg[1], arg[2], arg[3], arg[4], arg[5], arg[6], arg[7])										--Execute function with the stored arguments				

			if is_helicopter and result and result.routeImpossible then
				return result
			end
		end

		-- if #FindPathLegTable > 100 then
		-- 	print("AtoRG #FindPathLegTable "..#FindPathLegTable)
		-- end
		--Determine best nav route from NavRoutes table
		local temp_route = {																						--local table to store the currently selected optimal route
			navpoints = {},
			dist = GetDistance(from, to)
		}

		if #NavRoutes == 0 then
			return temp_route
		else
			for n = 1, #NavRoutes do																				--Go through all stored routes
				if n == 1 then
					temp_route = NavRoutes[n]																		--make first route the temp route
				else
					if NavRoutes[n].threats < temp_route.threats or (NavRoutes[n].threats == temp_route.threats and NavRoutes[n].dist < temp_route.dist) then	--if next route has either less threats or the same threats and shorter distance, make this the current temp route
						temp_route = NavRoutes[n]
					end
				end
			end
			return temp_route																						--return the selected route
		end

	end	--function FindPath(from, to)


	----- find a route depending on task -----
	if task == "Strike" or task == "Anti-ship Strike" or task == "Reconnaissance" or task == "CSAR" or task == "Runway Attack" then
		local before = os.clock()
		--set Initial Point IP
		local initialPoint = {}																				--initial point

		local base_target_route = FindPath(basePoint, target)											--find the safest route between basePoint and target

		if task == "CSAR" and is_helicopter   then
			if base_target_route.routeImpossible  then
				return false
			else
				-- print("AtoRG AAAA base_target_route ROUTE crée ****************")		
				-- os.execute 'pause'
			end

		end

		local ideal_axis																					--ideal axis of the IP
		-- if base_target_route and base_target_route.navpoints then	
			if #base_target_route.navpoints == 0 then															--if there are no navpoints
				ideal_axis = route_axis																			--ideal IP is on base-target axis
			else																								--if there are navpoints
				ideal_axis = GetHeading(target, base_target_route.navpoints[#base_target_route.navpoints])	--ideal IP is on target-last navpoint axis
			end
		-- end
		if profile.standoff then																			--if standoff defined in loadout profile
			standoff = profile.standoff																		--use value from loadout profile
		else																								--if no standoff defined in loadout profile
			standoff = profile.hAttack + profile.vAttack * 30												--standoff distance is attack alt plus 30 seconds at attack speed
			if is_helicopter then
				if task == "SAR" or task == "CSAR" then
					standoff = 0
				end
			elseif standoff < 7000 then																			--standoff should be at least 7000m
				standoff = 7000
			end
		end

		do
			local IP_distance = standoff + profile.vAttack * 60												--distance target-IP is standoff range from profile + 60 seconds run in at attack speed
			if profile.ingress then																			--ingress distance is defined in loadout
				IP_distance = standoff + profile.ingress
			end
			local IP_table = {}																				--table to store all possible IPs

			local MaxAttackOffset = 90
			if profile.MaxAttackOffset then
				MaxAttackOffset = profile.MaxAttackOffset
			end

			local heading_min = ideal_axis - MaxAttackOffset												--lowest heading from target to IP
			local heading_max = ideal_axis + MaxAttackOffset												--highest heading from target to IP
			if multipackmax > 1 then																		--if this is part of a multi package attack
				ideal_axis = heading_min + (multipackn - 1) / (multipackmax - 1) * (MaxAttackOffset * 2)	--distribute ideal axis evenly across maximal left/right offset depending on package number
			end

			local afterInterAa = os.clock()

			for n = 0, 180, 5 do	--5		--10																--find IP by evaluating threat level for IPs between heading min and heading max in 5� steps
				if initialPoint.x then																		--break loop if an IP is set																
					break
				else
					for m = 1, -1, -2 do																		--try left and right option for each offset from ideal axis (*1, *-1)
						local IP_heading = ideal_axis + (n * m)													--current IP heading to consider
						if (IP_heading >= heading_min and IP_heading <= heading_max) or task == "CSAR" then							--IP heading must be within min and max offsets
							local draft_IP = GetOffsetPoint(target, IP_heading, IP_distance)				--draft IP for current offset
							local draft_attackPoint = target
							if standoff > 15000 then															--if standoff range is more than 15'000m, assume target will not be overflown.
								draft_attackPoint = GetOffsetPoint(target, IP_heading, standoff)			--draft attack point
							end
							local threat = ThreatOnLeg(draft_IP, draft_attackPoint, profile.hAttack)			--all threats between draft IP and draft attack point

							if  debugRoute then io.write(" "..#threat.." ") end

							local total_threat_level = 0														--cumulated threat level for this leg
							local EWRpenality = false
							for t = 1, #threat do																--iterate through all threats on this option				
								i_timmer01 = i_timmer01 +1

								if threat[t].class == "EWR" then												--threat is an EWR
									if EWRpenality == false then												--threat is the first EWR encountered
										total_threat_level = total_threat_level + 0.1							--add a small threat level once if there are any EWR encountered betwen draft IP and draft attack point (this means there will be a small bias for IPs that are not under any EWR, but multiple EWR will not affect IP direction).
										EWRpenality = true														--mark that the threat penality for one EWR has been marked 
									end
								else
									local closest_approach = GetTangentDistance(draft_IP, draft_attackPoint, threat[t])	--closest approach distance to threat
									local closest_approach_factor = 1 - closest_approach / threat[t].range		--factor how close threat is approached (1 = on top, 0 not at all)
									local lenght_in_threat = GetTangentLenght(draft_IP, draft_attackPoint, threat[t], threat[t].range)	--distance that is traveled within threat range
									local threat_level = threat[t].level * (lenght_in_threat / (threat[t].range * 2)) * closest_approach_factor --threat level for this indiviudal threat (path lenght in threat circle compared to threat diameter * approach factor)
									total_threat_level = total_threat_level + threat_level						--sum all threat levels to total threat level
								end
							end

							local tooHighReliefD = false
							if is_helicopter then
								for Npoly, poly in ipairs(AltiHelicoMap) do
									for n = 1 , #poly - 1 do
										local freeRoute = findIntersect(target, draft_IP, poly[n], poly[n+1])
										if freeRoute then
											tooHighReliefD = true
											-- print("AtoRG Baa freeRoute BREAK "..tostring(freeRoute))
											break
										end
									end
									if tooHighReliefD then break end
								end
							end


							if total_threat_level == 0 and not tooHighReliefD then														--if there is no threat, make this the IP and stop evaluation
								initialPoint = draft_IP
								break
							elseif not tooHighReliefD then																				--if there are threats
								table.insert(IP_table, {point = draft_IP, threat = total_threat_level})			--store current draft IP in IP table
							end
						end
					end
				end
			end

			local afterInter = os.clock()
			if  debugRoute and afterInter >= afterInterAa + deltaT  then print() print("|Strike IPa: "..afterInter - afterInterAa.." |") end
			local afterInterBa = os.clock()


			if initialPoint.x == nil then																	--if IP is not yet set, find the best from IP table
				local current_threat = 1000000
				for n = 1, #IP_table do																		--iterate through all draft IPs to find to one with the lowest threat level
					local roundedThreat = math.floor(IP_table[n].threat * 10000000000) / 10000000000		--round threat value to remove rounding errors
					if roundedThreat < current_threat then													--if this draft IP has a lower threat level than the IP currently set
						initialPoint = IP_table[n].point													--make it the new IP
						current_threat = roundedThreat														--this is the threat level of the currently set IP					
					end
				end
			end
		end

		local afterInter = os.clock()
		local afterInterB = os.clock()
		if  debugRoute and afterInter >= before + deltaT  then print() print("|Strike IPb: "..afterInter - before.." |") end

		--set attack point
		local target_ip_heading = GetHeading(target, initialPoint)
		local attackPoint = GetOffsetPoint(target, target_ip_heading, standoff)						--attack point is standoff range from target on straight IP-target line

		--set egress point
		local egressPoint = {}																				--egress point
		do
			local egress_point_start																		--point from where egress is initiated (target or attack point depending on standoff profile)
			local egress_table = {}
			local egress_distance = standoff + profile.vAttack * 90											--egress point is standoff range from target plus 90 seconds run out at attack speed
			if profile.egress then																			--egress distance is defined in loadout
				egress_distance = standoff + profile.egress
			end
			local egress_heading

			if task == "Strike" or task == "Anti-ship Strike" or task == "Runway Attack" then
				local afterInterAb = os.clock()

				if standoff <= 15000 then																		--if standoff range is 15'000m or less, assume target will be overflown. Optimal egress should be 90� offset from ingress in direction of RTB
					egress_point_start = target															--egress starts from target

					if GetDeltaHeading(route_axis, target_ip_heading) > 0 then									--homebase is on left side of ingress heading
						egress_heading = target_ip_heading + 90													--optimal egress heading is 90� to left
					else																						--homebase is on right side of ingress heading
						egress_heading = target_ip_heading - 90													--optimal egress heading is 90� to right
					end
				else																							--if standoff range is bigger than 15'000m, optimal egrees should be in direction of home base
					egress_point_start = attackPoint															--egress starts from attack point
					egress_distance = profile.vAttack * 90														--egress distance for stand off attacks is 90 seconds run out at attack speed
					if profile.egress then																		--egress distance is defined in loadout
						egress_distance = profile.egress
					end
					egress_heading = GetHeading(attackPoint, basePoint)											--direct egress from attack point
				end

				for n = 0, 180, 5 do	--5	--10																	--find egress point by evaluating threat level for egress between egress heading and +/- 135� offset in 5� steps
					if egressPoint.x then																		--break loop if an egress point is set																
						break
					else
						for m = 1, -1, -2 do																	--try left and right option for each offset from egress heading (*1, *-1)
							i_timmer01 = i_timmer01 +1
							if GetDeltaHeading(egress_heading + n * m, target_ip_heading) >= 15 or GetDeltaHeading(egress_heading + n * m, target_ip_heading) <= -15 then	--valid egresses must be at least 15� offset from ingress
								local draft_egress = GetOffsetPoint(egress_point_start, egress_heading + n * m, egress_distance)	--draft egress for current offset
								local threat = ThreatOnLeg(egress_point_start, draft_egress, profile.hAttack)		--all threats between attack point and draft egress point
								local total_threat_level = 0														--cumulated threat level for this leg
								local EWRpenality = false
								for t = 1, #threat do																--iterate through all threats on this option				
									if threat[t].class == "EWR" then												--threat is an EWR
										if EWRpenality == false then												--threat is the first EWR encountered
											total_threat_level = total_threat_level + 0.1							--add a small threat level once if there are any EWR encountered betwen attack point and draft egress point (this means there will be a small bias for IPs that are not under any EWR, but multiple EWR will not affect IP direction).
											EWRpenality = true														--mark that the threat penality for one EWR has been marked 
										end
									else
										local closest_approach = GetTangentDistance(egress_point_start, draft_egress, threat[t])	--closest approach distance to threat
										local closest_approach_factor = 1 - closest_approach / threat[t].range		--factor how close threat is approached (1 = on top, 0 not at all)
										local lenght_in_threat = GetTangentLenght(egress_point_start, draft_egress, threat[t], threat[t].range)	--distance that is traveled within threat range
										local threat_level = threat[t].level * (lenght_in_threat / (threat[t].range * 2)) * closest_approach_factor --threat level for this indiviudal threat (path lenght in threat circle compared to threat diameter * approach factor)
										total_threat_level = total_threat_level + threat_level						--sum all threat levels to total threat level
									end
								end
								if total_threat_level == 0 then														--if there is no threat, make this the egress point and stop evaluation
									egressPoint = draft_egress
									break
								else
									table.insert(egress_table, {point = draft_egress, threat = total_threat_level})	--store current draft egress in egress table
								end
							end
						end
					end
				end

				local afterInter = os.clock()
				if  debugRoute and afterInter >= afterInterAb + deltaT  then print() print("|Strike Egress: "..afterInter - afterInterAb.." |") end
				local afterInterBb = os.clock()



			elseif task == "Reconnaissance"  then																	--for recon missions
				local afterInterAb = os.clock()
				egress_heading = GetHeading(initialPoint, target)
				for n = 0, 30, 5 do																					--find egress point by evaluating threat level for egress between egress heading and +/- 30� offset in 5� steps
					if egressPoint.x then																			--break loop if an egress point is set																
						break
					else
						for m = 1, -1, -2 do																		--try left and right option for each offset from egress heading (*1, *-1)
							local draft_egress = GetOffsetPoint(target, egress_heading + n * m, egress_distance)	--draft egress for current offset
							local threat = ThreatOnLeg(target, draft_egress, profile.hAttack)					--all threats between target point and draft egress point
							local total_threat_level = 0															--cumulated threat level for this leg
							local EWRpenality = false
							for t = 1, #threat do																--iterate through all threats on this option				
								if threat[t].class == "EWR" then												--threat is an EWR
									if EWRpenality == false then												--threat is the first EWR encountered
										total_threat_level = total_threat_level + 0.1							--add a small threat level once if there are any EWR encountered betwen attack point and draft egress point (this means there will be a small bias for IPs that are not under any EWR, but multiple EWR will not affect IP direction).
										EWRpenality = true														--mark that the threat penality for one EWR has been marked 
									end
								else
									local threat_level = GetTangentLenght(target, draft_egress, threat[t], threat[t].range) / (threat[t].range * 2) * threat[t].level		--threat level for this indiviudal threat (path lenght in threat circle compared to threat diameter)
									total_threat_level = total_threat_level + threat_level							--sum all threat levels to total threat level
								end
							end
							if total_threat_level == 0 then															--if there is no threat, make this the egress point and stop evaluation
								egressPoint = draft_egress
								break
							else
								table.insert(egress_table, {point = draft_egress, threat = total_threat_level})		--store current draft IP in IP table
							end
						end
					end
				end

			local afterInter = os.clock()
			if  debugRoute and afterInter >= afterInterAb + deltaT  then print() print("|Reconnaissance: "..afterInter - afterInterAb.." |") end

			elseif  task == "CSAR" then																	--for recon missions
				local afterInterAb = os.clock()
				egress_distance = 0
				egress_heading = GetHeading(initialPoint, target)
				for n = 0, 30, 5 do																					--find egress point by evaluating threat level for egress between egress heading and +/- 30� offset in 5� steps
					if egressPoint.x then																			--break loop if an egress point is set																
						break
					else
						for m = 1, -1, -2 do																		--try left and right option for each offset from egress heading (*1, *-1)
							local draft_egress = GetOffsetPoint(target, egress_heading + n * m, egress_distance)	--draft egress for current offset
							local threat = ThreatOnLeg(target, draft_egress, profile.hAttack)					--all threats between target point and draft egress point
							local total_threat_level = 0															--cumulated threat level for this leg
							local EWRpenality = false
							for t = 1, #threat do																--iterate through all threats on this option				
								if threat[t].class == "EWR" then												--threat is an EWR
									if EWRpenality == false then												--threat is the first EWR encountered
										total_threat_level = total_threat_level + 0.1							--add a small threat level once if there are any EWR encountered betwen attack point and draft egress point (this means there will be a small bias for IPs that are not under any EWR, but multiple EWR will not affect IP direction).
										EWRpenality = true														--mark that the threat penality for one EWR has been marked 
									end
								else
									local threat_level = GetTangentLenght(target, draft_egress, threat[t], threat[t].range) / (threat[t].range * 2) * threat[t].level		--threat level for this indiviudal threat (path lenght in threat circle compared to threat diameter)
									total_threat_level = total_threat_level + threat_level							--sum all threat levels to total threat level
								end
							end
							if total_threat_level == 0 then															--if there is no threat, make this the egress point and stop evaluation
								egressPoint = draft_egress
								break
							else
								table.insert(egress_table, {point = draft_egress, threat = total_threat_level})		--store current draft IP in IP table
							end
						end
					end
				end
				local afterInter = os.clock()
				if  debugRoute and afterInter >= afterInterAb + deltaT  then print() print("|CSAR: "..afterInter - afterInterAb.." |") end

			end

			if egressPoint.x == nil then																			--if egress is not yet set, find the best from egress table
				-- if target.name == "EWR-Eyeball" then print("AtoRG PASSE LL egressPoint nil ") end
				local current_threat = 1000000
				for n = 1, #egress_table do																			--iterate through all draft egress points to find to one with the lowest threat level
					if egress_table[n].threat < current_threat then													--if this draft egress has a lower threat level than the egress currently set
						egressPoint = egress_table[n].point															--make it the new egress point
						current_threat = egress_table[n].threat														--this is the threat level of the currently set egress			

						-- if target.name == "EWR-Eyeball" then 
						-- 	local tempHeading = GetHeading(attackPoint, egressPoint)
						-- 	print("AtoRG PASSE MM egressPoint nil tempHeading(attackPoint, egressPoint) "..tempHeading) 
						-- end

					end
				end
			end
		end

		local afterInter = os.clock()
		if  debugRoute and afterInter >= afterInterB + deltaT  then print() print("|Egress b: "..afterInter - afterInterB.." |") end
		local afterInterB = os.clock()

		--set outbound and inbound routes
		local outbound_navRoute = FindPath(basePoint, initialPoint)														--find the safest route between basePoint and initialPoint


		local afterInter = os.clock()
		if  debugRoute and afterInter >= afterInterB + deltaT  then print() print("|outbound_navRoute: "..afterInter - afterInterB.." |") end
		local afterInterB = os.clock()

		local inbound_navRoute = FindPath(basePoint, egressPoint)														--find the safest route between egressPoint and basePoint


		local afterInter = os.clock()
		if  debugRoute and afterInter >= afterInterB + deltaT  then print() print("|inbound_navRoute: "..afterInter - afterInterB.." |") end
		local afterInterB = os.clock()

		if task == "CSAR" and is_helicopter   then
			if outbound_navRoute.routeImpossible  then
				return false
			else

			end
		end

		--set form-up point
		local joinPoint = {}																							--point where package joins on common flight route
		do
			local point																									--join point is between basePoint and this local point
			if #outbound_navRoute.navpoints == 0 then																	--if there is no outbound nav route
				point = initialPoint																					--point is IP
			else																										--if there is an outbound nav route
				point = outbound_navRoute.navpoints[1]																	--point is first nav point
			end
			local heading = GetHeading(basePoint, point)

			local distance = math.abs((profile.hCruise - basePoint.h) * 10)												--distance to climb from base elevation to cruise altitude with 6� pitch (make sure distance is positive)
			if distance >= GetDistance(basePoint, point) then															--climb distance bigger than distance to first WP
				distance = GetDistance(basePoint, point) / 3 * 2														--join point is 2/3 to first WP
			elseif distance < 15000 then																				--climb distance less than 15 km
				distance = 15000																						--join point should be at least 15 km from base
			end

			joinPoint = GetOffsetPoint(basePoint, heading, distance)													--define join point
		end

		local afterInter = os.clock()
		if  debugRoute and afterInter >= afterInterB + deltaT  then print() print("|Join: "..afterInter - afterInterB.." |") end
		local afterInterB = os.clock()

		--set split point
		local splitPoint = {}																							--point where package splits to land on individual airbases		
		do
			local point																									--split point is between basePoint and this local point
			if #inbound_navRoute.navpoints == 0 then																	--if there is no inbound nav route
				point = egressPoint																						--point is egress point
			else																										--if there is an inbound nav route
				point = inbound_navRoute.navpoints[1]																	--point is first nav point
			end
			local heading = GetHeading(basePoint, point)

			local distance = math.abs((profile.hCruise - basePoint.h) * 4)												--distance to descend from cruise alt to base elevation with 15� pitch (make sure distance is positive)
			if distance >= GetDistance(basePoint, point) then															--descend distance bigger than distance to last WP
				distance = GetDistance(basePoint, point) / 3 * 2														--join point is 2/3 to last WP
			elseif distance < 15000 then																				--descend distance less than 15 km
				distance = 15000																						--split point should be at least 15 km from base
			end

			splitPoint = GetOffsetPoint(basePoint, heading, distance)													--define split point
		end

		--set assemble point
		local assemblyPoint = {}
		do
			local heading = GetHeading(basePoint, joinPoint)
			local distance = assemblePointDistance
			if GetDistance(basePoint, joinPoint) < distance then distance = GetDistance(basePoint, joinPoint) -1000 end
			assemblyPoint = GetOffsetPoint(basePoint, heading, distance)
		end

		local afterInter = os.clock()
		if  debugRoute and afterInter >= afterInterB + deltaT  then print() print("|Split: "..afterInter - afterInterB.." |") end
		local afterInterB = os.clock()

		-- --altitude plus basse pour helicopter -- Miguel21 modification M06 : helicoptere playable 
		-- if is_helicopter then delta_h = 50 else delta_h = 1524 end

		--build complete route if virtual air base, in the AIR ;), Spawn
		-- Miguel21 modification M16.d : SpawnAir B1b & B-52 need BaseAirStart = true in db_aibase
		if basePoint.BaseAirStart == true then
			table.insert(route, {x = basePoint.x, y = basePoint.y, id = "Spawn", alt = profile.hCruise })
			table.insert(route, {x = joinPoint.x, y = joinPoint.y, id = "Join", alt = profile.hCruise, hCruiseREF = profile.hCruiseREF})
		else
			--build complete route
			table.insert(route, {x = basePoint.x, y = basePoint.y, id = "Taxi", alt = basePoint.h})
			table.insert(route, {x = basePoint.x, y = basePoint.y, id = "Departure", alt = basePoint.h })		--+ delta_h
			table.insert(route, {x = assemblyPoint.x, y = assemblyPoint.y, id = "Assemble", alt = profile.hCruise })
			table.insert(route, {x = joinPoint.x, y = joinPoint.y, id = "Join", alt = profile.hCruise , hCruiseREF = profile.hCruiseREF})
		end

		for n = 1, #outbound_navRoute.navpoints do
			table.insert(route, {x = outbound_navRoute.navpoints[n].x, y = outbound_navRoute.navpoints[n].y, id = "Nav", alt = profile.hCruise})
		end

		table.insert(route, {x = initialPoint.x, y = initialPoint.y, id = "IP", alt = profile.hAttack})
		table.insert(route, {x = attackPoint.x, y = attackPoint.y, id = "Attack", alt = profile.hAttack})

		if standoff <= 15000 then																						--if standoff is less than 15 km, then assume target is overflown. For higher standoff, target is only inserted after route lenght and threats are calculated-
			table.insert(route, {x = target.x, y = target.y, id = "Target", alt = profile.hAttack})
		end

		table.insert(route, {x = egressPoint.x, y = egressPoint.y, id = "Egress", alt = profile.hAttack})

		for n = #inbound_navRoute.navpoints, 1, -1 do
			table.insert(route, {x = inbound_navRoute.navpoints[n].x, y = inbound_navRoute.navpoints[n].y, id = "Nav", alt = profile.hCruise})
		end

		table.insert(route, {x = splitPoint.x, y = splitPoint.y, id = "Split", alt = profile.hCruise})
		table.insert(route, {x = basePoint.x, y = basePoint.y, id = "Land", alt = profile.hCruise})


		--set descend and climb points in route
		if profile.hCruise > profile.hAttack then																		--if cruise is higher than attack altitude, a descend and a climb point must be inserted

			--descend point
			for n = 3, #route - 2 do																					--iterate through route between join and split point
				if route[n].alt == profile.hCruise then

					--get high and low threats on route segement
					local threat = {}																					--threats on leg at high alt default to 0 as an earlier change in altitude is of no advantage
					if profile.hAttack < 1000 then																		--if attack alt is at low altitude, collect actual threats to determine descend point on route
						threat = ThreatOnLeg(route[n], route[n + 1], profile.hCruise)									--collect threats on leg at high alt
					end

					--reduce threat range of EWR to areas of fighter threat
					for t = 1, #threat do																				--iterate through threats
						if threat[t].class == "EWR" then																--threat is an EWR
							local newEWRrange = 0																		--reduce EWR range to point where route enters the first fighter threat
							for f = 1, #fighterthreats[enemy] do														--iterate through fighter threats to find the first fighter threat that route enters into
								if GetTangentDistance(route[n], route[n + 1], fighterthreats[enemy][f]) < fighterthreats[enemy][f].range then	--route passes though fighter threat circle
									--find point where route enters fighter circle					
									local heading1 = GetHeading(route[n], route[n + 1])									--route heading
									local heading2 = GetHeading(route[n], fighterthreats[enemy][f])						--heading to center of threat circle
									local alpha = math.abs(heading1 - heading2)											--angle beteen both headings
									if alpha > 180 then
										alpha = math.abs(alpha - 360)
									end
									alpha = math.rad(alpha)
									local a = fighterthreats[enemy][f].range											--radius of threat circle
									local b = GetDistance(route[n], fighterthreats[enemy][f])							--distance to center of threat circle
									local beta = math.asin(b / (a / math.sin(alpha)))									--sinus sentence
									beta = math.pi - beta																--since sinus sentence results in two possible angles for beta and only the second is valid, use the second
									local gamma = math.pi - alpha - beta
									local c = a / math.sin(alpha) * math.sin(gamma)										--distance from WP1 to point intersecting threat circle
									local p = GetOffsetPoint(route[n], heading1, c)										--point where route is intersecting threat circle
									local EWR_p = GetDistance(threat[t], p)												--distance from EWR to this point
									if EWR_p < threat[t].range and EWR_p > newEWRrange then								--find longest new EWR range that is shorter than the original EWR range
										newEWRrange = EWR_p
									end

									local heading_p_t = GetHeading(p, fighterthreats[enemy][f])							--heading from intersection point to fighter threat
									local heading_p_EWR = GetHeading(p, threat[t])										--heading from intersection point to EWR
									local angle = math.abs(heading_p_t - heading_p_EWR)									--angle beteen both headings
									if angle > 180 then
										angle = math.abs(angle - 360)
									end
									if angle > 90 then																	--when angle is bigger then 90																											
										threat[t].invert = true															--the treat circle of EWR is outside of the interception area!
									end

								end
							end
							if newEWRrange > 0 then																		--an adjusted EWR range was determined
								threat[t].range = newEWRrange															--make this the new EWR range
							end
						end
					end

					if #threat == 0 then																				--no threat on route
						if route[n].alt > route[n + 1].alt then															--but route segment is the descend leg
							local descendPoint = {}																		--point to start descend
							local heading = GetHeading(route[n + 1], route[n])											--descend point is on route leg
							local distance = math.abs((profile.hCruise - profile.hAttack)) * 6							--distance to descend is 6 times the altitude difference (~-10� pitch) (make sure is positive)
							if distance < GetDistance(route[n + 1], route[n]) then										--if descend distance is longer than route leg distance, ignore descend point
								descendPoint = GetOffsetPoint(route[n + 1], heading, distance)							--define descend point position
								descendPoint.id = "Nav"
								descendPoint.alt = profile.hCruise
								table.insert(route, n + 1, descendPoint)												--insert into route
							end
							break																						--stop going through waypoints for the descend
						end
					else																								--if there are threats on route leg, make the descend on this route leg
						for m = n, #route do																			--move forward in route and put all subsequent waypoints until IP to low alt
							if route[m + 1] and route[m + 1].alt and route[m + 1].alt == profile.hCruise then													--if next waypoint is still at cruise
								route[m + 1].alt = profile.hAttack														--adjust waypoint alt to attack
							else
								break																					--stop when attack part of route is reached
							end
						end

						local descendPointEnd = {}																		--point where descend must be completed (here the high alt threat is entered)
						local distance = 100000000
						local heading = GetHeading(route[n], route[n + 1])
						for t = 1, #threat do
							local p1_t_heading = GetHeading(route[n], threat[t])
							local alpha = math.abs(heading - p1_t_heading)												--angle beteen route and p1-threat
							if alpha > 180 then
								alpha = math.abs(alpha - 360)
							end
							local p1_t = GetDistance(route[n], threat[t])												--distance between p1 and threat
							local p1_p90t = math.cos(math.rad(alpha)) * p1_t											--distance between p1 and point on route perpendicular to threat
							local p90t_t = p1_t * math.sin(math.rad(alpha))												--distance between threat and point on route perpendicular to threat
							local p90t_pC = math.sqrt(math.pow(threat[t].range, 2) - math.pow(p90t_t, 2))				--distance between point on route perpendiculat to threat and point on route intersecting threat circle
							local p1_pC = p1_p90t - p90t_pC																--distance from p1 to point on route intersecting threat circle
							if p1_pC <= 0 then																			--if point on route intersecting threat circle is ahead of p1
								if threat[t].invert then																--area outside of EWR range is the threat area
									distance = -p1_pC
								else
									distance = 0
									break																				--p1 is already within a threat circle. No descend point is needed, alter p1 to low level instead
								end
							elseif p1_pC < distance then
								distance = p1_pC																		--find the shortest distance to all threat circles (this is the point on route where the decend to low alt must be completed)
							end
						end

						if distance == 0 then																			--descend point is ahead of route[n]
							route[n].alt = profile.hAttack																--set route[n] to low alttude
						else																							--descend point is beyond of route[n]
							descendPointEnd = GetOffsetPoint(route[n], heading, distance)								--define descend point position
							descendPointEnd.id = "Nav"
							descendPointEnd.alt = profile.hAttack
							table.insert(route, n + 1, descendPointEnd)													--insert into route
							local descend_distance = (profile.hCruise - profile.hAttack) * 6							--distance to descend is 6 times the altitude difference (~-10� pitch)
							if descend_distance < distance then
								local descendPointStart = {}															--point where descend starts
								descendPointStart = GetOffsetPoint(route[n], heading, (distance - descend_distance))	--define descend point position
								descendPointStart.id = "Nav"
								descendPointStart.alt = profile.hCruise
								table.insert(route, n + 1, descendPointStart)											--insert into route
							end
						end
						break																							--stop going through waypoints for the descend
					end
				end
			end

			local afterInter = os.clock()
			if  debugRoute and afterInter >= afterInterB + deltaT  then print() print("|Descent: "..afterInter - afterInterB.." |") end
			local afterInterB = os.clock()

			--climb point
			for n = #route - 1, 4, -1 do																				--iterate through route backkwards between split and join point
				if route[n].alt == profile.hCruise then

					--get high and low threats on route segement
					local threat = {}																					--threats on leg at high alt default to 0 as an earlier change in altitude is of no advantage
					if profile.hAttack < 1000 then																		--if attack alt is at low altitude, collect actual threats to determine climb point on route
						threat = ThreatOnLeg(route[n], route[n - 1], profile.hCruise)									--collect threats on leg at high alt
					end

					--reduce threat range of EWR to areas of fighter threat
					for t = 1, #threat do																				--iterate through threats
						if threat[t].class == "EWR" then																--threat is an EWR
							local newEWRrange = 0																		--reduce EWR range to point where route enters the first fighter threat
							for f = 1, #fighterthreats[enemy] do														--iterate through fighter threats to find the first fighter threat that route enters into
								if GetTangentDistance(route[n], route[n - 1], fighterthreats[enemy][f]) < fighterthreats[enemy][f].range then	--route passes though fighter threat circle
									--find point where route enters fighter circle					
									local heading1 = GetHeading(route[n], route[n - 1])									--route heading
									local heading2 = GetHeading(route[n], fighterthreats[enemy][f])						--heading to center of threat circle
									local alpha = math.abs(heading1 - heading2)											--angle beteen both headings
									if alpha > 180 then
										alpha = math.abs(alpha - 360)
									end
									alpha = math.rad(alpha)
									local a = fighterthreats[enemy][f].range											--radius of threat circle
									local b = GetDistance(route[n], fighterthreats[enemy][f])							--distance to center of threat circle
									local beta = math.asin(b / (a / math.sin(alpha)))									--sinus sentence
									beta = math.pi - beta																--since sinus sentence results in two possible angles for beta and only the second is valid, use the second
									local gamma = math.pi - alpha - beta
									local c = a / math.sin(alpha) * math.sin(gamma)										--distance from WP1 to point intersecting threat circle
									local p = GetOffsetPoint(route[n], heading1, c)										--point where route is intersecting threat circle
									local EWR_p = GetDistance(threat[t], p)												--distance from EWR to this point
									if EWR_p < threat[t].range and EWR_p > newEWRrange then								--find longest new EWR range that is shorter than the original EWR range
										newEWRrange = EWR_p
									end

									local heading_p_t = GetHeading(p, fighterthreats[enemy][f])							--heading from intersection point to fighter threat
									local heading_p_EWR = GetHeading(p, threat[t])										--heading from intersection point to EWR
									local angle = math.abs(heading_p_t - heading_p_EWR)									--angle beteen both headings
									if angle > 180 then
										angle = math.abs(angle - 360)
									end
									if angle > 90 then																	--when angle is bigger then 90																											
										threat[t].invert = true															--the treat circle of EWR is outside of the interception area!
									end
								end
							end
							if newEWRrange > 0 then																		--an adjusted EWR range was determined
								threat[t].range = newEWRrange															--make this the new EWR range
							end
						end
					end

					if #threat == 0 then																				--no threat on route
						if route[n].alt > route[n - 1].alt then															--but route segment is the climb leg
							local climbPoint = {}																		--point to start climb
							local heading = GetHeading(route[n - 1], route[n])											--climb point is on route leg
							local distance = math.abs((profile.hCruise - profile.hAttack)) * 10							--distance to climb is 10 times the altitude difference (~-6� pitch) (make sure is positive)
							if distance < GetDistance(route[n - 1], route[n]) then										--if climb distance is longer than route leg distance, ignore clinb point
								climbPoint = GetOffsetPoint(route[n - 1], heading, distance)							--define climb point position
								climbPoint.id = "Nav"
								climbPoint.alt = profile.hCruise
								table.insert(route, n, climbPoint)														--insert into route
							end
							break																						--stop going through waypoints for the climb
						end
					else																								--if there are threats on route leg, make the climb on this route leg
						for m = n, 1, -1 do																				--move backward in route and put all previous wayoints until Egress to low alt
							if route[m - 1].alt == profile.hCruise then													--if previous waypoint is still at cruise
								route[m - 1].alt = profile.hAttack														--adjust waypoint alt to attack
							else
								break																					--stop when attack part of route is reached
							end
						end

						local climbPointStart = {}																		--point where climb starts (here the high alt threat is left)
						local distance = 100000000
						local heading = GetHeading(route[n], route[n - 1])
						for t = 1, #threat do
							local p1_t_heading = GetHeading(route[n], threat[t])
							local alpha = math.abs(heading - p1_t_heading)												--angle beteen route and p1-threat
							if alpha > 180 then
								alpha = math.abs(alpha - 360)
							end
							local p1_t = GetDistance(route[n], threat[t])												--distance between p1 and threat
							local p1_p90t = math.cos(math.rad(alpha)) * p1_t											--distance between p1 and point on route perpendicular to threat
							local p90t_t = p1_t * math.sin(math.rad(alpha))												--distance between threat and point on route perpendicular to threat
							local p90t_pC = math.sqrt(math.pow(threat[t].range, 2) - math.pow(p90t_t, 2))				--distance between point on route perpendiculat to threat and point on route intersecting threat circle
							local p1_pC = p1_p90t - p90t_pC																--distance from p1 to point on route intersecting threat circle
							if p1_pC <= 0 then																			--if point on route intersecting threat circle is ahead of p1
								if threat[t].invert then																--area outside of EWR range is the threat area
									distance = -p1_pC
								else
									distance = 0
									break																				--p1 is already within a threat circle. No climb point is needed, alter p1 to low level instead
								end
							elseif p1_pC < distance then
								distance = p1_pC																		--find the shortest distance to all threat circles (this is the point on route where the decend to low alt must be completed)
							end
						end

						if distance == 0 then																			--climb point is after of route[n]
							route[n].alt = profile.hAttack																--set route[n] to low alttude
						else																							--climb point is beyond of route[n]
							climbPointStart = GetOffsetPoint(route[n], heading, distance)								--define climb point position
							climbPointStart.id = "Nav"
							climbPointStart.alt = profile.hAttack
							table.insert(route, n, climbPointStart)														--insert into route
							local climb_distance = (profile.hCruise - profile.hAttack) * 10								--distance to climb is 10 times the altitude difference (~-6� pitch)
							if climb_distance < distance then
								local climbPointEnd = {}																--point where climb ends
								climbPointEnd = GetOffsetPoint(route[n + 1], heading, (distance - climb_distance))		--define climb point position
								climbPointEnd.id = "Nav"
								climbPointEnd.alt = profile.hCruise
								table.insert(route, n + 1, climbPointEnd)												--insert into route
							end
						end
						break																							--stop going through waypoints for the climb
					end
				end
			end

			local afterInter = os.clock()
			if  debugRoute and afterInter >= afterInterB + deltaT  then print() print("|Climb: "..afterInter - afterInterB.." |") end
			local afterInterB = os.clock()

		elseif profile.hCruise < profile.hAttack then																	--if cruise is lower than attack altitude, a descend and a climb point must be inserted
			for n = 3, #route - 2 do																					--iterate through route between join and split point
				if route[n].alt < route[n + 1].alt then																	--climb route leg
					local climbPoint = {}																				--point to start climb
					local heading = GetHeading(route[n + 1], route[n])													--climb point is on route leg
					local distance = math.abs((profile.hCruise - profile.hAttack) * 10)									--distance to climb is 10 times the altitude difference (~6� pitch) (make sure is positive)
					if distance < GetDistance(route[n], route[n + 1]) then												--if climb distance is longer than route leg distance, ignore climb point
						climbPoint = GetOffsetPoint(route[n + 1], heading, distance)									--define climb point position
						climbPoint.id = "Nav"
						climbPoint.alt = profile.hCruise
						table.insert(route, n + 1, climbPoint)															--insert into route
					end
					break
				end
			end
			for n = 3, #route - 2 do																					--iterate through route between join and split point
				if route[n].alt > route[n + 1].alt then																	--descend route leg
					local descendPoint = {}																				--point to start descend
					local heading = GetHeading(route[n], route[n + 1])													--descend point is on route leg
					local distance = math.abs((profile.hCruise - profile.hAttack) * 10)									--distance to descend is 10 times the altitude difference (~-6� pitch) (make sure is positive)
					if distance < GetDistance(route[n + 1], route[n]) then												--if descend distance is longer than route leg distance, ignore descend point
						descendPoint = GetOffsetPoint(route[n], heading, distance)										--define descend point position
						descendPoint.id = "Nav"
						descendPoint.alt = profile.hCruise
						table.insert(route, n + 1, descendPoint)														--insert into route
					end
					break
				end
			end
		end
		local after = os.clock()
		if  debugRoute and after >= before + deltaT  then print() print("|task == Strike: "..before.."-"..after.." |") end

	elseif task == "Fighter Sweep" then

		--set outbound and inbound routes
		local sweepStart = target																					--start point of sweep
		local sweepEnd																									--end point of sweep
		if target.MultiPoints then																					--the sweep target has multiple points
			sweepEnd = target.MultiPoints[#target.MultiPoints]												--sweep ends at last point
		else																											--the sweep target has a single point only
			sweepEnd = target																						--sweep ends at target point
		end

		local outbound_navRoute = FindPath(basePoint, sweepStart)														--find the safest outbound route
		local inbound_navRoute = FindPath(basePoint, sweepEnd)															--find the safest inbound route


		--set form-up point
		local joinPoint = {}																							--point where package joins on common flight route
		do
			local point																									--join point is between basePoint and this local point
			if #outbound_navRoute.navpoints == 0 then																	--if there is no outbound nav route
				point = sweepStart																						--point is sweepStart
			else																										--if there is an outbound nav route
				point = outbound_navRoute.navpoints[1]																	--point is first nav point
			end
			local heading = GetHeading(basePoint, point)

			local distance = math.abs((profile.hCruise - basePoint.h) * 7)												--distance to climb from base elevation to cruise altitude with 8� pitch (make sure distance is positive)
			if distance >= GetDistance(basePoint, point) then															--climb distance bigger than distance to first WP
				distance = GetDistance(basePoint, point) / 3 * 2														--join point is 2/3 to first WP
			elseif distance < 15000 then																				--climb distance less than 15 km
				distance = 15000																						--join point should be at least 15 km from base
			end

			joinPoint = GetOffsetPoint(basePoint, heading, distance)													--define join point
		end


		--set split point
		local splitPoint = {}																							--point where package splits to land on individual airbases		
		do
			local point																									--split point is between basePoint and this local point
			if #inbound_navRoute.navpoints == 0 then																	--if there is no inbound nav route
				point = sweepEnd																						--point is sweepEnd
			else																										--if there is an inbound nav route
				point = inbound_navRoute.navpoints[1]																	--point is first nav point
			end
			local heading = GetHeading(basePoint, point)

			local distance = math.abs((profile.hCruise - basePoint.h) * 7)												--distance to descend from cruise alt to base elevation with 8� pitch (make sure distance is positive)
			if distance >= GetDistance(basePoint, point) then															--descend distance bigger than distance to last WP
				distance = GetDistance(basePoint, point) / 3 * 2														--join point is 2/3 to last WP
			elseif distance < 15000 then																				--descend distance less than 15 km
				distance = 15000																						--split point should be at least 15 km from base
			end

			splitPoint = GetOffsetPoint(basePoint, heading, distance)													--define split point
		end
		--set assemble point
		local assemblyPoint = {}
		do
			local heading = GetHeading(basePoint, joinPoint)
			local distance = assemblePointDistance
			if GetDistance(basePoint, joinPoint) < distance then distance = GetDistance(basePoint, joinPoint) -1000 end
			assemblyPoint = GetOffsetPoint(basePoint, heading, distance)
		end

		--build complete route
		table.insert(route, {x = basePoint.x, y = basePoint.y, id = "Taxi", alt = basePoint.h})
		table.insert(route, {x = basePoint.x, y = basePoint.y, id = "Departure", alt = basePoint.h })		--+ 1000
		table.insert(route, {x = assemblyPoint.x, y = assemblyPoint.y, id = "Assemble", alt = profile.hCruise })
		table.insert(route, {x = joinPoint.x, y = joinPoint.y, id = "Join", alt = profile.hCruise, hCruiseREF = profile.hCruiseREF})
		for n = 1, #outbound_navRoute.navpoints do
			table.insert(route, {x = outbound_navRoute.navpoints[n].x, y = outbound_navRoute.navpoints[n].y, id = "Nav", alt = profile.hCruise})
		end
		if target.MultiPoints then																					--the sweep target has multiple points
			for n = 1, #target.MultiPoints do
				table.insert(route, {x = target.MultiPoints[n].x, y = target.MultiPoints[n].y, id = "Sweep", alt = profile.hAttack})
			end
		else																											--the sweep target has a single point only
			table.insert(route, {x = target.x, y = target.y, id = "Sweep", alt = profile.hAttack})
		end
		for n = #inbound_navRoute.navpoints, 1, -1 do
			table.insert(route, {x = inbound_navRoute.navpoints[n].x, y = inbound_navRoute.navpoints[n].y, id = "Nav", alt = profile.hCruise})
		end
		table.insert(route, {x = splitPoint.x, y = splitPoint.y, id = "Split", alt = profile.hCruise})
		table.insert(route, {x = basePoint.x, y = basePoint.y, id = "Land", alt = profile.hCruise})


	elseif task == "CAP" or task == "AWACS" or task == "Refueling" or task == "AFAC" then

		--set orbit points
		local orbit_lenght
		if task == "CAP" then
			orbit_lenght = profile.vAttack * 180																		--orbit leg 3 minutes
		elseif task == "AWACS" or task == "AFAC" then
			orbit_lenght = profile.vAttack * 180																		--orbit leg 3 minutes
		elseif task == "Refueling" then
			orbit_lenght = profile.vAttack * 180																		--orbit leg 3 minutes

			-- local side = DCS_ENI_Side[enemy]
			-- local angel = math.floor(profile.hAttack * 3.281 / 1000) * 1000
			-- if not patern[side] then patern[side] = {} end

			-- if patern[side][angel] then
			-- 	local i = 1
			-- 	local newAngel = 0
			-- 	repeat
			-- 		newAngel = (math.random(-5, 5) * 1000) + angel
			-- 		i=i+1
			-- 	until not patern[side][newAngel] or i>30
			-- 	patern[side][newAngel] = true
			-- 	profile.hAttack = newAngel / 3.281
			-- end

		end

		local orbitStart = {}
		local orbitEnd = {}

		--local route_axis = GetHeading(target, basePoint)
		--adjustment_f
		local axeStart = route_axis + 90
		local axeEnd = route_axis - 90
		if target.axis then
			axeStart = target.axis
			axeEnd = target.axis + 180
		end

		orbitStart = GetOffsetPoint(target, axeStart, orbit_lenght / 2)
		orbitEnd = GetOffsetPoint(target, axeEnd, orbit_lenght / 2)


		--set outbound and inbound routes
		local outbound_navRoute = FindPath(basePoint, orbitStart)														--find the safest outbound route
		local inbound_navRoute = FindPath(basePoint, orbitEnd)															--find the safest inbound route


		--set form-up point
		local joinPoint = {}																							--point where package joins on common flight route
		do
			local point																									--join point is between basePoint and this local point
			if #outbound_navRoute.navpoints == 0 then																	--if there is no outbound nav route
				point = orbitStart																						--point is orbitStart
			else																										--if there is an outbound nav route
				point = outbound_navRoute.navpoints[1]																	--point is first nav point
			end
			local heading = GetHeading(basePoint, point)

			local distance = math.abs((profile.hCruise - basePoint.h) * 7)												--distance to climb from base elevation to cruise altitude with 8� pitch (make sure distance is positive)
			if distance >= GetDistance(basePoint, point) then															--climb distance bigger than distance to first WP
				distance = GetDistance(basePoint, point) / 3 * 2														--join point is 2/3 to first WP
			elseif distance < 15000 then																				--climb distance less than 15 km
				distance = 15000																						--join point should be at least 15 km from base
			end

			joinPoint = GetOffsetPoint(basePoint, heading, distance)													--define join point
		end


		--set split point
		local splitPoint = {}																							--point where package splits to land on individual airbases		
		do
			local point																									--split point is between basePoint and this local point
			if #inbound_navRoute.navpoints == 0 then																	--if there is no inbound nav route
				point = orbitEnd																						--point is orbitEnd
			else																										--if there is an inbound nav route
				point = inbound_navRoute.navpoints[1]																	--point is first nav point
			end
			local heading = GetHeading(basePoint, point)

			local distance = math.abs((profile.hCruise - basePoint.h) * 7)												--distance to descend from cruise alt to base elevation with 8� pitch (make sure distance is positive)
			if distance >= GetDistance(basePoint, point) then															--descend distance bigger than distance to last WP
				distance = GetDistance(basePoint, point) / 3 * 2														--join point is 2/3 to last WP
			elseif distance < 15000 then																				--descend distance less than 15 km
				distance = 15000																						--split point should be at least 15 km from base
			end

			splitPoint = GetOffsetPoint(basePoint, heading, distance)													--define split point
		end

		--set assemble point
		local assemblyPoint = {}
		do
			local heading = GetHeading(basePoint, joinPoint)
			local distance = assemblePointDistance
			if GetDistance(basePoint, joinPoint) < distance then distance = GetDistance(basePoint, joinPoint) -1000 end
			assemblyPoint = GetOffsetPoint(basePoint, heading, distance)
		end

		--build complete route
		table.insert(route, {x = basePoint.x, y = basePoint.y, id = "Taxi", alt =  basePoint.h})
		table.insert(route, {x = basePoint.x, y = basePoint.y, id = "Departure", alt = basePoint.h})	-- + 1000
		table.insert(route, {x = assemblyPoint.x, y = assemblyPoint.y, id = "Assemble", alt = profile.hCruise })
		table.insert(route, {x = joinPoint.x, y = joinPoint.y, id = "Join", alt = profile.hCruise, hCruiseREF = profile.hCruiseREF})
		for n = 1, #outbound_navRoute.navpoints do
			table.insert(route, {x = outbound_navRoute.navpoints[n].x, y = outbound_navRoute.navpoints[n].y, id = "Nav", alt = profile.hCruise})
		end

		local tempAlt = profile.hAttack
		if target.alt then
			tempAlt = target.alt
		end

		table.insert(route, {x = orbitStart.x, y = orbitStart.y, id = "Station", alt = tempAlt})
		table.insert(route, {x = orbitEnd.x, y = orbitEnd.y, id = "Station", alt = tempAlt})
		for n = #inbound_navRoute.navpoints, 1, -1 do
			table.insert(route, {x = inbound_navRoute.navpoints[n].x, y = inbound_navRoute.navpoints[n].y, id = "Nav", alt = profile.hCruise})
		end
		table.insert(route, {x = splitPoint.x, y = splitPoint.y, id = "Split", alt = profile.hCruise})
		table.insert(route, {x = basePoint.x, y = basePoint.y, id = "Land", alt = profile.hCruise})


		--climb and descend points
		if profile.hCruise < profile.hAttack then																		--if cruise and attack altitude are not the same, a descend and a climb point must be inserted
			for n = 3, #route - 2 do																					--iterate through route between join and split point
				if route[n].alt < route[n + 1].alt then																	--climb route leg
					local climbPoint = {}																				--point to start climb
					local heading = GetHeading(route[n + 1], route[n])													--climb point is on route leg
					local distance = math.abs((profile.hCruise - profile.hAttack) * 12)									--distance to climb is 10 times the altitude difference (~6� pitch) (make sure is positive)
					if distance < GetDistance(route[n], route[n + 1]) then												--if climb distance is longer than route leg distance, ignore climb point
						climbPoint = GetOffsetPoint(route[n + 1], heading, distance)									--define climb point position
						climbPoint.id = "Nav"
						climbPoint.alt = profile.hCruise
						table.insert(route, n + 1, climbPoint)															--insert into route
					end
					break
				end
			end
			for n = 3, #route - 2 do																					--iterate through route between join and split point
				if route[n].alt > route[n + 1].alt then																	--descend route leg
					local descendPoint = {}																				--point to start descend
					local heading = GetHeading(route[n], route[n + 1])													--descend point is on route leg
					local distance = math.abs((profile.hCruise - profile.hAttack) * 10)									--distance to descend is 10 times the altitude difference (~-6� pitch) (make sure is positive)
					if distance < GetDistance(route[n + 1], route[n]) then												--if descend distance is longer than route leg distance, ignore descend point
						descendPoint = GetOffsetPoint(route[n], heading, distance)										--define descend point position
						descendPoint.id = "Nav"
						descendPoint.alt = profile.hCruise
						table.insert(route, n + 1, descendPoint)														--insert into route
					end
					break
				end
			end
		elseif profile.hCruise > profile.hAttack then																		--if cruise and attack altitude are not the same, a descend and a climb point must be inserted
			for n = 3, #route - 2 do																					--iterate through route between join and split point
				if route[n].alt < route[n + 1].alt then																	--climb route leg
					local climbPoint = {}																				--point to start climb
					local heading = GetHeading(route[n], route[n + 1])													--climb point is on route leg
					local distance = math.abs((profile.hCruise - profile.hAttack) * 10)									--distance to climb is 10 times the altitude difference (~6� pitch) (make sure is positive)
					if distance < GetDistance(route[n], route[n + 1]) then												--if climb distance is longer than route leg distance, ignore climb point
						climbPoint = GetOffsetPoint(route[n], heading, distance)										--define climb point position
						climbPoint.id = "Nav"
						climbPoint.alt = profile.hCruise
						table.insert(route, n + 1, climbPoint)															--insert into route
					end
					break
				end
			end
			for n = 3, #route - 2 do																					--iterate through route between join and split point
				if route[n].alt > route[n + 1].alt then																	--descend route leg
					local descendPoint = {}																				--point to start descend
					local heading = GetHeading(route[n + 1], route[n])													--descend point is on route leg
					local distance = math.abs((profile.hCruise - profile.hAttack) * 10)									--distance to descend is 10 times the altitude difference (~-6� pitch) (make sure is positive)
					if distance < GetDistance(route[n + 1], route[n]) then												--if descend distance is longer than route leg distance, ignore descend point
						descendPoint = GetOffsetPoint(route[n + 1], heading, distance)									--define descend point position
						descendPoint.id = "Nav"
						descendPoint.alt = profile.hCruise
						table.insert(route, n + 1, descendPoint)														--insert into route
					end
					break
				end
			end
		end


	elseif task == "Transport" or task == "Nothing" then

		--set outbound and inbound routes
		local outbound_navRoute = FindPath(basePoint, target)														--find the safest outbound route

		--set form-up point
		local joinPoint = {}																							--point where package joins on common flight route
		do
			local point																									--join point is between basePoint and this local point
			if #outbound_navRoute.navpoints == 0 then																	--if there is no outbound nav route
				point = target																						--point is target
			else																										--if there is an outbound nav route
				point = outbound_navRoute.navpoints[1]																	--point is first nav point
			end
			local heading = GetHeading(basePoint, point)

			local distance = math.abs((profile.hCruise - basePoint.h) * 7)												--distance to climb from base elevation to cruise altitude with 8� pitch (make sure distance is positive)
			if distance >= GetDistance(basePoint, point) then															--climb distance bigger than distance to first WP
				distance = GetDistance(basePoint, point) / 3 * 2														--join point is 2/3 to first WP
			elseif distance < 15000 then																				--climb distance less than 15 km
				distance = 15000																						--join point should be at least 15 km from base
			end

			joinPoint = GetOffsetPoint(basePoint, heading, distance)													--define join point
		end

		--set split point
		local splitPoint = {}																							--point where package splits to land on individual airbases		
		do
			local point																									--split point is between basePoint and this local point
			if #outbound_navRoute.navpoints == 0 then																	--if there is no outbound nav route
				point = joinPoint																						--point is joinPoint
			else																										--if there is an outbound nav route
				point = outbound_navRoute.navpoints[#outbound_navRoute.navpoints]										--point is last nav point
			end
			local heading = GetHeading(target, point)

			local distance = math.abs((profile.hCruise - basePoint.h) * 7)												--distance to descend from cruise alt to base elevation with 8� pitch (make sure distance is positive)
			if distance >= GetDistance(basePoint, point) then															--descend distance bigger than distance to last WP
				distance = GetDistance(basePoint, point) / 3 * 2														--join point is 2/3 to last WP
			elseif distance < 15000 then																				--descend distance less than 15 km
				distance = 15000																						--split point should be at least 15 km from base
			end

			splitPoint = GetOffsetPoint(target, heading, distance)													--define split point
		end

		--set assemble point
		local assemblyPoint = {}
		do
			local heading = GetHeading(basePoint, joinPoint)
			local distance = assemblePointDistance
			if GetDistance(basePoint, joinPoint) < distance then distance = GetDistance(basePoint, joinPoint) -1000 end
			assemblyPoint = GetOffsetPoint(basePoint, heading, distance)
		end

		table.insert(route, {x = basePoint.x, y = basePoint.y, id = "Taxi", alt = basePoint.h})
		table.insert(route, {x = basePoint.x, y = basePoint.y, id = "Departure", alt = basePoint.h })		--+ 1000
		table.insert(route, {x = assemblyPoint.x, y = assemblyPoint.y, id = "Assemble", alt = profile.hCruise })
		table.insert(route, {x = joinPoint.x, y = joinPoint.y, id = "Join", alt = profile.hCruise})
		table.insert(route, {x = splitPoint.x, y = splitPoint.y, id = "Split", alt = profile.hCruise})
		table.insert(route, {x = target.x, y = target.y, id = "Land", alt = profile.hCruise})
	end


	--measure lenght of complete route
	local route_lenght = 0
	for n = 1, #route - 1 do
		route_lenght = route_lenght + GetDistance(route[n], route[n + 1])
	end
	route.lenght = route_lenght

	if  DebugRoute  then
		print("AtoRG passe BB route.lenght "..tostring(route.lenght))
	end

	--evaluate threat level of complete route
	do
		route.threats = {}																								--table to store threats for route
		before = os.clock()
		-- print() print("|fighterthreats: "..before.." |")
		--ground threats
		route.threats.ground = {}																						--table to store ground threats for route
		for alt,threat in pairs(threat_table.ground) do																	--iterate through all ground threat altitudes
			for t = 1, #threat do																						--iterate through all ground threats within altitude band
				-- io.write(" #threat "..#threat.." ")

				for n = 1, #route - 1 do																				--iterate through all route segements
					i_timmer01 = i_timmer01 +1

					if route[n + 1].alt <= alt then																		--if route segement is in threat altitude
						local distance = GetTangentDistance(route[n], route[n + 1], threat[t])							--distance of route segment to threat
						if distance < threat[t].range then																--if route segment is in range of threat						
							local adjusted_threat = threat[t].level - (threat[t].level / threat[t].range * distance)	--threat adjusted to distance to route leg
							if route.threats.ground[threat[t].x .. "/" .. threat[t].y] then									--if this ground threat already has a threat entry for this route
								if route.threats.ground[threat[t].x .. "/" .. threat[t].y].level < adjusted_threat then		--if the existing threat entry is lower than the new one
									route.threats.ground[threat[t].x .. "/" .. threat[t].y].level = adjusted_threat			--overwrite threat entry with new one
								end
							else																						--if this fighter unit has no threat entry for this route yet
								route.threats.ground[threat[t].x .. "/" .. threat[t].y] = {								--make new threat entry for this ground threat
									level = adjusted_threat,
									offset = threat[t].SEAD_offset
								}
							end
							if threat[t].class == "SAM" then															--threat is a SAM
								if route[n].SEAD_radius then															--waypoint has a SEAD radius entry
									if threat[t].range > route[n].SEAD_radius then										--find longest ranging threat that route segment penetrates
										route[n].SEAD_radius = threat[t].range											--store the range of the threat that route segment penetrates
									end
								else																					--waypoint has no SEAD radius entry
									route[n].SEAD_radius = threat[t].range												--store the range of the threat that route segment penetrates
								end
							end

						end

						-- io.write("| "..before.."-"..after.." |")
					end
					-- if i_timmer01 >= 10  then io.write("!") i_timmer01 = 0 end
				end
			end

		end
		after = os.clock()
		if  debugRoute and after >= before + deltaT  then print() print("|threat_table.ground: "..before.."-"..after.." |") end

		before = os.clock()
		-- print() print("|fighterthreats: "..before.." |")
		--air threats
		route.threats.air = {}																										--table to store air threats for route
		for t = 1, #fighterthreats[enemy] do																						--iterate through all fighter threats
			if fighterthreats[enemy][t].class == "CAP" or fighterthreats[enemy][t].class == "Intercept" then
				for n = 1, #route - 1 do																							--iterate through all route segements
					i_timmer01 = i_timmer01 +1
					local route_leg_alt
					local route_leg_band
					if route[n].alt >= 3000 and route[n + 1].alt >= 3000 then
						route_leg_alt = profile.hCruise
						route_leg_band = "high"
					else
						route_leg_alt = profile.hAttack
						route_leg_band = "low"
					end

					if GetTangentDistance(route[n], route[n + 1], fighterthreats[enemy][t]) < fighterthreats[enemy][t].range then	--if route segment is in range of fighter threat
						local ewr_required																							--boolean whether ewr is required for the fighter to be a threat
						if fighterthreats[enemy][t].class == "CAP" then																--if the fighter is CAP
							if route_leg_band == "high" then																		--if route leg is at high altitude
								ewr_required = false																				--CAP does not need ewr to be a threat
							else																									--if route leg is at low altitude
								if fighterthreats[enemy][t].LDSD then																--if fighter is look down/shoot down capable
									ewr_required = false																			--CAP does not need ewr to be a threat
								else																								--if fighter is not look down/shoot down capable
									-- ATO_RG_Debug02		quand les EWR sont d�truit: on active les CAP, si les CAP on besoin d'EWR c'est nul
									-- ewr_required = true																				--CAP needs ewr to be a threat
								end
							end
						elseif fighterthreats[enemy][t].class == "Intercept" then													--if the fighter is an interceptor
							ewr_required = true																						--ewr is required for fighter to be a threat (needs early warning to take off)
						end

						if ewr_required == true then																				--fighter needs ewr/awacs station to be a threat
							local break_loop = false
							for e = 1, #threat_table.ewr[route_leg_alt] do															--iterate through all ewr/awacs
								i_timmer01 = i_timmer01 +1
								if GetDistance(threat_table.ewr[route_leg_alt][e], fighterthreats[enemy][t]) < threat_table.ewr[route_leg_alt][e].range + fighterthreats[enemy][t].range then	--fighter operation area and ewr coverage are overlapping
									if GetTangentDistance(route[n], route[n + 1], fighterthreats[enemy][t]) < fighterthreats[enemy][t].range then				--if route leg is in range of fighter
										if GetTangentDistance(route[n], route[n + 1], threat_table.ewr[route_leg_alt][e]) < threat_table.ewr[route_leg_alt][e].range then	--if route leg is in range of ewr/awacs
											if route.threats.air[fighterthreats[enemy][t].name] then															--if this fighter unit already has a threat entry for this route
												if route.threats.air[fighterthreats[enemy][t].name].level < fighterthreats[enemy][t].level then					--if the existing threat entry is lower than the new one
													route.threats.air[fighterthreats[enemy][t].name].level = fighterthreats[enemy][t].level						--overwrite threat entry with new one
												end
											else																					--if this fighter unit has no threat entry for this route yet
												route.threats.air[fighterthreats[enemy][t].name] = {								--make new threat entry for this fighter unit
													level = fighterthreats[enemy][t].level,
												}
											end
											break_loop = true																		--two breaks would be required to break ewr loop and route loop
											break																					--ewr loop
										end
									end
								end
							end
							if break_loop == true then
								break																								--break route segemnt loop and go to next threat
							end
						else																										--no ewr is needed for fighter to be a threat
							if route.threats.air[fighterthreats[enemy][t].name] then												--if this fighter unit already has a threat entry for this route
								if route.threats.air[fighterthreats[enemy][t].name].level < fighterthreats[enemy][t].level then		--if the existing threat entry is lower than the new one
									route.threats.air[fighterthreats[enemy][t].name].level = fighterthreats[enemy][t].level			--overwrite threat entry with new one
								end
							else																									--if this fighter unit has no threat entry for this route yet
								route.threats.air[fighterthreats[enemy][t].name] = {												--make new threat entry for this fighter unit
									level = fighterthreats[enemy][t].level,
								}
							end
							break																									--break route segemnt loop and go to next threat
						end
					end
					-- if i_timmer01 >= 10  then io.write("*a") i_timmer01 = 0 end
				end
			end
		end
		after = os.clock()
		if  debugRoute and after >= before + deltaT  then print() print("|fighterthreats: "..before.."-"..after.." |") end

		--combine route threats
		route.threats.SEAD_offset = 0																								--counter for SEAD sorties required to offset ground threats
		route.threats.ground_total = 0.5																							--cummulative route ground threat level (0.5 = no threat)
		route.threats.air_total = 0.5																								--cuumulative route air threat level (0.5 = no threat)

		for k,v in pairs(route.threats.ground) do																					--iterate through route ground threats
			route.threats.SEAD_offset = route.threats.SEAD_offset + v.offset														--collect combined SEAD offset
			route.threats.ground_total = route.threats.ground_total + v.level														--sum route ground threat levels
		end
		for k,v in pairs(route.threats.air) do																						--iterate through route air threats
			route.threats.air_total = route.threats.air_total + v.level																--sum route air threat levels
			-- debuGenTxt = debuGenTxt .."\n air_total:|_|"..k.."|_v.level_|"..v.level.."|_total_|".. route.threats.air_total 	
		end
	end


	if standoff and standoff > 15000 then																							--if standoff from attack point to target is bigger than 15 km, then target point has not yet been inserted to route in order to calculate threats and route lenght from attack point to egress point
		for r = 1, #route do																										--go through route
			if route[r].id == "Attack" then																							--find attack point
				local toTarget = GetHeading(route[r], target)
				local towards_target = GetOffsetPoint(route[r], toTarget, 5000)			--draft attack point
				-- local towards_target = GetOffsetPoint(route[r], toTarget, standoff)			--Attention, cette ligne amene le vecteur à survoler la cible, ce qui est idiot avec un ASM


				table.insert(route, r + 1, {x = towards_target.x, y = towards_target.y, id = "Target", alt = profile.hAttack})			--insert target point after attack point
				break
			end
		end
	end

	return route
end


function GetEscortRoute(basePoint, orig_route, task, loadouts, unitEscort, mainUnit)																					--get the escort route given the escort start point and an existing package route
	local before = os.clock()
	--make a local copy of the route table forwarded as function argument (otherwise the original route gets adjusted
	-- local MainUnitHelicopter = mainUnit.helicopter
	local route = Deepcopy(orig_route)
	local TagPause = false

	-- Miguel21 modification M16.c // ne recopie pas le Spawn des B1b et B-52 en apparation sur une base virtuel en alti
	if route[1].id == "Spawn" then
		route[1].id = "Taxi"
		route[2].id = "Departure"
	end

	-- change l'altitude des differents role, sinon, Strike Escorte et SEAD sont � la meme alti, pas bien
	local randomAlti = math.random(4500, 7600)
	if IsHelicopter[unitEscort.type]  then
		-- if not loadouts.hCruise then
		-- 	_affiche(unitEscort, "unitEscort AtoRG")
		-- 	_affiche(loadouts, "loadouts AtoRG")
		-- end

		if loadouts.hCruise then
			randomAlti = math.random(loadouts.hCruise*2/3, loadouts.hCruise)
		else
			randomAlti = math.random(0, 700)
		end
	end
	for w = 1, #route do

		local higher = 0

		if task == "SEAD" then
			higher = 304
		elseif task == "Escort" then
			higher = 608
		end

		if not IsHelicopter[unitEscort.type]  then
			-- -- on ne l'applique pas � un groupe volant sous les radars
			-- if route[w].alt > 1000 then
			-- 	route[w].alt = route[w].alt + higher
			-- end


			-- if loadouts.hAttack and loadouts.hCruise then
			-- 	-- ne pas avoir d'avion haute altitude en escorte TBA
			-- 	if route[w].id ~= "Departure" and route[w].id ~= "Taxi" and route[w].id ~= "Land" and route[w].alt < loadouts.hAttack and route[w].alt < loadouts.hCruise then
			-- 		route[w].alt = loadouts.hCruise + higher
			-- 	end
			-- end
			route[w].alt = randomAlti
		else
			route[w].alt = randomAlti
		end

		-- elseif MainUnitHelicopter and not unitEscort.helicopter  then
		if IsHelicopter[mainUnit.type] and not IsHelicopter[unitEscort.type] then
			-- les avions escorte d helicopter doivent etre a leur alti conso
			route[w].alt = route[w].alt +  randomAlti
		end

		if route[w].id == "Land" then
			route[w].alt =  basePoint.h
		end
	end

	--adjust route for escort joining the package
	local join_distance = 99999999																								--shortest distance from escort start point to package route leg
	local WP
	for n = 4, #route - 1 do																									--iterate through route points from Join Point on
		if GetTangentDistance(route[n], route[n + 1], basePoint) < join_distance then											--distance to this route leg is shorter than to previous leg
			join_distance = GetTangentDistance(route[n], route[n + 1], basePoint)												--set new shortest join distance
			WP = n
		else																													--distance to this route leg is longer than to previous leg
			break																												--stop searching
		end
		if route[n + 1].id == "IP" then																							--only search to IP
			break
		end
	end

	route[1].x = basePoint.x																									--modify route to start at escort start point
	route[1].y = basePoint.y
	route[1].alt = basePoint.h

	if #orig_route < 2 then
		_affiche(orig_route, "orig_route")
		_affiche(mainUnit, "mainUnit")
		os.execute 'pause'
	end
	route[2].x = basePoint.x
	route[2].y = basePoint.y
	route[2].alt = basePoint.h

	if route[3].id == "Assemble" then
		route[3].x = basePoint.x
		route[3].y = basePoint.y
		route[3].alt = basePoint.h
	end

	if not IsHelicopter[unitEscort.type] then
		local heading = 0
		for n, wpt in ipairs(route) do
			if wpt.id == "Join" then
				heading = GetHeading(route[WP], basePoint)
				break
			end
		end

		local assemblyPoint = GetOffsetPoint(basePoint, heading, 16000)

		local altitude = AltitudeCruise *2/3

		if Data_divers[unitEscort.type] and Data_divers[unitEscort.type].hCruise then
			altitude = Data_divers[unitEscort.type].hCruise *2/3
		end


		if route[3].id == "Assemble" then
			route[3].x = assemblyPoint.x
			route[3].y = assemblyPoint.y
			route[3].alt = altitude
		end
	end

	if GetDistance(basePoint, route[WP]) == join_distance then																	--shortest distance to route leg is to first leg waypoint
		route[4].x = route[WP].x
		route[4].y = route[WP].y
		for n = WP, 5, -1 do
			-- table.remove(route, n)	-- ATO_RG_Debug03 supprime trop de waypoint lors de l'escorte
		end
	elseif GetDistance(basePoint, route[WP + 1]) == join_distance then															--shortest distance to route leg is to second leg waypoint
		route[4].x = route[WP + 1].x
		route[4].y = route[WP + 1].y
		for n = WP + 1, 5, -1 do
			-- table.remove(route, n)	-- ATO_RG_Debug03 supprime trop de waypoint lors de l'escorte
		end
	else																														--shortest distance to route leg is between first and second leg waypoint
		local join_heading
		local heading1 = GetHeading(route[WP], route[WP + 1])
		local heading2 = GetHeading(route[WP], basePoint)
		if heading1 - heading2 > 180 then
			heading1 = heading1 - 360
		elseif heading2 - heading1 > 180 then
			heading2 = heading2 - 360
		end
		if heading1 <= heading2 then
			join_heading = heading1 - 90
		else
			join_heading = heading1 + 90
		end
		local mod_joinPoint = GetOffsetPoint(basePoint, join_heading, join_distance)											--modify the Joint Point to be between route leg WP 1 and 2
		route[4].x = mod_joinPoint.x
		route[4].y = mod_joinPoint.y
		for n = WP, 5, -1 do
			-- table.remove(route, n)	-- ATO_RG_Debug03 supprime trop de waypoint lors de l'escorte
		end
	end

	--adjust route for escort to leave the package
	local split_distance = 99999999																								--shortest distance from escort end point to package route leg
	for n = #route - 1, 2, -1 do																								--iterate backwards through route points from Split Point on
		if GetTangentDistance(route[n], route[n - 1], basePoint) < split_distance then											--distance to this route leg is shorter than to previous leg
			split_distance = GetTangentDistance(route[n], route[n - 1], basePoint)												--set new shortest split distance
			WP = n
		else																													--distance to this route leg is longer than to previous leg
			break																												--stop searching
		end
		if route[n - 1].id == "Egress" then																						--only search to Egress
			break
		end
	end

	if mainUnit.task ~= "Transport" and mainUnit.task ~= "Nothing" then

		route[#route].x = basePoint.x																								--modify route to end at escort land point
		route[#route].y = basePoint.y

		if GetDistance(basePoint, route[WP]) == split_distance then
			route[#route - 1].x = route[WP].x
			route[#route - 1].y = route[WP].y
			for n = #route - 2, WP, -1 do
				table.remove(route, n)
			end
		elseif GetDistance(basePoint, route[WP - 1]) == split_distance then
			route[#route - 1].x = route[WP - 1].x
			route[#route - 1].y = route[WP - 1].y
			for n = #route - 2, WP - 1, -1 do
				table.remove(route, n)
			end
		else																														--if a point between last Nav and Split Point is closest to escort land point
			local split_heading
			local heading1 = GetHeading(route[WP], route[WP - 1])
			local heading2 = GetHeading(route[WP], basePoint)
			if heading1 - heading2 > 180 then
				heading1 = heading1 - 360
			elseif heading2 - heading1 > 180 then
				heading2 = heading2 - 360
			end
			if heading1 <= heading2 then
				split_heading = heading1 - 90
			else
				split_heading = heading1 + 90
			end
			local mod_splitPoint = GetOffsetPoint(basePoint, split_heading, split_distance)											--modify the Split Point to be between last Nav and old Split Point
			route[#route - 1].x = mod_splitPoint.x
			route[#route - 1].y = mod_splitPoint.y
			for n = #route - 2, WP, -1 do
				table.remove(route, n)
			end
		end
	else
		--ajoute le wpt land
		table.insert(route, {x = basePoint.x, y = basePoint.y, id = "Land", alt =  basePoint.h})

		--renomme l'ancien wpt land en attack
		route[#route - 1].id = "Target"
		local targetPoint = route[#route - 1]

		--renomme le wpt join en TransmitMessage
		local altMax = 0
		for n=1, #route do
			if route[n].id == "Split" then
				route[n].id = "Nav"
			end
			if route[n].alt > altMax then
				altMax = route[n].alt
			end
		end

		--ajoute le WPT Egress pour obtenir un CERCLE d'attente
		local egressPoint = {}																							--point where package splits to land on individual airbases		
		do
			local heading = GetHeading(targetPoint, route[#route - 2])
			egressPoint = GetOffsetPoint(targetPoint, heading, 5000)
		end

		table.insert(route, #route, {x = egressPoint.x, y = egressPoint.y, id = "Egress", alt = altMax})

		--ajoute un WPT Split
		local splitPoint = {}																							--point where package splits to land on individual airbases		
		do
			local heading = GetHeading(basePoint, targetPoint)

			local distance = math.abs((altMax - basePoint.h) * 4)												--distance to descend from cruise alt to base elevation with 15� pitch (make sure distance is positive)
			if distance >= GetDistance(basePoint, targetPoint) then															--descend distance bigger than distance to last WP
				distance = GetDistance(basePoint, targetPoint) / 3 * 2														--join point is 2/3 to last WP
			elseif distance < 15000 then																				--descend distance less than 15 km
				distance = 15000																						--split point should be at least 15 km from base
			end

			splitPoint = GetOffsetPoint(basePoint, heading, distance)													--define split point
		end

		table.insert(route, #route, {x = splitPoint.x, y = splitPoint.y, id = "Split", alt = altMax})

		-- _affiche(route, "AtoRG route")
	end

	--measure lenght of complete route
	local route_lenght = 0
	for n = 1, #route - 1 do
		route_lenght = route_lenght + GetDistance(route[n], route[n + 1])
	end
	route.lenght = route_lenght

	if  DebugRoute  then
		print("AtoRG passe CC route.lenght "..tostring(route.lenght))
	end

	-- if i_timmer01 >= 10  then io.write("|") i_timmer01 = 0 end

	local after = os.clock()
	if  debugRoute and after >= before + deltaT  then print() print("|EscorteRoute: "..before.."-"..after.." |") end

	return route
end