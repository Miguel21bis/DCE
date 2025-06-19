--To manually generate the first campaign mission and reset the campaign to initial status. For manual use by campaign designer only, not required for normal campaign play.
--Initiated by FirstMission.bat
------------------------------------------------------------------------------------------------------- 
-- last modification: M85_a
if not versionDCE then versionDCE = {} end
versionDCE["BAT_FirstMission.lua"] = "1.14.100"
-------------------------------------------------------------------------------------------------------
-- adjustment_p				(p tools)(o full targetList)(n targetList numeric)(m BAT)(l Playable_m from Data_divers)(k BugList)(j PairsByKeys)(i global TabTask)(h Firstmission_flag)(g mise a niveau)(d: use io.stdin:read)(c: fire Playable_m from conf_mod)(b: robust form)
-- cleancode_d				(d springCleaning)
-- modification M85_a		new variables added to conf_mod (RepairOption, current_date, weather, etc.)
-- modification M80_a		use various tables, such as base name or aircraft type aliases
-- modification M61_c		SAR (c DEV creation fichier cercle commande: w3)
-- modification M55_a		player can change the type of plane
-- modification M47_c		keeps the history of the campaign files (c: save debugging information during mission generation)
-- modification M46_d		singlePlayer with dedicated server (c: DF choice)(c: D choice with AI AirSpawn)
-- modification M40_f		Template Active GroundGroup moving front (f: sideBase)
-- modification M38_n		helps to balance the game (n: delete Ngroug)
-- modification M35_e		version ScriptsMod + camp (e: ScriptsMod_version from UTIL_Changelog)
-- modification M14			Versionning
-- modification M11A_b_l	Multiplayer (bl MP overRide) (gh %target alive)(x: only active Target)(q: displays all tasks of several squadrons)(p: Task table)
-------------------------------------------------------------------------------------------------------


BugList = {}
Firstmission_flag = true
Playable_m = {}
SinglePlayer = false
MissionInstance = 0

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

-- random seed -----
local seed = os.time() -- Récupérer un timestamp en secondes
math.randomseed(seed)  -- Initialiser le générateur pseudo-aléatoire

if VersionPackageICM == nil then
	VersionPackageICM = os.getenv('VersionPackageICM')														-- modification M35.b version ScriptsMod
end

dofile("Init/conf_mod.lua")
dofile("Init/camp_init.lua")

if mission_ini.current_date and mission_ini.current_date.year then
	camp.date = mission_ini.current_date
end

if ChangePlane then
	require("Active/oob_air")
else
	require("Init/oob_air_init")
end

dofile("Init/db_airbases.lua")
-- dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_Data.lua")
-- dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_DataMap.lua")
dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_Functions.lua")
dofile("Init/targetlist_init.lua")--ne pas supprimé, util pour inscrire targetlist dans Active
if not targetlist.blue[1] then
	TargetlistToNum(targetlist)
end

dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_ResetCampaign.lua")					--reset campaign status files. Required for first mission to generate according to initial status	


