--Various DATA
------------------------------------------------------------------------------------------------------- 
------------------------------------------------------------------------------------------------------- 
if not versionDCE then versionDCE = {} end
versionDCE["UTIL_Data.lua"] = "1.15.93"
------------------------------------------------------------------------------------------------------- 

if Debug.debug then
	print("START UTIL_Data.lua "..versionDCE["UTIL_Data.lua"].." =-=-=-=-=-=-=-=-=-=-=-=-=-=-=")
end

-- À la louche je pencherais plutôt pour : 
-- 75% à 10000m pour l’EA-6B
-- 50% à 4000m pour le F-105G
-- 40% à 2000m pour le B-52

AFAC = "AFAC"
CAS = "CAS"
AntishipStrike = "Antiship Strike"
GroundAttack = "Ground Attack"
RunwayAttack = "Runway Attack"
Escort = "Escort"
PinpointStrike = "Pinpoint Strike"
Intercept = "Intercept"
CAP = "CAP"
FighterSweep = "Fighter Sweep"
Reconnaissance = "Reconnaissance"
Refueling = "Refueling"
AWACS = "AWACS"
SEAD = "SEAD"
Transport = "Transport"


Data_configuration = {
	CV_Vmax = 15.4,								--10-- (default : 15.4333( m/s):30kts), can have bp with F14, go down to 10 m/s
	CV_windDeck = 13.8,							--9-- (default : 13.89( m/s):27kts), can have bp with F14, go down to 9 m/s
	CV_despawnAfterLanding = true,				-- (default : true) despawn aircraft landing on CV and LHA ,this avoids collisions between taxxing and landing aircraft
	SC_SpawnOn = {
		["F-14B"] = "deck",						-- (default: "deck"), "catapult", "air"
		["E-2C"] = "deck",
		["S-3B Tanker"] = "deck",
		["Pedro"] = "deck",
	},
}


EjectedPilotFrequency = {
	blue = {
		GuardEjection = 243000000,			--frequency used for automatic triggering of the radio beacon during ejection (blue side usually 243)
		-- radioBeacon = 121500000,			--think you need a compatible helicopter to listen and follow the frequency (preset Chanel 4 R-852)
		radioBeacon = 43000000,			--pour vietnam et UH-1H, obligé de passer en Fm pour avoir du homing
	},
	red = {
		GuardEjection = 114115000,			--think you need a compatible helicopter to listen and follow the frequency (preset Chanel 1 R-852)
		radioBeacon = 114585000,			--think you need a compatible helicopter to listen and follow the frequency (preset Chanel 3 R-852)
	},
	neutral = {
		GuardEjection = 243000000,			--think you need a compatible helicopter to listen and follow the frequency (blue side usually 243)
		-- radioBeacon = 121500000,			--think you need a compatible helicopter to listen and follow the frequency (preset Chanel 4 R-852)
		radioBeacon = 282800000,			--URC-11 (PRC-63)
	},
}

-- function en local, sinon en global ça pollue ça fait planter DCE_Manager
local function deepcopyLocal(orig, copies)
    copies = copies or {}  -- Table pour suivre les références déjà copiées

    if type(orig) ~= 'table' then return orig end  -- Copie simple des types de base

    if copies[orig] then return copies[orig] end  -- Si déjà copié, éviter boucle infinie

    local copy = {}
    copies[orig] = copy  -- Stocker la copie pour éviter de repasser sur la même table

    for orig_key, orig_value in pairs(orig) do
        copy[deepcopyLocal(orig_key, copies)] = deepcopyLocal(orig_value, copies)
    end

    setmetatable(copy, deepcopyLocal(getmetatable(orig), copies))
    return copy
end


TaskByPlane = {
	["Escort Jammer"] = {
	},

	["AFAC"] = {
		-- ["MosquitoFBMkVI"] = true,
		["SpitfireLFMkIX"] = true,
		["SpitfireLFMkIXCW"] = true,

		["P-47D-30bl1"] = true,
		["P-47D-30"] = true,
		["P-47D-40"] = true,
		["P-51D"] = true,
		["P-51D-30-NA"] = true,

		["Bf-109K-4"] = true,
		["FW-190A8"] = true,
		["FW-190D9"] = true,

		["C-47"] = true,

		["MQ-9 Reaper"] = true,

		["Tornado GR4"] = true,
		["Tornado IDS"] = true,

		-- ["A-4E-C"] = true,				--Mod
		["A-10C"] = true,
		["A-10C_2"] = true,
		["A-10A"] = true,
		-- ["Bronco-OV-10A"] = true,		--Mod
		["vwv_a1_skyraider"] = true,	--Mod
		["vwv_o-1"] = true,         	--Mod

		["F-16C bl.52d"] = true,


		["Yak-52"] = true,
		["JF-17"] = true,
		["L-39ZA"] = true,
		["Su-24M"] = true,

		-- ["Ka-50"] = true,
		["Ka-50_3"] = true,
		["Mi-28N"] = true,

		["AH-64A"] = true,

	},
	["CAS"] = {
		-- ["MosquitoFBMkVI"] = true,
		["SpitfireLFMkIX"] = true,
		["SpitfireLFMkIXCW"] = true,

		["A-20G"] = true,

		["P-47D-30bl1"] = true,
		["P-47D-30"] = true,
		["P-47D-40"] = true,
		["P-51D"] = true,
		["P-51D-30-NA"] = true,

		["Bf-109K-4"] = true,
		["FW-190A8"] = true,
		["FW-190D9"] = true,
		["Ju-88A4"] = true,

		["I-16"] = true,

		["A-6E"] = true,			--Mod
		["A-10C"] = true,
		["A-10C_2"] = true,
		["A-10A"] = true,
		["vwv_a1_skyraider"] = true,	--Mod

		["AV8BNA"] = true,
		["MB-339A"] = true,
		["MirageF1"] = true,			--Mod

		["B-1B"] = true,
		["B-52H"] = true,

		["H-6J"] = true,
		["tu_22D"] = true,				--Mod

		["F-4E"] = true,
		["F-15E"] = true,
		["F-16C bl.52d"] = true,
	
		["AH-64D_BLK_II"] = true,

		["JF-17"] = true,
		["L-39C"] = true,
		["L-39ZA"] = true,
		["MiG-23MLD"] = true,
		["MiG-27K"] = true,

		["Su-17M4"] = true,
		["Su-24M"] = true,
		["Su-25"] = true,
		["Su-25T"] = true,
		["Su-30"] = true,
		["Su-34"] = true,

		["Mi-24V"] = true,
		["Mi-28N"] = true,
		["Ka-50_3"] = true,

	},

	["Antiship Strike"] = {
		["SpitfireLFMkIX"] = true,
		["SpitfireLFMkIXCW"] = true,

		["A-20G"] = true,

		["P-47D-30bl1"] = true,
		["P-47D-30"] = true,
		["P-47D-40"] = true,
		["P-51D"] = true,
		["P-51D-30-NA"] = true,

		["Bf-109K-4"] = true,
		["FW-190A8"] = true,
		["FW-190D9"] = true,
		["Ju-88A4"] = true,

		["Tornado GR4"] = true,
		["Tornado IDS"] = true,

		["A-10C"] = true,
		["A-10C_2"] = true,
		["A-10A"] = true,
		["vwv_a1_skyraider"] = true,	--Mod
		["AV8BNA"] = true,
		["B-52H"] = true,

		["H-6J"] = true,

		["F-4E"] = true,
		["F-16C bl.52d"] = true,
		["MB-339A"] = true,			 
		
		["AH-64D_BLK_II"] = true,
		["AH-64A"] = true,
		["SH-3D"] = true,				--Mod

		["JF-17"] = true,
		["L-39C"] = true,
		["L-39ZA"] = true,
		["MiG-27K"] = true,
		["Su-17M4"] = true,
		["Su-24M"] = true,
		["Su-25"] = true,
		["Su-25T"] = true,
		["Su-25TM"] = true,
		["Su-34"] = true,

		["Su-30"] = true,

		["tu_22D"] = true,				--Mod

		["Mi-24V"] = true,
		["Mi-28N"] = true,
		["Ka-50_3"] = true,


	},

	["Ground Attack"] = {
		["SpitfireLFMkIX"] = true,
		["SpitfireLFMkIXCW"] = true,

		["P-47D-30bl1"] = true,
		["P-47D-30"] = true,
		["P-47D-40"] = true,
		["P-51D"] = true,
		["P-51D-30-NA"] = true,

		["A-20G"] = true,
		["B-17G"] = true,

		["Bf-109K-4"] = true,
		["FW-190A8"] = true,
		["FW-190D9"] = true,
		["Ju-88A4"] = true,

		["I-16"] = true,

		["Tornado GR4"] = true,
		["Tornado IDS"] = true,

		["A-6E"] = true,				--Mod
		["vwv_a1_skyraider"] = true,	--Mod
		["A-10C"] = true,
		["A-10C_2"] = true,
		["A-10A"] = true,
		["AV8BNA"] = true,

		["B-1B"] = true,
		["B-52H"] = true,

		["H-6J"] = true,
		["tu_22D"] = true,				--Mod

		["F-4E"] = true,
		["F-15E"] = true,
		["F-16C bl.52d"] = true,
		["MB-339A"] = true,
		["MirageF1"] = true,			--Mod

		["AH-64D_BLK_II"] = true,
		["AH-64A"] = true,

		["JF-17"] = true,
		["L-39C"] = true,
		["L-39ZA"] = true,
		["MiG-23MLD"] = true,
		["MiG-25RBT"] = true,
		["MiG-27K"] = true,

		["Su-17M4"] = true,
		["Su-24M"] = true,
		["Su-25"] = true,
		["Su-25T"] = true,
		["Su-30"] = true,
		["Su-34"] = true,

		["Mi-24V"] = true,
		["Mi-28N"] = true,
		["Ka-50_3"] = true,



	},

	["Runway Attack"] = {
		["SpitfireLFMkIX"] = true,
		["SpitfireLFMkIXCW"] = true,

		["P-47D-30bl1"] = true,
		["P-47D-30"] = true,
		["P-47D-40"] = true,
		["P-51D"] = true,
		["P-51D-30-NA"] = true,

		["A-20G"] = true,
		["B-17G"] = true,

		["Bf-109K-4"] = true,
		["FW-190A8"] = true,
		["FW-190D9"] = true,
		["Ju-88A4"] = true,

		["Tornado GR4"] = true,
		["Tornado IDS"] = true,

		["A-6E"] = true,					--Mod
		["A-10C"] = true,
		["A-10C_2"] = true,
		["A-10A"] = true,
		["vwv_a1_skyraider"] = true,		--Mod
		["AV8BNA"] = true,

		["B-1B"] = true,
		["B-52H"] = true,

		["H-6J"] = true,
		["tu_22D"] = true,					--Mod

		["F-15E"] = true,
		["F-16C bl.52d"] = true,
		["MB-339A"] = true,
		["MirageF1"] = true,			--Mod

		["JF-17"] = true,
		["L-39C"] = true,
		["L-39ZA"] = true,
		["Su-17M4"] = true,
		["Su-24M"] = true,
		["Su-25"] = true,
		["Su-25T"] = true,
		-- ["Su-27"] = true,
		["Su-30"] = true,
		["Su-34"] = true,
		["MiG-27K"] = true,


	},

	["Escort"] = {
		["SpitfireLFMkIX"] = true,
		["SpitfireLFMkIXCW"] = true,

		["P-47D-30bl1"] = true,
		["P-47D-30"] = true,
		["P-47D-40"] = true,
		["P-51D"] = true,
		["P-51D-30-NA"] = true,

		["Bf-109K-4"] = true,
		["FW-190A8"] = true,
		["FW-190D9"] = true,

		["I-16"] = true,

		["AV8BNA"] = true,

		["F-4E"] = true,
		["vwv_crusader"] = true,		--Mod
		["F-15C"] = true,
		["F-15E"] = true,
		["F-16C bl.52d"] = true,

		["MirageF1"] = true,			--Mod

		["AH-64D_BLK_II"] = true,

		["Yak-52"] = true,
		["JF-17"] = true,
		["MiG-23MLD"] = true,
		["MiG-25PD"] = true,
		["MiG-29S"] = true,
		["MiG-31"] = true,

		-- ["Su-27"] = true,
		["Su-30"] = true,

		["Mi-28N"] = true,
		-- ["Ka-50"] = true,
		["Ka-50_3"] = true,
	},

	["Pinpoint Strike"] = {
		["AV8BNA"] = true,

		["Tornado GR4"] = true,
		["Tornado IDS"] = true,

		["B-1B"] = true,
		["B-52H"] = true,

		["H-6J"] = true,
		["tu_22D"] = true,				--Mod

		["F-4E"] = true,
		["F-15E"] = true,
		["F-16C bl.52d"] = true,
		["F-117A"] = true,

		["JF-17"] = true,
		["MiG-27K"] = true,
		["Su-17M4"] = true,
		["Su-24M"] = true,
		["Su-25"] = true,
		["Su-25T"] = true,
		["Su-30"] = true,
		["Su-34"] = true,

	},

	["Intercept"] = {
		["SpitfireLFMkIX"] = true,
		["SpitfireLFMkIXCW"] = true,

		["P-47D-30bl1"] = true,
		["P-47D-30"] = true,
		["P-47D-40"] = true,

		["Bf-109K-4"] = true,
		["FW-190A8"] = true,
		["FW-190D9"] = true,

		["I-16"] = true,


		["AV8BNA"] = true,
		["F-4E"] = true,
		["vwv_crusader"] = true,		--Mod
		["F-15C"] = true,
		["F-15E"] = true,
		["F-16C bl.52d"] = true,

		["MirageF1"] = true,			--Mod

		["JF-17"] = true,
		["MiG-23MLD"] = true,
		["MiG-25PD"] = true,
		["MiG-29S"] = true,
		["MiG-31"] = true,
		-- ["Su-27"] = true,
		["Su-30"] = true,


	},

	["CAP"] = {
		["SpitfireLFMkIX"] = true,
		["SpitfireLFMkIXCW"] = true,

		["P-47D-30bl1"] = true,
		["P-47D-30"] = true,
		["P-47D-40"] = true,
		["P-51D"] = true,
		["P-51D-30-NA"] = true,


		["Bf-109K-4"] = true,
		["FW-190A8"] = true,
		["FW-190D9"] = true,

		["I-16"] = true,

		["AV8BNA"] = true,

		["F-4E"] = true,
		["vwv_crusader"] = true,		--Mod
		["F-15C"] = true,
		["F-15E"] = true,
		["F-16C bl.52d"] = true,
		
		["MirageF1"] = true,			--Mod

		["Yak-52"] = true,
		["JF-17"] = true,
		["L-39C"] = true,
		["L-39ZA"] = true,
		["MiG-23MLD"] = true,
		["MiG-25PD"] = true,
		["MiG-29S"] = true,
		["MiG-31"] = true,
		-- ["Su-27"] = true,
		["Su-30"] = true,


	},

	["Fighter Sweep"] = {
		["SpitfireLFMkIX"] = true,
		["SpitfireLFMkIXCW"] = true,

		["P-47D-30bl1"] = true,
		["P-47D-30"] = true,
		["P-47D-40"] = true,
		["P-51D"] = true,
		["P-51D-30-NA"] = true,


		["Bf-109K-4"] = true,
		["FW-190A8"] = true,
		["FW-190D9"] = true,

		["I-16"] = true,

		["AV8BNA"] = true,
		["F-4E"] = true,
		["vwv_crusader"] = true,		--Mod
		["F-15C"] = true,
		["F-15E"] = true,
		["F-16C bl.52d"] = true,
		
		["MirageF1"] = true,			--Mod

		["JF-17"] = true,
		["MiG-23MLD"] = true,
		["MiG-25PD"] = true,
		["MiG-29S"] = true,
		["MiG-31"] = true,
		-- ["Su-27"] = true,
		["Su-30"] = true,


	},


	["Reconnaissance"] = {
		["TF-51D"] = true,
		["FW-190A8"] = true,
		["I-16"] = true,

		["Tornado GR4"] = true,
		["Tornado IDS"] = true,

		-- ["A-4E-C"] = true,				--Mod
		-- ["AJS37"] = true,
		["F-4E"] = true,
		["vwv_crusader"] = true,		--Mod
		["vwv_ra-5"] = true,		--Mod
		["F-15E"] = true,
		["F-16C bl.52d"] = true,

		["JF-17"] = true,
		["MiG-25RBT"] = true,
		["Su-24MR"] = true,
		["tu_22D"] = true,				--Mod
	},


	["Refueling"] = {
		-- ["A-4E-C"] = true,				--Mod
		["S-3B Tanker"] = true,
		["KC135MPRS"] = true,
		["KC-135"] = true,
		["KC130"] = true,
		["IL-78M"] = true,
		["A6E"] = true,
		
	},

	["AWACS"] = {
		["E-3A"] = true,
		["E-2C"] = true,
		["A-50"] = true,
	},

	["SEAD"] = {
		-- ["AJS37"] = true,

		["Tornado GR4"] = true,
		["Tornado IDS"] = true,

		-- ["A-4E-C"] = true,				--Mod				 

		["AV8BNA"] = true,
		["F-4E"] = true,
		["F-16C bl.52d"] = true,
		
		["JF-17"] = true,

		["Su-17M4"] = true,
		["Su-24M"] = true,
		["Su-25T"] = true,
		["Su-30"] = true,
		["Su-34"] = true,
		["MiG-27K"] = true,


	},

	["Transport"] = {
		["C-47"] = true,
		["C-130"] = true,
		["Hercules"] = true,		--Mod
		["C-17A"] = true,

		["vwv_sh2f"] = true,			--Mod
		["vwv_hh2d"] = true,			--Mod
		["CH-53E"] = true,
		["UH-60A"] = true,
		["UH-60L"] = true,			--Mod
		["SH-3D"] = true,			--Mod
		["SH-60B"] = true,

		["An-26B"] = true,
		["An-30M"] = true,
		["IL-76MD"] = true,

		["Ka-27"] = true,
		["Mi-24V"] = true,
		["Mi-26"] = true,


	},

}

-- Data_divers = {}
--instrumentUnits = "imperial" or  metric or russian (metric and QNH in mmHg)
-- inheritedFrom = "F-14",	--copy radio frequency, failures ...
-- inherited_APA_From = "F-14",	--copy AddPropAircraft
--requiredModules = true,						--itsModule
-- moduleName = "VSN_F105",	--if the aircraft type name does not match the requested module name
--flyingAlone = false
	-- alignment_PropAircraft = {
	-- 	fast = {
	-- 		["ReadyALCM"] = true,
	-- 		["ForceINSRules"] = true,
	-- 		["InitHotDrift"] = 0,
	-- 	},
	-- 	slow = {
	-- 		["ReadyALCM"] = false,
	-- 		["ForceINSRules"] = true,
	-- 		["InitHotDrift"] = 0,
	-- 	}
	-- }

