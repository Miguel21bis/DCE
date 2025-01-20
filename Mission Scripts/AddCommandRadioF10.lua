-- Adds functions in radio menu F10
--Script attached to mission and executed via trigger
--Functions accessed via LUA Run Script
------------------------------------------------------------------------------------------------------- 
--player can request emergency resupply with S-3B's
-- It is possible to send the whole PACK in RTB to avoid unnecessary losses. 
------------------------------------------------------------------------------------------------------- 
-- last modification  cleanCode_b adjustment_h M81_a debug_h
if not versionDCE then versionDCE = {} end
versionDCE["Mission Scripts\AddCommandRadioF10.lua"] = "1.13.47"
------------------------------------------------------------------------------------------------------- 
-- cleanCode_b				(b springCleaning)(a: remove RemovePlane)
-- adjustment_h				(h avoid SAM zone)(g force RTB if bingo)(f ENI table)(e: add sar_F10)(d GetHeading)(c coalitionIdNumeric)(b group Item Radio)(a: ajust function trigo)
-- debug_h					(h A/A off sur avoidZone)(g no menu in SP)(f getCategory)(e getHeading Z)(d: tanker exist)n'affiche pas les messages d'error sauf à la fin de mission
-- debug_bonfor_a			RTB from to inversé
-- modification M81_a		text announcement of contacts as seen by EWR and SAM radar
-- modification M78_a		LatLon positions added and unit display removed on MAP F10 (a dcs_to_gps)
-- modification M69_a		getOut (a allows you to remove the pilot from a crashed helicopter, for immediate or later recovery)
-- modification M68_a		add AFAC task
-- modification M60_a		add CTLD (a JTAC)
-- modification M36_e		(e: 1 h) (d: add timer) MenuRadio request manual TurnIntoWind
-- modification M36_e		Help CAP (e: camp rouge et bleu)
-- modification M32_d		E-2C automatic retreat (d only if fighter)(c: debug)
-- modification M29_i		Added MenuRadio F10  (i:escorte to RTB(@bonfor))(h:strike or SEAD only packages to RTB(@bonfor))(g:movePlane) (f: CallTankRefuel camp rouge et bleu)
------------------------------------------------------------------------------------------------------- 

if not camp.debugInGamePopup then
	env.setErrorMessageBoxEnabled(false)
end



env.info("ACRF10 version of Lua _VERSION "..tostring(_VERSION))

-- for k, v in pairs(AI.Option.Air.val) do
--     env.info(k .. " = " .. tostring(v))
-- end

-- env.info("Constante REACTION_ON_THREAT : " .. tostring(AI.Option.Air.id.REACTION_ON_THREAT))
-- env.info("Valeur EVADE_FIRE : " .. tostring(AI.Option.Air.val.EVADE_FIRE))
-- env.info("Constante AAA_EVADE_FIRE : " .. tostring(AI.Option.Air.val.REACTION_ON_THREAT.AAA_EVADE_FIRE))
-- env.info("Valeur EVADE_FIRE : " ..        tostring(AI.Option.Air.val.REACTION_ON_THREAT.EVADE_FIRE))
-- env.info("ACRF10 start loading ACRF10 script ")

-- env.info("Object.Category.UNIT : " .. tostring(Object.Category.UNIT))
-- env.info("Object.Category.WEAPON : " ..  tostring(Object.Category.WEAPON))
-- env.info("Object.Category.STATIC : " .. tostring(Object.Category.STATIC))
-- env.info("Object.Category.BASE : " ..  tostring(Object.Category.BASE))
-- env.info("Object.Category.SCENERY : " .. tostring(Object.Category.SCENERY))
-- env.info("Object.Category.Cargo : " ..  tostring(Object.Category.Cargo))

-- SRSAudio = require('SRSAudio') -- Importer le module audio de SR


LastInjectFlightPlan = {}																--garde les derniers plan de vol injecté
tabBingoPlane = {}
GroundDamagedFlyingMachine = {}


EjectionSeatFrequency = {}
SumSoldierAliasPilot = 0
CustomLog = {}
zoneSAR = {}																									--table enumérant les helico SAR pour eviter d'en envoyer plusieurs aux memes endroits
EjectedPilotOnBoard = {}

coalitionId = {
	["0"] = "neutral",
	["1"] = "red",
	["2"] = "blue",
}

coalitionIdNumeric = {
	[0] = "neutral",
	[1] = "red",
	[2] = "blue",
}

coalitionIdNumericENI = {
	[0] = 1,
	[1] = 2,
	[2] = 1,
}

--variable global
DCS_Side = {"blue", "red", "neutrals"}

DCS_ENI_Side = {
	["blue"] = "red",
	["red"] = "blue"
	}

-- Unit.Category = {
-- 	AIRPLANE      = 0,
-- 	HELICOPTER    = 1,
-- 	GROUND_UNIT   = 2,
-- 	SHIP          = 3,
-- 	STRUCTURE     = 4
--   }
DCS_CategoryById = {
	[0] = Airplane,
	[1] = Helicopters,

}

Object_Category = {
	[1] = "UNIT",
	[2] = "WEAPON",
	[3] = "STATIC",
	[4] = "BASE",
	[5] = "SCENERY",
	[6] = "Cargo",
}

Unit_Category = {
	[0] = "AIRPLANE",
	[1] = "HELICOPTER",
	[2] = "GROUND_UNIT",
	[3] = "SHIP",
	[4] = "STRUCTURE",
  }

--   land.SurfaceType 
--   LAND             1
--   SHALLOW_WATER    2
--   WATER            3 
--   ROAD             4
--   RUNWAY           5

local radioCommands = {}
local flightPlanTimer = {}
local commandDB = {}
local tabJockerPlane = {}
local var_TPN_alreadyAdded = false

EWR_optionPlayer = {}

-- EWR_optionPlayer["OBT_test"] = {
-- 	EWR_on = true,
-- }
-- EWR_optionPlayer["ArealTest-2"] = {
-- 	EWR_on = true,
-- }
-- EWR_optionPlayer["Pack 5 - 70 Squadron - Strike 1-4"] = {
-- 	EWR_on = true,
-- }
-- EWR_optionPlayer["Pack 5 - 70 Squadron - Strike 1-2"] = {
-- 	EWR_on = true,
-- }