--***********NEW function***************--
LoadFileAndUpdate()
--***********NEW function***************--

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
	print("0A0= = = = = = = = = = = = = = = = = = = = = = = "..camp.title.." ("..tostring(camp.version)..")= = = = = = = = = = = = = = = =")
	print("= = = = = = = = = = = = = Script Version : "..tostring(showVersion).." = = Lua Version : "..tostring(_VERSION))
	print("= = = = = = = = = = = = = Player Plane : "..tostring(playerInfo.planeBAT).." Unit: "..tostring(playerInfo.squadBAT).." Country: "..tostring(playerInfo.countryBAT))
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
		end

		choix1 = string.lower(choix1)
		
		if choix1 == "n" or  choix1 == "t"  then
			if choix1 == "t"  then
				--===================================================================================
				-- Ecran N°2 Selection du Target	
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
				local ti = 65 																						--char(65) == a
				local tabTaskAvailable = {}

				-- parse toutes les unités et rempli le tab tabTaskAvailable pour etre sur de proposer toutes les task proposé active 
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
				for nSide , unit_type in PairsByKeys(tabTaskAvailable) do
					-- print() print(nSide..":")
					for unitType , tabType in PairsByKeys(unit_type) do
						-- print("BatFM unitType "..tostring(unitType))
						local IndexStringType = string.lower(string.char(ti))
						if not playable_type[IndexStringType] then playable_type[IndexStringType] = {} end
						playable_type[IndexStringType]["type"] = unitType
						playable_type[IndexStringType]["side"] = nSide

						io.write(" (1 to 8): ("..IndexStringType.."): "..unitType..":")

						for taskStr , nbool in PairsByKeys(tabType) do
							-- print("BatFM taskStr "..tostring(taskStr))
							-- print("BatFM TabTask[taskStr] "..tostring(TabTask[taskStr]))
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

		--M55_a		player can change the type of plane
		elseif choix1 == "c" then
			dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_ChangePlane.lua")

		elseif choix1 == "o" then

			local tabIndexTools = {
				["a"] = true,
				["b"] = true,
				["c"] = true,
				["d"] = true,
			}
			-- Ecran N°3 Selection nb of Flight
			repeat
				print("Tools menu: \n")
				print("Select :\n"..
				"A: DelGroup  \n"..
				"B: fuelConsumption \n"..
				"C: KillTarget \n"..
				"D: help balance Power \n"
				)

				local choix2 = string.lower(io.stdin:read())

				if tabIndexTools[choix2] then
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
			until tabIndexTools[choix2]

			--killTarget doit etre lancé plus tard par MAIN_NextMission.lua
			if ArgTools ~= "KillTarget" then
				dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_Divers.lua")
				os.execute 'pause'
			end
			break
		elseif choix1 == "w3" then
			dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_TestCercle.lua")
			os.execute 'pause'																					--pause command window for user to read text
			os.exit()
		end
	until tabIndex01[choix1]

	-- dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_ResetCampaign.lua")					--reset campaign status files. Required for first mission to generate according to initial status	

	print("\n\n")
	repeat
		print("Generating First Mission.\n")

		MissionInstance = MissionInstance + 1															--count the number of times the mission is generated
		dofile("../../../ScriptsMod."..VersionPackageICM.."/MAIN_NextMission.lua")						--generate mission

		if Multi.NbGroup >= 1 and PlayerFlight then
			if acceptMission() then
				 print("\nMultiplayerCampaign Next mission generated.\n")								--confirmation text
				 break
			end
		elseif SinglePlayer and PlayerFlight  then														--mission has a player flight
			if acceptMission() then
				 print("\nCampaign reset and first campaign mission re-generated.\n")					--confirmation text
				 break
			end
		elseif StopBug then																				--mission has a player flight
			print("\n\n StopBug .\n")																	--confirmation text
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
			-- elseif Playability_criterium.coop == nil then
				-- print("Not enough ready aircraft for all clients.\n\n")
			elseif Multi.NbGroup and not PlayerFlight then
				print("Not enough ready aircraft for all clients..\n\n")
			elseif Playability_criterium.intercept == nil then
				print("Ground alert intercept duty without launch.\n\n")
			end
		end

		if showVersion  then
			print("0A1= = = = = = = = = = = = = = = = = = = = = = = "..camp.title.." ("..tostring(camp.version)..")= = = = = = = = = = = = = = = =")
			print("= = = = = = = = = = = = = Script Version : "..tostring(showVersion).." = = Lua Version : "..tostring(_VERSION))
			print("= = = = = = = = = = = = = Player Plane : "..tostring(playerInfo.planeBAT).." Unit: "..tostring(playerInfo.squadBAT).." Country: "..tostring(playerInfo.countryBAT))
			print()
		else
			print("= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =")
		end

	until 1 == 2

	break

until 1 == 2

os.execute 'pause'																					--pause command window for user to read text
os.exit()