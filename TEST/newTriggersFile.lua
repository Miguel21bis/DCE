camp_triggers = {

    {
        name = "Campaign Briefing",
        active = true,
        once = true,
        condition = 'true',
        action = {
            'Action.Text("NAM 1965-74")',
            'Action.AddImage("Newspaper_FirstNight_blue.jpg", "blue")',
        },
    },

    {
        name = "Campaign End Victory 1",
        active = true,
        once = true,
        condition = 'GroundTarget["blue"].percent < 40 and Return.Mission() > 6',
        action = {
            'Action.CampaignEnd("win")',
            'Action.Text("Allied forces completely destroyed the NVA forces. Good game.")',
            'Action.AddImage("Newspaper_Victory_blue.jpg", "blue")',
        },
    },

    {
        name = "Campaign End Victory 2",
        active = true,
        once = true,
        condition = 'Return.totalAirUnitAliveBySide("red") < 5 and Return.Mission() > 6',
        action = {
            'Action.CampaignEnd("win")',
            'Action.Text("The NVA Air Force is in ruins. After repeated air strikes and disastrous losses in air-air combat, the NVA are no longer able to produce any sorties or offer any resistance. The US now owns complete air superiority.")',
            'Action.AddImage("Newspaper_Victory_blue.jpg", "blue")',
        },
    },

    {
        name = "Campaign End Loss",
        active = true,
        once = true,
        condition = 'Return.AirUnitAlive("469th TFS") < 2',
        action = {
            'Action.CampaignEnd("loss")',
            'Action.Text("Ongoing combat operations have exhausted your squadron. Loss rate has reached a level where reinforcements are no longer able to sustain combat operations. With the failure of Allied Air Force to attain air superiority, US Central Command has decided to call of the air campaign against the enemy. Without destroying enemy airbases it seems unlikely that the coalition will be able to win this war.")',
            'Action.Text("Les operations de combat en cours ont epuise votre escadron. Le taux de pertes a atteint un niveau tel que les renforts ne sont plus en mesure de soutenir les operations de combat. Face a l echec des des forces aeriennes alliees a atteindre la superiorite aerienne, le Commandement central americain a decide de stopper la campagne aerienne contre lennemi. Il semble peu probable que la coalition puisse gagner cette guerre.")',
            'Action.AddImage("Newspaper_Defeat_blue.jpg", "blue")',
        },
    },

    {
        name = "Campaign End Draw",
        active = true,
        once = true,
        condition = 'MissionInstance == 40',
        action = {
            'Action.CampaignEnd("draw")',
            'Action.Text("The air campaign has seen a sustained period of inactivity. Seemingly unable to complete the destruction of the Russian Air Force and infrastructure, US Central Command has called off all squadrons from offensive operations. We hope negociations with Russians will convince them to stop attacks in Georgia")',
        },
    },

    {
        name = "Campaign first destructions",
        active = true,
        once = true,
        condition = 'GroundTarget["blue"].percent < 100 and Return.Mission() > 1',
        action = {
            'Action.Text("First targets have been destroyed. Keep up the good work")',
        },
    },

    {
        name = "Campaign 20 percents destructions",
        active = true,
        once = true,
        condition = 'GroundTarget["blue"].percent < 80 and Return.Mission() > 1',
        action = {
            'Action.Text("Enemy targets have sustained fair damages. Keep up the good work")',
        },
    },

    {
        name = "Campaign 40 percents destructions",
        active = true,
        once = true,
        condition = 'GroundTarget["blue"].percent < 60 and Return.Mission() > 1',
        action = {
            'Action.Text("Enemy targets have sustained great damages. Strike missions are really efficient and we will win this war soon")',
        },
    },

    {
        name = "Campaign 50 percents destructions",
        active = true,
        once = true,
        condition = 'GroundTarget["blue"].percent < 50 and Return.Mission() > 1',
        action = {
            'Action.Text("More than half of our targets are neutralized. Intelligence think that the enemy will ask for a cease fire soon")',
        },
    },

    {
        name = "TF-59 Patrol At Sea",
        active = true,
        once = true,
        condition = 'Return.Mission() >= 1',
        action = {
            'Action.ShipMission("TF-59", {{"TF-59-1", "TF-59-2", "TF-59-3", "TF-59-4"}}, 10, 8, nil)',
        },
    },

    {
        name = "test weather hiver",
        active = true,
        once = true,
        condition = 'Return.Mission() > 1',												----'camp.date.month >= 10 or camp.date.month <= 3',
        action = {
            'Action.SetWeather( "weather = { pHigh = 78, pLow = 22, refTemp = 30, weatherChangeRate = 0.12 }" )',
        },
    },

    {
        name = "test restrictedLoadoutnamstart",
        active = true,
        once = true,
        condition = 'Return.Mission() > 0',
        action = {
            'Action.RestrictedLoadout("restricted_loadoutnamstart.miz")',
        },
    },

    {
        name = "test restrictedLoadoutnam2",
        active = true,
        once = true,
        condition = 'Return.Mission() > 2',
        action = {
            'Action.RestrictedLoadout("restricted_loadoutnam2.miz")',
        },
    },

    {
        name = "test restrictedLoadoutnam3",
        active = true,
        once = true,
        condition = 'Return.Mission() > 4',
        action = {
            'Action.RestrictedLoadout("restricted_loadoutnam3.miz")',
        },
    },

    {
        name = "test restrictedLoadoutnam4",
        active = true,
        once = true,
        condition = 'Return.Mission() > 6',
        action = {
            'Action.RestrictedLoadout("restricted_loadoutnam4.miz")',
        },
    },

    {
        name = "Training_targets template activate",
        active = true,
        once = true,
        condition = 'Return.Mission() > 0',
        action = {
            'Action.TemplateActive("Training_targets.stm", true)',
        },
    },

    {
        name = "Training_targets_IA template activate",
        active = true,
        once = true,
        condition = 'Return.Mission() > 0',
        action = {
            'Action.TemplateActive("Training_targets_IA.stm", true)',
        },
    },

    {
        name = "Training_targets Deactivate",
        active = true,
        once = true,
        condition = 'Return.Mission() > 1',
        action = {
            'Action.TargetActive("Training_targets", false)',
            'Action.TemplateDeactivate("Training_targets.stm")',
        },
    },

    {
        name = "Training_targets_IA Deactivate",
        active = true,
        once = true,
        condition = 'Return.Mission() > 1',
        action = {
            'Action.TargetActive("Training_targets_IA", false)',
            'Action.TemplateDeactivate("Training_targets_IA.stm")',
        },
    },

    {
        name = "Recon Hanoi high Activation",
        active = true,
        once = true,
        condition = 'Return.Mission() > 1',
        action = {
            'Action.TargetActive("Recon Hanoi high", true)',
        },
    },

    {
        name = "Recon Hanoi low Activation",
        active = true,
        once = true,
        condition = 'Return.Mission() > 1',
        action = {
            'Action.TargetActive("Recon Hanoi low", true)',
        },
    },

    {
        name = "Recon Haiphong high Activation",
        active = true,
        once = true,
        condition = 'Return.Mission() > 1',
        action = {
            'Action.TargetActive("Recon Haiphong high", true)',
        },
    },

    {
        name = "Recon Haiphong low Activation",
        active = true,
        once = true,
        condition = 'Return.Mission() > 1',
        action = {
            'Action.TargetActive("Recon Haiphong low", true)',
        },
    },

    {
        name = "Tanker Track E1 Activation",
        active = true,
        once = true,
        condition = 'Return.Mission() > 20',
        action = {
            'Action.TargetActive("Tanker Track E1", true)',
        },
    },

    {
        name = "Tanker Track E2 Activation",
        active = true,
        once = true,
        condition = 'Return.Mission() > 20',
        action = {
            'Action.TargetActive("Tanker Track E2", true)',
        },
    },

    {
        name = "Tanker Track E3 Activation",
        active = true,
        once = true,
        condition = 'Return.Mission() > 20',
        action = {
            'Action.TargetActive("Tanker Track E3", true)',
        },
    },

    {
        name = "Tanker Track E4 Activation",
        active = true,
        once = true,
        condition = 'Return.Mission() > 20',
        action = {
            'Action.TargetActive("Tanker Track E4", true)',
        },
    },

    {
        name = "Tanker Track Navy1 Activation",
        active = true,
        once = true,
        condition = 'Return.Mission() > 20',
        action = {
            'Action.TargetActive("Tanker Track Navy1", true)',
        },
    },

    {
        name = "Tanker Track Navy2 Activation",
        active = true,
        once = true,
        condition = 'Return.Mission() > 20',
        action = {
            'Action.TargetActive("Tanker Track Navy2", true)',
        },
    },

    {
        name = "Tanker Track Navy3 Activation",
        active = true,
        once = true,
        condition = 'Return.Mission() > 20',
        action = {
            'Action.TargetActive("Tanker Track Navy3", true)',
        },
    },

    {
        name = "Tanker Track Navy4 Activation",
        active = true,
        once = true,
        condition = 'Return.Mission() > 20',
        action = {
            'Action.TargetActive("Tanker Track Navy4", true)',
        },
    },

    {
        name = "Sweep Ho Chi Mihn",
        active = true,
        once = true,
        condition = 'Return.Mission() > 1',
        action = {
            'Action.TargetActive("Sweep Ho Chi Mihn", true)',
        },
    },

    {
        name = "Sweep Khe Sanh",
        active = true,
        once = true,
        condition = 'Return.Mission() > 2',
        action = {
            'Action.TargetActive("Sweep Khe Sanh", true)',
        },
    },

    {
        name = "VC_Inf_camp-1",
        active = true,
        once = true,
        condition = 'Return.Mission() > 1',
        action = {
            'Action.TargetActive("VC_Inf_camp-1", true)',
        },
    },

    {
        name = "VC_Inf_camp-2",
        active = true,
        once = true,
        condition = 'Return.Mission() > 1',
        action = {
            'Action.TargetActive("VC_Inf_camp-2", true)',
        },
    },

    {
        name = "VC_Inf_camp-3",
        active = true,
        once = true,
        condition = 'Return.Mission() > 1',
        action = {
            'Action.TargetActive("VC_Inf_camp-3", true)',
        },
    },

    {
        name = "VC_Inf_camp-4",
        active = true,
        once = true,
        condition = 'Return.Mission() > 1',
        action = {
            'Action.TargetActive("VC_Inf_camp-4", true)',
        },
    },

    {
        name = "VC_Inf_camp-5",
        active = true,
        once = true,
        condition = 'Return.Mission() > 1',
        action = {
            'Action.TargetActive("VC_Inf_camp-5", true)',
        },
    },

    {
        name = "VC_Inf_camp-6",
        active = true,
        once = true,
        condition = 'Return.Mission() > 1',
        action = {
            'Action.TargetActive("VC_Inf_camp-6", true)',
        },
    },

    {
        name = "VC_Inf_camp-7",
        active = true,
        once = true,
        condition = 'Return.Mission() > 1',
        action = {
            'Action.TargetActive("VC_Inf_camp-7", true)',
        },
    },

    {
        name = "VC_Inf_camp-8",
        active = true,
        once = true,
        condition = 'Return.Mission() > 1',
        action = {
            'Action.TargetActive("VC_Inf_camp-8", true)',
        },
    },

    {
        name = "VC_Inf_camp-9",
        active = true,
        once = true,
        condition = 'Return.Mission() > 1',
        action = {
            'Action.TargetActive("VC_Inf_camp-9", true)',
        },
    },

    {
        name = "VC_ammo_fuel_storage-1",
        active = true,
        once = true,
        condition = 'Return.Mission() > 1',
        action = {
            'Action.TargetActive("VC_ammo_fuel_storage-1", true)',
        },
    },

    {
        name = "VC_ammo_fuel_storage-2",
        active = true,
        once = true,
        condition = 'Return.Mission() > 1',
        action = {
            'Action.TargetActive("VC_ammo_fuel_storage-2", true)',
        },
    },

    {
        name = "VC_ammo_fuel_storage-3",
        active = true,
        once = true,
        condition = 'Return.Mission() > 1',
        action = {
            'Action.TargetActive("VC_ammo_fuel_storage-3", true)',
        },
    },

    {
        name = "VC_Ho_Chi_Minh_Convoy-1",
        active = true,
        once = true,
        condition = 'Return.Mission() > 1',
        action = {
            'Action.TargetActive("VC_Ho_Chi_Minh_Convoy-1", true)',
            'Action.TargetPriority("VC_Ho_Chi_Minh_Convoy-1", 35)',
        },
    },

    {
        name = "SAM-SA-2_Hanoi-South",
        active = true,
        once = true,
        condition = 'Return.Mission() > 6',
        action = {
            'Action.TargetActive("SAM-SA-2_Hanoi-South", true)',
        },
    },

    {
        name = "SAM-SA-2_Hanoi-South-AA",
        active = true,
        once = true,
        condition = 'Return.Mission() > 6',
        action = {
            'Action.TargetActive("SAM-SA-2_Hanoi-South-AA", true)',
        },
    },

    {
        name = "SAM-SA-2_Kien-An",
        active = true,
        once = true,
        condition = 'Return.Mission() > 5',
        action = {
            'Action.TargetActive("SAM-SA-2_Kien-An", true)',
        },
    },

    {
        name = "SAM-SA-2_Kien-An-AA",
        active = true,
        once = true,
        condition = 'Return.Mission() > 5',
        action = {
            'Action.TargetActive("SAM-SA-2_Kien-An-AA", true)',
        },
    },

    {
        name = "SAM-SA-2_Ban-Puoi",
        active = true,
        once = true,
        condition = 'Return.Mission() > 5',
        action = {
            'Action.TargetActive("SAM-SA-2_Ban-Puoi", true)',
        },
    },

    {
        name = "SAM-SA-2_Ban-Puoi-AA",
        active = true,
        once = true,
        condition = 'Return.Mission() > 5',
        action = {
            'Action.TargetActive("SAM-SA-2_Ban-Puoi-AA", true)',
        },
    },

    {
        name = "SAM-SA-2_Vihn",
        active = true,
        once = true,
        condition = 'Return.Mission() > 3',
        action = {
            'Action.TargetActive("SAM-SA-2_Vihn", true)',
        },
    },

    {
        name = "SAM-SA-2_Vihn-AA",
        active = true,
        once = true,
        condition = 'Return.Mission() > 3',
        action = {
            'Action.TargetActive("SAM-SA-2_Vihn-AA", true)',
        },
    },

    {
        name = "SAM-SA-2_South-Coast",
        active = true,
        once = true,
        condition = 'Return.Mission() > 3',
        action = {
            'Action.TargetActive("SAM-SA-2_South-Coast", true)',
        },
    },

    {
        name = "SAM-SA-2_South-Coast-AA",
        active = true,
        once = true,
        condition = 'Return.Mission() > 3',
        action = {
            'Action.TargetActive("SAM-SA-2_South-Coast-AA", true)',
        },
    },

    {
        name = "SAM-SA-2_South-Center",
        active = true,
        once = true,
        condition = 'Return.Mission() > 3',
        action = {
            'Action.TargetActive("SAM-SA-2_South-Center", true)',
        },
    },

    {
        name = "SAM-SA-2_South-Center-AA",
        active = true,
        once = true,
        condition = 'Return.Mission() > 3',
        action = {
            'Action.TargetActive("SAM-SA-2_South-Center-AA", true)',
        },
    },

    {
        name = "SAM-SA-2_East",
        active = true,
        once = true,
        condition = 'Return.Mission() > 3',
        action = {
            'Action.TargetActive("SAM-SA-2_East", true)',
        },
    },

    {
        name = "SAM-SA-2_East-AA",
        active = true,
        once = true,
        condition = 'Return.Mission() > 3',
        action = {
            'Action.TargetActive("SAM-SA-2_East-AA", true)',
        },
    },

    {
        name = "SAM-SA-2_South-West",
        active = true,
        once = true,
        condition = 'Return.Mission() > 3',
        action = {
            'Action.TargetActive("SAM-SA-2_South-West", true)',
        },
    },

    {
        name = "SAM-SA-2_South-West-AA",
        active = true,
        once = true,
        condition = 'Return.Mission() > 3',
        action = {
            'Action.TargetActive("SAM-SA-2_South-West-AA", true)',
        },
    },

    {
        name = "Rail Bridge Kien An",
        active = true,
        once = true,
        condition = 'Return.Mission() > 6',
        action = {
            'Action.TargetActive("Rail Bridge Kien An", true)',
        },
    },

    {
        name = "Road Bridge Kien An",
        active = true,
        once = true,
        condition = 'Return.Mission() > 6',
        action = {
            'Action.TargetActive("Road Bridge Kien An", true)',
        },
    },

    {
        name = "Ban Puoi Airbase false",
        active = true,
        once = true,
        condition = 'Return.Mission() > 0',
        action = {
            'Action.TargetActive("Ban Puoi Airbase", false)',
            'Action.TargetPriority("Ban Puoi Airbase", 1)',
        },
    },

    {
        name = "Ban Puoi Airbase Runway false",
        active = true,
        once = true,
        condition = 'Return.Mission() > 0',
        action = {
            'Action.TargetActive("Ban Puoi Airbase Runway", false)',
            'Action.TargetPriority("Ban Puoi Airbase Runway", 1)',
        },
    },

    {
        name = "Vihn Airbase false",
        active = true,
        once = true,
        condition = 'Return.Mission() > 0',
        action = {
            'Action.TargetActive("Vihn Airbase", false)',
            'Action.TargetPriority("Vihn Airbase", 1)',
        },
    },

    {
        name = "Vihn Airbase Runway false",
        active = true,
        once = true,
        condition = 'Return.Mission() > 0',
        action = {
            'Action.TargetActive("Vihn Airbase Runway", false)',
            'Action.TargetPriority("Vihn Airbase Runway", 1)',
        },
    },

    {
        name = "Kien An Airbase false",
        active = true,
        once = true,
        condition = 'Return.Mission() > 0',
        action = {
            'Action.TargetActive("Kien An Airbase", false)',
            'Action.TargetPriority("Kien An Airbase", 1)',
        },
    },

    {
        name = "Kien An Airbase Runway false",
        active = true,
        once = true,
        condition = 'Return.Mission() > 0',
        action = {
            'Action.TargetActive("Kien An Airbase Runway", false)',
            'Action.TargetPriority("Kien An Airbase Runway", 1)',
        },
    },

    {
        name = "Ban Puoi Airbase",
        active = true,
        once = true,
        condition = 'Return.Mission() > 6',
        action = {
            'Action.TargetActive("Ban Puoi Airbase", true)',
            'Action.TargetPriority("Ban Puoi Airbase", 7)',
        },
    },

    {
        name = "Ban Puoi Airbase Runway",
        active = true,
        once = true,
        condition = 'Return.Mission() > 6',
        action = {
            'Action.TargetActive("Ban Puoi Airbase Runway", true)',
            'Action.TargetPriority("Ban Puoi Airbase Runway", 8)',
        },
    },

    {
        name = "Vihn Airbase",
        active = true,
        once = true,
        condition = 'Return.Mission() > 4',
        action = {
            'Action.TargetActive("Vihn Airbase", true)',
            'Action.TargetPriority("Vihn Airbase", 7)',
        },
    },

    {
        name = "Vihn Airbase Runway",
        active = true,
        once = true,
        condition = 'Return.Mission() > 4',
        action = {
            'Action.TargetActive("Vihn Airbase Runway", true)',
            'Action.TargetPriority("Vihn Airbase Runway", 8)',
        },
    },

    {
        name = "Haiphong Airbase",
        active = true,
        once = true,
        condition = 'Return.Mission() > 5',
        action = {
            'Action.TargetActive("Haiphong Airbase", true)',
            'Action.TargetPriority("Haiphong Airbase", 7)',
        },
    },

    {
        name = "Haiphong Airbase Runway",
        active = true,
        once = true,
        condition = 'Return.Mission() > 5',
        action = {
            'Action.TargetActive("Haiphong Airbase Runway", true)',
            'Action.TargetPriority("Haiphong Airbase Runway", 8)',
        },
    },

    {
        name = "Hanoi Airbase",
        active = true,
        once = true,
        condition = 'Return.Mission() > 5',
        action = {
            'Action.TargetActive("Hanoi Airbase", true)',
            'Action.TargetPriority("Hanoi Airbase", 7)',
        },
    },

    {
        name = "Hanoi Airbase Runway",
        active = true,
        once = true,
        condition = 'Return.Mission() > 5',
        action = {
            'Action.TargetActive("Hanoi Airbase Runway", true)',
            'Action.TargetPriority("Hanoi Airbase Runway", 8)',
        },
    },

    {
        name = "Kien An Airbase",
        active = true,
        once = true,
        condition = 'Return.Mission() > 6',
        action = {
            'Action.TargetActive("Kien An Airbase", true)',
            'Action.TargetPriority("Kien An Airbase", 7)',
        },
    },

    {
        name = "Kien An Airbase Runway",
        active = true,
        once = true,
        condition = 'Return.Mission() > 6',
        action = {
            'Action.TargetActive("Kien An Airbase Runway", true)',
            'Action.TargetPriority("Kien An Airbase Runway", 8)',
        },
    },

    {
        name = "Hanoi Airbase Alert",
        active = true,
        once = true,
        condition = 'Return.Mission() > 1',
        action = {
            'Action.TargetActive("Hanoi Airbase Alert", true)',
        },
    },

    {
        name = "Vihn Airbase Alert",
        active = true,
        once = true,
        condition = 'Return.Mission() > 1',
        action = {
            'Action.TargetActive("Vihn Airbase Alert", true)',
        },
    },

    {
        name = "Ban Puoi Airbase Alert",
        active = true,
        once = true,
        condition = 'Return.Mission() > 1',
        action = {
            'Action.TargetActive("Ban Puoi Airbase Alert", true)',
        },
    },

    {
        name = "Kien An Airbase Alert",
        active = true,
        once = true,
        condition = 'Return.Mission() > 2',
        action = {
            'Action.TargetActive("Kien An Airbase Alert", true)',
        },
    },

    {
        name = "Haiphong Airbase Alert",
        active = true,
        once = true,
        condition = 'Return.Mission() > 3',
        action = {
            'Action.TargetActive("Haiphong Airbase Alert", true)',
        },
    },

    {
        name = "RVAH-1 Activation",
        active = true,
        once = true,
        condition = 'Return.Mission() > 1',
        action = {
            'Action.AirUnitActive("RVAH-1", true)',
        },
    },

    {
        name = "333rd TFS Desactivation",
        active = true,
        once = true,
        condition = 'Return.Mission() > 3',
        action = {
            'Action.AirUnitActive("333rd TFS", false)',
        },
    },

    {
        name = "174 ARW Activation",
        active = true,
        once = true,
        condition = 'Return.Mission() > 20',
        action = {
            'Action.AirUnitActive("174 ARW", true)',
        },
    },

    {
        name = "90th TFS Desactivation",
        active = true,
        once = true,
        condition = 'Return.Mission() > 4',
        action = {
            'Action.AirUnitActive("90th TFS", false)',
        },
    },

    {
        name = "602nd FS Activation",
        active = true,
        once = true,
        condition = 'Return.Mission() > 1',
        action = {
            'Action.AirUnitActive("602nd FS", true)',
        },
    },

    {
        name = "6234th TFS Activation",
        active = true,
        once = true,
        condition = 'Return.Mission() > 3',
        action = {
            'Action.AirUnitActive("6234th TFS", true)',
        },
    },

    {
        name = "34th TFS Activation",
        active = true,
        once = true,
        condition = 'Return.Mission() > 5',
        action = {
            'Action.AirUnitActive("34th TFS", true)',
        },
    },

    {
        name = "4th TFS Activation",
        active = true,
        once = true,
        condition = 'Return.Mission() > 6',
        action = {
            'Action.AirUnitActive("4th TFS", true)',
        },
    },

    {
        name = "VA-163 Desactivation",
        active = true,
        once = true,
        condition = 'Return.Mission() > 6',
        action = {
            'Action.AirUnitActive("VA-163", false)',
        },
    },

    {
        name = "21st RAC Desactivation",
        active = true,
        once = true,
        condition = 'Return.Mission() > 2',
        action = {
            'Action.AirUnitActive("21st RAC", false)',
            'Action.Text("The old O-1 Bird dogs are replaced now and will cease AFAC mission now")',
        },
    },

    {
        name = "Activation B-52H",
        active = true,
        once = true,
        condition = 'Return.Mission() > 3',
        action = {
            'Action.AirUnitActive("69 BS", true)',
            'Action.Text("B-52H from 96 BS are authorized to launch long range missions against NVA targets")',
        },
    },

    {
        name = "128th TFS Activation",
        active = true,
        once = true,
        condition = 'Return.Mission() > 3',
        action = {
            'Action.AirUnitActive("128th TFS", true)',
            'Action.Text("A new electronic warfare plane enters service now : F-105G. It should protect bomber raids against SA-2")',
        },
    },

    {
        name = "VAQ-132 Activation",
        active = true,
        once = true,
        condition = 'Return.Mission() > 8',
        action = {
            'Action.AirUnitActive("VAQ-132", true)',
            'Action.Text("A brand new electronic warfare plane enters service now : EA-6 Prowler. It should protect bomber raids against SA-2")',
        },
    },

    {
        name = "VA-65 Activation",
        active = true,
        once = true,
        condition = 'Return.Mission() > 6',
        action = {
            'Action.AirUnitActive("VA-65", true)',
            'Action.Text("A brand new attack plane enters service now : A-6 Intruder. It should be more efficient than old A-4E Skyhawk")',
        },
    },

    {
        name = "RVNAF 522nd FS Activation",
        active = true,
        once = true,
        condition = 'Return.Mission() > 4',
        action = {
            'Action.AirUnitActive("RVNAF 522nd FS", true)',
            'Action.Text("South Vietnam Air Force received new F-5E Tiger fighter-bombers. It should help us to attack NVA forces.")',
        },
    },

    {
        name = "504th FAC Activation",
        active = true,
        once = true,
        condition = 'Return.Mission() > 2',
        action = {
            'Action.AirUnitActive("504th FAC", true)',
            'Action.Text("A brand new AFAC plane enters service now : OV-10A Bronco. It should help to find more targets for our bombers.")',
        },
    },

    {
        name = "921st FR-PFM Activation",
        active = true,
        once = true,
        condition = 'Return.Mission() > 2',
        action = {
            'Action.AirUnitActive("921st FR-PFM", true)',
        },
    },

    {
        name = "927th-1 FR-PFM Activation",
        active = true,
        once = true,
        condition = 'Return.Mission() > 0',
        action = {
            'Action.AirUnitActive("927th-1 FR-PFM", true)',
        },
    },

    {
        name = "927th-2 FR-PFM Activation",
        active = true,
        once = true,
        condition = 'Return.Mission() > 3',
        action = {
            'Action.AirUnitActive("927th-2 FR-PFM", true)',
        },
    },

    {
        name = "921st FR-PFM DeActivation",
        active = true,
        once = true,
        condition = 'Return.Mission() > 8',
        action = {
            'Action.AirUnitActive("921st FR-PFM", false)',
            'Action.AirUnitActive("921st FR-MF", true)',
        },
    },

    {
        name = "927th-1 FR-PFM DeActivation",
        active = true,
        once = true,
        condition = 'Return.Mission() > 7',
        action = {
            'Action.AirUnitActive("927th-1 FR-PFM", false)',
            'Action.AirUnitActive("927th-1 FR-MF", true)',
        },
    },

    {
        name = "927th-2 FR-PFM DeActivation",
        active = true,
        once = true,
        condition = 'Return.Mission() > 8',
        action = {
            'Action.AirUnitActive("927th-2 FR-PFM", false)',
            'Action.AirUnitActive("927th-2 FR-MF", true)',
        },
    },

    {
        name = "923rd-1 FR Activation",
        active = true,
        once = true,
        condition = 'Return.Mission() > 0',
        action = {
            'Action.AirUnitActive("923rd-1 FR", true)',
        },
    },

    {
        name = "923rd-2 FR Activation",
        active = true,
        once = true,
        condition = 'Return.Mission() > 0',
        action = {
            'Action.AirUnitActive("923rd-2 FR", true)',
        },
    },

    {
        name = "925th FR Activation",
        active = true,
        once = true,
        condition = 'Return.Mission() > 8',
        action = {
            'Action.AirUnitActive("925th FR", true)',
        },
    },

    {
        name = "GroundUnitRepair",
        active = true,
        once = nil,
        condition = 'true',
        action = {
            'Action.GroundUnitRepair()',
        },
    },

    {
        name = "Repair",
        active = true,
        once = nil,
        condition = 'true',
        action = {
            'Action.AirUnitRepair()',
        },
    },

    {
        name = "Blue Ground Target Briefing Intel",
        active = true,
        once = nil,
        condition = 'true',
        action = {
            'Action.AddGroundTargetIntel("blue")',
        },
    },

    {
        name = "Red Ground Target Briefing Intel",
        active = true,
        once = nil,
        condition = 'true',
        action = {
            'Action.AddGroundTargetIntel("red")',
        },
    },

}
