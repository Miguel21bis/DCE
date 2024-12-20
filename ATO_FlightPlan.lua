--To create the flight plans in the mission file for all flights in the ATO
--Initiated by Main_NextMission.lua
------------------------------------------------------------------------------------------------------- 
-- last modification: cleancode_n Debug_y
if not versionDCE then versionDCE = {} end
versionDCE["ATO_FlightPlan.lua"] = "1.58.283"
------------------------------------------------------------------------------------------------------- 

-- SomethingSimple_a		(a add randomizeSkills)
													-- (deprecate) Eagle_01 Modification E02_a		I16 and A-4e
-- Eagle_01 Modification E01_c

-- mouvedOption_CM_01_c		(c: manage les options de west callSign) (b: previent le CampaignMaker d'une nation manquante)
-- adjustment_Aa            	(y AddPropAircraft for all)(x largage d urgence if not heli)(CVN to CV)(t adjustment_e)(s No ATE if antiShip + B52 ASM)(r dont prune target mission)(q id_task)(modified jettison)(O escort Transport)(n is_helicopter)(m: less fuel for Tanker/Awacs already in the area)(l AltitudeFloor helicopter)(k landing after spawn)(j cheat_Mod_Eye)(i: skin: evite le bug table vide)(h: spawnAir +30s)(e: customScript on IP)(d: ajuster à 0 l'alti des joueurs Attack Landing) (b: ATO_lock sur les xpt Join) (ag: ne pas larguer les emports en cas d'urgence)
-- cleancode_n				(n springCleaning)
-- Debug_y					(y polka on parking)(x frequency SA342)(w no recalculates all speeds)(v formation heli)(u activate*2)(t wpt speed eta)(s pilotEjected n) (r callsign_eastbug, thks ldnz)(o DeactivateBeacon MPRS)(n Tacan Tanker)(m TACAN)(l: fromParking MP)(k:etagement des roles)(j:landing task transport sur la base de destination )(i:gestion des apparitions décalé au sol et en vol)(h:vi trop faible pour les escorteurs des strike trop lent)(g:MP, alti vi unite)(f:strike ASM B52)(e:Escorte)(d:Gun = 0 uniquement sur un Flight)(c:Antiship strike)(b: Interceptor error nb trigger) (a: alti flight ai en multijoueur)

-- modification M78_a		LatLon positions added and unit display removed on MAP F10 (a LL_KnownPositionsTable)
-- modification M74_a		mix static, vehicle and map elements in a Target.
-- modification M71_a		PayloadRestricted
-- modification M68_a		add AFAC task
-- modification M67_a		add 2.9 datalinks dataCartridge
-- modification M66_a		add Runway Attack
-- modification M65_a		add AirGroundAttackTask Mbot s file
-- modification M63_a		compatible Datacard Generator or CombatFlite
-- modification M61_k		SAR (k use parkAlertSAR for all Heli)(j bug parkAlertSAR.occupied)(debug SAR on CV)(f radio_start)(d theatre)
-- modification M60_c		add CTLD (c load_CTLD option)(b bug vehicul)(a JTAC)
-- modification M58_a		flight plan, heading, Dist, ETE
-- modification M56_b		AssignCallnameSquad (b: callsignId)
-- modification M54_d		revoir CustomTaskScript et TaskBombing (c: "Guided bombs 268402702)(b: debug No XY)
-- modification M53_b		automatic update of the conf_mod file (b conf_mod reconfiguration)
-- modification M52_b		campaign player's choices  (b: difficulté de campagne)(a: durée de la campagne)
-- modification M47_c		Keeps the history of the campaign files (c: save debugging information during mission generation)
-- modification M46_f		SinglePlayer with dedicated server (f: set up the server correctly for sixpack)(d: MP spawnTime =0) ((c: D choice with AI AirSpawn) )
-- modification M45_s		Compatible with 2.7.0 (pqrs: debug deck)(o: bug spawnAir MP)(m: trigger)(l: debug Deck)(k: delayed landing before first catapults)(j: E2 S3 on catapult)(i: debug Deck)(h: player On Sixpack)(g: taxiing timetable)(f: activate true) (e: order of spawn on Deck)(c: IA catapult First)(b: F14 catapult)
-- modification M43_c		Assignment of parking numbers of type C08 (b: ("1.38.106") assignment of parking with a simple numbering )
-- modification M42_b		LiveryModex
-- modification M40_i		Pedro Helicopter (i use new follow task)
-- modification M38_e		Check and Help CampaignMaker (e: loadout Task?)
-- modification M34_Bj		Custom FrequenceRadio (j inheritedType)(i: FreqCapability2 et bug freqence invalid)(g group Frequency canal1 radio1)(f more Divert, more Coalition, bug list Freq)(Be sautomatically selects the correct range ex Mig19)(Bd bug Guard)
-- modification M33_k		Custom Briefing (k debug MP)(j debug Client)(h: debug)(g: not airbase)(f: Divert/CV possible)(d: Divert)(c: Alignement du txt)(onBoardNum)
-- modification M31			Remove all static aircraft from the deck
-- modification M30_b		Desactive TriggerStart
-- modification M27_d		movedBullseye (d: selectedBullseye in db_airbases)(c: does not include carriers)
-- modification M24			Set Multiplayer 
-- modification M23			Désactive USN Mod 
-- modification M20_b		Pannes aléatoires (Failures) en SingleMission et ForcedOption (external view etc..) (b failure adapted to each aircraft type)
-- modification M18_e		(e: un avion BaseAirStart peu se poser sur une base)Despawn/destroy Plane on BaseAirStart
-- modification M17_g		Option F-14B & All AddPropAircraft (g rewriting NavTargetPoints)
-- Modification M15_e		Info catapulte/pont dans briefing (e info departure à toutes les bases)
-- modification M14_b		Versionning (b:"1.38.107")
-- modification M12_c		Skill (c: moved skill table)
-- modification M11B_c		Multiplayer--briefing	(c: info flight if MP)
-- modification M11A_b_l	Multiplayer (l distance btw 2 & 3)(duplicate groupName)(i ATTENTION MANQUE Start)(bh recovery wpt 2&3)(z nbrecovery)(y: force same package)(vwx: spawn intercepteur)(u: spawn in wpt 2)(ba t: AltitudeFloor)(s: F14 no limited to 2) (r: notRecovery for Inter)(q: take recovery plane)
-- modification M08_c		Hotstart  --||initialement ((départ de la piste + debug hotstart + intercepteur CV))(c: debug)
-- modification M06_i		Helicoptere playable (i over speed on spawn)(g: Start From FARP & LHA & delete E01)
-- modification M03_n		Parking assignment CV LHA FARP & shift the spawn (n debug limitedParking)(m: debug helico/FARP)(l: best check)(k: check place parking dispo en fonction des minutes)(i: Parking limite little base)
-- modification M01_b		Ajout datalink (b: UTIL_Data file)
------------------------------------------------------------------------------------------------------- 	



DebugFLIGHT = ""
TabLPark	= {}
TargetList_InThisMission = {}			-- garde en mémoire les targets pour eviter de les pruner plus tard

local debugStart = true					--NE PAS CHANGER, les infos restent seulement dans le fichier debugGenMission
local debugTxt_AtoFP = ""
local tabCallSignFligt = {}
local tabDivert = {}					-- modification M33.c 	Custom Briefing (onBoardNum)	
local PlayerTask = ""
local tempBaseAirStart = {}
local tempDeckPlace = {}
local testDeckPlace = {}
local altRole = 0
local mn_StartParking = 5 				--[en minute] 5 mn de temps de presence sur parking
local ParkSarAirBase = {}				--reprend la table db_airbases[basename].parkAlertSAR
local is_helicopter
local baseIsFARP
local baseIsCarrier
local allFlightName_AtoFP = {}

local polkaOff = true					--evite la dance des aeronefs sur le parking (Inter et SAR compris)

if not camp.SAR then camp.SAR = {} end
camp.SAR.helicopter = {}


if Multi.NbGroup >= 1 then


	mission_ini.PruneScript = true							-- reduce a mission by removing units (mod Tomsk M09) [MP: recommend: true]					PruneAggressiveness = 1.5,					-- How aggressive should the pruning be [0 to 2], larger numbers will remove more units, 0 = no pruning at all
	mission_ini.PruneStatic = true							-- Should ALL parked (static) aircraft be pruned [MP: recommend: true]
	-- mission_ini.ForcedPruneSam = true						-- PBO-CEF avait pr�vu de garder des SAM actif, cette option les d�sactives tout de m�me [MP: recommend: true]
	mission_ini.failure = false								-- (true or false) modification M20 [MP: recommend: false]
	-- mission_ini.ravitoByConvoy = false					-- [non encore fonctionnel] ravitaillement par convoy routier 
	mission_ini.Keep_USNdeckCrew = false					-- false = supprime US Navy deck crew dans la g�n�ration de mission. Miguel Modification M23
	mission_ini.CV_CleanDeck = true 							-- true: Remove all static aircraft from the deck. ( M31 )

	-- Force vos propres options plutot que ceux de base_ini.miz, qui correspondent � ceux de PBO-CEF ^^
	if not mission.forcedOptions then mission.forcedOptions = {} end
	mission.forcedOptions.accidental_failures =  false
	mission_forcedOptions.wakeTurbulence = false			-- False / true : turbulence  [MP: recommend: false]
	mission_forcedOptions.civTraffic = ""					-- Traffic civil routier : ( "" : OFF ) || ( "low" : BAS ) || ( "medium" : MOYEN )|| ( "high" : ELEVE )  [MP: recommend: ""]
	mission_forcedOptions.birds = 0							-- Collision volatile (probabilit�) ( 0 � 1000 )  [MP: recommend: 0]

end

----- Desactive USN Mod -----modification M23
if not mission_ini.Keep_USNdeckCrew then
	mission.requiredModules = {
		['USN-Deckcrew'] = nil,
	}
end

-- ["requiredModules"] = 
-- {
-- 	["Hercules"] = "Hercules",
-- }, -- end of ["requiredModules"]

if mission.requiredModules then
	for nameN, module in pairs(mission.requiredModules) do
		local entry = {
			["name"] = tostring(nameN),
			["origine"] = {
				"base_mission.miz  ",
			}
		}
		if ListRequiredModules[nameN] then
			table.insert(ListRequiredModules[nameN].origine, "base_mission.miz  " )
		else
			ListRequiredModules[nameN] = entry
		end
	end
end

--desactive la reservation pour ne pas perturber une boucle de refus de mission
for k=1, Multi.NbGroup do
	Multi.Group[k].assigned  = false
end

----- Ajoute les pannes aleatoires en SingleMission -----modification M20
for option, value  in pairs(mission_forcedOptions) do								-- ajoute les options du jeux
	if not mission.forcedOptions then mission.forcedOptions = {} end
	mission.forcedOptions[option] =  value
end

-- inheritedFrom
local type_withData_player = PlayerSquad.type
if Data_divers and Data_divers[PlayerSquad.type] and Data_divers[PlayerSquad.type].inheritedFrom then
	type_withData_player = Data_divers[PlayerSquad.type].inheritedFrom
end


if mission.failures and Failures and Failures[type_withData_player] then
	mission.failures = {}

	-- ["A11_CLOCK_FAILURE"] = 
	-- {
	-- 	["enable"] = false,
	-- 	["hh"] = 0,
	-- 	["id"] = "A11_CLOCK_FAILURE",
	-- 	["mm"] = 0,
	-- 	["mmint"] = 1,
	-- 	["prob"] = 100,
	-- },
	-- ["AAR_47_FAILURE_SENSOR_BOTTOM"] = 
	-- {
	-- 	["enable"] = false,
	-- 	["hh"] = 0,
	-- 	["id"] = "AAR_47_FAILURE_SENSOR_BOTTOM",
	-- 	["mm"] = 0,
	-- 	["mmint"] = 1,
	-- 	["prob"] = 100,
	-- },

	for n, failure in ipairs(Failures[type_withData_player]) do
		mission.failures[failure] = {
			["enable"] = false,
			["hh"] = 0,
			["id"] = tostring(failure),
			["mm"] = 0,
			["mmint"] = 1,
			["prob"] = 100,
		}
	end
end



if mission_ini.failure then										-- not multiplayer --	if mission_ini.failure and not Multi.NbGroup then	

	-- ajoute accidental_failures = true � forcedOptions
	if not mission.forcedOptions then mission.forcedOptions = {} end
	mission.forcedOptions.accidental_failures =  true


	local n= 1
	for _id, failure in pairs(mission.failures) do
		n = n+1
	end

	for f = 1, mission_ini.failureNbMax do

		local hh = math.random(0, 1)
		local mm = math.random(1, 59)
		local prob = math.random(1, mission_ini.failureProbMax)
		local mmint = math.random(1, 59)
		local id_failed = math.random(1, n-1)

		local m = 1
		for _id, failure in pairs(mission.failures) do

			if id_failed == m then
				if not mission.failures[_id] then print("NotFailureId") end
				if not mission.failures[_id]['hh'] then print("NotFailureHh") end
				mission.failures[_id]['hh'] = hh
				mission.failures[_id]['mm'] = mm
				mission.failures[_id]['prob'] = prob
				mission.failures[_id]['enable'] = true
				mission.failures[_id]['mmint'] = mmint
				if Debug.AfficheFailure then print("PossibleFailure ".._id.." "..hh.."H"..mm.." ".." Duration "..mmint.." Probability: "..prob) end
			end
			m = m+1
		end
	end
end

----- function to create callsigns for aircraft in ATO -----
local Callsign_west_counter = {
generic = math.random(1, #Callsign_west.generic ),
AWACS = math.random(1, #Callsign_west.AWACS ),
tanker = math.random(1, #Callsign_west.tanker),
}
local callsign_east_counter = 0


CommonFreq = {
	blue = {
		UHF = {
			[1] = 0,
			[2] = 0,
		},
		VHF = {
			[1] = 0,
			[2] = 0,
		},
		LVHF = {
			[1] = 0,
			[2] = 0,
		},
		HF = {
			[1] = 0,
			[2] = 0,
		},
	},
	red = {
		UHF = {
			[1] = 0,
			[2] = 0,
		},
		VHF = {
			[1] = 0,
			[2] = 0,
		},
		LVHF = {
			[1] = 0,
			[2] = 0,
		},
		HF = {
			[1] = 0,
			[2] = 0,
		},
	},
	neutrals = {
		UHF = {
			[1] = 0,
			[2] = 0,
		},
		VHF = {
			[1] = 0,
			[2] = 0,
		},
		LVHF = {
			[1] = 0,
			[2] = 0,
		},
		HF = {
			[1] = 0,
			[2] = 0,
		},
	},
}

--DCS_Side = {"blue", "red", "neutrals"}
--commun frequence M34_
for sideName, side in pairs(DCS_Side) do
	CommonFreq[side]["UHF"][1] = GetFrequency(side, nil, "coalition", nil, "UHF")
	CommonFreq[side]["UHF"][2] = GetFrequency(side, nil, "coalition", nil, "UHF")

	CommonFreq[side]["VHF"][1] = GetFrequency(side, nil, "coalition", nil, "VHF")
	CommonFreq[side]["VHF"][2] = GetFrequency(side, nil, "coalition", nil, "VHF")

	CommonFreq[side]["HF"][1] = GetFrequency(side, nil, "coalition", nil, "HF")
	CommonFreq[side]["HF"][2] = GetFrequency(side, nil, "coalition", nil, "HF")

	CommonFreq[side]["LVHF"][1] = GetFrequency(side, nil, "coalition", nil, "LVHF")
	CommonFreq[side]["LVHF"][2] = GetFrequency(side, nil, "coalition", nil, "LVHF")

	for n=1, 2 do
		local testFreqency = tonumber(CommonFreq[side]["UHF"][n])
		if tonumber(CommonFreq[side]["UHF"][n]) == 243 or tonumber(CommonFreq[side]["UHF"][n]) == 121.5 then
			print("ATTENTION GUARD Frequence Commune "..tostring(testFreqency))
			os.execute 'pause'
		end
	end
end

-- modification M40 : Pedro Helicopter
-- Supprime les anciens Pedro
for i=1, 4 do
	for coalition_name, coal in pairs(mission.coalition) do
		for country_n, country in pairs(coal.country) do
			if country.helicopter then
				for group_n, group in pairs(country.helicopter.group) do
					if group and group.units and #group.units >= 1 then
						for w = 1, #group.units do
							if (group.units[w].name and group.units[w].name and string.find(group.units[w].name, "Pedro_"))
								or
								(group.name  and string.find(group.name, "Pedro_"))
								then
									table.remove(country.helicopter.group, group_n)
							end
						end
					end
				end
			end
		end
	end
end


local function GetCallsign(country, flight_n, aircraft_n, task, flight_)
	local style
	local callsign_flight = 0
	local testCall = ""
	local callsign_nb = 0
	local _name = ""
	local foundCsf = false

	local westernCountry = IsWesternCountry(country)

	-- if  WestCallsign[country] == "west" then
	if westernCountry then
		style = "west"
	else
		style = "east"
	end

	local callsign
	if style == "west" then
		local category
		if task == "AWACS" then
			category = "AWACS"
		elseif task == "Refueling" then
			category = "tanker"
		else
			category = "generic"
		end

		--M56_b
		--si le callsign à déjà été défini par AssignCallnameSquad() ou oob_air_init
		if flight_ and flight_["callsign"] and flight_["callsignId"]  then

			if aircraft_n == 1 then

				local ii = 1
				repeat
					callsign_flight = math.random(1, 9)
					testCall = flight_["callsign"]..callsign_flight
					if not tabCallSignFligt[testCall] then
						tabCallSignFligt[testCall] = true
						foundCsf = true
						break
					end
					ii = ii + 1
				until ii > 30 or foundCsf
				--si le random non tuilé ne fonctionne pas, tant pis, on prend au pif
				if not foundCsf then
					callsign_flight = math.random(1, 9)
					testCall = flight_["callsign"]..callsign_flight
					tabCallSignFligt[testCall] = true
				end
				-- callsign_flight = math.random(0, 8)			
				-- callsign_flight = callsign_flight + 1
				-- if callsign_flight > 9 then
					-- callsign_flight = 1
				-- end							
			end
			callsign_nb = flight_["callsignId"]
			_name = flight_["callsign"] .. callsign_flight .. aircraft_n

		else
			if flight_n == 1 and aircraft_n == 1 then
				Callsign_west_counter[category] = Callsign_west_counter[category] + 1
				if Callsign_west_counter[category] > #Callsign_west[category] then
					Callsign_west_counter[category] = 1
				end
				callsign_flight = math.random(0, 8)
			end

			if aircraft_n == 1 then
				if not callsign_flight then
					print()
					print("********************ATTENTION******************")
					print("***************Note for the Campaign Maker*****The nation of a previous aircraft misfiled in the table  conf_mod/campMod.WestCallsign or ATO_FlightPlan/country****************")
					print("********************ATTENTION******************")
					print()
					os.execute 'pause'
				end

				local ii = 1
				repeat
					callsign_flight = math.random(1, 9)

					if not Callsign_west[category] or not Callsign_west_counter[category] or not Callsign_west[category][Callsign_west_counter[category]] then

						print("AtoFp Error GetCal..callsign: "..tostring(category))
						_affiche(Callsign_west , "Callsign_west")

						_affiche(Callsign_west_counter, "Callsign_west_counter ")

						os.execute 'pause'
					end


					testCall = Callsign_west[category][Callsign_west_counter[category]]..callsign_flight
					if not tabCallSignFligt[testCall] then
						tabCallSignFligt[testCall] = true
						foundCsf = true
						break
					end
					ii = ii + 1
				until ii > 1 or foundCsf

				--si le random non tuilé ne fonctionne pas, tant pis, on prend au pif
				if not foundCsf then
					callsign_flight = math.random(1, 9)
					-- testCall = flight_["callsign"]..callsign_flight
					testCall = Callsign_west[category][Callsign_west_counter[category]]..callsign_flight
					tabCallSignFligt[testCall] = true
				end
				-- callsign_flight = callsign_flight + 1
				-- if callsign_flight > 9 then
					-- callsign_flight = 1
				-- end
			end

			callsign_nb = Callsign_west_counter[category]
			_name = Callsign_west[category][Callsign_west_counter[category]] .. callsign_flight .. aircraft_n

		end

		callsign = {
			[1] = callsign_nb,
			[2] =  callsign_flight,
			[3] =  aircraft_n,
			name = _name
		}

	else
		if aircraft_n == 1 then
			callsign_east_counter = callsign_east_counter + 1
		end
		callsign = 90 + callsign_east_counter * 10 + aircraft_n

		-- --Mod_ldnz
		-- if aircraft_n == 1 then
		-- 	callsign_east_counter = callsign_east_counter + 1
		-- end

		-- local callsign_temp = 90 + callsign_east_counter * 10 + aircraft_n
		-- print("FIXING UP Callsign " .. callsign_temp)
		-- local hundreds = math.floor(callsign_temp / 100)
		-- local tens = math.floor((callsign_temp % 100) / 10)
		-- local ones = math.floor(callsign_temp  % 10)
		-- print("Got " .. hundreds .. " " .. tens .. " " .. ones)

		-- callsign = {
		-- 	[3] = hundreds,
		-- 	[2] = tens,
		-- 	[1] = ones,
		-- 	name = ""
		-- }
	end

	if callsign == nil then
		-- print("AtoFP ERROR callsign == nil , style: "..tostring(style).." country: "..tostring(country) .." WestCallsign: "..tostring(WestCallsign[country]) )
		print("AtoFP ERROR callsign == nil , style: "..tostring(style).." country: "..tostring(country)  )
		os.execute 'pause'
	end
	return callsign
end


---- function to get sidenumbers -----
local sidenumbers = {}

function GetSidenumber(squadron, lower, upper, nUnit, player, type)				--not local, also used in DC_StaticAircraft
	if sidenumbers[squadron] == nil then										--sidenumber squadron entry does not exist
		sidenumbers[squadron] = {}												--create sidenumber squadron entry
	end
	local upperNum = tonumber(upper)
	local lowerNum = tonumber(lower)
	local s 																		--new sidenumber
	local counter = 0

	--cherche si le joueur fait partie de cet escadron
	local reservedDigit = 0
	oob_air = oob_air or {}
	for side_name,side in pairs(oob_air) do
		for n,unit in pairs(side) do
			if unit.name == squadron and unit.player  then
				reservedDigit = 1												--ajoute un chiffre pour les IA, exemple 200+1 pour l'ia, 200 etant reservé au joueur
			end
		end
	end
	-- modification M42.b : liveryModex
	local leaderCheck															--on s assure que le num 200 (par exemple) est donné au leader et pas un ailier
	if player and nUnit == 1 then
		s = lowerNum
	else
		if lowerNum and upperNum then
			repeat
				leaderCheck = true
				counter = counter + 1
				s = math.random(lowerNum +reservedDigit, upperNum)		--find random sidenumber

				if nUnit == 1 and tonumber(string.sub (s, -1)) ~= 0 and not sidenumbers[squadron][lower]  then	--on s assure que le num 200 (par exemple) est donné au leader et pas un ailier
					leaderCheck = false
				end

			until (sidenumbers[squadron][s] == nil and leaderCheck)	or counter == 100	--repeat until a sidenumber is found that is not yet in squadron use or stop after 100 tries
		end

		--le script n'a pas trouvé de serial non libre
		if counter >= 100 then

			local totSerial = {}
			for n= lowerNum, tonumber(upper) do								--creation de la table de tous les serial
				totSerial[n] = false
			end

			for n, squad in pairs(sidenumbers[squadron]) do						--suppresion de la table totale des seriales déjà utilisé
				for totN, value in pairs(totSerial) do								--liste la table totale
					if n == totN then												--marque les serial dejà utilisé
						totSerial[totN] = true
					end
				end
			end

			for totN, value in pairs(totSerial) do									--prend le premier serial libre
				if totSerial[totN] == false then
					s = totN
					break
				end
			end
		end

	end

	if s and s ~= nil then
		sidenumbers[squadron][s] = true													--mark sidenumber in use for squadron
	end
	-- particularité du Harrier : donner 810 pour afficher 18
	local s_str = tostring(s)
	if type == "AV8BNA" then
		local Digit_1 = string.sub(s_str, -1, -1)
		local Digit_2 = string.sub(s_str, -2, -2)
		s = tonumber(Digit_1..Digit_2.."0")
		s = string.format("%03d", s)
	else
		local lNew = string.len(s_str)													--lenght of new sidenumber
		local lOld = string.len(lower)												--lenght of given lower end of sidenumbers
		for n = lNew, lOld - 1 do													--for each character that new sidenumber is smaller than given lower ranger
			s = "0" .. s_str															--add a zero in front
		end
	end

	return tostring(s)															--return sidenumber as string
end


---- function to get datalink Id -----
local pack_L16_unitId = {}		--permet de retrouver tous les unitId participant à un package
local STN_L16_Id = {}
local function Get_L16_Id()
	local i = 0
	local preTest = "002"
	local testId = "00001"

	repeat
		i=i+1
		local digit4 = math.random(0,7)
		local digit5 = math.random(0,7)

		testId = preTest..digit4..digit5

	until STN_L16_Id[testId] == nil 	or i >= 300

	if i >= 300 then
		local preTest = "003"
		repeat
			i=i+1
			-- local digit1 = math.random(0,7)
			-- local digit2 = math.random(0,7)
			-- local digit3 = math.random(0,7)
			local digit4 = math.random(0,7)
			local digit5 = math.random(0,7)

			testId = preTest..digit4..digit5

		until STN_L16_Id[testId] == nil 	or i >= 600
	end

	if i >= 600 then
		local preTest = "00"
		repeat
			i=i+1
			-- local digit1 = math.random(0,7)
			-- local digit2 = math.random(0,7)
			local digit3 = math.random(0,7)
			local digit4 = math.random(0,7)
			local digit5 = math.random(0,7)

			testId = preTest..digit3..digit4..digit5

		until STN_L16_Id[testId] == nil 	or i >= 900
	end

	STN_L16_Id[testId] = true

	if i >= 900 then
		print("AtoFP Get_L16_Id trop long "..i.." test "..testId)
		os.execute 'pause'
	end

	return testId
end

--spécial datalink A-10
local pack_SADL_unitId = {}		--permet de retrouver tous les unitId participant à un package
local SADL_TN_Id = {}
local function Get_SADL_Id()
	local i = 0
	local preTest = "01"
	local testId = "0001"

	repeat
		i=i+1
		local digit3 = math.random(0,7)
		local digit4 = math.random(0,7)

		testId = preTest..digit3..digit4

	until SADL_TN_Id[testId] == nil 	or i >= 300


	if i >= 300 then
		print("AtoFP SADL_TN_Id trop long "..i.." test "..testId)
		os.execute 'pause'
	end

	return testId
end


--spécial datalink AH-64
local pack_IDM_unitId = {}
local IDM_Id = {}

local function Get_IDM_Id()
	local i = 0

	local testId = "1"

	repeat
		i=i+1
		local digit1 = math.random(1,39)

		testId = tostring(digit1)

	until IDM_Id[testId] == nil 	or i >= 300


	if i >= 300 then
		print("AtoFP IDM_Id trop long "..i.." test "..testId)
		os.execute 'pause'
	end

	return testId
end

--liste tous les Fréquence déjà existantes pour ne pas creer de doublon
for basename, base in pairs(db_airbases) do
	if base.ATC_frequency and base.ATC_frequency ~= "" and type(base.ATC_frequency)~= "table" then
		Assigned_freq[tonumber(base.ATC_frequency)] = basename
	elseif base.ATC_frequency and type(base.ATC_frequency)== "table" then
		for n , freq in ipairs(base.ATC_frequency) do
			Assigned_freq[tonumber(freq)] = basename
		end
	else
		-- _affiche(base.ATC_frequency, "AA base.ATC_frequency")
		-- os.execute 'pause'
	end
end


---- function to assign A-A TACAN channels ----
local channel_tacan = {}																--table to store tanker TACAN channels
-- https://forums.eagle.ru/showpost.php?p=3821502&postcount=139
-- https://forums.eagle.ru/topic/199994-tacan-and-dl-last-update/
-- 37-67  ??.?

--liste tous les TACAN déjà existant pour ne pas creer de doublon
for basename, base in pairs(db_airbases) do															--iterate through airbases
	if base.TACAN then
		local tacanClean = base.TACAN
		local channel = 0
		local one, two
		if string.find(base.TACAN, "/") then
			one, two = tacanClean:match("([^,]+)/([^,]+)")
			tacanClean = one:gsub( " ", "")
		elseif string.find(base.TACAN, "-") then
			one, two = tacanClean:match("([^,]+)-([^,]+)")
			tacanClean = one:gsub( " ", "")
		end

		local test = string.sub(base.TACAN, 1, #tacanClean - 1)
		-- if test and test ~= nil then
		-- 	channel = tonumber(test)		
		-- 	channel_tacan[channel] = true			
		-- end

		-- local channel = 0
		if test and test ~= nil then
			local channel_num = tonumber(test)
			if channel_num then
				channel = channel_num
			end
		end
		channel_tacan[channel] = true

	end
end

-- _affiche(channel_tacan, "channel_tacan")
-- os.execute 'pause'

local function GetTankerTACAN()
	local channel
	repeat
		channel = math.random(37, 67)											--find random TACAN channel
	until channel_tacan[channel] == nil											--repeat until channel is found that is not in use yet

	channel_tacan[channel] = true												--mark channel in use
	return channel																--return channel
end

--Mod M27.b Randomly moves the 2 BullsEye
local function fct_movedBullseye(side, nameTheatre)

	local tempArrayBulls = {}
	local tempBullseye =
	{
		x = 0,
		y = 0,
		name = "",
	}



	if not mission_ini.movedBullseye then
		for name, base in pairs(db_airbases) do
			if base.x and not base.unitname and base.side == side then
				if base.selectedBullseye then
					tempBullseye.x = base.x
					tempBullseye.y = base.y
					tempBullseye.name = name
				end
			end
		end
	else

		for name, base in pairs(db_airbases) do
			if base.x and not base.unitname then
			-- if base.x  then
				if GetDistance(campMod.movedBullseye[nameTheatre].pos, base) <= (campMod.movedBullseye[nameTheatre].rayon * 1000) then
					db_airbases[name]["name"] = name
					table.insert(tempArrayBulls, db_airbases[name])
				end
			end
		end


		-- local i = table.getn(tempArrayBulls)
		local i = #tempArrayBulls

		if i >= 1 then
			local j = math.random(1, i)
			tempBullseye.x = tempArrayBulls[j].x
			tempBullseye.y = tempArrayBulls[j].y
			tempBullseye.name = tempArrayBulls[j].name
		end
	end

	if tempBullseye.name ~= "" and tempBullseye.x ~= 0 then
		--ajoute bullseye dans mission
		mission.coalition[side].bullseye.x = tempBullseye.x
		mission.coalition[side].bullseye.y = tempBullseye.y

		--ajoute bullseye dans briefing
		if not Brief[side].bullseye then Brief[side].bullseye = {} end
		Brief[side].bullseye.name = tempBullseye.name
		Brief[side].bullseye.x = tempBullseye.x
		Brief[side].bullseye.y = tempBullseye.y

		if LL_KnownPositionsFileExit then

			local xKey = math.abs(math.floor(tempBullseye.x))
			if LL_KnownPositions[xKey]  then
				local testX = math.floor(Brief[side].bullseye.x)
				local testY = math.floor(Brief[side].bullseye.y)
				for n, llPos in pairs(LL_KnownPositions[xKey] ) do
					if testX == llPos.x and testY == llPos.y then
						Brief[side].bullseye.lat = llPos.lat
						Brief[side].bullseye.lon = llPos.lon
						break
					end
				end
			end
		end
	end
end

--modify_activate_group_time
local function modify_activate_group_time(group, AirSpawnTime, from)

	if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe 1B modify_activate_group_time "..tostring(AirSpawnTime).." from: "..tostring(from)) end

	-- group['uncontrolled'] = true
	-- group['lateActivation'] = true --incompatible avec l'activation sur sixpack

	for trig_n = 1, #mission.trigrules  do
		if  mission.trigrules[trig_n] and mission.trigrules[trig_n].actions and mission.trigrules[trig_n].actions[1] then
			if  mission.trigrules[trig_n].actions[1].group and mission.trigrules[trig_n].actions[1].group == group.groupId then

				if AirSpawnTime == -1 then
					AirSpawnTime = 0
				end

				-- if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe 1Bb seconds (before) "..tostring(mission.trigrules[trig_n].rules[1].seconds)) end
				mission.trigrules[trig_n].rules[1].seconds = AirSpawnTime
				-- if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe 1Bc seconds (after) "..tostring(mission.trigrules[trig_n].rules[1].seconds)) end

				-- conditions[44] = 'return(c_time_after(2233.512158504) )',
				mission.trig.conditions[trig_n] = "return(c_time_after(" .. AirSpawnTime .. ") )"
				if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe 1Cc modify_activate_group_time find groupId "..group.groupId.." trig_n: "..tostring(trig_n)) end

			end
		end
	end
end

-- modification M37.l SuperCarrier (l: ajout alt et speed aux unites)(i: option deck air catapult)
--Spawn OnDeck, OnCatapult or OnAir
function SpawnOn(spawn, waypoints, group, Pn, spawnTime, from, flight, f, role)
	spawn = string.lower(spawn)

	if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe A SpawnOn() "..spawn) end

	-- ATO_FP_Debug_k
	local altRole = 0
	if role == "SEAD" then
		altRole = 1
	elseif role == "Escort" then
		altRole = 2
	end

	-- local is_helicopter = false
	-- if IsHelicopter[flight[f].type]  then
	-- 	is_helicopter = true
	-- end

	if  spawn == "air" then
		if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP spawnOair AIR from: "..tostring(from)) end
		if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP spawnOair AIR from: "..tostring(from)) end


		if waypoints[1]["alt"] <= 500 and not is_helicopter then waypoints[1]["alt"] = 500 end

		local altBase = waypoints[1]["alt"]
		if db_airbases[flight[f].base].elevation then
			altBase = db_airbases[flight[f].base].elevation
		end
		local altStep = 500
		local speed = 200
		if is_helicopter  then
			altStep = 50
			speed = flight[f].loadout.vCruise / 4 * 3
		end

		waypoints[1].action = "Turning Point"
		waypoints[1].type = "Turning Point"
		waypoints[1]["alt"] = altBase + (Pn * altStep) + (altRole * 33)
		waypoints[1]["speed"] = speed
		-- waypoints[1].ETA = spawnTime

		group.start_time = spawnTime

		if waypoints[1].helipadId then
			waypoints[1].helipadId = nil
		end
		if waypoints[1].linkUnit then
			waypoints[1].linkUnit = nil
		end

		local alt = 150

		if is_helicopter  then 											-- M6.1 sauf helicopter			
			if db_airbases[flight[f].base].elevation then							--airbase has defined elevation
				alt = alt + db_airbases[flight[f].base].elevation					--make alt above base
			end
			waypoints[1]["alt"] = alt  + (Pn * 10) + altRole * 33
		end

		for	n = 2 , #group.units do
			if not flight[f].task == "AFAC" then
				group.units[n].x = ((Pn-1) * 15) + ((f-1) * 15) + group.units[n].x + (15 * n)	--ANTI-COLLISION A
				group.units[n].y = ((Pn-1) * 15) + ((f-1) * 15) + group.units[n].y + (15 * n)
			end
			group.units[n].speed = speed

			if is_helicopter  then
				-- group.units[n]["alt"] = alt  + (Pn * 10) + altRole * 11
				group.units[n]["alt"] = waypoints[1]["alt"]
				group.units[n].speed = speed
			else
				-- group.units[n]["alt"] = waypoints[1]["alt"] + (Pn * 500) + altRole * 33
				group.units[n]["alt"] = waypoints[1]["alt"]
			end
		end

		if  spawnTime and spawnTime > 1 and Missionfunc then	--not group["TrigActivate"] and
			-- group["TrigActivate"] = true ATTENTION semble bloquer les orbite indefiniment
			group['lateActivation'] = true											--make group late activation "en vol"
			group['uncontrolled'] = false
			group['tasks'] = {}														--supprime le tasks start

			local activateGroupExist = false
			for n , trigrule in pairs(mission.trigrules) do
				if type(trigrule) == "table" then
					if trigrule.actions and trigrule.actions[1] and trigrule.actions[1].group == group.groupId then
						if trigrule.actions[1]["predicate"] == "a_activate_group" then

							activateGroupExist = true
						end
					end
				end
			end

			if not activateGroupExist then

				trig_n =  #mission.trig.actions + 1
				Missionfunc = Missionfunc + 1 																	--M11.o
				mission.trig.func[trig_n] = "if mission.trig.conditions[" .. trig_n .. "]() then mission.trig.actions[" .. trig_n .. "]() end"
				mission.trig.flag[trig_n] = true
				mission.trig.conditions[trig_n] = "return(c_time_after(" .. spawnTime .. ") )"
				mission.trig.actions[trig_n] = "a_activate_group(" .. group.groupId .. "); mission.trig.func[" .. trig_n .. "]=nil;"	-- ATO_FP_Debug02 Interceptor error nb trigger
				mission.trigrules[trig_n] = {
					['rules'] = {
						[1] = {
							["seconds"] = spawnTime,
							["predicate"] = "c_time_after",
						},
					},
					['eventlist'] = '',
					['comment'] = 'Trigger ' .. trig_n,
					['predicate'] = 'triggerOnce',
					['actions'] = {
						[1] = {
							["group"] = group.groupId,
							["predicate"] = "a_activate_group",
						},
					}
				}
				if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP SpawnOn passe activate 01") end
			end
		end

		-- remet l'horaire d'origine sur activate
		modify_activate_group_time(group, spawnTime, debug.getinfo(1).currentline)

		--supprime les avions initialement prévu sur le pont, puisque maintenant, ils spawn en vol
		local remove_n
		if testDeckPlace and  testDeckPlace[flight[f].base] then
			for n, deck in pairs(testDeckPlace[flight[f].base]) do
				if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP RemovetestDeckPlace n "..tostring(n).." "..tostring(deck["groupName"])) end

				if deck["groupName"] == flight[f].name then
					remove_n = n-1
					break
				end
			end
			table.remove(testDeckPlace[flight[f].base], remove_n)
		end


	elseif spawn == "catapult" then

		if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP spawnOair CATAPULT from: "..tostring(from)) end

		waypoints[1].action = "From Runway"
		waypoints[1].type = "TakeOff"

		waypoints[1]["alt"] = 0

		group.uncontrolled = false											-- sur cata, les F14 IA bloquent
	end

end


--activate_group_withFlag
local function activate_group_withFlag(group, flag, from)

	if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe 1H activate_group_withFlag "..tostring(flag).." from: "..tostring(from)) end

	group['uncontrolled'] = false
	group['lateActivation'] = true

	trig_n =  #mission.trig.actions + 1
	Missionfunc = Missionfunc + 1 																	--M11.o
	mission.trig.func[trig_n] = "if mission.trig.conditions[" .. trig_n .. "]() then mission.trig.actions[" .. trig_n .. "]() end"
	mission.trig.flag[trig_n] = true
	mission.trig.conditions[trig_n] = "return(c_flag_is_true(" .. flag .. ") )"
	mission.trig.actions[trig_n] = "a_activate_group(" .. group.groupId .. "); mission.trig.func[" .. trig_n .. "]=nil;"
	mission.trigrules[trig_n] = {
		['rules'] = {
			[1] = {
				["flag"] = flag,
				["predicate"] = "c_flag_is_true",
				["zone"] = "",
			},
		},
		['eventlist'] = '',
		['comment'] = 'Trigger ' .. trig_n,
		['predicate'] = 'triggerOnce',
		['actions'] = {
			[1] = {
				["group"] = group.groupId,
				["predicate"] = "a_activate_group",
			},
		}
	}


end

--activate_group_time_after
local function activate_group_time_after(group, AirSpawnTime, from)

	if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe 1B activate_group_time_after "..tostring(from)) end

	-- group['lateActivation'] = true --incompatible avec l'activation sur sixpack

	-- if not group["TrigActivate"]  then
		-- group["TrigActivate"] = true ATTENTION semble incompatible avec les orbites (infini)
		-- local trig_n = Missionfunc + #mission.trig.funcStartup + 1										--next available trigger number
		trig_n =  #mission.trig.actions + 1
		Missionfunc = Missionfunc + 1 																	--M11.o
		mission.trig.func[trig_n] = "if mission.trig.conditions[" .. trig_n .. "]() then mission.trig.actions[" .. trig_n .. "]() end"
		mission.trig.flag[trig_n] = true
		mission.trig.conditions[trig_n] = "return(c_time_after(" .. AirSpawnTime .. ") )"
		mission.trig.actions[trig_n] = "a_activate_group(" .. group.groupId .. "); mission.trig.func[" .. trig_n .. "]=nil;"	-- ATO_FP_Debug02 Interceptor error nb trigger
		mission.trigrules[trig_n] = {
			['rules'] = {
				[1] = {
					["seconds"] = AirSpawnTime,
					["predicate"] = "c_time_after",
				},
			},
			['eventlist'] = '',
			['comment'] = 'Trigger ' .. trig_n,
			['predicate'] = 'triggerOnce',
			['actions'] = {
				[1] = {
					["group"] = group.groupId,
					["predicate"] = "a_activate_group",
				},
			}
		}

	-- end
end

--Start_set_ai_task
function Start_set_ai_task(group, aiStart_spawn_time, from)

	group['uncontrolled'] = true

	if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe 1C Start_set_ai_task "..tostring(from)) end

	-- local trig_n = Missionfunc + #mission.trig.funcStartup + 1										--next available trigger number
	trig_n =  #mission.trig.actions + 1
	Missionfunc = Missionfunc + 1
	mission.trig.func[trig_n] = "if mission.trig.conditions[" .. trig_n .. "]() then mission.trig.actions[" .. trig_n .. "]() end"
	mission.trig.flag[trig_n] = true
	mission.trig.conditions[trig_n] = "return(c_time_after(" .. aiStart_spawn_time .. ") )"
	mission.trig.actions[trig_n] = "a_set_ai_task(" .. group.groupId .. ", 1); mission.trig.func[" .. trig_n .. "]=nil;"				-- ATO_FP_Debug02 Interceptor error nb trigger
	mission.trigrules[trig_n] = {
		['rules'] = {
			[1] = {
				["seconds"] = aiStart_spawn_time,
				["predicate"] = "c_time_after",
				["zone"] = "",
			},
		},
		['eventlist'] = '',
		['comment'] = 'Trigger ' .. trig_n,
		['predicate'] = 'triggerOnce',
		['actions'] = {
			[1] = {
				["predicate"] = "a_set_ai_task",
				["set_ai_task"] = {
					[1] = group.groupId,
					[2] = 1,
				}
			},
		},
	}
	--triggered action to start uncontrolled group
	group['tasks'] = {
		[1] = {
			["number"] = 1,
			["name"] = group.name,
			["id"] = "WrappedAction",
			["auto"] = false,
			["enabled"] = true,
			["params"] = {
				["action"] = {
					["id"] = "Start",
					["params"] = {},
				},
			},
		},
	}
end


--modify_set_ai_task
local function modify_set_ai_task(group, AirSpawnTime, from)

	if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe 1B modify_set_ai_task "..tostring(from)) end

	-- group['uncontrolled'] = true
	-- group['lateActivation'] = true --incompatible avec l'activation sur sixpack

	for trig_n = 1, #mission.trigrules  do

		if mission.trigrules[trig_n] and mission.trigrules[trig_n].actions and mission.trigrules[trig_n].actions[1] then
					-- [25] = {
						-- ['rules'] = {
							-- [1] = {
								-- ['seconds'] = 2436.739371505,
								-- ['predicate'] = 'c_time_after',
								-- ['zone'] = '',
							-- },
						-- },
						-- ['eventlist'] = '',
						-- ['actions'] = {
							-- [1] = {
								-- ['predicate'] = 'a_set_ai_task',
								-- ['set_ai_task'] = {
									-- [1] = 100054,
									-- [2] = 1,
								-- },
							-- },
						-- },
						-- ['predicate'] = 'triggerOnce',
						-- ['comment'] = 'Trigger 25',
					-- },

			if  mission.trigrules[trig_n].actions[1].predicate and  mission.trigrules[trig_n].actions[1].predicate ==  "a_set_ai_task"
				and mission.trigrules[trig_n].actions[1].set_ai_task[1] == group.groupId then

				if AirSpawnTime == -1 then
					AirSpawnTime = 0
				end

					-- table.remove(mission.trigrules, trig_n)
					-- table.remove(mission.trig.conditions, trig_n)
					-- table.remove(mission.trig.actions, trig_n)
					-- if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe 1D delete_modify_set_ai_task find groupId "..group.groupId.." trig_n: "..tostring(trig_n)) end

				-- else
					mission.trigrules[trig_n].rules[1].seconds = AirSpawnTime

					-- conditions[44] = 'return(c_time_after(2233.512158504) )',
					mission.trig.conditions[trig_n] = "return(c_time_after(" .. AirSpawnTime .. ") )"
					if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe 1Dd modify_set_ai_task find groupId "..group.groupId.." trig_n: "..tostring(trig_n)) end
				-- end


			end
		end
	end
end


local function  createBombingChapter(id_task ,flight ,waypoints, weaponType, attackType, attackAlt, element, from, typeCible )

	-- print("AtoFP passe function createBombingChapter id_task: "..tostring(id_task).." |element.name: "..tostring(element.name).." |from: "..tostring(from))

	if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe function createBombingChapter id_task:  "..tostring(id_task).." |element.name: "..tostring(element.name).." |from: "..tostring(from)) end


	local stopLoop = false
	-- cherche xy des elements dans la table oob_ground s'ils n'existent pas dans la table targetlist
	if (id_task == "AttackUnit" or id_task == "Bombing" or id_task == "AttackMapObject") and element ~= nil then
		-- if not (flight.target.elements and flight.target.elements[e] and flight.target.elements[e].x) then

		-- if not (flight.target.elements) or not (flight.target.elements[e]) or not( flight.target.elements[e].x) then
		if not (flight.target.elements) or not (element) or not( element.x) then

			print("AtoFP PASSE A not elements xy  "..tostring(flight.target_name).." || "..tostring(element.name))

			for side, oob in pairs(oob_ground) do
				for country_n, country in pairs(oob_ground[side]) do						--iterate through countries
					if country.static then
						for group_n, group in pairs(country.static.group) do				--iterate through groups in country.static.group table
							for unit_n, unit in pairs(group.units) do									--Iterate through elements of target						
								if unit.name == flight.target_name or unit.name == element.name then
									element.x = unit.x
									element.y = unit.y
									print("AtoFP passe XD find target "..tostring(group.name))
									stopLoop = true
								elseif  group.name == flight.target_name or group.name == element.name then
									element.x = unit.x
									element.y = unit.y
									print("AtoFP passe ZD find target "..tostring(group.name))
									stopLoop = true
								end
								if stopLoop then break end
							end
							if stopLoop then break end
						end
						if stopLoop then break end
					end
					if  country.vehicle then
						for group_n, group in pairs(country.vehicle.group) do				--iterate through groups in country.static.group table
							for unit_n, unit in pairs(group.units) do									--Iterate through elements of target						
								print("AtoFP passe ZC_b group.name "..tostring(group.name).." || "..tostring(flight.target.name))

								-- if group.name == unit.name then
								if unit.name == flight.target_name or unit.name == element.name then
									element.x = unit.x
									element.y = unit.y
									-- print("AtoFP passe ZD find target "..tostring(group.name))
									stopLoop = true
								elseif  group.name == flight.target_name or group.name == element.name then
									element.x = unit.x
									element.y = unit.y
									-- print("AtoFP passe ZD find target "..tostring(group.name))
									stopLoop = true
								end
								if stopLoop then break end
							end
							if stopLoop then break end
						end
						if stopLoop then break end
					end
					if stopLoop then break end
				end
				if stopLoop then break end
			end
		end
	end

	local TaskEnable = false
	if flight.player or flight.client then
		TaskEnable = true
	end

	local task_entry = {}

	if id_task == "AttackGroup" then
		-- print("AtoFP CBC passe M AttackGroup ")
		task_entry = {
			["enabled"] = TaskEnable,
			["auto"] = false,
			["id"] = id_task,
			["number"] = #waypoints["task"]["params"]["tasks"] + 1,
			["params"] =
			{
				["groupId"] = flight.target.groupId,
				["weaponType"] = weaponType,
				["expend"] = flight.loadout.expend,
				["attackType"] = flight.loadout.attackType,
			}
		}
	elseif id_task == "AttackUnit"  then
		-- print("AtoFP CBC passe N AttackUnit ")
		task_entry = {
			["enabled"] = TaskEnable,
			["auto"] = false,
			["id"] = "AttackUnit",
			["number"] = #waypoints["task"]["params"]["tasks"] + 1,
			["params"] = {
				["x"] = element.x,
				["y"] = element.y,
				["unitId"] = element.unitId,
				["expend"] = flight.loadout.expend,
				["weaponType"] = weaponType,
				["groupAttack"] = false,
				["attackType"] = attackType,
				["attackQtyLimit"] = true,
				["attackQty"] = 1,
				["altitudeEdited"] = true,
				["altitudeEnabled"] = true,
				["altitude"] = attackAlt,
				["directionEnabled"] = false,
				["direction"] = 0,
			},
		}
	elseif id_task == "Bombing"  then
		-- print("AtoFP CBC passe O Bombing ")
		if not element.x then
			print(element.name)
			print("AtoFp noX from "..tostring(from))
			-- os.execute 'pause'

		end

		task_entry = {									--define attack task
			["enabled"] = TaskEnable,
			["auto"] = false,
			["id"] = "Bombing",
			["number"] = #waypoints["task"]["params"]["tasks"] + 1,
			["params"] = {
				["x"] = element.x,
				["y"] = element.y,
				["expend"] = flight.loadout.expend,
				["weaponType"] = weaponType,
				["groupAttack"] = false,
				["attackType"] = attackType,
				["attackQtyLimit"] = true,
				["attackQty"] = 1,
				["altitudeEdited"] = true,
				["altitudeEnabled"] = true,
				["altitude"] = attackAlt,
				["directionEnabled"] = false,
				["direction"] = 0,
			},
		}
	elseif id_task == "AttackMapObject"  then
		print("AtoFP CBC passe P AttackMapObject ")
		task_entry = {
			["enabled"] = TaskEnable,
			["auto"] = false,
			["id"] = "AttackMapObject",
			["number"] = #waypoints["task"]["params"]["tasks"] + 1,
			["params"] = {
				["x"] = element.x,
				["y"] = element.y,
				["weaponType"] = weaponType,
				["expend"] = flight.loadout.expend,
				["direction"] = 0,
				["attackQtyLimit"] = false,
				["attackQty"] = 1,
				["directionEnabled"] = false,
				["groupAttack"] = true,
				["altitude"] = 2000,
				["altitudeEnabled"] = false,
			},
		}
	elseif id_task == ""  then
		-- print("AtoFP CBC passe Q ")

		print("AtoFp no id_task from "..tostring(from))
		os.execute 'pause'


	end

	-- print("AtoFP "..tostring(element.name))

	-- _affiche(task_entry, "task_entry")

	return task_entry
end


local timingDeckCata = {}
local testSixPack = {}
local pedroOK = {}						--flag pour connaitre si un pedro est activé pour un CV

---- table to store departure altitudes and times and all airbases to deconflict spawns and orbits ----
local DepartureOrbitAlt = {}
Missionfunc = 0														--remplace #mission.trig.func qui ne commence plus à 0, donc impossible avec #

local NbFlightPackage = 0													-- calcul le nombre de flight dans un Package, en comptant ceux des Roles
local NbFlightPlayer = 2 													-- nb d'avion dans le flight du joueur	
local NbPlanetDeck = 0														-- nb d'avion total sur la plateform
local basePlayer = ""
-- Cherche le nb d'avion dans le package joueur
for side, pack in pairs(ATO) do
	for p = 1, #pack do
		if camp.player and camp.player.side == side and camp.player.pack_n == p then
			for role, flight in pairs(pack[p]) do
				for f = 1, #flight do
					if flight[f].player then
						basePlayer = flight[f].base
					end

					for role2,flight2 in pairs(pack[p]) do							-- calcul le nombre de flight dans un Package, en comptant ceux des Roles																									
						for x = 1, #flight2 do
							if flight2[x].player then
								NbFlightPlayer = #flight2
								NbPlanetDeck = flight2[x].number
							elseif flight2[x].client then
								NbFlightPlayer = #flight2
								NbPlanetDeck = flight2[x].number
							end
						end
					end
				end
			end

			for role,flight in pairs(pack[p]) do
				for f = 1, #flight do
					if flight[f].base == basePlayer then
						NbFlightPackage = NbFlightPackage + 1
					end
				end
			end
		end
	end
end

-- Assigne le temp d occupation parking du joueur, pour manager le parking avion
for side, pack in pairs(ATO) do
	for p = 1, #pack do
		if camp.player and camp.player.side == side and camp.player.pack_n == p then
			for role, flight in pairs(pack[p]) do
				for f = 1, #flight do
					if flight[f].player then

						if flight[f].player or flight[f].client then
							mn_StartParking = math.floor(mission_ini.startup_time_player / 60)	-- si joueur, le tps d occupation est égal à celui du confMod

							if db_airbases[flight[f].base].LimitedParkNb then
								-- db_airbases[flight[f].base].LimitedParkNb = db_airbases[flight[f].base].LimitedParkNb - flight[f].number
							end
						end

					end
				end
			end
		end
	end
end


--Reset les anciennes position occupées par la mission precedente
for baseName, base in pairs(db_airbases) do
	if base.parkAlertSAR and base.parkAlertSAR ~= nil then

		ParkSarAirBase[baseName] = base.parkAlertSAR

		for parkN, park in pairs(ParkSarAirBase[baseName]) do
			park.occupied = false
			park.reservedAR = false
		end
	end
end

-- if db_airbases[flight[f].base].parkAlertSAR and IsHelicopter[flight[f].type] then

-- 	--combien de place libre reste t'il:
-- 	local freeParkSpace = 0 
-- 	for baseN, park in pairs(ParkSarAirBase[flight[f].base]) do
-- 		if (not park.occupied or park.occupied == nil) and not park.reservedAR then
-- 			freeParkSpace = freeParkSpace + 1
-- 		end
-- 	end

-- reserve les parking SAR aux missions SAR
--car maintenant, on utilise aussi leur parking pour tous les autres helico si ceux ci ne sont pas utilisé
for side, pack in pairs(ATO) do
	for p = 1, #pack do

		for role, flight in pairs(pack[p]) do
			for f = 1, #flight do
				if flight[f].task == "SAR" then

					if ParkSarAirBase[flight[f].base] then

						for n=1, flight[f].number do

							for parkN, park in pairs(ParkSarAirBase[flight[f].base]) do

								if not park.reservedAR or park.reservedAR == nil then
									park.reservedAR = true
									flight[f]["reservedAR"] = true
									break
								end

							end
						end
					end


				end
			end
		end

	end
end



-- garde en mémoire les targets pour eviter de les pruner plus tard
for side, pack in pairs(ATO) do
	for p = 1, #pack do
		for role, flight in pairs(pack[p]) do
			for f = 1, #flight do
				if flight[f].target and flight[f].target.elements then
					for elementN, element in ipairs(flight[f].target.elements) do
						TargetList_InThisMission[element.name] = true
					end
				end
			end
		end
	end
end


--= = = = = = = =  = = = = = = = = = =  = = = = = = = = = =  ==  = = = 
----- create flight plans in mission file for all flights in ATO -----
----- create flight plans in mission file for all flights in ATO -----
----- create flight plans in mission file for all flights in ATO -----
----- create flight plans in mission file for all flights in ATO -----
--= = = = = = = =  = = = = = = = = = =  = = = = = = = = = =  ==  = = = 


for side, pack in pairs(ATO) do													--iterate through sides in ATO

	--M27 Randomly moves the 2 BullsEye
	local nameTheatre =  string.lower(mission.theatre)
	if campMod.movedBullseye[nameTheatre] or mission_ini.movedBullseye == false then
		fct_movedBullseye(side, nameTheatre)
	end

	for p = 1, #pack do															--iterate through packages in sides		
		local Pn = 0															--variable to count flights in package	
		for role,flight in pairs(pack[p]) do									--iterate through roles in package (main, SEAD, escort)		

			-- local addNflight = 0
			-- if role ~= "main" then addNflight = 1 end
			for f = 1, #flight do												--iterate through flights in roles

				local FARP_MorePlace = false
				local InfoFlight = ""
				local TotFlightDist = 0

				--pour eviter le pb du flight 2 du main(strike) qui peut etre en comflit avec une escorte strike 		
				local tempNumFlight = f
				local groupName = "Pack " .. p .. " - " .. flight[f].name .. " - " .. flight[f].task .. " " .. tempNumFlight
				repeat			
					groupName = "Pack " .. p .. " - " .. flight[f].name .. " - " .. flight[f].task .. " " .. tempNumFlight
					tempNumFlight = tempNumFlight + 1
				until not allFlightName_AtoFP[groupName]

				-- inheritedFrom 
				local type_withData = flight[f].type
				local type_withProp = flight[f].type
				if Data_divers and Data_divers[flight[f].type] and Data_divers[flight[f].type].inheritedFrom then
					type_withData = Data_divers[flight[f].type].inheritedFrom
				end
				if Data_divers and Data_divers[flight[f].type] and Data_divers[flight[f].type].inherited_APA_From then
					type_withProp = Data_divers[flight[f].type].inherited_APA_From
				end

				if flight[f].player or flight[f].client	then
					PlayerTask = flight[f].task
				end

				baseIsFARP = string.match(flight[f].base, "FARP") ~= nil

				if db_airbases[flight[f].base].unitname or string.match(flight[f].base, "CV") or string.match(flight[f].base, "LHA") then
					baseIsCarrier = true
				else
					baseIsCarrier = false
				end

				if baseIsFARP then
					if  db_airbases[flight[f].base].parkAlertSAR and #db_airbases[flight[f].base].parkAlertSAR >= 4  then
						FARP_MorePlace = true
					end
				end


				-- ["requiredModules"] = 
				-- {
				-- 	["Hercules"] = "Hercules",
				-- }, -- end of ["requiredModules"]

				if Data_divers[flight[f].type] and Data_divers[flight[f].type].requiredModules then
					local entry = {
						["name"] = tostring(flight[f].type),
						["origine"] = {
							"Data_divers: "..flight[f].type,
						}
					}

					local typeNameRequire = flight[f].type
					if  Data_divers[flight[f].type].requiredModulesSpecialName then
						typeNameRequire = Data_divers[flight[f].type].requiredModulesSpecialName
					end

					if ListRequiredModules[typeNameRequire] then

						for n, from in pairs(ListRequiredModules[typeNameRequire].origine) do

							if from ~= "Data_divers: "..typeNameRequire then
								table.insert(ListRequiredModules[typeNameRequire].origine, "Data_divers: "..typeNameRequire )
							end
						end
					else
						ListRequiredModules[typeNameRequire] = entry
					end
				end

				--evite les doublons de calcul d'alti in game
				local flagCustomAlti = false

				-- modification M18.c despawn/destroy Plane on BaseAirStart
				if db_airbases[flight[f].base].BaseAirStart then
					if not tempBaseAirStart[flight[f].base] then
						tempBaseAirStart[flight[f].base] = db_airbases[flight[f].base]
					end
				end

				local LimitedParkTiming = false
				-- modification M03 Apparition décalé sur PA, LHA et FARP

				local PlayerFirstParking = false

				--TabLPark[flight[f].base][NbPlaneTot] --NbPlaneTot sera utilisé pour ajouter des avions static sur les emplacements parking jamais utilisé
				if not TabLPark[flight[f].base] then TabLPark[flight[f].base] = {} end
				if not TabLPark[flight[f].base]["NbPlaneTot"] then TabLPark[flight[f].base]["NbPlaneTot"] = 0 end

				--M03.k : (k: best check) (j: check place parking dispo en fonction des minutes)(i: Parking limite little base)			
				local timmingParking = math.floor(flight[f].route[1].eta / 60 )

				if  not db_airbases[flight[f].base].LimitedParkNb then
					TabLPark[flight[f].base][timmingParking] = 0
				end


				if IsHelicopter[flight[f].type]  then
					is_helicopter = true
					if not IsHelicopter[flight[f].type].hHover then
						IsHelicopter[flight[f].type].hHover = 1500
					end
				else
					is_helicopter = false
				end


				-- LimitedParkTiming  limite par timming l'apparition des avions


				--[[
				création d'une table où l'on compte le nb d'aéronef present sur le parking avant décollage
				T0 est le début du jeux
				timmingParking : est l'heure de décollage du flight
				mn_StartParking : on considére qu'il faut 10mn avant de décoller, donc 10mn d'occupation parking
				si un joueur est sur la base le temps d'occupation parking correspond au temp de preparation du joueur
				["Dubai Intl"] = 
				{
					[1] = 8,
					[2] = 8,
					[3] = 8,
					[4] = 8,
					[5] = 8,
					[6] = 8,
					[7] = 8,
					[8] = 8,
					[9] = 8,
					[10] = 8,
					[11] = 8,
					[12] = 8,
					[13] = 4,
					[14] = 4,
					[15] = 4,
					[16] = 4,
					[17] = 4,
					[18] = 4,
					[19] = 4,
					[20] = 4,
					[21] = 4,
					[22] = 4,
					[23] = 4,
					[24] = 4,
					[25] = 4,
					[26] = 4,
					[27] = 4,
					[28] = 4,
					[29] = 4,
					[30] = 4,
					[31] = 4,
					[32] = 4,
					[33] = 4,
					[34] = 4,
					[35] = 4,
					[36] = 4,
					[37] = 4,
					[0] = 16,
					[-15] = 16,
					[-2] = 16,
					[-4] = 16,
					[-8] = 16,
					[-16] = 16,
					[-17] = 16,
					[-9] = 16,
					[-18] = 16,
					[-19] = 16,
					[-10] = 16,
					[-20] = 16,
					[-21] = 16,
					[-11] = 16,
					[-22] = 16,
					[-3] = 16,
					[-23] = 16,
					[-12] = 16,
					[-24] = 16,
					[-1] = 16,
					[-25] = 16,
					[-13] = 16,
					[-5] = 16,
					["LimitedParkNb"] = 96,
					[-7] = 16,
					[-14] = 16,
					[-6] = 16,
					--]]

				if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe ParkSarAirBase A0 "..tostring(flight[f].route[1].id).." "..tostring(flight[f].route[2])) end

				if (flight[f].route[1].id ~= "Spawn" and flight[f].route[1].eta and flight[f].route[2]) or (flight[f].route[1].id ~= "Spawn" and flight[f].route[1].eta and not baseIsCarrier) then

					for mn =  -mn_StartParking, timmingParking  do
						if not TabLPark[flight[f].base][mn] then TabLPark[flight[f].base][mn] = 0 end

						if flight[f].task == "SAR" and flight[f].reservedAR then

						else
							--s'il n'y a plus de place, on le dit (LimitedParkTiming) et on arrete de compter
							if db_airbases[flight[f].base].LimitedParkNb and  TabLPark[flight[f].base][mn] + flight[f].number > db_airbases[flight[f].base].LimitedParkNb then
								LimitedParkTiming = true
								break
							else
								--si il reste de la place, on ajoute la somme 
								TabLPark[flight[f].base][mn] = TabLPark[flight[f].base][mn] + flight[f].number
							end
						end
					end

					--NbPlaneTot sera utilisé pour ajouter des avions static sur les emplacements parking jamais utilisé
					for mn, value in pairs(TabLPark[flight[f].base]) do
						if TabLPark[flight[f].base]["NbPlaneTot"] < value then
							TabLPark[flight[f].base]["NbPlaneTot"] = value
						end
					end

					if LimitedParkTiming then

						if db_airbases[flight[f].base].parkAlertSAR and IsHelicopter[flight[f].type] then

							--combien de place libre reste t'il:
							local freeParkSpace = 0
							for baseN, park in pairs(ParkSarAirBase[flight[f].base]) do
								if (not park.occupied or park.occupied == nil) and not park.reservedAR then
									freeParkSpace = freeParkSpace + 1
								end
							end

							if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe ParkSarAirBase D "..tostring(freeParkSpace).." "..tostring(debug.getinfo(1).currentline)) end

							if freeParkSpace >= flight[f].number then
								--il y a donc de la place sur les parking SAR (ParkSarAirBase), on enleve donc la limite LimitedParkTiming
								LimitedParkTiming = false

								--TODO enlever ceci: ai décollage
								-- ["helipadId"] = 1665,
								-- ["linkUnit"] = 1665,

								for n = 1,  flight[f].number do

									for baseN, park in pairs(ParkSarAirBase[flight[f].base]) do
										if (not park.occupied or park.occupied == nil) and not park.reservedAR then
											park.occupied = true
											if not flight[f]["parkAlertSAR"] then flight[f]["parkAlertSAR"] = {} end
											flight[f]["parkAlertSAR"][n] = park

											if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe ParkSarAirBase E "..tostring(flight[f]["parkAlertSAR"]).." "..tostring(debug.getinfo(1).currentline)) end

											break
										end
									end
								end
							end
						end
					end
				end

				local NavTargetPoints = {}
				local flagPoints = {}
				local activG_spawn_time = 0
				local aiStart_spawn_time = 0

				Pn = Pn + 1														--count flights in package

				--M54_a
				--testb
				--CustomTasksScript:
				--CAS						AttackGroup		AttackUnit			AttackUnit(Static)
				--Pinpoint Strike			Bombing 		AttackMapObject
				--Ground Attack				Bombing 		AttackMapObject		CarpetBombing
				--Runway Attack				Bombing			AttackMapObject		BombingRunway


				--CustomTasksScript:
				--							Bombing			AttackGroup		AttackUnit		AttackMapObject		BombingRunway		CarpetBombing
				--CAS											X				X (&Static)
				--Pinpoint Strike				X													X
				--Ground Attack					X													X										X
				--Runway Attack					X													X					X


				--pb F18	"Pinpoint Strike" + AttackGroup  (pas prévu)
				--pb Mi24	"GroundAttack" + AttackUnit (pas prévu)

				local weaponType = 1073741822																			--Weapon types to use (default auto)
				if flight[f].loadout.weaponType == "Cannon" then
					weaponType = 805306368																				--Use cannon only
				elseif flight[f].loadout.weaponType == "Rockets" then
					weaponType = 30720																					--Use rockets only
				elseif flight[f].loadout.weaponType == "Bombs" then
					weaponType = 2032																					--Use unguided bombs only
					-- weaponType = 1073741822	???
				elseif flight[f].loadout.weaponType == "Guided bombs" then
					-- weaponType = 14																						--Use guided bombs only
					weaponType = 268402702
				elseif flight[f].loadout.weaponType == "ASM" then
					weaponType = 4161536																				--Use ASM only
				end

				local GoupTaskTemp = flight[f].task

				if flight[f].task == "Strike" then												--Strike is a generic A-G task that needs to be replaced by the respective DCS task
					if flight[f].loadout.weaponType == "ASM"  then
						GoupTaskTemp = "Ground Attack"
					elseif flight[f].target.class == nil or  flight[f].target.class == "vehicle" or  flight[f].target.class == "static" or  flight[f].target.class == "airbase" then
						GoupTaskTemp = "Ground Attack"
					-- elseif flight[f].target.class == "vehicle" then
					-- 	GoupTaskTemp = "CAS"
					-- elseif flight[f].target.class == "static" then
					-- 	GoupTaskTemp = "CAS"
					-- elseif flight[f].target.class == "airbase" then
						-- GoupTaskTemp = "CAS"
					end
				elseif flight[f].task == "Escort Jammer" then									--Escort Jammer task does not exitsts in DCS and needs to be replaced
					GoupTaskTemp = "Ground Attack"
				elseif flight[f].task == "Flare Illumination" then								--Flare illumination task does not exist in DCS and needs to be replaced
					GoupTaskTemp = "Ground Attack"
				elseif flight[f].task == "Laser Illumination" then								--Laser illumination task does not exist in DCS and needs to be replaced
					GoupTaskTemp = "AFAC"
				elseif flight[f].task == "AFAC" then
					GoupTaskTemp = "AFAC"
				elseif flight[f].task == "Anti-ship Strike" then
					GoupTaskTemp = "Antiship Strike"											-- Miguel debugB 
				elseif flight[f].task == "SAR" or flight[f].task == "CSAR"  then
					GoupTaskTemp = "Transport"													-- Miguel debugB 
				elseif flight[f].task == "Runway Attack"  then
					GoupTaskTemp = "Runway Attack"
				end

				local typeCible

				if flight[f].task == "Strike" and flight[f].target.class == nil then
					-- typeCible = "MapObject"
					typeCible = "Static"
				-- elseif flight[f].task == "Strike" and flight[f].target.class == "vehicle" then
				-- 	typeCible = "DynamicGroup"
				elseif flight[f].task == "Strike" and (flight[f].target.class == "static" or  flight[f].target.class == "vehicle"  or  flight[f].target.class == "airbase")  then
					typeCible = "Static"
				-- elseif flight[f].task == "Strike" and flight[f].target.class == "airbase" then
				-- 	typeCible = "Static" 
				elseif flight[f].task == "Anti-ship Strike" then
					typeCible = "Ship"
				elseif flight[f].task == "Runway Attack" then
					typeCible = "Runway"
				else
					typeCible = flight[f].task
				end


				-- TaskByPlane

				--teste_ =======================================================================

				local breakloop = false
				local goodTask = true

				local foundGoodTask = false
				local id_task = ""
				if not  TaskByPlane[GoupTaskTemp][flight[f].type] or not GoupTaskByTypeTarget[typeCible][GoupTaskTemp]  then

					-- print("AtoFP  if not  TaskByPlane[GoupTaskTemp][flight[f].type]  "..tostring(GoupTaskTemp))

					goodTask = false

					--iteration de la table avion/task possible
					for GoupTaskTemp_, plane in pairs(TaskByPlane) do
						for type_, value in pairs(plane) do
							if type_ == flight[f].type then
								--iteration de la table id/task possible
								for task_, idStrike in pairs(GoupTaskByTypeTarget[typeCible]) do
									if GoupTaskTemp_ == task_ then
										for idStrike_, value2 in pairs(idStrike) do
											if idStrike_ and idStrike_ ~= nil then
												if flight[f].task == "Strike" or  flight[f].task == "Antiship Strike" then
													if task_ == "Antiship Strike" and GoupTaskTemp == "Ship" then
														-- print("AtoFP  GoupTaskTemp avant "..tostring(GoupTaskTemp))

														id_task = idStrike_
														GoupTaskTemp = task_

														-- print("AtoFP Ship après le GoupTaskTemp après "..flight[f].type.." "..tostring(GoupTaskTemp).." id_task: "..tostring(id_task))
														-- os.execute 'pause'
														goodTask = true
														breakloop = true
														break

													elseif task_ == "Runway Attack" and GoupTaskTemp == "Runway Attack" then
														-- print("AtoFP  GoupTaskTemp avant "..tostring(GoupTaskTemp))

														id_task = idStrike_
														GoupTaskTemp = task_

														-- print("AtoFP Runway après GoupTaskTemp après "..flight[f].type.." "..tostring(GoupTaskTemp).." id_task: "..tostring(id_task))
														-- os.execute 'pause'
														goodTask = true
														breakloop = true
														break
													elseif not (task_ == "Runway Attack" or  task_ == "Antiship Strike" )then
														-- print("AtoFP  GoupTaskTemp avant "..tostring(GoupTaskTemp))

														id_task = idStrike_
														GoupTaskTemp = task_

														-- print("AtoFP  GoupTaskTemp après "..flight[f].type.." "..tostring(GoupTaskTemp).." id_task: "..tostring(id_task))
														-- os.execute 'pause'
														goodTask = true
														breakloop = true
														break
													end

												end
											end
										end
									end

									if breakloop then break end
								end
								if breakloop then break end
							end
							if breakloop then break end
						end
						if breakloop then break end
					end
				else

					--iteration de la table id/task possible
					for task_, idStrike in pairs(GoupTaskByTypeTarget[typeCible]) do
						for idStrike_, value2 in pairs(idStrike) do
							if idStrike_ and idStrike_ ~= nil then
								if GoupTask[GoupTaskTemp] and  GoupTask[GoupTaskTemp][idStrike_] then

									id_task = idStrike_

									-- print("AtoFP #12 FOUND choix  |"..tostring(GoupTaskTemp).."| |"..tostring(id_task))
									-- os.execute 'pause'

									breakloop = true
									break
								end
							end
						end
						if breakloop then
							-- print("AtoFP #13 break  ")							
							break
						end
					end
					if not breakloop then
						-- print("AtoFP #14 choix  "..tostring(GoupTaskTemp).." id_task "..tostring(id_task).." typeCible "..tostring(typeCible))
						-- os.execute 'pause'
					end
				end


				--teste_ =======================================================================

				--n'a pas trouvé de task correspondant à l'avion et au type de cible
				--on passe donc en mode dégradé
				if not goodTask then
					if GoupTaskTemp ~= "Runway Attack" then
						print("(downgraded mode  : don t found task "..flight[f].task.." of the "..flight[f].type.. "in the oob_air_init.lua file")
						print("typeCible "..typeCible.." || "..flight[f].type.." "..GoupTaskTemp.." "..tostring(flight[f].target.name))
						-- os.execute 'pause'
					end

					if  TaskByPlane["Ground Attack"][flight[f].type]   then
						GoupTaskTemp = "Ground Attack"
						id_task = "Bombing"
						goodTask = true
						-- print("AtoFp passe BA "..GoupTaskTemp)
					else
						-- print("AtoFp passe BB ")

						for GoupTaskTemp_, plane in pairs(TaskByPlane) do
							for type_, value in pairs(plane) do
								if type_ == flight[f].type then
									-- print("AtoFp passe BC ")

									if GoupTaskTemp_ == "CAS" or GoupTaskTemp_ == "Pinpoint Strike" or  GoupTaskTemp_ == "Antiship Strike"  or GoupTaskTemp_ == "Runway Attack" then
										-- print("AtoFp passe BE ")

										GoupTaskTemp = GoupTaskTemp_
										id_task = "Bombing"
										for id_task_ , value in pairs(StrikeDegradedMode[GoupTaskTemp]) do
											id_task = id_task_
											goodTask = true

											-- print("AtoFp passe BD ")
										end
										break
									end
								end
							end
						end
					end
				end

				if not goodTask then
					print("(Error AtoFp 11  : bad task: remove "..flight[f].task.." of the "..flight[f].type.. "in the oob_air_init.lua file")
					print("typeCible "..typeCible.." || "..flight[f].type.." "..GoupTaskTemp.." "..tostring(flight[f].target.name))
					os.execute 'pause'
				end

				-- print("AtoFP passe #2 typeCible "..typeCible.." || "..flight[f].type.." "..GoupTaskTemp.." "..tostring(flight[f].target.name))

				----- define waypoints -----
				local egress_wp													--local variable to store the Egress WP
				local target_wp_remove											--local variable for the target waypoint to be potentially removed for standoff ground attacks
				local spawn_time = flight[f].route[1].eta --spawn_time_bug											--local variable to store spawn time
				local departure_time											--local variable to store departure time
				local waypoints = {}											--define waypoints of flight
				local wptTargetPass = false										--detecte le passage du wpt Target



				for w = 1, #flight[f].route do
					local atlTemp = flight[f].route[w].alt
					if is_helicopter then
						if IsHelicopter[flight[f].type].hHover then
							if atlTemp > IsHelicopter[flight[f].type].hHover then
								atlTemp = IsHelicopter[flight[f].type].hHover * 2/3
							end
						elseif atlTemp > 1500 then
							atlTemp = 1500
						end

					end

					local speed = 0
					if flight[f].route[w] and not flight[f].route[w].speed then
						speed = pack[p].main[1].loadout.vCruise
					else
						speed = flight[f].route[w].speed
					end


					waypoints[w] = {

						["name"] = flight[f].route[w].id,
						["briefing_name"] = flight[f].route[w].id,				--not needed for actual mission creation, but added for navigation overview in briefing
						["alt"] = atlTemp,
						["type"] = "Turning Point",
						action = "Turning Point",
						["alt_type"] = "BARO",
						["formation_template"] = "",
						-- ["properties"] = 
						-- {
						-- 	["vnav"] = 1,
						-- 	["scale"] = 0,
						-- 	["angle"] = 0,
						-- 	["vangle"] = 0,
						-- 	["steer"] = 2,
						-- },
						["ETA"] = flight[f].route[w].eta,
						["y"] = flight[f].route[w].y,
						["x"] = flight[f].route[w].x,
						["speed"] = speed,
						ETA_locked = true,
						["task"] =
						{
							["id"] = "ComboTask",
							["params"] =
							{
								["tasks"] = {}
							},
						},
						speed_locked = false,
					}

					if waypoints[w].name == "Target" then
						wptTargetPass = true
					end

					if w == 1 and (flight[f].task == "Intercept" or flight[f].task == "SAR") then
						local speed = 300
						if flight[f].task == "SAR" then
							speed = 30
						end
						waypoints[2] = {
							-- ["name"] = flight[f].route[w].id,
							-- ["briefing_name"] = flight[f].route[w].id,				--not needed for actual mission creation, but added for navigation overview in briefing
							["alt"] = flight[f].route[w].alt,
							type = "Turning Point",
							action = "Turning Point",
							["alt_type"] = "BARO",
							["formation_template"] = "",
							-- ["properties"] = 
							-- {
							-- 	["vnav"] = 1,
							-- 	["scale"] = 0,
							-- 	["angle"] = 0,
							-- 	["vangle"] = 0,
							-- 	["steer"] = 2,
							-- },
							["ETA"] = flight[f].route[w].eta,
							["y"] = flight[f].route[w].y,
							["x"] = flight[f].route[w].x,
							["speed"] = speed,
							ETA_locked = false,
							["task"] =
							{
								["id"] = "ComboTask",
								["params"] =
								{
									["tasks"] = {}
								},
							},
							speed_locked = true,
						}
					end

					-- modification M17.e
					if flight[f].type == "F-14B" and ( flight[f].player or  flight[f].client) then		-- and TargetPointF14 --or Multi.NbGroup >= 1 
						if  flight[f].route[w].id == "Target" or flight[f].route[w].id == "Attack" and not flagPoints["ST"] then

							local tempNTP = {
								text_comment = "ST",
								x = flight[f].route[w].x,
								y = flight[f].route[w].y,
							}

							table.insert(NavTargetPoints, tempNTP)
							NavTargetPoints[#NavTargetPoints]["index"] = #NavTargetPoints
							flagPoints["ST"] = true

						elseif flight[f].route[w].id == "IP" and not flagPoints["IP"] then

							local tempNTP = {
								text_comment = "IP",
								x = flight[f].route[w].x,
								y = flight[f].route[w].y,
							}
							table.insert(NavTargetPoints, tempNTP)
							NavTargetPoints[#NavTargetPoints]["index"] = #NavTargetPoints

							flagPoints["IP"] = true

						elseif flight[f].route[w].id == "Station" and not flagPoints["DP"] then --and not flagPoints["DP"]

							local tempNTP = {
								text_comment = "DP",
								x = flight[f].route[w].x,
								y = flight[f].route[w].y,
							}
							table.insert(NavTargetPoints, tempNTP)
							NavTargetPoints[#NavTargetPoints]["index"] = #NavTargetPoints
							flagPoints["DP"] = true
						end

						if not flagPoints["FP"] then

							local tempNTP = {
								text_comment = "FP",
								x = flight[f].route[w].x,
								y = flight[f].route[w].y,
							}
							table.insert(NavTargetPoints, tempNTP)
							NavTargetPoints[#NavTargetPoints]["index"] = #NavTargetPoints
							flagPoints["FP"] = true

						end

					end

					--store spawn and departure time for flight
					if flight[f].route[w].id == "Taxi" or flight[f].route[w].id == "Spawn" or flight[f].route[w].id == "SAR"then
						-- spawn_time = flight[f].route[w].eta --spawn_time_bug
						departure_time = flight[f].route[w].eta
					elseif flight[f].route[w].id == "Departure" then
						departure_time = flight[f].route[w].eta
					end

					-- if departure_time == nil then
					-- 	_affiche(flight[f], "flight[f] departure_time == nil")
					-- end
					if flight[f].route[w].id == "Join" then
						waypoints[w]["hCruiseREF"] = flight[f].route[w].hCruiseREF
						waypoints[w]["test"] = flight[f].route[w].test
					end


					--alter departure alt (spawn and orbit) to prevent collisions of multiple packages
					if flight[f].route[w].id == "Departure" and flight[f].route[w - 1] and flight[f].route[w].id == "Spawn" then							--for departure waypoints that come after spwn waypoints
						waypoints[w]["alt"] = waypoints[w - 1]["alt"]																						--use same altitude as departure as for spawn
					elseif  w < #flight[f].route then

						if flight[f].route[w + 1] == nil then
							print("AtoFp #flight[f].route "..#flight[f].route.." w: "..w.." type: "..flight[f].type.." task: "..flight[f].task)
							_affiche(flight[f].route, "Atofp ")
						end

						if flight[f].route[w].id == "Departure"
						or (flight[f].route[w].id == "Spawn"
						and flight[f].route[w + 1].id == "Departure")
						then		--for departure waypoint or spawn before departure waypoint
							local alt = 609.6														--initial departure alt to try: 2'000 ft
							if is_helicopter  then 											-- M6.1 sauf helicopter
								alt = 50
							end
							if db_airbases[flight[f].base].elevation then							--airbase has defined elevation
								alt = alt + db_airbases[flight[f].base].elevation					--make alt above base
							end
							if DepartureOrbitAlt[flight[f].base] == nil then						--airbase has no departure altitute entries yet
								DepartureOrbitAlt[flight[f].base] = {								--make base table
									[alt] = {														--make altitude table
										[1] = waypoints[w]["ETA"],									--store time of departure
									}
								}
								waypoints[w]["alt"] = alt											--set departure altitude
							else																	--airbase has departure altitute entries
								local DepartureAlt
								repeat
									if DepartureOrbitAlt[flight[f].base][alt] == nil then			--no altitude entries yet			
										DepartureOrbitAlt[flight[f].base][alt] = {					--make altitude table
											[1] = waypoints[w]["ETA"],								--store time of departure
										}
										DepartureAlt = alt											--set departure altitude
									else															--there are already altitude entries for this airbase
										for a = 1, #DepartureOrbitAlt[flight[f].base][alt] do		--iterate through all entries of that alt
											if waypoints[w]["ETA"] > DepartureOrbitAlt[flight[f].base][alt][a] - 600 and waypoints[w]["ETA"] < DepartureOrbitAlt[flight[f].base][alt][a] + 600 then		--waypoint ETA is within 10 minutes of stored ETA 
												alt = alt + 304.8									--increase alt by 1'000 ft any try again for this next alt
												break												--break and continue with higher altitude
											end
											if a == #DepartureOrbitAlt[flight[f].base][alt] then	--if all stored ETAs have been checked
												table.insert(DepartureOrbitAlt[flight[f].base][alt], waypoints[w]["ETA"])	--insert new ETA for that altitude
												DepartureAlt = alt									--set this departure altitude
											end
										end
									end
								until DepartureAlt													--repeat until a departure altitude has been found
								waypoints[w]["alt"] = DepartureAlt									--set departure altitude
							end
						end
					end

					--set attack speed for attack, target and egress waypoints
					if waypoints[w]["name"] == "Attack" or waypoints[w]["name"] == "Target" or waypoints[w]["name"] == "Egress" then
						waypoints[w].ETA_locked = false
						waypoints[w].speed_locked = true
					elseif waypoints[w]["name"] == "Join"  then
						waypoints[w].ETA_locked = true
						waypoints[w].speed_locked = false
					elseif waypoints[w]["name"] == "Assemble"  then
						waypoints[w].ETA_locked = false
						waypoints[w].speed_locked = true
					elseif waypoints[w]["name"] == "Departure"  then
						-- waypoints[w]["speed"] = pack[p].main[1].loadout.vCruise / 4 * 3					--set NEWSPEED
					end

					--sets the speed_locked values for the CAP only (it can arrive late ^^)
					if flight[f].task == "CAP" and waypoints[w]["name"] ~= "Land" and waypoints[w]["name"] ~= "Departure" and waypoints[w]["name"] ~= "Taxi" then
						waypoints[w].ETA_locked = false
						waypoints[w].speed_locked = true
					end

					-- ATO_FP_Debug08 vi trop faible pour les escorteurs des strike trop lent 					
					if 	w>1 and flight[f].loadout.vCruise and waypoints[w]["speed"] < flight[f].loadout.vCruise / 4 * 3 then
						if Debug.debug then
							print("AtoFP vi trop faible w: "..w.." waypoints[w][speed]: "..waypoints[w]["speed"].." vCruise3/4 "..tostring(flight[f].loadout.vCruise / 4 * 3))
							print("  flight[f].loadout.vCruise ".. flight[f].loadout.vCruise)

							_affiche(waypoints, "waypoints")
							print("AtoFP ATO_FP_Debug08 vi trop faible pour les escorteurs des strike trop lent 	")
							print()

							_affiche(flight[f], "flight[f]")
							os.execute 'pause'
						end

					end

					--attack waypoint is a fly over point
					if waypoints[w]["name"] == "Attack" then
						waypoints[w].action = "Fly Over Point"
					end

					--ATO_FP_Reglage_d
					--requetes des joueurs, assigner l'altitude des wpt landing et attack
					if flight[f].player or flight[f].client then
						if waypoints[w]["briefing_name"] == "Target" or  waypoints[w]["briefing_name"] == "Attack" then
							waypoints[w]["alt"] = 0
						elseif waypoints[w]["briefing_name"] == "Land" then
							if db_airbases[flight[f].base].elevation then
								waypoints[w]["alt"] =  db_airbases[flight[f].base].elevation
							else
								waypoints[w]["alt"] = 0
							end
						end
					end

					if (waypoints[w]["name"] == "IP" ) and flight[f].task == "Escort" then --or waypoints[w]["name"] == "Egress"

						-- local grpname = "Pack " .. p .. " - " .. flight[f].name .. " - " .. flight[f].task .. " " .. (f + addNflight)
						local task_entry = {
							["enabled"] = true,
							["auto"] = false,
							["id"] = "WrappedAction",
							["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
							["params"] =
							{
								["action"] =
								{
									["id"] = "Script",
									["params"] =
									{
										["command"] = "OrbitPosition('" .. groupName .. "', " .. waypoints[w]["alt"] .. ", " .. flight[f].loadout.vCruise  / 4 * 3 .. ", " .. (waypoints[w].ETA + 300) .. ")",
									},
								},
							},
						}
						table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)

					end

					--player flight WP ETA
					if flight[f].player then
						if waypoints[w]["name"] == "Target" or waypoints[w]["name"] == "Station" then
							waypoints[w].ETA_locked = true
							waypoints[w].speed_locked = false
						elseif waypoints[w]["name"] == "Join" then															--ETA of join should be unlocked (so it is no target point for Viggen), but speed needs to be reduced to allow time for start up and take off
							waypoints[w].ETA_locked = false
							waypoints[w].speed_locked = true
							--set NEWSPEED
							-- waypoints[w]["speed"] = GetDistance(waypoints[w - 1], waypoints[w]) / (waypoints[w]["ETA"] - waypoints[w-1]["ETA"])		--exact speed to rach join at required ETA
						else
							waypoints[w].ETA_locked = false
							waypoints[w].speed_locked = true
						end
					end

					-- modification M06.b bug helico reste statique s'il demarre en horaire décalé
					-- M06.e
					if is_helicopter and flight[f].route[w].id ~= "Departure" then	 --and flight[f].task == "Transport"	
						waypoints[w].ETA_locked = false
						waypoints[w].speed_locked = true
					end

					--altitudes below 1000m are AGL instead of MSL
					if waypoints[w]["alt"] <= 1000 and not is_helicopter then
						waypoints[w]["alt_type"] = "RADIO"
					elseif is_helicopter and flight[f].route[w].id == "Departure" then
						waypoints[w]["alt_type"] = "RADIO"
					elseif is_helicopter and flight[f].route[w].id ~= "Departure" and waypoints[w]["alt"] <= 100 then
						waypoints[w]["alt_type"] = "RADIO"
					end

					--take off and landing
					if (flight[f].route[w].id == "Taxi" and flight[f].route[w].eta >= 0) or (flight[f].route[w].id == "Intercept" or flight[f].route[w].id == "SAR")  then
						if  ( not flight[f].player and not flight[f].client) and db_airbases[flight[f].base].AI_Spawn and string.upper(db_airbases[flight[f].base].AI_Spawn) ~= "PARKING" then
							if string.upper(db_airbases[flight[f].base].AI_Spawn) == "AIR" then
								waypoints[w].type = "Turning Point"
								waypoints[w].action = "Turning Point"
								flight[f].route[w].id = "Spawn"
								flight[f].route[w].eta = flight[f].route[w].eta - 300
								-- spawn_time = flight[f].route[w].eta --spawn_time_bug							
							elseif string.upper(db_airbases[flight[f].base].AI_Spawn) == "RUNWAY" then
								waypoints[w].type = "Turning TakeOff"
								waypoints[w].action = "From Runway"
								flight[f].route[w].eta = flight[f].route[w].eta - 200
								-- spawn_time = flight[f].route[w].eta --spawn_time_bug										
							end
						else
							waypoints[w].type = "TakeOffParking"
							waypoints[w].action = "From Parking Area"
							if baseIsCarrier or (flight[f].airdromeId and flight[f].airdromeId >= 100 and not flight[f]["parkAlertSAR"]) then									--airbase is a carrier
								waypoints[w].linkUnit = flight[f].airdromeId
								waypoints[w].helipadId = flight[f].airdromeId
							else
								waypoints[w]["airdromeId"] = flight[f].airdromeId
							end

							--if defined in conf_mod, player flight starts with engines running
							if (flight[f].player == true or flight[f].client == true) and mission_ini.parking_hotstart and (flight[f].task ~= "Intercept" and flight[f].task ~= "SAR") then													--if flight[f].player == true and camp.hotstart then
								-- waypoints[w].action = "From Parking Area Hot"
								-- waypoints[w].type = "TakeOffParkingHot"

								if  mission_ini.parking_hotstart then
									if  type(mission_ini.parking_hotstart) == "boolean"  then														--if flight[f].player == true and camp.hotstart then
										waypoints[w].action = "From Parking Area Hot"
										waypoints[w].type = "TakeOffParkingHot"
										-- print("AtoFP passe boolean TakeOffParkingHot")
									elseif  type(mission_ini.parking_hotstart) == "number" and mission_ini.parking_hotstart == 0  then			--if flight[f].player == true and camp.hotstart then
										waypoints[w].action = "From Parking Area"
										waypoints[w].type = "TakeOffParking"
										-- print("AtoFP passe 0 TakeOffParking")
									elseif  type(mission_ini.parking_hotstart) == "number" and mission_ini.parking_hotstart == 1  then			--if flight[f].player == true and camp.hotstart then
										waypoints[w].action = "From Parking Area Hot"
										waypoints[w].type = "TakeOffParkingHot"
										-- print("AtoFP passe 1 TakeOffParkingHot")
									elseif  type(mission_ini.parking_hotstart) == "number" and mission_ini.parking_hotstart == 2  then			--if flight[f].player == true and camp.hotstart then
										waypoints[w].action = "From Runway"
										waypoints[w].type = "TakeOff"
										-- print("AtoFP passe 2 From Runway")
									end
								end

							--if defined in conf_mod, task intercept player flight starts with engines running										-- modification M08	: hotstart
							elseif (flight[f].player == true or flight[f].client == true) and (flight[f].task == "Intercept" or flight[f].task == "SAR") then													--if flight[f].player == true and camp.hotstart then
								if  mission_ini.intercept_hotstart then
									if  type(mission_ini.intercept_hotstart) == "boolean"  then														--if flight[f].player == true and camp.hotstart then
										waypoints[w].action = "From Parking Area Hot"
										waypoints[w].type = "TakeOffParkingHot"
										-- print("AtoFP passe boolean TakeOffParkingHot")
									elseif  type(mission_ini.intercept_hotstart) == "number" and mission_ini.intercept_hotstart == 0  then			--if flight[f].player == true and camp.hotstart then
										waypoints[w].action = "From Parking Area"
										waypoints[w].type = "TakeOffParking"
										-- print("AtoFP passe 0 TakeOffParking")
									elseif  type(mission_ini.intercept_hotstart) == "number" and mission_ini.intercept_hotstart == 1  then			--if flight[f].player == true and camp.hotstart then
										waypoints[w].action = "From Parking Area Hot"
										waypoints[w].type = "TakeOffParkingHot"
										-- print("AtoFP passe 1 TakeOffParkingHot")
									elseif  type(mission_ini.intercept_hotstart) == "number" and mission_ini.intercept_hotstart == 2  then			--if flight[f].player == true and camp.hotstart then
										waypoints[w].action = "From Runway"
										waypoints[w].type = "TakeOff"
										-- print("AtoFP passe 2 From Runway")
									end
								end
							end
						end
					elseif flight[f].route[w].id == "Land" then
						-- modification M18.c despawn/destroy Plane on BaseAirStart
						if (db_airbases[flight[f].base].BaseAirStart and not (flight[f].task == "Nothing" or flight[f].task == "Transport")) or
							( (flight[f].task == "Nothing" or flight[f].task == "Transport") and db_airbases[flight[f].target.destination].BaseAirStart ) then

							waypoints[w].type = "Turning Point"
							waypoints[w].action = "Turning Point"
							-- waypoints[w]["speed"] = flight[f].loadout.vCruise / 3 * 2			--set NEWSPEED
							waypoints[w]["alt"] = 500 + db_airbases[flight[f].base].elevation
							waypoints[w].ETA_locked = false
							waypoints[w].speed_locked = true

							local stopTime = waypoints[w].ETA + 7200



							-- local grpname = "Pack " .. p .. " - " .. flight[f].name .. " - " .. flight[f].task .. " " .. (f + addNflight)
							local task_entry = {
								["enabled"] = true,
								["auto"] = false,
								["id"] = "WrappedAction",
								["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
								["params"] =
								{
									["action"] =
									{
										["id"] = "Script",
										["params"] =
										{
											["command"] = "OrbitPosition('" .. groupName .. "', " .. waypoints[w]["alt"] .. ", " .. waypoints[w]["speed"] .. ", " .. stopTime .. ")",
										},
									},
								},
							}
							table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)

						else
							waypoints[w].type = "Land"
							waypoints[w].action = "Landing"
							-- waypoints[w].ETA_locked = true		--ceci n'est pas une bonne idée, le DCS bloque
							waypoints[w].ETA_locked = false
							waypoints[w].speed_locked = true
							if baseIsCarrier then
								waypoints[w].linkUnit = flight[f].airdromeId
								waypoints[w].helipadId = flight[f].airdromeId
							else
								waypoints[w]["airdromeId"] = flight[f].airdromeId
								--ATO_FP_Debug10
								if flight[f].task == "Nothing" or flight[f].task == "Transport" then
									waypoints[w]["airdromeId"] = db_airbases[flight[f].target.destination].airdromeId
									waypoints[w]["alt"] = 500 + db_airbases[flight[f].target.destination].elevation
								end
							end

							--TODO ajouter un wpt intermediaire avec customOrbit
							if baseIsCarrier and waypoints[w]["ETA"] <= mission_ini.startup_time_player + 600 then
								if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP delayed LANDING ") end

								-- local grpname = "Pack " .. p .. " - " .. flight[f].name .. " - " .. flight[f].task .. " " .. (f + addNflight)

								local distOrbit  = GetDistance({x = waypoints[w-1].x, y = waypoints[w-1].y}, {x = waypoints[w].x, y = waypoints[w].y})

								local HeadingOrbit  = GetHeading({x = waypoints[w-1].x, y = waypoints[w-1].y}, {x = waypoints[w].x, y = waypoints[w].y})

								local pointOrbit = GetOffsetPoint({x = waypoints[w-1].x, y = waypoints[w-1].y}, HeadingOrbit, distOrbit)

								local ETA_orbit = (waypoints[w-1]["ETA"] + waypoints[w]["ETA"]) / 2

								local departure_timeB = mission_ini.startup_time_player + 600

								waypoints[w]["ETA"] = mission_ini.startup_time_player + 1200

								--ajoute un waypoint intermediaire avec une orbit
								local wptOrbit = {
									['alt'] = waypoints[w-1]["alt"],
									['briefing_name'] = 'Stacking',
									['action'] = 'Turning Point',
									['alt_type'] = 'BARO',
									speed_locked = false,
									['ETA'] = ETA_orbit,
									['y'] = pointOrbit.y,
									['formation_template'] = '',
									['name'] = 'Stacking',
									ETA_locked = true,
									['speed'] = waypoints[w-1]["speed"],
									['x'] = pointOrbit.x,
									['task'] = {
										['id'] = 'ComboTask',
										['params'] = {
											['tasks'] = {
												[1] = {
													["enabled"] = true,
													["auto"] = false,
													["id"] = "WrappedAction",
													["number"] =  1,
													["params"] =
													{
														["action"] =
														{
															["id"] = "Script",
															["params"] =
															{
																["command"] = "OrbitPosition('" .. groupName .. "', " .. waypoints[w-1]["alt"] .. ", " .. waypoints[w-1]["speed"] .. ", " .. departure_timeB .. ")",
															},
														},
													},
												},
											},
										},
									},
									['type'] = 'Turning Point',

								}

								table.insert(waypoints, w, wptOrbit )

							end
						end

					end

					-- --target WP to be removed for non-player A-G attacks
					-- if flight[f].route[w].id == "Target" then											--WP is target WP
					-- 	if flight[f].task ~= "Reconnaissance" and flight[f].task ~= "Laser Illumination" then		--target WP is removed for all A-G tasks except recon or laser illumination
					-- 		if flight[f].player ~= true and flight[f].client ~= true then											--not the player flight (player always gets a target WP)
					-- 			target_wp_remove = w
					-- 		end
					-- 	end
					-- end

					--formations
					if flight[f].route[w].id == "Departure" or flight[f].route[w].id == "Spawn" then
						local task_entry = {}
						if is_helicopter then
							task_entry = {															--Spread Four Close
							["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
							["auto"] = false,
							["id"] = "WrappedAction",
							["name"] = "Formation Coin",
							["enabled"] = true,
							["params"] =
							{
								["action"] =
								{
									["id"] = "Option",
									["params"] =
									{
										["value"] = 8,
										["name"] = 5,
										["formationIndex"] = 8,
									},
								},
							},
						}
						else
							task_entry = {															--Spread Four Close
							["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
							["auto"] = false,
							["id"] = "WrappedAction",
							["name"] = "Spread Four Close",
							["enabled"] = true,
							["params"] =
							{
								["action"] =
								{
									["id"] = "Option",
									["name"] = "Formation",
									["params"] =
									{
										["variantIndex"] = 1,
										["name"] = 5,
										["formationIndex"] = 7,
										["value"] = 458753,
									},
								},
							},
						}
						end

						table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
					end

					--ATO_FP_Reglage01 : emport, ne pas larguer les emports en cas d'urgence
					-- if flight[f].route[w].id == "Departure" or flight[f].route[w].id == "Spawn" then
						-- local task_entry = {
							-- ["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
							-- ["enabled"] = true,
							-- ["auto"] = false,
							-- ["id"] = "WrappedAction",
							-- ["name"] = "emergency jettison",
							-- ["params"] = 
							-- {
								-- ["action"] = 
								-- {
									-- ["id"] = "Option",
									-- ["params"] = 
									-- {
										-- ["value"] = true,
										-- ["name"] = 15,
									-- }, -- end of ["params"]
								-- }, -- end of ["action"]
							-- }, -- end of ["params"],
						-- }
						-- table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
					-- end


					-- modif Miguel M01 : ajout datalink EPLRS Capacity
					if (flight[f].route[w].id == "Departure"  or flight[f].route[w].id == "Spawn") and camp.date.year >= 1996 then
						--M01_b	
						if EPLRS_Capacity[flight[f].type] then
							local task_entry = {
								["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
								["auto"] = true,
								["id"] = "WrappedAction",
								["enabled"] = true,
								["params"] =
								{
									["action"] =
									{
										["id"] = "EPLRS",
										["params"] =
										{
											["value"] = true,
											["groupId"] = 1,
										}, -- end of ["params"]
									}, -- end of ["action"]
								},
							}
							table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
						end
					end

					altRole = 0
					if role == "SEAD" then
						altRole = 1
					elseif role == "Escort" then
						altRole = 2
					end
					--determine une nouvelle altitude pour ne pas prendre une montagne
					if flight[f].route[w].id == "Spawn" then
						local nameTheatre =  string.lower(mission.theatre)
						local altFloor = 0

						if AltitudeFloorNew then
							for level, layers in pairs(AltitudeFloorNew) do
								-- print("AtoFP AA AltitudeFloorNew level "..tostring(level))

								for polyN, poly in pairs(layers) do
									-- print("AtoFP BB polyN "..tostring(polyN).." waypoints[1]: "..tostring(waypoints[1].x) .." poly.x: "..tostring(poly.x))

									local result = CheckPointInPolygon(waypoints[1], poly)
									-- print("AtoFP CC result "..tostring(result).." altFloor: "..altFloor .."< level:? "..level)

									if result and altFloor < level then
										altFloor = level
									end
									if is_helicopter and altFloor > 4000 then
										altFloor = altFloor - 2000
									end
								end
							end
						end
						if altFloor ~= 0 then
							-- print("AtoFP OLD alt ".. waypoints[1]["alt"].." altFloor "..altFloor)
							if waypoints[1]["alt"] < altFloor + 200 then
								waypoints[1]["alt"] =  altFloor + 200 + ((Pn-1) * 200) + (altRole * 50)
								-- print("AtoFP NEW alt ".. waypoints[1]["alt"])
							end
						end

					end


					-- --determine une nouvelle altitude pour ne pas prendre une montagne
					-- if flight[f].route[w].id == "Spawn" then
					-- 	local nameTheatre =  string.lower(mission.theatre)
					-- 	local altFloor = 0 
					-- 	if AltitudeFloor and AltitudeFloor[nameTheatre] then					
					-- 		for level, poly in pairs(AltitudeFloor[nameTheatre]) do
					-- 			local result = CheckPointInPolygon(waypoints[1], poly)
					-- 			if result and altFloor < level then								
					-- 				altFloor = level
					-- 			end
					-- 			if is_helicopter and altFloor > 4000 then
					-- 				altFloor = altFloor - 2000
					-- 			end
					-- 		end
					-- 	end	

					-- 	if altFloor ~= 0 then
					-- 		if waypoints[1]["alt"] < altFloor + 200 then							
					-- 			waypoints[1]["alt"] =  altFloor + 200 + ((Pn-1) * 200) + (altRole * 50) 
					-- 		end
					-- 	end

					-- end

					--*************************************************************************************
					--attack tasks
					--*************************************************************************************

					-- local grpname = "Pack " .. p .. " - " .. flight[f].name .. " - " .. flight[f].task .. " " .. (f + addNflight)
					local ExpendQty = flight[f].loadout.expend
					local WeaponType_ = flight[f].loadout.weaponType
					local attackType = flight[f].loadout.attackType or "nil"
					local attackAlt = flight[f].loadout.attackAlt or flight[f].loadout.hAttack
					local Dive = nil
					if flight[f].loadout.attackType and  string.lower( flight[f].loadout.attackType) == "dive"  then
						Dive = true
					end

					local AGAS_ready = false

					if flight[f].loadout.AGAS_AttackDist or flight[f].loadout.AGAS_PopAlt or flight[f].loadout.AGAS_OffsetAngle or flight[f].loadout.AGAS_ClimbAngle then
						AGAS_ready = true
					end
					local OffsetAngle = flight[f].loadout.AGAS_OffsetAngle or 20
					local ClimbAngle  = flight[f].loadout.AGAS_ClimbAngle or 30   --climb angles smaller than 15 are not possible
					local PopAlt = flight[f].loadout.AGAS_PopAlt or nil   --500   --Pop-up maneuver prior to attack
					local AttackDist = flight[f].loadout.AGAS_AttackDist or nil   --3000
					local Reattack = flight[f].loadout.AGAS_Reattack or nil
					local DebugTask = Debug.debug

					local target_element, tgtlist
					if flight[f].target.elements and #flight[f].target.elements >= 1 and flight[f].target.elements[1].x then
						target_element = {}																			--table to hold the target element number to be struck
						for e = 1, #flight[f].target.elements do															--iterate trough all target elements
							if flight[f].target.elements[e].dead ~= true then												--pick only elements that are not dead
								table.insert(target_element, e)																--add to target element table
							end
						end
						for n = 1, (f - 1) * 4 do																			--shift the order of target elements for subsequent flights in package, so that each flights starts attacking different elements (flight 1: element 1-4, flight 2: element 5-8, etc)
							table.insert(target_element, target_element[1])													--shift element order, copy first element to back
							table.remove(target_element, 1)																	--delete first element
						end
						tgtlist = ""																					--list of of names of all target elements
						for n,e in ipairs(target_element) do
							tgtlist = tgtlist .. '{ x = ' .. tostring(flight[f].target.elements[e].x) .. ', y = ' .. tostring(flight[f].target.elements[e].y) .. '}, '
						end

					end

					--s'il n'y a pas d'élément enregistré, et pour éviter un bug
					-- de façon dégradé, l'on ne prend que la position de la cible dans son ensemble
					if tgtlist == nil and flight[f].task == "Runway Attack" then
						tgtlist =  '{ x = ' .. tostring(flight[f].target.x) .. ', y = ' .. tostring(flight[f].target.y) .. '}, '
						-- table.insert(BugList, "no known runway element for the target "..tostring(flight[f].target_name))
						InsertBugList("no known runway element for the target "..tostring(flight[f].target_name))
					end

					-- if  flight[f].route[w].id == "IP" then
					if  flight[f].route[w].id == "Attack" then

						----*********************************Strike class == nil*******************************************
						-- if flight[f].task == "Strike" and flight[f].target.class == nil then									--Tasks against scenery objects with multiple target sub-elements
						-- 	if not (flight[f].player or flight[f].client) then
						-- 		local task_entry = {																				--task is a command to run LUA code
						-- 			["enabled"] = true,
						-- 			["auto"] = false,
						-- 			["id"] = "WrappedAction",
						-- 			["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
						-- 			["params"] = 
						-- 			{
						-- 				["action"] = 
						-- 				{
						-- 					["id"] = "Script",
						-- 					["params"] = 
						-- 					{
						-- 						["command"] = "CustomMapObjectAttack('" .. grpname .. "', {" .. tgtlist .. "}, '" .. ExpendQty .. "', '" .. weaponType .. "', '" .. attackType .. "', '" .. attackAlt .. "', '" .. GoupTaskTemp ..  "')",	--this is a custom written task to allow all aircraft in flight to attack multiple static objects simultenously
						-- 					},
						-- 				},
						-- 			},
						-- 		}
						-- 		table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
						-- 	end
						-- 	--this is only to display attack markers in mission editor, task will be replaced in game by CustomMapObjectAttack
						-- 	-----------------------------------------------------------------------
						-- 	for n,e in ipairs(target_element) do

						-- 		local TaskFrom =  " TaskFrom "..debug.getinfo(1).currentline
						-- 		local task_entry = createBombingChapter(id_task, flight[f], waypoints[w], weaponType, attackType, attackAlt, e, TaskFrom, typeCible)
						-- 		table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)

						-- 	end


						----*********************************Strike vehicle*******************************************
						-- elseif flight[f].task == "Strike" and flight[f].target.class == "vehicle" then

						-- 	if is_helicopter or  AGAS_ready == false  then
						-- 		-- print("AtoFp flight[f].task: "..flight[f].task.." GoupTaskTemp: "..tostring(GoupTaskTemp))

						-- 		if not (flight[f].player or flight[f].client) then
						-- 			local task_entry = {																				--task is a command to run LUA code
						-- 				["enabled"] = true,
						-- 				["auto"] = false,
						-- 				["id"] = "WrappedAction",
						-- 				["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
						-- 				["params"] = 
						-- 				{
						-- 					["action"] = 
						-- 					{
						-- 						["id"] = "Script",
						-- 						["params"] = 
						-- 						{
						-- 							["command"] = "CustomGroupAttack('" .. grpname .. "', '" .. flight[f].target.name .. "', '" .. ExpendQty .. "', '" .. weaponType .. "', '" .. attackType .. "', '" .. attackAlt .. "', '" .. GoupTaskTemp ..  "')", 
						-- 						},
						-- 					},
						-- 				},
						-- 			}
						-- 			table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
						-- 		end

						-- 		if id_task == "AttackGroup" then

						-- 			local TaskFrom =  " TaskFrom "..debug.getinfo(1).currentline
						-- 			local task_entry = createBombingChapter(id_task, flight[f], waypoints[w], weaponType, attackType, attackAlt, nil, TaskFrom, typeCible)
						-- 			table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)


						-- 		else 

						-- 			local target_element = {}																			--table to hold the target element number to be struck
						-- 			for e = 1, #flight[f].target.elements do															--iterate trough all target elements
						-- 				if flight[f].target.elements[e].dead ~= true then												--pick only elements that are not dead
						-- 					table.insert(target_element, e)																--add to target element table
						-- 				end
						-- 			end
						-- 			for n = 1, (f - 1) * 4 do																			--shift the order of target elements for subsequent flights in package, so that each flights starts attacking different elements (flight 1: element 1-4, flight 2: element 5-8, etc)
						-- 				table.insert(target_element, target_element[1])													--shift element order, copy first element to back
						-- 				table.remove(target_element, 1)																	--delete first element
						-- 			end

						-- 			for n,e in ipairs(target_element) do
						-- 				local TaskFrom =  " TaskFrom "..debug.getinfo(1).currentline
						-- 				local task_entry = createBombingChapter(id_task, flight[f], waypoints[w], weaponType, attackType, attackAlt, e, TaskFrom, typeCible)
						-- 				table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
						-- 			end	
						-- 		end
						-- 	else


						-- 		if not (flight[f].player or flight[f].client) then

						-- 			local task_entry = {																				--task is a command to run LUA code
						-- 				["enabled"] = true,
						-- 				["auto"] = false,
						-- 				["id"] = "WrappedAction",
						-- 				["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
						-- 				["params"] = 
						-- 				{
						-- 					["action"] = 
						-- 					{
						-- 						["id"] = "Script",
						-- 						["params"] = 
						-- 						{
						-- 										--AirGroundAttackTask(FlightName,				 Target,						 WeaponType,string			 ExpendQty,string		 Dive,			 OffsetAngle, 			ClimbAngle, 		PopAlt, 		AttackDist, 			Reattack,			 Debug)
						-- 							["command"] = "AirGroundAttackTask('" .. grpname .. "', '" .. flight[f].target.name .. "', '" .. WeaponType_ .. "', '"  .. ExpendQty .. "', " .. tostring(Dive) .. ", " .. tostring(OffsetAngle) .. ", " .. tostring(ClimbAngle) ..", " .. tostring(PopAlt) ..", " .. tostring(AttackDist) ..", " .. tostring(Reattack) .. ", " .. tostring(DebugTask) ..  ")", 
						-- 						},
						-- 					},
						-- 				},
						-- 			}
						-- 			table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
						-- 		end
						-- 	end

							---------------------------------------------------------------------------------------------------
							---------------------------------------------------------------------------------------------------


						--*********************************Strike static*******************************************
						-- elseif flight[f].task == "Strike" and flight[f].target.class == "static" then

							--*********************************Strike MEDLEY*******************************************
						if flight[f].task == "Strike" and (flight[f].target.class == nil or flight[f].target.class ~= "airbase") then
							-- print("AtoFp flight[f].name |"..tostring(flight[f].name.."| target_name |"..tostring(flight[f].target_name)))
							local target_e = {}																			--table to hold the target element number to be struck
							local target_elements = {}
							if flight[f].target and not flight[f].target.elements then
								_affiche(flight[f].target, "flight[f].target")
							end
							for e = 1, #flight[f].target.elements do															--iterate trough all target elements
								if flight[f].target.elements[e].dead ~= true then												--pick only elements that are not dead
									table.insert(target_e, e)																--add to target element table
								end
								if flight[f].target.elements[e].dead ~= true then												--pick only elements that are not dead
									table.insert(target_elements, flight[f].target.elements[e])																--add to target element table
								end
							end
							for n = 1, (f - 1) * 4 do																			--shift the order of target elements for subsequent flights in package, so that each flights starts attacking different elements (flight 1: element 1-4, flight 2: element 5-8, etc)
								table.insert(target_e, target_e[1])													--shift element order, copy first element to back
								table.remove(target_e, 1)																	--delete first element
							end

							local tgtlist = ""																					--list of of names of all target elements
							for n,e in ipairs(target_e) do
								tgtlist = tgtlist .. "{'" .. flight[f].target.elements[e].name .. "','" .. tostring(flight[f].target.elements[e].class) .. "','" .. tostring(flight[f].target.elements[e].x) .. "','" .. tostring(flight[f].target.elements[e].y) .. "'}, "
							end

							if is_helicopter or AGAS_ready == false  then
								if not (flight[f].player or flight[f].client) then
									local task_entry = {																				--task is a command to run LUA code
										["enabled"] = true,
										["auto"] = false,
										["id"] = "WrappedAction",
										["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
										["params"] =
										{
											["action"] =
											{
												["id"] = "Script",
												["params"] =
												{
													["command"] = "CustomMixClassAttack('" .. groupName .. "', {" .. tgtlist .. "}, '" .. ExpendQty .. "', '" .. weaponType .. "', '" .. attackType .. "', '" .. attackAlt .. "', '" .. GoupTaskTemp ..  "')",	--this is a custom written task to allow all aircraft in flight to attack multiple static objects simultenously
												},

											},
										},
									}
									table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)

								end

							else

								if not (flight[f].player or flight[f].client) then

									local task_entry = {																				--task is a command to run LUA code
										["enabled"] = true,
										["auto"] = false,
										["id"] = "WrappedAction",
										["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
										["params"] =
										{
											["action"] =
											{
												["id"] = "Script",
												["params"] =
												{
																--AirGroundAttackTask(FlightName,				 Target,						 WeaponType,string			 ExpendQty,string		 Dive,			 OffsetAngle, 			ClimbAngle, 		PopAlt, 		AttackDist, 			Reattack,			 Debug)
													["command"] = "AirGroundAttackTask('" .. groupName .. "', {" .. tgtlist .. "}, '" .. WeaponType_ .. "', '"  .. ExpendQty .. "', " .. tostring(Dive) .. ", " .. tostring(OffsetAngle) .. ", " .. tostring(ClimbAngle) ..", " .. tostring(PopAlt) ..", " .. tostring(AttackDist) ..", " .. tostring(Reattack) .. ", " .. tostring(DebugTask) ..  ")",
												},
											},
										},
									}
									table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
								end
							end

							if flight[f].player or flight[f].client then
								for n, target_element in ipairs(target_elements) do
									-- print("AtoFP target_element.name "..tostring(target_element.name))
									local TaskFrom =  " TaskFrom "..debug.getinfo(1).currentline
									local task_entry = createBombingChapter(id_task, flight[f],waypoints[w], weaponType, attackType, attackAlt, target_element, TaskFrom, typeCible)
									-- print("AtoFP "..tostring(target_element.name))
									-- _affiche(task_entry, "task_entry B2")
									table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
								end
							end

						--*********************************Strike airbase*******************************************
						elseif flight[f].task == "Strike" and flight[f].target.class == "airbase" then
							---- "airbase" 					

							if is_helicopter or  AGAS_ready == false  then

								local task_entry = {																				--task is a command to run LUA code
									["enabled"] = true,
									["auto"] = false,
									["id"] = "WrappedAction",
									["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
									["params"] =
									{
										["action"] =
										{
											["id"] = "Script",
											["params"] =
											{
												["command"] = "CustomAirbaseAttack('" .. groupName .. "', {x = " .. flight[f].target.x .. ", y = " .. flight[f].target.y .. "}, '" .. ExpendQty .. "', '" .. weaponType .. "', '" .. attackType .. "', " .. attackAlt .. ")",
											},
										},
									},
								}
								table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
							else

								if not (flight[f].player or flight[f].client) then

									local task_entry = {																				--task is a command to run LUA code
										["enabled"] = true,
										["auto"] = false,
										["id"] = "WrappedAction",
										["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
										["params"] =
										{
											["action"] =
											{
												["id"] = "Script",
												["params"] =
												{
																--AirGroundAttackTask(FlightName,				 Target,															 WeaponType,string			 ExpendQty,string		 Dive,			 OffsetAngle, 			ClimbAngle, 		PopAlt, 		AttackDist, 			Reattack,			 Debug)
													["command"] = "AirGroundAttackTask('" .. groupName .. "', {x = " .. flight[f].target.x .. ", y = " .. flight[f].target.y .. "}, '" .. WeaponType_ .. "', '"  .. ExpendQty .. "', " .. tostring(Dive) .. ", " .. tostring(OffsetAngle) .. ", " .. tostring(ClimbAngle) ..", " .. tostring(PopAlt) ..", " .. tostring(AttackDist) ..", " .. tostring(Reattack) .. ", " .. tostring(DebugTask) ..  ")",
												},
											},
										},
									}
									table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
								end
							end

							--TODO a voir pour airbase pour les IA du joueur
								-- local TaskFrom =  " TaskFrom "..debug.getinfo(1).currentline
								-- local task_entry = createBombingChapter(id_task, flight[f], waypoints[w], weaponType, attackType, attackAlt, nil, TaskFrom, typeCible, typeCible)
								-- table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)

						--*********************************Runway Attack*******************************************
						elseif flight[f].task == "Runway Attack" then

							if not (flight[f].player or flight[f].client) then
								local task_entry = {
									["enabled"] = true,
									["auto"] = false,
									["id"] = "WrappedAction",
									["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
									["params"] =
									{
										["action"] =
										{
											["id"] = "Script",
											["params"] =
											{
												["command"] = "CustomMapObjectAttack('" .. groupName .. "', {" .. tgtlist .. "}, '" .. ExpendQty .. "', '" .. weaponType .. "', '" .. attackType .. "', '" .. attackAlt .. "', '" .. GoupTaskTemp ..  "')",
												-- ["command"] = "CustomStaticAttack('" .. grpname .. "', {" .. tgtlist .. "}, '" .. ExpendQty .. "', '" .. weaponType .. "', '" .. attackType .. "', '" .. attackAlt .. "', '" .. GoupTaskTemp ..  "')",	--this is a custom written task to allow all aircraft in flight to attack multiple static objects simultenously
											},

										},
									},
								}
								table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
							end

						--*********************************Anti-ship Strike*******************************************
						elseif flight[f].task == "Anti-ship Strike" then

							if is_helicopter or  AGAS_ready == false  then


								local task_entry = {															--Spread Four Close
									["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
									["enabled"] = true,
									["key"] = "AntiShip",
									["id"] = "EngageTargets",
									["auto"] = true,
									["params"] =
									{
										["targetTypes"] =
										{
											[1] = "Ships",
										}, -- end of ["targetTypes"]
										["priority"] = 0,
									}, -- end of ["params"]

								}
								table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)

								-- + ATO_FP_Debug03 Antiship strike
								local task_entry = {
									["enabled"] = true,
									["auto"] = false,
									["id"] = "AttackGroup",
									["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
									["params"] =
									{
										["groupId"] = flight[f].target.groupId,
										["weaponType"] = weaponType,
										["expend"] = flight[f].loadout.expend,
										["attackType"] = flight[f].loadout.attackType,
									}
								}


								table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)

							else

								if not (flight[f].player or flight[f].client) then

									local task_entry = {																				--task is a command to run LUA code
										["enabled"] = true,
										["auto"] = false,
										["id"] = "WrappedAction",
										["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
										["params"] =
										{
											["action"] =
											{
												["id"] = "Script",
												["params"] =
												{
																--AirGroundAttackTask(FlightName,				 Target,						 WeaponType,string			 ExpendQty,string		 Dive,			 OffsetAngle, 			ClimbAngle, 		PopAlt, 		AttackDist, 			Reattack,			 Debug)
													["command"] = "AirGroundAttackTask('" .. groupName .. "', '" .. flight[f].target.name .. "', '" .. WeaponType_ .. "', '"  .. ExpendQty .. "', " .. tostring(Dive) .. ", " .. tostring(OffsetAngle) .. ", " .. tostring(ClimbAngle) ..", " .. tostring(PopAlt) ..", " .. tostring(AttackDist) ..", " .. tostring(Reattack) .. ", " .. tostring(DebugTask) ..  ")",
												},
											},
										},
									}
									table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
								end
							end

						elseif flight[f].task == "Flare Illumination" then

							--this is only to display attack markers in mission editor, task will be replaced in game by CustomFlareAttack
							-----------------------------------------------------------------------
							local task_entry = {
								["enabled"] = false,
								["auto"] = false,
								["id"] = "Bombing",
								["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
								["params"] = {
									["x"] = flight[f].target.x,
									["y"] = flight[f].target.y,
									["direction"] = 0,
									["attackQtyLimit"] = false,
									["attackQty"] = 1,
									["expend"] = flight[f].loadout.expend,
									["altitude"] = 1524,
									["directionEnabled"] = false,
									["groupAttack"] = true,
									["altitudeEdited"] = true,
									["altitudeEnabled"] = true,
									["weaponType"] = weaponType,
								},
							}
							table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
							-----------------------------------------------------------------------

							-- local grpname = "Pack " .. p .. " - " .. flight[f].name .. " - " .. flight[f].task .. " " .. (f + addNflight)
							local expend = flight[f].loadout.expend
							local attackType = flight[f].loadout.attackType or "nil"
							local attackAlt = flight[f].loadout.attackAlt or flight[f].loadout.hAttack
							local tgtx = "n/a"																					--target coordinate n/a, custom attach script will determine latest target position at time of attack during the misssion
							local tgty = "n/a"																					--target coordinate n/a, custom attach script will determine latest target position at time of attack during the misssion
							if flight[f].target.class ~= "vehicle" then															--if target is not a vehicle or ship, then known target coordinates are used
								tgtx = flight[f].target.x																		--use known target coordinates
								tgty = flight[f].target.y																		--use known target coordinates
							end

							local task_entry = {																				--task is a command to run LUA code
								["enabled"] = true,
								["auto"] = false,
								["id"] = "WrappedAction",
								["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
								["params"] =
								{
									["action"] =
									{
										["id"] = "Script",
										["params"] =
										{
											["command"] = "CustomFlareAttack('" .. groupName .. "', '" .. tgtx .. "', '" .. tgty .. "', '" .. flight[f].target.name .. "', '" .. expend .. "', '" .. weaponType .. "', '" .. attackType .. "', '" .. attackAlt .. ")",	--this is a custom written task to allow coordinates bombing of target poistion at time of attack
										},
									},
								},
							}
							table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)

						elseif flight[f].task == "Laser Illumination" then
							-- local grpname = "Pack " .. p .. " - " .. flight[f].name .. " - " .. flight[f].task .. " " .. (f + addNflight)
							local laserCode1 = math.random(1,7)
							local laserCode2 = math.random(1,8)
							local laserCode3 = math.random(1,8)
							flight[f].target.LaserCode = tonumber("1" .. laserCode1 .. laserCode2 .. laserCode3)				--store laser code for flight target
							for ff = 1, #pack[p].main do																		--iterate through all main body flights
								pack[p].main[ff].target.LaserCode = tonumber("1" .. laserCode1 .. laserCode2 .. laserCode3)		--store laser code in all main body flights
							end

							local tgt = ""
							local class
							if flight[f].target.class == "static" then
								class = "static"
								for e = 1, #flight[f].target.elements do
									tgt = tgt .. '"' .. flight[f].target.elements[e].name .. '", '
								end
							elseif flight[f].target.class == "vehicle" then
								class = "vehicle"
								tgt = flight[f].target.name
							elseif flight[f].target.class == "airbase" then

							else
								class = "scenery"
								for e = 1, #flight[f].target.elements do
									tgt = tgt .. '{ x = ' .. flight[f].target.elements[e].x .. ', y = ' .. flight[f].target.elements[e].y .. '}, '
								end
							end

							local task_entry = {																				--task is a command to run LUA code
								["enabled"] = true,
								["auto"] = false,
								["id"] = "WrappedAction",
								["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
								["params"] =
								{
									["action"] =
									{
										["id"] = "Script",
										["params"] =
										{
											["command"] = "CustomLaserDesignation('" .. groupName .. "', '" .. tgt .. "', '" .. class .. "', '" .. flight[f].target.LaserCode .. "')",	--this is a custom written task to allow coordinates bombing of target poistion at time of attack
										},
									},
								},
							}
							table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)


						elseif flight[f].task == "CSAR" and not flight[f].player and not flight[f].client then

							-- local grpname = "Pack " .. p .. " - " .. flight[f].name .. " - " .. flight[f].task .. " " .. (f + addNflight)
							local alt_cruise = (db_airbases[flight[f].base].elevation + flight[f].target.z + 100 ) / 2

							local task_entry = {																				--task is a command to run LUA code
								["enabled"] = true,
								["auto"] = false,
								["id"] = "WrappedAction",
								["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
								["params"] =
								{
									["action"] =
									{
										["id"] = "Script",
										["params"] =
										{
														-- Custom_SAR(grpname, airdrome, airdromeX2d, airdromeY2d, mgrsChute, speed, alt)
											["command"] = "Custom_SAR('" .. groupName .. "', '" .. flight[f].base .. "', '" .. db_airbases[flight[f].base].x .. "', '" .. db_airbases[flight[f].base].y .. "', '" .. flight[f].target_name .. "', '" .. flight[f].loadout.vCruise .. "', '" .. alt_cruise ..  "')",
										},
									},
								},
							}
							table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
						end
					end

					--SEAD engage tasks for each route segment
					if flight[f].task == "SEAD" then
						if flight[f].route[w].SEAD_radius then
							local task_entry = {
								["enabled"] = true,
								["auto"] = false,
								["id"] = "ControlledTask",
								["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
								["params"] =
								{
									["task"] =
									{
										["id"] = "EngageTargets",
										["params"] =
										{
											["targetTypes"] =
											{
												[1] = "SAM TR",
											},
											["maxDistEnabled"] = true,
											["priority"] = 0,
											["maxDist"] = flight[f].route[w].SEAD_radius,
											["weaponType"] = weaponType,
											["expend"] = flight[f].loadout.expend,
											["attackType"] = flight[f].loadout.attackType,
											["altitudeEdited"] = true,
											["altitudeEnabled"] = true,
											["altitude"] = flight[f].loadout.attackAlt or flight[f].loadout.hAttack,
										},
									},
									["stopCondition"] =
									{
										["lastWaypoint"] = w + 1,
									},
								}
							}
							if flight[f].loadout.weaponType == nil then							--if no specific weapon type defined in loadout
								task_entry.params.task.params.weaponType = 268402702			--use Anti-Radar Missile
							end
							table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
						end
					--Escort and Fighter Sweep Custom Search and Engage Task
					elseif flight[f].task == "Fighter Sweep" then
						-- if flight[f].route[w].id == "Join" or (flight[f].route[w].id == "Spawn" and (flight[f].route[w + 1].id ~= "Join" and flight[f].route[w + 1].id ~= "Departure")) then

						if flight[f].route[w].id == "Spawn" or flight[f].route[w].id == "Departure" then
							local searchTime = flight[f].route[#flight[f].route].eta
							-- local grpname = "Pack " .. p .. " - " .. flight[f].name .. " - " .. flight[f].task .. " " .. (f + addNflight)
							local task_entry = {
								["enabled"] = true,
								["auto"] = false,
								["id"] = "WrappedAction",
								["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
								["params"] =
								{
									["action"] =
									{
										["id"] = "Script",
										["params"] =
										{
											["command"] = "CustomSearchThenEngage('" .. groupName .. "', " .. flight[f].loadout.standoff .. ", 'Air'," .. searchTime .. ")",
										},
									},
								},
							}
							table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
						end
					elseif flight[f].task == "Escort" then
						if flight[f].route[w + 1] ~= nil then
							-- if flight[f].route[w].id == "Join" or (flight[f].route[w].id == "Spawn" and (flight[f].route[w + 1].id ~= "Join" and flight[f].route[w + 1].id ~= "Departure")) then

							if flight[f].route[w].id == "Spawn" or flight[f].route[w].id == "Departure" then
								local target = "Battle airplanes"
								if  is_helicopter then															-- modif M06 : helicoptere playable
									target = "Helicopters"
								end

								local searchTime = flight[f].route[#flight[f].route].eta
								-- local grpname = "Pack " .. p .. " - " .. flight[f].name .. " - " .. flight[f].task .. " " .. (f + addNflight)
								local task_entry = {
									["enabled"] = true,
									["auto"] = false,
									["id"] = "WrappedAction",
									["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
									["params"] =
									{
										["action"] =
										{
											["id"] = "Script",
											["params"] =
											{
												["command"] = "CustomSearchThenEngage('" .. groupName .. "', " .. flight[f].loadout.standoff .. ", 'Air'," .. searchTime .. ")",
											},
										},
									},
								}
								table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
							end
						end
					elseif flight[f].task == "AFAC" then
						if w == 1 and flight[f].route[w] ~= nil then

							local task_entry = {

								["enabled"] = true,
								["auto"] = true,
								["id"] = "FAC",
								["number"] = #waypoints[w]["task"] + 1,
								["params"] =
								{
									["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
									["designation"] = "Auto",
									["modulation"] = 0,
									["callname"] = 1,
									["datalink"] = true,
									-- ["frequency"] = flight[f].frequency * 1000000,
								}, -- end of ["params"]

							}
							table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)

						end
					elseif flight[f].task == "CAP" then
						if flight[f].route[w].id ~= "Station"  then --and flight[f].route[w].id ~= "Departure" and flight[f].route[w].id ~= "Land"
							local task_entry = {
								["enabled"] = true,
								["auto"] = false,
								["id"] = "ControlledTask",
								["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
								["params"] =
								{
									["task"] =
									{
										["enabled"] = true,
										["auto"] = false,
										["id"] = "EngageTargets",
										["params"] =
										{
											["targetTypes"] =
											{
												[1] = "Air",
											}, -- end of ["targetTypes"]
											["priority"] = 0,
											["value"] = "Air;",
											["noTargetTypes"] =
											{
												[1] = "Cruise missiles",
												[2] = "Antiship Missiles",
												[3] = "AA Missiles",
												[4] = "AG Missiles",
												[5] = "SA Missiles",
											}, -- end of ["noTargetTypes"]
											["maxDistEnabled"] = true,
											["maxDist"] = 60000,
										}, -- end of ["params"]
									},
								}
							}
							table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
						end
					end


					--station tasks
					if flight[f].route[w].id == "Station" and flight[f].route[w + 1].id == "Station" then
						if flight[f].task == "CAP" then
							local task_entry = {
								["enabled"] = true,
								["auto"] = false,
								["id"] = "ControlledTask",
								["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
								["params"] =
								{
									["task"] =
									{
										["id"] = "EngageTargetsInZone",
										["params"] =
										{
											["targetTypes"] =
											{
												[1] = "Air",
												[2] = "Cruise missiles",
											},
											["x"] = flight[f].target.x,
											["y"] = flight[f].target.y,
											["value"] = "Air;Cruise missiles;",
											["priority"] = 0,
											["zoneRadius"] = flight[f].target.radius,
										},
									},
									["stopCondition"] =
									{
										-- ["lastWaypoint"] = w + 1,
										["time"] = flight[f].route[w + 1].eta
									},
								}
							}
							table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
						elseif flight[f].task == "AWACS" then
							local task_entry = {
								["enabled"] = true,
								["auto"] = false,
								["id"] = "ControlledTask",
								["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
								["params"] =
								{
									["task"] =
									{
										["id"] = "AWACS",
										["params"] = {},
									},
									["stopCondition"] =
									{
										-- ["lastWaypoint"] = w + 1,
										["time"] = flight[f].route[w + 1].eta
									},
								}
							}
							table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
						elseif flight[f].task == "Refueling" then
							local task_entry = {
								["enabled"] = true,
								["auto"] = false,
								["id"] = "ControlledTask",
								["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
								["params"] =
								{
									["task"] =
									{
										["id"] = "Tanker",
										["params"] = {},
									},
									["stopCondition"] =
									{
										-- ["lastWaypoint"] = w + 1,
										["time"] = flight[f].route[w + 1].eta
									},
								}
							}
							table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)

						elseif flight[f].task == "AFAC" then
							-- local grpname = "Pack " .. p .. " - " .. flight[f].name .. " - " .. flight[f].task .. " " .. (f + addNflight)
							local laserCode1 = 0
							local laserCode2 = 0
							local laserCode3 = 0
							local LaserCode = ""

							if not pack[p].main[f].target.LaserCode then

								laserCode1 = math.random(1,7)
								laserCode2 = math.random(1,8)
								laserCode3 = math.random(1,8)

								LaserCode = 1 .. laserCode1 .. laserCode2 .. laserCode3

								flight[f].target.LaserCode = LaserCode																--store laser code for flight target

								for ff = 1, #pack[p].main do																		--iterate through all main body flights
									pack[p].main[ff].target.LaserCode = LaserCode													--store laser code in all main body flights
								end
							else
								flight[f].target.LaserCode = pack[p].main[f].target.LaserCode
							end

							local task_entry = {																				--task is a command to run LUA code
								["enabled"] = true,
								["auto"] = false,
								["id"] = "WrappedAction",
								["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
								["params"] =
								{
									["action"] =
									{
										["id"] = "Script",
										["params"] =
										{
											["command"] = "CustomLaserDesignationAFAC('" .. groupName .. "', '" .. flight[f].target.x .. "', '" .. flight[f].target.y .. "',  '" .. flight[f].target.LaserCode .. "')",
											-- ["command"] = "CustomLaserDesignation('" .. grpname .. "', '" .. tgt .. "', '" .. class .. "', '" .. flight[f].target.LaserCode .. "')",	--this is a custom written task to allow coordinates bombing of target poistion at time of attack
										},
									},
								},
							}
							table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)


						end
					end

					--orbit on departure
					-- if flight[f].route[w].id == "Departure" then
					if flight[f].route[w].id == "Assemble" then
						if flight[f].number > 1 or (#flight > 1 and flight[f].loadout.tStation == nil) or flight[f].target.firepower.packmax then		--orbit on departure only for flights larger than 1-ship, flights that are part of a package (but no on-station tasks) or multi-packages
							local speed = pack[p].main[1].loadout.vCruise
							if flight[f].loadout.vCruise then
								speed = flight[f].loadout.vCruise
								if Data_divers and Data_divers[flight[f].type] and Data_divers[flight[f].type].vCruise then
									speed = Data_divers[flight[f].type].vCruise
								end
							end

							local altitude = AltitudeCruise
							if is_helicopter then altitude = 150 end
							if Data_divers and Data_divers[flight[f].type] and Data_divers[flight[f].type].hCruise then
								altitude = Data_divers[flight[f].type].hCruise
							end
							if flight[f].loadout.heavy_load then
								altitude = altitude /2
							end

							-- local grpname = "Pack " .. p .. " - " .. flight[f].name .. " - " .. flight[f].task .. " " .. (f + addNflight)
							local task_entry = {
								["enabled"] = true,
								["auto"] = false,
								["id"] = "WrappedAction",
								["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
								["params"] =
								{
									["action"] =
									{
										["id"] = "Script",
										["params"] =
										{
											["command"] = "OrbitPosition('" .. groupName .. "', " .. altitude .. ", " .. speed .. ", " .. departure_time .. ")",
										},
									},
								},
							}
							table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
						end
					end

					--A-A TACAN for tankers, activate TACAN on first orbit WP
					--w == 1 : suite au bug des tacan qui ne s'active plus en cours du plan de vol, sauf sur le wpt 0
					if (flight[f].route[w].id == "Station" and flight[f].route[w + 1].id == "Station") or w == 1 then
						if flight[f].task == "Refueling" then
							if flight[f].type == "KC-135" or flight[f].type == "KC130" or flight[f].type == "KC135BDA" or flight[f].type == "S-3B Tanker" or flight[f].type == "KC135MPRS" then	--only specific tanker types have air-air TACAN
								if flight[1].tacan == nil then
									flight[1].tacan = GetTankerTACAN()															--get new channel for first flight in pack only, all other flights will use same channel
								end

								-- local unitIdTemp = GenerateIDUnit("AtoFP ".. "Pack " .. p .. " - " .. flight[f].name .. " - " .. flight[f].task .. " " .. (f + addNflight) .. "-1")
								local unitIdTemp = GenerateIDUnit(groupName.. "-1")

								local task_entry = {
									["enabled"] = true,
									["auto"] = true,
									["id"] = "WrappedAction",
									["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
									["params"] =
									{
										["action"] =
										{
											["id"] = "ActivateBeacon",
											["params"] =
											{
												["type"] = 4,
												["AA"] = true,
												["unitId"] = unitIdTemp,
												["modeChannel"] = "Y",
												["name"] = "",
												["channel"] = flight[1].tacan,
												["callsign"] = "TKR",
												["system"] = 4,
												["bearing"] = true,
												["frequency"] = 1087000000 + flight[1].tacan * 1000000,
											},
										},
									},
								}
								if task_entry.params.action.params.frequency > 1150000000 then
									task_entry.params.action.params.frequency = task_entry.params.action.params.frequency - 126000000
								end
								table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
							end
						end
					end

					--A-A TACAN for tankers, deactivate beacon on second orbit WP
					--A-A TACAN for tankers, deactivate beacon after 2 wpt on orbit WP
					-- if flight[f].route[w].id == "Station" and flight[f].route[w - 1].id == "Station" then
					if w > 2 and (flight[f].route[w-1].id == "Station" and flight[f].route[w - 2].id == "Station") then
						if flight[f].task == "Refueling" then
							if flight[f].type == "KC-135" or flight[f].type == "KC135MPRS"  or flight[f].type == "KC130" or flight[f].type == "KC135BDA" or flight[f].type == "S-3B Tanker" then	--only specific tanker types have air-air TACAN			
								local task_entry = {
									["enabled"] = true,
									["auto"] = false,
									["id"] = "WrappedAction",
									["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
									["params"] =
									{
										["action"] =
										{
											["id"] = "DeactivateBeacon",
											["params"] =
											{
											},
										},
									},
								}
								table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
							end
						end
					end

					--orbit on station
					if flight[f].route[w].id == "Station" and flight[f].route[w + 1].id == "Station" then
						local tempAltitude = flight[f].loadout.hAttack
						if flight[f].target.alt then
							tempAltitude = flight[f].target.alt
						end

						local task_entry = {
							["enabled"] = true,
							["auto"] = false,
							["id"] = "ControlledTask",
							["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
							["params"] =
							{
								["task"] =
								{
									["id"] = "Orbit",
									["params"] =
									{
										["altitude"] = tempAltitude,
										["pattern"] = "Race-Track",
										["speed"] = flight[f].loadout.vAttack,
									},
								},
								["stopCondition"] =
								{
									["time"] = flight[f].route[w + 1].eta
								}
							}
						}
						table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
					end

					--SEAD switch from IP to egress
					if flight[f].route[w].id == "IP" and flight[f].task == "SEAD" then
						local speed = pack[p].main[1].loadout.vCruise
						if flight[f].loadout.vCruise and flight[f].loadout.vCruise < speed then
							speed = flight[f].loadout.vCruise / 3 * 2
						end
						local task_entry = {
							["enabled"] = true,
							["auto"] = false,
							["id"] = "WrappedAction",
							["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
							["params"] = {
								["action"] = {
									["id"] = "SwitchWaypoint",
									["params"] = {
										["fromWaypointIndex"] = w,						--from IP
										["goToWaypointIndex"] = w + 2,					--directly to egress
									},
								},
							},
						}
						table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)

						local task_entry2 = {
							["enabled"] = true,
							["auto"] = false,
							["id"] = "ControlledTask",
							["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
							["params"] = {
								["task"] = {
									["id"] = "Orbit",
									["params"] = {
										["altitude"] = waypoints[w]["alt"],
										["pattern"] = "Race-Track",
										["speed"] = speed,
										["speedEdited"] = true,
									},
								},
								["stopCondition"] = {
									["time"] = flight[f].route[w + 2].eta,
								},
							},
						}
						table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry2)
					end

					--TODO ajouter un circle pour les escorte de Transport

					--orbit on egress
					if flight[f].route[w].id == "Egress" and flight[f].task == "Escort" then
						local speed = pack[p].main[1].loadout.vCruise
						if flight[f].loadout.vCruise and flight[f].loadout.vCruise < speed then
							speed = flight[f].loadout.vCruise / 3 * 2
						end
						local timeOrbit = 400

						if IsHelicopter[pack[p]["main"][1].type] then
							timeOrbit = 700
						end
						local task_entry = {
							["enabled"] = true,
							["auto"] = false,
							["id"] = "ControlledTask",
							["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
							["params"] =
							{
								["task"] =
								{
									["id"] = "Orbit",
									["params"] =
									{
										["altitude"] = waypoints[w]["alt"],
										["pattern"] = "Circle",
										["speed"] = speed,
									},
								},
								["stopCondition"] =
								{
									["time"] = flight[f].route[w].eta + timeOrbit
								}
							}
						}
						table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
					end

					--rejoin flight on egress
					if (flight[f].task == "Strike" or flight[f].task == "Anti-ship Strike" ) and flight[f].route[w].id == "Egress" then
						-- local grpname = "Pack " .. p .. " - " .. flight[f].name .. " - " .. flight[f].task .. " " .. (f + addNflight)
						local task_entry = {																				--task is a command to run LUA code
							["enabled"] = true,
							["auto"] = false,
							["id"] = "WrappedAction",
							["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
							["params"] =
							{
								["action"] =
								{
									["id"] = "Script",
									["params"] =
									{
										["command"] = "CustomRejoin('" .. groupName .. "')",
									},
								},
							},
						}
						table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
					end

					--allow weapon jettison from egress on
					-- if mission_ini.AIemergencyLaunch then


					if flight[f].route[w].id == "Egress" and (flight[f].task == "SEAD" or flight[f].task == "Strike" or flight[f].task == "Anti-ship Strike" or flight[f].task == "Flare Illumination" or flight[f].task == "Laser Illumination")
						and not is_helicopter then
						if flight[f].player ~= true and flight[f].client ~= true then
							local task_entry = {
								["enabled"] = true,
								["auto"] = false,
								["id"] = "WrappedAction",
								["name"] = "emergency jettison",
								["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
								["params"] =
								{
									["action"] =
									{
										["id"] = "Option",
										["params"] =
										{
											["value"] = true,			--true: autorise le largage d urgence, false interdit le largage
											["name"] = 15,
										},
									},
								},
							}
							table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
						end

					end
					--IP/egress reaction on threat for recon
					if flight[f].task == "Reconnaissance" and flight[f].route[w].id == "IP" then
						if flight[f].player ~= true and flight[f].client ~= true then
							local task_entry = {
								["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
								["auto"] = false,
								["id"] = "WrappedAction",
								["name"] = "reaction to Threats, passive defense",
								["enabled"] = true,
								["params"] =
								{
									["action"] =
									{
										["id"] = "Option",
										["params"] =
										{
											["value"] = 1,
											["name"] = 1,
										},
									},
								},
							}
							table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
						end
					elseif flight[f].task == "Reconnaissance" and flight[f].route[w].id == "Egress" then
						if flight[f].player ~= true and flight[f].client ~= true then
							local task_entry = {
								["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
								["auto"] = false,
								["id"] = "WrappedAction",
								["name"] = "reaction to threats, avoidance of fire",
								["enabled"] = true,
								["params"] =
								{
									["action"] =
									{
										["id"] = "Option",
										["params"] =
										{
											["value"] = 2,
											["name"] = 1,
										},
									},
								},
							}
							table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
						end
					end

					--navigation information on waypoint name for player flight
					if flight[f].player or flight[f].client then																				--flight is player flight
						if waypoints[w - 1] then																			--previous waypoint exists
							local distance = GetDistance(waypoints[w - 1], waypoints[w])									--distance between waypoints
							local distanceStr = tostring(distance)
							local suffixe = " KM"
							if waypoints[w].name == "Target" then
								distance = GetDistance(waypoints[w - 2], waypoints[w])										--for target waypoint measure distance from IP, since attack point is removed for player flight
							end
							if distance > 0 then																			--distance is not zero
								local heading = math.floor(GetHeading(waypoints[w - 1], waypoints[w]))						--heading between waypoints
								heading = heading - camp.variation															--adjust heading (true heading) with variation of map to get magnetix heading
								if heading < 0 then
									heading = heading + 360
								elseif heading > 359 then
									heading = heading - 360
								end
								if heading < 10 then
									heading = "00" .. heading
								elseif heading < 100 then
									heading = "0" .. heading
								end


								-- if mission_ini.units == "metric" then
								if Data_divers and Data_divers[flight[f].type] and Data_divers[flight[f].type].instrumentUnits
								and (Data_divers[flight[f].type].instrumentUnits == "metric" or Data_divers[flight[f].type].instrumentUnits =="russian") then
									distance = math.ceil(distance / 1000)
									TotFlightDist = TotFlightDist + tonumber(distance)
									distanceStr = tostring(distance) .. " KM"
									suffixe = " KM"
								else
									distance = math.ceil(distance / 1000 * 0.539957)
									TotFlightDist = TotFlightDist + tonumber(distance)
									distanceStr = distance .. " NM"
									suffixe = " NM"
								end

								local ete = ""
								local eteNum = 0
								if  waypoints[w].ETA and  waypoints[w-1].ETA then
									eteNum = math.floor(((waypoints[w].ETA - waypoints[w-1].ETA) / 60) + 0.5)
									ete = tostring(eteNum).." mn"
								end

								-- modification M58_a		flight plan, heading, Dist, ETE
								-- ajoute des espaces entre les texte pour présenter quelque chose de beau
								local space = 7 - string.len(tostring(waypoints[w]["name"]))
								local s = ""
								for n = 1, space  do
									s = s .. " "
								end
								waypoints[w]["name"] = waypoints[w]["name"] .. s

								space = 4 - string.len(tostring(heading))
								s = ""
								for n = 1, space  do
									s = s .. " "
								end
								heading = heading .. s

								space = 7 - string.len(tostring(distanceStr))
								s = ""
								for n = 1, space  do
									s = s .. " "
								end
								distanceStr = s..distanceStr

								space = 6 - string.len(tostring(ete))
								s = ""
								for n = 1, space  do
									s = s .. " "
								end
								ete = s..ete




								--TODO, revoir ces ce code, pas sur que name garde Target ou autre...essais avec NavTP, a voir comment l'integrer inGame
								-- modification M17
								if flight[f].type == "F-14B" and NavTargetPoints[1] then
									if waypoints[w].name == "Target" or waypoints[w].name == "Attack" then  waypoints[w].NavTP = "ST" end
									if waypoints[w].name == "Station"  then  waypoints[w].NavTP = "DP" end
								end
								waypoints[w]["name"] = waypoints[w]["name"] .. "" .. heading .. " / " .. distance.." / "..ete			--add heading and distance to waypoint name

								if  waypoints[w].briefing_name == "Land"  then
									local tempTime = 0
									local tempTimeStr = ""
									for ww = 1, #waypoints do
										if waypoints[ww].briefing_name == "Departure" then
											 tempTime =   waypoints[w].ETA - waypoints[ww].ETA
											 break
										end
									end
									if tempTime ~= 0 then
										tempTimeStr = FormatTime( tempTime, "hh:mm")
										-- tempTime =  math.floor((tempTime / 60) + 0.5)	.. " mn"

										local space = 6 - string.len(tostring(tempTimeStr))
										local s = ""
										for n = 1, space  do
											s = s .. " "
										end
										waypoints[w]["TotFlightTime"] = s..tempTimeStr
										waypoints[w]["TotFlightDist"] = TotFlightDist .. suffixe

									end
								end
							end
						end
					end


					-- print("AtoFp "..flight[f].task.." _________ wptTargetPass: "..tostring(wptTargetPass).." wptName "..tostring(waypoints[w]["name"]) )
					if flight[f].task == "Anti-ship Strike" and wptTargetPass and  waypoints[w]["name"] ~= "Land"  then
						waypoints[w].ETA_locked = false
						waypoints[w].speed_locked = true
						-- print("AtoFP ETA_locked false")
						-- os.execute 'pause'
					end

				end	-- Fin de Route

				--lock ETA and speed of first waypoint
				waypoints[1].ETA_locked = true
				waypoints[1].speed_locked = true
				if waypoints[1]["speed"] == nil then
					waypoints[1]["speed"] = 1
				end

				--store player waypoints for briefing creation
				if flight[f].player == true then
					camp.player.waypoints = Deepcopy(waypoints)
					if camp.player.waypoints[2] then
						camp.player.waypoints[2].speed = 0
						camp.player.waypoints[2].alt = 0
					end
					-- if camp.player.waypoints[3] then
						-- camp.player.waypoints[3].speed = pack[p].main[1].loadout.vCruise / 4 * 3
					-- end
				end

				-- TODO revoir client
				-- if flight[f].client and flight[f].IdClient then
				-- 	camp.client[flight[f].IdClient].waypoints = Deepcopy(waypoints)
				-- end


				--remove target WP for certain flights
				if target_wp_remove then
					table.remove(waypoints, target_wp_remove)

					for w = target_wp_remove, #waypoints do												--adjust stop condition WPs
						if waypoints[w]["task"]["params"]["tasks"] then									--WP has tasks
							for task_n,task in ipairs(waypoints[w]["task"]["params"]["tasks"]) do		--go through tasks
								if task["params"]["stopCondition"] and task["params"]["stopCondition"]["lastWaypoint"] then					--task has a last waypoint stop condition
									task["params"]["stopCondition"]["lastWaypoint"] = task["params"]["stopCondition"]["lastWaypoint"] - 1	--decreas last WP number by one to account for the removed WP
								end
								if task["params"]["action"] and task["params"]["action"]["id"] == "SwitchWaypoint" then						--task is a switch WP
									task["params"]["action"]["params"]["fromWaypointIndex"] = task["params"]["action"]["params"]["fromWaypointIndex"] - 1
									task["params"]["action"]["params"]["goToWaypointIndex"] = task["params"]["action"]["params"]["goToWaypointIndex"] - 1
								end
							end
						end
					end
				end

				--remove taxi waypoint
				if waypoints[1].name == "Taxi" then

					waypoints[2]["airdromeId"] = waypoints[1]["airdromeId"]
					waypoints[2].linkUnit = waypoints[1].linkUnit
					waypoints[2].helipadId = waypoints[1].helipadId
					waypoints[2].action = waypoints[1]["action"]
					waypoints[2].type = waypoints[1]["type"]

					table.remove(waypoints, 1)

					waypoints[1]["ETA"] = spawn_time
					waypoints[1].ETA_locked = true
					waypoints[1].speed_locked = true

					if waypoints[1]["speed"] == nil then
						waypoints[1]["speed"] = 1
					end

					for w = 1, #waypoints do															--adjust stop condition WPs
						if waypoints[w]["task"]["params"]["tasks"] then									--WP has tasks
							for task_n,task in ipairs(waypoints[w]["task"]["params"]["tasks"]) do		--go through tasks
								if task["params"] and task["params"]["stopCondition"] and task["params"]["stopCondition"]["lastWaypoint"] then					--task has a last waypoint stop condition
									task["params"]["stopCondition"]["lastWaypoint"] = task["params"]["stopCondition"]["lastWaypoint"] - 1	--decreas last WP number by one to account for the removed WP
								end
								if task["params"] and task["params"]["action"] and task["params"]["action"]["id"] == "SwitchWaypoint" then						--task is a switch WP
									task["params"]["action"]["params"]["fromWaypointIndex"] = task["params"]["action"]["params"]["fromWaypointIndex"] - 1
									task["params"]["action"]["params"]["goToWaypointIndex"] = task["params"]["action"]["params"]["goToWaypointIndex"] - 1
								end
							end
						end
					end
				end

				--add descend waypoint
				if flight[f].player ~= true and flight[f].client ~= true then																--for AI flights only
					for w = 3, #waypoints do
						if waypoints[w].alt < waypoints[w - 1].alt and waypoints[w]["type"] ~= "Land" then		--for any descend waypoint that is not the landing waypoint
							local extraWP = Deepcopy(waypoints[w])												--make a copy of the descend waypoint
							extraWP.x = (waypoints[w].x + waypoints[w + -1].x) / 2								--position half-way between descend waypoint and previous waypoint
							extraWP.y = (waypoints[w].y + waypoints[w + -1].y) / 2								--position half-way between descend waypoint and previous waypoint
							extraWP.ETA = (waypoints[w].ETA + waypoints[w + -1].ETA) / 2						--ETA half-way between descend waypoint and previous waypoint
							extraWP.task.params.tasks = {}
							extraWP.name = "AI Descend Helper"
							table.insert(waypoints, w, extraWP)

							--adjust stop condition and switch WPs
							for w2 = w, #waypoints do															--go through waypoints from inserted WP to end
								if waypoints[w2]["task"]["params"]["tasks"] then								--WP has tasks
									for task_n,task in ipairs(waypoints[w2]["task"]["params"]["tasks"]) do		--go through tasks
										if task["params"] and task["params"]["stopCondition"] and task["params"]["stopCondition"]["lastWaypoint"] then					--task has a last waypoint stop condition
											task["params"]["stopCondition"]["lastWaypoint"] = task["params"]["stopCondition"]["lastWaypoint"] + 1	--increase last WP number by one to account for the inserted WP
										end
										if task["params"] and task["params"]["action"] and task["params"]["action"]["id"] == "SwitchWaypoint" then						--task is a switch WP
											task["params"]["action"]["params"]["fromWaypointIndex"] = task["params"]["action"]["params"]["fromWaypointIndex"] + 1
											task["params"]["action"]["params"]["goToWaypointIndex"] = task["params"]["action"]["params"]["goToWaypointIndex"] + 1
										end
									end
								end
							end
						end
					end
				end

				--first waypoint reaction to threat
				local task_entry = {
					["number"] = #waypoints[1]["task"]["params"]["tasks"] + 1,
					["auto"] = false,
					["id"] = "WrappedAction",
					["name"] = "reaction to threats, avoidance of fire",
					["enabled"] = true,
					["params"] =
					{
						["action"] =
						{
							["id"] = "Option",
							["params"] =
							{
								["value"] = 2,
								["name"] = 1,
							},
						},
					},
				}
				table.insert(waypoints[1]["task"]["params"]["tasks"], task_entry)

				--ATO_FP_Reglage01 : emport, ne pas larguer les emports en cas d'urgence pour les Strike
				--first waypoint restrict jettison for SEAD
				-- if mission_ini.AIemergencyLaunch then

				if not is_helicopter then
					if flight[f].task == "SEAD" or flight[f].task == "Strike" or flight[f].task == "Anti-ship Strike" or flight[f].task == "Flare Illumination" or flight[f].task == "Laser Illumination" then
						--interdit le largage des charges s'il y a une escorte
						if pack[p]["Escort"][1] and pack[p]["Escort"][1].firepower > 2 then
							local task_entry = {
								["enabled"] = true,
								["auto"] = false,
								["id"] = "WrappedAction",
								["name"] = "emergency jettison",
								["number"] = #waypoints[1]["task"]["params"]["tasks"] + 1,
								["params"] =
								{
									["action"] =
									{
										["id"] = "Option",
										["params"] =
										{
											["value"] = false,		--true: autorise le largage d urgence, false interdit le largage
											["name"] = 15,
										},
									},
								},
							}
							table.insert(waypoints[1]["task"]["params"]["tasks"], task_entry)
						else
							--autorise le largage des charges s'il n'y a pas d'escorte
							local task_entry = {
								["enabled"] = true,
								["auto"] = false,
								["id"] = "WrappedAction",
								["name"] = "emergency jettison",
								["number"] = #waypoints[1]["task"]["params"]["tasks"] + 1,
								["params"] =
								{
									["action"] =
									{
										["id"] = "Option",
										["params"] =
										{
											["value"] = true,		--true: autorise le largage d urgence, false interdit le largage
											["name"] = 15,
										},
									},
								},
							}
							table.insert(waypoints[1]["task"]["params"]["tasks"], task_entry)
						end
					end
				end

				--first waypoint restrict air-air
				if flight[f].loadout.restrict_aa then
					local task_entry = {
						["enabled"] = true,
						["auto"] = false,
						["id"] = "WrappedAction",
						["number"] = #waypoints[1]["task"]["params"]["tasks"] + 1,
						["params"] =
						{
							["action"] =
							{
								["id"] = "Option",
								["params"] =
								{
									["value"] = true,
									["name"] = 14,
								},
							},
						},
					}
					table.insert(waypoints[1]["task"]["params"]["tasks"], task_entry)
				end

				--first waypoint no RTB on bingo
				if flight[f].airdromeId == nil then
					local task_entry = {
						["enabled"] = true,
						["auto"] = false,
						["id"] = "WrappedAction",
						["number"] = #waypoints[1]["task"]["params"]["tasks"] + 1,
						["params"] =
						{
							["action"] =
							{
								["id"] = "Option",
								["params"] =
								{
									["value"] = false,
									["name"] = 6,
								},
							},
						},
					}
					table.insert(waypoints[1]["task"]["params"]["tasks"], task_entry)
				end


				if flight[f].task == "CSAR" then
					--ajuste l'altitude des helico en zone montagneuse, ils ont beaucoup de mal en alti radar
					for n = 1, #waypoints do
						if waypoints[n].type == "Land" then
							waypoints[n].action = "LandingReFuAr"
							waypoints[n].type = "LandingReFuAr"
						end
						if waypoints[n]["briefing_name"] == "Join" or waypoints[n]["briefing_name"] == "Nav" or waypoints[n]["briefing_name"] == "Split"  then
							waypoints[n]["alt"] = waypoints[n]["alt"] + db_airbases[flight[f].base].elevation
						end
						if waypoints[n]["briefing_name"] == "IP" or waypoints[n]["briefing_name"] == "Attack"  then   -- or waypoints[n]["briefing_name"] == "Egress"

							local altEjected  = flight[f].target.elements[1].z2d + 100

							waypoints[n]["alt"] = altEjected

							--demande à tous les ejectedPilot de la zone d'allumer leur radio à 10mn avant l'eta
							for p=1, #camp.SAR.pilotEjected do
								if camp.SAR.pilotEjected[p].MGRS_Chute == flight[f].target_name
								and camp.SAR.pilotEjected[p].side == side then
									camp.SAR.pilotEjected[p].radio_start = waypoints[n].ETA - 600
								end
							end
						end

					end
				end


				--********************************************************************************
				--create units START
				--********************************************************************************			
				----- define units -----

				-- modification M11.l : Multiplayer (M11.l:groupe superieur à 2 possible)
				if Multi.NbGroup >= 1 then
					if  flight[f].client  or  flight[f].player  then
						if flight[f].number >= 2 and flight[f].NbPlaneClient <=2 then																			-- on ne veut pas d'avionIA au dela de 2
							flight[f].number = 2
						elseif flight[f].NbPlaneClient > 4 then
							flight[f].number = 4
						else
							flight[f].number = flight[f].NbPlaneClient
						end
					end
				end

				local skillTab = {
					[1] = "Average",				-- don't touch
					[2] = "Good", 					-- don't touch
					[3] = "High",					-- don't touch
					[4] = "Excellent",				-- don't touch
				}


				local units = {}

				if flight[f].number > 0 and flight[f].number < 1 then flight[f].number = 1 end

				-- --pour eviter le pb du flight 2 du main(strike) qui peut etre en comflit avec une escorte strike 		
				-- local tempNumFlight = f
				-- local groupName = "Pack " .. p .. " - " .. flight[f].name .. " - " .. flight[f].task .. " " .. tempNumFlight
				-- repeat
				-- 	tempNumFlight = tempNumFlight + 1
				-- 	groupName = "Pack " .. p .. " - " .. flight[f].name .. " - " .. flight[f].task .. " " .. tempNumFlight
				-- until not allFlightName_AtoFP[groupName]

				local calcWish
				local randSkill


				for n = 1, flight[f].number do
					-- modification M12.b : Skill
					-- le niveau est s�par� en 4 (25% de 100)
					--Average (0 à 25)
					--Good (25 à 50)
					--High (50 à 75)
					--Excellent (75 à 100)

					if string.lower(flight[f].skill) == "high" and not( mission_ini.slider_EnemyLevel or type(mission_ini.slider_EnemyLevel == "number")) then				--M52_b
						calcWish = 62
					else
						calcWish = SkillWish[side]
					end

					local mSkill = 2
					if n == 1 then
						mSkill = ( math.random(calcWish-20, calcWish+18) / 25 ) + 1		-- 75-62 = 13 (13 + 5 = 18 )5 % de chance d'avoir excellent
					else
						mSkill = ( math.random(calcWish-50, calcWish+10) / 25) + 1
					end

					if  (flight[f].player or flight[f].client) and n == 2 then
						-- pour éviter à l'ailier de percuter le joueur, on lui donne un Hight ou Excellent
						--75% de chance qu'il soit Hight
						--25% de chance qu'il soit Excellent
						randSkill = math.random(100)
						if randSkill >= 75 then
							mSkill = 4
						else
							mSkill = 3
						end
					end

					if  (flight[f].player or flight[f].client) and n == 2 then
						mSkill = 4
					end
					-- mSkill = math.floor(mSkill) + 1					
					mSkill = math.floor(mSkill)

					if mSkill <= 1 then mSkill = 1
					elseif mSkill >= 4 then mSkill = 4
					-- else mSkill = mSkill
					end

					local skill = ""
					if mission_ini.randomizeSkills then
						skill = skillTab[mSkill]
					else
						skill = flight[f].skill
					end

					local fuelTemp = flight[f].loadout.stores.fuel
					if (flight[f].task == "Refueling" or flight[f].task == "AWACS")
						and waypoints[1].briefing_name and  waypoints[1].briefing_name == "Spawn"
						and flight[f].route[1].airstart
					then
						fuelTemp = fuelTemp * 0.75
					end

					local unitName = groupName .. "-" .. n

					local unitIdTemp = 1
					if not UnitByName[unitName] then
						unitIdTemp = GenerateIDUnit(unitName)
					end

					local define_x = waypoints[1]["x"]
					local define_y = waypoints[1]["y"]

					if n >= 2 and not (is_helicopter and waypoints[1].action == "From Ground Area" and baseIsFARP ) then
						define_x = waypoints[1]["x"] + ((n - 1) * 15) +  ((f-1) * 15) + ((p - 1) * 15) -- ATO_FP_Debug01	--ANTI-COLLISION B
						define_y = waypoints[1]["y"] + ((n - 1) * 15) +  ((f-1) * 15) + ((p - 1) * 15) --ATO_FP_Debug01 	--ANTI-COLLISION B
					end

					units[n] =
					{
						["alt"] = waypoints[1].alt,
						["heading"] = 0,
						["callsign"] = GetCallsign(flight[f].country, f, n, flight[f].task, flight[f]),
						["psi"] = 0,
						["livery_id"] = flight[f].livery,
						["type"] = flight[f].type,
						["x"] = define_x ,
						["y"] = define_y ,
						["name"] = unitName,
						-- ["payload"] = flight[f].loadout.stores,
						["payload"] = {
							["pylons"] = flight[f].loadout.stores.pylons,
							["fuel"] = fuelTemp,
							["flare"] = flight[f].loadout.stores.flare,
							["chaff"] = flight[f].loadout.stores.chaff,
							["gun"] =  flight[f].loadout.stores.gun,										-- ATO_FP_Debug04 Gun = 0 uniquement sur un Flight
							['DCE_payloadtName'] = flight[f].loadout.name,
						},
						["AddPropAircraft"] = flight[f].loadout.AddPropAircraft,
						["speed"] = waypoints[1].speed,
						["unitId"] = unitIdTemp,
						["alt_type"] = waypoints[1].alt_type,
						["skill"] = skill,
						["hardpoint_racks"] = true,

					}


					--datalink 2.9
					--ajoute le paragraphe datalink uniquement pour les receveurs
					if Data_divers[flight[f].type] and Data_divers[flight[f].type].datalinks and Data_divers[flight[f].type].datalinks.isReceiver then
						local typeDatalink = Data_divers[flight[f].type].datalinks.type

						units[n]["datalinks"] = {
							[typeDatalink] = 	Deepcopy(datalinks[typeDatalink][flight[f].type])
						}
					end

					--ajout les restrictions au loadout s il y en a
					if (flight[f].player or flight[f].client) then
						for typeAircraft, payloadProhibited in pairs(PayloadRestricted) do
							if typeAircraft and payloadProhibited and flight[f].type == typeAircraft then
								units[n].payload.restricted = payloadProhibited
							end
						end
					end

					--FARP parking id
					-- if  flight[f].airdromeId >= 100 then
					if baseIsFARP and waypoints[1].action ~= "Spawn" then
						if not LimitedParkTiming and not flight[f]["parkAlertSAR"] then

							units[n]["parking"] = tostring(n)
							units[n]["parking_id"] = tostring(n)

						elseif flight[f]["parkAlertSAR"] and flight[f]["parkAlertSAR"][n] then

							if n==1 then
								--groups.xy se fera plus loin, dans le code, avec waypoints[1].xy comme ref
								waypoints[1].action = "From Ground Area"
								waypoints[1].type = "TakeOffGround"
								waypoints[1].x = flight[f]["parkAlertSAR"][n].x
								waypoints[1].y = flight[f]["parkAlertSAR"][n].y
								units[n].x = flight[f]["parkAlertSAR"][n].x
								units[n].y = flight[f]["parkAlertSAR"][n].y
							else
								units[n].x = flight[f]["parkAlertSAR"][n].x
								units[n].y = flight[f]["parkAlertSAR"][n].y
							end

							--on le fait reposer au meme endroit:
							waypoints[#waypoints].action = "Landing"
							waypoints[#waypoints].type = "Land"
							waypoints[#waypoints].x = flight[f]["parkAlertSAR"][n].x
							waypoints[#waypoints].y = flight[f]["parkAlertSAR"][n].y

						end
						--pour les helico qui serait sur base, mais avec des points SAR utilisable
					elseif is_helicopter and waypoints[1].action ~= "Spawn" then
						if flight[f]["parkAlertSAR"] and flight[f]["parkAlertSAR"][n] then

							if n==1 then
								--groups.xy se fera plus loin, dans le code, avec waypoints[1].xy comme ref
								waypoints[1].action = "From Ground Area"
								waypoints[1].type = "TakeOffGround"
								waypoints[1].x = flight[f]["parkAlertSAR"][n].x
								waypoints[1].y = flight[f]["parkAlertSAR"][n].y
								units[n].x = flight[f]["parkAlertSAR"][n].x
								units[n].y = flight[f]["parkAlertSAR"][n].y
							else
								units[n].x = flight[f]["parkAlertSAR"][n].x
								units[n].y = flight[f]["parkAlertSAR"][n].y
							end

							--on le fait reposer au meme endroit:
							waypoints[#waypoints].action = "Landing"
							waypoints[#waypoints].type = "Land"
							waypoints[#waypoints].x = flight[f]["parkAlertSAR"][n].x
							waypoints[#waypoints].y = flight[f]["parkAlertSAR"][n].y

						end
					end


					-- n assigne pas de parking aux IA qui spawn in air
					if waypoints[1].action == "From Parking Area" and not LimitedParkTiming and not db_airbases[flight[f].base].BaseAirStart then
						if not flight[f]["parkAlertSAR"] and flight[f].parking_id then

							local parkParameters = GetParkingId( flight[f].parking_id, flight[f].base)

							if parkParameters and parkParameters["parking_id"] then
								units[n]["parking_id"] = parkParameters["parking_id"]
							end

							-- local parkParameters = GetParkingId( flight[f].parking_id, flight[f].base)

							-- if parkParameters and parkParameters["parking_id"] then
							-- 	units[n]["heading"] = parkParameters["heading"]
							-- 	units[n]["parking"] = parkParameters["parking"]
							-- 	units[n]["parking_id"] = parkParameters["parking_id"]
							-- 	units[n]["x"] = parkParameters["x"]
							-- 	units[n]["y"] = parkParameters["y"]
							-- 	if n==1 then
							-- 		waypoints[1].x = parkParameters["x"]
							-- 		waypoints[1].y = parkParameters["y"]
							-- 	end
							-- end


						elseif flight[f]["parkAlertSAR"] and flight[f]["parkAlertSAR"][n] then
							if n==1 then
								--groups.xy se fera plus loin, dans le code, avec waypoints[1].xy comme ref
								waypoints[1].action = "From Ground Area"
								waypoints[1].type = "TakeOffGround"
								waypoints[1].x = flight[f]["parkAlertSAR"][n].x
								waypoints[1].y = flight[f]["parkAlertSAR"][n].y
								units[n].x = flight[f]["parkAlertSAR"][n].x
								units[n].y = flight[f]["parkAlertSAR"][n].y
							else
								units[n].x = flight[f]["parkAlertSAR"][n].x
								units[n].y = flight[f]["parkAlertSAR"][n].y
							end

							--on le fait reposer au meme endroit:
							waypoints[#waypoints].action = "Landing"
							waypoints[#waypoints].type = "Land"
							waypoints[#waypoints].x = flight[f]["parkAlertSAR"][n].x
							waypoints[#waypoints].y = flight[f]["parkAlertSAR"][n].y
						end

					end

					if flight[f].sidenumber and flight[f].sidenumber[1] and flight[f].sidenumber[2] then		--squadron has sidenumbers defined
						units[n]["onboard_num"] = GetSidenumber(flight[f].name, flight[f].sidenumber[1], flight[f].sidenumber[2],n , flight[f].player, flight[f].type)	--get new sidenumber
					else																						--squadron has no sidenumbers defined
						-- units[n]["onboard_num"] = "0" .. math.random(1, 99)										--us a random number
						units[n]["onboard_num"] = math.random(1, 99)										--us a random number
						units[n]["onboard_num"] = string.format("%03d", units[n]["onboard_num"])
					end

					--multiple skins for aircraft
					if flight[f].liveryModex then
						if flight[f].liveryModex[tonumber(units[n]["onboard_num"])] then
							units[n]["livery_id"] = flight[f].liveryModex[tonumber(units[n]["onboard_num"])]
						end
					end

					-- if units[n]["livery_id"] and type(units[n]["livery_id"]) == "table" then
					if units[n]["livery_id"] and type(units[n]["livery_id"]) == "table"  then					--if skin is a table							
						if  #units[n]["livery_id"] ~= 0 then
							units[n]["livery_id"] = units[n]["livery_id"][math.random(1, #units[n]["livery_id"])]	--chose a random skin from table
						else
							units[n]["livery_id"] = ""
						end
					end

					--prend en compte en priorité la version AddProp du loadout
					if units[n]["AddPropAircraft"] == false or units[n]["AddPropAircraft"] == nil then

						-- -- inheritedFrom
						-- local type_withData= flight[f].type
						-- if Data_divers and Data_divers.inheritedFrom then
						-- 	type_withData= Data_divers.inheritedFrom
						-- end

						if Data_AddPropAircraft[type_withProp]  then
							--ajoute AddPropAircraft aux types joueur/client
							units[n]["AddPropAircraft"] = Deepcopy(Data_AddPropAircraft[type_withProp])

							if Data_divers[flight[f].type].alignment_PropAircraft and Data_divers[flight[f].type].alignment_PropAircraft[mission_ini.alignment_Mode] then

								--règle la/les valeurs des variables de vitesse d'alignement dans la table AddPropAircraft 
								for key, value in pairs(Data_divers[flight[f].type].alignment_PropAircraft[mission_ini.alignment_Mode]) do
									units[n]["AddPropAircraft"][key] = value
								end
							end
						else
							units[n]["AddPropAircraft"] =
							{
							}
						end
					end

					if flight[f].modification then
						if not units[n]["AddPropAircraft"] then units[n]["AddPropAircraft"] = {} end
						units[n]["AddPropAircraft"].modification = flight[f].modification
					end

					if units[n]["AddPropAircraft"].modification then
						if type(units[n]["AddPropAircraft"].modification) == "table" then
							units[n]["AddPropAircraft"].modification = units[n]["AddPropAircraft"].modification[1]
						end
					end

					--dataCartridge 2.9
					if Data_divers[flight[f].type] and Data_divers[flight[f].type].dataCartridge then
						units[n]["dataCartridge"] = 	Deepcopy(dataCartridge)
					end



					--remove gun ammunition from AI escorts to prevent them from strafing aircraft on the ground at hostile air bases
					-- if (flight[f].task == "Escort" and not flight[f].player ) and (flight[f].task == "Escort" and not flight[f].client ) then	--if fligh is taskes as escort and is not player flight
					if flight[f].task == "Anti-ship Strike" and not (flight[f].player or flight[f].client) then	--or Multi.NbGroup >= 1
						if units[n].payload.gun and units[n].payload.gun == 100 then								--if loadout has full gun ammo
							units[n].payload.gun = 0																--remove all gun ammo
						end
					end

					--pour brief et debrief, recupere le name de l'unité
					--et seulement le name, on oublie le reste pour eviter d'enregistrer des trucs trop lourd
					if not flight[f]["units"] then flight[f]["units"] = {} end
					if not flight[f]["units"][n] then flight[f]["units"][n] = units[n] end

					-- flight[f]["units"][n] = {
					-- 	name = units[n].name
					-- }


				end -- for n = 1, flight[f].number do
				--********************************************************************************
				--create units FIN
				--********************************************************************************

				--********************************************************************************
				--datalink 2.9
				--********************************************************************************
				if Data_divers[flight[f].type] and Data_divers[flight[f].type].datalinks and Data_divers[flight[f].type].datalinks.type then

					local typeDatalink = Deepcopy(Data_divers[flight[f].type].datalinks.type)

					--récupere les id des autres membres du group
					local recordId = {}
					for n=1, #units do
						recordId[n] = units[n].unitId
					end

					if typeDatalink == "Link16" or  typeDatalink == "SADL" then
						local isDonnor = Data_divers[flight[f].type].datalinks.isDonnor
						local isReceiver = Data_divers[flight[f].type].datalinks.isReceiver

						for n=1, #units do
							local copyRecordId = Deepcopy(recordId)

							if not units[n].AddPropAircraft then
								--essentielement pour les donnors
								units[n].AddPropAircraft = Deepcopy(AddPropAircraft_datalinks[typeDatalink])
							else
								for keyA, valueA in  pairs(AddPropAircraft_datalinks[typeDatalink]) do
									if not units[n].AddPropAircraft[keyA] then
										units[n].AddPropAircraft[keyA] = Deepcopy(valueA)
									end
								end
							end

							if units[n]["AddPropAircraft"]["STN_L16"] then
								--essentielement pour les donnors HA BON?
								units[n]["AddPropAircraft"]["STN_L16"] =  Get_L16_Id()
								if not pack_L16_unitId[p] then pack_L16_unitId[p] = {} end
								table.insert(pack_L16_unitId[p], units[n].unitId)
							elseif units[n]["AddPropAircraft"]["SADL_TN"] then
								units[n]["AddPropAircraft"]["SADL_TN"] =  Get_SADL_Id()
								if not pack_SADL_unitId[p] then pack_SADL_unitId[p] = {} end
								table.insert(pack_SADL_unitId[p], units[n].unitId)
							end

							--["VoiceCallsignLabel"] = "CT",
							--callsign["name"] = "Ragin71",
							if units[n].callsign and units[n].callsign.name then
								local tempName = string.sub( units[n].callsign.name, 1, -3)
								local tempName1 = tempName:sub(1,1)
								local tempName2 = tempName:sub(-1,-1)
								units[n].AddPropAircraft.VoiceCallsignLabel = string.upper(tempName1..tempName2)
							end

							if units[n].callsign and units[n].callsign[3] then
								units[n].AddPropAircraft.VoiceCallsignNumber = units[n].callsign[2]..units[n].callsign[3]
							end

							--pour les receveir uniquement						
							if isReceiver then
								--pour assigner le lead
								if typeDatalink == "SADL" or (flight[f].type == "F-16C_50" ) then
									if  n == 1 then
										units[n].datalinks[typeDatalink].settings.flightLead = true
									else
										units[n].datalinks[typeDatalink].settings.flightLead = false
									end
								end

								--pour distribuer les unitId aux members
								for m = 1, flight[f].number do
									if m == 1 then
										units[n].datalinks[typeDatalink].network.teamMembers[m] = {missionUnitId = units[n].unitId}
										for r, copyId in pairs(copyRecordId) do
											if copyId == units[n].unitId then
												table.remove(copyRecordId, r)
											end
										end
										if flight[f].type == "F-16C_50" then
											units[n].datalinks[typeDatalink].network.teamMembers[m].TDOA = true

										end
									else

										if #copyRecordId >= 1 then
											units[n].datalinks[typeDatalink].network.teamMembers[m] = {missionUnitId = copyRecordId[1]}
											table.remove(copyRecordId, 1)
											if flight[f].type == "F-16C_50" then
												units[n].datalinks[typeDatalink].network.teamMembers[m].TDOA = true

											end
										end

									end
								end


								--pour distribuer les unitId aux members
								for m, member in ipairs(units[n].datalinks[typeDatalink].network.teamMembers) do
									if m == 1 then
										member.missionUnitId = units[n].unitId
										for r, copyId in pairs(copyRecordId) do
											if copyId == units[n].unitId then
												table.remove(copyRecordId, r)
											end
										end
										if flight[f].type == "F-16C_50" then
											member["TDOA"] = true

										end
									else

										if #copyRecordId >= 1 then
											member.missionUnitId = copyRecordId[1]
											table.remove(copyRecordId, 1)
											if flight[f].type == "F-16C_50" then
												member["TDOA"] = true

											end
										end

									end

								end
							end

							-- if n == 1 then
							-- 	units[n].datalinks[typeDatalink].settings.flightLead = true
							-- end

						end
					elseif typeDatalink == "IDM" then
						for n=1, #units do
							local copyRecordId = Deepcopy(recordId)
							if not units[n].AddPropAircraft then
								--essentielement pour les donnors
								units[n].AddPropAircraft = Deepcopy(AddPropAircraft_datalinks[typeDatalink])
							else
								for keyA, valueA in  pairs(AddPropAircraft_datalinks[typeDatalink]) do
									if not units[n].AddPropAircraft[keyA] then
										units[n].AddPropAircraft[keyA] = Deepcopy(valueA)
									end
								end
							end

							if units[n]["AddPropAircraft"]["TN_IDM_LB"] then

								units[n]["AddPropAircraft"]["TN_IDM_LB"] =  tostring(Get_IDM_Id())
								if not pack_IDM_unitId[p] then pack_IDM_unitId[p] = {} end
								table.insert(pack_IDM_unitId[p], units[n].unitId)
							end

							--	["TN_IDM_LB"] = "2",							--max : 39
							-- ["OwnshipCallSign"] = "G-2",
							-- units[n].AddPropAircraft.OwnshipCallSign = "G-"..units[n]["AddPropAircraft"]["TN_IDM_LB"]

							--["VoiceCallsignLabel"] = "CT",
							--callsign["name"] = "Ragin71",

							local tempName, tempName1, tempName2
							local suffixe = units[n]["AddPropAircraft"]["TN_IDM_LB"]
							if units[n].callsign and units[n].callsign.name then
								tempName = string.sub( units[n].callsign.name, 1, -3)
								tempName1 = tempName:sub(1,1)
								tempName2 = tempName:sub(-1,-1)
							end

							if units[n].callsign and units[n].callsign[3] then
								suffixe = units[n].callsign[2]..units[n].callsign[3]
							end

							units[n].AddPropAircraft.OwnshipCallSign = string.upper(tempName1..tempName2)..suffixe

							--pour les receveir uniquement						
							for pr, preset in ipairs(units[n].datalinks[typeDatalink].network.presets) do

								for m, member in ipairs(preset.members) do

									if m == 1 then
										member.missionUnitId = units[n].unitId
										for r, copyId in pairs(copyRecordId) do
											if copyId == units[n].unitId then
												table.remove(copyRecordId, r)
											end
										end
									else

										if #copyRecordId >= 1 then
											member.missionUnitId = copyRecordId[1]
											table.remove(copyRecordId, 1)
										end

									end
								end
							end
						end
					end

				end

				----- define group -----
				local testFreqency = GetFrequency(side, flight[f].target_name, flight[f].task, type_withData, nil)


				--certain plane ne peuvent pas dépasser les valeurs de la radio 1 pour la frequence générale (exemple M-2000)
				local info = ""
				if frequency[type_withData] and frequency[type_withData].radio.frequencyMustBeRadio1 then
					if not FreqCapability2(testFreqency, type_withData, 1, info) then

						local foundFreq = false
						if frequency[type_withData].radio then
							for range, value in pairs(frequency[type_withData].radio) do
								local i=0
								repeat
									testFreqency = GetFrequency(side, groupName, flight[f].task, type_withData, range)
									print("AtoFP testFreqency: "..testFreqency)
									if FreqCapability2(testFreqency, type_withData, 1, info) then
										foundFreq = true
									end
									i=i+1
								until foundFreq or i > 10

								if foundFreq then break end

							end
						end
					end

					if not FreqCapability2(testFreqency, type_withData, 1, info) then
						print("AtoFP error frequency: "..type_withData.." "..testFreqency)
						_affiche(frequency[type_withData].radio, "UtilF frequency[flightType].radio")
						os.execute 'pause'
					end
				end

				if frequency[type_withData] and frequency[type_withData]["onlyVariableFrequency"] then

					if testFreqency >= frequency[type_withData].onlyVariableFrequency.min
					and testFreqency <= frequency[type_withData].onlyVariableFrequency.max
					then
						-- print("AtoFp frequency Passe C Frequence "..tostring(testFreqency))
					else

						local wave = FoundWave(frequency[type_withData].onlyVariableFrequency)

						testFreqency = GetFrequency(side, flight[f].target_name, flight[f].task, type_withData, wave)

						if testFreqency < frequency[type_withData].onlyVariableFrequency.min
						or testFreqency > frequency[type_withData].onlyVariableFrequency.max
						then
							print("AtoFp frequency "..tostring(testFreqency).." BUG with "..tostring(type_withData))
							os.execute 'pause'
						end
					end
				end

				if tonumber(testFreqency) == 243 or tonumber(testFreqency) == 121.5 then
					print("ATTENTION GUARD Frequence "..tostring(testFreqency))
					os.execute 'pause'
				end

				if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe waypoints[1][x] AA "..tostring(waypoints[1]["x"])) end


				local group =
				{
					-- ['frequency'] = GetFrequency(side, flight[f].target_name, flight[f].task, flight[f].type),				-- M06
					['frequency'] = testFreqency,
					['taskSelected'] = true,
					['modulation'] = 0,
					['groupId'] = GenerateIDGroup(),
					['tasks'] = {
					},
					['route'] = {
						['points'] = waypoints,
					},
					['hidden'] = true,
					['units'] = units,
					['radioSet'] = true,
					-- ["name"] = "Pack " .. p .. " - " .. flight[f].name .. " - " .. flight[f].task .. " " .. (f + addNflight),
					["name"] = groupName,
					['communication'] = true,
					['x'] = waypoints[1]["x"],
					['y'] = waypoints[1]["y"],
					['start_time'] = 1,	--start_time_bug = 1,
					['task'] = flight[f].task,
					['uncontrolled'] = false,
					['DCE_targetName'] = flight[f].target_name,

				}

				if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe group[x] BB "..tostring(group["x"])) end

				--ajoute la frequence à l AFAC
				if flight[f].task == "AFAC"  then
					for w=1, #waypoints do
						if waypoints[w]["task"] and waypoints[w]["task"]["params"] and waypoints[w]["task"]["params"]["tasks"] then
							for i_task, _task in pairs(waypoints[w]["task"]["params"]["tasks"]) do
								if _task and _task.id and _task.id == "FAC" then
									_task.params.frequency = testFreqency * 1000000
								end
							end
						end
					end

				end

				if flight[f].task == "SAR" then
					if not camp.SAR then camp.SAR = {} end
					if not camp.SAR.helicopter then camp.SAR.helicopter = {} end
					table.insert(camp.SAR.helicopter, group.name )
				end

				-- ATO_FP_Debug01 
				-- decale les apparitions en vol pour eviter les collisions en vol
				if waypoints[1].type == "Turning Point" and waypoints[1]["briefing_name"] == "Spawn" and not flight[f].task == "AFAC"  then
					for	n = 1 , #group.units do
						group.units[n].x = ((p-1) * 15) + ((f-1) * 15) + group.units[n].x + (15 * n)	--ANTI-COLLISION C
						group.units[n].y = ((p-1) * 15) + ((f-1) * 15) + group.units[n].y + (15 * n)	--ANTI-COLLISION C
					end
				end

				-- modif M17
				if flight[f].type == "F-14B" and NavTargetPoints[1] then
					 group["NavTargetPoints"]= NavTargetPoints
				end


				--======================================
				group['task'] = GoupTaskTemp

				-- print("AtoFP task GoupTaskTemp "..tostring(GoupTaskTemp))


				---- unhide player package -----
				if mission_ini.cheat_Mod_Eye  then																--debug is on
					group.hidden = false														--unhide all groups
				elseif camp.player and camp.player.side == side then							--player side										
					group.hidden = false														--unhide group
					--if camp.player.pack_n == p then											--package is player package
						--group.hidden = false													--unhide group
					--elseif flight[f].task == "AWACS" then										--flight is an AWACS on player side
						--group.hidden = false													--unhide group
					--elseif flight[f].task == "Refueling" then									--flight is a tanker on player side
						--group.hidden = false													--unhide group
					--end
				elseif camp.client and 	flight[f].IdClient and camp.client[flight[f].IdClient].side == side then							--player side										
					group.hidden = false														--unhide group
				end

				-- modification M31 	Remove all static aircraft from the deck
				if  mission_ini.CV_CleanDeck == true and string.find(flight[f].base,"CV") then
					DeleteStaticOnCV(flight[f].base)
				end

				if not Data_configuration.SC_SpawnOn[flight[f].type] then Data_configuration.SC_SpawnOn[flight[f].type] = "deck" end

				local SpawnDeck = true
				local SpawnAir = false
				local SpawnCata = false

				if baseIsCarrier and not ( flight[f].player or flight[f].client ) then
					if Data_configuration.SC_SpawnOn[flight[f].type] == "catapult" then
						SpawnDeck = false
						SpawnCata = true
					elseif Data_configuration.SC_SpawnOn[flight[f].type] == "air" then
						SpawnDeck = false
						SpawnAir = true
					end
				end

				--||||||| INFORMATIOn TUTORIAL TUTORIEL
				--||||||| START seulement utile au sol
				--||||||| uncontrolled : SOL :permet d'utiliser (START + a_set_ai_task) au SOL

				--||||||| lateActivation : SOL + VOL + a_activate_group (invisible avant cela)

				--|||||||  lateActivation : utile avec apparition joueur décalé sur PA (lié à activeGroup ou ai start?)

				--||||||| conclusion:
				--|||||||  SOL decale et visible : uncontrolled + (START + a_set_ai_task)
				--|||||||  SOL decale 			 : lateActivation + a_activate_group

				--|||||||  VOL decale			: ["start_time"] = 60, + ETA = 60 etc
				--|||||||  VOL decale			: lateActivation + a_activate_group

				--|||||||  VOL sur TRIGGER: lateActivation + triggerActiveGroup

				--||||||| CV
				--||||||| uncontrolled
				--||||||| lateActivation
				--||||||| a_activate_group (fait apparaitre l'avion sans pilote)
				--||||||| (START + a_set_ai_task) (pilote + demarrage)

				if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("") end
				if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP FirstMsg " .. groupName) end

				if (not spawn_time or spawn_time == nil or spawn_time == "") and departure_time ~= "" then
					spawn_time = departure_time
				end

				local activate_time = spawn_time
				local FlagInsertSixpack = false

				-- local taxi_time = spawn_time
				-- = - = - = - = -- = - = - = - = - = - = - = - = - = - = -- = - = - = - = - = - = - = - = - = - = -- = - = - = - = - = - = - = - = - = - = -- = - = - = - = - = - = -
				--Player & Client on SuperCarrier
				-- = - = - = - = -- = - = - = - = - = - = - = - = - = - = -- = - = - = - = - = - = - = - = - = - = -- = - = - = - = - = - = - = - = - = - = -- = - = - = - = - = - = -
				if baseIsCarrier and  ( flight[f].player or flight[f].client ) and waypoints[1]["type"] ~= "Turning Point" then --??? LimitedParkTiming? vraiment pour le joueur?
					if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe 0A-a SinglePlayer ..NbPlanetDeck: "..NbPlanetDeck) end

					spawn_time = mission_ini.startup_time_player

					if flight[f].task == "Intercept"  or   flight[f].task == "SAR" then
						spawn_time = -1
					end

					group.start_time = 0	--start_time_bug group.start_time = 1
					group['route']['points'][1]["ETA"] = 0

					local PlayerSixPack = {}
					if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe PlayerClient AddtimingDeckCata "..spawn_time) end
					--construit une table que l'on triera plus tard pour decider qui a le droit d etre sur le sixpack et ne pas gener les autres
					PlayerSixPack = {
						time = spawn_time ,
						groupName = group.name,
						number = flight[f].number,
						LimitedParkNb = db_airbases[flight[f].base].LimitedParkNb,
						client = true,
						}

					FlagInsertSixpack = true
					if not testSixPack[flight[f].base] then testSixPack[flight[f].base] = {} end
					table.insert(testSixPack[flight[f].base],  PlayerSixPack)
				end

				--LimitedParkTiming RAPPEL concerne: CV LHA FARP et Petite BASE, si le nombre de place est superieur à db_airbases.LimitedParkNb				
				----- late groups spawn uncontrolled at mission start -----
				-- if ((group['route']['points'][1]["ETA"] > 0 and flight[f].task ~= "Intercept")  or LimitedParkTiming ) and  not flight[f].player and not flight[f].client
				if (( flight[f].task ~= "Intercept"  and flight[f].task ~= "SAR") or LimitedParkTiming ) and not flight[f].player and not flight[f].client and waypoints[1]["type"] ~= "Turning Point"
					then	--group launches after mission start																	-- calcul le nombre de flight dans un Package, en comptant ceux des Roles				
					if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe AA LimitedParkTiming "..tostring(LimitedParkTiming)) end

					if baseIsCarrier then			--for groups on aircraft carriers
						if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe BB unitname+FARP "..group['route']['points'][1]["ETA"].." Multi.NbGroup?: "..tostring(Multi.NbGroup).." MultiPlayer.pack_n[p?: ".. tostring(camp.MultiPlayer.pack_n[p]) .." SingleWithDServerAiAir?: "..tostring(SingleWithDServerAiAir) ) end

						--permet de spawner les avions avant qu'ils ne démarrent
						if spawn_time - 120	>  (mission_ini.startup_time_player + 200) then
							activate_time = spawn_time - 120
						end

						--si multi ou ddserverAirAir: les IA en vol
						-- single ou ddserver : on gere les taxiing cata
						if  (SinglePlayer  or  SingleWithDServer) and not SingleWithDServerAiAir then
							if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe CC SinglePlayer "..tostring(waypoints[1]["type"])) end


							-- = = = SixPack = = = = - = - = - = -- = - = - = - = - = - = - = - = - = - = -- = - =

							--construit une table que l'on triera plus tard pour decider qui a le droit d etre sur le sixpack et ne pas gener les autres
							if group['route']['points'][1]["ETA"] <  (mission_ini.startup_time_player + 200) and waypoints[1]["action"] ~= "Turning Point" and not SpawnAir and not SpawnCata then
								-- and flight[f].type ~= "E-2C" and flight[f].type ~= "S-3B Tanker"

								if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe -- == SixPack == -- ") end

								if not timingDeckCata[side] then timingDeckCata[side] = {} end
								if not timingDeckCata[side][flight[f].base] then timingDeckCata[side][flight[f].base] = {} end

								-- TODO il faudrait prendre en compte le nombre d'avion à lancer, mais bordel à faire
								-- local timeToLauch = flight[f].number * mission_ini.CV_TimeBtwPlane
								-- placeTiming = math.ceil(spawn_time / 300) *300

								-- local timeToLauch = math.ceil(4 * mission_ini.CV_TimeBtwPlane)
								local timeToLauch = math.ceil(4 * 75)
								local placeTiming = math.ceil(spawn_time / timeToLauch) * timeToLauch

								local counter = 0
								repeat
									counter = counter + 1
									placeTiming = placeTiming - timeToLauch
								until not timingDeckCata[side][flight[f].base][placeTiming]  or counter == 20	or placeTiming < 0

								if counter == 20 or placeTiming < 0 then
									local BugFrom =  " timingDeckCata "..debug.getinfo(1).currentline
									SpawnOn( "air", waypoints, group, Pn, spawn_time + 30, BugFrom, flight, f, role)
								else
									timingDeckCata[side][flight[f].base][placeTiming] = group.name
									spawn_time = placeTiming
									activate_time = 5
									group.start_time = 5
									NbPlanetDeck = NbPlanetDeck + flight[f].number

									local tempSixPack = {}
									if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe BBB2 AddtimingDeckCata "..placeTiming.." NbPlanetDeck: "..NbPlanetDeck) end
									--construit une table que l'on triera plus tard pour decider qui a le droit d etre sur le sixpack et ne pas gener les autres
									tempSixPack = {
										time = placeTiming ,
										groupName = group.name,
										number = flight[f].number,
										LimitedParkNb = db_airbases[flight[f].base].LimitedParkNb,
										type = flight[f].type,
										}

									FlagInsertSixpack = true
									if not testSixPack[flight[f].base] then testSixPack[flight[f].base] = {} end
									table.insert(testSixPack[flight[f].base],  tempSixPack)

								end
							end


							if camp.player  and camp.player.side == side and camp.player.pack_n == p and camp.player.airbase == flight[f].base and flight[f].task ~= "AWACS" and flight[f].task ~= "Refueling" then					--for flights in player's package and package does not cover a station and flight[f].task ~= "CAP"
								if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe DD camp.player.pack_n") end


								--les Planes qui genent le taxiing spawn selon conf_mod
								if not SpawnDeck then
									local BugFrom =  ""..debug.getinfo(1).currentline
									SpawnOn(Data_configuration.SC_SpawnOn[flight[f].type], waypoints, group, Pn, spawn_time, BugFrom, flight, f, role)
								end

								-- les helico sur le FARP du joueur spawn en l'air
								--TODO mettre ça ailleur
								if PlayerFirstParking then
									if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe EE PlayerFirstParking") end
									local BugFrom =  ""..debug.getinfo(1).currentline
									SpawnOn( "air", waypoints, group, Pn, spawn_time, BugFrom, flight, f, role)
								end

							elseif group['route']['points'][1]["ETA"] <= mission_ini.startup_time_player + 200  and db_airbases[flight[f].base].LimitedParkNb then		--+ 600					-- Gère le spawn des groupes au début de mission																	
								if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe FFa ETA mission_ini.startup_time_player + 200 & LimitedParkNb NbPlanetDeck: "..NbPlanetDeck) end

								if not FlagInsertSixpack and flight[f].number + NbPlanetDeck >= db_airbases[flight[f].base].LimitedParkNb  then										-- on ne dépasse pas le nb max de spawn sur le CV 
									if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe FFb  NbPlanetDeck >= LimitedParkNb") end

									group['lateActivation'] = true																		--make group late activation  -- SOL decale 			 : lateActivation + a_activate_group
									-- group['uncontrolled'] = true		VOL decale			: lateActivation + a_activate_group																--Seulement sur CV, lateActivation and uncontrolled requis

									local BugFrom =  " NbPlanetDeck >= db_airbases[flight[f].base].LimitedParkNb "..debug.getinfo(1).currentline
									SpawnOn( "air", waypoints, group, Pn, spawn_time + 30, BugFrom, flight, f, role)

								elseif FlagInsertSixpack and NbPlanetDeck >= db_airbases[flight[f].base].LimitedParkNb  then										-- on ne dépasse pas le nb max de spawn sur le CV 
									if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe FFb  NbPlanetDeck >= LimitedParkNb") end

									group['lateActivation'] = true																		--make group late activation  -- SOL decale 			 : lateActivation + a_activate_group
									-- group['uncontrolled'] = true			VOL decale			: lateActivation + a_activate_group															--Seulement sur CV, lateActivation and uncontrolled requis

									local BugFrom =  " NbPlanetDeck >= db_airbases[flight[f].base].LimitedParkNb "..debug.getinfo(1).currentline
									SpawnOn( "air", waypoints, group, Pn, spawn_time + 30, BugFrom, flight, f, role)

									--si le vol postulait pour le sixpack, on le supprime de la table
									table.remove(testSixPack[flight[f].base])
									FlagInsertSixpack = false
									for forTiming, value in pairs(timingDeckCata[side][flight[f].base]) do
										if value == group.name then
											timingDeckCata[side][flight[f].base][value] = nil
										end
									end
								end
							else
								if not FlagInsertSixpack then																			--les planes qui ne sont pas ajouté dans les catégories précédente, spawn décalé
									if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe FFd  not FlagInsertSixpack "..tostring(waypoints[1]["type"])) end
									group['lateActivation'] = true																		--make group late activation  -- SOL decale 			 : lateActivation + a_activate_group
									group['uncontrolled'] = true																		--Seulement sur CV, lateActivation and uncontrolled requis
								end
							end

							--les Planes qui genent le taxiing spawn selon conf_mod
							if not SpawnDeck then
								local BugFrom =  " if not SpawnDeck "..debug.getinfo(1).currentline
								SpawnOn(Data_configuration.SC_SpawnOn[flight[f].type], waypoints, group, Pn, spawn_time, BugFrom, flight, f, role)
							end

							if LimitedParkTiming or db_airbases[flight[f].base].BaseAirStart then
								if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe LLLa LimitedParkTiming OR BaseAirStart ") end
								local BugFrom =  " LimitedParkTiming or BaseAirStart "..debug.getinfo(1).currentline

								SpawnOn( "air", waypoints, group, Pn, spawn_time + 30, BugFrom, flight, f, role)
								if FlagInsertSixpack then																			--si le vol postulait pour le sixpack, on le supprime de la table
									table.remove(testSixPack[flight[f].base])
									FlagInsertSixpack = false
									for forTiming, value in pairs(timingDeckCata[side][flight[f].base]) do
										if value == group.name then
											timingDeckCata[side][flight[f].base][value] = nil
										end
									end
								end
							end

							--au final, Start+Activate si le flight ne spawn pas en vol
							if waypoints[1]["action"] ~= "Turning Point" then
								activate_group_time_after(group, activate_time, debug.getinfo(1).currentline )	-- = - = - = - = -- = - = - = - = - = - = - = - = - = - = --															
								Start_set_ai_task(group, spawn_time, debug.getinfo(1).currentline)			-- = - = - = - = -- = - = - = - = - = - = - = - = - = - = --
							end

						elseif   (Multi.NbGroup >= 1 and not camp.MultiPlayer.pack_n[p]) or SingleWithDServerAiAir  then	--en multiplayer: aucun décalage sur le pont, puisque tous les IA commencent en vol								
							if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe GG Multi.NbGroup >= 1") end


							if not FARP_MorePlace then
								--les Planes qui genent le taxiing spawn selon conf_mod
								if not SpawnDeck or baseIsFARP then
									local BugFrom =  " not SpawnDeck "..debug.getinfo(1).currentline
									SpawnOn(Data_configuration.SC_SpawnOn[flight[f].type], waypoints, group, Pn, spawn_time + 30, BugFrom, flight, f, role)
									if FlagInsertSixpack then																			--si le vol postulait pour le sixpack, on le supprime de la table
										table.remove(testSixPack[flight[f].base])
										FlagInsertSixpack = false
										for forTiming, value in pairs(timingDeckCata[side][flight[f].base]) do
											if value == group.name then
												timingDeckCata[side][flight[f].base][value] = nil
											end
										end
									end
								end

								--au final, Start+Activate si le flight ne spawn pas en vol
								if waypoints[1]["action"] ~= "Turning Point" then
									group['lateActivation'] = true										--make group late activation 
									group['uncontrolled'] = true										--Seulement sur CV, lateActivation and uncontrolled requis
									activate_group_time_after(group, activate_time, debug.getinfo(1).currentline )	-- = - = - = - = -- = - = - = - = - = - = - = - = - = - = --															
									Start_set_ai_task(group, spawn_time, debug.getinfo(1).currentline)			-- = - = - = - = -- = - = - = - = - = - = - = - = - = - = --
								end
							end
						end


						--permet de faire apparaitre sur CV des planes qui decolleront plus tard, mais qui ont de la place pour apparaitre sur le pont des le début de mission
						--cela habille et occupe le  pont
						-- la decision sera prise en bas, en parsant le tableau testDeckPlace
						if group['route']['points'][1]["type"] ~= "Turning Point" and not FlagInsertSixpack and not SingleWithDServerAiAir then
							if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe GGa  ~= Turning Point and not FlagInsertSixpack") end

							tempDeckPlace = {
								time = group['route']['points'][1]["ETA"] ,
								groupName = group.name,
								number = flight[f].number,
								LimitedParkNb = db_airbases[flight[f].base].LimitedParkNb,
								}

							-- FlagInsertSixpack = true
							if not testDeckPlace[flight[f].base] then testDeckPlace[flight[f].base] = {} end
							table.insert(testDeckPlace[flight[f].base],  tempDeckPlace)
						end

					------------------	
					--SUR PISTE DUR---
					------------------	
					elseif (flight[f].task ~= "Intercept" and flight[f].task ~= "SAR" and not flight[f]["parkAlertSAR"]) then
						if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe II SUR PISTE DUR") end

						if LimitedParkTiming or db_airbases[flight[f].base].BaseAirStart then
							group['lateActivation'] = true
							group['uncontrolled'] = false
							if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe LLLb LimitedParkTiming OR BaseAirStart ") end
							local BugFrom =  " LimitedParkTiming or BaseAirStart "..debug.getinfo(1).currentline
							SpawnOn( "air", waypoints, group, Pn, spawn_time + 30, BugFrom, flight, f, role)

						elseif group.route.points[1].action ~= "Turning Point" then

							group['lateActivation'] = false
							group['uncontrolled'] = true
							group['start_time'] = spawn_time - 15		--evite le BUG actuel de la Polka sur parking

							Start_set_ai_task(group, spawn_time, debug.getinfo(1).currentline)			-- = - = - = - = -- = - = - = - = - = - = - = - = - = - = --
						end
					end

				end

				----- provisions for CSAR -----

				if (flight[f].task == "CSAR" )  then

					-- ParkSarAirBase
					if ParkSarAirBase[flight[f].base] then

						local pkFound = false
						local nLoop = 1
						local nPk = 0
						repeat
							nPk = math.random(1, #ParkSarAirBase[flight[f].base])

							if not ParkSarAirBase[flight[f].base][nPk].occupied or ParkSarAirBase[flight[f].base][nPk].occupied == false then
								ParkSarAirBase[flight[f].base][nPk].occupied = true
								pkFound = true
							end
							nLoop = nLoop + 1
						until nLoop > 200 or pkFound

						if pkFound then

							waypoints[1].action = "From Ground Area"
							waypoints[1].type = "TakeOffGround"

							group.units[1].x = ParkSarAirBase[flight[f].base][nPk].x
							group.units[1].y = ParkSarAirBase[flight[f].base][nPk].y

							group.x = ParkSarAirBase[flight[f].base][nPk].x
							group.y = ParkSarAirBase[flight[f].base][nPk].y

							waypoints[1].x = ParkSarAirBase[flight[f].base][nPk].x
							waypoints[1].y = ParkSarAirBase[flight[f].base][nPk].y

							if waypoints[1].linkUnit then
								waypoints[1].linkUnit = nil
							end

							-- if group.units[1].parking then
							-- 	group.units[1].parking = nil
							-- end

							-- if group.units[1].parking_id then
							-- 	group.units[1].parking_id = nil
							-- end
						end
					end
				end

				----- provisions for SAR -----

				--Truc débile pour obliger le premier SAR sur CV à etre un PEDRO
				local conditionUno = true
				if flight[f].task == "SAR" and baseIsCarrier then
					conditionUno = false
					if pedroOK[flight[f].base]  then
						conditionUno = true
					end
				end

				if (flight[f].task == "SAR" and conditionUno)  then			--or flight[f].task == "CSAR" 		
					camp.SAR.Flag = camp.SAR.Flag + 1								--go to next trigger flag number					

					-- ParkSarAirBase
					if ParkSarAirBase[flight[f].base] then

						local pkFound = false
						local nPk = 0

						--premier passage, on se positionne sur les places reservées, si elles existent
						for parkN, park in pairs(ParkSarAirBase[flight[f].base]) do
							if park.reservedAR and not park.occupied then
								park.occupied = true
								nPk = parkN
								pkFound = true
								break
							end
						end

						if not pkFound  then
							local nLoop = 1
							repeat
							nPk = math.random(1, #ParkSarAirBase[flight[f].base])

								if not ParkSarAirBase[flight[f].base][nPk].occupied or ParkSarAirBase[flight[f].base][nPk].occupied == false then
									ParkSarAirBase[flight[f].base][nPk].occupied = true
									pkFound = true
								end
								nLoop = nLoop + 1
							until nLoop > 200 or pkFound
						end

						if pkFound then

							waypoints[1].action = "From Ground Area"
							waypoints[1].type = "TakeOffGround"

							group.units[1].x = ParkSarAirBase[flight[f].base][nPk].x
							group.units[1].y = ParkSarAirBase[flight[f].base][nPk].y

							group.x = ParkSarAirBase[flight[f].base][nPk].x
							group.y = ParkSarAirBase[flight[f].base][nPk].y

							waypoints[1].x = ParkSarAirBase[flight[f].base][nPk].x
							waypoints[1].y = ParkSarAirBase[flight[f].base][nPk].y

							if waypoints[1].linkUnit then
								waypoints[1].linkUnit = nil
							end

							if group.units[1].parking then
								group.units[1].parking = nil
							end

							if group.units[1].parking_id then
								group.units[1].parking_id = nil
							end
						end
					end

					--ajuste l'altitude des helico en zone montagneuse, ils ont beaucoup de mal en alti radar
					for n = 1, #waypoints do
						if waypoints[n].type == "Land" then
							waypoints[n].action = "LandingReFuAr"
							waypoints[n].type = "LandingReFuAr"
						end
					end

					if ( flight[f].client ~= true and flight[f].player ~= true)  then	--or LimitedParkTiming or  ParkSarAirBase[flight[f].base]						-- M11 PVP ne copie pas de trigger retardé START pour les clients/joueurs	

						if polkaOff then

							group['lateActivation'] = false
							group['uncontrolled'] = false
							activate_group_withFlag(group, camp.SAR.Flag, debug.getinfo(1).currentline )	-- = - = - = - = -- = - = - = - = - = - = - = - = - = - = --															

						else

							group['uncontrolled'] = true
							group['lateActivation'] = false

							--TODO reassigner la position landing PilotEjected
							--TODO pourquoi pas de soldier rouge?

							--triggered action to start uncontrolled group
							group['tasks'] = {
								[1] = {
									["number"] = 1,
									["name"] = group.name,
									["id"] = "WrappedAction",
									["auto"] = false,
									["enabled"] = true,
									["params"] = {
										["action"] = {
											["id"] = "Start",
											["params"] = {},
										},
									},
								},
							}

							--mission trigger to initiate triggered action
							-- local trig_n = Missionfunc + #mission.trig.funcStartup + 1										--next available trigger number
							trig_n =  #mission.trig.actions + 1
							Missionfunc = Missionfunc + 1 																	--M11.o
							mission.trig.func[trig_n] = "if mission.trig.conditions[" .. trig_n .. "]() then mission.trig.actions[" .. trig_n .. "]() end"
							mission.trig.flag[trig_n] = true
							mission.trig.conditions[trig_n] = "return(c_flag_is_true(" .. camp.SAR.Flag .. ") )"
							mission.trig.actions[trig_n] = "a_set_ai_task(" .. group.groupId .. ", 1); mission.trig.func[" .. trig_n .. "]=nil;"
							mission.trigrules[trig_n] = {
								['rules'] = {
									[1] = {
										["flag"] = camp.SAR.Flag,
										["predicate"] = "c_flag_is_true",
										["zone"] = "",
									},
								},
								['eventlist'] = '',
								['comment'] = 'Trigger ' .. trig_n,
								['predicate'] = 'triggerOnce',
								['actions'] = {
									[1] = {
										["predicate"] = "a_set_ai_task",
										["set_ai_task"] = {
											[1] = group.groupId,
											[2] = 1,
										}
									},
								},
							}
						end

						--if the group is on a carrier, it gets late activation instead of uncontrolled. An activate trigger is needed instead of AI task trigger.
						-- Les SAR sur CV et parking limité spawn en vol

						if (baseIsCarrier or LimitedParkTiming or db_airbases[flight[f].base].BaseAirStart) and not FARP_MorePlace  then

							local BugFrom =  " SAR sur CV et parking limité spawn en vol "..debug.getinfo(1).currentline
							SpawnOn( "air", waypoints, group, Pn, 0, BugFrom, flight, f, role)

							group['lateActivation'] = true											--make group late activation "en vol"
							group['uncontrolled'] = false
							group['tasks'] = {}

							mission.trig.actions[trig_n] = "a_activate_group(" .. group.groupId .. "); mission.trig.func[" .. trig_n .. "]=nil;"
							mission.trigrules[trig_n]['actions'][1] = {
								["group"] = group.groupId,
								["predicate"] = "a_activate_group",
							}

							if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe activate 03") end
						end
					end

					local t = {
						name = group.name,
						number = #group.units,
						range = flight[f].target.radius,
						x = group.x,
						y = group.y,
						flag = camp.SAR.Flag,
						tot_from = flight[f].tot_from,
						tot_to = flight[f].tot_to,
						airdromeId = flight[f].airdromeId,
						airdromeElevation = db_airbases[flight[f].base].elevation,
						airdromeName = flight[f].base,
						time = -900,
						vCruise = flight[f].loadout.vCruise,
						vAttack = flight[f].loadout.vAttack,
						hCruise = flight[f].loadout.hCruise,
						hAttack = flight[f].loadout.hAttack,
						hHover = IsHelicopter[flight[f].type].hHover,
					}

					if camp.SAR.alertSAR[side].base[flight[f].base] == nil then
						camp.SAR.alertSAR[side].base[flight[f].base] = {
							ready = {},
						}
					end

					if flight[f].player or flight[f].client then										-- M11 multiplayer, les joueurs sont ajouté dans la base ready pour ne pas attendre 
						table.insert(camp.SAR.alertSAR[side].base[flight[f].base].ready, t)
					else
						table.insert(camp.SAR.alertSAR[side].base[flight[f].base].ready, t)
					end

				end
				----- provisions for interceptors/GCI/AWACS -----
				if flight[f].task == "Intercept" then   --and not flight[f].player 				--and flight[f].client ~= true					
					GCI.Flag = GCI.Flag + 1															--go to next trigger flag number					
					if flight[f].client ~= true or LimitedParkTiming then								-- M11 PVP ne copie pas de trigger retardé START pour les clients/joueurs	

						if polkaOff then
							group['lateActivation'] = false
							group['uncontrolled'] = false
							activate_group_withFlag(group, GCI.Flag, debug.getinfo(1).currentline )	-- = - = - = - = -- = - = - = - = - = - = - = - = - = - = --															

						else
							group['uncontrolled'] = true											--make interceptor groups uncontrolled at mission start
							group['lateActivation'] = false

							--triggered action to start uncontrolled group
							group['tasks'] = {
								[1] = {
									["number"] = 1,
									["name"] = group.name,
									["id"] = "WrappedAction",
									["auto"] = false,
									["enabled"] = true,
									["params"] = {
										["action"] = {
											["id"] = "Start",
											["params"] = {},
										},
									},
								},
							}

							--mission trigger to initiate triggered action
							-- local trig_n = Missionfunc + #mission.trig.funcStartup + 1										--next available trigger number
							trig_n =  #mission.trig.actions + 1
							Missionfunc = Missionfunc + 1 																	--M11.o
							mission.trig.func[trig_n] = "if mission.trig.conditions[" .. trig_n .. "]() then mission.trig.actions[" .. trig_n .. "]() end"
							mission.trig.flag[trig_n] = true
							mission.trig.conditions[trig_n] = "return(c_flag_is_true(" .. GCI.Flag .. ") )"
							mission.trig.actions[trig_n] = "a_set_ai_task(" .. group.groupId .. ", 1); mission.trig.func[" .. trig_n .. "]=nil;"
							mission.trigrules[trig_n] = {
								['rules'] = {
									[1] = {
										["flag"] = GCI.Flag,
										["predicate"] = "c_flag_is_true",
										["zone"] = "",
									},
								},
								['eventlist'] = '',
								['comment'] = 'Trigger ' .. trig_n,
								['predicate'] = 'triggerOnce',
								['actions'] = {
									[1] = {
										["predicate"] = "a_set_ai_task",
										["set_ai_task"] = {
											[1] = group.groupId,
											[2] = 1,
										}
									},
								},
							}
						end

						--if the group is on a carrier, it gets late activation instead of uncontrolled. An activate trigger is needed instead of AI task trigger.
						-- Les inter sur CV et parking limité spawn en vol
						if baseIsCarrier or LimitedParkTiming or db_airbases[flight[f].base].BaseAirStart then

							local BugFrom =  " IA intercept "..debug.getinfo(1).currentline
							SpawnOn( "air", waypoints, group, Pn, 0, BugFrom, flight, f, role)

							group['lateActivation'] = true											--make group late activation "en vol"
							group['uncontrolled'] = false
							group['tasks'] = {}

							mission.trig.actions[trig_n] = "a_activate_group(" .. group.groupId .. "); mission.trig.func[" .. trig_n .. "]=nil;"
							mission.trigrules[trig_n]['actions'][1] = {
								["group"] = group.groupId,
								["predicate"] = "a_activate_group",
							}

							if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe activate 03") end
						end
					end



					--build Interceptor table
					local t = {
						name = group.name,
						number = #group.units,
						range = flight[f].target.radius,
						x = group.x,
						y = group.y,
						flag = GCI.Flag,
						tot_from = flight[f].tot_from,
						tot_to = flight[f].tot_to,
						airdromeId = flight[f].airdromeId,
						time = -900
					}

					-- Initialize base tables if not already set
					if GCI.Interceptor[side].base[flight[f].base] == nil then
						GCI.Interceptor[side].base[flight[f].base] = {
							ready30 = {},
							ready15 = {},
							ready15_n = 0,
							ready = {},
							ready_n = 0,
							assign_index = 1  -- New variable to track insertion index
						}
					end

					-- Assign the plane to a table based on the assign_index
					local base = GCI.Interceptor[side].base[flight[f].base]

					if flight[f].player or flight[f].client then
						-- Always prioritize the `ready` table for player-controlled flights
						table.insert(base.ready, t)
						base.ready_n = base.ready_n + 1
					else
						-- Insert into the appropriate table based on the current assign_index
						if base.assign_index == 1 then
							table.insert(base.ready, t)
							base.ready_n = base.ready_n + 1
						elseif base.assign_index == 2 then
							table.insert(base.ready15, t)
							base.ready15_n = base.ready15_n + 1
						elseif base.assign_index == 3 then
							table.insert(base.ready30, t)
						end

						-- Update assign_index for the next plane, cycling back to 1 after 3
						base.assign_index = base.assign_index % 3 + 1
					end


					-- if GCI.Interceptor[side].base[flight[f].base] == nil then
					-- 	GCI.Interceptor[side].base[flight[f].base] = {
					-- 		ready30 = {},
					-- 		ready15 = {},
					-- 		ready15_n = 0,
					-- 		ready = {},
					-- 		ready_n = 0,
					-- 	}
					-- end

					-- if flight[f].player or flight[f].client then										

					-- 	table.insert(GCI.Interceptor[side].base[flight[f].base].ready, t)
					-- 	GCI.Interceptor[side].base[flight[f].base].ready_n = GCI.Interceptor[side].base[flight[f].base].ready_n + 1

					-- elseif #GCI.Interceptor[side].base[flight[f].base].ready == #GCI.Interceptor[side].base[flight[f].base].ready15 and #GCI.Interceptor[side].base[flight[f].base].ready == #GCI.Interceptor[side].base[flight[f].base].ready30 then

					-- 	table.insert(GCI.Interceptor[side].base[flight[f].base].ready, t)
					-- 	GCI.Interceptor[side].base[flight[f].base].ready_n = GCI.Interceptor[side].base[flight[f].base].ready_n + 1

					-- elseif #GCI.Interceptor[side].base[flight[f].base].ready15 == #GCI.Interceptor[side].base[flight[f].base].ready30 then

					-- 	table.insert(GCI.Interceptor[side].base[flight[f].base].ready15, t)
					-- 	GCI.Interceptor[side].base[flight[f].base].ready15_n = GCI.Interceptor[side].base[flight[f].base].ready15_n + 1

					-- else
					-- 	table.insert(GCI.Interceptor[side].base[flight[f].base].ready30, t)
					-- end

				elseif flight[f].task == "AWACS" then
					GCI.EWR[side][units[1].name] = true											--add AWACS to EWR table
				end

				-- -- si multijoueur, les Flight AI commencent en vol + M11.n
				-- if ((flight[f].type == 'F-14B' or flight[f].type == 'FA-18C_hornet') and Multi.NbGroup >= 1 and flight[f].player ~= true and flight[f].client ~= true 
				-- and string.find(flight[f].base,"CV") and flight[f].task ~= "Intercept") then
					-- if camp.startup then										--if player value defined in camp
						-- spawn_time = spawn_time + camp.startup						--if in-flight departure, the time initially added is deleted.
					-- else
						-- spawn_time = spawn_time + 300								--if in-flight departure, the time initially added is deleted.
					-- end
				-- end


				if flight[f].task == "SAR" and (pedroOK[flight[f].base] == nil  and db_airbases[flight[f].base].unitname) then

					--recherche le nombre de wpt du CV pour que le pedro le suive
					local PedroLinkCV = {}
					local breakFlag = false
					for coalition_name, coal in pairs(mission.coalition) do
						for country_n, country in pairs(coal.country) do
							if country.ship then
								for group_n, group in pairs(country.ship.group) do
									for w = 1, #group.units do
										if group.units[w].name and group.units[w].name == db_airbases[flight[f].base].unitname then

											PedroLinkCV = {
												Gname = group.name,
												Uname = group.units[w].name ,
												id_group = group.groupId,
												id_unit = group.units[w].unitId,
												x = group.units[w].x,
												y = group.units[w].y,
												startTime = group.start_time,
												nbWPT = #group.route.points,
												frequency = group.units[w].frequency/1000000,
											}
											breakFlag = true
											break
										end
									end
									if breakFlag then break end
								end
							end
							if breakFlag then break end
						end
						if breakFlag then break end
					end

					local action
					local type
					local alt
					local pos = {
						x=0,
						y=0,
					}
					local onCV = false
					if Data_configuration.SC_SpawnOn["Pedro"] == "deck"  and PlayerTask ~= "Intercept"  then
						-- action = "From Parking Area"
						-- type = "TakeOffParking"
						action = "From Parking Area Hot"
						type = "TakeOffParkingHot"
						alt = 0
						pos.x = PedroLinkCV.x
						pos.y = PedroLinkCV.y
						onCV = true
					elseif  Data_configuration.SC_SpawnOn["Pedro"] == "catapult" and PlayerTask ~= "Intercept" then
						action = "From Runway"
						type = "Turning TakeOff"
						alt = 0
						pos.x = PedroLinkCV.x
						pos.y = PedroLinkCV.y
						onCV = true
					else
						action = "Turning Point"
						type = "Turning Point"
						alt = 60
						pos.x = PedroLinkCV.x + 100
						pos.y = PedroLinkCV.y + 100
					end

					group.units[1].alt = alt
					group.units[1].speed = 41.66666666666
					group.units[1].x = pos.x
					group.units[1].y = pos.y
					group.units[1].name = "Unit_Pedro_"..PedroLinkCV.Uname.."_1"

					group.x = pos.x
					group.y = pos.y
					group.name = "Group_Pedro_"..PedroLinkCV.Uname.."_1"
					group.frequency = PedroLinkCV.frequency
					group.start_time = 0

					spawn_time = 0

					waypoints[1] =
					{
						["alt"] = alt,
						["action"] = action,
						["type"] = type,
						["alt_type"] = "BARO",

						["speed"] = 41.666666666667,
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
										["id"] = "Follow",
										["number"] = 1,
										["params"] =
										{
											["lastWptIndexFlagChangedManually"] = true,
											["groupId"] =   PedroLinkCV.id_group,
											["lastWptIndex"] = PedroLinkCV.nbWPT,
											["lastWptIndexFlag"] = true,
											["pos"] =
											{
												["y"] = 0,
												["x"] = -50,
												["z"] = -100,
											}, -- end of ["pos"]
										}, -- end of ["params"]
									}, -- end of [1]
								}, -- end of ["tasks"]
							}, -- end of ["params"]
						}, -- end of ["task"]
						["ETA"] = PedroLinkCV.startTime,
						ETA_locked = true,
						["y"] =  pos.y,
						["x"] =  pos.x,
						["formation_template"] = "",
						speed_locked = true,
					}

					if onCV then
						waypoints[1].linkUnit = PedroLinkCV.id_unit
						waypoints[1].helipadId = PedroLinkCV.id_unit
					end


					waypoints[2] =
					{
						["alt"] = 30,
						["action"] = "Turning Point",
						["alt_type"] = "BARO",
						["speed"] = 13.888888888889,
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
										["id"] = "Follow",
										["number"] = 1,
										["params"] =
										{
											["lastWptIndexFlagChangedManually"] = true,
											["groupId"] = PedroLinkCV.id_group,
											["lastWptIndex"] = PedroLinkCV.nbWPT,
											["lastWptIndexFlag"] = true,
											["pos"] =
											{
												["y"] = 0,
												["x"] = -50,
												["z"] = -100,
											}, -- end of ["pos"]
										}, -- end of ["params"]
									}, -- end of [1]
								}, -- end of ["tasks"]
							}, -- end of ["params"]
						}, -- end of ["task"]
						["type"] = "Turning Point",
						["ETA"] = PedroLinkCV.startTime + 60,
						ETA_locked = false,
						["y"] = pos.y + 300,
						["x"] = pos.x + 300,
						["formation_template"] = "",
						speed_locked = true,
					}

					pedroOK[flight[f].base] = true
				end




				-- si multijoueur, les Flight AI commencent en vol + M11.j
				if ( (Multi.NbGroup >= 1 or SingleWithDServerAiAir) and not flight[f].player and not flight[f].client  and string.find(flight[f].base,"CV") and flight[f].task ~= "Intercept") then
					if  waypoints[1]["type"] ~= "Turning Point" then 					-- si le vol a deja ete deplace pour un commencement en vol, on ne recommence pas le d�calage lat�ral
						local BugFrom =  " si multijoueur, les Flight AI commencent en vol "..debug.getinfo(1).currentline
						-- SpawnOn( "air", waypoints, group, Pn, spawn_time + 300, BugFrom, flight, f)	

						if not spawn_time or spawn_time == nil then
							_affiche(group, "group No spawn_time")

							os.execute 'pause'

						end

						SpawnOn( "air", waypoints, group, Pn, spawn_time, BugFrom, flight, f, role)
						modify_activate_group_time(group, spawn_time - 1, debug.getinfo(1).currentline)
					end


				elseif (flight[f].type == 'F-14B' or flight[f].type == 'FA-18C_hornet') and flight[f].client
					and string.find(flight[f].base,"CV") and flight[f].task ~= "Intercept" then

					if not waypoints[1]['linkUnit'] then waypoints[1]['linkUnit'] = waypoints[#waypoints]['linkUnit'] end
					if not waypoints[1]['helipadId'] then waypoints[1]['helipadId'] = waypoints[#waypoints]['helipadId'] end

				end

				-- if (db_airbases[flight[f].base].unitname or db_airbases[flight[f].base].helipadId) and group['route']['points'][1]["type"] ~= "Turning Point" then	-- and waypoints[1]["type"] ~= "Turning Point"
				if  group['route']['points'][1]["type"] ~= "Turning Point" then
					-- initie et place dans la table PlacePA les horaires "esperés" de catapultage
					if not PlacePA[side] then PlacePA[side] = {} end
					if not PlacePA[side][flight[f].base] then PlacePA[side][flight[f].base] = {} end

					local EPlayer = "."
					if	flight[f].player == true then EPlayer = " - Player" end
					if	flight[f].client == true then EPlayer = " - Client" end

					-- local etiquette = "Pack " .. p .. " - "..flight[f].number.." "..flight[f].type.. " - " .. flight[f].name .." - " .. flight[f].task .." ".. f.. EPlayer.." spawn_time: "..spawn_time
					local etiquette = "Pack " .. p .. " - "..flight[f].number.." "..ReplaceTypeName(flight[f].type).. " - " .. flight[f].name .." - " .. flight[f].task .." ".. f.. EPlayer

					local testST
					if (baseIsCarrier or db_airbases[flight[f].base].helipadId) then
						if spawn_time then
							testST =  spawn_time	- 120
						else
							testST =  departure_time
						end
					else
						testST =  departure_time
					end

					-- testST =  spawn_time	- 120						--	+ 200					-- ajoute 200s, cela correspond au roulage apres activatin (donc demarrage)													
					if not testST then testST = 0 end

					if (baseIsCarrier or db_airbases[flight[f].base].helipadId) then
						--todo fini l'ordre de décollage sur cata
						repeat
							testST = testST + 1
						until not PlacePA[side][flight[f].base][testST]
					end
					-- etiquette = etiquette .." HCV: "..testST

					PlacePA[side][flight[f].base][testST] = etiquette

				end


				if SinglePlayer and flight[f].player and not SingleWithDServer then									--if this is the player flight
				-- Eagle_01 Modification E02.a												--Make Flight Lead an AI
					-- if flight[f].type == 'I-16' or flight[f].type == 'A-4E-C' then			--Compensate for Unit without a radio so AI in flight will automatically attack targets
						-- units[1]["skill"] = "Excellent"
						-- units[2]["skill"] = "Client"
					-- else
						units[1]["skill"] = "Player"										--make first aircraft in flight the player aircraft
					-- end																		--make first aircraft in flight the player aircraft

				-- modification M11.l : Multiplayer	
				elseif (flight[f].client or flight[f].player) and not SingleWithDServer then
					local boucleNbPlaneClient
					if flight[f].NbPlaneClient > 4 then
						boucleNbPlaneClient = 4
					else
						boucleNbPlaneClient = flight[f].NbPlaneClient
					end
					for i=1, boucleNbPlaneClient do
						units[i]["skill"] = "Client"
					end

					waypoints[1].ETA = 0													-- Place l'heure d'apparition au lancement de mission, pour avoir plus de temps...^^	

					--ne change pas le type de decollage d'une position SAR (from ground)
					if waypoints[1]["type"] ~= "TakeOffGround" then
						waypoints[1].type = "TakeOffParking"
						waypoints[1].action = "From Parking Area"							--TODO pourquoi je l'avais enlevé déjà????
					end

					if db_airbases[flight[f].base].elevation then
						waypoints[1]["alt"] = 500 + db_airbases[flight[f].base].elevation
					end

					if baseIsCarrier or (flight[f].airdromeId and flight[f].airdromeId >= 100 and not flight[f]["parkAlertSAR"]) then									--airbase is a carrier
						waypoints[1].linkUnit = flight[f].airdromeId						--Debug_l
						waypoints[1].helipadId = flight[f].airdromeId
					else
						waypoints[1]["airdromeId"] = flight[f].airdromeId
					end

					DebugFLIGHT = DebugFLIGHT .."Passe Player ou Client TakeOffParking"

				elseif SingleWithDServer and flight[f].player then
					units[1]["skill"] = "Client"

				end

				if not units or not units[1] or not units[1].callsign then
					_affiche(units, "AtoFP units")

					_affiche(flight[f], "AtoFP flight[f]")
				end

				if type(units[1].callsign) == "number" then										--Russian style
					ATO[side][p][role][f].callsign = units[1].callsign							--store flight callsign in ATO
				else																			--NATO style
					ATO[side][p][role][f].callsign = units[1].callsign.name						--store flight callsign in ATO									
				end

				ATO[side][p][role][f].frequency = group.frequency								--store package frequency in ATO

				--M11.r ajoute une copie des avions multijoueur commançant en l'air // retab // recovery
				local groupRTB = {}

				if mission_ini.MP_PlaneRecovery and Multi.NbGroup >= 1 and (flight[f].client or flight[f].player) then

					groupRTB = Deepcopy(group)
					groupRTB.groupId = GenerateIDGroup()

					local direction = 0

					--pour ne pas avoir trop de retab, on fixe un chiffre par groupe, dans conf_mod
					if type(mission_ini.MP_PlaneRecovery) == "number" then
						for nb = 4 , mission_ini.MP_PlaneRecovery + 1, -1 do
							table.remove(groupRTB.units, nb)
						end
					end

					if not groupRTB.route.points[3] and not groupRTB.route.points[2] and groupRTB.route.points[1] then

						groupRTB.route.points[1]['action'] = 'Turning Point'
						groupRTB.route.points[1]['type'] = 'Turning Point'

						groupRTB.route.points[1].ETA_locked = true
						groupRTB.route.points[1].speed_locked = true

						if flight[f].loadout.vAttack then
							groupRTB.route.points[1]['speed'] = flight[f].loadout.vAttack
						elseif flight[f].loadout.vCruise then
							groupRTB.route.points[1]['speed'] = flight[f].loadout.vCruise
						else
							groupRTB.route.points[1]['speed'] = 250
						end


						groupRTB.route.points[2] = groupRTB.route.points[1]

						groupRTB.route.points[2]['airdromeId'] = nil
						groupRTB.route.points[2]['task'] = {
																['id'] = 'ComboTask',
																['params'] = {
																	['tasks'] = {
																	},
																},
															}
						groupRTB.route.points[2].ETA_locked = false

					elseif groupRTB.route.points[2] and  groupRTB.route.points[3] then
						-- groupRTB.route.points[1] = groupRTB.route.points[2]

						--cherche le milieu entre le wpt 2 et 3
						direction = GetHeading(groupRTB.route.points[2], groupRTB.route.points[3])
						local distance = GetDistance(groupRTB.route.points[2], groupRTB.route.points[3]) / 2
						local tempWPT = GetOffsetPoint(groupRTB.route.points[2], direction, distance)

						groupRTB.route.points[1] = groupRTB.route.points[3]

						groupRTB.route.points[1].speed_locked = true
						groupRTB.route.points[1].ETA_locked = true
						groupRTB.route.points[1]['ETA'] = 60
						-- groupRTB.route.points[1]['x'] = groupRTB.route.points[1]['x'] + 5000
						-- groupRTB.route.points[1]['y'] = groupRTB.route.points[1]['y'] + 5000

						groupRTB.route.points[1]['x'] = tempWPT['x']
						groupRTB.route.points[1]['y'] = tempWPT['y']

						groupRTB['x'] = tempWPT['x']
						groupRTB['y'] = tempWPT['y']

						-- direction = GetHeading(groupRTB.route.points[2], groupRTB.route.points[3])					
						distance = 1000
						tempWPT = GetOffsetPoint(groupRTB.route.points[1], direction, distance)

						groupRTB.route.points[2] = groupRTB.route.points[1]
						groupRTB.route.points[2].x = tempWPT['x']
						groupRTB.route.points[2].y = tempWPT['y']
						groupRTB.route.points[1]['ETA'] = 70
						groupRTB.route.points[2].speed_locked = false
						groupRTB.route.points[2].ETA_locked = true
					end

					groupRTB.name = "Recovery "..groupRTB.name

					--determine une nouvelle altitude pour ne pas prendre une montagne
					-- modification M11A.t  Multiplayer (t: AltitudeFloor)
					local nameTheatre =  string.lower(mission.theatre)
					local altFloor = -1

					if AltitudeFloorNew  then

						local function findCorrectAltitude(testN, Heading)
						local altFloorFunc = 99999
						local newPoint = groupRTB.route.points[1]

						if testN > 0 then
							newPoint = GetOffsetPoint(groupRTB.route.points[1], Heading, testN * 1000, false)
						end

						for level, polys in pairs(AltitudeFloorNew) do
							-- if is_helicopter then 
							-- 	print("AtoFp altiFloor passe BBBheli testN "..tostring(testN).." Heading "..tostring(Heading)) 
							-- 	print("AtoFp altiFloor passe BBBheli level "..tostring(level).." altFloorFunc "..altFloorFunc) 
							-- end

							for polyN, poly in pairs(polys) do

								local result = CheckPointInPolygon(newPoint, poly, false)

								-- if is_helicopter then print("AtoFp altiFloor passe CCC "..tostring(result).." altFloorFunc "..altFloorFunc.." <level? "..level) end

								if result and  level < altFloorFunc then
									altFloorFunc = level
									-- if is_helicopter then print("AtoFp altiFloor passe DDD altFloor "..tostring(altFloor)) end
								end
							end
						end
						if altFloorFunc == 99999 then altFloorFunc = -1 end
						return altFloorFunc, newPoint
					end

					if is_helicopter and IsHelicopter[flight[f].type].hHover then
						local testN = 0
						local newPoint
						repeat
							for Heading=0, 360, 90  do
								altFloor, newPoint  = findCorrectAltitude(testN, Heading)
								if altFloor < IsHelicopter[flight[f].type].hHover then
									break
								end
							end
							testN = testN + 1
						until altFloor == -1 or altFloor < IsHelicopter[flight[f].type].hHover or testN > 30

						if altFloor < IsHelicopter[flight[f].type].hHover then
							groupRTB.route.points[1].x = newPoint.x
							groupRTB.route.points[1].y = newPoint.y
						end


						-- if is_helicopter then print("AtoFp altiFloor passe EEEE2 altFloor "..tostring(altFloor).." "..tostring(flight[f].type)) end
						-- if is_helicopter then print("AtoFp altiFloor passe EEEE2 testN "..tostring(testN).." Heading "..tostring(Heading)) end

						if altFloor == -1 then altFloor = 600 end
					else
						altFloor = findCorrectAltitude(0)
					end

					elseif is_helicopter then
						if IsHelicopter[flight[f].type].hHover then
							altFloor = IsHelicopter[flight[f].type].hHover
						elseif flight[f].loadout.hCruise then
							altFloor = flight[f].loadout.hCruise
						end
						-- if is_helicopter then print("AtoFp altiFloor passe FFF altFloor "..tostring(altFloor)) end
					end

					if altFloor > -1 then

						if is_helicopter and  groupRTB.route.points[1]["alt"] < altFloor  then
							groupRTB.route.points[1]["alt"] =  altFloor + 20 + ((Pn-1) * 20) + (altRole * 5)

						elseif groupRTB.route.points[1]["alt"] < altFloor + 200 then
							groupRTB.route.points[1]["alt"] =  altFloor + 200 + ((Pn-1) * 200) + (altRole * 5)
						end


						-- if is_helicopter then 
						-- 	print("AtoFp altiFloor passe GGG altFloor "..tostring(altFloor)) 
						-- 	os.execute 'pause'
						-- end
					end

					for n = 1, #groupRTB.units do
						groupRTB.units[n].x =  groupRTB.route.points[1].x + (150 * n)
						groupRTB.units[n].y =  groupRTB.route.points[1].y + (150 * n)
						groupRTB.units[n].heading = direction
					end

					for i=1 , #groupRTB.units do
						local unitId_ = GenerateIDUnit("AtoFP ".."Recovery "..groupRTB.units[i].name)
						groupRTB.units[i].payload.fuel = groupRTB.units[i].payload.fuel * 0.80
						groupRTB.units[i].name = "Recovery "..groupRTB.units[i].name
						groupRTB.units[i].unitId = unitId_
						groupRTB.units[i].alt = groupRTB.route.points[1].alt

						if groupRTB.units[i].speed < 50 then
							groupRTB.units[i].speed	= groupRTB.route.points[1]['speed']
						end
					end



					for n, unit in pairs(groupRTB.units) do
						if unit["AddPropAircraft"] then
							if unit["AddPropAircraft"]["STN_L16"] then

								unit["AddPropAircraft"]["STN_L16"] =  Get_L16_Id()
								if not pack_L16_unitId[p] then pack_L16_unitId[p] = {} end
								table.insert(pack_L16_unitId[p], unit.unitId)

							elseif unit["AddPropAircraft"]["SADL_TN"] then

								unit["AddPropAircraft"]["SADL_TN"] =  Get_SADL_Id()
								if not pack_SADL_unitId[p] then pack_SADL_unitId[p] = {} end
								table.insert(pack_SADL_unitId[p], unit.unitId)

							elseif unit["AddPropAircraft"]["TN_IDM_LB"] then

								unit["AddPropAircraft"]["TN_IDM_LB"] =  Get_IDM_Id()
								if not pack_IDM_unitId[p] then pack_IDM_unitId[p] = {} end
								table.insert(pack_IDM_unitId[p], unit.unitId)
							end
						end
					end


				end	-- fin RECOVERY

				-- modification M33_e 	Custom Briefing (e: Divert/CV possible)
				-- place dans une table les bases proches des WPT
				local TabBaseByWPT = {}
				if flight[f].player or flight[f].client then
					for n = 1, #group.route.points   do
						for baseName, airbase in pairs(db_airbases) do
							if  (not airbase.inactive or airbase.inactive == false) and airbase["side"] == side and flight[f].base ~= baseName and not airbase.BaseAirStart and airbase.x then		--airbase.divert and					
								local distance = GetDistance(group.route.points[n], airbase )

								if flight[f].type == "AV8BNA" or baseIsCarrier then

										if distance < 300000 then
											local temp = {
												baseName = baseName,
												dist = distance
											}
											table.insert(TabBaseByWPT,temp )
										end


								elseif is_helicopter then

										if distance < 150000 then
											local temp = {
												baseName = baseName,
												dist = distance
											}
											table.insert(TabBaseByWPT,temp )
										end

								else
									if  not (airbase.helipadId or string.find(baseName, "LHA") or baseIsCarrier) then
										if distance < 300000 then
											local temp = {
												baseName = baseName,
												dist = distance
											}
											table.insert(TabBaseByWPT,temp )
										end
									end
								end
							end
						end
					end

					--TODO refaire ce bordel avec le nom du groupe comme key
					-- creer une table en evitant les doublons
					for wp, TabBase in pairs(TabBaseByWPT) do
						if flight[f].player then

							if not tabDivert["player"] then tabDivert["player"] = {} end
							if not tabDivert["player"]["pack"] then tabDivert["player"]["pack"] = {} end
							if not tabDivert["player"]["pack"][role] then tabDivert["player"]["pack"][role] = {} end
							if not tabDivert["player"]["pack"][role][f] then tabDivert["player"]["pack"][role][f] = {} end
							if not tabDivert["player"]["pack"][role][f]["base"] then tabDivert["player"]["pack"][role][f]["base"] = {} end

							if not tabDivert["player"]["pack"][role][f].base[TabBase.baseName] then
								tabDivert["player"]["pack"][role][f].base[TabBase.baseName] = TabBase.baseName
							end
						end
						-- elseif flight[f].client then

						-- 	if not tabDivert["client"] then tabDivert["client"] = {} end
						-- 	if not tabDivert["client"]["pack"] then tabDivert["client"]["pack"] = {} end
						-- 	if not tabDivert["client"]["pack"][role] then tabDivert["client"]["pack"][role] = {} end
						-- 	if not tabDivert["client"]["pack"][role][f] then tabDivert["client"]["pack"][role][f] = {} end
						-- 	if not tabDivert["client"]["pack"][role][f]["base"] then tabDivert["client"]["pack"][role][f]["base"] = {} end

						-- 	if not tabDivert["client"]["pack"][role][f].base[TabBase.baseName] then
						-- 		tabDivert["client"]["pack"][role][f].base[TabBase.baseName] = TabBase.baseName
						-- 	end
						-- end
						-- elseif flight[f].client then

						-- 	if not tabDivert["client"]												then tabDivert["client"] = {} end
						-- 	if not tabDivert["client"][flight[f].IdClient]							then tabDivert["client"][flight[f].IdClient] = {} end
						-- 	if not tabDivert["client"][flight[f].IdClient]["pack"]					then tabDivert["client"][flight[f].IdClient]["pack"] = {} end
						-- 	if not tabDivert["client"][flight[f].IdClient]["pack"][role]			then tabDivert["client"][flight[f].IdClient]["pack"][role] = {} end
						-- 	if not tabDivert["client"][flight[f].IdClient]["pack"][role][f]			then tabDivert["client"][flight[f].IdClient]["pack"][role][f] = {} end
						-- 	if not tabDivert["client"][flight[f].IdClient]["pack"][role][f]["base"]	then tabDivert["client"][flight[f].IdClient]["pack"][role][f]["base"] = {} end

						-- 	if not tabDivert["client"][flight[f].IdClient]["pack"][role][f]["base"][TabBase.baseName] then
						-- 		tabDivert["client"][flight[f].IdClient]["pack"][role][f]["base"][TabBase.baseName] = TabBase.baseName
						-- 	end
						-- end
					end
				end

				--ajoute un wpt supplementaire, num2 , proche du 1 (1500m), pour ajouter en toute securite Custom_Altitude
				if is_helicopter and not flight[f].client and not flight[f].player and  #group.route.points >= 3  then
					local wpt1 = group.route.points[1]
					local wpt2 = group.route.points[2]
					local Heading  = GetHeading(wpt1, wpt2)
					local newPoint = GetOffsetPoint(wpt1, Heading, 2000)
					local newEta = (1500 / wpt2.speed) + wpt1.ETA
					-- local grpname = "Pack " .. p .. " - " .. flight[f].name .. " - " .. flight[f].task .. " " .. (f + addNflight)

					--ajoute un waypoint intermediaire avec une orbit
					local neWpt = {
						['alt'] = wpt2.alt,
						['briefing_name'] = 'interWpt',
						['action'] = 'Turning Point',
						['alt_type'] = 'BARO',
						speed_locked = false,
						['ETA'] = tonumber(newEta),
						['y'] = newPoint.y,
						['formation_template'] = '',
						['name'] = 'Stacking',
						ETA_locked = true,
						['speed'] = wpt2.speed,
						['x'] = newPoint.x,
						['task'] = {
							['id'] = 'ComboTask',
							['params'] = {
								['tasks'] = {
									[1] = {
										["enabled"] = true,
										["auto"] = false,
										["id"] = "WrappedAction",
										["number"] =  1,
										["params"] =
										{
											["action"] =
											{
												["id"] = "Script",
												["params"] =
												{
													["command"] = "Custom_Altitude('" .. groupName .. "',  '  nil  ', '" .. 2 .. "')",
												},
											},
										},
									},
								},
							},
						},
						['type'] = 'Turning Point',

					}

					table.insert(group.route.points, 2, neWpt )

				end


				--ajoute ici les Custom_Altitude car les num de wpt ne change plus
				if is_helicopter and not flight[f].client and not flight[f].player  then
					for n = 2, #group.route.points   do
						-- if n == 2 then
						-- 	local grpname = "Pack " .. p .. " - " .. flight[f].name .. " - " .. flight[f].task .. " " .. (f + addNflight)
						-- 	local task_entry = {	
						-- 		["enabled"] = true,
						-- 		["auto"] = false,
						-- 		["id"] = "WrappedAction",
						-- 		["number"] = #group.route.points[n]["task"]["params"]["tasks"] + 1,
						-- 		["params"] = 
						-- 		{
						-- 			["action"] = 
						-- 			{
						-- 				["id"] = "Script",
						-- 				["params"] = 
						-- 				{
						-- 					["command"] = "Custom_Altitude('" .. grpname .. "',  '  nil  ', '" .. n .. "')",
						-- 				},
						-- 			},
						-- 		},
						-- 	}
						-- 	table.insert(group.route.points[n]["task"]["params"]["tasks"], task_entry)


						-- else
						if group.route.points[n].briefing_name == "Egress" then

							-- local grpname = "Pack " .. p .. " - " .. flight[f].name .. " - " .. flight[f].task .. " " .. (f + addNflight)
							local task_entry = {
								["enabled"] = true,
								["auto"] = false,
								["id"] = "WrappedAction",
								["number"] = #group.route.points[n]["task"]["params"]["tasks"] + 1,
								["params"] =
								{
									["action"] =
									{
										["id"] = "Script",
										["params"] =
										{
											["command"] = "Custom_Altitude('" .. groupName .. "',  '  nil  ', '" .. n .. "')",
										},
									},
								},
							}
							table.insert(group.route.points[n]["task"]["params"]["tasks"], task_entry)

						end
					end
				end
					-- 	local grpname = "Pack " .. p .. " - " .. flight[f].name .. " - " .. flight[f].task .. " " .. (f + addNflight)
					-- 	local task_entry = {	
					-- 		["enabled"] = true,
					-- 		["auto"] = false,
					-- 		["id"] = "WrappedAction",
					-- 		["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
					-- 		["params"] = 
					-- 		{
					-- 			["action"] = 
					-- 			{
					-- 				["id"] = "Script",
					-- 				["params"] = 
					-- 				{
					-- 					-- ["command"] = "Custom_Altitude('" .. grpname .. "')",
					-- 					["command"] = "Custom_Altitude('" .. grpname .. "',  '  nil  ', '" .. w .. "')",
					-- 				},
					-- 			},
					-- 		},
					-- 	}
					-- 	table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)


				------ add group to mission -----
				local foundCountry = false
				local addKeyCoalition
				for c = 1, #mission.coalition[side].country do
					-- if mission.coalition[side].country[c].name == flight[f].country then
					if string.lower(mission.coalition[side].country[c].name) == string.lower(flight[f].country) then
						addKeyCoalition = c
						foundCountry = true
						if mission.coalition[side].country[c].name ~= flight[f].country then
							print("******ATTENTION******, wrong letter case "..tostring(flight[f].country).." into oob_air")
							print()
							flight[f].country = mission.coalition[side].country[c].name
						end
						break
					end
				end

				-- CHCM_FP_01 Check and Help CampaignMaker 
				if not foundCountry then

					-- flight[f].country
					local dataIdCountry
					local dataIdKey
					for key, value in ipairs(DataCountry) do
						if string.lower(value.name) == string.lower(flight[f].country) then
							dataIdCountry = value.id
							dataIdKey = key
							if value.name ~= flight[f].country then
								print("******ATTENTION******, wrong letter case "..tostring(flight[f].country).." into oob_air")
								print()

							end
							break
						end
					end

					if dataIdCountry == nil or dataIdCountry == "" then
						print("******ATTENTION****** no found this contry "..tostring(flight[f].country).." into dataCoutrys")
						print()
						os.execute 'pause'
					end

					--cherche l idCoutry de plane demandé
					local requestCountry = {}
					for n, country_ in ipairs(DataCountry) do
						if string.lower(country_.name) == string.lower(flight[f].country) then
							requestCountry = country_
							flight[f].country = country_.name
							break
						end
					end

					addKeyCoalition = #mission.coalition[side].country + 1

					local countryInMission = false
					for n, missionIdCountry in ipairs(mission.coalitions[side]) do
						if missionIdCountry == requestCountry.id then
							countryInMission = true
							break
						end
					end

					if not countryInMission then
						-- Supprime l'enregistrement du camp opposé, si celui-ci existe
						if type(mission.coalitions[DCS_ENI_Side[side]]) == "table" then
							for n, missionIdCountry in ipairs(mission.coalitions[DCS_ENI_Side[side]]) do
								if missionIdCountry == requestCountry.id then
									table.remove(mission.coalitions[DCS_ENI_Side[side]], n)
									break
								end
							end
						end

						-- Supprime l'enregistrement du camp neutre, si celui-ci existe
						if type(mission.coalitions["neutrals"]) == "table" then
							for n, missionIdCountry in ipairs(mission.coalitions["neutrals"]) do
								if missionIdCountry == requestCountry.id then
									table.remove(mission.coalitions["neutrals"], n)
									break
								end
							end
						end

						-- Ajoute l'ID country dans le camp actuel
						if type(mission.coalitions[side]) == "table" then
							table.insert(mission.coalitions[side], dataIdCountry)
						end
					end


					mission.coalition[side].country[addKeyCoalition] = {
						["name"] = tostring(DataCountry[dataIdKey].name),
						["id"] = dataIdCountry,
					}
				end



				if not is_helicopter then
					if mission.coalition[side].country[addKeyCoalition].plane == nil then
						mission.coalition[side].country[addKeyCoalition].plane = {
							group = {}
						}
					end
					table.insert(mission.coalition[side].country[addKeyCoalition].plane.group, group)

					if flight[f].player == true then
						camp.player.group = mission.coalition[side].country[addKeyCoalition].plane.group[#mission.coalition[side].country[addKeyCoalition].plane.group]		--store a link to the player group in mission
					end
					-- modification M11B. : Multiplayer--briefing
					-- TODO revoir client
					-- if flight[f].client == true then
					-- 	camp.client[flight[f].IdClient].group = mission.coalition[side].country[addKeyCoalition].plane.group[#mission.coalition[side].country[addKeyCoalition].plane.group]		--store a link to the player group in mission
					-- end

					if groupRTB.groupId then
						table.insert(mission.coalition[side].country[addKeyCoalition].plane.group, groupRTB)
					end
				else

					if mission.coalition[side].country[addKeyCoalition].helicopter == nil then
						mission.coalition[side].country[addKeyCoalition].helicopter = {
							group = {}
						}
					end
					table.insert(mission.coalition[side].country[addKeyCoalition].helicopter.group, group)

					if flight[f].player == true then
						camp.player.group = mission.coalition[side].country[addKeyCoalition].helicopter.group[#mission.coalition[side].country[addKeyCoalition].helicopter.group]		--store a link to the player group in mission
					-- modification M11B. : Multiplayer--briefing	
					end
					---- TODO revoir client
					-- if flight[f].client == true then
					-- 	camp.client[flight[f].IdClient].group = mission.coalition[side].country[addKeyCoalition].helicopter.group[#mission.coalition[side].country[addKeyCoalition].helicopter.group]		--store a link to the player group in mission
					-- end
					if groupRTB.groupId then
						table.insert(mission.coalition[side].country[addKeyCoalition].helicopter.group, groupRTB)
					end
				end

				local debugTempFLIGHT = ""
				-- local idSol = "SolRIEN"
				local ETA = -1
				local NbEta = "ETA "

				if spawn_time ~= nil then
					-- ETA = spawn_time
					ETA = group.start_time
				end

				local info01 = ""
				local info02 = ""
				local info03 = ""
				local info04 = ""
				local info05 = ""
				local info06 = ""

				local a_activate = false
				local a_activate2 = 0
				local a_set_ai_task = false
				local c_time = false
				local c_flag = false
				local testtrigrule = {}
				local activateSecondes = 999999
				local nbactivate = 0
				for n , trigrule in pairs(mission.trigrules) do
					if type(trigrule) == "table" then
						if trigrule.actions and trigrule.actions[1] and trigrule.actions[1].group == group.groupId then
							if trigrule.actions[1]["predicate"] == "a_activate_group" then
								nbactivate = nbactivate + 1

								a_activate = true
								testtrigrule = trigrule
								if trigrule.rules[1].predicate == "c_time_after" then
									-- print("AtoFp passe rulesSeconds "..activateSecondes)
									activateSecondes = math.floor(trigrule.rules[1].seconds)
									c_time = true
								elseif trigrule.rules[1].predicate == "c_flag_is_true" then
									c_flag = true
								end
							end
						end
						if trigrule.actions and trigrule.actions[1] and trigrule.actions[1].set_ai_task and trigrule.actions[1].set_ai_task[1] == group.groupId then
							if trigrule.actions[1]["predicate"] == "a_set_ai_task" then
								a_set_ai_task = true
								testtrigrule = trigrule
								if trigrule.rules[1].predicate == "c_time_after" then
									-- print("AtoFp passe rulesSeconds "..activateSecondes)
									activateSecondes = math.floor(trigrule.rules[1].seconds)
									c_time = true
								elseif trigrule.rules[1].predicate == "c_flag_is_true" then
									c_flag = true
								end
							end
						end
					end
				end

				if nbactivate > 1 then
					info06 = info06.." |+|ATTENTION plusieurs ACTIVATE "
				end

				if group.tasks and group.tasks[1] and group.tasks[1].params.action.id == "Start" then
					if not group.uncontrolled then
						info01 = "ATTENTION MANQUE uncontrolled "..group.groupId
					end
					-- if waypoints[1].action == "Turning Point" then
					-- 	info01 = info01.." |+|ATTENTION Start en VOL "
					-- end
					if group.route.points[1].action == "Turning Point" then
						info01 = info01.." |+|ATTENTION Start en VOL "
					end


				end

				-- if spawn_time and waypoints[1].action == "Turning Point" and spawn_time > 10 then	
				if spawn_time and group.route.points[1].action == "Turning Point" and spawn_time > 10 then
					for n , trigrule in pairs(mission.trigrules) do
						if type(trigrule) == "table" then
							if trigrule.actions and trigrule.actions[1] and trigrule.actions[1].group == group.groupId then
								if trigrule.actions[1]["predicate"] == "a_activate_group" then
									a_activate2 = a_activate2 + 1
								end
							end
						end
					end
					if a_activate2 == 0 then
						info01 = info01.." |+|ATTENTION VOL sans a_activate_group "
					elseif a_activate2 > 1 then
						info01 = info01.." |+|ATTENTION VOL (many times) "..a_activate2.." a_activate_group "
						print("AtoFP "..group.name.." |+|ATTENTION VOL (many times) "..a_activate2.." a_activate_group ")
						os.execute 'pause'
					end
				end


				if group.uncontrolled then
					if group.tasks and group.tasks[1] and group.tasks[1].params.action.id == "Start" then
						if a_set_ai_task then
							if c_time then
								info02 = "SOL/VOL decale_A "..activateSecondes
							elseif c_flag then
								info02 = info02.." |VOL decale_B"
							else
								_affiche(testtrigrule, "testtrigrule")
							end
						else
							info02 = info02.." |ATTENTION MANQUE a_set_ai_task: aucun demarrage possible "..group.groupId
						end
					else
						info02 = info02.." |ATTENTION MANQUE Start "..group.groupId
						print("AtoFp info02"..info02)
						os.execute 'pause'
					end
				end


				if group.lateActivation then
					if a_activate then
						if c_time then
							if activateSecondes == math.floor(ETA)   then
								info03 = "SOL/VOL decale_A"
							else
								info03 = "ATTENTION SECONDES a_activate_group "..group.groupId .." |activateSecondes ~= "..activateSecondes .." |ETA: "..ETA
							end
						elseif c_flag then
							info03 = "VOL FLAG decale _B"
						else
							_affiche(testtrigrule, "testtrigrule")
						end
					else
						info03 = "ATTENTION MANQUE a_activate_group "..group.groupId
					end
				end

				-- if waypoints[1].linkUnit then				
				-- 	info04 = "linkUnit "..waypoints[1].linkUnit				
				-- end
				-- if waypoints[1].helipadId then				
				-- 	info04 = info04.." helipadId "..waypoints[1].helipadId				
				-- end	

				if group.route.points[1].linkUnit then
					info04 = "linkUnit "..group.route.points[1].linkUnit
				end
				if group.route.points[1].helipadId then
					info04 = info04.." helipadId "..group.route.points[1].helipadId
				end

				info05 = info05.."|" .. group.route.points[1]["action"].."|"

				if units[1]["parking_id"] then
					info05 = info05.."| parking_id: |"
				end

				for i = 1, #units do
					if units[i]["parking_id"] then
						info05 = info05.."|"..units[i]["parking_id"].."|"
					end
				end


				for i = 1, #group.route.points do
					--['briefing_name'] = 'IP'
					if group.route.points[i]["briefing_name"] and group.route.points[i]["briefing_name"] == "IP" then
						info06 = info06.." IP_ETA : "..group.route.points[i].ETA.." "
						break
					end
				end

				-- if waypoints[1].linkUnit then				
					-- info06 = info06.." linkUnit CV "..waypoints[1].linkUnit				
				-- end	


				-- if waypoints[#waypoints]["airdromeId"] then				
					-- info06 = info06.." airdromeId LANDING "..waypoints[#waypoints]["airdromeId"]				
				-- end	


				if group.frequency then
					info06 = info06.."frequency "..group.frequency
				else
					info06 = info06.."ATTENTION NO frequency "
				end

				if group.task then
					info06 = info06.."task "..group.task
				else
					info06 = info06.."ATTENTION NO task "
				end

				if flight[f].loadout.name then

					info06 = info06.." || "..flight[f].loadout.name
				end

				-- for i=1, #units do				
					-- info06 = info06.."||"..units[i].skill.."||"	
				-- end	

				-- for i=1, #waypoints do
					-- if waypoints[i]["briefing_name"] and waypoints[i]["briefing_name"] == "Join"  then				
						-- info06 = info06.." |"..waypoints[i]["briefing_name"]..": "..tostring(waypoints[i]["hCruiseREF"])..": "..waypoints[i]["alt"]				
					-- end
				-- end


				if units[1].skill == "Player" or units[1].skill == "Client" then
					InfoFlight = InfoFlight.."\n"..("= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = ")
					InfoFlight = InfoFlight.."\n"..("= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = ")
				end

				local groupInfo = ""
				if debugStart then
					groupInfo = info01
					.." "..info02
					.." "..info03
					-- .." "..info04
					.." "..info05

					-- .."  ".." // "..units[1].skill
					.." "..info06
					-- .." UAlt ".." // "..units[1].alt
					-- .." WPptAlt".." // "..tostring(group['route']['points'][1]["alt"])
					.."  ".."Type: "..tostring(group['route']['points'][1]["type"])
					-- .."  unCont: "..tostring(group.uncontrolled)
					.."  lateA: "..tostring(group.lateActivation)

					-- .."  ".." // "..group.frequency


					-- .." WAlt ".." // "..info01
					-- .." "..groupInfo
					.." ETA1: "..group.route.points[1]["ETA"]
				end

				InfoFlight = InfoFlight.."\n"
					..""..flight[f].id
					.." Pack: "..p.." Nb "
					.." "..flight[f].number
					.." "..flight[f].type
					.." "..group.name
					.." "..flight[f].base
					.." "..flight[f].target_name
					.." "..NbEta.. math.floor(ETA)
					.." "..group.frequency
					.." "..info06



				debugTempFLIGHT = InfoFlight.." "..groupInfo

				-- for nn = 1 , #units do
					-- debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("\n")						
					-- debugTxt_AtoFP = debugTxt_AtoFP.."\n"..(" / ".. units[nn].onboard_num )
					-- debugTxt_AtoFP = debugTxt_AtoFP.."\n"..(" / ".. units[nn].livery_id )
				-- end

				if units[1].skill == "Player" or units[1].skill == "Client" then
					InfoFlight = InfoFlight.."\n"..("= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = ")
					InfoFlight = InfoFlight.."\n"..("= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = ")
				end
				if units[1].skill == "Player" or units[1].skill == "Client" then
					debugTempFLIGHT = debugTempFLIGHT.."\n"..("= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = ")
					debugTempFLIGHT = debugTempFLIGHT.."\n"..("= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = ")
				end

				if Debug.AfficheFlight  then
					print(debugTempFLIGHT)
				end

				-- if waypoints[1]["ETA"] < 0 then
				if group and group.route and group.route.points[1]["ETA"] then
					if group.route.points[1]["ETA"] < 0 then
						--TODO regler les ETA negatif
						-- print("AtoFP ETA négatif: "..tostring(waypoints[1]["ETA"]))
						-- os.execute 'pause'


					end
				else

					_affiche(group.route.points, "group.route.point.route")
				end


				debugTempFLIGHT = debugTempFLIGHT.."\n"..("\n")

				DebugFLIGHT = DebugFLIGHT .. debugTempFLIGHT
				debugTxt_AtoFP = debugTxt_AtoFP .. debugTempFLIGHT

				if Multi.NbGroup >= 1 and not Debug.AfficheFlight then
					print(InfoFlight)
				end
			end
		end
	end
end

--ajoute les modules necessaire dans le fichier mission
if ListRequiredModules then
	if not mission.requiredModules then mission.requiredModules = {} end
	for nameN, module in pairs(ListRequiredModules) do
		if not mission.requiredModules[nameN] then mission.requiredModules[nameN] = nameN end
	end
end



--mettre dans le for du pack ATO les avions link16 capa

for _side, side in pairs(mission.coalition) do
	for countryN, country in pairs(side.country) do
		for category, groups in pairs(country) do
			if type(groups) == "table" and groups["group"]  then	--and groups[1].units
				for Ngroup, group in pairs(groups["group"]) do
					for Nunit, unit in pairs(group.units) do

						if Data_divers[unit.type] and Data_divers[unit.type].datalinks and Data_divers[unit.type].datalinks.isReceiver then
							local typeDataLink = Data_divers[unit.type].datalinks.type
							for pack_N, listId in pairs(pack_L16_unitId) do
								local listIdCopy = Deepcopy(listId)

								for n=1, #listId do
									if unit.unitId == listId[n] then
										for key, value in pairs(listIdCopy) do
											local data = {
												["missionUnitId"] = value,
											}

											--cas avion RECOVERY, place ici l unitId dans le premier members
											if unit.datalinks[typeDataLink].network.teamMembers[1].missionUnitId ~= unit.unitId then
												unit.datalinks[typeDataLink].network.teamMembers[1].missionUnitId = unit.unitId
											end

											if #unit.datalinks[typeDataLink].network.teamMembers < Data_divers[unit.type].datalinks.hasTeamMembers then
												table.insert(unit.datalinks[typeDataLink].network.teamMembers, data )
											elseif #unit.datalinks[typeDataLink].network.donors < Data_divers[unit.type].datalinks.hasDonors then

												--check si l'id du donor n'est pas déjà dans members
												local found = false
												for nMember, member in pairs(unit.datalinks[typeDataLink].network.teamMembers) do

													if member.missionUnitId == value then found = true break end
												end

												if not found then
													table.insert(unit.datalinks[typeDataLink].network.donors, data )
												end

											end
										end
									end
								end
							end

							for pack_N, listId in pairs(pack_SADL_unitId) do
								local listIdCopy = Deepcopy(listId)

								for n=1, #listId do
									if unit.unitId == listId[n] then
										--  n'ajoute que les avions du meme package
										for key, value in pairs(listIdCopy) do
											local data = {
												["missionUnitId"] = value,
											}

											--cas avion RECOVERY, place ici l unitId dans le premier members
											if unit.datalinks[typeDataLink].network.teamMembers[1].missionUnitId ~= unit.unitId then
												unit.datalinks[typeDataLink].network.teamMembers[1].missionUnitId = unit.unitId
											end

											if #unit.datalinks[typeDataLink].network.teamMembers < Data_divers[unit.type].datalinks.hasTeamMembers then
												table.insert(unit.datalinks[typeDataLink].network.teamMembers, data )

											elseif #unit.datalinks[typeDataLink].network.donors < Data_divers[unit.type].datalinks.hasDonors then

												--check si l'id du donor n'est pas déjà dans members
												local found = false
												for nMember, member in pairs(unit.datalinks[typeDataLink].network.teamMembers) do
													if member.missionUnitId == value then found = true break end
												end

												if not found then
													table.insert(unit.datalinks[typeDataLink].network.donors, data )
												end

											end
										end
									end

								end
							end

						end
					end
				end
			end
		end
	end
end


function AF_spawnOn(where, groupName)
	if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFp AF_spawnOn  "..groupName) end

		local action = 'From Runway'
		local actionType = 'TakeOff'

	if where == "catapult" then
		action = 'From Runway'
		actionType = 'TakeOff'
	end

	for _side,side in pairs(mission.coalition) do
		for _country,country in pairs(side.country) do
			if country.plane then
				for Ngroup,group in pairs(country.plane.group) do
					if group.name ==  groupName then
						group.route.points[1]['action'] = action
						group.route.points[1]['type'] = actionType
						group['route']['points'][1]["ETA"] = 0
						group['uncontrolled'] = false
						if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFp AF_spawnOn Find "..group.units[1].type.." "..group.name.." "..group.route.points[1]['type']) end
					end
				end
			elseif country.helicopter  then
				for Ngroup,group in pairs(country.helicopter.group) do
					if group.name ==  groupName then
						group.route.points[1]['action'] = action
						group.route.points[1]['type'] = actionType
						group['route']['points'][1]["ETA"] = 0
						group['uncontrolled'] = false
						if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFp AF_spawnOn Find "..group.units[1].type.." "..group.name.." "..group.route.points[1]['type']) end
					end
				end
			end
		end
	end
end

--nombre d'avion UNIQUEMENT sur le SIXPACK
local sommePlane = {}
for CV, SixPack in pairs(testSixPack) do

	if #SixPack > 0 then

		table.sort(SixPack, function(a,b) return a.time < b.time  end)
		if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.. _afficheTXT(SixPack, "SixPack") end

		local breakloop = false
		sommePlane[CV] = 0
		local n = 1
		repeat

			if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("n: "..n) end

			local sixpackWiner = SixPack[n]["groupName"]

			--affiche la note concernant le joueur:
				-- s'il est sur le Sixpack ET serveur dédié : commencer serveur sur pause
				-- s'il n'est pas sur sixpack ET serveur dédié: commencer serveur en resume


			sommePlane[CV] = 4													-- par defaut, le sixpack ne pourra etre utiliser à posteriorie, donc on estime que les 4 places sont occupé, cela evite les spawn derriere et le manque de place ensuite, sur tout le pont

			for _side,side in pairs(mission.coalition) do
				for _country,country in pairs(side.country) do
					if country.plane then
						for Ngroup,group in pairs(country.plane.group) do
							if group.name ==  sixpackWiner then
								if group.units[1].type == "S-3B Tanker" or group.units[1].type == "E-2C"  then						-- cet endroit est bloqué par DCS pour ces 2 avions
									AF_spawnOn("catapult", group.name)
									modify_activate_group_time(group, -1, debug.getinfo(1).currentline)								--supprime le triger activate
									modify_set_ai_task(group, -1, debug.getinfo(1).currentline)										--supprime le triger start
									group['tasks'] = {}
									break
								end
								group['route']['points'][1]["ETA"] = 0
								group['start_time'] = 0
								modify_activate_group_time(group, -1, debug.getinfo(1).currentline)								--supprime le triger activate
								if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFp SixPack Find "..group.name) end
								breakloop = true

							end
						end
					elseif country.helicopter  then
						for Ngroup,group in pairs(country.helicopter.group) do
							if group.name ==  sixpackWiner then
								group['route']['points'][1]["ETA"] = 0
								group['start_time'] = 0
								modify_activate_group_time(group, -1, debug.getinfo(1).currentline)								--supprime le triger activate
								if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFp SixPack Find "..group.name) end
								breakloop = true

							end
						end
					end
				end
			end

			if breakloop or n > #SixPack then
				if SixPack[n]["client"] and SingleWithDServer  then	-- and not SingleWithDServerAiAir
					print()
					print("********************ATTENTION******************")
					print()
					print("        You MUST set the server to PAUSE")
					print("          (to appear on the SIXPACK) ")
					print()
					print("********************ATTENTION******************")
					print()
					os.execute 'pause'


				elseif  SingleWithDServer then	-- and not SingleWithDServerAiAirthen	

					print()
					print("*****************************************ATTENTION***************************************************")
					print()
					print("				  You MUST set the server to RESUME ")
					print()
					print("(so that you don't appear on the Sixpack, you'd be annoying the AIs that will be driving before you) ")
					print()
					print("*****************************************ATTENTION***************************************************")
					print()
					os.execute 'pause'
				end
			end

			n = n +1
		until breakloop or n > #SixPack
	end
end

if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.. _afficheTXT(testDeckPlace, "testDeckPlace") end

-- nombre d'avion sur le pont total
-- limite le nombre d'avion sur le pont (permet de faire apparaitre les avions tardif, s'il y a de la place)
for CV, deck in pairs(testDeckPlace) do

	if #deck > 0 then

		table.sort(deck, function(a,b) return a.time < b.time  end)
		if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.. _afficheTXT(deck, "testDeckPlace deck") end

		if testSixPack[CV] and #testSixPack[CV] > 0 then

			--cherche une place dispo sur le deck pour les avions tardif
			local counter = 0
			local testSomme = 0
			for n = 1 , #deck do
				repeat
					counter = counter +1

					local DeckWiner = deck[n]["groupName"]

					if not deck[n]["LimitedParkNb"] then
						break
					else
						--enleve les 4 places du Sixpack
						--et aussi le nombre de place du pack client/joueur
						LimitedDeckNb  = deck[n]["LimitedParkNb"] - 4 - NbPlanetDeck
					end

					if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFp DeckWiner "..DeckWiner) end
					if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFp DeckWiner "..tostring(deck[n]["number"]) .." |LimitedDeckNb: "..tostring(LimitedDeckNb)) end

					testSomme = testSomme + deck[n]["number"]
					if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFp testSomme "..testSomme) end
					if testSomme <= LimitedDeckNb and not deck[n]["OnDeck"] then
						for _side,side in pairs(mission.coalition) do
							for _country,country in pairs(side.country) do
								if country.plane then
									for Ngroup,group in pairs(country.plane.group) do
										if group.name ==  DeckWiner then
											group['uncontrolled'] = true
											group['lateActivation'] = true
											modify_activate_group_time(group, 2, debug.getinfo(1).currentline)
											sommePlane[CV] = sommePlane[CV] + tonumber(deck[n]["number"])
											deck[n]["OnDeck"] = true
											if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFp DeckWiner Find "..group.name.." +number: "..deck[n]["number"]) end
										end
									end
								elseif country.helicopter  then
									for Ngroup,group in pairs(country.helicopter.group) do
										if group.name ==  DeckWiner then
											group['uncontrolled'] = true
											group['lateActivation'] = true
											modify_activate_group_time(group, 2, debug.getinfo(1).currentline)
											sommePlane[CV] = sommePlane[CV] + tonumber(deck[n]["number"])
											deck[n]["OnDeck"] = true
											if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFp DeckWiner Find "..group.name.." +number: "..deck[n]["number"]) end
										end
									end
								end
							end
						end
					end

				until sommePlane[CV] >= LimitedDeckNb or counter >= 2
			end
		end
	end
end

if debugStart then
	-- affiche  le timing des avions sur le pont/catapulte pour prévenir le/les joueurs que des IA seront dessus
	local tabNam = {}
	debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP startup_time_player: " ..FormatTime(mission_ini.startup_time_player, "hh:mm"))
	debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP NowTime: " ..FormatTime(camp.time, "hh:mm"))

	print("\n")
	if PlacePA and camp.player then
		for side , pPA in pairs(PlacePA) do
			if camp.player.side == side then
				for base , Tmn in pairs(pPA) do
					debugTxt_AtoFP = debugTxt_AtoFP.."\n"..(tostring(base).." Takeoff time on the platform at ...")
					for s, name in PairsByKeys(Tmn) do

						if tabNam[name] ~= true then
							local catTime = camp.time + s
							debugTxt_AtoFP = debugTxt_AtoFP.."\n"..(" "..FormatTime(catTime, "hh:mm").. " - "..tostring(name).."\n")
							tabNam[name] = true
						end
					end
				end
			end
		end
	end
end


--ajoute les JTAC dans les triggers pour le fichier CTLD
-- modification M60_a		add CTLD
if mission_ini.load_CTLD then
	TableJTAC = {}
	for _side,side in pairs(mission.coalition) do
		for _country,country in pairs(side.country) do
			if country.vehicle then
				for Ngroup,group in pairs(country.vehicle.group) do
					if string.find(group.name, "JTAC") then

						TableJTAC[#TableJTAC+1] = {
							Predicate = "a_do_script",
							NameJTAC = group.name,
						}

					end
				end
			end
		end
	end

	if #TableJTAC >= 1  then
		AddFileTriggerTempo(nil, 10, "triggerOnce", TableJTAC)	-- modification M60 CTLD
	end
end
--ajoute les name helico dans la table CTLD transport
-- modification M60_a		add CTLD
-- ******************** Transports names **********************
-- Use any of the predefined names or set your own ones
-- ctld.transportPilotNames = {
    -- "helicargo1",
    -- "helicargo2",
    -- "helicargo3",

TableTransportPilotNames = {}
for _side,side in pairs(mission.coalition) do
	for _country, country in pairs(side.country) do
		if country.helicopter then
			for Ngroup, group in pairs(country.helicopter.group) do

				TableTransportPilotNames[#TableTransportPilotNames+1] = group.name

			end
		end
	end
end

if #TableTransportPilotNames >= 1  then
	camp["TableTransportPilotNames"] = TableTransportPilotNames	-- modification M60 CTLD
end

-- TODO revoir client
-- -- modification M11B. : Multiplayer--briefing	
-- if camp.client and PlayerFlight then
-- 	for i = 1, Multi.NbGroup do
-- 		camp.client[i].pack = Deepcopy(ATO[camp.client[i].side][camp.client[i].pack_n])
-- 	end
-- end


----- make a copy of player package for easy reference in briefing -----
local breakloop = false
if camp.player then
	if not camp.player.pack then camp.player.pack = {} end
	if not camp.player.pack[camp.player.pack_n] then
		camp.player.pack[camp.player.pack_n] = Deepcopy(ATO[camp.player.side][camp.player.pack_n])
	end

	--for multi-package strikes, add flights from other packages with the same target to player package to enrich the briefiing
	for p = 1, #ATO[camp.player.side] do										--iterate through packages in player side	
		for role,flight in pairs(ATO[camp.player.side][p]) do					--iterate through roles in package (main, SEAD, escort)		
			for f = 1, #flight do												--iterate through flights in roles
				if flight[f].target_name == camp.player.target.titleName and camp.player.pack_n ~= p then	--flights that have the same target as player but are not in the player package
					table.insert(camp.player.pack[role], Deepcopy(flight[f]))							--insert flight into player package to list it in player briefing
				end
				if flight[f].player or flight[f].client then
					-- modification M33_b 	Custom Briefing (onBoardNum)
					if flight[f].target_name == camp.player.target.titleName and camp.player.pack_n == p and not breakloop then
						for _side,side in pairs(mission.coalition) do
							for _country,country in pairs(side.country) do
								if country.plane and _side == camp.player.side then
									for Ngroup,group in pairs(country.plane.group) do
										if group.units and ( group.units[1].skill == "Player" or group.units[1].skill == "Client" ) then

											--TODO encore utile?
											-- camp.player.pack[camp.player.pack_n][role][f].units = group.units

											if tabDivert and tabDivert["player"] then

												camp.player.pack[role][f]["divert"] = tabDivert["player"]["pack"][role][f].base

											end
											-- breakloop = true
										end
									end
								end
								if country.helicopter and _side == camp.player.side then
									for Ngroup,group in pairs(country.helicopter.group) do
										if group.units and ( group.units[1].skill == "Player" or group.units[1].skill == "Client" ) then
											-- camp.player.pack[camp.player.pack_n][role][f].units = group.units
											if tabDivert and tabDivert["player"] then
												camp.player.pack[camp.player.pack_n][role][f]["divert"] = tabDivert["player"]["pack"][role][f].base
											end
											-- breakloop = true
										end
									end
								end
							end
						end
					end
				end

			end
		end
	end
end


if camp.client then

	-- camp.client.pack = Deepcopy(ATO[camp.client.side][camp.client.pack_n])
	for c = 1, #camp.client do
		if not camp.client.pack then camp.client.pack = {} end
		if not camp.client.pack[camp.client[c].pack_n] then
			camp.client.pack[camp.client[c].pack_n] = Deepcopy(ATO[camp.client[c].side][camp.client[c].pack_n])	--pack_n
		end


	end

		-- if  tabDivert["client"] then
		-- 	if pack_ and PlayerFlight then
		-- 		for i = 1, #camp.client do
		-- 			if tabDivert["client"][i] and tabDivert["client"][i]["pack"]  and tabDivert["client"][i]["pack"][role] and tabDivert["client"][i]["pack"][role][f] then
		-- 				camp.client[i]["pack"][role][f]["divert"] = tabDivert["client"][i]["pack"][role][f]["base"]
		-- 			end
		-- 		end
		-- 	end
		-- end

	-- for p = 1, #ATO[camp.client.side] do
	-- 	for role,flight in pairs(ATO[camp.client.side][p]) do
	-- 		for f = 1, #flight do
	-- 			if flight[f].target_name == camp.client.target.titleName and camp.client.pack_n ~= p then
	-- 				local copyFlight = Deepcopy(flight[f])
	-- 				if copyFlight and copyFlight.target then copyFlight.target = nil end
	-- 				if copyFlight and copyFlight.route then copyFlight.route = nil end
	-- 				if copyFlight and copyFlight.loadout then copyFlight.loadout = nil end
	-- 				table.insert(camp.client.pack[role], Deepcopy(flight[f]))
	-- 			end				
	-- 		end
	-- 	end
	-- end
end


-- if camp.client then

-- 	-- for c = 1, #camp.client do
-- 	-- 	camp.client[c].pack = Deepcopy(ATO[camp.client[c].side][camp.client[c].pack_n])	--pack_n
-- 	-- end
-- 	--for multi-package strikes, add flights from other packages with the same target to player package to enrich the briefiing
-- 	for c, pack_ in pairs(camp.client) do
-- 		for p = 1, #ATO[pack_.side] do										--iterate through packages in player side	
-- 			for role,flight in pairs(ATO[pack_.side][p]) do					--iterate through roles in package (main, SEAD, escort)		
-- 				for f = 1, #flight do												--iterate through flights in roles
-- 					-- if flight[f].target_name == pack_.target.titleName and pack_.pack_n ~= p then	--flights that have the same target as player but are not in the player package
-- 						-- table.insert(pack_.pack[role], Deepcopy(flight[f]))							--insert flight into player package to list it in player briefing
-- 					-- end	
-- 					if flight[f].client  then
-- 						-- modification M33_b 	Custom Briefing (onBoardNum)
-- 						if flight[f].target_name == pack_.target.titleName and pack_.pack_n == p and not breakloop then

-- 							for _side,side in pairs(mission.coalition) do
-- 								for _country,country in pairs(side.country) do
-- 									if country.plane and _side == pack_.side then
-- 										for Ngroup,group in pairs(country.plane.group) do
-- 											-- if group.units and ( group.units[1].skill == "Client" ) and (group.units[1].type == pack_.pack[role][f].type)  then
-- 											local egual = false
-- 											if type(tonumber( group.units[1].callsign)) == "number" and type(tonumber(pack_.pack[role][f].callsign)) == "number" then
-- 												if group.units[1].callsign == pack_.pack[role][f].callsign then egual = true end
-- 											elseif type(tonumber( group.units[1].callsign)) ~= "number" and type(tonumber(pack_.pack[role][f].callsign)) ~= "number" then
-- 												if group.units[1].callsign.name == pack_.pack[role][f].callsign then egual = true end
-- 											end
-- 											if group.units and ( group.units[1].skill == "Client" ) and egual  then
-- 												pack_.pack[role][f].units = group.units
-- 												if tabDivert then
-- 													-- if  tabDivert["client"] then
-- 													-- 	if pack_ and PlayerFlight then
-- 													-- 		for i = 1, #camp.client do
-- 													-- 			if tabDivert["client"][i] and tabDivert["client"][i]["pack"]  and tabDivert["client"][i]["pack"][role] and tabDivert["client"][i]["pack"][role][f] then
-- 													-- 				camp.client[i]["pack"][role][f]["divert"] = tabDivert["client"][i]["pack"][role][f]["base"]
-- 													-- 			end
-- 													-- 		end
-- 													-- 	end
-- 													-- end
-- 												end
-- 											end
-- 										end
-- 									end
-- 									if country.helicopter and _side == pack_.side then
-- 										for Ngroup,group in pairs(country.helicopter.group) do
-- 											local egual = false
-- 											-- local testNumber = tonumber(group.units[1].callsign)
-- 											-- if type(testNumber) == "number" and type(pack_.pack[role][f].callsign)== "number" then
-- 											if type(tonumber(group.units[1].callsign)) == "number" and type(tonumber(pack_.pack[role][f].callsign)) == "number" then
-- 												if group.units[1].callsign == pack_.pack[role][f].callsign then egual = true end
-- 											elseif type(tonumber(group.units[1].callsign)) ~= "number" and type(tonumber(pack_.pack[role][f].callsign)) ~= "number" then
-- 												if group.units[1].callsign.name == pack_.pack[role][f].callsign then egual = true end
-- 											end

-- 											if group.units and ( group.units[1].skill == "Client" ) and egual  then
-- 												pack_.pack[role][f].units = group.units

-- 												if tabDivert then
-- 													if  tabDivert["client"] then
-- 														if pack_ and PlayerFlight then
-- 															for i = 1, #camp.client do
-- 																if tabDivert["client"][i] and tabDivert["client"][i]["pack"]  and tabDivert["client"][i]["pack"][role] and tabDivert["client"][i]["pack"][role][f] then
-- 																	camp.client[i]["pack"][role][f]["divert"] = tabDivert["client"][i]["pack"][role][f]["base"]
-- 																end
-- 															end
-- 														end
-- 													end
-- 												end
-- 											end
-- 										end
-- 									end
-- 								end
-- 							end
-- 						end
-- 					end
-- 				end
-- 			end
-- 		end
-- 	end
-- end

local function ShipFindByName(name)
	for coal_name,coal in pairs(oob_ground) do												--go through sides(red/blue)	
		for country_n,country in ipairs(coal) do											--go through countries
			if country.ship then															--country has ships
				for group_n,group in ipairs(country.ship.group) do							--go through groups
					for n = 1, #group.units do												--ship group found
						if name == group.units[n].name then
							return group.units[n]
						end
					end
				end
			end
		end
	end
end



-- modification M18.c despawn/destroy Plane on BaseAirStart
camp.BaseAirStart = tempBaseAirStart

-- local debugTxt_AtoFP = debugTxt_AtoFP
local debugGenMFile = io.open("Debug/debugGenMission.txt", "w") or error("Failed to open debug file")
debugGenMFile:write(debugTxt_AtoFP)
debugGenMFile:close()


-- local camp_str = "mission_AtoFP = " .. TableSerialization(mission, 0)						
-- local campFile = io.open("Debug/mission_AtoFP.lua", "w")								
-- campFile:write(camp_str)															
-- campFile:close()

-- local camp_str = "target = " .. TableSerialization(targetList_InThisMission, 0)						
-- local campFile = io.open("Debug/targetList_InThisMission_AtoFP.lua", "w")								
-- campFile:write(camp_str)															
-- campFile:close()



local camp_str = "TabLPark = " .. TableSerialization(TabLPark, 0)
local campFile = io.open("Debug/TabLPark_AtoFP.lua", "w") or error("Failed to open debug file")
campFile:write(camp_str)
campFile:close()

local testPosRunwayImpact = false

if testPosRunwayImpact then
	if not mission.coalition.blue.country[1].vehicle then
		mission.coalition.blue.country[1].vehicle.group = {}
	end

	mission_ini.PruneScriptConf.PruneScript  = false

	-- local nbGroup = #mission.coalition.country[1].vehicle.group
	for baseName, airbase in pairs(db_airbases) do
		if airbase.runways then

			for runwayN, runway in pairs(airbase.runways) do

				local tempTarget = {}
				tempTarget.db_airbaseName = baseName

				if runway.x and runway.x ~= 0 then
					print("AtoFP B baseName "..baseName)

					--pour la map caucasus
					if camp.theatre and (string.lower(camp.theatre)  == "caucasus" or string.lower(camp.theatre)  == "persiangulf") then
						local hdg = runway.hdg
						if not runway.true_hdg or runway.true_hdg == nil then
							hdg = runway.hdg + camp.variation
						end

						local runwayDecal  = GetOffsetPoint({x=runway.x, y=runway.y}, hdg+90, 30)

						runway.x = runwayDecal.x
						runway.y = runwayDecal.y

						local distance = 0
						local interval = runway.length / 9
						for e = 1, 8 do
							distance = distance + interval
							local newPos = GetOffsetPoint({x=runway.x, y=runway.y}, hdg, distance)
							if not tempTarget.elements then tempTarget.elements = {} end

							tempTarget.elements[#tempTarget.elements +1] = {
								name = tempTarget.db_airbaseName.." runway "..runway.name.." part "..e,
								x = newPos.x,
								y = newPos.y,
							}

						end

						-- _affiche(tempTarget.elements, "tempTarget.elements")
					else
						--pour la map Syria
						local hdg = runway.hdg
						if not runway.true_hdg or runway.true_hdg == nil then
							hdg = runway.hdg + camp.variation
						end
						local distance = 0
						local interval = runway.length / 9
						for e = 1, 4 do
							distance = distance + interval
							local newPos = GetOffsetPoint({x=runway.x, y=runway.y}, hdg, distance)
							if not tempTarget.elements then tempTarget.elements = {} end

							tempTarget.elements[#tempTarget.elements +1] = {
								name = tempTarget.db_airbaseName.." runway part "..e,
								x = newPos.x,
								y = newPos.y,
							}

						end
						hdg = hdg + 180

						distance = 0
						for e = 5, 8 do
							distance = distance + interval
							local newPos = GetOffsetPoint({x=runway.x, y=runway.y}, hdg, distance)
							if not tempTarget.elements then tempTarget.elements = {} end

							tempTarget.elements[#tempTarget.elements +1] = {
								name = tempTarget.db_airbaseName.." runway part "..e,
								x = newPos.x,
								y = newPos.y,
							}

						end
					end
				end

				local AddGroup = {
					["visible"] = false,
					["tasks"] =
					{
					}, -- end of ["tasks"]
					["uncontrollable"] = false,
					["task"] = "Pas de sol",
					["taskSelected"] = true,
					["route"] =
					{
						["spans"] =
						{
						}, -- end of ["spans"]
						["points"] =
						{
							[1] =
							{
								-- ["alt"] = tonumber(target.z2d),
								["type"] = "Turning Point",
								["ETA"] = 0,
								["name"] = tostring(baseName).."_runway_"..runwayN,
								["alt_type"] = "BARO",
								["formation_template"] = "",
								["y"] = tonumber(runway.y),
								["x"] = tonumber(runway.x),
								ETA_locked = true,
								["speed"] = 0,
								["action"] = "Off Road",
								["task"] =
								{
									["id"] = "ComboTask",
									["params"] =
									{
										["tasks"] =
										{
										},
									}, -- end of ["params"]
								}, -- end of ["task"]
								speed_locked = true,
							}, -- end of [1]
						}, -- end of ["points"]
					}, -- end of ["route"]
					["groupId"] = GenerateIDGroup(),
					["hidden"] = false,

					["y"] = tonumber(runway.y),
					["x"] = tonumber(runway.x),
					["name"] = "Group_Runway_"..baseName.."_runway_"..runwayN,
					["start_time"] = 0,
				}

				print("AtoFP Ngroup AVANT   "..tostring(#mission.coalition.blue.country[1].vehicle.group))

				table.insert(mission.coalition.blue.country[1].vehicle.group, AddGroup)
				local Ngroup = #mission.coalition.blue.country[1].vehicle.group

				print("AtoFP Ngroup APRES   "..tostring(#mission.coalition.blue.country[1].vehicle.group))

				if tempTarget.elements then
					print("AtoFP execute runway "..baseName.." "..tostring(Ngroup))

					for e, element in ipairs(tempTarget.elements) do
						print("AtoFP execute runway e "..tostring(e))
						-- _affiche(element, "AtoFP element")

						if not mission.coalition.blue.country[1].vehicle.group[Ngroup].units then mission.coalition.blue.country[1].vehicle.group[Ngroup].units = {} end
						local unitAdd =
						{

							["type"] = "Soldier M4",
							["unitId"] = GenerateIDUnit("AtoFP ".."UnitRunway_"..baseName.."_"..e),
							["livery_id"] = "winter",
							["skill"] = "Average",
							["y"] = tonumber(element.y),
							["x"] = tonumber(element.x),
							["name"] = "UnitRunway_"..baseName.."_"..e,
							["heading"] = 0,
							["playerCanDrive"] = false,

						}


						table.insert(mission.coalition.blue.country[1].vehicle.group[Ngroup].units, unitAdd)
						-- print("AtoFP Nunits   "..tostring(#mission.coalition.blue.country[1].vehicle.group[Ngroup].units))
					end
				else
					print("AtoFP bug runway "..baseName)
					os.execute 'pause'
				end
			end
		end
	end
end


for _side, side in pairs(mission.coalition) do
	for countryN, country in pairs(side.country) do

		for category, groups in pairs(country) do

			if (category == "plane" or category == "helicopter" ) and type(groups) == "table" and groups["group"]  then	--and groups[1].units
				for Ngroup, group in pairs(groups["group"]) do

					for pointN, point in pairs(group.route.points) do

						if not point.ETA_locked and not point.speed_locked then
							print("AtoFP bug ETA and Speed not lock in "..pointN.." "..group.name)
							_affiche(point, "AtoFP point")
							os.execute 'pause'
						end
					end
				end
			end
		end
	end
end


local positionCentrale = {}
for _side, side in pairs(mission.coalition) do
	for countryN, country in pairs(side.country) do

		for category, groups in pairs(country) do

			if (category == "vehicule" or category == "static"  ) and type(groups) == "table" and groups["group"]  then
				for Ngroup, group in pairs(groups["group"]) do

					if string.find(group.name, "ASTI") then
						positionCentrale.x = group.x
						positionCentrale.y = group.y
						positionCentrale.name = group.name
					end


				end
			end
		end
	end
end

--supprime les ["num"] = 1, des loadouts
--qui sont devenu inutile
for _side, side in pairs(mission.coalition) do
	for countryN, country in pairs(side.country) do
		for category, groups in pairs(country) do
			if type(groups) == "table" and groups["group"]  then
				for Ngroup, group in pairs(groups["group"]) do
					for Nunit, unit in pairs(group.units) do
						if unit.payload and unit.payload.pylons   then
							for pylonN, pylon in pairs(unit.payload.pylons) do
								if pylon and pylon.num then
									pylon.num = nil
								end
							end
						end
					end
				end
			end
		end
	end
end

if Debug.debug then
	local camp_str = "ATO_AtoFP = " .. TableSerialization(ATO, 0)						--make a string
	local campFile = io.open("Debug/ATO_AtoFP.lua", "w")  or error("Failed to open debug file")
	campFile:write(camp_str)																		--save new data
	campFile:close()

	if camp.client then
		local camp_str = "client = " .. TableSerialization(camp.client, 0)						--make a string
		local campFile = io.open("Debug/camp_client_AtoFP.lua", "w")  or error("Failed to open debug file")
		campFile:write(camp_str)																		--save new data
		campFile:close()
	elseif camp.player then
		local camp_str = "player = " .. TableSerialization(camp.player, 0)						--make a string
		local campFile = io.open("Debug/camp_player_AtoFP.lua", "w")  or error("Failed to open debug file")
		campFile:write(camp_str)																		--save new data
		campFile:close()
	end

end