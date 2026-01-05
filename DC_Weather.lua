--Weather
--Initiated by MAIN_NextMission.lua
------------------------------------------------------------------------------------------------------- 
------------------------------------------------------------------------------------------------------- 
-- last modification: debug_f
if not versionDCE then versionDCE = {} end
versionDCE["DC_Weather.lua"] = "1.6.26"
------------------------------------------------------------------------------------------------------- 
-- cleanCode_f				(e springCleaning)					
-- adjustment_h				(h baseChoice)(f \\\n to \n)(e debug info)(d preset = nil)(c adds METAR to dynamic cloud presets, where possible) (b CampTotalTimeS)(a: high 2 days max)
-- debug_f					(f WeatherParams)(e: cloud/METAR altitudes above 10000ft were not displayed)(d very bad weather during a cold sector)%chance pHigh pLow 
-- modification M53_b		automatic update of the conf_mod file (b conf_mod reconfiguration)
-- modification M51_c		Moonphase
-- modification M45_e		compatible with 2.7.0s  (e: debug cleaning)(d: less clounds in the PG)(c: debugWeather)
------------------------------------------------------------------------------------------------------- 

if Debug.debug then
	print("START DC_Weather.lua "..versionDCE["DC_Weather.lua"].." =-=-=-=-=-=-=-=-=-=-=-=-=-=-=")
end

-- weather = {
--     trend         = 70,   -- (0–100) : 0 = dépression forte / pluie, 100 = anticyclone stable / ciel clair
--     refTemp       = 28,   -- (°C) température moyenne diurne (point d’équilibre)
--     instability   = 40,   -- (0–100) : fréquence et amplitude des changements météo
--     windActivity  = 35,   -- (0–100) : intensité générale du vent
-- }

-- mission_ini.weather = {
--     trend = 35,        -- dépression faible → nuages, pluie possible
--     refTemp = 32,      -- température moyenne
--     instability = 60,  -- météo changeante
--     windActivity = 8,  -- 8 m/s au sol (~28 km/h)
-- }


-- debugTxt = debugTxt .."".."\n"


	-- ["weather"] = 
	-- {
	-- 	["wind"] = 
	-- 	{
	-- 		["at8000"] = 
	-- 		{
	-- 			["speed"] = 0,
	-- 			["dir"] = 0,
	-- 		}, -- end of ["at8000"]
	-- 		["atGround"] = 
	-- 		{
	-- 			["speed"] = 0,
	-- 			["dir"] = 0,
	-- 		}, -- end of ["atGround"]
	-- 		["at2000"] = 
	-- 		{
	-- 			["speed"] = 0,
	-- 			["dir"] = 0,
	-- 		}, -- end of ["at2000"]
	-- 	}, -- end of ["wind"]
	-- 	["enable_fog"] = false,
	-- 	["season"] = 
	-- 	{
	-- 		["temperature"] = 20,
	-- 	}, -- end of ["season"]
	-- 	["qnh"] = 760,
	-- 	["cyclones"] = {},
	-- 	["dust_density"] = 0,
	-- 	["enable_dust"] = false,
	-- 	["clouds"] = 
	-- 	{
	-- 		["thickness"] = 200,
	-- 		["density"] = 0,
	-- 		["preset"] = "Preset20",
	-- 		["base"] = 3800,
	-- 		["iprecptns"] = 0,
	-- 	}, -- end of ["clouds"]
	-- 	["atmosphere_type"] = 0,
	-- 	["groundTurbulence"] = 0,
	-- 	["halo"] = 
	-- 	{
	-- 		["preset"] = "auto",
	-- 	}, -- end of ["halo"]
	-- 	["type_weather"] = 0,
	-- 	["modifiedTime"] = false,
	-- 	["name"] = "Winter, clean sky",
	-- 	["fog"] = 
	-- 	{
	-- 		["visibility"] = 0,
	-- 		["thickness"] = 0,
	-- 	}, -- end of ["fog"]
	-- 	["visibility"] = 
	-- 	{
	-- 		["distance"] = 80000,
	-- 	}, -- end of ["visibility"]
	-- }, -- end of ["weather"]


-- 1	Light Scattered 1	FEW/SCT 7/8	25%
-- 2	Light Scattered 2	FEW/SCT 8/10 SCT 23/24	33%
-- 3	High Scattered 1	SCT 8/9 FEW 21	50%
-- 4	High Scattered 2	SCT 8/10 FEW 24/26	50%
-- 5	High Scattered 3	SCT/BKN  18/20 FEW 36/38 FEW 40	67%
-- 6	Scattered 1	SCT 14/17 FEW 27/29 BKN 40	50%
-- 7	Scattered 2	SCT/BKN 8/10 FEW 40	67%
-- 8	Scattered 3	BKN 7.5/12 SCT/BKN 21/23 SCT 40	75%
-- 9	Scattered 4	BKN 7.5/10 SCT 20/22	75%
-- 10	Scattered 5	SCT/BKN 18/20 FEW 36/38 FEW 40	67%
-- 11	Scattered 6	BKN 18/20 BKN 32/33 FEW 41	75%
-- 12	Scattered 7	BKN 12/14 SCT 22/23 FEW 41	75%
-- 13	Broken 1	BKN 12/14 BKN 26/28 FEW 41	75%
-- 14	Broken 2	BKN/LYR 7/16 FEW 41	87%
-- 15	Broken 3	SCT/BKN 14/18 BKN 24/27 FEW 41	67%
-- 16	Broken 4	BKN 14/18 BKN 28/30 FEW 40	75%
-- 17	Broken 5	BKN/OVC 7/13 20/22 32/34	87%
-- 18	Broken 6	BKN/OVC 13/15 25/29 38/41	87%
-- 19	Broken 7	OVC 9/16 BKN/OVC 23/24 31/33	100%
-- 20	Broken 8	BKN/OVC 13/18 BKN 28/30 SCT/FEW 38	87%
-- 21	Overcast 1	BKN/OVC 7/8 17/19	87%
-- 22	Overcast 2	BKN/OVC 7/10 17/20	87%
-- 23	Overcast 3	BKN/OVC 11/14 18/25 SCT 32/35	87%
-- 24	Overcast 4	BKN/OVC 3/7 17/22 BKN 34	87%
-- 25	Overcast 5	OVC 12/14 22/25 40/42	87%
-- 26	Overcast 6	OVC 9/15 BKN 23/25 SCT 32	100%
-- 27	Overcast 7	OVC 8/15 SCT/BKN 25/26 34/36	100%
-- 28	RainyPreset1/ Overcast and Rain 1/	VIS3-5KM RA OVC 3/15 28/30 FEW 40	100%
-- 29	RainyPreset2/ Overcast and Rain 2/	VIS 1-5KM RA OVC 3/11 SCT 18/29 FEW 40	100%
-- 30	RainyPreset3/ Overcast and Rain 3/	VIS 3.5KM RA OVC 6/18 19/21 SCT 34	100%
-- 31	RainyPreset4/ Light Rain 1/ Two Layers Scattered Large Thick Clouds  \nMETAR: SCT/BKN 18/20 FEW36/38 FEW 40
-- 32	RainyPreset5/ Light Rain 2/ Three Layers Broken/Overcast \nMETAR: BKN/OVC LYR 7/13 20/22 32/34
-- 33	RainyPreset6/ Light Rain 3/ Three Layers Overcast At Low Level \nMETAR: OVC 9/16 BKN/OVC LYR 23/24 31/33
-- 34	NEWRAINPRESET4/ Light Rain 4/ Two Layers Overcast At Low Level \nMETAR: BKN/OVC 7/8 17/19

