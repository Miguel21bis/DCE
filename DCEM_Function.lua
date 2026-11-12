
-------------------------------------------------------------------------------------------------------
if not versionDCE then versionDCE = {} end
versionDCE["DCEM_Function.lua"] = "1.2.9"
-------------------------------------------------------------------------------------------------------


--function type DCS, ne pas changer la casse
function aircraft_task(taskName)
	return taskName
end



pathScriptsMod = pathScriptsMod or  "C:/Users/miguel/Saved Games/DCS/Mods/tech/DCE/ScriptsMod.NG"
-- pathCampaign = pathCampaign or  "C:/Users/miguel/Saved Games/DCS/Mods/tech/DCE/Missions/Campaigns/Hot War in The Cold - Fishbed"

-- print("debug pathCampaign "..tostring(pathCampaign))
-- Si UTIL_Include.lua est déjà chargé (cas DCE_Manager, qui passe par
-- DCEM_Bootstrap.lua), on utilise IncludeOnce : le fichier est trouvé où qu'il
-- soit rangé, et il n'est pas rechargé s'il l'est déjà - ce qui évite au passage
-- de déclencher un faux avertissement de compatibilité via le relais resté à la
-- racine. Sinon (chaîne .bat -> luae.exe), on garde l'appel historique.
-- Écrit pour rester valable en Lua 5.1 comme en 5.4.
if type(IncludeOnce) == "function" then
	IncludeOnce("UTIL_Data.lua")
else
	dofile(pathScriptsMod.."/UTIL_Data.lua")
end

dofile(pathCampaign.."/Init/oob_air_init.lua")

local debugTab = {}


--function to turn a table into a string
local function TableSerialization(t, i)

	local text = "{\n"
	local tab = ""
	for n = 1, i + 1 do															--controls the indent for the current text line
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
	for n = 1, i do																--indent for closing bracket is one less then previous text line
		tab = tab .. "\t"
	end
	if i == 0 then
		text = text .. tab .. "}\n"												--the last bracket should not be followed by an comma
	else
		text = text .. tab .. "},\n"											--all brackets with indent higher than 0 are followed by a comma
	end
	return text
end


-- récupère le chemin du script actuel (UTIL_Functions.lua)
local currentScript = debug.getinfo(1).source:sub(2)
local baseDir = currentScript:match("(.*/)") or "./"

function mergeTablesDeep(target, source)
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

local taskByPlane = {}

