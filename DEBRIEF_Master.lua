--To evaluate the DCS debrief.log, update the campaign status files/OOBs, generate a Debriefing and initiate generation of next campaign mission
--Initiated by MissionEnd.lua running from within DCS
------------------------------------------------------------------------------------------------------- 
-- last modification:  M47_e
if not versionDCE then versionDCE = {} end
versionDCE["DEBRIEF_Master.lua"] = "1.17.137"
-------------------------------------------------------------------------------------------------------
-- adjustment_n				(n new targetlist)(m oob_scen ==0)(l AcceptedMission again)(k BugList)(j PairsByKeys)(i global TabTask)(g mise a niveau)(e: use io.stdin:read)(c: fire Playable_m from conf_mod)(b: robust form) 
-- debug_d	 				(cd: EndMission)
-- cleanCode_c				(c springCleaning)
-- modification M80_a		use various tables, such as base name or aircraft type aliases
-- modification M61_a		SAR
-- modification M56_a		AssignCallnameSquad
-- modification M55_a		player can change the type of plane
-- modification M50_b		Records landings (b: add data file payload)
-- modification M48_a		Accept result mission
-- modification M47_e		saves missions played and their files (e: creates a folder for each mission-n in \Debug)(c: save debugging information during mission generation)
-- modification M46_d		singlePlayer with dedicated server (c: DF choice)(c: D choice with AI AirSpawn)
-- modification M40_f		Template Active GroundGroup moving front (f: sideBase)
-- modification M38_x		Check and Help CampaignMaker
-- modification M35_f		version ScriptsMod + camp (f camp.version)(e: ScriptsMod_version from UTIL_Changelog)
-- modification M33_n 		Custom Briefing (n don't overwrite old briefing info)
-- modification M14			Versionning
-- modification M11A_b_l	Multiplayer (bl MP overRide) (g %target alive)(t:display name )(s: T choice bug)(q: displays all tasks of several squadrons)
-------------------------------------------------------------------------------------------------------

BugList = {}
Playable_m = {}
AcceptedMission = false
MissionInstance = 0
TimeAlreadyAdded = false

Briefing_status = ""																		--text string to be added to next briefing (status reports are amended for each mission generation attempt until mission is succesfully generated)
Briefing_oob_text_red = ""																	--text string to be added to next briefing (red repair and reinforcements)
Briefing_oob_text_blue = ""																	--text string to be added to next briefing (blue repair and reinforcements)
Briefing_text = ""

local function AcceptMission()
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
local campExport = loadfile("camp_status.lua")()												--camp_status
local SARExport

--zoneSAR = {
local zoneSARFile = "zoneSAR.lua"
local testPath = io.open(zoneSARFile, "r")																--cette maniere de chercer la presence d un fichier evite un plantage
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

UpdateConfMod(nil, nil, "DEBRIEF_Master "..debug.getinfo(1).currentline)

--load status file to be updated
require("Active/oob_ground")																	--load ground oob
require("Active/oob_air")																		--load air oob


-- Exécution du fichier s'il existe
local testFile = "Init/various_table.lua"
if FileExists(testFile) then
    dofile(testFile)
end

require("Active/clientstats")																	--load clientstats

--camp_ZoneSAR = {
local zoneSARFile = "Active/camp_ZoneSAR.lua"
local testPath = io.open(zoneSARFile, "r")																--cette maniere de chercer la presence d un fichier evite un plantage
if testPath ~= nil then																					--check si le fichier existe dans ScriptsMod
	io.close(testPath)
	require("Active/camp_ZoneSAR")																--zoneSAR
end


-- dofile("Init/conf_mod.lua")

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



--mmm non, ça doit effacer les fichiers maj plus haut
-- --***********NEW function***************--
-- --***********NEW function***************--
-- LoadFileAndUpdate()
-- --***********NEW function***************--
-- --***********NEW function***************--


	--Compare les noms des bases de DCS avec ceux enregistré dans DCE		[1] = 
		-- {
		-- 	["baseObject"] = 
		-- 	{
		-- 		["id_"] = 5000002,
		-- 	},
		-- 	["life"] = 3600,
		-- 	["life0"] = 3600,
		-- 	["name"] = "Abu al-Duhur",
		-- 	["point"] = 
		-- 	{
		-- 		["x"] = 75929.7734375,
		-- 		["y"] = 250.00024414062,
		-- 		["z"] = 112670.328125,
		-- 	},
		-- },
		-- [2] = 
		-- {
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



--affiche le type d'avion selectionné et son squadrons M55_a
local playerInfo = {
	planeBat = "",
	squadBat = "",
	countryBat = "",
}

-- playerSide = ""
for side, squadTL in  PairsByKeys(oob_air) do
	for squad_n, squad in  PairsByKeys(squadTL) do
		if squad.player then
			playerInfo.planeBAT = squad.type
			playerInfo.squadBAT = squad.name
			playerInfo.countryBAT = squad.country
		end
	end
end

if VersionPackageICM then
	-- print("= = = = = = = = = = = = = = = = = = = = = = = "..camp.title.." = = = = = = = = = = = = = = = = = =")
	-- print("= = = = = = = = = = = = = = Version: "..tostring(camp.version))
	-- print("= = = = = = = = = = = = = Script: "..showVersion)
	-- print()
	print("0C0= = = = = = = = = = = = = = = = = = = = = = = "..camp.title.." ("..tostring(camp.version)..")= = = = = = = = = = = = = = = =")
	print("= = = = = = = = = = = = = Script Version : "..tostring(showVersion).." = = Lua Version : "..tostring(_VERSION))
	print("= = = = = = = = = = = = = Player Plane : "..tostring(playerInfo.planeBAT).." Unit: "..tostring(playerInfo.squadBAT).." Country: "..tostring(playerInfo.countryBAT))
	print()
else
	print("= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =")
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
	end
	os.exit()

end
	--===================================================================================
	-- Ecran N 0 Choix next campaign mission	
--ask for input to save results and continue with campaign or disregard the last mission

print("\nGenerate next campaign mission? y(es)/n(o):\n")						--ask for user confirmation

local input
local playable_type = {}
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
		--===================================================================================
		-- Ecran N 1 Choix entre Single ou Multiplayer
		print("Select :\n"..
			"S (S)ingleplayer  \n"..
			"D Singleplayer with (D)edicated Server \n"..
			"DF Singleplayer with (D)edicated Server, (F)ull plane on Deck (Testing: Bug Catapult possible) \n"..
			"\n"..
			"C (C)hange type of plane\n"..
			"\n"..
			"T Multiplayer by choice of (T)arget \n"..
			"N multiplayer by choice of (N)ATO")

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


		repeat																							-- adjustment A01 : robust form 

			choix1 = io.stdin:read()
			choix1 = string.lower(choix1)

			if choix1 == "n" or  choix1 == "t"  then
				if choix1 == "t"  then
				--===================================================================================
				-- Ecran N°2 Selection du Target	
				

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
					print("2. Rescue mission (CSAR)")
					print("3. Back to coalition selection")

					local choice
					repeat
						io.write("\nEnter your choice (1-3): ")
						choice = tonumber(io.stdin:read())
					until choice == 1 or choice == 2 or choice == 3

					return choice
				end

				-- Fonction pour afficher les cibles standard (Strike, Runway Attack)
				local function showStandardTargets(targetlist, side)
					print("\n--- select a target in the "..side.." side ---")
					local tabIndex = {}
					local Ckey = 0

					for key, target in ipairs(targetlist[side]) do
						if target.inactive ~= true and target.ATO 
						and (string.find(target.task, "Strike") or target.task == "Runway Attack")
						and target.type ~= "Ejected Pilot"
						then
							Ckey = key
							io.write(Ckey.." "..side.." "..tostring(target.titleName).."  "..tostring(target.alive).."%  X"..tostring(target.priority).."\n")
							tabIndex[Ckey] = target
						end
					end

					return tabIndex
				end

				-- Fonction pour afficher les cibles de type CSAR (pilotes éjectés)
				local function showCSARTargets(targetlist, side)
					print("\n--- Select the pilot to be rescued, who has fallen into the "..DCS_ENI_Side[side].." side  ---")
					local tabIndex = {}
					local Ckey = 0

					for key, target in ipairs(targetlist[side]) do
						if target.inactive ~= true and target.ATO and target.task == "CSAR" and target.type == "Ejected Pilot" then
							Ckey = key
							io.write(Ckey.." "..side.." "..tostring(target.titleName).."\n")
							tabIndex[Ckey] = target
							
							for ejectPilotN, ejectPilot in ipairs(target.elements) do
								if ejectPilot.status == "EVAC_possible" then
									local txtSup = ""
									if ejectPilot.inTheEnemyCamp then txtSup = "in the enemy camp" end
									io.write("          - - - - >"..tostring(ejectPilot.MGRS_Chute_10KM).." : "..tostring(ejectPilot.name).." "..txtSup.."\n")
								end
							end
						end
					end

					return tabIndex
				end

				-- Fonction principale pour la sélection des cibles
				local function selectTarget(targetlist)
					local side = selectCamp()
					if not side then return end -- Quitter si l'utilisateur choisit "Exit"

					local missionChoice = selectMissionType()

					local tabIndex = {}
					if missionChoice == 1 then
						tabIndex = showStandardTargets(targetlist, side)
					elseif missionChoice == 2 then
						tabIndex = showCSARTargets(targetlist, side)
					else
						return selectTarget(targetlist) -- Retourner au choix du camp
					end

					if next(tabIndex) == nil then
						print("\nNo available targets for this selection.")
						return
					end

					-- Sélection de la cible spécifique
					local input
					repeat
						io.write("\nEnter target number: ")
						input = tonumber(io.stdin:read())
						if not input or not tabIndex[input] then
							print("\nInvalid entry. Please enter a valid target number.")
						end
					until input and tabIndex[input]

					local selectedTarget = tabIndex[input]
					Multi.Target = Multi.Target or {}
					Multi.Target[side] = selectedTarget.titleName

					print("\nSelected Target: "..selectedTarget.titleName)
				end

				-- Exécution de la sélection
				selectTarget(targetlist)

				io.write( "\n")
			end	--if choix1 == "t"  then


			--===================================================================================
			-- Ecran N 3 Selection nb of Flight
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
			-- Ecran N 4 Selection du type d'avion Multiplayer	
				local tabIndex = {}
				for i = 1 , Multi.NbGroup do
					local ExPlaneA = ""
					local stopLoop = false
					for nSide , oob_airSide in PairsByKeys(oob_air) do														--pour afficher l'exemple de selection du premier avion presente
						for m , unit in PairsByKeys(oob_airSide) do
							if Playable_m[unit.type] and unit.inactive ~= true and not stopLoop then
								ExPlaneA = unit.type
								stopLoop = true
							end
						end
					end

					print("Choose your aircraft type for Flight n°"..i)
					print("(number of aircraft) (type of aircraft) (type of mission)")
					print("example for (4 "..ExPlaneA..": Escort): 4ae or 4AE")

					if not Multi.Group then Multi.Group= {} end
					if not Multi.Group[i] then Multi.Group[i]= {} end

					local playable_type = {}
					local seen = {}
					local tasks = {}
				local ti = 65 																						--char(65) == a
				local tabTaskAvailable = {}

				-- parse toutes les unites et rempli le tab tabTaskAvailable pour etre sur de proposer toutes les task propos� active 
				for nSide , oob_airSide in PairsByKeys(oob_air) do
					print() print(nSide..":")
					for m , unit in PairsByKeys(oob_airSide) do
						if Playable_m[unit.type]  and unit.inactive ~= true then
							for taskStr , nbool in PairsByKeys(oob_air[nSide][m].tasks) do
								taskStr = tostring(taskStr)

								if not tabTaskAvailable[nSide] then tabTaskAvailable[nSide] = {} end
								if not tabTaskAvailable[nSide][unit.type] then tabTaskAvailable[nSide][unit.type] = {} end
								if not tabTaskAvailable[nSide][unit.type][taskStr] then tabTaskAvailable[nSide][unit.type][taskStr] = nbool end
								if nbool == true then	tabTaskAvailable[nSide][unit.type][taskStr] = true	end
							end
						end
					end
				end

								-- display le tableau des choix d'avion et de task
				local tabBug = {}

				for nSide , unit_type in PairsByKeys(tabTaskAvailable) do
					print() print(nSide..":")
					for unitType , TabType in PairsByKeys(unit_type) do

						local IndexStringType = string.lower(string.char(ti))
						if not playable_type[IndexStringType] then playable_type[IndexStringType] = {} end
						playable_type[IndexStringType]["type"] = unitType
						playable_type[IndexStringType]["side"] = nSide

						io.write(" (1 to 8): ("..IndexStringType.."): "..unitType..":")

						for taskStr , nbool in PairsByKeys(TabType) do

							if TabTask[taskStr] and nbool == true then
								io.write( " ("..TabTask[taskStr]..")"..taskStr.."")
								-- local FstLetTask = string.lower(string.sub (taskStr, 1, 1))
								tabIndex[tostring(1)..IndexStringType..TabTask[taskStr]] = true
								tabIndex[tostring(2)..IndexStringType..TabTask[taskStr]] = true
								tabIndex[tostring(3)..IndexStringType..TabTask[taskStr]] = true
								tabIndex[tostring(4)..IndexStringType..TabTask[taskStr]] = true
								tabIndex[tostring(5)..IndexStringType..TabTask[taskStr]] = true
								tabIndex[tostring(6)..IndexStringType..TabTask[taskStr]] = true
								tabIndex[tostring(7)..IndexStringType..TabTask[taskStr]] = true
								tabIndex[tostring(8)..IndexStringType..TabTask[taskStr]] = true

							elseif not TabTask[taskStr] and not string.lower(taskStr) == "spotter" then
								table.insert(tabBug,taskStr )
							end
						end
						io.write("\n")
						ti = ti+1
					end
				end

				-- -- display le tableau des choix d'avion et de task
				-- --tabTaskAvailable[nSide][unit.type][taskStr]
				-- for nSide , unit_type in PairsByKeys(tabTaskAvailable) do
				-- 	print() print(nSide..":")
				-- 	for unitType , TabType in PairsByKeys(unit_type) do

				-- 		local IndexStringType = string.lower(string.char(ti))
				-- 		if not playable_type[IndexStringType] then playable_type[IndexStringType] = {} end
				-- 		playable_type[IndexStringType]["type"] = unitType
				-- 		playable_type[IndexStringType]["side"] = nSide

				-- 		io.write(" (1 to 8): ("..IndexStringType.."): "..unitType..":")

				-- 		for taskStr , nbool in PairsByKeys(TabType) do
				-- 			if   nbool == true then
				-- 				io.write( " ("..TabTask[taskStr]..")"..taskStr.."")
				-- 				local FstLetTask = string.lower(string.sub (taskStr, 1, 1))
				-- 				tabIndex[tostring(1)..IndexStringType..TabTask[taskStr]] = true
				-- 				tabIndex[tostring(2)..IndexStringType..TabTask[taskStr]] = true
				-- 				tabIndex[tostring(3)..IndexStringType..TabTask[taskStr]] = true
				-- 				tabIndex[tostring(4)..IndexStringType..TabTask[taskStr]] = true
				-- 				tabIndex[tostring(5)..IndexStringType..TabTask[taskStr]] = true
				-- 				tabIndex[tostring(6)..IndexStringType..TabTask[taskStr]] = true
				-- 				tabIndex[tostring(7)..IndexStringType..TabTask[taskStr]] = true
				-- 				tabIndex[tostring(8)..IndexStringType..TabTask[taskStr]] = true

				-- 			end
				-- 		end
				-- 		io.write("\n")
				-- 		ti = ti+1
				-- 	end
				-- end

				io.write( "\n")
			--===================================================================================
				-- Ecran N 5 Selection Nombre d'avion Multiplayer
					repeat
						input = string.lower(io.stdin:read())
						if  tabIndex[input] then
							if not Multi.Group[i] then Multi.Group[i]= {} end

							local inputNb = tonumber(string.sub (input, 1, 1))
							Multi.Group[i].NbPlane = inputNb

							local inputTyp = tostring(string.sub (input, 2, 2))
							Multi.Group[i].PlaneType = playable_type[inputTyp].type
							Multi.Group[i].side = playable_type[inputTyp].side

							local inputTsk = tostring(string.sub (input, 3, 4))
							Multi.Group[i].task = TabTask[inputTsk]

						else
							print("\nInvalid entry.\n")
						end
					until   tabIndex[input]

					io.write( "\n")

					--========================= affiche le choix du joueurs
					print(" -------------------------------------------------------> Building your different Flight: ")
					for k=1, i do
						print(" -------------------------------------------------------> "..Multi.Group[k].NbPlane.." "..Multi.Group[k].PlaneType.." ("..Multi.Group[k].side..")".." "..Multi.Group[k].task)
					end
					io.write( "\n")

				end
			--===================================================================================
				-- Ecran N 6 SinglePlayer

		elseif choix1 == "s" then
		  SinglePlayer = true

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

	--increase campaign mission number
	-- camp.mission = camp.mission + 1	

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
			if AcceptMission() then
				print("\nMultiplayerCampaign Next mission generated.\n")								--confirmation text
				 break
			end
		elseif SinglePlayer and PlayerFlight  then														--mission has a player flight
			if AcceptMission() then
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
			-- if Playability_criterium.active_unit == nil then
			-- 	print("Player unit is not active.\n\n")
			-- elseif Playability_criterium.base == nil then
			-- 	print("Player airbase is not operational.\n\n")
			-- elseif Playability_criterium.ready_aircraft == nil then
			-- 	print("Player unit has no ready aircraft.\n\n")
			-- elseif Playability_criterium.tot == nil then
			-- 	print("Player aircraft type cannot operate at this time of day.\n\n")
			-- elseif Playability_criterium.target == nil then
			-- 	print("No eligible mission available for player.\n\n")
			-- elseif Playability_criterium.target_firepower == nil then
			-- 	print("Not enough ready aircraft for this mission.\n\n")
			-- elseif Playability_criterium.weather == nil then
			-- 	print("Player aircraft type cannot operate in this weather.\n\n")
			-- elseif Playability_criterium.target_range == nil then
			-- 	print("No eligible mission available for player.\n\n")
			-- elseif Playability_criterium.coop == nil then
			-- 	print("Not enough ready aircraft for all clients.\n\n")
			-- elseif Multi.NbGroup and not PlayerFlight then
			-- 	print("Not enough ready aircraft for all clients.\n\n")
			-- elseif Playability_criterium.intercept == nil then
			-- 	print("Ground alert intercept duty without launch.\n\n")
			-- end
			
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
				elseif crit.key == "coop" and crit.value == nil then
					print("Not enough ready aircraft for all clients.\n\n")
				elseif crit.key == "intercept" and crit.value == nil then
					print("Ground alert intercept duty without launch.\n\n")
				end
			end
			if Multi.NbGroup and not PlayerFlight then
				print("Not enough ready aircraft for all clients..\n\n")
			end

		end
		if showVersion then
			print("0C1= = = = = = = = = = = = = = = = = = = = = = = "..camp.title.." ("..tostring(camp.version)..")= = = = = = = = = = = = = = = =")
			print("= = = = = = = = = = = = = Script Version : "..tostring(showVersion).." = = Lua Version : "..tostring(_VERSION))
			print("= = = = = = = = = = = = = Player Plane : "..tostring(playerInfo.planeBAT).." Unit: "..tostring(playerInfo.squadBAT).." Country: "..tostring(playerInfo.countryBAT))
			print()

		else
			print("= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =")
		end


		if Debug.debug and Debug.AfficheFlight then
			print("DCE debug")  os.execute 'pause'
		end

	until 1 == 2																					--repeat until the next mission is ready (has a player flight)
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
end

os.exit()