local preset = {
	[1] = {
		altiMin = 840,
		altiMax = 4100,
		name = "Preset1",
		nameVignette = "Light Scattered 1",
		thickness = 200,
		--FEW/SCT 7/8
		layers = {
			{
				presetMetar = "FEW/SCT",
				base = 7,
				ceiling = 8,
			},
		},
		cover = 25,
	},
	[2] = {
		altiMin = 1260,
		altiMax = 2520,
		name = "Preset2",
		nameVignette = "Light Scattered 2",

		thickness = 200,
		nameMETAR = "FEW/SCT 8/10 SCT 23/24",
		layers = {
			{
				presetMetar = "FEW/SCT",
				base = 8,
				ceiling = 10,
			},
			{
				presetMetar = "SCT",
				base = 23,
				ceiling = 24,
			},
		},
		cover = 33,
	},
	[3] = {
		altiMin = 840,
		altiMax = 2520,
		name = "Preset3",
		nameVignette = "Hight Scattered 1",
		nameMETAR = "SCT 8/9 FEW 21",
		layers = {
			{
				presetMetar = "SCT",
				base = 8,
				ceiling = 9,
			},
			{
				presetMetar = "FEW",
				base = 21,
				ceiling = 0,
			},
		},
		cover = 50,
	},
	[4] = {
		altiMin = 1260,
		altiMax = 2520,
		name = "Preset4",
		nameVignette = "Hight Scattered 2",
		nameMETAR = "SCT 8/10 FEW 24/26",
		layers = {
			{
				presetMetar = "SCT",
				base = 8,
				ceiling = 10,
			},
			{
				presetMetar = "FEW",
				base = 24,
				ceiling = 26,
			},
		},
		cover = 50,
	},

	[5] = {
		altiMin = 1260,
		altiMax = 4620,
		name = "Preset5",
		nameVignette = "Scattered 1",
		nameMETAR = "SCT/BKN  18/20 FEW 36/38 FEW 40",
		layers = {
			{
				presetMetar = "SCT/BKN",
				base = 18,
				ceiling = 20,
			},
			{
				presetMetar = "FEW",
				base = 36,
				ceiling = 38,
			},
			{
				presetMetar = "FEW",
				base = 40,
				ceiling = 0,
			},
		},
		cover = 67,
	},
	[6] = {
		altiMin = 1260,
		altiMax = 4200,
		name = "Preset6",
		nameVignette = "Scattered 2",					--okok
		nameMETAR = "SCT 14/17 FEW 27/29 BKN 40",
		layers = {
			{
				presetMetar = "SCT",
				base = 14,
				ceiling = 17,
			},
			{
				presetMetar = "FEW",
				base = 27,
				ceiling = 29,
			},
			{
				presetMetar = "BKN",
				base = 40,
				ceiling = 0,
			},
		},
		cover = 50,
	},
	[7] = {
		altiMin = 1680,
		altiMax = 5040,
		name = "Preset7",
		nameVignette = "Scattered 3",
		nameMETAR = "SCT/BKN 8/10 FEW 40",
		layers = {
			{
				presetMetar = "SCT/BKN",
				base = 8,
				ceiling = 10,
			},
			{
				presetMetar = "FEW",
				base = 40,
				ceiling = 0,
			},
		},
		cover = 67,
	},
	[8] = {
		altiMin = 3780,
		altiMax = 5460,
		name = "Preset8",
		nameVignette = "Hight Scattered 3",
		nameMETAR = "BKN 7.5/12 SCT/BKN 21/23 SCT 40",
		layers = {
			{
				presetMetar = "BKN",
				base = 7.5,
				ceiling = 12,
			},
			{
				presetMetar = "SCT/BKN",
				base = 21,
				ceiling = 23,
			},
			{
				presetMetar = "SCT",
				base = 40,
				ceiling = 0,
			},
		},
		cover = 75,
	},
	[9] = {
		altiMin = 1680,
		altiMax = 3780,
		name = "Preset9",
		nameVignette = "Scattered 4",				--ok	ok
		nameMETAR = "BKN 7.5/10 SCT 20/22",
		layers = {
			{
				presetMetar = "BKN",
				base = 7.5,
				ceiling = 10,
			},
			{
				presetMetar = "SCT",
				base = 20,
				ceiling = 22,
			},
		},
		cover = 75,
	},
	[10] = {
		altiMin = 1260,
		altiMax = 4200,
		name = "Preset10",
		nameVignette = "Scattered 5",				-- OK	ok
		nameMETAR = "SCT/BKN 18/20 FEW 36/38 FEW 40",
		layers = {
			{
				presetMetar = "SCT/BKN",
				base = 18,
				ceiling = 20,
			},
			{
				presetMetar = "FEW",
				base = 36,
				ceiling = 38,
			},
			{
				presetMetar = "FEW",
				base = 40,
				ceiling = 0,
			},
		},
		cover = 67,
	},
	[11] = {
		altiMin = 2520,
		altiMax = 5460,
		name = "Preset11",
		nameVignette = "Scattered 6",				--okok
		nameMETAR = "BKN 18/20 BKN 32/33 FEW 41",
		layers = {
			{
				presetMetar = "BKN",
				base = 18,
				ceiling = 20,
			},
			{
				presetMetar = "BKN",
				base = 32,
				ceiling = 33,
			},
			{
				presetMetar = "FEW",
				base = 41,
				ceiling = 0,
			},
		},
		cover = 75,
	},
	[12] = {
		altiMin = 1680,
		altiMax = 3360,
		name = "Preset12",
		nameVignette = "Scattered 7",					--okok
		nameMETAR = "BKN 12/14 SCT 22/23 FEW 41",
		layers = {
			{
				presetMetar = "BKN",
				base = 12,
				ceiling = 14,
			},
			{
				presetMetar = "SCT",
				base = 22,
				ceiling = 23,
			},
			{
				presetMetar = "FEW",
				base = 41,
				ceiling = 0,
			},
		},
		cover = 75,
	},
	[13] = {
		altiMin = 1680,
		altiMax = 3360,
		name = "Preset13",
		nameVignette = "Broken 1",					--okok
		nameMETAR = "BKN 12/14 BKN 26/28 FEW 41",
		layers = {
			{
				presetMetar = "BKN",
				base = 12,
				ceiling = 14,
			},
			{
				presetMetar = "BKN",
				base = 26,
				ceiling = 28,
			},
			{
				presetMetar = "FEW",
				base = 41,
				ceiling = 0,
			},
		},
		cover = 75,
	},
	[14] = {
		altiMin = 1680,
		altiMax = 3360,
		name = "Preset14",
		nameVignette = "Broken 2",					--okok
		nameMETAR = "BKN/LYR 7/16 FEW 41",
		layers = {
			{
				presetMetar = "BKN/LYR",
				base = 7,
				ceiling = 16,
			},
			{
				presetMetar = "FEW",
				base = 41,
				ceiling = 0,
			},
		},
		cover = 87,
	},
	[15] = {
		altiMin = 840,
		altiMax = 5040,
		name = "Preset15",
		nameVignette = "Broken 3",
		nameMETAR = "SCT/BKN 14/18 BKN 24/27 FEW 41",
		layers = {
			{
				presetMetar = "SCT/BKN",
				base = 14,
				ceiling = 18,
			},
			{
				presetMetar = "BKN",
				base = 24,
				ceiling = 27,
			},
			{
				presetMetar = "FEW",
				base = 41,
				ceiling = 0,
			},
		},
		cover = 67,
	},
	[16] = {
		altiMin = 1260,
		altiMax = 4200,
		name = "Preset16",
		nameVignette = "Broken 4",
		nameMETAR = "BKN 14/18 BKN 28/30 FEW 40",
		layers = {
			{
				presetMetar = "BKN",
				base = 14,
				ceiling = 18,
			},
			{
				presetMetar = "BKN",
				base = 28,
				ceiling = 30,
			},
			{
				presetMetar = "FEW",
				base = 40,
				ceiling = 0,
			},
		},
		cover = 75,
	},
	[17] = {
		altiMin = 0,
		altiMax = 2520,
		name = "Preset17",
		nameVignette = "Broken 5",
		nameMETAR = "BKN/OVC 7/13 20/22 32/34",
		layers = {
			{
				presetMetar = "BKN/OVC",
				base = 7,
				ceiling = 13,
			},
			{
				presetMetar = "",
				base = 20,
				ceiling = 22,
			},
			{
				presetMetar = "",
				base = 32,
				ceiling = 34,
			},
		},
		cover = 87,
	},
	[18] = {
		altiMin = 0,
		altiMax = 3780,
		name = "Preset18",
		nameVignette = "Broken 6",
		nameMETAR = "BKN/OVC 13/15 25/29 38/41",
		layers = {
			{
				presetMetar = "BKN/OVC",
				base = 13,
				ceiling = 15,
			},
			{
				presetMetar = "",
				base = 25,
				ceiling = 29,
			},
			{
				presetMetar = "",
				base = 38,
				ceiling = 41,
			},
		},
		cover = 87,
	},
	[19] = {
		altiMin = 0,
		altiMax = 2940,
		name = "Preset19",
		nameVignette = "Broken 7",
		nameMETAR = "OVC 9/16 BKN/OVC 23/24 31/33",
		layers = {
			{
				presetMetar = "OVC",
				base = 9,
				ceiling = 16,
			},
			{
				presetMetar = "BKN/OVC",
				base = 23,
				ceiling = 24,
			},
			{
				presetMetar = "FEW",
				base = 31,
				ceiling = 33,
			},
		},
		cover = 100,
	},
	[20] = {
		altiMin = 0,
		altiMax = 3780,
		name = "Preset20",
		nameVignette = "Broken 8",					--okok
		nameMETAR = "BKN/OVC 13/18 BKN 28/30 SCT/FEW 38",
		layers = {
			{
				presetMetar = "BKN/OVC",
				base = 13,
				ceiling = 18,
			},
			{
				presetMetar = "BKN",
				base = 28,
				ceiling = 30,
			},
			{
				presetMetar = "SCT/FEW",
				base = 38,
				ceiling = 0,
			},
		},
		cover = 87,
	},
	[21] = {
		altiMin = 1260,
		altiMax = 4200,
		name = "Preset21",
		nameVignette = "Overcast 1",				--okok
		nameMETAR = "BKN/OVC 7/8 17/19",
		layers = {
			{
				presetMetar = "BKN/OVC",
				base = 7,
				ceiling = 8,
			},
			{
				presetMetar = "BKN",
				base = 17,
				ceiling = 19,
			},
			{
				presetMetar = "FEW",
				base = 41,
				ceiling = 0,
			},
		},
		cover = 87,
	},
	[22] = {
		altiMin = 420,
		altiMax = 4200,
		name = "Preset22",
		nameVignette = "Overcast 2",
		nameMETAR = "BKN/OVC 7/10 17/20",
		layers = {
			{
				presetMetar = "BKN/OVC",
				base = 7,
				ceiling = 10,
			},
			{
				presetMetar = "BKN",
				base = 17,
				ceiling = 20,
			},
		},
		cover = 87,
	},
	[23] = {
		altiMin = 840,
		altiMax = 3360,
		name = "Preset23",
		nameVignette = "Overcast 3",
		nameMETAR = "BKN/OVC 11/14 18/25 SCT 32/35",
		layers = {
			{
				presetMetar = "BKN/OVC",
				base = 11,
				ceiling = 14,
			},
			{
				presetMetar = "",
				base = 18,
				ceiling = 25,
			},
			{
				presetMetar = "SCT",
				base = 32,
				ceiling = 35,
			},
		},
		cover = 87,
	},
	[24] = {
		altiMin = 420,
		altiMax = 2520,
		name = "Preset24",
		nameVignette = "Overcast 4",
		nameMETAR = "BKN/OVC 3/7 17/22 BKN 34",
		layers = {
			{
				presetMetar = "BKN/OVC",
				base = 3,
				ceiling = 7,
			},
			{
				presetMetar = "",
				base = 17,
				ceiling = 22,
			},
			{
				presetMetar = "BKN",
				base = 34,
				ceiling = 0,
			},
		},
		cover = 87,
	},
	[25] = {
		altiMin = 420,
		altiMax = 3360,
		name = "Preset25",
		nameVignette = "Overcast 5",
		nameMETAR = "OVC 12/14 22/25 40/42",
		layers = {
			{
				presetMetar = "OVC",
				base = 12,
				ceiling = 14,
			},
			{
				presetMetar = "BKN",
				base = 22,
				ceiling = 25,
			},
			{
				presetMetar = "FEW",
				base = 40,
				ceiling = 42,
			},
		},
		cover = 87,
	},
	[26] = {
		altiMin = 420,
		altiMax = 2940,
		name = "Preset26",
		nameVignette = "Overcast 6",
		nameMETAR = "OVC 9/15 BKN 23/25 SCT 32",
		layers = {
			{
				presetMetar = "OVC",
				base = 9,
				ceiling = 15,
			},
			{
				presetMetar = "BKN",
				base = 23,
				ceiling = 25,
			},
			{
				presetMetar = "SCT",
				base = 32,
				ceiling = 0,
			},
		},
		cover = 100,
	},
	[27] = {
		altiMin = 420,
		altiMax = 2520,
		name = "Preset27",
		nameVignette = "Overcast 7",
		nameMETAR = "OVC 8/15 SCT/BKN 25/26 34/36",
		layers = {
			{
				presetMetar = "OVC",
				base = 8,
				ceiling = 15,
			},
			{
				presetMetar = "SCT/BKN",
				base = 25,
				ceiling = 26,
			},
			{
				presetMetar = "",
				base = 34,
				ceiling = 36,
			},
		},
		cover = 100,
	},
	[28] = {
		altiMin = 420,
		altiMax = 2500,
		name = "RainyPreset1",
		visibility = 3000,
		nameVignette = "Overcast And Rain 1",
		nameMETAR = "VIS3-5KM RA OVC 3/15 28/30 FEW 40",
		layers = {
			{
				presetMetar = "VIS3-5KM RA OVC",
				base = 3,
				ceiling = 15,
			},
			{
				presetMetar = "",
				base = 28,
				ceiling = 30,
			},
			{
				presetMetar = "FEW",
				base = 40,
				ceiling = 0,
			},
		},
		cover = 100,
	},
	[29] = {
		altiMin = 840,
		altiMax = 2520,
		name = "RainyPreset2",
		visibility = 1000,
		nameVignette = "Overcast And Rain 2",
		nameMETAR = "VIS 1-5KM RA OVC 3/11 SCT 18/29 FEW 40",
		layers = {
			{
				presetMetar = "VIS 1-5KM RA OVC",
				base = 3,
				ceiling = 11,
			},
			{
				presetMetar = "SCT",
				base = 18,
				ceiling = 29,
			},
			{
				presetMetar = "FEW",
				base = 40,
				ceiling = 0,
			},
		},
		cover = 100,
	},
	[30] = {
		altiMin = 840,
		altiMax = 2520,
		name = "RainyPreset3",
		visibility = 3500,
		nameVignette = "Overcast And Rain 2",
		nameMETAR = "VIS 3.5KM RA OVC 6/18 19/21 SCT 34",
		layers = {
			{
				presetMetar = "VIS 3.5KM RA OVC",
				base = 6,
				ceiling = 18,
			},
			{
				presetMetar = "",
				base = 19,
				ceiling = 21,
			},
			{
				presetMetar = "SCT",
				base = 34,
				ceiling = 0,
			},
		},
		cover = 100,
	},
	[31] = {
		altiMin = 1260,
		altiMax = 4200,
		name = "Light Rain 1",
		-- visibility = 3500,
		nameVignette = "Two Layers Scattered Large Thick Clouds",
		nameMETAR = "SCT/BKN 18/20 FEW36/38 FEW 40",
		layers = {
			{
				presetMetar = "SCT/BKN",
				base = 18,
				ceiling = 20,
			},
			{
				presetMetar = "FEW3",
				base = 36,
				ceiling = 38,
			},
			{
				presetMetar = "SCT",
				base = 40,
				ceiling = 0,
			},
		},
	},
	[32] = {
		altiMin = 1260,
		altiMax = 2520,
		name = "Light Rain 2",
		-- visibility = 3500,
		nameVignette = "Three Layers Broken/Overcast",
		nameMETAR = "BKN/OVC LYR 7/13 20/22 32/34",
		layers = {
			{
				presetMetar = "BKN/OVC LYR",
				base = 7,
				ceiling = 13,
			},
			{
				presetMetar = "",
				base = 20,
				ceiling = 22,
			},
			{
				presetMetar = "",
				base = 32,
				ceiling = 34,
			},
		},
	},
	[33] = {
		altiMin = 1260,
		altiMax = 2940,
		name = "Light Rain 3",
		-- visibility = 3500,
		nameVignette = "Three Layers Overcast At Low Level",
		nameMETAR = "OVC 9/16 BKN/OVC LYR 23/24 31/33",
		layers = {
			{
				presetMetar = "OVC",
				base = 9,
				ceiling = 16,
			},
			{
				presetMetar = "BKN/OVC LYR",
				base = 23,
				ceiling = 24,
			},
			{
				presetMetar = "",
				base = 31,
				ceiling = 33,
			},
		},
	},
	[34] = {
		altiMin = 840,
		altiMax = 5174,
		name = "Light Rain 4",
		-- visibility = 3500,
		nameVignette = "Two Layers Overcast At Low Level",
		nameMETAR = "BKN/OVC 7/8 17/19",
		layers = {
			{
				presetMetar = "BKN/OVC",
				base = 7,
				ceiling = 8,
			},
			{
				presetMetar = "",
				base = 17,
				ceiling = 19,
			},
		},
	},
}

