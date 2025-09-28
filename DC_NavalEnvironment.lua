--Moving ships and carriers as airbases
--Initiated by MAIN_NextMission.lua
------------------------------------------------------------------------------------------------------- 
-- last modification: cleancode_d
if not versionDCE then versionDCE = {} end
versionDCE["DC_NavalEnvironment.lua"] = "1.12.35"
------------------------------------------------------------------------------------------------------- 
-- debug_g					(g #route<1)(f: wpt en dehors du polygone)(e: TACAN)(d: staticPos)(c: Angle et Bearing des statics sur PA)
-- DC_NE_Debug_b			(b: maximizes the distance between two ship turns) (a: transforms an angle of more than 90� into 2 WPT of less than 90�)
-- cleancode_d				(c springCleaning)
-- adjustment_c				(c no CVN turn to avoid INS offset) (b CVN to CV)(a clean conf_mod)
-- modification M62_b		allows you to use third party files that Data information without being overwritten by central information updates (b SC_CarrierIntoWind active this file)
-- modification M45_a		compatible with 2.7.0
-- modification M40_i		Pedro Helicopter (i use new follow task)
-- modification M36_f		(f boats start upwind)(d: add timer) MenuRadio request manual TurnIntoWind
-- modification M33_e		Custom Briefing (e: CV Manual Freq)
-- modification M11_a		Multiplayer
------------------------------------------------------------------------------------------------------- 
if Debug.debug then
	print("START DC_NavalEnvironment.lua "..versionDCE["DC_NavalEnvironment.lua"].." =-=-=-=-=-=-=-=-=-=-=-=-=-=-=")
end
-- local poly = {}


--function to find random point in polygon
local function randomPointInPoly(arg_poly)

	-- _affiche(poly, "DcNE random Before")

	-- action = 'Action.ShipMission("TF-71", {{"CV-1-1", "CV-1-2", "CV-1-3", "CV-1-4"}}, 10, 8, nil)',

	-- [1] = 'Action.ShipMission("TF-74", { {"TF-74-2", "TF-74-4", "TF-74-5", "TF-74-6"}}, 10, 8, nil)',

	-- [1] = 'Action.ShipMission("TF-71", {  {"TF-71-1", "TF-71-2"}, {"TF-71-3", "TF-71-4"},  {"TF-71-5", "TF-71-6"}}, 10, 8, nil)',


	local maxx = -9999999
	local minx = 9999999
	local maxy = -9999999
	local miny = 9999999
	for n = 1, #arg_poly do
		if arg_poly[n].x > maxx then
			maxx = arg_poly[n].x
		end
		if arg_poly[n].x < minx then
			minx = arg_poly[n].x
		end
		if arg_poly[n].y > maxy then
			maxy = arg_poly[n].y
		end
		if arg_poly[n].y < miny then
			miny = arg_poly[n].y
		end
	end

	-- poly[#poly + 1] = poly[1]

	-- _affiche(poly, "DcNE random After")

	local newpoint = {}

	local n = 1
	local found = false
	repeat

		local i = 1
		repeat
			newpoint = {
				x = math.random(minx, maxx),
				y = math.random(miny, maxy)
			}
			i = i +1

			found = CheckPointInPolygon(newpoint, arg_poly)
		until found or i > 100000

		if not found then
			minx =  minx*(5/100) + minx
			maxx =  maxx*(5/100) + maxx
			miny =  miny*(5/100) + miny
			maxy =  maxy*(5/100) + maxy
		end

		n = n + 1

	until n > 50 or found

	if not found then

		print("minx: "..tostring(minx))
		print("maxx: "..tostring(maxx))
		print("miny: "..tostring(miny))
		print("maxy: "..tostring(maxy))

		print("DcNE impossible found next random point")

	end

	return newpoint
end


--function to assign movement to ship groups
function ShipGroupMovement(GroupName, WPtable, CruiseSpeed, PatrolSpeed, StartTime)

	local poly = {}
	local firstItem = ""

	local testTxt = ""

	if not WindDirection or WindDirection == nil then
		WindDirection = 0
	end

	if type(WPtable) == "table" then
		if WPtable[1] == ""  then
			table.remove(WPtable, 1)
			firstItem = "originalWPT"
		end
		RandomWPtable = WPtable[math.random(1, #WPtable)]
	end

	if WPtable[1] == "" or  WPtable[1] == nil then
		firstItem = "originalWPT"
		table.remove(WPtable, 1)
	end
	if type(WPtable[1]) == "table" and (WPtable[1][1] == "" or  WPtable[1][1] == nil) then
		firstItem = "originalWPT"
		table.remove(WPtable[1], 1)
	end

	if type(WPtable[1]) == "string" then												--WP is a single point marked by trigger zone	
		for w = 1, #WPtable do
			poly[w] = Refpoint[WPtable[w]]
		end
	elseif type(WPtable[1]) == "table" then												--WP is a polygon marked by multiple trigger zones
		--c'est une double table, il ne faut en choisir qu'une seule
		local nWP = math.random(1, #WPtable)

		for w = 1, #WPtable[nWP] do
			poly[w] = Refpoint[WPtable[nWP][w]]
		end
	end

	--melange l'ordre des ZoneWP

	if type(poly) == "table" then
		local shuffled = {}
		for i, v in ipairs(poly) do
			if v ~= "" and v ~= nil then
				local pos = math.random(1, #shuffled+1)
				table.insert(shuffled, pos, v)
			end
		end
		poly = shuffled
	end

	local MaxLoop = 20																		--Maximum Loop to maximizes the distance between two ship turns (recommended : 2)
	--search for ship group
	for coal_name,coal in pairs(oob_ground) do												--go through sides(red/blue)	
		for country_n,country in ipairs(coal) do											--go through countries
			if country.ship then															--country has ships
				for group_n,group in ipairs(country.ship.group) do							--go through groups
					if GroupName == group.name then											--ship group found
						--determine ship route
						local route = {}																		--local table to build group route

						if firstItem == "originalWPT" then														--if the WP string is empty, use the groups initial position
							route[1] = {
								x = group.x,
								y = group.y
							}
						elseif #poly >=3 then
							route[1] = randomPointInPoly(poly)
						else
							route[1] = poly[1]												--store x-y coordnates of that trigger zone
						end

						route[1].time = StartTime

						if #poly == 1 and PatrolSpeed  then				--patrol after route
							route[1].speed = PatrolSpeed													--set speed to patrol speed
						elseif #poly == 1 then
							route[1].speed = 0
						else
							route[1].speed = CruiseSpeed
						end


						--wpt indefini si CV, sinon ils risquent d etre au stop
						-- local QteWptConnu = false
						local nTotal
						if (string.find(group.units[1].name, "CV")  or string.find(group.units[1].name, "LHA") )then
							nTotal = 10
							CruiseSpeed = Data_configuration.CV_Vmax
							PatrolSpeed = Data_configuration.CV_Vmax
						else
							nTotal = #poly																	--pour revenir au code original de Mbot
							-- QteWptConnu = true
						end

						testTxt = ""

						for n = 2, nTotal do																	--go through waypoints table passed as function argument
							--oriente les CV dans le sens du vent au tout d�but
							testTxt = testTxt.." 01 "

							if (n == 2 ) and (string.find(group.units[1].name, "CV")  or string.find(group.units[1].name, "LHA") )then

								if  n == 2 then

									if poly and #poly > 1 then

										local foundWpt_2 = false
										local i_tot = 0

										local i_2 = 0
										local distFctSpeed_2 = Data_configuration.CV_Vmax * (100) *2
										local WptInWind_2 = {}

										local j = 0

										repeat

											distFctSpeed_2 = Data_configuration.CV_Vmax * ( mission_ini.startup_time_player + (mission_ini.startup_time_player/3))
											-- local WptInWind_2 = GetOffsetPoint(route[2], WindDirection, distFctSpeed_2)
											WptInWind_2 = {}
											local j_2 = 0


											repeat

												WptInWind_2 = GetOffsetPoint(route[1], WindDirection , distFctSpeed_2)
												if CheckPointInPolygon(WptInWind_2, poly) == true then
													foundWpt_2 = true
												end

												j_2 = j_2+1
											until foundWpt_2 or j_2 > 10


											if foundWpt_2 then
												route[2] = {
													x = WptInWind_2.x,
													y = WptInWind_2.y,
													speed = Data_configuration.CV_Vmax
												}

												route[2].time = route[1].time + GetDistance(route[1], route[2]) / Data_configuration.CV_Vmax

											end

											i_tot = i_tot+1

											if not foundWpt_2  then
												--si on ne peux pas placer un wpt 2 dans le vent, on bouge le WPT1 et on recommence
												route[1] = randomPointInPoly(poly)
												route[1].time = StartTime
												route[1].speed = CruiseSpeed

												foundWpt_2 = false

											end

										until (foundWpt_2 ) or i_tot >= 500

										if not route[2] then
											route[2] = randomPointInPoly(poly)
										end

									end
								end
							else
								testTxt = testTxt.." 02 "

								if #poly == 1 then												--WP is a single point marked by trigger zone	
									route[n] = poly[1]												--store x-y coordnates of that trigger zone

								elseif #poly == 2 then												--WP is a polygon marked by multiple trigger zones
									local p1 = poly[1]
									local p2 = poly[2]
									local dx = p2.x - p1.x
									local dy = p2.y - p1.y
									local rand = math.random(0, 100)
									route[n] = {
										x = p1.x + dx * rand / 100,
										y = p1.y + dy * rand / 100
									}
								elseif #poly > 2 then														--poly has more than two points

									--get random point within polygon
									-- DC_NE_Debug02	maximizes the distance between two ship turns
									if n >= 4 then
										local distBtw  = {}
										local tabTestWPT = {}
										local maxDistId = 1
										for i = 1 , MaxLoop do
											tabTestWPT[i] = randomPointInPoly(poly)
											distBtw[i] =  GetDistance(route[n - 1], tabTestWPT[i])
											if distBtw[i] > distBtw[maxDistId] then
												maxDistId = i
											end
										end
										route[n] = tabTestWPT[maxDistId]
									else
										route[n] = randomPointInPoly(poly)
									end
								end
							end

							if #poly == 1 and PatrolSpeed  then				--patrol after route

								route[n].speed = tonumber(PatrolSpeed)													--set speed to patrol speed
							elseif #poly == 1 then
								route[n].speed = 0
							else
								route[n].speed = tonumber(CruiseSpeed)
							end

							route[n].time = route[n - 1].time + GetDistance(route[n - 1], route[n]) / CruiseSpeed	--calculate time at waypoint based on speed and distance from previous waypoint

						end

						--ship position at current time
						local CurrentTime = (camp.day - 1) * 86400 + camp.time									--total time in seconds since campaign start
						for n = #route, 1, -1 do																--go through route from back to front
							if route[n].time < CurrentTime then													--check if waypoint time is earlier than current time
								if n == #route then																--waypoint is last waypoint
									if PatrolSpeed and #poly >= 2  then					--patrol after route
										route[n].speed = PatrolSpeed											--set speed to patrol speed
									else
										route[n].speed = 0														--set speed to zero
									end
									route[n].time = CurrentTime
								else
									local TimePassed = CurrentTime - route[n].time								--time since passed last waypoint
									local DistancePassed = TimePassed * route[n].speed							--distance covered since passed last waypoint
									local heading = GetHeading(route[n], route[n + 1])							--heading from last to next waypoint
									route[n].x = route[n].x + math.cos(math.rad(heading)) * DistancePassed		--update last waypoint to position at current time
									route[n].y = route[n].y + math.sin(math.rad(heading)) * DistancePassed		--update last waypoint to position at current time
								end
								for w = n - 1, 1, -1 do															--go throut all waypoints ahead of waypoint at current time
									table.remove(route, w)														--remove these waypoints
								end
								break
							end
						end

						--patrol zone at end of route
						if PatrolSpeed and PatrolSpeed > 0 then													--if there is a patrol speed assigned, ship should patrol at end of route
							while route[#route].time < CurrentTime + mission_ini.mission_duration * 2 do			--repeat as long as last waypoint time is within twice the mission duration
								local nextWP																--next waypoint
								if #poly == 2 then												--poly has two points only, patrol between these two points
									if #route % 2 == 0 then													--even
										nextWP = poly[1]
									else																	--uneven
										nextWP = poly[2]
									end
								elseif #poly > 2 then											--poly has more than two points, patrol in random pattern within this polygon
									local distBtw  = {}
									local tabTestWPT = {}
									local maxDistId = 1
									for i = 1 , MaxLoop do
										tabTestWPT[i] = randomPointInPoly(poly)
										distBtw[i] =  GetDistance(route[#route], tabTestWPT[i])
										if distBtw[i] > distBtw[maxDistId] then
											maxDistId = i
										end
									end

									nextWP = tabTestWPT[maxDistId]
								end


								local nextTime = route[#route].time + GetDistance(route[#route], nextWP) / PatrolSpeed	--time at next waypoint

								route[#route + 1] = {
									x = nextWP.x,
									y = nextWP.y,
									speed = PatrolSpeed,
									time =  nextTime
								}


							end
						end

						--suppression des doublons
						if #route > 1 then
							for n = 2, #route do
								if route[n-1] and route[n] then
									if (route[n-1].x ==   route[n].x) and (route[n-1].y ==   route[n].y) then
										table.remove(route, n )
									end
								else
									break
								end
							end
						end

						--DC_NE_Debug01	transforms an angle of more than 90� into 2 WPT of less than 90�
						-- tablWPT = {} utilité?
						local routeModif = {}
						if #route > 1 then
							routeModif[1] = route[1]
							for n = 2, #route-1 do
								local waypoint = {}
								local h1 = GetHeading(route[n-1], route[n] )
								local h2 = GetHeading(route[n], route[n+1] )
								local angle = GetDeltaHeading(h1, h2)
								local bearing = 0

								if (angle > 90 or angle < -90)  then
								-- if (angle >= 90 or angle <= -90) and (angle ~= 180 or angle ~= -180) then

									if angle >= 90 then bearing = h1 - 90
										-- print("DcNE passe CC passe (bearing = h1 - 90) "..bearing.." = "..h1.." - 90")

									elseif angle <= -90 then bearing = h1 + 90
										-- print("DcNE passe DD passe (bearing = h1 + 90) "..bearing.." = "..h1.." + 90")

									end
									local intercalWP = GetOffsetPoint(route[n], bearing, 3000)
									waypoint = {
										x = intercalWP.x,
										y = intercalWP.y,
										speed = PatrolSpeed,
										time =  0
									}

									table.insert(routeModif, waypoint )
								end

								if  angle ~= 0  then
									table.insert(routeModif, route[n] )
								end
							end
							-- if  angle ~= 0  then
							-- 	table.insert(routeModif, route[n] )
							-- 	-- print("DcNE _03_ #routeModif "..tostring(#routeModif))
							-- end
						end

						if #route > 1 then
							route = {}
							route = Deepcopy(routeModif)
						end

						--recalcul les timmings en fonction des nouveaux wpt ajout�
						local addTime
						if #route > 1 then
							addTime = route[1].time
							for n = 1, #route-1 do
								addTime = addTime + GetDistance(route[n], route[n+1]) / route[n].speed	--time at next waypoint
								route[n+1]["time"] = addTime
							end
						end


						--group initial position
						group.x = route[1].x
						group.y = route[1].y

						--units in group initial position and heading
						local delta_heading = 0												--change of heading between initial leader heading as per base_mission and actual heading at start of route
						local PaHeading = 0
						if route[2] then													--if there is more than one waypoint
							delta_heading = GetHeading(route[1], route[2]) - math.deg(group.units[1].heading)		--difference between heading as per base_mission and actual heading at start of route
							PaHeading = math.rad(GetHeading(route[1], route[2]))

						end
						local dx = 0
						local dy = 0

						for u = 2, #group.units do											--go through all units in group after the leader
							local bearing_from_leader = GetHeading(group.units[1], group.units[u])		--unit bearing from leader
							bearing_from_leader = bearing_from_leader + delta_heading					--update bearing from leader by change of group heading
							local distance_from_leader = GetDistance(group.units[1], group.units[u])	--unit distance from leader
							dx = math.cos(math.rad(bearing_from_leader)) * distance_from_leader	--x component from leader
							dy = math.sin(math.rad(bearing_from_leader)) * distance_from_leader	--y component from leader

							group.units[u].x = route[1].x + dx								--unit initial position relative to leader
							group.units[u].y = route[1].y + dy								--unit initial position relative to leader
							if route[2] then												--if there is more than one waypoint
								group.units[u].heading = PaHeading		--update initial unit heading
							end
						end

						--check for linked static units	
						if country.static then												--side has static units	
							for u = 1, #group.units do										--go through all units in group
								for static_n, static in ipairs(country.static.group) do		--go through static groups								
									if static.route.points[1].linkUnit and static.route.points[1].linkUnit == group.units[u].unitId then	--static unit is linked to ship
										local bearing_from_leader = GetHeading(group.units[1], static)				--static bearing from leader

										bearing_from_leader = bearing_from_leader + delta_heading					--update bearing from leader by change of group heading
										local distance_from_leader = GetDistance(group.units[1], static)			--unit distance from leader
										dx = math.cos(math.rad(bearing_from_leader)) * distance_from_leader	--x component from leader
										dy = math.sin(math.rad(bearing_from_leader)) * distance_from_leader	--y component from leader
										static.x = route[1].x + dx													--new static position
										static.y = route[1].y + dy
										static.units[1].x = static.x
										static.units[1].y = static.y
										static.route.points[1].x = static.x
										static.route.points[1].y = static.y
										-- static.heading = static.units[1].heading + math.rad(delta_heading)			--new static heading
										-- static.units[1].offsets.angle = static.heading							-- l'angle offsets doit rester identique
										static.heading = static.units[1].offsets.angle + PaHeading					-- debugC Angle et Bearing des statics sur PA
										static.units[1].heading = static.heading
									end
								end
							end
						end

						group.units[1].x = route[1].x										--leader initial position
						group.units[1].y = route[1].y										--leader initial position
						if route[2] then													--if there is more than one waypoint
							group.units[1].heading = PaHeading			--update initial leader heading
						end

						--group route
						group.route.points[1].x = route[1].x
						group.route.points[1].y = route[1].y
						group.route.points[1].speed = route[1].speed
						for n = 2, #route do												--go through route waypoints to assign
							group.route.points[n] = {
								["type"] = "Turning Point",
								["alt"] = 0,
								["alt_type"] = "BARO",
								["formation_template"] = "",
								["y"] = route[n].y,
								["x"] = route[n].x,
								["name"] = "",
								["ETA_locked"] = false,
								["ETA"] = 0,
								["speed_locked"] = true,
								["speed"] = route[n].speed,
								["action"] = "Turning Point",
								["task"] = {
									["id"] = "ComboTask",
									["params"] = {
										["tasks"] = {},
									},
								},
							}
						end
						for n = #group.route.points, #route + 1, -1 do
							group.route.points[n] = nil										--clear the group's route points after the last waypoint (it might inherit from an old route)
						end

						--airbase (carrier) position
						for basename,base in pairs(db_airbases) do							--go through airbases
							for u = 1, #group.units do										--go through units in group

								-- print("DcNE passe BA base.unitname "..tostring(base.unitname).." uName "..tostring(group.units[u].name).." u: "..u )

								if base.unitname == group.units[u].name then				--if unit is an airbase (carrier)	
									base.x = group.units[u].x								--update airbase (carrier) position
									base.y = group.units[u].y								--update airbase (carrier) position
									-- print("DcNE passe BB "..base.unitname.." "..base.x)
								end

								--dans le cas, où il y aurait 2 CV dans le group
								if u > 1 and base.unitname == group.units[u].name then				--if unit is an airbase (carrier)	
									base.x = group.units[1].x								--update airbase (carrier) position
									base.y = group.units[1].y								--update airbase (carrier) position
									-- print("DcNE passe BC "..base.unitname.." "..base.x)
								end
							end
						end
					end
				end
			end
		end
	end
end

--go through ship missions and execute them
if camp.ShipMissions == nil then															--storage table for ship missions in camp doesn't exist yet
	camp.ShipMissions = {}																	--create it
end
for GroupName,entry in pairs(camp.ShipMissions) do
	-- ShipGroupMovement(GroupName, entry.WPtable, entry.CruiseSpeed, entry.PatrolSpeed, entry.StartTime)	--execute ship mission
	ShipGroupMovement(GroupName, entry.WPtable, entry.CruiseSpeed, entry.PatrolSpeed, CampTotalTimeS)	--execute ship mission
end

--update aircraft carriers in db_airbase table and enable CarrierIntoWindScript for carrier

for basename,base in pairs(db_airbases) do															--iterate through airbases
	if base.unitname then																			--if airbase is a carrier, find the unit in the OOB Ground
		-- print("DcNE C unitName "..tostring(base.unitname) )
		
		for coal_name,coal in pairs(oob_ground) do													--go through sides(red/blue)	
			for country_n,country in ipairs(coal) do												--go through countries
				if country.ship then																--country has ships
					for groupn,group in pairs(country.ship.group) do								--group table
						for unitn,unit in pairs(group.units) do										--units table
							if unit.name == base.unitname then										--respective unit found
								-- print("DcNE J unit.name "..tostring(unit.name) )
							
								base.airdromeId = unit.unitId
								base.x = unit.x
								base.y = unit.y
								base.elevation = 0
								if not base.ATC_frequency then										--modification M33.e 	Custom Briefing (e: CV Manual Freq)								
									base.ATC_frequency = tostring(unit.frequency / 1000000)			--si ATC_frequency non present dans db_airbases, on prend la freq de base_mission
								else
									unit.frequency = base.ATC_frequency * 1000000
								end
								--get carrier TACAN and ICLS
								for taskn,task in ipairs(group.route.points[1].task.params.tasks) do	--go through group tasks in first waypoint
									if task.params then
										if task.params.action then
											if task.params.action.id == "ActivateBeacon" then		--has beacon
												if task.params.action.params.channel and task.params.action.params.modeChannel and task.params.action.params.callsign then						--beacon is TACAN
													base.TACAN = task.params.action.params.channel .. task.params.action.params.modeChannel .. " / " .. task.params.action.params.callsign		--store tacan channel and callsign in airbase entry
												end
											elseif task.params.action.id == "ActivateICLS" then		--has ICLS
												base.icls = task.params.action.params.channel		--store ICLS channel in airbase entry
											end
										end
									end
								end

								if string.lower(mission_ini.SC_CarrierIntoWind) == "auto" then											-- modification M36.d	(d: add timer) MenuRadio request manual TurnIntoWind
									--add mission trigger to add carrier to CarrierIntoWindScript (turn into wind during flight ops)
									local trig_n = #mission.trig.funcStartup + 1
									mission.trig.funcStartup[trig_n] = "if mission.trig.conditions[" .. trig_n .. "]() then mission.trig.actions[" .. trig_n .. "]() end"
									mission.trig.flag[trig_n] = true
									mission.trig.conditions[trig_n] = "return(true)"
									-- mission.trig.actions[trig_n] = 'a_do_script(\\\"CarrierIntoWind(\\\\\\"' .. group.name .. '\\\\\\")\\\"); mission.trig.funcStartup[' .. trig_n .. ']=nil;'

									mission.trig.actions[trig_n] = "a_do_script('CarrierIntoWind(\\\"" .. group.name .. "\\\")'); mission.trig.funcStartup[" .. trig_n .. "]=nil;"

									mission.trigrules[trig_n] = {
										["rules"] = {},
										["eventlist"] = "",
										["comment"] = "Trigger " .. trig_n,
										["predicate"] = "triggerStart",
										["actions"] = {
											[1] = {
												["predicate"] = "a_do_script",
												["text"] = "CarrierIntoWind('" .. group.name .. "')",
												["KeyDict_text"] = "CarrierIntoWind('" .. group.name .. "')",
												["ai_task"] =
												{
													[1] = "",
													[2] = "",
												},
											},
										},
									}
								end

								-- print("DcNE Zbase.x "..tostring(base.x) )

							end
						end
					end
				end
			end
		end
	end
end

-- modification M11 : Multiplayer													-- pour donner de la place sur le PA, on supprime, � la demande, les statics pr�sent
function DeleteStaticOnCV(GroupName)

	--search for ship group
	for coal_name,coal in pairs(oob_ground) do												--go through sides(red/blue)	
		for country_n,country in ipairs(coal) do											--go through countries
			if country.ship then															--country has ships
				for shipGroupN,group in ipairs(country.ship.group) do							--go through groups
					if GroupName == group.units[1].name then								--ship group found

						--check for linked static units	
						if country.static then												--side has static units	
							for static_n, _static in ipairs(country.static.group) do		--go through static groups								
								if _static.route.points[1].linkUnit and _static.route.points[1].linkUnit == group.units[1].unitId then	--static unit is linked to ship
									for staticGgroupN, _group in ipairs(mission.coalition[coal_name].country[country_n].static.group) do

										if _group.units[1].unitId == _static.units[1].unitId then

											if Debug.debug then
												print("DcNE CleanDeck remove Static "..tostring(_group.units[1].type)..""..tostring(_group.units[1].name))
											end

											local val = table.remove(mission.coalition[coal_name].country[country_n].static.group, staticGgroupN)
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
end
