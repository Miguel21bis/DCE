--To generate a new mission file. Unzips template mission, defines content of next missions and packs a new mission file
--Initiated by Debrief_Master.lua, BAT_FirstMission.lua or BAT_RedoMission.lua
------------------------------------------------------------------------------------------------------- 
-- last modification: M90_a cleanCode_i
if not versionDCE then versionDCE = {} end
versionDCE["MAIN_NextMission.lua"] = "2.40.222"
------------------------------------------------------------------------------------------------------- 

if Debug.debug then
	print("START MAIN_NextMission.lua "..versionDCE["MAIN_NextMission.lua"].." =-=-=-=-=-=-=-=-=-=-=-=-=-=-=")
end

local t0 = os.clock()
local t_miz  = 0
local t_lua2File = 0
local t_lua2miz = 0
local t_backup = 0

PlacePA = {}
AltitudeCruise = 5400			--for plane without hcruise
AirbasesCarrier = {}


--Check_TaskPossibleByPlane
----- unpack template mission file ----
local minizip = require('minizip')
local zipFile = minizip.unzOpen("Init/base_mission.miz", 'rb')
local old_miz = minizip.unzOpen("Init/base_mission.miz", 'rb')
local existing_files = {}
local tab_aDoScriptFile = {}

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
--déjà appeler par LoadFileAndUpdate(), et ceci ecrase le mission["start_time"]
--attention, pour que la mission ne démarre pas a l'heure de base_mission, il faut ça:
mission["start_time"] = camp.time																--set mission start time


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
local oldMapResource = DeepCopy(mapResource)

zipFile:unzClose()

if mission.version < 19 then --19ok 18bad
	print("(MainNM) ATTENTION: BaseMission.miz is too old. (prior to DCS version 2.7.0) try to save it again with the mission editor. Or ask the creator of this campaign to provide an update.")
	print("(MainNM) ATTENTION ") os.execute 'pause'
	os.exit()
end

--parse la table original trigrules pour reperer les a_do_script_file 
-- et ainsi garde en mémoire les fichiers à remettre, exemple: ["file"] = "ResKey_Action_34"
for trigN, trig in pairs(mission.trigrules) do
	if trig and trig.actions then
		for actionN, action in pairs(trig.actions) do
			if action and action.predicate == "a_do_script_file" and action.file then
				if oldMapResource[action.file] then
					local entrie = {
						resKey = action.file,
						file = oldMapResource[action.file],
					}
					table.insert(tab_aDoScriptFile, entrie )
				end
			end
		end
	end
end


local scenaryTrigN = #mission.trigrules + 1

