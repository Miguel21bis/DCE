--To create the flight plans in the mission file for all flights in the ATO
--Initiated by Main_NextMission.lua
-------------------------------------------------------------------------------------------------------
-- ORGANISATION (réorganisé en dossier ATO_FlightPlan\ ; ce fichier reste le point d'entrée : MAIN_NextMission.lua l'inclut)
--
--   ATO_FlightPlan.lua                  CE FICHIER = chef d'orchestre : préparation, boucle sur les vols, puis étape finale.
--   ATO_FlightPlan\ATO_FP_Check.lua      contrôle automatique (règles, globales oubliées) + protection anti-plantage.
--   ATO_FlightPlan\ATO_FP_20_Tasks.lua   constructeurs de tâches DCS : Task_Option, Task_Script, Task_Orbit, Task_Bombing...
--   ATO_FlightPlan\ATO_FP_30_Identity.lua indicatifs (callsign), identifiants Link16 / SADL / IDM, TACAN tanker.
--   ATO_FlightPlan\ATO_FP_40_Spawn.lua   apparition / activation du groupe (spawnOn, triggers, flags).
--   ATO_FlightPlan\ATO_FP_60_Loop.lua    les ETAPES du traitement d'un vol (phases A à J), en fonctions, dans l'ordre d'exécution.
--   ATO_FlightPlan\ATO_FP_90_Final.lua   étape finale : fichiers de debug, briefing, nettoyages, GetSidenumber, GeWpindex.
--
-- COMMENT LES FICHIERS COMMUNIQUENT : table globale AtoFP (remise à zéro à chaque passe, ligne ci-dessous).
--   chaque fichier ATO_FP_xx range ce qu'il fournit dans AtoFP.xxx ; ce fichier le récupère avec  local xxx = AtoFP.xxx
--
-- LA BOUCLE (for sideName > p > role > f) : un vol à la fois. Chaque étape est un appel précédé de  AtoFP.phase = "..."
--   A préparation | B waypoints (boucle for w) | C après waypoints | D unités | E datalink | F fréquences + group
--   G apparition | H SAR / Intercept / Pedro / recovery | I insertion dans la mission | J triggers + debug
--   Le détail de chaque étape et son rôle sont en tête de ATO_FlightPlan\ATO_FP_60_Loop.lua.
--
-- EN CAS DE PROBLEME (dossier Debug\ATO_FlightPlan_LOG\) :
--   FlightPlan_Check.txt   VERDICT en tête, tableau des règles, globales oubliées, signature des groupes
--   FlightPlan_Crash.txt   écrit seulement si ça plante : phase, vol, waypoint, pile d'appels
--   FlightPlan_FLIGHT_Debug.lua   texte de debug (dbg) du FlightPlan
--
-- ATTENTION : l'ordre des appels math.random compte (même graine = même mission) : ne pas déplacer les tirages au sort.
-------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------- 
-- if not versionDCE then versionDCE = {} end
-- versionDCE["ATO_FlightPlan.lua"] = "1.58.295"
-- ------------------------------------------------------------------------------------------------------- 

-- if Debug.debug then
-- 	print("START ATO_FlightPlan.lua "..versionDCE["ATO_FlightPlan.lua"].." =-=-=-=-=-=-=-=-=-=-=-=-=-=-=")
-- end

DebugFLIGHT = ""
TabLPark	= {}
TargetList_InThisMission = {}			-- garde en mémoire les targets pour eviter de les pruner plus tard
PointOfInterest = {}					-- liste des points d'interet
TabDivert = {}							--liste des pistes de deroutement
HumainInterceptor = false
MsgForPlayerInMsn = {}


