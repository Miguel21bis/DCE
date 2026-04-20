--Various functions
------------------------------------------------------------------------------------------------------- 
if not versionDCE then versionDCE = {} end
versionDCE["UTIL_Functions.lua"] = "2.20.139"
------------------------------------------------------------------------------------------------------- 

if Debug.debug then
	print("START UTIL_Functions.lua "..versionDCE["UTIL_Functions.lua"].." =-=-=-=-=-=-=-=-=-=-=-=-=-=-=")
end


T_GetTD  = 0
T_GetD = 0

--local variable

--variable camp global
if not camp.AuthorizedLoadout then
	camp.AuthorizedLoadout = {}
end

--variable global
NameTheatreLower = ""
NameTheatre  = ""
AllIdGroup = {}
AllIdUnit = {}
UnitByName = {}						-- table de tous les unitId généré, utile pour placer le TACAN sur l'unitId qui est demandé avant la génération du l'unité
Assigned_freq = {}
MinPercentDestroyed = 95		----variable pour destructions batiment de DCS en pourcentage
RayonDamaged = 50				----variable pour destructions batiment de DCS en metres
RosterJumpTempPercent = 0.25			-- suite à un saut temporel, enleve une partie des presents pour éviter un effectif neuf comme un démarrage de DCE
WingmenPlayer = false			-- si true, les wingmen playable sont proposé aux joueurs
LoadoutsList = {}				-- construit la table loadout en fonction du loadout général et de la campagne
EPLRS_Capacity = {}
AircraftInCampaign = {}				-- liste de tous les types d'avions utilisés dans la campagne
AircraftCampaignBySide = {
	["red"] = {},
	["blue"] = {},
}
HelicoBySide= {
	["red"] = {},
	["blue"] = {},
}
PlaneBySide= {
	["red"] = {},
	["blue"] = {},
}

MODULATION_AM = "AM"
MODULATION_AM_AND_FM = "AM/FM"
MODULATION_FM = "FM"
RadioPlayerWaveRanges = {}

AssignedTargetFrequency = {
	["blue"] = {},
	["red"] = {},
}

RADIO_WAVES = {
	HF =       { min =   3.0, max =  30.0 },
	LVHF =   { min =  30.0, max =  88.0 },
	VHF =   { min = 108.0, max = 174.0 },
	UHF =      { min = 225.0, max = 400.0 },
}

Brief = {
	red = {},
	blue = {},
}

-- par défaut, on assigne une valeur superieur au camp du joueur, qu'il soit rouge ou bleu.
SkillWish = {
	["red"] = 50,
	["blue"] = 50,
}

DCS_Side = {"blue", "red", "neutrals"}

DCS_ENI_Side = {
	["blue"] = "red",
	["red"] = "blue"
	}

	-- airbase = { 25, 12, 20, 15, 0 },
	-- runWay = { 25, 12, 20, 15, 0 },
	-- SAM = { 25, 12, 20, 15, 0 },
	-- EWR = { 25, 12, 20, 15, 0 },
	-- bridge = { 25, 12, 20, 15, 0 },
	-- generic = { 25, 12, 20, 15, 0 },

Attribut2Target = {
	["airbase"] = "airbase",
	["base"] = "airbase",
	["Runway"] = "runway",
	["sam"] = "sam",
	["ewr"] = "ewr",
	["bridge"] = "bridge",
}

-- Package_freq = {															--table to store frequencies assigned to packages
-- 	["blue"] = {
-- 		["UHF"] = {},
-- 		["VHF"] = {},
-- 		["LVHF"] = {},
-- 		["HF"] = {},
-- 	},
-- 	["red"] = {
-- 		["UHF"] = {},
-- 		["VHF"] = {},
-- 		["LVHF"] = {},
-- 		["HF"] = {},
-- 	},
-- }


local idGroupCounter = 3000
local idUnitCounter = 3000

if not _ then
	function _(text)
		return text
	end
end

--function to return txt whith carriage return
function StringToTxt(text)
	text = string.gsub(text, "\\n", "\n")
	return text
end

--function to return txt whith carriage return for Sratchpad
-- modification M41
function StringToTxtBrief(text)
	if type(text) == "string" then
		text = string.gsub(text, "\\n", " \\\n")
		return text
	else
		return  text
	end
end

--//####################### file function:
function FileExists(path)
	local file = io.open(path, "r")
	if file then
		file:close()
		return true
	else
		return false
	end
end


--function to sort tables alphabetically, to be used in a "for" loop instead of pairs or ipairs
-- Fonction pour trier les clés numériques dans l'ordre croissant
function PairsByKeys(t, f)
    local numericKeys = {}
    local otherKeys = {}
    local initType

    -- Séparer les clés numériques des autres
    for n in pairs(t) do
        initType = type(n)
        if initType == "number" then
            table.insert(numericKeys, n)
        else
            table.insert(otherKeys, n)
        end
    end

    -- Trier les clés numériques
    table.sort(numericKeys, f)

    -- Concaténer les clés non numériques (non triées)
    for _, key in ipairs(otherKeys) do
        table.insert(numericKeys, key)
    end

    local i = 0 -- Variable d'itération
    local iter = function() -- Fonction d'itération
        i = i + 1
        if numericKeys[i] == nil then
            return nil
        else
            return numericKeys[i], t[numericKeys[i]]
        end
    end
    return iter
end

--function to turn a table into a string
function TableSerializationAG(t, i)

	local text = "{\n"
	local tab = ""
	for n = 1, i + 1 do																	--controls the indent for the current text line
		tab = tab .. "\t"
	end
	for k,v in pairs(t) do
		if type(k) == "string" then
			text = text .. tab .. "['" .. k .. "'] = "
		else
			text = text .. tab .. "[" .. k .. "] = "
		end
		if type(v) == "string" then
			text = text .. "'" .. v .. "',\n"
		elseif type(v) == "number" then
			text = text .. v .. ",\n"
		elseif type(v) == "table" then
			text = text .. TableSerializationAG(v, i + 1)
		elseif type(v) == "boolean" then
			if v == true then
				text = text .. "true,\n"
			else
				text = text .. "false,\n"
			end
		elseif type(v) == "function" then
			text = text .. v .. ",\n"
		elseif v == nil then
			text = text .. "nil,\n"
		end
	end
	tab = ""
	for n = 1, i do																		--indent for closing bracket is one less then previous text line
		tab = tab .. "\t"
	end
	if i == 0 then
		text = text .. tab .. "}\n"														--the last bracket should not be followed by an comma
	else
		text = text .. tab .. "},\n"													--all brackets with indent higher than 0 are followed by a comma
	end
	return text
end

-- Fonction pour vérifier si une table est strictement numérique
local function IsSequentialTable(t)
    local count = 0
    for k, _ in pairs(t) do
        if type(k) ~= "number" or k ~= math.floor(k) then
            return false
        end
        count = count + 1
    end
    return count == #t -- Vérifie qu'il n'y a pas de "trous" dans les indices
end


-- Fonction : sérialise une table Lua en texte exploitable par DCS
-- Pourquoi : optimisation massive des performances (buffer, suppression du tri des clés, cache indentation)
-- Où : remplace intégralement l'ancienne fonction TableSerialization

local indentcache = {}	-- cache d'indentation partagé (évite string.rep coûteux)

function TableSerialization(t, i, options)

	-- Gestion des options
	-- Pourquoi : conserver le comportement existant sans casser les appels actuels
	local writenumerictable = options
	if type(options) == "table" then
		writenumerictable = options.writeNumericTable
	elseif options == nil then
		writenumerictable = true
	end

	-- Buffer de sortie
	-- Pourquoi : éviter les concaténations de strings (gain majeur de performance)
	local buffer = {}
	local bufferindex = 1

	-- Fonction locale : retourne une indentation mise en cache
	-- Pourquoi : éviter string.rep à chaque appel récursif
	local function getindent(n)
		local s = indentcache[n]
		if not s then
			s = string.rep("\t", n)
			indentcache[n] = s
		end
		return s
	end

	local tab1 = getindent(i)
	local tab  = getindent(i + 1)

	buffer[bufferindex] = "\n" .. tab1 .. "{\n"
	bufferindex = bufferindex + 1

	-- Cas des tables séquentielles sans affichage des indices
	if not writenumerictable and IsSequentialTable(t) then
		for _, v in ipairs(t) do
			if type(v) == "table" then
				buffer[bufferindex] = tab .. TableSerialization(v, i + 1, writenumerictable) .. ",\n"
				bufferindex = bufferindex + 1

			elseif type(v) == "string" then
				if v:find("\n", 1, true) then
					v = v:gsub("\n", "\\\n")
				end
				if v:find('"', 1, true) then
					v = v:gsub('"', '\\"')
				end
				buffer[bufferindex] = tab .. '"' .. v .. '",\n'
				bufferindex = bufferindex + 1

			elseif type(v) == "number" or type(v) == "boolean" then
				buffer[bufferindex] = tab .. tostring(v) .. ",\n"
				bufferindex = bufferindex + 1

			elseif v == nil then
				buffer[bufferindex] = tab .. "nil,\n"
				bufferindex = bufferindex + 1
			end
		end

	else
		-- Cas général : table avec clés
		-- Pourquoi : utilisation de pairs() (suppression du tri PairsByKeys → gain massif)
		for k, v in pairs(t) do
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

			if type(v) == "table" then
				buffer[bufferindex] = TableSerialization(v, i + 1, writenumerictable) .. ",\n"
				bufferindex = bufferindex + 1

			elseif type(v) == "string" then
				if v:find("\n", 1, true) then
					v = v:gsub("\n", "\\\n")
				end
				if v:find('"', 1, true) then
					v = v:gsub('"', '\\"')
				end
				buffer[bufferindex] = '"' .. v .. '",\n'
				bufferindex = bufferindex + 1

			elseif type(v) == "number" or type(v) == "boolean" then
				buffer[bufferindex] = tostring(v) .. ",\n"
				bufferindex = bufferindex + 1

			elseif v == nil then
				buffer[bufferindex] = "nil,\n"
				bufferindex = bufferindex + 1
			end
		end
	end

	buffer[bufferindex] = tab1 .. "}"
	return table.concat(buffer)
end


-- Fonction pour sérialiser une table en chaîne
-- Fonction pour sérialiser une table en chaîne avec une option pour afficher les indices des tables séquentielles
-- function TableSerialization(t, i, options)
-- 	-- Si options est un booléen, on le traite comme la valeur de writeNumericTable
-- 	local writeNumericTable = options
-- 	if type(options) == "table" then
-- 		writeNumericTable = options.writeNumericTable
-- 	elseif options == nil then
-- 		writeNumericTable = true -- Valeur par défaut si options n'est pas fourni
-- 	end

--     local crlf = ""
--     local tab1 = string.rep("\t", i) -- Indentation
--     local text = "\n" .. crlf .. tab1 .. "{\n" .. crlf

--     local tab = string.rep("\t", i + 1)

--     if not writeNumericTable and IsSequentialTable(t) then
--         -- Si la table est strictement numérique et numericTable est false, on n'affiche pas les indices
--         for _, v in ipairs(t) do
--             if type(v) == "table" then
--                 text = text .. tab .. TableSerialization(v, i + 1, writeNumericTable) .. ",\n"
--             elseif type(v) == "string" then
--                 v = string.gsub(v, "\n", "\\\n")
--                 v = string.gsub(v, "\"", "\\\"")
--                 -- v = string.gsub(v, "'", "\\\'")
--                 text = text .. tab .. '"' .. v .. '",\n'
--             elseif type(v) == "number" or type(v) == "boolean" then
--                 text = text .. tab .. tostring(v) .. ",\n"
--             elseif v == nil then
--                 text = text .. tab .. "nil,\n"
--             end
--         end
--     else
--         -- Sinon, on affiche les clés comme d'habitude
--         for k, v in PairsByKeys(t) do
--             if type(k) == "string" then
--                 k = string.gsub(k, "\n", "\\\n")
--                 k = string.gsub(k, "\"", "\\\"")
--                 -- k = string.gsub(k, "'", "\\\'")
--                 text = text .. tab .. '["' .. k .. '"] = '
--             else
--                 -- text = text .. tab .. "[" .. k .. "] = "
-- 				text = text .. tab .. "[" .. tostring(k) .. "] = "
--             end

--             if type(v) == "table" then
--                 text = text .. TableSerialization(v, i + 1, writeNumericTable) .. ",\n"
--             elseif type(v) == "string" then
--                 v = string.gsub(v, "\n", "\\\n")
--                 v = string.gsub(v, "\"", "\\\"")
--                 -- v = string.gsub(v, "'", "\\\'")
--                 text = text .. '"' .. v .. '",\n'
--             elseif type(v) == "number" or type(v) == "boolean" then
--                 text = text .. tostring(v) .. ",\n"
--             elseif v == nil then
--                 text = text .. "nil,\n"
--             end
--         end
--     end

--     text = text .. tab1 .. "}"
--     return text
-- end

--function to turn a table into a string
function TableSerialization_TEMP1(t, i, params)

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

-- Fonction pour sérialiser une table en chaîne
function TableSerializationAG_triggers(t, i)
    local text = "{\n"
    local tab = string.rep("\t", i + 1)

    if IsSequentialTable(t) then
        -- Si la table est strictement numérique, on n'affiche pas les indices
        for _, v in ipairs(t) do
            if type(v) == "string" then
                text = text .. tab .. "'" .. v .. "',\n"
            elseif type(v) == "number" then
                text = text .. tab .. v .. ",\n"
            elseif type(v) == "table" then
                text = text .. tab .. TableSerializationAG(v, i + 1)
            elseif type(v) == "boolean" then
                text = text .. tab .. tostring(v) .. ",\n"
            elseif type(v) == "function" then
                text = text .. tab .. tostring(v) .. ",\n"
            elseif v == nil then
                text = text .. tab .. "nil,\n"
            end
        end
    else
        -- Sinon, on affiche les clés triées
        for k, v in PairsByKeys(t) do
            if type(k) == "string" then
                text = text .. tab .. "['" .. k .. "'] = "
            else
                text = text .. tab .. "[" .. k .. "] = "
            end

            if type(v) == "string" then
                text = text .. "'" .. v .. "',\n"
            elseif type(v) == "number" then
                text = text .. v .. ",\n"
            elseif type(v) == "table" then
                text = text .. TableSerializationAG(v, i + 1)
            elseif type(v) == "boolean" then
                text = text .. tostring(v) .. ",\n"
            elseif type(v) == "function" then
                text = text .. tostring(v) .. ",\n"
            elseif v == nil then
                text = text .. "nil,\n"
            end
        end
    end

    tab = string.rep("\t", i)
    if i == 0 then
        text = text .. tab .. "}\n" -- La dernière accolade ne doit pas être suivie d'une virgule
    else
        text = text .. tab .. "},\n" -- Toutes les autres accolades sont suivies d'une virgule
    end
    return text
end


function Try_dofile(path)
	local f3 = io.open(path, "r")
	if f3 then f3:close(); dofile(path); return true end
	return false
end


--function type DCS, ne pas changer la casse
function aircraft_task(taskName)

	return taskName
end

local loadoutStructures = {
	{name = "minscore", check = false },
	{name = "support", check = false },
	{name = "country", check = false },

	{name = "self_escort", check = false },
	{name = "attributes", check = false },
	{name = "code_loadout", check = false },
	{name = "weaponType", check = false },
	{name = "expend", check = false },
	{name = "attackType", check = false },

	{name = "day", check = false },
	{name = "night", check = false },
	{name = "adverseWeather", check = false },
	{name = "range", check = false },
	{name = "capability", check = false },
	{name = "firepower", check = false },
	{name = "vCruise", check = false },
	{name = "vAttack", check = false },
	{name = "hCruise", check = false },
	{name = "hAttack", check = false },
	{name = "standoff", check = false },
	{name = "ingress", check = false },
	{name = "egress", check = false },
	{name = "MaxAttackOffset", check = false },

	{name = "tStation", check = false },
	{name = "LDSD", check = false },
	{name = "sortie_rate", check = false },
	{name = "stores", check = false },


}

local function makeStrutureLoadout(loadoutTotal)

	for plane, loadoutsByTask in PairsByKeys(loadoutTotal) do
		for task, loadouts in PairsByKeys(loadoutsByTask) do

			for loadoutName, loadout in PairsByKeys(loadouts) do

				local loadoutTemp = {}

				--ajoutes les entrées selon le canevas
				for structN, struct in ipairs(loadoutStructures) do

					if loadout[struct.name] then
						local entrie = {
							[struct.name] = loadout[struct.name]
						}
						table.insert(loadoutTemp, entrie)
					end
				end

				--fait un repassage pour ajouter ce qui n etait pas dans le canevas
				for key, values in pairs(loadout) do
					local inStructure = false

					for structN, struct in ipairs(loadoutStructures) do
						if struct.name == key then
							inStructure = true
							break
						end
					end

					if not inStructure then

						local entrie = {
							[key] = values
						}

						-- print("EEE             entrie "..key.." "..tostring(entrie))

						table.insert(loadoutTemp, entrie)
					end
				end

				loadouts[loadoutName] = loadoutTemp
			end
		end
	end

	return loadoutTotal

end

local item = 0
local lodaoutStructure = {}

function TableSerializationLoadout(t, i, iTotal)

	local text = ""

		local recal = false
		local tab1 = ""
		local tab = ""

		--ignore les chapitres 4 issue du rangement loadoutStructures
		if iTotal == 4 then
			recal = true
			text = ""
		else
			text = "{\n"
		end

		if iTotal >= 4 then i = iTotal-1 end

		for n = 1, i do																	--controls the indent for the current text line
			tab1 = tab1 .. "\t"
		end

		for n = 1, i + 1 do																	--controls the indent for the current text line
			tab = tab .. "\t"
		end



		for k, v in pairs(t) do

			if type(k) == "string" then
				if string.match(k, "%s") or  string.match(k, "%d") then
					text = text .. tab .. '["' .. k .. '"] = '
				else
					text = text .. tab  .. k .. ' = '
				end
			elseif iTotal ~= 3 then
				text = text .. tab .. "[" .. k .. "] = "
			end

			if type(v) == "string" then
				v = string.gsub(v, "\n", "\\n" )
				text = text .. '"' .. v .. '",\n'
			elseif type(v) == "number" then
				text = text .. v .. ",\n"
			elseif type(v) == "table" then
				local tableOneLigne = false

				if k == "attributes" or k == "code_loadout" then
					tableOneLigne = true
				end

				if tableOneLigne then
					text = text .." {"
					local passLoop = false
					for kTemp, vTemp in pairs(v) do
						text = text .." \""..vTemp.."\","
						passLoop = true
					end
					if passLoop then text = text:sub(1, -2) end
					text = text .." },\n"
				else
					text = text .. TableSerializationLoadout(v, i+1, iTotal + 1)
				end

			elseif type(v) == "boolean" then
				if v == true then
					text = text .. "true,\n"
				else
					text = text .. "false,\n"
				end
			elseif type(v) == "function" then
				text = text .. v .. ",\n"
			elseif v == nil then
				text = text .. "nil,\n"
			end
		end
		tab = ""
		for n = 1, i do																		--indent for closing bracket is one less then previous text line
			tab = tab .. "\t"
		end
		if not recal then
			if i == 0 then
				text = text .. tab .. "}\n"														--the last bracket should not be followed by an comma
			else
				text = text .. tab .. "},\n"													--all brackets with indent higher than 0 are followed by a comma
			end
		end

	return text
end

function DeepCopy(orig, copies)
    copies = copies or {}  -- Table pour suivre les références déjà copiées

    if type(orig) ~= 'table' then return orig end  -- Copie simple des types de base

    if copies[orig] then return copies[orig] end  -- Si déjà copié, éviter boucle infinie

    local copy = {}
    copies[orig] = copy  -- Stocker la copie pour éviter de repasser sur la même table

    for orig_key, orig_value in pairs(orig) do
        copy[DeepCopy(orig_key, copies)] = DeepCopy(orig_value, copies)
    end

    setmetatable(copy, DeepCopy(getmetatable(orig), copies))
    return copy
end


-- --function to make a deep copy of a table
-- function Deepcopy(orig)
--     -- local orig_type = type(orig)
--     -- local copy
--     -- if orig_type == 'table' then
--     --     copy = {}
--     --     for orig_key, orig_value in next, orig, nil do
--     --         copy[Deepcopy(orig_key)] = Deepcopy(orig_value)
--     --     end
--     --     setmetatable(copy, Deepcopy(getmetatable(orig)))
--     -- else -- number, string, boolean, etc
--     --     copy = orig
--     -- end
--     -- return copy



-- 		local copy
-- 		if type(orig) == 'table' then
-- 			copy = {}
-- 			for orig_key, orig_value in pairs(orig) do
-- 				copy[orig_key] = Deepcopy(orig_value)
-- 			end
-- 			setmetatable(copy, Deepcopy(getmetatable(orig)))
-- 		else
-- 			copy = orig
-- 		end
-- 		return copy


-- end


--function to return heading between two vector2 points
-- return une valeur en degré par rapport au nord géographique (pas le cercle trigonometrique)
function GetHeadingDegre(p1, p2, debug)

	if debug then
		if not p1 or not p1.x or not p1.y then
			_affiche(debug, "debug p1 GetHeading")
		end
		if not p2 or not p2.x or not p2.y then
			_affiche(debug, "debug p2 GetHeading")
		end
	end


	local deltax = p2.x - p1.x
	local deltay = p2.y - p1.y
	local result
	if (deltax > 0) and (deltay == 0) then
		result =  0
	elseif (deltax > 0) and (deltay > 0) then
		result =  math.deg(math.atan(deltay / deltax))
	elseif (deltax == 0) and (deltay > 0) then
		result =  90
	elseif (deltax < 0) and (deltay > 0) then
		result =  90 - math.deg(math.atan(deltax / deltay))
	elseif (deltax < 0) and (deltay == 0) then
		result =  180
	elseif (deltax < 0) and (deltay < 0) then
		result =  180 + math.deg(math.atan(deltay / deltax))
	elseif (deltax == 0) and (deltay < 0) then
		result =  270
	elseif (deltax > 0) and (deltay < 0) then
		result =  270 - math.deg(math.atan(deltax / deltay))
	else
		result =  0
	end

	-- --https://www.mathepower.com/fr/fonctionslineaires.php
	-- if result >= 0 and result <= 90 then       
	-- 	result = (-1* result) + 90

    -- elseif result >= 0 and result <= 180 then
    --     result = (-1* result) + 450

    -- elseif result >= 270 and result <= 360 then
    --     result = (-1* result) + 450

    -- elseif result >= 180 and result <= 270 then
    --     result = (-1* result) + 450
    -- end

	return result

end

--https://github.com/mrSkortch/MissionScriptingTools/releases
--- Returns heading of given unit.
-- @tparam Unit unit unit whose heading is returned.
-- @param rawHeading
-- @treturn number heading of the unit, in range
-- of 0 to 2*pi.
function GetHeadingByPos(unit)
	local unitpos = unit:getPosition()
	if unitpos then
		local Heading = math.atan2(unitpos.x.z, unitpos.x.x)
		if Heading < 0 then
			Heading = Heading + 2*math.pi	-- put heading in range of 0 to 2*pi
		end
		return Heading
	end
end

function HeadingDegToRad(angle)
	angle = angle % 360 							-- garde le reste de 360
	return angle * 0.0174532925				-- 0,0174532925
end


--function to return the angle between two headings
function GetDeltaHeading(h1, h2)
	local delta = h2 - h1
	if delta > 180 then
		delta = delta - 360
	elseif delta <= -180 then
		delta = delta + 360
	end
	return delta
end




--function to return distance between two vector2 points
function GetDistance(p1, p2)

	local c_GetD = os.clock()

	if not p1.x or not p1.y then
		_affiche(p1, "p1")
	end

	if not p2.x or not p2.y then
		_affiche(p2, "p2")
	end

	local deltax = p2.x - p1.x
	local deltay = p2.y - p1.y

	local result =  math.sqrt(math.pow(deltax, 2) + math.pow(deltay, 2))

	T_GetD = T_GetD + (os.clock() - c_GetD)

	return result
end




--function to return a new point offset from an initial point
function GetOffsetPoint(point, heading, distance, show)
	-- if show then
	-- 	print("UtilF heading: "..tostring(heading).." distance "..tostring(distance))
	-- 	_affiche(point,"point")
	-- end
	return {
		x = point.x + math.cos(math.rad(heading)) * distance,
		y = point.y + math.sin(math.rad(heading)) * distance
	}
end


-- --function to return closest distance of point p3 to the line p1 to p2
-- function GetTangentDistance(p1, p2, p3)

-- 	local c_GetTD = os.clock()

