
-- print("Current working directory:", lfs.currentdir())
print("Current working directory:", os.getenv("PWD") or io.popen("cd"):read('*l'))

dofile("UTIL_Functions.lua")

--["type"] = 0, dans zone
			-- [39] = 
			-- {
			-- 	["radius"] = 4.8768,
			-- 	["zoneId"] = 555,
			-- 	["color"] = 
			-- 	{
			-- 		[1] = 0,
			-- 		[2] = 0,
			-- 		[3] = 1,
			-- 		[4] = 0.14901960784314,
			-- 	},
			-- 	["properties"] = 
			-- 	{
			-- 	},
			-- 	["hidden"] = true,
			-- 	["y"] = 418329.40457264,
			-- 	["x"] = 148302.72691429,
			-- 	["name"] = "Recon Hanoi",
			-- 	["type"] = 0,
			-- 	["heading"] = 0,
			-- },
			-- [40] = 
			-- {
			-- 	["y"] = 429445.11392031,
			-- 	["x"] = -20537.361711746,
			-- 	["zoneId"] = 1,
			-- 	["color"] = 
			-- 	{
			-- 		[1] = 1,
			-- 		[2] = 1,
			-- 		[3] = 1,
			-- 		[4] = 0.15,
			-- 	},
			-- 	["name"] = "SceneryDestroyZone1",
			-- 	["hidden"] = true,
			-- 	["radius"] = 60,
			-- },

-- Paramètre configurable pour la profondeur d'enregistrement des tables
-- Défini le nombre de niveaux de profondeur à enregistrer (n-2, n-3, etc.)
local MAX_DEPTH = 3  -- Modifier cette valeur pour changer la profondeur (2 pour n-2, 3 pour n-3, etc.)

-- Liste des clés à ignorer
local ignoredKeys = {
    -- briefing_name = true,
    -- hCruiseREF = true,
    -- DCE_payloadtName = true,
    dead_last = true,
    -- TotFlightTime = true,
    -- TotFlightDist = true,
    -- DCE_targetName = true,
    -- dead = true,
    -- CheckDay = true,
    -- etaSpawn = true,
    -- baseStartup = true,
    -- debug = true,

    psi = true,
    Radio = true,
    x = true,
    y = true,
    heading = true,
    parking = true,
    parking_id = true,
    speed = true,
    alt = true,
    ETA = true,
    start_time = true,



    triggers = true,
    trigrules = true,
    trig = true,
    category = true,
    failures = true,

    -- taskSelected = true,
    name = true,

}

-- Fonction pour convertir une table en chaîne formatée multi-lignes
local function tableToStringFormatted(tbl, depth, indent)
    depth = depth or 1
    indent = indent or ""
    if depth > MAX_DEPTH then return "{...}" end

    if type(tbl) ~= "table" then
        return tostring(tbl)
    end

    local nextIndent = indent .. "\t"
    local result = "{\n"
    for k, v in pairs(tbl) do
        local keyStr = tostring(k)
        local valueStr
        if type(v) == "table" then
            valueStr = tableToStringFormatted(v, depth + 1, nextIndent)
        else
            valueStr = tostring(v)
        end
        result = result .. nextIndent .. "[\"" .. keyStr .. "\"] = " .. valueStr .. ",\n"
    end
    result = result .. indent .. "}"
    return result
end

-- Fonction pour charger un fichier Lua sous forme de table
local function loadLuaFile(filename)
    dofile(filename) -- Exécute le fichier Lua
    return mission -- Retourne la table mission
end

-- Fonction pour vérifier si une clé doit être ignorée
local function shouldIgnoreKey(key)
    return ignoredKeys[key] or false
end

-- Fonction pour convertir une table en chaîne lisible
local function tableToString(tbl, depth)
    depth = depth or 1
    if depth > MAX_DEPTH then return "{...}" end -- Limite d'affichage pour éviter les structures trop profondes

    -- Si ce n'est pas une table, retourner la représentation en chaîne directement
    if type(tbl) ~= "table" then
        return tostring(tbl)
    end

    local result = "{ "
    for k, v in pairs(tbl) do
        local keyStr = tostring(k)
        local valueStr
        if type(v) == "table" then
            valueStr = tableToString(v, depth + 1)
        else
            valueStr = tostring(v)
        end
        result = result .. keyStr .. " = " .. valueStr .. ", "
    end
    return result .. "}"
