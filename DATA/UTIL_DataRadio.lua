--cree pour controler les plages des frequences
--Initiated by MAIN_NextMission.lua
------------------------------------------------------------------------------------------------------- 
-- last modification:  updateData_n
if not versionDCE then versionDCE = {} end
versionDCE["UTIL_DataRadio.lua"] = "2.5.52"
------------------------------------------------------------------------------------------------------- 
-- updateData_n				(n VSN_F104C)(m VSN_F4)(l: Fulcrum)k(Frequency)(CH-47F)(i: VSN_F100 + 105)(h F-4E-45MC)(g add Hercules)(h F-15ESE)(f add MB-339A)(e: add F1-EE)(d add 3xSa342)(c: L39+Su25)(b: add AH-64D_BLK_II)(a: add Mi24)
-- Debug_f					(f: bug list Freq)(e correction F16)(d: fix Mi24 VHF/UHF)(c onlyVariableFrequency = true, for SA342)(b radio 2 UHF)(a Bf109, Spitfire)
--new script
-- modification M34_Bl		custom FrequenceRadio (l new file name)  (i: FreqCapability2)(f more Divert, more Coalition)(Bc Bug Mirage 2000)(Ba A-4E-C bug)(v delete Radio3 AV8)(t: radioname)(p LVHF)(i: 3 frequency bands)
-- modification M20_b		Pannes aléatoires (Failures) en SingleMission et ForcedOption (external view etc..) (b failure adapted to each aircraft type)
-- -------------------------------------------------------------------------------------------------------


