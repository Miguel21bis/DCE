--To manually re-generate and replace the current campaign mission. For contingency only, not required for normal campaign play.
--Initiated by RedoMission.bat
------------------------------------------------------------------------------------------------------- 
-- last modification: springCleaning adjustment_o
if not versionDCE then versionDCE = {} end
versionDCE["BAT_SkipMission.lua"] = "1.14.98"
-------------------------------------------------------------------------------------------------------
-- adjustment_o				(o tools)(n targetList numeric)(m BAT)(l Playable_m from Data_divers)(k BugList)(j PairsByKeys)(i global TabTask)(h Skipmission_flag)(g mise a niveau)(e: use io.stdin:read)(c: fire Playable_m from conf_mod)(b: robust form) 
-- debug_d					(cd: EndMission)
-- cleancode_d				(d springCleaning)
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
DebuGenTxt = ""					--debug cumulutatif de ATO_Generator

local function AcceptMission()
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

if not ChangePlane then
	require("Active/oob_air")
end
dofile("../../../ScriptsMod."..versionPackageICM.."/UTIL_Data.lua")
dofile("../../../ScriptsMod."..versionPackageICM.."/UTIL_DataMap.lua")
dofile("../../../ScriptsMod."..versionPackageICM.."/UTIL_Functions.lua")
dofile("Active/targetlist.lua")


-- Exécution du fichier s'il existe
local testFile = "Init/various_table.lua"
if FileExists(testFile) then
    dofile(testFile)
end

local db_airbasesFile = "Active/db_airbases.lua"
local TestPath = io.open(db_airbasesFile, "r")																--cette maniere de chercer la presence d un fichier evite un plantage
if TestPath ~= nil then																					--check si le fichier existe dans ScriptsMod
	io.close(TestPath)
	dofile("Active/db_airbases.lua")
else
	local db_airbasesFile2 = "Init/db_airbases.lua"
	local TestPath2 = io.open(db_airbasesFile2, "r")
	if TestPath2 ~= nil then																			--check si le fichier exist dans le dossier campagne
		io.close(TestPath2)
		dofile(db_airbasesFile2)
		--creer le fichier db_airbases dans Active, meme en cours de campagne, pour garder la retrocompatibilite
		local airbases_Str = "db_airbases = " .. TableSerialization(db_airbases, 0)
		local trigFile = io.open("Active/db_airbases.lua", "w") or error("Failed to open Active/db_airbases.lua file")
		trigFile:write(airbases_Str)
		trigFile:close()
	end
end

if not targetlist.blue[1] then
	TargetlistToNum()
end

Playable_m = {}

for planeType, value in PairsByKeys(Data_divers) do
	if value.playable then
		Playable_m[planeType] = true
	end
end


local showVersion = versionPackageICM

local verScriptsModPath = "../../../ScriptsMod."..versionPackageICM.."/UTIL_Changelog.lua"
local TestPath = io.open(verScriptsModPath, "r")
if  TestPath ~= nil then
	io.close(TestPath)
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
	print("Skip current mission and generate next campaign mission. Continue? y(es)/n(o):\n")				--ask for user confirmation


	local playable_type = {}

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

					--[[
					--===================================================================================
					-- Ecran N°2 Selection du Target	
					print("choose a Single target")

					local tabIndex = {}
					-- for side, Targetlist in PairsByKeys(tableTargetlist) do
					for side, targetSide in pairs(targetlist) do
						-- local j = 1
						local Ckey = 0
						print() print(side..":")
						for key, target in ipairs(targetSide) do
							if target.inactive ~= true 
							and target.ATO 
							and ( string.find(target.task, "Strike") or target.task == "Runway Attack" or target.task == "CSAR")
							and target.type ~= "Ejected Pilot"
							then
								if side == "red" then
									Ckey = key + #targetlist["blue"]															--permet de n'afficher qu'un nombre continue pour les 2 camps
								else
									Ckey = key
								end
								io.write(  Ckey.." "..side.." "..tostring(target.titleName) .."  "..tostring(target.alive).." %  X"..tostring(target.priority).."\n")
								if not tabIndex[Ckey]  then tabIndex[Ckey] = {} end
								tabIndex[Ckey]["side"] = side
								-- j = j+1
							end
						end
						
						io.write(  " A: "..side.." All ejected pilots ".."\n")
						
					end


					input = io.stdin:read()

					if string.lower(input) == "a" then
						for side, targetSide in pairs(targetlist) do
							-- local j = 1
							local Ckey = 0
							print() print(side..":")
							for key, target in ipairs(targetSide) do
								if target.inactive ~= true 
								and target.ATO 
								and (  target.task == "CSAR")
								and target.type == "Ejected Pilot"
								then
									if side == "red" then
										Ckey = key + #targetlist["blue"]															--permet de n'afficher qu'un nombre continue pour les 2 camps
									else
										Ckey = key
									end
									io.write(  Ckey.." "..side.." "..tostring(target.titleName) .."  "..tostring(target.alive).." %  X"..tostring(target.priority).."\n")
									if not tabIndex[Ckey]  then tabIndex[Ckey] = {} end
									tabIndex[Ckey]["side"] = side
									-- j = j+1
								end
							end							
						end

					else

						repeat
						
							input = tonumber(io.stdin:read())
							
							if (input == nil or input == "") then input = 999 end
							if input >  #targetlist["blue"] then
								Ckey = input - #targetlist["blue"]
							else
								Ckey = input
							end
							if  tabIndex[input] then
								local side = tabIndex[input]["side"]
								if not Multi.Target then Multi.Target = {} end
								if not Multi.Target[side] then Multi.Target[side]= {} end
								Multi.Target[side] = targetlist[side][Ckey].titleName
								print("\n"..targetlist[side][Ckey].titleName.."\n")
							else
								print("\nInvalid entry.\n")
							end
						until  tabIndex[input]
					end



					io.write( "\n")
				end	--if choix1 == "t"  then
					]]--


				
					-- local tabIndex = {}

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
				--tabTaskAvailable[nSide][unit.type][taskStr]
				for nSide , unit_type in PairsByKeys(tabTaskAvailable) do
					print() print(nSide..":")
					for unitType , TabType in PairsByKeys(unit_type) do

						local IndexStringType = string.lower(string.char(ti))
						if not playable_type[IndexStringType] then playable_type[IndexStringType] = {} end
						playable_type[IndexStringType]["type"] = unitType
						playable_type[IndexStringType]["side"] = nSide

						io.write(" (1 to 8): ("..IndexStringType.."): "..unitType..":")

						for taskStr , nbool in PairsByKeys(TabType) do
							
							if nbool == true then
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

							end
						end
						io.write("\n")
						ti = ti+1
					end
				end

				io.write( "\n")
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
				if AcceptMission() then
					print("\nMultiplayerCampaign Next mission generated.\n")								--confirmation text
					break
				else
					print("\nDebug A: AcceptMission() .\n")	
				end
			elseif SinglePlayer and PlayerFlight  then														--mission has a player flight
				if AcceptMission() then
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