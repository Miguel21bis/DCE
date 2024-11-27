--To evaluate the DCS debrief.log, update the campaign status files/OOBs, generate a debriefing and initiate generation of next campaign mission
--Initiated by MissionEnd.lua running from within DCS
------------------------------------------------------------------------------------------------------- 
-- last modification:  M80_a
if not versionDCE then versionDCE = {} end
versionDCE["DEBRIEF_Master.lua"] = "1.16.121"
-------------------------------------------------------------------------------------------------------
-- adjustment_n				(n new targetlist)(m oob_scen ==0)(l AcceptedMission again)(k BugList)(j pairsByKeys)(i global TabTask)(g mise a niveau)(e: use io.stdin:read)(c: fire Playable_m from conf_mod)(b: robust form) 
-- debug_d	 				(cd: EndMission)
-- cleanCode_b
-- modification M80_a		use various tables, such as base name or aircraft type aliases
-- modification M61_a		SAR
-- modification M56_a		AssignCallnameSquad
-- modification M55_a		player can change the type of plane
-- modification M50_b		Records landings (b: add data file payload)
-- modification M48_a		Accept result mission
-- modification M47_c		keeps the history of the campaign files (c: save debugging information during mission generation)
-- modification M46_d		singlePlayer with dedicated server (c: DF choice)(c: D choice with AI AirSpawn)
-- modification M40_f		Template Active GroundGroup moving front (f: sideBase)
-- modification M38_x		Check and Help CampaignMaker
-- modification M35_f		version ScriptsMod + camp (f camp.version)(e: ScriptsMod_version from UTIL_Changelog)
-- modification M14			Versionning
-- modification M11A_b_l	Multiplayer (bl MP overRide) (g %target alive)(t:display name )(s: T choice bug)(q: displays all tasks of several squadrons)
-------------------------------------------------------------------------------------------------------

BugList = {}
AcceptedMission = false
DebuGenTxt = ""					--debug cumulutatif de ATO_Generator

local function AcceptMission()
	repeat
		print("\n\n Night or Day ? : "..daytime)													-- info day or not
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
----- random seed -----
math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))
math.random(); math.random(); math.random()


--load functions
dofile("Init/conf_mod.lua")



--load mission export files
local testNamePath = "camp_status.lua"
local TestPath = io.open(testNamePath, "r")
if  TestPath == nil then
	local txt = "DEBUG_DebriefMission is a utility that allows you to resume the script at the end of a mission\
	But it needs the temporary mission end files, which are not present here.\
	\
	These files have not been written because:\
	- the path does not match (path.bat) \
	- or sanitizeModule is not disabled (DCE_MissionScript_Mod)\
	- or these files have been deleted by a new mission generation.\
	"
	print(txt)
	os.execute 'pause'
	os.exit()
end

local logExport = loadfile("MissionEventsLog.lua")()											--mission events log
local scenExport = loadfile("scen_destroyed.lua")()												--destroyed scenery objects
local campExport = loadfile("camp_status.lua")()												--camp_status
local SARExport

