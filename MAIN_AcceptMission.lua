--To generate a new mission file. Unzips template mission, defines content of next missions and packs a new mission file
--Initiated by Debrief_Master.lua, BAT_FirstMission.lua or BAT_RedoMission.lua
------------------------------------------------------------------------------------------------------- 
-- last modification debug_b
if not versionDCE then versionDCE = {} end
versionDCE["MAIN_AcceptMission.lua"] = "1.10.65"
------------------------------------------------------------------------------------------------------- 

-- cleanCode_g				(g springCleaning)(e: os.remove)
-- debug_b					(b Briefing_text)(a endCampaign)
-- adjustment_g				(f currentKey)(e not DC_Weather)(d PairsByKeys)(c move UpdateSar & correct Brief Systeme)(b: don't load UTIL_Debug)(a: don't load Ini/db_airbase)
-- modification M63_a		compatible Datacard Generator or CombatFlite
-- modification M61_a		SAR
-- modification M56_a		AssignCallnameSquad
-- modification M51_a		Moonphase
-- modification M49_a		big central db_loadout
-- modification M48_g		Accept result mission (d: garde en memoire le txt camp.pendingBriefing) (g: addImage trigger)(af: debug)
-- modification M34_Bl		custom FrequenceRadio (l new file name)
-- -------------------------------------------------------------------------------------------------------

-- print("MAIN_AM targetlist F1: "..tostring(camp_triggers))
-- print("MAIN_AM targetlist F2: "..tostring(camp_triggers[1]["name"]))

----- unpack template mission file ----
local minizip = require('minizip')

local zipFile = minizip.unzOpen("Init/base_mission.miz", 'rb')

zipFile:unzLocateFile('mission')
local misStr = zipFile:unzReadAllCurrentFile()
local misStrFunc = loadstring(misStr)()

zipFile:unzLocateFile('options')
local optStr = zipFile:unzReadAllCurrentFile()
local optStrFunc = loadstring(optStr)()

zipFile:unzLocateFile('warehouses')
local warStr = zipFile:unzReadAllCurrentFile()
local warStrFunc = loadstring(warStr)()

zipFile:unzLocateFile('l10n/DEFAULT/dictionary')
local dicStr = zipFile:unzReadAllCurrentFile()
local dicStrFunc = loadstring(dicStr)()

zipFile:unzLocateFile('l10n/DEFAULT/mapResource')
local resStr = zipFile:unzReadAllCurrentFile()
local resStrFunc = loadstring(resStr)()

zipFile:unzClose()

AcceptedMission = true

--save new data (remaining files are updated in MAIN_NextMission.lua)
local client_str = "clientstats = " .. TableSerialization(clientstats, 0)					--make a string
local clientFile = io.open("Active/clientstats.lua", "w") or error("Failed to open debug file")
clientFile:write(client_str)																--save new data
clientFile:close()

-- local oob_scen_old = loadfile("Active/oob_scen.lua")()										--load oob_scen file
for scen_name, scen in PairsByKeys(scen_log) do												--iterate through destroyed scenery objects
	if scen.x and scen.y then																--destroyed scenery object has x and z coordinates

		local isForest = false
		if scen.sceneryTypeName and string.find(scen.sceneryTypeName, "FOREST")  then
			isForest = true
		end

		if not isForest then
			-- print("Pass MainAM scen_name: "..scen_name.." scen.sceneryTypeName: " .. scen.sceneryTypeName)
			if scen.lifePourcent then
				if scen.lifePourcent <= MinPercentDestroyed then
					oob_scen[scen_name] = scen
				end
			else
				oob_scen[scen_name] = scen														--add/update to oob_scen
			end
		end
	end
end

local scen_str = "oob_scen = " .. TableSerialization(oob_scen, 0)							--make a string
local scenFile = io.open("Active/oob_scen.lua", "w") or error("Failed to open debug file")
scenFile:write(scen_str)																	--save new data
scenFile:close()


----- run scripts to accept content of next mission -----
dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_Data.lua")
CreateAircraftListInCampaign()
CleanDataDivers()
dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_DataMap.lua")
dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_Functions.lua")

--run log evaluation and status updates
dofile("../../../ScriptsMod."..VersionPackageICM.."/DEBRIEF_StatsEvaluation.lua")
dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_UpdateTargetlist.lua")

--create and view Debriefing file for mission
--cette foi-ci, on enregistre les stats, mais sans les montrer

dofile("../../../ScriptsMod."..VersionPackageICM.."/DEBRIEF_Text.lua")														--In this script the actual text is created. Script loaded after oob modifications above have been made.

--retrocompatibilie location UTIL_DataRadio file
--recherche en priorit� le fichier radios_freq_compatible dans le dossier ScriptsMod puis dans le dossier campagne
local radioFile = "../../../ScriptsMod."..VersionPackageICM.."/UTIL_DataRadio.lua"
local testPath = io.open(radioFile, "r")																--cette maniere de chercher la presence d un fichier evite un plantage
if not testPath then																					--check si le fichier existe dans ScriptsMod
	io.close(testPath)
	dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_DataRadio.lua")
else
	local radioFile2 = "../../../Missions/Campaigns/"..camp.title.."/Init/radios_freq_compatible.lua"
	local testPath2 = io.open(radioFile2, "r")
	if testPath2 ~= nil then																			--check si le fichier exist dans le dossier campagne
		io.close(testPath2)
		dofile(radioFile2)
	end
