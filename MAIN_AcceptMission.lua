--To generate a new mission file. Unzips template mission, defines content of next missions and packs a new mission file
--Initiated by Debrief_Master.lua, BAT_FirstMission.lua or BAT_RedoMission.lua
------------------------------------------------------------------------------------------------------- 
-- last modification M34_Bl
if not versionDCE then versionDCE = {} end
versionDCE["MAIN_AcceptMission.lua"] = "1.10.63"
------------------------------------------------------------------------------------------------------- 

-- cleanCode_f				(e: os.remove)
-- debug_a					(a endCampaign)
-- adjustment_g				(f currentKey)(e not DC_Weather)(d PairsByKeys)(c move UpdateSar & correct Brief Systeme)(b: don't load UTIL_Debug)(a: don't load Ini/db_airbase)
-- modification M63_a		compatible Datacard Generator or CombatFlite
-- modification M61_a		SAR
-- modification M56_a		AssignCallnameSquad
-- modification M51_a		Moonphase
-- modification M49_a		big central db_loadout
-- modification M48_g		Accept result mission (d: garde en memoire le txt camp["Briefing_text"]) (g: addImage trigger)(af: debug)
-- modification M34_Bl		custom FrequenceRadio (l new file name)
-- -------------------------------------------------------------------------------------------------------

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


----- run scripts to accept content of next mission -----
dofile("../../../ScriptsMod."..versionPackageICM.."/UTIL_Data.lua")
dofile("../../../ScriptsMod."..versionPackageICM.."/UTIL_DataMap.lua")
dofile("../../../ScriptsMod."..versionPackageICM.."/UTIL_Functions.lua")


--run log evaluation and status updates
-- print("MainAM AA "..tostring(targetlist.blue[8].elements[2].name).." dead? "..tostring(targetlist.blue[8].elements[2].dead))
dofile("../../../ScriptsMod."..versionPackageICM.."/DEBRIEF_StatsEvaluation.lua")
-- print("MainAM BB "..tostring(targetlist.blue[8].elements[2].name).." dead? "..tostring(targetlist.blue[8].elements[2].dead))
dofile("../../../ScriptsMod."..versionPackageICM.."/DC_DestroyTarget.lua")												--Mod11.j
dofile("../../../ScriptsMod."..versionPackageICM.."/DC_UpdateTargetlist.lua")
-- print("MainAM DD "..tostring(targetlist.blue[8].elements[2].name).." dead? "..tostring(targetlist.blue[8].elements[2].dead))
--create and view debriefing file for mission
--cette foi-ci, on enregistre les stats, mais sans les montrer

dofile("../../../ScriptsMod."..versionPackageICM.."/DEBRIEF_Text.lua")														--In this script the actual text is created. Script loaded after oob modifications above have been made.

--ces fichiers sont loadé par DEBRIEF_StatsEvaluation au dessus
-- require("Active/oob_air")
-- require("Active/oob_ground")
-- require("Init/conf_mod")																				-- modification M00 : need option

--retrocompatibilie location UTIL_DataRadio file
--recherche en priorit� le fichier radios_freq_compatible dans le dossier ScriptsMod puis dans le dossier campagne
local RadioFile = "../../../ScriptsMod."..versionPackageICM.."/UTIL_DataRadio.lua"
local TestPath = io.open(RadioFile, "r")																--cette maniere de chercer la presence d un fichier evite un plantage
if TestPath ~= nil then																					--check si le fichier existe dans ScriptsMod
	io.close(TestPath)
	dofile("../../../ScriptsMod."..versionPackageICM.."/UTIL_DataRadio.lua")
else	
	local RadioFile2 = "../../../Missions/Campaigns/"..camp.title.."/Init/radios_freq_compatible.lua"
	local TestPath2 = io.open(RadioFile2, "r")
	if TestPath2 ~= nil then																			--check si le fichier exist dans le dossier campagne
		io.close(TestPath2)
		dofile(RadioFile2)
	end
end

local db_airbasesFile = "Active/db_airbases.lua"
local TestPath = io.open(db_airbasesFile, "r")																--cette maniere de chercer la presence d un fichier evite un plantage
if TestPath ~= nil then																					--check si le fichier existe dans ScriptsMod
	io.close(TestPath)
	-- dofile("Active/db_airbases.lua")
else	
	local db_airbasesFile2 = "Init/db_airbases.lua"
	local TestPath2 = io.open(db_airbasesFile2, "r")
	if TestPath2 ~= nil then																			--check si le fichier exist dans le dossier campagne
		io.close(TestPath2)
		dofile(db_airbasesFile2)
		--creer le fichier db_airbases dans Active, meme en cours de campagne, pour garder la retrocompatibilite
		print("MainA create copie db_airbase from Init")
		local airbases_Str = "db_airbases = " .. TableSerialization(db_airbases, 0)
		local trigFile = io.open("Active/db_airbases.lua", "w") or error("Failed to open debug file")
		trigFile:write(airbases_Str)
		trigFile:close()
	end
