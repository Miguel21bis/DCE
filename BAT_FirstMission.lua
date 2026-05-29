--To manually generate the first campaign mission and reset the campaign to initial status. For manual use by campaign designer only, not required for normal campaign play.
--Initiated by FirstMission.bat
------------------------------------------------------------------------------------------------------- 
if not versionDCE then versionDCE = {} end
versionDCE["BAT_FirstMission.lua"] = "2.16.102"
-------------------------------------------------------------------------------------------------------

BugList = BugList or {}
Firstmission_flag = true
Playable_m = {}
SinglePlayer = false
MissionInstance = 0
Briefing_text = ""
PlayerSide = nil


Multi =
{
	NbGroup = 0,
}


mission = {}					--pour declarer la table globale et calmer les inquietudes d'IDE ^^
oob_air = {}					--pour declarer la table globale et calmer les inquietudes d'IDE ^^


local function acceptMission()
	local m = ""
	repeat
		print("\n\n Night or Day ? : "..Daytime)													-- info day or not
		print("\n\nAccept Mission ?:")

		print("a".." - Accept mission")
		print("s".." - Skip mission")

		-- m = tostring(io.read())
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


-- -- Construit une chaine compacte des tasks disponibles
-- local function buildTaskList(tasks)

-- 	local result = {}

-- 	for _, taskStr in PairsByKeys(tasks) do

