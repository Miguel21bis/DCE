--To generate a new mission file. Unzips template mission, defines content of next missions and packs a new mission file
--Initiated by Debrief_Master.lua, BAT_FirstMission.lua or BAT_RedoMission.lua
------------------------------------------------------------------------------------------------------- 
-- last modification: M83_c
if not versionDCE then versionDCE = {} end
versionDCE["MAIN_NextMission.lua"] = "1.36.216"
------------------------------------------------------------------------------------------------------- 
-- debug_l 					(l endCampaign)(ik error beacon file)(h mission.maxDictId)(g help campaignMaker)(f autolase)(e camp_ZoneSAR in skipmod)(d: oob_ground not in mission)(c: EndMission)
-- Reglage_e				(e EPLRS_Capacity)(d CVN to CV)(c stop si < 2.7.0 (ver18))(a: Init/loadout selection)
-- adjustment_g				(g keep original triggers( a_remove_scene_objects ))(e oob_scen ==0)(d currentKey)(c clean conf_mod)(b Firstmission_flag)(a: add Loadout tiers)
-- cleanCode_h				(ag springCleaning)
-- modification M83_c		Jammer checkMissileProximity (c all jammer in DataBase)(b B-52)
-- modification M77_k		CG_ArtySpotter (k ListSpotterAircraft)(c camp.spotter)(b tempo)
-- modification M71_b		PayloadRestricted  (b Action.RestrictedLoadout(file))
-- modification M66_a		bombOnRunway
-- modification M65_a		add AirGroundAttackTask Mbot s file
-- modification M64_b		adds elements of a new base_mission (b: update Type & groupId)
-- modification M63_a		compatible Datacard Generator or CombatFlite
-- modification M62_a		allows you to use third party files that Data information without being overwritten by central information updates
-- modification M61_g		SAR (g EjectedPilotFrequency)(c theatre)
-- modification M60_d		add CTLD (d always beacon.ogg)(c load_CTLD option)(b debug)
-- Psyko modification M59_a			silences the tower
-- Norman99 modification M57_a		Simple Fuel Check Script
-- modification M56_a		AssignCallnameSquad
-- modification M53_b		automatic update of the conf_mod file (b conf_mod reconfiguration)
-- modification M52_a		campaign player's choices 
-- modification M51_a		Moonphase
-- modification M49_f		big central db_loadout (f: detection automatique du codeNom)(d: tag in conf_mod)(ce: loadout statistics)(b: archive)
-- modification M48_e		Accept result mission (e: debug horaire)(d: garde en memoire le txt camp["Briefing_text"])
-- modification M47_c		keeps the history of the campaign files (c: save debugging information during mission generation)
-- modification M40_k		Template Active GroundGroup moving front (k: update Active/db_airbase)
-- modification M40			Pedro
-- modification M38_v		Check and Help CampaignMaker (check name&Id)(u debug.mission file)(ijk: debug)(h: KillTarget step by step)
-- modification M37_d		SuperCarrier
-- modification M35_d		(d: info log) version ScriptsMod
-- modification M36_d		(d: add timer) MenuRadio request manual TurnIntoWind
-- modification M34_Bl		custom FrequenceRadio (l new file name) (b: move file location)
-- modification M29			AddCommandRadioF10 CallTankRefuel
-- modification M26			destroys targets if below a certain value
-- modification M18_e		despawn (e: option confMod)
-- modification M17_f		add AddPropAircraft Option all type
-- modification M11A_v		Multiplayer (u: AltitudeFloor in UTIL_Data) (t: AltitudeFloor)
-- modification M14_c		Versionning(c: use changelog.lua)
-- Tomsk modification M09_b		Integration de  Prune Script
-- modification M05_c		ajout picture Briefing (c: correction path vide)
-- modification M00_b		Integration de conf_mod
-- -------------------------------------------------------------------------------------------------------	


-- Brief = {
-- 	red = {},
-- 	blue = {},
-- }
-- Briefing_text = ""

-- -- par défaut, on assigne une valeur superieur au camp du joueur, qu'il soit rouge ou bleu.
-- SkillWish = {
-- 	["red"] = 50,
-- 	["blue"] = 50,
-- }

PlacePA = {}
AltitudeCruise = 5400			--for plane without hcruise
TaxiTime = 3000
if mission_ini.startup_time_player then mission_ini.startup_time_player = mission_ini.startup_time_player + TaxiTime end

--Check_TaskPossibleByPlane
----- unpack template mission file ----
local minizip = require('minizip')

local zipFile = minizip.unzOpen("Init/base_mission.miz", 'rb')

local old_miz = minizip.unzOpen("Init/base_mission.miz", 'rb')
local existing_files = {}

if old_miz then
    old_miz:unzGoToFirstFile()
    repeat
        local filename = old_miz:unzGetCurrentFileName()
        if filename:match("^l10n/DEFAULT/") then  -- Filtrer les fichiers sous l10n/DEFAULT
            local file_content = old_miz:unzReadAllCurrentFile()
            existing_files[filename] = file_content
        end
    until not old_miz:unzGoToNextFile()
    old_miz:unzClose()
end

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
loadstring(resStr)()
local oldMapResource = Deepcopy(mapResource)

zipFile:unzClose()

if mission.version < 19 then --19ok 18bad
	print("(MainNM) ATTENTION: BaseMission.miz is too old. (prior to DCS version 2.7.0) try to save it again with the mission editor. Or ask the creator of this campaign to provide an update.")
	os.execute 'pause'
	os.exit()
end

-- NameTheatreLower =  string.lower(mission.theatre)
-- NameTheatre =  mission.theatre


local trig_n = #mission.trigrules + 1

---- add trigger to destory scenery objects -----
mission.trig.flag[trig_n] = true
-- mission.trig.conditions[trig_n] = "return(true)"
mission.trig.conditions[trig_n] = "return(c_time_after(300) )"
mission.trig.actions[trig_n] = ""
-- mission.trig.funcStartup[trig_n] = "if mission.trig.conditions["..trig_n.."]() then mission.trig.actions["..trig_n.."]() end"
mission.trig.func[trig_n] = "if mission.trig.conditions["..trig_n.."]() then mission.trig.actions["..trig_n.."]() end"
mission.trigrules[trig_n] = {
	-- ["rules"] = {},
	["rules"] =
		{
			[1] =
			{
				["predicate"] = "c_time_after",
				["seconds"] = 300,
			}, -- end of [1]
		}, -- end of ["rules"]
	["eventlist"] = "",
	["actions"] = {},
	["comment"] = "Scenery Destruction",
	-- ["predicate"] = "triggerStart",
	["predicate"] = "triggerOnce",
}

--attention, ne pas activer ici oob_scen, sinon cela ne prend pas en compte son update
-- require("Active/oob_scen")