end


-- require("Active/targetlist")
if not targetlist.blue[1] then
	TargetlistToNum()
end

require("Active/camp_triggers")

dofile("../../../ScriptsMod."..versionPackageICM.."/DC_Refpoints.lua")			--besoin par NavalEnv
dofile("../../../ScriptsMod."..versionPackageICM.."/DC_MissionScore.lua")
dofile("../../../ScriptsMod."..versionPackageICM.."/DC_Time.lua")				--need if AcceptedMission
dofile("../../../ScriptsMod."..versionPackageICM.."/UTIL_MoonPhase.lua")
-- dofile("../../../ScriptsMod."..versionPackageICM.."/DC_DestroyTarget.lua")			-- Mod26
dofile("../../../ScriptsMod."..versionPackageICM.."/DC_NavalEnvironment.lua")		--besoin par CheckTrigger pour bouger les navires
-- dofile("../../../ScriptsMod."..versionPackageICM.."/DC_UpdateTargetlist.lua")
dofile("../../../ScriptsMod."..versionPackageICM.."/DC_CheckTriggers.lua")

--TODO ici la cible Jask repasse à 30%, pourquoi
dofile("../../../ScriptsMod."..versionPackageICM.."/DC_UpdateTargetlist.lua")
dofile("../../../ScriptsMod."..versionPackageICM.."/DC_UpdateOOBGround.lua")

mission.currentKey = 1010000															--not clear how this works but is required for multiplyer clients to be available for selection on mission start

camp.waitingNextGen = true

--si la generation de la mission suivante est repoussee, on sauvegarde le txt cree par les trigger txt precedent
-- if Briefing_text ~= "" then	
	if camp["Briefing_text"] then 
		camp["Briefing_text"] = ""..FormatDate(camp.date.day, camp.date.month, camp.date.year) .. ", " .. FormatTime(camp.time, "hh:mm") .. camp["Briefing_text"] .. ": \n \n" 		--add date and time header
	else 
		camp["Briefing_text"] = ""..FormatDate(camp.date.day, camp.date.month, camp.date.year) .. ", " .. FormatTime(camp.time, "hh:mm") .. ": \n \n" 		--add date and time header
	end
	
	if Briefing_text ~= "" then	
		-- Briefing_text = Briefing_text:gsub("\n", "\\\n")
		-- Briefing_text = Briefing_text:gsub("\\n", "\\\n")
		-- Briefing_text = Briefing_text:gsub("\\\\\n", "\\\n")
		camp["Briefing_text"] = camp["Briefing_text"] .. Briefing_text
	end

--si la generation de la mission suivante est repoussee, on sauvegarde le txt cr�e par les trigger txt precedent
if BriefingImagesR ~= nil or #BriefingImagesR ~= 0 then	
	if camp["BriefingImagesR"] then 
		table.insert(camp["BriefingImagesR"], BriefingImagesR)
	else 
		camp["BriefingImagesR"]	 = BriefingImagesR
	end
end
if BriefingImagesB ~= nil or #BriefingImagesB ~= 0 then	
	if camp["BriefingImagesB"] then 
		table.insert(camp["BriefingImagesB"], BriefingImagesB)
	else 
		camp["BriefingImagesB"]	 = BriefingImagesB
	end
end


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
if TypeAlias then
	air_str = air_str .. "TypeAlias = " .. TableSerialization(TypeAlias, 0)
end
local airFile = io.open("Active/oob_air.lua", "w") or error("Failed to open debug file")
airFile:write(air_str)																		--save new data
airFile:close()

local ground_str = "oob_ground = " .. TableSerialization(oob_ground, 0)						--make a string
local groundFile = io.open("Active/oob_ground.lua", "w") or error("Failed to open debug file")
groundFile:write(ground_str)																--save new data
groundFile:close()


local tgt_str = "targetlist = " .. TableSerialization(targetlist, 0)						--make a string
local tgtFile = io.open("Active/targetlist.lua", "w") or error("Failed to open debug file")
tgtFile:write(tgt_str)																		--save new data
tgtFile:close()

local trigStr = "camp_triggers = " .. TableSerializationAG(camp_triggers, 0)
local trigFile = io.open("Active/camp_triggers.lua", "w") or error("Failed to open debug file")
trigFile:write(trigStr)
trigFile:close()

local airbases_Str = "db_airbases = " .. TableSerialization(db_airbases, 0)
local trigFile = io.open("Active/db_airbases.lua", "w") or error("Failed to open debug file")
trigFile:write(airbases_Str)
trigFile:close()

local ZoneSAR_str = "camp_ZoneSAR = " .. TableSerialization(camp_ZoneSAR, 0)					--make a string
local ZoneSARFile = io.open("Active/camp_ZoneSAR.lua", "w")	 or error("Failed to open debug file")
ZoneSARFile:write(ZoneSAR_str)																	--save new data
ZoneSARFile:close()
