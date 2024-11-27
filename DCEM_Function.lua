--explication
------------------------------------------------------------------------------------------------------- 
-- last modification: adjustment_c
if not versionDCE then versionDCE = {} end
versionDCE["DCEM_Function.lua"] = "1.1.4"
-------------------------------------------------------------------------------------------------------
-- adjustment_c			(c playerSide)(b add tabSquad)(a SAR & CSAR)
-- modification 
-------------------------------------------------------------------------------------------------------

-- local pathScriptsMod = "C:/Users/Miguel/Saved Games/DCS_Installer/Mods/tech/DCE/ScriptsMod.NG"
-- local pathCampaign = "C:/Users/Miguel/Saved Games/DCS_Installer/Mods/tech/DCE/Missions/Campaigns/Crisis in PG-Blue-GC22"

-- C:\Users\Miguel\Saved Games\DCS_Installer\Mods\tech\DCE\Missions\Campaigns\Crisis in PG-Blue-GC22
-- C:/Users/Miguel/Saved Games/DCS_Installer/Mods/tech/DCE/Missions/Crisis in PG-Blue-GC22

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


--******************************************************************--
--******************************************************************--
--********* Function qui return les Task possible par type d'avion
--******************************************************************--
--******************************************************************--


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

							--si transport et helico, ajoute SAR et CSAR
                            if task == "Transport" and isHelicopter[squad.type]    then
                                task = "SAR"		
								if not taskByPlane[squad.type][task] then taskByPlane[squad.type][task] = true end	
								task = "CSAR"		
								if not taskByPlane[squad.type][task] then taskByPlane[squad.type][task] = true end
								task = "Transport"
                            end

                            if not taskByPlane[squad.type][task] then taskByPlane[squad.type][task] = true end
                        end
                    end
                end
            end
		end
	end
end

--******************************************************************--
--******************************************************************--
--********* Function qui return les avions playable
--******************************************************************--
--******************************************************************--

local Playable_m = {}
for planeType, value in pairs(data_divers) do	
	if value.playable then
		Playable_m[planeType] = true
	end
end	


--******************************************************************--
--******************************************************************--
--********* Function qui return un string Type/NameSquad/base
--      Pour le clonage de campaign
--******************************************************************--
--******************************************************************--

local oldSquadName = ""
local newSquadName = ""

local playerSide = "blue"

--affiche le type d'avion selectionné et son squadrons
for side, squadTL in  pairs(oob_air) do
	for squad_n, squad in  pairs(squadTL) do
		if squad.player then 
			-- playerPlane = squad.type
			-- playerSquad = squad.name
			-- playerCountry = squad.country
			playerSide = side
		end
	end
end

--TIPS sort (attention suite à un tri, la boucle doit etre fait avec ipairs)
local oobAirSide = oob_air[playerSide]
table.sort(oobAirSide, function(a, b) return a.type:upper() < b.type:upper() end)

-- Playable_m = {}
-- for planeType, value in pairs(data_divers) do	
-- 	if value.playable then
-- 		Playable_m[planeType] = true
-- 	end
-- end	


local nType = 1
local tabSquad = {}

for m , unit in ipairs(oobAirSide) do
	if Playable_m[unit.type] then

		table.insert(tabSquad, nType, unit.type.." | "..unit.name.." | "..unit.base)

		nType = nType + 1
	end
end

--******************************************************************--
--******************************************************************--
--********* 
--******************************************************************--
--******************************************************************--

local test_str = "tabSquad = " .. TableSerialization(tabSquad, 0)						--make a string
local testFile = io.open(pathCampaign.."/Debug/DCEM_Function_tabSquad.lua", "w")								--open targetlist file
testFile:write(test_str)															--save new data
testFile:close()

local test_str = "taskByPlane = " .. TableSerialization(taskByPlane, 0)						--make a string
local testFile = io.open(pathCampaign.."/Debug/DCEM_Function_taskByPlane.lua", "w")								--open targetlist file
testFile:write(test_str)															--save new data
testFile:close()

local test_str = "Playable_m = " .. TableSerialization(Playable_m, 0)						--make a string
local testFile = io.open(pathCampaign.."/Debug/DCEM_Function_Playable_m.lua", "w")								--open targetlist file
testFile:write(test_str)															--save new data
testFile:close()

--******************************************************************--
--******************************************************************--
--********* 
--******************************************************************--
--******************************************************************--

return {
    taskByPlane = taskByPlane,
    Playable_m = Playable_m,
	tabSquad = tabSquad,
}






