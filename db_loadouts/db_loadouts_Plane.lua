--Planes Loadouts database
-------------------------------------------------------------------------------------------------------
----OB----


if not versionDCE then versionDCE = {} end
versionDCE["db_loadouts/db_loadouts_Plane.lua"] = "1.3.207"

-- V207 - add F-100D for NAM
-- V206 - add Tu-95MS reco plane for TF
-- V205 - add SU-24MR escort jammer capacity and used by antiship planes 
-- V204 - add refuel capacity to A6E
-- V203 - add ["Escort Jammer"] = true, to B-52 AV8NA
-- V202 - Su-33 CV
-- V201 - no Mods - A6E - C-130J-30
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
	["E-2C"] = {
		AWACS = {
			Default = {
				attributes =  { "AEW" },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 152.778,
				vAttack = 138.889,
				hCruise = 7315.2,
				hAttack = 7315.2,
				tStation = 18000,
				sortie_rate = 4,
				stores = {
					pylons = {
					},
					fuel = "65000",
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
		},
	},
	["L-39ZA"] = {
		Strike = {
			["WOB - AG - UB-16x2 - R-60Mx2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "soft", "Parked Aircraft" },
				code_loadout =  { "WOB" },
				weaponType = "Rockets",
				expend = "Auto",
				attackType = "Dive",
								range = 250000,
				firepower = 1,
				vCruise = 200,
				vAttack = 300.5,
				hCruise = 5486.4,
				hAttack = 4572,
				sortie_rate = 6,
				stores = {
					pylons = {
						[5] = {
							CLSID = "{APU-60-1_R_60M}",
						},
						[2] = {
							CLSID = "{UB-16-57UMP}",
						},
						[4] = {
							CLSID = "{UB-16-57UMP}",
						},
						[1] = {
							CLSID = "{APU-60-1_R_60M}",
						},
					},
					fuel = "980",
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
			["WOB - AG - FAB-250x4"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "soft", "Parked Aircraft", "Structure" },
				code_loadout =  { "WOB" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
								range = 450000,
				firepower = 1,
				vCruise = 200,
				vAttack = 300.5,
				hCruise = 5486.4,
				hAttack = 4572,
				sortie_rate = 6,
				stores = {
					pylons = {
						[5] = {
							CLSID = "{FAB_250_M62}",
						},
						[2] = {
							CLSID = "{FAB_250_M62}",
						},
						[4] = {
							CLSID = "{FAB_250_M62}",
						},
						[1] = {
							CLSID = "{FAB_250_M62}",
						},
					},
					fuel = "980",
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
			["WOB - AG - UB-16x4"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "soft", "Parked Aircraft" },
				code_loadout =  { "WOB" },
				weaponType = "Rockets",
				expend = "Auto",
				attackType = "Dive",
								range = 250000,
				firepower = 1,
				vCruise = 200,
				vAttack = 300.5,
				hCruise = 5486.4,
				hAttack = 4572,
				sortie_rate = 6,
				stores = {
					pylons = {
						[5] = {
							CLSID = "{UB-16-57UMP}",
						},
						[2] = {
							CLSID = "{UB-16-57UMP}",
						},
						[4] = {
							CLSID = "{UB-16-57UMP}",
						},
						[1] = {
							CLSID = "{UB-16-57UMP}",
						},
					},
					fuel = "980",
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
			["WOB - AG - FAB-250x2 - R-60Mx2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "soft", "Parked Aircraft", "Structure" },
				code_loadout =  { "WOB" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
								range = 450000,
				firepower = 1,
				vCruise = 200,
				vAttack = 300.5,
				hCruise = 5486.4,
				hAttack = 4572,
				sortie_rate = 6,
				stores = {
					pylons = {
						[5] = {
							CLSID = "{APU-60-1_R_60M}",
						},
						[2] = {
							CLSID = "{FAB_250_M62}",
						},
						[4] = {
							CLSID = "{FAB_250_M62}",
						},
						[1] = {
							CLSID = "{APU-60-1_R_60M}",
						},
					},
					fuel = "980",
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
	},
	["UH-60A"] = {
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
					},
					fuel = 1100,
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
				vCruise = 65,
				vAttack = 75,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
					},
					fuel = 1100,
					flare = 30,
					chaff = 30,
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
				vCruise = 65,
				vAttack = 75,
				hCruise = 100,
				hAttack = 100,
				sortie_rate = 5,
				stores = {
					pylons = {
					},
					fuel = "1100",
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
		},
	},
	["MiG-15bis"] = {
		Intercept = {
			["NAM - AA - Intercept"] = {
				attributes =  { },
				country = {
					[1] = "Vietnam",
				},
				code_loadout =  { "NAM" },
								range = 150000,
				firepower = 1,
				sortie_rate = 6,
				stores = {
					["pylons"] = {
					},
					fuel = 1172,
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
				vAttack = 213.86666666667,
				hCruise = 800,
				hAttack = 800,
				sortie_rate = 2,
				standoff = 20000,
				stores = {
					pylons = {
					},
					fuel = 1172,
					flare = 0,
					chaff = 0,
					gun = 100,
				},	
			},
		},
		CAP = {
			["CAP NAM - AA"] = {
				attributes =  { },
				code_loadout =  { "NAM" },
				country = {
					[1] = "Vietnam",
				},
								range = 150000,
				firepower = 1,
				vCruise = 200,
				vAttack = 213.86666666667,
				hCruise = 3000,
				hAttack = 3000,
				standoff = false,
				tStation = 1200,
				sortie_rate = 6,
				stores = {
					["pylons"] = {
					},
					fuel = 1172,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
	},
	["MiG-19P"] = {
		Strike = {
			["IPW - Strike - K-13A*2, FAB-250*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "soft", "Parked Aircraft", "Structure" },
				code_loadout =  { "IPW71" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
								range = 450000,
				firepower = 1,
				vCruise = 200,
				vAttack = 300.5,
				hCruise = 5486.4,
				hAttack = 4572,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{K-13A}",
						},
						[2] = {
							CLSID = "{3C612111-C7AD-476E-8A8E-2485812F4E5C}",
						},
						[6] = {
							CLSID = "{K-13A}",
						},
						[5] = {
							CLSID = "{3C612111-C7AD-476E-8A8E-2485812F4E5C}",
						},
					},
					fuel = 1800,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
			["IPW - Strike - K-13A*2, PTB-760*2, ORO-57K*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "soft", "Parked Aircraft" },
				code_loadout =  { "IPW71" },
				weaponType = "Rockets",
				expend = "Auto",
				attackType = "Dive",
								range = 450000,
				firepower = 1,
				vCruise = 200,
				vAttack = 300.5,
				hCruise = 5486.4,
				hAttack = 4572,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{K-13A}",
						},
						[2] = {
							CLSID = "PTB760_MIG19",
						},
						[3] = {
							CLSID = "{ORO57K_S5M_HEFRAG}",
						},
						[4] = {
							CLSID = "{ORO57K_S5M_HEFRAG}",
						},
						[5] = {
							CLSID = "PTB760_MIG19",
						},
						[6] = {
							CLSID = "{K-13A}",
						},
					},
					fuel = 1800,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
			["IPW - Strike SR - K-13A*2, ORO-57K*4"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "soft", "Parked Aircraft" },
				code_loadout =  { "IPW71" },
				weaponType = "Rockets",
				expend = "Auto",
				attackType = "Dive",
								range = 250000,
				firepower = 1,
				vCruise = 200,
				vAttack = 300.5,
				hCruise = 5486.4,
				hAttack = 4572,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{K-13A}",
						},
						[2] = {
							CLSID = "{ORO57K_S5M_HEFRAG}",
						},
						[3] = {
							CLSID = "{ORO57K_S5M_HEFRAG}",
						},
						[4] = {
							CLSID = "{ORO57K_S5M_HEFRAG}",
						},
						[5] = {
							CLSID = "{ORO57K_S5M_HEFRAG}",
						},
						[6] = {
							CLSID = "{K-13A}",
						},
					},
					fuel = 1800,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		["Fighter Sweep"] = {
			["Fighter Sweep TF-Old-LR-AIM-9M*2,AIM7MH*4,FT*3"] = {
				self_escort = true,
				attributes =  { },
				code_loadout =  { "IPW71" },
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
						[1] = {
							CLSID = "{K-13A}",
						},
						[2] = {
							CLSID = "PTB760_MIG19",
						},
						[6] = {
							CLSID = "{K-13A}",
						},
						[5] = {
							CLSID = "PTB760_MIG19",
						},
					},
					fuel = 1800,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		Escort = {
			[" Escort IPW K-13A*2, PTB-760*2"] = {
				attributes =  { },
				code_loadout =  { "IPW71" },
								range = 250000,
				firepower = 1,
				vCruise = 200,
				standoff = 3000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{K-13A}",
						},
						[2] = {
							CLSID = "PTB760_MIG19",
						},
						[6] = {
							CLSID = "{K-13A}",
						},
						[5] = {
							CLSID = "PTB760_MIG19",
						},
					},
					fuel = 1800,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		CAP = {
			["CAP IPW K-13A*2, PTB-760*2"] = {
				attributes =  { },
				code_loadout =  { "IPW71" },
								range = 250000,
				firepower = 1,
				vCruise = 200,
				vAttack = 213.86666666667,
				hCruise = 7096,
				hAttack = 7096,
				standoff = 3000,
				tStation = 1800,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{K-13A}",
						},
						[2] = {
							CLSID = "PTB760_MIG19",
						},
						[6] = {
							CLSID = "{K-13A}",
						},
						[5] = {
							CLSID = "PTB760_MIG19",
						},
					},
					fuel = 1800,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},	
			["NAM - AA - CAP - FT - K-13Ax2"] = {
				attributes =  { },
				country = {
					[1] = "Vietnam",
				},
				code_loadout =  { "NAM" },
								range = 250000,
				firepower = 1,
				vCruise = 200,
				vAttack = 213.86666666667,
				hCruise = 7096,
				hAttack = 7096,
				standoff = 3000,
				tStation = 1800,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{K-13A}",
					["num"] = 6,
				},
				[2] = {
					["CLSID"] = "{K-13A}",
					["num"] = 1,
				},
				[3] = {
					["CLSID"] = "PTB760_MIG19",
					["num"] = 5,
				},
				[4] = {
					["CLSID"] = "PTB760_MIG19",
					["num"] = 2,
				},
					},
					fuel = 1800,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		["Anti-ship Strike"] = {
			["Antiship IPW - Strike SR - K-13A*2, ORO-57K*4"] = {
				minscore = 0.3,
				support = {
					SEAD = false,
					Escort = true,
					["Laser Illumination"] = false,
				},
				attributes =  { "ship" },
				code_loadout =  { "IPW71" },
				weaponType = "Rockets",
				expend = "Auto",
				attackType = "Dive",
								range = 250000,
				firepower = 1,
				vCruise = 200,
				vAttack = 300.5,
				hCruise = 5486.4,
				hAttack = 4572,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{K-13A}",
						},
						[2] = {
							CLSID = "{ORO57K_S5M_HEFRAG}",
						},
						[3] = {
							CLSID = "{ORO57K_S5M_HEFRAG}",
						},
						[4] = {
							CLSID = "{ORO57K_S5M_HEFRAG}",
						},
						[5] = {
							CLSID = "{ORO57K_S5M_HEFRAG}",
						},
						[6] = {
							CLSID = "{K-13A}",
						},
					},
					fuel = 1800,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
			["IPW - Strike - K-13A*2, FAB-250*2"] = {
				minscore = 0.3,
				support = {
					SEAD = false,
					Escort = true,
					["Laser Illumination"] = false,
				},
				attributes =  { "ship" },
				code_loadout =  { "IPW71" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
								range = 450000,
				firepower = 1,
				vCruise = 200,
				vAttack = 250,
				hCruise = 5000,
				hAttack = 5000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{K-13A}",
						},
						[2] = {
							CLSID = "{3C612111-C7AD-476E-8A8E-2485812F4E5C}",
						},
						[6] = {
							CLSID = "{K-13A}",
						},
						[5] = {
							CLSID = "{3C612111-C7AD-476E-8A8E-2485812F4E5C}",
						},
					},
					fuel = 1800,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		Intercept = {
			["Intercept IPW - Intercept - K-13A*2"] = {
				attributes =  { },
				code_loadout =  { "IPW71" },
								range = 150000,
				firepower = 1,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{K-13A}",
						},
						[6] = {
							CLSID = "{K-13A}",
						},
					},
					fuel = 1800,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
			["NAM - AA - Intercept - FT - K-13Ax2"] = {
				attributes =  { },
				country = {
					[1] = "Vietnam",
				},
				code_loadout =  { "NAM" },
								range = 150000,
				firepower = 1,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{K-13A}",
					["num"] = 6,
				},
				[2] = {
					["CLSID"] = "{K-13A}",
					["num"] = 1,
				},
				[3] = {
					["CLSID"] = "PTB760_MIG19",
					["num"] = 5,
				},
				[4] = {
					["CLSID"] = "PTB760_MIG19",
					["num"] = 2,
				},
					},
					fuel = 1800,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
	},
	["Mirage-F1CE"] = {
		Strike = {
			["WOC LR AS 2*R550 Magic I, 4*SAMP-400 LD, 72*RKT, 2*Fuel Tank"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "frontline" },
				code_loadout =  { "Caucasus", "WOC80" },
				weaponType = "Bombs",
				expend = "All",
								range = 300000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 8000,
				hAttack = 4000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R550_Magic_1}",
						},
						[2] = {
							CLSID = "{MATRA_F1_SNEBT253}",
						},
						[3] = {
							CLSID = "PTB-1200-F1",
						},
						[4] = {
							CLSID = "{CLB4_SAMP400LD}",
						},
						[5] = {
							CLSID = "PTB-1200-F1",
						},
						[6] = {
							CLSID = "{MATRA_F1_SNEBT253}",
						},
						[7] = {
							CLSID = "{R550_Magic_1}",
						},
					},
					fuel = 3356,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
			["Revenge LR AS 2*R550 Magic I, 6*Mk82 LD, 2*Fuel Tank"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "Structure" },
				code_loadout =  { "Revenge" },
				weaponType = "Bombs",
				expend = "All",
								range = 200000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 9100,
				hAttack = 4572,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R550_Magic_1}",
						},
						[2] = {
							CLSID = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
						},
						[3] = {
							CLSID = "PTB-1200-F1",
						},
						[4] = {
							CLSID = "{CLB4_MK82}",
						},
						[5] = {
							CLSID = "PTB-1200-F1",
						},
						[6] = {
							CLSID = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
						},
						[7] = {
							CLSID = "{R550_Magic_1}",
						},
					},
					fuel = 3356,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
			["WOC LR AS 2*R550 Magic I, 6*Mk82 LD, 2*Fuel Tank"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "frontline" },
				code_loadout =  { "Caucasus" },
				weaponType = "Bombs",
				expend = "All",
								range = 300000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 9100,
				hAttack = 4572,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R550_Magic_1}",
						},
						[2] = {
							CLSID = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
						},
						[3] = {
							CLSID = "PTB-1200-F1",
						},
						[4] = {
							CLSID = "{CLB4_MK82}",
						},
						[5] = {
							CLSID = "PTB-1200-F1",
						},
						[6] = {
							CLSID = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
						},
						[7] = {
							CLSID = "{R550_Magic_1}",
						},
					},
					fuel = 3356,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
			["Revenge LR AS 2*R550 Magic I, 6*SAMP-400 LD, 2*Fuel Tank"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "Structure" },
				code_loadout =  { "Crisis", "Revenge", "WOC80" },
				weaponType = "Bombs",
				expend = "All",
								range = 200000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 9100,
				hAttack = 4572,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R550_Magic_1}",
						},
						[2] = {
							CLSID = "{SAMP400LD}",
						},
						[3] = {
							CLSID = "PTB-1200-F1",
						},
						[4] = {
							CLSID = "{CLB4_SAMP400LD}",
						},
						[5] = {
							CLSID = "PTB-1200-F1",
						},
						[6] = {
							CLSID = "{SAMP400LD}",
						},
						[7] = {
							CLSID = "{R550_Magic_1}",
						},
					},
					fuel = 3356,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
			["WOC Caucasus LR AS 2*R550 Magic I, 4*SAMP-400 HD, 72*RKT, 2*Fuel Tank"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "frontline" },
				code_loadout =  { "Caucasus", "WOC80" },
				weaponType = "Bombs",
				expend = "All",
								range = 300000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 2000,
				hAttack = 500,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R550_Magic_1}",
						},
						[2] = {
							CLSID = "{MATRA_F1_SNEBT253}",
						},
						[3] = {
							CLSID = "PTB-1200-F1",
						},
						[4] = {
							CLSID = "{CLB4_SAMP400HD}",
						},
						[5] = {
							CLSID = "PTB-1200-F1",
						},
						[6] = {
							CLSID = "{MATRA_F1_SNEBT253}",
						},
						[7] = {
							CLSID = "{R550_Magic_1}",
						},
					},
					fuel = 3356,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
			["WOC LR AS 2*R550 Magic I, 4*SAMP-400 LD, 2*Belouga, 2*Fuel Tank"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "frontline" },
				code_loadout =  { "Caucasus", "WOC80" },
				weaponType = "Bombs",
				expend = "All",
								range = 300000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 8000,
				hAttack = 4000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R550_Magic_1}",
						},
						[2] = {
							CLSID = "{BLG66_BELOUGA}",
						},
						[3] = {
							CLSID = "PTB-1200-F1",
						},
						[4] = {
							CLSID = "{CLB4_SAMP400LD}",
						},
						[5] = {
							CLSID = "PTB-1200-F1",
						},
						[6] = {
							CLSID = "{BLG66_BELOUGA}",
						},
						[7] = {
							CLSID = "{R550_Magic_1}",
						},
					},
					fuel = 3356,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
			["WOT87 IIW LR AS 2*R550 Magic I, 6*SAMP-400 HD, 2*Fuel Tank"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "SAM", "Structure" },
				code_loadout =  { "WOT87", "IIW" },
				weaponType = "Bombs",
				expend = "All",
								range = 800000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 2000,
				hAttack = 50,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R550_Magic_1}",
						},
						[2] = {
							CLSID = "{SAMP400HD}",
						},
						[3] = {
							CLSID = "PTB-1200-F1",
						},
						[4] = {
							CLSID = "{CLB4_SAMP400HD}",
						},
						[5] = {
							CLSID = "PTB-1200-F1",
						},
						[6] = {
							CLSID = "{SAMP400HD}",
						},
						[7] = {
							CLSID = "{R550_Magic_1}",
						},
					},
					fuel = 3356,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
			["WOC LR AS 2*R550 Magic I, 4*SAMP-400 HD, 2*Belouga, 2*Fuel Tank"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "frontline" },
				code_loadout =  { "Caucasus", "WOC80" },
				weaponType = "Bombs",
				expend = "All",
								range = 300000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 2000,
				hAttack = 500,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R550_Magic_1}",
						},
						[2] = {
							CLSID = "{BLG66_BELOUGA}",
						},
						[3] = {
							CLSID = "PTB-1200-F1",
						},
						[4] = {
							CLSID = "{CLB4_SAMP400HD}",
						},
						[5] = {
							CLSID = "PTB-1200-F1",
						},
						[6] = {
							CLSID = "{BLG66_BELOUGA}",
						},
						[7] = {
							CLSID = "{R550_Magic_1}",
						},
					},
					fuel = 3356,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
			["WOT87 Caucasus LR AS 2*R550 Magic I, 144*RKT, 1*Fuel Tank"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "SAM" },
				code_loadout =  { "WOT87", "IIW" },
				weaponType = "Rockets",
				expend = "All",
								range = 800000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 2000,
				hAttack = 50,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R550_Magic_1}",
						},
						[2] = {
							CLSID = "{MATRA_F1_SNEBT253}",
						},
						[3] = {
							CLSID = "{MATRA_F1_SNEBT253}",
						},
						[4] = {
							CLSID = "PTB-1200-F1",
						},
						[5] = {
							CLSID = "{MATRA_F1_SNEBT253}",
						},
						[6] = {
							CLSID = "{MATRA_F1_SNEBT253}",
						},
						[7] = {
							CLSID = "{R550_Magic_1}",
						},
					},
					fuel = 3356,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
			["Revenge LR AS 2*R550 Magic I, 6*SAMP-250 HD, 2*Fuel Tank"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "Structure" },
				code_loadout =  { "Crisis", "Revenge", "WOC80", "WOT87", "IIW" },
				weaponType = "Bombs",
				expend = "All",
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 195,
				vAttack = 300,
				hCruise = 6000,
				hAttack = 500,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R550_Magic_1}",
						},
						[2] = {
							CLSID = "{SAMP250HD}",
						},
						[3] = {
							CLSID = "PTB-1200-F1",
						},
						[4] = {
							CLSID = "{CLB4_SAMP250HD}",
						},
						[5] = {
							CLSID = "PTB-1200-F1",
						},
						[6] = {
							CLSID = "{SAMP250HD}",
						},
						[7] = {
							CLSID = "{R550_Magic_1}",
						},
					},
					fuel = 3356,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
			["WOT87 LR AS 2*R550 Magic I, 6*SAMP-400 LD, 2*Fuel Tank"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Structure" },
				code_loadout =  { "Crisis", "WOT87", "IIW" },
				weaponType = "Bombs",
				expend = "All",
								range = 200000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 9100,
				hAttack = 4572,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R550_Magic_1}",
						},
						[2] = {
							CLSID = "{SAMP400LD}",
						},
						[3] = {
							CLSID = "PTB-1200-F1",
						},
						[4] = {
							CLSID = "{CLB4_SAMP400LD}",
						},
						[5] = {
							CLSID = "PTB-1200-F1",
						},
						[6] = {
							CLSID = "{SAMP400LD}",
						},
						[7] = {
							CLSID = "{R550_Magic_1}",
						},
					},
					fuel = 3356,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
			["IIW LR AS 2*R550 Magic I, 4*SAMP-400 HD, 2*Belouga, 2*Fuel Tank"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "SAM", "Structure" },
				code_loadout =  { "IIW" },
				weaponType = "Bombs",
				expend = "All",
								range = 800000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 2000,
				hAttack = 50,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R550_Magic_1}",
						},
						[2] = {
							CLSID = "{BLG66_BELOUGA}",
						},
						[3] = {
							CLSID = "PTB-1200-F1",
						},
						[4] = {
							CLSID = "{CLB4_SAMP400HD}",
						},
						[5] = {
							CLSID = "PTB-1200-F1",
						},
						[6] = {
							CLSID = "{BLG66_BELOUGA}",
						},
						[7] = {
							CLSID = "{R550_Magic_1}",
						},
					},
					fuel = 3356,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
			["WOT87 LR AS 2*R550 Magic I, 3*Mk83 LD, 2*Fuel Tank"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Structure" },
				code_loadout =  { "WOT87", "IIW" },
				weaponType = "Bombs",
				expend = "All",
								range = 800000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 9100,
				hAttack = 4572,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R550_Magic_1}",
						},
						[2] = {
							CLSID = "{7A44FF09-527C-4B7E-B42B-3F111CFE50FB}",
						},
						[3] = {
							CLSID = "PTB-1200-F1",
						},
						[4] = {
							CLSID = "{7A44FF09-527C-4B7E-B42B-3F111CFE50FB}",
						},
						[5] = {
							CLSID = "PTB-1200-F1",
						},
						[6] = {
							CLSID = "{7A44FF09-527C-4B7E-B42B-3F111CFE50FB}",
						},
						[7] = {
							CLSID = "{R550_Magic_1}",
						},
					},
					fuel = 3356,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
			["WOC LR AS 2*R550 Magic I, 3*Mk83 LD, 2*Fuel Tank"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "frontline" },
				code_loadout =  { "Caucasus", "WOC80" },
				weaponType = "Bombs",
				expend = "All",
								range = 300000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 9100,
				hAttack = 4572,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R550_Magic_1}",
						},
						[2] = {
							CLSID = "{7A44FF09-527C-4B7E-B42B-3F111CFE50FB}",
						},
						[3] = {
							CLSID = "PTB-1200-F1",
						},
						[4] = {
							CLSID = "{7A44FF09-527C-4B7E-B42B-3F111CFE50FB}",
						},
						[5] = {
							CLSID = "PTB-1200-F1",
						},
						[6] = {
							CLSID = "{7A44FF09-527C-4B7E-B42B-3F111CFE50FB}",
						},
						[7] = {
							CLSID = "{R550_Magic_1}",
						},
					},
					fuel = 3356,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
		},
		["Anti-ship Strike"] = {
			["Revenge LR AS 2*R550 Magic I, 6*SAMP-400 HD, 2*Fuel Tank"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "ship" },
				code_loadout =  { "Revenge", "IIW" },
				weaponType = "Bombs",
				expend = "All",
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 195,
				vAttack = 300,
				hCruise = 6000,
				hAttack = 50,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R550_Magic_1}",
						},
						[2] = {
							CLSID = "{SAMP250HD}",
						},
						[3] = {
							CLSID = "PTB-1200-F1",
						},
						[4] = {
							CLSID = "{CLB4_SAMP250HD}",
						},
						[5] = {
							CLSID = "PTB-1200-F1",
						},
						[6] = {
							CLSID = "{SAMP250HD}",
						},
						[7] = {
							CLSID = "{R550_Magic_1}",
						},
					},
					fuel = 3356,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
			["Revenge LR AS 2*R550 Magic I, 6*SAMP-400 LD, 2*Fuel Tank"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "ship" },
				code_loadout =  { "Revenge" },
				weaponType = "Bombs",
				expend = "All",
								range = 200000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 9100,
				hAttack = 4572,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R550_Magic_1}",
						},
						[2] = {
							CLSID = "{SAMP400LD}",
						},
						[3] = {
							CLSID = "PTB-1200-F1",
						},
						[4] = {
							CLSID = "{CLB4_SAMP400LD}",
						},
						[5] = {
							CLSID = "PTB-1200-F1",
						},
						[6] = {
							CLSID = "{SAMP400LD}",
						},
						[7] = {
							CLSID = "{R550_Magic_1}",
						},
					},
					fuel = 3356,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
			["Revenge LR AS 2*R550 Magic I, 6*Mk82 LD, 2*Fuel Tank"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "ship" },
				code_loadout =  { "Revenge" },
				weaponType = "Bombs",
				expend = "All",
								range = 200000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 9100,
				hAttack = 4572,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R550_Magic_1}",
						},
						[2] = {
							CLSID = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
						},
						[3] = {
							CLSID = "PTB-1200-F1",
						},
						[4] = {
							CLSID = "{CLB4_MK82}",
						},
						[5] = {
							CLSID = "PTB-1200-F1",
						},
						[6] = {
							CLSID = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
						},
						[7] = {
							CLSID = "{R550_Magic_1}",
						},
					},
					fuel = 3356,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
		},
		Escort = {
			["Revenge LR AA 2*R550 Magic I, 1*R530EM, 2*Fuel Tank"] = {
				attributes =  { },
				code_loadout =  { "Crisis", "Revenge", "WOC80", "WOT87", "IIW" },
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 270,
				standoff = 27000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R550_Magic_1}",
						},
						[3] = {
							CLSID = "PTB-1200-F1",
						},
						[4] = {
							CLSID = "{R530F_EM}",
						},
						[5] = {
							CLSID = "PTB-1200-F1",
						},
						[7] = {
							CLSID = "{R550_Magic_1}",
						},
					},
					fuel = 3356,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
		},
		CAP = {
			["Revenge LR AA 2*R550 Magic I, 1*R530EM, 2*Fuel Tank"] = {
				attributes =  { },
				code_loadout =  { "Revenge", "WOT87", "IIW" },
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 245,
				vAttack = 246.66666666667,
				hCruise = 10900,
				hAttack = 10900,
				standoff = 36000,
				tStation = 1800,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R550_Magic_1}",
						},
						[3] = {
							CLSID = "PTB-1200-F1",
						},
						[4] = {
							CLSID = "{R530F_EM}",
						},
						[5] = {
							CLSID = "PTB-1200-F1",
						},
						[7] = {
							CLSID = "{R550_Magic_1}",
						},
					},
					fuel = 3356,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
			["WOC80 LR AA 2*R550 Magic I, 1*R530EM, 2*Fuel Tank"] = {
				attributes =  { "Air Forces" },
				code_loadout =  { "Crisis", "WOC80" },
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 245,
				vAttack = 246.66666666667,
				hCruise = 10900,
				hAttack = 10900,
				standoff = 36000,
				tStation = 1800,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R550_Magic_1}",
						},
						[3] = {
							CLSID = "PTB-1200-F1",
						},
						[4] = {
							CLSID = "{R530F_EM}",
						},
						[5] = {
							CLSID = "PTB-1200-F1",
						},
						[7] = {
							CLSID = "{R550_Magic_1}",
						},
					},
					fuel = 3356,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
		},
		["Runway Attack"] = {
			["RAttack LR AS 2*R550 Magic I, 6*SAMP-400 LD, 2*Fuel Tank"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Runway" },
				code_loadout =  { "All" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 9100,
				hAttack = 100,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R550_Magic_1}",
						},
						[2] = {
							CLSID = "{SAMP400LD}",
						},
						[3] = {
							CLSID = "PTB-1200-F1",
						},
						[4] = {
							CLSID = "{CLB4_SAMP400LD}",
						},
						[5] = {
							CLSID = "PTB-1200-F1",
						},
						[6] = {
							CLSID = "{SAMP400LD}",
						},
						[7] = {
							CLSID = "{R550_Magic_1}",
						},
					},
					fuel = 3356,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
		},
		["Fighter Sweep"] = {
			["Revenge LR AA 2*R550 Magic I, 1*R530EM, 2*Fuel Tank"] = {
				attributes =  { },
				code_loadout =  { "Crisis", "Revenge", "WOC80", "WOT87", "IIW" },
				night = true,
				adverseWeather = true,
				range = 800000,
				firepower = 1,
				vCruise = 255.83333333333,
				vAttack = 265.83333333333,
				hCruise = 10900,
				hAttack = 10900,
				standoff = 27000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R550_Magic_1}",
						},
						[3] = {
							CLSID = "PTB-1200-F1",
						},
						[4] = {
							CLSID = "{R530F_EM}",
						},
						[5] = {
							CLSID = "PTB-1200-F1",
						},
						[7] = {
							CLSID = "{R550_Magic_1}",
						},
					},
					fuel = 3356,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
		},
		Intercept = {
			["Revenge LR AA 2*R550 Magic I, 1*R530EM, 2*Fuel Tank"] = {
				attributes =  { },
				code_loadout =  { "Crisis", "Revenge", "WOC80", "IIW" },
				adverseWeather = true,
				range = 800000,
				firepower = 1,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R550_Magic_1}",
						},
						[3] = {
							CLSID = "PTB-1200-F1",
						},
						[4] = {
							CLSID = "{R530F_EM}",
						},
						[5] = {
							CLSID = "PTB-1200-F1",
						},
						[7] = {
							CLSID = "{R550_Magic_1}",
						},
					},
					fuel = 3356,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
			["WOC80 80s - AA - SR - 2xMagic1 - 2xR530 - FT"] = {
				attributes =  { },
				code_loadout =  { "Crisis", "WOC80", "WOT87", "IIW", "WOB" },
				adverseWeather = true,
				range = 800000,
				firepower = 1,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R550_Magic_1}",
						},
						[3] = {
							CLSID = "{R530F_EM}",
						},
						[4] = {
							CLSID = "PTB-1200-F1",
						},
						[5] = {
							CLSID = "{R530F_EM}",
						},
						[7] = {
							CLSID = "{R550_Magic_1}",
						},
					},
					fuel = 3356,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
		},
	},
	["AH-1W"] = {
		Escort = {
			Escort = {
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 80000,
				firepower = 1,
				vCruise = 75,
				standoff = 4000,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{3EA17AB0-A805-4D9E-8732-4CE00CB00F17}",
						},
						[4] = {
							CLSID = "{3EA17AB0-A805-4D9E-8732-4CE00CB00F17}",
						},
					},
					fuel = 1250,
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
		},
		Strike = {
			Strike = {
				minscore = 0.3,
				support = {
					Escort = false,
					SEAD = false,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "All" },
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 80000,
				firepower = 1,
				vCruise = 75,
				vAttack = 85,
				hCruise = 50,
				hAttack = 50,
				standoff = 4000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{3EA17AB0-A805-4D9E-8732-4CE00CB00F17}",
						},
						[2] = {
							CLSID = "M260_HYDRA",
						},
						[3] = {
							CLSID = "M260_HYDRA",
						},
						[4] = {
							CLSID = "{3EA17AB0-A805-4D9E-8732-4CE00CB00F17}",
						},
					},
					fuel = 1250,
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
		},
	},
	["Tu-22M3"] = {
		Strike = {
			["Strike bombs - High"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Structure", "SAM" },
				code_loadout =  { "Caucasus", "WOC80" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				day = false,
				range = 900000,
				firepower = 1,
				vCruise = 250,
				vAttack = 300,
				hCruise = 6096,
				hAttack = 6096,
				sortie_rate = 2,
				stores = {
					pylons = {
						[3] = {
							CLSID = "{AD5E5863-08FC-4283-B92C-162E2B2BD3FF}",
						},
					},
					fuel = 50000,
					flare = 48,
					chaff = 48,
					gun = 100,
				},
			},
			["Strike bombs - Low"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Structure", "SAM" },
				code_loadout =  { "Caucasus", "WOC80" },
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
				sortie_rate = 2,
				stores = {
					pylons = {
						[3] = {
							CLSID = "{AD5E5863-08FC-4283-B92C-162E2B2BD3FF}",
						},
					},
					fuel = 50000,
					flare = 48,
					chaff = 48,
					gun = 100,
				},
			},
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
				sortie_rate = 2,
				stores = {
					pylons = {
						[3] = {
							CLSID = "{AD5E5863-08FC-4283-B92C-162E2B2BD3FF}",
						},
					},
					fuel = 50000,
					flare = 48,
					chaff = 48,
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
				vAttack = 500,
				hCruise = 6096,
				hAttack = 6096,
				sortie_rate = 2,
				stores = {
					pylons = {
						[3] = {
							CLSID = "{AD5E5863-08FC-4283-B92C-162E2B2BD3FF}",
						},
					},
					fuel = 50000,
					flare = 48,
					chaff = 48,
					gun = 100,
				},
			},
		},
		["Anti-ship Strike"] = {
			["Antiship  Kh-22N*1"] = {
				minscore = 0.1,
				support = {
					-- Escort = true,
					-- SEAD = false,
					-- ["Escort Jammer"] = true,
				},
				attributes =  { "ship" },
				code_loadout =  { "TF", "Caucasus", "WOC80" },
				weaponType = "ASM",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 2000000,
				firepower = 1,
				vCruise = 210,
				vAttack = 340,
				hCruise = 9000,
				hAttack = 9000,
				standoff = 280000,
				ingress = 50000,
				egress = 50000,
				MaxAttackOffset = 30,
				sortie_rate = 1,
				stores = {
					pylons = {
						-- [1] = {
						-- 	CLSID = "{12429ECF-03F0-4DF6-BCBD-5D38B6343DE1}",
						-- },
						[3] = {
							CLSID = "{12429ECF-03F0-4DF6-BCBD-5D38B6343DE1}",
						},
						-- [5] = {
						-- 	CLSID = "{12429ECF-03F0-4DF6-BCBD-5D38B6343DE1}",
						-- },
					},
					fuel = 50000,
					flare = 48,
					chaff = 48,
					gun = 100,
				},
			},
			["Antiship TF80s Kh-22N*2"] = {
				minscore = 0.1,
				support = {
					-- Escort = false,
					-- SEAD = false,
					-- ["Escort Jammer"] = true,
				},
				attributes =  { "ship" },
				code_loadout =  { "TF80s", "TF80sRED", "TF80sI" },
				weaponType = "ASM",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 2000000,
				firepower = 1,
				vCruise = 210,
				vAttack = 290,
				hCruise = 9000,
				hAttack = 9000,
				standoff = 280000,
				ingress = 50000,
				egress = 50000,
				MaxAttackOffset = 30,
				sortie_rate = 1,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{12429ECF-03F0-4DF6-BCBD-5D38B6343DE1}",
						},
						-- [3] = {
						-- 	CLSID = "{12429ECF-03F0-4DF6-BCBD-5D38B6343DE1}",
						-- },
						[5] = {
							CLSID = "{12429ECF-03F0-4DF6-BCBD-5D38B6343DE1}",
						},
					},
					fuel = 50000,
					flare = 48,
					chaff = 48,
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
				sortie_rate = 2,
				stores = {
					pylons = {
						[3] = {
							CLSID = "{AD5E5863-08FC-4283-B92C-162E2B2BD3FF}",
						},
					},
					fuel = 50000,
					flare = 48,
					chaff = 48,
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
				weaponType = "Bombs",
				expend = "All",
				night = true,
				range = 900000,
				firepower = 5,
				vCruise = 250,
				vAttack = 300,
				hCruise = 6096,
				hAttack = 6096,
				sortie_rate = 2,
				stores = {
					pylons = {
						[3] = {
							CLSID = "{AD5E5863-08FC-4283-B92C-162E2B2BD3FF}",
						},
					},
					fuel = 50000,
					flare = 48,
					chaff = 48,
					gun = 100,
				},
			},
		},
	},
	["MiG-21Bis"] = {
		Strike = {
			["IPW - Strike - R-3R*1, R-3S*1, FT800L, FAB-500*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "soft", "Parked Aircraft", "Structure" },
				code_loadout =  { "IPW71", "HWITC", "WOB" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
								range = 700000,
				firepower = 1,
				vCruise = 200,
				vAttack = 250,
				hCruise = 5500,
				hAttack = 4000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R-3R}",
						},
						[2] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
						[3] = {
							CLSID = "{PTB_800_MIG21}",
						},
						[4] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
						[5] = {
							CLSID = "{R-3S}",
						},
					},
					fuel = 2280,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
			["IPW - Strike - R-3R*1, R-3S*1, FT800L, S-24B*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "soft", "Parked Aircraft", "Structure" },
				code_loadout =  { "IPW71", "HWITC" },
				weaponType = "Rockets",
				expend = "All",
				attackType = "Dive",
								range = 700000,
				firepower = 1,
				vCruise = 200,
				vAttack = 250,
				hCruise = 1500,
				hAttack = 1000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R-3R}",
						},
						[2] = {
							CLSID = "{S-24B}",
						},
						[3] = {
							CLSID = "{PTB_800_MIG21}",
						},
						[4] = {
							CLSID = "{S-24B}",
						},
						[5] = {
							CLSID = "{R-3S}",
						},
					},
					fuel = 2280,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
			["IPW - Strike - R-3R*1, R-3S*1, FT800L, FAB-250*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "soft", "Parked Aircraft", "Structure" },
				code_loadout =  { "IPW71", "HWITC" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
								range = 700000,
				firepower = 1,
				vCruise = 200,
				vAttack = 250,
				hCruise = 5500,
				hAttack = 4000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{3C612111-C7AD-476E-8A8E-2485812F4E5C}",
						},
						[2] = {
							CLSID = "{R-3S}",
						},
						[3] = {
							CLSID = "{PTB_800_MIG21}",
						},
						[4] = {
							CLSID = "{R-3R}",
						},
						[5] = {
							CLSID = "{3C612111-C7AD-476E-8A8E-2485812F4E5C}",
						},
					},
					fuel = 2280,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
			["IPW - Strike - R-3R*1, R-3S*1, FT800L, UB16UM*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "soft", "Parked Aircraft" },
				code_loadout =  { "IPW71", "HWITC" },
				weaponType = "Rockets",
				expend = "All",
				attackType = "Dive",
								range = 700000,
				firepower = 1,
				vCruise = 200,
				vAttack = 250,
				hCruise = 1500,
				hAttack = 1000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R-3R}",
						},
						[2] = {
							CLSID = "{UB-16_S5M}",
						},
						[3] = {
							CLSID = "{PTB_800_MIG21}",
						},
						[4] = {
							CLSID = "{UB-16_S5M}",
						},
						[5] = {
							CLSID = "{R-3S}",
						},
					},
					fuel = 2280,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
			["GTA strike 1 S24*4 FT800L"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "soft", "Parked Aircraft", "Structure", "SAM" },
				code_loadout =  { "HWITC" },
				weaponType = "Rockets",
				expend = "All",
				adverseWeather = true,
				range = 700000,
				firepower = 1,
				vCruise = 200,
				vAttack = 250,
				hCruise = 1500,
				hAttack = 1000,
				sortie_rate = 8,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{S-24A}",
						},
						[2] = {
							CLSID = "{S-24A}",
						},
						[3] = {
							CLSID = "{PTB_800_MIG21}",
						},
						[4] = {
							CLSID = "{S-24A}",
						},
						[5] = {
							CLSID = "{S-24A}",
						},
						[6] = {
							CLSID = "{ASO-2}",
						},
					},
					fuel = 2280,
					flare = 40,
					chaff = 18,
					gun = 100,
				},
			},
		},
		["Anti-ship Strike"] = {
			["Antiship IPW R-3R*1, R-3S*1, FT800L, S-24B*2"] = {
				minscore = 0.3,
				support = {
					SEAD = false,
					Escort = true,
					["Laser Illumination"] = false,
				},
				attributes =  { "ship" },
				code_loadout =  { "IPW71" },
				weaponType = "Rockets",
				expend = "Auto",
				attackType = "Dive",
								range = 600000,
				firepower = 1,
				vCruise = 200,
				vAttack = 250,
				hCruise = 5486.4,
				hAttack = 4572,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R-3R}",
						},
						[2] = {
							CLSID = "{S-24B}",
						},
						[3] = {
							CLSID = "{PTB_800_MIG21}",
						},
						[4] = {
							CLSID = "{S-24B}",
						},
						[5] = {
							CLSID = "{R-3S}",
						},
					},
					fuel = 2280,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
			["IPW - Antiship Strike - R-3R*1, R-3S*1, FT800L, FAB-500*2"] = {
				minscore = 0.3,
				support = {
					SEAD = false,
					Escort = true,
					["Laser Illumination"] = false,
				},
				attributes =  { "ship" },
				code_loadout =  { "IPW71" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
								range = 600000,
				firepower = 1,
				vCruise = 200,
				vAttack = 250,
				hCruise = 5000,
				hAttack = 5000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R-3R}",
						},
						[2] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
						[3] = {
							CLSID = "{PTB_800_MIG21}",
						},
						[4] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
						[5] = {
							CLSID = "{R-3S}",
						},
					},
					fuel = 2280,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		Escort = {
			["TF-Old-R-3R*2,R-60M*4,FT,ASO2"] = {
				attributes =  { },
				code_loadout =  { "TF80s", "TF80sRED", "TF80sI", "WOC80" },
				night = true,
				adverseWeather = true,
				range = 600000,
				firepower = 1,
				vCruise = 250,
				vAttack = 350,
				hCruise = 7500,
				hAttack = 5500,
				standoff = 20000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R-3R}",
						},
						[2] = {
							CLSID = "{R-60M 2L}",
						},
						[3] = {
							CLSID = "{PTB_800_MIG21}",
						},
						[4] = {
							CLSID = "{R-60M 2R}",
						},
						[5] = {
							CLSID = "{R-3R}",
						},
						[6] = {
							CLSID = "{ASO-2}",
						},
					},
					fuel = 2280,
					flare = 40,
					chaff = 18,
					gun = 100,
				},
			},
			["TF-Old-R-3R*2,R-3S*2,FT,ASO2"] = {
				attributes =  { },
				code_loadout =  { "TF80s", "TF80sRED", "TF80sI", "WOC80" },
				night = true,
				adverseWeather = true,
				range = 600000,
				firepower = 1,
				vCruise = 250,
				vAttack = 350,
				hCruise = 7500,
				hAttack = 5500,
				standoff = 20000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R-3R}",
						},
						[2] = {
							CLSID = "{R-3S}",
						},
						[3] = {
							CLSID = "{PTB_800_MIG21}",
						},
						[4] = {
							CLSID = "{R-3S}",
						},
						[5] = {
							CLSID = "{R-3R}",
						},
						[6] = {
							CLSID = "{ASO-2}",
						},
					},
					fuel = 2280,
					flare = 40,
					chaff = 18,
					gun = 100,
				},
			},
			["R-60*4, R-3R*2, Fuel_450*1"] = {
				attributes =  { },
				code_loadout =  { "IIW", "WOB" },
				night = true,
				adverseWeather = true,
				range = 532000,
				firepower = 1,
				vCruise = 225,
				standoff = 20000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R-60 2L}",
						},
						[2] = {
							CLSID = "{R-3R}",
						},
						[3] = {
							CLSID = "{PTB_800_MIG21}",
						},
						[4] = {
							CLSID = "{R-3R}",
						},
						[5] = {
							CLSID = "{R-60 2R}",
						},
						[6] = {
							CLSID = "{ASO-2}",
						},
					},
					fuel = 2280,
					flare = 40,
					chaff = 18,
					gun = 100,
				},
			},
			["IPW R-3R*2, R-3S*2, FT800L"] = {
				attributes =  { },
				code_loadout =  { "IPW71" },
								range = 700000,
				firepower = 1,
				vCruise = 200,
				standoff = 10000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R-3R}",
						},
						[2] = {
							CLSID = "{R-3S}",
						},
						[3] = {
							CLSID = "{PTB_800_MIG21}",
						},
						[4] = {
							CLSID = "{R-3S}",
						},
						[5] = {
							CLSID = "{R-3R}",
						},
					},
					fuel = 2280,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
			["GTA AIR/AIR ,R-60*4, R-13M*2, FT, ASO"] = {
				attributes =  { },
				code_loadout =  { "HWITC" },
				adverseWeather = true,
				range = 700000,
				firepower = 1,
				vCruise = 250,
				standoff = 10000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R-60 2L}",
						},
						[2] = {
							CLSID = "{R-13M}",
						},
						[3] = {
							CLSID = "{PTB_800_MIG21}",
						},
						[4] = {
							CLSID = "{R-13M}",
						},
						[5] = {
							CLSID = "{R-60 2R}",
						},
						[6] = {
							CLSID = "{ASO-2}",
						},
					},
					fuel = 2280,
					flare = 40,
					chaff = 18,
					gun = 100,
				},
			},
			["GTA AIR/AIR ,R60*4 R3R*2,FT 800L"] = {
				attributes =  { },
				code_loadout =  { },
				adverseWeather = true,
				range = 700000,
				firepower = 1,
				vCruise = 250,
				standoff = 10000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R-60 2L}",
						},
						[2] = {
							CLSID = "{R-3R}",
						},
						[3] = {
							CLSID = "{PTB_800_MIG21}",
						},
						[4] = {
							CLSID = "{R-3R}",
						},
						[5] = {
							CLSID = "{R-60 2R}",
						},
						[6] = {
							CLSID = "{ASO-2}",
						},
					},
					fuel = 2280,
					flare = 40,
					chaff = 18,
					gun = 100,
				},
			},
			["R-3R*2, R-3S*2, FT, ASO"] = {
				attributes =  { },
				code_loadout =  { "IIW" },
				night = true,
				adverseWeather = true,
				range = 542000,
				firepower = 1,
				vCruise = 225,
				standoff = 20000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R-3S}",
						},
						[2] = {
							CLSID = "{R-3R}",
						},
						[3] = {
							CLSID = "{PTB_800_MIG21}",
						},
						[4] = {
							CLSID = "{R-3R}",
						},
						[5] = {
							CLSID = "{R-3S}",
						},
						[6] = {
							CLSID = "{ASO-2}",
						},
					},
					fuel = 2280,
					flare = 40,
					chaff = 18,
					gun = 100,
				},
			},
		},
		CAP = {
			["GTA AIR/AIR Medium,R-60*4, R-13M*2, FT, ASO"] = {
				attributes =  { "medium" },
				code_loadout =  { "HWITC" },
				adverseWeather = true,
				range = 600000,
				firepower = 1,
				vCruise = 200,
				vAttack = 220,
				hCruise = 4000,
				hAttack = 4200,
				standoff = 15000,
				tStation = 2400,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R-60 2L}",
						},
						[2] = {
							CLSID = "{R-13M}",
						},
						[3] = {
							CLSID = "{PTB_800_MIG21}",
						},
						[4] = {
							CLSID = "{R-13M}",
						},
						[5] = {
							CLSID = "{R-60 2R}",
						},
						[6] = {
							CLSID = "{ASO-2}",
						},
					},
					fuel = 2280,
					flare = 40,
					chaff = 18,
					gun = 100,
				},
			},
			["GTA AIR/AIR Low,R60*4 R3R*2,FT 800L"] = {
				attributes =  { "low" },
				code_loadout =  { },
				adverseWeather = true,
				range = 600000,
				firepower = 1,
				vCruise = 200,
				vAttack = 220,
				hCruise = 2000,
				hAttack = 2000,
				standoff = 15000,
				tStation = 1800,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R-60 2L}",
						},
						[2] = {
							CLSID = "{R-3R}",
						},
						[3] = {
							CLSID = "{PTB_800_MIG21}",
						},
						[4] = {
							CLSID = "{R-3R}",
						},
						[5] = {
							CLSID = "{R-60 2R}",
						},
						[6] = {
							CLSID = "{ASO-2}",
						},
					},
					fuel = 2280,
					flare = 40,
					chaff = 18,
					gun = 100,
				},
			},
			["TF-Old-R-3R*2,R-60M*4,FT,ASO2"] = {
				attributes =  { },
				code_loadout =  { "TF80s", "TF80sRED", "TF80sI", "WOC80" },
				night = true,
				adverseWeather = true,
				range = 600000,
				firepower = 1,
				vCruise = 250,
				vAttack = 350,
				hCruise = 7500,
				hAttack = 5500,
				standoff = 20000,
				tStation = 1800,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R-3R}",
						},
						[2] = {
							CLSID = "{R-60M 2L}",
						},
						[3] = {
							CLSID = "{PTB_800_MIG21}",
						},
						[4] = {
							CLSID = "{R-60M 2R}",
						},
						[5] = {
							CLSID = "{R-3R}",
						},
						[6] = {
							CLSID = "{ASO-2}",
						},
					},
					fuel = 2280,
					flare = 40,
					chaff = 18,
					gun = 100,
				},
			},
			["TF-Old-R-3R*2,R-3S*2,FT,ASO2"] = {
				attributes =  { },
				code_loadout =  { "TF80s", "TF80sRED", "TF80sI", "WOC80" },
				night = true,
				adverseWeather = true,
				range = 600000,
				firepower = 1,
				vCruise = 250,
				vAttack = 350,
				hCruise = 7500,
				hAttack = 5500,
				standoff = 20000,
				tStation = 1800,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R-3R}",
						},
						[2] = {
							CLSID = "{R-3S}",
						},
						[3] = {
							CLSID = "{PTB_800_MIG21}",
						},
						[4] = {
							CLSID = "{R-3S}",
						},
						[5] = {
							CLSID = "{R-3R}",
						},
						[6] = {
							CLSID = "{ASO-2}",
						},
					},
					fuel = 2280,
					flare = 40,
					chaff = 18,
					gun = 100,
				},
			},
			["R-60*4, R-3R*2, Fuel_450*1"] = {
				attributes =  { },
				code_loadout =  { "IIW", "WOB" },
				night = true,
				adverseWeather = true,
				range = 600000,
				firepower = 1,
				vCruise = 250,
				vAttack = 350,
				hCruise = 7500,
				hAttack = 5500,
				standoff = 20000,
				tStation = 1800,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R-60 2L}",
						},
						[2] = {
							CLSID = "{R-3R}",
						},
						[3] = {
							CLSID = "{PTB_800_MIG21}",
						},
						[4] = {
							CLSID = "{R-3R}",
						},
						[5] = {
							CLSID = "{R-60 2R}",
						},
						[6] = {
							CLSID = "{ASO-2}",
						},
					},
					fuel = 2280,
					flare = 40,
					chaff = 18,
					gun = 100,
				},
			},
			["GTA AIR/AIR Low,R-60*4, R-13M*2, FT, ASO"] = {
				attributes =  { "low" },
				code_loadout =  { "HWITC" },
				adverseWeather = true,
				range = 600000,
				firepower = 1,
				vCruise = 200,
				vAttack = 220,
				hCruise = 2000,
				hAttack = 2000,
				standoff = 15000,
				tStation = 1800,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R-60 2L}",
						},
						[2] = {
							CLSID = "{R-13M}",
						},
						[3] = {
							CLSID = "{PTB_800_MIG21}",
						},
						[4] = {
							CLSID = "{R-13M}",
						},
						[5] = {
							CLSID = "{R-60 2R}",
						},
						[6] = {
							CLSID = "{ASO-2}",
						},
					},
					fuel = 2280,
					flare = 40,
					chaff = 18,
					gun = 100,
				},
			},
			["IPW R-3R*2, R-3S*2, FT800L"] = {
				attributes =  { },
				code_loadout =  { "IPW71" },
								range = 600000,
				firepower = 1,
				vCruise = 200,
				vAttack = 220,
				hCruise = 7500,
				hAttack = 5500,
				standoff = 20000,
				tStation = 1800,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R-3R}",
						},
						[2] = {
							CLSID = "{R-3S}",
						},
						[3] = {
							CLSID = "{PTB_800_MIG21}",
						},
						[4] = {
							CLSID = "{R-3S}",
						},
						[5] = {
							CLSID = "{R-3R}",
						},
					},
					fuel = 2280,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
			["GTA AIR/AIR Medium,R60*4 R3R*2,FT 800L"] = {
				attributes =  { "medium" },
				code_loadout =  { },
				adverseWeather = true,
				range = 600000,
				firepower = 1,
				vCruise = 200,
				vAttack = 220,
				hCruise = 4000,
				hAttack = 4200,
				standoff = 15000,
				tStation = 2400,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R-60 2L}",
						},
						[2] = {
							CLSID = "{R-3R}",
						},
						[3] = {
							CLSID = "{PTB_800_MIG21}",
						},
						[4] = {
							CLSID = "{R-3R}",
						},
						[5] = {
							CLSID = "{R-60 2R}",
						},
						[6] = {
							CLSID = "{ASO-2}",
						},
					},
					fuel = 2280,
					flare = 40,
					chaff = 18,
					gun = 100,
				},
			},
			["R-3R*2, R-3S*2, FT, ASO"] = {
				attributes =  { },
				code_loadout =  { "IIW" },
				night = true,
				adverseWeather = true,
				range = 600000,
				firepower = 1,
				vCruise = 250,
				vAttack = 350,
				hCruise = 7500,
				hAttack = 5500,
				standoff = 20000,
				tStation = 1800,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R-3S}",
						},
						[2] = {
							CLSID = "{R-3R}",
						},
						[3] = {
							CLSID = "{PTB_800_MIG21}",
						},
						[4] = {
							CLSID = "{R-3R}",
						},
						[5] = {
							CLSID = "{R-3S}",
						},
						[6] = {
							CLSID = "{ASO-2}",
						},
					},
					fuel = 2280,
					flare = 40,
					chaff = 18,
					gun = 100,
				},
			},
			["NAM - AA Intercept - AA-2Bx4"] = {
				attributes =  { },
				code_loadout =  { "NAM" },
								night = false,
				adverseWeather = false,
				range = 600000,
				firepower = 1,
				vCruise = 250,
				vAttack = 350,
				hCruise = 7500,
				hAttack = 5500,
				standoff = 20000,
				tStation = 1800,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{R-3S}",
					["num"] = 5,
				},
				[2] = {
					["CLSID"] = "{R-3S}",
					["num"] = 4,
				},
				[3] = {
					["CLSID"] = "{R-3S}",
					["num"] = 2,
				},
				[4] = {
					["CLSID"] = "{R-3S}",
					["num"] = 1,
				},
					},
					fuel = 2280,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
			["NAM - AA Intercept - AA-2Bx2"] = {
				attributes =  { },
				code_loadout =  { "NAM" },
								night = false,
				adverseWeather = false,
				range = 600000,
				firepower = 1,
				vCruise = 250,
				vAttack = 350,
				hCruise = 7500,
				hAttack = 5500,
				standoff = 20000,
				tStation = 1800,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{R-3S}",
					["num"] = 4,
				},
				[2] = {
					["CLSID"] = "{R-3S}",
					["num"] = 2,
				},
					},
					fuel = 2280,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		["Fighter Sweep"] = {
			["TF-Old-R-3R*2,R-60M*4,FT,ASO2"] = {
				attributes =  { },
				code_loadout =  { "TF80s", "TF80sRED", "TF80sI", "WOC80" },
				night = true,
				adverseWeather = true,
				range = 600000,
				firepower = 1,
				vCruise = 250,
				vAttack = 350,
				hCruise = 7500,
				hAttack = 5500,
				standoff = 20000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R-3R}",
						},
						[2] = {
							CLSID = "{R-60M 2L}",
						},
						[3] = {
							CLSID = "{PTB_800_MIG21}",
						},
						[4] = {
							CLSID = "{R-60M 2R}",
						},
						[5] = {
							CLSID = "{R-3R}",
						},
						[6] = {
							CLSID = "{ASO-2}",
						},
					},
					fuel = 2280,
					flare = 40,
					chaff = 18,
					gun = 100,
				},
			},
			["TF-Old-R-3R*2,R-3S*2,FT,ASO2"] = {
				attributes =  { },
				code_loadout =  { "TF80s", "TF80sRED", "TF80sI", "WOC80" },
				night = true,
				adverseWeather = true,
				range = 600000,
				firepower = 1,
				vCruise = 250,
				vAttack = 350,
				hCruise = 7500,
				hAttack = 5500,
				standoff = 20000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R-3R}",
						},
						[2] = {
							CLSID = "{R-3S}",
						},
						[3] = {
							CLSID = "{PTB_800_MIG21}",
						},
						[4] = {
							CLSID = "{R-3S}",
						},
						[5] = {
							CLSID = "{R-3R}",
						},
						[6] = {
							CLSID = "{ASO-2}",
						},
					},
					fuel = 2280,
					flare = 40,
					chaff = 18,
					gun = 100,
				},
			},
			["NAM sweep-AA-2Bx2"] = {
				attributes =  { },
				code_loadout =  { "NAM" },
								night = false,
				adverseWeather = false,
				range = 600000,
				firepower = 1,
				vCruise = 250,
				vAttack = 350,
				hCruise = 800,
				hAttack = 800,
				standoff = 20000,
				sortie_rate = 2,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{R-3S}",
					["num"] = 4,
				},
				[2] = {
					["CLSID"] = "{R-3S}",
					["num"] = 2,
				},
					},
					fuel = 2280,
					flare = 0,
					chaff = 0,
					gun = 100,
				},			
			},
			["R-60*4, R-3R*2, Fuel_450*1"] = {
				attributes =  { },
				code_loadout =  { "IIW", "WOB" },
				night = true,
				adverseWeather = true,
				range = 600000,
				firepower = 1,
				vCruise = 250,
				vAttack = 350,
				hCruise = 7500,
				hAttack = 5500,
				standoff = 20000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R-60 2L}",
						},
						[2] = {
							CLSID = "{R-3R}",
						},
						[3] = {
							CLSID = "{PTB_800_MIG21}",
						},
						[4] = {
							CLSID = "{R-3R}",
						},
						[5] = {
							CLSID = "{R-60 2R}",
						},
						[6] = {
							CLSID = "{ASO-2}",
						},
					},
					fuel = 2280,
					flare = 40,
					chaff = 18,
					gun = 100,
				},
			},
			["IPW R-3R*2, R-3S*2, FT800L"] = {
				self_escort = true,
				attributes =  { },
				code_loadout =  { "IPW71" },
								range = 700000,
				firepower = 1,
				vCruise = 200,
				vAttack = 250,
				hCruise = 7500,
				hAttack = 5500,
				standoff = 20000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R-3R}",
						},
						[2] = {
							CLSID = "{R-3S}",
						},
						[3] = {
							CLSID = "{PTB_800_MIG21}",
						},
						[4] = {
							CLSID = "{R-3S}",
						},
						[5] = {
							CLSID = "{R-3R}",
						},
					},
					fuel = 2280,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
			["GTA AIR/AIR ,R-60*4, R-13M*2, FT, ASO"] = {
				self_escort = true,
				attributes =  { },
				code_loadout =  { "HWITC" },
				night = true,
				adverseWeather = true,
				range = 700000,
				firepower = 1,
				vCruise = 225,
				vAttack = 250,
				hCruise = 7500,
				hAttack = 5500,
				standoff = 20000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R-60 2L}",
						},
						[2] = {
							CLSID = "{R-13M}",
						},
						[3] = {
							CLSID = "{PTB_800_MIG21}",
						},
						[4] = {
							CLSID = "{R-13M}",
						},
						[5] = {
							CLSID = "{R-60 2R}",
						},
						[6] = {
							CLSID = "{ASO-2}",
						},
					},
					fuel = 2280,
					flare = 40,
					chaff = 18,
					gun = 100,
				},
			},
			["GTA AIR/AIR ,R60*4 R3R*2,FT 800L"] = {
				self_escort = true,
				attributes =  { },
				code_loadout =  { },
				night = true,
				adverseWeather = true,
				range = 700000,
				firepower = 1,
				vCruise = 225,
				vAttack = 250,
				hCruise = 7500,
				hAttack = 5500,
				standoff = 20000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R-60 2L}",
						},
						[2] = {
							CLSID = "{R-3R}",
						},
						[3] = {
							CLSID = "{PTB_800_MIG21}",
						},
						[4] = {
							CLSID = "{R-3R}",
						},
						[5] = {
							CLSID = "{R-60 2R}",
						},
						[6] = {
							CLSID = "{ASO-2}",
						},
					},
					fuel = 2280,
					flare = 40,
					chaff = 18,
					gun = 100,
				},
			},
			["R-3R*2, R-3S*2, FT, ASO"] = {
				attributes =  { },
				code_loadout =  { "IIW" },
				night = true,
				adverseWeather = true,
				range = 600000,
				firepower = 1,
				vCruise = 250,
				vAttack = 350,
				hCruise = 7500,
				hAttack = 5500,
				standoff = 20000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R-3S}",
						},
						[2] = {
							CLSID = "{R-3R}",
						},
						[3] = {
							CLSID = "{PTB_800_MIG21}",
						},
						[4] = {
							CLSID = "{R-3R}",
						},
						[5] = {
							CLSID = "{R-3S}",
						},
						[6] = {
							CLSID = "{ASO-2}",
						},
					},
					fuel = 2280,
					flare = 40,
					chaff = 18,
					gun = 100,
				},
			},
		},
		Intercept = {
			["R-60*4, R-3R*2, Fuel_800*1"] = {
				attributes =  { },
				code_loadout =  { "IIW" },
				night = true,
				adverseWeather = true,
				range = 600000,
				firepower = 1,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R-60 2L}",
						},
						[2] = {
							CLSID = "{R-3R}",
						},
						[3] = {
							CLSID = "{PTB_490C_MIG21}",
						},
						[4] = {
							CLSID = "{R-3R}",
						},
						[5] = {
							CLSID = "{R-60 2R}",
						},
						[6] = {
							CLSID = "{ASO-2}",
						},
					},
					fuel = 2280,
					flare = 40,
					chaff = 18,
					gun = 100,
				},
			},
			["TF-Old-R-3R*2,R-3S*2,FT,ASO2"] = {
				attributes =  { },
				code_loadout =  { "TF80s", "TF80sRED", "TF80sI", "WOC80" },
				night = true,
				adverseWeather = true,
				range = 600000,
				firepower = 1,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R-3R}",
						},
						[2] = {
							CLSID = "{R-3S}",
						},
						[3] = {
							CLSID = "{PTB_800_MIG21}",
						},
						[4] = {
							CLSID = "{R-3S}",
						},
						[5] = {
							CLSID = "{R-3R}",
						},
						[6] = {
							CLSID = "{ASO-2}",
						},
					},
					fuel = 2280,
					flare = 40,
					chaff = 18,
					gun = 100,
				},
			},
			["NAM - AA Intercept - AA-2Bx2"] = {
				attributes =  { },
				code_loadout =  { "NAM" },
				night = true,
				adverseWeather = true,
				range = 600000,
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
					["num"] = 2,
				},
					},
					fuel = 2280,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
			["IPW R-3R*2, R-3S*2, FT800L"] = {
				attributes =  { },
				code_loadout =  { "IPW71" },
								range = 600000,
				firepower = 1,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R-3R}",
						},
						[2] = {
							CLSID = "{R-3S}",
						},
						[3] = {
							CLSID = "{PTB_800_MIG21}",
						},
						[4] = {
							CLSID = "{R-3S}",
						},
						[5] = {
							CLSID = "{R-3R}",
						},
					},
					fuel = 2280,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
			["CAP R-60*4, R-13M*2, FT, ASO"] = {
				attributes =  { },
				code_loadout =  { "HWITC", "WOB" },
				night = true,
				adverseWeather = true,
				range = 600000,
				firepower = 1,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R-60 2L}",
						},
						[2] = {
							CLSID = "{R-13M}",
						},
						[3] = {
							CLSID = "{PTB_800_MIG21}",
						},
						[4] = {
							CLSID = "{R-13M}",
						},
						[5] = {
							CLSID = "{R-60 2R}",
						},
						[6] = {
							CLSID = "{ASO-2}",
						},
					},
					fuel = 2280,
					flare = 40,
					chaff = 18,
					gun = 100,
				},
			},
			["GTA AIR/AIR ,R60*4 R3R*2,FT 800L"] = {
				attributes =  { },
				code_loadout =  { "WOB" },
				adverseWeather = true,
				range = 600000,
				firepower = 1,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R-60 2L}",
						},
						[2] = {
							CLSID = "{R-3R}",
						},
						[3] = {
							CLSID = "{PTB_800_MIG21}",
						},
						[4] = {
							CLSID = "{R-3R}",
						},
						[5] = {
							CLSID = "{R-60 2R}",
						},
						[6] = {
							CLSID = "{ASO-2}",
						},
					},
					fuel = 2280,
					flare = 40,
					chaff = 18,
					gun = 100,
				},
			},
		},
	},
	["F-100D"] = {
		SEAD = {
			["NAM - SEAD - FT*2 - AGM-45*2 - RKT*38"] = {
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
					["CLSID"] = "{GD_F100_STRIKE_CAMERA}",
					["num"] = 8,
				},
				[2] = {
					["CLSID"] = "{GD_F100_450_GAL_TANK}",
					["num"] = 6,
				},
				[3] = {
					["CLSID"] = "{GD_F100_450_GAL_TANK}",
					["num"] = 2,
				},
				[4] = {
					["CLSID"] = "{LAU3_FFAR_MK5HEAT}",
					["num"] = 7,
				},
				[5] = {
					["CLSID"] = "{LAU3_FFAR_MK5HEAT}",
					["num"] = 1,
				},
				[6] = {
					["CLSID"] = "{AGM_45A}",
					["num"] = 5,
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
				[7] = {
					["CLSID"] = "{AGM_45A}",
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
					fuel = 3505.4,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		Strike = {
			["NAM - Strike - FT*2 - Snakeyes*8"] = {
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
				range = 600000,
				firepower = 0.5,
				vCruise = 200,
				vAttack = 350,
				hCruise = 500,
				hAttack = 50,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{GD_F100_STRIKE_CAMERA}",
					["num"] = 8,
				},
				[2] = {
					["CLSID"] = "{GD_F100_335_GAL_TANK_R}",
					["num"] = 6,
				},
				[3] = {
					["CLSID"] = "{GD_F100_335_GAL_TANK_L}",
					["num"] = 2,
				},
				[4] = {
					["CLSID"] = "{Mk82SNAKEYE}",
					["num"] = 7,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_M904E4"] = 4,
						["00_prfx_function_delay_ctrl_M904E4"] = 0,
						["01_prfx_arm_delay_ctrl_M905"] = 4,
						["01_prfx_function_delay_ctrl_M905"] = 0,
						["NFP_PRESID"] = "MDRN_B_A_GPHD",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
					},
				},
				[5] = {
					["CLSID"] = "{Mk82SNAKEYE}",
					["num"] = 1,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_M904E4"] = 4,
						["00_prfx_function_delay_ctrl_M904E4"] = 0,
						["01_prfx_arm_delay_ctrl_M905"] = 4,
						["01_prfx_function_delay_ctrl_M905"] = 0,
						["NFP_PRESID"] = "MDRN_B_A_GPHD",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
					},
				},
				[6] = {
					["CLSID"] = "{GD_F100_TER_MK-82_Snakeye_x3}",
					["num"] = 5,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_M904E4"] = 4,
						["00_prfx_function_delay_ctrl_M904E4"] = 0,
						["01_prfx_arm_delay_ctrl_M905"] = 4,
						["01_prfx_function_delay_ctrl_M905"] = 0,
						["NFP_PRESID"] = "MDRN_B_A_GPHD",
						["NFP_PRESVER"] = 2,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
					},
				},
				[7] = {
					["CLSID"] = "{GD_F100_TER_MK-82_Snakeye_x3}",
					["num"] = 3,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_M904E4"] = 4,
						["00_prfx_function_delay_ctrl_M904E4"] = 0,
						["01_prfx_arm_delay_ctrl_M905"] = 4,
						["01_prfx_function_delay_ctrl_M905"] = 0,
						["NFP_PRESID"] = "MDRN_B_A_GPHD",
						["NFP_PRESVER"] = 2,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
					},
				},
					},
					fuel = 3505.4,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
			["NAM - Strike - FT*2 - Snackeye*3 - AIM-9J*2 - RKT*38"] = {
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
				range = 600000,
				firepower = 0.5,
				vCruise = 200,
				vAttack = 350,
				hCruise = 500,
				hAttack = 50,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{GD_F100_STRIKE_CAMERA}",
					["num"] = 8,
				},
				[2] = {
					["CLSID"] = "{GD_F100_335_GAL_TANK_R}",
					["num"] = 6,
				},
				[3] = {
					["CLSID"] = "{GD_F100_335_GAL_TANK_L}",
					["num"] = 2,
				},
				[4] = {
					["CLSID"] = "{LAU3_FFAR_MK5HEAT}",
					["num"] = 7,
				},
				[5] = {
					["CLSID"] = "{LAU3_FFAR_MK5HEAT}",
					["num"] = 1,
				},
				[6] = {
					["CLSID"] = "{GD_F100_TER_MK-82_Snakeye_x3}",
					["num"] = 5,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_M904E4"] = 4,
						["00_prfx_function_delay_ctrl_M904E4"] = 0,
						["01_prfx_arm_delay_ctrl_M905"] = 4,
						["01_prfx_function_delay_ctrl_M905"] = 0,
						["NFP_PRESID"] = "MDRN_B_A_GPHD",
						["NFP_PRESVER"] = 2,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
					},
				},
				[7] = {
					["CLSID"] = "{GD_F100_AIM-9J_x2}",
					["num"] = 3,
				},
					},
					fuel = 3505.4,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
			["NAM - Strike - FT*2 - Snackeye*6 - RKT*38"] = {
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
				range = 600000,
				firepower = 0.5,
				vCruise = 200,
				vAttack = 350,
				hCruise = 500,
				hAttack = 50,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{GD_F100_STRIKE_CAMERA}",
					["num"] = 8,
				},
				[2] = {
					["CLSID"] = "{GD_F100_335_GAL_TANK_R}",
					["num"] = 6,
				},
				[3] = {
					["CLSID"] = "{GD_F100_335_GAL_TANK_L}",
					["num"] = 2,
				},
				[4] = {
					["CLSID"] = "{LAU3_FFAR_MK5HEAT}",
					["num"] = 7,
				},
				[5] = {
					["CLSID"] = "{LAU3_FFAR_MK5HEAT}",
					["num"] = 1,
				},
				[6] = {
					["CLSID"] = "{GD_F100_TER_MK-82_Snakeye_x3}",
					["num"] = 5,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_M904E4"] = 4,
						["00_prfx_function_delay_ctrl_M904E4"] = 0,
						["01_prfx_arm_delay_ctrl_M905"] = 4,
						["01_prfx_function_delay_ctrl_M905"] = 0,
						["NFP_PRESID"] = "MDRN_B_A_GPHD",
						["NFP_PRESVER"] = 2,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
					},
				},
				[7] = {
					["CLSID"] = "{GD_F100_TER_MK-82_Snakeye_x3}",
					["num"] = 3,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_M904E4"] = 4,
						["00_prfx_function_delay_ctrl_M904E4"] = 0,
						["01_prfx_arm_delay_ctrl_M905"] = 4,
						["01_prfx_function_delay_ctrl_M905"] = 0,
						["NFP_PRESID"] = "MDRN_B_A_GPHD",
						["NFP_PRESVER"] = 2,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
					},
				},
					},
					fuel = 3505.4,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
			["NAM - Strike - FT*2 - MK-83*2"] = {
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
					["CLSID"] = "{GD_F100_STRIKE_CAMERA}",
					["num"] = 8,
				},
				[2] = {
					["CLSID"] = "{GD_F100_335_GAL_TANK_R}",
					["num"] = 6,
				},
				[3] = {
					["CLSID"] = "{GD_F100_335_GAL_TANK_L}",
					["num"] = 2,
				},
				[4] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 7,
				},
				[5] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 1,
				},
				[6] = {
					["CLSID"] = "{7A44FF09-527C-4B7E-B42B-3F111CFE50FB}",
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
				[7] = {
					["CLSID"] = "{7A44FF09-527C-4B7E-B42B-3F111CFE50FB}",
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
					fuel = 3505.4,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
			["NAM - Strike - FT*2 - Mk-82*8"] = {
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
					["CLSID"] = "{GD_F100_STRIKE_CAMERA}",
					["num"] = 8,
				},
				[2] = {
					["CLSID"] = "{GD_F100_335_GAL_TANK_R}",
					["num"] = 6,
				},
				[3] = {
					["CLSID"] = "{GD_F100_335_GAL_TANK_L}",
					["num"] = 2,
				},
				[4] = {
					["CLSID"] = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
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
				[5] = {
					["CLSID"] = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
					["num"] = 1,
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
				[6] = {
					["CLSID"] = "{GD_F100_TER_MK-82_x3}",
					["num"] = 5,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_M904E4"] = 4,
						["00_prfx_function_delay_ctrl_M904E4"] = 0,
						["01_prfx_arm_delay_ctrl_M905"] = 4,
						["01_prfx_function_delay_ctrl_M905"] = 0,
						["NFP_PRESID"] = "MDRN_B_A_GPLD",
						["NFP_PRESVER"] = 2,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
					},
				},
				[7] = {
					["CLSID"] = "{GD_F100_TER_MK-82_x3}",
					["num"] = 3,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_M904E4"] = 4,
						["00_prfx_function_delay_ctrl_M904E4"] = 0,
						["01_prfx_arm_delay_ctrl_M905"] = 4,
						["01_prfx_function_delay_ctrl_M905"] = 0,
						["NFP_PRESID"] = "MDRN_B_A_GPLD",
						["NFP_PRESVER"] = 2,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
					},
				},
					},
					fuel = 3505.4,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
	},
	["F-5E-3"] = {
		Strike = {
			["WOC80 Strike LR AG - AIM-9P5x2 - Mk-82HDx7 - FTx2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				country = {
					[1] = "Canada",
				},
				attributes =  { "frontline" },
				code_loadout =  { "WOC80" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
								range = 378000,
				firepower = 1,
				vCruise = 177,
				vAttack = 200,
				hCruise = 5156,
				hAttack = 3000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9P5}",
						},
						[2] = {
							CLSID = "{Mk82SNAKEYE}",
							settings = {
								["function_delay_ctrl_M905"] = 0,
								["arm_delay_ctrl_M904E4"] = 2,
								["arm_delay_ctrl_M905"] = 4,
								["NFP_VIS_DrawArgNo_57"] = 0,
								NFP_fuze_type_tail = "M905",
								NFP_fuze_type_nose = "M904E4",
								["function_delay_ctrl_M904E4"] = 0,
							},
						},
						[3] = {
							CLSID = "{PTB-150GAL}",
						},
						[4] = {
							CLSID = "{MER-5E_Mk82SNAKEYEx5}",
							settings = {
								["function_delay_ctrl_M905"] = 0,
								["arm_delay_ctrl_M904E4"] = 2,
								["arm_delay_ctrl_M905"] = 4,
								["NFP_VIS_DrawArgNo_57"] = 0,
								NFP_fuze_type_tail = "M905",
								NFP_fuze_type_nose = "M904E4",
								["function_delay_ctrl_M904E4"] = 0,
							},
						},
						[5] = {
							CLSID = "{PTB-150GAL}",
						},
						[6] = {
							CLSID = "{Mk82SNAKEYE}",
							settings = {
								["function_delay_ctrl_M905"] = 0,
								["arm_delay_ctrl_M904E4"] = 2,
								["arm_delay_ctrl_M905"] = 4,
								["NFP_VIS_DrawArgNo_57"] = 0,
								NFP_fuze_type_tail = "M905",
								NFP_fuze_type_nose = "M904E4",
								["function_delay_ctrl_M904E4"] = 0,
							},
						},
						[7] = {
							CLSID = "{AIM-9P5}",
						},
					},
					fuel = 2046,
					flare = 15,
					ammo_type = 1,
					chaff = 30,
					gun = 100,
				},
			},
			["Iran - AG - LR - AIM-9Jx2 - Mk-82LDx7 - FTx2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				country = {
					[1] = "Iran",
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "Structure" },
				code_loadout =  { "IIW", "Crisis", "PG" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
								range = 378000,
				firepower = 1,
				vCruise = 177,
				vAttack = 200,
				hCruise = 5156,
				hAttack = 3000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9J}",
						},
						[2] = {
							CLSID = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
							settings = {
								["function_delay_ctrl_M905"] = 0,
								["arm_delay_ctrl_M904E4"] = 2,
								["arm_delay_ctrl_M905"] = 4,
								["NFP_VIS_DrawArgNo_57"] = 0,
								NFP_fuze_type_tail = "M905",
								NFP_fuze_type_nose = "M904E4",
								["function_delay_ctrl_M904E4"] = 0,
							},
						},
						[3] = {
							CLSID = "{PTB-150GAL}",
						},
						[4] = {
							CLSID = "{MER-5E_MK82x5}",
							settings = {
								["function_delay_ctrl_M905"] = 0,
								["arm_delay_ctrl_M904E4"] = 2,
								["arm_delay_ctrl_M905"] = 4,
								["NFP_VIS_DrawArgNo_57"] = 0,
								NFP_fuze_type_tail = "M905",
								NFP_fuze_type_nose = "M904E4",
								["function_delay_ctrl_M904E4"] = 0,
							},
						},
						[5] = {
							CLSID = "{PTB-150GAL}",
						},
						[6] = {
							CLSID = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
							settings = {
								["function_delay_ctrl_M905"] = 0,
								["arm_delay_ctrl_M904E4"] = 2,
								["arm_delay_ctrl_M905"] = 4,
								["NFP_VIS_DrawArgNo_57"] = 0,
								NFP_fuze_type_tail = "M905",
								NFP_fuze_type_nose = "M904E4",
								["function_delay_ctrl_M904E4"] = 0,
							},
						},
						[7] = {
							CLSID = "{AIM-9J}",
						},
					},
					fuel = 2046,
					flare = 15,
					ammo_type = 1,
					chaff = 30,
					gun = 100,
				},
			},
			["Cyprus Strike LR  AIM-9P5x2 - Mk-82HDx7 - FTx2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				country = {
					[1] = "Turkey",
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "Cyprus" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
								range = 378000,
				firepower = 1,
				vCruise = 177,
				vAttack = 200,
				hCruise = 5156,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9P5}",
						},
						[2] = {
							CLSID = "{Mk82SNAKEYE}",
							settings = {
								["function_delay_ctrl_M905"] = 0,
								["arm_delay_ctrl_M904E4"] = 2,
								["arm_delay_ctrl_M905"] = 4,
								["NFP_VIS_DrawArgNo_57"] = 0,
								NFP_fuze_type_tail = "M905",
								NFP_fuze_type_nose = "M904E4",
								["function_delay_ctrl_M904E4"] = 0,
							},
						},
						[3] = {
							CLSID = "{PTB-150GAL}",
						},
						[4] = {
							CLSID = "{MER-5E_Mk82SNAKEYEx5}",
							settings = {
								["function_delay_ctrl_M905"] = 0,
								["arm_delay_ctrl_M904E4"] = 2,
								["arm_delay_ctrl_M905"] = 4,
								["NFP_VIS_DrawArgNo_57"] = 0,
								NFP_fuze_type_tail = "M905",
								NFP_fuze_type_nose = "M904E4",
								["function_delay_ctrl_M904E4"] = 0,
							},
						},
						[5] = {
							CLSID = "{PTB-150GAL}",
						},
						[6] = {
							CLSID = "{Mk82SNAKEYE}",
							settings = {
								["function_delay_ctrl_M905"] = 0,
								["arm_delay_ctrl_M904E4"] = 2,
								["arm_delay_ctrl_M905"] = 4,
								["NFP_VIS_DrawArgNo_57"] = 0,
								NFP_fuze_type_tail = "M905",
								NFP_fuze_type_nose = "M904E4",
								["function_delay_ctrl_M904E4"] = 0,
							},
						},
						[7] = {
							CLSID = "{AIM-9P5}",
						},
					},
					fuel = 2046,
					flare = 15,
					ammo_type = 1,
					chaff = 30,
					gun = 100,
				},
			},
			["Cyprus Strike LR AG - AIM-9P5x2 - Mk-84LD - FTx2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				country = {
					[1] = "Turkey",
				},
				attributes =  { "Structure" },
				code_loadout =  { "Cyprus" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
								range = 500000,
				firepower = 1,
				vCruise = 177,
				vAttack = 200,
				hCruise = 4500,
				hAttack = 3000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9P5}",
						},
						[3] = {
							CLSID = "{PTB-150GAL}",
						},
						[4] = {
							CLSID = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
							settings = {
								["function_delay_ctrl_M905"] = 0,
								["arm_delay_ctrl_M904E4"] = 2,
								["arm_delay_ctrl_M905"] = 4,
								["NFP_VIS_DrawArgNo_57"] = 0,
								NFP_fuze_type_tail = "M905",
								NFP_fuze_type_nose = "M904E4",
								["function_delay_ctrl_M904E4"] = 0,
							},
						},
						[5] = {
							CLSID = "{PTB-150GAL}",
						},
						[7] = {
							CLSID = "{AIM-9P5}",
						},
					},
					fuel = 2046,
					flare = 15,
					ammo_type = 1,
					chaff = 30,
					gun = 100,
				},
			},
			["Cyprus Strike LR Mk-82*7,AIM-9P5*2,Fuel 275*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				country = {
					[1] = "Turkey",
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "Cyprus" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
								range = 500000,
				firepower = 1,
				vCruise = 177,
				vAttack = 200,
				hCruise = 4500,
				hAttack = 3000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9P5}",
						},
						[2] = {
							CLSID = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
							settings = {
								["function_delay_ctrl_M905"] = 0,
								["arm_delay_ctrl_M904E4"] = 2,
								["arm_delay_ctrl_M905"] = 4,
								["NFP_VIS_DrawArgNo_57"] = 0,
								NFP_fuze_type_tail = "M905",
								NFP_fuze_type_nose = "M904E4",
								["function_delay_ctrl_M904E4"] = 0,
							},
						},
						[3] = {
							CLSID = "{PTB-150GAL}",
						},
						[4] = {
							CLSID = "{MER-5E_MK82x5}",
							settings = {
								["function_delay_ctrl_M905"] = 0,
								["arm_delay_ctrl_M904E4"] = 2,
								["arm_delay_ctrl_M905"] = 4,
								["NFP_VIS_DrawArgNo_57"] = 0,
								NFP_fuze_type_tail = "M905",
								NFP_fuze_type_nose = "M904E4",
								["function_delay_ctrl_M904E4"] = 0,
							},
						},
						[5] = {
							CLSID = "{PTB-150GAL}",
						},
						[6] = {
							CLSID = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
							settings = {
								["function_delay_ctrl_M905"] = 0,
								["arm_delay_ctrl_M904E4"] = 2,
								["arm_delay_ctrl_M905"] = 4,
								["NFP_VIS_DrawArgNo_57"] = 0,
								NFP_fuze_type_tail = "M905",
								NFP_fuze_type_nose = "M904E4",
								["function_delay_ctrl_M904E4"] = 0,
							},
						},
						[7] = {
							CLSID = "{AIM-9P5}",
						},
					},
					fuel = 2046,
					flare = 15,
					ammo_type = 1,
					chaff = 30,
					gun = 100,
				},
			},
			["Iran - AG - LR - AIM-9Jx2 - Mk-84LD - FTx2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				country = {
					[1] = "Iran",
				},
				attributes =  { "Structure" },
				code_loadout =  { "IIW", "Crisis", "PG" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
								range = 570000,
				firepower = 1,
				vCruise = 197,
				vAttack = 200,
				hCruise = 5812,
				hAttack = 3000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9J}",
						},
						[3] = {
							CLSID = "{PTB-150GAL}",
						},
						[4] = {
							CLSID = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
							settings = {
								["function_delay_ctrl_M905"] = 0,
								["arm_delay_ctrl_M904E4"] = 2,
								["arm_delay_ctrl_M905"] = 4,
								["NFP_VIS_DrawArgNo_57"] = 0,
								NFP_fuze_type_tail = "M905",
								NFP_fuze_type_nose = "M904E4",
								["function_delay_ctrl_M904E4"] = 0,
							},
						},
						[5] = {
							CLSID = "{PTB-150GAL}",
						},
						[7] = {
							CLSID = "{AIM-9J}",
						},
					},
					fuel = 2046,
					flare = 15,
					ammo_type = 1,
					chaff = 30,
					gun = 100,
				},
			},
			["GTA CAS1/STRIKE Mk-82SE*4,AIM-9P*2,Fuel 275"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				country = {
					[1] = "Turkey",
				},
				attributes =  { "Bridge", "soft", "Parked Aircraft", "Structure", "SAM" },
				code_loadout =  { "HWITC" },
				weaponType = "Bombs",
				expend = "All",
				adverseWeather = true,
				range = 360000,
				firepower = 1,
				vCruise = 177,
				vAttack = 200,
				hCruise = 4500,
				hAttack = 3000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{9BFD8C90-F7AE-4e90-833B-BFD0CED0E536}",
						},
						[2] = {
							CLSID = "{Mk82SNAKEYE}",
						},
						[3] = {
							CLSID = "{Mk82SNAKEYE}",
						},
						[4] = {
							CLSID = "{0395076D-2F77-4420-9D33-087A4398130B}",
						},
						[5] = {
							CLSID = "{Mk82SNAKEYE}",
						},
						[6] = {
							CLSID = "{Mk82SNAKEYE}",
						},
						[7] = {
							CLSID = "{9BFD8C90-F7AE-4e90-833B-BFD0CED0E536}",
						},
					},
					fuel = 2046,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
			["WOC80 Strike LR Mk-82*7,AIM-9P5*2,Fuel 275*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				country = {
					[1] = "Canada",
				},
				attributes =  { "frontline" },
				code_loadout =  { "WOC80" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
								range = 500000,
				firepower = 1,
				vCruise = 177,
				vAttack = 200,
				hCruise = 4500,
				hAttack = 3000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9P5}",
						},
						[2] = {
							CLSID = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
							settings = {
								["function_delay_ctrl_M905"] = 0,
								["arm_delay_ctrl_M904E4"] = 2,
								["arm_delay_ctrl_M905"] = 4,
								["NFP_VIS_DrawArgNo_57"] = 0,
								NFP_fuze_type_tail = "M905",
								NFP_fuze_type_nose = "M904E4",
								["function_delay_ctrl_M904E4"] = 0,
							},
						},
						[3] = {
							CLSID = "{PTB-150GAL}",
						},
						[4] = {
							CLSID = "{MER-5E_MK82x5}",
							settings = {
								["function_delay_ctrl_M905"] = 0,
								["arm_delay_ctrl_M904E4"] = 2,
								["arm_delay_ctrl_M905"] = 4,
								["NFP_VIS_DrawArgNo_57"] = 0,
								NFP_fuze_type_tail = "M905",
								NFP_fuze_type_nose = "M904E4",
								["function_delay_ctrl_M904E4"] = 0,
							},
						},
						[5] = {
							CLSID = "{PTB-150GAL}",
						},
						[6] = {
							CLSID = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
							settings = {
								["function_delay_ctrl_M905"] = 0,
								["arm_delay_ctrl_M904E4"] = 2,
								["arm_delay_ctrl_M905"] = 4,
								["NFP_VIS_DrawArgNo_57"] = 0,
								NFP_fuze_type_tail = "M905",
								NFP_fuze_type_nose = "M904E4",
								["function_delay_ctrl_M904E4"] = 0,
							},
						},
						[7] = {
							CLSID = "{AIM-9P5}",
						},
					},
					fuel = 2046,
					flare = 15,
					ammo_type = 1,
					chaff = 30,
					gun = 100,
				},
			},
			["NAM - AG - AIM-9Jx2 - FTx2 - Mk-82LDx7"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
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
				vCruise = 177,
				vAttack = 200,
				hCruise = 4500,
				hAttack = 3000,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 7,
				},
				[2] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 1,
				},
				[3] = {
					["CLSID"] = "{0395076D-2F77-4420-9D33-087A4398130B}",
					["num"] = 5,
				},
				[4] = {
					["CLSID"] = "{0395076D-2F77-4420-9D33-087A4398130B}",
					["num"] = 3,
				},
				[5] = {
					["CLSID"] = "{MER-5E_MK82x5}",
					["num"] = 4,
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
				[6] = {
					["CLSID"] = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
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
				[7] = {
					["CLSID"] = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
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
					},
					fuel = 2046,
					flare = 15,
					ammo_type = 1,
					chaff = 30,
					gun = 100,
				},
			},
			["NAM - AG - AIM-9Jx2 - FTx2 - Mk-82HDx7"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
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
				vCruise = 177,
				vAttack = 200,
				hCruise = 4500,
				hAttack = 200,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 7,
				},
				[2] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 1,
				},
				[3] = {
					["CLSID"] = "{0395076D-2F77-4420-9D33-087A4398130B}",
					["num"] = 5,
				},
				[4] = {
					["CLSID"] = "{0395076D-2F77-4420-9D33-087A4398130B}",
					["num"] = 3,
				},
				[5] = {
					["CLSID"] = "{MER-5E_Mk82SNAKEYEx5}",
					["num"] = 4,
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
				[6] = {
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
				[7] = {
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
					},
					fuel = 2046,
					flare = 15,
					ammo_type = 1,
					chaff = 30,
					gun = 100,
				},
			},
			["NAM - AG - AIM-9Jx2 - FTx2 - Mk-84LD"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				country = {
					[1] = "USA",
				},
				attributes =  { "Bridge", "Structure" },
				code_loadout =  { "NAM" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
								range = 500000,
				firepower = 1,
				vCruise = 177,
				vAttack = 200,
				hCruise = 4500,
				hAttack = 3000,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 7,
				},
				[2] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 1,
				},
				[3] = {
					["CLSID"] = "{0395076D-2F77-4420-9D33-087A4398130B}",
					["num"] = 5,
				},
				[4] = {
					["CLSID"] = "{0395076D-2F77-4420-9D33-087A4398130B}",
					["num"] = 3,
				},
				[5] = {
					["CLSID"] = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
					["num"] = 4,
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
					fuel = 2046,
					flare = 15,
					ammo_type = 1,
					chaff = 30,
					gun = 100,
				},
			},
			["NAM - AG - AIM-9Jx2 - FT - LAU-2x4"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				country = {
					[1] = "USA",
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "NAM" },
				weaponType = "Rockets",
				expend = "Auto",
				attackType = "Dive",
								range = 500000,
				firepower = 1,
				vCruise = 177,
				vAttack = 200,
				hCruise = 4500,
				hAttack = 200,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 7,
				},
				[2] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 1,
				},
				[3] = {
					["CLSID"] = "{LAU3_FFAR_MK1HE}",
					["num"] = 5,
				},
				[4] = {
					["CLSID"] = "{LAU3_FFAR_MK1HE}",
					["num"] = 3,
				},
				[5] = {
					["CLSID"] = "{0395076D-2F77-4420-9D33-087A4398130B}",
					["num"] = 4,
				},
				[6] = {
					["CLSID"] = "{LAU3_FFAR_MK1HE}",
					["num"] = 6,
				},
				[7] = {
					["CLSID"] = "{LAU3_FFAR_MK1HE}",
					["num"] = 2,
				},
					},
					fuel = 2046,
					flare = 15,
					ammo_type = 1,
					chaff = 30,
					gun = 100,
				},
			},
		},
		["Fighter Sweep"] = {
			["Cyprus FS LR AIM-9P5*2, Fuel 275*3"] = {
				country = {
					[1] = "Turkey",
				},
				attributes =  { },
				code_loadout =  { "Cyprus" },
								range = 628000,
				firepower = 1,
				vCruise = 215,
				vAttack = 215,
				hCruise = 6683,
				hAttack = 6683,
				standoff = 27000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9P5}",
						},
						[3] = {
							CLSID = "{0395076D-2F77-4420-9D33-087A4398130B}",
						},
						[4] = {
							CLSID = "{0395076D-2F77-4420-9D33-087A4398130B}",
						},
						[5] = {
							CLSID = "{0395076D-2F77-4420-9D33-087A4398130B}",
						},
						[7] = {
							CLSID = "{AIM-9P5}",
						},
					},
					fuel = 2046,
					flare = 15,
					ammo_type = 1,
					chaff = 30,
					gun = 100,
				},
			},
			["Iran - AA -  FS - AIM-9Jx2 - FTx3"] = {
				country = {
					[1] = "Iran",
				},
				attributes =  { },
				code_loadout =  { "IIW", "Crisis", "PG" },
								range = 628000,
				firepower = 1,
				vCruise = 215,
				vAttack = 215,
				hCruise = 6683,
				hAttack = 6683,
				standoff = 27000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9J}",
						},
						[3] = {
							CLSID = "{PTB-150GAL}",
						},
						[4] = {
							CLSID = "{PTB-150GAL}",
						},
						[5] = {
							CLSID = "{PTB-150GAL}",
						},
						[7] = {
							CLSID = "{AIM-9J}",
						},
					},
					fuel = 2046,
					flare = 15,
					ammo_type = 1,
					chaff = 30,
					gun = 100,
				},
			},
		},
		Escort = {
			["Iran - AA -  Escort - AIM-9Jx2 - FTx3"] = {
				country = {
					[1] = "Iran",
				},
				attributes =  { },
				code_loadout =  { "IIW", "Crisis", "PG" },
								range = 450000,
				firepower = 1,
				vCruise = 230,
				standoff = 28000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9J}",
						},
						[3] = {
							CLSID = "{PTB-150GAL}",
						},
						[4] = {
							CLSID = "{PTB-150GAL}",
						},
						[5] = {
							CLSID = "{PTB-150GAL}",
						},
						[7] = {
							CLSID = "{AIM-9J}",
						},
					},
					fuel = 2046,
					flare = 15,
					ammo_type = 1,
					chaff = 30,
					gun = 100,
				},
			},
			["Cyprus Escort LR AIM-9P5*2, Fuel 275*3"] = {
				country = {
					[1] = "Turkey",
				},
				attributes =  { },
				code_loadout =  { "Cyprus" },
								range = 450000,
				firepower = 1,
				vCruise = 230,
				standoff = 28000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9P5}",
						},
						[3] = {
							CLSID = "{0395076D-2F77-4420-9D33-087A4398130B}",
						},
						[4] = {
							CLSID = "{0395076D-2F77-4420-9D33-087A4398130B}",
						},
						[5] = {
							CLSID = "{0395076D-2F77-4420-9D33-087A4398130B}",
						},
						[7] = {
							CLSID = "{AIM-9P5}",
						},
					},
					fuel = 2046,
					flare = 15,
					ammo_type = 1,
					chaff = 30,
					gun = 100,
				},
			},
		},
		CAP = {
			["Cyprus CAP LR AIM-9P5*2, Fuel 275*3"] = {
				country = {
					[1] = "Turkey",
				},
				attributes =  { },
				code_loadout =  { "Cyprus" },
								range = 500000,
				firepower = 1,
				vCruise = 230,
				vAttack = 230,
				hCruise = 5112,
				hAttack = 5112,
				standoff = 1000,
				tStation = 2340,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9P5}",
						},
						[3] = {
							CLSID = "{0395076D-2F77-4420-9D33-087A4398130B}",
						},
						[4] = {
							CLSID = "{0395076D-2F77-4420-9D33-087A4398130B}",
						},
						[5] = {
							CLSID = "{0395076D-2F77-4420-9D33-087A4398130B}",
						},
						[7] = {
							CLSID = "{AIM-9P5}",
						},
					},
					fuel = 2046,
					flare = 15,
					ammo_type = 1,
					chaff = 30,
					gun = 100,
				},
			},
			["Iran - AA -  LR - AIM-9Jx2 - FTx3"] = {
				country = {
					[1] = "Iran",
				},
				attributes =  { },
				code_loadout =  { "IIW", "Crisis", "PG" },
								range = 539000,
				firepower = 1,
				vCruise = 230,
				vAttack = 230,
				hCruise = 5112,
				hAttack = 5112,
				standoff = 1000,
				tStation = 2340,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9J}",
						},
						[3] = {
							CLSID = "{PTB-150GAL}",
						},
						[4] = {
							CLSID = "{PTB-150GAL}",
						},
						[5] = {
							CLSID = "{PTB-150GAL}",
						},
						[7] = {
							CLSID = "{AIM-9J}",
						},
					},
					fuel = 2046,
					flare = 15,
					ammo_type = 1,
					chaff = 30,
					gun = 100,
				},
			},
		},
		["Runway Attack"] = {
			["Runway attack  Iran - AG - LR - AIM-9Jx2 - Mk-82HDx7 - FTx2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				country = {
					[1] = "Iran",
				},
				attributes =  { "Runway" },
				code_loadout =  { "IIW", "Crisis", "PG", "Cyprus" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 230,
				vAttack = 277.5,
				hCruise = 9100,
				hAttack = 100,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9J}",
						},
						[2] = {
							CLSID = "{Mk82SNAKEYE}",
							settings = {
								["function_delay_ctrl_M905"] = 0,
								["arm_delay_ctrl_M904E4"] = 2,
								["arm_delay_ctrl_M905"] = 4,
								["NFP_VIS_DrawArgNo_57"] = 0,
								NFP_fuze_type_tail = "M905",
								NFP_fuze_type_nose = "M904E4",
								["function_delay_ctrl_M904E4"] = 0,
							},
						},
						[3] = {
							CLSID = "{PTB-150GAL}",
						},
						[4] = {
							CLSID = "{MER-5E_Mk82SNAKEYEx5}",
							settings = {
								["function_delay_ctrl_M905"] = 0,
								["arm_delay_ctrl_M904E4"] = 2,
								["arm_delay_ctrl_M905"] = 4,
								["NFP_VIS_DrawArgNo_57"] = 0,
								NFP_fuze_type_tail = "M905",
								NFP_fuze_type_nose = "M904E4",
								["function_delay_ctrl_M904E4"] = 0,
							},
						},
						[5] = {
							CLSID = "{PTB-150GAL}",
						},
						[6] = {
							CLSID = "{Mk82SNAKEYE}",
							settings = {
								["function_delay_ctrl_M905"] = 0,
								["arm_delay_ctrl_M904E4"] = 2,
								["arm_delay_ctrl_M905"] = 4,
								["NFP_VIS_DrawArgNo_57"] = 0,
								NFP_fuze_type_tail = "M905",
								NFP_fuze_type_nose = "M904E4",
								["function_delay_ctrl_M904E4"] = 0,
							},
						},
						[7] = {
							CLSID = "{AIM-9J}",
						},
					},
					fuel = 2046,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
			["Runway attack  AG - LR - AIM-9P5x2 - Mk-82HDx7 - FTx2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				country = {
					[1] = "Turkey",
				},
				attributes =  { "Runway" },
				code_loadout =  { "Cyprus" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 230,
				vAttack = 277.5,
				hCruise = 9100,
				hAttack = 100,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9P5}",
						},
						[2] = {
							CLSID = "{Mk82SNAKEYE}",
							settings = {
								["function_delay_ctrl_M905"] = 0,
								["arm_delay_ctrl_M904E4"] = 2,
								["arm_delay_ctrl_M905"] = 4,
								["NFP_VIS_DrawArgNo_57"] = 0,
								NFP_fuze_type_tail = "M905",
								NFP_fuze_type_nose = "M904E4",
								["function_delay_ctrl_M904E4"] = 0,
							},
						},
						[3] = {
							CLSID = "{PTB-150GAL}",
						},
						[4] = {
							CLSID = "{MER-5E_Mk82SNAKEYEx5}",
							settings = {
								["function_delay_ctrl_M905"] = 0,
								["arm_delay_ctrl_M904E4"] = 2,
								["arm_delay_ctrl_M905"] = 4,
								["NFP_VIS_DrawArgNo_57"] = 0,
								NFP_fuze_type_tail = "M905",
								NFP_fuze_type_nose = "M904E4",
								["function_delay_ctrl_M904E4"] = 0,
							},
						},
						[5] = {
							CLSID = "{PTB-150GAL}",
						},
						[6] = {
							CLSID = "{Mk82SNAKEYE}",
							settings = {
								["function_delay_ctrl_M905"] = 0,
								["arm_delay_ctrl_M904E4"] = 2,
								["arm_delay_ctrl_M905"] = 4,
								["NFP_VIS_DrawArgNo_57"] = 0,
								NFP_fuze_type_tail = "M905",
								NFP_fuze_type_nose = "M904E4",
								["function_delay_ctrl_M904E4"] = 0,
							},
						},
						[7] = {
							CLSID = "{AIM-9P5}",
						},
					},
					fuel = 2046,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
		},
		Intercept = {
			["Iran - AA - Intercept - LR - AIM-9Jx2 - FT"] = {
				country = {
					[1] = "Iran",
				},
				attributes =  { },
				code_loadout =  { "IIW", "Crisis", "PG" },
								range = 200000,
				firepower = 1,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9J}",
						},
						[7] = {
							CLSID = "{AIM-9J}",
						},
						[4] = {
							CLSID = "{PTB-150GAL}",
						},
					},
					fuel = 2046,
					flare = 15,
					ammo_type = 1,
					chaff = 30,
					gun = 100,
				},
			},
			["AIM-9P*2, Fuel_275*1"] = {
				country = {
					[1] = "Turkey",
				},
				attributes =  { },
				code_loadout =  { "Cyprus" },
								range = 200000,
				firepower = 1,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{9BFD8C90-F7AE-4e90-833B-BFD0CED0E536}",
						},
						[7] = {
							CLSID = "{9BFD8C90-F7AE-4e90-833B-BFD0CED0E536}",
						},
						[4] = {
							CLSID = "{0395076D-2F77-4420-9D33-087A4398130B}",
						},
					},
					fuel = 2046,
					flare = 15,
					ammo_type = 1,
					chaff = 30,
					gun = 100,
				},
			},
		},
	},
	["Su-24MR"] = {
		["Escort Jammer"] = {
			["Escort-Jammer : Elint pod, ETHER, Fuel*2"] = {
				attributes =  { },
				code_loadout =  { "All" },
				attackType = "Dive",
				night = true,
				adverseWeather = true,
				range = 1000000,
				firepower = 2,
				vCruise = 240,
				sortie_rate = 12,
				stores = {
					pylons = {
						[1] = 
							{
							["CLSID"] = "{B0DBC591-0F52-4F7D-AD7B-51E67725FB81}",
							}, -- end of [1]
						[2] = 
							{
							["CLSID"] = "{7D7EC917-05F6-49D4-8045-61FC587DD019}",
							}, -- end of [2]
						[5] = 
							{
							["CLSID"] = "{0519A262-0AB6-11d6-9193-00A0249B6F00}",
							}, -- end of [5]
						[7] = 
							{
							["CLSID"] = "{7D7EC917-05F6-49D4-8045-61FC587DD019}",
							}, -- end of [7]
						[8] = 
							{
							["CLSID"] = "{0519A261-0AB6-11d6-9193-00A0249B6F00}",
							}, -- end of [8]
					},
					fuel = 11700,
					flare = 96,
					chaff = 96,
					gun = 100,
				},
			},
		},
		Reconnaissance = {
			["Reco TANGAZH,ETHER,R-60M*2,Fuel*2"] = {
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { },
				code_loadout =  { "TF", "TF80s", "TF80sRED", "TF80sI" },
				night = true,
				day = false,
				adverseWeather = true,
				range = 900000,
				firepower = 10,
				vCruise = 250,
				vAttack = 350,
				hCruise = 10096,
				hAttack = 10096,
				tStation = 2000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{B0DBC591-0F52-4F7D-AD7B-51E67725FB81}",
						},
						[2] = {
							CLSID = "{7D7EC917-05F6-49D4-8045-61FC587DD019}",
						},
						[5] = {
							CLSID = "{0519A262-0AB6-11d6-9193-00A0249B6F00}",
						},
						[7] = {
							CLSID = "{7D7EC917-05F6-49D4-8045-61FC587DD019}",
						},
						[8] = {
							CLSID = "{0519A261-0AB6-11d6-9193-00A0249B6F00}",
						},
					},
					fuel = 11700,
					flare = 96,
					chaff = 96,
					gun = 100,
				},
			},
		},
	},
	["Tu-95MS"] = {
		Reconnaissance = {
			["Reco"] = {
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				day = false,
				adverseWeather = true,
				range = 1000000,
				firepower = 10,
				vCruise = 210,
				vAttack = 250,
				hCruise = 10096,
				hAttack = 10096,
				tStation = 6000,
				sortie_rate = 6,
				stores = {
					pylons = {
					},
					fuel = 87000,
					flare = 48,
					chaff = 48,
					gun = 100,
				},
			},
		},
	},
	["An-26B"] = {
		Transport = {
			Default = {
				attributes =  { },
				code_loadout =  { "All" },
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 154.16666666667,
				vAttack = 154.16666666667,
				hCruise = 7300,
				hAttack = 7300,
				sortie_rate = 6,
				stores = {
					pylons = {
					},
					fuel = 5500,
					flare = 384,
					chaff = 384,
					gun = 100,
				},
			},
		},
	},
	["F-15ESE"] = {
		Strike = {
			["Crisis AG - AIM-9Lx2 - AIM-120Bx2 - GBU-12x8 - TGP - NVP - FTx3"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "Crisis", "PG" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				range = 900000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7315.2,
				hAttack = 5315,
				standoff = 15000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[2] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[3] = {
							CLSID = "{AIM-9L}",
						},
						[4] = {
							CLSID = "{CFT_L_GBU_12_x_4}",
						},
						[7] = {
							CLSID = "{F-15E_AAQ-14_LANTIRN}",
						},
						[8] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[9] = {
							CLSID = "{F-15E_AAQ-13_LANTIRN}",
						},
						[12] = {
							CLSID = "{CFT_R_GBU_12_x_4}",
						},
						[13] = {
							CLSID = "{AIM-9L}",
						},
						[14] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[15] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
					},
					fuel = 10245,
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
			["WOB AG - AIM-9Mx2 - AIM-120x2 - GBU-10x3 - TGP - NVP - FTx2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Structure", "Bridge" },
				code_loadout =  { "Caucasus" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				range = 900000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7315.2,
				hAttack = 5315,
				standoff = 15000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[2] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[3] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[4] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[7] = {
							CLSID = "{F-15E_AAQ-14_LANTIRN}",
						},
						[8] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[9] = {
							CLSID = "{F-15E_AAQ-13_LANTIRN}",
						},
						[12] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[13] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[14] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[15] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
					},
					fuel = 10245,
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
			["WOB AG - AIM-9Mx2 - AIM-120x2 - GBU-12x8 - TGP - NVP - FTx3"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "frontline" },
				code_loadout =  { "Caucasus" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				range = 900000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7315.2,
				hAttack = 5315,
				standoff = 15000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[2] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[3] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[4] = {
							CLSID = "{CFT_L_GBU_12_x_4}",
						},
						[7] = {
							CLSID = "{F-15E_AAQ-14_LANTIRN}",
						},
						[8] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[9] = {
							CLSID = "{F-15E_AAQ-13_LANTIRN}",
						},
						[12] = {
							CLSID = "{CFT_R_GBU_12_x_4}",
						},
						[13] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[14] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[15] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
					},
					fuel = 10245,
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
			["Crisis AG - AIM-9Lx2 - AIM-120Bx2 - GBU-24x3 - TGP - NVP - FTx2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Structure", "Bridge" },
				code_loadout =  { "Crisis", "PG" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				range = 900000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7315.2,
				hAttack = 5315,
				standoff = 15000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[2] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[3] = {
							CLSID = "{AIM-9L}",
						},
						[4] = {
							CLSID = "{34759BBC-AF1E-4AEE-A581-498FF7A6EBCE}",
						},
						[7] = {
							CLSID = "{F-15E_AAQ-14_LANTIRN}",
						},
						[8] = {
							CLSID = "{34759BBC-AF1E-4AEE-A581-498FF7A6EBCE}",
						},
						[9] = {
							CLSID = "{F-15E_AAQ-13_LANTIRN}",
						},
						[12] = {
							CLSID = "{34759BBC-AF1E-4AEE-A581-498FF7A6EBCE}",
						},
						[13] = {
							CLSID = "{AIM-9L}",
						},
						[14] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[15] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
					},
					fuel = 10245,
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
			["WOC AG  LR - AIM-9Mx2 - AIM-120Cx2 - JSAW-Ax4 - TGP - NVP - FT"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "frontline" },
				code_loadout =  { "Caucasus" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 900000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7315.2,
				hAttack = 5315,
				standoff = 60000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[2] = {
							CLSID = "{AGM-154A}",
						},
						[3] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[4] = {
							CLSID = "{AGM-154A}",
						},
						[7] = {
							CLSID = "{F-15E_AAQ-14_LANTIRN}",
						},
						[8] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[9] = {
							CLSID = "{F-15E_AAQ-13_LANTIRN}",
						},
						[12] = {
							CLSID = "{AGM-154A}",
						},
						[13] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[14] = {
							CLSID = "{AGM-154A}",
						},
						[15] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
					},
					fuel = 10245,
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
			["Crisis AG - AIM-9Lx2 - AIM-120Bx2 - GBU-10x3 - TGP - NVP - FTx2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Structure", "Bridge" },
				code_loadout =  { "Crisis", "PG" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				range = 900000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7315.2,
				hAttack = 5315,
				standoff = 15000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[2] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[3] = {
							CLSID = "{AIM-9L}",
						},
						[4] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[7] = {
							CLSID = "{F-15E_AAQ-14_LANTIRN}",
						},
						[8] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[9] = {
							CLSID = "{F-15E_AAQ-13_LANTIRN}",
						},
						[12] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[13] = {
							CLSID = "{AIM-9L}",
						},
						[14] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[15] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
					},
					fuel = 10245,
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
			["WOB AG LR - AIM-9Mx2 - AIM-120Cx2 - GBU-38x6 - TGP - NVP - FTx3"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "frontline", "Structure", "Bridge" },
				code_loadout =  { "WOB", "Caucasus" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				range = 900000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 9100,
				hAttack = 9000,
				standoff = 15000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[2] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[3] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[4] = {
							CLSID = "{CFT_L_GBU_38_x_3}",
						},
						[7] = {
							CLSID = "{F-15E_AAQ-14_LANTIRN}",
						},
						[8] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[9] = {
							CLSID = "{F-15E_AAQ-13_LANTIRN}",
						},
						[12] = {
							CLSID = "{CFT_R_GBU_38_x_3}",
						},
						[13] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[14] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[15] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
					},
					fuel = 10245,
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
			["WOB AG - AIM-9Mx2 - AIM-120x2 - GBU-24x3 - TGP - NVP - FTx2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Structure", "Bridge" },
				code_loadout =  { "Caucasus" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				range = 900000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7315.2,
				hAttack = 5315,
				standoff = 15000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[2] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[3] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[4] = {
							CLSID = "{34759BBC-AF1E-4AEE-A581-498FF7A6EBCE}",
						},
						[7] = {
							CLSID = "{F-15E_AAQ-14_LANTIRN}",
						},
						[8] = {
							CLSID = "{34759BBC-AF1E-4AEE-A581-498FF7A6EBCE}",
						},
						[9] = {
							CLSID = "{F-15E_AAQ-13_LANTIRN}",
						},
						[12] = {
							CLSID = "{34759BBC-AF1E-4AEE-A581-498FF7A6EBCE}",
						},
						[13] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[14] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[15] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
					},
					fuel = 10245,
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
			["WOC AG  - AIM-9Mx2 - AIM-120Cx2 - JSAW-Ax5 - TGP - NVP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "frontline" },
				code_loadout =  { "Caucasus" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7315.2,
				hAttack = 5315,
				standoff = 60000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[2] = {
							CLSID = "{AGM-154A}",
						},
						[3] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[4] = {
							CLSID = "{AGM-154A}",
						},
						[7] = {
							CLSID = "{F-15E_AAQ-14_LANTIRN}",
						},
						[8] = {
							CLSID = "{AGM-154A}",
						},
						[9] = {
							CLSID = "{F-15E_AAQ-13_LANTIRN}",
						},
						[12] = {
							CLSID = "{AGM-154A}",
						},
						[13] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[14] = {
							CLSID = "{AGM-154A}",
						},
						[15] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
					},
					fuel = 10245,
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
			["WOB AG High Alt AIM-120C x 2, AIM-9M x 2, Mk-82LD x 12, TGP, NVP, Fuel Tank x3"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "frontline", "Structure", "Bridge" },
				code_loadout =  { "Caucasus" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 9100,
				hAttack = 8500,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[2] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[3] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[4] = {
							CLSID = "{CFT_L_MK82LD_x_6}",
						},
						[7] = {
							CLSID = "{F-15E_AAQ-14_LANTIRN}",
						},
						[8] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[9] = {
							CLSID = "{F-15E_AAQ-13_LANTIRN}",
						},
						[12] = {
							CLSID = "{CFT_R_MK82LD_x_6}",
						},
						[13] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[14] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[15] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
					},
					fuel = 10245,
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
			["WOB AG LR - AIM-9Mx2 - AIM-120Cx2 - GBU-31x4 - TGP - NVP - FTx3"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Structure", "Bridge" },
				code_loadout =  { "WOB", "Caucasus" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				range = 900000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 9100,
				hAttack = 9000,
				standoff = 15000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[2] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[3] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[4] = {
							CLSID = "{CFT_L_GBU_31_x_2}",
						},
						[7] = {
							CLSID = "{F-15E_AAQ-14_LANTIRN}",
						},
						[8] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[9] = {
							CLSID = "{F-15E_AAQ-13_LANTIRN}",
						},
						[12] = {
							CLSID = "{CFT_R_GBU_31_x_2}",
						},
						[13] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[14] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[15] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
					},
					fuel = 10245,
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
		},
		["Fighter Sweep"] = {
			["Crisis AA - AIM-9Lx2 - AIM-120Bx6 - TGP - NVP - FTx3"] = {
				attributes =  { },
				code_loadout =  { "Crisis", "PG" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 6,
				vCruise = 255.83333333333,
				vAttack = 265.83333333333,
				hCruise = 9753.6,
				hAttack = 9753.6,
				standoff = 46300,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[2] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[3] = {
							CLSID = "{AIM-9L}",
						},
						[5] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[6] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[7] = {
							CLSID = "{F-15E_AAQ-14_LANTIRN}",
						},
						[8] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[9] = {
							CLSID = "{F-15E_AAQ-13_LANTIRN}",
						},
						[10] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[11] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[13] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[14] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[15] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
					},
					fuel = 10245,
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
			["old AA - AIM-9Lx4 - AIM-7MHx4 - TGP - NVP - FTx3"] = {
				attributes =  { },
				code_loadout =  { "WOC80" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 4,
				vCruise = 255.83333333333,
				vAttack = 265.83333333333,
				hCruise = 9753.6,
				hAttack = 9753.6,
				standoff = 46300,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[3] = {
							CLSID = "{AIM-9L}",
						},
						[5] = {
							CLSID = "{AIM-7H}",
						},
						[6] = {
							CLSID = "{AIM-7H}",
						},
						[7] = {
							CLSID = "{F-15E_AAQ-14_LANTIRN}",
						},
						[8] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[9] = {
							CLSID = "{F-15E_AAQ-13_LANTIRN}",
						},
						[10] = {
							CLSID = "{AIM-7H}",
						},
						[11] = {
							CLSID = "{AIM-7H}",
						},
						[13] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[14] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[15] = {
							CLSID = "{AIM-9L}",
						},
					},
					fuel = 10245,
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
			["WOB AA - AIM-9Mx2 - AIM-120Cx6 - TGP - NVP - FTx3"] = {
				attributes =  { },
				code_loadout =  { "WOB", "Caucasus" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 6,
				vCruise = 255.83333333333,
				vAttack = 265.83333333333,
				hCruise = 9753.6,
				hAttack = 9753.6,
				standoff = 46300,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[2] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[3] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[5] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[6] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[7] = {
							CLSID = "{F-15E_AAQ-14_LANTIRN}",
						},
						[8] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[9] = {
							CLSID = "{F-15E_AAQ-13_LANTIRN}",
						},
						[10] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[11] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[13] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[14] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[15] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
					},
					fuel = 10245,
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
		},
		Escort = {
			["Crisis AA - AIM-9Lx2 - AIM-120Bx6 - TGP - NVP - FTx3"] = {
				attributes =  { },
				code_loadout =  { "Crisis", "PG" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 6,
				vCruise = 255.83333333333,
				standoff = 46300,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[2] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[3] = {
							CLSID = "{AIM-9L}",
						},
						[5] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[6] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[7] = {
							CLSID = "{F-15E_AAQ-14_LANTIRN}",
						},
						[8] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[9] = {
							CLSID = "{F-15E_AAQ-13_LANTIRN}",
						},
						[10] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[11] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[13] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[14] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[15] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
					},
					fuel = 10245,
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
			["old AA - AIM-9Lx4 - AIM-7MHx4 - TGP - NVP - FTx3"] = {
				attributes =  { },
				code_loadout =  { "WOC80" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 4,
				vCruise = 255.83333333333,
				standoff = 46300,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[3] = {
							CLSID = "{AIM-9L}",
						},
						[5] = {
							CLSID = "{AIM-7H}",
						},
						[6] = {
							CLSID = "{AIM-7H}",
						},
						[7] = {
							CLSID = "{F-15E_AAQ-14_LANTIRN}",
						},
						[8] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[9] = {
							CLSID = "{F-15E_AAQ-13_LANTIRN}",
						},
						[10] = {
							CLSID = "{AIM-7H}",
						},
						[11] = {
							CLSID = "{AIM-7H}",
						},
						[13] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[14] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[15] = {
							CLSID = "{AIM-9L}",
						},
					},
					fuel = 10245,
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
			["WOB AA - AIM-9Mx2 - AIM-120Cx6 - TGP - NVP - FTx3"] = {
				attributes =  { },
				code_loadout =  { "WOB", "Caucasus" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 6,
				vCruise = 255.83333333333,
				standoff = 46300,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[2] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[3] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[5] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[6] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[7] = {
							CLSID = "{F-15E_AAQ-14_LANTIRN}",
						},
						[8] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[9] = {
							CLSID = "{F-15E_AAQ-13_LANTIRN}",
						},
						[10] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[11] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[13] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[14] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[15] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
					},
					fuel = 10245,
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
		},
		CAP = {
			["Crisis AA - AIM-9Lx2 - AIM-120Bx6 - TGP - NVP - FTx3"] = {
				attributes =  { "Air Forces" },
				code_loadout =  { "Crisis", "PG" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 6,
				vCruise = 245,
				vAttack = 245,
				hCruise = 9753.6,
				hAttack = 9753.6,
				standoff = 46300,
				tStation = 7200,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[2] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[3] = {
							CLSID = "{AIM-9L}",
						},
						[5] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[6] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[7] = {
							CLSID = "{F-15E_AAQ-14_LANTIRN}",
						},
						[8] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[9] = {
							CLSID = "{F-15E_AAQ-13_LANTIRN}",
						},
						[10] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[11] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[13] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[14] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[15] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
					},
					fuel = 10245,
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
			["old AA - AIM-9Lx4 - AIM-7MHx4 - TGP - NVP - FTx3"] = {
				attributes =  { "Air Forces" },
				code_loadout =  { "WOC80" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 4,
				vCruise = 245,
				vAttack = 245,
				hCruise = 9753.6,
				hAttack = 9753.6,
				standoff = 46300,
				tStation = 7200,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[3] = {
							CLSID = "{AIM-9L}",
						},
						[5] = {
							CLSID = "{AIM-7H}",
						},
						[6] = {
							CLSID = "{AIM-7H}",
						},
						[7] = {
							CLSID = "{F-15E_AAQ-14_LANTIRN}",
						},
						[8] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[9] = {
							CLSID = "{F-15E_AAQ-13_LANTIRN}",
						},
						[10] = {
							CLSID = "{AIM-7H}",
						},
						[11] = {
							CLSID = "{AIM-7H}",
						},
						[13] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[14] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[15] = {
							CLSID = "{AIM-9L}",
						},
					},
					fuel = 10245,
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
			["WOB AA - AIM-9Mx2 - AIM-120Cx6 - TGP - NVP - FTx3"] = {
				attributes =  { "Air Forces" },
				code_loadout =  { "WOB", "Caucasus" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 6,
				vCruise = 245,
				vAttack = 245,
				hCruise = 9753.6,
				hAttack = 9753.6,
				standoff = 46300,
				tStation = 7200,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[2] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[3] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[5] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[6] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[7] = {
							CLSID = "{F-15E_AAQ-14_LANTIRN}",
						},
						[8] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[9] = {
							CLSID = "{F-15E_AAQ-13_LANTIRN}",
						},
						[10] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[11] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[13] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[14] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[15] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
					},
					fuel = 10245,
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
		},
		["Runway Attack"] = {
			["Crisis Runway attack High Alt AIM-120B x 2, AIM-9L x 2, Mk-82LD x 12, TGP, NVP, Fuel Tank x3"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Runway" },
				code_loadout =  { "Crisis", "PG" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 9100,
				hAttack = 8500,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[2] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[3] = {
							CLSID = "{AIM-9L}",
						},
						[4] = {
							CLSID = "{CFT_L_MK82LD_x_6}",
						},
						[7] = {
							CLSID = "{F-15E_AAQ-14_LANTIRN}",
						},
						[8] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[9] = {
							CLSID = "{F-15E_AAQ-13_LANTIRN}",
						},
						[12] = {
							CLSID = "{CFT_R_MK82LD_x_6}",
						},
						[13] = {
							CLSID = "{AIM-9L}",
						},
						[14] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[15] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
					},
					fuel = 10245,
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
			["Crisis Runway attack AIM-120B x 2, AIM-9L x 2, Mk-82HD x 12, TGP, NVP, Fuel Tank x3"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Runway" },
				code_loadout =  { "Crisis", "PG" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				day = false,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 9100,
				hAttack = 100,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[2] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[3] = {
							CLSID = "{AIM-9L}",
						},
						[4] = {
							CLSID = "{CFT_L_MK82AR_x_6}",
						},
						[7] = {
							CLSID = "{F-15E_AAQ-14_LANTIRN}",
						},
						[8] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[9] = {
							CLSID = "{F-15E_AAQ-13_LANTIRN}",
						},
						[12] = {
							CLSID = "{CFT_R_MK82AR_x_6}",
						},
						[13] = {
							CLSID = "{AIM-9L}",
						},
						[14] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[15] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
					},
					fuel = 10245,
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
			["WOB Runway attack AIM-120C x 2, AIM-9M x 2, BLU-107 x 12, TGP, NVP, Fuel Tank x3"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Runway" },
				code_loadout =  { "TF", "Caucasus", "WOB" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 9100,
				hAttack = 100,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[2] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[3] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[4] = {
							CLSID = "{CFT_L_BLU107_x_6}",
						},
						[7] = {
							CLSID = "{F-15E_AAQ-14_LANTIRN}",
						},
						[8] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[9] = {
							CLSID = "{F-15E_AAQ-13_LANTIRN}",
						},
						[12] = {
							CLSID = "{CFT_R_BLU107_x_6}",
						},
						[13] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[14] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[15] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
					},
					fuel = 10245,
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
			["Crisis Runway attack AIM-120B x 2, AIM-9L x 2, BLU-107 x 12, TGP, NVP, Fuel Tank x3"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Runway" },
				code_loadout =  { "Crisis", "PG" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 9100,
				hAttack = 100,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[2] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[3] = {
							CLSID = "{AIM-9L}",
						},
						[4] = {
							CLSID = "{CFT_L_BLU107_x_6}",
						},
						[7] = {
							CLSID = "{F-15E_AAQ-14_LANTIRN}",
						},
						[8] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[9] = {
							CLSID = "{F-15E_AAQ-13_LANTIRN}",
						},
						[12] = {
							CLSID = "{CFT_R_BLU107_x_6}",
						},
						[13] = {
							CLSID = "{AIM-9L}",
						},
						[14] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[15] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
					},
					fuel = 10245,
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
			["WOB Runway attack AIM-120C x 2, AIM-9M x 2, Mk-82HD x 12, TGP, NVP, Fuel Tank x3"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Runway" },
				code_loadout =  { "TF", "Caucasus", "WOB" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				day = false,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 9100,
				hAttack = 100,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[2] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[3] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[4] = {
							CLSID = "{CFT_L_MK82AR_x_6}",
						},
						[7] = {
							CLSID = "{F-15E_AAQ-14_LANTIRN}",
						},
						[8] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[9] = {
							CLSID = "{F-15E_AAQ-13_LANTIRN}",
						},
						[12] = {
							CLSID = "{CFT_R_MK82AR_x_6}",
						},
						[13] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[14] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[15] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
					},
					fuel = 10245,
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
			["WOB Runway attack High Alt AIM-120C x 2, AIM-9M x 2, Mk-82LD x 12, TGP, NVP, Fuel Tank x3"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Runway" },
				code_loadout =  { "TF", "Caucasus", "WOB" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 9100,
				hAttack = 8500,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[2] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[3] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[4] = {
							CLSID = "{CFT_L_MK82LD_x_6}",
						},
						[7] = {
							CLSID = "{F-15E_AAQ-14_LANTIRN}",
						},
						[8] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[9] = {
							CLSID = "{F-15E_AAQ-13_LANTIRN}",
						},
						[12] = {
							CLSID = "{CFT_R_MK82LD_x_6}",
						},
						[13] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[14] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[15] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
					},
					fuel = 10245,
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
		},
		Intercept = {
			["Crisis AA - AIM-9Lx2 - AIM-120Bx6 - TGP - NVP - FTx3"] = {
				attributes =  { },
				code_loadout =  { "Crisis", "PG" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 6,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[2] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[3] = {
							CLSID = "{AIM-9L}",
						},
						[5] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[6] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[7] = {
							CLSID = "{F-15E_AAQ-14_LANTIRN}",
						},
						[8] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[9] = {
							CLSID = "{F-15E_AAQ-13_LANTIRN}",
						},
						[10] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[11] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[13] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[14] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[15] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
					},
					fuel = 10245,
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
			["old AA - AIM-9Lx4 - AIM-7MHx4 - TGP - NVP - FTx3"] = {
				attributes =  { },
				code_loadout =  { "WOC80" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 4,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[3] = {
							CLSID = "{AIM-9L}",
						},
						[5] = {
							CLSID = "{AIM-7H}",
						},
						[6] = {
							CLSID = "{AIM-7H}",
						},
						[7] = {
							CLSID = "{F-15E_AAQ-14_LANTIRN}",
						},
						[8] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[9] = {
							CLSID = "{F-15E_AAQ-13_LANTIRN}",
						},
						[10] = {
							CLSID = "{AIM-7H}",
						},
						[11] = {
							CLSID = "{AIM-7H}",
						},
						[13] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[14] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[15] = {
							CLSID = "{AIM-9L}",
						},
					},
					fuel = 10245,
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
			["WOB AA - AIM-9Mx2 - AIM-120Cx6 - TGP - NVP - FTx3"] = {
				attributes =  { },
				code_loadout =  { "WOB", "Caucasus" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 6,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[2] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[3] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[5] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[6] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[7] = {
							CLSID = "{F-15E_AAQ-14_LANTIRN}",
						},
						[8] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[9] = {
							CLSID = "{F-15E_AAQ-13_LANTIRN}",
						},
						[10] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[11] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[13] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[14] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[15] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
					},
					fuel = 10245,
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
		},
	},
	["AV8BNA"] = {
		Strike = {
			["Strike 2000s SR AG GBU38*8 - AIM9M*1 - AGM122*1 - Gun - TP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft" },
				code_loadout =  { "TF", "Caucasus", "WOB" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 150000,
				firepower = 1,
				vCruise = 225,
				vAttack = 277.5,
				hCruise = 6048,
				hAttack = 6706,
				standoff = 20000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{BRU-42_2*GBU-38_RIGHT}",
						},
						[3] = {
							CLSID = "{BRU-42_2*GBU-38_LEFT}",
						},
						[4] = {
							CLSID = "{GAU_12_Equalizer}",
						},
						[5] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
						[6] = {
							CLSID = "{BRU-42_2*GBU-38_RIGHT}",
						},
						[7] = {
							CLSID = "{BRU-42_2*GBU-38_LEFT}",
						},
						[8] = {
							CLSID = "{AGM_122_SIDEARM}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s SR AG GBU54*8 - AIM9M*1 - AGM122*1 - Gun - TP"] = {
				minscore = 0.5,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft" },
				code_loadout =  { "TF" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 150000,
				firepower = 1,
				vCruise = 225,
				vAttack = 277.5,
				hCruise = 6048,
				hAttack = 6706,
				standoff = 20000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{BRU-70A_2*GBU-54_RIGHT}",
						},
						[3] = {
							CLSID = "{BRU-70A_2*GBU-54_LEFT}",
						},
						[4] = {
							CLSID = "{GAU_12_Equalizer}",
						},
						[5] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
						[6] = {
							CLSID = "{BRU-70A_2*GBU-54_RIGHT}",
						},
						[7] = {
							CLSID = "{BRU-70A_2*GBU-54_LEFT}",
						},
						[8] = {
							CLSID = "{AGM_122_SIDEARM}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s SR AG AGM65F*4 - AIM9M*1 - AGM122*1 - Gun - TP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "frontline" },
				code_loadout =  { "TF", "Caucasus", "WOB" },
				weaponType = "ASM",
				expend = "Auto",
				night = true,
				range = 150000,
				firepower = 1,
				vCruise = 225,
				vAttack = 277.5,
				hCruise = 6000,
				hAttack = 5572,
				standoff = 15000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[3] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[4] = {
							CLSID = "{GAU_12_Equalizer}",
						},
						[5] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
						[6] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[7] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[8] = {
							CLSID = "{AGM_122_SIDEARM}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
			["Old TF - Strike  SR - MK-83*4 - AA*1 - AGM122*1 -  ECM - GP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "Bridge", "Structure" },
				code_loadout =  { "TF80s", "TF80sRED", "TF80sI" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 150000,
				firepower = 1,
				vCruise = 225,
				vAttack = 277.5,
				hCruise = 6000,
				hAttack = 6706,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{7A44FF09-527C-4B7E-B42B-3F111CFE50FB}",
						},
						[3] = {
							CLSID = "{7A44FF09-527C-4B7E-B42B-3F111CFE50FB}",
						},
						[4] = {
							CLSID = "{GAU_12_Equalizer}",
						},
						[5] = {
							CLSID = "{ALQ_164_RF_Jammer}",
						},
						[6] = {
							CLSID = "{7A44FF09-527C-4B7E-B42B-3F111CFE50FB}",
						},
						[7] = {
							CLSID = "{7A44FF09-527C-4B7E-B42B-3F111CFE50FB}",
						},
						[8] = {
							CLSID = "{AGM_122_SIDEARM}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s 90s SR AG GBU12*4 - AIM9M*1 - AGM122*1 - Gun - TP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "Crisis", "PG" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				range = 150000,
				firepower = 1,
				vCruise = 225,
				vAttack = 277.5,
				hCruise = 6048,
				hAttack = 6706,
				standoff = 15000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{DB769D48-67D7-42ED-A2BE-108D566C8B1E}",
						},
						[3] = {
							CLSID = "{DB769D48-67D7-42ED-A2BE-108D566C8B1E}",
						},
						[4] = {
							CLSID = "{GAU_12_Equalizer}",
						},
						[5] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
						[6] = {
							CLSID = "{DB769D48-67D7-42ED-A2BE-108D566C8B1E}",
						},
						[7] = {
							CLSID = "{DB769D48-67D7-42ED-A2BE-108D566C8B1E}",
						},
						[8] = {
							CLSID = "{AGM_122_SIDEARM}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s LR AG GBU38*2 - AIM9M*1 - AGM122*1 - Gun - FT*2 - TP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "frontline" },
				code_loadout =  { "TF", "Caucasus", "WOB" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 225,
				vAttack = 277.5,
				hCruise = 6048,
				hAttack = 6706,
				standoff = 20000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{GBU-38}",
						},
						[3] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[4] = {
							CLSID = "{GAU_12_Equalizer}",
						},
						[5] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
						[6] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[7] = {
							CLSID = "{GBU-38}",
						},
						[8] = {
							CLSID = "{AGM_122_SIDEARM}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s SR AG GBU12*4 - AIM9M*1 - AGM122*1 - Gun - TP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft" },
				code_loadout =  { "TF", "Caucasus", "WOB" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				range = 150000,
				firepower = 1,
				vCruise = 225,
				vAttack = 277.5,
				hCruise = 6048,
				hAttack = 6706,
				standoff = 15000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{DB769D48-67D7-42ED-A2BE-108D566C8B1E}",
						},
						[3] = {
							CLSID = "{DB769D48-67D7-42ED-A2BE-108D566C8B1E}",
						},
						[4] = {
							CLSID = "{GAU_12_Equalizer}",
						},
						[5] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
						[6] = {
							CLSID = "{DB769D48-67D7-42ED-A2BE-108D566C8B1E}",
						},
						[7] = {
							CLSID = "{DB769D48-67D7-42ED-A2BE-108D566C8B1E}",
						},
						[8] = {
							CLSID = "{AGM_122_SIDEARM}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s 90s LR AG GBU12*2 - AIM9M*1 - AGM122*1 - FT*2 - TP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "Crisis", "PG" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				range = 500000,
				firepower = 1,
				vCruise = 225,
				vAttack = 277.5,
				hCruise = 6048,
				hAttack = 6706,
				standoff = 15000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{DB769D48-67D7-42ED-A2BE-108D566C8B1E}",
						},
						[3] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[5] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
						[6] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[7] = {
							CLSID = "{DB769D48-67D7-42ED-A2BE-108D566C8B1E}",
						},
						[8] = {
							CLSID = "{AGM_122_SIDEARM}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
			["Old TF - Strike  SR - Mk-82*8 - AA*1 - AGM122*1 - GP - ECM"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "TF80s", "TF80sRED", "TF80sI" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 150000,
				firepower = 1,
				vCruise = 225,
				vAttack = 277.5,
				hCruise = 6000,
				hAttack = 6706,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{BRU-42_2*Mk-82_RIGHT}",
						},
						[3] = {
							CLSID = "{BRU-42_2*Mk-82_LEFT}",
						},
						[4] = {
							CLSID = "{GAU_12_Equalizer}",
						},
						[5] = {
							CLSID = "{ALQ_164_RF_Jammer}",
						},
						[6] = {
							CLSID = "{BRU-42_2*Mk-82_RIGHT}",
						},
						[7] = {
							CLSID = "{BRU-42_2*Mk-82_LEFT}",
						},
						[8] = {
							CLSID = "{AGM_122_SIDEARM}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
			["Old TF - Strike LR  - MAV F*2 - AA*2 - GP - ECM - FT*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "frontline" },
				code_loadout =  { "TF80s", "TF80sRED", "TF80sI" },
				weaponType = "ASM",
				expend = "Auto",
				night = true,
				range = 500000,
				firepower = 1,
				vCruise = 225,
				vAttack = 277.5,
				hCruise = 6000,
				hAttack = 5572,
				standoff = 15000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[3] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[4] = {
							CLSID = "{GAU_12_Equalizer}",
						},
						[5] = {
							CLSID = "{ALQ_164_RF_Jammer}",
						},
						[6] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[7] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[8] = {
							CLSID = "{AIM-9L}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
			["Old TF - Strike  SR - Snakeyes*8 - AA*1 - AGM122*1 - ECM - GP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft" },
				code_loadout =  { "TF80s", "TF80sRED", "TF80sI" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 150000,
				firepower = 1,
				vCruise = 225,
				vAttack = 277.5,
				hCruise = 5000,
				hAttack = 100,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{BRU-42_2*Mk-82SNAKEYE_RIGHT}",
						},
						[3] = {
							CLSID = "{BRU-42_2*Mk-82SNAKEYE_LEFT}",
						},
						[4] = {
							CLSID = "{GAU_12_Equalizer}",
						},
						[5] = {
							CLSID = "{ALQ_164_RF_Jammer}",
						},
						[6] = {
							CLSID = "{BRU-42_2*Mk-82SNAKEYE_RIGHT}",
						},
						[7] = {
							CLSID = "{BRU-42_2*Mk-82SNAKEYE_LEFT}",
						},
						[8] = {
							CLSID = "{AGM_122_SIDEARM}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
			["Old TF - Strike  LR - Zuni*8 - AA*1 - AGM122*1 - ECM - GP - FT*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "frontline" },
				code_loadout =  { "TF80s", "TF80sRED", "TF80sI" },
				weaponType = "Rockets",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 225,
				vAttack = 277.5,
				hCruise = 6000,
				hAttack = 4006,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{F3EFE0AB-E91A-42D8-9CA2-B63C91ED570A}",
						},
						[3] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[4] = {
							CLSID = "{GAU_12_Equalizer}",
						},
						[5] = {
							CLSID = "{ALQ_164_RF_Jammer}",
						},
						[6] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[7] = {
							CLSID = "{F3EFE0AB-E91A-42D8-9CA2-B63C91ED570A}",
						},
						[8] = {
							CLSID = "{AGM_122_SIDEARM}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
			["Old TF - Strike SR - Rockeye*8 - AA*1 - AGM122*1 - ECM - GP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 150000,
				firepower = 1,
				vCruise = 225,
				vAttack = 277.5,
				hCruise = 6000,
				hAttack = 6706,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{BRU-42_2*MK-20_RIGHT}",
						},
						[3] = {
							CLSID = "{BRU-42_2*MK-20_LEFT}",
						},
						[4] = {
							CLSID = "{GAU_12_Equalizer}",
						},
						[5] = {
							CLSID = "{ALQ_164_RF_Jammer}",
						},
						[6] = {
							CLSID = "{BRU-42_2*MK-20_RIGHT}",
						},
						[7] = {
							CLSID = "{BRU-42_2*MK-20_LEFT}",
						},
						[8] = {
							CLSID = "{AGM_122_SIDEARM}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s 90s SR AG AGM65F*4 - AIM9M*1 - AGM122*1 - Gun - TP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "Crisis", "PG", "Caucasus" },
				weaponType = "ASM",
				expend = "Auto",
				night = true,
				range = 150000,
				firepower = 1,
				vCruise = 225,
				vAttack = 277.5,
				hCruise = 6000,
				hAttack = 5572,
				standoff = 15000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[3] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[4] = {
							CLSID = "{GAU_12_Equalizer}",
						},
						[5] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
						[6] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[7] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[8] = {
							CLSID = "{AGM_122_SIDEARM}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
			["Old TF - Strike  LR - Mk-82*4 - AA*1 - AGM122*1 - FT*2 - GP - ECM"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "frontline" },
				code_loadout =  { "TF80sI", "TF80s", "TF80sRED" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 225,
				vAttack = 277.5,
				hCruise = 7000,
				hAttack = 6706,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{BRU-42_2*Mk-82_RIGHT}",
						},
						[3] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[4] = {
							CLSID = "{GAU_12_Equalizer}",
						},
						[5] = {
							CLSID = "{ALQ_164_RF_Jammer}",
						},
						[6] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[7] = {
							CLSID = "{BRU-42_2*Mk-82_LEFT}",
						},
						[8] = {
							CLSID = "{AGM_122_SIDEARM}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s 90s LR AG Mk82*2 - AIM9M*1 - AGM122*1 - FT*2 - Gun - ECM"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "frontline" },
				code_loadout =  { "Caucasus" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 225,
				vAttack = 277.5,
				hCruise = 7000,
				hAttack = 6706,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
						},
						[3] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[4] = {
							CLSID = "{GAU_12_Equalizer}",
						},
						[5] = {
							CLSID = "{ALQ_164_RF_Jammer}",
						},
						[6] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[7] = {
							CLSID = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
						},
						[8] = {
							CLSID = "{AGM_122_SIDEARM}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s 90s LR AG GBU32*2 - AIM9M*1 - AGM122*1 - FT*2 - TP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "Bridge", "Structure" },
				code_loadout =  { "PG", "TF", "Caucasus", "WOB" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 225,
				vAttack = 277.5,
				hCruise = 6048,
				hAttack = 6706,
				standoff = 20000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{GBU_32_V_2B}",
						},
						[3] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[5] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
						[6] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[7] = {
							CLSID = "{GBU_32_V_2B}",
						},
						[8] = {
							CLSID = "{AGM_122_SIDEARM}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s 90s LR AG AGM65F*2 - AIM9M*1 - AGM122*1 - FT*2 - TP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "frontline" },
				code_loadout =  { "Crisis", "PG", "Caucasus" },
				weaponType = "ASM",
				expend = "Auto",
				night = true,
				range = 500000,
				firepower = 1,
				vCruise = 225,
				vAttack = 277.5,
				hCruise = 6000,
				hAttack = 5572,
				standoff = 15000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[3] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[5] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
						[6] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[7] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[8] = {
							CLSID = "{AGM_122_SIDEARM}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
			["Old TF - Strike  SR - Zuni*16 - AA*1 - AGM122*1 - ECM - GP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "TF80s", "TF80sRED", "TF80sI" },
				weaponType = "Rockets",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 150000,
				firepower = 1,
				vCruise = 225,
				vAttack = 277.5,
				hCruise = 6000,
				hAttack = 6706,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{F3EFE0AB-E91A-42D8-9CA2-B63C91ED570A}",
						},
						[3] = {
							CLSID = "{F3EFE0AB-E91A-42D8-9CA2-B63C91ED570A}",
						},
						[4] = {
							CLSID = "{GAU_12_Equalizer}",
						},
						[5] = {
							CLSID = "{ALQ_164_RF_Jammer}",
						},
						[6] = {
							CLSID = "{F3EFE0AB-E91A-42D8-9CA2-B63C91ED570A}",
						},
						[7] = {
							CLSID = "{F3EFE0AB-E91A-42D8-9CA2-B63C91ED570A}",
						},
						[8] = {
							CLSID = "{AGM_122_SIDEARM}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s 90s LR AG Mk83*2 - AIM9M*1 - AGM122*1 - FT*2  - ECM"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "Bridge", "Structure" },
				code_loadout =  { "Crisis", "PG", "Caucasus" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 225,
				vAttack = 277.5,
				hCruise = 7000,
				hAttack = 6706,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{7A44FF09-527C-4B7E-B42B-3F111CFE50FB}",
						},
						[3] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[5] = {
							CLSID = "{ALQ_164_RF_Jammer}",
						},
						[6] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[7] = {
							CLSID = "{7A44FF09-527C-4B7E-B42B-3F111CFE50FB}",
						},
						[8] = {
							CLSID = "{AGM_122_SIDEARM}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s 90s LR AG GBU38*2 - AIM9M*1 - AGM122*1 - Gun - FT*2 - TP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "frontline" },
				code_loadout =  { "PG", "TF", "Caucasus", "WOB" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 225,
				vAttack = 277.5,
				hCruise = 6048,
				hAttack = 6706,
				standoff = 20000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{GBU-38}",
						},
						[3] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[4] = {
							CLSID = "{GAU_12_Equalizer}",
						},
						[5] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
						[6] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[7] = {
							CLSID = "{GBU-38}",
						},
						[8] = {
							CLSID = "{AGM_122_SIDEARM}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
			["Old TF - Strike  LR - MK-83*2 - AA*1 - AGM122*1 -  ECM - GP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "Bridge", "Structure" },
				code_loadout =  { "TF80s", "TF80sRED", "TF80sI" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 225,
				vAttack = 277.5,
				hCruise = 7000,
				hAttack = 6706,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{7A44FF09-527C-4B7E-B42B-3F111CFE50FB}",
						},
						[3] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[4] = {
							CLSID = "{GAU_12_Equalizer}",
						},
						[5] = {
							CLSID = "{ALQ_164_RF_Jammer}",
						},
						[6] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[7] = {
							CLSID = "{7A44FF09-527C-4B7E-B42B-3F111CFE50FB}",
						},
						[8] = {
							CLSID = "{AGM_122_SIDEARM}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
			["Old TF - Strike  LR - Snakeyes*4 - AA*1 - AGM122*1 - FT*2 - ECM - GP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "frontline" },
				code_loadout =  { "TF80s", "TF80sRED", "TF80sI" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				day = false,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 225,
				vAttack = 277.5,
				hCruise = 5000,
				hAttack = 100,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{BRU-42_2*Mk-82SNAKEYE_RIGHT}",
						},
						[3] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[4] = {
							CLSID = "{GAU_12_Equalizer}",
						},
						[5] = {
							CLSID = "{ALQ_164_RF_Jammer}",
						},
						[6] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[7] = {
							CLSID = "{BRU-42_2*Mk-82SNAKEYE_LEFT}",
						},
						[8] = {
							CLSID = "{AGM_122_SIDEARM}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s LR AG GBU12*2 - AIM9M*1 - AGM122*1 - FT*2 - TP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft" },
				code_loadout =  { "TF", "Caucasus", "WOB" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				range = 500000,
				firepower = 1,
				vCruise = 225,
				vAttack = 277.5,
				hCruise = 6048,
				hAttack = 6706,
				standoff = 15000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{DB769D48-67D7-42ED-A2BE-108D566C8B1E}",
						},
						[3] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[5] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
						[6] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[7] = {
							CLSID = "{DB769D48-67D7-42ED-A2BE-108D566C8B1E}",
						},
						[8] = {
							CLSID = "{AGM_122_SIDEARM}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s 90s SR AG Mk82HD*8 - AIM9M*1 - AGM122*1 - FT*2 - Gun - ECM"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft" },
				code_loadout =  { "Crisis", "PG", "Caucasus", "WOB" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				day = false,
				adverseWeather = true,
				range = 454000,
				firepower = 1,
				vCruise = 225,
				vAttack = 277.5,
				hCruise = 5000,
				hAttack = 100,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{BRU-42_2*Mk-82SNAKEYE_RIGHT}",
						},
						[3] = {
							CLSID = "{BRU-42_2*Mk-82SNAKEYE_LEFT}",
						},
						[4] = {
							CLSID = "{GAU_12_Equalizer}",
						},
						[5] = {
							CLSID = "{ALQ_164_RF_Jammer}",
						},
						[6] = {
							CLSID = "{BRU-42_2*Mk-82SNAKEYE_RIGHT}",
						},
						[7] = {
							CLSID = "{BRU-42_2*Mk-82SNAKEYE_LEFT}",
						},
						[8] = {
							CLSID = "{AGM_122_SIDEARM}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s 90s LR AG LR AG Mk20*2 - AIM9M*1 - AGM122*1 - FT*2 - Gun - ECM"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "frontline" },
				code_loadout =  { },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 225,
				vAttack = 277.5,
				hCruise = 6000,
				hAttack = 4006,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{ADD3FAE1-EBF6-4EF9-8EFC-B36B5DDF1E6B}",
						},
						[3] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[4] = {
							CLSID = "{GAU_12_Equalizer}",
						},
						[5] = {
							CLSID = "{ALQ_164_RF_Jammer}",
						},
						[6] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[7] = {
							CLSID = "{ADD3FAE1-EBF6-4EF9-8EFC-B36B5DDF1E6B}",
						},
						[8] = {
							CLSID = "{AGM_122_SIDEARM}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s 90s LR AG Mk82HD*2 - AIM9M*1 - AGM122*1 - FT*2 - Gun - ECM"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "frontline" },
				code_loadout =  { "Crisis", "PG", "Caucasus", "WOB" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				day = false,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 225,
				vAttack = 277.5,
				hCruise = 5000,
				hAttack = 100,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{Mk82SNAKEYE}",
						},
						[3] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[4] = {
							CLSID = "{GAU_12_Equalizer}",
						},
						[5] = {
							CLSID = "{ALQ_164_RF_Jammer}",
						},
						[6] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[7] = {
							CLSID = "{Mk82SNAKEYE}",
						},
						[8] = {
							CLSID = "{AGM_122_SIDEARM}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s LR AG AGM65F*2 - AIM9M*1 - AGM122*1 - FT*2 - TP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "frontline" },
				code_loadout =  { "TF", "Caucasus", "WOB" },
				weaponType = "ASM",
				expend = "Auto",
				night = true,
				range = 500000,
				firepower = 1,
				vCruise = 225,
				vAttack = 277.5,
				hCruise = 6000,
				hAttack = 5572,
				standoff = 15000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[3] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[5] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
						[6] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[7] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[8] = {
							CLSID = "{AGM_122_SIDEARM}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s 90s SR AG GBU38*8 - AIM9M*1 - AGM122*1 - Gun - TP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "PG", "TF", "WOB" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 150000,
				firepower = 1,
				vCruise = 225,
				vAttack = 277.5,
				hCruise = 6048,
				hAttack = 6706,
				standoff = 20000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{BRU-42_2*GBU-38_RIGHT}",
						},
						[3] = {
							CLSID = "{BRU-42_2*GBU-38_LEFT}",
						},
						[4] = {
							CLSID = "{GAU_12_Equalizer}",
						},
						[5] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
						[6] = {
							CLSID = "{BRU-42_2*GBU-38_RIGHT}",
						},
						[7] = {
							CLSID = "{BRU-42_2*GBU-38_LEFT}",
						},
						[8] = {
							CLSID = "{AGM_122_SIDEARM}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s 90s SR AG Mk83*4 - AIM9M*1 - AGM122*1 - Gun - ECM"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "Bridge", "Structure" },
				code_loadout =  { "Crisis", "PG", "Caucasus" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 150000,
				firepower = 1,
				vCruise = 225,
				vAttack = 277.5,
				hCruise = 6000,
				hAttack = 6706,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{7A44FF09-527C-4B7E-B42B-3F111CFE50FB}",
						},
						[3] = {
							CLSID = "{7A44FF09-527C-4B7E-B42B-3F111CFE50FB}",
						},
						[4] = {
							CLSID = "{GAU_12_Equalizer}",
						},
						[5] = {
							CLSID = "{ALQ_164_RF_Jammer}",
						},
						[6] = {
							CLSID = "{7A44FF09-527C-4B7E-B42B-3F111CFE50FB}",
						},
						[7] = {
							CLSID = "{7A44FF09-527C-4B7E-B42B-3F111CFE50FB}",
						},
						[8] = {
							CLSID = "{AGM_122_SIDEARM}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
			["2000s 90s SR AG GBU32*4 - AIM9M*1 - AGM122*1 - Gun - TP"] = {
				minscore = 0.5,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "Bridge", "Structure" },
				code_loadout =  { "PG", "TF", "WOB" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 150000,
				firepower = 1,
				vCruise = 225,
				vAttack = 277.5,
				hCruise = 6048,
				hAttack = 6706,
				standoff = 20000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{GBU_32_V_2B}",
						},
						[3] = {
							CLSID = "{GBU_32_V_2B}",
						},
						[4] = {
							CLSID = "{GAU_12_Equalizer}",
						},
						[5] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
						[6] = {
							CLSID = "{GBU_32_V_2B}",
						},
						[7] = {
							CLSID = "{GBU_32_V_2B}",
						},
						[8] = {
							CLSID = "{AGM_122_SIDEARM}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s 90s SR AG Mk20*8 - AIM9M*1 - AGM122*1 - Gun - ECM"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 150000,
				firepower = 1,
				vCruise = 225,
				vAttack = 277.5,
				hCruise = 6000,
				hAttack = 6706,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{BRU-42_2*MK-20_RIGHT}",
						},
						[3] = {
							CLSID = "{BRU-42_2*MK-20_LEFT}",
						},
						[4] = {
							CLSID = "{GAU_12_Equalizer}",
						},
						[5] = {
							CLSID = "{ALQ_164_RF_Jammer}",
						},
						[6] = {
							CLSID = "{BRU-42_2*MK-20_RIGHT}",
						},
						[7] = {
							CLSID = "{BRU-42_2*MK-20_LEFT}",
						},
						[8] = {
							CLSID = "{AGM_122_SIDEARM}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s 90s SR AG Mk82*8 - AIM9M*1 - AGM122*1 -  Gun - ECM"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "Crisis", "PG" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 150000,
				firepower = 1,
				vCruise = 225,
				vAttack = 277.5,
				hCruise = 6000,
				hAttack = 6706,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{BRU-42_2*Mk-82_RIGHT}",
						},
						[3] = {
							CLSID = "{BRU-42_2*Mk-82_LEFT}",
						},
						[4] = {
							CLSID = "{GAU_12_Equalizer}",
						},
						[5] = {
							CLSID = "{ALQ_164_RF_Jammer}",
						},
						[6] = {
							CLSID = "{BRU-42_2*Mk-82_RIGHT}",
						},
						[7] = {
							CLSID = "{BRU-42_2*Mk-82_LEFT}",
						},
						[8] = {
							CLSID = "{AGM_122_SIDEARM}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s LR AG GBU54*2 - AIM9M*1 - AGM122*1 - FT*2 - Gun - TP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "frontline" },
				code_loadout =  { "TF", "Caucasus" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 225,
				vAttack = 277.5,
				hCruise = 6048,
				hAttack = 6706,
				standoff = 20000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{GBU_54_V_1B}",
						},
						[3] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[4] = {
							CLSID = "{GAU_12_Equalizer}",
						},
						[5] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
						[6] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[7] = {
							CLSID = "{GBU_54_V_1B}",
						},
						[8] = {
							CLSID = "{AGM_122_SIDEARM}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
			["Old TF - Strike SR  - MAV F*4 - AA*2 - GP - ECM"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "TF80s", "TF80sRED", "TF80sI" },
				weaponType = "ASM",
				expend = "Auto",
				night = true,
				range = 150000,
				firepower = 1,
				vCruise = 225,
				vAttack = 277.5,
				hCruise = 6000,
				hAttack = 5572,
				standoff = 15000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[3] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[4] = {
							CLSID = "{GAU_12_Equalizer}",
						},
						[5] = {
							CLSID = "{ALQ_164_RF_Jammer}",
						},
						[6] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[7] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[8] = {
							CLSID = "{AIM-9L}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
			["Old TF - Strike LR - Rockeye*4 - AA*1 - AGM122*1 - FT*2 - ECM - GP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "frontline" },
				code_loadout =  { },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 225,
				vAttack = 277.5,
				hCruise = 6000,
				hAttack = 4006,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{BRU-42_2*MK-20_RIGHT}",
						},
						[3] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[4] = {
							CLSID = "{GAU_12_Equalizer}",
						},
						[5] = {
							CLSID = "{ALQ_164_RF_Jammer}",
						},
						[6] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[7] = {
							CLSID = "{BRU-42_2*MK-20_LEFT}",
						},
						[8] = {
							CLSID = "{AGM_122_SIDEARM}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s 90s LR AG GBU16*2 - AIM9M*1 - AGM122*1 - FT*2 - TP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "Bridge", "Structure" },
				code_loadout =  { "Crisis", "PG", "TF", "Caucasus", "WOB" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				range = 500000,
				firepower = 1,
				vCruise = 225,
				vAttack = 277.5,
				hCruise = 6048,
				hAttack = 6706,
				standoff = 15000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{0D33DDAE-524F-4A4E-B5B8-621754FE3ADE}",
						},
						[3] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[5] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
						[6] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[7] = {
							CLSID = "{0D33DDAE-524F-4A4E-B5B8-621754FE3ADE}",
						},
						[8] = {
							CLSID = "{AGM_122_SIDEARM}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
			["2000s 90s SR AG GBU16*4 - AIM9M*1 - AGM122*1 - Gun - TP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "Bridge", "Structure" },
				code_loadout =  { "Crisis", "PG", "TF", "Caucasus", "WOB" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				range = 150000,
				firepower = 1,
				vCruise = 225,
				vAttack = 277.5,
				hCruise = 6048,
				hAttack = 6706,
				standoff = 15000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{0D33DDAE-524F-4A4E-B5B8-621754FE3ADE}",
						},
						[3] = {
							CLSID = "{0D33DDAE-524F-4A4E-B5B8-621754FE3ADE}",
						},
						[4] = {
							CLSID = "{GAU_12_Equalizer}",
						},
						[5] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
						[6] = {
							CLSID = "{0D33DDAE-524F-4A4E-B5B8-621754FE3ADE}",
						},
						[7] = {
							CLSID = "{0D33DDAE-524F-4A4E-B5B8-621754FE3ADE}",
						},
						[8] = {
							CLSID = "{AGM_122_SIDEARM}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
		},
		["Fighter Sweep"] = {
			["Revenge LR AA - AIM9Mx2 - Gun - FTx2"] = {
				attributes =  { },
				code_loadout =  { "Revenge" },
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 255.83333333333,
				vAttack = 265.83333333333,
				hCruise = 7011,
				hAttack = 7011,
				sortie_rate = 6,
				standoff = 40000,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{AIM-9M-ON-ADAPTER}",
						},
						[3] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[4] = {
							CLSID = "{GAU_12_Equalizer}",
						},
						[6] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[7] = {
							CLSID = "{AIM-9M-ON-ADAPTER}",
						},
						[8] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
			["Revenge SR AA - AIM9M*4 - Gun"] = {
				attributes =  { },
				code_loadout =  { "Revenge" },
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 255.83333333333,
				vAttack = 265.83333333333,
				hCruise = 7011,
				hAttack = 7011,
				sortie_rate = 6,
				standoff = 40000,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{AIM-9M-ON-ADAPTER}",
						},
						[4] = {
							CLSID = "{GAU_12_Equalizer}",
						},
						[7] = {
							CLSID = "{AIM-9M-ON-ADAPTER}",
						},
						[8] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
			["2000s 90s LR AA - AIM9M*4 - FT*2 - Gun - ECM"] = {
				attributes =  { },
				code_loadout =  { },
				night = true,
				adverseWeather = true,
				range = 10000,
				firepower = 1,
				vCruise = 255.83333333333,
				vAttack = 265.83333333333,
				hCruise = 7011,
				hAttack = 7011,
				sortie_rate = 6,
				standoff = 40000,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{AIM-9M-ON-ADAPTER}",
						},
						[3] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[4] = {
							CLSID = "{GAU_12_Equalizer}",
						},
						[5] = {
							CLSID = "{ALQ_164_RF_Jammer}",
						},
						[6] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[7] = {
							CLSID = "{AIM-9M-ON-ADAPTER}",
						},
						[8] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
		},
		Escort = {
			["Revenge LR AA - AIM9Mx2 - Gun - FTx2"] = {
				attributes =  { },
				code_loadout =  { "Revenge" },
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 255,
				standoff = 40000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{AIM-9M-ON-ADAPTER}",
						},
						[3] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[4] = {
							CLSID = "{GAU_12_Equalizer}",
						},
						[6] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[7] = {
							CLSID = "{AIM-9M-ON-ADAPTER}",
						},
						[8] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
			["Revenge SR AA - AIM9M*4 - Gun"] = {
				attributes =  { },
				code_loadout =  { "Revenge" },
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 255,
				standoff = 40000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{AIM-9M-ON-ADAPTER}",
						},
						[4] = {
							CLSID = "{GAU_12_Equalizer}",
						},
						[7] = {
							CLSID = "{AIM-9M-ON-ADAPTER}",
						},
						[8] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
			["2000s 90s LR AA - AIM9M*4 - FT*2 - Gun - ECM"] = {
				attributes =  { },
				code_loadout =  { },
				night = true,
				adverseWeather = true,
				range = 400000,
				firepower = 1,
				vCruise = 255,
				standoff = 40000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{AIM-9M-ON-ADAPTER}",
						},
						[3] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[4] = {
							CLSID = "{GAU_12_Equalizer}",
						},
						[5] = {
							CLSID = "{ALQ_164_RF_Jammer}",
						},
						[6] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[7] = {
							CLSID = "{AIM-9M-ON-ADAPTER}",
						},
						[8] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
		},
		CAP = {
			["Revenge LR AA - AIM9Mx2 - Gun - FTx2"] = {
				attributes =  { "SR CAP" },
				code_loadout =  { "Revenge" },
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 225,
				vAttack = 246.66666666667,
				hCruise = 6096,
				hAttack = 6096,
				tStation = 1200,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{AIM-9M-ON-ADAPTER}",
						},
						[3] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[4] = {
							CLSID = "{GAU_12_Equalizer}",
						},
						[6] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[7] = {
							CLSID = "{AIM-9M-ON-ADAPTER}",
						},
						[8] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
			["Revenge SR AA - AIM9M*4 - Gun"] = {
				attributes =  { },
				code_loadout =  { },
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 225,
				vAttack = 246.66666666667,
				hCruise = 6096,
				hAttack = 6096,
				tStation = 1200,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{AIM-9M-ON-ADAPTER}",
						},
						[4] = {
							CLSID = "{GAU_12_Equalizer}",
						},
						[7] = {
							CLSID = "{AIM-9M-ON-ADAPTER}",
						},
						[8] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
			["2000s 90s LR AA - AIM9M*4 - FT*2 - Gun - ECM"] = {
				attributes =  { },
				code_loadout =  { },
				night = true,
				adverseWeather = true,
				range = 400000,
				firepower = 1,
				vCruise = 225,
				vAttack = 246.66666666667,
				hCruise = 6096,
				hAttack = 6096,
				tStation = 1200,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{AIM-9M-ON-ADAPTER}",
						},
						[3] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[4] = {
							CLSID = "{GAU_12_Equalizer}",
						},
						[5] = {
							CLSID = "{ALQ_164_RF_Jammer}",
						},
						[6] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[7] = {
							CLSID = "{AIM-9M-ON-ADAPTER}",
						},
						[8] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
		},
		SEAD = {
			["AIM-122*2, AIM-9 *2, ECM*1"] = {
				attributes =  { },
				code_loadout =  { },
				weaponType = "ASM",
				night = true,
				adverseWeather = true,
				range = 900000,
				firepower = 1,
				vCruise = 225,
				vAttack = 270,
				hCruise = 6096,
				hAttack = 6096,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{LAU_7_AGM_122_SIDEARM}",
						},
						[4] = {
							CLSID = "{GAU_12_Equalizer}",
						},
						[5] = {
							CLSID = "{ALQ_164_RF_Jammer}",
						},
						[7] = {
							CLSID = "{LAU_7_AGM_122_SIDEARM}",
						},
						[8] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
		},
		["Runway Attack"] = {
			["WOB Runway Attack SR AIM-9Mx2, ECM, Gun, Mk-82HDx8"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Runway" },
				code_loadout =  { "TF", "Caucasus", "WOB", "Crisis" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 1000000,
				firepower = 1,
				vCruise = 225,
				vAttack = 277.5,
				hCruise = 9100,
				hAttack = 100,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{BRU-42_2*Mk-82AIR_RIGHT}",
						},
						[3] = {
							CLSID = "{BRU-42_2*Mk-82AIR_LEFT}",
						},
						[4] = {
							CLSID = "{GAU_12_Equalizer}",
						},
						[5] = {
							CLSID = "{ALQ_164_RF_Jammer}",
						},
						[6] = {
							CLSID = "{BRU-42_2*Mk-82AIR_RIGHT}",
						},
						[7] = {
							CLSID = "{BRU-42_2*Mk-82AIR_LEFT}",
						},
						[8] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
			["Old TF Runway Attack SR AIM-9Lx2, ECM, Gun, Mk-82HDx8"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Runway" },
				code_loadout =  { "TF80s" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 1000000,
				firepower = 1,
				vCruise = 225,
				vAttack = 277.5,
				hCruise = 9100,
				hAttack = 100,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{BRU-42_2*Mk-82AIR_RIGHT}",
						},
						[3] = {
							CLSID = "{BRU-42_2*Mk-82AIR_LEFT}",
						},
						[4] = {
							CLSID = "{GAU_12_Equalizer}",
						},
						[5] = {
							CLSID = "{ALQ_164_RF_Jammer}",
						},
						[6] = {
							CLSID = "{BRU-42_2*Mk-82AIR_RIGHT}",
						},
						[7] = {
							CLSID = "{BRU-42_2*Mk-82AIR_LEFT}",
						},
						[8] = {
							CLSID = "{AIM-9L}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
		},
		["Anti-ship Strike"] = {
			["2000s 90s Antiship LR AG AGM65F*2 - AIM9M*1 - AGM122*1 - FT*2 - TP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "ship" },
				code_loadout =  { "Crisis", "PG", "TF", "Caucasus", "WOB" },
				weaponType = "ASM",
				expend = "Auto",
				night = true,
				range = 500000,
				firepower = 1,
				vCruise = 225,
				vAttack = 277.5,
				hCruise = 6000,
				hAttack = 5572,
				standoff = 15000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[3] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[5] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
						[6] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[7] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[8] = {
							CLSID = "{AGM_122_SIDEARM}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
			["Revenge - Antinavire LR - MAV F*4 - AA*2 - FT*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "ship" },
				code_loadout =  { "Revenge" },
				weaponType = "ASM",
				expend = "Auto",
				night = true,
				range = 200000,
				firepower = 1,
				vCruise = 225,
				vAttack = 277.5,
				hCruise = 6000,
				hAttack = 5572,
				standoff = 15000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[3] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[4] = {
							CLSID = "{GAU_12_Equalizer}",
						},
						[6] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[7] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[8] = {
							CLSID = "{AGM_122_SIDEARM}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
			["Old TF - Antinavire SR  - MAV F*4 - AA*2 - GP - ECM"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "ship" },
				code_loadout =  { "TF80s", "TF80sRED" },
				weaponType = "ASM",
				expend = "Auto",
				night = true,
				range = 150000,
				firepower = 1,
				vCruise = 225,
				vAttack = 277.5,
				hCruise = 6000,
				hAttack = 5572,
				standoff = 15000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[3] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[4] = {
							CLSID = "{GAU_12_Equalizer}",
						},
						[5] = {
							CLSID = "{ALQ_164_RF_Jammer}",
						},
						[6] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[7] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[8] = {
							CLSID = "{AIM-9L}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
			["Revenge - Antinavire SR - MAV F*4 - AA*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "ship" },
				code_loadout =  { "Revenge" },
				weaponType = "ASM",
				expend = "Auto",
				night = true,
				range = 200000,
				firepower = 1,
				vCruise = 225,
				vAttack = 277.5,
				hCruise = 6000,
				hAttack = 5572,
				standoff = 15000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[3] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[4] = {
							CLSID = "{GAU_12_Equalizer}",
						},
						[6] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[7] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[8] = {
							CLSID = "{AGM_122_SIDEARM}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
			["Old TF - Antiship LR  - MAV F*2 - AA*2 - GP - ECM - FT*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "ship" },
				code_loadout =  { "TF80s", "TF80sRED", "TF80sI" },
				weaponType = "ASM",
				expend = "Auto",
				night = true,
				range = 500000,
				firepower = 1,
				vCruise = 225,
				vAttack = 277.5,
				hCruise = 6000,
				hAttack = 5572,
				standoff = 15000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[3] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[4] = {
							CLSID = "{GAU_12_Equalizer}",
						},
						[5] = {
							CLSID = "{ALQ_164_RF_Jammer}",
						},
						[6] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[7] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[8] = {
							CLSID = "{AIM-9L}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
			["2000s 90s Antiship SR AG AGM65F*4 - AIM9M*1 - AGM122*1 - Gun - TP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "ship" },
				code_loadout =  { "Crisis", "PG", "TF", "Caucasus", "WOB" },
				weaponType = "ASM",
				expend = "Auto",
				night = true,
				range = 150000,
				firepower = 1,
				vCruise = 225,
				vAttack = 277.5,
				hCruise = 6000,
				hAttack = 5572,
				standoff = 15000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[3] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[4] = {
							CLSID = "{GAU_12_Equalizer}",
						},
						[5] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
						[6] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[7] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[8] = {
							CLSID = "{AGM_122_SIDEARM}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
		},
		Intercept = {
			["Revenge LR AA - AIM9Mx2 - Gun - FTx2"] = {
				attributes =  { },
				code_loadout =  { "Revenge" },
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{AIM-9M-ON-ADAPTER}",
						},
						[3] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[4] = {
							CLSID = "{GAU_12_Equalizer}",
						},
						[6] = {
							CLSID = "{AV8BNA_AERO1D}",
						},
						[7] = {
							CLSID = "{AIM-9M-ON-ADAPTER}",
						},
						[8] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
			["Revenge SR AA - AIM9M*4 - Gun"] = {
				attributes =  { },
				code_loadout =  { "Revenge" },
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{AIM-9M-ON-ADAPTER}",
						},
						[4] = {
							CLSID = "{GAU_12_Equalizer}",
						},
						[7] = {
							CLSID = "{AIM-9M-ON-ADAPTER}",
						},
						[8] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
			["2000s 90s SR AA - AIM9M*4 - Gun - ECM"] = {
				attributes =  { },
				code_loadout =  { "Caucasus", "TF", "WOB" },
				night = true,
				adverseWeather = true,
				range = 150000,
				firepower = 1,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{AIM-9M-ON-ADAPTER}",
						},
						[4] = {
							CLSID = "{GAU_12_Equalizer}",
						},
						[5] = {
							CLSID = "{ALQ_164_RF_Jammer}",
						},
						[7] = {
							CLSID = "{AIM-9M-ON-ADAPTER}",
						},
						[8] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = 3519,
					flare = 120,
					chaff = 60,
					gun = 100,
				},
			},
		},
	},
	["A6E"] = {
		Refueling = {
			["Low Track"] = {
				attributes =  { "low" },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 180,
				vAttack = 150,
				hCruise = 1828.8,
				hAttack = 1828.8,
				tStation = 10800,
				sortie_rate = 6,
				stores = {
					pylons = {
					[1] = 
					{
						["CLSID"] = "{HB_A6E_AERO1D}",
					}, -- end of [1]
					[2] = 
					{
						["CLSID"] = "{HB_A6E_AERO1D}",
					}, -- end of [2]
					[3] = 
					{
						["CLSID"] = "{HB_A6E_D704}",
					}, -- end of [3]
					[4] = 
					{
						["CLSID"] = "{HB_A6E_AERO1D}",
					}, -- end of [4]
					[5] = 
					{
						["CLSID"] = "{HB_A6E_AERO1D}",
					}, -- end of [5]
					},
					fuel = 7229.8,
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
			["Medium Track"] = {
				attributes =  { "medium" },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 200,
				vAttack = 150,
				hCruise = 6096,
				hAttack = 6096,
				tStation = 10800,
				sortie_rate = 6,
				stores = {
					pylons = {
					[1] = 
					{
						["CLSID"] = "{HB_A6E_AERO1D}",
					}, -- end of [1]
					[2] = 
					{
						["CLSID"] = "{HB_A6E_AERO1D}",
					}, -- end of [2]
					[3] = 
					{
						["CLSID"] = "{HB_A6E_D704}",
					}, -- end of [3]
					[4] = 
					{
						["CLSID"] = "{HB_A6E_AERO1D}",
					}, -- end of [4]
					[5] = 
					{
						["CLSID"] = "{HB_A6E_AERO1D}",
					}, -- end of [5]
					},
					fuel = 7229.8,
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
		},
		SEAD = {
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
					["CLSID"] = "{LAU_34_AGM_45A}",
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
				[2] = {
					["CLSID"] = "{LAU_34_AGM_45A}",
					["num"] = 2,
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
					["CLSID"] = "{HB_A6E_AERO1D}",
					["num"] = 3,
				},
				[4] = {
					["CLSID"] = "{LAU_34_AGM_45A}",
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
					["CLSID"] = "{LAU_34_AGM_45A}",
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
					},
					fuel = 7229.8,
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
		
		},
		Strike = {
			["HB_Old TF Strike LR Mk-82HDx10, FTx3"] = {
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
					["CLSID"] = "{HB_A6E_AERO1D}",
					["num"] = 1,
				},
						[2] = {
					["CLSID"] = "{HB_A6E_MK82SE_MER_5x_LEFT}",
					["num"] = 2,
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
				[3] = {
					["CLSID"] = "{HB_A6E_AERO1D}",
					["num"] = 3,
				},
				[4] = {
					["CLSID"] = "{HB_A6E_MK82SE_MER_5x_RIGHT}",
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
				[5] = {
					["CLSID"] = "{HB_A6E_AERO1D}",
					["num"] = 5,
				},
					},
					fuel = 7229.8,
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
			["HB Old TF Strike LR Mk-82x10, FTx3"] = {
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
					["CLSID"] = "{HB_A6E_AERO1D}",
					["num"] = 1,
				},
				[2] = {
					["CLSID"] = "{HB_A6E_MK82_MER_5x_LEFT}",
					["num"] = 2,
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
				[3] = {
					["CLSID"] = "{HB_A6E_AERO1D}",
					["num"] = 3,
				},
				[4] = {
					["CLSID"] = "{HB_A6E_MK82SE_MER_5x_RIGHT}",
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
				[5] = {
					["CLSID"] = "{HB_A6E_AERO1D}",
					["num"] = 5,
				},
					},
					fuel = 7229.8,
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
			["HB Strike Mk-83x6,FTx3"] = {
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
					["CLSID"] = "{HB_A6E_AERO1D}",
					["num"] = 1,
				},
				[2] = {
					["CLSID"] = "{HB_A6E_MK83_MER_3x_AFT}",
					["num"] = 2,
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
				[3] = {
					["CLSID"] = "{HB_A6E_AERO1D}",
					["num"] = 3,
				},
				[4] = {
					["CLSID"] = "{HB_A6E_MK83_MER_3x_AFT}",
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
				[5] = {
					["CLSID"] = "{HB_A6E_AERO1D}",
					["num"] = 5,
				},
					},
					fuel = 7229.8,
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
		},
	},
	["Su-25"] = {
		Strike = {
			["GTA strike1 S-25L*6,R-60M*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "soft", "Parked Aircraft", "Structure", "frontline" },
				code_loadout =  { "HWITC", "Caucasus" },
				weaponType = "ASM",
				expend = "Auto",
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 230,
				vAttack = 250,
				hCruise = 2500,
				hAttack = 2000,
				standoff = 1000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[3] = {
							CLSID = "{0180F983-C14A-11d8-9897-000476191836}",
						},
						[4] = {
							CLSID = "{0180F983-C14A-11d8-9897-000476191836}",
						},
						[5] = {
							CLSID = "{0180F983-C14A-11d8-9897-000476191836}",
						},
						[6] = {
							CLSID = "{0180F983-C14A-11d8-9897-000476191836}",
						},
						[7] = {
							CLSID = "{0180F983-C14A-11d8-9897-000476191836}",
						},
						[8] = {
							CLSID = "{0180F983-C14A-11d8-9897-000476191836}",
						},
						[10] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
					},
					fuel = 2835,
					flare = 128,
					chaff = 128,
					gun = 100,
				},
			},
			["GTA CAS1 S-8KOM*120,R-60M*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "HWITC" },
				weaponType = "Rockets",
				expend = "All",
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 230,
				vAttack = 250,
				hCruise = 3500,
				hAttack = 1000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[2] = {
							CLSID = "{F72F47E5-C83A-4B85-96ED-D3E46671EE9A}",
						},
						[3] = {
							CLSID = "{F72F47E5-C83A-4B85-96ED-D3E46671EE9A}",
						},
						[4] = {
							CLSID = "{F72F47E5-C83A-4B85-96ED-D3E46671EE9A}",
						},
						[7] = {
							CLSID = "{F72F47E5-C83A-4B85-96ED-D3E46671EE9A}",
						},
						[8] = {
							CLSID = "{F72F47E5-C83A-4B85-96ED-D3E46671EE9A}",
						},
						[10] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[9] = {
							CLSID = "{F72F47E5-C83A-4B85-96ED-D3E46671EE9A}",
						},
					},
					fuel = 2835,
					flare = 128,
					chaff = 128,
					gun = 100,
				},
			},
			["GTA CAS2 PATAB-1M(cluster)*6,R-60M*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "soft", "Parked Aircraft" },
				code_loadout =  { "HWITC" },
				weaponType = "Bombs",
				expend = "All",
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 230,
				vAttack = 250,
				hCruise = 2500,
				hAttack = 2000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[2] = {
							CLSID = "{7AEC222D-C523-425e-B714-719C0D1EB14D}",
						},
						[3] = {
							CLSID = "{7AEC222D-C523-425e-B714-719C0D1EB14D}",
						},
						[4] = {
							CLSID = "{7AEC222D-C523-425e-B714-719C0D1EB14D}",
						},
						[7] = {
							CLSID = "{7AEC222D-C523-425e-B714-719C0D1EB14D}",
						},
						[8] = {
							CLSID = "{7AEC222D-C523-425e-B714-719C0D1EB14D}",
						},
						[10] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[9] = {
							CLSID = "{7AEC222D-C523-425e-B714-719C0D1EB14D}",
						},
					},
					fuel = 2835,
					flare = 128,
					chaff = 128,
					gun = 100,
				},
			},
			["WOC80 strike2 Kh-25*4 R-60*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "soft", "Parked Aircraft", "Structure", "SAM", "frontline" },
				code_loadout =  { "WOC80" },
				weaponType = "ASM",
				expend = "Auto",
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 230,
				vAttack = 250,
				hCruise = 2500,
				hAttack = 2000,
				standoff = 2000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[3] = {
							CLSID = "{79D73885-0801-45a9-917F-C90FE1CE3DFC}",
						},
						[4] = {
							CLSID = "{79D73885-0801-45a9-917F-C90FE1CE3DFC}",
						},
						[7] = {
							CLSID = "{79D73885-0801-45a9-917F-C90FE1CE3DFC}",
						},
						[8] = {
							CLSID = "{79D73885-0801-45a9-917F-C90FE1CE3DFC}",
						},
						[10] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
					},
					fuel = 2835,
					flare = 128,
					chaff = 128,
					gun = 100,
				},
			},
			["WOC80 strike1 S-25L*6,R-60M*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "soft", "Parked Aircraft", "Structure", "SAM", "frontline" },
				code_loadout =  { "WOC80" },
				weaponType = "ASM",
				expend = "Auto",
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 230,
				vAttack = 250,
				hCruise = 2500,
				hAttack = 2000,
				standoff = 1000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[3] = {
							CLSID = "{0180F983-C14A-11d8-9897-000476191836}",
						},
						[4] = {
							CLSID = "{0180F983-C14A-11d8-9897-000476191836}",
						},
						[5] = {
							CLSID = "{0180F983-C14A-11d8-9897-000476191836}",
						},
						[6] = {
							CLSID = "{0180F983-C14A-11d8-9897-000476191836}",
						},
						[7] = {
							CLSID = "{0180F983-C14A-11d8-9897-000476191836}",
						},
						[8] = {
							CLSID = "{0180F983-C14A-11d8-9897-000476191836}",
						},
						[10] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
					},
					fuel = 2835,
					flare = 128,
					chaff = 128,
					gun = 100,
				},
			},
			["GTA strike2 Kh-25*4 R-60*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "soft", "Parked Aircraft", "Structure", "frontline" },
				code_loadout =  { "HWITC", "Caucasus" },
				weaponType = "ASM",
				expend = "Auto",
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 230,
				vAttack = 250,
				hCruise = 2500,
				hAttack = 2000,
				standoff = 2000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[3] = {
							CLSID = "{79D73885-0801-45a9-917F-C90FE1CE3DFC}",
						},
						[4] = {
							CLSID = "{79D73885-0801-45a9-917F-C90FE1CE3DFC}",
						},
						[7] = {
							CLSID = "{79D73885-0801-45a9-917F-C90FE1CE3DFC}",
						},
						[8] = {
							CLSID = "{79D73885-0801-45a9-917F-C90FE1CE3DFC}",
						},
						[10] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
					},
					fuel = 2835,
					flare = 128,
					chaff = 128,
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
	["KC130"] = {
		Refueling = {
			Default = {
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 185,
				vAttack = 185,
				hCruise = 7000,
				hAttack = 7000,
				tStation = 21600,
				sortie_rate = 3,
				stores = {
					pylons = {
					},
					fuel = 20830,
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
			Revenge = {
				attributes =  { "KC130" },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 1000000,
				firepower = 1,
				vCruise = 185,
				vAttack = 185,
				hCruise = 7000,
				hAttack = 7000,
				tStation = 21600,
				sortie_rate = 3,
				stores = {
					pylons = {
					},
					fuel = 20830,
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
		},
	},
	["F-15E"] = {
		Strike = {
			["GBU-10*4, AIM-9M*2, AIM-120B*2, Fuel*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Structure", "Bridge" },
				code_loadout =  { "Crisis", "PG" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				day = false,
				range = 900000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7315.2,
				hAttack = 7315.2,
				standoff = 15000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[11] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[17] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[13] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[18] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[3] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[19] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[9] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[7] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
					},
					fuel = "10246",
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
			["Strike 2000s AG GBU-38*12, AIM-9M*2, AIM-120C*2, FT*3"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "Caucasus", "WOB" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				day = false,
				adverseWeather = true,
				range = 900000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7315.2,
				hAttack = 7315.2,
				standoff = 20000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[3] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[4] = {
							CLSID = "{GBU-38}",
						},
						[5] = {
							CLSID = "{GBU-38}",
						},
						[6] = {
							CLSID = "{GBU-38}",
						},
						[7] = {
							CLSID = "{GBU-38}",
						},
						[8] = {
							CLSID = "{GBU-38}",
						},
						[9] = {
							CLSID = "{GBU-38}",
						},
						[10] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[11] = {
							CLSID = "{GBU-38}",
						},
						[12] = {
							CLSID = "{GBU-38}",
						},
						[13] = {
							CLSID = "{GBU-38}",
						},
						[14] = {
							CLSID = "{GBU-38}",
						},
						[15] = {
							CLSID = "{GBU-38}",
						},
						[16] = {
							CLSID = "{GBU-38}",
						},
						[18] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[19] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[17] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
					},
					fuel = "10246",
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
			["2000s AG GBU-10*4, AIM-9M*2, AIM-120C*2, Fuel*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Structure", "Bridge" },
				code_loadout =  { "Caucasus", "WOB" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				day = false,
				range = 900000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7315.2,
				hAttack = 7315.2,
				standoff = 15000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[11] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[17] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[13] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[18] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[3] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[19] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[9] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[7] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
					},
					fuel = "10246",
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
			["Strike GBU-31*4, AIM-9M*2, AIM-120B*2, FT*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Structure", "Bridge" },
				code_loadout =  { "Crisis", "PG" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				day = false,
				adverseWeather = true,
				range = 900000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7315.2,
				hAttack = 7315.2,
				standoff = 20000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[11] = {
							CLSID = "{GBU-31}",
						},
						[17] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[13] = {
							CLSID = "{GBU-31}",
						},
						[18] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[3] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[19] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[9] = {
							CLSID = "{GBU-31}",
						},
						[7] = {
							CLSID = "{GBU-31}",
						},
					},
					fuel = "10246",
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
			["Strike GBU-38*12, AIM-9M*2, AIM-120B*2, FT*3"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "Crisis", "PG" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				day = false,
				adverseWeather = true,
				range = 900000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7315.2,
				hAttack = 7315.2,
				standoff = 20000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[3] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[4] = {
							CLSID = "{GBU-38}",
						},
						[5] = {
							CLSID = "{GBU-38}",
						},
						[6] = {
							CLSID = "{GBU-38}",
						},
						[7] = {
							CLSID = "{GBU-38}",
						},
						[8] = {
							CLSID = "{GBU-38}",
						},
						[9] = {
							CLSID = "{GBU-38}",
						},
						[10] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[11] = {
							CLSID = "{GBU-38}",
						},
						[12] = {
							CLSID = "{GBU-38}",
						},
						[13] = {
							CLSID = "{GBU-38}",
						},
						[14] = {
							CLSID = "{GBU-38}",
						},
						[15] = {
							CLSID = "{GBU-38}",
						},
						[16] = {
							CLSID = "{GBU-38}",
						},
						[18] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[19] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[17] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
					},
					fuel = "10246",
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
			["Strike 2000s AG GBU-31*4, AIM-9M*2, AIM-120C*2, FT*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Structure", "Bridge" },
				code_loadout =  { "Caucasus", "WOB" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				day = false,
				adverseWeather = true,
				range = 900000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7315.2,
				hAttack = 7315.2,
				standoff = 20000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[11] = {
							CLSID = "{GBU-31}",
						},
						[17] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[13] = {
							CLSID = "{GBU-31}",
						},
						[18] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[3] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[19] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[9] = {
							CLSID = "{GBU-31}",
						},
						[7] = {
							CLSID = "{GBU-31}",
						},
					},
					fuel = "10246",
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
		},
		["Runway Attack"] = {
			["WOB Runway attack AIM-120C x 2, AIM-9M x 2, BLU-107 x 12, TGP, NVP, Fuel Tank x3"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Runway" },
				code_loadout =  { "TF", "Caucasus", "WOB" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 9100,
				hAttack = 100,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[2] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[3] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[4] = {
							CLSID = "{CFT_L_BLU107_x_6}",
						},
						[7] = {
							CLSID = "{F-15E_AAQ-14_LANTIRN}",
						},
						[8] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[9] = {
							CLSID = "{F-15E_AAQ-13_LANTIRN}",
						},
						[12] = {
							CLSID = "{CFT_R_BLU107_x_6}",
						},
						[13] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[14] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[15] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
					},
					fuel = "10246",
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
			["WOB Runway attack AIM-120C x 2, AIM-9M x 2, Mk-82HD x 12, TGP, NVP, Fuel Tank x3"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Runway" },
				code_loadout =  { "TF", "Caucasus", "WOB" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				day = false,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 9100,
				hAttack = 100,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[2] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[3] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[4] = {
							CLSID = "{CFT_L_MK82AR_x_6}",
						},
						[7] = {
							CLSID = "{F-15E_AAQ-14_LANTIRN}",
						},
						[8] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[9] = {
							CLSID = "{F-15E_AAQ-13_LANTIRN}",
						},
						[12] = {
							CLSID = "{CFT_R_MK82AR_x_6}",
						},
						[13] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[14] = {
							CLSID = "{F15E_EXTTANK}",
						},
						[15] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
					},
					fuel = "10246",
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
		},
	},
	["A-10C_2"] = {
		Strike = {
			["Strike GBU-38*4, M151 APKWS*7,AGM-65D*2,AGM-65H*2,CBU-87*1, TGP,AIM-9M*2,ECM"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "PG", "WOB" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 360000,
				firepower = 1,
				vCruise = 120,
				vAttack = 125,
				hCruise = 5200,
				hAttack = 5100,
				standoff = 10000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6D21ECEA-F85B-4E8D-9D51-31DC9B8AA4EF}",
						},
						[2] = {
							CLSID = "{LAU-131 - 7 AGR-20A}",
						},
						[3] = {
							CLSID = "LAU_88_AGM_65H_2_L",
						},
						[4] = {
							CLSID = "{GBU-38}",
						},
						[5] = {
							CLSID = "{GBU-38}",
						},
						[6] = {
							CLSID = "{CBU-87}",
						},
						[7] = {
							CLSID = "{GBU-38}",
						},
						[8] = {
							CLSID = "{GBU-38}",
						},
						[9] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98453}",
						},
						[10] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
						[11] = {
							CLSID = "{DB434044-F5D0-4F1F-9BA9-B73027E18DD3}",
						},
					},
					fuel = 5029,
					flare = 120,
					chaff = 240,
					gun = 100,
				},
			},
			["Strike GBU-12*4, M151 APKWS*7,AGM-65D*2,AGM-65H*2,CBU-87*1, TGP,AIM-9M*2,ECM"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "Crisis", "PG", "WOB" },
				weaponType = "ASM",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 360000,
				firepower = 1,
				vCruise = 120,
				vAttack = 125,
				hCruise = 5200,
				hAttack = 5100,
				standoff = 10000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6D21ECEA-F85B-4E8D-9D51-31DC9B8AA4EF}",
						},
						[2] = {
							CLSID = "{LAU-131 - 7 AGR-20A}",
						},
						[3] = {
							CLSID = "LAU_88_AGM_65H_2_L",
						},
						[4] = {
							CLSID = "{DB769D48-67D7-42ED-A2BE-108D566C8B1E}",
						},
						[5] = {
							CLSID = "{DB769D48-67D7-42ED-A2BE-108D566C8B1E}",
						},
						[6] = {
							CLSID = "{CBU-87}",
						},
						[7] = {
							CLSID = "{DB769D48-67D7-42ED-A2BE-108D566C8B1E}",
						},
						[8] = {
							CLSID = "{DB769D48-67D7-42ED-A2BE-108D566C8B1E}",
						},
						[9] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98453}",
						},
						[10] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
						[11] = {
							CLSID = "{DB434044-F5D0-4F1F-9BA9-B73027E18DD3}",
						},
					},
					fuel = 5029,
					flare = 120,
					chaff = 240,
					gun = 100,
				},
			},
			["Strike Heavy GBU-10*2, M151 APKWS*7,AGM-65D*1,AGM-65H*1, TGP,AIM-9M*2,ECM"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "ship", "Structure" },
				code_loadout =  { "Crisis", "PG", "WOB" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 360000,
				firepower = 1,
				vCruise = 120,
				vAttack = 125,
				hCruise = 5200,
				hAttack = 5100,
				standoff = 2000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6D21ECEA-F85B-4E8D-9D51-31DC9B8AA4EF}",
						},
						[11] = {
							CLSID = "{DB434044-F5D0-4F1F-9BA9-B73027E18DD3}",
						},
						[10] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
						[4] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[8] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
					},
					fuel = 5029,
					flare = 120,
					chaff = 240,
					gun = 100,
				},
			},
			["Strike WOC GBU-12*4, M151 APKWS*7,AGM-65D*2,AGM-65H*2,CBU-87*1, TGP,AIM-9M*2,ECM"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "frontline" },
				code_loadout =  { "Caucasus" },
				weaponType = "ASM",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 360000,
				firepower = 1,
				vCruise = 120,
				vAttack = 125,
				hCruise = 5200,
				hAttack = 5100,
				standoff = 10000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6D21ECEA-F85B-4E8D-9D51-31DC9B8AA4EF}",
						},
						[2] = {
							CLSID = "{LAU-131 - 7 AGR-20A}",
						},
						[3] = {
							CLSID = "LAU_88_AGM_65H_2_L",
						},
						[4] = {
							CLSID = "{DB769D48-67D7-42ED-A2BE-108D566C8B1E}",
						},
						[5] = {
							CLSID = "{DB769D48-67D7-42ED-A2BE-108D566C8B1E}",
						},
						[6] = {
							CLSID = "{CBU-87}",
						},
						[7] = {
							CLSID = "{DB769D48-67D7-42ED-A2BE-108D566C8B1E}",
						},
						[8] = {
							CLSID = "{DB769D48-67D7-42ED-A2BE-108D566C8B1E}",
						},
						[9] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98453}",
						},
						[10] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
						[11] = {
							CLSID = "{DB434044-F5D0-4F1F-9BA9-B73027E18DD3}",
						},
					},
					fuel = 5029,
					flare = 120,
					chaff = 240,
					gun = 100,
				},
			},
			["Strike Heavy GBU-31*2, M151 APKWS*7,AGM-65D*1,AGM-65H*1, TGP,AIM-9M*2,ECM"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "ship", "Structure" },
				code_loadout =  { "PG", "WOB" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 360000,
				firepower = 1,
				vCruise = 120,
				vAttack = 125,
				hCruise = 5200,
				hAttack = 5100,
				standoff = 10000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6D21ECEA-F85B-4E8D-9D51-31DC9B8AA4EF}",
						},
						[11] = {
							CLSID = "{DB434044-F5D0-4F1F-9BA9-B73027E18DD3}",
						},
						[10] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
						[4] = {
							CLSID = "{GBU-31}",
						},
						[8] = {
							CLSID = "{GBU-31}",
						},
					},
					fuel = 5029,
					flare = 120,
					chaff = 240,
					gun = 100,
				},
			},
		},
		["Anti-ship Strike"] = {
			["Antiship Strike GBU-10*2, M151 APKWS*7,AGM-65G*2, TGP,AIM-9M*2,ECM"] = {
				minscore = 0.001,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "ship" },
				code_loadout =  { "Crisis", "PG" },
				weaponType = "ASM",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 130000,
				firepower = 1,
				vCruise = 120,
				vAttack = 125,
				hCruise = 5200,
				hAttack = 5100,
				standoff = 9000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6D21ECEA-F85B-4E8D-9D51-31DC9B8AA4EF}",
						},
						[2] = {
							CLSID = "{LAU-131 - 7 AGR-20A}",
						},
						[3] = {
							CLSID = "LAU_117_AGM_65G",
						},
						[4] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[8] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[11] = {
							CLSID = "{DB434044-F5D0-4F1F-9BA9-B73027E18DD3}",
						},
						[10] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
						[9] = {
							CLSID = "LAU_117_AGM_65G",
						},
					},
					fuel = 5029,
					flare = 120,
					chaff = 240,
					gun = 100,
				},
			},
		},
	},
	["B-52H"] = {
		Strike = {
			["NAM 80s AG Mk-82x45"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
					["Escort Jammer"] = true,
				},
				attributes =  { "SAM", "soft", "Bridge", "Base", "B-52" },
				code_loadout =  {  "NAM" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Carpet",
				night = true,
				day = false,
				adverseWeather = true,
				range = 14000000,
				firepower = 10,
				vCruise = 231.25,
				vAttack = 256.94444444444,
				hCruise = 7315.2,
				hAttack = 7315.2,
				sortie_rate = 1.5,
				standoff = 20000,
				stores = {
					pylons = {
						[1] = {
					["CLSID"] = "{585D626E-7F42-4073-AB70-41E728C333E2}",
					["num"] = 3,
					["settings"] = {
						["NFP_PRESID"] = "MDRN_B_A_GPLD",
						["NFP_PRESVER"] = 1,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
						["arm_delay_ctrl_M904E4"] = 4,
						["arm_delay_ctrl_M905"] = 4,
						["function_delay_ctrl_M904E4"] = 0,
						["function_delay_ctrl_M905"] = 0,
					},
				},
				[2] = {
					["CLSID"] = "{585D626E-7F42-4073-AB70-41E728C333E2}",
					["num"] = 1,
					["settings"] = {
						["NFP_PRESID"] = "MDRN_B_A_GPLD",
						["NFP_PRESVER"] = 1,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
						["arm_delay_ctrl_M904E4"] = 4,
						["arm_delay_ctrl_M905"] = 4,
						["function_delay_ctrl_M904E4"] = 0,
						["function_delay_ctrl_M905"] = 0,
					},
				},
				[3] = {
					["CLSID"] = "{6C47D097-83FF-4FB2-9496-EAB36DDF0B05}",
					["num"] = 2,
					["settings"] = {
						["NFP_PRESID"] = "MDRN_B_A_GPLD",
						["NFP_PRESVER"] = 1,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
						["arm_delay_ctrl_M904E4"] = 4,
						["arm_delay_ctrl_M905"] = 4,
						["function_delay_ctrl_M904E4"] = 0,
						["function_delay_ctrl_M905"] = 0,
					},
				},
					},
					fuel = "141135",
					flare = 192,
					chaff = 1125,
					gun = 100,
				},
			},
			["80s AG Mk-82x45"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "SAM", "soft", "Bridge", "Base" },
				code_loadout =  { "TF80sI", "WOC80", "TF80s" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 14000000,
				firepower = 1,
				vCruise = 231.25,
				vAttack = 256.94444444444,
				hCruise = 7315.2,
				hAttack = 7315.2,
				sortie_rate = 1.5,
				stores = {
					pylons = {
					[1] = {
					["CLSID"] = "{585D626E-7F42-4073-AB70-41E728C333E2}",
					["num"] = 3,
					["settings"] = {
						["NFP_PRESID"] = "MDRN_B_A_GPLD",
						["NFP_PRESVER"] = 1,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
						["arm_delay_ctrl_M904E4"] = 4,
						["arm_delay_ctrl_M905"] = 4,
						["function_delay_ctrl_M904E4"] = 0,
						["function_delay_ctrl_M905"] = 0,
					},
				},
				[2] = {
					["CLSID"] = "{585D626E-7F42-4073-AB70-41E728C333E2}",
					["num"] = 1,
					["settings"] = {
						["NFP_PRESID"] = "MDRN_B_A_GPLD",
						["NFP_PRESVER"] = 1,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
						["arm_delay_ctrl_M904E4"] = 4,
						["arm_delay_ctrl_M905"] = 4,
						["function_delay_ctrl_M904E4"] = 0,
						["function_delay_ctrl_M905"] = 0,
					},
				},
				[3] = {
					["CLSID"] = "{6C47D097-83FF-4FB2-9496-EAB36DDF0B05}",
					["num"] = 2,
					["settings"] = {
						["NFP_PRESID"] = "MDRN_B_A_GPLD",
						["NFP_PRESVER"] = 1,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
						["arm_delay_ctrl_M904E4"] = 4,
						["arm_delay_ctrl_M905"] = 4,
						["function_delay_ctrl_M904E4"] = 0,
						["function_delay_ctrl_M905"] = 0,
					},
					},
				},
					fuel = "141135",
					flare = 192,
					chaff = 1125,
					gun = 100,
				},
			},
			["NAM Mk-84*12"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
					["Escort Jammer"] = true,
				},
				attributes =  { "Structure", "SAM", "soft", "Bridge", "Base", "B-52" },
				code_loadout =  {  "NAM" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Carpet",
				night = true,
				adverseWeather = true,
				range = 14000000,
				firepower = 10,
				vCruise = 231.25,
				vAttack = 256.94444444444,
				hCruise = 7315.2,
				hAttack = 7315.2,
				sortie_rate = 1.5,
				standoff = 20000,
				stores = {
					pylons = {
						[1] = {
					["CLSID"] = "{696CFFC4-0BDE-42A8-BE4B-0BE3D9DD723C}",
					["num"] = 3,
					["settings"] = {
						["NFP_PRESID"] = "MDRN_B_A_GPLD",
						["NFP_PRESVER"] = 1,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
						["arm_delay_ctrl_M904E4"] = 4,
						["arm_delay_ctrl_M905"] = 4,
						["function_delay_ctrl_M904E4"] = 0,
						["function_delay_ctrl_M905"] = 0,
					},
				},
				[2] = {
					["CLSID"] = "{696CFFC4-0BDE-42A8-BE4B-0BE3D9DD723C}",
					["num"] = 1,
					["settings"] = {
						["NFP_PRESID"] = "MDRN_B_A_GPLD",
						["NFP_PRESVER"] = 1,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
						["arm_delay_ctrl_M904E4"] = 4,
						["arm_delay_ctrl_M905"] = 4,
						["function_delay_ctrl_M904E4"] = 0,
						["function_delay_ctrl_M905"] = 0,
					},
				},
					},
					fuel = "141135",
					flare = 192,
					chaff = 1125,
					gun = 100,
				},
			},
			["Mk-84*12"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "Structure", "SAM", "soft", "Bridge", "Base" },
				code_loadout =  { "TF80sI", "WOC80", "TF80s" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				day = false,
				adverseWeather = true,
				range = 14000000,
				firepower = 1,
				vCruise = 231.25,
				vAttack = 256.94444444444,
				hCruise = 7315.2,
				hAttack = 7315.2,
				sortie_rate = 1.5,
				stores = {
					pylons = {
						[1] = {
					["CLSID"] = "{696CFFC4-0BDE-42A8-BE4B-0BE3D9DD723C}",
					["num"] = 3,
					["settings"] = {
						["NFP_PRESID"] = "MDRN_B_A_GPLD",
						["NFP_PRESVER"] = 1,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
						["arm_delay_ctrl_M904E4"] = 4,
						["arm_delay_ctrl_M905"] = 4,
						["function_delay_ctrl_M904E4"] = 0,
						["function_delay_ctrl_M905"] = 0,
					},
				},
				[2] = {
					["CLSID"] = "{696CFFC4-0BDE-42A8-BE4B-0BE3D9DD723C}",
					["num"] = 1,
					["settings"] = {
						["NFP_PRESID"] = "MDRN_B_A_GPLD",
						["NFP_PRESVER"] = 1,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
						["arm_delay_ctrl_M904E4"] = 4,
						["arm_delay_ctrl_M905"] = 4,
						["function_delay_ctrl_M904E4"] = 0,
						["function_delay_ctrl_M905"] = 0,
					},
				},
					},
					fuel = "141135",
					flare = 192,
					chaff = 1125,
					gun = 100,
				},
			},
			["Strike TF  AGM-86D*30"] = {
				minscore = 0.3,
				support = {
					Escort = false,
					SEAD = false,
					["Escort Jammer"] = true,
				},
				attributes =  { "SAM", "SAM-LR" },
				code_loadout =  { "TF", "Caucasus", "WOB" },
				weaponType = "ASM",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 14000000,
				firepower = 20,
				vCruise = 231.25,
				vAttack = 256.94444444444,
				hCruise = 9500,
				hAttack = 9500,
				standoff = 150000,
				ingress = 50000,
				egress = 10000,
				MaxAttackOffset = 60,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
					["CLSID"] = "{45447F82-01B5-4029-A572-9AAD28AF0275}",
					["num"] = 3,
				},
				[2] = {
					["CLSID"] = "{45447F82-01B5-4029-A572-9AAD28AF0275}",
					["num"] = 1,
				},
				[3] = {
					["CLSID"] = "{8DCAF3A3-7FCF-41B8-BB88-58DEDA878EDE}",
					["num"] = 2,
				},
					},
					fuel = "141135",
					flare = 192,
					chaff = 1125,
					gun = 100,
				},
			},
			["Strike TF medium  AGM-86D*30"] = {
				minscore = 0.3,
				support = {
					Escort = false,
					SEAD = false,
					["Escort Jammer"] = true,
				},
				attributes =  { "SAM", "SAM-LR" },
				code_loadout =  { "TF", "Caucasus", "WOB" },
				weaponType = "ASM",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 14000000,
				firepower = 20,
				vCruise = 231.25,
				vAttack = 256.94444444444,
				hCruise = 7315.2,
				hAttack = 7315.2,
				standoff = 130000,
				ingress = 50000,
				egress = 10000,
				MaxAttackOffset = 60,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
					["CLSID"] = "{45447F82-01B5-4029-A572-9AAD28AF0275}",
					["num"] = 3,
				},
				[2] = {
					["CLSID"] = "{45447F82-01B5-4029-A572-9AAD28AF0275}",
					["num"] = 1,
				},
				[3] = {
					["CLSID"] = "{8DCAF3A3-7FCF-41B8-BB88-58DEDA878EDE}",
					["num"] = 2,
				},
					},
					fuel = "141135",
					flare = 192,
					chaff = 1125,
					gun = 100,
				},
			},
		},
	},
	["AJS37"] = {
		Strike = {
			["CAS WOC80 - RB-75T*2 - ECM*2 - RB-24J*2 - FT"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "WOC80" },
				weaponType = "ASM",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 250.83333333333,
				vAttack = 350.5,
				hCruise = 6000,
				hAttack = 5572,
				standoff = 6000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{Robot24J}",
						},
						[2] = {
							CLSID = "{KB}",
						},
						[3] = {
							CLSID = "{RB75T}",
						},
						[4] = {
							CLSID = "{VIGGEN_X-TANK}",
						},
						[5] = {
							CLSID = "{RB75T}",
						},
						[6] = {
							CLSID = "{U22A}",
						},
						[7] = {
							CLSID = "{Robot24J}",
						},
					},
					fuel = 4476,
					flare = 36,
					chaff = 105,
					gun = 100,
				},
			},
			["CAS - Rocket ARAK M70 HE*2 - ECM*2 - RB-24J*2 - FT"] = {
				minscore = 0.4,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "frontline" },
				code_loadout =  { "Caucasus" },
				weaponType = "Rockets",
				expend = "All",
				night = true,
				range = 500000,
				firepower = 1,
				vCruise = 250.83333333333,
				vAttack = 350.5,
				hCruise = 100,
				hAttack = 300,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{Robot24J}",
						},
						[2] = {
							CLSID = "{KB}",
						},
						[3] = {
							CLSID = "{ARAKM70BHE}",
						},
						[4] = {
							CLSID = "{VIGGEN_X-TANK}",
						},
						[5] = {
							CLSID = "{ARAKM70BHE}",
						},
						[6] = {
							CLSID = "{U22A}",
						},
						[7] = {
							CLSID = "{Robot24J}",
						},
					},
					fuel = 4476,
					flare = 36,
					chaff = 105,
					gun = 100,
				},
			},
			["CAS - Bomb M/71*8 - ECM*2 - RB-24J*2 - FT"] = {
				minscore = 0.5,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "frontline" },
				code_loadout =  { "Crisis", "PG", "Caucasus", "WOB" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 723000,
				firepower = 1,
				vCruise = 250,
				vAttack = 330,
				hCruise = 7548,
				hAttack = 1000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{Robot24J}",
						},
						[2] = {
							CLSID = "{KB}",
						},
						[3] = {
							CLSID = "{M71BOMB}",
						},
						[4] = {
							CLSID = "{VIGGEN_X-TANK}",
						},
						[5] = {
							CLSID = "{M71BOMB}",
						},
						[6] = {
							CLSID = "{U22A}",
						},
						[7] = {
							CLSID = "{Robot24J}",
						},
					},
					fuel = 4476,
					flare = 36,
					chaff = 105,
					gun = 100,
				},
			},
			["CAS - Bomb M/71 chute*8 - ECM*2 - RB-24J*2 - FT"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "frontline" },
				code_loadout =  { "Crisis", "PG", "Caucasus", "WOB" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 501000,
				firepower = 1,
				vCruise = 185,
				vAttack = 330,
				hCruise = 530,
				hAttack = 50,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{Robot24J}",
						},
						[2] = {
							CLSID = "{KB}",
						},
						[3] = {
							CLSID = "{M71BOMBD}",
						},
						[4] = {
							CLSID = "{VIGGEN_X-TANK}",
						},
						[5] = {
							CLSID = "{M71BOMBD}",
						},
						[6] = {
							CLSID = "{U22A}",
						},
						[7] = {
							CLSID = "{Robot24J}",
						},
					},
					fuel = 4476,
					flare = 36,
					chaff = 105,
					gun = 100,
				},
			},
			["WOC 80 - CAS - Bomb M/71*8 - ECM*2 - RB-24J*2 - FT"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "WOC80" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 501000,
				firepower = 1,
				vCruise = 185,
				vAttack = 330,
				hCruise = 530,
				hAttack = 300,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{Robot24J}",
						},
						[2] = {
							CLSID = "{KB}",
						},
						[3] = {
							CLSID = "{M71BOMB}",
						},
						[4] = {
							CLSID = "{VIGGEN_X-TANK}",
						},
						[5] = {
							CLSID = "{M71BOMB}",
						},
						[6] = {
							CLSID = "{U22A}",
						},
						[7] = {
							CLSID = "{Robot24J}",
						},
					},
					fuel = 4476,
					flare = 36,
					chaff = 105,
					gun = 100,
				},
			},
			["CAS WOC80 - Bomb M/71 chute*8 - ECM*2 - RB-24J*2 - FT"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "WOC80" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 501000,
				firepower = 1,
				vCruise = 185,
				vAttack = 330,
				hCruise = 530,
				hAttack = 50,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{Robot24J}",
						},
						[2] = {
							CLSID = "{KB}",
						},
						[3] = {
							CLSID = "{M71BOMBD}",
						},
						[4] = {
							CLSID = "{VIGGEN_X-TANK}",
						},
						[5] = {
							CLSID = "{M71BOMBD}",
						},
						[6] = {
							CLSID = "{U22A}",
						},
						[7] = {
							CLSID = "{Robot24J}",
						},
					},
					fuel = 4476,
					flare = 36,
					chaff = 105,
					gun = 100,
				},
			},
			["CAS - RB-75T*2 - ECM*2 - RB-24J*2 - FT"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "frontline" },
				code_loadout =  { "Crisis", "PG", "Caucasus", "WOB" },
				weaponType = "ASM",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 200,
				vAttack = 350.5,
				hCruise = 6000,
				hAttack = 5572,
				standoff = 6000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{Robot24J}",
						},
						[2] = {
							CLSID = "{KB}",
						},
						[3] = {
							CLSID = "{RB75T}",
						},
						[4] = {
							CLSID = "{VIGGEN_X-TANK}",
						},
						[5] = {
							CLSID = "{RB75T}",
						},
						[6] = {
							CLSID = "{U22A}",
						},
						[7] = {
							CLSID = "{Robot24J}",
						},
					},
					fuel = 4476,
					flare = 36,
					chaff = 105,
					gun = 100,
				},
			},
			["CAS WOC80 - BK90 (MJ1)*2 - ECM*2 - RB-24J*2 - XT"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "WOC80" },
				weaponType = "ASM",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 501000,
				firepower = 1,
				vCruise = 185,
				vAttack = 330,
				hCruise = 100,
				hAttack = 200,
				standoff = 9000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{Robot24J}",
						},
						[2] = {
							CLSID = "{KB}",
						},
						[3] = {
							CLSID = "{BK90}",
						},
						[4] = {
							CLSID = "{VIGGEN_X-TANK}",
						},
						[5] = {
							CLSID = "{BK90}",
						},
						[6] = {
							CLSID = "{U22A}",
						},
						[7] = {
							CLSID = "{Robot24J}",
						},
					},
					fuel = 4476,
					flare = 36,
					chaff = 105,
					gun = 100,
				},
			},
			["CAS - BK90 (MJ1)*2 - ECM*2 - RB-24J*2 - XT"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "frontline" },
				code_loadout =  { "Crisis", "PG", "Caucasus", "WOC80", "WOB" },
				weaponType = "ASM",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 475000,
				firepower = 1,
				vCruise = 200,
				vAttack = 300,
				hCruise = 100,
				hAttack = 200,
				standoff = 9000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{Robot24J}",
						},
						[2] = {
							CLSID = "{KB}",
						},
						[3] = {
							CLSID = "{BK90}",
						},
						[4] = {
							CLSID = "{VIGGEN_X-TANK}",
						},
						[5] = {
							CLSID = "{BK90}",
						},
						[6] = {
							CLSID = "{U22A}",
						},
						[7] = {
							CLSID = "{Robot24J}",
						},
					},
					fuel = 4476,
					flare = 36,
					chaff = 105,
					gun = 100,
				},
			},
			["CAS - Rocket ARAK M70 AP*2 - ECM*2 - RB-24J*2 - FT"] = {
				minscore = 0.4,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "frontline" },
				code_loadout =  { "Caucasus" },
				weaponType = "Rockets",
				expend = "All",
				night = true,
				range = 475000,
				firepower = 1,
				vCruise = 200,
				vAttack = 350.5,
				hCruise = 100,
				hAttack = 300,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{Robot24J}",
						},
						[2] = {
							CLSID = "{KB}",
						},
						[3] = {
							CLSID = "{ARAKM70BAP}",
						},
						[4] = {
							CLSID = "{VIGGEN_X-TANK}",
						},
						[5] = {
							CLSID = "{ARAKM70BAP}",
						},
						[6] = {
							CLSID = "{U22A}",
						},
						[7] = {
							CLSID = "{Robot24J}",
						},
					},
					fuel = 4476,
					flare = 36,
					chaff = 105,
					gun = 100,
				},
			},
		},
		["Anti-ship Strike"] = {
			["Antiship - RB 15F*2 - RB-74J*2 - RB-24J*2 - FT"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "ship" },
				code_loadout =  { "Crisis", "PG", "Caucasus", "WOC80", "WOB" },
				weaponType = "ASM",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 619000,
				firepower = 1,
				vCruise = 230,
				vAttack = 215.5,
				hCruise = 5109,
				hAttack = 1000,
				standoff = 35000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{Robot24J}",
						},
						[2] = {
							CLSID = "{Rb15_HB}",
						},
						[3] = {
							CLSID = "{Robot74}",
						},
						[4] = {
							CLSID = "{VIGGEN_X-TANK}",
						},
						[5] = {
							CLSID = "{Robot74}",
						},
						[6] = {
							CLSID = "{Rb15_HB}",
						},
						[7] = {
							CLSID = "{Robot24J}",
						},
					},
					fuel = 4476,
					flare = 36,
					chaff = 105,
					gun = 100,
				},
			},
		},
		["Runway Attack"] = {
			["WOB Runway Strike: SB71HD*16, RB-24J, XT"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Runway" },
				code_loadout =  { "TF", "Caucasus", "WOB", "Crisis" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 660000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 9100,
				hAttack = 100,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{Robot24J}",
						},
						[2] = {
							CLSID = "{M71BOMBD}",
						},
						[3] = {
							CLSID = "{M71BOMBD}",
						},
						[4] = {
							CLSID = "{VIGGEN_X-TANK}",
						},
						[5] = {
							CLSID = "{M71BOMBD}",
						},
						[6] = {
							CLSID = "{M71BOMBD}",
						},
						[7] = {
							CLSID = "{Robot24J}",
						},
					},
					fuel = 4476,
					flare = 36,
					chaff = 105,
					gun = 100,
				},
			},
		},
	},
	["S-3B Tanker"] = {
		Refueling = {
			["Low Track"] = {
				attributes =  { "low" },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 180,
				vAttack = 150,
				hCruise = 1828.8,
				hAttack = 1828.8,
				tStation = 10800,
				sortie_rate = 6,
				stores = {
					pylons = {
					},
					fuel = 7813,
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
			["Medium Track"] = {
				attributes =  { "medium" },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 200,
				vAttack = 150,
				hCruise = 6096,
				hAttack = 6096,
				tStation = 10800,
				sortie_rate = 6,
				stores = {
					pylons = {
					},
					fuel = 7813,
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
		},
	},
	["Su-25T"] = {
		SEAD = {
			["ARM, Fuel*2, ECM"] = {
				attributes =  { },
				code_loadout =  { "Caucasus" },
				weaponType = "ASM",
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 230,
				vAttack = 250,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{44EE8698-89F9-48EE-AF36-5FD31896A82D}",
						},
						[2] = {
							CLSID = "{CBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[3] = {
							CLSID = "{752AF1D2-EBCC-4bd7-A1E7-2357F5601C70}",
						},
						[4] = {
							CLSID = "{752AF1D2-EBCC-4bd7-A1E7-2357F5601C70}",
						},
						[5] = {
							CLSID = "{E8D4652F-FD48-45B7-BA5B-2AE05BB5A9CF}",
						},
						[6] = {
							CLSID = "{0519A264-0AB6-11d6-9193-00A0249B6F00}",
						},
						[7] = {
							CLSID = "{E8D4652F-FD48-45B7-BA5B-2AE05BB5A9CF}",
						},
						[8] = {
							CLSID = "{752AF1D2-EBCC-4bd7-A1E7-2357F5601C70}",
						},
						[9] = {
							CLSID = "{752AF1D2-EBCC-4bd7-A1E7-2357F5601C70}",
						},
						[10] = {
							CLSID = "{CBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[11] = {
							CLSID = "{44EE8698-89F9-48EE-AF36-5FD31896A82C}",
						},
					},
					fuel = "3790",
					flare = 128,
					chaff = 128,
					gun = 100,
				},
			},
		},
		Strike = {
			["Standoff, R-60M*4, Fuel"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "SAM", "frontline" },
				code_loadout =  { "Caucasus" },
				weaponType = "ASM",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 800000,
				firepower = 1,
				vCruise = 230,
				vAttack = 250,
				hCruise = 500,
				hAttack = 1000,
				standoff = 15000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[2] = {
							CLSID = "{CBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[3] = {
							CLSID = "{E8D4652F-FD48-45B7-BA5B-2AE05BB5A9CF}",
						},
						[4] = {
							CLSID = "{F789E86A-EE2E-4E6B-B81E-D5E5F903B6ED}",
						},
						[6] = {
							CLSID = "{B1EF6B0E-3D91-4047-A7A5-A99E7D8B4A8B}",
						},
						[8] = {
							CLSID = "{F789E86A-EE2E-4E6B-B81E-D5E5F903B6ED}",
						},
						[11] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[10] = {
							CLSID = "{CBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[9] = {
							CLSID = "{E8D4652F-FD48-45B7-BA5B-2AE05BB5A9CF}",
						},
					},
					fuel = "3790",
					flare = 128,
					chaff = 128,
					gun = 100,
				},
			},
			["Bombs 1, R-60M*4, Fuel"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "SAM", "Structure", "frontline" },
				code_loadout =  { "Caucasus" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 800000,
				firepower = 1,
				vCruise = 230,
				vAttack = 250,
				hCruise = 500,
				hAttack = 1000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[2] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
						[3] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
						[4] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
						[5] = {
							CLSID = "{E8D4652F-FD48-45B7-BA5B-2AE05BB5A9CF}",
						},
						[7] = {
							CLSID = "{E8D4652F-FD48-45B7-BA5B-2AE05BB5A9CF}",
						},
						[8] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
						[9] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
						[10] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
						[11] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
					},
					fuel = "3790",
					flare = 128,
					chaff = 128,
					gun = 100,
				},
			},
			["Bombs 2 LowAlt, R-60M*4, Fuel"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Parked Aircraft", "frontline" },
				code_loadout =  { "Caucasus" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 800000,
				firepower = 1,
				vCruise = 200,
				vAttack = 250,
				hCruise = 500,
				hAttack = 1000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[2] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
						[3] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
						[4] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
						[5] = {
							CLSID = "{E8D4652F-FD48-45B7-BA5B-2AE05BB5A9CF}",
						},
						[7] = {
							CLSID = "{E8D4652F-FD48-45B7-BA5B-2AE05BB5A9CF}",
						},
						[8] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
						[9] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
						[10] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
						[11] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
					},
					fuel = "3790",
					flare = 128,
					chaff = 128,
					gun = 100,
				},
			},
			["Bombs 3 LowAlt, R-60M*4, Fuel"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "frontline" },
				code_loadout =  { "Caucasus" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 800000,
				firepower = 1,
				vCruise = 200,
				vAttack = 250,
				hCruise = 500,
				hAttack = 1000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[2] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
						[3] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
						[4] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
						[5] = {
							CLSID = "{E8D4652F-FD48-45B7-BA5B-2AE05BB5A9CF}",
						},
						[7] = {
							CLSID = "{E8D4652F-FD48-45B7-BA5B-2AE05BB5A9CF}",
						},
						[8] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
						[9] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
						[10] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
						[11] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
					},
					fuel = "3790",
					flare = 128,
					chaff = 128,
					gun = 100,
				},
			},
			["BGL, R-60M*4, Fuel"] = {
				minscore = 0.3,
				support = {
					SEAD = true,
					Escort = true,
					["Laser Illumination"] = true,
				},
				attributes =  { "Structure", "soft", "frontline" },
				code_loadout =  { "Caucasus" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				range = 800000,
				firepower = 1,
				vCruise = 230,
				vAttack = 250,
				hCruise = 500,
				hAttack = 5000,
				standoff = 15000,
				sortie_rate = 1,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[2] = {
							CLSID = "{CBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[11] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[7] = {
							CLSID = "{E2C426E3-8B10-4E09-B733-9CDC26520F48}",
						},
						[10] = {
							CLSID = "{CBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[3] = {
							CLSID = "{E8D4652F-FD48-45B7-BA5B-2AE05BB5A9CF}",
						},
						[6] = {
							CLSID = "{B1EF6B0E-3D91-4047-A7A5-A99E7D8B4A8B}",
						},
						[9] = {
							CLSID = "{E8D4652F-FD48-45B7-BA5B-2AE05BB5A9CF}",
						},
						[5] = {
							CLSID = "{E2C426E3-8B10-4E09-B733-9CDC26520F48}",
						},
					},
					fuel = "3790",
					flare = 128,
					chaff = 128,
					gun = 100,
				},
			},
		},
	},
	["MiG-25RBT"] = {
		Reconnaissance = {
			Default = {
				attributes =  { },
				code_loadout =  { "IIW" },
				night = true,
				adverseWeather = true,
				range = 548000,
				firepower = 1,
				vCruise = 270,
				vAttack = 300,
				hCruise = 7548,
				hAttack = 8767,
				sortie_rate = 6,
				stores = {
					pylons = {
					},
					fuel = "15245",
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		Strike = {
			["Strike Fab500*2, R-60*2"] = {
				minscore = 0.3,
				attributes =  { "Parked Aircraft", "SAM", "Structure" },
				code_loadout =  { "IIW" },
				weaponType = "Bombs",
				expend = "all",
				attackType = "Dive",
								range = 492000,
				firepower = 1,
				vCruise = 260,
				vAttack = 300,
				hCruise = 7578,
				hAttack = 6000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[2] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
						[3] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
						[4] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
					},
					fuel = "15245",
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
			["Strike Fab500*4"] = {
				minscore = 0.3,
				attributes =  { "Parked Aircraft", "SAM", "Structure" },
				code_loadout =  { "IIW" },
				weaponType = "Bombs",
				expend = "all",
				attackType = "Dive",
								range = 492000,
				firepower = 1,
				vCruise = 260,
				vAttack = 300,
				hCruise = 7578,
				hAttack = 6000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
						[2] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
						[3] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
						[4] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
					},
					fuel = "15245",
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
	},
	["F-86F Sabre"] = {
		Strike = {
			["IPW - Strike - 200gal Fuel*2, AIM-9*2, HVAR*8"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "soft", "Parked Aircraft" },
				code_loadout =  { "IPW71" },
				weaponType = "Rockets",
				expend = "Auto",
				attackType = "Dive",
								range = 450000,
				firepower = 1,
				vCruise = 200,
				vAttack = 300.5,
				hCruise = 5486.4,
				hAttack = 4572,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{PTB_200_F86F35}",
						},
						[3] = {
							CLSID = "{HVARx2}",
						},
						[4] = {
							CLSID = "{HVARx2}",
						},
						[5] = {
							CLSID = "{GAR-8}",
						},
						[6] = {
							CLSID = "{GAR-8}",
						},
						[7] = {
							CLSID = "{HVARx2}",
						},
						[8] = {
							CLSID = "{HVARx2}",
						},
						[10] = {
							CLSID = "{PTB_200_F86F35}",
						},
					},
					fuel = "1282",
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
			["IPW - Strike - 200gal Fuel*2, AIM-9*2, AN-M64*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "soft", "Parked Aircraft", "Structure" },
				code_loadout =  { "IPW71" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
								range = 450000,
				firepower = 1,
				vCruise = 200,
				vAttack = 300.5,
				hCruise = 5486.4,
				hAttack = 4572,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{PTB_200_F86F35}",
						},
						[4] = {
							CLSID = "{F86ANM64}",
						},
						[5] = {
							CLSID = "{GAR-8}",
						},
						[6] = {
							CLSID = "{GAR-8}",
						},
						[7] = {
							CLSID = "{F86ANM64}",
						},
						[10] = {
							CLSID = "{PTB_200_F86F35}",
						},
					},
					fuel = "1282",
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
			["IPW - IPW - Strike - AIM-9*2, HVAR*16"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "soft", "Parked Aircraft" },
				code_loadout =  { "IPW71" },
				weaponType = "Rockets",
				expend = "Auto",
				attackType = "Dive",
								range = 450000,
				firepower = 1,
				vCruise = 200,
				vAttack = 300.5,
				hCruise = 5486.4,
				hAttack = 4572,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{HVARx2}",
						},
						[2] = {
							CLSID = "{HVARx2}",
						},
						[3] = {
							CLSID = "{HVARx2}",
						},
						[4] = {
							CLSID = "{HVARx2}",
						},
						[5] = {
							CLSID = "{GAR-8}",
						},
						[6] = {
							CLSID = "{GAR-8}",
						},
						[7] = {
							CLSID = "{HVARx2}",
						},
						[8] = {
							CLSID = "{HVARx2}",
						},
						[9] = {
							CLSID = "{HVARx2}",
						},
						[10] = {
							CLSID = "{HVARx2}",
						},
					},
					fuel = "1282",
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
			["IPW - Strike - 200gal Fuel*2, AIM-9*2, M117*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "soft", "Parked Aircraft", "Structure" },
				code_loadout =  { "IPW71" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
								range = 450000,
				firepower = 1,
				vCruise = 200,
				vAttack = 300.5,
				hCruise = 5486.4,
				hAttack = 4572,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{PTB_200_F86F35}",
						},
						[4] = {
							CLSID = "{00F5DAC4-0466-4122-998F-B1A298E34113}",
						},
						[5] = {
							CLSID = "{GAR-8}",
						},
						[6] = {
							CLSID = "{GAR-8}",
						},
						[7] = {
							CLSID = "{00F5DAC4-0466-4122-998F-B1A298E34113}",
						},
						[10] = {
							CLSID = "{PTB_200_F86F35}",
						},
					},
					fuel = "1282",
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		["Fighter Sweep"] = {
			["Fighter Sweep IPW - 200gal Fuel*2, AIM-9*2"] = {
				self_escort = true,
				attributes =  { },
				code_loadout =  { "IPW71" },
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
						[1] = {
							CLSID = "{PTB_200_F86F35}",
						},
						[5] = {
							CLSID = "{GAR-8}",
						},
						[10] = {
							CLSID = "{PTB_200_F86F35}",
						},
						[6] = {
							CLSID = "{GAR-8}",
						},
					},
					fuel = "1282",
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		Escort = {
			[" Escort IPW - 200gal Fuel*2, AIM-9*2"] = {
				attributes =  { },
				code_loadout =  { "IPW71" },
								range = 250000,
				firepower = 1,
				vCruise = 200,
				standoff = 40000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{PTB_200_F86F35}",
						},
						[5] = {
							CLSID = "{GAR-8}",
						},
						[10] = {
							CLSID = "{PTB_200_F86F35}",
						},
						[6] = {
							CLSID = "{GAR-8}",
						},
					},
					fuel = "1282",
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		CAP = {
			["CAP IPW - 200gal Fuel*2, AIM-9*2"] = {
				self_escort = true,
				attributes =  { },
				code_loadout =  { "IPW71" },
								range = 250000,
				firepower = 1,
				vCruise = 180,
				vAttack = 200,
				hCruise = 7096,
				hAttack = 7096,
				tStation = 1800,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{PTB_200_F86F35}",
						},
						[5] = {
							CLSID = "{GAR-8}",
						},
						[10] = {
							CLSID = "{PTB_200_F86F35}",
						},
						[6] = {
							CLSID = "{GAR-8}",
						},
					},
					fuel = "1282",
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		["Anti-ship Strike"] = {
			["IPW - Antiship Strike - 200gal Fuel*2, AIM-9*2, AN-M64*2"] = {
				minscore = 0.3,
				support = {
					SEAD = false,
					Escort = true,
					["Laser Illumination"] = false,
				},
				attributes =  { "ship" },
				code_loadout =  { "IPW71" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
								range = 450000,
				firepower = 1,
				vCruise = 200,
				vAttack = 300.5,
				hCruise = 5000,
				hAttack = 5000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{PTB_200_F86F35}",
						},
						[4] = {
							CLSID = "{F86ANM64}",
						},
						[5] = {
							CLSID = "{GAR-8}",
						},
						[6] = {
							CLSID = "{GAR-8}",
						},
						[7] = {
							CLSID = "{F86ANM64}",
						},
						[10] = {
							CLSID = "{PTB_200_F86F35}",
						},
					},
					fuel = "1282",
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
			["IPW - Antiship Strike - 200gal Fuel*2, AIM-9*2, M117*2"] = {
				minscore = 0.3,
				support = {
					SEAD = false,
					Escort = true,
					["Laser Illumination"] = false,
				},
				attributes =  { "ship" },
				code_loadout =  { "IPW71" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
								range = 450000,
				firepower = 1,
				vCruise = 200,
				vAttack = 300.5,
				hCruise = 5000,
				hAttack = 5000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{PTB_200_F86F35}",
						},
						[4] = {
							CLSID = "{00F5DAC4-0466-4122-998F-B1A298E34113}",
						},
						[5] = {
							CLSID = "{GAR-8}",
						},
						[6] = {
							CLSID = "{GAR-8}",
						},
						[7] = {
							CLSID = "{00F5DAC4-0466-4122-998F-B1A298E34113}",
						},
						[10] = {
							CLSID = "{PTB_200_F86F35}",
						},
					},
					fuel = "1282",
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
			["Antiship IPW - Strike - AIM-9*2, HVAR*16"] = {
				minscore = 0.3,
				support = {
					SEAD = false,
					Escort = true,
					["Laser Illumination"] = false,
				},
				attributes =  { "ship" },
				code_loadout =  { "IPW71" },
				weaponType = "Rockets",
				expend = "Auto",
				attackType = "Dive",
								range = 450000,
				firepower = 1,
				vCruise = 200,
				vAttack = 300.5,
				hCruise = 5486.4,
				hAttack = 4572,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{HVARx2}",
						},
						[2] = {
							CLSID = "{HVARx2}",
						},
						[3] = {
							CLSID = "{HVARx2}",
						},
						[4] = {
							CLSID = "{HVARx2}",
						},
						[5] = {
							CLSID = "{GAR-8}",
						},
						[6] = {
							CLSID = "{GAR-8}",
						},
						[7] = {
							CLSID = "{HVARx2}",
						},
						[8] = {
							CLSID = "{HVARx2}",
						},
						[9] = {
							CLSID = "{HVARx2}",
						},
						[10] = {
							CLSID = "{HVARx2}",
						},
					},
					fuel = "1282",
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
			["Antiship IPW - Strike - 200gal Fuel*2, AIM-9*2, HVAR*8"] = {
				minscore = 0.3,
				support = {
					SEAD = false,
					Escort = true,
					["Laser Illumination"] = false,
				},
				attributes =  { "ship" },
				code_loadout =  { "IPW71" },
				weaponType = "Rockets",
				expend = "Auto",
				attackType = "Dive",
								range = 450000,
				firepower = 1,
				vCruise = 200,
				vAttack = 300.5,
				hCruise = 5486.4,
				hAttack = 4572,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{PTB_200_F86F35}",
						},
						[3] = {
							CLSID = "{HVARx2}",
						},
						[4] = {
							CLSID = "{HVARx2}",
						},
						[5] = {
							CLSID = "{GAR-8}",
						},
						[6] = {
							CLSID = "{GAR-8}",
						},
						[7] = {
							CLSID = "{HVARx2}",
						},
						[8] = {
							CLSID = "{HVARx2}",
						},
						[10] = {
							CLSID = "{PTB_200_F86F35}",
						},
					},
					fuel = "1282",
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		Intercept = {
			["Intercept IPW - AIM-9*2"] = {
				attributes =  { },
				code_loadout =  { "IPW71" },
								range = 250000,
				firepower = 1,
				sortie_rate = 6,
				stores = {
					pylons = {
						[6] = {
							CLSID = "{GAR-8}",
						},
						[5] = {
							CLSID = "{GAR-8}",
						},
					},
					fuel = "1282",
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
			["Intercept IPW - 200gal Fuel*2, AIM-9*2"] = {
				attributes =  { },
				code_loadout =  { "IPW71" },
								range = 150000,
				firepower = 1,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{PTB_200_F86F35}",
						},
						[5] = {
							CLSID = "{GAR-8}",
						},
						[10] = {
							CLSID = "{PTB_200_F86F35}",
						},
						[6] = {
							CLSID = "{GAR-8}",
						},
					},
					fuel = "1282",
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
	},
	["Su-25TM"] = {
		["Anti-ship Strike"] = {
			["Antiship Kh-35*2_R-73*2_Fuel*2_MPS410_Kopyo-25"] = {
				minscore = 0.1,
				support = {
					-- Escort = true,
					SEAD = false,
					["Escort Jammer"] = true,
				},
				attributes =  { "ship" },
				code_loadout =  { "TF", "Caucasus" },
				weaponType = "ASM",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 900000,
				firepower = 1,
				vCruise = 220,
				vAttack = 260,
				hCruise = 296,
				hAttack = 296,
				standoff = 60000,
				ingress = 50000,
				egress = 10000,
				MaxAttackOffset = 60,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{44EE8698-89F9-48EE-AF36-5FD31896A82D}",
						},
						[2] = {
							CLSID = "{CBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[3] = {
							CLSID = "{E8D4652F-FD48-45B7-BA5B-2AE05BB5A9CF}",
						},
						[5] = {
							CLSID = "{2234F529-1D57-4496-8BB0-0150F9BDBBD3}",
						},
						[6] = {
							CLSID = "{F4920E62-A99A-11d8-9897-000476191836}",
						},
						[7] = {
							CLSID = "{2234F529-1D57-4496-8BB0-0150F9BDBBD3}",
						},
						[9] = {
							CLSID = "{E8D4652F-FD48-45B7-BA5B-2AE05BB5A9CF}",
						},
						[10] = {
							CLSID = "{CBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[11] = {
							CLSID = "{44EE8698-89F9-48EE-AF36-5FD31896A82D}",
						},
					},
					fuel = "3790",
					flare = 128,
					chaff = 128,
					gun = 100,
				},
			},
			["Antiship Kh-31A*2_R-73*2_Fuel*2_MPS410_Kopyo-25"] = {
				minscore = 0.1,
				support = {
					-- Escort = true,
					SEAD = false,
					["Escort Jammer"] = true,
				},
				attributes =  { "ship" },
				code_loadout =  { "TF", "Caucasus" },
				weaponType = "ASM",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 900000,
				firepower = 1,
				vCruise = 220,
				vAttack = 260,
				hCruise = 296,
				hAttack = 296,
				standoff = 40000,
				ingress = 50000,
				egress = 10000,
				MaxAttackOffset = 60,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{44EE8698-89F9-48EE-AF36-5FD31896A82D}",
						},
						[2] = {
							CLSID = "{CBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[3] = {
							CLSID = "{E8D4652F-FD48-45B7-BA5B-2AE05BB5A9CF}",
						},
						[5] = {
							CLSID = "{4D13E282-DF46-4B23-864A-A9423DFDE50A}",
						},
						[6] = {
							CLSID = "{F4920E62-A99A-11d8-9897-000476191836}",
						},
						[7] = {
							CLSID = "{4D13E282-DF46-4B23-864A-A9423DFDE50A}",
						},
						[9] = {
							CLSID = "{E8D4652F-FD48-45B7-BA5B-2AE05BB5A9CF}",
						},
						[10] = {
							CLSID = "{CBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[11] = {
							CLSID = "{44EE8698-89F9-48EE-AF36-5FD31896A82D}",
						},
					},
					fuel = "3790",
					flare = 128,
					chaff = 128,
					gun = 100,
				},
			},
		},
	},
	["KC-135"] = {
		Refueling = {
			Default = {
				attributes =  { "KC135" },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 185,
				vAttack = 185,
				hCruise = 7000,
				hAttack = 7000,
				tStation = 21600,
				sortie_rate = 3,
				stores = {
					pylons = {
					},
					fuel = 90700,
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
		},
	},
	["MiG-25PD"] = {
		CAP = {
			["R-40R*2, R-40T*2"] = {
				self_escort = true,
				attributes =  { },
				code_loadout =  { "TF80s", "TF80sRED", "TF80sI", "WOC80", "WOB" },
				night = true,
				adverseWeather = true,
				range = 484000,
				firepower = 2,
				vCruise = 255,
				vAttack = 255,
				hCruise = 7822,
				hAttack = 7822,
				standoff = 100000,
				tStation = 2000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{5F26DBC2-FB43-4153-92DE-6BBCE26CB0FF}",
						},
						[2] = {
							CLSID = "{4EDBA993-2E34-444C-95FB-549300BF7CAF}",
						},
						[3] = {
							CLSID = "{4EDBA993-2E34-444C-95FB-549300BF7CAF}",
						},
						[4] = {
							CLSID = "{5F26DBC2-FB43-4153-92DE-6BBCE26CB0FF}",
						},
					},
					fuel = "15245",
					flare = 64,
					chaff = 64,
					gun = 100,
				},
			},
			["R-40R*4"] = {
				self_escort = true,
				attributes =  { },
				code_loadout =  { "TF80s", "TF80sRED", "TF80sI", "WOC80", "WOB" },
				night = true,
				adverseWeather = true,
				range = 484000,
				firepower = 2,
				vCruise = 255,
				vAttack = 255,
				hCruise = 7822,
				hAttack = 7822,
				standoff = 100000,
				tStation = 2000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{4EDBA993-2E34-444C-95FB-549300BF7CAF}",
						},
						[2] = {
							CLSID = "{4EDBA993-2E34-444C-95FB-549300BF7CAF}",
						},
						[3] = {
							CLSID = "{4EDBA993-2E34-444C-95FB-549300BF7CAF}",
						},
						[4] = {
							CLSID = "{4EDBA993-2E34-444C-95FB-549300BF7CAF}",
						},
					},
					fuel = "15245",
					flare = 64,
					chaff = 64,
					gun = 100,
				},
			},
		},
		["Fighter Sweep"] = {
			["R-40R*2, R-40T*2"] = {
				attributes =  { },
				code_loadout =  { "IIW", "TF80s", "TF80sRED", "TF80sI", "WOC80", "WOB" },
				night = true,
				adverseWeather = true,
				range = 484000,
				firepower = 2,
				vCruise = 255,
				vAttack = 255,
				hCruise = 7822,
				hAttack = 7822,
				standoff = 100000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{5F26DBC2-FB43-4153-92DE-6BBCE26CB0FF}",
						},
						[2] = {
							CLSID = "{4EDBA993-2E34-444C-95FB-549300BF7CAF}",
						},
						[3] = {
							CLSID = "{4EDBA993-2E34-444C-95FB-549300BF7CAF}",
						},
						[4] = {
							CLSID = "{5F26DBC2-FB43-4153-92DE-6BBCE26CB0FF}",
						},
					},
					fuel = "15245",
					flare = 64,
					chaff = 64,
					gun = 100,
				},
			},
			["R-40R*4"] = {
				attributes =  { },
				code_loadout =  { "IIW", "TF80s", "TF80sRED", "TF80sI", "WOC80", "WOB" },
				night = true,
				adverseWeather = true,
				range = 484000,
				firepower = 2,
				vCruise = 255,
				vAttack = 255,
				hCruise = 7822,
				hAttack = 7822,
				standoff = 100000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{4EDBA993-2E34-444C-95FB-549300BF7CAF}",
						},
						[2] = {
							CLSID = "{4EDBA993-2E34-444C-95FB-549300BF7CAF}",
						},
						[3] = {
							CLSID = "{4EDBA993-2E34-444C-95FB-549300BF7CAF}",
						},
						[4] = {
							CLSID = "{4EDBA993-2E34-444C-95FB-549300BF7CAF}",
						},
					},
					fuel = "15245",
					flare = 64,
					chaff = 64,
					gun = 100,
				},
			},
		},
		Intercept = {
			["R-40R*2, R-40T*2"] = {
				attributes =  { },
				code_loadout =  { "IIW", "TF80s", "TF80sRED", "TF80sI", "WOC80", "WOB" },
				night = true,
				adverseWeather = true,
				range = 484000,
				firepower = 2,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{5F26DBC2-FB43-4153-92DE-6BBCE26CB0FF}",
						},
						[2] = {
							CLSID = "{4EDBA993-2E34-444C-95FB-549300BF7CAF}",
						},
						[3] = {
							CLSID = "{4EDBA993-2E34-444C-95FB-549300BF7CAF}",
						},
						[4] = {
							CLSID = "{5F26DBC2-FB43-4153-92DE-6BBCE26CB0FF}",
						},
					},
					fuel = "15245",
					flare = 64,
					chaff = 64,
					gun = 100,
				},
			},
			["R-40R*4"] = {
				attributes =  { },
				code_loadout =  { "IIW", "TF80s", "TF80sRED", "TF80sI", "WOC80", "WOB" },
				night = true,
				adverseWeather = true,
				range = 484000,
				firepower = 2,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{4EDBA993-2E34-444C-95FB-549300BF7CAF}",
						},
						[2] = {
							CLSID = "{4EDBA993-2E34-444C-95FB-549300BF7CAF}",
						},
						[3] = {
							CLSID = "{4EDBA993-2E34-444C-95FB-549300BF7CAF}",
						},
						[4] = {
							CLSID = "{4EDBA993-2E34-444C-95FB-549300BF7CAF}",
						},
					},
					fuel = "15245",
					flare = 64,
					chaff = 64,
					gun = 100,
				},
			},
		},
	},
	["MiG-27K"] = {
		SEAD = {
			["Kh-25MPU*2,R-60M*2,Fuel"] = {
				attributes =  { },
				code_loadout =  { "IIW", "WOC80" },
				weaponType = "ASM",
				attackType = "Dive",
				night = true,
				adverseWeather = true,
				range = 664000,
				firepower = 1,
				vCruise = 190,
				vAttack = 400,
				hCruise = 6328,
				hAttack = 4000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[2] = {
							CLSID = "{752AF1D2-EBCC-4bd7-A1E7-2357F5601C70}",
						},
						[3] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[5] = {
							CLSID = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
						},
						[7] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[8] = {
							CLSID = "{752AF1D2-EBCC-4bd7-A1E7-2357F5601C70}",
						},
					},
					fuel = "4500",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
		},
		["Runway Attack"] = {
			["RAttack FAB-500*2,FAB-250*2,R-60M*2,Fuel"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Runway" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 400000,
				firepower = 1,
				vCruise = 190,
				vAttack = 277.5,
				hCruise = 5924.8,
				hAttack = 200,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[2] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
						[3] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[4] = {
							CLSID = "{3C612111-C7AD-476E-8A8E-2485812F4E5C}",
						},
						[5] = {
							CLSID = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
						},
						[6] = {
							CLSID = "{3C612111-C7AD-476E-8A8E-2485812F4E5C}",
						},
						[7] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[8] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
					},
					fuel = "4500",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
		},
		Strike = {
			["Kh-29T*2, R-60*2, FT"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "Structure", "Bridge", "frontline" },
				code_loadout =  { "IIW", "WOC80" },
				weaponType = "ASM",
				expend = "Auto",
				attackType = "Dive",
								range = 388000,
				firepower = 1,
				vCruise = 190,
				vAttack = 277,
				hCruise = 5530,
				hAttack = 2000,
				standoff = 15000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[2] = {
							CLSID = "{601C99F7-9AF3-4ed7-A565-F8B8EC0D7AAC}",
						},
						[3] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[5] = {
							CLSID = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
						},
						[7] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[8] = {
							CLSID = "{601C99F7-9AF3-4ed7-A565-F8B8EC0D7AAC}",
						},
					},
					fuel = "4500",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["GTA STRIKE2 Kh-25L*2,R-60M*2,Fuel"] = {
				minscore = 0.3,
				support = {
					SEAD = false,
					Escort = true,
					["Laser Illumination"] = false,
				},
				attributes =  { "soft", "Parked Aircraft", "Structure", "SAM", "frontline" },
				code_loadout =  { "HWITC", "WOC80" },
				weaponType = "ASM",
				expend = "Auto",
				adverseWeather = true,
				range = 400000,
				firepower = 1,
				vCruise = 190,
				vAttack = 277,
				hCruise = 5924.8,
				hAttack = 2315.2,
				standoff = 2000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[2] = {
							CLSID = "{79D73885-0801-45a9-917F-C90FE1CE3DFC}",
						},
						[3] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[5] = {
							CLSID = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
						},
						[7] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[8] = {
							CLSID = "{79D73885-0801-45a9-917F-C90FE1CE3DFC}",
						},
					},
					fuel = "4500",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["GTA STRIKE1 Kh-29L*2,R-60M*2,Fuel"] = {
				minscore = 0.3,
				support = {
					SEAD = false,
					Escort = true,
					["Laser Illumination"] = false,
				},
				attributes =  { "Structure", "SAM", "Bridge", "frontline" },
				code_loadout =  { "HWITC", "WOC80" },
				weaponType = "ASM",
				expend = "Auto",
				adverseWeather = true,
				range = 400000,
				firepower = 1,
				vCruise = 190,
				vAttack = 277.5,
				hCruise = 5315.2,
				hAttack = 2000,
				standoff = 2000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[2] = {
							CLSID = "{D4A8D9B9-5C45-42e7-BBD2-0E54F8308432}",
						},
						[3] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[5] = {
							CLSID = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
						},
						[7] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[8] = {
							CLSID = "{D4A8D9B9-5C45-42e7-BBD2-0E54F8308432}",
						},
					},
					fuel = "4500",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["GTA FAB-500*2,FAB-250*2,R-60M*2,Fuel"] = {
				minscore = 0.3,
				support = {
					SEAD = false,
					Escort = true,
					["Laser Illumination"] = false,
				},
				attributes =  { "soft", "Parked Aircraft", "Structure", "frontline" },
				code_loadout =  { "HWITC", "WOC80" },
				weaponType = "Bombs",
				expend = "All",
				adverseWeather = true,
				range = 400000,
				firepower = 1,
				vCruise = 190,
				vAttack = 277.5,
				hCruise = 5924.8,
				hAttack = 2315.2,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[2] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
						[3] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[4] = {
							CLSID = "{3C612111-C7AD-476E-8A8E-2485812F4E5C}",
						},
						[5] = {
							CLSID = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
						},
						[6] = {
							CLSID = "{3C612111-C7AD-476E-8A8E-2485812F4E5C}",
						},
						[7] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[8] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
					},
					fuel = "4500",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
		},
	},
	["A-10C"] = {
		Strike = {
			["Strike WOC AGM-65D*4, CBU-97, CBU-87,GBU-38*2, LAU-68 2.75*7, TGP, ECM, AIM-9M*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "frontline" },
				code_loadout =  { "Caucasus" },
				weaponType = "ASM",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 360000,
				firepower = 1,
				vCruise = 120,
				vAttack = 125,
				hCruise = 5200,
				hAttack = 5100,
				standoff = 9000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "ALQ_184",
						},
						[2] = {
							CLSID = "{174C6E6D-0C3D-42ff-BCB3-0853CB371F5C}",
						},
						[3] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98452}",
						},
						[4] = {
							CLSID = "{CBU-87}",
						},
						[5] = {
							CLSID = "{GBU-38}",
						},
						[7] = {
							CLSID = "{GBU-38}",
						},
						[8] = {
							CLSID = "{5335D97A-35A5-4643-9D9B-026C75961E52}",
						},
						[9] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98453}",
						},
						[10] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
						[11] = {
							CLSID = "{DB434044-F5D0-4F1F-9BA9-B73027E18DD3}",
						},
					},
					fuel = 5029,
					flare = 120,
					chaff = 240,
					gun = 100,
				},
			},
			["Strike AGM-65D*4, GBU-12*4, LAU-68 2.75*7, TGP, ECM, AIM-9M*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "Crisis", "WOB" },
				weaponType = "ASM",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 360000,
				firepower = 1,
				vCruise = 120,
				vAttack = 125,
				hCruise = 5200,
				hAttack = 5100,
				standoff = 9000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "ALQ_184",
						},
						[2] = {
							CLSID = "{174C6E6D-0C3D-42ff-BCB3-0853CB371F5C}",
						},
						[3] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98452}",
						},
						[4] = {
							CLSID = "{DB769D48-67D7-42ED-A2BE-108D566C8B1E}",
						},
						[5] = {
							CLSID = "{DB769D48-67D7-42ED-A2BE-108D566C8B1E}",
						},
						[7] = {
							CLSID = "{DB769D48-67D7-42ED-A2BE-108D566C8B1E}",
						},
						[8] = {
							CLSID = "{DB769D48-67D7-42ED-A2BE-108D566C8B1E}",
						},
						[9] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98453}",
						},
						[10] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
						[11] = {
							CLSID = "{DB434044-F5D0-4F1F-9BA9-B73027E18DD3}",
						},
					},
					fuel = 5029,
					flare = 120,
					chaff = 240,
					gun = 100,
				},
			},
			["GBU-38"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "Bridge" },
				code_loadout =  { },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 130000,
				firepower = 1,
				vCruise = 120,
				vAttack = 125,
				hCruise = 6200,
				hAttack = 7100,
				sortie_rate = 2,
				stores = {
					pylons = {
						[1] = {
							CLSID = "ALQ_184",
						},
						[3] = {
							CLSID = "{GBU-38}",
						},
						[4] = {
							CLSID = "{GBU-38}",
						},
						[5] = {
							CLSID = "{GBU-38}",
						},
						[6] = {
							CLSID = "Fuel_Tank_FT600",
						},
						[7] = {
							CLSID = "{GBU-38}",
						},
						[8] = {
							CLSID = "{GBU-38}",
						},
						[11] = {
							CLSID = "LAU-105_2*CATM-9M",
						},
						[10] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
						[9] = {
							CLSID = "{GBU-38}",
						},
					},
					fuel = 4526,
					flare = 120,
					chaff = 240,
					gun = 100,
				},
			},
			["Strike AGM-65D*2, AGM-65H*2, GBU-38*4, LAU-68 2.75*7, TGP, ECM, AIM-9M*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "Crisis", "WOB" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 360000,
				firepower = 1,
				vCruise = 120,
				vAttack = 125,
				hCruise = 5200,
				hAttack = 5100,
				standoff = 9000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "ALQ_184",
						},
						[2] = {
							CLSID = "{174C6E6D-0C3D-42ff-BCB3-0853CB371F5C}",
						},
						[3] = {
							CLSID = "LAU_88_AGM_65H_2_L",
						},
						[4] = {
							CLSID = "{GBU-38}",
						},
						[5] = {
							CLSID = "{GBU-38}",
						},
						[7] = {
							CLSID = "{GBU-38}",
						},
						[8] = {
							CLSID = "{GBU-38}",
						},
						[9] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98453}",
						},
						[10] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
						[11] = {
							CLSID = "{DB434044-F5D0-4F1F-9BA9-B73027E18DD3}",
						},
					},
					fuel = 5029,
					flare = 120,
					chaff = 240,
					gun = 100,
				},
			},
			["Strike WOC80 AGM-65D*4,Mk-82AIR*2, CBU-97*2, CBU-87, LAU-68 Heat 2.75*14,ECM, AIM-9L*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "SAM", "frontline" },
				code_loadout =  { "WOC80" },
				weaponType = "ASM",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 360000,
				firepower = 1,
				vCruise = 120,
				vAttack = 125,
				hCruise = 5200,
				hAttack = 5100,
				standoff = 9000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "ALQ_184",
						},
						[2] = {
							CLSID = "{319293F2-392C-4617-8315-7C88C22AF7C4}",
						},
						[3] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98452}",
						},
						[4] = {
							CLSID = "{5335D97A-35A5-4643-9D9B-026C75961E52}",
						},
						[5] = {
							CLSID = "{Mk82AIR}",
						},
						[6] = {
							CLSID = "{CBU-87}",
						},
						[7] = {
							CLSID = "{Mk82AIR}",
						},
						[8] = {
							CLSID = "{5335D97A-35A5-4643-9D9B-026C75961E52}",
						},
						[9] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98453}",
						},
						[10] = {
							CLSID = "{319293F2-392C-4617-8315-7C88C22AF7C4}",
						},
						[11] = {
							CLSID = "LAU-105_2*AIM-9L",
						},
					},
					fuel = 5029,
					flare = 120,
					chaff = 240,
					gun = 100,
				},
			},
			["GBU-10"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Structure", "Bridge" },
				code_loadout =  { },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 360000,
				firepower = 1,
				vCruise = 120,
				vAttack = 125,
				hCruise = 6200,
				hAttack = 7100,
				standoff = 11000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "ALQ_184",
						},
						[6] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[10] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
						[3] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[9] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[11] = {
							CLSID = "LAU-105_2*CATM-9M",
						},
					},
					fuel = 5029,
					flare = 120,
					chaff = 240,
					gun = 100,
				},
			},
			["Strike WOC AGM-65D*4, GBU-12*4, LAU-68 2.75*7, TGP, ECM, AIM-9M*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "frontline" },
				code_loadout =  { "Caucasus" },
				weaponType = "ASM",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 360000,
				firepower = 1,
				vCruise = 120,
				vAttack = 125,
				hCruise = 5200,
				hAttack = 5100,
				standoff = 9000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "ALQ_184",
						},
						[2] = {
							CLSID = "{174C6E6D-0C3D-42ff-BCB3-0853CB371F5C}",
						},
						[3] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98452}",
						},
						[4] = {
							CLSID = "{DB769D48-67D7-42ED-A2BE-108D566C8B1E}",
						},
						[5] = {
							CLSID = "{DB769D48-67D7-42ED-A2BE-108D566C8B1E}",
						},
						[7] = {
							CLSID = "{DB769D48-67D7-42ED-A2BE-108D566C8B1E}",
						},
						[8] = {
							CLSID = "{DB769D48-67D7-42ED-A2BE-108D566C8B1E}",
						},
						[9] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98453}",
						},
						[10] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
						[11] = {
							CLSID = "{DB434044-F5D0-4F1F-9BA9-B73027E18DD3}",
						},
					},
					fuel = 5029,
					flare = 120,
					chaff = 240,
					gun = 100,
				},
			},
			["Strike WOC AGM-65D*2, AGM-65H*2, CBU-97*2, CBU-87*2, LAU-68 2.75*7, TGP, ECM, AIM-9M*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "frontline" },
				code_loadout =  { "Caucasus" },
				weaponType = "ASM",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 360000,
				firepower = 1,
				vCruise = 120,
				vAttack = 125,
				hCruise = 5200,
				hAttack = 5100,
				standoff = 9000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "ALQ_184",
						},
						[2] = {
							CLSID = "{174C6E6D-0C3D-42ff-BCB3-0853CB371F5C}",
						},
						[3] = {
							CLSID = "LAU_88_AGM_65H_2_L",
						},
						[4] = {
							CLSID = "{5335D97A-35A5-4643-9D9B-026C75961E52}",
						},
						[5] = {
							CLSID = "{CBU-87}",
						},
						[7] = {
							CLSID = "{CBU-87}",
						},
						[8] = {
							CLSID = "{5335D97A-35A5-4643-9D9B-026C75961E52}",
						},
						[9] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98453}",
						},
						[10] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
						[11] = {
							CLSID = "{DB434044-F5D0-4F1F-9BA9-B73027E18DD3}",
						},
					},
					fuel = 5029,
					flare = 120,
					chaff = 240,
					gun = 100,
				},
			},
			["Strike WOC AGM-65D*2, AGM-65H*2, GBU-38*4, LAU-68 2.75*7, TGP, ECM, AIM-9M*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "frontline" },
				code_loadout =  { "Caucasus" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 360000,
				firepower = 1,
				vCruise = 120,
				vAttack = 125,
				hCruise = 5200,
				hAttack = 5100,
				standoff = 9000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "ALQ_184",
						},
						[2] = {
							CLSID = "{174C6E6D-0C3D-42ff-BCB3-0853CB371F5C}",
						},
						[3] = {
							CLSID = "LAU_88_AGM_65H_2_L",
						},
						[4] = {
							CLSID = "{GBU-38}",
						},
						[5] = {
							CLSID = "{GBU-38}",
						},
						[7] = {
							CLSID = "{GBU-38}",
						},
						[8] = {
							CLSID = "{GBU-38}",
						},
						[9] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98453}",
						},
						[10] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
						[11] = {
							CLSID = "{DB434044-F5D0-4F1F-9BA9-B73027E18DD3}",
						},
					},
					fuel = 5029,
					flare = 120,
					chaff = 240,
					gun = 100,
				},
			},
			["Strike AGM-65D*4, CBU-97, CBU-87,GBU-38*2, LAU-68 2.75*7, TGP, ECM, AIM-9M*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "Crisis", "WOB" },
				weaponType = "ASM",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 360000,
				firepower = 1,
				vCruise = 120,
				vAttack = 125,
				hCruise = 5200,
				hAttack = 5100,
				standoff = 9000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "ALQ_184",
						},
						[2] = {
							CLSID = "{174C6E6D-0C3D-42ff-BCB3-0853CB371F5C}",
						},
						[3] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98452}",
						},
						[4] = {
							CLSID = "{CBU-87}",
						},
						[5] = {
							CLSID = "{GBU-38}",
						},
						[7] = {
							CLSID = "{GBU-38}",
						},
						[8] = {
							CLSID = "{5335D97A-35A5-4643-9D9B-026C75961E52}",
						},
						[9] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98453}",
						},
						[10] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
						[11] = {
							CLSID = "{DB434044-F5D0-4F1F-9BA9-B73027E18DD3}",
						},
					},
					fuel = 5029,
					flare = 120,
					chaff = 240,
					gun = 100,
				},
			},
			["Strike Heavy AGM-65D*2, GBU-31*2, LAU-68 2.75*7, TGP, ECM, AIM-9M*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Bridge", "Structure" },
				code_loadout =  { "WOB" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 360000,
				firepower = 1,
				vCruise = 120,
				vAttack = 125,
				hCruise = 5200,
				hAttack = 5100,
				standoff = 9000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "ALQ_184",
						},
						[2] = {
							CLSID = "{174C6E6D-0C3D-42ff-BCB3-0853CB371F5C}",
						},
						[3] = {
							CLSID = "LAU_88_AGM_65D_ONE",
						},
						[5] = {
							CLSID = "{GBU-31}",
						},
						[7] = {
							CLSID = "{GBU-31}",
						},
						[11] = {
							CLSID = "{DB434044-F5D0-4F1F-9BA9-B73027E18DD3}",
						},
						[10] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
						[9] = {
							CLSID = "LAU_88_AGM_65D_ONE",
						},
					},
					fuel = 5029,
					flare = 120,
					chaff = 240,
					gun = 100,
				},
			},
			["Strike Heavy AGM-65D*2, GBU-10*2, LAU-68 2.75*7, TGP, ECM, AIM-9M*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Bridge", "Structure" },
				code_loadout =  { "Crisis", "WOB" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 360000,
				firepower = 1,
				vCruise = 120,
				vAttack = 125,
				hCruise = 5200,
				hAttack = 5100,
				standoff = 2000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "ALQ_184",
						},
						[2] = {
							CLSID = "{174C6E6D-0C3D-42ff-BCB3-0853CB371F5C}",
						},
						[3] = {
							CLSID = "LAU_88_AGM_65D_ONE",
						},
						[5] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[7] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[11] = {
							CLSID = "{DB434044-F5D0-4F1F-9BA9-B73027E18DD3}",
						},
						[10] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
						[9] = {
							CLSID = "LAU_88_AGM_65D_ONE",
						},
					},
					fuel = 5029,
					flare = 120,
					chaff = 240,
					gun = 100,
				},
			},
			["GBU-12"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "Bridge" },
				code_loadout =  { },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 360000,
				firepower = 1,
				vCruise = 120,
				vAttack = 125,
				hCruise = 6200,
				hAttack = 7100,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "ALQ_184",
						},
						[3] = {
							CLSID = "{DB769D48-67D7-42ED-A2BE-108D566C8B1E}",
						},
						[4] = {
							CLSID = "{DB769D48-67D7-42ED-A2BE-108D566C8B1E}",
						},
						[5] = {
							CLSID = "{DB769D48-67D7-42ED-A2BE-108D566C8B1E}",
						},
						[6] = {
							CLSID = "Fuel_Tank_FT600",
						},
						[7] = {
							CLSID = "{DB769D48-67D7-42ED-A2BE-108D566C8B1E}",
						},
						[8] = {
							CLSID = "{DB769D48-67D7-42ED-A2BE-108D566C8B1E}",
						},
						[11] = {
							CLSID = "LAU-105_2*CATM-9M",
						},
						[10] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
						[9] = {
							CLSID = "{DB769D48-67D7-42ED-A2BE-108D566C8B1E}",
						},
					},
					fuel = 4526,
					flare = 120,
					chaff = 240,
					gun = 100,
				},
			},
			["Mk-82"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 130000,
				firepower = 1,
				vCruise = 120,
				vAttack = 125,
				hCruise = 5200,
				hAttack = 5100,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "ALQ_184",
						},
						[3] = {
							CLSID = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
						},
						[4] = {
							CLSID = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
						},
						[5] = {
							CLSID = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
						},
						[6] = {
							CLSID = "Fuel_Tank_FT600",
						},
						[7] = {
							CLSID = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
						},
						[8] = {
							CLSID = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
						},
						[11] = {
							CLSID = "LAU-105_2*CATM-9M",
						},
						[10] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
						[9] = {
							CLSID = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
						},
					},
					fuel = 3470,
					flare = 120,
					chaff = 240,
					gun = 100,
				},
			},
			["Mk-84"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Bridge", "Structure" },
				code_loadout =  { },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 360000,
				firepower = 1,
				vCruise = 120,
				vAttack = 125,
				hCruise = 5200,
				hAttack = 5100,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "ALQ_184",
						},
						[6] = {
							CLSID = "Fuel_Tank_FT600",
						},
						[10] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
						[3] = {
							CLSID = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
						},
						[9] = {
							CLSID = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
						},
						[11] = {
							CLSID = "LAU-105_2*CATM-9M",
						},
					},
					fuel = 5029,
					flare = 120,
					chaff = 240,
					gun = 100,
				},
			},
			["Strike AGM-65D*2, AGM-65H*2, CBU-97*2, CBU-87*2, LAU-68 2.75*7, TGP, ECM, AIM-9M*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "Crisis", "WOB" },
				weaponType = "ASM",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 360000,
				firepower = 1,
				vCruise = 120,
				vAttack = 125,
				hCruise = 5200,
				hAttack = 5100,
				standoff = 9000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "ALQ_184",
						},
						[2] = {
							CLSID = "{174C6E6D-0C3D-42ff-BCB3-0853CB371F5C}",
						},
						[3] = {
							CLSID = "LAU_88_AGM_65H_2_L",
						},
						[4] = {
							CLSID = "{5335D97A-35A5-4643-9D9B-026C75961E52}",
						},
						[5] = {
							CLSID = "{CBU-87}",
						},
						[7] = {
							CLSID = "{CBU-87}",
						},
						[8] = {
							CLSID = "{5335D97A-35A5-4643-9D9B-026C75961E52}",
						},
						[9] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98453}",
						},
						[10] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
						[11] = {
							CLSID = "{DB434044-F5D0-4F1F-9BA9-B73027E18DD3}",
						},
					},
					fuel = 5029,
					flare = 120,
					chaff = 240,
					gun = 100,
				},
			},
		},
		["Anti-ship Strike"] = {
			["Antiship Strike AGM-65G*2, GBU-10*2, LAU-68 2.75*7, TGP, ECM, AIM-9M*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "ship" },
				code_loadout =  { "Crisis", "WOB" },
				weaponType = "ASM",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 360000,
				firepower = 1,
				vCruise = 120,
				vAttack = 125,
				hCruise = 5200,
				hAttack = 5100,
				standoff = 9000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "ALQ_184",
						},
						[2] = {
							CLSID = "{174C6E6D-0C3D-42ff-BCB3-0853CB371F5C}",
						},
						[11] = {
							CLSID = "{DB434044-F5D0-4F1F-9BA9-B73027E18DD3}",
						},
						[7] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[10] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
						[3] = {
							CLSID = "LAU_117_AGM_65G",
						},
						[5] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[9] = {
							CLSID = "LAU_117_AGM_65G",
						},
					},
					fuel = 5029,
					flare = 120,
					chaff = 240,
					gun = 100,
				},
			},
		},
	},
	["F-15C"] = {
		CAP = {
			["80s AA LR - 4xAIM-9L - 4xAIM-7MH - 3xFT"] = {
				attributes =  { "Air Forces" },
				code_loadout =  { "WOC80" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 2,
				vCruise = 245,
				vAttack = 245,
				hCruise = 9753.6,
				hAttack = 9753.6,
				standoff = 46300,
				tStation = 7200,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[3] = {
							CLSID = "{AIM-9L}",
						},
						[4] = {
							CLSID = "{AIM-7H}",
						},
						[5] = {
							CLSID = "{AIM-7H}",
						},
						[6] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[7] = {
							CLSID = "{AIM-7H}",
						},
						[8] = {
							CLSID = "{AIM-7H}",
						},
						[9] = {
							CLSID = "{AIM-9L}",
						},
						[10] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[11] = {
							CLSID = "{AIM-9L}",
						},
					},
					fuel = "6103",
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
			["AIM-9M*4, AIM-120B*4, Fuel*3"] = {
				attributes =  { "Air Forces" },
				code_loadout =  { "Crisis", "PG" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 4,
				vCruise = 245,
				vAttack = 245,
				hCruise = 9753.6,
				hAttack = 9753.6,
				standoff = 46300,
				tStation = 7200,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[3] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[4] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[5] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[6] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[7] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[8] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[9] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[10] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[11] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = "6103",
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
			["2000s LR AA AIM-120C*4,  AIM-9M*4, Fuel*3"] = {
				attributes =  { "Air Forces" },
				code_loadout =  { "Caucasus", "WOB" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 4,
				vCruise = 245,
				vAttack = 245,
				hCruise = 9753.6,
				hAttack = 9753.6,
				standoff = 46300,
				tStation = 7200,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[3] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[4] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[5] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[6] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[7] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[8] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[9] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[10] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[11] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = "6103",
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
			["2000s LR AA AIM-120C*6,  AIM-9M*2, Fuel*3"] = {
				attributes =  { "Air Forces" },
				code_loadout =  { "Caucasus", "WOB" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 6,
				vCruise = 245,
				vAttack = 245,
				hCruise = 9753.6,
				hAttack = 9753.6,
				standoff = 46300,
				tStation = 7200,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[2] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[3] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[4] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[5] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[6] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[7] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[8] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[9] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[10] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[11] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
					},
					fuel = "6103",
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
		},
		["Fighter Sweep"] = {
			["80s AA LR - 4xAIM-9L - 4xAIM-7MH - 3xFT"] = {
				attributes =  { },
				code_loadout =  { "WOC80" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 2,
				vCruise = 255.83333333333,
				vAttack = 265.83333333333,
				hCruise = 9753.6,
				hAttack = 9753.6,
				standoff = 46300,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[3] = {
							CLSID = "{AIM-9L}",
						},
						[4] = {
							CLSID = "{AIM-7H}",
						},
						[5] = {
							CLSID = "{AIM-7H}",
						},
						[6] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[7] = {
							CLSID = "{AIM-7H}",
						},
						[8] = {
							CLSID = "{AIM-7H}",
						},
						[9] = {
							CLSID = "{AIM-9L}",
						},
						[10] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[11] = {
							CLSID = "{AIM-9L}",
						},
					},
					fuel = "6103",
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
			["AIM-9M*4, AIM-120B*4, Fuel*3"] = {
				attributes =  { },
				code_loadout =  { "Crisis", "PG" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 4,
				vCruise = 255.83333333333,
				vAttack = 265.83333333333,
				hCruise = 9753.6,
				hAttack = 9753.6,
				standoff = 46300,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[3] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[4] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[5] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[6] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[7] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[8] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[9] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[10] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[11] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = "6103",
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
			["2000s LR AA AIM-120C*4,  AIM-9M*4, Fuel*3"] = {
				attributes =  { },
				code_loadout =  { "Caucasus", "WOB" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 4,
				vCruise = 255.83333333333,
				vAttack = 265.83333333333,
				hCruise = 9753.6,
				hAttack = 9753.6,
				standoff = 46300,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[3] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[4] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[5] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[6] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[7] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[8] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[9] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[10] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[11] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = "6103",
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
			["2000s LR AA AIM-120C*6,  AIM-9M*2, Fuel*3"] = {
				attributes =  { },
				code_loadout =  { "Caucasus", "WOB" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 6,
				vCruise = 255.83333333333,
				vAttack = 265.83333333333,
				hCruise = 9753.6,
				hAttack = 9753.6,
				standoff = 46300,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[2] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[3] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[4] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[5] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[6] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[7] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[8] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[9] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[10] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[11] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
					},
					fuel = "6103",
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
		},
		Escort = {
			["80s AA LR - 4xAIM-9L - 4xAIM-7MH - 3xFT"] = {
				attributes =  { },
				code_loadout =  { "WOC80" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 2,
				vCruise = 255.83333333333,
				standoff = 46300,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[3] = {
							CLSID = "{AIM-9L}",
						},
						[4] = {
							CLSID = "{AIM-7H}",
						},
						[5] = {
							CLSID = "{AIM-7H}",
						},
						[6] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[7] = {
							CLSID = "{AIM-7H}",
						},
						[8] = {
							CLSID = "{AIM-7H}",
						},
						[9] = {
							CLSID = "{AIM-9L}",
						},
						[10] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[11] = {
							CLSID = "{AIM-9L}",
						},
					},
					fuel = "6103",
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
			["AIM-9M*4, AIM-120B*4, Fuel*3"] = {
				attributes =  { },
				code_loadout =  { "Crisis", "PG" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 4,
				vCruise = 255.83333333333,
				standoff = 46300,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[3] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[4] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[5] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[6] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[7] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[8] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[9] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[10] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[11] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = "6103",
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
			["2000s LR AA AIM-120C*4,  AIM-9M*4, Fuel*3"] = {
				attributes =  { },
				code_loadout =  { "Caucasus", "WOB" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 4,
				vCruise = 255.83333333333,
				standoff = 46300,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[3] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[4] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[5] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[6] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[7] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[8] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[9] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[10] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[11] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = "6103",
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
			["2000s LR AA AIM-120C*6,  AIM-9M*2, Fuel*3"] = {
				attributes =  { },
				code_loadout =  { "Caucasus", "WOB" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 6,
				vCruise = 255.83333333333,
				standoff = 46300,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[2] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[3] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[4] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[5] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[6] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[7] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[8] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[9] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[10] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[11] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
					},
					fuel = "6103",
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
		},
		Intercept = {
			["AIM-9M*4, AIM-120B*4, Fuel*1"] = {
				attributes =  { },
				code_loadout =  { "Crisis", "PG" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[3] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[4] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[5] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[6] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[7] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[8] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[9] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[11] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = "6103",
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
			["80s AA LR - 4xAIM-9L - 4xAIM-7MH - 3xFT"] = {
				attributes =  { },
				code_loadout =  { "WOC80" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[3] = {
							CLSID = "{AIM-9L}",
						},
						[4] = {
							CLSID = "{AIM-7H}",
						},
						[5] = {
							CLSID = "{AIM-7H}",
						},
						[6] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[7] = {
							CLSID = "{AIM-7H}",
						},
						[8] = {
							CLSID = "{AIM-7H}",
						},
						[9] = {
							CLSID = "{AIM-9L}",
						},
						[10] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[11] = {
							CLSID = "{AIM-9L}",
						},
					},
					fuel = "6103",
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
			["2000s LR AA AIM-120C*4,  AIM-9M*4, Fuel*3"] = {
				attributes =  { },
				code_loadout =  { "Caucasus", "WOB" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[3] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[4] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[5] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[6] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[7] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[8] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[9] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[10] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[11] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = "6103",
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
			["2000s LR AA AIM-120C*6,  AIM-9M*2, Fuel*3"] = {
				attributes =  { },
				code_loadout =  { "Caucasus", "WOB" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[2] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[3] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[4] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[5] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[6] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[7] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[8] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[9] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[10] = {
							CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
						},
						[11] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
					},
					fuel = "6103",
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
		},
	},
	["Tornado GR4"] = {
		["Anti-ship Strike"] = {
			["Revenge  Sea Eagle*2, AIM-9M*2, Fuel*2, ECM"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "ship" },
				code_loadout =  { "Revenge" },
				weaponType = "ASM",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 250,
				vAttack = 300,
				hCruise = 6096,
				hAttack = 2000,
				standoff = 80000,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{8C3F26A2-FA0F-11d5-9190-00A0249B6F00}",
						},
						[2] = {
							CLSID = "{EF124821-F9BB-4314-A153-E0E2FE1162C4}",
						},
						[3] = {
							CLSID = "{AIM-9L}",
						},
						[4] = {
							CLSID = "{1461CD18-429A-42A9-A21F-4C621ECD4573}",
						},
						[5] = {
							CLSID = "",
						},
						[6] = {
							CLSID = "",
						},
						[7] = {
							CLSID = "",
						},
						[8] = {
							CLSID = "",
						},
						[9] = {
							CLSID = "{1461CD18-429A-42A9-A21F-4C621ECD4573}",
						},
						[10] = {
							CLSID = "{AIM-9L}",
						},
						[11] = {
							CLSID = "{EF124821-F9BB-4314-A153-E0E2FE1162C4}",
						},
						[12] = {
							CLSID = "{8C3F26A1-FA0F-11d5-9190-00A0249B6F00}",
						},
					},
					fuel = "4663",
					flare = 45,
					chaff = 90,
					gun = 100,
				},
			},
		},
	},
	["Su-17M4"] = {
		Strike = {
			["Fab250*12, FT*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "Structure", "frontline" },
				code_loadout =  { "WOT87" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
								range = 300000,
				firepower = 1,
				vCruise = 210,
				vAttack = 300,
				hCruise = 7500,
				hAttack = 4000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{E659C4BE-2CD8-4472-8C08-3F28ACB61A8A}",
						},
						[3] = {
							CLSID = "{6A367BB4-327F-4A04-8D9E-6D86BDC98E7E}",
						},
						[4] = {
							CLSID = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
						},
						[5] = {
							CLSID = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
						},
						[6] = {
							CLSID = "{6A367BB4-327F-4A04-8D9E-6D86BDC98E7E}",
						},
						[8] = {
							CLSID = "{E659C4BE-2CD8-4472-8C08-3F28ACB61A8A}",
						},
					},
					fuel = "3770",
					flare = 64,
					chaff = 64,
					gun = 100,
				},
			},
			["LR, Rockets, R-60*2, FT*4"] = {
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
								range = 280000,
				firepower = 1,
				vCruise = 250,
				vAttack = 300,
				hCruise = 1530,
				hAttack = 1000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{414E383A-59EB-41BC-8566-2B5E0788ED1F}",
						},
						[2] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[3] = {
							CLSID = "{FC56DF80-9B09-44C5-8976-DCFAFF219062}",
						},
						[4] = {
							CLSID = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
						},
						[5] = {
							CLSID = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
						},
						[6] = {
							CLSID = "{FC56DF80-9B09-44C5-8976-DCFAFF219062}",
						},
						[7] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[8] = {
							CLSID = "{414E383A-59EB-41BC-8566-2B5E0788ED1F}",
						},
					},
					fuel = "3770",
					flare = 64,
					chaff = 64,
					gun = 100,
				},
			},
			["IPW - Strike - FAB 500 M62*4"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "soft", "Parked Aircraft", "Structure" },
				code_loadout =  { "IPW71" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
								range = 700000,
				firepower = 1,
				vCruise = 200,
				vAttack = 280,
				hCruise = 5500,
				hAttack = 4000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[8] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
						[6] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
						[1] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
						[3] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
					},
					fuel = "3770",
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
			["LR Fab250*8, FT*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "Structure", "frontline" },
				code_loadout =  { "WOT87" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
								range = 600000,
				firepower = 1,
				vCruise = 250,
				vAttack = 300,
				hCruise = 5500,
				hAttack = 4000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{414E383A-59EB-41BC-8566-2B5E0788ED1F}",
						},
						[3] = {
							CLSID = "{6A367BB4-327F-4A04-8D9E-6D86BDC98E7E}",
						},
						[4] = {
							CLSID = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
						},
						[5] = {
							CLSID = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
						},
						[6] = {
							CLSID = "{6A367BB4-327F-4A04-8D9E-6D86BDC98E7E}",
						},
						[8] = {
							CLSID = "{414E383A-59EB-41BC-8566-2B5E0788ED1F}",
						},
					},
					fuel = "3770",
					flare = 64,
					chaff = 64,
					gun = 100,
				},
			},
			["IPW - Strike - S-24B*4"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "soft", "Parked Aircraft", "Structure" },
				code_loadout =  { "IPW71" },
				weaponType = "Rockets",
				expend = "Auto",
				attackType = "Dive",
								range = 700000,
				firepower = 1,
				vCruise = 200,
				vAttack = 280,
				hCruise = 1500,
				hAttack = 1000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[8] = {
							CLSID = "{3858707D-F5D5-4bbb-BDD8-ABB0530EBC7C}",
						},
						[6] = {
							CLSID = "{3858707D-F5D5-4bbb-BDD8-ABB0530EBC7C}",
						},
						[1] = {
							CLSID = "{3858707D-F5D5-4bbb-BDD8-ABB0530EBC7C}",
						},
						[3] = {
							CLSID = "{3858707D-F5D5-4bbb-BDD8-ABB0530EBC7C}",
						},
					},
					fuel = "3770",
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
			["LR Fab250*8, R-60*2, FT*4"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "Structure", "frontline" },
				code_loadout =  { "IIW", "WOC80", "WOB" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
								range = 800000,
				firepower = 1,
				vCruise = 185,
				vAttack = 300,
				hCruise = 6328,
				hAttack = 4000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{414E383A-59EB-41BC-8566-2B5E0788ED1F}",
						},
						[2] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[3] = {
							CLSID = "{6A367BB4-327F-4A04-8D9E-6D86BDC98E7E}",
						},
						[4] = {
							CLSID = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
						},
						[5] = {
							CLSID = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
						},
						[6] = {
							CLSID = "{6A367BB4-327F-4A04-8D9E-6D86BDC98E7E}",
						},
						[7] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[8] = {
							CLSID = "{414E383A-59EB-41BC-8566-2B5E0788ED1F}",
						},
					},
					fuel = "3770",
					flare = 64,
					chaff = 64,
					gun = 100,
				},
			},
			["IPW - Strike - RBK-500 PTAB-10-5*4"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "soft", "Parked Aircraft" },
				code_loadout =  { "IPW71", "WOB" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
								range = 700000,
				firepower = 1,
				vCruise = 200,
				vAttack = 280,
				hCruise = 5500,
				hAttack = 4000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[8] = {
							CLSID = "{D5435F26-F120-4FA3-9867-34ACE562EF1B}",
						},
						[6] = {
							CLSID = "{D5435F26-F120-4FA3-9867-34ACE562EF1B}",
						},
						[1] = {
							CLSID = "{D5435F26-F120-4FA3-9867-34ACE562EF1B}",
						},
						[3] = {
							CLSID = "{D5435F26-F120-4FA3-9867-34ACE562EF1B}",
						},
					},
					fuel = "3770",
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
			["Rockets, FT*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "frontline" },
				code_loadout =  { "WOT87" },
				weaponType = "Rockets",
				expend = "All",
				attackType = "Dive",
								range = 300000,
				firepower = 1,
				vCruise = 250,
				vAttack = 300,
				hCruise = 1500,
				hAttack = 1000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{FC56DF80-9B09-44C5-8976-DCFAFF219062}",
						},
						[3] = {
							CLSID = "{FC56DF80-9B09-44C5-8976-DCFAFF219062}",
						},
						[4] = {
							CLSID = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
						},
						[5] = {
							CLSID = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
						},
						[6] = {
							CLSID = "{FC56DF80-9B09-44C5-8976-DCFAFF219062}",
						},
						[8] = {
							CLSID = "{FC56DF80-9B09-44C5-8976-DCFAFF219062}",
						},
					},
					fuel = "3770",
					flare = 64,
					chaff = 64,
					gun = 100,
				},
			},
			["IPW - Strike - S-13*25"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "soft", "Parked Aircraft" },
				code_loadout =  { "IPW71" },
				weaponType = "Rockets",
				expend = "Auto",
				attackType = "Dive",
								range = 700000,
				firepower = 1,
				vCruise = 200,
				vAttack = 280,
				hCruise = 1500,
				hAttack = 1000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[8] = {
							CLSID = "{FC56DF80-9B09-44C5-8976-DCFAFF219062}",
						},
						[6] = {
							CLSID = "{FC56DF80-9B09-44C5-8976-DCFAFF219062}",
						},
						[1] = {
							CLSID = "{FC56DF80-9B09-44C5-8976-DCFAFF219062}",
						},
						[3] = {
							CLSID = "{FC56DF80-9B09-44C5-8976-DCFAFF219062}",
						},
					},
					fuel = "3770",
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
			["Fab500*4, FT*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Structure", "frontline" },
				code_loadout =  { "WOT87" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
								range = 300000,
				firepower = 1,
				vCruise = 250,
				vAttack = 300,
				hCruise = 5500,
				hAttack = 4000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
						[3] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
						[4] = {
							CLSID = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
						},
						[5] = {
							CLSID = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
						},
						[6] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
						[8] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
					},
					fuel = "3770",
					flare = 64,
					chaff = 64,
					gun = 100,
				},
			},
			["Rockets, R-60*2, FT*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "frontline" },
				code_loadout =  { "IIW", "WOC80", "WOB" },
				weaponType = "Rockets",
				expend = "All",
				attackType = "Dive",
								range = 170000,
				firepower = 1,
				vCruise = 255,
				vAttack = 300,
				hCruise = 530,
				hAttack = 100,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{FC56DF80-9B09-44C5-8976-DCFAFF219062}",
						},
						[2] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[3] = {
							CLSID = "{FC56DF80-9B09-44C5-8976-DCFAFF219062}",
						},
						[4] = {
							CLSID = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
						},
						[5] = {
							CLSID = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
						},
						[6] = {
							CLSID = "{FC56DF80-9B09-44C5-8976-DCFAFF219062}",
						},
						[7] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[8] = {
							CLSID = "{FC56DF80-9B09-44C5-8976-DCFAFF219062}",
						},
					},
					fuel = "3770",
					flare = 64,
					chaff = 64,
					gun = 100,
				},
			},
			["Fab250*12, R-60*2, FT*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				heavy_load = true,
				attributes =  { "soft", "Parked Aircraft", "SAM", "Structure", "frontline" },
				code_loadout =  { "IIW", "WOC80", "WOB" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
								range = 300000,
				firepower = 1,
				vCruise = 180,	--142,
				vAttack = 300,
				hCruise = 6358, --5719,
				hAttack = 4000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{E659C4BE-2CD8-4472-8C08-3F28ACB61A8A}",
						},
						[2] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[3] = {
							CLSID = "{6A367BB4-327F-4A04-8D9E-6D86BDC98E7E}",
						},
						[4] = {
							CLSID = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
						},
						[5] = {
							CLSID = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
						},
						[6] = {
							CLSID = "{6A367BB4-327F-4A04-8D9E-6D86BDC98E7E}",
						},
						[7] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[8] = {
							CLSID = "{E659C4BE-2CD8-4472-8C08-3F28ACB61A8A}",
						},
					},
					fuel = "3770",
					flare = 64,
					chaff = 64,
					gun = 100,
				},
			},
			["IPW - Strike - FAB 250*16"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "soft", "Parked Aircraft", "Structure" },
				code_loadout =  { "IPW71" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
								range = 700000,
				firepower = 1,
				vCruise = 200,
				vAttack = 280,
				hCruise = 5500,
				hAttack = 4000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[8] = {
							CLSID = "{6A367BB4-327F-4A04-8D9E-6D86BDC98E7E}",
						},
						[6] = {
							CLSID = "{6A367BB4-327F-4A04-8D9E-6D86BDC98E7E}",
						},
						[1] = {
							CLSID = "{6A367BB4-327F-4A04-8D9E-6D86BDC98E7E}",
						},
						[3] = {
							CLSID = "{3E35F8C1-052D-11d6-9191-00A0249B6F00}",
						},
					},
					fuel = "3770",
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
			["Fab500*4, R-60*2, FT*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Structure", "frontline" },
				code_loadout =  { "IIW", "WOC80", "WOB" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
								range = 350000,
				firepower = 1,
				vCruise = 190,
				vAttack = 210,
				hCruise = 6938,
				hAttack = 4000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
						[2] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[3] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
						[4] = {
							CLSID = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
						},
						[5] = {
							CLSID = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
						},
						[6] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
						[7] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[8] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
					},
					fuel = "3770",
					flare = 64,
					chaff = 64,
					gun = 100,
				},
			},
			["LR Fab500*2, FT*4"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Structure" },
				code_loadout =  { "WOT87" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
								range = 600000,
				firepower = 1,
				vCruise = 239,
				vAttack = 300,
				hCruise = 9000,
				hAttack = 4000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{414E383A-59EB-41BC-8566-2B5E0788ED1F}",
						},
						[3] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
						[4] = {
							CLSID = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
						},
						[5] = {
							CLSID = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
						},
						[6] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
						[8] = {
							CLSID = "{414E383A-59EB-41BC-8566-2B5E0788ED1F}",
						},
					},
					fuel = "3770",
					flare = 64,
					chaff = 64,
					gun = 100,
				},
			},
			["LR Fab500*2, R-60*2, FT*4"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Structure" },
				code_loadout =  { "IIW", "WOC80", "WOB" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
								range = 530000,
				firepower = 1,
				vCruise = 190,
				vAttack = 300,
				hCruise = 7548,
				hAttack = 4000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{414E383A-59EB-41BC-8566-2B5E0788ED1F}",
						},
						[2] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[3] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
						[4] = {
							CLSID = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
						},
						[5] = {
							CLSID = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
						},
						[6] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
						[7] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[8] = {
							CLSID = "{414E383A-59EB-41BC-8566-2B5E0788ED1F}",
						},
					},
					fuel = "3770",
					flare = 64,
					chaff = 64,
					gun = 100,
				},
			},
		},
		["Anti-ship Strike"] = {
			["Kh-25ML*4, R-60*2, FT*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "ship" },
				code_loadout =  { "IIW", "WOB" },
				weaponType = "ASM",
				expend = "All",
				attackType = "Dive",
								range = 300000,
				firepower = 1,
				vCruise = 250,
				vAttack = 300,
				hCruise = 5500,
				hAttack = 4000,
				standoff = 18000,
				ingress = 15000,
				egress = 5000,
				MaxAttackOffset = 60,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6DADF342-D4BA-4D8A-B081-BA928C4AF86D}",
						},
						[2] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[3] = {
							CLSID = "{6DADF342-D4BA-4D8A-B081-BA928C4AF86D}",
						},
						[4] = {
							CLSID = "{414E383A-59EB-41BC-8566-2B5E0788ED1F}",
						},
						[5] = {
							CLSID = "{414E383A-59EB-41BC-8566-2B5E0788ED1F}",
						},
						[6] = {
							CLSID = "{6DADF342-D4BA-4D8A-B081-BA928C4AF86D}",
						},
						[7] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[8] = {
							CLSID = "{6DADF342-D4BA-4D8A-B081-BA928C4AF86D}",
						},
					},
					fuel = "3770",
					flare = 64,
					chaff = 64,
					gun = 100,
				},
			},
			["IPW - AntishipStrike - FAB 500 M62*4"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "ship" },
				code_loadout =  { "IPW71" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
								range = 500000,
				firepower = 1,
				vCruise = 200,
				vAttack = 280,
				hCruise = 5500,
				hAttack = 4000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[8] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
						[6] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
						[1] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
						[3] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
					},
					fuel = "3770",
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
			["TF-Old-Kh-25ML*2,Kh-29L*2,R-60*2,FT*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "ship" },
				code_loadout =  { "TF80s", "TF80sRED", "TF80sI", "WOC80", "WOB" },
				weaponType = "ASM",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 300000,
				firepower = 1,
				vCruise = 250,
				vAttack = 300,
				hCruise = 100,
				hAttack = 200,
				standoff = 18000,
				ingress = 15000,
				egress = 10000,
				MaxAttackOffset = 60,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6DADF342-D4BA-4D8A-B081-BA928C4AF86D}",
						},
						[2] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[3] = {
							CLSID = "{3468C652-E830-4E73-AFA9-B5F260AB7C3D}",
						},
						[4] = {
							CLSID = "{414E383A-59EB-41BC-8566-2B5E0788ED1F}",
						},
						[5] = {
							CLSID = "{414E383A-59EB-41BC-8566-2B5E0788ED1F}",
						},
						[6] = {
							CLSID = "{3468C652-E830-4E73-AFA9-B5F260AB7C3D}",
						},
						[7] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[8] = {
							CLSID = "{6DADF342-D4BA-4D8A-B081-BA928C4AF86D}",
						},
					},
					fuel = "3770",
					flare = 64,
					chaff = 64,
					gun = 100,
				},
			},
		},
		["Runway Attack"] = {
			["RAttack Fab250*12, R-60*2, FT*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Runway" },
				code_loadout =  { "all" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
				night = true,
				adverseWeather = true,
				range = 300000,
				vCruise = 180,	--142,
				hCruise = 6358, --5719,
				firepower = 1,
				vAttack = 277,
				hAttack = 200,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{E659C4BE-2CD8-4472-8C08-3F28ACB61A8A}",
						},
						[2] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[3] = {
							CLSID = "{6A367BB4-327F-4A04-8D9E-6D86BDC98E7E}",
						},
						[4] = {
							CLSID = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
						},
						[5] = {
							CLSID = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
						},
						[6] = {
							CLSID = "{6A367BB4-327F-4A04-8D9E-6D86BDC98E7E}",
						},
						[7] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[8] = {
							CLSID = "{E659C4BE-2CD8-4472-8C08-3F28ACB61A8A}",
						},
					},
					fuel = "3770",
					flare = 64,
					chaff = 64,
					gun = 100,
				},
			},
			["WOB BetAB-500HD*6,R-60M*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Runway" },
				code_loadout =  { "TF", "Caucasus", "WOB", "IIW" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 340000,
				firepower = 1,
				vCruise = 190,
				vAttack = 277.5,
				hCruise = 7548,
				hAttack = 100,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{BD289E34-DF84-4C5E-9220-4B14C346E79D}",
						},
						[2] = {
							CLSID = "{APU-60-1_R_60M}",
						},
						[3] = {
							CLSID = "{BD289E34-DF84-4C5E-9220-4B14C346E79D}",
						},
						[4] = {
							CLSID = "{BD289E34-DF84-4C5E-9220-4B14C346E79D}",
						},
						[5] = {
							CLSID = "{BD289E34-DF84-4C5E-9220-4B14C346E79D}",
						},
						[6] = {
							CLSID = "{BD289E34-DF84-4C5E-9220-4B14C346E79D}",
						},
						[7] = {
							CLSID = "{APU-60-1_R_60M}",
						},
						[8] = {
							CLSID = "{BD289E34-DF84-4C5E-9220-4B14C346E79D}",
						},
					},
					fuel = "3770",
					flare = 64,
					chaff = 64,
					gun = 100,
				},
			},
		},
	},
	["Tu-142"] = {
		["Anti-ship Strike"] = {
			["Antiship Kh-35*6"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
					["Escort Jammer"] = true,
				},
				attributes =  { "ship" },
				code_loadout =  { "TF", "TF80s", "TF80sRED", "TF80sI", "WOC80" },
				weaponType = "ASM",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 900000,
				firepower = 1,
				-- vCruise = 200,
				-- vAttack = 236,
				-- hCruise = 9000,
				-- hAttack = 5000,
				-- standoff = 110000,
				-- ingress = 50000,
				-- egress = 30000,
				vCruise = 197,                 -- Ajusté pour la croisière éco réelle du Bear
                vAttack = 150,                 -- Réduit : Vitesse de pénétration basse altitude
                hCruise = 9000,
                hAttack = 150,                 -- Crucial : Descendu au ras de l'eau pour le pop-up
                standoff = 70000,              -- Réduit : Distance de tir réaliste pour l'IA DCS avec le Kh-35
                ingress = 220000,               -- 90000 Augmenté : Pour forcer la descente TBA avant la détection
                egress = 50000,                -- Augmenté : Pour maintenir la fuite TBA hors de portée des SAM
                MaxAttackOffset = 30,          -- Réduit : L'IA gère mal les grands angles pour les missiles anti-navires
				-- MaxAttackOffset = 60,
				sortie_rate = 1,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{C42EE4C3-355C-4B83-8B22-B39430B8F4AE}",
						},
					},
					fuel = "60000",
					flare = 48,
					chaff = 48,
					gun = 100,
				},
			},
		},
	},
	["MiG-29A"] = {
		CAP = {
			["R-27R*2, R-60M*4, Fuel*1"] = {
				attributes =  { },
				code_loadout =  { "Crisis", "PG" },
				night = true,
				adverseWeather = true,
				range = 504000,
				firepower = 1,
				vCruise = 213,
				vAttack = 213,
				hCruise = 7011,
				hAttack = 7011,
				standoff = 27000,
				tStation = 2700,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[2] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[3] = {
							CLSID = "{9B25D316-0434-4954-868F-D51DB1A38DF0}",
						},
						[4] = {
							CLSID = "{2BEC576B-CDF5-4B7F-961F-B0FA4312B841}",
						},
						[5] = {
							CLSID = "{9B25D316-0434-4954-868F-D51DB1A38DF0}",
						},
						[6] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[7] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
					},
					fuel = "3380",
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
			["CAP R-73*4 - R-27ER*1 - R-27ET*1 - FT"] = {
				attributes =  { },
				code_loadout =  { "TF", "Caucasus", "WOB" },
				night = true,
				adverseWeather = true,
				range = 400000,
				firepower = 1.5,
				vCruise = 213,
				vAttack = 213,
				hCruise = 7011,
				hAttack = 7011,
				tStation = 1800,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[2] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[3] = {
							CLSID = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}",
						},
						[4] = {
							CLSID = "{2BEC576B-CDF5-4B7F-961F-B0FA4312B841}",
						},
						[5] = {
							CLSID = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						},
						[6] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[7] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
					},
					fuel = "3380",
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
		},
		["Fighter Sweep"] = {
			["R-27R*2, R-60M*4, Fuel*1"] = {
				attributes =  { },
				code_loadout =  { "Crisis", "PG" },
				night = true,
				adverseWeather = true,
				firepower = 1.5,
				range = 504000,
				vCruise = 213,
				vAttack = 213,
				hCruise = 7011,
				hAttack = 7011,
				standoff = 27000,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[2] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[3] = {
							CLSID = "{9B25D316-0434-4954-868F-D51DB1A38DF0}",
						},
						[4] = {
							CLSID = "{2BEC576B-CDF5-4B7F-961F-B0FA4312B841}",
						},
						[5] = {
							CLSID = "{9B25D316-0434-4954-868F-D51DB1A38DF0}",
						},
						[6] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[7] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
					},
					fuel = "3380",
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
			["Fighter Sweep R-73*4 - R-27ER*1 - R-27ET*1 - FT"] = {
				attributes =  { },
				code_loadout =  { "TF", "Caucasus", "WOB" },
				night = true,
				adverseWeather = true,
				range = 600000,
				firepower = 1.5,
				vCruise = 260.83333333333,
				vAttack = 315.83333333333,
				hCruise = 7011,
				hAttack = 7011,
				standoff = 60000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[2] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[3] = {
							CLSID = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}",
						},
						[4] = {
							CLSID = "{2BEC576B-CDF5-4B7F-961F-B0FA4312B841}",
						},
						[5] = {
							CLSID = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						},
						[6] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[7] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
					},
					fuel = "3380",
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
		},
		Escort = {
			["Escort  - R-73*4 - R-27ER*1 - R-27ET*1 - FT"] = {
				attributes =  { },
				code_loadout =  { "TF", "Caucasus", "WOB" },
				night = true,
				adverseWeather = true,
				range = 700000,
				firepower = 1.5,
				vCruise = 260.83333333333,
				standoff = 50000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[2] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[3] = {
							CLSID = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}",
						},
						[4] = {
							CLSID = "{2BEC576B-CDF5-4B7F-961F-B0FA4312B841}",
						},
						[5] = {
							CLSID = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						},
						[6] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[7] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
					},
					fuel = "3380",
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
			["R-27R*2, R-60M*4, Fuel*1"] = {
				attributes =  { },
				code_loadout =  { "Crisis", "PG" },
				night = true,
				adverseWeather = true,
				range = 504000,
				firepower = 1,
				vCruise = 213,
				standoff = 27000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[2] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[3] = {
							CLSID = "{9B25D316-0434-4954-868F-D51DB1A38DF0}",
						},
						[4] = {
							CLSID = "{2BEC576B-CDF5-4B7F-961F-B0FA4312B841}",
						},
						[5] = {
							CLSID = "{9B25D316-0434-4954-868F-D51DB1A38DF0}",
						},
						[6] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[7] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
					},
					fuel = "3380",
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
		},
		Intercept = {
			["R-27R*2, R-60M*4, Fuel*1"] = {
				attributes =  { },
				code_loadout =  { "Crisis", "PG" },
				night = true,
				adverseWeather = true,
				range = 250000,
				firepower = 1,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[2] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[3] = {
							CLSID = "{9B25D316-0434-4954-868F-D51DB1A38DF0}",
						},
						[4] = {
							CLSID = "{2BEC576B-CDF5-4B7F-961F-B0FA4312B841}",
						},
						[5] = {
							CLSID = "{9B25D316-0434-4954-868F-D51DB1A38DF0}",
						},
						[6] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
						[7] = {
							CLSID = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
						},
					},
					fuel = "3380",
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
			["Intercept R-73*4 - R-27ER*1 - R-27ET*1 - FT"] = {
				attributes =  { },
				code_loadout =  { "TF", "Caucasus", "WOB" },
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[2] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[3] = {
							CLSID = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}",
						},
						[4] = {
							CLSID = "{2BEC576B-CDF5-4B7F-961F-B0FA4312B841}",
						},
						[5] = {
							CLSID = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						},
						[6] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[7] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
					},
					fuel = "3380",
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
		},
	},
	["MiG-29 Fulcrum"] = {
		CAP = {
			["AA CAP - 90s - R-27R*2 R-60M*4 - FT"] = {
				attributes =  { },
				code_loadout =  { "Crisis", "PG", "TF80s" },
				night = true,
				adverseWeather = true,
				range = 504000,
				firepower = 1,
				vCruise = 213,
				vAttack = 213,
				hCruise = 7011,
				hAttack = 7011,
				standoff = 27000,
				tStation = 2700,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
					[1] = {
					["CLSID"] = "{PTB_1500_MIG29A}",
					["num"] = 4,
				},
				[2] = {
					["CLSID"] = "{9B25D316-0434-4954-868F-D51DB1A38DF0}",
					["num"] = 5,
				},
				[3] = {
					["CLSID"] = "{9B25D316-0434-4954-868F-D51DB1A38DF0}",
					["num"] = 3,
				},
				[4] = {
					["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
					["num"] = 7,
				},
				[5] = {
					["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
					["num"] = 1,
				},
				[6] = {
					["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
					["num"] = 6,
				},
				[7] = {
					["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
					["num"] = 2,
				},
					},
					fuel = "3376",
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
			["CAP AA - 2000s - R-27ER*2 R-73*4 - FT"] = {
				attributes =  { },
				code_loadout =  { "TF", "Caucasus", "WOB" },
				night = true,
				adverseWeather = true,
				range = 400000,
				firepower = 1.5,
				vCruise = 213,
				vAttack = 213,
				hCruise = 7011,
				hAttack = 7011,
				tStation = 1800,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
					["CLSID"] = "{PTB_1500_MIG29A}",
					["num"] = 4,
				},
				[2] = {
					["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
					["num"] = 5,
				},
				[3] = {
					["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
					["num"] = 3,
				},
				[4] = {
					["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
					["num"] = 7,
				},
				[5] = {
					["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
					["num"] = 1,
				},
				[6] = {
					["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
					["num"] = 6,
				},
				[7] = {
					["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
					["num"] = 2,
				},
					},
					fuel = "3380",
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
		},
		["Fighter Sweep"] = {
			["AA sweep - 90s - R-27R*2 R-60M*4 - FT"] = {
				attributes =  { },
				code_loadout =  { "Crisis", "PG", "TF80s"  },
				night = true,
				adverseWeather = true,
				firepower = 1.5,
				range = 504000,
				vCruise = 213,
				vAttack = 213,
				hCruise = 7011,
				hAttack = 7011,
				standoff = 27000,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
					["CLSID"] = "{PTB_1500_MIG29A}",
					["num"] = 4,
				},
				[2] = {
					["CLSID"] = "{9B25D316-0434-4954-868F-D51DB1A38DF0}",
					["num"] = 5,
				},
				[3] = {
					["CLSID"] = "{9B25D316-0434-4954-868F-D51DB1A38DF0}",
					["num"] = 3,
				},
				[4] = {
					["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
					["num"] = 7,
				},
				[5] = {
					["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
					["num"] = 1,
				},
				[6] = {
					["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
					["num"] = 6,
				},
				[7] = {
					["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
					["num"] = 2,
				},
					},
					fuel = "3380",
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
			["Fighter Sweep AA - 2000s - R-27ER*2 R-73*4 - FT"] = {
				attributes =  { },
				code_loadout =  { "TF", "Caucasus", "WOB" },
				night = true,
				adverseWeather = true,
				range = 600000,
				firepower = 1.5,
				vCruise = 260.83333333333,
				vAttack = 315.83333333333,
				hCruise = 7011,
				hAttack = 7011,
				standoff = 60000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
					["CLSID"] = "{PTB_1500_MIG29A}",
					["num"] = 4,
				},
				[2] = {
					["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
					["num"] = 5,
				},
				[3] = {
					["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
					["num"] = 3,
				},
				[4] = {
					["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
					["num"] = 7,
				},
				[5] = {
					["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
					["num"] = 1,
				},
				[6] = {
					["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
					["num"] = 6,
				},
				[7] = {
					["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
					["num"] = 2,
				},
					},
					fuel = "3380",
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
		},
		Escort = {
			["Escort  AA - 2000s - R-27ER*2 R-73*4 - FT"] = {
				attributes =  { },
				code_loadout =  { "TF", "Caucasus", "WOB" },
				night = true,
				adverseWeather = true,
				range = 700000,
				firepower = 1.5,
				vCruise = 260.83333333333,
				standoff = 50000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
					["CLSID"] = "{PTB_1500_MIG29A}",
					["num"] = 4,
				},
				[2] = {
					["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
					["num"] = 5,
				},
				[3] = {
					["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
					["num"] = 3,
				},
				[4] = {
					["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
					["num"] = 7,
				},
				[5] = {
					["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
					["num"] = 1,
				},
				[6] = {
					["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
					["num"] = 6,
				},
				[7] = {
					["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
					["num"] = 2,
				},
					},
					fuel = "3380",
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
			["AA Escort - 90s - R-27R*2 R-60M*4 - FT"] = {
				attributes =  { },
				code_loadout =  { "Crisis", "PG", "TF80s"  },
				night = true,
				adverseWeather = true,
				range = 504000,
				firepower = 1,
				vCruise = 213,
				standoff = 27000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
					["CLSID"] = "{PTB_1500_MIG29A}",
					["num"] = 4,
				},
				[2] = {
					["CLSID"] = "{9B25D316-0434-4954-868F-D51DB1A38DF0}",
					["num"] = 5,
				},
				[3] = {
					["CLSID"] = "{9B25D316-0434-4954-868F-D51DB1A38DF0}",
					["num"] = 3,
				},
				[4] = {
					["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
					["num"] = 7,
				},
				[5] = {
					["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
					["num"] = 1,
				},
				[6] = {
					["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
					["num"] = 6,
				},
				[7] = {
					["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
					["num"] = 2,
				},
					},
					fuel = "3380",
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
		},
		Intercept = {
			["AA Intercept - 90s - R-27R*2 R-60M*4 - FT"] = {
				attributes =  { },
				code_loadout =  { "Crisis", "PG", "TF80s"  },
				night = true,
				adverseWeather = true,
				range = 250000,
				firepower = 1,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
					["CLSID"] = "{PTB_1500_MIG29A}",
					["num"] = 4,
				},
				[2] = {
					["CLSID"] = "{9B25D316-0434-4954-868F-D51DB1A38DF0}",
					["num"] = 5,
				},
				[3] = {
					["CLSID"] = "{9B25D316-0434-4954-868F-D51DB1A38DF0}",
					["num"] = 3,
				},
				[4] = {
					["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
					["num"] = 7,
				},
				[5] = {
					["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
					["num"] = 1,
				},
				[6] = {
					["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
					["num"] = 6,
				},
				[7] = {
					["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
					["num"] = 2,
				},
					},
					fuel = "3380",
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
			["Intercept AA - 2000s - R-27ER*2 R-73*4 - FT"] = {
				attributes =  { },
				code_loadout =  { "TF", "Caucasus", "WOB" },
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
					["CLSID"] = "{PTB_1500_MIG29A}",
					["num"] = 4,
				},
				[2] = {
					["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
					["num"] = 5,
				},
				[3] = {
					["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
					["num"] = 3,
				},
				[4] = {
					["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
					["num"] = 7,
				},
				[5] = {
					["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
					["num"] = 1,
				},
				[6] = {
					["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
					["num"] = 6,
				},
				[7] = {
					["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
					["num"] = 2,
				},
					},
					fuel = "3380",
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
		},
		Strike = {
			["AG - 2000s - FAB-500*4 - R-73*2 - FT"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Structure", "soft", "Parked Aircraft" },
				code_loadout =  { "TF", "Caucasus", "WOB" },
				weaponType = "Bombs",
				expend = "All",
				range = 200000,
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
					["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
					["num"] = 7,
				},
				[2] = {
					["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
					["num"] = 1,
				},
				[3] = {
					["CLSID"] = "{PTB_1500_MIG29A}",
					["num"] = 4,
				},
				[4] = {
					["CLSID"] = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
					["num"] = 5,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_AVUE_NOSE"] = 4.5,
						["00_prfx_function_delay_ctrl_AVUE_NOSE"] = 0,
						["NFP_PRESID"] = "MDRN_B_USSR_FABMedium",
						["NFP_PRESVER"] = 1,
						["NFP_fuze_type_nose"] = 1,
						["NFP_fuze_type_tail"] = "EMPTY_TAIL",
						["safety_delay"] = 11.35,
					},
				},
				[5] = {
					["CLSID"] = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
					["num"] = 3,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_AVUE_NOSE"] = 4.5,
						["00_prfx_function_delay_ctrl_AVUE_NOSE"] = 0,
						["NFP_PRESID"] = "MDRN_B_USSR_FABMedium",
						["NFP_PRESVER"] = 1,
						["NFP_fuze_type_nose"] = 1,
						["NFP_fuze_type_tail"] = "EMPTY_TAIL",
						["safety_delay"] = 11.35,
					},
				},
				[6] = {
					["CLSID"] = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
					["num"] = 6,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_AVUE_NOSE"] = 4.5,
						["00_prfx_function_delay_ctrl_AVUE_NOSE"] = 0,
						["NFP_PRESID"] = "MDRN_B_USSR_FABMedium",
						["NFP_PRESVER"] = 1,
						["NFP_fuze_type_nose"] = 1,
						["NFP_fuze_type_tail"] = "EMPTY_TAIL",
						["safety_delay"] = 11.35,
					},
				},
				[7] = {
					["CLSID"] = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
					["num"] = 2,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_AVUE_NOSE"] = 4.5,
						["00_prfx_function_delay_ctrl_AVUE_NOSE"] = 0,
						["NFP_PRESID"] = "MDRN_B_USSR_FABMedium",
						["NFP_PRESVER"] = 1,
						["NFP_fuze_type_nose"] = 1,
						["NFP_fuze_type_tail"] = "EMPTY_TAIL",
						["safety_delay"] = 11.35,
					},
				},
					},
					fuel = 3380,
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
			["AG - 90s - FAB-500*4 - R-60M*2 - FT"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Structure", "soft", "Parked Aircraft" },
				code_loadout =  { "Crisis", "PG", "TF80s"  },
				weaponType = "Bombs",
				expend = "All",
				range = 200000,
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
					["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
					["num"] = 7,
				},
				[2] = {
					["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
					["num"] = 1,
				},
				[3] = {
					["CLSID"] = "{PTB_1500_MIG29A}",
					["num"] = 4,
				},
				[4] = {
					["CLSID"] = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
					["num"] = 5,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_AVUE_NOSE"] = 4.5,
						["00_prfx_function_delay_ctrl_AVUE_NOSE"] = 0,
						["NFP_PRESID"] = "MDRN_B_USSR_FABMedium",
						["NFP_PRESVER"] = 1,
						["NFP_fuze_type_nose"] = 1,
						["NFP_fuze_type_tail"] = "EMPTY_TAIL",
						["safety_delay"] = 11.35,
					},
				},
				[5] = {
					["CLSID"] = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
					["num"] = 3,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_AVUE_NOSE"] = 4.5,
						["00_prfx_function_delay_ctrl_AVUE_NOSE"] = 0,
						["NFP_PRESID"] = "MDRN_B_USSR_FABMedium",
						["NFP_PRESVER"] = 1,
						["NFP_fuze_type_nose"] = 1,
						["NFP_fuze_type_tail"] = "EMPTY_TAIL",
						["safety_delay"] = 11.35,
					},
				},
				[6] = {
					["CLSID"] = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
					["num"] = 6,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_AVUE_NOSE"] = 4.5,
						["00_prfx_function_delay_ctrl_AVUE_NOSE"] = 0,
						["NFP_PRESID"] = "MDRN_B_USSR_FABMedium",
						["NFP_PRESVER"] = 1,
						["NFP_fuze_type_nose"] = 1,
						["NFP_fuze_type_tail"] = "EMPTY_TAIL",
						["safety_delay"] = 11.35,
					},
				},
				[7] = {
					["CLSID"] = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
					["num"] = 2,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_AVUE_NOSE"] = 4.5,
						["00_prfx_function_delay_ctrl_AVUE_NOSE"] = 0,
						["NFP_PRESID"] = "MDRN_B_USSR_FABMedium",
						["NFP_PRESVER"] = 1,
						["NFP_fuze_type_nose"] = 1,
						["NFP_fuze_type_tail"] = "EMPTY_TAIL",
						["safety_delay"] = 11.35,
					},
				},
					},
					fuel = 3380,
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
			["AG Low - 2000s - BeTAB-500 HD*4 - R-73*2 - FT"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Structure", "soft", "Parked Aircraft" },
				code_loadout =  { "TF", "Caucasus", "WOB" },
				weaponType = "Bombs",
				expend = "All",
				range = 200000,
				firepower = 1,
				night = true,
				adverseWeather = true,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 9100,
				hAttack = 200,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
					[1] = {
					["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
					["num"] = 7,
				},
				[2] = {
					["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
					["num"] = 1,
				},
				[3] = {
					["CLSID"] = "{PTB_1500_MIG29A}",
					["num"] = 4,
				},
				[4] = {
					["CLSID"] = "{BD289E34-DF84-4C5E-9220-4B14C346E79D}",
					["num"] = 5,
					["settings"] = {
						["NFP_PRESID"] = "MDRN_B_USSR_BetABShP",
						["NFP_PRESVER"] = 1,
						["NFP_fuze_type"] = 1,
						["arm_delay_ctrl_AVU589"] = 4.5,
						["function_delay_ctrl_AVU589"] = 26,
						["safety_delay"] = 11.35,
					},
				},
				[5] = {
					["CLSID"] = "{BD289E34-DF84-4C5E-9220-4B14C346E79D}",
					["num"] = 3,
					["settings"] = {
						["NFP_PRESID"] = "MDRN_B_USSR_BetABShP",
						["NFP_PRESVER"] = 1,
						["NFP_fuze_type"] = 1,
						["arm_delay_ctrl_AVU589"] = 4.5,
						["function_delay_ctrl_AVU589"] = 26,
					},
				},
				[6] = {
					["CLSID"] = "{BD289E34-DF84-4C5E-9220-4B14C346E79D}",
					["num"] = 6,
					["settings"] = {
						["NFP_PRESID"] = "MDRN_B_USSR_BetABShP",
						["NFP_PRESVER"] = 1,
						["NFP_fuze_type"] = 1,
						["arm_delay_ctrl_AVU589"] = 4.5,
						["function_delay_ctrl_AVU589"] = 26,
						["safety_delay"] = 11.35,
					},
				},
				[7] = {
					["CLSID"] = "{BD289E34-DF84-4C5E-9220-4B14C346E79D}",
					["num"] = 2,
					["settings"] = {
						["NFP_PRESID"] = "MDRN_B_USSR_BetABShP",
						["NFP_PRESVER"] = 1,
						["NFP_fuze_type"] = 1,
						["arm_delay_ctrl_AVU589"] = 4.5,
						["function_delay_ctrl_AVU589"] = 26,
						["safety_delay"] = 11.35,
					},
				},
					},
					fuel = 3380,
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
			["AG Low - 90s - BeTAB-500 HD*4 - R-60M*2 - FT"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Structure", "soft", "Parked Aircraft" },
				code_loadout =  { "Crisis", "PG", "TF80s"  },
				weaponType = "Bombs",
				expend = "All",
				range = 200000,
				night = true,
				adverseWeather = true,
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
					["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
					["num"] = 7,
				},
				[2] = {
					["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
					["num"] = 1,
				},
				[3] = {
					["CLSID"] = "{PTB_1500_MIG29A}",
					["num"] = 4,
				},
				[4] = {
					["CLSID"] = "{BD289E34-DF84-4C5E-9220-4B14C346E79D}",
					["num"] = 5,
					["settings"] = {
						["NFP_PRESID"] = "MDRN_B_USSR_BetABShP",
						["NFP_PRESVER"] = 1,
						["NFP_fuze_type"] = 1,
						["arm_delay_ctrl_AVU589"] = 4.5,
						["function_delay_ctrl_AVU589"] = 26,
					},
				},
				[5] = {
					["CLSID"] = "{BD289E34-DF84-4C5E-9220-4B14C346E79D}",
					["num"] = 3,
					["settings"] = {
						["NFP_PRESID"] = "MDRN_B_USSR_BetABShP",
						["NFP_PRESVER"] = 1,
						["NFP_fuze_type"] = 1,
						["arm_delay_ctrl_AVU589"] = 4.5,
						["function_delay_ctrl_AVU589"] = 26,
					},
				},
				[6] = {
					["CLSID"] = "{BD289E34-DF84-4C5E-9220-4B14C346E79D}",
					["num"] = 6,
					["settings"] = {
						["NFP_PRESID"] = "MDRN_B_USSR_BetABShP",
						["NFP_PRESVER"] = 1,
						["NFP_fuze_type"] = 1,
						["arm_delay_ctrl_AVU589"] = 4.5,
						["function_delay_ctrl_AVU589"] = 26,
					},
				},
				[7] = {
					["CLSID"] = "{BD289E34-DF84-4C5E-9220-4B14C346E79D}",
					["num"] = 2,
					["settings"] = {
						["NFP_PRESID"] = "MDRN_B_USSR_BetABShP",
						["NFP_PRESVER"] = 1,
						["NFP_fuze_type"] = 1,
						["arm_delay_ctrl_AVU589"] = 4.5,
						["function_delay_ctrl_AVU589"] = 26,
					},
				},
					},
					fuel = 3380,
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
		},	
	},
	["C-130J-30"] = {
		Transport = {
			Default = {
				attributes =  { },
				code_loadout =  { "All" },
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
					pylons = 
					{
						[1] = 
						{
						["CLSID"] = "{C130J_Ext_Tank_L}",
						}, -- end of [1]
						[2] = 
						{
						["CLSID"] = "{C130J_Ext_Tank_R}",
						}, -- end of [2]
						[3] = 
						{
						["CLSID"] = "{C130-Cargo-Bay-M4}",
						}, -- end of [3]
					},
					["fuel"] = 15753.6,
					["flare"] = 200,
					["chaff"] = 220,
					["gun"] = 100,
				},
			},
		},
	},
	["C-130"] = {
		Transport = {
			WOB = {
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { },
				code_loadout =  { "WOB" },
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
					},
					fuel = 20830,
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
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
					},
					fuel = 20830,
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
			["Crisis transport"] = {
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { },
				code_loadout =  { "Crisis" },
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
					},
					fuel = "20830",
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
			["NAM transport"] = {
				support = {
					Escort = false,
					SEAD = false,
				},
				attributes =  { },
				code_loadout =  { "NAM" },
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
					},
					fuel = "20830",
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
		},
	},
	["E-3A"] = {
		AWACS = {
			Default = {
				attributes =  { "Sentry" },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 231.25,
				vAttack = 231.25,
				hCruise = 10668,
				hAttack = 10668,
				tStation = 25200,
				sortie_rate = 3,
				stores = {
					pylons = {
					},
					fuel = "65000",
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
		},
	},
	["MQ-9 Reaper"] = {
		AFAC = {
			["FAC no weapons"] = {
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 110,
				vAttack = 110,
				hCruise = 9000,
				hAttack = 9000,
				tStation = 18000,
				sortie_rate = 6,
				stores = {
					pylons = {
					},
					fuel = 1300,
					flare = 0,
					chaff = 0,
					gun = 0,
				},
			},
		},
	},
	["F-117A"] = {
		Strike = {
			["GBU-27*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Structure", "Bridge" },
				code_loadout =  { "PG", "Caucasus" },
				weaponType = "Guided bombs",
				expend = "All",
				night = true,
				day = false,
				adverseWeather = true,
				range = 500000,
				firepower = 120,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 8534.4,
				hAttack = 8534.4,
				standoff = 15000,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{EF0A9419-01D6-473B-99A3-BEBDB923B14D}",
						},
						[2] = {
							CLSID = "{EF0A9419-01D6-473B-99A3-BEBDB923B14D}",
						},
					},
					fuel = "3840",
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
			["GBU-10*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Structure", "Bridge" },
				code_loadout =  { "PG", "Caucasus" },
				weaponType = "Guided bombs",
				expend = "All",
				night = true,
				day = false,
				adverseWeather = true,
				range = 500000,
				firepower = 120,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 8534.4,
				hAttack = 8534.4,
				standoff = 15000,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[2] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
					},
					fuel = "3840",
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
	},
	["Su-24M"] = {
		Strike = {
			["WOB - AG - Kh-59Mx2 - R-60Mx2 - FT"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Structure", "SAM", "frontline" },
				code_loadout =  { "Caucasus", "WOB" },
				weaponType = "ASM",
				expend = "Auto",
				night = true,
				range = 900000,
				firepower = 1,
				vCruise = 250,
				vAttack = 300,
				hCruise = 7096,
				hAttack = 7096,
				standoff = 100000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{APU-60-1_R_60M}",
						},
						[8] = {
							CLSID = "{APU-60-1_R_60M}",
						},
						[2] = {
							CLSID = "{40AB87E8-BEFB-4D85-90D9-B2753ACF9514}",
						},
						[7] = {
							CLSID = "{40AB87E8-BEFB-4D85-90D9-B2753ACF9514}",
						},
						[5] = {
							CLSID = "{16602053-4A12-40A2-B214-AB60D481B20E}",
						},
					},
					fuel = "11700",
					flare = 96,
					chaff = 96,
					gun = 100,
				},
			},
			["BGL, R-60M*4, Fuel"] = {
				minscore = 0.3,
				support = {
					SEAD = true,
					Escort = true,
					["Laser Illumination"] = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Structure", "frontline" },
				code_loadout =  { "Crisis", "PG", "Caucasus", "WOB" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				range = 487000,
				firepower = 1,
				vCruise = 190,
				vAttack = 300,
				hCruise = 6938,
				hAttack = 6938,
				standoff = 15000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{B0DBC591-0F52-4F7D-AD7B-51E67725FB81}",
						},
						[2] = {
							CLSID = "{BA565F89-2373-4A84-9502-A0E017D3A44A}",
						},
						[3] = {
							CLSID = "{BA565F89-2373-4A84-9502-A0E017D3A44A}",
						},
						[4] = {
							CLSID = "{39821727-F6E2-45B3-B1F0-490CC8921D1E}",
						},
						[5] = {
							CLSID = "{0519A264-0AB6-11d6-9193-00A0249B6F00}",
						},
						[6] = {
							CLSID = "{BA565F89-2373-4A84-9502-A0E017D3A44A}",
						},
						[7] = {
							CLSID = "{BA565F89-2373-4A84-9502-A0E017D3A44A}",
						},
						[8] = {
							CLSID = "{275A2855-4A79-4B2D-B082-91EA2ADF4691}",
						},
					},
					fuel = "11700",
					flare = 96,
					chaff = 96,
					gun = 100,
				},
			},
			["Bombs, R-60M*4, Fuel"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "Structure", "frontline" },
				code_loadout =  { "Crisis", "PG", "Caucasus", "WOB" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 524000,
				firepower = 1,
				vCruise = 190,
				vAttack = 300,
				hCruise = 6096,
				hAttack = 6096,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{3C612111-C7AD-476E-8A8E-2485812F4E5C}",
						},
						[2] = {
							CLSID = "{3C612111-C7AD-476E-8A8E-2485812F4E5C}",
						},
						[3] = {
							CLSID = "{3C612111-C7AD-476E-8A8E-2485812F4E5C}",
						},
						[4] = {
							CLSID = "{3C612111-C7AD-476E-8A8E-2485812F4E5C}",
						},
						[5] = {
							CLSID = "{3C612111-C7AD-476E-8A8E-2485812F4E5C}",
						},
						[6] = {
							CLSID = "{3C612111-C7AD-476E-8A8E-2485812F4E5C}",
						},
						[7] = {
							CLSID = "{3C612111-C7AD-476E-8A8E-2485812F4E5C}",
						},
						[8] = {
							CLSID = "{3C612111-C7AD-476E-8A8E-2485812F4E5C}",
						},
					},
					fuel = "11700",
					flare = 96,
					chaff = 96,
					gun = 100,
				},
			},
		},
		["Anti-ship Strike"] = {
			-- ["Antiship, Hi Kh-31A*2,R-60M*4,Fuel"] = {
			-- 	minscore = 0.1,
			-- 	support = {
			-- 		Escort = true,
			-- 		SEAD = false,
			-- 		["Escort Jammer"] = true,
			-- 	},
			-- 	attributes =  { "ship" },
			-- 	code_loadout =  { "Crisis", "PG", "TF", "TF80s", "TF80sRED", "TF80sI", "Caucasus", "WOB" },
			-- 	weaponType = "ASM",
			-- 	expend = "All",
			-- 	night = true,
			-- 	adverseWeather = true,
			-- 	range = 900000,
			-- 	firepower = 1,
			-- 	vCruise = 221,       -- ~800 km/h (Économique à haute altitude)
            --     vAttack = 295,       -- ~1060 km/h (Mach 1.0 max en charge à 10k m pour l'IA)
            --     hCruise = 10000,     -- Limite de stabilité pour les manœuvres IA DCS
            --     hAttack = 10000,     -- Conserve l'avantage de portée du Kh-31A
            --     standoff = 70000,    -- Force le tir à distance max (70km) pour survie
            --     ingress = 75000,     -- Début de la phase finale d'attaque
            --     egress = 20000,      -- Distance de sécurité pour faire demi-tour après tir
			-- 	MaxAttackOffset = 60,
			-- 	sortie_rate = 6,
			-- 	stores = {
			-- 		pylons = {
			-- 			[1] = {
			-- 				CLSID = "{B0DBC591-0F52-4F7D-AD7B-51E67725FB81}",
			-- 			},
			-- 			[2] = {
			-- 				CLSID = "{4D13E282-DF46-4B23-864A-A9423DFDE504}",
			-- 			},
			-- 			[5] = {
			-- 				CLSID = "{16602053-4A12-40A2-B214-AB60D481B20E}",
			-- 			},
			-- 			[7] = {
			-- 				CLSID = "{4D13E282-DF46-4B23-864A-A9423DFDE504}",
			-- 			},
			-- 			[8] = {
			-- 				CLSID = "{275A2855-4A79-4B2D-B082-91EA2ADF4691}",
			-- 			},
			-- 		},
			-- 		fuel = "11700",
			-- 		flare = 96,
			-- 		chaff = 96,
			-- 		gun = 100,
			-- 	},
			-- },
			["Antiship, HiLowHi Kh-31A*2,R-60M*4,Fuel"] = {
				minscore = 0.1,
				support = {
					Escort = true,
					SEAD = false,
					["Escort Jammer"] = true,
				},
				attributes =  { "ship" },
				code_loadout =  { "Crisis", "PG", "TF", "TF80s", "TF80sRED", "TF80sI", "Caucasus", "WOB" },
				weaponType = "ASM",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 700000,
				firepower = 1,
				vCruise = 221, --,
				vAttack = 277, --,
				hCruise = 8000,	--,
				hAttack = 150,	--,
				standoff = 70000,
				ingress = 220000,
				egress = 20000,
				MaxAttackOffset = 30,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{B0DBC591-0F52-4F7D-AD7B-51E67725FB81}",
						},
						[2] = {
							CLSID = "{4D13E282-DF46-4B23-864A-A9423DFDE504}",
						},
						[5] = {
							CLSID = "{16602053-4A12-40A2-B214-AB60D481B20E}",
						},
						[7] = {
							CLSID = "{4D13E282-DF46-4B23-864A-A9423DFDE504}",
						},
						[8] = {
							CLSID = "{275A2855-4A79-4B2D-B082-91EA2ADF4691}",
						},
					},
					fuel = "11700",
					flare = 96,
					chaff = 96,
					gun = 100,
				},
			},
		},
		["Laser Illumination"] = {
			["Laser Illumination, R-60M*4, Fuel"] = {
				attributes =  { },
				code_loadout =  { "Crisis", "PG", "Caucasus" },
				night = true,
				range = 900000,
				firepower = 1,
				vCruise = 270,
				vAttack = 300,
				hCruise = 7096,
				hAttack = 7096,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{B0DBC591-0F52-4F7D-AD7B-51E67725FB81}",
						},
						[8] = {
							CLSID = "{275A2855-4A79-4B2D-B082-91EA2ADF4691}",
						},
						[2] = {
							CLSID = "{7D7EC917-05F6-49D4-8045-61FC587DD019}",
						},
						[7] = {
							CLSID = "{7D7EC917-05F6-49D4-8045-61FC587DD019}",
						},
						[5] = {
							CLSID = "{0519A264-0AB6-11d6-9193-00A0249B6F00}",
						},
					},
					fuel = "11700",
					flare = 96,
					chaff = 96,
					gun = 100,
				},
			},
		},
		SEAD = {
			["SEAD  Kh58*2_R60*4_L-081"] = {
				attributes =  { },
				code_loadout =  { "Crisis", "PG", "Caucasus", "WOB" },
				weaponType = "ASM",
				night = true,
				adverseWeather = true,
				range = 443000,
				firepower = 1,
				vCruise = 250,
				vAttack = 330,
				hCruise = 6938,
				hAttack = 6938,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{B0DBC591-0F52-4F7D-AD7B-51E67725FB81}",
						},
						[2] = {
							CLSID = "{FE382A68-8620-4AC0-BDF5-709BFE3977D7}",
						},
						[5] = {
							CLSID = "{0519A264-0AB6-11d6-9193-00A0249B6F00}",
						},
						[7] = {
							CLSID = "{FE382A68-8620-4AC0-BDF5-709BFE3977D7}",
						},
						[8] = {
							CLSID = "{275A2855-4A79-4B2D-B082-91EA2ADF4691}",
						},
					},
					fuel = "11700",
					flare = 96,
					chaff = 96,
					gun = 100,
				},
			},
		},
		["Runway Attack"] = {
			["WOB BetAB-500HD*4,R-60M*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "Runway" },
				code_loadout =  { "TF", "Caucasus", "WOB" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 9100,
				hAttack = 100,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{APU-60-1_R_60M}",
						},
						[2] = {
							CLSID = "{BD289E34-DF84-4C5E-9220-4B14C346E79D}",
						},
						[3] = {
							CLSID = "{BD289E34-DF84-4C5E-9220-4B14C346E79D}",
						},
						[6] = {
							CLSID = "{BD289E34-DF84-4C5E-9220-4B14C346E79D}",
						},
						[7] = {
							CLSID = "{BD289E34-DF84-4C5E-9220-4B14C346E79D}",
						},
						[8] = {
							CLSID = "{APU-60-1_R_60M}",
						},
					},
					fuel = "11700",
					flare = 96,
					chaff = 96,
					gun = 100,
				},
			},
			["WOB - AG - FAB-250x8 - R-60Mx2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "Runway" },
				code_loadout =  { "TF", "Caucasus", "WOB" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 9100,
				hAttack = 5000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{APU-60-1_R_60M}",
						},
						[2] = {
							CLSID = "{FAB_250_M62}",
						},
						[3] = {
							CLSID = "{3C612111-C7AD-476E-8A8E-2485812F4E5C}",
						},
						[4] = {
							CLSID = "{FAB_250_M62}",
						},
						[5] = {
							CLSID = "{FAB_250_M62}",
						},
						[6] = {
							CLSID = "{FAB_250_M62}",
						},
						[7] = {
							CLSID = "{FAB_250_M62}",
						},
						[8] = {
							CLSID = "{APU-60-1_R_60M}",
						},
					},
					fuel = "11700",
					flare = 96,
					chaff = 96,
					gun = 100,
				},
			},
		},
	},
	["A-50"] = {
		AWACS = {
			Default = {
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 231.25,
				vAttack = 231.25,
				hCruise = 9753.6,
				hAttack = 9753.6,
				tStation = 25200,
				sortie_rate = 0.5,
				stores = {
					pylons = {
					},
					fuel = "70000",
					flare = 192,
					chaff = 192,
					gun = 100,
				},
			},
		},
	},
	["B-1B"] = {
		Strike = {
			["Strike TF AGM-154*12"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "SAM" },
				code_loadout =  { "TF", "Caucasus", "WOB" },
				weaponType = "ASM",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 1000000,
				firepower = 1.5,
				vCruise = 250.25,
				vAttack = 356.94444444444,
				hCruise = 9500,
				hAttack = 9500,
				standoff = 50000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AABA1A14-78A1-4E85-94DD-463CF75BD9E4}",
						},
						[2] = {
							CLSID = "{AABA1A14-78A1-4E85-94DD-463CF75BD9E4}",
						},
						[3] = {
							CLSID = "{AABA1A14-78A1-4E85-94DD-463CF75BD9E4}",
						},
					},
					fuel = "88450",
					flare = 30,
					chaff = 60,
					gun = 100,
				},
			},
			["80s AG - Mk-84x24"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Structure", "SAM", "soft", "Bridge", "Base" },
				code_loadout =  { "TF80sI", "WOC80", "TF80s" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 1000000,
				firepower = 1,
				vCruise = 250.25,
				vAttack = 356.94444444444,
				hCruise = 7315.2,
				hAttack = 7315.2,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "B-1B_Mk-84*8",
						},
						[2] = {
							CLSID = "B-1B_Mk-84*8",
						},
						[3] = {
							CLSID = "B-1B_Mk-84*8",
						},
					},
					fuel = "88450",
					flare = 30,
					chaff = 60,
					gun = 100,
				},
			},
			["80s AG - Mk-82x84"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "SAM", "soft", "Bridge" },
				code_loadout =  { "TF80sI", "WOC80", "TF80s" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 1000000,
				firepower = 1,
				vCruise = 250.25,
				vAttack = 356.94444444444,
				hCruise = 7315.2,
				hAttack = 7315.2,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "MK_82*28",
						},
						[2] = {
							CLSID = "MK_82*28",
						},
						[3] = {
							CLSID = "MK_82*28",
						},
					},
					fuel = "88450",
					flare = 30,
					chaff = 60,
					gun = 100,
				},
			},
		},
	},
	["Il-76MD"] = {
		Transport = {
			Default = {
				attributes =  { },
				code_loadout =  { "All" },
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 154.16666666667,
				vAttack = 154.16666666667,
				hCruise = 3500,
				hAttack = 3500,
				sortie_rate = 6,
				stores = {
					pylons = {
					},
					fuel = 40000,
					flare = 96,
					chaff = 96,
					gun = 100,
				},
			},
		},
	},
	["M-2000C"] = {
		Strike = {
			["GBU-12*4, MagicII*2, FT*2"] = {
				minscore = 0.3,
				support = {
					SEAD = true,
					Escort = true,
					["Laser Illumination"] = true,
				},
				attributes =  { "Bridge" },
				code_loadout =  { },
				weaponType = "Guided bombs",
				expend = "Auto",
								range = 500000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 9100,
				hAttack = 7315.2,
				standoff = 15000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{MMagicII}",
						},
						[2] = {
							CLSID = "{M2KC_02_RPL541}",
						},
						[8] = {
							CLSID = "{M2KC_08_RPL541}",
						},
						[10] = {
							CLSID = "{Eclair}",
						},
						[9] = {
							CLSID = "{MMagicII}",
						},
						[5] = {
							CLSID = "{0D33DDAE-524F-4A4E-B5B8-621754FE3ADE}",
						},
					},
					fuel = 3165,
					flare = 48,
					chaff = 112,
					gun = 100,
				},
			},
			["Caucasus 80s 90s 2000s LR AG Belouga*4,MagicII*2,FT*3"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "frontline" },
				code_loadout =  { "Caucasus" },
				weaponType = "Bombs",
				expend = "All",
								range = 300000,
				firepower = 1,
				vCruise = 195,
				vAttack = 300,
				hCruise = 300.4,
				hAttack = 200,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{MMagicII}",
						},
						[2] = {
							CLSID = "{M2KC_02_RPL541}",
						},
						[3] = {
							CLSID = "{BLG66_BELOUGA_AC}",
						},
						[4] = {
							CLSID = "{BLG66_BELOUGA_AC}",
						},
						[5] = {
							CLSID = "{M2KC_RPL_522}",
						},
						[6] = {
							CLSID = "{BLG66_BELOUGA_AC}",
						},
						[7] = {
							CLSID = "{BLG66_BELOUGA_AC}",
						},
						[8] = {
							CLSID = "{M2KC_08_RPL541}",
						},
						[9] = {
							CLSID = "{MMagicII}",
						},
					},
					fuel = 3165,
					flare = 48,
					chaff = 112,
					gun = 100,
				},
			},
			["Cyprus 80s 90s 2000s SR AG Belouga*8,MagicII*2,FT*1"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "SAM" },
				code_loadout =  { "Cyprus", "Crisis", "PG" },
				weaponType = "Bombs",
				expend = "All",
								range = 200000,
				firepower = 1,
				vCruise = 195,
				vAttack = 300,
				hCruise = 300.4,
				hAttack = 200,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{MMagicII}",
						},
						[2] = {
							CLSID = "{M2KC_RAFAUT_BLG66}",
						},
						[3] = {
							CLSID = "{BLG66_BELOUGA_AC}",
						},
						[4] = {
							CLSID = "{BLG66_BELOUGA_AC}",
						},
						[5] = {
							CLSID = "{M2KC_RPL_522}",
						},
						[6] = {
							CLSID = "{BLG66_BELOUGA_AC}",
						},
						[7] = {
							CLSID = "{BLG66_BELOUGA_AC}",
						},
						[8] = {
							CLSID = "{M2KC_RAFAUT_BLG66}",
						},
						[9] = {
							CLSID = "{MMagicII}",
						},
					},
					fuel = 3165,
					flare = 48,
					chaff = 112,
					gun = 100,
				},
			},
			["80s 90s 2000s SR AG MK82HD*8,MagicII*2,FT*1"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "Structure" },
				code_loadout =  { "Cyprus", "Crisis", "PG", "WOB" },
				weaponType = "Bombs",
				expend = "All",
				day = false,
				night = true,
				range = 350000,
				firepower = 1,
				vCruise = 195,
				vAttack = 300,
				hCruise = 300.4,
				hAttack = 200,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{MMagicII}",
						},
						[2] = {
							CLSID = "{M2KC_RAFAUT_MK82A}",
						},
						[3] = {
							CLSID = "{Mk82AIR}",
						},
						[4] = {
							CLSID = "{Mk82AIR}",
						},
						[5] = {
							CLSID = "{M2KC_RPL_522}",
						},
						[6] = {
							CLSID = "{Mk82AIR}",
						},
						[7] = {
							CLSID = "{Mk82AIR}",
						},
						[8] = {
							CLSID = "{M2KC_RAFAUT_MK82A}",
						},
						[9] = {
							CLSID = "{MMagicII}",
						},
					},
					fuel = 3165,
					flare = 48,
					chaff = 112,
					gun = 100,
				},
			},
			["Caucasus 80s 90s 2000s SR AG Belouga*8,MagicII*2,FT*1"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "frontline" },
				code_loadout =  { "Caucasus" },
				weaponType = "Bombs",
				expend = "All",
								range = 200000,
				firepower = 1,
				vCruise = 195,
				vAttack = 300,
				hCruise = 300.4,
				hAttack = 200,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{MMagicII}",
						},
						[2] = {
							CLSID = "{M2KC_RAFAUT_BLG66}",
						},
						[3] = {
							CLSID = "{BLG66_BELOUGA_AC}",
						},
						[4] = {
							CLSID = "{BLG66_BELOUGA_AC}",
						},
						[5] = {
							CLSID = "{M2KC_RPL_522}",
						},
						[6] = {
							CLSID = "{BLG66_BELOUGA_AC}",
						},
						[7] = {
							CLSID = "{BLG66_BELOUGA_AC}",
						},
						[8] = {
							CLSID = "{M2KC_RAFAUT_BLG66}",
						},
						[9] = {
							CLSID = "{MMagicII}",
						},
					},
					fuel = 3165,
					flare = 48,
					chaff = 112,
					gun = 100,
				},
			},
			["80s 90s 2000s LR AG MK82*4,MagicII*2,FT*3"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "Structure" },
				code_loadout =  { "Cyprus", "Crisis", "PG", "WOB" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				range = 360000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 9100,
				hAttack = 4572,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{MMagicII}",
						},
						[2] = {
							CLSID = "{M2KC_02_RPL541}",
						},
						[3] = {
							CLSID = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
						},
						[4] = {
							CLSID = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
						},
						[5] = {
							CLSID = "{M2KC_RPL_522}",
						},
						[6] = {
							CLSID = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
						},
						[7] = {
							CLSID = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
						},
						[8] = {
							CLSID = "{M2KC_08_RPL541}",
						},
						[9] = {
							CLSID = "{MMagicII}",
						},
					},
					fuel = 3165,
					flare = 48,
					chaff = 112,
					gun = 100,
				},
			},
			["WOC 2000s LR AG MK82*4,MagicII*2,FT*3"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "frontline" },
				code_loadout =  { "Caucasus", "WOC80", "WOB" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				range = 360000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 9100,
				hAttack = 4572,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{MMagicII}",
						},
						[2] = {
							CLSID = "{M2KC_02_RPL541}",
						},
						[3] = {
							CLSID = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
						},
						[4] = {
							CLSID = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
						},
						[5] = {
							CLSID = "{M2KC_RPL_522}",
						},
						[6] = {
							CLSID = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
						},
						[7] = {
							CLSID = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
						},
						[8] = {
							CLSID = "{M2KC_08_RPL541}",
						},
						[9] = {
							CLSID = "{MMagicII}",
						},
					},
					fuel = 3165,
					flare = 48,
					chaff = 112,
					gun = 100,
				},
			},
			["Revenge LR AG MK82*4,MagicII*2,FT*3"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "Structure" },
				code_loadout =  { "Revenge" },
				weaponType = "Bombs",
				expend = "All",
								range = 200000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 9100,
				hAttack = 4572,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{MMagicII}",
						},
						[2] = {
							CLSID = "{M2KC_02_RPL541}",
						},
						[3] = {
							CLSID = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
						},
						[4] = {
							CLSID = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
						},
						[5] = {
							CLSID = "{M2KC_RPL_522}",
						},
						[6] = {
							CLSID = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
						},
						[7] = {
							CLSID = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
						},
						[8] = {
							CLSID = "{M2KC_08_RPL541}",
						},
						[9] = {
							CLSID = "{MMagicII}",
						},
					},
					fuel = 3165,
					flare = 48,
					chaff = 112,
					gun = 100,
				},
			},
			["80s 90s 2000s LR AG MK82HD*4,MagicII*2,FT*3"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "Structure" },
				code_loadout =  { "Cyprus", "Crisis", "PG" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				range = 300000,
				firepower = 1,
				vCruise = 195,
				vAttack = 300,
				hCruise = 6000,
				hAttack = 50,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{MMagicII}",
						},
						[2] = {
							CLSID = "{M2KC_02_RPL541}",
						},
						[3] = {
							CLSID = "{Mk82AIR}",
						},
						[4] = {
							CLSID = "{Mk82AIR}",
						},
						[5] = {
							CLSID = "{M2KC_RPL_522}",
						},
						[6] = {
							CLSID = "{Mk82AIR}",
						},
						[7] = {
							CLSID = "{Mk82AIR}",
						},
						[8] = {
							CLSID = "{M2KC_08_RPL541}",
						},
						[9] = {
							CLSID = "{MMagicII}",
						},
					},
					fuel = 3165,
					flare = 48,
					chaff = 112,
					gun = 100,
				},
			},
			["Revenge LR AG MK82HD*4,MagicII*2,FT*3"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "Structure" },
				code_loadout =  { "Revenge" },
				weaponType = "Bombs",
				expend = "All",
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 195,
				vAttack = 300,
				hCruise = 6000,
				hAttack = 50,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{MMagicII}",
						},
						[2] = {
							CLSID = "{M2KC_02_RPL541}",
						},
						[3] = {
							CLSID = "{Mk82AIR}",
						},
						[4] = {
							CLSID = "{Mk82AIR}",
						},
						[5] = {
							CLSID = "{M2KC_RPL_522}",
						},
						[6] = {
							CLSID = "{Mk82AIR}",
						},
						[7] = {
							CLSID = "{Mk82AIR}",
						},
						[8] = {
							CLSID = "{M2KC_08_RPL541}",
						},
						[9] = {
							CLSID = "{MMagicII}",
						},
					},
					fuel = 3165,
					flare = 48,
					chaff = 112,
					gun = 100,
				},
			},
			["GBU-16*1, MagicII*2, FT*2"] = {
				minscore = 0.3,
				support = {
					SEAD = true,
					Escort = true,
					["Laser Illumination"] = true,
				},
				attributes =  { "Bridge", "Structure" },
				code_loadout =  { },
				weaponType = "Guided bombs",
				expend = "Auto",
								range = 500000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 9100,
				hAttack = 7315.2,
				standoff = 15000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{MMagicII}",
						},
						[2] = {
							CLSID = "{M2KC_02_RPL541}",
						},
						[8] = {
							CLSID = "{M2KC_08_RPL541}",
						},
						[10] = {
							CLSID = "{Eclair}",
						},
						[9] = {
							CLSID = "{MMagicII}",
						},
						[5] = {
							CLSID = "{0D33DDAE-524F-4A4E-B5B8-621754FE3ADE}",
						},
					},
					fuel = 3165,
					flare = 48,
					chaff = 112,
					gun = 100,
				},
			},
			["Cyprus 80s 90s 2000s LR AG Belouga*4,MagicII*2,FT*3"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "SAM" },
				code_loadout =  { "Cyprus", "Crisis", "PG" },
				weaponType = "Bombs",
				expend = "All",
								range = 300000,
				firepower = 1,
				vCruise = 195,
				vAttack = 300,
				hCruise = 300.4,
				hAttack = 200,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{MMagicII}",
						},
						[2] = {
							CLSID = "{M2KC_02_RPL541}",
						},
						[3] = {
							CLSID = "{BLG66_BELOUGA_AC}",
						},
						[4] = {
							CLSID = "{BLG66_BELOUGA_AC}",
						},
						[5] = {
							CLSID = "{M2KC_RPL_522}",
						},
						[6] = {
							CLSID = "{BLG66_BELOUGA_AC}",
						},
						[7] = {
							CLSID = "{BLG66_BELOUGA_AC}",
						},
						[8] = {
							CLSID = "{M2KC_08_RPL541}",
						},
						[9] = {
							CLSID = "{MMagicII}",
						},
					},
					fuel = 3165,
					flare = 48,
					chaff = 112,
					gun = 100,
				},
			},
			["WOC SR AG MK82*8,MagicII*2,FT*1"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "frontline" },
				code_loadout =  { "Caucasus", "WOC80", "WOB" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				range = 350000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 9100,
				hAttack = 4572,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{MMagicII}",
						},
						[2] = {
							CLSID = "{M2KC_RAFAUT_MK82}",
						},
						[3] = {
							CLSID = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
						},
						[4] = {
							CLSID = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
						},
						[5] = {
							CLSID = "{M2KC_RPL_522}",
						},
						[6] = {
							CLSID = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
						},
						[7] = {
							CLSID = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
						},
						[8] = {
							CLSID = "{M2KC_RAFAUT_MK82}",
						},
						[9] = {
							CLSID = "{MMagicII}",
						},
					},
					fuel = 3165,
					flare = 48,
					chaff = 112,
					gun = 100,
				},
			},
			["WOC LR AG MK82HD*4,MagicII*2,FT*3"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "frontline" },
				code_loadout =  { "Caucasus", "WOC80" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				range = 300000,
				firepower = 1,
				vCruise = 195,
				vAttack = 300,
				hCruise = 6000,
				hAttack = 50,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{MMagicII}",
						},
						[2] = {
							CLSID = "{M2KC_02_RPL541}",
						},
						[3] = {
							CLSID = "{Mk82AIR}",
						},
						[4] = {
							CLSID = "{Mk82AIR}",
						},
						[5] = {
							CLSID = "{M2KC_RPL_522}",
						},
						[6] = {
							CLSID = "{Mk82AIR}",
						},
						[7] = {
							CLSID = "{Mk82AIR}",
						},
						[8] = {
							CLSID = "{M2KC_08_RPL541}",
						},
						[9] = {
							CLSID = "{MMagicII}",
						},
					},
					fuel = 3165,
					flare = 48,
					chaff = 112,
					gun = 100,
				},
			},
			["WOC SR AG MK82HD*8,MagicII*2,FT*1"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "frontline" },
				code_loadout =  { "Caucasus", "WOC80", "WOB" },
				weaponType = "Bombs",
				expend = "All",
				day = false,
				night = true,
				range = 350000,
				firepower = 1,
				vCruise = 195,
				vAttack = 300,
				hCruise = 300.4,
				hAttack = 200,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{MMagicII}",
						},
						[2] = {
							CLSID = "{M2KC_RAFAUT_MK82A}",
						},
						[3] = {
							CLSID = "{Mk82AIR}",
						},
						[4] = {
							CLSID = "{Mk82AIR}",
						},
						[5] = {
							CLSID = "{M2KC_RPL_522}",
						},
						[6] = {
							CLSID = "{Mk82AIR}",
						},
						[7] = {
							CLSID = "{Mk82AIR}",
						},
						[8] = {
							CLSID = "{M2KC_RAFAUT_MK82A}",
						},
						[9] = {
							CLSID = "{MMagicII}",
						},
					},
					fuel = 3165,
					flare = 48,
					chaff = 112,
					gun = 100,
				},
			},
			["80s 90s 2000s SR AG MK82*4,MagicII*2,FT*1"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "Structure" },
				code_loadout =  { "Cyprus", "Crisis", "PG", "WOB" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				range = 350000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 9100,
				hAttack = 4572,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{MMagicII}",
						},
						[3] = {
							CLSID = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
						},
						[4] = {
							CLSID = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
						},
						[5] = {
							CLSID = "{M2KC_RPL_522}",
						},
						[6] = {
							CLSID = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
						},
						[7] = {
							CLSID = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
						},
						[9] = {
							CLSID = "{MMagicII}",
						},
					},
					fuel = 3165,
					flare = 48,
					chaff = 112,
					gun = 100,
				},
			},
		},
		["Anti-ship Strike"] = {
			["Revenge LR AG MK82*4,MagicII*2,FT*3"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "ship" },
				code_loadout =  { "Revenge" },
				weaponType = "Bombs",
				expend = "All",
								range = 200000,
				firepower = 1,
				vCruise = 205,
				vAttack = 277.5,
				hCruise = 9100,
				hAttack = 4572,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{MMagicII}",
						},
						[2] = {
							CLSID = "{M2KC_02_RPL541}",
						},
						[3] = {
							CLSID = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
						},
						[4] = {
							CLSID = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
						},
						[5] = {
							CLSID = "{M2KC_RPL_522}",
						},
						[6] = {
							CLSID = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
						},
						[7] = {
							CLSID = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
						},
						[8] = {
							CLSID = "{M2KC_08_RPL541}",
						},
						[9] = {
							CLSID = "{MMagicII}",
						},
					},
					fuel = 3165,
					flare = 48,
					chaff = 112,
					gun = 100,
				},
			},
			["Revenge LR AG MK82HD*4,MagicII*2,FT*3"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "ship" },
				code_loadout =  { "Revenge" },
				weaponType = "Bombs",
				expend = "All",
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 195,
				vAttack = 300,
				hCruise = 6000,
				hAttack = 50,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{MMagicII}",
						},
						[2] = {
							CLSID = "{M2KC_02_RPL541}",
						},
						[3] = {
							CLSID = "{Mk82AIR}",
						},
						[4] = {
							CLSID = "{Mk82AIR}",
						},
						[5] = {
							CLSID = "{M2KC_RPL_522}",
						},
						[6] = {
							CLSID = "{Mk82AIR}",
						},
						[7] = {
							CLSID = "{Mk82AIR}",
						},
						[8] = {
							CLSID = "{M2KC_08_RPL541}",
						},
						[9] = {
							CLSID = "{MMagicII}",
						},
					},
					fuel = 3165,
					flare = 48,
					chaff = 112,
					gun = 100,
				},
			},
		},
		Escort = {
			["Escort WOB - 2000-5 - Eclair - Mica IRx2 - Mica EMx4 - FT1300"] = {
				attributes =  { },
				code_loadout =  { "WOB" },
				night = true,
				adverseWeather = true,
				range = 800000,
				firepower = 1,
				vCruise = 270,
				standoff = 27000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{0DA03783-61E4-40B2-8FAE-6AEE0A5C5AAE}",
						},
						[3] = {
							CLSID = "{6D778860-7BB8-4ACB-9E95-BA772C6BBC2C}",
						},
						[4] = {
							CLSID = "{6D778860-7BB8-4ACB-9E95-BA772C6BBC2C}",
						},
						[5] = {
							CLSID = "{M2KC_RPL_522}",
						},
						[6] = {
							CLSID = "{6D778860-7BB8-4ACB-9E95-BA772C6BBC2C}",
						},
						[7] = {
							CLSID = "{6D778860-7BB8-4ACB-9E95-BA772C6BBC2C}",
						},
						[10] = {
							CLSID = "{EclairM_42}",
						},
						[9] = {
							CLSID = "{0DA03783-61E4-40B2-8FAE-6AEE0A5C5AAE}",
						},
					},
					fuel = 3165,
					flare = 48,
					chaff = 112,
					gun = 100,
				},
			},
			["Escort 80s 90s 2000s MagicII*2, S-530D*2, FT*1"] = {
				attributes =  { },
				code_loadout =  { "Cyprus", "Crisis", "PG", "Caucasus", "WOC80" },
				night = true,
				adverseWeather = true,
				range = 800000,
				firepower = 1,
				vCruise = 270,
				standoff = 27000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{MMagicII}",
						},
						[2] = {
							CLSID = "{Matra_S530D}",
						},
						[5] = {
							CLSID = "{M2KC_RPL_522}",
						},
						[9] = {
							CLSID = "{MMagicII}",
						},
						[8] = {
							CLSID = "{Matra_S530D}",
						},
					},
					fuel = 3165,
					flare = 48,
					chaff = 112,
					gun = 100,
				},
			},
			["Revenge Escort MagicII*2, S-530D*2, FT*1"] = {
				attributes =  { },
				code_loadout =  { "Revenge", "WOC80" },
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 270,
				standoff = 27000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{MMagicII}",
						},
						[2] = {
							CLSID = "{Matra_S530D}",
						},
						[5] = {
							CLSID = "{M2KC_RPL_522}",
						},
						[9] = {
							CLSID = "{MMagicII}",
						},
						[8] = {
							CLSID = "{Matra_S530D}",
						},
					},
					fuel = 3165,
					flare = 48,
					chaff = 112,
					gun = 100,
				},
			},
		},
		CAP = {
			["CAP WOB - 2000-5 - Eclair - Mica IRx2 - Mica EMx4 - FT1300"] = {
				attributes =  { },
				code_loadout =  { "WOB" },
				night = true,
				adverseWeather = true,
				range = 800000,
				firepower = 1,
				vCruise = 245,
				vAttack = 246.66666666667,
				hCruise = 10900,
				hAttack = 10900,
				standoff = 36000,
				tStation = 1800,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{0DA03783-61E4-40B2-8FAE-6AEE0A5C5AAE}",
						},
						[3] = {
							CLSID = "{6D778860-7BB8-4ACB-9E95-BA772C6BBC2C}",
						},
						[4] = {
							CLSID = "{6D778860-7BB8-4ACB-9E95-BA772C6BBC2C}",
						},
						[5] = {
							CLSID = "{M2KC_RPL_522}",
						},
						[6] = {
							CLSID = "{6D778860-7BB8-4ACB-9E95-BA772C6BBC2C}",
						},
						[7] = {
							CLSID = "{6D778860-7BB8-4ACB-9E95-BA772C6BBC2C}",
						},
						[10] = {
							CLSID = "{EclairM_42}",
						},
						[9] = {
							CLSID = "{0DA03783-61E4-40B2-8FAE-6AEE0A5C5AAE}",
						},
					},
					fuel = 3165,
					flare = 48,
					chaff = 112,
					gun = 100,
				},
			},
			["CAP 80s 90s 2000s Day, MagicII*2, S-530D*2, FT*1"] = {
				attributes =  { "Air Forces" },
				code_loadout =  { "Cyprus", "Crisis", "PG", "Caucasus", "WOC80" },
				adverseWeather = true,
				range = 800000,
				firepower = 1,
				vCruise = 245,
				vAttack = 246.66666666667,
				hCruise = 10900,
				hAttack = 10900,
				standoff = 36000,
				tStation = 1800,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{MMagicII}",
						},
						[2] = {
							CLSID = "{Matra_S530D}",
						},
						[5] = {
							CLSID = "{M2KC_RPL_522}",
						},
						[9] = {
							CLSID = "{MMagicII}",
						},
						[8] = {
							CLSID = "{Matra_S530D}",
						},
					},
					fuel = 3165,
					flare = 48,
					chaff = 112,
					gun = 100,
				},
			},
			["Revenge, MagicII*2, S-530D*2, FT*1"] = {
				attributes =  { },
				code_loadout =  { "Revenge" },
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 245,
				vAttack = 246.66666666667,
				hCruise = 10900,
				hAttack = 10900,
				standoff = 36000,
				tStation = 1800,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{MMagicII}",
						},
						[2] = {
							CLSID = "{Matra_S530D}",
						},
						[5] = {
							CLSID = "{M2KC_RPL_522}",
						},
						[9] = {
							CLSID = "{MMagicII}",
						},
						[8] = {
							CLSID = "{Matra_S530D}",
						},
					},
					fuel = 3165,
					flare = 48,
					chaff = 112,
					gun = 100,
				},
			},
		},
		["Fighter Sweep"] = {
			["Sweep WOB - 2000-5 - Eclair - Mica IRx2 - Mica EMx4 - FT1300"] = {
				attributes =  { },
				code_loadout =  { "WOB" },
				night = true,
				adverseWeather = true,
				range = 800000,
				firepower = 1,
				vCruise = 255.83333333333,
				vAttack = 265.83333333333,
				hCruise = 10900,
				hAttack = 10900,
				standoff = 27000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{0DA03783-61E4-40B2-8FAE-6AEE0A5C5AAE}",
						},
						[3] = {
							CLSID = "{6D778860-7BB8-4ACB-9E95-BA772C6BBC2C}",
						},
						[4] = {
							CLSID = "{6D778860-7BB8-4ACB-9E95-BA772C6BBC2C}",
						},
						[5] = {
							CLSID = "{M2KC_RPL_522}",
						},
						[6] = {
							CLSID = "{6D778860-7BB8-4ACB-9E95-BA772C6BBC2C}",
						},
						[7] = {
							CLSID = "{6D778860-7BB8-4ACB-9E95-BA772C6BBC2C}",
						},
						[10] = {
							CLSID = "{EclairM_42}",
						},
						[9] = {
							CLSID = "{0DA03783-61E4-40B2-8FAE-6AEE0A5C5AAE}",
						},
					},
					fuel = 3165,
					flare = 48,
					chaff = 112,
					gun = 100,
				},
			},
			["Sweep 80s 90s 2000s MagicII*2, S-530D*2, FT*1"] = {
				attributes =  { },
				code_loadout =  { "Cyprus", "Crisis", "PG", "Caucasus", "Revenge", "WOC80" },
				night = true,
				adverseWeather = true,
				range = 800000,
				firepower = 1,
				vCruise = 255.83333333333,
				vAttack = 265.83333333333,
				hCruise = 10900,
				hAttack = 10900,
				standoff = 27000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{MMagicII}",
						},
						[2] = {
							CLSID = "{Matra_S530D}",
						},
						[5] = {
							CLSID = "{M2KC_RPL_522}",
						},
						[9] = {
							CLSID = "{MMagicII}",
						},
						[8] = {
							CLSID = "{Matra_S530D}",
						},
					},
					fuel = 3165,
					flare = 48,
					chaff = 112,
					gun = 100,
				},
			},
		},
		Intercept = {
			["Intercept WOB - 2000-5 - Eclair - Mica IRx2 - Mica EMx4 - FT1300"] = {
				attributes =  { },
				code_loadout =  { "WOB" },
				night = true,
				adverseWeather = true,
				range = 800000,
				firepower = 1,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{0DA03783-61E4-40B2-8FAE-6AEE0A5C5AAE}",
						},
						[3] = {
							CLSID = "{6D778860-7BB8-4ACB-9E95-BA772C6BBC2C}",
						},
						[4] = {
							CLSID = "{6D778860-7BB8-4ACB-9E95-BA772C6BBC2C}",
						},
						[5] = {
							CLSID = "{M2KC_RPL_522}",
						},
						[6] = {
							CLSID = "{6D778860-7BB8-4ACB-9E95-BA772C6BBC2C}",
						},
						[7] = {
							CLSID = "{6D778860-7BB8-4ACB-9E95-BA772C6BBC2C}",
						},
						[10] = {
							CLSID = "{EclairM_42}",
						},
						[9] = {
							CLSID = "{0DA03783-61E4-40B2-8FAE-6AEE0A5C5AAE}",
						},
					},
					fuel = 3165,
					flare = 48,
					chaff = 112,
					gun = 100,
				},
			},
			["Intercept 80s 90s 2000s Day, MagicII*2, S-530D*2, FT*1"] = {
				attributes =  { },
				code_loadout =  { "Cyprus", "Crisis", "PG", "Caucasus", "Revenge", "WOC80" },
				adverseWeather = true,
				range = 800000,
				firepower = 1,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{MMagicII}",
						},
						[2] = {
							CLSID = "{Matra_S530D}",
						},
						[5] = {
							CLSID = "{M2KC_RPL_522}",
						},
						[9] = {
							CLSID = "{MMagicII}",
						},
						[8] = {
							CLSID = "{Matra_S530D}",
						},
					},
					fuel = 3165,
					flare = 48,
					chaff = 112,
					gun = 100,
				},
			},
		},
	},
	["A-10A"] = {
		Strike = {
			["Strike SR WOC-80s-Mav*4 - CBU-97 - CBU-87 - Rockets*14 - Mk-82HD*3 - AA*2 - ECM"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "frontline" },
				code_loadout =  { "WOC80" },
				weaponType = "ASM",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 560000,
				firepower = 1,
				vCruise = 120,
				vAttack = 125,
				hCruise = 5200,
				hAttack = 5100,
				standoff = 9000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6D21ECEA-F85B-4E8D-9D51-31DC9B8AA4EF}",
						},
						[2] = {
							CLSID = "{174C6E6D-0C3D-42ff-BCB3-0853CB371F5C}",
						},
						[3] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98452}",
						},
						[4] = {
							CLSID = "{5335D97A-35A5-4643-9D9B-026C75961E52}",
						},
						[5] = {
							CLSID = "{Mk82AIR}",
						},
						[6] = {
							CLSID = "{Mk82AIR}",
						},
						[7] = {
							CLSID = "{Mk82AIR}",
						},
						[8] = {
							CLSID = "{CBU-87}",
						},
						[9] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98453}",
						},
						[10] = {
							CLSID = "{174C6E6D-0C3D-42ff-BCB3-0853CB371F5C}",
						},
						[11] = {
							CLSID = "LAU-105_2*AIM-9L",
						},
					},
					fuel = 5029,
					flare = 120,
					chaff = 240,
					gun = 100,
				},
			},
			["Strike 80s AGM-65D*6,Mk82HD*4,AIM-9L*2,ECM"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "frontline" },
				code_loadout =  { "Caucasus" },
				weaponType = "ASM",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 360000,
				firepower = 1,
				vCruise = 120,
				vAttack = 125,
				hCruise = 5200,
				hAttack = 5100,
				standoff = 9000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6D21ECEA-F85B-4E8D-9D51-31DC9B8AA4EF}",
						},
						[2] = {
							CLSID = "{174C6E6D-0C3D-42ff-BCB3-0853CB371F5C}",
						},
						[3] = {
							CLSID = "{DAC53A2F-79CA-42FF-A77A-F5649B601308}",
						},
						[4] = {
							CLSID = "{Mk82AIR}",
						},
						[5] = {
							CLSID = "{Mk82AIR}",
						},
						[7] = {
							CLSID = "{Mk82AIR}",
						},
						[8] = {
							CLSID = "{Mk82AIR}",
						},
						[9] = {
							CLSID = "{DAC53A2F-79CA-42FF-A77A-F5649B601308}",
						},
						[10] = {
							CLSID = "{174C6E6D-0C3D-42ff-BCB3-0853CB371F5C}",
						},
						[11] = {
							CLSID = "LAU-105_2*AIM-9L",
						},
					},
					fuel = 5029,
					flare = 120,
					chaff = 240,
					gun = 100,
				},
			},
		},
	},
	["MB-339A"] = {
		Strike = {
			["Strike Rkt 50*50 - Bat120*12 - GP*2 - FT*2"] = {
				minscore = 0.3,
				support = {
					SEAD = true,
					Escort = true,
					["Laser Illumination"] = false,
				},
				attributes =  { "soft", "Parked Aircraft" },
				code_loadout =  { "All" },
				weaponType = "Rockets",
				expend = "Auto",
				attackType = "Dive",
								range = 600000,
				firepower = 1,
				vCruise = 200,
				vAttack = 250,
				hCruise = 5486.4,
				hAttack = 4572,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{FUEL-TIP-ELLITTIC-L}",
						},
						[2] = {
							CLSID = "{LR25_ARF8M3_API}",
						},
						[3] = {
							CLSID = "{14_3_M2_6xBAT120}",
						},
						[4] = {
							CLSID = "{MB339_DEFA553_L}",
						},
						[7] = {
							CLSID = "{MB339_DEFA553_R}",
						},
						[8] = {
							CLSID = "{14_3_M2_6xBAT120}",
						},
						[10] = {
							CLSID = "{FUEL-TIP-ELLITTIC-R}",
						},
						[9] = {
							CLSID = "{LR25_ARF8M3_API}",
						},
					},
					fuel = 626,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
			["Strike Rkt matra*36 - Zuni*8 - GP*2 - FT*2"] = {
				minscore = 0.3,
				support = {
					SEAD = true,
					Escort = true,
					["Laser Illumination"] = false,
				},
				attributes =  { "soft", "Parked Aircraft" },
				code_loadout =  { "All" },
				weaponType = "Rockets",
				expend = "Auto",
				attackType = "Dive",
								range = 600000,
				firepower = 1,
				vCruise = 200,
				vAttack = 250,
				hCruise = 5486.4,
				hAttack = 200,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{FUEL-TIP-ELLITTIC-L}",
						},
						[2] = {
							CLSID = "{Matra155RocketPod}",
						},
						[3] = {
							CLSID = "{F3EFE0AB-E91A-42D8-9CA2-B63C91ED570A}",
						},
						[4] = {
							CLSID = "{MB339_DEFA553_L}",
						},
						[7] = {
							CLSID = "{MB339_DEFA553_R}",
						},
						[8] = {
							CLSID = "{F3EFE0AB-E91A-42D8-9CA2-B63C91ED570A}",
						},
						[10] = {
							CLSID = "{FUEL-TIP-ELLITTIC-R}",
						},
						[9] = {
							CLSID = "{Matra155RocketPod}",
						},
					},
					fuel = 626,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
			["Strike Mk 82 HD*6 - FT*2"] = {
				minscore = 0.3,
				support = {
					SEAD = true,
					Escort = true,
					["Laser Illumination"] = false,
				},
				attributes =  { "soft", "Parked Aircraft" },
				code_loadout =  { "All" },
				weaponType = "Bombs",
				expend = "Auto",
				attackType = "Dive",
								range = 600000,
				firepower = 1,
				vCruise = 200,
				vAttack = 250,
				hCruise = 5486.4,
				hAttack = 200,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{FUEL-TIP-ELLITTIC-L}",
						},
						[2] = {
							CLSID = "{Mk82SNAKEYE}",
						},
						[3] = {
							CLSID = "{Mk82SNAKEYE}",
						},
						[4] = {
							CLSID = "{Mk82SNAKEYE}",
						},
						[7] = {
							CLSID = "{Mk82SNAKEYE}",
						},
						[8] = {
							CLSID = "{Mk82SNAKEYE}",
						},
						[10] = {
							CLSID = "{FUEL-TIP-ELLITTIC-R}",
						},
						[9] = {
							CLSID = "{Mk82SNAKEYE}",
						},
					},
					fuel = 626,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		["Anti-ship Strike"] = {
			["Anti Ship Strike - 2*320L TipTanks + 2*DEFA-553 GunPods + 2*LAU-10(Zuni Rockets) Mk-82HD*2"] = {
				minscore = 0.3,
				support = {
					SEAD = false,
					Escort = true,
					["Laser Illumination"] = false,
				},
				attributes =  { "ship" },
				code_loadout =  { "All" },
				weaponType = "Rockets",
				expend = "Auto",
				attackType = "Dive",
								range = 600000,
				firepower = 1,
				vCruise = 200,
				vAttack = 250,
				hCruise = 5486.4,
				hAttack = 4572,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{FUEL-TIP-ELLITTIC-L}",
						},
						[2] = {
							CLSID = "{Mk82SNAKEYE}",
						},
						[3] = {
							CLSID = "{F3EFE0AB-E91A-42D8-9CA2-B63C91ED570A}",
						},
						[4] = {
							CLSID = "{MB339_DEFA553_L}",
						},
						[7] = {
							CLSID = "{MB339_DEFA553_R}",
						},
						[8] = {
							CLSID = "{F3EFE0AB-E91A-42D8-9CA2-B63C91ED570A}",
						},
						[10] = {
							CLSID = "{FUEL-TIP-ELLITTIC-R}",
						},
						[9] = {
							CLSID = "{Mk82SNAKEYE}",
						},
					},
					fuel = 2280,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
	},
	["L-39C"] = {
		Strike = {
			["Strike - HWITC - Fab 100*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "soft", "Parked Aircraft", "Structure" },
				code_loadout =  { "HWITC" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
								range = 450000,
				firepower = 1,
				vCruise = 200,
				vAttack = 300.5,
				hCruise = 5486.4,
				hAttack = 4572,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{FB3CE165-BF07-4979-887C-92B87F13276B}",
						},
						[3] = {
							CLSID = "{FB3CE165-BF07-4979-887C-92B87F13276B}",
						},
					},
					fuel = "980",
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
			["Strike - HWITC - Rocket S-5*32"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "soft", "Parked Aircraft" },
				code_loadout =  { "HWITC" },
				weaponType = "Rockets",
				expend = "Auto",
				attackType = "Dive",
								range = 250000,
				firepower = 1,
				vCruise = 200,
				vAttack = 300.5,
				hCruise = 5486.4,
				hAttack = 4572,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{UB-16-57UMP}",
						},
						[3] = {
							CLSID = "{UB-16-57UMP}",
						},
					},
					fuel = "980",
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		["Fighter Sweep"] = {
			["AA - Old  - R-3S*2"] = {
				self_escort = true,
				attributes =  { },
				code_loadout =  { "HWITC" },
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
						[1] = {
							CLSID = "{R-3S}",
						},
						[3] = {
							CLSID = "{R-3S}",
						},
					},
					fuel = "980",
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		Escort = {
			["AA - Old  - R-3S*2"] = {
				attributes =  { },
				code_loadout =  { "HWITC" },
								range = 250000,
				firepower = 1,
				vCruise = 200,
				standoff = 40000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R-3S}",
						},
						[3] = {
							CLSID = "{R-3S}",
						},
					},
					fuel = "1800",
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		CAP = {
			["AA - Old  - R-3S*2"] = {
				attributes =  { },
				code_loadout =  { "HWITC" },
								range = 250000,
				firepower = 1,
				vCruise = 200,
				vAttack = 213.86666666667,
				hCruise = 7096,
				hAttack = 7096,
				standoff = 40000,
				tStation = 1800,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R-3S}",
						},
						[3] = {
							CLSID = "{R-3S}",
						},
					},
					fuel = "980",
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		["Anti-ship Strike"] = {
			["Strike - HWITC - Fab 100*2"] = {
				minscore = 0.3,
				support = {
					SEAD = false,
					Escort = true,
					["Laser Illumination"] = false,
				},
				attributes =  { "ship" },
				code_loadout =  { "HWITC" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
								range = 450000,
				firepower = 1,
				vCruise = 200,
				vAttack = 250,
				hCruise = 5000,
				hAttack = 5000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{FB3CE165-BF07-4979-887C-92B87F13276B}",
						},
						[3] = {
							CLSID = "{FB3CE165-BF07-4979-887C-92B87F13276B}",
						},
					},
					fuel = "980",
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		Intercept = {
			["AA - Old  - R-3S*2"] = {
				attributes =  { },
				code_loadout =  { "HWITC" },
								range = 150000,
				firepower = 1,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{R-3S}",
						},
						[3] = {
							CLSID = "{R-3S}",
						},
					},
					fuel = "980",
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
	},
	["Mirage-F1EE"] = {
		Strike = {
			["WOC LR AS 2*R550 Magic 2, 4*Mk82 LD, 2*Fuel Tank, ECM"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "frontline" },
				code_loadout =  { "Caucasus" },
				weaponType = "Bombs",
				expend = "All",
								range = 300000,
				firepower = 1,
				vCruise = 225,
				vAttack = 277.5,
				hCruise = 9100,
				hAttack = 4572,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
						[2] = {
							CLSID = "BARAX_ECM",
						},
						[3] = {
							CLSID = "PTB-1200-F1",
						},
						[4] = {
							CLSID = "{CLB4_MK82}",
						},
						[5] = {
							CLSID = "PTB-1200-F1",
						},
						[7] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
					},
					fuel = 3246,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
			["WOT87 LR AS 2*R550 Magic 2, 1*Mk83 LD, 2*Fuel Tank, ECM"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Structure" },
				code_loadout =  { "WOT87", "IIW", "WOB" },
				weaponType = "Bombs",
				expend = "All",
								range = 600000,
				firepower = 1,
				vCruise = 240,
				vAttack = 260,
				hCruise = 7669,
				hAttack = 4572,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
						[2] = {
							CLSID = "BARAX_ECM",
						},
						[3] = {
							CLSID = "PTB-1200-F1",
						},
						[4] = {
							CLSID = "{7A44FF09-527C-4B7E-B42B-3F111CFE50FB}",
						},
						[5] = {
							CLSID = "PTB-1200-F1",
						},
						[7] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
					},
					fuel = 3246,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
			["Revenge LR AS 2*R550 Magic 2, 4*Mk82 LD, 2*Fuel Tank, ECM"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "Structure" },
				code_loadout =  { "Revenge" },
				weaponType = "Bombs",
				expend = "All",
								range = 200000,
				firepower = 1,
				vCruise = 225,
				vAttack = 277.5,
				hCruise = 9100,
				hAttack = 4572,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
						[2] = {
							CLSID = "BARAX_ECM",
						},
						[3] = {
							CLSID = "PTB-1200-F1",
						},
						[4] = {
							CLSID = "{CLB4_MK82}",
						},
						[5] = {
							CLSID = "PTB-1200-F1",
						},
						[7] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
					},
					fuel = 3246,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
			["IIW LR AS 2*R550 Magic 2, 4*SAMP-400 HD, 2*Fuel Tank, ECM"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "SAM", "Structure" },
				code_loadout =  { "IIW" },
				weaponType = "Bombs",
				expend = "All",
								range = 536000,
				firepower = 1,
				vCruise = 220,
				vAttack = 277.5,
				hCruise = 6968,
				hAttack = 50,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
						[2] = {
							CLSID = "BARAX_ECM",
						},
						[3] = {
							CLSID = "PTB-1200-F1",
						},
						[4] = {
							CLSID = "{CLB4_SAMP400HD}",
						},
						[5] = {
							CLSID = "PTB-1200-F1",
						},
						[7] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
					},
					fuel = 3246,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
			["WOC LR AS 2*R550 Magic 2, 4*SAMP-400 HD, 2*Fuel Tank, ECM"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "frontline" },
				code_loadout =  { "Caucasus", "WOC80", "WOB" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				day = false,
				range = 536000,
				firepower = 1,
				vCruise = 220,
				vAttack = 277.5,
				hCruise = 7030.48,
				hAttack = 50,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
						[2] = {
							CLSID = "BARAX_ECM",
						},
						[3] = {
							CLSID = "PTB-1200-F1",
						},
						[4] = {
							CLSID = "{CLB4_SAMP400HD}",
						},
						[5] = {
							CLSID = "PTB-1200-F1",
						},
						[7] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
					},
					fuel = 3246,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
			["WOT87 IIW LR AS 2*R550 Magic 2, 4*SAMP-400 HD, 2*Fuel Tank, ECM"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "SAM", "Structure" },
				code_loadout =  { "WOT87", "IIW" },
				weaponType = "Bombs",
				expend = "All",
								range = 536000,
				firepower = 1,
				vCruise = 220,
				vAttack = 277.5,
				hCruise = 7030.48,
				hAttack = 50,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
						[2] = {
							CLSID = "BARAX_ECM",
						},
						[3] = {
							CLSID = "PTB-1200-F1",
						},
						[4] = {
							CLSID = "{CLB4_SAMP400HD}",
						},
						[5] = {
							CLSID = "PTB-1200-F1",
						},
						[7] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
					},
					fuel = 3246,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
			["Revenge LR AS 2*R550 Magic 2, 4*SAMP-250 HD, 2*Fuel Tank, ECM"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "Structure" },
				code_loadout =  { "Crisis", "Revenge", "WOC80", "WOT87", "IIW" },
				weaponType = "Bombs",
				expend = "All",
				adverseWeather = true,
				range = 556000,
				firepower = 1,
				vCruise = 230,
				vAttack = 300,
				hCruise = 7274,
				hAttack = 50,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
						[2] = {
							CLSID = "BARAX_ECM",
						},
						[3] = {
							CLSID = "PTB-1200-F1",
						},
						[4] = {
							CLSID = "{CLB4_SAMP250HD}",
						},
						[5] = {
							CLSID = "PTB-1200-F1",
						},
						[7] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
					},
					fuel = 3246,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
			["WOC Caucasus LR AS 2*R550 Magic 2, 4*SAMP-400 HD, 2*Fuel Tank, ECM"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "frontline" },
				code_loadout =  { "Caucasus", "WOC80" },
				weaponType = "Bombs",
				expend = "All",
								range = 536000,
				firepower = 1,
				vCruise = 220,
				vAttack = 277.5,
				hCruise = 7030.48,
				hAttack = 50,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
						[2] = {
							CLSID = "BARAX_ECM",
						},
						[3] = {
							CLSID = "PTB-1200-F1",
						},
						[4] = {
							CLSID = "{CLB4_SAMP400HD}",
						},
						[5] = {
							CLSID = "PTB-1200-F1",
						},
						[7] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
					},
					fuel = 3246,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
			["WOC LR AS 2*R550 Magic 2, 4*SAMP-400 LD, 2*Fuel Tank, ECM"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "frontline" },
				code_loadout =  { "Caucasus", "WOC80", "WOB" },
				weaponType = "Bombs",
				expend = "All",
								range = 541000,
				firepower = 1,
				vCruise = 220,
				vAttack = 277.5,
				hCruise = 7030,
				hAttack = 4572,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
						[2] = {
							CLSID = "BARAX_ECM",
						},
						[3] = {
							CLSID = "PTB-1200-F1",
						},
						[4] = {
							CLSID = "{CLB4_SAMP400LD}",
						},
						[5] = {
							CLSID = "PTB-1200-F1",
						},
						[7] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
					},
					fuel = 3246,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
			["IIW LR AS 2*R550 Magic 2, 72*RKT, 1*Fuel Tank, ECM"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "SAM" },
				code_loadout =  { "IIW" },
				weaponType = "Rockets",
				expend = "All",
								range = 500000,
				firepower = 1,
				vCruise = 240,
				vAttack = 277.5,
				hCruise = 7548,
				hAttack = 50,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
						[2] = {
							CLSID = "BARAX_ECM",
						},
						[3] = {
							CLSID = "{MATRA_F1_SNEBT253}",
						},
						[4] = {
							CLSID = "PTB-1200-F1",
						},
						[5] = {
							CLSID = "{MATRA_F1_SNEBT253}",
						},
						[7] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
					},
					fuel = 3246,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
			["WOT87 LR AS 2*R550 Magic 2, 4*SAMP-400 LD, 2*Fuel Tank, ECM"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Structure" },
				code_loadout =  { "Crisis", "WOT87", "IIW", "WOB" },
				weaponType = "Bombs",
				expend = "All",
								range = 541000,
				firepower = 1,
				vCruise = 220,
				vAttack = 277.5,
				hCruise = 7030,
				hAttack = 4572,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
						[2] = {
							CLSID = "BARAX_ECM",
						},
						[3] = {
							CLSID = "PTB-1200-F1",
						},
						[4] = {
							CLSID = "{CLB4_SAMP400LD}",
						},
						[5] = {
							CLSID = "PTB-1200-F1",
						},
						[7] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
					},
					fuel = 3246,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
			["WOC LR AS 2*R550 Magic 2, 1*Mk83 LD, 2*Fuel Tank, ECM"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "frontline" },
				code_loadout =  { "Caucasus", "WOC80", "WOB" },
				weaponType = "Bombs",
				expend = "All",
								range = 600000,
				firepower = 1,
				vCruise = 240,
				vAttack = 260,
				hCruise = 7669,
				hAttack = 4572,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
						[2] = {
							CLSID = "BARAX_ECM",
						},
						[3] = {
							CLSID = "PTB-1200-F1",
						},
						[4] = {
							CLSID = "{7A44FF09-527C-4B7E-B42B-3F111CFE50FB}",
						},
						[5] = {
							CLSID = "PTB-1200-F1",
						},
						[7] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
					},
					fuel = 3246,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
			["Revenge LR AS 2*R550 Magic 2, 4*SAMP-400 LD, 2*Fuel Tank, ECM"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "Structure" },
				code_loadout =  { "Revenge" },
				weaponType = "Bombs",
				expend = "All",
								range = 541000,
				firepower = 1,
				vCruise = 220,
				vAttack = 277.5,
				hCruise = 7030,
				hAttack = 4572,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
						[2] = {
							CLSID = "BARAX_ECM",
						},
						[3] = {
							CLSID = "PTB-1200-F1",
						},
						[4] = {
							CLSID = "{CLB4_SAMP400LD}",
						},
						[5] = {
							CLSID = "PTB-1200-F1",
						},
						[7] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
					},
					fuel = 3246,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
		},
		["Anti-ship Strike"] = {
			["Revenge LR AS 2*R550 Magic 2, 4*SAMP-400 LD, 2*Fuel Tank, ECM"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "ship" },
				code_loadout =  { "Revenge" },
				weaponType = "Bombs",
				expend = "All",
								range = 541000,
				firepower = 1,
				vCruise = 220,
				vAttack = 277.5,
				hCruise = 7030,
				hAttack = 4572,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
						[2] = {
							CLSID = "BARAX_ECM",
						},
						[3] = {
							CLSID = "PTB-1200-F1",
						},
						[4] = {
							CLSID = "{CLB4_SAMP400LD}",
						},
						[5] = {
							CLSID = "PTB-1200-F1",
						},
						[7] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
					},
					fuel = 3246,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
			["Revenge LR AS 2*R550 Magic 2, 4*Mk82 LD, 2*Fuel Tank, ECM"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "ship" },
				code_loadout =  { "Revenge" },
				weaponType = "Bombs",
				expend = "All",
								range = 200000,
				firepower = 1,
				vCruise = 215,
				vAttack = 277.5,
				hCruise = 7030,
				hAttack = 4572,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
						[2] = {
							CLSID = "BARAX_ECM",
						},
						[3] = {
							CLSID = "PTB-1200-F1",
						},
						[4] = {
							CLSID = "{CLB4_MK82}",
						},
						[5] = {
							CLSID = "PTB-1200-F1",
						},
						[7] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
					},
					fuel = 3246,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
			["Revenge LR AS 2*R550 Magic 2, 6*SAMP-400 HD, 2*Fuel Tank, ECM"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "ship" },
				code_loadout =  { "Revenge", "IIW" },
				weaponType = "Bombs",
				expend = "All",
				adverseWeather = true,
				range = 553000,
				firepower = 1,
				vCruise = 230,
				vAttack = 300,
				hCruise = 6938,
				hAttack = 50,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
						[2] = {
							CLSID = "BARAX_ECM",
						},
						[3] = {
							CLSID = "PTB-1200-F1",
						},
						[4] = {
							CLSID = "{CLB4_SAMP250HD}",
						},
						[5] = {
							CLSID = "PTB-1200-F1",
						},
						[7] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
					},
					fuel = 3246,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
		},
		Escort = {
			["Revenge LR AA 2*R550 Magic 2, 2*S530F, 1*FT 2310 L, ECM"] = {
				attributes =  { },
				code_loadout =  { "Crisis", "Revenge", "WOC80", "WOT87", "IIW", "WOB" },
				night = true,
				adverseWeather = true,
				range = 598000,
				firepower = 1,
				vCruise = 245,
				standoff = 27000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
						[2] = {
							CLSID = "BARAX_ECM",
						},
						[3] = {
							CLSID = "{S530F}",
						},
						[4] = {
							["CLSID"] = "PTB-580G-F1",
						},
						[5] = {
							CLSID = "{S530F}",
						},
						[7] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
					},
					fuel = 3246,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
		},
		CAP = {
			["Revenge LR AA 2*R550 Magic 2, 2*S530F, 1*FT 2310 L, ECM"] = {
				attributes =  { },
				code_loadout =  { "Revenge", "WOT87", "IIW" },
				adverseWeather = true,
				range = 513000,
				firepower = 1,
				vCruise = 245,
				vAttack = 250,
				hCruise = 7548,
				hAttack = 7548,
				standoff = 36000,
				tStation = 3600,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
						[2] = {
							CLSID = "BARAX_ECM",
						},
						[3] = {
							CLSID = "{S530F}",
						},
						[4] = {
							["CLSID"] = "PTB-580G-F1",
						},
						[5] = {
							CLSID = "{S530F}",
						},
						[7] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
					},
					fuel = 3246,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
			["WOC80 LR AA 2*R550 Magic 2, 2*S530F, 1*FT 2310 L, ECM"] = {
				attributes =  { "Air Forces" },
				code_loadout =  { "Crisis", "WOC80", "WOB" },
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 245,
				vAttack = 250,
				hCruise = 7548,
				hAttack = 7548,
				standoff = 36000,
				tStation = 1800,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
						[2] = {
							CLSID = "BARAX_ECM",
						},
						[3] = {
							CLSID = "{S530F}",
						},
						[4] = {
							["CLSID"] = "PTB-580G-F1",
						},
						[5] = {
							CLSID = "{S530F}",
						},
						[7] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
					},
					fuel = 3246,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
		},
		["Runway Attack"] = {
			["Runway attack - Durandal*4, Magic 2*2, FT*2, ECM "] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Runway" },
				code_loadout =  { "All" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 575000,
				firepower = 1,
				vCruise = 215,
				vAttack = 277.5,
				hCruise = 7548,
				hAttack = 100,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
						[2] = {
							CLSID = "BARAX_ECM",
						},
						[3] = {
							CLSID = "PTB-1200-F1",
						},
						[4] = {
							CLSID = "{CLB4_BLU107}",
						},
						[5] = {
							CLSID = "PTB-1200-F1",
						},
						[7] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
					},
					fuel = 3246,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
		},
		["Fighter Sweep"] = {
			["Revenge LR AA 2*R550 Magic 2, 2*S530F, 1*FT 2310 L, ECM"] = {
				attributes =  { },
				code_loadout =  { "Crisis", "Revenge", "WOC80", "WOT87", "IIW", "WOB" },
				night = true,
				adverseWeather = true,
				range = 601000,
				firepower = 1,
				vCruise = 230,
				vAttack = 265,
				hCruise = 7548,
				hAttack = 7548,
				standoff = 27000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
						[2] = {
							CLSID = "BARAX_ECM",
						},
						[3] = {
							CLSID = "{S530F}",
						},
						[4] = {
							["CLSID"] = "PTB-580G-F1",
						},
						[5] = {
							CLSID = "{S530F}",
						},
						[7] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
					},
					fuel = 3246,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
		},
		Intercept = {
			["WOC80 80s - AA - SR - 2xMagic2 - 2xS530F - FT - ECM"] = {
				attributes =  { },
				code_loadout =  { "Crisis", "WOC80", "WOT87", "IIW", "WOB" },
				adverseWeather = true,
				range = 400000,
				firepower = 1,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
						[2] = {
							CLSID = "BARAX_ECM",
						},
						[3] = {
							CLSID = "{S530F}",
						},
						[4] = {
							CLSID = "PTB-1200-F1",
						},
						[5] = {
							CLSID = "{S530F}",
						},
						[7] = {
							CLSID = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
						},
					},
					fuel = 3246,
					flare = 15,
					chaff = 30,
					gun = 100,
				},
			},
		},
	},
	["MiG-23MLD"] = {
		Strike = {
			["Strike FAB500*2, R-60*4, FT"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "Structure" },
				code_loadout =  { "IIW", "WOT87", "WOB" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
								range = 410000,
				firepower = 1,
				vCruise = 190,
				vAttack = 280,
				hCruise = 6000,
				hAttack = 4000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[2] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
						[3] = {
							CLSID = "{B0DBC591-0F52-4F7D-AD7B-51E67725FB81}",
						},
						[4] = {
							CLSID = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
						},
						[5] = {
							CLSID = "{275A2855-4A79-4B2D-B082-91EA2ADF4691}",
						},
						[6] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
					},
					fuel = "3800",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike FAB500*4, FT"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "Structure" },
				code_loadout =  { "IIW" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
								range = 398000,
				firepower = 1,
				vCruise = 185,
				vAttack = 280,
				hCruise = 6000,
				hAttack = 4000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[2] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
						[3] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
						[4] = {
							CLSID = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
						},
						[5] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
						[6] = {
							CLSID = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
						},
					},
					fuel = "3800",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
		},
		["Fighter Sweep"] = {
			["Fighter Sweep R-24R*2, R-60M*4, Fuel"] = {
				attributes =  { },
				code_loadout =  { "IIW", "TF80s", "TF80sRED", "TF80sI", "WOC80", "WOT87", "WOB" },
				night = true,
				adverseWeather = true,
				range = 420000,
				firepower = 1,
				vCruise = 190,
				vAttack = 250,
				hCruise = 6328,
				hAttack = 6328,
				standoff = 40000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[2] = {
							CLSID = "{CCF898C9-5BC7-49A4-9D1E-C3ED3D5166A1}",
						},
						[3] = {
							CLSID = "{B0DBC591-0F52-4F7D-AD7B-51E67725FB81}",
						},
						[4] = {
							CLSID = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
						},
						[5] = {
							CLSID = "{275A2855-4A79-4B2D-B082-91EA2ADF4691}",
						},
						[6] = {
							CLSID = "{CCF898C9-5BC7-49A4-9D1E-C3ED3D5166A1}",
						},
					},
					fuel = "3800",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Fighter Sweep  R-24R*1, R-24T*1, R-60M*4, Fuel"] = {
				attributes =  { },
				code_loadout =  { "IIW", "TF80s", "TF80sRED", "TF80sI", "WOC80", "WOB" },
				night = true,
				adverseWeather = true,
				range = 420000,
				firepower = 1,
				vCruise = 190,
				vAttack = 250,
				hCruise = 6328,
				hAttack = 6328,
				standoff = 40000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[2] = {
							CLSID = "{6980735A-44CC-4BB9-A1B5-591532F1DC69}",
						},
						[3] = {
							CLSID = "{B0DBC591-0F52-4F7D-AD7B-51E67725FB81}",
						},
						[4] = {
							CLSID = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
						},
						[5] = {
							CLSID = "{275A2855-4A79-4B2D-B082-91EA2ADF4691}",
						},
						[6] = {
							CLSID = "{CCF898C9-5BC7-49A4-9D1E-C3ED3D5166A1}",
						},
					},
					fuel = "3800",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
		},
		Escort = {
			["Escort R-24R*2, R-60M*2, Fuel"] = {
				attributes =  { },
				code_loadout =  { "IIW", "TF80s", "TF80sRED", "TF80sI", "WOC80", "WOT87", "WOB" },
				night = true,
				adverseWeather = true,
				range = 460000,
				firepower = 1,
				vCruise = 183,
				standoff = 40000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[2] = {
							CLSID = "{CCF898C9-5BC7-49A4-9D1E-C3ED3D5166A1}",
						},
						[3] = {
							-- CLSID = "{B0DBC591-0F52-4F7D-AD7B-51E67725FB81}",
							["CLSID"] = "{APU-60-1_R_60M}",
						},
						[4] = {
							CLSID = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
						},
						[5] = {
							-- CLSID = "{275A2855-4A79-4B2D-B082-91EA2ADF4691}",
							["CLSID"] = "{APU-60-1_R_60M}",
						},
						[6] = {
							CLSID = "{CCF898C9-5BC7-49A4-9D1E-C3ED3D5166A1}",
						},
					},
					fuel = "3800",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Escort R-24R*1, R-24T*1, R-60M*4, Fuel"] = {
				attributes =  { },
				code_loadout =  { "IIW", "TF80s", "TF80sRED", "TF80sI", "WOC80", "WOB" },
				night = true,
				adverseWeather = true,
				range = 460000,
				firepower = 1,
				vCruise = 183,
				standoff = 40000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[2] = {
							CLSID = "{6980735A-44CC-4BB9-A1B5-591532F1DC69}",
						},
						[3] = {
							CLSID = "{B0DBC591-0F52-4F7D-AD7B-51E67725FB81}",
						},
						[4] = {
							CLSID = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
						},
						[5] = {
							CLSID = "{275A2855-4A79-4B2D-B082-91EA2ADF4691}",
						},
						[6] = {
							CLSID = "{CCF898C9-5BC7-49A4-9D1E-C3ED3D5166A1}",
						},
					},
					fuel = "3800",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
		},
		CAP = {
			["CAP R-24R*1, R-24T*1, R-60M*4, Fuel"] = {
				attributes =  { },
				code_loadout =  { "IIW", "TF80s", "TF80sRED", "TF80sI", "WOC80", "WOB" },
				night = true,
				adverseWeather = true,
				range = 420000,
				firepower = 1,
				vCruise = 190,
				vAttack = 250,
				hCruise = 6328,
				hAttack = 6328,
				standoff = 40000,
				tStation = 3600,
				sortie_rate = 6,
				stores = {
					pylons = {
						[2] = {
							CLSID = "{6980735A-44CC-4BB9-A1B5-591532F1DC69}",
						},
						[3] = {
							CLSID = "{B0DBC591-0F52-4F7D-AD7B-51E67725FB81}",
						},
						[4] = {
							CLSID = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
						},
						[5] = {
							CLSID = "{275A2855-4A79-4B2D-B082-91EA2ADF4691}",
						},
						[6] = {
							CLSID = "{CCF898C9-5BC7-49A4-9D1E-C3ED3D5166A1}",
						},
					},
					fuel = "3800",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["CAP R-24R*2, R-60M*4, Fuel"] = {
				attributes =  { },
				code_loadout =  { "IIW", "TF80s", "TF80sRED", "TF80sI", "WOC80", "WOT87", "WOB" },
				night = true,
				adverseWeather = true,
				range = 420000,
				firepower = 1,
				vCruise = 190,
				vAttack = 250,
				hCruise = 6328,
				hAttack = 6328,
				standoff = 40000,
				tStation = 3600,
				sortie_rate = 6,
				stores = {
					pylons = {
						[2] = {
							CLSID = "{CCF898C9-5BC7-49A4-9D1E-C3ED3D5166A1}",
						},
						[3] = {
							CLSID = "{B0DBC591-0F52-4F7D-AD7B-51E67725FB81}",
						},
						[4] = {
							CLSID = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
						},
						[5] = {
							CLSID = "{275A2855-4A79-4B2D-B082-91EA2ADF4691}",
						},
						[6] = {
							CLSID = "{CCF898C9-5BC7-49A4-9D1E-C3ED3D5166A1}",
						},
					},
					fuel = "3800",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
		},
		["Runway Attack"] = {
			["Runway attack High - R-60x4 - FAB-100x8 - FT"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Runway" },
				code_loadout =  { "TF", "Caucasus", "WOB", "IIW" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 9100,
				hAttack = 200,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[2] = {
							CLSID = "{5A1AC2B4-CA4B-4D09-A1AF-AC52FBC4B60B}",
						},
						[3] = {
							CLSID = "{B0DBC591-0F52-4F7D-AD7B-51E67725FB81}",
						},
						[4] = {
							CLSID = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
						},
						[5] = {
							CLSID = "{275A2855-4A79-4B2D-B082-91EA2ADF4691}",
						},
						[6] = {
							CLSID = "{5A1AC2B4-CA4B-4D09-A1AF-AC52FBC4B60B}",
						},
					},
					fuel = 3800,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
		},
		Intercept = {
			["Intercept R-24R*1, R-24T*1, R-60M*4, Fuel"] = {
				attributes =  { },
				code_loadout =  { "IIW", "TF80s", "TF80sRED", "TF80sI", "WOC80", "WOB" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				sortie_rate = 6,
				stores = {
					pylons = {
						[2] = {
							CLSID = "{6980735A-44CC-4BB9-A1B5-591532F1DC69}",
						},
						[3] = {
							CLSID = "{B0DBC591-0F52-4F7D-AD7B-51E67725FB81}",
						},
						[4] = {
							CLSID = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
						},
						[5] = {
							CLSID = "{275A2855-4A79-4B2D-B082-91EA2ADF4691}",
						},
						[6] = {
							CLSID = "{CCF898C9-5BC7-49A4-9D1E-C3ED3D5166A1}",
						},
					},
					fuel = "3800",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Intercept R-24R*2, R-60M*4, Fuel"] = {
				attributes =  { },
				code_loadout =  { "IIW", "TF80s", "TF80sRED", "TF80sI", "WOC80", "WOT87", "WOB" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				sortie_rate = 6,
				stores = {
					pylons = {
						[2] = {
							CLSID = "{CCF898C9-5BC7-49A4-9D1E-C3ED3D5166A1}",
						},
						[3] = {
							CLSID = "{B0DBC591-0F52-4F7D-AD7B-51E67725FB81}",
						},
						[4] = {
							CLSID = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
						},
						[5] = {
							CLSID = "{275A2855-4A79-4B2D-B082-91EA2ADF4691}",
						},
						[6] = {
							CLSID = "{CCF898C9-5BC7-49A4-9D1E-C3ED3D5166A1}",
						},
					},
					fuel = "3800",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
		},
	},
	["Su-27"] = {
		CAP = {
			["CAP R-73*2,R-27ER*4,R-27ET*2,ECM"] = {
				attributes =  { },
				code_loadout =  { "TF", "Caucasus" },
				night = true,
				adverseWeather = true,
				range = 600000,
				firepower = 1,
				vCruise = 213.222,
				vAttack = 213.555,
				hCruise = 8500,
				hAttack = 8500,
				standoff = 70000,
				tStation = 3700,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{44EE8698-89F9-48EE-AF36-5FD31896A82F}",
						},
						[2] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[3] = {
							CLSID = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}",
						},
						[4] = {
							CLSID = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						},
						[5] = {
							CLSID = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						},
						[6] = {
							CLSID = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						},
						[7] = {
							CLSID = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						},
						[8] = {
							CLSID = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}",
						},
						[9] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[10] = {
							CLSID = "{44EE8698-89F9-48EE-AF36-5FD31896A82A}",
						},
					},
					fuel = 5590.18,
					flare = 96,
					chaff = 96,
					gun = 100,
				},
			},
		},
		["Fighter Sweep"] = {
			["Sweep R-73*2,R-27ER*4,R-27ET*2,ECM"] = {
				attributes =  { },
				code_loadout =  { "TF", "Caucasus" },
				night = true,
				adverseWeather = true,
				range = 800000,
				firepower = 1,
				vCruise = 260.222,
				vAttack = 300.555,
				hCruise = 8500,
				hAttack = 8500,
				standoff = 70000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{44EE8698-89F9-48EE-AF36-5FD31896A82F}",
						},
						[2] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[3] = {
							CLSID = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}",
						},
						[4] = {
							CLSID = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						},
						[5] = {
							CLSID = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						},
						[6] = {
							CLSID = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						},
						[7] = {
							CLSID = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						},
						[8] = {
							CLSID = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}",
						},
						[9] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[10] = {
							CLSID = "{44EE8698-89F9-48EE-AF36-5FD31896A82A}",
						},
					},
					fuel = 5590.18,
					flare = 96,
					chaff = 96,
					gun = 100,
				},
			},
		},
		Escort = {
			["Escort R-73*2,R-27ER*4,R-27ET*2,ECM"] = {
				attributes =  { },
				code_loadout =  { "TF", "Caucasus" },
				night = true,
				adverseWeather = true,
				range = 800000,
				firepower = 1,
				vCruise = 260.222,
				vAttack = 300.555,
				hCruise = 8500,
				hAttack = 8500,
				standoff = 70000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{44EE8698-89F9-48EE-AF36-5FD31896A82F}",
						},
						[2] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[3] = {
							CLSID = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}",
						},
						[4] = {
							CLSID = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						},
						[5] = {
							CLSID = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						},
						[6] = {
							CLSID = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						},
						[7] = {
							CLSID = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						},
						[8] = {
							CLSID = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}",
						},
						[9] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[10] = {
							CLSID = "{44EE8698-89F9-48EE-AF36-5FD31896A82A}",
						},
					},
					fuel = 5590.18,
					flare = 96,
					chaff = 96,
					gun = 100,
				},
			},
		},
		Intercept = {
			["Intercept R-73*2,R-27ER*4,R-27ET*2,ECM"] = {
				attributes =  { },
				code_loadout =  { "TF", "Caucasus" },
				night = true,
				adverseWeather = true,
				range = 800000,
				firepower = 1,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{44EE8698-89F9-48EE-AF36-5FD31896A82F}",
						},
						[2] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[3] = {
							CLSID = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}",
						},
						[4] = {
							CLSID = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						},
						[5] = {
							CLSID = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						},
						[6] = {
							CLSID = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						},
						[7] = {
							CLSID = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						},
						[8] = {
							CLSID = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}",
						},
						[9] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[10] = {
							CLSID = "{44EE8698-89F9-48EE-AF36-5FD31896A82A}",
						},
					},
					fuel = 5590.18,
					flare = 96,
					chaff = 96,
					gun = 100,
				},
			},
		},
	},
	["Su-33"] = {
		CAP = {
			["Su-33 CV CAP R-73*2,R-27ER*4,R-27ET*2,ECM"] = {
				attributes =  { },
				code_loadout =  { "TF", "Caucasus" },
				night = true,
				adverseWeather = true,
				range = 600000,
				firepower = 1,
				vCruise = 213.222,
				vAttack = 213.555,
				hCruise = 8500,
				hAttack = 8500,
				standoff = 70000,
				tStation = 3700,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = 
						{
							["CLSID"] = "{44EE8698-89F9-48EE-AF36-5FD31896A82F}",
						}, -- end of [1]
						[2] = 
						{
							["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						}, -- end of [2]
						[3] = 
						{
							["CLSID"] = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}",
						}, -- end of [3]
						[4] = 
						{
							["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						}, -- end of [4]
						[5] = 
						{
							["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						}, -- end of [5]
						[6] = 
						{
							["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						}, -- end of [6]
						[7] = 
						{
							["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						}, -- end of [7]
						[8] = 
						{
							["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						}, -- end of [8]
						[9] = 
						{
							["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						}, -- end of [9]
						[10] = 
						{
							["CLSID"] = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}",
						}, -- end of [10]
						[11] = 
						{
							["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						}, -- end of [11]
						[12] = 
						{
							["CLSID"] = "{44EE8698-89F9-48EE-AF36-5FD31896A82A}",
						}, -- end of [12]
					},
					["fuel"] = 4750,
					["flare"] = 48,
					["chaff"] = 48,
					["gun"] = 100,
				},
			},
		},
		["Fighter Sweep"] = {
			["Su-33 CV Sweep R-73*2,R-27ER*4,R-27ET*2,ECM"] = {
				attributes =  { },
				code_loadout =  { "TF", "Caucasus" },
				night = true,
				adverseWeather = true,
				range = 800000,
				firepower = 1,
				vCruise = 260.222,
				vAttack = 300.555,
				hCruise = 8500,
				hAttack = 8500,
				standoff = 70000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = 
						{
						["CLSID"] = "{44EE8698-89F9-48EE-AF36-5FD31896A82F}",
						}, -- end of [1]
						[2] = 
						{
						["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						}, -- end of [2]
						[3] = 
						{
						["CLSID"] = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}",
						}, -- end of [3]
						[4] = 
						{
						["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						}, -- end of [4]
						[5] = 
						{
						["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						}, -- end of [5]
						[6] = 
						{
						["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						}, -- end of [6]
						[7] = 
						{
						["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						}, -- end of [7]
						[8] = 
						{
						["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						}, -- end of [8]
						[9] = 
						{
						["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						}, -- end of [9]
						[10] = 
						{
						["CLSID"] = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}",
						}, -- end of [10]
						[11] = 
						{
						["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						}, -- end of [11]
						[12] = 
						{
						["CLSID"] = "{44EE8698-89F9-48EE-AF36-5FD31896A82A}",
						}, -- end of [12]
					},
					fuel = 5590.18,
					flare = 96,
					chaff = 96,
					gun = 100,
				},
			},
		},
		Escort = {
			["Su-33 CV Escort R-73*2,R-27ER*4,R-27ET*2,ECM"] = {
				attributes =  { },
				code_loadout =  { "TF", "Caucasus" },
				night = true,
				adverseWeather = true,
				range = 800000,
				firepower = 1,
				vCruise = 260.222,
				vAttack = 300.555,
				hCruise = 8500,
				hAttack = 8500,
				standoff = 70000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = 
						{
						["CLSID"] = "{44EE8698-89F9-48EE-AF36-5FD31896A82F}",
						}, -- end of [1]
						[2] = 
						{
						["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						}, -- end of [2]
						[3] = 
						{
						["CLSID"] = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}",
						}, -- end of [3]
						[4] = 
						{
						["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						}, -- end of [4]
						[5] = 
						{
						["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						}, -- end of [5]
						[6] = 
						{
						["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						}, -- end of [6]
						[7] = 
						{
						["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						}, -- end of [7]
						[8] = 
						{
						["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						}, -- end of [8]
						[9] = 
						{
						["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						}, -- end of [9]
						[10] = 
						{
						["CLSID"] = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}",
						}, -- end of [10]
						[11] = 
						{
						["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						}, -- end of [11]
						[12] = 
						{
						["CLSID"] = "{44EE8698-89F9-48EE-AF36-5FD31896A82A}",
						}, -- end of [12]
					},
					fuel = 5590.18,
					flare = 96,
					chaff = 96,
					gun = 100,
				},
			},
		},
		Intercept = {
			["Su-33 CV Intercept R-73*2,R-27ER*4,R-27ET*2,ECM"] = {
				attributes =  { },
				code_loadout =  { "TF", "Caucasus" },
				night = true,
				adverseWeather = true,
				range = 800000,
				firepower = 1,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = 
						{
						["CLSID"] = "{44EE8698-89F9-48EE-AF36-5FD31896A82F}",
						}, -- end of [1]
						[2] = 
						{
						["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						}, -- end of [2]
						[3] = 
						{
						["CLSID"] = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}",
						}, -- end of [3]
						[4] = 
						{
						["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						}, -- end of [4]
						[5] = 
						{
						["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						}, -- end of [5]
						[6] = 
						{
						["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						}, -- end of [6]
						[7] = 
						{
						["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						}, -- end of [7]
						[8] = 
						{
						["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						}, -- end of [8]
						[9] = 
						{
						["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						}, -- end of [9]
						[10] = 
						{
						["CLSID"] = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}",
						}, -- end of [10]
						[11] = 
						{
						["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						}, -- end of [11]
						[12] = 
						{
						["CLSID"] = "{44EE8698-89F9-48EE-AF36-5FD31896A82A}",
						}, -- end of [12]
					},
					fuel = 5590.18,
					flare = 96,
					chaff = 96,
					gun = 100,
				},
			},
		},
	},
	["MiG-29S"] = {
		CAP = {
			["WOB AA - R77x2 - R-27ETx2 - R-73x2 - FT"] = {
				attributes =  { },
				code_loadout =  { "WOB" },
				night = true,
				adverseWeather = true,
				range = 400000,
				firepower = 4,
				vCruise = 213,
				vAttack = 213,
				hCruise = 7011,
				hAttack = 7011,
				standoff = 50000,
				tStation = 1800,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[2] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[3] = {
							CLSID = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}",
						},
						[4] = {
							CLSID = "{2BEC576B-CDF5-4B7F-961F-B0FA4312B841}",
						},
						[5] = {
							CLSID = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}",
						},
						[6] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[7] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
					},
					fuel = "3493",
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
			["CAP WOB AA - R77x4 - R-73x2 - FT"] = {
				attributes =  { },
				code_loadout =  { "WOB" },
				night = true,
				adverseWeather = true,
				range = 400000,
				firepower = 4,
				vCruise = 213,
				vAttack = 213,
				hCruise = 7011,
				hAttack = 7011,
				tStation = 1800,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[2] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[3] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[4] = {
							CLSID = "{2BEC576B-CDF5-4B7F-961F-B0FA4312B841}",
						},
						[5] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[6] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[7] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
					},
					fuel = "3493",
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
		},
		["Fighter Sweep"] = {
			["WOB AA - R77x2 - R-27ETx2 - R-73x2 - FT"] = {
				attributes =  { },
				code_loadout =  { "WOB" },
				night = true,
				adverseWeather = true,
				range = 600000,
				firepower = 4,
				vCruise = 255.83333333333,
				vAttack = 265.83333333333,
				hCruise = 7011,
				hAttack = 7011,
				standoff = 50000,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[2] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[3] = {
							CLSID = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}",
						},
						[4] = {
							CLSID = "{2BEC576B-CDF5-4B7F-961F-B0FA4312B841}",
						},
						[5] = {
							CLSID = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}",
						},
						[6] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[7] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
					},
					fuel = "3493",
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
			["Fighter Sweep WOB AA - R77x4 - R-73x2 - FT"] = {
				attributes =  { },
				code_loadout =  { "WOB" },
				night = true,
				adverseWeather = true,
				range = 600000,
				firepower = 4,
				vCruise = 260.83333333333,
				vAttack = 315.83333333333,
				hCruise = 7011,
				hAttack = 7011,
				standoff = 50000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[2] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[3] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[4] = {
							CLSID = "{2BEC576B-CDF5-4B7F-961F-B0FA4312B841}",
						},
						[5] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[6] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[7] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
					},
					fuel = "3493",
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
		},
		Escort = {
			["WOB AA - R77x2 - R-27ETx2 - R-73x2 - FT"] = {
				attributes =  { },
				code_loadout =  { "WOB" },
				night = true,
				adverseWeather = true,
				range = 700000,
				firepower = 4,
				vCruise = 255.83333333333,
				standoff = 50000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[2] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[3] = {
							CLSID = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}",
						},
						[4] = {
							CLSID = "{2BEC576B-CDF5-4B7F-961F-B0FA4312B841}",
						},
						[5] = {
							CLSID = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}",
						},
						[6] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[7] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
					},
					fuel = "3493",
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
			["Escort  WOB AA - R77x4 - R-73x2 - FT"] = {
				attributes =  { },
				code_loadout =  { "WOB" },
				night = true,
				adverseWeather = true,
				range = 700000,
				firepower = 4,
				vCruise = 260.83333333333,
				standoff = 50000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[2] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[3] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[4] = {
							CLSID = "{2BEC576B-CDF5-4B7F-961F-B0FA4312B841}",
						},
						[5] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[6] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[7] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
					},
					fuel = "3493",
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
		},
		Intercept = {
			["WOB AA - R77x2 - R-27ETx2 - R-73x2 - FT"] = {
				attributes =  { },
				code_loadout =  { "WOB" },
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 4,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[2] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[3] = {
							CLSID = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}",
						},
						[4] = {
							CLSID = "{2BEC576B-CDF5-4B7F-961F-B0FA4312B841}",
						},
						[5] = {
							CLSID = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}",
						},
						[6] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[7] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
					},
					fuel = "3493",
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
			["Intercept WOB AA - R77x4 - R-73x2 - FT"] = {
				attributes =  { },
				code_loadout =  { "WOB" },
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 4,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[2] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[3] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[4] = {
							CLSID = "{2BEC576B-CDF5-4B7F-961F-B0FA4312B841}",
						},
						[5] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[6] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[7] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
					},
					fuel = "3493",
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
		},
	},
	["MiG-31"] = {
		CAP = {
			["CAP R-60M*4,R-33*4"] = {
				attributes =  { "Mig-31" },
				code_loadout =  { "TF", "Caucasus" },
				night = true,
				adverseWeather = true,
				range = 600000,
				firepower = 1,
				vCruise = 220,
				vAttack = 220.555,
				hCruise = 10500,
				hAttack = 10000,
				standoff = 100000,
				tStation = 3700,
				LDSD = true,
				sortie_rate = 12,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{B0DBC591-0F52-4F7D-AD7B-51E67725FB81}",
						},
						[2] = {
							CLSID = "{F1243568-8EF0-49D4-9CB5-4DA90D92BC1D}",
						},
						[3] = {
							CLSID = "{F1243568-8EF0-49D4-9CB5-4DA90D92BC1D}",
						},
						[4] = {
							CLSID = "{F1243568-8EF0-49D4-9CB5-4DA90D92BC1D}",
						},
						[5] = {
							CLSID = "{F1243568-8EF0-49D4-9CB5-4DA90D92BC1D}",
						},
						[6] = {
							CLSID = "{275A2855-4A79-4B2D-B082-91EA2ADF4691}",
						},
					},
					fuel = 15500,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		["Fighter Sweep"] = {
			["Fighter Sweep R-60M*4,R-33*4"] = {
				attributes =  { },
				code_loadout =  { "TF", "Caucasus" },
				night = true,
				adverseWeather = true,
				range = 800000,
				firepower = 1,
				vCruise = 300,
				vAttack = 500.555,
				hCruise = 10500,
				hAttack = 10000,
				standoff = 100000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{B0DBC591-0F52-4F7D-AD7B-51E67725FB81}",
						},
						[2] = {
							CLSID = "{F1243568-8EF0-49D4-9CB5-4DA90D92BC1D}",
						},
						[3] = {
							CLSID = "{F1243568-8EF0-49D4-9CB5-4DA90D92BC1D}",
						},
						[4] = {
							CLSID = "{F1243568-8EF0-49D4-9CB5-4DA90D92BC1D}",
						},
						[5] = {
							CLSID = "{F1243568-8EF0-49D4-9CB5-4DA90D92BC1D}",
						},
						[6] = {
							CLSID = "{275A2855-4A79-4B2D-B082-91EA2ADF4691}",
						},
					},
					fuel = 15500,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		Escort = {
			["Escort R-60M*4,R-33*4"] = {
				attributes =  { },
				code_loadout =  { "TF", "Caucasus" },
				night = true,
				adverseWeather = true,
				range = 800000,
				firepower = 1,
				vCruise = 300,
				vAttack = 500.555,
				hCruise = 10500,
				hAttack = 10000,
				standoff = 100000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{B0DBC591-0F52-4F7D-AD7B-51E67725FB81}",
						},
						[2] = {
							CLSID = "{F1243568-8EF0-49D4-9CB5-4DA90D92BC1D}",
						},
						[3] = {
							CLSID = "{F1243568-8EF0-49D4-9CB5-4DA90D92BC1D}",
						},
						[4] = {
							CLSID = "{F1243568-8EF0-49D4-9CB5-4DA90D92BC1D}",
						},
						[5] = {
							CLSID = "{F1243568-8EF0-49D4-9CB5-4DA90D92BC1D}",
						},
						[6] = {
							CLSID = "{275A2855-4A79-4B2D-B082-91EA2ADF4691}",
						},
					},
					fuel = 15500,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		Intercept = {
			["Intercept  R-60M*4,R-33*4"] = {
				attributes =  { },
				code_loadout =  { "TF", "Caucasus" },
				night = true,
				adverseWeather = true,
				range = 1000000,
				firepower = 1,
				LDSD = true,
				sortie_rate = 8,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{B0DBC591-0F52-4F7D-AD7B-51E67725FB81}",
						},
						[2] = {
							CLSID = "{F1243568-8EF0-49D4-9CB5-4DA90D92BC1D}",
						},
						[3] = {
							CLSID = "{F1243568-8EF0-49D4-9CB5-4DA90D92BC1D}",
						},
						[4] = {
							CLSID = "{F1243568-8EF0-49D4-9CB5-4DA90D92BC1D}",
						},
						[5] = {
							CLSID = "{F1243568-8EF0-49D4-9CB5-4DA90D92BC1D}",
						},
						[6] = {
							CLSID = "{275A2855-4A79-4B2D-B082-91EA2ADF4691}",
						},
					},
					fuel = 15500,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
	},
	["KC135MPRS"] = {
		Refueling = {
			Default = {
				attributes =  { "KC135MPRS" },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 1500000,
				firepower = 1,
				vCruise = 185,
				vAttack = 185,
				hCruise = 7345,
				hAttack = 7345,
				tStation = 21600,
				sortie_rate = 3,
				stores = {
					pylons = {
					},
					fuel = 90700,
					flare = 60,
					chaff = 120,
					gun = 100,
				},
			},
		},
	},
	["Su-30"] = {
		Strike = {
			["WOB - AG - R-73*2,Kh-29T*4,R-77*2,ECM"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Structure" },
				code_loadout =  { "WOB" },
				weaponType = "ASM",
				expend = "Auto",
				night = true,
				range = 900000,
				firepower = 1,
				vCruise = 250,
				vAttack = 300,
				hCruise = 7096,
				hAttack = 7096,
				standoff = 12000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{44EE8698-89F9-48EE-AF36-5FD31896A82F}",
						},
						[2] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[3] = {
							CLSID = "{B4FC81C9-B861-4E87-BBDC-A1158E648EBF}",
						},
						[4] = {
							CLSID = "{B4FC81C9-B861-4E87-BBDC-A1158E648EBF}",
						},
						[5] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[6] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[7] = {
							CLSID = "{B4FC81C9-B861-4E87-BBDC-A1158E648EBF}",
						},
						[8] = {
							CLSID = "{B4FC81C9-B861-4E87-BBDC-A1158E648EBF}",
						},
						[9] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[10] = {
							CLSID = "{44EE8698-89F9-48EE-AF36-5FD31896A82A}",
						},
					},
					fuel = "9400",
					flare = 96,
					chaff = 96,
					gun = 100,
				},
			},
			["WOB - AG - R-73*2,Kh-59M*2,R-27ER*2,R-77*2,ECM"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Structure", "SAM" },
				code_loadout =  { "WOB" },
				weaponType = "ASM",
				expend = "Auto",
				night = true,
				range = 900000,
				firepower = 1,
				vCruise = 250,
				vAttack = 300,
				hCruise = 7096,
				hAttack = 7096,
				standoff = 50000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{44EE8698-89F9-48EE-AF36-5FD31896A82F}",
						},
						[2] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[3] = {
							CLSID = "{40AB87E8-BEFB-4D85-90D9-B2753ACF9514}",
						},
						[4] = {
							CLSID = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						},
						[5] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[6] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[7] = {
							CLSID = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						},
						[8] = {
							CLSID = "{40AB87E8-BEFB-4D85-90D9-B2753ACF9514}",
						},
						[9] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[10] = {
							CLSID = "{44EE8698-89F9-48EE-AF36-5FD31896A82A}",
						},
					},
					fuel = "9400",
					flare = 96,
					chaff = 96,
					gun = 100,
				},
			},
		},
		["Fighter Sweep"] = {
			["Sweep WOB - AA - R-73*2,R-27ET*2,R-77*2,R-27ER*2,ECM"] = {
				attributes =  { },
				code_loadout =  { "WOB" },
				night = true,
				adverseWeather = true,
				range = 800000,
				firepower = 5,
				vCruise = 260.222,
				vAttack = 300.555,
				hCruise = 8500,
				hAttack = 8500,
				standoff = 60000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{44EE8698-89F9-48EE-AF36-5FD31896A82F}",
						},
						[2] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[3] = {
							CLSID = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}",
						},
						[4] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[5] = {
							CLSID = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						},
						[6] = {
							CLSID = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						},
						[7] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[8] = {
							CLSID = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}",
						},
						[9] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[10] = {
							CLSID = "{44EE8698-89F9-48EE-AF36-5FD31896A82A}",
						},
					},
					fuel = "9400",
					flare = 96,
					chaff = 96,
					gun = 100,
				},
			},
			["Sweep WOB - AA - R-73*2,R-27ET*2,R-77*4,ECM"] = {
				attributes =  { },
				code_loadout =  { "WOB" },
				night = true,
				adverseWeather = true,
				range = 800000,
				firepower = 6,
				vCruise = 260.222,
				vAttack = 300.555,
				hCruise = 8500,
				hAttack = 8500,
				standoff = 50000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{44EE8698-89F9-48EE-AF36-5FD31896A82F}",
						},
						[2] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[3] = {
							CLSID = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}",
						},
						[4] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[5] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[6] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[7] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[8] = {
							CLSID = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}",
						},
						[9] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[10] = {
							CLSID = "{44EE8698-89F9-48EE-AF36-5FD31896A82A}",
						},
					},
					fuel = "9400",
					flare = 96,
					chaff = 96,
					gun = 100,
				},
			},
		},
		Escort = {
			["Escort WOB - AA - R-73*2,R-27ET*2,R-77*2,R-27ER*2,ECM"] = {
				attributes =  { },
				code_loadout =  { "WOB" },
				night = true,
				adverseWeather = true,
				range = 800000,
				firepower = 5,
				vCruise = 260.222,
				vAttack = 300.555,
				hCruise = 8500,
				hAttack = 8500,
				standoff = 60000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{44EE8698-89F9-48EE-AF36-5FD31896A82F}",
						},
						[2] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[3] = {
							CLSID = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}",
						},
						[4] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[5] = {
							CLSID = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						},
						[6] = {
							CLSID = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						},
						[7] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[8] = {
							CLSID = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}",
						},
						[9] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[10] = {
							CLSID = "{44EE8698-89F9-48EE-AF36-5FD31896A82A}",
						},
					},
					fuel = "9400",
					flare = 96,
					chaff = 96,
					gun = 100,
				},
			},
			["Escort WOB - AA - R-73*2,R-27ET*2,R-77*4,ECM"] = {
				attributes =  { },
				code_loadout =  { "WOB" },
				night = true,
				adverseWeather = true,
				range = 800000,
				firepower = 6,
				vCruise = 260.222,
				vAttack = 300.555,
				hCruise = 8500,
				hAttack = 8500,
				standoff = 50000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{44EE8698-89F9-48EE-AF36-5FD31896A82F}",
						},
						[2] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[3] = {
							CLSID = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}",
						},
						[4] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[5] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[6] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[7] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[8] = {
							CLSID = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}",
						},
						[9] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[10] = {
							CLSID = "{44EE8698-89F9-48EE-AF36-5FD31896A82A}",
						},
					},
					fuel = "9400",
					flare = 96,
					chaff = 96,
					gun = 100,
				},
			},
		},
		CAP = {
			["CAP WOB - AA - R-73*2,R-27ET*2,R-77*2,R-27ER*2,ECM"] = {
				attributes =  { },
				code_loadout =  { "WOB" },
				night = true,
				adverseWeather = true,
				range = 600000,
				firepower = 5,
				vCruise = 213.222,
				vAttack = 213.555,
				hCruise = 8500,
				hAttack = 8500,
				standoff = 60000,
				tStation = 3700,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{44EE8698-89F9-48EE-AF36-5FD31896A82F}",
						},
						[2] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[3] = {
							CLSID = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}",
						},
						[4] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[5] = {
							CLSID = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						},
						[6] = {
							CLSID = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						},
						[7] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[8] = {
							CLSID = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}",
						},
						[9] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[10] = {
							CLSID = "{44EE8698-89F9-48EE-AF36-5FD31896A82A}",
						},
					},
					fuel = "9400",
					flare = 96,
					chaff = 96,
					gun = 100,
				},
			},
			["CAP WOB - AA - R-73*2,R-27ET*2,R-77*4,ECM"] = {
				attributes =  { },
				code_loadout =  { "WOB" },
				night = true,
				adverseWeather = true,
				range = 600000,
				firepower = 6,
				vCruise = 213.222,
				vAttack = 213.555,
				hCruise = 8500,
				hAttack = 8500,
				standoff = 50000,
				tStation = 3700,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{44EE8698-89F9-48EE-AF36-5FD31896A82F}",
						},
						[2] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[3] = {
							CLSID = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}",
						},
						[4] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[5] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[6] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[7] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[8] = {
							CLSID = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}",
						},
						[9] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[10] = {
							CLSID = "{44EE8698-89F9-48EE-AF36-5FD31896A82A}",
						},
					},
					fuel = "9400",
					flare = 96,
					chaff = 96,
					gun = 100,
				},
			},
		},
		SEAD = {
			["WOB - SEAD - R-73*2,Kh-31P*2,KH-29T*2,R-77*2,ECM"] = {
				attributes =  { },
				code_loadout =  { "WOB" },
				weaponType = "ASM",
				night = true,
				adverseWeather = true,
				range = 800000,
				firepower = 1,
				vCruise = 330,
				vAttack = 450,
				hCruise = 8000,
				hAttack = 8000,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{44EE8698-89F9-48EE-AF36-5FD31896A82F}",
						},
						[2] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[3] = {
							CLSID = "{D8F2C90B-887B-4B9E-9FE2-996BC9E9AF03}",
						},
						[4] = {
							CLSID = "{B4FC81C9-B861-4E87-BBDC-A1158E648EBF}",
						},
						[5] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[6] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[7] = {
							CLSID = "{B4FC81C9-B861-4E87-BBDC-A1158E648EBF}",
						},
						[8] = {
							CLSID = "{D8F2C90B-887B-4B9E-9FE2-996BC9E9AF03}",
						},
						[9] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[10] = {
							CLSID = "{44EE8698-89F9-48EE-AF36-5FD31896A82A}",
						},
					},
					fuel = "9400",
					flare = 96,
					chaff = 96,
					gun = 100,
				},
			},
			["WOB - SEAD - R-73*2,Kh-31P*4,R-77*2,ECM"] = {
				attributes =  { },
				code_loadout =  { "WOB" },
				weaponType = "ASM",
				night = true,
				adverseWeather = true,
				range = 800000,
				firepower = 1,
				vCruise = 330,
				vAttack = 450,
				hCruise = 8000,
				hAttack = 8000,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{44EE8698-89F9-48EE-AF36-5FD31896A82F}",
						},
						[2] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[3] = {
							CLSID = "{D8F2C90B-887B-4B9E-9FE2-996BC9E9AF03}",
						},
						[4] = {
							CLSID = "{D8F2C90B-887B-4B9E-9FE2-996BC9E9AF03}",
						},
						[5] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[6] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[7] = {
							CLSID = "{D8F2C90B-887B-4B9E-9FE2-996BC9E9AF03}",
						},
						[8] = {
							CLSID = "{D8F2C90B-887B-4B9E-9FE2-996BC9E9AF03}",
						},
						[9] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[10] = {
							CLSID = "{44EE8698-89F9-48EE-AF36-5FD31896A82A}",
						},
					},
					fuel = "9400",
					flare = 96,
					chaff = 96,
					gun = 100,
				},
			},
		},
		["Anti-ship Strike"] = {
			["Antiship, WOB - Anti-Ship - R-73*2,Kh-31A*4,R-77*2,ECM"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "ship" },
				code_loadout =  { "WOB" },
				weaponType = "ASM",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 900000,
				firepower = 1,
				vCruise = 250,
				vAttack = 300,
				hCruise = 6096,
				hAttack = 6096,
				standoff = 50000,
				ingress = 50000,
				egress = 12000,
				MaxAttackOffset = 60,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{44EE8698-89F9-48EE-AF36-5FD31896A82F}",
						},
						[2] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[3] = {
							CLSID = "{4D13E282-DF46-4B23-864A-A9423DFDE504}",
						},
						[4] = {
							CLSID = "{4D13E282-DF46-4B23-864A-A9423DFDE504}",
						},
						[5] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[6] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[7] = {
							CLSID = "{4D13E282-DF46-4B23-864A-A9423DFDE504}",
						},
						[8] = {
							CLSID = "{4D13E282-DF46-4B23-864A-A9423DFDE504}",
						},
						[9] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[10] = {
							CLSID = "{44EE8698-89F9-48EE-AF36-5FD31896A82A}",
						},
					},
					fuel = "9400",
					flare = 96,
					chaff = 96,
					gun = 100,
				},
			},
		},
		Intercept = {
			["Intercept WOB - AA - R-73*2,R-27ET*2,R-77*2,R-27ER*2,ECM"] = {
				attributes =  { },
				code_loadout =  { "WOB" },
				night = true,
				adverseWeather = true,
				range = 800000,
				firepower = 5,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{44EE8698-89F9-48EE-AF36-5FD31896A82F}",
						},
						[2] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[3] = {
							CLSID = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}",
						},
						[4] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[5] = {
							CLSID = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						},
						[6] = {
							CLSID = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						},
						[7] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[8] = {
							CLSID = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}",
						},
						[9] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[10] = {
							CLSID = "{44EE8698-89F9-48EE-AF36-5FD31896A82A}",
						},
					},
					fuel = "9400",
					flare = 96,
					chaff = 96,
					gun = 100,
				},
			},
			["Intercept WOB - AA - R-73*2,R-27ET*2,R-77*4,ECM"] = {
				attributes =  { },
				code_loadout =  { "WOB" },
				night = true,
				adverseWeather = true,
				range = 800000,
				firepower = 6,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{44EE8698-89F9-48EE-AF36-5FD31896A82F}",
						},
						[2] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[3] = {
							CLSID = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}",
						},
						[4] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[5] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[6] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[7] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[8] = {
							CLSID = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}",
						},
						[9] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[10] = {
							CLSID = "{44EE8698-89F9-48EE-AF36-5FD31896A82A}",
						},
					},
					fuel = "9400",
					flare = 96,
					chaff = 96,
					gun = 100,
				},
			},
		},
	},
	["Su-34"] = {
		SEAD = {
			["WOB - SEAD - R-77x2 - R-27ERx2 - Kh-58Ux2 - Kh-31Px2 - ECM"] = {
				attributes =  { },
				code_loadout =  { "WOB" },
				weaponType = "ASM",
				night = true,
				adverseWeather = true,
				range = 800000,
				firepower = 1,
				vCruise = 330,
				vAttack = 450,
				hCruise = 8000,
				hAttack = 8000,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{ECM_POD_L_175V}",
						},
						[2] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[3] = {
							CLSID = "{X-31P}",
						},
						[4] = {
							CLSID = "{B5CA9846-776E-4230-B4FD-8BCC9BFB1676}",
						},
						[5] = {
							CLSID = "{X-29T}",
						},
						[6] = {
							CLSID = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						},
						[7] = {
							CLSID = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						},
						[8] = {
							CLSID = "{X-29T}",
						},
						[9] = {
							CLSID = "{B5CA9846-776E-4230-B4FD-8BCC9BFB1676}",
						},
						[10] = {
							CLSID = "{X-31P}",
						},
						[11] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[12] = {
							CLSID = "{ECM_POD_L_175V}",
						},
					},
					fuel = "9800",
					flare = 64,
					chaff = 64,
					gun = 100,
				},
			},
		},
		["Anti-ship Strike"] = {
			["Antiship, Antiship Kh-31A*6,R-73*2,R-77*2,ECM"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "ship" },
				code_loadout =  { "WOB" },
				weaponType = "ASM",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 900000,
				firepower = 1,
				vCruise = 250,
				vAttack = 300,
				hCruise = 6096,
				hAttack = 6096,
				standoff = 50000,
				ingress = 50000,
				egress = 10000,
				MaxAttackOffset = 60,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{44EE8698-89F9-48EE-AF36-5FD31896A82F}",
						},
						[2] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[3] = {
							CLSID = "{4D13E282-DF46-4B23-864A-A9423DFDE504}",
						},
						[4] = {
							CLSID = "{4D13E282-DF46-4B23-864A-A9423DFDE504}",
						},
						[5] = {
							CLSID = "{4D13E282-DF46-4B23-864A-A9423DFDE504}",
						},
						[6] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[7] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[8] = {
							CLSID = "{4D13E282-DF46-4B23-864A-A9423DFDE504}",
						},
						[9] = {
							CLSID = "{4D13E282-DF46-4B23-864A-A9423DFDE504}",
						},
						[10] = {
							CLSID = "{4D13E282-DF46-4B23-864A-A9423DFDE504}",
						},
						[11] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[12] = {
							CLSID = "{44EE8698-89F9-48EE-AF36-5FD31896A82A}",
						},
					},
					fuel = "9800",
					flare = 64,
					chaff = 64,
					gun = 100,
				},
			},
		},
		Strike = {
			["WOB - AG - R-77x2 - R-27ERx2 - Kh-29Tx4 - Kh-29Lx2 - ECM"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Structure" },
				code_loadout =  { "WOB" },
				weaponType = "ASM",
				expend = "Auto",
				night = true,
				range = 900000,
				firepower = 1,
				vCruise = 250,
				vAttack = 300,
				hCruise = 7096,
				hAttack = 7096,
				standoff = 10000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{ECM_POD_L_175V}",
						},
						[2] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[3] = {
							CLSID = "{X-29T}",
						},
						[4] = {
							CLSID = "{X-29L}",
						},
						[5] = {
							CLSID = "{X-29T}",
						},
						[6] = {
							CLSID = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						},
						[7] = {
							CLSID = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						},
						[8] = {
							CLSID = "{X-29T}",
						},
						[9] = {
							CLSID = "{X-29L}",
						},
						[10] = {
							CLSID = "{X-29T}",
						},
						[11] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[12] = {
							CLSID = "{ECM_POD_L_175V}",
						},
					},
					fuel = "9800",
					flare = 64,
					chaff = 64,
					gun = 100,
				},
			},
			["WOB - AG - R-73x2 - R-77x2 - R-27ERx2 - Kh-59Mx2 - ECM"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Structure", "SAM" },
				code_loadout =  { "WOB" },
				weaponType = "ASM",
				expend = "Auto",
				night = true,
				range = 900000,
				firepower = 1,
				vCruise = 250,
				vAttack = 300,
				hCruise = 7096,
				hAttack = 7096,
				standoff = 100000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{ECM_POD_L_175V}",
						},
						[2] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[3] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[4] = {
							CLSID = "{40AB87E8-BEFB-4D85-90D9-B2753ACF9514}",
						},
						[6] = {
							CLSID = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						},
						[7] = {
							CLSID = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
						},
						[11] = {
							CLSID = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
						},
						[10] = {
							CLSID = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
						},
						[9] = {
							CLSID = "{40AB87E8-BEFB-4D85-90D9-B2753ACF9514}",
						},
						[12] = {
							CLSID = "{ECM_POD_L_175V}",
						},
					},
					fuel = "9800",
					flare = 64,
					chaff = 64,
					gun = 100,
				},
			},
		},
	},	
}