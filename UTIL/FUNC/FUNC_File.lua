

--//####################### file function:
function FileExists(path)
	local file = io.open(path, "r")
	if file then
		file:close()
		return true
	else
		return false
	end
end


function Try_dofile(path)
	local f3 = io.open(path, "r")
	if f3 then f3:close(); dofile(path); return true end
	return false
end


-- function loadDataFile(path, globalName)
-- 	local ok, err = pcall(dofile, path)
-- 	if not ok then
-- 		return nil, "impossible de charger " .. path .. " globalName: " .. globalName .. " (" .. tostring(err) .. ")"
-- 	end
-- 	if _G[globalName] == nil then
-- 		return nil, path .. " ne définit pas " .. globalName
-- 	end
-- 	return _G[globalName]
-- end

local function loadDataFile(path, globalName)
	-- Sauvegarde/restauration de la variable globale visée : si un état vivant
	-- (ex: camp = { mission = 7, ... } chargé depuis Active/camp_status.lua)
	-- porte déjà ce nom, le dofile() ci-dessous ne doit jamais l'écraser.
	-- Seule la valeur nouvellement chargée doit être renvoyée à l'appelant.
	local previousValue = _G[globalName]
	_G[globalName] = nil

	local ok, err = pcall(dofile, path)
	local loadedValue = _G[globalName]

	_G[globalName] = previousValue

	if not ok then
		return nil, "impossible de charger " .. path .. " globalName: " .. globalName .. " (" .. tostring(err) .. ")"
	end
	if loadedValue == nil then
		return nil, path .. " ne définit pas " .. globalName
	end
	return loadedValue
end

-- Fonction pour vérifier l'existence d'un fichier
function FileExists(path)
    local file = io.open(path, "r")
    if file then
        file:close()
        return true
    end
    return false
end

-- Écriture sécurisée dans un fichier
function WriteToFile(path, content)
    local file, err = io.open(path, "w")
    if not file then
        error("Impossible d'ouvrir le fichier '" .. path .. "' pour écriture : " .. tostring(err))
    end
    file:write(content)
    file:close()
end


-- Safe helper: debug may be overridden in some environments, avoid calling nil

function SafeGetLine()

    if type(debug) == "table" and type(debug.getinfo) == "function" then

        local info = debug.getinfo(2)

        return info and info.currentline or 0

    end

    return 0

end

-- Remplace uniquement la partie "valeur" d'une ligne "clé = valeur, -- commentaire",
-- en conservant l'indentation, la clé et le commentaire tels quels.
function setValueOnLine(line, value)
	local beforeEq, afterEq = line:match("^(%s*[%a_][%w_]*%s*=)%s*(.*)$")
	if not beforeEq then return line end
	local comment = afterEq:match("%-%-.*$") or ""
	return beforeEq .. " " .. serializeScalar(value) .. (comment ~= "" and (", " .. comment) or ",")
end


