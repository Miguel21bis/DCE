-- Auteur: Tomsk
-- https://forums.eagle.ru/showpost.php?p=3525106&postcount=753
-- Pruning can improve the performance of the mission by removing units that are very unlikely to participate in it.
--
-- In particular this varies depending on.
--  Whether the unit is an anti-air unit (of various types) or not.
-- How close any flight passes to the unit when that flight is flying along the waypoints.
-- Whether that unit is close to any 'Target' or 'Attack' waypoint
-------------------------------------------------------------------------------------------------------
-- last modification: cleancode_b
if not versionDCE then versionDCE = {} end
versionDCE["DC_Prune.lua"] = "1.7.25"
-------------------------------------------------------------------------------------------------------
-- Reglage_g		(g targetList_InThisMission)(f debug file)(g add 9A33)(f ZSU_57_2)(e dont prune target mission)(d unit FARP)(c: scud)(b: add FPS-117 & FUG & FUSE) (a: ajust PruneScriptConf)
-- debug_g			(g function entry)(f: keept EWR)(e: prune category tag)(d: Static Plane Bug + Heli)(c: Package avion supprimé)(b: FARP)(a: helicopter)
-- cleancode_b		(a springCleaning)
-- M23_a			Désactive USN Mod
-- M21_a			Ajout Convoy (interdit à Prune de les Pruner..)
-- Z02_a			DontPrunSAM et prend en compte la position des intercepteur qui n'ont qu'un seul waypoint
-- M16_d			SpawnAir, & insert pos far target
-------------------------------------------------------------------------------------------------------

local cibleTrouve = {}

local pruneScript =				mission_ini.PruneScriptConf.PruneScript
local pruneAggressiveness =		mission_ini.PruneScriptConf.PruneAggressiveness
local pruneStatic =				mission_ini.PruneScriptConf.PruneStatic
local pruneSam =				mission_ini.PruneScriptConf.ForcedPruneSam

-- Liste des mots-clés à pruner
-- local pruneKeywords = { "bag", "wall", "sand", "camouflage", "barrier", "container", "tent", "cargo", "soldier" , "vc_" }
local pruneKeywords = { }
-- Liste des mots-clés à garder
local keepKeywords = { "farp", "dallas", "paris" }

-- work out which side has 'players'
local function findPlayerSide()
	for side,units in pairs(oob_air) do
		for ui,unit in pairs(units) do
			if unit.player then return side end
		end
	end
	return nil
end

local playerSide = findPlayerSide()


-- M16 : SpawnAir, & insert pos far target 
-- array de tous les groups vehicle pour rechercher ceux qui seront des targets designés afin de les protéger de Prune
local function GroundGroupId()
	local allGroundGroupId = {}
	for side, ncountry in pairs(oob_ground ) do
		for nc, country in pairs(ncountry ) do
			if country["vehicle"] then
				for vi,vehicle in pairs(country) do
					if 	type(vehicle) == "table" then
						for gi,ngroup in pairs(vehicle["group"]) do
							if ngroup["groupId"] then
								allGroundGroupId[ngroup["groupId"]] = {}
								allGroundGroupId[ngroup["groupId"]].x = ngroup["x"]
								allGroundGroupId[ngroup["groupId"]].y = ngroup["y"]
								allGroundGroupId[ngroup["groupId"]].name = ngroup["name"]
							end
						end
					end
				end
			end
		end
	end
	return allGroundGroupId
end

