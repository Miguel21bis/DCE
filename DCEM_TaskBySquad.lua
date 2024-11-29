--explication
------------------------------------------------------------------------------------------------------- 
-- last modification: 
if not versionDCE then versionDCE = {} end
versionDCE["DCEM_TaskBySquad.lua"] = "1.1.1"
-------------------------------------------------------------------------------------------------------
-- adjustment_
-- modification 
-------------------------------------------------------------------------------------------------------

-- local pathScriptsMod = "C:/Users/Miguel/Saved Games/DCS_Installer/Mods/tech/DCE/ScriptsMod.NG"
-- local pathCampaign = "C:/Users/Miguel/Saved Games/DCS_Installer/Mods/tech/DCE/Missions/Campaigns/TF-71-80s-Intruder"

dofile(pathScriptsMod.."/UTIL_Data.lua")
dofile(pathCampaign.."/Init/oob_air_init.lua")



--function to turn a table into a string
local function TableSerialization(t, i)
	
	local text = "{\n"
	local tab = ""
	for n = 1, i + 1 do																	--controls the indent for the current text line
		tab = tab .. "\t"
	end
	for k,v in pairs(t) do
		if type(k) == "string" then
			text = text .. tab .. "['" .. k .. "'] = "
		else
			text = text .. tab .. "[" .. k .. "] = "
		end
		if type(v) == "string" then
			text = text .. "'" .. v .. "',\n"
		elseif type(v) == "number" then
			text = text .. v .. ",\n"
		elseif type(v) == "table" then
			text = text .. TableSerialization(v, i + 1)
		elseif type(v) == "boolean" then
			if v == true then
				text = text .. "true,\n"
			else
				text = text .. "false,\n"
			end
		elseif type(v) == "function" then
			text = text .. v .. ",\n"
		elseif v == nil then
			text = text .. "nil,\n"
		end
	end
	tab = ""
	for n = 1, i do																		--indent for closing bracket is one less then previous text line
		tab = tab .. "\t"
	end
	if i == 0 then
		text = text .. tab .. "}\n"														--the last bracket should not be followed by an comma
	else
		text = text .. tab .. "},\n"													--all brackets with indent higher than 0 are followed by a comma
	end
	return text
end




local taskByPlane = {}
--affiche le type d'avion selectionné et son squadrons
for side, squadTL in  pairs(oob_air) do
	for squad_n, squad in  pairs(squadTL) do
		if squad.type then 
            for task, data in  pairs(TaskByPlane) do
                for dataType, value in  pairs(data) do
                   
                    if squad.type == dataType and value then

                        if task == "Nothing" then
                        else

                            if not taskByPlane[squad.type] then taskByPlane[squad.type] = {} end

                            --modifie certain air/ground en strike
                            if task == "CAS" or task == "Ground Attack" or task == "Pinpoint Strike"   then
                                task = "Strike"			
                            end

                            if not taskByPlane[squad.type][task] then taskByPlane[squad.type][task] = true end
                        end
                    end
                end
            end
		end
	end
end


local test_str = "taskByPlane = " .. TableSerialization(taskByPlane, 0)						--make a string
local testFile = io.open(pathCampaign.."/Debug/DCEM_taskByPlane.lua", "w") or error("Failed to open debug file")
testFile:write(test_str)															--save new data
testFile:close()

return taskByPlane

