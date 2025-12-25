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

FrequencyAG = {

	["A-4E-C"] = {							--A-4C
		radio = {						--range of radio frequencies of player aircraft
			[1] = {						--radio 1
				UHF = {
					min = 225,				--minimum radio frequency in mHz   UHF ARC-27 20 preset channels
					max = 399,				--maxium  radio frequency in mHz
				},
				nbCanal = 20,
				name = "ARC-27 UHF",
				manual = true,
			},
		},
	},
	["A-10A"] = {
		radio = {						--range of radio frequencies of player aircraft
			[1] = {
				LVHF = {
					min = 36,				--minimum radio frequency in mHz
					max = 76,				--maxium  radio frequency in mHz
				},
				VHF = {
					min = 116,
					max = 151.975,
				},
				UHF = {
					min = 225,
					max = 399.98,
				},
				nbCanal = 0,
				FC3 = true,
				FC3Frequency = 124,
			},
		},	
	},
	["A-10C"] = {
		radio = {						--range of radio frequencies of player aircraft
			[1] = {						--radio 1 AN/ARC 164 UHF
				UHF = {
					min = 225,				--minimum radio frequency in mHz  
					max = 399.975,			--maxium  radio frequency in mHz
				},
				nbCanal = 0,
				name = "AN/ARC 164 UHF",	
			},
			[2] = {						--radio 2 AN/ARC 186(V) VHF AM # 1  VHF FM #2
				LVHF = {
					min = 36,				--minimum radio frequency in mHz
					max = 76,				--maxium  radio frequency in mHz
				},
				VHF = {
					min = 116,				--minimum radio frequency in mHz 
					max = 151.975,			--maxium  radio frequency in mHz
				},	
				nbCanal = 0,	
				name = "AN/ARC 186 VHF/FM",	
			},
		},
	},
	["A-10C_2"] = {
		radio = {						--range of radio frequencies of player aircraft
			[1] = {						--radio 1 AN/ARC 164 UHF
				UHF = {
					min = 225,				--minimum radio frequency in mHz  
					max = 399.975,			--maxium  radio frequency in mHz
				},
				nbCanal = 0,
				name = "AN/ARC 164 UHF",	
			},
			[2] = {						--radio 2 AN/ARC 186(V) VHF AM # 1  VHF FM #2
				LVHF = {
					min = 36,				--minimum radio frequency in mHz
					max = 76,				--maxium  radio frequency in mHz
				},
				VHF = {
					min = 116,				--minimum radio frequency in mHz 
					max = 151.975,			--maxium  radio frequency in mHz
				},	
				nbCanal = 0,
				name = "AN/ARC 186 VHF/FM",	
			},
		},
	},
	["Bronco-OV-10A"] = {
		-- HumanRadio = 
		-- {
		-- 	frequency = 127.5,  -- Radio Freq
		-- 	editable = true,
		-- 	minFrequency = 100.000,
		-- 	maxFrequency = 156.000,
		-- 	modulation = MODULATION_AM
		-- },
		onlyVariableFrequency = {
			min = 100,
			max = 156,
		},
		prefFreqPackage = {
			nRadio = 2,
			range = "VHF",
			},
		radio = {						--range of radio frequencies of player aircraft
			[1] = {						--radio 1 AN/ARC 164 UHF
				LVHF = {
					min = 30,				--minimum radio frequency in mHz  
					max = 87.975,			--maxium  radio frequency in mHz
				},
				nbCanal = 8,
				name = "FM Radio",	
				-- range = {{min = 30, max = 87.975}},
			},
			[2] = {						--radio  
				VHF = {
					min = 100,				--minimum radio frequency in mHz
					max = 156,				--maxium  radio frequency in mHz
				},
				nbCanal = 0,
				manual = true,
				name = "VHF",
			},
		},
	},
	
	["F-86F Sabre"] = {
		radio = {						--range of radio frequencies of player aircraft
			[1] = {						--radio 1
				UHF = {
					min = 225,				--minimum radio frequency in mHz
					max = 269,				--maxium  radio frequency in mHz
				},
				nbCanal = 18,
			},
		},
	},
	["VSN_F100"] = {
		radio = {						--range of radio frequencies of player aircraft
			[1] = {						--radio 1
				UHF = {
					min = 225,				--minimum radio frequency in mHz
					max = 399.979,				--maxium  radio frequency in mHz
				},
				nbCanal = 0,
				manual = true,
				name = "UHF",
			},
		},
	},
	["VSN_F104C"] = {
		radio = {						--range of radio frequencies of player aircraft
			[1] = {						--radio 1
				UHF = {
					min = 225,				--minimum radio frequency in mHz
					max = 399,				--maxium  radio frequency in mHz
				},
				nbCanal = 27,
				manual = true,
				name = "ARC_66 UHF",
			},
			[2] = {						--radio 1
				UHF = {
					min = 243.0,				--minimum radio frequency in mHz
					max = 243.0,				--maxium  radio frequency in mHz
				},
				nbCanal = 1,
				name = "Guard",
			},
		},
	},
	["VSN_F105D"] = {
		radio = {						--range of radio frequencies of player aircraft
			[1] = {						--radio 1
				UHF = {
					min = 225,				--minimum radio frequency in mHz
					max = 399.979,				--maxium  radio frequency in mHz
				},
				nbCanal = 0,
				manual = true,
				name = "UHF",
			},
		},
	},
	["VSN_F105G"] = {
		radio = {						--range of radio frequencies of player aircraft
			[1] = {						--radio 1
				UHF = {
					min = 225,				--minimum radio frequency in mHz
					max = 399.979,				--maxium  radio frequency in mHz
				},
				nbCanal = 0,
				manual = true,
				name = "UHF",
			},
		},
	},
	["VSN_F4B"] = {
		radio = {
			[1] = {
				UHF = {
					min = 225,
					max = 399,
				},
				nbCanal = 18,
				manual = true,
				name = "UHF COMM",
				type = "AN/ASQ-19",
			},
		},
	},
	["VSN_F4C"] = {
		radio = {
			[1] = {
				UHF = {
					min = 225,
					max = 399,
				},
				nbCanal = 18,
				manual = true,
				name = "UHF COMM",
				type = "AN/ASQ-19",
			},
		},
	},
	["F-4E-45MC"] = {
		radio = {
			[1] = {
				UHF = {
					min = 225,
					max = 399,
				},
				nbCanal = 18,
				manual = true,
				name = "UHF COMM",
				type = "AN/ARC-164",
			},
			[2] = {
				UHF = {
					min = 265,
					max = 284.9,
				},
				nbCanal = 20,
				manual = false,
				name = "UHF AUX",
			},
		},
	},

	["F-5E-3"] = {
		radio = {						--range of radio frequencies of player aircraft
			[1] = {				
				UHF = {
					min = 225,				--minimum radio frequency in mHz   UHF ARC-164 20 preset channels
					max = 399,				--maxium  radio frequency in mHz
				},
				nbCanal = 20,
				manual = true,
				name = "RC-164 UHF",
			},			
		},
	},
	
	["F-14"] = {--Common aircraft definitions F-14A-135-GR & F-14B
		-- HumanRadio = {
		-- 	frequency     = 124.0, -- onboard radio, default DCSW frequency, chnl 0
		-- 	editable     = true,
		-- 	minFrequency     = 30.000,
		-- 	maxFrequency     = 399.975,
		-- 	rangeFrequency = {
		-- 		{min = 30.0,  max = 87.975},
		-- 		{min = 108.0, max = 173.975},
		-- 		{min = 225.0, max = 399.975},
		-- 	},
		-- 	modulation     = MODULATION_AM
		-- },
		radio = {
			[1] = {
				UHF = {
					min = 225,				--minimum radio frequency in mHz    UHF ARC-159    20  preset channels
					max = 399,				--maxium  radio frequency in mHz
				},
				nbCanal = 20,
				manual = true,
				name = "ARC-159 UHF PILOT",
				range = {min = 225.0, max = 399.975},--testing
			},
			[2] = {
				LVHF = {
					min = 30,				--minimum radio frequency in mHz
					max = 87.975,				--maxium  radio frequency in mHz
				},
				VHF = {
					min = 108,				--minimum radio frequency in mHz   V/UHF FM ARC-182 20 preset channels
					max = 173,				--maxium  radio frequency in mHz
				},
				UHF = {
					min = 225,				--minimum radio frequency in mHz   MIN 108 MAX 399
					max = 399,				--maxium  radio frequency in mHz
				},
				nbCanal = 30,
				manual = true,
				name = "ARC-182 V/UHF RIO",
				range = {{min = 30.0, max = 87.975},--testing
				{min = 108.0, max = 173.975},
				{min = 225.0, max = 399.975}},
			},
		},
	},

	["F-15ESE"] = {
		radio = {			
			[1] = {						--radio 1 AN/ARC-164
				UHF = {
					min = 225,				--minimum radio frequency in mHz 
					max = 399,				--maxium  radio frequency in mHz
				},
				nbCanal = 20,
				name = "UHF Radio 1",
			},
			[2] = {						--radio 2 AN/ARC-222
				LVHF = {
					min = 30,				--minimum radio frequency in mHz 
					max = 87,				--maxium  radio frequency in mHz
				},
				-- VHF = { 
				-- 	{min = 108.0, max = 115.975},				--minimum radio frequency in mHz   
				-- 	{min = 118.0, max = 173.975},				--maxium  radio frequency in mHz
				-- },
				VHF = {
					min = 118,				--minimum radio frequency in mHz   
					max = 173,				--maxium  radio frequency in mHz
				},
				UHF = {
					min = 225,				--minimum radio frequency in mHz 
					max = 399,				--maxium  radio frequency in mHz
				},
				nbCanal = 20,
				name = "V/UHF Radio 2",
			},
		},
	},
	["F-16C_50"] = {
		radio = {			
			[1] = {						--radio 1 AN/ARC-164
				UHF = {
					min = 225,				--minimum radio frequency in mHz 
					max = 399.975,				--maxium  radio frequency in mHz
				},
				nbCanal = 20,
				-- range = {
				-- 	{min = 225.0, max = 399.975, modulation	= MODULATION_AM}
				-- },
			},
			[2] = {						--radio 2 AN/ARC-222
				LVHF = {
					min = 30,				--minimum radio frequency in mHz 
					max = 87.975,				--maxium  radio frequency in mHz
				},
				VHF = {
					min = 116,				--minimum radio frequency in mHz   
					max = 155.975,				--maxium  radio frequency in mHz
				},
				nbCanal = 20,
				-- range = {
				-- 	{min =  30.0, max =  87.975, modulation	= MODULATION_FM},	-- FM
				-- 	{min = 116.0, max = 155.975, modulation	= MODULATION_AM}	-- AM
				-- },
			},
		},
	},
	["FA-18C_hornet"] = {
		radio = {						--range of radio frequencies of player aircraft			
			[1] = {						--radio 1
				LVHF = {
					min = 30,				--minimum radio frequency in mHz   V/UHF FM ARC-210 20 preset channels
					max = 87,				--maxium  radio frequency in mHz
				},
				VHF = {
					min = 118,				--minimum radio frequency in mHz   V/UHF FM ARC-210 20 preset channels
					max = 173,				--maxium  radio frequency in mHz
				},
				UHF = {
					min = 225,				--minimum radio frequency in mHz   V/UHF FM ARC-210 20 preset channels
					max = 399,				--maxium  radio frequency in mHz
				},
				nbCanal = 20,
				name = "ARC-210 COMM 1 V/UHF",
				manual = true,
			},
			[2] = {						--radio 2
				LVHF = {
					min = 30,				--minimum radio frequency in mHz   V/UHF FM ARC-210 20 preset channels
					max = 87,				--maxium  radio frequency in mHz
				},
				VHF = {
					min = 118,				--minimum radio frequency in mHz   V/UHF FM ARC-210 20 preset channels
					max = 173,				--maxium  radio frequency in mHz
				},
				UHF = {
					min = 225,				--minimum radio frequency in mHz   V/UHF FM ARC-210 20 preset channels
					max = 399,				--maxium  radio frequency in mHz
				},
				nbCanal = 20,
				name = "ARC-210 COMM 2 V/UHF",
				manual = true,
			},
		},
	},
	["AJS37"] = {
		radio = {						--range of radio frequencies of player aircraft
			[1] = {						-- V/UHF FR 24 radio
				UHF = {
					min = 225,				--minimum radio frequency in mHz  
					max = 399.95,			--maxium  radio frequency in mHz
				},
				-- reserved = { 7 , 121.5},
				nbCanal = 6,
				name = "FR 24 UHF backup Radio",
			},
			[2] = {						-- V/UHF FR 22 radio
				VHF = {
					min = 103,				--minimum radio frequency in mHz 	TODO a fonfirmer avec notice
					max = 155.975,			--maxium  radio frequency in mHz
				},	
				UHF = {
					min = 225,				--minimum radio frequency in mHz  
					max = 399.95,			--maxium  radio frequency in mHz
				},	
				
				nbCanal = 0,
				manual = true,
				name = "FR 22 V/UHF",
			}
			-- [2] = {						--radio 1 mode 2
				-- min = 103,				--minimum radio frequency in mHz   VHF FR-22 25 Khz interval    10  preset channels
				-- max = 155,				--maxium  radio frequency in mHz
			-- },
			-- [3] = {						--radio 2
				-- min = 228,				--minimum radio frequency in mHz   VHF FR-24 3 preset channels only
				-- max = 399,				--maxium  radio frequency in mHz
			-- },
		},
	},
	["AV8BNA"] = {
		radio = {						--range of radio frequencies of player aircraft
			[1] = {						-- V/UHF FM ARC-210 26 preset channels
				LVHF = {
					min = 30,				--minimum radio frequency in mHz  30 à 400, mais on limite artificielement pour harmoniser avec les autres types d avion
					max = 87,				--maxium  radio frequency in mHz
				},
				VHF = {
					min = 118,				--minimum radio frequency in mHz 
					max = 173,				--maxium  radio frequency in mHz
				},
				UHF = {
					min = 225,				--minimum radio frequency in mHz  
					max = 399,				--maxium  radio frequency in mHz
				},
				nbCanal = 26,
				name = "ARC-210 COM1 V/UHF/AM/FM",
				
			},
			[2] = {						-- V/UHF FM ARC-210 26 preset channels
				LVHF = {
					min = 30,				--minimum radio frequency in mHz  
					max = 87,				--maxium  radio frequency in mHz
				},
				VHF = {
					min = 118,				--minimum radio frequency in mHz  
					max = 173,				--maxium  radio frequency in mHz
				},
				UHF = {
					min = 225,				--minimum radio frequency in mHz   
					max = 399,				--maxium  radio frequency in mHz
				},
				nbCanal = 26,
				name = "ARC-210 COM2 V/UHF/AM/FM",
			},			
			-- [3] = {						--V/UHF FM ARC-210 30 preset channels  RCS
				-- LVHF = {
					-- min = 30,				--minimum radio frequency in mHz  
					-- max = 87,				--maxium  radio frequency in mHz
				-- },
				-- VHF = {
					-- min = 118,				--minimum radio frequency in mHz   
					-- max = 173,				--maxium  radio frequency in mHz
				-- },
				-- UHF = {
					-- min = 225,				--minimum radio frequency in mHz   
					-- max = 399,				--maxium  radio frequency in mHz
				-- },
				-- nbCanal = 30,
				-- name = "ARC-210 RSC V/UHF/AM/FM",
			-- },
		},
	},
	["M-2000C"] = {
		radio = {						--range of radio frequencies of player aircraft
			[1] = {						--radio 1
				UHF = {
					min = 225,				--minimum radio frequency in mHz  
					max = 400,				--maxium  radio frequency in mHz
				},
				nbCanal = 20,
				name = "Poste Rouge UHF",
				frequencyMustBeRadio1 = true;
			},
			[2] = {						--radio 2
				VHF = {
					min = 118,				--minimum radio frequency in mHz   V/UHF FM ARC-210 20 preset channels
					max = 140,				--maxium  radio frequency in mHz
				},
				UHF = {
					min = 225,				--minimum radio frequency in mHz 
					max = 400,				--maxium  radio frequency in mHz
				},
				nbCanal = 20,
				manual = true,
				name = "Poste Vert V/UHF",
			},
		},
	},	
	
	["Mirage-F1"] = {
		radio = {						--range of radio frequencies of player aircraft
			[1] = {						--radio 1
				VHF = {
					min = 118,				--minimum radio frequency in mHz   V/UHF FM ARC-210 20 preset channels
					max = 143,				--maxium  radio frequency in mHz
				},
				UHF = {
					min = 225,				--minimum radio frequency in mHz 
					max = 400,				--maxium  radio frequency in mHz
				},
				nbCanal = 20,
				manual = true,
				name = "Poste Vert V/UHF",
			},			
			[2] = {						--radio 2
				UHF = {
					min = 225,				--minimum radio frequency in mHz  
					max = 400,				--maxium  radio frequency in mHz
				},
				nbCanal = 20,
				name = "Poste Rouge UHF",
			},
		},
	},

	["MB-339A"] = {
		radio = {						--range of radio frequencies of player aircraft
			[1] = {						--radio 1
				UHF = {
					min = 225,				--minimum radio frequency in mHz 
					max = 399.975,				--maxium  radio frequency in mHz
				},
				nbCanal = 20,
				manual = true,
				name = "UHF AN/ARC-150(V)-2 ", --UHF",
			},			
			[2] = {						--radio 2
				LVHF = {
					min = 30,				--minimum radio frequency in mHz
					max = 87.975,				--maxium  radio frequency in mHz
				},
				UHF = {
					min = 225,				--minimum radio frequency in mHz  
					max = 400,				--maxium  radio frequency in mHz
				},
				VHF = {
					min = 108.0,				--minimum radio frequency in mHz   V/UHF FM ARC-210 20 preset channels
					max = 155.975,				--maxium  radio frequency in mHz
				},
				nbCanal = 30,
				name = "VHF/UHF SRT-651/N",
			},
		},
	},

	["SA342"] = {
		onlyVariableFrequency = {
			min = 118,
			max = 143,
		},
		prefFreqPackage = {
			nRadio = 2,
			range = "VHF",
			},
		radio = {						--range of radio frequencies of player aircraft
			[1] = {						--radio 1
				LVHF = {
					min = 30,				--minimum radio frequency in mHz
					max = 50,				--maxium  radio frequency in mHz
				},
				nbCanal = 8,
				name = "FM",
			},
			[2] = {						--radio 2
				VHF = {
					min = 118,				--minimum radio frequency in mHz
					max = 143,				--maxium  radio frequency in mHz
				},
				nbCanal = 0,
				name = "VHF Radio",
			},
			[3] = {						--radio 3
				UHF = {
					min = 225,				--minimum radio frequency in mHz
					max = 399.9,				--maxium  radio frequency in mHz
				},
				nbCanal = 0,
				name = "UHF Radio",
			},
		},
	},

	["AH-64D_BLK_II"] = {
		
		-- prefFreqPackage = {
			-- nRadio = 2,
			-- range = "VHF",
			-- },
		radio = {								--range of radio frequencies of player aircraft
			[1] = {								--radio 1 name = _("ARC-186"),
				VHF = {
					min = 108.0,				--minimum radio frequency in mHz
					max = 151.975,				--maxium  radio frequency in mHz
				},
				nbCanal = 10,
				name = "ARC-186 VHF",
				manual = true,
			},
			[2] = {								--radio 2 name = _("ARC-164"),
				UHF = {
					min = 225,					--minimum radio frequency in mHz
					max = 399.975,				--maxium  radio frequency in mHz
				},
				nbCanal = 10,
				name = "ARC-164 UHF",
				manual = true,
			},
			[3] = {								--radio 3 name = _("FM 1: ARC-201D"),
				LVHF = {
					min = 30.0,					--minimum radio frequency in mHz
					max = 87.995,				--maxium  radio frequency in mHz
				},
				nbCanal = 10,
				manual = true,
				name = "ARC-201D FM 1",
			},
			[4] = {								--radio 4 name = _("FM 2: ARC-201D"),
				LVHF = {
					min = 30.0,					--minimum radio frequency in mHz
					max = 87.995,				--maxium  radio frequency in mHz
				},
				nbCanal = 10,
				manual = true,
				name = "ARC-201D FM 2",
			},
			[5] = {						--radio 3 Yadro1 HF
				HF = {
					min = 2,				--minimum radio frequency in mHz
					max = 29.999,			--maxium  radio frequency in mHz
				},
				nbCanal = 0,
				name = "ARC-220 HF",
			},
		},
	},


	["UH-1H"] = {
		radio = {						--range of radio frequencies of player aircraft
			[1] = {						--radio 1
				UHF = {
					min = 225,				--minimum radio frequency in mHz
					max = 399.9,				--maxium  radio frequency in mHz
				},
				nbCanal = 20,
				name = "ARC 51BX UHF",
				manual = true,
			},
			[2] = {						--radio 2
				VHF = {
					min = 116,				--minimum radio frequency in mHz
					max = 149.975,				--maxium  radio frequency in mHz
				},
				nbCanal = 0,
				name = "ARC 134 VHF",
				manual = true,
			},
		},
		 
		
	},
	["OH58D"] = {
		onlyVariableFrequency = {
			min = 30,
			max = 399,
		},
		prefFreqPackage = {
			nRadio = 1,
			range = "UHF",
			},
		radio = {
			[1] = {
				UHF = {
					min = 225,				--minimum radio frequency in mHz
					max = 399.975,				--maxium  radio frequency in mHz
				},
				nbCanal = 20,
				name = "UHF AM",
				manual = true,
				-- range =
				-- {
				-- 	{min = 225.0, max = 399.975}
				-- },
			},
			[2] = {	
				VHF = {
					min = 116,				--minimum radio frequency in mHz
					max = 151.975,				--maxium  radio frequency in mHz
				},
				nbCanal = 20,
				name = "VHF AM",
				manual = true,
				-- range =
				-- {
				-- 	{min = 116.0, max = 151.975}
				-- },
			},
			[3] = {
				LVHF = {
					min = 30,				--minimum radio frequency in mHz
					max = 87.975,				--maxium  radio frequency in mHz
				},
				nbCanal = 21,
				name = "VHF FM1",
				manual = true,
				-- range =
				-- {
				-- 	{min = 30.0, max = 87.975}
				-- },
			},
			[4] = {	
				LVHF = {
					min = 30,				--minimum radio frequency in mHz
					max = 87.975,				--maxium  radio frequency in mHz
				},
				nbCanal = 21,
				name = "VHF FM2",
				manual = true,
				-- range =
				-- {
				-- 	{min = 30.0, max = 87.975}
				-- },
			},
		},
	},
	["OH-6A"] = {
		onlyVariableFrequency = {
			min = 100,
			max = 399,
		},
		prefFreqPackage = {
			nRadio = 1,
			range = "UHF",
			},
		radio = {						--range of radio frequencies of player aircraft
			[1] = {						--radio 1
				UHF = {
					min = 225,				--minimum radio frequency in mHz
					max = 399.975,				--maxium  radio frequency in mHz
				},
				nbCanal = 20,
				name = "AN/ARC-51BX",
				manual = true,
				-- range =
				-- {
				-- 	{min = 225.0, max = 399.975}
				-- },
			},
		},
	},
	["CH-47Fbl1"] = {
		radio = {						--range of radio frequencies of player aircraft
			[1] = {						--radio 2 AN/ARC 186(V) VHF AM # 1  VHF FM #2
				LVHF = {
					min = 30,				--minimum radio frequency in mHz
					max = 87.975,				--maxium  radio frequency in mHz
				},
				VHF = {
					min = 116,				--minimum radio frequency in mHz 
					max = 151.975,			--maxium  radio frequency in mHz
				},	
				nbCanal = 20,
				name = "AN/ARC 186 VHF/FM",	
			},
		},
	},
	["C-130J-30"] = {
		-- HumanRadio                               = {
		-- 	frequency      = 305.0,
		-- 	editable       = true,
		-- 	minFrequency   = 1.000,
		-- 	maxFrequency   = 399.975,
		-- 	rangeFrequency = {
		-- 		{ min = 30.0,   max = 87.975,  modulation = MODULATION_FM },
		-- 		{ min = 156.0,  max = 173.975, modulation = MODULATION_FM },
		-- 		{ min = 225.0,  max = 399.975, modulation = MODULATION_AM },
		-- 		{ min = 108.0,  max = 200.975, modulation = MODULATION_AM },
		-- 	},
		-- 	modulation     = MODULATION_AM,
		-- },
		-- panelRadio                               = {
		-- 	[1] = {
		-- 		name = _("UHF-1/2"),
		-- 		range = {
		-- 			{ min = 225.0, max = 399.975, modulation = MODULATION_AM }
		-- 		},
		-- 		channels = { 30 }

		-- 	},
		-- 	[2] = {
		-- 		name = _("VHF-1/2"),
		-- 		range = {
		-- 			{ min = 30.0, max = 200.975, modulation = MODULATION_AM }
		-- 		},
		-- 		channels = { 10 }
		-- 	},
		-- },

		radio = {						--range of radio frequencies of player aircraft
			[1] = {						--radio 1
				UHF = {
					min = 225,				--minimum radio frequency in mHz
					max = 399.975,				--maxium  radio frequency in mHz
				},
				nbCanal = 20,
				name = "UHF-1/2",
			},
			[2] = {						--radio 2
				LVHF = {
					min = 30,				--minimum radio frequency in mHz
					max = 87.975,				--maxium  radio frequency in mHz
				},
				VHF = {
					min = 108,				--minimum radio frequency in mHz
					max = 200.975,				--maxium  radio frequency in mHz
				},
				nbCanal = 10,
				name = "VHF-1/2",
			},
		},
	},
	["Hercules"] = {
		-- prefFreqPackage = {
		-- 	nRadio = 2,
		-- 	range = "VHF",
		-- 	},
		radio = {						--range of radio frequencies of player aircraft
			[1] = {						--radio 1
				UHF = {
					min = 225,				--minimum radio frequency in mHz
					max = 399.975,				--maxium  radio frequency in mHz
				},
				nbCanal = 20,
				name = "UHF AN/ARC-164",
			},
			[2] = {						--radio 2
				LVHF = {
					min = 30,				--minimum radio frequency in mHz
					max = 87.975,				--maxium  radio frequency in mHz
				},
				nbCanal = 0,
				name = "FM1",
			},
			[3] = {						--radio 3
				VHF = {
					min = 108,				--minimum radio frequency in mHz
					max = 155.975,				--maxium  radio frequency in mHz
				},
				nbCanal = 0,
				name = "VHF Radio",
			},
		},
	},
	["L-39"] = {--Common aircraft definitions L-39C & L-39ZA
		radio = {
			[1] = {
				VHF = {
					min = 118,
					max = 224.995,
				},
				UHF = {
					min = 225,
					max = 399.95,
				},
				nbCanal = 20,
				startCanal = 0,
				name = "R-832M V/UHF"
			},
		},	
	},

	["Su-25"] = {--Common aircraft definitions Su-25 & Su-25T
		radio = {						--range of radio frequencies of player aircraft
			[1] = {
				VHF = {
					min = 100,
					max = 224.995,
				},
				UHF = {
					min = 225,
					max = 399.98,
				},
				nbCanal = 0,
				FC3 = true,
				FC3Frequency = 124,
			},
		},	
	},

	["MiG-15bis"] = {
		radio = {						--range of radio frequencies of player aircraft
			[1] = {						--radio RSI 6K HF
				HF = {
					min = 3.75,				--minimum radio frequency in mHz   
					max = 5,				--maxium  radio frequency in mHz
				},
				nbCanal = 0,
				name = "RSI-6K",
			},
		},	
	},
	["MiG-19P"] = {
		radio = {						--range of radio frequencies of player aircraft
			[1] = {						--radio 1 RSIU 4 V VHF
				VHF = {
					min = 100,				--minimum radio frequency in mHz   
					max = 150,				--maxium  radio frequency in mHz
				},
				nbCanal = 6,
				name = "RSIU-4V VHF",
			},
		},	
	},
	["MiG-21Bis"] = {
		radio = {
			[1] = {						--radio 1  RSIU 5V 
				VHF = {
					min = 118,				--minimum radio frequency in mHz   RS-832 0 to 19 preset channels only
					max = 140,				--maxium  radio frequency in mHz
				},
				UHF = {
					min = 225,				--minimum radio frequency in mHz  
					max = 390,				--maxium  radio frequency in mHz
				},
				nbCanal = 20,
				startCanal = 0,
				name = "RS-832 V/UHF",
				emergencyFreq = 121.5,
				emergencyPreset = 2,
			},
		},
	},
	["MiG-29 Fulcrum"] = {
		radio = {
			[1] = {
				VHF = {
					min = 100,
					max = 149.975,
				},
				UHF = {
					min = 220,
					max = 399.975,
				},
				nbCanal = 20,
				name = "VHF/UHF R-862"
			},
			[2] = {
				HF = {
					min = 0.150,
					max = 1.2995,
				},
				nbCanal = 8,
				name = "ARK-19",
			},
		},
	},
	["MiG-29A"] = {
		radio = {
			[1] = {
				VHF = {
					min = 100,
					max = 224.995,
				},
				UHF = {
					min = 225,
					max = 399.98,
				},
				nbCanal = 0,
				FC3 = true,
				FC3Frequency = 124,
			},
		},	
	},
	["MiG-29S"] = {
		radio = {						--range of radio frequencies of player aircraft
			[1] = {
				VHF = {
					min = 100,
					max = 224.995,
				},
				UHF = {
					min = 225,
					max = 399.98,
				},
				nbCanal = 0,
				FC3 = true,
				FC3Frequency = 124,
			},
		},	
	},
	["JF-17"] = {
		radio = {			
			[1] = {						--radio 1
				LVHF = {
					min = 30,				--minimum radio frequency in mHz 
					max = 100,				--maxium  radio frequency in mHz
				},
				VHF = {
					min = 101,				--minimum radio frequency in mHz 
					max = 224,				--maxium  radio frequency in mHz
				},
				UHF = {
					min = 225,				--minimum radio frequency in mHz  
					max = 399,				--maxium  radio frequency in mHz
				},
				nbCanal = 20,
			},
		},
	},

	["Mi-8MT"] = {
		
		radio = {						--range of radio frequencies of player aircraft
			[1] = {						--radio 1
				VHF = {
					min = 100,				--minimum radio frequency in mHz
					max = 225,				--maxium  radio frequency in mHz
				},	
				UHF = {
					min = 226,				--minimum radio frequency in mHz
					max = 399,				--maxium  radio frequency in mHz
				},
				nbCanal = 20,
				name = "R-863 V/UHF",
				startCanal = 0,
				manual = true,
			},
			[2] = {						--radio 2
				LVHF = {
					min = 20,				--minimum radio frequency in mHz
					max = 59.97,				--maxium  radio frequency in mHz
				},
				nbCanal = 10,
				name = "R-828 LVHF",
				startCanal = 0,
			},
			[3] = {						--radio 3 Yadro1 HF
				HF = {
					min = 2,				--minimum radio frequency in mHz
					max = 17.999,			--maxium  radio frequency in mHz
				},
				nbCanal = 0,
				name = "Yadro HF",
			},
		},
	},
	["Mi-24P"] = {
		
		radio = {
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
				name = "R-863",
				startCanal = 0,
			},
			[2] = {						--radio 2 R828 LVHF
				LVHF = {
					min = 20,				--minimum radio frequency in mHz
					max = 59.97,			--maxium  radio frequency in mHz
				},
				nbCanal = 10,
				name = "R-868",
				startCanal = 0,
			},
			[3] = {						--radio 3 Yadro1 HF
				HF = {
					min = 2,				--minimum radio frequency in mHz
					max = 17.999,			--maxium  radio frequency in mHz
				},
				nbCanal = 0,
				name = "Yadro",
			},
		},
	},
	["Ka-50"] = {
		
		radio = {						--range of radio frequencies of player aircraft
			[1] = {						--radio 1
				LVHF = {
					min = 20,				--minimum radio frequency in mHz
					max = 59,				--maxium  radio frequency in mHz
				},
				nbCanal = 10,
			},
			[2] = {						--radio 2 simule la frequence FC3 de DCS
				VHF = {
					min = 100,				--minimum radio frequency in mHz
					max = 224,				--maxium  radio frequency in mHz
				},
				UHF = {
					min = 225,				--minimum radio frequency in mHz
					max = 399,				--maxium  radio frequency in mHz
				},
				nbCanal = 0,
			},
			-- [2] = {						--radio 2
				-- min = 0.215,				--minimum radio frequency in mHz
				-- max = 1.065,				--maxium  radio frequency in mHz
				-- nbCanal = 16,
			-- },
		},
	},
	["Ka-50_3"] = {
		
		radio = {						--range of radio frequencies of player aircraft
			[1] = {						--radio 1
				LVHF = {
					min = 20,				--minimum radio frequency in mHz
					max = 59,				--maxium  radio frequency in mHz
				},
				nbCanal = 10,
			},
			[2] = {						--radio 2 simule la frequence FC3 de DCS
				VHF = {
					min = 100,				--minimum radio frequency in mHz
					max = 224,				--maxium  radio frequency in mHz
				},
				UHF = {
					min = 225,				--minimum radio frequency in mHz
					max = 399,				--maxium  radio frequency in mHz
				},
				nbCanal = 0,
			},
			-- [2] = {						--radio 2
				-- min = 0.215,				--minimum radio frequency in mHz
				-- max = 1.065,				--maxium  radio frequency in mHz
				-- nbCanal = 16,
			-- },
		},
	},
	["P-51D-30-NA"] = {
		radio = {							
			[1] = {						--radio  SCR 522 A VHF RADIO
				VHF = {
					min = 100,				--minimum radio frequency in mHz
					max = 156,				--maxium  radio frequency in mHz
				},
				nbCanal = 4,
			},
		},
	},
	["P-47D-30"] = {
		radio = {									
			[1] = {						--radio SCR 522 A VHF RADIO
				VHF = {
					min = 100,				--minimum radio frequency in mHz
					max = 156,				--maxium  radio frequency in mHz
				},
				nbCanal = 4,
			},
		},
	},
	["SpitfireLFMkIX"] = {
		radio = {									
			[1] = {						--radio A R I 1063 type HF
				VHF = {
					min = 100,				--minimum radio frequency in mHz
					max = 156,				--maxium  radio frequency in mHz
				},
				nbCanal = 4,
			},
		},
	},
	
	["MosquitoFBMkVI"] = {
		radio = {									
			[1] = {						--radio VHF
				VHF = {
					min = 100,				--minimum radio frequency in mHz
					max = 156,				--maxium  radio frequency in mHz
				},
				nbCanal = 4,
				name = "SCR-522 (TR1143) VHF"
			},
			[2] = {						--radio HF
				HF = {
					min = 5.5,				--minimum radio frequency in mHz
					max = 10,				--maxium  radio frequency in mHz
				},
				nbCanal = 8,
				name = "HF Blue Range"
			},
			[3] = {						--radio HF
				HF = {
					min = 3,				--minimum radio frequency in mHz
					max = 5.4,				--maxium  radio frequency in mHz
				},
				nbCanal = 8,
				name = "HF Red Range"
			},
			[4] = {						--radio MF
				MF = {
					min = 0.200,				--minimum radio frequency in mHz
					max = 0.500,				--maxium  radio frequency in mHz
				},
				nbCanal = 8,
				name = "MF Yellow Range"
			},
		},
	},
	["Bf-109K-4"] = {
		radio = {									
			[1] = {						--radio 4 is equipped with a FUG 16ZY radio transmitter and receiver.
				LVHF = {
					min = 38.4,				--minimum radio frequency in mHz
					max = 42.4,				--maxium  radio frequency in mHz
				},
				nbCanal = 4,
			},
		},
	},
}	
	
