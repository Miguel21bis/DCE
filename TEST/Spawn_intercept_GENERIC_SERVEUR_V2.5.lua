-- Spawn intercept script GENERIC V2.5
-- v 2.56b
-- by GC22 "Psyko"
--------------------------------------------------------------------------------------

-- DO NOT EDIT THE SCRIPT!!!

-- To use this script :
-- 1) create three zone strictly named "COMBAT ZONE 1/2/3" with the mission editor,
-- 2) launch the script with the trigger "execute script file"
-- 3) in game, the submenus will pop in "F-10/Others".
-- 4) Set-up the ennemi flight with a zone, aircraft type, armament and direction (or launch a radom chosen). Choose also the number of bogey.
-- 6) Launch the selected flight with "launch selected". The data will be stored and you can just modify either you want for re-launch.
-- 5)  altitude is choosen randomly between 8000ft AGL and 32000ft AGL

--------------------------------------------------------------------------------------

	PosTabl = 								--table for spawn points
	{
		[1] =		--North
		{
			["x1"] = 125000,
			["z1"] = 0,
			["x2"] = 62500,
			["z2"] = 0,
			["DirName"] = "north",
		},
		[2] =		--Noth-East
		{
			["x1"] = 90000,
			["z1"] = 90000,
			["x2"] = 45000,
			["z2"] = 45000,
			["DirName"] = "north-east",
		},
		[3] =		--East
		{
			["x1"] = 0,
			["z1"] = 125000,
			["x2"] = 0,
			["z2"] = 62500,
			["DirName"] = "east",
		},
		[4] =		--SE
		{
			["x1"] = -90000,
			["z1"] = 90000,
			["x2"] = -45000,
			["z2"] = 45000,
			["DirName"] = "south-east",
		},
		[5] =		--South
		{
			["x1"] = -125000,
			["z1"] = 0,
			["x2"] = -62500,
			["z2"] = 0,
			["DirName"] = "south",
		},
		[6] =		--South-West
		{
			["x1"] = -90000,
			["z1"] = -90000,
			["x2"] = -45000,
			["z2"] = -45000,
			["DirName"] = "south-west",
		},
		[7] =		--West
		{
			["x1"] = 0,
			["z1"] = -125000,
			["x2"] = 0,
			["z2"] = -62500,
			["DirName"] = "west",
		},
		[8] =		--North-West
		{
			["x1"] = 90000,
			["z1"] = -90000,
			["x2"] = 45000,
			["z2"] = -45000,
			["DirName"] = "north-west",
		},
	}

--------------------------------------------------------------------------------------
	CZTbl =
	{
		[1] = {
			["Long"] = 0,
			["Lat"] = 0,
		},

		[2] = {
			["Long"] = 0,
			["Lat"] = 0,
		},

		[3] = {
			["Long"] = 0,
			["Lat"] = 0,
		},
	}

--------------------------------------------------------------------------------------

	VarTbl =				--stock the flight characteristics
	{
		["Zone"] = 0,		--Zone value
		["Direct"] = 0,		--Direction value
		["Plane"] = 0,		--Plane value
		["Arma"] = 0,		--Armament value
		["QtyP"] = 0,		--Plane quantity value
	}

--------------------------------------------------------------------------------------
	ArmTbl =		--table for Armament name
	{
		[1] = "FOX 1",
		[2] = "FOX 2",
		[3] = "FOX 3",
		[4] = "GUNS only",
		[5] = "Random",
	}
--------------------------------------------------------------------------------------
	EniTbl =
	{}
--------------------------------------------------------------------------------------
	PlaneTbl =		--table to set PlaneType and LiveryType
	{
		[1] =
		{
			["PlaneType"] = "MiG-23MLD",
			["LiveryType"] = "af standard-1",
		},
		[2] =
		{
			["PlaneType"] = "MiG-31",
			["LiveryType"] = "af standard",
		},
		[3] =
		{
			["PlaneType"] = "F-4E",
			["LiveryType"] = "IRIAF Asia Minor",
		},
		[4] =
		{
			["PlaneType"] = "Su-27",
			["LiveryType"] = "Air Force Standard",
		},
		[5] =
		{
			["PlaneType"] = "MiG-21Bis",
			["LiveryType"] = "",
		},
		[6] =
		{
			["PlaneType"] = "MiG-29S",
			["LiveryType"] = "KazAADF new (fictional digital)",
		},
		[7] =
		{
			["PlaneType"] = "J-11A",
			["LiveryType"] = "PLAAF OPFOR 'Desert' (Fictional)",
		},
		[8] =
		{
			["PlaneType"] = "F-15C",
			["LiveryType"] = "65th Aggressor SQN (WA) Flanker",
		},
	}		--end of PlaneTbl

