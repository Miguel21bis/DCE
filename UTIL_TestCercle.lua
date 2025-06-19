--To generate a new mission file. Unzips template mission, defines content of next missions and packs a new mission file
--Initiated by Debrief_Master.lua, BAT_FirstMission.lua or BAT_RedoMission.lua
------------------------------------------------------------------------------------------------------- 
-- last modification:  M63_a
if not versionDCE then versionDCE = {} end
versionDCE["UTIL_TestCercle"] = "1.2.2"
------------------------------------------------------------------------------------------------------- 
-- cleanCode_a			(a springCleaning)
-- modification M63_a
-- -------------------------------------------------------------------------------------------------------


----- unpack template mission file ----
local minizip = require('minizip')

local zipFile = minizip.unzOpen("Init/base_mission.miz", 'rb')

zipFile:unzLocateFile('mission')
local misStr = zipFile:unzReadAllCurrentFile()
local misStrFunc = loadstring(misStr)()

zipFile:unzLocateFile('options')
local optStr = zipFile:unzReadAllCurrentFile()
local optStrFunc = loadstring(optStr)()

zipFile:unzLocateFile('warehouses')
local warStr = zipFile:unzReadAllCurrentFile()
local warStrFunc = loadstring(warStr)()

zipFile:unzLocateFile('l10n/DEFAULT/dictionary')
local dicStr = zipFile:unzReadAllCurrentFile()
local dicStrFunc = loadstring(dicStr)()

zipFile:unzLocateFile('l10n/DEFAULT/mapResource')
local resStr = zipFile:unzReadAllCurrentFile()
local resStrFunc = loadstring(resStr)()

zipFile:unzClose()

print("mission.version "..mission.version)

-- AddFileTrigger("Cercle_City.lua")													-- Miguel21 modification M61 SAR



mission.drawings = nil
mission["trig"] = 
{
    ["actions"] = 
    {
    }, -- end of ["actions"]
    ["events"] = 
    {
    }, -- end of ["events"]
    ["custom"] = 
    {
    }, -- end of ["custom"]
    ["func"] = 
    {
    }, -- end of ["func"]
    ["flag"] = 
    {
    }, -- end of ["flag"]
    ["conditions"] = 
    {
    }, -- end of ["conditions"]
    ["customStartup"] = 
    {
    }, -- end of ["customStartup"]
    ["funcStartup"] = 
    {
    }, -- end of ["funcStartup"]
}
mission["coalition"] = 
{
    ["neutrals"] = 
    {
        ["bullseye"] = 
        {
            ["y"] = 0,
            ["x"] = 0,
        }, -- end of ["bullseye"]
        ["nav_points"] = 
        {
        }, -- end of ["nav_points"]
        ["name"] = "neutrals",
        ["country"] = 
        {
        }, -- end of ["country"]
    }, -- end of ["neutrals"]
    ["blue"] = 
    {
        ["bullseye"] = 
        {
            ["y"] = 617414,
            ["x"] = -291014,
        }, -- end of ["bullseye"]
        ["nav_points"] = 
        {
        }, -- end of ["nav_points"]
        ["name"] = "blue",
        ["country"] = 
        {
        }, -- end of ["country"]
    }, -- end of ["blue"]
    ["red"] = 
    {
        ["bullseye"] = 
        {
            ["y"] = 371700,
            ["x"] = 11557,
        }, -- end of ["bullseye"]
        ["nav_points"] = 
        {
        }, -- end of ["nav_points"]
        ["name"] = "red",
        ["country"] = 
        {
        }, -- end of ["country"]
    }, -- end of ["red"]
}
mission["failures"] = 
{
}

mission["triggers"] = 
{
    ["zones"] = 
    {}
}

