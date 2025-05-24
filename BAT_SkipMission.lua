--To manually re-generate and replace the current campaign mission. For contingency only, not required for normal campaign play.
--Initiated by RedoMission.bat
------------------------------------------------------------------------------------------------------- 
-- last modification: M85_a
if not versionDCE then versionDCE = {} end
versionDCE["BAT_SkipMission.lua"] = "1.15.99"
-------------------------------------------------------------------------------------------------------
-- adjustment_o				(o tools)(n targetList numeric)(m BAT)(l Playable_m from Data_divers)(k BugList)(j PairsByKeys)(i global TabTask)(h Skipmission_flag)(g mise a niveau)(e: use io.stdin:read)(c: fire Playable_m from conf_mod)(b: robust form) 
-- debug_d					(cd: EndMission)
-- cleancode_d				(d springCleaning)
-- modification M85_a		new variables added to conf_mod (RepairOption, current_date, weather, etc.)
-- modification M80_a		use various tables, such as base name or aircraft type aliases
-- modification M61_a		SAR
-- modification M55_a		player can change the type of plane
-- modification M47_d		keeps the history of the campaign files (d: debug) (c: save debugging information during mission generation)
-- modification M46_d		singlePlayer with dedicated server (c: DF choice)(c: D choice with AI AirSpawn)
-- modification M40_f		Template Active GroundGroup moving front (f: sideBase, move db_airbase to Actice folder)
-- modification M38_n		Check and Help CampaignMaker (n: delete Ngroug)(h: KillTarget step by step)
-- modification M35_e		version ScriptsMod + camp (e: ScriptsMod_version from UTIL_Changelog)
-- modification M14			Versionning
-- modification M11A_b_l	Multiplayer (bl MP overRide)(g %target alive)(y: force same package)(x: only active Target)(t:display name )(s: T choice bug)(r: targets already destroyed)(q: displays all tasks of several squadrons)
-------------------------------------------------------------------------------------------------------

BugList = {}
Skipmission_flag = true
Playable_m = {}

local function acceptMission()
	local m = ""
	repeat
		print("\n\n Night or Day ? : "..Daytime)													-- info day or not
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
versionPackageICM = os.getenv('versionPackageICM')														-- modification M35.b version ScriptsMod

dofile("Init/conf_mod.lua")
dofile("Active/camp_status.lua")
dofile("../../../ScriptsMod."..versionPackageICM.."/UTIL_Functions.lua")

if mission_ini.current_date and mission_ini.current_date.year then


	local jumpDate
	local jumpTime = false
	if camp.date.day ~= mission_ini.current_date.day or camp.date.month ~= mission_ini.current_date.month or camp.date.year ~= mission_ini.current_date.year then
		jumpDate = Deepcopy(camp.date)
		jumpTime = true
	end

	camp.date = mission_ini.current_date

	local aliasInitYear = camp.dateInit.year
	if aliasInitYear < 1970 then
		aliasInitYear = 1970
	end

	local aliasYear = camp.date.year
	if aliasYear < 1970 then
		aliasYear = 1970
	end

	--calcul le temps de la campagne
	local referenceTime = os.time{day=camp.dateInit.day, year=aliasInitYear, month=camp.dateInit.month}
	local actualTime = os.time{day=camp.date.day, year=aliasYear, month=camp.date.month} + camp.time
	CampTotalTimeS = os.difftime(actualTime, referenceTime) --/ (24 * 60 * 60) -- seconds in a day

	-- if camp.missionHistory and camp.missionHistory[camp.mission] then
	if jumpTime then

		local aliasJumpYear = jumpDate.year
		if aliasJumpYear < 1970 then
			aliasJumpYear = 1970
		end

		aliasYear = camp.date.year
		if aliasYear < 1970 then
			aliasYear = 1970
		end

		-- detecte s'il y a un saut temporel (changement de la date dans conf_mod)
		referenceTime = os.time{day=jumpDate.day, year=aliasJumpYear, month=jumpDate.month}
		actualTime = os.time{day=camp.date.day, year=aliasYear, month=camp.date.month} + camp.time
		local diffTime = os.difftime(actualTime, referenceTime) --/ (24 * 60 * 60) -- seconds in a day

		if diffTime > mission_ini.mission_duration + mission_ini.idle_time_max then
			camp.timeJump = true
		end
	end