------------------------------------------------------------
-- DCS CampaignMaker Realistic Weather Generator v0.3
-- Basé sur les familles de presets réels
------------------------------------------------------------

--------------------------------------------------------------
-- 0. VARIABLES 
--------------------------------------------------------------

-- METAR = ""
TabMetar = {}
local foundSinglePlayer = {}

local presetChoice
local elapsed_Time = CampTotalTimeS								--elapsed time since campaign start in seconds
local debugTxt = ""
local debugWeather = false
local debugChoice
local showOne = false
local showOneNight = true

if not camp.weather then
	camp.weather = {
		refTemp = mission_ini.weather.refTemp
	}
end

if debugWeather then
	print("calcul new weather:")
	_affiche(camp.weather, "camp.weather DcW ")
end

print("elapsed_Time = "..tostring(elapsed_Time))
--------------------------------------------------------------
-- 1. Catégories de presets DCS
--------------------------------------------------------------

local highPresets        = {1, 2, 3, 4}
local warmSectorPresets  = {5, 6, 7, 8, 9, 10}
local coldSectorPresets  = {11, 12, 13, 14, 15, 16, 17, 18}
local warmFrontPresets   = {19, 20, 21, 22, 23, 24, 25, 26, 27}
local coldFrontPresets   = {28, 29, 30, 32}
local lightRainPresets   = {31, 33, 34}
local heavyRainPresets   = {28, 29, 30}



