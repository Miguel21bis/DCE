-- Charger les données FuelData comme module
require("FuelData")

-- Paramètres
local rangeStep = 100 -- Tranches d'altitude (en mètres)

-- Fonction pour analyser les données et calculer les ratios
local function analyzeFuelData(data)
    local consumptionData = {}
    local avgConsumptionData = {}

    -- Grouper par unité
    local units = {}
    for _, entry in ipairs(data) do
        if not units[entry.unitName] then
            units[entry.unitName] = {
                fuelStart = entry.fuelLevel, -- Premier niveau de carburant
                totalTime = 0,
                totalDistance = 0,
                totalConsumption = 0,
                totalSpeed = 0,
                totalEfficiency = 0, -- Pour le ratio kg/m
                entries = {}
            }
        end
        table.insert(units[entry.unitName].entries, entry)
    end

    -- Calcul des consommations, distances et ratios
    for unitName, unitData in pairs(units) do
        local entries = unitData.entries
        table.sort(entries, function(a, b) return a.time < b.time end)

        for i = 1, #entries do
            local current = entries[i]

            -- Consommation horaire et ratio d'efficacité
            local consumptionRate = current.consumption -- Déjà en kg/h
            local efficiencyRatio = consumptionRate / current.speed -- kg/m (carburant par mètre parcouru)

            -- Mise à jour des données cumulées
            unitData.totalConsumption = unitData.totalConsumption + (consumptionRate / 3600) * 120 -- kg consommés sur l'intervalle
            unitData.totalTime = unitData.totalTime + 120 -- Ajouter l'intervalle de temps (120 s)
            unitData.totalDistance = unitData.totalDistance + current.speed * 120 -- Distance parcourue
            unitData.totalSpeed = unitData.totalSpeed + current.speed
            unitData.totalEfficiency = unitData.totalEfficiency + efficiencyRatio

            if efficiencyRatio > 0 then
                -- Ajouter à la liste des consommations par tranche d'altitude
                table.insert(consumptionData, {
                    unitName = current.unitName,
                    altitude = current.altitude,
                    speed = current.speed,
                    fuelConsumption = consumptionRate,
                    efficiencyRatio = efficiencyRatio
                })
            end
        end

        -- Calcul des moyennes et autres statistiques
        if unitData.totalTime > 0 then
            local avgConsumption = (unitData.totalConsumption / unitData.totalTime) * 3600 -- Moyenne en kg/h
            local avgSpeed = unitData.totalSpeed / #entries -- Vitesse moyenne
            local avgEfficiency = unitData.totalEfficiency / #entries -- Ratio moyen
            local endurance = unitData.fuelStart / (avgConsumption / 3600) -- Endurance totale (s)
            local maxDistance = avgSpeed * endurance -- Distance maximale (m)

            avgConsumptionData[unitName] = {
                avgConsumption = avgConsumption,
                endurance = endurance, -- En secondes
                maxDistance = maxDistance, -- En mètres
                avgEfficiency = avgEfficiency -- Ratio moyen (kg/m)
            }
        end
    end

    return consumptionData, avgConsumptionData
end

-- Fonction pour trouver la meilleure consommation par tranche d'altitude
local function getBestConsumptionByAltitudeRange(data, rangeStep)
    local ranges = {}

    for _, entry in ipairs(data) do
        local rangeStart = math.floor(entry.altitude / rangeStep) * rangeStep

        if not ranges[rangeStart] then
            ranges[rangeStart] = entry
        else
            if entry.efficiencyRatio > 0 and entry.efficiencyRatio < ranges[rangeStart].efficiencyRatio then
                ranges[rangeStart] = entry
            end
        end
    end

    -- Trier les plages d'altitude
    local sortedRanges = {}
    for rangeStart, entry in pairs(ranges) do
        table.insert(sortedRanges, { rangeStart = rangeStart, entry = entry })
    end
    table.sort(sortedRanges, function(a, b) return a.rangeStart < b.rangeStart end)

    return sortedRanges
end

-- Fonction pour trier par nom d'avion
local function sortByUnitName(data)
    local sorted = {}
    for unitName, stats in pairs(data) do
        table.insert(sorted, { unitName = unitName, stats = stats })
    end
    table.sort(sorted, function(a, b) return a.unitName < b.unitName end)
    return sorted
end

-- Étape 1 : Calculer la consommation horaire et les ratios d'efficacité
local consumptionData, avgConsumptionData = analyzeFuelData(fuelData)

-- Étape 2 : Trouver la meilleure consommation par tranche d'altitude
local bestByRange = getBestConsumptionByAltitudeRange(consumptionData, rangeStep)

-- Étape 3 : Trier la consommation moyenne par nom d'avion
local sortedAvgConsumption = sortByUnitName(avgConsumptionData)

-- Afficher les résultats
print("Meilleures consommations par plage d'altitude :")
for _, range in ipairs(bestByRange) do
    local rangeStart = range.rangeStart
    local rangeEnd = rangeStart + rangeStep
    local entry = range.entry
    print(string.format(
        "Altitude %d-%d m : Conso %.1f kg/h, Vitesse %.1f m/s, Altitude précise %.1f m, Unité %s, Ratio %.5f kg/m",
        rangeStart, rangeEnd, entry.fuelConsumption, entry.speed, entry.altitude, entry.unitName, entry.efficiencyRatio
    ))
end

print("\nConsommation moyenne, distance franchissable, endurance et ratio :")
for _, item in ipairs(sortedAvgConsumption) do
    local unitName = item.unitName
    local stats = item.stats
    print(string.format(
        "Unité %s : Conso Moy %.1f kg/h, Endurance %.1f h, Distance Max %.1f km, Ratio Moy %.5f kg/m",
        unitName,
        stats.avgConsumption,
        stats.endurance / 3600, -- Convertir endurance en heures
        stats.maxDistance / 1000, -- Convertir distance maximale en kilomètres
        stats.avgEfficiency
    ))
end
