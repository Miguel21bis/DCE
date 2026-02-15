-- adds the latest and various elements, postFlightPlan

-------------------------------------------------------------------------------------------------------
-- Last Modification M38_n
if not versionDCE then versionDCE = {} end
versionDCE["DC_Final_steps.lua"] = "1.1.1"
-------------------------------------------------------------------------------------------------------
--
-- modification M90_a		missionWithIcone
-------------------------------------------------------------------------------------------------------
---
---["type"] = "KS-19",
---["type"] = "S-60_Type59_Artillery",
---["skill"] = "High",Average
---
------
if Debug.debug then
	print("START DC_Final_steps.lua "..versionDCE["DC_Final_steps.lua"].." =-=-=-=-=-=-=-=-=-=-=-=-=-=-=")
end

-- local checkPoint = {
--     ["y"] = 427946.75056108,
--     ["x"] = -59046.908118635,
--     }
-- local unitsIdToRemove = {}
-- local flagUnitToRemove = false
-- --set quelques unitées AAA en moyen
-- for _, side in pairs(mission.coalition) do
-- 	for _, country in pairs(side.country) do
-- 		for _, groups in pairs(country) do
-- 			if type(groups) == "table" and groups["group"]  then
-- 				for _, group in pairs(groups["group"]) do
--                     flagUnitToRemove = false
-- 					for _, unit in pairs(group.units) do
-- 						if unit.type and (unit.type ==  "KS-19" or unit.type ==  "S-60_Type59_Artillery" ) then
-- 							unit.skill = "Average"
--                             --si la distance entre ces éléments et checkPoint est inferieur à 15km, on l'enregistre pour le supprimer juste apres
--                             local distance = math.sqrt(math.pow(unit.x - checkPoint.x, 2) + math.pow(unit.y - checkPoint.y, 2))
--                             if distance < 15000 then
--                                 unitsIdToRemove = unitsIdToRemove or {}
--                                 table.insert(unitsIdToRemove, unit.id)
--                                 flagUnitToRemove = true
--                             end

-- 						end
-- 					end
--                     if flagUnitToRemove then
--                         -- print("group "..tostring(group.name).." has a unit to remove")
--                         for n=1, #group.units do
--                             if group.units[n].id == unitsIdToRemove[#unitsIdToRemove] then
--                                 table.remove(group.units, n)
--                                 -- print("unit with id "..tostring(unitsIdToRemove[#unitsIdToRemove]).." removed")
--                                 table.remove(unitsIdToRemove, #unitsIdToRemove)

--                             end
                            
--                         end
--                     end
-- 				end
-- 			end
-- 		end
-- 	end
-- end

-- Point de référence
local checkPoint = {
    x = -59046.908118635,
    y = 427946.75056108,
}

-- Distance max (15 km)
local maxDistance = 15000


--[[ --particularité NAM
-- Parcours des coalitions
for _, side in pairs(mission.coalition) do
    for _, country in pairs(side.country) do
        for _, groups in pairs(country) do

            if type(groups) == "table" and groups.group then

                for _, group in pairs(groups.group) do

                    -- Parcours A L'ENVERS pour suppression propre
                    for i = #group.units, 1, -1 do

                        local unit = group.units[i]

                        if unit.type and
                           (unit.type == "KS-19" or unit.type == "S-60_Type59_Artillery") then

                            -- Mise en skill moyen
                            unit.skill = "Average"

                            -- Calcul distance
                            local dx = unit.x - checkPoint.x
                            local dy = unit.y - checkPoint.y

                            local distance = math.sqrt(dx * dx + dy * dy)

                            -- Suppression si trop proche
                            if distance < maxDistance then

                                -- Debug optionnel
                                print("Suppression unité : "..tostring(unit.name).." "..unit.type)

                                table.remove(group.units, i)

                            end
                        end
                    end
                end
            end
        end
    end
end ]]



-- supprime les task EWR orphelines (sans unité EWR)
for _, side in pairs(mission.coalition) do
    for _, country in pairs(side.country) do
        for _, groups in pairs(country) do
            if type(groups) == "table" and groups["group"] then
                for _, group in pairs(groups["group"]) do

                    local found_EWR_task = false
                    local found_EWR_unit = false

                    -- 1) Chercher la présence d'une task EWR
                    if group.route and group.route.points then
                        for _, point in pairs(group.route.points) do
                            if point.task and point.task.params and point.task.params.tasks then
                                for _, task in pairs(point.task.params.tasks) do
                                    if task.id == "EWR" then
                                        found_EWR_task = true
                                        break
                                    end
                                end
                            end
                        end
                    end

                    -- 2) Chercher une unité EWR dans le groupe
                    if found_EWR_task then
                        for _, unit in pairs(group.units) do
                            if IsEWR[unit.type] then
                                found_EWR_unit = true
                                break
                            end
                        end
                    end

                    -- 3) Supprimer les tasks EWR si aucune unité EWR, puis renuméroter
                    if found_EWR_task and not found_EWR_unit then
                        for _, point in pairs(group.route.points) do
                            if point.task and point.task.params and point.task.params.tasks then

                                local tasks = point.task.params.tasks

                                ----------------------------------------------------------------------
                                -- A) Suppression des tasks EWR (robuste)
                                ----------------------------------------------------------------------
                                for i = #tasks, 1, -1 do
                                    if tasks[i].id == "EWR" then
                                        table.remove(tasks, i)
                                    end
                                end

                                ----------------------------------------------------------------------
                                -- B) RENUMÉROTATION OBLIGATOIRE : tasks[n].number = n
                                ----------------------------------------------------------------------
                                for newIndex = 1, #tasks do
                                    local t = tasks[newIndex]
                                    if t.number ~= newIndex then
                                        t.number = newIndex
                                    end
                                end

                            end
                        end
                    end

                end
            end
        end
    end
