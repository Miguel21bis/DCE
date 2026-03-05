--Planes Loadouts database
-------------------------------------------------------------------------------------------------------
----OB----


if not versionDCE then versionDCE = {} end
versionDCE["db_loadout/db_loadouts_Mods.lua"] = "1.3.201"

-- modification M66_a		add Runway Attack
-- modification M65_a		add AirGroundAttackTask Mbot s file

-- V201 - Transport for SH-3D
-- V200 - only Mods
-- V198 - F-4E GBU - AGM - Mk20 
-- V197 - AI restricted loadouts
-- V196 - F-4E Fuel tanks 
-- V195 - A-5 Vigilante speed
-- V194 - MiG-29 for TF80s
-- V193 - MiG-29 Fulcrum loadout first version
-- V192 - Armement des MIG-21 (Ajout version 4 missiles ) - Modif de l'armement des A-4 (toujours 2 Fuel Tanks)
-- V191 KC-135 v = 185
-- V190 A-4E fuel = 2467
-- V189 - Crusader Escort
-- V188 - Mod MiG-21MF (TeTe) + PFM (Miguel Mod)
-- V187 - R-5C Vigilante
-- V185 - New B-52 loadouts
-- V184 - Cruse CAP and Mig-15 and Mig-21 sweep for NAM..
-- V183 Crusader range..
-- V182 Escort Jammer for F-105G
-- V181 - Loft Shrike for NAM - EA-6B Shrike
-- V180 - Escort jammer for F-4E
-- V 179 - vwv-o-1 and AFAC loaouts for Bronco O-1 and Skyraider for NAM

-- V178 - Tu-22M3 no escort and Minscore 0.1  for TF-80-Full
-- V177 - Mirage F-1EE big Fuel tank
-- V176 - update of speed/altitude of MirageF1/Mig21/Su17 etc... from IIW following new consumption script 
-- V175 - tu-22D War over Chad Campaign
-- V 174 - Su-17M4 (modification of certain speeds and altitudes)
-- V 173 - code_loadout =  { "All" }, correction ! thanks BAMSE
-- V 172 - Crusader - Skyraider - MiG-17F - HH-2D - SH-2F
-- V 171 - CH-47F - H-6J from JG_1 BAMSE
-- V 170 - New Shrikes for the NAM A-4E
-- V168 - WOB ajustements
-- V166 - F-4E for WOB - OH-58D
-- V165 - Fixes for Iran Irak War
-- V164 - NAM loadout (later) and No guided weapons for F-4E (bugged for IA)
-- V163 - Canadian F-5E for WOC80

--[[ Loadout Entry Example ----------------------------------------------------------------------------


depreciated variable:
capability = ...,

change of logic for these variables:
day = ...,


["MiG-21Bis"] = {														--String, aircraft type
	["Strike"] = {														--String, task
		["Custom Loadout Name"] = {										--String, custom loadout name
			support = {													--Table, list of tasks that can support this loadout (nil = is never added, true = is added when available)
				["Escort"] = true,										--Fighter escort
				["SEAD"] = true,										--SEAD	escort
				["Escort Jammer"] = true,								--Jammer escort
				["Flare Illumination"] = true,							--Target area flare illumination (mandatory support for loadout to be eligible)
				["Laser Illumination"] = true,							--Target laser illumination (mandatory support for loadout to be eligible)
			},
			attributes = {												--Array, custom loadout attributes. Only used by A-G tasks. Any target attribute must be matched in this array for the loadout to be eligible for the target.
				[1] = "Anti-tank",										--String, custom attribute to be matched for target attribute
				[2] = "Stand-off Missile",								--String, custom attribute to be matched for target attribute
			},
			code_loadout =  {"Crisis", "Cyprus"},						--String, need to build campaign db_loadout with camp_init code_loadout
			weaponType = "Bombs",										--String, type of ordinance of loadout. Only used by A-G taks. Options: "Cannon", "Rockets", "Bombs", "Guided bombs", "ASM". A-G weapon types cannot be mixed.
			expend = "All",												--String, quantity of wapons expended per attack. Only used by A-G tasks. Options: "Auto", "All", "Half", "Two".
			***day = false,***											--false, by default, all loadouts are daytime; to specify that it is only nighttime, you must also set day = false
			night = true,												--Boolean, loadout is night capable
			adverseWeather = true,										--Boolean, loadout is adverse weather capable
			range = 900000,												--Number, range radius in meters
			***depreciated variable***capability ***					--depreciated variable
			firepower = 1,												--Number, how much firepower has this loadout. The higher the better
			vCruise = 225,												--Number, cruise speed in m/s
			vAttack = 280,												--Number, attack speed in m/s
			hCruise = 6000,												--Number, cruise altitude in m
			hAttack = 100,												--Number, attack altitude in m
			standoff = 5000,											--Number, attack distance from target in m. Determines attack waypoint distance for A-G with missiles (for Bombss use nil) and engage distance for A-A tasks
			tStation = 1200,											--Number, seconds the aircraft can remain on station. Only used by CAP, AWACS and Refuelling tasks
			LDSD = true,												--Boolean, aircraft is Look-Down/Shoot-Down capable. Only used by CAP and Intercept tasks
			--- self_escort = false,										--Boolean, aircraft can defend itself against fighters. Only used by A-G tasks
			sortie_rate = 6,											--Number, average amount of sorties that aircraft flies per day
			stores = {													--Table, loadout table for DCS
				["pylons"] = 
				{
					[1] = 
					{
						["CLSID"] = "{R-60M 2L}",
					},
					[2] = 
					{
						["CLSID"] = "{R-3R}",
					},
					[3] = 
					{
						["CLSID"] = "{PTB_800_MIG21}",
					},
					[4] = 
					{
						["CLSID"] = "{R-3R}",
					},
					[5] = 
					{
						["CLSID"] = "{R-60M 2R}",
					},
					[6] = 
					{
						["CLSID"] = "{ASO-2}",
					},
				},
				["fuel"] = 2280,
				["flare"] = 32,
				["ammo_type"] = 1,
				["chaff"] = 32,
				["gun"] = 100,
			},
		},
	},
},

--Detection automatique du BON loadout
--si vous prevoyez un nom d'avion au milieu du titre, découpez le dans une table: TF-71-Tomcat-80s devient {"TF%-71", "80s" }
--si un tiret est dans le nom, mettez % devant
--insensible à la casse des lettres
--Automatic detection of the right loadout
--if you provide a plane name in the middle of the title, cut it out in a table: TF-71-Tomcat-80s becomes {"TF%-71", "80s" }
--if a dash is in the name, put % in front of it
--case sensitive
campaigns_code_loadout = { 
    ["Cyprus"] =    "Cyprus Incident",
    ["Crisis"] =    "Crisis in PG",
    ["PG"] =        "Over PG",
    ["Caucasus"] =    "Over Caucasus",         
    ["TF80sRED"] =    {"TF%-71", "Fishbed", "80s" },    --"TF-71-Fishbed-80s", 
    ["TF80s"] =        {"TF%-71", "80s" },    
    ["TF"] =        "TF%-71",
    ["IPW71"] =        "India%-Pak War%-71",             --India-Pak War-71 - MiG-19   
    ["HWITC"] =        "Hot War in the Cold",
    ["IIW"] =        "Iran%-Iraq war",                --Iran-Iraq war-Gazelle
}



]]-----------------------------------------------------------------------------------------------------

--Detection automatique du BON loadout
--si vous prevoyez un nom d'avion au milieu du titre, découpez le dans une table: TF-71-Tomcat-80s devient {"TF%-71", "80s" }
--si un tiret est dans le nom, mettez % devant
--insensible à la casse des lettres
--Automatic detection of the right loadout
--if you provide a plane name in the middle of the title, cut it out in a table: TF-71-Tomcat-80s becomes {"TF%-71", "80s" }
--if a dash is in the name, put % in front of it
--case sensitive
campaigns_code_loadout = { 
    ["Cyprus"] =	"Cyprus Incident",
    ["Crisis"] =	"Crisis in PG",
    ["PG"] =		"Over PG",
    ["Caucasus"] =	"Over Caucasus", 		
    ["TF80sRED"] =	{"TF%-71", "Fishbed", "80s" },	--"TF-71-Fishbed-80s", 
	["TF80s"] =		{"TF%-71", "80s" },	
	["TF"] =		"TF%-71",
	["TF80sI"] =		{"TF%-71", "80s","Intruder"},
    ["IPW71"] =		"India%-Pak War%-71", 			--India-Pak War-71 - MiG-19   
    ["HWITC"] =		"Hot War in the Cold",
    ["IIW"] =		"Iran%-Iraq war",				--Iran-Iraq war-Gazelle
	["Revenge"] =	"Revenge in South Atlantic",
	["WOC80"] =        "WOC%-80s",                   --War over Caucasus 80s - blue
	["WOT87"] =	"over Tchad 1987",						-- War over Tchad 1987-blue
	["WOB"] =	"over Beirut",						-- War over Beirut-blue
	["NAM"] =	"NAM",						-- NAM-blue
}


