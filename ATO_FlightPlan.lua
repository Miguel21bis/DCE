--To create the flight plans in the mission file for all flights in the ATO
--Initiated by Main_NextMission.lua
------------------------------------------------------------------------------------------------------- 
if not versionDCE then versionDCE = {} end
versionDCE["ATO_FlightPlan.lua"] = "1.58.295"
------------------------------------------------------------------------------------------------------- 

if Debug.debug then
	print("START ATO_FlightPlan.lua "..versionDCE["ATO_FlightPlan.lua"].." =-=-=-=-=-=-=-=-=-=-=-=-=-=-=")
end

DebugFLIGHT = ""
TabLPark	= {}
TargetList_InThisMission = {}			-- garde en mémoire les targets pour eviter de les pruner plus tard
PointOfInterest = {}					-- liste des points d'interet
TabDivert = {}							--liste des pistes de deroutement
HumainInterceptor = false
MsgForPlayerInMsn = {}


local debugStart = true					--NE PAS CHANGER, les infos restent seulement dans le fichier FlightPlan_Generator_Debug
local debugTxt_AtoFP = ""
local callSignFlight = {}
local callSignFlightUnite = {}
local playerTask = ""
local tempBaseAirStart = {}
local tempDeckPlace = {}
local testDeckPlace = {}
local altRole = 0
local mn_StartParking = 5 				--[en minute] 5 mn de temps de presence sur parking
local parkSarAirBase = {}				--reprend la table db_airbases[basename].parkAlertSAR
local is_helicopter
local baseIsFARP
local baseIsCarrier
local tacan_byTarget = {}				--liste les TACAN pour un meme parttern , util pour les multiples tanker
local proximityAircraft = {} 			-- Table des avions de ravitaillement déjà enregistrés
local offsetDistance = 15000			-- Distance minimale entre tankers (15 km)
local currentHeading = 0  				-- Angle initial-- On démarre vers le Nord
local nameTheatre = mission.theatre
local nbFlightPackage = 0													-- calcul le nombre de flight dans un Package, en comptant ceux des Roles

local basePlayer = ""
local cv_nbPlanetDeck = 0														-- nb d'avion total sur la plateform
local cv_nbPlaneSixPack = {}
local cv_deckReservations = {}
local cv_testSixPack = {}
local pedroOK = {}						--flag pour connaitre si un pedro est activé pour un CV
local departureOrbitAlt = {}		--table to store departure altitudes and times and all airbases to deconflict spawns and orbits
local stackN = 0


if not camp.SAR then camp.SAR = {} end
camp.SAR.helicopter = {}

if Multi.NbGroup >= 1 then

	mission_ini.PruneScript = true							-- reduce a mission by removing units (mod Tomsk M09) [MP: recommend: true]					PruneAggressiveness = 1.5,					-- How aggressive should the pruning be [0 to 2], larger numbers will remove more units, 0 = no pruning at all
	mission_ini.PruneStatic = true							-- Should ALL parked (static) aircraft be pruned [MP: recommend: true]
	-- mission_ini.ForcedPruneSam = true						-- PBO-CEF avait prévu de garder des SAM actif, cette option les d�sactives tout de m�me [MP: recommend: true]
	mission_ini.failure = false								-- (true or false) modification M20 [MP: recommend: false]
	-- mission_ini.ravitoByConvoy = false					-- [non encore fonctionnel] ravitaillement par convoy routier 
	mission_ini.Keep_USNdeckCrew = false					-- false = supprime US Navy deck crew dans la génération de mission. Miguel Modification M23
	mission_ini.CV_CleanDeck = true 							-- true: Remove all static aircraft from the deck. ( M31 )

	-- Force vos propres options plutot que ceux de base_ini.miz, qui correspondent à ceux de PBO-CEF ^^
	if not mission.forcedOptions then mission.forcedOptions = {} end
	mission.forcedOptions.accidental_failures =  false
	mission_forcedOptions.wakeTurbulence = false			-- False / true : turbulence  [MP: recommend: false]
	mission_forcedOptions.civTraffic = ""					-- Traffic civil routier : ( "" : OFF ) || ( "low" : BAS ) || ( "medium" : MOYEN )|| ( "high" : ELEVE )  [MP: recommend: ""]
	mission_forcedOptions.birds = 0							-- Collision volatile (probabilité) ( 0 à 1000 )  [MP: recommend: 0]

	mission.failures = {}
end

----- Desactive USN Mod -----modification M23
if not mission_ini.Keep_USNdeckCrew and mission.requiredModules['USN-Deckcrew'] then
	mission.requiredModules['USN-Deckcrew'] =  nil
end

-- ["requiredModules"] = 
-- {
-- 	["Hercules"] = "Hercules",
-- }, -- end of ["requiredModules"]

if mission.requiredModules then
	for nameN, _ in pairs(mission.requiredModules) do
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


