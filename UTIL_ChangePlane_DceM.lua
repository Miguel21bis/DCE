---@diagnostic disable: undefined-global, need-check-nil, lowercase-global
--gives the player the possibility to change planes during the campaign.
------------------------------------------------------------------------------------------------------- 
-- last modification: cleanCode_b
if not versionDCE then versionDCE = {} end
versionDCE["UTIL_ChangePlane_DceM.lua"] = "1.3.8"
-------------------------------------------------------------------------------------------------------
-- adjustment_c				(b Playable_m from Data_divers)
-- cleanCode_b				(b springCleaning)
-- modification M55_c		player can change the type of plane (c:triggers part)(b:same Side)
-------------------------------------------------------------------------------------------------------


--====================================================================================================
--====================================================================================================
-- partie Plane
--change le type d'avion dans le fichier/table oob_air
--====================================================================================================
--====================================================================================================

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


local oldSquadName = ""
local newSquadName = ""


--affiche le type d'avion selectionn� et son squadrons
for side, squadTL in  pairs(oob_air) do
	for squad_n, squad in  pairs(squadTL) do
		if squad.player then 
			playerPlane = squad.type
			playerSquad = squad.name
			playerCountry = squad.country
			playerSide = side
		end
	end
end

-- oobAirSide = oob_air[playerSide]
-- table.sort(oobAirSide, cmp)

--TIPS sort (attention suite � un tri, la boucle doit etre fait avec ipairs)
oobAirSide = oob_air[playerSide]
table.sort(oobAirSide, function(a, b) return a.type:upper() < b.type:upper() end)

-- Playable_m = {}
-- for planeType, value in pairs(frequency) do	
-- 	Playable_m[planeType] = true
-- end	

Playable_m = {}
for planeType, value in pairs(Data_divers) do	
	if value.playable then
		Playable_m[planeType] = true
	end
end	


local nType = 1
local TabSquad = {}

for m , unit in ipairs(oobAirSide) do
	if Playable_m[unit.type] then

		table.insert(TabSquad,nType, unit.type.." | "..unit.name.." | "..unit.base)

		nType = nType + 1
	end
end

local test_str = "TabSquad = " .. TableSerialization(TabSquad, 0)						--make a string
local testFile = io.open(pathCampaign.."/Debug/TabSquad.lua", "w")								--open targetlist file
testFile:write(test_str)															--save new data
testFile:close()

return TabSquad

