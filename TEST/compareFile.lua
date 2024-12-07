
-- print("Current working directory:", lfs.currentdir())
print("Current working directory:", os.getenv("PWD") or io.popen("cd"):read('*l'))

dofile("UTIL_Functions.lua")

-- Liste des clés à ignorer
local ignoredKeys = {
    briefing_name = true,
    hCruiseREF = true,
    DCE_payloadtName = true,
    psi = true,
    dead_last = true,
    TotFlightTime = true,
    TotFlightDist = true,
    DCE_targetName = true,
    dead = true,
    CheckDay = true,

    Radio = true,
    x = true,
    y = true,
    heading = true,
    parking = true,
    parking_id = true,
    spedd = true,
    alt = true,
    ETA = true,
    start_time = true,

}

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
    if depth > 3 then return "{...}" end -- Limite d'affichage pour éviter les structures trop profondes

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
                table.insert(differences, {type = "removed", path = currentPath, value = v1})
            elseif type(v1) ~= type(v2) then
                table.insert(differences, {type = "changed", path = currentPath, oldValue = v1, newValue = v2})
            elseif type(v1) == "table" then
                local subDiff = compareTables(v1, v2, currentPath)
                for _, diff in ipairs(subDiff) do
                    table.insert(differences, diff)
                end
            elseif v1 ~= v2 then
                table.insert(differences, {type = "changed", path = currentPath, oldValue = v1, newValue = v2})
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
                table.insert(differences, {type = "added", path = currentPath, value = v2})
            end
        end
    end

    return differences
end

-- Fonction pour afficher les différences
local function printDifferences(differences)
    for _, diff in ipairs(differences) do
        if diff.type == "removed" then
            print("Supprimé: " .. diff.path .. " = " .. tostring(type(diff.value) == "table" and tableToString(diff.value) or diff.value))
        elseif diff.type == "added" then
            print("Ajouté: " .. diff.path .. " = " .. tostring(type(diff.value) == "table" and tableToString(diff.value) or diff.value))
        elseif diff.type == "changed" then
            print("Modifié: " .. diff.path ..
                " (ancien: " .. tostring(type(diff.oldValue) == "table" and tableToString(diff.oldValue) or diff.oldValue) ..
                ", nouveau: " .. tostring(type(diff.newValue) == "table" and tableToString(diff.newValue) or diff.newValue) .. ")")
        end
    end
end

-- Exemple d'utilisation
local function main()
    local file1 = "missionA" -- Chemin vers le premier fichier Lua
    local file2 = "missionB" -- Chemin vers le deuxième fichier Lua

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