-- ["triggers"] = 
-- {
--     ["zones"] = 
--     {
--         [1] = 
--         {
--             ["radius"] = 914.4,
--             ["zoneId"] = 165,
--             ["color"] = 
--             {
--                 [1] = 1,
--                 [2] = 1,
--                 [3] = 1,
--                 [4] = 0.15,
--             }, -- end of ["color"]
--             ["properties"] = 
--             {
--             }, -- end of ["properties"]
--             ["hidden"] = false,
--             ["y"] = 594396.00768354,
--             ["x"] = -188328.61416991,
--             ["name"] = "1",
--             ["heading"] = 0,
--             ["type"] = 0,
--         }, -- end of [1]

dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_Data_circleSAR_Caucasus.lua")

local n = 0
for nCircle, circle in ipairs(circleSAR) do                   
    n = n +1
    if nCircle > 500 then break end

    --Pixel axe x : horizontal vers la droite
    --Pixel axe y : horizontal vers le bas
    --x=0 et y=0, les origines en haut à gauche

    --mission axe x: vertical vers le haut      (ordonne)
    --mission axe y: horizontal vers la droite  (abscissse)

    -- local mission2d_x = (ref_DCS_metre_ordonne * circle.pixel_y) / ref_pixel_ordonne     --pas assez precis
    local mission2d_x = 58538.7 - (47.2304 * circle.pixel_y )
                        --  58538.7−47.2304x
    

    -- local mission2d_y = (ref_DCS_metre_abscissse * circle.pixel_x) / ref_pixel_abscissse    --pas assez precis                 
    -- local mission2d_y = (564387 * circle.x2d) / offsett_pix_x
    local mission2d_y = (47.2287 * circle.pixel_x) + 70914
                        -- 47.2287x+70914

    local tempZone = 
    {
        ["radius"] = circle.radius * 47.2287,
        ["zoneId"] = nCircle,
        ["color"] = 
        {
            [1] = 1,
            [2] = 1,
            [3] = 1,
            [4] = 0.15,
        },
        -- ["properties"] = 
        -- {
        -- },
        ["hidden"] = false,
        ["y"] = mission2d_y,
        ["x"] = mission2d_x,
        ["name"] = tostring(nCircle),
    }

    mission["triggers"]["zones"][n] = tempZone

end


	----- convert tables back to strings for insertion into content files -----
	local misStr = "mission = " .. TableSerialization(mission, 0)
	local optStr = "options = " .. TableSerialization(options, 0)
	local warStr = "warehouses = " .. TableSerialization(warehouses, 0)
	local dicStr = "dictionary = " .. TableSerialization(dictionary, 0)
	local resStr = "mapResource = " .. TableSerialization(mapResource, 0)
	local cmpStr = "camp = " .. TableSerialization(camp, 0)

	----- create temporary content files of new mission file -----
	local misFile = io.open("misFile.lua", "w") or error("Failed to open debug file")											--mission
	misFile:write(misStr)
	misFile:close()


	local optFile = io.open("optFile.lua", "w")	 or error("Failed to open debug file")										--options
	optFile:write(optStr)
	optFile:close()

	local warFile = io.open("warFile.lua", "w") or error("Failed to open debug file")											--warehouses
	warFile:write(warStr)
	warFile:close()

	local dicFile = io.open("dicFile.lua", "w") or error("Failed to open debug file")											--dictionary
	dicFile:write(dicStr)
	dicFile:close()

	local resFile = io.open("resFile.lua", "w") or error("Failed to open debug file")											--mapResource
	resFile:write(resStr)
	resFile:close()

	----- create new mission file and add content files -----

	
    -- os.remove("../"..camp.title.."/Debriefing/"..camp.title.."_testCircle"..NbMission..".miz")

    -- os.rename("../"..camp.title.."_first.miz", "../"..camp.title.."/Debriefing/"..camp.title.."_first"..NbMission..".miz")
    local miz = minizip.zipCreate("../" .. camp.title .. "_testCircle.miz")					--create the first campaign mission
	
	miz:zipAddFile("mission", "misFile.lua")
	miz:zipAddFile("options", "optFile.lua")
	miz:zipAddFile("warehouses", "warFile.lua")
	miz:zipAddFile("l10n/DEFAULT/dictionary", "dicFile.lua")
	miz:zipAddFile("l10n/DEFAULT/mapResource", "resFile.lua")
		

	miz:zipClose()


----- remove temporary content files -----
os.remove("misFile.lua")
os.remove("optFile.lua")
os.remove("warFile.lua")
os.remove("dicFile.lua")
os.remove("resFile.lua")

