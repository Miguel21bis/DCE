-- Adds functions in radio menu F10
--Script attached to mission and executed via trigger
--Functions accessed via LUA Run Script
------------------------------------------------------------------------------------------------------- 
if not versionDCE then versionDCE = {} end
versionDCE["Mission Scripts/AddCommandRadioF10.lua"] = "3.16.59"
------------------------------------------------------------------------------------------------------- 

if not campL.debugInGamePopup then
	env.setErrorMessageBoxEnabled(false)
end


env.info("DCE_ACRF10 version of Lua _VERSION "..tostring(_VERSION))
env.info("DCE_ACRF10 START LOADING AddCommandRadioF10.lua "..tostring(versionDCE["Mission Scripts/AddCommandRadioF10.lua"]))

Bingo_time = 0
Bingo_calls = 0
Bingo_t0 = 0

Perf_A = 0
Perf_A_N = 0



Perf_B = 0
Perf_B_N = 0
Perf_Bb = 0
Perf_B_Nb = 0


Perf_C = 0
Perf_C_N = 0
Perf_D = 0
Perf_D_N = 0
Perf_E = 0
Perf_E_N = 0
Perf_F = 0
Perf_F_N = 0

Perf_G = 0
Perf_G_N = 0
Perf_H = 0
Perf_H_N = 0

Perf_J = 0
Perf_J_N = 0
Perf_I = 0
Perf_I_N = 0

Perf_K = 0
Perf_K_N = 0

Perf_CustAlt = {}
Perf_EventsT = {}

Perf_L = 0
Perf_L_N = 0

Perf_M = 0
Perf_M_N = 0
Perf_O = 0
Perf_O_N = 0
Perf_P = 0
Perf_P_N = 0

Perf_Q = 0
Perf_Q_N = 0

Perf_S = 0
Perf_S_N = 0

Perf_E_timer = 0

Perf_Tot = 0