-- Tâches possibles de TOUS les types d'avion/hélico connus (et plus seulement ceux déjà présents dans oob_air) :
-- l'éditeur de squad de DCE_Manager en a besoin quand on change le type d'un squad.
for planeType, _ in pairs(Data_divers) do
    for task, data in pairs(TaskByPlane) do
        if data[planeType] and task ~= "Nothing" then

            -- Initialise la liste si nécessaire
            local list = taskByPlane[planeType]
            if not list then
                list = {}
                taskByPlane[planeType] = list
            end

            -- Normalisation Strike
            local name = task
            if name == "CAS" or name == "Ground Attack" or name == "Pinpoint Strike" then
                name = "Strike"
            end

            -- Cas spécial Transport hélico -> SAR + CSAR
            if name == "Transport" and IsHelicopter[planeType] then
                list[#list+1] = "SAR"
                list[#list+1] = "CSAR"
            end

            -- Ajout de la tâche
            list[#list+1] = name
        end
    end
end

-- Tri final des tâches pour chaque avion
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
        Playable_m[planeType] = true
    end
end

local Playable_Num = {}
for planeType, value in pairs(Data_divers) do
    if value.playable then
        Playable_Num[#Playable_Num + 1] = planeType
    end
end
table.sort(Playable_Num)


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

        for k, value in pairs(callSigns) do
            if value ~= nil then
                all_callsign_west[typeFct][k] = value
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

                -- for _, value in pairs(callSigns) do
                --     if value ~= nil then
                --         all_specific_callsigns[aircraft][country][#all_specific_callsigns[aircraft][country] + 1] = value
                --     end
                -- end

                for id, value in pairs(callSigns) do
                    if value ~= nil then
                        all_specific_callsigns[aircraft][country][id] = value
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

-- local oldSquadName = ""
-- local newSquadName = ""

-- local playerSide = "blue"
local playerSide

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

debugTab["playerSide"] = playerSide

--TIPS sort (attention suite à un tri, la boucle doit etre fait avec ipairs)
local oobAirSide = oob_air[playerSide]
table.sort(oobAirSide, function(a, b) return a.type:upper() < b.type:upper() end)

local nType = 1
local tabSquad = {}

debugTab["A"] = {}
debugTab["B"] = {}
for m , unit in ipairs(oobAirSide) do

    table.insert(debugTab["A"],unit.type)

	if Playable_m[unit.type] then
        table.insert(debugTab["B"],unit.type)
		table.insert(tabSquad, nType, unit.type.." | "..unit.name.." | "..unit.base)
        -- table.insert(tabSquad, unit.type.." | "..unit.name.." | "..unit.base)

		nType = nType + 1
	end
end



debugTab["C"] = nType

--******************************************************************--
--******************************************************************--
--********* Function qui retourne les plages de fréquence utilisables
--          par module, RADIO PAR RADIO (pas de fusion pour la campagne)
--
--  radioRanges[module] = {
--      default = false,            -- true : aucune donnée radio trouvée pour ce module
--                                  --        (plage 100-156 par défaut, à traiter comme "inconnu")
--      radios  = {
--          { name = "UHF", source = "panelRadio", nbCanal = 20,
--            ranges = { { min = 225, max = 399.975 } } },
--          ...
--      },
--  }
--  Fréquences en MHz.
--  source : "panelRadio" | "HumanRadio" | "default"
--
--  radioInfo : diagnostic (dcsRoot, savedGames, scanned, files, missing, modules,
--  withData, seconds, error) pour que DCE_Manager sache si la lecture a marché.
--******************************************************************--
--******************************************************************--

-- Liste de plages {min,max} depuis { min, max } ou { {min,max}, ... } ou { {min=,max=}, ... }
-- (les tables avec metatable sont les "stubs" du bac à sable de DataDiscoveryA2 : on les ignore)
local function ToRangeList(r)
    local list = {}
    if type(r) ~= "table" or getmetatable(r) then return list end

    local function add(a, b)
        if type(a) == "number" and type(b) == "number" and b > a then
            list[#list + 1] = { min = a, max = b }
        end
    end

    if type(r[1]) == "number" then
        add(r[1], r[2])
    elseif type(r.min) == "number" then
        add(r.min, r.max)
    else
        for i = 1, #r do
            local e = r[i]
            if type(e) == "table" and not getmetatable(e) then
                if type(e[1]) == "number" then
                    add(e[1], e[2])
                else
                    add(e.min, e.max)
                end
            end
        end
    end
    return list
end

-- Radios d'une entrée de Data_divers : panelRadio en priorité, sinon HumanRadio
local function RadiosOfModule(m)
    local radios = {}

    local panel = m.panelRadio
    if type(panel) == "table" and not getmetatable(panel) then
        local idx = {}
        for k, _ in pairs(panel) do
            if type(k) == "number" then idx[#idx + 1] = k end
        end
        table.sort(idx)

        for _, k in ipairs(idx) do
            local p = panel[k]
            if type(p) == "table" and not getmetatable(p) then
                local ranges = ToRangeList(p.range)
                if #ranges > 0 then
                    local nb = 0
                    if type(p.channels) == "table" and not getmetatable(p.channels) then
                        nb = #p.channels
                    end
                    radios[#radios + 1] = {
                        name    = (type(p.name) == "string") and p.name or ("Radio " .. k),
                        source  = "panelRadio",
                        nbCanal = nb,
                        ranges  = ranges,
                    }
                end
            end
        end
    end

    local h = m.HumanRadio
    if #radios == 0 and type(h) == "table" and not getmetatable(h) then
        local ranges = ToRangeList(h.rangeFrequency)
        if #ranges == 0 and type(h.minFrequency) == "number" and type(h.maxFrequency) == "number"
           and h.maxFrequency > h.minFrequency then
            ranges = { { min = h.minFrequency, max = h.maxFrequency } }
        end
        if #ranges > 0 then
            radios[1] = { name = "HumanRadio", source = "HumanRadio", nbCanal = 0, ranges = ranges }
        end
    end

    return radios
end

local radioRanges = {}
local radioInfo = { modules = 0, withData = 0 }
local radioClock = os.clock()

local okRadio, errRadio = pcall(function()

    -- Saved Games\DCS\ déduit de pathScriptsMod si la variable d'environnement n'est pas posée
    local savedGames = os.getenv("pathSavedGames")
    if not savedGames then
        local p = (tostring(pathScriptsMod):gsub("\\", "/"))
        savedGames = p:match("^(.*/DCS[^/]*/)Mods/")
    end

    -- lit les entry.lua de TOUS les modules connus (pas seulement ceux de la campagne),
    -- sans toucher à Tasks ni Failures
    DataCompilation_DataDiscoveryA2({
        allModules     = true,
        radioOnly      = true,
        pathSavedGames = savedGames,
        stats          = radioInfo,
    })

    for planeType, m in pairs(Data_divers) do
        radioInfo.modules = radioInfo.modules + 1

        local radios = RadiosOfModule(m)

        -- pas de donnée propre : on tente le parent (inheritedFrom), sans modifier Data_divers
        local depth = 0
        local parent = m.inheritedFrom and Data_divers[m.inheritedFrom]
        while #radios == 0 and parent and depth < 5 do
            radios = RadiosOfModule(parent)
            parent = parent.inheritedFrom and Data_divers[parent.inheritedFrom]
            depth = depth + 1
        end

        local isDefault = (#radios == 0)
        if isDefault then
            -- même défaut que Make_Db_Frequency (FUNC_Radio.lua)
            radios = { { name = "Default", source = "default", nbCanal = 0, ranges = { { min = 100, max = 156 } } } }
        else
            radioInfo.withData = radioInfo.withData + 1
        end

        radioRanges[planeType] = { default = isDefault, radios = radios }
    end
end)

if not okRadio then
    radioInfo.error = tostring(errRadio)
end
radioInfo.seconds = os.clock() - radioClock

debugTab["radioSeconds"] = radioInfo.seconds

local camp_str = "debugTab = " .. TableSerialization(debugTab, 0)						--make a string
local campFile = io.open(pathCampaign.."/".."Debug/DCEM_debugTab.lua", "w")	 or error("Failed to open debug file")
campFile:write(camp_str)																--save new data
campFile:close()

camp_str = "tabSquad = " .. TableSerialization(tabSquad, 0)						--make a string
campFile = io.open(pathCampaign.."/".."Debug/DCEM_tabSquad.lua", "w")	 or error("Failed to open debug file")
campFile:write(camp_str)																--save new data
campFile:close()

camp_str = "Playable_m = " .. TableSerialization(Playable_m, 0)						--make a string
campFile = io.open(pathCampaign.."/".."Debug/DCEM_Playable_m.lua", "w")	 or error("Failed to open debug file")
campFile:write(camp_str)																--save new data
campFile:close()

camp_str = "RadioRanges = " .. TableSerialization(radioRanges, 0) .. "\nRadioRangesInfo = " .. TableSerialization(radioInfo, 0)
campFile = io.open(pathCampaign.."/".."Debug/DCEM_RadioRanges.lua", "w")	 or error("Failed to open debug file")
campFile:write(camp_str)																--save new data
campFile:close()

--******************************************************************--
--******************************************************************--
--*********
--******************************************************************--
--******************************************************************--

return {
    taskByPlane = taskByPlane,
    Playable_m = Playable_Num,
	TabSquad = tabSquad,
	all_PlaneHeli = all_PlaneHeli,
    Country = all_Country,
    CallsignWest = all_callsign_west,
    SpecificCallnames = all_specific_callsigns,
    RadioRanges = radioRanges,
    RadioRangesInfo = radioInfo,
}
