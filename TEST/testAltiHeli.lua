

function pairsByKeys (t, f)
    local a = {}
	local initType
	local dontSort = false
    for n in pairs(t) do initType = type(n) break end
	for n in pairs(t) do 
		table.insert(a, n) 
		if type(n) ~= initType then dontSort = true end
	end
	if not dontSort then 
		table.sort(a, f) 
	end
    local i = 0      -- iterator variable
    local iter = function ()   -- iterator function
        i = i + 1
        if a[i] == nil then return nil
        else return a[i], t[a[i]]
        end
    end
    return iter
end


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

    LastInjectFlightPlan = {
        [100005] = {

            params = {
                route = {
                    points = {
                        [1] = 
                        {
                            ["ETA"] = 2210.26,
                            ["ETA_locked"] = true,
                            ["action"] = "Turning Point",
                            ["alt"] = 52,
                            ["alt_type"] = "BARO",
                            ["formation_template"] = "",
                            ["name"] = "",
                            ["speed"] = 60,
                            ["speed_locked"] = true,
                            ["task"] = 
                            {
                                ["id"] = "ComboTask",
                                ["params"] = 
                                {
                                    ["tasks"] = 
                                    {
                                    },
                                },
                            },
                            ["type"] = "Turning Point",
                            ["x"] = 109137.71076361,
                            ["y"] = -7305.7706179045,
                        },
                        [2] = 
                        {
                            ["ETA"] = 2334.3177420955,
                            ["ETA_locked"] = false,
                            ["action"] = "Turning Point",
                            ["alt"] = 108.5695734024,
                            ["alt_type"] = "BARO",
                            ["formation_template"] = "",
                            ["name"] = "",
                            ["speed"] = 60,
                            ["speed_locked"] = true,
                            ["task"] = 
                            {
                                ["id"] = "ComboTask",
                                ["params"] = 
                                {
                                    ["tasks"] = 
                                    {
                                        [1] = 
                                        {
                                            ["auto"] = false,
                                            ["enabled"] = true,
                                            ["id"] = "WrappedAction",
                                            ["number"] = 1,
                                            ["params"] = 
                                            {
                                                ["action"] = 
                                                {
                                                    ["id"] = "Script",
                                                    ["params"] = 
                                                    {
                                                        ["command"] = 'Custom_Altitude("Pack 3 - Iranian SAR Helicopter Squadron 2 - SAR 1",  "2")',
                                                    },
                                                },
                                            },
                                        },
                                    },
                                },
                            },
                            ["type"] = "Turning Point",
                            ["x"] = 105895.63903555,
                            ["y"] = -14006.079197058,
                        },
                        [3] = 
                        {
                            ["ETA"] = 2980.9314372993,
                            ["ETA_locked"] = false,
                            ["action"] = "Turning Point",
                            ["alt"] = 500,
                            ["alt_type"] = "BARO",
                            ["formation_template"] = "",
                            ["name"] = "",
                            ["speed"] = 55,
                            ["speed_locked"] = true,
                            ["task"] = 
                            {
                                ["id"] = "ComboTask",
                                ["params"] = 
                                {
                                    ["tasks"] = 
                                    {
                                    },
                                },
                            },
                            ["type"] = "Turning Point",
                            ["x"] = 102653.56730748,
                            ["y"] = -20706.387776212,
                        },
                        [4] = 
                        {
                            ["ETA"] = 2980.9314372993,
                            ["ETA_locked"] = false,
                            ["action"] = "Turning Point",
                            ["alt"] = 500,
                            ["alt_type"] = "RADIO",
                            ["formation_template"] = "",
                            ["name"] = "",
                            ["speed"] = 55,
                            ["speed_locked"] = true,
                            ["task"] = 
                            {
                                ["id"] = "ComboTask",
                                ["params"] = 
                                {
                                    ["tasks"] = 
                                    {
                                        [1] = 
                                        {
                                            ["auto"] = false,
                                            ["enabled"] = true,
                                            ["id"] = "WrappedAction",
                                            ["number"] = 2,
                                            ["params"] = 
                                            {
                                                ["action"] = 
                                                {
                                                    ["id"] = "Script",
                                                    ["params"] = 
                                                    {
                                                        ["command"] = 'Custom_SAR("Pack 3 - Iranian SAR Helicopter Squadron 2 - SAR 1",  "Havadarya",  "109137.71076361",  "-7305.7706179045",  "40R_DQ_A_B",   "55",  "500")',
                                                    },
                                                },
                                            },
                                        },
                                    },
                                },
                            },
                            ["type"] = "Turning Point",
                            ["x"] = 102653.56730748,
                            ["y"] = -20706.387776212,
                        },
                        [5] = 
                        {
                            ["ETA"] = 3616.2671559489,
                            ["ETA_locked"] = false,
                            ["action"] = "Turning Point",
                            ["alt"] = 108.5695734024,
                            ["alt_type"] = "BARO",
                            ["formation_template"] = "",
                            ["name"] = "",
                            ["speed"] = 55,
                            ["speed_locked"] = true,
                            ["task"] = 
                            {
                                ["id"] = "ComboTask",
                                ["params"] = 
                                {
                                    ["tasks"] = 
                                    {
                                    },
                                },
                            },
                            ["type"] = "Turning Point",
                            ["x"] = 102653.56730748,
                            ["y"] = -20706.387776212,
                        },
                        [6] = 
                        {
                            ["ETA"] = 5961.8628745985,
                            ["ETA_locked"] = false,
                            ["action"] = "Landing",
                            ["alt"] = 522,
                            ["alt_type"] = "BARO",
                            ["formation_template"] = "",
                            ["helipadId"] = 9,
                            ["linkUnit"] = 9,
                            ["name"] = "",
                            ["speed"] = 55,
                            ["speed_locked"] = true,
                            ["task"] = 
                            {
                                ["id"] = "ComboTask",
                                ["params"] = 
                                {
                                    ["tasks"] = 
                                    {
                                    },
                                },
                            },
                            ["type"] = "Land",
                            ["x"] = 109137.71076361,
                            ["y"] = -7305.7706179045,
                        },
                    },
                }
            }
        }
    }