function _affiche(_table, titre, prof)

	--export custom mission log
	local logExp = "logExp  "

	-- prof = profondeur de niveau dans la hierarchie
	if not prof or prof == nil then
		prof = 999
	end
  	logExp = logExp.."\n"

    if titre == nil then logExp = logExp.. string.format(" _affiche() titre = nil ")
    elseif type( titre) == "string" then
		logExp = logExp.. string.format(" _affiche(titre) "..tostring(titre)).."\n"
	end

	if type( _table) == "table"  then --and  (table.getn(_table) ~= 0 or table.getn(_table) ~= nil

		for a, b in pairs(_table) do --for a, b in pairs(event.initiator) do --for a, b in pairs(_ammo) do
			-- logExp.. " _affiche( a  ) ".. tostring(a).."\n"  

			if  type(b) ~= "table" then
				logExp = logExp.." _affiche (a b)     "..tostring(a).." "..tostring(b).."\n"
			elseif type(b) == "table"   and prof >= 2 then
				for c, d in pairs(b) do
					logExp = logExp.. " _affiche(a c)     "..tostring(a).." "..tostring(c).."\n"


					if type(d)~= "table"  then
						logExp = logExp.. " _affiche(. d)                "..tostring(d).."\n"
					elseif type(d) == "table"  and prof >= 3 then
						for e, f in pairs(d) do
							-- logExp = logExp.. " _affiche( e)                     "..tostring(e).."\n"


							if type( f ) ~= "table"  then
								logExp = logExp.. " _affiche(e f)                          "..tostring(e).." "..tostring(f).."\n"
							elseif type( f ) == "table"  and prof >= 4 then
								logExp = logExp.. " _affiche( e)                                "..tostring(e).."\n"
								for g, h in pairs(f) do
									logExp = logExp.. " _affiche(Ig)                                 "..tostring(g).."\n"


									if type( h ) ~= "table"  then
										logExp = logExp.. " _affiche(g h)                                    "..tostring(g).." "..tostring(h).."\n"
									elseif type( h ) == "table"  and prof >= 5 then
										logExp = logExp.. " _affiche( g)                                         "..tostring(g).."\n"
										for i, j in pairs(h) do
											-- logExp = logExp.. " _affiche(i)                                         "..tostring(i).."\n"


											if type( j ) ~= "table"  then
												logExp = logExp.. " _affiche(i j)                                              "..tostring(i).." "..tostring(j).."\n"
											elseif type( j ) == "table" and prof >= 6 then
												logExp = logExp.. " _affiche(i)                                                  "..tostring(i).."\n"
												for k, l in pairs(j) do
													-- logExp = logExp.. " _affiche(k)                                                   "..tostring(k).."\n"

													if type( l ) ~= "table"  then
														logExp = logExp.. " _affiche(k l)                                                   "..tostring(k).." "..tostring(l).."\n"
													elseif type( l ) == "table" and prof >= 7 then
														logExp = logExp.. " _affiche(k)                                                       "..tostring(k).."\n"
														for m, n in pairs(l) do
															logExp = logExp.. " _affiche(m)                                                        "..tostring(m).."\n"


															if type( n ) ~= "table"  then
																logExp = logExp.. " _affiche(m n)                                                   "..tostring(m).." "..tostring(n).."\n"
															elseif type( n ) == "table" and prof >= 7 then
																logExp = logExp.. " _affiche(m)                                                       "..tostring(m).."\n"
																for o, p in pairs(n) do
																	logExp = logExp.. " _affiche(o)                                                        "..tostring(o).."\n"


																	if type( p ) ~= "table"  then
																		logExp = logExp.. " _affiche(p)                                                             "..tostring(p).."\n"
																	elseif type( p ) == "table"  and prof >= 8 then
																		logExp = logExp.. " p est une table                                                              "..tostring(p).."---------------------------".."\n"

																	end
																end
															end --if
														end --for l
													end --if
												end -- for j
											end --if
										end -- for h
									end --if
								end --for f
							end --elseif
						end -- for d
					end -- if d
				end -- for v
			end -- if v
		end  -- for _table

	else logExp = logExp.. "_affiche NoTable==> " ..tostring(_table).."\n"

	end -- if if type( _table) == "table"


	-- log.write('MIGUEL.EXPORT',log.INFO,logExp)

	env.info( logExp )

end -- function affiche

-- sorts tables alphabetically, to be used in a "for" loop instead of pairs or ipairs
-- http://www.lua.org/pil/19.3.html
function PairsByKeys (t, f)
    local a = {}
	local initType
	local dontSort = false
    for n in pairs(t) do initType = type(n) break end
	for n in pairs(t) do
		table.insert(a, n)
		if type(n) ~= initType then dontSort = true end
	end
	if not dontSort then
		table.sort(a, f)
	end
    local i = 0      -- iterator variable
    local iter = function ()   -- iterator function
        i = i + 1
        if a[i] == nil then return nil
        else return a[i], t[a[i]]
        end
    end
    return iter
end


--function to turn a table into a string
function TableSerialization(t, i, params)

	local crlf = ""
	local tab1 = ""
	for n = 1, i do																	--controls the indent for the current text line
		tab1 = tab1 .. "\t"
	end

	local text = "\n"..crlf..tab1.."{\n"..crlf

	local tab = ""
	for n = 1, i + 1 do																	--controls the indent for the current text line
		tab = tab .. "\t"
	end

	-- if params then
	-- 	table.sort(t, function(a,b) return a[params] > b[params]  end)
	-- end
	local stop = false
	for k,v in PairsByKeys(t) do
		if type(k) == "string" then
			k = string.gsub(k, "\n", "\\\n" )
			k = string.gsub(k, "\"", "\\\"" )
			k = string.gsub(k, "'", "\\\'" )
			text = text .. tab .. '["' .. k .. '"] = '
		else
			text = text .. tab .. "[" .. k .. "] = "
		end
		if type(v) == "string" then
			v = string.gsub(v, "\n", "\\\n" )
			v = string.gsub(v, "\"", "\\\"" )
			v = string.gsub(v, "'", "\\\'" )
			text = text .. '"' .. v .. '",\n'..crlf
		elseif type(v) == "number" then
			text = text .. v .. ",\n"..crlf
		elseif type(v) == "table" then
			text = text .. TableSerialization(v, i + 1)
		elseif type(v) == "boolean" then
			if v == true then
				text = text .. "true,\n"..crlf
			else
				text = text .. "false,\n"..crlf
			end
		elseif type(v) == "function" then
			text = text .. v .. ",\n"..crlf
		elseif v == nil then
			text = text .. "nil,\n"..crlf
		end
	end
	tab = ""
	for n = 1, i do																		--indent for closing bracket is one less then previous text line
		tab = tab .. "\t"
	end
	if i == 0 then
		text = text .. tab .. "}\n"		..crlf												--the last bracket should not be followed by an comma
	else
		text = text .. tab .. "},\n"	..crlf												--all brackets with indent higher than 0 are followed by a comma
	end
	return text
end

--function to return distance between two vector2 points
function GetDistance(p1, p2)
	local deltax = p2.x - p1.x
	local deltay = p2.y - p1.y
	return math.sqrt(math.pow(deltax, 2) + math.pow(deltay, 2))
end

function radToDeg(_rad)
	Deg = _rad * (180/math.pi)
	return Deg
end

--function to make a deep copy of a table
function Deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[Deepcopy(orig_key)] = Deepcopy(orig_value)
        end
        setmetatable(copy, Deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function GetHeading(p1, p2)
	local deltax = p2.x - p1.x
	local deltay
	if (p2.z and p1.z) then
		deltay = p2.z - p1.z
	else
		deltay = p2.y - p1.y
	end
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

local function getOppositePointOnCircle(posA, centerCircle)
    -- Calculer les coordonnées opposées sur le cercle
    local bx = 2 * centerCircle.x - posA.x
    local by = 2 * centerCircle.y - posA.y
    return bx, by
end


--function to return a new point offset from an initial point
	-- angle en degré avec nord geographique (pas trigonometrique)
function GetOffsetPoint(point, heading, distance)
	return {
		x = point.x + math.cos(math.rad(heading)) * distance,
		y = point.y + math.sin(math.rad(heading)) * distance
	}
end

--https://github.com/mrSkortch/MissionScriptingTools/releases
--- Returns heading of given unit.
-- @tparam Unit unit unit whose heading is returned.
-- @param rawHeading
-- @treturn number heading of the unit, in range
-- of 0 to 2*pi.
function GetHeadingByPos(unit)
	local unitpos = unit:getPosition()
	local Heading = 0
	if unitpos then
		local Heading = math.atan2(unitpos.x.z, unitpos.x.x)
		if Heading < 0 then
			Heading = Heading + 2*math.pi	-- put heading in range of 0 to 2*pi
		end
		return Heading
	else
		return nil
	end
end

--function to return the angle between two headings
function GetDeltaHeadingIM(h1, h2)
	local delta = h2 - h1
	if delta > 180 then
		delta = delta - 360
	elseif delta <= -180 then
		delta = delta + 360
	end
	return delta
end

--check si un point est dans le polygone
function CheckPointInPoly2(point, poly)

    local crossings = 0
	for n = 1, #poly - 1 do
         if (poly[n].y < point.y and poly[n + 1].y > point.y) or (poly[n].y > point.y and poly[n + 1].y < point.y) then
            local dx = poly[n + 1].x - poly[n].x
			local dy = poly[n + 1].y - poly[n].y
			local delta_point_y = point.y - poly[n].y
			local delta_point_x = dx / dy * delta_point_y
			if poly[n].x + delta_point_x > point.x then
				crossings = crossings + 1
			end
		end
	end

	if crossings % 2 ~= 0 then
		return true
	else
		return false
	end
end


local function localGetPlayerObj()
	local playerObj = nil
	for coalitionID = 1, 2 do
		local pUnits = coalition.getPlayers(coalitionID)

		for unitN, unit in ipairs(pUnits) do
			if unit and unit:getPlayerName() then
				playerObj = unit
				break
			end
		end
		if playerObj then
			break
		end
	end
	return playerObj
end

local function setErrorMessageBoxShedul()
	if not camp.debugInGamePopup then
		env.setErrorMessageBoxEnabled(false)
	end
end

function getGroupById(groupId)
    for coalitionId = 1, 2 do -- 1 = Red, 2 = Blue
        local groups = coalition.getGroups(coalitionId)
        for _, group in ipairs(groups) do
            if group:getID() == groupId then
                return group
            end
        end
    end
    return nil -- Groupe introuvable
end

--nettoie les noms de certain caractere spéciaux (" et ')
function CleanName(name)

	name = name:gsub("['\"]", '')

	return name

end

function normalizeAngle(angle)
    return (angle % 360 + 360) % 360
end





function FctRemovePlane(_unit)
	_unit:destroy()
end

function RemovePlane(PlayerGroup)

	local PlayerUnits = PlayerGroup:getUnits()
	local PlayerUnit = PlayerUnits[1]
	local PlayerUnitPoint = PlayerUnit:getPoint()
	local Coalition = PlayerUnit:getCoalition()
	missionCommands.removeItem( {"nearby aircraft"})
	local requestM = missionCommands.addSubMenu('nearby aircraft'  )
	local RPlane = {}
	local groups = coalition.getGroups(Coalition, Group.Category.AIRPLANE)
	for i, gp in pairs(groups) do
		local gpName = Group.getName(gp)
		local units = gp:getUnits()

		for n=1, #units do
			local _unit = units[n]
			if  _unit:isActive() and not _unit:inAir() then

				local description = _unit:getDesc()

				-- _affiche(description, "description")

				local unitPos = _unit:getPoint()
				local  gpGid = Group.getID(gp)
				local  UnitId = Unit.getID(_unit)
				local unitCallsign = _unit:getCallsign()
				local distance = math.floor(math.sqrt(math.pow(unitPos.x - PlayerUnitPoint.x, 2) + math.pow(unitPos.z - PlayerUnitPoint.z, 2)))
				if distance <= 900 then
					env.info(gpName.." "..unitCallsign.." "..distance.."m ")
					-- trigger.action.outText(gpName.." "..unitCallsign.." "..distance.."m ", 15)	--FOR DEBUG
					-- local subN1 = missionCommands.addSubMenu(gpName.." "..UnitId, requestM)
					RPlane[UnitId] = missionCommands.addCommand(gpName.." "..unitCallsign, requestM, FctRemovePlane, _unit)
				end
			end
		end
	end
end

-- _affiche(titre) ACRF10 DCE Desc
-- _affiche (a b)     speedMax0 388.10000610352
-- _affiche (a b)     massEmpty 10550
-- _affiche (a b)     range 1950
-- _affiche(a c)           box min
-- _affiche(e f)                          y -2.3299200534821
-- _affiche(e f)                          x -10
-- _affiche(e f)                          z -9
-- _affiche(a c)           box max
-- _affiche(e f)                          y 2.7555100917816
-- _affiche(e f)                          x 11
-- _affiche(e f)                          z 9
-- _affiche (a b)     Hmax 18500
-- _affiche (a b)     Kmax 0.68999999761581
-- _affiche (a b)     _origin 
-- _affiche (a b)     speedMax10K 693.25
-- _affiche (a b)     NyMin -3
-- _affiche (a b)     fuelMassMax 3800
-- _affiche (a b)     speedMax 693.25
-- _affiche (a b)     NyMax 6.5
-- _affiche (a b)     massMax 17800
-- _affiche (a b)     RCS 4
-- _affiche (a b)     displayName mig-23ml
-- _affiche (a b)     life 16
-- _affiche (a b)     VyMax 240
-- _affiche (a b)     Kab 3
-- _affiche(a c)           attributes Air
-- _affiche(d)                true
-- _affiche(a c)           attributes Fighters
-- _affiche(d)                true
-- _affiche(a c)           attributes NonAndLightArmoredUnits
-- _affiche(d)                true
-- _affiche(a c)           attributes NonArmoredUnits
-- _affiche(d)                true
-- _affiche(a c)           attributes All
-- _affiche(d)                true
-- _affiche(a c)           attributes Battle airplanes
-- _affiche(d)                true
-- _affiche(a c)           attributes Planes
-- _affiche(d)                true
-- _affiche (a b)     typeName MiG-23MLD
-- _affiche (a b)     category 0

local hotSpotAirDefense = {
    red = {},
    blue = {},
}

local function calculateDistance(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

local function hotSpotSAM()
    if not camp.groundthreats then return end

    local clusterThreshold = 100000 -- Distance max pour regrouper les SAMs

    for side, antiAirCover in pairs(camp.groundthreats) do
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
        hotSpotAirDefense[side] = {}
        for _, cluster in ipairs(clusters) do
            table.insert(hotSpotAirDefense[side], { x = cluster.centerX, y = cluster.centerY })
        end
    end
end


local function chooseBestHotspot(actualPos, side)
    local bestHotSpot = nil
    local shortestDistance = math.huge

    for _, hotspot in ipairs(hotSpotAirDefense[side]) do
        local dist = calculateDistance(actualPos.x, actualPos.y, hotspot.x, hotspot.y)
        if dist < shortestDistance then
            shortestDistance = dist
            bestHotSpot = hotspot
        end
    end

    return bestHotSpot
end



-- interdit aux CAP et Intercepteur d'entrer dans une zone SAM connu
local function avoidArea()

	-- env.info("ACRF10_avoidArea A0 camp.groundthreats.? "..tostring(camp.groundthreats))

	local debug_avoidArea = false

	if not camp.groundthreats then return end

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
				-- _affiche(flightPlanTimer, "ACRF10_avoidArea flightPlanTimer")
			end

			if (string.find(gpName,"CAP") or string.find(gpName,"Intercept")) and passTimer then
				local wingman = gp:getUnits()

				for wingmanN, _unit in ipairs(wingman) do

					if _unit and _unit:isActive() and _unit:inAir() then
						local currentPoint = _unit:getPoint()
						local currentPointXY = {
							x = currentPoint.x,
							y = currentPoint.z,
							z = currentPoint.y,
						}

						local unitName = _unit:getName()
						local callSign = _unit:getCallsign()

						local description = _unit:getDesc()

						local speedMax = 300
						local speedCruise = 300
						local Hcruise = 7600
						if description then
							if description.speedMax then
								speedMax = description.speedMax
							end
							if description.speedMax0 then
								speedCruise = description.speedMax0 / 2
							end
							if description.Hmax then
								Hcruise = description.Hmax / 3
							end
						end

						local ctr = _unit:getGroup():getController()

						local ENI_side = DCS_ENI_Side[coalitionIdNumeric[sideNum]]

						for threatN, threat in pairs(camp.groundthreats[ENI_side]) do

							if threat and threat.class and threat.class == "SAM"  then

								local distance = math.sqrt(math.pow(threat.x - currentPointXY.x, 2) + math.pow(threat.y - currentPointXY.y, 2))

								-- if debug_avoidArea or (distance and distance <= threat.range) then
								if debug_avoidArea or (distance and distance <= ((2 / 3) * threat.range)) then


									env.info( "ACRF10_avoidArea I4_______  ")

									local foundGroup = false
									local breaktab = false
									local CAP_group = {
										name = "",
										from = 0,
										to = 0,
										task = {},
										base = {
											x = 0,
											y = 0 ,
										},
										orbitCAP = {
											x = 0,
											y = 0 ,
											altitude = 0,
											speed = 0,
										},
										sation1 = {},
										sation2 = {},
									}

									for _coalition, coalition in pairs(env.mission.coalition) do
										env.info( "ACRF10_avoidArea J________  _coalition? "..tostring(_coalition).." coalitionIdNumeric[sideNum]? "..tostring(coalitionIdNumeric[sideNum]).." sideNum? "..tostring(sideNum))

										if _coalition == coalitionIdNumeric[sideNum] then
											for Ncountry, _country in pairs(coalition.country) do
												if _country.plane then
													for Ngroup, _group in pairs(_country.plane.group) do
														if _group.groupId and _group.groupId == gpGid then

															CAP_group.name = _group.name
															foundGroup = true

															-- env.info( "ACRF10_avoidArea M        found Froup "..tostring(unitName))

															--Station
															for pointN, value in ipairs(_group.route.points) do
																if value.name == 'Station' then
																	CAP_group.to = pointN
																	CAP_group.from = pointN - 1
																	if value.task then


																		if value.task.params and value.task.params.tasks then

																			for _, valueTasks in ipairs(value.task.params.tasks) do

																				if valueTasks.params.task.id == "EngageTargetsInZone" then

																					CAP_group.sation1 = _group.route.points[pointN]
																					CAP_group.sation2 = _group.route.points[pointN+1]

																					-- CAP_group.orbitCAP.x = valueTasks.params.task.params.x
																					-- CAP_group.orbitCAP.y = valueTasks.params.task.params.y


																				elseif valueTasks.params.task.id == "Orbit" then
																					CAP_group.orbitCAP.altitude = valueTasks.params.task.params.altitude
																					CAP_group.orbitCAP.speed = valueTasks.params.task.params.speed
																				end
																			end
																		end
																	end
																	break
																end
															end

															--BaseXY

															CAP_group.base = {
																x = _group.route.points[#_group.route.points].x,
																y = _group.route.points[#_group.route.points].y,
															}

															breaktab = true
															break
														end
													end
												end
												if breaktab then break end
											end
										end
										if breaktab then break end
									end

									if CAP_group.to ~= 0 then
										local switchtask = {
												id = "SwitchWaypoint",
													params = {
														goToWaypointIndex = CAP_group.to,
														fromWaypointIndex = CAP_group.from
												}
											}
									end

									-- env.info( "ACRF10_avoidArea K0_______ currentPointXY.y: "..tostring(currentPointXY.y).." threat.name "..tostring(threat.name))

									local pointOfCoverage = chooseBestHotspot(currentPointXY, coalitionIdNumeric[sideNum])

									-- _affiche(pointOfCoverage, "ACRF10_avoidArea pointOfCoverage")


									local altCircle = Hcruise + (math.random(1,10) * 10)
									local timeCircle = current_time

									if CAP_group.orbitCAP.altitude ~= 0 then
										Hcruise = CAP_group.orbitCAP.altitude
									elseif Hcruise < currentPointXY.z then
										Hcruise = currentPointXY.z
									end

									if CAP_group.orbitCAP.speed ~= 0 then
										speedCruise = CAP_group.orbitCAP.speed
									end

									if CAP_group.orbitCAP.altitude ~= 0 then
										altCircle = CAP_group.orbitCAP.altitude
										timeCircle = timeCircle + 150

									else
										--temps d orbit pour intercepteur
										timeCircle = timeCircle + 900
									end



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
															alt = Hcruise,
															action = "Turning Point",
															type = "Turning Point",
															name = "Found pointOfCoverage"
														},
														{
															x = oppositePoint_x,
															y = oppositePoint_y,
															speed = speedCruise,
															alt = Hcruise,
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
															alt = Hcruise,
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
																			["number"] = 2,
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
																			["number"] = 2,
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
																			['number'] = 3,
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
																			['number'] = 4,
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
															x = CAP_group.base.x,
															y = CAP_group.base.y,
															speed = speedCruise,
															action = "Landing",
															type = "Land"
														}
													}
												}
											}
										}

										-- env.info( "ACRF10_avoidArea K2_______ #CAP_group.sation1: "..tostring(#CAP_group.sation1))
										if CAP_group.sation1 ~= nil and CAP_group.sation2 ~= nil and CAP_group.orbitCAP.altitude ~= 0 then

											-- env.info( "ACRF10_avoidArea K3A_______ ##flightPlan.params.route.points: "..tostring(#flightPlan.params.route.points).." type"..tostring(flightPlan.params.route.points[#flightPlan.params.route.points].type))

											-- table.insert(flightPlan.params.route.points, #flightPlan.params.route.points - 1, CAP_group.sation1)

											-- env.info( "ACRF10_avoidArea K3B_______ ##flightPlan.params.route.points: "..tostring(#flightPlan.params.route.points).." type"..tostring(flightPlan.params.route.points[#flightPlan.params.route.points].type))

											-- table.insert(flightPlan.params.route.points, #flightPlan.params.route.points - 1, CAP_group.sation2)

											local numPoints = #flightPlan.params.route.points
											local indexForStation1 = numPoints
											local indexForStation2 = numPoints +1 -- Station2 viendra après Station1

											-- env.info("ACRF10_avoidArea K3A_______ ##flightPlan.params.route.points: " .. tostring(numPoints) .. " type " .. tostring(flightPlan.params.route.points[numPoints].type))

											-- Insérer station1 et station2 à des indices fixes
											table.insert(flightPlan.params.route.points, indexForStation1, CAP_group.sation1)
											table.insert(flightPlan.params.route.points, indexForStation2, CAP_group.sation2)

											-- env.info("ACRF10_avoidArea K3B_______ ##flightPlan.params.route.points: " .. tostring(#flightPlan.params.route.points) .. " type " .. tostring(flightPlan.params.route.points[#flightPlan.params.route.points].type))

										end

									else --if NOT pointOfCoverage then

										local position = _unit:getPosition()
										-- local heading = math.atan2(position.x.z, position.x.x) -- Calcul du cap en radians

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
															alt = Hcruise,
															ETA_locked = false,
															action = "Turning Point",
															type = "Turning Point",
															name = "NOFound pointOfCoverage"
														},
														{
															x = oppositePoint_x,
															y = oppositePoint_y,
															speed = speedCruise,
															alt = Hcruise,
															speed_locked = true,
															ETA_locked = false,
															action = "Turning Point",
															type = "Turning Point"
														},
														--point à mi chemin entre le point 2 et 4
														{
															x = (oppositePoint_x + CAP_group.base.x ) / 2,
															y = (oppositePoint_y + CAP_group.base.y ) / 2,
															speed = speedCruise,
															alt = Hcruise,
															speed_locked = true,
															ETA_locked = false,
															action = "Turning Point",
															type = "Turning Point",
															-- cntrl:setOption(AI.Option.Air.id.PROHIBIT_AA, false)
														},
														{
															x = CAP_group.base.x,
															y = CAP_group.base.y,
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
										env.info( "ACRF10_avoidArea Z        NO foundGroup "..tostring(unitName).." "..callSign )
									end

									if flightPlan then
										ctr:resetTask()
										-- ctr:setOption(AI.Option.Air.id.REACTION_ON_THREAT, AI.Option.Air.val.EVADE_FIRE)
										ctr:setOption(AI.Option.Air.id.REACTION_ON_THREAT, 2)
										ctr:setOption(AI.Option.Air.id.PROHIBIT_AA, true) -- Désactiver l'engagement A/A
										ctr:setTask(flightPlan)
										flightPlanTimer[gpGid] = nowTime
										_affiche(flightPlanTimer, "ACRF10_avoidArea Z2 flightPlanTimer")
									end

									if camp.debug then
										local TimeSearchEngage = timer.getTime() + 5
										local logStr = "flightPlan = " .. TableSerialization(flightPlan, 0)
										local FlightNameClean = unitName:gsub('[%p%c%s]', '_')
										local logFile = io.open(PathDCE.."Debug\\"..FlightNameClean.."_"..TimeSearchEngage.."_avoidArea.lua", "w")

										if logFile then
											logFile:write(logStr)
											logFile:close()
										else
											env.info("DCE_avoidArea: Failed to open log file for writing.")
										end

										env.info("DCE_avoidArea ZZZ " .. tostring(unitName))
									end



									break -- il est entre dans une zone interdite, on l evacue et on s arrete là
								end

							end

						end

					end
				end
			end
		end
	end


	local groups = coalition.getGroups(coalition.side.BLUE, Group.Category.AIRPLANE)

	-- for i, gp in pairs(groups) do	


	-- end
	return timer.getTime() + 1
end

-- modification M32	E-2C automatic retreat 
function AirRetreat()

	local current_time = timer.getTime()

	local groups = coalition.getGroups(coalition.side.BLUE, Group.Category.AIRPLANE)

	for i, gp in pairs(groups) do

		local gpName = Group.getName(gp)

		if   string.find(gpName,"AWACS") then
			local units = gp:getUnits()
			local _unit = units[1]

			if _unit and _unit:getTypeName() == "E-2C" and _unit:isActive() and _unit:inAir() then
				local awacs_point = _unit:getPoint()
				local  gpGid = Group.getID(gp)
				local nameAwacs =  _unit:getName()
				if not RetreatTimeGp then RetreatTimeGp = {} end
				if not RetreatTimeGp[gpGid] then RetreatTimeGp[gpGid] = {} end
				if not RetreatTimeGp[gpGid].rTime then RetreatTimeGp[gpGid].rTime = 0  end

				if _unit and current_time >  RetreatTimeGp[gpGid].rTime then							--if _unit exists
					local ctr = _unit:getGroup():getController()										--get _unit controller
					local targets = ctr:getDetectedTargets()											--get detected targets of this EWR
					for t = 1, #targets do																--iterate through detected targets
						if targets[t].object and current_time >  RetreatTimeGp[gpGid].rTime then
							local objCat = Object.getCategory(targets[t].object)								--get object category
							if objCat == Object.Category.UNIT then															--object is a _unit
								local desc = targets[t].object:getDesc()								--get descriptor descriptor
								local descAwacs = _unit:getDesc()

								-- _affiche(titre) ACRF10 DCE Desc
								-- _affiche (a b)     speedMax0 388.10000610352
								-- _affiche (a b)     massEmpty 10550
								-- _affiche (a b)     range 1950
								-- _affiche(a c)           box min
								-- _affiche(e f)                          y -2.3299200534821
								-- _affiche(e f)                          x -10
								-- _affiche(e f)                          z -9
								-- _affiche(a c)           box max
								-- _affiche(e f)                          y 2.7555100917816
								-- _affiche(e f)                          x 11
								-- _affiche(e f)                          z 9
								-- _affiche (a b)     Hmax 18500
								-- _affiche (a b)     Kmax 0.68999999761581
								-- _affiche (a b)     _origin 
								-- _affiche (a b)     speedMax10K 693.25
								-- _affiche (a b)     NyMin -3
								-- _affiche (a b)     fuelMassMax 3800
								-- _affiche (a b)     speedMax 693.25
								-- _affiche (a b)     NyMax 6.5
								-- _affiche (a b)     massMax 17800
								-- _affiche (a b)     RCS 4
								-- _affiche (a b)     displayName mig-23ml
								-- _affiche (a b)     life 16
								-- _affiche (a b)     VyMax 240
								-- _affiche (a b)     Kab 3
								-- _affiche(a c)           attributes Air
								-- _affiche(d)                true
								-- _affiche(a c)           attributes Fighters
								-- _affiche(d)                true
								-- _affiche(a c)           attributes NonAndLightArmoredUnits
								-- _affiche(d)                true
								-- _affiche(a c)           attributes NonArmoredUnits
								-- _affiche(d)                true
								-- _affiche(a c)           attributes All
								-- _affiche(d)                true
								-- _affiche(a c)           attributes Battle airplanes
								-- _affiche(d)                true
								-- _affiche(a c)           attributes Planes
								-- _affiche(d)                true
								-- _affiche (a b)     typeName MiG-23MLD
								-- _affiche (a b)     category 0

								if desc.category == Unit.Category.AIRPLANE and (desc.attributes["Battle airplanes"] or desc.attributes.Fighters)  then												--descriptor category is airplane 
									--TODO ajouter ici les attributs interressant des chasseurs et non des transports
									--To know what attributes the object type has, look for the unit type script in sub-directories planes/, helicopter/s, vehicles, navy/ of ./Scripts/Database/ directory.
									--and desc.attributs ~= "Battleplane" and desc.attributs ~= "Fighter"

									-- attributes Air true
									-- attributes Fighters  true
									-- attributes NonAndLightArmoredUnits true
									-- attributes NonArmoredUnits true
									-- attributes All  true
									-- attributes Battle airplanes true
									-- attributes Planes true

									local target_point = targets[t].object:getPoint()					--get target point					
									local distance = math.sqrt(math.pow(awacs_point.x - target_point.x, 2) + math.pow(awacs_point.z - target_point.z, 2))

									if distance < 100000 then
									-- if distance < 150000 then 

										local callsign = _unit:getCallsign()
										env.info("ACRF10 DCE AWACS |03b|: Order to Retire "..distance)
										env.info("ACRF10 DCE AWACS |03c|: Order to Retire "..callsign.." Retreat to the aircraft carrier")
										trigger.action.outText(callsign.." Retreat to the aircraft carrier",10)

										--active le waypoint du PA										
										RetreatTimeGp[gpGid].rTime = current_time + 300

										local carrierDistance = 99999999
										local xRetreat = 0
										local yRetreat = 0
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
																	local carrierPos = carrier:getPoint()
																	local distance = math.sqrt(math.pow(carrierPos.x - awacs_point.x, 2) + math.pow(carrierPos.z - awacs_point.z, 2))
																	if distance < carrierDistance then
																		xRetreat = carrierPos.x
																		yRetreat = carrierPos.z
																		carrierDistance =  distance
																	end
																end
															end
														end
													end
												end
											end
										end


										for _coalition, coalition in pairs(env.mission.coalition) do
											if _coalition  == "blue" then
												for Ncountry, _country in pairs(coalition.country) do
													if _country.plane then
														for Ngroup, _group in pairs(_country.plane.group) do
															if _group.groupId == gpGid then

																-- si aucun CVN n'a été trouvé, on prend comme position de retraite l'ID "land"
																if xRetreat == 0 then
																	for key, value in ipairs(_group.route.points) do				-- recherche de la position safe du PA et une alti						
																		if value.type == 'Land' then
																			xRetreat = value.x
																			yRetreat = value.y
																		end
																	end
																end
																local retreatRoute = {}

																-- retreatRoute = _group.route.points										--copie de l'ancienne route
																retreatRoute = Deepcopy(_group.route.points)

																-- ajoute comme premier wpt leur position initial pour garder la fonction AWACS
																local FirstWPT = {
																	['alt'] = awacs_point.y,
																	['type'] = 'Turning Point',
																	['action'] = 'Turning Point',
																	['alt_type'] = 'BARO',
																	['speed_locked'] = true,
																	['y'] = awacs_point.z,
																	['x'] = awacs_point.x,
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


																table.insert(retreatRoute, 1, FirstWPT)

																--modifie les coordonées du premier wpt initial
																retreatRoute[2].x = xRetreat
																retreatRoute[2].y = yRetreat
																retreatRoute[2].alt = awacs_point.y
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
																for i=1, #retreatRoute[1].task.params.tasks do
																	retreatRoute[1].task.params.tasks[i].number = i
																end

																local Mission = {														--define mission for retreat AWACS
																		id = 'Mission',
																		params = {
																			route = {
																				points = retreatRoute
																			},
																		}
																	}


																-- local logStr = "Mission = " .. TableSerialization(Mission, 0)
																-- local logFile = io.open(PathDCE.."_"..nameAwacs.."_".. "Mission_AWACSretreatRoute.lua", "w")
																-- logFile:write(logStr)
																-- logFile:close()	

																Controller.setTask(ctr, Mission)										--activate task with mission for retreat AWACS
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
				end
			end
		end
	end
	return timer.getTime() + 1
end

local function bingo(gpGid, groupMission)

	for index, unit in pairs(groupMission:getUnits()) do

		--getPlayerName(unit)

		-- local humainUnit = getPlayerName(unit)


		local humainUnit = ""

		if unit and unit:getPlayerName() then
			humainUnit = unit:getPlayerName()
		end

		local callSign = Unit.getCallsign(unit)
		if not tabBingoPlane[gpGid] then tabBingoPlane[gpGid] = {} end
		if not tabJockerPlane[gpGid] then tabJockerPlane[gpGid] = {} end

		local  gpName = Group.getName(groupMission)
		-- env.info( " bingo() gpName  "..tostring(gpName).." groupMission.id_ "..tostring(groupMission.id_) )
		-- _affiche(groupMission, "groupMission function bingo(gpGid, groupMission)")


		if tabBingoPlane[gpGid] and not tabBingoPlane[gpGid][callSign] then												-- si le callSign a deja dit qu'il etait Bingo, on l'oublie		
			if Unit.getFuel(unit) <=  0.34 then																			-- Sur F14, 4000lbs/16000lbs = 0.25%
				trigger.action.outTextForGroup(gpGid, callSign .." Bingo Fuel", 15 , true)
				env.info( "DCE_Bingo AA Unit.getFuel(unit)  "..tostring(groupMission.id_).." gpName: "..tostring(gpName).." callSign: "..callSign.." humainUnit? "..tostring(humainUnit) )

				tabBingoPlane[gpGid][callSign] = true																	-- la callSign � d�ja indiqu� qu'il �tait Bingo


				local report = " not humainUnit "
				local cntrl = unit:getController()

				report = report.." RTB_ON_BINGO & PROHIBIT_AB "

				local unitName =  unit:getName()

				env.info( "DCE_Bingo CC      report "..tostring(groupMission.id_).." "..tostring(unitName).." "..callSign.." report "..tostring(report) )

				local description = unit:getDesc()
				_affiche(description, "description function bingo()")

				local breaktab = false
				local rtbGroup = {
					name = "",
					from = 0,
					to = 0
				}

				for _coalition, coalition in pairs(env.mission.coalition) do

					for Ncountry, _country in pairs(coalition.country) do
						if _country.plane then
							for Ngroup, _group in pairs(_country.plane.group) do
								if _group.groupId and _group.groupId == groupMission.id_ then

									rtbGroup.name = _group.name

									--Split
									for key, value in ipairs(_group.route.points) do
										if value.name == 'Split' then
											rtbGroup.to = key
											rtbGroup.from = key - 1
										end
									end

									if rtbGroup.to == 0 then
										for key, value in ipairs(_group.route.points) do
											if value.type == 'Land' then
												rtbGroup.to = key
												rtbGroup.from = key - 1
											end
										end
									end

									breaktab = true
									break
								end
							end
						end
						if breaktab then break end
					end

					if breaktab then break end
				end

				env.info( "DCE_Bingo DD        rtbGroup from "..tostring( rtbGroup.from).." to "..tostring( rtbGroup.to))

				if rtbGroup.to ~= 0 then
					local switchtask = {
							id = "SwitchWaypoint",
								params = {
									goToWaypointIndex = rtbGroup.to,
									fromWaypointIndex = rtbGroup.from
							}
						}


					cntrl:resetTask()

					cntrl:setCommand(switchtask)

					cntrl:setOption(AI.Option.Air.id.REACTION_ON_THREAT, 2)
					cntrl:setOption(AI.Option.Air.id.PROHIBIT_AA, true) -- Désactiver l'engagement A/A
					cntrl:setOption(AI.Option.Air.id.PROHIBIT_JETT, false)
					cntrl:setOption(AI.Option.Air.id.PROHIBIT_AB, true)
					cntrl:setOption(AI.Option.Air.id.JETT_TANKS_IF_EMPTY, true)

					env.info( "DCE_Bingo EE        goToWaypointIndex "..tostring(unitName).." "..callSign.." goToWaypointIndex "..tostring(rtbGroup.to) )
					_affiche(switchtask, "switchtask function bingo()")
				end
			end
		end

		if tabJockerPlane[gpGid] and not tabJockerPlane[gpGid][callSign] then												-- si le callSign a deja dit qu'il etait Bingo, on l'oublie
			if Unit.getFuel(unit) <=  0.33 then																			-- Sur F14, 4000lbs/16000lbs = 0.25%
				trigger.action.outTextForGroup(gpGid, callSign .." Jocker Fuel", 15 , true)
				env.info( " Unit.getFuel(unit)  "..callSign.." humainUnit? "..tostring(humainUnit) )
				tabJockerPlane[gpGid][callSign] = true																	-- la callSign � d�ja indiqu� qu'il �tait Bingo			
			end
		end
	end

end


LLtool = {}

LLtool.LLstrings = function(pos) -- pos is a Vec3

	local LLposN, LLposE = coord.LOtoLL(pos)
	local LLposfixN, LLposdegN = math.modf(LLposN)
	LLposdegN = LLposdegN * 60
	local LLposdegN2, LLposdegN3 = math.modf(LLposdegN)
	LLposdegN3 = LLposdegN3 * 1000

	local LLposfixE, LLposdegE = math.modf(LLposE)
	LLposdegE = LLposdegE * 60
	local LLposdegE2, LLposdegE3 = math.modf(LLposdegE)
	LLposdegE3 = LLposdegE3 * 1000

	local LLposNstring = string.format('%+.2i %.2i %.3d', LLposfixN, LLposdegN2, LLposdegN3)
	local LLposEstring = string.format('%+.3i %.2i %.3d', LLposfixE, LLposdegE2, LLposdegE3)

	return LLposNstring, LLposEstring
end


	--************* AFAC PART ****************************************
function AFAC_com(arg)
	local AFAC_Name = arg[1]
	local gpGid = arg[2]
	local radioOn = arg[3]

	if radioOn == true then
		AFAC_available[AFAC_Name]["gpGid"] = gpGid
		trigger.action.outTextForGroup(gpGid,"AFAC radio On, waiting ...", 15, false)
		_affiche(AFAC_available, "AFAC_available radioOn")
	elseif radioOn == false then
		if AFAC_available[AFAC_Name]["gpGid"] and AFAC_available[AFAC_Name]["gpGid"] == gpGid  then
			AFAC_available[AFAC_Name]["gpGid"] = nil
		end
		trigger.action.outTextForGroup(gpGid,"AFAC radio Off", 15, false)
		_affiche(AFAC_available, "AFAC_available radioOff")
	end


end

function AFAC_F10(playerGroup)

	local gpGid = playerGroup:getID()
	local menuAFAC
	missionCommands.removeItemForGroup(gpGid, {"AFAC"})

	-- AFAC_available[FlightName] = nil
	if AFAC_available then
		for AFAC_Name, AFAC in pairs(AFAC_available) do
			if AFAC_Name and type(AFAC_Name) == "string" then
				menuAFAC = missionCommands.addSubMenuForGroup(gpGid, "AFAC")
				break
			end
		end


		for AFAC_Name, AFAC in pairs(AFAC_available) do
			if AFAC_Name and type(AFAC_Name) == "string" then
				missionCommands.addCommandForGroup(gpGid, "AFAC radio On ", menuAFAC, AFAC_com, {AFAC_Name, gpGid, true}  )
				missionCommands.addCommandForGroup(gpGid, "AFAC radio Off ", menuAFAC, AFAC_com, {AFAC_Name, gpGid, false}  )

				--table missionCommands.addCommandForGroup(number groupId , string name , table/nil path , function functionToRun , any anyArguement)
				--      missionCommands.addCommandForGroup(gpGid, txt, ejctedPilRadioON, activateRadioBeacon, {gpGid, ejectPil}  )
			end
		end

	end


end

local function activateRadioBeacon(arguments)

	local gpGid = arguments[1]
	local ejectedPilot = arguments[2]

	local pilEjectObj = Unit.getByName(ejectedPilot.name)

	if pilEjectObj and camp.EjectedPilotFrequency and camp.EjectedPilotFrequency[ejectedPilot.side] then

		env.info( "AddCRF10:activateRadioBeacon  pilEjectObj:isExist "..tostring(pilEjectObj:isExist()))

		if not ejectedPilot.embarked  and pilEjectObj:isExist()  then
			local pilEjectPos = pilEjectObj:getPoint()

			env.info( "AddCRF10:activateRadioBeacon  pilEjectPos.y "..tostring(pilEjectPos.y))

			trigger.action.radioTransmission('l10n/DEFAULT/beacon.ogg', ejectedPilot.position, 0, true, camp.EjectedPilotFrequency[ejectedPilot.side].radioBeacon, 1, 'radioBeacon_'..ejectedPilot.name)

			local freqShow = camp.EjectedPilotFrequency[ejectedPilot.side].radioBeacon / 1000000
			trigger.action.outTextForGroup(gpGid, "activate RadioBeacon on : "..freqShow, 45 , true)
		end
	else
		trigger.action.outTextForGroup(gpGid, "Error, no frequency  ", 15 , true)
		env.info( "Error, no frequency  ")
	end
end



	--************* SAR ejectedPilot PART ****************************************
local function sar_F10(arg)
	local gpGid = arg[1]
	local playerGroup = arg[2]
	-- local gpGid = playerGroup:getID()

	if not Group.isExist(playerGroup) then
		return
	end

	local playerUnits = playerGroup:getUnits()
	local playerUnit = playerUnits[1]
	local playerPos = playerUnit:getPoint()

	local playerCoal = playerUnit:getCoalition()

	local listEjectPil = {}

	missionCommands.removeItemForGroup(gpGid, {"SAR"})
	missionCommands.removeItemForGroup(gpGid, {"Activate beacon radios", "SAR"})
	missionCommands.removeItemForGroup(gpGid, {"Turns off beacon radios", "SAR"})

	missionCommands.addSubMenuForGroup(gpGid, "SAR")

	local ejctedPilRadioON = missionCommands.addSubMenuForGroup(gpGid, "Activate beacon radios", {"SAR"})
	local ejctedPilRadioOFF = missionCommands.addSubMenuForGroup(gpGid, "Turns off beacon radios", {"SAR"})

	if camp.SAR and camp.SAR.pilotEjected then

		for pilotN, ejectPilot in ipairs(camp.SAR.pilotEjected) do

			local pilEjectObj = Unit.getByName(ejectPilot.name)

			if not ejectPilot.embarked and ejectPilot.side == coalitionIdNumeric[playerCoal] and pilEjectObj and pilEjectObj:isExist()  then
				local pilEjectPos = pilEjectObj:getPoint()
				local distance = math.floor(math.sqrt(math.pow(pilEjectPos.x - playerPos.x, 2) + math.pow(pilEjectPos.z - playerPos.z, 2)))
				distance = math.ceil(distance / 1000)

				local tabTemp = {
					name = ejectPilot.name,
					distance = distance,
					position = pilEjectPos,
					MGRS_Chute_10KM = ejectPilot.MGRS_Chute_10KM,
					side = ejectPilot.side,
				}
				table.insert(listEjectPil, tabTemp)

			end
		end
	end

	if listEjectPil and #listEjectPil >=1 then
		table.sort(listEjectPil, function(a,b) return a.distance > b.distance  end)

		for n , ejectPil in ipairs(listEjectPil) do

			local txt = "..."
			if ejectPil.MGRS_Chute_10KM then
				txt = ejectPil.distance.." Km. "..ejectPil.MGRS_Chute_10KM.." "..txt
			else
				txt = ejectPil.distance.." Km. Activates radio beacon "..ejectPil.name
			end

			-- missionCommands.addCommandForGroup(gpGid, txt, {"Activate beacon radios"}, activateRadioBeacon, {gpGid, ejectPil}  )

			missionCommands.addCommandForGroup(gpGid, txt, ejctedPilRadioON, activateRadioBeacon, {gpGid, ejectPil}  )

		end
	end

	--TODO, A REMETTRE
	-- return timer.getTime() + 1
end





function BullsEye(PlayerGroup)

	-- ['coalition'] = {
			-- ['blue'] = {
				-- ['bullseye'] = {
					-- ['y'] = 635639.37385346,
					-- ['x'] = -317948.32727306,
				-- },
	local gpGid = PlayerGroup:getID()
	local PlayerUnits = PlayerGroup:getUnits()
	local PlayerUnit = PlayerUnits[1]

	local Coalition = PlayerUnit:getCoalition()

	local sideT = {
		[0] = "neutral",
		[1] = "red",
		[2] = "blue"
		}

	local bullsEye_pos = {
			x = env.mission.coalition[sideT[Coalition]].bullseye.x,
			y = 0,
			z = env.mission.coalition[sideT[Coalition]].bullseye.y
		}

	LLposNstring, LLposEstring = LLtool.LLstrings(bullsEye_pos)

	trigger.action.outTextForGroup(gpGid, "BullsEye: "..'N ' .. LLposNstring .. '   E ' .. LLposEstring, 45 , true)

end

function FctRtbGroup(rtbGroup)

	trigger.action.outText("RTB "..tostring(rtbGroup.name), 5)	--FOR DEBUG

	local gp = Group.getByName(rtbGroup.name)

	local rtbCtr = Group.getController(gp)


	local switchtask = {
			id = "SwitchWaypoint",
				params = {
					goToWaypointIndex = rtbGroup.to,
					fromWaypointIndex = rtbGroup.from
			}
		}

	rtbCtr:resetTask()
	rtbCtr:setCommand(switchtask)

end



function RtbPack(PlayerGroup)

	for _coalition, coalition in pairs(env.mission.coalition) do
		if _coalition == camp.player.side then
			for Ncountry, _country in pairs(coalition.country) do
				if _country.plane then
					for Ngroup, _group in pairs(_country.plane.group) do
						if string.find(_group.name,"Pack "..camp.player.pack_n) then

							local rtbGroup = {
									name = "",
									from = 0,
									to = 0
								}


							rtbGroup.name = _group.name

							if string.find(_group.name,"Escort") then
								local function Execute()
									local wingman = _group:getUnits()								--get list of units from attacking flights
									for n = 1, #wingman do											--iterate through wingmen in flight
										local cntrl = wingman[n]:getController()					--get controller of individual aircraft in flight
										cntrl:resetTask()											--reset task (wingman will rejoin with leader)
									end
								end
								timer.scheduleFunction(Execute, nil, timer.getTime() + 1)
							end

							for key, value in ipairs(_group.route.points) do
								if value.type == 'Land' then
									rtbGroup.to = key
									rtbGroup.from = key - 1
								end

							end

							if rtbGroup.name and rtbGroup.to ~= 0 then
								FctRtbGroup(rtbGroup)
							end

						end
					end
				end
			end
		end
	end
end


function RtbStrikePack(PlayerGroup)

	for _coalition, coalition in pairs(env.mission.coalition) do
		if _coalition == camp.player.side then
			for Ncountry, _country in pairs(coalition.country) do
				if _country.plane then
					for Ngroup, _group in pairs(_country.plane.group) do
						if string.find(_group.name,"Pack "..camp.player.pack_n) then

							local rtbGroup = {
									name = "",
									from = 0,
									to = 0
								}


							rtbGroup.name = _group.name

							if string.find(_group.name,"Strike") then

								for key, value in ipairs(_group.route.points) do
									if value.type == 'Land' then
										rtbGroup.to = key
										rtbGroup.from = key -1
									end

								end

								if rtbGroup.name and rtbGroup.to ~= 0 then
									FctRtbGroup(rtbGroup)
								end

							end
						end
					end
				end
			end
		end
	end
end


function RtbSEADPack(PlayerGroup)

	for _coalition, coalition in pairs(env.mission.coalition) do
		if _coalition == camp.player.side then
			for Ncountry, _country in pairs(coalition.country) do
				if _country.plane then
					for Ngroup, _group in pairs(_country.plane.group) do
						if string.find(_group.name,"Pack "..camp.player.pack_n) then

							local rtbGroup = {
									name = "",
									from = 0,
									to = 0
								}


							rtbGroup.name = _group.name

							if string.find(_group.name,"SEAD") then

								for key, value in ipairs(_group.route.points) do
									if value.type == 'Land' then
										rtbGroup.to = key
										rtbGroup.from = key -1
									end

								end

								if rtbGroup.name and rtbGroup.to ~= 0 then
									FctRtbGroup(rtbGroup)
								end

							end
						end
					end
				end
			end
		end
	end
end

function EWR_ON(playerName)
	if not EWR_optionPlayer[playerName] then
		EWR_optionPlayer[playerName] = {
			EWR_on = true,
		}
	else
		EWR_optionPlayer[playerName].EWR_on = true
	end
end

function EWR_OFF(playerName)
	if not EWR_optionPlayer[playerName] then
		EWR_optionPlayer[playerName] = {
			EWR_on = false,
		}
	else
		EWR_optionPlayer[playerName].EWR_on = false
	end
end

function ReFueling(PlayerGroup)

	local player = {
		["point"] = {}
	}

	local tanker = {
		["point"] = {},
		["name"] = "",
		["distance"] = 0,
		["gpName"] = ""
	}

	local PlayerUnits = PlayerGroup:getUnits()
	local PlayerUnit = PlayerUnits[1]
	local uid = PlayerUnit:getID()

	-- fichier miz:
		-- plan haut, droite, alti : x/y/z
	-- vue F10 et vector3d:
		-- plan haut, droite, alti : x/z/y

	local PtempPoint = PlayerUnit:getPoint()
			player.point.x = PtempPoint.x
			player.point.y = PtempPoint.z
			player.point.z = PtempPoint.y
	local Coalition = PlayerUnit:getCoalition()
	local groups = coalition.getGroups(Coalition, Group.Category.AIRPLANE)
	local speed = PlayerUnit:getVelocity()
	player.speed = math.sqrt(speed.x^2 + speed.y^2 + speed.z^2)
	-- local groups = coalition.getGroups(coalition.side.BLUE, Group.Category.AIRPLANE)
	local selected_distance = 99999999

	for i, gp in pairs(groups) do
		local gpName = Group.getName(gp)
		if   string.find(gpName,"Refueling") then
			local units = gp:getUnits()
			local _unit = units[1]
			local fuel = _unit:getFuel()
			local callsign = _unit:getCallsign()
			local TankerTypeName = _unit:getTypeName()
			local t = {
						["point"] = {}
						}

			local TtempPoint = _unit:getPoint()
					t.point.x = TtempPoint.x
					t.point.y = TtempPoint.z
					t.point.z = TtempPoint.y

			local description = _unit:getDesc()

			if (description.attributes.Refuelable or description.attributes.Tankers ) and _unit:isActive() then
			-- if _unit:getTypeName() == "S-3B Tanker" and _unit:isActive() then			
			-- if _unit:getTypeName() == "S-3B Tanker"  and t.point.z > 100 and _unit:isActive() then			

				local Tdistance = math.sqrt(math.pow(t.point.x - player.point.x, 2) + math.pow(t.point.y - player.point.y, 2))		--distance between tanker and player
				if Tdistance < selected_distance then
					tanker.point = t.point
					tanker.TypeName = TankerTypeName
					tanker.distance = Tdistance
					tanker.gpName = tostring(gpName)
					tanker.ctr = Group.getController(gp)
					tanker.callsign = callsign
					tanker._unit = _unit
					tanker.Desc = _unit:getDesc()
					selected_distance =  Tdistance
				end
			end
		end
	end

	local heading  = GetHeading(tanker.point, player.point)		--return heading between two vector2 points
	local dist = tanker.distance / 2
	local interception_pos = GetOffsetPoint(tanker.point, heading, dist)		--function to return a new point offset from an initial point
	local interception_alt = player.point.z
	local pattern_alt = player.point.z
	local pattern_speed = player.speed

	if interception_alt < 1000 and dist > 50000 then
		interception_alt = 3000
	elseif interception_alt > 6100  then										-- alti max:6100
		interception_alt = 6100
		pattern_alt = 6100
	end

	if pattern_speed < 130  then
		pattern_speed = 130
	elseif pattern_speed > 200  then											-- vi max:6100
		pattern_speed = 200
	end

	local infoSpeed = math.floor(pattern_speed / 0.51444444444)					-- m/s to Kts
	local infoAlti = math.floor((pattern_alt * 3.2808398950131 )/100)*100		-- m to ft	
	local intercept_pos = {
					x = interception_pos.x,
					y = pattern_alt,
					z = interception_pos.y
					}

	local intercept_LL =  coord.LOtoLL(intercept_pos)

	LLposNstring, LLposEstring = LLtool.LLstrings(intercept_pos)
	trigger.action.outText(tanker.callsign.." "..tanker.gpName.." Rdv: "..'N ' .. LLposNstring .. '   E ' .. LLposEstring.." Alt: "..infoAlti.." Speed "..infoSpeed, 20)

		local Mission = {														--define mission for interceptor group
			id = 'Mission',
			params = {
				route = {
					["points"] = {
						[1] = {
							["alt"] = interception_alt,
							["type"] = "Turning Point",
							["action"] = "Turning Point",
							["alt_type"] = "BARO",
							["formation_template"] = "",
							["y"] = interception_pos.y ,
							["x"] = interception_pos.x ,
							["speed"] = 200,
							["ETA_locked"] = false,
							["task"] = {
								["id"] = "ComboTask",
								["params"] =
								{
									["tasks"] =
									{

										[1] =
										{
											["number"] = 1,
											["auto"] = false,
											["id"] = "Tanker",
											["enabled"] = true,
											["params"] =
											{
											}, -- end of ["params"]
										}, -- end of [1]
										[2] =
										{
											["number"] = 2,
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
														["altitude"] = pattern_alt,
														["pattern"] = "Circle",
														["speed"] = pattern_speed,
														["speedEdited"] = true,
													}, -- end of ["params"]
												}, -- end of ["task"]
												["stopCondition"] =
												{
													["duration"] = 600,
												}, -- end of ["stopCondition"]
											}, -- end of ["params"]
										}, -- end of [2]
									}, -- end of ["tasks"]
								}, -- end of ["params"]
							},
							["speed_locked"] = true,
						},
						[2] = {
							["alt"] = tanker.point.z,
							["type"] = "Turning Point",
							["action"] = "Turning Point",
							["alt_type"] = "BARO",
							["formation_template"] = "",
							-- ["ETA"] = 0,
							["y"] = tanker.point.y,
							["x"] = tanker.point.x,
							["speed"] = 180,
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

		Controller.setTask(tanker.ctr, Mission)																			--activate task with mission for interceptor group							
end

function RequestCAP(PlayerGroup)
	-- modification M36	Help CAP 
	local player = {
		["point"] = {}
	}

	local CAP = {
		["point"] = {},
		["name"] = "",
		["distance"] = 0,
		["gpName"] = ""
	}

	local PlayerUnits = PlayerGroup:getUnits()
	local PlayerUnit = PlayerUnits[1]
	local uid = PlayerUnit:getID()

	-- fichier miz:
		-- plan haut, droite, alti : x/y/z
	-- vue F10 et vector3d:
		-- plan haut, droite, alti : x/z/y

	local PtempPoint = PlayerUnit:getPoint()
			player.point.x = PtempPoint.x
			player.point.y = PtempPoint.z
			player.point.z = PtempPoint.y

	local Coalition = PlayerUnit:getCoalition()
	local groups = coalition.getGroups(Coalition, Group.Category.AIRPLANE)
	local speed = PlayerUnit:getVelocity()
	player.speed = math.sqrt(speed.x^2 + speed.y^2 + speed.z^2)

	-- local groups = coalition.getGroups(coalition.side.BLUE, Group.Category.AIRPLANE)
	local selected_distance = 99999999

	for i, gp in pairs(groups) do

		local gpName = Group.getName(gp)

		if   string.find(gpName,"CAP") then
			local units = gp:getUnits()
			local _unit = units[1]
			local fuel = _unit:getFuel()
			local callsign = _unit:getCallsign()
			local TankerTypeName = _unit:getTypeName()
			local t = {
						["point"] = {}
						}

			local TtempPoint = _unit:getPoint()
					t.point.x = TtempPoint.x
					t.point.y = TtempPoint.z
					t.point.z = TtempPoint.y

			if  _unit:isActive() then
			-- if _unit:getTypeName() == "S-3B Tanker"  and t.point.z > 100 and _unit:isActive() then			

				local Tdistance = math.sqrt(math.pow(t.point.x - player.point.x, 2) + math.pow(t.point.y - player.point.y, 2))		--distance between tanker and player

				if Tdistance < selected_distance then

					CAP.point = t.point
					CAP.TypeName = TankerTypeName
					CAP.distance = Tdistance
					CAP.gpName = tostring(gpName)
					CAP.ctr = Group.getController(gp)
					CAP.callsign = callsign
					CAP._unit = _unit
					CAP.Desc = _unit:getDesc()
					selected_distance =  Tdistance

				end
			end
		end
	end
	--[[	
		local  gpGid = Group.getID(gp)
		
		for _coalition, coalition in pairs(env.mission.coalition) do
			if _coalition == camp.player.side then
				for Ncountry, _country in pairs(coalition.country) do	
					if _country.plane then
						for Ngroup, _group in pairs(_country.plane.group) do
							if _group.groupId == gpGid then 				
								
								frequencyCAP = _group.frequency	
									
							end
						end
					end
				end
			end
		end
	]]

	--[[
	export in low tick interval to Ikarus
	Example from A-10C
	Get Radio Frequencies
	get data from device
	local lUHFRadio = GetDevice(54)
	ExportScript.Tools.SendData("ExportID", "Format")
	ExportScript.Tools.SendData(2000, string.format("%7.3f", lUHFRadio:get frequency()/1000000)) <- special function for get frequency data
	]]


	local heading  = GetHeading(CAP.point, player.point)					--return heading between two vector2 points
	local dist = CAP.distance / 1.5											-- approche le CAP 

	CAP.velocity = CAP._unit:getVelocity()
	CAP.speed = math.sqrt(CAP.velocity.x^2 + CAP.velocity.y^2 + CAP.velocity.z^2)

	local interception_pos = GetOffsetPoint(CAP.point, heading, dist)		--function to return a new point offset from an initial point

	local interception_alt = player.point.z
	local pattern_speed 													-- ex = player.speed

	if interception_alt < 3000 and dist > 50000 then
		interception_alt = 7600
	elseif interception_alt > 6100  then										-- alti max:6100
		interception_alt = 7600
	end

	trigger.action.outText(CAP.callsign.." "..CAP.gpName, 20)


		local Mission = {														--define mission for interceptor group
			id = 'Mission',
			params = {
				route = {
					["points"] = {

						[1] = {
							['alt'] = interception_alt,
							['briefing_name'] = 'Station',
							['action'] = 'Turning Point',
							['alt_type'] = 'BARO',
							-- ['properties'] = {
							-- 	['vnav'] = 1,
							-- 	['scale'] = 0,
							-- 	['angle'] = 0,
							-- 	['vangle'] = 0,
							-- 	['steer'] = 2,
							-- },
							['speed_locked'] = true,
							['speed'] = 290,									-- vitesse du son  295 a 20000m
							['ETA'] = 1,
							["y"] = interception_pos.y ,
							["x"] = interception_pos.x ,
							['formation_template'] = '',
							['name'] = 'Station',
							['ETA_locked'] = false,
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
													['id'] = 'EngageTargetsInZone',
													['params'] = {
														['targetTypes'] = {
															[1] = 'Air',
															[2] = 'Cruise missiles',
														},
														['x'] = player.point.x,
														['value'] = 'Air;Cruise missiles;',
														['priority'] = 0,
														['y'] = player.point.y,
														['zoneRadius'] = 111000,
													},
												},
												['stopCondition'] = {
													['lastWaypoint'] = 3,
												},
											},
										},
										[2] = {
											['enabled'] = true,
											['auto'] = false,
											['id'] = 'ControlledTask',
											['number'] = 2,
											['params'] = {
												['task'] = {
													['id'] = 'Orbit',
													['params'] = {
														['altitude'] = CAP.point.z,
														['pattern'] = 'Race-Track',
														['speed'] = CAP.speed,
													},
												},
												['stopCondition'] = {
													['time'] = 1000,
												},
											},
										},
									},
								},
							},
							['type'] = 'Turning Point',
						},
					},
				}
			}
		}--local Mission = {	


		Controller.setTask(CAP.ctr, Mission)																			--activate task with mission for interceptor group

		trigger.action.outText("ADD_CR "..CAP.callsign.." "..CAP.gpName, 60)
end


function getOut(arg)
	env.info( "DCE_getOut A function getOut(gid) ")

	local groupObj = arg[1]
	local pName = arg[2]

	local wingman = groupObj:getUnits()
	local playerName
	local playerObj
	local playerId

	for w = 1, #wingman do
		playerName = wingman[w]:getPlayerName()

		if playerName == pName then
			playerObj = wingman[w]
			playerId = Unit.getID(playerObj)

			env.info( "DCE_getOut B Attempted emergency evacuation of the aircraft ")
			trigger.action.outTextForUnit(playerId, "Attempted emergency evacuation of the aircraft ", 15)
			
			GetOutGDFM({pName, playerObj, playerId})
		end
	end
end

local function getLL_TargetPosition()
	-- trigger.action.outText("DCE_getLL_TargetPosition Init ", 15)
	-- [357797] = 
	-- {
	-- 	[1] = 
	-- 	{
	-- 		["x"] = -357797,
	-- 		["y"] = 615132,
	-- 	},
	-- 	[2] = 
	-- 	{
	-- 		["x"] = 357797,
	-- 		["y"] = 665544,
	-- 	},

	if camp.targetPos then
		-- trigger.action.outText("DCE_getLL_TargetPosition START ", 15)
		for key_x, searchPos_s in pairs(camp.targetPos) do
			for posN, searchPos in pairs(searchPos_s) do
				if searchPos.x and searchPos.y then
					local posXZ = {
						x = searchPos.x,
						y = math.ceil(land.getHeight(searchPos)),
						z = searchPos.y,
					}

					local LLposN, LLposE = coord.LOtoLL(posXZ)
					searchPos.lat = LLposN
					searchPos.lon = LLposE
					searchPos.elevation = posXZ.y
				end
			end
		end
	end

	local logStr = "LL_KnownPositions = " .. TableSerialization(camp.targetPos, 0)
	local logFile = io.open(PathDCE.."Init\\".."LL_KnownPositionsTable.lua", "w")
	if logFile then
		logFile:write(logStr)
		logFile:close()
	else
		env.info("DCE_LL_KnownPositions: Failed to open log file for writing.")
	end

	-- trigger.action.outText("DCE_getLL_TargetPosition End ", 15)

	-- if camp.targetPos then
	-- 	for campName, targets in pairs(camp.targetPos) do
	-- 		for targetName, target in pairs(targets) do
	-- 			if target.x and target.y then
	-- 				local posXZ = {
	-- 					x = target.x,
	-- 					y = land.getHeight(target),
	-- 					z = target.y,
	-- 				}

	-- 				local LLposN, LLposE = coord.LOtoLL(posXZ)
	-- 				target.lat = LLposN
	-- 				target.lon = LLposE
	-- 				target.elevation = posXZ.y

	-- 				if target.elements then
	-- 					for i, element in pairs(target.elements) do
	-- 						if element.x and element.x ~= 0 and element.y and element.y ~= 0 then

	-- 							local elementPosXZ = {
	-- 								x = target.x,
	-- 								y = land.getHeight(element),
	-- 								z = target.y,
	-- 							}

	-- 							local LLposN, LLposE = coord.LOtoLL(elementPosXZ)
	-- 							element.lat = LLposN
	-- 							element.lon = LLposE
	-- 							element.elevation = elementPosXZ.y

	-- 						end
	-- 					end
	-- 				end

	-- 			end
	-- 		end
	-- 	end
	-- end

	-- if camp.debug then
	-- 	--export custom mission log
	-- 	local logStr = "targetPos = " .. TableSerialization(camp.targetPos, 0)
	-- 	local logFile = io.open(PathDCE.."Debug\\".."targetPos"..".lua", "w")
	-- 	logFile:write(logStr)
	-- 	logFile:close()
	-- end


end

--dans le cas de la creation de campagne, ceci permet de recuperer les positions GPS lat lon de toutes les unités, afin d'afficher ces position des la premiere mission
if camp.makeCampaign then

	-- local LL_KnownPositionsTable = {}

	-- -- Lire le fichier oobground.lua et charger la table
	-- local fileName = PathDCE.."Active\\".."oob_ground.lua"

	-- local oob_ground = assert(loadfile(fileName)) -- Charge le fichier

	-- for sideName, country in pairs(oob_ground) do																				
	-- 	for typeName, typeTable in pairs(country) do						
	-- 		if typeName == "vehicle" or typeName == "ship" or typeName == "static" then			
	-- 			for groupN, group in pairs(typeTable.group) do

	-- 				if group.x and group.y then
	-- 					local addItem = true
	-- 					local elevation = math.ceil(land.getHeight(group)) 
	-- 					local posXZ = {
	-- 						x = group.x,
	-- 						y = elevation,
	-- 						z = group.y,
	-- 					}

	-- 					local LLposN, LLposE = coord.LOtoLL(posXZ)
	-- 					LLposN = math.floor(LLposN)
	-- 					LLposE = math.floor(LLposE)

	-- 					local xKey = math.abs(group.x)

	-- 					if not LL_KnownPositionsTable[xKey] then 
	-- 						LL_KnownPositionsTable[xKey] = {} 
	-- 						addItem = true
	-- 					else
	-- 						for n, llPos in pairs(LL_KnownPositionsTable[xKey]) do
	-- 							if LLposN == llPos.lat and LLposE == llPos.lon then
	-- 								addItem = false
	-- 								break
	-- 							end 
	-- 						end
	-- 					end

	-- 					if addItem == true then
	-- 						local posLL = {
	-- 							lat = LLposE,
	-- 							lon = LLposE,
	-- 							elevation = elevation,
	-- 						}
	-- 						table.insert(LL_KnownPositionsTable[xKey], posLL)
	-- 					end

	-- 					for unitN, unit in pairs(group.units) do			
	-- 						if unit.x and unit.y then					
	-- 							local addItem = true
	-- 							local elevation = math.ceil(land.getHeight(unit)) 
	-- 							local posXZ = {
	-- 								x = unit.x,
	-- 								y = elevation,
	-- 								z = unit.y,
	-- 							}

	-- 							local LLposN, LLposE = coord.LOtoLL(posXZ)
	-- 							LLposN = math.floor(LLposN)
	-- 							LLposE = math.floor(LLposE)

	-- 							local xKey = math.abs(unit.x)

	-- 							if not LL_KnownPositionsTable[xKey] then 
	-- 								LL_KnownPositionsTable[xKey] = {} 
	-- 								addItem = true
	-- 							else
	-- 								for n, llPos in pairs(LL_KnownPositionsTable[xKey]) do
	-- 									if LLposN == llPos.lat and LLposE == llPos.lon then
	-- 										addItem = false
	-- 										break
	-- 									end 
	-- 								end
	-- 							end

	-- 							if addItem == true then
	-- 								local posLL = {
	-- 									lat = LLposE,
	-- 									lon = LLposE,
	-- 									elevation = elevation,
	-- 								}
	-- 								table.insert(LL_KnownPositionsTable[xKey], posLL)
	-- 							end
	-- 						end
	-- 					end
	-- 				end
	-- 			end
	-- 		end
	-- 	end


	-- 	--***************************************************************************
	-- 	-- Lire le fichier targetlist pour ajouter les xy des elements de la map
	-- 	local fileName = PathDCE.."Active\\".."targetlist.lua"

	-- 	local targetList = assert(loadfile(fileName)) -- Charge le fichier

	-- 	for campName, targets in pairs(targetList) do
	-- 		for targetName, target in pairs(targets) do
	-- 			if target.x and target.y then
	-- 				local addItem = true
	-- 				local elevation = math.ceil(land.getHeight(target)) 
	-- 				local posXZ = {
	-- 					x = target.x,
	-- 					y = elevation,
	-- 					z = target.y,
	-- 				}

	-- 				local LLposN, LLposE = coord.LOtoLL(posXZ)
	-- 				LLposN = math.floor(LLposN)
	-- 				LLposE = math.floor(LLposE)

	-- 				local xKey = math.abs(math.floor(target.x))

	-- 				if not LL_KnownPositionsTable[xKey] then 
	-- 					LL_KnownPositionsTable[xKey] = {} 
	-- 					addItem = true
	-- 				else
	-- 					for n, llPos in pairs(LL_KnownPositionsTable[xKey]) do
	-- 						if LLposN == llPos.lat and LLposE == llPos.lon then
	-- 							addItem = false
	-- 							break
	-- 						end 
	-- 					end
	-- 				end

	-- 				if addItem == true then
	-- 					local posLL = {
	-- 						x = math.floor(target.x),
	-- 						y = math.floor(target.y),
	-- 						lat = LLposE,
	-- 						lon = LLposE,
	-- 						elevation = elevation,
	-- 					}
	-- 					table.insert(LL_KnownPositionsTable[xKey], posLL)
	-- 				end

	-- 				if target.elements then
	-- 					for i, element in pairs(target.elements) do
	-- 						if element.x and element.x ~= 0 and element.y and element.y ~= 0 then
	-- 							local addItem = true
	-- 							local elevation = math.ceil(land.getHeight(element)) 
	-- 							local elementPosXZ = {
	-- 								x = element.x,
	-- 								y = elevation,
	-- 								z = element.y,
	-- 							}

	-- 							local LLposN, LLposE = coord.LOtoLL(elementPosXZ)
	-- 							local xKey = math.abs(math.floor(element.x))

	-- 							if not LL_KnownPositionsTable[xKey] then 
	-- 								LL_KnownPositionsTable[xKey] = {} 
	-- 								addItem = true
	-- 							else
	-- 								for n, llPos in pairs(LL_KnownPositionsTable[xKey]) do
	-- 									if LLposN == llPos.lat and LLposE == llPos.lon then
	-- 										addItem = false
	-- 										break
	-- 									end 
	-- 								end
	-- 							end

	-- 							if addItem == true then
	-- 								local posLL = {
	-- 									x = math.floor(target.x),
	-- 									y = math.floor(target.y),
	-- 									lat = LLposE,
	-- 									lon = LLposE,
	-- 									elevation = elevation,
	-- 								}
	-- 								table.insert(LL_KnownPositionsTable[xKey], posLL)
	-- 							end

	-- 						end
	-- 					end
	-- 				end

	-- 			end
	-- 		end
	-- 	end

	-- end


	-- --export custom mission log
	-- local logStr = "LL_KnownPositions = " .. TableSerialization(LL_KnownPositionsTable, 0)
	-- local logFile = io.open(PathDCE.."Init\\".."LL_KnownPositionsTable.lua", "w")
	-- logFile:write(logStr)
	-- logFile:close()
end

local function addFuncs(gid, groupObject, playerName)

	env.info("DCE_addFuncs PASSE   _A gid "..tostring(gid).." Group "..tostring(Group))

	if gid and Group then

		env.info("DCE_addFuncs PASSE   _B  ")

		if not EWR_optionPlayer[playerName] then
			EWR_optionPlayer[playerName] = {
				EWR_on = false,
			}
		end

		-- -- supprime les anciens items de la commande F10
		-- missionCommands.removeItemForGroup(gid, {"Urgent_Refueling"})
		-- missionCommands.removeItemForGroup(gid, {"Urgent_RequestCAP"})
		-- missionCommands.removeItemForGroup(gid, {"BullsEye_LongLat"})	
		-- missionCommands.removeItemForGroup(gid, {"Package_All_RTB"})
		-- missionCommands.removeItemForGroup(gid, {"Package_Strike_RTB"})
		-- missionCommands.removeItemForGroup(gid, {"Package_SEAD_RTB"})		
		-- -- missionCommands.removeItemForGroup(gid, {"RemovePlane"})
		-- missionCommands.removeItemForGroup(gid, {"CarrierIntoWind"})		

		-- missionCommands.addCommandForGroup(gid, "Urgent_Refueling", nil, ReFueling, Group)
		-- missionCommands.addCommandForGroup(gid, "Urgent_RequestCAP", nil, RequestCAP, Group)
		-- missionCommands.addCommandForGroup(gid, "BullsEye_LongLat", nil, BullsEye, Group)
		-- missionCommands.addCommandForGroup(gid, "Package_All_RTB", nil, RtbPack, Group)
		-- missionCommands.addCommandForGroup(gid, "Package_Strike_RTB", nil, RtbStrikePack, Group)
		-- missionCommands.addCommandForGroup(gid, "Package_SEAD_RTB", nil, RtbSEADPack, Group)		
		-- -- missionCommands.addCommandForGroup(gid, "RemovePlane", nil, RemovePlane, Group)



		-- supprime les anciens items de la commande F10
		missionCommands.removeItemForGroup(gid, {"BullsEye_LongLat"})

		missionCommands.removeItemForGroup(gid, {"CarrierIntoWind"})
		missionCommands.removeItemForGroup(gid, {"Urgent request"})
		missionCommands.removeItemForGroup(gid, {"EWR"})
		missionCommands.removeItemForGroup(gid, {"Get out of the cockpit"})

		local subR_A = missionCommands.addSubMenuForGroup(gid, "Urgent request", nil)

		radioCommands[#radioCommands + 1] = missionCommands.addCommandForGroup(gid, "Urgent_Refueling", subR_A, ReFueling, groupObject )
		radioCommands[#radioCommands + 1] = missionCommands.addCommandForGroup(gid, "Urgent_RequestCAP", subR_A, RequestCAP, groupObject)
		radioCommands[#radioCommands + 1] = missionCommands.addCommandForGroup(gid, "Package_All_RTB", subR_A, RtbPack, groupObject)
		radioCommands[#radioCommands + 1] = missionCommands.addCommandForGroup(gid, "Package_Strike_RTB", subR_A, RtbStrikePack, groupObject)
		radioCommands[#radioCommands + 1] = missionCommands.addCommandForGroup(gid, "Package_SEAD_RTB", subR_A, RtbSEADPack, groupObject)


		radioCommands[#radioCommands + 1] = missionCommands.addCommandForGroup(gid, "BullsEye_LongLat", nil, BullsEye, groupObject)


		-- local subR = missionCommands.addSubMenu('Root SubMenu')
		-- local subN1 = missionCommands.addSubMenu('SubMenu within RootSubmenu', subR)
		-- local subN2 = missionCommands.addSubMenu('we must go deeper', subN1)
		-- local subN3 = missionCommands.addSubMenu('Go take a UX class', subN2)

		local subR_B1 = missionCommands.addSubMenuForGroup(gid, "EWR", nil)
		local subR_B2 = missionCommands.addSubMenuForGroup(gid, "EWR ON", subR_B1)
		local subR_B3 = missionCommands.addSubMenuForGroup(gid, "EWR OFF", subR_B1)

		for pName, value in pairs(EWR_optionPlayer) do
			radioCommands[#radioCommands + 1] = missionCommands.addCommandForGroup(gid, tostring(pName) .." EWR ON", subR_B2, EWR_ON, pName )
		end

		for pName, value in pairs(EWR_optionPlayer) do
			radioCommands[#radioCommands + 1] = missionCommands.addCommandForGroup(gid, tostring(pName) .." EWR OFF", subR_B3, EWR_OFF, pName )
		end



		-- radioCommands[#radioCommands + 1] = missionCommands.addCommandForGroup(gid, "Get out of the cockpit", subR_A, getOut, gid)
		local subR_C1 = missionCommands.addSubMenuForGroup(gid, "Get out of the cockpit", subR_A)
		for pName, value in pairs(EWR_optionPlayer) do
			radioCommands[#radioCommands + 1] = missionCommands.addCommandForGroup(gid, tostring(pName) .." Get out", subR_C1, getOut, {groupObject ,pName} )
		end


		env.info("DCE_addFuncs PASSE   _C  ")

		if camp.SC_CarrierIntoWind == "man" then
			missionCommands.removeItemForGroup(gid, {"CarrierIntoWind"})
			local subR = missionCommands.addSubMenuForGroup(gid, "CarrierIntoWind", nil)
			for coalition_name,coal in pairs(env.mission.coalition) do
				for country_n,country in ipairs(coal.country) do
					if country.ship then
						for group_n,group in ipairs(country.ship.group) do
							local groupCarrier = Group.getByName(group.name)													--get carrier group
							if groupCarrier then																				--group exists
								local carrier = groupCarrier:getUnit(1)															--get group leader (assumed to be the carrier)								
								local Desc = carrier:getDesc()
								if Desc.attributes.AircraftCarrier or Desc.attributes["Aircraft Carriers"] then
									-- local carrierPos = carrier:getPoint()														--get position of carrier
									local groupName = group.name
									radioCommands[#radioCommands + 1] = missionCommands.addCommandForGroup(gid, group.name.." Into Wind 30mn", subR, TurnIntoWind, {groupName, nil, nil, 30} )	-- modification M36.d	(d: add timer) MenuRadio request manual TurnIntoWind
									radioCommands[#radioCommands + 1] = missionCommands.addCommandForGroup(gid, group.name.." Into Wind 60mn", subR, TurnIntoWind, {groupName, nil, nil, 60} )
									radioCommands[#radioCommands + 1] = missionCommands.addCommandForGroup(gid, group.name.." Resume Route", subR, ResumeRoute, {groupName, nil} )
								end
							end
						end
					end
				end
			end
		end

		-- sar_F10(Group)
		timer.scheduleFunction(sar_F10, {gid, groupObject}, timer.getTime() + 2)

		-- AFAC_F10(Group)
		timer.scheduleFunction(AFAC_F10, groupObject, timer.getTime() + 2)


		-- The solution is to use env.mission.coalition where you find all object informations even groupId
		-- https://forums.eagle.ru/showthread.php?t=147792&page=15

		 -- commandDB['RUR'] = missionCommands.addCommandForGroup(gid,"UrgentRefueling", nil, ReFueling, Group)
		 -- commandDB['speed'] = missionCommands.addCommandForGroup(gid,"Testing", nil, Test, Group)
		 -- commandDB['RTB'] = missionCommands.addCommandForGroup(gid,"Package_RTB", nil, RtbPack, Group)

		 if camp.debug then
			local TimeSearchEngage = timer.getTime()
			local logStr = "radioCommands = " .. TableSerialization(radioCommands, 0)
			local FlightNameClean = "radioCommands"
			local logFile = io.open(PathDCE.."Debug\\"..FlightNameClean.."_"..TimeSearchEngage.."_".. "_radioCommands.lua", "w")
			if logFile then
				logFile:write(logStr)
				logFile:close()
			else
				env.info("DCE_addFuncs: Failed to open log file for writing.")
			end
		 end

		 env.info("DCE_addFuncs PASSE   _D  ")

	end
end

--////////////////////////////////////////////////////////////////////////////////////////////
--test BULLE
--////////////////////////////////////////////////////////////////////////////////////////////


--////////////////////////////////////////////////////////////////////////////////////////////

-- coalition.getGroups(Coalition, Group.Category.AIRPLANE)
-- _group.category = Group.Category.GROUND;

	-- --recupere les dynamique
	-- local GroundGroups = coalition.getGroups(coalitionIdNumericENI[Coalition], Group.Category.GROUND)

	-- 	--recupere les static
	-- 	local statics = coalition.getStaticObjects(coalitionIdNumericENI[Coalition])

--////////////////////////////////////////////////////////////////////////////////////////////


-- Liste des groupes au sol et leurs états d'origine
local groundGroups = {}

-- Collecte des groupes dynamiques au sol
local function collectGroundGroups()
    groundGroups = {}
    local totalGroups = 0
    local validGroups = 0

    local function addGroupsFromCoalition(side)
        -- Récupère uniquement les groupes dynamiques au sol
        local allGroups = coalition.getGroups(side, Group.Category.GROUND)
        totalGroups = totalGroups + #allGroups

        for _, group in ipairs(allGroups) do
            if group and group:isExist() then
                env.info("Checking group: " .. group:getName())
                local groupName = group:getName()
                local units = group:getUnits()
                if #units > 0 then
                    groundGroups[groupName] = {
                        name = groupName,
                        invisible = false -- État actuel
                    }
                    validGroups = validGroups + 1
                    env.info("Added ground vehicle group: " .. groupName)
                else
                    env.info("Skipped group (no units): " .. groupName)
                end
            end
        end
    end

    -- Ajout des groupes des deux coalitions
    addGroupsFromCoalition(coalition.side.RED)  -- Groupes dynamiques côté RED
    addGroupsFromCoalition(coalition.side.BLUE) -- Groupes dynamiques côté BLUE

    env.info("Total groups found: " .. tostring(totalGroups))
    env.info("Ground vehicle groups collected: " .. tostring(validGroups))
end

-- Basculer la visibilité d'un groupe via SetInvisible
local function toggleGroupVisibility(groupData)
    local group = Group.getByName(groupData.name)
    if group and group:isExist() then
        local controller = group:getController()
        if controller then
            local SetInvisible = {
                id = 'SetInvisible',
                params = {
                    value = not groupData.invisible -- Basculer la visibilité
                }
            }
            controller:setCommand(SetInvisible)
            groupData.invisible = not groupData.invisible -- Mise à jour de l'état
            env.info("Toggled visibility for group: " .. groupData.name .. " to " .. tostring(groupData.invisible))
        else
            env.warning("No controller found for group: " .. groupData.name)
        end
    else
        env.info("Group does not exist anymore: " .. groupData.name)
    end
end

--************************************
-- -- Basculer l'état de visibilité des unités au sol
-- local function toggleGroundUnits()
--     env.info("Toggling ground units visibility...")
--     for _, groupData in pairs(groundGroups) do
--         toggleGroupVisibility(groupData)
--     end
-- end

-- -- Planification initiale et exécution toutes les 10 minutes
-- local function scheduleToggle()
--     toggleGroundUnits()
--     -- return timer.getTime() + 1200 -- 600 secondes = 10 minutes
-- end
--************************************


--************************************
-- -- Planification de la collecte initiale après 10 secondes
-- timer.scheduleFunction(function()
--     collectGroundGroups()
--     timer.scheduleFunction(scheduleToggle, nil, timer.getTime() + 10) -- Commence le cycle après 10 minutes
-- end, nil, timer.getTime() + 10)


-- collectGroundGroups()
-- timer.scheduleFunction(scheduleToggle, nil, timer.getTime() + 360) -- Commence le cycle après 10 minutes


--////////////////////////////////////////////////////////////////////////////////////////////
--test BULLE (fin)
--////////////////////////////////////////////////////////////////////////////////////////////


--////////////////////////////////////////////////////////////////////////////////////////////
--test EWR (start)
--recupere les data de tous les aéronefs
--////////////////////////////////////////////////////////////////////////////////////////////
local function EWR_speaking(arg)

	trigger.action.outTextForUnit(arg[1], arg[2], 30, false)
end


-- Fonction pour envoyer un texte transformé en audio via TTS
-- local function sendTTSMessage(freq, modulation, text)
local function sendTTSMessage(arg)

	local freq, modulation, text = arg[1], arg[2],arg[3]

	local duration = SRSAudio.transmitTTS( -- Utilise la fonction TTS de SRS
		freq,        -- Fréquence en Hz
		modulation,  -- "AM" ou "FM"
		text         -- Texte à convertir en audio
	)
	if duration then
		trigger.action.outText("DCE_sendTTSMessage : Message TTS diffusé sur " .. freq / 1000000 .. " MHz (durée: " .. duration .. " s)", 10)
	else
		trigger.action.outText("DCE_sendTTSMessage Erreur lors de la diffusion TTS. freq: "..tostring(freq), 10)
		trigger.action.outText("DCE_sendTTSMessage Erreur lors de la diffusion TTS. modulation: "..tostring(modulation), 10)
		trigger.action.outText("DCE_sendTTSMessage Erreur lors de la diffusion TTS. text: "..tostring(text), 10)
	end
end




local function EWR_magic()
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
							-- env.info("DCE_EventsTracker Object Category "..tostring(objCat).." _: "..tostring(Object_Category[objCat]))
						end


						if objCat and objCat == Object.Category.UNIT then

							-- local unitCat = Unit.getCategory(target) -- toujours cassé

							local desc = target:getDesc()
							local unitCat = desc.category

							-- env.info("DCE_EventsTracker Unit Category "..tostring(unitCat).." _: "..tostring(Unit_Category[unitCat]))


							if unitCat and (unitCat == Unit.Category.AIRPLANE or unitCat == Unit.Category.HELICOPTER) then

								if target:isActive() and target:inAir() then

									local target_unitId = target:getID()

									local target_point = target:getPoint()

									local target_pos = target:getPosition() -- Obtenir la position et l'orientation de la cible

									-- Heading (cap)
									local heading = math.atan2(target_pos.x.z, target_pos.x.x)
									heading = math.deg(heading) -- Conversion en degrés
									if heading < 0 then
										heading = heading + 360 -- Ajuster pour avoir un angle positif (0-360°)
									end
									-- Arrondi au multiple de 5 le plus proche
									heading = math.floor((heading + 2.5) / 5) * 5

									local target_coalition = target:getCoalition() -- Récupère la coalition de la cible

									local target_typeName = Object.getTypeName(target)

									target_tracks[ewr_side][target_unitId] = {
										point = target_point,
										category = unitCat,
										qte = 1,
										heading = heading,
										coalition = target_coalition,
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
				if getDistance3D(group.point, trackData.point) <= groupingDistance
					and math.abs(group.point.y - trackData.point.y) <= altitudeTolerance
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
					point = trackData.point,
					qte = 1, -- Initialement 1 avion
					typeName = trackData.typeName,
					position = trackData.position,
				})
			end
		end
	end

	-- Résultat
	-- env.info("Regroupement terminé. Nombre de groupes par coalition :")
	-- for coalitionName, groups in pairs(groupedTracks) do
	-- 	env.info(coalitionName .. ": " .. tostring(#groups) .. " groupes")
	-- end
	--##############################################################
	--################################################################


	-- if camp.debug then
	-- 	local current_time = timer.getTime()
	-- 	local logStr = "groupedTracks = " .. TableSerialization(groupedTracks, 0)
	-- 	local logFile = io.open(PathDCE.."Debug\\".. "_groupedTracks_"..current_time..".lua", "w")
	-- 	if logFile then
	-- 		logFile:write(logStr)
	-- 		logFile:close()
	-- 	else
	-- 		env.info("DCE_Custom_Altitude_: Failed to open log file for writing.")
	-- 	end
	-- end

	local function roundTo2NmUp(number)
		-- Diviser le nombre par 2 pour travailler avec des pas de 2 NM
		local scaled = number / 2
		-- Arrondir à l'entier supérieur le plus proche
		local rounded = math.ceil(scaled)
		-- Revenir à l'échelle d'origine en multipliant par 2
		return rounded * 2
	end


	local function calculateAspect(myPos, enemy)
		local aspect = "UNKNOWN"

		-- Récupérer la position et l'orientation de l'ennemi
		-- local enemyPos = enemy:getPosition()
		-- local forward = enemyPos.x -- Forward vector (direction de l'ennemi)
		-- local targetPos = enemy:getPoint() -- Position de l'ennemi

		local enemyPos = enemy.position
		local forward = enemyPos.x -- Forward vector (direction de l'ennemi)
		local targetPos = enemy.point -- Position de l'ennemi

		-- Calcul du vecteur relatif de l'ennemi à moi
		local dx = myPos.x - targetPos.x
		local dz = myPos.z - targetPos.z
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
					if _unit and _unit:isActive()  then --and _unit:inAir()
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

							local player = _unit
							local playerId = Unit.getID(player)
							local playerPoint = player:getPoint()				--get target point

							local player_coalition = player:getCoalition()
							local sidePlayer = coalitionIdNumeric[player_coalition]
							local sideENI = DCS_ENI_Side[sidePlayer]

							local targetTracks_km_thisPlayer = {}

							for  _, targets in pairs(groupedTracks) do
								for _, target in pairs(targets) do

									if target and type(target) == "table" and target.point.x and target.point.y then

										-- Calcul de la distance
										local dx = target.point.x - playerPoint.x
										local dz = target.point.z - playerPoint.z
										local distance = math.sqrt(dx^2 + dz^2)

										target.distance = distance
										table.insert(targetTracks_km_thisPlayer, target)
									end
								end
							end

							-- triage de la table en fonction de la distance
							table.sort(targetTracks_km_thisPlayer, function(a,b) return a.distance < b.distance  end)

							local i = 1
							local plotContactDetected = {}
							for trackN, target in pairs(targetTracks_km_thisPlayer) do
								-- Conversion des distances
								local distanceKm = math.floor(target.distance / 1000) -- En kilomètres
								local distanceNm = roundTo2NmUp(target.distance / 1852) -- En miles nautiques, arrondi à 2 Nm près
								local altitudeFt = math.floor((target.point.y * 3.281) / 1000) * 1000 -- Altitude en pieds


								-- Calcul du bearing
								local dx = target.point.x - playerPoint.x
								local dz = target.point.z - playerPoint.z
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
								if target.coalition and target.coalition ~= 0 and target.coalition ~= player_coalition then
									sideIFF = "ENEMY"
									sideContact = sideENI
									aspect = calculateAspect(playerPoint, target)
								else
									sideIFF = "Friend"
									sideContact = sidePlayer
								end

								local catTarget = "aircraft"
								if target.category and target.category == Unit.Category.HELICOPTER then
									catTarget = "helicopter"
									aspect = ""
								end

								local oldSoluce = false
								if oldSoluce then
									-- Affichage si la distance est dans les limites
									if (distanceKm > 2 and distanceKm <= 150) or (distanceKm <= 2 and sideIFF == "ENEMY" ) then

										-- local freq = camp.EWR_frequency[coalitionIdNumeric[sideNum]][1]
										local speak = target.qte.." "..sideIFF.." "..catTarget.." "..tostring(aspect).." Bearing: "..string.format("%.0f", bearing).."° |  Distance: "..tostring(distanceNm).." NM | Altitude: "..tostring(altitudeFt).." ft"

										timer.scheduleFunction(EWR_speaking, {playerId, speak}, timer.getTime() + (i*3))
										-- timer.scheduleFunction(sendTTSMessage, {freq, "AM", speak}, timer.getTime() + (i*2))

										EWR_optionPlayer[trucName]["lasTime"] = locTimer
										i = i + 1
										if i > 6 then break end
									end
								else
									-- Affichage si la distance est dans les limites
									if (distanceKm > 2 and distanceKm <= 150) or (distanceKm <= 2 and sideIFF == "ENEMY" ) then

										-- local freq = camp.EWR_frequency[coalitionIdNumeric[sideNum]][1]
										local speak = target.qte.." "..sideIFF.." "..catTarget.." "..tostring(aspect).." Bearing: "..string.format("%.0f", bearing).."° |  Distance: "..tostring(distanceNm).." NM | Altitude: "..tostring(altitudeFt).." ft"

										local annonce = {
											distanceKm = distanceKm,
											speak = speak,
											qte = target.qte,
											target_point = target.point,
											playerPoint = playerPoint,
											bearing = bearing,
										}

										table.insert(plotContactDetected[sideContact], annonce)
									end


								end

							end


							-- Affichage si la distance est dans les limites
							if (plotContactDetected ) then
								local bearingFriend = {}
								for annonceN, annonce in pairs(plotContactDetected[sideENI]) do

									timer.scheduleFunction(EWR_speaking, {playerId, annonce, i}, timer.getTime() + (i*3))
									-- timer.scheduleFunction(sendTTSMessage, {freq, "AM", speak}, timer.getTime() + (i*2))
									
									EWR_optionPlayer[trucName]["lasTime"] = locTimer
									i = i + 1
									if i > 6 then break end
										
									if i == 1 then
										bearingFriend[1] = annonce.bearing
									elseif i == 2 then
										bearingFriend[2] = annonce.bearing
									end

								end

								for j = 1, #bearingFriend do
									for annonceN, annonce in pairs(plotContactDetected[sidePlayer]) do
										-- Normaliser les angles
										local bearingFriendAngle = normalizeAngle(bearingFriend[j].bearing)
										local annonceAngle = normalizeAngle(annonce.bearing)
								
										-- Calculer la différence absolue en tenant compte du cercle
										local diff = math.abs(annonceAngle - bearingFriendAngle)
										diff = math.min(diff, 360 - diff) -- Prendre en compte l'enroulement
								
										if diff <= 20 then
											timer.scheduleFunction(EWR_speaking, {playerId, annonce, i}, timer.getTime() + (i * 3))
											-- timer.scheduleFunction(sendTTSMessage, {freq, "AM", speak}, timer.getTime() + (i*2))
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

	return timer.getTime() + 60

end


--////////////////////////////////////////////////////////////////////////////////////////////
--test EWR (fin)


EventHandler2 = {}
function EventHandler2:onEvent(event)
	local idLabel = "inc"
	-- env.info("DCE_EventHandler2 PASSE 01 event.id "..tostring(event.id))
	-- _affiche(event, "EventHandler2 event")

	if event and event.id and Info_event and Info_event[tonumber(event.id)] then
		idLabel = tostring(Info_event[tonumber(event.id)])
		-- env.info("DCE_EventHandler2 PASSE 02 event.id "..tostring(event.id).." " ..idLabel)
	end

	-- if event.initiator then
	-- 	env.info("DCE_EventHandler2 PASSE 03 event.id "..tostring(event.id).." initiator.id_: "..tostring(event.initiator.id_))
	-- end

	if event.id == world.event.S_EVENT_BIRTH then
		env.info("DCE_EventHandler2 PASSE BIRTH 001a ")

		if event.initiator and Object.getCategory(event.initiator) ~= Object.Category.STATIC and event.initiator:getPlayerName() then
			env.info("DCE_EventHandler2 PASSE BIRTH 001b ")

			local playerName = event.initiator:getPlayerName()
			-- local Uid = event.initiator:getID()
			local groupObject = event.initiator:getGroup()
			local gpGid = event.initiator:getGroup():getID()

			if gpGid and groupObject and playerName  then
				addFuncs(gpGid, groupObject, playerName)
			end
		end
	elseif not event.place then
		if event.subPlace then
			env.info("DCE_EventHandler2 PASSE 002 subPlace")																								--debug ET01	

			_affiche(event, "event event.subPlace ")
			if event.initiator and event.initiator:getPlayerName() then
				local playerName = event.initiator:getPlayerName()
				-- local Uid = event.initiator:getID()
				local groupObject = event.initiator:getGroup()

				if Group then
					-- local gpGid = event.initiator:getGroup():getID()		--1299: attempt to index a nil value
					local gpGid =Group:getID()		--1300: attempt to index a nil value
					if gpGid and Group and groupObject then
						-- addFuncs(gpGid, Group)
						addFuncs(gpGid, groupObject, playerName)
					end
				end
			end

		elseif event.id == world.event.S_EVENT_LAND or event.id == world.event.S_EVENT_CRASH or event.id == world.event.S_EVENT_DETAILED_FAILURE or event.id == world.event.S_EVENT_AI_ABORT_MISSION
			or event.id == world.event.S_EVENT_POSTPONED_LAND or event.id == world.event.S_EVENT_EMERGENCY_LANDING then
			env.info("DCE_EventHandler2 PASSE 003 LAND or CRASH")

			if event.initiator and not event.initiator:getPlayerName() then

				local ptEvent = event.initiator:getPoint()
				local wreckVec3
				if ptEvent and ptEvent.x then
					wreckVec3 = {
						x = ptEvent.x,
						y = land.getHeight({x = ptEvent.x, y = ptEvent.z}),
						z = ptEvent.z,
					}
					env.info( "DCE_GroundDamagedFlyingMachine B1 wreckVec3 alti "..tostring(wreckVec3.y))
				end

				if wreckVec3.y <= 100 then

					env.info( "DCE_GroundDamagedFlyingMachine B getPlayerName detected ? ")

					local initDesc = event.initiator:getDesc()
					_affiche(initDesc, "DCE_GroundDamagedFlyingMachine initDesc")

					-- local initiatorPilotName = event.initiator:getPlayerName()
					local unitName = event.initiator:getName()
					local life = event.initiator:getLife()
					local init_life = event.initiator:getLife0()
					local lifePourcent = 100
					local isPlayer = false
					if init_life then
						lifePourcent = life/init_life*100
					end


					-- env.info( "DCE_GroundDamagedFlyingMachine C1 initiatorPilotName "..tostring(initiatorPilotName).." lifePourcent: "..tostring(lifePourcent))
					env.info( "DCE_GroundDamagedFlyingMachine C2 init_life "..tostring(init_life).." life: "..tostring(life))
					env.info( "DCE_GroundDamagedFlyingMachine C3 event.initiator.id_ "..tostring(event.initiator.id_))

					-- if initiatorPilotName and initiatorPilotName ~= "" then
					-- 	isPlayer = true
					-- end

					--TODO ajouter une proximité Base & Farp pour ne pas le faire dessus
					if lifePourcent < 100 and lifePourcent >= 1 then
						env.info( "DCE_GroundDamagedFlyingMachine D detected ? event.initiator.id_ "..tostring(event.initiator.id_))

						local Group = event.initiator:getGroup()
						local gpGid = Group:getID()
						local categoryId = event.initiator:getDesc().category

						local countryId = event.initiator:getCountry()
						local initiatorCountry = string.lower(country.name[countryId])
						local initiatorSIDE = event.initiator:getCoalition()
						local side = coalitionIdNumeric[tonumber(initiatorSIDE)]

						local eventData = {
							-- initiatorPilotName = initiatorPilotName,
							-- isPlayer = isPlayer,
							unitName = unitName,
							-- unitGame = event.initiator,
							-- Uid = event.initiator:getID(),
							aircraftType = event.initiator:getTypeName(),
							lifePourcent = lifePourcent,
							crashPoint = event.initiator:getPoint(),
							unit = event.initiator,
							gpGid = gpGid,
							idLabel= idLabel,
							categoryId = categoryId,
							Coalition = event.initiator:getCoalition(),
							initiatorMissionID = event.initiator:getID(),
							initiatorSIDE = initiatorSIDE,
							countryId = countryId,
							initiatorCountry = initiatorCountry,
							side = side,
							initiator_id_ = event.initiator.id_,
						}

						-- if not GroundDamagedFlyingMachine[gpGid] then GroundDamagedFlyingMachine[gpGid] = {} end
						-- table.insert(GroundDamagedFlyingMachine[gpGid], eventData)



						if not GroundDamagedFlyingMachine[event.initiator.id_] then GroundDamagedFlyingMachine[event.initiator.id_] = {} end
						table.insert(GroundDamagedFlyingMachine[event.initiator.id_], eventData)

						local current_time = timer.getTime()
						if camp.debug then
							local logStr = "DamagedFM = " .. TableSerialization(GroundDamagedFlyingMachine, 0)
							local grpnameClean = unitName:gsub('[%p%c%s]', '_')
							local logFile = io.open(PathDCE.."Debug\\"..event.initiator.id_.."_"..grpnameClean.."_".. "DamagedFM_"..current_time..".lua", "w")
							if logFile then
								logFile:write(logStr)
								logFile:close()
							else
								env.info("DCE_GroundDamagedFlyingMachine: Failed to open log file for writing.")
							end
						end

					end

					-- local gpGid = event.initiator:getGroup():getID()

				end
			end
		end
	elseif event.id == world.event.S_EVENT_DEAD or event.id == world.event.S_EVENT_PILOT_DEAD or event.id == world.event.S_EVENT_KILL then

		--TODO controler si c'est utile
		if event.initiator and event.initiator.id_ then
			for n, damageds in pairs(GroundDamagedFlyingMachine) do
				local toRemove = {} -- Table pour stocker les clés à supprimer

				for initiatorId, damaged in pairs(damageds) do
					env.info("DCE_GroundDamagedFlyingMachine S_EVENT_KILL n: " .. n .. " initiatorId: " .. tostring(initiatorId))

					if initiatorId == event.initiator.id_ then
						env.info("DCE_GroundDamagedFlyingMachine S_EVENT_KILL delete initiatorId: " .. tostring(initiatorId))
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

world.addEventHandler(EventHandler2)



--sur certaines map en solo (Syria) l'evenement Birth n'est pas detectée
local function timerPlayerMenu(arg)
	if (radioCommands == nil or #radioCommands == 0) and timer.getTime() < 10 then
		local Uid, groupObject, gpGid, playerName
		local playerObj = localGetPlayerObj()
		if playerObj then
			-- Uid = playerObj:getID()
			playerName = playerObj:getPlayerName()
			groupObject = playerObj:getGroup()
			gpGid = playerObj:getGroup():getID()
		end

		if gpGid and Group then
			-- addFuncs(gpGid, Group)
			addFuncs(gpGid, groupObject, playerName)
		end
	end
end

function LoopPilot()

	local groups = coalition.getGroups(coalition.side.BLUE, Group.Category.AIRPLANE)

	for i, gp in pairs(groups) do
		-- local  gpName = Group.getName(gp)
		local  gpGid = Group.getID(gp)

		if gpGid  and gp then
			bingo(gpGid, gp)
		end
	end

	groups = coalition.getGroups(coalition.side.RED, Group.Category.AIRPLANE)

	for i, gp in pairs(groups) do
		-- local  gpName = Group.getName(gp)
		local  gpGid = Group.getID(gp)

		if gpGid  and gp then
			bingo(gpGid, gp)
		end
	end



	if camp.TableTransportPilotNames and ctld and ctld.alreadyInitialized and not var_TPN_alreadyAdded then
		for n=1, #camp.TableTransportPilotNames do
			ctld.transportPilotNames[#ctld.transportPilotNames +1 ] = camp.TableTransportPilotNames[n]
		end

		env.info( "AdCR10 add  ctld.transportPilotNames ")

		var_TPN_alreadyAdded = true
	end

	return timer.getTime() + 15

end

--creation de la table de couverture anti aérienne AMI
hotSpotSAM()

if camp.debug then
	local logStr = "hotSpotAirDefense = " .. TableSerialization(hotSpotAirDefense, 0)
	local logFile = io.open(PathDCE.."Debug\\".."hotSpotAirDefense.lua", "w")
	if logFile then
		logFile:write(logStr)
		logFile:close()
	else
		env.info("DCE_hotSpotAirDefense: Failed to open log file for writing.")
	end
end

timer.scheduleFunction(timerPlayerMenu, nil, timer.getTime() + 5)

timer.scheduleFunction(LoopPilot, nil, timer.getTime() + 15)

timer.scheduleFunction(AirRetreat, nil, timer.getTime() + 5)

timer.scheduleFunction(avoidArea, nil, timer.getTime() + 5)

timer.scheduleFunction(getLL_TargetPosition, nil, timer.getTime() + 20)

timer.scheduleFunction(EWR_magic, nil, timer.getTime() + 30)

timer.scheduleFunction(setErrorMessageBoxShedul, nil, timer.getTime() + 30)



_affiche(AI.Option.Air.val, "AI.Option.Air.val")

_affiche(DCS_CategoryById, "DCE_DCS_CategoryById")

_affiche(Object.Category, "Object.Category")

env.info("ACRF10 end of loading AdCR10 script ")
