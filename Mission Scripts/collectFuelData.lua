------------------------------------------------------------------------------------------------------- 
-- last modification  
if not versionDCE then versionDCE = {} end
versionDCE["Mission Scripts/collectFuelFata.lua"] = "1.1.1"
------------------------------------------------------------------------------------------------------- 
---
-- Variables globales
local fuelData = {} -- Table pour stocker les données
local logInterval = 10 -- Intervalle en secondes pour l'enregistrement des données

-- Fonction pour collecter les données de carburant
local function collectFuelData()
    local currentTime = timer.getTime() -- Temps actuel de la mission
    for _, unitName in pairs(mist.DBs.humansByName) do
        local unit = Unit.getByName(unitName)
        if unit and unit:isActive() then
            local fuelLevel = unit:getFuel()
            local alt = unit:getPosition().p.y -- Altitude (en mètres)
            local speed = unit:getVelocity() -- Vecteur de vitesse
            local speedMps = math.sqrt(speed.x^2 + speed.y^2 + speed.z^2) -- Norme de la vitesse

            -- Ajout des données à la table
            table.insert(fuelData, {
                time = currentTime,
                unitName = unitName,
                fuelLevel = fuelLevel,
                altitude = alt,
                speed = speedMps
            })
        end
    end

    -- Reprogrammer le timer pour la prochaine collecte
    timer.scheduleFunction(collectFuelData, nil, timer.getTime() + logInterval)
end

-- Fonction pour exporter les données dans un fichier Lua
local function exportFuelData()
    local fileName = lfs.writedir() .. "Scripts/FuelData.lua"
    local file = io.open(fileName, "w")

    if file then
        file:write("fuelData = {\n")
        for _, entry in ipairs(fuelData) do
            file:write(string.format("    {time = %.1f, unitName = '%s', fuelLevel = %.3f, altitude = %.1f, speed = %.1f},\n",
                entry.time, entry.unitName, entry.fuelLevel, entry.altitude, entry.speed))
        end
        file:write("}\n")
        file:close()
        trigger.action.outText("Données exportées dans " .. fileName, 10)
    else
        trigger.action.outText("Erreur : Impossible d'exporter les données.", 10)
    end
end

-- Planifier la collecte des données et l'exportation
timer.scheduleFunction(collectFuelData, nil, timer.getTime() + logInterval)
-- timer.scheduleFunction(exportFuelData, nil, timer.getTime() + 600) -- Export après 10 minutes
timer.scheduleFunction(exportFuelData, nil, timer.getTime() + 100) -- Export après 10 minutes