end





-- dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_Refpoints.lua")			--besoin par NavalEnv
-- dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_MissionScore.lua")

-- -- dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_Time.lua")				--need if AcceptedMission
-- -- dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_MoonPhase.lua")


-- --TODO comment se passer de ca??
-- -- dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_NavalEnvironment.lua")		--besoin par CheckTrigger pour bouger les navires


-- dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_CheckTriggers.lua")

-- --TODO ici la cible Jask repasse à 30%, pourquoi
-- dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_UpdateTargetlist.lua")
-- dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_UpdateOOBGround.lua")

mission.currentKey = 1010000															--not clear how this works but is required for multiplyer clients to be available for selection on mission start

-- camp.waitingNextGen = true

if Briefing_text and Briefing_text ~= "" then

	if camp.pendingBriefing then
		camp.pendingBriefing = camp.pendingBriefing .. Briefing_text
	else
		camp.pendingBriefing = Briefing_text
	end

end


-- fou le bordel, TODO, il faudrait vérifier si certaines images ont le droit d'être sauvegardée pour la prochaine mission

-- --si la generation de la mission suivante est repoussee, on sauvegarde le txt cr�e par les trigger txt precedent
-- if BriefingImagesR ~= nil or (BriefingImagesR and #BriefingImagesR ~= 0) then
-- 	if camp["BriefingImagesR"] then
-- 		table.insert(camp["BriefingImagesR"], BriefingImagesR)
-- 	else
-- 		camp["BriefingImagesR"]	 = BriefingImagesR
-- 	end
-- end
-- if BriefingImagesB ~= nil or (BriefingImagesB and #BriefingImagesB ~= 0) then
-- 	if camp["BriefingImagesB"] then
-- 		table.insert(camp["BriefingImagesB"], BriefingImagesB)
-- 	else
-- 		camp["BriefingImagesB"]	 = BriefingImagesB
-- 	end
-- end


----- convert tables back to strings for insertion into content files -----
local cmpStr = "camp = " .. TableSerialization(camp, 0)

local cmpFile = io.open("Active/camp_status.lua", "w") or error("Failed to open debug file")
cmpFile:write(cmpStr)
cmpFile:close()

-- ----- remove temporary content files -----
-- os.remove("misFile.lua")
-- os.remove("optFile.lua")
-- os.remove("warFile.lua")
-- os.remove("dicFile.lua")
-- os.remove("resFile.lua")
-- os.remove("GCIdata.lua")
-- os.remove("aibaseFile.lua")


----- save updated status files  -----
table.sort(oob_air.blue, function(a, b) return a.type:upper() < b.type:upper() end)
table.sort(oob_air.red, function(a, b) return a.type:upper() < b.type:upper() end)


local air_str = "oob_air = " .. TableSerialization(oob_air, 0)								--make a string
local airFile = io.open("Active/oob_air.lua", "w") or error("Failed to open debug file")
airFile:write(air_str)																		--save new data
airFile:close()

local ground_str = "oob_ground = " .. TableSerialization(oob_ground, 0)						--make a string
local groundFile = io.open("Active/oob_ground.lua", "w") or error("Failed to open debug file")
groundFile:write(ground_str)																--save new data
groundFile:close()

-- print("MAIN_AM targetlist M1: "..tostring(camp_triggers))
-- print("MAIN_AM targetlist M2: "..tostring(camp_triggers[1]["name"]))

local tgt_str = "targetlist = " .. TableSerialization(targetlist, 0)						--make a string
local tgtFile = io.open("Active/targetlist.lua", "w") or error("Failed to open debug file")
tgtFile:write(tgt_str)																		--save new data
tgtFile:close()

-- local trigStr = "camp_triggers = " .. TableSerializationAG(camp_triggers, 0)
-- local trigFile = io.open("Active/camp_triggers.lua", "w") or error("Failed to open debug file")
-- trigFile:write(trigStr)
-- trigFile:close()

local airbases_Str = "db_airbases = " .. TableSerialization(db_airbases, 0)
local trigFile = io.open("Active/db_airbases.lua", "w") or error("Failed to open debug file")
trigFile:write(airbases_Str)
trigFile:close()

local ZoneSAR_str = "camp_ZoneSAR = " .. TableSerialization(camp_ZoneSAR, 0)					--make a string
local ZoneSARFile = io.open("Active/camp_ZoneSAR.lua", "w")	 or error("Failed to open debug file")
ZoneSARFile:write(ZoneSAR_str)																	--save new data
ZoneSARFile:close()

_affiche(camp.date, "camp.date")
print("MAIN_AM BEFORE LoadFileAndUpdate()")

--***********NEW function***************--
--***********NEW function***************--
LoadFileAndUpdate("MAIN_AcceptMission "..debug.getinfo(1).currentline)
--***********NEW function***************--
--***********NEW function***************--

_affiche(camp.date, "camp.date")
print("MAIN_AM AFTER LoadFileAndUpdate()")


-- if TypeAlias then
-- 	local _str = "TypeAlias = " .. TableSerialization(TypeAlias, 0)
-- 	local _file = io.open("Active/alias.lua", "w") or error("Failed to open debug file")
-- 	_file:write(_str)
-- 	_file:close()
-- end


