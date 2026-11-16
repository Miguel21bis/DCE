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

		-- ===== Combat =====
		control_flip_threshold = 0.25, -- @ui numeric min=0 max=0.9 group="Wargame - combat" label="Conquest difficulty" help=How much stronger than the defender an attacker must be to take a zone. 0 = any advantage is enough. 0.25 = attacker needs about 1.7x the defender strength. 0.5 = about 3x. Higher = the front moves slowly. Lower = the front moves fast. [default: 0.25]
		random_variance = 0, -- @ui numeric min=0 max=0.5 group="Wargame - combat" label="Luck" help=Random factor on each fight. 0 = no luck: same forces always give the same result. 0.2 = each side's strength can vary by about 20% up or down, so a slightly weaker attacker can still win. [default: 0]

		-- ===== Army =====
		max_formations_per_zone = 3, -- @ui numeric min=1 max=30 group="Wargame - army" label="Formations per zone" help=Strict limit of formations in a zone, and number of formations that fight in it (the strongest ones). A zone never receives more: a formation with no free place waits in the zone behind (but a retreating formation with no place to go is lost). Extra formations placed by hand in the editor stay in the zone but do not fight. [default: 3]
		disband_below_fraction = 0.25, -- @ui numeric min=0 max=0.9 group="Wargame - army" label="Disband weak formations" help=A formation whose strength falls below this share of its full strength is disbanded and removed from the missions. 0.25 = below 25%. 0 = never disbanded (very weak formations stay on the map). [default: 0.25]
		supply_recovery_rate = 0.10, -- @ui numeric min=0 max=1 group="Wargame - army" label="Reinforcement speed" help=Share of its full strength a formation can recover between two missions, on a good road and away from the front line. 0.10 = 10% per mission (about 10 missions to recover fully). Front line zones recover half as much, poor tracks and cut-off zones recover less or nothing. 0 = no reinforcement at all. [default: 0.10]

		-- Fine tuning (terrain, roads, supply, wear, movement...) is in Init/Wargame/wargame_balance.lua (optional file: if missing, DCE_Manager uses its built-in values).
	}

	-- ANY MODIFICATIONS IN THIS FILE NEED TO RESTART ALL THE CAMPAIGN USING FIRSTMISSION.BAT FILE
}