--zoneSAR = {
local zoneSARFile = "zoneSAR.lua"
local TestPath = io.open(zoneSARFile, "r")																--cette maniere de chercer la presence d un fichier evite un plantage
if TestPath ~= nil then																					--check si le fichier existe dans ScriptsMod
	io.close(TestPath)
	SARExport = loadfile("zoneSAR.lua")()														--zoneSAR
end


versionPackageICM = camp.versionPackageICM

if not versionPackageICM or versionPackageICM == nil then										-- modification M35.d version ScriptsMod
	versionPackageICM = os.getenv('versionPackageICM')											-- modification M35.c version ScriptsMod
end

dofile("../../../ScriptsMod."..versionPackageICM.."/UTIL_Data.lua")
dofile("../../../ScriptsMod."..versionPackageICM.."/UTIL_DataMap.lua")
dofile("../../../ScriptsMod."..versionPackageICM.."/UTIL_Functions.lua")

--load status file to be updated
require("Active/oob_ground")																	--load ground oob
require("Active/oob_air")																		--load air oob
require("Active/targetlist")																--load targetlist

-- Exécution du fichier s'il existe
local testFile = "Init/various_table.lua"
if fileExists(testFile) then
    dofile(testFile)
end


if not targetlist.blue[1] then
	targetlistToNum()
end
require("Active/clientstats")																	--load clientstats

--camp_ZoneSAR = {
local zoneSARFile = "Active/camp_ZoneSAR.lua"
local TestPath = io.open(zoneSARFile, "r")																--cette maniere de chercer la presence d un fichier evite un plantage
if TestPath ~= nil then																					--check si le fichier existe dans ScriptsMod
	io.close(TestPath)
	require("Active/camp_ZoneSAR")																--zoneSAR
end

Playable_m = {}

for planeType, value in pairsByKeys(data_divers) do	
	if value.playable then
		Playable_m[planeType] = true
	end
end	

---

-- modification M40.f : Template Active GroundGroup moving front (f: sideBase)
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
		local trigFile = io.open("Active/db_airbases.lua", "w")
		trigFile:write(airbases_Str)
		trigFile:close()
	end
end


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
	if camp.runwayLife then
		for baseN, base in pairs(camp.runwayLife) do
			if db_airbases[base.name] then
				foundN = foundN + 1
				
				if db_airbases[base.name].x == base.point.x  then
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



dofile("Init/conf_mod.lua")
dofile("../../../ScriptsMod."..versionPackageICM.."/UTIL_Data.lua")
dofile("../../../ScriptsMod."..versionPackageICM.."/UTIL_DataMap.lua")
dofile("../../../ScriptsMod."..versionPackageICM.."/UTIL_Functions.lua")


--run log evaluation and status updates
dofile("../../../ScriptsMod."..versionPackageICM.."/DEBRIEF_StatsEvaluation.lua")
dofile("../../../ScriptsMod."..versionPackageICM.."/DC_DestroyTarget.lua")												--Mod11.j
dofile("../../../ScriptsMod."..versionPackageICM.."/DC_UpdateTargetlist.lua")

--update campaign time
local elapsed_time = math.floor(events[#events].t - events[1].t)								--mission runtime in seconds
camp.time = camp.time + elapsed_time															--add mission time to campaign time


--create and view debriefing file for mission
dofile("../../../ScriptsMod."..versionPackageICM.."/DEBRIEF_Text.lua")														--In this script the actual text is created. Script loaded after oob modifications above have been made.
local debriefFile = io.open("Debriefing/Debriefing " .. camp.mission .. ".txt", "w")			--create new debriefing file
debriefFile:write(debriefing)																	--write debriefing text into file (variable debriefing comes from DEBRIEF_Text.lua)
debriefFile:close()
os.execute('start "Debriefing" "notepad.exe" "Debriefing/Debriefing ' .. camp.mission .. '.txt"')	--open the debriefing file with notepad

		
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

if versionPackageICM then
	print("= = = = = = = = = = = = = = = = = = = = = = = "..camp.title.." = = = = = = = = = = = = = = = = = =")
	print("= = = = = = = = = = = = = = Version: "..tostring(camp.version))
	print("= = = = = = = = = = = = = Script: "..showVersion)
	print()
else 
	print("= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =")
end	

	--===================================================================================
	-- Ecran N 00 Choix accept result mission or not	
--ask for input to save results 

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
	
	-- increase campaign mission number
	-- camp.mission = camp.mission + 1	
	AcceptedMission = true

	--TODO cette partie devrait etre dans MAIN_AcceptMission .... a voir
	
	--save new data (remaining files are updated in MAIN_NextMission.lua)
	local client_str = "clientstats = " .. TableSerialization(clientstats, 0)					--make a string
	local clientFile = io.open("Active/clientstats.lua", "w")									--open clientstats file
	clientFile:write(client_str)																--save new data
	clientFile:close()
	
	local oob_scen_old = loadfile("Active/oob_scen.lua")()										--load oob_scen file
	for scen_name, scen in pairsByKeys(scen_log) do													--iterate through destroyed scenery objects
		if scen.x and scen.z then																--destroyed scenery object has x and z coordinates
			if scen.lifePourcent then
				if scen.lifePourcent == 0 then
					oob_scen[scen_name] = scen
				end
			else
				oob_scen[scen_name] = scen														--add/update to oob_scen
			end

		end
	end
	local scen_str = "oob_scen = " .. TableSerialization(oob_scen, 0)							--make a string
	local scenFile = io.open("Active/oob_scen.lua", "w")										--open oob_scen file
	scenFile:write(scen_str)																	--save new data
	scenFile:close()
	
	dofile("../../../ScriptsMod."..versionPackageICM.."/MAIN_AcceptMission.lua")

	AcceptedMission = false
	
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
	
	-- --save new data (remaining files are updated in MAIN_NextMission.lua)
	-- local client_str = "clientstats = " .. TableSerialization(clientstats, 0)					--make a string
	-- local clientFile = io.open("Active/clientstats.lua", "w")									--open clientstats file
	-- clientFile:write(client_str)																--save new data
	-- clientFile:close()
	
	-- local oob_scen_old = loadfile("Active/oob_scen.lua")()										--load oob_scen file
	-- for scen_name,scen in pairsByKeys(scen_log) do													--iterate through destroyed scenery objects
	-- 	if scen.x and scen.z then																--destroyed scenery object has x and z coordinates
	-- 		oob_scen[scen_name] = scen															--add/update to oob_scen
	-- 	end
	-- end
	-- local scen_str = "oob_scen = " .. TableSerialization(oob_scen, 0)							--make a string
	-- local scenFile = io.open("Active/oob_scen.lua", "w")										--open oob_scen file
	-- scenFile:write(scen_str)																	--save new data
	-- scenFile:close()
	

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
					print("choose a Single target")
					
					local tabIndex = {}	 
					-- for side, Targetlist in pairsByKeys(tableTargetlist) do
					for side, targets in pairs(targetlist) do
						local j = 1
						local Ckey = 0
						print() print(side..":")
						for key, target in ipairs(targets) do	
							if target.inactive ~= true and target.ATO  and ( target.task == "Strike" or target.task == "Anti-ship Strike" or target.task == "CSAR") then
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
							Multi.Target[side] = targetlist[side][Ckey].name
							print("\n"..targetlist[side][Ckey].name.."\n")
						else 
							print("\nInvalid entry.\n")
						end
					until  tabIndex[input]
					
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
					for nSide , oob_airSide in pairsByKeys(oob_air) do														--pour afficher l'exemple de selection du premier avion presente
						for m , unit in pairsByKeys(oob_airSide) do
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
				tabTaskAvailable = {}
				
				-- parse toutes les unites et rempli le tab tabTaskAvailable pour etre sur de proposer toutes les task propos� active 
				for nSide , oob_airSide in pairsByKeys(oob_air) do	
					print() print(nSide..":")
					for m , unit in pairsByKeys(oob_airSide) do						
						if Playable_m[unit.type]  and unit.inactive ~= true then							
							for taskStr , nbool in pairsByKeys(oob_air[nSide][m].tasks) do
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
				for nSide , unit_type in pairsByKeys(tabTaskAvailable) do	
					print() print(nSide..":")
					for unitType , TabType in pairsByKeys(unit_type) do
							
						local IndexStringType = string.lower(string.char(ti))
						if not playable_type[IndexStringType] then playable_type[IndexStringType] = {} end													
						playable_type[IndexStringType]["type"] = unitType
						playable_type[IndexStringType]["side"] = nSide
						
						io.write(" (1 to 8): ("..IndexStringType.."): "..unitType..":")												
							
						for taskStr , nbool in pairsByKeys(TabType) do	
							if   nbool == true then
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
			dofile("../../../ScriptsMod."..versionPackageICM.."/UTIL_ChangePlane.lua")
		end
		
	until tabIndex01[choix1]

--==========================================================

	--increase campaign mission number
	-- camp.mission = camp.mission + 1	
	
	--generate next campaign mission
	Briefing_status = ""																		--text string to be added to next briefing (status reports are amended for each mission generation attempt until mission is succesfully generated)
	Briefing_oob_text_red = ""																	--text string to be added to next briefing (red repair and reinforcements)
	Briefing_oob_text_blue = ""																	--text string to be added to next briefing (blue repair and reinforcements)
	PlayerFlight = false																		--variable to control mission generation loop
	
	MissionInstance = 0
	repeat
		print("Generating Next Mission.\n")
	
		MissionInstance = MissionInstance + 1													--count the number of times the mission is generated															   
		dofile("../../../ScriptsMod."..versionPackageICM.."/MAIN_NextMission.lua")											--generate next mission
		
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
		elseif stopBug then																			--mission has a player flight
			print("\n\n stopBug .\n")																--confirmation text
			break
		elseif MissionInstance == 50 then														--no player flight could be assigned in 50 tries, stop it
			print("Mission Generation Error. No eligible player flight in 50 attempts. Start a new campaign.\n\n")
			break
		else																					--no player flight could be assigned, advance time and try again
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
			end
		end
		if showVersion then
			print("= = = = = = = = = = = = = = = = = = = = = = = "..camp.title.." = = = = = = = = = = = = = = = = = =")
			print("= = = = = = = = = = = = = = Version: "..tostring(camp.version))
			print("= = = = = = = = = = = = = Script: "..showVersion)
			print()
		else 
			print("= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =")
		end		
	until 1 == 2																					--repeat until the next mission is ready (has a player flight)
	break
  until 1 == 2
	os.execute 'pause'
		
	
else	
	camp.waitingNextGen = true
	
	----- convert tables back to strings for insertion into content files -----
	local cmpStr = "camp = " .. TableSerialization(camp, 0)
	local cmpFile = io.open("Active/camp_status.lua", "w")								--campaign status file
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