--------------------------------------------------------------
-- 2. UTILITAIRES
--------------------------------------------------------------

local function pickRandom(t)
    return t[math.random(1, #t)]
end

-- Random gaussien simplifié
local function gaussianRandom(mean, stdDev)
    -- math.random() produit un nombre uniformément distribué entre 0 et 1.
    -- Pour obtenir une distribution gaussienne, on applique la transformation de Box-Muller.

    local u1 = math.random()
    local u2 = math.random()

    -- Transformation : on convertit deux tirages uniformes
    -- en un tirage gaussien centré sur 0, variance 1
    local z0 = math.sqrt(-2 * math.log(u1)) * math.cos(2 * math.pi * u2)

    -- Puis on applique moyenne et écart-type
    return mean + z0 * stdDev
end


-- renvoie une valeur centrée autour de "center"
-- amplitude = +/- plage du random
local function weightedRandom(center, amplitude)
    -- random 0..1
    local r = math.random()
    -- courbe douce (r^2 favorise les valeurs proches du centre)
    local factor = r * r
    local offset = (math.random(0,1) == 0 and -1 or 1) * factor * amplitude
    return center + offset
end

local function generateFog(category, windSpeed)

    -- Jamais de brouillard si trop de vent
    if windSpeed > 2 then
        return false, {visibility = 0, thickness = 0}
    end

    -- Catégories qui peuvent naturellement donner du brouillard
    local fogPossible = {
        lightRain = true,
        heavyRain = true,
        warmFront = true,
        coldFront = true,
    }

    if not fogPossible[category] then
        return false, {visibility = 0, thickness = 0}
    end

    -- Probabilité rare : 5 %
    if math.random() > 0.05 then
        return false, {visibility = 0, thickness = 0}
    end

    -- Brouillard généré
    local visibility = math.random(250, 1200)
    local thickness  = math.random(100, 300)

    return true, {
        visibility = visibility,
        thickness  = thickness
    }
end


--------------------------------------------------------------
-- 3. CHOISIR UN PRESET EN FONCTION DE LA METEO SIMULÉE
--------------------------------------------------------------

-- Débogage : dernière valeur utilisée pour déterminer la catégorie météo
local lastWeatherRoll = 0

local function chooseWeatherPreset(trend)
    -- On génère un tirage gaussien autour de "trend"
    -- Spread (écart type) fixe, car "instability" ne doit plus être pris en compte
    local spread = 12

    -- On conserve la valeur pour débug
    lastWeatherRoll = gaussianRandom(trend, spread)

    -- Sélection de la météo
    if lastWeatherRoll >= 85 then
        return pickRandom(highPresets), "high", lastWeatherRoll

    elseif lastWeatherRoll >= 65 then
        return pickRandom(warmSectorPresets), "warmSector", lastWeatherRoll

    elseif lastWeatherRoll >= 45 then
        return pickRandom(coldSectorPresets), "coldSector", lastWeatherRoll

    elseif lastWeatherRoll >= 30 then
        return pickRandom(warmFrontPresets), "warmFront", lastWeatherRoll

    elseif lastWeatherRoll >= 15 then
        return pickRandom(lightRainPresets), "lightRain", lastWeatherRoll

    elseif lastWeatherRoll >= 8 then
        return pickRandom(coldFrontPresets), "coldFront", lastWeatherRoll

    else
        return pickRandom(heavyRainPresets), "heavyRain", lastWeatherRoll
    end
end


--------------------------------------------------------------
-- 4. GENERATION DU VENT DCS
--------------------------------------------------------------

local function generateWindDirection(category, winDirection)
    
    -- Catégories où le vent peut venir de n'importe où
    local badWeather = {
        heavyRain = true,
        coldFront = true
    }

    -- Si météo mauvaise → direction chaotique
    if badWeather[category] then
        return math.random(0, 359)
    end

    -- Sinon direction pondérée autour du vent dominant
    local dir = weightedRandom(winDirection, 35)   -- +/- 35° autour
    dir = dir % 360
    if dir < 0 then dir = dir + 360 end
    return math.floor(dir)
end

local function generateWind(windActivity, winDir, category)

    category = category or "unknown"

    ----------------------------------------------------------
    -- 1. Meteo → Facteur multiplicateur limité
    ----------------------------------------------------------
    local function getMeteoFactor(cat)
        if cat == "high"        then return 0.9 end
        if cat == "warmSector"  then return 1.0 end
        if cat == "coldSector"  then return 1.1 end
        if cat == "warmFront"   then return 1.2 end
        if cat == "lightRain"   then return 1.1 end
        if cat == "coldFront"   then return 1.3 end
        if cat == "heavyRain"   then return 1.4 end
        return 1.0
    end

    local meteoFactor = getMeteoFactor(category)
    print("Wind category = "..tostring(category).." | meteoFactor = "..meteoFactor)


    ----------------------------------------------------------
    -- 2. Tire un vent maîtrisé avec maxima stricts
    ----------------------------------------------------------
    local function randomWind(base, maxLimit)

        -- influence météo
        local v = base * meteoFactor

        -- variation légère ±20%
        local delta = (math.random() * 0.4) - 0.2      -- -0.2 à +0.2
        v = v + (v * delta)

        -- clamp to limits
        if v > maxLimit then v = maxLimit end
        if v < 0 then v = 0 end

        -- no decimals
        return math.floor(v)
    end


    ----------------------------------------------------------
    -- 3. Direction (pas modifiée)
    ----------------------------------------------------------
    local function driftDir(center, amplitude)
        local r = math.random()
        local offset = ((math.random() < 0.5) and -1 or 1) * (r * r) * amplitude
        local d = (center + offset) % 360
        if d < 0 then d = d + 360 end
        return math.floor(d)
    end


    ----------------------------------------------------------
    -- 4. Construction du vent (sol → 2000 → 8000)
    ----------------------------------------------------------
    local groundWind = randomWind(windActivity, 2)     -- MAX sol = 2 m/s
    local wind2000   = randomWind(groundWind * 1.5, 6) -- MAX altitude = 6 m/s
    local wind8000   = randomWind(groundWind * 2.0, 6)

    return {
        atGround = {
            speed = groundWind,
            dir   = driftDir(winDir, 20)
        },
        at2000 = {
            speed = wind2000,
            dir   = driftDir(winDir, 12)
        },
        at8000 = {
            speed = wind8000,
            dir   = driftDir(winDir, 7)
        }
    }
end

--------------------------------------------------------------
-- 5. GENERATION DES NUAGES
--------------------------------------------------------------

-- data doit contenir data[presetID].altiMin et altiMax
-- Exemple : data[32].altiMin = 1260 ; data[32].altiMax = 2520

local function clamp(val, min, max)
    if val < min then return min end
    if val > max then return max end
    return val
end



local function generateClouds(presetID, category)

	local data = preset[presetID]
    -- Sécurités
    local presetData = data[presetID]
    if not presetData then
        -- fallback propre
        presetData = { altiMin = 500, altiMax = 5000 }
    end

    local altiMin = presetData.altiMin
    local altiMax = presetData.altiMax

    -----------------------------------------------------
    -- 1) Base estimée selon la catégorie (comme tu le voulais)
    -----------------------------------------------------
    local base = 3500 -- valeur par défaut ciel haut

    if category == "coldSector" then base = 2200 end
    if category == "warmFront"  then base = 1800 end
    if category == "lightRain"  then base = 1500 end
    if category == "heavyRain"  then base =  900 end
    if category == "coldFront"  then base =  700 end

    -----------------------------------------------------
    -- 2) Clamp final : la base doit respecter altiMin / altiMax
    -----------------------------------------------------
    base = clamp(base, altiMin, altiMax)

    -----------------------------------------------------
    -- 3) Construction de la table clouds compatible DCS
    -----------------------------------------------------
    return {
        preset    = "Preset" .. tostring(presetID),
        base      = base,
        density   = 0,       -- requis par DCS mais ignoré
        thickness = 200,     -- requis mais non utilisé
        iprecptns = 0        -- ignoré depuis la 2.9 mais obligatoire
    }
