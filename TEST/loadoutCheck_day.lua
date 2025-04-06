
-- local lfs = require("lfs") -- LuaFileSystem doit être disponible
-- print("Répertoire courant : ", lfs.currentdir())
-- print("Current working directory:", lfs.currentdir())
print("Current working directory:", os.getenv("PWD") or io.popen("cd"):read('*l'))

local pathSup = "C:\\Users\\miguel\\Saved Games\\DCS\\Mods\\tech\\DCE\\ScriptsMod.NG"
dofile("UTIL_Functions.lua")

local pathTest = "C:\\Users\\miguel\\Saved Games\\DCS\\Mods\\tech\\DCE\\ScriptsMod.NG\\TEST\\UTIL_db_loadouts.lua"

dofile(pathTest)

print("pathTest:"..pathTest)


dofile("UTIL_db_loadouts.lua")

local db_all_loadouts = db_all_loadouts or {}

local checkTable = {}
for typePlane, loadouts in pairs(db_all_loadouts) do
    for task, item_loadout in pairs(loadouts) do
        for loadoutName, loadout in pairs(item_loadout) do
            for key, value in pairs(loadout) do

                if not checkTable[typePlane] then checkTable[typePlane] = {} end
                if not checkTable[typePlane][loadoutName] then checkTable[typePlane][loadoutName] = {} end

                if not checkTable[typePlane][loadoutName]["found_day"] then checkTable[typePlane][loadoutName]["found_day"] = false end
                if not checkTable[typePlane][loadoutName]["found_night"] then checkTable[typePlane][loadoutName]["found_night"] = false end
                -- if not cruiseTable[typePlane]["hCruiseMax"] then cruiseTable[typePlane]["hCruiseMax"] = 0 end

                -- if not cruiseTable[typePlane]["vCruiseMin"] then cruiseTable[typePlane]["vCruiseMin"] = 9999999 end
                -- if not cruiseTable[typePlane]["vCruiseMax"] then cruiseTable[typePlane]["vCruiseMax"] = 0 end


                if type(key) ~= "table" then
                    if key == "day" then
                      
                        checkTable[typePlane][loadoutName]["found_day"] = true
                    elseif key == "night" then --and value == true 
                    
                        checkTable[typePlane][loadoutName]["found_night"] = true
                    end
                end
            end
        end
    end
end

for typePlane, loadouts in pairs(checkTable) do
    for loadoutName, loadout in pairs(loadouts) do
        if not loadout.found_day then   --and not loadout.found_night 
            print(typePlane.."| |"..loadoutName.."| |"..tostring(loadout.found_day))
        end
    end
end

-- local logStr = "Cruise = " .. TableSerialization(cruiseTable, 0)
-- local logFile = io.open("RES\\z_cruise.lua", "w") or error("Failed to open debug file")
-- logFile:write(logStr)
-- logFile:close()	