-- Applique un ensemble {chemin.point = valeur} sur conf_mod.lua, en ne
-- touchant qu'aux lignes correspondantes, sans réordonner le reste du fichier.
local function applyUpdatesToFile(path, updates)
	local file = io.open(path, "r")
	if not file then
		print("[UpdateConfMod] impossible d'ouvrir " .. path)
		return false
	end

	local pathStack, outLines, applied = {}, {}, {}
	for line in file:lines() do
		local key = line:match("^%s*([%a_][%w_]*)%s*=")
		if key and line:match("=%s*{") then
			pathStack[#pathStack + 1] = key
			outLines[#outLines + 1] = line
		elseif key then
			local full = (#pathStack > 0 and (table.concat(pathStack, ".") .. "." .. key)) or key
			if updates[full] ~= nil then
				outLines[#outLines + 1] = setValueOnLine(line, updates[full])
				applied[full] = true
			else
				outLines[#outLines + 1] = line
			end
		else
			outLines[#outLines + 1] = line
			if line:match("^%s*}") and #pathStack > 0 then
				pathStack[#pathStack] = nil
			end
		end
	end
	file:close()

	local outFile = io.open(path, "w")
	if not outFile then
		print("[UpdateConfMod] impossible d'écrire " .. path)
		return false
	end
	outFile:write(table.concat(outLines, "\n"))
	outFile:close()

	return true, applied
end

function LoadFileAndUpdate(from)

	if Debug.debug then print("START UTIL_Functions LoadFileAndUpdate() "..tostring(from).." /1/1/1/1/1/1/1///1/1 /1/1/1/1/1/1/1///1/1 /1/1/1/1/1/1/1///1/1 /1/1/1/1/1/1/1///1/1") end

    FromFile = "UTIL_Functions/LoadFileAndUpdate()" -- file name for debug

	----- unpack template mission file ----
	local minizip = require('minizip')

	local zipFile = minizip.unzOpen("Init/base_mission.miz", 'rb')

	zipFile:unzLocateFile('mission')
	local misStr = zipFile:unzReadAllCurrentFile()
	local misStrFunc = loadstring(misStr)()

	NameTheatreLower = string.lower(mission.theatre)
    NameTheatre = mission.theatre

	--util pour connaitre les warehouses utilisé lors du script DC_UpdateOOBGround.lua
	zipFile:unzLocateFile('warehouses')
	local warStr = zipFile:unzReadAllCurrentFile()
	local warStrFunc = loadstring(warStr)()

	FirstCheck_Id()
	CheckAll_Id()

	zipFile:unzClose()

	-- dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_Data.lua")
	-- dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_DataMap.lua")

	IncludeOnce("UTIL_Data.lua")
	IncludeOnce("UTIL_DataMap.lua")

	if not oob_scen and Firstmission_flag then
		require("Active/oob_scen")
	end

	UpdateConfMod(nil, camp.date, "UTIL_Functions/LoadFileAndUpdate() "..debug.getinfo(1).currentline)


	--TODO risque de razer completement camp_init, pas glop, à revoir
	-- if Firstmission_flag then
		-- ModifiCampInit()
	-- end


	--****************************************************************************************
	--ajout automatique d'elements en cours de campagne: START
	--****************************************************************************************


	--********************************* targetlist ******************************************************
	dofile("Init/targetlist_init.lua")
	local targetlist_init = DeepCopy(targetlist)
	if not targetlist_init.blue[1] then
		TargetlistToNum(targetlist_init)
	end

	targetlist = nil

	dofile("Active/targetlist.lua")
	if not targetlist.blue[1] then
		TargetlistToNum(targetlist)
	end

	local changes = CompareTargetLists(targetlist_init, targetlist)

	-- Afficher les résultats
	for _, added in ipairs(changes.added) do
		print("Added TargetList: Name:", added.data.name)
	end
	-- for _, removed in ipairs(changes.removed) do
	-- 	print("Removed TargetList: Name:", removed.data.name)
	-- end

	-- Ajout des éléments manquants dans targetlist
	for _, added in ipairs(changes.added) do
		if not targetlist[added.side] then
			targetlist[added.side] = {}
		end
		-- Insérer l'élément à la fin de la table numérique
		table.insert(targetlist[added.side], added.data)
	end

	-- -- Suppression des éléments retirés de targetlist
	-- for _, removed in ipairs(changes.removed) do
	-- 	if targetlist[removed.side] then
	-- 		for i, target in ipairs(targetlist[removed.side]) do
	-- 			if target.name == removed.name then
	-- 				table.remove(targetlist[removed.side], i)
	-- 				break
	-- 			end
	-- 		end
	-- 	end
	-- end

	--********************************* camp_triggers ******************************************************
	-- Charger les fichiers de référence et de travail
	dofile("Init/camp_triggers_init.lua")
	local camp_triggers_init = camp_triggers

	if not IsSequentialTable(camp_triggers) then
    	camp_triggers = ConvertAlphaToNumeric(camp_triggers)
	end

	dofile("Active/camp_triggers.lua")

	-- Comparer les deux tables
	changes = CompareTableNumericTrigger(camp_triggers_init, camp_triggers)

	-- Afficher les résultats
	for _, added in ipairs(changes.added) do
		-- print("Added triggers: Name:", added.name)
	end
	for _, removed in ipairs(changes.removed) do
		-- print("Removed triggers: Name:", removed.name)
	end

	-- Ajouter les éléments manquants dans camp_triggers
	for _, added in ipairs(changes.added) do
		-- _affiche(added, "triggersAdded: ")
		table.insert(camp_triggers, added)
	end
	-- Supprimer les éléments retirés de camp_triggers
	for _, removed in ipairs(changes.removed) do
		for i, trigger in ipairs(camp_triggers) do
			if trigger.name == removed.name then
				table.remove(camp_triggers, i)
				break
			end
		end
	end



	--********************************* db_airbases ******************************************************
	-- Charger les fichiers de référence et de travail
	dofile("Init/db_airbases.lua")
	local db_airbases_init = db_airbases

	dofile("Active/db_airbases.lua")

	-- Comparer les deux tables
	changes = CompareTableAlphaNumeric(db_airbases_init, db_airbases)

	-- Afficher les résultats
	for _, added in ipairs(changes.added) do
		print("\nAdded db_airbases Name:", added.name)
	end
	-- for _, removed in ipairs(changes.removed) do
	-- 	print("\nRemoved db_airbases: Name:", removed.name)
	-- end

	-- Ajouter les éléments manquants dans db_airbases
	for _, added in ipairs(changes.added) do
		db_airbases[added.name] = added.data
	end
	-- -- Supprimer les éléments retirés de db_airbases
	-- for _, removed in ipairs(changes.removed) do
	-- 	db_airbases[removed.name] = nil
	-- end


	--********************************* oob_air ******************************************************
	dofile("Init/oob_air_init.lua")
	local oob_air_init = oob_air

	dofile("Active/oob_air.lua")
	-- oob_air est maintenant la version active

	-- for sideN, side in pairs(DCS_Side) do
	for _, side in ipairs(DCS_Side) do
		if oob_air_init[side] and oob_air[side] then
			-- Construire un index par nom pour la table active
			local activeByName = {}
			for _, unit in pairs(oob_air[side]) do
				if unit.name then
					activeByName[unit.name] = true
				end
			end

			-- Parcourir les unités de l'init et ajouter celles absentes dans l'actif
			for _, unitInit in pairs(oob_air_init[side]) do
				if unitInit.name and not activeByName[unitInit.name] then

					unitInit.roster = {
						ready = unitInit.number,																	--number of airframes ready for operations
						lost = 0,																				--number of airframes lost
						damaged = 0																				--number of airframes damaged
					}
					unitInit.score = {
						kills_air = 0,																			--air kills
						kills_ground = 0,																		--ground kills
						kills_ship = 0																			--ship kills
					}
					if unitInit.reserve then
						unitInit.roster.reserve = unitInit.reserve
					end


					-- Trouver le prochain index numérique libre
					local idx = #oob_air[side] + 1
					oob_air[side][idx] = unitInit
					print("Ajouté à oob_air["..side.."] : "..unitInit.name)
				end
			end
		end
	end

	
	--****************************************************************************************
	--ajout automatique d'elements en cours de campagne: FIN
	--****************************************************************************************



	-- Exécution du fichier s'il existe
	local testFile = "Init/various_table.lua"
	if FileExists(testFile) then
		dofile(testFile)
	else
		if TypeAlias then
			local _str = "TypeAlias = " .. TableSerialization(TypeAlias, 0)
			local _file = io.open("Init/various_table.lua", "w") or error("Failed to open debug file")
			_file:write(_str)
			_file:close()
		end
	end

	for planeType, value in PairsByKeys(Data_divers) do
		if value.playable then
			Playable_m[planeType] = true
		end
	end

	--si le joueur fait un saut temporel (via date dans conf_mod) on met a jour les fichiers de la campagne
	if not Firstmission_flag and TimeJump then
		if Debug.debug then
			print("UtilF jumpTime_C : "..tostring(TimeJump))
			_affiche(mission_ini.current_date, "mission_ini.current_date")
			_affiche(camp.date, "camp.date")
		end
		UpdateFilesAfterTimeJump()
	end



	--**************INITIALEMENT DANS MAIN_NextMission *****************************
	--**************INITIALEMENT DANS MAIN_NextMission *****************************
	require("Active/oob_ground")
	require("Init/conf_mod")

	-- Si Active/camp_ZoneSAR n'existe pas, on le crée, sinon on le charge
	local zoneSARFile = "../../../Missions/Campaigns/"..camp.title.."/Active/camp_ZoneSAR.lua"
	local f2 = io.open(zoneSARFile, "r")
	if f2 then
		f2:close()
		require("Active/camp_ZoneSAR")
	else
		camp_ZoneSAR = { blue = {}, red = {}, neutrals = {} }
	end

	-- dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_DataRadio.lua")
	IncludeOnce("UTIL_DataRadio.lua")

	--utilise ici le fichier Init/persistenceMP.lua s'il existe, pour facilité l'attribution des num tail/avion
	local persistPath = "../../../Missions/Campaigns/"..camp.title.."/Init/persistenceMP.lua"
	Try_dofile(persistPath)

	--reorganise la table PersistenceMP en fonction de la Task et rank
	if PersistenceMP then
		PersistenceMP_byTask = {}
		for pilotName, pilotData in pairs(PersistenceMP) do
			local task = pilotData.task or "Unknown"
			local rank = pilotData.rank or "Unknown"
			if pilotData.active then
				if not PersistenceMP_byTask[task] then
					PersistenceMP_byTask[task] = {}
				end
				if not PersistenceMP_byTask[task][rank] then
					PersistenceMP_byTask[task][rank] = {}
				end
				pilotData.name = pilotName
				PersistenceMP_byTask[task][rank] = pilotData
			end

		end
		-- s'assure que la renumerotation ne comporte pas de trou
		for task, ranks in pairs(PersistenceMP_byTask) do
			local newRanks = {}
			local rankIndex = 1
			for rank, pilotData in pairs(ranks) do
				newRanks[rankIndex] = pilotData
				rankIndex = rankIndex + 1
			end
			PersistenceMP_byTask[task] = newRanks
		end

	end

	-- dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_CampaignSettings.lua")
	-- dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_Refpoints.lua")
	-- dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_AddPropAircraft.lua")
	Include("DC_CampaignSettings.lua")
	Include("DC_Refpoints.lua")
	Include("UTIL_AddPropAircraft.lua")

	 if Debug.debug then
        print("LOAD LoadFileAndUpdate() from " .. tostring(from))
    end

	--////////////////////////////////////////////////////////
	LoadModData("Mods", true)
	BuildLoadout()
	--////////////////////////////////////////////////////////

	CreateAircraftListInCampaign()
	
	--/////////////////////////////////////////////////////////////////////
	--/////////////////////////////////////////////////////////////////////

	InheritedFromProcessing()
	DataCompilation_DataDiscoveryA2()
	DataCompilation_TaskByPlane()

	Make_Db_Frequency()

	--remplit la table des frequences déjà utilisé dans la map ou les bases
	AssignedFrequencies()

	--supprime des mega grosse table DATA les info supperflue
	CleanDataDivers()

	if Debug.debug then

		camp_str = "Failures = " .. TableSerialization(Failures, 0)
		campFile = io.open("Debug/Failures.lua", "w") or error("Échec d'ouverture du fichier Failures")
		campFile:write(camp_str)
		campFile:close()

		camp_str = "CampaignAircraft = " .. TableSerialization(AircraftInCampaign, 0)
		campFile = io.open("Debug/AircraftInCampaign.lua", "w") or error("Échec d'ouverture du fichier Failures")
		campFile:write(camp_str)
		campFile:close()

		camp_str = "AircraftCampaignBySide = " .. TableSerialization(AircraftCampaignBySide, 0)
		campFile = io.open("Debug/AircraftCampaignBySide.lua", "w") or error("Échec d'ouverture du fichier Failures")
		campFile:write(camp_str)
		campFile:close()
	end

	Check_TaskPossibleByPlane()

	-- print('campDate A '..camp.date.year)

	-- dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_Time.lua")
	-- dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_MoonPhase.lua")
	-- dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_Weather.lua")
	-- dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_NavalEnvironment.lua")
	-- dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_UpdateSAR.lua")
	Include("DC_Time.lua")
	Include("UTIL_MoonPhase.lua")
	Include("DC_Weather.lua")
	Include("DC_NavalEnvironment.lua")
	Include("DC_UpdateSAR.lua")

	-- print('campDate B '..camp.date.year)

	CommonRanges = DCE_FindCommonRadioRanges()	--get common radio range for all planes in campaign

	local file_str = "CommonRanges = " .. TableSerialization(CommonRanges, 0)			--make a string
	local file_File = io.open("Debug/Radio_CommonRanges.lua", "w") or error("Failed to open debug EWR_UtilDebug file")
	file_File:write(file_str)																	--save new data
	file_File:close()

	-- dofile("../../../ScriptsMod."..VersionPackageICM.."/ATO_ThreatEvaluation.lua")
	-- dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_UpdateTargetlist.lua")
	Include("ATO_ThreatEvaluation.lua")
	Include("DC_UpdateTargetlist.lua")


	CheckAll_Id()
	if Debug.debug then print ("Lancement VIA UTIL_Fonction F 4884 (LoadFileAndUpdate)") end

	-- dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_CheckTriggers.lua")
	Include("DC_CheckTriggers.lua")

	if not camp.boundary then
		--creation des borders
		GetBoundary()
	end
	-- dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_UpdateTargetlist.lua")
	Include("DC_UpdateTargetlist.lua")

	if Debug.debug then print ("Lancement VIA UTIL_Fonction G 5690 (LoadFileAndUpdate)") end
	-- dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_CheckTriggers.lua")
	Include("DC_CheckTriggers.lua")


	print('campDate E '..camp.date.year)
	--**************INITIALEMENT DANS MAIN_NextMission *****************************
	--**************INITIALEMENT DANS MAIN_NextMission *****************************

	if Debug.debug then print("FIN UTIL_Functions LoadFileAndUpdate()  /2222222222222222222222222222222222") end



end


--=========================================================================
-- ModifiCampInit
-- Recale Init/camp_init.lua sur la référence UTIL_REF_camp_init.lua (REF_camp) :
--   - REF_camp fait autorité sur la liste des variables valides, leur ordre
--     et leurs commentaires/tags @ui
--   - une variable présente dans REF_camp ET dans le local : on garde la
--     valeur locale, jamais celle de la référence
--   - une variable présente dans REF_camp mais absente du local : on prend
--     la valeur par défaut de la référence
--   - une variable locale absente de REF_camp : soit elle est connue comme
--     devant être portée vers conf_mod.lua (table MIGRATE_TO_CONFMOD),
--     soit elle est obsolète et supprimée
--=========================================================================


local REF_PATH = IncludeResolve("UTIL_REF_camp_init.lua")
if not REF_PATH then
	print("[ModifiCampInit] UTIL_REF_camp_init.lua introuvable (racine testée : " .. MOD_PATH .. ")")
end
local CAMP_INIT_PATH  = "Init/camp_init.lua"
local CONF_MOD_PATH   = "Init/conf_mod.lua"

local LOCAL_ROOT_NAME = "camp"
local REF_ROOT_NAME   = "REF_camp"

-- Anciennes variables qui ont pu traîner dans camp_init.lua et qui doivent
-- être reversées dans conf_mod.lua plutôt que simplement supprimées.
-- Table extensible : ajouter une entrée suffit, pas besoin de toucher au moteur.
local MIGRATE_TO_CONFMOD = {
	["weather.trend"]        = "mission_ini.weather.trend",
	["weather.variance"]     = "mission_ini.weather.variance",
	["weather.refTemp"]      = "mission_ini.weather.refTemp",
	["weather.instability"]  = "mission_ini.weather.instability",
	["weather.windActivity"] = "mission_ini.weather.windActivity",
	["weather.winDirection"] = "mission_ini.weather.winDirection",
}
-- 
-- Aplatit une table imbriquée en {["a.b.c"] = valeur}. Un tableau-liste
-- (v[1] existe) est traité comme une feuille, pas aplati plus loin.
local function flatten(t, prefix, out)
	out = out or {}
	for k, v in pairs(t) do
		local path = prefix and (prefix .. "." .. tostring(k)) or tostring(k)
		if type(v) == "table" and v[1] == nil then
			flatten(v, path, out)
		else
			out[path] = v
		end
	end
	return out
end

function serializeScalar(v)
	if type(v) == "string" then return string.format("%q", v) end
	return tostring(v)
end



-- Porte les variables retrouvées vers conf_mod.lua (une seule responsabilité :
-- ce fichier, dans son propre format, avec la même technique de substitution).
function PortLegacyFieldsToConfMod(path, portable)
	local byPath = {}
	for _, migration in ipairs(portable) do byPath[migration.toPath] = migration.value end

	local file = io.open(path, "r")
	if not file then
		-- print("[PortLegacyFieldsToConfMod] impossible d'ouvrir " .. path)
		return false
	end

	local pathStack, outLines = {}, {}
	for line in file:lines() do
		local key = line:match("^%s*([%a_][%w_]*)%s*=")
		if key and line:match("=%s*{") then
			pathStack[#pathStack + 1] = key
			outLines[#outLines + 1] = line
		elseif key then
			local full = (#pathStack > 0 and (table.concat(pathStack, ".") .. "." .. key)) or key
			if byPath[full] ~= nil then
				outLines[#outLines + 1] = setValueOnLine(line, byPath[full])
				-- print("[ModifiCampInit] porté vers conf_mod : " .. full)
			else
				outLines[#outLines + 1] = line
			end
		else
			outLines[#outLines + 1] = line
			if line:match("^%s*}") and #pathStack > 0 then
				pathStack[#pathStack] = nil
			end
		end
	end
	file:close()

	local out = io.open(path, "w")
	if not out then
		-- print("[PortLegacyFieldsToConfMod] impossible d'écrire " .. path)
		return false
	end
	out:write(table.concat(outLines, "\n"))
	out:close()
	return true
end



-- function ModifiCampInit()

-- 	if not REF_PATH then
-- 		print("[ModifiCampInit] UTIL_REF_camp_init.lua introuvable (racine testée : " .. MOD_PATH .. ")")
-- 		return false
-- 	end

-- 	local REF_camp, refErr = loadDataFile(REF_PATH, REF_ROOT_NAME)
-- 	if not REF_camp then print("[ModifiCampInit] " .. refErr) return false end

-- 	local camp, campErr = loadDataFile(CAMP_INIT_PATH, LOCAL_ROOT_NAME)
-- 	if not camp then print("[ModifiCampInit] " .. campErr) return false end

-- 	local refFile = io.open(REF_PATH, "r")
-- 	if not refFile then print("[ModifiCampInit] impossible d'ouvrir " .. REF_PATH) return false end

-- 	local localFlat   = flatten(camp, nil, {})
-- 	local visited     = {}
-- 	local pathStack   = {}
-- 	local skippingList = false
-- 	local outLines    = {}

-- 	local function currentPath()
-- 		return table.concat(pathStack, ".")
-- 	end

-- 	local isRootLine = true -- traite la toute première ligne "REF_camp = {" à part

-- 	for line in refFile:lines() do

-- 		local key = line:match("^%s*([%a_][%w_]*)%s*=")

-- 		if isRootLine and key == REF_ROOT_NAME then
-- 			-- la ligne d'ouverture porte le nom de la référence (REF_camp) ;
-- 			-- on la réécrit avec le nom réellement utilisé dans camp_init.lua (camp)
-- 			outLines[#outLines + 1] = line:gsub("^(%s*)" .. REF_ROOT_NAME, "%1" .. LOCAL_ROOT_NAME)
-- 			isRootLine = false

-- 		elseif skippingList then
-- 			-- on saute les lignes d'exemple d'une liste déjà régénérée
-- 			if line:match("^%s*}") then
-- 				outLines[#outLines + 1] = line
-- 				pathStack[#pathStack] = nil
-- 				skippingList = false
-- 			end

-- 		elseif key and line:match("=%s*{") then
-- 			-- ouverture d'une sous-table
-- 			pathStack[#pathStack + 1] = key
-- 			outLines[#outLines + 1] = line

-- 			-- ne régénère que si la donnée locale à ce chemin est un vrai
-- 			-- tableau-liste ; sinon ce n'est qu'un conteneur (ex: pictureBrief
-- 			-- au-dessus de blue/red), on continue la récursion normalement
-- 			local path = currentPath()
-- 			local values = localFlat[path]
-- 			if type(values) == "table" and values[1] ~= nil then
-- 				local indent = (line:match("^(%s*)") or "") .. "\t"
-- 				for _, picName in ipairs(values) do
-- 					outLines[#outLines + 1] = indent .. serializeScalar(picName) .. ","
-- 				end
-- 				skippingList = true
-- 			end

-- 		elseif key then
-- 			-- ligne "clé = valeur, -- commentaire"
-- 			local path = currentPath() ~= "" and (currentPath() .. "." .. key) or key
-- 			visited[path] = true
-- 			local value = localFlat[path]
-- 			outLines[#outLines + 1] = (value ~= nil) and setValueOnLine(line, value) or line

-- 		else
-- 			outLines[#outLines + 1] = line
-- 			if line:match("^%s*}") and #pathStack > 0 then
-- 				pathStack[#pathStack] = nil
-- 			end
-- 		end
-- 	end
-- 	refFile:close()

-- 	-- variables locales absentes de REF_camp : à porter, ou obsolètes
-- 	local portable = {}
-- 	for path, value in pairs(localFlat) do
-- 		if not visited[path] then
-- 			local target = MIGRATE_TO_CONFMOD[path]
-- 			if target then
-- 				portable[#portable + 1] = { fromPath = path, toPath = target, value = value }
-- 			else
-- 				-- print("[ModifiCampInit] variable obsolète supprimée : " .. path)
-- 			end
-- 		end
-- 	end

-- 	local outFile = io.open(CAMP_INIT_PATH, "w")
-- 	if not outFile then print("[ModifiCampInit] impossible d'écrire " .. CAMP_INIT_PATH) return false end
-- 	outFile:write(table.concat(outLines, "\n"))
-- 	outFile:close()

-- 	if #portable > 0 then
-- 		PortLegacyFieldsToConfMod(CONF_MOD_PATH, portable)
-- 	end

-- 	dofile(CAMP_INIT_PATH)
-- 	return true
-- end

function ModifiCampInit()

	local REF_camp, refErr = loadDataFile(REF_PATH, REF_ROOT_NAME)
	if not REF_camp then print("[ModifiCampInit] " .. refErr) return false end

	local camp, campErr = loadDataFile(CAMP_INIT_PATH, LOCAL_ROOT_NAME)
	if not camp then print("[ModifiCampInit] " .. campErr) return false end

	local refFile = io.open(REF_PATH, "r")
	if not refFile then print("[ModifiCampInit] impossible d'ouvrir " .. REF_PATH) return false end

	local localFlat   = flatten(camp, nil, {})
	local visited     = {}
	local pathStack   = {}
	local skippingList = false
	local outLines    = {}

	local function currentPath()
		return table.concat(pathStack, ".")
	end

	local isRootLine = true -- traite la toute première ligne "REF_camp = {" à part

	for line in refFile:lines() do

		local key = line:match("^%s*([%a_][%w_]*)%s*=")

		if isRootLine and key == REF_ROOT_NAME then
			-- la ligne d'ouverture porte le nom de la référence (REF_camp) ;
			-- on la réécrit avec le nom réellement utilisé dans camp_init.lua (camp)
			outLines[#outLines + 1] = line:gsub("^(%s*)" .. REF_ROOT_NAME, "%1" .. LOCAL_ROOT_NAME)
			isRootLine = false

		elseif skippingList then
			-- on saute les lignes d'exemple d'une liste déjà régénérée
			if line:match("^%s*}") then
				outLines[#outLines + 1] = line
				pathStack[#pathStack] = nil
				skippingList = false
			end

		elseif key and line:match("=%s*{") then
			-- ouverture d'une sous-table
			pathStack[#pathStack + 1] = key
			outLines[#outLines + 1] = line

			-- ne régénère que si la donnée locale à ce chemin est un vrai
			-- tableau-liste ; sinon ce n'est qu'un conteneur (ex: pictureBrief
			-- au-dessus de blue/red), on continue la récursion normalement
			local path = currentPath()
			local values = localFlat[path]
			if type(values) == "table" and values[1] ~= nil then
				local indent = (line:match("^(%s*)") or "") .. "\t"
				for _, picName in ipairs(values) do
					outLines[#outLines + 1] = indent .. serializeScalar(picName) .. ","
				end
				skippingList = true
			end

		elseif key then
			-- ligne "clé = valeur, -- commentaire"
			local path = currentPath() ~= "" and (currentPath() .. "." .. key) or key
			visited[path] = true
			local value = localFlat[path]
			outLines[#outLines + 1] = (value ~= nil) and setValueOnLine(line, value) or line

		else
			outLines[#outLines + 1] = line
			if line:match("^%s*}") and #pathStack > 0 then
				pathStack[#pathStack] = nil
			end
		end
	end
	refFile:close()

	-- variables locales absentes de REF_camp : à porter, ou obsolètes
	local portable = {}
	for path, value in pairs(localFlat) do
		if not visited[path] then
			local target = MIGRATE_TO_CONFMOD[path]
			if target then
				portable[#portable + 1] = { fromPath = path, toPath = target, value = value }
			else
				-- print("[ModifiCampInit] variable obsolète supprimée : " .. path)
			end
		end
	end

	local outFile = io.open(CAMP_INIT_PATH, "w")
	if not outFile then print("[ModifiCampInit] impossible d'écrire " .. CAMP_INIT_PATH) return false end
	outFile:write(table.concat(outLines, "\n"))
	outFile:close()

	if #portable > 0 then
		PortLegacyFieldsToConfMod(CONF_MOD_PATH, portable)
	end

	-- NE PAS faire dofile(CAMP_INIT_PATH) ici : ça écraserait la variable
	-- globale "camp" (état vivant de campagne : mission en cours, date, etc.)
	-- avec le template de départ de campagne. Init/camp_init.lua a été
	-- réécrit sur disque ci-dessus, c'est suffisant : il sera relu au
	-- prochain BAT_FirstMission. Ici on ne veut RIEN en mémoire.
	return true
end

--=========================================================================
-- UpdateConfMod(setWeather, setDate, from)
--
--   setWeather : table optionnelle, ex: { trend = 20, refTemp = 15 }
--                seules les clés fournies sont modifiées.
--   setDate    : table optionnelle, ex: { day = 12, month = 8, year = 1996 }
--                mêmes règles que setWeather.
--   from       : chaîne libre indiquant l'origine de l'appel
--                ("trigger", "user", "missionGeneration"...) — sert
--                uniquement au log/traçabilité, aucune restriction de
--                droits n'est appliquée selon cette valeur pour l'instant.
--=========================================================================
local function dateToNumber(d)
    return (d.year or 0) * 10000 + (d.month or 0) * 100 + (d.day or 0)
end

-- function UpdateConfMod(setWeather, setDate, from)

--     from = from or "unknown"

--     if not setWeather and not setDate then
--         -- if Debug.debug then print("[UpdateConfMod] appel depuis '" .. from .. "' sans rien à changer, ignoré") end
--         return true
--     end

--     local updates = {}

--     if setWeather then
--         for field, value in pairs(setWeather) do
--             updates["mission_ini.weather." .. field] = value
--             -- if Debug.debug then print("[UpdateConfMod][" .. from .. "] weather." .. field .. " -> " .. tostring(value)) end
--         end
--     end

--     if setDate then

--         setDate.setDateInNextMission = false

--         -- date proposée = date actuelle + les champs fournis
--         local newDate = {
--             day   = setDate.day   or camp.date.day,
--             month = setDate.month or camp.date.month,
--             year  = setDate.year  or camp.date.year,
--         }

--         if dateToNumber(newDate) < dateToNumber(camp.date) then
--             if Debug.debug then 
--                 print("[UpdateConfMod][" .. from .. "] REFUS date : "
--                     .. string.format("%04d-%02d-%02d", newDate.year, newDate.month, newDate.day)
--                     .. " antérieure à "
--                     .. string.format("%04d-%02d-%02d", camp.date.year, camp.date.month, camp.date.day)
--                     .. " -> changement de date ignoré, le reste est appliqué")
--             end
--         else
--             camp.date = newDate

--             for field, value in pairs(setDate) do
--                 updates["mission_ini.current_date." .. field] = value
--                 -- if Debug.debug then print("[UpdateConfMod][" .. from .. "] current_date." .. field .. " -> " .. tostring(value)) end
--             end
--         end
--     end

--     -- la date a pu être refusée et il n'y avait rien d'autre : plus rien à écrire
--     if next(updates) == nil then
--         -- if Debug.debug then print("[UpdateConfMod][" .. from .. "] aucune mise à jour à écrire") end
--         return true
--     end

--     local ok, applied = applyUpdatesToFile(CONF_MOD_PATH, updates)
--     if not ok then
--         -- if Debug.debug then print("[UpdateConfMod][" .. from .. "] échec de l'écriture de " .. CONF_MOD_PATH) end
--         return false
--     end
--     applied = applied or {}

--     for path in pairs(updates) do
--         if not applied[path] and Debug.debug then
--             -- print("[UpdateConfMod][" .. from .. "] AVERTISSEMENT : clé introuvable dans conf_mod.lua : " .. path)
--         end
--     end

--     dofile(CONF_MOD_PATH) -- recharge mission_ini en mémoire avec les nouvelles valeurs

--     return true
-- end

function UpdateConfMod(setWeather, setDate, from)

    from = from or "unknown"

    if not setWeather and not setDate then
        -- if Debug.debug then print("[UpdateConfMod] appel depuis '" .. from .. "' sans rien à changer, ignoré") end
        return true
    end

    local updates = {}

    if setWeather then
        for field, value in pairs(setWeather) do
            updates["mission_ini.weather." .. field] = value
            -- if Debug.debug then print("[UpdateConfMod][" .. from .. "] weather." .. field .. " -> " .. tostring(value)) end
        end
    end

    if setDate then

        setDate.setDateInNextMission = false

        -- date proposée = date actuelle + les champs fournis
        local newDate = {
            day   = setDate.day   or camp.date.day,
            month = setDate.month or camp.date.month,
            year  = setDate.year  or camp.date.year,
        }

        if dateToNumber(newDate) < dateToNumber(camp.date) then
			if Debug.debug then 
				print("[UpdateConfMod][" .. from .. "] REFUS date : "
					.. string.format("%04d-%02d-%02d", newDate.year, newDate.month, newDate.day)
					.. " antérieure à "
					.. string.format("%04d-%02d-%02d", camp.date.year, camp.date.month, camp.date.day)
					.. " -> changement de date ignoré, le reste est appliqué")
			end
        else
            camp.date = newDate

            for field, value in pairs(setDate) do
                updates["mission_ini.current_date." .. field] = value
                -- if Debug.debug then print("[UpdateConfMod][" .. from .. "] current_date." .. field .. " -> " .. tostring(value)) end
            end
        end
    end

    -- la date a pu être refusée et il n'y avait rien d'autre : plus rien à écrire
    if next(updates) == nil then
        -- if Debug.debug then print("[UpdateConfMod][" .. from .. "] aucune mise à jour à écrire") end
        return true
    end

    local ok, applied = applyUpdatesToFile(CONF_MOD_PATH, updates)
    if not ok then
        -- if Debug.debug then print("[UpdateConfMod][" .. from .. "] échec de l'écriture de " .. CONF_MOD_PATH) end
        return false
    end

    for path in pairs(updates) do
        if not applied[path] then
            -- if Debug.debug then print("[UpdateConfMod][" .. from .. "] AVERTISSEMENT : clé introuvable dans conf_mod.lua : " .. path) end
        end
    end

    -- Le dofile ci-dessous recrée entièrement la table Debug avec les valeurs
    -- par défaut du fichier conf_mod.lua, ce qui écraserait une activation
    -- runtime du mode debug (touche "+") lors des cycles de génération suivants.
    -- On sauvegarde donc l'état courant et on le réapplique juste après.
    local savedDebugMode         = Debug.debug
    local savedAfficheFlight     = Debug.AfficheFlight

    dofile(CONF_MOD_PATH) -- recharge mission_ini en mémoire avec les nouvelles valeurs

    Debug.debug        = savedDebugMode
    Debug.AfficheFlight = savedAfficheFlight

    return true
end


function ShowBugsWindows()
	if not Debug.debug then return end
		--recherche Debug/BugList.lua
		--cette maniere de chercer la presence d un fichier evite un plantage
	local fileName = "Debug/BugList.lua"
	local testPath = io.open(fileName, "r")
	if testPath ~= nil then	
		io.close(testPath)
		os.execute('start "BugList" "notepad.exe" "Debug/BugList.lua"')
	end
end