end




--------------------------------------------------------------
-- 6. GENERATION DE LA TEMPÉRATURE
--------------------------------------------------------------

local function generateTemperature(baseTemp, category)

    -- Influence météo très légère
    local meteoBias = 0

    if category == "high" then meteoBias =  1 end        -- beau temps : un poil plus chaud
    if category == "warmSector" then meteoBias =  2 end  -- air chaud
    if category == "coldSector" then meteoBias = -2 end  -- air froid
    if category == "warmFront"  then meteoBias =  1 end
    if category == "coldFront"  then meteoBias = -2 end
    if category == "lightRain"  then meteoBias = -1 end
    if category == "heavyRain"  then meteoBias = -2 end  -- logique météo

    -- Température cible finale avant random
    local target = baseTemp + meteoBias

    -- Random pondéré léger autour de cette cible (±2°C)
    local temp = weightedRandom(target, 5)

    return math.floor(temp)
end



--------------------------------------------------------------
-- 7. GENERATION DU QNH
--------------------------------------------------------------

local function generateQNH(category)

    -- Valeur centrale selon météo
    local center = 770   -- valeur par défaut

    if category == "high" then center = 777 end            -- anticyclone
    if category == "warmSector" then center = 773 end
    if category == "coldSector" then center = 767 end
    if category == "warmFront" then center = 765 end
    if category == "coldFront" then center = 762 end       -- dépression
    if category == "lightRain" then center = 768 end
    if category == "heavyRain" then center = 761 end       -- très bas

    -- Random pondéré autour du centre, amplitude ±4
    local qnh = weightedRandom(center, 4)

    -- Clamp strict
    if qnh < 760 then qnh = 760 end
    if qnh > 780 then qnh = 780 end

    return math.floor(qnh)
end


--------------------------------------------------------------
-- 8. GENERATION GLOBAL DCS WEATHER
--------------------------------------------------------------

