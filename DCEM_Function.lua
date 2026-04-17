
------------------------------------------------------------------------------------------------------- 
if not versionDCE then versionDCE = {} end
versionDCE["DCEM_Function.lua"] = "1.2.7"
-------------------------------------------------------------------------------------------------------

--function type DCS, ne pas changer la casse
function aircraft_task(taskName)

	return taskName
end

pathScriptsMod = pathScriptsMod or  "C:/Users/miguel/Saved Games/DCS/Mods/tech/DCE/ScriptsMod.NG"
pathCampaign = pathCampaign or  "C:/Users/miguel/Saved Games/DCS/Mods/tech/DCE/Missions/Campaigns/Hot War in The Cold - Fishbed"

print("debug pathCampaign "..tostring(pathCampaign))
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


-- récupère le chemin du script actuel (UTIL_Functions.lua)
local currentScript = debug.getinfo(1).source:sub(2)
local baseDir = currentScript:match("(.*/)") or "./"

local function mergeTablesDeep(target, source)
    for k, v in pairs(source) do
        if type(v) == "table" then
            target[k] = target[k] or {}
            mergeTablesDeep(target[k], v)
        else
            target[k] = v
        end
    end
end


-- Charge les mods d'un dossier, exécute chaque fichier dans un env isolé
-- relativeFolder = "../../../Missions/Campaigns/"..camp.title.."/Mods" par exemple
-- ACCEPT_NEW_TABLES = true --toutes les tables créées par le mod seront ajoutées à _G
function LoadModData(relativeFolder, ACCEPT_NEW_TABLES)

    ACCEPT_NEW_TABLES = not not ACCEPT_NEW_TABLES

    for _, fullpath in ipairs(modFiles or {}) do
        if fullpath:match("%.lua$") then

            -- print("DCE : Chargement MOD -> " .. fullpath)

            -- environnement isolé mais qui écrit dans _G directement
            local env = setmetatable({}, { __index = _G, __newindex = _G })

            -- chargement du fichier UNE SEULE FOIS
            local chunk, loadErr = loadfile(fullpath, "t", env)

            if not chunk then
                print("DCE ERROR : loadfile failed for " .. fullpath .. " : " .. tostring(loadErr))
            else
                local ok, execErr = pcall(chunk)

                if not ok then
                    print("DCE ERROR : execution failed for " .. fullpath .. " : " .. tostring(execErr))
                else
                    -- OPTION : si tu veux limiter aux tables uniquement
                    if ACCEPT_NEW_TABLES then
                        for k, v in pairs(env) do
                            if type(k) == "string" and type(v) == "table" then
                                _G[k] = v
                            end
                        end
                    end
                end
            end

        end
    end

end

-- LoadModData("Mods", true)

-- if Data_divers["a_37_dragonfly"] then
-- 	print(" a_37_dragonfly FOUND !!!! ")
-- else
-- 	print(" a_37_dragonfly BUUUUG !!!! ")
-- end

-- os.execute 'pause'
--******************************************************************--
--******************************************************************--
--********* Function qui return les Task possible par type d'avion
--******************************************************************--
--******************************************************************--


-- local taskByPlane = {}
-- --affiche le type d'avion selectionné et son squadrons
-- for side, squadTL in pairs(oob_air) do
-- 	for squad_n, squad in pairs(squadTL) do
-- 		if squad.type then 
--             for task, data in pairs(TaskByPlane) do
--                 for dataType, value in  pairs(data) do
                   
--                     if squad.type == dataType and value then

--                         if task == "Nothing" then
--                         else

--                             if not taskByPlane[squad.type] then taskByPlane[squad.type] = {} end

--                             --modifie certain air/ground en strike
--                             if task == "CAS" or task == "Ground Attack" or task == "Pinpoint Strike"   then
--                                 task = "Strike"			
--                             end

-- 							--si transport et helico, ajoute SAR et CSAR
--                             if task == "Transport" and IsHelicopter[squad.type]    then
--                                 task = "SAR"		
-- 								if not taskByPlane[squad.type][task] then taskByPlane[squad.type][task] = true end	
-- 								task = "CSAR"		
-- 								if not taskByPlane[squad.type][task] then taskByPlane[squad.type][task] = true end
-- 								task = "Transport"
--                             end