function Custom_Altitude(grpname, wptAlti, wptTag)
	if FpsLeak_B then return end

    dofile("C:/Users/Miguel/Desktop/Tempon/N/Active/last_Mission.lua")

    -- require("C:/Users/Miguel/Desktop/Tempon/N/Active/last_Mission.lua")
	
	if wptTag then
		wptTag = tonumber(wptTag)
	else
		wptTag = 0
	end
	if not wptAlti or wptAlti == nil then
		wptAlti = 1
		print( "A Custom_Altitude, A wptAlti  |"..tostring(grpname).." |wptAlti: "..tostring(wptAlti))
	end


    -- local  gpGid = Group.getID(flight)
    local  gpGid = 100005
    local foundAeronef = false
    local copyRoute = {}
    
    print( "Custom_Altitude, D gpGid? |"..tostring(gpGid))
    
    for tblGrpId, value in pairs(LastInjectFlightPlan) do
        if tblGrpId == gpGid then
            copyRoute = deepcopy(value.params.route.points)
            foundAeronef = true
            print( "Custom_Altitude, D2_a found LastInjectFlightPlan tblGrpId |"..tostring(tblGrpId))
            break
        end
    end

    if not foundAeronef then
        print( "Custom_Altitude, E |")
        
        for _coalition, coalition in pairs(mission.coalition) do
            for Ncountry, _country in pairs(coalition.country) do	
                if _country.helicopter then
                    for Ngroup, _group in pairs(_country.helicopter.group) do
                        if _group.groupId == gpGid then 						
                            copyRoute = deepcopy(_group.route.points)						
                            foundAeronef = true
                            print( "Custom_Altitude, D2_b found foundAeronef _group.groupId |"..tostring(_group.groupId ))
                            break						
                        end
                    end
                end
                if foundAeronef then break end
            end
            if foundAeronef then break end
        end
    end

    print("B1 #copyRoute "..tostring(#copyRoute))

    local path = "C:/Users/Miguel/Desktop/Tempon/N/"

    local logStr = "Mission = " .. TableSerialization(copyRoute, 0)
    local grpnameClean = grpname:gsub('[%p%c%s]', '_')
    local logFile = io.open(path.."TEST\\"..grpnameClean.."_".. "Custom_Altitude_copyRoute_B1.lua", "w")
    logFile:write(logStr)
    logFile:close()	

    if wptTag and wptTag > 0 then
        print("B2 wptTag "..tostring(wptTag))

        for i = #copyRoute, 1, -1 do
            print("C i "..tostring(i))

            if i <= wptTag then
                print("D table.remove i "..tostring(i))

                table.remove(copyRoute, i)
            end
        end
    end

    print("F #copyRoute "..tostring(#copyRoute))
    local logStr = "Mission = " .. TableSerialization(copyRoute, 0)
    local grpnameClean = grpname:gsub('[%p%c%s]', '_')
    local logFile = io.open(path.."TEST\\"..grpnameClean.."_".. "Custom_Altitude_copyRoute_FF.lua", "w")
    logFile:write(logStr)
    logFile:close()	


end

Custom_Altitude("Pack 3 - Iranian SAR Helicopter Squadron 2 - SAR 1", "nil",  "2")