-- given a unit return the anti-air type of an unit: SHORT, MEDIUM, LONG, IR, AAA or NONE.
local function unitAntiAirType(unit)
	-- List reduced from https://forums.eagle.ru/showthread.php?t=174971
	local types = {
		["2S6 Tunguska"]="MEDIUM",	-- 12km
		["Tor 9A331"]="MEDIUM",		-- 12km
		["Strela-10M3"]="IR",		-- 5km
		["Strela-1 9P31"]="IR",		-- 5km
		["SA-8 Osa LD 9T217"]="SHORT",	-- 7km
		["Osa 9A33 ln"]="SHORT",	-- 7km
		["Gepard"]="AAA",				-- 5km
		["SA-18 Igla manpad"]="IR",		-- 5km
		["Igla manpad INS"]="IR",		-- 5km
		["SA-18 Igla-S manpad"]="IR",	-- 5km
		["Vulcan"]="AAA",				-- 2.5km
		["M48 Chaparral"]="IR",			-- 9km
		["M6 Linebacker"]="IR",  		-- 8km
		["M1097 Avenger"]="IR",			-- 7km
		["Stinger manpad GRG"]="IR",	-- 8km
		["Stinger manpad dsr"]="IR",	-- 8km
		["Stinger manpad"]="IR",		-- 8km
		["ZSU_57_2"]="SHORT",			-- 5km
		["ZSU-23-4 Shilka"]="SHORT",			-- 2.5km
		["ZU-23 Emplacement Closed"]="AAA",		-- 2.0km
		["ZU-23 Emplacement"]="AAA",			-- 2.0km
		["ZU-23 Closed Insurgent"]="AAA",		-- 2.0km
		["Ural-375 ZU-23 Insurgent"]="AAA",		-- 2.0km
		["ZU-23 Insurgent"]="AAA",				-- 2.0km
		["Ural-375 ZU-23"]="AAA",				-- 2.0km
		["1L13 EWR"]="LONG",					-- EWR: 200km
		["Kub 1S91 str"]="MEDIUM",				-- 25.0 km
		["S-300PS 40B6M tr"]="LONG",			-- 100km
		["S-300PS 40B6MD sr"]="LONG",			-- 100km
		["55G6 EWR"]="LONG",					-- 200km
		["FPS-117 Dome"]="LONG",				-- 200km
		["FPS-117"]="LONG",						-- 200km
		["S-300PS 64H6E sr"]="LONG",			-- 100km
		["SA-11 Buk SR 9S18M1"]="LONG",			-- 100km
		["Dog Ear radar"]="SHORT",				-- 5km
		["Hawk tr"]="LONG",						-- 50km
		["Hawk sr"]="LONG",						-- 50km
		["Patriot str"]="LONG",					-- 150km
		["Hawk cwar"]="LONG",					-- 50km
		["p-19 s-125 sr"]="MEDIUM",				-- 35km
		["Roland Radar"]="SHORT",				-- 8km
		["snr s-125 tr"]="MEDIUM",				-- 35km
		["FuMG-401"]="MEDIUM",				-- 8km
		["FuSe-65"]="MEDIUM",				-- 8km

	}
	local got = types[unit.type]
	return (got or "NONE")
end

local function stringStarts(str, start)
	str = string.lower(str)
	start = string.lower(start)
	if str == nil then
		return false
	else
	-- print(" str: "..str.." |start:"..start.." ||subLen: "..string.sub(str,1,string.len(start)))
		return string.sub(str,1,string.len(start)) == start
	end
end

-- iterate through all consecutive pairs of waypoints
local function waypointPairs(wps, f)
	local wi = 1
	while (wps[wi]) do
		local wp = wps[wi]
		local nextWi = wi + 1
		local found = false
		while (wps[nextWi]) do
			local np = wps[nextWi]
			if (np.x ~= wp.x) or (np.y ~= wp.y) then
				found = true
				wi = nextWi
				f(wp, np)
				break
			end
			nextWi = nextWi + 1
		end
	 -- Z02 : SAM ajoute un waypoint sur les intercepteurs (qui n'ont qu'un seul waypoint) pour éviter de supprimer les unité proche
-- TODO fonction a déplacer dans ATO_FlightPlan
		if wi <= 1 and (wps[1].name == "Intercept" or wps[1].name == "SAR") then
			local np = wps[1]
			np.x = wp.x + 5000
			np.y = wp.y + 5000
			found = true
			f(wp, np)
			-- print("PruneIntercepteurIntercept"..np.x)
			break
		end
		if not found then return end
	end
end

-- juste avant la fonction keepGroundUnit, tu déclares :
local function isPruneKeyword(lowCaseName)
    for _, kw in ipairs(pruneKeywords) do
        if string.find(lowCaseName, kw) then
			--garde les mots clés pour les garder
			for _, keepKw in ipairs(keepKeywords) do
				if string.find(lowCaseName, keepKw) then
					-- print("DC_P_T  Keep keyword: "..lowCaseName)
					return false -- ne pas pruner si on trouve un mot clé de la liste des mots clés à garder
				end
			end
			return true

		end
    end
    return false
end