-- 	local p1_p2_heading = GetHeadingDegre(p1, p2)
-- 	local p1_p3_heading = GetHeadingDegre(p1, p3)
-- 	local alpha = math.abs(p1_p2_heading - p1_p3_heading)
-- 	if alpha > 180 then
-- 		alpha = math.abs(alpha - 360)
-- 	end
-- 	local p1_p3_distance = GetDistance(p1, p3)

-- 	local p2_p1_heading = GetHeadingDegre(p2, p1)
-- 	local p2_p3_heading = GetHeadingDegre(p2, p3)

-- 	local beta = math.abs(p2_p1_heading - p2_p3_heading)
-- 	if beta > 180 then
-- 		beta = math.abs(beta - 360)
-- 	end
-- 	local p2_p3_distance = GetDistance(p2, p3)

-- 	if alpha > 90 or alpha < -90 then
-- 		T_GetTD = T_GetTD + (os.clock() - c_GetTD)
-- 		return p1_p3_distance
-- 	elseif beta > 90 or beta < -90 then
-- 		T_GetTD = T_GetTD + (os.clock() - c_GetTD)
-- 		return p2_p3_distance
-- 	elseif GetDistance(p1, p2) == 0 then
-- 		T_GetTD = T_GetTD + (os.clock() - c_GetTD)
-- 		return p1_p3_distance
-- 	else

-- 		local value = math.abs(math.sin(math.rad(alpha)) * p1_p3_distance)
-- 		T_GetTD = T_GetTD + (os.clock() - c_GetTD)
-- 		return value
-- 	end
-- end

-- Retourne la distance minimale entre un point (p3) et un segment (p1-p2),
-- afin d’évaluer rapidement si un trajet intersecte une zone de menace.
--https://www.geeksforgeeks.org/dsa/minimum-distance-from-a-point-to-the-line-segment-using-vectors/
-- Cette version utilise la projection vectorielle pour calculer la
-- distance minimale d’un point à un segment. Cela remplace les calculs
-- d’angles et de trigonométrie (atan2/sin) par une formule directe, ce
-- qui réduit fortement le coût CPU tout en donnant un résultat équivalent.

function GetTangentDistance(p1, p2, p3)

    local c_GetTD = os.clock()

    local x1, y1 = p1.x, p1.y
    local x2, y2 = p2.x, p2.y
    local x3, y3 = p3.x, p3.y

    local dx = x2 - x1
    local dy = y2 - y1

    local len2 = dx * dx + dy * dy
    if len2 == 0 then
        -- p1 et p2 confondus : distance point à point
        local dist = math.sqrt((x3 - x1)^2 + (y3 - y1)^2)
        T_GetTD = T_GetTD + (os.clock() - c_GetTD)
        return dist
    end

    -- Projection du point p3 sur la droite p1-p2 (paramètre t)
    local t = ((x3 - x1) * dx + (y3 - y1) * dy) / len2

    if t < 0 then
        -- Projection avant p1
        local dist = math.sqrt((x3 - x1)^2 + (y3 - y1)^2)
        T_GetTD = T_GetTD + (os.clock() - c_GetTD)
        return dist
    elseif t > 1 then
        -- Projection après p2
        local dist = math.sqrt((x3 - x2)^2 + (y3 - y2)^2)
        T_GetTD = T_GetTD + (os.clock() - c_GetTD)
        return dist
    else
        -- Distance perpendiculaire au segment
        local projx = x1 + t * dx
        local projy = y1 + t * dy
        local dist = math.sqrt((x3 - projx)^2 + (y3 - projy)^2)
        T_GetTD = T_GetTD + (os.clock() - c_GetTD)
        return dist
    end
end


--function to return lenght of a line from p1 to p2 that is within a circle c with radius r
function GetTangentLenght(p1, p2, pc, r)
	local p1_pc = GetDistance(p1, pc)
	local p2_pc = GetDistance(p2, pc)
	local p1_p2 = GetDistance(p1, p2)

	if (p1.x == pc.x and p1.y == pc.y) or (p2.x == pc.x and p2.y == pc.y) then			--p1 or p2 are the center of the circle
		if p1_p2 > r then																--the other point is outside of the circle
			return r																	--return the circle radius
		else																			--the other point is inside the cicle
			return p1_p2																--return distance from p1 to p2
		end
	elseif p1_pc < r and p2_pc < r then													--p1 and p2 are in circle
		return p1_p2																	--return distance from p1 to p2
	elseif p1_pc < r then																--only p1 is in circle
		local p1_p2_heading = GetHeadingDegre(p1, p2)										--heading from p1 to p2
		local p1_pc_heading = GetHeadingDegre(p1, pc)										--heading from p1 to pc
		local alpha = math.abs(p1_p2_heading - p1_pc_heading)							--angle in deg		
		local a = r
		local b = p1_pc
		local beta = math.deg(math.asin(b * math.sin(math.rad(alpha)) / a))
		local gamma = 180 - alpha - beta
		local c = a * math.sin(math.rad(gamma)) / math.sin(math.rad(alpha))
		return math.abs(c)
	elseif p2_pc < r then																--only p2 is in circle
		local p2_p1_heading = GetHeadingDegre(p2, p1)										--heading from p2 to p1
		local p2_pc_heading = GetHeadingDegre(p2, pc)										--heading from p2 to pc
		local alpha = math.abs(p2_p1_heading - p2_pc_heading)							--angle in deg		
		local a = r
		local b = p2_pc
		local beta = math.deg(math.asin(b * math.sin(math.rad(alpha)) / a))
		local gamma = 180 - alpha - beta
		local c = a * math.sin(math.rad(gamma)) / math.sin(math.rad(alpha))
		return math.abs(c)
	else																				--neither p1 or p2 is in circle
		local t = GetTangentDistance(p1, p2, pc)
		return 2 * math.sqrt(math.pow(r, 2) - math.pow(t, 2))
	end
end


--function to return subsequent IDs
-- Gestion propre des IDs pour groupes et unités



-- Génère un nouvel ID de groupe unique
function GenerateIDGroup(groupName)
	local maxAttempts = 10000
	local attempts = 0
	repeat
		idGroupCounter = idGroupCounter + 1
		attempts = attempts + 1
		if attempts > maxAttempts then
			error("GenerateIDGroup: Too many attempts to find a unique group ID")
		end
	until not AllIdGroup[idGroupCounter]
	AllIdGroup[idGroupCounter] = groupName
	return idGroupCounter
end

-- Génère un nouvel ID d'unité unique
function GenerateIDUnit(unitName, type)
	local maxAttempts = 10000
	local attempts = 0

	repeat
		idUnitCounter = idUnitCounter + 1
		attempts = attempts + 1
		if attempts > maxAttempts then
			error("GenerateIDUnit: Too many attempts to find a unique unit ID")
		end
	until not AllIdUnit[idUnitCounter]

	AllIdUnit[idUnitCounter] = {
		name = unitName,
		type = type,
	}
	if unitName then
		UnitByName[unitName] = idUnitCounter
	end

	-- print("GenerateIDUnit "..unitName.." | "..type.." | "..idUnitCounter)

	return idUnitCounter
end

-- Fonction principale pour détecter et corriger les doublons
--premiere passe pour les warehouses, CV, et FARP
function FirstCheck_Id()

	for warhouse_Id, warehouseData in pairs(warehouses.warehouses or {}) do
		for side_name, side in pairs(mission.coalition) do
			for country_n, country_ in pairs(side.country) do
				for categorie, categorie_ in pairs(country_) do
					if type(categorie_) == "table" and categorie_.group then
						for groupN, groupData in pairs(categorie_.group) do

							-- Vérifie les doublons de unitId
							for unitN, unit in pairs(groupData.units or {}) do
								if unit.unitId == warhouse_Id then
									AllIdUnit[unit.unitId] = {name = unit.name, type = unit.type}
									break
								end
							end

						end
					end
				end
			end
		end
	end

	-- _affiche(AllIdUnit, "warehouses ")

end

-- Fonction principale pour détecter et corriger les doublons
function CheckAll_Id()

	-- _affiche(AllIdUnit, "AllIdUnit_START ")
	-- Cross-platform sleep for 6 seconds
	-- if package.config:sub(1,1) == '\\' then
	-- 	-- Windows
	-- 	os.execute("ping -n 7 127.0.0.1 > NUL")
	-- else
	-- 	-- Unix/Linux/Mac
	-- 	os.execute("sleep 6")
	-- end

	--pour le mission
	for side_name, side in pairs(mission.coalition) do
		for country_n, country_ in pairs(side.country) do
			for categorie, categorie_ in pairs(country_) do
				if type(categorie_) == "table" and categorie_.group then
					for groupN, groupData in pairs(categorie_.group) do
						-- Vérifie les doublons de groupId
                        if AllIdGroup[groupData.groupId] then
                        else
                            AllIdGroup[groupData.groupId] = groupData.name
                        end
                        -- Vérifie les doublons de unitId
                        for Nunit, unit in pairs(groupData.units or {}) do
                            if AllIdUnit[unit.unitId] then
                            else
                                AllIdUnit[unit.unitId] = {name = unit.name, type = unit.type}
                                UnitByName[unit.name] = unit.unitId
                            end
                        end
                    end
                end
            end
        end
    end

	--pour le oob_ground
    for coalName, coal in pairs(oob_ground or {}) do
        for countryN, country in pairs(coal or {}) do
            for category, groups in pairs(country or {}) do
                if type(groups) == "table" and groups["group"] then
                    for groupN, groupData in pairs(groups["group"] or {}) do
                        -- Vérifie les doublons de groupId
                        if AllIdGroup[groupData.groupId] then
                        else
                            AllIdGroup[groupData.groupId] = groupData.name
                        end
                        -- Vérifie les doublons de unitId
                        for Nunit, unit in pairs(groupData.units or {}) do
                            if AllIdUnit[unit.unitId] then
                            else
                                AllIdUnit[unit.unitId] = {name = unit.name, type = unit.type}
                                UnitByName[unit.name] = unit.unitId
                            end
                        end
                    end
                end
            end
        end
    end

-- _affiche(AllIdUnit, "AllIdUnit_FIN ")

end


-- Fonction principale pour détecter et corriger les doublons
function CheckAndFixAllIds()
    -- -- Réinitialise les tables d'ID
    -- AllIdGroup = {}
    -- AllIdUnit = {}
    -- UnitByName = {}

    -- 1. Premier passage : collecte tous les IDs et détecte les doublons
    local groupIdError = {}
    local unitIdError = {}

    for coalName, coal in pairs(oob_ground or {}) do
        for countryN, country in pairs(coal or {}) do
            for category, groups in pairs(country or {}) do
                if type(groups) == "table" and groups["group"] then
                    for groupN, group in pairs(groups["group"] or {}) do
                        -- Vérifie les doublons de groupId
                        if AllIdGroup[group.groupId] and AllIdGroup[group.groupId] ~= group.name then
                            table.insert(groupIdError, group)
                        else
                            AllIdGroup[group.groupId] = group.name
                        end
                        -- Vérifie les doublons de unitId
                        for Nunit, unit in pairs(group.units or {}) do
                            if AllIdUnit[unit.unitId] and AllIdUnit[unit.unitId].name ~= unit.name then
								--on evite de changer l'Id si c'est une FARP, a cause des multiple lien (warhouse, linkUnit, etc...)
								if string.find(AllIdUnit[unit.unitId].type, "FARP") then
                                	table.insert(unitIdError, unit)
								else
									table.insert(unitIdError, AllIdUnit[unit.unitId])
								end
                            else
                                AllIdUnit[unit.unitId] = {name = unit.name, type = unit.type}
                                UnitByName[unit.name] = unit.unitId
                            end
                        end
                    end
                end
            end
        end
    end

    -- 2. Correction des doublons de groupId
    for _, group in ipairs(groupIdError) do
        group.groupId = GenerateIDGroup(group.name)
        if Debug and Debug.debug then
            print("Nouveau groupId attribué : "..tostring(group.groupId).." pour "..tostring(group.name))
        end
    end

    -- 3. Correction des doublons de unitId
    for _, unit in ipairs(unitIdError) do
        unit.unitId = GenerateIDUnit(unit.name, unit.type)
        if Debug and Debug.debug then
            print("Nouveau unitId attribué : "..tostring(unit.unitId).." pour "..tostring(unit.name))
        end
    end
end


function Disp_time(time)
	local days = math.floor(time/86400)
	local hours = math.floor((time% 86400)/3600)
	local minutes = math.floor((time%3600)/60)
	local seconds = math.floor((time%60))
	return string.format("%d days %02d hours",days,hours)
  end


--function to return various date and time formats of a number in seconds
function FormatTime(t, form)
    local day = math.floor(t / 86400)
    local hour = math.floor((t % 86400) / 3600)
    local minute = math.floor((t % 3600) / 60)
    local second = math.floor(t % 60)

    local dayStr = string.format("%02d", day)
    local hourStr = string.format("%02d", hour + day * 24) -- total heures pour hh:mm
    local hourOnlyStr = string.format("%02d", hour)
    local minuteStr = string.format("%02d", minute)
    local secondStr = string.format("%02d", second)

    if form == "dd:hh:mm" then
        return dayStr .. "d " .. hourOnlyStr .. "h" .. minuteStr
    elseif form == "hh:mm" then
        return hourStr .. "h" .. minuteStr
    elseif form == "hh:mm:ss" then
        return hourStr .. "h" .. minuteStr .. "mn " .. secondStr
    end
end

-- function FormatTime(t, form)
-- 	local hour
-- 	local minute
-- 	local second

-- 	if t >= 86400 then
-- 		t= t - 86400
-- 	end

-- 	hour = math.floor(t / 3600)
-- 	t = t - hour * 3600
-- 	if hour < 10 then
-- 		hour = "0" .. hour
-- 	end

-- 	minute = math.floor(t / 60)
-- 	t = t - minute * 60
-- 	if minute < 10 then
-- 		minute = "0" .. minute
-- 	end

-- 	second = math.floor(t)
-- 	if second < 10 then
-- 		second = "0" .. second
-- 	end

-- 	if form == "hh:mm" then
-- 		minute =  math.floor(minute + 0.5)
-- 		if minute < 10 then
-- 			minute = "0" .. minute
-- 		end
-- 		return hour .. ":" .. minute
-- 	elseif form == "hh:mm:ss" then
-- 		return hour .. ":" .. minute .. ":" .. second
-- 	end
-- end


--function to format date
function FormatDate(day, month, year)
	if month == 1 then
		month = "January"
	elseif month == 2 then
		month = "February"
	elseif month == 3 then
		month = "March"
	elseif month == 4 then
		month = "April"
	elseif month == 5 then
		month = "May"
	elseif month == 6 then
		month = "June"
	elseif month == 7 then
		month = "July"
	elseif month == 8 then
		month = "August"
	elseif month == 9 then
		month = "September"
	elseif month == 10 then
		month = "October"
	elseif month == 11 then
		month = "November"
	elseif month == 12 then
		month = "December"
	end

	return month .. " " .. day .. ", " .. year
end


--function to format altitude in metric or imperial measurement
function FormatDistance(a, unitsUse)
	a = a / 1000																			--round to km
	if unitsUse == "metric" or unitsUse =="russian" then															--metric units
		return math.floor(a) .. " km"															--kilometers
	else 													--imperial units
		a = a * 0.539957																	--covert to nm
		return math.floor(a) .. " nm"															--nautical miles
	end
end


--function to format altitude in metric or imperial measurement
function FormatAlt(a, unitsUse)
	if unitsUse == "metric" or unitsUse =="russian" then															--metric units
		a = math.ceil(a / 10) * 10															--round to tens
		if a <= 1000 then																	--for altitudes until 1000m
			a = a .. " m AGL"																--meters AGL
		else
			a = a .. " m MSL"																--meters MSL
		end
	else													--imperial units
		a = a * 3.28																		--covert to feet
		a = math.ceil(a / 100) * 100														--round to hunderts
		if a <= 3300 then																	--for altitudes until 3300ft
			a = a .. " ft AGL"																--feet AGL
		else
			a = a .. " ft MSL"																--feet MSL
		end
	end
	return a
end


--function to format speed in metric or imperial measurement
function FormatSpeed(a, unitsUse)
	if  unitsUse == "metric" or unitsUse =="russian" then															--metric units
		a = a * 3.6
		a = math.floor(a / 10) * 10															--round to tens
		a = a .. " kph"																		--km per hour
	else												--imperial units
		a = a * 1.94																		--covert to knots
		a = math.floor(a / 5) * 5															--round to fives
		a = a .. " kts"																		--knots
	end
	return a
end


--function to replace certain type names
function AliasTypeName(s)
	if TypeAlias and TypeAlias[s] then
		return TypeAlias[s]
	else
		return s
	end
end

--function to replace certain type names Init\various_table.lua
function AliasBaseName(s)
	if BaseNameAlias and BaseNameAlias[s] then
		return BaseNameAlias[s]
	else
		return s
	end
end

-- -- Fonction récursive pour itérer sur la table
-- function Display(t, indent)
--     indent = indent or ""
--     for key, value in pairs(t) do
--         if type(value) == "table" then
--             print(indent .. tostring(key) .. ":")
--             Display(value, indent .. "  ")
--         else
--             print(indent .. tostring(key) .. ": " .. tostring(value))
--         end
--     end
-- end

-- Fonction récursive pour afficher une table en évitant les erreurs
function Display(t, indent)
    indent = indent or ""

    if type(t) ~= "table" then
        print(indent .. tostring(t)) -- Affiche directement la valeur si ce n'est pas une table
        return
    end

    for key, value in pairs(t) do
        if type(value) == "table" then
            print(indent .. tostring(key) .. ":")
            Display(value, indent .. "  ")
        else
            print(indent .. tostring(key) .. ": " .. tostring(value))
        end
    end
end



function _affiche(t, indent)
    indent = indent or ""

    if type(t) ~= "table" then
        print(indent .. tostring(t)) -- Affiche directement la valeur si ce n'est pas une table
        return
    end

    for key, value in pairs(t) do
        if type(value) == "table" then
            print(indent .. tostring(key) .. ":")
            Display(value, indent .. "  ")
        else
            print(indent .. tostring(key) .. ": " .. tostring(value))
        end
    end
end


