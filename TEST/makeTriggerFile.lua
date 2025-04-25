
-- print("Current working directory:", lfs.currentdir())
print("Current working directory:", os.getenv("PWD") or io.popen("cd"):read('*l'))

dofile("UTIL_Functions.lua")

local inputFilename = "camp_triggers_init.lua" -- Nom du fichier Lua à charger
local outputFilename = "newTriggersFile.lua"  -- Nom du fichier de sortie

-- Fonction pour lire et parser le fichier ligne par ligne
local function parseTriggersFromFile(filename)
    local triggers = {}
    local currentTrigger = nil
    local currentKey = nil

    for line in io.lines(filename) do
        print()
        print("line ", tostring(line))
        -- Supprime les espaces en début/fin de ligne
        line = line:match("^%s*(.-)%s*$")

        -- Ignore les lignes commentées ou vides
        if line:sub(1, 2) ~= "--" and line ~= "" then
            -- Détecte le début d'un nouveau déclencheur
            local triggerName = line:match('%["(.-)"%] = {')
            print("02 triggerName ", tostring(triggerName))
            print("03 currentTrigger ", tostring(currentTrigger))
            
            if triggerName then
                print("A triggerName ", tostring(triggerName))
                if currentTrigger then
                    table.insert(triggers, currentTrigger) -- Ajoute le déclencheur précédent
                end
                currentTrigger = { name = triggerName } -- Crée un nouveau déclencheur
                currentKey = nil -- Réinitialise la clé courante
            elseif currentTrigger then
                -- Détecte les clés et leurs valeurs
                print("B_1 currentTrigger ", tostring(currentTrigger))

                local key, value = line:match('(%w+)%s*=%s*(.+),')
                print("B_2 key ", tostring(key))
                if key and value then
                    if key == "action" then
                        print("-->Ba key (action détectée sur une seule ligne) ", tostring(key))
                        -- Vérifie si l'action est sur une seule ligne
                        local singleAction = value:match("^'(.*)'$")
                        if singleAction then
                            currentTrigger[key] = { singleAction } -- Ajoute l'action comme une table avec un seul élément
                        else
                            currentTrigger[key] = {} -- Initialise la table d'actions
                            currentKey = key
                        end
                    else
                        -- Convertit les valeurs booléennes et garde les chaînes intactes
                        print("-->Bb key ", tostring(key))
                        if value == "true" or value == "false" then
                            currentTrigger[key] = value == "true"
                        else
                            currentTrigger[key] = value:match("^'(.*)'$") or value
                        end
                    end
                elseif line:match('(%w+)%s*=%s*{') then
                    -- Détecte les lignes de type `action = {`
                    key = line:match('(%w+)%s*=%s*{')
                    print("-->Bc key (début de table) ", tostring(key))
                    if key == "action" then
                        currentTrigger[key] = {} -- Initialise la table d'actions
                        currentKey = key
                    end
                elseif currentKey == "action" then
                    -- Vérifie si la ligne contient une action ou la fin de la table d'actions
                    if line == "}," then
                        print("Fin de la table d'actions détectée.")
                        currentKey = nil -- Réinitialise la clé courante
                    else
                        -- Ajoute les actions dans la table d'actions
                        local action = line:match("'(.-)'")
                        print("C1 currentKey == action ", tostring(action))
                        print("C2 currentKey == action line ", tostring(line))
                        if action then
                            table.insert(currentTrigger[currentKey], action)
                        end
                    end
                end
            end
        end
    end

    -- Ajoute le dernier déclencheur
    if currentTrigger then
        table.insert(triggers, currentTrigger)
    end

    return triggers
end
-- Fonction pour lire et parser le fichier ligne par ligne


-- Fonction pour écrire les déclencheurs dans le fichier de sortie
local function writeTriggersToFile(filename, triggers)
    local file = io.open(filename, "w") -- Ouvre le fichier en mode écriture
    file:write("camp_triggers = {\n\n") -- Début de la table

    for _, trigger in ipairs(triggers) do
        file:write("    {\n") -- Supprime l'index numérique
        file:write(string.format("        name = \"%s\",\n", trigger.name))
        file:write(string.format("        active = %s,\n", tostring(trigger.active)))
        file:write(string.format("        once = %s,\n", tostring(trigger.once)))
        file:write(string.format("        condition = '%s',\n", trigger.condition))
        file:write("        action = {\n")
        for _, action in ipairs(trigger.action or {}) do
            file:write(string.format("            '%s',\n", action))
        end
        file:write("        },\n")
        file:write("    },\n\n")
    end

    file:write("}\n") -- Fin de la table
    file:close() -- Ferme le fichier
end

-- Parse le fichier source pour obtenir les déclencheurs
local camp_triggers = parseTriggersFromFile(inputFilename)

-- Vérifie si des déclencheurs ont été trouvés
if #camp_triggers == 0 then
    error("Aucun déclencheur trouvé dans le fichier '" .. inputFilename .. "'.")
else
    print("Déclencheurs chargés avec succès.")
end

-- Écrit les déclencheurs dans le fichier de sortie
writeTriggersToFile(outputFilename, camp_triggers)

print("Fichier '" .. outputFilename .. "' généré avec succès.")


local logStr = "camp_triggers = " .. TableSerialization(camp_triggers, 0)
local logFile = io.open("RES\\newTriggersFile.lua", "w") or error("Failed to open debug file")
logFile:write(logStr)
logFile:close()	