Data_divers = {

	["MosquitoFBMkVI"] =
	{
		instrumentUnits = "imperial",
		EPLRS_Capacity = false,
		playable = true,
		Tasks = {
			aircraft_task(FighterSweep),
			aircraft_task(Intercept),
			aircraft_task(Escort),
			aircraft_task(CAP),
			aircraft_task(GroundAttack),
			aircraft_task(CAS),
			aircraft_task(AFAC),
			aircraft_task(RunwayAttack),
			aircraft_task(AntishipStrike),
		},
	},
	["SpitfireLFMkIX"] = 	{
		instrumentUnits = "imperial",
		playable = true,
	},
	["SpitfireLFMkIXCW"] = 	{
		instrumentUnits = "imperial",
	},

	["P-47D-30bl1"] =	{
		instrumentUnits = "imperial",
	},
	["P-47D-30"] = 	{
		instrumentUnits = "imperial",
		playable = true,
	},
	["P-47D-40"] = 	{
		instrumentUnits = "imperial",
	},
	["P-51D"] = 	{
		instrumentUnits = "imperial",
	},
	["P-51D-30-NA"] = 	{
		instrumentUnits = "imperial",
		EPLRS_Capacity = false,
		playable = true,
	},
	["TF-51D"] = 	{
		instrumentUnits = "imperial",
	},

	["A-20G"] = 	{
		instrumentUnits = "imperial",
	},
	["B-17G"] = 	{
		instrumentUnits = "imperial",
	},
	["C-47"] = {
		instrumentUnits = "imperial",
	},

	["Bf-109K-4"] = 	{
		instrumentUnits = "metric",
		playable = true,
	},
	["FW-190A8"] = 	{
		instrumentUnits = "metric",
	},
	["FW-190D9"] = 	{
		instrumentUnits = "metric",
	},
	["Ju-88A4"] = 	{
		instrumentUnits = "metric",
	},

	["I-16"] = 	{
		instrumentUnits = "russian",
	},
	["Yak-52"] = 	{
		instrumentUnits = "russian",
	},

	["vwv_ec-121"] = 	{							--name, next to DisplayName
		instrumentUnits = "imperial",
		moduleName = "tetet_ec121",		--self_ID 
		folderModName = "[VWV] EC-121",

		-- Tasks = {
		-- 	aircraft_task(AWACS),
		-- },
		requiredModules = true,						--itsModule
		playable = false,
		hCruise = 7000,	--(≈ 20 000–25 000 ft)
		vCruise = 110,	--–120 m/s
	},


	["Tornado GR4"] = 	{
		instrumentUnits = "imperial",
		EPLRS_Capacity = false,
	},
	["Tornado IDS"] = 	{
		instrumentUnits = "imperial",
		EPLRS_Capacity = false,
	},

	["AV8BNA"] = 	{
		instrumentUnits = "imperial",
		EPLRS_Capacity = false,
		playable = true,
		folderModName = "AV8BNA",
		vCruise = 230,
		hCruise = 4500,
		refuellingReceptacleType = "drogue"
	},
	["A-4E-C"] = 	{--mod
		instrumentUnits = "imperial",
		requiredModules = true,						--itsModule
		playable = true,
		moduleName = "A-4E-C",		--self_ID 
		folderModName = "A-4E-C",
		vCruise = 221,
		hCruise = 10630,--TODO a confirmer
		refuellingReceptacleType = "drogue"
	},
	["A6E"] = 	{--natif ED mais folder name particulier
		instrumentUnits = "imperial",
		moduleName = "A-6E",
		folderModName = "A-6E",
		EPLRS_Capacity = false,
		refuellingType = "drogue",
		vCruise = 216,
		hCruise = 10670,
	},
	["A-6E"] = 	{				--Mod
		instrumentUnits = "imperial",
		requiredModules = true,						--itsModule
		-- moduleName = "A-6E",
		-- folderModName = "A-6E",
		EPLRS_Capacity = false,
		vCruise = 216,
		hCruise = 10670,
	},
	["EA_6B"] = 	{					--Mod
		instrumentUnits = "imperial",
		EPLRS_Capacity = false,
		requiredModules = true,						--itsModule
		folderModName = "Northrop Grumman EA-6B Prowler",
		vCruise = 216,
		hCruise = 10670,
		jammer = {
			type = "AN/ALQ-99",
			efficiency = 95,
			range = 10000,
		},
		addTasks = {                     -- defined in db_units_planes.lua
			aircraft_task("Escort Jammer"),
		},
	},

	["VSN_F100"] = 	{				--type in mission.miz
		instrumentUnits = "imperial",
		requiredModules = true,						--itsModule
		moduleName = "VSN_F100",		--self_ID  require module name
		folderModName = "VSN_F100",
		vCruise = 200,	--TODO a confirmer
		hCruise = 4500,
		-- Tasks = {
		-- 	aircraft_task(GroundAttack),
		-- 	aircraft_task(CAS),
		-- 	aircraft_task(SEAD),
		-- },
	},

	["VSN_F105D"] = 	{				-- type in mission.miz
		instrumentUnits = "imperial",
		requiredModules = true,						--itsModule
		moduleName = "VSN_F105",	--self_ID  require module name
		folderModName = "VSN_F105",
		EPLRS_Capacity = false,
	-- 	Tasks = {
	-- 		aircraft_task(CAP),
	-- 		aircraft_task(Escort),
	-- 		aircraft_task(FighterSweep),
	-- 		aircraft_task(Intercept),
	-- 		aircraft_task(Reconnaissance),
	-- 		aircraft_task(GroundAttack),
	-- 		aircraft_task(CAS),
	-- 		aircraft_task(RunwayAttack),
	-- 		aircraft_task(AntishipStrike),
	--   },
		playable = true,
		vCruise = 205.5,	--TODO a confirmer
		hCruise = 5315.2,
	},

	["VSN_F105G"] = 	{				--type in mission.miz
		instrumentUnits = "imperial",
		requiredModules = true,						--itsModule
		moduleName = "VSN_F105",	--self_ID  require module name
		folderModName = "VSN_F105",
		EPLRS_Capacity = false,

		playable = true,
		jammer = {
			type = "AN/ALQ-71",
			efficiency = 90,
			range = 4000,
			power = 90,
		},
		vCruise = 205.5,	--TODO a confirmer
		hCruise = 5315.2,
	},

	["Bronco-OV-10A"] = 	{				--Mod
		instrumentUnits = "imperial",
		requiredModules = true,						--itsModule
		EPLRS_Capacity = true,
		vCruise = 110,
		hCruise = 4570,
		laserDesignator = false,
		playable = true,
		folderModName = "BRONCO_V1.24",
	},

	["vwv_a1_skyraider"] = 	{				--Mod
		instrumentUnits = "imperial",
		requiredModules = true,						--itsModule
		moduleName = "tetet_a-1_skyraider",
		folderModName = "[VWV] A-1",
		-- radio = {
		-- 	frequency = 127.5,  -- Radio Freq
		-- 	editable = true,
		-- 	minFrequency = 100.000,
		-- 	maxFrequency = 156.000,
		-- 	modulation = MODULATION_AM
		-- },
		vCruise = 154,	-- TODO a confirmer
		hCruise = 3315,
	},

	["vwv_ra-5"] = 	{				--Mod
		instrumentUnits = "imperial",
		requiredModules = true,						--itsModule
		moduleName = "tetet_ra5",					--self_ID 
		folderModName = "[VWV] A-5",
		jammer = {
			type = "AN/ALQ-100",
			efficiency = 86,
			range = 2000,
		},
		vCruise = 154,
		hCruise = 9144,
	},

	["vwv_crusader"] = 	{				--Mod
		instrumentUnits = "imperial",
		requiredModules = true,						--itsModule
		moduleName = "tetet_crusader",
		folderModName = "[VWV] F-8",
		-- playable = true,
		-- radio = {
		-- 	frequency = 127.5,  -- Radio Freq
		-- 	editable = true,
		-- 	minFrequency = 100.000,
		-- 	maxFrequency = 156.000,
		-- 	modulation = MODULATION_AM
		-- },
		vCruise = 245,		--TODO a confirmer
		hCruise = 5486.4,
	},
	["vwv_o-1"] = 	{			                 	--Mod
		instrumentUnits = "imperial",
		requiredModules = true,						--itsModule
		moduleName = "tetet_O1",
		folderModName = "[VWV] O-1",
		-- radio =
		-- {
		-- 	frequency = 127.5,  -- Radio Freq
		-- 	editable = true,
		-- 	minFrequency = 100.000,
		-- 	maxFrequency = 156.000,
		-- 	modulation = MODULATION_AM
		-- },
		vCruise = 80,	-- TODO a confirmer
		hCruise = 3315.2,
	},

	["A-10A"] = 	{
		instrumentUnits = "imperial",
		EPLRS_Capacity = false,
		playable = true,
		folderModName = "A-10",
		vCruise = 154,
		hCruise = 7600,
		refuellingReceptacleType = "probe"
	},

	["A-10C"] = 	{
		instrumentUnits = "imperial",
		EPLRS_Capacity = true,
		folderModName = "A-10",
		playable = true,
		datalinks = {
			type = "SADL",
			isDonnor = true,
		},

		vCruise = 154,
		hCruise = 7600,
		refuellingReceptacleType = "probe"
	},
	["A-10C_2"] = 	{
		instrumentUnits = "imperial",
		EPLRS_Capacity = true,
		folderModName = "A-10",
		datalinks = {
			type = "SADL",
			hasTeamMembers = 4,
			hasDonors = 12,
			isDonnor = true,
			isReceiver = true,
		},
		inheritedFrom = "A-10C",	--copy radio frequency, failures ...
		playable = true,
		vCruise = 154,
		hCruise = 7600,
		refuellingReceptacleType = "probe"
	},

	["a_37_dragonfly"] = 	{							--name, next to DisplayName
		instrumentUnits = "imperial",
		moduleName = "h60_a37_dragonfly",		--self_ID 
		folderModName = "[VWV] A-37",
		playable = false,
		vCruise = 125,						--V_opt
		hCruise = 6000,
	},
	

	["MQ-9 Reaper"] = 	{
		instrumentUnits = "imperial",
		EPLRS_Capacity = false,
		playable = false,
		laserDesignator = true,
	},

	["B-1B"] = 	{
		instrumentUnits = "imperial",
		EPLRS_Capacity = false,
		datalinks = {
			type = "Link16",
			isDonnor = true,
		},
		flyingAlone = true,
		vCruise = 250,
		hCruise = 9150,
		heavyBomber = true,
	},
	["B-52H"] = 	{
		instrumentUnits = "imperial",
		EPLRS_Capacity = false,
		datalinks = {
			type = "Link16",
			isDonnor = true,
		},
		-- flyingAlone = true,
		vCruise = 250,
		hCruise = 12000,
		heavyBomber = true,
		jammer = {
			type = "AN/ALT-22",
			efficiency = 86,
			range = 2000,
		}
	},

	["F-117A"] = 	{
		instrumentUnits = "imperial",
		EPLRS_Capacity = false,
		flyingAlone = true,
		vCruise = 260,
		hCruise = 12500,
	},

	["C-130"] = {
		instrumentUnits = "imperial",
		EPLRS_Capacity = false,
		vCruise = 140,
		hCruise = 7620,
	},
	["C-130J-30"] = {
		instrumentUnits = "imperial",
		playable = true,
		EPLRS_Capacity = false,
		folderModName = "C130J",
		-- Tasks = {
		-- 	aircraft_task(Transport),
		-- 	aircraft_task(GroundAttack),
		-- 	aircraft_task(Refueling),
		-- },
		vCruise = 140,
		hCruise = 7620,
	},
	["Hercules"] = {			--Mod
		instrumentUnits = "imperial",
		EPLRS_Capacity = false,
		requiredModules = true,						--itsModule
		playable = true,
	},
	["C-17A"] = {
		instrumentUnits = "imperial",
		EPLRS_Capacity = false,
	},


	["F-86F Sabre"] = 	{
		instrumentUnits = "imperial",
		EPLRS_Capacity = false,
		playable = true,
		folderModName = "F-86",
	},
	["vwv_rf101b"] = 	{
		instrumentUnits = "imperial",
		requiredModules = true,						--itsModule
		moduleName = "tetet_rf101b",	--if the aircraft type name does not match the requested module name
		folderModName = "[VWV] RF-101B",
		vCruise = 215,
		hCruise = 9000,
		-- Tasks = {
		-- 	aircraft_task(Reconnaissance),
		-- },
	},
	["VSN_F104C"] = 	{
		instrumentUnits = "imperial",
		requiredModules = true,						--itsModule
		moduleName = "VSN_F104C",	--if the aircraft type name does not match the requested module name
		folderModName = "VSN_F104C",
		playable = true,
		vCruise = 215,
		hCruise = 9000,
	},
	["F111C"] = 	{
		instrumentUnits = "imperial",
		requiredModules = true,						--itsModule
		moduleName = "F111C",	--if the aircraft type name does not match the requested module name
		folderModName = "F111C",
		playable = true,
		-- vCruise = 215,
		-- hCruise = 9000,
	},
	["F-4E"] = 	{
		instrumentUnits = "imperial",
		EPLRS_Capacity = false,
		vCruise = 215,
		hCruise = 9000,
	},
	["VSN_F4B"] = 	{
		instrumentUnits = "imperial",
		requiredModules = true,						--itsModule
		moduleName = "VSN_F4",	--if the aircraft type name does not match the requested module name
		folderModName = "VSN_F4",
		playable = true,
		vCruise = 215,
		hCruise = 9000,
	},
	["VSN_F4C"] = 	{
		instrumentUnits = "imperial",
		requiredModules = true,						--itsModule
		moduleName = "VSN_F4",	--if the aircraft type name does not match the requested module name
		folderModName = "VSN_F4",
		playable = true,
		vCruise = 215,
		hCruise = 9000,
	},

	["F-4E-45MC"] = 	{
		instrumentUnits = "imperial",
		EPLRS_Capacity = false,
		folderModName = "F-4E",
		playable = true,
		alignment_PropAircraft = {
			fast = {
				["INSAlignmentStored"] = true,
			},
			slow = {
				["INSAlignmentStored"] = false,
			},
		},
		vCruise = 215,--a peaufiner
		hCruise = 9000,--a peaufiner
		refuellingReceptacleType = "probe"
	},
	["F-5E-3"] = 	{
		instrumentUnits = "imperial",
		EPLRS_Capacity = false,
		playable = true,
		folderModName = "F-5E", -- marche pas sur ce mod
		vCruise = 230,
		hCruise = 5112,
	},
	["F-14"] = 	{--Common aircraft definitions
		instrumentUnits = "imperial",
		EPLRS_Capacity = false,
	},
	["F-14A-135-GR"] = 	{
		instrumentUnits = "imperial",
		EPLRS_Capacity = false,
		inheritedFrom = "F-14",	--copy radio frequency, failures ...
		inherited_APA_From = "F-14",	--copy AddPropAircraft
		folderModName = "F14",
		fileModName = "F-14B.lua",		--exactement les meme fichiers que le F-14B
		playable = true,
		alignment_PropAircraft = {
			fast = {
				["INSAlignmentStored"] = true,
			},
			slow = {
				["INSAlignmentStored"] = false,
			},
		},
		vCruise = 230,
		hCruise = 9140,
		refuellingReceptacleType = "drogue"
	},
	["F-14B"] = 	{
		instrumentUnits = "imperial",
		EPLRS_Capacity = false,
		inheritedFrom = "F-14",	--copy radio frequency, failures ...
		inherited_APA_From = "F-14",	--copy AddPropAircraft
		folderModName = "F14",
		fileModName = "F-14B.lua",
		playable = true,
		alignment_PropAircraft = {
			fast = {
				["INSAlignmentStored"] = true,
			},
			slow = {
				["INSAlignmentStored"] = false,
			},
		},
		vCruise = 230,
		hCruise = 9140,
		refuellingReceptacleType = "drogue"
	},
	["F-15C"] = 	{
		instrumentUnits = "imperial",
		EPLRS_Capacity = true,
		datalinks = {
			type = "Link16",
			isDonnor = true,
		},
		vCruise = 265,
		hCruise = 12000,
	},
	["F-15E"] = 	{
		instrumentUnits = "imperial",
		EPLRS_Capacity = true,
		datalinks = {
			type = "Link16",
			isDonnor = true,
		},
		vCruise = 245,
		hCruise = 12670,
	},
	["F-15ESE"] = 	{
		instrumentUnits = "imperial",
		EPLRS_Capacity = true,
		playable = true,
		folderModName = "F-15E",
		moduleName = "F-15E",
		-- Tasks = {
		-- 	aircraft_task(CAP),
		-- 	aircraft_task(Escort),
		-- 	aircraft_task(FighterSweep),
		-- 	aircraft_task(Intercept),
		-- 	aircraft_task(PinpointStrike),
		-- 	aircraft_task(CAS),
		-- 	aircraft_task(GroundAttack),
		-- 	aircraft_task(RunwayAttack),
		-- },-- end of Tasks
		vCruise = 250,
		hCruise = 12670,
		refuellingReceptacleType = "probe"
	},
	["F-16C_50"] = 	{
		instrumentUnits = "imperial",
		folderModName = "F-16C",
		EPLRS_Capacity = true,
		datalinks = {
			type = "Link16",
			hasTeamMembers = 8,
			hasDonors = 4,
			isDonnor = true,
			isReceiver = true,

		},
		playable = true,
		vCruise = 220,
		hCruise = 9140,
		refuellingReceptacleType = "probe"
	},
	["F-16C bl.52d"] = 	{
		instrumentUnits = "imperial",
		EPLRS_Capacity = true,
		datalinks = {
			type = "Link16",
			isDonnor = true,
		},
		vCruise = 220,
		hCruise = 9140,
	},
	["F/A-18C"]  = 	{
		instrumentUnits = "imperial",
		EPLRS_Capacity = true,
		datalinks = {
			type = "Link16",
			isDonnor = true,
		},
	},
	["FA-18C_hornet"] = {
		instrumentUnits = "imperial",
		EPLRS_Capacity = true,
		folderModName = "FA-18C",
		datalinks = {
			type = "Link16",
			hasTeamMembers = 4,
			hasDonors = 8,
			isDonnor = true,
			isReceiver = true,
		},
		dataCartridge = true,
		playable = true,
		vCruise = 230,
		hCruise = 7548,
		refuellingReceptacleType = "drogue"
	},

	["H-6J"] = 	{
		instrumentUnits = "metric",
		EPLRS_Capacity = false,
	},
	["tu_22D"] = 	{
		instrumentUnits = "metric",
		EPLRS_Capacity = false,
		flyingAlone = true,
	},
	["AJS37"] = 	{
		instrumentUnits = "imperial",
		EPLRS_Capacity = false,
		playable = true,
		folderModName = "AJS37",
		vCruise = 200,
		hCruise = 100,
	},
	["MB-339A"] = {
		instrumentUnits = "imperial",
		EPLRS_Capacity = false,
		playable = true,
	},
	["MirageF1"] = {--mod
		instrumentUnits = "imperial",
		EPLRS_Capacity = false,
		requiredModules = true,						--itsModule
	},

	["Mirage-F1CE"] = {
		inheritedFrom = "Mirage-F1",	--copy radio frequency, failures ...
		folderModName = "Mirage-F1",
		inheritedModFrom = "Mirage-F1C",
		refuellingReceptacleType = "drogue",
	},
	["Mirage-F1EE"] = {
		inheritedFrom = "Mirage-F1",	--copy radio frequency, failures ...
		folderModName = "Mirage-F1",
		inheritedModFrom = "Mirage-F1C",
		alignment_PropAircraft = {
			fast = {
				["INSStartMode"] = 1,
			},
			slow = {
				["INSStartMode"] = 0,
			}
		},
		refuellingReceptacleType = "drogue"
		
	},
	["Mirage-F1BE"] = {
		inheritedFrom = "Mirage-F1",	--copy radio frequency, failures ...
		folderModName = "Mirage-F1",
		inheritedModFrom = "Mirage-F1B",
		refuellingReceptacleType = "drogue"
	},

	["M-2000C"] = {
		instrumentUnits = "imperial",
		EPLRS_Capacity = false,
		folderModName = "M-2000C",
		playable = true,
		alignment_PropAircraft = {
			fast = {
				["ReadyALCM"] = true,
				["ForceINSRules"] = true,
				["InitHotDrift"] = 0,
			},
			slow = {
				["ReadyALCM"] = false,
				["ForceINSRules"] = true,
				["InitHotDrift"] = 0,
			}
		},

		refuellingReceptacleType = "drogue",
		vCruise = 250,
		hCruise = 8000,
	},

	["SA342"] = {
		instrumentUnits = "metric",
		EPLRS_Capacity = false,
		Tasks = {
			aircraft_task(Escort),
			aircraft_task(AFAC),
			aircraft_task(Reconnaissance),
			aircraft_task(GroundAttack),
	  	},
		playable = true,
		hCruise = 150,   -- m (vol très basse altitude typique)
		vCruise = 65,    -- m/s (≈ 235 km/h, croisière normale)
	},
	["SA342M"] = {
		-- instrumentUnits = "metric",
		-- EPLRS_Capacity = false,
		inheritedFrom = "SA342",	--copy radio frequency, failures ...
		inherited_APA_From = "SA342",	--copy AddPropAircraft
		-- playable = true,
		Tasks = {
			aircraft_task(GroundAttack),
			aircraft_task(CAS),
	  	},
	},
	["SA342Mistral"] = {
		-- instrumentUnits = "metric",
		-- EPLRS_Capacity = false,
		inheritedFrom = "SA342",	--copy radio frequency, failures ...
		inherited_APA_From = "SA342",	--copy AddPropAircraft
		-- playable = true,
	},
	["SA342L"] = {
		-- instrumentUnits = "metric",
		-- EPLRS_Capacity = false,
		inheritedFrom = "SA342",	--copy radio frequency, failures ...
		inherited_APA_From = "SA342",	--copy AddPropAircraft
		-- playable = true,
		Tasks = {
			aircraft_task(GroundAttack),
			aircraft_task(CAS),
	  	},
	},
	["SA342Minigun"] = {
		inheritedFrom = "SA342",
		Tasks = {
			aircraft_task(GroundAttack),
			aircraft_task(CAS),
	  	},
	},
	["UH-1H"] = {
		instrumentUnits = "imperial",
		EPLRS_Capacity = false,
		Tasks = {
			aircraft_task(CAS),
			aircraft_task(GroundAttack),
			aircraft_task(Transport),
	  	},
		playable = true,
		vCruise = 55,	--TODO a verifier
		hCruise = 50,
	},
	["AH-1G"] = {
		instrumentUnits = "imperial",
		EPLRS_Capacity = false,
		requiredModules = true,
		moduleName = "AH-1G",
		folderModName = "AH-1G",
		vCruise = 55,	--TODO a verifier
		hCruise = 50,
	},
	["AH-1W"] = {
		instrumentUnits = "imperial",
		EPLRS_Capacity = false,
		Tasks = {
			aircraft_task(CAS),
			aircraft_task(Escort),
			aircraft_task(AntishipStrike),
			aircraft_task(GroundAttack),
	  	},
		vCruise = 55,	--TODO a verifier
		hCruise = 50,
	},
	
	["vwv_uh2a"] = {--mod
		instrumentUnits = "imperial",
		EPLRS_Capacity = false,
		requiredModules = true,						--itsModule
		moduleName = "jjj_uh2a",		--self_ID  require module name
		folderModName = "[VWV] UH-2A",
		vCruise = 40,	--TODO a verifier
		hCruise = 500,
	},
	["vwv_uh2b"] = {--mod
		instrumentUnits = "imperial",
		EPLRS_Capacity = false,
		requiredModules = true,						--itsModule
		moduleName = "jjj_uh2b",		--self_ID  require module name
		folderModName = "[VWV] UH-2B",
		vCruise = 40,	--TODO a verifier
		hCruise = 500,
	},
	["vwv_uh2c"] = {--mod
		instrumentUnits = "imperial",
		EPLRS_Capacity = false,
		requiredModules = true,						--itsModule
		moduleName = "jjj_uh2c",
		folderModName = "[VWV] UH-2C",
		savedGameMod = true,
		vCruise = 40,	--TODO a verifier
		hCruise = 500,
	},
	["SH-3D"] = {--mod
		instrumentUnits = "imperial",
		requiredModules = true,						--itsModule
		moduleName = "SH-3D",
		folderModName = "SH-3D",
		vCruise = 40,	--TODO a verifier
		hCruise = 500,
	},
	["vwv_sh2f"] = {--mod
		instrumentUnits = "imperial",
		moduleName = "vwv_sh2f",
		folderModName = "[VWV] SH-2F",
		requiredModules = true,						--itsModule
	},
	["vwv_ch46d"] = {
		instrumentUnits = "imperial",
		requiredModules = true,
		moduleName = "tetet_ch46d",
		folderModName = "[VWV] CH-46D",
		hCruise = 200,
		vCruise = 75, -- (m/s, ≈ 270 km/h)
	},
	["CH-47D"] = {
		instrumentUnits = "imperial",
		EPLRS_Capacity = false,
		Tasks = {
			aircraft_task(Transport),
		},
		hCruise = 200,
		vCruise = 75, -- (m/s, ≈ 270 km/h)
	},
	["CH-47Fbl1"] = {
		instrumentUnits = "imperial",
		EPLRS_Capacity = false,
		playable = true,
		folderModName = "CH-47F",
		hCruise = 200,
		vCruise = 75, -- (m/s, ≈ 270 km/h)
	},
	["SH-60B"] = {
		instrumentUnits = "imperial",
		vCruise = 65,
		hCruise = 500,
	},
	["UH-60L"] = {
		instrumentUnits = "imperial",
		requiredModules = true,						--itsModule
	},
	["OH58D"] = {
		instrumentUnits = "imperial",
		EPLRS_Capacity = false,
		playable = true,
		folderModName = "OH-58D",
		hCruise = 150,
		vCruise = 65, -- (m/s, ≈ 235 km/h)
	},
	["OH-6A"] = {
		instrumentUnits = "imperial",
		requiredModules = true,						--itsModule
		folderModName = "OH-6A",
		addTasks = {                     -- defined in db_units_planes.lua
			-- aircraft_task(Transport), --31
			-- aircraft_task(Reconnaissance),
			aircraft_task(CAS),
		},
		playable = true,
	},
	["AH-64D_BLK_II"] = {
		instrumentUnits = "imperial",
		EPLRS_Capacity = true,
		datalinks = {
			type = "IDM",
			hasTeamMembers = 8,
			hasDonors = 8,
			isDonnor = true,
			isReceiver = true,
		},
		playable = true,
	},
	["AH-64A"] = {
		instrumentUnits = "imperial",
		EPLRS_Capacity = false,
	},


	["JF-17"] = {
		instrumentUnits = "imperial",
		playable = true,
		folderModName = "ChinaAssetPack",
		add_aircraftFileName = "Entries/Aircrafts.lua",

		EPLRS_Capacity = true,
	},

	["L-39"] = {--Common aircraft definitions
		instrumentUnits = "russian",
		EPLRS_Capacity = false,
	},
	["L-39C"] = {
		instrumentUnits = "russian",
		folderModName = "L-39",
		EPLRS_Capacity = false,
		inheritedFrom = "L-39",	--copy radio frequency, failures ...
		playable = true,
	},
	["L-39ZA"] = {
		instrumentUnits = "russian",
		EPLRS_Capacity = false,
		inheritedFrom = "L-39",	--copy radio frequency, failures ...
		playable = true,
		folderModName = "L-39",
	},

	["MiG-15bis"] = {
		instrumentUnits = "russian",
		EPLRS_Capacity = false,
		folderModName = "MiG-15bis",
		playable = true,
		vCruise = 180,   -- m/s 648km/h M ≈ 0.59
		hCruise = 8500,  -- m
	},

	["vwv_mig17f"] = 	{			                 	--Mod
		instrumentUnits = "russian",
		requiredModules = true,						--itsModule
		EPLRS_Capacity = false,
		moduleName = "tetet_mig17f",
		folderModName = "[VWV] MiG-17",
		vCruise = 200,   -- m/s 720km/h M ≈ 0.66
		hCruise = 9000,  -- m
	},

	["MiG-19P"] = {
		instrumentUnits = "russian",
		EPLRS_Capacity = false,
		folderModName = "MiG-19P",
		playable = true,
		alignment_PropAircraft = {
			fast = {
				["NAV_Initial_Hdg"] = 1,
			},
			slow = {
				["NAV_Initial_Hdg"] = 0,
			}
		},
		vCruise = 220,   -- m/s (≈ 792 km/h)Mach ≈ 0.72
		hCruise = 9000,  -- m (≈ 9 000 m)
	},
	
	["vwv_mig21pfm"] = 	{			                 	--Mod
		instrumentUnits = "russian",
		requiredModules = true,						--itsModule
		EPLRS_Capacity = false,
		moduleName = "tetet_mig21pfm",
		folderModName = "vwv_MiG-21PFM",
		vCruise = 220,   -- m/s
		hCruise = 11000, -- m
	},

	["vwv_mig21mf"] = 	{			                 	--Mod
		instrumentUnits = "russian",
		requiredModules = true,						--itsModule
		EPLRS_Capacity = false,
		moduleName = "tetet_mig21mf",
		folderModName = "[VWV] MiG-21MF",
		vCruise = 240,   -- m/s (≈ 864 km/h)Mach ≈ 0.81
		hCruise = 11000, -- m (≈ 11 000 m)
	},

	["MiG-21Bis"] = {
		instrumentUnits = "russian",
		EPLRS_Capacity = false,
		playable = true,
		folderModName = "MiG-21bis",
		vCruise = 225,
		hCruise = 7548,
	},
	["MiG-23MLD"] = {
		instrumentUnits = "russian",
		EPLRS_Capacity = false,
		vCruise = 255,
		hCruise = 7822,
	},
	["MiG-25PD"] = {
		instrumentUnits = "russian",
		EPLRS_Capacity = false,
		vCruise = 255,
		hCruise = 7822,
	},
	
	["MiG-25RBT"] = {
		instrumentUnits = "russian",
		EPLRS_Capacity = false,
		flyingAlone = true,
		vCruise = 183,
		hCruise = 7547,
	},
	["MiG-27K"] = {
		instrumentUnits = "russian",
		EPLRS_Capacity = false,
		vCruise = 190,
		hCruise = 6358,
	},
	["MiG-29 Fulcrum"] = {
		instrumentUnits = "russian",
		EPLRS_Capacity = false,
		playable = true,
		folderModName = "MiG-29-Fulcrum",
		alignment_PropAircraft = {
			fast = {
				["IMU alignment type"] = 0,
			},
			slow = {
				["IMU alignment type"] = 1,
			},
		},
		vCruise = 240, --m/s--a peaufiner
		hCruise = 9000,	-- m--a peaufiner
	},
	["MiG-29A"] = {
		instrumentUnits = "russian",
		EPLRS_Capacity = false,
		playable = true,
		Tasks = {
			aircraft_task(CAP),
			aircraft_task(Escort),
			aircraft_task(FighterSweep),
			aircraft_task(Intercept),
			aircraft_task(GroundAttack),
			aircraft_task(CAS),
			aircraft_task(RunwayAttack),
			aircraft_task(AntishipStrike),
		},
		vCruise = 213,
		hCruise = 7011,
	},
	["MiG-29S"] = {
		instrumentUnits = "russian",
		EPLRS_Capacity = false,
		playable = true,
		vCruise = 213,
		hCruise = 7011,
	},
	["MiG-31"] = {
		instrumentUnits = "russian",
		EPLRS_Capacity = false,
		vCruise = 220,
		hCruise = 10500,
	},
	["Su-17M4"] = {
		instrumentUnits = "russian",
		EPLRS_Capacity = false,
		vCruise = 180,
		hCruise = 6358,
	},
	["Su-24M"] = {
		instrumentUnits = "russian",
		EPLRS_Capacity = false,
		vCruise = 190,
		hCruise = 6938,
	},
	["Su-25"] = {
		instrumentUnits = "russian",
		EPLRS_Capacity = false,
		playable = true,
		vCruise = 180,
		hCruise = 5000,
	},

	["Su-25T"] = {
		instrumentUnits = "russian",
		EPLRS_Capacity = false,
		inheritedFrom = "Su-25",	--copy radio frequency, failures ...
		playable = true,
		vCruise = 185,
		hCruise = 5000,
	},
	["Su-25TM"] = {
		instrumentUnits = "russian",
		EPLRS_Capacity = false,
		inheritedFrom = "Su-25",	--copy radio frequency, failures ...
		-- playable = true,
		vCruise = 185,
		hCruise = 5000,
	},
	["Su-27"] = {
		instrumentUnits = "russian",
		EPLRS_Capacity = false,
		playable = true,
		Tasks = {
			aircraft_task(CAP),
			aircraft_task(Escort),
			aircraft_task(FighterSweep),
			aircraft_task(Intercept),
			aircraft_task(GroundAttack),
			aircraft_task(CAS),
			aircraft_task(RunwayAttack),
			aircraft_task(AntishipStrike),
		},
		vCruise = 213.222,--TODO a confirmer
		hCruise = 8500,
	},
	["J-11A"] = {
		instrumentUnits = "russian",
		EPLRS_Capacity = false,
		playable = true,
		Tasks = {
			aircraft_task(CAP),
			aircraft_task(Escort),
			aircraft_task(FighterSweep),
			aircraft_task(Intercept),
			aircraft_task(GroundAttack),
			aircraft_task(CAS),
			aircraft_task(RunwayAttack),
			aircraft_task(AntishipStrike),
		},
		vCruise = 213.222,--TODO a confirmer
		hCruise = 8500,
	},
	["Su-30"] = {
		instrumentUnits = "russian",
		EPLRS_Capacity = false,
		vCruise = 230,
		hCruise = 10000,
	},
	["Su-33"] = {
		instrumentUnits = "russian",
		-- folderModName = "Su-33",
		playable = true,
		Tasks = {
			aircraft_task(CAP),
			aircraft_task(Escort),
			aircraft_task(FighterSweep),
			aircraft_task(Intercept),
			aircraft_task(GroundAttack),
			aircraft_task(CAS),
			aircraft_task(RunwayAttack),
			aircraft_task(AntishipStrike),
		},
		vCruise = 213.222,--TODO a confirmer
		hCruise = 7548,
	},
	["Su-34"] = {
		instrumentUnits = "russian",
		EPLRS_Capacity = false,
		vCruise = 250,
		hCruise = 9500,
	},
	["Ka-27"] = {
		instrumentUnits = "russian",
		EPLRS_Capacity = false,
	},
	["Mi-8MT"] = {--data a garder, ancien module, information non accessible
		instrumentUnits = "russian",
		EPLRS_Capacity = false,
		playable = true,
		Tasks = {
			aircraft_task(AFAC),
			aircraft_task(GroundAttack),
			aircraft_task(CAS),
			aircraft_task(Transport),
			aircraft_task(AntishipStrike),
		},
		vCruise = 63,
		hCruise = 50,
	},
	["Mi-24V"] = {
		instrumentUnits = "russian",
		EPLRS_Capacity = false,
		hCruise = 150,    -- m  (vol basse altitude typique)
		vCruise = 75,     -- m/s  (≈ 270 km/h)
	},
	["Mi-24P"] = {
		instrumentUnits = "russian",
		EPLRS_Capacity = false,
		playable = true,
		folderModName = "Mi-24P",
		hCruise = 150,    -- m  (vol basse altitude typique)
		vCruise = 75,     -- m/s  (≈ 270 km/h)
	},
	["Mi-28N"] = {
		instrumentUnits = "russian",
		EPLRS_Capacity = false,
	},
	["Ka-50"] = {
		instrumentUnits = "russian",
		EPLRS_Capacity = false,
		playable = true,
		folderModName = "Ka-50",
	},
	["Ka-50_3"] = {
		instrumentUnits = "russian",
		EPLRS_Capacity = false,
		playable = true,
		folderModName = "Ka-50",
	},


	["E-3A"] = {
		instrumentUnits = "imperial",
		EPLRS_Capacity = true,
		datalinks = {
			type = "Link16",
			isDonnor = true,
		},
		vCruise = 230,
		hCruise = 9150,
	},
	["E-2C"] = {
		instrumentUnits = "imperial",
		EPLRS_Capacity = true,
		datalinks = {
			type = "Link16",
			isDonnor = true,
		},
		vCruise = 145,
		hCruise = 7600,
	},
	["A-50"] = {
		instrumentUnits = "russian",
		EPLRS_Capacity = false,
		vCruise = 205,
		hCruise = 9150,
	},

	["S-3B Tanker"] = {
		instrumentUnits = "imperial",
		EPLRS_Capacity = false,
		flyingAlone = true,
		refuellingType = "drogue",
		vCruise = 180,
		hCruise = 1828.8,
	},
	["KC135MPRS"] = {
		instrumentUnits = "imperial",
		EPLRS_Capacity = false,
		vCruise = 185,
		hCruise = 7345,
		refuellingType = "drogue"
	},
	["KC-135"] = {
		instrumentUnits = "imperial",
		EPLRS_Capacity = false,
		datalinks = {
			type = "Link16",
			isDonnor = true,
		},
		vCruise = 185,
		hCruise = 7345,
		refuellingType = "probe"
	},
	["KC130"] = {
		instrumentUnits = "imperial",
		EPLRS_Capacity = false,
	},
	["IL-78M"] = {
		instrumentUnits = "russian",
		EPLRS_Capacity = false,
	},

	["Su-24MR"] = {
		instrumentUnits = "russian",
		EPLRS_Capacity = false,
		vCruise = 250,
		hCruise = 10096,
	},

	["Tu-22M3"] = {
		instrumentUnits = "russian",
		EPLRS_Capacity = false,
		flyingAlone = true,
		heavyBomber = true,
		Tasks = {
			aircraft_task(GroundAttack),
			aircraft_task(RunwayAttack),
			aircraft_task(AntishipStrike),
		},
		hCruise = 10000,   -- m
		vCruise = 260,     -- m/s (≈ 935 km/h, Mach 0.84 à 10 km)

	},
	["Tu-95MS"] = {
		instrumentUnits = "russian",
		EPLRS_Capacity = false,
		flyingAlone = true,
		heavyBomber = true,
		Tasks = {
			aircraft_task(GroundAttack), --TODO a verifier
			aircraft_task(RunwayAttack),
			aircraft_task(AntishipStrike),
		},
		hCruise = 9000,
		vCruise = 220, -- (m/s)
	},
	["Tu-142"] = {
		instrumentUnits = "russian",
		EPLRS_Capacity = false,
		flyingAlone = true,
		heavyBomber = true,
		Tasks = {
			aircraft_task(Reconnaissance),
			aircraft_task(AntishipStrike),
		},
		hCruise = 10000,   -- m
		vCruise = 260,     -- m/s --TODO a confirmer
	},
	["Tu-160"] = {
		instrumentUnits = "russian",
		EPLRS_Capacity = false,
		flyingAlone = true,
		heavyBomber = true,
		Tasks = {
			aircraft_task(GroundAttack),
			aircraft_task(RunwayAttack),
			aircraft_task(AntishipStrike),
		},
		hCruise = 10000,   -- m
		vCruise = 260,     -- m/s 
	},

	["An-30M"] = {
		instrumentUnits = "imperial",
		EPLRS_Capacity = false,
	},
	["An-26B"] = {
		instrumentUnits = "russian",
		EPLRS_Capacity = false,
		vCruise = 123,
		hCruise = 7500,
	},
	["IL-76MD"] = {
		instrumentUnits = "russian",
		EPLRS_Capacity = false,
	},


}

