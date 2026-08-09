--Loadouts database
--F14 loadouts
-------------------------------------------------------------------------------------------------------

if not versionDCE then versionDCE = {} end
versionDCE["db_loadouts/db_loadouts_F14.lua"] = "1.1.3"

-- 1.1.3 - AIM-9J for F-14A-95-GR for IRIAF - F-14BU for modern campaigns
-- 1.1.2 - F-14A-135-GR-Early for TF80s and F-14A-95-GR for IRIAF
-- 1.1.1 - Beginning of the versions of this loadouts file dedicated to the F4.


db_loadouts = {
	["F-14A-135-GR-Early"] = {
		CAP = {
			["80s AA AIM-54A-MK47*2, AIM-7MH*3, AIM-9L*2, XT*2"] = {
				attributes =  { "CV CAP" },
				code_loadout =  { "TF80s", "TF80sRED", "TF80sI", "WOC80" },
				night = true,
				adverseWeather = true,
				range = 450000,
				firepower = 3.5,
				vCruise = 213.83333333333,
				vAttack = 213.83333333333,
				hCruise = 9753.6,
				hAttack = 9753.6,
				standoff = 100300,
				tStation = 3600,
				LDSD = true,
				sortie_rate = 5,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{LAU-138 wtip - AIM-9L}",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "{LAU-138 wtip - AIM-9L}",
					["num"] = 1,
				},
				[3] = {
					["CLSID"] = "{F14-300gal}",
					["num"] = 3,
				},
				[4] = {
					["CLSID"] = "{F14-300gal}",
					["num"] = 8,
				},
				[5] = {
					["CLSID"] = "{SHOULDER AIM-7M}",
					["num"] = 9,
				},
				[6] = {
					["CLSID"] = "{SHOULDER AIM-7M}",
					["num"] = 2,
				},
				[7] = {
					["CLSID"] = "{AIM_54A_Mk47}",
					["num"] = 7,
				},
				[8] = {
					["CLSID"] = "{AIM_54A_Mk47}",
					["num"] = 4,
				},
				[9] = {
					["CLSID"] = "{BELLY AIM-7M}",
					["num"] = 5,
				},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
			["80s AA AIM-54A-MK47*4, AIM-7MH*2, AIM-9L*2,XT*2"] = {
				attributes =  { "CV CAP" },
				code_loadout =  { "TF80s", "TF80sI", "WOC80" },
				night = true,
				adverseWeather = true,
				range = 450000,
				firepower = 5,
				vCruise = 213.83333333333,
				vAttack = 213.83333333333,
				hCruise = 9753.6,
				hAttack = 9753.6,
				standoff = 100300,
				tStation = 3600,
				LDSD = true,
				sortie_rate = 5,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{LAU-138 wtip - AIM-9L}",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "{LAU-138 wtip - AIM-9L}",
					["num"] = 1,
				},
				[3] = {
					["CLSID"] = "{F14-300gal}",
					["num"] = 3,
				},
				[4] = {
					["CLSID"] = "{F14-300gal}",
					["num"] = 8,
				},
				[5] = {
					["CLSID"] = "{SHOULDER AIM-7M}",
					["num"] = 9,
				},
				[6] = {
					["CLSID"] = "{SHOULDER AIM-7M}",
					["num"] = 2,
				},
				[7] = {
					["CLSID"] = "{AIM_54A_Mk47}",
					["num"] = 7,
				},
				[8] = {
					["CLSID"] = "{AIM_54A_Mk47}",
					["num"] = 4,
				},
				[9] = {
					["CLSID"] = "{AIM_54A_Mk47}",
					["num"] = 6,
				},
				[10] = {
					["CLSID"] = "{AIM_54A_Mk47}",
					["num"] = 5,
				},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
		},
		["Fighter Sweep"] = {
			["80s AA AIM-54A-MK47*2, AIM-7MH*3, AIM-9L*2, XT*2"] = {
				attributes =  { },
				code_loadout =  { "TF80s", "TF80sRED", "TF80sI", "WOC80" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 3.5,
				vCruise = 213.83333333333,
				vAttack = 213.83333333333,
				hCruise = 9753.6,
				hAttack = 9753.6,
				standoff = 100300,
				tStation = 3600,
				LDSD = true,
				sortie_rate = 5,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{LAU-138 wtip - AIM-9L}",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "{LAU-138 wtip - AIM-9L}",
					["num"] = 1,
				},
				[3] = {
					["CLSID"] = "{F14-300gal}",
					["num"] = 3,
				},
				[4] = {
					["CLSID"] = "{F14-300gal}",
					["num"] = 8,
				},
				[5] = {
					["CLSID"] = "{SHOULDER AIM-7M}",
					["num"] = 9,
				},
				[6] = {
					["CLSID"] = "{SHOULDER AIM-7M}",
					["num"] = 2,
				},
				[7] = {
					["CLSID"] = "{AIM_54A_Mk47}",
					["num"] = 7,
				},
				[8] = {
					["CLSID"] = "{AIM_54A_Mk47}",
					["num"] = 4,
				},
				[9] = {
					["CLSID"] = "{BELLY AIM-7M}",
					["num"] = 5,
				},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
			["80s AA AIM-54A-MK47*4, AIM-7MH*2, AIM-9L*2,XT*2"] = {
				attributes =  { },
				code_loadout =  { "TF80s", "TF80sI", "WOC80" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 5,
				vCruise = 213.83333333333,
				vAttack = 213.83333333333,
				hCruise = 9753.6,
				hAttack = 9753.6,
				standoff = 100300,
				tStation = 3600,
				LDSD = true,
				sortie_rate = 5,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{LAU-138 wtip - AIM-9L}",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "{LAU-138 wtip - AIM-9L}",
					["num"] = 1,
				},
				[3] = {
					["CLSID"] = "{F14-300gal}",
					["num"] = 3,
				},
				[4] = {
					["CLSID"] = "{F14-300gal}",
					["num"] = 8,
				},
				[5] = {
					["CLSID"] = "{SHOULDER AIM-7M}",
					["num"] = 9,
				},
				[6] = {
					["CLSID"] = "{SHOULDER AIM-7M}",
					["num"] = 2,
				},
				[7] = {
					["CLSID"] = "{AIM_54A_Mk47}",
					["num"] = 7,
				},
				[8] = {
					["CLSID"] = "{AIM_54A_Mk47}",
					["num"] = 4,
				},
				[9] = {
					["CLSID"] = "{AIM_54A_Mk47}",
					["num"] = 6,
				},
				[10] = {
					["CLSID"] = "{AIM_54A_Mk47}",
					["num"] = 5,
				},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
		},
		Escort = {
			["80s AA AIM-54A-MK47*2, AIM-7MH*3, AIM-9L*2, XT*2"] = {
				attributes =  { },
				code_loadout =  { "TF80s", "TF80sRED", "TF80sI", "WOC80" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 3.5,
				vCruise = 255.83333333333,
				standoff = 80300,
				LDSD = true,
				sortie_rate = 5,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{LAU-138 wtip - AIM-9L}",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "{LAU-138 wtip - AIM-9L}",
					["num"] = 1,
				},
				[3] = {
					["CLSID"] = "{F14-300gal}",
					["num"] = 3,
				},
				[4] = {
					["CLSID"] = "{F14-300gal}",
					["num"] = 8,
				},
				[5] = {
					["CLSID"] = "{SHOULDER AIM-7M}",
					["num"] = 9,
				},
				[6] = {
					["CLSID"] = "{SHOULDER AIM-7M}",
					["num"] = 2,
				},
				[7] = {
					["CLSID"] = "{AIM_54A_Mk47}",
					["num"] = 7,
				},
				[8] = {
					["CLSID"] = "{AIM_54A_Mk47}",
					["num"] = 4,
				},
				[9] = {
					["CLSID"] = "{BELLY AIM-7M}",
					["num"] = 5,
				},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
			["80s AA AIM-54A-MK47*4, AIM-7MH*2, AIM-9L*2,XT*2"] = {
				attributes =  { },
				code_loadout =  { "TF80s", "TF80sI", "WOC80" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 5,
				vCruise = 255.83333333333,
				standoff = 80300,
				LDSD = true,
				sortie_rate = 5,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{LAU-138 wtip - AIM-9L}",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "{LAU-138 wtip - AIM-9L}",
					["num"] = 1,
				},
				[3] = {
					["CLSID"] = "{F14-300gal}",
					["num"] = 3,
				},
				[4] = {
					["CLSID"] = "{F14-300gal}",
					["num"] = 8,
				},
				[5] = {
					["CLSID"] = "{SHOULDER AIM-7M}",
					["num"] = 9,
				},
				[6] = {
					["CLSID"] = "{SHOULDER AIM-7M}",
					["num"] = 2,
				},
				[7] = {
					["CLSID"] = "{AIM_54A_Mk47}",
					["num"] = 7,
				},
				[8] = {
					["CLSID"] = "{AIM_54A_Mk47}",
					["num"] = 4,
				},
				[9] = {
					["CLSID"] = "{AIM_54A_Mk47}",
					["num"] = 6,
				},
				[10] = {
					["CLSID"] = "{AIM_54A_Mk47}",
					["num"] = 5,
				},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
		},
		Intercept = {
			["80s AA AIM-54A-MK47*2, AIM-7MH*3, AIM-9L*2, XT*2"] = {
				attributes =  { },
				code_loadout =  { "TF80s", "TF80sRED", "TF80sI", "WOC80" },
				night = true,
				adverseWeather = true,
				range = 450000,
				firepower = 3.5,
				sortie_rate = 5,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{LAU-138 wtip - AIM-9L}",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "{LAU-138 wtip - AIM-9L}",
					["num"] = 1,
				},
				[3] = {
					["CLSID"] = "{F14-300gal}",
					["num"] = 3,
				},
				[4] = {
					["CLSID"] = "{F14-300gal}",
					["num"] = 8,
				},
				[5] = {
					["CLSID"] = "{SHOULDER AIM-7M}",
					["num"] = 9,
				},
				[6] = {
					["CLSID"] = "{SHOULDER AIM-7M}",
					["num"] = 2,
				},
				[7] = {
					["CLSID"] = "{AIM_54A_Mk47}",
					["num"] = 7,
				},
				[8] = {
					["CLSID"] = "{AIM_54A_Mk47}",
					["num"] = 4,
				},
				[9] = {
					["CLSID"] = "{BELLY AIM-7M}",
					["num"] = 5,
				},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
			["80s AA AIM-54A-MK47*4, AIM-7MH*2, AIM-9L*2,XT*2"] = {
				attributes =  { },
				code_loadout =  { "TF80s", "TF80sI", "WOC80" },
				night = true,
				adverseWeather = true,
				range = 450000,
				firepower = 5,
				sortie_rate = 5,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{LAU-138 wtip - AIM-9L}",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "{LAU-138 wtip - AIM-9L}",
					["num"] = 1,
				},
				[3] = {
					["CLSID"] = "{F14-300gal}",
					["num"] = 3,
				},
				[4] = {
					["CLSID"] = "{F14-300gal}",
					["num"] = 8,
				},
				[5] = {
					["CLSID"] = "{SHOULDER AIM-7M}",
					["num"] = 9,
				},
				[6] = {
					["CLSID"] = "{SHOULDER AIM-7M}",
					["num"] = 2,
				},
				[7] = {
					["CLSID"] = "{AIM_54A_Mk47}",
					["num"] = 7,
				},
				[8] = {
					["CLSID"] = "{AIM_54A_Mk47}",
					["num"] = 4,
				},
				[9] = {
					["CLSID"] = "{AIM_54A_Mk47}",
					["num"] = 6,
				},
				[10] = {
					["CLSID"] = "{AIM_54A_Mk47}",
					["num"] = 5,
				},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
		},
	},
	["F-14A-135-GR"] = {
		CAP = {
			["80s AA AIM-54A-MK47*2, AIM-7MH*3, AIM-9L*2, XT*2"] = {
				attributes =  { "CV CAP" },
				code_loadout =  { "TF80s", "TF80sRED", "TF80sI", "WOC80" },
				night = true,
				adverseWeather = true,
				range = 450000,
				firepower = 3.5,
				vCruise = 213.83333333333,
				vAttack = 213.83333333333,
				hCruise = 9753.6,
				hAttack = 9753.6,
				standoff = 100300,
				tStation = 3600,
				LDSD = true,
				sortie_rate = 5,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{LAU-138 wtip - AIM-9L}",
						},
						[2] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[3] = {
							CLSID = "{F14-300gal}",
						},
						[4] = {
							CLSID = "{AIM_54A_Mk47}",
						},
						[5] = {
							CLSID = "{BELLY AIM-7MH}",
						},
						[7] = {
							CLSID = "{AIM_54A_Mk47}",
						},
						[8] = {
							CLSID = "{F14-300gal}",
						},
						[9] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[10] = {
							CLSID = "{LAU-138 wtip - AIM-9L}",
						},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
			["80s AA AIM-54A-MK47*4, AIM-7MH*2, AIM-9L*2,XT*2"] = {
				attributes =  { "CV CAP" },
				code_loadout =  { "TF80s", "TF80sI", "WOC80" },
				night = true,
				adverseWeather = true,
				range = 450000,
				firepower = 5,
				vCruise = 213.83333333333,
				vAttack = 213.83333333333,
				hCruise = 9753.6,
				hAttack = 9753.6,
				standoff = 100300,
				tStation = 3600,
				LDSD = true,
				sortie_rate = 5,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{LAU-138 wtip - AIM-9L}",
						},
						[2] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[3] = {
							CLSID = "{F14-300gal}",
						},
						[4] = {
							CLSID = "{AIM_54A_Mk47}",
						},
						[5] = {
							CLSID = "{AIM_54A_Mk47}",
						},
						[6] = {
							CLSID = "{AIM_54A_Mk47}",
						},
						[7] = {
							CLSID = "{AIM_54A_Mk47}",
						},
						[8] = {
							CLSID = "{F14-300gal}",
						},
						[9] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[10] = {
							CLSID = "{LAU-138 wtip - AIM-9L}",
						},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
		},
		["Fighter Sweep"] = {
			["80s AA AIM-54A-MK47*2, AIM-7MH*3, AIM-9L*2, XT*2"] = {
				attributes =  { },
				code_loadout =  { "TF80s", "TF80sRED", "TF80sI", "WOC80" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 3.5,
				vCruise = 213.83333333333,
				vAttack = 213.83333333333,
				hCruise = 9753.6,
				hAttack = 9753.6,
				standoff = 100300,
				tStation = 3600,
				LDSD = true,
				sortie_rate = 5,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{LAU-138 wtip - AIM-9L}",
						},
						[2] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[3] = {
							CLSID = "{F14-300gal}",
						},
						[4] = {
							CLSID = "{AIM_54A_Mk47}",
						},
						[5] = {
							CLSID = "{BELLY AIM-7MH}",
						},
						[7] = {
							CLSID = "{AIM_54A_Mk47}",
						},
						[8] = {
							CLSID = "{F14-300gal}",
						},
						[9] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[10] = {
							CLSID = "{LAU-138 wtip - AIM-9L}",
						},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
			["80s AA AIM-54A-MK47*4, AIM-7MH*2, AIM-9L*2,XT*2"] = {
				attributes =  { },
				code_loadout =  { "TF80s", "TF80sI", "WOC80" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 5,
				vCruise = 213.83333333333,
				vAttack = 213.83333333333,
				hCruise = 9753.6,
				hAttack = 9753.6,
				standoff = 100300,
				tStation = 3600,
				LDSD = true,
				sortie_rate = 5,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{LAU-138 wtip - AIM-9L}",
						},
						[2] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[3] = {
							CLSID = "{F14-300gal}",
						},
						[4] = {
							CLSID = "{AIM_54A_Mk47}",
						},
						[5] = {
							CLSID = "{AIM_54A_Mk47}",
						},
						[6] = {
							CLSID = "{AIM_54A_Mk47}",
						},
						[7] = {
							CLSID = "{AIM_54A_Mk47}",
						},
						[8] = {
							CLSID = "{F14-300gal}",
						},
						[9] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[10] = {
							CLSID = "{LAU-138 wtip - AIM-9L}",
						},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
		},
		Escort = {
			["80s AA AIM-54A-MK47*2, AIM-7MH*3, AIM-9L*2, XT*2"] = {
				attributes =  { },
				code_loadout =  { "TF80s", "TF80sRED", "TF80sI", "WOC80" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 3.5,
				vCruise = 255.83333333333,
				standoff = 80300,
				LDSD = true,
				sortie_rate = 5,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{LAU-138 wtip - AIM-9L}",
						},
						[2] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[3] = {
							CLSID = "{F14-300gal}",
						},
						[4] = {
							CLSID = "{AIM_54A_Mk47}",
						},
						[5] = {
							CLSID = "{BELLY AIM-7MH}",
						},
						[7] = {
							CLSID = "{AIM_54A_Mk47}",
						},
						[8] = {
							CLSID = "{F14-300gal}",
						},
						[9] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[10] = {
							CLSID = "{LAU-138 wtip - AIM-9L}",
						},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
			["80s AA AIM-54A-MK47*4, AIM-7MH*2, AIM-9L*2,XT*2"] = {
				attributes =  { },
				code_loadout =  { "TF80s", "TF80sI", "WOC80" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 5,
				vCruise = 255.83333333333,
				standoff = 80300,
				LDSD = true,
				sortie_rate = 5,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{LAU-138 wtip - AIM-9L}",
						},
						[2] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[3] = {
							CLSID = "{F14-300gal}",
						},
						[4] = {
							CLSID = "{AIM_54A_Mk47}",
						},
						[5] = {
							CLSID = "{AIM_54A_Mk47}",
						},
						[6] = {
							CLSID = "{AIM_54A_Mk47}",
						},
						[7] = {
							CLSID = "{AIM_54A_Mk47}",
						},
						[8] = {
							CLSID = "{F14-300gal}",
						},
						[9] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[10] = {
							CLSID = "{LAU-138 wtip - AIM-9L}",
						},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
		},
		Intercept = {
			["80s AA AIM-54A-MK47*2, AIM-7MH*3, AIM-9L*2, XT*2"] = {
				attributes =  { },
				code_loadout =  { "TF80s", "TF80sRED", "TF80sI", "WOC80" },
				night = true,
				adverseWeather = true,
				range = 450000,
				firepower = 3.5,
				sortie_rate = 5,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{LAU-138 wtip - AIM-9L}",
						},
						[2] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[3] = {
							CLSID = "{F14-300gal}",
						},
						[4] = {
							CLSID = "{BELLY AIM-7MH}",
						},
						[5] = {
							CLSID = "{BELLY AIM-7MH}",
						},
						[7] = {
							CLSID = "{BELLY AIM-7MH}",
						},
						[8] = {
							CLSID = "{F14-300gal}",
						},
						[9] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[10] = {
							CLSID = "{LAU-138 wtip - AIM-9L}",
						},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
			["80s AA AIM-54A-MK47*4, AIM-7MH*2, AIM-9L*2,XT*2"] = {
				attributes =  { },
				code_loadout =  { "TF80s", "TF80sI", "WOC80" },
				night = true,
				adverseWeather = true,
				range = 450000,
				firepower = 5,
				sortie_rate = 5,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{LAU-138 wtip - AIM-9L}",
						},
						[2] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[3] = {
							CLSID = "{F14-300gal}",
						},
						[4] = {
							CLSID = "{AIM_54A_Mk47}",
						},
						[5] = {
							CLSID = "{AIM_54A_Mk47}",
						},
						[6] = {
							CLSID = "{AIM_54A_Mk47}",
						},
						[7] = {
							CLSID = "{AIM_54A_Mk47}",
						},
						[8] = {
							CLSID = "{F14-300gal}",
						},
						[9] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[10] = {
							CLSID = "{LAU-138 wtip - AIM-9L}",
						},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
		},
	},
	["F-14B"] = {
		Strike = {
			["Strike 90s-2000s AG - GBU-12*4, AIM-9M*2, AIM-7M*1,Lantirn, FT*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "frontline" },
				code_loadout =  { "Crisis", "PG", "TF", "Caucasus", "WOB" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				range = 450000,
				firepower = 1,
				vCruise = 245,
				vAttack = 300.5,
				hCruise = 5486.4,
				hAttack = 4572,
				standoff = 15000,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
						[2] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[3] = {
							CLSID = "{F14-300gal}",
						},
						[4] = {
							CLSID = "{BRU-32 GBU-12}",
						},
						[5] = {
							CLSID = "{BRU-32 GBU-12}",
						},
						[6] = {
							CLSID = "{BRU-32 GBU-12}",
						},
						[7] = {
							CLSID = "{BRU-32 GBU-12}",
						},
						[8] = {
							CLSID = "{F14-300gal}",
						},
						[9] = {
							CLSID = "{F14-LANTIRN-TP}",
						},
						[10] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
			["Strike 90s-2000s AG - Mk84LD*2-AIM-54C-MK47*2, AIM-7MH*2, AIM-9M*2, XT*2"] = {
				minscore = 0.4,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Structure", "Bridge" },
				code_loadout =  { "Crisis", "PG", "TF", "Caucasus", "WOB" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				range = 450000,
				firepower = 1,
				vCruise = 245,
				vAttack = 300.5,
				hCruise = 5486.4,
				hAttack = 4572,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
						[2] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[3] = {
							CLSID = "{F14-300gal}",
						},
						[4] = {
							CLSID = "{AIM_54C_Mk47}",
						},
						[5] = {
							CLSID = "{BRU-32 MK-84}",
						},
						[6] = {
							CLSID = "{BRU-32 MK-84}",
						},
						[7] = {
							CLSID = "{AIM_54C_Mk47}",
						},
						[8] = {
							CLSID = "{F14-300gal}",
						},
						[9] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[10] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
			["Strike 90s-2000s AG - GBU24*1-AIM-54C-MK47*2, AIM-7MH*1, AIM-9M*2, XT*2, GP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Structure", "Bridge" },
				code_loadout =  { "Crisis", "PG", "TF", "Caucasus", "WOB" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				range = 450000,
				firepower = 1,
				vCruise = 245,
				vAttack = 300.5,
				hCruise = 5486.4,
				hAttack = 4572,
				standoff = 15000,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
						[2] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[3] = {
							CLSID = "{F14-300gal}",
						},
						[4] = {
							CLSID = "{AIM_54C_Mk47}",
						},
						[5] = {
							CLSID = "<CLEAN>",
						},
						[6] = {
							CLSID = "{BRU-32 GBU-24}",
						},
						[7] = {
							CLSID = "{AIM_54C_Mk47}",
						},
						[8] = {
							CLSID = "{F14-300gal}",
						},
						[9] = {
							CLSID = "{F14-LANTIRN-TP}",
						},
						[10] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
			["Strike 90s-2000s AG - GBU24*2, AIM-7MH*1, AIM-9M*2, XT*2, GP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Structure", "Bridge" },
				code_loadout =  { "Crisis", "PG", "TF", "Caucasus", "WOB" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				range = 450000,
				firepower = 1,
				vCruise = 245,
				vAttack = 300.5,
				hCruise = 5486.4,
				hAttack = 4572,
				standoff = 15000,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
						[2] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[3] = {
							CLSID = "{F14-300gal}",
						},
						[4] = {
							CLSID = "{BRU-32 GBU-24}",
						},
						[5] = {
							CLSID = "<CLEAN>",
						},
						[6] = {
							CLSID = "{BRU-32 GBU-24}",
						},
						[7] = {
							CLSID = "<CLEAN>",
						},
						[8] = {
							CLSID = "{F14-300gal}",
						},
						[9] = {
							CLSID = "{F14-LANTIRN-TP}",
						},
						[10] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
			["Strike 90s-2000s AG - GBU16*4, AIM-7MH*1, AIM-9M*2, XT*2, GP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Structure", "Bridge" },
				code_loadout =  { "Crisis", "PG", "TF", "Caucasus", "WOB" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				range = 450000,
				firepower = 1,
				vCruise = 245,
				vAttack = 300.5,
				hCruise = 5486.4,
				hAttack = 4572,
				standoff = 15000,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
						[2] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[3] = {
							CLSID = "{F14-300gal}",
						},
						[4] = {
							CLSID = "{BRU-32 GBU-16}",
						},
						[5] = {
							CLSID = "{BRU-32 GBU-16}",
						},
						[6] = {
							CLSID = "{BRU-32 GBU-16}",
						},
						[7] = {
							CLSID = "{BRU-32 GBU-16}",
						},
						[8] = {
							CLSID = "{F14-300gal}",
						},
						[9] = {
							CLSID = "{F14-LANTIRN-TP}",
						},
						[10] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
			["Strike 90s-2000s AG - Mk20*2-AIM-54C-MK47*2, AIM-7MH*2, AIM-9M*2, XT*2"] = {
				minscore = 0.4,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "frontline", "WOB" },
				code_loadout =  { },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				range = 450000,
				firepower = 1,
				vCruise = 245,
				vAttack = 300.5,
				hCruise = 5486.4,
				hAttack = 4572,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
						[2] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[3] = {
							CLSID = "{F14-300gal}",
						},
						[4] = {
							CLSID = "{AIM_54C_Mk47}",
						},
						[5] = {
							CLSID = "{MAK79_MK20 1L}",
						},
						[6] = {
							CLSID = "{MAK79_MK20 1R}",
						},
						[7] = {
							CLSID = "{AIM_54C_Mk47}",
						},
						[8] = {
							CLSID = "{F14-300gal}",
						},
						[9] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[10] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
			["Strike 90s-2000s AG - GBU12*2-AIM-54C-MK47*2, AIM-7MH*1, AIM-9M*2, XT*2, GP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "frontline" },
				code_loadout =  { "Crisis", "PG", "TF", "Caucasus", "WOB" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				range = 450000,
				firepower = 1,
				vCruise = 245,
				vAttack = 300.5,
				hCruise = 5486.4,
				hAttack = 4572,
				standoff = 15000,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
						[2] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[3] = {
							CLSID = "{F14-300gal}",
						},
						[4] = {
							CLSID = "{AIM_54C_Mk47}",
						},
						[5] = {
							CLSID = "{BRU-32 GBU-12}",
						},
						[6] = {
							CLSID = "{BRU-32 GBU-12}",
						},
						[7] = {
							CLSID = "{AIM_54C_Mk47}",
						},
						[8] = {
							CLSID = "{F14-300gal}",
						},
						[9] = {
							CLSID = "{F14-LANTIRN-TP}",
						},
						[10] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
			["Strike 90s-2000s AG - Mk82HD*6-AIM-54C-MK47*2, AIM-7MH*2, AIM-9M*2, XT*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "frontline" },
				code_loadout =  { "Crisis", "PG", "TF", "Caucasus", "WOB" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				range = 500000,
				firepower = 1,
				vCruise = 245,
				vAttack = 300.5,
				hCruise = 306.4,
				hAttack = 100,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
						[2] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[3] = {
							CLSID = "{F14-300gal}",
						},
						[4] = {
							CLSID = "{AIM_54C_Mk47}",
						},
						[5] = {
							CLSID = "{MAK79_MK82SE 3L}",
						},
						[6] = {
							CLSID = "{MAK79_MK82SE 3R}",
						},
						[7] = {
							CLSID = "{AIM_54C_Mk47}",
						},
						[8] = {
							CLSID = "{F14-300gal}",
						},
						[9] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[10] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
			["Strike 90s-2000s AG - Mk83LD*2-AIM-54C-MK47*2, AIM-7MH*2, AIM-9M*2, XT*2"] = {
				minscore = 0.4,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Structure", "Bridge" },
				code_loadout =  { "Crisis", "PG", "TF", "Caucasus", "WOB" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				range = 450000,
				firepower = 1,
				vCruise = 245,
				vAttack = 300.5,
				hCruise = 5486.4,
				hAttack = 4572,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
						[2] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[3] = {
							CLSID = "{F14-300gal}",
						},
						[4] = {
							CLSID = "{AIM_54C_Mk47}",
						},
						[5] = {
							CLSID = "{MAK79_MK83 1L}",
						},
						[6] = {
							CLSID = "{MAK79_MK83 1R}",
						},
						[7] = {
							CLSID = "{AIM_54C_Mk47}",
						},
						[8] = {
							CLSID = "{F14-300gal}",
						},
						[9] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[10] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
			["Strike 90s-2000s AG - GBU16*2-AIM-54C-MK47*2, AIM-7MH*1, AIM-9M*2, XT*2, GP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Structure", "Bridge" },
				code_loadout =  { "Crisis", "PG", "TF", "Caucasus", "WOB" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				range = 450000,
				firepower = 1,
				vCruise = 245,
				vAttack = 300.5,
				hCruise = 5486.4,
				hAttack = 4572,
				standoff = 15000,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
						[2] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[3] = {
							CLSID = "{F14-300gal}",
						},
						[4] = {
							CLSID = "{AIM_54C_Mk47}",
						},
						[5] = {
							CLSID = "{BRU-32 GBU-16}",
						},
						[6] = {
							CLSID = "{BRU-32 GBU-16}",
						},
						[7] = {
							CLSID = "{AIM_54C_Mk47}",
						},
						[8] = {
							CLSID = "{F14-300gal}",
						},
						[9] = {
							CLSID = "{F14-LANTIRN-TP}",
						},
						[10] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
			["Strike 90s-2000s AG - Mk82LD*6-AIM-54C-MK47*2, AIM-7MH*2, AIM-9M*2, XT*2"] = {
				minscore = 0.4,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "frontline" },
				code_loadout =  { "Crisis", "PG", "TF", "Caucasus", "WOB" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				range = 450000,
				firepower = 1,
				vCruise = 245,
				vAttack = 300.5,
				hCruise = 5486.4,
				hAttack = 4572,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
						[2] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[3] = {
							CLSID = "{F14-300gal}",
						},
						[4] = {
							CLSID = "{AIM_54C_Mk47}",
						},
						[5] = {
							CLSID = "{MAK79_MK82 3L}",
						},
						[6] = {
							CLSID = "{MAK79_MK82 3R}",
						},
						[7] = {
							CLSID = "{AIM_54C_Mk47}",
						},
						[8] = {
							CLSID = "{F14-300gal}",
						},
						[9] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[10] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
		},
		["Fighter Sweep"] = {
			["90s-2000s AA-1 - AIM-54C-MK47*4, AIM-7MH*2, AIM-9M*2, XT*2"] = {
				attributes =  { },
				code_loadout =  { "Crisis", "PG", "TF", "Caucasus", "WOB" },
				night = true,
				adverseWeather = true,
				range = 550000,
				firepower = 5,
				vCruise = 255.83333333333,
				vAttack = 315.83333333333,
				hCruise = 9753.6,
				hAttack = 9753.6,
				standoff = 100300,
				tStation = 7200,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
						[2] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[3] = {
							CLSID = "{F14-300gal}",
						},
						[4] = {
							CLSID = "{AIM_54C_Mk47}",
						},
						[5] = {
							CLSID = "{AIM_54C_Mk47}",
						},
						[6] = {
							CLSID = "{AIM_54C_Mk47}",
						},
						[7] = {
							CLSID = "{AIM_54C_Mk47}",
						},
						[8] = {
							CLSID = "{F14-300gal}",
						},
						[9] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[10] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
			["90s-2000s AA-2 - AIM-54C-MK47*2, AIM-7MH*3, AIM-9M*2, XT*2"] = {
				attributes =  { },
				code_loadout =  { "Crisis", "PG", "TF", "Caucasus", "WOB" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 5,
				vCruise = 255.83333333333,
				vAttack = 315.83333333333,
				hCruise = 9753.6,
				hAttack = 9753.6,
				standoff = 100300,
				tStation = 7200,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
						[2] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[3] = {
							CLSID = "{F14-300gal}",
						},
						[4] = {
							CLSID = "{AIM_54C_Mk47}",
						},
						[5] = {
							CLSID = "{BELLY AIM-7MH}",
						},
						[7] = {
							CLSID = "{AIM_54C_Mk47}",
						},
						[8] = {
							CLSID = "{F14-300gal}",
						},
						[9] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[10] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
		},
		Escort = {
			["90s-2000s AA-1 - AIM-54C-MK47*4, AIM-7MH*2, AIM-9M*2, XT*2"] = {
				attributes =  { },
				code_loadout =  { "Crisis", "PG", "TF", "Caucasus", "WOB" },
				night = true,
				adverseWeather = true,
				range = 550000,
				firepower = 5,
				vCruise = 255.83333333333,
				standoff = 80300,
				LDSD = true,
				sortie_rate = 8,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
						[2] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[3] = {
							CLSID = "{F14-300gal}",
						},
						[4] = {
							CLSID = "{AIM_54C_Mk47}",
						},
						[5] = {
							CLSID = "{AIM_54C_Mk47}",
						},
						[6] = {
							CLSID = "{AIM_54C_Mk47}",
						},
						[7] = {
							CLSID = "{AIM_54C_Mk47}",
						},
						[8] = {
							CLSID = "{F14-300gal}",
						},
						[9] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[10] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
			["90s-2000s AA-2 - AIM-54C-MK47*2, AIM-7MH*3, AIM-9M*2, XT*2"] = {
				attributes =  { },
				code_loadout =  { "Crisis", "PG", "TF", "Caucasus", "WOB" },
				night = true,
				adverseWeather = true,
				range = 450000,
				firepower = 3,
				vCruise = 255.83333333333,
				standoff = 80300,
				LDSD = true,
				sortie_rate = 8,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
						[2] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[3] = {
							CLSID = "{F14-300gal}",
						},
						[4] = {
							CLSID = "{AIM_54C_Mk47}",
						},
						[5] = {
							CLSID = "{BELLY AIM-7MH}",
						},
						[7] = {
							CLSID = "{AIM_54C_Mk47}",
						},
						[8] = {
							CLSID = "{F14-300gal}",
						},
						[9] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[10] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
		},
		CAP = {
			["90s-2000s AA-1 - AIM-54C-MK47*4, AIM-7MH*2, AIM-9M*2, XT*2"] = {
				attributes =  { "CV CAP" },
				code_loadout =  { "Crisis", "PG", "TF", "Caucasus", "WOB" },
				night = true,
				adverseWeather = true,
				range = 550000,
				firepower = 5,
				vCruise = 213.83333333333,
				vAttack = 213.83333333333,
				hCruise = 9753.6,
				hAttack = 9753.6,
				standoff = 100300,
				tStation = 3600,
				LDSD = true,
				sortie_rate = 12,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
						[2] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[3] = {
							CLSID = "{F14-300gal}",
						},
						[4] = {
							CLSID = "{AIM_54C_Mk47}",
						},
						[5] = {
							CLSID = "{AIM_54C_Mk47}",
						},
						[6] = {
							CLSID = "{AIM_54C_Mk47}",
						},
						[7] = {
							CLSID = "{AIM_54C_Mk47}",
						},
						[8] = {
							CLSID = "{F14-300gal}",
						},
						[9] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[10] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
			["90s-2000s AA-2 - AIM-54C-MK47*2, AIM-7MH*3, AIM-9M*2, XT*2"] = {
				attributes =  { "CV CAP" },
				code_loadout =  { "Crisis", "PG", "TF", "Caucasus", "WOB" },
				night = true,
				adverseWeather = true,
				range = 450000,
				firepower = 3,
				vCruise = 213.83333333333,
				vAttack = 213.83333333333,
				hCruise = 9753.6,
				hAttack = 9753.6,
				standoff = 100300,
				tStation = 3600,
				LDSD = true,
				sortie_rate = 12,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
						[2] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[3] = {
							CLSID = "{F14-300gal}",
						},
						[4] = {
							CLSID = "{AIM_54C_Mk47}",
						},
						[5] = {
							CLSID = "{BELLY AIM-7MH}",
						},
						[7] = {
							CLSID = "{AIM_54C_Mk47}",
						},
						[8] = {
							CLSID = "{F14-300gal}",
						},
						[9] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[10] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
		},
		Intercept = {
			["90s-2000s AA-3 - AIM-54C-MK47*6, AIM-9M*2, XT*2"] = {
				attributes =  { },
				code_loadout =  { "Crisis", "PG", "TF", "Caucasus" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 6,
				LDSD = true,
				sortie_rate = 12,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
						[2] = {
							CLSID = "{SHOULDER AIM_54C_Mk47 L}",
						},
						[3] = {
							CLSID = "{F14-300gal}",
						},
						[4] = {
							CLSID = "{AIM_54C_Mk47}",
						},
						[5] = {
							CLSID = "{AIM_54C_Mk47}",
						},
						[6] = {
							CLSID = "{AIM_54C_Mk47}",
						},
						[7] = {
							CLSID = "{AIM_54C_Mk47}",
						},
						[8] = {
							CLSID = "{F14-300gal}",
						},
						[9] = {
							CLSID = "{SHOULDER AIM_54C_Mk47 R}",
						},
						[10] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
			["90s-2000s AA-1 - AIM-54C-MK47*4, AIM-7MH*2, AIM-9M*2, XT*2"] = {
				attributes =  { },
				code_loadout =  { "Crisis", "PG", "TF", "Caucasus", "WOB" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 5,
				LDSD = true,
				sortie_rate = 12,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
						[2] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[3] = {
							CLSID = "{F14-300gal}",
						},
						[4] = {
							CLSID = "{AIM_54C_Mk47}",
						},
						[5] = {
							CLSID = "{AIM_54C_Mk47}",
						},
						[6] = {
							CLSID = "{AIM_54C_Mk47}",
						},
						[7] = {
							CLSID = "{AIM_54C_Mk47}",
						},
						[8] = {
							CLSID = "{F14-300gal}",
						},
						[9] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[10] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
			["90s-2000s AA-2 - AIM-54C-MK47*2, AIM-7MH*3, AIM-9M*2, XT*2"] = {
				attributes =  { },
				code_loadout =  { "Crisis", "PG", "TF", "Caucasus", "WOB" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 3,
				LDSD = true,
				sortie_rate = 12,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
						[2] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[3] = {
							CLSID = "{F14-300gal}",
						},
						[4] = {
							CLSID = "{AIM_54C_Mk47}",
						},
						[5] = {
							CLSID = "{BELLY AIM-7MH}",
						},
						[7] = {
							CLSID = "{AIM_54C_Mk47}",
						},
						[8] = {
							CLSID = "{F14-300gal}",
						},
						[9] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[10] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
		},
	},
	["F-14BU"] = {
		["Runway Attack"] = {
			["Runway attack AG - Bombs Mk-83Air - Mk-83Air*8 - AIM-9M*2 - AIM-7M*2 - FT*2"] = {
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
				vAttack = 300.5,
				hCruise = 9100,
				hAttack = 100,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{LAU-138 wtip - AIM-9M}",
					["num"] = 10,
					["settings"] = {
						["NFP_PRESID"] = "MDRN_M_A_AIM9",
						["NFP_VIS_DrawArgNo_57"] = 0.1,
					},
				},
				[2] = {
					["CLSID"] = "{LAU-138 wtip - AIM-9M}",
					["num"] = 1,
					["settings"] = {
						["NFP_PRESID"] = "MDRN_M_A_AIM9",
						["NFP_VIS_DrawArgNo_57"] = 0.1,
					},
				},
				[3] = {
					["CLSID"] = "{SHOULDER AIM-7M}",
					["num"] = 9,
				},
				[4] = {
					["CLSID"] = "{SHOULDER AIM-7M}",
					["num"] = 2,
				},
				[5] = {
					["CLSID"] = "{F14-300gal}",
					["num"] = 8,
				},
				[6] = {
					["CLSID"] = "{F14-300gal}",
					["num"] = 3,
				},
				[7] = {
					["CLSID"] = "{MAK79_MK83AIR 3L}",
					["num"] = 4,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_M904E4"] = 4,
						["00_prfx_function_delay_ctrl_M904E4"] = 0,
						["01_prfx_arm_delay_ctrl_M905"] = 4,
						["01_prfx_function_delay_ctrl_M905"] = 0,
						["NFP_PRESID"] = "MDRN_B_A_GPHD",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
					},
				},
				[8] = {
					["CLSID"] = "{MAK79_MK83AIR 3R}",
					["num"] = 7,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_M904E4"] = 4,
						["00_prfx_function_delay_ctrl_M904E4"] = 0,
						["01_prfx_arm_delay_ctrl_M905"] = 4,
						["01_prfx_function_delay_ctrl_M905"] = 0,
						["NFP_PRESID"] = "MDRN_B_A_GPHD",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
					},
				},
				[9] = {
					["CLSID"] = "{MAK79_MK83AIR 1R}",
					["num"] = 6,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_M904E4"] = 4,
						["00_prfx_function_delay_ctrl_M904E4"] = 0,
						["01_prfx_arm_delay_ctrl_M905"] = 4,
						["01_prfx_function_delay_ctrl_M905"] = 0,
						["NFP_PRESID"] = "MDRN_B_A_GPHD",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
					},
				},
				[10] = {
					["CLSID"] = "{MAK79_MK83AIR 1L}",
					["num"] = 5,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_M904E4"] = 4,
						["00_prfx_function_delay_ctrl_M904E4"] = 0,
						["01_prfx_arm_delay_ctrl_M905"] = 4,
						["01_prfx_function_delay_ctrl_M905"] = 0,
						["NFP_PRESID"] = "MDRN_B_A_GPHD",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
					},
				},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
		},	
		Strike = {
			["Strike AG - Bombs Heavy GPS -GBU-31 Penetrator*4 - AIM-9M*2 - AIM-7M*1 - FT*2 - TPod"] = {
				minscore = 0.01,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "Structure", "Bridge" },
				code_loadout =  { "PG", "TF", "Caucasus", "WOB" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				range = 550000,
				firepower = 1,
				vCruise = 245,
				vAttack = 300.5,
				hCruise = 5486.4,
				hAttack = 4572,
				standoff = 20000,
				LDSD = true,
				sortie_rate = 10,
				stores = {
				pylons = {
				[1] = {
					["CLSID"] = "{LAU-138 wtip - AIM-9M}",
					["num"] = 10,
					["settings"] = {
						["NFP_PRESID"] = "MDRN_M_A_AIM9",
						["NFP_VIS_DrawArgNo_57"] = 0.1,
					},
				},
				[2] = {
					["CLSID"] = "{LAU-138 wtip - AIM-9M}",
					["num"] = 1,
					["settings"] = {
						["NFP_PRESID"] = "MDRN_M_A_AIM9",
						["NFP_VIS_DrawArgNo_57"] = 0.1,
					},
				},
				[3] = {
					["CLSID"] = "{F14-LANTIRN-TP}",
					["num"] = 9,
				},
				[4] = {
					["CLSID"] = "{SHOULDER AIM-7M}",
					["num"] = 2,
				},
				[5] = {
					["CLSID"] = "{F14-300gal}",
					["num"] = 8,
				},
				[6] = {
					["CLSID"] = "{F14-300gal}",
					["num"] = 3,
				},
				[7] = {
					["CLSID"] = "{BRU-32 GBU_31_V_4B}",
					["num"] = 7,
					["settings"] = {
						["01_prfx_arm_delay_ctrl_FMU143"] = 5.5,
						["01_prfx_function_delay_ctrl_FMU143"] = 0.03,
						["NFP_PRESID"] = "MDRN_B_A_PGM_HTP_USN",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_57"] = 1,
						["NFP_fuze_type_tail"] = "FMU143",
					},
				},
				[8] = {
					["CLSID"] = "{BRU-32 GBU_31_V_4B}",
					["num"] = 4,
					["settings"] = {
						["01_prfx_arm_delay_ctrl_FMU143"] = 5.5,
						["01_prfx_function_delay_ctrl_FMU143"] = 0.03,
						["NFP_PRESID"] = "MDRN_B_A_PGM_HTP_USN",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_57"] = 1,
						["NFP_fuze_type_tail"] = "FMU143",
					},
				},
				[9] = {
					["CLSID"] = "{BRU-32 GBU_31_V_4B}",
					["num"] = 6,
					["settings"] = {
						["01_prfx_arm_delay_ctrl_FMU143"] = 5.5,
						["01_prfx_function_delay_ctrl_FMU143"] = 0.03,
						["NFP_PRESID"] = "MDRN_B_A_PGM_HTP_USN",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_57"] = 1,
						["NFP_fuze_type_tail"] = "FMU143",
					},
				},
				[10] = {
					["CLSID"] = "{BRU-32 GBU_31_V_4B}",
					["num"] = 5,
					["settings"] = {
						["01_prfx_arm_delay_ctrl_FMU143"] = 5.5,
						["01_prfx_function_delay_ctrl_FMU143"] = 0.03,
						["NFP_PRESID"] = "MDRN_B_A_PGM_HTP_USN",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_57"] = 1,
						["NFP_fuze_type_tail"] = "FMU143",
					},
					},
				},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
			["Strike AG - Bombs Light GPS GBU-38*4 - AIM-9M*2 - AIM-7M*1 - FT*2 - TPod"] = {
				minscore = 0.01,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "PG", "TF", "Caucasus", "WOB" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				range = 550000,
				firepower = 4,
				vCruise = 245,
				vAttack = 300.5,
				hCruise = 5486.4,
				hAttack = 4572,
				standoff = 20000,
				LDSD = true,
				sortie_rate = 10,
				stores = {
				pylons = {
				[1] = {
					["CLSID"] = "{LAU-138 wtip - AIM-9M}",
					["num"] = 10,
					["settings"] = {
						["NFP_PRESID"] = "MDRN_M_A_AIM9",
						["NFP_VIS_DrawArgNo_57"] = 0.1,
					},
				},
				[2] = {
					["CLSID"] = "{LAU-138 wtip - AIM-9M}",
					["num"] = 1,
					["settings"] = {
						["NFP_PRESID"] = "MDRN_M_A_AIM9",
						["NFP_VIS_DrawArgNo_57"] = 0.1,
					},
				},
				[3] = {
					["CLSID"] = "{F14-LANTIRN-TP}",
					["num"] = 9,
				},
				[4] = {
					["CLSID"] = "{SHOULDER AIM-7M}",
					["num"] = 2,
				},
				[5] = {
					["CLSID"] = "{F14-300gal}",
					["num"] = 8,
				},
				[6] = {
					["CLSID"] = "{F14-300gal}",
					["num"] = 3,
				},
				[7] = {
					["CLSID"] = "{BRU-32 GBU-38}",
					["num"] = 7,
					["settings"] = {
						["01_prfx_arm_delay_ctrl_FMU139CB_LD"] = 4,
						["01_prfx_function_delay_ctrl_FMU139CB_LD"] = 0,
						["NFP_PRESID"] = "MDRN_B_A_PGM_TWINWELL",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_56"] = 0.5,
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "EMPTY_NOSE",
						["NFP_fuze_type_tail"] = "FMU139CB_LD",
					},
				},
				[8] = {
					["CLSID"] = "{BRU-32 GBU-38}",
					["num"] = 4,
					["settings"] = {
						["01_prfx_arm_delay_ctrl_FMU139CB_LD"] = 4,
						["01_prfx_function_delay_ctrl_FMU139CB_LD"] = 0,
						["NFP_PRESID"] = "MDRN_B_A_PGM_TWINWELL",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_56"] = 0.5,
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "EMPTY_NOSE",
						["NFP_fuze_type_tail"] = "FMU139CB_LD",
					},
				},
				[9] = {
					["CLSID"] = "{BRU-32 GBU-38}",
					["num"] = 6,
					["settings"] = {
						["01_prfx_arm_delay_ctrl_FMU139CB_LD"] = 4,
						["01_prfx_function_delay_ctrl_FMU139CB_LD"] = 0,
						["NFP_PRESID"] = "MDRN_B_A_PGM_TWINWELL",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_56"] = 0.5,
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "EMPTY_NOSE",
						["NFP_fuze_type_tail"] = "FMU139CB_LD",
					},
				},
				[10] = {
					["CLSID"] = "{BRU-32 GBU-38}",
					["num"] = 5,
					["settings"] = {
						["01_prfx_arm_delay_ctrl_FMU139CB_LD"] = 4,
						["01_prfx_function_delay_ctrl_FMU139CB_LD"] = 0,
						["NFP_PRESID"] = "MDRN_B_A_PGM_TWINWELL",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_56"] = 0.5,
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "EMPTY_NOSE",
						["NFP_fuze_type_tail"] = "FMU139CB_LD",
					},
					},
				},	
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
			["Strike AG - Bombs Heavy GPS Phoenix - AIM-54C*2 - GBU-31 Penetrator*2 - AIM-9M*2 - AIM-7M*1 - FT*2 - TPod"] = {
				minscore = 0.01,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "Structure", "Bridge" },
				code_loadout =  { "PG", "TF", "Caucasus", "WOB" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				range = 550000,
				firepower = 1,
				vCruise = 245,
				vAttack = 300.5,
				hCruise = 5486.4,
				hAttack = 4572,
				standoff = 20000,
				LDSD = true,
				sortie_rate = 10,
				stores = {
				pylons = {
				[1] = {
					["CLSID"] = "{LAU-138 wtip - AIM-9M}",
					["num"] = 10,
					["settings"] = {
						["NFP_PRESID"] = "MDRN_M_A_AIM9",
						["NFP_VIS_DrawArgNo_57"] = 0.1,
					},
				},
				[2] = {
					["CLSID"] = "{LAU-138 wtip - AIM-9M}",
					["num"] = 1,
					["settings"] = {
						["NFP_PRESID"] = "MDRN_M_A_AIM9",
						["NFP_VIS_DrawArgNo_57"] = 0.1,
					},
				},
				[3] = {
					["CLSID"] = "{F14-LANTIRN-TP}",
					["num"] = 9,
				},
				[4] = {
					["CLSID"] = "{SHOULDER AIM-7M}",
					["num"] = 2,
				},
				[5] = {
					["CLSID"] = "{F14-300gal}",
					["num"] = 8,
				},
				[6] = {
					["CLSID"] = "{F14-300gal}",
					["num"] = 3,
				},
				[7] = {
					["CLSID"] = "{AIM_54C_Mk60}",
					["num"] = 7,
				},
				[8] = {
					["CLSID"] = "{AIM_54C_Mk60}",
					["num"] = 4,
				},
				[9] = {
					["CLSID"] = "{BRU-32 GBU_31_V_4B}",
					["num"] = 6,
					["settings"] = {
						["01_prfx_arm_delay_ctrl_FMU143"] = 5.5,
						["01_prfx_function_delay_ctrl_FMU143"] = 0.03,
						["NFP_PRESID"] = "MDRN_B_A_PGM_HTP_USN",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_57"] = 1,
						["NFP_fuze_type_tail"] = "FMU143",
					},
				},
				[10] = {
					["CLSID"] = "{BRU-32 GBU_31_V_4B}",
					["num"] = 5,
					["settings"] = {
						["01_prfx_arm_delay_ctrl_FMU143"] = 5.5,
						["01_prfx_function_delay_ctrl_FMU143"] = 0.03,
						["NFP_PRESID"] = "MDRN_B_A_PGM_HTP_USN",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_57"] = 1,
						["NFP_fuze_type_tail"] = "FMU143",
					},
					},
				},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
			["Strike AG - Bombs Light GPS Phoenix - AIM-54C*2 - GBU-38*2 - AIM-9M*2 - AIM-7M*1 - FT*2 - TPod"] = {
				minscore = 0.01,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "PG", "TF", "Caucasus", "WOB" },
				weaponType = "Guided bombs",
				expend = "Auto",
				night = true,
				range = 550000,
				firepower = 1,
				vCruise = 245,
				vAttack = 300.5,
				hCruise = 5486.4,
				hAttack = 4572,
				standoff = 20000,
				LDSD = true,
				sortie_rate = 10,
				stores = {
				pylons = {
				[1] = {
					["CLSID"] = "{LAU-138 wtip - AIM-9M}",
					["num"] = 10,
					["settings"] = {
						["NFP_PRESID"] = "MDRN_M_A_AIM9",
						["NFP_VIS_DrawArgNo_57"] = 0.1,
					},
				},
				[2] = {
					["CLSID"] = "{LAU-138 wtip - AIM-9M}",
					["num"] = 1,
					["settings"] = {
						["NFP_PRESID"] = "MDRN_M_A_AIM9",
						["NFP_VIS_DrawArgNo_57"] = 0.1,
					},
				},
				[3] = {
					["CLSID"] = "{F14-LANTIRN-TP}",
					["num"] = 9,
				},
				[4] = {
					["CLSID"] = "{SHOULDER AIM-7M}",
					["num"] = 2,
				},
				[5] = {
					["CLSID"] = "{F14-300gal}",
					["num"] = 8,
				},
				[6] = {
					["CLSID"] = "{F14-300gal}",
					["num"] = 3,
				},
				[7] = {
					["CLSID"] = "{AIM_54C_Mk60}",
					["num"] = 7,
				},
				[8] = {
					["CLSID"] = "{AIM_54C_Mk60}",
					["num"] = 4,
				},
				[9] = {
					["CLSID"] = "{BRU-32 GBU-38}",
					["num"] = 6,
					["settings"] = {
						["01_prfx_arm_delay_ctrl_FMU139CB_LD"] = 4,
						["01_prfx_function_delay_ctrl_FMU139CB_LD"] = 0,
						["NFP_PRESID"] = "MDRN_B_A_PGM_TWINWELL",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_56"] = 0.5,
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "EMPTY_NOSE",
						["NFP_fuze_type_tail"] = "FMU139CB_LD",
					},
				},
				[10] = {
					["CLSID"] = "{BRU-32 GBU-38}",
					["num"] = 5,
					["settings"] = {
						["01_prfx_arm_delay_ctrl_FMU139CB_LD"] = 4,
						["01_prfx_function_delay_ctrl_FMU139CB_LD"] = 0,
						["NFP_PRESID"] = "MDRN_B_A_PGM_TWINWELL",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_56"] = 0.5,
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "EMPTY_NOSE",
						["NFP_fuze_type_tail"] = "FMU139CB_LD",
					},
				},
				},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},			
		},
		["Fighter Sweep"] = {
			["AA Fighter Sweep - Classic Phoenix - AIM-54C*4 - AIM-9M*2 - AIM-7M*2 - FT*2"] = {
				attributes =  { },
				code_loadout =  { "PG", "TF", "Caucasus", "WOB" },
				night = true,
				adverseWeather = true,
				range = 550000,
				firepower = 5,
				vCruise = 255.83333333333,
				vAttack = 315.83333333333,
				hCruise = 9753.6,
				hAttack = 9753.6,
				standoff = 100300,
				tStation = 7200,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{LAU-138 wtip - AIM-9M}",
					["num"] = 10,
					["settings"] = {
						["NFP_PRESID"] = "MDRN_M_A_AIM9",
						["NFP_VIS_DrawArgNo_57"] = 0.1,
					},
				},
				[2] = {
					["CLSID"] = "{LAU-138 wtip - AIM-9M}",
					["num"] = 1,
					["settings"] = {
						["NFP_PRESID"] = "MDRN_M_A_AIM9",
						["NFP_VIS_DrawArgNo_57"] = 0.1,
					},
				},
				[3] = {
					["CLSID"] = "{SHOULDER AIM-7M}",
					["num"] = 9,
				},
				[4] = {
					["CLSID"] = "{SHOULDER AIM-7M}",
					["num"] = 2,
				},
				[5] = {
					["CLSID"] = "{F14-300gal}",
					["num"] = 8,
				},
				[6] = {
					["CLSID"] = "{F14-300gal}",
					["num"] = 3,
				},
				[7] = {
					["CLSID"] = "{AIM_54C_Mk60}",
					["num"] = 7,
				},
				[8] = {
					["CLSID"] = "{AIM_54C_Mk60}",
					["num"] = 6,
				},
				[9] = {
					["CLSID"] = "{AIM_54C_Mk60}",
					["num"] = 5,
				},
				[10] = {
					["CLSID"] = "{AIM_54C_Mk60}",
					["num"] = 4,
				},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
			["AA Fighter Sweep - Reduced Phoenix - AIM-54C*2 - AIM-9M*2 - AIM-7M*3 - FT*2"] = {
				attributes =  { },
				code_loadout =  { "PG", "TF", "Caucasus", "WOB" },
				night = true,
				adverseWeather = true,
				range = 550000,
				firepower = 5,
				vCruise = 255.83333333333,
				vAttack = 315.83333333333,
				hCruise = 9753.6,
				hAttack = 9753.6,
				standoff = 100300,
				tStation = 7200,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{LAU-138 wtip - AIM-9M}",
					["num"] = 10,
					["settings"] = {
						["NFP_PRESID"] = "MDRN_M_A_AIM9",
						["NFP_VIS_DrawArgNo_57"] = 0.1,
					},
				},
				[2] = {
					["CLSID"] = "{LAU-138 wtip - AIM-9M}",
					["num"] = 1,
					["settings"] = {
						["NFP_PRESID"] = "MDRN_M_A_AIM9",
						["NFP_VIS_DrawArgNo_57"] = 0.1,
					},
				},
				[3] = {
					["CLSID"] = "{SHOULDER AIM-7M}",
					["num"] = 9,
				},
				[4] = {
					["CLSID"] = "{SHOULDER AIM-7M}",
					["num"] = 2,
				},
				[5] = {
					["CLSID"] = "{F14-300gal}",
					["num"] = 8,
				},
				[6] = {
					["CLSID"] = "{F14-300gal}",
					["num"] = 3,
				},
				[7] = {
					["CLSID"] = "{AIM_54C_Mk60}",
					["num"] = 4,
				},
				[8] = {
					["CLSID"] = "{AIM_54C_Mk60}",
					["num"] = 7,
				},
				[9] = {
					["CLSID"] = "{BELLY AIM-7M}",
					["num"] = 5,
				},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
		},
		Escort = {
			["AA Escort - Classic Phoenix - AIM-54C*4 - AIM-9M*2 - AIM-7M*2 - FT*2"] = {
				attributes =  { },
				code_loadout =  { "PG", "TF", "Caucasus", "WOB" },
				night = true,
				adverseWeather = true,
				range = 550000,
				firepower = 5,
				vCruise = 255.83333333333,
				standoff = 80300,
				LDSD = true,
				sortie_rate = 8,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{LAU-138 wtip - AIM-9M}",
					["num"] = 10,
					["settings"] = {
						["NFP_PRESID"] = "MDRN_M_A_AIM9",
						["NFP_VIS_DrawArgNo_57"] = 0.1,
					},
				},
				[2] = {
					["CLSID"] = "{LAU-138 wtip - AIM-9M}",
					["num"] = 1,
					["settings"] = {
						["NFP_PRESID"] = "MDRN_M_A_AIM9",
						["NFP_VIS_DrawArgNo_57"] = 0.1,
					},
				},
				[3] = {
					["CLSID"] = "{SHOULDER AIM-7M}",
					["num"] = 9,
				},
				[4] = {
					["CLSID"] = "{SHOULDER AIM-7M}",
					["num"] = 2,
				},
				[5] = {
					["CLSID"] = "{F14-300gal}",
					["num"] = 8,
				},
				[6] = {
					["CLSID"] = "{F14-300gal}",
					["num"] = 3,
				},
				[7] = {
					["CLSID"] = "{AIM_54C_Mk60}",
					["num"] = 7,
				},
				[8] = {
					["CLSID"] = "{AIM_54C_Mk60}",
					["num"] = 6,
				},
				[9] = {
					["CLSID"] = "{AIM_54C_Mk60}",
					["num"] = 5,
				},
				[10] = {
					["CLSID"] = "{AIM_54C_Mk60}",
					["num"] = 4,
				},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
			["AA Escort - Reduced Phoenix - AIM-54C*2 - AIM-9M*2 - AIM-7M*3 - FT*2"] = {
				attributes =  { },
				code_loadout =  { "PG", "TF", "Caucasus", "WOB" },
				night = true,
				adverseWeather = true,
				range = 550000,
				firepower = 5,
				vCruise = 255.83333333333,
				standoff = 80300,
				LDSD = true,
				sortie_rate = 8,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{LAU-138 wtip - AIM-9M}",
					["num"] = 10,
					["settings"] = {
						["NFP_PRESID"] = "MDRN_M_A_AIM9",
						["NFP_VIS_DrawArgNo_57"] = 0.1,
					},
				},
				[2] = {
					["CLSID"] = "{LAU-138 wtip - AIM-9M}",
					["num"] = 1,
					["settings"] = {
						["NFP_PRESID"] = "MDRN_M_A_AIM9",
						["NFP_VIS_DrawArgNo_57"] = 0.1,
					},
				},
				[3] = {
					["CLSID"] = "{SHOULDER AIM-7M}",
					["num"] = 9,
				},
				[4] = {
					["CLSID"] = "{SHOULDER AIM-7M}",
					["num"] = 2,
				},
				[5] = {
					["CLSID"] = "{F14-300gal}",
					["num"] = 8,
				},
				[6] = {
					["CLSID"] = "{F14-300gal}",
					["num"] = 3,
				},
				[7] = {
					["CLSID"] = "{AIM_54C_Mk60}",
					["num"] = 4,
				},
				[8] = {
					["CLSID"] = "{AIM_54C_Mk60}",
					["num"] = 7,
				},
				[9] = {
					["CLSID"] = "{BELLY AIM-7M}",
					["num"] = 5,
				},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
		},
		CAP = {
			["AA CAP - Full Phoenix - AIM-54C*6 - AIM-9M*2 - FT*2"] = {
				attributes =  { "CV CAP" },
				code_loadout =  { "PG", "TF", "Caucasus", "WOB" },
				night = true,
				adverseWeather = true,
				range = 550000,
				firepower = 5,
				vCruise = 213.83333333333,
				vAttack = 213.83333333333,
				hCruise = 9753.6,
				hAttack = 9753.6,
				standoff = 100300,
				tStation = 3600,
				LDSD = true,
				sortie_rate = 12,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{LAU-138 wtip - AIM-9M}",
					["num"] = 10,
					["settings"] = {
						["NFP_PRESID"] = "MDRN_M_A_AIM9",
						["NFP_VIS_DrawArgNo_57"] = 0.1,
					},
				},
				[2] = {
					["CLSID"] = "{LAU-138 wtip - AIM-9M}",
					["num"] = 1,
					["settings"] = {
						["NFP_PRESID"] = "MDRN_M_A_AIM9",
						["NFP_VIS_DrawArgNo_57"] = 0.1,
					},
				},
				[3] = {
					["CLSID"] = "{SHOULDER AIM_54C_Mk60 R}",
					["num"] = 9,
				},
				[4] = {
					["CLSID"] = "{SHOULDER AIM_54C_Mk60 L}",
					["num"] = 2,
				},
				[5] = {
					["CLSID"] = "{F14-300gal}",
					["num"] = 8,
				},
				[6] = {
					["CLSID"] = "{F14-300gal}",
					["num"] = 3,
				},
				[7] = {
					["CLSID"] = "{AIM_54C_Mk60}",
					["num"] = 7,
				},
				[8] = {
					["CLSID"] = "{AIM_54C_Mk60}",
					["num"] = 6,
				},
				[9] = {
					["CLSID"] = "{AIM_54C_Mk60}",
					["num"] = 5,
				},
				[10] = {
					["CLSID"] = "{AIM_54C_Mk60}",
					["num"] = 4,
				},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
			["AA CAP - Classic Phoenix - AIM-54C*4 - AIM-9M*2 - AIM-7M*2 - FT*2"] = {
				attributes =  { "CV CAP" },
				code_loadout =  { "PG", "TF", "Caucasus", "WOB" },
				night = true,
				adverseWeather = true,
				range = 550000,
				firepower = 5,
				vCruise = 213.83333333333,
				vAttack = 213.83333333333,
				hCruise = 9753.6,
				hAttack = 9753.6,
				standoff = 100300,
				tStation = 3600,
				LDSD = true,
				sortie_rate = 12,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{LAU-138 wtip - AIM-9M}",
					["num"] = 10,
					["settings"] = {
						["NFP_PRESID"] = "MDRN_M_A_AIM9",
						["NFP_VIS_DrawArgNo_57"] = 0.1,
					},
				},
				[2] = {
					["CLSID"] = "{LAU-138 wtip - AIM-9M}",
					["num"] = 1,
					["settings"] = {
						["NFP_PRESID"] = "MDRN_M_A_AIM9",
						["NFP_VIS_DrawArgNo_57"] = 0.1,
					},
				},
				[3] = {
					["CLSID"] = "{SHOULDER AIM-7M}",
					["num"] = 9,
				},
				[4] = {
					["CLSID"] = "{SHOULDER AIM-7M}",
					["num"] = 2,
				},
				[5] = {
					["CLSID"] = "{F14-300gal}",
					["num"] = 8,
				},
				[6] = {
					["CLSID"] = "{F14-300gal}",
					["num"] = 3,
				},
				[7] = {
					["CLSID"] = "{AIM_54C_Mk60}",
					["num"] = 7,
				},
				[8] = {
					["CLSID"] = "{AIM_54C_Mk60}",
					["num"] = 6,
				},
				[9] = {
					["CLSID"] = "{AIM_54C_Mk60}",
					["num"] = 5,
				},
				[10] = {
					["CLSID"] = "{AIM_54C_Mk60}",
					["num"] = 4,
				},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
			["AA CAP - Reduced Phoenix - AIM-54C*2 - AIM-9M*2 - AIM-7M*3 - FT*2"] = {
				attributes =  { "CV CAP" },
				code_loadout =  { "PG", "TF", "Caucasus", "WOB" },
				night = true,
				adverseWeather = true,
				range = 550000,
				firepower = 5,
				vCruise = 213.83333333333,
				vAttack = 213.83333333333,
				hCruise = 9753.6,
				hAttack = 9753.6,
				standoff = 100300,
				tStation = 3600,
				LDSD = true,
				sortie_rate = 12,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{LAU-138 wtip - AIM-9M}",
					["num"] = 10,
					["settings"] = {
						["NFP_PRESID"] = "MDRN_M_A_AIM9",
						["NFP_VIS_DrawArgNo_57"] = 0.1,
					},
				},
				[2] = {
					["CLSID"] = "{LAU-138 wtip - AIM-9M}",
					["num"] = 1,
					["settings"] = {
						["NFP_PRESID"] = "MDRN_M_A_AIM9",
						["NFP_VIS_DrawArgNo_57"] = 0.1,
					},
				},
				[3] = {
					["CLSID"] = "{SHOULDER AIM-7M}",
					["num"] = 9,
				},
				[4] = {
					["CLSID"] = "{SHOULDER AIM-7M}",
					["num"] = 2,
				},
				[5] = {
					["CLSID"] = "{F14-300gal}",
					["num"] = 8,
				},
				[6] = {
					["CLSID"] = "{F14-300gal}",
					["num"] = 3,
				},
				[7] = {
					["CLSID"] = "{AIM_54C_Mk60}",
					["num"] = 4,
				},
				[8] = {
					["CLSID"] = "{AIM_54C_Mk60}",
					["num"] = 7,
				},
				[9] = {
					["CLSID"] = "{BELLY AIM-7M}",
					["num"] = 5,
				},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
		},
		Intercept = {
			["AA Intercept - Full Phoenix - AIM-54C*6 - AIM-9M*2 - FT*2"] = {
				attributes =  { },
				code_loadout =  { "PG", "TF", "Caucasus", "WOB" },
				night = true,
				adverseWeather = true,
				range = 550000,
				firepower = 6,
				LDSD = true,
				sortie_rate = 12,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{LAU-138 wtip - AIM-9M}",
					["num"] = 10,
					["settings"] = {
						["NFP_PRESID"] = "MDRN_M_A_AIM9",
						["NFP_VIS_DrawArgNo_57"] = 0.1,
					},
				},
				[2] = {
					["CLSID"] = "{LAU-138 wtip - AIM-9M}",
					["num"] = 1,
					["settings"] = {
						["NFP_PRESID"] = "MDRN_M_A_AIM9",
						["NFP_VIS_DrawArgNo_57"] = 0.1,
					},
				},
				[3] = {
					["CLSID"] = "{SHOULDER AIM_54C_Mk60 R}",
					["num"] = 9,
				},
				[4] = {
					["CLSID"] = "{SHOULDER AIM_54C_Mk60 L}",
					["num"] = 2,
				},
				[5] = {
					["CLSID"] = "{F14-300gal}",
					["num"] = 8,
				},
				[6] = {
					["CLSID"] = "{F14-300gal}",
					["num"] = 3,
				},
				[7] = {
					["CLSID"] = "{AIM_54C_Mk60}",
					["num"] = 7,
				},
				[8] = {
					["CLSID"] = "{AIM_54C_Mk60}",
					["num"] = 6,
				},
				[9] = {
					["CLSID"] = "{AIM_54C_Mk60}",
					["num"] = 5,
				},
				[10] = {
					["CLSID"] = "{AIM_54C_Mk60}",
					["num"] = 4,
				},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
			["AA Intercept - Classic Phoenix - AIM-54C*4 - AIM-9M*2 - AIM-7M*2 - FT*2"] = {
				attributes =  { },
				code_loadout =  { "PG", "TF", "Caucasus", "WOB" },
				night = true,
				adverseWeather = true,
				range = 550000,
				firepower = 6,
				LDSD = true,
				sortie_rate = 12,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{LAU-138 wtip - AIM-9M}",
					["num"] = 10,
					["settings"] = {
						["NFP_PRESID"] = "MDRN_M_A_AIM9",
						["NFP_VIS_DrawArgNo_57"] = 0.1,
					},
				},
				[2] = {
					["CLSID"] = "{LAU-138 wtip - AIM-9M}",
					["num"] = 1,
					["settings"] = {
						["NFP_PRESID"] = "MDRN_M_A_AIM9",
						["NFP_VIS_DrawArgNo_57"] = 0.1,
					},
				},
				[3] = {
					["CLSID"] = "{SHOULDER AIM-7M}",
					["num"] = 9,
				},
				[4] = {
					["CLSID"] = "{SHOULDER AIM-7M}",
					["num"] = 2,
				},
				[5] = {
					["CLSID"] = "{F14-300gal}",
					["num"] = 8,
				},
				[6] = {
					["CLSID"] = "{F14-300gal}",
					["num"] = 3,
				},
				[7] = {
					["CLSID"] = "{AIM_54C_Mk60}",
					["num"] = 7,
				},
				[8] = {
					["CLSID"] = "{AIM_54C_Mk60}",
					["num"] = 6,
				},
				[9] = {
					["CLSID"] = "{AIM_54C_Mk60}",
					["num"] = 5,
				},
				[10] = {
					["CLSID"] = "{AIM_54C_Mk60}",
					["num"] = 4,
				},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
		},
	},	
	["F-14A-95-GR"] = {
		CAP = {
			["CAP - IRIAF - AIM-9J*2 - AIM-7-E*3 - AIM-54- mk-47*2"] = {
				attributes =  { "IRIAF" },
				code_loadout =  { "Crisis", "PG", "IIW" },
				night = true,
				adverseWeather = true,
				range = 451000,
				firepower = 3.5,
				vCruise = 213.83333333333,
				vAttack = 213.83333333333,
				hCruise = 9753.6,
				hAttack = 9753.6,
				standoff = 100300,
				tStation = 3600,
				LDSD = true,
				sortie_rate = 5,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{LAU-7 wtip - AIM-9J}",
					["num"] = 1,
				},
				[2] = {
					["CLSID"] = "{SHOULDER AIM-7E}",
					["num"] = 2,
				},
				[3] = {
					["CLSID"] = "{SHOULDER AIM-7E}",
					["num"] = 9,
				},
				[4] = {
					["CLSID"] = "{LAU-7 wtip - AIM-9J}",
					["num"] = 10,
				},
				[5] = {
					["CLSID"] = "{AIM_54A_Mk47}",
					["num"] = 7,
				},
				[6] = {
					["CLSID"] = "{AIM_54A_Mk47}",
					["num"] = 4,
				},
				[7] = {
					["CLSID"] = "{BELLY AIM-7E}",
					["num"] = 5,
				},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
			["CAP - IRIAF - AIM-9J*2 - AIM-7-E*6"] = {
				attributes =  { "IRIAF" },
				code_loadout =  { "Crisis", "PG", "IIW" },
				night = true,
				adverseWeather = true,
				range = 451000,
				firepower = 3,
				vCruise = 213.83333333333,
				vAttack = 213.83333333333,
				hCruise = 9753.6,
				hAttack = 9753.6,
				standoff = 20000,
				tStation = 3600,
				LDSD = true,
				sortie_rate = 5,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{LAU-7 wtip - AIM-9J}",
					["num"] = 1,
				},
				[2] = {
					["CLSID"] = "{SHOULDER AIM-7E}",
					["num"] = 2,
				},
				[3] = {
					["CLSID"] = "{BELLY AIM-7E}",
					["num"] = 4,
				},
				[4] = {
					["CLSID"] = "{BELLY AIM-7E}",
					["num"] = 5,
				},
				[5] = {
					["CLSID"] = "{BELLY AIM-7E}",
					["num"] = 6,
				},
				[6] = {
					["CLSID"] = "{BELLY AIM-7E}",
					["num"] = 7,
				},
				[7] = {
					["CLSID"] = "{SHOULDER AIM-7E}",
					["num"] = 9,
				},
				[8] = {
					["CLSID"] = "{LAU-7 wtip - AIM-9J}",
					["num"] = 10,
				},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
			["CAP - IRIAF - AIM-9J*4 - AIM-7-E*4"] = {
				attributes =  { "IRIAF" },
				code_loadout =  { "Crisis", "PG", "IIW" },
				night = true,
				adverseWeather = true,
				range = 451000,
				firepower = 3,
				vCruise = 213.83333333333,
				vAttack = 213.83333333333,
				hCruise = 9753.6,
				hAttack = 9753.6,
				standoff = 20000,
				tStation = 3600,
				LDSD = true,
				sortie_rate = 5,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{LAU-7 wtip - AIM-9J}",
					["num"] = 1,
				},
				[2] = {
					["CLSID"] = "{LAU-7 - AIM-9J}",
					["num"] = 2,
				},
				[3] = {
					["CLSID"] = "{BELLY AIM-7E}",
					["num"] = 4,
				},
				[4] = {
					["CLSID"] = "{BELLY AIM-7E}",
					["num"] = 5,
				},
				[5] = {
					["CLSID"] = "{BELLY AIM-7E}",
					["num"] = 6,
				},
				[6] = {
					["CLSID"] = "{BELLY AIM-7E}",
					["num"] = 7,
				},
				[7] = {
					["CLSID"] = "{LAU-7 - AIM-9J}",
					["num"] = 9,
				},
				[8] = {
					["CLSID"] = "{LAU-7 wtip - AIM-9J}",
					["num"] = 10,
				},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
		},
		["Fighter Sweep"] = {
			["Fighter Sweep - IRIAF - AIM-9J*2 - AIM-7-E*2 - AIM-54- mk-47*2"] = {
				attributes =  { "IRIAF" },
				code_loadout =  { "Crisis", "PG", "IIW" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 3.5,
				vCruise = 213.83333333333,
				vAttack = 213.83333333333,
				hCruise = 9753.6,
				hAttack = 9753.6,
				standoff = 100300,
				tStation = 3600,
				LDSD = true,
				sortie_rate = 5,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{LAU-7 wtip - AIM-9J}",
					["num"] = 1,
				},
				[2] = {
					["CLSID"] = "{SHOULDER AIM-7E}",
					["num"] = 2,
				},
				[3] = {
					["CLSID"] = "{SHOULDER AIM-7E}",
					["num"] = 9,
				},
				[4] = {
					["CLSID"] = "{LAU-7 wtip - AIM-9J}",
					["num"] = 10,
				},
				[5] = {
					["CLSID"] = "{AIM_54A_Mk47}",
					["num"] = 7,
				},
				[6] = {
					["CLSID"] = "{AIM_54A_Mk47}",
					["num"] = 4,
				},
				[7] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 6,
				},
				[8] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 5,
				},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
			["Fighter Sweep - IRIAF - AIM-9J*2 - AIM-7-E*6"] = {
				attributes =  { "IRIAF" },
				code_loadout =  { "Crisis", "PG", "IIW" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 3,
				vCruise = 213.83333333333,
				vAttack = 213.83333333333,
				hCruise = 9753.6,
				hAttack = 9753.6,
				standoff = 20300,
				tStation = 3600,
				LDSD = true,
				sortie_rate = 5,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{LAU-7 wtip - AIM-9J}",
					["num"] = 1,
				},
				[2] = {
					["CLSID"] = "{SHOULDER AIM-7E}",
					["num"] = 2,
				},
				[3] = {
					["CLSID"] = "{BELLY AIM-7E}",
					["num"] = 4,
				},
				[4] = {
					["CLSID"] = "{BELLY AIM-7E}",
					["num"] = 5,
				},
				[5] = {
					["CLSID"] = "{BELLY AIM-7E}",
					["num"] = 6,
				},
				[6] = {
					["CLSID"] = "{BELLY AIM-7E}",
					["num"] = 7,
				},
				[7] = {
					["CLSID"] = "{SHOULDER AIM-7E}",
					["num"] = 9,
				},
				[8] = {
					["CLSID"] = "{LAU-7 wtip - AIM-9J}",
					["num"] = 10,
				},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
			["Fighter Sweep - IRIAF - AIM-9J*4 - AIM-7-E*4"] = {
				attributes =  { "IRIAF" },
				code_loadout =  { "Crisis", "PG", "IIW" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 3,
				vCruise = 213.83333333333,
				vAttack = 213.83333333333,
				hCruise = 9753.6,
				hAttack = 9753.6,
				standoff = 20300,
				tStation = 3600,
				LDSD = true,
				sortie_rate = 5,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{LAU-7 wtip - AIM-9J}",
					["num"] = 1,
				},
				[2] = {
					["CLSID"] = "{LAU-7 - AIM-9J}",
					["num"] = 2,
				},
				[3] = {
					["CLSID"] = "{BELLY AIM-7E}",
					["num"] = 4,
				},
				[4] = {
					["CLSID"] = "{BELLY AIM-7E}",
					["num"] = 5,
				},
				[5] = {
					["CLSID"] = "{BELLY AIM-7E}",
					["num"] = 6,
				},
				[6] = {
					["CLSID"] = "{BELLY AIM-7E}",
					["num"] = 7,
				},
				[7] = {
					["CLSID"] = "{LAU-7 - AIM-9J}",
					["num"] = 9,
				},
				[8] = {
					["CLSID"] = "{LAU-7 wtip - AIM-9J}",
					["num"] = 10,
				},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
		},
		Escort = {
			["Escort - IRIAF - AIM-9J*2 - AIM-7-E*2 - AIM-54- mk-47*2"] = {
				attributes =  { },
				code_loadout =  { "Crisis", "PG", "IIW" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 3.5,
				vCruise = 255.83333333333,
				standoff = 80300,
				LDSD = true,
				sortie_rate = 5,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{LAU-7 wtip - AIM-9J}",
					["num"] = 1,
				},
				[2] = {
					["CLSID"] = "{SHOULDER AIM-7E}",
					["num"] = 2,
				},
				[3] = {
					["CLSID"] = "{SHOULDER AIM-7E}",
					["num"] = 9,
				},
				[4] = {
					["CLSID"] = "{LAU-7 wtip - AIM-9J}",
					["num"] = 10,
				},
				[5] = {
					["CLSID"] = "{AIM_54A_Mk47}",
					["num"] = 7,
				},
				[6] = {
					["CLSID"] = "{AIM_54A_Mk47}",
					["num"] = 4,
				},
				[7] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 6,
				},
				[8] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 5,
				},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
			["Escort - IRIAF - AIM-9J*2 - AIM-7-E*6"] = {
				attributes =  { },
				code_loadout =  { "Crisis", "PG", "IIW" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 3,
				vCruise = 255.83333333333,
				standoff = 80300,
				LDSD = true,
				sortie_rate = 5,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{LAU-7 wtip - AIM-9J}",
					["num"] = 1,
				},
				[2] = {
					["CLSID"] = "{SHOULDER AIM-7E}",
					["num"] = 2,
				},
				[3] = {
					["CLSID"] = "{BELLY AIM-7E}",
					["num"] = 4,
				},
				[4] = {
					["CLSID"] = "{BELLY AIM-7E}",
					["num"] = 5,
				},
				[5] = {
					["CLSID"] = "{BELLY AIM-7E}",
					["num"] = 6,
				},
				[6] = {
					["CLSID"] = "{BELLY AIM-7E}",
					["num"] = 7,
				},
				[7] = {
					["CLSID"] = "{SHOULDER AIM-7E}",
					["num"] = 9,
				},
				[8] = {
					["CLSID"] = "{LAU-7 wtip - AIM-9J}",
					["num"] = 10,
				},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},	
			["Escort - IRIAF - AIM-9J*4 - AIM-7-E*4"] = {
				attributes =  { },
				code_loadout =  { "Crisis", "PG", "IIW" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 3,
				vCruise = 255.83333333333,
				standoff = 80300,
				LDSD = true,
				sortie_rate = 5,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{LAU-7 wtip - AIM-9J}",
					["num"] = 1,
				},
				[2] = {
					["CLSID"] = "{LAU-7 - AIM-9J}",
					["num"] = 2,
				},
				[3] = {
					["CLSID"] = "{BELLY AIM-7E}",
					["num"] = 4,
				},
				[4] = {
					["CLSID"] = "{BELLY AIM-7E}",
					["num"] = 5,
				},
				[5] = {
					["CLSID"] = "{BELLY AIM-7E}",
					["num"] = 6,
				},
				[6] = {
					["CLSID"] = "{BELLY AIM-7E}",
					["num"] = 7,
				},
				[7] = {
					["CLSID"] = "{LAU-7 - AIM-9J}",
					["num"] = 9,
				},
				[8] = {
					["CLSID"] = "{LAU-7 wtip - AIM-9J}",
					["num"] = 10,
				},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
		},
		Intercept = {
			["Intercept - IRIAF - AIM-9J*2 - AIM-7-E*2 - AIM-54- mk-47*2"] = {
				attributes =  { "IRIAF" },
				code_loadout =  { "Crisis", "PG", "IIW" },
				night = true,
				adverseWeather = true,
				range = 450000,
				firepower = 3.5,
				sortie_rate = 5,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{LAU-7 wtip - AIM-9J}",
					["num"] = 1,
				},
				[2] = {
					["CLSID"] = "{SHOULDER AIM-7E}",
					["num"] = 2,
				},
				[3] = {
					["CLSID"] = "{SHOULDER AIM-7E}",
					["num"] = 9,
				},
				[4] = {
					["CLSID"] = "{LAU-7 wtip - AIM-9J}",
					["num"] = 10,
				},
				[5] = {
					["CLSID"] = "{AIM_54A_Mk47}",
					["num"] = 7,
				},
				[6] = {
					["CLSID"] = "{AIM_54A_Mk47}",
					["num"] = 4,
				},
				[7] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 6,
				},
				[8] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 5,
				},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
			["Intercept - IRIAF - AIM-9J*2 - AIM-7-E*6"] = {
				attributes =  { "IRIAF" },
				code_loadout =  { "Crisis", "PG", "IIW" },
				night = true,
				adverseWeather = true,
				range = 450000,
				firepower = 3,
				sortie_rate = 5,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{LAU-7 wtip - AIM-9J}",
					["num"] = 1,
				},
				[2] = {
					["CLSID"] = "{SHOULDER AIM-7E}",
					["num"] = 2,
				},
				[3] = {
					["CLSID"] = "{BELLY AIM-7E}",
					["num"] = 4,
				},
				[4] = {
					["CLSID"] = "{BELLY AIM-7E}",
					["num"] = 5,
				},
				[5] = {
					["CLSID"] = "{BELLY AIM-7E}",
					["num"] = 6,
				},
				[6] = {
					["CLSID"] = "{BELLY AIM-7E}",
					["num"] = 7,
				},
				[7] = {
					["CLSID"] = "{SHOULDER AIM-7E}",
					["num"] = 9,
				},
				[8] = {
					["CLSID"] = "{LAU-7 wtip - AIM-9J}",
					["num"] = 10,
				},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
		},
	},
}