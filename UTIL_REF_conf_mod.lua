
--configuration file, for the player and for the campainmaker
--Requires only a skipmission after a change
--This file is updated automatically if new items are added, keeping the old player options
------------------------------------------------------------------------------------------------------- 


--@ui-schema v1 : trailing comments starting with "@ui" tell DCE_Manager how to render that field.
--  syntax : -- @ui <type> [min=N] [max=N] [group="Name"] [label="Text"] [options="value:Label,value:Label"] [zero-false=true] [step=N] [help=free text to end of line]
--  types  : checkbox | numeric | slider | combo | text
--  zero-false=true : a value of 0 must be written back to Lua as the literal "false" (and read back as 0)
--  a field with no @ui tag is simply not shown in the DCE_Manager UI

mission_ini_check = {
	--***number of ground elements (FPS like)***
	PruneScriptConf = {
		PruneScript          = true,    -- @ui checkbox group="Prune Script" label="Enable pruning" help=Enable or disable ground unit pruning (mod Tomsk M09) to improve FPS by reducing the number of ground units. [default: true]
		PruneAggressiveness  = 1.8,     -- @ui numeric min=0 max=3 step=0.1 group="Prune Script" label="Pruning aggressiveness" help=How aggressive the pruning is (0 to 3). Larger numbers remove more units; 0 = no pruning at all. [default: 1.8]
		PruneStatic          = true,    -- @ui checkbox group="Prune Script" label="Prune static aircraft" help=Whether ALL parked (static) aircraft should be pruned too. Recommended: true in multiplayer. [default: true]
		ForcedPruneSam       = false,   -- @ui checkbox group="Prune Script" label="Force prune active SAMs" help=PBO_CEF kept some active SAMs on purpose; this option also disables them. [default: false]
	},
	
	--***Don Rudi's ArtySpotter script option***
	spotter = {
		markerPrefix      = "fire mission", -- @ui text group="Spotter" label="Marker prefix" help=Prefix for the marker text, e.g. "#arty" or "fire" (used alone or as a position prefix added to the marker text). [default: "fire mission"]
		spottingDistance  = 15,      -- @ui numeric min=5 max=15 group="Spotter" label="Spotting distance (km)" help=Maximum allowed distance from the player to the target, to prevent cheating. In kilometers. [default: 15]
		qtyBySalve        = 20,      -- @ui numeric min=10 max=40 group="Spotter" label="Shells per salvo" help=Number of shells fired per salvo (for the effect task). [default: 20]
		qtyTotalShells    = 100,     -- @ui numeric min=50 max=200 group="Spotter" label="Total shells available" help=Total number of artillery shells that can be allocated to your mission. [default: 100]
		smokeOn           = true,    -- @ui checkbox group="Spotter" label="Smoke marker" help=Show a red smoke marker during a "single round" firing, to help adjust artillery. [default: true]
	},
	
	--***aircraft/helicopter option player/client***
	parking_hotstart              = false,   -- @ui checkbox group="Aircraft" label="Hot start on parking" help=Player flights start with engines already running on parking. [default: false]
	intercept_hotstart            = 2,       -- @ui combo zero-false=true group="Aircraft" label="Intercept hot start" options="0:Cold start,1:Parking (hot),2:Runway (hot)" help=Player flights with an intercept task start with engines running. [default: false / cold start]
	alignment_Mode                = "fast",  -- @ui combo group="Aircraft" label="INS alignment speed" options="fast:Fast,slow:Slow" help=Inertial unit alignment speed, if available for the mission's player/client modules. [default: "fast"]
	persistentACFT_FileNameCache  = "",      -- @ui text group="Aircraft" label="(F-4E option) Damaged aircraft cache filename" help=Filename of the damaged aircraft cache, in the Heatblur folder (example: "NAM_Campaign"). [default: ""]
	persistentACFT_TailNb         = "",      -- @ui text group="Aircraft" label="(F-4E option) Damaged aircraft tail number" help=Tail number of the damaged aircraft (example: "021" for "FT-021"). [default: ""]
		
	--***in-flight failures***
	failure                       = false,   -- @ui checkbox group="Failures" label="Enable in-flight failures" help=Activates random aircraft failures. Works in SOLO; buggy in multiplayer. [default: false]
	failureProbMax                = 5,       -- @ui numeric min=1 max=100 group="Failures" label="Failure probability (%)" help=Probability of a given failure occurring. [default: 5]
	failureNbMax                  = 5,       -- @ui numeric min=1 max=60 group="Failures" label="Max failures per mission" help=Maximum number of failures in a single mission. [default: 2]
	
	--***time options***
	onlyDayMission                = true,    -- @ui checkbox group="Time" label="Daylight missions only" help=Forces all missions to be played in daylight (Mod M25). [default: false]
	hourlyTolerance               = 6,       -- @ui numeric min=0 max=100 group="Time" label="Hourly tolerance (%)" help=When "Daylight missions only" is on, allows the mission to start a bit before or after daytime, as a percentage. [default: 5]
	startup_time_player           = 1800,    -- @ui numeric min=0 max=7200 group="Time" label="Startup/taxi/take-off time (s)" help=Time in seconds allocated for startup, taxi and take-off for the player flight. [default: 600]
	mission_duration              = 6600,    -- @ui numeric min=0 max=36000 group="Time" label="Mission duration (s)" help=Duration of a mission in seconds. [default: 5400]
	idle_time_min                 = 10800,   -- @ui numeric min=0 max=100000 group="Time" label="Min time between missions (s)" help=Minimum time between missions, in seconds. [default: 10800]
	idle_time_max                 = 14400,   -- @ui numeric min=0 max=100000 group="Time" label="Max time between missions (s)" help=Maximum time between missions, in seconds. [default: 14400]
	dawn                          = 21600,   -- @ui numeric min=0 max=86400 group="Time" label="Dawn (s since midnight)" help=Time of dawn, in seconds since midnight. [default: 21600]
	dusk                          = 65700,   -- @ui numeric min=0 max=86400 group="Time" label="Dusk (s since midnight)" help=Time of dusk, in seconds since midnight. [default: 65700]
		
	--***weather options***
	weather_playerBias    = 0,      -- @ui slider min=-50 max=50 group="Weather U" label="Player bias" help=Shifts the trend imposed by campaign events toward good (+) or bad (-) weather. 0 = fully respects the campaignMaker's intent. [default: 0]

	
	
		--***current date during this campaign***
	current_date = {
		setDateInNextMission = false,   -- @ui checkbox group="Date" label="Apply this date to next mission" help=If enabled, the date below is applied at the start of the next mission. [default: false]
		day             = 7,             -- @ui numeric min=1 max=31 group="Date" label="Day"
		year            = 1996,          -- @ui numeric min=1936 max=2100 group="Date" label="Year"
		month           = 7,             -- @ui numeric min=1 max=12 group="Date" label="Month"
	},
	
		--***difficulty option***
	slider_CampaignDuration       = 0,   -- @ui combo zero-false=true group="Difficulty" label="Campaign duration" options="0:No change,1:1 - Fast,2:2 - Medium,3:3 - Long (recommended),4:4 - Very long" help=Influences the length of the campaign. [default: false]
	slider_EnemyLevel             = 0,   -- @ui combo zero-false=true group="Difficulty" label="Enemy level" options="0:No change,1:1 - Easy,2:2 - Medium,3:3 - Difficult (recommended),4:4 - Very difficult" help=Changes the level of pilots, number of planes, etc. [default: false]
	randomizeSkills               = true,    -- @ui checkbox group="Difficulty" label="Randomize pilot skills" help=Random but logical skill assignment, versus respecting the skills configured in the Air OOB. (@SomethingSimple) [default: true]
	slider_PercentPlane           = false,   -- @ui numeric min=0 max=100 zero-false=true group="Difficulty" label="Aircraft % (0 = no change)" help=Percentage of the number of aircraft proposed in the campaign. 100% is the campaignMaker's choice; try 80% or less to gain FPS. [default: false]
	strikeOnlyWithEscorte         = false,   -- @ui checkbox group="Difficulty" label="Strike requires escort" help="Requires an escort for strikes to proceed. [default: false]"
	
		--***miscellaneous options***
	movedBullseye                 = true,    -- @ui checkbox group="Misc" label="Move bullseye each mission" help=Moves the bullseye position for every mission. [default: true]
	CV_CleanDeck                  = true,    -- @ui checkbox group="Misc" label="Clean carrier deck" help=Removes all static aircraft from the carrier deck. [default: false]
	SC_CarrierIntoWind            = "man",   -- @ui combo group="Misc" label="Carrier into wind" options="auto:Auto,man:Manual" help="auto": the carrier rotates automatically according to air operations (original Mbot code). "man": the carrier turns only via the F10 radio menu command. [default: "auto"]
	MP_PlaneRecovery              = 2,       -- @ui numeric min=0 max=20 zero-false=true group="Misc" label="MP plane recovery" help=In multiplayer, lets you take control of an aircraft already in flight after a crash. [default: 2]
	backupAllMissionFiles         = true,    -- @ui checkbox group="Misc" label="Backup all mission files" help=Saves every mission in the Debriefing directory instead of only the last one. [default: false]
	cheat_Mod_Eye                 = false,   -- @ui checkbox group="Misc" label="Show all aircraft (cheat)" help=Reveals all friendly and enemy aircraft. [default: false]
	unitSystem                    = "imperial", -- @ui combo group="Misc" label="Unit system" options="imperial:Imperial,metric:Metric" help=Unit system used throughout the campaign. [default: "imperial"]
	
		--***third-party mod option***
	silenceATC                    = "auto",  -- @ui combo group="3rd-Party Mods" label="Silence ATC" options="auto:Auto (MP only),true:Always silence,false:Never silence" help=Silences the ATC to avoid repeated talking that blocks multiplayer flights (except the carrier). "auto" silences it in multiplayer only. Note: the Lua value is either the quoted string "auto" or a bare boolean - needs special handling in the writer. [default: "auto"]
	load_CTLD                     = false,   -- @ui checkbox group="3rd-Party Mods" label="Load CTLD script" help=Loads the CTLD (Cargo/Troop Loading and Deployment) script. [default: false]
	load_mist                     = false,   -- @ui checkbox group="3rd-Party Mods" label="Load mist script" help=Loads the mist scripting framework. [default: false]
	preset_AAA_Barrage_BLUE       = 1,       -- @ui combo group="3rd-Party Mods" label="AAA Barrage preset (BLUE)" options="0:Disabled, 1:preset 1, 2:preset 2, 3:preset 3, 4:preset 4, 5:preset 5, 6:preset 6" help=... [default: 0]
	preset_AAA_Barrage_RED        = 1,       -- @ui combo group="3rd-Party Mods" label="AAA Barrage preset (RED)"  options="0:Disabled, 1:preset 1, 2:preset 2, 3:preset 3, 4:preset 4, 5:preset 5, 6:preset 6" help=... [default: 0]	
}

