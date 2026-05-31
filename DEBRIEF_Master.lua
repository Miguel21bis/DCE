--To evaluate the DCS debrief.log, update the campaign status files/OOBs, generate a Debriefing and initiate generation of next campaign mission
--Initiated by MissionEnd.lua running from within DCS
------------------------------------------------------------------------------------------------------- 
if not versionDCE then versionDCE = {} end
versionDCE["DEBRIEF_Master.lua"] = "1.17.137"
-------------------------------------------------------------------------------------------------------


BugList = BugList or {}
Playable_m = {}
AcceptedMission = false
MissionInstance = 0
TimeAlreadyAdded = false

Briefing_status = ""																		--text string to be added to next briefing (status reports are amended for each mission generation attempt until mission is succesfully generated)
Briefing_oob_text_red = ""																	--text string to be added to next briefing (red repair and reinforcements)
Briefing_oob_text_blue = ""																	--text string to be added to next briefing (blue repair and reinforcements)
Briefing_text = ""
PlayerSide = nil

local function acceptMission()
	local m = ""
	repeat
		print("Actual time(DebriefMaster A): " .. FormatTime(camp.time, "hh:mm") .. ", " .. camp.date.day .. "." .. camp.date.month .. "." .. camp.date.year .. ".\n")
		print("\n\n Night or Day ? : "..Daytime)											-- info day or not
		print("\n\nAccept Mission ?:")

		print("a".." - Accept mission")
		print("s".." - Skip mission")

		m = tostring(io.stdin:read())
		m = string.lower(m)

		if not ( m ~= nil and ( m == "a" or m == "s" or m == "d")) then
			print("\nInvalid entry.\n")
		end
	until m ~= nil and ( m == "a" or m == "s" or m == "d")

	if  m == "s" then
		TaskRefused = true
		return false
	elseif  m == "d" then
		os.execute('start "Debug" "notepad++.exe" "Debug/debugFlight' .. '.txt"')
		return true
	else
		return true
	end
end

-- Convertit les tasks longues en codes courts lisibles console
local function taskToShort(task)

	local taskMap = {
		["Strike"] = "STR",
		["Escort"] = "ESC",
		["CAP"] = "CAP",
		["Intercept"] = "INT",
		["Fighter Sweep"] = "FS",
		["SEAD"] = "SD",
		["Anti-ship Strike"] = "ASH",
		["Runway Attack"] = "RW",
		["SAR"] = "SAR",
		["CSAR"] = "CSAR",
	}

	return taskMap[task] or task
end