Db_Frequency = {


	-- HumanRadio = {
	-- 	frequency 		= 251.0,  -- Radio Freq angepasst F104
	-- 	editable 		= true,
	-- 	minFrequency	= 225.000, -- angepasst F104
	-- 	maxFrequency 	= 399.979, -- angepasst F104
	-- 	modulation 		= MODULATION_AM
	-- },

	-- 	panelRadio = {
    --     [1] = {--ARC_66 has 27 slots...so look for those missing 7 ;-)
    --         name = _("ARC_66"),
    --         range = {
	-- 					{min = 225.0, max = 399.0}
    --         },
    --         channels = {  -- matches L-39C except for channel 8, which was changed to a Georgian airport and #20 which is NTTR only (for now).  This radio goes 1-20 not 0-19.
    --             [1] = { name = _("Channel 1"),		default = 264.0, modulation = _("AM"), connect = true}, -- mineralnye-vody (URMM) : 264.0
    --             [2] = { name = _("Channel 2"),		default = 265.0, modulation = _("AM")},	-- nalchik (URMN) : 265.0
    --             [3] = { name = _("Channel 3"),		default = 256.0, modulation = _("AM")},	-- sochi-adler (URSS) : 256.0
    --             [4] = { name = _("Channel 4"),		default = 254.0, modulation = _("AM")},	-- maykop-khanskaya (URKH), nellis (KLSV) : 254.0
    --             [5] = { name = _("Channel 5"),		default = 250.0, modulation = _("AM")},	-- anapa (URKA) : 250.0
    --             [6] = { name = _("Channel 6"),		default = 270.0, modulation = _("AM")},	-- beslan (URMO) : 270.0
    --             [7] = { name = _("Channel 7"),		default = 257.0, modulation = _("AM")},	-- krasnodar-pashkovsky (URKK) : 257.0
    --             [8] = { name = _("Channel 8"),		default = 258.0, modulation = _("AM")},	-- sukhumi-babushara (UGSS) : 255.0
    --             [9] = { name = _("Channel 9"),		default = 262.0, modulation = _("AM")},	-- kobuleti (UG5X) : 262.0
    --             [10] = { name = _("Channel 10"),	default = 259.0, modulation = _("AM")},	-- gudauta (UG23) : 259.0
    --             [11] = { name = _("Channel 11"),	default = 268.0, modulation = _("AM")},	-- tbilisi-soganlug (UG24) : 268.0
    --             [12] = { name = _("Channel 12"),	default = 269.0, modulation = _("AM")},	-- tbilisi-vaziani (UG27) : 269.0
    --             [13] = { name = _("Channel 13"),	default = 260.0, modulation = _("AM")},	-- batumi (UGSB) : 260.0
    --             [14] = { name = _("Channel 14"),	default = 263.0, modulation = _("AM")},	-- kutaisi-kopitnari (UGKO) : 263.0
    --             [15] = { name = _("Channel 15"),	default = 261.0, modulation = _("AM")},	-- senaki-kolkhi (UGKS) :  261.0
    --             [16] = { name = _("Channel 16"),	default = 267.0, modulation = _("AM")},	-- tbilisi-lochini (UGTB) : 267.0
    --             [17] = { name = _("Channel 17"),	default = 251.0, modulation = _("AM")},	-- krasnodar-center (URKI), creech (KINS) : 251.0
    --             [18] = { name = _("Channel 18"),	default = 253.0, modulation = _("AM")},	-- krymsk (URKW), mccarran (KLAS) : 253.0
	-- 			[19] = { name = _("Channel 19"),	default = 266.0, modulation = _("AM")},	-- mozdok (XRMF) : 266.0
    --             [20] = { name = _("Channel 20"),	default = 252.0, modulation = _("AM")}, -- N/A, groom lake/homey (KXTA) : 252.0
	-- 			[21] = { name = _("Channel 21"),	default = 252.8, modulation = _("AM")}, -- Syria Amman
	-- 			[22] = { name = _("Channel 22"),	default = 252.9, modulation = _("AM")}, -- Syria Beirut-Rafic
	-- 			[23] = { name = _("Channel 23"),	default = 252.1, modulation = _("AM")}, -- Syria Gecitcale
	-- 			[24] = { name = _("Channel 24"),	default = 252.3, modulation = _("AM")}, -- Syria H3
	-- 			[25] = { name = _("Channel 25"),	default = 360.1, modulation = _("AM")}, -- Syria Incirlic
	-- 			[26] = { name = _("Channel 26"),	default = 250.4, modulation = _("AM")}, -- Syria King Hussein 				
	-- 			[27] = { name = _("Channel 27"),	default = 251.8, modulation = _("AM")}, -- Syria Kingsfield
	-- 		}
    --     },
	-- 	[2] = { --Guard_Radio
	-- 		name = _("Guard_Channel ARC_66"),
	-- 		range = { 
	-- 					{min = 238.0, max = 248.0} 
	-- 				},
	-- 		channels = {
	-- 			[1] = { name = _("Guard 1"),	default = 243.0, modulation = _("AM")},
	-- 		}
	-- 	},
    -- }
	
		-- ["F-86F Sabre"] = {
	-- 	radio = {						--range of radio frequencies of player aircraft
	-- 		[1] = {						--radio 1
	-- 			UHF = {
	-- 				min = 225,				--minimum radio frequency in mHz
	-- 				max = 269,				--maxium  radio frequency in mHz
	-- 			},
	-- 			nbCanal = 18,
	-- 		},
	-- 	},
	-- },

	["F-86F Sabre"] = {
		HumanRadio = {
			frequency 		= 251.0,
			editable 		= true,
			minFrequency	= 225.000,
			maxFrequency 	= 269.000,
			modulation 		= MODULATION_AM
		},

		panelRadio = {
			[1] = {
				name = _("radio?"),
				range = {
					{min = 225.0, max = 269.0}
				},
				channels = {  -- matches L-39C except for channel 8, which was changed to a Georgian airport and #20 which is NTTR only (for now).  This radio goes 1-20 not 0-19.
					[1] = { name = _("Channel 1"),		default = 264.0, modulation = _("AM"), connect = true}, -- mineralnye-vody (URMM) : 264.0
					[2] = { name = _("Channel 2"),		default = 265.0, modulation = _("AM")},	-- nalchik (URMN) : 265.0
					[3] = { name = _("Channel 3"),		default = 256.0, modulation = _("AM")},	-- sochi-adler (URSS) : 256.0
					[4] = { name = _("Channel 4"),		default = 254.0, modulation = _("AM")},	-- maykop-khanskaya (URKH), nellis (KLSV) : 254.0
					[5] = { name = _("Channel 5"),		default = 250.0, modulation = _("AM")},	-- anapa (URKA) : 250.0
					[6] = { name = _("Channel 6"),		default = 270.0, modulation = _("AM")},	-- beslan (URMO) : 270.0
					[7] = { name = _("Channel 7"),		default = 257.0, modulation = _("AM")},	-- krasnodar-pashkovsky (URKK) : 257.0
					[8] = { name = _("Channel 8"),		default = 258.0, modulation = _("AM")},	-- sukhumi-babushara (UGSS) : 255.0
					[9] = { name = _("Channel 9"),		default = 262.0, modulation = _("AM")},	-- kobuleti (UG5X) : 262.0
					[10] = { name = _("Channel 10"),	default = 259.0, modulation = _("AM")},	-- gudauta (UG23) : 259.0
					[11] = { name = _("Channel 11"),	default = 268.0, modulation = _("AM")},	-- tbilisi-soganlug (UG24) : 268.0
					[12] = { name = _("Channel 12"),	default = 269.0, modulation = _("AM")},	-- tbilisi-vaziani (UG27) : 269.0
					[13] = { name = _("Channel 13"),	default = 260.0, modulation = _("AM")},	-- batumi (UGSB) : 260.0
					[14] = { name = _("Channel 14"),	default = 263.0, modulation = _("AM")},	-- kutaisi-kopitnari (UGKO) : 263.0
					[15] = { name = _("Channel 15"),	default = 261.0, modulation = _("AM")},	-- senaki-kolkhi (UGKS) :  261.0
					[16] = { name = _("Channel 16"),	default = 267.0, modulation = _("AM")},	-- tbilisi-lochini (UGTB) : 267.0
					[17] = { name = _("Channel 17"),	default = 251.0, modulation = _("AM")},	-- krasnodar-center (URKI), creech (KINS) : 251.0
					[18] = { name = _("Channel 18"),	default = 253.0, modulation = _("AM")},	-- krymsk (URKW), mccarran (KLAS) : 253.0
				},
			},
		},
	},



	["F-15ESE"] = {
		radio = {			
			[1] = {						--radio 1 AN/ARC-164
				UHF = {
					min = 225,				--minimum radio frequency in mHz 
					max = 399,				--maxium  radio frequency in mHz
				},
				nbCanal = 20,
				name = "UHF Radio 1",
			},
			[2] = {						--radio 2 AN/ARC-222
				LVHF = {
					min = 30,				--minimum radio frequency in mHz 
					max = 87,				--maxium  radio frequency in mHz
				},
				-- VHF = { 
				-- 	{min = 108.0, max = 115.975},				--minimum radio frequency in mHz   
				-- 	{min = 118.0, max = 173.975},				--maxium  radio frequency in mHz
				-- },
				VHF = {
					min = 118,				--minimum radio frequency in mHz   
					max = 173,				--maxium  radio frequency in mHz
				},
				UHF = {
					min = 225,				--minimum radio frequency in mHz 
					max = 399,				--maxium  radio frequency in mHz
				},
				nbCanal = 20,
				name = "V/UHF Radio 2",
			},
		},
	},
	["F-16C_50"] = {
		radio = {			
			[1] = {						--radio 1 AN/ARC-164
				UHF = {
					min = 225,				--minimum radio frequency in mHz 
					max = 399.975,				--maxium  radio frequency in mHz
				},
				nbCanal = 20,
				-- range = {
				-- 	{min = 225.0, max = 399.975, modulation	= MODULATION_AM}
				-- },
			},
			[2] = {						--radio 2 AN/ARC-222
				LVHF = {
					min = 30,				--minimum radio frequency in mHz 
					max = 87.975,				--maxium  radio frequency in mHz
				},
				VHF = {
					min = 116,				--minimum radio frequency in mHz   
					max = 155.975,				--maxium  radio frequency in mHz
				},
				nbCanal = 20,
				-- range = {
				-- 	{min =  30.0, max =  87.975, modulation	= MODULATION_FM},	-- FM
				-- 	{min = 116.0, max = 155.975, modulation	= MODULATION_AM}	-- AM
				-- },
			},
		},
	},



	["UH-1H"] = {

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


	["SA342"] = {
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

	["Hercules"] = {
		-- prefFreqPackage = {
		-- 	nRadio = 2,
		-- 	range = "VHF",
		-- 	},
		radio = {						--range of radio frequencies of player aircraft
			[1] = {						--radio 1
				UHF = {
					min = 225,				--minimum radio frequency in mHz
					max = 399.975,				--maxium  radio frequency in mHz
				},
				nbCanal = 20,
				name = "UHF AN/ARC-164",
			},
			[2] = {						--radio 2
				LVHF = {
					min = 30,				--minimum radio frequency in mHz
					max = 87.975,				--maxium  radio frequency in mHz
				},
				nbCanal = 0,
				name = "FM1",
			},
			[3] = {						--radio 3
				VHF = {
					min = 108,				--minimum radio frequency in mHz
					max = 155.975,				--maxium  radio frequency in mHz
				},
				nbCanal = 0,
				name = "VHF Radio",
			},
		},
	},


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

	["MiG-29 Fulcrum"] = {
		radio = {
			[1] = {
				VHF = {
					min = 100,
					max = 149.975,
				},
				UHF = {
					min = 220,
					max = 399.975,
				},
				nbCanal = 20,
				name = "VHF/UHF R-862"
			},
			[2] = {
				HF = {
					min = 0.150,
					max = 1.2995,
				},
				nbCanal = 8,
				name = "ARK-19",
			},
		},
	},
	["MiG-29A"] = {
		radio = {
			[1] = {
				VHF = {
					min = 100,
					max = 224.995,
				},
				UHF = {
					min = 225,
					max = 399.98,
				},
				nbCanal = 0,
				FC3 = true,
				FC3Frequency = 124,
			},
		},	
	},
	["MiG-29S"] = {
		radio = {						--range of radio frequencies of player aircraft
			[1] = {
				VHF = {
					min = 100,
					max = 224.995,
				},
				UHF = {
					min = 225,
					max = 399.98,
				},
				nbCanal = 0,
				FC3 = true,
				FC3Frequency = 124,
			},
		},	
	},
	["JF-17"] = {
		radio = {			
			[1] = {						--radio 1
				LVHF = {
					min = 30,				--minimum radio frequency in mHz 
					max = 100,				--maxium  radio frequency in mHz
				},
				VHF = {
					min = 101,				--minimum radio frequency in mHz 
					max = 224,				--maxium  radio frequency in mHz
				},
				UHF = {
					min = 225,				--minimum radio frequency in mHz  
					max = 399,				--maxium  radio frequency in mHz
				},
				nbCanal = 20,
			},
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
		
		radio = {						--range of radio frequencies of player aircraft
			[1] = {						--radio 1
				LVHF = {
					min = 20,				--minimum radio frequency in mHz
					max = 59,				--maxium  radio frequency in mHz
				},
				nbCanal = 10,
			},
			[2] = {						--radio 2 simule la frequence FC3 de DCS
				VHF = {
					min = 100,				--minimum radio frequency in mHz
					max = 224,				--maxium  radio frequency in mHz
				},
				UHF = {
					min = 225,				--minimum radio frequency in mHz
					max = 399,				--maxium  radio frequency in mHz
				},
				nbCanal = 0,
			},
			-- [2] = {						--radio 2
				-- min = 0.215,				--minimum radio frequency in mHz
				-- max = 1.065,				--maxium  radio frequency in mHz
				-- nbCanal = 16,
			-- },
		},
	},
	["Ka-50_3"] = {
		
		radio = {						--range of radio frequencies of player aircraft
			[1] = {						--radio 1
				LVHF = {
					min = 20,				--minimum radio frequency in mHz
					max = 59,				--maxium  radio frequency in mHz
				},
				nbCanal = 10,
			},
			[2] = {						--radio 2 simule la frequence FC3 de DCS
				VHF = {
					min = 100,				--minimum radio frequency in mHz
					max = 224,				--maxium  radio frequency in mHz
				},
				UHF = {
					min = 225,				--minimum radio frequency in mHz
					max = 399,				--maxium  radio frequency in mHz
				},
				nbCanal = 0,
			},
			-- [2] = {						--radio 2
				-- min = 0.215,				--minimum radio frequency in mHz
				-- max = 1.065,				--maxium  radio frequency in mHz
				-- nbCanal = 16,
			-- },
		},
	},
	["P-51D-30-NA"] = {
		radio = {							
			[1] = {						--radio  SCR 522 A VHF RADIO
				VHF = {
					min = 100,				--minimum radio frequency in mHz
					max = 156,				--maxium  radio frequency in mHz
				},
				nbCanal = 4,
			},
		},
	},
	["P-47D-30"] = {
		radio = {									
			[1] = {						--radio SCR 522 A VHF RADIO
				VHF = {
					min = 100,				--minimum radio frequency in mHz
					max = 156,				--maxium  radio frequency in mHz
				},
				nbCanal = 4,
			},
		},
	},
	["SpitfireLFMkIX"] = {
		radio = {									
			[1] = {						--radio A R I 1063 type HF
				VHF = {
					min = 100,				--minimum radio frequency in mHz
					max = 156,				--maxium  radio frequency in mHz
				},
				nbCanal = 4,
			},
		},
	},
	
	["MosquitoFBMkVI"] = {
		radio = {									
			[1] = {						--radio VHF
				VHF = {
					min = 100,				--minimum radio frequency in mHz
					max = 156,				--maxium  radio frequency in mHz
				},
				nbCanal = 4,
				name = "SCR-522 (TR1143) VHF"
			},
			[2] = {						--radio HF
				HF = {
					min = 5.5,				--minimum radio frequency in mHz
					max = 10,				--maxium  radio frequency in mHz
				},
				nbCanal = 8,
				name = "HF Blue Range"
			},
			[3] = {						--radio HF
				HF = {
					min = 3,				--minimum radio frequency in mHz
					max = 5.4,				--maxium  radio frequency in mHz
				},
				nbCanal = 8,
				name = "HF Red Range"
			},
			[4] = {						--radio MF
				MF = {
					min = 0.200,				--minimum radio frequency in mHz
					max = 0.500,				--maxium  radio frequency in mHz
				},
				nbCanal = 8,
				name = "MF Yellow Range"
			},
		},
	},
	["Bf-109K-4"] = {
		radio = {									
			[1] = {						--radio 4 is equipped with a FUG 16ZY radio transmitter and receiver.
				LVHF = {
					min = 38.4,				--minimum radio frequency in mHz
					max = 42.4,				--maxium  radio frequency in mHz
				},
				nbCanal = 4,
			},
		},
	},
}	