-- decides whether the given ground unit (which is on side 'unitSide') should be kept or not
local function keepGroundUnit(unit, unitSide, allWaypoints, allGroundGroupId, category)

	if TargetList_InThisMission[unit.name] then

		return true
	end

	local lowCaseName = string.lower(unit.name)

	if pruneStatic and (category == 'plane' or category == 'helicopter') and stringStarts(unit.name, 'Static') then
		-- print("DC_P_T  Prune static planes "..unit.name )
		return false -- Prune static planes
	elseif  (category == 'plane' or category == 'helicopter') and not string.find(unit.name,"Static") then
		-- print("DC_P_T  keep plane and helicopter: "..unit.name )
		return true -- keep plane and helicopter
	elseif  stringStarts(unit.name,"Pack") and not string.find(unit.name,"Static") then
		-- print("DC_P_T  Pack keep plane and helicopter: "..unit.name )
		return true -- keep plane and helicopte

	-- puis dans keepGroundUnit :
	elseif isPruneKeyword(lowCaseName) then
		if string.find(lowCaseName, "vc_") then

			-- Exception : ne prune pas si c'est VC_Khe-Sanh
			if string.find(unit.name, "VC_Khe%-Sanh") then
				-- print("DC_P_T9 ---K----> Keep VC: "..unit.name)
				return true -- keep
			end

			-- print("DC_P_T2 -P----P--> Prune vc_: "..lowCaseName)
			return false -- Prune
		end

		-- Vérifie la proximité d'un PointOfInterest
		for nPOI, POI in pairs(PointOfInterest) do
			local distance = GetDistance(POI, unit)
			-- print("DC_P_T0 ---distance: "..math.floor(distance/1000))
			if distance < 10000 then
				-- print("DC_P_T1 ---K----> Keep POI: "..lowCaseName)
				return true -- keep POI
			end
		end

		-- print("DC_P_T2 -P----P--> Prune staticDecor: "..lowCaseName)
		return false -- Prune
	

	elseif  string.find(string.lower(unit.name),"convo") then
		-- print("DC_P_ keep Convoy")
		return true -- keep Convoy
	elseif  string.find(string.lower(unit.name),"scud") then
		-- print("DC_P_ keep scud")
		return true -- keep scud
	elseif  string.find(string.lower(unit.name),"_pilot_") then
		-- print("DC_P_ keep scud")
		return true -- keep ejected _pilot_
	elseif  ( string.find(string.lower(unit.name),"ewr") or string.find(string.lower(unit.name),"fps") or string.find(string.lower(unit.name),"FuMG") or string.find(string.lower(unit.name),"FuSe") )   then
		-- print("DC_P_ keep EWR")
		return true -- keep EWR
	elseif  string.find(string.lower(unit.name),"farp") then
		-- print("DC_P_ keep name FARP: "..tostring(unit.name))
		return true -- keep FARP_
	end
	local aaType = unitAntiAirType(unit)

	-- debug02 : FARP bug
	if unit.type == "FARP" or unit.type == "Invisible FARP" then
		-- print("DC_P_ keep type FARP: "..tostring(unit.type))
		return true
	end
	-- Z02 : SAM
	if stringStarts(unit.name, 'DontPrune') and pruneSam == false then
	-- print("DC_P_ DontPrune")
		return true
	end
	if  (unit.type == "DECKCREW" or  stringStarts(unit.type,"MD_3") )and not mission_ini.Keep_USNdeckCrew then
		-- print("DC_P_PruneUSnCrew "..unit.type)
		return false -- prune USN crew -- si Keep_USNdeckCrew est en False dans conf_mod -- Miguel Modisication M23
	end

	-- decides which aircraft waypoints we want to check against, we really don't care if enemy planes fly over enemy defenses.
	local otherSide = (unitSide == "blue") and "red" or "blue"
	local checkSides = unitSide == playerSide and { unitSide, otherSide } or { otherSide }	-- if unit is same side as player check both, else just check enemy

	-- for other types of unit it depends on distance to waypoints 
	local closestWP     = 100000000
	local closestTarget = 100000000
	for csi,side in pairs(checkSides) do
		for wpi,wps in pairs(allWaypoints[side]) do
			waypointPairs(wps, function (wp1, wp2)
				-- calculate the distance between the unit and the closest point along the two waypoints		
				local dist = GetTangentDistance(wp1, wp2, unit)
				closestWP = math.min(closestWP, dist)

				-- if this is a 'target' waypoint then record that distance as well
				if wp1.name == 'Target' or wp1.name == 'Attack' then
					local dist = GetDistance(wp1, unit)
					closestTarget = math.min(closestTarget, dist)
				end
				if wp2.name == 'Target' or wp2.name == 'Attack' then
					local dist = GetDistance(wp2, unit)
					closestTarget = math.min(closestTarget, dist)
				end

				-- TargetList_InThisMission

				--TODO revoir les cibles, elles ne sont plus forcement dans la liste mission
				-- les cibles identifiées par idgroup seront Gardées (Keep) 
				if wp1.task.id == "ComboTask" then
					if wp1.task.params.tasks then
						for ti=1 , #wp1.task.params.tasks do
							if wp1.task.params.tasks[ti] then
								if wp1.task.params.tasks[ti].id == 'AttackGroup' then
									if wp1.task.params.tasks[ti].params then
										if wp1.task.params.tasks[ti].params.groupId then
											local targetGroupId =  wp1.task.params.tasks[ti].params.groupId
											if allGroundGroupId[targetGroupId] then
		-- print("DC_P_P Keep cibles identifiées par idgroup seront Gardées "..targetGroupId.." Unit "..unit.name)	
												cibleTrouve[targetGroupId] = allGroundGroupId[targetGroupId].name
												local dist = GetDistance(allGroundGroupId[targetGroupId], unit)
												closestTarget = math.min(closestTarget, dist)
											end
										end
									end
								end
							end
						end
					end
				end
			end)
		end
	end

	-- depending on the closest distance (and unit type) decide if we want to keep this unit
	local range = {
		["LONG"] = 400000.0, ["MEDIUM"] = 80000, ["SHORT"] = 30000,
		["AAA"] = 15000.0, ["IR"] = 20000.0, ["NONE"] = 10000.0
	}
	local rfactor = math.min(math.max(pruneAggressiveness, 0), 3)
	local keep = closestWP*rfactor <= range[aaType] or closestTarget*rfactor <= 25000



	-- print("DC_P keepGroundUnit_A Unit " .. unit.type .. " |unit.name: " .. unit.name .. " closestWP " .. closestWP .. " closestTarget " .. 
	-- 		closestTarget .. " Keep = " .. (keep and "KEEP" or "PRUNE"))

	-- if  unit.category and  keep == false then
	-- 	print("DC_P keepGroundUnit_B UnitCat " .. unit.category.." " ..unit.type .. " " .. unit.name .. " closestWP " .. closestWP .. " closestTarget " .. 
	-- 			closestTarget .. " Keep = " .. (keep and "KEEP" or "PRUNE"))
	-- elseif  keep == false then
	-- 	print("DC_P keepGroundUnit_C Unit "..unit.type .. " " .. unit.name .. " closestWP " .. closestWP .. " closestTarget " .. 
	-- 			closestTarget .. " Keep = " .. (keep and "KEEP" or "PRUNE"))
	-- end


	return keep