function _afficheTXT(_table, titre, prof)

	--export custom mission log
	local logExp = "logExp  "

	if not prof or prof == nil then prof = 999 end 						-- prof = profondeur de niveau dans la hierarchie
	logExp = logExp.."\n"

    if titre == nil then logExp = logExp.. string.format(" _affiche() titre = nil ")
    elseif type( titre) == "string" then
		logExp = logExp.. string.format(" _affiche(titre) "..tostring(titre)).."\n"
	end

	if type( _table) == "table"  then --and  (table.getn(_table) ~= 0 or table.getn(_table) ~= nil

		for a, b in pairs(_table) do --for a, b in pairs(event.initiator) do --for a, b in pairs(_ammo) do

			if  type(b) ~= "table" then
				logExp = logExp.." _affiche (a b)     "..tostring(a).." "..tostring(b).."\n"
			elseif type(b) == "table"   and prof >= 2 then
				for c, d in pairs(b) do
					logExp = logExp.. " _affiche(a c)           "..tostring(a).." "..tostring(c).."\n"


					if type(d)~= "table"  then
						logExp = logExp.. " _affiche(d)                "..tostring(d).."\n"
					elseif type(d) == "table"  and prof >= 3 then
						for e, f in pairs(d) do

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

											if type( j ) ~= "table"  then
												logExp = logExp.. " _affiche(i j)                                              "..tostring(i).." "..tostring(j).."\n"
											elseif type( j ) == "table" and prof >= 6 then
												logExp = logExp.. " _affiche(i)                                                  "..tostring(i).."\n"
												for k, l in pairs(j) do

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

	return logExp

end -- function affiche

--*******************************************************
----------------------------------------------------------------
-- Calcul Range Radio NG
----------------------------------------------------------------
----------------------------------------------------------------
-- DCE - Common Radio Frequency Finder
-- Lua 5.1 compatible
----------------------------------------------------------------


local function intersectRange(a, b)


	local function modulationCompatible(m1, m2)
		if m1 == m2 then return true end
		if m1 == MODULATION_AM_AND_FM then return true end
		if m2 == MODULATION_AM_AND_FM then return true end
		return false
	end

	if not modulationCompatible(a.modulation, b.modulation) then
		return nil
	end

	local minF = math.max(a.min, b.min)
	local maxF = math.min(a.max, b.max)

	if minF < maxF then
		return {
			min = minF,
			max = maxF,
			modulation = (a.modulation == b.modulation) and a.modulation or MODULATION_AM_AND_FM
		}
	end

	return nil
end


local function intersect(a,b)
	local min = math.max(a.min, b.min)
	local max = math.min(a.max, b.max)
	if max > min then
		return { min = min, max = max }
	end
	end

local function findBestCommonRange(ranges)

	if type(ranges) ~= "table" or #ranges == 0 then
		return nil
	end

	local best, bestScore = nil, 0

	for i,candidate in ipairs(ranges) do
		local score = 0
		local current = candidate

		for _,r in ipairs(ranges) do
			local inter = intersect(current, r)
			if inter then
				current = inter
				score = score + 1
			end
		end

		if score > bestScore then
			bestScore = score
			best = current
		end
	end

	return best
end

local function simplifyRadioRanges(moduleData, isPlayer)

	-- if isPlayer then print("simplifyRadioRanges called for moduleData isPlayer=? "..tostring(isPlayer)) end

	if type(moduleData) ~= "table" then
		print("return A no moduleData table")
		return {}
	end

	------------------------------------------------
	-- 1) Collecte brute de toutes les plages
	------------------------------------------------
	local rawRanges = {}

	local function addRange(min, max)

		-- if isPlayer then print("SRR addRange() A1 "..tostring(min).." - "..tostring(max)) end

		if type(min) == "number" and type(max) == "number" and max > min then
			-- if isPlayer then print("addRange() A2 valid range") end
			table.insert(rawRanges, { min = min, max = max })
		end
	end

	-- HumanRadio
	local hr = moduleData.HumanRadio
	if type(hr) == "table" then
		if type(hr.rangeFrequency) == "table" and hr.rangeFrequency[1] then
			-- forme limitative
			for _,r in ipairs(hr.rangeFrequency) do
				-- if isPlayer then print("SRR addRange() B1sub-range "..tostring(r.min).." - "..tostring(r.max)) end
				addRange(r.min, r.max)
			end
		elseif hr.minFrequency and hr.maxFrequency then
			-- if isPlayer then print("SRR addRange() B2 minFrequency "..tostring(hr.minFrequency).." - "..tostring(hr.maxFrequency)) end
			addRange(hr.minFrequency, hr.maxFrequency)
		end
	end

	-- PanelRadio
	local pr = moduleData.panelRadio
	if type(pr) == "table" then
		-- if isPlayer then _affiche(pr, "pr: ") end

		for _,radio in pairs(pr) do
			-- if isPlayer then print("SRR addRange() C _ ".._) _affiche(radio, "radio: ") end

			if type(radio.range) == "table" then
				for _, rangeData in ipairs(radio.range) do
					-- if isPlayer then print("SRR addRange() D panelRadio "..tostring(rangeData.min).." - "..tostring(rangeData.max)) end
					addRange(rangeData.min, rangeData.max)
				end
			end
		end
	end

	if #rawRanges == 0 then
		-- if isPlayer then print("SRR return E no rawRanges collected") end
		return {}
	end

	------------------------------------------------
	-- 2) CAS NON JOUEUR → UNION GLOBALE
	------------------------------------------------
	if not isPlayer then
		table.sort(rawRanges, function(a,b) return a.min < b.min end)

		local EPSILON = 0.01
		local simplified = {}
		local current = rawRanges[1]

		for i = 2, #rawRanges do
			local r = rawRanges[i]
			if r.min <= current.max + EPSILON then
				current.max = math.max(current.max, r.max)
			else
				table.insert(simplified, current)
				current = r
			end
		end

		table.insert(simplified, current)
		-- print("SRR return F simplified non-player ranges")
		return simplified
	end

	------------------------------------------------
	-- 3) CAS JOUEUR → PLAGE LA PLUS RESTRICTIVE
	------------------------------------------------
	local best = nil
	local bestWidth = nil
	-- if isPlayer then print("SRR G1 searching best player range among "..tostring(#rawRanges).." ranges") end

	for _,r in ipairs(rawRanges) do
		local width = r.max - r.min
		-- if isPlayer then print("SRR G2 candidate player range "..tostring(r.min).." - "..tostring(r.max).." width "..tostring(width)) end
		if not best or width < bestWidth then
			best = { min = r.min, max = r.max }
			bestWidth = width
			-- if isPlayer then print("SRR G3 new best player range found") end
		end
	end

	if best then
		if isPlayer then
			-- print("SRR return H best player range "..tostring(best.min).." - "..tostring(best.max)) 
			-- os.execute 'pause'
			end
		return { best }
	end

	-- if isPlayer then print("return Z no best player range") end

	return {}

end



local function ComputeCommonRangesForModules(moduleList)

	local common = nil

	for moduleName,_ in pairs(moduleList) do
		local data = Db_Frequency[moduleName]
		if data then
			-- print("moduleName CCRFmodules() "..moduleName.." has data")
			local ranges = simplifyRadioRanges(data)
			-- ignorer modules vides (OH-6, data pas prête)
			if ranges[1] then
				if not common then
					common = DeepCopy(ranges)
				else
					local newCommon = {}
					for _,c in ipairs(common) do
						for _,r in ipairs(ranges) do
							local inter = intersectRange(c, r)
							if inter then
								table.insert(newCommon, inter)
							end
						end
					end
					common = newCommon
				end
			end
		end
	end

	return common or {}
end



----------------------------------------------------------------
-- main function
----------------------------------------------------------------
function DCE_FindRadioCommonWaves()

	local result = {
		blue = {},
		red  = {},
	}

	for side,modules in pairs(AircraftCampaignBySide) do

		for waveName, wave in pairs(RADIO_WAVES) do

		local common = nil
		local validModuleCount = 0

			for moduleName,_ in pairs(modules) do

				local moduleData = Db_Frequency[moduleName]
				if moduleData then
					-- print("moduleName DCE_FRC() "..moduleName)
					local ranges = simplifyRadioRanges(moduleData)
					local inWave = {}

					for _,r in ipairs(ranges) do
						local inter = intersect(r, wave)
						if inter then
							table.insert(inWave, inter)
						end
					end

					-- ce module participe à la wave
					if inWave[1] then
						validModuleCount = validModuleCount + 1
						if not common then
							common = DeepCopy(inWave)
						else
							local newCommon = {}

							for _,c in ipairs(common) do
								for _,m in ipairs(inWave) do
									local inter2 = intersect(c, m)
									if inter2 then
										table.insert(newCommon, inter2)
									end
								end
							end

							-- intersection impossible
							if not newCommon[1] then
								common = nil
								break
							end

							common = newCommon
						end
						-- _affiche(common, "common : ")
					end
				else
					if Data_divers[moduleName] and Data_divers[moduleName].playable then
						print("DCE_FindRadioCommonWaves D no Data_divers for module "..moduleName)
						os.execute("pause")
					end

				end
			end

			-- décision finale
			if common and validModuleCount >= 1 then
				result[side][waveName] = findBestCommonRange(common)
			end
		end

	end

	return result
end


function DCE_FindCommonRadioRanges()

	--ajoute à la table Db_Frequency les data radio qui sont dans Data_divers
	--ne l'ajoute pas si les tables radio sont déjà ajouté dans Db_Frequency
	for moduleName, moduleData in pairs(Data_divers) do

		if not Db_Frequency[moduleName] then
			Db_Frequency[moduleName] = {}
		end

		if moduleData.HumanRadio then
			Db_Frequency[moduleName].HumanRadio = moduleData.HumanRadio
		end

		if moduleData.panelRadio then
			Db_Frequency[moduleName].panelRadio = moduleData.panelRadio
		end
	end

	-- mutualisation panelRadio + HumanRadio
	for moduleName, dataRadio in pairs(Db_Frequency) do

		dataRadio.radio = {}

		------------------------------------------------------------------
		-- 1) panelRadio
		------------------------------------------------------------------
		if dataRadio.panelRadio then
			for radioN, radioData in pairs(dataRadio.panelRadio) do

				local ranges = {}

				--transforme cette partie range de la meme maniere pour tout le monde:
				if radioData.range then
					-- Check if range is already an array or a single range object
					if radioData.range.min and not radioData.range[1] then
						-- Single range object: convert to array format
						local copyRange = DeepCopy(radioData.range)
						radioData.range = {
							[1] = {
								min = copyRange.min,
								max = copyRange.max,
							}
						}
					end
					-- If already an array, leave it as-is
				end

				if radioData.range then
					for _, r in ipairs(radioData.range) do
						ranges[#ranges + 1] = {
							min = r.min,
							max = r.max,
						}
					end
				end

				dataRadio.radio[#dataRadio.radio + 1] = {
					name     = radioData.name or ("panelRadio_" .. tostring(radioN)),
					nbCanal  = radioData.channels and #radioData.channels or 0,
					range    = ranges,
					source   = "panelRadio",
				}
			end
		end
	end

		------------------------------------------------------------------
		-- 2) HumanRadio
		------------------------------------------------------------------
	for moduleName, dataRadio in pairs(Db_Frequency) do
		-- print("DCE_FindCommonRadioRanges A processing module "..moduleName)
		if dataRadio.HumanRadio then

			local hrMin = dataRadio.HumanRadio.minFrequency
			local hrMax = dataRadio.HumanRadio.maxFrequency
			-- print("DCE_FindCommonRadioRanges B HumanRadio for module "..moduleName.." range "..tostring(hrMin).." - "..tostring(hrMax))

			if hrMin and hrMax then
				-- print("DCE_FindCommonRadioRanges C adding HumanRadio for module "..moduleName.." range "..tostring(hrMin).." - "..tostring(hrMax))

				for waveName, wave in pairs(RADIO_WAVES) do
					-- print("DCE_FindCommonRadioRanges D checking wave "..waveName.." range "..tostring(wave.min).." - "..tostring(wave.max))

					-- test d'intersection HumanRadio ↔ wave
					if hrMax >= wave.min and hrMin <= wave.max then
						-- print("DCE_FindCommonRadioRanges E wave "..waveName.." is intersecting HumanRadio for module "..moduleName)

						-- vérifier si cette wave est déjà couverte par panelRadio
						local waveAlreadyCovered = false

						for _, radio in ipairs(dataRadio.radio) do
							-- print("DCE_FindCommonRadioRanges F checking existing radio "..tostring(radio.name).." for module "..moduleName)
							if radio.range then
								-- print("DCE_FindCommonRadioRanges G radio "..tostring(radio.name).." has range for module "..moduleName)

								-- if #radio.range and #radio.range >= 1 then
									for _, r in ipairs(radio.range) do
										-- print("DCE_FindCommonRadioRanges H checking range "..tostring(r.min).." - "..tostring(r.max).." of radio "..tostring(radio.name).." for module "..moduleName)
										if r.max >= wave.min and r.min <= wave.max then
											-- print("DCE_FindCommonRadioRanges I1 wave "..waveName.." is already covered by radio "..tostring(radio.name).." for module "..moduleName)
											waveAlreadyCovered = true
											break
										end
									end
								-- else
								-- 	local r = radio.range
								-- 	if r.max >= wave.min and r.min <= wave.max then
								-- 		print("DCE_FindCommonRadioRanges I2 wave "..waveName.." is already covered by radio "..tostring(radio.name).." for module "..moduleName)
								-- 		waveAlreadyCovered = true
								-- 		break
								-- 	end
								-- end
							end
							if waveAlreadyCovered then break end
						end

						-- si pas couverte → ajouter radio Human
						if not waveAlreadyCovered then
							-- print("DCE_FindCommonRadioRanges J adding HumanRadio wave "..waveName.." for module "..moduleName)

							-- intersection utile (le plus restrictif)
							local minFreq = math.max(hrMin, wave.min)
							local maxFreq = math.min(hrMax, wave.max)

							dataRadio.radio[#dataRadio.radio + 1] = {
								name    = "HumanRadio_" .. waveName,
								nbCanal = 0,
								range   = {
									{
										min = minFreq,
										max = maxFreq,
									},
								},
								source  = "HumanRadio",
							}
						end
					end
				end
			end
		else
			if not dataRadio.radio or #dataRadio.radio < 1 then
				dataRadio.radio[1] = {
					name    = "defautRadio_VHF",
					nbCanal = 0,
					range   = {
						{
							min = RADIO_WAVES["VHF"].min,
							max = RADIO_WAVES["VHF"].max,
						},
					},
					source  = "default",
				}
			end
		end
	end



	-- local camp_str = "Db_Frequency = " .. TableSerialization(Db_Frequency, 0)						--make a string
	-- local campFile = io.open("Debug/Radio_Db_Frequency.lua", "w")	 or error("Failed to open debug file")
	-- campFile:write(camp_str)																		--save new data
	-- campFile:close()


	local function intersectRangeFreqOnly(a, b)
		local minF = math.max(a.min, b.min)
		local maxF = math.min(a.max, b.max)

		if minF < maxF then
			return { min = minF, max = maxF }
		end

		return nil
	end

	--initie les waves de frequences
	RadioWaveCommon = DCE_FindRadioCommonWaves()

	-- camp_str = "RadioWaveCommon = " .. TableSerialization(RadioWaveCommon, 0)						--make a string
	-- campFile = io.open("Debug/Radio_RadioWaveCommon_.lua", "w")	 or error("Failed to open debug file")
	-- campFile:write(camp_str)																		--save new data
	-- campFile:close()


	------------------------------------------------
	-- 1. Find player aircraft type
	------------------------------------------------
	local currentPlayerAircraftType = nil

	for moduleName, value in pairs(AircraftInCampaign) do
		if value == "player" then
			currentPlayerAircraftType = moduleName
			break
		end
	end

	if not currentPlayerAircraftType then
		-- print("DCE_FindRadioCommonRG ERROR: no player aircraft found")
		return { red = {}, blue = {} }
	end

	------------------------------------------------
	-- 2. Get player ranges (REFERENCE)
	------------------------------------------------
	local playerData = Db_Frequency[currentPlayerAircraftType]
	-- print("DCE_FindRadioCommonRG player module data: "..currentPlayerAircraftType)

	RadioPlayerWaveRanges = simplifyRadioRanges(playerData, true)

	if Debug.debug then
		local camp_str = "RadioPlayerWaveRanges = " .. TableSerialization(RadioPlayerWaveRanges, 0)						--make a string
		local campFile = io.open("Debug/RadioPlayerWaveRanges_"..currentPlayerAircraftType..".lua", "w")	 or error("Failed to open debug file")
		campFile:write(camp_str)																		--save new data
		campFile:close()
	end
	if not RadioPlayerWaveRanges or not RadioPlayerWaveRanges[1] then
		-- print("DCE_FindRadioCommonRG WARNING: player has no radio data")
		return { red = {}, blue = {} }
	end

	------------------------------------------------
	-- 3. Determine player side
	------------------------------------------------
	local playerSide = nil
	if AircraftCampaignBySide.red and AircraftCampaignBySide.red[currentPlayerAircraftType] then
		playerSide = "red"
	elseif AircraftCampaignBySide.blue and AircraftCampaignBySide.blue[currentPlayerAircraftType] then
		playerSide = "blue"
	end

	if not playerSide then
		return { red = {}, blue = {} }
	end

	------------------------------------------------
	-- 4. Start with player ranges
	------------------------------------------------
	local commonRanges = {
		red  = {},
		blue = {},
	}

	commonRanges[playerSide] = DeepCopy(RadioPlayerWaveRanges)

	------------------------------------------------
	-- 5. Intersect ONLY with other modules of same side
	------------------------------------------------
	for moduleName, moduleData in pairs(Db_Frequency) do

		if moduleName ~= currentPlayerAircraftType then

			-- same side only
			if AircraftCampaignBySide[playerSide] and AircraftCampaignBySide[playerSide][moduleName] then

				-- print("DCE_FindRadioCommonRG checking module "..moduleName.." for side "..playerSide)
				local moduleRanges = simplifyRadioRanges(moduleData)

					-- camp_str = "moduleRanges = " .. TableSerialization(moduleRanges, 0)						--make a string
					-- campFile = io.open("Debug/RadioRangeModule_"..moduleName..".lua", "w")	 or error("Failed to open debug file")
					-- campFile:write(camp_str)																		--save new data
					-- campFile:close()

				-- IGNORE modules without radio data
				if moduleRanges and moduleRanges[1] then

					local newCommon = {}

					for _,c in ipairs(commonRanges[playerSide]) do
						for _,m in ipairs(moduleRanges) do
							local inter = intersectRangeFreqOnly(c, m)
							if inter then
								-- _affiche(inter, "inter: ")
								table.insert(newCommon, inter)
							end
						end
					end

					-- only reduce if something matched
					if newCommon[1] then
						commonRanges[playerSide] = newCommon
					else
						-- print("DCE_FindRadioCommonRG: no compatible ranges with "..moduleName..", ignored")
					end
				else
					-- print("DCE_FindRadioCommonRG: module "..moduleName.." has no radio data, ignored")
				end
			end
		end
	end

	local function UnionRanges(a, b)
		local all = {}
		for _,r in ipairs(a) do table.insert(all, r) end
		for _,r in ipairs(b) do table.insert(all, r) end
		return simplifyRadioRanges(all)
	end

	local eniSide = DCS_ENI_Side[SidePlayer]

	local heliRanges  = ComputeCommonRangesForModules(HelicoBySide[eniSide])
	local planeRanges = ComputeCommonRangesForModules(PlaneBySide[eniSide])

	commonRanges[eniSide] = UnionRanges(heliRanges, planeRanges)

	return commonRanges
end

----------------------------------------------------------------
-- FIN FIN Calcul Range Radio NG FIN
----------------------------------------------------------------
---
---
--- --assigne les fréquences aux bases
function AssignedFrequencies()
	Assigned_freq = {}

	--liste toutes les Fréquences déjà existantes pour ne pas creer de doublon
	for basename, base in pairs(db_airbases) do
		if base.ATC_frequency and base.ATC_frequency ~= "" and type(base.ATC_frequency)~= "table" then
			Assigned_freq[tonumber(base.ATC_frequency)] = basename
		elseif base.ATC_frequency and type(base.ATC_frequency)== "table" then
			for n , freq in ipairs(base.ATC_frequency) do
				Assigned_freq[tonumber(freq)] = basename
			end
		else
			-- _affiche(base.ATC_frequency, "AA base.ATC_frequency") 
		end
	end

	-- camp_str = "Assigned_freq = " .. TableSerialization(Assigned_freq, 0)						--make a string
	-- campFile = io.open("Debug/RADIO_Assigned_freq.lua", "w")  or error("Failed to open debug file")
	-- campFile:write(camp_str)																		--save new data
	-- campFile:close()

	-- print("AssignedFrequencies()")
	-- os.execute 'pause'
end






-------------------------------------------------------------------
-- START Get Frequency NG
----------------------------------------------------------------


local EmergencyFreq = {
    [121.5] = true,
    [243.0] = true,
}
-- local waveDefinitions = {
--     UHF  = { min = 225, max = 399.95 },
--     VHF  = { min = 116, max = 149.975 },
--     HF   = { min = 3,   max = 17.999 },
--     LVHF = { min = 30,  max = 75.95 },
-- }

local wavePriority = {
	blue = {
		plane = { "UHF", "VHF", "HF", "LVHF" },
		helicopter = {  "LVHF", "VHF", "UHF", "HF", }
	},
	red = {
		plane = {  "VHF", "UHF", "HF", "LVHF" },
		helicopter = {  "LVHF", "VHF", "UHF", "HF", }
	}
}

local specialTasks = {
    EWR = true,
    AWACS = true,
    Refueling = true,
    AFAC = true,
	player = true,
	playerInPackage = true,
}


local function rangeIntersectsWave(range, wave)
    local waveDef = RADIO_WAVES[wave]
    if not waveDef then
        return false
    end

    return range.max >= waveDef.min
       and range.min <= waveDef.max
end


local function getRangesForContext(side, task, type_withData, flightOrPackage)
	print("getRangesForContext A called for side "..tostring(side).." task "..tostring(task).." type_withData "..tostring(type_withData).." flightOrPackage "..tostring(flightOrPackage))
	-- cas spécial : réseaux commandement joueur

	if specialTasks[task] and side == PlayerSide and (not type_withData or not IsHelicopter[type_withData]) then
		if not IsHelicopter[type_withData] then
			for _, wave in ipairs(wavePriority[side].plane) do
				for n, dataFreq in ipairs(RadioPlayerWaveRanges or {}) do
					if rangeIntersectsWave(dataFreq, wave) then
						print("getRangesForContext B special task "..tostring(task).." wave "..tostring(wave).." freq range "..tostring(dataFreq.min).." - "..tostring(dataFreq.max))
						return wave, { dataFreq }
					end
				end
			end
		end
	end

    -- cas normal : coalition
	if not IsHelicopter[type_withData] then
		for _, wave in ipairs(wavePriority[side].plane) do
			if RadioWaveCommon[side] and RadioWaveCommon[side][wave] then
				print("getRangesForContext C normal plane wave "..tostring(wave))
				return wave, { RadioWaveCommon[side][wave] }
			end
		end
	else
		if flightOrPackage == "FreqFlight" and RadioWaveCommon[side] and RadioWaveCommon[side]["LVHF"] then
			print("getRangesForContext D1 normal helicopter wave "..tostring("LVHF"))
			return "LVHF", { RadioWaveCommon[side]["LVHF"] }
		elseif flightOrPackage == "FreqPackage" and RadioWaveCommon[side] and RadioWaveCommon[side]["UHF"] then
			print("getRangesForContext D2 normal helicopter wave "..tostring("UHF"))
			return "UHF", { RadioWaveCommon[side]["UHF"] }
		end

		for _, wave in ipairs(wavePriority[side].helicopter) do
			if RadioWaveCommon[side] and RadioWaveCommon[side][wave] then
				print("getRangesForContext D3 normal helicopter wave "..tostring(wave))
				return wave, { RadioWaveCommon[side][wave] }
			end
		end
	end

    return nil, {}
end



