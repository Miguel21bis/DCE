--we place here the specific properties of flyable aircraft, such as, for example, rapid alignment.
------------------------------------------------------------------------------------------------------- 
-- last modification:  updateData_r
if not versionDCE then versionDCE = {} end
versionDCE["UTIL_AddPropAircraft.lua"] = "1.5.29"
-------------------------------------------------------------------------------------------------------
-- debug_b					(b F16 L16 & Radar Apach)(a F16 AddPropAircraft) 
-- updateData_r				(q CH-47F)(p OH58D)(o OH-6A)(n F-4E-45MC)(m LoadWater)(l Ka-50_3) (k Mirage-F1EE)(j Gazelle + UH-1)(i: Mirage-F1CE)(h: Apache)(g: M-2000C)
-- cleanCode				(en attente d utilisation)
-- adjustment_a				(a following the desynchro problem when loading missions, especially when using MP:  INSAlignmentStored = false)
-- modification M67_a		add 2.9 datalinks dataCartridge
-- modification M17_f		add AddPropAircraft Option all type 
------------------------------------------------------------------------------------------------------- 
 

Data_AddPropAircraft = {

	["A-10C_2"] = 
	{
		["SADL_TN"] = "0164",
		["VoiceCallsignLabel"] = "BR",
		["VoiceCallsignNumber"] = "53",
	},
	["A-4E-C"] = {							--A-4E-C	Mod	
		["CBU2BATPP"] = 0,
		["HideECMPanel"] = false,
        ["CMS_BURST_INTERVAL"] = 1,
        ["CMS_BURSTS"] = 1,
        ["Night_Vision"] = false,
        ["CMS_SALVO_INTERVAL"] = 1,
        ["CMS_SALVOS"] = 1,
        ["CBU2ATPP"] = 0,
        ["Auto_Catapult_Power"] = false,
	},
	["AJS-37"] = {							--AJS-37 Viggen
		["Rb04GroupTarget"] = 3,
		["WeapSafeHeight"] = 1,
		["Rb04VinkelHopp"] = 0,
		["MissionGeneratorSetting"] = 0,
	},
	["AV8BNA"] = {							--Harrier
		["ClockTime"] = 1,
		["EWDispenserBR"] = 2,
		["AAR_Zone3"] = 0,
		["AAR_Zone2"] = 0,
		["EWDispenserBL"] = 2,
		["AAR_Zone1"] = 0,
		["LaserCode100"] = 6,
		["RocketBurst"] = 1,
		["LoadWater"] = true,
		["MountNVG"] = false,
		["EWDispenserTBL"] = 2,
		["EWDispenserTFR"] = 1,
		["GBULaserCode1"] = 8,
		["LaserCode1"] = 8,
		["EWDispenserTFL"] = 1,
		["GBULaserCode10"] = 8,
		["GBULaserCode100"] = 6,
		["LaserCode10"] = 8,
		["EWDispenserTBR"] = 2,
	},
	["E-2C"] = 
	{
		["STN_L16"] = "00215",
		["VoiceCallsignLabel"] = "OD",
		["VoiceCallsignNumber"] = "61",
	},
	["KC-135"] = 
	{
		["STN_L16"] = "00233",
		["VoiceCallsignLabel"] = "TO",
		["VoiceCallsignNumber"] = "51",
	}, 

	["F-4E-45MC"] = {							--F-4E-45MC
		["TacanBand"] = 0,
		["TacanChannel"] = 0,
		["VORILSFrequencyMHZ"] = 108,
		["Quality"] = 100,
		["ChaffDoubleDispense"] = false,
		["INSAlignmentStored"] = false,
		["KY28Key"] = 1,
		["VORILSFrequencyDecimalMHZ"] = 0,
		["UseReferenceAircraft"] = false,
		["Wear"] = 0,
		["IffMode2Digit1"] = 0,
		["IffMode2Digit2"] = 0,
		["IffMode2Digit3"] = 0,
		["IffMode2Digit4"] = 0,
		["LaserCodeDigit1"] = 1,
		["LaserCodeDigit2"] = 6,
		["LaserCodeDigit3"] = 8,
		["LaserCodeDigit4"] = 8,
		["IsNvgAllowed"] = true,
	},
	["F-5E-3"] = {							--Tiger
		["LAU68ROF"] = 0,
		["ChaffSalvo"] = 0,
		["ChaffSalvoInt"] = 0,
		["LAU3ROF"] = 0,
		["ChaffBurstInt"] = 0,
		["LaserCode100"] = 6,
		["LaserCode1"] = 8,
		["FlareBurstInt"] = 0,
		["FlareBurst"] = 0,
		["LaserCode10"] = 8,
		["ChaffBurst"] = 0,
	},
	["F-14"] = {							--Tomcat A/B
		["LGB100"] = 6,
		["M61BURST"] = 0,
		["IlsChannel"] = 11,				-- preset ILS channel
		["LGB1"] = 8,
		["KY28Key"] = 1,
		["TacanBand"] = 0,
		["ALE39Loadout"] = 3,
		["UseLAU138"] = true,
		["LGB10"] = 8,
		["INSAlignmentStored"] = false,		-- fast/slow alignment, information will be adapted according to the player's choice in conf_mod (alignment_Mode)
		["TacanChannel"] = 37,				-- preset TACAN channel
		["LGB1000"] = 1,
	},
	["F-15ESE"] = {							--Strike Eagle
		["InitAirborneTime"] = 0,
		["Sta8LaserCode"] = 688,
		["Sta5LaserCode"] = 688,
		["Sta2LaserCode"] = 688,
		["needsGCAlign"] = false,
		["HumanOrchestra"] = false,
		["NetCrewControlPriority"] = 0,
		["SoloFlight"] = false,
		["InitAlertStatus"] = false,
		["RCFTLaserCode"] = 688,
		["LCFTLaserCode"] = 688,
		["MountNVG"] = false,
	},
	["F-16C_50"] = {							--Viper
		["LaserCode100"] = 6,
		["LaserCode1"] = 8,
		["HelmetMountedDevice"] = 1,
		["LaserCode10"] = 8,
		["LAU3ROF"] = 0,
	},
	["FA-18C_hornet"] = {							--Hornet
		["HelmetMountedDevice"] = 1,
		["VoiceCallsignLabel"] = "CT",
		["OuterBoard"] = 0,
		["InnerBoard"] = 0,
		["STN_L16"] = "00211",
		["VoiceCallsignNumber"] = "11",
	},


	["MB-339A"] = {
		["SoloFlight"] = false,
		["DEFA_553_Burst"] = 0.5,
		["RocketRippleTiming"] = 250,
		["PilotEquipment"] = 1,
		["EnableCutOff"] = false,
		["ARMAMENT"] = 1,
		["MountBlindHood"] = false,
		["NetCrewControlPriority"] = 1,
		["SAAB_RGS-2_Gunsight"] = true,
		["BombsRippleTiming"] = 300,
    },	
	["M-2000C"] = {							--M2000
		["ReadyALCM"] = false,  -- fast/slow alignment, information will be adapted according to the player's choice in conf_mod (alignment_Mode)
		["ForceINSRules"] = false,
		["InitHotDrift"] = 0,
		["EnableTAF"] = true,
		["DisableVTBExport"] = false,
		["LaserCode100"] = 6,
		["LaserCode1"] = 8,
		["WpBullseye"] = 0,
		["LoadNVGCase"] = false,
		["RocketBurst"] = 6,
		["LaserCode10"] = 8,
		["GunBurst"] = 1,					
	},
	["Mirage-F1CE"] = {							--MF1CE
		["RocketSalvoF1"] = 1,
        ["ChaffMultiTime"] = 1,
		["FlareMultiNumber"] = 1,
        ["ChaffMultiNumber"] = 1,
		["LaserCode1"] = 8,
		["ChaffProgramNumber"] = 1,
		["LaserCode100"] = 6,
		["FlareMultiTime"] = 1,
		["ChaffProgramTime"] = 1,
		["LaserCode10"] = 8,
        ["RocketSalvoF4"] = 1,
        ["GunBurstSettings"] = 1,
        ["RadarCoverSettings"] = 1,					
	},
	["Mirage-F1EE"] = {							--MF1EE
		["RocketSalvoF1"] = 1,
		["ChaffMultiNumber"] = 1,
		["GunBurstSettings"] = 1,
		["ChaffMultiTime"] = 1,
		["FlareMultiNumber"] = 1,
		["RadarCoverSettings"] = 1,
		["RocketSalvoF4"] = 1,
		["ChaffProgramNumber"] = 1,
		["LaserCode100"] = 6,
		["LaserCode1"] = 8,
		["ChaffProgramTime"] = 1,
		["LaserCode10"] = 8,
		["FlareMultiTime"] = 1,
		["RWR_type"] = "ALR_300",
		["INSStartMode"] = 1,  -- fast/slow alignment, information will be adapted according to the player's choice in conf_mod (alignment_Mode)
		["IFFMode4Disabled"] = 1,
		["MissSimplLock"] = 1,
	},

	["AH-64D_BLK_II"] = {							--AH-64D Apache
		["FlareProgramDelay"] = 0,
		["TN_IDM_LB"] = "1",						-- ["TN_IDM_LB"] = "3", etc...
		["FlareSalvoInterval"] = 0,
		["OverrideIFF"] = 0,
		["PltNVG"] = true,
		["CpgNVG"] = true,
		-- ["FCR_RFI_removed"] = false,
		["HumanOrchestra"] = false,
		["OwnshipCallSign"] = "G-1",				--["OwnshipCallSign"] = "G-3", etc
		["TrackAirTargets"] = true,
		["FlareBurstCount"] = 0,
		["AIDisabled"] = false,
		["FlareBurstInterval"] = 0,
		["FlareSalvoCount"] = 0,
		["NetCrewControlPriority"] = 0,				
	},
	["AH-64D_BLK_II_IA"] = {
		["CpgNVG"] = true,
		["OwnshipCallSign"] = "G-2",
		["TN_IDM_LB"] = "2",
		["PltNVG"] = true,
		["TrackAirTargets"] = true,
		["AIDisabled"] = false,
	}, -- end of ["AddPropAircraft"]

	["UH-1H"] = {
		["SoloFlight"] = false,
		["ExhaustScreen"] = true,
		["GunnersAISkill"] = 90,
		["NetCrewControlPriority"] = 0,
		["EngineResource"] = 90,					
	},
	["OH-6A"] = {
		CableCutterEnables = false,			
	},	
	["OH58D"] = 
	{
		["importDrawings"] = true,
		["MMS removal"] = false,
		["Remove doors"] = true,
		["ALQ144"] = false,
		["PDU"] = false,
		["Rifles"] = true,
		["NetCrewControlPriority"] = 0,
		["Rapid Deployment Gear"] = false,
		["tacNet"] = 1,
	}, -- end of ["AddPropAircraft"]									   
	["UH-60L"] = {
		["FuelProbeEnabled"] = false,
		["NetCrewControlPriority"] = 1,					
	},
	["CH-47Fbl1"] = {
		["NetCrewControlPriority"] = 1,					
	},
	--inherited_APA_From
	["SA342"] = {
		["SA342RemoveDoors"] = false,
		["RemoveTablet"] = false,
		["NS430allow"] = true,					
	},
	["SA342Minigun"] = {
        ["NS430allow"] = true,					
	},	


	["L-39ZA"] = {
		["DismountIFRHood"] = false,
		["SoloFlight"] = false,
		["NetCrewControlPriority"] = 1,
		["NS430allow"] = true,
    },	

	["MiG-19P"] = {							--Mig-19P
		["MissileToneVolume"] = 5,
		["ADF_Selected_Frequency"] = 1,
		["MountSIRENA"] = false,
		["ADF_NEAR_Frequency"] = 303,
		["ADF_FAR_Frequency"] = 625,
		["NAV_Initial_Hdg"] = 0,	-- fast/slow alignment, information will be adapted according to the player's choice in conf_mod (alignment_Mode)				
	},

	["Mi-24P"] = {							--Mi-24P Hind
		["LeftEngineResource"] = 90,
		["RightEngineResource"] = 90,
		["PilotNVG"] = true,
		["GunnersAISkill"] = 90,
		["OverrideIFF"] = 0,
		["R60equipment"] = true,
		["OperatorNVG"] = true,
		["SimplifiedAI"] = false,
		["ExhaustScreen"] = true,
		["TrackAirTargets"] = true,
		["NetCrewControlPriority"] = 0,
		["HideAngleBoxes"] = false,
		["NS430allow"] = true,
		["HumanOrchestra"] = false,		
	},
	["Mi-8MT"] = {							--Mi-8MT
		["LeftEngineResource"] = 90,
		["RightEngineResource"] = 90,
		["NetCrewControlPriority"] = 1,
		["ExhaustScreen"] = true,
		["CargoHalfdoor"] = true,
		["GunnersAISkill"] = 90,
		["AdditionalArmor"] = true,
		["NS430allow"] = true,					
	},
	["Ka-50_3"] = {							--Ka-50_3
		["ExhaustScreen"] = true,
		["modification"] = {"Ka-50", "Ka-50_3"},		--Ka-50_3	ou 		Ka-50		
	},	
}


