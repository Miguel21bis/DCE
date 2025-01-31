------------------------------------------------------------------------------------------------------- 
-- last modification  
if not versionDCE then versionDCE = {} end
versionDCE["Mission Scripts/collectFuelData.lua"] = "1.1.2"
------------------------------------------------------------------------------------------------------- 
---

trigger.action.outText("DCE_collectFuelData :Start script.", 30)

-- Variables globales
local fuelData = {} -- Table pour stocker les données
local logInterval = 30 -- Intervalle en secondes pour l'enregistrement des données
local lastFuelLevels = {} -- Stocke les niveaux de carburant précédents des unités

-- Fonction pour récupérer toutes les unités valides (avions et hélicoptères)
local function getAllAircrafts()
    local units = {}
    for coalitionId = 1, 2 do -- 1 = Blue, 2 = Red
        local coalition = coalition.getGroups(coalitionId, Group.Category.AIRPLANE)
        if coalition then
            for _, group in pairs(coalition) do
                for _, unit in pairs(group:getUnits()) do
                    if unit and unit:isExist() then
                        table.insert(units, unit)
                    end
                end
            end
        end

        -- Récupération des hélicoptères
        -- coalition = coalition.getGroups(coalitionId, Group.Category.HELICOPTER)
        -- if coalition then
            -- for _, group in pairs(coalition) do
                -- for _, unit in pairs(group:getUnits()) do
                    -- if unit and unit:isExist() then
                        -- table.insert(units, unit)
                    -- end
                -- end
            -- end
        -- end
    end
    return units
end

-- Fonction pour collecter les données de carburant
local function collectFuelData()
    local currentTime = timer.getTime() -- Temps actuel de la mission
    local units = getAllAircrafts()

    for _, unit in ipairs(units) do
        local unitName = unit:getName()
        local fuelLevel = unit:getFuel() -- Carburant restant (0-1)
        local position = unit:getPosition()
        local altitude = position.p.y -- Altitude en mètres
        local velocity = unit:getVelocity() -- Vecteur vitesse
        local speedMps = math.sqrt(velocity.x^2 + velocity.y^2 + velocity.z^2) -- Vitesse en m/s

        local descr = unit:getDesc()
        fuelLevel = fuelLevel * descr.fuelMassMax

        env.info("typeName: "..tostring(descr.typeName).." fuelMassMax: "..tostring(descr.fuelMassMax))

        -- Calcul de la consommation
        local consumptionRate = nil
        if lastFuelLevels[unitName] then
            local deltaFuel = lastFuelLevels[unitName].fuel - fuelLevel
            local deltaTime = currentTime - lastFuelLevels[unitName].time

            if deltaTime > 0 and deltaFuel > 0 then
                consumptionRate = deltaFuel / deltaTime * 3600 -- kg/h (approximatif)
            end
        end

        -- Stocker la mesure actuelle
        lastFuelLevels[unitName] = { fuel = fuelLevel, time = currentTime }

        -- Ajouter les données dans la table
        table.insert(fuelData, {
            time = currentTime,
            unitName = unitName,
            fuelLevel = fuelLevel,
            altitude = altitude,
            speed = speedMps,
            consumption = consumptionRate
        })

        -- Débogage : Afficher la consommation estimée
        if consumptionRate then
            -- trigger.action.outText(string.format(
                -- "Unité: %s | Conso: %.2f kg/h | Fuel restant: %.2f | Altitude: %.1f | Vitesse: %.1f",
                -- unitName, consumptionRate, fuelLevel, altitude, speedMps
            -- ), 10)
			env.info(string.format(
                "Unité: %s | Conso: %.2f kg/h | Fuel restant: %.2f | Altitude: %.1f | Vitesse: %.1f",
                unitName, consumptionRate, fuelLevel, altitude, speedMps
            ))
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
            file:write(string.format("    {time = %.1f, unitName = '%s', fuelLevel = %.3f, altitude = %.1f, speed = %.1f, consumption = %.2f},\n",
                entry.time, entry.unitName, entry.fuelLevel, entry.altitude, entry.speed, entry.consumption or 0))
        end
        file:write("}\n")
        file:close()
        trigger.action.outText("Données exportées dans " .. fileName, 1000)
    else
        trigger.action.outText("Erreur : Impossible d'exporter les données.", 1000)
    end
end

-- Planifier la collecte des données et l'exportation
timer.scheduleFunction(collectFuelData, nil, timer.getTime() + logInterval)
timer.scheduleFunction(exportFuelData, nil, timer.getTime() + 300) -- Export après 10 minutes



trigger.action.outText("DCE_collectFuelData :Load script OK.", 30)