local function generateRandomFrequency(ranges)

	local step = 0.05
	local range

	-- Normalisation du range
	if ranges.min and ranges.max then
		range = ranges
	elseif type(ranges) == "table" and #ranges > 0 then
		range = ranges[math.random(1, #ranges)]
	else
		return nil
	end

	if not range.min or not range.max then
		return nil
	end

	local min = math.ceil(range.min / step) * step
	local max = math.floor(range.max / step) * step
	local count = math.floor((max - min) / step)

	if count <= 0 then
		return nil
	end

	local freq
	local safety = 0

	repeat
		local index = math.random(0, count)
		freq = min + index * step

		-- normalisation décimale
		freq = math.floor(freq * 100 + 0.5) / 100

		safety = safety + 1
		if safety > 200 then
			return nil
		end

	until not EmergencyFreq[freq]
	   and not Assigned_freq[freq]

	return freq
end

function GetFrequencyNG(side, target_name, task, type_withData, wave, flightOrPackage, groupName)

	AssignedTargetFrequency[side] = AssignedTargetFrequency[side] or {}
	AssignedGroupFrequency = AssignedGroupFrequency or {}
	AssignedGroupFrequency[side] = AssignedGroupFrequency[side] or {}

	if target_name then
		AssignedTargetFrequency[side][target_name] = AssignedTargetFrequency[side][target_name] or {}
	end

	----------------------------------------------------------------
	-- 1. CACHE GROUPE (prioritaire mais différencié Flight/Package)
	----------------------------------------------------------------
	local groupKey = nil

	if groupName and type_withData and flightOrPackage then
		local root = string.gsub(groupName, "%s%d+$", "")
		groupKey = type_withData .. "|" .. root .. "|" .. flightOrPackage

		if AssignedGroupFrequency[side][groupKey] then
			return AssignedGroupFrequency[side][groupKey]
		end
	end

	----------------------------------------------------------------
	-- 2. CACHE CLASSIQUE
	----------------------------------------------------------------
	if target_name and flightOrPackage and AssignedTargetFrequency[side][target_name][flightOrPackage] then
		return AssignedTargetFrequency[side][target_name][flightOrPackage]
	end

	----------------------------------------------------------------
	-- 3. RANGES
	----------------------------------------------------------------
	local selectedWave
	local ranges = {}

	if wave then
		selectedWave = wave

		if RadioWaveCommon[side] and RadioWaveCommon[side][wave] then
			ranges = { RadioWaveCommon[side][wave] }
		end
	else
		selectedWave, ranges = getRangesForContext(side, task, type_withData, flightOrPackage)
	end

	----------------------------------------------------------------
	-- 4. GÉNÉRATION
	----------------------------------------------------------------
	local freq = generateRandomFrequency(ranges)
	if not freq then return nil end

	----------------------------------------------------------------
	-- 5. SAUVEGARDE
	----------------------------------------------------------------
	if groupKey then
		AssignedGroupFrequency[side][groupKey] = freq
	end

	if target_name and flightOrPackage then
		AssignedTargetFrequency[side][target_name][flightOrPackage] = freq
	end

	return freq
end

-- function GetFrequencyNG(side, target_name, task, type_withData, wave, flightOrPackage)
-- 	-- print("GetFrequencyNG A called for side "..tostring(side).." target_name "..tostring(target_name).." task "..tostring(task).." type_withData "..tostring(type_withData).." wave "..tostring(wave))

-- 	AssignedTargetFrequency[side] = AssignedTargetFrequency[side] or {}

-- 	if target_name then
-- 		AssignedTargetFrequency[side][target_name] = AssignedTargetFrequency[side][target_name] or {}
-- 	end


--     -- 1. Cache par cible
--     if target_name and flightOrPackage and AssignedTargetFrequency[side][target_name][flightOrPackage] then
-- 		-- print("GetFrequencyNG B returning cached frequency for target "..tostring(target_name).." flightOrPackage: " .. tostring(flightOrPackage) .. " freq "..tostring(AssignedTargetFrequency[side][target_name][flightOrPackage]))
--         return AssignedTargetFrequency[side][target_name][flightOrPackage]
--     end

--     local selectedWave
--     local ranges = {}

--     -- 2. Wave forcée
--     if wave then
--         selectedWave = wave
-- 		-- print("GetFrequencyNG C1 wave forced "..tostring(wave).." for side "..tostring(side).." task "..tostring(task).." type_withData "..tostring(type_withData))
--         if RadioWaveCommon[side] and RadioWaveCommon[side][wave] then
-- 			-- print("GetFrequencyNG C2 wave forced "..tostring(wave).." found for side "..tostring(side))
--             ranges = { RadioWaveCommon[side][wave] }
--         end

--     else
--         -- 3. Choix automatique
-- 		-- print("GetFrequencyNG D automatic wave selection for side "..tostring(side).." task "..tostring(task).." type_withData "..tostring(type_withData))
--         selectedWave, ranges = getRangesForContext(side, task, type_withData, flightOrPackage)
--     end

--     -- 4. Génération fréquence
--     local freq = generateRandomFrequency(ranges)
--     if not freq then return nil end

--     -- 5. Cache si target
--     if target_name and flightOrPackage then
--         AssignedTargetFrequency[side][target_name][flightOrPackage] = freq
--     end

-- 	-- print("GetFrequencyNG F returning frequency "..tostring(freq).." for side "..tostring(side).." target_name "..tostring(target_name).." task "..tostring(task).." type_withData "..tostring(type_withData).." wave "..tostring(selectedWave))
--     return freq
-- end

----------------------------------------------------------------
-- FIN FIN Calcul Range Radio NG FIN
----------------------------------------------------------------

----------------------------------------------------------------
-- START START FreqCapabilityNG START
----------------------------------------------------------------
---
local function freqInRange(freq, range)
    if not range or not range.min or not range.max then
        return false
    end
    return freq >= range.min and freq <= range.max
end

function FreqCapabilityNG1(arg_testFreq, arg_type)

    local freq = tonumber(arg_testFreq)
    if not freq then
        return false
    end

    local db = Db_Frequency[arg_type]
    if not db then
        return false
    end

    ------------------------------------------------------------------
    -- 1. HUMAN RADIO
    ------------------------------------------------------------------
    if db.HumanRadio then
        local hr = db.HumanRadio

        -- Cas 1 : rangeFrequency (le PLUS restrictif)
        if hr.rangeFrequency then
            for _, r in ipairs(hr.rangeFrequency) do
                if freqInRange(freq, r) then
                    return true
                end
            end
        else
            -- Cas 2 : minFrequency / maxFrequency
            if hr.minFrequency and hr.maxFrequency then
                if freq >= hr.minFrequency and freq <= hr.maxFrequency then
                    return true
                end
            end
        end
    end

    ------------------------------------------------------------------
    -- 2. PANEL RADIO
    ------------------------------------------------------------------
    if db.panelRadio then
        for _, radio in ipairs(db.panelRadio) do

            -- Cas 1 : range sous forme de liste
            if radio.range and type(radio.range) == "table" then
                -- range[1..n]
                if radio.range[1] then
                    for _, r in ipairs(radio.range) do
                        if freqInRange(freq, r) then
                            return true
                        end
                    end
                else
                    -- range simple
                    if freqInRange(freq, radio.range) then
                        return true
                    end
                end
            end
        end
    end

    ------------------------------------------------------------------
    -- 3. AUCUNE RADIO COMPATIBLE
    ------------------------------------------------------------------
    return false
end
----------------------------------------------------------------
-- FIN FIN FreqCapabilityNG FIN
----------------------------------------------------------------


----- function to assign frquencies to packages -----

-- pour information, voici les plages utilisées en aéronautique (les valeurs fluctuent en fonction des organisations):
-- UHF 	: superieur à 225 Mhz	(Ultra Haute Frequence)
-- VHF 	: 100 à 225 Mhz			(Very Haute Frequence)
-- LVHF 	: 20 à 100 Mhz			(Low VHF, trompeusement dénommé FM, FM et AM sont des modulations de freq ou d'amplitude) (Occidental)
-- HF 		: 1 à 10 Mhz 			(Haute Fréquence)(Russe)
local waveRef = {
	["UHF"] = {
		min = 225,
		max = 400,
	},
	["VHF"] = {
		min = 100,
		max = 225,
	},
	["LVHF"] = {
		min = 20,
		max = 100,
	},
	["HF"] = {
		min = 1,
		max = 10,
	},
}
function FoundWave(range)
	-- _affiche(range, "UtilF AA range testing")
	for waveName, wave in pairs(waveRef) do
		if range.min >= wave.min and range.max <= wave.max then
			-- print("UtilF CC return waveName "..tostring(waveName))

			return waveName
		end
	end
	return false
end

--renommer les clefs, c'est obligatoire
-- les tables loadouts sauvegardé par le campaignMaker dans aved Games\DCS\MissionEditor\UnitPayloads
-- sont inutilisable dans le fichier mission, tel quel
local function loadoutPylon(loadoutTable)
	for plane, loadoutByTask in pairs(loadoutTable) do
		for task, ltable in pairs(loadoutByTask) do
			for loadoutName, loadout in pairs(ltable) do

				local newSortPylons = {}
				local newSort = false
				if loadout.stores and loadout.stores.pylons then

					for chapterN, emport in pairs(loadout.stores.pylons) do
						if emport.num and emport.num ~= chapterN then
								-- print("UtilF incoherence pylon N and Num: "..tostring(plane).." "..tostring(task).." "..tostring(loadoutName).." "..tostring(chapterN))
							newSort = true
						end
					end

					if newSort then
						for chapterN, emport in pairs(loadout.stores.pylons) do

							if not emport.num then
								-- AddLog("UtilF bug with plane "..plane.." loadoutName: "..loadoutName)
							else
								newSortPylons[emport.num] =
								{
									["CLSID"] =	emport.CLSID,
								}
								if emport.settings then
									newSortPylons[emport.num]["settings"] = emport.settings
								end
								newSort = true
							end


						end
					else
						for chapterN, emport in pairs(loadout.stores.pylons) do
							emport.num = nil

						end
					end
				end

				if newSort then
					loadout.stores.pylons = newSortPylons
				end

				--deletes deprecated variables
				if loadout.capability then
					loadout.capability = nil
				end
			end
		end
	end
	return loadoutTable
end


local function mergeTablesDeep(target, source)
    for k, v in pairs(source) do
        if type(v) == "table" then
            target[k] = target[k] or {}
            mergeTablesDeep(target[k], v)
        else
            target[k] = v
        end
    end
end

function LoadAllLoadouts(subFolder)

	-- récupère le chemin du script actuel (UTIL_Functions.lua)
	local currentScript = debug.getinfo(1).source:sub(2)
	local baseDir = currentScript:match("(.*/)") or "./"

    -- 1) ON PART DE LA TABLE ORIGINALE (celle de DCE)
    local final = {}
    if db_loadouts and type(db_loadouts) == "table" then
        final = DeepCopy(db_loadouts)
    else
        -- print("DCE WARNING : aucun db_loadouts initial trouvé !")
    end

    local folder = baseDir .. subFolder
    local cmd = 'dir "' .. folder .. '" /b'

    local p = io.popen(cmd)
    if not p then
        -- print("DCE ERROR : impossible d’ouvrir le dossier : " .. folder)
		AddLog("DCE ERROR : impossible d’ouvrir le dossier : " .. folder)
        return final
    end

    for file in p:lines() do
        if file:match("%.lua$") then

            local fullpath = folder .. "/" .. file
            -- print("DCE : loading loadout -> " .. fullpath)

            db_loadouts = nil  -- IMPORTANT : on purifie avant le dofile

            local ok, err = pcall(function()
                dofile(fullpath)
            end)

            if not ok then
                -- print("DCE ERROR : erreur dans " .. fullpath .. " : " .. err)
				AddLog("DCE ERROR : erreur dans " .. fullpath .. " : " .. err)

            elseif db_loadouts then
                -- MERGE ici : final = final + db_loadouts
                mergeTablesDeep(final, db_loadouts)

                db_loadouts = nil  -- nettoyage
            end
        end
    end

    p:close()
    return final
end



-- Charge les mods d'un dossier, exécute chaque fichier dans un env isolé
-- relativeFolder = "../../../Missions/Campaigns/"..camp.title.."/Mods" par exemple
-- ACCEPT_NEW_TABLES = true --toutes les tables créées par le mod seront ajoutées à _G
function LoadModData(relativeFolder, ACCEPT_NEW_TABLES)
    ACCEPT_NEW_TABLES = not not ACCEPT_NEW_TABLES    -- bool
    local fullFolder = "../../../Missions/Campaigns/"..camp.title.."/"..relativeFolder
    -- print("DCE : Scanning Mods folder : " .. tostring(fullFolder))

    local cmd = 'dir "' .. fullFolder .. '" /b'
    local p = io.popen(cmd)
    if not p then
        -- print("DCE ERROR : impossible de lire le dossier Mods : " .. fullFolder)
        return
    end

    for file in p:lines() do
        if file:match("%.lua$") then
            local fullpath = fullFolder .. "/" .. file
            -- print("DCE : Chargement MOD -> " .. fullpath)

            -- load the chunk (file) without executing it globally
            local chunk, loadErr = loadfile(fullpath)
            if not chunk then
                -- print("DCE ERROR : loadfile failed for " .. fullpath .. " : " .. tostring(loadErr))
            else
                -- create an isolated env that falls back to _G for reads (so mod can call DCE functions)
                local env = {}
                setmetatable(env, { __index = _G })

                -- set this env as the chunk's environment (Lua 5.1)
                setfenv(chunk, env)

                -- execute the chunk safely
                local ok, execErr = pcall(chunk)
                if not ok then
                    -- print("DCE ERROR : execution failed for " .. fullpath .. " : " .. tostring(execErr))
                else
                    -- enumerate what the mod defined in env
                    for k, v in pairs(env) do
                        -- skip metamethods and inherited keys (if index produced inherited, pairs won't show them)
                        if type(k) == "string" then
                            -- only consider tables defined by the mod (ignore functions, numbers...)
                            if type(v) == "table" then
                                -- print("DCE : Table détectée dans MOD '" .. file .. "' : " .. tostring(k))

                                -- si DCE (global) a déjà une table du même nom -> merge dedans
                                if type(_G[k]) == "table" then
                                    -- print("DCE : Fusion dans DCE -> " .. tostring(k))
                                    mergeTablesDeep(_G[k], v)
                                else
                                    -- table nouvelle, décider selon ACCEPT_NEW_TABLES
                                    if ACCEPT_NEW_TABLES then
                                        -- print("DCE : Ajout d'une nouvelle table globale -> " .. tostring(k))
                                        _G[k] = v
                                    else
                                        -- print("DCE : Table nouvelle ignorée (pour l'instant) -> " .. tostring(k))
                                    end
                                end
                            else
                                -- si le mod définit des scalaires ou fonctions globaux qu'on souhaite conserver ou logger
                                -- par défaut on ignore pour éviter de polluer _G
                                -- Si tu veux autoriser certaines clés non-table, tu peux les whitelist ici.
                            end
                        end
                    end
                end
            end
        end
    end

    p:close()
end


-- modification M49.a big central db_loadout

function BuildLoadout()

	if not camp.AuthorizedLoadout then
		camp.AuthorizedLoadout = {}
	end
	local addLoadoutsTag = false
	-- campaigns_code_loadout = { 
		-- ["Cyprus"] =		"Cyprus Incident",
		-- ["Crisis"] = 		"Crisis in PG",
		-- ["PG"] = 			"Over PG",
		-- ["Caucasus"] = 		"Over Caucasus",
		-- ["TF"] = 			"TF-71",             
		-- ["TF80s"] = 		"TF-71-80s",           
		-- ["TF80sRED"] = 		"TF-71-Fishbed-80s",   
		-- ["IPW71"] = 		"India Pak War 71",    
		-- ["HWITC"] = 		"Hot War in the Cold",
		-- ["IIW"] = 			"Iran Iraq War",
	-- }   



	if campMod.selectLoadout == "init" then
		require("Init/db_loadouts")
	else
		-- charge le loadout central en premier pour avoir la table de code_loadout
		-- Charge toute la base
		db_loadouts = LoadAllLoadouts("db_loadouts")
	end

	-- Fonction pour compter les mots dans une chaîne
	local function word_count(input)
		local count = 0
		for word in string.gmatch(input, "%S+") do
			count = count + 1
		end
		return count
	end



	-- cherche le code a appliquer au loadout, pour charger le bon..loadout ^^
	-- if (not ( campConfMod and campConfMod.code_loadout) and campaigns_code_loadout )then
	if (campaigns_code_loadout )then
		local bestMatch = nil
		local bestMatchCount = 0
		-- campConfMod = {}

		-- Parcourir la table des codes
		for codeName, prefix_s in pairs(campaigns_code_loadout) do
			if type(prefix_s) == "table" then
				-- Plusieurs mots-clés à vérifier
				local matchCount = 0
				for _, prefix in ipairs(prefix_s) do
					if string.find(string.lower(camp.title), string.lower(prefix)) then
						matchCount = matchCount + 1
					end
				end
				-- Mise à jour du meilleur match
				if matchCount > bestMatchCount then
					bestMatch = codeName
					bestMatchCount = matchCount
				end
			else
				-- Un seul mot-clé à vérifier
				if string.find(string.lower(camp.title), string.lower(prefix_s)) then
					local number_of_words = word_count(prefix_s)
					if number_of_words > bestMatchCount then
						bestMatch = codeName
						bestMatchCount = 1
					elseif prefix_s == camp.title then
						bestMatch = codeName
						bestMatchCount = 100
					end

					if bestMatchCount < 1 then -- Priorité pour les correspondances plus spécifiques
						bestMatch = codeName
						bestMatchCount = 1
					end
				end
			end
		end

		-- campConfMod.code_loadout = bestMatch
		camp.code_loadout = bestMatch
	end


	if Debug.debug then
		print("UtilF camp.title |"..camp.title.."| campConfMod.code_loadout |"..tostring(camp.code_loadout) )
	end

	-- helper: vérifie si le loadout est autorisé par restrictedCondition
	local function allowed_by_restriction(loadData)
		if not loadData.restrictedCondition then
			return true
		end
		if type(loadData.restrictedCondition) == "string" then
			for _, campAuth in pairs(camp.AuthorizedLoadout) do
				if string.lower(tostring(loadData.restrictedCondition)) == string.lower(tostring(campAuth)) then
					return true
				end
			end
			return false
		end
		if not camp.AuthorizedLoadout then
			return true
		end
		for _, conditionName in pairs(loadData.restrictedCondition) do
			for _, campAuth in pairs(camp.AuthorizedLoadout) do
				if string.lower(tostring(conditionName)) == string.lower(tostring(campAuth)) then
					return true
				end
			end
		end
		return false
	end

	-- helper: vérifie si le code_loadout correspond à la configuration de la campagne
	local function codes_match(value, campaign_code)
		if not value.code_loadout or value.code_loadout == "" then
			return true
		end
		if not campaign_code or campaign_code == "" then
			return true
		end
		-- accepter une chaîne ou une table
		if type(value.code_loadout) == "string" then
			return string.lower(value.code_loadout) == string.lower(campaign_code) or string.lower(value.code_loadout) == "all"
		end
		if type(value.code_loadout) == "table" then
			for _, code in pairs(value.code_loadout) do
				if string.lower(tostring(code)) == string.lower(campaign_code) or string.lower(tostring(code)) == "all" then
					return true
				end
			end
		end
		return false
	end

	-- helper: vérifie si 
	local function plane_match(planeLoadout)

		for sideName, squads in pairs(oob_air) do
			for squadN, squad in pairs(squads) do
				if string.lower(squad.type) == string.lower(planeLoadout) then
					return true
				end
			end
		end
		return false
	end

	local function add_loadout(plane, taskName, loadoutName, value)
		LoadoutsList[plane] = LoadoutsList[plane] or {}
		LoadoutsList[plane][taskName] = LoadoutsList[plane][taskName] or {}
		LoadoutsList[plane][taskName][loadoutName] = value
	end

	for plane, planeTab in pairs(db_loadouts) do
		if plane_match(plane) then
			for taskName, loadout in pairs(planeTab) do
				for loadoutName, loadData in pairs(loadout) do
					if codes_match(loadData, camp.code_loadout) then
						if allowed_by_restriction(loadData) then
							add_loadout(plane, taskName, loadoutName, loadData)
						end
					end
				end
			end
		end
	end


	if campaigns_code_loadout and not addLoadoutsTag then
		for planeType, plane  in pairs(LoadoutsList) do
			for taskName, loadouts in pairs(plane) do
				for loadoutName, loadout  in pairs(loadouts) do
					-- print("UtilF "..plane.." "..taskName.." "..loadoutName)
					if loadout and loadout.code_loadout and loadout.code_loadout ~= "" then
						for code_loadout_number, code in ipairs(loadout.code_loadout) do
							if not campaigns_code_loadout[code]  then	--and not string.lower(code) == "all"

								if  string.lower(code) ~= "all"  then

									local bugTxt = ""..planeType.." ||| "..taskName.." ||| "..loadoutName.." ||| "..code.." not found in campaigns_code_loadout****************"
									AddLog("Note for the Campaign Maker"..bugTxt)
								end
							else
								-- print("UtilF camp.code_loadout "..camp.code_loadout.." found")						
							end
						end
					end
				end
			end
		end
	end


	LoadoutsList = loadoutPylon(LoadoutsList)

	-- copy_all_loadouts = makeStrutureLoadout(copy_all_loadouts)

	if Debug.debug then
		local test_loadouts = DeepCopy(LoadoutsList)
		test_loadouts = makeStrutureLoadout(test_loadouts)

		local test_str = "db_loadouts = " .. TableSerializationLoadout(test_loadouts, 0, 0)						--make a string	
		local testFile = io.open("Debug/loadouts_clean.lua", "w") or error("Failed to open debug file")
		testFile:write(test_str)															--save new data
		testFile:close()

		-- if db_loadouts then

		-- 	local copy_all_loadouts = Deepcopy(db_loadouts)
		-- 	copy_all_loadouts = loadoutPylon(copy_all_loadouts)

		-- 	copy_all_loadouts = makeStrutureLoadout(copy_all_loadouts)

		-- 	test_str = "db_all_loadouts = " .. TableSerializationLoadout(copy_all_loadouts, 0, 0)						--make a string	
		-- 	testFile = io.open("Debug/loadouts_global_clean.lua", "w") or error("Failed to open debug file")
		-- 	testFile:write(test_str)															--save new data
		-- 	testFile:close()
		-- end
	end
end




-- modification M54		revoir CustomTaskScript et TaskBombing
-- check si tous les avions pr�vu dans oob_air ont leur task d�clar� possible dans la table TaskByPlane
local error = 0
local debugTempFLIGHT
function Check_TaskPossibleByPlane()

	-- StrikeCombi = {
		-- ["CAS"] = false,
		-- ["Ground Attack"] = false,
		-- -- ["Runway Attack"] = false,
		-- ["Pinpoint Strike"] = true,
	-- }

	--**
	--deprecated
	--**
	-- --si ADD_data existe, on le precharge pour l'ajouter au DATA centram
	-- local addDataFile02 = "../../../Missions/Campaigns/"..camp.title.."/Init/ADD_data.lua"
	-- local testPathADD_addData = io.open(addDataFile02, "r")										--cette maniere de chercher la presence d un fichier evite un plantage
	-- if testPathADD_addData ~= nil  then														--check si le fichier existe dans ScriptsMod
	-- 	dofile("../../../Missions/Campaigns/"..camp.title.."/Init/ADD_data.lua")

	-- 	if add_EPLRS_Capacity then
	-- 		for key , value in pairs(add_EPLRS_Capacity) do
	-- 			if not EPLRS_Capacity[key] then
	-- 				EPLRS_Capacity[key] = true
	-- 			end
	-- 		end
	-- 	end

	-- 	if add_TaskByPlane then
	-- 		for task , plane in pairs(add_TaskByPlane) do
	-- 			for planeName , value in pairs(plane) do
	-- 				if  TaskByPlane[task] then
	-- 					if  not TaskByPlane[task][planeName] then
	-- 						TaskByPlane[task][planeName] = true
	-- 					end
	-- 				else
	-- 					TaskByPlane = {
	-- 						task = {
	-- 							planeName = true,
	-- 						}
	-- 					}
	-- 				end
	-- 			end
	-- 		end
	-- 	end

	-- end

	local checkOobAir = DeepCopy(oob_air)
	for side, squadTbl in  pairs(checkOobAir) do
		for squad_n, squad in  pairs(squadTbl) do

			local foundPlane = false

			if squad.tasks and type(squad.tasks) == "table" and not squad.inactive then

				-- StrikeCombi
				local addMultipleStrike = false
				for taskOA, valueOA in  pairs(squad.tasks) do
					if taskOA == "Strike" and valueOA == true  then
						addMultipleStrike = true
					end
				end

				--ajoute les vrais id des differents Strike
				if addMultipleStrike then
					squad.tasks["Strike"] = nil
					squad.tasks["CAS"] = true
					squad.tasks["Ground Attack"] = true
					squad.tasks["Pinpoint Strike"] = true
					-- squad.tasks["Runway Attack"] = true				
				end

				local foundStrikeTask = false
				for taskOA, valueOA in  pairs(squad.tasks) do

					local foundTask = false

					-- print("UtilF passe A "..taskOA.." valueOA: "..tostring(valueOA))

					if taskOA == "Escort Jammer" then
						taskOA = "Ground Attack"
					elseif taskOA == "Flare Illumination" then
						taskOA = "Ground Attack"
					elseif taskOA == "Laser Illumination" then
						taskOA = "AFAC"
					elseif taskOA == "Anti-ship Strike" then
						taskOA = "Antiship Strike"
					elseif taskOA == "SAR" or taskOA == "CSAR" then
						taskOA = "Transport"
					end

					if type(valueOA) ~= "boolean" then
						debugTempFLIGHT = "UtilF ATTENTION is not a boolean value for : "..tostring(squad.type).." "..tostring(taskOA)
						error = error + 1
					end

					if valueOA == true and TaskByPlane[taskOA] then
						for plane_TbP, value in  pairs(TaskByPlane[taskOA]) do
							if squad.type == plane_TbP   then
								foundPlane = true
								foundTask = true
								if taskOA == "CAS" or taskOA == "Ground Attack" or taskOA == "Pinpoint Strike"  then
									foundStrikeTask = true
								end
							end
						end

						--toutes les tasks sauf strike
						if not foundTask and not addMultipleStrike and not tostring(taskOA) == "Fighter Sweep" then
							debugTempFLIGHT = "(Error UutilF C01) this task, requested in Init\\oob_air_init.lua, is not listed in the UTIL_Data.lua file : "..tostring(squad.type).." "..tostring(taskOA)
							error = error + 1
						end

					elseif valueOA == true and not TaskByPlane[taskOA] and not tostring(taskOA) == "Fighter Sweep" then
						debugTempFLIGHT = "(Error UutilF C02) this task, requested in Init\\oob_air_init.lua, is not listed in the UTIL_Data.lua file : "..tostring(squad.type).." "..tostring(taskOA)
						error = error + 1
					end
				end

				--si aucune tasks strike n'a été trouvée
				if not foundStrikeTask and addMultipleStrike then
					debugTempFLIGHT = "(Error UutilF C03) this task, requested in Init\\oob_air_init.lua, is not listed in the UTIL_Data.lua file : "..tostring(squad.type).." "..tostring("Strike ( CAS or Ground Attack or Pinpoint Strike )")
					print(debugTempFLIGHT )
					AddLog(debugTempFLIGHT)
					error = error + 1
					-- os.execute 'pause'
				end
				if not squad.inactive and not foundPlane   then
					--TODO revoir ce pb, exemple avec campaign Hornet Over Carrier SC
					debugTempFLIGHT = "(Error UutilF C04)||"..tostring(squad.type).."||"..tostring(squad.name).."||  impossible to find a task/aircraft match with all files concerned ".." (oob_air_init or  UTIL_Data.lua or bad Task or bad boolean task)"
					AddLog(debugTempFLIGHT)

					for taskOA, valueOA in  pairs(squad.tasks) do
						debugTempFLIGHT = tostring(taskOA).." : "..tostring(valueOA)
						AddLog(debugTempFLIGHT)
					end
					error = error + 1
				end
			end
		end
	end
end

if error >= 1 then

	if BugList and type(BugList) == "table" and #BugList >= 1 then
		local table_Str = "BugList = " .. TableSerialization(BugList, 0)
		local bugFile = io.open("Debug/BugList.lua", "w") or error("Failed to open debug file")
		bugFile:write(table_Str)
		bugFile:close()
	end

	os.execute('start "BugList" "notepad.exe" "Debug/BugList.lua"')			--open the BugList file with notepad

	os.execute 'pause'
end

ParkOccupied = {}
function GetParkingId(parkingId, baseName)
	local s
	local counter = 0
	if not ParkOccupied[baseName]  then
		ParkOccupied[baseName] = {}
	end

	-- parking_id = {
	-- 	[""] = {25,26},                   --["C"] = {2,10},
	-- },	

	for prefix, value in pairs(parkingId) do
		local valueCopy = DeepCopy(value)
		counter = 0
		local single = false
		local singleTest = string.lower(tostring(valueCopy[1]))

		--signifie que l'on prend uniquement les chiffres proposé, on ne prend pas la plage entre 2 chiffres
		if singleTest == "single" then
			single = true
			table.remove(valueCopy, 1)
		end

		if #valueCopy == 2 and not single then
			local lower = tonumber(valueCopy[1])
			local upper = tonumber(valueCopy[2])

			-- Validation explicite que lower et upper sont des entiers
			if lower and upper then
				repeat
					counter = counter + 1
					local randomValue = math.random(math.floor(lower), math.floor(upper)) -- Forcer en entiers
					s = prefix .. randomValue
				until ParkOccupied[baseName][s] == nil or counter == 100
			else
				AddLog("Error: GetParkingId(): Range limits are not valid numbers."..baseName.." prefix: "..tostring(prefix))
			end
		elseif #valueCopy > 2 or single then
			repeat
				counter = counter + 1
				local r = math.random(1,#valueCopy)
				s = valueCopy[r]
				-- s = prefix..string.format("%02d", s)
				s = prefix.. s
			until ParkOccupied[baseName][s] == nil 	or counter == 100
		end

		if ParkOccupied[baseName][s] == nil then
			break
		end
	end

	--ne trouve pas de place libre:
	if counter >= 100 then
		AddLog("GetParkingId() G no parking id available for base "..tostring(baseName))
		return false
	end

	ParkOccupied[baseName][s] = true

	return tostring(s)

end

--function to check if point is in polygon
--function repris de Mbot dans DC_NavalEnvironment
function CheckPointInPolygonINIT(point, poly)
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

--https://stackoverflow.com/questions/31730923/check-if-point-lies-in-polygon-lua
function CheckPointInPolygon(point, polygon, show)
    local oddNodes = false
    local j = #polygon
    for i = 1, #polygon do

        if (polygon[i].y < point.y
		and polygon[j].y >= point.y
		or polygon[j].y < point.y
		and polygon[i].y >= point.y) then
            if (polygon[i].x + ( point.y - polygon[i].y ) / (polygon[j].y - polygon[i].y) * (polygon[j].x - polygon[i].x) < point.x) then
                oddNodes = not oddNodes;
            end
        end
        j = i;
    end
    return oddNodes
end


function UpdateConfMod(setWeather, setDate, from)
	if setWeather then
		UpdateConfModSuite(setWeather, nil, "UpdateConfMod:"..tostring(from))
	end
	if setDate then
		--mis à jour via camp_triggers et DC_CheckTriggers
		camp.date = setDate

		UpdateConfModSuite(nil, setDate, "UpdateConfMod:"..tostring(from))
	end
end

--met à jour automatiquement le conf_mod en fonction des nouveautés apporté par UTIL_ConfModCheck
function UpdateConfModSuite(setWeather, setDate, from)
    --version UpdateConfMod VA_1.12

	local weather_override
	local date_override

	-- if camp.mission == 1 then
	if Firstmission_flag then
		if camp.weather and camp.weather.pHigh then
			weather_override = camp.weather
		else
			dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_ConfModCheck.lua")
			weather_override = mission_ini_check.weather

		end

		if camp.date and camp.date.year then
			date_override = camp.date
		else
			dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_ConfModCheck.lua")
			date_override = mission_ini_check.date

		end

	else

		-- dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_ConfModCheck.lua")
		-- date_override = mission_ini_check.date

		-- if Debug.debug then
		-- 	print("date_override 4 date_override = mission_ini_check.date ")
		-- end
	end

	--mis à jour via camp_triggers et DC_CheckTriggers
	if setWeather then
		weather_override = setWeather
	end

	--mis à jour via camp_triggers et DC_CheckTriggers
	if setDate then
		date_override = setDate
		-- camp.date = setDate

		-- if Debug.debug then
		-- 	print("date_override 5: camp.date = setDate ")
		-- 	_affiche(date_override, "date_override 5: setDate ")
		-- end
	end

    -- Fonction pour charger la configuration avec la structure	
	local function loadConfigWithStructure(filePath)
		-- version loadConfigWithStructure VA_1.38b
		local config = {}
		local structure = {}
		local stack = {}
		local currentTable = config
		local currentKey = nil
		local pendingTable = nil -- Stocker temporairement le nom d'une table qui attend `{`

		for line in io.lines(filePath) do
			line = line:gsub("_check", "") -- Supprimer "_check"

			-- print("\nLCWS A "..line) -- Debug simple sans icône

			-- Ignorer les lignes commentées
			if line:match("^%s*%-%-") then
				table.insert(structure, line)

			-- Ignorer les lignes versionDCE
			elseif line:match("versionDCE") then

			else
				table.insert(structure, line) -- Stockage brut de la structure du fichier

				-- Détection des structures Lua
				local singleLineTable = line:match("(%S+)%s*=%s*{(.-)}%s*,?%s*$")
				local tableStart = line:match("(%S+)%s*=%s*{")
				local tableEnd = line:match("^%s*}%s*[,]?")
				local listValue = line:match('^%s*"(.-)",?%s*$')
				local tableStartUnique = line:match('%["([^"]+)"%]%s*=%s*$') or line:match("(%S+)%s*=%s*$")

				local key, value, comment = line:match('(%S+)%s*=%s*(["]?[%w%s%p]+["]?)%s*,?%s*%-%-%s*(.*)')
				-- print("lCWS AA1 value?: "..tostring(value))
				if not key then
					key, value = line:match('(%S+)%s*=%s*(["]?[%w%s%p]+["]?)%s*,?')
					-- print("lCWS AA2 value?: "..tostring(value))

				end


				--  Tables sur une seule ligne (ex: `x = {1, 2, 3}`)
				if singleLineTable then
					-- print("LCWS B ")
					local name, contents = line:match("(%S+)%s*=%s*{(.-)}")
					local newTable = {}
					for valueB in contents:gmatch("[^,]+") do
						valueB = valueB:match("^%s*(.-)%s*$") -- Supprimer les espaces blancs
						newTable[#newTable + 1] = tonumber(valueB) or valueB
					end
					currentTable[name] = newTable

				--`pictureBrief =` suivi de `{` sur la ligne suivante
				elseif tableStartUnique then
					-- print("LCWS C ")
					pendingTable = tableStartUnique -- Retenir le nom de la table

				elseif line:match("^%s*{%s*$") and pendingTable then
					-- print("\nLCWS D ")
					currentTable[pendingTable] = {} -- Créer la table
					table.insert(stack, { table = currentTable, key = currentKey }) -- Sauvegarde du contexte
					currentTable = currentTable[pendingTable]
					currentKey = pendingTable
					pendingTable = nil -- Réinitialisation

				--Tables classiques (`key = {`)
				elseif tableStart then
					-- print("LCWS E ")

					if not currentTable[tableStart] then
						currentTable[tableStart] = {} -- Créer la table si elle n'existe pas
					end
					table.insert(stack, { table = currentTable, key = currentKey })
					currentTable = currentTable[tableStart]
					currentKey = tableStart


				--`blue = {` et `red = {` sous `pictureBrief`
				elseif (line:match("^%s*(blue|red)%s*=%s*{") or line:match("^%s*%[%d+%]%s*=%s*{")) and currentKey == "pictureBrief" then
					-- print("LCWS F ")
					local subKey = line:match("^%s*(blue|red)%s*=%s*{") or line:match("^%s*%[(%d+)%]%s*=%s*{")
					if not currentTable[subKey] then
						currentTable[subKey] = {}
					end
					table.insert(stack, { table = currentTable, key = currentKey })
					currentTable = currentTable[subKey]
					currentKey = subKey

				--Fermeture de table (`}`)
				elseif tableEnd then
					-- print("LCWS G ")
					if #stack > 0 then
						local popped = table.remove(stack)
						currentTable = popped.table
						currentKey = popped.key
					end

				--Détection des listes `"texte",`
				elseif listValue then
					-- print("LCWS H ")

					table.insert(currentTable, listValue)

				--Détection des valeurs indexées `[1] = "..."``
				elseif line:match("^%s*%[%d+%]%s*=%s*") then
					-- print("LCWS I ")
					local index, listValueB = line:match("^%s*%[(%d+)%]%s*=%s*\"(.-)\"")
					if index and listValueB and currentKey then

						currentTable[tonumber(index)] = listValueB

					end
				--Variables classiques `key = value`
				elseif key and value then
					--   Suppression propre des `,` et espaces parasites en fin de valeur
					value = value:match("^%s*(.-)%s*$") -- Trim des espaces inutiles
					value = value:gsub(",%s*$", "")     -- Supprimer `,` en fin de ligne

					--   Conversion propre en nombre
					local numValue = tonumber(value)
					-- print("LCWS J2 "..tostring(value))
					currentTable[key] = numValue or value  -- Si c'est un nombre, on le stocke en tant que nombre


				end
			end
		end

		return config, structure
	end

	--   Fonction pour récupérer la vraie valeur (sans toujours mettre des strings)
	local function getFormattedValue(value)

		--   Si `value` est une table contenant { value = ..., comment = ... }
		if type(value) == "table" and value.value ~= nil then
			return getFormattedValue(value.value) -- Récupérer directement `value`
		end

		--   Gestion des types normaux (string, booléens, nombres)
		if type(value) == "string" then
			if value == "true" or value == "false" then
				return value -- Garder sans guillemets
			elseif tonumber(value) then
				return value -- Convertir en nombre
			else
				return '"' .. value:gsub('"', '') .. '"' -- Supprime les doubles guillemets parasites
			end
		elseif type(value) == "boolean" then
			return tostring(value)
		elseif type(value) == "number" then
			return value
		elseif type(value) == "table" then
			--   Vérifier si c'est une liste indexée
			local isArray = (#value > 0) and (next(value, #value) == nil)

			if isArray then
				return "{ " .. table.concat(value, ", ") .. " }"  --   Format propre des listes !
			else
				local formattedTable = {}
				for k, v in pairs(value) do
					table.insert(formattedTable, "[" .. tostring(k) .. "] = " .. getFormattedValue(v))
				end
				return "{ " .. table.concat(formattedTable, ", ") .. " }"
			end

		else
			return tostring(value)
		end
	end

    -- Fonction pour supprimer les clés obsolètes
    local function removeObsoleteEntries(clientConfig, referenceConfig)
        --version removeObsoleteEntries VA_1.12
        local function deepClean(clientTable, referenceTable)
            for key, value in pairs(clientTable) do
                if key ~= "pictureBrief" and key ~= "movedBullseye" then
					if type(value) == "table" then
						if not referenceTable[key] then
							clientTable[key] = nil  -- Supprime la table complète si elle est absente du modèle
						else
							deepClean(value, referenceTable[key])  -- Nettoie récursivement les sous-tables
						end
					elseif not referenceTable[key] then
						clientTable[key] = nil  -- Supprime les variables obsolètes
					end
				else

				end
            end
        end

        deepClean(clientConfig, referenceConfig)
        return clientConfig
    end

	local function mergeTables(clientTable, defaultTable, structure)
		for key, defaultValue in pairs(defaultTable) do

			local clientValue = clientTable[key]

			--   `pictureBrief` ne doit pas être touché
			if key == "pictureBrief" then
				-- print("[mergeTables] A `pictureBrief` préservé")

			--   `movedBullseye` doit fusionner **ET** accepter de nouvelles maps
			elseif key == "movedBullseye" and type(defaultValue) == "table" then
				-- print("[mergeTables] B Fusion `movedBullseye`")
				if type(clientValue) ~= "table" then
					-- print("[mergeTables] C `movedBullseye` absent dans clientTable, création.."..key)
					clientTable[key] = {}
					clientValue = clientTable[key]
				end

				--   Fusion normale des maps existantes
				mergeTables(clientValue, defaultValue, structure)

				--   Ajouter les nouvelles maps du client qui n'existent pas dans `defaultTable`
				for mapName, mapData in pairs(clientValue) do
					-- print("[mergeTables] D Map détectée :", mapName)
					if not defaultValue[mapName] then
						-- print("[mergeTables] E Nouvelle map ajoutée :", mapName)
						defaultValue[mapName] = DeepCopy(mapData) -- Ajoute la map à `config_default`

						--   Ajouter aussi `mapName` à `structure` pour garantir l'écriture
						table.insert(structure, "\t" .. mapName .. " = {")
						table.insert(structure, "\t\tpos = {")
						table.insert(structure, "\t\t\tx = " .. getFormattedValue(mapData.pos.x) .. ",")
						table.insert(structure, "\t\t\ty = " .. getFormattedValue(mapData.pos.y) .. ",")
						table.insert(structure, "\t\t},")
						table.insert(structure, "\t\trayon = " .. getFormattedValue(mapData.rayon) .. ",")
						table.insert(structure, "\t},")
					end
				end

			-- `weather` doit **toujours** être remplacé par `weather_override`
			elseif key == "weather" and weather_override then
				clientTable[key] = DeepCopy(weather_override)
			-- `current_date` doit **toujours** être remplacé par `date_override`
			elseif key == "current_date" and date_override then
				clientTable[key] = DeepCopy(date_override)
				-- _affiche(date_override, "date_override F1; ")
			-- Fusion normale des sous-tables
			elseif type(defaultValue) == "table" then
				if not clientValue then
					-- print("[mergeTables]   Copie de la table absente :", key)
					clientTable[key] = DeepCopy(defaultValue)
				elseif type(clientValue) == "table" then
					mergeTables(clientValue, defaultValue, structure)
				end

			-- Valeur simple : on applique la valeur par défaut si absente
			else
				if clientValue == nil then
					-- print("[mergeTables]   Valeur par défaut appliquée :", key)
					clientTable[key] = defaultValue
				end
			end
		end
	end

    -- Nouvelle fonction pour insérer les nouvelles tables et variables manquantes dans la structure
	local function updateConfiguration(clientConfig, defaultConfig)

		mergeTables(clientConfig, defaultConfig)

		return clientConfig  --   Ajout du retour de la table mise à jour !
	end



	local function saveUpdatedConfig(filePath, updatedConfig, structure)
		-- version saveUpdatedConfig VA_1.50 (Correction des valeurs sous forme de table et commentaires)

		if updatedConfig.mission_ini.weather and weather_override then
			for key, forcedValue in pairs(weather_override) do
				updatedConfig.mission_ini.weather[key] = forcedValue  -- **Écrase l'existant OU ajoute si absent**
			end
		end


		if updatedConfig.mission_ini.date and date_override then
			-- print("date_override 6 ")
			for key, forcedValue in pairs(date_override) do
				updatedConfig.mission_ini.date[key] = forcedValue  -- **Écrase l'existant OU ajoute si absent**
				-- print("date_override 7 ")
			end
		end

		local file = io.open(filePath, "w")
		if not file then error("Cannot open file for writing: " .. filePath) end

		local indentLevel = 0
		local stack = {}  -- Suivi des tables imbriquées

		--   Fonction d'indentation stricte
		local function getIndent(level)
			return string.rep("\t", level)
		end


		local function writeStructureLines(currentTable, structureLocal, level)

			for i, line in ipairs(structureLocal) do
				local trimmedLine = line:match("^%s*(.-)%s*$") -- Supprimer espaces début/fin
				-- print("A "..line)

				local key, value, comment = line:match('(%S+)%s*=%s*([^%s,]+)%s*,?%s*%-%-%s*(.*)')
				if not key then
					key, value = line:match('(%S+)%s*=%s*([^%s,]+)')
				end

				--   Conserver les commentaires et lignes vides
				if trimmedLine:match("^%-%-") or trimmedLine == "" then
					-- print("B "..getIndent(level) .. line .. "\n")
					file:write(getIndent(level) .. line .. "\n")

				--   Détection des tables sur une seule ligne
				elseif trimmedLine:match("(%S+)%s*=%s*{.-}%s*,?%s*$") then
					key = trimmedLine:match("(%S+)%s*=%s*{")
					local clientValue = currentTable[key]
					if clientValue then
						-- print("C1 "..getIndent(level) .. key .. " = " .. getFormattedValue(clientValue) .. ",\n")
						file:write(getIndent(level) .. key .. " = " .. getFormattedValue(clientValue) .. ",\n")
					end

				--   Détection de déclaration de table avec indentation correcte
				elseif trimmedLine:match("(%S+)%s*=%s*{") then
					key = trimmedLine:match("(%S+)%s*=%s*{")
					local clientValue = currentTable[key]
					if clientValue and type(clientValue) == "table" and next(clientValue) then
						-- print("D1 "..getIndent(level) .. key .. " = {\n")
						file:write(getIndent(level) .. key .. " = {\n")
						table.insert(stack, { name = key, table = currentTable })
						currentTable = clientValue
						level = level + 1
						-- print("D2 #stack "..tostring(#stack))
					end

					--   Détection des fermetures de table
					elseif trimmedLine:match("^%s*}%s*[,]?") then
						-- print("E1 #stack "..tostring(#stack))
						if #stack > 0 then
							local popped = table.remove(stack)
							currentTable = popped.table
							level = level - 1
						end

						--   Vérifier si on doit ajouter une virgule après `}`
						local nextLine = structureLocal[i + 1] or ""
						local addComma = not nextLine:match("^%s*}%s*$")

						if level > 0 then
							-- print("E2 "..getIndent(level) .. "}" .. (addComma and "," or "") .. "\n")
							file:write(getIndent(level) .. "}" .. (addComma and "," or "") .. "\n")
						else
							-- print("E3 "..getIndent(level) .. "}\n")
							file:write(getIndent(level) .. "}\n")
						end

				--   Gestion des affectations (Valeur + Commentaire propre)
				else

					-- key, value, comment = line:match('(%S+)%s*=%s*([^,%s]+)%s*,?%s*%-%-%s*(.*)')
					-- print("F1a key: "..tostring(key).." value: |"..tostring(value).."|")

					-- if not key then
					-- 	key, value = line:match('(%S+)%s*=%s*([^,%s]+)%s*,?%s*$') -- Capture sans commentaire
					-- 	print("F1b key: "..tostring(key).." value: |"..tostring(value).."|")
					-- end

					key, value, comment = line:match('([%w_%[%]"]+)%s*=%s*("?.-"?),?%s*%-%-%s*(.*)')
					-- print("F1a key: " .. tostring(key) .. " value: |" .. tostring(value) .. "|")

                    if not key then
                        key, value = line:match('([%w_%[%]"]+)%s*=%s*("?.-"?),?')
                        -- print("F1b key: " .. tostring(key) .. " value: |" .. tostring(value) .. "|")
                    end

					if key then
						-- print("G key: "..tostring(key).." currentTable[key]: "..tostring(currentTable[key]).." value: |"..tostring(value).."|")

						local clientValue = currentTable[key] or value
						local formattedValue = getFormattedValue(clientValue)

						-- -- Calcul de la largeur max des clés pour un alignement automatique
						-- local keyColumnWidth = 0
						-- for k, _ in pairs(currentTable) do
						-- 	if type(k) == "string" then
						-- 		keyColumnWidth = math.max(keyColumnWidth, #k)
						-- 	end
						-- end
						-- keyColumnWidth = keyColumnWidth + 2  -- Ajout de 2 espaces pour plus de lisibilité

						-- 📏 Calcul de la largeur max des clés pour aligner les `=`
						local maxKeyLength = 0
						for k, _ in pairs(currentTable) do
							if type(k) == "string" then
								maxKeyLength = math.max(maxKeyLength, #k)
							end
						end
						local spacingAfterKey = string.rep(" ", math.max(1, maxKeyLength - #key + 2)) -- Ajoute 2 espaces pour lisibilité



						-- --   Ajustement de l'alignement
						-- local spacingAfterKey = string.rep(" ", keyColumnWidth - #key)

						local spacingAfterEqual = " "
						local valueColumnWidth = 8  -- 🛠 Réduit l'espace après la valeur
						local spacingAfterValue = string.rep(" ", math.max(1, valueColumnWidth - #tostring(formattedValue)))

						--   Vérifier si on ajoute une virgule
						local nextLine = structureLocal[i + 1] or ""
						local addComma = not nextLine:match("^%s*}%s*$")

						-- Écriture avec **espacement plus serré**
						if comment then
							-- print("H2 "..getIndent(level) .. key .. spacingAfterKey .. "=" .. spacingAfterEqual .. formattedValue .. (addComma and "," or "") .. spacingAfterValue .. "-- " .. comment .. "\n")
							-- file:write(getIndent(level) .. key .. spacingAfterKey .. "=" .. spacingAfterEqual .. formattedValue .. (addComma and "," or "") .. spacingAfterValue .. "-- " .. comment .. "\n")
							file:write(getIndent(level) .. key .. spacingAfterKey .. "= " .. formattedValue .. (addComma and "," or "") .. spacingAfterValue .. "-- " .. comment .. "\n")

						else
							-- print("H3 "..getIndent(level) .. key .. spacingAfterKey .. "=" .. spacingAfterEqual .. formattedValue .. (addComma and ",") .. "\n")
							file:write(getIndent(level) .. key .. spacingAfterKey .. "=" .. spacingAfterEqual .. formattedValue .. (addComma and ",") .. "\n")
						end
					end
				end
			end

			--   Vérification finale : s'assurer que toutes les tables sont bien fermées
			while #stack > 0 do
				local popped = table.remove(stack)
				level = level - 1
				file:write(getIndent(level) .. "}\n")
			end

			--   Ajout manuel de `pictureBrief` à la fin si présent
			if currentTable.pictureBrief then
				file:write("\n" .. getIndent(level) .. "pictureBrief = {\n")
				level = level + 1

				for category, images in pairs(currentTable.pictureBrief) do
					file:write(getIndent(level) .. category .. " = {\n")
					for _, image in ipairs(images) do
						file:write(getIndent(level + 1) .. '"' .. image .. '",\n')
					end
					file:write(getIndent(level) .. "},--pictureBrief\n")  -- Fermeture de `blue` ou `red`
				end

				level = level - 1
				file:write(getIndent(level) .. "}\n")  -- Fermeture de `pictureBrief`
			end


		end

		--   Écrire la structure dans le fichier en respectant les valeurs du client
		writeStructureLines(updatedConfig, structure, indentLevel)

		file:close()
	end

    -- Chemins des fichiers de configuration
    local clientConfigPath = "Init/conf_mod.lua"
    local defaultConfigPath = "../../../ScriptsMod." .. VersionPackageICM .. "/UTIL_ConfModCheck.lua"

    -- Charger les fichiers de configuration client et par défaut
    local clientConfig, clientStructure = loadConfigWithStructure(clientConfigPath)

	-- Sauvegarde `pictureBrief` original AVANT toute modification
	local backupPictureBrief = clientConfig.pictureBrief and DeepCopy(clientConfig.pictureBrief) or nil

    local defaultConfig, defaultStructure = loadConfigWithStructure(defaultConfigPath)

	mergeTables(clientConfig, defaultConfig, clientStructure)

	-- Nettoyer les variables obsolètes du client
    clientConfig = removeObsoleteEntries(clientConfig, defaultConfig)

	-- Mettre à jour la configuration client avec les valeurs par défaut manquantes
	clientConfig = updateConfiguration(clientConfig, defaultConfig)

	if backupPictureBrief then
		-- print("  Restauration de `pictureBrief` après traitement !")
		clientConfig.pictureBrief = backupPictureBrief
	end


	-- Sauvegarder la configuration mise à jour
	-- clientConfigPath = "Init/conf_mod_BBB.lua"
	saveUpdatedConfig(clientConfigPath, clientConfig, defaultStructure)

	dofile("Init/conf_mod.lua")
end


--reecrit le fichier camp_ini en ne gardant que les variables utile, les autres ayant été transférée dans conf_mo
function ModifiCampInit()

	-- camp = {
	-- 	--any modification of this part requires a restart of the campaign to be taken into account.
	-- 	title = "WOC-80s-Blue-GC22-5",		--Title of campaign (name of missions)
	-- 	version = "V25-gc",
	-- 	mission = 1,					--campaig mission number
	-- 	date = {						--campaign date
	-- 		day = 6,
	-- 		year = 1986,
	-- 		month = 4,
	-- 	},
	-- 	time = 11700,					--Daytime in seconds
	-- 	variation = 4,					--variation in degrees from true north to magneitic north

	local txt = ""
	-- local nTab = 0
	local compareVariable = {
		"camp",
		"title",
		"version",
		"mission",
		"date",
		"day",
		"year",
		"month",
		"weather",
		"trend",
		"variance",
		"refTemp",
		"instability",
		"windActivity",
		"winDirection",
		"time",
		"variation",
		"ewrFreqAdaptable",
	}

	local monfichier = io.open("Init/camp_init.lua", "r") or error("Failed to open debug file")

	io.input(monfichier)
	local n = 0
	local nTab = {
		false,
		false,
		false,
		false,
	}
	for line in io.lines() do

		local addLine = false
		local varString, com2, comTemp

		if string.find(line, "%-%-")  then
			--traitement du commentaire avec la valeur de la variable
			varString, com2 = line:match("(.*)-(.*)")
			if com2 and string.find(com2, "%-%-") then
				comTemp, com2 = com2:match("(.*)-(.*)")
			end
		else
			varString = line
		end

		if string.find(line, "{")   then n = n+1  end
		if string.find(line, "}")   then n = n-1  end

		if varString ~= nil and string.find(varString, "=") then

			local varStringB, varValue = varString:match("(.*)=(.*)")

			varStringB = varStringB:gsub(" ", "")
			varStringB = varStringB:gsub("\t", "")

			for m, varRef in ipairs(compareVariable) do

				if varStringB == varRef  then
					txt = txt .. line .. "\n"
					addLine = true
					if string.find(line, "{")   then nTab[n] = true end
					if string.find(line, "}")   then nTab[n+1] = false end
					-- print("UtilF passe ADD  H n:|"..tostring(n).." nTab[n]: "..tostring(nTab[n]))
					break
				end
			end

			if string.find(line, "}") and not addLine and varStringB == nil   then
				n = n - 1
				if not addLine then
					txt = txt .. line .. "\n"
					if string.find(line, "{")   then nTab[n] = true end
					if string.find(line, "}")   then nTab[n+1] = false end
					-- print("UtilF passe ADD  I n:|"..tostring(n).." nTab[n]: "..tostring(nTab[n]))
					break
				end
			end

		else

			if not string.find(line, "}")   then
				txt = txt .. line .. "\n"
				-- print("UtilF passe ADD  J n:|"..tostring(n).." nTab[n]: "..tostring(nTab[n]))
			else

				-- print("UtilF passe ADD  K1 n:|"..tostring(n).." nTab[n]: "..tostring(nTab[n]).." nTabn+1 "..tostring(nTab[n+1]))

				if nTab[n+1] == true then
					txt = txt .. line .. "\n"
					-- print("UtilF passe ADD  K2 n:|"..tostring(n).." nTab[n]: "..tostring(nTab[n]))
					nTab[n+1] = false
				end
			end

		end

	end

	io.close(monfichier)

	local updateFile = io.open("Init/camp_init.lua", "w") or error("Failed to open debug file")
	updateFile:write(txt)																		--save new data

	io.close(updateFile)

	dofile("Init/camp_init.lua")

end

--assigne un CallName � tous les squad West pour tout le reste de la campagne 
function AssignCallnameSquad()
	--le callsign ou callname sera dorenavant assign� � un squad "west" pour toute la campagne
	--par default, l'assignation se fait lors de la premiere mission ou a n'importe quel skipMission si cela n'avait pas �t� fait avant
	--l'assignation se fait en priorit� avec des SpecificCallnames s'ils existent, ensuite, le choix est automatique et al�atoire.
	--le joueur � la possibilit� de "forcer" le callsign � un ou plusieurs squads dans Init/oob_air_init.lua
	--Il peut meme le changer au cours de la campagne, DCE le prendra en compte
	-- il existe une "protection" contre les mauvais callsign ajout� par le joueur, s'il se trompe
	--https://wiki.hoggitworld.com/view/DCS_enum_callsigns

	--******************************

	--the callsign or callname will now be assigned to a "west" squad for the entire campaign
	--by default, the assignment is done at the first mission or at any skipMission if it was not done before
	--the assignment is done in priority with SpecificCallnames if they exist, then, the choice is automatic and random.
	--the player has the possibility to "force" the callsign to one or more squads in Init/oob_air_init.lua
	--he can even change it during the campaign, DCE will take it into account
	-- there is a "protection" against bad callsign added by the player, if he is wrong
	--https://wiki.hoggitworld.com/view/DCS_enum_callsigns


	-- Charger oob_air_init sans écraser oob_air actuel
	local initOobAir = nil
	do
		local tempEnv = {} -- Crée un environnement temporaire pour charger oob_air_init
		local f = assert(loadfile("Init/oob_air_init.lua"))
		setfenv(f, tempEnv)
		f()
		initOobAir = DeepCopy(tempEnv.oob_air or {}) -- Copie profonde pour éviter les références partagées
	end

	-- Comparer et mettre à jour les callsigns si nécessaire
	for _, initUnit in pairs(initOobAir) do
		for n = 1, #initUnit do
			for _, unit in pairs(oob_air) do
				if initUnit[n].callsign then -- Si le joueur a enregistré un callsign personnalisé
					for r = 1, #unit do
						if unit[r].name == initUnit[n].name and unit[r].callsign ~= initUnit[n].callsign then -- Si c'est le même squad
							unit[r].callsign = initUnit[n].callsign
							-- print("utilFct CORRECTION callsign "..unit[r].callsign)
						end
					end
				end
			end
		end
	end



	local callSigneAssigned = {}

	for side,unit in pairs(oob_air) do
		for n = 1, #unit do
			--regarde les CallName d�j� attribu� par le concepteur de campagne
			-- if WestCallsign[unit[n].country] == "west" and unit[n].callsign then
			if IsWesternCountry(unit[n].country) and unit[n].callsign then
				callSigneAssigned[unit[n].callsign] = true
			end
		end
	end

	for side, unit_ in pairs(oob_air) do
		for n = 1, #unit_ do
			local unit = unit_[n]
			local category
			if not unit.inactive then
				-- local Imax = 0
				-- if WestCallsign[unit.country] == "west" and not unit.callsign then
				if IsWesternCountry(unit.country) and not unit.callsign then
						local assigneOk = false

						--s'il existe une table avec des CallName sp�cifique � un type d'avion
						if SpecificCallnames[unit.type] and SpecificCallnames[unit.type][unit.country]  then

							--recherch l'index le plus haut de la table SpecificCallnames
							local Imax = 0
							for index, value in pairs(SpecificCallnames[unit.type][unit.country]) do
								if index > Imax then
									Imax = index
								end
							end

							local j = 0
							repeat
								local i =  math.random(9, Imax)

								if not callSigneAssigned[SpecificCallnames[unit.type][unit.country][i]] then
									unit.callsign = SpecificCallnames[unit.type][unit.country][i]
									unit.callsignId = i
									callSigneAssigned[unit.callsign] = true
									assigneOk = true
									break
								end
								j = j + 1
							until j > 50 or assigneOk
						end

						if not assigneOk then
							if unit.tasks["AWACS"] then
								category = "AWACS"
							elseif unit.tasks["Refueling"] then
								category = "tanker"
							else
								category = "generic"
							end

							for i = 1, #Callsign_west[category] do
								if not callSigneAssigned[Callsign_west[category][i]] then
									unit.callsign = Callsign_west[category][i]
									unit.callsignId = i
									callSigneAssigned[unit.callsign] = true
									assigneOk = true
									break
								end
							end

							if not assigneOk then
								local i =  math.random(1, #Callsign_west[category])
								unit.callsign = Callsign_west[category][i]
								unit.callsignId = i
								callSigneAssigned[unit.callsign] = true
								assigneOk = true
								break
							end
						end

				-- elseif WestCallsign[unit.country] == "west" and unit.callsign then								--controle si le callsign renseign� par le joueur/campaignMaker est compatible
				elseif IsWesternCountry(unit.country) and unit.callsign then
					local GoodCallSign = false
					if  not unit.inactive and SpecificCallnames[unit.type] and SpecificCallnames[unit.type][unit.country]  then

						--recherch l'index le plus haut de la table SpecificCallnames
						local Imax = 0
						for index, value in pairs(SpecificCallnames[unit.type][unit.country]) do
							if index > Imax then
								Imax = index
							end
						end
						for i = 9, Imax do
							if SpecificCallnames[unit.type][unit.country][i] == unit.callsign then
								unit.callsignId = i
								GoodCallSign = true
								break
							end
						end
					end

					if not GoodCallSign then
						if unit.tasks["AWACS"] then
							category = "AWACS"
						elseif unit.tasks["Refueling"] then
							category = "tanker"
						else
							category = "generic"
						end
						for i = 1, #Callsign_west[category] do
							if Callsign_west[category][i] == unit.callsign then
								GoodCallSign = true
								unit.callsignId = i
								break
							end
						end
					end

					if not GoodCallSign then
						print("Error(UtilFct) This callsign: ("..tostring(unit.callsign)..") is not compatible with this type of aircraft ("..tostring(unit.type)..")")
						print(" This callsign is ignored for this mission. Change this callsign in /Init/oob_air_init.lua for this squadron ("..tostring(unit.name)..")")
						print(" select a new callsign corresponding to the aircraft type as in this page. Or delete it, DCE will automatically assign the right one.")
						print("https://wiki.hoggitworld.com/view/DCS_enum_callsigns")
						print("Error ") os.execute 'pause'
						unit.callsign = nil
					end
				end
			end
		end
	end
end

function AddLog(txt)
	if not BugList then BugList = {} end

	if #BugList >=1 then
		for n=1, #BugList do
			if BugList[n] == txt then
				-- le bug est déjà enregistré, inutile de l'ajouter
				return
			end
		end
	end

	table.insert(BugList,txt)

end


function ExtractDateFromCondition(condition)
	local day = condition:match("camp%.date%.day%s*[<>=]+%s*(%d+)")
	local month = condition:match("camp%.date%.month%s*[<>=]+%s*(%d+)")
	local year = condition:match("camp%.date%.year%s*[<>=]+%s*(%d+)")
	if day and month and year then
		return { day = tonumber(day), month = tonumber(month), year = tonumber(year) }
	end
	return nil
end

	--sort() trie la table alpha en fonction du priority
function TargetlistToNum(tableWorking)
	local targetlistTempB = {}

	for target_name, target in pairs(tableWorking["blue"]) do
		target.titleName = target_name
		if not target.name then target.name = target_name end
		-- print("UtilFct titleName "..tostring(target.titleName))
		table.insert(targetlistTempB, target)
	end
	table.sort(targetlistTempB,  function(a,b)  return a.priority > b.priority  end)
	tableWorking["blue"] = targetlistTempB

	targetlistTempB = {}
	for target_name, target in pairs(tableWorking["red"]) do
		target.titleName = target_name
		if not target.name then target.name = target_name end
		-- print("UtilFct titleName "..tostring(target.titleName))
		table.insert(targetlistTempB, target)
	end
	table.sort(targetlistTempB,  function(a,b)  return a.priority > b.priority  end)
	tableWorking["red"] = targetlistTempB

end

function CompareTargetLists(reference, working)
    local changes = {
        added = {},    -- Éléments ajoutés
        removed = {},  -- Éléments supprimés
    }

    -- Parcourir les éléments de la table de référence pour détecter les suppressions
    for side, targets in pairs(reference) do
        for refIndex, refData in ipairs(targets) do
            local found = false
            if working[side] then
                for workIndex, workData in ipairs(working[side]) do
                    if refData.name == workData.name then
                        found = true
                        break
                    end
                end
            end
            if not found then
				-- Si l'élément n'existe pas dans la table de référence, il a été ajouté
				table.insert(changes.added, { side = side, data = refData })

            end
        end
    end

    -- Parcourir les éléments de la table de travail pour détecter les ajouts
    for side, targets in pairs(working) do
        for workIndex, workData in ipairs(targets) do
            local found = false
            if reference[side] then
                for refIndex, refData in ipairs(reference[side]) do
                    if workData.name == refData.name then
                        found = true
                        break
                    end
                end
            end
            if not found then
                -- Si l'élément n'existe pas dans la table de travail, il a été supprimé
                table.insert(changes.removed, { side = side, data = workData })
            end
        end
    end

    return changes
end

function CompareTableNumericTrigger(reference, working)
    local changes = {
        added = {},    -- Éléments ajoutés
        removed = {},  -- Éléments supprimés
    }

    -- Parcourir les éléments de la table de référence pour détecter les ajouts
    for refN, refData in ipairs(reference) do
        local found = false
		-- print("UtilF A refData.name: "..tostring(refData.name))
        for workN, workData in ipairs(working) do
			-- print("UtilF   BB refName: "..tostring(refData.name).." workName: "..tostring(workData.name))
            if refData.name == workData.name then
				-- print("UtilF       CCC ----------------->> FOUND ok")
                found = true
                break
            end
        end
        if not found then
			-- print("CompareTrigger refData.name: "..tostring(refData.name))
			-- print("CompareTrigger refData.condition: "..tostring(refData.condition))

			local dateCible = ExtractDateFromCondition(refData.condition)
			if dateCible then
				-- print("CompareTrigger Date extraite : " .. dateCible.day .. "/" .. dateCible.month .. "/" .. dateCible.year)
				-- Désactive si la date de la campagne est au moins 1 jour strictement après la date cible
				-- Utilise Julian Day Number (JDN) pour être indépendant de os.time et compatible avant 1970
				local function date_to_jdn(d)
					if not d then return nil end
					local y = tonumber(d.year)
					local m = tonumber(d.month)
					local day = tonumber(d.day)
					if not (y and m and day) then return nil end
					if m <= 2 then
						y = y - 1
						m = m + 12
					end
					local A = math.floor(y / 100)
					local B = 2 - A + math.floor(A / 4)
					local jd = math.floor(365.25 * (y + 4716)) + math.floor(30.6001 * (m + 1)) + day + B - 1524
					return jd
				end

				local camp_jd = date_to_jdn(camp.date)
				local cible_jd = date_to_jdn(dateCible)
				if camp_jd and cible_jd then
					local day_diff = camp_jd - cible_jd
					if day_diff >= 1 then
						refData.active = false
						-- print("CompareTrigger refData.active FALSE (camp >= cible +1 jour)")
						-- _affiche(camp.date, "camp.date: ")
						-- os.execute 'pause'
					end
				else
					-- print("CompareTrigger erreur lors de la conversion des dates (JDN)")
				end
			else
				-- print("CompareTrigger Impossible d'extraire la date")
			end

            -- Si l'élément n'existe pas dans la table de travail, il a été ajouté
            table.insert(changes.added, refData)
			-- print("UtilF          DDDD ----------------->> BAD ")
        end
    end

    -- -- Parcourir les éléments de la table de travail pour détecter les suppressions
    -- for workName, workData in ipairs(working) do
    --     local found = false
    --     for refName, refData in ipairs(reference) do
    --         if workName == refName then
    --             found = true
    --             break
    --         end
    --     end
    --     if not found then
    --         -- Si l'élément n'existe pas dans la table de référence, il a été supprimé
    --         table.insert(changes.removed, workData)
    --     end
    -- end

    return changes
end

function CompareTableAlphaNumeric(reference, working)
    local changes = {
        added = {},    -- Éléments ajoutés
        removed = {},  -- Éléments supprimés
    }

    -- Parcourir les éléments de la table de référence pour détecter les ajouts
    for refKey, refData in pairs(reference) do
        local found = false
        for workKey, workData in pairs(working) do
            if refKey == workKey then
                found = true
                break
            end
        end
        if not found then
            -- Si l'élément n'existe pas dans la table de travail, il a été ajouté
            table.insert(changes.added, { name = refKey, data = refData })
        end
    end

    -- Parcourir les éléments de la table de travail pour détecter les suppressions
    for workKey, workData in pairs(working) do
        local found = false
        for refKey, refData in pairs(reference) do
            if workKey == refKey then
                found = true
                break
            end
        end
        if not found then
            -- Si l'élément n'existe pas dans la table de référence, il a été supprimé
            table.insert(changes.removed, { name = workKey, data = workData })
        end
    end

    return changes
end


function ListSpotterAircraft()
	-- local isAfacAircraft = {}
	-- for side, oob_side in pairs(oob_air) do
	-- 	for n, sqd in pairs(oob_side) do
	-- 		if sqd.type and TaskByPlane.AFAC[sqd.type] then
	-- 			isAfacAircraft[sqd.type] = true
	-- 		end
	-- 	end
	-- end
	-- return isAfacAircraft

	local isAfacAircraft = {}
	for side, oob_side in pairs(oob_air) do
		for n, sqd in pairs(oob_side) do
			if sqd.tasks and type(sqd.tasks) == "table" then
				-- print("UtilFct sqd.name : "..tostring(sqd.name).." sqd.type: "..tostring(sqd.type))
				-- _affiche(sqd.tasks, "UtilFct sqd.tasks: ")
				for taskName, value in pairs(sqd.tasks) do
					if string.lower(taskName) == "spotter" and value == true then
						isAfacAircraft[sqd.type] = true
					end
				end
			end
		end
	end

	return isAfacAircraft

end


local function latLon_decimal_to_dms(decimal_degrees)
    local degrees = math.floor(decimal_degrees)
    local minutes = math.floor((decimal_degrees - degrees) * 60)
    local seconds = (decimal_degrees - degrees - minutes / 60) * 3600
    return degrees, minutes, seconds
end


local showLL_position = true

function Format_dms(lat_decimal, lon_decimal, precision)

	if not showLL_position then return "" end

	local lat_deg, lat_min, lat_sec = latLon_decimal_to_dms(lat_decimal)
    local lon_deg, lon_min, lon_sec = latLon_decimal_to_dms(lon_decimal)

    local lat_direction = lat_decimal >= 0 and 'N' or 'S'
    local lon_direction = lon_decimal >= 0 and 'E' or 'W'

    if precision == 4 then
        return string.format("%s%d°%02d' - %s%d°%02d'",
                             lat_direction, math.abs(lat_deg), math.abs(lat_min),
                             lon_direction, math.abs(lon_deg), math.abs(lon_min))
    elseif precision == 6 then
        return string.format("%s%d°%02d'%02d\" - %s%d°%02d'%02d\"",
                             lat_direction, math.abs(lat_deg), math.abs(lat_min), math.floor(math.abs(lat_sec)),
                             lon_direction, math.abs(lon_deg), math.abs(lon_min), math.floor(math.abs(lon_sec)))
    elseif precision == 8 then
        return string.format("%s%d°%02d'%05.2f\" - %s%d°%02d'%05.2f\"",
                             lat_direction, math.abs(lat_deg), math.abs(lat_min), math.abs(lat_sec),
                             lon_direction, math.abs(lon_deg), math.abs(lon_min), math.abs(lon_sec))
    else
        error("Precision must be 4, 6, or 8")
    end
end


-- Fonction pour convertir les degrés en radians
local function deg_to_rad(deg)
    return deg * (math.pi / 180)
end

-- Fonction pour convertir les radians en degrés
local function rad_to_deg(rad)
    return rad * (180 / math.pi)
end


-- -- Constantes pour WGS84
-- local a = 6378137.0 -- Demi-grand axe en mètres (WGS84)
-- local f = 1 / 298.257223563 -- Aplatissement inverse (WGS84)
-- local e2 = 2 * f - f * f -- Excentricité au carré
-- local k0 = 0.9996 -- Facteur d'échelle sur le méridien central

--[[ -- Fonction pour convertir des coordonnées UTM en latitude et longitude
local function dcs_to_gps(easting, northing, P0_lat, P0_lon)
    -- Convertir l'origine en radians
    local lat0_rad = math.rad(P0_lat)
    local lon0_rad = math.rad(P0_lon)

    -- Delta en mètres par rapport au point de référence P0
    local delta_easting = easting
    local delta_northing = northing

    -- Calcul du méridien d'origine
    local M0 = a * ((1 - e2 / 4 - 3 * e2^2 / 64 - 5 * e2^3 / 256) * lat0_rad
                - (3 * e2 / 8 + 3 * e2^2 / 32 + 45 * e2^3 / 1024) * math.sin(2 * lat0_rad)
                + (15 * e2^2 / 256 + 45 * e2^3 / 1024) * math.sin(4 * lat0_rad)
                - (35 * e2^3 / 3072) * math.sin(6 * lat0_rad))

    -- Calcul de la latitude intermédiaire
    local M = M0 + delta_northing / k0
    local mu = M / (a * (1 - e2 / 4 - 3 * e2^2 / 64 - 5 * e2^3 / 256))

    -- Calcul de phi1 (latitude initiale en radians)
    local phi1_rad = mu + (3 * (3 * e2 / 8 + 3 * e2^2 / 32 + 45 * e2^3 / 1024) / 2) * math.sin(2 * mu)
                    + (21 * e2^2 / 16 - 55 * e2^3 / 32) * math.sin(4 * mu)
                    + (151 * e2^3 / 96) * math.sin(6 * mu)

    -- Calcul des termes nécessaires
    local N1 = a / math.sqrt(1 - e2 * math.sin(phi1_rad)^2)
    local T1 = math.tan(phi1_rad)^2
    local C1 = e2 * math.cos(phi1_rad)^2 / (1 - e2)
    local R1 = a * (1 - e2) / ((1 - e2 * math.sin(phi1_rad)^2) ^ 1.5)
    local D = delta_easting / (N1 * k0)

    -- Calcul de la latitude finale
    local latitude_rad = phi1_rad - (N1 * math.tan(phi1_rad) / R1) * (D^2 / 2 - (5 + 3 * T1 + 10 * C1 - 4 * C1^2 - 9 * e2) * D^4 / 24
                    + (61 + 90 * T1 + 298 * C1 + 45 * T1^2 - 252 * e2 - 3 * C1^2) * D^6 / 720)

    -- Calcul de la longitude finale
    local longitude_rad = lon0_rad + (D - (1 + 2 * T1 + C1) * D^3 / 6 + (5 - 2 * C1 + 28 * T1 - 3 * C1^2 + 8 * e2 + 24 * T1^2) * D^5 / 120) / math.cos(phi1_rad)

    -- Conversion en degrés
    local latitude = math.deg(latitude_rad)
    local longitude = math.deg(longitude_rad)

    return latitude, longitude
end ]]

-- Fonction pour convertir les degrés en radians
local function toRadians(degrees)
    return degrees * math.pi / 180
end

-- Fonction pour convertir les radians en degrés
local function toDegrees(radians)
    return radians * 180 / math.pi
end

-- Implémentation de atan2 manuelle
local function atan2(y, x)
    if x > 0 then
        return math.atan(y / x)
    elseif x < 0 and y >= 0 then
        return math.atan(y / x) + math.pi
    elseif x < 0 and y < 0 then
        return math.atan(y / x) - math.pi
    elseif x == 0 and y > 0 then
        return math.pi / 2
    elseif x == 0 and y < 0 then
        return -math.pi / 2
    else
        return 0
    end
end

-- Rayon de la Terre en mètres
local R = 6371000  -- 6371 km en mètres

-- Fonction pour calculer la position du point B
function NewPosLatLon(latA, lonA, distance, azimut)
    -- Conversion des entrées en radians
    local latA_rad = toRadians(latA)
    local lonA_rad = toRadians(lonA)
    local azimut_rad = toRadians(azimut)

    -- Distance en fraction de rayon terrestre (distance en mètres ici)
    local d = distance / R

    -- Calcul de la latitude de B
    local latB_rad = math.asin(math.sin(latA_rad) * math.cos(d) + math.cos(latA_rad) * math.sin(d) * math.cos(azimut_rad))

    -- Calcul de la différence de longitude
    local deltaLon_rad = atan2(
        math.sin(azimut_rad) * math.sin(d) * math.cos(latA_rad),
        math.cos(d) - math.sin(latA_rad) * math.sin(latB_rad)
    )

    -- Calcul de la longitude de B
    local lonB_rad = lonA_rad + deltaLon_rad

    -- Conversion des résultats en degrés
    local latB = toDegrees(latB_rad)
    local lonB = toDegrees(lonB_rad)

    return latB, lonB
end

function GetWeightedRandom(min, max, bias)
    -- Génère un nombre aléatoire entre 0 et 1
    local randomValue = math.random()
    -- Applique une pondération exponentielle (plus le biais est grand, plus c'est proche de min)
    local weightedValue = randomValue ^ bias
    -- Remap pour correspondre à l'échelle entre min et max
    return min + (max - min) * weightedValue
end

-- Fonction pour vérifier l'existence d'un fichier
function FileExists(path)
    local file = io.open(path, "r")
    if file then
        file:close()
        return true
    end
    return false
end

-- Écriture sécurisée dans un fichier
function WriteToFile(path, content)
    local file, err = io.open(path, "w")
    if not file then
        error("Impossible d'ouvrir le fichier '" .. path .. "' pour écriture : " .. tostring(err))
    end
    file:write(content)
    file:close()
end

function CheckTarawa(txt)

	for basename, base in pairs(db_airbases) do
		if base.unitname and base.unitname == "LHA_Tarawa" then																			--if airbase is a carrier, find the unit in the OOB Ground
			print("UtilF LHA_Tarawa "..txt.." "..tostring(base.x) )
		end
	end
end

function CheckTarget(tgt, txt)

	for sideName, targets in pairs(targetlist) do
		for targetN, target in pairs(targets) do
			if target.titleName  == tgt then

				print("UtilF CheckTarget |"..txt.."| |"..tgt.."| alive?: "..tostring(target.alive) )

				if target.elements and target.elements[1] then

					print("UtilF CheckTarget |"..txt.."| |"..target.elements[1].name.."| dead? "..tostring(target.elements[1].dead) )

				end
			end
		end
	end
end

function FoundSquadSide(squadName)
	--local squadName = "VFA-113"
	local foundSide = false
	for side, unit in pairs(oob_air) do
		for n = 1, #unit do
			if unit[n].name == squadName then
				foundSide = side
				break
			end
		end
	end

	return foundSide
end


function KillTarget(targetName, targetName2)

	local findTarget = false
	for side_name,side in pairs(oob_ground) do														--side table(red/blue)											
		for country_n,country in pairs(side) do														--country table (number array)
			if country.vehicle then																	--if country has vehicles
				for group_n,group in pairs(country.vehicle.group) do								--groups table (number array)
					if group.name == targetName or group.name == targetName2 then
						for unit_n,unit in pairs(group.units) do										--units table (number array)					
							if not unit.dead then
								if Debug.AfficheSol then print("DC_DT Kill "..unit.name) end

								unit.dead = true														--mark unit as dead in oob_ground
								-- unit.dead_last = true													--mark unit as died in last mission
								unit.CheckDay = camp.date.CampTotalTimeS
								findTarget = true
							end
						end
					end
				end
			end
			if country.static then																--if country has static objects	
				for group_n,group in pairs(country.static.group) do								--groups table (number array)
					if group.name == targetName or group.name == targetName2 then
						for unit_n,unit in pairs(group.units) do									--units table (number array)
							if Debug.AfficheSol then print("DC_DT Kill "..unit.name) end

							if not unit.dead then											--unit is not yet dead (some static objects that are spawned in a destroyed state are logged dead at mission start, these must be excluded here)
								group.dead = true												--mark group as dead in oob_ground (static objects can be set as group.dead and spawned in a destroyed state)
								--TODO si le vehicle revit, il faudrait lui coller le hidden d'origine
								group.hidden = true												--hide dead static object
								unit.dead = true												--mark unit as dead in oob_ground (this is for the targetlist)
								-- unit.dead_last = true
								unit.CheckDay = camp.date.CampTotalTimeS
								findTarget = true
							end
						end
					end
				end
			end
			if country.ship then																--if country has ships
				for group_n,group in pairs(country.ship.group) do								--groups table (number array)
					if group.name == targetName or group.name == targetName2 then
						for unit_n,unit in pairs(group.units) do									--units table (number array)	
							if Debug.AfficheSol then print("DC_DT Kill "..unit.name) end

							unit.dead = true													--mark unit as dead in oob_ground
							-- unit.dead_last = true												--mark unit as died in last mission
							unit.CheckDay = camp.date.CampTotalTimeS                              -- ajoute la date de destruction    Miguel21 modification M19 : Repair SAM   
							findTarget = true
						end
					end
				end
			end
		end
	end

	for side_name, targets in pairs(targetlist) do											--iterate through targetlist
		for targetN, target in pairs(targets) do										--iterate through targets
			if target.titleName == targetName or target.titleName == targetName2 then
				if target.elements and target.elements[1].x then 						--if the target has subelements and is a scenery object target (element has x coordinate)
					for element_n,element in pairs(target.elements) do					--iterate through target elements

						if Debug.AfficheSol then print("DC_DT Kill __SCENERY__ "..element.name) end
						element.dead = true
						element.CheckDay = camp.date.CampTotalTimeS

					end
				end
			end
		end
	end
end

--rafraichit certain fichier si l'utilisateur avance le temps, cela permet de choisir les cibles rafraichi en fonction des triggers actif ou pas
function UpdateFilesAfterTimeJump()

	----- unpack template mission file ----
	local minizip = require('minizip')

	local zipFile = minizip.unzOpen("Init/base_mission.miz", 'rb')

	zipFile:unzLocateFile('mission')
	local misStr = zipFile:unzReadAllCurrentFile()
	local misStrFunc = loadstring(misStr)()

	zipFile:unzClose()

	CampTotalTimeS = SecondsBetween(camp.dateInit, camp.date)
	CampTotalTimeH = CampTotalTimeS / 3600

	-- print("UTIL_function_UpdateFilesAfterTimeJump() The campaign will start on this date: " .. tostring(camp.dateInit.day) .. "." .. tostring(camp.dateInit.month) .. "." .. tostring(camp.dateInit.year) .. ".\n")
	-- print("UTIL_function_UpdateFilesAfterTimeJump() The current date of the campaign is: " .. tostring(camp.date.day) .. "." .. tostring(camp.date.month) .. "." .. tostring(camp.date.year) .. ".\n")

	camp.date.CampTotalTimeS = CampTotalTimeS
	camp.date.CampTotalTimeH = CampTotalTimeH

	require("Active/oob_ground")

    dofile("../../../ScriptsMod." .. VersionPackageICM .. "/DC_UpdateTargetlist.lua")
	dofile("../../../ScriptsMod." .. VersionPackageICM .. "/DC_Refpoints.lua")
	dofile("../../../ScriptsMod." .. VersionPackageICM .. "/DC_NavalEnvironment.lua")
	if Debug.debug then print ("Lancement VIA UTIL_Fonction E 5235 (UpdateFilesAfterTimeJump)") end
	dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_CheckTriggers.lua")
	dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_UpdateTargetlist.lua")
	dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_UpdateOOBGround.lua")


	local airbases_Str = "db_airbases = " .. TableSerialization(db_airbases, 0)
	local trigFile = io.open("Active/db_airbases.lua", "w") or error("Failed to open debug file")
	trigFile:write(airbases_Str)
	trigFile:close()

	local ground_str = "oob_ground = " .. TableSerialization(oob_ground, 0)						--make a string
	local groundFile = io.open("Active/oob_ground.lua", "w") or error("Failed to open debug file")
	groundFile:write(ground_str)																--save new data
	groundFile:close()


	local tgt_str = "targetlist = " .. TableSerialization(targetlist, 0)						--make a string
	local tgtFile = io.open("Active/targetlist.lua", "w") or error("Failed to open debug file")
	tgtFile:write(tgt_str)																		--save new data
	tgtFile:close()

	local trigStr = "camp_triggers = " .. TableSerializationAG_triggers(camp_triggers, 0)
	trigFile = io.open("Active/camp_triggers.lua", "w") or error("Failed to open debug file")
	trigFile:write(trigStr)
	trigFile:close()

end

function ConvertAlphaToNumeric(tbl)
    local numericTbl = {}
    for k, v in pairs(tbl) do
        if type(v) == "table" then
            v.name = k -- copie la clé alphanumérique dans le champ 'name'
            table.insert(numericTbl, v)
        end
    end
    return numericTbl
end

function LoadFileAndUpdate(from)

	if Debug.debug then
		print("START LoadFileAndUpdate() "..tostring(from).." /1/1/1/1/1/1/1///1/1")
	end

    FromFile = "UTIL_Functions/LoadFileAndUpdate()" -- file name for debug

	----- unpack template mission file ----
	local minizip = require('minizip')

	local zipFile = minizip.unzOpen("Init/base_mission.miz", 'rb')

	zipFile:unzLocateFile('mission')
	local misStr = zipFile:unzReadAllCurrentFile()
	local misStrFunc = loadstring(misStr)()

	NameTheatreLower = string.lower(mission.theatre)
    NameTheatre = mission.theatre

	--util pour connaitre les warehouses utilisé lors du script DC_UpdateOOBGround.lua
	zipFile:unzLocateFile('warehouses')
	local warStr = zipFile:unzReadAllCurrentFile()
	local warStrFunc = loadstring(warStr)()

	FirstCheck_Id()
	CheckAll_Id()

	zipFile:unzClose()

	dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_Data.lua")
	dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_DataMap.lua")

	if not oob_scen and Firstmission_flag then
		require("Active/oob_scen")
	end

	-- _affiche(camp.date, "LoadFileAndUpdate()camp.date: ")
	UpdateConfMod(nil, camp.date, "UTIL_Functions/LoadFileAndUpdate() "..debug.getinfo(1).currentline)

	if Firstmission_flag then
		ModifiCampInit()
	end

	--****************************************************************************************
	--ajout automatique d'elements en cours de campagne: START
	--****************************************************************************************


	--********************************* targetlist ******************************************************
	dofile("Init/targetlist_init.lua")
	local targetlist_init = DeepCopy(targetlist)
	if not targetlist_init.blue[1] then
		TargetlistToNum(targetlist_init)
	end

	targetlist = nil

	dofile("Active/targetlist.lua")
	if not targetlist.blue[1] then
		TargetlistToNum(targetlist)
	end

	local changes = CompareTargetLists(targetlist_init, targetlist)

	-- Afficher les résultats
	for _, added in ipairs(changes.added) do
		print("Added TargetList: Name:", added.data.name)
	end
	-- for _, removed in ipairs(changes.removed) do
	-- 	print("Removed TargetList: Name:", removed.data.name)
	-- end

	-- Ajout des éléments manquants dans targetlist
	for _, added in ipairs(changes.added) do
		if not targetlist[added.side] then
			targetlist[added.side] = {}
		end
		-- Insérer l'élément à la fin de la table numérique
		table.insert(targetlist[added.side], added.data)
	end

	-- -- Suppression des éléments retirés de targetlist
	-- for _, removed in ipairs(changes.removed) do
	-- 	if targetlist[removed.side] then
	-- 		for i, target in ipairs(targetlist[removed.side]) do
	-- 			if target.name == removed.name then
	-- 				table.remove(targetlist[removed.side], i)
	-- 				break
	-- 			end
	-- 		end
	-- 	end
	-- end

	--********************************* camp_triggers ******************************************************
	-- Charger les fichiers de référence et de travail
	dofile("Init/camp_triggers_init.lua")
	local camp_triggers_init = camp_triggers

	if not IsSequentialTable(camp_triggers) then
    	camp_triggers = ConvertAlphaToNumeric(camp_triggers)
	end

	dofile("Active/camp_triggers.lua")

	-- Comparer les deux tables
	changes = CompareTableNumericTrigger(camp_triggers_init, camp_triggers)

	-- Afficher les résultats
	for _, added in ipairs(changes.added) do
		-- print("Added triggers: Name:", added.name)
	end
	for _, removed in ipairs(changes.removed) do
		-- print("Removed triggers: Name:", removed.name)
	end

	-- Ajouter les éléments manquants dans camp_triggers
	for _, added in ipairs(changes.added) do
		-- _affiche(added, "triggersAdded: ")
		table.insert(camp_triggers, added)
	end
	-- Supprimer les éléments retirés de camp_triggers
	for _, removed in ipairs(changes.removed) do
		for i, trigger in ipairs(camp_triggers) do
			if trigger.name == removed.name then
				table.remove(camp_triggers, i)
				break
			end
		end
	end



	--********************************* db_airbases ******************************************************
	-- Charger les fichiers de référence et de travail
	dofile("Init/db_airbases.lua")
	local db_airbases_init = db_airbases

	dofile("Active/db_airbases.lua")

	-- Comparer les deux tables
	changes = CompareTableAlphaNumeric(db_airbases_init, db_airbases)

	-- Afficher les résultats
	for _, added in ipairs(changes.added) do
		print("\nAdded db_airbases Name:", added.name)
	end
	-- for _, removed in ipairs(changes.removed) do
	-- 	print("\nRemoved db_airbases: Name:", removed.name)
	-- end

	-- Ajouter les éléments manquants dans db_airbases
	for _, added in ipairs(changes.added) do
		db_airbases[added.name] = added.data
	end
	-- -- Supprimer les éléments retirés de db_airbases
	-- for _, removed in ipairs(changes.removed) do
	-- 	db_airbases[removed.name] = nil
	-- end


	--********************************* oob_air ******************************************************
	dofile("Init/oob_air_init.lua")
	local oob_air_init = oob_air

	dofile("Active/oob_air.lua")
	-- oob_air est maintenant la version active

	-- for sideN, side in pairs(DCS_Side) do
	for _, side in ipairs(DCS_Side) do
		if oob_air_init[side] and oob_air[side] then
			-- Construire un index par nom pour la table active
			local activeByName = {}
			for _, unit in pairs(oob_air[side]) do
				if unit.name then
					activeByName[unit.name] = true
				end
			end

			-- Parcourir les unités de l'init et ajouter celles absentes dans l'actif
			for _, unitInit in pairs(oob_air_init[side]) do
				if unitInit.name and not activeByName[unitInit.name] then

					unitInit.roster = {
						ready = unitInit.number,																	--number of airframes ready for operations
						lost = 0,																				--number of airframes lost
						damaged = 0																				--number of airframes damaged
					}
					unitInit.score = {
						kills_air = 0,																			--air kills
						kills_ground = 0,																		--ground kills
						kills_ship = 0																			--ship kills
					}
					if unitInit.reserve then
						unitInit.roster.reserve = unitInit.reserve
					end


					-- Trouver le prochain index numérique libre
					local idx = #oob_air[side] + 1
					oob_air[side][idx] = unitInit
					print("Ajouté à oob_air["..side.."] : "..unitInit.name)
				end
			end
		end
	end

	-- -- petit code pour remettre les stock init comme au debut
	-- if adjust_DCE_GC22 then
	-- 	for side, sideTab in pairs(oob_air_init) do
	-- 		if oob_air[side] then
	-- 			for _, unitInit in pairs(sideTab) do
	-- 				local found = false
	-- 				for _, unitActive in pairs(oob_air[side]) do
	-- 					if unitActive.name == unitInit.name then
	-- 						found = true
	-- 						if unitActive.number ~= unitInit.number then
	-- 							if unitInit.number > unitActive.number then
	-- 								if Debug and Debug.debug then
	-- 									print("Check/MAJ oob_air oob_air_init/number to Active/number pour "..tostring(unitInit.type).." || "..unitActive.name.." ("..side..") : "..tostring(unitInit.number).." -> "..tostring(unitActive.number).." = "..tostring(unitInit.number))
	-- 								end
	-- 								unitActive.number = unitInit.number
	-- 								unitActive.number = unitInit.number
	-- 								if unitActive.rooster and unitActive.rooster.ready then
	-- 									unitActive.rooster.ready = unitInit.number
	-- 								end
	-- 							else
	-- 								if Debug and Debug.debug then
	-- 									print("Check ---- oob_air_init/number to Active/number ----- pour "..tostring(unitInit.type).." || "..unitActive.name.." ("..side..") : "..tostring(unitInit.number ).." -> "..tostring(unitActive.number))
	-- 								end
	-- 							end
	-- 						end
	-- 						break
	-- 					end
	-- 				end
	-- 				if not found and Debug and Debug.debug then
	-- 					print("Unité "..unitInit.name.." ("..side..") non trouvée dans Active/oob_air")
	-- 				end
	-- 			end
	-- 		end
	-- 	end
	-- end

	--****************************************************************************************
	--ajout automatique d'elements en cours de campagne: FIN
	--****************************************************************************************


	-- Exécution du fichier s'il existe
	local testFile = "Init/various_table.lua"
	if FileExists(testFile) then
		dofile(testFile)
	else
		if TypeAlias then
			local _str = "TypeAlias = " .. TableSerialization(TypeAlias, 0)
			local _file = io.open("Init/various_table.lua", "w") or error("Failed to open debug file")
			_file:write(_str)
			_file:close()
		end
	end

	for planeType, value in PairsByKeys(Data_divers) do
		if value.playable then
			Playable_m[planeType] = true
		end
	end

	--si le joueur fait un saut temporel (via date dans conf_mod) on met a jour les fichiers de la campagne
	if not Firstmission_flag and TimeJump then
		if Debug.debug then
			print("UtilF jumpTime_C : "..tostring(TimeJump))
			_affiche(mission_ini.current_date, "mission_ini.current_date")
			_affiche(camp.date, "camp.date")
		end
		UpdateFilesAfterTimeJump()
	end



	--**************INITIALEMENT DANS MAIN_NextMission *****************************
	--**************INITIALEMENT DANS MAIN_NextMission *****************************
	require("Active/oob_ground")
	require("Init/conf_mod")

	-- Si Active/camp_ZoneSAR n'existe pas, on le crée, sinon on le charge
	local zoneSARFile = "../../../Missions/Campaigns/"..camp.title.."/Active/camp_ZoneSAR.lua"
	local f2 = io.open(zoneSARFile, "r")
	if f2 then
		f2:close()
		require("Active/camp_ZoneSAR")
	else
		camp_ZoneSAR = { blue = {}, red = {}, neutrals = {} }
	end


	dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_DataRadio.lua")

	--remplit la table des frequences déjà utilisé dans la map ou les bases
	AssignedFrequencies()

	--utilise ici le fichier Init/persistenceMP.lua s'il existe, pour facilité l'attribution des num tail/avion
	local persistPath = "../../../Missions/Campaigns/"..camp.title.."/Init/persistenceMP.lua"
	Try_dofile(persistPath)

	--reorganise la table PersistenceMP en fonction de la Task et rank
	if PersistenceMP then
		PersistenceMP_byTask = {}
		for pilotName, pilotData in pairs(PersistenceMP) do
			local task = pilotData.task or "Unknown"
			local rank = pilotData.rank or "Unknown"
			if pilotData.active then
				if not PersistenceMP_byTask[task] then
					PersistenceMP_byTask[task] = {}
				end
				if not PersistenceMP_byTask[task][rank] then
					PersistenceMP_byTask[task][rank] = {}
				end
				pilotData.name = pilotName
				PersistenceMP_byTask[task][rank] = pilotData
			end

		end
		-- s'assure que la renumerotation ne comporte pas de trou
		for task, ranks in pairs(PersistenceMP_byTask) do
			local newRanks = {}
			local rankIndex = 1
			for rank, pilotData in pairs(ranks) do
				newRanks[rankIndex] = pilotData
				rankIndex = rankIndex + 1
			end
			PersistenceMP_byTask[task] = newRanks
		end

	end

	dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_CampaignSettings.lua")
	dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_Refpoints.lua")
	dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_AddPropAircraft.lua")

	 if Debug.debug then
        print("LOAD LoadFileAndUpdate() from " .. tostring(from))
    end


	--////////////////////////////////////////////////////////
	LoadModData("Mods", true)
	BuildLoadout()
	--////////////////////////////////////////////////////////

	CreateAircraftListInCampaign()
	--supprime des mega grosse table DATA les info supperflue
	CleanDataDivers()

	--/////////////////////////////////////////////////////////////////////
	--/////////////////////////////////////////////////////////////////////

	InheritedFromProcessing()
	DataCompilation_DataDiscoveryA2()
	DataCompilation_TaskByPlane()

	if Debug.debug then

		camp_str = "Failures = " .. TableSerialization(Failures, 0)
		campFile = io.open("Debug/Failures.lua", "w") or error("Échec d'ouverture du fichier Failures")
		campFile:write(camp_str)
		campFile:close()

		camp_str = "CampaignAircraft = " .. TableSerialization(AircraftInCampaign, 0)
		campFile = io.open("Debug/AircraftInCampaign.lua", "w") or error("Échec d'ouverture du fichier Failures")
		campFile:write(camp_str)
		campFile:close()

		camp_str = "AircraftCampaignBySide = " .. TableSerialization(AircraftCampaignBySide, 0)
		campFile = io.open("Debug/AircraftCampaignBySide.lua", "w") or error("Échec d'ouverture du fichier Failures")
		campFile:write(camp_str)
		campFile:close()
	end

	Check_TaskPossibleByPlane()


	dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_Time.lua")
	dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_MoonPhase.lua")
	dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_Weather.lua")
	dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_NavalEnvironment.lua")
	dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_UpdateSAR.lua")

	-- CreatePlageFrequency_A()-- TODO a confirmer qu'il est encore utile cree une table de radio en fonction du canal puis de la wave
	-- CreatePlageFrequency_B()	--cree une table de radio en fonction des wave

	CommonRanges = DCE_FindCommonRadioRanges()	--get common radio range for all planes in campaign

	local file_str = "CommonRanges = " .. TableSerialization(CommonRanges, 0)			--make a string
	local file_File = io.open("Debug/Radio_CommonRanges.lua", "w") or error("Failed to open debug EWR_UtilDebug file")
	file_File:write(file_str)																	--save new data
	file_File:close()

	dofile("../../../ScriptsMod."..VersionPackageICM.."/ATO_ThreatEvaluation.lua")
	dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_UpdateTargetlist.lua")
	CheckAll_Id()
	if Debug.debug then print ("Lancement VIA UTIL_Fonction F 5687 (LoadFileAndUpdate)") end
	dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_CheckTriggers.lua")
	if not camp.boundary then
		--creation des borders
		GetBoundary()
	end
	dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_UpdateTargetlist.lua")
	if Debug.debug then print ("Lancement VIA UTIL_Fonction G 5690 (LoadFileAndUpdate)") end
	dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_CheckTriggers.lua")
	--**************INITIALEMENT DANS MAIN_NextMission *****************************
	--**************INITIALEMENT DANS MAIN_NextMission *****************************


end

-- Convertit une date en "nombre absolu de jours" depuis 1/1/0001
local function dateToAbsoluteDays(y, m, d)
    local monthDays = {31,28,31,30,31,30,31,31,30,31,30,31}

    local function isLeap(year)
        return (year % 4 == 0 and year % 100 ~= 0) or (year % 400 == 0)
    end

    local days = d

    -- Ajouter les jours des mois précédents
    for i = 1, m - 1 do
        days = days + monthDays[i]
        if i == 2 and isLeap(y) then
            days = days + 1
        end
    end

    -- Ajouter les jours des années précédentes
    for year = 1, y - 1 do
        days = days + (isLeap(year) and 366 or 365)
    end

    return days
end

function SecondsBetween(date1, date2)
    local abs1 = dateToAbsoluteDays(date1.year, date1.month, date1.day)
    local abs2 = dateToAbsoluteDays(date2.year, date2.month, date2.day)

    local deltaDays = math.abs(abs2 - abs1)
    return deltaDays * 24 * 3600
end

function PatchEjectedPilotStructure(pilot, from)

	if not pilot.type then
		pilot.type = "ejectedPilot"
	end

	-- print("utilF pilot.x2d "..tostring(pilot.x2d).." pilot.y2d "..tostring(pilot.y2d).." pilot.z2d "..tostring(pilot.z2d).." pilot.name "..tostring(pilot.name) )

	pilot.radio_on = nil
	pilot.smokeTiming = nil
	pilot.radio_start = nil
	pilot.closeRoad = nil
	-- pilot.pos = nil
	pilot.groupSAR = nil
	pilot.nameId = nil
	pilot.unit = nil
	pilot.initiatorMissionID = nil
	pilot.createdSoldier = nil
	pilot.initiator = nil
	pilot.unitObj = nil

	if not pilot.date then
		pilot.date = {
			day = pilot.day,
			month = pilot.month,
			year = pilot.year,
			hour = pilot.hour,
		}
		pilot.day = nil
		pilot.month = nil
		pilot.year = nil
		pilot.hour = nil
	end

	if not pilot.pos then
		if pilot.vec3x then
			pilot.pos = {
				vec3x = pilot.vec3x,
				vec3y = pilot.vec3y,
				vec3z = pilot.vec3z,
				x = pilot.vec3x,
				y = pilot.vec3z,
				z = pilot.vec3y,
				surfaceType = pilot.SurfaceType,
			}
		elseif pilot.x2d then
			pilot.pos = {
				vec3x = pilot.x2d,
				vec3y = pilot.z2d,
				vec3z = pilot.y2d,
				x = pilot.x2d,
				y = pilot.y2d,
				z = pilot.z2d,
				surfaceType = pilot.SurfaceType,
			}
		else
			print("Error PatchEjectedPilotStructure no pos for pilot "..tostring(pilot.name) )
		end
		pilot.x = nil
		pilot.y = nil
		pilot.z = nil
		pilot.x2d = nil
		pilot.y2d = nil
		pilot.z2d = nil
		pilot.SurfaceType = nil
	end

	if from == "targetlist" then
		
		if not pilot.x then
			-- dans targetlist on a pas le side
			pilot.x = pilot.pos.x
			pilot.y = pilot.pos.y
			pilot.z = pilot.pos.z
		end

		if pilot.firepower.max then
			pilot.firepower.max = 1
		end
	end

	-- if not pilot.sumEjectedPilotDay then
	-- 	pilot.sumEjectedPilotDay = pilot.SumEjectedPilotDay
		pilot.SumEjectedPilotDay = nil
	-- end


	if not pilot.dataPOW then
		pilot.dataPOW = {
			initChoicePOW = pilot.initChoicePOW or false,
			ejectNbDay = pilot.ejectNbDay or 0,
			POW_nextDayCheck = pilot.POW_nextDayCheck or 2,
			PowDayMax = pilot.PowDayMax or math.random(3, 15),
		}
		pilot.initChoicePOW = nil
		pilot.ejectNbDay = nil
		pilot.POW_nextDayCheck = nil
		pilot.PowDayMax = nil
	end

	return pilot

end




-- Safe helper: debug may be overridden in some environments, avoid calling nil

function SafeGetLine()

    if type(debug) == "table" and type(debug.getinfo) == "function" then

        local info = debug.getinfo(2)

        return info and info.currentline or 0

    end

    return 0

end

--demandé par 2 fichiers, normalement via MAIN_NextMission et UTIL_DIvers outils
function AddIconLayer(layersObjects, targetListRequired)


        -- [4] = 
        -- {
        --     ["visible"] = true,
    --     ["name"] = "Common",
        --     ["objects"] = 
        --     {
            -- [27] = 
            --     {
            --         ["visible"] = true,
            --         ["mapY"] = 445695.43,
            --         ["primitiveType"] = "Icon",
            --         ["scale"] = 1,
            --         ["file"] = "P91000072.png",
            --         ["colorString"] = "0x000000ff",
            --         ["mapX"] = 63776.31,
            --         ["layerName"] = "Common",
            --         ["name"] = "Warehouse - 20",
            --         ["angle"] = 0,



    local dataType = {
        ["warehouse"] = {
            ["type"] = "icon",
            ["data"] = "P91000072.png",
        },
        ["ammo_supply"] = {
            ["type"] = "icon",
            ["data"] = "P91000072.png",
        },
        ["logistic_center"] = {
            ["type"] = "icon",
            ["data"] = "P91000072.png",
        },
        ["fuel_storage"] = {
            ["type"] = "icon",
            ["data"] = "P91000207.png",
        },
        ["fuel_tank"] = {
            ["type"] = "icon",
            ["data"] = "P91000207.png",
        },
        ["power_plant"] = {
            ["type"] = "txt",
            ["data"] = "PP",
        },
        ["power_supply"] = {
            ["type"] = "txt",
            ["data"] = "PS",
        },
        ["rail_bridge"] = {
            ["type"] = "txt",
            ["data"] = "RB",
        },
        ["road_bridge"] = {
            ["type"] = "txt",
            ["data"] = "B",
        },
        ["control_tower"] = {
            ["type"] = "txt",
            ["data"] = "CT",
        },
        ["command_center"] = {
            ["type"] = "txt",
            ["data"] = "HQ",
        },
        ["airplane_shelter"] = {
            ["type"] = "txt",
            ["data"] = "AS",
        },
        ["default_target"] = {
            ["type"] = "txt",
            ["data"] = "T",
        },
        ["civil_ship"] = {
            ["type"] = "txt",
            ["data"] = "CS",
        },
        ["loading_crane"] = {
            ["type"] = "txt",
            ["data"] = "LC",
        },
        ["communication_center"] = {
            ["type"] = "txt",
            ["data"] = "CC",
        },
		["runway part"] = {
            ["type"] = "txt",
            ["data"] = "RW",
        },
    }

    -- Les couleurs dans DCS sont généralement définies au format hexadécimal ARGB (Alpha, Rouge, Vert, Bleu).
    -- Par exemple : "0xRRGGBBAA" où AA est l'opacité (FF = opaque).
    -- Les couleurs standards utilisées dans les fichiers mission DCS sont souvent :
    local colorType = {
        ["red"]   = "0xff0000ff", -- Rouge pur, opaque
        ["blue"]  = "0x0000ffff", -- Bleu pur, opaque
        ["black"] = "0x000000ff", -- Noir, opaque
        ["white"] = "0xffffffff", -- Blanc, opaque
        ["green"] = "0x00ff00ff", -- Vert pur, opaque
        ["yellow"]= "0xffff00ff", -- Jaune, opaque
    }

    local x_Legend = 999999999
    local y_Legend = 999999999

    local nb = 0
    for targetClientN, targetClientName in pairs(targetListRequired) do
        for targetSide, targets in pairs(targetlist) do
            for targetN, target in pairs(targets) do
                 if target.name == targetClientName and target.elements then
                    for elementN, element in pairs(target.elements) do

                        local function matchTypeFromName(name)
                            local lowerName = string.lower(name)
                            for key, val in pairs(dataType) do
                                local allFound = true
                                for sub in string.gmatch(key, "([^_]+)") do
                                    if not string.find(lowerName, sub) then
                                        allFound = false
                                        break
                                    end
                                end
                                if allFound then
                                    return key, val
                                end
                            end
                            return "default_target", dataType["default_target"]
                        end

                        -- Utilisation dans ta boucle :
                        local colorDefine
                        local tempObject = {}
                        local typeMatched, dataInfo = matchTypeFromName(element.name)
                        local data = dataInfo.data
                        local layerType = dataInfo.type


                        -- print("Element Name: " .. element.name .. ", Matched Type: " .. typeMatched)
                        -- _affiche(dataInfo, "dataInfo ")


                        if typeMatched then
                            data = dataType[typeMatched].data
                            layerType = dataType[typeMatched].type

                            --definitions des couleurs
                            if element.dead then
                                colorDefine = colorType["black"]
                            else
                                colorDefine = colorType["red"]
                            end

                            if layerType == "icon" then
                                tempObject = {
                                    ["visible"] = true,
                                    ["mapX"] = element.x,
                                    ["mapY"] = element.y,
                                    ["primitiveType"] = "Icon",
                                    ["scale"] = 1,
                                    ["file"] = tostring(data),
                                    ["name"] = tostring(element.name),
                                    ["colorString"] = tostring(colorDefine),
                                    ["layerName"] = "Common",
                                    ["angle"] = 0,
                                }
                            elseif layerType == "txt" then
                                tempObject =
                                {
                                    ["visible"] = true,
                                    ["borderThickness"] = 0,
                                    ["fillColorString"] = "0xffffff00", -- fond est transparent
                                    ["fontSize"] = 15,
                                    ["mapX"] = element.x,
                                    ["mapY"] = element.y,
                                    ["layerName"] = "Common",
                                    ["primitiveType"] = "TextBox",
                                    ["font"] = "DejaVuLGCSansCondensed.ttf",
                                    ["text"] = tostring(data),
                                    ["name"] = tostring(element.name),
                                    ["colorString"] = tostring(colorDefine),
                                    ["angle"] = 0,
                                }
                            end

                            -- Trouver la position la plus à gauche (minX) et la plus en bas (minY) de tous les éléments du groupe
                            -- On initialise minX et minY si ce n'est pas déjà fait
                            if not x_Legend or element.x -200 < x_Legend then
                                x_Legend = element.x -200
                            end
                            if not y_Legend or element.y - 200 < y_Legend then
                                y_Legend = element.y - 200
                            end

                            nb = nb + 1
                            table.insert(mission.drawings.layers[4].objects, tempObject)
                        end
                    end
                end
            end
        end
    end

    -- print("Number of targets added to the mission: " .. nb)
    -- print("x_Legend: " .. x_Legend.." y_Legend: " .. y_Legend)



    x_Legend = x_Legend -500 -- Ajuster la position ordonné pour le texte

    if nb > 0 and LayerObjectsLegend then
        -- Trouver le point d'ancrage de la légende (origine du template)
        local legend_minX = math.huge
        local legend_minY = math.huge
        for _, object in ipairs(LayerObjectsLegend) do
            if object.mapX and object.mapX < legend_minX then legend_minX = object.mapX end
            if object.mapY and object.mapY < legend_minY then legend_minY = object.mapY end
        end

        -- Décaler chaque objet de la légende pour l'aligner sur la cible
        for _, object in ipairs(LayerObjectsLegend) do
            local delta_x = (object.mapX or 0) - legend_minX
            local delta_y = (object.mapY or 0) - legend_minY

            object.mapX = x_Legend + delta_x
            object.mapY = y_Legend + delta_y

            -- print("object.mapX: "..object.mapX.." (x_Legend: "..x_Legend.." + delta_x: "..delta_x..")")
            -- print("object.mapY: "..object.mapY.." (y_Legend: "..y_Legend.." + delta_y: "..delta_y..")")

            table.insert(mission.drawings.layers[4].objects, object)
        end
    end

        -- os.execute 'pause'

    return layersObjects

end

--cration de la table listant les avions uniquement necessaire à la campagne:
function CreateAircraftListInCampaign()
	for sideName, squads in pairs(oob_air) do
		for squadN, squad in pairs(squads) do
			--ne pas tenir compte des escadrilles inactives, car si activation en cours, ça bug
			-- if not squad.inactive then
				if not AircraftInCampaign[squad.type] then
					AircraftInCampaign[squad.type] = true
					AircraftCampaignBySide[sideName][squad.type] = true

					if IsHelicopter[squad.type] then
						HelicoBySide[sideName][squad.type] = true
					else
						PlaneBySide[sideName][squad.type] = true
					end
				end
					if squad.player then
						AircraftInCampaign[squad.type] = "player"
						SidePlayer = sideName
					end
					if squad.client then
						AircraftInCampaign[squad.type] = "client"
					end
			-- end
		end
	end
end


--supprime de la mega table Data_divers les avions qui ne sont pas listé dans CampaignAircraft
function CleanDataDivers()
	for planeType, _ in pairs(Data_divers) do
		if not AircraftInCampaign[planeType] then
			Data_divers[planeType] = nil
		end
	end
	for planeType, _ in pairs(Db_Frequency) do
		if not AircraftInCampaign[planeType] then
			Db_Frequency[planeType] = nil
		end
	end

		camp_str = "AircraftInCampaign = " .. TableSerialization(AircraftInCampaign, 0)						--make a string
		campFile = io.open("Debug/Z_AircraftInCampaign.lua", "w")	 or error("Failed to open debug file")
		campFile:write(camp_str)																		--save new data
		campFile:close()

		camp_str = "Db_Frequency = " .. TableSerialization(Db_Frequency, 0)						--make a string
		campFile = io.open("Debug/Z_Db_Frequency.lua", "w")	 or error("Failed to open debug file")
		campFile:write(camp_str)																		--save new data
		campFile:close()

end


function SetBoundaryFromCamp()
	
	-- print("BOUNDARY SetBoundaryFromCamp _A ".." camp.boundary "..tostring(camp.boundary) )

	--ecrase mission pour mettre à jour son boundary
	if camp.boundary then

		-- print("BOUNDARY SetBoundaryFromCamp _B camp.boundary existe, on met à jour le boundary de la mission en cours")
		
		--si camp.boundary existe, il faut ecraser celui de la mission en cours
		-- car ce n'est peut etre pas le meme

		local drawTbl = {}
		if mission and mission.drawings then

			-- print("BOUNDARY SetBoundaryFromCamp _C mission.drawings existe, on cherche une ligne border a ecraser dans les layers de la mission")

			drawTbl = mission.drawings
			
			-- cherche si un bordery existe et le remplace
			if drawTbl and drawTbl.layers then
				for layersN, layer in ipairs( drawTbl.layers) do
					if (layer.name == "Red" or layer.name == "Blue" or layer.name == "Neutral" ) and layer.objects and #layer.objects >= 1 then
						for objetN, objet in ipairs(layer.objects) do
							local testName = string.lower(objet.name)
							if ( string.find( testName , "border") or string.find( testName , "boundary") or string.find( testName , "frontline")   ) and #objet.points >= 3 then
								if string.find( testName , "blue") then

									if camp.boundary.data and camp.boundary.data.blue then
										objet.colorString = camp.boundary.data.blue.color or "0x0000ffff"
										objet.mapY = camp.boundary.data.blue.mapY or 0
										objet.mapX = camp.boundary.data.blue.mapX or 0

										-- objet.points = camp.boundary.blue

										local newPoints = {}
										for n, point in ipairs(camp.boundary.blue) do
											newPoints[n] = {
												x = point.x - camp.boundary.data.blue.mapX,
												y = point.y - camp.boundary.data.blue.mapY,
											}
										end
										objet["points"] = newPoints
									end



								elseif string.find( testName , "red") then

									if camp.boundary.data and camp.boundary.data.red then
										objet.colorString = camp.boundary.data.red.color or "0xff0000ff"
										objet.mapY = camp.boundary.data.red.mapY or 0
										objet.mapX = camp.boundary.data.red.mapX or 0

										-- objet.points = camp.boundary.red
									
										local newPoints = {}
										for n, point in ipairs(camp.boundary.red) do
											newPoints[n] = {
												x = point.x - camp.boundary.data.red.mapX,
												y = point.y - camp.boundary.data.red.mapY,
											}
										end
										objet["points"] = newPoints
									end
								end
							end
						end
					end
				end
			end

		else

			-- print("BOUNDARY SetBoundaryFromCamp _D mission.drawings n'existe pas, on le crée avec le boundary du camp")

			mission.drawings = {
				["options"] = 
					{
						["hiddenOnF10Map"] = 
						{
							["Observer"] = 
							{
								["Neutral"] = false,
								["Blue"] = false,
								["Red"] = false,
							}, -- end of ["Observer"]
							["Instructor"] = 
							{
								["Neutral"] = false,
								["Blue"] = false,
								["Red"] = false,
							}, -- end of ["Instructor"]
							["ForwardObserver"] = 
							{
								["Neutral"] = false,
								["Blue"] = false,
								["Red"] = false,
							}, -- end of ["ForwardObserver"]
							["Pilot"] = 
							{
								["Neutral"] = false,
								["Blue"] = false,
								["Red"] = false,
							}, -- end of ["Pilot"]
							["Spectrator"] = 
							{
								["Neutral"] = false,
								["Blue"] = false,
								["Red"] = false,
							}, -- end of ["Spectrator"]
							["ArtilleryCommander"] = 
							{
								["Neutral"] = false,
								["Blue"] = false,
								["Red"] = false,
							}, -- end of ["ArtilleryCommander"]
						}, -- end of ["hiddenOnF10Map"]
					}, -- end of ["options"]
				layers =
				{
					[1] = 
					{
						["visible"] = true,
						["name"] = "Red",
						["objects"] = {},
					}, -- end of [1]
					[2] = 
					{
						["visible"] = true,
						["name"] = "Blue",
						["objects"] = {},
					}, -- end of [2]
					[3] = 
					{
						["visible"] = true,
						["name"] = "Neutral",
						["objects"] = {},
					}, -- end of [3]
					[4] = 
					{
						["visible"] = true,
						["name"] = "Common",
						["objects"] = {},
					}, -- end of [4]
					[5] = 
					{
						["visible"] = true,
						["name"] = "Author",
						["objects"] = {},
					}, -- end of [5]
				}, -- end of ["layers"]
			}

			if camp.boundary.blue and #camp.boundary.blue >= 3 then
				-- print("BOUNDARY SetBoundaryFromCamp _E camp.boundary.blue existe et comporte au moins 3 points, on ajoute une ligne blue dans les layers de la mission")

				mission.drawings.layers[2] = {
					name = "Blue",
					visible = true,
					objects = {
						[1] = {
							["visible"] = true,
							["colorString"] = camp.boundary.data.blue.color or "0x0000ffff",
							["lineMode"] = "segments",
							["mapY"] = camp.boundary.data.blue.mapY or 0,
							["primitiveType"] = "Line",
							["style"] = "solid",
							["closed"] = false,
							["thickness"] = 8,
							["mapX"] = camp.boundary.data.blue.mapX or 0,
							["layerName"] = "Blue",
							["name"] = "Border-Blue",
							-- ["points"] = camp.boundary.blue,
						},
					},
				}

				local newPoints = {}
				for n, point in ipairs(camp.boundary.blue) do
					newPoints[n] = {
						x = point.x - camp.boundary.data.blue.mapX,
						y = point.y - camp.boundary.data.blue.mapY,
					}
				end
				mission.drawings.layers[2].objects[1]["points"] = newPoints

			end

			if camp.boundary.red and #camp.boundary.red >= 3 then
				mission.drawings.layers[1] = {
					name = "Red",
					visible = true,
					objects = {
						[1] = {
							["visible"] = true,
							["colorString"] = camp.boundary.data.red.color or "0xff0000ff",
							["lineMode"] = "segments",
							["mapY"] = camp.boundary.data.red.mapY or 0,
							["primitiveType"] = "Line",
							["style"] = "solid",
							["closed"] = false,
							["thickness"] = 8,
							["mapX"] = camp.boundary.data.red.mapX or 0,
							["layerName"] = "Red",
							["name"] = "Border-Red",
							-- ["points"] = camp.boundary.red,
						},
					},
				}

				local newPoints = {}
				for n, point in ipairs(camp.boundary.red) do
					newPoints[n] = {
						x = point.x - camp.boundary.data.red.mapX,
						y = point.y - camp.boundary.data.red.mapY,
					}
				end
				mission.drawings.layers[1].objects[1]["points"] = newPoints

			end

		end


	end
end

--recupere les info boundary de base_mission ou mission trigger pour remplir le camp.boundary
function GetBoundary(missionWork)

	-- print("BOUNDARY GetBoundary _A missionWork "..tostring(missionWork).." camp.boundary "..tostring(camp.boundary) )

	if not missionWork then missionWork = mission end
		
	local boundary = {
		red = {},
		blue = {},
		neutral = {},
	}

	local tableDrawings = {}
	if missionWork and missionWork.drawings then
		tableDrawings = missionWork.drawings
	else
		AddLog("Error: No drawings found in the mission to extract boundary information.")
		return false
	end
	local foundBoundary = false

	-- creation des frontieres en fonction des dessins dans missionWork red et blue qui comporte le nom border ou boundary
	if tableDrawings and tableDrawings.layers then
		-- print("BOUNDARY GetBoundary _B tableDrawings.layers existe, on cherche une ligne border dans les layers de la mission")

		for layersN, layer in ipairs( tableDrawings.layers) do
			-- print("BOUNDARY GetBoundary _C layer.name "..tostring(layer.name).." layer.objects "..tostring(layer.objects) )

			if (layer.name == "Red" or layer.name == "Blue" or layer.name == "Neutral" ) and layer.objects and #layer.objects >= 1 then
				-- print("BOUNDARY GetBoundary _D layer.name "..tostring(layer.name).." correspond à une faction et comporte des objets, on cherche un objet border ou boundary dans les objets du layer")

				for objetN, objet in ipairs(layer.objects) do
					local testName = string.lower(objet.name)
					-- print("BOUNDARY GetBoundary _E objet.name "..tostring(objet.name).." testName "..tostring(testName) )

					if ( string.find( testName , "border") or string.find( testName , "boundary") or string.find( testName , "frontline")   ) and #objet.points >= 3 then
						-- print("BOUNDARY GetBoundary _F objet.name "..tostring(objet.name).." correspond à une frontière et comporte au moins 3 points, on ajoute les points à la table boundary")

						if objet.points and #objet.points >= 3 then
							-- print("BOUNDARY GetBoundary _G objet.name "..tostring(objet.name).." comporte "..#objet.points.." points, on les ajoute à la table boundary")

							camp.boundary = camp.boundary or {}
							camp.boundary.data = camp.boundary.data or {}
							camp.boundary.data[string.lower(layer.name)] = camp.boundary.data[string.lower(layer.name)] or {}
							camp.boundary.data[string.lower(layer.name)].color = objet.colorString or (layer.name == "Red" and "0xff0000ff" or "0x0000ffff")
							camp.boundary.data[string.lower(layer.name)].mapX = objet.mapX or 0
							camp.boundary.data[string.lower(layer.name)].mapY = objet.mapY or 0

							for n, point in ipairs(objet.points) do
								local newPoints = {
									x = point.x + objet.mapX,
									y = point.y + objet.mapY,
								}

								table.insert(boundary[string.lower(layer.name)], newPoints)

								foundBoundary = true
							end

							camp.boundary[string.lower(layer.name)] = boundary[string.lower(layer.name)]
						end
					end
				end
			end
		end
	end

	if not foundBoundary then
		local bugTxt = " * * * DcUsar there are no valid borders in this campaign * * * "
		AddLog("Note for the Campaign Maker"..bugTxt)
		return false
	else
		return true
	end
end

function LoadMissionFromMizIsolated(misStr)

    local chunk, err = loadstring(misStr)
    if not chunk then
        error("Erreur loadstring mission: "..tostring(err))
    end

    local env = {}
    setmetatable(env, { __index = _G })

    setfenv(chunk, env)

    local ok, execErr = pcall(chunk)
    if not ok then
        error("Erreur execution mission: "..tostring(execErr))
    end

    return env.mission
end


---------------------------------------------------------------------
-- Formate un nombre avec des zéros devant (ex: 7 -> "007")
-- Pourquoi : DCS ne supporte pas %0*d dans string.format
---------------------------------------------------------------------
local function padnumber(num, size)

    local s = tostring(num)

    while #s < size do
        s = "0" .. s
    end

    return s
end

---------------------------------------------------------------------
-- Convertit une latitude / longitude WGS84 en MGRS simplifié
-- Précision : 1 km ou 100 m selon le paramètre
---------------------------------------------------------------------
function LatLonToMGRS(lat, lon, precision)
    -- Pourquoi : constantes WGS84 nécessaires à la projection UTM
    local a = 6378137.0
    local f = 1 / 298.257223563
    local k0 = 0.9996
    local e2 = f * (2 - f)

    -- Pourquoi : calcul de la zone UTM
    local zone = math.floor((lon + 180) / 6) + 1

    -- Pourquoi : méridien central de la zone
    local lon0 = math.rad((zone - 1) * 6 - 180 + 3)

    -- Conversion degrés → radians
    local lat_rad = math.rad(lat)
    local lon_rad = math.rad(lon)

    -- Pourquoi : termes intermédiaires pour la projection
    local n = a / math.sqrt(1 - e2 * math.sin(lat_rad)^2)
    local t = math.tan(lat_rad)^2
    local c = (e2 / (1 - e2)) * math.cos(lat_rad)^2
    local a_term = math.cos(lat_rad) * (lon_rad - lon0)

    -- Pourquoi : calcul du méridien (formule UTM standard)
    local m = a * (
        (1 - e2 / 4 - 3 * e2^2 / 64 - 5 * e2^3 / 256) * lat_rad
        - (3 * e2 / 8 + 3 * e2^2 / 32 + 45 * e2^3 / 1024) * math.sin(2 * lat_rad)
        + (15 * e2^2 / 256 + 45 * e2^3 / 1024) * math.sin(4 * lat_rad)
        - (35 * e2^3 / 3072) * math.sin(6 * lat_rad)
    )

    -- Calcul Easting / Northing UTM
    local easting = k0 * n * (
        a_term
        + (1 - t + c) * a_term^3 / 6
        + (5 - 18 * t + t^2 + 72 * c) * a_term^5 / 120
    ) + 500000

    local northing = k0 * (
        m
        + n * math.tan(lat_rad) * (
            a_term^2 / 2
            + (5 - t + 9 * c + 4 * c^2) * a_term^4 / 24
        )
    )

    -- Pourquoi : correction hémisphère sud
    if lat < 0 then
        northing = northing + 10000000
    end

    -- Pourquoi : bande latitudinale MGRS
    local bands = "CDEFGHJKLMNPQRSTUVWX"
    local band = bands:sub(math.floor((lat + 80) / 8) + 1,
                            math.floor((lat + 80) / 8) + 1)

    -- Pourquoi : carrés 100 km MGRS
    local e100k = math.floor(easting / 100000)
    local n100k = math.floor(northing / 100000)

    local e_letters = {"ABCDEFGH", "JKLMNPQR", "STUVWXYZ"}
    local e_letter = e_letters[(zone - 1) % 3 + 1]:sub(e100k + 1, e100k + 1)

    local n_letters = "ABCDEFGHJKLMNPQRSTUV"
    local n_letter = n_letters:sub((n100k % 20) + 1, (n100k % 20) + 1)

    -- Pourquoi : réduction selon la précision demandée
    local scale = (precision == 100) and 100 or 1000

    local e_reduced = math.floor((easting % 100000) / scale)
    local n_reduced = math.floor((northing % 100000) / scale)

    local digits = (precision == 100) and 3 or 2

	local zone_str = padnumber(zone, 2)
	local e_str = padnumber(e_reduced, digits)
	local n_str = padnumber(n_reduced, digits)

	return zone_str .. band .. " " ..
		e_letter .. n_letter .. " " ..
		e_str .. " " .. n_str

end


---------------------------------------------------------------------
-- Génère une zone MGRS floue (1km / 2km / 10km) à partir d'une table grid
-- Pourquoi : représenter une zone d'incertitude (chute, impact, radar…)
---------------------------------------------------------------------
function GetFuzzyMGRS(grid, precision)

    -- precision en mètres : 1000 / 2000 / 10000

    local e = tostring(grid.Easting)
    local n = tostring(grid.Northing)

    -- Sécurité : toujours 5 chiffres
    while #e < 5 do e = "0" .. e end
    while #n < 5 do n = "0" .. n end

    local mask

    -- Pourquoi : nombre de chiffres à masquer selon la précision
    if precision == 1000 then
        mask = 2       -- 1 km → xx
    elseif precision == 2000 then
        mask = 2       -- 2 km ≈ même affichage, mais interprétation plus large
    elseif precision == 10000 then
        mask = 3       -- 10 km → xxx
    else
        mask = 2       -- défaut = 1 km
    end

    local function maskdigits(s, count)

        return s:sub(1, 5 - count) .. string.rep("x", count)
    end

    local e_fuzzy = maskdigits(e, mask)
    local n_fuzzy = maskdigits(n, mask)

    return grid.UTMZone .. "_" ..
           grid.MGRSDigraph .. "_" ..
           e_fuzzy .. "_" ..
           n_fuzzy
end

-- function SetBaseClient(baseName)

-- 	--parse la table db_airbases puis trouve la baseName puis y ajoute la variable : client = true
-- 	for baseTitre, base in pairs(db_airbases) do
-- 		if base.name == baseName then
-- 			base.client = true
-- 			return true
-- 		end
-- 	end

-- 	return false
-- end

-- function ResetBaseClient()

-- 	--parse la table db_airbases et met à nil tout base.client
-- 	for baseTitre, base in pairs(db_airbases) do
-- 		base.client = nil
-- 	end

-- end

function SetBaseHumain(baseSelected)
	for baseName, base in pairs(db_airbases) do
		if baseName == baseSelected then
			base["humainSquad"] = true
			return true
			-- break
		end
	end
	return false
end
function ResetBaseHumain()
	for baseName, base in pairs(db_airbases) do
		base.humainSquad = nil
	end
end

function SetUnitClient(unitName)
	--parse la table oob_air puis trouve unitName puis y ajoute la variable : client = true
	for sideName, squads in pairs(oob_air) do
		for squadN, squad in pairs(squads) do
			if squad.name == unitName then
				squad.client = true
				SetBaseHumain(squad.base)
				local result = SetBaseHumain(squad.base)
				if not result then 
					AddLog("BatSM ECHEC to set HumanBase " ..tostring(squad.base))
				end
				return true
			end
		end
	end

	-- print("SetUnitClient return FALSE")
	return false
end

function ResetUnitClient()
	--parse la table oob_air et met à nil tout squad.client
	for sideName, squads in pairs(oob_air) do
		for squadN, squad in pairs(squads) do
			squad.client = nil
		end
	end
end
