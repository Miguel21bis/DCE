-- adds the latest and various elements, postFlightPlan

-------------------------------------------------------------------------------------------------------
-- Last Modification M38_n
if not versionDCE then versionDCE = {} end
versionDCE["DC_Final_steps.lua"] = "1.1.1"
-------------------------------------------------------------------------------------------------------
--
-- modification M90_a		missionWithIcone
-------------------------------------------------------------------------------------------------------

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
        }
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

    local x_Legend = 0
    local y_Legend = 0
                        
    local nb = 0
    for targetClientN, targetClientName in pairs(targetListRequired) do
        for targetSide, targets in pairs(targetlist) do
            for targetN, target in pairs(targets) do
                if target.name == targetClientName then
                    for elementN, element in pairs(target.elements) do

                        -- local layerType
                        -- local data
                        -- local colorDefine
                        -- local lowerName = string.lower(element.name)
                        -- local tempObject = {}

                        -- local typeMatched = nil
                        -- if string.find(lowerName, "warehouse") then
                        --     typeMatched = "warehouse"
                        -- elseif string.find(lowerName, "fuel") and string.find(lowerName, "storage") then
                        --     typeMatched = "fuel_storage"
                        -- elseif string.find(lowerName, "power") and string.find(lowerName, "plant") then
                        --     typeMatched = "power_plant"
                        -- elseif string.find(lowerName, "rail") and string.find(lowerName, "bridge") then
                        --     typeMatched = "rail_bridge"
                        -- elseif string.find(lowerName, "road") and string.find(lowerName, "bridge") then
                        --     typeMatched = "road_bridge"
                        -- else
                        --     typeMatched = "default_target"
                        -- end

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


                        print("Element Name: " .. element.name .. ", Matched Type: " .. typeMatched)
                        _affiche(dataInfo, "dataInfo ")


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
                            -- -- On garde aussi la position la plus à droite (maxX) si besoin
                            -- if not maxX or element.x > maxX then
                            --     maxX = element.x
                            -- end
                            -- if not maxY or element.y > maxY then
                            --     maxY = element.y
                            -- end
                            
                            nb = nb + 1
                            table.insert(mission.drawings.layers[4].objects, tempObject)
                        end
                    end
                end
            end
        end
    end

    print("Number of targets added to the mission: " .. nb)
    -- os.execute 'pause'

    y_Legend = y_Legend -500 -- Ajuster la position Y pour le texte

    -- Décalage initial (pour placer la légende où tu veux)
    local delta_x = 0
    local delta_y = 0

    if nb > 0 and LayerObjectsLegend then
        for objectN, object in ipairs(LayerObjectsLegend) do
            -- Calcule le décalage relatif à la position d'origine de chaque objet
            local dx = (object.mapX or 0) - (LayerObjectsLegend[1].mapX or 0)
            local dy = (object.mapY or 0) - (LayerObjectsLegend[1].mapY or 0)

            -- Place l'objet à la nouvelle position
            object.x = x_Legend + dx + delta_x
            object.y = y_Legend + dy + delta_y

            table.insert(mission.drawings.layers[4].objects, object)
        end
    end

    return layersObjects

end

