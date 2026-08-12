

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
function IsSequentialTable(t)
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

-- 

