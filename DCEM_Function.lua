--explication
------------------------------------------------------------------------------------------------------- 
-- cleancode_a				(a springCleaning)
-- last modification: adjustment_c
if not versionDCE then versionDCE = {} end
versionDCE["DCEM_Function.lua"] = "1.2.6"
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
    ACCEPT_NEW_TABLES = not not ACCEPT_NEW_TABLES    -- bool
    local fullFolder = pathCampaign.."/"..relativeFolder
    -- print("DCE : A  Scanning Mods folder : " .. tostring(fullFolder))

    local cmd = 'dir "' .. fullFolder .. '" /b'
	-- print("DCE : B  cmd : " .. tostring(cmd))
    local p = io.popen(cmd)
	-- print("DCE : C  p : " .. tostring(p))
    if not p then
        print("DCE ERROR : impossible de lire le dossier Mods : " .. fullFolder)
        return
    end

	-- print("DCE : D  p : " .. tostring(p))

    for file in p:lines() do
        if file:match("%.lua$") then
            local fullpath = fullFolder .. "/" .. file
            -- print("DCE : Chargement MOD -> " .. fullpath)

            -- load the chunk (file) without executing it globally
            local chunk, loadErr = loadfile(fullpath)
            if not chunk then
                print("DCE ERROR : loadfile failed for " .. fullpath .. " : " .. tostring(loadErr))
            else
                -- create an isolated env that falls back to _G for reads (so mod can call DCE functions)
                local env = {}
                setmetatable(env, { __index = _G })

                -- set this env as the chunk's environment (Lua 5.1)
				chunk, loadErr = loadfile(fullpath, "t", env)
				-- if not chunk then
				-- 	print("DCE ERROR : loadfile failed : " .. tostring(loadErr))
				-- else
					local ok, execErr = pcall(chunk)
				-- end

                if not ok then
                    print("DCE ERROR : execution failed for " .. fullpath .. " : " .. tostring(execErr))
                else
                    -- enumerate what the mod defined in env
                    for k, v in pairs(env) do
                        -- skip metamethods and inherited keys (if index produced inherited, pairs won't show them)
                        if type(k) == "string" then
                            -- only consider tables defined by the mod (ignore functions, numbers...)
                            if type(v) == "table" then
                                print("DCE : Table détectée dans MOD '" .. file .. "' : " .. tostring(k))

                                -- si DCE (global) a déjà une table du même nom -> merge dedans
                                if type(_G[k]) == "table" then
                                    print("DCE : Fusion dans DCE -> " .. tostring(k))
                                    mergeTablesDeep(_G[k], v)
                                else
                                    -- table nouvelle, décider selon ACCEPT_NEW_TABLES
                                    if ACCEPT_NEW_TABLES then
                                        print("DCE : Ajout d'une nouvelle table globale -> " .. tostring(k))
                                        _G[k] = v
                                    else
                                        print("DCE : Table nouvelle ignorée (pour l'instant) -> " .. tostring(k))
                                    end
                                end
                            else
                                -- si le mod définit des scalaires ou fonctions globaux qu'on souhaite conserver ou logger
                                -- par défaut on ignore pour éviter de polluer _G
                                -- Si tu veux autoriser certaines clés non-table, tu peux les whitelist ici.
                            end
                        end
                    end
                end
            end
        end
    end

    p:close()
end

LoadModData("Mods", true)

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
                            if task == "Transport" and IsHelicopter[squad.type]    then
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
for planeType, value in pairs(Data_divers) do	
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

local test_str = "tabSquad = " .. TableSerialization(tabSquad, 0)						--make a string
local testFile = io.open(pathCampaign.."/Debug/DCEM_Function_tabSquad.lua", "w") or error("Failed to open debug file")
testFile:write(test_str)															--save new data
testFile:close()

test_str = "taskByPlane = " .. TableSerialization(taskByPlane, 0)						--make a string
testFile = io.open(pathCampaign.."/Debug/DCEM_Function_taskByPlane.lua", "w") or error("Failed to open debug file")
testFile:write(test_str)															--save new data
testFile:close()

test_str = "Playable_m = " .. TableSerialization(Playable_m, 0)						--make a string
testFile = io.open(pathCampaign.."/Debug/DCEM_Function_Playable_m.lua", "w") or error("Failed to open debug file")
testFile:write(test_str)															--save new data
testFile:close()


test_str = "Data_divers = " .. TableSerialization(Data_divers, 0)						--make a string
testFile = io.open(pathCampaign.."/Debug/DCEM_Function_Data_divers.lua", "w") or error("Failed to open debug file")
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