-- Force your own options rather than those of base_ini.miz, which correspond to those of PBO-CEF ^^
-- Force vos propres options plutot que ceux de base_ini.miz, qui correspondent � ceux de PBO-CEF ^^
mission_forcedOptions_check = {
	["wakeTurbulence"]           = true,    -- @ui checkbox group="Forced Options" label="Wake turbulence" help=Enables wake turbulence. Recommended off in multiplayer. [default: true]
	["labels"]                   = 0,       -- @ui combo group="Forced Options" label="Labels" options="0:No label,1:Full label,2:Label repealed,3:Flat label" help=Controls the in-game unit label style. [default: 0]
	["optionsView"]              = "optview_all", -- @ui combo group="Forced Options" label="F10 map view" options="optview_onlymap:Map only,optview_myaircraft:Only my aircraft,optview_allies:Fog of war,optview_onlyallies:Allies only,optview_all:Everything visible" help=Controls what is visible on the F10 map. "optview_all" is useful for programming JDAM/JSAW: non-target units stay invisible to the player. [default: "optview_all"]
	["externalViews"]            = true,    -- @ui checkbox group="Forced Options" label="External views" help=Allows external camera views. [default: true]
	["permitCrash"]              = true,    -- @ui checkbox group="Forced Options" label="Crash recovery" help=Allows recovery after a crash. [default: true]
	["miniHUD"]                  = false,   -- @ui checkbox group="Forced Options" label="Mini HUD" help=Enables the mini HUD. [default: false]
	["cockpitVisualRM"]          = true,    -- @ui checkbox group="Forced Options" label="Cockpit visual recognition mod" help=Enables the visual recognition mod in the cockpit. [default: true]
	["userMarks"]                = true,    -- @ui checkbox group="Forced Options" label="F10 map markers" help=Enables player-placed markers in the F10 map view. [default: true]
	["civTraffic"]               = "",      -- @ui combo group="Forced Options" label="Civil road traffic" options=":Off,low:Low,medium:Medium,high:High" help=Sets civilian road traffic density. Recommended off in multiplayer. [default: "" / off]
	["birds"]                    = 0,       -- @ui numeric min=0 max=100 group="Forced Options" label="Bird strike probability (%)" help=Probability of a bird strike collision. Recommended 0 in multiplayer. [default: 100]
	["cockpitStatusBarAllowed"]  = false,   -- @ui checkbox group="Forced Options" label="Cockpit status bar" help=Enables the cockpit status bar. [default: false]
	["RBDAI"]                    = true    -- @ui checkbox group="Forced Options" label="Combat damage assessment" help=Enables combat damage assessment (RBDAI). [default: true]
}

















