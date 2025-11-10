--To check oob_ground for threats and rate and store them in a table for later mission plannning
--Initiated by Main_NextMission.lua
------------------------------------------------------------------------------------------------------- 
-- last modification:  debug_c
if not versionDCE then versionDCE = {} end
versionDCE["ATO_ThreatEvaluation.lua"] = "1.7.56"
------------------------------------------------------------------------------------------------------- 
-- cleancode_g				(g springCleaning)
-- debug_c					(c Fighterthreats & country table(b EWR again)(a Freq EWR)
-- Reglage_i				(i: KS-19 & S-60)(k: ZSU_57_2)(j station awacs position)(debug alti)(g SetFrequency only EWR)(f: add FPS-117 EWR)(e SEAD_offset CVN)(c: more info)(b: ajout des CVN_71/CVN_75 et SA-5)
-- modification M38_h		Check and Help CampaignMaker (h: loadout info)
-- modification M34_r		change freq EWR + custom FrequenceRadio (qr debug units[1])(p LVHF)(o: debug boucle 2 unites)(lmn: debug)(k: utilise les indicatifs WEST pour EWR)
-- modification M28_b		helicoptere see all SAM
-- modification M07_g		EWR toujours affiché dans le briefing + 07g ajout des SAM et Boat dans la chaine de detection
------------------------------------------------------------------------------------------------------- 

if Debug.debug then
	print("START ATO_ThreatEvaluation.lua "..versionDCE["ATO_ThreatEvaluation.lua"].." =-=-=-=-=-=-=-=-=-=-=-=-=-=-=")
end

local reduceCercle = 100

--table to store ground/sea threats
groundthreats = {
	blue = {																		--blue threats (to red)
	},
	red = {																			--red threats (to blue)
	}
}

--pb callSign EWR:
-- façon WEST:
	-- [2] = 
	-- {
	-- 	["number"] = 2,
	-- 	["auto"] = false,
	-- 	["id"] = "WrappedAction",
	-- 	["enabled"] = true,
	-- 	["params"] = 
	-- 	{
	-- 		["action"] = 
	-- 		{
	-- 			["id"] = "SetCallsign",
	-- 			["params"] = 
	-- 			{
	-- 				["number"] = 1,
	-- 				["callnameFlag"] = true,
	-- 				["callname"] = 19,
	-- 			}, -- end of ["params"]
	-- 		}, -- end of ["action"]
	-- 	}, -- end of ["params"]
	-- }, -- end of [2]

	-- façon EST:
		-- [3] = 
		-- {
		-- 	["number"] = 3,
		-- 	["auto"] = false,
		-- 	["id"] = "WrappedAction",
		-- 	["enabled"] = true,
		-- 	["params"] = 
		-- 	{
		-- 		["action"] = 
		-- 		{
		-- 			["id"] = "SetCallsign",
		-- 			["params"] = 
		-- 			{
		-- 				["callsign"] = 503,
		-- 				["callnameFlag"] = false,
		-- 			}, -- end of ["params"]
		-- 		}, -- end of ["action"]
		-- 	}, -- end of ["params"]
		-- }, -- end of [3]


--function to check if a unit is a threat, assign threat values and add to threats table

local function addThreat(unit, side, hide)											--unput is side and unit-table from oob_ground	-- modification M28.b : helicoptere see all SAM (on ajoute Hide)							

	local threatentry = {}

	--tout ce qui est mobile et peu ou pas rayonnant est considéré caché, on ne peut pas prévoir leur position à l'avance
	-- on ne peut plus se fier au hidden du group, cache depuis les positions affiché en lat lont, on les cache tous, systematiquement
	local hiddenValue = true

	if unit.type == "Vulcan" then
		threatentry = {
			type = unit.type,
			class = "AAA",
			level = 1,																--threat level: 1 = low, 2 = medium, 3 = high
			SEAD_offset = 0,														--number of SEAD sorties required to offset threat
			x = unit.x,																--position x-coordinate
			y = unit.y,																--position y-coordinate
			range = 1500,															--range of threat
			night = false,															--night capable
			elevation = 3,															--sensor elevation above ground
			min_alt = 0,															--minimal threat altitute
			max_alt = 1500,															--maximal threat altitude
			hidden = hiddenValue,
		}
									-- modification M28.b : helicoptere see all SAM (insertion se fera plus bas avec hide)

	elseif unit.type == "ZSU-23-4 Shilka" or string.find(unit.type, "ZU-23")  then
		threatentry = {
			type = unit.type,
			class = "AAA",
			level = 1,
			SEAD_offset = 0,
			x = unit.x,
			y = unit.y,
			range = 2000,
			night = true,
			elevation = 3.5,
			min_alt = 0,
			max_alt = 2000,
			hidden = hiddenValue,
		}
	elseif unit.type == "KS-19" then
		threatentry = {
			type = unit.type,
			class = "AAA",
			level = 1,
			SEAD_offset = 0,
			x = unit.x,
			y = unit.y,
			range = 8000,
			night = false,
			elevation = 3.5,
			min_alt = 0,
			max_alt = 8000,
			hidden = hiddenValue,
		}
	elseif unit.type == "S-60_Type59_Artillery" then
		threatentry = {
			type = unit.type,
			class = "AAA",
			level = 1,
			SEAD_offset = 0,
			x = unit.x,
			y = unit.y,
			range = 4000,
			night = false,
			elevation = 3.5,
			min_alt = 0,
			max_alt = 4000,
			hidden = hiddenValue,
		}
	elseif unit.type == "ZSU_57_2" then
		threatentry = {
			type = unit.type,
			class = "AAA",
			level = 1,
			SEAD_offset = 0,
			x = unit.x,
			y = unit.y,
			range = 5000,
			night = true,
			elevation = 3.5,
			min_alt = 0,
			max_alt = 4300,
			hidden = hiddenValue,
		}

	elseif unit.type == "Gepard" then
		threatentry = {
			type = unit.type,
			class = "AAA",
			level = 1,
			SEAD_offset = 0,
			x = unit.x,
			y = unit.y,
			range = 4000,
			night = true,
			elevation = 4,
			min_alt = 0,
			max_alt = 3500,
			hidden = hiddenValue,
		}


	elseif unit.type == "M1097 Avenger" then
		threatentry = {
			type = unit.type,
			class = "SAM",
			level = 3,
			SEAD_offset = 0,
			x = unit.x,
			y = unit.y,
			range = 3000,
			night = true,
			elevation = 3,
			min_alt = 0,
			max_alt = 3600,
			hidden = hiddenValue,
		}


	elseif unit.type == "M48 Chaparral" then
		threatentry = {
			type = unit.type,
			class = "SAM",
			level = 3,
			SEAD_offset = 0,
			x = unit.x,
			y = unit.y,
			range = 4000,
			night = false,
			elevation = 3,
			min_alt = 0,
			max_alt = 3600,
			hidden = hiddenValue,
		}


	elseif unit.type == "M6 Linebacker" then	--Le M6 Linebacker est issu d'une conversion du M2A2 ODS Bradley
		threatentry = {
			type = unit.type,
			class = "SAM",
			level = 3,
			SEAD_offset = 0,
			x = unit.x,
			y = unit.y,
			range = 3000,
			night = true,
			elevation = 3,
			min_alt = 0,
			max_alt = 3600,
			hidden = hiddenValue,
		}


	elseif unit.type == "Stinger manpad" then
		threatentry = {
			type = unit.type,
			class = "SAM",
			level = 3,
			SEAD_offset = 0,
			x = unit.x,
			y = unit.y,
			range = 3000,
			night = false,
			elevation = 3,
			min_alt = 0,
			max_alt = 3600,
			hidden = hiddenValue,
		}


	elseif unit.type == "SA-18 Igla-S manpad" then
		threatentry = {
			type = unit.type,
			class = "SAM",
			level = 3,
			SEAD_offset = 0,
			x = unit.x,
			y = unit.y,
			range = 3500,
			night = false,
			elevation = 3,
			min_alt = 0,
			max_alt = 3600,
			hidden = hiddenValue,
		}


	elseif unit.type == "Strela-1 9P31" then
		threatentry = {
			type = unit.type,
			class = "SAM",
			level = 3,
			SEAD_offset = 0,
			x = unit.x,
			y = unit.y,
			range = 2500,
			night = false,
			elevation = 3,
			min_alt = 0,
			max_alt = 3600,
			hidden = hiddenValue,
		}


	elseif unit.type == "Strela-10M3" then
		threatentry = {
			type = unit.type,
			class = "SAM",
			level = 3,
			SEAD_offset = 0,
			x = unit.x,
			y = unit.y,
			range = 3500,
			night = false,
			elevation = 3.5,
			min_alt = 0,
			max_alt = 3600,
			hidden = hiddenValue,
		}


	elseif unit.type == "2S6 Tunguska" then
		threatentry = {
			type = unit.type,
			class = "SAM",
			level = 5,
			SEAD_offset = 1,
			x = unit.x,
			y = unit.y,
			range = 8000,
			night = true,
			elevation = 3.5,
			min_alt = 0,
			max_alt = 6500,
			hidden = hiddenValue,
		}


	elseif unit.type == "rapier_fsa_blindfire_radar" then
		threatentry = {
			type = unit.type,
			class = "SAM",
			level = 5,
			SEAD_offset = 2,
			x = unit.x,
			y = unit.y,
			range = 10000,
			night = true,
			elevation = 2.5,
			min_alt = 0,
			max_alt = 3600,
			hidden = hiddenValue,
		}


	elseif unit.type == "rapier_fsa_optical_tracker_unit" then
		threatentry = {
			type = unit.type,
			class = "SAM",
			level = 5,
			SEAD_offset = 0,
			x = unit.x,
			y = unit.y,
			range = 8500,
			night = false,
			elevation = 1.5,
			min_alt = 0,
			max_alt = 3600,
			hidden = hiddenValue,
		}


	elseif unit.type == "Roland ADS" then
		threatentry = {
			type = unit.type,
			class = "SAM",
			level = 5,
			SEAD_offset = 1,
			x = unit.x,
			y = unit.y,
			range = 8500,
			night = true,
			elevation = 4,
			min_alt = 0,
			max_alt = 8000,
			hidden = hiddenValue,
		}


	elseif unit.type == "HQ-7_STR_SP" then
		threatentry = {
			type = unit.type,
			class = "SAM",
			level = 3,
			SEAD_offset = 1,
			x = unit.x,
			y = unit.y,
			range = 12000,
			night = true,
			elevation = 4,
			min_alt = 0,
			max_alt = 5000,
			hidden = hiddenValue,
		}


	elseif unit.type == "HQ-7_LN_SP" then
		threatentry = {
			type = unit.type,
			class = "SAM",
			level = 2,
			SEAD_offset = 1,
			x = unit.x,
			y = unit.y,
			range = 12000,
			night = true,
			elevation = 4,
			min_alt = 0,
			max_alt = 5000,
			hidden = hiddenValue,
		}


	elseif unit.type == "Hawk tr" then
		threatentry = {
			type = unit.type,
			class = "SAM",
			level = 7,
			SEAD_offset = 2,
			x = unit.x,
			y = unit.y,
			range = 46000,
			night = true,
			elevation = 3,
			min_alt = 0,
			max_alt = 59000, --22000,
			hidden = false,
		}


	elseif unit.type == "Patriot str" then
		threatentry = {
			type = unit.type,
			class = "SAM",
			level = 10,
			SEAD_offset = 4,
			x = unit.x,
			y = unit.y,
			range = 92000,
			night = true,
			elevation = 6,
			min_alt = 0,
			max_alt = 32000,
			hidden = false,
		}


	elseif unit.type == "NASAMS_Radar_MPQ64F1" then	--NASAMS
		threatentry = {
			type = unit.type,
			class = "SAM",
			level = 8,
			SEAD_offset = 2,
			x = unit.x,
			y = unit.y,
			range = 15000,
			night = true,
			elevation = 4,
			min_alt = 0,
			max_alt = 15000,
			hidden = false,
		}


	elseif unit.type == "SNR_75V" then		--SA-2
		threatentry = {
			type = unit.type,
			class = "SAM",
			level = 5,
			SEAD_offset = 2,
			x = unit.x,
			y = unit.y,
			range = 45000,
			night = true,
			elevation = 3,
			min_alt = 50,
			max_alt = 20000,
			hidden = false,
		}


	elseif unit.type == "snr s-125 tr" then		--SA-3
		threatentry = {
			type = unit.type,
			class = "SAM",
			level = 6,
			SEAD_offset = 2,
			x = unit.x,
			y = unit.y,
			range = 23000,
			night = true,
			elevation = 3,
			min_alt = 50,
			max_alt = 20000,
			hidden = false,
		}


	elseif unit.type == "Kub 1S91 str" then		--SA-6
		threatentry = {
			type = unit.type,
			class = "SAM",
			level = 7,
			SEAD_offset = 2,
			x = unit.x,
			y = unit.y,
			range = 35000,
			night = true,
			elevation = 6,
			min_alt = 0,
			max_alt = 10000,
			hidden = false,
		}


	elseif unit.type == "Osa 9A33 ln" then
		threatentry = {
			type = unit.type,
			class = "SAM",
			level = 7,
			SEAD_offset = 1,
			x = unit.x,
			y = unit.y,
			range = 15000,
			night = true,
			elevation = 5.5,
			min_alt = 0,
			max_alt = 7000,
			hidden = hiddenValue,
		}


	elseif unit.type == "SA-11 Buk SR 9S18M1" then		--SA-11
		threatentry = {
			type = unit.type,
			class = "SAM",
			level = 8,
			SEAD_offset = 2,
			x = unit.x,
			y = unit.y,
			range = 39000,
			night = true,
			elevation = 7,
			min_alt = 0,
			max_alt = 24000,
			hidden = false,
		}


	elseif unit.type == "SA-11 Buk LN 9S18M1" then		--SA-11
		threatentry = {
			type = unit.type,
			class = "SAM",
			level = 8,
			SEAD_offset = 2,
			x = unit.x,
			y = unit.y,
			range = 35000,
			night = true,
			elevation = 7,
			min_alt = 0,
			max_alt = 24000,
			hidden = false,
		}


	elseif unit.type == "Tor 9A331" then
		threatentry = {
			type = unit.type,
			class = "SAM",
			level = 8,
			SEAD_offset = 2,
			x = unit.x,
			y = unit.y,
			range = 16000,
			night = true,
			elevation = 5,
			min_alt = 0,
			max_alt = 19600,
			hidden = hiddenValue,
		}


	elseif unit.type == "S-300PS 40B6M tr" then	--SA-10 radar
		threatentry = {
			type = unit.type,
			class = "SAM",
			level = 10,
			SEAD_offset = 4,
			x = unit.x,
			y = unit.y,
			range = 90000,
			night = true,
			elevation = 27.5,
			min_alt = 0,
			max_alt = 29000,
			hidden = false,
		}


	elseif unit.type == "RLS_19J6" then --SA-5 RLS 19J6 (P-14 Tall King) : Détection et surveillance initiales (alerte précoce).
		threatentry = {
			type = unit.type,
			class = "SAM",
			level = 7,
			SEAD_offset = 4,
			x = unit.x,
			y = unit.y,
			range = 150000,
			night = true,
			elevation = 27.5,
			min_alt = 0,
			max_alt = 35000,
			hidden = false,
		}

	elseif unit.type == "RPC_5N62V" then --SA-5 RPC 5N62V (Square Pair) : Poursuite et guidage des missiles.
		threatentry = {
			type = unit.type,
			class = "SAM",
			level = 8,
			SEAD_offset = 4,
			x = unit.x,
			y = unit.y,
			range = 255000,
			night = true,
			elevation = 27.5,
			min_alt = 0,
			max_alt = 35000,
			hidden = false,
		}


	elseif unit.type == "052B" then	--Destroyer Chinois Polyvalent
		threatentry = {
			type = unit.type,
			class = "SAM",
			level = 8,
			SEAD_offset = 2,
			x = unit.x,
			y = unit.y,
			range = 50000,
			night = true,
			elevation = 20,
			min_alt = 0,
			max_alt = 25000,
			hidden = false,
		}


	elseif unit.type == "052C" then
		threatentry = {
			type = unit.type,
			class = "SAM",
			level = 10,
			SEAD_offset = 4,
			x = unit.x,
			y = unit.y,
			range = 150000,
			night = true,
			elevation = 25,
			min_alt = 0,
			max_alt = 30000,
			hidden = false,
		}


	elseif unit.type == "054A" then
		threatentry = {
			type = unit.type,
			class = "SAM",
			level = 8,
			SEAD_offset = 2,
			x = unit.x,
			y = unit.y,
			range = 60000,
			night = true,
			elevation = 20,
			min_alt = 0,
			max_alt = 25000,
			hidden = false,
		}


	elseif unit.type == "MOLNIYA" then
		threatentry = {
			type = unit.type,
			class = "AAA",
			level = 3,
			SEAD_offset = 0,
			x = unit.x,
			y = unit.y,
			range = 2000,
			night = true,
			elevation = 10,
			min_alt = 0,
			max_alt = 1500,
			hidden = false,
		}


	elseif unit.type == "ALBATROS" then
		threatentry = {
			type = unit.type,
			class = "SAM",
			level = 7,
			SEAD_offset = 1,
			x = unit.x,
			y = unit.y,
			range = 15000,
			night = true,
			elevation = 20,
			min_alt = 0,
			max_alt = 5000,
			hidden = false,
		}


	elseif unit.type == "REZKY" then
		threatentry = {
			type = unit.type,
			class = "SAM",
			level = 7,
			SEAD_offset = 1,
			x = unit.x,
			y = unit.y,
			range = 15000,
			night = true,
			elevation = 20,
			min_alt = 0,
			max_alt = 5000,
			hidden = false,
		}


	elseif unit.type == "KUZNECOW" then
		threatentry = {
			type = unit.type,
			class = "SAM",
			level = 8,
			SEAD_offset = 2,
			x = unit.x,
			y = unit.y,
			range = 16000,
			night = true,
			elevation = 20,
			min_alt = 0,
			max_alt = 6000,
			hidden = false,
		}


	elseif unit.type == "NEUSTRASH" then
		threatentry = {
			type = unit.type,
			class = "SAM",
			level = 8,
			SEAD_offset = 2,
			x = unit.x,
			y = unit.y,
			range = 16000,
			night = true,
			elevation = 20,
			min_alt = 0,
			max_alt = 6000,
			hidden = false,
		}


	elseif unit.type == "MOSCOW" then
		threatentry = {
			type = unit.type,
			class = "SAM",
			level = 10,
			SEAD_offset = 4,
			x = unit.x,
			y = unit.y,
			range = 90000,
			night = true,
			elevation = 25,
			min_alt = 0,
			max_alt = 27000,
			hidden = false,
		}


	elseif unit.type == "PIOTR" then
		threatentry = {
			type = unit.type,
			class = "SAM",
			level = 10,
			SEAD_offset = 4,
			x = unit.x,
			y = unit.y,
			range = 145000,
			night = true,
			elevation = 30,
			min_alt = 0,
			max_alt = 27000,
			hidden = false,
		}


	elseif unit.type == "PERRY" then
		threatentry = {
			type = unit.type,
			class = "SAM",
			level = 7,
			SEAD_offset = 2,
			x = unit.x,
			y = unit.y,
			range = 90000,
			night = true,
			elevation = 20,
			min_alt = 0,
			max_alt = 30000,
			hidden = false,
		}


	elseif unit.type == "USS_Arleigh_Burke_IIa" then
		threatentry = {
			type = unit.type,
			class = "SAM",
			level = 9,
			SEAD_offset = 4,
			x = unit.x,
			y = unit.y,
			range = 10000,
			night = true,
			elevation = 25,
			min_alt = 0,
			max_alt = 30000,
			hidden = false,
		}


	elseif unit.type == "TICONDEROG" then
		threatentry = {
			type = unit.type,
			class = "SAM",
			level = 10,
			SEAD_offset = 4,
			x = unit.x,
			y = unit.y,
			range = 100000,
			night = true,
			elevation = 25,
			min_alt = 0,
			max_alt = 30000,
			hidden = false,
		}


	elseif unit.type == "Stennis" then
		threatentry = {
			type = unit.type,
			class = "SAM",
			level = 6,
			SEAD_offset = 2,
			x = unit.x,
			y = unit.y,
			range = 27000,
			night = true,
			elevation = 30,
			min_alt = 0,
			max_alt = 15000,
			hidden = false,
		}


	elseif unit.type == "CVN_71" then
		threatentry = {
			type = unit.type,
			class = "SAM",
			level = 6,
			SEAD_offset = 2,
			x = unit.x,
			y = unit.y,
			range = 27000,
			night = true,
			elevation = 30,
			min_alt = 0,
			max_alt = 15000,
			hidden = false,
		}
	elseif unit.type == "CVN_75" then
		threatentry = {
			type = unit.type,
			class = "SAM",
			level = 6,
			SEAD_offset = 2,
			x = unit.x,
			y = unit.y,
			range = 27000,
			night = true,
			elevation = 30,
			min_alt = 0,
			max_alt = 15000,
			hidden = false,
		}
	elseif unit.type == "CVN_72" then
		threatentry = {
			type = unit.type,
			class = "SAM",
			level = 6,
			SEAD_offset = 2,
			x = unit.x,
			y = unit.y,
			range = 27000,
			night = true,
			elevation = 30,
			min_alt = 0,
			max_alt = 15000,
			hidden = false,
		}


	elseif unit.type == "VINSON" then
		threatentry = {
			type = unit.type,
			class = "SAM",
			level = 6,
			SEAD_offset = 2,
			x = unit.x,
			y = unit.y,
			range = 27000,
			night = true,
			elevation = 30,
			min_alt = 0,
			max_alt = 15000,
			hidden = false,
		}


	elseif unit.type == "LHA_Tarawa" then
		threatentry = {
			type = unit.type,
			class = "SAM",
			level = 6,
			SEAD_offset = 2,
			x = unit.x,
			y = unit.y,
			range = 27000,
			night = true,
			elevation = 30,
			min_alt = 0,
			max_alt = 15000,
			hidden = false,
		}


	end



	if threatentry and threatentry.type then


		threatentry["name"] = unit.name
		-- threatentry.hidden = hide
		-- threatentry.range = threatentry.range + 5000		--TODO donne de la place aux planes pour manoeuvrer à coté sans risque d'entrer dans leur range
		-- threatentry.range = threatentry.range

		table.insert(groundthreats[side], threatentry)

		-- print("AtoTE Add New element "..#groundthreats[side].." name: "..tostring(threatentry["name"]).." "..tostring(threatentry.hidden))
	end

end -- fin local function AddThreat(unit, side, hide)


--table to store ewr
EWR_DB = {
	blue = {																		--blue EWR
	},
	red = {																			--red EWR
	}
}

--GCI table to store EWR radars (and later AWACS and interceptors)

GCI = {
	EWR = {
		["blue"] = {},
		["red"] = {},
	},
	Interceptor = {
		["blue"] = {
			base = {},
			assigned = {},
		},
		["red"] = {
			base = {},
			assigned = {},
		},
	},
	Flag = 500,
}

--function to add EWR units to EWR table
local function addEWR(unit, side, ewrData)
	-- print("AtoTE passe 00 function AddEWR type "..tostring(unit.type).." side: "..tostring(side).." freq: "..tostring(freq).." call: "..tostring(call)) 
	local insertEWR = false
	local insertGCi = false
	local entry = {}

	if unit.type == "1L13 EWR" then
		entry = {
			type = unit.type,
			class = "EWR",
			x = unit.x,
			y = unit.y,
			range = 330000,
			frequency = ewrData.frequencyMHz,
			callsign = (ewrData.WEST_callnameString and ewrData.WEST_number) and (ewrData.WEST_callnameString .. "." .. tostring(ewrData.WEST_number)) or (ewrData.EST_callsign or ""),
			elevation = 39,
			min_alt = 0,
			max_alt = 30000,
			-- [call] = true,
		}
		insertEWR = true
		insertGCi = true

	elseif unit.type == "55G6 EWR" then
		entry = {
			type = unit.type,
			class = "EWR",
			x = unit.x,
			y = unit.y,
			range = 340000,
			frequency = ewrData.frequencyMHz,
			callsign = (ewrData.WEST_callnameString and ewrData.WEST_number) and (ewrData.WEST_callnameString .. "." .. tostring(ewrData.WEST_number)) or (ewrData.EST_callsign or ""),
			elevation = 39,
			min_alt = 50,
			max_alt = 30000,
			-- [call] = true,
		}
		insertEWR = true
		insertGCi = true

	elseif unit.type == "FPS-117" then
		entry = {
			type = unit.type,
			class = "EWR",
			x = unit.x,
			y = unit.y,
			range = 461000,
			frequency = ewrData.frequencyMHz,
			callsign = (ewrData.WEST_callnameString and ewrData.WEST_number) and (ewrData.WEST_callnameString .. "." .. tostring(ewrData.WEST_number)) or (ewrData.EST_callsign or ""),
			elevation = 39,
			min_alt = 50,
			max_alt = 30000,
			-- [call] = true,
		}
		insertEWR = true
		insertGCi = true

	elseif unit.type == "FPS-117 Dome" then
		entry = {
			type = unit.type,
			class = "EWR",
			x = unit.x,
			y = unit.y,
			range = 461000,
			frequency = ewrData.frequencyMHz,
			callsign = (ewrData.WEST_callnameString and ewrData.WEST_number) and (ewrData.WEST_callnameString .. "." .. tostring(ewrData.WEST_number)) or (ewrData.EST_callsign or ""),
			elevation = 39,
			min_alt = 50,
			max_alt = 30000,
			-- [call] = true,
		}
		insertEWR = true
		insertGCi = true

	elseif unit.type == "p-19 s-125 sr" then		--SA-5 SA-2 radar						--Participe � la chaine de detection
		entry = {
			type = unit.type,
			class = "EWR",
			x = unit.x,
			y = unit.y,
			range = 160000,
			frequency = ewrData.frequencyMHz,
			callsign = (ewrData.WEST_callnameString and ewrData.WEST_number) and (ewrData.WEST_callnameString .. "." .. tostring(ewrData.WEST_number)) or (ewrData.EST_callsign or ""),
			elevation = 6,
			min_alt = 0,
			max_alt = 30000,
			-- [call] = true,
		}
		insertEWR = true
		insertGCi = true

	elseif unit.type == "Dog Ear radar" then								--Participe � la chaine de detection
		entry = {
			type = unit.type,
			class = "EWR",
			x = unit.x,
			y = unit.y,
			range = 35000,
			frequency = ewrData.frequencyMHz,
			callsign = (ewrData.WEST_callnameString and ewrData.WEST_number) and (ewrData.WEST_callnameString .. "." .. tostring(ewrData.WEST_number)) or (ewrData.EST_callsign or ""),
			elevation = 4,
			min_alt = 0,
			max_alt = 20000,
			-- [call] = true,
		}
		insertEWR = true
		insertGCi = true

	--M07.g
	elseif unit.type == "SNR_75V" then										--Participe � la chaine de detection
		insertGCi = true
	elseif unit.type == "snr s-125 tr" then										--Participe � la chaine de detection
		insertGCi = true
	elseif unit.type == "RPC_5N62V" then	--SA-5		radar							--Participe � la chaine de detection
		insertGCi = true
	elseif unit.type == "S-300PS 40B6M tr" then	--SA-10 radar									--Participe � la chaine de detection
		insertGCi = true
	elseif unit.type == "Patriot str" then										--Participe � la chaine de detection
		insertGCi = true
	elseif unit.type == "NASAMS_Radar_MPQ64F1" then										--Participe � la chaine de detection
		insertGCi = true
	elseif unit.type == "Hawk tr" then										--Participe � la chaine de detection
		insertGCi = true
	elseif unit.type == "TICONDEROG" then										--Participe � la chaine de detection
		insertGCi = true
	elseif unit.type == "USS_Arleigh_Burke_IIa" then										--Participe � la chaine de detection
		insertGCi = true
	elseif unit.type == "Stennis" then										--Participe � la chaine de detection
		insertGCi = true
	elseif unit.type == "CVN_71" then										--Participe � la chaine de detection
		insertGCi = true
	elseif unit.type == "CVN_72" then										--Participe � la chaine de detection
		insertGCi = true
	elseif unit.type == "CVN_73" then										--Participe � la chaine de detection
		insertGCi = true
	elseif unit.type == "CVN_75" then										--Participe � la chaine de detection
		insertGCi = true
	elseif unit.type == "LHA_Tarawa" then										--Participe � la chaine de detection
		insertGCi = true
	elseif unit.type == "PIOTR" then										--Participe � la chaine de detection
		insertGCi = true
	elseif unit.type == "MOSCOW" then										--Participe � la chaine de detection
		insertGCi = true
	elseif unit.type == "KUZNECOW" then										--Participe � la chaine de detection
		insertGCi = true
	else
		-- print("AtoTE ATTENTION, not found "..tostring(unit.type).." in data ATO_ThreatEvaluation. Side: "..tostring(side).." freq: "..tostring(freq).." call: "..tostring(call)) 
		return false
	end


	if insertEWR then
		if entry.callsign then
			table.insert(EWR_DB[side], entry)

			--TODO a quoi ça sert?
			-- EWR_DB[side][#EWR_DB[side]][call] = true
		else
			return false
		end
	end
	if insertGCi then
		GCI.EWR[side][unit.name] = true
	end


	-- _affiche(GCI , "AtoTE passe 00bc GCI ")
end

local ewrFreqDejaTraite = {}
--find ground threats and EWR in vehicles and ships
for sidename, side in pairs(oob_ground) do									--Iterate through all sides
	for country_n, country in pairs(side) do								--Iterate through all countries
		if country.vehicle then												--If country has vehicles
			for group_n, group in pairs(country.vehicle.group) do			--Iterate through all groups				
				local ewr_task = false							--group has EWR task
				-- local ewr_freq = nil							--group has a communications frequency
				local ewr_call = {
					EST_callsign = nil ,
					frequencyHz = nil,
					frequencyMHz = nil,
					WEST_callnameId = nil ,
					WEST_callnameString = nil ,
					WEST_number = nil ,
				}							--group has a communications callsign
				local tempFreq = nil

				--check la presences d'une task EWR en ne parsant QUE le wpt 1
				for t = 1, #group.route.points[1].task.params.tasks do												--Iterate through WP1 tasks of group
					if group.route.points[1].task.params.tasks[t].id == "EWR" then									--If there is a EWR task
						ewr_task = true																				--set ewr_task true									
						-- print("AtoTE EWR B "..tostring(group.name))							
					end
				end
					-- {
						-- ["number"] = 2,
						-- ["auto"] = false,
						-- ["id"] = "EWR",
						-- ["enabled"] = true,
						-- ["params"] = 
						-- {
							-- ["number"] = 1,
							-- ["callname"] = 3,
						-- }, -- end of ["params"]
					-- }, -- end of [2]

				--on recommence la boucle, car id = EWR peut etre en dernier, et on louperait les freq et name
				for t = 1, #group.route.points[1].task.params.tasks do
					-- camp west, si utilisation des EWR, pour que les indicatifs soient bien pris en compte, l'enregistrement par DCS est comme ci dessus, il n'y a pas de SetCallsign
					if group.route.points[1].task.params.tasks[t].params.callname then							--if group has a callsign set									
						ewr_call["WEST_callnameId"] = group.route.points[1].task.params.tasks[t].params.callname					--set callname modification M07f
						ewr_call["WEST_number"] = group.route.points[1].task.params.tasks[t].params.number
						-- print("AtoTE EWR A "..tostring(group.name).." callname: "..tostring(ewr_call))							--debug
						
						ewr_call["WEST_callnameString"] = Callsign_west.JTAC_EWR[ewr_call.WEST_callnameId]
					end

					if group.route.points[1].task.params.tasks[t].params.action and ewr_task then
						if group.route.points[1].task.params.tasks[t].params.action.id == "SetCallsign" then							--if group has a callsign set
							
						--EST side
							if group.route.points[1].task.params.tasks[t].params.action.params.callsign then
								ewr_call["EST_callsign"] = group.route.points[1].task.params.tasks[t].params.action.params.callsign						--set callsign
								
							--WEST side
							elseif group.route.points[1].task.params.tasks[t].params.action.params.callname then						-- callname is Callsign_west
								ewr_call["WEST_callnameId"] = group.route.points[1].task.params.tasks[t].params.action.params.callname
								ewr_call["WEST_number"] = group.route.points[1].task.params.tasks[t].params.action.params.number						--set callname modification M07e

								ewr_call["WEST_callnameString"] = Callsign_west.JTAC_EWR[ewr_call.WEST_callnameId]
							end
						end

						--changement obligatoire de la frequence 
						--pour que les frequences puissent etre compatible avec la radio du joueur
						if group.route.points[1].task.params.tasks[t].params.action.id == "SetFrequency" then							--if group has a frequency set										
							
							if camp and camp.ewrFreqAdaptable then
								ewr_call["frequencyMHz"] = GetFrequency(sidename, group.name, "EWR")
								ewr_call["frequencyHz"] = ewr_call.frequencyMHz * 1000000		--convert to Hz
								group.route.points[1].task.params.tasks[t].params.action.params.frequency = ewr_call["frequencyHz"]
							else
								ewr_call["frequencyHz"] = group.route.points[1].task.params.tasks[t].params.action.params.frequency
								ewr_call["frequencyMHz"] = ewr_call.frequencyHz / 1000000		--convert to MHz
							end

							if Assigned_freq and ewr_call.frequencyMHz then
								Assigned_freq[ewr_call.frequencyMHz] = true
							end

						end
					end
				end


				--parse toutes les unités car le/les radars ne sont pas forcement en position 1
				local testAdd = false
				for _, unit in pairs(group.units) do				--Iterate through all units			
					if not unit.dead then

						-- print("AtoTE group.name "..group.name.." group.hidden: "..tostring(group.hidden))
						-- print(" - - - AtoTE unit.name "..unit.name.." group.hidden: "..tostring(group.hidden))
						addThreat(unit, sidename, group.hidden)

						if not ewrFreqDejaTraite[sidename] then ewrFreqDejaTraite[sidename]= {} end
						if not ewrFreqDejaTraite[sidename][group.groupId] then

							--tente d'ajouter cette unité dans la table EWR du script GCI inGame
							--si elle est reconnue EWR, elle sera ajoutée

							testAdd = addEWR(unit, sidename, ewr_call)	--Add to EWR table
							if testAdd ~= false then
								ewrFreqDejaTraite[sidename][group.groupId] = true
								-- tempFreq = ewr_freq * 1000000
								EwrAdd = true
							elseif ewrFreqDejaTraite[sidename][group.groupId] then
								InsertBugList("no callsign planned for this EWR name "..tostring(unit.name).." type "..tostring(unit.type))
							end

						else
							-- print("AtoTE  EWR _Z_  ")
							-- ewr_freq = nil
							-- ewr_call = nil
							-- tempFreq = nil
						end
					end
				end
			end
		end
		if country.ship then												--If country has ships
			for group_n, group in pairs(country.ship.group) do				--Iterate through all groups
				if group.hidden == false then								--group is not hidden
					for unit_n, unit in pairs(group.units) do				--Iterate through all units
						if not unit.dead then							--If unit is not dead
							addThreat(unit, sidename)						--Evaluate unit as threat and add to groundthreats table
							addEWR(unit, sidename)							--Evaluate unit as EWR and add to EWR table
						end
					end
				end
			end
		end
	end
end

--table to store fighter threats (CAP and intercept)
Fighterthreats = {
	blue = {},																					--blue threats (to red)
	red = {}																					--red threats (to blue)
}

CAPthreats = {
	blue = {},																					--blue threats (to red)
	red = {}																					--red threats (to blue)
}


--find AWACS, CAP and interceptors in aircraft units and populate ewr/Fighterthreats table
for sideName, unit in pairs(oob_air) do																--iterate through all sides
	for n = 1, #unit do																			--iterate through all units
		local pass = true

		if unit[n].inactive then
			-- print("AtoTE Ce echec ")
			-- _affiche(unit[n], "unit[n]: ")
			-- os.execute 'pause'
			pass = false
		end

		if pass and unit[n].roster.ready > 0 and db_airbases[unit[n].base] and db_airbases[unit[n].base].inactive ~= true and db_airbases[unit[n].base].x and db_airbases[unit[n].base].y then		--if unit is active and has ready aircraft and its airbase is active
			for task, task_bool in pairs(unit[n].tasks) do										--iterate through all tasks of unit			
				if task_bool then
					if LoadoutsList[unit[n].type] then
						if LoadoutsList[unit[n].type][task] then							--task is true and db_loadouts has such tasks
							for loadout_name, loadout in pairs(LoadoutsList[unit[n].type][task]) do		--iterate through all loadout.descriptions for a given aircraft type
								
								if loadout.day == nil then
									loadout.day = true
								end
							
								if (Daytime == "day" and loadout.day) or (Daytime == "night" and loadout.night) or (Daytime == "night-day" and (loadout.day or loadout.night)) or (Daytime == "day-night" and (loadout.day or loadout.night)) then	--loadout works for current time of day
									local passCountry = false
									if not loadout.country then 
										passCountry = true
									else
										if type(loadout.country) == "table" then
											for i = 1, #loadout.country do
												if loadout.country[i] == unit[n].country then
													passCountry = true
												end
											end
										else
											if loadout.country == unit[n].country then passCountry = true end
										end
									end
 
									if passCountry then	--loadout is country unspecific or applies to unit country
										
										-- if task == "AWACS" then												--if loadout is AWACS
										-- 	local entry = {													--define Fighterthreats table entry
										-- 		name = unit[n].name,										--unit name
										-- 		class = "AWACS",											--class
										-- 		x = db_airbases[unit[n].base].x,							--unit homebase position
										-- 		y = db_airbases[unit[n].base].y,
										-- 		level = 0,
										-- 		range = loadout.range + 600000,								--AWACS surveilance radius = AWACS mission range + radar range,
										-- 		elevation = 30000,
										-- 		min_alt = 0,
										-- 		max_alt = 30000,
										-- 	}

											-- table.insert(ewr[side], entry)
										if task == "Escort" then											--if loadout is CAP
											local entry = {													--define Fighterthreats table entry
												name = unit[n].name,										--unit name
												type =  unit[n].type,
												class = "CAP",												--class
												x = db_airbases[unit[n].base].x,							--unit homebase position
												y = db_airbases[unit[n].base].y,
												-- level = loadout.capability * loadout.firepower * (unit[n].roster.ready / 3),		--total unit threat is capability * firepower * one third of ready aircraft
												level =  loadout.firepower * (unit[n].roster.ready / 3),
												range = loadout.range,										--Fighter action radius
												LDSD = loadout.LDSD,										--Look Down/Shoot Down
											}

											table.insert(Fighterthreats[sideName], entry)
											-- print("AtoTE J table.insert Escort")

										elseif task == "Fighter Sweep" then											--if loadout is CAP
											local entry = {													--define Fighterthreats table entry
												name = unit[n].name,										--unit name
												type =  unit[n].type,
												class = "CAP",												--class
												x = db_airbases[unit[n].base].x,							--unit homebase position
												y = db_airbases[unit[n].base].y,
												-- level = loadout.capability * loadout.firepower * (unit[n].roster.ready / 3),		--total unit threat is capability * firepower * one third of ready aircraft
												level =  loadout.firepower * (unit[n].roster.ready / 3),
												range = loadout.range,										--Fighter action radius
												LDSD = loadout.LDSD,										--Look Down/Shoot Down
											}

											table.insert(Fighterthreats[sideName], entry)
											-- print("AtoTE J table.insert Fighter Sweep")

										elseif task == "CAP" then											--if loadout is CAP
											local entry = {													--define Fighterthreats table entry
												name = unit[n].name,										--unit name
												type =  unit[n].type,
												class = "CAP",												--class
												x = db_airbases[unit[n].base].x,							--unit homebase position
												y = db_airbases[unit[n].base].y,
												-- level = loadout.capability * loadout.firepower * (unit[n].roster.ready / 3),		--total unit threat is capability * firepower * one third of ready aircraft
												level =  loadout.firepower * (unit[n].roster.ready / 3),
												range = loadout.range,										--Fighter action radius
												LDSD = loadout.LDSD,										--Look Down/Shoot Down
											}

											table.insert(CAPthreats[sideName], entry)
											table.insert(Fighterthreats[sideName], entry)
											-- print("AtoTE J table.insert CAP")

										elseif task == "Intercept" then										--if loadout is Intercept
											local entry = {													--define Fighterthreats table entry
												name = unit[n].name,										--unit name
												type =  unit[n].type,
												class = "Intercept",										--class
												x = db_airbases[unit[n].base].x,							--unit homebase position
												y = db_airbases[unit[n].base].y,
												-- level = loadout.capability * loadout.firepower * (unit[n].roster.ready / 3),		--total unit threat is capability * firepower * one third of ready aircraft
												level =  loadout.firepower * (unit[n].roster.ready / 3),
												range = loadout.range,										--Fighter action radius
											}

											table.insert(Fighterthreats[sideName], entry)
											-- print("AtoTE J table.insert Intercept")
											
										end
									end
								end
							end
						end
					else
						-- print("AtoTE Not loadout find for "..unit[n].type.." in UTIL_db_loaouts file OR code_loadout OR Init\db_loaouts "..tostring(task))
						
					end
				end
			end
		end
	end
end


local cap_threatsSort = {
	blue = {},
	red = {},
}

for side, threats in pairs(CAPthreats) do
	for key, value in ipairs(threats) do
		if value.class == "CAP" then
			table.insert(cap_threatsSort[side], value)
		end

	end
end
table.sort(cap_threatsSort["blue"], function(a,b) return a.level > b.level  end)
table.sort(cap_threatsSort["red"], function(a,b) return a.level > b.level  end)

--find AWACS, CAP and interceptors in aircraft units and populate ewr/Fighterthreats table
for side, targets in pairs(targetlist) do																--iterate through all sides
	for targetN, target in pairs(targets) do
		if target.task == "AWACS" and target.inactive ~= true  then		--if unit is active and has ready aircraft and its airbase is active

			local entry = {													--define Fighterthreats table entry
				name = tostring(target.titleName),										--unit name
				class = "AWACS",											--class
				x = target.x,
				y = target.y,
				level = 0,
				range =  650000,
				elevation = 50000,
				min_alt = 0,
				max_alt = 40000,
			}

			table.insert(EWR_DB[side], entry)

		elseif  target.task == "CAP" and target.inactive ~= false then											--if loadout is CAP
			if cap_threatsSort[side] and cap_threatsSort[side][1] then
				local entry = {													--define Fighterthreats table entry
					name = tostring(target.titleName),										--unit name
					class = "CAP",												--class
					info  = "AddCAP by target position",
					x = target.x,
					y = target.y,
					level =  cap_threatsSort[side][1].level,
					range = target.radius,										--Fighter action radius
					LDSD = cap_threatsSort[side][1].LDSD,										--Look Down/Shoot Down
				}

				table.insert(Fighterthreats[side], entry)
			end
		end
	end
end



-- _affiche(Fighterthreats, "ATO_TE Fighterthreats")
--add avoidance zones to threattable
for zone_n,zone in pairs(mission.triggers.zones) do												--iterate through all trigger zones
	if string.find(zone.name, "AvoidanceZone") then												--zone is named as avoidance zone

		local threatentry = {																	--define threattable entry
			type = "TriggerZone",
			class = "AvoidanceZone",
			level = 1000,
			SEAD_offset = 0,
			x = zone.x,
			y = zone.y,
			range = zone.radius,
			night = true,
			elevation = 20000,
		}

		if string.find(zone.name, "Blue") then													--Blue avoidance zone is a threat to blue
			if string.find(zone.name, "Low") then												--Low level
				threatentry.min_alt = 0
				threatentry.max_alt = 3000
				table.insert(groundthreats.red, threatentry)
			elseif string.find(zone.name, "High") then											--High level
				threatentry.min_alt = 3000
				threatentry.max_alt = 30000
				table.insert(groundthreats.red, threatentry)
			else																				--Low and high level
				threatentry.min_alt = 0
				threatentry.max_alt = 30000
				table.insert(groundthreats.red, threatentry)
			end
		elseif string.find(zone.name, "Red") then												--Red avoidance zone is a threat to red
			if string.find(zone.name, "Low") then												--Low level
				threatentry.min_alt = 0
				threatentry.max_alt = 3000
				table.insert(groundthreats.blue, threatentry)
			elseif string.find(zone.name, "High") then											--High level
				threatentry.min_alt = 3000
				threatentry.max_alt = 30000
				table.insert(groundthreats.blue, threatentry)
			else																				--Low and high level
				threatentry.min_alt = 0
				threatentry.max_alt = 30000
				table.insert(groundthreats.blue, threatentry)
			end
		else																					--Undefined avoidance zone is a threat to red and blue
			if string.find(zone.name, "Low") then												--Low level
				threatentry.min_alt = 0
				threatentry.max_alt = 3000
				table.insert(groundthreats.red, threatentry)
				table.insert(groundthreats.blue, threatentry)
			elseif string.find(zone.name, "High") then											--High level
				threatentry.min_alt = 3000
				threatentry.max_alt = 30000
				table.insert(groundthreats.red, threatentry)
				table.insert(groundthreats.blue, threatentry)
			else																				--Low and high level
				threatentry.min_alt = 0
				threatentry.max_alt = 30000
				table.insert(groundthreats.red, threatentry)
				table.insert(groundthreats.blue, threatentry)
			end
		end
	end
end

GroundthreatsAll = Deepcopy(groundthreats)

function CheckPointInCercle(point, circle)
	--(x-center_x)^2 + (y - center_y)^2 < radius^2
	if not point or not circle or not point.x or not circle.x then
		return false
	end
	local distance = math.pow(point.x - circle.x, 2) + math.pow(point.y - circle.y, 2)
	if distance < math.pow(circle.range, 2)  then
		return true
	else
		return false
	end
end

local sumCercleSAM = #groundthreats["blue"]
sumCercleSAM = sumCercleSAM + #groundthreats["red"]

--supprime les cercles dans les cercles pour eviter d'en avoir beaucoup beaucoup
if sumCercleSAM >= reduceCercle then
	local copyThreats = Deepcopy(groundthreats)
	for sideThreat, threats in pairs(groundthreats) do
		for n=#threats-1, 2, -1 do
			for copyThreats_n, copyThreat in pairs(copyThreats[sideThreat]) do
				if  threats[n] and threats[n].x and threats[n].range < 10000  then
					local allIn = true
					for r=0, 360, 90 do
						local testPoint = GetOffsetPoint(threats[n], r, threats[n].range)
						if not CheckPointInCercle(testPoint, copyThreat) then
							allIn = false
							break
						end
					end

					if allIn then
						-- print("AtoTE remove "..tostring(threats[n].type))
						table.remove(threats, n)
					end
				end
			end
		end
	end
end




if Debug.debug then
	local camp_str = "threatgroundthreats_AtoTE = " .. TableSerialization(groundthreats, 0)						--make a string
	local campFile = io.open("Debug/threat_groundthreats_AtoTE.lua", "w") or error("Failed to open debug file")
	campFile:write(camp_str)															--save new data
	campFile:close()


	camp_str = "threatgroundthreatsALL_AtoTE = " .. TableSerialization(GroundthreatsAll, 0)						--make a string
	campFile = io.open("Debug/threat_groundthreatsALL_AtoTE.lua", "w") or error("Failed to open debug file")
	campFile:write(camp_str)															--save new data
	campFile:close()

	camp_str = "GCI_AtoTE = " .. TableSerialization(GCI, 0)						--make a string
	campFile = io.open("Debug/threat_GCI_AtoTE.lua", "w") or error("Failed to open debug file")
	campFile:write(camp_str)															--save new data
	campFile:close()


	camp_str = "Fighterthreats_AtoTE = " .. TableSerialization(Fighterthreats, 0)						--make a string
	campFile = io.open("Debug/threat_Fighterthreats_AtoTE.lua", "w") or error("Failed to open debug file")
	campFile:write(camp_str)															--save new data
	campFile:close()

	camp_str = "EWR_DB = " .. TableSerialization(EWR_DB, 0)						--make a string
	campFile = io.open("Debug/EWR_DB_AtoTE.lua", "w") or error("Failed to open debug file")
	campFile:write(camp_str)															--save new data
	campFile:close()

	if #Fighterthreats["blue"] == 0 then
		print("AtoTE pas de menace air BLue? ^^")
		os.execute 'pause'
	end
	if #Fighterthreats["red"] == 0 then
		print("AtoTE pas de menace air red? ^^")
		os.execute 'pause'
	end

end