PayloadType = {
	["C-47"] = 10000,					--a consolider
	["C-17A"] = 70000,					--max 77000 mais longue piste � pr�voir
	["C-130"] = 19000,					--Kg
	["Hercules"] = 19000,

	["CH-47D"] = 10000,
	["CH-47Fbl1"] = 10000,
	["CH-53E"] = 14000,					--16000 en externe
	["SH-3D"] = 2700,
	["SH-60B"] = 1800,
	["UH-60A"] = 1100,					--4000 en externe
	["UH-60L"] = 1100,					--4000 en externe
	["UH-1H"] = 1500,
	["OH58D"] = 500,
	["OH-6A"] = 500,

	["An-30M"] = 5000,
	["An-26B"] = 5500,
	["IL-76MD"] = 40000,
	["Yak-40"] = 2700,

	["Ka-27"] = 4000,
	["Mi-8MT"] = 4000,
	["Mi-24V"] = 2400,
	["Mi-24P"] = 2400,
	["Mi-26"] = 20000,
}

IsHelicopter = {
	--West Side
	["SA342M"] = {},
	["SA342L"] = {},
	["SA342Minigun"] = {},

	["UH-1H"] = {},
	["AH-1G"] = {},
	["AH-1W"] = {},

	["vwv_uh2a"] = {},                            --mod
	["vwv_uh2b"] = {},                            --mod
	["vwv_uh2c"] = {},                            --mod
	["vwv_sh2f"] = {},                            --mod
	["vwv_hh2d"] = {},                            --mod

	
	["vwv_ch46d"] = {},
	["CH-47D"] = {},
	["CH-47Fbl1"] = {},
	["CH-53E"] = {},
	["SH-3D"] =
	{
		hHover = 2500,
	},
	["SH-60B"] = {},
	["UH-60A"] = {},
	["UH-60L"] = {},

	["AH-64A"] = {},
	["AH-64D"] =
	{
		hHover = 3505,
	},
	["AH-64D_BLK_II"] =
	{
		["hHover"] = 2990,
	},

	["OH58D"] = {},
	["OH-6A"] = {},


	--East Side
	["Ka-27"] = {},
	["Ka-50"] = {},
	["Ka-50_3"] = {},

	["Mi-8MT"] =
	{
		hHover = 3960,
	},
	["Mi-24P"] =
	{
		hHover = 1500,
	},
	["Mi-24V"] = {},
	["Mi-26"] =
	{
		hHover = 1500,
	},

}

