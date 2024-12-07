
-- local lfs = require("lfs") -- LuaFileSystem doit être disponible
-- print("Répertoire courant : ", lfs.currentdir())
-- print("Current working directory:", lfs.currentdir())
print("Current working directory:", os.getenv("PWD") or io.popen("cd"):read('*l'))

local pathSup = "C:\\Users\\miguel\\Saved Games\\DCS\\Mods\\tech\\DCE\\ScriptsMod.NG"
dofile("UTIL_Functions.lua")

local pathTest = "C:\\Users\\miguel\\Saved Games\\DCS\\Mods\\tech\\DCE\\ScriptsMod.NG\\TEMP\\UTIL_db_loadouts.lua"

dofile(pathTest)

print("pathTest:"..pathTest)


-- function pairsByKeys (t, f)
--     local a = {}
-- 	local initType
-- 	local dontSort = false
--     for n in pairs(t) do initType = type(n) break end
-- 	for n in pairs(t) do 
-- 		table.insert(a, n) 
-- 		if type(n) ~= initType then dontSort = true end
-- 	end
-- 	if not dontSort then 
-- 		table.sort(a, f) 
-- 	end
--     local i = 0      -- iterator variable
--     local iter = function ()   -- iterator function
--         i = i + 1
--         if a[i] == nil then return nil
--         else return a[i], t[a[i]]
--         end
--     end
--     return iter
-- end

--[[ 
--function to make a deep copy of a table
    function deepcopy(orig)
        local orig_type = type(orig)
        local copy
        if orig_type == 'table' then
            copy = {}
            for orig_key, orig_value in next, orig, nil do
                copy[deepcopy(orig_key)] = deepcopy(orig_value)
            end
            setmetatable(copy, deepcopy(getmetatable(orig)))
        else -- number, string, boolean, etc
            copy = orig
        end
        return copy
    end

    function TableSerialization(t, i, params)
	
        local crlf = ""
        local tab1 = ""
        for n = 1, i do																	--controls the indent for the current text line
            tab1 = tab1 .. "\t"
        end
    
        local text = "\n"..crlf..tab1.."{\n"..crlf
    
        local tab = ""
        for n = 1, i + 1 do																	--controls the indent for the current text line
            tab = tab .. "\t"
        end
    
        -- if params then
        -- 	table.sort(t, function(a,b) return a[params] > b[params]  end)
        -- end
    
        for k,v in pairsByKeys(t) do
            if type(k) == "string" then
                text = text .. tab .. '["' .. k .. '"] = '
            else
                text = text .. tab .. "[" .. k .. "] = "
            end
            if type(v) == "string" then
                text = text .. '"' .. v .. '",\n'..crlf
            elseif type(v) == "number" then
                text = text .. v .. ",\n"..crlf
            elseif type(v) == "table" then
                text = text .. TableSerialization(v, i + 1)
            elseif type(v) == "boolean" then
                if v == true then
                    text = text .. "true,\n"..crlf
                else
                    text = text .. "false,\n"..crlf
                end
            elseif type(v) == "function" then
                text = text .. v .. ",\n"..crlf
            elseif v == nil then
                text = text .. "nil,\n"..crlf
            end
        end
        tab = ""
        for n = 1, i do																		--indent for closing bracket is one less then previous text line
            tab = tab .. "\t"
        end
        if i == 0 then
            text = text .. tab .. "}\n"		..crlf												--the last bracket should not be followed by an comma
        else
            text = text .. tab .. "},\n"	..crlf												--all brackets with indent higher than 0 are followed by a comma
        end
        return text
    end

 ]]
    dofile("UTIL_db_loadouts.lua")

    local db_all_loadouts = db_all_loadouts or {}

    local cruiseTable = {}
    for typePlane, loadout in pairs(db_all_loadouts) do
        for task, item_loadout in pairs(loadout) do
            for loadoutName, loadout in pairs(item_loadout) do
                for key, value in pairs(loadout) do

                    if not cruiseTable[typePlane] then cruiseTable[typePlane] = {} end

                    if not cruiseTable[typePlane]["hCruiseMin"] then cruiseTable[typePlane]["hCruiseMin"] = 9999999 end
                    if not cruiseTable[typePlane]["hCruiseMax"] then cruiseTable[typePlane]["hCruiseMax"] = 0 end

                    if not cruiseTable[typePlane]["vCruiseMin"] then cruiseTable[typePlane]["vCruiseMin"] = 9999999 end
                    if not cruiseTable[typePlane]["vCruiseMax"] then cruiseTable[typePlane]["vCruiseMax"] = 0 end


                    if type(value) == "number" then
                        if key == "hCruise" then
                            print("hCruise typePlane: "..typePlane.." loadoutName: |"..tostring(loadoutName))

                            if not cruiseTable[typePlane]["hCruiseMin"] then cruiseTable[typePlane]["hCruiseMin"] = value end
                            if not cruiseTable[typePlane]["hCruiseMax"] then cruiseTable[typePlane]["hCruiseMax"] = value end
                            

                            if cruiseTable[typePlane]["hCruiseMin"] and value < cruiseTable[typePlane]["hCruiseMin"] then cruiseTable[typePlane]["hCruiseMin"] = value end
                            if cruiseTable[typePlane]["hCruiseMax"] and value > cruiseTable[typePlane]["hCruiseMax"] then cruiseTable[typePlane]["hCruiseMax"] = value end


                        elseif key == "vCruise" then

                            print("vCruise typePlane: "..typePlane.." loadoutName: |"..tostring(loadoutName))

                            if not cruiseTable[typePlane]["vCruiseMin"] then cruiseTable[typePlane]["vCruiseMin"] = value end
                            if not cruiseTable[typePlane]["vCruiseMax"] then cruiseTable[typePlane]["vCruiseMax"] = value end
                            
                            if cruiseTable[typePlane]["vCruiseMin"] and value < cruiseTable[typePlane]["vCruiseMin"] then cruiseTable[typePlane]["vCruiseMin"] = value end
                            if cruiseTable[typePlane]["vCruiseMax"] and value > cruiseTable[typePlane]["vCruiseMax"] then cruiseTable[typePlane]["vCruiseMax"] = value end


                        end
                    end
                end
            end
        end
    
    
    end

    local logStr = "Cruise = " .. TableSerialization(cruiseTable, 0)
    local logFile = io.open("RES\\z_cruise.lua", "w") or error("Failed to open debug file")
    logFile:write(logStr)
    logFile:close()	