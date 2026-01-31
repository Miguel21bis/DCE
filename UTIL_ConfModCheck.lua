--configuration file, for the player and for the campainmaker
--Requires only a skipmission after a change
--This file is updated automatically if new items are added, keeping the old player options
------------------------------------------------------------------------------------------------------- 
------------------------------------------------------------------------------------------------------- 
-- last modification: reglage_m
if not versionDCE then versionDCE = {} end
versionDCE["UTIL_ConfModCheck.lua"] = "1.38.119"
------------------------------------------------------------------------------------------------------- 		
-- SomethingSimple_a		(a add randomizeSkills)
-- cleanCode_b		
-- reglage_m				(m Kola)(n CVN to CV)(m remove jettison line)(l Add spyTarget)(j: new slider_PercentPlane)(i TheChannel)(h strikeOnlyWithEscorte = false)(g: PruneScriptConf)(f: Init/loadout selection)(e: remet WestCallsign dans ATO_FlightPlan)(d: delete DeltaMn table)(c: fire Playable_m from conf_mod)(b: CJTF Blue)(a: United Arab Emirates)
-- modification M78_a		LatLon positions added and unit display removed on MAP F10 
-- modification M77_c		CG_ArtySpotter (c camp.spotter)
-- modification M72_a		alignment_Mode
-- modification M66_d		bombOnRunway and ActivateBaseAndItsUnits (d add RepairBaseMinimumDestroyed)
-- modification M60_c		add CTLD (c load_CTLD option)(b bug vehicul)(a JTAC)
-- modification M53_b		automatic update of the conf_mod file (b conf_mod reconfiguration)
-- modification M47_b		keeps the history of the campaign files
-- modification M41			Scratchpad written in the Sratchpad file, if this modul is installed
-- modification M38_z		Check and Help CampaignMaker (z new file name: UTIL_ConfModCheck)(f: chapter ATO_Generator spy)(e: spy squad)  (c: Check conf_mod) 
-- modification M18_e		despawn (e: option confMod)
-- modification M17_f		Option F-14B & All AddPropAircraft
-- modification M11A_z		Multiplayer (z nbrecovery)
-- modification M08_b		Hotstart  
------------------------------------------------------------------------------------------------------- 