end

-- decides whether the given air unit should be kept or not
local function keepAirUnit(unit, side)
-- print( tostring( not pruneStatic or not string.find(unit.name, 'Static')))
	return not pruneStatic or not string.find(unit.name, 'Static')
end

-- Get all the waypoints for all (flying) units for all countries
local function getAllWaypoints()
	local allWaypoints = {}
	for si, side in pairs(mission.coalition) do
		local sideWaypoints = {}
		for ci, country in pairs(side.country) do
			if country.plane then
				for gi, grp in pairs(country.plane.group) do
					table.insert(sideWaypoints, grp.route.points)
				end
			end
			if country.helicopter then
--				for gi, grp in pairs(country.plane.helicopter) do
				for gi, grp in pairs(country.helicopter.group) do       -- debug01 : helicopter bug
					table.insert(sideWaypoints, grp.route.points)
				end
			end
		end
		allWaypoints[si] = sideWaypoints
	end
	return allWaypoints
end

-- Get all the ground units in the mission that could be pruned
local function pruneUnits(groundFun, airFun)
	local totalPruned = 0
	local totalKept = 0
	local addPrune = {}
	local i = 1
	local j = 1
	-- prune all the units in a given group (e.g. 'vehicle' or 'static')
	local pruneInGroup = function (container, side, fun, category)
		if container and container.group and container then
			local newGroup = {}

			for gi, grp in pairs(container.group) do
				if grp.units then

					-- either the whole group survives (if any unit in it survives), or the whole group is removed.
					local saved = false
					for ui, unit in pairs(grp.units) do
						-- unit['category'] = category

						saved = saved or fun(unit, side, category)
						
					end
					if not saved then
						totalPruned = totalPruned + #grp.units
						if Debug.debug then
							for ui, unit in pairs(grp.units) do
								table.insert(addPrune, unit.name)
								if i == 1 and j < 20 then
									print("DC_P_P sampler  prune: "..unit.name)
									j=j+1
								elseif i >= 40 then
									i = 0
								end
								i=i+1

							end
						end
					else
						totalKept = totalKept + #grp.units
						table.insert(newGroup, grp)
					end
				end
			end
			container.group = newGroup

		end

	end