-- if not oob_scen and Firstmission_flag then
-- 	require("Active/oob_scen")
-- end
for scen_name, scen in pairs(oob_scen) do											--iterate through destroyed scenery objects

	if scen.x and scen.z then														--destroyed scenery object has x and z coordinates

		local isForest = false
		if scen.sceneryTypeName and string.find(scen.sceneryTypeName, "FOREST")  then
			isForest = true
		end

		local txDestruction = 100
		local radius = 12

        if scen.explosiveMass then
            -- Calcul du rayon de destruction total (en mètres) selon la masse d'explosif (TNT)
            local k = 8 -- coefficient empirique pour destruction totale
            radius = math.floor(k * (scen.explosiveMass)^(1/3))
            -- print("Destruction totale pour "..tostring(scen_name).." : rayon = "..radius.." m (masse TNT = "..scen.explosiveMass.." kg)")
        end

		-- local addToMission = false

		-- if scen.lifePourcent and not isForest then
		-- 	if scen.lifePourcent <= MinPercentDestroyed then
		-- 		addToMission = true
		-- 		txDestruction = 100 - scen.lifePourcent -- taux de destruction = 100 - pourcentage de vie
		-- 	else
		-- 		oob_scen[scen_name] = nil
		-- 	end
		-- else
		-- 	-- addToMission = true
		-- end

		if not isForest  then
			local zones_n = #mission.triggers.zones	+ 1									--trigger zone number

			--add trigger zone
			mission.triggers.zones[zones_n] = {
				["x"] = scen.x,
				["y"] = scen.z,
				["radius"] = radius,
				["zoneId"] = zones_n,
				["color"] =
				{
					[1] = 1,
					[2] = 1,
					[3] = 1,
					[4] = 0.15,
				},
				["hidden"] = true,
				-- ["name"] = "ScenKillZone_" .. (#mission.trigrules[trig_n].actions + 1).."_"..tostring(scen_name),
				["name"] = "SceneryDestroyZone" .. #mission.trigrules[trig_n].actions + 1,
			}

			--add trigger
			mission.trig.actions[trig_n] = mission.trig.actions[trig_n] ..  "a_scenery_destruction_zone(" .. zones_n .. ", ".. txDestruction..");"

			mission.trigrules[trig_n].actions[#mission.trigrules[trig_n].actions + 1] = {
				["ai_task"] = {
					[1] = "",
					[2] = "",
				},
				["predicate"] = "a_scenery_destruction_zone",
				["destruction_level"] = txDestruction,
				["zone"] = zones_n,
			}
		end
	end
end

-----------------------------------------------------------------------
mapResource =
{
} -- end of mapResource

----- prepare triggers to run files in mission -----
-- local trig_n = 1
local function AddFileTrigger(filename, cond0, predicate1, predicate2)

	--attention, les sons sont à telecharger de cette maniere
	--	[4] = "a_out_sound_c(21, getValueResourceByKey(\"ResKey_Action_2\"), 0);a_out_sound_c(8, getValueResourceByKey(\"ResKey_Action_3\"), 0);",
-- 	["rules"] = 
-- 	{
-- 	}, -- end of ["rules"]
-- 	["comment"] = "Sounds",
-- 	["eventlist"] = "",
-- 	["predicate"] = "triggerStart",
-- 	["actions"] = 
-- 	{
-- 		[1] = 
-- 		{
-- 			["file"] = "ResKey_Action_2",
-- 			["countrylist"] = 21,
-- 			["predicate"] = "a_out_sound_c",
-- 			["ai_task"] = 
-- 			{
-- 				[1] = "",
-- 				[2] = "",
-- 			}, -- end of ["ai_task"]
-- 		}, -- end of [1]
-- 		[2] = 
-- 		{
-- 			["countrylist"] = 8,
-- 			["file"] = "ResKey_Action_3",
-- 			["predicate"] = "a_out_sound_c",
-- 			["ai_task"] = 
-- 			{
-- 				[1] = "",
-- 				[2] = "",
-- 			}, -- end of ["ai_task"]
-- 		}, -- end of [2]
-- 	}, -- end of ["actions"]
-- }, -- end of [4]

	local cond = ""
	local rule = nil
	if not cond0 then
		cond = "return(true)"
		rule = nil
	else
		cond = "return(c_time_after("..tostring(cond0)..") )"
		rule = {
			['predicate'] = 'c_time_after',
			['seconds'] = cond0,
		}
	end

	local predicate = ""
	if not predicate1 then
		predicate1 = "triggerStart"
	end

	if not predicate2 then
		predicate2 = 'a_do_script_file'
	end

	local idCountry = 2

	mission.maxDictId = mission.maxDictId + 1
	trig_n = trig_n + 1
	mapResource["ResKey_Action_" .. mission.maxDictId] = filename
	mission.trig.funcStartup[trig_n] = "if mission.trig.conditions[" .. trig_n .. "]() then mission.trig.actions[" .. trig_n .. "]() end"
	mission.trig.flag[trig_n] = true
	mission.trig.conditions[trig_n] = cond																			--"return(true)"
	--						[1] = "a_do_script_file(getValueResourceByKey(\"ResKey_Action_6\"));",
	if predicate2 == "a_out_sound_c" then
		mission.trig.actions[trig_n] = "a_out_sound_c("..idCountry..", getValueResourceByKey(\"ResKey_Action_" .. mission.maxDictId .. "\"), 0);"
	else
		mission.trig.actions[trig_n] = "a_do_script_file(getValueResourceByKey(\"ResKey_Action_" .. mission.maxDictId .. "\"));"
	end

	mission.trigrules[trig_n] = {
		['rules'] = { rule },
		['eventlist'] = '',
		['comment'] = 'Trigger ' .. trig_n,
		['predicate'] = predicate1,
		['actions'] = {
			[1] = {
				['file'] = 'ResKey_Action_' .. mission.maxDictId,
				['predicate'] = predicate2,
				['ai_task'] = {
					[1] = '',
					[2] = '',
				},
			},
		},
	}

	if predicate2 == "a_out_sound_c" then
		mission.trigrules[trig_n]["countrylist"] = idCountry
	end
end


