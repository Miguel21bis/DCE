--To create fresh status files when a new campaign is started
--Initiated by EventsTracker.lua running from within DCS if the mission was a first campaign mission
--Initated by BAT_FirstMission.lua if a campaign is reset manually
------------------------------------------------------------------------------------------------------- 
-- last modification:  cleanCode_a
if not versionDCE then versionDCE = {} end
versionDCE["UTIL_ResetCampaign.lua"] = "1.12.59"
------------------------------------------------------------------------------------------------------- 
-- cleanCode_a			(a springCleaning)
-- adjustment_c			(c targetList)(b PairsByKeys)(a Firstmission_flag)
-- modification M63_a	compatible Datacard Generator or CombatFlite
-- modification M61_a	SAR
-- modification M55_c	player can change the type of plane (c:triggers part)
-- modification Mxx_a	c# compatible
-- modification M53_a	simplification of the "Reserves" variable 
-- modification M45		compatible with 2.7.0
-- modification M40_f	Template Active GroundGroup moving front (f: sideBase)
-- modification M40		Pedro Helicopter
-- modification M35		version ScriptsMod
-- modification M34_Bl	custom FrequenceRadio (l new file name) (b: move file location)
------------------------------------------------------------------------------------------------------- 


----- random seed -----
local seed = os.time() -- Récupérer un timestamp en secondes
math.randomseed(seed)  -- Initialiser le générateur pseudo-aléatoire

require("Init/camp_init")

if not ChangePlane then
	require("Init/oob_air_init")
	require("Init/camp_triggers_init")
end
require("Init/db_airbases")

--retrocompatibilie location UTIL_DataRadio file
--recherche en priorite le fichier UTIL_DataRadio dans le dossier ScriptsMod puis dans le dossier campagne
local radioFile = "../../../ScriptsMod."..VersionPackageICM.."/UTIL_DataRadio.lua"
local testPath = io.open(radioFile, "r")																--cette maniere de chercer la presence d un fichier evite un plantage
if testPath ~= nil then																					--check si le fichier existe dans ScriptsMod
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

if Firstmission_flag then																				--if the script is called by BAT_FirstMission.lua, then FirstMission is true and camp_status is reset to init. When called by DEBRIEF_Master.lua, block is skipped and camp_camp status carried over in mission is used.
	local camp_str = "camp = " .. TableSerialization(camp, 0)										--make a string of campaign initial status table
	local campFile = io.open("Active/camp_status.lua", "w") or error("Failed to open debug file")
	camp.VersionPackageICM = tostring(VersionPackageICM)											-- modification M35 version ScriptsMod -- ajoute la version du script dans camp_status pour utilisation en fin de mission
	campFile:write(camp_str)																		--write initial status
	campFile:close()
end


-- require("Init/oob_air_init")																		--run initial oob air
for side,unit in pairs(oob_air) do																	----update oob_air to add roster and score table
	for n = 1, #unit do
		unit[n].roster = {
			ready = unit[n].number,																	--number of airframes ready for operations
			lost = 0,																				--number of airframes lost
			damaged = 0																				--number of airframes damaged
		}
		unit[n].score = {
			kills_air = 0,																			--air kills
			kills_ground = 0,																		--ground kills
			kills_ship = 0																			--ship kills
		}
		if unit[n].reserve then
			unit[n].roster.reserve = unit[n].reserve
		end
	end
end

table.sort(oob_air.blue, function(a, b) return a.type:upper() < b.type:upper() end)
table.sort(oob_air.red, function(a, b) return a.type:upper() < b.type:upper() end)

local air_str = "oob_air = " .. TableSerialization(oob_air, 0)										--make a string
local airFile = io.open("Active/oob_air.lua", "w") or error("Failed to open debug file")
airFile:write(air_str)																				--write initial data
airFile:close()

local tgt_str = "targetlist = " .. TableSerialization(targetlist, 0)								--make a string
local tgtFile = io.open("Active/targetlist.lua", "w") or error("Failed to open debug file")
tgtFile:write(tgt_str)																				--write initial data
tgtFile:close()

local ground_str = "oob_ground = {}"
local groundFile = io.open("Active/oob_ground.lua", "w") or error("Failed to open debug file")
groundFile:write(ground_str)																		--write initial data
groundFile:close()

local scen_str = "oob_scen = {}"
local scenFile = io.open("Active/oob_scen.lua", "w") or error("Failed to open debug file")
scenFile:write(scen_str)																			--write initial file
scenFile:close()

local client_str = "clientstats = {}"
local clientFile = io.open("Active/clientstats.lua", "w") or error("Failed to open debug file")
clientFile:write(client_str)																		--write initial file
clientFile:close()