--------------------------------------------------------------------------------------

	ConfTBL =		--table for the aircraft's payload
	{
		[1] =		--MiG-23
		{
			[1] = 		--FOX1
			{
				[2] =
				{
					["CLSID"] = "{CCF898C9-5BC7-49A4-9D1E-C3ED3D5166A1}",
				}, -- end of [2]
				[3] =
				{
					["CLSID"] = "{B0DBC591-0F52-4F7D-AD7B-51E67725FB81}",
				}, -- end of [3]
				[4] =
				{
					["CLSID"] = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
				}, -- end of [4]
				[5] =
				{
					["CLSID"] = "{275A2855-4A79-4B2D-B082-91EA2ADF4691}",
				}, -- end of [5]
				[6] =
				{
					["CLSID"] = "{CCF898C9-5BC7-49A4-9D1E-C3ED3D5166A1}",
				}, -- end of [6]
			}, -- end of ["FOX1"]

			[2] =		--FOX2
			{
				[3] =
				{
					["CLSID"] = "{B0DBC591-0F52-4F7D-AD7B-51E67725FB81}",
				}, -- end of [3]
				[4] =
				{
					["CLSID"] = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
				}, -- end of [4]
				[5] =
				{
					["CLSID"] = "{275A2855-4A79-4B2D-B082-91EA2ADF4691}",
				}, -- end of [5]
			},
			[3] =		--FOX3
			{
			},
			[4] =		--GUNS only
			{
				[4] =
				{
					["CLSID"] = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
				}, -- end of [4]
			},		--end of GUNS only
			[5] = 3800,		--fuel
			[6] = 60,		--flares
			[7] = 60,		--chaffs
			[8] = 100,		--gun
		}, -- end of MiG-23MLD

		[2] =		--MiG-31
		{
			[1] =		--FOX1
			{
				[1] =
				{
					["CLSID"] = "{4EDBA993-2E34-444C-95FB-549300BF7CAF}",
				}, -- end of [1]
				[2] =
				{
					["CLSID"] = "{F1243568-8EF0-49D4-9CB5-4DA90D92BC1D}",
				}, -- end of [2]
				[3] =
				{
					["CLSID"] = "{F1243568-8EF0-49D4-9CB5-4DA90D92BC1D}",
				}, -- end of [3]
				[4] =
				{
					["CLSID"] = "{F1243568-8EF0-49D4-9CB5-4DA90D92BC1D}",
				}, -- end of [4]
				[5] =
				{
					["CLSID"] = "{F1243568-8EF0-49D4-9CB5-4DA90D92BC1D}",
				}, -- end of [5]
				[6] =
				{
					["CLSID"] = "{4EDBA993-2E34-444C-95FB-549300BF7CAF}",
				}, -- end of [6]
			},		--end of FOX1
			[2] =		--FOX2
			{
				[1] =
				{
					["CLSID"] = "{5F26DBC2-FB43-4153-92DE-6BBCE26CB0FF}",
				}, -- end of [1]
				[6] =
				{
					["CLSID"] = "{5F26DBC2-FB43-4153-92DE-6BBCE26CB0FF}",
				}, -- end of [6]
			},		--end of FOX2
			[3] =		--FOX3
			{
			},
			[4] =		--GUNS only
			{
			},
			[5] = 15500,		--fuel
			[6] = 0,		--flares
			[7] = 0,		--chaffs
			[8] = 100,		--gun
		}, -- end of MiG-31

		[3] =		--F-4E
		{
			[1] =		--FOX1
			{
				[1] =
				{
					["CLSID"] = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
				}, -- end of [1]
				[2] =
				{
					["CLSID"] = "{9DDF5297-94B9-42FC-A45E-6E316121CD85}",
				}, -- end of [2]
				[3] =
				{
					["CLSID"] = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
				}, -- end of [3]
				[4] =
				{
					["CLSID"] = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
				}, -- end of [4]
				[6] =
				{
					["CLSID"] = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
				}, -- end of [6]
				[7] =
				{
					["CLSID"] = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
				}, -- end of [7]
				[8] =
				{
					["CLSID"] = "{9DDF5297-94B9-42FC-A45E-6E316121CD85}",
				}, -- end of [8]
				[9] =
				{
					["CLSID"] = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
				}, -- end of [9]
			},
			[2] =		--FOX2
			{
				[8] =
				{
					["CLSID"] = "{773675AB-7C29-422f-AFD8-32844A7B7F17}",
				}, -- end of [8]
				[2] =
				{
					["CLSID"] = "{773675AB-7C29-422f-AFD8-32844A7B7F17}",
				}, -- end of [2]
				[5] =
				{
					["CLSID"] = "{8B9E3FD0-F034-4A07-B6CE-C269884CC71B}",
				}, -- end of [5]
			},
			[3] =		--FOX3
			{
			},
			[4] =		--GUNS only
			{
				[5] =
				{
					["CLSID"] = "{8B9E3FD0-F034-4A07-B6CE-C269884CC71B}",
				}, -- end of [5]
			},
			[5] = 4864,		--fuel
			[6] = 30,		--flares
			[7] = 60,		--chaffs
			[8] = 100,		--gun
		}, -- end of F-4E

		[4] =		--Su-27
		{
			[1] =		--FOX1
			{
				[1] =
				{
					["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
				}, -- end of [1]
				[3] =
				{
					["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
				}, -- end of [3]
				[5] =
				{
					["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
				}, -- end of [5]
				[6] =
				{
					["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
				}, -- end of [6]
				[8] =
				{
					["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
				}, -- end of [8]
				[10] =
				{
					["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
				}, -- end of [10]
			},
			[2] =		--FOX2
			{
				[3] =
				{
					["CLSID"] = "{88DAC840-9F75-4531-8689-B46E64E42E53}",
				}, -- end of [3]
				[2] =
				{
					["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
				}, -- end of [2]
				[9] =
				{
					["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
				}, -- end of [9]
				[8] =
				{
					["CLSID"] = "{88DAC840-9F75-4531-8689-B46E64E42E53}",
				}, -- end of [8]
			},
			[3] =		--FOX3
			{
			},
			[4] =		--GUNS only
			{
				[1] =
				{
					["CLSID"] = "{44EE8698-89F9-48EE-AF36-5FD31896A82F}",
				}, -- end of [1]
				[10] =
				{
					["CLSID"] = "{44EE8698-89F9-48EE-AF36-5FD31896A82A}",
				}, -- end of [10]
			},
			[5] = 3000,		--fuel
			[6] = 00,		--flares
			[7] = 00,		--chaffs
			[8] = 000,		--gun
		}, -- end of Su-27

		[5] =		--MiG-21
		{
			[1] =		--FOX1
			{
				[1] =
				{
					["CLSID"] = "{R-3R}",
				}, -- end of [1]
				[2] =
				{
					["CLSID"] = "{R-3R}",
				}, -- end of [2]
				[3] =
				{
					["CLSID"] = "{PTB_800_MIG21}",
				}, -- end of [3]
				[4] =
				{
					["CLSID"] = "{R-3R}",
				}, -- end of [4]
				[5] =
				{
					["CLSID"] = "{R-3R}",
				}, -- end of [5]
				[6] =
				{
					["CLSID"] = "{ASO-2}",
				}, -- end of [6]
			},
			[2] =		--FOX2
			{
				[1] =
				{
					["CLSID"] = "{R-60M}",
				}, -- end of [1]
				[2] =
				{
					["CLSID"] = "{R-13M}",
				}, -- end of [2]
				[3] =
				{
					["CLSID"] = "{PTB_800_MIG21}",
				}, -- end of [3]
				[4] =
				{
					["CLSID"] = "{R-13M}",
				}, -- end of [4]
				[5] =
				{
					["CLSID"] = "{R-60M}",
				}, -- end of [5]
				[6] =
				{
					["CLSID"] = "{ASO-2}",
				}, -- end of [6]
			},
			[3] =		--FOX3
			{
			},
			[4] =		--GUNS only
			{
				[6] =
				{
					["CLSID"] = "{ASO-2}",
				}, -- end of [6]
				[3] =
				{
					["CLSID"] = "{PTB_800_MIG21}",
				}, -- end of [3]
			},
			[5] = 3000,		--fuel
			[6] = 00,		--flares
			[7] = 00,		--chaffs
			[8] = 00,		--gun
		}, -- end of MiG-21

		[6] =		--MiG-29
		{
			[1] =		--FOX1
			{
				[1] =
				{
					["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
				}, -- end of [1]
				[2] =
				{
					["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
				}, -- end of [2]
				[3] =
				{
					["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
				}, -- end of [3]
				[4] =
				{
					["CLSID"] = "{2BEC576B-CDF5-4B7F-961F-B0FA4312B841}",
				}, -- end of [4]
				[5] =
				{
					["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
				}, -- end of [5]
				[6] =
				{
					["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
				}, -- end of [6]
				[7] =
				{
					["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
				}, -- end of [7]
			}, -- end of FOX1
			[2] =		--FOX2
			{
				[1] =
				{
					["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
				}, -- end of [1]
				[2] =
				{
					["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
				}, -- end of [2]
				[3] =
				{
					["CLSID"] = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}",
				}, -- end of [3]
				[4] =
				{
					["CLSID"] = "{2BEC576B-CDF5-4B7F-961F-B0FA4312B841}",
				}, -- end of [4]
				[5] =
				{
					["CLSID"] = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}",
				}, -- end of [5]
				[6] =
				{
					["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
				}, -- end of [6]
				[7] =
				{
					["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
				}, -- end of [7]
			},
			[3] =		--FOX3
			{
				[1] =
				{
					["CLSID"] = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
				}, -- end of [1]
				[2] =
				{
					["CLSID"] = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
				}, -- end of [2]
				[3] =
				{
					["CLSID"] = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
				}, -- end of [3]
				[4] =
				{
					["CLSID"] = "{2BEC576B-CDF5-4B7F-961F-B0FA4312B841}",
				}, -- end of [4]
				[5] =
				{
					["CLSID"] = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
				}, -- end of [5]
				[6] =
				{
					["CLSID"] = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
				}, -- end of [6]
				[7] =
				{
					["CLSID"] = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
				}, -- end of [7]
			}, -- end FOX3,
			[4] =		--GUNS only
			{
				[4] =
				{
					["CLSID"] = "{2BEC576B-CDF5-4B7F-961F-B0FA4312B841}",
				}, -- end of [4]
			},		--end of GUNS only
			[5] = 3493,		--fuel
			[6] = 30,		--flares
			[7] = 30,		--chaffs
			[8] = 100,		--gun
		}, --end of MiG-29

		[7] =		--Su-35(J-11A)
		{
			[1] =		--FOX1
			{
				[1] =
				{
					["CLSID"] = "{RKL609_L}",
				}, -- end of [1]
				[2] =
				{
					["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
				}, -- end of [2]
				[3] =
				{
					["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
				}, -- end of [3]
				[4] =
				{
					["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
				}, -- end of [4]
				[5] =
				{
					["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
				}, -- end of [5]
				[6] =
				{
					["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
				}, -- end of [6]
				[7] =
				{
					["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
				}, -- end of [7]
				[8] =
				{
					["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
				}, -- end of [8]
				[9] =
				{
					["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
				}, -- end of [9]
				[10] =
				{
					["CLSID"] = "{RKL609_R}",
				}, -- end of [10]
			}, -- end of FOX1
			[2] =		--FOX2
			{
				[1] =
				{
					["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
				}, -- end of [1]
				[2] =
				{
					["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
				}, -- end of [2]
				[8] =
				{
					["CLSID"] = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}",
				}, -- end of [8]
				[10] =
				{
					["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
				}, -- end of [10]
				[9] =
				{
					["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
				}, -- end of [9]
				[3] =
				{
					["CLSID"] = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}",
				}, -- end of [3]
			},		--end of FOX2
			[3] =		--FOX3
			{
				[1] =
				{
					["CLSID"] = "{RKL609_L}",
				}, -- end of [1]
				[2] =
				{
					["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
				}, -- end of [2]
				[3] =
				{
					["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
				}, -- end of [3]
				[4] =
				{
					["CLSID"] = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
				}, -- end of [4]
				[5] =
				{
					["CLSID"] = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
				}, -- end of [5]
				[6] =
				{
					["CLSID"] = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
				}, -- end of [6]
				[7] =
				{
					["CLSID"] = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
				}, -- end of [7]
				[8] =
				{
					["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
				}, -- end of [8]
				[9] =
				{
					["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
				}, -- end of [9]
				[10] =
				{
					["CLSID"] = "{RKL609_R}",
				}, -- end of [10]
			}, -- end of FOX3
			[4] =		--GUNS only
			{
				[1] =
				{
					["CLSID"] = "{RKL609_L}",
				}, -- end of [1]
				[10] =
				{
					["CLSID"] = "{RKL609_R}",
				}, -- end of [10]
			},		--end of GUNS only
			[5] = 9400,		--fuel
			[6] = 96,		--flares
			[7] = 96,		--chaffs
			[8] = 100,		--gun
		}, --end of Su-35(J-11A)

		[8] =		--F-15C
		{
			[1] =		--FOX1
			{
				[1] =
				{
					["CLSID"] = "{AIM-9P5}",
				}, -- end of [1]
				[2] =
				{
					["CLSID"] = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
				}, -- end of [2]
				[4] =
				{
					["CLSID"] = "{AIM-7H}",
				}, -- end of [4]
				[5] =
				{
					["CLSID"] = "{AIM-7H}",
				}, -- end of [5]
				[7] =
				{
					["CLSID"] = "{AIM-7H}",
				}, -- end of [7]
				[8] =
				{
					["CLSID"] = "{AIM-7H}",
				}, -- end of [8]
				[11] =
				{
					["CLSID"] = "{AIM-9P5}",
				}, -- end of [11]
				[10] =
				{
					["CLSID"] = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
				}, -- end of [10]
			},
			[2] =		--FOX2
			{
				[1] =
				{
					["CLSID"] = "{AIM-9P5}",
				}, -- end of [1]
				[11] =
				{
					["CLSID"] = "{AIM-9P5}",
				}, -- end of [11]
				[6] =
				{
					["CLSID"] = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
				}, -- end of [6]
				[9] =
				{
					["CLSID"] = "{AIM-9P5}",
				}, -- end of [9]
				[3] =
				{
					["CLSID"] = "{AIM-9P5}",
				}, -- end of [3]
			},
			[3] =		--FOX3
			{
				[1] =
				{
					["CLSID"] = "{AIM-9P5}",
				}, -- end of [1]
				[2] =
				{
					["CLSID"] = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
				}, -- end of [2]
				[3] =
				{
					["CLSID"] = "{C8E06185-7CD6-4C90-959F-044679E90751}",
				}, -- end of [3]
				[5] =
				{
					["CLSID"] = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
				}, -- end of [5]
				[7] =
				{
					["CLSID"] = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
				}, -- end of [7]
				[11] =
				{
					["CLSID"] = "{AIM-9P5}",
				}, -- end of [11]
				[10] =
				{
					["CLSID"] = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
				}, -- end of [10]
				[9] =
				{
					["CLSID"] = "{C8E06185-7CD6-4C90-959F-044679E90751}",
				}, -- end of [9]
			},
			[4] =		--GUNS only
			{
				[6] =
				{
					["CLSID"] = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
				}, -- end of [6]
				[11] =
				{
					["CLSID"] = "{AIS_ASQ_T50}",
				}, -- end of [11]
			},
			[5] = 6103,		--fuel
			[6] = 60,		--flares
			[7] = 120,		--chaffs
			[8] = 100,		--gun
		}, -- end of F-15C
	} --end of ConfTBL

--------------------------------------------------------------------------------------

function LaunchFlt(FuncTime)				--function that launch the flight

	trigger.action.outText("** Building the flight... **", 5, 0)

	FuncTime = timer.getTime()
	if FuncTime > 10 then

		if print(VarTbl["Zone"]) == 0 or print(VarTbl["Direct"]) == 0 or print(VarTbl["Plane"]) == 0 or print(VarTbl["Arma"]) == 0 or print(VarTbl["QtyP"]) == 0 then
			trigger.action.outText("** The flight is not fully configured!!! **", 5, 0)

		elseif print(VarTbl["Zone"]) ~= 0 and print(VarTbl["Direct"]) ~= 0 and print(VarTbl["Plane"]) ~= 0 and print(VarTbl["Arma"]) ~= 0 and print(VarTbl["QtyP"]) ~= 0 then
			trigger.action.outText("** Flight is cooked... **", 5, 0)

				local FltNbr = math.random(1,999)
				local EniFlt =
						{
							["task"] = "CAP",
							["uncontrolled"] = false,
							["taskSelected"] = true,
							["name"] = "CAP "..tostring(FltNbr).."",
							["route"] =
							{
								["points"] =
								{
									[1] =
									{
										["alt"] = AltDep,
										["action"] = "Turning Point",
										["alt_type"] = "BARO",
										["properties"] =
										{
											["addopt"] =
											{
											}, -- end of ["addopt"]
										}, -- end of ["properties"]
										["speed"] = 179.86111111111,
										["task"] =
										{
											["id"] = "ComboTask",
											["params"] =
											{
												["tasks"] =
												{
													[1] =
													{
														["number"] = 1,
														["key"] = "CAP",
														["id"] = "EngageTargets",
														["enabled"] = true,
														["auto"] = true,
														["params"] =
														{
															["targetTypes"] =
															{
																[1] = "Air",
															}, -- end of ["targetTypes"]
															["priority"] = 0,
														}, -- end of ["params"]
													}, -- end of [1]
													[2] =
													{
														["number"] = 2,
														["auto"] = false,
														["id"] = "WrappedAction",
														["enabled"] = true,
														["params"] =
														{
															["action"] =
															{
																["id"] = "Option",
																["params"] =
																{
																	["value"] = true,
																	["name"] = 17,
																}, -- end of ["params"]
															}, -- end of ["action"]
														}, -- end of ["params"]
													}, -- end of [2]
													[3] =
													{
														["number"] = 3,
														["auto"] = true,
														["id"] = "WrappedAction",
														["enabled"] = true,
														["params"] =
														{
															["action"] =
															{
																["id"] = "Option",
																["params"] =
																{
																	["value"] = 4,
																	["name"] = 18,
																}, -- end of ["params"]
															}, -- end of ["action"]
														}, -- end of ["params"]
													}, -- end of [3]
													[4] =
													{
														["number"] = 4,
														["auto"] = true,
														["id"] = "WrappedAction",
														["enabled"] = true,
														["params"] =
														{
															["action"] =
															{
																["id"] = "Option",
																["params"] =
																{
																	["value"] = true,
																	["name"] = 19,
																}, -- end of ["params"]
															}, -- end of ["action"]
														}, -- end of ["params"]
													}, -- end of [4]
													[5] =
													{
														["number"] = 2,
														["auto"] = false,
														["id"] = "ControlledTask",
														["enabled"] = true,
														["params"] =
														{
															["task"] =
															{
																["id"] = "EngageTargets",
																["params"] =
																{
																	["targetTypes"] =
																	{
																		[1] = "Planes",
																	}, -- end of ["targetTypes"]
																	["noTargetTypes"] =
																	{
																		[1] = "Helicopters",
																		[2] = "Cruise missiles",
																		[3] = "Antiship Missiles",
																		[4] = "AA Missiles",
																		[5] = "AG Missiles",
																		[6] = "SA Missiles",
																	}, -- end of ["noTargetTypes"]
																	["value"] = "Planes;",
																	["priority"] = 0,
																	["maxDistEnabled"] = true,
																	["maxDist"] = 74000,
																}, -- end of ["params"]
															}, -- end of ["task"]
															["condition"] =
															{
																["probability"] = 100,
															}, -- end of ["condition"]
														}, -- end of ["params"]
													}, -- end of [5]
												}, -- end of ["tasks"]
											}, -- end of ["params"]
										}, -- end of ["task"]
										["type"] = "Turning Point",
										["ETA"] = 86400,
										["ETA_locked"] = true,
										["y"] = CZTbl[1]["Lat"],
										["x"] = CZTbl[1]["Long"],
										["formation_template"] = "",
										["speed_locked"] = true,
									}, -- end of [1]
									[2] =
									{
										["alt"] = AltDep,
										["action"] = "Turning Point",
										["alt_type"] = "BARO",
										["properties"] =
										{
											["addopt"] =
											{
											}, -- end of ["addopt"]
										}, -- end of ["properties"]
										["speed"] = 179.86111111111,
										["task"] =
										{
											["id"] = "ComboTask",
											["params"] =
											{
												["tasks"] =
												{
												}, -- end of ["tasks"]
											}, -- end of ["params"]
										}, -- end of ["task"]
										["type"] = "Turning Point",
										["ETA"] = 86653.367522944,
										["ETA_locked"] = false,
										["y"] = CZTbl[2]["Lat"],
										["x"] = CZTbl[2]["Long"],
										["formation_template"] = "",
										["speed_locked"] = true,
									}, -- end of [2]
									[3] =
									{
										["alt"] = AltDep,
										["action"] = "Turning Point",
										["alt_type"] = "RADIO",
										["properties"] =
										{
											["addopt"] =
											{
											}, -- end of ["addopt"]
										}, -- end of ["properties"]
										["speed"] = 179.86111111111,
										["task"] =
										{
											["id"] = "ComboTask",
											["params"] =
											{
												["tasks"] =
												{
													[1] =
													{
														["enabled"] = true,
														["auto"] = false,
														["id"] = "ControlledTask",
														["number"] = 1,
														["params"] =
														{
															["condition"] =
															{
																["probability"] = 100,
															}, -- end of ["condition"]
															["task"] =
															{
																["id"] = "Orbit",
																["params"] =
																{
																	["altitude"] = AltDep,
																	["pattern"] = "Circle",
																	["speed"] = 160.88888888889,
																}, -- end of ["params"]
															}, -- end of ["task"]
															["stopCondition"] =
															{
																["duration"] = 900,
															}, -- end of ["stopCondition"]
														}, -- end of ["params"]
													}, -- end of [1]
												}, -- end of ["tasks"]
											}, -- end of ["params"]
										}, -- end of ["task"]
										["type"] = "Turning Point",
										["ETA"] = 86653.367522944,
										["ETA_locked"] = false,
										["y"] = CZTbl[3]["Lat"],
										["x"] = CZTbl[3]["Long"],
										["formation_template"] = "",
										["speed_locked"] = true,
									}, -- end of [3]
								}, -- end of ["points"]
							}, -- end of ["route"]
							["hidden"] = false,
							["units"] =
							{
								EniTbl[1],
								EniTbl[2],
								EniTbl[3],
								EniTbl[4],

							}, -- end of ["units"]
							["y"] = CZTbl[1]["Long"],
							["x"] = CZTbl[1]["Long"],
							["communication"] = true,
							["start_time"] = 0,
							["frequency"] = 127.5,
						} -- end of EniFlt
			coalition.addGroup(FlightCnty, Group.Category.AIRPLANE, EniFlt)
			trigger.action.outText("** Flight N° "..tostring(FltNbr).." is baked, fight on!!! **", 10, 0)
		end
	end
end

--------------------------------------------------------------------------------------

function ZoneSel(val)			--Zone selection function
	ZonVal = val.Zone

	if ZonVal == 1 then
		trigger.action.outText("** Zone 1 selected **", 10, 0)
	elseif ZonVal == 2 then
		trigger.action.outText("** Zone 2 selected **", 10, 0)
	elseif ZonVal == 3 then
		trigger.action.outText("** Zone 3 selected **", 10, 0)
	end
	VarTbl["Zone"] = tonumber(ZonVal)

	missionCommands.removeItem({"**Config Flight TempMenu**"})
	local subTemp = missionCommands.addSubMenu("**Config Flight TempMenu**")

	local subDir1 = missionCommands.addCommand("From North", subTemp, DirSel, {Dir=1})
	local subDir2 = missionCommands.addCommand("From North-East", subTemp, DirSel, {Dir=2})
	local subDir3 = missionCommands.addCommand("From East", subTemp, DirSel, {Dir=3})
	local subDir4 = missionCommands.addCommand("From South-East", subTemp, DirSel, {Dir=4})
	local subDir5 = missionCommands.addCommand("From South", subTemp, DirSel, {Dir=5})
	local subDir6 = missionCommands.addCommand("From South-West", subTemp, DirSel, {Dir=6})
	local subDir7 = missionCommands.addCommand("From West", subTemp, DirSel, {Dir=7})
	local subDir8 = missionCommands.addCommand("From North-West", subTemp, DirSel, {Dir=8})

end

--------------------------------------------------------------------------------------

function PrepSide(val)					--select the country of the Eni flight. Depends on the country side of the launcher
	local SideVal = val.SideCnty

	if SideVal == 1 then
		FlightCnty = country.id.CJTF_RED
	elseif SideVal == 2 then
		FlightCnty = country.id.CJTF_BLUE
	end
	timer.scheduleFunction(LaunchFlt, FuncTime, timer.getTime()+1)
end



--------------------------------------------------------------------------------------

function DirSel(val)				--Direction selection function
	DirVal = val.Dir

	if DirVal == 1 then
		trigger.action.outText("** North selected **", 10, 0)
	elseif DirVal == 2 then
		trigger.action.outText("** North-East selected **", 10, 0)
	elseif DirVal == 3 then
		trigger.action.outText("** East selected **", 10, 0)
	elseif DirVal == 4 then
		trigger.action.outText("** South-East selected **", 10, 0)
	elseif DirVal == 5 then
		trigger.action.outText("** South selected **", 10, 0)
	elseif DirVal == 6 then
		trigger.action.outText("** South-West selected **", 10, 0)
	elseif DirVal == 7 then
		trigger.action.outText("** West selected **", 10, 0)
	elseif DirVal == 8 then
		trigger.action.outText("** North-West selected **", 10, 0)
	end
	VarTbl["Direct"] = tonumber(DirVal)

	local CZ = trigger.misc.getZone("COMBAT ZONE "..tonumber(VarTbl["Zone"]).."")			--get the zone coordinates
	local CZpoint = CZ.point

	CZTbl[3]["Long"] = tonumber(CZ.point.x)					--store the coordinates
	CZTbl[3]["Lat"] = tonumber(CZ.point.z)

	trigger.action.outText("** got the Zone... **", 5, 0)

	local StartX = PosTabl[tonumber(VarTbl["Direct"])]["x1"] + CZTbl[3]["Long"]				--calculate the starting waypoint of the flight
	local StartZ = PosTabl[tonumber(VarTbl["Direct"])]["z1"] + CZTbl[3]["Lat"]
	local InterX = PosTabl[tonumber(VarTbl["Direct"])]["x2"] + CZTbl[3]["Long"]				--calculate the intermediate waypoint of the flight
	local InterZ = PosTabl[tonumber(VarTbl["Direct"])]["z2"] + CZTbl[3]["Lat"]

	CZTbl[1]["Long"] = tonumber(StartX)						--store the coordinates of start and intermediate waypoint
	CZTbl[1]["Lat"] = tonumber(StartZ)
	CZTbl[2]["Long"] = tonumber(InterX)
	CZTbl[2]["Lat"] = tonumber(InterZ)

	missionCommands.removeItem({"**Config Flight TempMenu**"})
	local subTemp = missionCommands.addSubMenu("**Config Flight TempMenu**")

	local subPlan1 = missionCommands.addCommand("MiG-23", subTemp, PlanSel, {Plan=1})
	local subPlan2 = missionCommands.addCommand("MiG-31", subTemp, PlanSel, {Plan=2})
	local subPlan3 = missionCommands.addCommand("F-4E", subTemp, PlanSel, {Plan=3})
	local subPlan4 = missionCommands.addCommand("Su-27", subTemp, PlanSel, {Plan=4})
	local subPlan5 = missionCommands.addCommand("MiG-21", subTemp, PlanSel, {Plan=5})
	local subPlan6 = missionCommands.addCommand("MiG-29", subTemp, PlanSel, {Plan=6})
	local subPlan7 = missionCommands.addCommand("Su-35(J-11)", subTemp, PlanSel, {Plan=7})
	local subPlan8 = missionCommands.addCommand("F-15C", subTemp, PlanSel, {Plan=8})

	trigger.action.outText("** Coordinates are cooked... **", 5, 0)

end

--------------------------------------------------------------------------------------
function PlanSel(val)					--type of plane selection
	PlanVal = val.Plan

	if tonumber(VarTbl["Arma"]) == 4 then			--verify if the selected plane can carry FOX3
		if PlanVal <= 5 then
			trigger.action.outText("** This plane cannot carry FOX3, select another!!! **", 10, 0)
			PlanVal = 0
		elseif PlanVal == 6 then
			trigger.action.outText("** MiG-29 selected **", 10, 0)
		elseif PlanVal == 7 then
			trigger.action.outText("** Su-35(J-11) selected **", 10, 0)
		elseif PlanVal == 8 then
			trigger.action.outText("** F-15C selected **", 10, 0)
		end
	
	elseif tonumber(VarTbl["Arma"]) <= 3 then		--select the plane
		if PlanVal == 1 then
			trigger.action.outText("** MiG-23 selected **", 10, 0)
		elseif PlanVal == 2 then
			trigger.action.outText("** MiG-31 selected **", 10, 0)
		elseif PlanVal == 3 then
			trigger.action.outText("** F-4E selected **", 10, 0)
		elseif PlanVal == 4 then
			trigger.action.outText("** Su-27 selected **", 10, 0)
		elseif PlanVal == 5 then
			trigger.action.outText("** MiG-21 selected **", 10, 0)
		elseif PlanVal == 6 then
			trigger.action.outText("** MiG-29 selected **", 10, 0)
		elseif PlanVal == 7 then
			trigger.action.outText("** Su-35(J-11) selected **", 10, 0)
		elseif PlanVal == 8 then
			trigger.action.outText("** F-15C selected **", 10, 0)
		end
	end
	VarTbl["Plane"] = tonumber(PlanVal)			--store the plane value

	missionCommands.removeItem({"**Config Flight TempMenu**"})
	local subTemp = missionCommands.addSubMenu("**Config Flight TempMenu**")

	local subArm1 = missionCommands.addCommand("FOX-1", subTemp, ArmSel, {Arm=1})
	local subArm2 = missionCommands.addCommand("FOX-2", subTemp, ArmSel, {Arm=2})
	local subArm3 = missionCommands.addCommand("FOX-3", subTemp, ArmSel, {Arm=3})
	local subArm4 = missionCommands.addCommand("GUNS only", subTemp, ArmSel, {Arm=4})
	local subArm5 = missionCommands.addCommand("Random", subTemp, ArmSel, {Arm=5})

end

--------------------------------------------------------------------------------------
function ArmSel(val)					--type of armament selection
	ArmVal = val.Arm

	if ArmVal == 1 then
		trigger.action.outText("** FOX-1 selected **", 10, 0)
	elseif ArmVal == 2 then
		trigger.action.outText("** FOX-2 selected **", 10, 0)
	elseif ArmVal == 3 then
		if tonumber(VarTbl["Plane"]) <= 5 then
			trigger.action.outText("** FOX-3 impossible for this plane, select another armament!!! **", 10, 0)
			ArmVal = 0
		elseif tonumber(VarTbl["Plane"]) > 5 then
			trigger.action.outText("** FOX-3 selected **", 10, 0)
		end
	elseif ArmVal == 4 then
		trigger.action.outText("** GUNS selected **", 10, 0)
	elseif ArmVal == 5 then
		trigger.action.outText("** Random selected **", 10, 0)
		if PlanVal <= 5 then
			ArmVal = math.random (1,3)
		elseif PlanVal > 5 then
			ArmVal = math.random(1,4)
		end
	end
	VarTbl["Arma"] = tonumber(ArmVal)			--store the plane value

	missionCommands.removeItem({"**Config Flight TempMenu**"})
	local subTemp = missionCommands.addSubMenu("**Config Flight TempMenu**")

	local subQty1 = missionCommands.addCommand("1 plane", subTemp, QtySel, {Qty=1})
	local subQty2 = missionCommands.addCommand("2 planes", subTemp, QtySel, {Qty=2})
	local subQty3 = missionCommands.addCommand("3 planes", subTemp, QtySel, {Qty=3})
	local subQty4 = missionCommands.addCommand("4 planes", subTemp, QtySel, {Qty=4})

end
--------------------------------------------------------------------------------------

function QtySel(val)					--select the number of planes. Prepare the ["units"] table for the flight
	QtyVal = val.Qty

	local BoardNum = math.random (1, 999)
	AltDep = math.random(1370,9600)

	trigger.action.outText("** cooking Eni's... **", 10, 0)
	Eni1 = {							--table for the ["units"] section of the flight
		["alt"] = AltDep,
		["hardpoint_racks"] = true,
		["alt_type"] = "BARO",
		["livery_id"] = ""..tostring(PlaneTbl[tonumber(VarTbl["Plane"])]["LiveryType"]).."",
		["skill"] = "Excellent",
		["speed"] = 169.58333333333,
		["type"] = ""..tostring(PlaneTbl[tonumber(VarTbl["Plane"])]["PlaneType"]).."",
		["psi"] = -1.1783754164212,
		["y"] = 	CZTbl[1]["Lat"],
		["x"] = CZTbl[1]["Long"],
		["name"] = ""..tostring(QtyVal).." "..tostring(BoardNum).."",
		["payload"] =
		{
			["pylons"] = ConfTBL[tonumber(VarTbl["Plane"])][tonumber(VarTbl["Arma"])],
			["fuel"] = ConfTBL[tonumber(VarTbl["Plane"])][5],
			["flare"] = ConfTBL[tonumber(VarTbl["Plane"])][6],
			["chaff"] = ConfTBL[tonumber(VarTbl["Plane"])][7],
			["gun"] = ConfTBL[tonumber(VarTbl["Plane"])][8],
		},
	}
	trigger.action.outText("** Eni1 is cooked... **", 10, 0)



	if QtyVal == 1 then
		trigger.action.outText("** 1 bogey selected **", 10, 0)
		EniTbl = {
			[1] = Eni1,
			}
	elseif QtyVal == 2 then
		EniTbl = {
			[1] = Eni1,
			[2] = Eni1,
			}
		trigger.action.outText("** 2 bogey's selected **", 10, 0)
	elseif QtyVal == 3 then
		EniTbl = {
			[1] = Eni1,
			[2] = Eni1,
			[3] = Eni1,
			}
		trigger.action.outText("** 3 bogey's selected **", 10, 0)
	elseif QtyVal == 4 then
		EniTbl = {
			[1] = Eni1,
			[2] = Eni1,
			[3] = Eni1,
			[4] = Eni1,
			}
		trigger.action.outText("** 4 bogey's selected **", 10, 0)
	end
		trigger.action.outText("** All Eni's are cooked... **", 10, 0)
		VarTbl["QtyP"] = tonumber(QtyVal)								--store the number of planes
		trigger.action.outText("** End of flight configuration, you can launch it... **", 10, 0)
		missionCommands.removeItem({"**Config Flight TempMenu**"})
end

--------------------------------------------------------------------------------------
function LaunchRdm(FuncTime)			--randomize function for flight

	FuncTime = timer.getTime()
	if FuncTime > 60 then

	ZonVal = math.random (1, 3)
	DirVal = math.random (1, 8)
	ArmVal = math.random (1, 4)
	QtyVal = math.random (1, 4)

	if ArmVal == 3 then
		PlanVal = math.random (6, 8)
	else PlanVal = math.random (1, 8)
	end

	VarTbl["Zone"] = tonumber(ZonVal)
	VarTbl["Direct"] = tonumber(DirVal)
	VarTbl["Plane"] = tonumber(PlanVal)
	VarTbl["Arma"] = tonumber(ArmVal)
	VarTbl["QtyP"] = tonumber(QtyVal)

	timer.scheduleFunction(LaunchFlt, FuncTime, timer.getTime()+1)
	end
end

--------------------------------------------------------------------------------------

function ConFunc(TimeCheck)			--starting the temp menu for easier selection

	TimeCheck = timer.getTime()
	if TimeCheck > 10 then

	trigger.action.outText("** Starting configuration **", 2, 0)

	local subTemp = missionCommands.addSubMenu("**Config Flight TempMenu**")

	local subZ1 = missionCommands.addCommand("Zone 1", subTemp, ZoneSel, {Zone=1})
	local subZ2 = missionCommands.addCommand("Zone 2", subTemp, ZoneSel, {Zone=2})
	local subZ3 = missionCommands.addCommand("Zone 3", subTemp, ZoneSel, {Zone=3})
	
	end
end

--------------------------------------------------------------------------------------

function OptFunc(val)		--function for reloading script and verifying the stored data

	if val.Rset == 1 then			--reload
		trigger.action.outText("** Reloading script... **", 5, 0)
		missionCommands.removeItem(subXSM)
		dofile(lfs.writedir()..[[Missions\SERVEUR\ScriptsServ\Spawn_intercept_GENERIC_SERVEUR_V2.5.lua]])
		Rset = 0
		
	elseif val.Verif == 1 then		--verify the data

		if tonumber(VarTbl["Zone"]) == 0 then
			local StringZone = "none"
		elseif tonumber(VarTbl["Zone"]) ~= 0 then
			local StringZone = ""..tostring(PosTabl[tonumber(VarTbl["Direct"])]["DirName"])..""
		end
		trigger.action.outText("** Zone selected : "..tostring(StringZone).."... **", 15, 0)

		if tonumber(VarTbl["Direct"]) == 0 then
			local StringDir = "none"
		elseif tonumber(VarTbl["Direct"]) ~= 0 then
			local StringDir = ""..tostring(PosTabl[tonumber(VarTbl["Direct"])]["DirName"])..""
		end
		trigger.action.outText("** Direction selected : "..tostring(StringDir).."... **", 15, 0)

		if tonumber(VarTbl["Plane"]) == 0 then
			local StringPlane = "none"
		elseif tonumber(VarTbl["Plane"]) ~= 0 then
			local StringPlane = ""..tostring(PlaneTbl[tonumber(VarTbl["Plane"])]["PlaneType"])..""
		end
		trigger.action.outText("** Plane selected : "..tostring(StringPlane).."... **", 15, 0)

		if tonumber(VarTbl["Arma"]) == 0 then
			local StringArma = "none"
		elseif tonumber(VarTbl["Arma"]) ~= 0 then
			local StringArma = ""..tostring(ArmTbl[tonumber(VarTbl["Arma"])])..""
		end
		trigger.action.outText("** Armament selected : "..tostring(StringArma).."... **", 15, 0)

		if tonumber(VarTbl["QtyP"]) == 0 then
			local StringQty = "none"
		elseif tonumber(VarTbl["QtyP"]) ~= 0 then
			local StringQty = ""..tostring(ArmTbl[tonumber(VarTbl["QtyP"])])..""
		end
		trigger.action.outText("** Quantity of bogey's : "..tostring(StringQty).."... **", 15, 0)
		Verif = 0
	end
end

--------------------------------------------------------------------------------------

subXSM = missionCommands.addSubMenu("**TEST AIR SPAWN NG**", subR2)		--create the F-10 menu

	local subConf = missionCommands.addCommand("Configure flight", subXSM, ConFunc, TimeCheck)
	local subLnR = missionCommands.addCommandForCoalition(2, "Launch Red flight", subXSM, PrepSide, {SideCnty = 1})	
	local subLnB = missionCommands.addCommandForCoalition(1, "Launch Blue flight", subXSM, PrepSide, {SideCnty = 2})
	local subLnr = missionCommands.addCommand("Launch random", subXSM, LaunchRdm, FuncTime)
	local subStateP = missionCommands.addCommand("Verify selected data", subXSM, OptFunc, {Verif=1})
	local subRld = missionCommands.addCommand("Reload script", subXSM, OptFunc, {Rset=1})

	trigger.action.outText("** SpawnFighters script v 2.56b initialized... **", 5, 0)

--------------------------------------------------------------------------------------