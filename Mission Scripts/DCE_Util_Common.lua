-- DCE_Util_Common
-- Fonctions utilitaires génériques (géométrie, tables, strings) utilisées par plusieurs
-- scripts du dossier Mission Scripts (CustomTasksScript, EventsTracker, GCIscript,
-- CarrierIntoWindScript, SAR, CG_ArtySpotter, AirGroundAttackScript, Pedro,
-- ARM_Defence_Script, bombOnRunway, AddCommandRadioF10...).
-- Doit être chargé AVANT ces fichiers (voir addFileTrigger dans MAIN_NextMission.lua).
-------------------------------------------------------------------------------------------------------
-- Extrait de AddCommandRadioF10.lua le 19/09/2026 (Chantier A - réorganisation DCE InGame) :
-- ces fonctions n'ont aucun rapport avec les menus radio F10, elles avaient juste fini
-- par atterrir dans ce fichier au fil du temps. Code repris tel quel, aucune logique modifiée.
-------------------------------------------------------------------------------------------------------
if not versionDCE then versionDCE = {} end
versionDCE["Mission Scripts/DCE_Util_Common.lua"] = "1.0.0"
-------------------------------------------------------------------------------------------------------

env.info("DCE START LOADING DCE_Util_Common.lua "..tostring(versionDCE["Mission Scripts/DCE_Util_Common.lua"]))


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
function GetDistance(a, b)
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