--CustomTasksScript:
--CAS						AttackGroup		AttackUnit			AttackUnit(Static)
--Pinpoint Strike			Bombing 		AttackMapObject
--Ground Attack				Bombing 		AttackMapObject		CarpetBombing
--Runway Attack				Bombing			AttackMapObject		BombingRunway


--CustomTasksScript:
--							Bombing			AttackGroup		AttackUnit		AttackMapObject		BombingRunway		CarpetBombing
--CAS											X				X (&Static)
--Pinpoint Strike				X													X
--Ground Attack					X													X										X
--Runway Attack					X													X					X


--pb F18	"Pinpoint Strike" + AttackGroup  (pas pr�vu)
--pb Mi24	"GroundAttack" + AttackUnit (pas pr�vu)
GoupTask = {
	["CAS"] = {
		["AttackGroup"] = true,
		["AttackUnit"] = true,
	},
	["Pinpoint Strike"] = {
		["Bombing"] = true,
		["AttackMapObject"] = true,
	},
	["Ground Attack"] = {
		["Bombing"] = true,
		["AttackMapObject"] = true,
		["CarpetBombing"] = true,
		["AttackGroup"] = true,
		["AttackUnit"] = true,
	},
	["Runway Attack"] = {
		["Bombing"] = true,
		["AttackMapObject"] = true,
		["BombingRunway"] = true,
	},
	["Intercept"] = {
		["EngageTargetsInZone"] = true,
	},
	["Antiship Strike"] = {
		["AttackGroup"] = true,
	},
	["Escort"] = {
		["EngageTargetsInZone"] = true,
	},
	["CAP"] = {
		["EngageTargetsInZone"] = true,
	},
	["SEAD"] = {
		["EngageTargets"] = true,
	},
	["AWACS"] = {
		["AWACS"] = true,
	},
	["Refueling"] = {
		["Tanker"] = true,
	},
	["SAR"] = {
		["Transport"] = true,
	},
	["CSAR"] = {
		["Transport"] = true,
	},
	["Transport"] = {
		["Transport"] = true,
	},
	["AFAC"] = {
		["AFAC"] = true,
	},
}
--							Bombing			AttackGroup		AttackUnit		AttackMapObject		BombingRunway		CarpetBombing
--CAS											X				X (&Static)
--Pinpoint Strike				X													X
--Ground Attack					X													X										X
--Runway Attack					X													X					X

StrikeDegradedMode = {
	["CAS"] = {
		["AttackGroup"] = true,
		["AttackUnit"] = true,
	},
	["Pinpoint Strike"] = {
		["Bombing"] = true,
	},
	["Ground Attack"] = {
		["Bombing"] = true,
	},
	["Runway Attack"] = {
		["Bombing"] = true,
	},
	["Antiship Strike"] = {
		["AttackGroup"] = true,
		["AttackUnit"] = true,
	},
}


GoupTaskByTypeTarget = {
	["DynamicGroup"] = {
		["CAS"] = {
			["AttackGroup"] = true,
			["AttackUnit"] = true,
		},
		["Pinpoint Strike"] = {
			["Bombing"] = true,
		},
		["Ground Attack"] = {
			["Bombing"] = true,
		},
		-- ["Runway Attack"] = {
			-- ["Bombing"] = true,
		-- },
	},
	["Static"] = {
		["CAS"] = {
			["AttackUnit"] = true,
		},
		["Pinpoint Strike"] = {
			["Bombing"] = true,
		},
		["Ground Attack"] = {
			["Bombing"] = true,
		},
		-- ["Runway Attack"] = {
			-- ["Bombing"] = true,
		-- },
	},
	["MapObject"] = {
		["Pinpoint Strike"] = {
			["AttackMapObject"] = true,
		},
		["Ground Attack"] = {
			["AttackMapObject"] = true,
		},
		["Runway Attack"] = {
			["AttackMapObject"] = true,
		},
	},
	["Runway"] = {
		["Runway Attack"] = {
			-- ["BombingRunway"] = true,
			["Bombing"] = true,
			-- ["CarpetBombing"] = true,
		},
	},
	["Ship"] = {

		["Antiship Strike"] = {
			["AttackGroup"] = true,
			["AttackUnit"] = true,
		},
		-- ["CAS"] = {
			-- ["AttackGroup"] = true,
			-- ["AttackUnit"] = true,
		-- },
		-- ["Pinpoint Strike"] = {
			-- ["Bombing"] = true,
		-- },
		-- ["Ground Attack"] = {
			-- ["Bombing"] = true,
		-- },
		-- ["Runway Attack"] = {
			-- ["Bombing"] = true,
		-- },
	},
	-- ["AA"] = {		
		-- ["Fighter Sweep"] = {
			-- ["EngageTargetsInZone"] = true,
		-- },		
		-- ["CAP"] = {
			-- ["EngageTargetsInZone"] = true,
			-- ["AttackUnit"] = true,
		-- },
		-- ["Escort"] = {
			-- ["EngageTargetsInZone"] = true,
		-- },
		-- ["Intercept"] = {
			-- ["EngageTargetsInZone"] = true,
		-- },
	-- },

	["Fighter Sweep"] = {
		["Fighter Sweep"] = {
			["EngageTargetsInZone"] = true,
		},
	},
	["CAP"] = {
		["CAP"] = {
			["EngageTargetsInZone"] = true,
			["AttackUnit"] = true,
		},
	},
	["Escort"] = {
		["Escort"] = {
			["EngageTargetsInZone"] = true,
		},
	},
	["Intercept"] = {
		["Intercept"] = {
			["EngageTargetsInZone"] = true,
		},
	},

	["SEAD"] = {
		["SEAD"] = {
			["EngageTargets"] = true,
		},
	},
	["AWACS"] = {
		["AWACS"] = {
			["AWACS"] = true,
		},
	},
	["AFAC"] = {
		["AFAC"] = {
			["AFAC"] = true,
		},
	},
	["Transport"] = {
		["Transport"] = {
			["Transport"] = true,
		},
	},
	["Reconnaissance"] = {
		["Reconnaissance"] = {
			["Reconnaissance"] = true,
		},
	},
	["Refueling"] = {
		["Refueling"] = {
			["Tanker"] = true,
		},
	},
	["Laser Illumination"] = {
		["AFAC"] = {
			["EngageTargetsInZone"] = true,
		},
	},
	["Escort Jammer"] = {
		["Ground Attack"] = {
			["Bombing"] = true,
		},
	},
	["SAR"] = {
		["Transport"] = {
			["Transport"] = true,
		},
	},
	["CSAR"] = {
		["Transport"] = {
			["Transport"] = true,
		},
	},
}



function IsWesternCountry(country)
    return not (
		 ("Russia" 			== country) or
		 ("Ukraine" 		== country) or
		 ("Insurgents" 		== country) or
		 ("Abkhazia" 		== country) or
		 ("South Ossetia" 	== country) or
		 ("China" 			== country) or
		 ("Belarus" 		== country) or
		 ("USSR" 			== country) or
		 ("Yugoslavia"		== country) or
		 ("GDR"				== country)

	)
end


-- WestCallsign = {	

	-- ["Argentina"] = "west", 
	-- ["Bolivia"] = "west", 
	-- ["Chile"] = "west", 
	-- ["Cuba"] = "west", 
	-- ["Honduras"] = "west", 
	-- ["Mexico"] = "west", 

	-- ["Australia"] = "west", 
	-- ["Belgium"] = "west",
	-- ["Canada"] = "west", 


	-- ["CJTF Blue"] = "west",	
	-- ["Croatia"] = "west",
	-- ["Cyprus"] = "west",

	-- ["Denmark"] = "west",			
	-- ["France"] = "west", 
	-- ["Georgia"] = "west",
	-- ["Greece"] = "west",

	-- ["India"] = "west",
	-- ["Iran"] = "west",
	-- ["Israel"] = "west",
	-- ["Italy"] = "west", 

	-- ["Norway"] = "west", 
	-- ["Pakistan"] = "west",

	-- ["South Korea"] = "west", 
	-- ["Spain"] = "west", 
	-- ["Sweden"] = "west",

	-- ["The Netherlands"] = "west", 
	-- ["Turkey"] = "west",

	-- ["UK"] = "west",
	-- ["United Arab Emirates"] = "west",
	-- ["USA"] = "west", 
	-- ["USAF Aggressors"] = "west", 
-- }

Callsign_west = {
	generic = {
		[1] = "Enfield",
		[2] = "Springfield",
		[3] = "Uzi",
		[4] = "Colt",
		[5] = "Dodge",
		[6] = "Ford",
		[7] = "Chevy",
		[8] = "Pontiac",
	},
	AWACS = {
		[1] = "Overlord",
		[2] = "Magic",
		[3] = "Wizard",
		[4] = "Focus",
		[5] = "Darkstar",
	},
	tanker = {
		[1] = "Texaco",
		[2] = "Arco",
		[3] = "Shell",
	},
	JTAC_EWR = {
		[1] = "Axeman",
		[2] = "Darknight",
		[3] = "Warrior",
		[4] = "Pointer",
		[5] = "Eyeball",
		[6] = "Moonbeam",
		[7] = "Whiplash",
		[8] = "Finger",
		[9] = "Pinpoint",
		[10] = "Ferret",
		[11] = "Shaba",
		[12] = "Playboy",
		[13] = "Hammer",
		[14] = "Jaguar",
		[15] = "Deathstar",
		[16] = "Anvil",
		[17] = "Firefly",
		[18] = "Mantis",
		[19] = "Badger",
	}
}

--https://wiki.hoggitworld.com/view/DCS_enum_callsigns
SpecificCallnames = {
	["FA-18C_hornet"] = {
		["USA"] = {
			[9] = 'Hornet',
			[10] = 'Squid',
			[11] = 'Ragin',
			[12] = 'Roman',
			[13] = 'Sting',
			[14] = 'Jury',
			[15] = 'Joker',
			[16] = 'Ram',
			[17] = 'Hawk',
			[18] = 'Devil',
			[19] = 'Check',
			[20] = 'Snake',
		},
	},
	["F-16C_50"] = {
		["USA"] = {
			[9] = 'Viper',
			[10] = 'Venom',
			[11] = 'Lobo',
			[12] = 'Cowboy',
			[13] = 'Python',
			[14] = 'Rattler',
			[15] = 'Panther',
			[16] = 'Wolf',
			[17] = 'Weasel',
			[18] = 'Wild',
			[19] = 'Ninja',
			[20] = 'Jedi',
		},
	},
	["A-10A"] = {
		["USA"] = {
			[9] = 'Hawg',
			[10] = 'Boar',
			[11] = 'Pig',
			[12] = 'Tusk',
		},
	},
	["A-10C"] = {
		["USA"] = {
			[9] = 'Hawg',
			[10] = 'Boar',
			[11] = 'Pig',
			[12] = 'Tusk',
		},
	},
	["A-10C_2"] = {
		["USA"] = {
			[9] = 'Hawg',
			[10] = 'Boar',
			[11] = 'Pig',
			[12] = 'Tusk',
		},
	},
	["B-1B"] = {
		["USA"] = {
			[9] = 'Bone',
			[10] = 'Dark',
			[11] = 'Vader',
		},
	},
	["B-52H"] = {
		["USA"] = {
			[9] = 'Buff',
			[10] = 'Dump',
			[11] = 'Kenworth',
		},
	},
	["C-130"] = {
		["USA"] = {
			[9] = 'Heavy',
			[10] = 'Trash',
			[11] = 'Cargo',
			[12] = 'Ascot',
		},
	},
	["Hercules"] = {
		["USA"] = {
			[9] = 'Heavy',
			[10] = 'Trash',
			[11] = 'Cargo',
			[12] = 'Ascot',
		},
	},
	["C-17A"] = {
		["USA"] = {
			[9] = 'Heavy',
			[10] = 'Trash',
			[11] = 'Cargo',
			[12] = 'Ascot',
		},
	},
	["C-47"] = {
		["USA"] = {
			[9] = 'Heavy',
			[10] = 'Trash',
			[11] = 'Cargo',
			[12] = 'Ascot',
		},
	},
}

--useful table for choosing aircraft when generating missions
TabTask = {
	["a"] = "Anti-ship Strike",
		["Anti-ship Strike"] = "a",
	["af"] = "AFAC",
		["AFAC"] = "af",
	["c"] = "CAP",
		["CAP"] = "c",
	["d"] = "SEAD",
		["SEAD"] = "d",
	["e"] = "Escort",
		["Escort"] = "e",
	["ej"] = "Escort Jammer",
		["Escort Jammer"] = "ej",
	["f"] = "Fighter Sweep",
		["Fighter Sweep"] = "f",
	["i"] = "Intercept",
		["Intercept"] = "i",
	["l"] = "Laser Illumination",
		["Laser Illumination"] = "l",
	["r"] = "Reconnaissance",
		["Reconnaissance"] = "r",
	["s"] = "Strike",
		["Strike"] = "s",
	["ra"] = "Runway Attack",
		["Runway Attack"] = "ra",
	["t"] = "Transport",
		["Transport"] = "t",
	["u"] = "Refueling",
		["Refueling"] = "u",
	["sa"] = "SAR",
		["SAR"] = "sa",
	["cs"] = "CSAR",
		["CSAR"] = "cs",
}