AddPropAircraft_datalinks = 
{
	["Link16"] = 
	{
		["STN_L16"] = "00211",							--max 07777 digit max7 ou 77777(mef)
		["VoiceCallsignNumber"] = "11",
		["VoiceCallsignLabel"] = "CT",
	},
	["SADL"] = 											--A-10 C2
	{
		["SADL_TN"] = "0107",							--max 0777 digit max 7 ou 7777(mef)
		["VoiceCallsignNumber"] = "11",
		["VoiceCallsignLabel"] = "SD",
	},
	["IDM"] = 											-- AH-64
	{
		["TN_IDM_LB"] = "2",							--max : 39
		["OwnshipCallSign"] = "G-2",
	},

}

datalinks = 
{
	["Link16"] = 
	{
		["FA-18C_hornet"] = 
		{
			["settings"] = 
			{
				["FF1_Channel"] = 2,
				["FF2_Channel"] = 3,
				["transmitPower"] = 0,
				["AIC_Channel"] = 1,
				["VOCA_Channel"] = 4,
				["VOCB_Channel"] = 5,
			}, -- end of ["settings"]
			["network"] = 
			{
				["teamMembers"] = 
				{
					[1] = 
					{
						["missionUnitId"] = 1,
					}, -- end of [1]
					-- [2] = 
					-- {
					-- 	["missionUnitId"] = 2,
					-- }, -- end of [2]
					-- [4] = 
					-- {
					-- 	["missionUnitId"] = 4,
					-- }, -- end of [4]
					-- [3] = 
					-- {
					-- 	["missionUnitId"] = 3,
					-- }, -- end of [3]
				}, -- end of ["teamMembers"]
				["donors"] = 
				{
				}, -- end of ["donors"]
			}, -- end of ["network"]
		}, -- end of ["Link16"]

		["F-16C_50"] = 
		{
			["settings"] = 
			{
				["flightLead"] = false,
				["transmitPower"] = 3,
				["specialChannel"] = 1,
				["fighterChannel"] = 1,
				["missionChannel"] = 1,
			}, -- end of ["settings"]
			["network"] = 
			{
				["teamMembers"] = 
				{
					[1] = 
					{
						["missionUnitId"] = 1,
						["TDOA"] = true,
					}, -- end of [1]
					-- [2] = 
					-- {
					-- 	["missionUnitId"] = 2,
					-- 	["TDOA"] = true,
					-- }, -- end of [2]
					-- [4] = 
					-- {
					-- 	["missionUnitId"] = 4,
					-- 	["TDOA"] = true,
					-- }, -- end of [4]
					-- [3] = 
					-- {
					-- 	["missionUnitId"] = 3,
					-- 	["TDOA"] = true,
					-- }, -- end of [3]
				}, -- end of ["teamMembers"]
				["donors"] = 
				{
				}, -- end of ["donors"]
			}, -- end of ["network"]
		}, -- end of ["Link16"]
	},

	["SADL"] = 
	{
		["A-10C_2"] = 	{
			["settings"] = 
			{
				["flightLead"] = true,		--mettre à false pour les équipiers
				["AirKey"] = 10,
				["GatewayKey"] = 8,
			}, -- end of ["settings"]
			["network"] = 
			{
				["teamMembers"] = 
				{
					[1] = 
					{
						["missionUnitId"] = 9,
					}, -- end of [1]
					[2] = 
					{
						["missionUnitId"] = 10,
					}, -- end of [2]
					[4] = 
					{
						["missionUnitId"] = 12,
					}, -- end of [4]
					[3] = 
					{
						["missionUnitId"] = 11,
					}, -- end of [3]
				}, -- end of ["teamMembers"]
				["donors"] = 
				{
				}, -- end of ["donors"]
			}, -- end of ["network"]
		},
	},

	["IDM"] = 
	{
		["AH-64D_BLK_II"] = {
			["settings"] = 
			{
				["presets"] = 
				{
					[7] = 
					{
						["primaryFreq"] = 0,
						["NoAcknowledgmentRetries"] = 2,
						["LB_Net"] = true,
						["presetName"] = "PRESET 7",
						["callSign"] = "PRE 7",
						["autoAcknowledgment"] = true,
					}, -- end of [7]
					[1] = 
					{
						["primaryFreq"] = 1,
						["NoAcknowledgmentRetries"] = 2,
						["LB_Net"] = true,
						["presetName"] = "PRESET 1",
						["callSign"] = "PRE 1",
						["autoAcknowledgment"] = true,
					}, -- end of [1]
					[2] = 
					{
						["primaryFreq"] = 2,
						["NoAcknowledgmentRetries"] = 2,
						["LB_Net"] = true,
						["presetName"] = "PRESET 2",
						["callSign"] = "PRE 2",
						["autoAcknowledgment"] = true,
					}, -- end of [2]
					[4] = 
					{
						["primaryFreq"] = 4,
						["NoAcknowledgmentRetries"] = 2,
						["LB_Net"] = true,
						["presetName"] = "PRESET 4",
						["callSign"] = "PRE 4",
						["autoAcknowledgment"] = true,
					}, -- end of [4]
					[8] = 
					{
						["primaryFreq"] = 0,
						["NoAcknowledgmentRetries"] = 2,
						["LB_Net"] = true,
						["presetName"] = "PRESET 8",
						["callSign"] = "PRE 8",
						["autoAcknowledgment"] = true,
					}, -- end of [8]
					[9] = 
					{
						["primaryFreq"] = 0,
						["NoAcknowledgmentRetries"] = 2,
						["LB_Net"] = false,
						["presetName"] = "PRESET 9",
						["callSign"] = "PRE 9",
						["autoAcknowledgment"] = true,
					}, -- end of [9]
					[5] = 
					{
						["primaryFreq"] = 0,
						["NoAcknowledgmentRetries"] = 2,
						["LB_Net"] = true,
						["presetName"] = "PRESET 5",
						["callSign"] = "PRE 5",
						["autoAcknowledgment"] = true,
					}, -- end of [5]
					[10] = 
					{
						["primaryFreq"] = 0,
						["NoAcknowledgmentRetries"] = 2,
						["LB_Net"] = false,
						["presetName"] = "PRESET10",
						["callSign"] = "PRE10",
						["autoAcknowledgment"] = true,
					}, -- end of [10]
					[3] = 
					{
						["primaryFreq"] = 3,
						["NoAcknowledgmentRetries"] = 2,
						["LB_Net"] = true,
						["presetName"] = "PRESET 3",
						["callSign"] = "PRE 3",
						["autoAcknowledgment"] = true,
					}, -- end of [3]
					[6] = 
					{
						["primaryFreq"] = 0,
						["NoAcknowledgmentRetries"] = 2,
						["LB_Net"] = true,
						["presetName"] = "PRESET 6",
						["callSign"] = "PRE 6",
						["autoAcknowledgment"] = true,
					}, -- end of [6]
				}, -- end of ["presets"]
			}, -- end of ["settings"]
			["network"] = 
			{
				["presets"] = 
				{
					[7] = 
					{
						["members"] = 
						{
							[1] = 
							{
								["PRI_value"] = true,
								["TM_value"] = true,
								["missionUnitId"] = 13,
							}, -- end of [1]
							[2] = 
							{
								["PRI_value"] = true,
								["TM_value"] = true,
								["missionUnitId"] = 14,
							}, -- end of [2]
							[4] = 
							{
								["PRI_value"] = true,
								["TM_value"] = true,
								["missionUnitId"] = 16,
							}, -- end of [4]
							[3] = 
							{
								["PRI_value"] = true,
								["TM_value"] = true,
								["missionUnitId"] = 15,
							}, -- end of [3]
						}, -- end of ["members"]
					}, -- end of [7]
					[1] = 
					{
						["members"] = 
						{
							[1] = 
							{
								["PRI_value"] = true,
								["TM_value"] = true,
								["missionUnitId"] = 13,
							}, -- end of [1]
							[2] = 
							{
								["PRI_value"] = true,
								["TM_value"] = true,
								["missionUnitId"] = 14,
							}, -- end of [2]
							[4] = 
							{
								["PRI_value"] = true,
								["TM_value"] = true,
								["missionUnitId"] = 16,
							}, -- end of [4]
							[3] = 
							{
								["PRI_value"] = true,
								["TM_value"] = true,
								["missionUnitId"] = 15,
							}, -- end of [3]
						}, -- end of ["members"]
					}, -- end of [1]
					[2] = 
					{
						["members"] = 
						{
							[1] = 
							{
								["PRI_value"] = true,
								["TM_value"] = true,
								["missionUnitId"] = 13,
							}, -- end of [1]
							[2] = 
							{
								["PRI_value"] = true,
								["TM_value"] = true,
								["missionUnitId"] = 14,
							}, -- end of [2]
							[4] = 
							{
								["PRI_value"] = true,
								["TM_value"] = true,
								["missionUnitId"] = 16,
							}, -- end of [4]
							[3] = 
							{
								["PRI_value"] = true,
								["TM_value"] = true,
								["missionUnitId"] = 15,
							}, -- end of [3]
						}, -- end of ["members"]
					}, -- end of [2]
					[4] = 
					{
						["members"] = 
						{
							[1] = 
							{
								["PRI_value"] = true,
								["TM_value"] = true,
								["missionUnitId"] = 13,
							}, -- end of [1]
							[2] = 
							{
								["PRI_value"] = true,
								["TM_value"] = true,
								["missionUnitId"] = 14,
							}, -- end of [2]
							[4] = 
							{
								["PRI_value"] = true,
								["TM_value"] = true,
								["missionUnitId"] = 16,
							}, -- end of [4]
							[3] = 
							{
								["PRI_value"] = true,
								["TM_value"] = true,
								["missionUnitId"] = 15,
							}, -- end of [3]
						}, -- end of ["members"]
					}, -- end of [4]
					[8] = 
					{
						["members"] = 
						{
							[1] = 
							{
								["PRI_value"] = true,
								["TM_value"] = true,
								["missionUnitId"] = 13,
							}, -- end of [1]
							[2] = 
							{
								["PRI_value"] = true,
								["TM_value"] = true,
								["missionUnitId"] = 14,
							}, -- end of [2]
							[4] = 
							{
								["PRI_value"] = true,
								["TM_value"] = true,
								["missionUnitId"] = 16,
							}, -- end of [4]
							[3] = 
							{
								["PRI_value"] = true,
								["TM_value"] = true,
								["missionUnitId"] = 15,
							}, -- end of [3]
						}, -- end of ["members"]
					}, -- end of [8]
					[9] = 
					{
						["members"] = 
						{
							[1] = 
							{
								["PRI_value"] = true,
								["TM_value"] = true,
								["missionUnitId"] = 13,
							}, -- end of [1]
							[2] = 
							{
								["PRI_value"] = true,
								["TM_value"] = true,
								["missionUnitId"] = 14,
							}, -- end of [2]
							[4] = 
							{
								["PRI_value"] = true,
								["TM_value"] = true,
								["missionUnitId"] = 16,
							}, -- end of [4]
							[3] = 
							{
								["PRI_value"] = true,
								["TM_value"] = true,
								["missionUnitId"] = 15,
							}, -- end of [3]
						}, -- end of ["members"]
					}, -- end of [9]
					[5] = 
					{
						["members"] = 
						{
							[1] = 
							{
								["PRI_value"] = true,
								["TM_value"] = true,
								["missionUnitId"] = 13,
							}, -- end of [1]
							[2] = 
							{
								["PRI_value"] = true,
								["TM_value"] = true,
								["missionUnitId"] = 14,
							}, -- end of [2]
							[4] = 
							{
								["PRI_value"] = true,
								["TM_value"] = true,
								["missionUnitId"] = 16,
							}, -- end of [4]
							[3] = 
							{
								["PRI_value"] = true,
								["TM_value"] = true,
								["missionUnitId"] = 15,
							}, -- end of [3]
						}, -- end of ["members"]
					}, -- end of [5]
					[10] = 
					{
						["members"] = 
						{
							[1] = 
							{
								["PRI_value"] = true,
								["TM_value"] = true,
								["missionUnitId"] = 13,
							}, -- end of [1]
							[2] = 
							{
								["PRI_value"] = true,
								["TM_value"] = true,
								["missionUnitId"] = 14,
							}, -- end of [2]
							[4] = 
							{
								["PRI_value"] = true,
								["TM_value"] = true,
								["missionUnitId"] = 16,
							}, -- end of [4]
							[3] = 
							{
								["PRI_value"] = true,
								["TM_value"] = true,
								["missionUnitId"] = 15,
							}, -- end of [3]
						}, -- end of ["members"]
					}, -- end of [10]
					[3] = 
					{
						["members"] = 
						{
							[1] = 
							{
								["PRI_value"] = true,
								["TM_value"] = true,
								["missionUnitId"] = 13,
							}, -- end of [1]
							[2] = 
							{
								["PRI_value"] = true,
								["TM_value"] = true,
								["missionUnitId"] = 14,
							}, -- end of [2]
							[4] = 
							{
								["PRI_value"] = true,
								["TM_value"] = true,
								["missionUnitId"] = 16,
							}, -- end of [4]
							[3] = 
							{
								["PRI_value"] = true,
								["TM_value"] = true,
								["missionUnitId"] = 15,
							}, -- end of [3]
						}, -- end of ["members"]
					}, -- end of [3]
					[6] = 
					{
						["members"] = 
						{
							[1] = 
							{
								["PRI_value"] = true,
								["TM_value"] = true,
								["missionUnitId"] = 13,
							}, -- end of [1]
							[2] = 
							{
								["PRI_value"] = true,
								["TM_value"] = true,
								["missionUnitId"] = 14,
							}, -- end of [2]
							[4] = 
							{
								["PRI_value"] = true,
								["TM_value"] = true,
								["missionUnitId"] = 16,
							}, -- end of [4]
							[3] = 
							{
								["PRI_value"] = true,
								["TM_value"] = true,
								["missionUnitId"] = 15,
							}, -- end of [3]
						}, -- end of ["members"]
					}, -- end of [6]
				}, -- end of ["presets"]
			}, -- end of ["network"]
		}, -- end of ["IDM"]
	},
}

dataCartridge = 
{
	["GroupsPoints"] = 
	{
		["Initial Point"] = 
		{
		}, -- end of ["Initial Point"]
		["Sequence 2 Red"] = 
		{
		}, -- end of ["Sequence 2 Red"]
		["PB"] = 
		{
		}, -- end of ["PB"]
		["Sequence 1 Blue"] = 
		{
		}, -- end of ["Sequence 1 Blue"]
		["Start Location"] = 
		{
		}, -- end of ["Start Location"]
		["A/A Waypoint"] = 
		{
		}, -- end of ["A/A Waypoint"]
		["PP"] = 
		{
		}, -- end of ["PP"]
		["Sequence 3 Yellow"] = 
		{
		}, -- end of ["Sequence 3 Yellow"]
	}, -- end of ["GroupsPoints"]
	["Points"] = 
	{
	}, -- end of ["Points"]
}
