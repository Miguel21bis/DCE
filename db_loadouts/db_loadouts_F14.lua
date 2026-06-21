--Loadouts database
--F14 loadouts
-------------------------------------------------------------------------------------------------------

if not versionDCE then versionDCE = {} end
versionDCE["db_loadouts/db_loadouts_F14.lua"] = "1.1.1"

-- 1.1.1 - Beginning of the versions of this loadouts file dedicated to the F4.


db_loadouts = {
	["F-14A-135-GR"] = {
		CAP = {
			["CAP - IIW - AA - AIM-7F*6 - AIM9L*2"] = {
				attributes =  { "IRIAF" },
				code_loadout =  { "IIW" },
				night = true,
				adverseWeather = true,
				range = 500000,
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
							["CLSID"] = "{LAU-138 wtip - AIM-9L}",
							["num"] = 10,
						},
						[2] = {
							["CLSID"] = "{LAU-138 wtip - AIM-9L}",
							["num"] = 1,
						},
						[3] = {
							["CLSID"] = "{SHOULDER AIM-7F}",
							["num"] = 9,
						},
						[4] = {
							["CLSID"] = "{SHOULDER AIM-7F}",
							["num"] = 2,
						},
						[5] = {
							["CLSID"] = "{BELLY AIM-7F}",
							["num"] = 7,
						},
						[6] = {
							["CLSID"] = "{BELLY AIM-7F}",
							["num"] = 6,
						},
						[7] = {
							["CLSID"] = "{BELLY AIM-7F}",
							["num"] = 5,
						},
						[8] = {
							["CLSID"] = "{BELLY AIM-7F}",
							["num"] = 4,
						},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
			["90s-2000s AA Iran AIM-54A-MK47*2, AIM-7MH*3, AIM-9M*2"] = {
				attributes =  { "IRIAF" },
				code_loadout =  { "Crisis", "PG" },
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
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
						[2] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[4] = {
							CLSID = "{AIM_54A_Mk47}",
						},
						[5] = {
							CLSID = "{BELLY AIM-7MH}",
						},
						[10] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
						[7] = {
							CLSID = "{AIM_54A_Mk47}",
						},
						[9] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
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
			["90s-2000s AA Iran AIM-7MH*6, AIM-9M*2"] = {
				attributes =  { "IRIAF" },
				code_loadout =  { "Crisis", "PG" },
				night = true,
				adverseWeather = true,
				range = 450000,
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
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
						[2] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[4] = {
							CLSID = "{BELLY AIM-7MH}",
						},
						[5] = {
							CLSID = "{BELLY AIM-7MH}",
						},
						[6] = {
							CLSID = "{BELLY AIM-7MH}",
						},
						[7] = {
							CLSID = "{BELLY AIM-7MH}",
						},
						[10] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
						[9] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
			["CAP - IIW - AA - AIM-54A-MK47*2 - AIM-7F*3 - AIM9L*2"] = {
				attributes =  { "IRIAF" },
				code_loadout =  { "IIW" },
				night = true,
				adverseWeather = true,
				range = 600000,
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
							["CLSID"] = "{SHOULDER AIM-7F}",
							["num"] = 9,
						},
						[4] = {
							["CLSID"] = "{SHOULDER AIM-7F}",
							["num"] = 2,
						},
						[5] = {
							["CLSID"] = "{BELLY AIM-7F}",
							["num"] = 5,
						},
						[6] = {
							["CLSID"] = "{AIM_54A_Mk47}",
							["num"] = 7,
						},
						[7] = {
							["CLSID"] = "{AIM_54A_Mk47}",
							["num"] = 4,
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
			["FS - IIW - AA - AIM-7F*6 - AIM9L*2"] = {
				attributes =  { "IRIAF" },
				code_loadout =  { "IIW" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 3,
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
							["CLSID"] = "{SHOULDER AIM-7F}",
							["num"] = 9,
						},
						[4] = {
							["CLSID"] = "{SHOULDER AIM-7F}",
							["num"] = 2,
						},
						[5] = {
							["CLSID"] = "{BELLY AIM-7F}",
							["num"] = 7,
						},
						[6] = {
							["CLSID"] = "{BELLY AIM-7F}",
							["num"] = 6,
						},
						[7] = {
							["CLSID"] = "{BELLY AIM-7F}",
							["num"] = 5,
						},
						[8] = {
							["CLSID"] = "{BELLY AIM-7F}",
							["num"] = 4,
						},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
			["90s-2000s AA Iran AIM-54A-MK47*2, AIM-7MH*3, AIM-9M*2"] = {
				attributes =  { "IRIAF" },
				code_loadout =  { "Crisis", "PG" },
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
						[4] = {
							CLSID = "{AIM_54A_Mk47}",
						},
						[5] = {
							CLSID = "{BELLY AIM-7MH}",
						},
						[10] = {
							CLSID = "{LAU-138 wtip - AIM-9L}",
						},
						[7] = {
							CLSID = "{AIM_54A_Mk47}",
						},
						[9] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
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
			["90s-2000s AA Iran AIM-7MH*6, AIM-9M*2"] = {
				attributes =  { "IRIAF" },
				code_loadout =  { "Crisis", "PG" },
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
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
						[2] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[4] = {
							CLSID = "{BELLY AIM-7MH}",
						},
						[5] = {
							CLSID = "{BELLY AIM-7MH}",
						},
						[6] = {
							CLSID = "{BELLY AIM-7MH}",
						},
						[7] = {
							CLSID = "{BELLY AIM-7MH}",
						},
						[10] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
						[9] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
			["FS - IIW - AA - AIM-54A-MK47*2 - AIM-7F*3 - AIM9L*2"] = {
				attributes =  { "IRIAF" },
				code_loadout =  { "IIW" },
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
							["CLSID"] = "{SHOULDER AIM-7F}",
							["num"] = 9,
						},
						[4] = {
							["CLSID"] = "{SHOULDER AIM-7F}",
							["num"] = 2,
						},
						[5] = {
							["CLSID"] = "{BELLY AIM-7F}",
							["num"] = 5,
						},
						[6] = {
							["CLSID"] = "{AIM_54A_Mk47}",
							["num"] = 7,
						},
						[7] = {
							["CLSID"] = "{AIM_54A_Mk47}",
							["num"] = 4,
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
			["Escort - IIW - AA - AIM-7F*6 - AIM9L*2"] = {
				attributes =  { },
				code_loadout =  { "IIW" },
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
							["CLSID"] = "{LAU-138 wtip - AIM-9L}",
							["num"] = 10,
						},
						[2] = {
							["CLSID"] = "{LAU-138 wtip - AIM-9L}",
							["num"] = 1,
						},
						[3] = {
							["CLSID"] = "{SHOULDER AIM-7F}",
							["num"] = 9,
						},
						[4] = {
							["CLSID"] = "{SHOULDER AIM-7F}",
							["num"] = 2,
						},
						[5] = {
							["CLSID"] = "{BELLY AIM-7F}",
							["num"] = 7,
						},
						[6] = {
							["CLSID"] = "{BELLY AIM-7F}",
							["num"] = 6,
						},
						[7] = {
							["CLSID"] = "{BELLY AIM-7F}",
							["num"] = 5,
						},
						[8] = {
							["CLSID"] = "{BELLY AIM-7F}",
							["num"] = 4,
						},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
			["90s-2000s AA Iran AIM-54A-MK47*2, AIM-7MH*3, AIM-9M*2"] = {
				attributes =  { },
				code_loadout =  { "Crisis", "PG" },
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
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
						[2] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[4] = {
							CLSID = "{AIM_54A_Mk47}",
						},
						[5] = {
							CLSID = "{BELLY AIM-7MH}",
						},
						[10] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
						[7] = {
							CLSID = "{AIM_54A_Mk47}",
						},
						[9] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
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
			["90s-2000s AA Iran AIM-7MH*6, AIM-9M*2"] = {
				attributes =  { },
				code_loadout =  { "Crisis", "PG" },
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
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
						[2] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[4] = {
							CLSID = "{BELLY AIM-7MH}",
						},
						[5] = {
							CLSID = "{BELLY AIM-7MH}",
						},
						[6] = {
							CLSID = "{BELLY AIM-7MH}",
						},
						[7] = {
							CLSID = "{BELLY AIM-7MH}",
						},
						[10] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
						[9] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
			["Escort - IIW - AA - AIM-54A-MK47*2 - AIM-7F*3 - AIM9L*2"] = {
				attributes =  { },
				code_loadout =  { "IIW" },
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
							["CLSID"] = "{SHOULDER AIM-7F}",
							["num"] = 9,
						},
						[4] = {
							["CLSID"] = "{SHOULDER AIM-7F}",
							["num"] = 2,
						},
						[5] = {
							["CLSID"] = "{BELLY AIM-7F}",
							["num"] = 5,
						},
						[6] = {
							["CLSID"] = "{AIM_54A_Mk47}",
							["num"] = 7,
						},
						[7] = {
							["CLSID"] = "{AIM_54A_Mk47}",
							["num"] = 4,
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
			["Intercept - IIW - AA - AIM-7F*6 - AIM9L*2"] = {
				attributes =  { },
				code_loadout =  { "IIW" },
				night = true,
				adverseWeather = true,
				range = 450000,
				firepower = 3,
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
							["CLSID"] = "{SHOULDER AIM-7F}",
							["num"] = 9,
						},
						[4] = {
							["CLSID"] = "{SHOULDER AIM-7F}",
							["num"] = 2,
						},
						[5] = {
							["CLSID"] = "{BELLY AIM-7F}",
							["num"] = 7,
						},
						[6] = {
							["CLSID"] = "{BELLY AIM-7F}",
							["num"] = 6,
						},
						[7] = {
							["CLSID"] = "{BELLY AIM-7F}",
							["num"] = 5,
						},
						[8] = {
							["CLSID"] = "{BELLY AIM-7F}",
							["num"] = 4,
						},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
			["90s-2000s AA Iran AIM-54A-MK47*2, AIM-7MH*3, AIM-9M*2"] = {
				attributes =  { "IRIAF" },
				code_loadout =  { "Crisis", "PG" },
				night = true,
				adverseWeather = true,
				range = 450000,
				firepower = 3.5,
				sortie_rate = 5,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
						[2] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[4] = {
							CLSID = "{AIM_54A_Mk47}",
						},
						[5] = {
							CLSID = "{BELLY AIM-7MH}",
						},
						[10] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
						[7] = {
							CLSID = "{AIM_54A_Mk47}",
						},
						[9] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
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
			["90s-2000s AA Iran AIM-7MH*6, AIM-9M*2"] = {
				attributes =  { "IRIAF" },
				code_loadout =  { "Crisis", "PG" },
				night = true,
				adverseWeather = true,
				range = 450000,
				firepower = 3,
				sortie_rate = 5,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
						[2] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[4] = {
							CLSID = "{BELLY AIM-7MH}",
						},
						[5] = {
							CLSID = "{BELLY AIM-7MH}",
						},
						[6] = {
							CLSID = "{BELLY AIM-7MH}",
						},
						[7] = {
							CLSID = "{BELLY AIM-7MH}",
						},
						[10] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
						[9] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
			["Intercept - IIW - AA - AIM-54A-MK47*2 - AIM-7F*3 - AIM9L*2"] = {
				attributes =  { },
				code_loadout =  { "IIW" },
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
							["CLSID"] = "{SHOULDER AIM-7F}",
							["num"] = 9,
						},
						[4] = {
							["CLSID"] = "{SHOULDER AIM-7F}",
							["num"] = 2,
						},
						[5] = {
							["CLSID"] = "{BELLY AIM-7F}",
							["num"] = 5,
						},
						[6] = {
							["CLSID"] = "{AIM_54A_Mk47}",
							["num"] = 7,
						},
						[7] = {
							["CLSID"] = "{AIM_54A_Mk47}",
							["num"] = 4,
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
	["F-14A-95-GR"] = {
		CAP = {
			["90s-2000s AA Iran AIM-54A-MK47*2, AIM-7MH*3, AIM-9M*2"] = {
				attributes =  { "IRIAF" },
				code_loadout =  { "Crisis", "PG", "IIW" },
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
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
						[2] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[4] = {
							CLSID = "{AIM_54A_Mk47}",
						},
						[5] = {
							CLSID = "{BELLY AIM-7MH}",
						},
						[10] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
						[7] = {
							CLSID = "{AIM_54A_Mk47}",
						},
						[9] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
			["90s-2000s AA Iran AIM-7MH*6, AIM-9M*2"] = {
				attributes =  { "IRIAF" },
				code_loadout =  { "Crisis", "PG", "IIW" },
				night = true,
				adverseWeather = true,
				range = 450000,
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
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
						[2] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[4] = {
							CLSID = "{BELLY AIM-7MH}",
						},
						[5] = {
							CLSID = "{BELLY AIM-7MH}",
						},
						[6] = {
							CLSID = "{BELLY AIM-7MH}",
						},
						[7] = {
							CLSID = "{BELLY AIM-7MH}",
						},
						[10] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
						[9] = {
							CLSID = "{SHOULDER AIM-7MH}",
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
			["90s-2000s AA Iran AIM-54A-MK47*2, AIM-7MH*3, AIM-9M*2"] = {
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
							CLSID = "{LAU-138 wtip - AIM-9L}",
						},
						[2] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[4] = {
							CLSID = "{AIM_54A_Mk47}",
						},
						[5] = {
							CLSID = "{BELLY AIM-7MH}",
						},
						[10] = {
							CLSID = "{LAU-138 wtip - AIM-9L}",
						},
						[7] = {
							CLSID = "{AIM_54A_Mk47}",
						},
						[9] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
			["90s-2000s AA Iran AIM-7MH*6, AIM-9M*2"] = {
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
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
						[2] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[4] = {
							CLSID = "{BELLY AIM-7MH}",
						},
						[5] = {
							CLSID = "{BELLY AIM-7MH}",
						},
						[6] = {
							CLSID = "{BELLY AIM-7MH}",
						},
						[7] = {
							CLSID = "{BELLY AIM-7MH}",
						},
						[10] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
						[9] = {
							CLSID = "{SHOULDER AIM-7MH}",
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
			["90s-2000s AA Iran AIM-54A-MK47*2, AIM-7MH*3, AIM-9M*2"] = {
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
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
						[2] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[4] = {
							CLSID = "{AIM_54A_Mk47}",
						},
						[5] = {
							CLSID = "{BELLY AIM-7MH}",
						},
						[10] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
						[7] = {
							CLSID = "{AIM_54A_Mk47}",
						},
						[9] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
			["90s-2000s AA Iran AIM-7MH*6, AIM-9M*2"] = {
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
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
						[2] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[4] = {
							CLSID = "{BELLY AIM-7MH}",
						},
						[5] = {
							CLSID = "{BELLY AIM-7MH}",
						},
						[6] = {
							CLSID = "{BELLY AIM-7MH}",
						},
						[7] = {
							CLSID = "{BELLY AIM-7MH}",
						},
						[10] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
						[9] = {
							CLSID = "{SHOULDER AIM-7MH}",
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
			["90s-2000s AA Iran AIM-54A-MK47*2, AIM-7MH*3, AIM-9M*2"] = {
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
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
						[2] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[4] = {
							CLSID = "{AIM_54A_Mk47}",
						},
						[5] = {
							CLSID = "{BELLY AIM-7MH}",
						},
						[10] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
						[7] = {
							CLSID = "{AIM_54A_Mk47}",
						},
						[9] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
					},
					fuel = "7348",
					flare = 60,
					chaff = 140,
					gun = 100,
				},
			},
			["90s-2000s AA Iran AIM-7MH*6, AIM-9M*2"] = {
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
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
						[2] = {
							CLSID = "{SHOULDER AIM-7MH}",
						},
						[4] = {
							CLSID = "{BELLY AIM-7MH}",
						},
						[5] = {
							CLSID = "{BELLY AIM-7MH}",
						},
						[6] = {
							CLSID = "{BELLY AIM-7MH}",
						},
						[7] = {
							CLSID = "{BELLY AIM-7MH}",
						},
						[10] = {
							CLSID = "{LAU-138 wtip - AIM-9M}",
						},
						[9] = {
							CLSID = "{SHOULDER AIM-7MH}",
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