local trigStr = "camp_triggers = " .. TableSerializationAG_triggers(camp_triggers, 0)							--write
local trigFile = io.open("Active/camp_triggers.lua", "w") or error("Failed to open debug file")
trigFile:write(trigStr)
trigFile:close()

local airbases_Str = "db_airbases = " .. TableSerialization(db_airbases, 0)
trigFile = io.open("Active/db_airbases.lua", "w") or error("Failed to open debug file")
trigFile:write(airbases_Str)
trigFile:close()

local ZoneSAR_str = "camp_ZoneSAR = {}"																--make a string
local ZoneSARFile = io.open("Active/camp_ZoneSAR.lua", "w") or error("Failed to open debug file")
ZoneSARFile:write(ZoneSAR_str)																		--save new data
ZoneSARFile:close()

--supprime le fichier 
-- Vérifie si le fichier existe en tentant de l'ouvrir
local file = io.open("Active/PayloadRestricted.lua", "r")

if file then
    file:close()  -- Ferme le fichier (important avant suppression)
    -- Supprime le fichier
    os.remove("Active/PayloadRestricted.lua")
end



--create new oob_ground (requires extraction of data of init mission)
do

	--unpack template mission file
	local minizip = require('minizip')
	local zipFile = minizip.unzOpen("Init/base_mission.miz", 'rb')

	zipFile:unzLocateFile('mission')
	local misStr = zipFile:unzReadAllCurrentFile()
	local misStrFunc = loadstring(misStr)()

	zipFile:unzLocateFile('l10n/DEFAULT/dictionary')
	local dicStr = zipFile:unzReadAllCurrentFile()
	local dicStrFunc = loadstring(dicStr)()

	zipFile:unzClose()


	oob_ground = {}
	oob_ground["blue"] = Deepcopy(mission.coalition.blue.country)											--copy mission data
	oob_ground["red"] = Deepcopy(mission.coalition.red.country)												--copy mission data

	--store group and unit names in oob_ground instead of pointers to dict table
	for side_name, side in pairs(oob_ground) do																--iterate through sides
		for country_n, country in pairs(side) do															--iterate through countries
			if country.vehicle then																			--country has vehicles
				for g = 1, #country.vehicle.group do														--iterate through vehicle groups
					-- local groupname = dictionary[country.vehicle.group[g].name]								--find groupname in dictionary table			
					local groupname = country.vehicle.group[g].name											--M45	
					country.vehicle.group[g].name = groupname												--give group the actual groupname instead of the pointer to the dictionary table
					for u = 1, #country.vehicle.group[g].units do											--iterate through units
						-- local unitname = dictionary[country.vehicle.group[g].units[u].name]					--find unitname in dictionary table
						local unitname = country.vehicle.group[g].units[u].name								--M45	
						country.vehicle.group[g].units[u].name = unitname									--give unit the actual unitname instead of the pointer to the dictionary table
					end
				end
			end
			if country.ship then																			--country has ships
				for g = 1, #country.ship.group do															--iterate through ship groups
					-- local groupname = dictionary[country.ship.group[g].name]								--find groupname in dictionary table
					local groupname = country.ship.group[g].name								--M45
					country.ship.group[g].name = groupname													--give group the actual groupname instead of the pointer to the dictionary table
					for u = 1, #country.ship.group[g].units do												--iterate through units
						-- local unitname = dictionary[country.ship.group[g].units[u].name]					--find unitname in dictionary table
						local unitname = country.ship.group[g].units[u].name								--M45
						country.ship.group[g].units[u].name = unitname										--give unit the actual unitname instead of the pointer to the dictionary table
					end
				end
			end
			if country.static then																			--country has static objects
				for g = 1, #country.static.group do															--iterate through static groups
					-- local groupname = dictionary[country.static.group[g].name]								--find groupname in dictionary table			
					local groupname = country.static.group[g].name								--M45
					country.static.group[g].name = groupname												--give group the actual groupname instead of the pointer to the dictionary table
					for u = 1, #country.static.group[g].units do											--iterate through units
						-- local unitname = dictionary[country.static.group[g].units[u].name]					--find unitname in dictionary table
						local unitname = country.static.group[g].units[u].name								--M45
						country.static.group[g].units[u].name = unitname									--give unit the actual unitname instead of the pointer to the dictionary table
					end
				end
			end
		end
	end


	--save oob_ground status file
	ground_str = "oob_ground = " .. TableSerialization(oob_ground, 0)								--make a string
	groundFile = io.open("Active/oob_ground.lua", "w") or error("Failed to open debug file")
	groundFile:write(ground_str)																		--write initial data
	groundFile:close()
end