-- Construit la liste compacte des tasks dispo pour un squadron
local function buildTaskString(playableFlight)

	local tasks = {}

	if playableFlight.task then
		tasks[#tasks + 1] = taskToShort(playableFlight.task)
	end

	-- évite doublons
	local already = {}
	local result = {}

	for i = 1, #tasks do
		if not already[tasks[i]] then
			already[tasks[i]] = true
			result[#result + 1] = tasks[i]
		end
	end

	return table.concat(result, " ")
end

-- Tronque une chaine à une longueur fixe pour affichage console
local function fitString(txt, maxLen)

	txt = tostring(txt or "")

	if string.len(txt) <= maxLen then
		return txt
	end

	if maxLen <= 3 then
		return string.sub(txt, 1, maxLen)
	end

	return string.sub(txt, 1, maxLen - 3).."..."
end

-- random seed -----
local seed = os.time() -- Récupérer un timestamp en secondes
math.randomseed(seed)  -- Initialiser le générateur pseudo-aléatoire

--load functions
dofile("Init/conf_mod.lua")

--load mission export files
local testNamePath = "camp_status.lua"
local testPath = io.open(testNamePath, "r")
if testPath == nil then
	local txt = "DEBUG_DebriefMission is a utility that allows you to resume the script at the end of a mission\
	But it needs the temporary mission end files, which are not present here.\
	\
	These files have not been written because:\
	- the path does not match (path.bat) \
	- or sanitizeModule is not disabled (DCE_MissionScript_Mod)\
	- or these files have been deleted by a new mission generation.\
	"
	print(txt)
	print("DCE debug") os.execute 'pause'
	os.exit()
end

local logExport = loadfile("MissionEventsLog.lua")()											--mission events log
local scenExport = loadfile("scen_destroyed.lua")()												--destroyed scenery objects
local campExport = loadfile("camp_status.lua")()
Mission_LL_Positions = nil
local SARExport

local ll_PositionsExport = (loadfile("Mission_LL_Positions.lua") or function() return {} end)()

--camp full type A
dofile("Active/camp_status.lua")

if campL then
	--merge camp full and camp light
	for k,v in pairs(camp) do
		for kk,vv in pairs(campL) do
			if k == kk then
				v = vv
			end
		end	
	end	

	-- add keys from campL that are not in camp
	for kk,vv in pairs(campL) do
		if not camp[kk] then
			camp[kk] = vv
		end
	end
end

--zoneSAR = {
local zoneSARFile = "zoneSAR.lua"
testPath = io.open(zoneSARFile, "r")																--cette maniere de chercher la presence d un fichier evite un plantage
if testPath ~= nil then																					--check si le fichier existe dans ScriptsMod
	io.close(testPath)
	SARExport = loadfile("zoneSAR.lua")()														--zoneSAR
end


VersionPackageICM = camp.VersionPackageICM

if not VersionPackageICM or VersionPackageICM == nil then										-- modification M35.d version ScriptsMod
	VersionPackageICM = os.getenv('VersionPackageICM')											-- modification M35.c version ScriptsMod
end


dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_Functions.lua")

--TODO ceci ne fonctionne pas
-- recherche tjs pourquoi on ne passe pas du 15 au 16
-- puis pourquoi on n'a pas les nouvelles cibles du 16

UpdateConfModSuite(nil, nil, "DEBRIEF_Master "..debug.getinfo(1).currentline)

--load status file to be updated
require("Active/oob_ground")																	--load ground oob
require("Active/oob_air")																		--load air oob


--affiche le type d'avion selectionné et son squadrons M55_a
local playerInfo = {
	planeBat = "",
	squadBat = "",
	countryBat = "",
	sideBAT = "",
}

-- playerSide = ""
local n_player = 0
for side, squadTL in PairsByKeys(oob_air) do
	for squad_n, squad in PairsByKeys(squadTL) do
		if squad.player then
			playerInfo.planeBAT = squad.type
			playerInfo.squadBAT = squad.name
			playerInfo.countryBAT = squad.country
			playerInfo.sideBAT = side
			n_player = n_player + 1
		end
	end
end
PlayerSide = playerInfo.sideBAT
if n_player > 1 then
	print("Warning: more than one player squadron found in OOB.")
	os.execute 'pause'
end

-- Exécution du fichier s'il existe
local testFile = "Init/various_table.lua"
if FileExists(testFile) then
    dofile(testFile)
end

require("Active/clientstats")																	--load clientstats

--camp_ZoneSAR = {
zoneSARFile = "Active/camp_ZoneSAR.lua"
testPath = io.open(zoneSARFile, "r")																--cette maniere de chercer la presence d un fichier evite un plantage
if testPath ~= nil then																					--check si le fichier existe dans ScriptsMod
	io.close(testPath)
	require("Active/camp_ZoneSAR")																--zoneSAR
end


--ne pas supprimer, utile pour le fichier statsevaluation
dofile("Active/db_airbases.lua")
dofile("Active/targetlist.lua")
dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_Data.lua")
dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_DataMap.lua")


----*********** create and view Debriefing file for mission ********************************************
----*********** create and view Debriefing file for mission ********************************************
--run log evaluation and status updates
dofile("../../../ScriptsMod."..VersionPackageICM.."/DEBRIEF_StatsEvaluation.lua")
dofile("Active/oob_scen.lua")
--il faut laisser cette ligne, sinon le double appel crée un pb de alive_last
dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_UpdateTargetlist.lua")
dofile("../../../ScriptsMod."..VersionPackageICM.."/DEBRIEF_Text.lua")														--In this script the actual text is created. Script loaded after oob modifications above have been made.


local debriefFile = io.open("Debriefing/Debriefing " .. camp.mission .. ".txt", "w") or error("Failed to open debug file")
debriefFile:write(Debriefing)																	--write Debriefing text into file (variable Debriefing comes from DEBRIEF_Text.lua)
debriefFile:close()
os.execute('start "Debriefing" "notepad.exe" "Debriefing/Debriefing ' .. camp.mission .. '.txt"')	--open the Debriefing file with notepad


ResetUnitClient()
ResetBaseHumain()

local showVersion = VersionPackageICM

local changelogPath = "../../../ScriptsMod."..VersionPackageICM.."/UTIL_Changelog.lua"
local f = io.open(changelogPath, "r")
if f then
	f:close()
	dofile(changelogPath)
	if versionDCE and versionDCE["UTIL_Changelog.lua"] then
		showVersion = showVersion.." ("..versionDCE["UTIL_Changelog.lua"]..")"
	elseif versionDCE and versionDCE["UTIL_Changelog.txt"] then
		showVersion = showVersion.." ("..versionDCE["UTIL_Changelog.txt"]..")"
	end
end

-- for baseName, base in pairs(db_airbases) do
if Debug.debug then
	local foundN = 0
	local foundX = 0
	if camp.RunwayLife then
		for baseN, base in pairs(camp.RunwayLife) do
			if db_airbases[base.name] then
				foundN = foundN + 1

				if not base.pointVec3 then
					_affiche(base "base")
				end

				if db_airbases[base.name].x == base.pointVec3.x  then
					foundX = foundX + 1
				else
					-- print("DebriefMaster : "..tostring(base.name).." foundX incorrect DCE "..tostring(db_airbases[base.name].x).." DCS "..tostring(base.point.x))
				end
			else
				print("DebriefMaster : "..tostring(base.name).." not found in db_airbases")
			end
		end
	end
	print("DebriefMaster "..tostring(foundN).."  foundN in db_airbases")
	print("DebriefMaster "..tostring(foundX).."  foundX in db_airbases")
end



if VersionPackageICM then
	print("============================================================================================================================")
	print(" DCE CAMPAIGN GENERATOR")
	print(" "..tostring(camp.title).."   |   "..tostring(camp.version))
	print("============================================================================================================================")
	print()
	print(" Script : "..tostring(showVersion))
	-- print(" Lua    : "..tostring(_VERSION))
	print()
	print(" Player Aircraft : "..tostring(playerInfo.planeBAT))
	print(" Squadron         : "..tostring(playerInfo.squadBAT))
	print(" Country          : "..tostring(playerInfo.countryBAT))
	print()
	print(" Debug Mode       : "..(Debug.debug and "ENABLED" or "DISABLED"))
	print("============================================================================================================================")
	print()
else
	print("= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =")
end

	--===================================================================================
	-- Ecran N 00 Choix accept result mission or not	
--ask for input to save results 

if Debug.debug or mission_ini.backupAllMissionFiles then

	local filesName = {
		"MissionEventsLog.lua",
		"scen_destroyed.lua",
		"camp_status.lua",
		"zoneSAR.lua",
		"Mission_LL_Positions.lua",
	}

	-- Créer le répertoire "mission_0n" s'il n'existe pas
	local folderName =  "Debug\\mission_" .. string.format("%02d", camp.mission)

	os.execute('md "' .. folderName .. '" > nul 2>&1') -- Utilise `md` pour Windows	
	for fileN, fileName in pairs(filesName) do
		local sourcePath = "..\\" ..camp.title .."\\".. fileName
		-- Copier fileName dans folderName
		local destinationPath = folderName .. "\\" .. fileName
		os.execute('copy "' .. sourcePath .. '" "' .. destinationPath ..  '" > nul 2>&1') -- Utilise `copy`		
	end
end

print("\nAccept mission results? y(es)/n(o):\n")						--ask for user confirmation

local input

repeat
	input = io.stdin:read()
	input = string.lower(input)
	if input == "y" or input == "yes" or input == "n" or input == "no" then
		break
	else
		print("\n\nInvalid entry. Respond with y(es) or n(o):\n")
	end
until input == "y" or input == "yes" or input == "n" or input == "no"

print("\n\n")

if input == "y" or input == "yes" then


	-- Briefing_oob_text_red = FormatTime(camp.time, "hh:mm") .. ", " .. tostring(camp.date.day) .. "." .. tostring(camp.date.month) .. "." .. tostring(camp.date.year).. ".\n"
	-- Briefing_oob_text_blue = FormatTime(camp.time, "hh:mm") .. ", " .. tostring(camp.date.day) .. "." .. tostring(camp.date.month) .. "." .. tostring(camp.date.year).. ".\n"

	
	dofile("../../../ScriptsMod."..VersionPackageICM.."/MAIN_AcceptMission.lua")

else

	--delete mission export files
	if not Debug.debug then
		os.remove("MissionEventsLog.lua")	--DISABLE FOR DEBUG
		os.remove("scen_destroyed.lua")		--DISABLE FOR DEBUG
		os.remove("camp_status.lua")		--DISABLE FOR DEBUG
		os.remove("zoneSAR.lua")			--DISABLE FOR DEBUG
		os.remove("Mission_LL_Positions.lua")			--DISABLE FOR DEBUG
	end
	os.exit()

end
	--===================================================================================
	-- Ecran N 0 Choix next campaign mission	
--ask for input to save results and continue with campaign or disregard the last mission

print("\nGenerate next campaign mission? y(es)/n(o):\n")						--ask for user confirmation

-- input
local choix1

SinglePlayer = false
if Multi == nil then
	Multi =
	{
		NbGroup = 0,
	}
end																						--user input

repeat
	input = io.stdin:read()
	input = string.lower(input)
	if input == "y" or input == "yes" or input == "n" or input == "no" then
		break
	else
		print("\n\nInvalid entry. Respond with y(es) or n(o):\n")
	end
until input == "y" or input == "yes" or input == "n" or input == "no"

print("\n\n")

if input == "y" or input == "yes" then

	repeat
		local tabIndex01 = {
			["s"] = true,
			["d"] = true,

			["df"] = true,

			["c"] = true,

			["n"] = true,
			["t"] = true,


			["y"] = true,
			["z"] = true,
			-- ["w"] = true,--ne pas le mettre pour renouveller un choix possible
		}

		repeat
			--===================================================================================
			-- Ecran N 1 Choix entre Single ou Multiplayer
			--===================================================================================

			print("--------------------------------------------------------------")
			print(" Generate next campaign mission")
			print("--------------------------------------------------------------")
			print()
			print(" [S] Singleplayer")
			print()
			print(" [C] Change aircraft type")
			print()
			print(" [T] Multiplayer by Target")
			print(" [N] Multiplayer by NATO package")
			print()
			print(" [O] Tools / CampaignMaker")
			print()

			choix1 = io.stdin:read()
			choix1 = string.lower(choix1)

			-- Détection du mode debug : activation avec "+", désactivation avec "-"
			if string.find(choix1, "%+") then
				Debug.debug = true
				Debug.AfficheFlight = true
				print("Debug mode activated. Logs will be more detailed and mission generation will not stop for player flight assignment issues.")
				choix1 = string.gsub(choix1, "%+", "")   -- Retirer tous les points
			elseif string.find(choix1, "%-") then
				Debug.debug = false
				Debug.AfficheFlight = false
				print("Debug mode deactivated.")
				choix1 = string.gsub(choix1, "%-", "")   -- Retirer tous les tirets
			end

			--===================================================================================
			-- "T Multiplayer by choice of (T)arget \n"..
			-- "N multiplayer by choice of (N)ATO".."\n"..
			--===================================================================================

			if choix1 == "n" or choix1 == "t"  then
				if choix1 == "t"  then

			--===================================================================================
			-- Ecran N°2 Selection du Target 
			--===================================================================================

				-- UpdateFilesAfterTimeJump()

				-- Fonction pour afficher le menu de sélection du camp
				local function selectCamp()
					print("\n--- Select Coalition ---")
					print("1. targets in the RED camp")
					print("2. targets in the BLUE camp")
					print("3. Exit")

					local choice
					repeat
						io.write("\nEnter your choice (1-3): ")
						choice = tonumber(io.stdin:read())
					until choice == 1 or choice == 2 or choice == 3

					if choice == 1 then return "blue"
					elseif choice == 2 then return "red"
					else
						print("Exiting selection.")
						return nil
					end
				end

				-- Fonction pour afficher le menu de sélection de la mission
				local function selectMissionType()
					print("\n--- Select Mission Type ---")
					print("1. Standard targets (Strike's, Runway Attack)")
					print("2. Rescue mission (SAR/CSAR)")
					print("3. Back to coalition selection")

					local choice
					repeat
						io.write("\nEnter your choice (1-3): ")
						choice = tonumber(io.stdin:read())
					until choice == 1 or choice == 2 or choice == 3

					return choice
				end

				-- Fonction pour afficher les cibles standard (Strike, Runway Attack)
				local function showStandardTargets(targetlist, targetSide)
					local eniSide = DCS_ENI_Side[targetSide]
					print("\n--- Sélectionnez une cible situé dans le camp "..eniSide.." ---")

					-- Trier la table par priorité
					table.sort(targetlist[targetSide], function(a, b)
						return a.priority > b.priority
					end)

					local tabIndex = {}
					local Ckey = 0

					for key, target in ipairs(targetlist[targetSide]) do
						if target.inactive ~= true and target.ATO
						and (string.find(target.task, "Strike") or target.task == "Runway Attack" or target.task == "CAP" or target.task == "Fighter Sweep" or target.task == "Transport")
						and target.type ~= "Ejected Pilot"
						then
							Ckey = key
							io.write(Ckey.." "..eniSide.." "..tostring(target.titleName).."  "..tostring(target.alive).."%  X"..tostring(target.priority).."\n")
							tabIndex[Ckey] = target
						end
					end

					return tabIndex
				end

				-- Fonction pour afficher les cibles de type CSAR (pilotes éjectés)
				local function showCSARTargets(targetlist, targetSide)
					local eniSide = DCS_ENI_Side[targetSide]
					print("\n--- Select the pilot to be rescued, who has fallen into the "..eniSide.." side  ---")
					local tabIndex = {}
					-- local Ckey = 0

					-- Trier la table par priorité
					table.sort(targetlist[targetSide], function(a, b)
						return a.priority > b.priority
					end)

					for key, target in ipairs(targetlist[targetSide]) do
						if not target.inactive and target.ATO and (target.task == "CSAR" or target.task == "SAR") then
							-- Ckey = key
							local mgrsInfo = target.MGRS_Chute_1km or target.MGRS_Chute or 0
							io.write(key.." "..tostring(target.titleName).." "..tostring(mgrsInfo).."\n")
							tabIndex[key] = target
						end
					end

					return tabIndex
				end

				-- Fonction principale pour la sélection des cibles
				local function selectTarget(targetlist)
					local targetSide = selectCamp()
					if not targetSide then return end -- Quitter si l'utilisateur choisit "Exit"

					local missionChoice = selectMissionType()

					local tabIndex = {}
					if missionChoice == 1 then
						tabIndex = showStandardTargets(targetlist, targetSide)
					elseif missionChoice == 2 then
						tabIndex = showCSARTargets(targetlist, targetSide)
					else
						return selectTarget(targetlist) -- Retourner au choix du camp
					end

					if next(tabIndex) == nil then
						print("\nNo available targets for this selection.")
						return
					end

					-- Sélection de la cible spécifique
					
					repeat
						io.write("\nEnter target number: ")
						input = tonumber(io.stdin:read())
						if not input or not tabIndex[input] then
							print("\nInvalid entry. Please enter a valid target number.")
						end
					until input and tabIndex[input]

					local selectedTarget = tabIndex[input]
					Multi.Target = Multi.Target or {}
					Multi.Target[targetSide] = selectedTarget.titleName

					print("\nSelected Target: "..selectedTarget.titleName)
				end

				-- Exécution de la sélection
				selectTarget(targetlist)

				io.write( "\n")
			end	--if choix1 == "t"  then

				--===================================================================================
				-- Ecran N°3 Selection nb of Flight
				--===================================================================================
				repeat
					print("Select number of Flight :\n")
					input = tonumber(io.stdin:read())
					if (input == nil or input == "") then input = 999 end
					if  (input >= 1 and  input <= 10) then
						Multi.NbGroup = input
					else
						print("\nInvalid entry.\n")
					end
				until   (input >= 1 and  input <= 10)

				--===================================================================================
				-- Ecran N°4 Selection du type d'avion Multiplayer	
				--===================================================================================
				local tabIndex = {}
				for i = 1 , Multi.NbGroup do
					local ExPlaneA = ""
					local stopLoop = false
					for nSide , oob_airSide in PairsByKeys(oob_air) do														--pour afficher l'exemple de selection du premier avion présenté
						for m , unit in PairsByKeys(oob_airSide) do
							if Playable_m[unit.type] and unit.inactive ~= true and not stopLoop then
								ExPlaneA = unit.type
								stopLoop = true
							end
						end
					end

					-- print("Choose your aircraft type for Flight n°"..i)
					-- print("(number of aircraft) (type of aircraft) (type of mission)")
					-- print("example for (4 "..ExPlaneA..": Escort): 4ae or 4AE")

					print("Select your flight:")
					print("Format: [1-8 aircraft][ID][Task code]")
					print("Example: 4de = 4 aircraft, ID d, Escort mission")
					print()

					print("Task codes:")
					print("STR=Strike  ESC=Escort  CAP=CAP  INT=Intercept")
					print("FS=FighterSweep  SD=SEAD  ASH=AntiShip  RW=Runway")
					print("SAR=SAR  CSAR=CSAR")
					print()

					if not Multi.Group then Multi.Group= {} end
					if not Multi.Group[i] then Multi.Group[i]= {} end

					local playable_type = {}
					local seen = {}
					local tasks = {}
					local ti = 65 																						--char(65) == a
					local tabTaskAvailable = {}

					-- parse toutes les unités et rempli le tab tabTaskAvailable pour etre sur de proposer toutes les task proposé active 
					for nSide , oob_airSide in PairsByKeys(oob_air) do
						-- print() print(nSide..":")
						for m, unit in PairsByKeys(oob_airSide) do
							if Playable_m[unit.type] and unit.inactive ~= true then

								tabTaskAvailable[nSide] = tabTaskAvailable[nSide] or {}
								-- tabTaskAvailable[nSide][unit.name] = {
								-- 	type = unit.type,
								-- 	base = unit.base,
								-- 	tasks = {},
								-- }

								table.insert(tabTaskAvailable[nSide], {
									name = unit.name,
									type = unit.type,
									base = unit.base,
									tasks = {},
								})

								for taskStr, nbool in PairsByKeys(oob_air[nSide][m].tasks) do
									if nbool then
										taskStr = tostring(taskStr)
										table.insert(tabTaskAvailable[nSide][#tabTaskAvailable[nSide]]["tasks"],taskStr)
									end
								end

							end
						end
					end

					-- display le tableau des choix d'avion et de task
					local tabBug = {}

					for nSide, units in pairs(tabTaskAvailable) do
						print() print(nSide..":")

						--sort units par la key units.type
						table.sort(units, function(a, b)
							return a.type < b.type
						end)


						for unitN, unit in ipairs(units) do

							local indexStringType = string.lower(string.char(ti))

							playable_type[indexStringType] = playable_type[indexStringType] or {}
							playable_type[indexStringType]["type"] = unit.type
							playable_type[indexStringType]["side"] = nSide
							playable_type[indexStringType]["base"] = unit.base
							playable_type[indexStringType]["unitName"] = unit.name

							-- io.write(" (1 to 8): ("..indexStringType.."): "..unit.type.." || "..AliasBaseName(unit.base).." || ")

							-- for taskN, taskStr in PairsByKeys(unit.tasks) do

							-- 	if TabTask[taskStr] then
							-- 		io.write( " ("..TabTask[taskStr]..")"..taskStr.."")
							-- 		-- local FstLetTask = string.lower(string.sub (taskStr, 1, 1))
							-- 		tabIndex[tostring(1)..indexStringType..TabTask[taskStr]] = true
							-- 		tabIndex[tostring(2)..indexStringType..TabTask[taskStr]] = true
							-- 		tabIndex[tostring(3)..indexStringType..TabTask[taskStr]] = true
							-- 		tabIndex[tostring(4)..indexStringType..TabTask[taskStr]] = true
							-- 		tabIndex[tostring(5)..indexStringType..TabTask[taskStr]] = true
							-- 		tabIndex[tostring(6)..indexStringType..TabTask[taskStr]] = true
							-- 		tabIndex[tostring(7)..indexStringType..TabTask[taskStr]] = true
							-- 		tabIndex[tostring(8)..indexStringType..TabTask[taskStr]] = true

							-- 	elseif not TabTask[taskStr] and not string.lower(taskStr) == "spotter" then
							-- 		table.insert(tabBug,taskStr )
							-- 	end
							-- end
							-- io.write("\n")

							local shortTasks = {}
							local displayTasks = {}

							for _, taskStr in PairsByKeys(unit.tasks) do

								if TabTask[taskStr] then

									shortTasks[#shortTasks + 1] = taskToShort(taskStr)

									displayTasks[#displayTasks + 1] =
										taskToShort(taskStr)
										.."("
										..string.lower(TabTask[taskStr])
										..")"
								end
							end

							local shortTaskText = table.concat(displayTasks, " ")

							local line =
								string.format(
									"%-3s %-12s %-19s %-15s %s",
									indexStringType,
									fitString(unit.type, 12),
									fitString(AliasBaseName(unit.base), 19),
									fitString(unit.name, 15),
									-- shortTasks
									shortTaskText
								)

							print(line)

							for taskN, taskStr in PairsByKeys(unit.tasks) do

								if TabTask[taskStr] then

									tabIndex[tostring(1)..indexStringType..TabTask[taskStr]] = true
									tabIndex[tostring(2)..indexStringType..TabTask[taskStr]] = true
									tabIndex[tostring(3)..indexStringType..TabTask[taskStr]] = true
									tabIndex[tostring(4)..indexStringType..TabTask[taskStr]] = true
									tabIndex[tostring(5)..indexStringType..TabTask[taskStr]] = true
									tabIndex[tostring(6)..indexStringType..TabTask[taskStr]] = true
									tabIndex[tostring(7)..indexStringType..TabTask[taskStr]] = true
									tabIndex[tostring(8)..indexStringType..TabTask[taskStr]] = true

								elseif string.lower(taskStr) ~= "spotter" then

									table.insert(tabBug, taskStr)

								end
							end


							ti = ti+1
						end
					end

					io.write( "\n")

					if next(tabBug) == nil then
						-- print("La table est vide.")
					else
						for _, bug in ipairs(tabBug) do
							print("Bug with: "..bug)
						end
					end
					--===================================================================================
					-- Ecran N°5 Selection Nombre d'avion Multiplayer
					--===================================================================================
					repeat
						input = string.lower(io.stdin:read())
						if tabIndex[input] then

							Multi.Group[i] = Multi.Group[i] or {}

							Multi.Group[i].NbPlane = tonumber(string.sub (input, 1, 1))

							local inputTyp = tostring(string.sub (input, 2, 2))
							Multi.Group[i].PlaneType = playable_type[inputTyp].type
							Multi.Group[i].side = playable_type[inputTyp].side
							Multi.Group[i].base = playable_type[inputTyp].base
							Multi.Group[i].unitName = playable_type[inputTyp].unitName
							
							local result = SetUnitClient(playable_type[inputTyp].unitName)
							if not result then 
								AddLog("BatSM ECHEC to SetUnitClient() || "..playable_type[inputTyp].unitName.." || "..AliasBaseName(tostring(playable_type[inputTyp].base)))
							end

							local inputTsk = tostring(string.sub (input, 3, 4))
							Multi.Group[i].task = TabTask[inputTsk]

						else
							print("\nInvalid entry.\n")
						end
					until tabIndex[input]

					io.write( "\n")

					--========================= affiche le choix du joueurs
					print(" -------------------------------------------------------> Building your different Flight: ")
					for k=1, i do
						print(" -------------------------------------------------------> "
						..Multi.Group[k].NbPlane
						.." "..Multi.Group[k].PlaneType
						.." ("..Multi.Group[k].side ..")"
						.." "..Multi.Group[k].task
						.." "..AliasBaseName(Multi.Group[k].base)
					)
					end
					io.write( "\n")

				end
				--===================================================================================
				-- Ecran N°6 SinglePlayer
				--===================================================================================

			elseif choix1 == "s" then
				SinglePlayer = true
				local result = SetBaseHumain(playerInfo.baseBAT)
				if not result then 
					AddLog("BatFM ECHEC	 to set HumanBase " ..tostring(playerInfo.baseBAT))
				end
			elseif choix1 == "d" then
				SinglePlayer = true
				SingleWithDServer = true
				SingleWithDServerAiAir = true

			elseif choix1 == "df" then
				SinglePlayer = true
				SingleWithDServer = true
				elseif choix1 == "c" then
					dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_ChangePlane.lua")
				end

		until tabIndex01[choix1]

		--==========================================================

		--generate next campaign mission

		PlayerFlight = false																		--variable to control mission generation loop
		Briefing_oob_text_red = Briefing_oob_text_red .. FormatTime(camp.time, "hh:mm") .. ", " .. tostring(camp.date.day) .. "." .. tostring(camp.date.month) .. "." .. tostring(camp.date.year).. ".\n"
		Briefing_oob_text_blue = Briefing_oob_text_blue .. FormatTime(camp.time, "hh:mm") .. ", " .. tostring(camp.date.day) .. "." .. tostring(camp.date.month) .. "." .. tostring(camp.date.year).. ".\n"

		repeat
			print("Generating Next Mission.\n")

			MissionInstance = MissionInstance + 1													--count the number of times the mission is generated															   
			dofile("../../../ScriptsMod."..VersionPackageICM.."/MAIN_NextMission.lua")											--generate next mission

			AcceptedMission = false

			if EndCampaign or camp.endCampaign then 																			-- debug01.b EndMission
				local EndInfo
				if EndCampaign == nil then
					EndInfo = camp.endCampaign
				else
					EndInfo = EndCampaign
				end
				print("\n This campaign is a ".. tostring(EndInfo).."  \nEND OF THE CAMPAIGN, SEE THE BRIEFING IN THE MISSION..\n")					-- end of camapaign
				break
			elseif Multi.NbGroup >= 1 and PlayerFlight then
				if acceptMission() then
					BackupFilesMission()
					print("\nMultiplayerCampaign Next mission generated.\n")								--confirmation text
					break
				end
			elseif SinglePlayer and PlayerFlight then														--mission has a player flight
				if acceptMission() then
					BackupFilesMission() 
					print("\nNext mission generated.\n")													--confirmation text
					break
				end
			elseif StopBug then																			--mission has a player flight
				print("\n\n StopBug .\n")																--confirmation text
				break
			elseif MissionInstance == 50 then														--no player flight could be assigned in 50 tries, stop it
				print("Mission Generation Error. No eligible player flight in 50 attempts. Start a new campaign.\n\n")
				break
			else																					--no player flight could be assigned, advance time and try again
				
				for _, crit in ipairs(Playability_criterium) do
					if crit.key == "active_unit" and crit.value == nil then
						print("Player unit is not active.\n\n")
					elseif crit.key == "base" and crit.value == nil then
						print("Player airbase is not operational.\n\n")
					elseif crit.key == "ready_aircraft" and crit.value == nil then
						print("Player unit has no ready aircraft.\n\n")
					elseif crit.key == "tot" and crit.value == nil then
						print("Player aircraft type cannot operate at this time of day.\n\n")
					elseif crit.key == "target" and crit.value == nil then
						print("No eligible mission available for player.\n\n")
					elseif crit.key == "target_firepower" and crit.value == nil then
						print("Not enough ready aircraft for this mission.\n\n")
					elseif crit.key == "weather" and crit.value == nil then
						print("Player aircraft type cannot operate in this weather.\n\n")
					elseif crit.key == "target_range" and crit.value == nil then
						print("No eligible mission available for player.\n\n")
					elseif crit.key == "intercept" and crit.value == nil then
						print("Ground alert intercept duty without launch.\n\n")
					-- else
					-- 	print("No eligible mission available.\n\n")
					end
				end
				if Multi.NbGroup and not PlayerFlight then
					print("Not enough ready aircraft for all clients..\n\n")
				end

				os.execute 'timeout /t 4'

			end


			if showVersion then
				print("============================================================================================================================")
				print(" DCE CAMPAIGN GENERATOR")
				print(" "..tostring(camp.title).."   |   "..tostring(camp.version))
				print("============================================================================================================================")
				print()
				print(" Script : "..tostring(showVersion))
				-- print(" Lua    : "..tostring(_VERSION))
				print()
				print(" Player Aircraft : "..tostring(playerInfo.planeBAT))
				print(" Squadron         : "..tostring(playerInfo.squadBAT))
				print(" Country          : "..tostring(playerInfo.countryBAT))
				print()
				print(" Debug Mode       : "..(Debug.debug and "ENABLED" or "DISABLED"))
				print("============================================================================================================================")
				print()

			else
				print("= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =")
			end


			if Debug.debug and not PlayerFlight then
				print("0C1 DCE debug")  
				_affiche(Playability_criterium)
				
				-- os.execute 'pause'
			end

		until 1 == 2

		break

	until 1 == 2

	os.execute 'pause'


else
	-- camp.waitingNextGen = true

	----- convert tables back to strings for insertion into content files -----
	local cmpStr = "camp = " .. TableSerialization(camp, 0)
	local cmpFile = io.open("Active/camp_status.lua", "w") or error("Failed to open debug file")
	cmpFile:write(cmpStr)
	cmpFile:close()

end

if not Debug.debug then
	--delete mission export files
	os.remove("MissionEventsLog.lua")	--DISABLE FOR DEBUG
	os.remove("scen_destroyed.lua")		--DISABLE FOR DEBUG
	os.remove("camp_status.lua")		--DISABLE FOR DEBUG
	os.remove("zoneSAR.lua")			--DISABLE FOR DEBUG
	os.remove("Mission_LL_Positions.lua")			--DISABLE FOR DEBUG
end

os.exit()