----- prepare triggers to run files in mission with tempo-----
function AddFileTriggerTempo(filename, time, predicat0, ActionPredicate0)

	mission.maxDictId = mission.maxDictId +1
	local Table_trigrulesAction = {}
	local trig_n =  #mission.trig.actions + 1										--next available trigger number
	local s = ""

	for key, value in ipairs(ActionPredicate0) do
		local  trigrulesAction = {}

		if value.Predicate == "a_do_script_file" then
			trigrulesAction = {
				["file"] = 'ResKey_Action_' .. mission.maxDictId,
				["predicate"] = 'a_do_script_file',
			}

		elseif value.Predicate == "a_do_script"   then
			trigrulesAction = {
				-- ref: ["text"] = "ctld.JTACAutoLase('JTAC1', 1688, true,\"all\",1)",
				["text"] = "ctld.JTACAutoLase('"..value.NameJTAC.."', 1688, true,\\\"all\\\",1)",
				["predicate"] = "a_do_script",
				["ai_task"] =
				{
					[1] = "",
					[2] = "",
				}
			}
			--ref:		a_do_script(\"ctld.JTACAutoLase('JTAC1', 1688, true,\\\"all\\\",1)\");a_do_script(\"ctld.JTACAutoLase(
			s = s.."a_do_script(\\\"ctld.JTACAutoLase(\\\'"..value.NameJTAC.."\\\', 1688, true,\\\"all\\\",1));"
		end

		table.insert(Table_trigrulesAction, trigrulesAction)
	end


	if filename and filename ~= "" then
		mapResource["ResKey_Action_" .. mission.maxDictId] = filename
		--							[1] = "a_do_script_file(getValueResourceByKey(\"ResKey_Action_6\"));",
		mission.trig.actions[trig_n] = "a_do_script_file(getValueResourceByKey('ResKey_Action_"..mission.maxDictId.."')); mission.trig.func[" .. trig_n .. "]=nil;"
	else
		--[3] = "a_do_script(\"ctld.JTACAutoLase('JTAC1', 1688, false,\\\"all\\\")\"); mission.trig.func[3]=nil;",		
		mission.trig.actions[trig_n] = s..' mission.trig.func[' .. trig_n .. ']=nil;'

	end

	mission.trig.func[trig_n] = "if mission.trig.conditions[" .. trig_n .. "]() then mission.trig.actions[" .. trig_n .. "]() end"
	mission.trig.flag[trig_n] = true
	mission.trig.conditions[trig_n] = "return(c_time_after(" .. time .. ") )"

	mission.trigrules[trig_n] = {
		['rules'] = {
			[1] = {
				["seconds"] = time,
				["predicate"] = "c_time_after",
			},
		},
		['eventlist'] = '',
		['comment'] = 'Trigger ' .. trig_n,
		['predicate'] = predicat0,

	}
	mission.trigrules[trig_n]['actions'] = Table_trigrulesAction

	-- table.insert(mission.trigrules[trig_n]['actions'], trigrulesAction)
end




--ajoutes les restrictions de loadout dans la table PayloadRestricted
local function makePayloadRestricted()
	local restrictedPathActive = "Active/PayloadRestricted.lua"
	local testPath = io.open(restrictedPathActive, "r")

	if testPath ~= nil then
		io.close(testPath)
		dofile(restrictedPathActive)
	end

	if not PayloadRestricted or next(PayloadRestricted) == nil then
		PayloadRestricted = {}

		local restrictedPath = "Init/restricted_loadout.miz"
		testPath = io.open(restrictedPath, "r")

		if testPath ~= nil then
			io.close(testPath)

			local zipFileResticted = minizip.unzOpen(restrictedPath, 'rb')
			zipFileResticted:unzLocateFile('mission')

			local misRestricted = zipFileResticted:unzReadAllCurrentFile()

			-- Création d'un environnement vide pour éviter d'affecter `mission`
			local env = {}
			local func = loadstring(misRestricted)
			if func then
				setfenv(func, env) -- Exécute dans un environnement isolé
				func()
			end

			-- La mission extraite est maintenant stockée dans env.mission
			if env.mission then
				for _side, side in pairs(env.mission.coalition) do
					for countryN, country in pairs(side.country) do
						for category, groups in pairs(country) do
							if type(groups) == "table" and groups["group"] then
								for Ngroup, group in pairs(groups["group"]) do
									for Nunit, unit in pairs(group.units) do
										if unit.payload and unit.payload.restricted then
											PayloadRestricted[unit.type] = unit.payload.restricted
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
	return PayloadRestricted
end


AddFileTrigger("camp_status.lua")
AddFileTrigger("AddCommandRadioF10.lua")
AddFileTrigger("EventsTracker.lua")
AddFileTrigger("Fuel_Check.lua")													-- Norman99 Modification	M57
AddFileTrigger("ATC_ShutUp_GENERIC.lua")											-- Psyko Modification		M59
AddFileTrigger("GCIdata.lua")
AddFileTrigger("GCIscript.lua")
AddFileTrigger("ARM_Defence_Script.lua")
AddFileTrigger("CustomTasksScript.lua")
AddFileTrigger("CarrierIntoWindScript.lua")
AddFileTrigger("Pedro.lua")
AddFileTrigger("SAR.lua")
AddFileTrigger("Cercle_City.lua")
AddFileTrigger("AirGroundAttackScript.lua")
AddFileTrigger("bombOnRunway.lua")
AddFileTrigger("beacon.ogg", nil, nil, "a_out_sound_c")
AddFileTrigger("beaconsilent.ogg", nil, nil, "a_out_sound_c")
-- AddFileTrigger("CG_ArtySpotter.lua")												--https://www.digitalcombatsimulator.com/fr/files/3339128/


AddFileTriggerTempo("CG_ArtySpotter.lua", 2, "triggerOnce", { [1] = {["Predicate"] = "a_do_script_file"}})


if mission_ini.load_mist then
	AddFileTriggerTempo("mist.lua", 2, "triggerOnce", { [1] = {["Predicate"] = "a_do_script_file"}})	-- modification M60 CTLD
end
if mission_ini.load_CTLD then
	AddFileTriggerTempo("CTLD.lua", 4, "triggerOnce", { [1] = {["Predicate"] = "a_do_script_file"}})	-- modification M60 CTLD
end


----- run scripts to create content of next mission -----
-- dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_Data.lua")
-- dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_DataMap.lua")
-- dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_Functions.lua")


if 	not mission_ini  or mission_ini == nil  then
	dofile("Init/conf_mod.lua")
end


-- UpdateConfMod()

-- if Firstmission_flag then
-- 	ModifiCampInit()
-- end

local jammerOnBoard = {}
for planeType, plane in pairs(Data_divers) do
	if plane and plane.jammer then
		jammerOnBoard[planeType] = plane.jammer

	end
end


camp.SC_FullPlaneOnDeck = mission_ini.SC_FullPlaneOnDeck								-- modification M37.d SuperCarrier
camp.CV_Vmax = Data_configuration.CV_Vmax												-- modification M37.d SuperCarrier
camp.CV_windDeck = Data_configuration.CV_windDeck										-- modification M37.d SuperCarrier
camp.CV_despawnAfterLanding = Data_configuration.CV_despawnAfterLanding				-- modification M18.e despawn (e: option confMod)
camp.SC_CarrierIntoWind = string.lower(mission_ini.SC_CarrierIntoWind)					-- modification M36.d	MenuRadio request manual TurnIntoWind
camp.debug = Debug.debug
-- camp.makeCampaign = Debug.makeCampaign
camp.debugInGamePopup = Debug.debugInGamePopup
camp.theatre = NameTheatreLower
camp.EjectedPilotFrequency = EjectedPilotFrequency
camp.EWR_frequency = ewr

camp.spotter = mission_ini.spotter
camp.spotterAircraft = ListSpotterAircraft()

camp.jammerOnBoard = jammerOnBoard
camp.unitSystem = mission_ini.unitSystem
camp.MinPercentDestroyed = MinPercentDestroyed

if not camp.missionHistory then camp.missionHistory = {} end
camp.missionHistory[camp.mission] = camp.date

local nbTotalClient = 0
for k=1, Multi.NbGroup do
	nbTotalClient = nbTotalClient + Multi.Group[k].NbPlane
end


-- applique silenceATC si true et si auto (multi >= 2)									---- Psyko modification M59_a			silences the tower
if mission_ini.silenceATC and type(mission_ini.silenceATC) == "boolean" then
	camp.silenceATC = true
elseif  mission_ini.silenceATC == "auto" and nbTotalClient >= 2 then
	camp.silenceATC = true
else
	camp.silenceATC = false
end


local verScriptsModPath = "../../../ScriptsMod."..VersionPackageICM.."/UTIL_Changelog.lua"
local TestPath = io.open(verScriptsModPath, "r")
if  TestPath ~= nil then
	io.close(TestPath)
	dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_Changelog.lua")
	camp.ScriptsMod = versionDCE["UTIL_Changelog.lua"]

else
	--OBSOLETE
	local verScriptsModPath = "../../../ScriptsMod."..VersionPackageICM.."/UTIL_Version.lua"
	local TestPath = io.open(verScriptsModPath, "r")
	if  TestPath ~= nil then
		io.close(TestPath)
		dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_Version.lua")
		camp.ScriptsMod = version_ScriptsMod.ScriptsMod
	end

end

if not camp.path or camp.path == nil then												-- modification M35.d version ScriptsMod
	camp.path = os.getenv('pathSavedGames')												-- modification M35.e version ScriptsMod
	camp.path = string.gsub(camp.path, "\\", "/")
end

-- modification M35.d (d: info log) version ScriptsMod
camp["VersionPackageICM"] = VersionPackageICM

if Firstmission_flag then
	camp["MissionFilename"] =  camp.title.."_first.miz"
else
	camp["MissionFilename"] =  camp.title.."_ongoing.miz"
end


-- Vérification et création du fichier de loadout
local loadoutFile01 = "../../../Missions/Campaigns/" .. camp.title .. "/Active/Loadouts_archive.lua"

if not FileExists(loadoutFile01) or Firstmission_flag then
    -- Sérialisation des données
    local loadout_str = "Loadouts_archive = " .. TableSerialization(db_loadouts, 0)

    -- Essayez d'écrire dans le fichier
    local success, err = pcall(function()
        WriteToFile(loadoutFile01, loadout_str)
    end)

    if not success then
        print("Erreur lors de l'écriture dans le fichier : " .. tostring(err))
        os.exit(1) -- Quitte le script proprement en cas d'erreur
    else
        -- print("Fichier créé avec succès : " .. loadoutFile01)
    end
end




EPLRS_Capacity = {}
for planeType, value in PairsByKeys(Data_divers) do
	if value.EPLRS_Capacity then
		EPLRS_Capacity[planeType] = true
	end
end

--si ADD_data existe, on le precharge pour l'ajouter au DATA centram
local addDataFile02 = "../../../Missions/Campaigns/"..camp.title.."/Init/ADD_data.lua"
local TestPathADD_addData = io.open(addDataFile02, "r")										--cette maniere de chercher la presence d un fichier evite un plantage
if TestPathADD_addData ~= nil  then														--check si le fichier existe dans ScriptsMod
	dofile("../../../Missions/Campaigns/"..camp.title.."/Init/ADD_data.lua")

	if add_EPLRS_Capacity then
		for key , value in pairs(add_EPLRS_Capacity) do
			if not EPLRS_Capacity[key] then
				EPLRS_Capacity[key] = true
			end
		end
	end

	if add_TaskByPlane then
		for key , value in pairs(add_TaskByPlane) do
			if not TaskByPlane[key] then
				TaskByPlane[key] = true
			end
		end
	end

end

-- --assign les callsign par squad west
AssignCallnameSquad()



-- Appel de la fonction principale
CheckAndFixAllIds()



--****************************************************************************************
--transferé dans UTIL_Fonctions LoadFileAndUpdate()
--****************************************************************************************

-- dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_CampaignSettings.lua")
-- dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_Refpoints.lua")
-- dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_MissionScore.lua")
-- dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_Data.lua")
-- dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_DataMap.lua")

-- Check_TaskPossibleByPlane()

-- dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_Time.lua")
-- dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_MoonPhase.lua")
-- dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_Weather.lua")
-- dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_NavalEnvironment.lua")
-- dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_UpdateSAR.lua")
-- dofile("../../../ScriptsMod."..VersionPackageICM.."/ATO_ThreatEvaluation.lua")
-- dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_UpdateTargetlist.lua")
-- dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_CheckTriggers.lua")
-- dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_UpdateTargetlist.lua")
-- dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_CheckTriggers.lua")

PayloadRestricted = makePayloadRestricted()


dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_UpdateOOBGround.lua")		-- add oob_ground in mission.coalition..... don't forget ^^

if ArgTools == "KillTarget" then
	dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_Divers.lua")
end

dofile("../../../ScriptsMod."..VersionPackageICM.."/ATO_ThreatEvaluation.lua")
dofile("../../../ScriptsMod."..VersionPackageICM.."/ATO_RouteGenerator.lua")
dofile("../../../ScriptsMod."..VersionPackageICM.."/ATO_Generator.lua")
dofile("../../../ScriptsMod."..VersionPackageICM.."/ATO_PlayerAssign.lua")
dofile("../../../ScriptsMod."..VersionPackageICM.."/ATO_Timing.lua")
dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_AddPropAircraft.lua")
dofile("../../../ScriptsMod."..VersionPackageICM.."/ATO_FlightPlan.lua")
dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_StaticAircraft.lua")
dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_Prune.lua")
dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_Briefing.lua")


-- Supprime le fichier sans vérifier s'il existe
os.remove("Debug/BugList.lua")

if BugList and type(BugList) == "table" and #BugList >= 1 then
	local table_Str = "BugList = " .. TableSerialization(BugList, 0)
	local bugFile = io.open("Debug/BugList.lua", "w") or error("Failed to open debug file")
	bugFile:write(table_Str)
	bugFile:close()
end
dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_Debug.lua")


camp["groundthreats"] = groundthreats


mission.currentKey = 1010000															--not clear how this works but is required for multiplyer clients to be available for selection on mission start

--########   1   ##############
--check les doublons de name, groupId et unitId
local GroupId = {}
local uniId = {}
local name = {}
local groupIdError = {}
local minGroupId = 999999
local maxGroupId = 0
local unitIdError = {}
local minUnitId = 999999
local maxUnitId = 0

for side_name, side in pairs(mission.coalition) do																--iterate through sides
	for country_n, country_ in pairs(side.country) do															--iterate through countries
		for categorie, categorie_ in pairs(country_) do
			if type(categorie_) == "table" and categorie_.group then
				for _group, group in pairs(categorie_) do
					for groupN, group_ in pairs(group) do

						if group_.groupId > maxGroupId then
							maxGroupId = group_.groupId
						end
						if group_.groupId < minGroupId then
							minGroupId = group_.groupId
						end

						if not  name[group_.name] then
							name[group_.name] = group_.name
						else
							-- print("MainNM error, duplicate of |"..categorie.."| name |".. name[group_.name] .."|and|"..tostring(group_.name))
							-- os.execute 'pause'
						end

						if not  GroupId[group_.groupId] then
							GroupId[group_.groupId] = group_.groupId
						else
							-- print("MainNM error, duplicate of |"..categorie.."| OLD GroupId |".. GroupId[group_.groupId].."|and|"..tostring(group_.name) )

							table.insert(groupIdError,group_.name )
						end

						for unitN, unit in ipairs(group_.units) do

							if unit.unitId > maxUnitId then
								maxUnitId = unit.unitId
							end
							if unit.unitId < minUnitId then
								minUnitId = unit.unitId
							end

							if not  uniId[unit.unitId] then
								uniId[unit.unitId] = unit.unitId
							else
								-- print("MainNM error, duplicate of |"..tostring(categorie).."| OLD uniId |".. tostring(uniId[unit.unitId]) .."|and|"..tostring(unit.name))
								table.insert(unitIdError,unit.name )
							end

						end
					end
				end
			end
		end
	end
end
print()
--renumerote automatiquement le groupId en doublon
for nError , refName in pairs(groupIdError) do

	local nTentative = 0
	local found = false
	local testId = 1
	if minGroupId > 1 then
		repeat
			testId = math.random(1,minGroupId)
			if not GroupId[testId] then
				found = true
			end
			nTentative = nTentative + 1
		until found or nTentative > 50
	end

	if not found then
		repeat
			testId = math.random(minGroupId,maxGroupId)
			if not GroupId[testId] then
				found = true
			end
			nTentative = nTentative + 1
		until found or nTentative > 500
	end

	if not found then
		testId =  maxGroupId + 1
	end

	if testId > maxGroupId then
		maxGroupId = testId
	end
	if testId < minGroupId then
		minGroupId = testId
	end

	--change l'Id dans la mission
	for side_name, side in pairs(mission.coalition) do																--iterate through sides
		for country_n, country_ in pairs(side.country) do															--iterate through countries
			for categorie, categorie_ in pairs(country_) do
				if type(categorie_) == "table" and categorie_.group then
					for _group, group in pairs(categorie_) do
						for groupN, group_ in pairs(group) do
							if group_.name == refName then
								-- print("MainNM MISSION update NEW GroupId |"..testId.."| GroupName |".. group_.name)
								group_.groupId = testId
							end
						end
					end
				end
			end
		end
	end

	-- --change l'Id dans oobGround, pour ne pas recommencer
	-- for side_name, side in pairs(oob_ground) do																--iterate through sides
	-- 	for countryN, country in pairs(side) do															--iterate through countries
	-- 		for categorieN, categories in pairs(country) do
	-- 			if type(categories) == "table" and categories.group then
	-- 				for _group, groups in pairs(categories) do
	-- 					for groupN, group in pairs(groups) do
	-- 						-- print("MainNM group.name "..group.name.." refName: "..refName)
	-- 						if group.name == refName then
	-- 							-- print("MainNM oob_ground update NEW GroupId |"..testId.."| GroupName |".. group.name)
	-- 							group.groupId = testId
	-- 						end
	-- 					end
	-- 				end
	-- 			end
	-- 		end
	-- 	end
	-- end
end
print()

--renumerote automatiquement le uniId en doublon
for nErrorB , refNameB in pairs(unitIdError) do

	local nTentative = 0
	local found = false
	local testId = 1
	if minUnitId > 1 then
		repeat
			testId = math.random(1,minUnitId)
			if not uniId[testId] then
				found = true
			end
			nTentative = nTentative + 1
		until found or nTentative > 50
	end

	if not found then
		repeat
			testId = math.random(minUnitId,maxUnitId)
			if not uniId[testId] then
				found = true
			end
			nTentative = nTentative + 1
		until found or nTentative > 500
	end

	if not found then
		testId =  maxUnitId + 1
	end

	if testId > maxUnitId then
		maxUnitId = testId
	end
	if testId < minUnitId then
		minUnitId = testId
	end

	for side_nameB, sideB in pairs(mission.coalition) do																--iterate through sides
		for NcountryB, countryB in pairs(sideB.country) do															--iterate through countries
			for NcategorieB, categorieB in pairs(countryB) do
				if type(categorieB) == "table" and categorieB.group then
					for _groupB, groupsB in pairs(categorieB) do
						for groupNB, groupB in pairs(groupsB) do

							for unitNB, unitB in ipairs(groupB.units) do
								if unitB.name == refNameB then
									-- print("MainNM update MISSION NEW uniId |"..testId.."| groupName |".. groupB.name.."| unitName |".. unitB.name)
									unitB.unitId = testId

									-- print("MainNM new uniId? "..tostring(categorieB[_groupB][groupNB].units[unitNB].unitId))
								end
							end

						end
					end
				end
			end
		end
	end
	-- --change l'Id dans oobGround, pour ne pas recommencer
	-- for side_name, side in pairs(oob_ground) do																--iterate through sides
	-- 	for countryN, country in pairs(side) do															--iterate through countries
	-- 		for categorieN, categories in pairs(country) do
	-- 			if type(categories) == "table" and categories.group then
	-- 				for _group, groups in pairs(categories) do
	-- 					for groupN, group in pairs(groups) do
	-- 						for unitN, unit in ipairs(group.units) do	
	-- 							if unit.name == refNameB then
	-- 								-- print("MainNM update OOPGROUND NEW uniId |"..testId.."| groupName |".. group.name.."| unitName |".. unit.name)
	-- 								unit.unitId = testId
	-- 							end
	-- 						end
	-- 					end
	-- 				end
	-- 			end
	-- 		end
	-- 	end
	-- end
end

--########   2   ##############
--check les doublons de name, groupId et unitId
local GroupId = {}
local uniId = {}
local name = {}
local groupIdError = {}
local minGroupId = 999999
local maxGroupId = 0
local unitIdError = {}
local minUnitId = 999999
local maxUnitId = 0

for side_name, side in pairs(mission.coalition) do																--iterate through sides
	for country_n, country_ in pairs(side.country) do															--iterate through countries
		for categorie, categorie_ in pairs(country_) do
			if type(categorie_) == "table" and categorie_.group then
				for _group, group in pairs(categorie_) do
					for groupN, group_ in pairs(group) do

						if not  name[group_.name] then
							name[group_.name] = group_.name
						else
							print("MainNM error, duplicate of name |"..categorie.."| |".. name[group_.name] .."| and |"..tostring(group_.name))
							os.execute 'pause'
						end

						if not  GroupId[group_.groupId] then
							-- GroupId[group_.groupId] = group_.groupId
							GroupId[group_.groupId] = group_.name
						else
							print("MainNM error, duplicate of GroupId |"..categorie.."| |".. GroupId[group_.groupId].."| and |"..tostring(group_.name)
						)
							os.execute 'pause'
						end

						for unitN, unit in ipairs(group_.units) do

							if not  uniId[unit.unitId] then
								-- uniId[unit.unitId] = unit.unitId
								uniId[unit.unitId] = unit.name
							else
								if Debug.debug then
									print("MainNM error debug, duplicate of unitId |"..tostring(categorie).."| Clone1: |"..unit.unitId.." |unitId| ".. tostring(uniId[unit.unitId]) .."| Clone2: |"..tostring(unit.name))
									os.execute 'pause'
								end
							end
						end
					end
				end
			end
		end
	end
end

--supprime les informations de DCE dans le fichier mission

if Debug.allUnhide then
	for side_name, side in pairs(mission.coalition) do																--iterate through sides
		for country_n, country_ in pairs(side.country) do															--iterate through countries
			for categorie, categorie_ in pairs(country_) do
				if type(categorie_) == "table" and categorie_.group then
					for _group, groups in pairs(categorie_) do
						for groupN, group in pairs(groups) do

							if group.hidden then
								group.hidden = false
							end

						end
					end
				end
			end
		end
	end
end

--met à jour ce lien dans le fichier mission
--FARP-Paphos-Beacon etc example
for side_name, side in pairs(mission.coalition) do
	for country_n, country in pairs(side.country) do
		if type(country) == "table" then
			for typeChapter, chapter in pairs(country) do
				if type(chapter) == "table" then
					for groupN, group in ipairs(chapter.group) do
						if group.route.points[1]  and group.route.points[1].task then
							if group.route.points[1].task.params.tasks then
								for taskN, task in ipairs(group.route.points[1].task.params.tasks) do
									if task.params and task.params.action and task.params.action.id and task.params.action.id == "TransmitMessage" then

										if oldMapResource[task.params.action.params.file] == "beacon.ogg" then
											mission.maxDictId = mission.maxDictId + 1
											task.params.action.params.subtitle = "DictKey_subtitle_"..mission.maxDictId
											dictionary["DictKey_subtitle_" .. mission.maxDictId] = ""

											mission.maxDictId = mission.maxDictId + 1
											task.params.action.params.file = "ResKey_advancedFile_"..mission.maxDictId

											mapResource["ResKey_advancedFile_" .. mission.maxDictId] = "beacon.ogg"


										else
											--garde le nom du fichier autre que beacon
											local tempOldFile = Deepcopy(oldMapResource[task.params.action.params.file])

											mission.maxDictId = mission.maxDictId + 1
											task.params.action.params.subtitle = "DictKey_subtitle_"..mission.maxDictId
											mission.maxDictId = mission.maxDictId + 1
											task.params.action.params.file = "ResKey_advancedFile_"..mission.maxDictId

											mapResource["ResKey_advancedFile_" .. mission.maxDictId] = tempOldFile

										end

									end
								end
							end
						end
					end
				end
			end
		end
	end
end

-- if camp.waitingNextGen then
-- 	camp.waitingNextGen = false
-- end
-- --permet d'avancer l'horaire entre 2 missions
-- if Skipmission_flag then
-- 	if camp.waitingNextGen then
-- 		camp.waitingNextGen = false
-- 	end
-- end

camp.waitingNextGen = false

if not (EndCampaign or camp.endCampaign )then
	dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_EndCampaign.lua")
end

if ListRequiredModules then
	local infoShow = false
	for nameN, module in pairs(ListRequiredModules) do

		if module and module ~= nil then

			if not infoShow then
				print("Note that this mission requires these modules:")
				infoShow = true
			end
			print("\n - "..tostring(module.name))

			for n, origine in pairs(module.origine) do
				print(" - -------==> from: "..tostring(origine))

			end
		end
	end
	-- _affiche(mission.requiredModules, "MainNM mission.requiredModules ")
	-- os.execute 'pause'
end

----- convert tables back to strings for insertion into content files -----
local misStr = "mission = " .. TableSerialization(mission, 0)
local optStr = "options = " .. TableSerialization(options, 0)
local warStr = "warehouses = " .. TableSerialization(warehouses, 0)
local dicStr = "dictionary = " .. TableSerialization(dictionary, 0)
local resStr = "mapResource = " .. TableSerialization(mapResource, 0)
local gciStr = "GCI = " .. TableSerialization(GCI, 0)
local cmpStr = "camp = " .. TableSerialization(camp, 0)

----- create temporary content files of new mission file -----
local misFile = io.open("misFile.lua", "w") or error("Failed to open debug file")											--mission
misFile:write(misStr)
misFile:close()

local optFile = io.open("optFile.lua", "w") or error("Failed to open debug file")											--options
optFile:write(optStr)
optFile:close()

local warFile = io.open("warFile.lua", "w") or error("Failed to open debug file")											--warehouses
warFile:write(warStr)
warFile:close()

local dicFile = io.open("dicFile.lua", "w") or error("Failed to open debug file")											--dictionary
dicFile:write(dicStr)
dicFile:close()

local resFile = io.open("resFile.lua", "w")	 or error("Failed to open debug file")										--mapResource
resFile:write(resStr)
resFile:close()

local gciFile = io.open("GCIdata.lua", "w") or error("Failed to open debug file")											--GCI data file (EWR radars, AWACS, interceptors)
gciFile:write(gciStr)
gciFile:close()

local cmpFile = io.open("Active/camp_status.lua", "w") or error("Failed to open debug file")								--campaign status file
cmpFile:write(cmpStr)
cmpFile:close()


-- met à jour la date de camp dans conf_mod.lua
UpdateConfMod(nil, camp.date, "MAIN_NextMission "..debug.getinfo(1).currentline)

----- create new mission file and add content files -----

local NbMission  = tostring(camp.mission)

if mission_ini.backupAllMissionFiles and mission_ini.backupAllMissionFiles == true then
	if not Firstmission_flag then
		NbMission = tostring(camp.mission - 1)
		--en skipMission, la mission n'a pas �t� jou�e, donc c'est la suivante
		if Skipmission_flag then
			NbMission = NbMission + 1
		end
	end

	if string.len(NbMission) > 1 then
		NbMission = "__"..NbMission
	else
		NbMission = "__0"..NbMission
	end
else
	NbMission = "__Old"
end

local miz
if Firstmission_flag then																--is true if script is launched from GenerateFirstMission.lua
	if not (mission_ini.backupAllMissionFiles and mission_ini.backupAllMissionFiles == true) then
		os.remove("../"..camp.title.."/Debriefing/"..camp.title.."_first"..NbMission..".miz")
	end
	os.rename("../"..camp.title.."_first.miz", "../"..camp.title.."/Debriefing/"..camp.title.."_first"..NbMission..".miz")
	miz = minizip.zipCreate("../" .. camp.title .. "_first.miz")					--create the first campaign mission
else																				--is false if script is launched from Debrief_Master.lua
	if Skipmission_flag then
		os.remove( "../"..camp.title.."/Debriefing/"..camp.title.."_ongoing"..NbMission..".miz")
	end
	local res = os.rename("../"..camp.title.."_ongoing.miz", "../"..camp.title.."/Debriefing/"..camp.title.."_ongoing"..NbMission..".miz")
	miz = minizip.zipCreate("../" .. camp.title .. "_ongoing.miz")
end




for filename, content in pairs(existing_files) do
    if content then
        if filename:match("mapResource") or filename:match("dictionary") then
            -- Ajouter directement dans le .miz sans sauvegarde sur disque
            -- miz:zipAddFileFromString(filename, content)
        else
            -- Extraire uniquement le nom du fichier (supprimer "l10n/DEFAULT/")
            local temp_filename = filename:match("[^/]+$")

            -- Écrire dans le répertoire courant
            local temp_file = io.open(temp_filename, "wb")
            if temp_file then
                temp_file:write(content)
                temp_file:close()

                -- Ajouter au fichier .miz avec son chemin original
                miz:zipAddFile(filename, temp_filename)

                -- Supprimer le fichier temporaire
                os.remove(temp_filename)
            else
                print("⚠️ Impossible d'écrire le fichier temporaire : " .. temp_filename)
            end
        end
    else
        print("⚠️ Contenu vide ou nil pour le fichier : " .. filename)
    end
end




miz:zipAddFile("mission", "misFile.lua")
miz:zipAddFile("options", "optFile.lua")
miz:zipAddFile("warehouses", "warFile.lua")
miz:zipAddFile("l10n/DEFAULT/dictionary", "dicFile.lua")
miz:zipAddFile("l10n/DEFAULT/mapResource", "resFile.lua")
miz:zipAddFile("l10n/DEFAULT/EventsTracker.lua", "../../../ScriptsMod."..VersionPackageICM.."/Mission Scripts/EventsTracker.lua")
miz:zipAddFile("l10n/DEFAULT/GCIdata.lua", "GCIdata.lua")
miz:zipAddFile("l10n/DEFAULT/GCIscript.lua", "../../../ScriptsMod."..VersionPackageICM.."/Mission Scripts/GCIscript.lua")
miz:zipAddFile("l10n/DEFAULT/ARM_Defence_Script.lua", "../../../ScriptsMod."..VersionPackageICM.."/Mission Scripts/ARM_Defence_Script.lua")
miz:zipAddFile("l10n/DEFAULT/CustomTasksScript.lua", "../../../ScriptsMod."..VersionPackageICM.."/Mission Scripts/CustomTasksScript.lua")
miz:zipAddFile("l10n/DEFAULT/AirGroundAttackScript.lua", "../../../ScriptsMod."..VersionPackageICM.."/Mission Scripts/AirGroundAttackScript.lua")
miz:zipAddFile("l10n/DEFAULT/CarrierIntoWindScript.lua", "../../../ScriptsMod."..VersionPackageICM.."/Mission Scripts/CarrierIntoWindScript.lua")
miz:zipAddFile("l10n/DEFAULT/AddCommandRadioF10.lua", "../../../ScriptsMod."..VersionPackageICM.."/Mission Scripts/AddCommandRadioF10.lua")				-- Modification M29
miz:zipAddFile("l10n/DEFAULT/Fuel_Check.lua", "../../../ScriptsMod."..VersionPackageICM.."/Mission Scripts/Fuel_Check.lua")								-- Norman99 modification M57_a
miz:zipAddFile("l10n/DEFAULT/ATC_ShutUp_GENERIC.lua", "../../../ScriptsMod."..VersionPackageICM.."/Mission Scripts/ATC_ShutUp_GENERIC.lua")				-- Psyko modification M59_a
miz:zipAddFile("l10n/DEFAULT/Pedro.lua", "../../../ScriptsMod."..VersionPackageICM.."/Mission Scripts/Pedro.lua")										-- Pedro TEST
miz:zipAddFile("l10n/DEFAULT/camp_status.lua", "Active/camp_status.lua")
miz:zipAddFile("l10n/DEFAULT/debugGenMission.txt", "Debug/debugGenMission.txt")
miz:zipAddFile("l10n/DEFAULT/debugFlight.txt", "Debug/debugFlight.txt")
miz:zipAddFile("l10n/DEFAULT/SAR.lua", "../../../ScriptsMod."..VersionPackageICM.."/Mission Scripts/SAR.lua")
miz:zipAddFile("l10n/DEFAULT/Cercle_City.lua", "../../../ScriptsMod."..VersionPackageICM.."/Mission Scripts/Cercle_City.lua")
miz:zipAddFile("l10n/DEFAULT/bombOnRunway.lua", "../../../ScriptsMod."..VersionPackageICM.."/Mission Scripts/bombOnRunway.lua")
miz:zipAddFile("l10n/DEFAULT/CG_ArtySpotter.lua", "../../../ScriptsMod."..VersionPackageICM.."/Mission Scripts/CG_ArtySpotter.lua")


miz:zipAddFile("l10n/DEFAULT/beacon.ogg", "../../../ScriptsMod."..VersionPackageICM.."/Mission Scripts/beacon.ogg")											-- modification M60 CTLD
miz:zipAddFile("l10n/DEFAULT/beaconsilent.ogg", "../../../ScriptsMod."..VersionPackageICM.."/Mission Scripts/beaconsilent.ogg")
miz:zipAddFile("l10n/DEFAULT/ejectionRadioBeacon.ogg", "../../../ScriptsMod."..VersionPackageICM.."/Mission Scripts/ejectionRadioBeacon.ogg")

if mission_ini.load_mist then
	miz:zipAddFile("l10n/DEFAULT/mist.lua", "../../../ScriptsMod."..VersionPackageICM.."/Mission Scripts/mist.lua")											-- modification M60 CTLD
end
if mission_ini.load_CTLD then
	miz:zipAddFile("l10n/DEFAULT/CTLD.lua", "../../../ScriptsMod."..VersionPackageICM.."/Mission Scripts/CTLD.lua")											-- modification M60 CTLD
end


local screenTemp = {}
local findValue

for _, filename in ipairs(BriefingImagesB) do
	findValue = false

	for _, fileTemp in ipairs(screenTemp) do
		if filename == fileTemp then
			findValue = true
			break
		end
	end

	if not findValue then
		table.insert(screenTemp, filename)
	end
end



for _,  filename in ipairs(BriefingImagesR) do
	findValue = false

	for _, fileTemp in ipairs(screenTemp) do
		if filename == fileTemp then
			findValue = true
			break
		end
	end

	if not findValue then
		table.insert(screenTemp, filename)
	end
end

-- Fonction de similarité (basique, mais efficace pour ce cas)
local function areSimilar(str1, str2)
    if #str1 == #str2 then
        return true
    elseif math.abs(#str1 - #str2) <= 3 then -- Tolérance sur la longueur
        return true
    end
    return false
end

for _, filename in ipairs(screenTemp) do
    if type(filename) == "string" and string.len(filename) > 0 then
        local file_path = "Images/" .. filename

        -- Vérification d'existence du fichier
        local file = io.open(file_path, "rb")
        if file then
            file:close()

            -- On extrait juste le nom du fichier sans le chemin
            local actual = file_path:sub(8) -- Supprime "Images/"
            local expected = filename

            -- Vérification uniquement si les noms semblent similaires
            if areSimilar(expected, actual) and expected ~= actual then
                print("  Potential problem with encoding or invisible characters :")
                print(" -> Expected name : " .. expected)
                print(" -> Real name    : " .. actual)
                print(" -> Bytes expected:", string.byte(expected, 1, #expected))
                print(" -> Bytes real   :", string.byte(actual, 1, #actual))
            end

            -- Ajout au zip si tout va bien
            miz:zipAddFile("l10n/DEFAULT/" .. filename, file_path)
        else
            print("  File not found : " .. file_path)
        end
    end
end




miz:zipAddFile("l10n/DEFAULT/alarme.wav" , "Sounds/alarme.wav")


miz:zipClose()




----- remove temporary content files -----
os.remove("misFile.lua")
os.remove("optFile.lua")
os.remove("warFile.lua")
os.remove("dicFile.lua")
os.remove("resFile.lua")
os.remove("GCIdata.lua")

if not Debug.debug then
	--delete mission temporary files
	os.remove("../"..camp.title.."/Debug/debugFlight.txt")
	-- os.remove("../"..camp.title.."/Debug/briefingDescriptionText.txt")
	-- os.remove("../"..camp.title.."/Debug/briefing.txt")
	os.remove("../"..camp.title.."/Debug/debugGenMission.txt")
end


----- save updated status files  -----
table.sort(oob_air.blue, function(a, b) return a.type:upper() < b.type:upper() end)
table.sort(oob_air.red, function(a, b) return a.type:upper() < b.type:upper() end)
local air_str = "oob_air = " .. TableSerialization(oob_air, 0)								--make a string
-- if TypeAlias then
-- 	air_str = air_str .. "TypeAlias = " .. TableSerialization(TypeAlias, 0)
-- end
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

local scen_str = "oob_scen = " .. TableSerialization(oob_scen, 0)							--make a string
local scenFile = io.open("Active/oob_scen.lua", "w") or error("Failed to open debug file")
scenFile:write(scen_str)																	--save new data
scenFile:close()

local trigStr = "camp_triggers = " .. TableSerializationAG_triggers(camp_triggers, 0)
local trigFile = io.open("Active/camp_triggers.lua", "w") or error("Failed to open debug file")
trigFile:write(trigStr)
trigFile:close()


-- local miss_str = "last_Mission = " .. TableSerialization(mission, 0)						--make a string
-- local missFile = io.open("Active/last_Mission.lua", "w") or error("Failed to open debug file")
-- missFile:write(miss_str)															--save new data
-- missFile:close()

local miss_str = "last_Mission = " .. TableSerialization(mission, 0, { writeNumericTable = true })						--make a string
local missFile = io.open("Active/last_Mission.lua", "w") or error("Failed to open debug file")
missFile:write(miss_str)															--save new data
missFile:close()


if not (EndCampaign or camp.endCampaign) then
	local loadout_str = "Loadouts_archive = " .. TableSerialization(Loadouts_archive, 0)	--make a string
	local loadoutFile = io.open("Active/Loadouts_archive.lua", "w") or error("Failed to open debug file")
	loadoutFile:write(loadout_str)																--save new data
	loadoutFile:close()
end
--M40_k
local airbases_Str = "db_airbases = " .. TableSerialization(db_airbases, 0)
local trigFile = io.open("Active/db_airbases.lua", "w") or error("Failed to open debug file")
trigFile:write(airbases_Str)
trigFile:close()

if camp_ZoneSAR then
	local ZoneSAR_str = "camp_ZoneSAR = " .. TableSerialization(camp_ZoneSAR, 0)					--make a string
	local ZoneSARFile = io.open("Active/camp_ZoneSAR.lua", "w") or error("Failed to open debug file")
	ZoneSARFile:write(ZoneSAR_str)																	--save new data
	ZoneSARFile:close()
end



camp.timeJump = false


if Debug.debug or mission_ini.backupAllMissionFiles then
    local fileName
    local folderName = "Debug" -- Pas de `/` au début pour chemin relatif sous Windows

    if Firstmission_flag then
        fileName = camp.title .. "_first.miz"

        -- Créer le répertoire "mission_01" s'il n'existe pas
        folderName = folderName .. "\\mission_01"
        os.execute('md "' .. folderName .. '" > nul 2>&1') -- Utilise `md` pour Windows

        -- Copier fileName dans folderName
        local sourcePath = "..\\" .. fileName -- Normaliser pour Windows
        local destinationPath = folderName .. "\\" .. fileName
        os.execute('copy "' .. sourcePath .. '" "' .. destinationPath .. '" > nul 2>&1') -- Utilise `copy`

        -- Copier le répertoire "Active" dans folderName
        local activeFolder = "Active" -- Normaliser pour Windows
         os.execute('xcopy "' .. activeFolder .. '" "' .. folderName .. '\\Active" /E /I /Y /Q')

    else
        fileName = camp.title .. "_ongoing.miz"

        -- Créer le répertoire "mission_n" s'il n'existe pas
        folderName = folderName .. "\\mission_" .. string.format("%02d", camp.mission)
        os.execute('md "' .. folderName .. '" > nul 2>&1')

        -- Copier fileName dans folderName
        local sourcePath = "..\\" .. fileName
        local destinationPath = folderName .. "\\" .. fileName
        os.execute('copy "' .. sourcePath .. '" "' .. destinationPath .. '" > nul 2>&1')

        -- Copier le répertoire "Active" dans folderName
        local activeFolder = "Active"
         os.execute('xcopy "' .. activeFolder .. '" "' .. folderName .. '\\Active" /E /I /Y /Q')
    end
end


-- print("MainNM Z camp.date.day: "..tostring(camp.date.day))

-- if Debug.debug then
-- 	local camp_str = "mission = " .. TableSerialization(mission, 0)						--make a string
-- 	local campFile = io.open("Debug/mission_MainNM.lua", "w") or error("Failed to open debug file")
-- 	campFile:write(camp_str)															--save new data
-- 	campFile:close()
-- end

-- print("camp.time B  "..tostring(camp.time).." "..FormatTime(camp.time, "hh:mm"))
