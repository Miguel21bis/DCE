------------------------------------------------------------------------------------------------------- 
-- Artillery Spotter script - script merge version
-- original code by ************ Carsten Gurk aka Don Rudi ***************
-- modified by Miguel & Cef with kind permission of Don Rudi :)
------------------------------------------------------------------------------------------------------- 
-- last modification   cleanCode_a debug_c
if not versionDCE then versionDCE = {} end
versionDCE["Mission Scripts/CG_ArtySpotter.lua"] = "1.4.18"
------------------------------------------------------------------------------------------------------- 
-- cleanCode_a				(a springCleaning)				
-- adjustment_						
-- debug_c					(c removeItemForGroup Init)
-- modification M77_m		CG_ArtySpotter (m subMenu)(l spotterAircraft)(i boundary)(h camp.spotter)(g tempo)(f smoke & remains)(e lineOfSight)(d artyZone)(c timeImpact)(b qty_Total_Shells)(a responseTimeVar)	
------------------------------------------------------------------------------------------------------- 
local version = "script merge 2.3_f_15h.00"

env.info("CG_ArtySpotter: Start loading CG_ArtySpotter script created by Carsten Gurk aka Don Rudi")
env.info("CG_ArtySpotter: version: "..version)
-- trigger.action.outText("CG_ArtySpotter: Start loading CG_ArtySpotter script created by Carsten Gurk aka Don Rudi", 10)
-- trigger.action.outText("CG_ArtySpotter: version: "..version, 10)

-- User configurable variables**************************************************************

local user_fireDelay = 10					-- time to impact of the rounds
local user_quantity = 20					-- how many rounds will be fired in a fire for effect task
local user_spread = 50						-- impact radius of the rounds during fire for effect
local user_spottingDistance = 15			-- max allowable distance from player to target to prevent cheating. In kilometers.
local user_restrictByType = ""        		-- Restriction by type ("", "helo", etc.)
local user_markerPrefix = "fire mission"   	-- Prefix for marker text, for instance "#arty"
local user_qty_Total_Shells = 45			-- total number of shells in stock
local user_smokeOn = true					-- activate or deactivate the red smoke during “single round” firing, to aid artillery adjustment

-- end of user block************************************************************************


-- variable modified by environment DCE ****************************************************
if camp.spotter then
	user_quantity = camp.spotter.qtyBySalve
	user_markerPrefix = (camp.spotter.markerPrefix and camp.spotter.markerPrefix ~= "" and camp.spotter.markerPrefix) or user_markerPrefix
	user_qty_Total_Shells = camp.spotter.qtyTotalShells
	user_spottingDistance = camp.spotter.spottingDistance
	user_smokeOn = camp.spotter.smokeOn
end


-- Script variables
local artyRadius   = user_spread		-- Artillery Radius
local adjustRadius = 20  				-- fire adjustment
local quantity     = 1   				-- Rounds expanded 
local quantity_effect = user_quantity	-- Rounds expanded during fire for effect
local tntEquivalent = 12				-- TNT equivalent for explosion
local fireDelay = user_fireDelay		-- delay til artillery fires in seconds
local firstShotFired = true
local markerText = ""
local artyTasks = {}
local artyZonePrefixName = "arty"		-- name of artillery zones, added in the mission, to represent FSBs (Fire Support Base). To find out if the target is not too far away to be treated by artillery
local artyZones = {}
-- camp.boundary[spotterSide]			-- another way of knowing whether a target can be hit by artillery is to define a border or front line. But this is in the DCE environment.

local tableOfClient = {
	MARKER_FOUND = false,
	playerPosXZ = { x = 0, y = 0, z = 0 },
	targetPosXZ = { x = 0, y = 0, z = 0 },
	unitID = "",
	groupID = "",
	initiator = "",
	adjustDistance = 0,					-- Adjust fire (from F10 menu)
	adjustDirection = 0,				-- Adjust fire (from F10 menu)
	artyCall = 0, 						-- pilot called arty (from F10 menu) 1 = single round, 2 = fire for effect 
	menuItems = false,
}

local responseTimeVar = 5				--response time of the interlocutor, so that the answer is not immediate like a computer
local artyDistance = 40000				--distance max between arty zone and target
local distanceTable = {50, 100, 500, 1000, 2000}

-- optional arty enabled user flag, for use in triggers, if the player wants to
trigger.action.setUserFlag( "artyEnabled", 1 )

-- select format of target coordinates MGRS or LAT/LONG
local outputFormat = "MGRS"
--local outputFormat = "LL"

-- Fonction pour obtenir toutes les trigger zones dont le nom commence par "Arty_" ou "Arty-" ou "Arty"
local function getArtyTriggerZones()

    for i, zone in ipairs(env.mission.triggers.zones) do
        if string.sub(string.lower(zone.name), 1, 4) == artyZonePrefixName then
            table.insert(artyZones, zone)
        end
    end
    return artyZones
end

-- Utilisation de la fonction
artyZones = getArtyTriggerZones()

--to debug
for i, zone in ipairs(artyZones) do
    -- trigger.action.outText("Found Arty Zone: " .. zone.name, 10)
	env.info("CG_ArtySpotter : Found Arty Zone: "..zone.name)
end

--response time of the interlocutor, so that the answer is not immediate like a computer
local function responseTime(arg)
	local Uid = arg[1]
	local txt = arg[2]

	trigger.action.outTextForUnit( Uid, txt, 10)
end

local function menuAccueil(unitID)
	trigger.action.outTextForUnit( unitID, "To use the Spotter Artillery menu, you must place a marker on the F10 MAP, and enter a text beginning with: \n "..tostring(user_markerPrefix) , 10)
	trigger.action.outTextForUnit( unitID, " or enter the MGRS position directly.  ", 10)
end

-- set values selected by player through F10 menu
local function RemainingShells(initiatorName)

	local nbSalve = math.floor(user_qty_Total_Shells / user_quantity)
	trigger.action.outTextForUnit( artyTasks[initiatorName].unitID, "Number of shells remaining:  "..user_qty_Total_Shells.." Number of salvos possible: "..tostring(nbSalve), 10)

end

---- set values selected by player through F10 menu
-- local function setValueOLD( _valueType, _value, initiatorName )

-- 	if _valueType == "arty" then	
-- 		artyTasks[initiatorName].artyCall = _value	
-- 	elseif _valueType == "dist" then	
-- 		artyTasks[initiatorName].adjustDistance = _value		
-- 		trigger.action.outText("Fire adjusted by "..artyTasks[initiatorName].adjustDistance.." meters", 10)	
-- 	elseif _valueType == "dir" then	
-- 		artyTasks[initiatorName].adjustDirection = _value
-- 		trigger.action.outText("Direction corrected by "..artyTasks[initiatorName].adjustDirection.." °", 10)
-- 	end

-- 	artyAction( initiatorName )	
-- end