--[[
pour information, voici les plages utilisées en aéronautique (les valeurs fluctuent en fonction des organisations):
UHF 	: superieur à 225 Mhz	(Ultra Haute Frequence)
VHF 	: 100 à 225 Mhz			(Very Haute Frequence)
LVHF 	: 20 à 100 Mhz			(Low VHF, trompeusement dénommé FM, FM et AM sont des modulations de freq ou d'amplitude) (Occidental)
HF 		: 1 à 10 Mhz 			(Haute Fréquence)(Russe)

WIKI range:
	MF		: 0.3 à 3 Mhz
	HF		: 3 à 30 Mhz
	VHF		: 30 à 300 Mhz

bonne pratique:

pour integrer une radio comprenant plusieurs gamme (V/UHF par exemple)
	[1] = {						--radio 1 R863 VHF/UHF
		VHF = {
			min = 100,				--minimum radio frequency in mHz
			max = 399,				--maxium  radio frequency in mHz
		},
		nbCanal = 20,
on divisera la gamme comme ceci:

	[1] = {						--radio 1 R863 VHF/UHF
		VHF = {
			min = 100,				--minimum radio frequency in mHz
			max = 225,				--maxium  radio frequency in mHz
		},
		UHF = {
			min = 226,				--minimum radio frequency in mHz
			max = 399,				--maxium  radio frequency in mHz
		},
		nbCanal = 20,


]]--

if not _ then
	function _(text)
		return text
	end
end

Db_Frequency = {


	["UH-1H"] = {	--ne pas supprimer, fichier radio illisible dans le rep mod

		HumanRadio	= {
			frequency		= 305.0,
			editable		= true,
			minFrequency	=  30.000,
			maxFrequency	= 399.975,
			rangeFrequency = {
				{min =  30.0, max =  75.950, modulation	= MODULATION_FM},
				{min = 116.0, max = 149.975, modulation	= MODULATION_AM},
				{min = 225.0, max = 399.975, modulation	= MODULATION_AM}
			},
			modulation	= MODULATION_AM,
		},

		panelRadio =
		{
			[1] =
			{
				name = _("ARC 51BX"),
				range = {{min = 225, max = 399.975}},
				channels =
				{
					[1] = { name = _("Channel 1"),		default = 225.0, modulation = _("AM")}, --, connect = true}, -- default
					[2] = { name = _("Channel 2"),		default = 226.0, modulation = _("AM")},
					[3] = { name = _("Channel 3"),		default = 230.0, modulation = _("AM")},
					[4] = { name = _("Channel 4"),		default = 240.0, modulation = _("AM")},
					[5] = { name = _("Channel 5"),		default = 250.0, modulation = _("AM")},
					[6] = { name = _("Channel 6"),		default = 260.0, modulation = _("AM")},
					[7] = { name = _("Channel 7"),		default = 270.0, modulation = _("AM")},
					[8] = { name = _("Channel 8"),		default = 300.0, modulation = _("AM")},
				}
			},
		},


	},


	["SA342"] = {	--ne pas supprimer, fichier radio non complet dans rep mod
		HumanRadio	= {
			frequency		= 305.0,
			editable		= true,
			minFrequency	=  30.000,
			maxFrequency	= 399.975,
			rangeFrequency = {
				{min =  30.0, max =  87.975, modulation	= MODULATION_FM},
				{min = 118.0, max = 143.975, modulation	= MODULATION_AM},
				{min = 225.0, max = 399.900, modulation	= MODULATION_AM}
			},
			modulation	= MODULATION_AM,
		},

		panelRadio =
		{
			[1] =
			{
				name = _("FM Radio"),
				range = {{min = 30, max = 87.975}},
				channels =
				{
					[1] = { name = _("Channel 1"),		default = 30.0, modulation = _("FM")}, --, connect = true}, -- default
					[2] = { name = _("Channel 2"),		default = 31.0, modulation = _("FM")},
					[3] = { name = _("Channel 3"),		default = 32.0, modulation = _("FM")},
					[4] = { name = _("Channel 4"),		default = 33.0, modulation = _("FM")},
					[5] = { name = _("Channel 5"),		default = 40.0, modulation = _("FM")},
					[6] = { name = _("Channel 6"),		default = 41.0, modulation = _("FM")},
					[7] = { name = _("Channel 0"),		default = 42.0, modulation = _("FM")},
					[8] = { name = _("Channel RG"),		default = 50.0, modulation = _("FM")},
				}
			},
		},
	},

	-- ["Hercules"] = {
	-- 	radio = {						--range of radio frequencies of player aircraft
	-- 		[1] = {						--radio 1
	-- 			UHF = {
	-- 				min = 225,				--minimum radio frequency in mHz
	-- 				max = 399.975,				--maxium  radio frequency in mHz
	-- 			},
	-- 			nbCanal = 20,
	-- 			name = "UHF AN/ARC-164",
	-- 		},
	-- 		[2] = {						--radio 2
	-- 			LVHF = {
	-- 				min = 30,				--minimum radio frequency in mHz
	-- 				max = 87.975,				--maxium  radio frequency in mHz
	-- 			},
	-- 			nbCanal = 0,
	-- 			name = "FM1",
	-- 		},
	-- 		[3] = {						--radio 3
	-- 			VHF = {
	-- 				min = 108,				--minimum radio frequency in mHz
	-- 				max = 155.975,				--maxium  radio frequency in mHz
	-- 			},
	-- 			nbCanal = 0,
	-- 			name = "VHF Radio",
	-- 		},
	-- 	},
	-- },


	["Su-25"] = {--Common aircraft definitions Su-25 & Su-25T
		HumanRadio = {
			frequency 		= 251.0,  -- Radio Freq angepasst F104
			editable 		= true,
			minFrequency	= 100.000, -- angepasst F104
			maxFrequency 	= 399.979, -- angepasst F104
			modulation 		= MODULATION_AM,
		},
	},
	["Su-25T"] = {--Common aircraft definitions Su-25 & Su-25T
		HumanRadio = {
			frequency 		= 251.0,  -- Radio Freq angepasst F104
			editable 		= true,
			minFrequency	= 100.000, -- angepasst F104
			maxFrequency 	= 399.979, -- angepasst F104
			modulation 		= MODULATION_AM,
		},
	},

	["MiG-29A"] = {
		HumanRadio = {
			frequency 		= 251.0,  -- Radio Freq angepasst F104
			editable 		= true,
			minFrequency	= 100.000, -- angepasst F104
			maxFrequency 	= 399.979, -- angepasst F104
			modulation 		= MODULATION_AM,
		},
	},
	["MiG-29S"] = {--FC3
		HumanRadio = {
			frequency 		= 251.0,  -- Radio Freq angepasst F104
			editable 		= true,
			minFrequency	= 100.000, -- angepasst F104
			maxFrequency 	= 399.979, -- angepasst F104
			modulation 		= MODULATION_AM,
		},
	},
	["Su-27"] = {--FC3
		HumanRadio = {
			frequency 		= 251.0,  -- Radio Freq angepasst F104
			editable 		= true,
			minFrequency	= 100.000, -- angepasst F104
			maxFrequency 	= 399.979, -- angepasst F104
			modulation 		= MODULATION_AM,
		},
	},
	
	["J-11A"] = {--FC3
		HumanRadio = {
			frequency 		= 251.0,  -- Radio Freq angepasst F104
			editable 		= true,
			minFrequency	= 100.000, -- angepasst F104
			maxFrequency 	= 399.979, -- angepasst F104
			modulation 		= MODULATION_AM,
		},
	},
	["Su-33"] = {--FC3
		HumanRadio = {
			frequency 		= 251.0,  -- Radio Freq angepasst F104
			editable 		= true,
			minFrequency	= 100.000, -- angepasst F104
			maxFrequency 	= 399.979, -- angepasst F104
			modulation 		= MODULATION_AM,
		},
	},

	["Mi-8MT"] = {

		HumanRadio	= {
			frequency		= 305.0,
			editable		= true,
			minFrequency	=  2,
			maxFrequency	= 399.975,
			rangeFrequency = {
				{min =  2, max =  17.999, modulation	= MODULATION_FM},
				{min =  20.0, max =  59.97, modulation	= MODULATION_FM},
				{min = 100.0, max = 399.975, modulation	= MODULATION_AM},
			},
			modulation	= MODULATION_AM,
		},

		panelRadio =
		{
			[1] =
			{
				name = _("R-863"),
				range = {{min = 100, max = 399.975}},
				channels =
				{
					[1] = { name = _("Channel 0"),		default = 100.0, modulation = _("AM")}, --, connect = true}, -- default
					[2] = { name = _("Channel 1"),		default = 102.0, modulation = _("AM")},
					[3] = { name = _("Channel 2"),		default = 103.0, modulation = _("AM")},
					[4] = { name = _("Channel 3"),		default = 104.0, modulation = _("AM")},
					[5] = { name = _("Channel 4"),		default = 105.0, modulation = _("AM")},
					[6] = { name = _("Channel 5"),		default = 106.0, modulation = _("AM")},
					[7] = { name = _("Channel 6"),		default = 107.0, modulation = _("AM")},
					[8] = { name = _("Channel 7"),		default = 108.0, modulation = _("AM")},
					[9] = { name = _("Channel 8"),		default = 109.0, modulation = _("AM")},
					[10] = { name = _("Channel 9"),		default = 110.0, modulation = _("AM")},
					[11] = { name = _("Channel 10"),	default = 111.0, modulation = _("AM")},
					[12] = { name = _("Channel 11"),	default = 112.0, modulation = _("AM")},
					[13] = { name = _("Channel 12"),	default = 113.0, modulation = _("AM")},
					[14] = { name = _("Channel 13"),	default = 114.0, modulation = _("AM")},
					[15] = { name = _("Channel 14"),	default = 115.0, modulation = _("AM")},
					[16] = { name = _("Channel 15"),	default = 126.0, modulation = _("AM")},
					[17] = { name = _("Channel 16"),	default = 127.0, modulation = _("AM")},
					[18] = { name = _("Channel 17"),	default = 128.0, modulation = _("AM")},
					[19] = { name = _("Channel 18"),	default = 129.0, modulation = _("AM")},
					[20] = { name = _("Channel 19"),	default = 130.0, modulation = _("AM")},
				}
			},
			[2] =
			{
				name = _("R-828"),
				range = {{min = 20, max = 59.97}},
				channels =
				{
					[1] = { name = _("Channel 0"),		default = 20.0, modulation = _("FM")}, --, connect = true}, -- default
					[2] = { name = _("Channel 1"),		default = 31.0, modulation = _("FM")},
					[3] = { name = _("Channel 2"),		default = 32.0, modulation = _("FM")},
					[4] = { name = _("Channel 3"),		default = 33.0, modulation = _("FM")},
					[5] = { name = _("Channel 4"),		default = 40.0, modulation = _("FM")},
					[6] = { name = _("Channel 5"),		default = 41.0, modulation = _("FM")},
					[7] = { name = _("Channel 6"),		default = 42.0, modulation = _("FM")},
					[8] = { name = _("Channel 7"),		default = 50.0, modulation = _("FM")},
					[9] = { name = _("Channel 8"),		default = 51.0, modulation = _("FM")},
					[10] = { name = _("Channel 9"),		default = 52.0, modulation = _("FM")},
				}
			},
		},

	},

	["Ka-50"] = {

		HumanRadio = {
			frequency = 124.0,
			editable = true,
			minFrequency = 0.15,
			maxFrequency = 399.900,
			modulation = MODULATION_AM,
			rangeFrequency = {
				{min =  0.150, max =  1.750, modulation	= MODULATION_AM},
				{min =  20.0, max =  59.90, modulation	= MODULATION_FM},
				{min = 100.0, max = 149.975, modulation	= MODULATION_AM},
				{min = 220.0, max = 399.975, modulation	= MODULATION_AM},
			},
		},
		panelRadio = {
			[1] = {
				name = _("R-828"),
				range = {min = 20.0, max = 59.9},
				channels = {
					[1] = { name = _("Channel 1"),		default = 21.5, modulation = _("FM")},
					[2] = { name = _("Channel 2"),		default = 25.7, modulation = _("FM")},
					[3] = { name = _("Channel 3"),		default = 27.0, modulation = _("FM")},
					[4] = { name = _("Channel 4"),		default = 28.0, modulation = _("FM")},
					[5] = { name = _("Channel 5"),		default = 30.0, modulation = _("FM")},
					[6] = { name = _("Channel 6"),		default = 32.0, modulation = _("FM")},
					[7] = { name = _("Channel 7"),		default = 40.0, modulation = _("FM")},
					[8] = { name = _("Channel 8"),		default = 50.0, modulation = _("FM")},
					[9] = { name = _("Channel 9"),		default = 55.5, modulation = _("FM")},
					[10] = { name = _("Channel 10"),	default = 59.9, modulation = _("FM")},
				}
			},--[1]
			[2] = {
				name = _("ARK-22"),
				displayUnits = "kHz", --отображаемые единицы в МЕ-- задавать ниже в MHz все
				range = {min = 0.150, max = 1.750},
				channels = {
					[1] = { name = _("Channel 1, Outer"),		default	= 0.625,	modulation = _("AM")},	-- Krasnodar-Center
					[2] = { name = _("Channel 1, Inner"),		default = 0.303,	modulation = _("AM")},	-- Krasnodar-Center
					[3] = { name = _("Channel 2, Outer"),		default = 0.289,	modulation = _("AM")},	-- Maykop
					[4] = { name = _("Channel 2, Inner"),		default = 0.591,	modulation = _("AM")},	-- Maykop
					[5] = { name = _("Channel 3, Outer"),		default = 0.408,	modulation = _("AM")},	-- Krymsk
					[6] = { name = _("Channel 3, Inner"),		default = 0.803,	modulation = _("AM")},	-- Krymsk
					[7] = { name = _("Channel 4, Outer"),		default = 0.443,	modulation = _("AM")},	-- Anapa
					[8] = { name = _("Channel 4, Inner"),		default = 0.215,	modulation = _("AM")},	-- Anapa
					[9] = { name = _("Channel 5, Outer"),		default = 0.525,	modulation = _("AM")},	-- Mozdok
					[10] = { name = _("Channel 5, Inner"),		default = 1.065,	modulation = _("AM")},	-- Mozdok
					[11] = { name = _("Channel 6, Outer"),		default = 0.718,	modulation = _("AM")},	-- Nalchik
					[12] = { name = _("Channel 6, Inner"),		default = 0.350,	modulation = _("AM")},	-- Nalchik
					[13] = { name = _("Channel 7, Outer"),		default = 0.583,	modulation = _("AM")},	-- Min.Vody
					[14] = { name = _("Channel 7, Inner"),		default = 0.283,	modulation = _("AM")},	-- Min.Vody
					[15] = { name = _("Channel 8, Outer"),		default = 0.995,	modulation = _("AM")},	-- NDB Kislovodsk
					[16] = { name = _("Channel 8, Inner"),		default = 1.210,	modulation = _("AM")},	-- NDB Peredovaya
				}
			},--[2]
		},
	},
	["Ka-50_3"] = {
		HumanRadio = {
			frequency = 124.0,
			editable = true,
			minFrequency = 0.15,
			maxFrequency = 399.900,
			modulation = MODULATION_AM,
			rangeFrequency = {
				{min =  0.150, max =  1.750, modulation	= MODULATION_AM},
				{min =  20.0, max =  59.90, modulation	= MODULATION_FM},
				{min = 100.0, max = 149.975, modulation	= MODULATION_AM},
				{min = 220.0, max = 399.975, modulation	= MODULATION_AM},
			},
		},
		panelRadio = {
			[1] = {
				name = _("R-828"),
				range = {min = 20.0, max = 59.9},
				channels = {
					[1] = { name = _("Channel 1"),		default = 21.5, modulation = _("FM")},
					[2] = { name = _("Channel 2"),		default = 25.7, modulation = _("FM")},
					[3] = { name = _("Channel 3"),		default = 27.0, modulation = _("FM")},
					[4] = { name = _("Channel 4"),		default = 28.0, modulation = _("FM")},
					[5] = { name = _("Channel 5"),		default = 30.0, modulation = _("FM")},
					[6] = { name = _("Channel 6"),		default = 32.0, modulation = _("FM")},
					[7] = { name = _("Channel 7"),		default = 40.0, modulation = _("FM")},
					[8] = { name = _("Channel 8"),		default = 50.0, modulation = _("FM")},
					[9] = { name = _("Channel 9"),		default = 55.5, modulation = _("FM")},
					[10] = { name = _("Channel 10"),	default = 59.9, modulation = _("FM")},
				}
			},--[1]
			[2] = {
				name = _("ARK-22"),
				displayUnits = "kHz", --отображаемые единицы в МЕ-- задавать ниже в MHz все
				range = {min = 0.150, max = 1.750},
				channels = {
					[1] = { name = _("Channel 1, Outer"),		default	= 0.625,	modulation = _("AM")},	-- Krasnodar-Center
					[2] = { name = _("Channel 1, Inner"),		default = 0.303,	modulation = _("AM")},	-- Krasnodar-Center
					[3] = { name = _("Channel 2, Outer"),		default = 0.289,	modulation = _("AM")},	-- Maykop
					[4] = { name = _("Channel 2, Inner"),		default = 0.591,	modulation = _("AM")},	-- Maykop
					[5] = { name = _("Channel 3, Outer"),		default = 0.408,	modulation = _("AM")},	-- Krymsk
					[6] = { name = _("Channel 3, Inner"),		default = 0.803,	modulation = _("AM")},	-- Krymsk
					[7] = { name = _("Channel 4, Outer"),		default = 0.443,	modulation = _("AM")},	-- Anapa
					[8] = { name = _("Channel 4, Inner"),		default = 0.215,	modulation = _("AM")},	-- Anapa
					[9] = { name = _("Channel 5, Outer"),		default = 0.525,	modulation = _("AM")},	-- Mozdok
					[10] = { name = _("Channel 5, Inner"),		default = 1.065,	modulation = _("AM")},	-- Mozdok
					[11] = { name = _("Channel 6, Outer"),		default = 0.718,	modulation = _("AM")},	-- Nalchik
					[12] = { name = _("Channel 6, Inner"),		default = 0.350,	modulation = _("AM")},	-- Nalchik
					[13] = { name = _("Channel 7, Outer"),		default = 0.583,	modulation = _("AM")},	-- Min.Vody
					[14] = { name = _("Channel 7, Inner"),		default = 0.283,	modulation = _("AM")},	-- Min.Vody
					[15] = { name = _("Channel 8, Outer"),		default = 0.995,	modulation = _("AM")},	-- NDB Kislovodsk
					[16] = { name = _("Channel 8, Inner"),		default = 1.210,	modulation = _("AM")},	-- NDB Peredovaya
				}
			},--[2]
		},
	},
	["P-51D-30-NA"] = {
		panelRadio =
		{
			[1] =
			{
				name = _("SCR 522 A VHF RADIO"),
				range = {{min = 100, max = 156}},
				channels =
				{
					[1] = { name = _("Channel 1"),		default = 100.0, modulation = _("AM")}, --, connect = true}, -- default
					[2] = { name = _("Channel 2"),		default = 102.0, modulation = _("AM")},
					[3] = { name = _("Channel 3"),		default = 103.0, modulation = _("AM")},
					[4] = { name = _("Channel 4"),		default = 104.0, modulation = _("AM")},
				}
			}
		}
	},
	["P-47D-30"] = {
		panelRadio =
		{
			[1] =
			{
				name = _("SCR 522 A VHF RADIO"),
				range = {{min = 100, max = 156}},
				channels =
				{
					[1] = { name = _("Channel 1"),		default = 100.0, modulation = _("AM")}, --, connect = true}, -- default
					[2] = { name = _("Channel 2"),		default = 102.0, modulation = _("AM")},
					[3] = { name = _("Channel 3"),		default = 103.0, modulation = _("AM")},
					[4] = { name = _("Channel 4"),		default = 104.0, modulation = _("AM")},
				}
			}
		}
	},
	["SpitfireLFMkIX"] = {
		panelRadio =
		{
			[1] =
			{
				name = _("ARI 1063"),
				range = {{min = 100, max = 156}},
				channels =
				{
					[1] = { name = _("Channel 1"),		default = 100.0, modulation = _("AM")}, --, connect = true}, -- default
					[2] = { name = _("Channel 2"),		default = 102.0, modulation = _("AM")},
					[3] = { name = _("Channel 3"),		default = 103.0, modulation = _("AM")},
					[4] = { name = _("Channel 4"),		default = 104.0, modulation = _("AM")},
				}
			}
		}
	},

	["MosquitoFBMkVI"] = {
		panelRadio = {
			[1] =
			{
				name = _("VHF RADIO"),
				range = {{min = 100, max = 156}},
				channels =
				{
					[1] = { name = _("Channel 1"),		default = 100.0, modulation = _("AM")}, --, connect = true}, -- default
					[2] = { name = _("Channel 2"),		default = 102.0, modulation = _("AM")},
					[3] = { name = _("Channel 3"),		default = 103.0, modulation = _("AM")},
					[4] = { name = _("Channel 4"),		default = 104.0, modulation = _("AM")},
				}
			},
			[2] =
			{
				name = _("HF Blue Range"),
				range = {{min = 5.5, max = 10}},
				channels =
				{
					[1] = { name = _("Channel 1"),		default	= 5.5,	modulation = _("AM")},
					[2] = { name = _("Channel 2"),		default = 6.5,	modulation = _("AM")},
					[3] = { name = _("Channel 3"),		default = 7.55,	modulation = _("AM")},
					[4] = { name = _("Channel 4"),		default = 8.25,	modulation = _("AM")},
					[5] = { name = _("Channel 5"),		default = 8.30,	modulation = _("AM")},
					[6] = { name = _("Channel 6"),		default = 9.80,	modulation = _("AM")},
					[7] = { name = _("Channel 7"),		default = 9.95,	modulation = _("AM")},
					[8] = { name = _("Channel 8"),		default = 10.000,	modulation = _("AM")},

				}
			},
			[3] = {						--radio HF
				name = _("HF Red Range"),
				range = {{min = 3, max = 5.4}},
				channels =
				{
					[1] = { name = _("Channel 1"),		default	= 3.5,	modulation = _("AM")},
					[2] = { name = _("Channel 2"),		default = 3.6,	modulation = _("AM")},
					[3] = { name = _("Channel 3"),		default = 3.65,	modulation = _("AM")},
					[4] = { name = _("Channel 4"),		default = 4.25,	modulation = _("AM")},
					[5] = { name = _("Channel 5"),		default = 4.30,	modulation = _("AM")},
					[6] = { name = _("Channel 6"),		default = 4.80,	modulation = _("AM")},
					[7] = { name = _("Channel 7"),		default = 4.95,	modulation = _("AM")},
					[8] = { name = _("Channel 8"),		default = 5.00,	modulation = _("AM")},

				}
			},
			[4] = {						--radio MF
				name = _("MF Yellow Range"),
				range = {{min = 0.200, max = 0.500}},
				channels =
				{
					[1] = { name = _("Channel 1"),		default	= 0.20,	modulation = _("AM")},
					[2] = { name = _("Channel 2"),		default = 0.30,	modulation = _("AM")},
					[3] = { name = _("Channel 3"),		default = 0.35,	modulation = _("AM")},
					[4] = { name = _("Channel 4"),		default = 0.40,	modulation = _("AM")},
					[5] = { name = _("Channel 5"),		default = 0.45,	modulation = _("AM")},
					[6] = { name = _("Channel 6"),		default = 0.46,	modulation = _("AM")},
					[7] = { name = _("Channel 7"),		default = 0.47,	modulation = _("AM")},
					[8] = { name = _("Channel 8"),		default = 0.5,	modulation = _("AM")},

				}
			},
		},
	},
	["Bf-109K-4"] = {
		radio = {
			[1] = {
				name = _("FUG 16ZY"),
				range = {{min = 38.4, max = 42.4}},
				channels =
				{
					[1] = { name = _("Channel 1"),		default	= 39.0,	modulation = _("FM")},
					[2] = { name = _("Channel 2"),		default = 40.5,	modulation = _("FM")},
					[3] = { name = _("Channel 3"),		default = 41.75,	modulation = _("FM")},
					[4] = { name = _("Channel 4"),		default = 42.0,	modulation = _("FM")},
				}
			},
		},
	},
}