-- 		if TabTask[taskStr] then
-- 			result[#result + 1] = taskToShort(taskStr)
-- 		end
-- 	end

-- 	return table.concat(result, " ")
-- end

-- random seed -----
local seed = os.time() -- Récupérer un timestamp en secondes
math.randomseed(seed)  -- Initialiser le générateur pseudo-aléatoire

if VersionPackageICM == nil then
	VersionPackageICM = os.getenv('VersionPackageICM')														-- modification M35.b version ScriptsMod
end

dofile("Init/conf_mod.lua")
dofile("Init/camp_init.lua")

if mission_ini.current_date and mission_ini.current_date.year and mission_ini.e then
	camp.date = mission_ini.current_date
	mission_ini.current_date.setDateInNextMission =false
end

if ChangePlane then
	require("Active/oob_air")
else
	require("Init/oob_air_init")
end

dofile("Init/db_airbases.lua")
dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_Functions.lua")
dofile("Init/targetlist_init.lua")--ne pas supprimé, util pour inscrire targetlist dans Active
if not targetlist.blue[1] then
	TargetlistToNum(targetlist)
end

dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_ResetCampaign.lua")					--reset campaign status files. Required for first mission to generate according to initial status	

--affiche le type d'avion selectionné et son squadrons
local playerInfo = {
	planeBAT = "",
	squadBAT = "",
	countryBAT = "",
	sideBAT = "",
}

-- playerSide = ""
local n_player = 0
for side, squadTL in PairsByKeys(oob_air) do
	for squad_n, squad in PairsByKeys(squadTL) do
		if squad.player then
			playerInfo.planeBAT = squad.type
			playerInfo.squadBAT = squad.name
			playerInfo.baseBAT = squad.base
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

--***********NEW function***************--
--***********NEW function***************--
LoadFileAndUpdate("BAT_FirstMission "..debug.getinfo(1).currentline)
--***********NEW function***************--
--***********NEW function***************--

ResetUnitClient()
ResetBaseHumain()

-- Exécution du fichier s'il existe
local testFile = "Init/various_table.lua"
if FileExists(testFile) then
    dofile(testFile)
end


if not targetlist.blue[1] then
	TargetlistToNum(targetlist)
end

for planeType, value in PairsByKeys(Data_divers) do
	if value.playable then
		Playable_m[planeType] = true
	end
end



local showVersion = VersionPackageICM

local verScriptsModPath = "../../../ScriptsMod."..VersionPackageICM.."/UTIL_Changelog.lua"
local testPath = io.open(verScriptsModPath, "r")
if  testPath ~= nil then
	io.close(testPath)
	dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_Changelog.lua")
	if versionDCE then
		showVersion = showVersion.." ("..versionDCE["UTIL_Changelog.lua"]..")"
	elseif VersionDCE then
		showVersion = showVersion.." ("..versionDCE["UTIL_Changelog.txt"]..")"
	end
end




if VersionPackageICM then
	-- print("0A0= = = = = = = = = = = = = = = = = = = = = = = "..camp.title.." ("..tostring(camp.version)..")= = = = = = = = = = = = = = = =")
	-- print("= = = = = = = = = = = = = Script Version : "..tostring(showVersion).." = = Lua Version : "..tostring(_VERSION))
	-- print("= = = = = = = = = = = = = Player Plane : "..tostring(playerInfo.planeBAT).." Unit: "..tostring(playerInfo.squadBAT).." Country: "..tostring(playerInfo.countryBAT))
	-- print("= = = = = = = = = = = = = Debug Mod? : "..tostring(Debug.debug))
	-- print()

	print("==============================================================")
	print(" DCE CAMPAIGN GENERATOR")
	print(" "..tostring(camp.title).."   |   "..tostring(camp.version))
	print("==============================================================")
	print()
	print(" Script : "..tostring(showVersion))
	-- print(" Lua    : "..tostring(_VERSION))
	print()
	print(" Player Aircraft : "..tostring(playerInfo.planeBAT))
	print(" Squadron         : "..tostring(playerInfo.squadBAT))
	print(" Country          : "..tostring(playerInfo.countryBAT))
	print()
	print(" Debug Mode       : "..(Debug.debug and "ENABLED" or "DISABLED"))
	print("==============================================================")
	print()

else
	print("= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =")
end
	--===================================================================================
	-- Ecran N°0 Choix next mission
print("Reset the campaign and generate a new first mission.\n")

local input
local choix1

-- print("B.\n")
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


		-- ["y"] = true,
		["z"] = true,
		["o"] = true,
	}

	repeat
		
		if choix1 == nil then
			-- print("Select :\n"..
			-- 	"S (S)ingleplayer  \n"..
			-- 	-- "D Singleplayer with (D)edicated Server \n"..
			-- 	-- "DF Singleplayer with (D)edicated Server, (F)ull plane on Deck \n"..
			-- 	"\n"..
			-- 	"C (C)hange type of plane\n"..
			-- 	"\n"..
			-- 	"T Multiplayer by choice of (T)arget \n"..
			-- 	"N multiplayer by choice of (N)ATO".."\n"..
			-- 	"\n"..
			-- 	"O t(o)ols (tools for CampaignMaker and Coder)"
			-- )

			print("--------------------------------------------------------------")
			print(" Reset campaign and generate first mission")
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
		end

		
		-- choix1 = io.stdin:read()
		-- choix1 = string.lower(choix1)
		choix1 = string.lower(choix1 or "")

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

				
				print("choose a Single target")

				local tabIndex = {}
				for side, targetSide in pairs(targetlist) do
					local j = 1
					local Ckey = 0
					print() print(side..":")
					for key, target in ipairs(targetSide) do
						if target.inactive ~= true  and ( string.find(target.task, "Strike") or target.task == "Runway Attack" or target.task == "CSAR") then
							if side == "red" then
								Ckey = key + #targetlist["blue"]															--permet de n'afficher qu'un nombre continue pour les 2 camps
							else
								Ckey = key
							end
							io.write(  Ckey.." "..side.." "..tostring(target.titleName) .."  "..tostring(target.alive).." %  X"..tostring(target.priority).."\n")
							if not tabIndex[Ckey]  then tabIndex[Ckey] = {} end
							tabIndex[Ckey]["side"] = side
							j = j+1
						end
					end
				end

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

				print("Select your flight:")
				print("Format: [1-8 aircraft][ID][Task code]")
				print("Example: 4de = 4 aircraft, ID d, Escort mission")
				print()

				print("Task codes:")
				print("STR=Strike  ESC=Escort  CAP=CAP  INT=Intercept")
				print("FS=FighterSweep  SD=SEAD  ASH=AntiShip  RW=Runway")
				print("SAR=SAR  CSAR=CSAR")
				print()


				-- for nSide, units in PairsByKeys(tabTaskAvailable) do
				for nSide, units in pairs(tabTaskAvailable) do
					print() print(nSide..":")

					--sort units par la key units.type
					table.sort(units, function(a, b)
						return a.type < b.type
					end)


					print("ID Aircraft     Base                Squadron        Tasks")
					print("----------------------------------------------------------------")

					-- for unitName, unit in PairsByKeys(units) do
					for unitN, unit in ipairs(units) do

						local indexStringType = string.lower(string.char(ti))

						playable_type[indexStringType] = playable_type[indexStringType] or {}
						playable_type[indexStringType]["type"] = unit.type
						playable_type[indexStringType]["side"] = nSide
						playable_type[indexStringType]["base"] = unit.base
						playable_type[indexStringType]["unitName"] = unit.name

						-- io.write(" (1 to 8): ("..indexStringType.."): "..unit.type.." || "..AliasBaseName(unit.base).." || "..unit.name)

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

						-- 	-- elseif not TabTask[taskStr] and not string.lower(taskStr) == "spotter" then
						-- 	elseif not TabTask[taskStr] and string.lower(taskStr) ~= "spotter" then
						-- 		table.insert(tabBug,taskStr )
						-- 	end
						-- end
						-- io.write("\n")


						-- local shortTasks = buildTaskList(unit.tasks)
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
				repeat
					-- input = string.lower(io.stdin:read())
					input = string.lower(io.stdin:read() or "")
					if tabIndex[input] then

						Multi.Group[i] = Multi.Group[i] or {}

						Multi.Group[i].NbPlane = tonumber(string.sub (input, 1, 1))

						local inputTyp = tostring(string.sub (input, 2, 2))
						Multi.Group[i].PlaneType = playable_type[inputTyp].type
						Multi.Group[i].side = playable_type[inputTyp].side
						Multi.Group[i].base = playable_type[inputTyp].base
						Multi.Group[i].unitName = playable_type[inputTyp].unitName
						-- print("SetBaseClient TEST "..tostring(playable_type[inputTyp].unitName))
						local result = SetUnitClient(playable_type[inputTyp].unitName)
						if not result then print("SetUnitClient ECHEC || "..playable_type[inputTyp].unitName.." || "..AliasBaseName(tostring(playable_type[inputTyp].base))) end

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

		elseif choix1 == "s" then
			SinglePlayer = true

			local result = SetBaseHumain(playerInfo.baseBAT)
			if not result then 
				AddLog("BatFM ECHEC to set HumanBase " ..tostring(playerInfo.baseBAT))
			end

		-- elseif choix1 == "d" then
		--   SinglePlayer = true
		--   SingleWithDServer = true
		--   SingleWithDServerAiAir = true

		-- elseif choix1 == "df" then
		--   SinglePlayer = true
		--   SingleWithDServer = true

		--M55_a		player can change the type of plane
		elseif choix1 == "c" then
			dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_ChangePlane.lua")

		elseif choix1 == "o" then

			local tabIndexTools = {
				["a"] = true,
				["b"] = true,
				["c"] = true,
				["d"] = true,
				["e"] = true,
			}

			local choix2 = nil

			-- Ecran N°3 Selection nb of Flight
			repeat
				print("Tools menu: \n")
				print("Select :\n"..
				"A: DelGroup  \n"..
				"B: fuelConsumption \n"..
				"C: KillTarget \n"..
				"D: help balance Power \n"..
				"E: Icons on targetMission (PhotoMaton) \n" ..
				"\n"
				)

				-- local choix2 = string.lower(io.stdin:read())
				choix2 = string.lower(io.stdin:read() or "")

				if tabIndexTools[choix2] then
					if choix2 == "a" then
						ArgTools = "DelGroup"
					elseif choix2 == "b" then
						ArgTools = "fuelConsumption"
					elseif choix2 == "c" then
						ArgTools = "KillTarget"
					elseif choix2 == "d" then
                        ArgTools = "helpBalancePower"
					elseif choix2 == "e" then
						ArgTools = "missionWithIcone"
					end
				else
					print("\nInvalid entry.\n")
				end
			until tabIndexTools[choix2]

			--killTarget doit etre lancé plus tard par MAIN_NextMission.lua
			if ArgTools ~= "KillTarget" then
				dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_Divers.lua") os.execute 'pause'
			end
			break

		end
	until tabIndex01[choix1]

	print("\n\n")
	repeat
		print("Generating First Mission.\n")

		MissionInstance = MissionInstance + 1															--count the number of times the mission is generated
		dofile("../../../ScriptsMod."..VersionPackageICM.."/MAIN_NextMission.lua")						--generate mission

		if Multi.NbGroup >= 1 and PlayerFlight then
			if acceptMission() then
				BackupFilesMission() 
				print("\nMultiplayerCampaign Next mission generated.\n")								--confirmation text
				 break
			end
		elseif SinglePlayer and PlayerFlight  then														--mission has a player flight
			if acceptMission() then
				BackupFilesMission() 
				print("\nCampaign reset and first campaign mission re-generated.\n")					--confirmation text
				 break
			end
		elseif StopBug then																				--mission has a player flight
			print("\n\n StopBug .\n")																	--confirmation text
			break

		elseif MissionInstance >= 20 then																--no player flight could be assigned in 20 tries, stop it
			print("Mission Generation Error. No eligible player flight in 20 attempts. Try again.\n\n")
			break
		else																							--no player flight could be assigned, advance time and try again

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

				print("Mission generation failed:\n")
				print("ID  Aircraft     Base                Squadron        Tasks")
				print("----------------------------------------------------------------")
				if PlayerAssignFailure then

					for _, failData in pairs(PlayerAssignFailure) do

						local shortTasks = failData.generatedTasksShort or "---"

						local line =
							string.format(
								"%-3s %-12s %-19s %-15s %s",
								tostring(failData.id or "?"),
								tostring(failData.requestedPlane or "---"),
								tostring(failData.baseShort or "---"),
								tostring(failData.squadronShort or "---"),
								shortTasks
							)

						print(line)

						if failData.reason == "no_main_task_generated" then

							print(" -> Requested main task never generated.")

						elseif failData.reason == "task_filtered" then

							print(" -> Main task generated but filtered during Block A.")

						elseif failData.reason == "task_not_generated" then

							print(" -> Aircraft generated but requested task unavailable.")

						elseif failData.reason == "insufficient_aircraft" then

							print(
								" -> Generated "
								..tostring(failData.foundAircraft or 0)
								.." / "
								..tostring(failData.requestedNb or "?")
								.." aircraft."
							)

						elseif failData.reason == "no_aircraft_generated" then

							print(" -> No compatible aircraft generated.")

						end

						if failData.debugReason then
							print(" -> "..tostring(failData.debugReason))
						end

						print()
					end
				end
			end

			os.execute 'timeout /t 4'
			
		end

		if showVersion  then
			print("0A1= = = = = = = = = = = = = = = = = = = = = = = "..camp.title.." ("..tostring(camp.version)..")= = = = = = = = = = = = = = = =")
			print("= = = = = = = = = = = = = Script Version : "..tostring(showVersion).." = = Lua Version : "..tostring(_VERSION))
			print("= = = = = = = = = = = = = Player Plane : "..tostring(playerInfo.planeBAT).." Unit: "..tostring(playerInfo.squadBAT).." Country: "..tostring(playerInfo.countryBAT))
			print()
		else
			print("= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =")
		end

		if Debug.debug and not PlayerFlight then
			print("0C1 DCE debug")  
			_affiche(Playability_criterium)
			
			-- os.execute 'pause'
		end

	until 1 == 2

	break

until 1 == 2

os.execute 'pause'																					--pause command window for user to read text
os.exit()