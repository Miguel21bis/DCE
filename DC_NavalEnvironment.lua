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
-- function ShipGroupMovement(groupName, wpTable, cruiseSpeed, patrolSpeed, startTime)

-- 	print("DcNE ShipGroupMovement A groupName "..tostring(groupName))

-- 	local poly = {}
-- 	local firstItem = ""

-- 	local testTxt = ""

-- 	if not WindDirection or WindDirection == nil then
-- 		WindDirection = 0
-- 	end

-- 	if type(wpTable) == "table" then
-- 		if wpTable[1] == ""  then
-- 			table.remove(wpTable, 1)
-- 			firstItem = "originalWPT"
-- 		end
-- 		randomWPtable = wpTable[math.random(1, #wpTable)]
-- 	end

-- 	if wpTable[1] == "" or  wpTable[1] == nil then
-- 		firstItem = "originalWPT"
-- 		table.remove(wpTable, 1)
-- 	end
-- 	if type(wpTable[1]) == "table" and (wpTable[1][1] == "" or  wpTable[1][1] == nil) then
-- 		firstItem = "originalWPT"
-- 		table.remove(wpTable[1], 1)
-- 	end

-- 	if type(wpTable[1]) == "string" then												--WP is a single point marked by trigger zone	
-- 		for w = 1, #wpTable do
-- 			poly[w] = Refpoint[wpTable[w]]
-- 		end
-- 	elseif type(wpTable[1]) == "table" then												--WP is a polygon marked by multiple trigger zones
-- 		--c'est une double table, il ne faut en choisir qu'une seule
-- 		local nWP = math.random(1, #wpTable)

-- 		for w = 1, #wpTable[nWP] do
-- 			poly[w] = Refpoint[wpTable[nWP][w]]
-- 		end
-- 	end

-- 	--melange l'ordre des ZoneWP

-- 	if type(poly) == "table" then
-- 		local shuffled = {}
-- 		for i, v in ipairs(poly) do
-- 			if v ~= "" and v ~= nil then
-- 				local pos = math.random(1, #shuffled+1)
-- 				table.insert(shuffled, pos, v)
-- 			end
-- 		end
-- 		poly = shuffled
-- 	end
function ShipGroupMovement(groupName, wpTable, cruiseSpeed, patrolSpeed, startTime)
    print("DcNE ShipGroupMovement A groupName " .. tostring(groupName))

    if type(wpTable) ~= "table" or #wpTable == 0 then return end

    local poly = {}
    
    -- 1. Nettoyage initial : on enlève les entrées vides au début proprement
    while #wpTable > 0 and (wpTable[1] == "" or wpTable[1] == nil) do
        table.remove(wpTable, 1)
    end

    if #wpTable == 0 then return end -- Sécurité si la table est devenue vide

    -- 2. Détermination du type de structure
    if type(wpTable[1]) == "string" then
        -- Cas simple : liste de points directement
        for w = 1, #wpTable do
            if Refpoint[wpTable[w]] then
                table.insert(poly, Refpoint[wpTable[w]])
            end
        end
    elseif type(wpTable[1]) == "table" then
        -- Cas complexe : On choisit UNE sous-table parmi celles dispo
        local nWP = math.random(1, #wpTable)
        local selectedSubTable = wpTable[nWP]

        for w = 1, #selectedSubTable do
            local pointName = selectedSubTable[w]
            if pointName ~= "" and pointName ~= nil and Refpoint[pointName] then
                table.insert(poly, Refpoint[pointName])
            end
        end
    end

    -- 3. Mélange (Shuffle)
    local shuffled = {}
    for i = 1, #poly do
        local pos = math.random(1, #shuffled + 1)
        table.insert(shuffled, pos, poly[i])
    end
    poly = shuffled

	local maxLoop = 20																		--Maximum Loop to maximizes the distance between two ship turns (recommended : 2)
	--search for ship group
	for coal_name,coal in pairs(oob_ground) do												--go through sides(red/blue)	
		for country_n,country in ipairs(coal) do											--go through countries
			if country.ship then															--country has ships
				for group_n,group in ipairs(country.ship.group) do							--go through groups
					if groupName == group.name then											--ship group found
					print("DcNE ShipGroupMovement B groupName "..tostring(groupName).." found, start movement")	
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

						route[1].time = startTime

						if #poly == 1 and patrolSpeed  then				--patrol after route
							route[1].speed = patrolSpeed													--set speed to patrol speed
							AddLog("(a)This group of boats has only one WPT and won't move; is that normal?: "..tostring(groupName))
						elseif #poly == 1 then
							route[1].speed = 0
							AddLog("(b)This group of boats has only one WPT and won't move; is that normal?: "..tostring(groupName))
						else
							route[1].speed = cruiseSpeed
						end


						--wpt indefini si CV, sinon ils risquent d etre au stop
						-- local QteWptConnu = false
						local nTotal
						if (string.find(group.units[1].name, "CV")  or string.find(group.units[1].name, "LHA") )then
							nTotal = 10
							cruiseSpeed = Data_configuration.CV_Vmax
							patrolSpeed = Data_configuration.CV_Vmax
						-- else
						-- 	nTotal = #poly																	--pour revenir au code original de Mbot
						-- 	-- QteWptConnu = true
						-- end
						else
							-- Si on veut au moins un mouvement, on peut forcer nTotal 
							-- à une valeur fixe ou au nombre de points dans le polygone choisi.
							
							nTotal = #poly
							AddLog("DCNE (c1)  nTotal: "..nTotal)

							if nTotal == 1 then 
								-- Si le polygone n'a qu'un point, on force quand même 
								-- quelques répétitions pour le patrouillage
								nTotal = 4 
								AddLog("DCNE (c2) ancien Blocage nTotal: "..nTotal)
							end
						end

						local testTxt = ""

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
												route[1].time = startTime
												route[1].speed = cruiseSpeed

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

								if #poly == 1 then

									--Pourquoi : plusieurs WPT identiques donnent une distance nulle,
									--donc les bateaux restent immobiles dans DCS.
									--On crée donc un léger offset aléatoire autour du point.
									local offset = 1500

									route[n] = {
										x = poly[1].x + math.random(-offset, offset),
										y = poly[1].y + math.random(-offset, offset)
									}

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
										for i = 1 , maxLoop do
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

							if #poly == 1 and patrolSpeed  then				--patrol after route

								route[n].speed = tonumber(patrolSpeed)													--set speed to patrol speed
							elseif #poly == 1 then
								route[n].speed = 0
							else
								route[n].speed = tonumber(cruiseSpeed)
							end

							AddLog(
								"DCNE TIMECALC n="..n
								.." dist="..tostring(GetDistance(route[n - 1], route[n]))
								.." cruiseSpeed="..tostring(cruiseSpeed)
								.." routeSpeed="..tostring(route[n].speed)
							)

							route[n].time = route[n - 1].time + GetDistance(route[n - 1], route[n]) / cruiseSpeed	--calculate time at waypoint based on speed and distance from previous waypoint

						end

						--ship position at current time
						-- local currentTime = (camp.day - 1) * 86400 + camp.time									--total time in seconds since campaign start
						
						AddLog("DCNE M #route "..#route)

						
						local currentTime = (camp.date.day - 1) * 86400 + camp.time
						for n = #route, 1, -1 do																--go through route from back to front
							if route[n].time < currentTime then													--check if waypoint time is earlier than current time
								if n == #route then																--waypoint is last waypoint
									if patrolSpeed and #poly >= 2  then					--patrol after route
										route[n].speed = patrolSpeed											--set speed to patrol speed
									else
										route[n].speed = 0														--set speed to zero
									end
									route[n].time = currentTime
								else
									local timePassed = currentTime - route[n].time								--time since passed last waypoint
									local distancePassed = timePassed * route[n].speed							--distance covered since passed last waypoint
									local heading = GetHeadingDegre(route[n], route[n + 1])							--heading from last to next waypoint
									route[n].x = route[n].x + math.cos(math.rad(heading)) * distancePassed		--update last waypoint to position at current time
									route[n].y = route[n].y + math.sin(math.rad(heading)) * distancePassed		--update last waypoint to position at current time
								end
								for w = n - 1, 1, -1 do															--go throut all waypoints ahead of waypoint at current time
									table.remove(route, w)														--remove these waypoints
								end
								break
							end
						end

						AddLog("DCNE N #route "..#route)

						--patrol zone at end of route
						if patrolSpeed and patrolSpeed > 0 then													--if there is a patrol speed assigned, ship should patrol at end of route
							while route[#route].time < currentTime + mission_ini.mission_duration * 2 do			--repeat as long as last waypoint time is within twice the mission duration
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
									for i = 1 , maxLoop do
										tabTestWPT[i] = randomPointInPoly(poly)
										distBtw[i] =  GetDistance(route[#route], tabTestWPT[i])
										if distBtw[i] > distBtw[maxDistId] then
											maxDistId = i
										end
									end

									nextWP = tabTestWPT[maxDistId]
								end


								local nextTime = route[#route].time + GetDistance(route[#route], nextWP) / patrolSpeed	--time at next waypoint

								route[#route + 1] = {
									x = nextWP.x,
									y = nextWP.y,
									speed = patrolSpeed,
									time =  nextTime
								}


							end
						end

						AddLog("DCNE R #route "..#route)

						--suppression des doublons
						--Pourquoi : avec un seul point de patrouille (#poly == 1),
						--on génère volontairement plusieurs WPT proches pour forcer un mouvement.
						--Il ne faut donc PAS supprimer ces points.
						if #route > 1 and #poly > 1 then

							local n = 2

							while n <= #route do

								if route[n-1] and route[n] then

									if (route[n-1].x == route[n].x)
									and (route[n-1].y == route[n].y) then

										table.remove(route, n)

										AddLog("DCNE (o) suppression doublon n "..n)

									else
										n = n + 1
									end

								else
									break
								end
							end
						end

						AddLog("DCNE P #route "..#route)

						--DC_NE_Debug01	transforms an angle of more than 90� into 2 WPT of less than 90�
						-- tablWPT = {} utilité?
						local routeModif = {}
						if #route > 1 then
							routeModif[1] = route[1]
							for n = 2, #route-1 do

								local waypoint = {}
								local h1 = GetHeadingDegre(route[n-1], route[n] )
								local h2 = GetHeadingDegre(route[n], route[n+1] )
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
										speed = patrolSpeed,
										time =  0
									}

									table.insert(routeModif, waypoint )
								end

								if angle ~= 0 then
									table.insert(routeModif, route[n] )
								end
							end

							--Ajout du dernier waypoint
							--Pourquoi : le dernier point n'était jamais réinjecté
							--dans routeModif.
							table.insert(routeModif, route[#route])

							AddLog("DCNE FIX #routeModif "..#routeModif)

							-- if angle ~= 0  then
							-- 	table.insert(routeModif, route[n] )
							-- 	-- print("DcNE _03_ #routeModif "..tostring(#routeModif))
							-- end
						end

						AddLog("DCNE Q1 #route "..#route)
						AddLog("DCNE Q2 #routeModif "..#routeModif)

						if #route > 1 then
							route = {}
							route = DeepCopy(routeModif)
						end

						AddLog("DCNE S #route "..#route)

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
							delta_heading = GetHeadingDegre(route[1], route[2]) - math.deg(group.units[1].heading)		--difference between heading as per base_mission and actual heading at start of route
							PaHeading = math.rad(GetHeadingDegre(route[1], route[2]))

						end
						local dx = 0
						local dy = 0

						for u = 2, #group.units do											--go through all units in group after the leader
							local bearing_from_leader = GetHeadingDegre(group.units[1], group.units[u])		--unit bearing from leader
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
										local bearing_from_leader = GetHeadingDegre(group.units[1], static)				--static bearing from leader

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

						AddLog("DCNE DEBUG FINAL ROUTE COUNT = "..tostring(#route))

						for i = 1, #route do

							AddLog(
								"DCNE ROUTE["..i.."] "
								.."x="..tostring(route[i].x)
								.." y="..tostring(route[i].y)
								.." speed="..tostring(route[i].speed)
								.." time="..tostring(route[i].time)
							)

						end

						if #route <=1 then
							os.remove("Debug/BugList.lua")

							if BugList and type(BugList) == "table" and #BugList >= 1 then
								local table_Str = "BugList = " .. TableSerialization(BugList, 0)
								local bugFile = io.open("Debug/BugList.lua", "w") or error("Failed to open debug file")
								bugFile:write(table_Str)
								bugFile:close()
							end

							os.execute('start "BugList" "notepad.exe" "Debug/BugList.lua"')
							os.execute 'pause'
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

								print("DcNE passe BA base.unitname "..tostring(base.unitname).." uName "..tostring(group.units[u].name).." u: "..u )

								if base.unitname == group.units[u].name then				--if unit is an airbase (carrier)	
									base.x = group.units[u].x								--update airbase (carrier) position
									base.y = group.units[u].y								--update airbase (carrier) position
									print("DcNE passe BB "..base.unitname.." "..base.x)
								end

								--dans le cas, où il y aurait 2 CV dans le group
								if u > 1 and base.unitname == group.units[u].name then				--if unit is an airbase (carrier)	
									base.x = group.units[1].x								--update airbase (carrier) position
									base.y = group.units[1].y								--update airbase (carrier) position
									print("DcNE passe BC "..base.unitname.." "..base.x)
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

function MajPosition()
	-- print("DcNE MajPosition")
	for groupName,entry in pairs(camp.ShipMissions) do
		-- ShipGroupMovement(GroupName, entry.WPtable, entry.CruiseSpeed, entry.PatrolSpeed, entry.StartTime)	--execute ship mission
		ShipGroupMovement(groupName, entry.WPtable, entry.CruiseSpeed, entry.PatrolSpeed, CampTotalTimeS)	--execute ship mission
	end


	--update aircraft carriers in db_airbase table and enable CarrierIntoWindScript for carrier

	for basename,base in pairs(db_airbases) do															--iterate through airbases
		-- print("DcNE update_aircraft_carriers A basename: "..tostring(basename).." unitname: "..tostring(base.unitname))
		
		if base.unitname then																			--if airbase is a carrier, find the unit in the OOB Ground
			-- print("DcNE update_aircraft_carriers B base.unitname : " ..tostring(base.unitname))
			
			for coal_name,coal in pairs(oob_ground) do													--go through sides(red/blue)	
				-- print("DcNE update_aircraft_carriers C")
				for country_n,country in ipairs(coal) do												--go through countries
					-- print("DcNE update_aircraft_carriers D")
					if country.ship then																--country has ships
						-- print("DcNE update_aircraft_carriers E")
						for groupn,group in pairs(country.ship.group) do								--group table
							-- print("DcNE update_aircraft_carriers F")
							for unitn,unit in pairs(group.units) do										--units table
								-- print("DcNE update_aircraft_carriers G")
								if unit.name == base.unitname then										--respective unit found
									-- print("DcNE update_aircraft_carriers -> H unit.name "..tostring(unit.name) )
								
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

MajPosition()		--execute ship missions at mission start