local function generateDCSweather()
	local trend = mission_ini.weather.trend
	local refTemp = mission_ini.weather.refTemp
	local instability = mission_ini.weather.instability
	local windActivity = mission_ini.weather.windActivity
	local winDirection = mission_ini.weather.winDirection


    local presetID, category, loc_debugChoice = chooseWeatherPreset(trend)

	-- print("generateDCSweather() category "..category)
	
	local windDir = generateWindDirection(category, winDirection)
    local wind = generateWind(windActivity, windDir, category)

    local clouds = generateClouds(presetID, category)
    local temperature = generateTemperature(refTemp, category)
    local qnh = generateQNH(trend)

	local fogEnabled, fogData = generateFog(category, wind.atGround.speed)

    -- Fog (rare, seulement si très mauvaise météo)
    local fog = {
        thickness = fogEnabled and fogData.thickness or 0,
        visibility = fogEnabled and fogData.visibility or 0,
    }

    -- Visibilité globale
    local vis = 80000
    if category == "lightRain" then vis = 40000 end
    if category == "heavyRain" then vis = 15000 end
    if category == "coldFront" then vis = 10000 end

	camp.weather.zone = category
	presetChoice = presetID
	debugChoice = loc_debugChoice


    return {
        wind = wind,

        enable_fog = fogEnabled,

        season = {
            temperature = temperature
        },

        qnh = qnh,

        cyclones = {},

        dust_density = 0,
        enable_dust = false,

        clouds = clouds,

        atmosphere_type = 0,
        -- groundTurbulence = math.floor(windActivity),
		groundTurbulence = 0,

        halo = { preset = "auto" },

        type_weather = 0,

        modifiedTime = false,

        name = "Generated Weather: "..category,

        fog = fog,

        visibility = {
            distance = vis
        }
    }
end

local weather = generateDCSweather( )

mission["weather"] = weather

-- _affiche(weather, "weather: ")

-- os.execute 'pause'

--###################################################################
----- debut old weather -----
--###################################################################

--time and date
camp.date.hour = math.floor(camp.time / 3600)
camp.date.minute =  math.floor((camp.time / 3600 - camp.date.hour) * 60)


--###################################################################
----- Build METAR -----
--###################################################################
local breakTag
for side, units in pairs(oob_air) do
	if units and units ~= nil then
		for n, unit in pairs(units) do
			if unit.player then
				foundSinglePlayer = {
					place = unit.base,
					type = unit.type,
					-- fieldElevation = fieldElevation
				}
				breakTag = true
				break
			end
		end
		if breakTag then
			break
		end
	end
end

local tab_unite = {
	[1] = "imperial",
	[2] = "metric",
	[3] = "russian",
}


