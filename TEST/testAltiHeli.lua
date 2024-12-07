
local FpsLeak_B

dofile("UTIL_Functions.lua")


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
    local logFile = io.open(path.."TEST\\"..grpnameClean.."_".. "Custom_Altitude_copyRoute_B1.lua", "w") or error("Failed to open debug file")
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
    local logFile = io.open(path.."TEST\\"..grpnameClean.."_".. "Custom_Altitude_copyRoute_FF.lua", "w") or error("Failed to open debug file")
    logFile:write(logStr)
    logFile:close()	


end

Custom_Altitude("Pack 3 - Iranian SAR Helicopter Squadron 2 - SAR 1", "nil",  "2")