-- M16.d :
-- Obligé de passer les Aéronefs static avec "groudFun" pour les enlever en fonction de la distance.
	for si, side in pairs(mission.coalition) do
		for ci, country in pairs(side.country) do
			pruneInGroup(country.vehicle, si, groundFun, "vehicle")
			pruneInGroup(country.plane, si, groundFun, "plane")			-- plus efficace que pruneInGroup(country.plane, si, airFun, "Planes")
			pruneInGroup(country.static, si, groundFun, "static")
			pruneInGroup(country.helicopter, si, groundFun, "helicopter")
		end
	end
	print("Pruned " .. totalPruned .. ", kept " .. totalKept)

	if Debug.debug then
		print()
		print("this was a sample of what is pruned, to see it all, go to the prune.lua file in the /Debug folder")

		print()
		local prune_str = "mission_AtoFP = " .. TableSerialization(addPrune, 0)						--make a string
		local pruneFile = io.open("Debug/prune_DcPrune.lua", "w") or error("Failed to open debug file")
		pruneFile:write(prune_str)															--save new data
		pruneFile:close()
	end
end

local function prune()

	local allGroundGroupId = GroundGroupId()
	-- get the waypoints for all air units in the mission.
	local allWaypoints = getAllWaypoints()

	-- prune the required ground and air units 
	pruneUnits(
		function (unit, side, category) return keepGroundUnit(unit, side, allWaypoints, allGroundGroupId, category) end
		,
		-- function (unit, side, category) return keepAirUnit(unit, side, category) end 
		function (unit, side, category) return keepAirUnit(unit, side) end
	)
end

function NbPlane()
	local Count = {
			NbPlane = 0,
			NbPlaneStatic = 0,

			NbHeli = 0,
			NbHeliStatic = 0,
		}

	for side, _coalition in pairs(mission.coalition) do
		for ci, country in pairs(mission.coalition[side].country) do
			if country.plane then
				if country.plane.group then
					for gi = 1, #country.plane.group do
						for ui = 1, #country.plane.group[gi].units do
							local testName = string.lower(country.plane.group[gi].units[ui].name)
							if  string.find(testName,"static")  then
								Count.NbPlaneStatic = Count.NbPlaneStatic +  1
							else
								Count.NbPlane = Count.NbPlane +  1
							end
						end
					end
				end
			end
		end
	end

	for side, _coalition in pairs(mission.coalition) do
		for ci, country in pairs(mission.coalition[side].country) do
			if country.helicopter then
				if country.helicopter.group then
					for gi = 1, #country.helicopter.group do
						for ui = 1, #country.helicopter.group[gi].units do
							local testName = string.lower(country.helicopter.group[gi].units[ui].name)
							if  string.find(testName,"static")  then
								Count.NbHeliStatic = Count.NbHeliStatic +  1
							else
								Count.NbHeli = Count.NbHeli +  1
							end
						end
					end
				end
			end
		end
	end

	return Count
end


-- Tomsk modification V9 Integration de Prune Script
if pruneScript == true then
	local _Count = NbPlane()
	print ("Number of plane Before Prune: ".._Count.NbPlane.." PlaneStatic: ".._Count.NbPlaneStatic.." Nb Helic: ".._Count.NbHeli.." HeliStatic ".._Count.NbHeliStatic)
	prune()
	_Count = NbPlane()
	print ("Number of plane After Prune: ".._Count.NbPlane.." PlaneStatic: ".._Count.NbPlaneStatic.." Nb Helic: ".._Count.NbHeli.." HeliStatic ".._Count.NbHeliStatic)
end



if cibleTrouve then
	-- print("(TEST DC_Prune) Numero des cibles trouvées et normalement préservées de Prune: ")
	for i, cible in pairs(cibleTrouve) do
		if cible  then
			-- print(i.." DC_P_P cibleTrouve Keep "..cible)
		end
	end
end