for placeName, place in pairs(db_airbases) do
	for i, units in ipairs(tab_unite) do

		local metar = "METAR "

		-- code = {
		-- 	ICAO = "LTAG",
		-- 	other = "IAB",
		-- },

		local name = ""
		if place.code and place.code.other and place.code.other ~= "" then
			name = place.code.other
		elseif place.code and place.code.ICAO and place.code.ICAO ~= "" then
			name = place.code.ICAO
		else
			name = placeName
		end
		metar = metar .. name .. " "

		--time and date
		if camp.date.day < 10 then
			metar = metar .. "0" .. camp.date.day
		else
			metar = metar .. camp.date.day
		end

		--le metar est pris en compte avant le briefing, donc environ 1 à 2h avant
		local timePrepaMinute = math.random(3, 15) *100
		local timePrepa = math.floor((camp.time - 3600 - timePrepaMinute) / 600) * 600   --on arrondi à 10mn

		if timePrepa < 0 then
			timePrepa = 0
		else
			timePrepa = camp.time - 3600 - timePrepaMinute
		end
		--on arrondi (encore) à 10mn pres
		timePrepa = math.floor((timePrepa) / 600) * 600

		local hours = math.floor((timePrepa) / 3600)
		if hours < 10 then
			metar = metar .. "0" .. hours
		else
			metar = metar .. hours
		end

		local minute = (timePrepa / 3600 - hours) * 60
		local minuteStr = ""

		if minute < 10 then
			minuteStr = "0" .. minute
		else
			minuteStr = tostring(minute)
		end
		metar = metar .. minuteStr .. " "

		--wind
		local direction = mission.weather["wind"]["atGround"]["dir"] - 180
		local directionStr = ""
		if direction < 0 then
			direction = direction + 360
		end

		WindDirection = direction													--recupere la vrai direction du vent (aéronautique)

		direction = math.floor(direction / 10) * 10
		if direction < 10 then
			directionStr = "00" .. direction
		elseif direction < 100 then
			directionStr = "0" .. direction
		else
			directionStr = tostring(direction)
		end


		local speedString = tostring(mission.weather["wind"]["atGround"]["speed"] or "0")
		local speedNum = tonumber(speedString) or 0
		if units == "imperial" then
			speedNum = math.ceil(speedNum * 1.94384)
		end
		if speedNum < 10 then
			speedString = "0" .. tostring(speedNum)
		else
			speedString = tostring(speedNum)
		end
		-- 33014G26KT

		--turbulence or Gust, si la rafale de vent est supérieur à 25% au vent normal
		local gust = ""
		-- if (mission.weather["groundTurbulence"] / 10) > mission.weather["wind"]["atGround"]["speed"] * 1.20 then
		-- 	if units == "imperial" then
		-- 		gust = "G"..math.ceil(mission.weather["groundTurbulence"] * 1.94384)
		-- 	else
		-- 		gust = "G"..mission.weather["groundTurbulence"]
		-- 	end
		-- end 

		if units == "imperial" then
			if mission.weather["wind"]["atGround"]["speed"] == 0 then
				metar = metar .. "00000KT "
			else
				metar = metar .. directionStr .. speedString .. gust .. "KT "
			end
		else
			if mission.weather["wind"]["atGround"]["speed"] == 0 then
				metar = metar .. "00000MPS "
			else
				metar = metar .. directionStr

				.. speedString .. gust .. "MPS "
			end
		end


		--visibility
		if mission.weather["enable_fog"] == true then
			local vis = math.floor(mission.weather["fog"]["visibility"] / 100) * 100
			local visStr = ""
			if vis < 10 then
				visStr = "000" .. vis
			elseif vis < 100 then
				visStr = "00" .. vis
			elseif vis < 1000 then
				visStr = "0" .. vis
			else
				visStr = tostring(vis)
			end
			metar = metar .. visStr .. " "
		else
			-- if mission.weather["clouds"]["iprecptns"] == 1 then
			-- 	METAR = METAR .. "9999 "
			-- elseif mission.weather["clouds"]["iprecptns"] == 2 then
			-- 	METAR = METAR .. "9999 "
			-- else
			-- 	-- METAR = METAR .. "CAVOK "
			-- end

		end

		--fog
		if mission.weather["enable_fog"] == true then
			metar = metar .. "FG "
		end

		--precipitation
		if mission.weather["clouds"]["iprecptns"] == 1 then
			if mission.weather["season"]["temperature"] <= 0 then
				metar = metar .. "SN "
			else
				metar = metar .. "RA "
			end
		elseif mission.weather["clouds"]["iprecptns"] == 2 then
			metar = metar .. "TS "
		elseif not mission.weather["enable_fog"] then
			metar = metar .. "NSW "
		end


		--clouds
		local baseIni = mission.weather["clouds"]["base"]

		if place.elevation then
			baseIni = baseIni - place.elevation
		end

		local ceilingMeter = baseIni

		if ceilingMeter < 100 then
			--
		elseif ceilingMeter < 1000 then
			ceilingMeter =  math.floor(ceilingMeter / 100)
		elseif ceilingMeter < 10000 then
			ceilingMeter =  math.floor(ceilingMeter / 100)
		else
			ceilingMeter =  math.floor(ceilingMeter / 100)
		end

		local ceilingFt = baseIni * 3.28084
		if ceilingFt < 100 then
			--
		elseif ceilingFt < 1000 then
			ceilingFt =  math.floor(ceilingFt / 100)
		elseif ceilingFt < 10000 then
			ceilingFt =  math.floor(ceilingFt / 100)
		else
			ceilingFt =  math.floor(ceilingFt / 100)
		end

		if presetChoice > 0 then
			local deltaBase = 0
			for n, layer in ipairs(preset[presetChoice].layers) do
				if n == 1 then
					deltaBase = (layer.base * 10) - ceilingFt
				end

				local metarLayer = ""
				if layer.presetMetar  then   --and layer.presetMetar ~= ""
					if n == 1 then
						metarLayer =  ""..layer.presetMetar
					else
						metarLayer =  " "..layer.presetMetar
					end
				end

				local stringBase = math.floor((layer.base * 10) - deltaBase)
				local baseCloud = ""

				if stringBase < 10 then
					baseCloud = "00"..stringBase
				elseif stringBase < 100 then
					baseCloud = "0" .. stringBase
				else
					baseCloud = "" .. stringBase
				end


				metar = metar .. metarLayer..baseCloud

			end
		end


		-- SKC : sky clear, aucun nuage (0 octa) ;
		-- FEW : few, quelques nuages, 1/8 à 2/8 du ciel couvert (1 à 2 octas) ;
		-- SCT : scattered, épars, 3/8 à 4/8 du ciel couvert (3 à 4 octas) ;
		-- BKN : broken, fragmenté, 5/8 à 7/8 du ciel couvert (5 à 7 octas) ;
		-- OVC : overcast, couvert, 8/8 du ciel couvert (8 octas) ;


		--*******************************************************************************
		-- Temperature  ********************************************************************
		--*******************************************************************************
		--formule de la temperature, changeant en fonction de l'altitude du TableTransportPilotNames
		--θ(z) = 15 − 6.5 10−3 z
		local airfieldAlti = 0
		if place.elevation then
			airfieldAlti = place.elevation
		end
		local tempCorrected = math.ceil(mission.weather.season.temperature - (0.0065 * airfieldAlti))

		-- local tempT = math.abs(mission.weather.season.temperature)
		local tempT_num = math.abs(tempCorrected)
		local tempT = ""
		if tempT_num < 10 then
			tempT = "0"..tempT_num
		end
		if mission.weather.season.temperature < 0 then
			metar = metar .. " M" .. tempT
		else
			metar = metar .. " " .. tempT
		end

		-- dewPoint = airTemp - ((cloudAltitude/1000) * 2.5) 
		local dewPoint = math.ceil(mission.weather.season.temperature - (((mission.weather.clouds.base * 3.281 )/1000) * 2.5) )
		local tempDewPoint = math.abs(dewPoint)
		local tempDewPointStr = ""
		if tempDewPoint < 10 then
			tempDewPointStr = "0"..tempDewPoint
		else
			tempDewPointStr = tostring(tempDewPoint)
		end
		if dewPoint < 0 then
			metar = metar .. "/M" .. tempDewPointStr
		else
			metar = metar .. "/" .. tempDewPointStr
		end

		--*******************************************************************************
		-- Turbulence ********************************************************************
		--*******************************************************************************
		-- Turbulence Layer(s): 6 Digits (5WXXXY)
		-- 	5: first digit of the turbulence group is always a 5.

			-- 	Turbulence type: Second digit:
			-- intensity    ////  Weather Condition  ////Frequency
			--0
			--1 Light
			--2 Moderate     /// Clear     ///      Occasional
			--3 Moderate     /// Clear     ///      Frequent
			--4 Moderate     /// Cloud     ///      Occasional
			--5 Moderate     /// Cloud     ///      Frequent
			--6 Severe       /// Clear     ///      Occasional
			--7 Severe       /// Clear     ///      Frequent
			--8 Severe       /// Cloud     ///      Occasional
			--9 Severe       /// Cloud     ///      Frequent

			local turbulenceInfo = ""
			local turbulDigit = ""
			local turbulValue =  mission.weather["groundTurbulence"] / 10

			-- max 60/10 = 6
			--4 valeurs sont retenu, pour 
				-- 0 rien 
				-- 2 Light
				-- 4 Moderate
				-- 6 Severe

			if turbulValue <= 0 then   -- rien
				turbulenceInfo = " 5"..0
			elseif turbulValue <= 2 then   -- Light
				turbulenceInfo = " 5"..1
			elseif turbulValue <= 4 then   --Moderate
				if mission.weather.clouds.density == 0 then
					turbulenceInfo = " 5"..3
				else
					turbulenceInfo = " 5"..5
				end
			else
				if mission.weather.clouds.density == 0 then
					turbulenceInfo = " 5"..7
				else
					turbulenceInfo = " 5"..9
				end
			end

			-- no turbulence layer in DCS
			turbulenceInfo = turbulenceInfo .. "000"

			-- Turbulence layer’s base: next 3 digits.  (direct reading in 100s of ft/30s meters)

			-- 	Thickness of turbulence layer: last digit:

				-- Thickness of Layer

				-- 0-- Up to top of cloud			
				-- 1-- 300m/1000’			
				-- 2-- 600m/2000’			
				-- 3-- 900m/2000’			
				-- 4-- 1200m/4000’			
				-- 5-- 1500m/5000’			
				-- 6-- 1800m/6000’			
				-- 7-- 2100m/7000’			
				-- 8-- 2400m/8000’			
				-- 9-- 2700m/9000’

				-- no turbulence layer in DCS, but groundTurbulence, maybe 2000ft ^^
			turbulenceInfo = turbulenceInfo .. "2"

			metar = metar ..turbulenceInfo

		--QNH
		--le QNH de DCS est en mm d Hg, il faut le transformer pour etre en HPa

		local qnhStr = ""
		if units == "imperial" then
			local qnh = mission.weather["qnh"] / 25.399999704976

			qnhStr = tostring(qnh)
			qnhStr = qnhStr:sub(1, 2)..qnhStr:sub(4, 5)

			metar = metar .. " A" .. qnhStr
		elseif units == "metric" then

			local qnh = math.floor(mission.weather["qnh"] / 760 * 1013.25)
			metar = metar .. " Q" .. qnh

		else
			local qnh = math.floor(mission.weather["qnh"] )
			metar = metar .. " QNH" .. qnh
		end


		--a/Base of lowest cloud layer of 3/8 (or SCT) or more in heights above ground level
		--b/Base of lowest cloud layer of 5/8 (or BKN) or more in heights above ground level

		--						/a					/b
		-- Blue (BLU) 	8 KM 	2500 FT 	10 KM 	1500 FT
		-- White (WHT) 	5000 M 	1500 FT 	5000 M 	1200 FT
		-- Green (GRN) 	3700 M 	700 FT 	4000 M 	600 FT
		-- Yellow 1 (YLO1) 	2500 M 	500 FT 	  	 
		-- Yellow 2 (YLO2) 	1600 M 	300 FT 	  	 
		-- Amber (AMB) 	800 M 	200 FT 	500 M 	200 FT
		-- Red (RED) 	Less than 800 M Below 200 FT or Sky obscuredLess than 500 M Below 200 FT or Sky obscured

		local militaryColor = {
			[1] = {
				alti_ft = 2500,
				alti_m = 762,
				visu_m = 8000,
				color = "BLU",
			},
			[2] = {
				alti_ft = 1500,
				alti_m = 457,
				visu_m = 5000,
				color = "WHT",
			},
			[3] = {
				alti_ft = 700,
				alti_m = 213,
				visu_m = 3700,
				color = "GRN",
			},
			[4] = {
				alti_ft = 500,
				alti_m = 152,
				visu_m = 2500,
				color = "YLO",
			},
			[5] = {
				alti_ft = 200,
				alti_m = 60,
				visu_m = 800,
				color = "AMB",
			},
			[6] = {
				alti_ft = 0,
				alti_m = 0,
				visu_m = 0,
				color = "RED",
			},

		}

		local vis = 80000
		if mission.weather["enable_fog"] == true then
			vis = mission.weather["fog"]["visibility"]
		end
		if preset[presetChoice] and preset[presetChoice].visibility and preset[presetChoice].visibility < vis then
			-- print("DcW presetChoice "..presetChoice.." visibility "..preset[presetChoice].visibility)
			vis =  preset[presetChoice].visibility
		end

		for n, level in ipairs(militaryColor) do
			-- print("DcW base "..mission.weather.clouds.base.." (baseIni) "..baseIni.." > m? "..level.alti_m)
			-- print("DcW vis "..vis.." > level.visu_m? "..level.visu_m.." level.color? "..level.color)
			if baseIni >= level.alti_m and vis >= level.visu_m  then
				-- print("DcW passe color ")
				metar = metar .. " " .. level.color
				break
			end
		end

		metar = metar .. "="

		if not TabMetar[placeName] then TabMetar[placeName] = {} end
		TabMetar[placeName][units] = metar

		-- if debugWeather then
		-- 	print("DcW units "..TabMetar[placeName][units])
		-- 	if TabMetar[placeName][units] == nil then
		-- 		print("DcW placeName "..placeName.." units "..units )
		-- 	end
		-- end

		if not showOne then
			if foundSinglePlayer and foundSinglePlayer.type and foundSinglePlayer.place then

				if TabMetar and TabMetar[foundSinglePlayer.place]
				and Data_divers and Data_divers[foundSinglePlayer.type]
				and Data_divers[foundSinglePlayer.type].instrumentUnits
				then
					if TabMetar[foundSinglePlayer.place][Data_divers[foundSinglePlayer.type].instrumentUnits] then
						print("Metar: ".. tostring(TabMetar[foundSinglePlayer.place][Data_divers[foundSinglePlayer.type].instrumentUnits]))
						showOne = true
					else

					end

				end
			else
				-- print("DcW B not found foundSinglePlayer.type "..tostring(foundSinglePlayer.type).." place "..tostring(foundSinglePlayer.place))
			end
		end

		if not showOneNight and string.find(Daytime, "night") then
			MoonTxt = Moonphase(camp.date.day, camp.date.month, camp.date.year)
			showOneNight = true
		end

	end
