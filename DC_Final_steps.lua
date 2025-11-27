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

--set quelques unitées AAA en moyen
for _, side in pairs(mission.coalition) do
	for _, country in pairs(side.country) do
		for _, groups in pairs(country) do
			if type(groups) == "table" and groups["group"]  then
				for _, group in pairs(groups["group"]) do
					for _, unit in pairs(group.units) do
						if unit.type and (unit.type ==  "KS-19" or unit.type ==  "S-60_Type59_Artillery" ) then
							unit.skill = "Average"
						end
					end
				end
			end
		end
	end
end


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
                        if point.briefing_name then
                            point.briefing_name = nil
                        end
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


---
if Debug.debug then
	print("START DC_Final_steps.lua "..versionDCE["DC_Final_steps.lua"].." =-=-=-=-=-=-=-=-=-=-=-=-=-=-=")
end
--demandé par 2 fichiers, normalement via MAIN_NextMission et UTIL_DIvers outils
function AddIconLayer(layersObjects, targetListRequired)


        -- [4] = 
        -- {
        --     ["visible"] = true,
    --     ["name"] = "Common",
        --     ["objects"] = 
        --     {
            -- [27] = 
            --     {
            --         ["visible"] = true,
            --         ["mapY"] = 445695.43,
            --         ["primitiveType"] = "Icon",
            --         ["scale"] = 1,
            --         ["file"] = "P91000072.png",
            --         ["colorString"] = "0x000000ff",
            --         ["mapX"] = 63776.31,
            --         ["layerName"] = "Common",
            --         ["name"] = "Warehouse - 20",
            --         ["angle"] = 0,



    local dataType = {
        ["warehouse"] = {
            ["type"] = "icon",
            ["data"] = "P91000072.png",
        },
        ["ammo_supply"] = {
            ["type"] = "icon",
            ["data"] = "P91000072.png",
        },
        ["logistic_center"] = {
            ["type"] = "icon",
            ["data"] = "P91000072.png",
        },
        ["fuel_storage"] = {
            ["type"] = "icon",
            ["data"] = "P91000207.png",
        },
        ["fuel_tank"] = {
            ["type"] = "icon",
            ["data"] = "P91000207.png",
        },
        ["power_plant"] = {
            ["type"] = "txt",
            ["data"] = "PP",
        },
        ["power_supply"] = {
            ["type"] = "txt",
            ["data"] = "PS",
        },
        ["rail_bridge"] = {
            ["type"] = "txt",
            ["data"] = "RB",
        },
        ["road_bridge"] = {
            ["type"] = "txt",
            ["data"] = "B",
        },
        ["control_tower"] = {
            ["type"] = "txt",
            ["data"] = "CT",
        }, 
        ["command_center"] = {
            ["type"] = "txt",
            ["data"] = "HQ",
        },
        ["airplane_shelter"] = {
            ["type"] = "txt",
            ["data"] = "AS",
        },
        ["default_target"] = {
            ["type"] = "txt",
            ["data"] = "T",
        },
        ["civil_ship"] = {
            ["type"] = "txt",
            ["data"] = "CS",
        },
        ["loading_crane"] = {
            ["type"] = "txt",
            ["data"] = "LC",
        },
        ["communication_center"] = {
            ["type"] = "txt",
            ["data"] = "CC",
        },
    }

    -- Les couleurs dans DCS sont généralement définies au format hexadécimal ARGB (Alpha, Rouge, Vert, Bleu).
    -- Par exemple : "0xRRGGBBAA" où AA est l'opacité (FF = opaque).
    -- Les couleurs standards utilisées dans les fichiers mission DCS sont souvent :
    local colorType = {
        ["red"]   = "0xff0000ff", -- Rouge pur, opaque
        ["blue"]  = "0x0000ffff", -- Bleu pur, opaque
        ["black"] = "0x000000ff", -- Noir, opaque
        ["white"] = "0xffffffff", -- Blanc, opaque
        ["green"] = "0x00ff00ff", -- Vert pur, opaque
        ["yellow"]= "0xffff00ff", -- Jaune, opaque
    }

    local x_Legend = 999999999
    local y_Legend = 999999999
                        
    local nb = 0
    for targetClientN, targetClientName in pairs(targetListRequired) do
        for targetSide, targets in pairs(targetlist) do
            for targetN, target in pairs(targets) do
                 if target.name == targetClientName and target.elements then
                    for elementN, element in pairs(target.elements) do

                        local function matchTypeFromName(name)
                            local lowerName = string.lower(name)
                            for key, val in pairs(dataType) do
                                local allFound = true
                                for sub in string.gmatch(key, "([^_]+)") do
                                    if not string.find(lowerName, sub) then
                                        allFound = false
                                        break
                                    end
                                end
                                if allFound then
                                    return key, val
                                end
                            end
                            return "default_target", dataType["default_target"]
                        end

                        -- Utilisation dans ta boucle :
                        local colorDefine
                        local tempObject = {}
                        local typeMatched, dataInfo = matchTypeFromName(element.name)
                        local data = dataInfo.data
                        local layerType = dataInfo.type


                        -- print("Element Name: " .. element.name .. ", Matched Type: " .. typeMatched)
                        -- _affiche(dataInfo, "dataInfo ")


                        if typeMatched then
                            data = dataType[typeMatched].data
                            layerType = dataType[typeMatched].type

                            --definitions des couleurs
                            if element.dead then
                                colorDefine = colorType["black"]
                            else
                                colorDefine = colorType["red"]
                            end

                            if layerType == "icon" then
                                tempObject = {
                                    ["visible"] = true,
                                    ["mapX"] = element.x,
                                    ["mapY"] = element.y,
                                    ["primitiveType"] = "Icon",
                                    ["scale"] = 1,
                                    ["file"] = tostring(data),
                                    ["name"] = tostring(element.name),
                                    ["colorString"] = tostring(colorDefine),
                                    ["layerName"] = "Common",
                                    ["angle"] = 0,
                                }
                            elseif layerType == "txt" then
                                tempObject =
                                {
                                    ["visible"] = true,
                                    ["borderThickness"] = 0,
                                    ["fillColorString"] = "0xffffff00", -- fond est transparent
                                    ["fontSize"] = 15,
                                    ["mapX"] = element.x,
                                    ["mapY"] = element.y,
                                    ["layerName"] = "Common",
                                    ["primitiveType"] = "TextBox",
                                    ["font"] = "DejaVuLGCSansCondensed.ttf",
                                    ["text"] = tostring(data),
                                    ["name"] = tostring(element.name),
                                    ["colorString"] = tostring(colorDefine),
                                    ["angle"] = 0,
                                }
                            end
                            
                            -- Trouver la position la plus à gauche (minX) et la plus en bas (minY) de tous les éléments du groupe
                            -- On initialise minX et minY si ce n'est pas déjà fait
                            if not x_Legend or element.x < x_Legend then
                                x_Legend = element.x
                            end
                            if not y_Legend or element.y < y_Legend then
                                y_Legend = element.y
                            end
                            
                            nb = nb + 1
                            table.insert(mission.drawings.layers[4].objects, tempObject)
                        end
                    end
                end
            end
        end
    end

    -- print("Number of targets added to the mission: " .. nb)
    -- print("x_Legend: " .. x_Legend.." y_Legend: " .. y_Legend)
    


    x_Legend = x_Legend -500 -- Ajuster la position ordonné pour le texte

    if nb > 0 and LayerObjectsLegend then
        -- Trouver le point d'ancrage de la légende (origine du template)
        local legend_minX = math.huge
        local legend_minY = math.huge
        for _, object in ipairs(LayerObjectsLegend) do
            if object.mapX and object.mapX < legend_minX then legend_minX = object.mapX end
            if object.mapY and object.mapY < legend_minY then legend_minY = object.mapY end
        end

        -- Décaler chaque objet de la légende pour l'aligner sur la cible
        for _, object in ipairs(LayerObjectsLegend) do
            local delta_x = (object.mapX or 0) - legend_minX
            local delta_y = (object.mapY or 0) - legend_minY

            object.mapX = x_Legend + delta_x
            object.mapY = y_Legend + delta_y

            -- print("object.mapX: "..object.mapX.." (x_Legend: "..x_Legend.." + delta_x: "..delta_x..")")
            -- print("object.mapY: "..object.mapY.." (y_Legend: "..y_Legend.." + delta_y: "..delta_y..")")

            table.insert(mission.drawings.layers[4].objects, object)
        end
    end

        -- os.execute 'pause'

    return layersObjects

end