if Multi.NbGroup <= 0 and mission.failures and Failures and Failures[type_withData_player] then
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
local callSign_west_counter = {
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
	CommonFreq[side]["UHF"][1] = GetFrequencyNG(side, nil, "coalition", nil, "UHF")
	CommonFreq[side]["UHF"][2] = GetFrequencyNG(side, nil, "coalition", nil, "UHF")

	CommonFreq[side]["VHF"][1] = GetFrequencyNG(side, nil, "coalition", nil, "VHF")
	CommonFreq[side]["VHF"][2] = GetFrequencyNG(side, nil, "coalition", nil, "VHF")

	CommonFreq[side]["HF"][1] = GetFrequencyNG(side, nil, "coalition", nil, "HF")
	CommonFreq[side]["HF"][2] = GetFrequencyNG(side, nil, "coalition", nil, "HF")
	CommonFreq[side]["LVHF"][1] = GetFrequencyNG(side, nil, "coalition", nil, "LVHF")
	CommonFreq[side]["LVHF"][2] = GetFrequencyNG(side, nil, "coalition", nil, "LVHF")

	for n=1, 2 do
		local testFreqency = tonumber(CommonFreq[side]["UHF"][n])
		if tonumber(CommonFreq[side]["UHF"][n]) == 243 or tonumber(CommonFreq[side]["UHF"][n]) == 121.5 then
			DebugFLIGHT = DebugFLIGHT .. " ATTENTION GUARD Frequence Commune "..tostring(testFreqency)
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

local function getParkSarAirBase(flightF)

	local nLoop = 1

	if parkSarAirBase[flightF.base] then

		local pkFound = false

		local nPk = 0
		repeat
			nPk = math.random(1, #parkSarAirBase[flightF.base])

			if not parkSarAirBase[flightF.base][nPk].occupied or parkSarAirBase[flightF.base][nPk].occupied == false then
				parkSarAirBase[flightF.base][nPk].occupied = true
				if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP_getParkSarAirBase |return nil| flightF.base: "..tostring(flightF.base).. " |nPk :  "..tostring(nPk)) end
				return nPk
				-- pkFound = true
			end
			nLoop = nLoop + 1
		until nLoop > 200
	end

	if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP_getParkSarAirBase |return nil| flightF.base: "..tostring(flightF.base).. " |nLoop :  "..tostring(nLoop)) end	
	if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP_getParkSarAirBase ").._afficheTXT(parkSarAirBase[flightF.base]) end
	return nil

end




-- Ajout d'un tanker avec rotation du cap
local function addAndSpaceTankers(groupName, startX, startY)
    local newPosition = { x = startX, y = startY }
    local count = 0

    -- Comptage des tankers existants
    for _, _ in pairs(proximityAircraft) do
        count = count + 1
    end

    -- Décale chaque nouveau tanker
    if count > 0 then
        newPosition = GetOffsetPoint(newPosition, currentHeading, offsetDistance)

        -- On fait tourner le cap de 90°
        currentHeading = (currentHeading + 90) % 360
    end

    -- Vérifier que la nouvelle position respecte bien 15 km d’écart
    for _, tanker in pairs(proximityAircraft) do
        local dx = newPosition.x - tanker.x
        local dy = newPosition.y - tanker.y
        local distance = math.sqrt(dx * dx + dy * dy)

        -- Si un tanker est trop proche, on ajuste en le repoussant
        if distance < offsetDistance then
            -- print("⚠️ Ajustement de la position pour éviter un chevauchement")
            newPosition = GetOffsetPoint(newPosition, currentHeading, offsetDistance)
        end
    end

    -- Ajout du tanker dans la table
    proximityAircraft[groupName] = newPosition

    -- print(" Tanker ajouté:", groupName, "Position:", newPosition.x, newPosition.y, "Cap:", currentHeading)

	return newPosition.x, newPosition.y
end

local function getCallsignWest(category, task, flight_f, flight_n, aircraft_n)
    -- Toute la logique actuelle pour l'ouest ici
    -- Retourne la table callsign attendue par DCS pour l'ouest

	local callsign_flight = 0
	local testCall = ""
	local testCallFlightUnite = ""
	local callsign_nb = 0
	local _name = ""
	local foundCsf = false
	local callsign

	if task == "AWACS" then
		category = "AWACS"
	elseif task == "Refueling" then
		category = "tanker"
	else
		category = "generic"
	end

	if flight_f.target.predeterminedCallsign then

		callsign_flight = flight_f.target.predeterminedCallsign.groupNumber

		if callsign_flight <= 9 then
			callsign_flight = callsign_flight * 10
		end

		local nb_unite

		-- les tanker ne fonctionne pas avec Texaco 4.5
		-- mais Texaco 45.1
		--dans un group de 1, l'unité doit toujours etre à 1
		local ii = 1
		repeat
			nb_unite = math.random(2, 9)
			callsign_flight = callsign_flight + nb_unite
			testCall = Callsign_west[category][callSign_west_counter[category]]..callsign_flight
			testCallFlightUnite = testCall..1
			ii = ii + 1
		until ii > 50 or not callSignFlightUnite[testCallFlightUnite]

		callSignFlight[testCall] = true
		callSignFlightUnite[testCallFlightUnite] = true

		callsign_nb = callSign_west_counter[category]
		_name = Callsign_west[category][callSign_west_counter[category]] .. callsign_flight .. 1

		callsign = {
			[1] = callsign_nb,
			[2] =  callsign_flight,
			[3] =  1,
			name = _name
		}

		-- return callsign


	else

		--M56_b
		--si le callsign à déjà été défini par AssignCallnameSquad() ou oob_air_init
		if flight_f and flight_f["callsign"] and flight_f["callsignId"]  then

			if aircraft_n == 1 then

				local ii = 1
				repeat
					callsign_flight = math.random(1, 9)
					testCall = flight_f["callsign"]..callsign_flight
					if not callSignFlight[testCall] then
						callSignFlight[testCall] = true
						flight_f["callsign_flight"] = callsign_flight
						foundCsf = true
						break
					end
					ii = ii + 1
				until ii > 30 or foundCsf

				--si le random non tuilé ne fonctionne pas, tant pis, on prend au pif
				if not foundCsf then
					callsign_flight = math.random(1, 9)
					testCall = flight_f["callsign"]..callsign_flight
					flight_f["callsign_flight"] = callsign_flight
					callSignFlight[testCall] = true
				end
			end

			callsign_flight = flight_f["callsign_flight"]
			callsign_nb = flight_f["callsignId"]
			_name = flight_f["callsign"] .. callsign_flight .. aircraft_n

		else
			if flight_n == 1 and aircraft_n == 1 then
				callSign_west_counter[category] = callSign_west_counter[category] + 1
				if callSign_west_counter[category] > #Callsign_west[category] then
					callSign_west_counter[category] = 1
				end
				callsign_flight = math.random(0, 8)
			end

			if aircraft_n == 1 then
				if not callsign_flight then
					DebugFLIGHT = DebugFLIGHT .. "\nNote for the Campaign Maker: The nation of a previous aircraft misfiled in the table  conf_mod/campMod.WestCallsign or ATO_FlightPlan/country\n"
					DebugFLIGHT = DebugFLIGHT .. "\n"..flight_f.name.. "\n"
				end

				local ii = 1
				repeat
					callsign_flight = math.random(1, 9)

					if not Callsign_west[category] or not callSign_west_counter[category] or not Callsign_west[category][callSign_west_counter[category]] then
						DebugFLIGHT = DebugFLIGHT .. "\nAtoFp Error GetCal..callsign: "..tostring(category).." "..tostring(callSign_west_counter[category])"\n"
					end


					testCall = Callsign_west[category][callSign_west_counter[category]]..callsign_flight
					if not callSignFlight[testCall] then
						callSignFlight[testCall] = true
						foundCsf = true
						break
					end
					ii = ii + 1
				until ii > 100 or foundCsf

				--si le random non tuilé ne fonctionne pas, tant pis, on prend au pif
				if not foundCsf then
					callsign_flight = math.random(1, 9)
					testCall = Callsign_west[category][callSign_west_counter[category]]..callsign_flight
					callSignFlight[testCall] = true
				end

			end

			callsign_nb = callSign_west_counter[category]
			_name = Callsign_west[category][callSign_west_counter[category]] .. callsign_flight .. aircraft_n

		end

		callsign = {
			[1] = callsign_nb,
			[2] =  callsign_flight,
			[3] =  aircraft_n,
			name = _name
		}
	end

	-- print("AtoFP flight_f.name "..tostring(flight_f.name))
	-- _affiche(callsign, "callsign")
    return callsign
end

local function getCallsignEast(aircraft_n)
    -- Toute la logique actuelle pour l'est ici
    -- Retourne le nombre attendu par DCS pour l'est

		if aircraft_n == 1 then
			callsign_east_counter = callsign_east_counter + 1
		end
		local callsign = 90 + callsign_east_counter * 10 + aircraft_n

		-- callsign = {
		-- 	[3] = hundreds,
		-- 	[2] = tens,
		-- 	[1] = ones,
		-- 	name = ""
		-- }

    return callsign
end

local function getCallsign(country, flight_f, task, flight_n, aircraft_n )
	--["callsign"] = getCallsign(flight[f].country, flight[f], flight[f].task, f, n),

    local style = IsWesternCountry(country) and "west" or "east"
    if style == "west" then
        local category = "generic"
        if task == "AWACS" then category = "AWACS"
        elseif task == "Refueling" then category = "tanker" end
        return getCallsignWest(category, task, flight_f, flight_n, aircraft_n)
    else
        return getCallsignEast(aircraft_n)
    end
end


---- function to get sidenumbers -----
local sidenumbers = {}

-- function GetSidenumber(squadron, lower, upper, nUnit, player, type)				--not local, also used in DC_StaticAircraft
function GetSidenumber(flight, nUnit)				--not local, also used in DC_StaticAircraft

	local squadron = flight.name
	local lower = flight.sidenumber and flight.sidenumber[1] or nil
	local upper = flight.sidenumber and flight.sidenumber[2] or nil
	local player = flight.player
	local client = flight.client
	local type = flight.type

	local s 																		--new sidenumber
	local counter = 0

	-- if type == "F-4E-45MC" then
	-- 	print("player "..tostring(player).." client "..tostring(client).." flight.task "..tostring(flight.task))
	-- 	print("mission_ini.persistentAircraftTailNb "..tostring(mission_ini.persistentACFT_TailNb))
	-- 	print("mission_ini.persistentAircraftKey "..tostring(mission_ini.persistentACFT_FileNameCache))
	-- 	-- os.execute 'pause'
	-- end
	if type == "F-4E-45MC" and mission_ini.persistentACFT_TailNb and mission_ini.persistentACFT_TailNb ~= "" then
		-- print("persistent passe A")
		if player then
			-- print("persistent passe A2")
			if nUnit == 1 then
				-- print("persistent passe A3 ok")
				-- os.execute 'pause'
				return mission_ini.persistentACFT_TailNb, mission_ini.persistentACFT_FileNameCache, true
			end
		--utilise ici le fichier Init/persistenceMP.lua s'il existe, pour facilité l'attribution des num tail/avion
		elseif client and PersistenceMP_byTask and PersistenceMP_byTask[flight.task] then
			-- print("persistent passe B")
			for clientName, clientData in pairs(PersistenceMP_byTask[flight.task]) do
				-- print("persistent passe B2")
				if not clientData.assigned and clientData.tailNum then
					-- print("persistent passe B3 OK")
					-- os.execute 'pause'
					clientData.assigned = true
					return tostring(clientData.tailNum), mission_ini.persistentACFT_FileNameCache, true
				end
			end
		end
	end

	if not lower or upper then
		s = math.random(1, 99)										--us a random number
		s = string.format("%03d", s)
		return tostring(s)
	end
	if sidenumbers[squadron] == nil then										--sidenumber squadron entry does not exist
		sidenumbers[squadron] = {}												--create sidenumber squadron entry
	end
	local upperNum = tonumber(upper)
	local lowerNum = tonumber(lower)


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
		preTest = "003"
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
		preTest = "00"
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

	if i >= 400 then
		DebugFLIGHT = DebugFLIGHT .. "\n".." AtoFP Get_L16_Id trop long "..i.." test "..testId
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

	until SADL_TN_Id[testId] == nil or i >= 300


	if i >= 200 then
		DebugFLIGHT = DebugFLIGHT .. "\n".." AtoFP Get_SADL_Id trop long "..i.." test "..testId
	end

	return testId
end


--spécial datalink AH-64
local pack_IDM_unitId = {}
local IDM_Id = {}

local function get_IDM_Id()
	local i = 0

	local testId = "1"

	repeat
		i=i+1
		local digit1 = math.random(1,39)

		testId = tostring(digit1)

	until IDM_Id[testId] == nil or i >= 300

	if i >= 200 then
		DebugFLIGHT = DebugFLIGHT .. "\n".."AtoFP IDM_Id trop long "..i.." test "..testId
	end

	return testId
end

-- --liste toutes les Fréquences déjà existantes pour ne pas creer de doublon
-- for basename, base in pairs(db_airbases) do
-- 	if base.ATC_frequency and base.ATC_frequency ~= "" and type(base.ATC_frequency)~= "table" then
-- 		Assigned_freq[tonumber(base.ATC_frequency)] = basename
-- 	elseif base.ATC_frequency and type(base.ATC_frequency)== "table" then
-- 		for n , freq in ipairs(base.ATC_frequency) do
-- 			Assigned_freq[tonumber(freq)] = basename
-- 		end
-- 	else
-- 		-- _affiche(base.ATC_frequency, "AA base.ATC_frequency") 
-- 	end
-- end


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

		if test and test ~= nil then
			local channel_num = tonumber(test)
			if channel_num then
				channel = channel_num
			end
		end
		channel_tacan[channel] = true

	end
end


local function getTankerTACAN(tarnetName)

	local channel

	if tacan_byTarget[tarnetName] then
		return tacan_byTarget[tarnetName]
	end

	repeat
		-- channel = math.random(37, 67)											--find random TACAN channel
		channel = math.random(1, 63)
	until channel_tacan[channel] == nil											--repeat until channel is found that is not in use yet

	channel_tacan[channel] = tarnetName												--mark channel in use
	tacan_byTarget[tarnetName] = channel

	return channel																--return channel
end

--Mod M27.b Randomly moves the 2 BullsEye
local function fct_movedBullseye(arg_Side, arg_NameTheatre)

	local tempArrayBulls = {}
	local tempBullseye =
	{
		x = 0,
		y = 0,
		name = "",
	}



	if not mission_ini.movedBullseye then
		for name, base in pairs(db_airbases) do
			if base.x and not base.unitname and base.side == arg_Side then
				if base.selectedBullseye then
					tempBullseye.x = base.x
					tempBullseye.y = base.y
					tempBullseye.name = name
				end
			end
		end
	else

		for baseName, base in pairs(db_airbases) do
			if base.x and not base.unitname then
			-- if base.x  then
				if GetDistance(campMod.movedBullseye[arg_NameTheatre].pos, base) <= (campMod.movedBullseye[arg_NameTheatre].rayon * 1000) then
					db_airbases[baseName]["name"] = baseName
					table.insert(tempArrayBulls, db_airbases[baseName])
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
		mission.coalition[arg_Side].bullseye.x = tempBullseye.x
		mission.coalition[arg_Side].bullseye.y = tempBullseye.y

		--ajoute bullseye dans briefing
		if not Brief[arg_Side].bullseye then Brief[arg_Side].bullseye = {} end
		Brief[arg_Side].bullseye.name = tempBullseye.name
		Brief[arg_Side].bullseye.x = tempBullseye.x
		Brief[arg_Side].bullseye.y = tempBullseye.y

		if LL_PositionsFileExit then

			local xKey = math.abs(math.floor(tempBullseye.x))
			if LL_Positions[xKey]  then
				local testX = math.floor(Brief[arg_Side].bullseye.x)
				local testY = math.floor(Brief[arg_Side].bullseye.y)
				for n, llPos in pairs(LL_Positions[xKey] ) do
					if testX == llPos.x and testY == llPos.y then
						Brief[arg_Side].bullseye.lat = llPos.lat
						Brief[arg_Side].bullseye.lon = llPos.lon
						break
					end
				end
			end
		end
	end

	return mission.coalition[arg_Side].bullseye, Brief[arg_Side].bullseye

end

--modify_activate_group_time
local function modify_Activate_GroupTime(arg_Group, arg_AirSpawnTime, from)

	if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP_modify_Activate_GroupTime() passe A "..tostring(arg_AirSpawnTime).." from: "..tostring(from)) end

	-- arg_Group['uncontrolled'] = true -- ATTENTION, non surtout pas, cela depend
	local found = false
	for trig_n = 1, #mission.trigrules do
		if mission.trigrules[trig_n] and mission.trigrules[trig_n].actions and mission.trigrules[trig_n].actions[1] then
			if mission.trigrules[trig_n].actions[1].group and mission.trigrules[trig_n].actions[1].group == arg_Group.groupId then

				
				if mission.trigrules[trig_n].rules and mission.trigrules[trig_n].rules[1] then
					if mission.trigrules[trig_n].rules[1].flag then
						
						if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP_modify_Activate_GroupTime() passe Z, RETURN, activate by flag found ") end
						return
					end
				end

				if arg_AirSpawnTime == -1 then
					arg_AirSpawnTime = 0
				end

				mission.trigrules[trig_n].rules[1].seconds = arg_AirSpawnTime
				-- if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe 1Bc seconds (after) "..tostring(mission.trigrules[trig_n].rules[1].seconds)) end

				-- conditions[44] = 'return(c_time_after(2233.512158504) )',
				mission.trig.conditions[trig_n] = "return(c_time_after(" .. arg_AirSpawnTime .. ") )"
				if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP_modify_Activate_GroupTime() B find groupId "..arg_Group.groupId.." trig_n: "..tostring(trig_n)) end
				found = true
			end
		end
	end

	if not found then
		DebugFLIGHT = DebugFLIGHT .. "\n".." AtoFP_modify_Activate_GroupTime() C ERROR: NO TRIGGER FOUND groupId "..tostring(arg_Group.groupId).." from: "..tostring(from)
	end
end

-- modification M37.l SuperCarrier (l: ajout alt et speed aux unites)(i: option deck air catapult)
--Spawn OnDeck, OnCatapult or OnAir
local function spawnOn(arg_Spawn, arg_Waypoints, arg_Group, arg_Pn, arg_SpawnTime, arg_From, arg_Flight, arg_f, arg_Role)
	arg_Spawn = string.lower(arg_Spawn)

	if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP_spawnOn() A SpawnOn() "..arg_Spawn.." |arg_SpawnTime: "..arg_SpawnTime.." from: "..tostring(arg_From).." Missionfunc: "..tostring(Missionfunc)) end

	-- ATO_FP_Debug_k
	local alt_Role = 0
	if arg_Role == "SEAD" then
		alt_Role = 1
	elseif arg_Role == "Escort" then
		alt_Role = 2
	end

	if arg_Spawn == "air" then
		if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP_spawnOn() B AIR ") end

		if arg_Waypoints[1]["alt"] <= 500 and not is_helicopter then arg_Waypoints[1]["alt"] = 500 end

		local altBase = arg_Waypoints[1]["alt"]
		if db_airbases[arg_Flight[arg_f].base].elevation then
			altBase = db_airbases[arg_Flight[arg_f].base].elevation
		end
		local altStep = 500
		local speed = 200
		if is_helicopter  then
			altStep = 50
			speed = arg_Flight[arg_f].loadout.vCruise / 4 * 3
		end

		if arg_Waypoints[1]["speed"] then
			speed = arg_Waypoints[1]["speed"]
		end

		arg_Waypoints[1]["action"] = "Turning Point"
		arg_Waypoints[1]["type"] = "Turning Point"

		local psi = 0
		local heading = 0

		if arg_Waypoints[2] then
			local dx = arg_Waypoints[2].x - arg_Waypoints[1].x
			local dy = arg_Waypoints[2].y - arg_Waypoints[1].y

			heading = math.atan2(dx, dy)
			psi = -heading
		end

		arg_Waypoints[1]["alt"] = altBase + (arg_Pn * altStep) + (alt_Role * 33)
		arg_Waypoints[1]["speed"] = speed
		-- arg_Waypoints[1]["ETA"] = spawnTime
		arg_Waypoints[1]["ETA"] = arg_SpawnTime

		arg_Group.start_time = arg_SpawnTime

		if arg_Waypoints[1].helipadId then
			arg_Waypoints[1].helipadId = nil
		end
		if arg_Waypoints[1].linkUnit then
			arg_Waypoints[1].linkUnit = nil
		end

		if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP_spawnOn() A SpawnOn() Turning Point "..arg_Spawn.." from: "..tostring(arg_From).." Missionfunc: "..tostring(Missionfunc)) end


		local alt = 150

		if is_helicopter  then 											-- M6.1 sauf helicopter			
			if db_airbases[arg_Flight[arg_f].base].elevation then							--airbase has defined elevation
				alt = alt + db_airbases[arg_Flight[arg_f].base].elevation					--make alt above base
			end
			arg_Waypoints[1]["alt"] = alt  + (arg_Pn * 10) + alt_Role * 33
		end

		-- anti collision entre packages différents
		local spawnHash = math.abs(
			math.floor(arg_Waypoints[1].x / 1000) +
			math.floor(arg_Waypoints[1].y / 1000)
		)

		local spacing = 500 -- Mets ici la distance minimale souhaitée (en mètres)

		local spawnOffsetX = ((spawnHash % 7) - 3) * spacing * 2
		local spawnOffsetY = (((math.floor(spawnHash / 7)) % 7) - 3) * spacing * 2

		
		if is_helicopter then spacing = 100 end

		for	n = 1, #arg_Group.units do

			if arg_Flight[arg_f].task ~= "AFAC" then
				-- arg_Group.units[n].x = ((arg_Pn-1) * spacing) + ((arg_f-1) * spacing) + arg_Group.units[n].x + (spacing * n)	--ANTI-COLLISION A
				-- arg_Group.units[n].y = ((arg_Pn-1) * spacing) + ((arg_f-1) * spacing) + arg_Group.units[n].y + (spacing * n)	--ANTI-COLLISION A
				
				arg_Group.units[n].x = spawnOffsetX +
					((arg_Pn-1) * spacing) +
					((arg_f-1) * spacing) +
					arg_Group.units[n].x +
					(spacing * n)

				arg_Group.units[n].y = spawnOffsetY +
					((arg_Pn-1) * spacing) +
					((arg_f-1) * spacing) +
					arg_Group.units[n].y +
					(spacing * n)
				
				arg_Group.units[n].alt = ((arg_Pn-1) * spacing/1.2) + ((arg_f-1) * spacing) + arg_Waypoints[1]["alt"] + (spacing * n) 		--ANTI-COLLISION A
			end

			arg_Group.units[n].speed = speed
			arg_Group.units[n].psi = psi
			arg_Group.units[n].heading = heading

			if is_helicopter  then
				-- group.units[n]["alt"] = alt  + (Pn * 10) + alt_Role * 11
				arg_Group.units[n].alt = ((arg_Pn-1) * spacing/1.2) + ((arg_f-1) * spacing) + arg_Waypoints[1]["alt"] + (spacing * n) 		--ANTI-COLLISION A
				-- group.units[n]["alt"] = waypoints[1]["alt"]
				arg_Group.units[n].speed = speed
			else
				-- group.units[n]["alt"] = waypoints[1]["alt"] + (Pn * 500) + alt_Role * 33
				-- group.units[n]["alt"] = waypoints[1]["alt"]
			end
		end

		--///---enleve la task demarrage--///---
		--///---enleve la task demarrage--///---
		arg_Group['uncontrolled'] = false
		arg_Group['tasks'] = {}														--supprime le tasks start

		--si le tasks START est supprimé, il faut aussi le supprimer des trigrules &Co
		local found_trigN
		for trig_n = 1, #mission.trigrules do
			if mission.trigrules[trig_n] and mission.trigrules[trig_n].actions and mission.trigrules[trig_n].actions[1] then
				if mission.trigrules[trig_n].actions[1].set_ai_task and mission.trigrules[trig_n].actions[1].set_ai_task[1] and mission.trigrules[trig_n].actions[1].set_ai_task[1] == arg_Group.groupId then
					if mission.trigrules[trig_n].actions[1]["predicate"] == "a_set_ai_task" then

						found_trigN = trig_n
						if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP_spawnOn() C0b supprime start_Set_Ai_Task groupId "..arg_Group.groupId.." trig_n: "..tostring(trig_n)) end
						break


					end
				end
			end
		end

		-- supprime le trigrule start_Set_Ai_Task
		if found_trigN then
			table.remove(mission.trigrules, found_trigN)
			table.remove(mission.trig.flag, found_trigN)
			table.remove(mission.trig.conditions, found_trigN)
			table.remove(mission.trig.actions, found_trigN)
			table.remove(mission.trig.func, found_trigN)

		end
		--///---enleve la task demarrage--///---
		--///---enleve la task demarrage--///---

		if arg_SpawnTime and arg_SpawnTime > 1 and Missionfunc then	--not group["TrigActivate"] and
			if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP_spawnOn() C0  ") end

			arg_Group['lateActivation'] = true											--make group late activation "en vol"

			local activateGroupExist = false
			for n , trigrule in pairs(mission.trigrules) do
				if type(trigrule) == "table" then
					if trigrule.actions and trigrule.actions[1] and trigrule.actions[1].group == arg_Group.groupId then
						if trigrule.actions[1]["predicate"] == "a_activate_group" then

							activateGroupExist = true
							if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP_spawnOn() C1 activateGroupExist ") end
						end
					end
				end
			end

			if not activateGroupExist then
				if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP_spawnOn() C2 activateGroupExist ") end

				arg_Group.start_time = arg_SpawnTime

				local trig_n = #mission.trig.actions + 1
				Missionfunc = Missionfunc + 1
				mission.trig.func[trig_n] = "if mission.trig.conditions[" .. trig_n .. "]() then mission.trig.actions[" .. trig_n .. "]() end"
				mission.trig.flag[trig_n] = true
				mission.trig.conditions[trig_n] = "return(c_time_after(" .. arg_SpawnTime .. ") )"
				mission.trig.actions[trig_n] = "a_activate_group(" .. arg_Group.groupId .. "); mission.trig.func[" .. trig_n .. "]=nil;"	-- ATO_FP_Debug02 Interceptor error nb trigger
				mission.trigrules[trig_n] = {
					['rules'] = {
						[1] = {
							["seconds"] = arg_SpawnTime,
							["predicate"] = "c_time_after",
						},
					},
					['eventlist'] = '',
					['comment'] = 'Trigger ' .. trig_n,
					['predicate'] = 'triggerOnce',
					['actions'] = {
						[1] = {
							["group"] = arg_Group.groupId,
							["predicate"] = "a_activate_group",
						},
					}
				}

			end
		end

		-- remet l'horaire d'origine sur activate
		local passModified = true
		if mission.trigrules and mission.trigrules[trig_n] and mission.trigrules[trig_n].rules and mission.trigrules[trig_n].rules[1] then
			if mission.trigrules[trig_n].rules[1].flag then
				passModified = false
			end
		end
		if passModified then
			modify_Activate_GroupTime(arg_Group, arg_SpawnTime, debug.getinfo(1).currentline)
		end

		--supprime les avions initialement prévu sur le pont, puisque maintenant, ils spawnent en vol
		if testDeckPlace and testDeckPlace[arg_Flight[arg_f].base] then
			local deckList = testDeckPlace[arg_Flight[arg_f].base]
			if deckList then
				for i = #deckList, 1, -1 do
					if deckList[i].groupName == arg_Flight[arg_f].name then
						if debugStart then
							debugTxt_AtoFP = debugTxt_AtoFP .. "\n" .. ("AtoFP RemovetestDeckPlace i " .. tostring(i) .. " " .. tostring(deckList[i].groupName))
						end
						table.remove(deckList, i)
					end
				end
			end
		end

		if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP_spawnOn(AIR) arg_Group.uncontrolled "..tostring(arg_Group.uncontrolled)) end


	elseif arg_Spawn == "catapult" then

		if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP_spawnOn() CATAPULT D ") end

		arg_Waypoints[1]["action"] = "From Runway"
		arg_Waypoints[1]["type"] = "TakeOff"
		arg_Waypoints[1]["alt"] = 0
		arg_Group.uncontrolled = false											-- sur cata, les F14 IA bloquent
	end

end


--activate_group_withFlag
local function activate_Group_WithFlag(group, flag, from)

	if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP_activate_Group_WithFlag() passe A  "..tostring(flag).." from: "..tostring(from)) end

	group['uncontrolled'] = false
	group['lateActivation'] = true

	local trig_n =  #mission.trig.actions + 1
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
local function activate_group_time_after(group, airSpawnTime, from)

	--ça tombe bien, on ne fait pas sur le sixpack
	group['lateActivation'] = true --incompatible avec l'activation sur sixpack
	
	if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe 1B activate_group_time_after |lateActivation| "..tostring(group['lateActivation']).."|"..tostring(from)) end

	local trig_n =  #mission.trig.actions + 1
	Missionfunc = Missionfunc + 1
	mission.trig.func[trig_n] = "if mission.trig.conditions[" .. trig_n .. "]() then mission.trig.actions[" .. trig_n .. "]() end"
	mission.trig.flag[trig_n] = true
	mission.trig.conditions[trig_n] = "return(c_time_after(" .. airSpawnTime .. ") )"
	mission.trig.actions[trig_n] = "a_activate_group(" .. group.groupId .. "); mission.trig.func[" .. trig_n .. "]=nil;"
	mission.trigrules[trig_n] = {
		['rules'] = {
			[1] = {
				["seconds"] = airSpawnTime,
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
end

--start_set_ai_task
local function start_Set_Ai_Task(arg_group, aiStart_Time, flag, from)

	arg_group['uncontrolled'] = true

	if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP tasks_Start start_set_ai_task uncontrolled|"..tostring(arg_group['uncontrolled']).."|"..tostring(from)) end

	if flag then
		if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("c_flag_is_true|"..tostring(flag)) end
	else
		if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("c_time_after|"..tostring(aiStart_Time)) end
	end

	-- local trig_n = Missionfunc + #mission.trig.funcStartup + 1										--next available trigger number
	local trig_n = #mission.trig.actions + 1
	Missionfunc = Missionfunc + 1
	mission.trig.func[trig_n] = "if mission.trig.conditions[" .. trig_n .. "]() then mission.trig.actions[" .. trig_n .. "]() end"
	mission.trig.flag[trig_n] = true
	if aiStart_Time then
		mission.trig.conditions[trig_n] = "return(c_time_after(" .. aiStart_Time .. ") )"
	elseif flag then
		mission.trig.conditions[trig_n] = "return(c_flag_is_true(" .. GCI.Flag .. ") )"
	end
	mission.trig.actions[trig_n] = "a_set_ai_task(" .. arg_group.groupId .. ", 1); mission.trig.func[" .. trig_n .. "]=nil;"
	mission.trigrules[trig_n] = {
		-- ['rules'] = {
		-- 	[1] = {
		-- 		["seconds"] = aiStart_Time,
		-- 		["predicate"] = "c_time_after",
		-- 		["zone"] = "",
		-- 	},
		-- },
		['eventlist'] = '',
		['comment'] = 'Trigger_' .. arg_group.name,
		['predicate'] = 'triggerOnce',
		['actions'] = {
			[1] = {
				["predicate"] = "a_set_ai_task",
				["set_ai_task"] = {
					[1] = arg_group.groupId,
					[2] = 1,
				}
			},
		},
	}
	if aiStart_Time then
		mission.trigrules[trig_n]['rules'] = {
			[1] = {
				["seconds"] = aiStart_Time,
				["predicate"] = "c_time_after",
				-- ["zone"] = "",
			}
		}
	elseif flag then
		mission.trigrules[trig_n]['rules'] = {
			[1] = {
				["flag"] = GCI.Flag,
				["predicate"] = "c_flag_is_true",
				-- ["zone"] = "",
			}
		}
	end
	--triggered action to start uncontrolled group
	arg_group['tasks'] = {
		[1] = {
			["number"] = 1,
			["name"] = arg_group.name,
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


local function createBombingChapter(arg_idTask, arg_Flight, arg_Wpt, arg_WeaponType, arg_AttackType, arg_AttackAlt, arg_Element, arg_From, arg_TypeCible )

	if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe function createBombingChapter id_task:  "..tostring(arg_idTask).." |element.name: "..tostring(arg_Element.name).." |from: "..tostring(arg_From)) end

	local stopLoop = false
	-- cherche xy des elements dans la table oob_ground s'ils n'existent pas dans la table targetlist
	if (arg_idTask == "AttackUnit" or arg_idTask == "Bombing" or arg_idTask == "AttackMapObject") and arg_Element ~= nil then
		if not (arg_Flight.target.elements) or not (arg_Element) or not( arg_Element.x) then

			-- print("AtoFP PASSE A not elements xy  "..tostring(flight.target_name).." || "..tostring(element.name))

			for sideName, oob in pairs(oob_ground) do
				for country_n, country in pairs(oob_ground[sideName]) do						--iterate through countries
					if country.static then
						for group_n, group in pairs(country.static.group) do				--iterate through groups in country.static.group table
							for unit_n, unit in pairs(group.units) do									--Iterate through elements of target						
								if unit.name == arg_Flight.target_name or unit.name == arg_Element.name then
									arg_Element.x = unit.x
									arg_Element.y = unit.y
									print("AtoFP passe XD find target "..tostring(group.name))
									stopLoop = true
								elseif  group.name == arg_Flight.target_name or group.name == arg_Element.name then
									arg_Element.x = unit.x
									arg_Element.y = unit.y
									print("AtoFP passe ZD find target "..tostring(group.name))
									stopLoop = true
								end
								if stopLoop then break end
							end
							if stopLoop then break end
						end
						if stopLoop then break end
					end
					if country.vehicle then
						for group_n, group in pairs(country.vehicle.group) do				--iterate through groups in country.static.group table
							for unit_n, unit in pairs(group.units) do									--Iterate through elements of target						
								-- print("AtoFP passe ZC_b group.name "..tostring(group.name).." || "..tostring(arg_Flight.target.name))

								-- if group.name == unit.name then
								if unit.name == arg_Flight.target_name or unit.name == arg_Element.name then
									arg_Element.x = unit.x
									arg_Element.y = unit.y
									-- print("AtoFP passe ZD find target "..tostring(group.name))
									stopLoop = true
								elseif  group.name == arg_Flight.target_name or group.name == arg_Element.name then
									arg_Element.x = unit.x
									arg_Element.y = unit.y
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

	local taskEnable = false
	if arg_Flight.player or arg_Flight.client then
		taskEnable = true
	end

	local task_entry = {}

	if arg_idTask == "AttackGroup" then
		-- print("AtoFP CBC passe M AttackGroup ")
		task_entry = {
			["enabled"] = taskEnable,
			["auto"] = false,
			["id"] = arg_idTask,
			["number"] = #arg_Wpt["task"]["params"]["tasks"] + 1,
			["params"] =
			{
				["groupId"] = arg_Flight.target.groupId,
				["weaponType"] = arg_WeaponType,
				["expend"] = arg_Flight.loadout.expend,
				["attackType"] = arg_Flight.loadout.attackType,
			}
		}
	elseif arg_idTask == "AttackUnit"  then
		-- print("AtoFP CBC passe N AttackUnit ")
		task_entry = {
			["enabled"] = taskEnable,
			["auto"] = false,
			["id"] = "AttackUnit",
			["number"] = #arg_Wpt["task"]["params"]["tasks"] + 1,
			["params"] = {
				["x"] = arg_Element.x,
				["y"] = arg_Element.y,
				["unitId"] = arg_Element.unitId,
				["expend"] = arg_Flight.loadout.expend,
				["weaponType"] = arg_WeaponType,
				["groupAttack"] = false,
				["attackType"] = arg_AttackType,
				["attackQtyLimit"] = true,
				["attackQty"] = 1,
				["altitudeEdited"] = true,
				["altitudeEnabled"] = true,
				["altitude"] = arg_AttackAlt,
				["directionEnabled"] = false,
				["direction"] = 0,
			},
		}
	elseif arg_idTask == "Bombing"  then
		if not arg_Element.x then
			DebugFLIGHT = DebugFLIGHT .. "\n"..("AtoFp (arg_idTask == Bombing) noX "..arg_Element.name.." |from| "..tostring(arg_From))
		end

		task_entry = {									--define attack task
			["enabled"] = taskEnable,
			["auto"] = false,
			["id"] = "Bombing",
			["number"] = #arg_Wpt["task"]["params"]["tasks"] + 1,
			["params"] = {
				["x"] = arg_Element.x,
				["y"] = arg_Element.y,
				["expend"] = arg_Flight.loadout.expend,
				["weaponType"] = arg_WeaponType,
				["groupAttack"] = false,
				["attackType"] = arg_AttackType,
				["attackQtyLimit"] = true,
				["attackQty"] = 1,
				["altitudeEdited"] = true,
				["altitudeEnabled"] = true,
				["altitude"] = arg_AttackAlt,
				["directionEnabled"] = false,
				["direction"] = 0,
			},
		}
	elseif arg_idTask == "AttackMapObject"  then
		task_entry = {
			["enabled"] = taskEnable,
			["auto"] = false,
			["id"] = "AttackMapObject",
			["number"] = #arg_Wpt["task"]["params"]["tasks"] + 1,
			["params"] = {
				["x"] = arg_Element.x,
				["y"] = arg_Element.y,
				["weaponType"] = arg_WeaponType,
				["expend"] = arg_Flight.loadout.expend,
				["direction"] = 0,
				["attackQtyLimit"] = false,
				["attackQty"] = 1,
				["directionEnabled"] = false,
				["groupAttack"] = true,
				["altitude"] = 2000,
				["altitudeEnabled"] = false,
			},
		}
	elseif arg_idTask == ""  then
		DebugFLIGHT = DebugFLIGHT .. "\n"..("AtoFp no id_task from "..tostring(arg_From))
	end

	return task_entry
end



Missionfunc = 0														--remplace #mission.trig.func qui ne commence plus à 0, donc impossible avec #

-- Cherche le nb d'avion dans le package joueur
for sideName, pack in pairs(ATO) do
	for p = 1, #pack do
		if camp.player and camp.player.side == sideName and camp.player.pack_n == p then
			for _, flight in pairs(pack[p]) do
				for f = 1, #flight do
					if flight[f].player then
						basePlayer = flight[f].base
					end

					for _, flight2 in pairs(pack[p]) do							-- calcul le nombre de flight dans un Package, en comptant ceux des Roles																									
						for x = 1, #flight2 do
							if flight2[x].player then
								-- nbFlightPlayer = #flight2
								cv_nbPlanetDeck = flight2[x].number
							elseif flight2[x].client then
								-- nbFlightPlayer = #flight2
								cv_nbPlanetDeck = flight2[x].number
							end
						end
					end
				end
			end

			for _, flight in pairs(pack[p]) do
				for f = 1, #flight do
					if flight[f].base == basePlayer then
						nbFlightPackage = nbFlightPackage + 1
					end
				end
			end
		end
	end
end

-- Ajoute un message à envoyer à un groupe à un moment donné
local function addMessageForGroup(groupName, time, message)

    if not MsgForPlayerInMsn[time] then
        MsgForPlayerInMsn[time] = {}
    end

    if not MsgForPlayerInMsn[time][groupName] then
        MsgForPlayerInMsn[time][groupName] = {}
    end

    table.insert(MsgForPlayerInMsn[time][groupName], message)

end

local function isTimeFree(baseName, startTime, endTime)

	for _, r in ipairs(cv_deckReservations[baseName]) do

		if startTime < r.finish and endTime > r.start then
			return false
		end

	end

	return true
end

local function findDeckSlot(baseName, duration)

	local startTime = 420

	while true do

		local endTime = startTime + duration

		if isTimeFree(baseName, startTime, endTime) then
			return startTime
		end

		startTime = startTime + 10

	end

end

-- trouve le nombre d'avion du package du joueur, sur PA
-- seulement utilisé pour une 
local carrierPlayer = {
	carrierName = nil,
	pack_PlaneNumber = 0,
	packN = 0,
	playerRole = nil,
	sideName = ""
}
for baseName, base in pairs(db_airbases) do
	-- print("AtoFP cherche carrierPlayer.carrierName: "..tostring(baseName))
	if base.humainSquad and base.unitname then
		carrierPlayer.carrierName = baseName
		-- print("AtoFP trouve carrierPlayer.carrierName: "..tostring(carrierPlayer.carrierName))
		break
	end
end
if carrierPlayer.carrierName then
	for sideName, packs in pairs(ATO) do
		for packN, pack in pairs(packs) do

			for role, flights in pairs(pack) do
				for f, flight in pairs(flights) do
					if flight.base == carrierPlayer.carrierName then
						carrierPlayer.sideName = sideName
						carrierPlayer.pack_PlaneNumber = carrierPlayer.pack_PlaneNumber + flight.number
					end
					if flight.player then 
						carrierPlayer.playerRole = role 
						carrierPlayer.packN = packN

						--reserve le timing de taxiage sur le deck
						local placeTiming = 100 * flight.number
						placeTiming = placeTiming + mission_ini.startup_time_player 
						cv_deckReservations[flight.base] = cv_deckReservations[flight.base] or {}

						local taxiTimePerPlane = 75
						if string.find(flight.type, "F-14") then taxiTimePerPlane = 110 end
						local duration = flight.number * taxiTimePerPlane

						table.insert(cv_deckReservations[flight.base],{
							start = mission_ini.startup_time_player,
							finish = mission_ini.startup_time_player + duration,
							groupName = "Player"
						})

					end
				end
			end

		end
	end
end

-- _affiche(carrierPlayer, "carrierPlayer: ")


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

		parkSarAirBase[baseName] = base.parkAlertSAR

		for parkN, park in pairs(parkSarAirBase[baseName]) do
			park.occupied = false
			park.reservedSAR = false
		end
	end
end

if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP parkSarAirBase RESET ").._afficheTXT(parkSarAirBase) end

-- if db_airbases[flight[f].base].parkAlertSAR and IsHelicopter[flight[f].type] then

-- 	--combien de place libre reste t'il:
-- 	local freeParkSpace = 0 
-- 	for baseN, park in pairs(arkSarAirBase[flight[f].base]) do
-- 		if (not park.occupied or park.occupied == nil) and not park.reservedSAR then
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
					if parkSarAirBase[flight[f].base] then
						for n=1, flight[f].number do
							for parkN, park in pairs(parkSarAirBase[flight[f].base]) do
								if not park.reservedSAR or park.reservedSAR == nil then
									park.reservedSAR = true
									flight[f]["reservedSAR"] = true
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

-- _affiche(parkSarAirBase, "parkSarAirBase: ")

if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP parkSarAirBase 00 ").._afficheTXT(parkSarAirBase) end


-- garde en mémoire les targets pour eviter de les pruner plus tard
for side, pack in pairs(ATO) do
	for p = 1, #pack do
		for role, flight in pairs(pack[p]) do
			for f = 1, #flight do
				if flight[f].target then

					if flight[f].target.x and flight[f].target.task and flight[f].target.task == "Strike" then
						PointOfInterest[flight[f].target.titleName] = {x=flight[f].target.x,y=flight[f].target.y}
					end

					if flight[f].target.elements then
						for elementN, element in ipairs(flight[f].target.elements) do
							TargetList_InThisMission[element.name] = true

						end
					end
				end

				if flight[f].client or flight[f].player and db_airbases[flight[f].base].x then
					PointOfInterest[flight[f].base] = {x=db_airbases[flight[f].base].x,y=db_airbases[flight[f].base].y}
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
-- chapitre ATO
--= = = = = = = =  = = = = = = = = = =  = = = = = = = = = =  ==  = = = 


for sideName, pack in pairs(ATO) do													--iterate through sides in ATO


	if campMod.movedBullseye[nameTheatre] or mission_ini.movedBullseye == false then
		mission.coalition[sideName].bullseye, Brief[sideName].bullseye = fct_movedBullseye(sideName, nameTheatre)
	end

	for p = 1, #pack do															--iterate through packages in sides		
		local pn = 1															--variable to count flights in package	
		for role, flight in pairs(pack[p]) do									--iterate through roles in package (main, SEAD, escort)		
			for f = 1, #flight do												--iterate through flights in roles

				local farp_MorePlace = false
				local infoFlight = ""
				local totFlightDist = 0
				local isHumain = flight[f].player or flight[f].client
				local groupName = flight[f].groupName
				local start_time = 1

				-- inheritedFrom 
				local type_withData = flight[f].type
				local type_withProp = flight[f].type
				if Data_divers[flight[f].type] and Data_divers[flight[f].type].inheritedFrom then
					type_withData = Data_divers[flight[f].type].inheritedFrom
				end
				if Data_divers[flight[f].type] and Data_divers[flight[f].type].inherited_APA_From then
					type_withProp = Data_divers[flight[f].type].inherited_APA_From
				end

				if isHumain	then
					playerTask = flight[f].task
				end

				baseIsFARP = string.match(flight[f].base, "FARP") ~= nil

				if db_airbases[flight[f].base].unitname or string.match(flight[f].base, "CV") or string.match(flight[f].base, "LHA") then
					baseIsCarrier = true
				else
					baseIsCarrier = false
				end

				if baseIsFARP then
					if db_airbases[flight[f].base].parkAlertSAR and #db_airbases[flight[f].base].parkAlertSAR >= 2  then
						farp_MorePlace = true
					end
				end

				--requiredModules
				if Data_divers[flight[f].type] and Data_divers[flight[f].type].requiredModules then

					local nameOfModule = flight[f].type
					if Data_divers[flight[f].type].moduleName then
						nameOfModule = Data_divers[flight[f].type].moduleName
					end

					local entry = {
						["name"] = tostring(nameOfModule),
						["origine"] = {
							"Data_divers: "..nameOfModule,
						}
					}

					-- local typeNameRequire = flight[f].type
					if Data_divers[flight[f].type].moduleName then
						nameOfModule = Data_divers[flight[f].type].moduleName
					end

					if ListRequiredModules[nameOfModule] then
						local alreadyInside = false
						for n, from in pairs(ListRequiredModules[nameOfModule].origine) do
							if from == "Data_divers: "..nameOfModule then
								alreadyInside = true
								break
							end
						end
						if not alreadyInside then
							table.insert(ListRequiredModules[nameOfModule].origine, "Data_divers: "..nameOfModule )
						end
					else
						ListRequiredModules[nameOfModule] = entry
					end
				end


				-- modification M18.c despawn/destroy Plane on BaseAirStart
				if db_airbases[flight[f].base].BaseAirStart then
					if not tempBaseAirStart[flight[f].base] then
						tempBaseAirStart[flight[f].base] = db_airbases[flight[f].base]
					end
				end

				local limitedParkTiming = false

				--TabLPark[flight[f].base][NbPlaneTot] --NbPlaneTot sera utilisé pour ajouter des avions static sur les emplacements parking jamais utilisé
				if not TabLPark[flight[f].base] then
					TabLPark[flight[f].base] = {
						minuteTable = {},
						NbPlaneTot = 0,
					}
				end

				--M03.k : (k: best check) (j: check place parking dispo en fonction des minutes)(i: Parking limite little base)			
				local timmingParking = math.floor(flight[f].route[1].eta / 60 )

				--TODO est ce utile?
				if not db_airbases[flight[f].base].LimitedParkNb then
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


				-- limitedParkTiming  limite par timming l'apparition des avions


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

				if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passeparkSarAirBase 0a "..tostring(flight[f].route[1].id).." "..tostring(debug.getinfo(1).currentline)) end

				if (flight[f].route[1].id ~= "Spawn" and flight[f].route[1].eta and flight[f].route[2]) or (flight[f].route[1].id ~= "Spawn" and flight[f].route[1].eta and not baseIsCarrier) then

					if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passeparkSarAirBase 0b ") end


					for mn = -mn_StartParking, timmingParking  do
						if not TabLPark[flight[f].base]["minuteTable"][mn] then TabLPark[flight[f].base]["minuteTable"][mn] = 0 end

						if flight[f].task == "SAR" and flight[f].reservedSAR then

						else
							-- if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passeparkSarAirBase A1 ") end
							--s'il n'y a plus de place, on le dit (limitedParkTiming) et on arrete de compter
							if db_airbases[flight[f].base].LimitedParkNb and TabLPark[flight[f].base]["minuteTable"][mn] + flight[f].number > db_airbases[flight[f].base].LimitedParkNb then
								limitedParkTiming = true
								-- if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe LimitedParkNb A2 "..tostring(db_airbases[flight[f].base].LimitedParkNb) ) end
								break
							else
								-- if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passeparkSarAirBase A3 ") end
								--si il reste de la place, on ajoute la somme 
								TabLPark[flight[f].base]["minuteTable"][mn] = TabLPark[flight[f].base]["minuteTable"][mn] + flight[f].number
							end
						end
					end

					--NbPlaneTot sera utilisé pour ajouter des avions static sur les emplacements parking jamais utilisé
					for mn, value in pairs(TabLPark[flight[f].base]["minuteTable"]) do
						if TabLPark[flight[f].base]["NbPlaneTot"] < value then
							TabLPark[flight[f].base]["NbPlaneTot"] = value
						end
					end

					--existe déjà avec ça : local function getParkSarAirBase(flightF)


					-- if limitedParkTiming then
					-- 	if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passeparkSarAirBase B1 ") end

					-- 	if db_airbases[flight[f].base].parkAlertSAR and IsHelicopter[flight[f].type] then

					-- 		if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passeparkSarAirBase B2 ") end

					-- 		--combien de place libre reste t'il:
					-- 		local freeParkSpace = 0
					-- 		for baseN, park in pairs(parkSarAirBase[flight[f].base]) do
					-- 			if (not park.occupied or park.occupied == nil) and not park.reservedSAR then
					-- 				freeParkSpace = freeParkSpace + 1
					-- 			end
					-- 		end

					-- 		if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passeparkSarAirBase B3 "..tostring(freeParkSpace).." "..tostring(debug.getinfo(1).currentline)) end

					-- 		if freeParkSpace >= flight[f].number then
					-- 			--il y a donc de la place sur les parking SAR (arkSarAirBase), on enleve donc la limite limitedParkTiming
					-- 			limitedParkTiming = false
					-- 			if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe LimitedParkNb B4 "..tostring(db_airbases[flight[f].base].LimitedParkNb) ) end

					-- 			--TODO enlever ceci: ai décollage
					-- 			-- ["helipadId"] = 1665,
					-- 			-- ["linkUnit"] = 1665,

					-- 			for n = 1, flight[f].number do

					-- 				for baseN, park in pairs(parkSarAirBase[flight[f].base]) do
					-- 					if (not park.occupied or park.occupied == nil) and not park.reservedSAR then
					-- 						park.occupied = true
					-- 						if not parkSarAirBase[flight[f].base] then parkSarAirBase[flight[f].base] = {} end
					-- 						parkSarAirBase[flight[f].base][n] = park

					-- 						if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passeparkSarAirBase B5 "..tostring(parkSarAirBase[flight[f].base]).." "..tostring(debug.getinfo(1).currentline)) end

					-- 						break
					-- 					end
					-- 				end
					-- 			end
					-- 		end
					-- 	end
					-- end
				end

				local navTargetPoints = {}
				local flagPoints = {}

				pn = pn + 1														--count flights in package

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

				local goupTaskTemp = flight[f].task

				if flight[f].task == "Strike" then												--Strike is a generic A-G task that needs to be replaced by the respective DCS task
					if flight[f].loadout.weaponType == "ASM"  then
						goupTaskTemp = "Ground Attack"
					elseif flight[f].target.class == nil or  flight[f].target.class == "vehicle" or  flight[f].target.class == "static" or  flight[f].target.class == "airbase" then
						goupTaskTemp = "Ground Attack"
					-- elseif flight[f].target.class == "vehicle" then
					-- 	GoupTaskTemp = "CAS"
					-- elseif flight[f].target.class == "static" then
					-- 	GoupTaskTemp = "CAS"
					-- elseif flight[f].target.class == "airbase" then
						-- GoupTaskTemp = "CAS"
					end
				elseif flight[f].task == "Escort Jammer" then									--Escort Jammer task does not exitsts in DCS and needs to be replaced
					goupTaskTemp = "Ground Attack"
				elseif flight[f].task == "Flare Illumination" then								--Flare illumination task does not exist in DCS and needs to be replaced
					goupTaskTemp = "Ground Attack"
				elseif flight[f].task == "Laser Illumination" then								--Laser illumination task does not exist in DCS and needs to be replaced
					goupTaskTemp = "AFAC"
				elseif flight[f].task == "AFAC" then
					goupTaskTemp = "AFAC"
				elseif flight[f].task == "Anti-ship Strike" then
					goupTaskTemp = "Antiship Strike"											-- Miguel debugB 
				elseif flight[f].task == "SAR" or flight[f].task == "CSAR"  then
					goupTaskTemp = "Transport"													-- Miguel debugB 
				elseif flight[f].task == "Runway Attack"  then
					goupTaskTemp = "Runway Attack"
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
				local id_task = ""
				if not TaskByPlane[goupTaskTemp][flight[f].type] or not GoupTaskByTypeTarget[typeCible][goupTaskTemp]  then

					local txt = "AtoFP if not TaskByPlane[GoupTaskTemp][flight[f].type]  "..tostring(goupTaskTemp).." type: "..tostring(flight[f].type)
					AddLog(txt)

					goodTask = false

					--iteration de la table avion/task possible
					for groupTaskTemp, plane in pairs(TaskByPlane) do
						for type_, value in pairs(plane) do
							if type_ == flight[f].type then
								--iteration de la table id/task possible
								for task_, idStrike in pairs(GoupTaskByTypeTarget[typeCible]) do
									if groupTaskTemp == task_ then
										for idStrike_, value2 in pairs(idStrike) do
											if idStrike_ and idStrike_ ~= nil then
												if flight[f].task == "Strike" or flight[f].task == "Anti-ship Strike" then
													if task_ == "Antiship Strike" and goupTaskTemp == "Ship" then
														-- print("AtoFP  GoupTaskTemp avant "..tostring(GoupTaskTemp))

														id_task = idStrike_
														goupTaskTemp = task_

														goodTask = true
														breakloop = true
														break

													elseif task_ == "Runway Attack" and goupTaskTemp == "Runway Attack" then
														-- print("AtoFP  GoupTaskTemp avant "..tostring(GoupTaskTemp))

														id_task = idStrike_
														goupTaskTemp = task_

														goodTask = true
														breakloop = true
														break
													elseif not (task_ == "Runway Attack" or  task_ == "Antiship Strike" )then
														id_task = idStrike_
														goupTaskTemp = task_

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
								if GoupTask[goupTaskTemp] and  GoupTask[goupTaskTemp][idStrike_] then

									id_task = idStrike_

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
					end
				end


				--teste_ =======================================================================

				--n'a pas trouvé de task correspondant à l'avion et au type de cible
				--on passe donc en mode dégradé
				if not goodTask then
					if goupTaskTemp ~= "Runway Attack" then
						print("(downgraded mode  : don t found task |"..flight[f].task.."| of the |"..flight[f].type.. " |in the oob_air_init.lua file")
						print("typeCible |"..typeCible.."| |"..flight[f].type.."| |"..goupTaskTemp.."| |"..tostring(flight[f].target.name))
					end

					if TaskByPlane["Ground Attack"][flight[f].type]   then
						goupTaskTemp = "Ground Attack"
						id_task = "Bombing"
						goodTask = true
					else
						for GoupTaskTemp_, plane in pairs(TaskByPlane) do
							for type_, value in pairs(plane) do
								if type_ == flight[f].type then
									if GoupTaskTemp_ == "CAS" or GoupTaskTemp_ == "Pinpoint Strike" or  GoupTaskTemp_ == "Antiship Strike"  or GoupTaskTemp_ == "Runway Attack" then
										goupTaskTemp = GoupTaskTemp_
										id_task = "Bombing"
										for id_task_ , value2 in pairs(StrikeDegradedMode[goupTaskTemp]) do
											id_task = id_task_
											goodTask = true
										end
										break
									end
								end
							end
						end
					end
				end

				if not goodTask then
					DebugFLIGHT = DebugFLIGHT .. "\n".."(Error AtoFp 11  : bad task: remove |"..flight[f].task.."| of the |"..flight[f].type.. "| in the oob_air_init.lua file"
					DebugFLIGHT = DebugFLIGHT .. "\n"..("typeCible "..typeCible.." || "..flight[f].type.." "..goupTaskTemp.." "..tostring(flight[f].target.name))
				end




				------========================-----========================--
				---========================-----========================--
				----- define waypoints -----
                ------========================-----========================--
				---
				--- ------========================-----========================--
				--- -- chapitre waypoints
				--- 
				start_time = flight[f].route[1].eta
				local departure_time											--local variable to store departure time
				local waypoints = {}											--define waypoints of flight
				local wptTargetPass = false										--detecte le passage du wpt Target
				local alreadyTreated

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
					-- else
					-- 	if flight[f].route[w].alt < 500 then
					-- 		atlTemp = 1000
					-- 	end
					end

					local speed = 0
					if flight[f].route[w] and not flight[f].route[w].speed then
						-- if Debug.debug then
						-- 	InsertBugList("this flight have not a speed variable: "..flight[f].name)
						-- end
						if Data_divers[flight[f].type] and Data_divers[flight[f].type].vCruise then
							speed = Data_divers[flight[f].type].vCruise

						else
							speed = pack[p].main[1].loadout.vCruise
							if Debug.debug then
								-- AddLog("this flight have not a speed Data_divers.vCruise: "..flight[f].name.." |type: "..flight[f].type)
							end
						end

					else
						speed = flight[f].route[w].speed
					end

					waypoints[w] = {

						["name"] = flight[f].route[w].id,
						["briefing_name"] = flight[f].route[w].id,				--not needed for actual mission creation, but added for navigation overview in briefing
						["alt"] = atlTemp,
						["type"] = "Turning Point",
						["action"] =  "Turning Point",
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
						["ETA_locked"] = true,
						["task"] =
						{
							["id"] = "ComboTask",
							["params"] =
							{
								["tasks"] = {}
							},
						},
						["speed_locked"] =  false,
						["etaSpawn"] =  flight[f].route[w].etaSpawn,
						["baseStartup"] =  flight[f].route[w].baseStartup,
					}

					if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP_waypoints[w] = { Turning Point ") end


					if waypoints[w].name == "Target" then
						wptTargetPass = true
					end

					if w == 1 and (flight[f].task == "Intercept" or flight[f].task == "SAR") then
						-- speed = 300
						speed = flight[f].loadout.vAttack or Data_divers[flight[f].type].vAttack or 340
						if flight[f].task == "SAR" then
							speed = flight[f].loadout.vCruise or Data_divers[flight[f].type].vCruise or 50
						end

						waypoints[1]["speed"] = speed

						waypoints[2] = {
							-- ["name"] = flight[f].route[w].id,
							-- ["briefing_name"] = flight[f].route[w].id,				--not needed for actual mission creation, but added for navigation overview in briefing
							["alt"] = atlTemp,
							type = "Turning Point",
							["action"] =  "Turning Point",
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
							["ETA"] = flight[f].route[w].eta + 10,
							["y"] = flight[f].route[w].y + 1000,
							["x"] = flight[f].route[w].x + 1000,
							["speed"] = speed,
							["ETA_locked"] = false,
							["task"] =
							{
								["id"] = "ComboTask",
								["params"] =
								{
									["tasks"] = {}
								},
							},
							["speed_locked"] =  true,
						}
						if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP_Intercept or SAR = { Turning Point ") end
					end

					-- modification M17.e
					if flight[f]["type"] == "F-14B" and ( flight[f].player or  flight[f].client) then		-- and TargetPointF14 --or Multi.NbGroup >= 1 
						if  flight[f].route[w].id == "Target" or flight[f].route[w].id == "Attack" and not flagPoints["ST"] then

							local tempNTP = {
								text_comment = "ST",
								x = flight[f].route[w].x,
								y = flight[f].route[w].y,
							}

							table.insert(navTargetPoints, tempNTP)
							navTargetPoints[#navTargetPoints]["index"] = #navTargetPoints
							flagPoints["ST"] = true

						elseif flight[f].route[w].id == "IP" and not flagPoints["IP"] then

							local tempNTP = {
								text_comment = "IP",
								x = flight[f].route[w].x,
								y = flight[f].route[w].y,
							}
							table.insert(navTargetPoints, tempNTP)
							navTargetPoints[#navTargetPoints]["index"] = #navTargetPoints

							flagPoints["IP"] = true

						elseif flight[f].route[w].id == "Station" and not flagPoints["DP"] then --and not flagPoints["DP"]

							local tempNTP = {
								text_comment = "DP",
								x = flight[f].route[w].x,
								y = flight[f].route[w].y,
							}
							table.insert(navTargetPoints, tempNTP)
							navTargetPoints[#navTargetPoints]["index"] = #navTargetPoints
							flagPoints["DP"] = true
						end

						if not flagPoints["FP"] then

							local tempNTP = {
								text_comment = "FP",
								x = flight[f].route[w].x,
								y = flight[f].route[w].y,
							}
							table.insert(navTargetPoints, tempNTP)
							navTargetPoints[#navTargetPoints]["index"] = #navTargetPoints
							flagPoints["FP"] = true

						end

					end

					-- ************* store spawn and departure time for flight *************
					if flight[f].route[w].id == "Taxi" or flight[f].route[w].id == "Spawn" then --or flight[f].route[w].id == "SAR"
						start_time = flight[f].route[w].eta
						debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP Taxi or Spawn and SAR or set departure_time " .. tostring(start_time) )

					elseif flight[f].route[w].id == "Departure" then
						departure_time = flight[f].route[w].eta
					end

					if flight[f].route[w].id == "Join" then
						waypoints[w]["hCruiseREF"] = flight[f].route[w].hCruiseREF
						waypoints[w]["test"] = flight[f].route[w].test
					end

					if isHumain then

						start_time = 0

						if flight[f].route[w].id == "Taxi" or flight[f].route[w].id == "Spawn" then
							flight[f].route[w].eta = 0
						end
					end


					-- ************* alter departure alt (spawn and orbit) to prevent collisions of multiple packages *************
					if flight[f].route[w].id == "Departure" and flight[f].route[w - 1] then	--and flight[f].route[w].id == "Spawn"							--for departure waypoints that come after spwn waypoints
						waypoints[w].alt = waypoints[w - 1]["alt"]																						--use same altitude as departure as for spawn

					elseif w < #flight[f].route then

						if flight[f].route[w + 1] == nil then
							print("AtoFp #flight[f].route "..#flight[f].route.." w: "..w.." type: "..flight[f].type.." task: "..flight[f].task)
							_affiche(flight[f].route, "Atofp ")
						end

						if flight[f].route[w].id == "Departure" or (flight[f].route[w].id == "Spawn" and flight[f].route[w + 1].id == "Departure") then		--for departure waypoint or spawn before departure waypoint

							debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP Departure or (Spawn and Departure ) set Altitude " )

							local alt = 609.6														--initial departure alt to try: 2'000 ft
							if is_helicopter  then 											-- M6.1 sauf helicopter
								alt = 50
							end
							if db_airbases[flight[f].base].elevation then							--airbase has defined elevation
								alt = alt + db_airbases[flight[f].base].elevation					--make alt above base
							end
							if departureOrbitAlt[flight[f].base] == nil then						--airbase has no departure altitute entries yet
								departureOrbitAlt[flight[f].base] = {								--make base table
									[alt] = {														--make altitude table
										[1] = waypoints[w]["ETA"],									--store time of departure
									}
								}
								waypoints[w].alt = alt											--set departure altitude
							else																	--airbase has departure altitute entries
								local departureAlt
								repeat
									if departureOrbitAlt[flight[f].base][alt] == nil then			--no altitude entries yet			
										departureOrbitAlt[flight[f].base][alt] = {					--make altitude table
											[1] = waypoints[w]["ETA"],								--store time of departure
										}
										departureAlt = alt											--set departure altitude
									else															--there are already altitude entries for this airbase
										for a = 1, #departureOrbitAlt[flight[f].base][alt] do		--iterate through all entries of that alt
											if waypoints[w].ETA > departureOrbitAlt[flight[f].base][alt][a] - 600 and waypoints[w].ETA < departureOrbitAlt[flight[f].base][alt][a] + 600 then		--waypoint ETA is within 10 minutes of stored ETA 
												alt = alt + 304.8									--increase alt by 1'000 ft any try again for this next alt
												break												--break and continue with higher altitude
											end
											if a == #departureOrbitAlt[flight[f].base][alt] then	--if all stored ETAs have been checked
												table.insert(departureOrbitAlt[flight[f].base][alt], waypoints[w]["ETA"])	--insert new ETA for that altitude
												departureAlt = alt									--set this departure altitude
											end
										end
									end
								until departureAlt													--repeat until a departure altitude has been found
								waypoints[w].alt = departureAlt									--set departure altitude
							end
						end
					end

					-- ************* set attack speed for attack, target and egress waypoints *************
					if waypoints[w]["name"] == "Attack" or waypoints[w]["name"] == "Target" or waypoints[w]["name"] == "Egress" then
						waypoints[w]["ETA_locked"] = false
						waypoints[w]["speed_locked"] = true
						waypoints[w]["debug"] = (waypoints[w]["debug"] or "") .." ETA_locked A False "
					elseif waypoints[w]["name"] == "Join" and not is_helicopter then
						waypoints[w]["ETA_locked"] = true
						waypoints[w]["speed_locked"] = false
						waypoints[w]["debug"] = (waypoints[w]["debug"] or "") .." ETA_locked B True "

						local task_entry =
						{
							["enabled"] = true,
							["auto"] = false,
							["id"] = "WrappedAction",
							["name"] = "autorise la pc (name == Join)",
							["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
							["params"] =
							{
								["action"] =
								{
									["id"] = "Option",
									["params"] =
									{
										["value"] = false,
										["name"] = 16,
									},
								},
							},
						}
						table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)

					elseif waypoints[w]["name"] == "Assemble"  then
						waypoints[w]["ETA_locked"] = false
						waypoints[w]["speed_locked"] = true
						waypoints[w]["debug"] = (waypoints[w]["debug"] or "") .." ETA_locked C False "
					elseif waypoints[w]["name"] == "Departure"  then
						-- waypoints[w]["speed"] = pack[p].main[1].loadout.vCruise / 4 * 3					--set NEWSPEED
					end

					-- ************* sets the speed_locked values for the CAP only (it can arrive late ^^) *************
					if flight[f].task == "CAP" and waypoints[w]["name"] ~= "Land" and waypoints[w]["name"] ~= "Departure" and waypoints[w]["name"] ~= "Taxi" then
						waypoints[w]["ETA_locked"] = false
						waypoints[w]["speed_locked"] = true
						waypoints[w]["debug"] = (waypoints[w]["debug"] or "") .." ETA_locked D False "
					end

					-- *************  ATO_FP_Debug08 vi trop faible pour les escorteurs des strike trop lent 					
					if w>1 and flight[f].loadout.vCruise and waypoints[w]["speed"] < flight[f].loadout.vCruise / 4 * 3 then
						-- if Debug.debug then
							-- print("AtoFP vi trop faible w: "..w.." waypoints[w][speed]: "..waypoints[w]["speed"].." vCruise3/4 "..tostring(flight[f].loadout.vCruise / 4 * 3))
							-- print("  flight[f].loadout.vCruise ".. flight[f].loadout.vCruise)

							-- _affiche(waypoints, "waypoints")
							-- print("AtoFP ATO_FP_Debug08 vi trop faible pour les escorteurs des strike trop lent 	")
							-- print()

							-- _affiche(flight[f], "flight[f]") 
							-- print("Error") os.execute 'pause'

							DebugFLIGHT = DebugFLIGHT .. "\n".."(Error AtoFp 12  : vi trop faible pour les escorteurs des strike trop lent 	"
						-- end

					end

					-- ************* attack waypoint is a fly over point *************
					if waypoints[w]["name"] == "Attack" then
						waypoints[w]["action"] = "Fly Over Point"
					end

					-- ************* requetes des joueurs, assigner l'altitude des wpt landing et attack *************
					if isHumain then
						if waypoints[w]["briefing_name"] == "Target" or  waypoints[w]["briefing_name"] == "Attack" then
							waypoints[w].alt = 0
						elseif waypoints[w]["briefing_name"] == "Land" then
							if db_airbases[flight[f].base].elevation then
								waypoints[w].alt =  db_airbases[flight[f].base].elevation
							else
								waypoints[w].alt = 0
							end
						end
					end


					-- ************* player flight WP ETA *************
					if flight[f].player then
						if waypoints[w]["name"] == "Target" or waypoints[w]["name"] == "Station" then
							waypoints[w]["ETA_locked"] = true
							waypoints[w]["speed_locked"] = false
						elseif waypoints[w]["name"] == "Join" then															--ETA of join should be unlocked (so it is no target point for Viggen), but speed needs to be reduced to allow time for start up and take off
							waypoints[w]["ETA_locked"] = false
							waypoints[w]["speed_locked"] = true
						else
							waypoints[w]["ETA_locked"] = false
							waypoints[w]["speed_locked"] = true
						end
						waypoints[w]["debug"] = (waypoints[w]["debug"] or "") .." ETA_locked E "
					end

					-- modification M06.b bug helico reste statique s'il demarre en horaire décalé
					-- M06.e
					if is_helicopter and flight[f].route[w].id ~= "Departure" then	 --and flight[f].task == "Transport"	
						waypoints[w]["ETA_locked"] = false
						waypoints[w]["speed_locked"] = true
						waypoints[w]["debug"] = (waypoints[w]["debug"] or "") .." ETA_locked F False "
					end

					-- ************* altitudes below 1000m are AGL instead of MSL *************
					if waypoints[w]["alt"] <= 1000 and not is_helicopter then
						waypoints[w]["alt_type"] = "RADIO"
					elseif is_helicopter and flight[f].route[w].id == "Departure" then
						waypoints[w]["alt_type"] = "RADIO"
					elseif is_helicopter and flight[f].route[w].id ~= "Departure" and waypoints[w]["alt"] <= 100 then
						waypoints[w]["alt_type"] = "RADIO"
					end

					-- ************* take off and landing *************
					if (flight[f].route[w].id == "Taxi" and flight[f].route[w].eta >= 0) or (flight[f].route[w].id == "Intercept" or flight[f].route[w].id == "SAR")  then
						if not isHumain and db_airbases[flight[f].base].AI_Spawn and string.upper(db_airbases[flight[f].base].AI_Spawn) ~= "PARKING" then
							if string.upper(db_airbases[flight[f].base].AI_Spawn) == "AIR" then
								waypoints[w]["type"] = "Turning Point"
								waypoints[w]["action"] = "Turning Point"
								flight[f].route[w].id = "Spawn"
								flight[f].route[w].eta = flight[f].route[w].eta - 300
								-- spawn_time = flight[f].route[w].eta --spawn_time_bug		
								if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP_AI_Spawn AIR = { Turning Point ") end					
							elseif string.upper(db_airbases[flight[f].base].AI_Spawn) == "RUNWAY" then
								waypoints[w]["type"] = "Turning TakeOff"
								waypoints[w]["action"] = "From Runway"
								flight[f].route[w].eta = flight[f].route[w].eta - 200
								-- spawn_time = flight[f].route[w].eta --spawn_time_bug										
							end
						else
							waypoints[w]["type"] = "TakeOffParking"
							waypoints[w]["action"] = "From Parking Area"
							if baseIsCarrier or (flight[f].airdromeId and flight[f].airdromeId >= 100 and not parkSarAirBase[flight[f].base]) then									--airbase is a carrier
								waypoints[w].linkUnit = flight[f].airdromeId
								waypoints[w].helipadId = flight[f].airdromeId
							else
								waypoints[w]["airdromeId"] = flight[f].airdromeId
							end

							--if defined in conf_mod, player flight starts with engines running
							if (flight[f].player == true or flight[f].client == true) and mission_ini.parking_hotstart and (flight[f].task ~= "Intercept" and flight[f].task ~= "SAR") then

								if mission_ini.parking_hotstart then
									if  type(mission_ini.parking_hotstart) == "boolean"  then
										waypoints[w]["action"] = "From Parking Area Hot"
										waypoints[w]["type"] = "TakeOffParkingHot"
										-- print("AtoFP passe boolean TakeOffParkingHot")
									elseif  type(mission_ini.parking_hotstart) == "number" and mission_ini.parking_hotstart == 0  then
										waypoints[w]["action"] = "From Parking Area"
										waypoints[w]["type"] = "TakeOffParking"
									elseif  type(mission_ini.parking_hotstart) == "number" and mission_ini.parking_hotstart == 1  then
										waypoints[w]["action"] = "From Parking Area Hot"
										waypoints[w]["type"] = "TakeOffParkingHot"
									elseif  type(mission_ini.parking_hotstart) == "number" and mission_ini.parking_hotstart == 2  then
										waypoints[w]["action"] = "From Runway"
										waypoints[w]["type"] = "TakeOff"
									end
								end

							--if defined in conf_mod, task intercept player flight starts with engines running										-- modification M08	: hotstart
							elseif (flight[f].player == true or flight[f].client == true) and (flight[f].task == "Intercept" or flight[f].task == "SAR") then													--if flight[f].player == true and camp.hotstart then
								if  mission_ini.intercept_hotstart then
									if  type(mission_ini.intercept_hotstart) == "boolean"  then														--if flight[f].player == true and camp.hotstart then
										waypoints[w]["action"] = "From Parking Area Hot"
										waypoints[w]["type"] = "TakeOffParkingHot"
									elseif  type(mission_ini.intercept_hotstart) == "number" and mission_ini.intercept_hotstart == 0  then			--if flight[f].player == true and camp.hotstart then
										waypoints[w]["action"] = "From Parking Area"
										waypoints[w]["type"] = "TakeOffParking"
									elseif  type(mission_ini.intercept_hotstart) == "number" and mission_ini.intercept_hotstart == 1  then			--if flight[f].player == true and camp.hotstart then
										waypoints[w]["action"] = "From Parking Area Hot"
										waypoints[w]["type"] = "TakeOffParkingHot"
									elseif  type(mission_ini.intercept_hotstart) == "number" and mission_ini.intercept_hotstart == 2  then			--if flight[f].player == true and camp.hotstart then
										waypoints[w]["action"] = "From Runway"
										waypoints[w]["type"] = "TakeOff"
									end
								end
							end
						end
					elseif flight[f].route[w].id == "Land" then
						-- modification M18.c despawn/destroy Plane on BaseAirStart
						if (db_airbases[flight[f].base].BaseAirStart and not (flight[f].task == "Nothing" or flight[f].task == "Transport")) or
							( (flight[f].task == "Nothing" or flight[f].task == "Transport") and db_airbases[flight[f].target.destination].BaseAirStart ) then

							waypoints[w]["type"] = "Turning Point"
							waypoints[w]["action"] = "Turning Point"
							-- waypoints[w]["speed"] = flight[f].loadout.vCruise / 3 * 2			--set NEWSPEED
							waypoints[w].alt = 500 + db_airbases[flight[f].base].elevation
							waypoints[w]["ETA_locked"] = false
							waypoints[w]["speed_locked"] = true
							waypoints[w]["debug"] = (waypoints[w]["debug"] or "") .." ETA_locked G False "

							local stopTime = waypoints[w].ETA + 7200

							if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP_route[w].id land = { Turning Point ") end	


							local task_entry = {
								["enabled"] = true,
								["auto"] = false,
								["id"] = "WrappedAction",
								["name"] = "orbit with BaseAirStart (name == Land)",
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
							waypoints[w]["type"] = "Land"
							waypoints[w]["action"] = "Landing"
							-- waypoints[w]["ETA_locked"] = true		--ceci n'est pas une bonne idée, le DCS bloque
							waypoints[w]["ETA_locked"] = false
                            waypoints[w]["speed_locked"] = true
							waypoints[w]["debug"] = (waypoints[w]["debug"] or "") .." ETA_locked H False "

							if baseIsCarrier then
								waypoints[w].linkUnit = flight[f].airdromeId
								waypoints[w].helipadId = flight[f].airdromeId
								waypoints[w].alt = 0
							else
								waypoints[w]["airdromeId"] = flight[f].airdromeId
								--ATO_FP_Debug10
								if flight[f].task == "Nothing" or flight[f].task == "Transport" then
									waypoints[w]["airdromeId"] = db_airbases[flight[f].target.destination].airdromeId
									waypoints[w].alt = 500 + db_airbases[flight[f].target.destination].elevation
								end
							end

							if baseIsCarrier and waypoints[w].ETA <= mission_ini.startup_time_player + 600 then
								if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP delayed LANDING ") end

								--W-1 == Split
								--W == Land
								-- local distOrbit = GetDistance({x = waypoints[w-1].x, y = waypoints[w-1].y}, {x = waypoints[w].x, y = waypoints[w].y})
								local distOrbit = 35000
								local headingOrbit = 90 + GetHeadingDegre({x = waypoints[w-1].x, y = waypoints[w-1].y}, {x = waypoints[w].x, y = waypoints[w].y})
								local pointOrbit = GetOffsetPoint({x = waypoints[w-1].x, y = waypoints[w-1].y}, headingOrbit, distOrbit)
								local eta_orbit = (distOrbit / waypoints[w-1].speed) + waypoints[w-1].ETA
								stackN = stackN + 1
								local alt_orbit = 7620 + (stackN*305)

								--ajoute un waypoint intermediaire avec une orbit
								local wptOrbit = {
									['alt'] = alt_orbit,
									['briefing_name'] = 'Stacking',
									['action'] = 'Turning Point',
									['alt_type'] = 'BARO',
									["speed_locked"] =  false,
									['ETA'] = eta_orbit,
									['y'] = pointOrbit.y,
									['formation_template'] = '',
									['name'] = 'Stacking',
									["ETA_locked"] = true,
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
													["name"] = "orbit with BaseCarrier (name == Land)",
													["number"] =  1,
													["params"] =
													{
														["action"] =
														{
															["id"] = "Script",
															["params"] =
															{
																["command"] = "OrbitPosition('" .. groupName .. "', " .. alt_orbit .. ", " .. waypoints[w-1]["speed"] .. ", " .. tostring(waypoints[w-1]["ETA"]+120) .. ")",
															},
														},
													},
												},
											},
										},
									},
									['type'] = 'Turning Point',
									["debug"] = " |eta_orbit: ".. eta_orbit.." |distOrbit: "..distOrbit

								}
								table.insert(waypoints, w, wptOrbit )

								--now:
								--W-1 == Split
								--W == Stacking
								--W+1 == Land

								--décale l'ETA du waypoint suivant:
								local leg = GetDistance(waypoints[w], waypoints[w + 1])
								local addTime = leg / waypoints[w].speed
								waypoints[w+1].ETA = waypoints[w].ETA + addTime
								waypoints[w+1]["debug"] = (waypoints[w+1]["debug"] or "") .." |addTime: ".. addTime.." |leg: "..leg

							end
						end
					end

					-- ************* formations et largage d'urgence *************
					if flight[f].route[w].id == "Departure" or flight[f].route[w].id == "Spawn" then
						local task_entry = {}
						
						if is_helicopter then
							
							task_entry = {															--helicopter Spread Four Close
								["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
								["auto"] = true,
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


							table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
							
						else 
							
							--IsPlane

							--************* PC gourmand interdit *************
							if flight[f].type == "Tu-22M3" and flight[f].route[w].id == "Spawn" then
								task_entry =
								{
									["enabled"] = true,
									["auto"] = false,
									["id"] = "WrappedAction",
									["name"] = "interdit la PC after burner (id == Assemble)",
									["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
									["params"] =
									{
										["action"] =
										{
											["id"] = "Option",
											["params"] =
											{
												["value"] = true,
												["name"] = 16,
											},
										},
									},
								}
								table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
							end
							
							--************* largage d'urgence *************
							if (Data_divers[flight[f].type] and Data_divers[flight[f].type].heavyBomber)
								or flight[f].task == "SEAD" or flight[f].task == "Escort Jammer" then

								--interdiction largage d'urgence  *************
								task_entry = {
									["enabled"] = true,
									["auto"] = true,
									["id"] = "WrappedAction",
									["name"] = "PROHIBIT JETTISON: true (=jettisonOFF) (Departure/Spawn, SEAD)",
									["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
									["params"] =
									{
										["action"] =
										{
											["id"] = "Option",
											["params"] =
											{
												["value"] = true,
												["name"] = 15,
											},
										},
									},
								}
								table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
							else

								--largage d'urgence autorisé (Prohibit JETTISON false) *************
								task_entry = {
									["enabled"] = true,
									["auto"] = true,
									["id"] = "WrappedAction",
									["name"] = "PROHIBIT JETTISON: FALSE (=jettisonOK) (Departure/Spawn)",
									["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
									["params"] =
									{
										["action"] =
										{
											["id"] = "Option",
											["params"] =
											{
												["value"] = false,
												["name"] = 15,
											},
										},
									},
								}
								table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
							end


							--************* formation *************
							if Data_divers[flight[f].type] and Data_divers[flight[f].type].heavyBomber then
								--formation formation bomber moderne 100*100 *************
								task_entry = {															--formation bomber moderne 100*100
									["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
									["auto"] = true,
									["id"] = "WrappedAction",
									["name"] = "formation bomber moderne 100*100  (Departure/Spawn)",
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
												["formationIndex"] = 17,
												["value"] = 1114113,
											},
										},
									},
								}
								table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)

							else

								-- ** formation Spread Four Close
								task_entry = {															--Spread Four Close
									["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
									["auto"] = true,
									["id"] = "WrappedAction",
									["name"] = "Spread Four Close (Departure/Spawn)",
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

								table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)



								-- ** ignorer le ravito Vol WPT1
								task_entry = {
									["number"] = 4,
									["auto"] = false,
									["id"] = "WrappedAction",
									["name"] = "BINGO RTB: ignorer le ravito Vol WPT1",
									["enabled"] = true,
									["params"] =
									{
										["action"] =
										{
											["id"] = "Option",
											["params"] =
											{
												["value"] = 2,
												["name"] = 6,
											}, -- end of ["params"]
										}, -- end of ["action"]
									}, -- end of ["params"]
								}


								table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)

							end --heavyBomber or not


							--************* reaction to thread *************

							if Data_divers[flight[f].type] and Data_divers[flight[f].type].heavyBomber then

								--reaction to Threats passive defense
								task_entry = {
									["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
									["auto"] = true,
									["id"] = "WrappedAction",
									["name"] = "reaction to Threats, passive defense (Departure/Spawn)",
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

							elseif flight[f].task ~= "SEAD" then
								-- ** reaction to threat avoidance of fire
								task_entry = {
									["number"] = #waypoints[1]["task"]["params"]["tasks"] + 1,
									["auto"] = true,
									["id"] = "WrappedAction",
									["name"] = "reaction to threats, avoidance of fire (Departure/Spawn)",
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

							--************* EngageTargets *************
							if flight[f].task == "SEAD" then

								task_entry = {
									["enabled"] = true,
									["key"] = "SEAD",
									["id"] = "EngageTargets",
									["number"] = 1,
									["auto"] = true,
									["params"] =
									{
										["targetTypes"] =
										{
											[1] = "Air Defence",
										}, -- end of ["targetTypes"]
										["priority"] = 0,
									}, -- end of ["params"]
								}
								table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)

								--************* EngageTargets *************
							elseif flight[f].task == "Anti-ship Strike" then

								task_entry = {
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

							end
						end -- is plane
					end --if Departure or Spawn


					-- ************* datalink EPLRS Capacity *************
					if (flight[f].route[w].id == "Departure" or flight[f].route[w].id == "Spawn") and camp.date.year >= 1996 then
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
					-- ************* ALTITUDE determine une nouvelle altitude pour ne pas prendre une montagne
					if flight[f].route[w].id == "Spawn" then
						local altFloor = 0

						if AltitudeFloorNew then
							for level, layers in pairs(AltitudeFloorNew) do
								for polyN, poly in pairs(layers) do
									local result = CheckPointInPolygon(waypoints[1], poly)
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
							if waypoints[1]["alt"] < altFloor + 200 then
								waypoints[1]["alt"] =  altFloor + 200 + ((pn-1) * 200) + (altRole * 50)
							end
						end

					end


					--*************************************************************************************
					--attack tasks
					--*************************************************************************************

					-- local grpname = "Pack " .. p .. " - " .. flight[f].name .. " - " .. flight[f].task .. " " .. (f + addNflight)
					local expendQty = flight[f].loadout.expend
					local weaponType_ = flight[f].loadout.weaponType
					local attackType = flight[f].loadout.attackType or "nil"
					local attackAlt = flight[f].loadout.attackAlt or flight[f].loadout.hAttack
					local dive = nil
					if flight[f].loadout.attackType and  string.lower( flight[f].loadout.attackType) == "dive"  then
						dive = true
					end

					local AGAS_ready = false

					if flight[f].loadout.AGAS_AttackDist or flight[f].loadout.AGAS_PopAlt or flight[f].loadout.AGAS_OffsetAngle or flight[f].loadout.AGAS_ClimbAngle then
						AGAS_ready = true
					end
					local offsetAngle = flight[f].loadout.AGAS_OffsetAngle or 20
					local climbAngle  = flight[f].loadout.AGAS_ClimbAngle or 30   --climb angles smaller than 15 are not possible
					local popAlt = flight[f].loadout.AGAS_PopAlt or nil   --500   --Pop-up maneuver prior to attack
					local attackDist = flight[f].loadout.AGAS_AttackDist or nil   --3000
					local reattack = flight[f].loadout.AGAS_Reattack or nil
					local DebugTask = Debug.debug

					local target_element, tgtlist
					if flight[f].target.elements and #flight[f].target.elements >= 1 and flight[f].target.elements[1].x then
						target_element = {}																			--table to hold the target element number to be struck
						
						for e = 1, #flight[f].target.elements do															--iterate trough all target elements
							if not flight[f].target.elements[e].dead then												--pick only elements that are not dead
								table.insert(target_element, e)																--add to target element table
							end
						end
						
						-- for elementN, element in pairs(flight[f].target.elements) do															--iterate trough all target elements
						-- 	if not element.dead then												--pick only elements that are not dead
						-- 		table.insert(target_element, elementN)																--add to target element table
						-- 	end
						-- end

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
						AddLog("no known runway element for the target "..tostring(flight[f].target_name))
					end

					-- *************  switch from IP to egress *************
					if flight[f].route[w].id == "IP" then

						if not is_helicopter then
							--interdiction de largage d'urgence
							local task_entry = {
								["enabled"] = true,
								["auto"] = false,
								["id"] = "WrappedAction",
								["name"] = "PROHIBIT JETTISON : true (=jettisonOFF (id == IP)",
								["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
								["params"] =
								{
									["action"] =
									{
										["id"] = "Option",
										["params"] =
										{
											["value"] = true,
											["name"] = 15,
										},
									},
								},
							}
							table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
						end

					elseif  flight[f].route[w].id == "Attack" then

							--*********************************Strike MEDLEY*******************************************
						if flight[f].task == "Strike" then
							if flight[f].target.class == nil or flight[f].target.class ~= "airbase" and attackType ~= "Carpet" then
								local target_e = {}																			--table to hold the target element number to be struck
								
								if flight[f].target.elements and #flight[f].target.elements >= 1 and flight[f].target.elements[1].x then
									if flight[f].target and not flight[f].target.elements then
										_affiche(flight[f].target, "flight[f].target")
									end
									
									for n, element in pairs(flight[f].target.elements) do
										if element.dead ~= true then
											table.insert(target_e, element)
										end
									end
								else
									table.insert(target_e, flight[f].target)
								end
						
								local tgtlist2 = ""																					--list of of names of all target elements
								local AGAS_tgtList = ""
								for n , element in ipairs(target_e) do
									if element.x and element.y then
										tgtlist2 = tgtlist2 .. "{'" .. element.name .. "','" .. tostring(element.class) .. "','" .. tostring(element.x) .. "','" .. tostring(element.y) .. "'}, "
										AGAS_tgtList = AGAS_tgtList.. "{" .. element.x .. "," .. element.y .. "},"
									else
										AddLog("element "..tostring(element.name).." of target "..tostring(flight[f].target_name).." has no coordinates, skipped for attack task")
									end
								end

								if is_helicopter or AGAS_ready == false and tgtlist2 ~= ""then
									if not isHumain then
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
														["command"] = "CustomMixClassAttack('" .. groupName .. "', {" .. tgtlist2 .. "}, '" .. expendQty .. "', '" .. weaponType .. "', '" .. attackType .. "', '" .. attackAlt .. "', '" .. goupTaskTemp ..  "')",	--this is a custom written task to allow all aircraft in flight to attack multiple static objects simultenously
													},

												},
											},
										}
										table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)

									end

								elseif AGAS_tgtList ~= "" then
									if not isHumain then
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
																	--AirGroundAttackTask(FlightName,				 Target,						 WeaponType,string			 expendQty,string		 dive,			 OffsetAngle, 			ClimbAngle, 		PopAlt, 		AttackDist, 			Reattack,			 Debug)
														["command"] = "AirGroundAttackTask('" .. groupName .. "', {" .. AGAS_tgtList .. "}, '" .. weaponType_ .. "', '"  .. expendQty .. "', " .. tostring(dive) .. ", " .. tostring(offsetAngle) .. ", " .. tostring(climbAngle) ..", " .. tostring(popAlt) ..", " .. tostring(attackDist) ..", " .. tostring(reattack) .. ")",
													},
												},
											},
										}
										table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
									end
								end

								if isHumain then
									for n, element in ipairs(target_e) do
										local TaskFrom =  " TaskFrom "..debug.getinfo(1).currentline
										local task_entry = createBombingChapter(id_task, flight[f],waypoints[w], weaponType, attackType, attackAlt, element, TaskFrom, typeCible)
										table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
									end
								end

							--*********************************Strike airbase*******************************************
							elseif flight[f].target.class == "airbase" then
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
													["command"] = "CustomAirbaseAttack('" .. groupName .. "', {x = " .. flight[f].target.x .. ", y = " .. flight[f].target.y .. "}, '" .. expendQty .. "', '" .. weaponType .. "', '" .. attackType .. "', " .. attackAlt .. ")",
												},
											},
										},
									}
									table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
								else

									if not isHumain then

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
																	--AirGroundAttackTask(FlightName,				 Target,															 WeaponType,string			 expendQty,string		 dive,			 OffsetAngle, 			ClimbAngle, 		PopAlt, 		AttackDist, 			Reattack,			 Debug)
														["command"] = "AirGroundAttackTask('" .. groupName .. "', {x = " .. flight[f].target.x .. ", y = " .. flight[f].target.y .. "}, '" .. weaponType_ .. "', '"  .. expendQty .. "', " .. tostring(dive) .. ", " .. tostring(offsetAngle) .. ", " .. tostring(climbAngle) ..", " .. tostring(popAlt) ..", " .. tostring(attackDist) ..", " .. tostring(reattack) .. ")",
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


								--********************************* CarpetBombing *******************************************
							elseif attackType == "Carpet" then

								if not isHumain then

									local task_entry = {																				--task is a command to run LUA code
										["enabled"] = true,
										["auto"] = false,
										["id"] = "CarpetBombing",
										["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
										["params"] =
										{
											["attackType"] = "Carpet",
											["attackQtyLimit"] = false,
											["attackQty"] = 1,
											["expend"] = tostring(expendQty),
											["y"] = flight[f].target.y,
											["x"] = flight[f].target.x,
											["carpetLength"] = 500,
											["groupAttack"] = false,
											["altitudeEnabled"] = false,
											["weaponType"] = weaponType,
											["altitude"] = attackAlt,
										},
									}
									table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
								end

							end

						--*********************************Runway Attack*******************************************
						elseif flight[f].task == "Runway Attack" then

							if not isHumain then
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
												["command"] = "CustomMapObjectAttack('" .. groupName .. "', {" .. tgtlist .. "}, '" .. expendQty .. "', '" .. weaponType .. "', '" .. attackType .. "', '" .. attackAlt .. "', '" .. goupTaskTemp ..  "')",
											},

										},
									},
								}
								table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
							end

						--*********************************Anti-ship Strike*******************************************
						elseif flight[f].task == "Anti-ship Strike" then

							if not is_helicopter or AGAS_ready == false  then

								-- local task_entry = {															--Spread Four Close
								-- 	["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
								-- 	["enabled"] = true,
								-- 	["key"] = "AntiShip",
								-- 	["id"] = "EngageTargets",
								-- 	["auto"] = true,
								-- 	["params"] =
								-- 	{
								-- 		["targetTypes"] =
								-- 		{
								-- 			[1] = "Ships",
								-- 		}, -- end of ["targetTypes"]
								-- 		["priority"] = 0,
								-- 	}, -- end of ["params"]

								-- }
								-- table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)

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
										["attackQty"] = 1,
										["altitudeEnabled"] = false,
										-- ["attackType"] = flight[f].loadout.attackType,
									}
								}


								table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)

							else

								if not isHumain then

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
																--AirGroundAttackTask(FlightName,				 Target,						 WeaponType,string			 expendQty,string		 dive,			 OffsetAngle, 			ClimbAngle, 		PopAlt, 		AttackDist, 			Reattack,			 Debug)
													["command"] = "AirGroundAttackTask('" .. groupName .. "', '" .. flight[f].target.name .. "', '" .. weaponType_ .. "', '"  .. expendQty .. "', " .. tostring(dive) .. ", " .. tostring(offsetAngle) .. ", " .. tostring(climbAngle) ..", " .. tostring(popAlt) ..", " .. tostring(attackDist) ..", " .. tostring(reattack) .. ")",
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
							-- local attackType = flight[f].loadout.attackType or "nil"
							-- attackAlt = flight[f].loadout.attackAlt or flight[f].loadout.hAttack
							local tgtx = "n/a"																					--target coordinate n/a, custom attach script will determine latest target position at time of attack during the misssion
							local tgty = "n/a"																					--target coordinate n/a, custom attach script will determine latest target position at time of attack during the misssion
							if flight[f].target.class ~= "vehicle" then															--if target is not a vehicle or ship, then known target coordinates are used
								tgtx = flight[f].target.x																		--use known target coordinates
								tgty = flight[f].target.y																		--use known target coordinates
							end

							task_entry = {																				--task is a command to run LUA code
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


						--Custom_SAR
						elseif flight[f].task == "CSAR" and not isHumain then

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
														-- Custom_SAR(grpname, airdrome, airdromeX, airdromeY, mgrsChute, speed, alt)
											["command"] = "Custom_SAR('" .. groupName .. "', '" .. flight[f].base .. "', '" .. db_airbases[flight[f].base].x .. "', '" .. db_airbases[flight[f].base].y .. "', '" .. flight[f].target_name .. "', '" .. flight[f].loadout.vCruise .. "', '" .. alt_cruise ..  "')",
										},
									},
								},
							}
							table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
						end
					end

					-- ************* SEAD engage tasks for each route segment *************
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
					-- ************* Escort and Fighter Sweep Custom Search and Engage Task CustomSearchThenEngage *************
					elseif flight[f].task == "Fighter Sweep" then

						-- if flight[f].route[w].id == "Spawn" or flight[f].route[w].id == "Departure" then
						-- 	local searchTime = flight[f].route[#flight[f].route].eta
						-- 	if not flight[f].loadout.standoff then
						-- 		DebugFLIGHT = DebugFLIGHT .. "\n".."no standoff in the loadout of the task ..Fighter Sweep.. of the type: "..tostring(flight[f].type)
						-- 	end
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
						-- 					["command"] = "CustomSearchThenEngage('" .. groupName .. "', "  .. tostring(flight[f].loadout.standoff) .. ", 'Air',"   .. searchTime .. ")",
						-- 				},
						-- 			},
						-- 		},
						-- 	}
						-- 	table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
						-- end
						local task_entry = {
							["name"] = "EngageTargets ex CustomSearchThenEngage()",
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
										["maxDist"] = flight[f].loadout.standoff or 60000,
									}, -- end of ["params"]
								},
							}
						}
						table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
					elseif flight[f].task == "Escort" then
					
						if flight[f].route[w].id == "Spawn" or flight[f].route[w].id == "Departure" then
							-- local target = "Battle airplanes"
							-- if  is_helicopter then															-- modif M06 : helicoptere playable
							-- 	target = "Helicopters"
							-- end

							-- if not flight[f].loadout.standoff then
							-- 	DebugFLIGHT = DebugFLIGHT .. "\n".."no standoff in the loadout of the task ..Escort.. of the type: "..tostring(flight[f].type)
							-- end

							-- local searchTime = flight[f].route[#flight[f].route].eta

							-- local task_entry = {
							-- 	["enabled"] = true,
							-- 	["auto"] = false,
							-- 	["id"] = "WrappedAction",
							-- 	["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
							-- 	["params"] =
							-- 	{
							-- 		["action"] =
							-- 		{
							-- 			["id"] = "Script",
							-- 			["params"] =
							-- 			{
							-- 				["command"] = "CustomSearchThenEngage('" .. groupName .. "', "  .. tostring(flight[f].loadout.standoff) .. ", 'Air',"   .. searchTime .. ")",
							-- 			},
							-- 		},
							-- 	},
							-- }
							-- table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
						
							local task_entry = {
								["name"] = "EngageTargets ex CustomSearchThenEngage()",
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
											["maxDist"] = flight[f].loadout.standoff or 60000,
										}, -- end of ["params"]
									},
								}
							}
							table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
						
						end

						if flight[f].route[w].id == "WPT Before Landing" then
							local task_entry = {
								["enabled"] = true,
								["auto"] = false,
								["id"] = "WrappedAction",
								["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
								["params"] =
								{
									["action"] = {
										["id"] = "Script",
										["params"] = {
											["command"] = "env.info(\'DCE_WPT Before Landing #WPT-1 \')",
										},
									},
								},
							}
							table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)


							task_entry = {
								["enabled"] = true,
								["auto"] = false,
								["id"] = "WrappedAction",
								["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
								["params"] =
								{
									["action"] = {
										["id"] = "Script",
										["params"] = {
											["command"] = string.format(
												"Custom_ForceToLand('%s', %s, %s, %s, %s, %s)",
												groupName,
												tostring(flight[f].route[w].speed or 0),
												tostring(flight[f].route[w].alt or 0),
												tostring(flight[f].route[w].x or 0),
												tostring(flight[f].route[w].y or 0),
												tostring(waypoints[w].linkUnit or "nil")
											),
										},
									},
								},
							}
							table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
						end


						if flight[f].route[w].id == "Land" then
							local task_entry = {
								["enabled"] = true,
								["auto"] = false,
								["id"] = "WrappedAction",
								["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
								["params"] =
								{
									["action"] = {
										["id"] = "Script",
										["params"] = {
											["command"] = "env.info(\'DCE_WPT_Land #WPT \')",
										},
									},
								},
							}
							table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)


							task_entry = {
								["enabled"] = true,
								["auto"] = false,
								["id"] = "WrappedAction",
								["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
								["params"] =
								{
									["action"] = {
										["id"] = "Script",
										["params"] = {
											["command"] = string.format(
												"Custom_ForceToLand('%s', %s, %s, %s, %s, %s)",
												groupName,
												tostring(flight[f].route[w].speed or 0),
												tostring(flight[f].route[w].alt or 0),
												tostring(flight[f].route[w].x or 0),
												tostring(flight[f].route[w].y or 0),
												tostring(waypoints[w].linkUnit or "nil")
											),
										},
									},
								},
							}
							table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
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
						if flight[f].route[w].id ~= "Station" and flight[f].route[w].id ~= "Land" then --and flight[f].route[w].id ~= "Departure" 
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

					elseif flight[f].task == "Escort" then
						
						if flight[f].route[w].id ~= "Station" and flight[f].route[w].id ~= "Land" then 
							
							local task_entry = {
								["name"] = "EngageTargets maxDistEnabled",
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
											["maxDist"] = flight[f].loadout.standoff or 60000,
										}, -- end of ["params"]
									},
								}
							}
							table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
						end

					
					elseif flight[f].task == "Escort Jammer" then

						if (flight[f].route[w].id == "IP" or flight[f].route[w].id == "Target") and not alreadyTreated  then

							local task_entry = {
								["enabled"] = true,
								["auto"] = false,
								["id"] = "Follow",
								["name"] = "Follow : (id == IP or Target)",
								["number"] = 1,
								["params"] =
								{
									["lastWptIndexFlagChangedManually"] = true,
									["groupId"] = "toBeDefinedLater",
									["lastWptIndex"] = "toBeDefinedLater",
									["lastWptIndexFlag"] = true,
									["pos"] =
									{
										["y"] = -600,
										["x"] = -600,
										["z"] = -600,
									}, -- end of ["pos"]
								}, -- end of ["params"]
							}

							table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
							alreadyTreated = true

							flight[f]["mustFolloW"] = pack[p]["main"][1].groupName

						end
					end


					-- ************* station tasks *************
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

							local task_entry = {
								["enabled"] = true,
								["name"] = "evitement horizontal des tirs AAA",
								["auto"] = false,
								["id"] = "WrappedAction",
								["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
								["params"] =
								{
									["action"] =
									{
										["id"] = "Option",
										["params"] =
										{
											["value"] = 5,
											["name"] = 1,
										},
									},
								},
							}
							table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)


							if Data_divers[flight[f].type] and Data_divers[flight[f].type].laserDesignator then

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

							end

							task_entry = {																				--task is a command to run LUA code
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
											["command"] = "CustomDesignationAFAC('" .. groupName .. "', '" .. flight[f].target.x .. "', '" .. flight[f].target.y .. "',  '" .. tostring(flight[f].target.LaserCode) .. "')",
										},
									},
								},
							}
							table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)

						end
					end

					-- ************* orbit on departure/Assemble *************
					if flight[f].route[w].id == "Assemble" then
						if flight[f].number > 1 or (#flight > 1 and flight[f].loadout.tStation == nil) or flight[f].target.firepower.packmax then		--orbit on departure only for flights larger than 1-ship, flights that are part of a package (but no on-station tasks) or multi-packages

							if not is_helicopter then
								local task_entry =
								{
									["enabled"] = true,
									["auto"] = false,
									["id"] = "WrappedAction",
									["name"] = "interdit la PC after burner (id == Assemble)",
									["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
									["params"] =
									{
										["action"] =
										{
											["id"] = "Option",
											["params"] =
											{
												["value"] = true,
												["name"] = 16,
											},
										},
									},
								}
								table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
							end

							local altitude = AltitudeCruise * 2/3
							speed = pack[p].main[1].loadout.vCruise

							if flight[f].loadout.vCruise then
								speed = flight[f].loadout.vCruise
								if Data_divers and Data_divers[flight[f].type] and Data_divers[flight[f].type].vCruise and speed > Data_divers[flight[f].type].vCruise then
									speed = Data_divers[flight[f].type].vCruise
								end
							end

							speed = speed * (1 - 10/100)		--on soustrait 10% de la valeur de cruise

							if is_helicopter then altitude = 150 end

							if Data_divers and Data_divers[flight[f].type] and Data_divers[flight[f].type].hCruise then
								altitude = Data_divers[flight[f].type].hCruise
							end

							if flight[f].loadout.heavy_load then
								altitude = altitude /2
							else
								altitude = altitude * 2/3
							end

							waypoints[w].alt = altitude

							local timeOrbit = waypoints[w]["ETA"]

							if flight[f].route[w + 1] and flight[f].route[w + 1].eta and timeOrbit > flight[f].route[w + 1].eta then
								timeOrbit = flight[f].route[w + 1].eta
							end



							--orbit **--

							speed = pack[p].main[1].loadout.vCruise
							if flight[f].loadout.vCruise and flight[f].loadout.vCruise < speed then
								speed = flight[f].loadout.vCruise / 3 * 2
							end

							local task_entry = {
								["enabled"] = true,
								["auto"] = false,
								["id"] = "ControlledTask",
								["name"] = "orbit (id == Assemble)",
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
										["time"] = timeOrbit
									}
								}
							}
							table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)

						end
					end

					-- ************* A-A TACAN for tankers, activate TACAN on first orbit WP *************
					--w == 1 : suite au bug des tacan qui ne s'active plus en cours du plan de vol, sauf sur le wpt 0
					if (flight[f].route[w].id == "Station" and flight[f].route[w + 1].id == "Station") or w == 1 then
						if flight[f].task == "Refueling" then
							-- if flight[f]["type"] == "KC-135" or flight[f]["type"] == "KC130" or flight[f]["type"] == "KC135BDA" or flight[f]["type"] == "S-3B Tanker" or flight[f]["type"] == "KC135MPRS" then	--only specific tanker types have air-air TACAN
								if flight[1].tacan == nil then
									flight[1].tacan = getTankerTACAN(flight[f].target_name)															--get new channel for first flight in pack only, all other flights will use same channel
								end

								-- local unitIdTemp = GenerateIDUnit("AtoFP ".. "Pack " .. p .. " - " .. flight[f].name .. " - " .. flight[f].task .. " " .. (f + addNflight) .. "-1")
								local unitIdTemp = GenerateIDUnit(groupName.. "-1", flight[f]["type"])

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
								-- if task_entry.params.action.params.frequency > 1150000000 then
								-- 	task_entry.params.action.params.frequency = task_entry.params.action.params.frequency - 126000000
								-- end
								table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
							-- end
						end
					end

					-- ************* A-A TACAN for tankers, deactivate beacon on second orbit WP *************
					--A-A TACAN for tankers, deactivate beacon after 2 wpt on orbit WP
					if w > 2 and (flight[f].route[w-1].id == "Station" and flight[f].route[w - 2].id == "Station") then
						if flight[f].task == "Refueling" then
							-- if flight[f]["type"] == "KC-135" or flight[f]["type"] == "KC135MPRS"  or flight[f]["type"] == "KC130" or flight[f]["type"] == "KC135BDA" or flight[f]["type"] == "S-3B Tanker" then	--only specific tanker types have air-air TACAN			
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
							-- end
						end
					end

					-- ************* orbit on station
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

					-- ************* SEAD switch from IP to egress
					if flight[f].route[w].id == "IP" and flight[f].task == "SEAD" then
						speed = pack[p].main[1].loadout.vCruise
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

					-- TODO ajouter un circle pour les escorte de Transport

					--orbit on egress
					if flight[f].route[w].id == "Egress" and flight[f].task == "Escort" then
						speed = pack[p].main[1].loadout.vCruise
						if flight[f].loadout.vCruise and flight[f].loadout.vCruise < speed then
							speed = flight[f].loadout.vCruise / 3 * 2
						end
						local timeOrbit = 400

						if IsHelicopter[pack[p]["main"][1].type] then
							timeOrbit = 600
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

					-- ************* rejoin flight on egress *************
					if (flight[f].task == "Strike" or flight[f].task == "Anti-ship Strike" ) and flight[f].route[w].id == "Egress" then

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


					-- ************* allow weapon jettison from egress on *************

					if flight[f].route[w].id == "Egress"
						and (flight[f].task == "SEAD" or flight[f].task == "Strike" or flight[f].task == "Anti-ship Strike" or flight[f].task == "Flare Illumination" or flight[f].task == "Laser Illumination")
						and not is_helicopter then

						if flight[f].player ~= true and flight[f].client ~= true then
							local task_entry = {
								["enabled"] = true,
								["auto"] = false,
								["id"] = "WrappedAction",
								["name"] = "PROHIBIT JETTISON false (=jettisonOK) : Egress",
								["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
								["params"] =
								{
									["action"] =
									{
										["id"] = "Option",
										["params"] =
										{
											["value"] = false,
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
					if isHumain then																				--flight is player flight
						if waypoints[w - 1] then																			--previous waypoint exists
							local distance = GetDistance(waypoints[w - 1], waypoints[w])									--distance between waypoints
							local distanceStr = tostring(distance)
							local suffixe = " KM"
							if waypoints[w].name == "Target" then
								distance = GetDistance(waypoints[w - 2], waypoints[w])										--for target waypoint measure distance from IP, since attack point is removed for player flight
							end
							if distance > 0 then																			--distance is not zero
								local heading = math.floor(GetHeadingDegre(waypoints[w - 1], waypoints[w]))						--heading between waypoints
								heading = heading - camp.variation															--adjust heading (true heading) with variation of map to get magnetix heading
								if heading < 0 then
									heading = heading + 360
								elseif heading > 359 then
									heading = heading - 360
								end
								if heading < 10 then
									heading = "00" .. tostring(heading)
								elseif heading < 100 then
									heading = "0" .. tostring(heading)
								end


								-- if mission_ini.units == "metric" then
								if Data_divers and Data_divers[flight[f].type] and Data_divers[flight[f].type].instrumentUnits
								and (Data_divers[flight[f].type].instrumentUnits == "metric" or Data_divers[flight[f].type].instrumentUnits =="russian") then
									distance = math.ceil(distance / 1000)
									totFlightDist = totFlightDist + tonumber(distance)
									distanceStr = tostring(distance) .. " KM"
									suffixe = " KM"
								else
									distance = math.ceil(distance / 1000 * 0.539957)
									totFlightDist = totFlightDist + tonumber(distance)
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
								if flight[f]["type"] == "F-14B" and navTargetPoints[1] then
									if waypoints[w].name == "Target" or waypoints[w].name == "Attack" then  waypoints[w].NavTP = "ST" end
									if waypoints[w].name == "Station"  then  waypoints[w].NavTP = "DP" end
								end
								waypoints[w]["name"] = waypoints[w]["name"] .. "" .. heading .. " / " .. distance.." / "..ete			--add heading and distance to waypoint name

								if waypoints[w].briefing_name == "Land"  then
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

										space = 6 - string.len(tostring(tempTimeStr))
										s = ""
										for n = 1, space  do
											s = s .. " "
										end
										waypoints[w]["TotFlightTime"] = s..tempTimeStr
										waypoints[w]["TotFlightDist"] = totFlightDist .. suffixe

									end
								end
							end
						end
					end


					-- print("AtoFp "..flight[f].task.." _________ wptTargetPass: "..tostring(wptTargetPass).." wptName "..tostring(waypoints[w]["name"]) )
					if flight[f].task == "Anti-ship Strike" and wptTargetPass and waypoints[w]["name"] ~= "Land"  then
						waypoints[w]["ETA_locked"] = false
						waypoints[w]["speed_locked"] = true
						waypoints[w]["debug"] = (waypoints[w]["debug"] or "") .." ETA_locked J False "
					end

				end	-- Fin de Route


				-- ************* Fin de Route *************
				-- ************* Fin de Route *************
				-- ************* Fin de Route *************




				-- ************* lock ETA and speed of first waypoint *************
				waypoints[1]["ETA_locked"] = true
				waypoints[1]["speed_locked"] = true
				if waypoints[1]["speed"] == nil then
					waypoints[1]["speed"] = 1
				end

				-- ************* store player waypoints for briefing creation *************
				if flight[f].player == true then

					camp.player.waypoints = DeepCopy(waypoints)
					if camp.player.waypoints[2] then
						camp.player.waypoints[2].speed = 0
						camp.player.waypoints[2].alt = 0
					end


					-- if camp.player.waypoints[3] then
						-- camp.player.waypoints[3].speed = pack[p].main[1].loadout.vCruise / 4 * 3
					-- end
				end


				-- ************* remove taxi waypoint *************
				if waypoints[1].name == "Taxi" then

					waypoints[2]["airdromeId"] = waypoints[1]["airdromeId"]
					waypoints[2].linkUnit = waypoints[1].linkUnit
					waypoints[2].helipadId = waypoints[1].helipadId
					waypoints[2]["action"] = waypoints[1]["action"]
					waypoints[2]["type"] = waypoints[1]["type"]
					waypoints[2]["ETA"] = waypoints[1]["ETA"]
					waypoints[2].etaSpawn = waypoints[1].etaSpawn

					table.remove(waypoints, 1)

					-- waypoints[1]["ETA"] = spawn_time	--NE PAS METTRE ça, ça rend le decollage en retard

					if isHumain then
						waypoints[1]["ETA"] = 0
					end

					waypoints[1]["ETA_locked"] = true
					waypoints[1]["speed_locked"] = true

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

				-- ************* add descend waypoint *************
				if flight[f].player ~= true and flight[f].client ~= true then																--for AI flights only
					for w = 3, #waypoints do
						if not IsHelicopter and waypoints[w].alt < waypoints[w - 1].alt and waypoints[w]["type"] ~= "Land"
						and (waypoints[w]["briefing_name"] and waypoints[w]["briefing_name"] ~= "Stacking") then		--for any descend waypoint that is not the landing waypoint
							local extraWP = DeepCopy(waypoints[w])												--make a copy of the descend waypoint
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



				-- ************* evite que les escortes passent PC pour rattraper le retard au retour de mission *************
				local wptEtaOff = 9999
				for w = 1, #waypoints do
					if waypoints[w].briefing_name then
						if waypoints[w].briefing_name == "IP" then
							wptEtaOff = w+1
						elseif waypoints[w].briefing_name == "Egress" then
							wptEtaOff = w
						end
					end

					if w >= wptEtaOff then
						waypoints[w]["ETA_locked"] = false
						waypoints[w]["speed_locked"] = true
						waypoints[w]["debug"] = (waypoints[w]["debug"] or "") .. "ETA_Locked_OFF wptEtaOff: "..tostring(wptEtaOff)
					end

				end



				-- ************* Fin de bidouillage ETA *************
				-- ************* Fin de bidouillage ETA *************
				-- ************* Fin de bidouillage ETA *************



				if flight[f].task == "CSAR" then
					--ajuste l'altitude des helico en zone montagneuse, ils ont beaucoup de mal en alti radar
					for n = 1, #waypoints do
						if waypoints[n]["type"] == "Land" then
							waypoints[n]["action"] = "LandingReFuAr"
							waypoints[n]["type"] = "LandingReFuAr"
						end
						if waypoints[n]["briefing_name"] == "Join" or waypoints[n]["briefing_name"] == "Nav" or waypoints[n]["briefing_name"] == "Split"  then
							waypoints[n]["alt"] = waypoints[n]["alt"] + db_airbases[flight[f].base].elevation
						end
						if waypoints[n]["briefing_name"] == "IP" or waypoints[n]["briefing_name"] == "Attack"  then   -- or waypoints[n]["briefing_name"] == "Egress"

							-- local altEjected  = flight[f].target.elements[1].z + 100

							local altEjected  = flight[f].target.z + 100

							waypoints[n]["alt"] = altEjected

							--demande à tous les ejectedPilot de la zone d'allumer leur radio à 10mn avant l'eta
							for m=1, #camp.SAR.pilotEjected do
								if camp.SAR.pilotEjected[m].MGRS_Chute == flight[f].target_name
								and camp.SAR.pilotEjected[m].side == sideName then
									camp.SAR.pilotEjected[m].radio_start = waypoints[n].ETA - 600
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

					-- le niveau est séparé en 4 (25% de 100)
					--Average (0 à 25)
					--Good (25 à 50)
					--High (50 à 75)
					--Excellent (75 à 100)

					if string.lower(flight[f].skill) == "high" and not( mission_ini.slider_EnemyLevel or type(mission_ini.slider_EnemyLevel == "number")) then				--M52_b
						calcWish = 62
					else
						calcWish = SkillWish[sideName]
					end

					local mSkill
					local skill = ""

					if n == 1 then
						mSkill = ( math.random(calcWish-20, calcWish+18) / 25 ) + 1		-- 75-62 = 13 (13 + 5 = 18 )5 % de chance d'avoir excellent
					else
						mSkill = ( math.random(calcWish-50, calcWish+10) / 25) + 1
					end

					mSkill = math.floor(mSkill)

					if mSkill <= 1 then
						mSkill = 1
					elseif mSkill >= 4 then
						mSkill = 4
					end


					if isHumain then
						if n == 2 then
							skill = skillTab[4]
						end
					--overide skill pour les AFAC qui ne sont pas des manches et prennent tous les risques
					elseif flight[f].task == "AFAC" then
						skill = skillTab[4]
					else
						if mission_ini.randomizeSkills then
							skill = skillTab[mSkill]
						else
							skill = flight[f].skill
						end
					end


					--gerer le kero au Spawn
					local fuelTemp = flight[f].loadout.stores.fuel

					if (flight[f].task == "Refueling" or flight[f].task == "AWACS")
						and waypoints[1].briefing_name and waypoints[1].briefing_name == "Spawn"
						-- and flight[f].route[1].airstart
						-- and flight[f].type ~= "Tu-22M3"
					then
						if not db_airbases[flight[f].base].BaseAirStart then
							fuelTemp = fuelTemp * 0.8
						end
					end

					if flight[f].type == "A-4E-C" then
						local foundLongRunway = false
						if flight[f].base == "Rovaniemi" then
							fuelTemp = fuelTemp * 0.65
						elseif db_airbases[flight[f].base].runways then
							for wayN, runwayData in pairs(db_airbases[flight[f].base].runways) do
								if runwayData.length then
									if runwayData.length > 2700 then
										foundLongRunway = true
										break
									end
								else
									--si la longueur n'est pas renseignée, on suppose que c'est bon
									foundLongRunway = true
								end
							end
							if not foundLongRunway then
								fuelTemp = fuelTemp * 0.65
							end
						end
					end

					--generation du name
					local unitName = groupName .. "-" .. n
					local unitIdTemp = 1
					if not UnitByName[unitName] then
						unitIdTemp = GenerateIDUnit(unitName, flight[f]["type"])
					else
						unitIdTemp = UnitByName[unitName]
					end

					if unitIdTemp == 1 then
						print("bug unitName: "..tostring(unitName))
						_affiche(UnitByName, "UnitByName: ")
						os.execute 'pause'
					end

					if flight[f].route[1].id == "Spawn" and flight[f].task == "Refueling" then

						waypoints[1].x, waypoints[1].y = addAndSpaceTankers(groupName, waypoints[1].x, waypoints[1].y)

					end

					--position de départ
					local define_x = waypoints[1]["x"]
					local define_y = waypoints[1]["y"]

					if is_helicopter and waypoints[1]["action"] ~= "From Ground Area" then --and baseIsFARP n >= 2 and
						define_x = waypoints[1]["x"] + ((n - 1) * 15) +  ((f-1) * 15) + ((p - 1) * 15) -- ATO_FP_Debug01	--ANTI-COLLISION B
						define_y = waypoints[1]["y"] + ((n - 1) * 15) +  ((f-1) * 15) + ((p - 1) * 15) --ATO_FP_Debug01 	--ANTI-COLLISION B
					end

					-- Calculate aircraft orientation for air starts from WP1 -> WP2 direction
					local heading = 0
					local psi = 0

					if waypoints[2] and waypoints[1].type == "Turning Point" and waypoints[1].action == "Turning Point" then

						local dx = waypoints[2].x - waypoints[1].x
						local dy = waypoints[2].y - waypoints[1].y

						heading = math.atan2(dx, dy)
						psi = -heading
					end

					units[n] =
					{
						["alt"] = waypoints[1].alt,
						["heading"] = heading,
						["psi"] = psi,
						["callsign"] = getCallsign(flight[f].country, flight[f], flight[f].task, f, n),
						["livery_id"] = flight[f].livery,
						["type"] = flight[f].type,
						["x"] = define_x ,
						["y"] = define_y ,
						["name"] = unitName,
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
							[typeDatalink] = DeepCopy(datalinks[typeDatalink][flight[f].type])
						}
					end

					--ajout les restrictions au loadout s il y en a
					if isHumain then
						for typeAircraft, payloadProhibited in pairs(PayloadRestricted) do
							if typeAircraft and payloadProhibited and flight[f]["type"] == typeAircraft then
								units[n].payload.restricted = payloadProhibited
							end
						end
					end

					--FARP parking id
					-- if baseIsFARP and waypoints[1].action ~= "Spawn" then
					if waypoints[1].action ~= "Spawn" and is_helicopter and not db_airbases[flight[f].base].BaseAirStart then

						if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP limitedParkTiming C1 "..tostring(limitedParkTiming).." flight[f][parkAlertSAR]: "..tostring(parkSarAirBase[flight[f].base])) end

						if not parkSarAirBase[flight[f].base] then
							
							if flight[f].parking_id then
								if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP limitedParkTiming C2 ") end

								local parkParameters = GetParkingId( flight[f].parking_id, flight[f].base)

								if parkParameters then
									units[n]["parking_id"] = parkParameters
								end

							elseif not limitedParkTiming then
								if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP limitedParkTiming C3 ") end

								units[n]["parking"] = tostring(n)
								units[n]["parking_id"] = tostring(n)
							end

						elseif parkSarAirBase[flight[f].base] then
							if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP limitedParkTiming C4 n: "..n) end

							if n==1 then
								waypoints[1]["action"] = "From Ground Area"
								waypoints[1]["type"] = "TakeOffGround"
								waypoints[1].airdromeId = nil
								waypoints[1].linkUnit = nil
								waypoints[1].helipadId = nil

								if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP limitedParkTiming C5 action: "..waypoints[1]["action"]) end

								--on le fait reposer au meme endroit:
								waypoints[#waypoints]["action"] = "Landing"
								waypoints[#waypoints]["type"] = "Land"
							end

							local nParkSar = getParkSarAirBase(flight[f])
							if nParkSar then
								units[n].x = parkSarAirBase[flight[f].base][nParkSar].x
								units[n].y = parkSarAirBase[flight[f].base][nParkSar].y
							else
								waypoints[1]["action"] = "Turning Point"
								waypoints[1]["type"] = "Turning Point"

								if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP_FARP parking id ~= Spawn = { Turning Point ") end	

							end



							--supprime les clefs parking et parking_id s'ils existe dans les tables units
							if units[n].parking then
								units[n].parking = nil
							end
							if units[n].parking_id then
								units[n].parking_id = nil
							end

						end
					end
						

					local pers_ACFT_bool = nil
					local pers_ACFT_prefixFileName = nil
					units[n]["onboard_num"], pers_ACFT_prefixFileName, pers_ACFT_bool = GetSidenumber(flight[f], n)	--get new sidenumber

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

						if Data_AddPropAircraft[type_withProp]  then
							--ajoute AddPropAircraft aux types joueur/client
							units[n]["AddPropAircraft"] = DeepCopy(Data_AddPropAircraft[type_withProp])

							if isHumain then
								-- print("passe C10 isHumain")
								if Data_divers[type_withProp] and Data_divers[type_withProp].alignment_PropAircraft and Data_divers[flight[f].type].alignment_PropAircraft[mission_ini.alignment_Mode] then

									--règle la/les valeurs des variables de vitesse d'alignement dans la table AddPropAircraft 
									for key, value in pairs(Data_divers[type_withProp].alignment_PropAircraft[mission_ini.alignment_Mode]) do
										units[n]["AddPropAircraft"][key] = value
									end

								end

								if pers_ACFT_bool then
									units[n]["AddPropAircraft"]["PersistentAircraftKey"] = pers_ACFT_prefixFileName.."_"..units[n]["onboard_num"]
									units[n]["AddPropAircraft"]["UseReferenceAircraft"] = 2
								end


							else
								if pers_ACFT_bool then
									units[n]["AddPropAircraft"]["PersistentAircraftKey"] = ""
									units[n]["AddPropAircraft"]["UseReferenceAircraft"] = 0 --0 random/default? (Quality & Wear variable is used)
								end
								if units[n]["CombatTreeSpoofable"] then
									units[n]["CombatTreeSpoofable"] = 2	-- AI use default CombatTree
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
						units[n]["dataCartridge"] = 	DeepCopy(dataCartridge)
					end



					--remove gun ammunition from AI escorts to prevent them from strafing aircraft on the ground at hostile air bases
					-- if (flight[f].task == "Escort" and not flight[f].player ) and (flight[f].task == "Escort" and not flight[f].client ) then	--if fligh is taskes as escort and is not player flight
					if flight[f].task == "Anti-ship Strike" and not isHumain then	--or Multi.NbGroup >= 1
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

					local typeDatalink = DeepCopy(Data_divers[flight[f].type].datalinks.type)

					--récupere les id des autres membres du group
					local recordId = {}
					for n=1, #units do
						recordId[n] = units[n].unitId
					end

					if typeDatalink == "Link16" or typeDatalink == "SADL" then
						local isDonnor = Data_divers[flight[f].type].datalinks.isDonnor
						local isReceiver = Data_divers[flight[f].type].datalinks.isReceiver

						for n=1, #units do
							local copyRecordId = DeepCopy(recordId)

							if not units[n].AddPropAircraft then
								--essentielement pour les donnors
								units[n].AddPropAircraft = DeepCopy(AddPropAircraft_datalinks[typeDatalink])
							else
								for keyA, valueA in  pairs(AddPropAircraft_datalinks[typeDatalink]) do
									if not units[n].AddPropAircraft[keyA] then
										units[n].AddPropAircraft[keyA] = DeepCopy(valueA)
									end
								end
							end

							if units[n]["AddPropAircraft"]["STN_L16"] then
								--essentielement pour les donnors HA BON?
								units[n]["AddPropAircraft"]["STN_L16"] =  Get_L16_Id()
								pack_L16_unitId[p] = pack_L16_unitId[p] or {}
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
								if typeDatalink == "SADL" or (flight[f]["type"] == "F-16C_50" ) then
									if  n == 1 then
										units[n].datalinks[typeDatalink].settings.flightLead = true
									else
										units[n].datalinks[typeDatalink].settings.flightLead = false
									end
								end

							end

					
						end
					elseif typeDatalink == "IDM" then
						for n=1, #units do
							local copyRecordId = DeepCopy(recordId)
							if not units[n].AddPropAircraft then
								--essentielement pour les donnors
								units[n].AddPropAircraft = DeepCopy(AddPropAircraft_datalinks[typeDatalink])
							else
								for keyA, valueA in  pairs(AddPropAircraft_datalinks[typeDatalink]) do
									if not units[n].AddPropAircraft[keyA] then
										units[n].AddPropAircraft[keyA] = DeepCopy(valueA)
									end
								end
							end

							if units[n]["AddPropAircraft"]["TN_IDM_LB"] then

								units[n]["AddPropAircraft"]["TN_IDM_LB"] = tostring(get_IDM_Id())
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
				-------- define group -----
				-------- define group -----

				local taskOrHuman = isHumain and "player" or flight[f].task

				if HumainPack[p] then
					taskOrHuman = "playerInPackage"
					type_withData = HumainPack[p].humainTypePlane
				end


				local DCE_FreqFlight = GetFrequencyNG(sideName, nil , taskOrHuman, flight[f].type, nil, "FreqFlight", groupName)			
				local DCE_FreqPackage = GetFrequencyNG(sideName, flight[f].target_name, taskOrHuman, flight[f].type, nil, "FreqPackage", groupName)

				if not DCE_FreqPackage or DCE_FreqPackage == nil then
					-- print("AtoFP ERROR, no DCE_FreqPackage "..flight[f].type)
					AddLog("AtoFP ERROR, no DCE_FreqPackage for "..flight[f].type)
					-- os.execute 'pause'
				end

				if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe waypoints[1][x] AA "..tostring(waypoints[1]["x"])) end

				local goupTask = flight[f].task
				if flight[f].type == "SH-3D" and flight[f].task == "Transport" then
					goupTask = "CAS"
				end

				local group =
				{
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
					["name"] = groupName,
					['communication'] = true,
					['x'] = waypoints[1]["x"],
					['y'] = waypoints[1]["y"],
					['start_time'] = start_time or 1,
					['task'] = goupTask,
					['uncontrolled'] = false,
					['DCE_targetName'] = flight[f].target_name,
					['DCE_FreqFlight'] = DCE_FreqFlight,
					['frequency'] = DCE_FreqPackage,

				}

				if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe group[x] BB "..tostring(group["x"]).." "..tostring(group["route"]["points"][1]["action"])) end

				flight[f].groupId = group.groupId

				--ajoute la frequence à l AFAC
				if flight[f].task == "AFAC"  then
					for w=1, #waypoints do
						if waypoints[w]["task"] and waypoints[w]["task"]["params"] and waypoints[w]["task"]["params"]["tasks"] then
							for i_task, _task in pairs(waypoints[w]["task"]["params"]["tasks"]) do
								if _task and _task.id and _task.id == "FAC" then
									_task.params.frequency = DCE_FreqPackage * 1000000
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

				if waypoints[1]["briefing_name"] == "Spawn" and db_airbases[flight[f].base].BaseAirStart and waypoints[1].ETA > 5 then
					group["start_time"] = waypoints[1].ETA
				end

				-- decale les apparitions en vol pour eviter les collisions en vol
				if waypoints[1]["type"] == "Turning Point" and waypoints[1]["briefing_name"] == "Spawn" and not flight[f].task == "AFAC"  then
					local spacing = 330 -- Mets ici la distance minimale souhaitée (en mètres)
					for n = 1, #group.units do
						group.units[n].x = ((p-1) * spacing/1.2) + ((f-1) * spacing) + group.units[n].x + (spacing * n) 	--ANTI-COLLISION C
						group.units[n].y = ((p-1) * spacing/1.2) + ((f-1) * spacing) + group.units[n].y + (spacing * n) 	--ANTI-COLLISION C
						group.units[n].alt = ((p-1) * spacing/1.2) + ((f-1) * spacing) + waypoints[1]["alt"] + (spacing * n) 	--ANTI-COLLISION C
					end

					waypoints[1].x = group.units[1].x
					waypoints[1].y = group.units[1].y
					group.x = group.units[1].x
					group.y = group.units[1].y
				end

				-- modif M17
				if flight[f]["type"] == "F-14B" and navTargetPoints[1] then
					 group["NavTargetPoints"]= navTargetPoints
				end


				--======================================
				group['task'] = goupTaskTemp

				---- unhide player package -----
				if mission_ini.cheat_Mod_Eye  then																--debug is on
					group.hidden = false														--unhide all groups
				elseif camp.player and camp.player.side == sideName then							--player side										
					group.hidden = false														--unhide group
					--if camp.player.pack_n == p then											--package is player package
						--group.hidden = false													--unhide group
					--elseif flight[f].task == "AWACS" then										--flight is an AWACS on player side
						--group.hidden = false													--unhide group
					--elseif flight[f].task == "Refueling" then									--flight is a tanker on player side
						--group.hidden = false													--unhide group
					--end
				elseif camp.client and flight[f].IdClient and camp.client[flight[f].IdClient].side == sideName then							--player side										
					group.hidden = false														--unhide group
				end

				flight[f].groupName = groupName





				-- modification M31 	Remove all static aircraft from the deck
				if  mission_ini.CV_CleanDeck == true and string.find(flight[f].base,"CV") then
					DeleteStaticOnCV(flight[f].base)
				end

				if not Data_configuration.SC_SpawnOn[flight[f].type] then Data_configuration.SC_SpawnOn[flight[f].type] = "deck" end

				local spawnDeck = true
				local spawnAir = false
				local spawnCata = false

				if baseIsCarrier and not isHumain then
					if Data_configuration.SC_SpawnOn[flight[f].type] == "catapult" then
						spawnDeck = false
						spawnCata = true
					elseif Data_configuration.SC_SpawnOn[flight[f].type] == "air" then
						spawnDeck = false
						spawnAir = true
					end
				end




				--||||||| INFORMATIOn TUTORIAL TUTORIEL

				--||||||| uncontrolled necessite START + a_set_ai_task
				--||||||| lateActivation necessite a_activate_group (par seconde ou flag) 




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

				if (not start_time or start_time == nil or start_time == "") and departure_time ~= "" then
					start_time = departure_time
				end

				local activate_time = start_time
				local flagInsertSixpack  = false

				--limitedParkTiming RAPPEL concerne: CV LHA FARP et Petite BASE, si le nombre de place est superieur à db_airbases.LimitedParkNb				
				----- late groups spawn uncontrolled at mission start -----
				if (( flight[f].task ~= "Intercept" and flight[f].task ~= "SAR") or limitedParkTiming ) and waypoints[1]["type"] ~= "Turning Point" then	--group launches after mission start																	-- calcul le nombre de flight dans un Package, en comptant ceux des Roles				
					if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe AA limitedParkTiming "..tostring(limitedParkTiming)) end

					if baseIsCarrier then			--for groups on aircraft carriers
						if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe BB unitname+FARP "..group['route']['points'][1]["ETA"].." Multi.NbGroup?: "..tostring(Multi.NbGroup).." MultiPlayer.pack_n[p?: ".. tostring(camp.MultiPlayer.pack_n[p]) ) end

						cv_nbPlaneSixPack[flight[f].base] = cv_nbPlaneSixPack[flight[f].base] or 0

						--permet de spawner les avions avant qu'ils ne démarrent
						if start_time - 120	> (mission_ini.startup_time_player + 600) then
							activate_time = start_time - 120
						end

						if SinglePlayer then
							if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe CC SinglePlayer "..tostring(waypoints[1]["type"])) end


							-- = = = SixPack = = = = - = - = - = -- = - = - = - = - = - = - = - = - = - = -- = - =

							--construit une table que l'on triera plus tard pour decider qui a le droit d etre sur le sixpack et ne pas gener les autres
							-- if group['route']['points'][1].ETA < (mission_ini.startup_time_player + 200) and waypoints[1]["action"] ~= "Turning Point" and not spawnAir and not spawnCata then
								-- and flight[f].type ~= "E-2C" and flight[f].type ~= "S-3B Tanker"
							if group['route']['points'][1].ETA < (mission_ini.startup_time_player + 600) and waypoints[1]["action"] ~= "Turning Point" and not spawnAir and not spawnCata then
								if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe DD -- == SixPack == -- ") end

								cv_deckReservations[flight[f].base] = cv_deckReservations[flight[f].base] or {}

								local isProcessed = false
								--sur le porte avion du joueur
								if carrierPlayer.carrierName and carrierPlayer.carrierName == flight[f].base then
									if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe 6p B "..tostring(carrierPlayer.packN).." ==? p: "..p) end
									
									if carrierPlayer.packN == p then
										if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe 6p C ") end
										
										-- if role ~= "main" and (cv_nbPlaneSixPack[flight[f].base] + flight[f].number <= 4) then
										-- if not flight[f].player and (cv_nbPlaneSixPack[flight[f].base] + flight[f].number <= 4) then
										if not flight[f].player and flight[f].number == 4 and cv_nbPlaneSixPack[flight[f].base] < 4 then
											if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe 6p D ") end
											
											-- local placeTiming = 75 * flight[f].number

											-- cv_deckReservations[flight[f].base][placeTiming] = {
											-- 	groupName = group.name,
											-- 	number = flight[f].number,
											-- 	type = flight[f].type,
											-- 	isHumain = isHumain
											-- }

											local taxiTimePerPlane = 75
											if string.find(flight[f].type, "F-14") then taxiTimePerPlane = 110 end
											local duration = (flight[f].number * taxiTimePerPlane) + 120  --120 s necessaire pour le demarrage avant le taxiage


											table.insert(cv_deckReservations[flight[f].base],{
												start = 0,
												finish = duration,
												groupName = group.name
											})

											start_time = 0
											group.start_time = 0
											waypoints[1].ETA = 0
											cv_nbPlanetDeck = cv_nbPlanetDeck + flight[f].number
											cv_nbPlaneSixPack[flight[f].base] = cv_nbPlaneSixPack[flight[f].base] + flight[f].number

											flagInsertSixpack = true
											isProcessed = true
											spawnDeck = true
										end

										if flight[f].player and not flagInsertSixpack then
											if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe 6p E ") end
											
											-- cv_deckReservations déjà reservé en amont de ce script

											start_time = 5 --information courcircuité plus tard pour PlacePA et etiquette
											-- pour un group player, pas de activate_time, le joueur ne peut pas spawner
											-- pour un group player, pas de lateActivation, le joueur ne peut pas spawner
											
											group.start_time = 5
											waypoints[1].ETA = 5
											cv_nbPlanetDeck = cv_nbPlanetDeck + flight[f].number
											isProcessed = true
											spawnDeck = true

											local message = ""
											if mission_ini.startup_time_player - 300 > 0 then
												message = "Your group is due to depart in 5 minutes"
												addMessageForGroup(group.name, mission_ini.startup_time_player - 300, message)
											end
											message = "Your taxiing slot is now"
											addMessageForGroup(group.name, mission_ini.startup_time_player, message)
										
										end
									end
								end

								if not isProcessed then
									if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\nAtoFP passe 6p F (hors sixpack)" end

									local taxiTimePerPlane = 75
									if string.find(flight[f].type, "F-14") then taxiTimePerPlane = 110 end
									local duration = flight[f].number * taxiTimePerPlane

									local placeTiming = findDeckSlot(flight[f].base, duration)

									if placeTiming then

										table.insert(cv_deckReservations[flight[f].base],{
											start = placeTiming,
											finish = placeTiming + duration,
											groupName = group.name
										})

										start_time = placeTiming - 120 --120 s necessaire pour le demarrage avant le taxiage
										activate_time = 10

										spawnDeck = true

										cv_nbPlanetDeck = cv_nbPlanetDeck + flight[f].number

									end
								end
							end

							if carrierPlayer.carrierName and carrierPlayer.carrierName == flight[f].base then
							-- if carrierPlayer.carrierName and carrierPlayer.carrierName == flight[f].base and flight[f].task ~= "AWACS" and flight[f].task ~= "Refueling" then					--for flights in player's package and package does not cover a station and flight[f].task ~= "CAP"
								if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe DD1 carrierName == base start_time: "..tostring(start_time)) end


								--les Planes qui genent le taxiing spawn selon conf_mod
								if not spawnDeck then
									if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe DD2 ") end
									local bugFrom =  ""..debug.getinfo(1).currentline
									-- = SixPack =
									spawnOn(Data_configuration.SC_SpawnOn[flight[f].type], waypoints, group, pn, start_time, bugFrom, flight, f, role)
								end

							-- Spawn en VOL tous les avions du debut de mission qui n'ont pas eu de place
							elseif (group['route']['points'][1].ETA <= mission_ini.startup_time_player + 600) and db_airbases[flight[f].base].LimitedParkNb then																	
								if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe FFa ETA mission_ini.startup_time_player + 600 & LimitedParkNb NbPlanetDeck: "..cv_nbPlanetDeck) end

								if not flagInsertSixpack and flight[f].number + cv_nbPlanetDeck >= db_airbases[flight[f].base].LimitedParkNb  then										-- on ne dépasse pas le nb max de spawn sur le CV 
									if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe FFb  NbPlanetDeck >= LimitedParkNb") end

									local infoFrom =  " NbPlanetDeck >= db_airbases[flight[f].base].LimitedParkNb "..debug.getinfo(1).currentline
									local airSpawnTIme = waypoints[1]["etaSpawn"]
									spawnOn( "air", waypoints, group, pn, airSpawnTIme, infoFrom, flight, f, role)
								end
							end

							--TODO, c'est utile ça?
							-- if limitedParkTiming or db_airbases[flight[f].base].BaseAirStart then
							if db_airbases[flight[f].base].BaseAirStart then
								if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe LLLa BaseAirStart ") end
								local infoFrom =  " limitedParkTiming or BaseAirStart "..debug.getinfo(1).currentline

								local airSpawnTIme = waypoints[1]["etaSpawn"]
								spawnOn( "air", waypoints, group, pn, airSpawnTIme, infoFrom, flight, f, role)
								--TODO vérifier si c'est utile:
								modify_Activate_GroupTime(group, airSpawnTIme - 1, debug.getinfo(1).currentline)

							end

							--au final, Start+Activate si le flight ne spawn sur le deck
							--***********************************INSCRIPT CORRECT DANS LA MISSION***********************************
							--***********************************INSCRIPT CORRECT DANS LA MISSION***********************************
							--***********************************INSCRIPT CORRECT DANS LA MISSION***********************************
							if waypoints[1]["action"] ~= "Turning Point" and not flagInsertSixpack and not isHumain then

								if not activate_time then
									AddLog("AtoFP not activate_time A")
								end
								group.start_time = start_time
								waypoints[1].ETA = start_time
								activate_group_time_after(group, activate_time, debug.getinfo(1).currentline )	-- = - = - = - = -- = - = - = - = - = - = - = - = - = - = --															
								start_Set_Ai_Task(group, start_time, nil, debug.getinfo(1).currentline)			-- = - = - = - = -- = - = - = - = - = - = - = - = - = - = --

								if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP spawnDECK + not flagInsertSixpack and not isHumain : activate_group_time_after() + start_Set_Ai_Task start_time: "..tostring(start_time)) end

							end
							--***********************************INSCRIPT CORRECT DANS LA MISSION***********************************
							--***********************************INSCRIPT CORRECT DANS LA MISSION***********************************
							--***********************************INSCRIPT CORRECT DANS LA MISSION***********************************

						-- elseif (Multi.NbGroup >= 1 and not camp.MultiPlayer.pack_n[p]) or SingleWithDServerAiAir then
						elseif (Multi.NbGroup >= 1 and not camp.MultiPlayer.pack_n[p])then	--en multiplayer: aucun décalage sur le pont, puisque tous les IA commencent en vol								
							if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe GG Multi.NbGroup >= 1") end


							if not farp_MorePlace then
								--les Planes qui genent le taxiing spawn selon conf_mod
								if not spawnDeck or baseIsFARP then
									--= SixPack =
									local bugFrom =  " not SpawnDeck "..debug.getinfo(1).currentline
									spawnOn(Data_configuration.SC_SpawnOn[flight[f].type], waypoints, group, pn, start_time + 30, bugFrom, flight, f, role)
									if flagInsertSixpack  then																			--si le vol postulait pour le sixpack, on le supprime de la table
										table.remove(cv_testSixPack[flight[f].base])
										flagInsertSixpack  = false
										for forTiming, value in pairs(cv_deckReservations[flight[f].base]) do
											if value == group.name then
												cv_deckReservations[flight[f].base][value] = nil
											end
										end
									end
								end

								--au final, Start+Activate si le flight ne spawn sur le deck
								if waypoints[1]["action"] ~= "Turning Point" then
									-- group['lateActivation'] = true	 --sera fait dans activate_group_time_after()
									-- group['uncontrolled'] = true		--sera fait dans start_Set_Ai_Task()
									activate_group_time_after(group, activate_time, debug.getinfo(1).currentline )	-- = - = - = - = -- = - = - = - = - = - = - = - = - = - = --															
									start_Set_Ai_Task(group, start_time, nil,  debug.getinfo(1).currentline)			-- = - = - = - = -- = - = - = - = - = - = - = - = - = - = --
									if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP spawnDECK + activate_group_time_after() + start_Set_Ai_Task start_time: "..tostring(start_time)) end
								end
							end
						end


						--permet de faire apparaitre sur CV des planes qui decolleront plus tard, mais qui ont de la place pour apparaitre sur le pont des le début de mission
						--cela habille et occupe le  pont
						-- la decision sera prise en bas, en parsant le tableau testDeckPlace
						-- if group['route']['points'][1]["type"] ~= "Turning Point" and not flagInsertSixpack and not SingleWithDServerAiAir then
						if group['route']['points'][1]["type"] ~= "Turning Point" and not flagInsertSixpack then
							
							if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe GGa  table.insert(testDeckPlace |start_time: "..tostring(start_time)) end

							tempDeckPlace = {
								-- time = group['route']['points'][1].ETA ,
								time = start_time,
								groupName = group.name,
								number = flight[f].number,
								LimitedParkNb = db_airbases[flight[f].base].LimitedParkNb,
								isHumain = isHumain,
								}

							-- flagInsertSixpack  = true
							if not testDeckPlace[flight[f].base] then testDeckPlace[flight[f].base] = {} end
							table.insert(testDeckPlace[flight[f].base],  tempDeckPlace)
						end

					------------------	
					--SUR PISTE DUR---
					------------------	
					elseif (flight[f].task ~= "Intercept" and flight[f].task ~= "SAR" and not parkSarAirBase[flight[f].base]) then
						if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe II SUR PISTE DUR") end

						if not isHumain then
							if limitedParkTiming or db_airbases[flight[f].base].BaseAirStart then
								group['lateActivation'] = true
								group['uncontrolled'] = false
								if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe LLLb limitedParkTiming OR BaseAirStart ") end
								local infoFrom =  " limitedParkTiming or BaseAirStart "..debug.getinfo(1).currentline
								local airSpawnTIme = waypoints[1]["etaSpawn"] or waypoints[1]["ETA"]
								spawnOn( "air", waypoints, group, pn, airSpawnTIme, infoFrom, flight, f, role)
								--TODO vérifier si c'est utile:
								modify_Activate_GroupTime(group, airSpawnTIme - 1, debug.getinfo(1).currentline)


							elseif group.route.points[1].action ~= "Turning Point" then

								group['lateActivation'] = false

								start_Set_Ai_Task(group, start_time, nil,  debug.getinfo(1).currentline)			-- = - = - = - = -- = - = - = - = - = - = - = - = - = - = --
								if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP arg_group['uncontrolled']: "..tostring(group['uncontrolled'])) end
							end
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

				if (flight[f].task == "SAR" and conditionUno) then			--or flight[f].task == "CSAR" 		
					camp.SAR.Flag = camp.SAR.Flag + 1								--go to next trigger flag number					

					--parkSarAirBase
					if parkSarAirBase[flight[f].base] then

						local pkFound = false
						local nPk = 0

						--premier passage, on se positionne sur les places reservées, si elles existent
						for parkN, park in pairs(parkSarAirBase[flight[f].base]) do
							if park.reservedSAR and not park.occupied then
								park.occupied = true
								nPk = parkN
								pkFound = true
								break
							end
						end

						if not pkFound  then
							local nLoop = 1
							repeat
							nPk = math.random(1, #parkSarAirBase[flight[f].base])

								if not parkSarAirBase[flight[f].base][nPk].occupied or parkSarAirBase[flight[f].base][nPk].occupied == false then
									parkSarAirBase[flight[f].base][nPk].occupied = true
									pkFound = true
								end
								nLoop = nLoop + 1
							until nLoop > 200 or pkFound
						end

						if pkFound then

							waypoints[1]["action"] = "From Ground Area"
							waypoints[1]["type"] = "TakeOffGround"

							waypoints[1].airdromeId = nil
							waypoints[1].linkUnit = nil
							waypoints[1].helipadId = nil

							group.units[1].x = parkSarAirBase[flight[f].base][nPk].x
							group.units[1].y = parkSarAirBase[flight[f].base][nPk].y

							group.x = parkSarAirBase[flight[f].base][nPk].x
							group.y = parkSarAirBase[flight[f].base][nPk].y

							waypoints[1].x = parkSarAirBase[flight[f].base][nPk].x
							waypoints[1].y = parkSarAirBase[flight[f].base][nPk].y

							--supprime les clefs parking et parking_id s'ils existe dans les tables units
							for unitN, unit in pairs(group.units) do
								if unit.parking then
									unit.parking = nil
								end
								if unit.parking_id then
									unit.parking_id = nil
								end
							end
						end
					end

					--ajuste l'altitude des helico en zone montagneuse, ils ont beaucoup de mal en alti radar
					for n = 1, #waypoints do
						if waypoints[n]["type"] == "Land" then
							waypoints[n]["action"] = "LandingReFuAr"
							waypoints[n]["type"] = "LandingReFuAr"
						end
					end

					if ( flight[f].client ~= true and flight[f].player ~= true)  then	--or limitedParkTiming or parkSarAirBase[flight[f].base]						-- M11 PVP ne copie pas de trigger retardé START pour les clients/joueurs	

						if (baseIsCarrier or limitedParkTiming or db_airbases[flight[f].base].BaseAirStart) and not farp_MorePlace  then

							local infoFrom =  " SAR sur CV et parking limité spawn en vol "..debug.getinfo(1).currentline

							activate_Group_WithFlag(group, camp.SAR.Flag, debug.getinfo(1).currentline )	-- = - = - = - = -- = - = - = - = - = - = - = - = - = - = --	

							spawnOn( "air", waypoints, group, pn, 0, infoFrom, flight, f, role)

							if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe activate 03") end

						else

							if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP tasks_Start "..tostring(debug.getinfo(1).currentline)) end

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

						if (baseIsCarrier or limitedParkTiming or db_airbases[flight[f].base].BaseAirStart) and not farp_MorePlace  then

							local infoFrom =  " SAR sur CV et parking limité spawn en vol "..debug.getinfo(1).currentline
							spawnOn( "air", waypoints, group, pn, 0, infoFrom, flight, f, role)

							-- group['lateActivation'] = true											--make group late activation "en vol"
							-- group['uncontrolled'] = false
							-- group['tasks'] = {}

							-- mission.trig.actions[trig_n] = "a_activate_group(" .. group.groupId .. "); mission.trig.func[" .. trig_n .. "]=nil;"
							-- mission.trigrules[trig_n]['actions'][1] = {
							-- 	["group"] = group.groupId,
							-- 	["predicate"] = "a_activate_group",
							-- }

							if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP passe activate 03") end
						end
					end

					if not IsHelicopter[flight[f].type] then
						print("BUG no IsHelicopter[flight[f].type] "..flight[f].type)
						os.execute 'pause'
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
						hHover = IsHelicopter[flight[f].type].hHover or 1500,
					}

					if camp.SAR.alertSAR[sideName].base[flight[f].base] == nil then
						camp.SAR.alertSAR[sideName].base[flight[f].base] = {
							ready = {},
						}
					end

					if isHumain then										-- M11 multiplayer, les joueurs sont ajouté dans la base ready pour ne pas attendre 
						table.insert(camp.SAR.alertSAR[sideName].base[flight[f].base].ready, t)
					else
						table.insert(camp.SAR.alertSAR[sideName].base[flight[f].base].ready, t)
					end

				end
				----- provisions for interceptors/GCI/AWACS -----
				if flight[f].task == "Intercept" then
					GCI.Flag = GCI.Flag + 1															--go to next trigger flag number					
					if not isHumain then	-- and limitedParkTiming							-- M11 PVP ne copie pas de trigger retardé START pour les clients/joueurs	

						if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP tasks_Start "..tostring(debug.getinfo(1).currentline)) end

						activate_Group_WithFlag(group, GCI.Flag, debug.getinfo(1).currentline )	-- = - = - = - = -- = - = - = - = - = - = - = - = - = - = --	

						--if the group is on a carrier, it gets late activation instead of uncontrolled. An activate trigger is needed instead of AI task trigger.
						-- Les inter sur CV et parking limité spawn en vol
						if (baseIsCarrier or limitedParkTiming or db_airbases[flight[f].base].BaseAirStart) and waypoints[1]["type"] ~= "Turning Point" then

							local infoFrom =  " IA intercept "..debug.getinfo(1).currentline
							spawnOn( "air", waypoints, group, pn, 0, infoFrom, flight, f, role)

							--**
							-- local trig_n = Missionfunc + #mission.trig.funcStartup + 1										--next available trigger number
							-- local trig_n =  #mission.trig.actions + 1
							-- mission.trig.actions[trig_n] = "a_activate_group(" .. group.groupId .. "); mission.trig.func[" .. trig_n .. "]=nil;"
							-- mission.trigrules[trig_n]['actions'][1] = {
							-- 	["group"] = group.groupId,
							-- 	["predicate"] = "a_activate_group",
							-- }

							--**

							-- mission.trigrules[trig_n] = {
							-- 	['rules'] = {
							-- 		[1] = {
							-- 			["seconds"] = arg_SpawnTime,
							-- 			["predicate"] = "c_time_after",
							-- 		},
							-- 	},
							-- 	['eventlist'] = '',
							-- 	['comment'] = 'Trigger ' .. trig_n,
							-- 	['predicate'] = 'triggerOnce',
							-- 	['actions'] = {
							-- 		[1] = {
							-- 			["group"] = group.groupId,
							-- 			["predicate"] = "a_activate_group",
							-- 		},
							-- 	}
							-- }

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
					if GCI.Interceptor[sideName].base[flight[f].base] == nil then
						local targetPlane = flight[f].target.targetPlane
						GCI.Interceptor[sideName].base[flight[f].base] = {
							ready30 = {},
							ready15 = {},
							ready15_n = 0,
							ready = {},
							ready_n = 0,
							targetPlane = targetPlane,
							assign_index = 1  -- New variable to track insertion index
						}
					end

					-- Assign the plane to a table based on the assign_index
					local base = GCI.Interceptor[sideName].base[flight[f].base]

					if isHumain then
						-- Always prioritize the `ready` table for player-controlled flights
						table.insert(base.ready, t)
						base.ready_n = base.ready_n + 1
						HumainInterceptor = true
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

				elseif flight[f].task == "AWACS" then
					GCI.EWR[sideName][units[1].name] = true											--add AWACS to EWR table
				end

				if flight[f].task == "SAR" and (pedroOK[flight[f].base] == nil and db_airbases[flight[f].base].unitname) then

					--recherche le nombre de wpt du CV pour que le pedro le suive
					local pedroLinkCV = {}
					local breakFlag = false
					for _, coal in pairs(mission.coalition) do
						for _, country in pairs(coal.country) do
							if country.ship then
								for _, mGroup in pairs(country.ship.group) do
									for w = 1, #mGroup.units do
										if mGroup.units[w].name and mGroup.units[w].name == db_airbases[flight[f].base].unitname then

											pedroLinkCV = {
												Gname = mGroup.name,
												Uname = mGroup.units[w].name ,
												id_group = mGroup.groupId,
												id_unit = mGroup.units[w].unitId,
												x = mGroup.units[w].x,
												y = mGroup.units[w].y,
												startTime = mGroup.start_time,
												nbWPT = #mGroup.route.points,
												frequency = mGroup.units[w].frequency/1000000,
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
					if Data_configuration.SC_SpawnOn["Pedro"] == "deck" and playerTask ~= "Intercept"  then
						-- action = "From Parking Area"
						-- type = "TakeOffParking"
						action =  "From Parking Area Hot"
						type = "TakeOffParkingHot"
						alt = 0
						pos.x = pedroLinkCV.x
						pos.y = pedroLinkCV.y
						onCV = true
					elseif  Data_configuration.SC_SpawnOn["Pedro"] == "catapult" and playerTask ~= "Intercept" then
						action =  "From Runway"
						type = "Turning TakeOff"
						alt = 0
						pos.x = pedroLinkCV.x
						pos.y = pedroLinkCV.y
						onCV = true
					else
						action =  "Turning Point"
						type = "Turning Point"
						alt = 60
						pos.x = pedroLinkCV.x + 100
						pos.y = pedroLinkCV.y + 100
						if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFP_PEDRO or not = { Turning Point ") end	
					end

					group.units[1].alt = alt
					group.units[1].speed = 41.7
					group.units[1].x = pos.x
					group.units[1].y = pos.y
					group.units[1].name = "Unit_Pedro_"..pedroLinkCV.Uname.."_1"

					group.x = pos.x
					group.y = pos.y
					group.name = "Group_Pedro_"..pedroLinkCV.Uname.."_1"
					group.frequency = pedroLinkCV.frequency
					group.start_time = 0

					start_time = 0

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
										["name"] = "Follow : (id == SAR) wpt1",
										["number"] = 1,
										["params"] =
										{
											["lastWptIndexFlagChangedManually"] = true,
											["groupId"] =   pedroLinkCV.id_group,
											["lastWptIndex"] = pedroLinkCV.nbWPT,
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
						["ETA"] = pedroLinkCV.startTime,
						["ETA_locked"] = true,
						["y"] =  pos.y,
						["x"] =  pos.x,
						["formation_template"] = "",
						["speed_locked"] =  true,
					}

					if onCV then
						waypoints[1].linkUnit = pedroLinkCV.id_unit
						waypoints[1].helipadId = pedroLinkCV.id_unit
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
										["name"] = "Follow : (id == SAR) wpt2",
										["number"] = 1,
										["params"] =
										{
											["lastWptIndexFlagChangedManually"] = true,
											["groupId"] = pedroLinkCV.id_group,
											["lastWptIndex"] = pedroLinkCV.nbWPT,
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
						["ETA"] = pedroLinkCV.startTime + 60,
						["ETA_locked"] = false,
						["y"] = pos.y + 300,
						["x"] = pos.x + 300,
						["formation_template"] = "",
						["speed_locked"] =  true,
					}

					pedroOK[flight[f].base] = true
				end




				-- si multijoueur, les Flight AI commencent en vol + M11.j
				-- if ((Multi.NbGroup >= 1 or SingleWithDServerAiAir) and not isHumain and baseIsCarrier and flight[f].task ~= "Intercept") then
				if (Multi.NbGroup >= 1 and not isHumain and baseIsCarrier and flight[f].task ~= "Intercept") then
					if waypoints[1]["type"] ~= "Turning Point" then 					-- si le vol a deja ete deplace pour un commencement en vol, on ne recommence pas le d�calage lat�ral
						local infoFrom =  " si multijoueur, les Flight AI commencent en vol "..debug.getinfo(1).currentline

						if not start_time or start_time == nil then
							DebugFLIGHT = DebugFLIGHT .. "\n".."Error group No spawn_time "..group.name
						end

						-- spawnOn( "air", waypoints, group, pn, waypoints[1]["ETA"], infoFrom, flight, f, role)

						local airSpawnTIme = waypoints[1]["etaSpawn"] or waypoints[1]["ETA"]
						spawnOn( "air", waypoints, group, pn, airSpawnTIme, infoFrom, flight, f, role)
						-- modify_Activate_GroupTime(group, spawn_time - 1, debug.getinfo(1).currentline)
						--TODO supprimer le start_Set_Ai_Task START
						modify_Activate_GroupTime(group, airSpawnTIme - 1, debug.getinfo(1).currentline)
					end


				elseif (flight[f]["type"] == 'F-14B' or flight[f]["type"] == 'FA-18C_hornet') and flight[f].client
					and baseIsCarrier and flight[f].task ~= "Intercept" then

					if not waypoints[1]['linkUnit'] then waypoints[1]['linkUnit'] = waypoints[#waypoints]['linkUnit'] end
					if not waypoints[1]['helipadId'] then waypoints[1]['helipadId'] = waypoints[#waypoints]['helipadId'] end

				end

				-- initie et place dans la table PlacePA les horaires "esperés" de catapultage
				if group['route']['points'][1]["type"] ~= "Turning Point" then

					PlacePA[sideName] = PlacePA[sideName] or {}
					PlacePA[sideName][flight[f].base] = PlacePA[sideName][flight[f].base] or {}

					local suffixePlayer = "."
					if flight[f].player == true then suffixePlayer = " - Player" end
					if flight[f].client == true then suffixePlayer = " - Client" end

					local etiquette = "Pack " .. p .. " - "..flight[f].number.." "..AliasTypeName(flight[f].type).. " - " .. flight[f].name .." - " .. flight[f].task .." ".. f.. suffixePlayer

					local testST
					if isHumain then
						testST = mission_ini.startup_time_player
						-- etiquette = etiquette .. " (start_time)"
					elseif (baseIsCarrier or db_airbases[flight[f].base].helipadId) then
						if start_time then
							-- testST =  start_time - 120
							testST = start_time + 120
							-- etiquette = etiquette .. " (start_time)"
						else
							testST = departure_time + 120
							-- etiquette = etiquette .. " (else departure_time)"
						end
					else
						testST = departure_time
						-- etiquette = etiquette .. " (not Carrier, departur_time)"
					end

					-- testST =  spawn_time	- 120						--	+ 200					-- ajoute 200s, cela correspond au roulage apres activatin (donc demarrage)													
					if not testST then testST = 0 end

					if (baseIsCarrier or db_airbases[flight[f].base].helipadId) then
						--todo fini l'ordre de décollage sur cata
						repeat
							testST = testST + 1
						until not PlacePA[sideName][flight[f].base][testST]
					end

					PlacePA[sideName][flight[f].base][testST] = etiquette

				end


				-- if SinglePlayer and flight[f].player and not SingleWithDServer then
				if SinglePlayer and flight[f].player then
					local unitPlayer = flight[f].unitPlayer or 1
					units[unitPlayer]["skill"] = "Player"										--make first aircraft in flight the player aircraft

				-- modification M11.l : Multiplayer
				-- elseif isHumain and not SingleWithDServer then
				elseif isHumain then
					local boucleNbPlaneClient
					if flight[f].NbPlaneClient > 4 then
						boucleNbPlaneClient = 4
					else
						boucleNbPlaneClient = flight[f].NbPlaneClient
					end
					for i=1, boucleNbPlaneClient do
						units[i]["skill"] = "Client"
					end

					-- waypoints[1]["ETA"] = 0													-- Place l'heure d'apparition au lancement de mission, pour avoir plus de temps...^^	

					--ATTENTION ce qui suit plus bas pose un pb sur les FARP a une place
					-- --ne change pas le type de decollage d'une position SAR (from ground)
					-- if waypoints[1]["type"] ~= "TakeOffGround" then
					-- 	waypoints[1]["type"] = "TakeOffParking"
					-- 	waypoints[1]["action"] = "From Parking Area"							--TODO pourquoi je l'avais enlevé déjà????
					-- end

					if db_airbases[flight[f].base].elevation then
						waypoints[1]["alt"] = 500 + db_airbases[flight[f].base].elevation
					end

					-- if baseIsCarrier or (flight[f].airdromeId and flight[f].airdromeId >= 100 and not parkSarAirBase[flight[f].base]) then									--airbase is a carrier
					-- 	waypoints[1].linkUnit = flight[f].airdromeId						--Debug_l
					-- 	waypoints[1].helipadId = flight[f].airdromeId
					-- else
					-- 	waypoints[1]["airdromeId"] = flight[f].airdromeId
					-- end

					DebugFLIGHT = DebugFLIGHT .."Passe Player ou Client TakeOffParking"

				-- elseif SingleWithDServer and flight[f].player then
				-- 	units[1]["skill"] = "Client"

				end

				if not units or not units[1] or not units[1].callsign then
					_affiche(units, "AtoFP units")

					_affiche(flight[f], "AtoFP flight[f]")
				end

				if type(units[1].callsign) == "number" then										--Russian style
					ATO[sideName][p][role][f].callsign = units[1].callsign							--store flight callsign in ATO
				else																			--NATO style
					ATO[sideName][p][role][f].callsign = units[1].callsign.name						--store flight callsign in ATO									
				end

				ATO[sideName][p][role][f].frequency = group.frequency								--store package frequency in ATO




				--M11.r ajoute une copie des avions multijoueur commançant en l'air // retab // recovery
				local groupRTB = {}
				if mission_ini.MP_PlaneRecovery and Multi.NbGroup >= 1 and isHumain then

					groupRTB = DeepCopy(group)
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

						groupRTB.route.points[1]["ETA_locked"] = true
						groupRTB.route.points[1]["speed_locked"] = true

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
						groupRTB.route.points[2]["ETA_locked"] = false

					elseif groupRTB.route.points[2] and  groupRTB.route.points[3] then
						-- groupRTB.route.points[1] = groupRTB.route.points[2]

						--cherche le milieu entre le wpt 2 et 3
						direction = GetHeadingDegre(groupRTB.route.points[2], groupRTB.route.points[3])
						local distance = GetDistance(groupRTB.route.points[2], groupRTB.route.points[3]) / 2
						local tempWPT = GetOffsetPoint(groupRTB.route.points[2], direction, distance)

						groupRTB.route.points[1] = groupRTB.route.points[3]

						groupRTB.route.points[1]["speed_locked"] = true
						groupRTB.route.points[1]["ETA_locked"] = true
						groupRTB.route.points[1]['ETA'] = 1
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
						groupRTB.route.points[1]['ETA'] = 10
						groupRTB.route.points[2]["speed_locked"] = false
						groupRTB.route.points[2]["ETA_locked"] = true
					end

					groupRTB.name = "Recovery "..groupRTB.name

					--determine une nouvelle altitude pour ne pas prendre une montagne
					-- modification M11A.t  Multiplayer (t: AltitudeFloor)

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
					end

					if altFloor > -1 then

						if is_helicopter and  groupRTB.route.points[1]["alt"] < altFloor  then
							groupRTB.route.points[1]["alt"] =  altFloor + 20 + ((pn-1) * 20) + (altRole * 5)

						elseif groupRTB.route.points[1]["alt"] < altFloor + 200 then
							groupRTB.route.points[1]["alt"] =  altFloor + 200 + ((pn-1) * 200) + (altRole * 5)
						end
					end

					for n = 1, #groupRTB.units do
						groupRTB.units[n].x =  groupRTB.route.points[1].x + (150 * n)
						groupRTB.units[n].y =  groupRTB.route.points[1].y + (150 * n)
						groupRTB.units[n].heading = direction
					end

					for i=1 , #groupRTB.units do
						local unitId_ = GenerateIDUnit("AtoFP ".."Recovery "..groupRTB.units[i].name, groupRTB.units[i].type)
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

								unit["AddPropAircraft"]["TN_IDM_LB"] =  get_IDM_Id()
								if not pack_IDM_unitId[p] then pack_IDM_unitId[p] = {} end
								table.insert(pack_IDM_unitId[p], unit.unitId)
							end

							--desactive les num precis des avions persistants
							if unit["AddPropAircraft"]["PersistentAircraftKey"] and unit["AddPropAircraft"]["PersistentAircraftKey"]  ~= "" then
								unit["AddPropAircraft"]["PersistentAircraftKey"] = ""
								unit["AddPropAircraft"]["UseReferenceAircraft"] = 0
							end
						end
					end


				end	-- fin RECOVERY

				-- modification M33_e 	Custom Briefing (e: divert/CV possible)
				-- place dans une table les bases proches des WPT
				local TabBaseByWPT = {}
				if isHumain then
					for n = 1, #group.route.points   do
						for baseName, airbase in pairs(db_airbases) do
							if  (not airbase.inactive or airbase.inactive == false) and airbase["side"] == sideName and flight[f].base ~= baseName and not airbase.BaseAirStart and airbase.x then		--airbase.divert and					
								local distance = GetDistance(group.route.points[n], airbase )

								if flight[f]["type"] == "AV8BNA" or baseIsCarrier then

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


					-- creer une table globale en evitant les doublons
					for wp, TabBase in pairs(TabBaseByWPT) do
						-- if flight[f].player then

							if not TabDivert[p] then TabDivert[p] = {} end

							if not TabDivert[p][TabBase.baseName] then
								TabDivert[p][TabBase.baseName] = TabBase.baseName
							end
						-- end
					end
				end


				--ajoute ici les Custom_Altitude car les num de wpt ne change plus
				if is_helicopter and not flight[f].client and not flight[f].player  then
					for n = 2, #group.route.points do

						if group.route.points[n].briefing_name == "Egress" then

							-- local task_entry = {
							-- 	["enabled"] = true,
							-- 	["auto"] = false,
							-- 	["id"] = "WrappedAction",
							-- 	["number"] = #group.route.points[n]["task"]["params"]["tasks"] + 1,
							-- 	["params"] =
							-- 	{
							-- 		["action"] = {
							-- 			["id"] = "Script",
							-- 			["params"] = {
							-- 				["command"] = string.format(
							-- 					"Custom_Altitude('%s', nil, %s)",
							-- 					groupName,
							-- 					tostring(n or 0)
							-- 				),
							-- 			},
							-- 		},

							-- 	},
							-- }
							-- table.insert(group.route.points[n]["task"]["params"]["tasks"], task_entry)

						elseif group.route.points[n].briefing_name == "Assemble" then

							local task_entry = {
								["enabled"] = true,
								["auto"] = false,
								["id"] = "WrappedAction",
								["number"] = #group.route.points[n]["task"]["params"]["tasks"] + 1,
								["params"] =
								{
									["action"] = {
										["id"] = "Script",
										["params"] = {
											["command"] = string.format(
												"Custom_Altitude('%s', nil, %s)",
												groupName,
												tostring(n or 0)
											),
										},
									},

								},
							}
							table.insert(group.route.points[n]["task"]["params"]["tasks"], task_entry)

						end

					end
				end


				------ add group to mission -----
				local foundCountry = false
				local addKeyCoalition
				for c = 1, #mission.coalition[sideName].country do
					-- if mission.coalition[side].country[c].name == flight[f].country then
					if string.lower(mission.coalition[sideName].country[c].name) == string.lower(flight[f].country) then
						addKeyCoalition = c
						foundCountry = true
						if mission.coalition[sideName].country[c].name ~= flight[f].country then
							print("******ATTENTION******, wrong letter case "..tostring(flight[f].country).." into oob_air")
							print()
							flight[f].country = mission.coalition[sideName].country[c].name
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

					if not dataIdKey then
						print("******ATTENTION******, no found dataIdKey with this country: "..tostring(flight[f].country).." ")
						os.execute 'pause'
					end

					if dataIdCountry == nil or dataIdCountry == "" then
						DebugFLIGHT = DebugFLIGHT .. "\n".."Error no found this contry "..tostring(flight[f].country).." into dataCoutrys"
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

					addKeyCoalition = #mission.coalition[sideName].country + 1

					local countryInMission = false
					for n, missionIdCountry in ipairs(mission.coalitions[sideName]) do
						if missionIdCountry == requestCountry.id then
							countryInMission = true
							break
						end
					end

					if not countryInMission then
						-- Supprime l'enregistrement du camp opposé, si celui-ci existe
						if type(mission.coalitions[DCS_ENI_Side[sideName]]) == "table" then
							for n, missionIdCountry in ipairs(mission.coalitions[DCS_ENI_Side[sideName]]) do
								if missionIdCountry == requestCountry.id then
									table.remove(mission.coalitions[DCS_ENI_Side[sideName]], n)
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
						if type(mission.coalitions[sideName]) == "table" then
							table.insert(mission.coalitions[sideName], dataIdCountry)
						end
					end


					mission.coalition[sideName].country[addKeyCoalition] = {
						["name"] = tostring(DataCountry[dataIdKey].name),
						["id"] = dataIdCountry,
					}
				end



				if not is_helicopter then
					if mission.coalition[sideName].country[addKeyCoalition].plane == nil then
						mission.coalition[sideName].country[addKeyCoalition].plane = {
							group = {}
						}
					end
					table.insert(mission.coalition[sideName].country[addKeyCoalition].plane.group, group)

					if flight[f].player == true then
						camp.player.group = DeepCopy(mission.coalition[sideName].country[addKeyCoalition].plane.group[#mission.coalition[sideName].country[addKeyCoalition].plane.group])		--store a link to the player group in mission
					end

					if groupRTB.groupId then
						table.insert(mission.coalition[sideName].country[addKeyCoalition].plane.group, groupRTB)
					end
				else

					if mission.coalition[sideName].country[addKeyCoalition].helicopter == nil then
						mission.coalition[sideName].country[addKeyCoalition].helicopter = {
							group = {}
						}
					end
					table.insert(mission.coalition[sideName].country[addKeyCoalition].helicopter.group, group)

					if flight[f].player == true then
						camp.player.group = DeepCopy(mission.coalition[sideName].country[addKeyCoalition].helicopter.group[#mission.coalition[sideName].country[addKeyCoalition].helicopter.group])		--store a link to the player group in mission
					end

					if groupRTB.groupId then
						table.insert(mission.coalition[sideName].country[addKeyCoalition].helicopter.group, groupRTB)
					end
				end






	--***************************--DEBUG INFO***************************
					--***************************--DEBUG INFO***************************
	--***************************--DEBUG INFO***************************
	--***************************--DEBUG INFO***************************
					--***************************--DEBUG INFO***************************
	--***************************--DEBUG INFO***************************
	--***************************--DEBUG INFO***************************
					--***************************--DEBUG INFO***************************
	--***************************--DEBUG INFO***************************





				local debug_StartTime = group.start_time
				local info01, info02, info03, info04, info05, info06, debugTempFLIGHT = "", "", "", "", "", "", ""
				local nbactivate = 0
				local activateGroupSecondes = nil
				local tagATTENTION, a_activate, a_set_ai_task, c_time, c_flag = false, false, false, false, false
				local task_START = false
				local testtrigrule = {}
				local infoTemp = ""
				local enVol = false

				for n , trigrule in pairs(mission.trigrules) do
					if type(trigrule) == "table" then
						if trigrule.actions and trigrule.actions[1] and trigrule.actions[1].group == group.groupId then
							if trigrule.actions[1]["predicate"] == "a_activate_group" then
								nbactivate = nbactivate + 1
								infoTemp = infoTemp .."|"..n.."|"

								a_activate = true
								testtrigrule = trigrule
								if trigrule.rules[1].predicate == "c_time_after" then
									-- print("AtoFp passe rulesSeconds "..activateSecondes)
									activateGroupSecondes = math.floor(trigrule.rules[1].seconds)
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
									activateGroupSecondes = math.floor(trigrule.rules[1].seconds)
									c_time = true
								elseif trigrule.rules[1].predicate == "c_flag_is_true" then
									c_flag = true
								end
							end
						end
					end
				end

				if group.tasks and group.tasks[1] and group.tasks[1].params.action.id == "Start" then
					task_START = true
				end

				if nbactivate and nbactivate > 1 then
					info06 = info06.."\n".."|+T1|ATTENTION plusieurs ACTIVATE "..infoTemp.."\n"
					tagATTENTION = true
				end

				if task_START then
					if not group.uncontrolled then
						info01 = "\n".."|+T2|ATTENTION MANQUE uncontrolled "..group.groupId.."\n"
						tagATTENTION = true
					end
					-- if waypoints[1]["action"] == "Turning Point" then
					-- 	info01 = info01.."|+|ATTENTION Start en VOL "
					-- end
					if group.route.points[1]["action"] == "Turning Point" then
						info01 = info01.."\n".."|+T3|ATTENTION Start en VOL ".."\n"
						tagATTENTION = true
					end
				end

				if group.route.points[1]["action"] == "Turning Point" then 
					enVol = true
				end

				if group.route.points[1]["action"] == "Turning Point" and (math.abs(group.route.points[1]["ETA"] - group.start_time) > 5) then

					info01 = info01.."\n".."  |+T4|ATTENTION ETA[1] "..tostring(group.route.points[1]["ETA"]).." ~= start_time "..tostring(math.floor(debug_StartTime)).."\n"
					tagATTENTION = true
				end

				if a_set_ai_task and not group.uncontrolled and not enVol then
					info02 = info02.."\n".."  |+T5|SOL/VOL decale mais pas de uncontrolled "..group.groupId.."\n"
					tagATTENTION = true
				end
				if a_set_ai_task and not task_START then
					info02 = info02.."\n".."  |+T5|SOL/VOL decale mais pas de Task START "..group.groupId.."\n"
					tagATTENTION = true
				end

				if group.uncontrolled then
					if enVol then
						info02 = info02.."\n".."  |+T6|ATTENTION uncontrolled inutile, spawn on Air "..group.groupId.."\n"
					elseif task_START then
						if a_set_ai_task then
							if c_time then
								info02 = "SOL/VOL decale_A "..tostring(activateGroupSecondes)
							elseif c_flag then
								info02 = info02.." |VOL decale_B"
							else
								_affiche(testtrigrule, "testtrigrule")
							end
						else
							info02 = info02.."\n".."  |+T5|ATTENTION MANQUE a_set_ai_task: aucun demarrage possible "..group.groupId.."\n"
							tagATTENTION = true
						end
					else
						info02 = info02.."\n".."  |+T6|ATTENTION MANQUE Start "..group.groupId.."\n"
						tagATTENTION = true

						DebugFLIGHT = DebugFLIGHT .. "\n".."AtoFp info02"..info02
					end
				end


				if group.lateActivation then
					if a_activate then
						if c_time and activateGroupSecondes then
							--si c'est sur CV, on peux faire apparaitre (a_activate_group) le plane, avant le démarrage (a_set_ai_task)
							if (debug_StartTime < activateGroupSecondes) and group.route.points[1]["action"] ~= "Turning Point"  then
								info03 = "\n".."|+T7|ATTENTION SECONDES a_activate_group  |activateGrpSecondes "..activateGroupSecondes .."  ~= |start_time: "..debug_StartTime.."\n"
								tagATTENTION = true

							elseif (group.route.points[1]["ETA"] < activateGroupSecondes) then

								info03 = "\n".."|+T8|ATTENTION SECONDES a_activate_group  |activateGrpSecondes"..activateGroupSecondes .."  ~= |ETA: "..tostring(group.route.points[1]["ETA"]).."\n"
								tagATTENTION = true
							else
								info03 = "SOL/VOL decale _A"
							end
						elseif c_flag then
							info03 = "VOL FLAG decale _B"
						else
							info03 = "\n".."|+T9|ATTENTION bug a_activate_group, no c_time, no c_flag "..group.groupId.."\n"
							tagATTENTION = true
						end
					else
						info03 = "|+T10|ATTENTION MANQUE a_activate_group "..group.groupId
						tagATTENTION = true
					end
				end




				-- Chaque waypoint contient sa propre alt, alt_type, speed, et speed_locked.
				-- Quand l’IA se déplace d’un waypoint N vers un waypoint N+1 :
				-- Elle utilise la vitesse définie dans le waypoint N+1 comme consigne pour ce segment de vol.
				-- Idem pour l’altitude : l’IA cherchera à être à l’altitude du waypoint N+1 lorsqu’elle l’atteint.


				--recherche des incoherences de TIMING ETA: #2
				local wptLanding = #group.route.points
				for wtpN, wptData in ipairs(group.route.points) do
					if wtpN < wptLanding - 1 then
						local postWptData = group.route.points[wtpN + 1]
						local distance = GetDistance(wptData, postWptData)
						local calPostETA = distance / (postWptData.speed or 1) + wptData.ETA
						local infoCompl = ""

						if wtpN == 1 and wptData.action ~= "Turning Point" and wptData.baseStartup then
							calPostETA = distance / (postWptData.speed or 1) + (wptData.ETA + wptData.baseStartup)
							infoCompl = " (incl. baseStartup "..tostring(wptData.baseStartup)..")"
						end

						--cherche si un cercle est demandé:
						local diversParamsTiming = false
						local debutParams = ""
						if wptData.task and wptData.task.params and wptData.task.params.tasks then
							for taskN, taskData in pairs(wptData.task.params.tasks) do
								if taskData.params and taskData.params.action and taskData.params.action.params and taskData.params.action.params.command then
									debutParams = taskData.params.action.params.command
									if string.find(debutParams, "OrbitPosition") then
										diversParamsTiming = true
										break
									elseif string.find(debutParams, "Custom_Altitude") then
										diversParamsTiming = true
										break
									end
								end
							end
						end

						if postWptData.task and postWptData.task.params and postWptData.task.params.tasks then
							for taskN, taskData in pairs(postWptData.task.params.tasks) do
								if taskData.params and taskData.params.task and taskData.params.task.params and taskData.params.task.params.pattern then
									if taskData.params.task.params.pattern == "Circle" then
										diversParamsTiming = true
										break
									end
								end
							end
						end

						if wptData["briefing_name"] == "Station" or postWptData["briefing_name"] == "Station" then
							diversParamsTiming = true
						end


						if postWptData.ETA then
							if (math.abs(calPostETA - postWptData.ETA) > 50) and not diversParamsTiming and not isHumain  then
								info06 = info06.."\n".."|+T13|ATTENTION bad ETA wpt+1| "..(wtpN+1).." // "..postWptData.briefing_name.." |distance:| "..distance.." |calPostETA:| "..calPostETA.." |>| "..postWptData.ETA.." |infoCompl: "..infoCompl.."\n"
								tagATTENTION = true
							end
						else
							info06 = info06.."\n".."|+T14|ATTENTION pas de postWptData.ETA| "..(wtpN+1)..")".."\n"
							tagATTENTION = true
						end

					end
				end


				if isHumain then
					if group.route.points[1]["action"] == "Turning Point"then
						info02 = info02.."\n".."|+T15|ATTENTION MANQUE Start "..group.groupId.."\n"
						tagATTENTION = true

						DebugFLIGHT = DebugFLIGHT .. "\n".."Error info02"..info02
					end
					if group.start_time > 10 then
						info02 = info02.."\n".."|+start_time|ATTENTION start_time ClientPlayer > 10s:  "..group.start_time.."\n"
						tagATTENTION = true

						DebugFLIGHT = DebugFLIGHT .. "\n".."Error info02"..info02
					end
				end

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

				for i = 1, #group.route.points do
					--['briefing_name'] = 'IP'
					if group.route.points[i]["name"] and group.route.points[i]["name"] == "Target" then
						info06 = info06.." Target_ETA : "..group.route.points[i].ETA.." "
						break
					end
				end

				if waypoints[#waypoints]["airdromeId"] then				
					info06 = info06.." airdromeId LANDING "..waypoints[#waypoints]["airdromeId"]				
				end	


				if group.frequency then
					info06 = info06.."frequency "..group.frequency
				else
					info06 = info06.."\n".."|+T16|ATTENTION NO frequency ".."\n"
					tagATTENTION = true
				end

				if group.task then
					info06 = info06.."task "..group.task
					if group.task == "AWACS" or group.task == "Refueling" then
						if #group.units > 1 then
							info06 = info06.."\n".."|+T17|ATTENTION >1 UNIT "..group.task.."\n"
							tagATTENTION = true
						end

					end
				else
					info06 = info06.."\n".."|+T17|ATTENTION NO task ".."\n"
					tagATTENTION = true
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
					infoFlight = infoFlight.."\n"..("= = = = = = = = = = = = = = = = = ="..units[1].skill.." = = = = = = = = = = = = = = = = = = = = ")
					infoFlight = infoFlight.."\n"..("= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = ")
				end

				if (units[1].skill == "Player" or units[1].skill == "Client") and group.route.points[1].ETA> 10 then
					infoFlight = infoFlight.."\n\n\n".."|+T18|ATTENTION Player/Client delayed start ETA1: "..group.route.points[1]["ETA"].."\n\n\n"
					tagATTENTION = true
				end

				local groupInfo = ""
				if debugStart then
					groupInfo = tostring(info01)
					.." |"..tostring(info02)
					.." |"..tostring(info03)
					-- .." "..tostring(info04)
					.." |"..tostring(info05)
					.." |"..tostring(info06)


					-- .."  ".." // "..units[1].skill

					-- .." UAlt ".." // "..units[1].alt
					-- .." WPptAlt".." // "..tostring(group['route']['points'][1]["alt"])
					.."  |Type: "..tostring(group['route']['points'][1]["type"])
					.."  |unCont: "..tostring(group.uncontrolled)
					.."  |lActiv: "..tostring(group.lateActivation)

					-- .."  ".." // "..group.frequency


					-- .." WAlt ".." // "..info01
					-- .." "..groupInfo
					-- .." |ETA1: "..group.route.points[1]["ETA"]
				end

				infoFlight = infoFlight.."\n"
					..""..flight[f].id
					.." |Pack: "..p
					.." |Nb "..flight[f].number
					.." | "..AliasTypeName(flight[f].type)
					.." | "..group.name
					.." | "..AliasBaseName(flight[f].base)
					.." | "..flight[f].target_name
					.." |activate: "..tostring(activateGroupSecondes)
					.." |start_time: ".. math.floor(debug_StartTime)
					.." |ETA1: "..(group.route.points[1]["ETA"])
					-- .." |ETA2: "..group.route.points[2]["ETA"]
					.." |frequency: "..tostring(group.frequency)
					.." |threatsG: "..tostring(flight[f].threatsGround)
					.." |threatsA: "..tostring(flight[f].threatsAir)
					.." |score: "..tostring(flight[f].score)



				debugTempFLIGHT = infoFlight.." "..groupInfo

				if units[1].skill == "Player" or units[1].skill == "Client" then
					infoFlight = infoFlight.."\n"..("= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = ")
					infoFlight = infoFlight.."\n"..("= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = ")
				end
				if units[1].skill == "Player" or units[1].skill == "Client" then
					debugTempFLIGHT = debugTempFLIGHT.."\n"..("= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = ")
					debugTempFLIGHT = debugTempFLIGHT.."\n"..("= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = ")
				end

				if Debug.AfficheFlight  then
					print(debugTempFLIGHT)
				end

				if tagATTENTION then
					AddLog(debugTempFLIGHT)
				end

				-- if waypoints[1].ETA< 0 then
				if group and group.route and group.route.points[1].ETA then
					if group.route.points[1].ETA < 0 then
						--TODO regler les ETA negatif
						-- print("AtoFP ETA négatif: "..tostring(waypoints[1]["ETA"]))
					end
				else

					_affiche(group.route.points, "group.route.point.route")
				end

				debugTempFLIGHT = debugTempFLIGHT.."\n"..("\n")

				DebugFLIGHT = DebugFLIGHT .. debugTempFLIGHT
				debugTxt_AtoFP = debugTxt_AtoFP .. debugTempFLIGHT

				if Multi.NbGroup >= 1 and not Debug.AfficheFlight then
					print(infoFlight)
				end
			end
		end
	end
end


if mission.weather["clouds"] then

	if not mission.weather["clouds"]["preset"] then
		local infoWeather01 = "|+IW1|ATTENTION NO weather preset "
		-- if Debug.debug then
			AddLog(infoWeather01)
		-- end
	-- else
	-- 	local infoWeather02 = "|+IW2|weather preset: "..mission.weather["clouds"]["preset"]
	-- 	if Debug.debug then
	-- 		InsertBugList(infoWeather02)
	-- 	end
	end

end

--= = = = = = = =  = = = = = = = = = =  = = = = = = = = = =  ==  = = =
---FIN-- create flight plans in mission file for all flights in ATO -----
---END-- create flight plans in mission file for all flights in ATO -----
---FIN-- create flight plans in mission file for all flights in ATO -----
---END-- create flight plans in mission file for all flights in ATO -----
--= = = = = = = =  = = = = = = = = = =  = = = = = = = = = =  ==  = = =



function GeWpindex(groupIdCheck, wpLabel)

	for _side, side in pairs(mission.coalition) do
		for countryN, country in pairs(side.country) do
			for category, groups in pairs(country) do
				if type(groups) == "table" and groups["group"]  then
					for Ngroup, group in pairs(groups["group"]) do
						if group.groupId == groupIdCheck then
							for unitN, unit in pairs(group.units) do
								for pointN, waypoint in pairs(group.route.points) do
									if waypoint.briefing_name and waypoint.briefing_name == wpLabel then
										return pointN
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


-- following
for side, pack in pairs(ATO) do
	for p = 1, #pack do
		for role, flight in pairs(pack[p]) do
			for f = 1, #flight do
				if flight[f]["mustFolloW"] then

					flight[f]["mustFolloW_groupId"] = pack[p]["main"][1].groupId

					for countryN, country in pairs(mission.coalition[side].country) do
						for category, groups in pairs(country) do
							if type(groups) == "table" and groups["group"]  then	--and groups[1].units							
								for Ngroup, group in pairs(groups["group"]) do

									if group.groupId == flight[f].groupId then

										for pointN, waypoint in pairs(group.route.points) do
											if waypoint["task"] and waypoint["task"]["params"] and waypoint["task"]["params"]["tasks"] then
												for taskN, task_ in pairs(waypoint["task"]["params"]["tasks"]) do
													if task_.id == "Follow" then
														task_["params"].groupId = flight[f]["mustFolloW_groupId"]
														task_["params"].lastWptIndex = GeWpindex(flight[f]["mustFolloW_groupId"], "Egress")
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
end


-- ajoute le warehouse des FARP ajouté par trigger
-- if camp.needWarehouse then
	for _side, side in pairs(mission.coalition) do
		for countryN, country in pairs(side.country) do
			for category, groups in pairs(country) do
				if category == "static" and type(groups) == "table" and groups["group"] then
					for groupN, groupData in pairs(groups["group"]) do
						for unitN, unit in pairs(groupData.units) do
							if unit.category and unit.category == "Heliports" then
								if not warehouses.warehouses[unit.unitId] then
									warehouses.warehouses[unit.unitId] = Data_warehouses
									print("AtoFP: add warehouse for FARP "..unit.unitId.." || "..unit.name)
								end
							end
						end
					end
				end
			end
		end
	end
-- end

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
								local listIdCopy = DeepCopy(listId)

								for n=1, #listId do
									if unit.unitId == listId[n] then
										for key, value in pairs(listIdCopy) do
											local data = {
												["missionUnitId"] = value,
											}

											-- --cas avion RECOVERY, place ici l unitId dans le premier members
											-- if unit.datalinks[typeDataLink].network.teamMembers[1].missionUnitId ~= unit.unitId then
											-- 	unit.datalinks[typeDataLink].network.teamMembers[1].missionUnitId = unit.unitId
											-- end

											if #unit.datalinks[typeDataLink].network.teamMembers < Data_divers[unit.type].datalinks.hasTeamMembers then
												table.insert(unit.datalinks[typeDataLink].network.teamMembers, data )
											end
											if #unit.datalinks[typeDataLink].network.donors < Data_divers[unit.type].datalinks.hasDonors then

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
								local listIdCopy = DeepCopy(listId)

								for n=1, #listId do
									if unit.unitId == listId[n] then
										--  n'ajoute que les avions du meme package
										for key, value in pairs(listIdCopy) do
											local data = {
												["missionUnitId"] = value,
											}

											-- --cas avion RECOVERY, place ici l unitId dans le premier members
											-- if unit.datalinks[typeDataLink].network.teamMembers[1].missionUnitId ~= unit.unitId then
											-- 	unit.datalinks[typeDataLink].network.teamMembers[1].missionUnitId = unit.unitId
											-- end

											if #unit.datalinks[typeDataLink].network.teamMembers < Data_divers[unit.type].datalinks.hasTeamMembers then
												table.insert(unit.datalinks[typeDataLink].network.teamMembers, data )
											end

											if #unit.datalinks[typeDataLink].network.donors < Data_divers[unit.type].datalinks.hasDonors then

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


function af_spawnOn(where, groupName)
	if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFp AF_spawnOn  "..groupName) end

		local action = 'From Runway'
		local actionType = 'TakeOff'

	if where == "catapult" then
		action =  'From Runway'
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
for cv, sixPack in pairs(cv_testSixPack) do

	if #sixPack > 0 then

		table.sort(sixPack, function(a,b) return a.time < b.time  end)
		if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.. _afficheTXT(sixPack, "SixPack") end

		local breakloop = false
		local placeOnSixPack_OK = false
		sommePlane[cv] = 0
		local n = 1
		repeat

			if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("n: "..n) end

			local sixpackWiner = sixPack[n]["groupName"]

			--affiche la note concernant le joueur:
				-- s'il est sur le Sixpack ET serveur dédié : commencer serveur sur pause
				-- s'il n'est pas sur sixpack ET serveur dédié: commencer serveur en resume


			sommePlane[cv] = 4													-- par defaut, le sixpack ne pourra etre utiliser à posteriorie, donc on estime que les 4 places sont occupé, cela evite les spawn derriere et le manque de place ensuite, sur tout le pont

			for _side,side in pairs(mission.coalition) do
				for _country,country in pairs(side.country) do
					if country.plane then
						for Ngroup,group in pairs(country.plane.group) do
							if group.name == sixpackWiner then
								if group.units[1]["type"] == "S-3B Tanker" or group.units[1]["type"] == "E-2C"  then						-- cet endroit est bloqué par DCS pour ces 2 avions
									af_spawnOn("catapult", group.name)
									modify_Activate_GroupTime(group, -1, debug.getinfo(1).currentline)								--supprime le triger activate (vraiment?)
									-- modify_set_ai_task(group, -1, debug.getinfo(1).currentline) --supprime le triger start(vraiment?)
									group['tasks'] = {}
									break
								end
								if not placeOnSixPack_OK then
									group['route']['points'][1]["ETA"] = 0
									group['start_time'] = 0
									modify_Activate_GroupTime(group, -1, debug.getinfo(1).currentline) --supprime le triger activate(vraiment?)
									if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFp SixPack Find "..group.name) end
									breakloop = true
									placeOnSixPack_OK = true
								end
							end
						end
					elseif country.helicopter then
						for Ngroup, group in pairs(country.helicopter.group) do
							if group.name == sixpackWiner then
								group['route']['points'][1]["ETA"] = 0
								group['start_time'] = 0
								modify_Activate_GroupTime(group, -1, debug.getinfo(1).currentline)								--supprime le triger activate
								if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFp SixPack Find "..group.name) end
								breakloop = true
							end
						end
					end
				end
			end

			if breakloop or n > #sixPack then
				-- if sixPack[n]["client"] and SingleWithDServer  then
				-- 	print()
				-- 	print("********************ATTENTION******************")
				-- 	print()
				-- 	print("        You MUST set the server to PAUSE")
				-- 	print("          (to appear on the SIXPACK) ")
				-- 	print()
				-- 	print("********************ATTENTION******************")
				-- 	print("ATTENTION")os.execute 'pause'


				-- elseif SingleWithDServer then	

				-- 	print()
				-- 	print("*****************************************ATTENTION***************************************************")
				-- 	print()
				-- 	print("				  You MUST set the server to RESUME ")
				-- 	print()
				-- 	print("(so that you don't appear on the Sixpack, you'd be annoying the AIs that will be driving before you) ")
				-- 	print()
				-- 	print("*****************************************ATTENTION***************************************************")
				-- 	print("ATTENTION") os.execute 'pause'
				-- end
			end

			n = n +1
		until breakloop or n > #sixPack
	end
end

if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.. _afficheTXT(testDeckPlace, "testDeckPlace") end

-- nombre d'avion sur le pont total
-- limite le nombre d'avion sur le pont (permet de faire apparaitre les avions tardif, s'il y a de la place)
for cv, deckGroups in pairs(testDeckPlace) do

	if #deckGroups > 0 then

		table.sort(deckGroups, function(a,b) return a.time < b.time  end)
		if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.. _afficheTXT(deckGroups, "testDeckPlace deck") end

		if cv_testSixPack[cv] and #cv_testSixPack[cv] > 0 then

			--cherche une place dispo sur le deck pour les avions tardif
			local counter = 0
			local testSomme = 0
			-- for n = 1 , #deckGroups do
			for groupN, deckGr in pairs(deckGroups) do
				if not deckGr.isHumain then
					repeat
						counter = counter +1

						local deckWiner = deckGr["groupName"]

						if not deckGr["LimitedParkNb"] then
							break
						else
							--enleve les 4 places du Sixpack
							--et aussi le nombre de place du pack client/joueur
							LimitedDeckNb = deckGr["LimitedParkNb"] - 4 - cv_nbPlanetDeck
						end

						if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFp DeckWiner "..deckWiner) end
						if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFp DeckWiner "..tostring(deckGr["number"]) .." |LimitedDeckNb: "..tostring(LimitedDeckNb)) end

						testSomme = testSomme + deckGr["number"]
						if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFp testSomme "..testSomme) end
						if testSomme <= LimitedDeckNb and not deckGr["OnDeck"] then
							for _, side in pairs(mission.coalition) do
								for _, country in pairs(side.country) do
									if country.plane then
										for _, group in pairs(country.plane.group) do
											if group.name == deckWiner then
												group['uncontrolled'] = true
												group['lateActivation'] = true
												modify_Activate_GroupTime(group, 2, debug.getinfo(1).currentline)
												sommePlane[cv] = sommePlane[cv] + tonumber(deckGr["number"])
												deckGr["OnDeck"] = true
												if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFp DeckWiner Find "..group.name.." +number: "..deckGr["number"]) end
											end
										end
									elseif country.helicopter  then
										for _, group in pairs(country.helicopter.group) do
											if group.name ==  deckWiner then
												group['uncontrolled'] = true
												group['lateActivation'] = true
												modify_Activate_GroupTime(group, 2, debug.getinfo(1).currentline)
												sommePlane[cv] = sommePlane[cv] + tonumber(deckGr["number"])
												deckGr["OnDeck"] = true
												if debugStart then debugTxt_AtoFP = debugTxt_AtoFP.."\n"..("AtoFp DeckWiner Find "..group.name.." +number: "..deckGr["number"]) end
											end
										end
									end
								end
							end
						end

					until sommePlane[cv] >= LimitedDeckNb or counter >= 2
				end
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
				for base , time_mn in pairs(pPA) do
					debugTxt_AtoFP = debugTxt_AtoFP.."\n"..(tostring(base).." taxiing schedule on the deck at ...")
					for s, name in PairsByKeys(time_mn) do

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


----- make a copy of player package for easy reference in briefing -----

if camp.player then
	if not camp.player.package then camp.player.package = {} end
	if not camp.player.package[camp.player.pack_n] then
		camp.player.package[camp.player.pack_n] = DeepCopy(ATO[camp.player.side][camp.player.pack_n])
	end

	--for multi-package strikes, add flights from other packages with the same target to player package to enrich the briefiing
	for p = 1, #ATO[camp.player.side] do										--iterate through packages in player side	
		for role,flight in pairs(ATO[camp.player.side][p]) do					--iterate through roles in package (main, SEAD, escort)		
			-- print("AtoFP role: "..role)
			for f = 1, #flight do												--iterate through flights in roles
				if flight[f].target_name == camp.player.target.titleName and camp.player.pack_n ~= p then	--flights that have the same target as player but are not in the player package
					table.insert(camp.player.package[camp.player.pack_n][role], DeepCopy(flight[f]))							--insert flight into player package to list it in player briefing
				end
			end
		end
	end
end


if camp.client then

	-- camp.client.pack = Deepcopy(ATO[camp.client.side][camp.client.pack_n])
	for c = 1, #camp.client do
		if not camp.client.package then camp.client.package = {} end
		if not camp.client.package[camp.client[c].pack_n] then
			camp.client.package[camp.client[c].pack_n] = DeepCopy(ATO[camp.client[c].side][camp.client[c].pack_n])	--pack_n
		end
	end

	local camp_str = "camp.client = " .. TableSerialization(camp.client, 0)						--make a string
	local campFile = io.open("Debug/CAMPclientBB.lua", "w")	 or error("Failed to open debug file")
	campFile:write(camp_str)																		--save new data
	campFile:close()

end


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
local debugGenMFile = io.open("Debug/FlightPlan_FLIGHT_Debug.lua", "w") or error("Failed to open debug file")
debugGenMFile:write(debugTxt_AtoFP)
debugGenMFile:close()

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
					-- print("AtoFP B baseName "..baseName)

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

				local addGroup = {
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
								-- ["alt"] = tonumber(target.z),
								["type"] = "Turning Point",
								["ETA"] = 0,
								["name"] = tostring(baseName).."_runway_"..runwayN,
								["alt_type"] = "BARO",
								["formation_template"] = "",
								["y"] = tonumber(runway.y),
								["x"] = tonumber(runway.x),
								["ETA_locked"] = true,
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
								["speed_locked"] =  true,
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

				table.insert(mission.coalition.blue.country[1].vehicle.group, addGroup)
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
							["unitId"] = GenerateIDUnit("AtoFP ".."UnitRunway_"..baseName.."_"..e, "Soldier M4"),
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
					DebugFLIGHT = DebugFLIGHT .. "\n"..("AtoFP bug runway "..baseName)
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

							DebugFLIGHT = DebugFLIGHT .. "\n"..("AtoFP bug ETA and Speed not lock in "..pointN.." "..group.name)
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

-- --supprime les ["num"] = 1, des loadouts
-- --qui sont devenu inutile
-- for _, side in pairs(mission.coalition) do
-- 	for _, country in pairs(side.country) do
-- 		for _, groups in pairs(country) do
-- 			if type(groups) == "table" and groups["group"]  then
-- 				for _, group in pairs(groups["group"]) do
-- 					for _, unit in pairs(group.units) do
-- 						if unit.payload and unit.payload.pylons   then
-- 							for _, pylon in pairs(unit.payload.pylons) do
-- 								if pylon and pylon.num then
-- 									pylon.num = nil
-- 								end
-- 							end
-- 						end
-- 					end
-- 				end
-- 			end
-- 		end
-- 	end
-- end



if Debug.debug then

	camp_str = "ATO_AtoFP = " .. TableSerialization(ATO, 0)						--make a string
	campFile = io.open("Debug/ATO_AtoFP.lua", "w")  or error("Failed to open debug file")
	campFile:write(camp_str)																		--save new data
	campFile:close()

	camp_str = "CommonFreq = " .. TableSerialization(CommonFreq, 0)						--make a string
	campFile = io.open("Debug/Radio_CommonFreq_FlightPlan.lua", "w")  or error("Failed to open debug file")
	campFile:write(camp_str)																		--save new data
	campFile:close()

	camp_str = "timingDeckCata = " .. TableSerialization(cv_deckReservations, 0)						--make a string
	campFile = io.open("Debug/CVN_timingDeckCata.lua", "w")  or error("Failed to open debug file")
	campFile:write(camp_str)																		--save new data
	campFile:close()

		camp_str = "testSixPack = " .. TableSerialization(cv_testSixPack, 0)						--make a string
	campFile = io.open("Debug/CVN_testSixPack.lua", "w")  or error("Failed to open debug file")
	campFile:write(camp_str)																		--save new data
	campFile:close()
	

	

	if camp.client then
		camp_str = "client = " .. TableSerialization(camp.client, 0)						--make a string
		campFile = io.open("Debug/camp_client_AtoFP.lua", "w")  or error("Failed to open debug file")
		campFile:write(camp_str)																		--save new data
		campFile:close()
	elseif camp.player then
		camp_str = "player = " .. TableSerialization(camp.player, 0)						--make a string
		campFile = io.open("Debug/camp_player_AtoFP.lua", "w")  or error("Failed to open debug file")
		campFile:write(camp_str)																		--save new data
		campFile:close()
	end

	-- _affiche(PlacePA, "AtoFp PlacePA")

	-- _affiche(channel_tacan, "Atofp channel_tacan ")

	-- _affiche(PointOfInterest, "Atofp PointOfInterest ")

end