Failures = {

	["A-10A"] = {
		'asc',--('ASC'),
		'autopilot',--('AUTOPILOT'),
		'hydro',--('HYDRO'),
		'l_engine', --('L-ENGINE'),
		'r_engine', --('R-ENGINE'),
		'mlws',--('MLWS'),
		'rws', --('RWS'),
		'ecm', --('ECM'),
		'hud', --('HUD'),
		'mfd', --('MFD'),		
	},
	["A-10C"] = {
		'l_engine',--('L-ENGINE'),
		'r_engine', --('R-ENGINE'),
		'hydro_left',--('L-HYDRO'),
		'hydro_right',--('R-HYDRO'),
		'sas_yaw_left',--('SAS YAW LEFT'),
		'sas_yaw_right',--('SAS YAW RIGHT'),
		'sas_pitch_left',--('SAS PITCH LEFT'),
		'sas_pitch_right',--('SAS PITCH RIGHT'),
		'l_gen',	--('L-GENERATOR'),
		'r_gen', --('R-GENERATOR'),
		'l_conv',--('L-CONVERTER'),
		'r_conv',--('R-CONVERTER'),
		'HUD_FAILURE',--('HUD'),		
		'AAR_47_FAILURE_TOTAL',--('AAR-47'),	
		'AAR_47_FAILURE_SENSOR_RIGHT',--('AAR-47 right sensor'),
		'AAR_47_FAILURE_SENSOR_LEFT',--('AAR-47 left sensor'),
		'AAR_47_FAILURE_SENSOR_TAIL',--('AAR-47 tail sensor'),
		'AAR_47_FAILURE_SENSOR_BOTTOM',--('AAR-47 bottom sensor'),
		'AIRSPEED_INDICATOR_FAILURE',--('Airspeed indicator'),
		'AN_ALE_40V_FAILURE_TOTAL',--('AN/ALE-40V'),
		'AN_ALE_40V_FAILURE_CONTAINER_LEFT_WING',--('AN/ALE-40V left wingtip container'),
		'AN_ALE_40V_FAILURE_CONTAINER_LEFT_GEAR',--('AN/ALE-40V left main gear container'),
		'AN_ALE_40V_FAILURE_CONTAINER_RIGHT_GEAR',--('AN/ALE-40V right main gear container'),
		'AN_ALE_40V_FAILURE_CONTAINER_RIGHT_WING',--('AN/ALE-40V right wingtip container'),
		'AN_ALR69V_FAILURE_TOTAL',--('AN/ALR69V'),	
		'AN_ALR69V_FAILURE_SENSOR_NOSE_RIGHT',	  --('AN/ALR-69V nose right sensor'),	
		'AN_ALR69V_FAILURE_SENSOR_NOSE_LEFT',	  --('AN/ALR-69V nose left sensor'),	
		'AN_ALR69V_FAILURE_SENSOR_TAIL_RIGHT',	  --('AN/ALR-69V tail right sensor'),	
		'AN_ALR69V_FAILURE_SENSOR_TAIL_LEFT',	  --('AN/ALR-69V tail left sensor'),	
		'RADAR_ALTIMETR_LEFT_ANT_FAILURE',	  	--('AN/APN-194 left antenna'),		
		'RADAR_ALTIMETR_RIGHT_ANT_FAILURE',	  	--('AN/APN-194 right antenna'),		
		'CADC_FAILURE_TOTAL',--('CADC'),		
		'CADC_FAILURE_TEMPERATURE',--('CADC temperature sensor'),		
		'CADC_FAILURE_MACH',		  	  			--('CADC mach sensor'),
		'CADC_FAILURE_TAS',		  				--('CADC TAS sensor'),
		'CADC_FAILURE_IAS',		  				--('CADC IAS sensor'),
		'CADC_FAILURE_BARO_ALT',		  			--('CADC baro alt sensor'),
		'CADC_FAILURE_PRESSURE_ALT',	  			--('CADC pressure alt sensor'),		
		'CADC_FAILURE_DYNAMIC',		  			--('CADC dynamic pressure sensor'),	
		'CADC_FAILURE_STATIC',		  			--('CADC static pressure sensor'),	
		'CLOCK_FAILURE',		  	  				--('Digital clock'),
		'IFFCC_FAILURE_TOTAL',		  			--('IFFCC'),		
		'ILS_FAILURE_TOTAL',		  				--('ILS AN/ARN-118'),
		'ILS_FAILURE_ANT_LOCALIZER',	  			--('ILS AN/ARN-118 localizer antenna'),
		'ILS_FAILURE_ANT_GLIDESLOPE',	  		--('ILS AN/ARN-118 glideslope antenna'),
		'ILS_FAILURE_ANT_MARKER',	  			--('ILS AN/ARN-118 marker antenna'),	
		'LEFT_MFCD_FAILURE',		  				--('Left MFCD'),	
		'RIGHT_MFCD_FAILURE',		  			--('Right MFCD'),
		'SADL_FAILURE_TOTAL',		  			--('SADL'),		
		'TACAN_FAILURE_TOTAL',		  			--('TACAN AN/ARN-118'),
		'TACAN_FAILURE_TRANSMITTER',	  			--('TACAN AN/ARN-118 transmitter'),	
		'TACAN_FAILURE_RECEIVER',	  			--('TACAN AN/ARN-118 receiver'),		
		'TGP_FAILURE_RIGHT',		  				--('TGP on right wing'),
		'TGP_FAILURE_LEFT',		  				--('TGP on left wing'),
		'UHF_RADIO_FAILURE_TOTAL',	  			--('UHF radio'),	
		'VHF_AM_RADIO_FAILURE_TOTAL',	  		--('VHF AM radio'),
		'VHF_FM_RADIO_FAILURE_TOTAL',	  		--('VHF FM radio'),
		'IFFCC_FAILURE_GUN',	  					--('GUN'),		
		'CICU_FAILURE_TOTAL',	  				--('CICU'),		
		'CDU_FAILURE_TOTAL',	  					--('CDU'),		
		'EGI_FAILURE_TOTAL',	  					--('EGI'),		
    },

	["C-101"] =
	{
		"generator_fail",--("Generator failure"),	
		"starter_fail",  --("Starter failure"),		
		"batteries_fail",--("Batteries failure"),	
		"inverters_fail",--("Inverters failure"),    
		"inverter1_fail",--("Normal inverter failure"), 
		"inverter2_fail",--("Standby inverter failure"), 		
		"engine_flameout_irrecoverable",--("Engine flameout without relight"), 
		"engine_flameout_recoverable",--("Engine flameout with relight"), 
		"engine_fire",--("Engine fire"),    		
		"oil_press_drop",--("Oil pressure drop"),    
		"chip_in_oil",   --("Chip in oil"),          		
		"fuel_leak",     --("Fuel leak"),            
		"engine_seized", --("Engine seized"),        
		"engine_antiice_fail",--("Engine anti-ice failure"), 
		"eng_computer_fail",--("Engine computer fail (manual mode)"), 		
		"hydr_leak",     --("Hydraulic leak"),       
		"elevator_loss",  --("Elevator loss"),         		
		"aileron_loss",  --("Aileron loss"),         
		"rudder_loss",  --("Rudder loss"),         
		"pitch_trim_runaway_up",--("Pitch trim runaway - Nose up"), 		
		"pitch_trim_runaway_down",--("Pitch trim runaway - Nose down"), 
		"pitch_trim_fail",--("Control stick pitch trim switch failure"), 
		"aileron_trim_fail",--("Control stick aileron trim switch failure"), 
		"airbrake_cutout_microsw_malf",--("Airbrake autotrim cutout malfunction"), 		
		"LGear_ext_fault",--("Left gear extension fault"), 		
		"LGear_ret_fault",--("Left gear retraction fault"), 
		"RGear_ext_fault",--("Right gear extension fault"), 
		"RGear_ret_fault",--("Right gear retraction fault"), 
		"NGear_ext_fault",--("Nose gear extension fault"), 
		"NGear_ret_fault",--("Nose gear retraction fault"), 
		"antiskid_fail",--("Antiskid fail"), 
		"flaps_fault",--("Flaps fault"), 
		"explosive_depressurization",--("Explosive depressurization"), 		
		"pitot_blocked", --("Pitot tube blocked"),   
		"static_blocked",--("Static port blocked"),  
		"pitot_heat_fail",--("Pitot heat fail"),  
		"gs_fail",--("ILS receiver GS signal fail"), 
		"loc_fail",--("ILS receiver LOC signal fail"), 
		"vor_fail",--("VOR receiver nav signal fail"), 
		"tacan_fail",--("TACAN receiver nav signal fail"), 
	},
	["C-101CC"] =
	{
		"generator_fail",--("Generator failure"),	
		"starter_fail",  --("Starter failure"),		
		"batteries_fail",--("Batteries failure"),	
		"inverters_fail",--("Inverters failure"),    
		"inverter1_fail",--("Normal inverter failure"), 
		"inverter2_fail",--("Standby inverter failure"), 		
		"engine_flameout_irrecoverable",--("Engine flameout without relight"), 
		"engine_flameout_recoverable",--("Engine flameout with relight"), 
		"engine_fire",--("Engine fire"),    
		"oil_press_drop",--("Oil pressure drop"),    
		"chip_in_oil",   --("Chip in oil"),          		
		"fuel_leak",     --("Fuel leak"),            
		"engine_seized", --("Engine seized"),        
		"engine_antiice_fail",--("Engine anti-ice failure"), 
		"eng_computer_fail",--("Engine computer fail (manual mode)"), 		
		"eng_computer_total_fail",--("Failure of auto and manual modes (back-up mode)"), 		
		"hydr_leak",     --("Hydraulic leak"),       
		"elevator_loss",  --("Elevator loss"),         		
		"aileron_loss",  --("Aileron loss"),         
		"rudder_loss",  --("Rudder loss"),         
		"pitch_trim_runaway_up",--("Pitch trim runaway - Nose up"), 		
		"pitch_trim_runaway_down",--("Pitch trim runaway - Nose down"), 
		"pitch_trim_fail",--("Control stick pitch trim switch failure"), 
		"aileron_trim_fail",--("Control stick aileron trim switch failure"), 
		"rudder_trim_fail",--("Rudder trim failure"), 
		"airbrake_cutout_microsw_malf",--("Airbrake autotrim cutout malfunction"), 		
		"LGear_ext_fault",--("Left gear extension fault"), 		
		"LGear_ret_fault",--("Left gear retraction fault"), 
		"RGear_ext_fault",--("Right gear extension fault"), 
		"RGear_ret_fault",--("Right gear retraction fault"), 
		"NGear_ext_fault",--("Nose gear extension fault"), 
		"NGear_ret_fault",--("Nose gear retraction fault"), 
		"antiskid_fail",--("Antiskid fail"), 
		"flaps_fault",--("Flaps fault"), 
		"explosive_depressurization",--("Explosive depressurization"), 		
		"pitot_blocked", --("Pitot tube blocked"),   
		"static_blocked",--("Static port blocked"),  
		"pitot_heat_fail",--("Pitot heat fail"),  
		"gs_fail",--("ILS receiver GS signal fail"), 
		"loc_fail",--("ILS receiver LOC signal fail"), 
		"vor_fail",--("VOR receiver nav signal fail"), 
		"dme_fail",--("DME signal fail"), 		
		"adf_fail",--("ADF receiver indication fail"), 
		"radioalt_fail",--("Radio altimeter signal fail"), 		
		"sight_lamps_fail",--("Gunsight lamps failure"),   
	},
	
	["MB-339A"] =
	{
		 "1",--("Starter/Generator 1 failure"),		
		 "2",--("Generator 2 failure"),		
		 "3",--("Inverter failure"),			
		 "4",--("Backup Inverter failure"),	
		 "5",--("Batteries failure"),			
		 "6",--("Engine low responsive"), 	
		 "7",--("Engine low performance"), 	
		 "8",--("Engine casual RPM drop"), 	
		 "9",--("JPT limiter fail"), 		
		 "10",--("Engine failure"), 			
		 "11",--("Oil pressure drop"),    	
		 "12",--("Engine compressor stall"),	
		 "13",--("Engine flameout with relight"), 
		 "14",--("Engine fire"),    					
		 "15",--("Fuel leak"),				
		 "16",--("Electrical pump failure"),	
		 "17",--("Machanical pump failure"),   
		 "18",--("Engine anti-ice failure"), 	
		 "19",--("Antiskid fail"),	
		 "20",--("Hydraulic pump failure"),	
		 "21",--("Main Hyd Circuit leak"), 	
		 "22",--("Emerg Hyd Circuit leak"),	
		 "23",--("Left Oxygen tank leak"), 	
		 "24",--("Right Oxygen tank leak"), 	
		 "25",--("Nose gear electrical fault"),  		
		 "26",--("Left gear electrical fault"),  
		 "27",--("Right gear electrical fault"), 
		 "28",--("Nose gear mechanical fault"),  		
		 "29",--("Left gear mechanical fault"),  
		 "30",--("Right gear mechanical fault"), 
		 "31",--("Elevator loss"),			
		 "32",--("Aileron loss"),     
		 "33",--("Rudder loss"),		
		 "34",--("Elevator trim loss"), 
		 "35",--("Aileron trim loss"), 
		 "36",--("Rudder trim loss"), 
		 "37",--("Flaps fault"), 	
		-- "38",--("Depressurization"),			
		-- "39",--("Explosive depressurization"),			
		 "40",--("Fwd Pitot tube blocked"),	
		 "41",--("Aft Pitot tube blocked"),	
		 "42",--("Fwd Pitot anti-ice fail"),	
		 "43",--("Aft Pitot anti-ice fail"),	
		 "44",--("Windshield Demist fail"),	
		 "45",--("Nosewheel Steering failure"), 
		-- "gs_fail",--("ILS receiver GS signal fail"), 		
		-- "loc_fail",--("ILS receiver LOC signal fail"), 		
		-- "vor_fail",--("VOR receiver nav signal fail"), 		
		-- "tacan_fail",--("TACAN receiver nav signal fail"), 	
		-- "dme_fail",--("DME signal fail"), 							
	},

	-- ["OH58D"] =
	-- {
	-- 	'engine',
	-- 	'LMFD',
	-- 	'RMFD',
	-- 	'MMSCamera',
	-- 	'Inverter',
	-- 	'Battery',
	-- 	'Rectifier Unit',
	-- 	'AC Generator',
	-- 	'DC Generator',
	-- 	'Transmission',
	-- 	'Hydraulic Reserve',
	-- 	'Tail Rotor',
	-- 	'Engine Oil',
	-- },
	["AH-64D_BLK_II"] =
	{
		'APU_Fire',--('APU Fire'),
		'LeftEngine_Fire',--('Engine 1 Fire'),
		'RightEngine_Fire',--('Engine 2 Fire'),			
	},


	["MiG-29 Fulcrum"] =
	{
		"NOSE_CENTER",
		"NOSE_LEFT_SIDE",
		"NOSE_RIGHT_SIDE",
		"COCKPIT",
		"CABIN_LEFT_SIDE",
		"CABIN_RIGHT_SIDE",
		"FRONT_GEAR_BOX",
		"FUSELAGE_LEFT_SIDE",
		"FUSELAGE_RIGHT_SIDE",
		"ENGINE_L",
		"ENGINE_R",
		"MTG_L_BOTTOM",
		"MTG_R_BOTTOM",
		"LEFT_GEAR_BOX",
		"RIGHT_GEAR_BOX",
		"MTG_L",
		"MTG_R",
		"AIR_BRAKE_L",
		"AIR_BRAKE_R",
		"WING_L_PART_OUT",
		"WING_R_PART_OUT",
		"WING_L_OUT",
		"WING_R_OUT",
		"AILERON_L",
		"AILERON_R",
		"WING_L_CENTER",
		"WING_R_CENTER",
		"WING_L_PART_IN",
		"WING_R_PART_IN",
		"WING_L_IN",
		"WING_R_IN",
		"FLAP_L_IN",
		"FLAP_R_IN",
		"FIN_L_TOP",
		"FIN_R_TOP",
		"FIN_L_BOTTOM",
		"FIN_R_BOTTOM",
		"ELEVATOR_L_IN",
		"ELEVATOR_R_IN",
		"RUDDER_L",
		"RUDDER_R",
		"TAIL",
		"TAIL_BOTTOM",
		"NOSE_BOTTOM",
		"FUSELAGE_BOTTOM",
		"WHEEL_F",
		"WHEEL_L",
		"WHEEL_R",
		"CREW_1",
	},

	["JF-17"] = {
        -- power system
        'EMMC_FAILURE_BATTERY_DC1',--('EMMC_FAILURE_BATTERY_DC1')
        'EMMC_FAILURE_BATTERY_DC2',--('EMMC_FAILURE_BATTERY_DC2')
        'EMMC_FAILURE_BATTERY_FCS1',--('EMMC_FAILURE_BATTERY_FCS1')
        'EMMC_FAILURE_BATTERY_FCS2',--('EMMC_FAILURE_BATTERY_FCS2')
        'EMMC_FAILURE_DC_GENERATOR_VOLTAGE_LOW',--('EMMC_FAILURE_DC_GENERATOR_VOLTAGE_LOW')
        'EMMC_FAILURE_DC_GENERATOR_VOLTAGE_HIGH',--('EMMC_FAILURE_DC_GENERATOR_VOLTAGE_HIGH')
        'EMMC_FAILURE_DC_GENERATOR',--('EMMC_FAILURE_DC_GENERATOR')
        'EMMC_FAILURE_DC_GENERATOR_CONTROLLER',--('EMMC_FAILURE_DC_GENERATOR_CONTROLLER')
        'EMMC_FAILURE_DC_GENERATOR_SUBSYSTEM',--('EMMC_FAILURE_DC_GENERATOR_SUBSYSTEM')
        'EMMC_FAILURE_AC_GENERATOR_FEED_LINE',--('EMMC_FAILURE_AC_GENERATOR_FEED_LINE')
        'EMMC_FAILURE_AC_GENERATOR_CONTROLLER',--('EMMC_FAILURE_AC_GENERATOR_CONTROLLER')
        'EMMC_FAILURE_AC_GENERATOR',--('EMMC_FAILURE_AC_GENERATOR')
        'EMMC_FAILURE_AC_GENERATOR_SUBSYSTEM',--('EMMC_FAILURE_AC_GENERATOR_SUBSYSTEM')
        'EMMC_FAILURE_TRU_AC2DC28V',--('EMMC_FAILURE_TRU_AC2DC28V')
        'EMMC_FAILURE_SCU_AC2AC36V',--('EMMC_FAILURE_SCU_AC2AC36V')
        'EMMC_FAILURE_SCU_DC2AC36V',--('EMMC_FAILURE_SCU_DC2AC36V')
        'EMMC_FAILURE_SCU_DC2AC115V',--('EMMC_FAILURE_SCU_DC2AC115V')
        'EMMC_FAILURE_AC_GROUND',--('EMMC_FAILURE_AC_GROUND')

        -- ext light failures
        'FAILURE_EXT_LIGHT_NAV_LEFT',--('FAILURE_EXT_LIGHT_NAV_LEFT')
        'FAILURE_EXT_LIGHT_NAV_RIGHT',--('FAILURE_EXT_LIGHT_NAV_RIGHT')
        'FAILURE_EXT_LIGHT_NAV_TAIL',--('FAILURE_EXT_LIGHT_NAV_TAIL')
        'FAILURE_EXT_LIGHT_ANTICOL',--('FAILURE_EXT_LIGHT_ANTICOL')
        'FAILURE_EXT_LIGHT_FORMATION_LEFT',--('FAILURE_EXT_LIGHT_FORMATION_LEFT')
        'FAILURE_EXT_LIGHT_FORMATION_RIGHT',--('FAILURE_EXT_LIGHT_FORMATION_RIGHT')
        'FAILURE_EXT_LIGHT_TAXI',--('FAILURE_EXT_LIGHT_TAXI')
        'FAILURE_EXT_LIGHT_LAND',--('FAILURE_EXT_LIGHT_LAND')

        -- Hydro failures
        'FAILURE_HYDRAULICS_EMERGE',--('FAILURE_HYDRAULICS_EMERGE')
        'FAILURE_HYDRAULICS_EMERGE_ACCU',--('FAILURE_HYDRAULICS_EMERGE_ACCU')
        'FAILURE_HYDRAULICS_1_PUMP',--('FAILURE_HYDRAULICS_1_PUMP')
        'FAILURE_HYDRAULICS_1_ACCU',--('FAILURE_HYDRAULICS_1_ACCU')
        'FAILURE_HYDRAULICS_1_EXTERNAL_LEAKAGE',--('FAILURE_HYDRAULICS_1_EXTERNAL_LEAKAGE')
        'FAILURE_HYDRAULICS_1_EXTERNAL_LEAKAGE_SEVERE',--('FAILURE_HYDRAULICS_1_EXTERNAL_LEAKAGE_SEVERE')
        'FAILURE_HYDRAULICS_1_INTERNAL_LEAKAGE',--('FAILURE_HYDRAULICS_1_INTERNAL_LEAKAGE')
        'FAILURE_HYDRAULICS_2_PUMP',--('FAILURE_HYDRAULICS_2_PUMP')
        'FAILURE_HYDRAULICS_2_ACCU',--('FAILURE_HYDRAULICS_2_ACCU')
        'FAILURE_HYDRAULICS_2_EXTERNAL_LEAKAGE',--('FAILURE_HYDRAULICS_2_EXTERNAL_LEAKAGE')
        'FAILURE_HYDRAULICS_2_EXTERNAL_LEAKAGE_SEVERE',--('FAILURE_HYDRAULICS_2_EXTERNAL_LEAKAGE_SEVERE')
        'FAILURE_HYDRAULICS_2_INTERNAL_LEAKAGE',--('FAILURE_HYDRAULICS_2_INTERNAL_LEAKAGE')

        -- Oxygen failures
        'OXY_FAILURE_AUTO_100_O2',--('OXY_FAILURE_AUTO_100_O2')
        'OXY_FAILURE_AIR_O2_SWITCH',--('OXY_FAILURE_AIR_O2_SWITCH')
        'OXY_FAILURE_HIGH_PRESS',--('OXY_FAILURE_HIGH_PRESS')
        'OXY_FAILURE_L_LEAK',--('OXY_FAILURE_L_LEAK')
        'OXY_FAILURE_L_LEAK_SEVERE',--('OXY_FAILURE_L_LEAK_SEVERE')
        'OXY_FAILURE_R_LEAK',--('OXY_FAILURE_R_LEAK')
        'OXY_FAILURE_R_LEAK_SEVERE',--('OXY_FAILURE_R_LEAK_SEVERE')

        ---- Nav related failures
        -- SHARS failure
        'SHARS_FAILURE_SENSOR',--('SHARS_FAILURE_SENSOR')

        -- INS failure
        'INS_FAILURE_GYRO',--('INS_FAILURE_GYRO')
        'INS_FAILURE_ACC',--('INS_FAILURE_ACC')
        'INS_FAILURE_DATA_INVALID',--('INS_FAILURE_DATA_INVALID')
        --[['INS_GPS_NAV_MODE_ACTIVE',--('INS_GPS_NAV_MODE_ACTIVE')]]
        'INS_FAILURE_ALGNMENT',--('INS_FAILURE_ALGNMENT')
        'INS_FAILURE_ALT_INVALID',--('INS_FAILURE_ALT_INVALID')
        'INS_DATA_DEGRADED',--('INS_DATA_DEGRADED')
        'INS_WIND_INVALID',--('INS_WIND_INVALID')
        'INS_FAILURE_GPS_RECEIVER',--('INS_FAILURE_GPS_RECEIVER')
        'INS_PU_REJECTED',--('INS_PU_REJECTED')

        -- SNS receiver failures
        'SNS_FAILURE_ANTENNA',--('SNS_FAILURE_ANTENNA')
        'FAILURE_SNS_CABLE',--('SNS_FAILURE_CABLE')
        'SNS_FAILURE_COMPUTER',--('SNS_FAILURE_COMPUTER')

        ---- Defense
        -- RWR failures
        'RWR_FAILURE_ANTENNA_FRONT_LEFT',--('RWR_FAILURE_ANTENNA_FRONT_LEFT')
        'RWR_FAILURE_ANTENNA_REAR_LEFT',--('RWR_FAILURE_ANTENNA_REAR_LEFT')
        'RWR_FAILURE_ANTENNA_FRONT_RIGHT',--('RWR_FAILURE_ANTENNA_FRONT_RIGHT')
        'RWR_FAILURE_ANTENNA_REAR_RIGHT',--('RWR_FAILURE_ANTENNA_REAR_RIGHT')
        'RWR_FAILURE_RECEIVER_XX1',--('RWR_FAILURE_RECEIVER_XX1')
        'RWR_FAILURE_RECEIVER_XX2',--('RWR_FAILURE_RECEIVER_XX2')
        'RWR_FAILURE_RECEIVER_XX3',--('RWR_FAILURE_RECEIVER_XX3')
        'RWR_FAILURE_DB_NOT_LOADED',--('RWR_FAILURE_DB_NOT_LOADED')
        'RWR_FAILURE_COMPUTER',--('RWR_FAILURE_COMPUTER')

        -- OESP failures
        'OESP_FAILURE_FL_DISP_L',--('OESP_FAILURE_FL_DISP_L')
        'OESP_FAILURE_FL_DISP_R',--('OESP_FAILURE_FL_DISP_R')
        'OESP_FAILURE_CH_DISP_L',--('OESP_FAILURE_CH_DISP_L')
        'OESP_FAILURE_CH_DISP_R',--('OESP_FAILURE_CH_DISP_R')
        'OESP_FAILURE_MAWS_L',--('OESP_FAILURE_MAWS_L')
        'OESP_FAILURE_MAWS_R',--('OESP_FAILURE_MAWS_R')

        ---- Weapon
        -- SMS failures
        'FAILURE_SMS_PYLON_1',--('FAILURE_SMS_PYLON_1')
        'FAILURE_SMS_PYLON_2',--('FAILURE_SMS_PYLON_2')
        'FAILURE_SMS_PYLON_3',--('FAILURE_SMS_PYLON_3')
        'FAILURE_SMS_PYLON_4',--('FAILURE_SMS_PYLON_4')
        'FAILURE_SMS_PYLON_5',--('FAILURE_SMS_PYLON_5')
        'FAILURE_SMS_PYLON_6',--('FAILURE_SMS_PYLON_6')
        'FAILURE_SMS_PYLON_7',--('FAILURE_SMS_PYLON_7')

        ---- Misc
        -- DTC failures
        'DTC_FAILURE_CARD_BROKEN',--('DTC_FAILURE_CARD_BROKEN')
        'DTC_FAILURE_DATA_CRC',--('DTC_FAILURE_DATA_CRC')
        'DTC_FAILURE_DATA_DECIPHER',--('DTC_FAILURE_DATA_DECIPHER')
        'DTC_FAILURE_READER_BROKEN',--('DTC_FAILURE_READER_BROKEN')

        -- radar
        'RDR_FAILURE_ARRAY',--('RDR_FAILURE_ARRAY')
        'RDR_FAILURE_PEDESTAL',--('RDR_FAILURE_PEDESTAL')
        'RDR_FAILURE_SERVOLOOP',--('RDR_FAILURE_SERVOLOOP')
        'RDR_FAILURE_RX_FRONT_END',--('RDR_FAILURE_RX_FRONT_END')
        'RDR_FAILURE_RECEIVER',--('RDR_FAILURE_RECEIVER')
        'RDR_FAILURE_TRANSMITTER',--('RDR_FAILURE_TRANSMITTER')
        'RDR_FAILURE_PROCESSOR',--('RDR_FAILURE_PROCESSOR')
        'RDR_FAILURE_ANTENNA_DEGRATION',--('RDR_FAILURE_ANTENNA_DEGRATION')
        'RDR_FAILURE_RX_FRONT_END_DEGRATION',--('RDR_FAILURE_RX_FRONT_END_DEGRATION')
        'RDR_FAILURE_RECEIVER_DEGRATION',--('RDR_FAILURE_RECEIVER_DEGRATION')
        'RDR_FAILURE_TRANSMITTER_DEGRATION',--('RDR_FAILURE_TRANSMITTER_DEGRATION')
        'RDR_FAILURE_PROCESSOR_DEGRATION',--('RDR_FAILURE_PROCESSOR_DEGRATION')
        'RDR_FAILURE_TRANSMITTER_OVERHEAT',--('RDR_FAILURE_TRANSMITTER_OVERHEAT')
        'RDR_FAILURE_PROCESSOR_OVERHEAT',--('RDR_FAILURE_PROCESSOR_OVERHEAT')
        'RDR_FAILURE_SERVO_OVERHEAT',--('RDR_FAILURE_SERVO_OVERHEAT')
        'RDR_FAILURE_PREESURIZATION',--('RDR_FAILURE_PREESURIZATION')
        'RDR_FAILURE_DEGRATED_PERFORMANCE',--('RDR_FAILURE_DEGRATED_PERFORMANCE')

        -- WCS
        'MWMMC_FAILURE',--('MWMMC_FAILURE')
        'MWMMC_FAILURE_CPU',--('MWMMC_FAILURE_CPU')
        'MWMMC_FAILURE_IOC',--('MWMMC_FAILURE_IOC')
        'MWMMC_FAILURE_MBI',--('MWMMC_FAILURE_MBI')
        'MWMMC_FAILURE_AVI',--('MWMMC_FAILURE_AVI')
        'MWMMC_FAILURE_DMP',--('MWMMC_FAILURE_DMP')
        'MWMMC_FAILURE_PS',--('MWMMC_FAILURE_PS')
        'MWMMC_FAILURE_1553B_EMMC',--('MWMMC_FAILURE_1553B_EMMC')
        'MWMMC_FAILURE_1553B_FCS',--('MWMMC_FAILURE_1553B_FCS')
        'MWMMC_FAILURE_1553B_IFF',--('MWMMC_FAILURE_1553B_IFF')
        'MWMMC_FAILURE_1553B_ILS',--('MWMMC_FAILURE_1553B_ILS')
        'MWMMC_FAILURE_1553B_INS',--('MWMMC_FAILURE_1553B_INS')
        'MWMMC_FAILURE_1553B_LMFCD',--('MWMMC_FAILURE_1553B_LMFCD')
        'MWMMC_FAILURE_1553B_CMFCD',--('MWMMC_FAILURE_1553B_CMFCD')
        'MWMMC_FAILURE_1553B_RMFCD',--('MWMMC_FAILURE_1553B_RMFCD')
        'MWMMC_FAILURE_1553B_RDR',--('MWMMC_FAILURE_1553B_RDR')
        'MWMMC_FAILURE_1553B_OESP',--('MWMMC_FAILURE_1553B_OESP')
        'MWMMC_FAILURE_1553B_RALT',--('MWMMC_FAILURE_1553B_RALT')
        'MWMMC_FAILURE_1553B_RWR',--('MWMMC_FAILURE_1553B_RWR')
        'MWMMC_FAILURE_1553B_SAIU',--('MWMMC_FAILURE_1553B_SAIU')
        'MWMMC_FAILURE_1553B_HUD',--('MWMMC_FAILURE_1553B_HUD')
        'MWMMC_FAILURE_1553B_SPJ',--('MWMMC_FAILURE_1553B_SPJ')
        'MWMMC_FAILURE_1553B_TACAN',--('MWMMC_FAILURE_1553B_TACAN')
        'SWMMC_FAILURE',--('SWMMC_FAILURE')
        'SWMMC_FAILURE_CPU',--('SWMMC_FAILURE_CPU')
        'SWMMC_FAILURE_IOC',--('SWMMC_FAILURE_IOC')
        'SWMMC_FAILURE_MBI',--('SWMMC_FAILURE_MBI')
        'SWMMC_FAILURE_AVI',--('SWMMC_FAILURE_AVI')
        'SWMMC_FAILURE_DMP',--('SWMMC_FAILURE_DMP')
        'SWMMC_FAILURE_PS',--('SWMMC_FAILURE_PS')
        'SWMMC_FAILURE_CTVS',--('SWMMC_FAILURE_CTVS')
        'SWMMC_FAILURE_HUD',--('SWMMC_FAILURE_HUD')
        'SWMMC_FAILURE_LMFCD',--('SWMMC_FAILURE_LMFCD')
        'SWMMC_FAILURE_CMFCD',--('SWMMC_FAILURE_CMFCD')
        'SWMMC_FAILURE_RMFCD',--('SWMMC_FAILURE_RMFCD')
        'SWMMC_AAP_NO_RS422_COMM',--('SWMMC_AAP_NO_RS422_COMM')
        'SWMMC_FAILURE_AAP',--('SWMMC_FAILURE_AAP')
        'SWMMC_DVR_NO_RS422_COMM',--('SWMMC_DVR_NO_RS422_COMM')
        'SWMMC_FAILURE_DVR',--('SWMMC_FAILURE_DVR')
        'SWMMC_CSU_NO_RS422_COMM',--('SWMMC_CSU_NO_RS422_COMM')
        'SWMMC_FAILURE_CSU',--('SWMMC_FAILURE_CSU')

        ---- EMMC MISC
        'EMMC_FAILURE_DADS',--('EMMC_FAILURE_DADS')
        'EMMC_FAILURE_LANDING_GEAR',--('EMMC_FAILURE_LANDING_GEAR')
        'EMMC_FAILURE_FUEL_LOW_LEVEL',--('EMMC_FAILURE_FUEL_LOW_LEVEL')
        'EMMC_FAILURE_FUEL_START_PUMP',--('EMMC_FAILURE_FUEL_START_PUMP')
        'EMMC_FAILURE_FUEL_LOWER_PUMP',--('EMMC_FAILURE_FUEL_LOWER_PUMP')
        'EMMC_FAILURE_FUEL_UPPER_PUMP',--('EMMC_FAILURE_FUEL_UPPER_PUMP')
        'EMMC_FAILURE_CANOPY_UNLOCK',--('EMMC_FAILURE_CANOPY_UNLOCK')
        'EMMC_FAILURE_COCKPIT_PRESSURE_LOW',--('EMMC_FAILURE_COCKPIT_PRESSURE_LOW')
        'EMMC_FAILURE_TRU',--('EMMC_FAILURE_TRU')
        'EMMC_FAILURE_LWC',--('EMMC_FAILURE_LWC')
        'EMMC_FAILURE_EMMC',--('EMMC_FAILURE_EMMC')
        'EMMC_FAILURE_PROBES_HEATING',--('EMMC_FAILURE_PROBES_HEATING')
        'EMMC_FAILURE_STATIC_INVERTER',--('EMMC_FAILURE_STATIC_INVERTER')
        'EMMC_FAILURE_ECS_OFF',--('EMMC_FAILURE_ECS_OFF')
        'EMMC_FAILURE_ELECT_EQUIP_HOT',--('EMMC_FAILURE_ELECT_EQUIP_HOT')
        'EMMC_FAILURE_SHARS',--('EMMC_FAILURE_SHARS')
        'EMMC_FAILURE_BAU',--('EMMC_FAILURE_BAU')
        'EMMC_FAILURE_DADS_RPTU',--('EMMC_FAILURE_DADS_RPTU')
        'EMMC_FAILURE_DADS_LPTU',--('EMMC_FAILURE_DADS_LPTU')
        'EMMC_FAILURE_DADS_MPTU',--('EMMC_FAILURE_DADS_MPTU')

        -- CNI
        'CNI_FAILURE_COM1',--('CNI_FAILURE_COM1')
        'CNI_FAILURE_COM1_SECOS',--('CNI_FAILURE_COM1_SECOS')
        'CNI_FAILURE_COM2',--('CNI_FAILURE_COM2')
        'CNI_FAILURE_COM2_SECOS',--('CNI_FAILURE_COM2_SECOS')
        'CNI_FAILURE_TACAN',--('CNI_FAILURE_TACAN')
        'CNI_FAILURE_ILS',--('CNI_FAILURE_ILS')
        'CNI_FAILURE_IFF_TX',--('CNI_FAILURE_IFF_TX')
        'CNI_FAILURE_IFF_RX',--('CNI_FAILURE_IFF_RX')
        'CNI_FAILURE_RALT',--('CNI_FAILURE_RALT')
        -- ZCP
        'ZCP_FAILURE_MALFUNC',--('ZCP_FAILURE_MALFUNC')
        'FCS_FAILURE_COMP_1', --('FCS_FAILURE_COMP_1')
        'FCS_FAILURE_COMP_2', --('FCS_FAILURE_COMP_2')
        'FCS_FAILURE_COMP_3', --('FCS_FAILURE_COMP_3')
        'FCS_FAILURE_COMP_4', --('FCS_FAILURE_COMP_4')
        'FCS_FAILURE_L_ELEVATOR_ELEC_A', --('FCS_FAILURE_L_ELEVATOR_ELEC_A')
        'FCS_FAILURE_L_ELEVATOR_ELEC_B', --('FCS_FAILURE_L_ELEVATOR_ELEC_B')
        'FCS_FAILURE_L_ELEVATOR_ELEC_C', --('FCS_FAILURE_L_ELEVATOR_ELEC_C')
        'FCS_FAILURE_L_ELEVATOR_ELEC_D', --('FCS_FAILURE_L_ELEVATOR_ELEC_D')
        'FCS_FAILURE_R_ELEVATOR_ELEC_A', --('FCS_FAILURE_R_ELEVATOR_ELEC_A')
        'FCS_FAILURE_R_ELEVATOR_ELEC_B', --('FCS_FAILURE_R_ELEVATOR_ELEC_B')
        'FCS_FAILURE_R_ELEVATOR_ELEC_C', --('FCS_FAILURE_R_ELEVATOR_ELEC_C')
        'FCS_FAILURE_R_ELEVATOR_ELEC_D', --('FCS_FAILURE_R_ELEVATOR_ELEC_D')
        'FCS_FAILURE_L_ELEVATOR_HYD_1', --('FCS_FAILURE_L_ELEVATOR_HYD_1')
        'FCS_FAILURE_L_ELEVATOR_HYD_2', --('FCS_FAILURE_L_ELEVATOR_HYD_2')
        'FCS_FAILURE_R_ELEVATOR_HYD_1', --('FCS_FAILURE_R_ELEVATOR_HYD_1')
        'FCS_FAILURE_R_ELEVATOR_HYD_2', --('FCS_FAILURE_R_ELEVATOR_HYD_2')
        'FCS_FAILURE_ROLL_ELEC_SERVO_1', --('FCS_FAILURE_ROLL_ELEC_SERVO_1')
        'FCS_FAILURE_ROLL_ELEC_SERVO_2', --('FCS_FAILURE_ROLL_ELEC_SERVO_2')
        'FCS_FAILURE_YAW_ELEC_SERVO_1', --('FCS_FAILURE_YAW_ELEC_SERVO_1')
        'FCS_FAILURE_YAW_ELEC_SERVO_2', --('FCS_FAILURE_YAW_ELEC_SERVO_2')
        'FCS_FAILURE_PITCH_RATE_GYRO_1', --('FCS_FAILURE_PITCH_RATE_GYRO_1')
        'FCS_FAILURE_PITCH_RATE_GYRO_2', --('FCS_FAILURE_PITCH_RATE_GYRO_2')
        'FCS_FAILURE_PITCH_RATE_GYRO_3', --('FCS_FAILURE_PITCH_RATE_GYRO_3')
        'FCS_FAILURE_PITCH_RATE_GYRO_4', --('FCS_FAILURE_PITCH_RATE_GYRO_4')
        'FCS_FAILURE_ROLL_RATE_GYRO_1', --('FCS_FAILURE_ROLL_RATE_GYRO_1')
        'FCS_FAILURE_ROLL_RATE_GYRO_2', --('FCS_FAILURE_ROLL_RATE_GYRO_2')
        'FCS_FAILURE_YAW_RATE_GYRO_1', --('FCS_FAILURE_YAW_RATE_GYRO_1')
        'FCS_FAILURE_YAW_RATE_GYRO_2', --('FCS_FAILURE_YAW_RATE_GYRO_2')
        'FCS_FAILURE_NZ_SENSOR_1', --('FCS_FAILURE_NZ_SENSOR_1')
        'FCS_FAILURE_NZ_SENSOR_2', --('FCS_FAILURE_NZ_SENSOR_2')
        'FCS_FAILURE_NZ_SENSOR_3', --('FCS_FAILURE_NZ_SENSOR_3')
        'FCS_FAILURE_NZ_SENSOR_4', --('FCS_FAILURE_NZ_SENSOR_4')
        'FCS_FAILURE_NY_SENSOR_1', --('FCS_FAILURE_NY_SENSOR_1')
        'FCS_FAILURE_NY_SENSOR_2', --('FCS_FAILURE_NY_SENSOR_2')
        'FCS_FAILURE_PITCH_LVDT_1', --('FCS_FAILURE_PITCH_LVDT_1')
        'FCS_FAILURE_PITCH_LVDT_2', --('FCS_FAILURE_PITCH_LVDT_2')
        'FCS_FAILURE_PITCH_LVDT_3', --('FCS_FAILURE_PITCH_LVDT_3')
        'FCS_FAILURE_PITCH_LVDT_4', --('FCS_FAILURE_PITCH_LVDT_4')
        'FCS_FAILURE_ROLL_LVDT_1', --('FCS_FAILURE_ROLL_LVDT_1')
        'FCS_FAILURE_ROLL_LVDT_2', --('FCS_FAILURE_ROLL_LVDT_2')
        'FCS_FAILURE_YAW_LVDT_1', --('FCS_FAILURE_YAW_LVDT_1')
        'FCS_FAILURE_YAW_LVDT_2', --('FCS_FAILURE_YAW_LVDT_2')
        'FCS_FAILURE_AOA_SENSOR_1', --('FCS_FAILURE_AOA_SENSOR_1')
        'FCS_FAILURE_AOA_SENSOR_2', --('FCS_FAILURE_AOA_SENSOR_2')
        'FCS_FAILURE_AOA_SENSOR_3', --('FCS_FAILURE_AOA_SENSOR_3')
        'FCS_FAILURE_Q_SENSOR_1', --('FCS_FAILURE_Q_SENSOR_1')
        'FCS_FAILURE_Q_SENSOR_2', --('FCS_FAILURE_Q_SENSOR_2')
        'FCS_FAILURE_Q_SENSOR_3', --('FCS_FAILURE_Q_SENSOR_3')
        'FCS_FAILURE_Q_SENSOR_4', --('FCS_FAILURE_Q_SENSOR_4')
        'FCS_FAILURE_P_SENSOR_1', --('FCS_FAILURE_P_SENSOR_1')
        'FCS_FAILURE_P_SENSOR_2', --('FCS_FAILURE_P_SENSOR_2')
        'FCS_FAILURE_P_SENSOR_3', --('FCS_FAILURE_P_SENSOR_3')
        'FCS_FAILURE_P_SENSOR_4', --('FCS_FAILURE_P_SENSOR_4')
        'FCS_FAILURE_ROLL_AUGD_1', --('FCS_FAILURE_ROLL_AUGD_1')
        'FCS_FAILURE_ROLL_AUGD_2', --('FCS_FAILURE_ROLL_AUGD_2')
        'FCS_FAILURE_YAW_AUGD_1', --('FCS_FAILURE_YAW_AUGD_1')
        'FCS_FAILURE_YAW_AUGD_2', --('FCS_FAILURE_YAW_AUGD_2')
        'FCS_FAILURE_EFCS_1', --('FCS_FAILURE_EFCS_1')
        'FCS_FAILURE_EFCS_2', --('FCS_FAILURE_EFCS_2')
        'FCS_FAILURE_WOW_1', --('FCS_FAILURE_WOW_1')
        'FCS_FAILURE_WOW_2', --('FCS_FAILURE_WOW_2')
        'FCS_FAILURE_WOW_3', --('FCS_FAILURE_WOW_3')
        'FCS_FAILURE_WOW_4', --('FCS_FAILURE_WOW_4')
        'FCS_FAILURE_LG_1', --('FCS_FAILURE_LG_1')
        'FCS_FAILURE_LG_2', --('FCS_FAILURE_LG_2')
        'FCS_FAILURE_LG_3', --('FCS_FAILURE_LG_3')
        'FCS_FAILURE_LG_4', --('FCS_FAILURE_LG_4')

        'ENGINE_FAILURE_AB_IGNITION_UNIT', --('ENGINE_FAILURE_AB_IGNITION_UNIT')
        'ENGINE_FAILURE_APD88_STARTER', --('ENGINE_FAILURE_APD88_STARTER')
        'ENGINE_FAILURE_N1_COMPRESSOR', --('ENGINE_FAILURE_N1_COMPRESSOR')
        'ENGINE_FAILURE_N2_COMPRESSOR', --('ENGINE_FAILURE_N2_COMPRESSOR')
        'ENGINE_FAILURE_N1_TURBINE', --('ENGINE_FAILURE_N1_TURBINE')
        'ENGINE_FAILURE_N2_TURBINE', --('ENGINE_FAILURE_N2_TURBINE')
        'ENGINE_FAILURE_COMBUSTOR', --('ENGINE_FAILURE_COMBUSTOR')
        'ENGINE_FAILURE_NOZZLE_CONTROLLER', --('ENGINE_FAILURE_NOZZLE_CONTROLLER')
        'ENGINE_FAILURE_DEEC', --('ENGINE_FAILURE_DEEC')
    },

	-- ["Ka-50"] =
	-- {
	-- 	'hydro_main',  --('HYDRO MAIN'), 		
	-- 	'hydro_common',  --('HYDRO COMMON'), 	
	-- 	'l_engine',  --('L-ENGINE'), 		
	-- 	'r_engine',  --('R-ENGINE'), 		
	-- 	'asc_p',  	--('ASC PITCH'), 	
	-- 	'asc_r',  	--('ASC ROLL'), 		
	-- 	'asc_y',  	--('ASC YAW'), 		
	-- 	'asc_a',  	--('ASC ALT'), 		
	-- 	'abris_software',  	--('ABRIS SOFTWARE'),	
	-- 	'abris_hardware',  	--('ABRIS HARDWARE'),	
	-- 	'laser_failure' ,  	--('LASER FAILURE'),		
	-- 	'RADAR_ALT_TOTAL_FAILURE', 	--("RALT FAILURE"), 
	-- },
	["Ka-50 III"] =
	{
		'hydro_main',  --('HYDRO MAIN'), 		
		'hydro_common',  --('HYDRO COMMON'), 	
		'l_engine',  --('L-ENGINE'), 		
		'r_engine',  --('R-ENGINE'), 		
		'asc_p',  	--('ASC PITCH'), 	
		'asc_r',  	--('ASC ROLL'), 		
		'asc_y',  	--('ASC YAW'), 		
		'asc_a',  	--('ASC ALT'), 		
		'abris_software',  	--('ABRIS SOFTWARE'),	
		'abris_hardware',  	--('ABRIS HARDWARE'),	
		'laser_failure' ,  	--('LASER FAILURE'),		
		'RADAR_ALT_TOTAL_FAILURE', 	--("RALT FAILURE"), 
		'DNS_FAILURE',  --('DNS failure'), 	
		'IMU_FAILURE',  --('INS failure'), 	
	},
	-- ["Mi-24P"] =
	-- {
	-- 	'APU_Fire',--('AI-98 Tank-3 Fire'),
	-- 	'LeftEngine_Fire',--('Left Engine Fire'),
	-- 	'RightEngine_Fire',--('Right Engine Fire'),
	-- 	'MainReducer_Fire',--('Main Reducer Fire'),
	-- },
}