AtoFP = {}								--table commune aux fichiers ATO_FlightPlan\ATO_FP_xx.lua, remise à zéro à chaque passe
Include("ATO_FlightPlan/ATO_FP_Check.lua")	--contrôle automatique : rapport dans Debug\FlightPlan_Check.txt
AtoFP.CheckStart()
AtoFP.Guard(function()		-- protection : si le FlightPlan plante, Debug\FlightPlan_Crash.txt dit où et pourquoi

local debugStart = true					--NE PAS CHANGER, les infos restent seulement dans le fichier FlightPlan_Generator_Debug
AtoFP.debugTxt_AtoFP = ""

local function dbg(msg)
	if debugStart then
		AtoFP.debugTxt_AtoFP = AtoFP.debugTxt_AtoFP.."\n"..msg
	end
end

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
	mission.forcedOptions.accidental_failures = true


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
	CommonFreq[side]["UHF"][1] = GetFrequencyNG(side, nil, "coalition", nil, "UHF", nil, nil, "ATO_FlightPlan commun UHF 1")
	CommonFreq[side]["UHF"][2] = GetFrequencyNG(side, nil, "coalition", nil, "UHF", nil, nil, "ATO_FlightPlan commun UHF 2")

	CommonFreq[side]["VHF"][1] = GetFrequencyNG(side, nil, "coalition", nil, "VHF", nil, nil, "ATO_FlightPlan commun VHF 1")
	CommonFreq[side]["VHF"][2] = GetFrequencyNG(side, nil, "coalition", nil, "VHF", nil, nil, "ATO_FlightPlan commun VHF 2")

	CommonFreq[side]["HF"][1] = GetFrequencyNG(side, nil, "coalition", nil, "HF", nil, nil, "ATO_FlightPlan commun HF 1")
	CommonFreq[side]["HF"][2] = GetFrequencyNG(side, nil, "coalition", nil, "HF", nil, nil, "ATO_FlightPlan commun HF 2")
	CommonFreq[side]["LVHF"][1] = GetFrequencyNG(side, nil, "coalition", nil, "LVHF", nil, nil, "ATO_FlightPlan commun LVHF 1")
	CommonFreq[side]["LVHF"][2] = GetFrequencyNG(side, nil, "coalition", nil, "LVHF", nil, nil, "ATO_FlightPlan commun LVHF 2")

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
				dbg("AtoFP_getParkSarAirBase |return nil| flightF.base: "..tostring(flightF.base).. " |nPk :  "..tostring(nPk))
				return nPk
				-- pkFound = true
			end
			nLoop = nLoop + 1
		until nLoop > 200
	end

	dbg("AtoFP_getParkSarAirBase |return nil| flightF.base: "..tostring(flightF.base).. " |nLoop :  "..tostring(nLoop))	
	-- dbg("AtoFP_getParkSarAirBase ").._afficheTXT(parkSarAirBase[flightF.base])
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

Include("ATO_FlightPlan/ATO_FP_20_Tasks.lua")	--fabricants de tâches DCS (liste dans ATO_FP_20_Tasks.lua)
local Task_Option = AtoFP.Task_Option
local Task_Script = AtoFP.Task_Script
local Task_EngageAir = AtoFP.Task_EngageAir
local Task_Orbit = AtoFP.Task_Orbit
local Task_Service = AtoFP.Task_Service
local Task_CarpetBombing = AtoFP.Task_CarpetBombing
local Task_AttackGroup = AtoFP.Task_AttackGroup
local Task_Bombing = AtoFP.Task_Bombing
local Task_FAC = AtoFP.Task_FAC
local Task_Follow = AtoFP.Task_Follow
AtoFP.callSignFlight = callSignFlight
AtoFP.callSignFlightUnite = callSignFlightUnite
AtoFP.tacan_byTarget = tacan_byTarget
AtoFP.callSign_west_counter = callSign_west_counter
Include("ATO_FlightPlan/ATO_FP_30_Identity.lua")	--callsigns, sidenumbers, datalink, TACAN, bullseye
local getCallsign = AtoFP.getCallsign
local pack_L16_unitId = AtoFP.pack_L16_unitId
local pack_SADL_unitId = AtoFP.pack_SADL_unitId
local pack_IDM_unitId = AtoFP.pack_IDM_unitId
local Get_L16_Id = AtoFP.Get_L16_Id
local Get_SADL_Id = AtoFP.Get_SADL_Id
local get_IDM_Id = AtoFP.get_IDM_Id
local getTankerTACAN = AtoFP.getTankerTACAN
local fct_movedBullseye = AtoFP.fct_movedBullseye

AtoFP.debugStart = debugStart
AtoFP.dbg = dbg
AtoFP.testDeckPlace = testDeckPlace
Include("ATO_FlightPlan/ATO_FP_40_Spawn.lua")	--spawnOn, activation des groupes, start_Set_Ai_Task, createBombingChapter
local modify_Activate_GroupTime = AtoFP.modify_Activate_GroupTime
local spawnOn = AtoFP.spawnOn
local activate_Group_WithFlag = AtoFP.activate_Group_WithFlag
local activate_group_time_after = AtoFP.activate_group_time_after
local start_Set_Ai_Task = AtoFP.start_Set_Ai_Task
local createBombingChapter = AtoFP.createBombingChapter
Include("ATO_FlightPlan/ATO_FP_60_Loop.lua")	--morceaux de la boucle principale (fin de vol : triggers + debug)
local FlightTriggersAndDebug = AtoFP.FlightTriggersAndDebug
local FlightDatalink = AtoFP.FlightDatalink
local FlightInsertInMission = AtoFP.FlightInsertInMission
local FlightSarAlert = AtoFP.FlightSarAlert
local FlightInterceptAwacs = AtoFP.FlightInterceptAwacs
local FlightPedroSar = AtoFP.FlightPedroSar
local FlightStartAndCallsign = AtoFP.FlightStartAndCallsign
local FlightRecovery = AtoFP.FlightRecovery
local FlightGroupAndSpawn = AtoFP.FlightGroupAndSpawn
local FlightFrequencyAndGroup = AtoFP.FlightFrequencyAndGroup
local FlightCreateUnits = AtoFP.FlightCreateUnits
local FlightAfterWaypoints = AtoFP.FlightAfterWaypoints
local PrepBaseAndModules = AtoFP.PrepBaseAndModules
local PrepParking = AtoFP.PrepParking
local PrepWeaponAndTask = AtoFP.PrepWeaponAndTask
local PrepTaskCheck = AtoFP.PrepTaskCheck
local WpBuild = AtoFP.WpBuild
local WpSpecialCases = AtoFP.WpSpecialCases
local WpTypesSpeeds = AtoFP.WpTypesSpeeds
local WpAltitudeLand = AtoFP.WpAltitudeLand
local WpDepartureSpawn = AtoFP.WpDepartureSpawn
local WpAttackPrep = AtoFP.WpAttackPrep
local WpIpAttack = AtoFP.WpIpAttack
local WpTaskByRole = AtoFP.WpTaskByRole
local WpStationAssemble = AtoFP.WpStationAssemble
local WpSeadEgressRecon = AtoFP.WpSeadEgressRecon
local WpHumanBriefing = AtoFP.WpHumanBriefing



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

-- dbg("AtoFP parkSarAirBase 00 ").._afficheTXT(parkSarAirBase)


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


	if BullseyeZone[nameTheatre] or mission_ini.movedBullseye == false then
		mission.coalition[sideName].bullseye, Brief[sideName].bullseye = fct_movedBullseye(sideName, nameTheatre)
	end

	for p = 1, #pack do															--iterate through packages in sides		
		local pn = 1															--variable to count flights in package	
		for role, flight in pairs(pack[p]) do									--iterate through roles in package (main, SEAD, escort)		
			for f = 1, #flight do												--iterate through flights in roles

				AtoFP.phase = "A"
				local farp_MorePlace = false
				local infoFlight = ""
				local totFlightDist = 0
				local isHumain = flight[f].player or flight[f].client
				local groupName = flight[f].groupName
				AtoFP.here = { side = sideName, pack = p, role = role, f = f, group = groupName, flight = flight[f] }	-- repère pour Debug\FlightPlan_Crash.txt
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

				AtoFP.phase = "A:PrepBaseAndModules"
				baseIsCarrier, baseIsFARP, farp_MorePlace, playerTask = PrepBaseAndModules(flight, f, baseIsCarrier, baseIsFARP, farp_MorePlace, isHumain, playerTask, tempBaseAirStart)

				AtoFP.phase = "A:PrepParking"
				local limitedParkTiming
				limitedParkTiming, is_helicopter = PrepParking(flight, f, baseIsCarrier, is_helicopter, mn_StartParking)

				AtoFP.phase = "A:PrepWeaponAndTask"
				local navTargetPoints, flagPoints, weaponType, goupTaskTemp, typeCible
				navTargetPoints, flagPoints, weaponType, goupTaskTemp, typeCible, pn = PrepWeaponAndTask(flight, f, pn)


				-- TaskByPlane

				--teste_ =======================================================================

				AtoFP.phase = "A:PrepTaskCheck"
				local id_task
				id_task, goupTaskTemp = PrepTaskCheck(flight, f, goupTaskTemp, typeCible)




				------========================-----========================--
				---========================-----========================--
				----- define waypoints -----
                ------========================-----========================--
				---
				--- ------========================-----========================--
				--- -- chapitre waypoints
				--- 
				AtoFP.phase = "B"
				start_time = flight[f].route[1].eta
				local departure_time											--local variable to store departure time
				local waypoints = {}											--define waypoints of flight
				local wptTargetPass = false										--detecte le passage du wpt Target
				local alreadyTreated

				for w = 1, #flight[f].route do
					AtoFP.wp = w									-- repère pour Debug\ATO_FlightPlan_LOG\FlightPlan_Crash.txt
					AtoFP.phase = "B:WpBuild"
					local atlTemp, speed = WpBuild(flight, f, p, is_helicopter, pack, w, waypoints)


					AtoFP.phase = "B:WpSpecialCases"
					speed, wptTargetPass = WpSpecialCases(flight, f, atlTemp, flagPoints, navTargetPoints, speed, w, waypoints, wptTargetPass)

					-- ************* store spawn and departure time for flight *************
					AtoFP.phase = "B:WpTypesSpeeds"
					departure_time, start_time = WpTypesSpeeds(flight, f, departureOrbitAlt, departure_time, isHumain, is_helicopter, start_time, w, waypoints)

					-- modification M06.b bug helico reste statique s'il demarre en horaire décalé
					-- M06.e
					AtoFP.phase = "B:WpAltitudeLand"
					stackN = WpAltitudeLand(flight, f, baseIsCarrier, groupName, isHumain, is_helicopter, parkSarAirBase, stackN, w, waypoints)

					-- ************* formations et largage d'urgence *************
					AtoFP.phase = "B:WpDepartureSpawn"
					WpDepartureSpawn(flight, f, is_helicopter, w, waypoints)

					AtoFP.phase = "B:WpAttackPrep"
					local expendQty, weaponType_, attackType, attackAlt, dive, AGAS_ready, offsetAngle, climbAngle, popAlt, attackDist, reattack, tgtlist
					expendQty, weaponType_, attackType, attackAlt, dive, AGAS_ready, offsetAngle, climbAngle, popAlt, attackDist, reattack, tgtlist, altRole = WpAttackPrep(flight, f, role, altRole, is_helicopter, pn, w, waypoints)

					-- *************  switch from IP to egress *************
					AtoFP.phase = "B:WpIpAttack"
					WpIpAttack(flight, f, p, AGAS_ready, attackAlt, attackDist, attackType, climbAngle, dive, expendQty, goupTaskTemp, groupName, id_task, isHumain, is_helicopter, offsetAngle, pack, popAlt, reattack, tgtlist, typeCible, w, waypoints, weaponType, weaponType_)

					-- ************* SEAD engage tasks for each route segment *************
					AtoFP.phase = "B:WpTaskByRole"
					alreadyTreated = WpTaskByRole(flight, f, p, alreadyTreated, groupName, pack, w, waypoints, weaponType)


					-- ************* station tasks *************
					AtoFP.phase = "B:WpStationAssemble"
					speed = WpStationAssemble(flight, f, p, groupName, is_helicopter, pack, speed, w, waypoints)

					-- ************* SEAD switch from IP to egress
					AtoFP.phase = "B:WpSeadEgressRecon"
					speed = WpSeadEgressRecon(flight, f, p, groupName, is_helicopter, pack, speed, w, waypoints)

					--navigation information on waypoint name for player flight
					AtoFP.phase = "B:WpHumanBriefing"
					totFlightDist = WpHumanBriefing(flight, f, isHumain, navTargetPoints, totFlightDist, w, waypoints)


					-- print("AtoFp "..flight[f].task.." _________ wptTargetPass: "..tostring(wptTargetPass).." wptName "..tostring(waypoints[w]["name"]) )
					if flight[f].task == "Anti-ship Strike" and wptTargetPass and waypoints[w]["name"] ~= "Land" then
						waypoints[w]["ETA_locked"] = false
						waypoints[w]["speed_locked"] = true
						waypoints[w]["debug"] = (waypoints[w]["debug"] or "") .." ETA_locked J False "
					end

				end	-- Fin de Route


				-- ************* Fin de Route *************
				-- ************* Fin de Route *************
				-- ************* Fin de Route *************




				-- ************* lock ETA and speed of first waypoint *************
				AtoFP.phase = "C"
				local skillTab, units, calcWish = FlightAfterWaypoints(flight, f, sideName, isHumain, waypoints)


				AtoFP.phase = "D"
				calcWish = FlightCreateUnits(flight, f, p, sideName, addAndSpaceTankers, calcWish, getParkSarAirBase, groupName, isHumain, is_helicopter, limitedParkTiming, parkSarAirBase, skillTab, type_withProp, units, waypoints)
				--********************************************************************************
				--create units FIN
				--********************************************************************************

				--********************************************************************************
				--datalink 2.9
				--********************************************************************************
				AtoFP.phase = "E"
				FlightDatalink(flight, f, p, units)

				----- define group -----
				-------- define group -----
				-------- define group -----

				AtoFP.phase = "F"
				local group
				group, type_withData = FlightFrequencyAndGroup(flight, f, p, sideName, goupTaskTemp, groupName, isHumain, navTargetPoints, start_time, type_withData, units, waypoints)

				AtoFP.phase = "G"
				cv_nbPlanetDeck, start_time, tempDeckPlace = FlightGroupAndSpawn(flight, f, p, role, addMessageForGroup, baseIsCarrier, baseIsFARP, carrierPlayer, cv_deckReservations, cv_nbPlaneSixPack, cv_nbPlanetDeck, cv_testSixPack, departure_time, farp_MorePlace, findDeckSlot, group, groupName, isHumain, limitedParkTiming, parkSarAirBase, pn, start_time, tempDeckPlace, testDeckPlace, waypoints)

				----- provisions for SAR -----

				--Truc débile pour obliger le premier SAR sur CV à etre un PEDRO
				AtoFP.phase = "H"
				AtoFP.phase = "H1"
				FlightSarAlert(flight, f, role, sideName, group, waypoints, isHumain, farp_MorePlace, limitedParkTiming, baseIsCarrier, parkSarAirBase, pedroOK, pn)
				----- provisions for interceptors/GCI/AWACS -----
				AtoFP.phase = "H2"
				FlightInterceptAwacs(flight, f, role, sideName, group, units, waypoints, isHumain, limitedParkTiming, baseIsCarrier, pn)

				AtoFP.phase = "H3"
				start_time = FlightPedroSar(flight, f, group, waypoints, start_time, pedroOK, playerTask)




				-- si multijoueur, les Flight AI commencent en vol + M11.j
				-- if ((Multi.NbGroup >= 1 or SingleWithDServerAiAir) and not isHumain and baseIsCarrier and flight[f].task ~= "Intercept") then
				AtoFP.phase = "H4"
				FlightStartAndCallsign(flight, f, p, role, sideName, group, units, waypoints, isHumain, start_time, departure_time, baseIsCarrier, pn)




				--M11.r ajoute une copie des avions multijoueur commançant en l'air // retab // recovery
				-- start RECOVERY*********************************************************************
				-- start RECOVERY*********************************************************************
				-- start RECOVERY*********************************************************************
				AtoFP.phase = "H5"
				local groupRTB = FlightRecovery(flight, f, p, group, isHumain, is_helicopter, altRole, pn)
				-- fin RECOVERY*********************************************************************
				-- fin RECOVERY*********************************************************************
				-- fin RECOVERY*********************************************************************



				-- modification M33_e 	Custom Briefing (e: divert/CV possible)
				-- place dans une table les bases proches des WPT
				AtoFP.phase = "I"
				FlightInsertInMission(flight, f, p, sideName, group, groupName, groupRTB, isHumain, is_helicopter, baseIsCarrier)






	--***************************--DEBUG INFO***************************
					--***************************--DEBUG INFO***************************
	--***************************--DEBUG INFO***************************
	--***************************--DEBUG INFO***************************
					--***************************--DEBUG INFO***************************
	--***************************--DEBUG INFO***************************
	--***************************--DEBUG INFO***************************
					--***************************--DEBUG INFO***************************
	--***************************--DEBUG INFO***************************





				AtoFP.phase = "J"
				FlightTriggersAndDebug(flight, f, p, group, units, waypoints, isHumain, infoFlight)
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



--=======================================================================================
-- Etape finale : voir ATO_FlightPlan\ATO_FP_90_Final.lua
-- On transmet les variables locales utilisées par l'étape finale.
--=======================================================================================
AtoFP.tempBaseAirStart = tempBaseAirStart
AtoFP.testDeckPlace = testDeckPlace
AtoFP.cv_deckReservations = cv_deckReservations
AtoFP.cv_testSixPack = cv_testSixPack
AtoFP.pack_L16_unitId = pack_L16_unitId
AtoFP.pack_SADL_unitId = pack_SADL_unitId
AtoFP.modify_Activate_GroupTime = modify_Activate_GroupTime
AtoFP.cv_nbPlanetDeck = cv_nbPlanetDeck
AtoFP.debugStart = debugStart

Include("ATO_FlightPlan/ATO_FP_90_Final.lua")
end)	-- fin de AtoFP.Guard
AtoFP.CheckEnd()
