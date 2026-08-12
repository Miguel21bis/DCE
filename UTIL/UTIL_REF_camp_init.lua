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

	-- ANY MODIFICATIONS IN THIS FILE NEED TO RESTART ALL THE CAMPAIGN USING FIRSTMISSION.BAT FILE
}