db_loadouts = {
	["A-6E"] = {
		Strike = {
			["Old TF Strike LR Mk-82HDx9, FTx2"] = {
				minscore = 0.3,
				support = {
					SEAD = true,
					Escort = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "Structure", "Bridge" },
				code_loadout =  { "All" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 1000000,
				firepower = 1,
				vCruise = 190,
				vAttack = 205.5,
				hCruise = 5315.2,
				hAttack = 400,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{5f5a94ef-a4d7-464e-8d80-b40e6cd6c264}",
						},
						[2] = {
							CLSID = "{BRU-42_3*Mk-82AIR}",
						},
						[3] = {
							CLSID = "{BRU-42_3*Mk-82AIR}",
						},
						[4] = {
							CLSID = "{BRU-42_3*Mk-82AIR}",
						},
						[5] = {
							CLSID = "{5f5a94ef-a4d7-464e-8d80-b40e6cd6c264}",
						},
					},
					fuel = 7230,
					flare = 80,
					chaff = 112,
					gun = 100,
				},
			},
			["Old TF Strike LR Mk-82x18,  FTx2"] = {
				minscore = 0.3,
				support = {
					SEAD = true,
					Escort = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "Bridge" },
				code_loadout =  { "All" },
				weaponType = "Bombs",
				expend = "All",
								range = 500000,
				firepower = 1,
				vCruise = 190,
				vAttack = 205.5,
				hCruise = 7800,
				hAttack = 5000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{1C97B4A0-AA3B-43A8-8EE7-D11071457185}",
						},
						[2] = {
							CLSID = "{5f5a94ef-a4d7-464e-8d80-b40e6cd6c264}",
						},
						[3] = {
							CLSID = "{1C97B4A0-AA3B-43A8-8EE7-D11071457185}",
						},
						[4] = {
							CLSID = "{5f5a94ef-a4d7-464e-8d80-b40e6cd6c264}",
						},
						[5] = {
							CLSID = "{1C97B4A0-AA3B-43A8-8EE7-D11071457185}",
						},
					},
					fuel = 7230,
					flare = 80,
					chaff = 112,
					gun = 100,
				},
			},
			["Old TF Strike SR Mk-84x4,  FT"] = {
				minscore = 0.3,
				support = {
					SEAD = true,
					Escort = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "Structure", "Bridge" },
				code_loadout =  { "All" },
				weaponType = "Bombs",
				expend = "All",
								range = 450000,
				firepower = 1,
				vCruise = 190,
				vAttack = 205.5,
				hCruise = 7800,
				hAttack = 6000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
						},
						[2] = {
							CLSID = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
						},
						[3] = {
							CLSID = "{5f5a94ef-a4d7-464e-8d80-b40e6cd6c264}",
						},
						[4] = {
							CLSID = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
						},
						[5] = {
							CLSID = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
						},
					},
					fuel = 7230,
					flare = 80,
					chaff = 112,
					gun = 100,
				},
			},
			["Old TF Strike SR Mk-82HDx12,  FT"] = {
				minscore = 0.3,
				support = {
					SEAD = true,
					Escort = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "Structure", "Bridge" },
				code_loadout =  { "All" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 450000,
				firepower = 1,
				vCruise = 190,
				vAttack = 205.5,
				hCruise = 5315.2,
				hAttack = 400,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{BRU-42_3*Mk-82AIR}",
						},
						[2] = {
							CLSID = "{BRU-42_3*Mk-82AIR}",
						},
						[3] = {
							CLSID = "{5f5a94ef-a4d7-464e-8d80-b40e6cd6c264}",
						},
						[4] = {
							CLSID = "{BRU-42_3*Mk-82AIR}",
						},
						[5] = {
							CLSID = "{BRU-42_3*Mk-82AIR}",
						},
					},
					fuel = 7230,
					flare = 80,
					chaff = 112,
					gun = 100,
				},
			},
			["Strike Mk-84x3,FTx2"] = {
				minscore = 0.3,
				support = {
					SEAD = true,
					Escort = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "Structure", "Bridge" },
				code_loadout =  { "All" },
				weaponType = "Bombs",
				expend = "All",
								range = 1000000,
				firepower = 1,
				vCruise = 190,
				vAttack = 205.5,
				hCruise = 7800,
				hAttack = 6000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{5f5a94ef-a4d7-464e-8d80-b40e6cd6c264}",
						},
						[2] = {
							CLSID = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
						},
						[3] = {
							CLSID = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
						},
						[4] = {
							CLSID = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
						},
						[5] = {
							CLSID = "{5f5a94ef-a4d7-464e-8d80-b40e6cd6c264}",
						},
					},
					fuel = 7230,
					flare = 80,
					chaff = 112,
					gun = 100,
				},
			},
		},
	},
	["vwv_o-1"] = {
		AFAC = {
			["AFAC NAM - Day Smoke Rockets"] = {
				minscore = 0.3,
				support = {
					SEAD = false,
					Escort = false,
					["Escort Jammer"] = false,
				},
				country = {
					[1] = "USA",
				},
				attributes =  { "" },
				code_loadout =  { "NAM" },
				weaponType = "Rockets",
				expend = "Auto",
								night = false,
				adverseWeather = true,
				range = 400000,
				firepower = 1,
				vCruise = 80,
				vAttack = 80,
				hCruise = 3315.2,
				hAttack = 200,
				sortie_rate = 6,
				tStation = 18000,
				stores = {
					pylons = {
						[1] = {
							["CLSID"] = "{LAU68_FFAR_WP156}",
							["num"] = 2,
						},
						[2] = {
							["CLSID"] = "{LAU68_FFAR_WP156}",
							["num"] = 3,
						},
					},
					fuel = 160,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
			["AFAC NAM - Night  Flares"] = {
				minscore = 0.3,
				support = {
					SEAD = false,
					Escort = false,
					["Escort Jammer"] = false,
				},
				country = {
					[1] = "USA",
				},
				attributes =  { "" },
				code_loadout =  { "NAM" },
				weaponType = "Rockets",
				expend = "Auto",
				day = false,
				night = true,
				adverseWeather = false,
				range = 400000,
				firepower = 1,
				vCruise = 80,
				vAttack = 80,
				hCruise = 3315.2,
				hAttack = 200,
				sortie_rate = 6,
				tStation = 18000,
				stores = {
					pylons = {
						[1] = {
							["CLSID"] = "{CAE48299-A294-4bad-8EE6-89EFC5DCDF00}",
							["num"] = 3,
						},
						[2] = {
							["CLSID"] = "{CAE48299-A294-4bad-8EE6-89EFC5DCDF00}",
							["num"] = 2,
						},
					},
					fuel = 160,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
	},	
	["Bronco-OV-10A"] = {
		AFAC = {
			["AFAC NAM Smoke rockets - FT"] = {
				-- minscore = 0.3,
				support = {
					SEAD = false,
					Escort = false,
					["Escort Jammer"] = false,
				},
				country = {
					[1] = "USA",
				},
				attributes =  { "" },
				code_loadout =  { "NAM" },
				weaponType = "Rockets",
				expend = "Auto",
								night = false,
				adverseWeather = true,
				range = 400000,
				firepower = 1,
				vCruise = 154.16666666667,
				vAttack = 154.16666666667,
				hCruise = 3315.2,
				hAttack = 200,
				sortie_rate = 6,
				tStation = 18000,
				stores = {
					pylons = {
						[1] = {
							["CLSID"] = "LAU3_WP156",
							["num"] = 6,
						},
						[2] = {
							["CLSID"] = "{150gal}",
							["num"] = 4,
						},
						[3] = {
							["CLSID"] = "LAU3_WP156",
							["num"] = 2,
						},
					},
					fuel = 940,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},	
		Strike = {
			["NAM - AG - Mk-82HDx4"] = {
				minscore = 0.3,
				support = {
					SEAD = true,
					Escort = false,
					["Escort Jammer"] = false,
				},
				country = {
					[1] = "USA",
				},
				attributes =  { "" },
				code_loadout =  { "NAM" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 100000,
				firepower = 1,
				vCruise = 154.16666666667,
				vAttack = 154.16666666667,
				hCruise = 3315.2,
				hAttack = 200,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							["CLSID"] = "{Mk82SNAKEYE}",
							["num"] = 6,
							["settings"] = {
								["NFP_VIS_DrawArgNo_57"] = 0,
								["NFP_fuze_type_nose"] = "M904E4",
								["NFP_fuze_type_tail"] = "M905",
								["arm_delay_ctrl_M904E4"] = 2,
								["arm_delay_ctrl_M905"] = 4,
								["function_delay_ctrl_M904E4"] = 0,
								["function_delay_ctrl_M905"] = 0,
							},
						},
						[2] = {
							["CLSID"] = "{Mk82SNAKEYE}",
							["num"] = 2,
							["settings"] = {
								["NFP_VIS_DrawArgNo_57"] = 0,
								["NFP_fuze_type_nose"] = "M904E4",
								["NFP_fuze_type_tail"] = "M905",
								["arm_delay_ctrl_M904E4"] = 2,
								["arm_delay_ctrl_M905"] = 4,
								["function_delay_ctrl_M904E4"] = 0,
								["function_delay_ctrl_M905"] = 0,
							},
						},
						[3] = {
							["CLSID"] = "{150gal}",
							["num"] = 4,
						},
						[4] = {
							["CLSID"] = "{Mk82SNAKEYE}",
							["num"] = 5,
							["settings"] = {
								["NFP_VIS_DrawArgNo_57"] = 0,
								["NFP_fuze_type_nose"] = "M904E4",
								["NFP_fuze_type_tail"] = "M905",
								["arm_delay_ctrl_M904E4"] = 2,
								["arm_delay_ctrl_M905"] = 4,
								["function_delay_ctrl_M904E4"] = 0,
								["function_delay_ctrl_M905"] = 0,
							},
						},
						[5] = {
							["CLSID"] = "{Mk82SNAKEYE}",
							["num"] = 3,
							["settings"] = {
								["NFP_VIS_DrawArgNo_57"] = 0,
								["NFP_fuze_type_nose"] = "M904E4",
								["NFP_fuze_type_tail"] = "M905",
								["arm_delay_ctrl_M904E4"] = 2,
								["arm_delay_ctrl_M905"] = 4,
								["function_delay_ctrl_M904E4"] = 0,
								["function_delay_ctrl_M905"] = 0,
							},
						},
					},
					fuel = 940,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},			
			["NAM - AG - RKTx4 White Phos"] = {
				minscore = 0.3,
				support = {
					SEAD = true,
					Escort = false,
					["Escort Jammer"] = false,
				},
				country = {
					[1] = "USA",
				},
				attributes =  { "" },
				code_loadout =  { "NAM" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 100000,
				firepower = 1,
				vCruise = 154.16666666667,
				vAttack = 154.16666666667,
				hCruise = 3315.2,
				hAttack = 200,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							["CLSID"] = "LAU3_WP156",
							["num"] = 6,
						},
						[2] = {
							["CLSID"] = "LAU3_WP156",
							["num"] = 2,
						},
						[3] = {
							["CLSID"] = "{150gal}",
							["num"] = 4,
						},
						[4] = {
							["CLSID"] = "LAU3_WP156",
							["num"] = 5,
						},
						[5] = {
							["CLSID"] = "LAU3_WP156",
							["num"] = 3,
						},
					},
					fuel = 940,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
	},
	["vwv_a1_skyraider"] = {
		AFAC = {
			["AFAC NAM- Flares - Smoke rockets - FT*3"] = {
				minscore = 0.3,
				support = {
					SEAD = false,
					Escort = false,
					["Escort Jammer"] = false,
				},
				country = {
					[1] = "USA",
				},
				attributes =  { "" },
				code_loadout =  { "NAM" },
				weaponType = "Rockets",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 400000,
				firepower = 1,
				vCruise = 154.16666666667,
				vAttack = 154.16666666667,
				hCruise = 3315.2,
				hAttack = 200,
				sortie_rate = 6,
				tStation = 18000,
				stores = {
					pylons = {
						[1] = {
							["CLSID"] = "{CAE48299-A294-4bad-8EE6-89EFC5DCDF00}",
							["num"] = 15,
						},
						[2] = {
							["CLSID"] = "{CAE48299-A294-4bad-8EE6-89EFC5DCDF00}",
							["num"] = 1,
						},
						[3] = {
							["CLSID"] = "{3DFB7321-AB0E-11d7-9897-000476191836}",
							["num"] = 14,
						},
						[4] = {
							["CLSID"] = "{3DFB7321-AB0E-11d7-9897-000476191836}",
							["num"] = 2,
						},
						[5] = {
							["CLSID"] = "{AV8BNA_AERO1D}",
							["num"] = 9,
						},
						[6] = {
							["CLSID"] = "{AV8BNA_AERO1D}",
							["num"] = 7,
						},
						[7] = {
							["CLSID"] = "{AV8BNA_AERO1D}",
							["num"] = 8,
						},
						[8] = {
							["CLSID"] = "{CAE48299-A294-4bad-8EE6-89EFC5DCDF00}",
							["num"] = 13,
						},
						[9] = {
							["CLSID"] = "{CAE48299-A294-4bad-8EE6-89EFC5DCDF00}",
							["num"] = 3,
						},
						[10] = {
							["CLSID"] = "{3DFB7321-AB0E-11d7-9897-000476191836}",
							["num"] = 12,
						},
						[11] = {
							["CLSID"] = "{3DFB7321-AB0E-11d7-9897-000476191836}",
							["num"] = 4,
						},
					},
					fuel = 1036,
					flare = 240,
					chaff = 240,
					gun = 100,
				},
			},
		},	
		Strike = {
			["NAM-AG-Bombs 500lbs*8 - Rkt*14 - FT*3"] = {
				minscore = 0.3,
				support = {
					SEAD = false,
					Escort = false,
					["Escort Jammer"] = false,
				},
				country = {
					[1] = "USA",
				},
				attributes =  { "" },
				code_loadout =  { "NAM" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 154.16666666667,
				vAttack = 154.16666666667,
				hCruise = 3315.2,
				hAttack = 200,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							["CLSID"] = "{AN-M64}",
							["num"] = 15,
							["settings"] = {
								["NFP_PRESID"] = "WWII_B_A_GPMedium",
								["NFP_PRESVER"] = 1,
								["NFP_fuze_type_nose"] = 1,
								["NFP_fuze_type_tail"] = 1,
								["function_delay_ctrl_ANM101A2"] = 0,
								["function_delay_ctrl_ANM103A1"] = 0,
								["vane_rev_threshold_ctrl_ANM101A2"] = 160,
								["vane_rev_threshold_ctrl_FD_0_ANM103A1"] = 300,
							},
						},
						[2] = {
							["CLSID"] = "{AN-M64}",
							["num"] = 1,
							["settings"] = {
								["NFP_PRESID"] = "WWII_B_A_GPMedium",
								["NFP_PRESVER"] = 1,
								["NFP_fuze_type_nose"] = 1,
								["NFP_fuze_type_tail"] = 1,
								["function_delay_ctrl_ANM101A2"] = 0,
								["function_delay_ctrl_ANM103A1"] = 0,
								["vane_rev_threshold_ctrl_ANM101A2"] = 160,
								["vane_rev_threshold_ctrl_FD_0_ANM103A1"] = 300,
							},
						},
						[3] = {
							["CLSID"] = "{AN-M64}",
							["num"] = 14,
							["settings"] = {
								["NFP_PRESID"] = "WWII_B_A_GPMedium",
								["NFP_PRESVER"] = 1,
								["NFP_fuze_type_nose"] = 1,
								["NFP_fuze_type_tail"] = 1,
								["function_delay_ctrl_ANM101A2"] = 0,
								["function_delay_ctrl_ANM103A1"] = 0,
								["vane_rev_threshold_ctrl_ANM101A2"] = 160,
								["vane_rev_threshold_ctrl_FD_0_ANM103A1"] = 300,
							},
						},
						[4] = {
							["CLSID"] = "{AN-M64}",
							["num"] = 2,
							["settings"] = {
								["NFP_PRESID"] = "WWII_B_A_GPMedium",
								["NFP_PRESVER"] = 1,
								["NFP_fuze_type_nose"] = 1,
								["NFP_fuze_type_tail"] = 1,
								["function_delay_ctrl_ANM101A2"] = 0,
								["function_delay_ctrl_ANM103A1"] = 0,
								["vane_rev_threshold_ctrl_ANM101A2"] = 160,
								["vane_rev_threshold_ctrl_FD_0_ANM103A1"] = 300,
							},
						},
						[5] = {
							["CLSID"] = "{AN-M64}",
							["num"] = 13,
							["settings"] = {
								["NFP_PRESID"] = "WWII_B_A_GPMedium",
								["NFP_PRESVER"] = 1,
								["NFP_fuze_type_nose"] = 1,
								["NFP_fuze_type_tail"] = 1,
								["function_delay_ctrl_ANM101A2"] = 0,
								["function_delay_ctrl_ANM103A1"] = 0,
								["vane_rev_threshold_ctrl_ANM101A2"] = 160,
								["vane_rev_threshold_ctrl_FD_0_ANM103A1"] = 300,
							},
						},
						[6] = {
							["CLSID"] = "{AN-M64}",
							["num"] = 3,
							["settings"] = {
								["NFP_PRESID"] = "WWII_B_A_GPMedium",
								["NFP_PRESVER"] = 1,
								["NFP_fuze_type_nose"] = 1,
								["NFP_fuze_type_tail"] = 1,
								["function_delay_ctrl_ANM101A2"] = 0,
								["function_delay_ctrl_ANM103A1"] = 0,
								["vane_rev_threshold_ctrl_ANM101A2"] = 160,
								["vane_rev_threshold_ctrl_FD_0_ANM103A1"] = 300,
							},
						},
						[7] = {
							["CLSID"] = "{AN-M64}",
							["num"] = 12,
							["settings"] = {
								["NFP_PRESID"] = "WWII_B_A_GPMedium",
								["NFP_PRESVER"] = 1,
								["NFP_fuze_type_nose"] = 1,
								["NFP_fuze_type_tail"] = 1,
								["function_delay_ctrl_ANM101A2"] = 0,
								["function_delay_ctrl_ANM103A1"] = 0,
								["vane_rev_threshold_ctrl_ANM101A2"] = 160,
								["vane_rev_threshold_ctrl_FD_0_ANM103A1"] = 300,
							},
						},
						[8] = {
							["CLSID"] = "{AN-M64}",
							["num"] = 4,
							["settings"] = {
								["NFP_PRESID"] = "WWII_B_A_GPMedium",
								["NFP_PRESVER"] = 1,
								["NFP_fuze_type_nose"] = 1,
								["NFP_fuze_type_tail"] = 1,
								["function_delay_ctrl_ANM101A2"] = 0,
								["function_delay_ctrl_ANM103A1"] = 0,
								["vane_rev_threshold_ctrl_ANM101A2"] = 160,
								["vane_rev_threshold_ctrl_FD_0_ANM103A1"] = 300,
							},
						},
						[9] = {
							["CLSID"] = "{CAE48299-A294-4bad-8EE6-89EFC5DCDF00}",
							["num"] = 11,
						},
						[10] = {
							["CLSID"] = "{CAE48299-A294-4bad-8EE6-89EFC5DCDF00}",
							["num"] = 5,
						},
						[11] = {
							["CLSID"] = "{A021F29D-18AB-4d3e-985C-FC9C60E35E9E}",
							["num"] = 10,
						},
						[12] = {
							["CLSID"] = "{A021F29D-18AB-4d3e-985C-FC9C60E35E9E}",
							["num"] = 6,
						},
						[13] = {
							["CLSID"] = "{AV8BNA_AERO1D}",
							["num"] = 9,
						},
						[14] = {
							["CLSID"] = "{AV8BNA_AERO1D}",
							["num"] = 7,
						},
						[15] = {
							["CLSID"] = "{AV8BNA_AERO1D}",
							["num"] = 8,
						},
					},
					fuel = 1036,
					flare = 240,
					chaff = 240,
					gun = 100,
				},
			},			
			["NAM-AG-Rkt*70 - FT*3"] = {
				minscore = 0.3,
				support = {
					SEAD = true,
					Escort = false,
					["Escort Jammer"] = false,
				},
				country = {
					[1] = "USA",
				},
				attributes =  { "" },
				code_loadout =  { "NAM" },
				weaponType = "rockets",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 450000,
				firepower = 1,
				vCruise = 154.16666666667,
				vAttack = 154.16666666667,
				hCruise = 3315.2,
				hAttack = 200,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							["CLSID"] = "{A021F29D-18AB-4d3e-985C-FC9C60E35E9E}",
							["num"] = 15,
						},
						[2] = {
							["CLSID"] = "{A021F29D-18AB-4d3e-985C-FC9C60E35E9E}",
							["num"] = 1,
						},
						[3] = {
							["CLSID"] = "{A021F29D-18AB-4d3e-985C-FC9C60E35E9E}",
							["num"] = 14,
						},
						[4] = {
							["CLSID"] = "{A021F29D-18AB-4d3e-985C-FC9C60E35E9E}",
							["num"] = 2,
						},
						[5] = {
							["CLSID"] = "{A021F29D-18AB-4d3e-985C-FC9C60E35E9E}",
							["num"] = 13,
						},
						[6] = {
							["CLSID"] = "{A021F29D-18AB-4d3e-985C-FC9C60E35E9E}",
							["num"] = 3,
						},
						[7] = {
							["CLSID"] = "{A021F29D-18AB-4d3e-985C-FC9C60E35E9E}",
							["num"] = 12,
						},
						[8] = {
							["CLSID"] = "{A021F29D-18AB-4d3e-985C-FC9C60E35E9E}",
							["num"] = 4,
						},
						[9] = {
							["CLSID"] = "{CAE48299-A294-4bad-8EE6-89EFC5DCDF00}",
							["num"] = 11,
						},
						[10] = {
							["CLSID"] = "{CAE48299-A294-4bad-8EE6-89EFC5DCDF00}",
							["num"] = 5,
						},
						[11] = {
							["CLSID"] = "{A021F29D-18AB-4d3e-985C-FC9C60E35E9E}",
							["num"] = 10,
						},
						[12] = {
							["CLSID"] = "{A021F29D-18AB-4d3e-985C-FC9C60E35E9E}",
							["num"] = 6,
						},
						[13] = {
							["CLSID"] = "{AV8BNA_AERO1D}",
							["num"] = 9,
						},
						[14] = {
							["CLSID"] = "{AV8BNA_AERO1D}",
							["num"] = 7,
						},
						[15] = {
							["CLSID"] = "{AV8BNA_AERO1D}",
							["num"] = 8,
						},
					},
					fuel = 1036,
					flare = 240,
					chaff = 240,
					gun = 100,
				},
			},
		},
	},
	["VSN_F100"] = {
		SEAD = {
			["NAM - SEAD - FTx2 - AGM-45x2"] = {
				attributes =  { },
				country = {
					[1] = "USA",
				},
				code_loadout =  { "NAM" },
				attackType = "Dive",
								night = false,
				adverseWeather = false,
				range = 600000,
				firepower = 0.5,
				vCruise = 200,
				sortie_rate = 12,
				stores = {
					pylons = {
						[1] = {
					["CLSID"] = "{AGM_45A}",
					["num"] = 9,
					["settings"] = {
						["EAS_bypass_ctrl"] = 1,
						["NFP_PRESID"] = "AGM_45",
						["NFP_PRESVER"] = 1,
						["NFP_rfgu_type"] = 5,
						["rf_lower_limit_ctrl_Mk25"] = 4000000000,
						["rf_upper_limit_ctrl_Mk25"] = 6000000000,
						["smoke_marker"] = 0,
					},
				},
				[2] = {
					["CLSID"] = "{AGM_45A}",
					["num"] = 3,
					["settings"] = {
						["EAS_bypass_ctrl"] = 1,
						["NFP_PRESID"] = "AGM_45",
						["NFP_PRESVER"] = 1,
						["NFP_rfgu_type"] = 5,
						["rf_lower_limit_ctrl_Mk25"] = 4000000000,
						["rf_upper_limit_ctrl_Mk25"] = 6000000000,
						["smoke_marker"] = 0,
					},
				},
				[3] = {
					["CLSID"] = "{VSN_F1001000_ptb}",
					["num"] = 8,
				},
				[4] = {
					["CLSID"] = "{VSN_F1001000_ptb}",
					["num"] = 4,
				},
				[5] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 7,
				},
				[6] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 5,
				},
					},
					fuel = 3397,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
		},
		Strike = {
			["NAM - AG - FTx2 - LAU-3x4"] = {
				minscore = 0.3,
				support = {
					SEAD = true,
					Escort = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				country = {
					[1] = "USA",
				},
				code_loadout =  { "NAM" },
				weaponType = "rockets",
				expend = "All",
								night = false,
				adverseWeather = false,
				range = 600000,
				firepower = 0.5,
				vCruise = 200,
				vAttack = 350,
				hCruise = 4500,
				hAttack = 4500,
				LDSD = true,
				sortie_rate = 8,
				stores = {
					pylons = {
						[1] = {
					["CLSID"] = "{LAU3_FFAR_MK1HE}",
					["num"] = 9,
				},
				[2] = {
					["CLSID"] = "{LAU3_FFAR_MK1HE}",
					["num"] = 3,
				},
				[3] = {
					["CLSID"] = "{LAU3_FFAR_MK1HE}",
					["num"] = 7,
				},
				[4] = {
					["CLSID"] = "{LAU3_FFAR_MK1HE}",
					["num"] = 5,
				},
				[5] = {
					["CLSID"] = "{VSN_F1001000_ptb}",
					["num"] = 8,
				},
				[6] = {
					["CLSID"] = "{VSN_F1001000_ptb}",
					["num"] = 4,
				},
					},
					fuel = 3397,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
			["NAM - AG - FTx2 - Mk-84LDx2"] = {
				minscore = 0.3,
				support = {
					SEAD = true,
					Escort = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "Bridges", "Structure" },
				country = {
					[1] = "USA",
				},
				code_loadout =  { "NAM" },
				weaponType = "Bombs",
				expend = "All",
								night = false,
				adverseWeather = false,
				range = 1600000,
				firepower = 0.5,
				vCruise = 200,
				vAttack = 350,
				hCruise = 4500,
				hAttack = 4500,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
					["CLSID"] = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
					["num"] = 7,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_M904E4"] = 4,
						["00_prfx_function_delay_ctrl_M904E4"] = 0,
						["01_prfx_arm_delay_ctrl_M905"] = 4,
						["01_prfx_function_delay_ctrl_M905"] = 0,
						["NFP_PRESID"] = "MDRN_B_A_GPLD",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
					},
				},
				[2] = {
					["CLSID"] = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
					["num"] = 5,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_M904E4"] = 4,
						["00_prfx_function_delay_ctrl_M904E4"] = 0,
						["01_prfx_arm_delay_ctrl_M905"] = 4,
						["01_prfx_function_delay_ctrl_M905"] = 0,
						["NFP_PRESID"] = "MDRN_B_A_GPLD",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
					},
				},
				[3] = {
					["CLSID"] = "{VSN_F1001000_ptb}",
					["num"] = 8,
				},
				[4] = {
					["CLSID"] = "{VSN_F1001000_ptb}",
					["num"] = 4,
				},
				[5] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 9,
				},
				[6] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 3,
				},
					},
					fuel = 3397,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
			["NAM - AG - FTx2 - Mk-82LDx4"] = {
				minscore = 0.3,
				support = {
					SEAD = true,
					Escort = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				country = {
					[1] = "USA",
				},
				code_loadout =  { "NAM" },
				weaponType = "Bombs",
				expend = "All",
								night = false,
				adverseWeather = false,
				range = 1600000,
				firepower = 0.5,
				vCruise = 200,
				vAttack = 350,
				hCruise = 4500,
				hAttack = 4500,
				sortie_rate = 6,
				stores = {
					pylons = {
					[1] = {
					["CLSID"] = "{D5D51E24-348C-4702-96AF-97A714E72697}",
					["num"] = 7,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_M904E4"] = 4,
						["00_prfx_function_delay_ctrl_M904E4"] = 0,
						["01_prfx_arm_delay_ctrl_M905"] = 4,
						["01_prfx_function_delay_ctrl_M905"] = 0,
						["NFP_PRESID"] = "MDRN_B_A_GPLD",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
					},
				},
				[2] = {
					["CLSID"] = "{D5D51E24-348C-4702-96AF-97A714E72697}",
					["num"] = 5,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_M904E4"] = 4,
						["00_prfx_function_delay_ctrl_M904E4"] = 0,
						["01_prfx_arm_delay_ctrl_M905"] = 4,
						["01_prfx_function_delay_ctrl_M905"] = 0,
						["NFP_PRESID"] = "MDRN_B_A_GPLD",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
					},
				},
				[3] = {
					["CLSID"] = "{VSN_F1001000_ptb}",
					["num"] = 8,
				},
				[4] = {
					["CLSID"] = "{VSN_F1001000_ptb}",
					["num"] = 4,
				},
				[5] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 9,
				},
				[6] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 3,
				},
					},
					fuel = 3397,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
		},
	},
	["VSN_F105D"] = {
		Strike = {
			["NAM - AG - FT - Mk-82LDx12"] = {
				minscore = 0.3,
				support = {
					SEAD = true,
					Escort = true,
					["Escort Jammer"] = true,
				},
				country = {
					[1] = "USA",
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "Structure", "Bridge" },
				code_loadout =  { "NAM" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = false,
				range = 1000000,
				firepower = 1,
				vCruise = 190,
				vAttack = 205.5,
				hCruise = 5315.2,
				hAttack = 400,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							["CLSID"] = "{VSN_F105_MK82_6}",
							["num"] = 7,
						},
						[2] = {
							["CLSID"] = "{VSN_F105_MK82_6}",
							["num"] = 5,
						},
						[3] = {
							["CLSID"] = "{VSN_F105G_Center_PTB}",
							["num"] = 6,
						},
						[4] = {
							["CLSID"] = "<CLEAN>",
							["num"] = 8,
						},
						[5] = {
							["CLSID"] = "<CLEAN>",
							["num"] = 4,
						},
					},
					fuel = 4986,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
			["NAM - AG - FT - Mk-83LDx8"] = {
				minscore = 0.3,
				support = {
					SEAD = true,
					Escort = true,
					["Escort Jammer"] = true,
				},
				country = {
					[1] = "USA",
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "Structure", "Bridge" },
				code_loadout =  { "NAM" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = false,
				range = 450000,
				firepower = 1,
				vCruise = 190,
				vAttack = 205.5,
				hCruise = 7800,
				hAttack = 6000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							["CLSID"] = "{BRU-42_3*Mk-83}",
							["num"] = 7,
						},
						[2] = {
							["CLSID"] = "{BRU-42_3*Mk-83}",
							["num"] = 5,
						},
						[3] = {
							["CLSID"] = "{VSN_F105G_Center_PTB}",
							["num"] = 6,
						},
						[4] = {
							["CLSID"] = "{7A44FF09-527C-4B7E-B42B-3F111CFE50FB}",
							["num"] = 8,
							["settings"] = {
								["00_prfx_arm_delay_ctrl_M904E4"] = 4,
								["00_prfx_function_delay_ctrl_M904E4"] = 0,
								["01_prfx_arm_delay_ctrl_M905"] = 4,
								["01_prfx_function_delay_ctrl_M905"] = 0,
								["NFP_PRESID"] = "MDRN_B_A_GPLD",
								["NFP_PRESVER"] = 2,
								["NFP_VIS_DrawArgNo_57"] = 0,
								["NFP_fuze_type_nose"] = "M904E4",
								["NFP_fuze_type_tail"] = "M905",
							},
						},
						[5] = {
							["CLSID"] = "{7A44FF09-527C-4B7E-B42B-3F111CFE50FB}",
							["num"] = 4,
							["settings"] = {
								["00_prfx_arm_delay_ctrl_M904E4"] = 4,
								["00_prfx_function_delay_ctrl_M904E4"] = 0,
								["01_prfx_arm_delay_ctrl_M905"] = 4,
								["01_prfx_function_delay_ctrl_M905"] = 0,
								["NFP_PRESID"] = "MDRN_B_A_GPLD",
								["NFP_PRESVER"] = 2,
								["NFP_VIS_DrawArgNo_57"] = 0,
								["NFP_fuze_type_nose"] = "M904E4",
								["NFP_fuze_type_tail"] = "M905",
							},
						},
					},
					fuel = 4986,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},			
			["NAM - AG - FT - Mk-84LDx4"] = {
				minscore = 0.3,
				support = {
					SEAD = true,
					Escort = true,
					["Escort Jammer"] = true,
				},
				country = {
					[1] = "USA",
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "Structure", "Bridge" },
				code_loadout =  { "NAM" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = false,
				range = 450000,
				firepower = 1,
				vCruise = 190,
				vAttack = 205.5,
				hCruise = 7800,
				hAttack = 6000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							["CLSID"] = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
							["num"] = 7,
							["settings"] = {
								["00_prfx_arm_delay_ctrl_M904E4"] = 4,
								["00_prfx_function_delay_ctrl_M904E4"] = 0,
								["01_prfx_arm_delay_ctrl_M905"] = 4,
								["01_prfx_function_delay_ctrl_M905"] = 0,
								["NFP_PRESID"] = "MDRN_B_A_GPLD",
								["NFP_PRESVER"] = 2,
								["NFP_VIS_DrawArgNo_57"] = 0,
								["NFP_fuze_type_nose"] = "M904E4",
								["NFP_fuze_type_tail"] = "M905",
							},
						},
						[2] = {
							["CLSID"] = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
							["num"] = 5,
							["settings"] = {
								["00_prfx_arm_delay_ctrl_M904E4"] = 4,
								["00_prfx_function_delay_ctrl_M904E4"] = 0,
								["01_prfx_arm_delay_ctrl_M905"] = 4,
								["01_prfx_function_delay_ctrl_M905"] = 0,
								["NFP_PRESID"] = "MDRN_B_A_GPLD",
								["NFP_PRESVER"] = 2,
								["NFP_VIS_DrawArgNo_57"] = 0,
								["NFP_fuze_type_nose"] = "M904E4",
								["NFP_fuze_type_tail"] = "M905",
							},
						},
						[3] = {
							["CLSID"] = "{VSN_F105G_Center_PTB}",
							["num"] = 6,
						},
						[4] = {
							["CLSID"] = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
							["num"] = 8,
							["settings"] = {
								["00_prfx_arm_delay_ctrl_M904E4"] = 4,
								["00_prfx_function_delay_ctrl_M904E4"] = 0,
								["01_prfx_arm_delay_ctrl_M905"] = 4,
								["01_prfx_function_delay_ctrl_M905"] = 0,
								["NFP_PRESID"] = "MDRN_B_A_GPLD",
								["NFP_PRESVER"] = 2,
								["NFP_VIS_DrawArgNo_57"] = 0,
								["NFP_fuze_type_nose"] = "M904E4",
								["NFP_fuze_type_tail"] = "M905",
							},
						},
						[5] = {
							["CLSID"] = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
							["num"] = 4,
							["settings"] = {
								["00_prfx_arm_delay_ctrl_M904E4"] = 4,
								["00_prfx_function_delay_ctrl_M904E4"] = 0,
								["01_prfx_arm_delay_ctrl_M905"] = 4,
								["01_prfx_function_delay_ctrl_M905"] = 0,
								["NFP_PRESID"] = "MDRN_B_A_GPLD",
								["NFP_PRESVER"] = 2,
								["NFP_VIS_DrawArgNo_57"] = 0,
								["NFP_fuze_type_nose"] = "M904E4",
								["NFP_fuze_type_tail"] = "M905",
							},
						},
					},
					fuel = 4986,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
		},
	},
	["VSN_F105G"] = {
		["Escort Jammer"] = {
			["NAM Jammer AGM-45*2 - FT*3"] = {
				attributes =  { },
				code_loadout =  { "NAM" },
				night = true,
				adverseWeather = true,
				range = 1000000,
				firepower = 2,
				vCruise = 205.5,
				sortie_rate = 12,
				stores = {
					pylons = {
						[1] = {
					["CLSID"] = "{AGM_45A}",
					["num"] = 8,
					["settings"] = {
						["EAS_bypass_ctrl"] = 1,
						["NFP_PRESID"] = "AGM_45",
						["NFP_PRESVER"] = 1,
						["NFP_rfgu_type"] = 5,
						["rf_lower_limit_ctrl_Mk25"] = 4000000000,
						["rf_upper_limit_ctrl_Mk25"] = 6000000000,
						["smoke_marker"] = 0,
					},
				},
				[2] = {
					["CLSID"] = "{AGM_45A}",
					["num"] = 4,
					["settings"] = {
						["EAS_bypass_ctrl"] = 1,
						["NFP_PRESID"] = "AGM_45",
						["NFP_PRESVER"] = 1,
						["NFP_rfgu_type"] = 5,
						["rf_lower_limit_ctrl_Mk25"] = 4000000000,
						["rf_upper_limit_ctrl_Mk25"] = 6000000000,
						["smoke_marker"] = 0,
					},
				},
				[3] = {
					["CLSID"] = "{VSN_F105G_PTB}",
					["num"] = 7,
				},
				[4] = {
					["CLSID"] = "{VSN_F105G_Center_PTB}",
					["num"] = 6,
				},
				[5] = {
					["CLSID"] = "{VSN_F105G_PTB}",
					["num"] = 5,
				},
					},
					fuel = 4986,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
		},
		SEAD = {
			["NAM - SEAD - FT - AGM-45Ax4"] = {
				attributes =  { },
				country = {
					[1] = "USA",
				},
				code_loadout =  { "NAM" },
				attackType = "Dive",
				night = true,
				adverseWeather = false,
				range = 600000,
				firepower = 0.5,
				vCruise = 200,
				sortie_rate = 12,
				stores = {
					pylons = {
						[1] = {
					["CLSID"] = "{AGM_45A}",
					["num"] = 8,
					["settings"] = {
						["EAS_bypass_ctrl"] = 1,
						["NFP_PRESID"] = "AGM_45",
						["NFP_PRESVER"] = 1,
						["NFP_rfgu_type"] = 5,
						["rf_lower_limit_ctrl_Mk25"] = 4000000000,
						["rf_upper_limit_ctrl_Mk25"] = 6000000000,
						["smoke_marker"] = 0,
					},
				},
				[2] = {
					["CLSID"] = "{AGM_45A}",
					["num"] = 7,
					["settings"] = {
						["EAS_bypass_ctrl"] = 1,
						["NFP_PRESID"] = "AGM_45",
						["NFP_PRESVER"] = 1,
						["NFP_rfgu_type"] = 5,
						["rf_lower_limit_ctrl_Mk25"] = 4000000000,
						["rf_upper_limit_ctrl_Mk25"] = 6000000000,
						["smoke_marker"] = 0,
					},
				},
				[3] = {
					["CLSID"] = "{AGM_45A}",
					["num"] = 5,
					["settings"] = {
						["EAS_bypass_ctrl"] = 1,
						["NFP_PRESID"] = "AGM_45",
						["NFP_PRESVER"] = 1,
						["NFP_rfgu_type"] = 5,
						["rf_lower_limit_ctrl_Mk25"] = 4000000000,
						["rf_upper_limit_ctrl_Mk25"] = 6000000000,
						["smoke_marker"] = 0,
					},
				},
				[4] = {
					["CLSID"] = "{AGM_45A}",
					["num"] = 4,
					["settings"] = {
						["EAS_bypass_ctrl"] = 1,
						["NFP_PRESID"] = "AGM_45",
						["NFP_PRESVER"] = 1,
						["NFP_rfgu_type"] = 5,
						["rf_lower_limit_ctrl_Mk25"] = 4000000000,
						["rf_upper_limit_ctrl_Mk25"] = 6000000000,
						["smoke_marker"] = 0,
					},
				},
				[5] = {
					["CLSID"] = "{VSN_F105G_Center_PTB}",
					["num"] = 6,
				},
					},
					fuel = 4986,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
		},
	},
	["vwv_mig17f"] = {
		Strike = {
			["All-AG-FAB-250*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "soft", "Parked Aircraft", "Structure" },
				code_loadout =  { "All" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
								range = 150000,
				firepower = 1,
				vCruise = 200,
				vAttack = 213.86666666667,
				hCruise = 3000,
				hAttack = 3000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							["CLSID"] = "{3C612111-C7AD-476E-8A8E-2485812F4E5C}",
							["num"] = 2,
						},
						[2] = {
							["CLSID"] = "{3C612111-C7AD-476E-8A8E-2485812F4E5C}",
							["num"] = 1,
						},
					},
					fuel = 1140,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		["Fighter Sweep"] = {
			["Fighter Sweep - MiG-17"] = {
				self_escort = true,
				attributes =  { },
				code_loadout =  { "All" },
								range = 250000,
				firepower = 1,
				vCruise = 200,
				vAttack = 250,
				hCruise = 5000,
				hAttack = 5000,
				sortie_rate = 6,
				standoff = 40000,
				stores = {
					pylons = {
					},
					fuel = 1140,
					flare = 0,
					chaff = 0,
					gun = 100,
				},	
			},
		},
		Escort = {
			["Escort - MiG-17"] = {
				attributes =  { },
				code_loadout =  { "All" },
								range = 250000,
				firepower = 1,
				vCruise = 200,
				standoff = 3000,
				sortie_rate = 6,
				stores = {
					pylons = {
					},
					fuel = 1140,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		CAP = {
			["CAP - MiG-17"] = {
				attributes =  { },
				code_loadout =  { "All" },
								range = 250000,
				firepower = 1,
				vCruise = 200,
				vAttack = 213.86666666667,
				hCruise = 3000,
				hAttack = 3000,
				standoff = 3000,
				tStation = 1800,
				sortie_rate = 6,
				stores = {
					pylons = {
					},
					fuel = 1140,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		["Anti-ship Strike"] = {
			["Antiship -AG-FAB-250*2"] = {
				minscore = 0.3,
				support = {
					SEAD = false,
					Escort = true,
					["Laser Illumination"] = false,
				},
				attributes =  { "ship" },
				code_loadout =  { "All" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
								range = 250000,
				firepower = 1,
				vCruise = 200,
				vAttack = 213.86666666667,
				hCruise = 3000,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							["CLSID"] = "{3C612111-C7AD-476E-8A8E-2485812F4E5C}",
							["num"] = 2,
						},
						[2] = {
							["CLSID"] = "{3C612111-C7AD-476E-8A8E-2485812F4E5C}",
							["num"] = 1,
						},
					},
					fuel = 1140,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		Intercept = {
			["Intercept - Mig-17F"] = {
				attributes =  { },
				code_loadout =  { "All" },
								range = 150000,
				firepower = 1,
				sortie_rate = 6,
				stores = {
					pylons = {
					},
					fuel = 1140,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
	},
	["tu_22D"] = {
		Strike = {
			["WOT87 - Strike bombs - Low"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Structure", "SAM" },
				code_loadout =  { "WOT87" },
				weaponType = "Bombs",
				expend = "All",
								range = 900000,
				firepower = 1,
				vCruise = 250,
				vAttack = 300,
				hCruise = 4096,
				hAttack = 1000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = 
						{
						["CLSID"] = "{FA673F4C-D9E4-4993-AA7A-019A92F3C005}",
						}, -- end of [1]
						[2] = 
						{
						["CLSID"] = "<CLEAN>",
						}, -- end of [2]
					},
					fuel = 42500,
					flare = 0,
					chaff = 45,
					gun = 100,
				},
			},
			["WOT87 Strike bombs - High"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Structure", "SAM" },
				code_loadout =  { "WOT87" },
				weaponType = "Bombs",
				expend = "All",
								range = 900000,
				firepower = 1,
				vCruise = 250,
				vAttack = 300,
				hCruise = 6096,
				hAttack = 6096,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = 
						{
						["CLSID"] = "{FA673F4C-D9E4-4993-AA7A-019A92F3C005}",
						}, -- end of [1]
						[2] = 
						{
						["CLSID"] = "<CLEAN>",
						}, -- end of [2]
					},
					fuel = 42500,
					flare = 0,
					chaff = 45,
					gun = 100,
				},
			},
		},
		["Runway Attack"] = {
			["RAttack bombs - Low"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Runway" },
				code_loadout =  { "WOT87" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				day = false,
				range = 900000,
				firepower = 1,
				vCruise = 250,
				vAttack = 300,
				hCruise = 4096,
				hAttack = 4000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = 
						{
						["CLSID"] = "{FA673F4C-D9E4-4993-AA7A-019A92F3C005}",
						}, -- end of [1]
						[2] = 
						{
						["CLSID"] = "<CLEAN>",
						}, -- end of [2]
					},
					fuel = 42500,
					flare = 0,
					chaff = 45,
					gun = 100,
				},
			},
			["RAttack bombs - High"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Runway" },
				code_loadout =  { "WOT87" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				range = 900000,
				firepower = 5,
				vCruise = 250,
				vAttack = 300,
				hCruise = 6096,
				hAttack = 6096,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = 
						{
						["CLSID"] = "{FA673F4C-D9E4-4993-AA7A-019A92F3C005}",
						}, -- end of [1]
						[2] = 
						{
						["CLSID"] = "<CLEAN>",
						}, -- end of [2]
					},
					fuel = 42500,
					flare = 0,
					chaff = 45,
					gun = 100,
				},
			},
		},
	},
	["vwv_mig21pfm"] = {
		CAP = {
			["NAM - AA CAP  AA-2B*2"] = {
				attributes =  { "" },
				code_loadout =  { "NAM" },
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 200,
				vAttack = 220,
				hCruise = 4000,
				hAttack = 4200,
				standoff = 1000,
				tStation = 2000,
				sortie_rate = 6,
				stores = {
					pylons = {
					[1] = {
					["CLSID"] = "{R-3S}",
					["num"] = 4,
					},
					[2] = {
					["CLSID"] = "{R-3S}",
					["num"] = 1,
					},
					},
					fuel = 2350,
					flare = 0,
					chaff = 0,
					gun = 0,
				},
			},
			["NAM - AA CAP  AA-2B*4"] = {
				attributes =  { "" },
				code_loadout =  { "NAM" },
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 200,
				vAttack = 220,
				hCruise = 4000,
				hAttack = 4200,
				standoff = 1000,
				tStation = 2000,
				sortie_rate = 6,
				stores = {
					pylons = {
					[1] = {
					["CLSID"] = "{R-3S}",
					["num"] = 4,
					},
					[2] = {
					["CLSID"] = "{R-3S}",
					["num"] = 1,
					},
					[3] = {
					["CLSID"] = "{R-3S}",
					["num"] = 3,
					},
					[4] = {
					["CLSID"] = "{R-3S}",
					["num"] = 2,
					},
					},
					fuel = 2350,
					flare = 0,
					chaff = 0,
					gun = 0,
				},
			},
		},
		["Fighter Sweep"] = {
			["NAM - AA Sweep AA-2B*2"] = {
				attributes =  { },
				code_loadout =  { "NAM" },
				night = false,
				adverseWeather = false,
				range = 500000,
				firepower = 1,
				vCruise = 250,
				vAttack = 350,
				hCruise = 500,
				hAttack = 500,
				standoff = 1000,
				sortie_rate = 6,
				stores = {
					pylons = {
					[1] = {
					["CLSID"] = "{R-3S}",
					["num"] = 4,
					},
					[2] = {
					["CLSID"] = "{R-3S}",
					["num"] = 1,
					},
					},
					fuel = 2350,
					flare = 0,
					chaff = 0,
					gun = 0,
				},
			},
			["NAM - AA Sweep AA-2B*4"] = {
				attributes =  { },
				code_loadout =  { "NAM" },
				night = false,
				adverseWeather = false,
				range = 500000,
				firepower = 1,
				vCruise = 250,
				vAttack = 350,
				hCruise = 500,
				hAttack = 500,
				standoff = 1000,
				sortie_rate = 6,
				stores = {
					pylons = {
					[1] = {
					["CLSID"] = "{R-3S}",
					["num"] = 4,
					},
					[2] = {
					["CLSID"] = "{R-3S}",
					["num"] = 1,
					},
					[3] = {
					["CLSID"] = "{R-3S}",
					["num"] = 3,
					},
					[4] = {
					["CLSID"] = "{R-3S}",
					["num"] = 2,
					},
					},
					fuel = 2350,
					flare = 0,
					chaff = 0,
					gun = 0,
				},
			},
		},	
		Intercept = {
			["NAM - AA Inter AA-2B*2"] = {
				attributes =  { },
				code_loadout =  { "NAM" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				sortie_rate = 6,
				stores = {
					pylons = {
					[1] = {
					["CLSID"] = "{R-3S}",
					["num"] = 4,
					},
					[2] = {
					["CLSID"] = "{R-3S}",
					["num"] = 1,
					},
					},
					fuel = 2350,
					flare = 0,
					chaff = 0,
					gun = 0,
				},
			},
			["NAM - AA Inter AA-2B*4"] = {
				attributes =  { },
				code_loadout =  { "NAM" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				sortie_rate = 6,
				stores = {
					pylons = {
					[1] = {
					["CLSID"] = "{R-3S}",
					["num"] = 4,
					},
					[2] = {
					["CLSID"] = "{R-3S}",
					["num"] = 1,
					},
					[3] = {
					["CLSID"] = "{R-3S}",
					["num"] = 3,
					},
					[4] = {
					["CLSID"] = "{R-3S}",
					["num"] = 2,
					},
					},
					fuel = 2350,
					flare = 0,
					chaff = 0,
					gun = 0,
				},
			},
		},
	},
	["vwv_mig21mf"] = {
		CAP = {
			["NAM - AA CAP  AA-2B*2"] = {
				attributes =  { "" },
				code_loadout =  { "NAM" },
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 200,
				vAttack = 220,
				hCruise = 4000,
				hAttack = 4200,
				standoff = 1000,
				tStation = 2000,
				sortie_rate = 6,
				stores = {
					pylons = {
					[1] = {
					["CLSID"] = "{R-3S}",
					["num"] = 1,
					},
					[2] = {
					["CLSID"] = "{R-3S}",
					["num"] = 5,
					},
					},
					fuel = 2600,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
			["NAM - AA CAP  AA-2B*4"] = {
				attributes =  { "" },
				code_loadout =  { "NAM" },
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 200,
				vAttack = 220,
				hCruise = 4000,
				hAttack = 4200,
				standoff = 1000,
				tStation = 2000,
				sortie_rate = 6,
				stores = {
					pylons = {
					[1] = {
					["CLSID"] = "{R-3S}",
					["num"] = 1,
					},
					[2] = {
					["CLSID"] = "{R-3S}",
					["num"] = 5,
					},
					[3] = {
					["CLSID"] = "{R-3S}",
					["num"] = 4,
					},
					[4] = {
					["CLSID"] = "{R-3S}",
					["num"] = 2,
					},
					},
					fuel = 2600,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		["Fighter Sweep"] = {
			["NAM - AA Sweep AA-2B*2"] = {
				attributes =  { },
				code_loadout =  { "NAM" },
				night = false,
				adverseWeather = false,
				range = 500000,
				firepower = 1,
				vCruise = 250,
				vAttack = 350,
				hCruise = 500,
				hAttack = 500,
				standoff = 1000,
				sortie_rate = 6,
				stores = {
					pylons = {
					[1] = {
					["CLSID"] = "{R-3S}",
					["num"] = 1,
					},
					[2] = {
					["CLSID"] = "{R-3S}",
					["num"] = 5,
					},
					},
					fuel = 2600,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
			["NAM - AA Sweep AA-2B*4"] = {
				attributes =  { },
				code_loadout =  { "NAM" },
				night = false,
				adverseWeather = false,
				range = 500000,
				firepower = 1,
				vCruise = 250,
				vAttack = 350,
				hCruise = 500,
				hAttack = 500,
				standoff = 1000,
				sortie_rate = 6,
				stores = {
					pylons = {
					[1] = {
					["CLSID"] = "{R-3S}",
					["num"] = 1,
					},
					[2] = {
					["CLSID"] = "{R-3S}",
					["num"] = 5,
					},
					[3] = {
					["CLSID"] = "{R-3S}",
					["num"] = 4,
					},
					[4] = {
					["CLSID"] = "{R-3S}",
					["num"] = 2,
					},
					},
					fuel = 2600,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},	
		Intercept = {
			["NAM - AA Inter AA-2B*2"] = {
				attributes =  { },
				code_loadout =  { "NAM" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				sortie_rate = 6,
				stores = {
					pylons = {
					[1] = {
					["CLSID"] = "{R-3S}",
					["num"] = 1,
					},
					[2] = {
					["CLSID"] = "{R-3S}",
					["num"] = 5,
					},
					},
					fuel = 2600,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
			["NAM - AA Inter AA-2B*4"] = {
				attributes =  { },
				code_loadout =  { "NAM" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				sortie_rate = 6,
				stores = {
					pylons = {
					[1] = {
					["CLSID"] = "{R-3S}",
					["num"] = 1,
					},
					[2] = {
					["CLSID"] = "{R-3S}",
					["num"] = 5,
					},
					[3] = {
					["CLSID"] = "{R-3S}",
					["num"] = 4,
					},
					[4] = {
					["CLSID"] = "{R-3S}",
					["num"] = 2,
					},
					},
					fuel = 2600,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
	},
	["vwv_crusader"] = {
		["Fighter Sweep"] = {
			["Fighter Sweep - Crusader"] = {
				self_escort = true,
				attributes =  { },
				code_loadout =  { "All" },
								range = 370000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 5486.4,
				hAttack = 5487,
				sortie_rate = 6,
				standoff = 40000,
				stores = {
					pylons = {
					[1] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 6,
					},
					[2] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 1,
					},
					[3] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 5,
					},
					[4] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 2,
					},
					[5] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 4,
					},
					[6] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 3,
					},
				},				
					fuel = 4096,
					flare = 120,
					chaff = 120,
					gun = 100,
				},	
			},
		},
		Escort = {
			["Escort - Crusader"] = {
				attributes =  { },
				code_loadout =  { "All" },
								range = 1600000,
				firepower = 1,
				vCruise = 245,
				standoff = 80000,
				sortie_rate = 6,
				stores = {
					pylons = {
					[1] = {
					["CLSID"] = "{DFT-300gal_LR}",
					["num"] = 6,
					},
					[2] = {
					["CLSID"] = "{DFT-300gal_LR}",
					["num"] = 1,
					},
					[3] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 5,
					},
					[4] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 4,
					},
					[5] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 3,
					},
					[6] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 2,
					},
					},				
					fuel = 4096,
					flare = 120,
					chaff = 120,
					gun = 100,
				},	
			},
		},
		CAP = {
			["CAP - Crusader"] = {
				attributes =  {"CV CAP"},
				code_loadout =  { "All" },
								range = 370000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 5486.4,
				hAttack = 5487,
				standoff = 80000,
				tStation = 1800,
				sortie_rate = 6,
				stores = {
					pylons = {
					[1] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 6,
					},
					[2] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 1,
					},
					[3] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 5,
					},
					[4] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 2,
					},
					[5] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 4,
					},
					[6] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 3,
					},
				},
				},
					fuel = 4096,
					flare = 120,
					chaff = 120,
					gun = 100,
			},
		},
		Intercept = {
			["Intercept - Crusader"] = {
				attributes =  { },
				code_loadout =  { "All" },
								range = 300000,
				firepower = 1,
				sortie_rate = 6,
				stores = {
					pylons = {
					[1] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 6,
					},
					[2] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 1,
					},
					[3] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 5,
					},
					[4] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 2,
					},
					[5] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 4,
					},
					[6] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 3,
					},
					},
					fuel = 4096,
					flare = 120,
					chaff = 120,
					gun = 100,
				},
			},
		},
	},
	["vwv_ra-5"] = {
		Reconnaissance = {
			["Reco NAM High"] = {
				support = {
					Escort = false,
					SEAD = false,
					["Escort Jammer"] = true,
				},
				attributes =  { "recon high" },
				code_loadout =  { "NAM" },
				night = false,
				adverseWeather = false,
				range = 900000,
				firepower = 10,
				vCruise = 305,
				vAttack = 443,
				hCruise = 9144,
				hAttack = 15000,
				tStation = 2000,
				sortie_rate = 3,
				stores = {
					pylons = {
					},
					fuel = 10000,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
			["Reco NAM Low"] = {
				support = {
					Escort = false,
					SEAD = false,
					["Escort Jammer"] = false,
				},
				attributes =  { "recon low" },
				code_loadout =  { "NAM" },
				night = false,
				adverseWeather = true,
				range = 900000,
				firepower = 10,
				vCruise = 290,
				vAttack = 305,
				hCruise = 300,
				hAttack = 300,
				tStation = 2000,
				sortie_rate = 3,
				stores = {
					pylons = {
					},
					fuel = 10000,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
	},
	["EA_6B"] = {
		SEAD = {
			["Old TF SEAD AGM-88*4, ECM"] = {
				attributes =  { },
				code_loadout =  { "TF", "TF80s" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 2,
				vCruise = 205.5,
				sortie_rate = 12,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
						},
						[2] = {
							CLSID = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
						},
						[3] = {
							CLSID = "{EA6B_ANALQ992}",
						},
						[4] = {
							CLSID = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
						},
						[5] = {
							CLSID = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
						},
					},
					fuel = 6994,
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
			["NAM SEAD AGM-45*4, ECM"] = {
				attributes =  { },
				code_loadout =  { "NAM" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 2,
				vCruise = 205.5,
				sortie_rate = 12,
				stores = {
					pylons = {
						[1] = {
							["CLSID"] = "{AGM_45A}",
					["num"] = 1,
					["settings"] = {
						["EAS_bypass_ctrl"] = 0,
						["NFP_rfgu_type"] = 1,
						["rf_lower_limit_ctrl_Mk22Mod2"] = 4800000000,
						["rf_upper_limit_ctrl_Mk22Mod2"] = 5200000000,
					},
						},
						[2] = {
							["CLSID"] = "{AGM_45A}",
					["num"] = 2,
					["settings"] = {
						["EAS_bypass_ctrl"] = 0,
						["NFP_rfgu_type"] = 1,
						["rf_lower_limit_ctrl_Mk22Mod2"] = 4800000000,
						["rf_upper_limit_ctrl_Mk22Mod2"] = 5200000000,
					},
						},
						[3] = {
							["CLSID"] = "{EA6B_ANALQ992}",
					["num"] = 3,
						},
						[4] = {
							["CLSID"] = "{AGM_45A}",
					["num"] = 4,
					["settings"] = {
						["EAS_bypass_ctrl"] = 0,
						["NFP_rfgu_type"] = 1,
						["rf_lower_limit_ctrl_Mk22Mod2"] = 4800000000,
						["rf_upper_limit_ctrl_Mk22Mod2"] = 5200000000,
					},
						},
						[5] = {
							["CLSID"] = "{AGM_45A}",
					["num"] = 5,
					["settings"] = {
						["EAS_bypass_ctrl"] = 0,
						["NFP_rfgu_type"] = 1,
						["rf_lower_limit_ctrl_Mk22Mod2"] = 4800000000,
						["rf_upper_limit_ctrl_Mk22Mod2"] = 5200000000,
					},
						},
					},
					fuel = 6994,
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
			["SEAD 80s AGM-88x2,EPx3"] = {
				attributes =  { },
				code_loadout =  { "TF", "TF80s" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 2,
				vCruise = 270,
				sortie_rate = 12,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{EA6B_ANALQ991}",
						},
						[2] = {
							CLSID = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
						},
						[3] = {
							CLSID = "{EA6B_ANALQ992}",
						},
						[4] = {
							CLSID = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
						},
						[5] = {
							CLSID = "{EA6B_ANALQ991}",
						},
					},
					fuel = 6994,
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
		},
		["Escort Jammer"] = {
			["EPx3-SEAD"] = {
				attributes =  { },
				code_loadout =  { "TF", "TF80s", "WOC80" },
				attackType = "Dive",
				night = true,
				adverseWeather = true,
				range = 1000000,
				firepower = 2,
				vCruise = 240,
				sortie_rate = 12,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{EA6B_ANALQ991}",
						},
						[2] = {
							CLSID = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
						},
						[3] = {
							CLSID = "{EA6B_ANALQ992}",
						},
						[4] = {
							CLSID = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
						},
						[5] = {
							CLSID = "{EA6B_ANALQ991}",
						},
					},
					fuel = 6994,
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
			["NAM-EPx3-SEAD"] = {
				attributes =  { },
				code_loadout =  { "NAM" },
				attackType = "Dive",
				night = true,
				adverseWeather = true,
				range = 1000000,
				firepower = 2,
				vCruise = 240,
				sortie_rate = 12,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{EA6B_ANALQ991}",
						},
						[3] = {
							CLSID = "{EA6B_ANALQ992}",
						},
						[5] = {
							CLSID = "{EA6B_ANALQ991}",
						},
					},
					fuel = 6994,
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
		},
	},
	Hercules = {
		Transport = {
			Default = {
				attributes =  { },
				code_loadout =  { "Cyprus" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 154.16666666667,
				vAttack = 154.16666666667,
				hCruise = 4572,
				hAttack = 4572,
				sortie_rate = 6,
				stores = {
					pylons = {
						[11] = {
							CLSID = "Herc_GEN_CRATE",
						},
						[10] = {
							CLSID = "Herc_GEN_CRATE",
						},
						[12] = {
							CLSID = "Herc_GEN_CRATE",
						},
					},
					fuel = 11855,
					flare = 840,
					chaff = 840,
					gun = 100,
				},
			},
			WOB = {
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { },
				code_loadout =  { "WOB", "NAM" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 154.16666666667,
				vAttack = 154.16666666667,
				hCruise = 100,
				hAttack = 100,
				sortie_rate = 6,
				stores = {
					pylons = {
						[11] = {
							CLSID = "Herc_GEN_CRATE",
						},
						[10] = {
							CLSID = "Herc_GEN_CRATE",
						},
						[12] = {
							CLSID = "Herc_GEN_CRATE",
						},
					},
					fuel = 11855,
					flare = 840,
					chaff = 840,
					gun = 100,
				},
			},
		},
	},
	["MirageF1CT"] = {
		Strike = {
			["AS-30L*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Structure" },
				code_loadout =  { "IIW" },
				weaponType = "ASM",
				expend = "Auto",
				attackType = "Dive",
				night = true,
				range = 400000,
				firepower = 1,
				vCruise = 250,
				vAttack = 300,
				hCruise = 5500,
				hAttack = 4000,
				standoff = 15000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
						[3] = {
							CLSID = "{AS_30L}",
						},
						[4] = {
							CLSID = "{RP_35_F1}",
						},
						[5] = {
							CLSID = "{AS_30L}",
						},
						[7] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
						[8] = {
							CLSID = "COLD START",
						},
						[9] = {
							CLSID = "ECARTOMETRE LASER",
						},
					},
					fuel = 4530,
					flare = 50,
					chaff = 50,
					gun = 100,
				},
			},
			["GBU-16"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Structure" },
				code_loadout =  { "IIW" },
				weaponType = "Guided bombs",
				expend = "Auto",
				attackType = "Dive",
				night = true,
				range = 400000,
				firepower = 1,
				vCruise = 250,
				vAttack = 300,
				hCruise = 5500,
				hAttack = 4000,
				standoff = 15000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
						[3] = {
							CLSID = "{0D33DDAE-524F-4A4E-B5B8-621754FE3ADE}",
						},
						[4] = {
							CLSID = "{RP_35_F1}",
						},
						[5] = {
							CLSID = "{0D33DDAE-524F-4A4E-B5B8-621754FE3ADE}",
						},
						[7] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
						[8] = {
							CLSID = "COLD START",
						},
						[9] = {
							CLSID = "ECARTOMETRE LASER",
						},
					},
					fuel = 4530,
					flare = 50,
					chaff = 50,
					gun = 100,
				},
			},
		},
		["Anti-ship Strike"] = {
			["AS-30L*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "ship" },
				code_loadout =  { "IIW" },
				weaponType = "ASM",
				expend = "Auto",
				attackType = "Dive",
								range = 400000,
				firepower = 1,
				vCruise = 250,
				vAttack = 300,
				hCruise = 5500,
				hAttack = 4000,
				standoff = 15000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
						[3] = {
							CLSID = "{AS_30L}",
						},
						[4] = {
							CLSID = "{RP_35_F1}",
						},
						[5] = {
							CLSID = "{AS_30L}",
						},
						[7] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
						[8] = {
							CLSID = "COLD START",
						},
						[9] = {
							CLSID = "ECARTOMETRE LASER",
						},
					},
					fuel = 4530,
					flare = 50,
					chaff = 50,
					gun = 100,
				},
			},
		},
	},
	["A-4E-C"] = {
		SEAD = {
			SEAD = {
				attributes =  { },
				country = {
					[1] = "Argentina",
				},
				code_loadout =  { "Revenge" },
				attackType = "Dive",
				adverseWeather = true,
				range = 600000,
				firepower = 0.5,
				vCruise = 200,
				sortie_rate = 12,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{3E6B632D-65EB-44D2-9501-1C2D04515404}",
						},
						[2] = {
							CLSID = "{DFT-150gal}",
						},
						[3] = {
							CLSID = "{Mk4 HIPEG}",
						},
						[4] = {
							CLSID = "{DFT-150gal}",
						},
						[5] = {
							CLSID = "{3E6B632D-65EB-44D2-9501-1C2D04515404}",
						},
					},
					fuel = 2467.5454273299,
					flare = 30,
					ammo_type = 1,
					chaff = 30,
					gun = 100,
				},
			},
			["SEAD2"] = {
				attributes =  { },
				country = {
					[1] = "Argentina",
				},
				code_loadout =  { "Revenge" },
				attackType = "Dive",
				adverseWeather = true,
				range = 600000,
				firepower = 0.5,
				vCruise = 200,
				sortie_rate = 12,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{3E6B632D-65EB-44D2-9501-1C2D04515404}",
						},
						[2] = {
							CLSID = "{3E6B632D-65EB-44D2-9501-1C2D04515404}",
						},
						[3] = {
							CLSID = "{DFT-300gal}",
						},
						[4] = {
							CLSID = "{3E6B632D-65EB-44D2-9501-1C2D04515404}",
						},
						[5] = {
							CLSID = "{3E6B632D-65EB-44D2-9501-1C2D04515404}",
						},
					},
					fuel = 2467.5454273299,
					flare = 30,
					ammo_type = 1,
					chaff = 30,
					gun = 100,
				},
			},
			["SEAD3"] = {
				attributes =  { },
				country = {
					[1] = "Argentina",
				},
				code_loadout =  { "Revenge" },
				attackType = "Dive",
				adverseWeather = true,
				range = 600000,
				firepower = 0.5,
				vCruise = 200,
				sortie_rate = 12,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9P5-ON-ADAPTER}",
						},
						[2] = {
							CLSID = "{3E6B632D-65EB-44D2-9501-1C2D04515404}",
						},
						[3] = {
							CLSID = "{DFT-300gal}",
						},
						[4] = {
							CLSID = "{3E6B632D-65EB-44D2-9501-1C2D04515404}",
						},
						[5] = {
							CLSID = "{AIM-9P5-ON-ADAPTER}",
						},
					},
					fuel = 2467.5454273299,
					flare = 30,
					ammo_type = 1,
					chaff = 30,
					gun = 100,
				},
			},
			["NAM -SEAD - Shrike*2"] = {
				attributes =  { },
				country = {
					[1] = "USA",
				},
				code_loadout =  { "NAM" },
				attackType = "Dive",
				adverseWeather = true,
				range = 600000,
				firepower = 0.5,
				vCruise = 200,
				hCruise = 4500,
				hAttack = 500,
				sortie_rate = 12,
				stores = {
					pylons = {
						[1] = {
					["CLSID"] = "{C_A4E_AGM-45B_LAU34}",
					["num"] = 5,
					["settings"] = {
						["EAS_bypass_ctrl"] = 1,
						["NFP_PRESID"] = "AGM_45",
						["NFP_PRESVER"] = 1,
						["NFP_rfgu_type"] = 5,
						["rf_lower_limit_ctrl_Mk25"] = 4000000000,
						["rf_upper_limit_ctrl_Mk25"] = 6000000000,
						["smoke_marker"] = 0,
					},
				},
				[2] = {
					["CLSID"] = "{C_A4E_AGM-45B_LAU34}",
					["num"] = 1,
					["settings"] = {
						["EAS_bypass_ctrl"] = 1,
						["NFP_PRESID"] = "AGM_45",
						["NFP_PRESVER"] = 1,
						["NFP_rfgu_type"] = 5,
						["rf_lower_limit_ctrl_Mk25"] = 4000000000,
						["rf_upper_limit_ctrl_Mk25"] = 6000000000,
						["smoke_marker"] = 0,
					},
				},
				[3] = {
					["CLSID"] = "{DFT-150gal}",
					["num"] = 3,
				},
				[4] = {
					["CLSID"] = "{DFT-150gal}",
					["num"] = 4,
				},
				[5] = {
					["CLSID"] = "{DFT-150gal}",
					["num"] = 2,
				},
					},
					fuel = 2467.5454273299,
					flare = 30,
					ammo_type = 1,
					chaff = 30,
					gun = 100,
				},
			},
		},
		["Anti-ship Strike"] = {
			["M-65"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "ship" },
				country = {
					[1] = "Argentina",
				},
				code_loadout =  { "Revenge" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				range = 1600000,
				firepower = 0.5,
				vCruise = 200,
				vAttack = 350,
				hCruise = 4500,
				hAttack = 4500,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9P5-ON-ADAPTER}",
						},
						[2] = {
							CLSID = "{DFT-150gal}",
						},
						[3] = {
							CLSID = "{AN_M65}",
							settings = {
								["function_delay_ctrl_ANM102A2"] = 0,
								["vane_rev_threshold_ctrl_FD_0_ANM103A1"] = 300,
								["function_delay_ctrl_ANM103A1"] = 0,
								NFP_fuze_type_tail = 1,
								NFP_fuze_type_nose = 1,
								["vane_rev_threshold_ctrl_ANM102A2"] = 160,
							},
						},
						[4] = {
							CLSID = "{DFT-150gal}",
						},
						[5] = {
							CLSID = "{AIM-9P5-ON-ADAPTER}",
						},
					},
					fuel = 2467.5454273299,
					flare = 30,
					ammo_type = 1,
					chaff = 30,
					gun = 100,
				},
			},
		},
		Strike = {
			ZUNI = {
				minscore = 0.3,
				support = {
					SEAD = true,
					Escort = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				country = {
					[1] = "Argentina",
				},
				code_loadout =  { "Revenge" },
				weaponType = "rockets",
				expend = "All",
				night = true,
				range = 600000,
				firepower = 0.5,
				vCruise = 200,
				vAttack = 350,
				hCruise = 4500,
				hAttack = 4500,
				LDSD = true,
				sortie_rate = 8,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9P5-ON-ADAPTER}",
						},
						[2] = {
							CLSID = "{F3EFE0AB-E91A-42D8-9CA2-B63C91ED570A}",
						},
						[3] = {
							CLSID = "{DFT-300gal}",
						},
						[4] = {
							CLSID = "{F3EFE0AB-E91A-42D8-9CA2-B63C91ED570A}",
						},
						[5] = {
							CLSID = "{AIM-9P5-ON-ADAPTER}",
						},
					},
					fuel = 2467.5454273299,
					flare = 30,
					ammo_type = 1,
					chaff = 30,
					gun = 100,
				},
			},
			["2*M65"] = {
				minscore = 0.3,
				support = {
					SEAD = true,
					Escort = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				country = {
					[1] = "Argentina",
				},
				code_loadout =  { "Revenge" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				range = 1600000,
				firepower = 0.5,
				vCruise = 200,
				vAttack = 350,
				hCruise = 4500,
				hAttack = 4500,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9P5-ON-ADAPTER}",
						},
						[2] = {
							CLSID = "{AN_M65}",
							settings = {
								["function_delay_ctrl_ANM102A2"] = 0,
								["vane_rev_threshold_ctrl_FD_0_ANM103A1"] = 300,
								["function_delay_ctrl_ANM103A1"] = 0,
								NFP_fuze_type_tail = 1,
								NFP_fuze_type_nose = 1,
								["vane_rev_threshold_ctrl_ANM102A2"] = 160,
							},
						},
						[3] = {
							CLSID = "{DFT-300gal}",
						},
						[4] = {
							CLSID = "{AN_M65}",
							settings = {
								["function_delay_ctrl_ANM102A2"] = 0,
								["vane_rev_threshold_ctrl_FD_0_ANM103A1"] = 300,
								["function_delay_ctrl_ANM103A1"] = 0,
								NFP_fuze_type_tail = 1,
								NFP_fuze_type_nose = 1,
								["vane_rev_threshold_ctrl_ANM102A2"] = 160,
							},
						},
						[5] = {
							CLSID = "{AIM-9P5-ON-ADAPTER}",
						},
					},
					fuel = 2467.5454273299,
					flare = 30,
					ammo_type = 1,
					chaff = 30,
					gun = 100,
				},
			},
			["2*MK83"] = {
				minscore = 0.3,
				support = {
					SEAD = true,
					Escort = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "Structure" },
				country = {
					[1] = "Argentina",
				},
				code_loadout =  { "Revenge" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				range = 1600000,
				firepower = 0.5,
				vCruise = 200,
				vAttack = 350,
				hCruise = 4500,
				hAttack = 4500,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9P5-ON-ADAPTER}",
						},
						[2] = {
							CLSID = "{7A44FF09-527C-4B7E-B42B-3F111CFE50FB}",
						},
						[3] = {
							CLSID = "{DFT-300gal}",
						},
						[4] = {
							CLSID = "{7A44FF09-527C-4B7E-B42B-3F111CFE50FB}",
						},
						[5] = {
							CLSID = "{AIM-9P5-ON-ADAPTER}",
						},
					},
					fuel = 2467.5454273299,
					flare = 30,
					ammo_type = 1,
					chaff = 30,
					gun = 100,
				},
			},
			["4*MK82"] = {
				minscore = 0.3,
				support = {
					SEAD = true,
					Escort = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				country = {
					[1] = "Argentina",
				},
				code_loadout =  { "Revenge" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 1600000,
				firepower = 0.5,
				vCruise = 200,
				vAttack = 350,
				hCruise = 4500,
				hAttack = 4500,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9P5-ON-ADAPTER}",
						},
						[2] = {
							CLSID = "{Mk-82_TER_2_L}",
						},
						[3] = {
							CLSID = "{DFT-300gal}",
						},
						[4] = {
							CLSID = "{Mk-82_TER_2_R}",
						},
						[5] = {
							CLSID = "{AIM-9P5-ON-ADAPTER}",
						},
					},
					fuel = 2467.5454273299,
					flare = 30,
					ammo_type = 1,
					chaff = 30,
					gun = 100,
				},
			},
			["2*mk20"] = {
				minscore = 0.3,
				support = {
					SEAD = true,
					Escort = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				country = {
					[1] = "Argentina",
				},
				code_loadout =  { "Revenge" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				range = 600000,
				firepower = 0.5,
				vCruise = 200,
				vAttack = 350,
				hCruise = 4500,
				hAttack = 4500,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9P5-ON-ADAPTER}",
						},
						[2] = {
							CLSID = "{ADD3FAE1-EBF6-4EF9-8EFC-B36B5DDF1E6B}",
						},
						[3] = {
							CLSID = "{DFT-300gal}",
						},
						[4] = {
							CLSID = "{ADD3FAE1-EBF6-4EF9-8EFC-B36B5DDF1E6B}",
						},
						[5] = {
							CLSID = "{AIM-9P5-ON-ADAPTER}",
						},
					},
					fuel = 2467.5454273299,
					flare = 30,
					ammo_type = 1,
					chaff = 30,
					gun = 100,
				},
			},
			["2*M117"] = {
				minscore = 0.3,
				support = {
					SEAD = true,
					Escort = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				country = {
					[1] = "Argentina",
				},
				code_loadout =  { "Revenge" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 1600000,
				firepower = 0.5,
				vCruise = 200,
				vAttack = 350,
				hCruise = 4500,
				hAttack = 4500,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9P5-ON-ADAPTER}",
						},
						[2] = {
							CLSID = "{00F5DAC4-0466-4122-998F-B1A298E34113}",
						},
						[3] = {
							CLSID = "{DFT-300gal}",
						},
						[4] = {
							CLSID = "{00F5DAC4-0466-4122-998F-B1A298E34113}",
						},
						[5] = {
							CLSID = "{AIM-9P5-ON-ADAPTER}",
						},
					},
					fuel = 2467.5454273299,
					flare = 30,
					ammo_type = 1,
					chaff = 30,
					gun = 100,
				},
			},
			["NAM - AG - AIM-9Jx2 - FTx2 - Mk-82LDx6"] = {
				minscore = 0.3,
				support = {
					SEAD = true,
					Escort = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				country = {
					[1] = "USA",
				},
				code_loadout =  { "NAM" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 1600000,
				firepower = 1,
				vCruise = 200,
				vAttack = 350,
				hCruise = 4500,
				hAttack = 4500,
				sortie_rate = 6,
				stores = {
					pylons = {
					[1] = {
					["CLSID"] = "{AIM-9J-ON-ADAPTER}",
					["num"] = 5,
				},
				[2] = {
					["CLSID"] = "{AIM-9J-ON-ADAPTER}",
					["num"] = 1,
				},
				[3] = {
					["CLSID"] = "{Mk-82_MER_6_C}",
					["num"] = 3,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_M904E4"] = 4,
						["00_prfx_function_delay_ctrl_M904E4"] = 0,
						["01_prfx_arm_delay_ctrl_M905"] = 4,
						["01_prfx_function_delay_ctrl_M905"] = 0,
						["NFP_PRESID"] = "MDRN_B_A_GPLD",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
					},
				},
				[4] = {
					["CLSID"] = "{DFT-300gal_LR}",
					["num"] = 4,
				},
				[5] = {
					["CLSID"] = "{DFT-300gal_LR}",
					["num"] = 2,
				},
					},
					fuel = 2467.5454273299,
					flare = 30,
					ammo_type = 1,
					chaff = 30,
					gun = 100,
				},
			},
			["NAM -AG - Rockeye*3"] = {
				minscore = 0.3,
				support = {
					SEAD = true,
					Escort = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				restrictedCondition = "restricted_loadoutnam3",      --restricted_loadoutnam3
				country = {
					[1] = "USA",
				},
				code_loadout =  { "NAM" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 1600000,
				firepower = 1,
				vCruise = 200,
				vAttack = 350,
				hCruise = 4500,
				hAttack = 4500,
				sortie_rate = 6,
				stores = {
					pylons = {
					[1] = {
					["CLSID"] = "{AIM-9J-ON-ADAPTER}",
					["num"] = 5,
				},
				[2] = {
					["CLSID"] = "{AIM-9J-ON-ADAPTER}",
					["num"] = 1,
				},
				[3] = {
					["CLSID"] = "{Mk-20_TER_3_C}",
					["num"] = 3,
					["settings"] = {
						["NFP_PRESID"] = "MDRN_CC_A_Mk20",
						["NFP_PRESVER"] = 2,
						["NFP_fuze_type_nose"] = "Mk339Mod1",
						["function_delay_ctrl_00_Mk339Mod1"] = 1.2,
						["function_delay_ctrl_01_Mk339Mod1"] = 4,
					},
				},
				[4] = {
					["CLSID"] = "{DFT-300gal_LR}",
					["num"] = 4,
				},
				[5] = {
					["CLSID"] = "{DFT-300gal_LR}",
					["num"] = 2,
				},
					},
					fuel = 2467.5454273299,
					flare = 30,
					ammo_type = 1,
					chaff = 30,
					gun = 100,
				},
			},
			["NAM - AG - AIM-9Jx2 - FTx2 - Mk-82HDx6"] = {
				minscore = 0.3,
				support = {
					SEAD = true,
					Escort = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				country = {
					[1] = "USA",
				},
				code_loadout =  { "NAM" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 1600000,
				firepower = 1,
				vCruise = 200,
				vAttack = 350,
				hCruise = 4500,
				hAttack = 200,
				sortie_rate = 6,
				stores = {
					pylons = {
					[1] = {
					["CLSID"] = "{AIM-9J-ON-ADAPTER}",
					["num"] = 5,
				},
				[2] = {
					["CLSID"] = "{AIM-9J-ON-ADAPTER}",
					["num"] = 1,
				},
				[3] = {
					["CLSID"] = "{Mk-82 Snakeye_MER_6_C}",
					["num"] = 3,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_M904E4"] = 4,
						["00_prfx_function_delay_ctrl_M904E4"] = 0,
						["01_prfx_arm_delay_ctrl_M905"] = 4,
						["01_prfx_function_delay_ctrl_M905"] = 0,
						["NFP_PRESID"] = "MDRN_B_A_GPLD",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
					},
				},
				[4] = {
					["CLSID"] = "{DFT-300gal_LR}",
					["num"] = 4,
				},
				[5] = {
					["CLSID"] = "{DFT-300gal_LR}",
					["num"] = 2,
				},
					},
					fuel = 2467.5454273299,
					flare = 30,
					ammo_type = 1,
					chaff = 30,
					gun = 100,
				},
			},
			-- ["NAM - AG - AIM-9Jx2 - FTx2 - Mk-77x2 Napalm"] = {
				-- minscore = 0.3,
				-- support = {
					-- SEAD = true,
					-- Escort = true,
					-- ["Escort Jammer"] = true,
				-- },
				-- attributes =  { "soft", "Parked Aircraft", "SAM" },
				-- country = {
					-- [1] = "USA",
				-- },
				-- code_loadout =  { "NAM" },
				-- weaponType = "Bombs",
				-- expend = "All",
				-- night = true,
				-- adverseWeather = true,
				-- range = 1600000,
				-- firepower = 1,
				-- vCruise = 200,
				-- vAttack = 350,
				-- hCruise = 4500,
				-- hAttack = 200,
				-- sortie_rate = 6,
				-- stores = {
					-- pylons = {
					-- [1] = {
					-- ["CLSID"] = "{AIM-9J-ON-ADAPTER}",
					-- ["num"] = 5,
					-- },
					-- [2] = {
					-- ["CLSID"] = "{AIM-9J-ON-ADAPTER}",
					-- ["num"] = 1,
					-- },
					-- [3] = {
					-- ["CLSID"] = "{Mk-77 mod 1_TER_2_C}",
					-- ["num"] = 3,
					-- ["settings"] = {
						-- ["NFP_PRESID"] = "MDRN_B_A_GPLD",
						-- ["NFP_PRESVER"] = 1,
						-- ["NFP_VIS_DrawArgNo_57"] = 0,
						-- ["NFP_fuze_type_nose"] = "M904E4",
						-- ["NFP_fuze_type_tail"] = "M905",
						-- ["arm_delay_ctrl_M904E4"] = 4,
						-- ["arm_delay_ctrl_M905"] = 4,
						-- ["function_delay_ctrl_M904E4"] = 0,
						-- ["function_delay_ctrl_M905"] = 0,
					-- },
					-- },
					-- [4] = {
					-- ["CLSID"] = "{DFT-300gal_LR}",
					-- ["num"] = 4,
					-- },
					-- [5] = {
					-- ["CLSID"] = "{DFT-300gal_LR}",
					-- ["num"] = 2,
					-- },
					-- },
					-- fuel = 2467.5454273299,
					-- flare = 30,
					-- ammo_type = 1,
					-- chaff = 30,
					-- gun = 100,
				-- },
			-- },
			["NAM - AG - AIM-9Jx2 - FTx2 - Mk-83LDx3"] = {
				minscore = 0.3,
				support = {
					SEAD = true,
					Escort = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "Bridge", "Structure" },
				country = {
					[1] = "USA",
				},
				code_loadout =  { "NAM" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 1600000,
				firepower = 1,
				vCruise = 200,
				vAttack = 350,
				hCruise = 4500,
				hAttack = 4500,
				sortie_rate = 6,
				stores = {
					pylons = {
					[1] = {
					["CLSID"] = "{AIM-9J-ON-ADAPTER}",
					["num"] = 5,
				},
				[2] = {
					["CLSID"] = "{AIM-9J-ON-ADAPTER}",
					["num"] = 1,
				},
				[3] = {
					["CLSID"] = "{Mk-83_TER_3_C}",
					["num"] = 3,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_M904E4"] = 4,
						["00_prfx_function_delay_ctrl_M904E4"] = 0,
						["01_prfx_arm_delay_ctrl_M905"] = 4,
						["01_prfx_function_delay_ctrl_M905"] = 0,
						["NFP_PRESID"] = "MDRN_B_A_GPLD",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
					},
				},
				[4] = {
					["CLSID"] = "{DFT-300gal_LR}",
					["num"] = 4,
				},
				[5] = {
					["CLSID"] = "{DFT-300gal_LR}",
					["num"] = 2,
				},
					},
					fuel = 2467.5454273299,
					flare = 30,
					ammo_type = 1,
					chaff = 30,
					gun = 100,
				},
			},
			["NAM -AG - Mk84LD*1"] = {
				minscore = 0.3,
				support = {
					SEAD = true,
					Escort = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "Bridge", "Structure" },
				country = {
					[1] = "USA",
				},
				code_loadout =  { "NAM" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 1600000,
				firepower = 1,
				vCruise = 200,
				vAttack = 350,
				hCruise = 4500,
				hAttack = 4500,
				sortie_rate = 6,
				stores = {
					pylons = {
					[1] = {
					["CLSID"] = "{AIM-9J-ON-ADAPTER}",
					["num"] = 5,
				},
				[2] = {
					["CLSID"] = "{AIM-9J-ON-ADAPTER}",
					["num"] = 1,
				},
				[3] = {
					["CLSID"] = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
					["num"] = 3,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_M904E4"] = 4,
						["00_prfx_function_delay_ctrl_M904E4"] = 0,
						["01_prfx_arm_delay_ctrl_M905"] = 4,
						["01_prfx_function_delay_ctrl_M905"] = 0,
						["NFP_PRESID"] = "MDRN_B_A_GPLD",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
					},
				},
				[4] = {
					["CLSID"] = "{DFT-300gal_LR}",
					["num"] = 4,
				},
				[5] = {
					["CLSID"] = "{DFT-300gal_LR}",
					["num"] = 2,
				},
					},
					fuel = 2467.5454273299,
					flare = 30,
					ammo_type = 1,
					chaff = 30,
					gun = 100,
				},
			},
			["NAM - AG - AIM-9Jx2 - FT - LAU-10x3"] = {
				minscore = 0.3,
				support = {
					SEAD = true,
					Escort = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				country = {
					[1] = "USA",
				},
				code_loadout =  { "NAM" },
				weaponType = "rockets",
				expend = "All",
				night = true,
				range = 600000,
				firepower = 0.5,
				vCruise = 200,
				vAttack = 350,
				hCruise = 4500,
				hAttack = 4500,
				LDSD = true,
				sortie_rate = 8,
				stores = {
					pylons = {
					[1] = {
					["CLSID"] = "{AIM-9J-ON-ADAPTER}",
					["num"] = 5,
				},
				[2] = {
					["CLSID"] = "{AIM-9J-ON-ADAPTER}",
					["num"] = 1,
				},
				[3] = {
					["CLSID"] = "{LAU-10 ZUNI_TER_3_C}",
					["num"] = 3,
				},
				[4] = {
					["CLSID"] = "{DFT-300gal_LR}",
					["num"] = 4,
				},
				[5] = {
					["CLSID"] = "{DFT-150gal}",
					["num"] = 2,
				},
					},
					fuel = 2467.5454273299,
					flare = 30,
					ammo_type = 1,
					chaff = 30,
					gun = 100,
				},
			},
			["NAM -AG - LAU-3*3"] = {
				minscore = 0.3,
				support = {
					SEAD = true,
					Escort = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				country = {
					[1] = "USA",
				},
				code_loadout =  { "NAM" },
				weaponType = "rockets",
				expend = "All",
				night = true,
				range = 600000,
				firepower = 1,
				vCruise = 200,
				vAttack = 350,
				hCruise = 4500,
				hAttack = 4500,
				LDSD = true,
				sortie_rate = 8,
				stores = {
					pylons = {
					[1] = {
					["CLSID"] = "{AIM-9J-ON-ADAPTER}",
					["num"] = 5,
				},
				[2] = {
					["CLSID"] = "{AIM-9J-ON-ADAPTER}",
					["num"] = 1,
				},
				[3] = {
					["CLSID"] = "{LAU-3 FFAR Mk1 HE_TER_3_C}",
					["num"] = 3,
				},
				[4] = {
					["CLSID"] = "{DFT-300gal_LR}",
					["num"] = 4,
				},
				[5] = {
					["CLSID"] = "{DFT-300gal_LR}",
					["num"] = 2,
				},
					},
					fuel = 2467.5454273299,
					flare = 30,
					ammo_type = 1,
					chaff = 30,
					gun = 100,
				},
			},
		},
	},
	["MirageF1"] = {
		Strike = {
			["Strike Belouga*4, Magic*2, FT"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft" },
				code_loadout =  { "IIW" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
								range = 400000,
				firepower = 1,
				vCruise = 250,
				vAttack = 300,
				hCruise = 5500,
				hAttack = 4000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
						[3] = {
							CLSID = "{M2KC_RAFAUT_BLG66}",
						},
						[4] = {
							CLSID = "{RP_35_F1}",
						},
						[5] = {
							CLSID = "{M2KC_RAFAUT_BLG66}",
						},
						[7] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
					},
					fuel = 4530,
					flare = 50,
					chaff = 50,
					gun = 100,
				},
			},
			["Strike Rockets*2, Magic*2, FT"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "IIW" },
				weaponType = "Rockets",
				expend = "All",
				attackType = "Dive",
								range = 400000,
				firepower = 1,
				vCruise = 250,
				vAttack = 300,
				hCruise = 5500,
				hAttack = 4000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
						[3] = {
							CLSID = "{Matra155RocketPod}",
						},
						[4] = {
							CLSID = "{RP_35_F1}",
						},
						[5] = {
							CLSID = "{Matra155RocketPod}",
						},
						[7] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
					},
					fuel = 4530,
					flare = 50,
					chaff = 50,
					gun = 100,
				},
			},
			["Strike Mk-83*2, Magic*2, FT"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Structure" },
				code_loadout =  { "IIW" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
				night = true,
				adverseWeather = true,
				range = 400000,
				firepower = 1,
				vCruise = 250,
				vAttack = 300,
				hCruise = 5500,
				hAttack = 4000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
						[3] = {
							CLSID = "{7A44FF09-527C-4B7E-B42B-3F111CFE50FB}",
						},
						[4] = {
							CLSID = "{RP_35_F1}",
						},
						[5] = {
							CLSID = "{7A44FF09-527C-4B7E-B42B-3F111CFE50FB}",
						},
						[7] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
					},
					fuel = 4530,
					flare = 50,
					chaff = 50,
					gun = 100,
				},
			},
			["Strike Mk82*4, Magic *2, FT"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "Structure" },
				code_loadout =  { "IIW" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
								range = 400000,
				firepower = 1,
				vCruise = 250,
				vAttack = 300,
				hCruise = 5500,
				hAttack = 4000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
						[3] = {
							CLSID = "{M2KC_RAFAUT_MK82}",
						},
						[4] = {
							CLSID = "{RP_35_F1}",
						},
						[5] = {
							CLSID = "{M2KC_RAFAUT_MK82}",
						},
						[7] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
					},
					fuel = 4530,
					flare = 50,
					chaff = 50,
					gun = 100,
				},
			},
		},
		["Fighter Sweep"] = {
			["MagicII*2, S-530D*2, FT*1"] = {
				attributes =  { },
				code_loadout =  { "IIW" },
				night = true,
				adverseWeather = true,
				range = 360000,
				firepower = 1,
				vCruise = 245,
				vAttack = 245,
				hCruise = 7011,
				hAttack = 7011,
				standoff = 27000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
						[3] = {
							CLSID = "{FD21B13E-57F3-4C2A-9F78-C522D0B5BCE1}",
						},
						[4] = {
							CLSID = "{RP_35_F1}",
						},
						[5] = {
							CLSID = "{FD21B13E-57F3-4C2A-9F78-C522D0B5BCE1}",
						},
						[7] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
					},
					fuel = 4530,
					flare = 50,
					chaff = 50,
					gun = 100,
				},
			},
		},
		Escort = {
			["MagicII*2, S-530D*2, FT*1"] = {
				attributes =  { },
				code_loadout =  { "IIW" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 270,
				standoff = 27000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
						[3] = {
							CLSID = "{FD21B13E-57F3-4C2A-9F78-C522D0B5BCE1}",
						},
						[4] = {
							CLSID = "{RP_35_F1}",
						},
						[5] = {
							CLSID = "{FD21B13E-57F3-4C2A-9F78-C522D0B5BCE1}",
						},
						[7] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
					},
					fuel = 4530,
					flare = 50,
					chaff = 50,
					gun = 100,
				},
			},
		},
		CAP = {
			["Day, MagicII*2, S-530D*2, FT*1"] = {
				attributes =  { },
				code_loadout =  { "IIW" },
				adverseWeather = true,
				range = 250000,
				firepower = 1,
				vCruise = 245,
				vAttack = 246.66666666667,
				hCruise = 6096,
				hAttack = 6096,
				standoff = 36000,
				tStation = 1800,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
						[3] = {
							CLSID = "{FD21B13E-57F3-4C2A-9F78-C522D0B5BCE1}",
						},
						[4] = {
							CLSID = "{RP_35_F1}",
						},
						[5] = {
							CLSID = "{FD21B13E-57F3-4C2A-9F78-C522D0B5BCE1}",
						},
						[7] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
					},
					fuel = 4530,
					flare = 50,
					chaff = 50,
					gun = 100,
				},
			},
		},
		Intercept = {
			["Day, MagicII*2, S-530D*2, FT*1"] = {
				attributes =  { },
				code_loadout =  { "IIW" },
				adverseWeather = true,
				range = 400000,
				firepower = 1,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
						[3] = {
							CLSID = "{FD21B13E-57F3-4C2A-9F78-C522D0B5BCE1}",
						},
						[4] = {
							CLSID = "{RP_35_F1}",
						},
						[5] = {
							CLSID = "{FD21B13E-57F3-4C2A-9F78-C522D0B5BCE1}",
						},
						[7] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
					},
					fuel = 4530,
					flare = 50,
					chaff = 50,
					gun = 100,
				},
			},
		},
	},
	["H-6J"] = {             --payload edited by JG1_BAMSE --   Tu-16 Badger like 
		["Strike"] = {					
			["IN Strike bmb hrd"] = {
				minscore = 0.1,
				support = {
					["Escort"] = true,
					["SEAD"] = true,
				},
				attributes = {"soft", "Parked Aircraft", "SAM", "frontline", "Structure", "Bridge"},
				code_loadout =  {"All"},
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 1000000,
				capability = 9,
				firepower = 1,
				vCruise = 250,
				vAttack = 300,
				hCruise = 9096,
				hAttack = 9096,
				standoff = nil,
				tStation = nil,
				LDSD = false,
				self_escort = false,
				sortie_rate = 6,
				stores = {
			["pylons"] = {
				[8] = {
					["CLSID"] = "DIS_H6_250_2_N24",
					["num"] = 8,
				},
			},
				["fuel"] = "25000",
				["flare"] = 1000,
				["chaff"] = 1000,
				["gun"] = 100,
				},
			},						
			["Strike bmb hrd"] = {
				minscore = 0.1,
				support = {
					["Escort"] = true,
					["SEAD"] = true,
				},
				attributes = {"Structure", "Bridge", "Base"},
				code_loadout =  {"All"},
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 1000000,
				capability = 9,
				firepower = 1,
				vCruise = 250,
				vAttack = 300,
				hCruise = 9096,
				hAttack = 9096,
				standoff = nil,
				tStation = nil,
				LDSD = false,
				self_escort = false,
				sortie_rate = 6,
				stores = {
			["pylons"] = {
				[6] = {
					["CLSID"] = "DIS_MER6_250_3_N6",
					["num"] = 6,
				},
				[5] = {
					["CLSID"] = "DIS_MER6_250_3_N6",
					["num"] = 5,
				},
				[4] = {
					["CLSID"] = "DIS_MER6_250_3_N6",
					["num"] = 4,
				},
				[3] = {
					["CLSID"] = "DIS_MER6_250_3_N6",
					["num"] = 3,
				},
				[2] = {
					["CLSID"] = "DIS_MER6_250_3_N6",
					["num"] = 2,
				},
				[1] = {
					["CLSID"] = "DIS_MER6_250_3_N6",
					["num"] = 1,
				},
			},
				["fuel"] = "25000",
				["flare"] = 1000,
				["chaff"] = 1000,
				["gun"] = 100,
				},
			},											
		},
        ["Transport"] = {
			["Empty"] = {
				attributes = {},
				code_loadout =  {"All"},
				weaponType = nil,
				expend = nil,
				night = true,
				adverseWeather = true,
				range = 3000000,
				capability = 9,
				firepower = 1,
				vCruise = 255,
				vAttack = 255,
				hCruise = 9000,
				hAttack = 9000,
				standoff = nil,
				tStation = nil,
				LDSD = false,
				--- self_escort = false,
				sortie_rate = 6,
				stores = {
			["pylons"] = {
			},
				["fuel"] = "25000",
				["flare"] = 1000,
				["chaff"] = 1000,
				["gun"] = 100,
				},
			},
		},	
	},
	["UH-60L"] = {
		CSAR = {
			["CSAR test"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 65,
				vAttack = 75,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "<CLEAN>",
						},
						[2] = {
							CLSID = "<CLEAN>",
						},
						[3] = {
							CLSID = "{UH60_SEAT_GUNNER_L}",
						},
						[4] = {
							CLSID = "{UH60_SEAT_CARGO_REAR}",
						},
						[5] = {
							CLSID = "{UH60_SEAT_GUNNER_R}",
						},
						[6] = {
							CLSID = "<CLEAN>",
						},
						[7] = {
							CLSID = "<CLEAN>",
						},
					},
					fuel = 1362,
					flare = 60,
					chaff = 30,
					gun = 100,
				},
				AddPropAircraft = {
					FuelProbeEnabled = true,
					NetCrewControlPriority = 1,
				},
			},
		},
		SAR = {
			["SAR test"] = {
				minscore = 0.3,
				support = {
				},
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 65,
				vAttack = 75,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "<CLEAN>",
						},
						[2] = {
							CLSID = "<CLEAN>",
						},
						[3] = {
							CLSID = "{UH60_SEAT_GUNNER_L}",
						},
						[4] = {
							CLSID = "{UH60_SEAT_CARGO_REAR}",
						},
						[5] = {
							CLSID = "{UH60_SEAT_GUNNER_R}",
						},
						[6] = {
							CLSID = "<CLEAN>",
						},
						[7] = {
							CLSID = "<CLEAN>",
						},
					},
					fuel = 1362,
					flare = 60,
					chaff = 30,
					gun = 100,
				},
				AddPropAircraft = {
					FuelProbeEnabled = true,
					NetCrewControlPriority = 1,
				},
			},
		},
		Transport = {
			Default = {
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 65,
				vAttack = 75,
				hCruise = 100,
				hAttack = 100,
				sortie_rate = 5,
				stores = {
					pylons = {
						[1] = {
							CLSID = "<CLEAN>",
						},
						[2] = {
							CLSID = "<CLEAN>",
						},
						[3] = {
							CLSID = "{UH60_SEAT_GUNNER_L}",
						},
						[4] = {
							CLSID = "{UH60_SEAT_CARGO_REAR}",
						},
						[5] = {
							CLSID = "{UH60_SEAT_GUNNER_R}",
						},
						[6] = {
							CLSID = "<CLEAN>",
						},
						[7] = {
							CLSID = "<CLEAN>",
						},
					},
					fuel = 1362,
					flare = 60,
					chaff = 30,
					gun = 100,
				},
			},
		},
	},
	["vwv_ch46d"] = {
		CSAR = {
			["CSAR test"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 75,
				vAttack = 80,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
					},
					fuel = 3100,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		SAR = {
			["SAR test"] = {
				minscore = 0.3,
				support = {
				},
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 75,
				vAttack = 80,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
					},
					fuel = 3100,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		Transport = {
			Default = {
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 75,
				vAttack = 80,
				hCruise = 100,
				hAttack = 100,
				sortie_rate = 5,
				stores = {
					pylons = {
					},
					fuel = 3100,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
	},
	["vwv_uh2a"] = {
		CSAR = {
			["CSAR uh2a"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 40,
				vAttack = 40,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
					[1] = 
					{
					["CLSID"] = "{UH2A_FUEL_TANK_120R}",
					}, -- end of [1]
					[2] = 
					{
					["CLSID"] = "{UH2A_FUEL_TANK_120L}",
					}, -- end of [2]
					},
					fuel = 631,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		SAR = {
			["SAR uh2a"] = {
				minscore = 0.3,
				support = {
				},
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 40,
				vAttack = 40,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
					[1] = 
					{
					["CLSID"] = "{UH2A_FUEL_TANK_120R}",
					}, -- end of [1]
					[2] = 
					{
					["CLSID"] = "{UH2A_FUEL_TANK_120L}",
					}, -- end of [2]
					},
					fuel = 631,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		Transport = {
			["Transport uh2a"] = {
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { },
				code_loadout =  { "All" },
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 40,
				vAttack = 40,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
					[1] = 
					{
					["CLSID"] = "{UH2A_FUEL_TANK_120R}",
					}, -- end of [1]
					[2] = 
					{
					["CLSID"] = "{UH2A_FUEL_TANK_120L}",
					}, -- end of [2]
					},
					fuel = 631,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
	},
	["vwv_uh2b"] = {
		CSAR = {
			["CSAR uh2b"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 40,
				vAttack = 40,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
					[1] = 
					{
					["CLSID"] = "{UH2B_FUEL_TANK_120R}",
					}, -- end of [1]
					[2] = 
					{
					["CLSID"] = "{UH2B_FUEL_TANK_120L}",
					}, -- end of [2]
					},
					fuel = 631,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		SAR = {
			["SAR uh2b"] = {
				minscore = 0.3,
				support = {
				},
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 40,
				vAttack = 40,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
					[1] = 
					{
					["CLSID"] = "{UH2B_FUEL_TANK_120R}",
					}, -- end of [1]
					[2] = 
					{
					["CLSID"] = "{UH2B_FUEL_TANK_120L}",
					}, -- end of [2]
					},
					fuel = 631,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		Transport = {
			["Transport uh2b"] = {
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { },
				code_loadout =  { "All" },
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 40,
				vAttack = 40,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
					[1] = 
					{
					["CLSID"] = "{UH2B_FUEL_TANK_120R}",
					}, -- end of [1]
					[2] = 
					{
					["CLSID"] = "{UH2B_FUEL_TANK_120L}",
					}, -- end of [2]
					},
					fuel = 631,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
	},
	["vwv_uh2c"] = {
		CSAR = {
			["CSAR uh2c"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 40,
				vAttack = 40,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
					[1] = 
					{
					["CLSID"] = "{UH2C_FUEL_TANK_120R}",
					}, -- end of [1]
					[2] = 
					{
					["CLSID"] = "{UH2C_FUEL_TANK_120L}",
					}, -- end of [2]
					},
					fuel = 631,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		SAR = {
			["SAR uh2c"] = {
				minscore = 0.3,
				support = {
				},
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 40,
				vAttack = 40,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
					[1] = 
					{
					["CLSID"] = "{UH2C_FUEL_TANK_120R}",
					}, -- end of [1]
					[2] = 
					{
					["CLSID"] = "{UH2C_FUEL_TANK_120L}",
					}, -- end of [2]
					},
					fuel = 631,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		Transport = {
			["Transport uh2c"] = {
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { },
				code_loadout =  { "All" },
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 40,
				vAttack = 40,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
					[1] = 
					{
					["CLSID"] = "{UH2C_FUEL_TANK_120R}",
					}, -- end of [1]
					[2] = 
					{
					["CLSID"] = "{UH2C_FUEL_TANK_120L}",
					}, -- end of [2]
					},
					fuel = 631,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
	},
	["vwv_hh2d"] = {
		CSAR = {
			["CSAR HH-2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 40,
				vAttack = 40,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
					[1] = {
					["CLSID"] = "ab-212_cable",
					["num"] = 5,
					},
					},
					fuel = 1100,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		SAR = {
			["SAR HH-2"] = {
				minscore = 0.3,
				support = {
				},
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 40,
				vAttack = 40,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
					[1] = {
					["CLSID"] = "ab-212_cable",
					["num"] = 5,
					},
					},
					fuel = 1100,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		Transport = {
			Default = {
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { },
				code_loadout =  { "All" },
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 40,
				vAttack = 40,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
					},
					fuel = 1100,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
	},
	["vwv_sh2f"] = {
		CSAR = {
			["CSAR SH-2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 40,
				vAttack = 40,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
					},
					fuel = 1100,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		SAR = {
			["SAR SH-2"] = {
				minscore = 0.3,
				support = {
				},
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 40,
				vAttack = 40,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
					},
					fuel = 1100,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		Transport = {
			["transport SH-2"] = {
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { },
				code_loadout =  { "All" },
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 40,
				vAttack = 40,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
					},
					fuel = 1100,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
	},
	["SH-3D"] = {
		Transport = {
			["transport SH-3D"] = {
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { },
				code_loadout =  { "All" },
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 40,
				vAttack = 40,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
					},
					uel = 1157,
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
		},	
		["Anti-ship Strike"] = {
			["Antiship - Penguinx2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "ship" },
				code_loadout =  { "All" },
				weaponType = "ASM",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 40,
				vAttack = 40,
				hCruise = 500,
				hAttack = 50,
				standoff = 15000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{7B8DCEB4-820B-4015-9B48-1028A4195692}",
						},
						[4] = {
							CLSID = "{7B8DCEB4-820B-4015-9B48-1028A4195692}",
						},
					},
					fuel = 1157,
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
			["Antiship - Sea Eaglex2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "ship" },
				code_loadout =  { "All" },
				weaponType = "ASM",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 40,
				vAttack = 40,
				hCruise = 500,
				hAttack = 50,
				standoff = 50000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{1461CD18-429A-42A9-A21F-4C621ECD4573}",
						},
						[4] = {
							CLSID = "{1461CD18-429A-42A9-A21F-4C621ECD4573}",
						},
					},
					fuel = 1157,
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
		},
		CSAR = {
			["CSAR test"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 40,
				vAttack = 40,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
					},
					fuel = 1157,
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
		},
		SAR = {
			["SAR test"] = {
				minscore = 0.3,
				support = {
				},
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 40,
				vAttack = 40,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
					},
					fuel = 1157,
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
		},
	},
	["OH-6A"] = {
		Strike = {
			["NAM - AG - Minigun - Door gunner"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				country = {
					[1] = "USA",
				},
				attributes =  { "soft" },
				code_loadout =  { "All" },
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 55,
				vAttack = 60,
				hCruise = 50,
				hAttack = 50,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{OH6_SMOKE_YELLOW}",
					["num"] = 1,
				},
				[2] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 7,
				},
				[3] = {
					["CLSID"] = "{OH6_FRAG}",
					["num"] = 5,
				},
				[4] = {
					["CLSID"] = "{OH6_SMOKE_BLUE}",
					["num"] = 4,
				},
				[5] = {
					["CLSID"] = "{OH6_SMOKE_GREEN}",
					["num"] = 3,
				},
				[6] = {
					["CLSID"] = "{OH6_SMOKE_RED}",
					["num"] = 2,
				},
				[7] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 6,
				},
				[8] = {
					["CLSID"] = "{OH-6 M60 Door}",
					["num"] = 11,
				},
				[9] = {
					["CLSID"] = "{OH-6 M134 Minigun}",
					["num"] = 8,
				},
					},
					fuel = 181,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		CSAR = {
			["NAM - CSAR - Minigun - Door gunner"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				country = {
					[1] = "USA",
				},
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 55,
				vAttack = 60,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{OH6_SMOKE_YELLOW}",
					["num"] = 1,
				},
				[2] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 7,
				},
				[3] = {
					["CLSID"] = "{OH6_FRAG}",
					["num"] = 5,
				},
				[4] = {
					["CLSID"] = "{OH6_SMOKE_BLUE}",
					["num"] = 4,
				},
				[5] = {
					["CLSID"] = "{OH6_SMOKE_GREEN}",
					["num"] = 3,
				},
				[6] = {
					["CLSID"] = "{OH6_SMOKE_RED}",
					["num"] = 2,
				},
				[7] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 6,
				},
				[8] = {
					["CLSID"] = "{OH-6 M60 Door}",
					["num"] = 11,
				},
				[9] = {
					["CLSID"] = "{OH-6 M134 Minigun}",
					["num"] = 8,
				},
					},
					fuel = 181,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		SAR = {
			["NAM - SAR - Minigun - Door gunner"] = {
				minscore = 0.3,
				support = {
				},
				country = {
					[1] = "USA",
				},
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 55,
				vAttack = 60,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{OH6_SMOKE_YELLOW}",
					["num"] = 1,
				},
				[2] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 7,
				},
				[3] = {
					["CLSID"] = "{OH6_FRAG}",
					["num"] = 5,
				},
				[4] = {
					["CLSID"] = "{OH6_SMOKE_BLUE}",
					["num"] = 4,
				},
				[5] = {
					["CLSID"] = "{OH6_SMOKE_GREEN}",
					["num"] = 3,
				},
				[6] = {
					["CLSID"] = "{OH6_SMOKE_RED}",
					["num"] = 2,
				},
				[7] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 6,
				},
				[8] = {
					["CLSID"] = "{OH-6 M60 Door}",
					["num"] = 11,
				},
				[9] = {
					["CLSID"] = "{OH-6 M134 Minigun}",
					["num"] = 8,
				},
					},
					fuel = 181,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		Transport = {
			["NAM - Transport - Minigun - Door gunner"] = {
				support = {
					Escort = true,
					SEAD = false,
				},
				country = {
					[1] = "USA",
				},
				attributes =  { },
				code_loadout =  { "All" },
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 55,
				vAttack = 60,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{OH6_SMOKE_YELLOW}",
					["num"] = 1,
				},
				[2] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 7,
				},
				[3] = {
					["CLSID"] = "{OH6_FRAG}",
					["num"] = 5,
				},
				[4] = {
					["CLSID"] = "{OH6_SMOKE_BLUE}",
					["num"] = 4,
				},
				[5] = {
					["CLSID"] = "{OH6_SMOKE_GREEN}",
					["num"] = 3,
				},
				[6] = {
					["CLSID"] = "{OH6_SMOKE_RED}",
					["num"] = 2,
				},
				[7] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 6,
				},
				[8] = {
					["CLSID"] = "{OH-6 M60 Door}",
					["num"] = 11,
				},
				[9] = {
					["CLSID"] = "{OH-6 M134 Minigun}",
					["num"] = 8,
				},
					},
					fuel = 181,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
	},
	["F111C"] = {		
		Strike = {
			["NAM AG Low"] = {
				minscore = 0.3,
				support = {
					SEAD = true,
					Escort = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "Structure", "Bridge" },
				code_loadout =  { "All" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 1000000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 500,
				hAttack = 200,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
					["CLSID"] = "{F111C_ELINT}",
					["num"] = 12,
				},
				[2] = {
					["CLSID"] = "{F111C_FLIR}",
					["num"] = 11,
				},
				[3] = {
					["CLSID"] = "{TER_9A_3*MK-82_Snakeye}",
					["num"] = 9,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_M904E4"] = 4,
						["00_prfx_function_delay_ctrl_M904E4"] = 0,
						["01_prfx_arm_delay_ctrl_M905"] = 4,
						["01_prfx_function_delay_ctrl_M905"] = 0,
						["NFP_PRESID"] = "MDRN_B_A",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
					},
				},
				[4] = {
					["CLSID"] = "{TER_9A_3*MK-82_Snakeye}",
					["num"] = 8,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_M904E4"] = 4,
						["00_prfx_function_delay_ctrl_M904E4"] = 0,
						["01_prfx_arm_delay_ctrl_M905"] = 4,
						["01_prfx_function_delay_ctrl_M905"] = 0,
						["NFP_PRESID"] = "MDRN_B_A",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
					},
				},
				[5] = {
					["CLSID"] = "{TER_9A_3*MK-82_Snakeye}",
					["num"] = 5,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_M904E4"] = 4,
						["00_prfx_function_delay_ctrl_M904E4"] = 0,
						["01_prfx_arm_delay_ctrl_M905"] = 4,
						["01_prfx_function_delay_ctrl_M905"] = 0,
						["NFP_PRESID"] = "MDRN_B_A",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
					},
				},
				[6] = {
					["CLSID"] = "{TER_9A_3*MK-82_Snakeye}",
					["num"] = 4,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_M904E4"] = 4,
						["00_prfx_function_delay_ctrl_M904E4"] = 0,
						["01_prfx_arm_delay_ctrl_M905"] = 4,
						["01_prfx_function_delay_ctrl_M905"] = 0,
						["NFP_PRESID"] = "MDRN_B_A",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
					},
				},
					},
					fuel = 14860,
					flare = 100,
					chaff = 100,
					gun = 100,
				},
			},
			["NAM AG High"] = {
				minscore = 0.3,
				support = {
					SEAD = true,
					Escort = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "Bridge" },
				code_loadout =  { "All" },
				weaponType = "Bombs",
				expend = "All",
								range = 500000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7800,
				hAttack = 5000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
					["CLSID"] = "{F111C_ELINT}",
					["num"] = 12,
				},
				[2] = {
					["CLSID"] = "{F111C_FLIR}",
					["num"] = 11,
				},
				[3] = {
					["CLSID"] = "{BRU41_6X_MK-82}",
					["num"] = 9,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_M904E4"] = 4,
						["00_prfx_function_delay_ctrl_M904E4"] = 0,
						["01_prfx_arm_delay_ctrl_M905"] = 4,
						["01_prfx_function_delay_ctrl_M905"] = 0,
						["NFP_PRESID"] = "MDRN_B_A",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
					},
				},
				[4] = {
					["CLSID"] = "{BRU41_6X_MK-82}",
					["num"] = 8,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_M904E4"] = 4,
						["00_prfx_function_delay_ctrl_M904E4"] = 0,
						["01_prfx_arm_delay_ctrl_M905"] = 4,
						["01_prfx_function_delay_ctrl_M905"] = 0,
						["NFP_PRESID"] = "MDRN_B_A",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
					},
				},
				[5] = {
					["CLSID"] = "{BRU41_6X_MK-82}",
					["num"] = 5,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_M904E4"] = 4,
						["00_prfx_function_delay_ctrl_M904E4"] = 0,
						["01_prfx_arm_delay_ctrl_M905"] = 4,
						["01_prfx_function_delay_ctrl_M905"] = 0,
						["NFP_PRESID"] = "MDRN_B_A",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
					},
				},
				[6] = {
					["CLSID"] = "{BRU41_6X_MK-82}",
					["num"] = 4,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_M904E4"] = 4,
						["00_prfx_function_delay_ctrl_M904E4"] = 0,
						["01_prfx_arm_delay_ctrl_M905"] = 4,
						["01_prfx_function_delay_ctrl_M905"] = 0,
						["NFP_PRESID"] = "MDRN_B_A",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
					},
				},
					},
					fuel = 14860,
					flare = 100,
					chaff = 100,
					gun = 100,
				},
			},
			["NAM AG High heavy"] = {
				minscore = 0.3,
				support = {
					SEAD = true,
					Escort = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "Structure", "Bridge" },
				code_loadout =  { "All" },
				weaponType = "Bombs",
				expend = "All",
								range = 1000000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7800,
				hAttack = 6000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
					["CLSID"] = "{F111C_ELINT}",
					["num"] = 12,
				},
				[2] = {
					["CLSID"] = "{F111C_FLIR}",
					["num"] = 11,
				},
				[3] = {
					["CLSID"] = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
					["num"] = 9,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_M904E4"] = 4,
						["00_prfx_function_delay_ctrl_M904E4"] = 0,
						["01_prfx_arm_delay_ctrl_M905"] = 4,
						["01_prfx_function_delay_ctrl_M905"] = 0,
						["NFP_PRESID"] = "MDRN_B_A",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
					},
				},
				[4] = {
					["CLSID"] = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
					["num"] = 8,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_M904E4"] = 4,
						["00_prfx_function_delay_ctrl_M904E4"] = 0,
						["01_prfx_arm_delay_ctrl_M905"] = 4,
						["01_prfx_function_delay_ctrl_M905"] = 0,
						["NFP_PRESID"] = "MDRN_B_A",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
					},
				},
				[5] = {
					["CLSID"] = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
					["num"] = 5,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_M904E4"] = 4,
						["00_prfx_function_delay_ctrl_M904E4"] = 0,
						["01_prfx_arm_delay_ctrl_M905"] = 4,
						["01_prfx_function_delay_ctrl_M905"] = 0,
						["NFP_PRESID"] = "MDRN_B_A",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
					},
				},
				[6] = {
					["CLSID"] = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
					["num"] = 4,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_M904E4"] = 4,
						["00_prfx_function_delay_ctrl_M904E4"] = 0,
						["01_prfx_arm_delay_ctrl_M905"] = 4,
						["01_prfx_function_delay_ctrl_M905"] = 0,
						["NFP_PRESID"] = "MDRN_B_A",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
					},
				},
					},
					fuel = 14860,
					flare = 100,
					chaff = 100,
					gun = 100,
				},
			},
		},
	},	
	["VSN_F104C"] = {
		CAP = {
			["NAM - AA CAP - AIM-9B*2 - FT*4"] = {
				country = {
					[1] = "USA",
				},
				attributes =  {  },
				code_loadout =  { "NAM" },
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1.5,
				vCruise = 245,
				vAttack = 246.66666666667,
				hCruise = 6096,
				hAttack = 6096,
				standoff = 2000,
				tStation = 1800,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "VSN_F104C_RC_PTB",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "VSN_F104C_LC_PTB",
					["num"] = 2,
				},
				[3] = {
					["CLSID"] = "VSN_F104C_PTB",
					["num"] = 8,
				},
				[4] = {
					["CLSID"] = "VSN_F104C_PTB",
					["num"] = 4,
				},
				[5] = {
					["CLSID"] = "{AIM-9B}",
					["num"] = 7,
				},
				[6] = {
					["CLSID"] = "{AIM-9B}",
					["num"] = 5,
				},
					},
					fuel = 2644,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},	
		Escort = {	
			["NAM - AA Escort - AIM-9B*2 - FT*4"] = {
				country = {
					[1] = "USA",
				},
				attributes =  { },
				code_loadout =  { "NAM" },
				night = true,
				adverseWeather = true,
				range = 800000,
				firepower = 2,
				vCruise = 255,
				standoff = 46300,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "VSN_F104C_RC_PTB",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "VSN_F104C_LC_PTB",
					["num"] = 2,
				},
				[3] = {
					["CLSID"] = "VSN_F104C_PTB",
					["num"] = 8,
				},
				[4] = {
					["CLSID"] = "VSN_F104C_PTB",
					["num"] = 4,
				},
				[5] = {
					["CLSID"] = "{AIM-9B}",
					["num"] = 7,
				},
				[6] = {
					["CLSID"] = "{AIM-9B}",
					["num"] = 5,
				},
					},
					fuel = 2644,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		Intercept = {
			["NAM - AA Intercept - AIM-9B*2 - FT*4"] = {
				country = {
					[1] = "USA",
				},
				attributes =  { },
				code_loadout =  { "NAM" },
				night = true,
				adverseWeather = true,
				range = 400000,
				firepower = 1,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "VSN_F104C_RC_PTB",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "VSN_F104C_LC_PTB",
					["num"] = 2,
				},
				[3] = {
					["CLSID"] = "VSN_F104C_PTB",
					["num"] = 8,
				},
				[4] = {
					["CLSID"] = "VSN_F104C_PTB",
					["num"] = 4,
				},
				[5] = {
					["CLSID"] = "{AIM-9B}",
					["num"] = 7,
				},
				[6] = {
					["CLSID"] = "{AIM-9B}",
					["num"] = 5,
				},
					},
					fuel = 2644,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		Strike = {
			["NAM - AG  - AIM-9B*2 - FT*2 - M117LD*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				country = {
					[1] = "USA",
				},
				attributes =  { "Bridge", "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "NAM" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
				range = 500000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 5486.4,
				hAttack = 4572,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "VSN_F104C_RC_PTB",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "VSN_F104C_LC_PTB",
					["num"] = 2,
				},
				[3] = {
					["CLSID"] = "{00F5DAC4-0466-4122-998F-B1A298E34113}",
					["num"] = 8,
				},
				[4] = {
					["CLSID"] = "{00F5DAC4-0466-4122-998F-B1A298E34113}",
					["num"] = 4,
				},
				[5] = {
					["CLSID"] = "{AIM-9B}",
					["num"] = 7,
				},
				[6] = {
					["CLSID"] = "{AIM-9B}",
					["num"] = 5,
				},
					},
					fuel = 2644,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
	},		
	["VSN_F4B"] = {
		Strike = {
			["NAM - AG High alt - FT*2 - AIM-7E-2*4 - AIM-9J*4 - Mk-82LD*6"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				country = {
					[1] = "USA",
				},
				attributes =  { "Bridge", "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "NAM" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
				range = 500000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 5486.4,
				hAttack = 4572,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "VSN_F4ER_PTB",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "VSN_F4EL_PTB",
					["num"] = 2,
				},
				[3] = {
					["CLSID"] = "{BRU41_6X_MK-82}",
					["num"] = 6,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_M904E4"] = 4,
						["00_prfx_function_delay_ctrl_M904E4"] = 0,
						["01_prfx_arm_delay_ctrl_M905"] = 4,
						["01_prfx_function_delay_ctrl_M905"] = 0,
						["NFP_PRESID"] = "MDRN_B_A_GPLD",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
					},
				},
				[4] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 7,
				},
				[5] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 8,
				},
				[6] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 5,
				},
				[7] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 4,
				},
				[8] = {
					["CLSID"] = "{VSN_F4B_LAU105_AIM9J}",
					["num"] = 3,
				},
				[9] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 11,
				},
				[10] = {
					["CLSID"] = "{VSN_F4B_LAU105_AIM9J}",
					["num"] = 9,
				},
				[11] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 12,
				},
					},
					fuel = 6416,
					flare = 48,
					chaff = 48,
					gun = 100,
				},
			},
			["NAM - AG High alt - FT*3 - AIM-7E-2*4 - Mk-84LD*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				country = {
					[1] = "USA",
				},
				attributes =  { "Bridge", "Structure" },
				code_loadout =  { "NAM" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
				range = 600000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 5486.4,
				hAttack = 4572,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "VSN_F4ER_PTB",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "VSN_F4EL_PTB",
					["num"] = 2,
				},
				[3] = {
					["CLSID"] = "{BRU41_6X_MK-82}",
					["num"] = 6,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_M904E4"] = 4,
						["00_prfx_function_delay_ctrl_M904E4"] = 0,
						["01_prfx_arm_delay_ctrl_M905"] = 4,
						["01_prfx_function_delay_ctrl_M905"] = 0,
						["NFP_PRESID"] = "MDRN_B_A_GPLD",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
					},
				},
				[4] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 7,
				},
				[5] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 8,
				},
				[6] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 5,
				},
				[7] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 4,
				},
				[8] = {
					["CLSID"] = "{VSN_F4B_LAU105_AIM9J}",
					["num"] = 3,
				},
				[9] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 11,
				},
				[10] = {
					["CLSID"] = "{VSN_F4B_LAU105_AIM9J}",
					["num"] = 9,
				},
				[11] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 12,
				},
					},
					fuel = 6416,
					flare = 48,
					chaff = 48,
					gun = 100,
				},
			},
			["NAM - AG Low alt - FT*2 - AIM-7E-2*4 - AIM-9J*4 - Mk-82HD*6"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				country = {
					[1] = "USA",
				},
				attributes =  { "Bridge", "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "NAM" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 9100,
				hAttack = 200,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "VSN_F4ER_PTB",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "VSN_F4EL_PTB",
					["num"] = 2,
				},
				[3] = {
					["CLSID"] = "{HB_F4E_MK-82_Snakeye_6x}",
					["num"] = 6,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_M904E4"] = 4,
						["00_prfx_function_delay_ctrl_M904E4"] = 0,
						["01_prfx_arm_delay_ctrl_M905"] = 4,
						["01_prfx_function_delay_ctrl_M905"] = 0,
						["NFP_PRESID"] = "MDRN_B_A_GPLD",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
					},
				},
				[4] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 7,
				},
				[5] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 8,
				},
				[6] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 5,
				},
				[7] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 4,
				},
				[8] = {
					["CLSID"] = "{VSN_F4B_LAU105_AIM9J}",
					["num"] = 3,
				},
				[9] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 11,
				},
				[10] = {
					["CLSID"] = "{VSN_F4B_LAU105_AIM9J}",
					["num"] = 9,
				},
				[11] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 12,
				},
					},
					fuel = 6416,
					flare = 48,
					chaff = 48,
					gun = 100,
				},
			},
			["NAM - AG Mk20 - FT*2 - AIM-7E-2*4 - AIM-9J*4 - Mk-20 Rockeye*6"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				country = {
					[1] = "USA",
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "NAM" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
				range = 500000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 5486.4,
				hAttack = 4572,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "VSN_F4ER_PTB",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "VSN_F4EL_PTB",
					["num"] = 2,
				},
				[3] = {
					["CLSID"] = "{HB_F4E_ROCKEYE_6x}",
					["num"] = 6,
					["settings"] = {
						["NFP_PRESID"] = "MDRN_CC_A_Mk20",
						["NFP_PRESVER"] = 2,
						["NFP_fuze_type_nose"] = "Mk339Mod1",
						["function_delay_ctrl_00_Mk339Mod1"] = 1.2,
						["function_delay_ctrl_01_Mk339Mod1"] = 4,
					},
				},
				[4] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 7,
				},
				[5] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 8,
				},
				[6] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 5,
				},
				[7] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 4,
				},
				[8] = {
					["CLSID"] = "{VSN_F4B_LAU105_AIM9J}",
					["num"] = 3,
				},
				[9] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 11,
				},
				[10] = {
					["CLSID"] = "{VSN_F4B_LAU105_AIM9J}",
					["num"] = 9,
				},
				[11] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 12,
				},
					},
					fuel = 6416,
					flare = 48,
					chaff = 48,
					gun = 100,
				},
			},
		},	
		Escort = {
			["NAM - AA Escort - FT*3 - AIM-7E-2*4 - AIM-9J*4"] = {
				country = {
					[1] = "USA",
				},
				attributes =  { },
				code_loadout =  { "NAM" },
				night = true,
				adverseWeather = true,
				range = 600000,
				firepower = 2,
				vCruise = 255,
				standoff = 46300,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "VSN_F4ER_PTB",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "VSN_F4EL_PTB",
					["num"] = 2,
				},
				[3] = {
					["CLSID"] = "VSN_F4B_C2_PTB",
					["num"] = 6,
				},
				[4] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 7,
				},
				[5] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 8,
				},
				[6] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 5,
				},
				[7] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 4,
				},
				[8] = {
					["CLSID"] = "{VSN_F4B_LAU105_AIM9J}",
					["num"] = 3,
				},
				[9] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 11,
				},
				[10] = {
					["CLSID"] = "{VSN_F4B_LAU105_AIM9J}",
					["num"] = 9,
				},
				[11] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 12,
				},
					},
					fuel = 6416,
					flare = 48,
					chaff = 48,
					gun = 100,
				},
			},
		},	
		CAP = {
			["NAM - AA CAP - FT*3 - AIM-7E-2*4 - AIM-9J*4"] = {
				country = {
					[1] = "USA",
				},
				attributes =  {"CV CAP"},
				code_loadout =  { "NAM" },
				night = true,
				adverseWeather = true,
				range = 600000,
				firepower = 1.5,
				vCruise = 245,
				vAttack = 246.66666666667,
				hCruise = 6096,
				hAttack = 6096,
				standoff = 36000,
				tStation = 1800,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "VSN_F4ER_PTB",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "VSN_F4EL_PTB",
					["num"] = 2,
				},
				[3] = {
					["CLSID"] = "VSN_F4B_C2_PTB",
					["num"] = 6,
				},
				[4] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 7,
				},
				[5] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 8,
				},
				[6] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 5,
				},
				[7] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 4,
				},
				[8] = {
					["CLSID"] = "{VSN_F4B_LAU105_AIM9J}",
					["num"] = 3,
				},
				[9] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 11,
				},
				[10] = {
					["CLSID"] = "{VSN_F4B_LAU105_AIM9J}",
					["num"] = 9,
				},
				[11] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 12,
				},
					},
					fuel = 6416,
					flare = 48,
					chaff = 48,
					gun = 100,
				},
			},
		},
		["Fighter Sweep"] = {
			["NAM - AA Sweep - FT*3 - AIM-7E-2*4 - AIM-9J*4"] = {
				country = {
					[1] = "USA",
				},
				attributes =  { },
				code_loadout =  { "NAM" },
				adverseWeather = true,
				range = 600000,
				firepower = 2,
				vCruise = 255.83333333333,
				vAttack = 265.83333333333,
				hCruise = 2753.6,
				hAttack = 2753.6,
				standoff = 46300,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "VSN_F4ER_PTB",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "VSN_F4EL_PTB",
					["num"] = 2,
				},
				[3] = {
					["CLSID"] = "VSN_F4B_C2_PTB",
					["num"] = 6,
				},
				[4] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 7,
				},
				[5] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 8,
				},
				[6] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 5,
				},
				[7] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 4,
				},
				[8] = {
					["CLSID"] = "{VSN_F4B_LAU105_AIM9J}",
					["num"] = 3,
				},
				[9] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 11,
				},
				[10] = {
					["CLSID"] = "{VSN_F4B_LAU105_AIM9J}",
					["num"] = 9,
				},
				[11] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 12,
				},
					},
					fuel = 6416,
					flare = 48,
					chaff = 48,
					gun = 100,
				},
			},
		},
		Intercept = {
			["NAM - AA Intercept - FT*3 - AIM-7E-2*4 - AIM-9J*4"] = {
				country = {
					[1] = "USA",
				},
				attributes =  { },
				code_loadout =  { "NAM" },
				night = true,
				adverseWeather = true,
				range = 600000,
				firepower = 1,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "VSN_F4ER_PTB",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "VSN_F4EL_PTB",
					["num"] = 2,
				},
				[3] = {
					["CLSID"] = "VSN_F4B_C2_PTB",
					["num"] = 6,
				},
				[4] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 7,
				},
				[5] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 8,
				},
				[6] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 5,
				},
				[7] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 4,
				},
				[8] = {
					["CLSID"] = "{VSN_F4B_LAU105_AIM9J}",
					["num"] = 3,
				},
				[9] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 11,
				},
				[10] = {
					["CLSID"] = "{VSN_F4B_LAU105_AIM9J}",
					["num"] = 9,
				},
				[11] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 12,
				},
					},
					fuel = 6416,
					flare = 48,
					chaff = 48,
					gun = 100,
				},
			},
		},
	},
	["VSN_F4C"] = {
		SEAD = {
			["NAM - SEAD F4C - AIM-7E-2*4 - FT*3 - ECM Pod - AGM-45B*2"] = {
				country = {
					[1] = "USA",
				},
				attributes =  { },
				code_loadout =  { "NAM" },
				weaponType = "ASM",
				night = true,
				adverseWeather = true,
				range = 600000,
				firepower = 1,
				vCruise = 270,
				vAttack = 270,
				hCruise = 6096,
				hAttack = 6096,
				sortie_rate = 10,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "VSN_F4ER_PTB",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "VSN_F4EL_PTB",
					["num"] = 2,
				},
				[3] = {
					["CLSID"] = "VSN_F4B_C2_PTB",
					["num"] = 6,
				},
				[4] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 7,
				},
				[5] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 8,
				},
				[6] = {
					["CLSID"] = "{6D21ECEA-F85B-4E8D-9D51-31DC9B8AA4EF}",
					["num"] = 5,
				},
				[7] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 4,
				},
				[8] = {
					["CLSID"] = "{3E6B632D-65EB-44D2-9501-1C2D04515405}",
					["num"] = 9,
					["settings"] = {
						["EAS_bypass_ctrl"] = 1,
						["NFP_PRESID"] = "AGM_45",
						["NFP_PRESVER"] = 1,
						["NFP_rfgu_type"] = 1,
						["rf_lower_limit_ctrl_Mk22Mod2"] = 4800000000,
						["rf_upper_limit_ctrl_Mk22Mod2"] = 5200000000,
						["smoke_marker"] = 0,
					},
				},
				[9] = {
					["CLSID"] = "{3E6B632D-65EB-44D2-9501-1C2D04515405}",
					["num"] = 3,
					["settings"] = {
						["EAS_bypass_ctrl"] = 1,
						["NFP_PRESID"] = "AGM_45",
						["NFP_PRESVER"] = 1,
						["NFP_rfgu_type"] = 1,
						["rf_lower_limit_ctrl_Mk22Mod2"] = 4800000000,
						["rf_upper_limit_ctrl_Mk22Mod2"] = 5200000000,
						["smoke_marker"] = 0,
					},
				},
					},
					fuel = 6416,
					flare = 48,
					chaff = 48,
					gun = 100,
				},
			},
		},
		Strike = {
			["NAM - AG High F4C - AIM-7E-2*4 - AIM-9J*4 - FT*2 - Mk-82LD*6"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				country = {
					[1] = "USA",
				},
				attributes =  { "Bridge", "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "NAM" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
				range = 500000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 5486.4,
				hAttack = 4572,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "VSN_F4ER_PTB",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "VSN_F4EL_PTB",
					["num"] = 2,
				},
				[3] = {
					["CLSID"] = "{BRU41_6X_MK-82}",
					["num"] = 6,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_M904E4"] = 4,
						["00_prfx_function_delay_ctrl_M904E4"] = 0,
						["01_prfx_arm_delay_ctrl_M905"] = 4,
						["01_prfx_function_delay_ctrl_M905"] = 0,
						["NFP_PRESID"] = "MDRN_B_A_GPLD",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
					},
				},
				[4] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 7,
				},
				[5] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 8,
				},
				[6] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 5,
				},
				[7] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 4,
				},
				[8] = {
					["CLSID"] = "{VSN_F4B_LAU105_AIM9J}",
					["num"] = 9,
				},
				[9] = {
					["CLSID"] = "{VSN_F4B_LAU105_AIM9J}",
					["num"] = 3,
				},
					},
					fuel = 6416,
					flare = 48,
					chaff = 48,
					gun = 100,
				},
			},
			["NAM - AG High F4C - AIM-7E-2*4 - FT*3 - Mk-84LD*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				country = {
					[1] = "USA",
				},
				attributes =  { "Bridge", "Structure" },
				code_loadout =  { "NAM" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
				range = 600000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 5486.4,
				hAttack = 4572,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "VSN_F4ER_PTB",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "VSN_F4EL_PTB",
					["num"] = 2,
				},
				[3] = {
					["CLSID"] = "VSN_F4B_C2_PTB",
					["num"] = 6,
				},
				[4] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 7,
				},
				[5] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 8,
				},
				[6] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 5,
				},
				[7] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 4,
				},
				[8] = {
					["CLSID"] = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
					["num"] = 9,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_M904E4"] = 4,
						["00_prfx_function_delay_ctrl_M904E4"] = 0,
						["01_prfx_arm_delay_ctrl_M905"] = 4,
						["01_prfx_function_delay_ctrl_M905"] = 0,
						["NFP_PRESID"] = "MDRN_B_A_GPLD",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
					},
				},
				[9] = {
					["CLSID"] = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
					["num"] = 3,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_M904E4"] = 4,
						["00_prfx_function_delay_ctrl_M904E4"] = 0,
						["01_prfx_arm_delay_ctrl_M905"] = 4,
						["01_prfx_function_delay_ctrl_M905"] = 0,
						["NFP_PRESID"] = "MDRN_B_A_GPLD",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
					},
				},
					},
					fuel = 6416,
					flare = 48,
					chaff = 48,
					gun = 100,
				},
			},
			["NAM - AG Low F4C - AIM-7E-2*4 - AIM-9J*4 - FT*2 - Mk-82HD*6"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				country = {
					[1] = "USA",
				},
				attributes =  { "Bridge", "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "NAM" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 9100,
				hAttack = 200,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "VSN_F4ER_PTB",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "VSN_F4EL_PTB",
					["num"] = 2,
				},
				[3] = {
					["CLSID"] = "{HB_F4E_MK-82_Snakeye_6x}",
					["num"] = 6,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_M904E4"] = 4,
						["00_prfx_function_delay_ctrl_M904E4"] = 0,
						["01_prfx_arm_delay_ctrl_M905"] = 4,
						["01_prfx_function_delay_ctrl_M905"] = 0,
						["NFP_PRESID"] = "MDRN_B_A_GPLD",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
					},
				},
				[4] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 7,
				},
				[5] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 8,
				},
				[6] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 5,
				},
				[7] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 4,
				},
				[8] = {
					["CLSID"] = "{VSN_F4B_LAU105_AIM9J}",
					["num"] = 9,
				},
				[9] = {
					["CLSID"] = "{VSN_F4B_LAU105_AIM9J}",
					["num"] = 3,
				},
					},
					fuel = 6416,
					flare = 48,
					chaff = 48,
					gun = 100,
				},
			},
			["NAM - AG Rockeye F4C - AIM-7E-2*4 - AIM-9J*4 - FT*2 - Mk-20 Rockeye *6"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				country = {
					[1] = "USA",
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "NAM" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
				range = 500000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 5486.4,
				hAttack = 4572,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "VSN_F4ER_PTB",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "VSN_F4EL_PTB",
					["num"] = 2,
				},
				[3] = {
					["CLSID"] = "{HB_F4E_ROCKEYE_6x}",
					["num"] = 6,
					["settings"] = {
						["NFP_PRESID"] = "MDRN_CC_A_Mk20",
						["NFP_PRESVER"] = 2,
						["NFP_fuze_type_nose"] = "Mk339Mod1",
						["function_delay_ctrl_00_Mk339Mod1"] = 1.2,
						["function_delay_ctrl_01_Mk339Mod1"] = 4,
					},
				},
				[4] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 7,
				},
				[5] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 8,
				},
				[6] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 5,
				},
				[7] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 4,
				},
				[8] = {
					["CLSID"] = "{VSN_F4B_LAU105_AIM9J}",
					["num"] = 9,
				},
				[9] = {
					["CLSID"] = "{VSN_F4B_LAU105_AIM9J}",
					["num"] = 3,
				},
					},
					fuel = 6416,
					flare = 48,
					chaff = 48,
					gun = 100,
				},
			},
		},	
		Escort = {
			["NAM - Escort F4C - AIM-7E-2*4 - AIM-9J*4 - FT*3"] = {
				country = {
					[1] = "USA",
				},
				attributes =  { },
				code_loadout =  { "NAM" },
				night = true,
				adverseWeather = true,
				range = 600000,
				firepower = 2,
				vCruise = 255,
				standoff = 46300,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "VSN_F4ER_PTB",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "VSN_F4EL_PTB",
					["num"] = 2,
				},
				[3] = {
					["CLSID"] = "VSN_F4B_C2_PTB",
					["num"] = 6,
				},
				[4] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 7,
				},
				[5] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 8,
				},
				[6] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 5,
				},
				[7] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 4,
				},
				[8] = {
					["CLSID"] = "{VSN_F4B_LAU105_AIM9J}",
					["num"] = 9,
				},
				[9] = {
					["CLSID"] = "{VSN_F4B_LAU105_AIM9J}",
					["num"] = 3,
				},
					},
					fuel = 6416,
					flare = 48,
					chaff = 48,
					gun = 100,
				},
			},
		},	
		CAP = {
			["NAM - AA CAP F4C - AIM-7E-2*4 - AIM-9J*4 - FT*3"] = {
				country = {
					[1] = "USA",
				},
				attributes =  { },
				code_loadout =  { "NAM" },
				night = true,
				adverseWeather = true,
				range = 600000,
				firepower = 1.5,
				vCruise = 245,
				vAttack = 246.66666666667,
				hCruise = 6096,
				hAttack = 6096,
				standoff = 36000,
				tStation = 1800,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "VSN_F4ER_PTB",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "VSN_F4EL_PTB",
					["num"] = 2,
				},
				[3] = {
					["CLSID"] = "VSN_F4B_C2_PTB",
					["num"] = 6,
				},
				[4] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 7,
				},
				[5] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 8,
				},
				[6] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 5,
				},
				[7] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 4,
				},
				[8] = {
					["CLSID"] = "{VSN_F4B_LAU105_AIM9J}",
					["num"] = 9,
				},
				[9] = {
					["CLSID"] = "{VSN_F4B_LAU105_AIM9J}",
					["num"] = 3,
				},
					},
					fuel = 6416,
					flare = 48,
					chaff = 48,
					gun = 100,
				},
			},
		},
		["Fighter Sweep"] = {
			["NAM - AA Sweep F4C - AIM-7E-2*4 - AIM-9J*4 - FT*3"] = {
				country = {
					[1] = "USA",
				},
				attributes =  { },
				code_loadout =  { "NAM" },
				adverseWeather = true,
				range = 600000,
				firepower = 2,
				vCruise = 255.83333333333,
				vAttack = 265.83333333333,
				hCruise = 2753.6,
				hAttack = 2753.6,
				standoff = 46300,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "VSN_F4ER_PTB",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "VSN_F4EL_PTB",
					["num"] = 2,
				},
				[3] = {
					["CLSID"] = "VSN_F4B_C2_PTB",
					["num"] = 6,
				},
				[4] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 7,
				},
				[5] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 8,
				},
				[6] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 5,
				},
				[7] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 4,
				},
				[8] = {
					["CLSID"] = "{VSN_F4B_LAU105_AIM9J}",
					["num"] = 9,
				},
				[9] = {
					["CLSID"] = "{VSN_F4B_LAU105_AIM9J}",
					["num"] = 3,
				},
					},
					fuel = 6416,
					flare = 48,
					chaff = 48,
					gun = 100,
				},
			},
		},
		Intercept = {
			["NAM - AA Intercept F4C - AIM-7E-2*4 - AIM-9J*4 - FT*3"] = {
				country = {
					[1] = "USA",
				},
				attributes =  { },
				code_loadout =  { "NAM" },
				night = true,
				adverseWeather = true,
				range = 600000,
				firepower = 1,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "VSN_F4ER_PTB",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "VSN_F4EL_PTB",
					["num"] = 2,
				},
				[3] = {
					["CLSID"] = "VSN_F4B_C2_PTB",
					["num"] = 6,
				},
				[4] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 7,
				},
				[5] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 8,
				},
				[6] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 5,
				},
				[7] = {
					["CLSID"] = "{AIM-7E-2}",
					["num"] = 4,
				},
				[8] = {
					["CLSID"] = "{VSN_F4B_LAU105_AIM9J}",
					["num"] = 9,
				},
				[9] = {
					["CLSID"] = "{VSN_F4B_LAU105_AIM9J}",
					["num"] = 3,
				},
					},
					fuel = 6416,
					flare = 48,
					chaff = 48,
					gun = 100,
				},
			},
		},
	},
	["a_37_dragonfly"] = {
		Strike = {
			["NAM - Strike - Mk82*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				country = {
					[1] = "USA",
				},
				attributes =  { "soft" },
				code_loadout =  { "NAM" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
				range = 500000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 5486.4,
				hAttack = 4572,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "dragonfly_fuel_tanks",
					["num"] = 9,
				},
				[2] = {
					["CLSID"] = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
					["num"] = 5,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_M904E4"] = 4,
						["00_prfx_function_delay_ctrl_M904E4"] = 0,
						["01_prfx_arm_delay_ctrl_M905"] = 4,
						["01_prfx_function_delay_ctrl_M905"] = 0,
						["NFP_PRESID"] = "MDRN_B_A_GPLD",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
					},
				},
				[3] = {
					["CLSID"] = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
					["num"] = 4,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_M904E4"] = 4,
						["00_prfx_function_delay_ctrl_M904E4"] = 0,
						["01_prfx_arm_delay_ctrl_M905"] = 4,
						["01_prfx_function_delay_ctrl_M905"] = 0,
						["NFP_PRESID"] = "MDRN_B_A_GPLD",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
					},
				},
					},
					fuel = 2500,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
			["NAM - Strike - Rockets*28"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				country = {
					[1] = "USA",
				},
				attributes =  { "soft" },
				code_loadout =  { "NAM" },
				weaponType = "Rockets",
				expend = "All",
				attackType = "Dive",
				range = 500000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 5486.4,
				hAttack = 4572,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "dragonfly_fuel_tanks",
					["num"] = 9,
				},
				[2] = {
					["CLSID"] = "{69926055-0DA8-4530-9F2F-C86B157EA9F6}",
					["num"] = 5,
				},
				[3] = {
					["CLSID"] = "{69926055-0DA8-4530-9F2F-C86B157EA9F6}",
					["num"] = 4,
				},
				[4] = {
					["CLSID"] = "{69926055-0DA8-4530-9F2F-C86B157EA9F6}",
					["num"] = 6,
				},
				[5] = {
					["CLSID"] = "{69926055-0DA8-4530-9F2F-C86B157EA9F6}",
					["num"] = 3,
				},
					},
					fuel = 2500,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},	
	},		
	["vwv_rf101b"] = {
		Reconnaissance = {
			["Reco NAM Voodoo High"] = {
				support = {
					Escort = false,
					SEAD = false,
					["Escort Jammer"] = true,
				},
				attributes =  { "recon high" },
				code_loadout =  { "NAM" },
				night = false,
				adverseWeather = false,
				range = 900000,
				firepower = 10,
				vCruise = 305,
				vAttack = 443,
				hCruise = 9144,
				hAttack = 15000,
				tStation = 2000,
				sortie_rate = 3,
				stores = {
					pylons = {
					},
					fuel = 7770,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
			["Reco NAM Voodoo Low"] = {
				support = {
					Escort = false,
					SEAD = false,
					["Escort Jammer"] = false,
				},
				attributes =  { "recon low" },
				code_loadout =  { "NAM" },
				night = false,
				adverseWeather = true,
				range = 900000,
				firepower = 10,
				vCruise = 290,
				vAttack = 305,
				hCruise = 300,
				hAttack = 300,
				tStation = 2000,
				sortie_rate = 3,
				stores = {
					pylons = {
					},
					fuel = 7770,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
	},
	["AH-1G"] = {
		Strike = {
			["NAM - AG - Rockets *38"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				country = {
					[1] = "USA",
				},
				attributes =  { "soft" },
				code_loadout =  { "NAM" },
				weaponType = "Rockets",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 55,
				vAttack = 60,
				hCruise = 50,
				hAttack = 50,
				sortie_rate = 6,
				stores = {
				pylons = {
					[1] = 
					{
					["CLSID"] = "{FD90A1DC-9147-49FA-BF56-CB83EF0BD32B}",
					}, -- end of [1]
					[4] = 
					{
					["CLSID"] = "{FD90A1DC-9147-49FA-BF56-CB83EF0BD32B}",
					}, -- end of [4]
				},
					fuel = 1157,
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
		},
		Escort = {
			["NAM - Escort Rockets *38"] = {
				country = {
					[1] = "USA",
				},
				attributes =  { },
				code_loadout =  { "NAM" },
				night = true,
				adverseWeather = true,
				range = 150000,
				firepower = 1,
				vCruise = 75,
				standoff = 6000,
				sortie_rate = 6,
				stores = {
					pylons = {
					[1] = 
					{
					["CLSID"] = "{FD90A1DC-9147-49FA-BF56-CB83EF0BD32B}",
					}, -- end of [1]
					[4] = 
					{
					["CLSID"] = "{FD90A1DC-9147-49FA-BF56-CB83EF0BD32B}",
					}, -- end of [4]
					},
					fuel = 1157,
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
		},
	},
	["vwv_ec-121"] = {
		AWACS = {
			Default = {
				attributes =  { "Sentry" },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 154.16666666667,
				vAttack = 154.16666666667,
				hCruise = 7315.2,
				hAttack = 7315.2,
				tStation = 25200,
				sortie_rate = 3,
				stores = {
					pylons = {
					},
					fuel = "15000",
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
	},	
}