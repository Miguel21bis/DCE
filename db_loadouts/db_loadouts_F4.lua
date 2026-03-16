--Loadouts database
--F4 loadouts
-------------------------------------------------------------------------------------------------------

if not versionDCE then versionDCE = {} end
versionDCE["db_loadouts/db_loadouts_F4.lua"] = "1.1.1"

-- 1.1.1 - Beginning of the versions of this loadouts file dedicated to the F4.


db_loadouts = {
	["F-4E-45MC"] = {
		AFAC = {
			["AFAC test - NAM - Pod - AIM-7E-2-2*1 - ECM - AIM-9J*2 - FT*3"] = {
				attributes =  { },
				code_loadout =  { "All" },
				night = true,
				adverseWeather = true,
				range = 900000,
				firepower = 1,
				vCruise = 250,
				vAttack = 350,
				hCruise = 10096,
				hAttack = 10096,
				tStation = 18000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
					["CLSID"] = "{HB_PAVE_SPIKE_FAST_ON_ADAPTER_IN_AERO7}",
					["num"] = 6,
						},
						[2] = {
							["CLSID"] = "{F4_SARGENT_TANK_600_GAL}",
							["num"] = 7,
						},
						[3] = {
							["CLSID"] = "{F4_SARGENT_TANK_370_GAL}",
							["num"] = 1,
						},
						[4] = {
							["CLSID"] = "{F4_SARGENT_TANK_370_GAL_R}",
							["num"] = 13,
						},
						[5] = {
							["CLSID"] = "{HB_F4E_AIM-7E-2}",
							["num"] = 8,
						},
						[6] = {
							["CLSID"] = "{AIM-9J}",
							["num"] = 2,
						},
						[7] = {
							["CLSID"] = "{6D21ECEA-F85B-4E8D-9D51-31DC9B8AA4EF}",
							["num"] = 11,
						},
						[8] = {
							["CLSID"] = "{AIM-9J}",
							["num"] = 4,
						},
						[14] = {
							["CLSID"] = "{HB_ALE_40_30_60}",
							["num"] = 14,
						},
					},
					fuel = 5510.5,
					flare = 30,
					chaff = 120,
					gun = 100,
				},
			},
		},
		Reconnaissance = {
			["Reco - NAM - Pod - AIM-7E-2-2*1 - ECM - AIM-9J*2 - FT*3"] = {
				support = {
					Escort = false,
					SEAD = false,
				},
				attributes =  { },
				code_loadout =  { "NAM" },
				night = true,
				day = false,
				adverseWeather = true,
				range = 600000,
				firepower = 10,
				vCruise = 250,
				vAttack = 350,
				hCruise = 10096,
				hAttack = 10096,
				tStation = 2000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
					["CLSID"] = "{HB_PAVE_SPIKE_FAST_ON_ADAPTER_IN_AERO7}",
					["num"] = 6,
				},
				[2] = {
					["CLSID"] = "{F4_SARGENT_TANK_600_GAL}",
					["num"] = 7,
				},
				[3] = {
					["CLSID"] = "{F4_SARGENT_TANK_370_GAL}",
					["num"] = 1,
				},
				[4] = {
					["CLSID"] = "{F4_SARGENT_TANK_370_GAL_R}",
					["num"] = 13,
				},
				[5] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 8,
				},
				[6] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 2,
				},
				[7] = {
					["CLSID"] = "{6D21ECEA-F85B-4E8D-9D51-31DC9B8AA4EF}",
					["num"] = 11,
				},
				[8] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 4,
				},
				[14] = {
					["CLSID"] = "{HB_ALE_40_30_60}",
					["num"] = 14,
				},
					},
					fuel = 5510.5,
					flare = 30,
					chaff = 120,
					gun = 100,
				},
			},
		},
		Strike = {
			["Crisis - AG - LR - TPod - GBU-10x2 -  AIM-7Mx3 - FTx3 - DP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				country = {
					[1] = "Turkey",
				},
				attributes =  { "Bridge", "Structure" },
				code_loadout =  { "Crisis", "PG", "Cyprus" },
				weaponType = "Guided bombs",
				expend = "Auto",
				range = 500000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 5486.4,
				hAttack = 5487,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL}",
						},
						[2] = {
							CLSID = "{AIM-9M}",
						},
						[3] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
							settings = {
								["NFP_VIS_DrawArgNo_57"] = 0,
								laser_code = 1688,
								NFP_fuze_type_tail = "M905",
								["function_delay_ctrl_M905"] = 0,
								["arm_delay_ctrl_M905"] = 4,
							},
						},
						[4] = {
							CLSID = "{AIM-9M}",
						},
						[5] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[6] = {
							CLSID = "{HB_PAVE_SPIKE_ON_ADAPTER_IN_AERO7}",
						},
						[7] = {
							CLSID = "{F4_SARGENT_TANK_600_GAL}",
						},
						[8] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[9] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[10] = {
							CLSID = "{AIM-9M}",
						},
						[11] = {
							CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
							settings = {
								["NFP_VIS_DrawArgNo_57"] = 0,
								laser_code = 1688,
								NFP_fuze_type_tail = "M905",
								["function_delay_ctrl_M905"] = 0,
								["arm_delay_ctrl_M905"] = 4,
							},
						},
						[12] = {
							CLSID = "{AIM-9M}",
						},
						[13] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL_R}",
						},
						[14] = {
							CLSID = "{HB_ALE_40_30_60}",
						},
					},
					fuel = 5510.5,
					flare = 30,
					chaff = 120,
					gun = 100,
				},
			},
			["Crisis Strike AG - LR - ECM - AGM-65Bx6 - AIM-7Mx3 - FTx3 - DP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				country = {
					[1] = "Turkey",
				},
				attributes =  { "SAM", "soft", "frontline" },
				code_loadout =  { "Crisis", "PG", "HWITC", "Cyprus", "WOC80" },
				weaponType = "ASM",
				expend = "Auto",
				attackType = "Dive",
				range = 600000,
				firepower = 1,
				vCruise = 250,
				vAttack = 300,
				hCruise = 5486.4,
				hAttack = 4572,
				standoff = 15000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL}",
						},
						[2] = {
							CLSID = "<CLEAN>",
						},
						[3] = {
							CLSID = "{HB_F4EAGM-65B_LAU88_3x_Left}",
						},
						[4] = {
							CLSID = "<CLEAN>",
						},
						[5] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[6] = {
							CLSID = "{HB_ALQ-131_ON_ADAPTER_IN_AERO7}",
						},
						[7] = {
							CLSID = "{F4_SARGENT_TANK_600_GAL}",
						},
						[8] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[9] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[10] = {
							CLSID = "<CLEAN>",
							settings = {
								["NFP_VIS_DrawArgNo_57"] = 0,
								laser_code = 1688,
								NFP_fuze_type_tail = "M905",
								["function_delay_ctrl_M905"] = 0,
								["arm_delay_ctrl_M905"] = 4,
							},
						},
						[11] = {
							CLSID = "{HB_F4EAGM-65B_LAU88_3x_Right}",
						},
						[12] = {
							CLSID = "<CLEAN>",
							settings = {
								["NFP_VIS_DrawArgNo_57"] = 0,
								laser_code = 1688,
								NFP_fuze_type_tail = "M905",
								["function_delay_ctrl_M905"] = 0,
								["arm_delay_ctrl_M905"] = 4,
							},
						},
						[13] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL_R}",
						},
						[14] = {
							CLSID = "{HB_ALE_40_30_60}",
						},
					},
					fuel = 5510.5,
					flare = 30,
					chaff = 120,
					gun = 100,
				},
			},
			["Crisis AG - LR - ECM - Mk-82LDx10 - AIM-9Mx4- AIM-7Mx3 - FTx2 - DP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				country = {
					[1] = "Turkey",
				},
				attributes =  { "Bridge", "soft", "Parked Aircraft", "SAM", "frontline" },
				code_loadout =  { "HWITC", "Crisis", "PG", "Cyprus", "WOC80", "WOB" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
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
							CLSID = "{F4_SARGENT_TANK_370_GAL}",
						},
						[2] = {
							CLSID = "{AIM-9M}",
						},
						[3] = {
							CLSID = "{HB_F4E_MK-82_2x_SWA}",
							settings = {
								["function_delay_ctrl_M905"] = 0,
								["arm_delay_ctrl_M904E4"] = 2,
								["arm_delay_ctrl_M905"] = 4,
								["NFP_VIS_DrawArgNo_57"] = 0,
								NFP_fuze_type_tail = "M905",
								NFP_fuze_type_nose = "M904E4",
								["function_delay_ctrl_M904E4"] = 0,
							},
						},
						[4] = {
							CLSID = "{AIM-9M}",
						},
						[5] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[6] = {
							CLSID = "{HB_ALQ-131_ON_ADAPTER_IN_AERO7}",
						},
						[7] = {
							CLSID = "{HB_F4E_MK-82_6x}",
							settings = {
								["function_delay_ctrl_M905"] = 0,
								["arm_delay_ctrl_M904E4"] = 2,
								["arm_delay_ctrl_M905"] = 4,
								["NFP_VIS_DrawArgNo_57"] = 0,
								NFP_fuze_type_tail = "M905",
								NFP_fuze_type_nose = "M904E4",
								["function_delay_ctrl_M904E4"] = 0,
							},
						},
						[8] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[9] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[10] = {
							CLSID = "{AIM-9M}",
						},
						[11] = {
							CLSID = "{HB_F4E_MK-82_2x_SWA}",
							settings = {
								["function_delay_ctrl_M905"] = 0,
								["arm_delay_ctrl_M904E4"] = 2,
								["arm_delay_ctrl_M905"] = 4,
								["NFP_VIS_DrawArgNo_57"] = 0,
								NFP_fuze_type_tail = "M905",
								NFP_fuze_type_nose = "M904E4",
								["function_delay_ctrl_M904E4"] = 0,
							},
						},
						[12] = {
							CLSID = "{AIM-9M}",
						},
						[13] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL_R}",
						},
						[14] = {
							CLSID = "{HB_ALE_40_30_60}",
						},
					},
					fuel = 5510.5,
					flare = 30,
					chaff = 120,
					gun = 100,
				},
			},
			-- ["Crisis - AG - LR - TPod - GBU-12x4 - AIM-9Mx4- AIM-7Mx3 - FTx3 - DP"] = {
				-- minscore = 0.3,
				-- support = {
					-- Escort = true,
					-- SEAD = true,
				-- },
				-- country = {
					-- [1] = "Turkey",
				-- },
				-- attributes =  { "Bridge", "soft", "Parked Aircraft", "SAM" },
				-- code_loadout =  { "Crisis", "PG", "Cyprus", "WOB" },
				-- weaponType = "Guided bombs",
				-- expend = "Auto",
				-- 				-- range = 500000,
				-- firepower = 1,
				-- vCruise = 245,
				-- vAttack = 277.5,
				-- hCruise = 5486.4,
				-- hAttack = 5487,
				-- LDSD = true,
				-- sortie_rate = 6,
				-- stores = {
					-- pylons = {
						-- [1] = {
							-- CLSID = "{F4_SARGENT_TANK_370_GAL}",
						-- },
						-- [2] = {
							-- CLSID = "{AIM-9M}",
						-- },
						-- [3] = {
							-- CLSID = "{HB_F4E_GBU-12_2x_SWA}",
							-- settings = {
								-- ["NFP_VIS_DrawArgNo_57"] = 0,
								-- laser_code = 1688,
								-- NFP_fuze_type_tail = "M905",
								-- ["function_delay_ctrl_M905"] = 0,
								-- ["arm_delay_ctrl_M905"] = 4,
							-- },
						-- },
						-- [4] = {
							-- CLSID = "{AIM-9M}",
						-- },
						-- [5] = {
							-- CLSID = "{HB_F4E_AIM-7M}",
						-- },
						-- [6] = {
							-- CLSID = "{HB_PAVE_SPIKE_ON_ADAPTER_IN_AERO7}",
						-- },
						-- [7] = {
							-- CLSID = "{F4_SARGENT_TANK_600_GAL}",
						-- },
						-- [8] = {
							-- CLSID = "{HB_F4E_AIM-7M}",
						-- },
						-- [9] = {
							-- CLSID = "{HB_F4E_AIM-7M}",
						-- },
						-- [10] = {
							-- CLSID = "{AIM-9M}",
						-- },
						-- [11] = {
							-- CLSID = "{HB_F4E_GBU-12_2x_SWA}",
							-- settings = {
								-- ["NFP_VIS_DrawArgNo_57"] = 0,
								-- laser_code = 1688,
								-- NFP_fuze_type_tail = "M905",
								-- ["function_delay_ctrl_M905"] = 0,
								-- ["arm_delay_ctrl_M905"] = 4,
							-- },
						-- },
						-- [12] = {
							-- CLSID = "{AIM-9M}",
						-- },
						-- [13] = {
							-- CLSID = "{F4_SARGENT_TANK_370_GAL_R}",
						-- },
						-- [14] = {
							-- CLSID = "{HB_ALE_40_30_60}",
						-- },
					-- },
					-- fuel = 5510.5,
					-- flare = 30,
					-- chaff = 120,
					-- gun = 100,
				-- },
			-- },
			["Crisis Strike AG - LR - ECM - Mk-83LDx9 - AIM-7Mx3 - FTx2 - DP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				country = {
					[1] = "Turkey",
				},
				attributes =  { "Bridge", "Structure" },
				code_loadout =  { "HWITC", "Crisis", "PG", "Cyprus", "WOB" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
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
							CLSID = "{F4_SARGENT_TANK_370_GAL}",
						},
						[3] = {
							CLSID = "{HB_F4E_MK-83_3x}",
							settings = {
								["function_delay_ctrl_M905"] = 0,
								["arm_delay_ctrl_M904E4"] = 2,
								["arm_delay_ctrl_M905"] = 4,
								["NFP_VIS_DrawArgNo_57"] = 0,
								NFP_fuze_type_tail = "M905",
								NFP_fuze_type_nose = "M904E4",
								["function_delay_ctrl_M904E4"] = 0,
							},
						},
						[5] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[6] = {
							CLSID = "{HB_ALQ-131_ON_ADAPTER_IN_AERO7}",
						},
						[7] = {
							CLSID = "{HB_F4E_MK-83_MER_3x}",
							settings = {
								["function_delay_ctrl_M905"] = 0,
								["arm_delay_ctrl_M904E4"] = 2,
								["arm_delay_ctrl_M905"] = 4,
								["NFP_VIS_DrawArgNo_57"] = 0,
								NFP_fuze_type_tail = "M905",
								NFP_fuze_type_nose = "M904E4",
								["function_delay_ctrl_M904E4"] = 0,
							},
						},
						[8] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[9] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[10] = {
							CLSID = "<CLEAN>",
						},
						[11] = {
							CLSID = "{HB_F4E_MK-83_3x}",
							settings = {
								["function_delay_ctrl_M905"] = 0,
								["arm_delay_ctrl_M904E4"] = 2,
								["arm_delay_ctrl_M905"] = 4,
								["NFP_VIS_DrawArgNo_57"] = 0,
								NFP_fuze_type_tail = "M905",
								NFP_fuze_type_nose = "M904E4",
								["function_delay_ctrl_M904E4"] = 0,
							},
						},
						[12] = {
							CLSID = "<CLEAN>",
						},
						[13] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL_R}",
						},
						[14] = {
							CLSID = "{HB_ALE_40_30_60}",
						},
					},
					fuel = 5510.5,
					flare = 30,
					chaff = 120,
					gun = 100,
				},
			},
			["Crisis Strike AG - Iran - AG - LR - Mk-83LDx9 - AIM-7Ex4 - FTx2 - DP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				country = {
					[1] = "Iran",
				},
				attributes =  { "Bridge", "Structure" },
				code_loadout =  { "Crisis", "PG", "IIW" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
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
							CLSID = "{F4_SARGENT_TANK_370_GAL}",
						},
						[3] = {
							CLSID = "{HB_F4E_MK-83_3x}",
							settings = {
								["function_delay_ctrl_M905"] = 0,
								["arm_delay_ctrl_M904E4"] = 2,
								["arm_delay_ctrl_M905"] = 4,
								["NFP_VIS_DrawArgNo_57"] = 0,
								NFP_fuze_type_tail = "M905",
								NFP_fuze_type_nose = "M904E4",
								["function_delay_ctrl_M904E4"] = 0,
							},
						},
						[5] = {
							CLSID = "{HB_F4E_AIM-7E}",
						},
						[6] = {
							CLSID = "{HB_F4E_AIM-7E}",
						},
						[7] = {
							CLSID = "{HB_F4E_MK-83_MER_3x}",
							settings = {
								["function_delay_ctrl_M905"] = 0,
								["arm_delay_ctrl_M904E4"] = 2,
								["arm_delay_ctrl_M905"] = 4,
								["NFP_VIS_DrawArgNo_57"] = 0,
								NFP_fuze_type_tail = "M905",
								NFP_fuze_type_nose = "M904E4",
								["function_delay_ctrl_M904E4"] = 0,
							},
						},
						[8] = {
							CLSID = "{HB_F4E_AIM-7E}",
						},
						[9] = {
							CLSID = "{HB_F4E_AIM-7E}",
						},
						[10] = {
							CLSID = "<CLEAN>",
						},
						[11] = {
							CLSID = "{HB_F4E_MK-83_3x}",
							settings = {
								["function_delay_ctrl_M905"] = 0,
								["arm_delay_ctrl_M904E4"] = 2,
								["arm_delay_ctrl_M905"] = 4,
								["NFP_VIS_DrawArgNo_57"] = 0,
								NFP_fuze_type_tail = "M905",
								NFP_fuze_type_nose = "M904E4",
								["function_delay_ctrl_M904E4"] = 0,
							},
						},
						[12] = {
							CLSID = "<CLEAN>",
						},
						[13] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL_R}",
						},
						[14] = {
							CLSID = "{HB_ALE_40_30_60}",
						},
					},
					fuel = 5510.5,
					flare = 30,
					chaff = 120,
					gun = 100,
				},
			},
			-- ["Crisis Strike Iran - AG - LR - AGM-65Ax6 - AIM-7Ex3 - FTx3 - DP"] = {
				-- minscore = 0.3,
				-- support = {
					-- Escort = true,
					-- SEAD = true,
				-- },
				-- country = {
					-- [1] = "Iran",
				-- },
				-- attributes =  { "SAM", "soft" },
				-- code_loadout =  { "IIW", "Crisis", "PG" },
				-- weaponType = "ASM",
				-- expend = "Auto",
				-- attackType = "Dive",
				-- 				-- range = 600000,
				-- firepower = 1,
				-- vCruise = 250,
				-- vAttack = 300,
				-- hCruise = 5486.4,
				-- hAttack = 4572,
				-- standoff = 15000,
				-- LDSD = true,
				-- sortie_rate = 6,
				-- stores = {
					-- pylons = {
						-- [1] = {
							-- CLSID = "{F4_SARGENT_TANK_370_GAL}",
						-- },
						-- [2] = {
							-- CLSID = "<CLEAN>",
						-- },
						-- [3] = {
							-- CLSID = "{HB_F4EAGM-65A_LAU88_3x_Left}",
						-- },
						-- [4] = {
							-- CLSID = "<CLEAN>",
						-- },
						-- [5] = {
							-- CLSID = "{HB_F4E_AIM-7E}",
						-- },
						-- [6] = {
							-- CLSID = "{HB_F4E_AIM-7E}",
						-- },
						-- [7] = {
							-- CLSID = "{F4_SARGENT_TANK_600_GAL}",
						-- },
						-- [8] = {
							-- CLSID = "{HB_F4E_AIM-7E}",
						-- },
						-- [9] = {
							-- CLSID = "{HB_F4E_AIM-7E}",
						-- },
						-- [10] = {
							-- CLSID = "<CLEAN>",
							-- settings = {
								-- ["NFP_VIS_DrawArgNo_57"] = 0,
								-- laser_code = 1688,
								-- NFP_fuze_type_tail = "M905",
								-- ["function_delay_ctrl_M905"] = 0,
								-- ["arm_delay_ctrl_M905"] = 4,
							-- },
						-- },
						-- [11] = {
							-- CLSID = "{HB_F4EAGM-65A_LAU88_3x_Right}",
						-- },
						-- [12] = {
							-- CLSID = "<CLEAN>",
							-- settings = {
								-- ["NFP_VIS_DrawArgNo_57"] = 0,
								-- laser_code = 1688,
								-- NFP_fuze_type_tail = "M905",
								-- ["function_delay_ctrl_M905"] = 0,
								-- ["arm_delay_ctrl_M905"] = 4,
							-- },
						-- },
						-- [13] = {
							-- CLSID = "{F4_SARGENT_TANK_370_GAL_R}",
						-- },
						-- [14] = {
							-- CLSID = "{HB_ALE_40_30_60}",
						-- },
					-- },
					-- fuel = 5510.5,
					-- flare = 30,
					-- chaff = 120,
					-- gun = 100,
				-- },
			-- },
			-- ["Crisis - AG -SR - TPod - GBU-10x4 -  AIM-7Mx3 - FT  - DP"] = {
				-- minscore = 0.3,
				-- support = {
					-- Escort = true,
					-- SEAD = true,
				-- },
				-- country = {
					-- [1] = "Turkey",
				-- },
				-- attributes =  { "Bridge", "Structure" },
				-- code_loadout =  { "Crisis", "PG", "Cyprus", "WOB" },
				-- weaponType = "Guided bombs",
				-- expend = "Auto",
				-- 				-- range = 250000,
				-- firepower = 1,
				-- vCruise = 245,
				-- vAttack = 277.5,
				-- hCruise = 5486.4,
				-- hAttack = 5487,
				-- LDSD = true,
				-- sortie_rate = 6,
				-- stores = {
					-- pylons = {
						-- [1] = {
							-- CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
							-- settings = {
								-- ["NFP_VIS_DrawArgNo_57"] = 0,
								-- laser_code = 1688,
								-- NFP_fuze_type_tail = "M905",
								-- ["function_delay_ctrl_M905"] = 0,
								-- ["arm_delay_ctrl_M905"] = 4,
							-- },
						-- },
						-- [2] = {
							-- CLSID = "{AIM-9M}",
						-- },
						-- [3] = {
							-- CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
							-- settings = {
								-- ["NFP_VIS_DrawArgNo_57"] = 0,
								-- laser_code = 1688,
								-- NFP_fuze_type_tail = "M905",
								-- ["function_delay_ctrl_M905"] = 0,
								-- ["arm_delay_ctrl_M905"] = 4,
							-- },
						-- },
						-- [4] = {
							-- CLSID = "{AIM-9M}",
						-- },
						-- [5] = {
							-- CLSID = "{HB_F4E_AIM-7M}",
						-- },
						-- [6] = {
							-- CLSID = "{HB_PAVE_SPIKE_ON_ADAPTER_IN_AERO7}",
						-- },
						-- [7] = {
							-- CLSID = "{F4_SARGENT_TANK_600_GAL}",
						-- },
						-- [8] = {
							-- CLSID = "{HB_F4E_AIM-7M}",
						-- },
						-- [9] = {
							-- CLSID = "{HB_F4E_AIM-7M}",
						-- },
						-- [10] = {
							-- CLSID = "{AIM-9M}",
						-- },
						-- [11] = {
							-- CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
							-- settings = {
								-- ["NFP_VIS_DrawArgNo_57"] = 0,
								-- laser_code = 1688,
								-- NFP_fuze_type_tail = "M905",
								-- ["function_delay_ctrl_M905"] = 0,
								-- ["arm_delay_ctrl_M905"] = 4,
							-- },
						-- },
						-- [12] = {
							-- CLSID = "{AIM-9M}",
						-- },
						-- [13] = {
							-- CLSID = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
							-- settings = {
								-- ["NFP_VIS_DrawArgNo_57"] = 0,
								-- laser_code = 1688,
								-- NFP_fuze_type_tail = "M905",
								-- ["function_delay_ctrl_M905"] = 0,
								-- ["arm_delay_ctrl_M905"] = 4,
							-- },
						-- },
						-- [14] = {
							-- CLSID = "{HB_ALE_40_30_60}",
						-- },
					-- },
					-- fuel = 5510.5,
					-- flare = 30,
					-- chaff = 120,
					-- gun = 100,
				-- },
			-- },
			-- ["Crisis - AG - SR - TPod - GBU-12x6 - AIM-9Mx4- AIM-7Mx3 - FT - DP"] = {
				-- minscore = 0.3,
				-- support = {
					-- Escort = true,
					-- SEAD = true,
				-- },
				-- country = {
					-- [1] = "Turkey",
				-- },
				-- attributes =  { "Bridge", "soft", "Parked Aircraft", "SAM" },
				-- code_loadout =  { "Crisis", "PG", "Cyprus", "WOB" },
				-- weaponType = "Guided bombs",
				-- expend = "Auto",
				-- 				-- range = 250000,
				-- firepower = 1,
				-- vCruise = 245,
				-- vAttack = 277.5,
				-- hCruise = 5486.4,
				-- hAttack = 5487,
				-- LDSD = true,
				-- sortie_rate = 6,
				-- stores = {
					-- pylons = {
						-- [1] = {
							-- CLSID = "{DB769D48-67D7-42ED-A2BE-108D566C8B1E}",
							-- settings = {
								-- ["NFP_VIS_DrawArgNo_57"] = 0,
								-- laser_code = 1688,
								-- NFP_fuze_type_tail = "M905",
								-- ["function_delay_ctrl_M905"] = 0,
								-- ["arm_delay_ctrl_M905"] = 4,
							-- },
						-- },
						-- [2] = {
							-- CLSID = "{AIM-9M}",
						-- },
						-- [3] = {
							-- CLSID = "{HB_F4E_GBU-12_2x_SWA}",
							-- settings = {
								-- ["NFP_VIS_DrawArgNo_57"] = 0,
								-- laser_code = 1688,
								-- NFP_fuze_type_tail = "M905",
								-- ["function_delay_ctrl_M905"] = 0,
								-- ["arm_delay_ctrl_M905"] = 4,
							-- },
						-- },
						-- [4] = {
							-- CLSID = "{AIM-9M}",
						-- },
						-- [5] = {
							-- CLSID = "{HB_F4E_AIM-7M}",
						-- },
						-- [6] = {
							-- CLSID = "{HB_PAVE_SPIKE_ON_ADAPTER_IN_AERO7}",
						-- },
						-- [7] = {
							-- CLSID = "{F4_SARGENT_TANK_600_GAL}",
						-- },
						-- [8] = {
							-- CLSID = "{HB_F4E_AIM-7M}",
						-- },
						-- [9] = {
							-- CLSID = "{HB_F4E_AIM-7M}",
						-- },
						-- [10] = {
							-- CLSID = "{AIM-9M}",
						-- },
						-- [11] = {
							-- CLSID = "{HB_F4E_GBU-12_2x_SWA}",
							-- settings = {
								-- ["NFP_VIS_DrawArgNo_57"] = 0,
								-- laser_code = 1688,
								-- NFP_fuze_type_tail = "M905",
								-- ["function_delay_ctrl_M905"] = 0,
								-- ["arm_delay_ctrl_M905"] = 4,
							-- },
						-- },
						-- [12] = {
							-- CLSID = "{AIM-9M}",
						-- },
						-- [13] = {
							-- CLSID = "{DB769D48-67D7-42ED-A2BE-108D566C8B1E}",
							-- settings = {
								-- ["NFP_VIS_DrawArgNo_57"] = 0,
								-- laser_code = 1688,
								-- NFP_fuze_type_tail = "M905",
								-- ["function_delay_ctrl_M905"] = 0,
								-- ["arm_delay_ctrl_M905"] = 4,
							-- },
						-- },
						-- [14] = {
							-- CLSID = "{HB_ALE_40_30_60}",
						-- },
					-- },
					-- fuel = 5510.5,
					-- flare = 30,
					-- chaff = 120,
					-- gun = 100,
				-- },
			-- },
			["Crisis AG - LR - Iran - AG - LR - Mk-82LDx10 - AIM-9Jx4- AIM-7Ex3 - FTx2 - DP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				country = {
					[1] = "Iran",
				},
				attributes =  { "Bridge", "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "Crisis", "PG", "IIW" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
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
							CLSID = "{F4_SARGENT_TANK_370_GAL}",
						},
						[2] = {
							CLSID = "{AIM-9J}",
						},
						[3] = {
							CLSID = "{HB_F4E_MK-82_2x_SWA}",
							settings = {
								["function_delay_ctrl_M905"] = 0,
								["arm_delay_ctrl_M904E4"] = 2,
								["arm_delay_ctrl_M905"] = 4,
								["NFP_VIS_DrawArgNo_57"] = 0,
								NFP_fuze_type_tail = "M905",
								NFP_fuze_type_nose = "M904E4",
								["function_delay_ctrl_M904E4"] = 0,
							},
						},
						[4] = {
							CLSID = "{AIM-9J}",
						},
						[5] = {
							CLSID = "{HB_F4E_AIM-7E}",
						},
						[6] = {
							CLSID = "{HB_F4E_AIM-7E}",
						},
						[7] = {
							CLSID = "{HB_F4E_MK-82_6x}",
							settings = {
								["function_delay_ctrl_M905"] = 0,
								["arm_delay_ctrl_M904E4"] = 2,
								["arm_delay_ctrl_M905"] = 4,
								["NFP_VIS_DrawArgNo_57"] = 0,
								NFP_fuze_type_tail = "M905",
								NFP_fuze_type_nose = "M904E4",
								["function_delay_ctrl_M904E4"] = 0,
							},
						},
						[8] = {
							CLSID = "{HB_F4E_AIM-7E}",
						},
						[9] = {
							CLSID = "{HB_F4E_AIM-7E}",
						},
						[10] = {
							CLSID = "{AIM-9J}",
						},
						[11] = {
							CLSID = "{HB_F4E_MK-82_2x_SWA}",
							settings = {
								["function_delay_ctrl_M905"] = 0,
								["arm_delay_ctrl_M904E4"] = 2,
								["arm_delay_ctrl_M905"] = 4,
								["NFP_VIS_DrawArgNo_57"] = 0,
								NFP_fuze_type_tail = "M905",
								NFP_fuze_type_nose = "M904E4",
								["function_delay_ctrl_M904E4"] = 0,
							},
						},
						[12] = {
							CLSID = "{AIM-9J}",
						},
						[13] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL_R}",
						},
						[14] = {
							CLSID = "{HB_ALE_40_30_60}",
						},
					},
					fuel = 5510.5,
					flare = 30,
					chaff = 120,
					gun = 100,
				},
			},
			["NAM - AG High - AIM-7E-2*3 - AIM7J*4 - FT*2 - CMPod - ECM - Mk82 LD*10"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				country = {
					[1] = "USA",
				},
				attributes =  { "Bridge", "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "NAM" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
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
					["CLSID"] = "{HB_ALE_40_30_60}",
					["num"] = 14,
				},
				[2] = {
					["CLSID"] = "{F4_SARGENT_TANK_370_GAL_R}",
					["num"] = 13,
				},
				[3] = {
					["CLSID"] = "{F4_SARGENT_TANK_370_GAL}",
					["num"] = 1,
				},
				[4] = {
					["CLSID"] = "{HB_F4E_MK-82_6x}",
					["num"] = 7,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_M904E4"] = 4,
						["00_prfx_function_delay_ctrl_M904E4"] = 0,
						["01_prfx_arm_delay_ctrl_M905"] = 4,
						["01_prfx_function_delay_ctrl_M905"] = 0,
						["NFP_PRESID"] = "MDRN_B_A_GPLD",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
					},
				},
				[5] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 12,
				},
				[6] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 10,
				},
				[7] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 4,
				},
				[8] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 2,
				},
				[9] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 9,
				},
				[10] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 8,
				},
				[11] = {
					["CLSID"] = "{HB_ALQ-131_ON_ADAPTER_IN_AERO7}",
					["num"] = 6,
				},
				[12] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 5,
				},
				[13] = {
					["CLSID"] = "{HB_F4E_MK-82_2x_SWA}",
					["num"] = 11,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_M904E4"] = 4,
						["00_prfx_function_delay_ctrl_M904E4"] = 0,
						["01_prfx_arm_delay_ctrl_M905"] = 4,
						["01_prfx_function_delay_ctrl_M905"] = 0,
						["NFP_PRESID"] = "MDRN_B_A_GPLD",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
					},
				},
				[14] = {
					["CLSID"] = "{HB_F4E_MK-82_2x_SWA}",
					["num"] = 3,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_M904E4"] = 4,
						["00_prfx_function_delay_ctrl_M904E4"] = 0,
						["01_prfx_arm_delay_ctrl_M905"] = 4,
						["01_prfx_function_delay_ctrl_M905"] = 0,
						["NFP_PRESID"] = "MDRN_B_A_GPLD",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
					},
				},
					},
					fuel = 5510.5,
					flare = 30,
					chaff = 120,
					gun = 100,
				},
			},
			["NAM - AG High - AIM-7E-2*3 - AIM7J*4 - FT*2 - CMPod - ECM - Mk83 LD*3"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				country = {
					[1] = "USA",
				},
				attributes =  { "Bridge", "Structure" },
				code_loadout =  { "NAM" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
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
					["CLSID"] = "{HB_ALE_40_30_60}",
					["num"] = 14,
				},
				[2] = {
					["CLSID"] = "{F4_SARGENT_TANK_370_GAL_R}",
					["num"] = 13,
				},
				[3] = {
					["CLSID"] = "{F4_SARGENT_TANK_370_GAL}",
					["num"] = 1,
				},
				[4] = {
					["CLSID"] = "{HB_F4E_MK-83_MER_3x_Ripple}",
					["num"] = 7,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_M904E4"] = 4,
						["00_prfx_function_delay_ctrl_M904E4"] = 0,
						["01_prfx_arm_delay_ctrl_M905"] = 4,
						["01_prfx_function_delay_ctrl_M905"] = 0,
						["NFP_PRESID"] = "MDRN_B_A_GPLD",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
					},
				},
				[5] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 12,
				},
				[6] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 10,
				},
				[7] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 4,
				},
				[8] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 2,
				},
				[9] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 9,
				},
				[10] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 8,
				},
				[11] = {
					["CLSID"] = "{HB_ALQ-131_ON_ADAPTER_IN_AERO7}",
					["num"] = 6,
				},
				[12] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 5,
				},
					},
					fuel = 5510.5,
					flare = 30,
					chaff = 120,
					gun = 100,
				},
			},	
			["NAM - AG Low - AIM-7E-2*3 - AIM7J*4 - FT*2 - CMPod - ECM - Mk82 HD*10"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				country = {
					[1] = "USA",
				},
				attributes =  { "Bridge", "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "NAM" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 9100,
				hAttack = 200,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{HB_ALE_40_30_60}",
					["num"] = 14,
				},
				[2] = {
					["CLSID"] = "{F4_SARGENT_TANK_370_GAL_R}",
					["num"] = 13,
				},
				[3] = {
					["CLSID"] = "{F4_SARGENT_TANK_370_GAL}",
					["num"] = 1,
				},
				[4] = {
					["CLSID"] = "{HB_F4E_MK-82_Snakeye_6x}",
					["num"] = 7,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_M904E4"] = 4,
						["00_prfx_function_delay_ctrl_M904E4"] = 0,
						["01_prfx_arm_delay_ctrl_M905"] = 4,
						["01_prfx_function_delay_ctrl_M905"] = 0,
						["NFP_PRESID"] = "MDRN_B_A_GPLD",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
					},
				},
				[5] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 12,
				},
				[6] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 10,
				},
				[7] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 4,
				},
				[8] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 2,
				},
				[9] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 9,
				},
				[10] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 8,
				},
				[11] = {
					["CLSID"] = "{HB_ALQ-131_ON_ADAPTER_IN_AERO7}",
					["num"] = 6,
				},
				[12] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 5,
				},
				[13] = {
					["CLSID"] = "{HB_F4E_MK-82_Snakeye_2x_SWA}",
					["num"] = 11,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_M904E4"] = 4,
						["00_prfx_function_delay_ctrl_M904E4"] = 0,
						["01_prfx_arm_delay_ctrl_M905"] = 4,
						["01_prfx_function_delay_ctrl_M905"] = 0,
						["NFP_PRESID"] = "MDRN_B_A_GPLD",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
					},
				},
				[14] = {
					["CLSID"] = "{HB_F4E_MK-82_Snakeye_2x_SWA}",
					["num"] = 3,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_M904E4"] = 4,
						["00_prfx_function_delay_ctrl_M904E4"] = 0,
						["01_prfx_arm_delay_ctrl_M905"] = 4,
						["01_prfx_function_delay_ctrl_M905"] = 0,
						["NFP_PRESID"] = "MDRN_B_A_GPLD",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
					},
				},
					},
					fuel = 5510.5,
					flare = 30,
					chaff = 120,
					gun = 100,
				},
			},
			["NAM - AG Mk-20 Rockeye - AIM-7E-2*3 - AIM-9J*4 - FT*2 - CMPod - ECM - Mk20*10"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				country = {
					[1] = "USA",
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				restrictedCondition = "restricted_loadoutnam3",      --restricted_loadoutnam3
				code_loadout =  { "NAM" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
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
					["CLSID"] = "{HB_ALE_40_30_60}",
					["num"] = 14,
				},
				[2] = {
					["CLSID"] = "{F4_SARGENT_TANK_370_GAL_R}",
					["num"] = 13,
				},
				[3] = {
					["CLSID"] = "{F4_SARGENT_TANK_370_GAL}",
					["num"] = 1,
				},
				[4] = {
					["CLSID"] = "{HB_F4E_ROCKEYE_6x}",
					["num"] = 7,
					["settings"] = {
						["NFP_PRESID"] = "MDRN_CC_A_Mk20",
						["NFP_PRESVER"] = 2,
						["NFP_fuze_type_nose"] = "Mk339Mod1",
						["function_delay_ctrl_00_Mk339Mod1"] = 1.2,
						["function_delay_ctrl_01_Mk339Mod1"] = 4,
					},
				},
				[5] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 12,
				},
				[6] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 10,
				},
				[7] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 4,
				},
				[8] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 2,
				},
				[9] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 9,
				},
				[10] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 8,
				},
				[11] = {
					["CLSID"] = "{HB_ALQ-131_ON_ADAPTER_IN_AERO7}",
					["num"] = 6,
				},
				[12] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 5,
				},
				[13] = {
					["CLSID"] = "{HB_F4E_ROCKEYE_2x_SWA}",
					["num"] = 11,
					["settings"] = {
						["NFP_PRESID"] = "MDRN_CC_A_Mk20",
						["NFP_PRESVER"] = 2,
						["NFP_fuze_type_nose"] = "Mk339Mod1",
						["function_delay_ctrl_00_Mk339Mod1"] = 1.2,
						["function_delay_ctrl_01_Mk339Mod1"] = 4,
					},
				},
				[14] = {
					["CLSID"] = "{HB_F4E_ROCKEYE_2x_SWA}",
					["num"] = 3,
					["settings"] = {
						["NFP_PRESID"] = "MDRN_CC_A_Mk20",
						["NFP_PRESVER"] = 2,
						["NFP_fuze_type_nose"] = "Mk339Mod1",
						["function_delay_ctrl_00_Mk339Mod1"] = 1.2,
						["function_delay_ctrl_01_Mk339Mod1"] = 4,
					},
				},
					},
					fuel = 5510.5,
					flare = 30,
					chaff = 120,
					gun = 100,
				},
			},
			["NAM - AG Hobos - AIM-7E-2*3 - AIM-9J*3 - FT - CMPod - ECM Pod - GBU-8*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				country = {
					[1] = "USA",
				},
				attributes =  { "Bridge", "Structure" },
				restrictedCondition = "restricted_loadoutnam3",      --restricted_loadoutnam3
				code_loadout =  { "NAM" },
				weaponType = "ASM",
				expend = "Auto",
				attackType = "Dive",
				range = 400000,
				firepower = 1,
				vCruise = 250,
				vAttack = 300,
				hCruise = 5486.4,
				hAttack = 4572,
				standoff = 5000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{HB_ALE_40_30_60}",
					["num"] = 14,
				},
				[2] = {
					["CLSID"] = "{GBU_8_B}",
					["num"] = 13,
				},
				[3] = {
					["CLSID"] = "{GBU_8_B}",
					["num"] = 1,
				},
				[4] = {
					["CLSID"] = "{F4_SARGENT_TANK_600_GAL}",
					["num"] = 7,
				},
				[5] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 12,
				},
				[6] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 10,
				},
				[7] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 4,
				},
				[8] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 2,
				},
				[9] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 9,
				},
				[10] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 8,
				},
				[11] = {
					["CLSID"] = "{HB_ALQ-131_ON_ADAPTER_IN_AERO7}",
					["num"] = 6,
				},
				[12] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 5,
				},
					},
					fuel = 5510.5,
					flare = 30,
					chaff = 120,
					gun = 100,
				},
			},
			["NAM - AG Smart - AIM-7E-2*3 - FT*3 - CMPod - ECM Pod - Walleye I*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				country = {
					[1] = "USA",
				},
				attributes =  { "Bridge", "Structure" },
				restrictedCondition = "restricted_loadoutnam4",      --restricted_loadoutnam3
				code_loadout =  { "NAM" },
				weaponType = "ASM",
				expend = "Auto",
				attackType = "Dive",
				range = 600000,
				firepower = 1,
				vCruise = 250,
				vAttack = 300,
				hCruise = 5486.4,
				hAttack = 4572,
				standoff = 5000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{HB_ALE_40_30_60}",
					["num"] = 14,
				},
				[2] = {
					["CLSID"] = "{F4_SARGENT_TANK_370_GAL_R}",
					["num"] = 13,
				},
				[3] = {
					["CLSID"] = "{F4_SARGENT_TANK_370_GAL}",
					["num"] = 1,
				},
				[4] = {
					["CLSID"] = "{F4_SARGENT_TANK_600_GAL}",
					["num"] = 7,
				},
				[5] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 12,
				},
				[6] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 10,
				},
				[7] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 4,
				},
				[8] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 2,
				},
				[9] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 9,
				},
				[10] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 8,
				},
				[11] = {
					["CLSID"] = "{HB_ALQ-131_ON_ADAPTER_IN_AERO7}",
					["num"] = 6,
				},
				[12] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 5,
				},
				[13] = {
					["CLSID"] = "{AGM_62_I}",
					["num"] = 11,
				},
				[14] = {
					["CLSID"] = "{AGM_62_I}",
					["num"] = 3,
				},
					},
					fuel = 5510.5,
					flare = 30,
					chaff = 120,
					gun = 100,
				},
			},
			["NAM - AG LG - AIM-7E-2*3 - AIM-9J*4 - FT - CMPod - Laser Pod - GBU-10*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				country = {
					[1] = "USA",
				},
				attributes =  { "Bridge", "Structure", "Parked Aircraft", "SAM" },
				restrictedCondition = "restricted_loadoutnam4",      --restricted_loadoutnam4
				code_loadout =  { "NAM" },
				weaponType = "Guided bombs",
				expend = "Auto",
				range = 400000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 5486.4,
				hAttack = 5487,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{HB_ALE_40_30_60}",
					["num"] = 14,
				},
				[2] = {
					["CLSID"] = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
					["num"] = 13,
					["settings"] = {
						["01_prfx_arm_delay_ctrl_FMU139CB_LD"] = 4,
						["01_prfx_function_delay_ctrl_FMU139CB_LD"] = 0,
						["NFP_PRESID"] = "Paveway_II",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_tail"] = "FMU139CB_LD",
						["laser_code"] = 1688,
					},
				},
				[3] = {
					["CLSID"] = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
					["num"] = 1,
					["settings"] = {
						["01_prfx_arm_delay_ctrl_FMU139CB_LD"] = 4,
						["01_prfx_function_delay_ctrl_FMU139CB_LD"] = 0,
						["NFP_PRESID"] = "Paveway_II",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_tail"] = "FMU139CB_LD",
						["laser_code"] = 1688,
					},
				},
				[4] = {
					["CLSID"] = "{F4_SARGENT_TANK_600_GAL}",
					["num"] = 7,
				},
				[5] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 12,
				},
				[6] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 10,
				},
				[7] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 4,
				},
				[8] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 2,
				},
				[9] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 9,
				},
				[10] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 8,
				},
				[11] = {
					["CLSID"] = "{HB_PAVE_SPIKE_FAST_ON_ADAPTER_IN_AERO7}",
					["num"] = 6,
				},
				[12] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 5,
				},
					},
					fuel = 5510.5,
					flare = 30,
					chaff = 120,
					gun = 100,
				},
			},
			["NAM - AG Walleye II - AIM-7E-2*3 - FT*3 - CMPod - ECM Pod - AGM-62*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				country = {
					[1] = "USA",
				},
				attributes =  { "Bridge", "Structure" },
				restrictedCondition = "restricted_loadoutnam4",      --restricted_loadoutnam4
				code_loadout =  { "NAM" },
				weaponType = "ASM",
				expend = "Auto",
				attackType = "Dive",
				range = 600000,
				firepower = 1,
				vCruise = 250,
				vAttack = 300,
				hCruise = 5486.4,
				hAttack = 4572,
				standoff = 5000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{HB_ALE_40_30_60}",
					["num"] = 14,
				},
				[2] = {
					["CLSID"] = "{F4_SARGENT_TANK_370_GAL_R}",
					["num"] = 13,
				},
				[3] = {
					["CLSID"] = "{F4_SARGENT_TANK_370_GAL}",
					["num"] = 1,
				},
				[4] = {
					["CLSID"] = "{F4_SARGENT_TANK_600_GAL}",
					["num"] = 7,
				},
				[5] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 12,
				},
				[6] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 10,
				},
				[7] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 4,
				},
				[8] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 2,
				},
				[9] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 9,
				},
				[10] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 8,
				},
				[11] = {
					["CLSID"] = "{HB_ALQ-131_ON_ADAPTER_IN_AERO7}",
					["num"] = 6,
				},
				[12] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 5,
				},
				[13] = {
					["CLSID"] = "{C40A1E3A-DD05-40D9-85A4-217729E37FAE}",
					["num"] = 11,
				},
				[14] = {
					["CLSID"] = "{C40A1E3A-DD05-40D9-85A4-217729E37FAE}",
					["num"] = 3,
				},
					},
					fuel = 5510.5,
					flare = 30,
					chaff = 120,
					gun = 100,
				},
			},
			["NAM - AG LG - AIM-7E-2*3 - AIM-9J*4 - FT*3 - CMPod - ECM Pod - AGM-65A*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				country = {
					[1] = "USA",
				},
				attributes =  { "SAM", "soft"},
				restrictedCondition = "restricted_loadoutnam4",      --restricted_loadoutnam4
				code_loadout =  { "NAM" },
				weaponType = "ASM",
				expend = "Auto",
				attackType = "Dive",
				range = 600000,
				firepower = 1,
				vCruise = 250,
				vAttack = 300,
				hCruise = 5486.4,
				hAttack = 4572,
				standoff = 15000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{HB_ALE_40_30_60}",
					["num"] = 14,
				},
				[2] = {
					["CLSID"] = "{F4_SARGENT_TANK_370_GAL_R}",
					["num"] = 13,
				},
				[3] = {
					["CLSID"] = "{F4_SARGENT_TANK_370_GAL}",
					["num"] = 1,
				},
				[4] = {
					["CLSID"] = "{F4_SARGENT_TANK_600_GAL}",
					["num"] = 7,
				},
				[5] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 12,
				},
				[6] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 10,
				},
				[7] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 4,
				},
				[8] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 2,
				},
				[9] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 9,
				},
				[10] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 8,
				},
				[11] = {
					["CLSID"] = "{HB_ALQ-131_ON_ADAPTER_IN_AERO7}",
					["num"] = 6,
				},
				[12] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 5,
				},
				[13] = {
					["CLSID"] = "{HB_F4E_AGM-65A_LAU117_SWA}",
					["num"] = 11,
				},
				[14] = {
					["CLSID"] = "{HB_F4E_AGM-65A_LAU117_SWA}",
					["num"] = 3,
				},
					},
					fuel = 5510.5,
					flare = 30,
					chaff = 120,
					gun = 100,
				},
			},
			["NAM - AG LG - AIM-7E-2*3 - FT*3 - CMPod - ECM Pod - AGM-65A*6"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				country = {
					[1] = "USA",
				},
				attributes =  { "SAM", "soft"},
				restrictedCondition = "restricted_loadoutnam4",      --restricted_loadoutnam4
				code_loadout =  { "NAM" },
				weaponType = "ASM",
				expend = "Auto",
				attackType = "Dive",
				range = 600000,
				firepower = 1,
				vCruise = 250,
				vAttack = 300,
				hCruise = 5486.4,
				hAttack = 4572,
				standoff = 15000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{HB_ALE_40_30_60}",
					["num"] = 14,
				},
				[2] = {
					["CLSID"] = "{F4_SARGENT_TANK_370_GAL_R}",
					["num"] = 13,
				},
				[3] = {
					["CLSID"] = "{F4_SARGENT_TANK_370_GAL}",
					["num"] = 1,
				},
				[4] = {
					["CLSID"] = "{F4_SARGENT_TANK_600_GAL}",
					["num"] = 7,
				},
				[5] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 12,
				},
				[6] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 10,
				},
				[7] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 4,
				},
				[8] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 2,
				},
				[9] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 9,
				},
				[10] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 8,
				},
				[11] = {
					["CLSID"] = "{HB_ALQ-131_ON_ADAPTER_IN_AERO7}",
					["num"] = 6,
				},
				[12] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 5,
				},
				[13] = {
					["CLSID"] = "{HB_F4EAGM-65A_LAU88_3x_Right}",
					["num"] = 11,
				},
				[14] = {
					["CLSID"] = "{HB_F4EAGM-65A_LAU88_3x_Left}",
					["num"] = 3,
				},
					},
					fuel = 5510.5,
					flare = 30,
					chaff = 120,
					gun = 100,
				},
			},
		},
		["Anti-ship Strike"] = {
			["NAM AG - AIM-9Jx4 - AIM-7E-2x4 - FT - Mk-82LDx16"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
					["Escort Jammer"] = true,
				},
				country = {
					[1] = "USA",
				},
				attributes =  { "ship" },
				code_loadout =  { "NAM" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
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
					["CLSID"] = "{AIM-9J}",
					["num"] = 12,
				},
				[2] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 10,
				},
				[3] = {
					["CLSID"] = "{F4_SARGENT_TANK_600_GAL}",
					["num"] = 7,
				},
				[4] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 4,
				},
				[5] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 2,
				},
				[6] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 9,
				},
				[7] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 8,
				},
				[8] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 6,
				},
				[9] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 5,
				},
				[10] = {
					["CLSID"] = "{HB_F4E_MK-82_6x}",
					["num"] = 13,
					["settings"] = {
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
						["arm_delay_ctrl_M904E4"] = 2,
						["arm_delay_ctrl_M905"] = 4,
						["function_delay_ctrl_M904E4"] = 0,
						["function_delay_ctrl_M905"] = 0,
					},
				},
				[11] = {
					["CLSID"] = "{HB_F4E_MK-82_6x}",
					["num"] = 1,
					["settings"] = {
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
						["arm_delay_ctrl_M904E4"] = 2,
						["arm_delay_ctrl_M905"] = 4,
						["function_delay_ctrl_M904E4"] = 0,
						["function_delay_ctrl_M905"] = 0,
					},
				},
				[12] = {
					["CLSID"] = "{HB_F4E_MK-82_2x_SWA}",
					["num"] = 11,
					["settings"] = {
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
						["arm_delay_ctrl_M904E4"] = 2,
						["arm_delay_ctrl_M905"] = 4,
						["function_delay_ctrl_M904E4"] = 0,
						["function_delay_ctrl_M905"] = 0,
					},
				},
				[13] = {
					["CLSID"] = "{HB_F4E_MK-82_2x_SWA}",
					["num"] = 3,
					["settings"] = {
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
						["arm_delay_ctrl_M904E4"] = 2,
						["arm_delay_ctrl_M905"] = 4,
						["function_delay_ctrl_M904E4"] = 0,
						["function_delay_ctrl_M905"] = 0,
					},
				},
				[14] = {
					["CLSID"] = "{HB_ALE_40_30_60}",
					["num"] = 14,
				},
					},
					fuel = 5510.5,
					flare = 30,
					chaff = 120,
					gun = 100,
				},
			},
			-- ["Anti-Ship Strike NAM - AIM_9B*4 - AIM-7E-2*3 - ECM - AGM-65A*2 - FT*3"] = {
				-- minscore = 0.3,
				-- support = {
					-- Escort = true,
					-- SEAD = false,
					-- ["Escort Jammer"] = true,
				-- },
				-- country = {
					-- [1] = "USA",
				-- },
				-- attributes =  { "ship" },
				-- code_loadout =  { "NAM" },
				-- weaponType = "ASM",
				-- expend = "Auto",
				-- 				-- night = true,
				-- adverseWeather = true,
				-- range = 900000,
				-- firepower = 1,
				-- vCruise = 250,
				-- vAttack = 300,
				-- hCruise = 6096,
				-- hAttack = 6096,
				-- standoff = 10000,
				-- sortie_rate = 10,
				-- stores = {
					-- pylons = {
						-- [1] = {
					-- ["CLSID"] = "{F4_SARGENT_TANK_370_GAL_R}",
					-- ["num"] = 13,
				-- },
				-- [2] = {
					-- ["CLSID"] = "{F4_SARGENT_TANK_370_GAL}",
					-- ["num"] = 1,
				-- },
				-- [3] = {
					-- ["CLSID"] = "{AIM-9J}",
					-- ["num"] = 12,
				-- },
				-- [4] = {
					-- ["CLSID"] = "{AIM-9J}",
					-- ["num"] = 10,
				-- },
				-- [5] = {
					-- ["CLSID"] = "{AIM-9J}",
					-- ["num"] = 4,
				-- },
				-- [6] = {
					-- ["CLSID"] = "{AIM-9J}",
					-- ["num"] = 2,
				-- },
				-- [7] = {
					-- ["CLSID"] = "{HB_F4E_AGM-65A_LAU117_SWA}",
					-- ["num"] = 3,
				-- },
				-- [8] = {
					-- ["CLSID"] = "{HB_F4E_AGM-65A_LAU117_SWA}",
					-- ["num"] = 11,
				-- },
				-- [9] = {
					-- ["CLSID"] = "{F4_SARGENT_TANK_600_GAL}",
					-- ["num"] = 7,
				-- },
				-- [10] = {
					-- ["CLSID"] = "{HB_F4E_AIM-7E-2}",
					-- ["num"] = 8,
				-- },
				-- [11] = {
					-- ["CLSID"] = "{HB_F4E_AIM-7E-2}",
					-- ["num"] = 9,
				-- },
				-- [12] = {
					-- ["CLSID"] = "{HB_ALQ-131_ON_ADAPTER_IN_AERO7}",
					-- ["num"] = 6,
				-- },
				-- [13] = {
					-- ["CLSID"] = "{HB_F4E_AIM-7E-2}",
					-- ["num"] = 5,
				-- },
				-- [14] = {
					-- ["CLSID"] = "{HB_ALE_40_30_60}",
					-- ["num"] = 14,
				-- },
					-- },
					-- fuel = 5510.5,
					-- flare = 30,
					-- chaff = 120,
					-- gun = 100,
				-- },
			-- },
			-- ["Anti-Ship Strike Crisis - AG - LR - ECM - AGM-65Bx6 - AIM-7Mx3 - FTx3 - DP"] = {
				-- minscore = 0.3,
				-- support = {
					-- Escort = true,
					-- SEAD = false,
				-- },
				-- country = {
					-- [1] = "Turkey",
				-- },
				-- attributes =  { "ship" },
				-- code_loadout =  { "Crisis", "PG", "WOB" },
				-- weaponType = "ASM",
				-- expend = "Auto",
				-- 				-- night = true,
				-- adverseWeather = true,
				-- range = 900000,
				-- firepower = 1,
				-- vCruise = 250,
				-- vAttack = 300,
				-- hCruise = 6096,
				-- hAttack = 6096,
				-- standoff = 10000,
				-- sortie_rate = 10,
				-- stores = {
					-- pylons = {
						-- [1] = {
							-- CLSID = "{F4_SARGENT_TANK_370_GAL}",
						-- },
						-- [2] = {
							-- CLSID = "<CLEAN>",
						-- },
						-- [3] = {
							-- CLSID = "{HB_F4EAGM-65B_LAU88_3x_Left}",
						-- },
						-- [4] = {
							-- CLSID = "<CLEAN>",
						-- },
						-- [5] = {
							-- CLSID = "{HB_F4E_AIM-7M}",
						-- },
						-- [6] = {
							-- CLSID = "{HB_ALQ-131_ON_ADAPTER_IN_AERO7}",
						-- },
						-- [7] = {
							-- CLSID = "{F4_SARGENT_TANK_600_GAL}",
						-- },
						-- [8] = {
							-- CLSID = "{HB_F4E_AIM-7M}",
						-- },
						-- [9] = {
							-- CLSID = "{HB_F4E_AIM-7M}",
						-- },
						-- [10] = {
							-- CLSID = "<CLEAN>",
							-- settings = {
								-- ["NFP_VIS_DrawArgNo_57"] = 0,
								-- laser_code = 1688,
								-- NFP_fuze_type_tail = "M905",
								-- ["function_delay_ctrl_M905"] = 0,
								-- ["arm_delay_ctrl_M905"] = 4,
							-- },
						-- },
						-- [11] = {
							-- CLSID = "{HB_F4EAGM-65B_LAU88_3x_Right}",
						-- },
						-- [12] = {
							-- CLSID = "<CLEAN>",
							-- settings = {
								-- ["NFP_VIS_DrawArgNo_57"] = 0,
								-- laser_code = 1688,
								-- NFP_fuze_type_tail = "M905",
								-- ["function_delay_ctrl_M905"] = 0,
								-- ["arm_delay_ctrl_M905"] = 4,
							-- },
						-- },
						-- [13] = {
							-- CLSID = "{F4_SARGENT_TANK_370_GAL_R}",
						-- },
						-- [14] = {
							-- CLSID = "{HB_ALE_40_30_60}",
						-- },
					-- },
					-- fuel = 5510.5,
					-- flare = 30,
					-- chaff = 120,
					-- gun = 100,
				-- },
			-- },
			-- ["Anti-Ship Strike Turkey Cyprus AG - LR - ECM - AGM-65Bx6 - AIM-7Mx3 - FTx3 - DP"] = {
				-- minscore = 0.3,
				-- support = {
					-- Escort = true,
					-- SEAD = false,
				-- },
				-- country = {
					-- [1] = "Turkey",
				-- },
				-- attributes =  { "ship" },
				-- code_loadout =  { "Cyprus" },
				-- weaponType = "ASM",
				-- expend = "Auto",
				-- 				-- night = true,
				-- adverseWeather = true,
				-- range = 450000,
				-- firepower = 1,
				-- vCruise = 250,
				-- vAttack = 300,
				-- hCruise = 6096,
				-- hAttack = 6096,
				-- standoff = 10000,
				-- sortie_rate = 6,
				-- stores = {
					-- pylons = {
						-- [1] = {
							-- CLSID = "{F4_SARGENT_TANK_370_GAL}",
						-- },
						-- [2] = {
							-- CLSID = "<CLEAN>",
						-- },
						-- [3] = {
							-- CLSID = "{HB_F4EAGM-65B_LAU88_3x_Left}",
						-- },
						-- [4] = {
							-- CLSID = "<CLEAN>",
						-- },
						-- [5] = {
							-- CLSID = "{HB_F4E_AIM-7M}",
						-- },
						-- [6] = {
							-- CLSID = "{HB_ALQ-131_ON_ADAPTER_IN_AERO7}",
						-- },
						-- [7] = {
							-- CLSID = "{F4_SARGENT_TANK_600_GAL}",
						-- },
						-- [8] = {
							-- CLSID = "{HB_F4E_AIM-7M}",
						-- },
						-- [9] = {
							-- CLSID = "{HB_F4E_AIM-7M}",
						-- },
						-- [10] = {
							-- CLSID = "<CLEAN>",
							-- settings = {
								-- ["NFP_VIS_DrawArgNo_57"] = 0,
								-- laser_code = 1688,
								-- NFP_fuze_type_tail = "M905",
								-- ["function_delay_ctrl_M905"] = 0,
								-- ["arm_delay_ctrl_M905"] = 4,
							-- },
						-- },
						-- [11] = {
							-- CLSID = "{HB_F4EAGM-65B_LAU88_3x_Right}",
						-- },
						-- [12] = {
							-- CLSID = "<CLEAN>",
							-- settings = {
								-- ["NFP_VIS_DrawArgNo_57"] = 0,
								-- laser_code = 1688,
								-- NFP_fuze_type_tail = "M905",
								-- ["function_delay_ctrl_M905"] = 0,
								-- ["arm_delay_ctrl_M905"] = 4,
							-- },
						-- },
						-- [13] = {
							-- CLSID = "{F4_SARGENT_TANK_370_GAL_R}",
						-- },
						-- [14] = {
							-- CLSID = "{HB_ALE_40_30_60}",
						-- },
					-- },
					-- fuel = 5510.5,
					-- flare = 30,
					-- chaff = 120,
					-- gun = 100,
				-- },
			-- },
			-- ["Anti-Ship Strike Crisis - Iran - AG - LR - AGM-65Ax6 - AIM-7E-2x3 - FTx3 - DP"] = {
				-- minscore = 0.3,
				-- support = {
					-- Escort = true,
					-- SEAD = false,
				-- },
				-- country = {
					-- [1] = "Iran",
				-- },
				-- attributes =  { "ship" },
				-- code_loadout =  { "Crisis", "PG" },
				-- weaponType = "ASM",
				-- expend = "All",
				-- 				-- night = true,
				-- adverseWeather = true,
				-- range = 900000,
				-- firepower = 1,
				-- vCruise = 250,
				-- vAttack = 300,
				-- hCruise = 6096,
				-- hAttack = 6096,
				-- standoff = 10000,
				-- sortie_rate = 10,
				-- stores = {
					-- pylons = {
						-- [1] = {
							-- CLSID = "{F4_SARGENT_TANK_370_GAL}",
						-- },
						-- [2] = {
							-- CLSID = "<CLEAN>",
						-- },
						-- [3] = {
							-- CLSID = "{HB_F4EAGM-65A_LAU88_3x_Left}",
						-- },
						-- [4] = {
							-- CLSID = "<CLEAN>",
						-- },
						-- [5] = {
							-- CLSID = "{HB_F4E_AIM-7E-2}",
						-- },
						-- [6] = {
							-- CLSID = "{HB_F4E_AIM-7E-2}",
						-- },
						-- [7] = {
							-- CLSID = "{F4_SARGENT_TANK_600_GAL}",
						-- },
						-- [8] = {
							-- CLSID = "{HB_F4E_AIM-7E-2}",
						-- },
						-- [9] = {
							-- CLSID = "{HB_F4E_AIM-7E-2}",
						-- },
						-- [10] = {
							-- CLSID = "<CLEAN>",
							-- settings = {
								-- ["NFP_VIS_DrawArgNo_57"] = 0,
								-- laser_code = 1688,
								-- NFP_fuze_type_tail = "M905",
								-- ["function_delay_ctrl_M905"] = 0,
								-- ["arm_delay_ctrl_M905"] = 4,
							-- },
						-- },
						-- [11] = {
							-- CLSID = "{HB_F4EAGM-65A_LAU88_3x_Right}",
						-- },
						-- [12] = {
							-- CLSID = "<CLEAN>",
							-- settings = {
								-- ["NFP_VIS_DrawArgNo_57"] = 0,
								-- laser_code = 1688,
								-- NFP_fuze_type_tail = "M905",
								-- ["function_delay_ctrl_M905"] = 0,
								-- ["arm_delay_ctrl_M905"] = 4,
							-- },
						-- },
						-- [13] = {
							-- CLSID = "{F4_SARGENT_TANK_370_GAL_R}",
						-- },
						-- [14] = {
							-- CLSID = "{HB_ALE_40_30_60}",
						-- },
					-- },
					-- fuel = 5510.5,
					-- flare = 30,
					-- chaff = 120,
					-- gun = 100,
				-- },
			-- },
		},
		Escort = {
			["Crisis LR Escort Iran - AA - AIM-9Jx4 - AIM-7Ex4 - FTx3 - DP"] = {
				country = {
					[1] = "Iran",
				},
				attributes =  { },
				code_loadout =  { "Crisis", "PG", "IIW" },
				night = true,
				adverseWeather = true,
				range = 800000,
				firepower = 2,
				vCruise = 255,
				standoff = 46300,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL}",
						},
						[2] = {
							CLSID = "{AIM-9J}",
						},
						[4] = {
							CLSID = "{AIM-9J}",
						},
						[5] = {
							CLSID = "{HB_F4E_AIM-7E}",
						},
						[6] = {
							CLSID = "{HB_F4E_AIM-7E}",
						},
						[7] = {
							CLSID = "{F4_SARGENT_TANK_600_GAL}",
						},
						[8] = {
							CLSID = "{HB_F4E_AIM-7E}",
						},
						[9] = {
							CLSID = "{HB_F4E_AIM-7E}",
						},
						[10] = {
							CLSID = "{AIM-9J}",
						},
						[12] = {
							CLSID = "{AIM-9J}",
						},
						[13] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL_R}",
						},
						[14] = {
							CLSID = "{HB_ALE_40_30_60}",
						},
					},
					fuel = 5510.5,
					flare = 30,
					chaff = 120,
					gun = 100,
				},
			},
			["Cyprus Escort LR -ECM - AIM-9Mx4 - AIM-7Mx3 - FTx3 - DP"] = {
				country = {
					[1] = "Turkey",
				},
				attributes =  { },
				code_loadout =  { "Cyprus", "WOB" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1.5,
				vCruise = 255.83333333333,
				standoff = 46300,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL}",
						},
						[2] = {
							CLSID = "{AIM-9M}",
						},
						[4] = {
							CLSID = "{AIM-9M}",
						},
						[5] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[6] = {
							CLSID = "{HB_ALQ-131_ON_ADAPTER_IN_AERO7}",
						},
						[7] = {
							CLSID = "{F4_SARGENT_TANK_600_GAL}",
						},
						[8] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[9] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[10] = {
							CLSID = "{AIM-9M}",
						},
						[12] = {
							CLSID = "{AIM-9M}",
						},
						[13] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL_R}",
						},
						[14] = {
							CLSID = "{HB_ALE_40_30_60}",
						},
					},
					fuel = 5510.5,
					flare = 30,
					chaff = 120,
					gun = 100,
				},
			},
			["Crisis LR Escort -ECM - AIM-9Mx4 - AIM-7Mx3 - FTx3 - DP"] = {
				country = {
					[1] = "Turkey",
					[2] = "UK",
				},
				attributes =  { },
				code_loadout =  { "Crisis", "PG", "Revenge", "WOB" },
				night = true,
				adverseWeather = true,
				range = 800000,
				firepower = 1.5,
				vCruise = 255,
				standoff = 46300,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL}",
						},
						[2] = {
							CLSID = "{AIM-9M}",
						},
						[4] = {
							CLSID = "{AIM-9M}",
						},
						[5] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[6] = {
							CLSID = "{HB_ALQ-131_ON_ADAPTER_IN_AERO7}",
						},
						[7] = {
							CLSID = "{F4_SARGENT_TANK_600_GAL}",
						},
						[8] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[9] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[10] = {
							CLSID = "{AIM-9M}",
						},
						[12] = {
							CLSID = "{AIM-9M}",
						},
						[13] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL_R}",
						},
						[14] = {
							CLSID = "{HB_ALE_40_30_60}",
						},
					},
					fuel = 5510.5,
					flare = 30,
					chaff = 120,
					gun = 100,
				},
			},
			["GTA AIR/AIR Escort LR - AIM-9Mx4 - AIM-7Mx4 - FTx3 - DP"] = {
				country = {
					[1] = "Turkey",
				},
				attributes =  { },
				code_loadout =  { "HWITC" },
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
							CLSID = "{F4_SARGENT_TANK_370_GAL}",
						},
						[2] = {
							CLSID = "{AIM-9M}",
						},
						[4] = {
							CLSID = "{AIM-9M}",
						},
						[5] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[6] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[7] = {
							CLSID = "{F4_SARGENT_TANK_600_GAL}",
						},
						[8] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[9] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[10] = {
							CLSID = "{AIM-9M}",
						},
						[12] = {
							CLSID = "{AIM-9M}",
						},
						[13] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL_R}",
						},
						[14] = {
							CLSID = "{HB_ALE_40_30_60}",
						},
					},
					fuel = 5510.5,
					flare = 30,
					chaff = 120,
					gun = 100,
				},
			},
			["NAM - Escort - AIM-7E-2*4 - AIM7J*4 - FT*3 - CMPod"] = {
				country = {
					[1] = "USA",
				},
				attributes =  { },
				code_loadout =  { "NAM" },
				night = true,
				adverseWeather = true,
				range = 800000,
				firepower = 2,
				vCruise = 255,
				standoff = 46300,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{HB_ALE_40_30_60}",
					["num"] = 14,
				},
				[2] = {
					["CLSID"] = "{F4_SARGENT_TANK_370_GAL_R}",
					["num"] = 13,
				},
				[3] = {
					["CLSID"] = "{F4_SARGENT_TANK_370_GAL}",
					["num"] = 1,
				},
				[4] = {
					["CLSID"] = "{F4_SARGENT_TANK_600_GAL}",
					["num"] = 7,
				},
				[5] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 12,
				},
				[6] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 10,
				},
				[7] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 4,
				},
				[8] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 2,
				},
				[9] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 9,
				},
				[10] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 8,
				},
				[11] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 6,
				},
				[12] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 5,
				},
					},
					fuel = 5510.5,
					flare = 30,
					chaff = 120,
					gun = 100,
				},
			},
		},
		CAP = {
			["Revenge LR CAP -ECM - AIM-9Mx4 - AIM-7Mx3 - FTx3 - DP"] = {
				country = {
					[1] = "UK",
				},
				attributes =  { "LR CAP" },
				code_loadout =  { "Revenge" },
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1.5,
				vCruise = 245,
				vAttack = 246.66666666667,
				hCruise = 6096,
				hAttack = 6096,
				standoff = 36000,
				tStation = 1800,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL}",
						},
						[2] = {
							CLSID = "{AIM-9M}",
						},
						[4] = {
							CLSID = "{AIM-9M}",
						},
						[5] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[6] = {
							CLSID = "{HB_ALQ-131_ON_ADAPTER_IN_AERO7}",
						},
						[7] = {
							CLSID = "{F4_SARGENT_TANK_600_GAL}",
						},
						[8] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[9] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[10] = {
							CLSID = "{AIM-9M}",
						},
						[12] = {
							CLSID = "{AIM-9M}",
						},
						[13] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL_R}",
						},
						[14] = {
							CLSID = "{HB_ALE_40_30_60}",
						},
					},
					fuel = 5510.5,
					flare = 30,
					chaff = 120,
					gun = 100,
				},
			},
			["GTA AIR/AIR Low CAP -ECM - AIM-9Mx4 - AIM-7Mx3 - FTx3 - DP"] = {
				country = {
					[1] = "Turkey",
				},
				attributes =  { "low" },
				code_loadout =  { "HWITC" },
				adverseWeather = true,
				range = 450000,
				firepower = 1.5,
				vCruise = 245,
				vAttack = 246.66666666667,
				hCruise = 2000,
				hAttack = 2000,
				standoff = 36000,
				tStation = 1800,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL}",
						},
						[2] = {
							CLSID = "{AIM-9M}",
						},
						[4] = {
							CLSID = "{AIM-9M}",
						},
						[5] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[6] = {
							CLSID = "{HB_ALQ-131_ON_ADAPTER_IN_AERO7}",
						},
						[7] = {
							CLSID = "{F4_SARGENT_TANK_600_GAL}",
						},
						[8] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[9] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[10] = {
							CLSID = "{AIM-9M}",
						},
						[12] = {
							CLSID = "{AIM-9M}",
						},
						[13] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL_R}",
						},
						[14] = {
							CLSID = "{HB_ALE_40_30_60}",
						},
					},
					fuel = 5510.5,
					flare = 30,
					chaff = 120,
					gun = 100,
				},
			},
			["Crisis LR CAP Iran - AA - AIM-9Jx4 - AIM-7Ex4 - FTx3 - DP"] = {
				country = {
					[1] = "Iran",
				},
				attributes =  { },
				code_loadout =  { "IIW", "Crisis", "PG" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 2,
				vCruise = 245,
				vAttack = 246.66666666667,
				hCruise = 6096,
				hAttack = 6096,
				standoff = 36000,
				tStation = 1800,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL}",
						},
						[2] = {
							CLSID = "{AIM-9J}",
						},
						[4] = {
							CLSID = "{AIM-9J}",
						},
						[5] = {
							CLSID = "{HB_F4E_AIM-7E}",
						},
						[6] = {
							CLSID = "{HB_F4E_AIM-7E}",
						},
						[7] = {
							CLSID = "{F4_SARGENT_TANK_600_GAL}",
						},
						[8] = {
							CLSID = "{HB_F4E_AIM-7E}",
						},
						[9] = {
							CLSID = "{HB_F4E_AIM-7E}",
						},
						[10] = {
							CLSID = "{AIM-9J}",
						},
						[12] = {
							CLSID = "{AIM-9J}",
						},
						[13] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL_R}",
						},
						[14] = {
							CLSID = "{HB_ALE_40_30_60}",
						},
					},
					fuel = 5510.5,
					flare = 30,
					chaff = 120,
					gun = 100,
				},
			},
			["Crisis LR CAP -ECM - AIM-9Mx4 - AIM-7Mx3 - FTx3 - DP"] = {
				country = {
					[1] = "Turkey",
				},
				attributes =  { },
				code_loadout =  { "Crisis", "PG", "WOB" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1.5,
				vCruise = 245,
				vAttack = 246.66666666667,
				hCruise = 6096,
				hAttack = 6096,
				standoff = 36000,
				tStation = 1800,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL}",
						},
						[2] = {
							CLSID = "{AIM-9M}",
						},
						[4] = {
							CLSID = "{AIM-9M}",
						},
						[5] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[6] = {
							CLSID = "{HB_ALQ-131_ON_ADAPTER_IN_AERO7}",
						},
						[7] = {
							CLSID = "{F4_SARGENT_TANK_600_GAL}",
						},
						[8] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[9] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[10] = {
							CLSID = "{AIM-9M}",
						},
						[12] = {
							CLSID = "{AIM-9M}",
						},
						[13] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL_R}",
						},
						[14] = {
							CLSID = "{HB_ALE_40_30_60}",
						},
					},
					fuel = 5510.5,
					flare = 30,
					chaff = 120,
					gun = 100,
				},
			},
			["Cyprus Day, CAP -ECM - AIM-9Mx4 - AIM-7Mx3 - FTx3 - DP"] = {
				country = {
					[1] = "Turkey",
				},
				attributes =  { },
				code_loadout =  { "Cyprus", "WOB" },
				night = true,
				adverseWeather = true,
				range = 450000,
				firepower = 1.5,
				vCruise = 245,
				vAttack = 246.66666666667,
				hCruise = 6096,
				hAttack = 6096,
				standoff = 36000,
				tStation = 1800,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL}",
						},
						[2] = {
							CLSID = "{AIM-9M}",
						},
						[4] = {
							CLSID = "{AIM-9M}",
						},
						[5] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[6] = {
							CLSID = "{HB_ALQ-131_ON_ADAPTER_IN_AERO7}",
						},
						[7] = {
							CLSID = "{F4_SARGENT_TANK_600_GAL}",
						},
						[8] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[9] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[10] = {
							CLSID = "{AIM-9M}",
						},
						[12] = {
							CLSID = "{AIM-9M}",
						},
						[13] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL_R}",
						},
						[14] = {
							CLSID = "{HB_ALE_40_30_60}",
						},
					},
					fuel = 5510.5,
					flare = 30,
					chaff = 120,
					gun = 100,
				},
			},
			["GTA CAP -ECM - AIM-9Mx4 - AIM-7Mx3 - FTx3 - DP"] = {
				country = {
					[1] = "Turkey",
				},
				attributes =  { "medium" },
				code_loadout =  { "HWITC" },
				adverseWeather = true,
				range = 500000,
				firepower = 1.5,
				vCruise = 245,
				vAttack = 246.66666666667,
				hCruise = 4000,
				hAttack = 4000,
				standoff = 36000,
				tStation = 1800,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL}",
						},
						[2] = {
							CLSID = "{AIM-9M}",
						},
						[4] = {
							CLSID = "{AIM-9M}",
						},
						[5] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[6] = {
							CLSID = "{HB_ALQ-131_ON_ADAPTER_IN_AERO7}",
						},
						[7] = {
							CLSID = "{F4_SARGENT_TANK_600_GAL}",
						},
						[8] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[9] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[10] = {
							CLSID = "{AIM-9M}",
						},
						[12] = {
							CLSID = "{AIM-9M}",
						},
						[13] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL_R}",
						},
						[14] = {
							CLSID = "{HB_ALE_40_30_60}",
						},
					},
					fuel = 5510.5,
					flare = 30,
					chaff = 120,
					gun = 100,
				},
			},
			["NAM AA - CAP - AIM-7E-2*4 - AIM7J*4 - FT*3 - CMPod"] = {
				country = {
					[1] = "USA",
				},
				attributes =  { },
				code_loadout =  { "NAM" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 2,
				vCruise = 245,
				vAttack = 246.66666666667,
				hCruise = 6096,
				hAttack = 6096,
				standoff = 36000,
				tStation = 1800,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{HB_ALE_40_30_60}",
					["num"] = 14,
				},
				[2] = {
					["CLSID"] = "{F4_SARGENT_TANK_370_GAL_R}",
					["num"] = 13,
				},
				[3] = {
					["CLSID"] = "{F4_SARGENT_TANK_370_GAL}",
					["num"] = 1,
				},
				[4] = {
					["CLSID"] = "{F4_SARGENT_TANK_600_GAL}",
					["num"] = 7,
				},
				[5] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 12,
				},
				[6] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 10,
				},
				[7] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 4,
				},
				[8] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 2,
				},
				[9] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 9,
				},
				[10] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 8,
				},
				[11] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 6,
				},
				[12] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 5,
				},
					},
					fuel = 5510.5,
					flare = 30,
					chaff = 120,
					gun = 100,
				},
			},
		},
		SEAD = {
			["SEAD-Cyprus-LR - ECM - Shrikex2 - AIM-9Mx4 - AIM-7Mx3 - FTx3 - DP"] = {
				country = {
					[1] = "Turkey",
				},
				attributes =  { },
				code_loadout =  { "Cyprus", "WOC80", "WOB" },
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
							CLSID = "{F4_SARGENT_TANK_370_GAL}",
						},
						[2] = {
							CLSID = "{AIM-9M}",
						},
						[3] = {
							CLSID = "{LAU_34_AGM_45A_SWA}",
							settings = {
								NFP_rfgu_type = 1,
								EAS_bypass_ctrl = 1,
								["rf_upper_limit_ctrl_Mk22Mod2"] = 5200000000,
								["rf_lower_limit_ctrl_Mk22Mod2"] = 4800000000,
							},
						},
						[4] = {
							CLSID = "{AIM-9M}",
						},
						[5] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[6] = {
							CLSID = "{HB_ALQ-131_ON_ADAPTER_IN_AERO7}",
						},
						[7] = {
							CLSID = "{F4_SARGENT_TANK_600_GAL}",
						},
						[8] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[9] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[10] = {
							CLSID = "{AIM-9M}",
						},
						[11] = {
							CLSID = "{LAU_34_AGM_45A_SWA}",
							settings = {
								NFP_rfgu_type = 1,
								EAS_bypass_ctrl = 1,
								["rf_upper_limit_ctrl_Mk22Mod2"] = 5200000000,
								["rf_lower_limit_ctrl_Mk22Mod2"] = 4800000000,
							},
						},
						[12] = {
							CLSID = "{AIM-9M}",
						},
						[13] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL_R}",
						},
						[14] = {
							CLSID = "{HB_ALE_40_30_60}",
						},
					},
					fuel = 5510.5,
					flare = 30,
					chaff = 120,
					gun = 100,
				},
			},
			["Crisis SEAD - Iran - LR - Shrikex2 - AIM-9Jx4 - AIM-7Ex4 - FTx3 - DP"] = {
				country = {
					[1] = "Iran",
				},
				attributes =  { },
				code_loadout =  { "Crisis", "PG" },
				weaponType = "ASM",
				night = true,
				adverseWeather = true,
				range = 619000,
				firepower = 1,
				vCruise = 245,
				vAttack = 270,
				hCruise = 6752,
				hAttack = 6752,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL}",
						},
						[2] = {
							CLSID = "{AIM-9J}",
						},
						[3] = {
							CLSID = "{LAU_34_AGM_45A_SWA}",
							settings = {
								["NFP_VIS_DrawArgNo_56"] = 0,
								["NFP_VIS_DrawArgNo_55"] = 0,
								NFP_rfgu_type = 10,
								EAS_bypass_ctrl = 1,
								["rf_upper_limit_ctrl_Mk50"] = 6000000000,
								["rf_lower_limit_ctrl_Mk50"] = 2000000000,
							},
						},
						[4] = {
							CLSID = "{AIM-9J}",
						},
						[5] = {
							CLSID = "{HB_F4E_AIM-7E}",
						},
						[6] = {
							CLSID = "{HB_F4E_AIM-7E}",
						},
						[7] = {
							CLSID = "{F4_SARGENT_TANK_600_GAL}",
						},
						[8] = {
							CLSID = "{HB_F4E_AIM-7E}",
						},
						[9] = {
							CLSID = "{HB_F4E_AIM-7E}",
						},
						[10] = {
							CLSID = "{AIM-9J}",
						},
						[11] = {
							CLSID = "{LAU_34_AGM_45A_SWA}",
							settings = {
								["NFP_VIS_DrawArgNo_56"] = 0,
								["NFP_VIS_DrawArgNo_55"] = 0,
								NFP_rfgu_type = 10,
								EAS_bypass_ctrl = 1,
								["rf_upper_limit_ctrl_Mk50"] = 6000000000,
								["rf_lower_limit_ctrl_Mk50"] = 2000000000,
							},
						},
						[12] = {
							CLSID = "{AIM-9J}",
						},
						[13] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL_R}",
						},
						[14] = {
							CLSID = "{HB_ALE_40_30_60}",
						},
					},
					fuel = 5510.5,
					flare = 30,
					chaff = 120,
					gun = 100,
				},
			},
			["Crisis SEAD - LR - ECM - Shrikex2 - AIM-9Mx4 - AIM-7Mx3 - FTx3 - DP"] = {
				country = {
					[1] = "Turkey",
				},
				attributes =  { },
				code_loadout =  { "Crisis", "PG", "WOB" },
				weaponType = "ASM",
				night = true,
				adverseWeather = true,
				range = 686000,
				firepower = 1,
				vCruise = 240,
				vAttack = 270,
				hCruise = 8064,
				hAttack = 8064,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL}",
						},
						[2] = {
							CLSID = "{AIM-9M}",
						},
						[3] = {
							CLSID = "{LAU_34_AGM_45A_SWA}",
							settings = {
								NFP_rfgu_type = 1,
								EAS_bypass_ctrl = 1,
								["rf_upper_limit_ctrl_Mk22Mod2"] = 5200000000,
								["rf_lower_limit_ctrl_Mk22Mod2"] = 4800000000,
							},
						},
						[4] = {
							CLSID = "{AIM-9M}",
						},
						[5] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[6] = {
							CLSID = "{HB_ALQ-131_ON_ADAPTER_IN_AERO7}",
						},
						[7] = {
							CLSID = "{F4_SARGENT_TANK_600_GAL}",
						},
						[8] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[9] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[10] = {
							CLSID = "{AIM-9M}",
						},
						[11] = {
							CLSID = "{LAU_34_AGM_45A_SWA}",
							settings = {
								NFP_rfgu_type = 1,
								EAS_bypass_ctrl = 1,
								["rf_upper_limit_ctrl_Mk22Mod2"] = 5200000000,
								["rf_lower_limit_ctrl_Mk22Mod2"] = 4800000000,
							},
						},
						[12] = {
							CLSID = "{AIM-9M}",
						},
						[13] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL_R}",
						},
						[14] = {
							CLSID = "{HB_ALE_40_30_60}",
						},
					},
					fuel = 5510.5,
					flare = 30,
					chaff = 120,
					gun = 100,
				},
			},
			["IIW SEAD - Iran - LR - Shrikex2 - AIM-9Jx4 - AIM-7Ex4 - FTx3 - DP"] = {
				country = {
					[1] = "Iran",
				},
				attributes =  { },
				code_loadout =  { "IIW" },
				weaponType = "ASM",
				night = true,
				adverseWeather = true,
				range = 686000,
				firepower = 1,
				vCruise = 240,
				vAttack = 270,
				hCruise = 8064,
				hAttack = 8064,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL}",
						},
						[2] = {
							CLSID = "{AIM-9J}",
						},
						[3] = {
							CLSID = "{LAU_34_AGM_45A_SWA}",
							settings = {
								NFP_rfgu_type = 1,
								EAS_bypass_ctrl = 1,
								["rf_upper_limit_ctrl_Mk22Mod2"] = 5200000000,
								["rf_lower_limit_ctrl_Mk22Mod2"] = 4800000000,
							},
						},
						[4] = {
							CLSID = "{AIM-9J}",
						},
						[5] = {
							CLSID = "{HB_F4E_AIM-7E}",
						},
						[6] = {
							CLSID = "{HB_F4E_AIM-7E}",
						},
						[7] = {
							CLSID = "{F4_SARGENT_TANK_600_GAL}",
						},
						[8] = {
							CLSID = "{HB_F4E_AIM-7E}",
						},
						[9] = {
							CLSID = "{HB_F4E_AIM-7E}",
						},
						[10] = {
							CLSID = "{AIM-9J}",
						},
						[11] = {
							CLSID = "{LAU_34_AGM_45A_SWA}",
							settings = {
								NFP_rfgu_type = 1,
								EAS_bypass_ctrl = 1,
								["rf_upper_limit_ctrl_Mk22Mod2"] = 5200000000,
								["rf_lower_limit_ctrl_Mk22Mod2"] = 4800000000,
							},
						},
						[12] = {
							CLSID = "{AIM-9J}",
						},
						[13] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL_R}",
						},
						[14] = {
							CLSID = "{HB_ALE_40_30_60}",
						},
					},
					fuel = 5510.5,
					flare = 30,
					chaff = 120,
					gun = 100,
				},
			},
			["NAM AG - SEAD - AIM-9Jx4 - AIM-7E-2x4 - FT - AGM-45x4"] = {
				country = {
					[1] = "USA",
				},
				attributes =  { },
				code_loadout =  { "NAM" },
				weaponType = "ASM",
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 270,
				vAttack = 270,
				hCruise = 6096,
				hAttack = 6096,
				sortie_rate = 10,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 12,
				},
				[2] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 10,
				},
				[3] = {
					["CLSID"] = "{F4_SARGENT_TANK_600_GAL}",
					["num"] = 7,
				},
				[4] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 4,
				},
				[5] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 2,
				},
				[6] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 9,
				},
				[7] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 8,
				},
				[8] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 6,
				},
				[9] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 5,
				},
				[10] = {
					["CLSID"] = "{LAU_34_AGM_45A}",
					["num"] = 13,
					["settings"] = {
						["EAS_bypass_ctrl"] = 0,
						["NFP_rfgu_type"] = 5,
						["rf_lower_limit_ctrl_Mk25"] = 4000000000,
						["rf_upper_limit_ctrl_Mk25"] = 6000000000,
					},
				},
				[11] = {
					["CLSID"] = "{LAU_34_AGM_45A}",
					["num"] = 1,
					["settings"] = {
						["EAS_bypass_ctrl"] = 0,
						["NFP_rfgu_type"] = 5,
						["rf_lower_limit_ctrl_Mk25"] = 4000000000,
						["rf_upper_limit_ctrl_Mk25"] = 6000000000,
					},
				},
				[12] = {
					["CLSID"] = "{LAU_34_AGM_45A_SWA}",
					["num"] = 11,
					["settings"] = {
						["EAS_bypass_ctrl"] = 1,
						["NFP_rfgu_type"] = 5,
						["rf_lower_limit_ctrl_Mk25"] = 4000000000,
						["rf_upper_limit_ctrl_Mk25"] = 6000000000,
					},
				},
				[13] = {
					["CLSID"] = "{LAU_34_AGM_45A_SWA}",
					["num"] = 3,
					["settings"] = {
						["EAS_bypass_ctrl"] = 1,
						["NFP_rfgu_type"] = 5,
						["rf_lower_limit_ctrl_Mk25"] = 4000000000,
						["rf_upper_limit_ctrl_Mk25"] = 6000000000,
					},
				},
				[14] = {
					["CLSID"] = "{HB_ALE_40_30_60}",
					["num"] = 14,
				},
					},
					fuel = 5510.5,
					flare = 30,
					chaff = 120,
					gun = 100,
				},
			},
		},
		["Runway Attack"] = {
			["Runway attack  - AG -  Iran - LR - Mk-82HDx10 - AIM-9Jx4- AIM-7Ex3 - FTx2 - DP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				country = {
					[1] = "Iran",
				},
				attributes =  { "Runway" },
				code_loadout =  { "Crisis", "PG", "IIW" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 9100,
				hAttack = 200,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL}",
						},
						[2] = {
							CLSID = "{AIM-9J}",
						},
						[3] = {
							CLSID = "{HB_F4E_MK-82_Snakeye_2x_SWA}",
							settings = {
								["function_delay_ctrl_M905"] = 0,
								["NFP_VIS_DrawArgNo_56"] = 0,
								NFP_fuze_type_tail = "M905",
								NFP_fuze_type_nose = "M904E4",
								["NFP_VIS_DrawArgNo_57"] = 0,
								["function_delay_ctrl_M904E4"] = 0,
								["NFP_VIS_DrawArgNo_55"] = 0,
								["arm_delay_ctrl_M905"] = 4,
								["arm_delay_ctrl_M904E4"] = 2,
							},
						},
						[4] = {
							CLSID = "{AIM-9J}",
						},
						[5] = {
							CLSID = "{HB_F4E_AIM-7E}",
						},
						[6] = {
							CLSID = "{HB_F4E_AIM-7E}",
						},
						[7] = {
							CLSID = "{HB_F4E_MK-82_Snakeye_6x}",
							settings = {
								["function_delay_ctrl_M905"] = 0,
								["arm_delay_ctrl_M904E4"] = 2,
								["arm_delay_ctrl_M905"] = 4,
								["NFP_VIS_DrawArgNo_57"] = 0,
								NFP_fuze_type_tail = "M905",
								NFP_fuze_type_nose = "M904E4",
								["function_delay_ctrl_M904E4"] = 0,
							},
						},
						[8] = {
							CLSID = "{HB_F4E_AIM-7E}",
						},
						[9] = {
							CLSID = "{HB_F4E_AIM-7E}",
						},
						[10] = {
							CLSID = "{AIM-9J}",
						},
						[11] = {
							CLSID = "{HB_F4E_MK-82_Snakeye_2x_SWA}",
							settings = {
								["function_delay_ctrl_M905"] = 0,
								["arm_delay_ctrl_M904E4"] = 2,
								["arm_delay_ctrl_M905"] = 4,
								["NFP_VIS_DrawArgNo_57"] = 0,
								NFP_fuze_type_tail = "M905",
								NFP_fuze_type_nose = "M904E4",
								["function_delay_ctrl_M904E4"] = 0,
							},
						},
						[12] = {
							CLSID = "{AIM-9J}",
						},
						[13] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL_R}",
						},
						[14] = {
							CLSID = "{HB_ALE_40_30_60}",
						},
					},
					fuel = 5510.5,
					flare = 30,
					chaff = 120,
					gun = 100,
				},
			},
			["Runway attack  - AG - LR - ECM - Mk-82HDx10 - AIM-9Mx4- AIM-7Mx3 - FTx2 - DP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				country = {
					[1] = "Turkey",
				},
				attributes =  { "Runway" },
				code_loadout =  { "Crisis", "PG", "Cyprus", "WOB" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 9100,
				hAttack = 200,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL}",
						},
						[2] = {
							CLSID = "{AIM-9M}",
						},
						[3] = {
							CLSID = "{HB_F4E_MK-82_Snakeye_2x_SWA}",
							settings = {
								["function_delay_ctrl_M905"] = 0,
								["arm_delay_ctrl_M904E4"] = 2,
								["arm_delay_ctrl_M905"] = 4,
								["NFP_VIS_DrawArgNo_57"] = 0,
								NFP_fuze_type_tail = "M905",
								NFP_fuze_type_nose = "M904E4",
								["function_delay_ctrl_M904E4"] = 0,
							},
						},
						[4] = {
							CLSID = "{AIM-9M}",
						},
						[5] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[6] = {
							CLSID = "{HB_ALQ-131_ON_ADAPTER_IN_AERO7}",
						},
						[7] = {
							CLSID = "{HB_F4E_MK-82_Snakeye_6x}",
							settings = {
								["function_delay_ctrl_M905"] = 0,
								["arm_delay_ctrl_M904E4"] = 2,
								["arm_delay_ctrl_M905"] = 4,
								["NFP_VIS_DrawArgNo_57"] = 0,
								NFP_fuze_type_tail = "M905",
								NFP_fuze_type_nose = "M904E4",
								["function_delay_ctrl_M904E4"] = 0,
							},
						},
						[8] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[9] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[10] = {
							CLSID = "{AIM-9M}",
						},
						[11] = {
							CLSID = "{HB_F4E_MK-82_Snakeye_2x_SWA}",
							settings = {
								["function_delay_ctrl_M905"] = 0,
								["arm_delay_ctrl_M904E4"] = 2,
								["arm_delay_ctrl_M905"] = 4,
								["NFP_VIS_DrawArgNo_57"] = 0,
								NFP_fuze_type_tail = "M905",
								NFP_fuze_type_nose = "M904E4",
								["function_delay_ctrl_M904E4"] = 0,
							},
						},
						[12] = {
							CLSID = "{AIM-9M}",
						},
						[13] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL_R}",
						},
						[14] = {
							CLSID = "{HB_ALE_40_30_60}",
						},
					},
					fuel = 5510.5,
					flare = 30,
					chaff = 120,
					gun = 100,
				},
			},
			["Runway attack  - AG - LR - ECM - Durandalx12 - AIM-9Mx4- AIM-7Mx3 - FTx2 - DP"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				country = {
					[1] = "Turkey",
				},
				attributes =  { "Runway" },
				code_loadout =  { "Crisis", "PG", "WOB" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 9100,
				hAttack = 200,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL}",
						},
						[2] = {
							CLSID = "{AIM-9M}",
						},
						[3] = {
							CLSID = "{HB_F4E_BLU-107B_3x_SWA}",
						},
						[4] = {
							CLSID = "{AIM-9M}",
						},
						[5] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[6] = {
							CLSID = "{HB_ALQ-131_ON_ADAPTER_IN_AERO7}",
						},
						[7] = {
							CLSID = "{HB_F4E_BLU-107B_6x}",
						},
						[8] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[9] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[10] = {
							CLSID = "{AIM-9M}",
						},
						[11] = {
							CLSID = "{HB_F4E_BLU-107B_3x_SWA}",
						},
						[12] = {
							CLSID = "{AIM-9M}",
						},
						[13] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL_R}",
						},
						[14] = {
							CLSID = "{HB_ALE_40_30_60}",
						},
					},
					fuel = 5510.5,
					flare = 30,
					chaff = 120,
					gun = 100,
				},
			},
			["NAM AG - Runway Attack - AIM-7E-2*3 - AIM7J*4 - FT*2 - CMPod - ECM - Mk82 HD*10"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				country = {
					[1] = "USA",
				},
				attributes =  { "Runway" },
				code_loadout =  { "NAM" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 9100,
				hAttack = 200,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{HB_ALE_40_30_60}",
					["num"] = 14,
				},
				[2] = {
					["CLSID"] = "{F4_SARGENT_TANK_370_GAL_R}",
					["num"] = 13,
				},
				[3] = {
					["CLSID"] = "{F4_SARGENT_TANK_370_GAL}",
					["num"] = 1,
				},
				[4] = {
					["CLSID"] = "{HB_F4E_MK-82_Snakeye_6x}",
					["num"] = 7,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_M904E4"] = 4,
						["00_prfx_function_delay_ctrl_M904E4"] = 0,
						["01_prfx_arm_delay_ctrl_M905"] = 4,
						["01_prfx_function_delay_ctrl_M905"] = 0,
						["NFP_PRESID"] = "MDRN_B_A_GPLD",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
					},
				},
				[5] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 12,
				},
				[6] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 10,
				},
				[7] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 4,
				},
				[8] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 2,
				},
				[9] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 9,
				},
				[10] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 8,
				},
				[11] = {
					["CLSID"] = "{HB_ALQ-131_ON_ADAPTER_IN_AERO7}",
					["num"] = 6,
				},
				[12] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 5,
				},
				[13] = {
					["CLSID"] = "{HB_F4E_MK-82_Snakeye_2x_SWA}",
					["num"] = 11,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_M904E4"] = 4,
						["00_prfx_function_delay_ctrl_M904E4"] = 0,
						["01_prfx_arm_delay_ctrl_M905"] = 4,
						["01_prfx_function_delay_ctrl_M905"] = 0,
						["NFP_PRESID"] = "MDRN_B_A_GPLD",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
					},
				},
				[14] = {
					["CLSID"] = "{HB_F4E_MK-82_Snakeye_2x_SWA}",
					["num"] = 3,
					["settings"] = {
						["00_prfx_arm_delay_ctrl_M904E4"] = 4,
						["00_prfx_function_delay_ctrl_M904E4"] = 0,
						["01_prfx_arm_delay_ctrl_M905"] = 4,
						["01_prfx_function_delay_ctrl_M905"] = 0,
						["NFP_PRESID"] = "MDRN_B_A_GPLD",
						["NFP_PRESVER"] = 2,
						["NFP_VIS_DrawArgNo_57"] = 0,
						["NFP_fuze_type_nose"] = "M904E4",
						["NFP_fuze_type_tail"] = "M905",
					},
				},
					},
					fuel = 5510.5,
					flare = 30,
					chaff = 120,
					gun = 100,
				},
			},
		},
		["Fighter Sweep"] = {
			["GTA AIR/AIR FS LR - AIM-9Mx4 - AIM-7Mx4 - FTx3 - DP"] = {
				country = {
					[1] = "Turkey",
				},
				attributes =  { },
				code_loadout =  { "HWITC" },
				adverseWeather = true,
				range = 500000,
				firepower = 2,
				vCruise = 255.83333333333,
				vAttack = 265.83333333333,
				hCruise = 2753.6,
				hAttack = 2753.6,
				standoff = 46300,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL}",
						},
						[2] = {
							CLSID = "{AIM-9M}",
						},
						[4] = {
							CLSID = "{AIM-9M}",
						},
						[5] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[6] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[7] = {
							CLSID = "{F4_SARGENT_TANK_600_GAL}",
						},
						[8] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[9] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[10] = {
							CLSID = "{AIM-9M}",
						},
						[12] = {
							CLSID = "{AIM-9M}",
						},
						[13] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL_R}",
						},
						[14] = {
							CLSID = "{HB_ALE_40_30_60}",
						},
					},
					fuel = 5510.5,
					flare = 30,
					chaff = 120,
					gun = 100,
				},
			},
			["Crisis FS LR -ECM - AIM-9Mx4 - AIM-7Mx3 - FTx3 - DP"] = {
				country = {
					[1] = "Turkey",
					[2] = "UK",
				},
				attributes =  { },
				code_loadout =  { "Crisis", "PG", "Revenge", "WOB" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1.5,
				vCruise = 245,
				vAttack = 245,
				hCruise = 9753.6,
				hAttack = 9753.6,
				standoff = 46300,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL}",
						},
						[2] = {
							CLSID = "{AIM-9M}",
						},
						[4] = {
							CLSID = "{AIM-9M}",
						},
						[5] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[6] = {
							CLSID = "{HB_ALQ-131_ON_ADAPTER_IN_AERO7}",
						},
						[7] = {
							CLSID = "{F4_SARGENT_TANK_600_GAL}",
						},
						[8] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[9] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[10] = {
							CLSID = "{AIM-9M}",
						},
						[12] = {
							CLSID = "{AIM-9M}",
						},
						[13] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL_R}",
						},
						[14] = {
							CLSID = "{HB_ALE_40_30_60}",
						},
					},
					fuel = 5510.5,
					flare = 30,
					chaff = 120,
					gun = 100,
				},
			},
			["Cyprus FW LR -ECM - AIM-9Mx4 - AIM-7Mx3 - FTx3 - DP"] = {
				country = {
					[1] = "Turkey",
				},
				attributes =  { },
				code_loadout =  { "Cyprus" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1.5,
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
							CLSID = "{F4_SARGENT_TANK_370_GAL}",
						},
						[2] = {
							CLSID = "{AIM-9M}",
						},
						[4] = {
							CLSID = "{AIM-9M}",
						},
						[5] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[6] = {
							CLSID = "{HB_ALQ-131_ON_ADAPTER_IN_AERO7}",
						},
						[7] = {
							CLSID = "{F4_SARGENT_TANK_600_GAL}",
						},
						[8] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[9] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[10] = {
							CLSID = "{AIM-9M}",
						},
						[12] = {
							CLSID = "{AIM-9M}",
						},
						[13] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL_R}",
						},
						[14] = {
							CLSID = "{HB_ALE_40_30_60}",
						},
					},
					fuel = 5510.5,
					flare = 30,
					chaff = 120,
					gun = 100,
				},
			},
			["Crisis FS Iran - AA - AIM-9Jx4 - AIM-7Ex4 - FTx3 - DP"] = {
				country = {
					[1] = "Iran",
				},
				attributes =  { },
				code_loadout =  { "Crisis", "PG", "IIW" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 2,
				vCruise = 245,
				vAttack = 245,
				hCruise = 9753.6,
				hAttack = 9753.6,
				standoff = 46300,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL}",
						},
						[2] = {
							CLSID = "{AIM-9J}",
						},
						[4] = {
							CLSID = "{AIM-9J}",
						},
						[5] = {
							CLSID = "{HB_F4E_AIM-7E}",
						},
						[6] = {
							CLSID = "{HB_F4E_AIM-7E}",
						},
						[7] = {
							CLSID = "{F4_SARGENT_TANK_600_GAL}",
						},
						[8] = {
							CLSID = "{HB_F4E_AIM-7E}",
						},
						[9] = {
							CLSID = "{HB_F4E_AIM-7E}",
						},
						[10] = {
							CLSID = "{AIM-9J}",
						},
						[12] = {
							CLSID = "{AIM-9J}",
						},
						[13] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL_R}",
						},
						[14] = {
							CLSID = "{HB_ALE_40_30_60}",
						},
					},
					fuel = 5510.5,
					flare = 30,
					chaff = 120,
					gun = 100,
				},
			},
			["NAM AA - Fighter Sweep - AIM-7E-2*4 - AIM7J*4 - FT*3 - CMPod"] = {
				country = {
					[1] = "USA",
				},
				attributes =  { },
				code_loadout =  { "NAM" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1.5,
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
					["CLSID"] = "{HB_ALE_40_30_60}",
					["num"] = 14,
				},
				[2] = {
					["CLSID"] = "{F4_SARGENT_TANK_370_GAL_R}",
					["num"] = 13,
				},
				[3] = {
					["CLSID"] = "{F4_SARGENT_TANK_370_GAL}",
					["num"] = 1,
				},
				[4] = {
					["CLSID"] = "{F4_SARGENT_TANK_600_GAL}",
					["num"] = 7,
				},
				[5] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 12,
				},
				[6] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 10,
				},
				[7] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 4,
				},
				[8] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 2,
				},
				[9] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 9,
				},
				[10] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 8,
				},
				[11] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 6,
				},
				[12] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 5,
				},
					},
					fuel = 5510.5,
					flare = 30,
					chaff = 120,
					gun = 100,
				},
			},
		},
		Intercept = {
			["Crisis - Iran - AA - LR - AIM-9Jx4 - AIM-7Ex4 - FTx3 - DP"] = {
				country = {
					[1] = "Iran",
				},
				attributes =  { },
				code_loadout =  { "IIW", "Crisis", "PG" },
				night = true,
				adverseWeather = true,
				range = 400000,
				firepower = 1,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL}",
						},
						[2] = {
							CLSID = "{AIM-9J}",
						},
						[4] = {
							CLSID = "{AIM-9J}",
						},
						[5] = {
							CLSID = "{HB_F4E_AIM-7E}",
						},
						[6] = {
							CLSID = "{HB_F4E_AIM-7E}",
						},
						[7] = {
							CLSID = "{F4_SARGENT_TANK_600_GAL}",
						},
						[8] = {
							CLSID = "{HB_F4E_AIM-7E}",
						},
						[9] = {
							CLSID = "{HB_F4E_AIM-7E}",
						},
						[10] = {
							CLSID = "{AIM-9J}",
						},
						[12] = {
							CLSID = "{AIM-9J}",
						},
						[13] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL_R}",
						},
						[14] = {
							CLSID = "{HB_ALE_40_30_60}",
						},
					},
					fuel = 5510.5,
					flare = 30,
					chaff = 120,
					gun = 100,
				},
			},
			["GTA AIR/AIR -SR - AIM-9Mx4 - AIM-7Mx4 - FTx2 - DP"] = {
				country = {
					[1] = "Turkey",
				},
				attributes =  { },
				code_loadout =  { "HWITC" },
				adverseWeather = true,
				range = 400000,
				firepower = 1,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL}",
						},
						[2] = {
							CLSID = "{AIM-9M}",
						},
						[4] = {
							CLSID = "{AIM-9M}",
						},
						[5] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[6] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[8] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[9] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[10] = {
							CLSID = "{AIM-9M}",
						},
						[12] = {
							CLSID = "{AIM-9M}",
						},
						[13] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL_R}",
						},
						[14] = {
							CLSID = "{HB_ALE_40_30_60}",
						},
					},
					fuel = 5510.5,
					flare = 30,
					chaff = 120,
					gun = 100,
				},
			},
			["Crisis AA - SR -ECM - AIM-9Mx4 - AIM-7Mx3 - FTx2 - DP"] = {
				country = {
					[1] = "Turkey",
					[2] = "UK",
				},
				attributes =  { },
				code_loadout =  { "Crisis", "PG", "Revenge", "WOB" },
				night = true,
				adverseWeather = true,
				range = 400000,
				firepower = 1,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL}",
						},
						[2] = {
							CLSID = "{AIM-9M}",
						},
						[4] = {
							CLSID = "{AIM-9M}",
						},
						[5] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[6] = {
							CLSID = "{HB_ALQ-131_ON_ADAPTER_IN_AERO7}",
						},
						[8] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[9] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[10] = {
							CLSID = "{AIM-9M}",
						},
						[12] = {
							CLSID = "{AIM-9M}",
						},
						[13] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL_R}",
						},
						[14] = {
							CLSID = "{HB_ALE_40_30_60}",
						},
					},
					fuel = 5510.5,
					flare = 30,
					chaff = 120,
					gun = 100,
				},
			},
			["Cyprus SR -ECM - AIM-9Mx4 - AIM-7Mx3 - FTx2 - DP"] = {
				country = {
					[1] = "Turkey",
				},
				attributes =  { },
				code_loadout =  { "Cyprus" },
				night = true,
				adverseWeather = true,
				range = 400000,
				firepower = 1,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL}",
						},
						[2] = {
							CLSID = "{AIM-9M}",
						},
						[4] = {
							CLSID = "{AIM-9M}",
						},
						[5] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[6] = {
							CLSID = "{HB_ALQ-131_ON_ADAPTER_IN_AERO7}",
						},
						[8] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[9] = {
							CLSID = "{HB_F4E_AIM-7M}",
						},
						[10] = {
							CLSID = "{AIM-9M}",
						},
						[12] = {
							CLSID = "{AIM-9M}",
						},
						[13] = {
							CLSID = "{F4_SARGENT_TANK_370_GAL_R}",
						},
						[14] = {
							CLSID = "{HB_ALE_40_30_60}",
						},
					},
					fuel = 5510.5,
					flare = 30,
					chaff = 120,
					gun = 100,
				},
			},
			["NAM AA - Intercept - AIM-9Jx4 - AIM-7E-2x4 - FT"] = {
				country = {
					[1] = "USA",
				},
				attributes =  { },
				code_loadout =  { "NAM" },
				night = true,
				adverseWeather = true,
				range = 400000,
				firepower = 1,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
				[1] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 12,
				},
				[2] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 10,
				},
				[3] = {
					["CLSID"] = "{F4_SARGENT_TANK_600_GAL}",
					["num"] = 7,
				},
				[4] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 4,
				},
				[5] = {
					["CLSID"] = "{AIM-9J}",
					["num"] = 2,
				},
				[6] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 9,
				},
				[7] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 8,
				},
				[8] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 6,
				},
				[9] = {
					["CLSID"] = "{HB_F4E_AIM-7E-2}",
					["num"] = 5,
				},
				[10] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 13,
				},
				[11] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 1,
				},
				[14] = {
					["CLSID"] = "{HB_ALE_40_30_60}",
					["num"] = 14,
				},
					},
					fuel = 5510.5,
					flare = 30,
					chaff = 120,
					gun = 100,
				},
			},
		},
	},
	["F-4E"] = {
		Strike = {
			["Crisis Mk-82*6, AIM-7M*4, Fuel*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "Structure" },
				code_loadout =  { "IIW", "Crisis", "PG" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
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
							CLSID = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
						},
						[2] = {
							CLSID = "{60CC734F-0AFA-4E2E-82B8-93B941AB11CF}",
						},
						[3] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[4] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[5] = {
							CLSID = "{8B9E3FD0-F034-4A07-B6CE-C269884CC71B}",
						},
						[6] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[7] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[8] = {
							CLSID = "{60CC734F-0AFA-4E2E-82B8-93B941AB11CF}",
						},
						[9] = {
							CLSID = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
						},
					},
					fuel = "4864",
					flare = 30,
					chaff = 60,
					gun = 100,
				},
			},
			[" Cyprus Strike Heavy Mk84*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Structure", "Bridge" },
				code_loadout =  { "Cyprus", "WOC80" },
				weaponType = "Bombs",
				expend = "All",
								range = 500000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 5486.4,
				hAttack = 300,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
						},
						[2] = {
							CLSID = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
						},
						[3] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[4] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[5] = {
							CLSID = "{8B9E3FD0-F034-4A07-B6CE-C269884CC71B}",
						},
						[6] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[7] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[8] = {
							CLSID = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
						},
						[9] = {
							CLSID = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
						},
					},
					fuel = "4864",
					flare = 30,
					chaff = 60,
					gun = 100,
				},
				AGAS_OffsetAngle = 25,
				AGAS_PopAlt = 500,
				AGAS_ClimbAngle = 35,
			},
			["Crisis Strike Heavy Mk84*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Structure" },
				code_loadout =  { "IIW", "Crisis", "PG" },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
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
							CLSID = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
						},
						[2] = {
							CLSID = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
						},
						[3] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[4] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[5] = {
							CLSID = "{8B9E3FD0-F034-4A07-B6CE-C269884CC71B}",
						},
						[6] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[7] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[8] = {
							CLSID = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
						},
						[9] = {
							CLSID = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
						},
					},
					fuel = "4864",
					flare = 30,
					chaff = 60,
					gun = 100,
				},
			},
			["Cyprus Rockets, AIM-7M*4, Fuel*2"] = {
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { },
				weaponType = "Rockets",
				expend = "All",
								range = 500000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 5486.4,
				hAttack = 1572,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
						},
						[2] = {
							CLSID = "{F3EFE0AB-E91A-42D8-9CA2-B63C91ED570A}",
						},
						[3] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[4] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[5] = {
							CLSID = "{8B9E3FD0-F034-4A07-B6CE-C269884CC71B}",
						},
						[6] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[7] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[8] = {
							CLSID = "{F3EFE0AB-E91A-42D8-9CA2-B63C91ED570A}",
						},
						[9] = {
							CLSID = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
						},
					},
					fuel = "4864",
					flare = 30,
					chaff = 60,
					gun = 100,
				},
			},
			["Turkey Cyprus AG - Rockeye*6"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "frontline" },
				code_loadout =  { },
				weaponType = "Bombs",
				expend = "All",
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
							CLSID = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
						},
						[2] = {
							CLSID = "{B83CB620-5BBE-4BEA-910C-EB605A327EF9}",
						},
						[3] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[4] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[5] = {
							CLSID = "{8B9E3FD0-F034-4A07-B6CE-C269884CC71B}",
						},
						[6] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[7] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[8] = {
							CLSID = "{B83CB620-5BBE-4BEA-910C-EB605A327EF9}",
						},
						[9] = {
							CLSID = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
						},
					},
					fuel = "4864",
					flare = 30,
					chaff = 60,
					gun = 100,
				},
			},
			["GTA CAS1 AGM-65K*4,AIM-7*2,Fuel*2,ECM"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "HWITC" },
				weaponType = "ASM",
				expend = "Auto",
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 3486.4,
				hAttack = 2572,
				standoff = 2000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
						},
						[2] = {
							CLSID = "{D7670BC7-881B-4094-906C-73879CF7EB28}",
						},
						[3] = {
							CLSID = "{6D21ECEA-F85B-4E8D-9D51-31DC9B8AA4EF}",
						},
						[4] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[6] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[8] = {
							CLSID = "{D7670BC7-881B-4094-906C-73879CF7EB27}",
						},
						[9] = {
							CLSID = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
						},
					},
					fuel = "4864",
					flare = 30,
					chaff = 60,
					gun = 100,
				},
			},
			["Crisis Strike Mk20*6, AIM-7*2, AIM-9*4, ECM, FT"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft" },
				code_loadout =  { },
				weaponType = "Bombs",
				expend = "All",
				attackType = "Dive",
								range = 600000,
				firepower = 1,
				vCruise = 250,
				vAttack = 300,
				hCruise = 5486.4,
				hAttack = 4572,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{B83CB620-5BBE-4BEA-910C-EB605A327EF9}",
						},
						[2] = {
							CLSID = "{9DDF5297-94B9-42FC-A45E-6E316121CD85}",
						},
						[3] = {
							CLSID = "{6D21ECEA-F85B-4E8D-9D51-31DC9B8AA4EF}",
						},
						[4] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[5] = {
							CLSID = "{8B9E3FD0-F034-4A07-B6CE-C269884CC71B}",
						},
						[6] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[8] = {
							CLSID = "{9DDF5297-94B9-42FC-A45E-6E316121CD85}",
						},
						[9] = {
							CLSID = "{B83CB620-5BBE-4BEA-910C-EB605A327EF9}",
						},
					},
					fuel = "4864",
					flare = 30,
					chaff = 60,
					gun = 100,
				},
			},
			["Cyprus Mk-82*6, AIM-7M*4, Fuel*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM", "frontline" },
				code_loadout =  { "Cyprus", "WOC80" },
				weaponType = "Bombs",
				expend = "All",
								range = 500000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 5486.4,
				hAttack = 300,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
						},
						[2] = {
							CLSID = "{60CC734F-0AFA-4E2E-82B8-93B941AB11CF}",
						},
						[3] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[4] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[5] = {
							CLSID = "{8B9E3FD0-F034-4A07-B6CE-C269884CC71B}",
						},
						[6] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[7] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[8] = {
							CLSID = "{60CC734F-0AFA-4E2E-82B8-93B941AB11CF}",
						},
						[9] = {
							CLSID = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
						},
					},
					fuel = "4864",
					flare = 30,
					chaff = 60,
					gun = 100,
				},
				AGAS_OffsetAngle = 25,
				AGAS_PopAlt = 500,
				AGAS_ClimbAngle = 35,
			},
			["GTA CAS2 Mk20*6,AIM-7*2,Fuel*2,ECM"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { },
				weaponType = "Bombs",
				expend = "All",
								range = 500000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 3486.4,
				hAttack = 2572,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
						},
						[2] = {
							CLSID = "{B83CB620-5BBE-4BEA-910C-EB605A327EF9}",
						},
						[3] = {
							CLSID = "{6D21ECEA-F85B-4E8D-9D51-31DC9B8AA4EF}",
						},
						[4] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[6] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[8] = {
							CLSID = "{B83CB620-5BBE-4BEA-910C-EB605A327EF9}",
						},
						[9] = {
							CLSID = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
						},
					},
					fuel = "4864",
					flare = 30,
					chaff = 60,
					gun = 100,
				},
			},
			["GTA strike Mk-82*6,AIM-7*2,Fuel*2,ECM"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "Bridge", "soft", "Parked Aircraft", "Structure", "SAM" },
				code_loadout =  { "HWITC" },
				weaponType = "Bombs",
				expend = "All",
								range = 500000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 3486.4,
				hAttack = 2572,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
						},
						[2] = {
							CLSID = "{60CC734F-0AFA-4E2E-82B8-93B941AB11CF}",
						},
						[3] = {
							CLSID = "{6D21ECEA-F85B-4E8D-9D51-31DC9B8AA4EF}",
						},
						[4] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[6] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[8] = {
							CLSID = "{60CC734F-0AFA-4E2E-82B8-93B941AB11CF}",
						},
						[9] = {
							CLSID = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
						},
					},
					fuel = "4864",
					flare = 30,
					chaff = 60,
					gun = 100,
				},
			},
			["Crisis Strike AGM-65D*4, AIM-7M*2, ECM, FT*3"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "SAM", "soft" },
				code_loadout =  { "IIW", "Crisis", "PG" },
				weaponType = "ASM",
				expend = "Auto",
				attackType = "Dive",
								range = 600000,
				firepower = 1,
				vCruise = 250,
				vAttack = 300,
				hCruise = 5486.4,
				hAttack = 4572,
				standoff = 15000,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
						},
						[2] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98452}",
						},
						[3] = {
							CLSID = "{6D21ECEA-F85B-4E8D-9D51-31DC9B8AA4EF}",
						},
						[4] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[5] = {
							CLSID = "{8B9E3FD0-F034-4A07-B6CE-C269884CC71B}",
						},
						[6] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[8] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98453}",
						},
						[9] = {
							CLSID = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
						},
					},
					fuel = "4864",
					flare = 30,
					chaff = 60,
					gun = 100,
				},
			},
			["Turkey Cyprus AG - AGM65D*4"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "SAM", "frontline" },
				code_loadout =  { "Cyprus", "WOC80" },
				weaponType = "ASM",
				expend = "Auto",
				night = true,
				adverseWeather = true,
				range = 900000,
				firepower = 1,
				vCruise = 215,
				vAttack = 300,
				hCruise = 6096,
				hAttack = 300,
				standoff = 10000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
						},
						[2] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98452}",
						},
						[3] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[4] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[5] = {
							CLSID = "{8B9E3FD0-F034-4A07-B6CE-C269884CC71B}",
						},
						[6] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[7] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[8] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98453}",
						},
						[9] = {
							CLSID = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
						},
					},
					fuel = "4864",
					flare = 30,
					chaff = 60,
					gun = 100,
				},
				AGAS_OffsetAngle = 25,
				AGAS_ClimbAngle = 35,
				AGAS_PopAlt = 500,
				AGAS_AttackDist = 5000,
			},
			["IIW Rockets, AIM-7M*4, Fuel*2"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "soft", "Parked Aircraft", "SAM" },
				code_loadout =  { "IIW" },
				weaponType = "Rockets",
				expend = "All",
				attackType = "Dive",
								range = 500000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 5486.4,
				hAttack = 1572,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
						},
						[2] = {
							CLSID = "{F3EFE0AB-E91A-42D8-9CA2-B63C91ED570A}",
						},
						[3] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[4] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[5] = {
							CLSID = "{8B9E3FD0-F034-4A07-B6CE-C269884CC71B}",
						},
						[6] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[7] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[8] = {
							CLSID = "{F3EFE0AB-E91A-42D8-9CA2-B63C91ED570A}",
						},
						[9] = {
							CLSID = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
						},
					},
					fuel = "4864",
					flare = 30,
					chaff = 60,
					gun = 100,
				},
			},
		},
		["Anti-ship Strike"] = {
			["Anti-Ship Strike AGM-65K*4,AIM-7M*4,Fuel*3"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "ship" },
				code_loadout =  { "Crisis", "PG" },
				weaponType = "ASM",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 900000,
				firepower = 1,
				vCruise = 250,
				vAttack = 300,
				hCruise = 6096,
				hAttack = 6096,
				standoff = 10000,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
						},
						[2] = {
							CLSID = "{D7670BC7-881B-4094-906C-73879CF7EB28}",
						},
						[3] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[4] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[5] = {
							CLSID = "{8B9E3FD0-F034-4A07-B6CE-C269884CC71B}",
						},
						[6] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[7] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[8] = {
							CLSID = "{D7670BC7-881B-4094-906C-73879CF7EB27}",
						},
						[9] = {
							CLSID = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
						},
					},
					fuel = "4864",
					flare = 30,
					chaff = 60,
					gun = 100,
				},
			},
			["Anti-Ship Strike Turkey Cyprus AG - AGM65D*4"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = false,
				},
				attributes =  { "ship" },
				code_loadout =  { "Cyprus" },
				weaponType = "ASM",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 450000,
				firepower = 1,
				vCruise = 250,
				vAttack = 300,
				hCruise = 6096,
				hAttack = 6096,
				standoff = 10000,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
						},
						[2] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98452}",
						},
						[3] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[4] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[5] = {
							CLSID = "{8B9E3FD0-F034-4A07-B6CE-C269884CC71B}",
						},
						[6] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[7] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[8] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98453}",
						},
						[9] = {
							CLSID = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
						},
					},
					fuel = "4864",
					flare = 30,
					chaff = 60,
					gun = 100,
				},
			},
		},
		Escort = {
			["Crisis AIM-9M*4, AIM-7M*4, Fuel*3"] = {
				attributes =  { },
				code_loadout =  { "IIW", "Crisis", "PG", "Revenge" },
				night = true,
				adverseWeather = true,
				range = 800000,
				firepower = 1,
				vCruise = 255,
				standoff = 46300,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
						},
						[2] = {
							CLSID = "{9DDF5297-94B9-42FC-A45E-6E316121CD85}",
						},
						[3] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[4] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[5] = {
							CLSID = "{8B9E3FD0-F034-4A07-B6CE-C269884CC71B}",
						},
						[6] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[7] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[8] = {
							CLSID = "{9DDF5297-94B9-42FC-A45E-6E316121CD85}",
						},
						[9] = {
							CLSID = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
						},
					},
					fuel = "4864",
					flare = 30,
					chaff = 60,
					gun = 100,
				},
			},
			["GTA AIR/AIR AIM-9*4,AIM-7*4"] = {
				attributes =  { },
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 255.83333333333,
				standoff = 46300,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[2] = {
							CLSID = "{9DDF5297-94B9-42FC-A45E-6E316121CD85}",
						},
						[3] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[4] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[6] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[7] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[8] = {
							CLSID = "{9DDF5297-94B9-42FC-A45E-6E316121CD85}",
						},
					},
					fuel = "4864",
					flare = 30,
					chaff = 60,
					gun = 100,
				},
			},
			["Cyprus AIM-9M*4, AIM-7M*4, Fuel*3"] = {
				attributes =  { },
				code_loadout =  { "Cyprus" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 255.83333333333,
				standoff = 46300,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
						},
						[2] = {
							CLSID = "{F4-2-AIM9L}",
						},
						[3] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[4] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[5] = {
							CLSID = "{8B9E3FD0-F034-4A07-B6CE-C269884CC71B}",
						},
						[6] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[7] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[8] = {
							CLSID = "{F4-2-AIM9L}",
						},
						[9] = {
							CLSID = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
						},
					},
					fuel = "4864",
					flare = 30,
					chaff = 60,
					gun = 100,
				},
			},
		},
		CAP = {
			["Revenge Day, AIM-7M*4,AIM-9M*4,Fuel"] = {
				attributes =  { "LR CAP" },
				code_loadout =  { "Revenge" },
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 245,
				vAttack = 246.66666666667,
				hCruise = 6096,
				hAttack = 6096,
				standoff = 36000,
				tStation = 1800,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
						},
						[2] = {
							CLSID = "{9DDF5297-94B9-42FC-A45E-6E316121CD85}",
						},
						[3] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[4] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[5] = {
							CLSID = "{8B9E3FD0-F034-4A07-B6CE-C269884CC71B}",
						},
						[6] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[7] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[8] = {
							CLSID = "{9DDF5297-94B9-42FC-A45E-6E316121CD85}",
						},
						[9] = {
							CLSID = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
						},
					},
					fuel = "4864",
					flare = 30,
					chaff = 60,
					gun = 100,
				},
			},
			["Crisis Day, AIM-7M*4,AIM-9M*4,Fuel"] = {
				attributes =  { },
				code_loadout =  { "IIW", "Crisis", "PG" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 245,
				vAttack = 246.66666666667,
				hCruise = 6096,
				hAttack = 6096,
				standoff = 36000,
				tStation = 1800,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
						},
						[2] = {
							CLSID = "{9DDF5297-94B9-42FC-A45E-6E316121CD85}",
						},
						[3] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[4] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[5] = {
							CLSID = "{8B9E3FD0-F034-4A07-B6CE-C269884CC71B}",
						},
						[6] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[7] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[8] = {
							CLSID = "{9DDF5297-94B9-42FC-A45E-6E316121CD85}",
						},
						[9] = {
							CLSID = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
						},
					},
					fuel = "4864",
					flare = 30,
					chaff = 60,
					gun = 100,
				},
			},
			["Cyprus Day, AIM-7M*4,AIM-9M*4,Fuel"] = {
				attributes =  { },
				code_loadout =  { "Cyprus" },
				night = true,
				adverseWeather = true,
				range = 450000,
				firepower = 1,
				vCruise = 245,
				vAttack = 246.66666666667,
				hCruise = 6096,
				hAttack = 6096,
				standoff = 36000,
				tStation = 1800,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
						},
						[2] = {
							CLSID = "{F4-2-AIM9L}",
						},
						[3] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[4] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[5] = {
							CLSID = "{8B9E3FD0-F034-4A07-B6CE-C269884CC71B}",
						},
						[6] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[7] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[8] = {
							CLSID = "{F4-2-AIM9L}",
						},
						[9] = {
							CLSID = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
						},
					},
					fuel = "4864",
					flare = 30,
					chaff = 60,
					gun = 100,
				},
			},
			["GTA AIR/AIR Medium AIM-9*4,AIM-7*4"] = {
				attributes =  { "medium" },
				code_loadout =  { "HWITC" },
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 245,
				vAttack = 246.66666666667,
				hCruise = 4000,
				hAttack = 4000,
				standoff = 36000,
				tStation = 1800,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[2] = {
							CLSID = "{9DDF5297-94B9-42FC-A45E-6E316121CD85}",
						},
						[3] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[4] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[6] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[7] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[8] = {
							CLSID = "{9DDF5297-94B9-42FC-A45E-6E316121CD85}",
						},
					},
					fuel = "4864",
					flare = 30,
					chaff = 60,
					gun = 100,
				},
			},
			["GTA AIR/AIR Low AIM-9*4,AIM-7*4"] = {
				attributes =  { "low" },
				code_loadout =  { "HWITC" },
				adverseWeather = true,
				range = 450000,
				firepower = 1,
				vCruise = 245,
				vAttack = 246.66666666667,
				hCruise = 2000,
				hAttack = 2000,
				standoff = 36000,
				tStation = 1800,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[2] = {
							CLSID = "{9DDF5297-94B9-42FC-A45E-6E316121CD85}",
						},
						[3] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[4] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[6] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[7] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[8] = {
							CLSID = "{9DDF5297-94B9-42FC-A45E-6E316121CD85}",
						},
					},
					fuel = "4864",
					flare = 30,
					chaff = 60,
					gun = 100,
				},
			},
		},
		SEAD = {
			["SEAD-Cyprus-AGM45*2_AGM-65D*4_AIM7*3_ECM - FT"] = {
				attributes =  { },
				code_loadout =  { "Cyprus", "WOC80" },
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
							CLSID = "{3E6B632D-65EB-44D2-9501-1C2D04515405}",
						},
						[2] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98452}",
						},
						[3] = {
							CLSID = "{6D21ECEA-F85B-4E8D-9D51-31DC9B8AA4EF}",
						},
						[4] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[5] = {
							CLSID = "{8B9E3FD0-F034-4A07-B6CE-C269884CC71B}",
						},
						[6] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[7] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[8] = {
							CLSID = "{E6A6262A-CA08-4B3D-B030-E1A993B98453}",
						},
						[9] = {
							CLSID = "{3E6B632D-65EB-44D2-9501-1C2D04515405}",
						},
					},
					fuel = "4864",
					flare = 30,
					chaff = 60,
					gun = 100,
				},
			},
			["Crisis AGM-45*4, AIM-7M*2, Fuel*1, ECM"] = {
				attributes =  { },
				code_loadout =  { "IIW", "Crisis", "PG" },
				weaponType = "ASM",
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 270,
				vAttack = 270,
				hCruise = 6096,
				hAttack = 6096,
				sortie_rate = 10,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
						},
						[2] = {
							CLSID = "{3E6B632D-65EB-44D2-9501-1C2D04515405}",
						},
						[3] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[4] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[5] = {
							CLSID = "{8B9E3FD0-F034-4A07-B6CE-C269884CC71B}",
						},
						[6] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[7] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[8] = {
							CLSID = "{AGM_45A}",
						},
						[9] = {
							CLSID = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
						},
					},
					fuel = "4864",
					flare = 30,
					chaff = 60,
					gun = 100,
				},
			},
			["SEAD-Cyprus-AGM45*2_Mk-82*6_AIM7*3_ECM - FT"] = {
				attributes =  { },
				code_loadout =  { "Cyprus", "WOC80" },
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
							CLSID = "{3E6B632D-65EB-44D2-9501-1C2D04515405}",
						},
						[2] = {
							CLSID = "{60CC734F-0AFA-4E2E-82B8-93B941AB11CF}",
						},
						[3] = {
							CLSID = "{6D21ECEA-F85B-4E8D-9D51-31DC9B8AA4EF}",
						},
						[4] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[5] = {
							CLSID = "{8B9E3FD0-F034-4A07-B6CE-C269884CC71B}",
						},
						[6] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[7] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[8] = {
							CLSID = "{60CC734F-0AFA-4E2E-82B8-93B941AB11CF}",
						},
						[9] = {
							CLSID = "{3E6B632D-65EB-44D2-9501-1C2D04515405}",
						},
					},
					fuel = "4864",
					flare = 30,
					chaff = 60,
					gun = 100,
				},
			},
		},
		["Runway Attack"] = {
			["Runway attack  - Aim-7Mx4 - Aim-9Px4 - Mk82LDx12 - FT"] = {
				minscore = 0.3,
				support = {
					Escort = true,
					SEAD = true,
				},
				attributes =  { "Runway" },
				code_loadout =  { "IIW", "Crisis", "PG", "Cyprus" },
				weaponType = "Bombs",
				expend = "All",
				night = true,
				adverseWeather = true,
				range = 200000,
				firepower = 1,
				vCruise = 245,
				vAttack = 277.5,
				hCruise = 9100,
				hAttack = 200,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{1C97B4A0-AA3B-43A8-8EE7-D11071457185}",
						},
						[2] = {
							CLSID = "{773675AB-7C29-422f-AFD8-32844A7B7F17}",
						},
						[3] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[4] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[5] = {
							CLSID = "{8B9E3FD0-F034-4A07-B6CE-C269884CC71B}",
						},
						[6] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[7] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[8] = {
							CLSID = "{773675AB-7C29-422f-AFD8-32844A7B7F17}",
						},
						[9] = {
							CLSID = "{1C97B4A0-AA3B-43A8-8EE7-D11071457185}",
						},
					},
					fuel = 4864,
					flare = 30,
					chaff = 60,
					gun = 100,
				},
			},
		},
		["Fighter Sweep"] = {
			["Crisis AIM-9M*4, AIM-7M*4, Fuel*3"] = {
				attributes =  { },
				code_loadout =  { "IIW", "Crisis", "PG", "Revenge" },
				night = true,
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 245,
				vAttack = 245,
				hCruise = 9753.6,
				hAttack = 9753.6,
				standoff = 46300,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
						},
						[2] = {
							CLSID = "{9DDF5297-94B9-42FC-A45E-6E316121CD85}",
						},
						[3] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[4] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[5] = {
							CLSID = "{8B9E3FD0-F034-4A07-B6CE-C269884CC71B}",
						},
						[6] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[7] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[8] = {
							CLSID = "{9DDF5297-94B9-42FC-A45E-6E316121CD85}",
						},
						[9] = {
							CLSID = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
						},
					},
					fuel = "4864",
					flare = 30,
					chaff = 60,
					gun = 100,
				},
			},
			["GTA AIR/AIR AIM-9*4,AIM-7*4"] = {
				attributes =  { },
				code_loadout =  { "HWITC" },
				adverseWeather = true,
				range = 500000,
				firepower = 1,
				vCruise = 255.83333333333,
				vAttack = 265.83333333333,
				hCruise = 2753.6,
				hAttack = 2753.6,
				standoff = 46300,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[2] = {
							CLSID = "{9DDF5297-94B9-42FC-A45E-6E316121CD85}",
						},
						[3] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[4] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[6] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[7] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[8] = {
							CLSID = "{9DDF5297-94B9-42FC-A45E-6E316121CD85}",
						},
					},
					fuel = "4864",
					flare = 30,
					chaff = 60,
					gun = 100,
				},
			},
			["Cyprus AIM-9M*4, AIM-7M*4, Fuel*3"] = {
				attributes =  { },
				code_loadout =  { "Cyprus" },
				night = true,
				adverseWeather = true,
				range = 500000,
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
							CLSID = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
						},
						[2] = {
							CLSID = "{F4-2-AIM9L}",
						},
						[3] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[4] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[5] = {
							CLSID = "{8B9E3FD0-F034-4A07-B6CE-C269884CC71B}",
						},
						[6] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[7] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[8] = {
							CLSID = "{F4-2-AIM9L}",
						},
						[9] = {
							CLSID = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
						},
					},
					fuel = "4864",
					flare = 30,
					chaff = 60,
					gun = 100,
				},
			},
		},
		Intercept = {
			["Cyprus AIM-7M*4,AIM-9*4,Fuel"] = {
				attributes =  { },
				code_loadout =  { "Cyprus" },
				night = true,
				adverseWeather = true,
				range = 400000,
				firepower = 1,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
						},
						[2] = {
							CLSID = "{F4-2-AIM9L}",
						},
						[3] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[4] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[5] = {
							CLSID = "{8B9E3FD0-F034-4A07-B6CE-C269884CC71B}",
						},
						[6] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[7] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[8] = {
							CLSID = "{F4-2-AIM9L}",
						},
						[9] = {
							CLSID = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
						},
					},
					fuel = "4864",
					flare = 30,
					chaff = 60,
					gun = 100,
				},
			},
			["Crisis AIM-7M*4,AIM-9*4,Fuel"] = {
				attributes =  { },
				code_loadout =  { "IIW", "Crisis", "PG", "Revenge" },
				night = true,
				adverseWeather = true,
				range = 400000,
				firepower = 1,
				LDSD = true,
				sortie_rate = 6,
				stores = {
					pylons = {
						[1] = {
							CLSID = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
						},
						[2] = {
							CLSID = "{9DDF5297-94B9-42FC-A45E-6E316121CD85}",
						},
						[3] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[4] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[5] = {
							CLSID = "{8B9E3FD0-F034-4A07-B6CE-C269884CC71B}",
						},
						[6] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[7] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[8] = {
							CLSID = "{9DDF5297-94B9-42FC-A45E-6E316121CD85}",
						},
						[9] = {
							CLSID = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
						},
					},
					fuel = "4864",
					flare = 30,
					chaff = 60,
					gun = 100,
				},
			},
			["GTA AIR/AIR AIM-9*4,AIM-7*4"] = {
				attributes =  { },
				code_loadout =  { "HWITC" },
				adverseWeather = true,
				range = 400000,
				firepower = 1,
				LDSD = true,
				sortie_rate = 10,
				stores = {
					pylons = {
						[2] = {
							CLSID = "{9DDF5297-94B9-42FC-A45E-6E316121CD85}",
						},
						[3] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[4] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[6] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[7] = {
							CLSID = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
						},
						[8] = {
							CLSID = "{9DDF5297-94B9-42FC-A45E-6E316121CD85}",
						},
					},
					fuel = "4864",
					flare = 30,
					chaff = 60,
					gun = 100,
				},
			},
		},
	},

}