DataCountry = {

	{id = 0, name = "Russia"},
	{id = 1, name = "Ukraine"},
	{id = 2, name = "USA"},
	{id = 3, name = "Turkey"},
	{id = 4, name = "UK"},
	{id = 5, name = "France"},
	{id = 6, name = "Germany"},
	{id = 7, name = "US Aggressors"},
	{id = 8, name = "Canada"},
	{id = 9, name = "Spain"},
	{id = 10, name = "The Netherlands"},
	{id = 11, name = "Belgium"},
	{id = 12, name = "Norway"},
	{id = 13, name = "Denmark"},
	{id = 14, name = ""},
	{id = 15, name = "Israel"},
	{id = 16, name = "Georgia"},
	{id = 17, name = "Insurgents"},
	{id = 18, name = "Abkhazia"},
	{id = 19, name = "South Ossetia"},
	{id = 20, name = "Italy"},

	{id = 21, name = "Italy"},
	{id = 22, name = "Switzerland"},
	{id = 23, name = "Austria"},
	{id = 24, name = "Belarus"},
	{id = 25, name = "Bulgar"},
	{id = 26, name = "Czech"},
	{id = 27, name = "China"},
	{id = 28, name = "Croatia"},
	{id = 29, name = "Egypt"},
	{id = 30, name = "Finland"},
	{id = 31, name = "Greece"},
	{id = 32, name = "Hungary"},
	{id = 33, name = "India"},
	{id = 34, name = "Iran"},
	{id = 35, name = "Iraq"},
	{id = 36, name = "Japan"},
	{id = 37, name = "Kazakhstan"},
	{id = 38, name = "North Korea"},
	{id = 39, name = "Pakistan"},
	{id = 40, name = "Poland"},

	{id = 41, name = "Romania"},
	{id = 42, name = "Saudi Arabia"},
	{id = 43, name = "Serbia"},
	{id = 44, name = "Slovakia"},
	{id = 45, name = "South Korea"},
	{id = 46, name = "Sweden"},
	{id = 47, name = "Syria"},
	{id = 48, name = "Yemen"},
	{id = 49, name = "Vietnam"},
	{id = 50, name = "Venezuela"},
	{id = 51, name = "Tunisia"},
	{id = 52, name = "Thailand"},
	{id = 53, name = "Sudan"},
	{id = 54, name = "Philippines"},
	{id = 55, name = "Morocco"},
	{id = 56, name = "Mexico"},
	{id = 57, name = "Malaysia"},
	{id = 58, name = "Libia"},
	{id = 59, name = "Jordan"},
	{id = 60, name = "Indonesia"},

	{id = 61, name = "Honduras"},
	{id = 62, name = "Ethiopia"},
	{id = 63, name = "Chile"},
	{id = 64, name = "Brazil"},
	{id = 65, name = "Bahrain"},
	{id = 66, name = "Third Reich"},
	{id = 67, name = "Yugoslavia"},
	{id = 68, name = "USSR"},
	{id = 69, name = "Italian Socialist Republic"},
	{id = 70, name = "Algeria"},
	{id = 71, name = "Kuwait"},
	{id = 72, name = "Quatar"},
	{id = 73, name = "Oman"},
	{id = 74, name = "UAE"},
	{id = 75, name = "South Afrika"},
	{id = 76, name = "Cuba"},
	{id = 77, name = "Portugal"},
	{id = 78, name = "DDR"},
	{id = 79, name = "Lebanon"},
	{id = 80, name = "Combined Joint Task Force Blue"},

	{id = 81, name = "Combined Joint Task Force Red"},
	{id = 82, name = "UN"},
	{id = 83, name = "Argentina"},
	{id = 84, name = "Cyprus"},
	{id = 85, name = "Slovenia"},
	{id = 86, name = "Bolivia"},
	{id = 87, name = "Ghana"},
	{id = 88, name = "Nigeria"},
	{id = 89, name = "Peru"},
	{id = 90, name = "Ecuador"},

}