---- add trigger to destory scenery objects -----
mission.trig.flag[scenaryTrigN] = true
-- mission.trig.conditions[trig_n] = "return(true)"
mission.trig.conditions[scenaryTrigN] = "return(c_time_after(300) )"
mission.trig.actions[scenaryTrigN] = ""
-- mission.trig.funcStartup[trig_n] = "if mission.trig.conditions["..trig_n.."]() then mission.trig.actions["..trig_n.."]() end"
mission.trig.func[scenaryTrigN] = "if mission.trig.conditions["..scenaryTrigN.."]() then mission.trig.actions["..scenaryTrigN.."]() end"
mission.trigrules[scenaryTrigN] = {
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

List_zoneId = {}

if mission.triggers.zones then
	for zoneN, zone in pairs(mission.triggers.zones) do
		if zone and zone.zoneId and not List_zoneId[zone.zoneId] then
			List_zoneId[zone.zoneId] = true
		end
	end
end


--recherche un zoneId libre
local function GetFreeZoneId()
	local zoneId = 1
	local maxZoneId = 1000
	while List_zoneId[zoneId] do
		zoneId = zoneId + 1
		if zoneId > maxZoneId then
			error("MainNM GetFreeZoneId: No free zoneId found after " .. maxZoneId .. " attempts")
		end
	end
	List_zoneId[zoneId] = true
	return zoneId
end


--attention, ne pas activer ici oob_scen, sinon cela ne prend pas en compte son update
-- require("Active/oob_scen")
local addTriggersZOne
local destN = 0
for scen_name, scen in pairs(oob_scen) do											--iterate through destroyed scenery objects
	if destN <= 5 and scen.x and scen.y then														--destroyed scenery object has x and z coordinates

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

		if not isForest then
			addTriggersZOne = true
			local zoneId = GetFreeZoneId()

			--add trigger zone
			local dataZone = {
				["x"] = scen.x,
				["y"] = scen.y,
				["radius"] = radius,
				["zoneId"] = zoneId,
				["color"] =
				{
					[1] = 1,
					[2] = 1,
					[3] = 1,
					[4] = 0.15,
				},
				["hidden"] = true,
				-- ["name"] = "ScenKillZone_" .. (#mission.trigrules[trig_n].actions + 1).."_"..tostring(scen_name),
				["name"] = "SceneryDestroyZone" .. zoneId,
			}

			table.insert(mission.triggers.zones, dataZone)

			--add trigger
			mission.trig.actions[scenaryTrigN] = mission.trig.actions[scenaryTrigN] ..  "a_scenery_destruction_zone(" .. zoneId .. ", ".. txDestruction..");"

			mission.trigrules[scenaryTrigN].actions[#mission.trigrules[scenaryTrigN].actions + 1] = {
				["ai_task"] = {
					[1] = "",
					[2] = "",
				},
				["predicate"] = "a_scenery_destruction_zone",
				["destruction_level"] = txDestruction,
				["zone"] = zoneId,
				["type"] = 0,
			}

			destN = destN + 1
		end
	end
	
end

if addTriggersZOne then
	mission.trig.actions[scenaryTrigN] = mission.trig.actions[scenaryTrigN]  ..' mission.trig.func[' .. scenaryTrigN .. ']=nil;'
end
-----------------------------------------------------------------------
mapResource =
{
} -- end of mapResource


for nFile, data in pairs(tab_aDoScriptFile) do
	mapResource[data.resKey] = data.file
end

----- prepare triggers to run files in mission -----
-- local trig_n = 1
local function addFileTrigger(filename, cond0, predicate1, predicate2)

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
	-- trig_n = trig_n + 1
	local trig_n =  #mission.trigrules + 1										--next available trigger number
	mapResource["ResKey_Action_" .. mission.maxDictId] = filename
	mission.trig.funcStartup[trig_n] = "if mission.trig.conditions[" .. trig_n .. "]() then mission.trig.actions[" .. trig_n .. "]() end"
	mission.trig.flag[trig_n] = true
	mission.trig.conditions[trig_n] = cond																			--"return(true)"
	--						[1] = "a_do_script_file(getValueResourceByKey(\"ResKey_Action_6\"));",
	if predicate2 == "a_out_sound_c" then
		mission.trig.actions[trig_n] = "a_out_sound_c(\"\", getValueResourceByKey(\"ResKey_Action_" .. mission.maxDictId .. "\"), 0);"
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
function AddFileTriggerTempo(arg_filename, arg_time, arg_predicat0, arg_actionPredicate0)

	mission.maxDictId = mission.maxDictId +1
	local table_trigrulesAction = {}
	-- local trig_n =  #mission.trig.actions + 1										--next available trigger number
	local trig_n =  #mission.trigrules + 1										--next available trigger number
	local s = ""

	for key, value in ipairs(arg_actionPredicate0) do
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

		table.insert(table_trigrulesAction, trigrulesAction)
	end


	if arg_filename and arg_filename ~= "" then
		mapResource["ResKey_Action_" .. mission.maxDictId] = arg_filename
		--							[1] = "a_do_script_file(getValueResourceByKey(\"ResKey_Action_6\"));",
		mission.trig.actions[trig_n] = "a_do_script_file(getValueResourceByKey('ResKey_Action_"..mission.maxDictId.."')); mission.trig.func[" .. trig_n .. "]=nil;"
	else
		--[3] = "a_do_script(\"ctld.JTACAutoLase('JTAC1', 1688, false,\\\"all\\\")\"); mission.trig.func[3]=nil;",		
		mission.trig.actions[trig_n] = s..' mission.trig.func[' .. trig_n .. ']=nil;'

	end

	mission.trig.func[trig_n] = "if mission.trig.conditions[" .. trig_n .. "]() then mission.trig.actions[" .. trig_n .. "]() end"
	mission.trig.flag[trig_n] = true
	mission.trig.conditions[trig_n] = "return(c_time_after(" .. arg_time .. ") )"

	mission.trigrules[trig_n] = {
		['rules'] = {
			[1] = {
				["seconds"] = arg_time,
				["predicate"] = "c_time_after",
			},
		},
		['eventlist'] = '',
		['comment'] = 'Trigger ' .. trig_n,
		['predicate'] = arg_predicat0,

	}
	mission.trigrules[trig_n]['actions'] = table_trigrulesAction

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
				for _, side in pairs(env.mission.coalition) do
					for _, country in pairs(side.country) do
						for _, groups in pairs(country) do
							if type(groups) == "table" and groups["group"] then
								for _, group in pairs(groups["group"]) do
									for _, unit in pairs(group.units) do
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


addFileTrigger("camp_status.lua")
addFileTrigger("AddCommandRadioF10.lua")
addFileTrigger("EventsTracker.lua")
addFileTrigger("Fuel_Check.lua")													-- Norman99 Modification	M57
addFileTrigger("ATC_ShutUp_GENERIC.lua")											-- Psyko Modification		M59
addFileTrigger("GCIdata.lua")
addFileTrigger("GCIscript.lua")
addFileTrigger("ARM_Defence_Script.lua")
addFileTrigger("CustomTasksScript.lua")
addFileTrigger("CarrierIntoWindScript.lua")
addFileTrigger("Pedro.lua")
addFileTrigger("SAR.lua")
addFileTrigger("Cercle_City.lua")
addFileTrigger("AirGroundAttackScript.lua")
addFileTrigger("bombOnRunway.lua")
addFileTrigger("beacon.ogg", nil, nil, "a_out_sound_c")
addFileTrigger("beaconsilent.ogg", nil, nil, "a_out_sound_c")
-- AddFileTrigger("CG_ArtySpotter.lua")												--https://www.digitalcombatsimulator.com/fr/files/3339128/

if AAA_Barrage then
	AddFileTriggerTempo("AAA_barrage.lua", 1.5, "triggerOnce", { [1] = {["Predicate"] = "a_do_script_file"}})
end

AddFileTriggerTempo("CG_ArtySpotter.lua", 2, "triggerOnce", { [1] = {["Predicate"] = "a_do_script_file"}})

if mission_ini.load_mist then
	AddFileTriggerTempo("mist.lua", 2, "triggerOnce", { [1] = {["Predicate"] = "a_do_script_file"}})	-- modification M60 CTLD
end
if mission_ini.load_CTLD then
	AddFileTriggerTempo("CTLD.lua", 4, "triggerOnce", { [1] = {["Predicate"] = "a_do_script_file"}})	-- modification M60 CTLD
end

if not mission_ini  or mission_ini == nil  then
	dofile("Init/conf_mod.lua")
end

local jammerOnBoard = {}
for planeType, plane in pairs(Data_divers) do
	if plane and plane.jammer then
		jammerOnBoard[planeType] = plane.jammer

	end
end

--weather
mission.weather = WeatherParams

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
camp.EWR_frequency = EWR_DB
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
local testPath = io.open(verScriptsModPath, "r")
if testPath ~= nil then
	io.close(testPath)
	dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_Changelog.lua")
	camp.ScriptsMod = versionDCE["UTIL_Changelog.lua"]

else
	--OBSOLETE
	verScriptsModPath = "../../../ScriptsMod."..VersionPackageICM.."/UTIL_Version.lua"
	testPath = io.open(verScriptsModPath, "r")
	if testPath ~= nil then
		io.close(testPath)
		dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_Version.lua")
		camp.ScriptsMod = version_ScriptsMod.ScriptsMod
	end

end

if not camp.path or camp.path == nil then
	camp.path = os.getenv('pathSavedGames')
	camp.path = string.gsub(camp.path, "\\", "/")
end

if not camp.pathDCS or camp.pathDCS == nil then
	camp.pathDCS = os.getenv('pathDCS')
	camp.pathDCS = string.gsub(camp.pathDCS, "\\", "/")
end

-- modification M35.d (d: info log) version ScriptsMod
camp["VersionPackageICM"] = VersionPackageICM

if Firstmission_flag then
	camp["MissionFilename"] =  camp.title.."_first.miz"
else
	camp["MissionFilename"] =  camp.title.."_ongoing.miz"
end

for planeType, value in PairsByKeys(Data_divers) do
	if value.EPLRS_Capacity then
		EPLRS_Capacity[planeType] = true
	end
end

-- --assign les callsign par squad west
AssignCallnameSquad()



-- Appel de la fonction principale
CheckAndFixAllIds()


--ajoute des zones en cours de campagne
--si le fichier add_zones.lua existe, on l'ouvre et on ajoute ses informations à la table mission.zones déjà existante
add_zones = nil   -- même nom, même casse

local addZonesPath = "Init/add_zones.lua"
testPath = io.open(addZonesPath, "r")

print("DCE_Debug MainNM A : Checking for additional zones in "..addZonesPath)

if testPath ~= nil then
	print("DCE_Debug MainNM B : Additional zones found, loading zones from "..addZonesPath)
	io.close(testPath)

	dofile(addZonesPath)

	print("DCE_Debug MainNM C : Merging additional zones into mission triggers add_zones: "..tostring(add_zones))

	if add_zones and type(add_zones) == "table" then

		local count = 0
		for _ in pairs(add_zones) do
			count = count + 1
		end

		print("DCE_Debug MainNM D : Found "..count.." additional zones to add")

		for _, zone in pairs(add_zones) do
			print("DCE_Debug MainNM E : Adding zone "..tostring(zone.name).." with ID "..tostring(zone.zoneId))
			table.insert(mission.triggers.zones, zone)
		end
	end
end


dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_MissionScore.lua")

if MissionInstance >= 2 then
	if Debug.debug then
		print("MissionInstance "..MissionInstance)
		print("LOAD DC_Time from "..tostring("MAIN_NextMission "..debug.getinfo(1).currentline))
	end

	dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_Time.lua")
	dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_MoonPhase.lua")
	dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_Weather.lua")
	dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_NavalEnvironment.lua")
	dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_UpdateSAR.lua")
	
	-- CreatePlageFrequency_A()-- TODO a confirmer qu'il est encore utile cree une table de radio en fonction du canal puis de la wave
	-- CreatePlageFrequency_B()	--cree une table de radio en fonction des wave
	
	dofile("../../../ScriptsMod."..VersionPackageICM.."/ATO_ThreatEvaluation.lua")
	dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_UpdateTargetlist.lua")
	-- if Debug.debug then print ("Lancement VIA Main_NM A 646") end
	dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_CheckTriggers.lua")
	dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_UpdateTargetlist.lua")
	-- if Debug.debug then print ("Lancement VIA Main_NM B 649") end
	dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_CheckTriggers.lua")
end

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

dofile("../../../ScriptsMod." .. VersionPackageICM .. "/ATO_FlightPlan.lua")

if mission.drawings and not mission.drawings.layers[4].objects then
	mission.drawings.layers[4].objects = {}
end

local targetListRequired = {}

if camp.client then
    for clientN, client in pairs(camp.client) do
        if client.target and client.target.attributes and client.target.attributes[1] and client.target.attributes[1] == "Structure" then
			table.insert(targetListRequired, client.target.name)
        end
    end
elseif camp.player then
    if camp.player.target and camp.player.target.attributes and camp.player.target.attributes[1] and camp.player.target.attributes[1] == "Structure" then
		table.insert(targetListRequired, camp.player.target.name)
    end
end

if mission.drawings then
	mission.drawings.layers[4].objects = AddIconLayer(mission.drawings.layers[4].objects, targetListRequired)
end


dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_StaticAircraft.lua")
dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_Prune.lua")
dofile("../../../ScriptsMod." .. VersionPackageICM .. "/DC_Briefing.lua")
dofile("../../../ScriptsMod." .. VersionPackageICM .. "/DC_Final_steps.lua")

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


mission.currentKey = 1500000															--not clear how this works but is required for multiplyer clients to be available for selection on mission start

--########   1   ##############
--########   1   ##############
--check les doublons de name, groupId et unitId
--########   1   ##############
--########   1   ##############

local groupId = {}
local uniId = {}
local name = {}
local groupIdError = {}
local minGroupId = 999999
local maxGroupId = 0
local unitIdError = {}
local minUnitId = 999999
local maxUnitId = 0

for _, side in pairs(mission.coalition) do
	for _, country_ in pairs(side.country) do
		for _, categorie_ in pairs(country_) do
			if type(categorie_) == "table" and categorie_.group then
				for _, group in pairs(categorie_) do
					for _, group_ in pairs(group) do

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
						end

						
						if not groupId[group_.groupId] then
							groupId[group_.groupId] = group_.groupId
						else
							-- print("MainNM error, duplicate of |"..categorie.."| OLD GroupId |".. GroupId[group_.groupId].."|and|"..tostring(group_.name) )

							table.insert(groupIdError, group_.name )
						end

						--TODO ajouter ici une condition pour que les unitId des pistes (FARP et autres) ne soient pas changé
						for _, unit in ipairs(group_.units) do

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
								table.insert(unitIdError, unit.name )
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
for _ , refName in pairs(groupIdError) do

	local nTentative = 0
	local found = false
	local testId = 1
	if minGroupId > 1 then
		repeat
			testId = math.random(1,minGroupId)
			if not groupId[testId] then
				found = true
			end
			nTentative = nTentative + 1
		until found or nTentative > 50
	end

	if not found then
		repeat
			testId = math.random(minGroupId,maxGroupId)
			if not groupId[testId] then
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
	for _, side in pairs(mission.coalition) do																--iterate through sides
		for _, country_ in pairs(side.country) do															--iterate through countries
			for _, categorie_ in pairs(country_) do
				if type(categorie_) == "table" and categorie_.group then
					for _, group in pairs(categorie_) do
						for _, group_ in pairs(group) do
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
end
print()

--renumerote automatiquement le uniId en doublon
for _ , refNameB in pairs(unitIdError) do

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

	for _, sideB in pairs(mission.coalition) do																--iterate through sides
		for _, countryB in pairs(sideB.country) do															--iterate through countries
			for _, categorieB in pairs(countryB) do
				if type(categorieB) == "table" and categorieB.group then
					for _, groupsB in pairs(categorieB) do
						for _, groupB in pairs(groupsB) do

							for _, unitB in ipairs(groupB.units) do
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
end

--########   2   ##############
--check les doublons de name, groupId et unitId
groupId = {}
uniId = {}
name = {}

for _, side in pairs(mission.coalition) do																--iterate through sides
	for _, country_ in pairs(side.country) do															--iterate through countries
		for _, categorie_ in pairs(country_) do
			if type(categorie_) == "table" and categorie_.group then
				for _, group in pairs(categorie_) do
					for _, group_ in pairs(group) do

						if not  name[group_.name] then
							name[group_.name] = group_.name
						else
							-- print("MainNM error, duplicate of name |"..categorie.."| |".. name[group_.name] .."| and |"..tostring(group_.name))
							-- print("DCE debug") os.execute 'pause'
						end

						if not  groupId[group_.groupId] then
							-- GroupId[group_.groupId] = group_.groupId
							groupId[group_.groupId] = group_.name
						else
							-- print("MainNM error, duplicate of GroupId |"..categorie.."| |".. GroupId[group_.groupId].."| and |"..tostring(group_.name))
							-- print("DCE debug") os.execute 'pause'
						end

						for unitN, unit in ipairs(group_.units) do

							if not  uniId[unit.unitId] then
								-- uniId[unit.unitId] = unit.unitId
								uniId[unit.unitId] = unit.name
							else
								if Debug.debug then
									-- print("MainNM error debug, duplicate of unitId |"..tostring(categorie).."| Clone1: |"..unit.unitId.." |unitId| ".. tostring(uniId[unit.unitId]) .."| Clone2: |"..tostring(unit.name))
									-- print("DCE debug") os.execute 'pause'
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
	for _, side in pairs(mission.coalition) do																--iterate through sides
		for _, country_ in pairs(side.country) do															--iterate through countries
			for _, categorie_ in pairs(country_) do
				if type(categorie_) == "table" and categorie_.group then
					for _, groups in pairs(categorie_) do
						for _, group in pairs(groups) do

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
for _, side in pairs(mission.coalition) do
	for _, country in pairs(side.country) do
		if type(country) == "table" then
			for _, chapter in pairs(country) do
				if type(chapter) == "table" then
					for _, group in ipairs(chapter.group) do
						if group.route.points[1]  and group.route.points[1].task then
							if group.route.points[1].task.params.tasks then
								for _, task in ipairs(group.route.points[1].task.params.tasks) do
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
											local tempOldFile = DeepCopy(oldMapResource[task.params.action.params.file])

											_affiche(tempOldFile, "tempOldFile: ")

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


camp.waitingNextGen = false

if not (EndCampaign or camp.endCampaign )then
	dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_EndCampaign.lua")
end

if PlayerFlight then
	
	if ListRequiredModules then
		local infoShow = false
		for _, module in pairs(ListRequiredModules) do

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
	end
end

--cree la table AirbasesCarrier
for baseName, base in pairs(db_airbases) do
	if base.unitname then
		AirbasesCarrier[base.unitname] = true
	end

end

--ajoute dans la table campL.Aircraft_Carriers.side 
-- les noms des CV, CVN et CLA, tout porte aéronef
Aircraft_Carriers = {
	red = {},
	blue = {},
}
for side, coal in pairs(mission.coalition) do
	for _, country in pairs(coal.country) do
		if country.ship then
			for _, shipGroup in pairs(country.ship.group) do
				for _, shipUnit in pairs(shipGroup.units) do
					if shipUnit.name and AirbasesCarrier[shipUnit.name] then

						if Aircraft_Carriers[side] then
							Aircraft_Carriers[side] = {}
						end
						table.insert(Aircraft_Carriers[side], shipUnit.name)

						-- --ajoute le lien pedro <-> porte avions
						-- if pedroLinkCV[shipUnit.name] == nil then
						-- 	pedroLinkCV[shipUnit.name] = {}
						-- end
						-- pedroLinkCV[shipUnit.name].side = side
						-- pedroLinkCV[shipUnit.name].groupName = shipGroup.name
						-- pedroLinkCV[shipUnit.name].unitName = shipUnit.name

					end
				end
			end
		end
	end
end


AAA_Barrage = nil
--ajoute le preset AAA_Barrage s'il a été activé
if mission_ini.preset_AAA_Barrage and type(mission_ini.preset_AAA_Barrage) == "number" then
	if mission_ini.preset_AAA_Barrage > 0 then
		if Preset_AAA and Preset_AAA[mission_ini.preset_AAA_Barrage] then
			AAA_Barrage = Preset_AAA[mission_ini.preset_AAA_Barrage]
		end
	end
end

--création d'un camp pour camp_status InGame nettement plus leger
local campL = {

	debug = Debug.debug,
	debugInGamePopup = Debug.debugInGamePopup,
	debugTraceability = Debug.debugTraceability,                           --??? utile
	path = camp.path,
	title = camp.title,
	mission = camp.mission,
	ScriptsMod = camp.ScriptsMod,
	version = camp.version,
	VersionPackageICM = camp.VersionPackageICM,
	Briefing_text = camp.Briefing_text,                           --??? utile

	date = camp.date,
	--weather
	weather = WeatherParams,

	SC_FullPlaneOnDeck = mission_ini.SC_FullPlaneOnDeck,								-- modification M37.d SuperCarrier
	CV_Vmax = Data_configuration.CV_Vmax,												-- modification M37.d SuperCarrier
	CV_windDeck = Data_configuration.CV_windDeck,										-- modification M37.d SuperCarrier
	CV_despawnAfterLanding = Data_configuration.CV_despawnAfterLanding,				-- modification M18.e despawn (e: option confMod)
	SC_CarrierIntoWind = string.lower(mission_ini.SC_CarrierIntoWind),					-- modification M36.d	MenuRadio request manual TurnIntoWind

	theatre = NameTheatreLower,
	EjectedPilotFrequency = EjectedPilotFrequency,
	EWR_frequency = EWR_DB,
	spotter = mission_ini.spotter,
	spotterAircraft = ListSpotterAircraft(),
	jammerOnBoard = jammerOnBoard,
	unitSystem = mission_ini.unitSystem,
	MinPercentDestroyed = MinPercentDestroyed,
	groundthreats = groundthreats,
	-- player = camp.player,
	-- camp.player.side
	-- camp.player.pack_n
	playerSide = (camp.player and camp.player.side) or "blue",
	playerPackN = (camp.player and camp.player.pack_n) or 1,
	targetPos = camp.targetPos,
	TableTransportPilotNames = camp.TableTransportPilotNames,
	silenceATC = camp.silenceATC,
	runwayCrateres = camp.runwayCraters,
	MissionFilename = camp.MissionFilename,
	boundary = camp.boundary,
	SAR = camp.SAR,
	ShipDamagedLast = camp.ShipDamagedLast,
	ShipHealth = camp.ShipHealth,
	ShipHealth0 = camp.ShipHealth0,
	BaseAirStart = camp.BaseAirStart,
	Aircraft_Carriers = Aircraft_Carriers,
	AAA_Barrage = AAA_Barrage,


	-- if not camp.missionHistory then camp.missionHistory = {} end
	-- camp.missionHistory[camp.mission] = camp.date
}


local c_lua2miz = os.clock()

-- if not camp.date.CampTotalTimeS then
-- 	camp.date.CampTotalTimeS = CampTotalTimeS
-- end
CampTotalTimeS = SecondsBetween(camp.dateInit, camp.date)
CampTotalTimeH = CampTotalTimeS /3600
camp.date.CampTotalTimeS = CampTotalTimeS
camp.date.CampTotalTimeH = CampTotalTimeH

--change la boundary de la mission en fonction du camp
SetBoundaryFromCamp()

-- met à jour la date de camp dans conf_mod.lua
UpdateConfModSuite(nil, camp.date, "MAIN_NextMission "..debug.getinfo(1).currentline)


--on traite tous les fichiers uniquement si ça vaut le coup
--bref, si DCE à trouver un siege au joueur
if PlayerFlight then
	
	local c_miz = os.clock()
		
	----- create temporary content files of new mission file -----
	misStr = "mission = " .. TableSerialization(mission, 0)
	local misFile = io.open("misFile.lua", "w") or error("Failed to open debug file")											--mission
	misFile:write(misStr)
	misFile:close()

	optStr = "options = " .. TableSerialization(options, 0)
	local optFile = io.open("optFile.lua", "w") or error("Failed to open debug file")											--options
	optFile:write(optStr)
	optFile:close()

	warStr = "warehouses = " .. TableSerialization(warehouses, 0)
	local warFile = io.open("warFile.lua", "w") or error("Failed to open debug file")											--warehouses
	warFile:write(warStr)
	warFile:close()

	dicStr = "dictionary = " .. TableSerialization(dictionary, 0)
	local dicFile = io.open("dicFile.lua", "w") or error("Failed to open debug file")											--dictionary
	dicFile:write(dicStr)
	dicFile:close()

	resStr = "mapResource = " .. TableSerialization(mapResource, 0)
	local resFile = io.open("resFile.lua", "w")	 or error("Failed to open debug file")										--mapResource
	resFile:write(resStr)
	resFile:close()

	local gciStr = "GCI = " .. TableSerialization(GCI, 0)
	local gciFile = io.open("GCIdata.lua", "w") or error("Failed to open debug file")											--GCI data file (EWR radars, AWACS, interceptors)
	gciFile:write(gciStr)
	gciFile:close()

	local cmpStr = "camp = " .. TableSerialization(camp, 0)
	local cmpFile = io.open("Active/camp_status.lua", "w") or error("Failed to open debug file")								--campaign status file
	cmpFile:write(cmpStr)
	cmpFile:close()

	local cmpL_Str = "campL = " .. TableSerialization(campL, 0)
	local cmpL_File = io.open("campL.lua", "w") or error("Failed to open debug file")								--campaign status file
	cmpL_File:write(cmpL_Str)
	cmpL_File:close()

	t_lua2miz = t_lua2miz + (os.clock() - c_lua2miz)

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
					print("Impossible d'écrire le fichier temporaire : " .. temp_filename)
				end
			end
		else
			print("Contenu vide ou nil pour le fichier : " .. filename)
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
	-- miz:zipAddFile("l10n/DEFAULT/camp_status.lua", "Active/camp_status.lua")
	miz:zipAddFile("l10n/DEFAULT/camp_status.lua", "campL.lua")
	-- miz:zipAddFile("l10n/DEFAULT/FlightPlan_Generator_Debug.txt", "Debug/FlightPlan_Generator_Debug.txt")
	-- miz:zipAddFile("l10n/DEFAULT/debugFlight.txt", "Debug/debugFlight.txt")
	miz:zipAddFile("l10n/DEFAULT/SAR.lua", "../../../ScriptsMod."..VersionPackageICM.."/Mission Scripts/SAR.lua")

	if camp.theatre  == "Caucasus" then
		miz:zipAddFile("l10n/DEFAULT/Cercle_City.lua", "../../../ScriptsMod."..VersionPackageICM.."/Mission Scripts/Cercle_City.lua")
	end

	miz:zipAddFile("l10n/DEFAULT/bombOnRunway.lua", "../../../ScriptsMod."..VersionPackageICM.."/Mission Scripts/bombOnRunway.lua")
	miz:zipAddFile("l10n/DEFAULT/CG_ArtySpotter.lua", "../../../ScriptsMod."..VersionPackageICM.."/Mission Scripts/CG_ArtySpotter.lua")
	
	if AAA_Barrage then
		miz:zipAddFile("l10n/DEFAULT/AAA_barrage.lua", "../../../ScriptsMod."..VersionPackageICM.."/Mission Scripts/AAA_barrage.lua")
	end

	if not existing_files["l10n/DEFAULT/beacon.ogg"] then
		miz:zipAddFile("l10n/DEFAULT/beacon.ogg", "../../../ScriptsMod."..VersionPackageICM.."/Mission Scripts/beacon.ogg")	
	end

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
				-- print("  File not found : " .. file_path)
				AddLog("Warning: Briefing image file not found: " .. file_path)
			end
		end
	end



	if HumainInterceptor then
		miz:zipAddFile("l10n/DEFAULT/alarme.wav" , "Sounds/alarme.wav")
	end

	miz:zipClose()

	t_miz = t_miz + (os.clock() - c_miz)

end -- PlayerFlight onverture/fermeture du fichier .miz


local c_lua2File = os.clock()

----- remove temporary content files -----
os.remove("misFile.lua")
os.remove("optFile.lua")
os.remove("warFile.lua")
os.remove("dicFile.lua")
os.remove("resFile.lua")
os.remove("GCIdata.lua")
os.remove("campL.lua")

if not Debug.debug then
	--delete mission temporary files
	os.remove("../"..camp.title.."/Debug/debugFlight.txt")
	os.remove("../"..camp.title.."/Debug/FlightPlan_Generator_Debug.txt")
end


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

local miss_str = "last_Mission = " .. TableSerialization(mission, 0, { writeNumericTable = true })						--make a string
local missFile = io.open("Active/last_Mission.lua", "w") or error("Failed to open debug file")
missFile:write(miss_str)															--save new data
missFile:close()

local loadout_str = "Loadouts_archive = " .. TableSerialization(LoadoutsList, 0)	--make a string
local loadoutFile = io.open("Active/Loadouts_archive.lua", "w") or error("Failed to open debug file")
loadoutFile:write(loadout_str)																--save new data
loadoutFile:close()

local airbases_Str = "db_airbases = " .. TableSerialization(db_airbases, 0)
trigFile = io.open("Active/db_airbases.lua", "w") or error("Failed to open debug file")
trigFile:write(airbases_Str)
trigFile:close()

if camp_ZoneSAR then
	local ZoneSAR_str = "camp_ZoneSAR = " .. TableSerialization(camp_ZoneSAR, 0)					--make a string
	local ZoneSARFile = io.open("Active/camp_ZoneSAR.lua", "w") or error("Failed to open debug file")
	ZoneSARFile:write(ZoneSAR_str)																	--save new data
	ZoneSARFile:close()
end

t_lua2File = t_lua2File + (os.clock() - c_lua2File)

--reset TimeJump pour eviter les erreurs de mission suivante
TimeJump = false



----------------------------------------------------------------
-- Crée un dossier s'il n'existe pas (Windows, Lua 5.1, DCS safe)
-- Pourquoi : mkdir ne génère pas d'erreur si le dossier existe
----------------------------------------------------------------
local function ensureDir(path)
    if not path or path == "" then
        return
    end
    os.execute('mkdir "' .. path .. '" >nul 2>nul')
end


----------------------------------------------------------------
-- Liste les fichiers d'un dossier (sans sous-dossiers)
-- Pourquoi : nécessaire pour copie récursive en Lua pur
----------------------------------------------------------------
local function listFiles(path)
    local p = io.popen('dir "' .. path .. '" /b /a-d')
    if not p then
        return {}
    end

    local t = {}
    for file in p:lines() do
        t[#t + 1] = file
    end
    p:close()
    return t
end


----------------------------------------------------------------
-- Liste les sous-dossiers d'un dossier
-- Pourquoi : permet la récursion de copyDir
----------------------------------------------------------------
local function listDirs(path)
    local p = io.popen('dir "' .. path .. '" /b /ad')
    if not p then
        return {}
    end

    local t = {}
    for dir in p:lines() do
        t[#t + 1] = dir
    end
    p:close()
    return t
end


----------------------------------------------------------------
-- Copie un fichier binaire
-- Pourquoi : copie fiable des .miz et fichiers Active
----------------------------------------------------------------
local function copyFile(src, dst)
    local f1 = io.open(src, "rb")
    if not f1 then
        return
    end

    local data = f1:read("*all")
    f1:close()

    local parentDir = dst:match("^(.*)\\[^\\]+$")
    ensureDir(parentDir)

    local f2 = io.open(dst, "wb")
    if not f2 then
        error("Failed to open destination file : " .. tostring(dst))
    end

    f2:write(data)
    f2:close()
end


----------------------------------------------------------------
-- Copie récursive d'un dossier
-- Pourquoi : remplacement propre de xcopy /E
----------------------------------------------------------------
local function copyDir(src, dst)
    ensureDir(dst)

    for _, file in ipairs(listFiles(src)) do
        copyFile(src .. "\\" .. file, dst .. "\\" .. file)
    end

    for _, dir in ipairs(listDirs(src)) do
        copyDir(src .. "\\" .. dir, dst .. "\\" .. dir)
    end
end


----------------------------------------------------------------
-- Sauvegarde Debug / Backup mission
-- Pourquoi : archivage sûr, exécuté UNE fois par mission
----------------------------------------------------------------
local c_backup = os.clock()

function BackupFilesMission()
	if (Debug.debug or mission_ini.backupAllMissionFiles) and PlayerFlight then

		local fileName
		local folderName = "Debug"

		if Firstmission_flag then
			fileName   = camp.title .. "_first.miz"
			folderName = folderName .. "\\mission_01"
		else
			fileName   = camp.title .. "_ongoing.miz"
			folderName = folderName .. "\\mission_" .. string.format("%02d", camp.mission)
		end

		ensureDir(folderName)

		-- Copie du .miz
		copyFile("..\\" .. fileName, folderName .. "\\" .. fileName)

		-- Copie du dossier Active
		copyDir("Active", folderName .. "\\Active")
	end
end

t_backup = t_backup + (os.clock() - c_backup)



	-- print("MAIN_NM test start")

	-- print(string.format(
	-- 	"PERF MainNM: total=%.2fs | t_miz=%.2fs | t_lua2miz=%.2fs | t_lua2File=%.2fs |  t_backup=%.2fs | ",
	-- 	os.clock() - t0,
	-- 	t_miz,
	-- 	t_lua2File,
	-- 	t_lua2miz,
	-- 	t_backup
	-- ))

	-- print("MAIN_NM test fin")

	