-- set values selected by player through F10 menu
local function setValue( arg )

	local initiatorName = arg[4]

	artyTasks[initiatorName].artyCall = arg[1]
	artyTasks[initiatorName].adjustDirection = arg[2]
	artyTasks[initiatorName].adjustDistance = arg[3]

	if artyTasks[initiatorName].adjustDirection ~= nil and artyTasks[initiatorName].adjustDistance ~= nil then

		trigger.action.outText("Direction corrected by "..artyTasks[initiatorName].adjustDirection.." °, Fire adjusted by "..artyTasks[initiatorName].adjustDistance.." meters", 10)

	end

	artyAction( initiatorName )
end

-- Function to add F10 menu items for a specific group and store references
local function addMenuItems(groupId, initiatorName)

	if menuRadioInit and menuRadioInit[initiatorName] then
		missionCommands.removeItemForGroup(groupId, menuRadioInit[initiatorName])
	end

	-- menuItems = true
	artyTasks[initiatorName].menuItems = true

    local artyTask = artyTasks[initiatorName]

    artyTask.ArtyMenu = missionCommands.addSubMenuForGroup(groupId, 'Artillery Commands', nil)
    artyTask.Adjust = missionCommands.addSubMenuForGroup(groupId, 'Adjust fire', artyTask.ArtyMenu)
					missionCommands.addCommandForGroup(groupId, 'Remaining shells', artyTask.ArtyMenu, RemainingShells, initiatorName)

					-- table missionCommands.addCommandForGroup(number groupId , string name , table/nil path , function functionToRun , any anyArguement)

    artyTask.commands = {}
	artyTask.commands[#artyTask.commands + 1] = missionCommands.addCommandForGroup(groupId, 'request single round', artyTask.ArtyMenu, setValue, {1, nil, nil, initiatorName})
    artyTask.commands[#artyTask.commands + 1] = missionCommands.addCommandForGroup(groupId, 'request fire for effect', artyTask.ArtyMenu, setValue, {2, nil, nil, initiatorName})

	artyTask.dir = {}
	--*************************************
    artyTask.dir.dir_N = missionCommands.addSubMenuForGroup(groupId, 'adjust fire North', artyTask.Adjust)
	for i, dist in ipairs(distanceTable) do
		artyTask.dir["dir_N_dist"..dist] = missionCommands.addSubMenuForGroup(groupId, 'adjust fire by '..dist.."m", artyTask.dir.dir_N)
		missionCommands.addCommandForGroup(groupId, 'request single round', artyTask.dir["dir_N_dist"..dist], setValue, {1, 360, dist, initiatorName})
		missionCommands.addCommandForGroup(groupId, 'request fire for effect', artyTask.dir["dir_N_dist"..dist], setValue, {2, 360, dist, initiatorName})
	end
	--*************************************


    -- artyTask.commands[#artyTask.commands + 1] = missionCommands.addCommandForGroup(groupId, 'adjust fire North-East', artyTask.Adjust, function() setValue("dir", 45, initiatorName) end)
	--*************************************
	artyTask.dir.dir_NE = missionCommands.addSubMenuForGroup(groupId, 'adjust fire North-East', artyTask.Adjust)
	for i, dist in ipairs(distanceTable) do
		artyTask.dir["dir_NE_dist"..dist] = missionCommands.addSubMenuForGroup(groupId, 'adjust fire by '..dist.."m", artyTask.dir.dir_NE)
		artyTask.dir[#artyTask.dir + 1] = missionCommands.addCommandForGroup(groupId, 'request single round', artyTask.dir["dir_NE_dist"..dist], setValue, {1, 45, dist, initiatorName})
		artyTask.dir[#artyTask.dir + 1] = missionCommands.addCommandForGroup(groupId, 'request fire for effect', artyTask.dir["dir_NE_dist"..dist], setValue, {2, 45, dist, initiatorName})
	end
	--*************************************

    -- artyTask.commands[#artyTask.commands + 1] = missionCommands.addCommandForGroup(groupId, 'adjust fire East', artyTask.Adjust, function() setValue("dir", 90, initiatorName) end)
	--*************************************
	artyTask.dir.dir_E = missionCommands.addSubMenuForGroup(groupId, 'adjust fire East', artyTask.Adjust)
	for i, dist in ipairs(distanceTable) do
		artyTask.dir["dir_E_dist"..dist] = missionCommands.addSubMenuForGroup(groupId, 'adjust fire by '..dist.."m", artyTask.dir.dir_E)
		artyTask.dir[#artyTask.dir + 1] = missionCommands.addCommandForGroup(groupId, 'request single round', artyTask.dir["dir_E_dist"..dist], setValue, {1, 90, dist, initiatorName})
		artyTask.dir[#artyTask.dir + 1] = missionCommands.addCommandForGroup(groupId, 'request fire for effect', artyTask.dir["dir_E_dist"..dist], setValue, {2, 90, dist, initiatorName})
	end
	--*************************************

    -- artyTask.commands[#artyTask.commands + 1] = missionCommands.addCommandForGroup(groupId, 'adjust fire South-East', artyTask.Adjust, function() setValue("dir", 135, initiatorName) end)
  	--*************************************
	artyTask.dir.dir_SE = missionCommands.addSubMenuForGroup(groupId, 'adjust fire South-East', artyTask.Adjust)
	for i, dist in ipairs(distanceTable) do
		artyTask.dir["dir_SE_dist"..dist] = missionCommands.addSubMenuForGroup(groupId, 'adjust fire by '..dist.."m", artyTask.dir.dir_SE)
		artyTask.dir[#artyTask.dir + 1] = missionCommands.addCommandForGroup(groupId, 'request single round', artyTask.dir["dir_SE_dist"..dist], setValue, {1, 135, dist, initiatorName})
		artyTask.dir[#artyTask.dir + 1] = missionCommands.addCommandForGroup(groupId, 'request fire for effect', artyTask.dir["dir_SE_dist"..dist], setValue, {2, 135, dist, initiatorName})
	end
	--*************************************


	-- artyTask.commands[#artyTask.commands + 1] = missionCommands.addCommandForGroup(groupId, 'adjust fire South', artyTask.Adjust, function() setValue("dir", 180, initiatorName) end)
	--*************************************
    artyTask.dir.dir_S = missionCommands.addSubMenuForGroup(groupId, 'adjust fire South', artyTask.Adjust)
	for i, dist in ipairs(distanceTable) do
		artyTask.dir["dir_S_dist"..dist] = missionCommands.addSubMenuForGroup(groupId, 'adjust fire by '..dist.."m", artyTask.dir.dir_S)
		artyTask.dir[#artyTask.dir + 1] = missionCommands.addCommandForGroup(groupId, 'request single round', artyTask.dir["dir_S_dist"..dist], setValue, {1, 180, dist, initiatorName})
		artyTask.dir[#artyTask.dir + 1] = missionCommands.addCommandForGroup(groupId, 'request fire for effect', artyTask.dir["dir_S_dist"..dist], setValue, {2, 180, dist, initiatorName})
	end
	--*************************************

    -- artyTask.commands[#artyTask.commands + 1] = missionCommands.addCommandForGroup(groupId, 'adjust fire South-West', artyTask.Adjust, function() setValue("dir", 225, initiatorName) end)
	--*************************************
	artyTask.dir.dir_SW = missionCommands.addSubMenuForGroup(groupId, 'adjust fire South-West', artyTask.Adjust)
	for i, dist in ipairs(distanceTable) do
		artyTask.dir["dir_SW_dist"..dist] = missionCommands.addSubMenuForGroup(groupId, 'adjust fire by '..dist.."m", artyTask.dir.dir_SW)
		artyTask.dir[#artyTask.dir + 1] = missionCommands.addCommandForGroup(groupId, 'request single round', artyTask.dir["dir_SW_dist"..dist], setValue, {1, 225, dist, initiatorName})
		artyTask.dir[#artyTask.dir + 1] = missionCommands.addCommandForGroup(groupId, 'request fire for effect', artyTask.dir["dir_SW_dist"..dist], setValue, {2, 225, dist, initiatorName})
	end
	--*************************************

    -- artyTask.commands[#artyTask.commands + 1] = missionCommands.addCommandForGroup(groupId, 'adjust fire West', artyTask.Adjust, function() setValue("dir", 270, initiatorName) end)
	--*************************************
	artyTask.dir.dir_W = missionCommands.addSubMenuForGroup(groupId, 'adjust fire West', artyTask.Adjust)
	for i, dist in ipairs(distanceTable) do
		artyTask.dir["dir_W_dist"..dist] = missionCommands.addSubMenuForGroup(groupId, 'adjust fire by '..dist.."m", artyTask.dir.dir_W)
		artyTask.dir[#artyTask.dir + 1] = missionCommands.addCommandForGroup(groupId, 'request single round', artyTask.dir["dir_W_dist"..dist], setValue, {1, 270, dist, initiatorName})
		artyTask.dir[#artyTask.dir + 1] = missionCommands.addCommandForGroup(groupId, 'request fire for effect', artyTask.dir["dir_W_dist"..dist], setValue, {2, 270, dist, initiatorName})
	end
	--*************************************

    -- artyTask.commands[#artyTask.commands + 1] = missionCommands.addCommandForGroup(groupId, 'adjust fire North-West', artyTask.Adjust, function() setValue("dir", 315, initiatorName) end)
	--*************************************
	artyTask.dir.dir_NW = missionCommands.addSubMenuForGroup(groupId, 'adjust fire North-West', artyTask.Adjust)
	for i, dist in ipairs(distanceTable) do
		artyTask.dir["dir_NW_dist"..dist] = missionCommands.addSubMenuForGroup(groupId, 'adjust fire by '..dist.."m", artyTask.dir.dir_NW)
		artyTask.dir[#artyTask.dir + 1] = missionCommands.addCommandForGroup(groupId, 'request single round', artyTask.dir["dir_NW_dist"..dist], setValue, {1, 315, dist, initiatorName})
		artyTask.dir[#artyTask.dir + 1] = missionCommands.addCommandForGroup(groupId, 'request fire for effect', artyTask.dir["dir_NW_dist"..dist], setValue, {2, 315, dist, initiatorName})
	end
		--*************************************


	local TimeSearchEngage = timer.getTime()
	local logStr = "artyTask = " .. TableSerialization(artyTask, 0)
	local FlightNameClean = "artyTask"
	local logFile = io.open(PathDCE.."Debug\\"..FlightNameClean.."_"..TimeSearchEngage.."_".. "_artyTask.lua", "w")
	if logFile then
		logFile:write(logStr)
		logFile:close()
	else
		env.info("DCE_artyTask: Failed to open log file for writing.")
	end

end

-- Function to remove F10 menu items for a specific group
local function removeMenuItems(initiatorName)

	env.info("CG_ArtySpotter: removeMenuItems AA: initiatorName: "..tostring(initiatorName))

    local artyTask = artyTasks[initiatorName]

    if artyTask and artyTask.groupID then
		env.info("CG_ArtySpotter: removeMenuItems BB: |"..tostring(artyTask.groupID).."|")

        for _, command in ipairs(artyTask.commands) do
			env.info("CG_ArtySpotter: removeMenuItems CC: "..tostring(command))
			_affiche(command, "CG_ArtySpotter removeMenuItems command")
            missionCommands.removeItemForGroup(artyTask.groupID, command)
        end

        ---- missionCommands.removeItemForGroup(artyTasks[initiatorName].groupID, artyTask.AdjustDistance)
		if artyTask.Adjust then
       		missionCommands.removeItemForGroup(artyTask.groupID, artyTask.Adjust)
		end
		if artyTask.RemainingShells then
			missionCommands.removeItemForGroup(artyTask.groupID, artyTask.RemainingShells)
		end
		if artyTask.ArtyMenu then
			missionCommands.removeItemForGroup(artyTask.groupID, artyTask.ArtyMenu)
		end

		local TimeSearchEngage = timer.getTime()
		local logStr = "artyTasks = " .. TableSerialization(artyTasks, 0)
		local FlightNameClean = "artyTasks"
		local logFile = io.open(PathDCE.."Debug\\"..FlightNameClean.."_"..TimeSearchEngage.."_".. "_removeMenuItems.lua", "w")
		if logFile then
			logFile:write(logStr)
			logFile:close()
		else
			env.info("DCE_artyTask_removeMenuItems: Failed to open log file for writing.")
		end

		-- if artyTask.dir then
		-- 	missionCommands.removeItemForGroup(artyTask.groupID, artyTask.dir)
		-- end		

		artyTask.Adjust = nil
		artyTask.RemainingShells = nil
		artyTask.ArtyMenu = nil
		artyTask.dir = nil

		env.info("CG_ArtySpotter: CGAS_timerPlayerMenu: initiatorName: "..tostring(initiatorName))

		--ajoute l'init pour expliquer
		-- event.initiator:getGroup():getID()

		local Uid = artyTasks[initiatorName].initiator:getID()
		local gpGid = artyTasks[initiatorName].initiator:getGroup():getID()

		missionCommands.removeItemForGroup(gpGid, {"Artillery Init"})


		env.info("CG_ArtySpotter: CGAS_timerPlayerMenu: Uid: "..tostring(Uid))
		env.info("CG_ArtySpotter: CGAS_timerPlayerMenu: gpGid: "..tostring(gpGid))

		if not menuRadioInit then menuRadioInit = {} end
		menuRadioInit[initiatorName] = {}

		menuRadioInit[initiatorName] = missionCommands.addCommandForGroup(gpGid, 'Artillery Init', nil, menuAccueil, Uid)


    end

	-- menuItems = false
	artyTask.menuItems = false



end

-- Calculate distance
local function getDist(_point1, _point2)

    -- local xUnit = _point1.x
    -- local yUnit = _point1.z
    -- local xZone = _point2.x
    -- local yZone = _point2.z

    -- local xDiff = xUnit - xZone
    -- local yDiff = yUnit - yZone

    -- return math.sqrt(xDiff * xDiff + yDiff * yDiff)

	local distance = math.floor(math.sqrt(math.pow(_point1.x - _point2.x, 2) + math.pow(_point1.z - _point2.z, 2)))

	return distance

end

-- Shelling Zone
local function shellZone(initiatorName)

	local _artyCall = artyTasks[initiatorName].artyCall
	local _shellPos = artyTasks[initiatorName].targetPosXZ

	env.info("CG_ArtySpotter: AA shellZone  initiatorName: "..tostring(initiatorName))
	-- trigger.action.outTextForUnit( artyTasks[initiatorName].unitID, "Arty Task Created - fire incoming "..quantity.." rounds", 10)

	env.info("CG_ArtySpotter: CC shellZone  artyRadius: "..tostring(artyRadius))

	local j = 0
	for i = 1, quantity do

		local randomX = 0
		local randomZ = 0

		if _artyCall == 1 then
			randomX = math.random(-5, 5)
			randomZ = math.random(-5, 5)
		else

			--we increase the chances that a large proportion of the shells will fall close to the center of the zone
			if j == 1 then
				randomX = math.random(-artyRadius / 3, artyRadius / 3)
				randomZ = math.random(-artyRadius / 3, artyRadius / 3)
			elseif j == 2 then
				randomX = math.random(-artyRadius / 2, artyRadius / 2)
				randomZ = math.random(-artyRadius / 2, artyRadius / 2)
			else
				randomX = math.random(-artyRadius , artyRadius )
				randomZ = math.random(-artyRadius , artyRadius )
				j = 0
			end
			j = j + 1
		end


		local strikePos = {
		  x = _shellPos.x + randomX,
		  y = _shellPos.y,
		  z = _shellPos.z + randomZ
		}

		--recalculates the height of the shell drop points, and therefore of the explosion. Given that we had added 3m to the height of the target point for “line of sight” reasons
		strikePos.y = land.getHeight({ x = strikePos.x, y = strikePos.z })

		if _artyCall == 1 then
			_shellPos = strikePos
		end

		-- Delay the shelling by 1 second for each shell	
		timer.scheduleFunction(function()
		  trigger.action.explosion(strikePos, tntEquivalent)  -- Create an explosion at the target position with a predefined power
		  if _artyCall == 1 and user_smokeOn then trigger.action.smoke(strikePos, trigger.smokeColor.Red) end
		end, {}, timer.getTime() + i)
	end

	env.info("CG_ArtySpotter: HH shellZone  initiatorName: "..tostring(initiatorName))

	local TimeSearchEngage = timer.getTime()
	local logStr = "artyTasksTOUT = " .. TableSerialization(artyTasks, 0)
	local FlightNameClean = "artyTasksTOUT"
	local logFile = io.open(PathDCE.."Debug\\"..FlightNameClean.."_"..TimeSearchEngage.."_".. "_artyTasksTOUT.lua", "w")
	if logFile then
		logFile:write(logStr)
		logFile:close()
	else
		env.info("DCE_artyTask_shellZone: Failed to open log file for writing.")
	end

end

-- MGRS conversion to LL to x,z
local function convertMGRStoPos ( _mgrs )

	local lat, lon = coord.MGRStoLL( _mgrs )
    local markerPos = coord.LLtoLO( lat, lon, 0 )
	return markerPos

end

-- x,z coordinates conversion to LAT/LONG and MGRS
local function convertPos2Coord ( _pos, _reply )

	local lat, lon, alt = coord.LOtoLL (_pos)
	local lat_degrees = math.floor (lat)
	local lat_minutes = (60 * (lat - lat_degrees))
	local lat_seconds = math.floor(60 * (lat_minutes - math.floor(lat_minutes)))
	lat_minutes = math.floor(lat_minutes)

	local lon_degrees = math.floor (lon)
	local lon_minutes = (60 * (lon - lon_degrees))
	local lon_seconds = math.floor (60 * (lon_minutes - math.floor(lon_minutes)))
	lon_minutes = math.floor(lon_minutes)

	local coordStringLL = "N" .. lat_degrees .. " " .. lat_minutes .. " " ..lat_seconds.. " E".. lon_degrees .. " " .. lon_minutes .. " ".. lon_seconds

	local targetMGRS = coord.LLtoMGRS(lat, lon)
	targetMGRS.Easting = math.floor (( targetMGRS.Easting /10 ) + 0.5 )
	targetMGRS.Northing = math.floor (( targetMGRS.Northing / 10 ) + 0.5 )
	--local coordStringMGRS = targetMGRS.UTMZone.." "..targetMGRS.MGRSDigraph.." "..string.sub(targetMGRS.Easting, 1, -2).." "..string.sub(targetMGRS.Northing, 1, -2)
	local coordStringMGRS = targetMGRS.UTMZone.." "..targetMGRS.MGRSDigraph.." "..targetMGRS.Easting.." "..targetMGRS.Northing

	if outputFormat == "MGRS" then
		coordString = coordStringMGRS
	else
		coordString = coordStringLL
	end

	-- return either formated string or MGRS coordinate  

	if _reply == "string" then
		return coordString
	elseif _reply == "pos" then
		return targetMGRS
	end
end

--***************************************************************************************************
--***************************************************************************************************
-- Function to add a marker on the F10 map
local idMark = 1
function addF10MapMarker(text, pos)

    -- Create a marker table
	idMark = idMark + 1
	local coalition = coalition.side.BLUE -- You can change this to coalition.side.RED or coalition.side.NEUTRAL
	local markType = "Diamond" -- You can use "Arrow", "Circle", "Diamond", etc.
	local markColor = {0, 0, 255} -- RGB color (0-255) for the marker
	local markAlpha = 1.0 -- Transparency of the marker (0.0 - 1.0)

    -- Add the marker to the map

    trigger.action.markToAll(idMark, text, pos, true, "testMessage")
end


-- Fonction pour calculer la projection orthogonale d'un point sur un segment
local function closest_point_on_segment(seg_start, seg_end, point)

    local seg_vec = { x = seg_end.x - seg_start.x, y = seg_end.y - seg_start.y }
    local pt_vec = { x = point.x - seg_start.x, y = point.y - seg_start.y }
    local seg_len = seg_vec.x^2 + seg_vec.y^2
    local proj_len = (pt_vec.x * seg_vec.x + pt_vec.y * seg_vec.y) / seg_len

    if proj_len < 0 then
        return seg_start
    elseif proj_len > 1 then
        return seg_end
    else
        return { x = seg_start.x + proj_len * seg_vec.x, y = seg_start.y + proj_len * seg_vec.y }
    end
end

-- Fonction pour trouver le point sur le polygone le plus proche du point cible
local function foundArtyPointInPoly(polyA, targetPointXZ)
    -- Initialiser la distance minimale avec un grand nombre
    local minDistance = math.huge
    local closestPoint = nil
    local closest_seg_start = nil
    local closest_seg_end = nil

    -- Parcourir tous les segments du polygone pour trouver le point le plus proche de B
    for i = 1, #polyA - 1 do
        local seg_start = polyA[i]
        local seg_end = polyA[i + 1]

        local pointA = closest_point_on_segment(seg_start, seg_end, {x = targetPointXZ.x, y = targetPointXZ.z})
        local distance_AB = math.sqrt((pointA.x - targetPointXZ.x)^2 + (pointA.y - targetPointXZ.z)^2)

        if distance_AB < minDistance then
            minDistance = distance_AB
            closestPoint = pointA
            closest_seg_start = seg_start
            closest_seg_end = seg_end  -- Correction ici
        end
    end

    -- addF10MapMarker("PointArty", {x = closestPoint.x,y = 0, z = closestPoint.y})
    -- addF10MapMarker("closest_seg_start", {x = closest_seg_start.x,y = 0, z = closest_seg_start.y})
    -- addF10MapMarker("closest_seg_end", {x = closest_seg_end.x,y = 0, z = closest_seg_end.y})

    return closestPoint, minDistance
end


--***************************************************************************************************
--***************************************************************************************************

-- Who is the player
-- Function to determine which unit is controlled by the player
local function getPlayerControlledUnit()

	local playerUnit = nil

	-- Iterate through all coalitions and their respective player units
	for coalitionID = 1, 2 do  -- 1 = Red, 2 = Blue
		local playerUnits = coalition.getPlayers(coalitionID)

		for _, unit in ipairs(playerUnits) do
			if unit and unit:getPlayerName() then
				playerUnit = unit
				break
			end
		end

		if playerUnit then
			break
		end
	end

	return playerUnit
end


-- Check if user has created F10 map marker
artyAction = function ( initiatorName )

	local _artyCall = artyTasks[initiatorName].artyCall
	local _adjustDirection = artyTasks[initiatorName].adjustDirection
	local _adjustDistance = artyTasks[initiatorName].adjustDistance
	local adjustX = 0
	local adjustZ = 0

	-- Check Call for arty direction correction
	if _adjustDirection ~= 0 and _adjustDistance ~= 0 then

		if _adjustDirection == 360 then

			adjustX = _adjustDistance
			adjustZ = 0
			trigger.action.outTextForUnit( artyTasks[initiatorName].unitID, "Fire adjusted to the North", 10)

		elseif _adjustDirection == 45 then

			adjustX = _adjustDistance
			adjustZ = _adjustDistance
			trigger.action.outTextForUnit( artyTasks[initiatorName].unitID, "Fire adjusted to the North-East", 10)

		elseif _adjustDirection == 90 then

			adjustX = 0
			adjustZ = _adjustDistance
			trigger.action.outTextForUnit( artyTasks[initiatorName].unitID, "Fire adjusted to the East", 10)

		elseif _adjustDirection == 135 then

			adjustX = - _adjustDistance
			adjustZ = _adjustDistance
			trigger.action.outTextForUnit( artyTasks[initiatorName].unitID, "Fire adjusted to the South-East", 10)

		elseif _adjustDirection == 180 then

			adjustX = - _adjustDistance
			adjustZ = 0
			trigger.action.outTextForUnit( artyTasks[initiatorName].unitID, "Fire adjusted to the South", 10)

		elseif _adjustDirection == 225 then

			adjustX = - _adjustDistance
			adjustZ = - _adjustDistance
			trigger.action.outTextForUnit( artyTasks[initiatorName].unitID, "Fire adjusted to the South-West", 10)

		elseif _adjustDirection == 270 then

			adjustX = 0
			adjustZ = - _adjustDistance
			trigger.action.outTextForUnit( artyTasks[initiatorName].unitID, "Fire adjusted meters to the West", 10)

		elseif _adjustDirection == 315 then

			adjustX = _adjustDistance
			adjustZ = - _adjustDistance
			trigger.action.outTextForUnit( artyTasks[initiatorName].unitID, "Fire adjusted meters to the North-West", 10)

		end

		artyTasks[initiatorName].adjustDirection = 0
		artyTasks[initiatorName].adjustDistance = 0

		artyTasks[initiatorName].targetPosXZ.x = artyTasks[initiatorName].targetPosXZ.x + adjustX
		artyTasks[initiatorName].targetPosXZ.z = artyTasks[initiatorName].targetPosXZ.z + adjustZ

	end

	-- Check Call for arty - 1 = single round, 2 = fire for effect 
	if _artyCall == 1 or _artyCall == 2 then
		if artyTasks[initiatorName] and artyTasks[initiatorName].MARKER_FOUND then

			-- trigger.action.outTextForUnit( artyTasks[initiatorName].unitID, "Arty action marker found.", 10)
			env.info("CG_ArtySpotter: Arty action : marker found ")

			--updates the player's position, if he has moved after the marker was created
			local playerUnit = artyTasks[initiatorName].initiator
			local _playerPosXZ = playerUnit:getPoint()
			artyTasks[initiatorName].playerPosXZ = _playerPosXZ


			local _targetPosXZ = artyTasks[initiatorName].targetPosXZ

			local distPlayerTarget = math.floor( getDist ( _targetPosXZ, _playerPosXZ ) / 10 ) / 100

			--increase altitude by 3 m to avoid inconsistencies
			_playerPosXZ.y = _playerPosXZ.y + 3
			_targetPosXZ.y = _targetPosXZ.y + 3

			local lineOfSight = land.isVisible(_playerPosXZ, _targetPosXZ)
			local spotterSide =   "neutral"
			local sideNum = artyTasks[initiatorName].initiator:getCoalition()

			if sideNum then
				if sideNum == coalition.side.RED then
					spotterSide =  "red"
				elseif sideNum == coalition.side.BLUE then
					spotterSide =   "blue"
				else
					spotterSide =   "neutral"
				end
			end

			--*****calcul la distance avec une zone arti la plus proche *****
			local nearestZone = 99999
			local txtFromZone = ""

			--TODO attention, le script plus bas est désactivé, il faut le réactiver pour que les zones d'artillerie soient prises en compte
			-- if 1 == 2 and #artyZones >= 1 then
			-- 	for zoneN, zone in pairs(artyZones) do
			-- 		if zone.radius and zone.radius > 1000 then
			-- 			-- Calculer la distance entre O et B
			-- 			local d = math.sqrt(math.pow(zone.x - _targetPosXZ.x, 2) + math.pow(zone.y - _targetPosXZ.z, 2))

			-- 			-- Calculer les coordonnées de A sur la circonférence
			-- 			local A = {
			-- 				x = zone.x + zone.radius * (_targetPosXZ.x - zone.x) / d,
			-- 				y = zone.y + zone.radius * (_targetPosXZ.z - zone.y) / d
			-- 			}

			-- 			-- Calculer la distance entre A et B
			-- 			local distance_AB = math.sqrt((_targetPosXZ.x - A.x)^2 + (_targetPosXZ.z - A.y)^2)

			-- 			if distance_AB < nearestZone then
			-- 				nearestZone = distance_AB
			-- 				local distKm = math.floor(nearestZone / 1000)
			-- 				txtFromZone = " from FireBase "..tostring(zone.name).." , distance: "..tostring(math.floor(distKm).." Km ")
			-- 				-- env.info("CG_ArtySpotter: artyZones D "..txtFromZone)

			-- 			end
			-- 		else

			-- 			local distance = math.sqrt(math.pow(zone.x - _targetPosXZ.x, 2) + math.pow(zone.y - _targetPosXZ.z, 2))
			-- 			if distance < nearestZone then
			-- 				nearestZone = distance
			-- 				local distKm = math.floor(nearestZone / 1000)
			-- 				txtFromZone = " from FireBase "..tostring(zone.name).." , distance: "..tostring(math.floor(distKm).." Km ")
			-- 			end
			-- 		end
			-- 	end

			-- elseif camp.boundary and camp.boundary[spotterSide] and camp.boundary[spotterSide] ~= nil then

			if camp.boundary and camp.boundary[spotterSide] and camp.boundary[spotterSide] ~= nil then

				-- check si le target est dans son propre camp, si oui on balance
				if CheckPointInPoly_XY_3({x=_targetPosXZ.x, y=_targetPosXZ.z}, camp.boundary[spotterSide]) then
					
					nearestZone = artyDistance/2
					local distKm = math.floor(nearestZone / 1000)

					txtFromZone = " in your camp "..tostring(spotterSide).." , distance: "..tostring(math.floor(distKm).." Km ")
					env.info("CG_ArtySpotter: in your side D1 "..tostring(nearestZone).." txtFromZone: "..txtFromZone)

				else
					env.info("CG_ArtySpotter: camp.boundary D2 "..tostring(nearestZone).." txtFromZone: "..txtFromZone)

					local artyPoint
					artyPoint, nearestZone = foundArtyPointInPoly(camp.boundary[spotterSide], _targetPosXZ )

					if artyPoint then

						-- nearestZone = math.sqrt(math.pow(artyPoint.x - _targetPosXZ.x, 2) + math.pow(artyPoint.y - _targetPosXZ.z, 2))

						local distKm = math.floor(nearestZone / 1000)

						txtFromZone = " from the nearest "..tostring(spotterSide).." border , distance: "..tostring(math.floor(distKm).." Km ")
						env.info("CG_ArtySpotter: camp.boundary EE "..tostring(nearestZone).." txtFromZone: "..txtFromZone)
					else
						env.info("CG_ArtySpotter: artyPoint = nil ERROR ?")
					end
				end

			end

			local passZoneDistance = false
			local distKm 
			local distPlayerTarget_Km
			if nearestZone < artyDistance then
				passZoneDistance = true
				distKm = math.floor(nearestZone / 1000)
				distPlayerTarget_Km = math.floor(distPlayerTarget / 1000)
			end

			local targetPosString = convertPos2Coord ( _targetPosXZ, "string" )

			if _artyCall == 1 then
				trigger.action.outTextForUnit( artyTasks[initiatorName].unitID, "Arty single round requested on "..targetPosString, 10)
			elseif _artyCall == 2 then
				trigger.action.outTextForUnit( artyTasks[initiatorName].unitID, "Arty fire for effect requested on "..targetPosString, 10)
			end

			if trigger.misc.getUserFlag( "artyEnabled" ) == 1 and distPlayerTarget <= user_spottingDistance and user_qty_Total_Shells > 1 and lineOfSight and passZoneDistance then

				if _artyCall == 1 then
					-- trigger.action.outTextForUnit( artyTasks[_initiatorName].unitID, "Arty single round requested on "..targetPosString, 10)
					quantity = 1
					user_qty_Total_Shells = user_qty_Total_Shells -1

				elseif _artyCall == 2 then
					-- trigger.action.outTextForUnit( artyTasks[_initiatorName].unitID, "Arty fire for effect requested on "..targetPosString, 10)
					quantity = quantity_effect
					if quantity > user_qty_Total_Shells then
						quantity = user_qty_Total_Shells
					end
					user_qty_Total_Shells = user_qty_Total_Shells - quantity

				end


				--https://www.reddit.com/media?url=https%3A%2F%2Fpreview.redd.it%2Fhprc5usnka4a1.png%3Fauto%3Dwebp%26s%3D7e56478c90ab7e8fe38a290fd419d58d52cf791f
				-- calculates (very approximately) shell flight time
				fireDelay = math.floor(((27/35000) * nearestZone) + 7.2)
				local txt = txtFromZone.." Impact in "..fireDelay.." seconds. "..quantity.." rounds"

				--initiates the gunner's response with a time delay ~= 5s
				timer.scheduleFunction(responseTime, {artyTasks[initiatorName].unitID, txt}, timer.getTime() + responseTimeVar)

				--initiates blast control after shell flight time
				timer.scheduleFunction(shellZone, initiatorName , timer.getTime() + fireDelay + responseTimeVar)

				trigger.action.setUserFlag( "artyFired", 1 )

			elseif user_qty_Total_Shells <= 0 then
				--initiates the artilleryman's response with a time delay ~= 5s
				timer.scheduleFunction(responseTime, {artyTasks[initiatorName].unitID, "Out of ammunition"}, timer.getTime() + responseTimeVar)

			elseif distPlayerTarget > user_spottingDistance then
				--initiates the artilleryman's response with a time delay ~= 5s
				timer.scheduleFunction(responseTime, {artyTasks[initiatorName].unitID, "Out of your range: "..tostring(distPlayerTarget_Km).." Km"}, timer.getTime() + responseTimeVar)

			elseif not lineOfSight then
				--initiates the artilleryman's response with a time delay ~= 5s
				timer.scheduleFunction(responseTime, {artyTasks[initiatorName].unitID, "Cheater, you don't really see the target, do you? ^^ "}, timer.getTime() + responseTimeVar)

			elseif not passZoneDistance then
				--initiates the artilleryman's response with a time delay ~= 5s
				timer.scheduleFunction(responseTime, {artyTasks[initiatorName].unitID, "Out of range of artillery support: "..tostring(math.floor(distKm)).." Km"}, timer.getTime() + responseTimeVar)

			else
				--initiates the artilleryman's response with a time delay ~= 5s
				timer.scheduleFunction(responseTime, {artyTasks[initiatorName].unitID, "Artillery not available"}, timer.getTime() + responseTimeVar)

			end

		else
			-- trigger.action.outTextForUnit( artyTasks[_initiatorName].unitID, "Arty Requested Without Marker", 10)
			--initiates the artilleryman's response with a time delay ~= 5s
			timer.scheduleFunction(responseTime, {artyTasks[initiatorName].unitID, "Arty Requested Without Marker"}, timer.getTime() + responseTimeVar)
		end

		_artyCall = 0

	end
end



-- ************************************* ____ ****************************************************
-- ************************************* Main ****************************************************
-- ************************************* ____ ****************************************************


-- trigger.action.outText("Arty spotter script "..version.." loaded", 10)
-- Map Marker Text - read and process
-- Function to remove spaces from a string
local function removeSpaces( _text )

	_text = _text:gsub( " ", "" )
	_text = _text:gsub( "-", "" )
	return _text

end

-- Function to validate the structure of the MGRS coordinate
local function checkValidMGRS( _mgrs, len)
	if len == 13 then
			-- Pattern: 2 digits 1 letter UTM Zone, 2 letters MGRS Digraph, 4 digits Easting, 4 digits Northing
			return _mgrs:match("^%d%d%u%u%u%d%d%d%d%d%d%d%d$")
		elseif len == 10 then
			-- Pattern: 2 letters MGRS Digraph, 4 digits Easting, 4 digits Northing
			return _mgrs:match("^%u%u%d%d%d%d%d%d%d%d$")

		elseif len == 8 then
			-- Pattern: 4 digits Easting, 4 digits Northing
			return _mgrs:match("^%d%d%d%d%d%d%d%d$")
		else
			return false
	end
end

-- Function to validate and complete MGRS coordinates
local function processMGRS( _text, _playerPos, initiatorName )
	local _cleanedText = string.upper( removeSpaces( _text ) )
	local len = #_cleanedText

	local _isValidMGRS = checkValidMGRS( _cleanedText, len)

	if _isValidMGRS then

		trigger.action.outTextForUnit( artyTasks[initiatorName].unitID, "Processing MGRS: " .. _cleanedText, 10)

		if len == 13 then

			-- Complete MGRS coordinate
			return _cleanedText

		elseif len == 10 then

			-- Add UTM Zone based on player position
			local _utmZone = coord.LLtoMGRS(_playerPos.Lat, _playerPos.Lon).UTMZone
			return _utmZone .. _cleanedText

		elseif len == 8 then

			-- Add UTM Zone and MGRS Digraph based on player position
			local _mgrs = coord.LLtoMGRS( _playerPos.Lat, _playerPos.Lon )
			return _mgrs.UTMZone .. _mgrs.MGRSDigraph .. _cleanedText

		else

			-- Invalid MGRS coordinate
			return nil
		end

	else

		trigger.action.outTextForUnit( artyTasks[initiatorName].unitID, "Invalid text input: " .. _cleanedText, 10)
		return nil

	end
end

-- Function to convert a valid MGRS to vec3
local function MGRStoVec3( _mgrs )
	local lat, lon = coord.MGRStoLL( _mgrs )
	local vec3 = coord.LLtoLO( lat, lon, 0 )
	return vec3
end

-- Function to check if the initiator is valid based on restrictions
local function isValidInitiator(initiator)
    local isValid = false

	if not initiator then
		return false
	end

    -- Check type restriction	
    if user_restrictByType == "helo" then
        if initiator:getDesc().category == Unit.Category.Helicopter then
            isValid = true
			env.info("CG_ArtySpotter: isValidInitiator A: helo Unit.Category.Helicopter ")
        end
    end

    -- -- Check name restriction
    -- -- if user_restrictByUnitName ~= "" then
	-- if initiator.getPlayerName then

    --     -- local name = initiator:getName():lower()

	-- 	local name = initiator:getPlayerName()

    --     if name:find(user_restrictByUnitName:lower()) then
	-- 		isValid = true
	-- 		env.info("CG_ArtySpotter: isValidInitiator B: initiator:getPlayerName() ")
    --     end
    -- end



	-- DCE environment
	if camp.spotterAircraft and initiator.getDesc then
		local description = initiator:getDesc()
		if description and description.typeName then
            if camp.spotterAircraft[description.typeName] then
				isValid = true
				env.info("CG_ArtySpotter: isValidInitiator B: camp.spotterAircraft "..tostring(description.typeName))
			end
        end
	end

	return isValid
end

-- Function to check if the marker text has the required prefix and remove it
local function checkAndRemovePrefix(text)

	local test = text:sub(1, #user_markerPrefix)

	 if user_markerPrefix ~= "" and text:sub(1, #user_markerPrefix) == user_markerPrefix then
		return true, text:sub(#user_markerPrefix + 1)
	elseif user_markerPrefix == "" then
		return true, text
	else
		return false, text
	end

end


-- Event handler for map marker creation
local function onPlayerAddMarker(event)

	if event.id == world.event.S_EVENT_BIRTH then

		if event.initiator and Object.getCategory(event.initiator) ~= Object.Category.STATIC and event.initiator:getPlayerName() then

			local gpGid = event.initiator:getGroup():getID()
			local Uid = event.initiator:getID()
			local initiatorName = event.initiator:getPlayerName()

			env.info("CG_ArtySpotter: S_EVENT_BIRTH: groupId: "..tostring(gpGid))
			env.info("CG_ArtySpotter: S_EVENT_BIRTH: Uid: "..tostring(Uid))
			env.info("CG_ArtySpotter: S_EVENT_BIRTH: initiatorName: "..tostring(initiatorName))

			missionCommands.removeItemForGroup(gpGid, {"Artillery Init"})

			if not menuRadioInit then menuRadioInit = {} end
			menuRadioInit[initiatorName] = {}

			menuRadioInit[initiatorName] = missionCommands.addCommandForGroup(gpGid, 'Artillery Init', nil, menuAccueil, Uid)

		end

	elseif  event.id == world.event.S_EVENT_MARK_ADDED  then  --and user_markerPrefix == ""

		trigger.action.outText("Marker added", 5)

		if not event.initiator then
			event.initiator = getPlayerControlledUnit()
		end

		-- env.info("CG_ArtySpotter: MARK_ADDED 2 event.initiator "..tostring(event.initiator))
		-- _affiche(event.initiator, "CG_ArtySpotter: MARK_ADDED 2 event.initiator")

		if isValidInitiator(event.initiator) then
			trigger.action.outText("initiator isValidInitiator", 5)

			env.info("CG_ArtySpotter: MARK_ADDED 3 initiator isValidInitiator ")

			--no time to add a prefix when adding a marker
			local hasPrefix = true

            if hasPrefix then

				local _targetPosXZ = event.pos

				if event.initiator and event.initiator.getPlayerName then

					local initiatorName = event.initiator:getPlayerName()
					local _playerPosXZ = event.initiator:getPoint()


					-- Store position**********************************************************

					if not artyTasks[initiatorName] then
						artyTasks[initiatorName] = tableOfClient
					end

					trigger.action.outTextForUnit( event.initiator:getID(), "Marker added", 5)
					env.info("CG_ArtySpotter: MARK_ADDED 5 Marker added")

					artyTasks[initiatorName].playerPosXZ = _playerPosXZ
					artyTasks[initiatorName].targetPosXZ = _targetPosXZ
					artyTasks[initiatorName].unitID = event.initiator:getID()
					artyTasks[initiatorName].initiator = event.initiator
					artyTasks[initiatorName].MARKER_FOUND = true

					-- Add menu items for the initiator's group
					local groupId = event.initiator:getGroup():getID()
					artyTasks[initiatorName].groupID = groupId

					-- if menuItems == false then 
					if artyTasks[initiatorName].menuItems == false or artyTasks[initiatorName].menuItems == nil then
						addMenuItems(groupId, initiatorName)
					end

				end
			end
		else
            --trigger.action.outText("You do not have permission to add a marker.", 5)
        end

	elseif event.id == world.event.S_EVENT_MARK_CHANGE then

		if not event.initiator then
			event.initiator = getPlayerControlledUnit()
		end

        if isValidInitiator(event.initiator) then

			local hasPrefix, cleanedText = checkAndRemovePrefix(event.text)

            -- if hasPrefix or markerIsPosition then

			env.info("CG_ArtySpotter: S_EVENT_MARK_CHANGE  hasPrefix "..tostring(hasPrefix))
			env.info("CG_ArtySpotter: S_EVENT_MARK_CHANGE  cleanedText "..tostring(cleanedText))

			if hasPrefix then

				local markText = cleanedText

				trigger.action.outTextForUnit( event.initiator:getID(), "Text: "..markText, 5)

				if markText and event.initiator then

					-- local initiatorName = event.initiator:getName()
					local initiatorName = event.initiator:getPlayerName()
					artyTasks[initiatorName].MARKER_FOUND = true
					local playerUnit = event.initiator

					if not artyTasks[initiatorName] then
						artyTasks[initiatorName] = {}
					end

					artyTasks[initiatorName].initiator = event.initiator
					artyTasks[initiatorName].unitID = event.initiator:getID()

					trigger.action.outTextForUnit( event.initiator:getID(), "Marker changed", 5)
					env.info("CG_ArtySpotter: Marker changed")

					if playerUnit then

						if markText ~= "" then

							local playerPosXZ = playerUnit:getPoint()
							local lat, lon = coord.LOtoLL(playerPosXZ)
							local playerPosition = { Lat = lat, Lon = lon }
							local validMGRS = processMGRS(markText, playerPosition, initiatorName)

							if validMGRS then

								trigger.action.outTextForUnit( artyTasks[initiatorName].unitID, "Valid MGRS: " .. validMGRS, 10)

								local tmpMGRS = {
									UTMZone = string.sub(validMGRS, 1, 3),
									MGRSDigraph = string.sub(validMGRS, 4, 5),
									Easting = tonumber(string.sub(validMGRS, 6, 9)) * 10,
									Northing = tonumber(string.sub(validMGRS, 10, 13)) * 10
								}

								local targetPoint = MGRStoVec3(tmpMGRS)
								targetPoint.y = land.getHeight({ x = targetPoint.x, y = targetPoint.z })

								artyTasks[initiatorName].targetPosXZ = targetPoint
								artyTasks[initiatorName].playerPosXZ = playerPosXZ

							else
								trigger.action.outTextForUnit( artyTasks[initiatorName].unitID, "Invalid MGRS coordinate entered.", 10)
							end

						else

							artyTasks[initiatorName].targetPosXZ.y = land.getHeight({ x = artyTasks[initiatorName].targetPosXZ.x, y = artyTasks[initiatorName].targetPosXZ.z })

						end

						local _groupId = event.initiator:getGroup():getID()
						artyTasks[initiatorName].groupID = _groupId

						-- if menuItems == false then 
						-- 	addMenuItems(groupId, initiatorName)
						-- end
						if artyTasks[initiatorName].menuItems == false or artyTasks[initiatorName].menuItems == nil then
							addMenuItems(_groupId, initiatorName)
						end
					end
				end
			end
		else
            --trigger.action.outText("You do not have permission to change this marker.", 5)
		end

    elseif event.id == world.event.S_EVENT_MARK_REMOVED then

        trigger.action.outText("Marker removed", 5)

		if not event.initiator then
			event.initiator = getPlayerControlledUnit()
		end

        if event.initiator then

            -- local initiatorName = event.initiator:getName()
			local initiatorName = event.initiator:getPlayerName()

			_affiche(initiatorName, " S_EVENT_MARK_REMOVED initiatorName")

			if initiatorName and artyTasks[initiatorName] then

				removeMenuItems(initiatorName)
                artyTasks[initiatorName] = nil

            end
        end
	end
end

--sur certaines map en solo (Syria) l'evenement Birth n'est pas detectée
local function CGAS_timerPlayerMenu(arg)
	if menuRadioInit == nil then

		local playerObj = getPlayerControlledUnit()
		if playerObj then
			
			

			local initiatorName = playerObj:getPlayerName()
			local Uid = playerObj:getID()
			local gpGid = playerObj:getGroup():getID()

			missionCommands.removeItemForGroup(gpGid, {"Artillery Init"})

			env.info("CG_ArtySpotter: CGAS_timerPlayerMenu: playerObj: "..tostring(playerObj))
			env.info("CG_ArtySpotter: CGAS_timerPlayerMenu: initiatorName: "..tostring(initiatorName))
			env.info("CG_ArtySpotter: CGAS_timerPlayerMenu: Uid: "..tostring(Uid))
			env.info("CG_ArtySpotter: CGAS_timerPlayerMenu: gpGid: "..tostring(gpGid))

			menuRadioInit = {}
			menuRadioInit[initiatorName] = {}

			menuRadioInit[initiatorName] = missionCommands.addCommandForGroup(gpGid, 'Artillery Init', nil, menuAccueil, Uid)
		end

	end
end

-- Register the event handler
local EventHandler3 = { f = onPlayerAddMarker }
function EventHandler3:onEvent(e)
  self.f(e)
end
world.addEventHandler(EventHandler3)

timer.scheduleFunction(CGAS_timerPlayerMenu, nil, timer.getTime() + 5)

env.info("CG_ArtySpotter: End of loading CG_ArtySpotter script created by Carsten Gurk aka Don Rudi")
-- trigger.action.outText("CG_ArtySpotter: End of loading CG_ArtySpotter script created by Carsten Gurk aka Don Rudi", 10)