-- 2 ############################################################################################################################################################
-- 2 ############################################################################################################################################################
--The options in this second part are exclusively reserved for the campaign editor. Players must not modify them.
-- 2 ############################################################################################################################################################	
-- 2 ############################################################################################################################################################


Debug_check = {
	debug                  = false,   -- @ui checkbox audience=campaignMaker group="Debug" label="Debug mode" help=Replaces the old Init/camp/debug variable. Logs information to the DCS log and/or the campaign's /Debug folder while the mission is generated and played.
	allUnhide              = false,   -- @ui checkbox audience=campaignMaker group="Debug" label="Unhide all groups" help=Displays all groups on the F10 map.
	debugInGamePopup       = false,   -- @ui checkbox audience=campaignMaker group="Debug" label="In-game debug popup" help=Pops up the Lua/DCS bug window in game. Caution: this blocks the game.
	
	AfficheFailure         = false,   -- @ui checkbox audience=campaignMaker group="Debug" label="Log failure info" help=Displays random failure info.
	AfficheFlight          = false,   -- @ui checkbox audience=campaignMaker group="Debug" label="Log flight/package info" help=Displays generated package/flight info.
	AfficheSol             = false,   -- @ui checkbox audience=campaignMaker group="Debug" label="Log remaining ground targets" help=Displays info about targets still intact.
	Generator = {
		affiche    = false,   -- @ui checkbox audience=campaignMaker group="Debug" label="Log ATO generator info" help=Saves all ATO_Generator information to the file Debug/AtoGenerator_Debug.txt.
		chapter    = "A",     -- @ui combo audience=campaignMaker group="Debug" label="ATO generator chapter" options="A:A,B:B,C:C" help=Which of the 3 ATO_Generator parts (A/B/C) to log.
		nb         = 200,     -- @ui numeric min=0 max=1000 audience=campaignMaker group="Debug" label="Number of flights to log"
		SpySquad   = "VF-101", -- @ui text audience=campaignMaker group="Debug" label="Spy squad" help=Logs this squad's passage through the ATO_Generator.
		SpyTask    = "Escort", -- @ui text audience=campaignMaker group="Debug" label="Spy task" help=Logs this squad AND its task's passage through the ATO_Generator.
		SpyTarget  = "Bandar-e-Jask airfield", -- @ui text audience=campaignMaker group="Debug" label="Spy target" help=Logs this target's passage through the ATO_Generator.
	},
	checkTargetName        = true,    -- @ui checkbox audience=campaignMaker group="Debug" label="Check target names" help=Checks whether the target exists in oob_ground or in a template. [default: false]
	checkTargetName2Space  = true,    -- @ui checkbox audience=campaignMaker group="Debug" label="Check double spaces in names" help=Alerts on FirstMission if target names contain 2 consecutive spaces. [default: false]
		-- makeCampaign = false,						-- (true/false)	[default: false]	allows campaignMaker to create a file mapping xy positions to LL (Init\LL_Positions.lua) this file is created automatically during the first 60 seconds of a DCE mission in DCS
}