Data_warehouses = 
{
	["allowHotStart"] = false,
	["unlimitedMunitions"] = true,
	["methanol_mixture"] = 
	{
		["InitFuel"] = 100,
	},
	["OperatingLevel_Air"] = 10,
	["diesel"] = 
	{
		["InitFuel"] = 100,
	},
	["speed"] = 16.666666,
	["dynamicSpawn"] = false,
	["unlimitedAircrafts"] = true,
	["unlimitedFuel"] = true,
	["size"] = 100,
	["suppliers"] = 
	{
	},
	["jet_fuel"] = 
	{
		["InitFuel"] = 100,
	},
	["coalition"] = "blue",
	["dynamicCargo"] = false,
	["OperatingLevel_Eqp"] = 10,
	["gasoline"] = 
	{
		["InitFuel"] = 100,
	},
	["aircrafts"] = 
	{
	},
	["weapons"] = 
	{
	},
	["OperatingLevel_Fuel"] = 10,
	["periodicity"] = 30,
}

LayerObjectsLegend =
{
	[1] = 
	{
		["visible"] = true,
		["mapY"] = -181958.57928423,
		["primitiveType"] = "Icon",
		["scale"] = 1,
		["file"] = "P91000072.png",
		["colorString"] = "0xff0000ff",
		["mapX"] = -9019.6122877207,
		["layerName"] = "Common",
		["name"] = "Icon-1",
		["angle"] = 0,
	}, -- end of [1]
	[2] = 
	{
		["visible"] = true,
		["borderThickness"] = 0,
		["fillColorString"] = "0xffffff00",
		["fontSize"] = 20,
		["mapY"] = -181910.86615853,
		["layerName"] = "Common",
		["primitiveType"] = "TextBox",
		["font"] = "DejaVuLGCSansCondensed.ttf",
		["text"] = "warehouse - ammo supply - logistic center ",
		["mapX"] = -9034.9650117481,
		["name"] = "Warehouse",
		["colorString"] = "0xff0000ff",
		["angle"] = 0,
	}, -- end of [2]
	[3] = 
	{
		["visible"] = true,
		["mapY"] = -181955.61932259,
		["primitiveType"] = "Icon",
		["scale"] = 1,
		["file"] = "P91000207.png",
		["colorString"] = "0xff0000ff",
		["mapX"] = -9075.0022588626,
		["layerName"] = "Common",
		["name"] = "Fuel-1",
		["angle"] = 0,
	}, -- end of [3]
	[4] = 
	{
		["visible"] = true,
		["borderThickness"] = 0,
		["fillColorString"] = "0xffffff00",
		["fontSize"] = 20,
		["mapY"] = -181911.73444261,
		["layerName"] = "Common",
		["primitiveType"] = "TextBox",
		["font"] = "DejaVuLGCSansCondensed.ttf",
		["text"] = "fuel supply - fuel tank",
		["mapX"] = -9094.3911030631,
		["name"] = "Fuel",
		["colorString"] = "0xff0000ff",
		["angle"] = 0,
	}, -- end of [4]
	[5] = 
	{
		["visible"] = true,
		["borderThickness"] = 0,
		["fillColorString"] = "0xffffff00",
		["fontSize"] = 20,
		["mapY"] = -181960.779274,
		["layerName"] = "Common",
		["primitiveType"] = "TextBox",
		["font"] = "DejaVuLGCSansCondensed.ttf",
		["text"] = "PP  Power Plant",
		["mapX"] = -9153.0277668211,
		["name"] = "Power Plant",
		["colorString"] = "0xff0000ff",
		["angle"] = 0,
	}, -- end of [5]
	[6] = 
	{
		["visible"] = true,
		["borderThickness"] = 0,
		["fillColorString"] = "0xffffff00",
		["fontSize"] = 20,
		["mapY"] = -181959.5869327,
		["layerName"] = "Common",
		["primitiveType"] = "TextBox",
		["font"] = "DejaVuLGCSansCondensed.ttf",
		["text"] = "PS  Power Supply",
		["mapX"] = -9209.7871639022,
		["name"] = "Power Supply",
		["colorString"] = "0xff0000ff",
		["angle"] = 0,
	}, -- end of [6]
	[7] = 
	{
		["visible"] = true,
		["borderThickness"] = 0,
		["fillColorString"] = "0xffffff00",
		["fontSize"] = 20,
		["mapY"] = -181962.08754198,
		["layerName"] = "Common",
		["primitiveType"] = "TextBox",
		["font"] = "DejaVuLGCSansCondensed.ttf",
		["text"] = "RB  Rail Bridge",
		["mapX"] = -9268.6958222602,
		["name"] = "Rail Bridge",
		["colorString"] = "0xff0000ff",
		["angle"] = 0,
	}, -- end of [7]
	[8] = 
	{
		["visible"] = true,
		["borderThickness"] = 0,
		["fillColorString"] = "0xffffff00",
		["fontSize"] = 20,
		["mapY"] = -181950.85749233,
		["layerName"] = "Common",
		["primitiveType"] = "TextBox",
		["font"] = "DejaVuLGCSansCondensed.ttf",
		["text"] = "B   Road Bridge",
		["mapX"] = -9322.3226882947,
		["name"] = "Road Bridge",
		["colorString"] = "0xff0000ff",
		["angle"] = 0,
	}, -- end of [8]
	[9] = 
	{
		["visible"] = true,
		["borderThickness"] = 0,
		["fillColorString"] = "0xffffff00",
		["fontSize"] = 20,
		["mapY"] = -181962.00448266,
		["layerName"] = "Common",
		["primitiveType"] = "TextBox",
		["font"] = "DejaVuLGCSansCondensed.ttf",
		["text"] = "CT  Control Tower",
		["mapX"] = -9378.8566491306,
		["name"] = "Control Tower",
		["colorString"] = "0xff0000ff",
		["angle"] = 0,
	}, -- end of [9]
	[10] = 
	{
		["visible"] = true,
		["borderThickness"] = 0,
		["fillColorString"] = "0xffffff00",
		["fontSize"] = 20,
		["mapY"] = -181969.9053667,
		["layerName"] = "Common",
		["primitiveType"] = "TextBox",
		["font"] = "DejaVuLGCSansCondensed.ttf",
		["text"] = "HQ  Command Center Headquater",
		["mapX"] = -9433.1113778041,
		["name"] = "Command Center",
		["colorString"] = "0xff0000ff",
		["angle"] = 0,
	}, -- end of [10]
	[11] = 
	{
		["visible"] = true,
		["borderThickness"] = 0,
		["fillColorString"] = "0xffffff00",
		["fontSize"] = 20,
		["mapY"] = -181961.10322038,
		["layerName"] = "Common",
		["primitiveType"] = "TextBox",
		["font"] = "DejaVuLGCSansCondensed.ttf",
		["text"] = "AS  Airplane Shelter",
		["mapX"] = -9480.4877912818,
		["name"] = "Airplane Shelter",
		["colorString"] = "0xff0000ff",
		["angle"] = 0,
	}, -- end of [11]
}