--START_PARSING
mission_ini_check = {
	--***number of ground elements (FPS like)***
	PruneScriptConf = {
		PruneScript = true,						-- (true/false)				[default: true]		activate or not the script (and the associated options) allowing to prune the number of units on the ground to improve the FPS (mod Tomsk M09)
		PruneAggressiveness = 1.9,				-- (0 to 3)					[default: 1.8]		How aggressive should the pruning be [0 to 3], larger numbers will remove more units 0 : no pruning at all
		PruneStatic = true,						-- (true/false)				[default: true]		Should ALL parked (static) aircraft be pruned [MP: recommend: true]
		ForcedPruneSam = false,					-- (true/false)				[default: false]	PBO_CEF wanted to keep some actives SAMs, this option desactivates them too. 	
	},

	--***Don Rudi's ArtySpotter script option***
	spotter = {
		markerPrefix = "fire mission",			-- ("text")					[default: "fire mission"]	Prefix for marker text, for instance "#arty" or "fire" (can be used alone or as a position prefix added to the marker text)
		spottingDistance = 15,					-- (5 to ~15km)				[default: 15]				max allowable distance from player to target to prevent cheating. In kilometers.
		qtyBySalve = 20,						-- (10 to ~40)				[default: 20]				number of shells fired per salvo (for effect task)
		qtyTotalShells = 100,					-- (50 to ~200)				[default: 100]				total number of artillery shells that can be allocated to your mission
		smokeOn = true,							-- (true/false)				[default: true]				activate or deactivate the red smoke during “single round” firing, to aid artillery adjustment
	},

	--***aircraft/helicopter option player/client***
	parking_hotstart = false,					-- (true/false)				[default: false]	player flights starts with engines running on parking
	intercept_hotstart = 2,						-- (true/false/0/1/2)		[default: false]	(1 or true: on parking)(2: on runway)(0 or false: cold start) player flights with intercept task starts with engines running 
	alignment_Mode = "fast",					-- ("fast"/"slow")			[default: "fast"]	inertial unit alignment speed, if available for mission player/client modules
	
	--***in-flight failures***
	failure = false,							-- (true/false)				[default: false]	true : aircraft failures activated, works in SOLO, bug in MP
	failureProbMax = 5,							-- (1 to 100 [%])			[default: 5]		probability of this failure 
	failureNbMax = 2 ,							-- (1 to ...57?)			[default: 2]		Max failures number in one mission 

	--***time options***
	onlyDayMission = false,						-- (true/false)				[default: false]	true: Force all missions to be played in daylight (Mod M25)
	hourlyTolerance = 2,						-- (1 to 100 [%]) 			[default: 5]		%, When activating OnlyDayMission, allows you to play a little before or a little after the day. In percentage terms	
	startup_time_player = 900,					-- (number [s])				[default: 600]		time in seconds allocated for startup, taxi and take off for player flight	
	mission_duration = 5400,					-- (number [s])				[default: 5400]		duration of a mission in seconds
	idle_time_min = 10800,						-- (number [s])				[default: 10800]	minimum time between missions in seconds
	idle_time_max = 14400,						-- (number [s])				[default: 14400]	maximum time between missions in seconds
	dawn = 21600,								-- (number [s])				[default: 21600]	time of dawn in seconds
	dusk = 65700,								-- (number [s])				[default: 65700]	time of dusk in seconds
	
	--***weather options***
	weather = {
		trend        = 50,    -- (0–100) Main weather tendency. 0  = strong low pressure: storms, fronts, heavy clouds. 100 = strong high pressure: clear skies, stable weather
		variance     = 30,    -- (0–100) How much the weather is allowed to deviate from the trend. Low  = very stable, predictable weather. High = wide variations, unpredictable weather, mixed conditions
		refTemp      = 25,    -- (°C) Reference daytime temperature. Weather categories will adjust slightly around this value.
		instability  = 40,    -- (0–100h) How fast the weather evolves over time. Controls how often and how strongly the weather changes. between missions or during long campaigns (in hours).
		windActivity = 2.5,   -- (m/s) Average wind intensity at ground level. Higher values produce stronger and more turbulent winds.
		winDirection = 158,   -- (0–359°) Dominant wind direction in degrees. Weather generation will create realistic variations around this value.
	},


	--***current date during this campaign***
	current_date = {
		setDateInNextMission = false,	-- (true/false)				[default: false]	true: set the date defined below at the beginning of the next mission
		day = 10,
		year = 1965,
		month = 7,
	},

	--***difficulty option***
	slider_CampaignDuration  = false,			-- (false/1/2/3/4)			[default: false]	(false: no change)(1: fast)(2: medium)(3: long/recommended)(4: very long)			influences the length of the campaign
	slider_EnemyLevel = false,					-- (false/1/2/3/4)			[default: false]	(false: no change)(1: easy)(2: medium)(3: difficult/recommended)(4: very difficult)	changes the level of pilots, number of planes etc...
	randomizeSkills = true,						-- (true/false)				[default: true]		(true: random but logical Skill or if the skills configured in Air OOB are to be respected. (@SomethingSimple)
	slider_PercentPlane = false,				-- (false/1 to 100 [%])		[default: false]	percentage of the number of aircraft proposed in the campaign. 100% is the CampaignMaker's choice, to gain FPS you can try 80% or less.
	strikeOnlyWithEscorte = false, 				-- (true/false) 			[default: false]	strikes are possible with only one escort

	--***miscellaneous options***
	movedBullseye = true, 						-- (true/false)				[default: true]		Moves the bullseye to each mission	
	CV_CleanDeck = false, 						-- (true/false)				[default: false]	true: Remove all static aircraft from the deck.
	SC_CarrierIntoWind = "auto",				-- ("auto"/"man")			[defaut: "auto"]	"auto": Original Mbot code: the CV rotates according to the air operations. "man": the CV runs only once via the commands in the radio menu F10 		
	MP_PlaneRecovery = 2,						-- (false/1/2/3 etc)		[defaut: 2]			In multiplayer, this allows you to control an aircraft already in flight in case of a crash.
	backupAllMissionFiles = false,				-- (true/false)				[default: false]	true: save all missions in the Debriefing directory. false: only the last mission is saved
	cheat_Mod_Eye = false,						-- (true/false)				[default: false]	allows you to see all friend and foe planes
	unitSystem = "imperial",					-- ("imperial"/"metric")	[default: "imperial"]	Unit system used in the campaign (metric or imperial)

	--***third-party mod option***
	silenceATC = "auto",						-- ("auto"/false/true)		[default: "auto"]	auto: silence only MP silences the ATC | useful for many multiplayer flights where the ATC talks and blocks repeatedly (except CV)
	load_CTLD = false,							-- (true/false)				[default: false]	loads the CTLD script
	load_mist = false,							-- (true/false)				[default: false]	loads the mist script
	preset_AAA_Barrage = 1,						-- (0/6)					[default: 0]		active loads a preset from the AAA_Barrage script (with the kind permission of Bandit648)

	--***aircraft mod option***
	--***F-4E option***
	persistentACFT_FileNameCache = "",			-- ("text"(exemple: "NAM_Campaign"))[default: ""]		text: filename of the damaged aircraft, in Heatblur folder cache
	persistentACFT_TailNb   = "",				-- ("text"(exemple: "021"))[default: ""]		text: damaged whith tail number (ex: "FT-021"), 

}

-- Force your own options rather than those of base_ini.miz, which correspond to those of PBO-CEF ^^
-- Force vos propres options plutot que ceux de base_ini.miz, qui correspondent � ceux de PBO-CEF ^^
mission_forcedOptions_check = {
	["wakeTurbulence"] = true,					-- (true/false)			[default: true]		turbulence  [MP: recommend: false]
	["labels"] = 0,								-- (0/1/2/3)			[default: 0]		( 0 : no label )  ( 1 :full label )  ( 2 : label repealed ) ( 3 : flat label )
	["optionsView"] = "optview_all",			-- ("optview_onlymap"/"optview_myaircraft"/"optview_allies"/"optview_onlyallies"/"optview_all" )		F10 map view: ( "optview_onlymap": ONLY the MAP) || ( "optview_myaircraft": only my plane on map) || ( "optview_allies": fog of war) || ( "optview_onlyallies" : Allied only  ) || ( "optview_all" : every visible targets and planes on map allowed by campaign maker : usefull to program JDAM or JSAW | non target units will stay invisible to player )
	["externalViews"] = true,					-- (true/false)			[default: true]		External view
	["permitCrash"] = true,						-- (true/false)			[default: true]		crash recovery
	["miniHUD"] = false,						-- (true/false)			[default: false]	Mini HUD
	["cockpitVisualRM"] = true,					-- (true/false)			[default: true]		Mod Visual recognition in the cockpit
	["userMarks"] = true,						-- (true/false)			[default: true]		enables markers in MAP view F10
	["civTraffic"] = "",						-- (""/ "low" / "medium" / "high")	Civil road traffic  ( "" : OFF )  [MP: recommend: ""]
	["birds"] = 100,							-- (0 to 100 [%])		[default: 100]		volatile collision probability [MP: recommend: 0]
	["cockpitStatusBarAllowed"] = false,		-- (true/false)			[default: false]	cockpit status bar
	["RBDAI"] = true,							-- (true/false)			[default: true]		Combat damage assessment
}

















-- 2 ############################################################################################################################################################
-- 2 ############################################################################################################################################################
--The options in this second part are exclusively reserved for the campaign editor. Players must not modify them.
-- 2 ############################################################################################################################################################	
-- 2 ############################################################################################################################################################


Debug_check = {
	debug = false,								-- (true/false) (replaces the variable Init/camp/debug), when the mission was created and creates some files in the /debug folder During the DCE/DCS game, enter information in the DCS log and/or in the /Debug folder of the campaign.								
	allUnhide = false,							-- (true/false) displays all groups on the F10 map
	debugInGamePopup = false,					-- (true/false) popup the lua/DCS bug window in game, be careful, it blocks the game

	AfficheFailure = false,                     -- (true/false) displays Random failure info
	AfficheFlight = false,						-- (true/false) displays generated package/flight info
	AfficheSol = false,							-- (true/false) affiche les infos des cibles encore intactes
	Generator  = {
		affiche = false,						-- (true/false) saves all ATO_Generator information in the file Debug/AtoGenerator_Debug.txt
		chapter  = "A",							-- affiche les infos des 3 parties de ATO_Generator (ABC)
		nb = 50,								-- nb de vol à afficher
		SpySquad = "111.Filo",					-- affiche le passage de ce squad dans ATO_Generator
		SpyTask = "CAP",						-- affiche le passage de ce squad ET de son Task dans ATO_Generator
		SpyTarget = "",							-- affiche le passage de ce Target dans ATO_Generator
	},
	checkTargetName = false,					-- (true/false)	[default: false]	checks whether the target exists in oob_ground or in a template
	checkTargetName2Space = false,				-- (true/false)	[default: false]	FirsMission Alert if target names contain 2 consecutive spaces	
	-- makeCampaign = false,						-- (true/false)	[default: false]	allows campaignMaker to create a file mapping xy positions to LL (Init\LL_Positions.lua) this file is created automatically during the first 60 seconds of a DCE mission in DCS
}


campMod_check = {
	
	--***loadout options***
	selectLoadout = "central",				-- ("central"/"init")		[default: "central"] (init: for old campaigns, if the loadout file is located in the /Init folder)

	-- --***OLD repair option***
	-- RepairBaseMinimumDestroyed = 20,		-- (1 to 100 [%])	[default: 20]	does not repair if Base % life is less than 
	-- targetSpecificRepairValue = xx		-- to have a customized repair value for a target, to be added to the targetlist_init file.

	-- --***OLD other repair options with a different logic***
	-- RepairRunwayPerDay = 25,				-- (1 to 100 [%])	[default: 25]	% per day for runway repairs

	--***repair option***.
	-- object = {			1			;		2			;			3		;		4		;			5		}
	-- object = {minimumRepairThreshold	;	deathPoint		;	 reinforceDelay;	repairChance;		repairValue	}
	-- object = {	(% de l'unité) 		;	(% de l'unité) ;	(Nbre d'heures) ;	(% de proba) ;	(valeur de rép/Day)}

			-- minimumRepairThreshold : à partir de cette valeur l'unité n'est plus réparée mais vivante 
			-- deathPoint : à partir de cette valeur l'unité est mise à 0 et donc détruite
			-- repairValue: valeur de réparation pour une cible entiere/jour ou moment de réparation

	-- runway = {			1			;		2			;		 3			;		4		;		5				;		6		}
	-- runway = {		not used		;	deathPoint		;	 not used		;	not used	;	repairValue			;	runwayOk	}
	-- runway = {	(% de l'unité) 		;	(% de l'unité) ;	(Nbre d'heures) ;	(% de proba);	(value de rép/Day)	;	(% du Runway)}

	-- runway = {0,20,12,0,25,50},
			-- Runway < 20 ou à "deathPoint" : piste HS DEFINITIVEMENT, (Base Active, Plane Off, Heli On)
			-- repairRunwayPerDay = campMod.RepairOption[DCS_ENI_Side[side_name]]["runway"][5]
			-- Runway > 50 (ou runwayOk)la piste est PRATICABLE, REPARATION en cours , (Base Active, Plane On, Heli On)


	RepairOption = {
		blue = {
			airUnit = {0,0,12,0,0},
			airbase = {20,20,12,0,0},
			runway = {0,20,0,0,25,50},
			sam = {25,20,12,15,0},
			ewr = {25,20,12,15,0},
			bridge = {25,20,12,8,0},
			generic = {25,20,12,2,0},
		},
		red = {
			airUnit = {0,0,12,0,0},
			airbase = {20,20,12,0,0},
			runway = {0,20,0,0,25,50},
			sam = {25,20,12,15,0},
			ewr = {25,20,12,15,0},
			bridge = {25,20,12,8,0},
			generic = {25,20,12,2,0},
		},
	},


	movedBullseye = { 						-- modification M27 	movedBullseye
		Caucasus = {						
			pos = {
				x = -281713,				-- centre du rayon autour de laquelle on s'autorise � placer le nouveau BullsEye ['Senaki-Kolkhi']
				y = 647369,					-- centre du rayon autour de laquelle on s'autorise � placer le nouveau BullsEye ['Senaki-Kolkhi']
			},
			rayon = 200,					-- distance en Km autour de laquelle on peut placer le bullsEye
		},
		PersianGulf = {						
			pos = {
				x =	64800.714844,			-- Qeshm Island
				y = -33383.481445,			-- Qeshm Island
			},
			rayon = 200,					-- distance en Km autour de laquelle on peut placer le bullsEye
		},
		Syria = {							
			pos = {
				x =	-22163,					-- Israel Line 974
				y = -11800,					-- Israel Line 974
			},
			rayon = 200,					-- distance en Km autour de laquelle on peut placer le bullsEye
		},
		MarianaIslands = {
			pos = {
					x = 0,
					y = 0,
				},
			rayon = 200,					-- distance en Km autour de laquelle on peut placer le bullsEye
		},
		Normandy = {					
			pos = {
					x = -26144.085385954,	
					y = -41381.855008994,		
				},
			rayon = 200,					-- distance en Km autour de laquelle on peut placer le bullsEye
		},
		TheChannel = {						
			pos = {
					y = -15831.502170023,	--Manston
					x = 52281.058730041,	--Manston		
				},
			rayon = 200,					-- distance en Km autour de laquelle on peut placer le bullsEye
		},
		Falklands = {						
			pos = {
				x  = 72705,					--Falklands	
				y  = -31294,				--Falklands		
				},
			rayon  = 200,					-- distance en Km autour de laquelle on peut placer le bullsEye
		},
		SinaiMap = {						
			pos = {
				x  = 677526,				
				y  = 3542227,						
				},
			rayon  = 400,					-- distance en Km autour de laquelle on peut placer le bullsEye
		},		
		Kola = {
            pos = {
                x = 00132610,				--Murmansk International
                y = 00408650,				--Murmansk International
                },
            rayon   = 200,					-- distance en Km autour de laquelle on peut placer le bullsEye
        },
		Afghanistan = {
            pos = {
				x  = -64063.440649033,                                --26144.085385954,
                y  = -368210.59078097,                                --41381.855008994,
                },
            rayon   = 200,					-- distance en Km autour de laquelle on peut placer le bullsEye
        },
	},

}

