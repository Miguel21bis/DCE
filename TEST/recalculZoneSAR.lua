
dofile("UTIL_Functions.lua")

local function computeZone(grid)
    local E       = tonumber(string.sub(grid.Easting, 1, 1))
    local N       = tonumber(string.sub(grid.Northing, 1, 1))

    local isEast  = (E >= 5)
    local isNorth = (N >= 5)

    local zone

    if not isEast and not isNorth then
        zone = 1 -- Sud-Ouest
    elseif isEast and not isNorth then
        zone = 2 -- Sud-Est
    elseif not isEast and isNorth then
        zone = 3 -- Nord-Ouest
    else
        zone = 4 -- Nord-Est
    end

    return zone, E, N
end


function Rebuild_zoneSAR(oldTable)
    local newTable = {}

    for oldKey, pilotList in pairs(oldTable) do
        for idx, pilot in pairs(pilotList) do
            local grid = pilot.grid

            if grid then
                -- Calcule zone + sub-chiffres
                local zoneNumber, E, N = computeZone(grid)

                -- Nouvelle clé
                local newKey = grid.UTMZone .. "_" ..
                    grid.MGRSDigraph .. "_Zone_" .. zoneNumber

                -- Met à jour les champs internes
                pilot.MGRS_Chute = newKey
                pilot.MGRS_Chute_10KM = grid.UTMZone .. "_" ..
                    grid.MGRSDigraph .. "_" .. E .. "_" .. N

                -- Insert dans la nouvelle table au bon endroit
                if not newTable[newKey] then
                    newTable[newKey] = {}
                end

                table.insert(newTable[newKey], pilot)
            end
        end
    end

    return newTable
end


dofile("RES\\zoneSAR.lua")

local newZoneSAR = Rebuild_zoneSAR(zoneSAR)

local logStr = "zoneSAR = " .. TableSerialization(newZoneSAR, 0)
local logFile = io.open("RES\\new_zoneSAR.lua", "w") or error("Failed to open debug file")
logFile:write(logStr)
logFile:close()	
