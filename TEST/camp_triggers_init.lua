--Initial campaign triggers (static file, not updated)
--Copied to Status/camp_triggers.lua in first mission and subsequently read and updated there
--Campaign triggers are defined with conditions and actions
-------------------------------------------------------------------------------------------------------

--List of Return functions to build conditions:
--Return.Time()												returns time of day in seconds
--Return.Day()												returns day of month
--Return.Month()											returns month as number
--Return.Year()												returns year as number
--Return.Mission()											returns campaign mission number
--Return.CampFlag(flag-n)									returns value of campaign flag
--Return.AirUnitActive("UnitName")							returned boolean whether the air unit is active			
--Return.AirUnitReady("UnitName")							returns amount of ready aircraft in unit
--Return.AirUnitAlive("UnitName")							returns amount of ready and damaged aircraft in unit
--Return.AirUnitBase("UnitName")							returns the name of the airbase the unit operats from
--Return.AirUnitPlayer("UnitName")							returns boolean whether the air units is playable
--Return.TargetAlive("TargetName")							returns percentage of alive sub elements in target
--Return.UnitDead(unitname)									(ADD) return vehicle/ship units dead (ADD)
--Return.GroupHidden("GroupName")							returns group hidden status
--Return.GroupProbability("GroupName")						returns group spawn probability value between 0 and 1
--Return.ShipGroupInPoly(GroupName, PolyZonesTable)			(ADD) return boolean whether ship group is in polygon (ADD)
--Return.PlaceLogistic("AirbaseName")						returns the logistics of a base in weight which can be increased by the landing of transport aircraft or helicopters


--List of Action functions for trigger actions:
--Action.None()																				--void action
--Action.Text("your briefing text")															--add briefing text
--Action.TextPlayMission(arg)																--add trigger text to briefing text of this mission only if it is playable
--Action.SetCampFlag(flag-n, boolean/number)												--set campagn flag to value
--Action.AddCampFlag(flag-n, number)														--add or subtract to campaign flag
--Action.AddImage("filname.jpg")															--add briefing picture
--Action.CampaignEnd("win"/"draw"/"loss")													--end campaign
--Action.TargetActive("TargetName", boolean)												--set target active/inactive
--Action.AirUnitActive("UnitName", boolean)													--set unit active/inactive
--Action.SideBase("side", "BaseName")														--change le camp d'une base, ATTENTION, deplacer les unites avant--Action.SideBase("blue", "Incirlik Airbase")
--Action.AirUnitBase("UnitName", "BaseName")												--set unit base
--Action.AirUnitPlayer("UnitName", boolean)													--set unit playable
--Action.AirUnitReinforce("SourceUnitName", "DestinationUnitName", destNumber)				--send reinforcement aircraft from one unit to another
--Action.AirUnitRepair()																	--repair damaged aircraft in all air units
--Action.GroundUnitRepair()																	-- (ADD) M19.f : Repair Ground
--Action.AddGroundTargetIntel("sideName")													--add ground target intel updates to briefing
--Action.GroupHidden("GroupName", boolean)													--change vehicle/ship group hidden status
--Action.GroupProbability("GroupName", number 0-1)											--change vehicle/ship group probability status
																							--due to the way stats are reset for a new playrun upon completing a FirstMission, groups probability changed by trigger in first mission will not be carried over to second mission! Repeat trigger on second mission or use the trigger from mission 2 on only for flawless function.
--Action.GroupMove(GroupName, ZoneName)														-- (ADD) move vehicle group to refpoint (See the DC_CheckTriggers.lua file for more explanation)
--Action.GroupSlave(GroupName, master, bearing, distance)									-- (ADD)
--Action.ShipMission(GroupName, WPtable, CruiseSpeed, PatrolSpeed, StartTime)				-- (ADD) assign and run a movement mission to a ship group (See the DC_CheckTriggers.lua file for more explanation)
--Action.TemplateActive(TabFile)															-- (ADD) M40 : Template Active GroundGroup moving front (single file : active template) (if tab file: random activation)



