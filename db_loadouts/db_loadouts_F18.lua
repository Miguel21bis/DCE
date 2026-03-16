--Loadouts database
--F18 loadouts
-------------------------------------------------------------------------------------------------------

if not versionDCE then versionDCE = {} end
versionDCE["db_loadouts/db_loadouts_F18.lua"] = "1.1.2"

-- 1.1.2 - Add ["Escort Jammer"] = true, standoff harpoon for TF = 150000
-- 1.1.1 - Beginning of the versions of this loadouts file dedicated to the F4.

db_loadouts = {
	["FA-18C_hornet"] = {
		Strike = {
			["Strike 2000s LR-AG-AIM-9X*2,AIM-120C*2,MK84*2,FT*3"] = {
				minscore = 0.5,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "Structure" },
				code_loadout =  { },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				range = 450000,
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
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[2] = {
							CLSID = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
						},
						[3] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[4] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[7] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[8] = {
							CLSID = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
						},
						[9] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s SR-AG-AIM-9X*2,AIM-120C*1,JSAW-C*8,FT*1,GP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "Structure", "SAM" },
				code_loadout =  { "TF", "Caucasus" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 150000,
				firepower = 1,
				vCruise = 245.83333333333,
				vAttack = 300.5,
				hCruise = 7486.4,
				hAttack = 8172,
				standoff = 60000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[2] = {
							CLSID = "{BRU55_2*AGM-154C}",
						},
						[3] = {
							CLSID = "{BRU55_2*AGM-154C}",
						},
						[4] = {
							CLSID = "{AN_ASQ_228}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[7] = {
							CLSID = "{BRU55_2*AGM-154C}",
						},
						[8] = {
							CLSID = "{BRU55_2*AGM-154C}",
						},
						[9] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
					},
					fuel = "4900",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Old TF Precision Strike SR - AIM-9L*2 - AGM-62*2 - AIM-7MH*4 - Pod"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "Bridge", "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "TF80s", "TF80sRED" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				range = 150000,
				firepower = 1,
				vCruise = 245.83333333333,
				vAttack = 300.5,
				hCruise = 7486.4,
				hAttack = 7472,
				standoff = 15000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{C40A1E3A-DD05-40D9-85A4-217729E37FAE}",
						},
						[3] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[4] = {
							CLSID = "{AIM-7H}",
						},
						[5] = {
							CLSID = "{AWW-13}",
						},
						[6] = {
							CLSID = "{AIM-7H}",
						},
						[7] = {
							CLSID = "{LAU-115 - AIM-7H}",
						},
						[8] = {
							CLSID = "{C40A1E3A-DD05-40D9-85A4-217729E37FAE}",
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
			["Strike 2000s SR-AG-AIM-9X*2,AIM-120C*2,MK84*4,FT*1"] = {
				minscore = 0.5,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "Structure" },
				code_loadout =  { },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				range = 150000,
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
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[2] = {
							CLSID = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
						},
						[3] = {
							CLSID = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
						},
						[4] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[7] = {
							CLSID = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
						},
						[8] = {
							CLSID = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
						},
						[9] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["2000s-TF- Strike-LR-AGM-84E*2-AIM-120C*2-AIM-9x*2-DL-FT*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "SAM-LR" },
				code_loadout =  { "TF", "Caucasus" },
				weaponType = "ASM",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 450000,
				firepower = 1,
				vCruise = 245.83333333333,
				vAttack = 300.5,
				hCruise = 7486.4,
				hAttack = 8172,
				standoff = 85000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[2] = {
							CLSID = "{AF42E6DF-9A60-46D8-A9A0-1708B241AADB}",
						},
						[3] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[4] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[5] = {
							CLSID = "{AWW-13}",
						},
						[6] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[7] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[8] = {
							CLSID = "{AF42E6DF-9A60-46D8-A9A0-1708B241AADB}",
						},
						[9] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
					},
					fuel = "4900",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s WOC SR-AG-AIM-9X*2,AIM-120C*2,MK82HD*8,FT*1"] = {
				minscore = 0.4,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "frontline" },
				code_loadout =  { "Caucasus" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				range = 150000,
				firepower = 1,
				vCruise = 245,
				vAttack = 350.5,
				hCruise = 300.4,
				hAttack = 200,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[2] = {
							CLSID = "{BRU33_2X_MK-82_Snakeye}",
						},
						[3] = {
							CLSID = "{BRU33_2X_MK-82_Snakeye}",
						},
						[4] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[7] = {
							CLSID = "{BRU33_2X_MK-82_Snakeye}",
						},
						[8] = {
							CLSID = "{BRU33_2X_MK-82_Snakeye}",
						},
						[9] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 80s SR-AG-AIM-9L*2,AIM-7MH*2,MK82HD*8,FT*1"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "TF80s", "TF80sRED" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				range = 150000,
				firepower = 1,
				vCruise = 245,
				vAttack = 350.5,
				hCruise = 300.4,
				hAttack = 200,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{BRU33_2X_MK-82_Snakeye}",
						},
						[3] = {
							CLSID = "{BRU33_2X_MK-82_Snakeye}",
						},
						[4] = {
							CLSID = "{AIM-7H}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{AIM-7H}",
						},
						[7] = {
							CLSID = "{BRU33_2X_MK-82_Snakeye}",
						},
						[8] = {
							CLSID = "{BRU33_2X_MK-82_Snakeye}",
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
			["Strike 90s LR-AG-AIM-9M*2,AIM-120B*2,MK84LD*2,FT*3"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "Structure" },
				code_loadout =  { "Crisis", "PG" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				range = 450000,
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
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
						},
						[3] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[4] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[7] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[8] = {
							CLSID = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
						},
						[9] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 80s SR-AG-AIM-9L*2,AIM-7MH*2,MK84LD*4,FT*1"] = {
				minscore = 0.5,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "Structure" },
				code_loadout =  { "TF80s", "TF80sRED", "WOC80" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 150000,
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
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
						},
						[3] = {
							CLSID = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
						},
						[4] = {
							CLSID = "{AIM-7H}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{AIM-7H}",
						},
						[7] = {
							CLSID = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
						},
						[8] = {
							CLSID = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
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
			["Strike 90s SR-AG-AIM-9M*2,AIM-120B*1,GBU-31*4,FT*1,GP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "Structure" },
				code_loadout =  { "PG" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 150000,
				firepower = 1,
				vCruise = 245.83333333333,
				vAttack = 300.5,
				hCruise = 7486.4,
				hAttack = 8172,
				standoff = 20000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{GBU-31V3B}",
						},
						[3] = {
							CLSID = "{GBU-31V3B}",
						},
						[4] = {
							CLSID = "{AN_ASQ_228}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[7] = {
							CLSID = "{GBU-31V3B}",
						},
						[8] = {
							CLSID = "{GBU-31V3B}",
						},
						[9] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = "4900",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s LR-AG-AIM-9X*2,AIM-120C*1,AGM-65F*2,FT*3,GP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "frontline" },
				code_loadout =  { "TF", "Caucasus", "WOB" },
				weaponType = "ASM",
				expend = "Auto",
				attackType = "Dive",
				night = true,
				range = 450000,
				firepower = 1,
				vCruise = 245.83333333333,
				vAttack = 300.5,
				hCruise = 7486.4,
				hAttack = 7472,
				standoff = 15000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[2] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[3] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[4] = {
							CLSID = "{AN_ASQ_228}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[7] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[8] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[9] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
					},
					fuel = "4900",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["2000s-TF- Strike-SR-AGM-84E*4-AIM-120C*2-AIM-9x*2-DL-"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "SAM-LR" },
				code_loadout =  { "TF", "Caucasus" },
				weaponType = "ASM",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 400000,
				firepower = 1,
				vCruise = 245.83333333333,
				vAttack = 300.5,
				hCruise = 7486.4,
				hAttack = 8172,
				standoff = 85000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[2] = {
							CLSID = "{AF42E6DF-9A60-46D8-A9A0-1708B241AADB}",
						},
						[3] = {
							CLSID = "{AF42E6DF-9A60-46D8-A9A0-1708B241AADB}",
						},
						[4] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[5] = {
							CLSID = "{AWW-13}",
						},
						[6] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[7] = {
							CLSID = "{AF42E6DF-9A60-46D8-A9A0-1708B241AADB}",
						},
						[8] = {
							CLSID = "{AF42E6DF-9A60-46D8-A9A0-1708B241AADB}",
						},
						[9] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
					},
					fuel = "4900",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 90s SR-AG-AIM-9M*2,AIM-120B*2,Mk20-Rockeye*8,FT*1"] = {
				minscore = 0.4,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				range = 150000,
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
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{BRU33_2X_ROCKEYE}",
						},
						[3] = {
							CLSID = "{BRU33_2X_ROCKEYE}",
						},
						[4] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[7] = {
							CLSID = "{BRU33_2X_ROCKEYE}",
						},
						[8] = {
							CLSID = "{BRU33_2X_ROCKEYE}",
						},
						[9] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 90s LR-AG-AIM-9M*2,AIM-120B*2,MK82LD*4,FT*3"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "Crisis", "PG" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				range = 600000,
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
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{BRU33_2X_MK-82}",
						},
						[3] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[4] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[7] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[8] = {
							CLSID = "{BRU33_2X_MK-82}",
						},
						[9] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s SR-AG-AIM-9X*2,AIM-120C*1,GBU-10*4,FT*1,GP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "Structure" },
				code_loadout =  { "TF", "Caucasus" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				range = 150000,
				firepower = 1,
				vCruise = 245.83333333333,
				vAttack = 300.5,
				hCruise = 7486.4,
				hAttack = 7472,
				standoff = 15000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[2] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[3] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[4] = {
							CLSID = "{AN_ASQ_228}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[7] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[8] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[9] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Old TF Strike SR - AIM-9L*2 - Mk-82*8 - AIM-7MH*2 - FT*1"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "frontline" },
				code_loadout =  { "TF80s", "TF80sRED", "WOC80" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 150000,
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
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{BRU33_2X_MK-82}",
						},
						[3] = {
							CLSID = "{BRU33_2X_MK-82}",
						},
						[4] = {
							CLSID = "{AIM-7H}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{AIM-7H}",
						},
						[7] = {
							CLSID = "{BRU33_2X_MK-82}",
						},
						[8] = {
							CLSID = "{BRU33_2X_MK-82}",
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
			["Strike 80s SR-AG-AIM-9L*2,AIM-7MH*2,Mk20-Rockeye*8,FT*1"] = {
				minscore = 0.4,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				range = 150000,
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
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{BRU33_2X_ROCKEYE}",
						},
						[3] = {
							CLSID = "{BRU33_2X_ROCKEYE}",
						},
						[4] = {
							CLSID = "{AIM-7H}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{AIM-7H}",
						},
						[7] = {
							CLSID = "{BRU33_2X_ROCKEYE}",
						},
						[8] = {
							CLSID = "{BRU33_2X_ROCKEYE}",
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
			["Strike 2000s WOC SR-AG-AIM-9X*2,AIM-120C*1,GBU-12*8,FT*1,GP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "frontline" },
				code_loadout =  { "Caucasus" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				range = 150000,
				firepower = 1,
				vCruise = 245.83333333333,
				vAttack = 300.5,
				hCruise = 7486.4,
				hAttack = 7472,
				standoff = 15000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[2] = {
							CLSID = "{BRU33_2X_GBU-12}",
						},
						[3] = {
							CLSID = "{BRU33_2X_GBU-12}",
						},
						[4] = {
							CLSID = "{AN_ASQ_228}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[7] = {
							CLSID = "{BRU33_2X_GBU-12}",
						},
						[8] = {
							CLSID = "{BRU33_2X_GBU-12}",
						},
						[9] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 80s LR-AG-AIM-9L*2,AIM-7-MH*1,AGM-65F*2,FT*3,GP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "TF80s", "TF80sRED" },
				weaponType = "ASM",
				expend = "Auto",
				attackType = "Dive",
				night = true,
				range = 450000,
				firepower = 1,
				vCruise = 245.83333333333,
				vAttack = 300.5,
				hCruise = 7486.4,
				hAttack = 7472,
				standoff = 15000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[3] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[4] = {
							CLSID = "{AN_ASQ_228}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{AIM-7H}",
						},
						[7] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[8] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[9] = {
							CLSID = "{AIM-9L}",
						},
					},
					fuel = "4900",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s SR-AG-AIM-9X*2,AIM-120C*2,MK82HD*8,FT*1"] = {
				minscore = 0.4,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft" },
				code_loadout =  { "TF" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				range = 150000,
				firepower = 1,
				vCruise = 245,
				vAttack = 350.5,
				hCruise = 300.4,
				hAttack = 200,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[2] = {
							CLSID = "{BRU33_2X_MK-82_Snakeye}",
						},
						[3] = {
							CLSID = "{BRU33_2X_MK-82_Snakeye}",
						},
						[4] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[7] = {
							CLSID = "{BRU33_2X_MK-82_Snakeye}",
						},
						[8] = {
							CLSID = "{BRU33_2X_MK-82_Snakeye}",
						},
						[9] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 90s SR-AG-AIM-9M*2,AIM-120B*1,GBU-38*8,FT*1,GP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "PG" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 150000,
				firepower = 1,
				vCruise = 245.83333333333,
				vAttack = 300.5,
				hCruise = 7486.4,
				hAttack = 8172,
				standoff = 20000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{BRU55_2*GBU-38}",
						},
						[3] = {
							CLSID = "{BRU55_2*GBU-38}",
						},
						[4] = {
							CLSID = "{AN_ASQ_228}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[7] = {
							CLSID = "{BRU55_2*GBU-38}",
						},
						[8] = {
							CLSID = "{BRU55_2*GBU-38}",
						},
						[9] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = "4900",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 80s LR-AG-AIM-9L*2,AIM-7MH*2,Mk20-Rockeye*4,FT*3"] = {
				minscore = 0.4,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				range = 450000,
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
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{BRU33_2X_ROCKEYE}",
						},
						[3] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[4] = {
							CLSID = "{AIM-7H}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{AIM-7H}",
						},
						[7] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[8] = {
							CLSID = "{BRU33_2X_ROCKEYE}",
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
			["Old TF Precision Strike SR - AIM-9L*2 - AGM-65F*4 - AIM-7MH*2 - FT"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "TF80s", "TF80sRED" },
				weaponType = "ASM",
				expend = "Auto",
				attackType = "Dive",
				night = true,
				range = 150000,
				firepower = 1,
				vCruise = 245.83333333333,
				vAttack = 300.5,
				hCruise = 7486.4,
				hAttack = 7472,
				standoff = 15000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[3] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[4] = {
							CLSID = "{AIM-7H}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{AIM-7H}",
						},
						[7] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[8] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[9] = {
							CLSID = "{AIM-9L}",
						},
					},
					fuel = "4900",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s LR-AG-AIM-9X*2,AIM-120C*2,MK82LD*4,FT*3"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "frontline" },
				code_loadout =  { "Caucasus" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				range = 600000,
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
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[2] = {
							CLSID = "{BRU33_2X_MK-82}",
						},
						[3] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[4] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[7] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[8] = {
							CLSID = "{BRU33_2X_MK-82}",
						},
						[9] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 90s SR-AG-AIM-9M*2,AIM-120B*2,MK82LD*8,FT*1"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "Crisis", "PG" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				range = 150000,
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
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{BRU33_2X_MK-82}",
						},
						[3] = {
							CLSID = "{BRU33_2X_MK-82}",
						},
						[4] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[7] = {
							CLSID = "{BRU33_2X_MK-82}",
						},
						[8] = {
							CLSID = "{BRU33_2X_MK-82}",
						},
						[9] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 80s I LR-AG-AIM-9L*2,AIM-7-MH*2,AGM-65F*2,FT*3"] = {
				minscore = 0.3,
				support = {
					SEAD = true,
					Escort = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "TF80sI", "WOC80", "TF80s" },
				weaponType = "ASM",
				expend = "Auto",
				attackType = "Dive",
				night = true,
				range = 450000,
				firepower = 1,
				vCruise = 245.83333333333,
				vAttack = 300.5,
				hCruise = 7800,
				hAttack = 7000,
				standoff = 15000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[3] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[4] = {
							CLSID = "{AIM-7H}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{AIM-7H}",
						},
						[7] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[8] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[9] = {
							CLSID = "{AIM-9L}",
						},
					},
					fuel = "4900",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 90s LR-AG-AIM-9M*2,AIM-120B*2,MK82HD*4,FT*3"] = {
				minscore = 0.4,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "Crisis", "PG" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				range = 450000,
				firepower = 1,
				vCruise = 245,
				vAttack = 350.5,
				hCruise = 300.4,
				hAttack = 200,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{BRU33_2X_MK-82_Snakeye}",
						},
						[3] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[4] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[7] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[8] = {
							CLSID = "{BRU33_2X_MK-82_Snakeye}",
						},
						[9] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 90s LR-AG-AIM-9M*2,AIM-120B*1,GBU-38*4,FT*3,GP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "PG" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 600000,
				firepower = 1,
				vCruise = 245.83333333333,
				vAttack = 300.5,
				hCruise = 7486.4,
				hAttack = 8172,
				standoff = 20000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{BRU55_2*GBU-38}",
						},
						[3] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[4] = {
							CLSID = "{AN_ASQ_228}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[7] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[8] = {
							CLSID = "{BRU55_2*GBU-38}",
						},
						[9] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = "4900",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Old TF Strike LR - AIM-9L*2 - Mk-84*3 - AIM-7MH*2 - FT*2"] = {
				minscore = 0.5,
				support = {
					SEAD = true,
					Escort = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "Structure", "Bridge" },
				code_loadout =  { "TF80s", "TF80sRED", "TF80sI", "WOC80" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 450000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7800,
				hAttack = 7000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
						},
						[3] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[4] = {
							CLSID = "{AIM-7H}",
						},
						[5] = {
							CLSID = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
						},
						[6] = {
							CLSID = "{AIM-7H}",
						},
						[7] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[8] = {
							CLSID = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
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
			["Strike 90s LR-AG-AIM-9M*2,AIM-120B*1,GBU-10*2,FT*3,GP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "Structure" },
				code_loadout =  { "Crisis", "PG" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				range = 600000,
				firepower = 1,
				vCruise = 245.83333333333,
				vAttack = 300.5,
				hCruise = 7486.4,
				hAttack = 7472,
				standoff = 15000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[3] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[4] = {
							CLSID = "{AN_ASQ_228}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[7] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[8] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[9] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 90s SR-AG-AIM-9M*2,AIM-120B*2,MK82HD*8,FT*1"] = {
				minscore = 0.4,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "Crisis", "PG" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				range = 150000,
				firepower = 1,
				vCruise = 245,
				vAttack = 350.5,
				hCruise = 300.4,
				hAttack = 200,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{BRU33_2X_MK-82_Snakeye}",
						},
						[3] = {
							CLSID = "{BRU33_2X_MK-82_Snakeye}",
						},
						[4] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[7] = {
							CLSID = "{BRU33_2X_MK-82_Snakeye}",
						},
						[8] = {
							CLSID = "{BRU33_2X_MK-82_Snakeye}",
						},
						[9] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s LR-AG-AIM-9X*2,AIM-120C*1,GBU-12*4,FT*3,GP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "Bridge", "soft", "Parked Aircraft" },
				code_loadout =  { "TF" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				range = 450000,
				firepower = 1,
				vCruise = 245.83333333333,
				vAttack = 300.5,
				hCruise = 7486.4,
				hAttack = 7472,
				standoff = 15000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[2] = {
							CLSID = "{BRU33_2X_GBU-12}",
						},
						[3] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[4] = {
							CLSID = "{AN_ASQ_228}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[7] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[8] = {
							CLSID = "{BRU33_2X_GBU-12}",
						},
						[9] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s LR-AG-AIM-9X*2,AIM-120C*2,Mk20-Rockeye*4,FT*3"] = {
				minscore = 0.4,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "frontline" },
				code_loadout =  { },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				range = 450000,
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
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[2] = {
							CLSID = "{BRU33_2X_ROCKEYE}",
						},
						[3] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[4] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[7] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[8] = {
							CLSID = "{BRU33_2X_ROCKEYE}",
						},
						[9] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s SR-AG-AIM-9X*2,AIM-120C*2,Mk20-Rockeye*8,FT*1"] = {
				minscore = 0.4,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "frontline" },
				code_loadout =  { },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				range = 150000,
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
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[2] = {
							CLSID = "{BRU33_2X_ROCKEYE}",
						},
						[3] = {
							CLSID = "{BRU33_2X_ROCKEYE}",
						},
						[4] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[7] = {
							CLSID = "{BRU33_2X_ROCKEYE}",
						},
						[8] = {
							CLSID = "{BRU33_2X_ROCKEYE}",
						},
						[9] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 90s SR-AG-AIM-9M*2,AIM-120B*1,GBU-10*4,FT*1,GP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "Structure" },
				code_loadout =  { "Crisis", "PG" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				range = 150000,
				firepower = 1,
				vCruise = 245.83333333333,
				vAttack = 300.5,
				hCruise = 7486.4,
				hAttack = 7472,
				standoff = 15000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[3] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[4] = {
							CLSID = "{AN_ASQ_228}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[7] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[8] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[9] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s WOC LR-AG-AIM-9X*2,AIM-120C*2,MK82HD*4,FT*3"] = {
				minscore = 0.4,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "frontline" },
				code_loadout =  { "Caucasus" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				range = 450000,
				firepower = 1,
				vCruise = 245,
				vAttack = 350.5,
				hCruise = 300.4,
				hAttack = 200,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[2] = {
							CLSID = "{BRU33_2X_MK-82_Snakeye}",
						},
						[3] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[4] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[7] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[8] = {
							CLSID = "{BRU33_2X_MK-82_Snakeye}",
						},
						[9] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 90s SR-AG-AIM-9M*2,AIM-120B*2,MK84LD*4,FT*1"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "Structure" },
				code_loadout =  { "Crisis", "PG" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				range = 150000,
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
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
						},
						[3] = {
							CLSID = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
						},
						[4] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[7] = {
							CLSID = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
						},
						[8] = {
							CLSID = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
						},
						[9] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Old TF Strike LR - AIM-9L*2 - Mk-82*6 - AIM-7MH*2 - FT*2"] = {
				minscore = 0.3,
				support = {
					SEAD = true,
					Escort = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "frontline" },
				code_loadout =  { "TF80s", "TF80sRED", "TF80sI", "WOC80" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				range = 450000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 7800,
				hAttack = 7000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{BRU33_2X_MK-82}",
						},
						[3] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[4] = {
							CLSID = "{AIM-7H}",
						},
						[5] = {
							CLSID = "{BRU33_2X_MK-82}",
						},
						[6] = {
							CLSID = "{AIM-7H}",
						},
						[7] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[8] = {
							CLSID = "{BRU33_2X_MK-82}",
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
			["Strike 90s LR-AG-AIM-9M*2,AIM-120B*1,GBU-12*4,FT*3,GP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "Bridge", "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "Crisis", "PG" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				range = 600000,
				firepower = 1,
				vCruise = 245.83333333333,
				vAttack = 300.5,
				hCruise = 7486.4,
				hAttack = 7472,
				standoff = 15000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{BRU33_2X_GBU-12}",
						},
						[3] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[4] = {
							CLSID = "{AN_ASQ_228}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[7] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[8] = {
							CLSID = "{BRU33_2X_GBU-12}",
						},
						[9] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 90s LR-AG-AIM-9M*2,AIM-120B*1,AGM-65F*2,FT*3,GP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "Crisis", "PG" },
				weaponType = "ASM",
				expend = "Auto",
				attackType = "Dive",
				night = true,
				range = 450000,
				firepower = 1,
				vCruise = 245.83333333333,
				vAttack = 300.5,
				hCruise = 7486.4,
				hAttack = 7472,
				standoff = 15000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[3] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[4] = {
							CLSID = "{AN_ASQ_228}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[7] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[8] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[9] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = "4900",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s LR-AG-AIM-9X*2,AIM-120C*1,GBU-10*2,FT*3,GP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "Structure" },
				code_loadout =  { "TF", "Caucasus" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				range = 450000,
				firepower = 1,
				vCruise = 245.83333333333,
				vAttack = 300.5,
				hCruise = 7486.4,
				hAttack = 7472,
				standoff = 15000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[2] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[3] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[4] = {
							CLSID = "{AN_ASQ_228}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[7] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[8] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
						},
						[9] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s LR-AG-AIM-9X*2,AIM-120C*2,MK82HD*4,FT*3"] = {
				minscore = 0.4,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft" },
				code_loadout =  { "TF" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				range = 450000,
				firepower = 1,
				vCruise = 245,
				vAttack = 350.5,
				hCruise = 300.4,
				hAttack = 200,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[2] = {
							CLSID = "{BRU33_2X_MK-82_Snakeye}",
						},
						[3] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[4] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[7] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[8] = {
							CLSID = "{BRU33_2X_MK-82_Snakeye}",
						},
						[9] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s SR-AG-AIM-9X*2,AIM-120C*1,JSAW-A*8,FT*1,GP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 150000,
				firepower = 1,
				vCruise = 245.83333333333,
				vAttack = 300.5,
				hCruise = 7486.4,
				hAttack = 8172,
				standoff = 60000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[2] = {
							CLSID = "{BRU55_2*AGM-154A}",
						},
						[3] = {
							CLSID = "{BRU55_2*AGM-154A}",
						},
						[4] = {
							CLSID = "{AN_ASQ_228}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[7] = {
							CLSID = "{BRU55_2*AGM-154A}",
						},
						[8] = {
							CLSID = "{BRU55_2*AGM-154A}",
						},
						[9] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
					},
					fuel = "4900",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s LR-AG-AIM-9X*2,AIM-120C*1,JSAW-C*4,FT*3,GP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "Structure", "SAM" },
				code_loadout =  { "TF", "Caucasus" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 450000,
				firepower = 1,
				vCruise = 245.83333333333,
				vAttack = 300.5,
				hCruise = 7486.4,
				hAttack = 8172,
				standoff = 60000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[2] = {
							CLSID = "{BRU55_2*AGM-154C}",
						},
						[3] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[4] = {
							CLSID = "{AN_ASQ_228}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[7] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[8] = {
							CLSID = "{BRU55_2*AGM-154C}",
						},
						[9] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
					},
					fuel = "4900",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 90s SR-AG-AIM-9M*2,AIM-120B*1,GBU-12*8,FT*1,GP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "Bridge", "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "Crisis", "PG" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				range = 150000,
				firepower = 1,
				vCruise = 245.83333333333,
				vAttack = 300.5,
				hCruise = 7486.4,
				hAttack = 7472,
				standoff = 15000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{BRU33_2X_GBU-12}",
						},
						[3] = {
							CLSID = "{BRU33_2X_GBU-12}",
						},
						[4] = {
							CLSID = "{AN_ASQ_228}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[7] = {
							CLSID = "{BRU33_2X_GBU-12}",
						},
						[8] = {
							CLSID = "{BRU33_2X_GBU-12}",
						},
						[9] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s SR-AG-AIM-9X*2,AIM-120C*1,AGM-65F*4,FT*1,GP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "frontline" },
				code_loadout =  { "TF", "Caucasus", "WOB" },
				weaponType = "ASM",
				expend = "Auto",
				attackType = "Dive",
				night = true,
				range = 150000,
				firepower = 1,
				vCruise = 245.83333333333,
				vAttack = 300.5,
				hCruise = 7486.4,
				hAttack = 7472,
				standoff = 15000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[2] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[3] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[4] = {
							CLSID = "{AN_ASQ_228}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[7] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[8] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[9] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
					},
					fuel = "4900",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s LR-AG-AIM-9X*2,AIM-120C*1,GBU-31*2,FT*3,GP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "Structure" },
				code_loadout =  { "TF", "Caucasus", "WOB" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 450000,
				firepower = 1,
				vCruise = 245.83333333333,
				vAttack = 300.5,
				hCruise = 7486.4,
				hAttack = 8172,
				standoff = 20000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[2] = {
							CLSID = "{GBU-31V3B}",
						},
						[3] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[4] = {
							CLSID = "{AN_ASQ_228}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[7] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[8] = {
							CLSID = "{GBU-31V3B}",
						},
						[9] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
					},
					fuel = "4900",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Old TF Precision Strike LR - AIM-9L*2 - AGM-62*2 - AIM-7MH*2 - FT*2 - Pod"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "Bridge", "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "TF80s", "TF80sRED" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				range = 450000,
				firepower = 1,
				vCruise = 245.83333333333,
				vAttack = 300.5,
				hCruise = 7486.4,
				hAttack = 7472,
				standoff = 15000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{C40A1E3A-DD05-40D9-85A4-217729E37FAE}",
						},
						[3] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[4] = {
							CLSID = "{AIM-7H}",
						},
						[5] = {
							CLSID = "{AWW-13}",
						},
						[6] = {
							CLSID = "{AIM-7H}",
						},
						[7] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[8] = {
							CLSID = "{C40A1E3A-DD05-40D9-85A4-217729E37FAE}",
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
			["2000s-TF-Strike-LR-AGM-84H*2-AIM-120C*2-AIM-9x*2-DL-FT*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "SAM-LR" },
				code_loadout =  { "TF", "Caucasus" },
				weaponType = "ASM",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 450000,
				firepower = 1,
				vCruise = 245.83333333333,
				vAttack = 300.5,
				hCruise = 7486.4,
				hAttack = 8172,
				standoff = 110000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[2] = {
							CLSID = "{AGM_84H}",
						},
						[3] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[4] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[5] = {
							CLSID = "{AWW-13}",
						},
						[6] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[7] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[8] = {
							CLSID = "{AGM_84H}",
						},
						[9] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
					},
					fuel = "4900",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 90s LR-AG-AIM-9M*2,AIM-120B*2,Mk20-Rockeye*4,FT*3"] = {
				minscore = 0.4,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				range = 450000,
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
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{BRU33_2X_ROCKEYE}",
						},
						[3] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[4] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[7] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[8] = {
							CLSID = "{BRU33_2X_ROCKEYE}",
						},
						[9] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s SR-AG-AIM-9X*2,AIM-120C*1,GBU-38*8,FT*1,GP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "frontline", "SAM" },
				code_loadout =  { "TF", "Caucasus", "WOB" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 150000,
				firepower = 1,
				vCruise = 245.83333333333,
				vAttack = 300.5,
				hCruise = 7486.4,
				hAttack = 8172,
				standoff = 20000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[2] = {
							CLSID = "{BRU55_2*GBU-38}",
						},
						[3] = {
							CLSID = "{BRU55_2*GBU-38}",
						},
						[4] = {
							CLSID = "{AN_ASQ_228}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[7] = {
							CLSID = "{BRU55_2*GBU-38}",
						},
						[8] = {
							CLSID = "{BRU55_2*GBU-38}",
						},
						[9] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
					},
					fuel = "4900",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s LR-AG-AIM-9X*2,AIM-120C*1,GBU-38*4,FT*3,GP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "frontline", "SAM" },
				code_loadout =  { "TF", "Caucasus", "WOB" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 450000,
				firepower = 1,
				vCruise = 245.83333333333,
				vAttack = 300.5,
				hCruise = 7486.4,
				hAttack = 8172,
				standoff = 20000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[2] = {
							CLSID = "{BRU55_2*GBU-38}",
						},
						[3] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[4] = {
							CLSID = "{AN_ASQ_228}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[7] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[8] = {
							CLSID = "{BRU55_2*GBU-38}",
						},
						[9] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
					},
					fuel = "4900",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s SR-AG-AIM-9X*2,AIM-120C*1,GBU-31*4,FT*1,GP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "Structure" },
				code_loadout =  { "TF", "Caucasus", "WOB" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 150000,
				firepower = 1,
				vCruise = 245.83333333333,
				vAttack = 300.5,
				hCruise = 7486.4,
				hAttack = 8172,
				standoff = 20000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[2] = {
							CLSID = "{GBU-31V3B}",
						},
						[3] = {
							CLSID = "{GBU-31V3B}",
						},
						[4] = {
							CLSID = "{AN_ASQ_228}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[7] = {
							CLSID = "{GBU-31V3B}",
						},
						[8] = {
							CLSID = "{GBU-31V3B}",
						},
						[9] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
					},
					fuel = "4900",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 90s SR-AG-AIM-9M*2,AIM-120B*1,AGM-65F*4,FT*1,GP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "Crisis", "PG" },
				weaponType = "ASM",
				expend = "Auto",
				attackType = "Dive",
				night = true,
				range = 150000,
				firepower = 1,
				vCruise = 245.83333333333,
				vAttack = 300.5,
				hCruise = 7486.4,
				hAttack = 7472,
				standoff = 15000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[3] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[4] = {
							CLSID = "{AN_ASQ_228}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[7] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[8] = {
							CLSID = "LAU_117_AGM_65F",
						},
						[9] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = "4900",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Old TF Strike LR - AIM-9L*2 - Mk-82HD*6 - AIM-7MH*2 - FT*2"] = {
				minscore = 0.3,
				support = {
					SEAD = true,
					Escort = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "TF80s", "TF80sRED", "TF80sI", "WOC80" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				day = false,
				range = 450000,
				firepower = 1,
				vCruise = 245,
				vAttack = 350.5,
				hCruise = 5000,
				hAttack = 100,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{BRU33_2X_MK-82_Snakeye}",
						},
						[3] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[4] = {
							CLSID = "{AIM-7H}",
						},
						[5] = {
							CLSID = "{BRU33_2X_MK-82_Snakeye}",
						},
						[6] = {
							CLSID = "{AIM-7H}",
						},
						[7] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[8] = {
							CLSID = "{BRU33_2X_MK-82_Snakeye}",
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
			["Strike 2000s SR-AG-AIM-9X*2,AIM-120C*2,MK82LD*8,FT*1"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "frontline" },
				code_loadout =  { "Caucasus" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				range = 150000,
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
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[2] = {
							CLSID = "{BRU33_2X_MK-82}",
						},
						[3] = {
							CLSID = "{BRU33_2X_MK-82}",
						},
						[4] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[7] = {
							CLSID = "{BRU33_2X_MK-82}",
						},
						[8] = {
							CLSID = "{BRU33_2X_MK-82}",
						},
						[9] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["2000s-TF- Strike-SR-AGM-84H*4-AIM-120C*2-AIM-9x*2-DL-FT*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "SAM-LR" },
				code_loadout =  { "TF", "Caucasus" },
				weaponType = "ASM",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 450000,
				firepower = 1,
				vCruise = 245.83333333333,
				vAttack = 300.5,
				hCruise = 7486.4,
				hAttack = 8172,
				standoff = 110000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[2] = {
							CLSID = "{AGM_84H}",
						},
						[3] = {
							CLSID = "{AGM_84H}",
						},
						[4] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[5] = {
							CLSID = "{AWW-13}",
						},
						[6] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[7] = {
							CLSID = "{AGM_84H}",
						},
						[8] = {
							CLSID = "{AGM_84H}",
						},
						[9] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
					},
					fuel = "4900",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s SR-AG-AIM-9X*2,AIM-120C*1,GBU-12*8,FT*1,GP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "Bridge", "soft", "Parked Aircraft" },
				code_loadout =  { "TF" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				range = 150000,
				firepower = 1,
				vCruise = 245.83333333333,
				vAttack = 300.5,
				hCruise = 7486.4,
				hAttack = 7472,
				standoff = 15000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[2] = {
							CLSID = "{BRU33_2X_GBU-12}",
						},
						[3] = {
							CLSID = "{BRU33_2X_GBU-12}",
						},
						[4] = {
							CLSID = "{AN_ASQ_228}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[7] = {
							CLSID = "{BRU33_2X_GBU-12}",
						},
						[8] = {
							CLSID = "{BRU33_2X_GBU-12}",
						},
						[9] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 90s LR-AG-AIM-9M*2,AIM-120B*1,GBU-31*2,FT*3,GP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "Structure" },
				code_loadout =  { "PG" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 600000,
				firepower = 1,
				vCruise = 245.83333333333,
				vAttack = 300.5,
				hCruise = 7486.4,
				hAttack = 8172,
				standoff = 20000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{GBU-31V3B}",
						},
						[3] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[4] = {
							CLSID = "{AN_ASQ_228}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[7] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[8] = {
							CLSID = "{GBU-31V3B}",
						},
						[9] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = "4900",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s WOC LR-AG-AIM-9X*2,AIM-120C*1,GBU-12*4,FT*3,GP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "frontline" },
				code_loadout =  { "Caucasus" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				range = 450000,
				firepower = 1,
				vCruise = 245.83333333333,
				vAttack = 300.5,
				hCruise = 7486.4,
				hAttack = 7472,
				standoff = 15000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[2] = {
							CLSID = "{BRU33_2X_GBU-12}",
						},
						[3] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[4] = {
							CLSID = "{AN_ASQ_228}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[7] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[8] = {
							CLSID = "{BRU33_2X_GBU-12}",
						},
						[9] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Strike 2000s LR-AG-AIM-9X*2,AIM-120C*1,JSAW-A*4,FT*3,GP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 450000,
				firepower = 1,
				vCruise = 245.83333333333,
				vAttack = 300.5,
				hCruise = 7486.4,
				hAttack = 8172,
				standoff = 60000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[2] = {
							CLSID = "{BRU55_2*AGM-154A}",
						},
						[3] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[4] = {
							CLSID = "{AN_ASQ_228}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[7] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[8] = {
							CLSID = "{BRU55_2*AGM-154A}",
						},
						[9] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
					},
					fuel = "4900",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
		},
		["Anti-ship Strike"] = {
			["Antiship 80s SR-Anti-Ship-AIM-9L*2,AIM7MH*2,AGM-84D*4,FT*1"] = {
				minscore = 0.3,
				support = {
					SEAD = false,
					Escort = true,
					["Laser Illumination"] = false,
					["Escort Jammer"] = true,
				},
				attributes =  { "ship" },
				code_loadout =  { "TF80s", "TF80sRED", "WOC80" },
				weaponType = "ASM",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 150000,
				firepower = 1,
				vCruise = 245,
				vAttack = 300.5,
				hCruise = 5486.4,
				hAttack = 4572,
				standoff = 60000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{AGM_84D}",
						},
						[3] = {
							CLSID = "{AGM_84D}",
						},
						[4] = {
							CLSID = "{AIM-7H}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{AIM-7H}",
						},
						[7] = {
							CLSID = "{AGM_84D}",
						},
						[8] = {
							CLSID = "{AGM_84D}",
						},
						[9] = {
							CLSID = "{AIM-9L}",
						},
					},
					fuel = "4900",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Antiship 80s LR-Anti-Ship-AIM-9L*2,AIM7MH*2,AGM-84D*2,FT*3"] = {
				minscore = 0.3,
				support = {
					SEAD = false,
					Escort = true,
					["Escort Jammer"] = true,
					["Laser Illumination"] = false,
				},
				attributes =  { "ship" },
				code_loadout =  { "TF80s", "TF80sRED", "TF80sI", "WOC80" },
				weaponType = "ASM",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 450000,
				firepower = 1,
				vCruise = 245,
				vAttack = 300.5,
				hCruise = 5486.4,
				hAttack = 4572,
				standoff = 60000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{AGM_84D}",
						},
						[3] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[4] = {
							CLSID = "{AIM-7H}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{AIM-7H}",
						},
						[7] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[8] = {
							CLSID = "{AGM_84D}",
						},
						[9] = {
							CLSID = "{AIM-9L}",
						},
					},
					fuel = "4900",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Antiship 90s LR-Anti-Ship-AIM-9M*2,AIM-120B*2,AGM-84D*2,FT*3"] = {
				minscore = 0.3,
				support = {
					SEAD = false,
					Escort = true,
					["Laser Illumination"] = false,
					["Escort Jammer"] = true,
				},
				attributes =  { "ship" },
				code_loadout =  { "Crisis", "PG" },
				weaponType = "ASM",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 600000,
				firepower = 1,
				vCruise = 245,
				vAttack = 300.5,
				hCruise = 5486.4,
				hAttack = 4572,
				standoff = 60000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{AGM_84D}",
						},
						[3] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[4] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[7] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[8] = {
							CLSID = "{AGM_84D}",
						},
						[9] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = "4900",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Antiship 90s SR-Anti-Ship-AIM-9M*2,AIM-120B*2,AGM-84D*4,FT*1"] = {
				minscore = 0.3,
				support = {
					SEAD = false,
					Escort = true,
					["Laser Illumination"] = false,
					["Escort Jammer"] = true,
				},
				attributes =  { "ship" },
				code_loadout =  { "Crisis", "PG" },
				weaponType = "ASM",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 150000,
				firepower = 1,
				vCruise = 245,
				vAttack = 300.5,
				hCruise = 5486.4,
				hAttack = 4572,
				standoff = 60000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{AGM_84D}",
						},
						[3] = {
							CLSID = "{AGM_84D}",
						},
						[4] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[7] = {
							CLSID = "{AGM_84D}",
						},
						[8] = {
							CLSID = "{AGM_84D}",
						},
						[9] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = "4900",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Antiship 2000s SR-Anti-Ship-AIM-9X*2,AIM-120C*2,AGM-84D*4,FT*1"] = {
				minscore = 0.3,
				support = {
					SEAD = false,
					Escort = true,
					["Laser Illumination"] = false,
					["Escort Jammer"] = true,
				},
				attributes =  { "ship" },
				code_loadout =  { "TF", "Caucasus", "WOB" },
				weaponType = "ASM",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 150000,
				firepower = 1,
				vCruise = 245,
				vAttack = 300.5,
				hCruise = 5486.4,
				hAttack = 4572,
				standoff = 150000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[2] = {
							CLSID = "{AGM_84D}",
						},
						[3] = {
							CLSID = "{AGM_84D}",
						},
						[4] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[7] = {
							CLSID = "{AGM_84D}",
						},
						[8] = {
							CLSID = "{AGM_84D}",
						},
						[9] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
					},
					fuel = "4900",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Antiship 2000s LR-Anti-Ship-AIM-9X*2,AIM-120C*2,AGM-84D*2,FT*3"] = {
				minscore = 0.3,
				support = {
					SEAD = false,
					Escort = true,
					["Laser Illumination"] = false,
					["Escort Jammer"] = true,
				},
				attributes =  { "ship" },
				code_loadout =  { "TF", "Caucasus", "WOB" },
				weaponType = "ASM",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 600000,
				firepower = 1,
				vCruise = 245,
				vAttack = 300.5,
				hCruise = 5486.4,
				hAttack = 4572,
				standoff = 150000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[2] = {
							CLSID = "{AGM_84D}",
						},
						[3] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[4] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[7] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[8] = {
							CLSID = "{AGM_84D}",
						},
						[9] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
					},
					fuel = "4900",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
		},
		Escort = {
			["Escort 80s LR1 AA - AIM-9L*2 AIM-7MH*4 FT*3"] = {
				attributes =  { },
				code_loadout =  { "TF80s", "TF80sRED", "TF80sI", "WOC80" },
				night = true,
				adverseWeather = true,
				range = 450000,
				firepower = 2,
				vCruise = 255.83333333333,
				standoff = 50000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{LAU-115 - AIM-7H}",
						},
						[3] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[4] = {
							CLSID = "{AIM-7H}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{AIM-7H}",
						},
						[7] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[8] = {
							CLSID = "{LAU-115 - AIM-7H}",
						},
						[9] = {
							CLSID = "{AIM-9L}",
						},
					},
					fuel = "4900",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Escort 90s LR1 AA - AIM-9M*2 AIM-120B*6 FT*3"] = {
				attributes =  { },
				code_loadout =  { "Crisis", "PG" },
				night = true,
				adverseWeather = true,
				range = 600000,
				firepower = 6,
				vCruise = 255.83333333333,
				standoff = 72000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "LAU-115_2*LAU-127_AIM-120B",
						},
						[3] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[4] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[7] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[8] = {
							CLSID = "LAU-115_2*LAU-127_AIM-120B",
						},
						[9] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = "4900",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Escort 2000s LR1 AA - AIM-9X*2 AIM-120C*6 FT*3"] = {
				attributes =  { },
				code_loadout =  { "TF", "Caucasus", "WOB" },
				night = true,
				adverseWeather = true,
				range = 450000,
				firepower = 6,
				vCruise = 255.83333333333,
				standoff = 72000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[2] = {
							CLSID = "LAU-115_2*LAU-127_AIM-120C",
						},
						[3] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[4] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[7] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[8] = {
							CLSID = "LAU-115_2*LAU-127_AIM-120C",
						},
						[9] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
					},
					fuel = "4900",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
		},
		["Fighter Sweep"] = {
			["Fighter Sweep 2000s LR1 AA - AIM-9X*2 AIM-120C*6 FT*3"] = {
				self_escort = true,
				attributes =  { },
				code_loadout =  { "TF", "Caucasus", "WOB" },
				night = true,
				adverseWeather = true,
				range = 600000,
				firepower = 1,
				vCruise = 255.83333333333,
				vAttack = 346.66666666667,
				hCruise = 7096,
				hAttack = 7096,
				standoff = 36000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[2] = {
							CLSID = "LAU-115_2*LAU-127_AIM-120C",
						},
						[3] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[4] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[7] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[8] = {
							CLSID = "LAU-115_2*LAU-127_AIM-120C",
						},
						[9] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
					},
					fuel = "4900",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Fighter Sweep 90s LR1 AA - AIM-9M*2 AIM-120B*6 FT*3"] = {
				self_escort = true,
				attributes =  { },
				code_loadout =  { "Crisis", "PG" },
				night = true,
				adverseWeather = true,
				range = 600000,
				firepower = 1,
				vCruise = 255.83333333333,
				vAttack = 346.66666666667,
				hCruise = 7096,
				hAttack = 7096,
				standoff = 36000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "LAU-115_2*LAU-127_AIM-120B",
						},
						[3] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[4] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[7] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[8] = {
							CLSID = "LAU-115_2*LAU-127_AIM-120B",
						},
						[9] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = "4900",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Fighter Sweep 80s LR1 AA - AIM-9L*2 AIM-7MH*4 FT*3"] = {
				self_escort = true,
				attributes =  { },
				code_loadout =  { "TF80s", "TF80sRED", "TF80sI", "WOC80" },
				night = true,
				adverseWeather = true,
				range = 450000,
				firepower = 1,
				vCruise = 255.83333333333,
				vAttack = 346.66666666667,
				hCruise = 7096,
				hAttack = 7096,
				standoff = 36000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{LAU-115 - AIM-7H}",
						},
						[3] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[4] = {
							CLSID = "{AIM-7H}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{AIM-7H}",
						},
						[7] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[8] = {
							CLSID = "{LAU-115 - AIM-7H}",
						},
						[9] = {
							CLSID = "{AIM-9L}",
						},
					},
					fuel = "4900",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
		},
		SEAD = {
			["SEAD 80s SR-SEAD-AIM-9L*2,AIM7MH*2,AGM-88*4,FT*1"] = {
				attributes =  { },
				code_loadout =  { "TF80s", "TF80sRED" },
				attackType = "Dive",
				night = true,
				adverseWeather = true,
				range = 150000,
				firepower = 2,
				vCruise = 270,
				sortie_rate = 12,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
						},
						[3] = {
							CLSID = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
						},
						[4] = {
							CLSID = "{AIM-7H}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{AIM-7H}",
						},
						[7] = {
							CLSID = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
						},
						[8] = {
							CLSID = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
						},
						[9] = {
							CLSID = "{AIM-9L}",
						},
					},
					fuel = "4900",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["SEAD 90s SR-SEAD-AIM-9M*2,AIM-120B*2,AGM-88*4,FT*1"] = {
				attributes =  { },
				code_loadout =  { "Crisis", "PG" },
				attackType = "Dive",
				night = true,
				adverseWeather = true,
				range = 250000,
				firepower = 2,
				vCruise = 245,
				hCruise = 7016,
				sortie_rate = 12,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
						},
						[3] = {
							CLSID = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
						},
						[4] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[7] = {
							CLSID = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
						},
						[8] = {
							CLSID = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
						},
						[9] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = "4900",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["SEAD 90s LR-SEAD-AIM-9M*2,AIM-120B*2,AGM-88*2,FT*3"] = {
				attributes =  { },
				code_loadout =  { "Crisis", "PG" },
				attackType = "Dive",
				night = true,
				adverseWeather = true,
				range = 514000,
				firepower = 2,
				vCruise = 245,
				hCruise = 7016,
				sortie_rate = 12,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
						},
						[3] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[4] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[7] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[8] = {
							CLSID = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
						},
						[9] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = "4900",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["SEAD 80s LR-SEAD-AIM-9L*2,AIM7MH*2,AGM-88*2,FT*3"] = {
				attributes =  { },
				code_loadout =  { "TF80s", "TF80sRED", "TF80sI", "WOC80" },
				attackType = "Dive",
				night = true,
				adverseWeather = true,
				range = 514000,
				firepower = 2,
				vCruise = 245,
				hCruise = 7016,
				sortie_rate = 12,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
						},
						[3] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[4] = {
							CLSID = "{AIM-7H}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{AIM-7H}",
						},
						[7] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[8] = {
							CLSID = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
						},
						[9] = {
							CLSID = "{AIM-9L}",
						},
					},
					fuel = "4900",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["SEAD 2000s LR-SEAD-AIM-9X*2,AIM-120C*2,AGM-88*2,FT*3"] = {
				attributes =  { },
				code_loadout =  { "Caucasus", "TF", "WOB" },
				attackType = "Dive",
				night = true,
				adverseWeather = true,
				range = 514000,
				firepower = 2,
				vCruise = 245,
				hCruise = 7016,
				sortie_rate = 12,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[2] = {
							CLSID = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
						},
						[3] = {
							CLSID = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
						},
						[4] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[7] = {
							CLSID = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
						},
						[8] = {
							CLSID = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
						},
						[9] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
					},
					fuel = "4900",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["SEAD 2000s SR-SEAD-AIM-9X*2,AIM-120C*2,AGM-88*4,FT*1"] = {
				attributes =  { },
				code_loadout =  { "Caucasus", "TF", "WOB" },
				attackType = "Dive",
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 2,
				vCruise = 245,
				hCruise = 7016,
				sortie_rate = 12,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[2] = {
							CLSID = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
						},
						[3] = {
							CLSID = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
						},
						[4] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[7] = {
							CLSID = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
						},
						[8] = {
							CLSID = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
						},
						[9] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
					},
					fuel = "4900",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
		},
		["Runway Attack"] = {
			["WOB Runway attack SR High Alt AIM-9X*2, AIM-120C-5*2, Mk-82LD*8, FUEL"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "Runway" },
				code_loadout =  { "TF", "Caucasus", "WOB" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 250000,
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
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[2] = {
							CLSID = "{BRU33_2X_MK-82}",
						},
						[3] = {
							CLSID = "{BRU33_2X_MK-82}",
						},
						[4] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[7] = {
							CLSID = "{BRU33_2X_MK-82}",
						},
						[8] = {
							CLSID = "{BRU33_2X_MK-82}",
						},
						[9] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Old TF Runway Strike LR - AIM-9L*2 - Mk-82HD*6 - AIM-7MH*2 - FT*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "Runway" },
				code_loadout =  { "TF80s", "TF80sRED", "TF80sI", "WOC80" },
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
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{BRU33_2X_MK-82_Snakeye}",
						},
						[3] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[4] = {
							CLSID = "{AIM-7H}",
						},
						[5] = {
							CLSID = "{BRU33_2X_MK-82_Snakeye}",
						},
						[6] = {
							CLSID = "{AIM-7H}",
						},
						[7] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[8] = {
							CLSID = "{BRU33_2X_MK-82_Snakeye}",
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
			["WOB Runway attack SR AIM-9X*2, AIM-120C-5*2, Mk-82 Snakeye*8, FUEL"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
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
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[2] = {
							CLSID = "{BRU33_2X_MK-82_Snakeye}",
						},
						[3] = {
							CLSID = "{BRU33_2X_MK-82_Snakeye}",
						},
						[4] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[7] = {
							CLSID = "{BRU33_2X_MK-82_Snakeye}",
						},
						[8] = {
							CLSID = "{BRU33_2X_MK-82_Snakeye}",
						},
						[9] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["WOB Runway attack LR AIM-9X*2, AIM-120C-5*2, Mk-82 Snakeye*4, FUEL*3"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
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
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[2] = {
							CLSID = "{BRU33_2X_MK-82_Snakeye}",
						},
						[3] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[4] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[7] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[8] = {
							CLSID = "{BRU33_2X_MK-82_Snakeye}",
						},
						[9] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["90s Runway attack LR AIM-9M*2, AIM-120B*2, Mk-82 Snakeye*4, FUEL*3"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "Runway" },
				code_loadout =  { "Crisis", "PG" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 425000,
				firepower = 1,
				vCruise = 230,
				vAttack = 277.5,
				hCruise = 7548,
				hAttack = 100,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "{BRU33_2X_MK-82_Snakeye}",
						},
						[3] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[4] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[7] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[8] = {
							CLSID = "{BRU33_2X_MK-82_Snakeye}",
						},
						[9] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = 3249,
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Old TF Runway Strike SR - AIM-9L*2 - Mk-82HD*8 - AIM-7MH*2 - FT*1"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "Runway" },
				code_loadout =  { "TF80s", "TF80sRED", "TF80sI", "WOC80" },
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
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{BRU33_2X_MK-82_Snakeye}",
						},
						[3] = {
							CLSID = "{BRU33_2X_MK-82_Snakeye}",
						},
						[4] = {
							CLSID = "{AIM-7H}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{AIM-7H}",
						},
						[7] = {
							CLSID = "{BRU33_2X_MK-82_Snakeye}",
						},
						[8] = {
							CLSID = "{BRU33_2X_MK-82_Snakeye}",
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
			["90s Runway attack SR AIM-9M*2, AIM-120B*2, Mk-82 Snakeye*8, FUEL"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "Runway" },
				code_loadout =  { "Crisis", "PG" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 265000,
				firepower = 1,
				vCruise = 250,
				vAttack = 277.5,
				hCruise = 6328,
				hAttack = 100,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[2] = {
							CLSID = "{BRU33_2X_MK-82_Snakeye}",
						},
						[3] = {
							CLSID = "{BRU33_2X_MK-82_Snakeye}",
						},
						[4] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[7] = {
							CLSID = "{BRU33_2X_MK-82_Snakeye}",
						},
						[8] = {
							CLSID = "{BRU33_2X_MK-82_Snakeye}",
						},
						[9] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
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
			["CAP 90s LR1 AA - AIM-9M*2 AIM-120B*6 FT*3"] = {
				self_escort = true,
				attributes =  { "CV CAP" },
				code_loadout =  { "Crisis", "PG" },
				night = true,
				adverseWeather = true,
				range = 250000,
				firepower = 6,
				vCruise = 245,
				vAttack = 245,
				hCruise = 7096,
				hAttack = 7096,
				tStation = 2700,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "LAU-115_2*LAU-127_AIM-120B",
						},
						[3] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[4] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[7] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[8] = {
							CLSID = "LAU-115_2*LAU-127_AIM-120B",
						},
						[9] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = "4900",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["CAP 2000s LR1 AA - AIM-9X*2 AIM-120C*6 FT*3"] = {
				self_escort = true,
				attributes =  { "CV CAP" },
				code_loadout =  { "TF", "Caucasus", "WOB" },
				night = true,
				adverseWeather = true,
				range = 250000,
				firepower = 6,
				vCruise = 245,
				vAttack = 245,
				hCruise = 7096,
				hAttack = 7096,
				tStation = 2700,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[2] = {
							CLSID = "LAU-115_2*LAU-127_AIM-120C",
						},
						[3] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[4] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[7] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[8] = {
							CLSID = "LAU-115_2*LAU-127_AIM-120C",
						},
						[9] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
					},
					fuel = "4900",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["CAP 80s LR1 AA - AIM-9L*2 AIM-7MH*4 FT*3"] = {
				self_escort = true,
				attributes =  { },
				code_loadout =  { "TF80s", "TF80sRED", "TF80sI", "WOC80" },
				night = true,
				adverseWeather = true,
				range = 150000,
				firepower = 2,
				vCruise = 245,
				vAttack = 245,
				hCruise = 7096,
				hAttack = 7096,
				tStation = 2700,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{LAU-115 - AIM-7H}",
						},
						[3] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[4] = {
							CLSID = "{AIM-7H}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{AIM-7H}",
						},
						[7] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[8] = {
							CLSID = "{LAU-115 - AIM-7H}",
						},
						[9] = {
							CLSID = "{AIM-9L}",
						},
					},
					fuel = "4900",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
		},
		Intercept = {
			["Intercept 90s SR1 AA - AIM-9M*6 AIM-120B*6 FT*1"] = {
				attributes =  { },
				code_loadout =  { "Crisis", "PG" },
				night = true,
				adverseWeather = true,
				range = 150000,
				firepower = 1,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
						[2] = {
							CLSID = "LAU-115_2*LAU-127_AIM-9M",
						},
						[3] = {
							CLSID = "LAU-115_2*LAU-127_AIM-120B",
						},
						[4] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{C8E06185-7CD6-4C90-959F-044679E90751}",
						},
						[7] = {
							CLSID = "LAU-115_2*LAU-127_AIM-120B",
						},
						[8] = {
							CLSID = "LAU-115_2*LAU-127_AIM-9M",
						},
						[9] = {
							CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
						},
					},
					fuel = "4900",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Intercept 2000s SR1 AA - AIM-9X*6 AIM-120C*6 FT*1"] = {
				attributes =  { },
				code_loadout =  { "Caucasus", "TF", "WOB" },
				night = true,
				adverseWeather = true,
				range = 150000,
				firepower = 1,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
						[2] = {
							CLSID = "LAU-115_2*LAU-127_AIM-120C",
						},
						[3] = {
							CLSID = "LAU-115_2*LAU-127_AIM-120C",
						},
						[4] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
						},
						[7] = {
							CLSID = "LAU-115_2*LAU-127_AIM-120C",
						},
						[8] = {
							CLSID = "LAU-115_2*LAU-127_AIM-120C",
						},
						[9] = {
							CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
						},
					},
					fuel = "4900",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Intercept 80s SR1 AA - AIM-9L*6 AIM-7MH*4 FT*1"] = {
				attributes =  { },
				code_loadout =  { "TF80s", "TF80sRED", "TF80sI", "WOC80" },
				night = true,
				adverseWeather = true,
				range = 150000,
				firepower = 1,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "LAU-115_2*LAU-127_AIM-9L",
						},
						[3] = {
							CLSID = "{LAU-115 - AIM-7H}",
						},
						[4] = {
							CLSID = "{AIM-7H}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{AIM-7H}",
						},
						[7] = {
							CLSID = "{LAU-115 - AIM-7H}",
						},
						[8] = {
							CLSID = "LAU-115_2*LAU-127_AIM-9L",
						},
						[9] = {
							CLSID = "{AIM-9L}",
						},
					},
					fuel = "4900",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
			["Intercept 80s SR2 AA - AIM-9L*2 AIM-7MH*6 FT*1"] = {
				attributes =  { },
				code_loadout =  { "TF80s", "TF80sRED", "TF80sI", "WOC80" },
				night = true,
				adverseWeather = true,
				range = 150000,
				firepower = 1,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{AIM-9L}",
						},
						[2] = {
							CLSID = "{LAU-115 - AIM-7H}",
						},
						[3] = {
							CLSID = "{LAU-115 - AIM-7H}",
						},
						[4] = {
							CLSID = "{AIM-7H}",
						},
						[5] = {
							CLSID = "{FPU_8A_FUEL_TANK}",
						},
						[6] = {
							CLSID = "{AIM-7H}",
						},
						[7] = {
							CLSID = "{LAU-115 - AIM-7H}",
						},
						[8] = {
							CLSID = "{LAU-115 - AIM-7H}",
						},
						[9] = {
							CLSID = "{AIM-9L}",
						},
					},
					fuel = "4900",
					flare = 60,
					chaff = 60,
					gun = 100,
				},
			},
		},
	}
}