Cache_UnitCategoryByGetID = {} -- Unit.Category = {
-- Unit.Category = {
--   AIRPLANE      = 0,
--   HELICOPTER    = 1,
--   GROUND_UNIT   = 2,
--   SHIP          = 3,
--   STRUCTURE     = 4
-- }


DCE_groupRouteCache = {} -- [groupId] = { base=..., station1=..., station2=..., orbitAlt=..., orbitSpeed=... }
MissGroupByName = {}
BaseDistCache = {}
DCE_hotspotGrid = {}
DCE_hotspotCellSize = 100000 -- même que ton clusterThreshold

GroupMenusBuilt = GroupMenusBuilt or {}

GroupEWRMenus = GroupEWRMenus or {}
PlayerGroup = PlayerGroup or {}
EWR_optionPlayer = {}
EWR_rebuildPending = {}
local requestEWRMenuRebuild
local addFuncs
if not EWR_menuRootByGroup then
	EWR_menuRootByGroup = {}
end
MenuF10ByGroupByCmd = MenuF10ByGroupByCmd or {}

local fuelCacheCooldown = 5   -- secondes entre deux lectures DCS par avion
FuelCache = FuelCache or {}


AFAC_available = {}				--liste les AFAC en position
AFAC_targetStatus = {}    --table used by AFACs to monitor the status of targets and move on to the next ones

-- LastInjectAFAC = {}    --garde les derniers plan de vol injecté
LastInjectFlightPlan = {} --garde les derniers plan de vol injecté

ScheduleTenth = {}					--table used to schedule the tenth of a second
AgendaSeconde = {}


ZoneSAR = {} --table enumérant les helico SAR pour eviter d'en envoyer plusieurs aux memes endroits
EjectionSeatFrequency = {}
EjectedPilotOnBoard = {}
GroundDamagedFlyingMachine = {}
SumSoldierAliasPilot = 0

CustomLog = {}

SatusGroupAircraft = {}			--table used to store the status of aircraft groups
Players = {}					--table used to store player units
BingoPlaneTab = {}
AvgConsumptionKgPerKm = {}		--table used to store the available distance in km for each unitCat
TypePedroByCV = campL.TypePedroByCV or {}         		--table used to store the type of Pedro by CV
PlayerInOutAircraft = {}

EWR_Magic_DISTANCE_KM = 150  --distance en km pour detecter les cibles

SmokeColor_EjectedPilot = trigger.smokeColor.Orange
SmokeColor_TargetDesignation = trigger.smokeColor.Blue

RadioWatt = 1 -- Radio power in watts, used for radio beacon transmission

SAR_fct = {}	--table des fonction SAR, evite tous les pbs de monter une function avant l'autre

AnnonceOneOunce = {}

--target tracks
Target_tracks = {
	["blue"] = {},
	["red"] = {}
}

CoalitionIdAlphaToName = {
	["0"] = "neutral",
	["1"] = "red",
	["2"] = "blue",
}

CoalitionIdToName = {
	[0] = "neutral",
	[1] = "red",
	[2] = "blue",
}

CoalitionIdToENI_Id = {
	[0] = 1,
	[1] = 2,
	[2] = 1,
}

CoalitionNameToId = {
	["neutral"] = 0,
	["red"] = 1,
	["blue"] = 2,
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

-- local function menuF10_SAR(...) end

-- addFuncs()

local radioCommands = {}
local flightPlanTimer = {}
local tabJockerPlane = {}
local var_TPN_alreadyAdded = false
-- Liste des unités à exclure
local excludedUnitTypes = {
	["FPS-117"] = true,
	["55G6 EWR"] = true,
	["1L13 EWR"] = true,
	["FPS-117 Dome"] = true,
	["TACAN_beacon"] = true,
}


-----*********check path**************---------
env.info( "DCE_Bat_Path  "..tostring(campL.path) )

PathDD = "c:"
--prepare campaign path
PathDCE = string.gsub(campL.path, "/", "\\")																		--replace slashes in campaign path with double-backslashes
if  string.sub (campL.path, 2, 2) ~= ":" then																	--si le chemin est differen de C:\Users ou D:\Users
	PathDCE = os.getenv('USERPROFILE') .. "\\" .. PathDCE														--get path of windows userprofile and add to campaign path	
else
	PathDD = string.sub (campL.path, 1, 2)
end

PathDCE = PathDCE .."Mods\\tech\\DCE\\Missions\\Campaigns\\"..campL.title.."\\"
env.info( "DCE_PathDCE "..tostring(PathDCE) )
env.info( "DCE_PathDD "..tostring(PathDD) )
-----*********check PathDCE**************---------



function _affiche(t, indent)
    indent = indent or ""

    if type(t) ~= "table" then
        env.info(indent .. tostring(t)) -- Affiche directement la valeur si ce n'est pas une table
        return
    end

    for key, value in pairs(t) do
        if type(value) == "table" then
            env.info(indent .. tostring(key) .. ":")
            _affiche(value, indent .. "  ") -- Correction : appel récursif correct
        else
            env.info(indent .. tostring(key) .. ": " .. tostring(value))
        end
    end
end


-- log.write('MIGUEL.EXPORT',log.INFO,logExp)

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

local indentcache = {}

function TableSerialization(t, i, params)
	-- buffer de sortie
	local buffer = {}
	local bufferindex = 1

	-- indentation avec cache
	local function getindent(n)
		local s = indentcache[n]
		if not s then
			s = string.rep("\t", n)
			indentcache[n] = s
		end
		return s
	end

	local tab1          = getindent(i)
	local tab           = getindent(i + 1)

	buffer[bufferindex] = "\n" .. tab1 .. "{\n"
	bufferindex         = bufferindex + 1

	-- itération SANS TRI (gros gain)
	for k, v in pairs(t) do
		-- clé
		if type(k) == "string" then
			if k:find("\n", 1, true) then
				k = k:gsub("\n", "\\\n")
			end
			if k:find('"', 1, true) then
				k = k:gsub('"', '\\"')
			end
			buffer[bufferindex] = tab .. '["' .. k .. '"] = '
		else
			buffer[bufferindex] = tab .. "[" .. tostring(k) .. "] = "
		end
		bufferindex = bufferindex + 1

		-- valeur
		if type(v) == "string" then
			if v:find("\n", 1, true) then
				v = v:gsub("\n", "\\\n")
			end
			if v:find('"', 1, true) then
				v = v:gsub('"', '\\"')
			end
			buffer[bufferindex] = '"' .. v .. '",\n'
			bufferindex = bufferindex + 1
		elseif type(v) == "number" then
			buffer[bufferindex] = tostring(v) .. ",\n"
			bufferindex = bufferindex + 1
		elseif type(v) == "table" then
			buffer[bufferindex] = TableSerialization(v, i + 1) .. "\n"
			bufferindex = bufferindex + 1
		elseif type(v) == "boolean" then
			buffer[bufferindex] = (v and "true" or "false") .. ",\n"
			bufferindex = bufferindex + 1
		elseif type(v) == "function" then
			buffer[bufferindex] = tostring(v) .. ",\n"
			bufferindex = bufferindex + 1
		elseif v == nil then
			buffer[bufferindex] = "nil,\n"
			bufferindex = bufferindex + 1
		end
	end

	-- fermeture
	if i == 0 then
		buffer[bufferindex] = tab1 .. "}\n"
	else
		buffer[bufferindex] = tab1 .. "},\n"
	end

	return table.concat(buffer)
end
--function to return distance between two vector2 points
-- function GetDistance(p1, p2)
function GetDistance(a, b)
	-- local deltax = p2.x - p1.x
	-- local deltay = p2.y - p1.y
	-- return math.sqrt(math.pow(deltax, 2) + math.pow(deltay, 2))
	local dx = a.x - b.x
	local dy = a.y - b.y
	return math.sqrt(dx * dx + dy * dy)
end

-- Helper : calcule distance 2D entre deux points {x,y} et {x,y}
function GetDistance2D(a, b)
	local dx = a.x - b.x
	local dy = a.y - b.y
	return math.sqrt(dx * dx + dy * dy)
end

--response time of the interlocutor, so that the answer is not immediate like a computer
function ResponseTimeForU(arg)
    local Uid = arg[1]
    local txt = arg[2]

    trigger.action.outTextForUnit(Uid, txt, 10)
end

function ResponseTimeForGp(arg)
	local gpGid = arg[1]
    local txt = arg[2]

	trigger.action.outTextForGroup(gpGid, txt, 10)
end


--proxyBase
function ProxyBase(selectedEjection)
    local distanceBase = nil
    local baseName = nil
    for Id, base in pairs(RunwayLife) do
		if base.pointVec3 and base.pointVec3.x and base.pointVec3.z and selectedEjection.pos then
			local dx = base.pointVec3.x - selectedEjection.pos.vec3x
			local dz = base.pointVec3.z - selectedEjection.pos.vec3z
            local tempDistance = math.sqrt(dx * dx + dz * dz)
            if not distanceBase or tempDistance < distanceBase then
                distanceBase = tempDistance
                baseName = base.name
            end
        else
			env.info("DCE_EvenT: pilotLand_C G baseName "..tostring(baseName).." distanceBase "..tostring(distanceBase))

        end
    end
    return distanceBase, baseName
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
	local heading = 0
	if unitpos then
		heading = math.atan2(unitpos.x.z, unitpos.x.x)
		if heading < 0 then
			heading = heading + 2*math.pi	-- put heading in range of 0 to 2*pi
		end
		return heading
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
function CheckPointInPoly_XY_2(point, poly)

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

-- Vérifie si un point est dans un polygone (algorithme robuste)
function CheckPointInPoly_XY_3(point, poly)
    local inside = false
    local j = #poly
    for i = 1, #poly do
        if ((poly[i].y > point.y) ~= (poly[j].y > point.y)) and
           (point.x < (poly[j].x - poly[i].x) * (point.y - poly[i].y) / (poly[j].y - poly[i].y) + poly[i].x) then
            inside = not inside
        end
        j = i
    end
    return inside
end

--*************** BLUILD TAB INIT *********************
--*************** BLUILD TAB INIT *********************

-- Parse env.mission UNE seule fois et construit tous les index nécessaires
-- Pourquoi : éviter 3 parcours complets très coûteux de env.mission
local function buildMissionIndex()

    local t0 = timer.getTime()

    -- MissGroupByName = {}
    -- DCE_groupRouteCache = {}
    -- EnvMissionGroundUnits = {}

    if not env or not env.mission or not env.mission.coalition then
        return
    end

    for _, coalition in pairs(env.mission.coalition) do
        if coalition.country then
            for _, country in pairs(coalition.country) do

                -- ========= AVIONS =========
                if country.plane and country.plane.group then
                    for _, group in pairs(country.plane.group) do
                        -- index par nom
                        if group.name then
                            MissGroupByName[group.name] = group
                        end

                        -- routes
						if group.route and group.route.points then
							local data = {
								orbitCAP = {
									altitude = 0,
									speed = 0
								}
							}
							data.base = group.route.points[#group.route.points]
							data.to = 0
							data.from = 0

							for i, p in ipairs(group.route.points) do
								if p.name == "Station" then
									data.to = i
									data.from = i - 1
								end

								if p.task and p.task.params and p.task.params.tasks then
									for _, t in ipairs(p.task.params.tasks) do
										local task = nil
										if t.params then
											if t.params.task then
												task = t.params.task
											elseif t.params.action then
												task = t.params.action
											end
										end

										if task and task.id == "EngageTargetsInZone" then
											data.sation1 = group.route.points[i]
											data.sation2 = group.route.points[i + 1]
										end
										if task and task.id == "Orbit" and task.params then
											data.orbitCAP.altitude = task.params.altitude
											data.orbitCAP.speed = task.params.speed
										end
									end
								end
							end

                            DCE_groupRouteCache[group.groupId] = data
                        end
                    end
				end
				-- ========= HELICOPTERES =========
				if country.helicopter and country.helicopter.group then
					for _, group in pairs(country.helicopter.group) do
						-- index par nom
						if group.name then
							MissGroupByName[group.name] = group
						end

						-- routes
						if group.route and group.route.points then
							local data = {}
							data.base = group.route.points[#group.route.points]

							for i, p in ipairs(group.route.points) do
								if p.name == "Station" then
									data.station1 = group.route.points[i]
									data.station2 = group.route.points[i + 1]
								end

								if p.task and p.task.params and p.task.params.tasks then
									for _, t in ipairs(p.task.params.tasks) do
										local task = nil
										if t.params then
											if t.params.task then
												task = t.params.task
											elseif t.params.action then
												task = t.params.action
											end
										end

										if task and task.id == "Orbit" and task.params then
											data.orbitAlt = task.params.altitude
											data.orbitSpeed = task.params.speed
										end
									end
								end
							end

							DCE_groupRouteCache[group.groupId] = data
						end
					end
				end
            end
        end
    end

	env.info("DCE buildMissionIndex: planes=" ..
		tostring(#MissGroupByName) ..
		-- " groundUnits=" .. #EnvMissionGroundUnits ..
		" in " .. string.format("%.3f", timer.getTime() - t0) .. "s")


end





--*************** BLUILD TAB INIT *********************
--*************** BLUILD TAB INIT *********************


-- MGRS Rescue Zones (simplified)
--
-- Each MGRS square is divided into four rescue zones:
--
--        North
--      [3] | [4]
--      -----------
--      [1] | [2]
--        South
--
-- Zone 1 = South-West
-- Zone 2 = South-East
-- Zone 3 = North-West
-- Zone 4 = North-East
--
-- When a downed pilot reports "Zone 3", go to the north-west quarter
-- of the specified MGRS grid (e.g. 35W NR).
function Add_MGRS_Chute(pilot)
	local grid    = coord.LLtoMGRS(coord.LOtoLL(pilot))

	-- Extract first digit of Easting & Northing (10 km subdivision)
	local E       = tonumber(string.sub(grid.Easting, 1, 1))
	local N       = tonumber(string.sub(grid.Northing, 1, 1))

	-- Determine direction
	local isEast  = (E >= 5)
	local isNorth = (N >= 5)

	-- New zone numbering (requested layout):
	--        North
	--      3 | 4
	--      ------
	--      1 | 2
	--        South
	local zoneNumber

	if not isEast and not isNorth then
		zoneNumber = 1 -- South-West
	elseif isEast and not isNorth then
		zoneNumber = 2 -- South-East
	elseif not isEast and isNorth then
		zoneNumber = 3 -- North-West
	else
		zoneNumber = 4 -- North-East
	end

	-- Construct final strings
	pilot.MGRS_Chute = grid.UTMZone .. "_" ..
		grid.MGRSDigraph .. "_Zone_" .. zoneNumber

	pilot.MGRS_Chute_10KM = grid.UTMZone .. "_" ..
		grid.MGRSDigraph .. "_" .. E .. "_" .. N

	return pilot
end

-- function Add_MGRS_Chute(pilot)

-- 	local grid = coord.LLtoMGRS(coord.LOtoLL(pilot))

--     --Avec 2 lettres (A et B) on passe de zone de 10km à des zone de 50km (la limite supérieur serait de 100km)
--     --A B
-- 	--A B
-- 	local subdiv_E_Num = tonumber(string.sub(grid.Easting, 1, 1))
-- 	local subdiv_E_Alpha
-- 	if subdiv_E_Num < 5 then
-- 		subdiv_E_Alpha = "A"
-- 	else
-- 		subdiv_E_Alpha = "B"
-- 	end

-- 	local subdiv_N_Num = tonumber(string.sub(grid.Northing, 1, 1))
-- 	local subdiv_N_Alpha
-- 	if subdiv_N_Num < 5 then
-- 		subdiv_N_Alpha = "A"
-- 	else
-- 		subdiv_N_Alpha = "B"
-- 	end

-- 	pilot.MGRS_Chute = grid.UTMZone .. "_" .. grid.MGRSDigraph .. "_" .. subdiv_E_Alpha .. "_" .. subdiv_N_Alpha
-- 	pilot.MGRS_Chute_10KM = grid.UTMZone .. "_" .. grid.MGRSDigraph .. "_" .. subdiv_E_Num .. "_" .. subdiv_N_Num

-- 	return pilot
-- end


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
	if not campL.debugInGamePopup then
		env.setErrorMessageBoxEnabled(false)
	end
end

local function getGroupById(groupId)
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
    if type(name) ~= "string" then
        return ""
    end
    return name:gsub("['\"]", '')
end

function NormalizeAngle(angle)
    return (angle % 360 + 360) % 360
end


function GenerateIdAleatoire()
    local chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
    local id = ''
    for i = 1, 10 do
        local r = math.random(1, #chars)
        id = id .. chars:sub(r, r)
    end
    return id
end

-- Table globale
CarrierIndex = {}

-- construit l’index
function BuildCarrierIndex()
	CarrierIndex = {}

	for _, coal in ipairs({ coalition.side.BLUE, coalition.side.RED }) do
		local groups = coalition.getGroups(coal, Group.Category.SHIP)
		if groups then
			for _, group in ipairs(groups) do
				local units = group:getUnits()
				if units then
					for _, unit in ipairs(units) do
						if unit and unit.isExist and unit:isExist() then
							local desc = unit:getDesc()
							if desc and desc.category == Object.Category.SHIP then
								local id = unit:getID()
								if id then
									CarrierIndex[id] = unit
								end
							end
						end
					end
				end
			end
		end
	end
end

-- retourne la position d’un CV/CVN depuis son unitId ou son nom
-- mesure le temps CPU cumulé consommé par cette fonction
local function getCarrierPosition(linkUnit)

    if not linkUnit then
        return nil
    end

    -- 1) cas normal : ID
    if type(linkUnit) == "number" then
        local u = CarrierIndex[linkUnit]
        if u and u.isExist and u:isExist() and u.getLife and u:getLife() > 0 then
            local p = u:getPoint()
            return p
        end

        return nil
    end

    -- 2) fallback : recherche par nom (rare)
    for _, u in pairs(CarrierIndex) do
        if u and u.isExist and u:isExist() and u.getName and u:getName() == linkUnit then
            local p = u:getPoint()
            return p
        end
    end

    return nil
end



-- --genere une table des CV et CVN par unitId pour retrouver leur position, car ils bougent les bougres ^^
-- function GetCarrierPosition(linkUnit)
--     -- linkUnit peut être un ID numérique ou un nom (string)
--     for _, coalTab in ipairs({coalition.side.BLUE, coalition.side.RED}) do
--         local groups = coalition.getGroups(coalTab, Group.Category.SHIP)
--         for _, group in ipairs(groups) do
--             local units = group:getUnits()
--             for _, unit in ipairs(units) do
--                 if unit and unit.getDesc and unit:getDesc() and unit:getDesc().category == Object.Category.SHIP then
--                     -- Vérifie que le carrier est vivant
--                     if unit.isExist and unit:isExist() and unit.getLife and unit:getLife() > 0 then
--                         -- Vérification par ID (plus rapide et sûr)
--                         if unit.getID and linkUnit and unit:getID() == linkUnit then
--                             return unit:getPoint() -- Retourne la position Vec3 (x, y, z)
--                         end
--                         -- Ou vérification par nom (si besoin)
--                         if unit.getName and linkUnit and unit:getName() == linkUnit then
--                             return unit:getPoint()
--                         end
--                     end
--                 end
--             end
--         end
--     end
--     return nil -- Carrier non trouvé ou détruit
-- end


function DCE_GetRoute(name)

	local select = MissGroupByName[name]
	if not select then
		env.info("DCE_Bug DCE_GetRoute this group Id not found in MissionGroupIndex[] " .. tostring(name))
	end

	return select
end



function FctRemovePlane(_unit)
	_unit:destroy()
	env.info("DCE_FctRemovePlane despawn/destroy ")
end

function RemovePlane(playerGroup)

	local playerUnits = playerGroup:getUnits()
	local playerUnit = playerUnits[1]
	local playertPointVec3 = playerUnit:getPoint()
	local coalitionId = playerUnit:getCoalition()
	missionCommands.removeItem( {"nearby aircraft"})
	local requestM = missionCommands.addSubMenu('nearby aircraft'  )
	local RPlane = {}
	local groups = coalition.getGroups(coalitionId, Group.Category.AIRPLANE)
	for i, gp in pairs(groups) do
		local gpName = Group.getName(gp)
		local units = gp:getUnits()

		for n=1, #units do
			local _unit = units[n]
			if  _unit:isActive() and not _unit:inAir() then

				local description = _unit:getDesc()

				-- _affiche(description, "description")

				local unitPosVec3 = _unit:getPoint()
				local gpGid = Group.getID(gp)
				local UnitId = Unit.getID(_unit)
				local unitCallsign = _unit:getCallsign()
				local distance = math.floor(math.sqrt(math.pow(unitPosVec3.x - playertPointVec3.x, 2) + math.pow(unitPosVec3.z - playertPointVec3.z, 2)))
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


-- local function chooseBestHotspotOLD(arg_actualPos, arg_sideName)
--     local bestHotSpot = nil
--     local shortestDistance = math.huge

--     for _, hotspot in ipairs(hotSpotAirDefense[arg_sideName]) do
--         local dist = calculateDistance(arg_actualPos.x, arg_actualPos.y, hotspot.x, hotspot.y)
--         if dist < shortestDistance then
--             shortestDistance = dist
--             bestHotSpot = hotspot
--         end
--     end

--     return bestHotSpot
-- end

-- retourne le centre des avions actifs du groupe (leader si possible)
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

							if logFile then
								logFile:write(logStr)
								logFile:close()
							else
								env.info("DCE_avoidArea: Failed to open log file for writing.")
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


-- met à jour ou retourne les infos fuel d’un avion avec cooldown
-- retourne fuel et données avion avec cache temporel basé sur le temps DCS
local function updateFuelCache(unit)
	if not unit or not unit.isExist or not unit:isExist() then
		return nil
	end

	local unitId = unit:getID()
	local now = timer.getTime()

	local c = FuelCache[unitId]

	if not c then
		local desc = unit:getDesc()
		if not desc or not desc.fuelMassMax or not desc.range then
			return nil
		end

		c = {
			fuel = Unit.getFuel(unit),
			fuelMassMax = desc.fuelMassMax,
			range = desc.range,
			nextUpdate = now + fuelCacheCooldown
		}

		FuelCache[unitId] = c
		return c
	end

	-- cooldown pas expiré → aucune API DCS appelée
	if now < c.nextUpdate then
		return c
	end

	-- rafraîchissement réel
	c.fuel = Unit.getFuel(unit)
	c.nextUpdate = now + fuelCacheCooldown

	return c
end

local function updateBaseDistance(unit, baseX, baseY)
	local id = unit:getID()
	local now = timer.getTime()

	local c = BaseDistCache[id]
	local pos = unit:getPoint()

	local dx = pos.x - baseX
	local dy = pos.z - baseY
	local dist = math.sqrt(dx * dx + dy * dy) / 1000

	if not c then
		BaseDistCache[id] = {
			baseX = baseX,
			baseY = baseY,
			lastDistKm = dist,
			lastTime = now,
			closingSpeed = 0
		}
		return dist
	end

	local dt = now - c.lastTime
	if dt > 0 then
		c.closingSpeed = (c.lastDistKm - dist) / dt
	end

	c.lastDistKm = dist
	c.lastTime = now
	c.baseX = baseX
	c.baseY = baseY

	return dist
end

local function bingo(gpId, gpObj)

	local t0 
	if campL.debug then 
		t0 = os.clock()
	end

	-- if Bingo_calls == 0 then
	-- 	-- Bingo_t0 = timer.getTime()
	-- 	Bingo_t0 = os.clock()
	-- end
	-- Bingo_calls = Bingo_calls + 1
	-- Bingo_prof.pass = Bingo_prof.pass + 1

	for n, unit in pairs(gpObj:getUnits()) do
		-- Bingo_prof.units = Bingo_prof.units + 1

        local callSign = Unit.getCallsign(unit)
		
        -- if BingoPlaneTab[gpId] and BingoPlaneTab[gpId][callSign] then
        --     Bingo_prof.dejaBingo_skip = Bingo_prof.dejaBingo_skip + 1
        --     return
        -- end
		
		if BingoPlaneTab[gpId] and BingoPlaneTab[gpId][callSign] then
			-- Bingo_prof.dejaBingo_skip = Bingo_prof.dejaBingo_skip + 1
		else

			local groupName = gpObj:getName()
			local toRTB
			local distanceToBase_Km = 0
			local cruiseSpeed = 300
			local speedMini = 999999
			local speedMax = 0
					
			local cache = updateFuelCache(unit)
			if not cache then
				env.info("DCE_Bingo D6 not cache, is dead? " .. tostring(callSign))
			else
				local fuelRemainingPercent = cache.fuel
				local fuelMass = cache.fuel * cache.fuelMassMax
				local unitRange = cache.range
				local unitId = unit:getID() -- celui-là est cheap

				-- 🟢 pré-filtre
				if fuelRemainingPercent > 0.60 then
				-- if fuelRemainingPercent > 2 then --testing
					-- Bingo_prof.prefilter_skip = Bingo_prof.prefilter_skip + 1
				else
					-- Bingo_prof.heavy_calc = Bingo_prof.heavy_calc + 1

					--calcul de la distance restante vers la base
					local mGroup = MissGroupByName[groupName]
					if mGroup then
						local route = mGroup.route.points
						-- local unitVec3 = unit:getPoint()

						local baseX, baseY

						--a mettre en cache
						if route[1].type == "TakeOff" then
							baseX = route[1].x
							baseY = route[1].y
						else
							local last = route[#route]
							baseX = last.x
							baseY = last.y
						end

						-- CV ?
						if route[1].linkUnit then
							local cv = getCarrierPosition(route[1].linkUnit)
							if cv then
								baseX = cv.x
								baseY = cv.z
							end
						end
						-- distanceToBase_Km = GetDistance({ x = baseX, y = baseY }, { x = unitVec3.x, y = unitVec3.z }) / 1000

						local c = BaseDistCache[unitId]
                        if c then
                            local dt = timer.getTime() - c.lastTime
                            distanceToBase_Km = c.lastDistKm - c.closingSpeed * dt
                        else
                            distanceToBase_Km = updateBaseDistance(unit, baseX, baseY)
                        end
					else
						env.info("DCE_Bug DCE_Bingo this group not found in MissionGroupIndex[] " .. tostring(groupName))
					end

					if fuelMass and fuelMass > 0 then
						if distanceToBase_Km > 0 then
							if not AvgConsumptionKgPerKm[unitId] then
								if unitRange > 0 then
									AvgConsumptionKgPerKm[unitId] = cache.fuelMassMax / unitRange
								else
									AvgConsumptionKgPerKm[unitId] = 3
								end
							end

							local availableDistanceKm = fuelMass / AvgConsumptionKgPerKm[unitId]

							-- env.info("DCE_Bingo D3b availableDistanceKm: " .. tostring(availableDistanceKm) .. " <? distanceToBase_Km+200000: " .. tostring(distanceToBase_Km+200000))

							if availableDistanceKm < (distanceToBase_Km + 200) then
							-- if availableDistanceKm < (distanceToBase_Km + 200000) then
								toRTB = true
							end
						end
					else
						env.info("DCE_Bug Bingo D5 unitDesc invalid or missing fuelMassMax/range")
					end
				end

				if toRTB then
					-- Bingo_prof.ckeckRTB = Bingo_prof.ckeckRTB + 1
					
					trigger.action.outTextForGroup(gpId, callSign .. " low fuel: RTB", 15, true)

					if not BingoPlaneTab[gpId] then BingoPlaneTab[gpId] = {} end

					BingoPlaneTab[gpId][callSign] = true -- la callSign à déja indiqué qu'il était Bingo

					local humainUnit
					if unit and unit.getPlayerName then
						humainUnit = unit:getPlayerName()
					end
					-- local unitName = unit:getName()
					local unitVec3 = unit:getPoint()

					
					local report = "DCE_Bingo, pass toRTB, is humainUnit?:  " .. tostring(humainUnit)
					report = report .. " "..tostring(callSign)
					local cntrl

					--for the leader, the task has to be set on the group level
					if n == 1 then
						cntrl = gpObj:getController()
					else
						cntrl = unit:getController()
					end

					report = report .. " RTB_ON_BINGO & PROHIBIT_AB "

					local breaktab = false
					local rtbGroup = {
						name = "",
						from = 0,
						to = 0
					}

					local mGroupB = MissGroupByName[groupName]
					if mGroupB then
						-- Bingo_prof.waypoint_scans = Bingo_prof.waypoint_scans + #mGroupB.route.points

						--le wpt le plus proche de l'unit
						local existIP = 0
						local wptN_closest = #mGroupB.route.points - 1
						local closestPoint = 99999999
						for wptN, wpt in ipairs(mGroupB.route.points) do
							if wpt.name == 'IP' then
								existIP = wptN
								closestPoint = 99999999
								-- env.info( "DCE_Bingo D1  passIP existIP: "..tostring(existIP))
							end
							--on essai de passer le point IP et le target
							if existIP > 0 and wptN < existIP + 2 then
								closestPoint = 99999999
								-- env.info( "DCE_Bingo D2 N1 existIP: "..tostring(existIP).." wptN : "..tostring(wptN).." < "..tostring(existIP+2))
							end
							local distance = GetDistance({ x = unitVec3.x, y = unitVec3.z },
								{ x = wpt.x, y = wpt.y })
							if distance < closestPoint then
								closestPoint = distance
								wptN_closest = wptN
								-- env.info( "DCE_Bingo D1 N2 wptN_closest: "..tostring(wptN_closest).." closestPoint: "..tostring(closestPoint))
							end
						end

						rtbGroup.from = wptN_closest

						-- --Split
						-- for key, value in ipairs(_group.route.points) do
						-- 	if value.name == 'Split' then
						-- 		rtbGroup.from = key
						-- 	end
						-- end


						for key, value in ipairs(mGroupB.route.points) do
							--  env.info( "DCE_Bingo D1        waypoint "..tostring(key).." type "..tostring(value.type))
							if value.type == 'Land' then
								--  env.info( "DCE_Bingo D_2        found Land waypoint at "..tostring(key))
								rtbGroup.to = key
							end
						end


						if rtbGroup.to == 0 then
							rtbGroup.to = #mGroupB.route.points
						end

					end

					-- env.info( "DCE_Bingo D__DD        rtbGroup from "..tostring( rtbGroup.from).." to "..tostring( rtbGroup.to))

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

						-- Bingo_prof.rtb_orders = Bingo_prof.rtb_orders + 1

						cntrl:setOption(AI.Option.Air.id.REACTION_ON_THREAT, 2)
						cntrl:setOption(AI.Option.Air.id.PROHIBIT_AA, true) -- Désactiver l'engagement A/A
						cntrl:setOption(AI.Option.Air.id.PROHIBIT_JETT, false)
						cntrl:setOption(AI.Option.Air.id.PROHIBIT_AB, true)
						cntrl:setOption(AI.Option.Air.id.JETT_TANKS_IF_EMPTY, true)

						-- RTB_NO							= false,
						-- RTB_AAR_REFUEL 					= true,
						-- RTB_IGNORE_AAR					= 2,

						cntrl:setOption(AI.Option.Air.id.RTB_ON_BINGO, 2) -- RTB on Bingo  RTB_IGNORE_AAR
						--OptionName.RTB_ON_BINGO

						env.info( "DCE_Bingo D__DD        "..callSign.." RTB_ON_BINGO set" .. report)

					end
				end
			end
		end
	end

	--TODO a revoir, car callSign est hor boucle
	-- if tabJockerPlane[gpId] and not tabJockerPlane[gpId][callSign] then												-- si le callSign a deja dit qu'il etait Bingo, on l'oublie
	-- 	if Unit.getFuel(unit) <=  0.30 then																			-- Sur F14, 4000lbs/16000lbs = 0.25%
	-- 		trigger.action.outTextForGroup(gpId, callSign .." Jocker Fuel", 15 , true)
	-- 		-- env.info( " Unit.getFuel(unit)  "..callSign.." humainUnit? "..tostring(humainUnit) )
	-- 		tabJockerPlane[gpId][callSign] = true																	-- la callSign à déja indiqué qu'il était Bingo			
	-- 	end
	-- end


	-- if Bingo_calls >= 1000 then
	-- 	local dt = os.clock() - Bingo_t0
	-- 	Bingo_time = Bingo_time + dt
	-- 	env.info("DCE_Perf Bingo_time: " .. tostring(Bingo_time).. " seconds for "..tostring(Bingo_calls).." calls. Avg time per call: "..tostring(Bingo_time / Bingo_calls).." seconds.")
		
	-- 	Bingo_time = 0
	-- 	Bingo_calls = 0

	-- 	env.info(
	-- 		"DCE_Bingo PROF D | pass=" .. Bingo_prof.pass ..
    --         " units=" .. Bingo_prof.units ..
	-- 		" bingoSkip=" .. Bingo_prof.dejaBingo_skip ..
	-- 		" fuelSkip=" .. Bingo_prof.prefilter_skip ..
    --         " heavy=" .. Bingo_prof.heavy_calc ..
	-- 		" ckeckRTB=" .. Bingo_prof.ckeckRTB ..
	-- 		" wptScan=" .. Bingo_prof.waypoint_scans ..
	-- 		" RTB=" .. Bingo_prof.rtb_orders
    --     )
    --     for k in pairs(Bingo_prof) do
    --         Bingo_prof[k] = 0
    --     end

	-- end

	if campL.debug then 
		local dt = os.clock() - t0
		Bingo_time = Bingo_time + dt
		Bingo_calls = Bingo_calls + 1
	end

end


LLtool = {}

LLtool.LLstrings = function(posVec3) -- pos is a Vec3

	local LLposN, LLposE = coord.LOtoLL(posVec3)
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
local function AFAC_com(arg)

	-- local AFAC_Name = arg[1]
	-- local gpGid = arg[2]
	-- local radioOn = arg[3]

	local afacData = {
		AFAC_Name = Deepcopy(arg[1]),
		gpGid = Deepcopy(arg[2]),
		radioOn = Deepcopy(arg[3]),
	}

	_affiche(afacData, "AFAC_afacData ")

	if afacData.radioOn and afacData.radioOn == "on"  then
		AFAC_available[afacData.AFAC_Name]["gpGid"] = afacData.gpGid
		trigger.action.outTextForGroup(afacData.gpGid,"AFAC radio On, waiting ...", 15, false)
		_affiche(AFAC_available, "AFAC_available_radioOn ")

	elseif afacData.radioOn and afacData.radioOn == "off"  then
		if AFAC_available[afacData.AFAC_Name]["gpGid"] and AFAC_available[afacData.AFAC_Name]["gpGid"] == afacData.gpGid  then
			AFAC_available[afacData.AFAC_Name]["gpGid"] = nil
		end
		trigger.action.outTextForGroup(afacData.gpGid,"AFAC radio Off", 15, false)
		_affiche(AFAC_available, "AFAC_available_radioOff ")
	else
		trigger.action.outTextForGroup(afacData.gpGid,"AFAC radio ?else?", 15, false)
		_affiche(AFAC_available, "AFAC_available else ")
	end

end

local function AFAC_Com_ON(arg)

	-- local AFAC_Name = arg[1]
	-- local gpGid = arg[2]
	-- local radioOn = arg[3]

	local afacData = {
		AFAC_Name = Deepcopy(arg[1]),
		gpGid = Deepcopy(arg[2]),
		radioOn = Deepcopy(arg[3]),
	}

	_affiche(afacData, "AFAC_afacData ")


	AFAC_available[afacData.AFAC_Name]["gpGid"] = afacData.gpGid
	trigger.action.outTextForGroup(afacData.gpGid,"AFAC radio On, waiting ...: "..tostring(afacData.AFAC_Name), 15, false)
	_affiche(AFAC_available, "AFAC_available_radioOn ")
end

local function AFAC_Com_OFF(arg)

	-- local AFAC_Name = arg[1]
	-- local gpGid = arg[2]
	-- local radioOn = arg[3]

	local afacData = {
		AFAC_Name = Deepcopy(arg[1]),
		gpGid = Deepcopy(arg[2]),
		radioOn = Deepcopy(arg[3]),
	}

	_affiche(afacData, "AFAC_afacData ")

	if AFAC_available[afacData.AFAC_Name]["gpGid"] and AFAC_available[afacData.AFAC_Name]["gpGid"] == afacData.gpGid  then
		AFAC_available[afacData.AFAC_Name]["gpGid"] = nil
	end
	trigger.action.outTextForGroup(afacData.gpGid,"AFAC radio Off : "..tostring(afacData.AFAC_Name), 15, false)
	_affiche(AFAC_available, "AFAC_available_radioOff ")
end

function AFAC_F10(playerGroup)

	local gpGid
	if playerGroup and playerGroup:isExist() then
		gpGid = playerGroup:getID()
	else
		return -- Exit the function if group doesn't exist
	end

	missionCommands.removeItemForGroup(gpGid, {"AFAC"})

	local menuAFAC_A = missionCommands.addSubMenuForGroup(gpGid, "AFAC")

	if AFAC_available then

		--ne pas fair ça, cela rend le resultat aélatoire
		-- for AFAC_Name, _ in pairs(AFAC_available) do
		-- 	if AFAC_Name and type(AFAC_Name) == "string" then
		-- 		menuAFAC_A = missionCommands.addSubMenuForGroup(gpGid, "AFAC")
		-- 		break
		-- 	end
		-- end

		local i = 1
		for afacName, _ in pairs(AFAC_available) do
			if afacName and type(afacName) == "string" then

				-- menuAFAC_B = missionCommands.addSubMenuForGroup(gpGid, tostring(afacName), menuAFAC_A)

				-- Create a unique submenu for each AFAC name
				local uniqueMenuAFAC = missionCommands.addSubMenuForGroup(gpGid, tostring(afacName), menuAFAC_A)

				-- Commande pour activer la radio AFAC
				radioCommands[#radioCommands + 1] = missionCommands.addCommandForGroup(gpGid, "AFAC radio On (" .. afacName .. ")", uniqueMenuAFAC, AFAC_Com_ON, {afacName, gpGid, "on"})

				-- Commande pour désactiver la radio AFAC
				radioCommands[#radioCommands + 1] = missionCommands.addCommandForGroup(gpGid, "AFAC radio Off (" .. afacName .. ")", uniqueMenuAFAC, AFAC_Com_OFF, {afacName, gpGid, "off"})

			end
			i = i +1
		end
	end

end

--SAR_function
function SAR_fct.activateRadioBeacon(arguments)

	--attention, surement conflit avec function LoopManagedRadioTransmission()

	local arg_gpGid = arguments[1]
	local arg_ejPilTab = arguments[2]
	local pilEjectObj = Unit.getByName(arg_ejPilTab.name)

	if campL.EjectedPilotFrequency and campL.EjectedPilotFrequency[arg_ejPilTab.sideName] then

		if pilEjectObj then

			env.info( "DCE_activateRadioBeacon  pilEjectObj:isExist "..tostring(pilEjectObj:isExist()))

			if not arg_ejPilTab.embarked and pilEjectObj:isExist() then

				local modulation = 0	--AM/FM
				local modulationTxt = "AM"	--AM
				if campL.EjectedPilotFrequency[arg_ejPilTab.sideName].radioBeacon < 90000000 then
					modulation = 1	--FM
					modulationTxt = "FM"
				end

				env.info("DCE_TransRadio modulation: "..tostring(modulation))
				env.info("DCE_TransRadio Ejected pilot position: "..tostring(arg_ejPilTab.posVec3.x)..", "..tostring(arg_ejPilTab.posVec3.y)..", "..tostring(arg_ejPilTab.posVec3.z))
				env.info("DCE_TransRadio radioBeacon: "..tostring(campL.EjectedPilotFrequency[arg_ejPilTab.sideName].radioBeacon))
				env.info("DCE_TransRadio RadioWatt: "..tostring(RadioWatt))
				env.info("DCE_TransRadio 'radioBeacon_' .. arg_ejPilTab.name: "..tostring('radioBeacon_' .. arg_ejPilTab.name))



				trigger.action.radioTransmission('l10n/DEFAULT/beacon.ogg', arg_ejPilTab.posVec3, modulation, true,
					campL.EjectedPilotFrequency[arg_ejPilTab.sideName].radioBeacon, RadioWatt,
					'radioBeacon_' .. arg_ejPilTab.name)

				local freqShow = campL.EjectedPilotFrequency[arg_ejPilTab.sideName].radioBeacon / 1000000
				trigger.action.outTextForGroup(arg_gpGid, "activate RadioBeacon on : "..freqShow.." MHz "..modulationTxt, 45 , true)

				--set a ON la radio du l'ejectedPilot
				for MGRS_Chute, zone in pairs(ZoneSAR) do
					for pilotN, ejPilot in ipairs(zone) do
						local ejPilotObj = Unit.getByName(ejPilot.name)
						if ejPilot.name == arg_ejPilTab.name then
							ejPilot.radioFreq = freqShow
							ejPilot.radio_on = true
							env.info( "DCE_activateRadioBeacon set radioFreq true for ejPilot.name "..tostring(ejPilot.name))
                            timer.scheduleFunction(SAR_fct.menuF10_SAR, nil, timer.getTime() + 1)
							
						end
					end
				end


			end
		else
			trigger.action.outTextForGroup(arg_gpGid, "No response, the pilot may have been captured or killed. ", 15 , true)

			env.info( "DCE_activateRadioBeacon Error no response  ejectedPilot.name "..tostring(arg_ejPilTab.name))
			
			_affiche(pilEjectObj, "pilEjectObj ")
		end

	else
		env.info( "DCE_activateRadioBeacon frequency Error,  side  "..tostring(arg_ejPilTab.sideName).." or Frequency: "..tostring(campL.EjectedPilotFrequency[arg_ejPilTab.sideName]))

	end
end

function SAR_fct.StopRadioBeaconTransmission(ejPilotName)

	trigger.action.stopRadioTransmission('radioBeacon_'..ejPilotName)

	env.info( "DCE_RADIO StopRadioBeaconTransmission  "..tostring('radioBeacon_'..ejPilotName))

	--set a OFF la radio du l'ejectedPilot
	for MGRS_Chute, zone in pairs(ZoneSAR) do
		for pilotN, ejPilot in ipairs(zone) do
			local ejPilotObj = Unit.getByName(ejPilot.name)
			if ejPilot.sideName == ejPilotName then
				ejPilot.radio_on = nil
				env.info( "DCE_activateRadioBeacon set radioBeacon OFF for ejPilot.name "..tostring(ejPilot.name))	
			end
		end
	end

end

	--************* SAR ejectedPilot PART ****************************************
--on refait régulierement le menu SAR pour actualiser la liste des pilotes ejectés, et le proposer aux menu des joueurs
function SAR_fct.menuF10_SAR(arg)

	-- “Downed pilot, this is Sandy. If you hear me, key your radio twice.”
	env.info("DCE_menuF10_SAR A timer.getTime() " .. tostring(timer.getTime()))

	local gId = arg[1]
	local groupObj = arg[2]

	env.info("DCE_menuF10_SAR C1 arg_gpGid " .. tostring(gId) .. " arg_playerGroup: " .. tostring(groupObj))

	if groupObj and groupObj:isExist() then
	else
		env.info("DCE_menuF10_SAR D playerGroup not exist")
		return
	end

	local wingman = groupObj:getUnits()
	local unitSAR = wingman[1]
	local sar_CoalitionId = tostring(unitSAR:getCoalition())
	-- local uSAR_Player = unitSAR:getPlayerName()

	if unitSAR:isExist() and unitSAR:isActive() then
		local pos_SAR_vec3 = unitSAR:getPoint()
		-- local uSAR_unitId = Unit.getID(unitSAR)
		-- local uSAR_Name = unitSAR:getName()
		-- local uSAR_inAir = unitSAR:inAir()

		env.info("DCE_menuF10_SAR E unitSAR:isExist() "..tostring(unitSAR:isExist()).." unitSAR:isActive() "..tostring(unitSAR:isActive()).." pos_SAR_vec3.x "..tostring(pos_SAR_vec3.x).." pos_SAR_vec3.y "..tostring(pos_SAR_vec3.y).." pos_SAR_vec3.z "..tostring(pos_SAR_vec3.z))
		
		local txt = "Downed pilot, this is Sandy, key your radio and give me a beep."
		timer.scheduleFunction(ResponseTimeForGp, { gId, txt }, timer.getTime() + 2)
		
		for MGRS_Chute, zone in pairs(ZoneSAR) do
			env.info("DCE_menuF10_SAR _F1 MGRS_Chute "..tostring(MGRS_Chute))
			for pilotN, ejPil in ipairs(zone) do
				env.info("DCE_menuF10_SAR _F2 pilotN "..tostring(pilotN).." ejPil.name "..tostring(ejPil.name).." ejPil.embarked "..tostring(ejPil.embarked).." ejPil.sideName "..tostring(ejPil.sideName).." CoalitionIdAlphaToName[sar_CoalitionId] "..tostring(CoalitionIdAlphaToName[sar_CoalitionId]).." ejPil.radio_on "..tostring(ejPil.radio_on))

                if ejPil.name and not ejPil.embarked and ejPil.sideName == CoalitionIdAlphaToName[sar_CoalitionId]
					and not ejPil.radio_on then
					
					env.info("DCE_menuF10_SAR _F3 pilotN "..tostring(pilotN).." ejPil.name "..tostring(ejPil.name).." ejPil.embarked "..tostring(ejPil.embarked).." ejPil.sideName "..tostring(ejPil.sideName).." CoalitionIdAlphaToName[sar_CoalitionId] "..tostring(CoalitionIdAlphaToName[sar_CoalitionId]).." ejPil.radio_on "..tostring(ejPil.radio_on))
					local unitEjectPilot = Unit.getByName(ejPil.name)

					if unitEjectPilot then
						local ejPilotVec3 = unitEjectPilot:getPoint()
						local distance = math.sqrt(math.pow( pos_SAR_vec3.x - ejPilotVec3.x, 2) + math.pow(pos_SAR_vec3.z - ejPilotVec3.z, 2))

						env.info("DCE_menuF10_SAR _F4 pilotN "..tostring(pilotN).." ejPil.name "..tostring(ejPil.name).." distance to player "..tostring(distance))

						if distance <= 140000 then

							env.info("DCE_menuF10_SAR __G pilotN "..tostring(pilotN).." ejPil.name "..tostring(ejPil.name).." is in range for radio transmission")
							
							-- local ejPilData = arg[1]
							-- local ejPilObj = arg[2]
							-- StartRadioTransmission(arg)

							timer.scheduleFunction(StartRadioTransmission, { gId, ejPil, ejPilotVec3}, timer.getTime() + 10)

							if not unitEjectPilot:isExist() then
								StopRadioTransmission(ejPil.name)
							end

						end
					end
				end
			end
		end
	end

end



function SAR_fct.menuF10_SAR_OLD(arg)

	env.info("DCE_menuF10_SAR A timer.getTime() "..tostring(timer.getTime()))

	


	env.info("DCE_menuF10_SAR C0 arg " .. tostring(arg) )

	--si aucun argument, on s'appui sur la liste des joueurs fait maison
    if not arg or arg == nil then
        env.info("DCE_menuF10_SAR _B2 with No arg ")

        for playerName, playerData in pairs(PlayerInOutAircraft) do
            env.info("DCE_menuF10_SAR  _B4 gid " ..  tostring(playerData.gid) .. " Group " .. tostring(playerData.groupObject))
            if playerData.gid and playerData.groupObject then
                env.info("DCE_menuF10_SAR  _B5 gid " .. tostring(playerData.gid) .. " Group " .. tostring(playerData.groupObject))
                SAR_fct.menuF10_SAR({ playerData.gid, playerData.groupObject })
            end
        end
    end

	if not arg or arg == nil then
		env.info("DCE_menuF10_SAR _B1 Exit no arg ")
		return
	end

	local arg_gpGid = arg[1]
	local arg_playerGroup = arg[2]

	env.info("DCE_menuF10_SAR C1 arg_gpGid " .. tostring(arg_gpGid) .. " arg_playerGroup: " .. tostring(arg_playerGroup))

	if arg_playerGroup and arg_playerGroup:isExist() then
	else
		env.info("DCE_menuF10_SAR D playerGroup not exist")
		return
	end

	-- local playerUnits = arg_playerGroup:getUnits()
	-- local playerUnit = playerUnits[1]

	local playerUnits = arg_playerGroup:getUnits()

    for _, playerUnit in ipairs(playerUnits) do
		env.info("DCE_menuF10_SAR E1")
		local uSAR_Player = playerUnit:getPlayerName()

		if uSAR_Player and PlayerInOutAircraft[uSAR_Player] then
			env.info("DCE_menuF10_SAR E2 uSAR_Player "..tostring(uSAR_Player))
			local playerVec3 = playerUnit:getPoint()
			local playerCoalId = playerUnit:getCoalition()
			local listEjectPil = {}

			missionCommands.removeItemForGroup(arg_gpGid, {"SAR"})
			missionCommands.removeItemForGroup(arg_gpGid, {"Activate beacon radios", "SAR"})
			missionCommands.removeItemForGroup(arg_gpGid, {"Turns off beacon radios", "SAR"})
			missionCommands.removeItemForGroup(arg_gpGid, {"Radio transmitting", "SAR"})

			missionCommands.addSubMenuForGroup(arg_gpGid, "SAR")

			local ejctedPilRadioON = missionCommands.addSubMenuForGroup(arg_gpGid, "Activate beacon radios", {"SAR"})
			local ejctedPilRadioOFF = missionCommands.addSubMenuForGroup(arg_gpGid, "Turns off beacon radios", {"SAR"})
			
			

			for MGRS_Chute, zone in pairs(ZoneSAR) do
				for pilotN, ejPilot in ipairs(zone) do
					local ejPilotObj = Unit.getByName(ejPilot.name)
					if not ejPilot.embarked and ejPilot.sideName == CoalitionIdToName[playerCoalId] and ejPilotObj and ejPilotObj:isExist()  then
						local ejPilotVec3 = ejPilotObj:getPoint()
						local distance = math.floor(math.sqrt(math.pow(ejPilotVec3.x - playerVec3.x, 2) + math.pow(ejPilotVec3.z - playerVec3.z, 2)))
						distance = math.ceil(distance / 1000)
						local tabTemp = {
							name = ejPilot.name,
							distance = distance,
							-- position = pilEjectVec3,
							posVec3 = ejPilotVec3,
							MGRS_Chute_10KM = ejPilot.MGRS_Chute_10KM,
							sideName = ejPilot.sideName,
							radio_on= ejPilot.radio_on,
							radioFreq= ejPilot.radioFreq,

						}
						table.insert(listEjectPil, tabTemp)
					end
				end
			end

			env.info("DCE_menuF10_SAR M nb EjectedPilot "..tostring(#listEjectPil))

			if listEjectPil and #listEjectPil >= 1 then
				table.sort(listEjectPil, function(a,b) return a.distance < b.distance  end)
				for n , ejectPil in ipairs(listEjectPil) do
					local txt = "..."
					if ejectPil.MGRS_Chute_10KM then
						txt = ejectPil.distance.." Km. "..ejectPil.MGRS_Chute_10KM.." |"..ejectPil.name
					else
						txt = ejectPil.distance.." Km. Activates radio beacon "..ejectPil.name
					end

					if ejectPil.radio_on and ejectPil.radioFreq then
						env.info("DCE_menuF10_SAR N ejectPil.radioFreq "..tostring(ejectPil.radioFreq).." for ejectPil.name "..tostring(ejectPil.name))
						missionCommands.addCommandForGroup(arg_gpGid, ejectPil.radioFreq.." Turn the Radio Off: "..ejectPil.name, ejctedPilRadioOFF, SAR_fct.StopRadioBeaconTransmission, ejectPil.name  )
						missionCommands.addSubMenuForGroup(arg_gpGid, ejectPil.radioFreq.." Radio On: "..ejectPil.name, {"SAR"})
					else
						env.info("DCE_menuF10_SAR O ejectPil.radioBeaconOff for ejectPil.name "..tostring(ejectPil.name))
						missionCommands.addCommandForGroup(arg_gpGid, txt, ejctedPilRadioON, SAR_fct.activateRadioBeacon, {arg_gpGid, ejectPil}  )
					end
					
					
				end
			end
		end
	end
	

	--TODO, A REMETTRE, enlever, modifier, bref a voir
	-- return timer.getTime() + 30
end





function BullsEye(playerGroup)

	-- ['coalition'] = {
			-- ['blue'] = {
				-- ['bullseye'] = {
					-- ['y'] = 635639.37385346,
					-- ['x'] = -317948.32727306,
				-- },
	local gpGid = playerGroup:getID()
	local playerUnits = playerGroup:getUnits()
	local playerUnit = playerUnits[1]

	local coalitionId = playerUnit:getCoalition()

	local sideT = {
		[0] = "neutral",
		[1] = "red",
		[2] = "blue"
		}

	local bullsEye_pos = {
			x = env.mission.coalition[sideT[coalitionId]].bullseye.x,
			y = 0,
			z = env.mission.coalition[sideT[coalitionId]].bullseye.y
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



function RtbPack(playerGroup)

	for _coalition, coalition in pairs(env.mission.coalition) do
		if _coalition == campL.playerSide then
			for Ncountry, _country in pairs(coalition.country) do
				if _country.plane then
					for Ngroup, _group in pairs(_country.plane.group) do
						if string.find(_group.name,"Pack "..campL.playerPackN) then

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
										local cntrl

										if n == 1 then
											cntrl = _group:getController()
										else
											cntrl = wingman[n]:getController()
										end

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


function RtbStrikePack(playerGroup)

	for _coalition, coalition in pairs(env.mission.coalition) do
		if _coalition == campL.playerSide then
			for Ncountry, _country in pairs(coalition.country) do
				if _country.plane then
					for Ngroup, _group in pairs(_country.plane.group) do
						if string.find(_group.name,"Pack "..campL.playerPackN) then

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


function RtbSEADPack(playerGroup)

	for _coalition, coalition in pairs(env.mission.coalition) do
		if _coalition == campL.playerSide then
			for Ncountry, _country in pairs(coalition.country) do
				if _country.plane then
					for Ngroup, _group in pairs(_country.plane.group) do
						if string.find(_group.name,"Pack "..campL.playerPackN) then

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


function EWR_ON(data)
    if not data or not data.playerName or not data.gid or not data.groupObject then
        return
    end

    if not EWR_optionPlayer then
        EWR_optionPlayer = {}
    end

    if not EWR_optionPlayer[data.playerName] then
        EWR_optionPlayer[data.playerName] = {}
    end

    EWR_optionPlayer[data.playerName].EWR_on = true

	local txt = tostring(data.playerName).. " switch EWR to ON"
	trigger.action.outTextForGroup(data.gid, txt, 10)
	
end

function EWR_OFF(data)
	if not data or not data.playerName or not data.gid or not data.groupObject then
		return
	end

	if not EWR_optionPlayer then
		EWR_optionPlayer = {}
	end

	if not EWR_optionPlayer[data.playerName] then
		EWR_optionPlayer[data.playerName] = {}
	end

    EWR_optionPlayer[data.playerName].EWR_on = false
	
	local txt = tostring(data.playerName) .. " switch EWR to OFF"
	trigger.action.outTextForGroup(data.gid, txt, 10)
end


function EWR_ON_OLD(playerName)
	if not EWR_optionPlayer[playerName] then
		EWR_optionPlayer[playerName] = {
			EWR_on = true,
		}
	else
		EWR_optionPlayer[playerName].EWR_on = true
	end
end

function EWR_OFF_OLD(playerName)
	if not EWR_optionPlayer[playerName] then
		EWR_optionPlayer[playerName] = {
			EWR_on = false,
		}
	else
		EWR_optionPlayer[playerName].EWR_on = false
	end
end





function ReFueling(playerGroup)

	local player = {
		["point"] = {}
	}

	local tanker = {
		["point"] = {},
		["name"] = "",
		["distance"] = 0,
		["gpName"] = ""
	}

	local playerUnits = playerGroup:getUnits()
	local playerUnit = playerUnits[1]
	local uid = playerUnit:getID()

	-- fichier miz:
		-- plan haut, droite, alti : x/y/z
	-- vue F10 et vector3d:
		-- plan haut, droite, alti : x/z/y

	local playerVec3 = playerUnit:getPoint()
			player.point.x = playerVec3.x
			player.point.y = playerVec3.z
			player.point.z = playerVec3.y
	local playerCoalitionId = playerUnit:getCoalition()
	local groups = coalition.getGroups(playerCoalitionId, Group.Category.AIRPLANE)
	local speed = playerUnit:getVelocity()
	player.speed = math.sqrt(speed.x^2 + speed.y^2 + speed.z^2)
	-- local groups = coalition.getGroups(coalition.side.BLUE, Group.Category.AIRPLANE)
	local selected_distance = 99999999

	for i, gp in pairs(groups) do
		local gpName = Group.getName(gp)
		if string.find(gpName,"Refueling") then
			local units = gp:getUnits()
			local _unit = units[1]
			local fuel = _unit:getFuel()
			local callsign = _unit:getCallsign()
			local tankerTypeName = _unit:getTypeName()
			local t = {
						["point"] = {}
						}

			local unitVec3 = _unit:getPoint()
					t.point.x = unitVec3.x
					t.point.y = unitVec3.z
					t.point.z = unitVec3.y

			local description = _unit:getDesc()

			if (description.attributes.Refuelable or description.attributes.Tankers ) and _unit:isActive() then
			-- if _unit:getTypeName() == "S-3B Tanker" and _unit:isActive() then			
			-- if _unit:getTypeName() == "S-3B Tanker"  and t.point.z > 100 and _unit:isActive() then			

				local tempDistance = math.sqrt(math.pow(t.point.x - player.point.x, 2) + math.pow(t.point.y - player.point.y, 2))		--distance between tanker and player
				if tempDistance < selected_distance then
					tanker.point = t.point
					tanker.TypeName = tankerTypeName
					tanker.distance = tempDistance
					tanker.gpName = tostring(gpName)
					tanker.ctr = Group.getController(gp)
					tanker.callsign = callsign
					tanker._unit = _unit
					tanker.Desc = _unit:getDesc()
					selected_distance =  tempDistance
				end
			end
		end
	end

	local heading  = GetHeading(tanker.point, player.point)		--return heading between two vector2 points
	local dist = tanker.distance / 2
	local interceptPos = GetOffsetPoint(tanker.point, heading, dist)		--function to return a new point offset from an initial point
	local interceptAlt = player.point.z
	local pattern_alt = player.point.z
	local pattern_speed = player.speed

	if interceptAlt < 1000 and dist > 50000 then
		interceptAlt = 3000
	elseif interceptAlt > 6100  then										-- alti max:6100
		interceptAlt = 6100
		pattern_alt = 6100
	end

	if pattern_speed < 130  then
		pattern_speed = 130
	elseif pattern_speed > 200  then											-- vi max:6100
		pattern_speed = 200
	end

	local infoSpeed = math.floor(pattern_speed / 0.51444444444)					-- m/s to Kts
	local infoAlti = math.floor((pattern_alt * 3.2808398950131 )/100)*100		-- m to ft	
	local interceptPosVec3 = {
					x = interceptPos.x,
					y = pattern_alt,
					z = interceptPos.y
					}

	local intercept_LL =  coord.LOtoLL(interceptPosVec3)

	LLposNstring, LLposEstring = LLtool.LLstrings(interceptPosVec3)
	trigger.action.outText(tanker.callsign.." "..tanker.gpName.." Rdv: "..'N ' .. LLposNstring .. '   E ' .. LLposEstring.." Alt: "..infoAlti.." Speed "..infoSpeed, 20)

		local Mission = {														--define mission for interceptor group
			id = 'Mission',
			params = {
				route = {
					["points"] = {
						[1] = {
							["alt"] = interceptAlt,
							["type"] = "Turning Point",
							["action"] = "Turning Point",
							["alt_type"] = "BARO",
							["formation_template"] = "",
							["y"] = interceptPos.y ,
							["x"] = interceptPos.x ,
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

function RequestCAP(playerGroup)
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

	local playerUnits = playerGroup:getUnits()
	local playerUnit = playerUnits[1]
	local uid = playerUnit:getID()

	-- fichier miz:
		-- plan haut, droite, alti : x/y/z
	-- vue F10 et vector3d:
		-- plan haut, droite, alti : x/z/y

	local playerVec3 = playerUnit:getPoint()
			player.point.x = playerVec3.x
			player.point.y = playerVec3.z
			player.point.z = playerVec3.y

	local playerCoalitionId = playerUnit:getCoalition()
	local groups = coalition.getGroups(playerCoalitionId, Group.Category.AIRPLANE)
	local speed = playerUnit:getVelocity()
	player.speed = math.sqrt(speed.x^2 + speed.y^2 + speed.z^2)

	-- local groups = coalition.getGroups(coalition.side.BLUE, Group.Category.AIRPLANE)
	local selected_distance = 99999999

	for i, gp in pairs(groups) do

		local gpName = Group.getName(gp)

		if string.find(gpName,"CAP") then
			local units = gp:getUnits()
			local _unit = units[1]
			local fuel = _unit:getFuel()
			local callsign = _unit:getCallsign()
			local TankerTypeName = _unit:getTypeName()
			local t = {
						["point"] = {}
						}

			local unitVec3 = _unit:getPoint()
					t.point.x = unitVec3.x
					t.point.y = unitVec3.z
					t.point.z = unitVec3.y

			if _unit:isActive() then
			-- if _unit:getTypeName() == "S-3B Tanker"  and t.point.z > 100 and _unit:isActive() then			

				local tempDistance = math.sqrt(math.pow(t.point.x - player.point.x, 2) + math.pow(t.point.y - player.point.y, 2))		--distance between tanker and player

				if tempDistance < selected_distance then

					CAP.point = t.point
					CAP.TypeName = TankerTypeName
					CAP.distance = tempDistance
					CAP.gpName = tostring(gpName)
					CAP.ctr = Group.getController(gp)
					CAP.callsign = callsign
					CAP._unit = _unit
					CAP.Desc = _unit:getDesc()
					selected_distance =  tempDistance

				end
			end
		end
	end


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

	local arg_groupObj = arg[1]
	local arg_playerName = arg[2]

	local wingman = arg_groupObj:getUnits()
	local playerName
	local playerObj
	local playerId

	for w = 1, #wingman do
		playerName = wingman[w]:getPlayerName()

		if playerName == arg_playerName then
			playerObj = wingman[w]
			playerId = Unit.getID(playerObj)

			env.info( "DCE_getOut B Attempted emergency evacuation of the aircraft ")
			trigger.action.outTextForUnit(playerId, "Attempted emergency evacuation of the aircraft ", 15)

			GetOutGDFM({playerName, playerObj, playerId})
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

	if campL.targetPos then
		-- trigger.action.outText("DCE_getLL_TargetPosition START ", 15)
		for key_x, searchPos_s in pairs(campL.targetPos) do
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

	--export custom mission log
	local logStr = "Mission_LL_Positions = " .. TableSerialization(campL.targetPos, 0)
	local logFile = io.open(PathDCE .. "Mission_LL_Positions.lua", "w")
    if logFile then
        logFile:write(logStr)
        logFile:close()
    else
		env.info("DCE_Mission_LL_Positions: Failed to open log file for writing.")
    end

    campL.targetPos = nil
	collectgarbage("step", 200) -- on force la libération
	
end



addFuncs = function(gId, gObj, playerName)

	env.info("DCE_addFuncs _A gid "..tostring(gId).." Group "..tostring(gObj).." argPlayerName: "..tostring(playerName))

	--si aucun argument, on s'appui sur la liste des joueurs fait maison
	if not gId or not gObj then
		for pName, playerData in pairs(PlayerInOutAircraft or {}) do
			if playerData
				and playerData.gid
				and playerData.groupObject then
				addFuncs(playerData.gid, playerData.groupObject, pName)
			end
		end
		return -- IMPORTANT
	end

	if gId and gObj then

		if not EWR_optionPlayer[playerName] then
			EWR_optionPlayer[playerName] = {
				EWR_on = false,
			}
		end

		-- supprime les anciens items de la commande F10**************************************

		-- missionCommands.removeItemForGroup(arg_gpGid, { "SAR" })
		-- missionCommands.removeItemForGroup(arg_gpGid, { "Activate beacon radios", "SAR" })
		-- missionCommands.removeItemForGroup(arg_gpGid, { "Turns off beacon radios", "SAR" })
		-- missionCommands.removeItemForGroup(arg_gpGid, { "Radio transmitting", "SAR" })

		-- missionCommands.addSubMenuForGroup(arg_gpGid, "SAR")

		-- local ejctedPilRadioON = missionCommands.addSubMenuForGroup(arg_gpGid, "Activate beacon radios", { "SAR" })
		-- local ejctedPilRadioOFF = missionCommands.addSubMenuForGroup(arg_gpGid, "Turns off beacon radios", { "SAR" })

		missionCommands.removeItemForGroup(gId, {"Fuel Check"})
		missionCommands.removeItemForGroup(gId, {"Urgent request"})
		missionCommands.removeItemForGroup(gId, {"BullsEye_LongLat"})
		-- missionCommands.removeItemForGroup(arg_Gid, {"EWR"})
		missionCommands.removeItemForGroup(gId, {"Get out of the cockpit"})
		missionCommands.removeItemForGroup(gId, {"CarrierIntoWind"})
		
        -- Suppression propre via handle
		--"EWR"
		if EWR_menuRootByGroup[gId] then
			missionCommands.removeItemForGroup(gId, EWR_menuRootByGroup[gId])
			EWR_menuRootByGroup[gId] = nil
		end

		-- "SAR"
        if MenuF10ByGroupByCmd[gId] then
			if MenuF10ByGroupByCmd[gId]["SAR"] then
				missionCommands.removeItemForGroup(gId, MenuF10ByGroupByCmd[gId]["SAR"])
			end
		end



		-- ajoute les nouvelles commandes F10 **************************************
		missionCommands.addCommandForGroup(gId, "Fuel Check", nil, FuelCheck, {gid = gId, groupObject = gObj })

		local subR_A = missionCommands.addSubMenuForGroup(gId, "Urgent request", nil)

		radioCommands[#radioCommands + 1] = missionCommands.addCommandForGroup(gId, "Urgent_Refueling", subR_A, ReFueling, gObj )
		radioCommands[#radioCommands + 1] = missionCommands.addCommandForGroup(gId, "Urgent_RequestCAP", subR_A, RequestCAP, gObj)
		radioCommands[#radioCommands + 1] = missionCommands.addCommandForGroup(gId, "Package_All_RTB", subR_A, RtbPack, gObj)
		radioCommands[#radioCommands + 1] = missionCommands.addCommandForGroup(gId, "Package_Strike_RTB", subR_A, RtbStrikePack, gObj)
		radioCommands[#radioCommands + 1] = missionCommands.addCommandForGroup(gId, "Package_SEAD_RTB", subR_A, RtbSEADPack, gObj)


		radioCommands[#radioCommands + 1] = missionCommands.addCommandForGroup(gId, "BullsEye_LongLat", nil, BullsEye, gObj)

		local subR_B1 = missionCommands.addSubMenuForGroup(gId, "EWR", nil)
		EWR_menuRootByGroup[gId] = subR_B1
		local subR_B2 = missionCommands.addSubMenuForGroup(gId, "EWR ON", subR_B1)
		local subR_B3 = missionCommands.addSubMenuForGroup(gId, "EWR OFF", subR_B1)

		-- missionCommands.addCommandForGroup( gId, playerName, subR_B2, EWR_ON, { playerName = playerName, gid = gId, groupObject = gObj } )
		-- missionCommands.addCommandForGroup( gId, playerName, subR_B3, EWR_OFF, { playerName = playerName, gid = gId, groupObject = gObj } )
        -- for playersName, value in pairs(EWR_optionPlayer) do
        --     missionCommands.addCommandForGroup(gId, tostring(playersName) .. " EWR ON", subR_B2, EWR_ON,
        --         { playersName = playerName, gid = gId, groupObject = gObj })
        --     missionCommands.addCommandForGroup(gId, tostring(playersName) .. " EWR OFF", subR_B3, EWR_OFF,
        --         { playersName = playerName, gid = gId, groupObject = gObj })
        -- end
		local wingmans = gObj:getUnits()
		for playersName, unitObj in ipairs(wingmans) do
			missionCommands.addCommandForGroup(gId, tostring(playersName) .. " EWR ON", subR_B2, EWR_ON,
				{ playersName = playerName, gid = gId, groupObject = gObj })
			missionCommands.addCommandForGroup(gId, tostring(playersName) .. " EWR OFF", subR_B3, EWR_OFF,
				{ playersName = playerName, gid = gId, groupObject = gObj })
		end

		MenuF10ByGroupByCmd[gId] = MenuF10ByGroupByCmd[gId] or {}
		--trouve ici le camp, la coalition du joueur, a partir de son gId ou gObj ou playerName
		
		local unitsObj = gObj:getUnits()
		local sideName = CoalitionIdToName[unitsObj[1]:getCoalition()] or "blue"
		local freqence = campL.EjectedPilotFrequency[sideName].radioBeacon or 0
		MenuF10ByGroupByCmd[gId]["SAR"] = missionCommands.addCommandForGroup(gId, "CSAR: Request Survivor Beep "..tostring(freqence), nil, SAR_fct.menuF10_SAR, {gId, gObj} )

		
		-- radioCommands[#radioCommands + 1] = missionCommands.addCommandForGroup(gid, "Get out of the cockpit", subR_A, getOut, gid)
		local subR_C1 = missionCommands.addSubMenuForGroup(gId, "Get out of the cockpit", subR_A)
		-- for pName, value in pairs(EWR_optionPlayer) do
		-- 	radioCommands[#radioCommands + 1] = missionCommands.addCommandForGroup(gId, tostring(pName) .." Get out", subR_C1, getOut, {gObj ,pName} )
        -- end
		for playersName, unitObj in ipairs(wingmans) do
			missionCommands.addCommandForGroup(gId, tostring(playersName) .. " Get out", subR_C1, getOut, { gObj, playersName })
		end

		if campL.SC_CarrierIntoWind == "man" then
			missionCommands.removeItemForGroup(gId, {"CarrierIntoWind"})
			local subR = missionCommands.addSubMenuForGroup(gId, "CarrierIntoWind", nil)

            if campL.Aircraft_Carriers then
				--TODO ajouter une condition side
                for sideCarrier, carriers in ipairs(campL.Aircraft_Carriers) do
                    for group_n, carrier in ipairs(carriers) do
                        local carrierGroup = Group.getByName(carrier.name)
                        if carrierGroup then 
                           
							radioCommands[#radioCommands + 1] = missionCommands.addCommandForGroup(gId, carrier.name.." Into Wind 30mn", subR, TurnIntoWind, {carrier.name, nil, nil, 30} )
							radioCommands[#radioCommands + 1] = missionCommands.addCommandForGroup(gId, carrier.name.." Into Wind 60mn", subR, TurnIntoWind, {carrier.name, nil, nil, 60} )
							radioCommands[#radioCommands + 1] = missionCommands.addCommandForGroup(gId, carrier.name.." Resume Route", subR, ResumeRoute, {carrier.name, nil} )
                        end
                    end
                end
            end
			
		end

		-- -- sar_F10(Group)
		-- timer.scheduleFunction(SAR_fct.menuF10_SAR, {arg_Gid, arg_GroupObj}, timer.getTime() + 5)

		-- -- AFAC_F10(Group)
		-- timer.scheduleFunction(AFAC_F10, groupObject, timer.getTime() + 2)


		-- The solution is to use env.mission.coalition where you find all object informations even groupId
		-- https://forums.eagle.ru/showthread.php?t=147792&page=15

		 -- commandDB['RUR'] = missionCommands.addCommandForGroup(gid,"UrgentRefueling", nil, ReFueling, Group)
		 -- commandDB['speed'] = missionCommands.addCommandForGroup(gid,"Testing", nil, Test, Group)
		 -- commandDB['RTB'] = missionCommands.addCommandForGroup(gid,"Package_RTB", nil, RtbPack, Group)

		 if campL.debug then
			local timeSearchEngage = timer.getTime()
			local logStr = "radioCommands = " .. TableSerialization(radioCommands, 0)
			local flightNameClean = "radioCommands"
			local logFile = io.open(PathDCE.."Debug\\"..flightNameClean.."_"..timeSearchEngage.."_".. "_radioCommands.lua", "w")
			if logFile then
				logFile:write(logStr)
				logFile:close()
			else
				env.info("DCE_addFuncs: Failed to open log file for writing.")
			end
		 end

	end
end



--////////////////////////////////////////////////////////////////////////////////////////////
--test EWR (start)
--recupere les data de tous les aéronefs
--////////////////////////////////////////////////////////////////////////////////////////////
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

								if string.find(string.lower(groupName), "escort") then
									passEscort = true


									--TODO a supprimer une fois les tests finitos
									if campL.debug then
										EWR_ON(flightName)
									end
								end

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




--sur certaines map en solo (Syria) l'evenement Birth n'est pas detectée
local function timerPlayerMenu(arg)
	if (radioCommands == nil or #radioCommands == 0) and timer.getTime() < 10 then
		local Uid, groupObject, gpGid, playerName
		local playerObj = localGetPlayerObj()
		if playerObj then
			playerName = playerObj:getPlayerName()
			groupObject = playerObj:getGroup()
			gpGid = playerObj:getGroup():getID()
		end

		if gpGid and Group and playerName then
			 
			env.info("DCE_timerPlayerMenu: MAKE addFuncs().")
			addFuncs(gpGid, groupObject, playerName)
		end
	end
end




local function loopAFAC_CAS()

	local t0
	if campL.debug then
		t0 = os.clock()
		Perf_F_N = Perf_F_N + 1
	end
		
    if next(AFAC_available) == nil then
		if campL.debug then
			local dt = os.clock() - t0
			Perf_F = Perf_F + dt
		end
        return timer.getTime() + 17
			
	end

	for _, sideNum in ipairs({coalition.side.BLUE, coalition.side.RED}) do

		local groups = coalition.getGroups(sideNum, Group.Category.AIRPLANE)

		for _, gp in pairs(groups) do
			local gpName = Group.getName(gp)
			if string.find(gpName,"Strike") then
				local strikers = gp:getUnits()
				for wingmanN, unitStriker in ipairs(strikers) do
					for afacFlightName, afacData in pairs(AFAC_available) do
						if sideNum == afacData.sideNum then
							if afacData.smokeData and timer.getTime() > (afacData.smokeData.time + 300) then
								local afacGroupObj = Group.getByName(afacFlightName)
								if afacGroupObj then
									local unitsAFAC = afacGroupObj:getUnits()
									local unitAFAC = unitsAFAC[1]

									if unitAFAC and unitAFAC:isExist() then
										local afacVec3 = unitAFAC:getPoint()
										local unitStrikerVec3 = unitStriker:getPoint()
										local distance = math.sqrt((afacVec3.x - unitStrikerVec3.x)^2 + (afacVec3.z - unitStrikerVec3.z)^2)

										if distance <= 10000 then
											trigger.action.smoke(afacData.smokeData.targetPosVec3, SmokeColor_TargetDesignation)
											AFAC_available[afacFlightName]["smokeData"] = {
												time = timer.getTime(),
												targetPosVec3 = afacData.smokeData.targetPosVec3,
												sideNum = sideNum,
											}
										end
									end
								end

                            else
								
							end
						end
					end
				end
			end
		end
	end
	if campL.debug then
		local dt = os.clock() - t0
		Perf_F = Perf_F + dt
	end
	return timer.getTime() + 17
end




local function loopAFAC()

	local groupObject, gpGid
	local playerObj = localGetPlayerObj()
	if playerObj then
		groupObject = playerObj:getGroup()
		-- gpGid = playerObj:getGroup():getID()
	end

	if gpGid and groupObject then
		-- AFAC_F10(Group)
		timer.scheduleFunction(AFAC_F10, groupObject, timer.getTime() + 2)
	end
	return timer.getTime() + 61
end


--uniquement pour le Bingo?
local function loopPilot()

	local groups = coalition.getGroups(coalition.side.BLUE, Group.Category.AIRPLANE)

	for n=1, 5 do
		for _, gp in pairs(groups) do
			local gpGid = Group.getID(gp)
			if gpGid and gp then
				bingo(gpGid, gp)
			end
		end
	end

	groups = coalition.getGroups(coalition.side.RED, Group.Category.AIRPLANE)

	for _, gp in pairs(groups) do
		local gpGid = Group.getID(gp)
		if gpGid and gp then
			bingo(gpGid, gp)
		end
	end

	if campL.TableTransportPilotNames and ctld and ctld.alreadyInitialized and not var_TPN_alreadyAdded then
		for n=1, #campL.TableTransportPilotNames do
			ctld.transportPilotNames[#ctld.transportPilotNames +1 ] = campL.TableTransportPilotNames[n]
		end
		env.info( "AdCR10 add  ctld.transportPilotNames ")
		var_TPN_alreadyAdded = true
	end


    return timer.getTime() + 120
	-- return timer.getTime() + 10

end

local function testPerf()

	local groups = coalition.getGroups(coalition.side.BLUE, Group.Category.AIRPLANE)
    
    for _, gp in pairs(groups) do
        local gpGid = Group.getID(gp)
        if gpGid and gp then
            bingo(gpGid, gp)
        end
    end
	
end


local benchState = {}



-- Fait un round, puis se reprogramme
local function benchStep()
	env.info("DCE_Bench:A step nIndex=" .. tostring(benchState.nIndex))
	local n = benchState.nList[benchState.nIndex]

	-- local t0 = timer.getTime()
	local t0 = os.clock()

	env.info("DCE_Bench:B  n=" .. tostring(n) .. " rounds=" .. tostring(benchState.rounds))
	for r = 1, benchState.rounds do
		for i = 1, n do
			testPerf()
		end
	end

    env.info("DCE_Bench:C  step done, measuring time...")
	
	-- local t1 = timer.getTime()
	local t1 = os.clock()
	local dt = (t1 - t0) / benchState.rounds

	env.info(string.format("DCE_Bench:DCS_CategoryById n=%d dt=%.4f", n, dt))

	benchState.nIndex = benchState.nIndex + 1
	if benchState.nIndex > #benchState.nList then
		env.info("DCE_Bench:E terminé")
		return
	end

	return timer.getTime() + 0.1 -- on laisse respirer DCS entre deux tailles
end

-- Lance le benchmark
local function benchStart(nList, rounds)
	env.info("DCE_Bench: démarrage")
	benchState.nList = nList
	benchState.rounds = rounds
	benchState.nIndex = 1

	timer.scheduleFunction(benchStep, nil, timer.getTime() + 0.1)
end

local function benchDrive()
	benchStart({ 100, 500, 1000, 2000 }, 3)
	-- benchStart({ 100, 500, 1000 }, 10)
end

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


-- if campL.debug then
-- 	local logStr = "hotSpotAirDefense = " .. TableSerialization(hotSpotAirDefense, 0)
-- 	local logFile = io.open(PathDCE.."Debug\\".."hotSpotAirDefense.lua", "w")
-- 	if logFile then
-- 		logFile:write(logStr)
-- 		logFile:close()
-- 	else
-- 		env.info("DCE_hotSpotAirDefense: Failed to open log file for writing.")
-- 	end
-- end



-- timer.scheduleFunction(BuildMissionGroupIndex, nil, timer.getTime() + 0.01)
-- timer.scheduleFunction(BuildMissionGroupRoute, nil, timer.getTime() + 0.02)
timer.scheduleFunction(buildMissionIndex, nil, timer.getTime() + 0.02)
timer.scheduleFunction(hotSpotSAM, nil, timer.getTime() + 0.03) --creation de la table de couverture anti aérienne AMI
timer.scheduleFunction(BuildCarrierIndex, nil, timer.getTime() + 0.04)


timer.scheduleFunction(timerPlayerMenu, nil, timer.getTime() + 5)

--/////////////////////////bench
if campL.debug then --ça, ça ne marche pas
	timer.scheduleFunction(showPerformance, nil, timer.getTime() + 30)
end

--/////////////////////////bench

timer.scheduleFunction(loopPilot, nil, timer.getTime() + 15)--+15

timer.scheduleFunction(loopAFAC, nil, timer.getTime() + 61)

timer.scheduleFunction(loopAFAC_CAS, nil, timer.getTime() + 63)

timer.scheduleFunction(airRetreat, nil, timer.getTime() + 6)

timer.scheduleFunction(avoidArea, nil, timer.getTime() + 7)

timer.scheduleFunction(getLL_TargetPosition, nil, timer.getTime() + 21)

timer.scheduleFunction(EWR_magic, nil, timer.getTime() + 31)

timer.scheduleFunction(setErrorMessageBoxShedul, nil, timer.getTime() + 32)

-- --test pour exploser les unités detecté, afin de passer au suivant
-- local function explodeOnPoint()
-- 	for target_UnitId, target in pairs(AFAC_targetStatus) do
-- 		-- _affiche(target.unitPos, "DCE_explodeOnPoint target.unitPos ")
-- 		trigger.action.explosion(target.unitPos, 100)
-- 	end
-- 	return timer.getTime() + 300
-- end
-- timer.scheduleFunction(explodeOnPoint, nil, timer.getTime() + 300)



--  **Planification initiale après collecte des unités et statiques** 
-- if useBubble_DisableEnable_Group then
-- 	timer.scheduleFunction(DCE_BulleBy_DE, nil, timer.getTime() + 20) -- start après 5 sec
-- end
--////////////////////////////////////////////////////////////////////////////////////////////
--test BULLE (fin) IV
--avec distance avion
--////////////////////////////////////////////////////////////////////////////////////////////

_affiche(AI.Option.Air.val, "AI.Option.Air.val ")

_affiche(DCS_CategoryById, "DCE_DCS_CategoryById ")

_affiche(Object.Category, "Object.Category ")

-- for k, v in pairs(AI.Option.Air.val) do
--     env.info(k .. " = " .. tostring(v))
-- end


env.info("DCE_ACRF10 END OF LOADING AdCR10 script ")