end

if not ChangePlane then
	require("Active/oob_air")
end
dofile("../../../ScriptsMod."..versionPackageICM.."/UTIL_Data.lua")
dofile("../../../ScriptsMod."..versionPackageICM.."/UTIL_DataMap.lua")


--****************************************************************************************
--ajout automatique d'elements en cours de campagne: START
--****************************************************************************************
--********************************* targetlist ******************************************************
dofile("Init/targetlist_init.lua")
local targetlist_init = Deepcopy(targetlist)
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

dofile("Active/camp_triggers.lua")

-- Comparer les deux tables
changes = CompareTableNumeric(camp_triggers_init, camp_triggers)

-- Afficher les résultats
for _, added in ipairs(changes.added) do
	print("Added triggers: Name:", added.name)
end
for _, removed in ipairs(changes.removed) do
	print("Removed triggers: Name:", removed.name)
end

-- Ajouter les éléments manquants dans camp_triggers
for _, added in ipairs(changes.added) do
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
for _, removed in ipairs(changes.removed) do
    print("\nRemoved db_airbases: Name:", removed.name)
end

-- Ajouter les éléments manquants dans db_airbases
for _, added in ipairs(changes.added) do
    db_airbases[added.name] = added.data
end
-- Supprimer les éléments retirés de db_airbases
for _, removed in ipairs(changes.removed) do
    db_airbases[removed.name] = nil
end

--****************************************************************************************
--ajout automatique d'elements en cours de campagne: FIN
--****************************************************************************************


		
-- Exécution du fichier s'il existe
local testFile = "Init/various_table.lua"
if FileExists(testFile) then
    dofile(testFile)
end

for planeType, value in PairsByKeys(Data_divers) do
	if value.playable then
		Playable_m[planeType] = true
	end
end



--si le joueur fait un saut temporel (via date dans conf_mod) on met a jour les fichiers de la campagne
UpdateFilesAfterTimeJump()

local showVersion = versionPackageICM

local verScriptsModPath = "../../../ScriptsMod."..versionPackageICM.."/UTIL_Changelog.lua"
local testPath = io.open(verScriptsModPath, "r")
if testPath ~= nil then
	io.close(testPath)
	dofile("../../../ScriptsMod."..versionPackageICM.."/UTIL_Changelog.lua")
	if versionDCE then
		showVersion = showVersion.." ("..versionDCE["UTIL_Changelog.lua"]..")"
	elseif VersionDCE then
		showVersion = showVersion.." ("..versionDCE["UTIL_Changelog.txt"]..")"
	end
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


if versionPackageICM then
	print("0B0= = = = = = = = = = = = = = = = = = = = = = = "..camp.title.." ("..tostring(camp.version)..")= = = = = = = = = = = = = = = =")
	print("= = = = = = = = = = = = = Script Version : "..tostring(showVersion).." = = Lua Version : "..tostring(_VERSION))
	print("= = = = = = = = = = = = = Player Plane : "..tostring(playerInfo.planeBAT).." Unit: "..tostring(playerInfo.squadBAT).." Country: "..tostring(playerInfo.countryBAT))
	print()

else
	print("= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =")
end
	--===================================================================================
	-- Ecran N°0 Choix next campaign mission
local input
local choix1

if not ChangePlane then
	print("Actual time: " .. FormatTime(camp.time, "hh:mm") .. ", " .. camp.date.day .. "." .. camp.date.month .. "." .. camp.date.year .. ".\n")
	print("Skip current mission and generate next campaign mission. Continue? y(es)/n(o):\n")

	SinglePlayer = false
	if Multi == nil then
		Multi =
		{
			NbGroup = 0,
		}
	end

	repeat
		input = string.lower(io.stdin:read())
		if input == "y" or input == "yes" or input == "n" or input == "no" then
			break
		else
			print("\n\nInvalid entry. Respond with y(es) or n(o):\n")
		end
	until input == "y" or input == "yes" or input == "n" or input == "no"
