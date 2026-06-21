--Loadouts database
--Helicopter loadouts
-------------------------------------------------------------------------------------------------------

if not versionDCE then versionDCE = {} end
versionDCE["db_loadouts/db_loadouts_Heli.lua"] = "1.1.6"

-- 1.1.6 - OH58D and UH-1H strike range to 150000
-- 1.1.5 - No Mods
-- 1.1.4 - UH-1H Loadout strike NAM Rockets HE 
-- 1.1.3 - SH-3D missions adjustement
-- 1.1.2 - OH58D NAM version
-- 1.1.1 - Beginning of the versions of this loadouts file dedicated to the F4.


db_loadouts = {
	["Mi-24V"] = {
		Escort = {
			["Escort 4x9M114, 2xUPK-23"] = {
				self_escort = true,
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 80000,
				firepower = 1,
				vCruise = 75,
				vAttack = 85,
				hCruise = 50,
				hAttack = 50,
				standoff = 3000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{B919B0F4-7C25-455E-9A02-CEA51DB895E3}",
						},
						[2] = {
							CLSID = "{05544F1A-C39C-466b-BC37-5BD1D52E57BB}",
						},
						[6] = {
							CLSID = "{B919B0F4-7C25-455E-9A02-CEA51DB895E3}",
						},
						[5] = {
							CLSID = "{05544F1A-C39C-466b-BC37-5BD1D52E57BB}",
						},
					},
					fuel = 1551,
					flare = 192,
					chaff = 0,
					gun = 100,
				},
			},
		},
		Strike = {
			["Strike - 8x9M114, 2xUPK-23"] = {
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "All" },
				weaponType = "ASM",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 80000,
				firepower = 1,
				vCruise = 75,
				vAttack = 85,
				hCruise = 50,
				hAttack = 50,
				standoff = 3000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{B919B0F4-7C25-455E-9A02-CEA51DB895E3}",
						},
						[2] = {
							CLSID = "{B919B0F4-7C25-455E-9A02-CEA51DB895E3}",
						},
						[3] = {
							CLSID = "{05544F1A-C39C-466b-BC37-5BD1D52E57BB}",
						},
						[4] = {
							CLSID = "{05544F1A-C39C-466b-BC37-5BD1D52E57BB}",
						},
						[5] = {
							CLSID = "{B919B0F4-7C25-455E-9A02-CEA51DB895E3}",
						},
						[6] = {
							CLSID = "{B919B0F4-7C25-455E-9A02-CEA51DB895E3}",
						},
					},
					fuel = 1551,
					flare = 192,
					chaff = 0,
					gun = 100,
				},
			},
		},
	},
	["AH-64A"] = {
		Escort = {
			["Escort - WOC-80s  8xAGM-114, 38xHYDRA-70"] = {
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 100000,
				firepower = 1,
				vCruise = 55,
				standoff = 7000,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{88D18A5E-99C8-4B04-B40B-1C02F2018B6E}",
						},
						[2] = {
							CLSID = "{FD90A1DC-9147-49FA-BF56-CB83EF0BD32B}",
						},
						[3] = {
							CLSID = "{FD90A1DC-9147-49FA-BF56-CB83EF0BD32B}",
						},
						[4] = {
							CLSID = "{88D18A5E-99C8-4B04-B40B-1C02F2018B6E}",
						},
					},
					fuel = 1157,
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
		},
		Strike = {
			Strike = {
				minscore = 0.3,
				support = {
					Escort = false,
					SEAD = false,
				},
				attributes =  { "frontline" },
				code_loadout =  { "WOC80" },
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 100000,
				firepower = 1,
				vCruise = 70,
				vAttack = 75,
				hCruise = 50,
				hAttack = 50,
				standoff = 7000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{88D18A5E-99C8-4B04-B40B-1C02F2018B6E}",
						},
						[2] = {
							CLSID = "{FD90A1DC-9147-49FA-BF56-CB83EF0BD32B}",
						},
						[3] = {
							CLSID = "{FD90A1DC-9147-49FA-BF56-CB83EF0BD32B}",
						},
						[4] = {
							CLSID = "{88D18A5E-99C8-4B04-B40B-1C02F2018B6E}",
						},
					},
					fuel = 1157,
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
		},
	},
	["AH-64D"] = {
		Escort = {
			Escort = {
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 55,
				standoff = 7000,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{88D18A5E-99C8-4B04-B40B-1C02F2018B6E}",
						},
						[2] = {
							CLSID = "{FD90A1DC-9147-49FA-BF56-CB83EF0BD32B}",
						},
						[3] = {
							CLSID = "{FD90A1DC-9147-49FA-BF56-CB83EF0BD32B}",
						},
						[4] = {
							CLSID = "{88D18A5E-99C8-4B04-B40B-1C02F2018B6E}",
						},
					},
					fuel = 1157,
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
		},
		Strike = {
			Strike = {
				minscore = 0.3,
				support = {
					Escort = false,
					SEAD = false,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "All" },
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 70,
				vAttack = 75,
				hCruise = 50,
				hAttack = 50,
				standoff = 7000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{88D18A5E-99C8-4B04-B40B-1C02F2018B6E}",
						},
						[2] = {
							CLSID = "{FD90A1DC-9147-49FA-BF56-CB83EF0BD32B}",
						},
						[3] = {
							CLSID = "{FD90A1DC-9147-49FA-BF56-CB83EF0BD32B}",
						},
						[4] = {
							CLSID = "{88D18A5E-99C8-4B04-B40B-1C02F2018B6E}",
						},
					},
					fuel = 1157,
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
		},
	},
	["AH-64D_BLK_II"] = {
		Escort = {
			Escort = {
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 100000,
				firepower = 1,
				vCruise = 55,
				standoff = 7000,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{M299_4xAGM_114K}",
						},
						[2] = {
							CLSID = "{88D18A5E-99C8-4B04-B40B-1C02F2018B6E}",
						},
						[3] = {
							CLSID = "{88D18A5E-99C8-4B04-B40B-1C02F2018B6E}",
						},
						[4] = {
							CLSID = "{M299_4xAGM_114K}",
						},
						[5] = {
							CLSID = "{IAFS_ComboPak_100}",
						},
						[6] = {
							CLSID = "{AN_APG_78}",
						},
					},
					fuel = 1438,
					flare = 60,
					chaff = 30,
					gun = 100,
				},
			},
		},
		Strike = {
			Strike = {
				minscore = 0.3,
				support = {
					Escort = false,
					SEAD = false,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "Crisis", "WOB" },
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 100000,
				firepower = 1,
				vCruise = 70,
				vAttack = 75,
				hCruise = 50,
				hAttack = 50,
				standoff = 7000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{M299_4xAGM_114K}",
						},
						[2] = {
							CLSID = "{88D18A5E-99C8-4B04-B40B-1C02F2018B6E}",
						},
						[3] = {
							CLSID = "{88D18A5E-99C8-4B04-B40B-1C02F2018B6E}",
						},
						[4] = {
							CLSID = "{M299_4xAGM_114K}",
						},
						[5] = {
							CLSID = "{IAFS_ComboPak_100}",
						},
						[6] = {
							CLSID = "{AN_APG_78}",
						},
					},
					fuel = 1438,
					flare = 60,
					chaff = 30,
					gun = 100,
				},
			},
			["Strike WOC"] = {
				minscore = 0.3,
				support = {
					Escort = false,
					SEAD = false,
				},
				attributes =  { "frontline" },
				code_loadout =  { "Caucasus" },
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 100000,
				firepower = 1,
				vCruise = 70,
				vAttack = 75,
				hCruise = 50,
				hAttack = 50,
				standoff = 7000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{M299_4xAGM_114L}",
						},
						[2] = {
							CLSID = "{88D18A5E-99C8-4B04-B40B-1C02F2018B6E}",
						},
						[3] = {
							CLSID = "{88D18A5E-99C8-4B04-B40B-1C02F2018B6E}",
						},
						[4] = {
							CLSID = "{M299_4xAGM_114L}",
						},
						[5] = {
							CLSID = "{IAFS_ComboPak_100}",
						},
						[6] = {
							CLSID = "{AN_APG_78}",
						},
					},
					fuel = 1438,
					flare = 60,
					chaff = 30,
					gun = 100,
				},
			},
			["Strike Cyprus"] = {
				minscore = 0.3,
				support = {
					Escort = false,
					SEAD = false,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "Cyprus" },
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 100000,
				firepower = 1,
				vCruise = 70,
				vAttack = 75,
				hCruise = 50,
				hAttack = 50,
				standoff = 7000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{M299_4xAGM_114L}",
						},
						[2] = {
							CLSID = "{88D18A5E-99C8-4B04-B40B-1C02F2018B6E}",
						},
						[3] = {
							CLSID = "{88D18A5E-99C8-4B04-B40B-1C02F2018B6E}",
						},
						[4] = {
							CLSID = "{M299_4xAGM_114L}",
						},
						[5] = {
							CLSID = "{IAFS_ComboPak_100}",
						},
						[6] = {
							CLSID = "{AN_APG_78}",
						},
					},
					fuel = 1438,
					flare = 60,
					chaff = 30,
					gun = 100,
				},
			},
		},
	},
	["SA342M"] = {
		Strike = {
			["Strike WOC Hot3x4, FAS, IR Deflector"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "frontline" },
				code_loadout =  { "Caucasus", "WOC80", "WOB" },
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 120000,
				firepower = 1,
				vCruise = 60,
				vAttack = 80,
				hCruise = 50,
				hAttack = 50,
				standoff = 4000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{HOT3_R2_M}",
						},
						[2] = {
							CLSID = "{HOT3_L2_M}",
						},
						[3] = {
							CLSID = "{FAS}",
						},
						[4] = {
							CLSID = "{IR_Deflector}",
						},
					},
					fuel = 416,
					flare = 32,
					chaff = 0,
					gun = 100,
				},
			},
			["Strike 80s,90s,2000s AG Hot3*4,IR deflector, Sand Filter"] = {
				minscore = 0.3,
				support = {
					Escort = false,
					SEAD = false,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "IIW", "Crisis", "PG", "WOT87" },
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 80000,
				firepower = 4,
				vCruise = 60,
				vAttack = 80,
				hCruise = 70,
				hAttack = 60,
				standoff = 4000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{HOT3_R2_M}",
						},
						[2] = {
							CLSID = "{HOT3_L2_M}",
						},
						[3] = {
							CLSID = "{FAS}",
						},
						[4] = {
							CLSID = "{IR_Deflector}",
						},
					},
					fuel = 416,
					flare = 32,
					chaff = 0,
					gun = 100,
				},
			},
			["Strike Cyprus Strike Hot3x4, FAS, IR Deflector"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "Structure" },
				code_loadout =  { "Cyprus" },
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 120000,
				firepower = 1,
				vCruise = 60,
				vAttack = 80,
				hCruise = 50,
				hAttack = 50,
				standoff = 4000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{HOT3_R2_M}",
						},
						[2] = {
							CLSID = "{HOT3_L2_M}",
						},
						[3] = {
							CLSID = "{FAS}",
						},
						[4] = {
							CLSID = "{IR_Deflector}",
						},
					},
					fuel = 416,
					flare = 32,
					chaff = 0,
					gun = 100,
				},
			},
		},
	},
	["SA342Minigun"] = {
		Escort = {
			["Minigun IR Deflector"] = {
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 120000,
				firepower = 1,
				vCruise = 60,
				standoff = 2000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[6] = {
							CLSID = "{IR_Deflector}",
						},
					},
					fuel = 416,
					flare = 32,
					chaff = 0,
					gun = 100,
				},
			},
		},
		Strike = {
			["Minigun WOC IR Deflector"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "frontline" },
				code_loadout =  { "Caucasus" },
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 120000,
				firepower = 1,
				vCruise = 60,
				vAttack = 80,
				hCruise = 50,
				hAttack = 50,
				standoff = 4000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[6] = {
							CLSID = "{IR_Deflector}",
						},
					},
					fuel = 416,
					flare = 32,
					chaff = 0,
					gun = 100,
				},
			},
		},
	},
	["SA342L"] = {
		Escort = {
			["Rocket*8 - GIAT gun -Sand filter-IR Deflector"] = {
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 120000,
				firepower = 1,
				vCruise = 60,
				standoff = 2000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{GIAT_M621_APHE}",
						},
						[2] = {
							CLSID = "{TELSON8_SNEBT253}",
						},
						[3] = {
							CLSID = "{FAS}",
						},
						[4] = {
							CLSID = "{IR_Deflector}",
						},
						[5] = {
							CLSID = "{SA342_Dipole}",
						},
					},
					fuel = 416,
					flare = 32,
					chaff = 0,
					gun = 100,
				},
			},
			["Escort AA - Mistral*4 -Sand filter-IR Deflector"] = {
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 120000,
				firepower = 1,
				vCruise = 60,
				standoff = 2000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{SA342_Mistral_R2}",
						},
						[2] = {
							CLSID = "{SA342_Mistral_L2}",
						},
						[3] = {
							CLSID = "{FAS}",
						},
						[4] = {
							CLSID = "{IR_Deflector}",
						},
						[5] = {
							CLSID = "{SA342_Dipole}",
						},
					},
					fuel = 416,
					flare = 32,
					chaff = 0,
					gun = 100,
				},
			},
		},
		Strike = {
			["Rocket*8 - GIAT gun -Sand filter-IR Deflector"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "WOB" },
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 120000,
				firepower = 1,
				vCruise = 60,
				vAttack = 80,
				hCruise = 50,
				hAttack = 50,
				standoff = 2000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{GIAT_M621_APHE}",
						},
						[2] = {
							CLSID = "{TELSON8_SNEBT253}",
						},
						[3] = {
							CLSID = "{FAS}",
						},
						[4] = {
							CLSID = "{IR_Deflector}",
						},
						[5] = {
							CLSID = "{SA342_Dipole}",
						},
					},
					fuel = 416,
					flare = 32,
					chaff = 0,
					gun = 100,
				},
			},
			["AG Caucasus - Hot3*4 -Sand filter-IR Deflector"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "frontline" },
				code_loadout =  { "Caucasus", "WOC80" },
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 120000,
				firepower = 1,
				vCruise = 60,
				vAttack = 80,
				hCruise = 50,
				hAttack = 50,
				standoff = 4000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[5] = {
							CLSID = "{SA342_Dipole}",
						},
						[2] = {
							CLSID = "{HOT3_L2}",
						},
						[4] = {
							CLSID = "{IR_Deflector}",
						},
						[1] = {
							CLSID = "{HOT3_R2}",
						},
					},
					fuel = 416,
					flare = 32,
					chaff = 0,
					gun = 100,
				},
			},
			["AG - Hot3*4 -Sand filter-IR Deflector"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "Cyprus", "WOB" },
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 120000,
				firepower = 1,
				vCruise = 60,
				vAttack = 80,
				hCruise = 50,
				hAttack = 50,
				standoff = 4000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{HOT3_R2}",
						},
						[2] = {
							CLSID = "{HOT3_L2}",
						},
						[3] = {
							CLSID = "{FAS}",
						},
						[4] = {
							CLSID = "{IR_Deflector}",
						},
						[5] = {
							CLSID = "{SA342_Dipole}",
						},
					},
					fuel = 416,
					flare = 32,
					chaff = 0,
					gun = 100,
				},
			},
			["AG -Rocket*8 - FN HPM400 -Sand filter-IR Deflector"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "WOB" },
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 120000,
				firepower = 1,
				vCruise = 60,
				vAttack = 80,
				hCruise = 50,
				hAttack = 50,
				standoff = 4000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{FN_HMP400}",
						},
						[2] = {
							CLSID = "{TELSON8_SNEBT253}",
						},
						[3] = {
							CLSID = "{FAS}",
						},
						[4] = {
							CLSID = "{IR_Deflector}",
						},
						[5] = {
							CLSID = "{SA342_Dipole}",
						},
					},
					fuel = 416,
					flare = 32,
					chaff = 0,
					gun = 100,
				},
			},
		},
	},
	["Ka-50_3"] = {
		Escort = {
			["Escort PG -  12x9A4172, 2xFT, 4xIgla"] = {
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 75,
				standoff = 10000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{A6FD14D3-6D30-4C85-88A7-8D17BEE120E2}",
						},
						[2] = {
							CLSID = "{PTB_450}",
						},
						[3] = {
							CLSID = "{PTB_450}",
						},
						[4] = {
							CLSID = "{A6FD14D3-6D30-4C85-88A7-8D17BEE120E2}",
						},
						[5] = {
							CLSID = "{9S846_2xIGLA}",
						},
						[6] = {
							CLSID = "{9S846_2xIGLA}",
						},
					},
					fuel = 1450,
					flare = 128,
					chaff = 0,
					gun = 100,
				},
			},
		},
		Strike = {
			["Strike heavy 2xKh-25ML, 4xIgla, 2xFT"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "Structure" },
				code_loadout =  { "All" },
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 150000,
				firepower = 1,
				vCruise = 75,
				vAttack = 85,
				hCruise = 50,
				hAttack = 50,
				standoff = 10000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6DADF342-D4BA-4D8A-B081-BA928C4AF86D}",
						},
						[2] = {
							CLSID = "{PTB_450}",
						},
						[3] = {
							CLSID = "{PTB_450}",
						},
						[4] = {
							CLSID = "{6DADF342-D4BA-4D8A-B081-BA928C4AF86D}",
						},
						[5] = {
							CLSID = "{9S846_2xIGLA}",
						},
						[6] = {
							CLSID = "{9S846_2xIGLA}",
						},
					},
					fuel = 1450,
					flare = 128,
					chaff = 0,
					gun = 100,
				},
			},
			["Strike 12x9A4172, 40xS-8KOM, 4xIgla"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "frontline" },
				code_loadout =  { "Caucasus" },
				expend = "Auto",
				adverseWeather = true,
				range = 150000,
				firepower = 1,
				vCruise = 75,
				vAttack = 85,
				hCruise = 50,
				hAttack = 50,
				standoff = 6000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{A6FD14D3-6D30-4C85-88A7-8D17BEE120E2}",
						},
						[2] = {
							CLSID = "{6A4B9E69-64FE-439a-9163-3A87FB6A4D81}",
						},
						[3] = {
							CLSID = "{6A4B9E69-64FE-439a-9163-3A87FB6A4D81}",
						},
						[4] = {
							CLSID = "{A6FD14D3-6D30-4C85-88A7-8D17BEE120E2}",
						},
						[5] = {
							CLSID = "{9S846_2xIGLA}",
						},
						[6] = {
							CLSID = "{9S846_2xIGLA}",
						},
					},
					fuel = 1450,
					flare = 128,
					chaff = 0,
					gun = 100,
				},
			},
			["Strike Crisis 12x9A4172, 40xS-8KOM, 4xIgla"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "Crisis", "WOB" },
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 150000,
				firepower = 1,
				vCruise = 75,
				vAttack = 85,
				hCruise = 50,
				hAttack = 50,
				standoff = 6000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{A6FD14D3-6D30-4C85-88A7-8D17BEE120E2}",
						},
						[2] = {
							CLSID = "{6A4B9E69-64FE-439a-9163-3A87FB6A4D81}",
						},
						[3] = {
							CLSID = "{6A4B9E69-64FE-439a-9163-3A87FB6A4D81}",
						},
						[4] = {
							CLSID = "{A6FD14D3-6D30-4C85-88A7-8D17BEE120E2}",
						},
						[5] = {
							CLSID = "{9S846_2xIGLA}",
						},
						[6] = {
							CLSID = "{9S846_2xIGLA}",
						},
					},
					fuel = 1450,
					flare = 128,
					chaff = 0,
					gun = 100,
				},
			},
			["Strike LR Crisis 12x9A4172, 2xFT, 4xIgla"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "Crisis", "WOB" },
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 75,
				vAttack = 85,
				hCruise = 50,
				hAttack = 50,
				standoff = 10000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{A6FD14D3-6D30-4C85-88A7-8D17BEE120E2}",
						},
						[2] = {
							CLSID = "{PTB_450}",
						},
						[3] = {
							CLSID = "{PTB_450}",
						},
						[4] = {
							CLSID = "{A6FD14D3-6D30-4C85-88A7-8D17BEE120E2}",
						},
						[5] = {
							CLSID = "{9S846_2xIGLA}",
						},
						[6] = {
							CLSID = "{9S846_2xIGLA}",
						},
					},
					fuel = 1450,
					flare = 128,
					chaff = 0,
					gun = 100,
				},
			},
			["Strike LR 12x9A4172, 2xFT, 4xIgla"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "frontline" },
				code_loadout =  { "Caucasus" },
				expend = "Auto",
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 75,
				vAttack = 85,
				hCruise = 50,
				hAttack = 50,
				standoff = 10000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{A6FD14D3-6D30-4C85-88A7-8D17BEE120E2}",
						},
						[2] = {
							CLSID = "{PTB_450}",
						},
						[3] = {
							CLSID = "{PTB_450}",
						},
						[4] = {
							CLSID = "{A6FD14D3-6D30-4C85-88A7-8D17BEE120E2}",
						},
						[5] = {
							CLSID = "{9S846_2xIGLA}",
						},
						[6] = {
							CLSID = "{9S846_2xIGLA}",
						},
					},
					fuel = 1450,
					flare = 128,
					chaff = 0,
					gun = 100,
				},
			},
		},
	},
	["SH-60B"] = {
		CSAR = {
			["CSAR test"] = {
				minscore = 0.001,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 65,
				vAttack = 75,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
					},
					fuel = 1100,
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
		},
		SAR = {
			["SAR test"] = {
				minscore = 0.001,
				support = {
				},
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 65,
				vAttack = 75,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
					},
					fuel = 1100,
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
		},
		Transport = {
			Default = {
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 65,
				vAttack = 75,
				hCruise = 100,
				hAttack = 100,
				sortie_rate = 5,
				stores = {
					pylons = {
					},
					fuel = "1100",
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
		},
	},
	["CH-53E"] = {
		CSAR = {
			["CSAR test"] = {
				minscore = 0.001,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 75,
				vAttack = 80,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
					},
					fuel = 2880,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
		},
		SAR = {
			["SAR test"] = {
				minscore = 0.001,
				support = {
				},
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 75,
				vAttack = 80,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
					},
					fuel = 2880,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
		},
		Transport = {
			Default = {
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 75,
				vAttack = 80,
				hCruise = 100,
				hAttack = 100,
				sortie_rate = 5,
				stores = {
					pylons = {
					},
					fuel = 2880,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
		},
	},
	["Ka-50"] = {
		Escort = {
			["Escort 12x9A4172, 40xS-8"] = {
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 150000,
				firepower = 1,
				vCruise = 75,
				standoff = 10000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{A6FD14D3-6D30-4C85-88A7-8D17BEE120E2}",
						},
						[2] = {
							CLSID = "{6A4B9E69-64FE-439a-9163-3A87FB6A4D81}",
						},
						[3] = {
							CLSID = "{6A4B9E69-64FE-439a-9163-3A87FB6A4D81}",
						},
						[4] = {
							CLSID = "{A6FD14D3-6D30-4C85-88A7-8D17BEE120E2}",
						},
					},
					fuel = 1450,
					flare = 128,
					chaff = 0,
					gun = 100,
				},
			},
			["Escort Strike LR 12x9A4172, FTx2"] = {
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 75,
				standoff = 10000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{A6FD14D3-6D30-4C85-88A7-8D17BEE120E2}",
						},
						[2] = {
							CLSID = "{B99EE8A8-99BC-4a8d-89AC-A26831920DCE}",
						},
						[3] = {
							CLSID = "{B99EE8A8-99BC-4a8d-89AC-A26831920DCE}",
						},
						[4] = {
							CLSID = "{A6FD14D3-6D30-4C85-88A7-8D17BEE120E2}",
						},
					},
					fuel = 1450,
					flare = 128,
					chaff = 0,
					gun = 100,
				},
			},
		},
		Strike = {
			["Strike LR Crisis 12x9A4172, FTx2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "Crisis", "WOB" },
				expend = "Auto",
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 75,
				vAttack = 85,
				hCruise = 50,
				hAttack = 50,
				standoff = 10000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{A6FD14D3-6D30-4C85-88A7-8D17BEE120E2}",
						},
						[2] = {
							CLSID = "{B99EE8A8-99BC-4a8d-89AC-A26831920DCE}",
						},
						[3] = {
							CLSID = "{B99EE8A8-99BC-4a8d-89AC-A26831920DCE}",
						},
						[4] = {
							CLSID = "{A6FD14D3-6D30-4C85-88A7-8D17BEE120E2}",
						},
					},
					fuel = 1450,
					flare = 128,
					chaff = 0,
					gun = 100,
				},
			},
			["Strike heavy Kh-25MLx2 - Rktx40"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "Structure" },
				code_loadout =  { "All" },
				expend = "Auto",
				adverseWeather = true,
				range = 150000,
				firepower = 1,
				vCruise = 75,
				vAttack = 85,
				hCruise = 50,
				hAttack = 50,
				standoff = 10000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6DADF342-D4BA-4D8A-B081-BA928C4AF86D}",
						},
						[2] = {
							CLSID = "{6A4B9E69-64FE-439a-9163-3A87FB6A4D81}",
						},
						[3] = {
							CLSID = "{6A4B9E69-64FE-439a-9163-3A87FB6A4D81}",
						},
						[4] = {
							CLSID = "{6DADF342-D4BA-4D8A-B081-BA928C4AF86D}",
						},
					},
					fuel = 1450,
					flare = 128,
					chaff = 0,
					gun = 100,
				},
			},
			["Strike 12x9A4172, 40xS-8"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "frontline" },
				code_loadout =  { "Caucasus" },
				expend = "Auto",
				adverseWeather = true,
				range = 150000,
				firepower = 1,
				vCruise = 75,
				vAttack = 85,
				hCruise = 50,
				hAttack = 50,
				standoff = 6000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{A6FD14D3-6D30-4C85-88A7-8D17BEE120E2}",
						},
						[2] = {
							CLSID = "{6A4B9E69-64FE-439a-9163-3A87FB6A4D81}",
						},
						[3] = {
							CLSID = "{6A4B9E69-64FE-439a-9163-3A87FB6A4D81}",
						},
						[4] = {
							CLSID = "{A6FD14D3-6D30-4C85-88A7-8D17BEE120E2}",
						},
					},
					fuel = 1450,
					flare = 128,
					chaff = 0,
					gun = 100,
				},
			},
			["Strike LR 12x9A4172, FTx2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "frontline" },
				code_loadout =  { "Caucasus" },
				expend = "Auto",
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 75,
				vAttack = 85,
				hCruise = 50,
				hAttack = 50,
				standoff = 10000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{A6FD14D3-6D30-4C85-88A7-8D17BEE120E2}",
						},
						[2] = {
							CLSID = "{B99EE8A8-99BC-4a8d-89AC-A26831920DCE}",
						},
						[3] = {
							CLSID = "{B99EE8A8-99BC-4a8d-89AC-A26831920DCE}",
						},
						[4] = {
							CLSID = "{A6FD14D3-6D30-4C85-88A7-8D17BEE120E2}",
						},
					},
					fuel = 1450,
					flare = 128,
					chaff = 0,
					gun = 100,
				},
			},
			["Strike  Crisis 12x9A4172, 40xS-8"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "Crisis", "WOB" },
				expend = "Auto",
				adverseWeather = true,
				range = 150000,
				firepower = 1,
				vCruise = 75,
				vAttack = 85,
				hCruise = 50,
				hAttack = 50,
				standoff = 6000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{A6FD14D3-6D30-4C85-88A7-8D17BEE120E2}",
						},
						[2] = {
							CLSID = "{6A4B9E69-64FE-439a-9163-3A87FB6A4D81}",
						},
						[3] = {
							CLSID = "{6A4B9E69-64FE-439a-9163-3A87FB6A4D81}",
						},
						[4] = {
							CLSID = "{A6FD14D3-6D30-4C85-88A7-8D17BEE120E2}",
						},
					},
					fuel = 1450,
					flare = 128,
					chaff = 0,
					gun = 100,
				},
			},
		},
	},
	["Ka-27"] = {
		CSAR = {
			["CSAR test"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 55,
				vAttack = 75,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
					},
					fuel = 2616,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		SAR = {
			["SAR test"] = {
				minscore = 0.3,
				support = {
				},
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 55,
				vAttack = 75,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
					},
					fuel = 2616,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		Transport = {
			Default = {
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 55,
				vAttack = 75,
				hCruise = 100,
				hAttack = 100,
				sortie_rate = 5,
				stores = {
					pylons = {
					},
					fuel = 2616,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
	},
	["CH-47D"] = {
		CSAR = {
			["CSAR test"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 75,
				vAttack = 80,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
					},
					fuel = 3600,
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
		},
		SAR = {
			["SAR test"] = {
				minscore = 0.3,
				support = {
				},
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 75,
				vAttack = 80,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
					},
					fuel = 3600,
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
		},
		Transport = {
			Default = {
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 75,
				vAttack = 80,
				hCruise = 100,
				hAttack = 100,
				sortie_rate = 5,
				stores = {
					pylons = {
					},
					fuel = 3600,
					flare = 120,
					chaff = 120,
					gun = 100,
				},
			},
		},
	},
	["CH-47Fbl1"] = {
		CSAR = {
			["CSAR test"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 75,
				vAttack = 80,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = 
					{
						[1] = 
						{
						["CLSID"] = "{CH47_PORT_M60D}",
						}, -- end of [1]
						[2] = 
						{
						["CLSID"] = "{CH47_STBD_M60D}",
						}, -- end of [2]
					},
					fuel = 3054.592,
					flare = 120,
					chaff = 120,
					gun = 100,
				},
			},
		},
		SAR = {
			["SAR test"] = {
				minscore = 0.3,
				support = {
				},
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 75,
				vAttack = 80,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = 
					{
						[1] = 
						{
						["CLSID"] = "{CH47_PORT_M60D}",
						}, -- end of [1]
						[2] = 
						{
						["CLSID"] = "{CH47_STBD_M60D}",
						}, -- end of [2]
					},
					fuel = 3054.592,
					flare = 120,
					chaff = 120,
					gun = 100,
				},
			},
		},
		Transport = {
			Default = {
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 75,
				vAttack = 80,
				hCruise = 100,
				hAttack = 100,
				sortie_rate = 6,
				stores = {
					pylons = 
					{
						[1] = 
						{
						["CLSID"] = "{CH47_PORT_M60D}",
						}, -- end of [1]
						[2] = 
						{
						["CLSID"] = "{CH47_STBD_M60D}",
						}, -- end of [2]
					},
					fuel = 3054.592,
					flare = 120,
					chaff = 120,
					gun = 100,
				},
			},
		},
	},
	["Mi-24P"] = {
		Strike = {
			["Strike - Structures - AT9Heat*4 + S-24B*4"] = {
				minscore = 0.3,
				support = {
					Escort = false,
					SEAD = false,
				},
				attributes =  { "Structure" },
				code_loadout =  { "Cyprus" },
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 150000,
				firepower = 1,
				vCruise = 75,
				vAttack = 85,
				hCruise = 50,
				hAttack = 50,
				standoff = 2000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{2x9M120_Ataka_V}",
						},
						[2] = {
							CLSID = "{APU_68_S-24}",
						},
						[3] = {
							CLSID = "{APU_68_S-24}",
						},
						[4] = {
							CLSID = "{APU_68_S-24}",
						},
						[5] = {
							CLSID = "{APU_68_S-24}",
						},
						[6] = {
							CLSID = "{2x9M120_Ataka_V}",
						},
					},
					fuel = 1701,
					flare = 192,
					chaff = 0,
					gun = 100,
				},
			},
			["Strike WOC 2xB8V20+8xATGM_AT9-Heat"] = {
				minscore = 0.3,
				support = {
					Escort = false,
					SEAD = false,
				},
				attributes =  { "frontline" },
				code_loadout =  { "Caucasus" },
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 150000,
				firepower = 1,
				vCruise = 75,
				vAttack = 85,
				hCruise = 50,
				hAttack = 50,
				standoff = 6000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{2x9M120_Ataka_V}",
						},
						[2] = {
							CLSID = "{2x9M120_Ataka_V}",
						},
						[3] = {
							CLSID = "{6A4B9E69-64FE-439a-9163-3A87FB6A4D81}",
						},
						[4] = {
							CLSID = "{6A4B9E69-64FE-439a-9163-3A87FB6A4D81}",
						},
						[5] = {
							CLSID = "{2x9M120_Ataka_V}",
						},
						[6] = {
							CLSID = "{2x9M120_Ataka_V}",
						},
					},
					fuel = 1701,
					flare = 192,
					chaff = 0,
					gun = 100,
				},
			},
			["Strike 80s 1xB8V20+8xATGM_AT6+Gunner"] = {
				minscore = 0.3,
				support = {
					Escort = false,
					SEAD = false,
				},
				attributes =  { "frontline" },
				code_loadout =  { "WOC80" },
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 150000,
				firepower = 1,
				vCruise = 75,
				vAttack = 85,
				hCruise = 50,
				hAttack = 50,
				standoff = 6000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{B919B0F4-7C25-455E-9A02-CEA51DB895E3}",
						},
						[2] = {
							CLSID = "{B919B0F4-7C25-455E-9A02-CEA51DB895E3}",
						},
						[3] = {
							CLSID = "{6A4B9E69-64FE-439a-9163-3A87FB6A4D81}",
						},
						[4] = {
							CLSID = "{6A4B9E69-64FE-439a-9163-3A87FB6A4D81}",
						},
						[5] = {
							CLSID = "{B919B0F4-7C25-455E-9A02-CEA51DB895E3}",
						},
						[6] = {
							CLSID = "{B919B0F4-7C25-455E-9A02-CEA51DB895E3}",
						},
					},
					fuel = 1701,
					flare = 192,
					chaff = 0,
					gun = 100,
				},
			},
			["Strike 2xB8V20+8xATGM_AT9-Heat"] = {
				minscore = 0.3,
				support = {
					Escort = false,
					SEAD = false,
				},
				attributes =  { "soft", "SAM" },
				code_loadout =  { "Cyprus", "HWITC", "Crisis", "WOB" },
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 150000,
				firepower = 1,
				vCruise = 75,
				vAttack = 85,
				hCruise = 50,
				hAttack = 50,
				standoff = 6000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{2x9M120_Ataka_V}",
						},
						[2] = {
							CLSID = "{2x9M120_Ataka_V}",
						},
						[3] = {
							CLSID = "{6A4B9E69-64FE-439a-9163-3A87FB6A4D81}",
						},
						[4] = {
							CLSID = "{6A4B9E69-64FE-439a-9163-3A87FB6A4D81}",
						},
						[5] = {
							CLSID = "{2x9M120_Ataka_V}",
						},
						[6] = {
							CLSID = "{2x9M120_Ataka_V}",
						},
					},
					fuel = 1701,
					flare = 192,
					chaff = 0,
					gun = 100,
				},
			},
			["Strike 1980s 1xB8V20+8xATGM_AT6+Gunner"] = {
				minscore = 0.1,
				support = {
					Escort = false,
					SEAD = false,
				},
				attributes =  { "soft", "SAM" },
				code_loadout =  { "IIW", "WOT87" },
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 150000,
				firepower = 8,
				vCruise = 75,
				vAttack = 85,
				hCruise = 50,
				hAttack = 50,
				standoff = 6000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{B919B0F4-7C25-455E-9A02-CEA51DB895E3}",
						},
						[2] = {
							CLSID = "{B919B0F4-7C25-455E-9A02-CEA51DB895E3}",
						},
						[3] = {
							CLSID = "{6A4B9E69-64FE-439a-9163-3A87FB6A4D81}",
						},
						[4] = {
							CLSID = "{6A4B9E69-64FE-439a-9163-3A87FB6A4D81}",
						},
						[5] = {
							CLSID = "{B919B0F4-7C25-455E-9A02-CEA51DB895E3}",
						},
						[6] = {
							CLSID = "{B919B0F4-7C25-455E-9A02-CEA51DB895E3}",
						},
					},
					fuel = 1701,
					flare = 192,
					chaff = 0,
					gun = 100,
				},
			},
		},
		CSAR = {
			["test 80s"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { },
				code_loadout =  { "all" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 75,
				vAttack = 85,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{B919B0F4-7C25-455E-9A02-CEA51DB895E3}",
						},
						[2] = {
							CLSID = "{PTB_450}",
						},
						[5] = {
							CLSID = "{PTB_450}",
						},
						[6] = {
							CLSID = "{B919B0F4-7C25-455E-9A02-CEA51DB895E3}",
						},
						[8] = {
							CLSID = "KORD_12_7_MI24_R",
						},
					},
					fuel = 1701,
					flare = 192,
					chaff = 0,
					gun = 100,
				},
			},
			["80s - CSAR 2xFT+4xATGM_9M114+Gunner"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { },
				code_loadout =  { "IIW", "TF80sI", "WOC80", "WOT87" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 75,
				vAttack = 85,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{B919B0F4-7C25-455E-9A02-CEA51DB895E3}",
						},
						[2] = {
							CLSID = "{PTB_450}",
						},
						[5] = {
							CLSID = "{PTB_450}",
						},
						[6] = {
							CLSID = "{B919B0F4-7C25-455E-9A02-CEA51DB895E3}",
						},
						[8] = {
							CLSID = "KORD_12_7_MI24_R",
						},
					},
					fuel = 1701,
					flare = 192,
					chaff = 0,
					gun = 100,
				},
			},
			["90s - CSAR 2xFT+4xATGM_9M114+Gunner"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { },
				code_loadout =  { "Cyprus", "Crisis", "PG", "Caucasus", "TF", "WOB" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 75,
				vAttack = 85,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{2x9M120_Ataka_V}",
						},
						[2] = {
							CLSID = "{PTB_450}",
						},
						[5] = {
							CLSID = "{PTB_450}",
						},
						[6] = {
							CLSID = "{2x9M120_Ataka_V}",
						},
						[8] = {
							CLSID = "KORD_12_7_MI24_R",
						},
					},
					fuel = 1701,
					flare = 192,
					chaff = 0,
					gun = 100,
				},
			},
		},
		SAR = {
			["80s - SAR 2xFT+4xATGM_9M114+Gunner"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { },
				code_loadout =  {"IIW", "TF80sI", "WOC80", "WOT87", "PG" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 75,
				vAttack = 85,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{B919B0F4-7C25-455E-9A02-CEA51DB895E3}",
						},
						[2] = {
							CLSID = "{PTB_450}",
						},
						[5] = {
							CLSID = "{PTB_450}",
						},
						[6] = {
							CLSID = "{B919B0F4-7C25-455E-9A02-CEA51DB895E3}",
						},
						[8] = {
							CLSID = "KORD_12_7_MI24_R",
						},
					},
					fuel = 1701,
					flare = 192,
					chaff = 0,
					gun = 100,
				},
			},
			["90s - SAR 2xFT+4xATGM_9M114+Gunner"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { },
				code_loadout =  {"IIW", "Cyprus", "Crisis", "PG", "Caucasus", "TF", "WOB" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 75,
				vAttack = 85,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{2x9M120_Ataka_V}",
						},
						[2] = {
							CLSID = "{PTB_450}",
						},
						[5] = {
							CLSID = "{PTB_450}",
						},
						[6] = {
							CLSID = "{2x9M120_Ataka_V}",
						},
						[8] = {
							CLSID = "KORD_12_7_MI24_R",
						},
					},
					fuel = 1701,
					flare = 192,
					chaff = 0,
					gun = 100,
				},
			},
		},
		Escort = {
			["Escort 4x9M114, 4xAA-60"] = {
				attributes =  { },
				code_loadout =  { "Cyprus", "Caucasus", "WOB" },
				night = true,
				adverseWeather = true,
				range = 150000,
				firepower = 1,
				vCruise = 75,
				standoff = 6000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{2x9M120_Ataka_V}",
						},
						[2] = {
							CLSID = "{B0DBC591-0F52-4F7D-AD7B-51E67725FB81}",
						},
						[5] = {
							CLSID = "{275A2855-4A79-4B2D-B082-91EA2ADF4691}",
						},
						[6] = {
							CLSID = "{2x9M120_Ataka_V}",
						},
						[8] = {
							CLSID = "KORD_12_7_MI24_R",
						},
					},
					fuel = 1701,
					flare = 192,
					chaff = 0,
					gun = 100,
				},
			},
			["Escort 80s 8xATGM_AT6-Heat+ Gunpod + gunner"] = {
				attributes =  { },
				code_loadout =  { "IIW", "WOC80", "WOT87" },
				night = true,
				adverseWeather = true,
				range = 150000,
				firepower = 1,
				vCruise = 75,
				standoff = 6000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{B919B0F4-7C25-455E-9A02-CEA51DB895E3}",
						},
						[2] = {
							CLSID = "{2x9M220_Ataka_V}",
						},
						[3] = {
							CLSID = "GUV_YakB_GSHP",
						},
						[5] = {
							CLSID = "{B919B0F4-7C25-455E-9A02-CEA51DB895E3}",
						},
						[6] = {
							CLSID = "{B919B0F4-7C25-455E-9A02-CEA51DB895E3}",
						},
						[8] = {
							CLSID = "KORD_12_7_MI24_R",
						},
					},
					fuel = 1701,
					flare = 192,
					chaff = 0,
					gun = 100,
				},
			},
			["Escort 2xB8V20+4xATGM_AT9-Heat+4xATGM_AT9-AA"] = {
				attributes =  { },
				code_loadout =  { "Cyprus", "HWITC", "Crisis", "WOB" },
				night = true,
				adverseWeather = true,
				range = 150000,
				firepower = 1,
				vCruise = 75,
				standoff = 6000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{2x9M220_Ataka_V}",
						},
						[2] = {
							CLSID = "{2x9M120_Ataka_V}",
						},
						[3] = {
							CLSID = "GUV_YakB_GSHP",
						},
						[4] = {
							CLSID = "GUV_YakB_GSHP",
						},
						[5] = {
							CLSID = "{2x9M120_Ataka_V}",
						},
						[6] = {
							CLSID = "{2x9M220_Ataka_V}",
						},
					},
					fuel = 1701,
					flare = 192,
					chaff = 0,
					gun = 100,
				},
			},
		},
	},
	["Mi-8MT"] = {
		Strike = {
			["Strike Rockets"] = {
				minscore = 0.1,
				support = {
					Escort = false,
					SEAD = false,
				},
				attributes =  { "soft" },
				code_loadout =  { "All" },
				weaponType = "Rockets",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 400000,
				firepower = 1,
				vCruise = 63,
				vAttack = 72,
				hCruise = 50,
				hAttack = 50,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6A4B9E69-64FE-439a-9163-3A87FB6A4D81}",
						},
						[2] = {
							CLSID = "{6A4B9E69-64FE-439a-9163-3A87FB6A4D81}",
						},
						[3] = {
							CLSID = "{6A4B9E69-64FE-439a-9163-3A87FB6A4D81}",
						},
						[4] = {
							CLSID = "{6A4B9E69-64FE-439a-9163-3A87FB6A4D81}",
						},
						[5] = {
							CLSID = "{6A4B9E69-64FE-439a-9163-3A87FB6A4D81}",
						},
						[6] = {
							CLSID = "{6A4B9E69-64FE-439a-9163-3A87FB6A4D81}",
						},
						[7] = {
							CLSID = "KORD_12_7",
						},
						[8] = {
							CLSID = "PKT_7_62",
						},
					},
					fuel = 1929,
					flare = 128,
					chaff = 0,
					gun = 0,
				},
			},
		},
		CSAR = {
			["CSAR test"] = {
				minscore = 0.001,
				support = {
					Escort = false,
				},
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 63,
				vAttack = 72,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
						[8] = {
							CLSID = "PKT_7_62",
						},
						[7] = {
							CLSID = "KORD_12_7",
						},
					},
					fuel = 1929,
					flare = 128,
					chaff = 0,
					gun = 0,
				},
			},
		},
		SAR = {
			["SAR test"] = {
				minscore = 0.001,
				support = {
				},
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 63,
				vAttack = 72,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
						[8] = {
							CLSID = "PKT_7_62",
						},
						[7] = {
							CLSID = "KORD_12_7",
						},
					},
					fuel = 1929,
					flare = 128,
					chaff = 0,
					gun = 0,
				},
			},
		},
		Transport = {
			Default = {
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 63,
				vAttack = 72,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
						[8] = {
							CLSID = "PKT_7_62",
						},
						[7] = {
							CLSID = "KORD_12_7",
						},
					},
					fuel = 1929,
					flare = 128,
					chaff = 0,
					gun = 0,
				},
			},
		},
	},
	["Mi-28N"] = {
		Escort = {
			["Escort 12x9A4172, 40xS-8"] = {
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 150000,
				firepower = 1,
				vCruise = 75,
				standoff = 10000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{57232979-8B0F-4db7-8D9A-55197E06B0F5}",
						},
						[2] = {
							CLSID = "{6A4B9E69-64FE-439a-9163-3A87FB6A4D81}",
						},
						[3] = {
							CLSID = "{6A4B9E69-64FE-439a-9163-3A87FB6A4D81}",
						},
						[4] = {
							CLSID = "{57232979-8B0F-4db7-8D9A-55197E06B0F5}",
						},
					},
					fuel = 1500,
					flare = 128,
					chaff = 0,
					gun = 100,
				},
			},
			["Escort Strike LR 12x9A4172, FTx2"] = {
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 75,
				standoff = 10000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{57232979-8B0F-4db7-8D9A-55197E06B0F5}",
						},
						[2] = {
							CLSID = "{PTB_450}",
						},
						[3] = {
							CLSID = "{PTB_450}",
						},
						[4] = {
							CLSID = "{57232979-8B0F-4db7-8D9A-55197E06B0F5}",
						},
					},
					fuel = 1500,
					flare = 128,
					chaff = 0,
					gun = 100,
				},
			},
		},
		Strike = {
			["Strike 12x9A4172, 40xS-8"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "frontline" },
				code_loadout =  { "Caucasus" },
				expend = "Auto",
				adverseWeather = true,
				range = 150000,
				firepower = 1,
				vCruise = 75,
				vAttack = 85,
				hCruise = 50,
				hAttack = 50,
				standoff = 6000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{57232979-8B0F-4db7-8D9A-55197E06B0F5}",
						},
						[2] = {
							CLSID = "{6A4B9E69-64FE-439a-9163-3A87FB6A4D81}",
						},
						[3] = {
							CLSID = "{6A4B9E69-64FE-439a-9163-3A87FB6A4D81}",
						},
						[4] = {
							CLSID = "{57232979-8B0F-4db7-8D9A-55197E06B0F5}",
						},
					},
					fuel = 1500,
					flare = 128,
					chaff = 0,
					gun = 100,
				},
			},
			["Strike LR 12x9A4172, FTx2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "frontline" },
				code_loadout =  { "Caucasus" },
				expend = "Auto",
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 75,
				vAttack = 85,
				hCruise = 50,
				hAttack = 50,
				standoff = 10000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{57232979-8B0F-4db7-8D9A-55197E06B0F5}",
						},
						[2] = {
							CLSID = "{PTB_450}",
						},
						[3] = {
							CLSID = "{PTB_450}",
						},
						[4] = {
							CLSID = "{57232979-8B0F-4db7-8D9A-55197E06B0F5}",
						},
					},
					fuel = 1500,
					flare = 128,
					chaff = 0,
					gun = 100,
				},
			},
		},
	},
	["Mi-26"] = {
		CSAR = {
			["CSAR test"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 70,
				vAttack = 80,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
					},
					fuel = 9600,
					flare = 192,
					chaff = 0,
					gun = 100,
				},
			},
		},
		SAR = {
			["SAR test"] = {
				minscore = 0.3,
				support = {
				},
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 70,
				vAttack = 80,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
					},
					fuel = 9600,
					flare = 192,
					chaff = 0,
					gun = 100,
				},
			},
		},
		Transport = {
			Default = {
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 70,
				vAttack = 80,
				hCruise = 100,
				hAttack = 100,
				sortie_rate = 5,
				stores = {
					pylons = {
					},
					fuel = 9600,
					flare = 192,
					chaff = 0,
					gun = 100,
				},
			},
		},
	},
	["OH-58D"] = {
		Strike = {
			["Strike 4xAGM-114"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "frontline" },
				code_loadout =  { "Caucasus" },
				expend = "Auto",
				adverseWeather = true,
				range = 100000,
				firepower = 1,
				vCruise = 55,
				vAttack = 65,
				hCruise = 50,
				hAttack = 50,
				standoff = 8000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "AGM114x2_OH_58",
						},
						[2] = {
							CLSID = "AGM114x2_OH_58",
						},
					},
					fuel = 454,
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
			["Strike 2xAGM-114, M-3"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "frontline" },
				code_loadout =  { "Caucasus" },
				expend = "Auto",
				adverseWeather = true,
				range = 100000,
				firepower = 1,
				vCruise = 55,
				vAttack = 65,
				hCruise = 50,
				hAttack = 50,
				standoff = 8000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "oh-58-brauning",
						},
						[2] = {
							CLSID = "AGM114x2_OH_58",
						},
					},
					fuel = 454,
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
			["Strike 2xAGM-114, 7xHYDRA-70"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "frontline" },
				code_loadout =  { "Caucasus" },
				expend = "Auto",
				adverseWeather = true,
				range = 100000,
				firepower = 1,
				vCruise = 55,
				vAttack = 65,
				hCruise = 50,
				hAttack = 50,
				standoff = 8000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "AGM114x2_OH_58",
						},
						[2] = {
							CLSID = "M260_HYDRA",
						},
					},
					fuel = 454,
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
			["Strike All 4xAGM-114"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "soft", "SAM" },
				code_loadout =  { "Caucasus" },
				expend = "Auto",
				adverseWeather = true,
				range = 100000,
				firepower = 1,
				vCruise = 55,
				vAttack = 65,
				hCruise = 50,
				hAttack = 50,
				standoff = 8000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "AGM114x2_OH_58",
						},
						[2] = {
							CLSID = "AGM114x2_OH_58",
						},
					},
					fuel = 454,
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
			["Strike All 2xAGM-114, M-3"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "soft", "SAM" },
				code_loadout =  { "Caucasus" },
				expend = "Auto",
				adverseWeather = true,
				range = 100000,
				firepower = 1,
				vCruise = 55,
				vAttack = 65,
				hCruise = 50,
				hAttack = 50,
				standoff = 8000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "oh-58-brauning",
						},
						[2] = {
							CLSID = "AGM114x2_OH_58",
						},
					},
					fuel = 454,
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
			["Strike All 2xAGM-114, 7xHYDRA-70"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "soft", "SAM" },
				code_loadout =  { "Caucasus" },
				expend = "Auto",
				adverseWeather = true,
				range = 100000,
				firepower = 1,
				vCruise = 55,
				vAttack = 65,
				hCruise = 50,
				hAttack = 50,
				standoff = 8000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "AGM114x2_OH_58",
						},
						[2] = {
							CLSID = "M260_HYDRA",
						},
					},
					fuel = 454,
					flare = 30,
					chaff = 30,
					gun = 100,
				},
			},
		},
	},
	["UH-1H"] = {
		Strike = {
			["Cyprus Strike rockets"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "soft", "Structure" },
				code_loadout =  { "Cyprus", "HWITC", "WOB"},
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 80000,
				firepower = 1,
				vCruise = 55,
				vAttack = 60,
				hCruise = 50,
				hAttack = 50,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "M134_L",
						},
						[2] = {
							CLSID = "XM158_MK5",
						},
						[3] = {
							CLSID = "M60_SIDE_L",
						},
						[4] = {
							CLSID = "M60_SIDE_R",
						},
						[5] = {
							CLSID = "XM158_MK5",
						},
						[6] = {
							CLSID = "M134_R",
						},
					},
					fuel = 631,
					flare = 60,
					chaff = 0,
					gun = 100,
				},
			},
			["NAM Strike"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "soft", "Structure" },
				code_loadout =  { "NAM" },
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 150000,
				firepower = 1,
				vCruise = 55,
				vAttack = 60,
				hCruise = 50,
				hAttack = 50,
				sortie_rate = 6,
				stores = {
					pylons = {
						[5] = {
							CLSID = "M261_MK151",
						},
						[2] = {
							CLSID = "M261_MK151",
						},
						[4] = {
							CLSID = "M60_SIDE_R",
						},
						[3] = {
							CLSID = "M60_SIDE_L",
						},
					},
					fuel = 631,
					flare = 60,
					chaff = 0,
					gun = 100,
				},
				["AddPropAircraft"] = 
					{
						["SoloFlight"] = false,
						["ExhaustScreen"] = false,
						["GunnersAISkill"] = 90,
						["NetCrewControlPriority"] = 0,
						["EngineResource"] = 90,
					}, -- end of ["AddPropAircraft"]
			},
			["WOC Strike rockets"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "frontline" },
				code_loadout =  { "Crisis", "Caucasus", "WOC80"},
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 55,
				vAttack = 60,
				hCruise = 50,
				hAttack = 50,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "M134_L",
						},
						[2] = {
							CLSID = "XM158_MK5",
						},
						[3] = {
							CLSID = "M60_SIDE_L",
						},
						[4] = {
							CLSID = "M60_SIDE_R",
						},
						[5] = {
							CLSID = "XM158_MK5",
						},
						[6] = {
							CLSID = "M134_R",
						},
					},
					fuel = 631,
					flare = 60,
					chaff = 0,
					gun = 100,
				},
			},
		},
		CSAR = {
			["80s SAR Rocket He -  Door gunner M60"] = {
				minscore = 0.001,
				support = {
					-- Escort = true,
					-- SEAD = false,
				},
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 267000,
				firepower = 1,
				vCruise = 55,
				vAttack = 60,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
						[5] = {
							CLSID = "M261_MK151",
						},
						[2] = {
							CLSID = "M261_MK151",
						},
						[4] = {
							CLSID = "M60_SIDE_R",
						},
						[3] = {
							CLSID = "M60_SIDE_L",
						},
					},
					fuel = 631,
					flare = 60,
					chaff = 0,
					gun = 100,
				},
				["AddPropAircraft"] = 
					{
						["SoloFlight"] = false,
						["ExhaustScreen"] = false,
						["GunnersAISkill"] = 90,
						["NetCrewControlPriority"] = 0,
						["EngineResource"] = 90,
					}, -- end of ["AddPropAircraft"]
			},
		},
		SAR = {
			["80s SAR Rocket He -  Door gunner M60"] = {
				minscore = 0.001,
				support = {
				},
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 267000,
				firepower = 1,
				vCruise = 55,
				vAttack = 60,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
						[5] = {
							CLSID = "M261_MK151",
						},
						[2] = {
							CLSID = "M261_MK151",
						},
						[4] = {
							CLSID = "M60_SIDE_R",
						},
						[3] = {
							CLSID = "M60_SIDE_L",
						},
					},
					fuel = 631,
					flare = 60,
					chaff = 0,
					gun = 100,
				},
				["AddPropAircraft"] = 
					{
						["SoloFlight"] = false,
						["ExhaustScreen"] = false,
						["GunnersAISkill"] = 90,
						["NetCrewControlPriority"] = 0,
						["EngineResource"] = 90,
					}, -- end of ["AddPropAircraft"]
			},
		},
		Transport = {
			["Cyprus Default"] = {
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { },
				code_loadout =  { "All" },
				adverseWeather = true,
				range = 300000,
				firepower = 1,
				vCruise = 55,
				vAttack = 60,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
					},
					fuel = 631,
					flare = 60,
					chaff = 0,
					gun = 100,
				},
			},
		},
	},
	["OH58D"] = {
		Strike = {
			["NAM Strike Rockets Gun"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				country = {
					[1] = "USA",
				},
				attributes =  { "soft" },
				code_loadout =  { "NAM" },
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 150000,
				firepower = 1,
				vCruise = 55,
				vAttack = 60,
				hCruise = 50,
				hAttack = 50,
				standoff = 1000,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = 
				{
				["CLSID"] = "OH58D_M3P_L300",
				}, -- end of [1]
				[2] = {
					["CLSID"] = "OH58D_Green_Smoke_Grenade",
				},
				[3] = {
					["CLSID"] = "OH58D_Red_Smoke_Grenade",
				},
				[4] = {
					["CLSID"] = "OH58D_Blue_Smoke_Grenade",
				},
				[5] = 
				{
				["CLSID"] = "{M260_M151}",
				}, -- end of [5]
					},
					fuel = 333.69,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
				["AddPropAircraft"] = 
				{
				["MMS removal"] = true,
				["Remove doors"] = true,
				["Rapid Deployment Gear"] = false,
				["ALQ144"] = false,
				["PDU"] = false,
				["tacNet"] = 1,
				}, -- end of ["AddPropAircraft"]
			},
			["AG - AGM-114Kx2 - GP500"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				country = {
					[1] = "USA",
				},
				attributes =  { "soft" },
				code_loadout =  { "Caucasus", "Crisis" },
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 55,
				vAttack = 60,
				hCruise = 50,
				hAttack = 50,
				standoff = 8000,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "OH58D_AGM_114_R",
					["num"] = 5,
				},
				[2] = {
					["CLSID"] = "OH58D_M3P_L500",
					["num"] = 1,
				},
				[3] = {
					["CLSID"] = "OH58D_Green_Smoke_Grenade",
					["num"] = 4,
				},
				[4] = {
					["CLSID"] = "OH58D_Red_Smoke_Grenade",
					["num"] = 3,
				},
				[5] = {
					["CLSID"] = "OH58D_Blue_Smoke_Grenade",
					["num"] = 2,
				},
					},
					fuel = 333.69,
					flare = 30,
					chaff = 0,
					gun = 100,
				},
			},
			["AG - APKWSx7 - GP500"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				country = {
					[1] = "USA",
				},
				attributes =  { "soft" },
				code_loadout =  { "Caucasus", "Crisis" },
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 55,
				vAttack = 60,
				hCruise = 50,
				hAttack = 50,
				standoff = 6000,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{M260_APKWS_M151}",
					["num"] = 5,
				},
				[2] = {
					["CLSID"] = "OH58D_M3P_L500",
					["num"] = 1,
				},
				[3] = {
					["CLSID"] = "OH58D_Green_Smoke_Grenade",
					["num"] = 4,
				},
				[4] = {
					["CLSID"] = "OH58D_Red_Smoke_Grenade",
					["num"] = 3,
				},
				[5] = {
					["CLSID"] = "OH58D_Blue_Smoke_Grenade",
					["num"] = 2,
				},
					},
					fuel = 333.69,
					flare = 30,
					chaff = 0,
					gun = 100,
				},
			},
			["AG - AGM-114x2 - APKWSx7"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				country = {
					[1] = "USA",
				},
				attributes =  { "soft" },
				code_loadout =  { "Caucasus", "Crisis" },
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 55,
				vAttack = 60,
				hCruise = 50,
				hAttack = 50,
				standoff = 6000,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "OH58D_AGM_114_R",
					["num"] = 5,
				},
				[2] = {
					["CLSID"] = "{M260_APKWS_M151}",
					["num"] = 1,
				},
				[3] = {
					["CLSID"] = "OH58D_Green_Smoke_Grenade",
					["num"] = 4,
				},
				[4] = {
					["CLSID"] = "OH58D_Red_Smoke_Grenade",
					["num"] = 3,
				},
				[5] = {
					["CLSID"] = "OH58D_Blue_Smoke_Grenade",
					["num"] = 2,
				},
					},
					fuel = 333.69,
					flare = 30,
					chaff = 0,
					gun = 100,
				},
			},
			["AG - AGM-114x4"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				country = {
					[1] = "USA",
				},
				attributes =  { "soft" },
				code_loadout =  { "Caucasus", "Crisis" },
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 55,
				vAttack = 60,
				hCruise = 50,
				hAttack = 50,
				standoff = 8000,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "OH58D_AGM_114_R",
					["num"] = 5,
				},
				[2] = {
					["CLSID"] = "OH58D_AGM_114_L",
					["num"] = 1,
				},
				[3] = {
					["CLSID"] = "OH58D_Green_Smoke_Grenade",
					["num"] = 4,
				},
				[4] = {
					["CLSID"] = "OH58D_Red_Smoke_Grenade",
					["num"] = 3,
				},
				[5] = {
					["CLSID"] = "OH58D_Blue_Smoke_Grenade",
					["num"] = 2,
				},
					},
					fuel = 333.69,
					flare = 30,
					chaff = 0,
					gun = 100,
				},
			},
		},
		Escort = {
			["AA escort - Stingerx2 - GP500"] = {
				country = {
					[1] = "USA",
				},
				attributes =  { },
				code_loadout =  { "Caucasus", "Crisis" },
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 60,
				standoff = 3000,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "OH58D_FIM_92_R",
					["num"] = 5,
				},
				[2] = {
					["CLSID"] = "OH58D_M3P_L500",
					["num"] = 1,
				},
				[3] = {
					["CLSID"] = "OH58D_Green_Smoke_Grenade",
					["num"] = 4,
				},
				[4] = {
					["CLSID"] = "OH58D_Red_Smoke_Grenade",
					["num"] = 3,
				},
				[5] = {
					["CLSID"] = "OH58D_Blue_Smoke_Grenade",
					["num"] = 2,
				},
					},
					fuel = 333.69,
					flare = 30,
					chaff = 0,
					gun = 100,
				},
			},
		},
		CSAR = {
			["NAM CSAR"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				country = {
					[1] = "USA",
				},
				attributes =  { "soft" },
				code_loadout =  { "NAM" },
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 55,
				vAttack = 60,
				hCruise = 50,
				hAttack = 50,
				standoff = 1000,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = 
				{
				["CLSID"] = "OH58D_M3P_L300",
				}, -- end of [1]
				[2] = {
					["CLSID"] = "OH58D_Green_Smoke_Grenade",
				},
				[3] = {
					["CLSID"] = "OH58D_Red_Smoke_Grenade",
				},
				[4] = {
					["CLSID"] = "OH58D_Blue_Smoke_Grenade",
				},
				[5] = 
				{
				["CLSID"] = "{M260_M151}",
				}, -- end of [5]
					},
					fuel = 333.69,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
				["AddPropAircraft"] = 
				{
				["MMS removal"] = true,
				["Remove doors"] = true,
				["Rapid Deployment Gear"] = false,
				["ALQ144"] = false,
				["PDU"] = false,
				["tacNet"] = 1,
				}, -- end of ["AddPropAircraft"]
			},
			["CSAR - APKWSx7 - GP500"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				country = {
					[1] = "USA",
				},
				attributes =  { },
				code_loadout =  { "Caucasus", "Crisis" },
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 55,
				vAttack = 60,
				hCruise = 500,
				hAttack = 500,
				standoff = 6000,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{M260_APKWS_M151}",
					["num"] = 5,
				},
				[2] = {
					["CLSID"] = "OH58D_M3P_L500",
					["num"] = 1,
				},
				[3] = {
					["CLSID"] = "OH58D_Green_Smoke_Grenade",
					["num"] = 4,
				},
				[4] = {
					["CLSID"] = "OH58D_Red_Smoke_Grenade",
					["num"] = 3,
				},
				[5] = {
					["CLSID"] = "OH58D_Blue_Smoke_Grenade",
					["num"] = 2,
				},
					},
					fuel = 333.69,
					flare = 30,
					chaff = 0,
					gun = 100,
				},
			},
		},
		SAR = {
			["NAM SAR"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				country = {
					[1] = "USA",
				},
				attributes =  { "soft" },
				code_loadout =  { "NAM" },
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 55,
				vAttack = 60,
				hCruise = 50,
				hAttack = 50,
				standoff = 1000,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = 
				{
				["CLSID"] = "OH58D_M3P_L300",
				}, -- end of [1]
				[2] = {
					["CLSID"] = "OH58D_Green_Smoke_Grenade",
				},
				[3] = {
					["CLSID"] = "OH58D_Red_Smoke_Grenade",
				},
				[4] = {
					["CLSID"] = "OH58D_Blue_Smoke_Grenade",
				},
				[5] = 
				{
				["CLSID"] = "{M260_M151}",
				}, -- end of [5]
					},
					fuel = 333.69,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
				["AddPropAircraft"] = 
				{
				["MMS removal"] = true,
				["Remove doors"] = true,
				["Rapid Deployment Gear"] = false,
				["ALQ144"] = false,
				["PDU"] = false,
				["tacNet"] = 1,
				}, -- end of ["AddPropAircraft"]
			},
			["SAR - APKWSx7 - GP500"] = {
				minscore = 0.3,
				support = {
				},
				country = {
					[1] = "USA",
				},
				attributes =  { },
				code_loadout =  { "Caucasus", "Crisis" },
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 55,
				vAttack = 60,
				hCruise = 500,
				hAttack = 500,
				standoff = 6000,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{M260_APKWS_M151}",
					["num"] = 5,
				},
				[2] = {
					["CLSID"] = "OH58D_M3P_L500",
					["num"] = 1,
				},
				[3] = {
					["CLSID"] = "OH58D_Green_Smoke_Grenade",
					["num"] = 4,
				},
				[4] = {
					["CLSID"] = "OH58D_Red_Smoke_Grenade",
					["num"] = 3,
				},
				[5] = {
					["CLSID"] = "OH58D_Blue_Smoke_Grenade",
					["num"] = 2,
				},
					},
					fuel = 333.69,
					flare = 30,
					chaff = 0,
					gun = 100,
				},
			},
		},
		Transport = {
			["NAM transport"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				country = {
					[1] = "USA",
				},
				attributes =  { "soft" },
				code_loadout =  { "NAM" },
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 55,
				vAttack = 60,
				hCruise = 50,
				hAttack = 50,
				sortie_rate = 6,
				stores = {
					pylons = {				
				[2] = {
					["CLSID"] = "OH58D_Green_Smoke_Grenade",
				},
				[3] = {
					["CLSID"] = "OH58D_Red_Smoke_Grenade",
				},
				[4] = {
					["CLSID"] = "OH58D_Blue_Smoke_Grenade",
				},
				[5] = 
				{
				["CLSID"] = "{M260_M151}",
				}, -- end of [5]
					},
					fuel = 333.69,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
				["AddPropAircraft"] = 
				{
				["MMS removal"] = true,
				["Remove doors"] = true,
				["Rapid Deployment Gear"] = false,
				["ALQ144"] = false,
				["PDU"] = false,
				["tacNet"] = 1,
				}, -- end of ["AddPropAircraft"]
			},
			["Transport - APKWSx7 - GP500"] = {
				support = {
					Escort = true,
					SEAD = false,
				},
				country = {
					[1] = "USA",
				},
				attributes =  { },
				code_loadout =  { "Caucasus", "Crisis" },
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 55,
				vAttack = 60,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{M260_APKWS_M151}",
					["num"] = 5,
				},
				[2] = {
					["CLSID"] = "OH58D_M3P_L500",
					["num"] = 1,
				},
				[3] = {
					["CLSID"] = "OH58D_Green_Smoke_Grenade",
					["num"] = 4,
				},
				[4] = {
					["CLSID"] = "OH58D_Red_Smoke_Grenade",
					["num"] = 3,
				},
				[5] = {
					["CLSID"] = "OH58D_Blue_Smoke_Grenade",
					["num"] = 2,
				},
					},
					fuel = 333.69,
					flare = 30,
					chaff = 0,
					gun = 100,
				},
			},
		},
	},
	["uh2a"] = {
		CSAR = {
			["CSAR uh2a"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 40,
				vAttack = 40,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
					[1] = 
					{
					["CLSID"] = "{UH2A_FUEL_TANK_120R}",
					}, -- end of [1]
					[2] = 
					{
					["CLSID"] = "{UH2A_FUEL_TANK_120L}",
					}, -- end of [2]
					},
					fuel = 631,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		SAR = {
			["SAR uh2a"] = {
				minscore = 0.3,
				support = {
				},
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 40,
				vAttack = 40,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
					[1] = 
					{
					["CLSID"] = "{UH2A_FUEL_TANK_120R}",
					}, -- end of [1]
					[2] = 
					{
					["CLSID"] = "{UH2A_FUEL_TANK_120L}",
					}, -- end of [2]
					},
					fuel = 631,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		Transport = {
			["Transport uh2a"] = {
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { },
				code_loadout =  { "All" },
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 40,
				vAttack = 40,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
					[1] = 
					{
					["CLSID"] = "{UH2A_FUEL_TANK_120R}",
					}, -- end of [1]
					[2] = 
					{
					["CLSID"] = "{UH2A_FUEL_TANK_120L}",
					}, -- end of [2]
					},
					fuel = 631,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
	},
	["uh2b"] = {
		CSAR = {
			["CSAR uh2b"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 40,
				vAttack = 40,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
					[1] = 
					{
					["CLSID"] = "{UH2B_FUEL_TANK_120R}",
					}, -- end of [1]
					[2] = 
					{
					["CLSID"] = "{UH2B_FUEL_TANK_120L}",
					}, -- end of [2]
					},
					fuel = 631,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		SAR = {
			["SAR uh2b"] = {
				minscore = 0.3,
				support = {
				},
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 40,
				vAttack = 40,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
					[1] = 
					{
					["CLSID"] = "{UH2B_FUEL_TANK_120R}",
					}, -- end of [1]
					[2] = 
					{
					["CLSID"] = "{UH2B_FUEL_TANK_120L}",
					}, -- end of [2]
					},
					fuel = 631,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		Transport = {
			["Transport uh2b"] = {
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { },
				code_loadout =  { "All" },
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 40,
				vAttack = 40,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
					[1] = 
					{
					["CLSID"] = "{UH2B_FUEL_TANK_120R}",
					}, -- end of [1]
					[2] = 
					{
					["CLSID"] = "{UH2B_FUEL_TANK_120L}",
					}, -- end of [2]
					},
					fuel = 631,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
	},
	["uh2c"] = {
		CSAR = {
			["CSAR uh2c"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 40,
				vAttack = 40,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
					[1] = 
					{
					["CLSID"] = "{UH2C_FUEL_TANK_120R}",
					}, -- end of [1]
					[2] = 
					{
					["CLSID"] = "{UH2C_FUEL_TANK_120L}",
					}, -- end of [2]
					},
					fuel = 631,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		SAR = {
			["SAR uh2c"] = {
				minscore = 0.3,
				support = {
				},
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 40,
				vAttack = 40,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
					[1] = 
					{
					["CLSID"] = "{UH2C_FUEL_TANK_120R}",
					}, -- end of [1]
					[2] = 
					{
					["CLSID"] = "{UH2C_FUEL_TANK_120L}",
					}, -- end of [2]
					},
					fuel = 631,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		Transport = {
			["Transport uh2c"] = {
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { },
				code_loadout =  { "All" },
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 40,
				vAttack = 40,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
					[1] = 
					{
					["CLSID"] = "{UH2C_FUEL_TANK_120R}",
					}, -- end of [1]
					[2] = 
					{
					["CLSID"] = "{UH2C_FUEL_TANK_120L}",
					}, -- end of [2]
					},
					fuel = 631,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
	},
	["uh2f"] = {
		CSAR = {
			["CSAR SH-2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 40,
				vAttack = 40,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
					},
					fuel = 1100,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		SAR = {
			["SAR SH-2"] = {
				minscore = 0.3,
				support = {
				},
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 40,
				vAttack = 40,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
					},
					fuel = 1100,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
		Transport = {
			["transport SH-2"] = {
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { },
				code_loadout =  { "All" },
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 40,
				vAttack = 40,
				hCruise = 500,
				hAttack = 500,
				sortie_rate = 6,
				stores = {
					pylons = {
					},
					fuel = 1100,
					flare = 0,
					chaff = 0,
					gun = 100,
				},
			},
		},
	},

}