end



for _, side in pairs(mission.coalition) do
    for _, country in pairs(side.country) do
        for category, groups in pairs(country) do
            -- Vérifier si la catégorie est "static" (string)
            if type(groups) == "table" and groups["group"] then

                for groupNb, group in pairs(groups["group"]) do

                    if group.DCE_targetName then
                        group.DCE_targetName = nil
                    end
                    if group.debug then
                        group.debug = nil
                    end
                    --supprime la variable briefing_name de la table route\points[n].briefing_name
                    for _, point in pairs(group.route.points) do
                        -- if point.briefing_name then
                        --     point.briefing_name = nil
                        -- end
                        if point.hCruiseREF then
                            point.hCruiseREF = nil
                        end
                        if point.TotFlightTime then
                            point.TotFlightTime = nil
                        end
                        if point.TotFlightDist then
                            point.TotFlightDist = nil
                        end
                        if point.etaSpawn then
                            point.etaSpawn = nil
                        end
                        if point.baseStartup then
                            point.baseStartup = nil
                        end
                        if point.debug then
                            point.debug = nil
                        end
                    end

                    for _, unit in pairs(group.units) do
                        -- print("unit.name "..tostring(unit.name))
                        --supprime DCE_payloadtName
                        if unit.payload and unit.payload.DCE_payloadtName then
                            unit.payload.DCE_payloadtName = nil
                        end
                        --ici, il faut supprimer la variable unit.dead_last meme si elle est false
                        unit.dead_last = nil
                        if unit.CheckDay then
                            unit.CheckDay = nil
                        end

                        --corrige le bug du SH-3D
                        if unit.type == "SH-3D" and group.task == "Transport" then
                            group.task = "CAS"
                        end

                    end


                end

            end
        end
    end
end


--supprime les élements dead
--supprime le skill des static
--supprime taskSelected des static
local toRemove = {}
for _, side in pairs(mission.coalition) do
    for _, country in pairs(side.country) do
        for category, groups in pairs(country) do
            -- Vérifier si la catégorie est "static" (string)
            if category == "static" and type(groups) == "table" and groups["group"] then
                for groupNb, group in pairs(groups["group"]) do
                    for _, unit in pairs(group.units) do
                        --supprime le skill des static
                        if unit.skill == true then
                            unit.skill = nil
                        end
                    end
                    --supprime taskSelected des static
                    if group.taskSelected == true then
                        group.taskSelected = nil
                    end
                    if group.dead == true then
                        table.insert(toRemove, groupNb)
                    end

                end
                
                -- Supprimer en ordre inverse
                for i = #toRemove, 1, -1 do
                    table.remove(groups["group"], toRemove[i])
                end
                toRemove = {} -- Réinitialiser pour la prochaine catégorie
            end
        end
    end
end

for _, side in pairs(mission.coalition) do
    for _, country in pairs(side.country) do
        for category, groups in pairs(country) do
            -- Vérifier si la catégorie est "static" (string)
            if type(groups) == "table" and groups["group"] then

                    -- type = "removed",
                    --     path = "/coalition/red/country/3/static",
                    --     key = "static",
                    --     value = {
                    -- ["group"] = {
                    -- },
                --suite au constat plus haut ( static/group vide) on regarde si la table static est vide
                -- si oui, on supprime static/group
                for key, val in pairs(groups) do
                    if key == "group" then
                        if type(val) == "table" and #val == 0 then
                            country[category] = nil
                        end
                    end
                end
            end
        end
    end
end