else
	input = "y"
end

if input == "y" or input == "yes" then

	repeat
		--===================================================================================
		-- Ecran N°1 Choix entre Single ou Multiplayer

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

			print("Select :\n"..
				"S (S)ingleplayer  \n"..
				"D Singleplayer with (D)edicated Server \n"..
				"DF Singleplayer with (D)edicated Server, (F)ull plane on Deck \n"..
				"\n"..
				"C (C)hange type of plane\n"..
				"\n"..
				"T Multiplayer by choice of (T)arget \n"..
				"N multiplayer by choice of (N)ATO".."\n"..
				"\n"..
				"O t(o)ols (tools for CampaignMaker and Coder)"
			)

			choix1 = io.stdin:read()
			choix1 = string.lower(choix1)

			if choix1 == "n" or  choix1 == "t"  then
				if choix1 == "t"  then


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
						print("\n--- Sélectionnez une cible dans le camp "..side.." ---")
						
						-- Trier la table par priorité
						table.sort(targetlist[side], function(a, b)
							return a.priority > b.priority
						end)

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
							if target.inactive ~= true and target.ATO 
							and target.task == "CSAR" and target.type == "Ejected Pilot"
							then
								Ckey = key
								io.write(Ckey.." "..side.." "..tostring(target.titleName).."  "..tostring(target.alive).."%  X"..tostring(target.priority).."\n")
								tabIndex[Ckey] = target
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
			-- Ecran N°3 Selection nb of Flight
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

				-- parse toutes les unités et rempli le tab tabTaskAvailable pour etre sur de proposer toutes les task proposé active 
				for nSide , oob_airSide in PairsByKeys(oob_air) do
					print() print(nSide..":")
					for m , unit in PairsByKeys(oob_airSide) do
						if Playable_m[unit.type] and unit.inactive ~= true then
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
								local FstLetTask = string.lower(string.sub (taskStr, 1, 1))
								tabIndex[tostring(1)..IndexStringType..TabTask[taskStr]] = true
								tabIndex[tostring(2)..IndexStringType..TabTask[taskStr]] = true
								tabIndex[tostring(3)..IndexStringType..TabTask[taskStr]] = true
								tabIndex[tostring(4)..IndexStringType..TabTask[taskStr]] = true
								tabIndex[tostring(5)..IndexStringType..TabTask[taskStr]] = true
								tabIndex[tostring(6)..IndexStringType..TabTask[taskStr]] = true
								tabIndex[tostring(7)..IndexStringType..TabTask[taskStr]] = true
								tabIndex[tostring(8)..IndexStringType..TabTask[taskStr]] = true
							
							elseif not TabTask[taskStr] then
								table.insert(tabBug,taskStr )
							end
						end
						io.write("\n")
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
				-- Ecran N°6 SinglePlayer

			elseif choix1 == "s" then
			  SinglePlayer = true

			elseif choix1 == "d" then
			  SinglePlayer = true
			  SingleWithDServer = true
			  SingleWithDServerAiAir = true

			elseif choix1 == "df" then
			  SinglePlayer = true
			  SingleWithDServer = true

			-- -- modification M38.e Check and helps CampaignMaker
			-- elseif choix1 == "w" then
			-- 	UTIL_KillTarget = true
			elseif choix1 == "o" then

				-- Ecran N°3 Selection nb of Flight
				repeat
					print("Tools menu: \n")
					print("Select :\n"..
					"A: DelGroup  \n"..
					"B: fuelConsumption \n"..
					"C: KillTarget \n"
					)
	
					local choix2 = string.lower(io.stdin:read())
	
					if (choix2 == "a" or choix2 == "b" or choix2 == "c") then
						if choix2 == "a" then
							ArgTools = "DelGroup"
						elseif choix2 == "b" then
							ArgTools = "fuelConsumption"
						elseif choix2 == "c" then
							ArgTools = "KillTarget"
						elseif choix2 == "d" then
							ArgTools = "helpBalancePower"
						end
					else
						print("\nInvalid entry.\n")
					end
				until (choix2 == "a" or  choix2 == "b" or choix2 == "c")

				-- print("ArgTools "..tostring(ArgTools))
	
				if ArgTools ~= "KillTarget" then
					dofile("../../../ScriptsMod."..versionPackageICM.."/UTIL_Divers.lua")
					os.execute 'pause'
				end

				break
			elseif choix1 == "c" then
				dofile("../../../ScriptsMod."..versionPackageICM.."/UTIL_ChangePlane.lua")
			end

		until tabIndex01[choix1]

		MissionInstance = 0
		print("\n\n")
		repeat
			print("Generating Next Mission.\n")

			MissionInstance = MissionInstance + 1															--count the number of times the mission is generated

			camp.versionPackageICM = tostring(versionPackageICM)											-- modification M35 version ScriptsMod -- ajoute la version du script dans camp_status pour utilisation en fin de mission																				--set amount of players
			dofile("../../../ScriptsMod."..versionPackageICM.."/MAIN_NextMission.lua")																--generate mission


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
					print("\nMultiplayerCampaign Next mission generated.\n")								--confirmation text
					break
				else
					print("\nDebug A: AcceptMission() .\n")	
				end
			elseif SinglePlayer and PlayerFlight  then														--mission has a player flight
				if acceptMission() then
					print("\nNext mission generated.\n")													--confirmation text
					break
				else
					print("\nDebug B: AcceptMission() .\n")	
				end
			elseif StopBug then																			--mission has a player flight
				print("\n\n StopBug .\n")																--confirmation text
				break
			elseif MissionInstance == 20 then																--no player flight could be assigned in 20 tries, stop it
				print("Mission Generation Error. No eligible player flight in 20 attempts. Try again.\n\n")
				break
			else																							--no player flight could be assigned, advance time and try again
				if Playability_criterium.active_unit == nil then
					print("Player unit is not active.\n\n")
				elseif Playability_criterium.base == nil then
					print("Player airbase is not operational.\n\n")
				elseif Playability_criterium.ready_aircraft == nil then
					print("Player unit has no ready aircraft.\n\n")
				elseif Playability_criterium.tot == nil then
					print("Player aircraft type cannot operate at this time of day.\n\n")
				elseif Playability_criterium.target == nil then
					print("No eligible mission available for player.\n\n")
				elseif Playability_criterium.target_firepower == nil then
					print("Not enough ready aircraft for this mission.\n\n")
				elseif Playability_criterium.weather == nil then
					print("Player aircraft type cannot operate in this weather.\n\n")
				elseif Playability_criterium.target_range == nil then
					print("No eligible mission available for player.\n\n")
				elseif Playability_criterium.coop == nil then
					print("Not enough ready aircraft for all clients.\n\n")
				elseif Multi.NbGroup and not PlayerFlight then
					print("Not enough ready aircraft for all clients.\n\n")
				elseif Playability_criterium.intercept == nil then
					print("Ground alert intercept duty without launch.\n\n")
				else
					print("\nDebug C: Playability_criterium .\n")
					_affiche(Playability_criterium, "Playability_criterium")
				end
			end

			if showVersion  then
				print("0B1= = = = = = = = = = = = = = = = = = = = = = = "..camp.title.." ("..tostring(camp.version)..")= = = = = = = = = = = = = = = =")
				print("= = = = = = = = = = = = = Script Version : "..tostring(showVersion).." = = Lua Version : "..tostring(_VERSION))
				print("= = = = = = = = = = = = = Player Plane : "..tostring(playerInfo.planeBAT).." Unit: "..tostring(playerInfo.squadBAT).." Country: "..tostring(playerInfo.countryBAT))
				print()
			else
				print("= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =")
			end

		until 1 == 2

		break

	until 1 == 2

end
os.execute 'pause'																					--pause command window for user to read text
os.exit()