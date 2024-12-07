
-- print("Current working directory:", lfs.currentdir())
print("Current working directory:", os.getenv("PWD") or io.popen("cd"):read('*l'))

dofile("UTIL_Functions.lua")

dofile("mission")
    
for _side, side in pairs(mission.coalition) do
    for countryN, country in pairs(side.country) do
        for category, groups in pairs(country) do
            if type(groups) == "table" and groups["group"] then
                for Ngroup, group in pairs(groups["group"]) do
                    -- Itération inversée sur les unités
                    for Nunit = #group.units, 1, -1 do
                        local unit = group.units[Nunit]
                        if unit.type and unit.type == "KS-19" then
                            table.remove(group.units, Nunit)
                        end
                    end
                end
            end
        end
    end
end
    


    local logStr = "mission = " .. TableSerialization(mission, 0)
    local logFile = io.open("RES\\mission.lua", "w") or error("Failed to open debug file")
    logFile:write(logStr)
    logFile:close()	