--                             if not taskByPlane[squad.type][task] then taskByPlane[squad.type][task] = true end
--                         end
--                     end
--                 end
--             end
-- 		end
-- 	end
-- end

local taskByPlane = {}

for side, squadTL in pairs(oob_air) do
    for squad_n, squad in pairs(squadTL) do
        local planeType = squad.type
        if planeType then

            for task, data in pairs(TaskByPlane) do
                for dataType, value in pairs(data) do

                    if planeType == dataType and value then
                        if task ~= "Nothing" then

                            -- Initialise la liste si nécessaire
                            if not taskByPlane[planeType] then
                                taskByPlane[planeType] = {}
                            end

                            -- Normalisation Strike
                            if task == "CAS" or task == "Ground Attack" or task == "Pinpoint Strike" then
                                task = "Strike"
                            end

                            -- Cas spécial Transport hélico → SAR + CSAR
                            if task == "Transport" and IsHelicopter[planeType] then
                                local list = taskByPlane[planeType]

                                list[#list+1] = "SAR"
                                list[#list+1] = "CSAR"
                                -- On remet task pour l’ajouter ensuite
                                task = "Transport"
                            end

                            -- Ajout de la tâche
                            local list = taskByPlane[planeType]
                            list[#list+1] = task
                        end
                    end
                end
            end
        end
    end
end

-- 🔥 Tri final des tâches pour chaque avion
for planeType, list in pairs(taskByPlane) do
    table.sort(list)
end


--******************************************************************--
--******************************************************************--
--********* Function qui return les avions playable
--******************************************************************--
--******************************************************************--


local Playable_m = {}

for planeType, value in pairs(Data_divers) do
    if value.playable then
        Playable_m[#Playable_m + 1] = planeType
    end
end

table.sort(Playable_m)


--******************************************************************--
--******************************************************************--
--********* Function qui retourne tous les avions/helicopter
--******************************************************************--
--******************************************************************--

local all_PlaneHeli = {}
for planeType, value in pairs(Data_divers) do
    all_PlaneHeli[#all_PlaneHeli + 1] = planeType
end

table.sort(all_PlaneHeli)

--******************************************************************--
--******************************************************************--
--********* Function qui retourne tous all_Country
--******************************************************************--
--******************************************************************--

local all_Country = {}
for n, value in pairs(DataCountry) do
    all_Country[#all_Country + 1] = value.name
end

table.sort(all_Country)

--******************************************************************--
--******************************************************************--
--********* Function qui retourne tous all_callsign_west
--******************************************************************--
--******************************************************************--

local all_callsign_west = {}

for typeFct, callSigns in pairs(Callsign_west) do
    if type(callSigns) == "table" then
        
        all_callsign_west[typeFct] = {}  --  IMPORTANT

        for i = 1, #callSigns do
            local value = callSigns[i]
            if value ~= nil then
                all_callsign_west[typeFct][#all_callsign_west[typeFct] + 1] = value
            end
        end
    end
end


--******************************************************************--
--******************************************************************--
--********* Function qui retourne tous all_specific_callsigns
--******************************************************************--
--******************************************************************--

local all_specific_callsigns = {}

for aircraft, countries in pairs(SpecificCallnames) do
    if type(countries) == "table" then

        all_specific_callsigns[aircraft] = {}

        for country, callSigns in pairs(countries) do
            if type(callSigns) == "table" then

                all_specific_callsigns[aircraft][country] = {}

                for _, value in pairs(callSigns) do  -- 🔴 FIX ICI
                    if value ~= nil then
                        all_specific_callsigns[aircraft][country][#all_specific_callsigns[aircraft][country] + 1] = value
                    end
                end

            end
        end
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
-- for planeType, value in pairs(Data_divers) do	
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

return {
    taskByPlane = taskByPlane,
    Playable_m = Playable_m,
	tabSquad = tabSquad,
	all_PlaneHeli = all_PlaneHeli,
    Country = all_Country,
    CallsignWest = all_callsign_west,
    SpecificCallnames = all_specific_callsigns,
}






