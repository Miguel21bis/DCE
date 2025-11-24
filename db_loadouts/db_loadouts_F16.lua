--Loadouts database
--F16 loadouts
-------------------------------------------------------------------------------------------------------

if not versionDCE then versionDCE = {} end
versionDCE["loadouts_data/db_loadouts_F16.lua"] = "1.1.1"

-- 1.1.1 - Beginning of the versions of this loadouts file dedicated to the F4.

db_loadouts = {
	["F-16C bl.52d"] = {
		Strike = {
			["Strike 2*AIM9M, 2*AIM120B, 2*GBU-38, ECM, 2*FT"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "PG" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7000,
				hAttack = 7100,
				standoff = 20000,
				LDSD = true,
				sortie_rate = 2,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[3] = {
							CLSID = "{GBU-38}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "{CAAC1CFD-6745-416B-AFA4-CB57414856D0}",
						},
						[6] = {
							CLSID = "ALQ_184",
						},
						[7] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[8] = {
							CLSID = "{GBU-38}",
						},
						[9] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[10] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = 3104,
					flare = 45,
					chaff = 90,
					gun = 100,
				},
			},
			["Mk-82*6, AIM-9M*2, AIM-120B*2, Fuel*2, ECM"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Structure", "soft", "Parked Aircraft" },
				code_loadout =  { "PG" },
				weaponType = "Bombs",
				expend = "All",
								range = 500000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 5486.4,
				hAttack = 4572,
				LDSD = true,
				sortie_rate = 2,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[3] = {
							CLSID = "{60CC734F-0AFA-4E2E-82B8-93B941AB11CF}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[6] = {
							CLSID = "ALQ_184",
						},
						[7] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[8] = {
							CLSID = "{60CC734F-0AFA-4E2E-82B8-93B941AB11CF}",
						},
						[9] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[10] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = 3104,
					flare = 45,
					chaff = 90,
					gun = 100,
				},
			},
			["Strike GBU-12, AIM-9M*2, AIM-120B*2, Fuel*2, ECM"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Bridge" },
				code_loadout =  { "PG" },
				weaponType = "Guided bombs",
				expend = "Auto",
								range = 500000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7000,
				hAttack = 7100,
				LDSD = true,
				sortie_rate = 2,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[3] = {
							CLSID = "{89D000B0-0360-461A-AD83-FB727E2ABA98}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
						[6] = {
							CLSID = "ALQ_184",
						},
						[7] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[8] = {
							CLSID = "{BRU-42_2xGBU-12_right}",
						},
						[9] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[10] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = 3104,
					flare = 45,
					chaff = 90,
					gun = 100,
				},
			},
			["Strike 2*AIM9M, 2*AIM120B, 2*GBU-31, ECM, 2*FT"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Structure", "Bridge" },
				code_loadout =  { "PG" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7000,
				hAttack = 7100,
				standoff = 20000,
				LDSD = true,
				sortie_rate = 2,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[3] = {
							CLSID = "{GBU-31}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "{CAAC1CFD-6745-416B-AFA4-CB57414856D0}",
						},
						[6] = {
							CLSID = "ALQ_184",
						},
						[7] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[8] = {
							CLSID = "{GBU-31}",
						},
						[9] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[10] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = 3104,
					flare = 45,
					chaff = 90,
					gun = 100,
				},
			},
			["Strike GBU-10, AIM-9M*2, AIM-120B*2, Fuel*2, ECM"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Structure", "Bridge" },
				code_loadout =  { "PG" },
				weaponType = "Guided bombs",
				expend = "Auto",
								range = 500000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7000,
				hAttack = 7100,
				LDSD = true,
				sortie_rate = 2,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[3] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
						[6] = {
							CLSID = "ALQ_184",
						},
						[7] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[8] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[9] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[10] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = 3104,
					flare = 45,
					chaff = 90,
					gun = 100,
				},
			},
			["Mk-84*2, AIM-9M*2, AIM-120B*2, Fuel*2, ECM"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Structure" },
				code_loadout =  { "PG" },
				weaponType = "Bombs",
				expend = "All",
								range = 500000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 5486.4,
				hAttack = 4572,
				LDSD = true,
				sortie_rate = 1,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[3] = {
							CLSID = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[6] = {
							CLSID = "ALQ_184",
						},
						[7] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[8] = {
							CLSID = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
						},
						[9] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[10] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = 3104,
					flare = 45,
					chaff = 90,
					gun = 100,
				},
			},
		},
		SEAD = {
			["AGM-45*2, AIM-9M*2, AIM-120B*2, ECM*1, Fuel*2"] = {
				attributes =  { },
				code_loadout =  { "PG" },
				weaponType = "ASM",
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 270,
				vAttack = 270,
				hCruise = 6096,
				hAttack = 6096,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[3] = {
							CLSID = "{3E6B632D-65EB-44D2-9501-1C2D04515405}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "{CAAC1CFD-6745-416B-AFA4-CB57414856D0}",
						},
						[6] = {
							CLSID = "ALQ_184",
						},
						[7] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[8] = {
							CLSID = "{3E6B632D-65EB-44D2-9501-1C2D04515405}",
						},
						[9] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[10] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = 3104,
					flare = 45,
					chaff = 90,
					gun = 100,
				},
			},
		},
		["Laser Illumination"] = {
			["Laser Illumination"] = {
				attributes =  { },
				code_loadout =  { "PG" },
				night = true,
				range = 900000,
				firepower = 1,
				vCruise = 270,
				vAttack = 300,
				hCruise = 7096,
				hAttack = 7096,
				sortie_rate = 8,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[3] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
						[6] = {
							CLSID = "ALQ_184",
						},
						[7] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[8] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[9] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[10] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = 3104,
					flare = 45,
					chaff = 90,
					gun = 100,
				},
			},
		},
	},

	["F-16C_50"] = {
		Strike = {
			["Strike 90s SR AG GBU31*2,AIM-120B*2, AIM-9M*2, FT*1,TP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Structure", "Bridge" },
				code_loadout =  { "PG" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 250000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7000,
				hAttack = 7100,
				standoff = 20000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[2] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[3] = {
							CLSID = "{GBU-31V3B}",
						},
						[4] = {
							CLSID = "<CLEAN>",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "<CLEAN>",
						},
						[7] = {
							CLSID = "{GBU-31V3B}",
						},
						[8] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[9] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[11] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s SR AG AGM65D*4,AIM-120C*2, AIM-9X*2, FT*1,TP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "frontline" },
				code_loadout =  { "Caucasus", "WOB" },
				weaponType = "ASM",
				expend = "Auto",
								range = 150000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7000,
				hAttack = 7100,
				standoff = 10000,
				LDSD = true,
				sortie_rate = 8,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[2] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[3] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98452}",
						},
						[4] = {
							CLSID = "<CLEAN>",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "<CLEAN>",
						},
						[7] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98453}",
						},
						[8] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[9] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[11] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s LR AG GBU31*2,AIM-120C*2, AIM-9X*2, FT*3,TP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Structure", "Bridge" },
				code_loadout =  { "Caucasus", "WOB" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 450000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7000,
				hAttack = 7100,
				standoff = 20000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[2] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[3] = {
							CLSID = "{GBU-31V3B}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{GBU-31V3B}",
						},
						[8] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[9] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[11] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["CBU-97*4, AIM-120B*2, AIM-9L*2, FT*3,pod"] = {
				minscore = 0.4,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "Cyprus" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				range = 500000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 5486.4,
				hAttack = 4572,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[2] = {
							CLSID = "{AIM-9L}",
						},
						[3] = {
							CLSID = "{TER_9A_2L*CBU-97}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{TER_9A_2R*CBU-97}",
						},
						[8] = {
							CLSID = "{AIM-9L}",
						},
						[9] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s SR AG GBU38*4,AIM-120C*2, AIM-9X*2, FT*1,TP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "frontline" },
				code_loadout =  { "Caucasus", "WOB" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 250000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7000,
				hAttack = 7100,
				standoff = 20000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[2] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[3] = {
							CLSID = "{BRU57_2*GBU-38}",
						},
						[4] = {
							CLSID = "<CLEAN>",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "<CLEAN>",
						},
						[7] = {
							CLSID = "{BRU57_2*GBU-38}",
						},
						[8] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[9] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[11] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 90s SR AG GBU10*4,AIM-120B*2, AIM-9M*2, FT*1,TP"] = {
				minscore = 0.4,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Structure", "Bridge" },
				code_loadout =  { "Crisis", "PG" },
				weaponType = "Guided bombs",
				expend = "Auto",
								range = 250000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7000,
				hAttack = 7100,
				standoff = 15000,
				LDSD = true,
				sortie_rate = 8,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[2] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[3] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[4] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[7] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[8] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[9] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[11] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 80s LR AG GBU12*4,AIM-9M*4, FT*3,TP"] = {
				minscore = 0.4,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Bridge", "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { },
				weaponType = "Guided bombs",
				expend = "Auto",
								range = 450000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7000,
				hAttack = 7100,
				standoff = 15000,
				LDSD = true,
				sortie_rate = 8,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{AIM-9L}",
						},
						[3] = {
							CLSID = "{TER_9A_2L*GBU-12}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{TER_9A_2R*GBU-12}",
						},
						[8] = {
							CLSID = "{AIM-9L}",
						},
						[9] = {
							CLSID = "{AIM-9L}",
						},
						[11] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 90s LR AG AGM65D*4,AIM-120B*2, AIM-9M*2, FT*3,TP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "Crisis", "PG" },
				weaponType = "ASM",
				expend = "Auto",
								range = 450000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7000,
				hAttack = 7100,
				standoff = 10000,
				LDSD = true,
				sortie_rate = 8,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[2] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[3] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98452}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98453}",
						},
						[8] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[9] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[11] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 90s LR AG GBU31*2,AIM-120B*2, AIM-9M*2, FT*3,TP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Structure", "Bridge" },
				code_loadout =  { "PG" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 450000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7000,
				hAttack = 7100,
				standoff = 20000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[2] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[3] = {
							CLSID = "{GBU-31V3B}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{GBU-31V3B}",
						},
						[8] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[9] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[11] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s LR AG GBU10*2,AIM-120C*2, AIM-9X*2, FT*3,TP"] = {
				minscore = 0.4,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Structure", "Bridge" },
				code_loadout =  { "Caucasus", "WOB" },
				weaponType = "Guided bombs",
				expend = "Auto",
								range = 450000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7000,
				hAttack = 7100,
				standoff = 15000,
				LDSD = true,
				sortie_rate = 8,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[2] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[3] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[8] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[9] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[11] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 80s SR AG GBU10*4,AIM-9M*4, FT*1,TP"] = {
				minscore = 0.4,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Structure", "Bridge" },
				code_loadout =  { },
				weaponType = "Guided bombs",
				expend = "Auto",
								range = 250000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7000,
				hAttack = 7100,
				standoff = 15000,
				LDSD = true,
				sortie_rate = 8,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{AIM-9L}",
						},
						[3] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[4] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[7] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[8] = {
							CLSID = "{AIM-9L}",
						},
						[9] = {
							CLSID = "{AIM-9L}",
						},
						[11] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 90s SR AG GBU12*6,AIM-120B*2, AIM-9M*2, FT*1,TP"] = {
				minscore = 0.4,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Bridge", "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "Crisis" },
				weaponType = "Guided bombs",
				expend = "Auto",
								range = 150000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7000,
				hAttack = 7100,
				standoff = 15000,
				LDSD = true,
				sortie_rate = 8,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[2] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[3] = {
							CLSID = "{TER_9A_2L*GBU-12}",
						},
						[4] = {
							CLSID = "{DB769D48-67D7-42ED-A2BE-108D566C8B1E}",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "{DB769D48-67D7-42ED-A2BE-108D566C8B1E}",
						},
						[7] = {
							CLSID = "{TER_9A_2R*GBU-12}",
						},
						[8] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[9] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[11] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 90s LR AG GBU12*4,AIM-120B*2, AIM-9M*2, FT*3,TP"] = {
				minscore = 0.4,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Bridge", "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "Crisis" },
				weaponType = "Guided bombs",
				expend = "Auto",
								range = 450000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7000,
				hAttack = 7100,
				standoff = 15000,
				LDSD = true,
				sortie_rate = 8,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[2] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[3] = {
							CLSID = "{TER_9A_2L*GBU-12}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{TER_9A_2R*GBU-12}",
						},
						[8] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[9] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[11] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 80s SR AG AGM65D*4, AIM-9L*4, FT*1,TP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { },
				weaponType = "ASM",
				expend = "Auto",
								range = 150000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7000,
				hAttack = 7100,
				standoff = 10000,
				LDSD = true,
				sortie_rate = 8,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{AIM-9L}",
						},
						[3] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98452}",
						},
						[4] = {
							CLSID = "<CLEAN>",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "<CLEAN>",
						},
						[7] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98453}",
						},
						[8] = {
							CLSID = "{AIM-9L}",
						},
						[9] = {
							CLSID = "{AIM-9L}",
						},
						[11] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 90s LR AG GBU10*2,AIM-120B*2, AIM-9M*2, FT*3,TP"] = {
				minscore = 0.4,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Structure", "Bridge" },
				code_loadout =  { "Crisis", "PG" },
				weaponType = "Guided bombs",
				expend = "Auto",
								range = 450000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7000,
				hAttack = 7100,
				standoff = 15000,
				LDSD = true,
				sortie_rate = 8,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[2] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[3] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[8] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[9] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[11] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s SR AG GBU31*2,AIM-120C*2, AIM-9X*2, FT*1,TP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Structure", "Bridge" },
				code_loadout =  { "Caucasus", "WOB" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 250000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7000,
				hAttack = 7100,
				standoff = 20000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[2] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[3] = {
							CLSID = "{GBU-31V3B}",
						},
						[4] = {
							CLSID = "<CLEAN>",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "<CLEAN>",
						},
						[7] = {
							CLSID = "{GBU-31V3B}",
						},
						[8] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[9] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[11] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s SR AG GBU10*4,AIM-120C*2, AIM-9X*2, FT*1,TP"] = {
				minscore = 0.4,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Structure", "Bridge" },
				code_loadout =  { "Caucasus", "WOB" },
				weaponType = "Guided bombs",
				expend = "Auto",
								range = 250000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7000,
				hAttack = 7100,
				standoff = 15000,
				LDSD = true,
				sortie_rate = 8,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[2] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[3] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[4] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[7] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[8] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[9] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[11] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 80s SR AG GBU12*4,AIM-9M*4, FT*1,TP"] = {
				minscore = 0.4,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Bridge", "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { },
				weaponType = "Guided bombs",
				expend = "Auto",
								range = 250000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7000,
				hAttack = 7100,
				standoff = 15000,
				LDSD = true,
				sortie_rate = 8,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{AIM-9L}",
						},
						[3] = {
							CLSID = "{TER_9A_2L*GBU-12}",
						},
						[4] = {
							CLSID = "{DB769D48-67D7-42ED-A2BE-108D566C8B1E}",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "{DB769D48-67D7-42ED-A2BE-108D566C8B1E}",
						},
						[7] = {
							CLSID = "{TER_9A_2R*GBU-12}",
						},
						[8] = {
							CLSID = "{AIM-9L}",
						},
						[9] = {
							CLSID = "{AIM-9L}",
						},
						[11] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s SR AG GBU12*6,AIM-120C*2, AIM-9X*2, FT*1,TP"] = {
				minscore = 0.4,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Bridge", "soft", "Parked Aircraft", "SAM", "frontline" },
				code_loadout =  { "Caucasus" },
				weaponType = "Guided bombs",
				expend = "Auto",
								range = 150000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7000,
				hAttack = 7100,
				standoff = 15000,
				LDSD = true,
				sortie_rate = 8,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[2] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[3] = {
							CLSID = "{TER_9A_2L*GBU-12}",
						},
						[4] = {
							CLSID = "{DB769D48-67D7-42ED-A2BE-108D566C8B1E}",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "{DB769D48-67D7-42ED-A2BE-108D566C8B1E}",
						},
						[7] = {
							CLSID = "{TER_9A_2R*GBU-12}",
						},
						[8] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[9] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[11] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike Turkey Cyprus AG - AGM65D*4"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "Cyprus" },
				weaponType = "ASM",
				expend = "Auto",
								range = 500000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7000,
				hAttack = 7100,
				standoff = 10000,
				LDSD = true,
				sortie_rate = 8,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[2] = {
							CLSID = "{AIM-9L}",
						},
						[3] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98452}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98453}",
						},
						[8] = {
							CLSID = "{AIM-9L}",
						},
						[9] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike GBU-12*4, AIM-120B*2, AIM-9L*2, FUEL*2, TP"] = {
				minscore = 0.4,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Bridge", "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "Cyprus" },
				weaponType = "Guided bombs",
				expend = "Auto",
								range = 500000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7000,
				hAttack = 7100,
				standoff = 15000,
				LDSD = true,
				sortie_rate = 8,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[2] = {
							CLSID = "{AIM-9L}",
						},
						[3] = {
							CLSID = "{TER_9A_2L*GBU-12}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{TER_9A_2R*GBU-12}",
						},
						[8] = {
							CLSID = "{AIM-9L}",
						},
						[9] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[11] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s LR AG AGM65D*4,AIM-120C*2, AIM-9X*2, FT*3,TP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "frontline" },
				code_loadout =  { "Caucasus", "WOB" },
				weaponType = "ASM",
				expend = "Auto",
								range = 450000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7000,
				hAttack = 7100,
				standoff = 10000,
				LDSD = true,
				sortie_rate = 8,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[2] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[3] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98452}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98453}",
						},
						[8] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[9] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[11] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s LR AG GBU12*4,AIM-120C*2, AIM-9X*2, FT*3,TP"] = {
				minscore = 0.4,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Bridge", "soft", "Parked Aircraft", "SAM", "frontline" },
				code_loadout =  { "Caucasus" },
				weaponType = "Guided bombs",
				expend = "Auto",
								range = 450000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7000,
				hAttack = 7100,
				standoff = 15000,
				LDSD = true,
				sortie_rate = 8,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[2] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[3] = {
							CLSID = "{TER_9A_2L*GBU-12}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{TER_9A_2R*GBU-12}",
						},
						[8] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[9] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[11] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 90s LR AG GBU38*4,AIM-120B*2, AIM-9M*2, FT*3,TP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "PG" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 450000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7000,
				hAttack = 7100,
				standoff = 20000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[2] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[3] = {
							CLSID = "{BRU57_2*GBU-38}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{BRU57_2*GBU-38}",
						},
						[8] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[9] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[11] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 80s LR AG AGM65D*4, AIM-9L*4, FT*3,TP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { },
				weaponType = "ASM",
				expend = "Auto",
								range = 450000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7000,
				hAttack = 7100,
				standoff = 10000,
				LDSD = true,
				sortie_rate = 8,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{AIM-9L}",
						},
						[3] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98452}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98453}",
						},
						[8] = {
							CLSID = "{AIM-9L}",
						},
						[9] = {
							CLSID = "{AIM-9L}",
						},
						[11] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Mk-84*2, AIM-120B*2, AIM-9L*2, FUEL*3, Pod"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Structure" },
				code_loadout =  { "Cyprus" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				range = 500000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 5486.4,
				hAttack = 4572,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[2] = {
							CLSID = "{AIM-9L}",
						},
						[3] = {
							CLSID = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
						},
						[8] = {
							CLSID = "{AIM-9L}",
						},
						[9] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s LR AG GBU38*4,AIM-120C*2, AIM-9X*2, FT*3,TP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "frontline" },
				code_loadout =  { "Caucasus", "WOB" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 450000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7000,
				hAttack = 7100,
				standoff = 20000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[2] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[3] = {
							CLSID = "{BRU57_2*GBU-38}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{BRU57_2*GBU-38}",
						},
						[8] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[9] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[11] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 90s SR AG AGM65D*4,AIM-120B*2, AIM-9M*2, FT*1,TP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "Crisis", "PG" },
				weaponType = "ASM",
				expend = "Auto",
								range = 150000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7000,
				hAttack = 7100,
				standoff = 10000,
				LDSD = true,
				sortie_rate = 8,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[2] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[3] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98452}",
						},
						[4] = {
							CLSID = "<CLEAN>",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "<CLEAN>",
						},
						[7] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98453}",
						},
						[8] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[9] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[11] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 80s LR AG GBU10*2,AIM-9M*4, FT*3,TP"] = {
				minscore = 0.4,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Structure", "Bridge" },
				code_loadout =  { },
				weaponType = "Guided bombs",
				expend = "Auto",
								range = 450000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7000,
				hAttack = 7100,
				standoff = 15000,
				LDSD = true,
				sortie_rate = 8,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{AIM-9L}",
						},
						[3] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[8] = {
							CLSID = "{AIM-9L}",
						},
						[9] = {
							CLSID = "{AIM-9L}",
						},
						[11] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Mk-82HD*6 , AIM-120B*2, AIM-9L*2, FUEL*3, Pod"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "Cyprus" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				range = 500000,
				firepower = 1,
				vCruise = 245,
				vAttack = 315.5,
				hCruise = 3000.4,
				hAttack = 300,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[2] = {
							CLSID = "{AIM-9L}",
						},
						[3] = {
							CLSID = "{TER_9A_3*MK-82_Snakeye}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{TER_9A_3*MK-82_Snakeye}",
						},
						[8] = {
							CLSID = "{AIM-9L}",
						},
						[9] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 90s SR AG GBU38*4,AIM-120B*2, AIM-9M*2, FT*1,TP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "PG" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 250000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7000,
				hAttack = 7100,
				standoff = 20000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[2] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[3] = {
							CLSID = "{BRU57_2*GBU-38}",
						},
						[4] = {
							CLSID = "<CLEAN>",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "<CLEAN>",
						},
						[7] = {
							CLSID = "{BRU57_2*GBU-38}",
						},
						[8] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[9] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[11] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike GBU-10*2, AIM-120B*2, AIM-9L*2, FUEL*3, TP"] = {
				minscore = 0.4,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Structure", "Bridge" },
				code_loadout =  { "Cyprus" },
				weaponType = "Guided bombs",
				expend = "Auto",
								range = 500000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7000,
				hAttack = 7100,
				standoff = 15000,
				LDSD = true,
				sortie_rate = 8,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[2] = {
							CLSID = "{AIM-9L}",
						},
						[3] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[8] = {
							CLSID = "{AIM-9L}",
						},
						[9] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[11] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Mk-82*6, AIM-120B*2, AIM-9L*2, FUEL*3, Pod"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "Cyprus" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				range = 500000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 5486.4,
				hAttack = 4572,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[2] = {
							CLSID = "{AIM-9L}",
						},
						[3] = {
							CLSID = "{TER_9A_3*MK-82}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{TER_9A_3*MK-82}",
						},
						[8] = {
							CLSID = "{AIM-9L}",
						},
						[9] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
		},
		["Anti-ship Strike"] = {
			["90s LR AntiShip AGM65D*4,AIM-120B*2, AIM-9M*2, FT*3,TP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "ship" },
				code_loadout =  { "Crisis", "PG" },
				weaponType = "ASM",
				expend = "Auto",
								range = 450000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7000,
				hAttack = 7100,
				standoff = 10000,
				LDSD = true,
				sortie_rate = 8,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[2] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[3] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98452}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98453}",
						},
						[8] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[9] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[11] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["80s SR AntiShip AGM65D*4, AIM-9L*4, FT*1,TP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "ship" },
				code_loadout =  { },
				weaponType = "ASM",
				expend = "Auto",
								range = 250000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7000,
				hAttack = 7100,
				standoff = 10000,
				LDSD = true,
				sortie_rate = 8,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{AIM-9L}",
						},
						[3] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98452}",
						},
						[4] = {
							CLSID = "<CLEAN>",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "<CLEAN>",
						},
						[7] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98453}",
						},
						[8] = {
							CLSID = "{AIM-9L}",
						},
						[9] = {
							CLSID = "{AIM-9L}",
						},
						[11] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["90s SR AntiShip AGM65D*4,AIM-120B*2, AIM-9M*2, FT*1,TP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "ship" },
				code_loadout =  { "Crisis", "PG" },
				weaponType = "ASM",
				expend = "Auto",
								range = 250000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7000,
				hAttack = 7100,
				standoff = 10000,
				LDSD = true,
				sortie_rate = 8,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[2] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[3] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98452}",
						},
						[4] = {
							CLSID = "<CLEAN>",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "<CLEAN>",
						},
						[7] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98453}",
						},
						[8] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[9] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[11] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["2000s LR AntiShip AGM65D*4,AIM-120C*2, AIM-9X*2, FT*3,TP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "ship" },
				code_loadout =  { "Caucasus", "WOB" },
				weaponType = "ASM",
				expend = "Auto",
								range = 450000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7000,
				hAttack = 7100,
				standoff = 10000,
				LDSD = true,
				sortie_rate = 8,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[2] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[3] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98452}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98453}",
						},
						[8] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[9] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[11] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["2000s SR AntiShip AGM65D*4,AIM-120C*2, AIM-9X*2, FT*1,TP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "ship" },
				code_loadout =  { "Caucasus", "WOB" },
				weaponType = "ASM",
				expend = "Auto",
								range = 250000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7000,
				hAttack = 7100,
				standoff = 10000,
				LDSD = true,
				sortie_rate = 8,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[2] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[3] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98452}",
						},
						[4] = {
							CLSID = "<CLEAN>",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "<CLEAN>",
						},
						[7] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98453}",
						},
						[8] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[9] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[11] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["80s LR AntiShip AGM65D*4, AIM-9L*4, FT*3,TP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "ship" },
				code_loadout =  { },
				weaponType = "ASM",
				expend = "Auto",
								range = 450000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7000,
				hAttack = 7100,
				standoff = 10000,
				LDSD = true,
				sortie_rate = 8,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{AIM-9L}",
						},
						[3] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98452}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98453}",
						},
						[8] = {
							CLSID = "{AIM-9L}",
						},
						[9] = {
							CLSID = "{AIM-9L}",
						},
						[11] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
		},
		Intercept = {
			["2000s LR AA AIM-120C*4, AIM-9X*2, FT*3"] = {
				attributes =  { },
				code_loadout =  { "Caucasus", "WOB" },
				night = true,
				adverseWeather = true,
				range = 450000,
				firepower = 1,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[2] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[3] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[8] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[9] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["80s LR AA AIM-9L*6, FT*3"] = {
				attributes =  { },
				code_loadout =  { },
				night = true,
				adverseWeather = true,
				range = 450000,
				firepower = 1,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{AIM-9L}",
						},
						[3] = {
							CLSID = "{AIM-9L}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{AIM-9L}",
						},
						[8] = {
							CLSID = "{AIM-9L}",
						},
						[9] = {
							CLSID = "{AIM-9L}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			[" AA AIM-120B*4, AIM-9L*2, FT*3"] = {
				attributes =  { },
				code_loadout =  { },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[2] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[3] = {
							CLSID = "{AIM-9L}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{AIM-9L}",
						},
						[8] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[9] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["2000s SR AA AIM-120C*4, AIM-9X*2, FT*1"] = {
				attributes =  { },
				code_loadout =  { "Caucasus", "WOB" },
				night = true,
				adverseWeather = true,
				range = 250000,
				firepower = 1,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[2] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[3] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[4] = {
							CLSID = "<CLEAN>",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "<CLEAN>",
						},
						[7] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[8] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[9] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["80s SR AA AIM-9L*6, FT*1"] = {
				attributes =  { },
				code_loadout =  { },
				night = true,
				adverseWeather = true,
				range = 250000,
				firepower = 1,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{AIM-9L}",
						},
						[3] = {
							CLSID = "{AIM-9L}",
						},
						[4] = {
							CLSID = "<CLEAN>",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "<CLEAN>",
						},
						[7] = {
							CLSID = "{AIM-9L}",
						},
						[8] = {
							CLSID = "{AIM-9L}",
						},
						[9] = {
							CLSID = "{AIM-9L}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["90s SR AA AIM-120B*4, AIM-9M*2, FT*1"] = {
				attributes =  { },
				code_loadout =  { "Crisis", "PG" },
				night = true,
				adverseWeather = true,
				range = 250000,
				firepower = 1,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[2] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[3] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[4] = {
							CLSID = "<CLEAN>",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "<CLEAN>",
						},
						[7] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[8] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[9] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			[" AA AIM-120B*2, AIM-9L*4, FT*3"] = {
				attributes =  { },
				code_loadout =  { "Cyprus" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[2] = {
							CLSID = "{AIM-9L}",
						},
						[3] = {
							CLSID = "{AIM-9L}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{AIM-9L}",
						},
						[8] = {
							CLSID = "{AIM-9L}",
						},
						[9] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["90s LR AA AIM-120B*4, AIM-9M*2, FT*3"] = {
				attributes =  { },
				code_loadout =  { "Crisis", "PG" },
				night = true,
				adverseWeather = true,
				range = 450000,
				firepower = 1,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[2] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[3] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[8] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[9] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
		},
		Escort = {
			["90s SR AA AIM-120B*4, AIM-9M*2, FT*1"] = {
				attributes =  { },
				code_loadout =  { "Crisis", "PG" },
				night = true,
				adverseWeather = true,
				range = 250000,
				firepower = 4,
				vCruise = 255.83333333333,
				standoff = 46300,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[2] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[3] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[4] = {
							CLSID = "<CLEAN>",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "<CLEAN>",
						},
						[7] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[8] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[9] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["80s LR AA AIM-9L*6, FT*3"] = {
				attributes =  { },
				code_loadout =  { },
				night = true,
				adverseWeather = true,
				range = 450000,
				firepower = 1,
				vCruise = 255.83333333333,
				standoff = 46300,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{AIM-9L}",
						},
						[3] = {
							CLSID = "{AIM-9L}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{AIM-9L}",
						},
						[8] = {
							CLSID = "{AIM-9L}",
						},
						[9] = {
							CLSID = "{AIM-9L}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["AIM-120B*4, AIM-9L*2, FT*3"] = {
				attributes =  { },
				code_loadout =  { },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 4,
				vCruise = 255.83333333333,
				standoff = 46300,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[2] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[3] = {
							CLSID = "{AIM-9L}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{AIM-9L}",
						},
						[8] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[9] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["AIM-120B*2, AIM-9L*4, FT*3"] = {
				attributes =  { },
				code_loadout =  { "Cyprus" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 2,
				vCruise = 255.83333333333,
				standoff = 46300,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[2] = {
							CLSID = "{AIM-9L}",
						},
						[3] = {
							CLSID = "{AIM-9L}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{AIM-9L}",
						},
						[8] = {
							CLSID = "{AIM-9L}",
						},
						[9] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["80s SR AA AIM-9L*6, FT*1"] = {
				attributes =  { },
				code_loadout =  { },
				night = true,
				adverseWeather = true,
				range = 250000,
				firepower = 1,
				vCruise = 255.83333333333,
				standoff = 46300,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{AIM-9L}",
						},
						[3] = {
							CLSID = "{AIM-9L}",
						},
						[4] = {
							CLSID = "<CLEAN>",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "<CLEAN>",
						},
						[7] = {
							CLSID = "{AIM-9L}",
						},
						[8] = {
							CLSID = "{AIM-9L}",
						},
						[9] = {
							CLSID = "{AIM-9L}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["2000s LR AA AIM-120C*4, AIM-9X*2, FT*3"] = {
				attributes =  { },
				code_loadout =  { "Caucasus", "WOB" },
				night = true,
				adverseWeather = true,
				range = 510000,
				firepower = 4,
				vCruise = 255.83333333333,
				standoff = 46300,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[2] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[3] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[8] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[9] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["2000s SR AA AIM-120C*4, AIM-9X*2, FT*1"] = {
				attributes =  { },
				code_loadout =  { "Caucasus", "WOB" },
				night = true,
				adverseWeather = true,
				range = 250000,
				firepower = 4,
				vCruise = 255.83333333333,
				standoff = 46300,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[2] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[3] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[4] = {
							CLSID = "<CLEAN>",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "<CLEAN>",
						},
						[7] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[8] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[9] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["90s LR AA AIM-120B*4, AIM-9M*2, FT*3"] = {
				attributes =  { },
				code_loadout =  { "Crisis", "PG" },
				night = true,
				adverseWeather = true,
				range = 450000,
				firepower = 4,
				vCruise = 255.83333333333,
				standoff = 46300,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[2] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[3] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[8] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[9] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
		},
		["Laser Illumination"] = {
			["Laser Illumination AIM-120*2, AIM-9X*2, FUEL*2, TGP"] = {
				attributes =  { },
				code_loadout =  { "Caucasus", "WOB" },
				night = true,
				range = 900000,
				firepower = 1,
				vCruise = 270,
				vAttack = 300,
				hCruise = 7096,
				hAttack = 7096,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[2] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[3] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "<CLEAN>",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[8] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[9] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[11] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Laser Illumination Caucasus AIM-120B*2,AIM-9M*2,FUEL*2, TGP"] = {
				attributes =  { },
				code_loadout =  { "Crisis", "PG" },
				night = true,
				range = 900000,
				firepower = 1,
				vCruise = 270,
				vAttack = 300,
				hCruise = 7096,
				hAttack = 7096,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[2] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[3] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "<CLEAN>",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[8] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[9] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[11] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
		},
		CAP = {
			["80s LR AA AIM-9L*6, FT*3"] = {
				attributes =  { },
				code_loadout =  { },
				night = true,
				adverseWeather = true,
				range = 450000,
				firepower = 1,
				vCruise = 255.83333333333,
				vAttack = 265.83333333333,
				hCruise = 9753.6,
				hAttack = 9753.6,
				standoff = 46300,
				tStation = 7200,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{AIM-9L}",
						},
						[3] = {
							CLSID = "{AIM-9L}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{AIM-9L}",
						},
						[8] = {
							CLSID = "{AIM-9L}",
						},
						[9] = {
							CLSID = "{AIM-9L}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["AIM-120B*2, AIM-9L*4, FT*3"] = {
				attributes =  { },
				code_loadout =  { "Cyprus" },
				night = true,
				adverseWeather = true,
				range = 450000,
				firepower = 1,
				vCruise = 255.83333333333,
				vAttack = 265.83333333333,
				hCruise = 9753.6,
				hAttack = 9753.6,
				standoff = 46300,
				tStation = 7200,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[2] = {
							CLSID = "{AIM-9L}",
						},
						[3] = {
							CLSID = "{AIM-9L}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{AIM-9L}",
						},
						[8] = {
							CLSID = "{AIM-9L}",
						},
						[9] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["AIM-120B*4, AIM-9L*2, FT*3"] = {
				attributes =  { },
				code_loadout =  { },
				night = true,
				adverseWeather = true,
				range = 450000,
				firepower = 1,
				vCruise = 255.83333333333,
				vAttack = 265.83333333333,
				hCruise = 9753.6,
				hAttack = 9753.6,
				standoff = 46300,
				tStation = 7200,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[2] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[3] = {
							CLSID = "{AIM-9L}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{AIM-9L}",
						},
						[8] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[9] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["2000s LR AA AIM-120C*4, AIM-9X*2, FT*3"] = {
				attributes =  { "Air Forces" },
				code_loadout =  { "Caucasus", "WOB" },
				night = true,
				adverseWeather = true,
				range = 450000,
				firepower = 1,
				vCruise = 255.83333333333,
				vAttack = 265.83333333333,
				hCruise = 9753.6,
				hAttack = 9753.6,
				standoff = 46300,
				tStation = 7200,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[2] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[3] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[8] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[9] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["90s LR AA AIM-120B*4, AIM-9M*2, FT*3"] = {
				attributes =  { "Air Forces" },
				code_loadout =  { "Crisis", "PG" },
				night = true,
				adverseWeather = true,
				range = 450000,
				firepower = 1,
				vCruise = 255.83333333333,
				vAttack = 265.83333333333,
				hCruise = 9753.6,
				hAttack = 9753.6,
				standoff = 46300,
				tStation = 7200,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[2] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[3] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[8] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[9] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
		},
		["Runway Attack"] = {
			["Crisis Runway attack AIM-120B*2, AIM-9M*2, MK-82HD*6, FUEL*2, ECM, TGP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Runway" },
				code_loadout =  { "Crisis", "PG" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 9100,
				hAttack = 100,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[2] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[3] = {
							CLSID = "{TER_9A_3*MK-82AIR}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "ALQ_184_Long",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{TER_9A_3*MK-82AIR}",
						},
						[8] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[9] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[11] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["WOB Runway attack AIM-120C*2, AIM-9X*2, MK-82HD*6, FUEL*2, ECM, TGP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Runway" },
				code_loadout =  { "TF", "Caucasus", "WOB" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 9100,
				hAttack = 100,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[2] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[3] = {
							CLSID = "{TER_9A_3*MK-82AIR}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "ALQ_184_Long",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{TER_9A_3*MK-82AIR}",
						},
						[8] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[9] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[11] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["WOB Runway attack High Alt AIM-120C*2, AIM-9X*2, MK-82LD*6, FUEL*2, ECM, TGP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Runway" },
				code_loadout =  { "TF", "Caucasus", "WOB" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 9100,
				hAttack = 8500,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[2] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[3] = {
							CLSID = "{TER_9A_3*MK-82}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "ALQ_184_Long",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{TER_9A_3*MK-82}",
						},
						[8] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[9] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[11] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Crisis Runway attack High Alt AIM-120B*2, AIM-9M*2, MK-82LD*6, FUEL*2, ECM, TGP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Runway" },
				code_loadout =  { "Crisis", "PG" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 9100,
				hAttack = 8500,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[2] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[3] = {
							CLSID = "{TER_9A_3*MK-82}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "ALQ_184_Long",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{TER_9A_3*MK-82}",
						},
						[8] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[9] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[11] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
		},
		SEAD = {
			["Caucasus LR SEAD AGM88*2,AIM-120C*2, AIM-9X*2, FT*2, LP, HTS, ECM"] = {
				attributes =  { },
				code_loadout =  { "Caucasus" },
				weaponType = "ASM",
				night = true,
				adverseWeather = true,
				range = 450000,
				firepower = 2,
				vCruise = 191,
				vAttack = 270,
				hCruise = 6096,
				hAttack = 6096,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[2] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[3] = {
							CLSID = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "ALQ_184_Long",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
						},
						[8] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[9] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[10] = {
							CLSID = "{AN_ASQ_213}",
						},
						[11] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Caucasus SR SEAD AGM88*2,AIM-120C*2, AIM-9X*2, Mav-IR*2, Mav Las*2 LP, HTS, ECM"] = {
				attributes =  { },
				code_loadout =  { "Caucasus" },
				weaponType = "ASM",
				night = true,
				adverseWeather = true,
				range = 250000,
				firepower = 2,
				vCruise = 191,
				vAttack = 270,
				hCruise = 6096,
				hAttack = 6096,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[2] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[3] = {
							CLSID = "LAU_88_AGM_65H_2_L",
						},
						[4] = {
							CLSID = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
						},
						[5] = {
							CLSID = "ALQ_184_Long",
						},
						[6] = {
							CLSID = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
						},
						[7] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98453}",
						},
						[8] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[9] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[10] = {
							CLSID = "{AN_ASQ_213}",
						},
						[11] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["WOB SR SEAD AGM88*2,AIM-120C*2, AIM-9X*2, Mav-IR*2, Mav Las*2 LP, HTS, ECM"] = {
				attributes =  { },
				code_loadout =  { "WOB" },
				weaponType = "ASM",
				night = true,
				adverseWeather = true,
				range = 250000,
				firepower = 2,
				vCruise = 191,
				vAttack = 270,
				hCruise = 6096,
				hAttack = 6096,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[2] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[3] = {
							CLSID = "LAU_88_AGM_65H_2_L",
						},
						[4] = {
							CLSID = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
						},
						[5] = {
							CLSID = "ALQ_184_Long",
						},
						[6] = {
							CLSID = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
						},
						[7] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98453}",
						},
						[8] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[9] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[10] = {
							CLSID = "{AN_ASQ_213}",
						},
						[11] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["WOB LR SEAD AGM88*2,AIM-120C*2, AIM-9X*2, FT*2, LP, HTS, ECM"] = {
				attributes =  { },
				code_loadout =  { "WOB" },
				weaponType = "ASM",
				night = true,
				adverseWeather = true,
				range = 520000,
				firepower = 2,
				vCruise = 191,
				vAttack = 270,
				hCruise = 6096,
				hAttack = 6096,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[2] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[3] = {
							CLSID = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "ALQ_184_Long",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
						},
						[8] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[9] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[10] = {
							CLSID = "{AN_ASQ_213}",
						},
						[11] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["SEAD 80s LR SEAD AGM88*2,AIM-9L*4, FT*3"] = {
				attributes =  { },
				code_loadout =  { "Caucasus" },
				weaponType = "ASM",
				night = true,
				adverseWeather = true,
				range = 450000,
				firepower = 2,
				vCruise = 191,
				vAttack = 270,
				hCruise = 6096,
				hAttack = 6096,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{AIM-9L}",
						},
						[3] = {
							CLSID = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
						},
						[8] = {
							CLSID = "{AIM-9L}",
						},
						[9] = {
							CLSID = "{AIM-9L}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["SEAD 90s LR SEAD AGM88*2,AIM-120B*2, AIM-9M*2, FT*3"] = {
				attributes =  { },
				code_loadout =  { "Crisis", "PG" },
				weaponType = "ASM",
				night = true,
				adverseWeather = true,
				range = 450000,
				firepower = 2,
				vCruise = 191,
				vAttack = 270,
				hCruise = 6096,
				hAttack = 6096,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[2] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[3] = {
							CLSID = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
						},
						[8] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[9] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["SEAD 90s SR SEAD AGM88*4,AIM-120B*2, AIM-9M*2, FT*1"] = {
				attributes =  { },
				code_loadout =  { "Crisis", "PG" },
				weaponType = "ASM",
				night = true,
				adverseWeather = true,
				range = 250000,
				firepower = 2,
				vCruise = 191,
				vAttack = 270,
				hCruise = 6096,
				hAttack = 6096,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[2] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[3] = {
							CLSID = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
						},
						[4] = {
							CLSID = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
						},
						[7] = {
							CLSID = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
						},
						[8] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[9] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["SEAD Cyprus - AIM-120B*2-AIM-9L*2-FT*2-ECM-AGM-65D*4-LP"] = {
				attributes =  { },
				code_loadout =  { "Cyprus" },
				weaponType = "ASM",
				night = true,
				adverseWeather = true,
				range = 250000,
				firepower = 2,
				vCruise = 191,
				vAttack = 270,
				hCruise = 6096,
				hAttack = 6096,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[2] = {
							CLSID = "{AIM-9L}",
						},
						[3] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98452}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "{6D21ECEA-F85B-4E8D-9D51-31DC9B8AA4EF}",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98453}",
						},
						[8] = {
							CLSID = "{AIM-9L}",
						},
						[9] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[11] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["SEAD 80s SR SEAD AGM88*4,AIM-9L*4,FT*1"] = {
				attributes =  { },
				code_loadout =  { "Caucasus" },
				weaponType = "ASM",
				night = true,
				adverseWeather = true,
				range = 250000,
				firepower = 2,
				vCruise = 191,
				vAttack = 270,
				hCruise = 6096,
				hAttack = 6096,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{AIM-9L}",
						},
						[3] = {
							CLSID = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
						},
						[4] = {
							CLSID = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
						},
						[7] = {
							CLSID = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
						},
						[8] = {
							CLSID = "{AIM-9L}",
						},
						[9] = {
							CLSID = "{AIM-9L}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["SEAD LR - AGM-88*2, AIM-9L*2, AIM-120B*2, Fuel*3"] = {
				attributes =  { },
				code_loadout =  { "Cyprus" },
				weaponType = "ASM",
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 2,
				vCruise = 191,
				vAttack = 270,
				hCruise = 6096,
				hAttack = 6096,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[2] = {
							CLSID = "{AIM-9L}",
						},
						[3] = {
							CLSID = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
						},
						[8] = {
							CLSID = "{AIM-9L}",
						},
						[9] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["SEAD Cyprus - AIM-120B*2-AIM-9L*2-FT*2-ECM-BGU-12*4-LP"] = {
				attributes =  { },
				code_loadout =  { "Cyprus" },
				weaponType = "ASM",
				night = true,
				adverseWeather = true,
				range = 250000,
				firepower = 2,
				vCruise = 191,
				vAttack = 270,
				hCruise = 6096,
				hAttack = 6096,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[2] = {
							CLSID = "{AIM-9L}",
						},
						[3] = {
							CLSID = "{TER_9A_2L*GBU-12}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "{6D21ECEA-F85B-4E8D-9D51-31DC9B8AA4EF}",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{TER_9A_2R*GBU-12}",
						},
						[8] = {
							CLSID = "{AIM-9L}",
						},
						[9] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[11] = {
							CLSID = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
		},
		["Fighter Sweep"] = {
			["90s SR AA AIM-120B*4, AIM-9M*2, FT*1"] = {
				attributes =  { },
				code_loadout =  { "Crisis", "PG" },
				night = true,
				adverseWeather = true,
				range = 250000,
				firepower = 4,
				vCruise = 255.83333333333,
				vAttack = 265.83333333333,
				hCruise = 9753.6,
				hAttack = 9753.6,
				standoff = 46300,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[2] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[3] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[4] = {
							CLSID = "<CLEAN>",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "<CLEAN>",
						},
						[7] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[8] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[9] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["80s LR AA AIM-9L*6, FT*3"] = {
				attributes =  { },
				code_loadout =  { },
				night = true,
				adverseWeather = true,
				range = 450000,
				firepower = 1,
				vCruise = 255.83333333333,
				vAttack = 265.83333333333,
				hCruise = 9753.6,
				hAttack = 9753.6,
				standoff = 46300,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{AIM-9L}",
						},
						[3] = {
							CLSID = "{AIM-9L}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{AIM-9L}",
						},
						[8] = {
							CLSID = "{AIM-9L}",
						},
						[9] = {
							CLSID = "{AIM-9L}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["AIM-120B*4, AIM-9L*2, FT*3"] = {
				attributes =  { },
				code_loadout =  { },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 4,
				vCruise = 255.83333333333,
				vAttack = 265.83333333333,
				hCruise = 9753.6,
				hAttack = 9753.6,
				standoff = 46300,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[2] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[3] = {
							CLSID = "{AIM-9L}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{AIM-9L}",
						},
						[8] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[9] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["AIM-120B*2, AIM-9L*4, FT*3"] = {
				attributes =  { },
				code_loadout =  { "Cyprus" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 2,
				vCruise = 255.83333333333,
				vAttack = 265.83333333333,
				hCruise = 9753.6,
				hAttack = 9753.6,
				standoff = 46300,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[2] = {
							CLSID = "{AIM-9L}",
						},
						[3] = {
							CLSID = "{AIM-9L}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{AIM-9L}",
						},
						[8] = {
							CLSID = "{AIM-9L}",
						},
						[9] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["80s SR AA AIM-9L*6, FT*1"] = {
				attributes =  { },
				code_loadout =  { },
				night = true,
				adverseWeather = true,
				range = 250000,
				firepower = 1,
				vCruise = 255.83333333333,
				vAttack = 265.83333333333,
				hCruise = 9753.6,
				hAttack = 9753.6,
				standoff = 46300,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{AIM-9L}",
						},
						[3] = {
							CLSID = "{AIM-9L}",
						},
						[4] = {
							CLSID = "<CLEAN>",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "<CLEAN>",
						},
						[7] = {
							CLSID = "{AIM-9L}",
						},
						[8] = {
							CLSID = "{AIM-9L}",
						},
						[9] = {
							CLSID = "{AIM-9L}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["2000s LR AA AIM-120C*4, AIM-9X*2, FT*3"] = {
				attributes =  { },
				code_loadout =  { "Caucasus", "WOB" },
				night = true,
				adverseWeather = true,
				range = 450000,
				firepower = 4,
				vCruise = 255.83333333333,
				vAttack = 265.83333333333,
				hCruise = 9753.6,
				hAttack = 9753.6,
				standoff = 46300,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[2] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[3] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[8] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[9] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["2000s SR AA AIM-120C*4, AIM-9X*2, FT*1"] = {
				attributes =  { },
				code_loadout =  { "Caucasus", "WOB" },
				night = true,
				adverseWeather = true,
				range = 250000,
				firepower = 4,
				vCruise = 255.83333333333,
				vAttack = 265.83333333333,
				hCruise = 9753.6,
				hAttack = 9753.6,
				standoff = 46300,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[2] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[3] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[4] = {
							CLSID = "<CLEAN>",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "<CLEAN>",
						},
						[7] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[8] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[9] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["90s LR AA AIM-120B*4, AIM-9M*2, FT*3"] = {
				attributes =  { },
				code_loadout =  { "Crisis", "PG" },
				night = true,
				adverseWeather = true,
				range = 450000,
				firepower = 4,
				vCruise = 255.83333333333,
				vAttack = 265.83333333333,
				hCruise = 9753.6,
				hAttack = 9753.6,
				standoff = 46300,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[2] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[3] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[4] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[5] = {
							CLSID = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
						},
						[6] = {
							CLSID = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
						},
						[7] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[8] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[9] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
		},
	},

}