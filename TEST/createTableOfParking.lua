
-- print("Current working directory:", lfs.currentdir())
print("Current working directory:", os.getenv("PWD") or io.popen("cd"):read('*l'))

dofile("UTIL_Functions.lua")


-- Fonction pour parcourir récursivement la table et extraire les données nécessaires
local function extractParkingPositions(mission)
    local parkListPosition = {}

    -- Obtenir le nom de la map
    local theatreName = mission["theatre"] or "UnknownMap"
    parkListPosition[theatreName] = {}

    -- Fonction interne pour parcourir les tables
    local function parseTable(tbl, path)
        if type(tbl) ~= "table" then return end

        -- Vérifie si la table contient une clé "parking_id" et "parking"
        if tbl["parking_id"] and tbl["parking"] then
            local currentAirdromeId = path.airdromeId

            -- Enregistre uniquement si airdromeId est défini
            if currentAirdromeId then
                local parkingEntry = {
                    ["parking_id"] = tbl["parking_id"],
                    ["parking"] = tbl["parking"],
                    ["x"] = tbl["x"],
                    ["y"] = tbl["y"],
                    ["heading"] = tbl["heading"]
                }

                -- Initialisation si nécessaire
                parkListPosition[theatreName][currentAirdromeId] = parkListPosition[theatreName][currentAirdromeId] or {}
                table.insert(parkListPosition[theatreName][currentAirdromeId], parkingEntry)
            end
        end

        -- Vérifie si la table contient une clé "airdromeId" dans les points de route
        if tbl["airdromeId"] then
            path.airdromeId = tbl["airdromeId"]
        end

        -- Parcourt récursivement les sous-tables
        for k, v in pairs(tbl) do
            if type(v) == "table" then
                parseTable(v, path)
            end
        end
    end

    -- Parcourt toutes les coalitions (red, blue, etc.)
    if mission["coalition"] then
        for _, coalitionData in pairs(mission["coalition"]) do
            parseTable(coalitionData, {airdromeId = nil})
        end
    end

    return parkListPosition
end

-- Fonction principale pour charger la mission et extraire les positions
local function main()
    local missionFile = "missionPark" -- Remplacez par le fichier de mission approprié
    dofile(missionFile) -- Charge le fichier Lua
    parkListPosition = extractParkingPositions(mission)

    -- Afficher les résultats
    for mapName, airdromeData in pairs(parkListPosition) do
        print("Map: " .. mapName)
        for airdromeId, parkingList in pairs(airdromeData) do
            print("  Airdrome ID: " .. tostring(airdromeId))
            for i, parking in ipairs(parkingList) do
                print("    Parking " .. i .. ":")
                for key, value in pairs(parking) do
                    print("      " .. key .. " = " .. tostring(value))
                end
            end
        end
    end
end

main()



    


    local logStr = "parkListPosition = " .. TableSerialization(parkListPosition, 0)
    local logFile = io.open("RES\\parkListPosition.lua", "w") or error("Failed to open debug file")
    logFile:write(logStr)
    logFile:close()	