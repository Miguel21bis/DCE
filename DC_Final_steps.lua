-- adds the latest and various elements, postFlightPlan

-------------------------------------------------------------------------------------------------------
-- Last Modification updateFunction_d
if not versionDCE then versionDCE = {} end
versionDCE["DC_Final_steps.lua"] = "1.1.1"
-------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------

    -- [5] = 
    -- {
    --     ["visible"] = true,
    --     ["name"] = "Author",
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
        --         ["layerName"] = "Author",
        --         ["name"] = "Warehouse - 20",
        --         ["angle"] = 0,

if not mission.drawings.layers[5].objects then
    mission.drawings.layers[5].objects = {}
end

-- if mission.drawings.layers[1].mapY then
--     for PolyN = 1, #layer do

--         local tempAlti = {}

--         for pointN, point in ipairs(layer[PolyN].points) do
--             tempAlti[pointN] = {
--                 x = point.x + layer[PolyN].mapX,
--                 y = point.y + layer[PolyN].mapY,
--             }

--         end
--         table.insert(AltitudeFloorNew[alti], tempAlti)
--     end
-- end


local targetsName = {}

if camp.client then
    for clientN, client in pairs(camp.client) do
        if client.target then
            table.insert(targetsName, client.target.name)
        end
    end
elseif camp.player then
    if camp.player.target then
        table.insert(targetsName, camp.player.target.name)
    end
end

local iconeType = {
    ["warehouse"] = "P91000072.png",
    -- ["airbase"] = "P91000073.png",
    ["fuel_storage"] = "P91000207.png",
    ["power_plant"] = "P91000036.png",
    -- ["ship"] = "P91000076.png",
    -- ["static"] = "P91000077.png",
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
for targetClientN, targetClientName in pairs(targetsName) do
    print("targetClientName: " .. targetClientName)

    for targetSide, targets in pairs(targetlist) do
        for targetN, target in pairs(targets) do
            print("target.name: " .. tostring(target.name))

            if target.name == targetClientName then
                for elementN, element in pairs(target.elements) do

                    local fileName
                    local colorDefine
                    local lowerName = string.lower(element.name)

                    if string.find(lowerName, "warehouse") then
                        fileName = iconeType["warehouse"]
                    elseif string.find(lowerName, "fuel") and string.find(lowerName, "storage") then
                        fileName = iconeType["fuel_storage"]
                    elseif string.find(lowerName, "power") and string.find(lowerName, "plant") then
                        fileName = iconeType["power_plant"]
                    else
                        fileName = iconeType["warehouse"]
                    end

                    --definitions des couleurs
                    if element.dead then
                        colorDefine = colorType["black"]
                    else
                        colorDefine = colorType["red"]
                    end

                    local tempObject = {
                        ["visible"] = true,
                        ["mapX"] = element.x,
                        ["mapY"] = element.y,
                        ["primitiveType"] = "Icon",
                        ["scale"] = 1,
                        ["file"] = fileName,
                        ["colorString"] = colorDefine,
                        ["layerName"] = "Author",
                        ["name"] = "TestIconTarget_"..element.name,
                        ["angle"] = 0,
                    }

                    table.insert(mission.drawings.layers[5].objects, tempObject)

                    nb = nb + 1
                end
            end
        end
    end
end

print("Number of targets added to the mission: " .. nb)
-- os.execute 'pause'