end 


local s = ""
local remain = 1
local duration = 1
local passed = 1

if camp.weather and camp.weather.zoneEnd then
	remain = math.ceil((camp.weather.zoneEnd - elapsed_Time) / 3600)		--hours until end of weather zone					
	duration = math.ceil((camp.weather.zoneEnd - camp.weather.zoneStart) / 3600)					--duration of the weather zone in hours
	passed = 100 / duration * remain																--percentage of zone passage
end

if camp.weather.zone == "high" then
	if mission.weather["enable_fog"] == false then
		s = s .. "Good flying weather due to influence of a high pressure system in theater of operations"
		if remain < 6 then
			s = s .. ". Change of general weather situation imminent. "
		elseif remain < 25 then
			s = s .. ", expected to remain in effect for next " .. remain .. " hours. "
		elseif remain < 48 then
			s = s .. ", expected to remain dominant for another day. "
		else
			s = s .. ", expected to remain dominant for next " .. math.floor(remain / 24) .. " days. "
		end
	else
		s = s .. "Ground fog conditions. "
	end

elseif camp.weather.zone == "low front cold" then
	s = s .. "Low pressure system dominating theater of operations. Currently poor flying weather due to passage of cold front. Weather improvement expected within next " .. remain .. " hours. "

elseif camp.weather.zone == "low front warm" then
	s = s .. "Low pressure system dominating theater of operations. "
	if passed < 50 then
		s = s .. "Currently increasingly poor flying weather due to the passage of warm front. Expected to clear up after " .. remain .. " hours. "
	else
		s = s .. "Weather expected to deteriorate within next " .. remain .. " hours due to approach of warm front. "
	end

elseif camp.weather.zone == "low sector cold" then
	s = s .. "Low pressure system dominating theater of operations. Currently fair flying weather in cold sector"
	if remain < 6 then
		s = s .. ". Change of general weather situation imminent. "
	elseif remain < 25 then
		s = s .. ", expected to remain in effect for next " .. remain .. " hours. "
	elseif remain < 48 then
		s = s .. ", expected to remain stable for another day. "
	else
		s = s .. ", expected to remain stable for next " .. math.floor(remain / 24) .. " days. "
	end

elseif camp.weather.zone == "low sector warm" then
	s = s .. "Low pressure system dominating theater of operations. Currently fair flying weather in warm sector"
	if remain < 6 then
		s = s .. ". Change of general weather situation imminent. "
	elseif remain < 25 then
		s = s .. ", expected to remain in effect for next " .. remain .. " hours. "
	elseif remain < 48 then
		s = s .. ", expected to remain stable for another day. "
	else
		s = s .. ", expected to remain stable for next " .. math.floor(remain / 24) .. " days. "
	end

else
	-- s = s .. "Weather data unavailable. "

	s = s .." Weather data: " ..camp.weather.zone

end

camp.weather.brief = tostring(s)


debugTxt = debugTxt .."DcW camp.weather.zoneTemp "..camp.weather.zone.."\n"
-- debugTxt = debugTxt .."DcW camp.weather.zoneNextTemp "..camp.weather.zoneNext.."\n"

if not camp["debugTraceability"] then
	camp["debugTraceability"] = {}
end

if not camp["debugTraceability"]["weather"] then
	camp["debugTraceability"]["weather"] = ""
end

camp["debugTraceability"]["weather"] = debugTxt

WeatherParams = DeepCopy(mission.weather)

if debugWeather then
	print()
	print("debugChoice: "..debugChoice)
	print("START debugTxt: ")
	print(debugTxt)
	print("FIN debugTxt: ")
	print()
	print("elapsed_time: "..elapsed_Time)
	-- print("camp.weather.zoneEnd "..camp.weather.zoneEnd)
	print("remain "..remain)
	print()
	_affiche(camp.date, "camp.date FINAL: ")

	_affiche(camp.weather, "camp.weather FINAL: ")

	_affiche(mission.weather, "mission.weather: ")

	print("DCE debug") os.execute 'pause'


end

print("\nPlease Wait...\n")