end

-- Fonction pour comparer deux tables récursivement
local function compareTables(t1, t2, path)
    local path = path or ""
    local differences = {}

    -- Vérifier les clés dans t1 (éléments manquants dans t2 ou différents)
    for k, v1 in pairs(t1) do
        if shouldIgnoreKey(k) then
            -- Ignorer cette clé
        else
            local v2 = t2[k]
            local currentPath = path .. "/" .. tostring(k)

            if v2 == nil then
                table.insert(differences, {type = "removed", path = currentPath, value = v1, key = k})
            elseif type(v1) ~= type(v2) then
                table.insert(differences, { type = "changed", path = currentPath, oldValue = v1, newValue = v2, key = k })
            elseif type(v1) == "table" then
                local subDiff = compareTables(v1, v2, currentPath)
                for _, diff in ipairs(subDiff) do
                    table.insert(differences, diff)
                end
            elseif v1 ~= v2 then
                table.insert(differences, { type = "changed", path = currentPath, oldValue = v1, newValue = v2, key = k })
            end
        end
    end

    -- Vérifier les clés dans t2 (éléments ajoutés par rapport à t1)
    for k, v2 in pairs(t2) do
        if shouldIgnoreKey(k) then
            -- Ignorer cette clé
        else
            if t1[k] == nil then
                local currentPath = path .. "/" .. tostring(k)
                table.insert(differences, { type = "added", path = currentPath, value = v2, key = k })
            end
        end
    end

    return differences
end

-- Fonction pour afficher les différences
local function printDifferences(differences)
    local logFile = io.open("differences.txt", "w")
    if not logFile then
        print("Erreur : impossible de créer le fichier differences.txt")
        return
    end
    
    logFile:write("return {\n")
    for _, diff in ipairs(differences) do
        logFile:write("    {\n")
        logFile:write("        type = \"" .. diff.type .. "\",\n")
        logFile:write("        path = \"" .. diff.path .. "\",\n")
        logFile:write("        key = \"" .. tostring(diff.key) .. "\",\n")
        
        if diff.type == "changed" then
            logFile:write("        oldValue = " .. tableToStringFormatted(diff.oldValue) .. ",\n")
            logFile:write("        newValue = " .. tableToStringFormatted(diff.newValue) .. ",\n")
        elseif diff.type == "removed" then
            logFile:write("        value = " .. tableToStringFormatted(diff.value) .. ",\n")
        elseif diff.type == "added" then
            logFile:write("        value = " .. tableToStringFormatted(diff.value) .. ",\n")
        end
        
        logFile:write("    },\n")
    end
    logFile:write("}\n")
    logFile:close()
    
    -- Statistiques et résumé
    local stats = { added = 0, removed = 0, changed = 0 }
    for _, diff in ipairs(differences) do
        stats[diff.type] = (stats[diff.type] or 0) + 1
    end
    
    print("\n=== RÉSUMÉ ===")
    print(string.format("Ajoutés: %d, Supprimés: %d, Modifiés: %d", stats.added, stats.removed, stats.changed))
    print("\n=== DÉTAILS ===")
    for _, diff in ipairs(differences) do
        print(string.format("\n[%s] %s", diff.type:upper(), diff.path))
        if diff.type == "changed" then
            print("  Avant: " .. tableToStringFormatted(diff.oldValue))
            print("  Après: " .. tableToStringFormatted(diff.newValue))
        else
            print("  Valeur: " .. tableToStringFormatted(diff.value))
        end
    end
end



-- Exemple d'utilisation
local function main()
    local file1 = "mission_A" -- Chemin vers le premier fichier Lua
    local file2 = "mission_B" -- Chemin vers le deuxième fichier Lua

    local table1 = loadLuaFile(file1)
    local table2 = loadLuaFile(file2)

    local differences = compareTables(table1, table2)
    printDifferences(differences)
end

main()




    


    -- local logStr = "mission = " .. TableSerialization(mission, 0)
    -- local logFile = io.open("RES\\mission.lua", "w") or error("Failed to open debug file")
    -- logFile:write(logStr)
    -- logFile:close()	