--Initial status of the campaign (static file, not updated)
--Copied to camp_status.lua and for use in running campaign
--Fixed for the whole life of the campaign: editable by the campaignMaker only, before the campaign is launched.
--Whole file is campaignMaker-only, so no per-field @ui audience tag is needed here (unlike conf_mod.lua).
-------------------------------------------------------------------------------------------------------

REF_camp = {
	title         = "",             -- @ui text group="Identity" label="Campaign title" help=Name displayed for the campaign and used to build mission file names. [default: ""]
	version       = "",              -- @ui text group="Identity" label="Version" help=Free-text version tag for this campaign package. [default: ""]
	campaignId    = "",             -- @ui text group="Identity" label="Campaign ID" help=Internal identifier used to link this campaign to its repository and to update checks. [default: ""]
	repositoryUrl = "",             -- @ui text group="Identity" label="Repository URL" help=Source repository for this campaign. [default: ""]
	code_loadout  = "",             -- @ui text group="Identity" label="Loadout code" help=Code selecting which loadouts of the central db_loadouts this campaign uses (must exist in campaigns_code_loadout). Leave empty to auto-detect from the campaign title (legacy behaviour). [default: ""]
	mission       = 1,              -- @ui numeric min=1 group="Identity" label="Starting mission number" help=Mission number the campaign starts at (almost always 1). [default: 1]

	date = {                             --campaign date
		day   = 1,  -- @ui numeric min=1 max=31 group="Start date" label="Day" help=Calendar day the campaign starts on. [default: 1]
		year  = 2000, -- @ui numeric min=1940 max=2100 group="Start date" label="Year" help=Calendar year the campaign starts on. [default: 1996]
		month = 01, -- @ui numeric min=1 max=12 group="Start date" label="Month" help=Calendar month the campaign starts on. [default: 1]
	},
	time      = 17700, -- @ui numeric min=0 max=86400 group="Start date" label="Time of day (s)" help=Daytime in seconds since midnight at campaign start (17700 = 04:55). [default: 0]
	variation = 2,     -- @ui numeric min=-30 max=30 group="Geography" label="Magnetic variation" help=Variation in degrees from true north to magnetic north for this theatre. [default: 0]

	ewrFreqAdaptable = true, -- @ui checkbox group="Geography" label="Adaptive EWR frequencies" help=If enabled, EWR frequencies are generated adaptively from campaign start; fixed for the whole campaign. [default: true]

	pictureBrief = { -- @ui list group="Briefing pictures" label="Pictures" help=Filenames of the briefing pictures for this campaign (one section per side below).
		blue = { -- @ui list group="Briefing pictures" label="Blue side" help=Filenames of the briefing pictures shown to the blue side, one per line.
			"Frontline1.png",
		},--pictureBrief
		red = { -- @ui list group="Briefing pictures" label="Red side" help=Filenames of the briefing pictures shown to the red side, one per line.
			"Frontline1.png",
		},--pictureBrief
	},
	wargame_config = {
		-- ===== General =====
		country_blue = "Blue", -- @ui text group="Wargame" label="Blue side name" help=Name of the blue side (e.g. US). Only a label: shown in the wargame editor and map. It does not change any game rule. [default: "Blue"]
		country_red  = "Red",  -- @ui text group="Wargame" label="Red side name" help=Name of the red side (e.g. Iran). Only a label: shown in the wargame editor and map. It does not change any game rule. [default: "Red"]
		zone_edge_margin_meters = 1000,  -- @ui numeric min=0 max=10000 group="Wargame" label="Border safety distance (m)" help=When ground units are placed in a zone, they stay at least this far from any border shared with an enemy zone. Bigger = units start further apart (no point-blank fights at mission start). Smaller = units can start right on the front line. [default: 1000]
		dcs_zone_depth = 1, -- @ui numeric min=0 max=20 group="Wargame" label="Zones played in DCS" help=Only the formations in front line zones, and in this many zones behind them, are placed as units in the DCS missions. The others stay on the wargame map as numbers only: they keep their strength and are placed in DCS when the front gets close. 0 = front line zones only. 1 = front line plus one zone behind. 20 = everything is placed (old behaviour, more units in DCS). Lower = fewer units, faster missions. [default: 1]

		-- ===== Combat (how a zone is won or lost) =====
		control_flip_threshold = 0.25, -- @ui numeric min=0 max=0.9 group="Wargame - combat" label="Conquest difficulty" help=How much stronger than the defender an attacker must be to take a zone. 0 = any advantage is enough. 0.25 = attacker needs about 1.7x the defender strength. 0.5 = about 3x. Higher = the front moves slowly. Lower = the front moves fast. [default: 0.25]
		random_variance = 0, -- @ui numeric min=0 max=0.5 group="Wargame - combat" label="Luck" help=Random factor on each fight. 0 = no luck: same forces always give the same result. 0.2 = each side's strength can vary by about 20% up or down, so a slightly weaker attacker can still win. [default: 0]
		retreat_loss_fraction = 0.05, -- @ui numeric min=0 max=0.5 group="Wargame - combat" label="Loss when retreating" help=Share of its strength a formation loses each time it falls back after losing a zone (it retreats in disorder). 0 = no loss. 0.05 = loses 5%. A formation pushed back several times can end up disbanded (see "Disband weak formations" in the army group). [default: 0.05]
		combat_attrition = 0.02, -- @ui numeric min=0 max=0.2 group="Wargame - combat" label="Wear in combat" help=Share of its strength that each formation loses, every mission, when it takes part in a fight on an active axis (both sides). 0 = fights cost nothing: only air strikes wear formations down. 0.02 = 2% per mission. Keep it small so the war stays driven by air power. [default: 0.02]
		front_alignment = true, -- @ui checkbox group="Wargame - combat" label="Straighten the front" help=If enabled, the DEFENDING side pulls back its zones that stick out into the attacker (surrounded by more enemy neighbours than friendly ones) after each mission, so its front line stays tidy. The attacking side (the one holding the start zone of an active axis) never pulls back this way. If disabled, nobody pulls back. [default: true]

		-- ===== Army (formations, reinforcements, movement) =====
		max_formations_per_zone = 3, -- @ui numeric min=1 max=30 group="Wargame - army" label="Formations per zone" help=Normal number of formations a zone can hold. Formations that retreat or advance need a free place; a formation with no place to go is lost. A front line zone can hold more when the enemy in front of it is stronger, so it can gather enough force. [default: 3]
		max_formations_hard = 6, -- @ui numeric min=1 max=60 group="Wargame - army" label="Maximum formations per zone" help=Absolute limit of formations in one zone, even when the enemy in front is very strong (a front line zone can hold more than "Formations per zone" to face a strong enemy, but never more than this). It also limits the number of units placed in DCS. Must be at least "Formations per zone". [default: 6]
		disband_below_fraction = 0.25, -- @ui numeric min=0 max=0.9 group="Wargame - army" label="Disband weak formations" help=A formation whose strength falls below this share of its full strength is disbanded and removed from the missions. 0.25 = below 25%. 0 = never disbanded (very weak formations stay on the map). [default: 0.25]
		supply_recovery_rate = 0.10, -- @ui numeric min=0 max=1 group="Wargame - army" label="Reinforcement speed" help=Share of its full strength a formation can recover between two missions, on a good road and away from the front line. 0.10 = 10% per mission (about 10 missions to recover fully). Front line zones recover half as much, poor tracks and cut-off zones recover less or nothing. 0 = no reinforcement at all. [default: 0.10]
		engaged_recovery = 0.25, -- @ui numeric min=0 max=1 group="Wargame - army" label="Recovery while fighting" help=How much of its normal recovery a formation keeps in a mission where it fought (attacking or defending). 1 = recovers as usual (an offensive never wears out). 0.25 = recovers a quarter as much. 0 = no recovery while fighting. [default: 0.25]
		axis_reinforcement = true, -- @ui checkbox group="Wargame - army" label="Reinforcements follow the front" help=If enabled, formations behind the front move up toward it, one zone per mission, and gather in the front line zones (flanks included), so most of the army ends up in contact with the enemy. A front zone takes more formations when the enemy in front of it is strong. If disabled, formations only move when they advance after a conquest or retreat. [default: true]
		empty_zone_influence = true, -- @ui checkbox group="Wargame - army" label="Empty zones follow influence" help=If enabled, a zone with no force in it goes to the side that has clearly more force around it (neighbour zones count fully, zones two steps away count half). Undefended flanks and rear zones fall without a fight, one ring per mission. If disabled, an empty zone keeps its owner until an axis attack reaches it. [default: true]

		-- ===== Terrain and roads (one row per type, set per zone in the wargame editor) =====
		terrain = { -- @ui matrix group="Wargame - terrain and roads" label="Terrain" rows="plain:Plain,hills:Hills,mountain:Mountain,urban:Urban,coastal:Coastal" cols="1:Defense x" help=How much the terrain helps the DEFENDER of a zone. 1.0 = no effect. 1.5 = the defender counts as 50% stronger. Below 1.0 = the defender is weaker. Allowed 0.5 to 3. [default: plain 1.0, hills 1.3, mountain 1.8, urban 1.6, coastal 1.1]
			plain    = { 1.0 },
			hills    = { 1.3 },
			mountain = { 1.8 },
			urban    = { 1.6 },
			coastal  = { 1.1 },
		},
		supply_route = { -- @ui matrix group="Wargame - terrain and roads" label="Supply route" rows="none:No road,track:Track,road:Road,highway:Highway" cols="1:Recovery x,2:Combat x" help=Recovery x: multiplies how fast formations in the zone regain strength (see "Reinforcement speed"). Combat x: multiplies the strength of the formations of the zone in a fight, attacking or defending. 1.0 = no effect. Allowed 0 to 3 for Recovery, 0.1 to 3 for Combat. Tip: if you do not want roads to change the fights, set the whole Combat column to 1.0. [default: none 0.25/0.25, track 0.5/0.5, road 1.0/1.0, highway 1.5/1.5]
			none    = { 0.25, 0.25 },
			track   = { 0.5,  0.5  },
			road    = { 1.0,  1.0  },
			highway = { 1.5,  1.5  },
		},
	}

	-- ANY MODIFICATIONS IN THIS FILE NEED TO RESTART ALL THE CAMPAIGN USING FIRSTMISSION.BAT FILE
}
