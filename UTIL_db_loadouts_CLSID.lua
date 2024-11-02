--
--add the new parameters for bombs and GBUs if they exist
--
------------------------------------------------------------------------------------------------------- 
------------------------------------------------------------------------------------------------------- 
-- last modification: M79_g
if not versionDCE then versionDCE = {} end
versionDCE["UTIL_db_loadouts_CLSID.lua"] = "1.1.7"
------------------------------------------------------------------------------------------------------- 
------------------------------------------------------------------------------------------------------- 

-- modification M79_g			CLSID settings (g: add FA-18C_hornet - F-16C_50 - AV8BNA - F-4E-45MC - A-10C_2 - A-4E-C - B-52H)
------------------------------------------------------------------------------------------------------- 
------------------------------------------------------------------------------------------------------- 


---FA-18C_hornet - F-16C_50 - AV8BNA - F-4E-45MC - A-10C_2 - A-4E-C - B-52H

CLSID_db = 
{
	-- {  --ensemble d emport ayant des nom differents, mais un settings identique
	-- 	CLSID_Name = 
	-- 	{

	-- 	},
	-- 	settings =
	-- 	{

	-- 	}, -- end of ["settings"]
	-- },

	{  --MK81 --MK-82 --SNAKEYE --Mk-82Y AIR --Mk-83 --Mk84
		CLSID_Name = 
		{		
			--MK-81 solo
			"{90321C8E-7ED1-47D4-A160-E074D5ABD902}",
			--MK-81 X 2
			"{HB_F4E_MK-81_2x}",
			"{HB_F4E_MK-81_2x_SWA}",
			--MK-81 X 3
			"{HB_F4E_MK-81_3x}",
			--MK-81 X 6
			"{HB_F4E_MK-81_6x}",
			--MK-82 solo
			"{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
			"{BRU42_1X_MK-82}",
			--MK-82 x 2
			"{BRU33_2X_MK-82}",
			"{TER_9A_2R*MK-82}",
			"{TER_9A_2L*MK-82}",
			"{HB_F4E_MK-82_2x}",
			"{HB_F4E_MK-82_2x_SWA}",
			"{BRU42_2X_MK-82_R}",
			"{BRU42_2X_MK-82_L}",
			--Mk-82 x 3
			"{TER_9A_3*MK-82}",
			"{HB_F4E_MK-82_3x}",
			"{60CC734F-0AFA-4E2E-82B8-93B941AB11CF}",
			--Mk-82 x 6
			"{HB_F4E_MK-82_6x}",
			--Mk-82 x 9
			"{585D626E-7F42-4073-AB70-41E728C333E2}",
			--Mk-82 x 27
			"{6C47D097-83FF-4FB2-9496-EAB36DDF0B05}",
			--Mk-82 SNAKEYE solo
			"{Mk82SNAKEYE}",
			--Mk-82 SNAKEYE x 2
			"{BRU33_2X_MK-82_Snakeye}",
			"{TER_9A_2R*MK-82_Snakeye}",
			"{TER_9A_2L*MK-82_Snakeye}",
			"{HB_F4E_MK-82_Snakeye_2x}",
			"{HB_F4E_MK-82AIR_2x_SWA}",
			--Mk-82 SNAKEYE x 3
			"{TER_9A_3*MK-82_Snakeye}",
			"{HB_F4E_MK-82_Snakeye_3x}",
			--Mk-82 SNAKEYE x 6
			"{HB_F4E_MK-82_Snakeye_6x}",
			--Mk-82Y	AIR solo
			"{Mk_82Y}",
			"{Mk82AIR}",
			"{BRU42_1X_MK-82AIR}",
			--Mk-82Y	AIR x 2
			"{BRU33_2X_MK-82Y}",
			"{TER_9A_2R*MK-82AIR}",
			"{TER_9A_2L*MK-82AIR}",
			"{BRU42_2X_MK-82AIR_R}",
			"{BRU42_2X_MK-82AIR_L}",
			--Mk-82Y	AIR x 3
			"{TER_9A_3*MK-82AIR}",
			"{BRU-42_3*Mk-82AIR}",
			--Mk-82Y	AIR x 6
			"{HB_F4E_MK-82AIR_6x}",
			--Mk-83 solo
			"{7A44FF09-527C-4B7E-B42B-3F111CFE50FB}",
			"{HB_F4E_MK-83_MER_1x_Left_Ripple}",
			"{HB_F4E_MK-83_MER_1x_Right_Ripple}",
			--Mk-83 x 2
			"{BRU33_2X_MK-83}",
			"{HB_F4E_MK-83_MER_2x}",
			"{HB_F4E_MK-83_2x_Left}",
			"{HB_F4E_MK-83_2x_Right}",
			--Mk-83 x 3
			"{HB_F4E_MK-83_3x}",
			"{HB_F4E_MK-83_MER_3x}",
			"{HB_F4E_MK-83_MER_3x_Ripple}",
			--Mk-84 solo
			"{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
			--Mk-84 x 6
			"{696CFFC4-0BDE-42A8-BE4B-0BE3D9DD723C}",
		},
		settings =
		{
			["function_delay_ctrl_M905"] = 0,
			["arm_delay_ctrl_M904E4"] = 2,
			["function_delay_ctrl_M904E4"] = 0,
			["arm_delay_ctrl_M905"] = 4,
			["NFP_fuze_type_tail"] = "M905",
			["NFP_fuze_type_nose"] = "M904E4",
			["NFP_VIS_DrawArgNo_57"] = 0,
		}, -- end of ["settings"]
	},
	
	{  --AN-M30A1 --AN-M57 --AN-M64 --AN-M65
		CLSID_Name = 
		{
			--AN-M30A1 solo
			"{AN_M30A1}",
			--AN-M57 solo
			"{AN_M57}",
			--AN-M64 solo
			"{AN-M64}",
			--AN-M65 solo
			"{AN_M65}",
		},
		settings =
		{
			["NFP_fuze_type_nose"] = 1,
			["NFP_fuze_type_tail"] = 1,
			["function_delay_ctrl_ANM101A2"] = 0,
			["function_delay_ctrl_ANM103A1"] = 0,
			["vane_rev_threshold_ctrl_ANM101A2"] = 160,
						["vane_rev_threshold_ctrl_FD_0_ANM103A1"] = 300,
		}, -- end of ["settings"]
	},
	
	{  --Mk-84 AIR
		CLSID_Name = 
		{
			--Mk-84 AIR solo
			"{Mk_84AIR_GP}",
		},
		settings =
		{
			["NFP_fuze_type_nose"] = "M904E4",
			["NFP_fuze_type_tail"] = "M905",
			["arm_delay_ctrl_M904E4"] = 2,
			["arm_delay_ctrl_M905"] = 4,
			["function_delay_ctrl_M904E4"] = 0,
			["function_delay_ctrl_M905"] = 0,
		}, -- end of ["settings"]
	},

	{  --Mk-20 Rockeye --CBU-99
		CLSID_Name = 
		{
			--Mk-20 Rockeye solo
			"{ADD3FAE1-EBF6-4EF9-8EFC-B36B5DDF1E6B}",
			--Mk-20 Rockeye x 2
			"{BRU33_2X_ROCKEYE}",
			"{HB_F4E_ROCKEYE_2x}",
			"{HB_F4E_ROCKEYE_2x_SWA}",
			--Mk-20 Rockeye x 3
			"{HB_F4E_ROCKEYE_3x}",
			--Mk-20 Rockeye x 6
			"{HB_F4E_ROCKEYE_6x}",
			--CBU-99 solo
			"{CBU_99}",
			--CBU-99 x 2
			"{BRU33_2X_CBU-99}",
		},
		setting =
		{
			["NFP_fuze_type_nose"] = "Mk339Mod1",
			["arm_delay_ctrl_Mk339Mod1"] = 1.1,
			["function_delay_ctrl_00_Mk339Mod1"] = 1.2,
			["function_delay_ctrl_01_Mk339Mod1"] = 4,
			
		}, -- end of ["settings"]
	},
	
	{  --CBU-87 --CBU-103
		CLSID_Name = 
		{
			--CBU-87 solo
			"{CBU-87}",
			"{HB_CBU-87_SWA}",
			--CBU-87 x 2
			"{TER_9A_2R*CBU-87}",
			"{TER_9A_2L*CBU-87}",
			"{HB_F4E_CBU-87_2x}",
			"{HB_F4E_CBU-87_2x_SWA}",
			--CBU-87 x 3
			"{TER_9A_3*CBU-87}",
			"{HB_F4E_CBU-87_MER_3x_Right}",
			"{HB_F4E_CBU-87_MER_3x_Left}",
			--CBU-87 x 4
			"{HB_F4E_CBU-87_MER_4x}",
			--CBU-103 solo
			"{CBU_103}",
			--CBU-103 x 2
			"{BRU57_2*CBU-103}",
		},
		settings =
		{
			["NFP_fuze_type_nose"] = "FZU39",
			["ang_vel_x"] = 104.7,
			["function_altitude_ctrl_FZU39_SUU65"] = 457.2,
			["function_delay_ctrl_FZU39_SUU65"] = 2.23,
		}, -- end of ["settings"]
	},


	{  --CBU-97 -- CBU-105
		CLSID_Name = 
		{
			--CBU-97 solo
			"{5335D97A-35A5-4643-9D9B-026C75961E52}",
			--CBU-97 x 2
			"{TER_9A_2R*CBU-97}",
			"{TER_9A_2L*CBU-97}",
			--CBU-97 x 3
			"{TER_9A_3*CBU-97}",
			--CBU-105 solo
			"{CBU_105}",
			--CBU-105 x 2
			"{BRU57_2*CBU-105}",
		},
		settings =
		{
			["NFP_fuze_type_nose"] = "FZU39",
			["function_altitude_ctrl_FZU39_SUU65_SFW"] = 457.2,
			["function_delay_ctrl_FZU39_SUU65_SFW"] = 2.23,
		}, -- end of ["settings"]
	},


	{  --GBU-10 GBU-12 GBU-16
		CLSID_Name = 
		{
			--GBU-12 solo
			"{DB769D48-67D7-42ED-A2BE-108D566C8B1E}",
			"{HB_GBU-12_SWA}",
			--GBU-12 x 2
			"{BRU33_2X_GBU-12}",
			"{TER_9A_2L*GBU-12}",
			"{TER_9A_2R*GBU-12}",
			"{HB_F4E_GBU-12_2x}",
			"{HB_F4E_GBU-12_2x_SWA}",
			"{BRU42_2X_GBU-12_R}",
			"{BRU42_2X_GBU-12_L}",
			--GBU-12 x 3
			"BRU-42_3*GBU-12",
			--GBU-16 solo
			"{0D33DDAE-524F-4A4E-B5B8-621754FE3ADE}",
			--GBU-10 solo
			"{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
		},
		settings =
		{
			["NFP_VIS_DrawArgNo_57"] = 0,
			["NFP_fuze_type_tail"] = "FMU139CB_LD",
			["arm_delay_ctrl_FMU139CB_LD"] = 4,
			["function_delay_ctrl_FMU139CB_LD"] = 0,
			["laser_code"] = 1688,
		}, -- end of ["settings"]
	},

	{  --GBU-24
		CLSID_Name = 
		{
			--GBU-24 solo
			"{GBU-24}",
			"{34759BBC-AF1E-4AEE-A581-498FF7A6EBCE}",
		},
		settings =
		{
			["NFP_VIS_DrawArgNo_57"] = 1,
			["NFP_fuze_type_tail"] = "FMU139CB_LD",
			["arm_delay_ctrl_FMU139CB_LD"] = 4,
			["function_delay_ctrl_FMU139CB_LD"] = 0,
			["laser_code"] = 1688,
		}, -- end of ["settings"]
	},			

	{  --GBU-38
		CLSID_Name = 
		{
			--GBU-38 solo
			"{GBU-38}",
			--GBU-38 x 2
			"{BRU55_2*GBU-38}",
			"{BRU57_2*GBU-38}",
		},
		settings =
		{
			["NFP_VIS_DrawArgNo_56"] = 0.5,
			["NFP_VIS_DrawArgNo_57"] = 0,
			["NFP_fuze_type_nose"] = "EMPTY_NOSE",
			["NFP_fuze_type_tail"] = "FMU139CB_LD",
			["arm_delay_ctrl_FMU139CB_LD"] = 4,
			["function_delay_ctrl_FMU139CB_LD"] = 0,
		}, -- end of ["settings"]
	},		

	{  --GBU-31-V2 --GBU-32
		CLSID_Name = 
		{
			--GBU-32-V-2B solo
			"{GBU_32_V_2B}",
			--GBU-31-V-2B
			"{GBU_31_V_2B}",
		},
		settings =
		{
			["NFP_VIS_DrawArgNo_56"] = 0.5,
			["NFP_VIS_DrawArgNo_57"] = 1,
			["NFP_fuze_type_nose"] = "EMPTY_NOSE",
			["NFP_fuze_type_tail"] = "FMU139CB_LD",
			["arm_delay_ctrl_FMU139CB_LD"] = 4,
			["function_delay_ctrl_FMU139CB_LD"] = 0,
		}, -- end of ["settings"]
	},		

	{  ----GBU-31 solo
		CLSID_Name = 
		{
			--GBU-31 solo
			"{GBU-31}",
		},
		settings =
		{
			["NFP_VIS_DrawArgNo_56"] = 0.5,
			["NFP_fuze_type_nose"] = "EMPTY_NOSE",
			["NFP_fuze_type_tail"] = "FMU139CB_LD",
			["arm_delay_ctrl_FMU139CB_LD"] = 4,
			["function_delay_ctrl_FMU139CB_LD"] = 0,
		}, -- end of ["settings"]
	},		

	{  --GBU-31-V-3B --GBU-54-V-1B
		CLSID_Name = 
		{
			--GBU-31-V-3B
			"{GBU-31V3B}",
			--GBU-54-V-1B
			"{GBU_54_V_1B}",
		},
		settings =
		{
			["NFP_fuze_type_tail"] = "FMU139CB_LD",
			["arm_delay_ctrl_FMU139CB_LD"] = 4,
			["function_delay_ctrl_FMU139CB_LD"] = 0,
		}, -- end of ["settings"]
	},		

	{  --GBU-31-V-4B
		CLSID_Name = 
		{
			--GBU-31-V-4B
			"{GBU_31_V_4B}",
		},
		settings =
		{
			["NFP_VIS_DrawArgNo_57"] = 1,
			["NFP_fuze_type_tail"] = "FMU139CB_LD",
			["arm_delay_ctrl_FMU139CB_LD"] = 4,
			["function_delay_ctrl_FMU139CB_LD"] = 0,
		}, -- end of ["settings"]
	},
	

}

					