IsEWR = {
	["FPS-117"] = true,
	["FPS-117 Dome"] = true,
	["P-18"] = true,
	["PRV-13"] = true,
	["P-18T"] = true,
	["55G6 EWR"] = true,
	["1L13 EWR"] = true,
}




--/////////////////////////////////////////////////////////////////////
--/////////////////////////////////////////////////////////////////////


-- Détecte si une table est une liste simple (1..n)
local function isSequence(t)
    if type(t) ~= "table" then return false end
    local count = 0
    for k in pairs(t) do
        if type(k) ~= "number" or k <= 0 or k ~= math.floor(k) then
            return false
        end
        count = count + 1
    end
    for i = 1, count do
        if t[i] == nil then return false end
    end
    return true
end

-- Supprime les doublons d'une liste (par comparaison simple)
local function removeDuplicates(t)
    if not isSequence(t) then return end
    local seen = {}
    local unique = {}
    for _, v in ipairs(t) do
        if not seen[v] then
            table.insert(unique, v)
            seen[v] = true
        end
    end
    -- remplace le contenu original
    for k in pairs(t) do t[k] = nil end
    for i, v in ipairs(unique) do t[i] = v end
end

-- Fusionne récursivement src dans dest
-- opts.overwrite = true : les scalaires de src remplacent ceux de dest
local function mergeSimple(dest, src, opts)
    if type(dest) ~= "table" or type(src) ~= "table" then return end
    opts = opts or {}

    -- Si les deux tables sont des listes (ex: Tasks), on concatène puis on déduplique
    if isSequence(dest) and isSequence(src) then
        for _, v in ipairs(src) do
            table.insert(dest, deepcopyLocal(v))
        end
        removeDuplicates(dest)
        return
    end

    -- Sinon, on fusionne clé par clé
    for k, v in pairs(src) do
        local d = dest[k]
        if d == nil then
            -- Clé absente : copie directe
            if type(v) == "table" then
                dest[k] = deepcopyLocal(v)
            else
                dest[k] = v
            end
        else
            -- Clé déjà existante
            if type(d) == "table" and type(v) == "table" then
                mergeSimple(d, v, opts)
                if isSequence(d) then removeDuplicates(d) end
            else
                if opts.overwrite then
                    dest[k] = v
                end
            end
        end
    end
end

-- Data_divers contient les définitions (parent et enfant)
function InheritedFromProcessing()
	for planeType, planeData in pairs(Data_divers) do
		if planeData.inheritedFrom then
			local parent = Data_divers[planeData.inheritedFrom]
			if type(parent) == "table" then
				-- 1) on part d'une copie du parent (table propre)
				local merged = deepcopyLocal(parent)
				-- 2) on fusionne les champs de l'enfant dans la copie
				-- overwrite = true : si l'enfant définit un champ scalaire, il remplace le parent
				mergeSimple(merged, planeData, { overwrite = true })
				-- 3) on stocke le résultat dans l'enfant
				Data_divers[planeType] = merged
			end
		end
	end
end

--/////////////////////////////////////////////////////////////////////
--/////////////////////////////////////////////////////////////////////


--/////////////////////////////////////////////////////////////////////
-- extractFailuresA2 simple+
--/////////////////////////////////////////////////////////////////////

local function extractFailuresA2(aircraft)
    if type(aircraft.Failures) ~= "table" then
		-- print("extractFailuresA2: no Failures table")
        return nil
    end

    local out = {}
    local idx = 1

    for _, failure in ipairs(aircraft.Failures) do
        if type(failure) == "table" and type(failure.id) == "string" then
            out[idx] = failure.id
            idx = idx + 1
        end
    end

	-- print("extractFailuresA2: found "..(idx-1).." failures")

    if idx == 1 then
		-- print("extractFailuresA2: no failures extracted")
        return nil
    end

    return out
end


local function make_stub()
    local t = {}

    local mt = {
        __index = function(self, k)
            local v = make_stub()
            rawset(self, k, v)
            return v
        end,

        __call = function(...)
            return make_stub()
        end
    }

    return setmetatable(t, mt)
end



-- --rempli le reste des variables en allant chercher elle meme dans le bon repertoire mod
-- --si la table possede dataDiscovery = true
-- --exemple, si dans planeData, il y a moduleName = "h60_a37_dragonfly",		--self_ID 
-- -- le chemin : C:\Users\miguel\Saved Games\DCS\Mods\aircraft\h60_a37_dragonfly
-- --donc camp.path..\DCS\Mods\aircraft\h60_a37_dragonfly

local function getDcsRootFromExe()
    if not arg or type(arg[-1]) ~= "string" then
        return nil
    end

    -- normalisation séparateurs
    local exe = arg[-1]:gsub("/", "\\")

    -- retire \bin\luae.exe
    local root = exe:match("^(.*)bin\\[^\\]+%.exe$")
    return root
end

function DataCompilation_DataDiscoveryA2()

    local path_camp = os.getenv('pathSavedGames') or camp.path
  
	local path_dcs = os.getenv("pathDCS") or getDcsRootFromExe() or camp.path_dcs

    for planeType, planeData in pairs(Data_divers) do
        if AircraftInCampaign[planeType] and planeData.folderModName then

			-- if Debug.debug then print("DataDiscoveryA2 for aircraft: "..planeType) end

           local folderModName = planeData.folderModName

            if type(folderModName) == "string" then

                -- local fullPath
                local modRoot

				-- Construire le chemin CoreMods
				local fullPath = path_dcs .. "CoreMods/aircraft/" .. folderModName .. "/entry.lua"

				if planeData.add_aircraftFileName then
					fullPath = path_dcs .. "CoreMods/aircraft/" .. folderModName .. "/"..planeData.add_aircraftFileName	
				end

				-- Vérifier si le fichier existe dans le premier chemin (par exemple, CoreMods/aircraft/)
				local f0 = io.open(fullPath, "r")
				-- if Debug.debug then print("DataDiscovery_B1 test entry.lua : "..fullPath) end
				if f0 then
					modRoot  = path_dcs .. "CoreMods/aircraft/" .. folderModName
					f0:close()
				else
					-- Si non trouvé, basculer vers Mods (Saved Games)
					fullPath = path_camp .. "Mods/aircraft/" .. folderModName .. "/entry.lua"
					modRoot  = path_camp .. "Mods/aircraft/" .. folderModName
				end

                -- if Debug.debug then print("DataDiscovery_B2 entry.lua : "..fullPath) end

                local env = {}

				-- Lua standard
				env.pairs    = pairs
				env.ipairs   = ipairs
				env.next     = next
				env.tonumber = tonumber
				env.tostring = tostring
				env.type     = type
				env.unpack   = unpack
				env.select   = select

				env.math   = math
				env.string = string
				env.table  = table

				env.assert = assert
				env.error  = error
				env.pcall  = pcall
				env.print  = print

				env.Transport        = "Transport"
				env.Reconnaissance   = "Reconnaissance"
				env.Refueling 		= "Refueling"
				env.AWACS 			= "AWACS"

				env.AFAC              = "AFAC"
				env.CAP              = "CAP"
				env.CAS              = "CAS"
				env.GroundAttack     = "Ground Attack"
				env.RunwayAttack     = "Runway Attack"
				env.Intercept        = "Intercept"
				env.AntishipStrike    = "Antiship Strike"
				env.PinpointStrike	 = "Pinpoint Strike"
				env.Escort           = "Escort"
				env.FighterSweep     = "Fighter Sweep"
				env.SEAD             = "SEAD"
				env.Training         = "Training"
				-- env.Airborne         = "Airborne"
				env.Airborne         = "Transport"
				env.MODULATION_AM	= "AM"
				env.MODULATION_FM	= "FM"
				env.MODULATION_AM_AND_FM = "AM AND FM"

				-- DCS helpers connus
				env._ = function(s) return s end
				env.current_mod_path = modRoot
				env.__DCS_VERSION__  = "OFFLINE"
				env.__DEBUG__        = false

				--code original
				env.db_path = path_dcs .. "Scripts/Database"
				env.aircraft_task = function(task)
					return task
				end

				-- add_aircraft DOIT rester réel
				local collected = {}
				env.add_aircraft = function(def)
					if type(def) ~= "table" then
						-- if Debug.debug then  print("  [add_aircraft IGNORED] invalid def:", type(def)) end
						return
					end
					table.insert(collected, def)
				end

				-- dofile sandboxé
				env.dofile = function(path)
					local f = loadfile(path)
					if not f then
						-- if Debug.debug then  print("  [IGNORED dofile] "..tostring(path)) end
						return nil
					end
					setfenv(f, env)
					local ok, res = pcall(f)
					if not ok then
						-- if Debug.debug then  print("  [DOFILE ERROR] "..tostring(res)) end
						return nil
					end
					return res
				end

				-- fallback universel
				setmetatable(env, {
					__index = function(t, k)
						local v = make_stub()
						rawset(t, k, v)
						return v
					end
				})

				-- chargement entry.lua
				local chunk = loadfile(fullPath)
				if chunk then
					setfenv(chunk, env)
					local ok, err = pcall(chunk)
					if not ok then
						-- if Debug.debug then  print("  [ENTRY ERROR] "..tostring(err)) os.execute 'pause' end
						AddLog("ERROR loading entry.lua for "..tostring(planeType)..": "..tostring(err))
						-- os.execute 'pause'
					end
				else
					if Debug.debug then print("  [MISSING entry.lua] for "..tostring(planeType)) os.execute 'pause' end
					AddLog("ERROR: entry.lua not found for "..tostring(planeType).." at path: "..tostring(fullPath))
					
				end

				local function isWantedAircraft(aircraft, wanted)
					local name = aircraft.Name or aircraft.self_ID

					-- if Debug.debug then  print("  -> isWantedAircraft A2 name "..tostring(name).." wanted: "..tostring(wanted)) end

					if not name or not wanted then
						return false
					end

					return wanted == name
				end


				--  collected contient TOUS les avions du module
				for _, aircraft in ipairs(collected) do

					local dst = Data_divers[planeType]
					local wanted = dst.inheritedModFrom or planeType

					-- if Debug.debug then  print("  -> collected A planeName "..tostring(planeType).." aircraft.Name: "..tostring(aircraft.Name).." wanted: "..tostring(wanted)) end

					if wanted then
						-- FILTRE COMPATIBLE LUA 5.1
						if isWantedAircraft(aircraft, wanted) then

							if aircraft.Tasks then
								dst.Tasks = aircraft.Tasks
								-- _affiche(aircraft.Tasks, "  -> A2 Tasks found ")
								-- if Debug.debug then print("  -> A2 Tasks found ") end
								
							end

							if aircraft.HumanRadio then
								dst.HumanRadio = aircraft.HumanRadio
								-- _affiche(aircraft.HumanRadio, "  -> HumanRadio found ")
								-- if Debug.debug then print("  -> A3 HumanRadio found ") end
								
							end
							if aircraft.panelRadio then
								dst.panelRadio = aircraft.panelRadio
								-- print("  -> panelRadio found ")
								-- _affiche(aircraft.panelRadio, "  -> panelRadio found ")
								-- if Debug.debug then print("  -> A4 panelRadio found ") end
								
							end
							
							-- FAILURES
							local failures = extractFailuresA2(aircraft)
							if failures then
								Failures[planeType] = failures
								dst.Failures = failures
							end

							-- extraction plus tard
							-- print("  -> A2 aircraft captured "..planeType)
							

							-- local file_str = "dst = " .. TableSerialization(Data_divers[planeType], 0)			--make a string
							-- local file_File = io.open("Debug/Data_Divers_GetMods_"..planeType..".lua", "w") or error("Failed to open debug EWR_UtilDebug file")
							-- file_File:write(file_str)																	--save new data
							-- file_File:close()

						end
					else
						-- print("  -> collected A planeName "..tostring(planeType).." wanted: "..tostring(wanted))
						AddLog("WARNING: collected aircraft "..tostring(aircraft.Name or aircraft.self_ID).." does not match wanted "..tostring(wanted).." for planeType "..tostring(planeType))
						-- os.execute 'pause'
					end
				end

            end
        end
    end
end


--rempli la table TaskByPlane avec les Tasks qui ne sont rempli que dans Data_divers
function DataCompilation_TaskByPlane()


	-- On parcourt chaque entrée de Data_divers
	for planeName, planeData in pairs(Data_divers) do

		-- Si cette entrée contient des tâches à ajouter
		if planeData.addTasks then
			-- On clone la table principale pour pouvoir comparer sans modifier l'original
			local clonePlaneData = DeepCopy(planeData)

			-- On parcourt chaque tâche à ajouter
			for _, newTask in pairs(planeData.addTasks) do
				local found = false

				-- On cherche si cette tâche existe déjà dans la copie
				if clonePlaneData.Tasks then
					for _, existingTask in pairs(clonePlaneData.Tasks) do
						if existingTask == newTask then
							found = true
							break
						end
					end
				end
				if found then break end

				-- Si la tâche n'existe pas encore, on l'ajoute
				if not found then
					planeData.Tasks = planeData.Tasks or {}
					table.insert(planeData.Tasks, newTask)
				end
			end
		end
	end

	for planeType, planeData in pairs(Data_divers) do
		if planeData.Tasks then
			for taskN, task in pairs(planeData.Tasks) do
				-- print("DataCompilation_TaskByPlane: planeType "..planeType.." task "..tostring(task))
				if not TaskByPlane[task][planeType] then
					TaskByPlane[task][planeType] = true
				end
			end
		else
			planeData.Tasks = {}
			for task, dataTask in pairs(TaskByPlane) do
				if dataTask[planeType] then
					table.insert(planeData.Tasks, task)
				end
			end

		end
	end
end

Preset_AAA = {
    [1] = {
        -- Light / sparse (NAM) ://////////////////
        -- Density / pattern
        EMITTERS                 = 4,   -- number of parallel emitters (set to 6 to match your goal)
        CLUSTER_MIN              = 1,   -- bursts per event
        CLUSTER_MAX              = 1,
        -- Offset / aim around the aircraft
		LEAD_SECONDS             = 2, -- lead target based on velocity (0 to disable)
        -- Explosion strength
        POWER_MIN                = 4,
        POWER_MAX                = 8,
        -- Multi-target behavior
        MAX_SIMULTANEOUS_TARGETS = 4,     -- cap number of distinct aircraft we engage at once
    },
    [2] = {
        -- Light /dense
        -- Density / pattern
        EMITTERS                 = 6,   -- number of parallel emitters (set to 6 to match your goal)
        CLUSTER_MIN              = 4,   -- bursts per event
        CLUSTER_MAX              = 4,
        -- Offset / aim around the aircraft
        LEAD_SECONDS             = 3, -- lead target based on velocity (0 to disable)
        -- Explosion strength
        POWER_MIN                = 4,
        POWER_MAX                = 8,
        -- Multi-target behavior
        MAX_SIMULTANEOUS_TARGETS = 6,     -- cap number of distinct aircraft we engage at once
    },
	[3] = {
        -- Medium / sparse
        -- Density / pattern
        EMITTERS                 = 4,   -- number of parallel emitters (set to 6 to match your goal)
        CLUSTER_MIN              = 1,   -- bursts per event
        CLUSTER_MAX              = 1,
        -- Offset / aim around the aircraft
        LEAD_SECONDS             = 2, -- lead target based on velocity (0 to disable)
        -- Explosion strength
        POWER_MIN                = 6,
        POWER_MAX                = 12,
        -- Multi-target behavior
        MAX_SIMULTANEOUS_TARGETS = 4,     -- cap number of distinct aircraft we engage at once
    },
	[4] = {
        -- Medium / dense
        -- Density / pattern
        EMITTERS                 = 6,   -- number of parallel emitters (set to 6 to match your goal)
        CLUSTER_MIN              = 4,   -- bursts per event
        CLUSTER_MAX              = 4,
        -- Offset / aim around the aircraft
        LEAD_SECONDS             = 3, -- lead target based on velocity (0 to disable)
        -- Explosion strength
        POWER_MIN                = 6,
        POWER_MAX                = 12,
        -- Multi-target behavior
        MAX_SIMULTANEOUS_TARGETS = 6,     -- cap number of distinct aircraft we engage at once
    },
	[5] = {
        -- Heavy / sparse
        -- Density / pattern
        EMITTERS                 = 4,   -- number of parallel emitters (set to 6 to match your goal)
        CLUSTER_MIN              = 1,   -- bursts per event
        CLUSTER_MAX              = 1,
        -- Offset / aim around the aircraft
        LEAD_SECONDS             = 3, -- lead target based on velocity (0 to disable)
        -- Explosion strength
        POWER_MIN                = 15,
        POWER_MAX                = 25,
        -- Multi-target behavior
        MAX_SIMULTANEOUS_TARGETS = 4,     -- cap number of distinct aircraft we engage at once
    },
	[6] = {
        -- Heavy / sparse
        -- Density / pattern
        EMITTERS                 = 6,   -- number of parallel emitters (set to 6 to match your goal)
        CLUSTER_MIN              = 2,   -- bursts per event
        CLUSTER_MAX              = 2,
        -- Offset / aim around the aircraft
        LEAD_SECONDS             = 3, -- lead target based on velocity (0 to disable)
        -- Explosion strength
        POWER_MIN                = 15,
        POWER_MAX                = 25,
        -- Multi-target behavior
        MAX_SIMULTANEOUS_TARGETS = 6,     -- cap number of distinct aircraft we engage at once
    },
}

-- --En dur 
-- -- Which coalition to target:
-- local TARGET_COALITION = coalition.side.BLUE   -- coalition.side.RED
-- local EVENT_MIN_DT             = 0.5 -- seconds between events per emitter
-- local EVENT_MAX_DT             = 1.1
-- local CLUSTER_RADIUS_M         = 160 -- burst spread around event center (meters)
-- local AIM_RADIUS_M     = 450     -- how far from the aircraft the event center can be
-- local ALTITUDE_MODE    = "AGL"   -- "MSL" or "AGL"
-- local ALT_JITTER_M     = 120     -- +/- meters around target altitude
-- local ALT_MIN_MSL      = 600     -- clamp for safety (MSL meters)
-- local ALT_MAX_MSL      = 8000
-- local STICKY_TARGET_SECONDS    = 3.0   -- how long each emitter keeps its chosen aircraft before retargeting
-- local ALLOW_SAME_TARGET        = false -- if false, emitters will try to avoid sharing targets