--Important notes:
--for condition and action strings: outside with single quotes '', inside with double quotes ""!

camp_triggers = {
	
	----- CAMPAIGN INTRO ----
	["Campaign Briefing"] = {										--Trigger name
		active = true,												--Trigger is active
		once = true,												--Trigger is fired once
		condition = 'true',											--Condition of the trigger to return true or false embedded as string
		action = {													--Trigger action function embedded as string
			'Action.Text("NAM 1965-74")',			
			'Action.AddImage("Newspaper_FirstNight_blue.jpg", "blue")',
		},
	},
	
	
	----- CAMPAIGN END -----
	["Campaign End Victory 1"] = {
		active = true,
		once = true,
		condition = 'GroundTarget["blue"].percent < 40 and Return.Mission() > 6',
		action = {
			'Action.CampaignEnd("win")',
			'Action.Text("Allied forces completely destroyed the NVA forces. Good game.")',
			'Action.AddImage("Newspaper_Victory_blue.jpg", "blue")',
			'NoMoreNewspaper = true',
		},
	},
	["Campaign End Victory 2"] = {
		active = true,
		once = true,
		condition = 'Return.totalAirUnitAliveBySide("red") < 5 and Return.Mission() > 6',
		action = {
			'Action.CampaignEnd("win")',
			'Action.Text("The NVA Air Force is in ruins. After repeated air strikes and disastrous losses in air-air combat, the NVA are no longer able to produce any sorties or offer any resistance. The US now owns complete air superiority.")',
			'Action.AddImage("Newspaper_Victory_blue.jpg", "blue")',
			'NoMoreNewspaper = true',
		},
	},
	-- ["Campaign End Victory 3"] = {
		-- active = true,
		-- once = true,
		-- condition = 'GroundZoneTarget["blue"]["A"].percent < 25',
		-- action = {
			-- 'Action.CampaignEnd("win")',
			-- 'Action.Text("Allied forces completely destroyed the Syrian army. Good game.")',
			-- 'Action.Text("Les forces alliees ont totalement detruit l armee syrienne. Bien joue.")',
			-- 'Action.AddImage("Newspaper_Victory_blue.jpg", "blue")',
			-- 'NoMoreNewspaper = true',
		-- },
	-- },
	["Campaign End Loss"] = {
		active = true,
		once = true,
		condition = 'Return.AirUnitAlive("469th TFS") < 2',
		action = {
			'Action.CampaignEnd("loss")',
			'Action.Text("Ongoing combat operations have exhausted your squadron. Loss rate has reached a level where reinforcements are no longer able to sustain combat operations. With the failure of Allied Air Force to attain air superiority, US Central Command has decided to call of the air campaign against the enemy. Without destroying enemy airbases it seems unlikely that the coalition will be able to win this war.")',
			'Action.Text("Les operations de combat en cours ont epuise votre escadron. Le taux de pertes a atteint un niveau tel que les renforts ne sont plus en mesure de soutenir les operations de combat. Face a l echec des des forces aeriennes alliees a atteindre la superiorite aerienne, le Commandement central americain a decide de stopper la campagne aerienne contre lennemi. Il semble peu probable que la coalition puisse gagner cette guerre.")',
			'Action.AddImage("Newspaper_Defeat_blue.jpg", "blue")',
			'NoMoreNewspaper = true',
		},
	},
	-- ["Campaign End Loss 2"] = {
		-- active = true,
		-- once = true,
		-- condition = 'Return.TargetAlive("Beirut-Rafic Hariri Airbase") == 0 or Return.TargetAlive("Beirut-Rafic Hariri Airbase Runway") == 0 ',
		-- action = {
			-- 'Action.CampaignEnd("loss")',
			-- 'Action.Text("After the Beirut-Rafic Hariri Airbase has been hit and crippled by air strikes the libanese defense collapsed and it will be impossible for NATO to save this country. This is a bitter defeat.")',
			-- 'Action.Text("Apres que la base aerienne de Beyrouth-Rafic Hariri ait ete touchee et paralysee par des frappes aeriennes, la defense libanaise s est effondree et il sera impossible pour l OTAN de sauver ce pays. C est une defaite amere.")',
			-- 'Action.AddImage("Newspaper_Defeat_blue.jpg", "blue")',
			-- 'NoMoreNewspaper = true',
		-- },
	-- },
	-- ["Campaign End Loss 3"] = {
		-- active = true,
		-- once = true,
		-- condition = 'GroundTarget["red"].percent < 60',
		-- action = {
			-- 'Action.CampaignEnd("loss")',
			-- 'Action.Text("Syrian airforce was able to destroy enough allied forces to decide US Command to ask for a cease fire  and stop any Air missions. This is a bitter failure for the Allies.")',
			-- 'Action.Text("L armee de lair syrienne a reussi a detruire suffisamment de forces alliees pour decider le commandement americain de demander un cessez-le-feu et d arreter toute mission aerienne. C est un echec cuisant pour les Allies.")',
			-- 'Action.AddImage("Newspaper_Defeat_blue.jpg", "blue")',
			-- 'NoMoreNewspaper = true',
		-- },
	-- },
	["Campaign End Draw"] = {
		active = true,
		once = true,
		condition = 'MissionInstance == 40',
		action = {
			'Action.CampaignEnd("draw")',
			'Action.Text("The air campaign has seen a sustained period of inactivity. Seemingly unable to complete the destruction of the Russian Air Force and infrastructure, US Central Command has called off all squadrons from offensive operations. We hope negociations with Russians will convince them to stop attacks in Georgia")',
			'NoMoreNewspaper = true',
		},
	},

----- CAMPAIGN SITUATION -----
	["Campaign first destructions"] = {
		active = true,
		once = true,
		condition = 'GroundTarget["blue"].percent < 100 and Return.Mission() > 1',
		action = {
			'Action.Text("First targets have been destroyed. Keep up the good work")',
		},
	},
	["Campaign 20 percents destructions"] = {
		active = true,
		once = true,
		condition = 'GroundTarget["blue"].percent < 80 and Return.Mission() > 1',
		action = {
			'Action.Text("Enemy targets have sustained fair damages. Keep up the good work")',
		},
	},
	["Campaign 40 percents destructions"] = {
		active = true,
		once = true,
		condition = 'GroundTarget["blue"].percent < 60 and Return.Mission() > 1',
		action = {
			'Action.Text("Enemy targets have sustained great damages. Strike missions are really efficient and we will win this war soon")',
		},
	},
	["Campaign 50 percents destructions"] = {
		active = true,
		once = true,
		condition = 'GroundTarget["blue"].percent < 50 and Return.Mission() > 1',
		action = {
			'Action.Text("More than half of our targets are neutralized. Intelligence think that the enemy will ask for a cease fire soon")',
		},
	},
	-- ["Campaign Red first destructions"] = {
		-- active = true,
		-- once = true,
		-- condition = 'GroundTarget["red"].percent < 100',
		-- action = {
			-- 'Action.Text("The enemy destroyed its first allied targets, you must defend them.")',
		-- },
	-- },
	-- ["Campaign Red 20 percents destructions"] = {
		-- active = true,
		-- once = true,
		-- condition = 'GroundTarget["red"].percent < 80',
		-- action = {
			-- 'Action.Text("The enemy destroyed nearly 20 percents of allied targets, you must defend them.")',
		-- },
	-- },
	-- ["Campaign Red 30 percents destructions"] = {
		-- active = true,
		-- once = true,
		-- condition = 'GroundTarget["red"].percent < 70',
		-- action = {
			-- 'Action.Text("Allies troops have sustained great damages. Enemy strike missions are too efficient and they will win this war soon")',
		-- },
	-- },
	-- ["Campaign Red 35 percents destructions"] = {
		-- active = true,
		-- once = true,
		-- condition = 'GroundTarget["red"].percent < 65',
		-- action = {
			-- 'Action.Text("Too much allied troops are neutralized. We will ask for a cease fire soon")',
		-- },
	-- },

	----- CARRIER MOVEMENT -----
	["TF-59 Patrol At Sea"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() >= 1',
		action = 'Action.ShipMission("TF-59", {{"TF-59-1", "TF-59-2", "TF-59-3", "TF-59-4"}}, 10, 8, nil)',
	},	
	
	 --test change weather
    ["test weather hiver"] = {
        active = true,
        once = true,
        condition = 'Return.Mission() > 1',												----'camp.date.month >= 10 or camp.date.month <= 3',
        action = 'Action.SetWeather( "weather = { pHigh = 78, pLow = 22, refTemp = 30, weatherChangeRate = 0.12 }" )',
    },
	
	------ RESTRICTED LOADOUTS ------
	["test restrictedLoadoutnamstart"] = {  --- 1965 Start--- 
        active = true,
        once = true,
        condition = 'Return.Mission() > 0',
        action = {
        'Action.RestrictedLoadout("restricted_loadoutnamstart.miz")',    
        },
    },
    ["test restrictedLoadoutnam2"] = {
        active = true,
        once = true,
        condition = 'Return.Mission() > 2',          --- 1965 late --- 
        action = {
        'Action.RestrictedLoadout("restricted_loadoutnam2.miz")',    
        },
    },
	["test restrictedLoadoutnam3"] = {				--- 1969 ----	
        active = true,
        once = true,
        condition = 'Return.Mission() > 4',
        action = {
        'Action.RestrictedLoadout("restricted_loadoutnam3.miz")',    
        },
    },
	["test restrictedLoadoutnam4"] = {				--- 1972  ----
        active = true,
        once = true,
        condition = 'Return.Mission() > 6',
        action = {
        'Action.RestrictedLoadout("restricted_loadoutnam4.miz")',    
        },
    },
	
	----- TARGETS ACTIVATIONS ------
	
	["Training_targets template activate"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 0',
		action = {		
		'Action.TemplateActive("Training_targets.stm", true)',
		},
	},
	["Training_targets_IA template activate"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 0',
		action = {		
		'Action.TemplateActive("Training_targets_IA.stm", true)',
		},
	},
	["Training_targets Deactivate"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 1',
		action = {
		'Action.TargetActive("Training_targets", false)',
		'Action.TemplateDeactivate("Training_targets.stm")',
		},
	},	
	["Training_targets_IA Deactivate"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 1',
		action = {
		'Action.TargetActive("Training_targets_IA", false)',
		'Action.TemplateDeactivate("Training_targets_IA.stm")',
		},
	},
	["Recon Hanoi high Activation"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 1',
		action = {
		'Action.TargetActive("Recon Hanoi high", true)',
		},
	},
	["Recon Hanoi low Activation"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 1',
		action = {
		'Action.TargetActive("Recon Hanoi low", true)',
		},
	},
	["Recon Haiphong high Activation"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 1',
		action = {
		'Action.TargetActive("Recon Haiphong high", true)',
		},
	},
	["Recon Haiphong low Activation"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 1',
		action = {
		'Action.TargetActive("Recon Haiphong low", true)',
		},
	},
	["Tanker Track E1 Activation"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 20',
		action = {
		'Action.TargetActive("Tanker Track E1", true)',
		},
	},
	["Tanker Track E2 Activation"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 20',
		action = {
		'Action.TargetActive("Tanker Track E2", true)',
		},
	},
	["Tanker Track E3 Activation"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 20',
		action = {
		'Action.TargetActive("Tanker Track E3", true)',
		},
	},
	["Tanker Track E4 Activation"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 20',
		action = {
		'Action.TargetActive("Tanker Track E4", true)',
		},
	},
	["Tanker Track Navy1 Activation"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 20',
		action = {
		'Action.TargetActive("Tanker Track Navy1", true)',
		},
	},
	["Tanker Track Navy2 Activation"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 20',
		action = {
		'Action.TargetActive("Tanker Track Navy2", true)',
		},
	},
	["Tanker Track Navy3 Activation"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 20',
		action = {
		'Action.TargetActive("Tanker Track Navy3", true)',
		},
	},
	["Tanker Track Navy4 Activation"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 20',
		action = {
		'Action.TargetActive("Tanker Track Navy4", true)',
		},
	},
	["Sweep Ho Chi Mihn"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 1',
		action = {
		'Action.TargetActive("Sweep Ho Chi Mihn", true)',
		},
	},
	["Sweep Khe Sanh"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 2',
		action = {
		'Action.TargetActive("Sweep Khe Sanh", true)',
		},
	},
	["VC_Inf_camp-1"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 1',
		action = {
		'Action.TargetActive("VC_Inf_camp-1", true)',
		},
	},
	["VC_Inf_camp-2"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 1',
		action = {
		'Action.TargetActive("VC_Inf_camp-2", true)',
		},
	},
	["VC_Inf_camp-3"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 1',
		action = {
		'Action.TargetActive("VC_Inf_camp-3", true)',
		},
	},
	["VC_Inf_camp-4"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 1',
		action = {
		'Action.TargetActive("VC_Inf_camp-4", true)',
		},
	},
	["VC_Inf_camp-5"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 1',
		action = {
		'Action.TargetActive("VC_Inf_camp-5", true)',
		},
	},
	["VC_Inf_camp-6"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 1',
		action = {
		'Action.TargetActive("VC_Inf_camp-6", true)',
		},
	},
	["VC_Inf_camp-7"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 1',
		action = {
		'Action.TargetActive("VC_Inf_camp-7", true)',
		},
	},
	["VC_Inf_camp-8"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 1',
		action = {
		'Action.TargetActive("VC_Inf_camp-8", true)',
		},
	},
	["VC_Inf_camp-9"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 1',
		action = {
		'Action.TargetActive("VC_Inf_camp-9", true)',
		},
	},
	["VC_ammo_fuel_storage-1"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 1',
		action = {
		'Action.TargetActive("VC_ammo_fuel_storage-1", true)',
		},
	},
	["VC_ammo_fuel_storage-2"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 1',
		action = {
		'Action.TargetActive("VC_ammo_fuel_storage-2", true)',
		},
	},
	["VC_ammo_fuel_storage-3"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 1',
		action = {
		'Action.TargetActive("VC_ammo_fuel_storage-3", true)',
		},
	},
	["VC_Ho_Chi_Minh_Convoy-1"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 1',
		action = {
		'Action.TargetActive("VC_Ho_Chi_Minh_Convoy-1", true)',
		'Action.TargetPriority("VC_Ho_Chi_Minh_Convoy-1", 35)',
		},
	},
	["SAM-SA-2_Hanoi-South"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 6',
		action = {
		'Action.TargetActive("SAM-SA-2_Hanoi-South", true)',
		},
	},
	["SAM-SA-2_Hanoi-South-AA"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 6',
		action = {
		'Action.TargetActive("SAM-SA-2_Hanoi-South-AA", true)',
		},
	},
	["SAM-SA-2_Kien-An"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 5',
		action = {
		'Action.TargetActive("SAM-SA-2_Kien-An", true)',
		},
	},
	["SAM-SA-2_Kien-An-AA"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 5',
		action = {
		'Action.TargetActive("SAM-SA-2_Kien-An-AA", true)',
		},
	},
	["SAM-SA-2_Ban-Puoi"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 5',
		action = {
		'Action.TargetActive("SAM-SA-2_Ban-Puoi", true)',
		},
	},
	["SAM-SA-2_Ban-Puoi-AA"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 5',
		action = {
		'Action.TargetActive("SAM-SA-2_Ban-Puoi-AA", true)',
		},
	},
	["SAM-SA-2_Vihn"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 3',
		action = {
		'Action.TargetActive("SAM-SA-2_Vihn", true)',
		},
	},
	["SAM-SA-2_Vihn-AA"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 3',
		action = {
		'Action.TargetActive("SAM-SA-2_Vihn-AA", true)',
		},
	},
	["SAM-SA-2_South-Coast"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 3',
		action = {
		'Action.TargetActive("SAM-SA-2_South-Coast", true)',
		},
	},
	["SAM-SA-2_South-Coast-AA"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 3',
		action = {
		'Action.TargetActive("SAM-SA-2_South-Coast-AA", true)',
		},
	},
	["SAM-SA-2_South-Center"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 3',
		action = {
		'Action.TargetActive("SAM-SA-2_South-Center", true)',
		},
	},
	["SAM-SA-2_South-Center-AA"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 3',
		action = {
		'Action.TargetActive("SAM-SA-2_South-Center-AA", true)',
		},
	},
	["SAM-SA-2_East"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 3',
		action = {
		'Action.TargetActive("SAM-SA-2_East", true)',
		},
	},
	["SAM-SA-2_East-AA"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 3',
		action = {
		'Action.TargetActive("SAM-SA-2_East-AA", true)',
		},
	},
	["SAM-SA-2_South-West"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 3',
		action = {
		'Action.TargetActive("SAM-SA-2_South-West", true)',
		},
	},
	["SAM-SA-2_South-West-AA"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 3',
		action = {
		'Action.TargetActive("SAM-SA-2_South-West-AA", true)',
		},
	},
	["Rail Bridge Kien An"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 6',
		action = {
		'Action.TargetActive("Rail Bridge Kien An", true)',
		},
	},
	["Road Bridge Kien An"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 6',
		action = {
		'Action.TargetActive("Road Bridge Kien An", true)',
		},
	},
	["Ban Puoi Airbase false"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 0',
		action = {
		'Action.TargetActive("Ban Puoi Airbase", false)',
		'Action.TargetPriority("Ban Puoi Airbase", 1)',
		},
	},
	["Ban Puoi Airbase Runway false"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 0',
		action = {
		'Action.TargetActive("Ban Puoi Airbase Runway", false)',
		'Action.TargetPriority("Ban Puoi Airbase Runway", 1)',
		},
	},
	["Vihn Airbase false"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 0',
		action = {
		'Action.TargetActive("Vihn Airbase", false)',
		'Action.TargetPriority("Vihn Airbase", 1)',
		},
	},
	["Vihn Airbase Runway false"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 0',
		action = {
		'Action.TargetActive("Vihn Airbase Runway", false)',
		'Action.TargetPriority("Vihn Airbase Runway", 1)',
		},
	},
	["Kien An Airbase false"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 0',
		action = {
		'Action.TargetActive("Kien An Airbase", false)',
		'Action.TargetPriority("Kien An Airbase", 1)',
		},
	},
	["Kien An Airbase Runway false"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 0',
		action = {
		'Action.TargetActive("Kien An Airbase Runway", false)',
		'Action.TargetPriority("Kien An Airbase Runway", 1)',
		},
	},
	["Ban Puoi Airbase"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 6',
		action = {
		'Action.TargetActive("Ban Puoi Airbase", true)',
		'Action.TargetPriority("Ban Puoi Airbase", 7)',
		},
	},
	["Ban Puoi Airbase Runway"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 6',
		action = {
		'Action.TargetActive("Ban Puoi Airbase Runway", true)',
		'Action.TargetPriority("Ban Puoi Airbase Runway", 8)',
		},
	},
	["Vihn Airbase"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 4',
		action = {
		'Action.TargetActive("Vihn Airbase", true)',
		'Action.TargetPriority("Vihn Airbase", 7)',
		},
	},
	["Vihn Airbase Runway"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 4',
		action = {
		'Action.TargetActive("Vihn Airbase Runway", true)',
		'Action.TargetPriority("Vihn Airbase Runway", 8)',
		},
	},
	["Haiphong Airbase"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 5',
		action = {
		'Action.TargetActive("Haiphong Airbase", true)',
		'Action.TargetPriority("Haiphong Airbase", 7)',
		},
	},
	["Haiphong Airbase Runway"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 5',
		action = {
		'Action.TargetActive("Haiphong Airbase Runway", true)',
		'Action.TargetPriority("Haiphong Airbase Runway", 8)',
		},
	},
	["Hanoi Airbase"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 5',
		action = {
		'Action.TargetActive("Hanoi Airbase", true)',
		'Action.TargetPriority("Hanoi Airbase", 7)',
		},
	},
	["Hanoi Airbase Runway"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 5',
		action = {
		'Action.TargetActive("Hanoi Airbase Runway", true)',
		'Action.TargetPriority("Hanoi Airbase Runway", 8)',
		},
	},
	["Kien An Airbase"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 6',
		action = {
		'Action.TargetActive("Kien An Airbase", true)',
		'Action.TargetPriority("Kien An Airbase", 7)',
		},
	},
	["Kien An Airbase Runway"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 6',
		action = {
		'Action.TargetActive("Kien An Airbase Runway", true)',
		'Action.TargetPriority("Kien An Airbase Runway", 8)',
		},
	},
	["Hanoi Airbase Alert"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 1',
		action = {
		'Action.TargetActive("Hanoi Airbase Alert", true)',
		},
	},
	["Vihn Airbase Alert"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 1',
		action = {
		'Action.TargetActive("Vihn Airbase Alert", true)',
		},
	},
	["Ban Puoi Airbase Alert"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 1',
		action = {
		'Action.TargetActive("Ban Puoi Airbase Alert", true)',
		},
	},
	["Kien An Airbase Alert"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 2',
		action = {
		'Action.TargetActive("Kien An Airbase Alert", true)',
		},
	},
	["Haiphong Airbase Alert"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 3',
		action = {
		'Action.TargetActive("Haiphong Airbase Alert", true)',
		},
	},
		
	
	----- AIR UNITS ACTIVATION -----
	
	
	["RVAH-1 Activation"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 1',
		action = {
		'Action.AirUnitActive("RVAH-1", true)',
		},
	},
	["333rd TFS Desactivation"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 3',
		action = {
		'Action.AirUnitActive("333rd TFS", false)',
		},
	},
	-- ["355th TFS Activation"] = {
		-- active = true,
		-- once = true,
		-- condition = 'Return.Mission() > 1',
		-- action = {
		-- 'Action.AirUnitActive("355th TFS", true)',
		-- },
	-- },
	-- ["355th TFS Desactivation"] = {
		-- active = true,
		-- once = true,
		-- condition = 'Return.Mission() > 5',
		-- action = {
		-- 'Action.AirUnitActive("355th TFS", false)',
		-- },
	-- },
	-- ["90th TFS Activation"] = {
		-- active = true,
		-- once = true,
		-- condition = 'Return.Mission() > 0',
		-- action = {
		-- 'Action.AirUnitActive("90th TFS", true)',
		-- },
	-- },
	["174 ARW Activation"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 20',
		action = {
		'Action.AirUnitActive("174 ARW", true)',
		},
	},
	["90th TFS Desactivation"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 4',
		action = {
		'Action.AirUnitActive("90th TFS", false)',
		},
	},
	["602nd FS Activation"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 1',
		action = {
		'Action.AirUnitActive("602nd FS", true)',
		},
	},
	["6234th TFS Activation"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 3',
		action = {
		'Action.AirUnitActive("6234th TFS", true)',
		},
	},
	["34th TFS Activation"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 5',
		action = {
		'Action.AirUnitActive("34th TFS", true)',
		},
	},
	["4th TFS Activation"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 6',
		action = {
		'Action.AirUnitActive("4th TFS", true)',
		},
	},
	-- ["VA-163 Activation"] = {
		-- active = true,
		-- once = true,
		-- condition = 'Return.Mission() > 0',
		-- action = {
		-- 'Action.AirUnitActive("VA-163", true)',
		-- },
	-- },
	["VA-163 Desactivation"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 6',
		action = {
		'Action.AirUnitActive("VA-163", false)',
		},
	},
	["21st RAC Desactivation"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 2',
		action = {
		'Action.AirUnitActive("21st RAC", false)',
		'Action.Text("The old O-1 Bird dogs are replaced now and will cease AFAC mission now")',
		},
	},
	["Activation B-52H"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 3',
		action = {
			'Action.AirUnitActive("69 BS", true)',
			'Action.Text("B-52H from 96 BS are authorized to launch long range missions against NVA targets")',
		},
	},
	["128th TFS Activation"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 3',
		action = {
		'Action.AirUnitActive("128th TFS", true)',
		'Action.Text("A new electronic warfare plane enters service now : F-105G. It should protect bomber raids against SA-2")',
		},
	},
	["VAQ-132 Activation"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 8',
		action = {
		'Action.AirUnitActive("VAQ-132", true)',
		'Action.Text("A brand new electronic warfare plane enters service now : EA-6 Prowler. It should protect bomber raids against SA-2")',
		},
	},
	["VA-65 Activation"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 6',
		action = {
		'Action.AirUnitActive("VA-65", true)',
		'Action.Text("A brand new attack plane enters service now : A-6 Intruder. It should be more efficient than old A-4E Skyhawk")',
		},
	},
	["RVNAF 522nd FS Activation"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 4',
		action = {
		'Action.AirUnitActive("RVNAF 522nd FS", true)',
		'Action.Text("South Vietnam Air Force received new F-5E Tiger fighter-bombers. It should help us to attack NVA forces.")',
		},
	},
	["504th FAC Activation"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 2',
		action = {
		'Action.AirUnitActive("504th FAC", true)',
		'Action.Text("A brand new AFAC plane enters service now : OV-10A Bronco. It should help to find more targets for our bombers.")',
		},
	},
	["921st FR-PFM Activation"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 2',
		action = {
		'Action.AirUnitActive("921st FR-PFM", true)',
		},
	},
	["927th-1 FR-PFM Activation"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 0',
		action = {
		'Action.AirUnitActive("927th-1 FR-PFM", true)',		
		},
	},
	["927th-2 FR-PFM Activation"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 3',
		action = {
		'Action.AirUnitActive("927th-2 FR-PFM", true)',		
		},
	},
	["921st FR-PFM DeActivation"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 8',
		action = {
		'Action.AirUnitActive("921st FR-PFM", false)',
		'Action.AirUnitActive("921st FR-MF", true)',
		},
	},
	["927th-1 FR-PFM DeActivation"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 7',
		action = {
		'Action.AirUnitActive("927th-1 FR-PFM", false)',
		'Action.AirUnitActive("927th-1 FR-MF", true)',		
		},
	},
	["927th-2 FR-PFM DeActivation"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 8',
		action = {
		'Action.AirUnitActive("927th-2 FR-PFM", false)',
		'Action.AirUnitActive("927th-2 FR-MF", true)',		
		},
	},	
	["923rd-1 FR Activation"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 0',
		action = {
		'Action.AirUnitActive("923rd-1 FR", true)',
		},
	},
	["923rd-2 FR Activation"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 0',
		action = {
		'Action.AirUnitActive("923rd-2 FR", true)',
		},
	},
	["925th FR Activation"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() > 8',
		action = {
		'Action.AirUnitActive("925th FR", true)',
		
		},
	},
	
	
	----- REPAIR AND REINFORCEMENTS -----
	["GroundUnitRepair"] = {
		active = true,
		condition = 'true',
		action = 'Action.GroundUnitRepair()',
	},
	["Repair"] = {
		active = true,
		condition = 'true',
		action = 'Action.AirUnitRepair()',
	},
	
	
		
	---- GROUND TARGET STATUS ---
	["Blue Ground Target Briefing Intel"] = {
		active = true,
		condition = 'true',
		action = 'Action.AddGroundTargetIntel("blue")',
	},
	["Red Ground Target Briefing Intel"] = {
		active = true,
		condition = 'true',
		action = 'Action.AddGroundTargetIntel("red")',
	},
}