campMod_check = {

		--***weather options***
	weather = {
		trend         = 50,      -- @ui slider min=0 max=100 audience=campaignMaker group="Weather" label="Trend" help=Main weather tendency. 0 = strong low pressure: storms, fronts, heavy clouds. 100 = strong high pressure: clear skies, stable weather. [default: 50]
		variance      = 30,      -- @ui slider min=0 max=100 audience=campaignMaker group="Weather" label="Variance" help=How much the weather is allowed to deviate from the trend. Low = very stable, predictable weather. High = wide variations, unpredictable weather, mixed conditions. [default: 30]
		refTemp       = 20,      -- @ui numeric min=-30 max=45 audience=campaignMaker group="Weather" label="Reference temperature (C)" help=Reference daytime temperature. Weather categories will adjust slightly around this value. [default: 20]
		instability   = 60,      -- @ui slider min=0 max=100 audience=campaignMaker group="Weather" label="Instability (h)" help=How fast the weather evolves over time. Controls how often and how strongly the weather changes between missions or during long campaigns, in hours. [default: 60]
		windActivity  = 10,     -- @ui slider min=0 max=10 step=0.1 audience=campaignMaker group="Weather" label="Wind activity (m/s)" help=Average wind intensity at ground level. Higher values produce stronger and more turbulent winds. [default: 2.5]
		winDirection  = 158,     -- @ui slider min=0 max=359 audience=campaignMaker group="Weather" label="Wind direction" help=Dominant wind direction in degrees. Weather generation will create realistic variations around this value. [default: 158]
	},
		
	-- ***loadout options***
	selectLoadout  = "central", -- @ui combo audience=campaignMaker group="Loadout" label="Loadout source" options="central:Central (legacy),init:Init" help=Where the loadout file is located. "init" is for old campaigns whose loadout file sits in the /Init folder. [default: "central"]
	
	
	RepairOption = {
		blue = { -- @ui matrix audience=campaignMaker group="Repair (Blue)" label="Repair options" rows="airUnit:Air unit,airbase:Airbase,sam:SAM,ewr:EWR,bridge:Bridge,generic:Generic" cols="1:Min repair %,2:Death point %,3:Reinforce delay (h),4:Repair chance %,5:Repair value/day"
			airUnit = { 0 , 0 , 12 , 0 , 0 },
			airbase = { 20 , 20 , 12 , 0 , 2 },
			sam = { 25 , 20 , 12 , 15 , 0 },
			ewr = { 25 , 20 , 12 , 15 , 0 },
			bridge = { 25 , 20 , 12 , 8 , 0 },
			generic = { 25 , 20 , 12 , 2 , 0 },
			runway = {0, 20, 0, 0, 25, 50
			},
		},
		red = { -- @ui matrix audience=campaignMaker group="Repair (Red)" label="Repair options" rows="airUnit:Air unit,airbase:Airbase,sam:SAM,ewr:EWR,bridge:Bridge,generic:Generic" cols="1:Min repair %,2:Death point %,3:Reinforce delay (h),4:Repair chance %,5:Repair value/day"
			airUnit = { 0 , 0 , 12 , 0 , 0 },
			airbase = { 20 , 20 , 12 , 0 , 0 },
			runway = {0, 20, 0, 0, 25, 50},
			sam = { 25 , 20 , 12 , 15 , 0 },
			ewr = { 25 , 20 , 12 , 15 , 0 },
			bridge = { 25 , 20 , 12 , 8 , 0 },
			generic = { 25 , 20 , 12 , 2 , 0 },
		},
	},

	bullseyeZoneOverride = {
		enabled = false,  -- @ui checkbox audience=campaignMaker group="Bullseye zone override" label="Override this campaign's bullseye zone" help=If enabled, uses the position and radius below instead of the shared UTIL_MapData default for this map. [default: false]
		x       = 0,      -- @ui numeric audience=campaignMaker group="Bullseye zone override" label="Center X" help=Custom bullseye zone center, X coordinate (only used if enabled above). [default: 0]
		y       = 0,      -- @ui numeric audience=campaignMaker group="Bullseye zone override" label="Center Y" help=Custom bullseye zone center, Y coordinate (only used if enabled above). [default: 0]
		rayon   = 200,    -- @ui numeric min=0 max=500 audience=campaignMaker group="Bullseye zone override" label="Radius (km)" help=Custom bullseye zone radius in km (only used if enabled above). [default: 200]
	},
}



