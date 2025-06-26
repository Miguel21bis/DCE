if not versionDCE then versionDCE = {} end
versionDCE["UTIL_Changelog.lua"] = "20.88.546"
if not VersionDCE then VersionDCE = {} end
VersionDCE["UTIL_Changelog.txt"] = "20.88.546"
--[[


known issues:
- [pedro]	lands on another ship instead of CV or LHA
- [target]	a squadron is assigned to a target while another squadron (identical type&task) is based closer to it.

==:20.88.546:==
anticollision au spawn air
546	fixed		[campaign]	campaign peut etre update en cours, par modification des fichiers de Init
545	fixed		[date]	bug 1970 again
544	add			[date][time jump}	time jump possible with conf_mod (change date in conf_mod then make a SkipMission.BAT) 
543	fixed		[inter]	player interceptors are "delayed
542	fixed		[weather]	added latest weather presets + big bug on random weather
541	fixed		[AI]	prohibits in-flight refuelling and straffing for AIs
540	fixed		[debrief][stats]	revision of MAP's building destruction detection and statistics code
539	fixed		[debrief][stats]	ground unit destruction stats error
538 fixed		[refuel][M88]	CheckRefuelProgress (in progress)
537	mod		[loadout][M87]	change of logic for the “day” variable: day will always be considered true (even if it's not in the loadout). 
						However, if you want ONLY a night loadout, set this:
							night = true,
						and 
							day = false,
536	mod		[date][M86]	new variables added to conf_mod (RepairOption, current_date, weather, etc.) 
535	fixed	[generator][inter]		choosing interceptor causes mission generation to crash
534	mod		[inter]		interceptors only take off if a type of aircraft to be intercepted is detected
				in targetList: ["Kien An Airbase Alert"] = {
					task = "Intercept",
					targetPlane = {"B-52H", "A-6E", "VSN_F105D" },
					...
			
533	 add	[file][M85]		keeps files already added to base_mission
---
532	 add	[FPS][M84]		DCE Bubble by activating, deactivating vehicles and static
531	 add	[Jammer][M83]		Jammer checkMissileProximity  M83
530 add	[callSign]		assign a specific callSign (e.g. Tanker) to a target to have consistent callSigns according to the chosen pattern
						add this to a target pattern/tanker in the targetList :
						predeterminedCallsign =  {
							groupNumber = 6,
							name = "Shell",
						},
529 fixed	[radio]		tanker frequencies are not grouped by identical targets or patterns
528 fixed	[generator]	take-off time does not match (again...)
527 fixed	[debrief]	debriefing is blocked on a base.x position issue with damaged CVN/LHA
526 add	[campaignMaker][M82]	Action.UnitResuscitateOrKill(unitName, liveOrKill, liveValue)
525 fixed	[flight]	flight delayed

==:20.81.524:==
524 modified	[loadout]
				-- V178 - Tu-22M3 no escort and Minscore 0.1  for TF-80-Full
				-- V177 - Mirage F-1EE big Fuel tank
				-- V176 - update of speed/altitude of MirageF1/Mig21/Su17 etc... from IIW following new consumption script 
523 modified	[consumption]	prohibits PC after takeoff. Don't worry, we reinstated it later (I think ^^).
522 modified	[loadout][consumption]	many loadouts updated to take fuel consumption into account. Consumption found thanks to new tool
					(there are still many, many loadouts to modify in the future)
521 fixed	[code_loadout]	loadout code is sometimes incorrectly recognized
520 fixed	[generator][MP]	there's never a “runway attack” spot for players
519 fixed	[generator]	it is sometimes impossible to generate a mission, as the generator skips missions one after the other
518 fixed	[generator][SEAD][MP]	there are never any SEAD (“client”) flights for PMs
517 fixed	[generator][SEAD][IA]	There are very few IA SEAD flights, if any.
516 modified	[helico][get-out]the “Get Out” menu F10 (essentially) for human helicopters has been revised: you can now leave a grounded helicopter even if it's undamaged. 
				Note that there's no confirmation of the action once you've clicked: you're free of your module ^^ . 
				This action creates an EjectedPilot that can be rescue later.
515 fixed	[helico]	despawn problem
514 fixed	[helico][SAR]	SAR flights are not activated						
513 added	[debug]		creates a folder for each mission-n in \Debug, very useful for debugging
512 modified	[generator]	added tools mission (campaignMaker)
511 fixed	[generator]	take-off time does not match
510 fixed	[generator][callsign]	callsign for wingman doesn't make sense
509 fixed	[debriefing][stats]	stats for your own package are rarely displayed
508 fixed	[debriefing][stats]	rescue” and ‘kill’ not counted correctly
507 fixed	[debriefing][stats]	rounding problem refusing a 100% destroyed target
506 fixed	[inter]		interceptors and CAPs ordered to leave a SAM zone no longer return to combat
505 fixed	[inter]		campaigns with dates prior to 1970 can freeze. Because of UNIX time
504 fixed	[inter]		some missile detections caused the interceptor script to fail

503 fixed	[helico]	it's sometimes impossible to get out of a damaged helicopter on some maps
502 added	[EWR]		text announcement of multiple environmental contacts, friend and foe alike. And only those detected by all EWRs and SAM radar. 
				Activate in menu F10 (testing) (M81)
501 modified	[intercept]	prohibiting interceptors from entering the enemy zone, by boundary design.
				Longer time spacing, to avoid all interceptors taking off in 15 minutes, leaving the zone unprotected for the rest of the mission.
500 modified	[IA]		interceptors and CAPs turn around when they enter a SAM zone, then position themselves above their own SAM zone before (normally) returning to combat.

499 modified	[loadout]
				-- V175 - tu-22D War over Chad Campaign
				-- V 174 - Su-17M4 (modification of certain speeds and altitudes)
				-- V 173 - code_loadout =  { "All" }, correction ! thanks BAMSE
498 fixed	[METAR]	cloud/METAR altitudes above 10000ft were not displayed
497 fixed	[target]	some destruction is not taken into account by DCE
496 modified	[target]	even more attention to target priorities, as the campaignMaker intended
495 modified	[MP] a higher probability of obtaining a flight in MP
494 modified	[parking]	aircraft dance on the parking lot and disappear (DCS bug)
493 fixed	[briefing][METAR]	cloud altitudes above 10000ft were not displayed
492 fixed	[briefing]	overwrite old briefing info from hours before mission generation
491 fixed	[time]		wrong time jump between missions

490 fixed	[cleaning]	Many Global variables have been renamed to start with a capital letter.
489 fixed	[SAR]	SARs no longer take off
488 fixed	[GCI]	interceptors go into the enemy camp
487 fixed	[loadout]	correction of -code_loadout =  { "All" } + modification of certain speeds and altitudes (Su-17M4)
486 added	[loadout]	Crusader - Skyraider - MiG-17F - HH-2D - SH-2F 
485 added	[alias]	added the Init\various_table file to use various tables, such as base name or aircraft type aliases  (M80) (TypeAlias[] & BaseNameAlias[] )
484 modified	[parking]	use of additional car parks, initially reserved for SARs

==:20.79.483:==
483 added	[release]	merging files for publication
482 fixed	[generator]	-nan(ind) bug again ...
481 fixed	[generator][MP]	no selection possible in PM when requesting an escort type task only (Sead etc...)
480 fixed	[generator]	-nan(ind) bug
479 fixed	[CLSID]		add the new parameters for bombs and GBUs if they exist (M79)
478 added	[LatLon]	add GPS-type information (latitude, longitude) for targets.  (M78)
						This will allow CampaignMaker to completely hide the units on the F10 map.
						(because before, this was the only way of recovering precise positions for GBU missions and the like).
						It's still an archaic method (which requires live reception in the DCS game), but I hope to add an autonomous LatLon information function in DCE_Manager (later... ^^)
477 modified	[loadout][restricted]	the prohibited items can now evolve over the course of the campaign. CampaignMaker must add them to a Loadouts folder, then activate them in the camp_triggers_init.lua file with the new function: Action.RestrictedLoadout(file)
476 fixed	[weather]	clouds are always lower than airports at altitude
475 fixed	[VSN_F105]	the required module name is not correct
474 added	[dataMap]	marianaislands LocationForEphemeris
473 fixed	[country]	new countries in templates are not added automatically
472 fixed	[ejectedPilot]	borders were no longer calculated, so ejected pilots no longer appeared
471 modified	[loadout]	WOB Mirage F1 Strike (correction)
470 modified	[Spotter]	we continue to integrate it (border, fireBase, only the marker, impact time, add smoke etc...)

==:20.76.469:==
469 fixed	[loadout]	WOB Mirage F1 Strike
468 fixed	[generator]	very few or no red flights
467 modified	[Spotter]	modified CG_ArtySpotter script (merge Solo&MP), from Don Rudi 
466 fixed	[loadout]	an error display problem
465 added	[DCE_Manager]	new DCEM_Function file to link with DCE_Manager 
464 added	[loadout]	V166 - F-4E for WOB - OH-58D
463 added	[Spotter]	add CG_ArtySpotter script, from Don Rudi (M77 testing...) thanks again for the permission to use his script :)
462 fixed	[frequency] SA342 frequency outside authorized ranges (again ^^)

==:20.76.461:==
461 fixed	[targetList]	priorities are no longer taken into account
460 added	[loadout]	add OH58D
459 fixed	[unit]	error activation of inactive units (due to base repair script)
458 fixed	[loadout]	NAM loadout (later) and No guided weapons for F-4E (bugged for IA)
457 fixed	[briefing]	various display bugs
456 added	[planes]	add VSN_F100, VSN_F105, Bronco, OH-6A
455 added	[trigger]	keep original triggers, for example, a trigger in base_mission that deletes forests and/or buildings (on request from BAMSE)
454 modified 	[loadout]	for campaingMaker, there's no need to rename pylon numbers, as the script does this automatically.
				example: For example, you can copy what's in " DCS.openbeta\MissionEditor\UnitPayloads" directly into the DCS loadout.
					["pylons"] = {
						[1] = {
							["CLSID"] = "{AGM_122_SIDEARM}",
							["num"] = 8,
						},
						[2] = {
							["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
							["num"] = 1,
						},

					DCE then adapts the pylon numbers for the mission loadout:
					["pylons"] = {
						[8] = {
							["CLSID"] = "{AGM_122_SIDEARM}",
						},
						[1] = {
							["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						
453 modified 	[radio]		news name of file :  	radios_freq_compatible to UTIL_DataRadio 
452 modified 	[loadout]	you can differentiate several users with a country table.
						This way, in the same campaign, you can have different loadouts with Italian F4s and Iranian F4s (for example).
							["Italy Crisis AIR/AIR AIM-9*4,AIM-7*4"] = {
								attributes = {},
								code_loadout =  {"IIW", "Crisis", "PG", "Revenge"},
								country = {"Italy","USA"},
							and
							["Iran Crisis AIR/AIR AIM-9*4,AIM-7*4"] = {
								attributes = {},
								code_loadout =  {"IIW", "Crisis", "PG", "Revenge"},
								country = {"Iran"},

451 add 	[Plane][loadout]add F-4E-45MC from Headblur 
450 add 	[bingo]		force RTB if bingo (testing)

==:20.74.449:==
449 fixed 	[moon][kola]	bug to calculate moon phases when the sun doesn't always set, as in Kola. Thanks BAMSE
448 fixed 	[Interceptor]	the rest of the bug fixed/removed/modified in getCategory()
447 fixed 	[Escort]	when the strikeOnlyWithEscorte option is activated, non-escort missions are generated.
446 modified	[targetList]	better consideration of the priority value of targets
					beware, the side effect is that DCE will put everything it can on the high-priority target(s). 
					This will leave far fewer resources for the others.
445 modified	[targetList]	you can mix static, vehicle and map elements in the same Target. (except for the runway, which is still a separate target)
					to avoid having (as before) 3 different types of target (Sukhumi Airbase, Sukhumi Airbase Strategics, Sukhumi AA)
					DCE will automatically add the class to each Target element. M74

					***addition of the "mainObjective" variable, which will be added to the important units. If these units are destroyed, the target is considered destroyed, even if the other "less important" units remain.

					["Sukhumi Airbase"] = {
						inactive = false,
						task = "Strike",
						priority = 16,
						additionalGroupName = {Sukhumi Airbase AA","Sukhumi Airbase support"},		--vehicle/ships/static groups (groupe-name) can be set like this (that are not "important" targets)
						additionalGroupName_MainObjective = {Sukhumi defense"},						--important group/unit that will count to define whether the target is neutralized or not
						picture = {""},
						elements = {
							[1] = {
								name = "Sukhumi Airbase 3rd Bat-1",									--statics (unit-name) can be set like this
								mainObjective = true,												--important unit that will count to define whether the target is neutralized or not (this variable will be automatically added for units in this "elements" table)
							},
							[2] = {
								name = "Sukhumi Airbase 3rd Bat-3",
							},
							[3] = {
								name = "Sukhumi Fuel Tank 3",
							},
							[4] = {
								name = "Sukhumi Control Tower",										--map elements: are the only ones you will need to enter XY positions for yourself here
								x = -219668.28125,
								y = 563758.0625,
							},
							[5] = {
								name = "Sukhumi Ammo Depot",
								x = -219592.921875,
								y = 564007.3125,
								mainObjective = true,
							},
444 fixed	[roster]	not all planes are available, especially on older campaigns currently in play
443 fixed	[timing]	long intervals between missions (on the order of several days) block available aircraft
442 added	[squad]		automatic squad transfer based on available/unavailable runways/bases (M73)
				fille oob_air with new variable : baseAlternative
				["base"] = "Al-Dumayr",
				["baseAlternative"] = {"Al-Dumayr", "Beirut-Rafic Hariri", "Tiyas"},
441 added	[conf_mod]	the type of inertial unit alignment (and therefore its duration) can be configured in conf_mod M72
440 modified	[requiredModules]third-party mod units, added with templates, do not indicate that the mod must be added .  
439 added	[loadout][restricted]	to block certain loadouts: add a "restricted_loadout.miz" mission file to \Init with all the aircraft/helico whose loadouts you have blocked. M71
438 modified	[data][inherited] to avoid duplicate registrations of certain similar modules (SA342M, SA342L etc...), add a heritage system 
					Data_divers = {	
					-- inheritedFrom = "F-14",	--copy radio frequency, failues ...
					-- inherited_APA_From = "F-14",	--copy AddPropAircraft

					one of the consequences is to transfer playable module information to the table:
					Data_divers = {
						playable = true,

437 modified	[failures]	random failures (SinglePlayer only) are customized to the correct device type (A-4, A-10, AV8, AJS37, C101, F-5E, M2000, MF1, F-14, F-15, F-18, F-86, L-39, MB339, Mig-21, JF-17, Ah-64, Ka-50, Mi-24)
436 fixed 	[spawn][heli]	AltitudeFloor helico spawn altitude too low or too high
435 fixed	[EWR]		sometimes the EWR frequencies do not match the briefing frequencies
434 added	[campaign] 	GroundZoneTarget (adds the possibility of counting unit completeness by zone) (M70)
					if a zone collapses and you feel that this could lead to the end of the campaign, do it like this:
					In targetlist_init, assign units to a zone (for example, zone A).
						["Syrian-3rd-Armored-Div-25th-Brig-Cie-4"] = {
						task = "Strike",
						zone = "A",
						priority = 8,

					In camp_triggers_init, add this condition:
						['Campaign End Loss 4'] = {
							['condition'] = 'GroundZoneTarget["red"]["A"].percent < 40',

433 add		[F10]		getOut (a allows you to remove the pilot from a crashed helicopter, for immediate or later recovery) (M69)
432 fixed	[generator]	there are still duplicate identifiers (unitId groupId)
431 modified	[SAR]		adds aids (goals to be reached) for ejected pilots' helitacking
430 fixed	[SAR]		pilots ejected from the current mission cannot be recovered
429 fixed	[SAR]		the alert parking areas reserved for SAR and CSAR were not cleared after each mission. This meant that the parking lots became unavailable.
428 modified	[heli]		helicopter speeds and altitudes have been corrected
427 modified	[heli]		hHover variables are transferred from the loadout to the data file
426 fixed	[briefing]	the campaign briefing sometimes disappears
425 add		[trigger]	add moveToAnotherBaseOrDeactivate
424 fixed	[campaign]	end of campaign bug
423 modified	[speed]		no longer recalculates all speeds (ATO_FlightPlan.lua), but relies on the Timing.lua script
422 fixed	[loadout]	 the script's laser sport doesn't work
421 modified	[escort]	makes escorts offensive from their home base
420 modified	[radio]		onlyVariableFrequency SA342
419 add		[AddPropAir]	radar apach -> loadout
418 fixed	[loadout]	some SEAD aircraft were not activated because the range was very, very short.
417 fixed	[AI]		sometimes AIs don't bomb, neither do AI wingmen
416 fixed	[L16]		new F16 datalink not working
415 add		[AFAC]		adds the Task: AFAC with mainly Reaper UAVs


==:20.67.414:==
414 modified	[loadout]	 Runway attack fixed for Falcon in Crisis over PG
413 modified	[loadout]	 all Runway attacks for Crisis planes
412 fixed	[destruction]	limits the destruction of map elements, especially when artillery is present. This could create a big lag at the start of a mission.
411 modified	[CAP]		doesn't give all the CAP at the start of the game
410 add		[AddPropAir]	Ka-50_3
409 add		[missionFile]	adjust small things/variables to resemble as closely as possible a mission file created by the DCS mission editor (formation Heli, jettison heli...)
408 add		[briefing]	pattern schedule info, debug mission time info
407 add		[missionFile]	do not add helicopter jettison option
406 fixed	[CAP]		the time between CAPs is too long
405 fixed	[RadioBalise]	permanent emission of ejection beacon if only one pilot ejects
404 fixed	[pedro]		Pedro lands and takes off again from another ship
403 fixed	[scriptInGame][DCE]	most destructions are no longer taken into account by DCE.
					This is a fix for a very old DCS bug that creates a bug in most scripters, with the getCategory() function.
402 modified	[INS][F-14]	to avoid INS drift problems, especially in MP, rapid alignment has been removed
401 fixed	[weather][time]	tolerance for % of time early or late (in relation to the day) works correctly (if onlyday=true, you can start a little before or a little after according to hourlyTolerance)
400 fixed	[weather][time]	advances 2 times the time when accepting a mission + 

399 fixed	[timing]	some CAPs are not created, and the transport task for players does not work (Hecule Mode)
398 modified	[altitude][heli]	helicopter spawn too high
397 fixed	[F-14]		many NavTargetPoints are repeated in the mission file 
396 add		[module]	adds "requiredModules" according to the info saved in the DATA file , exemple: Data_divers["Hercules"].requiredModules = true,	
395 modified	[CTLD]		add version 202310.01
394 modified	[mist]		add version 47.5.122
393 modified	[loadout]	tanker speed | Mi-24P Night capability |  E-3 AWACS altitude |Tomcat loadout with 2 AIM-54 fixed | 
				Runway attack loadouts for F-4E, F-5E-3, MiG-23MLD for IIW | SAR and CSAR night capabilities
				add Reaper for futur Task
392 fixed	[MP]		the mission generation does not always give the number of aircraft requested
391 modified	[CV]		no CVN turn to avoid INS offset

390 modified	[CV]		change the term CV from CVN to include all "carriers" (thanks Bamsi)
389 add		[datalink]	adds the information needed for the 2.9 DCS dataLink
388 modified	[altitude][spawn]changes the way you detect minimum altitude, useful for SPAWN against mountains and helico alti
387 modified	[MP]		script still modified to have the best chance of obtaining all the planes requested in MP
386 modified	[loadout]	F-16 SEAD firepower, Tanker speed, Mi-24 Night capa, bug with AV8BNA and fuel tanker
385 modified	[loadout]	the capability variable is deprecated. Only firepower will be used to calculate a route's score.
					In the future, we will orient firepower in this way:
					For example, for Air/air:
					1 Fox3 missile = firepower = 1
					1 Fox1 missile = firepower = 0.5
					so an F14 with 4 phoenix and 2 Sparrow will have a firepower of 5
384 fixed	[debrief]	some end of mission blocked due to incomplete information
383 modified	[threat]	inclusion of ZSU_57_2 in the threats. AIR threat calculation improved by taking Awacs and CAP patterns into account rather than their AirBase.
382 fixed	[CVN]		the CVN collides with the shore
381 modified	[hour]		uses the whole schedule, especially in the morning. And if onlyDayMission is selected, the hourlyTolerance variable is better taken into account, so 4% means starting 1 hour before dawn (for example).
380 add		[altitude][tanker]	an altitude can now be added for Tanker stations, this altitude will be given priority in the loadout.
					add to targetlist_init.So you can have 2 (or more) patterns in the same place but at different altitudes.
					targetlist_init : ["alt"] = 6096, --in meter
379 modified	[TOT]		TOTs are forced to use the entire available time slot 'uniformly
378 fixed	[ASM]		some missiles (e.g. used by B-52s) are no longer fired in salvos
377 fixed	[target]	avoids removing ground units which are targets
376 fixed	[radio]		some (older) aircraft could not obtain an HF frequency
375 modified	[loadout]	adds F-15ESE Anti-Runway tasks and others, and corrects some other values: (Harrier, Kh-31A standoff ...) 
374 fixed	[ASM]		Bombers equipped with air-to-ground missiles fire ammunition one by one, or not at all.
373 fixed	[antiShip]	anti-ship aircraft circling after drop
372 fixed	[ejectedPilot]	the ejectedPilot target can create a "tot" bug during mission generation
371 fixed	[target]	bombers with a standoff of more than 15km still fly over the target
370 add		[runway]	add runway attack (M66)
				will be integrated into the future Beyrout campaign. To integrate it into the old campaigns, wait a little longer or read the "complete" guide to the "environment" of this new task.
369 modified	[oob_air]	add airReinforceDelay option
368 modified	[conf_mod]	conf_mod and camp_init have been redesigned, giving you more modifiable values without having to restart the campaign
367 fixed	[briefing]	su25 and mirage were in imperial units
366 add		[scripts]	add (new) AirGroundAttackTask Mbot s script (M65)

==:20.65.365:==

365 add		[plane]		Add  Su-30 Su-34 (War of Beirut)
364 fixed	[radio]		bug with the M2000 radio (loading bug) and the Apache (doesn't have the same Package frequency as the others)
363 fixed	[builtMission]	strikeOnlyWithEscorte  = true, it no longer worked properly
362 fixed	[frequency]	F-15ESE, radio 2 UHF
361 add		[plane]		Add  F-15ESE
360 add		[METAR]		add turbulence and temperature 
359 add		[builtMission]	reduces the minscore automatically and gradually to avoid mission generation failures
358 add		[loadout]	SA342L _ Apache : AGM-114L & loadout update
357 fixed	[builtMission]	templates are not taken into account if firstmission.bat does not generate a mission the first time round
356 fixed	[intercept]	no lauch
355 mod		[weather]	inconsistency between the game weather and the season. The pHigh and pLow values of camp_ini are better taken into account
354 add		[plane]		Add  SA342L
353 add		[METAR]		customises the METAR for each base (just like the real thing) and also adds military colour to the METAR. 
				The METAR is also consistent for each aircraft/base in the MP game briefing.
352 add		[plane]		Add  L-39ZA
351 add		[METAR]		adds pressure in inches of Hg when imperial is selected
350 add		[METAR]		adds METAR to dynamic cloud presets, where possible
349 fixed	[weather]	very bad weather during a cold sector
348 add 	[SAR]		addition of an F10 command to list pilots, ejected, the MGRS box and ask them to activate their beacon radio
347 add		[selfLearning]	as a result of counting aircraft losses, forced escort and/or SEAD for certain packages
346 modified	[mission]	AIs can drop their charge if they are not escorted
345 fixed	[debrief]	certain elements of the mission are not taken into account (e.g. ship)
344 add		[SAR]		human SARs must now embark ejected pilots or hover over them (altitude < 45m, distance < 10m, speed < 0.2m/s)
				Information to help the pilot is given in a message when the helicopter is less than 100m from the ejected pilot.
343 add		[task]		Transport can be escorted
342 fixed	[SAR]		SARs on CVN spawn and block the runway
341 add		[selfLearning]	reveals SAMs that have already been fired, so these will be avoided or taken into account for subsequent flights
				(M65)
340 add		[task]		add forced tasks for a certain time if there are too many losses (in test), 
				e.g. transport planes can be automatically escorted after a certain number of kills
339 fixed	[ejected]	ejected pilots were rarely captured
338 fixed	[MP]		some of the plane selections were not working and were running in a loop
337 add		[SAR]		Add ejected radio and SAR radio according to the frequencies pre-registered in the conf_mod
336 add		[plane]		Add MB-339A

335 fixed	[stat]			some kills are not counted
334 fixed	[MP]			duplicate groupName 
333 fixed	[despawn]		aircraft associated with a BaseAirStart do not despawn
332 fixed	[station]		too many Tanker/AWACS in the area at the same time
331 modified	[station]		less fuel for Tanker/Awacs already in the area
330 add		[loadout][Ka-50]	add Ka-50_3
329 add		[loadout][F-1EE]	Barax added to Mirage F-1EE loadouts 
328 fixed	[IA]			AI aircraft/helicopters of the same type as yours do not attack.
327 fixed	[SAR]			too much manhunt, FPS killer
326 fixed	[third]			if the SC_CarrierIntoWind variable is set to "auto", the mission does not load.
325 modified	[files][beacon]		always adds the beacon.ogg file
324 modified	[files]			rewriting the way to integrate files and other briefing images
323 fixed	[CTLD]			JTACAutoLase is badly implemented and crashes the mission 
322 modified	[campaignMaker]		takes into account additions/modifications to the base_mission file during the campaign
321 add		[campaign]		automatically adds new items that appear in a new baseMission, during a campaign (such as FARP, Vehicle and Static) (in test) (M64)
320 fixed	[parking]		static aircraft prevent the taxiing of others.
319 fixed	[parking]		there is no more static aircraft
318 fixed	[parking]		static aircraft do not appear on the correct car park
317 modified	[prune][FARP]		dont prune Unit FARP if you add the term "FARP" in the unit name (unit not group name)
316 fixed	[FARP]			does not prune units that support FARP (also put FARP in the unit name)
315 modified	[structure][briefing]	DCS standard briefing name structure (thanks ldnz)
314 fixed	[briefing]		no flight plan
313 fixed	[briefing]		corrects duplicate briefings, adds the name of the radio etc...
312 modified	[mission][Bullseye]	you can lock the Bullseye to a base, and by selecting movedBullseye = false in the confmod
					add in db_airbases : selectedBullseye = true,
311 modified	[mission]		The planes escorting the helicopters will probably not be down there.
310 fixed	[intercept]		wrong interception heading
309 modified	[intercept]		adds a random number to the quantity of interceptors
308 modified	[frequency][EWR]	modifies only the EWR frequency (does not affect the ADF and other FARP frequencies)
307 add		[frequency]		frequency guard guard frequencies can be mistakenly selected for AWACS, EWR, package flights, etc.
306 various	[frequency]		more Divert, more Coalition Freq, bug list Freq
305 add		[frequency]		add MiG-15bis and Mosquitos, for the futur campaign (?)
304 fixed	[frequency]		bad frequency of Bf109 and Spitfire
303 modified	[frequency][Mig19]	allows to add all frequency ranges of airfields, so that some aircraft (Mig-19) can use it

==:20.63.302:==
302 fixed	[CSAR]		some ejectedPilots are missing from the MAP, and CSARs are moving to empty positions
301 modified	[loadout]	new loadout or adjustment for F-1EE, Viggen, Tchad campaing, 
300 fixed	[IA strike]	strikes do not attack MAP structures and simplifies MAP's building detection 
299 add		[mission]	place men looking for some ejectedPilot "Manhunt^^"
298 fixed	[campaign]	the transfer of replacement (reserve) aircraft does not take place 
297 fixed	[radio]		guard frequencies are sometimes used 
296 fixed	[Eventslog]	***provisionally cancelled***use "forbidden" characters for its name DCS plant DCE.
295 fixed	[task]		simultaneous task injections freeze the intelligence of AIs ^^
294 fixed	[M2000]		Radio: the red and blue radio sets are reversed
293 add		[plane]		Add all SA342 playable 
292 modified	[mission]	attempts to "dilute" all packages throughout the duration of the mission
291 modified	[MP]		all players' planes in the same target pack (where possible)
290 add		[IA]		the helicopters (all of them) try to follow the valleys (this is under test)
289 add		[plane]		Add Mirage  F-1EE
288 add		[Datacard]	makes DCE compatible with the use of programs such as Datacard Generator or CombatFlite (M63)
287 add		[third]		allows you to use third party files that Data information without being overwritten by central information updates (M62)
				--> use Init\ADD_data.lua

==:20.61.286:==
286 fixed	[generator]	not enough Strike missions for some aircraft 
285 fixed	[mission]	CustomGroupAttack no longer works 
284 fixed	[MP]		no target in the first generation 
283 modified	[code]		clean code

==:20.61.282:==
282 fixed	[EWR]		EWRs are not always added in the frequencies
281 fixed	[mission]	some circles are infinite
280 fixed	[mission]	some bombing does not work
279 fixed	[mission]	spawn in the air are sometimes conflicting
278 add		[option]	Add randomizeSkills option in conf_mod (made by SomethingSimple)
277 added	[maker]		Add Return.totalAirUnitAliveBySide("side") function in camp_triggers_init
276 added	[maker]		Add spyTarget, useful to find the cause of the refusal to target certain targets
275 modified	[timing]	gives more time to set up the player flight (SP and MP)
274 fixed	[SEAD]		some SAMs did not require a SEAD to fight
273 added	[maker]		adds an axis, an orientation for the Awacs/Tanker/Cap patterns.
						To do this, in the targetlist_init.lua file,
						To do this, in the targetlist file, add in an Awacs (or CAP or Tanker) table the variable :
							axis = 90, (in degrees)
						note: not sure if this works for those "hooked" to a CVN
272 fixed	[MP]		some aircraft in MP do not activate
271 fixed	[stat]	squadron reinforcements no longer work for the new campaign + poor accounting
270 fixed	[SAR]		SAR no longer finds the pilots

==:20.61.269:==
269 fixed	[debrief]	debrief bug
268 fixed	[mission]	some aircraft land just after the spawn
267 fixed	[SEAD]		there is no more SEAD mission
266 add		[CSAR]		add a CSAR mission
265 add		[SAR]		add a SAR alert
264 fixed	[stats]		the stats were taken into account even if we did not accept the result.
263 added	[SAR]		SAR helicopters will recover ejected pilots (up to about 60km from CVN)
262 added	[SAR]		Pedro's helicopters (CVN) will pick up the ejected pilots near the CVN (they simulate the recovery ^^) (MODIFICATION M61)
261 modified	[mission]	use new follow task for Pedro


.......

260 fixed	[debrief]	transport bug
259 fixed	[generator]	the HF frequency of the Mig-15 is not taken into account
258 modified	[generator]	the player in A4 is always in second position
257 fixed	[MP]		mission generation in PVP bug
256 fixed	[generator]	A-4E-C bug radio
255 modified	[mission]	boats start upwind
254 fixed	[radio]		correction radio F16
253 added	[generator]	verif if DCS Version < 2.7.0
252 added	[generator]	ensures that DCE chooses between several ship patrol areas
251 modified	[generator]	limit the number of aircraft to CAP and Interceptor to keep some for the rest (strike...)
250 fixed	[generator]	TACAN registration


==:20.60.249:==
249 added	[DCE]		compatible with the South Atlantic MAP
248 added	[mission]	WW2 planes in data file (testing)
247 fixed	[mission]	TACAN is not disabled with the KC-135MPRS
246 fixed	[DCE]		offset role == Anti-ship Strike
245 modified	[briefing]	adds departure times for all flights, on all bases
244 modified	[radio]	avoid using guard frequencies 243 and 121.5
243 modified	[radio]	reorganises the radio presets and fixes a bug on the F16
242 fixed	[radio]	duplicate Frequency
241 fixed	[radio]	tankers don't always respond
240 modified	[briefing]	adds the tanker type
239 modified	[mission]	tries to work around the TACAN bug in dcs with tanker rotation
238 added	[conf_mod]	choice of loading CTLD and mist scripts
237 fixed	[mission]	duplicate TACAN
236 added	[CampaingMaker]	adds debugging information
235 added	[data]		adds A-4 and Mig15
234 modified	[MP]		offers more possibilities to fly with a group
233 fixed	[MP]		inconsistent take-off times

==:20.60.232:==
232 modified	[loadout]	Cobras missile,  Hind, Apaches and Mi-8MT range, fixed F16, add L-39C, A-10C and C II, fixed F16 Cap in Crisis
231 fixed	[mission]	AI on small car parks can get stuck
230 modified	[code]		cleans up the debugging information

==:20.60.229:==
229 fixed	[MP]		some take-off times are impossible to meet if there are several customer flights
228 modified	[MP]		spawn the Recovery in the middle of the initial WPT 2 and 3
227 added	[CTLD][JTAC]	Attempting to integrate CTLD, using JTAC only (for the moment)(M60)
226 fixed	[MP]		diverting base, will not appear in the briefing in MP
225 modified	[mp]		clients take off from the ground, even if it creates a flight plan timing problem, start the mission earlier
224 fixed	[debrief]	confusion between target and air unit names
223 added	[ATC]		silences the ATC | useful for many multiplayer flights where the ATC talks and blocks repeatedly (except CVN)(M59 many thanks GC-22 Psyko)
222 added	[CampaingMaker]	deactivate a template
221 modified	[MP]		choose the number of aircraft recovery per flight
220 added	[MP]		floor altitude over Chypre on recovery planes
219 fixed	[generation]	schedule not taken into account between 2 missions
218 modified	[mp]		displays only the active targets in the target selection
217 added	[briefing]	add the names of the radios
216 added	[MP]		add common frequencies (coalition) on the maximum possible wave
215 fixed	[MP]		some client planes start in flight
214 modified	[MP]		force the different selected aircraft to fly in the same package

==:20.58.214:==
213 added	[plane]	AH-64
212 fixed	[mission]	plane tourne en rond si plus de cible
211 fixed	[mission]	the SpecificCallnames of the F16 do not work
210 fixed	[strike]	F-18 Jsow don't bomb
209 fixed	[mission]	some planes go around in circles during the spawn
208 fixed	[strike]	wingmen don't bomb
207 added	[mission]	adds M-2000C in Data_AddPropAircraft
206 fixed	[development]	bug with move ship (UTIL_KillTarget)

==:20.58.205:==
205 fixed	[MP]		les intercepteurs en Multi ne démarre pas sur piste et les recovery ne sont pas en l'air
204 fixed	[briefing]	bad info on the number of days left in case of good weather.
203 fixed	[mission]	bad EWR frequency
202 fixed	[briefing]	Lost end campaign image
201 fixed	[ALL]		Check and Help CampaignMaker
200 added	[DCE_Manager]	all ScriptsMod.NG files are finally indexed, and can be re-downloaded if you delete them
201 added	[F10 command]	FuelCheck only wingmen (F10)--ATTENTION, for the moment, only calibrated for the F18- -(M57)(Norman99's script, thanks ^^)
200 fixed	[oob_ground]	some targets destroyed in DCS are not destroyed in DCE
199 fixed	[briefing]	somme picture  are not included in the mission briefing
198 added	[briefing]	adds in the briefing the heading, distance, ETE and their total- - - - - - - - - - - - (M58)
197 fixed	[conf_mod]	some automatic update of conf_mod bug
196 added	[Campaign]	manual or automatic assignment of CallSigns to WEST squadrons, these CallSigns are final for the duration of the campaign- - - (M56) (Roll's idea)
195 added	[Campaign]	player can change the type of plane- - - - - - - - - - - - - - - - - - - - - - - - - - (M55) (testing)
194 fixed	[briefing]	some text are not included in the mission briefing
193 modified	[conf_mod]	changement des variables du PruneScript
192 fixed	[conf_mod]	automatic destruction if Skip
191 fixed	[IA flightPlan]	attack level too low
189 modified	[IA flightPlan]	completely redesign CustomTaskScript and TaskBombing- - - - - - - - - - - - - - - - - -(M54)

==:20.53.188:==
188 -fixed: new conf_mod update system crashes mission generation
187 -fixed: transport spots crash the mission generation
186 -added: automatic update of conf_mod items, your settings are preserved in most cases(MOD M53)
185 -added: A-10C and A-10C_2 EPLRS (thanks Scotch75) you can now easily add an EPLRS plane in the UTIL_Data.lua file
184 -fixed: airlift info
183 -fixed: does not work if the player is client
182 -modified: simplification of the loadout code, there is now an automatic detection, no need for the campConfMod table in the conf_mod.lua file
181 -modified: simplification of the "Reserves" variable and AirUnitReinforce function (for campaign Maker)
180 -added: campaign player's choices in conf_mod (MOD M52)
	slider_CampaignDuration  = 3.0,				-- (false/default: no change)(1: fast)(2: medium)(3: long/recommended)(4: very long)			influences the length of the campaign
	slider_EnemyLevel = 3.0,				-- (false/default: no change)(1: easy)(2: medium)(3: difficult/recommended)(4: very difficult)	changes the level of pilots, number of planes etc...
179 -added: AddPropAircraft: add this option for maximum aircraft/helicopter
	customizable option in the UTIL_AddPropAircraft.lua file
178 -fixed: a transport plane from a virtual base, orbiting
177 -fixed: bug DC_time 41
176 -fixed: planes/helico static spawn on players in some cases
175 -fixed: triggers are taken into account twice with the new system which allows to accept the mission or not
174 -fixed: insert template bug
173 -added: moonRise info
172 -added: info MoonPhase (NVG) (MOD M51)
171 -fixed: some Syrian base names have forbidden characters in lua
170 -added: adds an option to take off from the runway, only with the interception task
	intercept_hotstart = 1,						-- (1 or true: on parking/default)(2: on runway)(0 or false: cold start) player flights with intercept task starts with engines running 
169 -fixed: end campaign, backwards compatibility
168 -fixed: the end of the campaign does not work
167 -fixed: db_airbase not updated
166 -fixed: diverts frequency
165 -modified: setting a ARM timer
164 -fixed: bombers do not always drop
163 -fixed: no loadout statistics

==:20.50.161:==
161 : clean code
159 -add: Action.LogisticObjectif trigger
157 -add: now, with variable strikeOnlyWithEscorte = true, in conf_mod file, the packages will have their SEAD if it is necessary
155 -add: CVN_71/.../CVN_75 and SA-5 to the threat table
154 -add: counts the payload of the transport aircraft/helicopter and adds it to the base/place	 (modification M50)
153 -changed: change of location for the loadout file, which is now unique and central for all campaigns (cf 182)
152 -progress: scenary objects are not always counted destroyed
151 -fixed: killTarget bug
150 -remove: playable plane in conf_mod (MP)
149 -added: records loadout statistics (CampaignMaker)
148 -modified: randomly gives a loadout if several are possible
147 -added: routine code_campaign check
146 -modified: One big central db_loadout file for everyone (modification M49)
145 -add : campaignmaker
144 -modifief: alt 0 on target wpt
142 -fixed: no channels assigned to recovery aircraft (MP)
141 -modified: loadout_eligible (CampaignMaker)
138 -fixed: wing players do not have registered radio channels (MP)
137 -changed: recovery spawn at wpt 2 instead of 3 
	+ spawn at a minimum altitude, according to the altitude of the mountains, (according to a table to be filled in the future: UTIL_Data.lua)
136 -fixed: destroyed targets always appear in the choice list (MP)
135 -added: change side base (static, vehicule and targetlist)(CampaignMaker)
134 -added: accept the result even without generating a new mission (MP) (modification M48)
133 -added: change side base (CampaignMaker)

==:20.47.132:==
113 -fixed: the position of the templates is bad when moving
114 -mod: display of flight information (MP)
115 -fixed: AI plane landing after spawn in air (MP)
116 -fixed: the group frequency of Mig19 is incompatible and blocks the loading of the mission
117 -fixed: no EWR freq for Mig19
118 -fixed: RTB doesn't work (thanks @Bonfor)
119 -added: get strike or SEAD only packages to RTB (thanks @Bonfor)
120 -fixed: transport aircraft do not land at the destination base
121 -fixed: RTB's escorte doesn't work (thanks @Bonfor)
122 -fixed: ATC freq out of wave of Mil24
123 -add: Help CampaignMaker : find static in template file
124 -fixed: AI plane landing after spawn in air (MP) (again)
125 -fixed: during a "skipMission" the incremental saving of old missions is not done
126 -Changed: moves the radios_freq_compatible file and keeps retroCompatibility	
128 -fixed: the orientation of the template units is not taken into account
129 -fixed: frequencies are not assigned for some aircraft (Tanker, AWACS, F15 etc...)
130 -fixed: EWR bad frequency
131 -fixed: recovery planes spawn in the mountains(testing in Caucasus)
132 -fixed: EWR bad frequency#2

==:20.47.112:==
112 -added: channel 0 for the Mi-24

==:20.47.111:==
111 -fixed: freezing due to a missing briefing image
110 -fixed: bug import template
109 -fixed: bug if no Bullseye

==:20.47.108:==
108 -fixed: see the debugging information

==:20.47.107:==
107 -fixed: bullseyes assigned on a CVN
106 -adds: debug file of the mission generation inserted in the mission
105 -adds: also gives the choice to save only the last mission
104 -adds: M47 keeps the history of the campaign files
103 -fixed: CVN's IA aircraft that spwan in flight are late


==:20.46.102:==
94 -fixed: some planes land at the beginning of the mission
95 -fixed: bug Deck
96 -fixed: bug trigger
97 -fixed: bug spawnAir MP
98 -fixed: bug Deck
99 -fixed: taxiing schedules are wrong
100 -fixed: bug Deck
101 -fixed: bug Deck
102 -added: SinglePlayer with dedicated server Full plane


==:20.46.93:==
-- M46 -Added- : SinglePlayer with dedicated server
93 -added: SinglePlayer with dedicated server

==:20.45.91:==
-- M45 -Added- : compatible with 2.7.0 

71 -fixed: in MP, all available tasks are not displayed if there are several squadrons of the same type of plane
72 -fixed: in Mp, not enough AI wingers offered if only one plane is selected
73 -added: compatible with 2.7.0
74 -fixed: crew do not catapult the F14 and F18
75 -fixed: the probability of bad weather is incorrect
76 -fixed: too many clouds on a desert map
77 -changed: order of spawn on the deck.
78 -fixed: some planes do not taxi
79 -fixed: in the MP form, proposes targets already destroyed
80 -fixed: taxiing times are bad
81 -fixed: the player cannot spawning on the sixpack even if there is space available
82 -fixed: too much or too little aircraft on the deck.
83 -added: Check and Help CampaignMaker
85 -fixed: the player cannot spawning on the sixpack even if there is space available
86 -added: manual despawn of the planes blocking the deck.
87 -added: despawn aircraft landing on CVN and LHA (option conf_mod)
88 -fixed: planes blocked because of the sixpack
89 -added: version of scriptsmod in the mission file
90 -fixed: planes don't take off
91 -fixed: bug at mission generation, line 3819
92 -fixed: in MP, the planes that spawn in flight appear at the beginning of the mission and land immediately

==:20.44.70:==
-- M44 -Added- : Template Active GroundGroup moving front

==:20.43.42:==
==:20.44.70:==
-- M43 -Added- Assignment of C08 type parking lot numbers

34 -Changed- fair task between squadrons
35 -fixed- LHA & FARP, flight start if there is no more space on the ground
36 -Changed- changes the display of "harrier" numbers: 810 is now displayed: 18
37 -fixed- customTask helicopters are now taken into account
38 -fixed- hour catapulting, if several CVNs are in the same group
39 -Changed- speed too low until the waypoint "join".
40 -Removed- Eagle modification on Ato_FlightPlan concerning helicopters and FARP
41 -Changed- for static aircraft, look at the space available according to the minutes

45 -fixed- CallTankRefuel + Help CAP, all coalition

47 -fixed- the static planes disappear after 3mn.
48 -fixed- speed too low for escort aircraft, following very slow aircraft (A-10)
49 -Changed- Help CAP , all coalition

53 -fixed- management of the offset flight or ground appearances
54 -Changed- despawn Plane on BaseAirStart

57 -fixed- fair task between squadrons
58 -fixed- custom FrequenceRadio  Radio AWACS
59 -Changed- possibility to use EWR in WEST language
60 -fixed- number of static aircraft based on the remaining space
61 -fixed- custom FrequenceRadio  (number expected, got string)
62 -Changed- Custom Briefing ( Divert/CVN possible)
63 -Added- for debugging adds the following info: mission name, script version, SavedGames path, campaign version
64 -fixed- Custom Briefing (f: Divert/CVN possible)
65 -fixed- F14 limited to 2 in MP
66 -fixed- helicopter on helipad (Reinstatement of a previously deleted Eagle's modification ^^)
67 -fixed- lack of frequency on the divert base blocks mission generation
68 -fixed- helicopter on FARP, LHA and parking delay occupation
69 -Added- assignment of parking with a simple numbering
70 -fixed- E2 retreat doesn't work

==:20.42.33:==
-- M42 -Added- liveryModex
	- displays a High res or CAG skin to the boss, also allows to display a skin especially to a plane number.

	- Gives the CAG aircraft number to the player, only in singlePlayer.

	- And gives priority to the most important aircraft numbers (ex 200) to the group leader.
	
	oob_air_init.lua :
	liveryModex = {									--unit livery Modex  (optional)
		[100] = "VF-101 Dark",
		[110] = "VF-101 Grim Reapers Low Vis",
		},


28 -fixed- Inteceptor
29 -fixed- Scratchpad 
30 -fixed- altitude too high for helicopters
31 -Added- Frequency FARP add in Mission file
32 -Changed- Custom Briefing TACAN tanker only if necessary + display of take-off times only at the right platform (CVN FARP)
33 -Added-weighting tasks between different squadrons

==:20.41.27:==
-- M41 -Added- Sratchpad : automatically writes to the Sratchpad file
	writes automatically in the scratchpad mod file, (for the moment, only works if DCS is not launched)


11 -Added- addition of Divert fields in the briefing
12 -fixed- to avoid blocking the naval task force, creates 2 small bends instead of one big one.
13 -Added- addition of VOR ILS etc. information in the Divert briefing

15 -Added- TakeOff Pedro Helicopter
16 -fixed- Scratchpad written in the Sratchpad file, if this modul is installed
17 -fixed- Despawn Landing CVN + FARP, with new CVN
18 -Added- ability to customize CVN frequencies in the Init/db_airbases file	
	Init/db_airbases		ATC_frequency = "250.255",
19 -Added- added the version of the campaign in the file camp_init

21 -Changed- reinforces the form on user input errors 

26 -Added- Parking limite little base, allows to place more aircraft than parking space
27 -fixed- CVN Manual Freq, frequency update

==:20.40.06(10):==
-- M40 -Added- Pedro (plane guard) This helicopter takes off, then follows the CVN despite the turns

Corrections:
01 -fixed- less angular boat turning

03 -Changed- priority to the player's frequencies
04 -Added-  MenuRadio request manual TurnIntoWind, 
	Init/conf_mod
		Chapter: mission_ini
		Add SC_CarrierIntoWind "auto" or "man":
				SC_CarrierIntoWind = "auto",				-- (defaut: "auto")("man"), "auto": Original Mbot code: the CVN rotates according to the air operations. "man": the CVN runs only once via the commands in the radio menu F10 
05 -fixed- radio frequency range F14 and F18
06 -fixed- SuperCarrier : add altitude and speed to units spawn in flight
07 -Changed- custom FrequenceRadio (i  3 frequency bands) rewriting of the automatic choice of frequency ranges
08 -fixed- fix all pb FrequenceRadio
09 -fixed- recovery interceptor

==:20.39.33:==
-- M39 -Added- Several types of aircraft for escort at the same time

01 -fixed- vCruise by default 
02 -fixed- deletes the camp.player table which mistakenly keeps the table in the Active folder.
03 -Changed- change freq EWR + custom FrequenceRadio, automatically calculates the usable radio frequency range, we delete the radio table from camp_init
04 -Changed- Multiplayer : number of flight group Client undefined ^^
05 -Added-  VHF helicopter
06 -fixed- Multiplayer : traitor plane (he turns around)
07 -Added- saved game on another DD
08 -Changed- Multiplayer : shield the form, debugging the multiplayer skip that was no longer offering a plane
09 -Added- Multiplayer : choice by target and task
10 -fixed- Multiplayer : replaces #mission.trig.func which doesn't start at 0 anymore, so impossible with #.
11 -fixed- Multiplayer :Task table
12 -Changed- cosmetique formulair + generator task 
13 -fixed-  prunescript category tag/ helico MP
14 -fixed- form MP
15 -fixed- Multiplayer : In multiplayer, this allows you to control an aircraft already in flight in case of a crash.
16 -Added- Check and Help CampaignMaker
17 -fixed- FARPS
18 -fixed- 3 choix assuré
18 -Changed- different Type possible/task
19 -fixed- frequence Min Gazelle vs A10
20 -fixed- Spawn before Departure 
21 -fixed- different Type possible/task ++
22 -Added- Check and Help CampaignMaker: warns the CampaignMaker of a missing nation
23 -Changed- robust form 
24 -Changed- keeps half of the staff for the escort
25 -Changed- prohibits an unescorted strike
26 -Added- Multiplayer limit escort number, option in conf_mod : ["limit_escort"] = 8,
27 -fixed- Gazelle
28 -fixed- Multiplayer EscorteTot-max
29 -Added- Check and Help CampaignMaker Check conf_mod
30 -Changed- prohibits aircraft/helicopter ecort
31 -Added- helps CampaignMaker to balance the game (type "Z" in firstmission.bat)
32 -Added- escort mandatory or not
	add in conf_mod.lua : 
	campMod = {
		strikeOnlyWithEscorte = false, 		-- (default : true) strikes are possible with only one escort
	}
33 -Changed- helps CampaignMaker: checks only the right  theatre

==:20.38.08:==
-- M38 -Added- Check Name Target error

==:20.37.23:==
-- M37 -Added- Adding the supercarrier conf_mod :
	CVN_CleanDeck
	CVN_Vmax
	CVN_windDeck
	SC_FullPlaneOnDeck
	SC_SpawnOn = {
		["F-14B"] = "deck",
		["E-2C"] = "catapult", 
		["S-3B Tanker"] = "air"
		
	SC_UseTurnCarrier

	F10 : Adding the F10 command : despawn plane (beta)

-- M36 -Added- F10 command :  Help CAP
-- M35 -Added- the scriptsmod folder will be named according to the scriptsmod version + simplification of the bat file, the path will now be managed in Init/path.bat
-- M34 -Added- EWR frequencies will be assigned according to the frequencies in camp_ini
	->radio custom: check frequency ranges and channel number before assigning it

Divers:
	Hide Windows Error Boxes
	Adds a radio channel MP (briefing)
	radio Su27
	Adds a catapult schedule  (briefing)
	
==:20.33.03:==
]]--
-- M33 -Added- Custom Briefing (onBoardNum) ajoute les numeros des avions du flight du joueur 
-- M32 -Added- E-2C Automatic Retreat
-- M31 -Added- Remove all static aircraft from the deck  : Important for MP !
-- M30 -Added- Desactive TriggerStart : when desactivate Planned mission can be used without problems for attack planes but there can be lags
-- M29 -Added- Menu F10 Refueling + RTB package + Info Bingo Wingman
-- M27 -Added- movedBullseye
-- M26 -Added- destroys the last targets automatically, avoids a package for a single remaining target
-- M25 -Added- added an option to get only Daytime : If you don't want to fly night missions 
-- M24 -Added- automatic configuration for MP (prunescript, static aircrafts on the deck, etc...)
-- M23 -Added- Delete all USN Deckcrew mod units without editing base mission
-- M22 -Added- limits unwanted detections : used to Intercept missions
-- M20 -Added- add failures and change game options 
-- M19 -Added- RepairGround ||  Targets objets can be repaired if purcentage of destruction is over 25 % by default
-- M18 -Added- destroy Plane Landing CVN 
-- M17 -Added- (Option F-14B), load loadout or confmod
-- M16 -Added- SpawnAir B1b & B-52
-- M14 -Added- versionning
-- M13 -Added- Performance: increases the speed of mission generation, a little
-- M12 -Added- Skill
-- M11 -Added- Multiplayer, still in TEST, PVP possible, separate briefing, separate images
-- M09 -Added- Prune Script
-- M05 -Added- ajout picture Briefing + pictures Target
-- M01 -Added- DataLink 