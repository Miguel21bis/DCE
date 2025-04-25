camp_triggers = 
{
	[1] = 
	{
		["action"] = 
		{
			[1] = "Action.Text(\"NAM 1965-74\")",
			[2] = "Action.AddImage(\"Newspaper_FirstNight_blue.jpg\", \"blue\")",
		},
		["active"] = true,
		["condition"] = "true",
		["name"] = "Campaign Briefing",
		["once"] = true,
	},
	[2] = 
	{
		["NoMoreNewspaper"] = "true\'",
		["action"] = 
		{
			[1] = "Action.CampaignEnd(\"win\")",
			[2] = "Action.Text(\"Allied forces completely destroyed the NVA forces. Good game.\")",
			[3] = "Action.AddImage(\"Newspaper_Victory_blue.jpg\", \"blue\")",
		},
		["active"] = true,
		["condition"] = "GroundTarget[\"blue\"].percent < 40 and Return.Mission() > 6",
		["name"] = "Campaign End Victory 1",
		["once"] = true,
	},
	[3] = 
	{
		["NoMoreNewspaper"] = "true\'",
		["action"] = 
		{
			[1] = "Action.CampaignEnd(\"win\")",
			[2] = "Action.Text(\"The NVA Air Force is in ruins. After repeated air strikes and disastrous losses in air-air combat, the NVA are no longer able to produce any sorties or offer any resistance. The US now owns complete air superiority.\")",
			[3] = "Action.AddImage(\"Newspaper_Victory_blue.jpg\", \"blue\")",
		},
		["active"] = true,
		["condition"] = "Return.totalAirUnitAliveBySide(\"red\") < 5 and Return.Mission() > 6",
		["name"] = "Campaign End Victory 2",
		["once"] = true,
	},
	[4] = 
	{
		["NoMoreNewspaper"] = "true\'",
		["action"] = 
		{
			[1] = "Action.CampaignEnd(\"loss\")",
			[2] = "Action.Text(\"Ongoing combat operations have exhausted your squadron. Loss rate has reached a level where reinforcements are no longer able to sustain combat operations. With the failure of Allied Air Force to attain air superiority, US Central Command has decided to call of the air campaign against the enemy. Without destroying enemy airbases it seems unlikely that the coalition will be able to win this war.\")",
			[3] = "Action.Text(\"Les operations de combat en cours ont epuise votre escadron. Le taux de pertes a atteint un niveau tel que les renforts ne sont plus en mesure de soutenir les operations de combat. Face a l echec des des forces aeriennes alliees a atteindre la superiorite aerienne, le Commandement central americain a decide de stopper la campagne aerienne contre lennemi. Il semble peu probable que la coalition puisse gagner cette guerre.\")",
			[4] = "Action.AddImage(\"Newspaper_Defeat_blue.jpg\", \"blue\")",
		},
		["active"] = true,
		["condition"] = "Return.AirUnitAlive(\"469th TFS\") < 2",
		["name"] = "Campaign End Loss",
		["once"] = true,
	},
	[5] = 
	{
		["NoMoreNewspaper"] = "true\'",
		["action"] = 
		{
			[1] = "Action.CampaignEnd(\"draw\")",
			[2] = "Action.Text(\"The air campaign has seen a sustained period of inactivity. Seemingly unable to complete the destruction of the Russian Air Force and infrastructure, US Central Command has called off all squadrons from offensive operations. We hope negociations with Russians will convince them to stop attacks in Georgia\")",
		},
		["active"] = true,
		["condition"] = "MissionInstance == 40",
		["name"] = "Campaign End Draw",
		["once"] = true,
	},
	[6] = 
	{
		["action"] = 
		{
			[1] = "Action.Text(\"First targets have been destroyed. Keep up the good work\")",
		},
		["active"] = true,
		["condition"] = "GroundTarget[\"blue\"].percent < 100 and Return.Mission() > 1",
		["name"] = "Campaign first destructions",
		["once"] = true,
	},
	[7] = 
	{
		["action"] = 
		{
			[1] = "Action.Text(\"Enemy targets have sustained fair damages. Keep up the good work\")",
		},
		["active"] = true,
		["condition"] = "GroundTarget[\"blue\"].percent < 80 and Return.Mission() > 1",
		["name"] = "Campaign 20 percents destructions",
		["once"] = true,
	},
	[8] = 
	{
		["action"] = 
		{
			[1] = "Action.Text(\"Enemy targets have sustained great damages. Strike missions are really efficient and we will win this war soon\")",
		},
		["active"] = true,
		["condition"] = "GroundTarget[\"blue\"].percent < 60 and Return.Mission() > 1",
		["name"] = "Campaign 40 percents destructions",
		["once"] = true,
	},
	[9] = 
	{
		["action"] = 
		{
			[1] = "Action.Text(\"More than half of our targets are neutralized. Intelligence think that the enemy will ask for a cease fire soon\")",
		},
		["active"] = true,
		["condition"] = "GroundTarget[\"blue\"].percent < 50 and Return.Mission() > 1",
		["name"] = "Campaign 50 percents destructions",
		["once"] = true,
	},
	[10] = 
	{
		["action"] = 
		{
			[1] = "Action.ShipMission(\"TF-59\", {{\"TF-59-1\", \"TF-59-2\", \"TF-59-3\", \"TF-59-4\"}}, 10, 8, nil)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() >= 1",
		["name"] = "TF-59 Patrol At Sea",
		["once"] = true,
	},
	[11] = 
	{
		["action"] = 
		{
			[1] = "Action.SetWeather( \"weather = { pHigh = 78, pLow = 22, refTemp = 30, weatherChangeRate = 0.12 }\" )",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 1\',												----\'camp.date.month >= 10 or camp.date.month <= 3",
		["name"] = "test weather hiver",
		["once"] = true,
	},
	[12] = 
	{
		["action"] = 
		{
			[1] = "Action.RestrictedLoadout(\"restricted_loadoutnamstart.miz\")",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 0",
		["name"] = "test restrictedLoadoutnamstart",
		["once"] = true,
	},
	[13] = 
	{
		["action"] = 
		{
			[1] = "Action.RestrictedLoadout(\"restricted_loadoutnam2.miz\")",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 2",
		["name"] = "test restrictedLoadoutnam2",
		["once"] = true,
	},
	[14] = 
	{
		["action"] = 
		{
			[1] = "Action.RestrictedLoadout(\"restricted_loadoutnam3.miz\")",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 4",
		["name"] = "test restrictedLoadoutnam3",
		["once"] = true,
	},
	[15] = 
	{
		["action"] = 
		{
			[1] = "Action.RestrictedLoadout(\"restricted_loadoutnam4.miz\")",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 6",
		["name"] = "test restrictedLoadoutnam4",
		["once"] = true,
	},
	[16] = 
	{
		["action"] = 
		{
			[1] = "Action.TemplateActive(\"Training_targets.stm\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 0",
		["name"] = "Training_targets template activate",
		["once"] = true,
	},
	[17] = 
	{
		["action"] = 
		{
			[1] = "Action.TemplateActive(\"Training_targets_IA.stm\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 0",
		["name"] = "Training_targets_IA template activate",
		["once"] = true,
	},
	[18] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"Training_targets\", false)",
			[2] = "Action.TemplateDeactivate(\"Training_targets.stm\")",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 1",
		["name"] = "Training_targets Deactivate",
		["once"] = true,
	},
	[19] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"Training_targets_IA\", false)",
			[2] = "Action.TemplateDeactivate(\"Training_targets_IA.stm\")",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 1",
		["name"] = "Training_targets_IA Deactivate",
		["once"] = true,
	},
	[20] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"Recon Hanoi high\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 1",
		["name"] = "Recon Hanoi high Activation",
		["once"] = true,
	},
	[21] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"Recon Hanoi low\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 1",
		["name"] = "Recon Hanoi low Activation",
		["once"] = true,
	},
	[22] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"Recon Haiphong high\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 1",
		["name"] = "Recon Haiphong high Activation",
		["once"] = true,
	},
	[23] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"Recon Haiphong low\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 1",
		["name"] = "Recon Haiphong low Activation",
		["once"] = true,
	},
	[24] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"Tanker Track E1\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 20",
		["name"] = "Tanker Track E1 Activation",
		["once"] = true,
	},
	[25] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"Tanker Track E2\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 20",
		["name"] = "Tanker Track E2 Activation",
		["once"] = true,
	},
	[26] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"Tanker Track E3\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 20",
		["name"] = "Tanker Track E3 Activation",
		["once"] = true,
	},
	[27] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"Tanker Track E4\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 20",
		["name"] = "Tanker Track E4 Activation",
		["once"] = true,
	},
	[28] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"Tanker Track Navy1\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 20",
		["name"] = "Tanker Track Navy1 Activation",
		["once"] = true,
	},
	[29] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"Tanker Track Navy2\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 20",
		["name"] = "Tanker Track Navy2 Activation",
		["once"] = true,
	},
	[30] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"Tanker Track Navy3\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 20",
		["name"] = "Tanker Track Navy3 Activation",
		["once"] = true,
	},
	[31] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"Tanker Track Navy4\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 20",
		["name"] = "Tanker Track Navy4 Activation",
		["once"] = true,
	},
	[32] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"Sweep Ho Chi Mihn\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 1",
		["name"] = "Sweep Ho Chi Mihn",
		["once"] = true,
	},
	[33] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"Sweep Khe Sanh\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 2",
		["name"] = "Sweep Khe Sanh",
		["once"] = true,
	},
	[34] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"VC_Inf_camp-1\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 1",
		["name"] = "VC_Inf_camp-1",
		["once"] = true,
	},
	[35] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"VC_Inf_camp-2\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 1",
		["name"] = "VC_Inf_camp-2",
		["once"] = true,
	},
	[36] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"VC_Inf_camp-3\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 1",
		["name"] = "VC_Inf_camp-3",
		["once"] = true,
	},
	[37] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"VC_Inf_camp-4\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 1",
		["name"] = "VC_Inf_camp-4",
		["once"] = true,
	},
	[38] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"VC_Inf_camp-5\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 1",
		["name"] = "VC_Inf_camp-5",
		["once"] = true,
	},
	[39] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"VC_Inf_camp-6\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 1",
		["name"] = "VC_Inf_camp-6",
		["once"] = true,
	},
	[40] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"VC_Inf_camp-7\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 1",
		["name"] = "VC_Inf_camp-7",
		["once"] = true,
	},
	[41] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"VC_Inf_camp-8\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 1",
		["name"] = "VC_Inf_camp-8",
		["once"] = true,
	},
	[42] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"VC_Inf_camp-9\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 1",
		["name"] = "VC_Inf_camp-9",
		["once"] = true,
	},
	[43] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"VC_ammo_fuel_storage-1\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 1",
		["name"] = "VC_ammo_fuel_storage-1",
		["once"] = true,
	},
	[44] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"VC_ammo_fuel_storage-2\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 1",
		["name"] = "VC_ammo_fuel_storage-2",
		["once"] = true,
	},
	[45] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"VC_ammo_fuel_storage-3\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 1",
		["name"] = "VC_ammo_fuel_storage-3",
		["once"] = true,
	},
	[46] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"VC_Ho_Chi_Minh_Convoy-1\", true)",
			[2] = "Action.TargetPriority(\"VC_Ho_Chi_Minh_Convoy-1\", 35)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 1",
		["name"] = "VC_Ho_Chi_Minh_Convoy-1",
		["once"] = true,
	},
	[47] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"SAM-SA-2_Hanoi-South\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 6",
		["name"] = "SAM-SA-2_Hanoi-South",
		["once"] = true,
	},
	[48] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"SAM-SA-2_Hanoi-South-AA\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 6",
		["name"] = "SAM-SA-2_Hanoi-South-AA",
		["once"] = true,
	},
	[49] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"SAM-SA-2_Kien-An\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 5",
		["name"] = "SAM-SA-2_Kien-An",
		["once"] = true,
	},
	[50] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"SAM-SA-2_Kien-An-AA\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 5",
		["name"] = "SAM-SA-2_Kien-An-AA",
		["once"] = true,
	},
	[51] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"SAM-SA-2_Ban-Puoi\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 5",
		["name"] = "SAM-SA-2_Ban-Puoi",
		["once"] = true,
	},
	[52] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"SAM-SA-2_Ban-Puoi-AA\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 5",
		["name"] = "SAM-SA-2_Ban-Puoi-AA",
		["once"] = true,
	},
	[53] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"SAM-SA-2_Vihn\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 3",
		["name"] = "SAM-SA-2_Vihn",
		["once"] = true,
	},
	[54] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"SAM-SA-2_Vihn-AA\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 3",
		["name"] = "SAM-SA-2_Vihn-AA",
		["once"] = true,
	},
	[55] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"SAM-SA-2_South-Coast\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 3",
		["name"] = "SAM-SA-2_South-Coast",
		["once"] = true,
	},
	[56] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"SAM-SA-2_South-Coast-AA\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 3",
		["name"] = "SAM-SA-2_South-Coast-AA",
		["once"] = true,
	},
	[57] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"SAM-SA-2_South-Center\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 3",
		["name"] = "SAM-SA-2_South-Center",
		["once"] = true,
	},
	[58] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"SAM-SA-2_South-Center-AA\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 3",
		["name"] = "SAM-SA-2_South-Center-AA",
		["once"] = true,
	},
	[59] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"SAM-SA-2_East\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 3",
		["name"] = "SAM-SA-2_East",
		["once"] = true,
	},
	[60] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"SAM-SA-2_East-AA\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 3",
		["name"] = "SAM-SA-2_East-AA",
		["once"] = true,
	},
	[61] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"SAM-SA-2_South-West\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 3",
		["name"] = "SAM-SA-2_South-West",
		["once"] = true,
	},
	[62] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"SAM-SA-2_South-West-AA\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 3",
		["name"] = "SAM-SA-2_South-West-AA",
		["once"] = true,
	},
	[63] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"Rail Bridge Kien An\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 6",
		["name"] = "Rail Bridge Kien An",
		["once"] = true,
	},
	[64] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"Road Bridge Kien An\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 6",
		["name"] = "Road Bridge Kien An",
		["once"] = true,
	},
	[65] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"Ban Puoi Airbase\", false)",
			[2] = "Action.TargetPriority(\"Ban Puoi Airbase\", 1)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 0",
		["name"] = "Ban Puoi Airbase false",
		["once"] = true,
	},
	[66] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"Ban Puoi Airbase Runway\", false)",
			[2] = "Action.TargetPriority(\"Ban Puoi Airbase Runway\", 1)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 0",
		["name"] = "Ban Puoi Airbase Runway false",
		["once"] = true,
	},
	[67] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"Vihn Airbase\", false)",
			[2] = "Action.TargetPriority(\"Vihn Airbase\", 1)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 0",
		["name"] = "Vihn Airbase false",
		["once"] = true,
	},
	[68] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"Vihn Airbase Runway\", false)",
			[2] = "Action.TargetPriority(\"Vihn Airbase Runway\", 1)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 0",
		["name"] = "Vihn Airbase Runway false",
		["once"] = true,
	},
	[69] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"Kien An Airbase\", false)",
			[2] = "Action.TargetPriority(\"Kien An Airbase\", 1)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 0",
		["name"] = "Kien An Airbase false",
		["once"] = true,
	},
	[70] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"Kien An Airbase Runway\", false)",
			[2] = "Action.TargetPriority(\"Kien An Airbase Runway\", 1)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 0",
		["name"] = "Kien An Airbase Runway false",
		["once"] = true,
	},
	[71] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"Ban Puoi Airbase\", true)",
			[2] = "Action.TargetPriority(\"Ban Puoi Airbase\", 7)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 6",
		["name"] = "Ban Puoi Airbase",
		["once"] = true,
	},
	[72] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"Ban Puoi Airbase Runway\", true)",
			[2] = "Action.TargetPriority(\"Ban Puoi Airbase Runway\", 8)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 6",
		["name"] = "Ban Puoi Airbase Runway",
		["once"] = true,
	},
	[73] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"Vihn Airbase\", true)",
			[2] = "Action.TargetPriority(\"Vihn Airbase\", 7)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 4",
		["name"] = "Vihn Airbase",
		["once"] = true,
	},
	[74] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"Vihn Airbase Runway\", true)",
			[2] = "Action.TargetPriority(\"Vihn Airbase Runway\", 8)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 4",
		["name"] = "Vihn Airbase Runway",
		["once"] = true,
	},
	[75] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"Haiphong Airbase\", true)",
			[2] = "Action.TargetPriority(\"Haiphong Airbase\", 7)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 5",
		["name"] = "Haiphong Airbase",
		["once"] = true,
	},
	[76] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"Haiphong Airbase Runway\", true)",
			[2] = "Action.TargetPriority(\"Haiphong Airbase Runway\", 8)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 5",
		["name"] = "Haiphong Airbase Runway",
		["once"] = true,
	},
	[77] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"Hanoi Airbase\", true)",
			[2] = "Action.TargetPriority(\"Hanoi Airbase\", 7)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 5",
		["name"] = "Hanoi Airbase",
		["once"] = true,
	},
	[78] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"Hanoi Airbase Runway\", true)",
			[2] = "Action.TargetPriority(\"Hanoi Airbase Runway\", 8)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 5",
		["name"] = "Hanoi Airbase Runway",
		["once"] = true,
	},
	[79] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"Kien An Airbase\", true)",
			[2] = "Action.TargetPriority(\"Kien An Airbase\", 7)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 6",
		["name"] = "Kien An Airbase",
		["once"] = true,
	},
	[80] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"Kien An Airbase Runway\", true)",
			[2] = "Action.TargetPriority(\"Kien An Airbase Runway\", 8)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 6",
		["name"] = "Kien An Airbase Runway",
		["once"] = true,
	},
	[81] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"Hanoi Airbase Alert\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 1",
		["name"] = "Hanoi Airbase Alert",
		["once"] = true,
	},
	[82] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"Vihn Airbase Alert\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 1",
		["name"] = "Vihn Airbase Alert",
		["once"] = true,
	},
	[83] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"Ban Puoi Airbase Alert\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 1",
		["name"] = "Ban Puoi Airbase Alert",
		["once"] = true,
	},
	[84] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"Kien An Airbase Alert\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 2",
		["name"] = "Kien An Airbase Alert",
		["once"] = true,
	},
	[85] = 
	{
		["action"] = 
		{
			[1] = "Action.TargetActive(\"Haiphong Airbase Alert\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 3",
		["name"] = "Haiphong Airbase Alert",
		["once"] = true,
	},
	[86] = 
	{
		["action"] = 
		{
			[1] = "Action.AirUnitActive(\"RVAH-1\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 1",
		["name"] = "RVAH-1 Activation",
		["once"] = true,
	},
	[87] = 
	{
		["action"] = 
		{
			[1] = "Action.AirUnitActive(\"333rd TFS\", false)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 3",
		["name"] = "333rd TFS Desactivation",
		["once"] = true,
	},
	[88] = 
	{
		["action"] = 
		{
			[1] = "Action.AirUnitActive(\"174 ARW\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 20",
		["name"] = "174 ARW Activation",
		["once"] = true,
	},
	[89] = 
	{
		["action"] = 
		{
			[1] = "Action.AirUnitActive(\"90th TFS\", false)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 4",
		["name"] = "90th TFS Desactivation",
		["once"] = true,
	},
	[90] = 
	{
		["action"] = 
		{
			[1] = "Action.AirUnitActive(\"602nd FS\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 1",
		["name"] = "602nd FS Activation",
		["once"] = true,
	},
	[91] = 
	{
		["action"] = 
		{
			[1] = "Action.AirUnitActive(\"6234th TFS\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 3",
		["name"] = "6234th TFS Activation",
		["once"] = true,
	},
	[92] = 
	{
		["action"] = 
		{
			[1] = "Action.AirUnitActive(\"34th TFS\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 5",
		["name"] = "34th TFS Activation",
		["once"] = true,
	},
	[93] = 
	{
		["action"] = 
		{
			[1] = "Action.AirUnitActive(\"4th TFS\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 6",
		["name"] = "4th TFS Activation",
		["once"] = true,
	},
	[94] = 
	{
		["action"] = 
		{
			[1] = "Action.AirUnitActive(\"VA-163\", false)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 6",
		["name"] = "VA-163 Desactivation",
		["once"] = true,
	},
	[95] = 
	{
		["action"] = 
		{
			[1] = "Action.AirUnitActive(\"21st RAC\", false)",
			[2] = "Action.Text(\"The old O-1 Bird dogs are replaced now and will cease AFAC mission now\")",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 2",
		["name"] = "21st RAC Desactivation",
		["once"] = true,
	},
	[96] = 
	{
		["action"] = 
		{
			[1] = "Action.AirUnitActive(\"69 BS\", true)",
			[2] = "Action.Text(\"B-52H from 96 BS are authorized to launch long range missions against NVA targets\")",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 3",
		["name"] = "Activation B-52H",
		["once"] = true,
	},
	[97] = 
	{
		["action"] = 
		{
			[1] = "Action.AirUnitActive(\"128th TFS\", true)",
			[2] = "Action.Text(\"A new electronic warfare plane enters service now : F-105G. It should protect bomber raids against SA-2\")",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 3",
		["name"] = "128th TFS Activation",
		["once"] = true,
	},
	[98] = 
	{
		["action"] = 
		{
			[1] = "Action.AirUnitActive(\"VAQ-132\", true)",
			[2] = "Action.Text(\"A brand new electronic warfare plane enters service now : EA-6 Prowler. It should protect bomber raids against SA-2\")",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 8",
		["name"] = "VAQ-132 Activation",
		["once"] = true,
	},
	[99] = 
	{
		["action"] = 
		{
			[1] = "Action.AirUnitActive(\"VA-65\", true)",
			[2] = "Action.Text(\"A brand new attack plane enters service now : A-6 Intruder. It should be more efficient than old A-4E Skyhawk\")",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 6",
		["name"] = "VA-65 Activation",
		["once"] = true,
	},
	[100] = 
	{
		["action"] = 
		{
			[1] = "Action.AirUnitActive(\"RVNAF 522nd FS\", true)",
			[2] = "Action.Text(\"South Vietnam Air Force received new F-5E Tiger fighter-bombers. It should help us to attack NVA forces.\")",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 4",
		["name"] = "RVNAF 522nd FS Activation",
		["once"] = true,
	},
	[101] = 
	{
		["action"] = 
		{
			[1] = "Action.AirUnitActive(\"504th FAC\", true)",
			[2] = "Action.Text(\"A brand new AFAC plane enters service now : OV-10A Bronco. It should help to find more targets for our bombers.\")",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 2",
		["name"] = "504th FAC Activation",
		["once"] = true,
	},
	[102] = 
	{
		["action"] = 
		{
			[1] = "Action.AirUnitActive(\"921st FR-PFM\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 2",
		["name"] = "921st FR-PFM Activation",
		["once"] = true,
	},
	[103] = 
	{
		["action"] = 
		{
			[1] = "Action.AirUnitActive(\"927th-1 FR-PFM\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 0",
		["name"] = "927th-1 FR-PFM Activation",
		["once"] = true,
	},
	[104] = 
	{
		["action"] = 
		{
			[1] = "Action.AirUnitActive(\"927th-2 FR-PFM\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 3",
		["name"] = "927th-2 FR-PFM Activation",
		["once"] = true,
	},
	[105] = 
	{
		["action"] = 
		{
			[1] = "Action.AirUnitActive(\"921st FR-PFM\", false)",
			[2] = "Action.AirUnitActive(\"921st FR-MF\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 8",
		["name"] = "921st FR-PFM DeActivation",
		["once"] = true,
	},
	[106] = 
	{
		["action"] = 
		{
			[1] = "Action.AirUnitActive(\"927th-1 FR-PFM\", false)",
			[2] = "Action.AirUnitActive(\"927th-1 FR-MF\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 7",
		["name"] = "927th-1 FR-PFM DeActivation",
		["once"] = true,
	},
	[107] = 
	{
		["action"] = 
		{
			[1] = "Action.AirUnitActive(\"927th-2 FR-PFM\", false)",
			[2] = "Action.AirUnitActive(\"927th-2 FR-MF\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 8",
		["name"] = "927th-2 FR-PFM DeActivation",
		["once"] = true,
	},
	[108] = 
	{
		["action"] = 
		{
			[1] = "Action.AirUnitActive(\"923rd-1 FR\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 0",
		["name"] = "923rd-1 FR Activation",
		["once"] = true,
	},
	[109] = 
	{
		["action"] = 
		{
			[1] = "Action.AirUnitActive(\"923rd-2 FR\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 0",
		["name"] = "923rd-2 FR Activation",
		["once"] = true,
	},
	[110] = 
	{
		["action"] = 
		{
			[1] = "Action.AirUnitActive(\"925th FR\", true)",
		},
		["active"] = true,
		["condition"] = "Return.Mission() > 8",
		["name"] = "925th FR Activation",
		["once"] = true,
	},
	[111] = 
	{
		["action"] = 
		{
			[1] = "Action.GroundUnitRepair()",
		},
		["active"] = true,
		["condition"] = "true",
		["name"] = "GroundUnitRepair",
	},
	[112] = 
	{
		["action"] = 
		{
			[1] = "Action.AirUnitRepair()",
		},
		["active"] = true,
		["condition"] = "true",
		["name"] = "Repair",
	},
	[113] = 
	{
		["action"] = 
		{
			[1] = "Action.AddGroundTargetIntel(\"blue\")",
		},
		["active"] = true,
		["condition"] = "true",
		["name"] = "Blue Ground Target Briefing Intel",
	},
	[114] = 
	{
		["action"] = 
		{
			[1] = "Action.AddGroundTargetIntel(\"red\")",
		},
		["active"] = true,
		["condition"] = "true",
		["name"] = "Red Ground Target Briefing Intel",
	},
}
