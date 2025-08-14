-- adds the latest and various elements, postFlightPlan

-------------------------------------------------------------------------------------------------------
-- Last Modification updateFunction_d
if not versionDCE then versionDCE = {} end
versionDCE["DC_Final_steps.lua"] = "1.1.1"
-------------------------------------------------------------------------------------------------------

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
        ["fuel_storage"] = {
            ["type"] = "icon",
            ["data"] = "P91000207.png",
        },
        ["power_plant"] = {
            ["type"] = "txt",
            ["data"] = "PP",
        },
        ["rail_bridge"] = {
            ["type"] = "txt",
            ["data"] = "RB",
        },
        ["road_bridge"] = {
            ["type"] = "txt",
            ["data"] = "B",
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

    -- _affiche(targetsName, "targetsName ")


    local nb = 0
    for targetClientN, targetClientName in pairs(targetListRequired) do
        for targetSide, targets in pairs(targetlist) do
            for targetN, target in pairs(targets) do
                if target.name == targetClientName then
                    for elementN, element in pairs(target.elements) do

                        local layerType
                        local data
                        local colorDefine
                        local lowerName = string.lower(element.name)
                        local tempObject = {}

                        local typeMatched = nil
                        if string.find(lowerName, "warehouse") then
                            typeMatched = "warehouse"
                        elseif string.find(lowerName, "fuel") and string.find(lowerName, "storage") then
                            typeMatched = "fuel_storage"
                        elseif string.find(lowerName, "power") and string.find(lowerName, "plant") then
                            typeMatched = "power_plant"
                        elseif string.find(lowerName, "rail") and string.find(lowerName, "bridge") then
                            typeMatched = "rail_bridge"
                        elseif string.find(lowerName, "road") and string.find(lowerName, "bridge") then
                            typeMatched = "road_bridge"
                        -- else
                        --     typeMatched = "warehouse"
                        end

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
                                    ["fillColorString"] = "0xffffff00",     -- fond est transparent
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

    return layersObjects

end

