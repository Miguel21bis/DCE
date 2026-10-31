--ATO_Generator_C_Core.lua
--Coeur du generateur de mission (ATO) : construction des draft sorties, assignation appareils/support/escorte, table ATO finale
--A charger APRES ATO_Generator_A_Debug.lua et ATO_Generator_B_Eval.lua
-------------------------------------------------------------------------------------------------------
if not versionDCE then versionDCE = {} end
versionDCE["ATO_Generator_C_Core.lua"] = "1.21.137"
-------------------------------------------------------------------------------------------------------

if Debug.debug then
	print("START ATO_Generator_C_Core.lua "..versionDCE["ATO_Generator_C_Core.lua"].." =-=-=-=-=-=-=-=-=-=-=-=-=-=-=")
end

-- ============================================================================
-- REGLAGE : réduction du minscore selon la couverture escorte
-- ============================================================================
--Pourquoi: si un package a les escortes qu'il demandait (en nombre), on descend son minscore
--pour autoriser sa création malgré une menace élevée / un score insuffisant.
--
--0    = aucun effet (comportement identique à avant)
--1    = minscore ramené à 0 quand l'escorte demandée est à 100% (couverture partielle = réduction proportionnelle)
--0.3  = à 100% d'escorte, minscore réduit de 30% ; à 50% d'escorte, réduit de 15% (proportionnel)
--
--A ajuster ici, avec l'expérience, sans toucher au reste du fichier.
ESCORT_MINSCORE_DISCOUNT = 0

local atoMainTaskFound = false

local multiPlaneSet = {}
local multiSquadSet = {}
local priorityMaxValue = {}

-- Etat final de génération par squad
SquadGenerationStatus = {}

local tgtList_Gen = DeepCopy(targetlist)

--firepower déjà assignée par target
--Pourquoi: éviter qu'un target continue à recevoir des packages inutiles
local targetAssignedFirepower = {}

--parse la table targetList, ignore les tasks Intercept, CAP, Refueling
-- et recupere la valeur maximal de priority
for sideName, targets in pairs(targetlist) do
	priorityMaxValue[sideName] = 0
	for targetN, target in pairs(targets) do
		if not target.inactive and not target.wargameLogistic and target.task ~= "Intercept" and target.task ~= "CAP" and target.task ~= "Refueling" and target.task ~= "SAR" and target.task ~= "CSAR" then
			if target.priority and target.priority > priorityMaxValue[sideName] then
				priorityMaxValue[sideName] = target.priority
			end
		end
	end
end

-- ============================================================================
-- WARGAME : ravitaillement aérien (airlift) - ETAPE 1 : lecture + log, RIEN n'est fabriqué
-- ============================================================================
--Pourquoi: DCE_Manager écrit dans la targetlist des entrées task="Transport" + wargameLogistic="airlift"
--(destination = un point WG_POINT_..., pas un aérodrome). Le générateur natif ne sait pas les traiter
--(Transport natif = target.base == unit.base + destination dans db_airbases).
--Étape 1 : on les sort de tgtList_Gen (donc aucune sortie générée, comportement inchangé) et on écrit dans le log
--ce qui SERAIT possible : quels squads d'hélicos peuvent faire le vol (Transport actif, charge, portée).
--Étape 2 (plus tard) : ces entrées seront réinjectées dans la génération.
--
--Règle de portée utilisée ici (estimation en ligne droite, comme le test natif route.lenght <= range*2) :
--  base -> entrepôt (wargameLoadX/Y, si présent) -> point -> base  <=  portée du loadout Transport x 2
WargameAirliftList = {}

local function wargameAirliftDiagnostic(sideName, target)

	local cargoKg = tonumber(target.wargameCargoKg) or 0
	local head = "AtoG WARGAME airlift "..tostring(target.name).." ("..tostring(sideName)..") cargo "..cargoKg.." kg -> "..tostring(target.destination)

	if not target.x or not target.y then
		AddLog(head.." | REFUSE: pas de position x/y dans l'entrée de la targetlist")
		return
	end

	local loadPoint = nil
	if target.wargameLoadX and target.wargameLoadY then
		loadPoint = { x = target.wargameLoadX, y = target.wargameLoadY }
	end

	local nbEligible = 0
	local report = {}

	for _, unit in pairs(oob_air[sideName] or {}) do

		if not unit.inactive and IsHelicopter[unit.type] and unit.tasks and unit.tasks["Transport"] then

			local reason = nil
			local base = db_airbases[unit.base]
			local ready = (unit.roster and unit.roster.ready) or 0
			local capacity = PayloadType and PayloadType[unit.type]

			--plus grande portée parmi les loadouts Transport de ce type
			local rangeMax = 0
			local loadoutsTransport = LoadoutsList[unit.type] and LoadoutsList[unit.type]["Transport"]
			for _, ltable in pairs(loadoutsTransport or {}) do
				if type(ltable) == "table" and tonumber(ltable.range) and ltable.range > rangeMax then
					rangeMax = ltable.range
				end
			end

			local trip = 0
			if not base or base.inactive == true or not base.x or not base.y then
				reason = "base '"..tostring(unit.base).."' invalide ou inactive"
			elseif ready <= 0 then
				reason = "aucun appareil prêt"
			elseif not capacity then
				reason = "capacité inconnue (PayloadType["..tostring(unit.type).."] absent)"
			elseif capacity < cargoKg then
				reason = "capacité "..capacity.." kg < "..cargoKg.." kg"
			elseif rangeMax <= 0 then
				reason = "pas de loadout Transport avec une portée pour ce type"
			else
				if loadPoint then
					trip = GetDistance(base, loadPoint) + GetDistance(loadPoint, target) + GetDistance(target, base)
				else
					trip = GetDistance(base, target) * 2
				end
				if trip > rangeMax * 2 then
					reason = "trajet "..math.floor(trip/1000).." km > portée x2 ("..math.floor(rangeMax*2/1000).." km)"
				end
			end

			if reason then
				report[#report + 1] = "    - "..tostring(unit.name).." ("..tostring(unit.type)..") NON: "..reason
			else
				nbEligible = nbEligible + 1
				report[#report + 1] = "    - "..tostring(unit.name).." ("..tostring(unit.type)..") OK: base "..tostring(unit.base)
					..", prêts "..ready..", capacité "..capacity.." kg, trajet "..math.floor(trip/1000).." km (portée x2 "..math.floor(rangeMax*2/1000).." km)"
			end
		end
	end

	local txt = head.." | squads possibles: "..nbEligible
	if #report > 0 then
		txt = txt.."\n"..table.concat(report, "\n")
	else
		txt = txt.."\n    - aucun squad d'hélicoptères avec la tâche Transport active"
	end

	AddLog(txt)
	if Debug.debug then print(txt) end
end

--repertorie les entrees wargame de tgtList_Gen dans WargameAirliftList (elles RESTENT dans tgtList_Gen : l'etape 2 les traite)
for sideName, targets in pairs(tgtList_Gen) do
	for i = #targets, 1, -1 do
		local target = targets[i]
		if type(target) == "table" and target.wargameLogistic == "airlift" then
			WargameAirliftList[#WargameAirliftList + 1] = { side = sideName, target = target }
		end
	end
end

for _, entry in ipairs(WargameAirliftList) do
	wargameAirliftDiagnostic(entry.side, entry.target)
end

--Vérifie si le loadout est compatible avec la météo actuelle
--Pourquoi: sortir la logique météo du pipeline principal pour simplifier le draft
local function checkWeatherEligibility(draftContext, currentLoadout, isDebugMode)
    local debugLocal = " "..currentLoadout.name
	local unit = draftContext.unit
	local task = draftContext.task

	local weatherEligible = true

	if mission.weather["clouds"]["density"] > 8 then

		local cloud_base = mission.weather["clouds"]["base"]
		local cloud_top = mission.weather["clouds"]["base"] + mission.weather["clouds"]["thickness"]

		if db_airbases[unit.base].elevation + 333 > cloud_base then
			if currentLoadout.adverseWeather == false then
				weatherEligible = false
                debugLocal = debugLocal .. " /n elevation + 333 > cloud_base & adverseWeather == false "
				addRejectReason(draftContext, "weather")
			end
		else
			if currentLoadout.hCruise and currentLoadout.hCruise > cloud_base and currentLoadout.hCruise < cloud_top then			--cruise alt is in the clouds
				if currentLoadout.adverseWeather == false then																	--loadout is not adverse weather capable
					weatherEligible = false																						--not eligible for this weather
					debugLocal = debugLocal .. " /n hCruise > cloud_base & adverseWeather == false "
                    addRejectReason(draftContext, "weather")
				end
			elseif currentLoadout.hAttack and currentLoadout.hAttack > cloud_base and currentLoadout.hAttack < cloud_top then		--attack alt is in the clouds
				if currentLoadout.adverseWeather == false then																	--loadout is not adverse weather capable
					weatherEligible = false																						--not eligible for this weather
					debugLocal = debugLocal .. " /n hAttack > cloud_base & adverseWeather == false "
                    addRejectReason(draftContext, "weather")
				end
			end

			if task == "Strike" or task == "Anti-ship Strike" or task == "Reconnaissance" then										--extra requirement for A-G tasks
				if currentLoadout.hAttack > cloud_base then																		--attack alt is above cloud base
					if currentLoadout.adverseWeather == false then																--loadout is not adverse weather capable
						debugLocal = debugLocal .. " /n Strike/Reconnaissance hAttack > cloud_base & adverseWeather == false "
                        weatherEligible = false																					--not eligible for this weather
					end
				end
			end
		end
		if mission.weather["enable_fog"] == true then															--fog
			if db_airbases[unit.base].elevation < mission.weather["fog"]["thickness"] then					--base elevation in fog
				if mission.weather["fog"]["visibility"] < 5000 then												--less than 5000m visibility
					if currentLoadout.adverseWeather == false then											--loadout is not adverse weather capable
						weatherEligible = false																--not eligible for this weather
                        debugLocal = debugLocal .. " /n enable_fog & adverseWeather == false "
                    end
				end
			end
		end
	end

    if weatherEligible then
        validateStep(draftContext, "weatherEligible")
    else
        -- rejectStep(draftContext, "weatherEligible", "no_weatherEligible", debugLocal)
		rejectStep(draftContext, "weatherEligible", "no_weatherEligible", debugLocal, "BLOCK_A", SafeGetLine())
    end
	return weatherEligible
end

local function checkAttributeEligibility(draftContext, currentLoadout, target, draftId, unit, isDebugModeA3)

	local debugLocal = " "..currentLoadout.name
	local attributeEligible = true

	if target.attributes and target.attributes[1] and target.attributes[1] ~= "" then
		-- Il faut que TOUS les attributs du target soient présents dans le loadout
		for _, target_attribute in ipairs(target.attributes) do
			-- debugLocal = debugLocal .. " /n target_attribute: " ..target_attribute
			local found = false
			for _, loadout_attribute in ipairs(currentLoadout.attributes or {}) do

				if target_attribute == loadout_attribute then
					found = true
                    validateStep(draftContext, "target_loadout_attributes")
					break
				else
					-- debugLocal = debugLocal .. " /n targetName: " ..target.name.." target_attribute: "..target_attribute
				end
			end

			if not found then
				attributeEligible = false

				debugLocal = debugLocal .. " /n targetName: " ..target.name.." target_attribute: "..target_attribute

                -- rejectStep(draftContext, "target_loadout_attributes", "no_full_target_attributes", debugLocal)
				rejectStep(draftContext, "target_loadout_attributes", "no_full_target_attributes", debugLocal, "BLOCK_A", SafeGetLine())
				break -- Un attribut manquant suffit à rendre le loadout inéligible
			end
		end
	end

	if target.attributesCond then
		attributeEligible = eval.group(target.attributesCond, unit, isDebugModeA3)
        if not attributeEligible then
            rejectStep(draftContext, "target_attributesCond", "no_full_target_attributesCond", debugLocal, "BLOCK_A", SafeGetLine())
        else
            validateStep(draftContext, "target_attributesCond")
        end
	end

	if isDebugModeA3 then
		debugLog("draftId"..draftId.." AtoG passe A_10 checkLoadoutEligibility() debugLocal: "..tostring(debugLocal))
	end

	return attributeEligible
end

local function computeTOTWindow(draftContext, currentLoadout, Daytime, mission_ini, camp, task, draftId, isDebugModeA2)

	local debug = ""
	-- local tot_from = 0																						--earliest Time on Target for this loadout
	-- local tot_to = 0
	draftContext.state.tot_from = 0
	draftContext.state.tot_to = 0

	if currentLoadout.day and currentLoadout.night then													--loadout is day and night capable
		draftContext.state.tot_from = 0																						--from mission start
		draftContext.state.tot_to = mission_ini.mission_duration																		--to mission end
		if task == "Intercept" or task == "SAR" then																			--for interceptors, tot_to is not limitted by mission duration
			draftContext.state.tot_to = 999999
		end
		debug = debug .. " A: tot_to "..draftContext.state.tot_to
	elseif currentLoadout.day then																		--loadout is day capable
		if Daytime == "night-day" then
			draftContext.state.tot_from = mission_ini.dawn - camp.time																--from dawn
			draftContext.state.tot_to = mission_ini.mission_duration																	--to mission end
			if task == "Intercept" or task == "SAR" then																		--for interceptors, tot_to is not limitted by mission duration
				draftContext.state.tot_to = mission_ini.dusk - camp.time
			end
			debug = debug .. " B1: tot_to "..draftContext.state.tot_to
		elseif Daytime == "day" then
			draftContext.state.tot_from = 0																					--from missiom start
			draftContext.state.tot_to = mission_ini.mission_duration																	--to mission end
			if task == "Intercept" or task == "SAR" then																		--for interceptors, tot_to is not limitted by mission duration
				draftContext.state.tot_to = mission_ini.dusk - camp.time
			end
			debug = debug .. " B2: tot_to "..draftContext.state.tot_to
		elseif Daytime == "day-night" then
			draftContext.state.tot_from = 0																					--from mission start
			draftContext.state.tot_to = mission_ini.dusk - camp.time																	--to dusk
			debug = debug .. " B3: tot_to "..draftContext.state.tot_to
		end

		debug = debug .. " B FIN: tot_to "..draftContext.state.tot_to

	elseif currentLoadout.night then																		--loadout is night capable
		if Daytime == "day-night" then
			draftContext.state.tot_from = mission_ini.dusk - camp.time																--from dusk
			draftContext.state.tot_to = mission_ini.mission_duration																	--to mission end
			if task == "Intercept" or task == "SAR" then																		--for interceptors, tot_to is not limitted by mission duration
				draftContext.state.tot_to = mission_ini.dawn - camp.time
			end
		elseif Daytime == "night" then
			draftContext.state.tot_from = 0																					--from mission start
			draftContext.state.tot_to = mission_ini.mission_duration																	--to mission end
			if task == "Intercept"  or task == "SAR" then																		--for interceptors, tot_to is not limitted by mission duration
				draftContext.state.tot_to = mission_ini.dawn - camp.time
			end
		elseif Daytime == "night-day" then
			draftContext.state.tot_from = 0																					--from mission start
			draftContext.state.tot_to = mission_ini.dawn - camp.time																	--to dawn
		end
		
		debug = debug .. " C FIN: tot_to "..draftContext.state.tot_to
		
	end

	if draftContext.state.tot_to < 0 then
		draftContext.state.tot_to = draftContext.state.tot_to + 86400
		debug = debug .. " D: tot_to "..draftContext.state.tot_to
	end
	if draftContext.state.tot_from < 0 then
		draftContext.state.tot_from = draftContext.state.tot_from + 86400
	end

	if isDebugModeA2 then
		debugLog("draftId"..draftId.." AtoG passe A_05b tot_to: "..draftContext.state.tot_to.." debug: "..tostring(debug))
	end

	return draftContext

end

DebugAssignAll = false
AltiHelicoMap = {}
AltitudeFloorNew = {}
PlayerSquad = {}
PlayerPlane = nil
DebugRoute = false

if Debug.Generator.affiche then
	if Debug.Generator.SpySquad == "" then
		Debug.Generator.SpySquad = nil
	end
	if Debug.Generator.SpyTask == "" then
		Debug.Generator.SpyTask = nil
	end
	if Debug.Generator.SpyTarget == "" then
		Debug.Generator.SpyTarget = nil
	end
end

--to track what caused lack of playable sortie for the player
--NOTE : l'ancienne table Playability_criterium (une vingtaine de booleens vagues) a ete retiree
--du chemin d'explication au joueur. Elle est conservee vide ci-dessous uniquement pour eviter
--une erreur "attempt to index a nil value" partout ou elle etait encore lue en debug
--(ex: ATO_PlayerAssign.lua ligne ~500, GenCriteriaOK() dans DEBRIEF_Master.lua).
--L'explication reelle des rejets se base desormais sur rejectStep/getDominantRejectReason/
--SquadGenerationStatus (ATO_Generator_A_Debug.lua), affichee via PrintPlayerRejectionSP/MP.
Playability_criterium = {}

--Suivi minimal conserve : uniquement pour detecter "tache CAP/Intercept jouable mais
--aucun hostile attendu dans la zone" (le reste de l'ancien systeme est retire).
HostileContextTrack = {}

local HostileContextKeys = {
	playerAssign_CAP               = true,
	playerAssign_CAP_hostile       = true,
	playerAssign_intercept         = true,
	playerAssign_intercept_hostile = true,
	playerAssign_SAR               = true,
}

--Ancien nom conserve pour ne pas toucher aux appels existants (C_Core.lua et
--ATO_PlayerAssign.lua en comptent une vingtaine). Les cles hors HostileContextKeys
--sont desormais silencieusement ignorees (c'etait l'ancien Playability_criterium).
function TrackPlayability(player_unit, criterium)
	if player_unit ~= true then
		return
	end
	if HostileContextKeys[criterium] then
		HostileContextTrack[criterium] = true
	end
end

function CheckAssignments()
	if HostileContextTrack.playerAssign_CAP == true and HostileContextTrack.playerAssign_CAP_hostile ~= true then
		print("CAP possible but no hostiles expected in the area")
	end

	if HostileContextTrack.playerAssign_intercept == true and HostileContextTrack.playerAssign_intercept_hostile ~= true then
		print("Interception possible but no hostiles expected in the area")
	end
end

--table to hold availability of aircraft
if not camp.Aircraft_availability and not camp.aircraft_availability then
	camp.Aircraft_availability = {}
elseif  camp.aircraft_availability then
	camp.Aircraft_availability = DeepCopy(camp.aircraft_availability)
	camp.aircraft_availability = nil
end
AcftAvail = camp.Aircraft_availability																				--link to table for easier reference

local debuGenTxt = ""
-- local debugLogs = {}

local denom_NeDonnePasTOUT = 1.5 --1.3		--nb, coef, dénominateur pour ne pas donner tous les chasseurs à l'escorte, en garder pour les intercepteur/cap
--plus le chiffre est petit, moins il y a de CAP et intercepteur
-- if AcftAvail[draft.name].unassigned - test_Aircraftnumber <= AcftAvail[draft.name].serviceable/denom_NeDonnePasTOUT then

local multipackByTargetName = {}

local bias = 4 -- Pondération pour target.firepower : plus grand = plus proche de `min

--calcul le nb d'avion en tout
local checkNbPlane = {
	blue = {
		beforMission = {
			ready = 0,
			reserve = 0,
			alreadyInFlight = 0,
		},
		thisMission = {
			used = 0,
			reserve = 0
		}
	},
	red = {
		beforMission = {
			ready = 0,
			reserve = 0,
			alreadyInFlight = 0,
		},
		thisMission = {
			used = 0,
			reserve = 0
		}
	},
}

local priorityRef = {
	blue =0,
	red = 0,
}
local newDraftByPriority = {
	blue = {},
	red = {},
}

--creation du targetlist par ordre de priorité
local targetListPrio = {
	blue = {},
	red = {},
}
local targetListPrioCheck = {
	blue = {},
	red = {},
}
local targetNamePrio = {
	blue = {},
	red = {},
}

if Debug.debug and oob_air then

	for side, units in pairs(oob_air) do
		for unitN, unit in pairs(units) do
			if not unit.inactive or unit.inactive == nil then
				if not unit.roster then
					checkNbPlane[side]["beforMission"].ready = checkNbPlane[side]["beforMission"].ready + unit.number
					checkNbPlane[side]["beforMission"].reserve = checkNbPlane[side]["beforMission"].reserve + unit.reserve
				else
					if unit.roster.ready then
						checkNbPlane[side]["beforMission"].ready = checkNbPlane[side]["beforMission"].ready + unit.roster.ready
					else
						print("AtoG strange, no roster.ready on this unit ")
						_affiche(unit, "unit")
						if Debug.debug then os.execute 'pause'
						end
					end

					if unit.roster.reserve then
						checkNbPlane[side]["beforMission"].reserve = checkNbPlane[side]["beforMission"].reserve + unit.roster.reserve
					-- else
					-- 	print("AtoG strange, no roster.reserve on this unit ")
					-- 	_affiche(unit, "unit")
					end

				end
			end
		end
	end

	if camp.Aircraft_availability then
		for squadName, squad in pairs(camp.Aircraft_availability) do
			if squad then
				if squad.unavailable then
					local squadSide = FoundSquadSide(squadName)
					if squadSide then

						checkNbPlane[squadSide]["beforMission"].alreadyInFlight = checkNbPlane[squadSide]["beforMission"].alreadyInFlight + #squad.unavailable
					else
						-- print("AtoG strange, squad.unavailable on this squad "..squadName)
						AddLog("AtoG strange, squad.unavailable on this squad "..squadName)
						-- _affiche(squad, "squad")
						-- if Debug.debug then os.execute 'pause'
						-- end

					end
				end
			end
		end

	end
end

--crer une table identique, en enlevant les infos des layers 
for mapName, layers in pairs(AltitudeFloor) do
	if string.lower(mapName) == string.lower(mission.theatre) then
		for alti, layer in pairs(layers) do

			if not AltitudeFloorNew then AltitudeFloorNew = {} end
			if not AltitudeFloorNew[alti] then AltitudeFloorNew[alti] = {} end

			--structure relevant des dessins de ligne de l editeur de mission
			if layer[1].mapY then
				for PolyN = 1, #layer do

					local tempAlti = {}

					for pointN, point in ipairs(layer[PolyN].points) do
						tempAlti[pointN] = {
							x = point.x + layer[PolyN].mapX,
							y = point.y + layer[PolyN].mapY,
						}

					end
					table.insert(AltitudeFloorNew[alti], tempAlti)
				end
			--structure épuré, issue d un plan de vol, avec un seul polygone
			else
				AltitudeFloorNew[alti] = layer
			end
		end
	end
end

local totalPlanePerTask = {
	red = {},
	blue = {},
	neutral = {},
}

--Nettoie les appareils indisponibles expirés
--Pourquoi: sortir le nettoyage availability du pipeline principal
local function cleanupUnavailableAircraft(unit)

	for u = #AcftAvail[unit.name].unavailable, 1, -1 do

		if AcftAvail[unit.name].unavailable[u] > CampTotalTimeH then
			AcftAvail[unit.name].unavailable[u] = 0
		end

		if CampTotalTimeH >= AcftAvail[unit.name].unavailable[u] then
			table.remove(AcftAvail[unit.name].unavailable, u)
		end
	end
end

--Calcule les appareils réellement disponibles mécaniquement
--Pourquoi: sortir le calcul serviceability du pipeline principal
local function computeServiceableAircraft(unit, sideName)

	local aircraft_serviceable = 0

	local serviceability = 0.8

	if unit.serviceability then
		serviceability = unit.serviceability
	end

	if multiPlaneSet and multiPlaneSet[sideName] and multiPlaneSet[sideName][unit.type] and multiPlaneSet[sideName][unit.type][unit.name] then
		aircraft_serviceable = unit.roster.ready
	else
		for s = 1, unit.roster.ready do
			if math.random(1, 100) <= serviceability * 100 then
				aircraft_serviceable = aircraft_serviceable + 1
			end
		end
	end

	return aircraft_serviceable
end

--Missions traditionnellement solo en aviation : unité minimale de 1 au lieu de 2
local SOLO_TASKS = {
	["AWACS"] = true,
	["AFAC"] = true,
	["Refueling"] = true,
	["Reconnaissance"] = true,
}

--Répartit les avions d'un squad entre ses tâches actives, au prorata de tasksCoef, par paires
--(unité de 2, sauf tâches solo type AWACS/AFAC/Refueling/Reconnaissance = unité de 1).
--Pourquoi: un squad avec Escort=5 et CAP=1 doit voir ses avions se répartir ~5/6 Escort, ~1/6 CAP,
--pas systématiquement 100% sur l'une ou l'autre. Une tâche dont la part arrondie tombe à 0 est
--simplement absente de la table retournée (pas assez d'avions pour l'ouvrir en paire complète).
local function allocateAircraftByTask(unit, totalAvailable)

	if not unit.tasksCoef or not unit.tasks or totalAvailable <= 0 then
		return nil
	end

	local candidates = {}
	local totalCoef = 0

	for taskName, enabled in pairs(unit.tasks) do
		if enabled then
			local coef = unit.tasksCoef[taskName] or 1
			if coef > 0 then
				candidates[#candidates + 1] = {
					name = taskName,
					coef = coef,
					unitSize = SOLO_TASKS[taskName] and 1 or 2,
				}
				totalCoef = totalCoef + coef
			end
		end
	end

	if #candidates == 0 or totalCoef <= 0 then
		return nil
	end

	if #candidates == 1 then
		return { [candidates[1].name] = totalAvailable }
	end

	--1er passage: part proportionnelle, arrondie au multiple de unitSize INFERIEUR
	local allocation = {}
	local usedTotal = 0

	for _, c in ipairs(candidates) do
		local rawShare = totalAvailable * (c.coef / totalCoef)
		local units = math.floor(rawShare / c.unitSize)
		local count = units * c.unitSize
		allocation[c.name] = count
		c.remainder = rawShare - count
		usedTotal = usedTotal + count
	end

	--2eme passage: distribue ce qui reste (par paquets de unitSize) aux tâches ayant le plus gros reste
	table.sort(candidates, function(a, b) return a.remainder > b.remainder end)

	local remaining = totalAvailable - usedTotal
	local guard = 0

	while remaining > 0 and guard < #candidates * 20 do
		local c = candidates[(guard % #candidates) + 1]
		if remaining >= c.unitSize then
			allocation[c.name] = allocation[c.name] + c.unitSize
			remaining = remaining - c.unitSize
		end
		guard = guard + 1
	end

	return allocation
end

--Prépare tout le contexte UNIT du draft
--Pourquoi: sortir les validations unit/base/availability de la cascade principale
local function prepareUnitContext(draftContext, sideName)

	local unit = draftContext.unit

	if unit.inactive then
		-- rejectStep(draftContext, "unit", "inactive")
		rejectStep(draftContext, "unit", "inactive", "inactive", "BLOCK_A", SafeGetLine())
		
		return false
	end

	TrackPlayability(unit.player, "active_unit")

	local base = db_airbases[unit.base]

	if not base or base.inactive == true or not base.x or not base.y then
		-- rejectStep(draftContext, "base", "invalid_airbase")
		rejectStep(draftContext, "base", "invalid_airbase", "invalid_airbase", "BLOCK_A", SafeGetLine())
		return false
	end

	TrackPlayability(unit.player, "base")

	if AcftAvail[unit.name] == nil then
		AcftAvail[unit.name] = {}
	end

	if AcftAvail[unit.name].unavailable == nil then
		if unit.unavailable then
			AcftAvail[unit.name].unavailable = unit.unavailable
		else
			AcftAvail[unit.name].unavailable = {}
		end
	end

	--Pourquoi: cette fonction est appelée UNE FOIS PAR TENTATIVE DE DRAFT (une fois par cible/tâche essayée),
	--pas une fois par squad. Recalculer/écraser la disponibilité à CHAQUE appel revenait à retirer au sort
	--et remplacer le nombre d'avions disponibles à chaque tentative -> le compteur final dépendait du DERNIER
	--tirage aléatoire rencontré, pas des vrais avions du squad.
	--MAIS AcftAvail = camp.Aircraft_availability persiste au-delà de cette seule fonction (géré par camp,
	--sauvegardé/rechargé avec la campagne), et un cycle de génération raté doit libérer les avions qu'il
	--avait réservés pour le cycle suivant (MissionInstance). Problème : MissionInstance seul ne distingue
	--pas "nouveau cycle dans la même génération" de "nouvelle génération de mission" (ex: bouton "Next
	--Mission"), qui repart généralement de MissionInstance=1 aussi -> on ajoute CampTotalTimeH (le temps de
	--campagne), qui lui avance forcément entre deux missions mais reste fixe entre deux cycles d'une même
	--tentative. On recalcule dès que L'UN OU L'AUTRE a changé.
	local currentMissionInstance = MissionInstance or 0
	local currentCampTime = CampTotalTimeH or 0

	if AcftAvail[unit.name].unassigned == nil
		or AcftAvail[unit.name].computedAtCycle ~= currentMissionInstance
		or AcftAvail[unit.name].computedAtTime ~= currentCampTime
	then

		local aircraft_serviceable = computeServiceableAircraft(unit, sideName)

		AcftAvail[unit.name].ready = unit.roster.ready
		AcftAvail[unit.name].serviceable = aircraft_serviceable

		cleanupUnavailableAircraft(unit)

		local aircraft_available = unit.roster.ready - #AcftAvail[unit.name].unavailable

		if aircraft_serviceable < aircraft_available then
			aircraft_available = aircraft_serviceable
		end

		AcftAvail[unit.name].available = aircraft_available
		AcftAvail[unit.name].assigned = 0
		AcftAvail[unit.name].unassigned = aircraft_available
		AcftAvail[unit.name].computedAtCycle = currentMissionInstance
		AcftAvail[unit.name].computedAtTime = currentCampTime

		--Pourquoi: répartit une fois pour toutes le stock de ce squad entre ses tâches (tasksCoef),
		--pour que Part A (tâches principales) et Part B (support/escorte) puisent chacune dans SA part
		--au lieu de se disputer le même pool global en tout-ou-rien.
		AcftAvail[unit.name].taskCap = allocateAircraftByTask(unit, aircraft_available)
		AcftAvail[unit.name].taskUsed = {}

		if Debug.debug and AcftAvail[unit.name].taskCap then
			local txt = "AtoG ALLOCATION_PAR_TACHE (cycle "..tostring(currentMissionInstance)..", t="..tostring(currentCampTime)..") "..unit.name..": "
			for taskName, count in pairs(AcftAvail[unit.name].taskCap) do
				txt = txt..taskName.."="..count.." "
			end
			debugLog(txt.."(total: "..aircraft_available..")")
		end
	end

	draftContext.aircraft_available = AcftAvail[unit.name].available

	if AcftAvail[unit.name].available <= 0 then
		-- rejectStep(draftContext, "NbAircraft", "no_aircraft_available")
		rejectStep(draftContext, "NbAircraft", "no_aircraft_available", "no_aircraft_available", "BLOCK_A", SafeGetLine())
		return false
	end

	validateStep(draftContext, "NbAircraft")
	TrackPlayability(unit.player, "available_aircraft")

	return true
end

--check le Loadout pour voir s'il y a des erreurs
-- require("Active/Loadouts_archive")
local error = 0
local debugTempFLIGHT
for side, units in pairs(oob_air) do
-- db_loadouts = {
	-- ["AV8BNA"] = {
		-- ["Anti-ship Strike"] = {

	for unitN, unit in pairs(units) do
		if not unit.inactive then
			if type(unit.tasks) == "table" then
				for task, task_bool in pairs(unit.tasks) do
					if task_bool and task ~= "Spotter" then

						local foundTaskAndCountry = false

						if LoadoutsList[unit.type] and LoadoutsList[unit.type] ~= nil then

							if LoadoutsList[unit.type][task] and LoadoutsList[unit.type][task] ~= nil then

								for loadout_name, ltable in pairs(LoadoutsList[unit.type][task]) do
									if ltable and type(ltable) == "table" then

										local countryEligible = false
										if ltable.country == nil  then
											countryEligible = true
											foundTaskAndCountry = true
										elseif type(ltable.country) == "string" then
											if string.lower(ltable.country) == string.lower(unit.country) or string.lower(ltable.country) == "all" then
												countryEligible = true
												foundTaskAndCountry = true
											end

										elseif type(ltable.country) == "table" then
											for n, countryLabel in pairs(ltable.country) do
												if string.lower(countryLabel) == string.lower(unit.country) or string.lower(countryLabel) == "all" then
													countryEligible = true
													foundTaskAndCountry = true
													break
												end
											end
										end

										if countryEligible then
											--creation table du nombre d'avion dispo pour une task
											if unit.roster and unit.roster.ready then
												if not totalPlanePerTask[side][task] then totalPlanePerTask[side][task] = 0 end
												totalPlanePerTask[side][task] = totalPlanePerTask[side][task] +	unit.roster.ready
											end
										end
									else
										-- print("AtoG error_A unit.type: |"..unit.type.."| not found in db_loadouts")
										print("AtoG error_A: no task |"..tostring(task).."| in the loadout for this unit:? "..tostring(unit.type).."|")
										error = error + 1
									end
								end

							elseif task ~= "Spotter" then

								debugTempFLIGHT = "AtoG error_B: no task |"..tostring(task).."| in the loadout for this unit:? "..tostring(unit.type).."|"
								AddLog(debugTempFLIGHT)
								error = error + 1
							end

						else
							debugTempFLIGHT = "AtoG error_C: |"..unit.type.."| not found in db_loadouts. A problem with the campaigns_code_loadout code? |"..tostring(camp.code_loadout).."|"
							AddLog(debugTempFLIGHT)
							error = error + 1
						end

						if not foundTaskAndCountry then
							debugTempFLIGHT = "AtoG error_D: |"..unit.type.."| |"..task.."| not found in db_loadouts for this country: |"..tostring(unit.country).."|"
							AddLog(debugTempFLIGHT)
							error = error + 1
						end
					end
				end
			end
		end
	end
end

if error >= 1 then

	debugTempFLIGHT = "AtoG error: ".." With so many errors using the Central loadout, there may be a custom loadout in the /Init folder \n "
	.."To do this, set the \"selectLoadout\" variable to \"init\" in the conf_mod"

	AddLog(debugTempFLIGHT)

	local loadout_str = "Loadouts_archive = " .. TableSerialization(LoadoutsList, 0)	--make a string
	local loadoutFile = io.open("Active/Loadouts_archive.lua", "w") or error("Failed to open debug file")
	loadoutFile:write(loadout_str)																--save new data
	loadoutFile:close()

	if BugList and type(BugList) == "table" and #BugList >= 1 then
		local table_Str = "BugList = " .. TableSerialization(BugList, 0)
		local bugFile = io.open("Debug/BugList.lua", "w") or error("Failed to open debug file")
		bugFile:write(table_Str)
		bugFile:close()
	end

	-- os.execute('start "BugList" "notepad.exe" "Debug/BugList.lua"')			--open the BugList file with notepad

	-- print("Read the Debug/BugList.lua file for more information about errors.")

	-- os.execute 'pause'
end

local function table_move(src, start, stop, dest, tbl)
    tbl = tbl or src
    local offset = dest - start
    if offset > 0 then -- Décalage vers l'avant
        for i = stop, start, -1 do
            tbl[i + offset] = src[i]
        end
    else -- Décalage vers l'arrière
        for i = start, stop do
            tbl[i + offset] = src[i]
        end
    end
    return tbl
end

local function round(num)
local dec = 2
  local mult = 10^(dec or 0)
  return math.floor(num * mult + 0.5) / mult
end

local baseFARP = {
	blue = {},
	red = {}
}

--creation d'une table recesant tous les noms des unités:
local squadByName = {}
for side, units in pairs(oob_air) do
	if units and units ~= nil then
		for unitN, unit in pairs(units) do
			if unit and unit.name then
				squadByName[unit.name] = true
			end
		end
	end
end

--Creation d'une table des FARP
for baseName, base in pairs(db_airbases) do

	if (base.type and base.type == "FARP") or (type(baseName) == "string" and string.find(baseName, "FARP")) then
		--get airbase position
		local farpData = {																				--get the x-y coordinates of the airbase where the unit is located
			x = base.x,
			y = base.y,
			h = base.elevation,
			BaseAirStart = base.BaseAirStart,
			name = baseName,
		}
		-- ensure BaseFARP[side] exists before inserting (avoid nil when base.side missing or unexpected)
		if base and base.side then
			if not baseFARP[base.side] then baseFARP[base.side] = {} end
			table.insert(baseFARP[base.side], farpData)
		else
			-- fallback: keep problematic FARPs to a neutral bucket so code doesn't error out
			if not baseFARP["neutral"] then baseFARP["neutral"] = {} end
			table.insert(baseFARP["neutral"], farpData)
		end
	end
end

--status report counters
local status_counter_sorties = 0
local status_counter_escorts = 0
local status_counter_ATO = 0

--table to store draft sorties (all valid unit/task/loadout/target combinations)
local draftSorties = {
	blue = {},
	red = {}
}

if Debug.debug and Debug.Generator.affiche then
	_affiche(Multi, "ATO_G_Multi: ")
end

for k = 1, Multi.NbGroup do

    local group = Multi.Group[k]
    local side  = group.side
    local pType = group.PlaneType
    -- local unitName = group.unitName
    local squadName = group.squad or group.unitName
    local planeType = group.plane or group.PlaneType
    local task  = group.task
    local count = group.NbPlane or 0

    multiSquadSet[side] = multiSquadSet[side] or {}
	multiSquadSet[side][squadName] = multiSquadSet[side][squadName] or true

	--==============
    multiPlaneSet[side] = multiPlaneSet[side] or {}
    multiPlaneSet[side][planeType] =  multiPlaneSet[side][planeType] or {}
	--======================

	multiPlaneSet[side][planeType][squadName] = multiPlaneSet[side][planeType][squadName] or { InitNbPlane = 0 }

    -- Raccourci vers le niveau "PlaneType" pour simplifier la suite
    -- local planeTypeData = multiPlaneSet[side][unitName]
    local planeTypeData = multiPlaneSet[side][planeType][squadName]

    if not planeTypeData[task] then
        -- planeTypeData[task] = { NbPlane = 0, InitNbPlaneByTask = 0 } 
		-- planeTypeData[task] = {  InitNbPlaneByTask = 0 }
		planeTypeData[task] = true
    end

    -- Raccourci vers le niveau "task"
    local taskData = planeTypeData[task]

    -- 3️ Accumulation des données
    -- taskData.NbPlane            = taskData.NbPlane + count
    -- taskData.InitNbPlaneByTask  = taskData.NbPlane  -- Copie la valeur cumulée courante

    planeTypeData.InitNbPlane   = planeTypeData.InitNbPlane + count
	planeTypeData.NbPlane    = 0
	planeTypeData.checked    = false
end

if Debug.debug and Debug.Generator.affiche then
	-- _affiche(Multi, "ATO_G_Multi: ")
	_affiche(multiPlaneSet, "ATO_G_multiPlaneSet: ")
    _affiche(multiSquadSet, "ATO_G_multiSquadSet: ")
end

if Debug.debug then
	for side, units in pairs(oob_air) do
		if units and units ~= nil then
			for unitN, unit in pairs(units) do
				if unit.player then
					if Debug.debug then
						print("ATO_G_C playable "..unit.type.." ready "..unit.roster.ready)
					end
				end
			end
		end
	end

	for side, units in pairs(oob_air) do
		if units and units ~= nil then
			for unitN, unit in pairs(units) do
				if unit.player then
					if Debug.debug then
						print("ATO_G_D TOUS "..unit.type.." ready "..unit.roster.ready)
					end
				end
			end
		end
	end
end

if Multi and Multi.Group then
	for kGroupN, multiGroup in pairs(Multi.Group) do
		for side, units in pairs(oob_air) do
			if units and units ~= nil then
				for unitN, unit in pairs(units) do
					if not unit.inactive and unit.name == multiGroup.unitName and side == multiGroup.side and unit.roster.ready < multiGroup.NbPlane   then
						unit.roster.ready = multiGroup.NbPlane * 2
						if Debug.debug then
							print("ATO_G_E set Nplane "..unit.type.." ready "..unit.roster.ready)
						end
					end
				end
			end
		end
	end

	-- --augmente la priority de la cible choisie
	-- for kGroupN, multiGroup in pairs(Multi.Group) do
	-- 	for targetN, target in pairs(tgtList_Gen[multiGroup.side]) do
	-- 		if not target.inactive and not target.priorityINIT and Multi.Target and target.titleName == Multi.Target[multiGroup.side] then
	-- 			target.priorityINIT = target.priority
	-- 			target.priority = target.priority * 4
	-- 			if Debug.debug then print("ATO_G_F multiGroup target.priority "..target.priority.." titleName "..target.titleName) end
	-- 			break
	-- 		end
	-- 	end
	-- end
end

--Retourne la config MP d'un side/type/task si elle existe
--Pourquoi: éviter les cascades de if et les accès nil dangereux
--Retourne la config MP d'un side/type/squad/task si elle existe
--Pourquoi: éviter les mélanges aléatoires entre plusieurs squads d'un même appareil
local function getMultiPlaneTask(sideName, squadName, planeType, task)

	if not multiPlaneSet then
		return nil
	end

	if not multiPlaneSet[sideName] then
		return nil
	end

	if not multiPlaneSet[sideName][planeType] then
		return nil
	end

	if not multiPlaneSet[sideName][planeType][squadName] then
		return nil
	end

	if not multiPlaneSet[sideName][planeType][squadName][task] then
		return nil
	end

	return multiPlaneSet[sideName][planeType][squadName][task]
end

local function getMultiPlane(sideName, squadName, planeType)

	if not multiPlaneSet then
		return nil
	end

	if not multiPlaneSet[sideName] then
		return nil
	end

	if not multiPlaneSet[sideName][planeType] then
		return nil
	end

	if not multiPlaneSet[sideName][planeType][squadName] then
		return nil
	end

	return multiPlaneSet[sideName][planeType][squadName]
end

table.sort(targetlist["blue"], function(a,b) return a.priority > b.priority  end)
table.sort(targetlist["red"], function(a,b) return a.priority > b.priority  end)

-- --packages collaboratifs
-- --Pourquoi: permettre à plusieurs squads de cumuler leur firepower sur une même cible
local pendingPackages = {}

--Construit les draft sorties pour une combinaison valide
--Pourquoi: sortir le bloc de génération de sortie du pipeline principal et réduire fortement l'indentation
local function buildDraftSorties(
				draftContext,
				sideName,
				task,
				target,
				currentLoadout,
				flights_requested,
				multipack,
				unit,
				mpConfig,
				draftId,
				isDebugModeA3
			)

	repeat

		local idTemp = "id"..#draftSorties[sideName]+1

		if isDebugModeA3 then
			debugLog( "draftId"..draftId .." AtoG BUILD_SORTIE "
				..idTemp .." aircraft_assign: " ..tostring(draftContext.state.futureAircraftAssign)
			)
		end

		--firepower apportee par cette sortie
		--Pourquoi: cumuler plusieurs squads sur une meme cible
		local firepowerContribution = draftContext.state.futureAircraftAssign * currentLoadout.firepower

		if not pendingPackages[target.titleName] then
			pendingPackages[target.titleName] = {
				firepower = 0,
				required = target.firepower.min,
				sorties = {},
				completed = false,
			}
		end

		pendingPackages[target.titleName].firepower = pendingPackages[target.titleName].firepower + firepowerContribution

		local draftSortiesEntry = {
			name = unit.name,
			playable = draftContext.clientPlayer,
			side = draftContext.side,
			type = unit.type,
			modification = unit.modification,
			callsign = unit.callsign,
			callsignId = unit.callsignId,
			helicopter = unit.helicopter,
			number = draftContext.state.futureAircraftAssign,
			flights = flights_requested,
			country = unit.country,
			livery = unit.livery,
			sidenumber = unit.sidenumber,
			liveryModex = unit.liveryModex,
			base = unit.base,
			airdromeId = db_airbases[unit.base].airdromeId,
			parking_id = unit.parking_id,
			skill = unit.skill,
			task = task,
			tasks = unit.tasks,
			loadout = DeepCopy(currentLoadout),
			target = DeepCopy(target),
			target_name = target.titleName,
			targetPriority = DeepCopy(target.priority),
			-- priorityIni = DeepCopy(target.priority),
			route = draftContext.state.route,
			tot_from = draftContext.state.tot_from,
			tot_to = draftContext.state.tot_to,
			support = {
				["Escort"] = {},
				["SEAD"] = {},
				["Escort Jammer"] = {},
				["Flare Illumination"] = {},
				["Laser Illumination"] = {},
				["Strike"] = {},
			},
			multipack = multipack,
			threatsGround = draftContext.state.route.threats.ground_total,
			threatsAir = draftContext.state.route.threats.air_total,
			id = "DraftId"..draftId.."_id"..#draftSorties[sideName]+1,
			rejected = {},
			main_overideMP = draftContext.overideMP_A,
			remainingFirepower = draftContext.state.remainingFirepower,
			firepowerContribution = firepowerContribution,
			packageTarget = target.titleName,
			-- multiPlaneSet_B = multiPlaneSet,
			baseScore = 0,
			finalScore = 0,
		}

		draftSortiesEntry.target.titleName = target.titleName

		draftSortiesEntry.scoreAdd = 0.000011
		draftSortiesEntry.scoreCoef = 1

		local route_threat = draftContext.state.route.threats.ground_total
			+ draftContext.state.route.threats.air_total

		if task == "CAP" or task == "Intercept" or task == "SAR" then
			draftSortiesEntry.score = target.priority
		else
			draftSortiesEntry.score = target.priority / route_threat
		end

		if unit.player then
			-- draftSortiesEntry.score = draftSortiesEntry.score * 1.5
			draftSortiesEntry.score = draftSortiesEntry.score * 500
			draftSortiesEntry.scoreCoef = 500

			if Debug.debug then
				debugLog("draftId"..draftId.." AtoG PLAYER_SCORE_INIT "..unit.name
					.." target.priority: "..tostring(target.priority)
					.." route_threat: "..tostring(route_threat)
					.." score_apres_coef: "..tostring(draftSortiesEntry.score)
					.." scoreCoef: "..tostring(draftSortiesEntry.scoreCoef)
				)
			end
		end

		if draftContext.overideMP_A then
			
			if draftSortiesEntry.score < 100 then
				draftSortiesEntry.scoreAdd = draftSortiesEntry.score + 100
				
				draftSortiesEntry.score = draftSortiesEntry.score + 100
			end

			if not target.newPriority then
				
				local maxVal = priorityMaxValue[draftSortiesEntry.side]
				local coef = (maxVal / target.priority) + 0.1
                
                -- Si la priorite etait deja superieure ou egale au max, on s'assure que le coef soit au moins > 1
                if coef <= 1 then coef = 1.1 end
                
                -- Application du coefficient
                target.priority = target.priority * coef + 1
				target.newPriority = true
				draftSortiesEntry.targetPriority = draftSortiesEntry.targetPriority * coef + 1
                
				-- target.newPriority = true
				-- target.priority = target.priority * 6
				-- draftSortiesEntry.targetPriority = draftSortiesEntry.targetPriority * 6
			end
		end

		draftSortiesEntry.baseScore = draftSortiesEntry.score
		draftSortiesEntry.finalScore = draftSortiesEntry.score

		--Pourquoi (v1.21.138): draftContext.rejectReasons grandit a chaque rejet du squad (tous ses couples
		--cible/loadout/variante) ; le DeepCopy en entier a CHAQUE draft donnait un cout qui grossit au carre
		--(~420 Ko par draft, ~600 Mo en tout, memoire ET temps). Plus rien ne lit ce champ en dehors du debug :
		--on ne garde que le nombre total et les 10 derniers rejets, SANS copie (references partagees).
		local rejectList = draftContext.rejectReasons or {}
		local rejectRecent = {}
		for i = math.max(1, #rejectList - 9), #rejectList do
			rejectRecent[#rejectRecent + 1] = rejectList[i]
		end
		for rejectKey, rejectValue in pairs(rejectList) do
			if type(rejectKey) == "string" then
				rejectRecent[rejectKey] = rejectValue
			end
		end

		draftSortiesEntry.debugContext = {
			rejectReasons = rejectRecent,
			rejectReasonsTotal = #rejectList,
			overideMP_A = draftContext.overideMP_A,
			passPackmax = draftContext.passPackmax,
		}

		if not draftSorties[sideName] then
			draftSorties[sideName] = {}
		end

		draftSorties[sideName][#draftSorties[sideName] + 1] = draftSortiesEntry
		if MemTick then MemTick("A draft") end

		table.insert(
			pendingPackages[target.titleName].sorties,
			draftSortiesEntry.id
		)

		local packageData = pendingPackages[target.titleName]

		if packageData.firepower >= packageData.required then

			packageData.completed = true

			if isDebugModeA3 then
				debugLog(
					"draftId"..draftId
					.." A_10_E PACKAGE COMPLETE "
					..target.titleName
					.." packageData.firepower/packageData.required: "
					..math.floor(packageData.firepower)
					.."/"
					..math.floor(packageData.required)
				)
			end

		else

			if isDebugModeA3 then
				debugLog(
					"draftId"..draftId
					.." A_10_C PACKAGE PENDING "
					..target.titleName
					.." firepower: "
					..math.floor(packageData.firepower)
					.."/"
					..math.floor(packageData.required)
				)
			end
		end

		-- draftContext.generatedSortie = true
		draftContext.generatedSortie = true
		draftContext.anyMissionGenerated = true

		--annonce (console + briefing) si cette sortie a ete obtenue grace a RelaxGeneration ;
		--relaxAnnounced evite de repeter l'annonce a chaque tour de la boucle repeat ci-dessous.
		if not draftContext.relaxAnnounced then
			draftContext.relaxAnnounced = true
			AnnounceRelaxedLimits(unit.name, target.titleName, currentLoadout.name)
		end

		validateStep(draftContext, "sortie")

		if task == "AWACS" or task == "Refueling" or task == "AFAC" then
			draftContext.state.futureAircraftAssign = draftContext.state.futureAircraftAssign - 1

		elseif draftContext.overideMP_A then

			local splitSize = 4

			draftContext.state.futureAircraftAssign = draftContext.state.futureAircraftAssign - splitSize
		else
			draftContext.state.futureAircraftAssign = 0
		end

	until draftContext.state.futureAircraftAssign <= 0
end

--Traite un loadout entièrement validé jusqu'à la génération des sorties
--Pourquoi: supprimer une énorme profondeur d'indentation du pipeline principal
local function processEligibleLoadout(draftContext, sideName, task, target, target_name, unit, currentLoadout, Daytime, airbasePoint, draftId, isDebugModeA3, i_timmer01 )

	validateStep(draftContext, "loadout")

	--attention, overideMP_A garde une ancienne valeur a true
	draftContext.overideMP_A = false

	if ( target.base and  ((task == "Intercept" and target.base == unit.base) or (task == "SAR" and target.base == unit.base) ) or (task == "Transport" and target.base == unit.base) or (task == "Nothing" and target.base == unit.base)
		) or (task ~= "Intercept" and task ~= "Transport" and task ~= "Nothing" and task ~= "SAR") then
		--intercept and transport missions are only assigned to units of a certain base as per targetlist	

		TrackPlayability(unit.player, "target")																							--track playabilty criterium has been met

		local mpTask_Check = getMultiPlaneTask(sideName, unit.name, unit.type, task)
		local mp_Data = getMultiPlane(sideName, unit.name, unit.type)

        local debugMulti = ""

		if mpTask_Check and mp_Data then

			if Multi.Target and Multi.Target[sideName] then
				debugMulti = debugMulti.."\n"..("AtoG passe A_AAe Multi.Target[side] "..tostring(Multi.Target[sideName]) .. " ==? target_name? " .. tostring(target_name))
				if Multi.Target[sideName] == target_name  then
					debugMulti = debugMulti.."\n"..("AtoG passe A_AAf Multi.Target[side] "..tostring(Multi.Target[sideName]) .. " ==? target_name? " .. tostring(target_name).." "..unit.type.." "..tostring(task))
					draftContext.overideMP_A = true
					if target.powerfire and target.powerfire.max then
						if target.powerfire.max < mp_Data.NbPlane then
							target.powerfire.max = mp_Data.NbPlane + 1
						end
					end
				end
			else
				debugMulti = debugMulti.."\n"..("AtoG passe A_AAg ==? target_name? " .. tostring(target_name).." "..unit.type.." "..tostring(task))

				Multi.Target = {}
				Multi.Target[sideName] = target_name
				draftContext.overideMP_A = true
			end

			draftContext.clientPlayer = true
		end

		if isDebugModeA3 then
			debugLog("draftId"..draftId.." "..debugMulti)
		end

		if isDebugModeA3 then
			debugLog("draftId"..draftId.." AtoG passe A_11 overRideMP_A? "..tostring(draftContext.overideMP_A).." Befor firepower Condition".." || "..target_name
			.." "..unit.type
			.." firepower.min? "..target.firepower.min
			.." <= aircraft_available: ".. AcftAvail[unit.name].available
			.." * firepower "..currentLoadout.firepower
			)
		end

		local passHumain = true
		if unit.humainOnly then
			passHumain = false
			if (unit.player or unit.client) then
				passHumain = true
			else

			end
		end

		--firepower individuelle apportée par ce squad
		--Pourquoi: permettre les packages collaboratifs
		local squadFirepower = AcftAvail[unit.name].available * currentLoadout.firepower

		local firepowerValid = false

		--cas normal: le squad peut satisfaire seul la cible
		if passHumain and squadFirepower >= target.firepower.min then
			firepowerValid = true
		end

		--cas MP joueur
		if draftContext.overideMP_A then
			firepowerValid = true
		end

		--package collaboratif
		--Pourquoi: autoriser les squads insuffisants seuls mais utiles collectivement
		if not firepowerValid and target.firepower.packmax and target.firepower.packmax > 1 then

			firepowerValid = true
			draftContext.passPackmax = true

		end

		--mode degrade : a partir de la 5e tentative infructueuse, on ignore ce manque de
		--firepower pour le draft du joueur plutot que de ne rien lui proposer (cf RelaxGeneration,
		--ATO_Generator_A_Debug.lua). L'ecart exact est garde pour etre annonce plus tard.
		if not firepowerValid and RelaxGeneration and isPlayerRelatedDraft(draftContext) then

			recordRelaxedLimit(unit.name, "firepower", {
				required = target.firepower.min,
				availableAircraft = AcftAvail[unit.name].available,
				loadoutFirepower = currentLoadout.firepower,
				maxPossible = AcftAvail[unit.name].available * currentLoadout.firepower,
				target = target.titleName,
				loadout = currentLoadout.name,
			})

			firepowerValid = true
		end

		if isDebugModeA3 then
			debugLog("draftId"..draftId.." AtoG passe A_11b passPackmax? "..tostring(draftContext.passPackmax).." ||target.firepower.packmax: "..tostring(target.firepower.packmax).." passHumain? "..tostring(passHumain).." firepowerValid? "..tostring(firepowerValid))
		end

		repeat

			if not passHumain then
				rejectStep( draftContext, "passHumain", "HumainRequired", nil)
				break
			end

			if not firepowerValid then
				rejectStep( draftContext, "firepower", "firepower_insufficient",
					{
						required = target.firepower.min,
						availableAircraft = AcftAvail[unit.name].available,
						loadoutFirepower = currentLoadout.firepower,
						maxPossible = AcftAvail[unit.name].available * currentLoadout.firepower,
						target = target.titleName,
						loadout = currentLoadout.name,
					},
					"BLOCK_A", 
					SafeGetLine()
				)
				
				break
			end

			if isDebugModeA3 then debugLog("draftId"..draftId.." AtoG passe A_13  Befor weather Condition  || "..target_name) end

			TrackPlayability(unit.player, "target_firepower")																			--track playabilty criterium has been met

			local weatherEligible = checkWeatherEligibility(draftContext, currentLoadout, isDebugModeA3)

			if not weatherEligible then
				rejectStep( draftContext, "weather", "weather_not_eligible",
					{
						target = target.titleName,
						loadout = currentLoadout.name,
						daytime = Daytime,

					},
					"BLOCK_A", 
					SafeGetLine()
				)
			end

			--selectionne une escadrille CSAR la plus proche de l'EjectedPilot
			local proxiCSAR = true
			if task == "CSAR" and target.selectedUnitSAR and target.selectedUnitSAR ~= "" then
				if unit.name ~= target.selectedUnitSAR then
					proxiCSAR = false
				end
			end

			if draftContext.overideMP_A or unit.player or unit.client then
				proxiCSAR = true
			end

			if isDebugModeA3 then
				debugLog("draftId"..draftId.." AtoG passe A_13__C ".." proxiCSAR "..tostring(proxiCSAR).." ".. tostring(unit.name).." selectedUnitSAR: "..tostring(target.selectedUnitSAR).." target.name: "..tostring(target.name))
				debugLog("draftId"..draftId.." AtoG passe A_13__D weatherEligible? "..tostring(weatherEligible).." overideMP_A? "..tostring(draftContext.overideMP_A))
			end

			if (weatherEligible and proxiCSAR) then																				--continue of this loadout is eligible for weather

				if isDebugModeA3 then
					debugLog("draftId"..draftId.." AtoG passe A_14 ".." After weatherEligible Condition "..target_name)
				end

				validateStep(draftContext, "weather")

				TrackPlayability(unit.player, "weather")															--track playabilty criterium has been met

				-- --get airbase position
				-- local airbasePoint = {																				--get the x-y coordinates of the airbase where the unit is located
				-- 	x = db_airbases[unit.base].x,
				-- 	y = db_airbases[unit.base].y,
				-- 	h = db_airbases[unit.base].elevation,
				-- 	BaseAirStart = db_airbases[unit.base].BaseAirStart,
				-- 	-- name = db_airbases[unit.base].base,
				-- 	name = unit.base,
				-- }

				local multipack = 1
				if target.firepower.packmax  then	--and unit_loadouts[l].MaxAttackOffset								--target has a requirement for multiple packages and loadout is multipack capable (defined maximum attack offset)
					multipack = target.firepower.packmax															--create draft sorties for this target for the requested amount of packages
				end

				if isDebugModeA3 then
					debugLog("draftId"..draftId.." AtoG passe A_15 multipack "..tostring(multipack).." FOR multipack Boucle "..target_name)
				end

				--determine route variants depending on Daytime
				-- local variant
				if Daytime == "day" then
					draftContext.state.variant = 1
				elseif Daytime == "night" then
					draftContext.state.variant = 2
				elseif Daytime == "night-day" then
					draftContext.state.variant = 3
				elseif Daytime == "day-night" then
					draftContext.state.variant = 4
				end

				if isDebugModeA3 then
					debugLog("draftId"..draftId.." AtoG passe A_16 "..tostring(draftContext.state.varian).." "..tostring(Daytime).." Befor variant Condition "..target_name)
				end

				draftContext.state.viaFARP = nil

				--create draft sortie for this target, loadout and route variant
				while draftContext.state.variant > 0 do
					if draftContext.state.variant ~= 1 then
						draftId = draftId + 1
					end
					if isDebugModeA3 then
						debugLog("draftId"..draftId.." AtoG passe A_18 ".." After variant Condition "..target_name)
					end

					local tempDebug = ""

					i_timmer01 = i_timmer01 +1
					if i_timmer01 >= 10  then io.write(".") i_timmer01 = 0 end
					--determine route
					status_counter_sorties = status_counter_sorties + 1													--status report

					draftContext.state.route = {}

					if task == "Intercept" then																			--intercept task only get a stub route
						draftContext.state.route = {
							[1] = {
								['y'] = airbasePoint.y,
								['x'] = airbasePoint.x,
								['alt'] = 0,
								['id'] = 'Intercept',
							},
							threats = {
								SEAD_offset = 0,
								ground_total = 0.5,
								air_total = 0.5
							},
							['lenght'] = target.radius * 2,																--interception task radius *2 because below it is compared with range *2
						}
					elseif task == "SAR" then																			--intercept task only get a stub route
						draftContext.state.route = {
							[1] = {
								['y'] = airbasePoint.y,
								['x'] = airbasePoint.x,
								['alt'] = 0,
								['id'] = 'SAR',
							},
							threats = {
								SEAD_offset = 0,
								ground_total = 0.5,
								air_total = 0.5
							},
							['lenght'] = target.radius * 2,																--interception task radius *2 because below it is compared with range *2
						}
					else																								--all other tasks than intercept
						local toTarget = 9999999
						if not airbasePoint.x then print("AtoG No Airbase position "..tostring(unit.base)) os.execute 'pause' end
						if not target.x then
							-- print("AtoG No target position "..tostring(target_name))
						else
							toTarget = GetDistance(airbasePoint, target)												--direct distance to target

							if IsHelicopter[unit.type] and toTarget > currentLoadout.range then
								for baseN, FARP in pairs(baseFARP[sideName]) do
									local toFARP = GetDistance(airbasePoint, FARP)

									if toFARP < (currentLoadout.range * 2) then

										local farpToTarget = GetDistance(FARP, target)

										if farpToTarget <= currentLoadout.range and farpToTarget < toTarget then
											toTarget = farpToTarget
											draftContext.state.viaFARP = FARP
										end
									end
								end
							end
						end

						--augmente le rayon d'action pour les helico client (ils peuvent se ravitailler sur des FARP occasionel)
						if draftContext.overideMP_A and IsHelicopter[unit.type] then
							currentLoadout.range = currentLoadout.range *2
						end

						if isDebugModeA3 then
							debugLog("draftId"..draftId.." AtoG passe A_25 "..tostring(toTarget).." || LoadoutUnitRange: "..tostring(currentLoadout.range).." "..tostring(currentLoadout.name)
							.."\n".."______________toTarget "..tostring(toTarget).." <=? "..tostring(currentLoadout.range)
							)
						end

						tempDebug = "\n"..("AtoG passe A_26                    AtoG toTarget "..tostring(toTarget).." <=?? currentLoadout.range: "..tostring(currentLoadout.range) )

						local rangeOK = toTarget <= currentLoadout.range

						--mode degrade : a partir de la 5e tentative infructueuse, on ignore le
						--depassement de portee pour le draft du joueur plutot que de ne rien
						--lui proposer (cf RelaxGeneration, ATO_Generator_A_Debug.lua).
						if not rangeOK and RelaxGeneration and isPlayerRelatedDraft(draftContext) then

							recordRelaxedLimit(unit.name, "range", {
								toTarget = math.floor(toTarget),
								range = math.floor(currentLoadout.range),
								target = target.titleName,
								loadout = currentLoadout.name,
							})

							rangeOK = true
						end

						if rangeOK then		--basic feasibility check of range before performance intensive route calculations are done

							validateStep(draftContext, "range")

							tempDebug = tempDebug.."\n"..("                    AtoG variant" )
							if draftContext.state.variant == 1 or draftContext.state.variant == 4 then
								tempDebug = tempDebug.."\n"..("AtoG passe  A_27a day")
															-- GetRoute(basePoint, target, profile,		sideName,	task, time,	multipackn,	multipackmax, unit,	viaFARP)
								draftContext.state.route = GetRoute(airbasePoint, target, currentLoadout, sideName, task, "day", math.random(1,multipack), multipack,    unit, draftContext.state.viaFARP)	or {}

							elseif draftContext.state.variant == 2 or draftContext.state.variant == 3 then
								tempDebug = tempDebug.."\n"..("AtoG passe  A_27b night")
								draftContext.state.route = GetRoute(airbasePoint, target, currentLoadout, sideName, task, "night", math.random(1,multipack), multipack,    unit, draftContext.state.viaFARP)	or {}
							end

							if draftContext.state.route then
								validateStep(draftContext.state.route, "route")
							else
								if not draftContext.state.route or not draftContext.state.route.lenght then
										rejectStep( draftContext, "route", "route_not_found",
											{
												target = target.titleName,
												loadout = currentLoadout.name,
												variant = draftContext.state.variant,
											},
											"BLOCK_A", 
											SafeGetLine()
										)
								end
							end

						else
							rejectStep( draftContext, "range", "range_too_short",
								{
									toTarget = math.floor(toTarget),
									range = math.floor(currentLoadout.range),
									target = target.titleName,
									loadout = currentLoadout.name,
									unit = unit.name,
								},
								"BLOCK_A", 
								SafeGetLine()
							)
						end

						DebugRoute = false
					end

					local altiPass = true
					if currentLoadout.hHover and target.z and target.z > currentLoadout.hHover then
						altiPass = false
					end

					if isDebugModeA3 then
						debugLog(tempDebug..draftId.."\n".."AtoG passe A_28d "
						.."\n".."______________route.lenght "..tostring(draftContext.state.route.lenght).." <=? "..tostring(currentLoadout.range * 2)
						.."\n".."______________altiPass? "..tostring(altiPass)
						.."\n".."______________altiPass? target.z "..tostring(target.z).." >? hHover "..tostring(currentLoadout.hHover))
					end

					--if sortie route lenght is within range of aircraft-loadout
					if draftContext.state.route and draftContext.state.route.lenght and draftContext.state.route.lenght <= currentLoadout.range * 2 and altiPass then
						if isDebugModeA3 then
							debugLog("draftId"..draftId.." AtoG passe A_29_A After Range Condition | firepower.max: "..tostring(target.firepower.max).." / currentLoadout.firepower "..tostring(currentLoadout.firepower))
						end

						TrackPlayability(unit.player, "target_range")												--track playabilty criterium has been met

						--firepower restante nécessaire pour ce target
						--Pourquoi: éviter l'overkill par accumulation de squads
						local assignedFirepower = targetAssignedFirepower[target_name] or 0

						local remainingFirepowerNeeded = target.firepower.max - assignedFirepower

						-- if remainingFirepowerNeeded <= 0 and not draftContext.overideMP_A then

						-- 	if isDebugModeA3 then
						-- 		debugLog(
						-- 			"draftId"..draftId .." A_29_B target already satisfied "
						-- 			..target_name .." assigned: "..assignedFirepower .." / "..target.firepower.max
						-- 		)
						-- 	end

						-- 	break
						-- end

						-- local firepowerRequest = GetWeightedRandom(target.firepower.min, target.firepower.max, bias)
						local firepowerRequest = GetWeightedRandom( target.firepower.min, remainingFirepowerNeeded, bias )
						draftContext.aircraft_requested = firepowerRequest / currentLoadout.firepower

						if task == "Transport" then
							if mp_Data and mp_Data.NbPlane
							and draftContext.aircraft_requested < mp_Data.NbPlane
							and task == "Transport"
							then
								draftContext.aircraft_requested = mp_Data.NbPlane
								if draftContext.aircraft_requested > 4 then draftContext.aircraft_requested = 4 end
							end
						elseif task == "Strike" and draftContext.aircraft_requested < 2 then
							draftContext.aircraft_requested = 2
						end

						local flights_requested
						if task == "AWACS" or task == "Refueling" or task == "AFAC" then									--multiple flights are required to continously cover a station for the duration of the mission
							if not currentLoadout.tStation then print("this variable <<tStation>> is missing  in this aircraft's "..task.." loadout "..unit.type) os.execute 'pause' end
							flights_requested = math.ceil((draftContext.state.tot_to - draftContext.state.tot_from) / currentLoadout.tStation) + 1			--how many flights are needed to keep continous coverage of station, plus 1 for on station before mission start
							draftContext.aircraft_requested = draftContext.aircraft_requested * flights_requested									--total number of requested aircraft is number of aircraft needed to statisfy firepower requirement of station * number of flights needed for continous coverage
						end
						if task == "CAP"  then									--multiple flights are required to continously cover a station for the duration of the mission
							if not currentLoadout.tStation then print("this variable <<tStation>> is missing in this aircraft's "..task.." loadout "..unit.type) os.execute 'pause' end

							local station = currentLoadout.tStation * 0.75
							flights_requested = math.ceil((draftContext.state.tot_to - draftContext.state.tot_from) / station)
							draftContext.aircraft_requested = draftContext.aircraft_requested * flights_requested									--total number of requested aircraft is number of aircraft needed to statisfy firepower requirement of station * number of flights needed for continous coverage

							if draftContext.aircraft_requested < 2  then
								draftContext.aircraft_requested = 2
							end

						end

						if task == "AWACS" or task == "Refueling" or task == "Transport" or task == "Nothing" or task == "Reconnaissance" or task == "AFAC" then
							draftContext.aircraft_requested = math.ceil(draftContext.aircraft_requested)
						-- elseif (unit.type == "S-3B" or unit.type == "F-117A" or unit.type == "B-1B" or unit.type == "B-52H" or unit.type == "Tu-22M3" or unit.type == "Tu-95MS" or unit.type == "Tu-142" or unit.type == "Tu-160" or unit.type == "MiG-25RBT")
						-- 	and task ~= "Runway Attack"	then
						-- 	aircraft_requested = math.ceil(aircraft_requested)	
						elseif (Data_divers[unit.type] and Data_divers[unit.type].flyingAlone) and task ~= "Runway Attack"	then

							draftContext.aircraft_requested = math.ceil(draftContext.aircraft_requested)
						else
							--aircraft_requested = math.ceil(aircraft_requested / 2) * 2								--round up to an even number
							draftContext.aircraft_requested = math.ceil(draftContext.aircraft_requested)
						end

						-- local aircraft_assign
						local logTmp = ""
						if draftContext.aircraft_requested > AcftAvail[unit.name].available then
							draftContext.state.futureAircraftAssign = math.floor(AcftAvail[unit.name].available)
							logTmp = logTmp .. " a "
						else
							draftContext.state.futureAircraftAssign = math.floor(draftContext.aircraft_requested)
							logTmp = logTmp .. " /b "
						end

						--garde en memoire remainingFirepower pour ajouter (ou non) un strike support
						draftContext.state.remainingFirepower = target.firepower.max - ( currentLoadout.firepower * draftContext.state.futureAircraftAssign)
						if draftContext.state.remainingFirepower < 0 then draftContext.state.remainingFirepower = 0 end

						-- local debugMulti = ""
						debugMulti = ""

						if draftContext.overideMP_A then

							debugMulti = debugMulti.."\n"..("AtoG_overideMP_A passe B "..tostring(task).." "..unit.type.." aircraft_assign:"..tostring(draftContext.state.futureAircraftAssign))

							--TODO a regarder si c'etait utile
							if draftContext.state.futureAircraftAssign > 4 and ( task == "CAP" ) then
								draftContext.state.futureAircraftAssign = 4
								logTmp = logTmp .. " /c "
							end

							--M11.z
							if mp_Data and mp_Data.NbPlane then
								if draftContext.state.futureAircraftAssign < mp_Data.NbPlane then
									draftContext.state.futureAircraftAssign = mp_Data.NbPlane
									logTmp = logTmp .. " /d "
									debugMulti = debugMulti.."\n"..("AtoG_overideMP_A passe C "..unit.type.." aircraft_assign: "..tostring(draftContext.state.futureAircraftAssign))
								end
							end

						end

						debugMulti = debugMulti.."\n"..("AtoG_overideMP_A passe D "..unit.type.." aircraft_assign: "..tostring(draftContext.state.futureAircraftAssign))

						if isDebugModeA3 then
							debugLog("draftId"..draftId.." "..debugMulti)
						end

						--self escort
						if currentLoadout.self_escort then															--if the loadout is capable of self-escort
							draftContext.state.route.threats.air_total = draftContext.state.route.threats.air_total / 2										--reduce the fighter threat by half
							if draftContext.state.route.threats.air_total < 0.5 then
								draftContext.state.route.threats.air_total = 0.5
							end
						end

						local assignedAircraft = draftContext.state.futureAircraftAssign

						buildDraftSorties(
							draftContext,
							sideName,
							task,
							target,
							currentLoadout,
							flights_requested,
							multipack,
							unit,
							mp_Data,
							draftId,
							isDebugModeA3
						)
						--mémorise la firepower déjà assignée à ce target
						--Pourquoi: empêcher les squads suivants de surcharger le target
						local generatedFirepower = currentLoadout.firepower * assignedAircraft

						--TODO ici, il ne faut mettre que les targets qui ont un packMax
						targetAssignedFirepower[target_name] = (targetAssignedFirepower[target_name] or 0) + generatedFirepower

						if isDebugModeA3 then
							debugLog(
								"draftId"..draftId .." AtoG passe A_30 = = = = = = = = = = = = >>>>>> buildDraftSorties()  "
								.." draftContext.state.futureAircraftAssign: "..draftContext.state.futureAircraftAssign
								.." logTmp : "..tostring(logTmp) 

						)
							
							
							debugLog(
								"draftId"..draftId .." AtoG passe A_30 = = = = = = = = = = = = >>>>>>  buildDraftSorties() PACKAGE COMPLETE "
								..target_name .." targetAssignedFirepower/target.firepower.max: "
								..targetAssignedFirepower[target_name] .."/" ..target.firepower.max
							)
						end

					end

					draftContext.state.variant = draftContext.state.variant - 2																			--determines if while-loop does another route variant depending on Daytime
				end

			end
		until true
	end
end

-- ============================================================================
-- WARGAME : ravitaillement aerien par helicoptere  (sous-etape 2a)
-- ============================================================================
--Pourquoi: les cibles "WG_AIRLIFT_..." ecrites par DCE_Manager (task Transport, wargameLogistic = "airlift")
--n'ont pas de base : le test natif "target.base == unit.base" les ignorait en silence.
--Ici on les traite a part : on calcule combien de rotations (N) un helico de l'escadrille peut faire
--(portee du loadout, aller-retour, marge de securite), on LOG la decision, et on rejette proprement
--si aucun N >= 1 n'est possible.
--
--SOUS-ETAPE 2a = CALCUL + LOG SEULEMENT : tant que WG_AIRLIFT_GENERATE = false, aucun vol n'est cree.
--(la creation du plan de vol complet arrive en 2b)
--
--REGLAGES (a ajuster ici, sans toucher au reste du fichier)
WG_AIRLIFT_GENERATE        = true		--false = calcul + log seulement ; true = creation des vols (2b, pas encore codee)
WG_AIRLIFT_MARGIN          = 0.25		--marge de securite sur le rayon d'action aller-retour (0.25 = on n'utilise que 75%)
WG_AIRLIFT_DETOUR          = 1.15		--coef de detour applique aux distances a vol d'oiseau (en attendant la vraie route en 2b)
WG_AIRLIFT_MAX_N           = 4			--nb maximum de rotations par vol
WG_AIRLIFT_STOP_S          = 300		--secondes perdues par rotation (chargement + depose)
WG_AIRLIFT_V_DEFAULT       = 50			--m/s, vitesse de croisiere si le loadout n'en donne pas
WG_AIRLIFT_PAYLOAD_DEFAULT = 1000		--kg, si l'helico n'est ni dans PayloadType ni donne par wargameCargoKg
WG_AIRLIFT_RESET_ATO       = false		--true = remet ATO=false sur les cibles qu'aucun helico ne peut servir ; false = ATO reste true (la note est ecrite quand meme)
WG_AIRLIFT_AUDIT           = true		--true = ecrit dans le log l'etat de chaque cible airlift et de chaque squad helico (diagnostic)
WG_AIRLIFT_NOTE            = "(no helicopter squad close enough)"
WG_AIRLIFT_NOTE_FLEET      = "(no helicopter available)"
WG_AIRLIFT_IGNORE_MINSCORE = true		--true = les vols airlift ignorent le minscore du loadout (un ravitaillement n'a pas a "meriter" un score de menace)
WG_AIRLIFT_IGNORE_SUPPORT  = true		--true = les vols airlift ne demandent pas d'escorte obligatoire (support du loadout vide)
WG_AIRLIFT_LOG             = true		--ecrit Debug/WG_Airlift.log (ecrase a chaque generation)
WG_AIRLIFT_RANDOM          = true		--true = tirage au sort entre escadrilles a egalite d'utilisation ; false = toujours la premiere dans l'ordre alphabetique (tests reproductibles)
WG_AIRLIFT_LOG_DIR         = "Debug/Wargame/ScriptsModPart"		--dossier des logs wargame de scriptsMod (cree automatiquement)
WG_AIRLIFT_LOG_FILE        = WG_AIRLIFT_LOG_DIR.."/WG_Airlift.log"

--etat de la generation en cours (remis a zero a chaque execution du fichier)
WG_AirliftBest   = {}		--par nom de cible : meilleur plan trouve
WG_AirliftSeen   = {}		--dedoublonnage du log (cible|escadrille|loadout)
WG_AirliftPick   = {}		--par nom de cible : escadrille + loadout choisis pour la generation (false = aucun)
WG_AirliftUsed   = {}		--par nom d'escadrille : nb de vols airlift deja attribues dans cette generation (pluralite)
WG_AirliftDone   = {}		--par nom de cible : true quand un vol a deja ete cree
WG_AirliftLogBuf = {}

function WG_Log(msg)
	if WG_AIRLIFT_LOG then
		WG_AirliftLogBuf[#WG_AirliftLogBuf + 1] = tostring(msg)
	end
end

--cree le dossier du log si besoin (Windows ; ne fait rien s'il existe deja)
function WG_EnsureLogDir()
	local dir = string.gsub(WG_AIRLIFT_LOG_DIR, "/", "\\")
	os.execute('if not exist "'..dir..'" mkdir "'..dir..'"')
end

--append = true : complete le fichier existant (bilan apres creation de l'ATO) au lieu de l'ecraser
function WG_FlushLog(append)
	if not WG_AIRLIFT_LOG then
		return
	end

	local mode = append and "a" or "w"

	local file = io.open(WG_AIRLIFT_LOG_FILE, mode)
	if not file and WG_EnsureLogDir then
		WG_EnsureLogDir()
		file = io.open(WG_AIRLIFT_LOG_FILE, mode)
	end

	if file then
		if not append then
			file:write("==== WG_Airlift 2b | MissionInstance: "..tostring(MissionInstance)
				.." | GeneratorPass: "..tostring(GeneratorPass)
				.." | CampTotalTimeH: "..tostring(CampTotalTimeH)
				.." | GENERATE: "..tostring(WG_AIRLIFT_GENERATE).." ====\n")
		end
		if #WG_AirliftLogBuf > 0 then
			file:write(table.concat(WG_AirliftLogBuf, "\n").."\n")
		end
		file:close()
	else
		print("WG_Airlift : impossible d'ouvrir "..tostring(WG_AIRLIFT_LOG_FILE))
	end

	WG_AirliftLogBuf = {}
end

--trace de la boucle Part A pour les helicos Transport (1 ligne par squad/etape, dedoublonne)
--ecrit dans le log WG_Airlift (lignes "TRACE_A")
function WG_AirliftTrace(unit, task, stage, txt)
	if not WG_AIRLIFT_LOG or not WG_AIRLIFT_AUDIT then return end
	if not unit or not IsHelicopter[unit.type] then return end
	local key = "TRACE|"..tostring(unit.name).."|"..tostring(task).."|"..tostring(stage)
	if WG_AirliftSeen[key] then return end
	WG_AirliftSeen[key] = true
	WG_Log("TRACE_A squad: "..tostring(unit.name).." | "..tostring(unit.type).." | etape: "..tostring(stage).." | "..tostring(txt))
end

--trace de la boucle Part A pour les helicos Transport (1 ligne par squad/etape, dedoublonne)
--ecrit dans Debug/WG_Airlift.log (lignes "TRACE_A")
function WG_AirliftTrace(unit, task, stage, txt)
	if not WG_AIRLIFT_LOG or not WG_AIRLIFT_AUDIT then return end
	if not unit or not IsHelicopter[unit.type] then return end
	local key = "TRACE|"..tostring(unit.name).."|"..tostring(task).."|"..tostring(stage)
	if WG_AirliftSeen[key] then return end
	WG_AirliftSeen[key] = true
	WG_Log("TRACE_A squad: "..tostring(unit.name).." | "..tostring(unit.type).." | etape: "..tostring(stage).." | "..tostring(txt))
end

--trace : que contient la copie tgtList_Gen (celle que lit la boucle Part A) comparee a la targetlist vivante ?
function WG_AirliftTraceTargets(copyList, sideName, unit)
	if not WG_AIRLIFT_LOG or not WG_AIRLIFT_AUDIT then return end
	if not unit or not IsHelicopter[unit.type] then return end
	local key = "TGTLIST|"..tostring(sideName)
	if WG_AirliftSeen[key] then return end
	WG_AirliftSeen[key] = true

	local function count(list)
		local n, nTransport, nAirlift, nAirliftATO = 0, 0, 0, 0
		local noms = ""
		for _, t in pairs(list or {}) do
			n = n + 1
			if t.task == "Transport" then nTransport = nTransport + 1 end
			if t.wargameLogistic == "airlift" then
				nAirlift = nAirlift + 1
				if t.ATO and not t.inactive then nAirliftATO = nAirliftATO + 1 end
				noms = noms.." ["..tostring(t.name).." titleName="..tostring(t.titleName).." ATO="..tostring(t.ATO).." inactive="..tostring(t.inactive).." task="..tostring(t.task).."]"
			end
		end
		return n, nTransport, nAirlift, nAirliftATO, noms
	end

	local n1, t1, a1, k1, noms1 = count(copyList and copyList[sideName])
	local n2, t2, a2, k2, noms2 = count(targetlist and targetlist[sideName])
	WG_Log("TRACE_A TGTLIST side: "..tostring(sideName)
		.." | tgtList_Gen (copie): cibles="..n1.." Transport="..t1.." airlift="..a1.." airlift_actifs_ATO="..k1..noms1
		.." | targetlist (vivante): cibles="..n2.." Transport="..t2.." airlift="..a2.." airlift_actifs_ATO="..k2)
end

--plafond de rotations donne par le Manager (limite de flotte), s'il existe
--ordre de lecture : target.air.heli.sorties (bloc air), puis target.wargameSorties
function WG_AirliftGetCap(target)

	local cap = nil

	if type(target.air) == "table" and type(target.air.heli) == "table" then
		cap = tonumber(target.air.heli.sorties)
		if cap then
			return cap, "air.heli.sorties"
		end
	end

	cap = tonumber(target.wargameSorties)
	if cap then
		return cap, "wargameSorties"
	end

	return nil, "aucun"
end

--Calcule le plan de rotations d'un helico pour une cible airlift.
--Trajet pour N rotations : base -> chargement (Dbe), puis N x (chargement -> depose) et (N-1) x (depose -> chargement)
--soit (2N-1) x Ded, puis depose -> base (Dpb).  Distance totale = Dbe + (2N-1) x Ded + Dpb.
--Budget = portee x 2 x (1 - marge).   =>   N <= ( (budget - Dbe - Dpb) / Ded + 1 ) / 2
--Retourne une table : feasible (portee ok pour au moins 1 rotation), N, limitedBy, distances, charge, etc.
function WG_AirliftComputePlan(target, unit, currentLoadout, airbasePoint)

	local plan = { N = 0, nRange = 0, feasible = false, limitedBy = "none" }

	if not target.wargameLoadX or not target.wargameLoadY or not target.x or not target.y then
		plan.reason = "point de chargement ou de depose manquant"
		return plan
	end

	local range = tonumber(currentLoadout.range) or 0
	if range <= 0 then
		plan.reason = "pas de range dans le loadout"
		return plan
	end

	local loadPoint = { x = target.wargameLoadX, y = target.wargameLoadY }
	local dropPoint = { x = target.x, y = target.y }
	local k = WG_AIRLIFT_DETOUR

	local Dbe = GetDistance(airbasePoint, loadPoint) * k		--base -> chargement
	local Ded = GetDistance(loadPoint, dropPoint) * k			--chargement -> depose
	local Dpb = GetDistance(dropPoint, airbasePoint) * k		--depose -> base

	plan.Dbe = Dbe
	plan.Ded = Ded
	plan.Dpb = Dpb
	plan.dist1 = Dbe + Ded + Dpb								--distance totale pour 1 seule rotation
	plan.range = range

	--charge utile d'UN helico : PayloadType en priorite, puis wargameCargoKg (indicatif), puis valeur par defaut
	local payload = PayloadType and PayloadType[unit.type]
	plan.payloadSource = "PayloadType"
	if not payload or payload <= 0 then
		payload = tonumber(target.wargameCargoKg)
		plan.payloadSource = "wargameCargoKg"
	end
	if not payload or payload <= 0 then
		payload = WG_AIRLIFT_PAYLOAD_DEFAULT
		plan.payloadSource = "defaut"
	end
	plan.payload = payload

	--1) limite de portee
	local budget = range * 2 * (1 - WG_AIRLIFT_MARGIN)
	local avail = budget - Dbe - Dpb
	local DedSafe = math.max(Ded, 500)							--evite une division par ~0 quand chargement et depose sont tres proches

	local nRange = 0
	if avail > 0 then
		nRange = math.floor((avail / DedSafe + 1) / 2)
	end
	plan.budget = budget
	plan.nRange = nRange

	plan.feasible = (nRange >= 1)

	--3) limites de besoin et de flotte : ne concernent que l'IA (le joueur peut en faire plus)
	local N = nRange
	local limitedBy = "range"

	local human = unit.player or unit.client
	plan.human = human and true or false

	local need = tonumber(target.wargameNeedKg)
	plan.need = need

	local cap, capSource = WG_AirliftGetCap(target)
	plan.cap = cap
	plan.capSource = capSource

	if not human then
		if need ~= nil then
			local nNeed = math.ceil(need / payload)
			plan.nNeed = nNeed
			if nNeed < N then
				N = nNeed
				limitedBy = "need"
			end
		end

		if cap ~= nil and cap < N then
			N = cap
			limitedBy = "cap"
		end
	end

	if N > WG_AIRLIFT_MAX_N then
		N = WG_AIRLIFT_MAX_N
		limitedBy = "max"
	end

	if N < 0 then N = 0 end

	plan.N = N
	plan.limitedBy = limitedBy
	plan.totalDist = (N >= 1) and (Dbe + (2 * N - 1) * Ded + Dpb) or plan.dist1
	plan.kgPlanned = N * payload

	return plan
end

--Choisit, pour une cible airlift, une escadrille helico + un loadout, avec PLURALITE entre les escadrilles :
--on prefere les escadrilles les moins utilisees dans cette generation (cible 1 : une escadrille, cible 2 : une autre,
--puis tirage au sort quand elles ont toutes servi autant). Ni la charge ni la distance ne donnent l'exclusivite a un type.
--Compte l'utilisation dans WG_AirliftUsed (a appeler UNE fois par cible, le resultat est memorise par l'appelant).
--Retourne { unit = nom du squad, loadout = nom du loadout, plan = plan } ou nil
function WG_AirliftPickBest(sideName, target)

	local cands = {}

	for _, unit in pairs(oob_air[sideName] or {}) do

		local isHeli = IsHelicopter and IsHelicopter[unit.type]
		local base = db_airbases[unit.base]
		local av = AcftAvail and AcftAvail[unit.name]
		local list = LoadoutsList and LoadoutsList[unit.type] and LoadoutsList[unit.type]["Transport"]
		local used = WG_AirliftUsed[unit.name] or 0

		if isHeli and not unit.inactive and not unit.player and not unit.client
			and base and base.x and base.y and base.inactive ~= true
			and unit.tasks and unit.tasks["Transport"] and list
			and not (av and (av.available or 0) - used <= 0) then

			for lname, l in pairs(list) do
				if type(l) == "table" and WG_CountryOk(l, unit.country) and WG_AttrOk(target, l) then

					local plan = WG_AirliftComputePlan(target, unit, l, { x = base.x, y = base.y })

					if plan.N >= 1 then
						table.insert(cands, { unit = unit.name, loadout = lname, loadoutName = l.loadoutName, loadoutName2 = l.name, plan = plan, used = used })
					end
				end
			end
		end
	end

	if #cands == 0 then return nil end

	--ordre stable (pour que WG_AIRLIFT_RANDOM = false donne toujours le meme resultat)
	table.sort(cands, function(a, b)
		if a.unit ~= b.unit then return a.unit < b.unit end
		return tostring(a.loadout) < tostring(b.loadout)
	end)

	--on ne garde que les escadrilles les moins utilisees
	local minUsed = cands[1].used
	for _, c in ipairs(cands) do
		if c.used < minUsed then minUsed = c.used end
	end
	local pool = {}
	for _, c in ipairs(cands) do
		if c.used == minUsed then table.insert(pool, c) end
	end

	local chosen = pool[1]
	if WG_AIRLIFT_RANDOM and #pool > 1 then
		chosen = pool[math.random(1, #pool)]
	end

	--log : tous les candidats, pour voir pourquoi celui-ci
	local txt = {}
	for _, c in ipairs(cands) do
		table.insert(txt, c.unit.."/"..tostring(c.loadout).." (deja utilisee: "..c.used.." | N="..c.plan.N.." | kg="..math.floor(c.plan.kgPlanned).." | dist="..math.floor(c.plan.totalDist)..")")
	end
	WG_Log("AIRLIFT_CANDIDATS target: "..tostring(target.name).." | "..table.concat(txt, " ; ").." | pool="..#pool.." random="..tostring(WG_AIRLIFT_RANDOM))

	WG_AirliftUsed[chosen.unit] = (WG_AirliftUsed[chosen.unit] or 0) + 1

	return chosen
end

--Remplace la fin de la route creee par le generateur (Assemble / Join / Split / Land sur la cible) par
--base -> chargement -> depose (x N) -> retour base.  On garde le debut (Taxi / Spawn / Departure).
--Retourne true si la route a ete reecrite.
function WG_AirliftRewriteRoute(entry, tgt, plan, airbasePoint)

	local route = entry.route

	if type(route) ~= "table" or #route < 2 then
		WG_Log("AIRLIFT_GEN ERREUR route du draft absente ou trop courte pour "..tostring(tgt.name))
		return false
	end

	local idsAvant = {}
	for i = 1, #route do idsAvant[#idsAvant + 1] = tostring(route[i].id) end

	--debut de route : jusqu'a Departure compris (sinon, juste le 1er point)
	local new = {}
	local iDep = nil
	for i = 1, #route do
		if route[i].id == "Departure" then iDep = i break end
	end
	if not iDep then iDep = 1 end
	for i = 1, iDep do
		new[#new + 1] = route[i]
	end

	--altitude de croisiere : celle du point qui suit Departure dans la route d'origine
	local cruise = 150
	if route[iDep + 1] and tonumber(route[iDep + 1].alt) then
		cruise = route[iDep + 1].alt
	end

	for k = 1, plan.N do
		new[#new + 1] = { x = tgt.wargameLoadX, y = tgt.wargameLoadY, id = "Load", alt = cruise }
		new[#new + 1] = { x = tgt.x, y = tgt.y, id = "Drop", alt = cruise }
	end
	new[#new + 1] = { x = airbasePoint.x, y = airbasePoint.y, id = "Land", alt = airbasePoint.h or 0 }

	--garde les champs non numeriques de la route (lenght...), puis recalcule la longueur
	for k, v in pairs(route) do
		if type(k) ~= "number" then new[k] = v end
	end

	local lenght = 0
	for i = 1, #new - 1 do
		lenght = lenght + GetDistance(new[i], new[i + 1])
	end
	new.lenght = lenght

	entry.route = new

	local idsApres = {}
	for i = 1, #new do idsApres[#idsApres + 1] = tostring(new[i].id) end

	WG_Log("AIRLIFT_ROUTE target: "..tostring(tgt.name).." avant: ["..table.concat(idsAvant, ",").."] apres: ["
		..table.concat(idsApres, ",").."] longueur="..math.floor(lenght).."m")

	return true
end

--Point d'entree appele a la place de processEligibleLoadout pour les cibles airlift du wargame.
--Helicopteres uniquement pour l'instant (les avions de transport viendront plus tard).
function WG_AirliftProcess(draftContext, sideName, task, target, target_name, unit, currentLoadout, airbasePoint, draftId, isDebugModeA3, nativeProcess, draftSortiesRef, Daytime, i_timmer01)

	if not IsHelicopter[unit.type] then
		return
	end

	local plan = WG_AirliftComputePlan(target, unit, currentLoadout, airbasePoint)

	--meilleur plan par cible (sert a decider si la cible reste ou non dans l'ATO)
	local best = WG_AirliftBest[target.name]
	if not best then
		best = { evaluated = 0, bestN = 0, feasibleAny = false }
		WG_AirliftBest[target.name] = best
	end
	best.evaluated = best.evaluated + 1
	if plan.feasible then best.feasibleAny = true end
	if plan.N > best.bestN then
		best.bestN = plan.N
		best.bestSquad = unit.name
		best.bestLoadout = currentLoadout.loadoutName or currentLoadout.name
	end

	--log (une ligne par cible / escadrille / loadout)
	local seenKey = tostring(target.name).."|"..tostring(unit.name).."|"..tostring(currentLoadout.loadoutName or currentLoadout.name)
	if not WG_AirliftSeen[seenKey] then
		WG_AirliftSeen[seenKey] = true

		local function m(v) return v and math.floor(v) or "nil" end

		WG_Log("AIRLIFT_PLAN target: "..tostring(target.name)
			.." squad: "..tostring(unit.name).." ("..tostring(unit.type)..(plan.human and ", joueur" or "")..")"
			.." base: "..tostring(unit.base)
			.." loadout: "..tostring(currentLoadout.loadoutName or currentLoadout.name)
			.." | N="..tostring(plan.N).." (limite: "..tostring(plan.limitedBy)
			..", portee="..tostring(plan.nRange)..")"
			.." | Dbe="..m(plan.Dbe).." Ded="..m(plan.Ded).." Dpb="..m(plan.Dpb)
			.." total="..m(plan.totalDist).." budget="..m(plan.budget).." range="..m(plan.range)
			.." | charge="..m(plan.payload).."kg ("..tostring(plan.payloadSource)..")"
			.." besoin="..tostring(plan.need).."kg cap="..tostring(plan.cap).." ("..tostring(plan.capSource)..")"
			..(plan.reason and (" | "..plan.reason) or ""))
	end

	if not plan.feasible then
		rejectStep( draftContext, "range", "range_too_short",
			{
				toTarget = math.floor(plan.dist1 or 0),
				range = math.floor(currentLoadout.range or 0),
				target = target.titleName,
				loadout = currentLoadout.name,
				unit = unit.name,
			},
			"BLOCK_A",
			SafeGetLine()
		)
		return
	end

	validateStep(draftContext, "range")

	if plan.N < 1 then
		--faisable mais rien a livrer (stock suffisant) ou flotte a 0 : pas d'erreur, juste pas de vol IA
		return
	end

	if not WG_AIRLIFT_GENERATE then
		return
	end

	--2b : creation du vol, une seule fois par cible, par l'escadrille choisie
	local loadoutName = currentLoadout.loadoutName or currentLoadout.name

	if WG_AirliftPick[target.name] == nil then
		WG_AirliftPick[target.name] = WG_AirliftPickBest(sideName, target) or false
		local p = WG_AirliftPick[target.name]
		if p then
			WG_Log("AIRLIFT_CHOIX target: "..tostring(target.name).." -> squad: "..p.unit.." loadout: "..tostring(p.loadout)
				.." N="..p.plan.N.." kg prevus: "..math.floor(p.plan.kgPlanned))
		else
			WG_Log("AIRLIFT_CHOIX target: "..tostring(target.name).." -> aucune escadrille (N>=1) disponible")
		end
	end

	local pick = WG_AirliftPick[target.name]

	local sameLoadout = false
	if pick then
		for _, k in ipairs({ currentLoadout.loadoutName, currentLoadout.name }) do
			if k ~= nil and (k == pick.loadout or k == pick.loadoutName or k == pick.loadoutName2) then sameLoadout = true end
		end
	end

	if not pick or pick.unit ~= unit.name or not sameLoadout then
		return
	end

	if WG_AirliftDone[target.name] then
		return
	end

	if type(nativeProcess) ~= "function" or type(draftSortiesRef) ~= "table" then
		WG_Log("AIRLIFT_GEN ERREUR target: "..tostring(target.name).." fonction native ou draftSortiesRef non transmis par le point d'appel")
		return
	end

	--copie de la cible pour le generateur : il croit a un transport "normal" (cible rattachee a la base du squad)
	--la vraie cible (targetlist) n'est pas touchee
	local tgt = DeepCopy(target)
	tgt.base = unit.base
	tgt.destination = unit.base
	tgt.wargameN = plan.N
	tgt.wargameKgPlanned = plan.kgPlanned
	tgt.wargameSquad = unit.name

	local nBefore = #(draftSortiesRef[sideName] or {})

	nativeProcess( draftContext, sideName, task, tgt, target_name,
		unit, currentLoadout, Daytime, airbasePoint, draftId, isDebugModeA3, i_timmer01 )

	local list = draftSortiesRef[sideName] or {}

	if #list <= nBefore then
		WG_Log("AIRLIFT_GEN ECHEC target: "..tostring(target.name).." squad: "..unit.name.." : le generateur n'a cree aucun draft (voir les rejets natifs)")
		return
	end

	for i = nBefore + 1, #list do
		WG_AirliftRewriteRoute(list[i], tgt, plan, airbasePoint)

		--un ravitaillement ne doit pas etre refuse pour un score de menace trop bas ni pour une escorte absente
		--(sinon createATO_table l'ecarte en silence : "MENACE TROP IMPORTANTE" / "any_SUPPORT")
		local lo = list[i].loadout
		if lo then
			local supTxt = ""
			if type(lo.support) == "table" then
				for k, v in pairs(lo.support) do
					if v then supTxt = supTxt..tostring(k).." " end
				end
			end

			WG_Log("AIRLIFT_LOADOUT draft: "..tostring(list[i].id).." minscore="..tostring(lo.minscore)
				.." support=["..supTxt.."] score="..tostring(list[i].score))

			if WG_AIRLIFT_IGNORE_MINSCORE then
				lo.minscore = nil
			end
			if WG_AIRLIFT_IGNORE_SUPPORT then
				lo.support = { Escort = false, SEAD = false }
			end
		end
	end

	WG_AirliftDone[target.name] = true
	WG_Log("AIRLIFT_GEN OK target: "..tostring(target.name).." squad: "..unit.name.." loadout: "..tostring(loadoutName)
		.." drafts crees: "..(#list - nBefore).." N="..plan.N)
end

--liste les cles a true d'une table (taches du squad...)
function WG_TrueKeys(tbl)
	local list = {}
	if type(tbl) == "table" then
		for k, v in pairs(tbl) do
			if v then list[#list + 1] = tostring(k) end
		end
		table.sort(list)
	end
	return table.concat(list, ",")
end

--liste les valeurs d'un tableau d'attributs
function WG_AttrList(tbl)
	local list = {}
	if type(tbl) == "table" then
		for _, v in pairs(tbl) do list[#list + 1] = tostring(v) end
	end
	return table.concat(list, ",")
end

--le loadout est-il autorise pour ce pays ? (meme regle que la generation)
function WG_CountryOk(ltable, country)
	if ltable.country == nil then return true end
	local c = string.lower(tostring(country or ""))
	if type(ltable.country) == "string" then
		return string.lower(ltable.country) == c or string.lower(ltable.country) == "all"
	elseif type(ltable.country) == "table" then
		for _, label in pairs(ltable.country) do
			if string.lower(tostring(label)) == c or string.lower(tostring(label)) == "all" then return true end
		end
	end
	return false
end

--tous les attributs de la cible sont-ils dans le loadout ? (meme regle que checkAttributeEligibility)
function WG_AttrOk(target, ltable)
	if target.attributes and target.attributes[1] and target.attributes[1] ~= "" then
		for _, ta in ipairs(target.attributes) do
			local found = false
			for _, la in ipairs(ltable.attributes or {}) do
				if la == ta then found = true break end
			end
			if not found then return false end
		end
	end
	return true
end

--DIAGNOSTIC : pour chaque cible airlift puis chaque squad helico, ecrit dans le log l'etat complet et
--la PREMIERE porte qui bloque le squad (dans l'ordre de la generation). Aucun effet sur la generation.
function WG_AirliftAudit()

	WG_Log("---- AIRLIFT_AUDIT cibles ----")

	local airlifts = {}

	for sideName, targets in pairs(targetlist) do
		for _, t in pairs(targets) do
			if type(t) == "table" and t.wargameLogistic == "airlift" then
				airlifts[#airlifts + 1] = { side = sideName, t = t }
				WG_Log("AIRLIFT_AUDIT_TARGET side: "..sideName.." name: "..tostring(t.name).." titleName: "..tostring(t.titleName)
					.." task: "..tostring(t.task).." ATO: "..tostring(t.ATO).." inactive: "..tostring(t.inactive)
					.." x,y: "..tostring(t.x)..","..tostring(t.y)
					.." load: "..tostring(t.wargameLoadX)..","..tostring(t.wargameLoadY)
					.." need: "..tostring(t.wargameNeedKg).." cargo: "..tostring(t.wargameCargoKg).." sorties: "..tostring(t.wargameSorties)
					.." destination: "..tostring(t.destination).." base: "..tostring(t.base)
					.." attributes: ["..WG_AttrList(t.attributes).."] attributesCond: "..tostring(t.attributesCond ~= nil)
					.." firepower: "..tostring(t.firepower and t.firepower.min)..".."..tostring(t.firepower and t.firepower.max)
					.." priority: "..tostring(t.priority))
			end
		end
	end

	WG_Log("---- AIRLIFT_AUDIT squads helico (oob_air) ----")

	local nHeli = 0

	for sideName, units in pairs(oob_air or {}) do
		for _, unit in pairs(units) do

			local isHeli = (IsHelicopter and IsHelicopter[unit.type]) or unit.helicopter

			if isHeli then
				nHeli = nHeli + 1

				local base = db_airbases[unit.base]
				local av = AcftAvail and AcftAvail[unit.name]
				local transportList = LoadoutsList and LoadoutsList[unit.type] and LoadoutsList[unit.type]["Transport"]

				local verdict = nil
				local nLoad, nLoadCountry = 0, 0

				if unit.inactive then
					verdict = "BLOQUE: squad inactif"
				elseif not base then
					verdict = "BLOQUE: base '"..tostring(unit.base).."' introuvable dans db_airbases"
				elseif base.inactive == true then
					verdict = "BLOQUE: base '"..tostring(unit.base).."' inactive"
				elseif not base.x or not base.y then
					verdict = "BLOQUE: base '"..tostring(unit.base).."' sans coordonnees"
				elseif not (unit.roster and (unit.roster.ready or 0) > 0) then
					verdict = "BLOQUE: roster.ready = 0 (aucun appareil)"
				elseif av and (av.available or 0) <= 0 then
					verdict = "BLOQUE: aucun appareil disponible (available: "..tostring(av.available)..")"
				elseif not (unit.tasks and unit.tasks["Transport"]) then
					verdict = "BLOQUE: tache Transport non activee sur ce squad (taches: "..WG_TrueKeys(unit.tasks)..")"
				elseif not (LoadoutsList and LoadoutsList[unit.type]) then
					verdict = "BLOQUE: type '"..tostring(unit.type).."' absent de LoadoutsList"
				elseif not transportList then
					verdict = "BLOQUE: aucun loadout Transport pour le type '"..tostring(unit.type).."'"
				end

				local loadTxt = ""
				if transportList then
					for lname, l in pairs(transportList) do
						if type(l) == "table" then
							nLoad = nLoad + 1
							local cOk = WG_CountryOk(l, unit.country)
							if cOk then nLoadCountry = nLoadCountry + 1 end
							loadTxt = loadTxt.."\n      loadout '"..tostring(lname).."' range: "..tostring(l.range).." vCruise: "..tostring(l.vCruise)
								.." day: "..tostring(l.day).." night: "..tostring(l.night)
								.." pays_ok: "..tostring(cOk).." (pays squad: "..tostring(unit.country)..") attributs: ["..WG_AttrList(l.attributes).."]"
						end
					end
				end

				if not verdict and nLoadCountry == 0 then
					verdict = "BLOQUE: "..nLoad.." loadout(s) Transport mais AUCUN autorise pour le pays '"..tostring(unit.country).."'"
				end

				--portes cible par cible : attributs puis distance brute
				local targetTxt = ""
				for _, a in ipairs(airlifts) do
					if a.side == sideName and transportList then
						local nAttrOk = 0
						for _, l in pairs(transportList) do
							if type(l) == "table" and WG_CountryOk(l, unit.country) and WG_AttrOk(a.t, l) then nAttrOk = nAttrOk + 1 end
						end
						local dist = -1
						if base and base.x and a.t.x then
							dist = math.floor(GetDistance({x = base.x, y = base.y}, {x = a.t.x, y = a.t.y}))
						end
						targetTxt = targetTxt.."\n      vs "..tostring(a.t.name)..": loadouts_attributs_ok: "..nAttrOk.."/"..nLoadCountry
							.." distance_base_livraison: "..dist.." m"
						if not verdict and nAttrOk == 0 then
							verdict = "BLOQUE: attributs de la cible ["..WG_AttrList(a.t.attributes).."] absents de tous les loadouts Transport (cible "..tostring(a.t.name)..")"
						end
					end
				end

				if not verdict then
					verdict = "PASSE toutes les portes de base : devrait etre evalue (si AUCUNE escadrille evaluee dans AIRLIFT_RESULT, voir SquadGenerationStatus ci-dessous)"
				end

				local sgs = SquadGenerationStatus and SquadGenerationStatus[unit.name]
				local sgsTxt = ""
				if sgs then
					sgsTxt = " | SquadGenerationStatus mainGenerated: "..tostring(sgs.mainGenerated)
					if sgs.bestReject then
						sgsTxt = sgsTxt.." dominantReason: "..tostring(sgs.bestReject.dominantReason)
						if sgs.bestReject.finalReject then
							sgsTxt = sgsTxt.." finalReject: etape '"..tostring(sgs.bestReject.finalReject.step).."' raison '"..tostring(sgs.bestReject.finalReject.reason).."'"
						end
					end
				end

				WG_Log("AIRLIFT_AUDIT_SQUAD side: "..sideName.." name: "..tostring(unit.name).." type: "..tostring(unit.type)
					.." base: "..tostring(unit.base).." inactive: "..tostring(unit.inactive)
					.." ready: "..tostring(unit.roster and unit.roster.ready)
					.." available: "..tostring(av and av.available).." unassigned: "..tostring(av and av.unassigned)
					.." taches: ["..WG_TrueKeys(unit.tasks).."] loadouts_Transport: "..nLoad.." (pays ok: "..nLoadCountry..")"
					..sgsTxt
					.."\n    VERDICT: "..verdict
					..loadTxt..targetTxt)
			end
		end
	end

	if nHeli == 0 then
		WG_Log("AIRLIFT_AUDIT_SQUAD AUCUN squad helicoptere dans oob_air (IsHelicopter/unit.helicopter) : rien ne peut servir l'airlift")
	end

	--squads non-helico ayant la tache Transport (info : ils sont ignores par l'airlift wargame)
	for sideName, units in pairs(oob_air or {}) do
		for _, unit in pairs(units) do
			local isHeli = (IsHelicopter and IsHelicopter[unit.type]) or unit.helicopter
			if not isHeli and unit.tasks and unit.tasks["Transport"] and not unit.inactive then
				WG_Log("AIRLIFT_AUDIT_NONHELI side: "..sideName.." name: "..tostring(unit.name).." type: "..tostring(unit.type).." (tache Transport, ignore par l'airlift wargame)")
			end
		end
	end
end

--liste les cles a true d'une table (taches du squad...)
function WG_TrueKeys(tbl)
	local list = {}
	if type(tbl) == "table" then
		for k, v in pairs(tbl) do
			if v then list[#list + 1] = tostring(k) end
		end
		table.sort(list)
	end
	return table.concat(list, ",")
end

--liste les valeurs d'un tableau d'attributs
function WG_AttrList(tbl)
	local list = {}
	if type(tbl) == "table" then
		for _, v in pairs(tbl) do list[#list + 1] = tostring(v) end
	end
	return table.concat(list, ",")
end

--le loadout est-il autorise pour ce pays ? (meme regle que la generation)
function WG_CountryOk(ltable, country)
	if ltable.country == nil then return true end
	local c = string.lower(tostring(country or ""))
	if type(ltable.country) == "string" then
		return string.lower(ltable.country) == c or string.lower(ltable.country) == "all"
	elseif type(ltable.country) == "table" then
		for _, label in pairs(ltable.country) do
			if string.lower(tostring(label)) == c or string.lower(tostring(label)) == "all" then return true end
		end
	end
	return false
end

--tous les attributs de la cible sont-ils dans le loadout ? (meme regle que checkAttributeEligibility)
function WG_AttrOk(target, ltable)
	if target.attributes and target.attributes[1] and target.attributes[1] ~= "" then
		for _, ta in ipairs(target.attributes) do
			local found = false
			for _, la in ipairs(ltable.attributes or {}) do
				if la == ta then found = true break end
			end
			if not found then return false end
		end
	end
	return true
end

--DIAGNOSTIC : pour chaque cible airlift puis chaque squad helico, ecrit dans le log l'etat complet et
--la PREMIERE porte qui bloque le squad (dans l'ordre de la generation). Aucun effet sur la generation.
function WG_AirliftAudit()

	WG_Log("---- AIRLIFT_AUDIT cibles ----")

	local airlifts = {}

	for sideName, targets in pairs(targetlist) do
		for _, t in pairs(targets) do
			if type(t) == "table" and t.wargameLogistic == "airlift" then
				airlifts[#airlifts + 1] = { side = sideName, t = t }
				WG_Log("AIRLIFT_AUDIT_TARGET side: "..sideName.." name: "..tostring(t.name).." titleName: "..tostring(t.titleName)
					.." task: "..tostring(t.task).." ATO: "..tostring(t.ATO).." inactive: "..tostring(t.inactive)
					.." x,y: "..tostring(t.x)..","..tostring(t.y)
					.." load: "..tostring(t.wargameLoadX)..","..tostring(t.wargameLoadY)
					.." need: "..tostring(t.wargameNeedKg).." cargo: "..tostring(t.wargameCargoKg).." sorties: "..tostring(t.wargameSorties)
					.." destination: "..tostring(t.destination).." base: "..tostring(t.base)
					.." attributes: ["..WG_AttrList(t.attributes).."] attributesCond: "..tostring(t.attributesCond ~= nil)
					.." firepower: "..tostring(t.firepower and t.firepower.min)..".."..tostring(t.firepower and t.firepower.max)
					.." priority: "..tostring(t.priority))
			end
		end
	end

	WG_Log("---- AIRLIFT_AUDIT squads helico (oob_air) ----")

	local nHeli = 0

	for sideName, units in pairs(oob_air or {}) do
		for _, unit in pairs(units) do

			local isHeli = (IsHelicopter and IsHelicopter[unit.type]) or unit.helicopter

			if isHeli then
				nHeli = nHeli + 1

				local base = db_airbases[unit.base]
				local av = AcftAvail and AcftAvail[unit.name]
				local transportList = LoadoutsList and LoadoutsList[unit.type] and LoadoutsList[unit.type]["Transport"]

				local verdict = nil
				local nLoad, nLoadCountry = 0, 0

				if unit.inactive then
					verdict = "BLOQUE: squad inactif"
				elseif not base then
					verdict = "BLOQUE: base '"..tostring(unit.base).."' introuvable dans db_airbases"
				elseif base.inactive == true then
					verdict = "BLOQUE: base '"..tostring(unit.base).."' inactive"
				elseif not base.x or not base.y then
					verdict = "BLOQUE: base '"..tostring(unit.base).."' sans coordonnees"
				elseif not (unit.roster and (unit.roster.ready or 0) > 0) then
					verdict = "BLOQUE: roster.ready = 0 (aucun appareil)"
				elseif av and (av.available or 0) <= 0 then
					verdict = "BLOQUE: aucun appareil disponible (available: "..tostring(av.available)..")"
				elseif not (unit.tasks and unit.tasks["Transport"]) then
					verdict = "BLOQUE: tache Transport non activee sur ce squad (taches: "..WG_TrueKeys(unit.tasks)..")"
				elseif not (LoadoutsList and LoadoutsList[unit.type]) then
					verdict = "BLOQUE: type '"..tostring(unit.type).."' absent de LoadoutsList"
				elseif not transportList then
					verdict = "BLOQUE: aucun loadout Transport pour le type '"..tostring(unit.type).."'"
				end

				local loadTxt = ""
				if transportList then
					for lname, l in pairs(transportList) do
						if type(l) == "table" then
							nLoad = nLoad + 1
							local cOk = WG_CountryOk(l, unit.country)
							if cOk then nLoadCountry = nLoadCountry + 1 end
							loadTxt = loadTxt.."\n      loadout '"..tostring(lname).."' range: "..tostring(l.range).." vCruise: "..tostring(l.vCruise)
								.." day: "..tostring(l.day).." night: "..tostring(l.night)
								.." pays_ok: "..tostring(cOk).." (pays squad: "..tostring(unit.country)..") attributs: ["..WG_AttrList(l.attributes).."]"
						end
					end
				end

				if not verdict and nLoadCountry == 0 then
					verdict = "BLOQUE: "..nLoad.." loadout(s) Transport mais AUCUN autorise pour le pays '"..tostring(unit.country).."'"
				end

				--portes cible par cible : attributs puis distance brute
				local targetTxt = ""
				for _, a in ipairs(airlifts) do
					if a.side == sideName and transportList then
						local nAttrOk = 0
						for _, l in pairs(transportList) do
							if type(l) == "table" and WG_CountryOk(l, unit.country) and WG_AttrOk(a.t, l) then nAttrOk = nAttrOk + 1 end
						end
						local dist = -1
						if base and base.x and a.t.x then
							dist = math.floor(GetDistance({x = base.x, y = base.y}, {x = a.t.x, y = a.t.y}))
						end
						targetTxt = targetTxt.."\n      vs "..tostring(a.t.name)..": loadouts_attributs_ok: "..nAttrOk.."/"..nLoadCountry
							.." distance_base_livraison: "..dist.." m"
						if not verdict and nAttrOk == 0 then
							verdict = "BLOQUE: attributs de la cible ["..WG_AttrList(a.t.attributes).."] absents de tous les loadouts Transport (cible "..tostring(a.t.name)..")"
						end
					end
				end

				if not verdict then
					verdict = "PASSE toutes les portes de base : devrait etre evalue (si AUCUNE escadrille evaluee dans AIRLIFT_RESULT, voir SquadGenerationStatus ci-dessous)"
				end

				local sgs = SquadGenerationStatus and SquadGenerationStatus[unit.name]
				local sgsTxt = ""
				if sgs then
					sgsTxt = " | SquadGenerationStatus mainGenerated: "..tostring(sgs.mainGenerated)
					if sgs.bestReject then
						sgsTxt = sgsTxt.." dominantReason: "..tostring(sgs.bestReject.dominantReason)
						if sgs.bestReject.finalReject then
							sgsTxt = sgsTxt.." finalReject: etape '"..tostring(sgs.bestReject.finalReject.step).."' raison '"..tostring(sgs.bestReject.finalReject.reason).."'"
						end
					end
				end

				WG_Log("AIRLIFT_AUDIT_SQUAD side: "..sideName.." name: "..tostring(unit.name).." type: "..tostring(unit.type)
					.." base: "..tostring(unit.base).." inactive: "..tostring(unit.inactive)
					.." ready: "..tostring(unit.roster and unit.roster.ready)
					.." available: "..tostring(av and av.available).." unassigned: "..tostring(av and av.unassigned)
					.." taches: ["..WG_TrueKeys(unit.tasks).."] loadouts_Transport: "..nLoad.." (pays ok: "..nLoadCountry..")"
					..sgsTxt
					.."\n    VERDICT: "..verdict
					..loadTxt..targetTxt)
			end
		end
	end

	if nHeli == 0 then
		WG_Log("AIRLIFT_AUDIT_SQUAD AUCUN squad helicoptere dans oob_air (IsHelicopter/unit.helicopter) : rien ne peut servir l'airlift")
	end

	--squads non-helico ayant la tache Transport (info : ils sont ignores par l'airlift wargame)
	for sideName, units in pairs(oob_air or {}) do
		for _, unit in pairs(units) do
			local isHeli = (IsHelicopter and IsHelicopter[unit.type]) or unit.helicopter
			if not isHeli and unit.tasks and unit.tasks["Transport"] and not unit.inactive then
				WG_Log("AIRLIFT_AUDIT_NONHELI side: "..sideName.." name: "..tostring(unit.name).." type: "..tostring(unit.type).." (tache Transport, ignore par l'airlift wargame)")
			end
		end
	end
end

--Bilan apres createATO_table : que sont devenus les drafts airlift ? (lecture seule)
--Appel unique, apres la creation de l'ATO. Complete le log (mode append).
--  dans l'ATO       : le vol existe, FlightPlan va le traiter
--  ABSENT           : le draft a ete ecarte ; les causes sont celles enregistrees par rejectDraft / rejectStep
function WG_AirliftAfterATO(draftSortiesRef, atoRef, multipackRef)

	if not WG_AIRLIFT_LOG then
		return
	end

	--index des vols presents dans l'ATO, par id de draft
	local inAto = {}
	for sideName, packages in pairs(atoRef or {}) do
		for packN, pack in pairs(packages) do
			for role, flights in pairs(pack) do
				if type(flights) == "table" then
					for _, flight in ipairs(flights) do
						if type(flight) == "table" and flight.id then
							inAto[tostring(flight.id)] = "pack "..tostring(packN).." role "..tostring(role).." nb="..tostring(flight.number)
						end
					end
				end
			end
		end
	end

	local function causeTxt(cause)
		if type(cause) ~= "table" then
			return tostring(cause)
		end
		local t = {}
		for _, v in ipairs(cause) do t[#t + 1] = tostring(v) end
		return table.concat(t, " ")
	end

	local nDraft, nInAto = 0, 0

	for sideName, drafts in pairs(draftSortiesRef or {}) do
		for _, draft in ipairs(drafts) do

			if type(draft.target) == "table" and draft.target.wargameLogistic == "airlift" then

				nDraft = nDraft + 1
				local place = inAto[tostring(draft.id)]
				if place then nInAto = nInAto + 1 end

				local lo = draft.loadout or {}
				local fp = (draft.target and draft.target.firepower) or {}
				local av = AcftAvail and AcftAvail[draft.name] or {}
				local nbPack = multipackRef and multipackRef[draft.target_name] and multipackRef[draft.target_name]["nbPack"]

				local supTxt = ""
				if type(lo.support) == "table" then
					for k, v in pairs(lo.support) do
						if v then supTxt = supTxt..tostring(k).." " end
					end
				end

				local escortNb = 0
				if draft.support and draft.support["Escort"] then
					escortNb = draft.support["Escort"]["NbTotalSupport"] or 0
				end

				WG_Log("AIRLIFT_ATO "..(place and "DANS L'ATO" or "ABSENT").." draft: "..tostring(draft.id)
					.." squad: "..tostring(draft.name).." ("..tostring(draft.type)..")"
					.." target: "..tostring(draft.target_name)
					..(place and (" | "..place) or "")
					.." | score="..tostring(draft.score).." minscore="..tostring(lo.minscore)
					.." | number="..tostring(draft.number).." loadout.firepower="..tostring(lo.firepower)
					.." target.firepower min/max="..tostring(fp.min).."/"..tostring(fp.max)
					.." | nbPack="..tostring(nbPack)
					.." | unassigned="..tostring(av.unassigned).." available="..tostring(av.available)
					.." taskCap.Transport="..tostring(av.taskCap and av.taskCap["Transport"])
					.." taskUsed.Transport="..tostring(av.taskUsed and av.taskUsed["Transport"])
					.." | support loadout=["..supTxt.."] escortes="..tostring(escortNb)
					.." strikeOnlyWithEscorte="..tostring(mission_ini and mission_ini.strikeOnlyWithEscorte))

				if draft.finalReject then
					WG_Log("    finalReject: step="..tostring(draft.finalReject.step)
						.." reason="..tostring(draft.finalReject.reason)
						.." bloc="..tostring(draft.finalReject.bloc))
				end

				if draft.rejected then
					for _, r in ipairs(draft.rejected) do
						WG_Log("    rejet: "..string.sub(tostring(r.sujet), 1, 200)
							.." | cause: "..causeTxt(r.cause)
							.." | ligne: "..tostring(r.ligne))
					end
				end
			end
		end
	end

	WG_Log("AIRLIFT_ATO_BILAN drafts airlift: "..nDraft.." | presents dans l'ATO: "..nInAto)

	WG_FlushLog(true)
end

--A appeler UNE fois, apres la generation des draft sorties (fin de la partie A).
--Compte les cibles airlift, ecrit le resultat par cible (+ note d'affichage), remet ATO=false seulement
--si WG_AIRLIFT_RESET_ATO = true, ecrit l'audit (WG_AIRLIFT_AUDIT) puis le log.
function WG_AirliftFinalize()

	local nTotal, nInactive, nNoATO, nActive = 0, 0, 0, 0

	for sideName, targets in pairs(targetlist) do
		for _, t in pairs(targets) do

			if type(t) == "table" and t.wargameLogistic == "airlift" then
				nTotal = nTotal + 1
				if t.inactive then
					nInactive = nInactive + 1
				elseif not t.ATO then
					nNoATO = nNoATO + 1
				else
					nActive = nActive + 1
				end
			end
		end
	end

	WG_Log("AIRLIFT_BILAN cibles airlift dans targetlist: "..nTotal
		.." (actives avec ATO: "..nActive..", inactive: "..nInactive..", ATO=false: "..nNoATO..")")

	for sideName, targets in pairs(targetlist) do
		for _, t in pairs(targets) do

			if type(t) == "table" and t.wargameLogistic == "airlift" and not t.inactive and t.ATO then

				local best = WG_AirliftBest[t.name]
				local needZero = (tonumber(t.wargameNeedKg) == 0)

				if best then
					WG_Log("AIRLIFT_RESULT target: "..tostring(t.name).." escadrilles evaluees: "..best.evaluated
						.." meilleur N: "..best.bestN
						..(best.bestSquad and (" ("..best.bestSquad.." / "..tostring(best.bestLoadout)..")") or "")
						.." faisable: "..tostring(best.feasibleAny))
				else
					WG_Log("AIRLIFT_RESULT target: "..tostring(t.name).." AUCUNE escadrille helico evaluee"
						.." (voir AIRLIFT_AUDIT_SQUAD plus bas : VERDICT par squad)")
				end

				if not needZero and (not best or best.bestN < 1) then

					if best and best.feasibleAny then
						t.wargameNote = WG_AIRLIFT_NOTE_FLEET
					else
						t.wargameNote = WG_AIRLIFT_NOTE
					end

					if WG_AIRLIFT_RESET_ATO then
						t.ATO = false
						WG_Log("AIRLIFT_RESET_ATO target: "..tostring(t.name).." -> ATO=false, note: "..t.wargameNote)
					else
						WG_Log("AIRLIFT_NOTE target: "..tostring(t.name).." ATO reste true, note: "..t.wargameNote)
					end
				end
			end
		end
	end

	if WG_AIRLIFT_AUDIT then
		local ok, err = pcall(WG_AirliftAudit)
		if not ok then
			WG_Log("AIRLIFT_AUDIT ERREUR: "..tostring(err))
		end
	end

	WG_FlushLog()
end


if Multi and Multi.Group then
	for k = 1, Multi.NbGroup do

		local group = Multi.Group[k]

		if group then

			local key =
				tostring(group.side) .. "|" ..
				tostring(group.PlaneType) .. "|" ..
				tostring(group.task)

			playerRequestedMainTask[key] = {
				side = group.side,
				plane = group.PlaneType,
				task = group.task,
				requested = group.NbPlane or 0,
			}
		end
	end
end

--///////////////////////------------MAIN------Bloc A------/////////////////////////////////////
--///////////////////////------------MAIN------Bloc A------/////////////////////////////////////
--///////////////////////------------MAIN------Bloc A------/////////////////////////////////////
local EMPTY = {} -- Optimisation CPU : évite de recréer une table en mémoire

--creat draft sorties
for sideName, units in pairs(oob_air) do

	local draftId = 1
	if Debug.Generator.affiche then
		if Debug.Generator.SpyTarget then
			debugLog("draftId"..draftId.." \n\n"..Debug.Generator.SpyTarget)
		end
	end

	for unitN, unit in pairs(units or EMPTY) do

		if unit.inactive and unit.player then
			print("AtoG attention, the player's squad is inactive. Activate it via DCE_Manager or directly in Init\\oob_air and Active\\oob_air ") os.execute 'pause'
		end

		if not SquadGenerationStatus[unit.name] then

			--Pourquoi: garder la liste des tâches et savoir si le squad a une vraie tâche principale,
			--pour que le rapport final ne confonde plus "pas de bestReject" avec "escort/support pur"
			local MAIN_TASKS_INIT = {
				["Strike"] = true, ["CAP"] = true, ["Intercept"] = true, ["CAS"] = true,
				["Transport"] = true, ["SAR"] = true, ["CSAR"] = true, ["Runway Attack"] = true,
				["Anti-ship Strike"] = true, ["Reconnaissance"] = true, ["AWACS"] = true,
				["Refueling"] = true, ["Fighter Sweep"] = true, ["AFAC"] = true,
			}

			local enabledTasks = {}
			local hasMainTask = false

			for taskName, taskBool in pairs(unit.tasks or EMPTY) do
				if taskBool then
					enabledTasks[#enabledTasks + 1] = taskName
					if MAIN_TASKS_INIT[taskName] then
						hasMainTask = true
					end
				end
			end

			SquadGenerationStatus[unit.name] = {

				unitName = unit.name,
				unitType = unit.type,

				mainGenerated = false,
				supportGenerated = false,

				bestReject = nil,
				bestScore = -1,

				tasks = enabledTasks,
				hasMainTask = hasMainTask,
			}
		end

		--Contexte local du draft
		--Pourquoi: centraliser l'état du draft dès le début du pipeline
		local draftContext = {
			--debug
			-- debugId = draftId,
			draftId = draftId,
			rejectReasons = {},
			rejectCount = {},
			finalReject = nil,
			generatedSortie = false,
			anyMissionGenerated = false,

			--unit runtime
			unit = unit,
			unitName = unit.name,
			unitType = unit.type,
			side = sideName,

			--state runtime
			state = {},
		}

		--ATO_Generator_v2 :
		--///////////////////////////////////////////////////////
		local unitReady = prepareUnitContext(draftContext, sideName)
		--///////////////////////////////////////////////////////

		if unitReady then

			local isDebugModeA1 = Debug.Generator.affiche and string.find(Debug.Generator.chapter, "A")
				and (
					(Debug.Generator.SpySquad and Debug.Generator.SpySquad == unit.name)
					or (not Debug.Generator.SpySquad)
				)

			if isDebugModeA1 then debugLog("draftId"..draftId.." AtoG passe A_01 "..unit.type.." Befor roster.ready Condition  ") end

			-- local overRideReady = false
			local clientPlayer = false

			if Multi.NbGroup == 0 then
				clientPlayer = unit.player
			end

			draftContext.clientPlayer = clientPlayer

			-- if Multi.NbGroup == 0 then clientPlayer = unit.player end
			if unit.player then
				PlayerSquad = unit
				PlayerPlane = unit.type
			end

			atoMainTaskFound = false

			local MAIN_TASKS = {
				["Strike"] = true,
				["CAP"] = true,
				["Intercept"] = true,
				["CAS"] = true,
				["Transport"] = true,
				["SAR"] = true,
				["CSAR"] = true,
				["Runway Attack"] = true,
				["Anti-ship Strike"] = true,
				["Reconnaissance"] = true,
				["AWACS"] = true,
				["Refueling"] = true,
				["Fighter Sweep"] = true,
				["AFAC"] = true,
			}

			--Pourquoi: la restriction "une seule tâche par recherche" (basée sur tasksCoef) a été retirée :
			--elle empêchait un squad de jamais être tenté sur sa tâche à plus faible coefficient, même
			--quand taskCap lui réserve encore de la place dessus. taskCap (dans addFlight) gère maintenant
			--la répartition équitable au moment de la consommation ; la recherche retente donc toutes les
			--tâches actives du squad, comme avant tasksCoef.
			local mainTasksToTry = unit.tasks

			if unit.tasks and unit.tasks["Transport"] then WG_AirliftTrace(unit, "Transport", "1_UNIT_ATTEINT", "Daytime="..tostring(Daytime).." available="..tostring(AcftAvail[unit.name].available).." ready="..tostring(unit.roster and unit.roster.ready).." base="..tostring(unit.base).." country="..tostring(unit.country)) end
	
			if unit.tasks and unit.tasks["Transport"] then WG_AirliftTraceTargets(tgtList_Gen, sideName, unit) end

			for task, task_bool in pairs(mainTasksToTry) do																		--iterate through all tasks of unit		
				if isDebugModeA1 then
					debugLog("draftId"..draftId.." AtoG passe A_03b task: "..tostring(task).." task_bool: "..tostring(task_bool).."  available: "..tostring(AcftAvail[unit.name].available).." = ready:  "..tostring(unit.roster.ready) .." - unavailable: ".. tostring(#AcftAvail[unit.name].unavailable))
				end

				if task_bool and MAIN_TASKS[task] then

					atoMainTaskFound = true

					validateStep(draftContext, "task")

					local isDebugModeA2 =
						Debug.Generator.affiche
						and string.find(Debug.Generator.chapter, "A")
						and (
							(Debug.Generator.SpySquad and Debug.Generator.SpySquad == unit.name)
							or (not Debug.Generator.SpySquad and Debug.Generator.SpyTask == task)
						)

					if isDebugModeA2 then
						debugLog("draftId"..draftId.." AtoG passe A_04b "..unit.type.." Befor task Condition | task: "..task)
					end

					--get possible loadouts
					local unit_loadouts = {}																					--table to hold all loadouts for this aircraft type and task

					if not LoadoutsList[unit.type] then
						rejectStep(draftContext, "LoadoutsList", "no_aircraft_loadout", nil, "BLOCK_A", SafeGetLine())
					else
						if not LoadoutsList[unit.type][task] then
							rejectStep(draftContext, "task", "no_task_loadout", task, "BLOCK_A", SafeGetLine())
						end
					end

					if LoadoutsList[unit.type] and LoadoutsList[unit.type][task] then																		--db_loadouts table has loadouts for this task

						for loadout_name, ltable in pairs(LoadoutsList[unit.type][task]) do									--iterate through all loadouts for the aircraft type and task

							local countryEligible = false
							if ltable.country == nil  then
								countryEligible = true
							elseif type(ltable.country) == "string" then
								if string.lower(ltable.country) == string.lower(unit.country) or string.lower(ltable.country) == "all" then
									countryEligible = true
								end

							elseif type(ltable.country) == "table" then
								for n, countryLabel in pairs(ltable.country) do
									if string.lower(countryLabel) == string.lower(unit.country) or string.lower(countryLabel) == "all" then
										countryEligible = true
										break
									end
								end
							end

							if countryEligible then
								ltable.name = loadout_name																		--store loadout name

								--copie locale du loadout pour éviter les mutations globales
								--Pourquoi: certaines valeurs sont modifiées dynamiquement pendant la génération
								local localLoadout = DeepCopy(ltable)

								localLoadout["hCruiseREF"] = localLoadout.hCruise
								localLoadout["hAttackREF"] = localLoadout.hAttack

								-- --ceci est un anti PBO_Corse66 ^^
								-- -- donne une alti aléatoire pour éviter de connaitre le type d'avion pas l'altitude habituellement utilisée
								-- if localLoadout.hCruise and localLoadout.hCruise > 2000 then
								-- 	local altiRandom = 0
								-- 	local RandomChance = math.random(0,100)

								-- 	if RandomChance < 50 then										--20% de chance d'avoir une alti de 1000 à 2000m de difference 
								-- 		altiRandom = math.random(100 ,200)

								-- 	elseif RandomChance < 70 then									--30% de chance d'avoir une alti de 1000m de difference
								-- 		altiRandom = math.random(0,100)
								-- 	end																--50% de chance d'avoir une alti de 0 de difference

								-- 	altiRandom = altiRandom *10 * (math.random(0, 1)*2-1)			--choisi si c'est une diff positive ou negative												
								-- 	localLoadout.hCruise = localLoadout.hCruise + altiRandom
								-- 	if localLoadout.hCruise < 300 then
								-- 		localLoadout.hCruise = 300
								-- 	end

								-- 	if localLoadout.hAttack then
								-- 		localLoadout.hAttack = localLoadout.hAttack + (altiRandom /2)
								-- 		if localLoadout.hAttack < 300 then
								-- 			localLoadout.hAttack = 300
								-- 		end
								-- 	end
								-- end

								--ajoute une task obligatoire en fonction du learning des missions précédentes
								if camp.newTaskRequest then
									for rSide, rSides in pairs(camp.newTaskRequest) do
										if rSide == sideName then
											for rTypeName, rTypes in pairs(rSides) do
												if rTypeName == unit.type then
													for rTaskEnCours, rNewTasks in pairs(rTypes) do
														if rTaskEnCours == task then
															for rNewTask, value in pairs(rNewTasks) do
																if value then
																	if not localLoadout.support then localLoadout.support = {} end
																	localLoadout.support[rNewTask] = true
																end
															end
														end
													end
												end
											end
										end
									end
								end

								unit_loadouts[#unit_loadouts+1] = localLoadout
								unit_loadouts[#unit_loadouts]["loadout_name"] = loadout_name

							else
								rejectStep(draftContext, "LoadoutCountry", "no_loadout_country", ltable.country,"BLOCK_A", SafeGetLine())

							end
						end
					end

					--mix the list of available loadouts so that you don't always have the same ones 
					--https://programming-idioms.org/idiom/10/shuffle-a-list/1313/lua
					for i = #unit_loadouts, 2, -1 do
						local j = math.random(i)
						unit_loadouts[i], unit_loadouts[j] = unit_loadouts[j], unit_loadouts[i]
					end

					if task == "Transport" then WG_AirliftTrace(unit, task, "2_LOADOUTS", "nb loadouts retenus (pays ok)="..#unit_loadouts.." Daytime="..tostring(Daytime).." LoadoutsList="..tostring(LoadoutsList[unit.type] ~= nil and LoadoutsList[unit.type][task] ~= nil)) end


					for l = 1, #unit_loadouts do																				--iterate through all available loadouts				

						if isDebugModeA2 then
							debugLog("draftId"..draftId.." AtoG passe A_05 "..unit.type.." "..unit_loadouts[l].loadout_name.." Befor Loadouts Day/Night Condition Daytime? "..tostring(Daytime))
						end

						--copie locale du loadout pour éviter de modifier le loadout global
						--Pourquoi: certaines valeurs sont modifiées dynamiquement pendant le draft
						local currentLoadout = DeepCopy(unit_loadouts[l])
						currentLoadout.loadoutName = unit_loadouts[l].loadout_name

						local debug = "/n day: "..tostring(currentLoadout.day) .." night?: ".. tostring(currentLoadout.night)
						if currentLoadout.day == nil then
							currentLoadout.day = true
						end

						local loadoutCompatible = true

						if Daytime == "night" and currentLoadout.day and not currentLoadout.night then

							loadoutCompatible = false

							rejectStep( draftContext, "loadout", "loadout_day_only",
								{
									loadout = currentLoadout.loadoutName,
									day = currentLoadout.day,
									night = currentLoadout.night,
									missionDaytime = Daytime,
								},
								"BLOCK_A",
								SafeGetLine()
							)
						elseif Daytime == "day" and currentLoadout.night and not currentLoadout.day then

							loadoutCompatible = false

							rejectStep(draftContext, "loadout", "loadout_night_only",
								{
									loadout = currentLoadout.loadoutName,
									day = currentLoadout.day,
									night = currentLoadout.night,
									missionDaytime = Daytime,
								},
								"BLOCK_A",
								SafeGetLine()
							)
						end

						--risque contient encore l'ancienne valeur du loadout précédent.
						draftContext.state.tot_from = 0
						draftContext.state.tot_to   = 0

						--*****************************
						--get possible Time on Target
						if loadoutCompatible then
							draftContext = computeTOTWindow(draftContext, currentLoadout, Daytime, mission_ini, camp, task, draftId, isDebugModeA2)
						end
						--*****************************

						if draftContext.state.tot_to ~= 0 then
							-- if tot_from ~= 0 or tot_to ~= 0 then																	--loadout has an eligible time on target
							if isDebugModeA2 then
								debugLog("draftId"..draftId.." AtoG passe A_06 Befor targetlist Boucle")
							end

							if draftContext.state.tot_from == 0 then																				--player is only allowed to start at mission start
								TrackPlayability(unit.player, "tot")															--track playabilty criterium has been met
							end

							local i_timmer01 = 0
							for target_sideName, targets in pairs(tgtList_Gen) do											--iterate through sides in targetlist				
								i_timmer01 = i_timmer01 +1
								
								if sideName == target_sideName then																--if the target is hostile
									local totalTarget = 0
									
									for target_name, target in pairs(targets) do
										totalTarget = totalTarget + 1
									end

									local iTarget = 0
									for targetN, target in pairs(targets) do											--iterate through all hostile targets
										iTarget = iTarget + 1
										if iTarget ~= 1 then
											draftId = draftId + 1
										end
										
										local target_name = target.titleName
										if task == "Transport" and target.wargameLogistic == "airlift" then WG_AirliftTrace(unit, task, "4_CIBLE_"..tostring(target_name), "inactive="..tostring(target.inactive).." ATO="..tostring(target.ATO).." target.task="..tostring(target.task).." titleName="..tostring(target.titleName)) end

										if not target.inactive and target.ATO then											--if target is active and should be added to ATO
											
											local isDebugModeA3 = Debug.Generator.affiche
												and string.find(Debug.Generator.chapter, "A")
												and (
													(
														Debug.Generator.SpySquad
														and Debug.Generator.SpySquad == unit.name
														and Debug.Generator.SpyTask == task
													)
													or (
														not Debug.Generator.SpySquad
														and (
															Debug.Generator.SpyTask == task
															or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == target.titleName)
														)
													)
												)

											if isDebugModeA3 then
												debugLog("draftId"..draftId.." AtoG passe A_07c :"..unit.type.." "..target.titleName.." Befor task Condition: "..target.task .." ==? task? "..task.." || "..target_name)
											end

											if target.task == task then															--if target is valid for aircaft-loadout															
												validateStep(draftContext, "target")
												--ajoute la task au loadout du main pour que cette task/support devienne obligatoire

												draftContext.target = target
												draftContext.targetName = target_name
												draftContext.task = task

												if camp.newTaskPerTarget then
													for tableTargetName, targetTask in pairs(camp.newTaskPerTarget) do
														if tableTargetName == target_name and targetTask.tasks then
															for task_, value in pairs(targetTask.tasks) do
																if not currentLoadout.support then currentLoadout.support = {} end
																currentLoadout.support[task_] = true
															end
														end
													end
												end

												--**********************************************
												local loadoutEligible = checkAttributeEligibility(draftContext, currentLoadout, target, draftId, unit, isDebugModeA3)
												--**********************************************

												if task == "Transport" and target.wargameLogistic == "airlift" then WG_AirliftTrace(unit, task, "5_ATTRIBUTS_"..tostring(target_name), "loadoutEligible="..tostring(loadoutEligible).." loadout="..tostring(currentLoadout.loadoutName)) end


												if isDebugModeA3 then
													debugLog("draftId"..draftId.." AtoG passe A_10b Befor Condition loadoutEligible?: "..tostring(loadoutEligible).." |unit.name: "..unit.name.." |target_name: "..target_name.." |target.base: "..tostring(target.base).." |unit.base: "..unit.base)
												end

												if loadoutEligible then

													validateStep(draftContext, "loadout")

													--get airbase position
													local airbasePoint = {																				--get the x-y coordinates of the airbase where the unit is located
														x = db_airbases[unit.base].x,
														y = db_airbases[unit.base].y,
														h = db_airbases[unit.base].elevation,
														BaseAirStart = db_airbases[unit.base].BaseAirStart,
														name = unit.base,
													}

													--**********************************************
													if task == "Transport" and target.wargameLogistic == "airlift" then
														--cibles airlift du wargame (sans base) : traitement dedie, voir WG_AirliftProcess
														WG_AirliftProcess( draftContext, sideName, task, target, target_name,
															unit, currentLoadout, airbasePoint, draftId, isDebugModeA3,
															processEligibleLoadout, draftSorties, Daytime, i_timmer01 )
													else
														processEligibleLoadout( draftContext, sideName, task, target, target_name,
															unit, currentLoadout, Daytime, airbasePoint, draftId, isDebugModeA3, i_timmer01 )
													end
													--**********************************************

												else
													-- if loadoutEligible then
													rejectStep(draftContext, "loadoutEligible", "no_loadoutEligible",nil, "BLOCK_A", SafeGetLine())
												end
											else
												if not DraftProgress[unit.name] or not DraftProgress[unit.name].task then
													rejectStep(draftContext, "task", "no_target.task == task", task, "BLOCK_A", SafeGetLine())
												end
												-- if target.task == task then
											end
										else
											-- if not target.inactive and target.ATO then	
											if target.inactive then
												rejectStep(draftContext, "target", "no_target_active", nil, "BLOCK_A", SafeGetLine())
											elseif not target.ATO then
												rejectStep(draftContext, "target", "no_target_ATO", nil, "BLOCK_A", SafeGetLine())
											end
										end
									end
								end
							end
						else
							-- if draftContext.state.tot_to ~= 0 then
							if task == "Transport" then WG_AirliftTrace(unit, task, "3_TOT_ZERO", "fenetre TOT vide pour le loadout "..tostring(currentLoadout.loadoutName).." Daytime="..tostring(Daytime).." day="..tostring(currentLoadout.day).." night="..tostring(currentLoadout.night)) end

						end

					end
				end
			end

			if isPlayerRelatedDraft(draftContext) and not draftContext.generatedSortie and next(draftContext.rejectStats or {}) then

				local reason =
					getDominantRejectReason(draftContext)

				--donnees precises (cible, distance, firepower, etc.) + ligne capturees
				--par le rejectStep() correspondant a "reason" ; a defaut (raison sans
				--data associee, ex: HumainRequired), on retombe sur le compteur brut.
				local rejectDetail =
					getRejectDetail(draftContext, reason)

				registerPlayerFailure({

					-- draftId = draftContext.debugId,
					draftId = draftContext.draftId,

					requestedPlane = unit.type,
					requestedTask = "MULTI",
					requestedNb = 1,

					stage = "BLOCK_A",

					reason = reason,

					line = rejectDetail and rejectDetail.line,

					details = (rejectDetail and rejectDetail.data) or DeepCopy(draftContext.rejectStats),

					debugText = reason,
				})
			end
		end

		--debug final reject
		--Pourquoi: afficher précisément le dernier blocage rencontré pour ce squad
		-- if atoMainTaskFound and not draftContext.generatedSortie then

		-- if atoMainTaskFound and not draftContext.generatedSortie and not draftContext.anyMissionGenerated then

		-- 	local reject = draftContext.finalReject

		-- 	local dominantReason = getDominantRejectReason(draftContext)

		-- 	local rejectStatsTxt = ""

		-- 	if draftContext.rejectStats then
		-- 		for reason, count in pairs(draftContext.rejectStats) do
		-- 			rejectStatsTxt =
		-- 				rejectStatsTxt
		-- 				.. reason
		-- 				.. "="
		-- 				.. count
		-- 				.. " "
		-- 		end
		-- 	end

		-- 	if not reject or (reject and reject.reason ~= "inactive") then

		-- 		print("\n========== NO GENERATION REASON ==========")
				
		-- 		local txt =
		-- 			(unit and unit.name or "nil")
		-- 			.." | "..unit.type
		-- 			.." | finalRejectStep: "..tostring(reject and reject.step or "nil")
		-- 			.." | finalReason: "..tostring(reject and reject.reason or "nil")
		-- 			.." | dominantReason: "..tostring(dominantReason or "nil")
		-- 			.." | stats: "..rejectStatsTxt
		-- 			.." | ==> | "

		-- 		if reject and reject.data then

		-- 			if type(reject.data) == "table" then

		-- 				for k, v in pairs(reject.data) do
		-- 					txt = txt.." | "..tostring(k)..": "..tostring(v)
		-- 				end
		-- 			elseif type(reject.data) == "string" then
		-- 					txt = txt.." | "..reject.data
		-- 			end
		-- 			rejectStep(draftContext, 
		-- 				tostring(reject and reject.step or "nil"), 
		-- 				tostring(reject and reject.reason or "nil"), 
		-- 				reject.data,
		-- 				"BLOCK_A",
		-- 				SafeGetLine()
		-- 			)
												
		-- 		end

		-- 		print("\r\n"..txt)
		-- 		print("===========================================\n")

		-- 		-- if not reject or not reject.step or not reject.reason then
		-- 		-- 	printDraftProgressReport(unit.name)
		-- 		-- end

		-- 	end
		-- end

		if atoMainTaskFound and not draftContext.generatedSortie then

			local squadStatus = SquadGenerationStatus[unit.name]

			if squadStatus then

				local score = computeRejectScore(draftContext)

				if score > squadStatus.bestScore then

					squadStatus.bestScore = score

					squadStatus.bestReject = {

						finalReject = DeepCopy(draftContext.finalReject),

						dominantReason = getDominantRejectReason(draftContext),

						stats = DeepCopy(draftContext.rejectStats),
					}
				end
			end
		end
	end
end
-- printDraftProgressReport()

print("-")
print("ATO Generating Sortie (" .. status_counter_sorties .. ") - Complete")
debugLog("\n"..("ATO Generating Sortie (" .. status_counter_sorties .. ") - Complete"))


WG_AirliftFinalize()		--wargame airlift 2a : bilan par cible (ATO=false si aucun helico possible) + Debug/WG_Airlift.log

        if MemProbe then MemProbe("fin Part A (drafts)") end
        if MemFields then MemFields("draftSorties.blue", draftSorties.blue, 150) end
        if MemFields then MemFields("draftSorties.red", draftSorties.red, 150) end

local shuffled = {}
for i, v in ipairs(oob_air["blue"]) do
	local pos = math.random(1, #shuffled+1)
	table.insert(shuffled, pos, v)
end
oob_air["blue"] = shuffled

shuffled = {}
for i, v in ipairs(oob_air["red"]) do
	local pos = math.random(1, #shuffled+1)
	table.insert(shuffled, pos, v)
end
oob_air["red"] = shuffled

-- Tri final par `targetPriority` (ascendant), puis par `score` (descendant)
for side, sorties in pairs(draftSorties) do
    table.sort(sorties, function(a, b)
        if a.targetPriority ~= b.targetPriority then
            return a.targetPriority > b.targetPriority -- Plus petite priorité d'abord
        end
        return a.score > b.score -- Plus grand score d'abord
    end)
end

if Debug.Generator.affiche then

	for sideName, drafts in pairs(draftSorties) do
		local di = 1
		debugLog(string.upper(sideName).." PART A")

		for draft_n, draft in pairs(drafts) do
			if  di < Debug.Generator.nb or draft.name == Debug.Generator.SpySquad or draft.target_name == Debug.Generator.SpyTarget then		--if  di < Debug.Generator.nb and string.find(draft.task, "Strike") then
				debugLog(	"A N° " .. draft_n..
						" /id/ " ..tostring(draft.id)..
						" /draft.targetPriority/ " ..tostring(draft.targetPriority)..
						-- " /draft.priorityIni/ " ..tostring(draft.priorityIni)..
						" /Nb/ " ..draft.number..
						" /flights/ " ..tostring(draft.flights)..
						" /Type/ "..draft.type..
						" /Name/ "..draft.name..
						" /threatsGround/ "..round(draft.threatsGround)..
						" /threatsAir/ "..round(draft.threatsAir)..
						" /Score/ " ..round(draft.score)..
						" /Task/ "..draft.task..
						" /Target/ "..draft.target_name..
						" /Sead_Of/ "..tostring(draft.route.threats.SEAD_offset)..
						" /main_overideMP/ " ..tostring(draft.main_overideMP)..
						" /remainingFirepower/ " ..draft.remainingFirepower..
						" /multipack/ " ..draft.multipack
						.." /supportEscort?/ " ..tostring(draft.support["Escort"])
						.." /supportCSAR?/ " ..tostring(draft.support["CSAR"])

						-- .." /loadout/ "..tostring(draft.loadout.loadout_name)
						)

				di = di +1
			end
		end
	end

end

if Debug.Generator and Debug.debug then
	flushDebugLogs()
end

-- Ajoute effectivement un support au draft
local function addSupportToDraft(
	draft,
	unitSupport,
	uSupportLoadout,
	sptTask,
	route,
	side,
	playable_II,
    overideMP_B,
	isDebugModeB,
	remain_air_total,
	support_requirement,
	support_tot_from,
	support_tot_to,
	wk,
	uniqueBonus
		)
	 -- multiPlaneSet_B, 

	TrackPlayability(unitSupport.player, "escort_target_range")									--track playabilty criterium has been met

	local debuGenTxt1545 = "\n"..(tostring(draft.id).." AtoG II_support() S1 pass B_17  ")

	--determine number of escorts
	local escort_num = 0
	local escort_max = 0

    -- local wk = 1

	if draft.support[sptTask]["escort_max"] ~= 999 then
		escort_max = draft.support[sptTask]["escort_max"]
	else
		escort_max = 0
	end

	if sptTask == "SEAD" then
		escort_num = draft.route.threats.SEAD_offset / uSupportLoadout.firepower 		-- uSupportLoadout.capability  capability determines amount of offset per aircraft
		-- escort_num = remain_SEAD_offset / uSupportLoadout.firepower
		escort_num = math.ceil(escort_num / 2) * 2										--round up requested escorts to even number

		if escort_num > 4 then
			escort_num = 4
		end	

		--TODO revoir ça
		-- if totalPlanePerTask[side][task] and totalPlanePerTask[side][task]/2 >= escort_num then
		-- 	draft.score = draft.score + (1 * draft.loadout.firepower) * draft.target.priority
		-- end

		debuGenTxt1545 = debuGenTxt1545.."\n"..(tostring(draft.id).." AtoG II_support() S2 pass_SEAD B "..unitSupport.type.." "..sptTask.." "..escort_num.." NbTotalSupport: "..draft.support[sptTask]["NbTotalSupport"].." draft.score: "..draft.score)
		debuGenTxt1545 = debuGenTxt1545.."\n"..("-------------------- escort_num: "..(draft.route.threats.SEAD_offset / uSupportLoadout.firepower).. "= SEAD_Offset: "..draft.route.threats.SEAD_offset.." /firepower "..uSupportLoadout.firepower
												)

	elseif sptTask == "Escort" then

		if draft.support[sptTask]["escort_max"] ~= 999 then
			escort_num = draft.support[sptTask]["escort_max"] - draft.support[sptTask]["NbTotalSupport"]	-- modification M11.x : Multiplayer	(x: EscorteTot-max)

			debuGenTxt1545 = debuGenTxt1545.."\n"..(tostring(draft.id).." AtoG II_support() S3 pass_Escort B "..unitSupport.type.." "..sptTask
						.." escort_num: "..escort_num.." = escort_max  "..draft.support[sptTask]["escort_max"].." - NbTotalSupport?: "..draft.support[sptTask]["NbTotalSupport"])

		else

			local escort_offset_level =  uSupportLoadout.firepower	--uSupportLoadout.capability *--threat level that each fighter escort can offset
			-- escort_num = (draft.route.threats.air_total - 0.5) / escort_offset_level		--number of escorts needed to offset total air threat (-0.5 because that is no air threat)
			escort_num = (remain_air_total - 0.5) / escort_offset_level

			if escort_num > draft.number * 2 then											--when more escorts 2 times escorts than escorted aircraft
				escort_num = draft.number * 2												--limit escort number to 2 times escorted aircraft
			end
			-- if escort_num > campMod.Setting_Generation.limit_escort then
			-- 	escort_num = campMod.Setting_Generation.limit_escort
			-- end

			escort_num = math.ceil(escort_num / 2) * 2										--round up requested escorts to even number

			if escort_num > escort_max then
				escort_max = escort_num
				draft.support[sptTask]["escort_max"] = escort_max
			end

			debuGenTxt1545 = debuGenTxt1545.."\r\n"..(tostring(draft.id).." AtoG II_support() S4 pass_Escort I "..unitSupport.type.." "..sptTask.." escort_num: "..escort_num)

		end

	elseif sptTask == "Escort Jammer" then
		escort_num = 1																	--escort jamming by single aircraft
	elseif sptTask == "Flare Illumination" then
		escort_num = 1																	--flare illumination by single aircraft
	elseif sptTask == "Laser Illumination" then
		escort_num = 1																	--laser illumination by single aircraft
	elseif sptTask == "Strike" and not overideMP_B then
		-- escort_num = 4
		escort_num = draft.remainingFirepower / uSupportLoadout.firepower
	elseif sptTask == "Strike"  then
		escort_num = 4
	end

	--ici 4 Mi24 redemandé
	-- mais c'est 4 de trop, 4 sont déjà pris en main strike
	if escort_num > AcftAvail[unitSupport.name].available then					--if more escorts are requested than available
		escort_num = AcftAvail[unitSupport.name].available						--reduce requested escorts to number of available escorts
		escort_num = math.floor(escort_num / 2) * 2										--round down to even number

		debuGenTxt1545 = debuGenTxt1545.."\r\n"..(tostring(draft.id).." AtoG II_support() S5 pass_Escort "..unitSupport.type.." "..sptTask.." escort_num: "..escort_num.." available: "..AcftAvail[unitSupport.name].available)

	end

	if escort_num <= 0 then
		rejectStep(draft, "aircraft_available", "no_aircraft_available", {requestedTask = sptTask}, "BLOCK_B", SafeGetLine())
	end

	debuGenTxt1545 = debuGenTxt1545.."\r\n"..(tostring(draft.id).." AtoG II_support() S6 pass_Escort "..unitSupport.type.." "..sptTask.." "..escort_num)

	local txtDebug = ""

	local mpSupportTask_Check = getMultiPlaneTask(side, unitSupport.name, unitSupport.type, sptTask)

	if mpSupportTask_Check  then

		txtDebug = txtDebug .. " passeA ".."\n"

		local mpMainTask_Check = getMultiPlaneTask(side, draft.name, draft.type, draft.task)
		local mpSupport_Data = getMultiPlane(side, unitSupport.name, unitSupport.type)

		if mpMainTask_Check then
			if mpSupport_Data then 
				mpSupport_Data.NbPlane = math.max(0, mpSupport_Data.NbPlane - draft.number)
				txtDebug = txtDebug .. "    AtoG II_support() S7 NbPlane: "..mpSupport_Data.NbPlane.." draft.task: "..tostring(draft.task).."\n"
			end
		end

		playable_II = true

		-- mpSupportTask_Check = getMultiPlaneTask(side, unitSupport.name, unitSupport.type, sptTask)

		txtDebug =  txtDebug.."    AtoG II_support() S8 mpSupportTask_Check: "
		.."mpSupport_Data "..tostring(mpSupport_Data)
		.."mpSupportTask_Check "..tostring(mpSupportTask_Check)
		.."side "..tostring(side)
		.."unitSupport.name "..tostring(unitSupport.name)
		.."unitSupport.type "..tostring(unitSupport.type)
		.."sptTask "..tostring(sptTask)
		.."\r\n"

		if mpSupport_Data and mpSupportTask_Check then
			escort_num = mpSupport_Data.InitNbPlane
			txtDebug =  txtDebug.."    AtoG II_support() S9 escort_num: "..escort_num.."\r\n"
		end

		if escort_num >= 1 then
			draft.score = draft.score * 1.2 + 1000
			draft.scoreAdd =  draft.scoreAdd + 1000
			draft.scoreCoef =  draft.scoreCoef * 1.2
			txtDebug = txtDebug.."    AtoG II_support() S10 "..draft.score.."\r\n"
		end

		txtDebug = txtDebug.."    AtoG II_support() S11 "..draft.score.."\r\n"

		txtDebug = txtDebug.."    AtoG II_support() S12 NbPlane "..multiPlaneSet[side][unitSupport.type][unitSupport.name].NbPlane.."\r\n"
		-- txtDebug = " 	AtoG II_support() S13 InitNbPlaneByTask: "..tostring(multiPlaneSet[side][unitSupport.type][unitSupport.name].InitNbPlaneByTask).." /n/r "..txtDebug

		-- Marquer l'unité comme vérifiée
		multiPlaneSet[side][unitSupport.type][unitSupport.name].checked = true

		-- Vérification si tous les éléments sont cochés
		local fullMP_Plane = true
		for typeM, tasksM in pairs(multiPlaneSet[side]) do
			if type(tasksM) == "table" then
				for taskM, value in pairs(tasksM) do
					if type(value) == "table" and not value.checked then
						fullMP_Plane = false
						break  -- Arrêter la vérification dès qu'un élément n'est pas coché
					end
				end
				if not fullMP_Plane then
					break  -- Sortir complètement si un type n'est pas entièrement vérifié
				end
			end
		end

		-- Doubler le score si tous les éléments sont cochés
		-- if fullMP_Plane and not uniqueBonus then
		if fullMP_Plane and not draft.uniqueBonusApplied then
			draft.score = draft.score + 2000				--draft.score * 2000
			draft.scoreCoef =  draft.scoreCoef + 2000		--draft.scoreCoef * 2000

			-- uniqueBonus = true
			draft.uniqueBonusApplied = true

			txtDebug =  "    AtoG II_support() S14 uniqueBonus "..draft.score.." /n/r "..txtDebug
		end

		if isDebugModeB then
			debugLog(debuGenTxt1545..draft.id.." AtoG II_support() S15 B_20 escort_num "..tostring(escort_num).." txtDebug: "..txtDebug   .." |score: "..tostring(draft.score))
		end

	end

	if Multi.NbGroup == 0 then
		playable_II = unitSupport.player
	end

	local wi = 1

	if isDebugModeB then
		debugLog(draft.id.." AtoG II_support() S16 pass B_21 Id "..tostring(draft.id).." "..unitSupport.type.." "..unitSupport.name.." escort_num "..tostring(escort_num).." "..draft.target_name.." NbTotalSupport: "..draft.support[sptTask]["NbTotalSupport"] )
	end

	TrackPlayability(unitSupport.player, "escort_target_firepower")							--track playabilty criterium has been met

	local entryEscortNum

	entryEscortNum = escort_num

	-- --TODO heuuuuuuuu, risqué ça
	-- if not draft.support[task] then
	-- 	draft.support[task] = {}
	-- end

	--add escort table to sortie															
	-- draft.support[sptTask]["NbTotalSupport"] = draft.support[sptTask]["NbTotalSupport"] + escort_num
	-- draft.support[sptTask]["escort_max"] = escort_max
	local futureNbTotalSupport = draft.support[sptTask]["NbTotalSupport"] + escort_num

	--regarde si l'enregistrement n'a pas encore eu lieu, sinon bloque avec la variable free_slot 
	--ceci doit etre vide draft.support[task][unitSupport.type]
	local free_slot = (draft.support[sptTask][unitSupport.type] == nil)

	if isDebugModeB then
		debugLog(draft.id.." AtoG II_support() S17 B_21 Id "..tostring(draft.id).." "..unitSupport.type.." "..unitSupport.name.."".." escort_num "..tostring(escort_num)
		.." "..draft.target_name.." entryEscortNum: "..tostring(entryEscortNum)
		.." free_slot: "..tostring(free_slot and " free_slot: true " or " free_slot: false ") )
	end

	if entryEscortNum >= 1 and free_slot then

		draft.support[sptTask]["NbTotalSupport"] = futureNbTotalSupport
		draft.support[sptTask]["escort_max"] = escort_max

		if isDebugModeB then
			debugLog(tostring(draft.id).." AtoG II_support() S18 pass B_9999 Add In draft.support ".." NbTotalSupport: "..draft.support[sptTask]["NbTotalSupport"])
		end

		if not draft.support[sptTask][unitSupport.type] then
			draft.support[sptTask][unitSupport.type] = {}
		end

		draft.support[sptTask][unitSupport.type] = {
			id = draft.id.."-"..wi.."-"..wk,
			name = unitSupport.name,
			playable = playable_II,								--unit.player,
			-- playable = unit.player,
			type = unitSupport.type,
			modification = unitSupport.modification,
			callsign = unitSupport.callsign,
			callsignId = unitSupport.callsignId,
			helicopter = unitSupport.helicopter,											-- modification M06 : helicopter playable
			number = entryEscortNum,
			country = unitSupport.country,
			livery = unitSupport.livery,
			sidenumber = unitSupport.sidenumber,
			liveryModex = unitSupport.liveryModex,
			base = unitSupport.base,
			airdromeId = db_airbases[unitSupport.base].airdromeId,
			parking_id = unitSupport.parking_id,
			skill = unitSupport.skill,
			task = sptTask,
			tasks = unitSupport.tasks,
			loadout = uSupportLoadout,
			route = route,
			target = DeepCopy(draft.target),
			target_name = draft.target.titleName,
			tot_from = draft.tot_from,
			tot_to = draft.tot_to,
			rejected = {},
			main_overideMP = draft.main_overideMP,
			overideMP_B = overideMP_B,
			-- priorityIni = draft.priorityIni,
			support_requirement = support_requirement,
			client = unitSupport.client,
		}

		local squadStatus = SquadGenerationStatus[unitSupport.name]
		-- print("create support AAA sortie for squad "..unitSupport.name.." with task "..sptTask.." escort_num: "..tostring(escort_num).." free_slot: "..tostring(free_slot and "true" or "false") 	)
		if squadStatus then
			squadStatus.supportGenerated = true
			-- print("create support BBB squadStatus.supportGenerated set to true for squad "..unitSupport.name)
		end

	end

	--recalculate threat level for sortie adjusted by number of escort
	-- local route_threat_OLD = draft.route.threats.ground_total + draft.route.threats.air_total
	local route_threat_OLD = draft.route.threats.ground_total + draft.route.threats.air_total
	local route_threat_recalc = 0.5
	--recalculated route threat with escort in place (0.5 == no threat)
	if sptTask == "SEAD" then
		local escort_offset = escort_num * uSupportLoadout.firepower					--* uSupportLoadout.capability--number of available SEAD to offset threats
		for k, tGround in pairs(draft.route.threats.ground) do									--iterate through route ground threats
			if tGround.offset > 0 then														--if threat can be offset by SEAD
				if escort_offset >= tGround.offset then										--some SEAD aircraft remain to offset the threat
					route_threat_recalc = escort_offset - tGround.offset							--use these SEAD aircraft to offset and ignore the therat
				else																	--no SEAD aircraft remain unassignedd
					route_threat_recalc = route_threat_recalc + tGround.level					--sum route ground threat levels
				end
			else																		--threat cannot be offset by SEAD
				route_threat_recalc = route_threat_recalc + tGround.level						--sum route ground threat levels
			end
		end

		if not draft.route.threats.ground_total_Init then
			draft.route.threats.ground_total_Init = draft.route.threats.ground_total
		end

		if route_threat_recalc < 0.5 then
			route_threat_recalc = 0.5
		end

		-- draft.route.threats.ground_total = route_threat_recalc			--recalculated total route grund threat
		draft.route.threats.ground_total = route_threat_recalc

	elseif sptTask == "Escort" then

		local escort_offset_level = uSupportLoadout.firepower		--uSupportLoadout.capability *--threat level that each fighter escort can offset
		route_threat_recalc = draft.route.threats.air_total - escort_offset_level * escort_num			--recalculated total route air threat

		if route_threat_recalc < 0.5 then
			route_threat_recalc = 0.5
		end

		draft.route.threats.air_total = route_threat_recalc

	elseif sptTask == "Escort Jammer" then
		draft.route.threats.ground_total = draft.route.threats.ground_total / 2
	end

	-- local route_threat_New = draft.route.threats.ground_total + draft.route.threats.air_total
	local route_threat_New = draft.route.threats.ground_total + draft.route.threats.air_total

	if route_threat_New ~= route_threat_OLD then

		-- local testScore = draft.priorityIni / route_threat_New
		local testScore = draft.targetPriority / route_threat_New

		local testScore_beforeCoef = testScore

		testScore = testScore * draft.scoreCoef + draft.scoreAdd

		if isDebugModeB then
			debugLog(draft.id.." AtoG SCORE_RECALC targetPriority: "..tostring(draft.targetPriority)
				.." route_threat_New: "..tostring(route_threat_New)
				.." testScore_avant_coef: "..tostring(testScore_beforeCoef)
				.." scoreCoef: "..tostring(draft.scoreCoef)
				.." scoreAdd: "..tostring(draft.scoreAdd)
				.." testScore_final: "..tostring(testScore)
				.." draft.score_avant: "..tostring(draft.score)
			)
		end

		if overideMP_B then
			if testScore > draft.score then
				draft.score = testScore
			end
		else
			draft.score = testScore
		end

	end

	--adjust sortie Time on Target
	if support_tot_from > draft.tot_from then
		draft.tot_from = support_tot_from
	end

	if support_tot_to < draft.tot_to then
		draft.tot_to = support_tot_to
	end

	--status report
	status_counter_escorts = status_counter_escorts + 1

	wi = wi + 1

	if isDebugModeB then
		debugLog(draft.id.." AtoG II_support() S19 pass B_22 draft.type: "..draft.type.." escort_num: "..tostring(escort_num)
		.." supportType: "..unitSupport.type.." Task: "..sptTask.." target_name: "..tostring(draft.target_name)  
		.." |score: "..tostring(draft.score))
	end

end

-- ============================================================================
-- REGLAGE : preference light / lourd cote SUPPORT (escortes, SEAD, ...)
-- ============================================================================
--Pourquoi: pour un meme squad et une meme tache, le PREMIER loadout qui passe tous les controles
--(portee, meteo, vitesse) prend la place (free_slot) et les suivants sont ignores. L'ordre de la liste
--decide donc du choix. Avant : standoff decroissant, puis ordre indefini (souvent light ou lourd au hasard).
--Apres : standoff decroissant, puis portee CROISSANTE -> le light est essaye en premier ; s'il est trop
--court pour la route d'escorte (route.lenght > range*2), il est refuse et le lourd est essaye ensuite.
--
--false = comportement identique a avant (seul le tri par standoff est applique)
--true  = a standoff egal, le loadout de plus petite portee est essaye en premier
SUPPORT_LOADOUT_PREFER_SHORT_RANGE = false

local function sortSupportLoadouts(loadoutList)

	table.sort(loadoutList, function(a, b)

		--1) standoff decroissant (comme avant)
		if a.standoff ~= b.standoff then
			return a.standoff > b.standoff
		end

		--2) a standoff egal : portee croissante (light avant lourd), si le reglage est actif
		if SUPPORT_LOADOUT_PREFER_SHORT_RANGE then
			local rangeA = tonumber(a.range) or 0
			local rangeB = tonumber(b.range) or 0
			if rangeA ~= rangeB then
				return rangeA < rangeB
			end
		end

		return false
	end)
end

--create additional draft sorties with support flights assigned
local wk = 1
local i_timmer02 = 0
-- local uniqueBonus = false

--rearange aléatoirement les unites pour que ne soit pas toujours les memes
shuffled = {}
for i, v in ipairs(oob_air["blue"]) do
	local pos = math.random(1, #shuffled+1)
	table.insert(shuffled, pos, v)
end
oob_air["blue"] = shuffled

shuffled = {}
for i, v in ipairs(oob_air["red"]) do
	local pos = math.random(1, #shuffled+1)
	table.insert(shuffled, pos, v)
end
oob_air["red"] = shuffled

--inversion des 2 boucles draft_sortie en premier, oob_air ensuite, pour homogeniser les chances de sortie de tous les escadrons support
for sideName, draftT in pairs(draftSorties) do
	for draft_n, draft in ipairs(draftT) do

		local isDebugModeB =
			Debug.Generator.affiche
			and string.find(Debug.Generator.chapter, "B")
			and (
				(
					Debug.Generator.SpySquad
					and Debug.Generator.SpySquad == draft.name
					and Debug.Generator.SpyTask == draft.task
				)
				or (
					not Debug.Generator.SpySquad
					and (
						Debug.Generator.SpyTask == draft.task
						or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == draft.target_name)
					)
				)
			)

		-- local uniqueBonus = false

		if isDebugModeB then
			debugLog(draft.id.." AtoG II pass B_00 target_name draftType: "..draft.type.." "..tostring(draft.target_name) .." "..tostring(draft.score))
		end

		--determine enemy side
		local enemy																						--determine enemy side (opposite of unit side)
		if sideName == "blue" then
			enemy = "red"
		else
			enemy = "blue"
		end

		-- --rearange aléatoirement les unites pour que ne soit pas toujours les memes
		-- shuffled = {}
		-- for i, v in ipairs(oob_air["blue"]) do
		-- 	local pos = math.random(1, #shuffled+1)
		-- 	table.insert(shuffled, pos, v)
		-- end
		-- oob_air["blue"] = shuffled

		-- shuffled = {}
		-- for i, v in ipairs(oob_air["red"]) do
		-- 	local pos = math.random(1, #shuffled+1)
		-- 	table.insert(shuffled, pos, v)
		-- end
		-- oob_air["red"] = shuffled

		--place en premier les unites des joueurs multi

		-- if multiPlaneSet.blue then
		-- 	for o = #oob_air["blue"], 1, -1 do
		-- 		if oob_air["blue"][o] and oob_air["blue"][o].type ==  multiPlaneSet.blue[oob_air["blue"][o].plane] 
		-- 		and oob_air["blue"][o].task ==  multiPlaneSet.blue[oob_air["blue"][o].task]  then	
		-- 			table.remove(oob_air["blue"], o)																		
		-- 		end
		-- 	end
		-- end

		-- if multiPlaneSet.blue then
		-- 	for o = 1, #oob_air["blue"] do
		-- 		local oob = oob_air["blue"][o]
		-- 		if multiPlaneSet.blue[oob.type] and oob and oob.tasks then
		-- 			for taskName, taskValue in pairs(oob.tasks) do
		-- 				if taskName == multiPlaneSet.blue.task then
		-- 					-- Décaler les éléments de la position 1 à o-1 vers la droite
		-- 					table_move(oob_air["blue"], 1, o-1, 2)
		-- 					-- Mettre l'élément trouvé en tête de la table
		-- 					oob_air["blue"][1] = oob
		-- 					-- Supprimer l'élément à sa position originale (qui a été décalée)
		-- 					table.remove(oob_air["blue"], o + 1)
		-- 					break -- Si un seul déplacement est requis, on peut quitter la boucle ici
		-- 				end
		-- 			end
		-- 		end
		-- 	end
		-- end

		-- if multiPlaneSet.red then
		-- 	for o = 1, #oob_air["red"] do
		-- 		local oob = oob_air["red"][o]
		-- 		if multiPlaneSet.red[oob.type] and oob and oob.tasks then
		-- 			for taskName, taskValue in pairs(oob.tasks) do
		-- 				if taskName == multiPlaneSet.red.task then
		-- 					-- Décaler les éléments de la position 1 à o-1 vers la droite
		-- 					table_move(oob_air["red"], 1, o-1, 2)
		-- 					-- Mettre l'élément trouvé en tête de la table
		-- 					oob_air["red"][1] = oob
		-- 					-- Supprimer l'élément à sa position originale (qui a été décalée)
		-- 					table.remove(oob_air["red"], o + 1)
		-- 					break -- Si un seul déplacement est requis, on peut quitter la boucle ici
		-- 				end
		-- 			end
		-- 		end
		-- 	end
		-- end

		-- if multiPlaneSet.blue and multiPlaneSet.blue._byType then
		-- 	for o = 1, #oob_air["blue"] do

		-- 		local oob = oob_air["blue"][o]

		-- 		if oob and oob.tasks then

		-- 			local mpType = multiPlaneSet.blue._byType[oob.type]

		-- 			if mpType then

		-- 				local foundTask = false

		-- 				for taskName in pairs(oob.tasks) do
		-- 					if mpType[taskName] then
		-- 						foundTask = true
		-- 						break
		-- 					end
		-- 				end

		-- 				if foundTask then
		-- 					table_move(oob_air["blue"], 1, o - 1, 2)
		-- 					oob_air["blue"][1] = oob
		-- 					table.remove(oob_air["blue"], o + 1)
		-- 					break
		-- 				end

		-- 			end
		-- 		end
		-- 	end
		-- end

		-- if multiPlaneSet.red and multiPlaneSet.red._byType then
		-- 	for o = 1, #oob_air["red"] do

		-- 		local oob = oob_air["red"][o]

		-- 		if oob and oob.tasks then

		-- 			local mpType = multiPlaneSet.red._byType[oob.type]

		-- 			if mpType then

		-- 				local foundTask = false

		-- 				for taskName in pairs(oob.tasks) do
		-- 					if mpType[taskName] then
		-- 						foundTask = true
		-- 						break
		-- 					end
		-- 				end

		-- 				if foundTask then
		-- 					table_move(oob_air["red"], 1, o - 1, 2)
		-- 					oob_air["red"][1] = oob
		-- 					table.remove(oob_air["red"], o + 1)
		-- 					break
		-- 				end

		-- 			end
		-- 		end
		-- 	end
		-- end

		--tag multiPlaneSet Présent pour l'avion MAIN
		-- local multiPlaneSet = draft.multiPlaneSet or {}

		local mpTask_Check = getMultiPlaneTask(sideName,draft.name, draft.type, draft.task)

		-- --TODO a voir si on ajoute un check lié au task ou pas
		-- if multiPlaneSet and mpTask_Check then
		-- 	multiPlaneSet[sideName][draft.type][draft.name].checked = true
		-- end

		--TODO a voir si on ajoute un check lié au task ou pas
		if mpTask_Check then
			local mp_Data = getMultiPlane(sideName,draft.name, draft.type)
			if mp_Data then
				mp_Data.checked = true
			end
		end

		local remain_SEAD_offset = draft.route.threats.SEAD_offset
		local remain_air_total = draft.route.threats.air_total

		-- local EMPTY = {} -- Optimisation CPU : évite de recréer une table en mémoire

		for side, units in pairs(oob_air) do

			-- Ligne combinée ultra-performante
			for unitN, unitSupport in pairs(units or EMPTY) do

				local overideMP_B = false

				--Pourquoi: donner LA raison exacte (pas une liste de possibles) par squad-escorte,
				--sans toucher à la condition existante ci-dessous ; une seule raison gardée par squad (evite le bruit)
				if not escortRejectReasons[unitSupport.name] and side == sideName then

					local reason = nil

					if unitSupport.inactive == true then
						reason = "squad inactif (config squad/campagne)"

					elseif not db_airbases[unitSupport.base] then
						reason = "base '"..tostring(unitSupport.base).."' introuvable"

					elseif db_airbases[unitSupport.base].inactive == true then
						reason = "base '"..tostring(unitSupport.base).."' inactive"

					elseif not db_airbases[unitSupport.base].x then
						reason = "base '"..tostring(unitSupport.base).."' sans coordonnées valides"

					elseif not (AcftAvail[unitSupport.name] and AcftAvail[unitSupport.name].available > 0) then
						reason = "plus aucun appareil disponible (available: "
							..tostring(AcftAvail[unitSupport.name] and AcftAvail[unitSupport.name].available or 0)..")"
					end

					if reason then
						AddEscortRejectReason(unitSupport.name, reason)
					end
				end

				if side == sideName and unitSupport.inactive ~= true and db_airbases[unitSupport.base] and db_airbases[unitSupport.base].inactive ~= true and (  (AcftAvail[unitSupport.name] and AcftAvail[unitSupport.name].available > 0))  and db_airbases[unitSupport.base].x  then	--if unit is active, its base is active and has available aircraft -- ATO_G_debug01 Fin de campagne					

					if isDebugModeB then
						debugLog(draft.id.." AtoG II pass B_02_a draft.type.: "..draft.type.." unitSupport.type: "..unitSupport.type
						.." || "..tostring(unitSupport.base).." || "..tostring(unitSupport.name)
						.." "..tostring(draft.score)
						)
					end

					--Pourquoi: la restriction "une seule tâche par recherche" (basée sur tasksCoef) a été retirée :
					--elle empêchait un squad de jamais être tenté sur sa tâche à plus faible coefficient
					--(ex: SEAD quand Escort a un coefficient plus haut), même quand taskCap lui réserve
					--encore de la place dessus -- ce qui pouvait rejeter un draft entier faute de candidat
					--jamais tenté, alors qu'un candidat existait bel et bien. taskCap (dans addFlight) gère
					--maintenant la répartition équitable au moment de la consommation ; la recherche retente
					--donc toutes les tâches actives du squad, comme avant tasksCoef.
					local tasksToTry = unitSupport.tasks

					for sptTask, task_bool in pairs(tasksToTry) do if task_bool then
						local playable_II = false
						local reserveClient = false

						if isDebugModeB then
							debugLog(draft.id.." AtoG II pass B_03 "..tostring(draft.target_name).." draft.type.: "..draft.type.." unitSupport.type.: "..unitSupport.type.." sptTask.: "..tostring(sptTask))
						end

						--****************************
						--//**START MULTIPLAYER--**//
						local mpSupportTask_Check = getMultiPlaneTask(side, unitSupport.name, unitSupport.type, sptTask)
						-- if multiPlaneSet[side] and multiPlaneSet[side][unitSupport.name] and multiPlaneSet[side][unitSupport.name][sptTask] then
						if mpSupportTask_Check then
							if not Multi.Target and draft.task ~= "SAR" and draft.task ~= "CAP" then
								Multi.Target = {}
								Multi.Target[side] = draft.target_name

								if isDebugModeB then
									debugLog(draft.id.." AtoG II pass B_04 draft.: "..draft.type.." OOBunit: "..unitSupport.type.." overideMP_B?: "..tostring(overideMP_B))
								end
							end

							if Multi.Target[side] == draft.target_name  then

								--on reserve la place pour un type d'avion prevu pour le MP
								reserveClient = true
								if unitSupport.client and sptTask ~= "Intercept" then

									draft.loadout.support = draft.loadout.support or {}
									draft.loadout.support[sptTask] = draft.loadout.support[sptTask] or true
									draft.support[sptTask] = draft.support[sptTask] or {}
									draft.support[sptTask]["escort_max"] = 4

									overideMP_B = true
								end
							end

						end
						--//**END MULTIPLAYER--**//
						--****************************

						--**cet overideMP_B donne trop d'avion
						-- if overideMP_B or (( draft.task ~= "CAP" and draft.task ~= "Intercept" )
						if (( draft.task ~= "CAP" and draft.task ~= "Intercept" )
							and (sptTask == "SEAD" or sptTask == "Escort" or sptTask == "Escort Jammer" or sptTask == "Flare Illumination" or sptTask == "Laser Illumination" or sptTask == "Strike")
							and task_bool) then

							if isDebugModeB then debugLog(draft.id.." AtoG II pass B_05  " ) end

							--get possible loadouts
							local uSupportloadouts = {}														--table to hold all loadouts for this aircraft type and task

							for loadout_name, ltable in pairs((LoadoutsList[unitSupport.type] and LoadoutsList[unitSupport.type][sptTask]) or {}) do			--iterate through all loadouts for the aircraft type and task
								ltable.name = loadout_name
								if ltable.standoff == nil then ltable.standoff = 0 end

								local countryEligible = false
								if ltable.country == nil  then
									countryEligible = true
								elseif type(ltable.country) == "string" then
									if string.lower(ltable.country) == string.lower(unitSupport.country) or string.lower(ltable.country) == "all" then
										countryEligible = true
									end

								elseif type(ltable.country) == "table" then
									for n, countryLabel in pairs(ltable.country) do
										if string.lower(countryLabel) == string.lower(unitSupport.country) or string.lower(countryLabel) == "all" then
											countryEligible = true
											break
										end
									end
								end

								if countryEligible then
									uSupportloadouts[#uSupportloadouts+1] = ltable
								end

							end

							-- trie par standoff
							--avant : table.sort(uSupportloadouts, function(a,b) return a.standoff > b.standoff end)
							sortSupportLoadouts(uSupportloadouts)

							for l = 1, #uSupportloadouts do													--iterate through all available loadouts				

								--get possible Time on Target
								local support_tot_from = 0															--earliest Time on Target for this loadout
								local support_tot_to = 0															--latest Time on target for this loadout

								if uSupportloadouts[l].day == nil then
									uSupportloadouts[l].day = true
								end

								if uSupportloadouts[l].day and uSupportloadouts[l].night then						--loadout is day and night capable
									support_tot_from = 0															--from mission start
									support_tot_to = mission_ini.mission_duration											--to mission end
								elseif uSupportloadouts[l].day then											--loadout is day capable
									if Daytime == "night-day" then
										support_tot_from = mission_ini.dawn - camp.time									--from dawn
										support_tot_to = mission_ini.mission_duration										--to mission end
									elseif Daytime == "day" then
										support_tot_from = 0														--from missiom start
										support_tot_to = mission_ini.mission_duration										--to mission end
									elseif Daytime == "day-night" then
										support_tot_from = 0														--from mission start
										support_tot_to = mission_ini.dusk - camp.time										--to dusk
									end
								elseif uSupportloadouts[l].night then											--loadout is night capable
									if Daytime == "day-night" then
										support_tot_from = mission_ini.dusk - camp.time									--from dusk
										support_tot_to = mission_ini.mission_duration										--to mission end
									elseif Daytime == "night" then
										support_tot_from = 0														--from mission start
										support_tot_to = mission_ini.mission_duration										--to mission end
									elseif Daytime == "night-day" then
										support_tot_from = 0														--from mission start
										support_tot_to = mission_ini.dawn - camp.time										--to dawn
									end
								end

								if isDebugModeB then
									debugLog(draft.id.." AtoG II pass B_06 tot_from: "..support_tot_from.." tot_to: "..support_tot_to.." overideMP_B: "..tostring(overideMP_B))
								end

								--**cet overideMP_B donne trop d'avion
								-- if (tot_from ~= 0 or tot_to ~= 0) and draft.support[sptTask] then
								local loadoutEligible = true

								if support_tot_from == 0 and support_tot_to == 0 then
									loadoutEligible = false

									if isDebugModeB then
										debugLog(draft.id.." B_REJECT TOT "..tostring(uSupportloadouts[l].name))
									end
								end

								if loadoutEligible and not draft.support[sptTask] then
									loadoutEligible = false

									if isDebugModeB then
										debugLog(draft.id.." B_REJECT support missing "..tostring(sptTask))
									end
								end

								if loadoutEligible then

									if isDebugModeB then
										debugLog(draft.id.." AtoG II pass B_7a target_name: "..tostring(draft.target_name))
									end

									if not draft or not draft.support or not draft.support[sptTask] then
										print("task: "..tostring(sptTask).." overideMP_B: "..tostring(overideMP_B).." draft.type: "..tostring(draft.type))
										flushDebugLogs()

									end

									if not draft.support[sptTask]["NbTotalSupport"] then draft.support[sptTask]["NbTotalSupport"] = 0 end
									if not draft.support[sptTask]["escort_max"] then draft.support[sptTask]["escort_max"] = 999 end

									if isDebugModeB and draft.loadout.support and draft.support  then
										debugLog(draft.id.." AtoG II pass B_10 overideMP_B: "..tostring(overideMP_B).." sptTask: "..tostring(sptTask) .." |draft.loadout.support[task]: "..tostring(draft.loadout.support[sptTask]).." draft.support[task][escort_max]: "..tostring(draft.support[sptTask]["escort_max"]).." draft.support[task][NbTotalSupport]: "..tostring(draft.support[sptTask]["NbTotalSupport"]))
									end

									i_timmer02 = i_timmer02 +1
									if overideMP_B or ((draft.loadout.support and draft.loadout.support[sptTask])
										and ( (tonumber(draft.support[sptTask]["NbTotalSupport"]) < tonumber(draft.support[sptTask]["escort_max"]) ) )) then

										if isDebugModeB then
											debugLog(draft.id.." AtoG II pass B_12 task "..sptTask.." SEAD_offset  "..tostring(draft.route.threats.SEAD_offset)

											.." |unitSupport.player: "..tostring(unitSupport.player)
											.." |unitSupport.client: "..tostring(unitSupport.client)
											.." |draft.task: "..tostring(draft.task)
											)
										end

										local support_requirement = false
										if sptTask == "SEAD" then
											if draft.route.threats.SEAD_offset > 0 then												--draft sortie has a SEAD offset requirement
												support_requirement = true
											end
											if mission_ini.strikeOnlyWithEscorte then
												support_requirement = true
											end
										elseif sptTask == "Escort" then
											if draft.route.threats.air_total > 0.5 then												--draft sortie has an air threat
												support_requirement = true
											end
											if mission_ini.strikeOnlyWithEscorte then
												support_requirement = true
											end
										elseif sptTask == "Escort Jammer" then
											if draft.route.threats.SEAD_offset > 0 or draft.route.threats.air_total > 0.5 then		--draft sortie has either a SEAD offest requirement or an air threat
												support_requirement = true
											end
											if mission_ini.strikeOnlyWithEscorte then
												support_requirement = true
											end
										elseif sptTask == "Flare Illumination" or sptTask == "Laser Illumination"then
											support_requirement = true

										elseif sptTask == "CSAR" then
											--on n'active que des support CSAR Player/Client
											if unitSupport.player or unitSupport.client then
												support_requirement = true
											else
												support_requirement = false
												overideMP_B = false
											end
										end

										if draft.task == "SAR" then
											support_requirement = false
										end

										if isDebugModeB then
											debugLog(draft.id.." AtoG II pass B_15 threats.SEAD_offset?: "..tostring(draft.route.threats.SEAD_offset)
											.." threats.air_total?: "..tostring(draft.route.threats.air_total)
											.." "..unitSupport.type.." overideMP_B: "..tostring(overideMP_B)

											.." |support_requirement: "..tostring(support_requirement)
											)
										end

										local supportEligible = support_requirement or overideMP_B

										if not supportEligible then
											if isDebugModeB then
												debugLog(draft.id.." B_SUPPORT_NOT_REQUIRED "..tostring(sptTask))
											end
										end

										if support_requirement or overideMP_B then																	--go ahead with this support task
											if isDebugModeB then
												debugLog(tostring(draft.id).." AtoG II pass B_15b support_requirement passe " )
											end

											if (uSupportloadouts[l].day and draft.loadout.day) or (uSupportloadouts[l].night and draft.loadout.night) then	--support can join package at either day or night
												TrackPlayability(unitSupport.player, "escort_tot")															--track playabilty criterium has been met
												--admet une vitesse (escort) 75% plus faible que la vitesse du Main
												if uSupportloadouts[l].vCruise < draft.loadout.vCruise then

													if isDebugModeB then
														debugLog(draft.id.." AtoG II pass B_15c unit_loadouts[l].vCruise : "..tostring(uSupportloadouts[l].vCruise).." < "..tostring(draft.loadout.vCruise).. " | %: "..tostring(uSupportloadouts[l].vCruise / draft.loadout.vCruise))
													end

													--ATTENTION, ce code descend trop bas la vitesse des bombers
													-- if (unit_loadouts[l].vCruise / draft.loadout.vCruise) * 100 >= 75 then
													-- 	draft.loadout.vCruise = unit_loadouts[l].vCruise
													-- end
												end

												if isDebugModeB then
													debugLog(draft.id.." AtoG II pass B_15d support_requirement passe UnitvCruise: "..uSupportloadouts[l].vCruise.." >=? MainvCruise "..draft.loadout.vCruise )
												end

												local tolerance = draft.loadout.vCruise * 0.10 -- 10%
												local toleranceBool = false

												if uSupportloadouts[l].vCruise + tolerance >= draft.loadout.vCruise then
													toleranceBool = true
												end

												-- if unit_loadouts[l].vCruise >= draft.loadout.vCruise or overideMP_B then
												if toleranceBool or overideMP_B then
													TrackPlayability(unitSupport.player, "escort_target")

													local debuGenTxt1480 = "\n"..(tostring(draft.id).." AtoG II pass B_15e support_requirement passe ")

													--check weather
													local weather_eligible = true
													if mission.weather["clouds"]["density"] > 8 then											--overcast clouds
														local cloud_base = mission.weather["clouds"]["base"]
														local cloud_top = mission.weather["clouds"]["base"] + mission.weather["clouds"]["thickness"]
														if db_airbases[unitSupport.base].elevation + 333 > cloud_base then							--cloud base is less than 1000 ft above airbase elevation
															if uSupportloadouts[l].adverseWeather == false then									--loadout is not adverse weather capable
																weather_eligible = false														--not eligible for this weather
															end
														else
															if draft.loadout.hCruise > cloud_base and draft.loadout.hCruise < cloud_top then	--cruise alt is in the clouds
																if uSupportloadouts[l].adverseWeather == false then								--loadout is not adverse weather capable
																	weather_eligible = false													--not eligible for this weather
																end
															elseif draft.loadout.hAttack > cloud_base and draft.loadout.hAttack < cloud_top then	--attack alt is in the clouds
																if uSupportloadouts[l].adverseWeather == false then								--loadout is not adverse weather capable
																	weather_eligible = false													--not eligible for this weather
																end
															end
														end
													end
													if mission.weather["enable_fog"] == true then												--fog
														if db_airbases[unitSupport.base].elevation < mission.weather["fog"]["thickness"] then		--base elevation in fog
															if mission.weather["fog"]["visibility"] < 5000 then									--less than 5000m visibility
																if uSupportloadouts[l].adverseWeather == false then								--loadout is not adverse weather capable
																	weather_eligible = false													--not eligible for this weather
																end
															end
														end
													end

													if isDebugModeB then
														debugLog(debuGenTxt1480.."\n"..(tostring(draft.id).." AtoG II pass B_15e support_requirement passe: weather_eligible "..tostring(weather_eligible).." overideMP_B "..tostring(overideMP_B)))
													end

													local passIsClientCondition = true

													--systeme compliqué pour privilégier les slots humain s'il y en a
													-- 1) Cas override MP + réserve client
													if reserveClient then
														passIsClientCondition = overideMP_B
														-- if isDebugModeB then
														-- 	debugLog(debuGenTxt1480.."\n"..(tostring(draft.id).." AtoG II pass B_15_f support_requirement passe: reserveClient "..tostring(reserveClient).." passIsClientCondition "..tostring(passIsClientCondition)))
														-- end
													end

													-- 2) Cas humainOnly
													if passIsClientCondition and unitSupport.humainOnly then
														passIsClientCondition = (unitSupport.player or unitSupport.client)
														-- if isDebugModeB then
														-- 	debugLog(debuGenTxt1480.."\n"..(tostring(draft.id).." AtoG II pass B_15_g support_requirement passe: humainOnly "..tostring(unitSupport.humainOnly).." passIsClientCondition "..tostring(passIsClientCondition)))
														-- end
													end

													if isDebugModeB then
														debugLog(debuGenTxt1480.."\n"..(tostring(draft.id).." AtoG II pass B_15_h support_requirement passe: final passIsClientCondition "..tostring(passIsClientCondition)))
													end

													if not weather_eligible then
														local detail = {
															adverseWeather = uSupportloadouts[l].adverseWeather
														}
														rejectStep(draft, "weatherEligible", "no_weatherEligible", detail, "BLOCK_B", SafeGetLine())
													end

			
													-- 3) Condition finale
													if weather_eligible and passIsClientCondition then												--continue of this loadout is eligible for weather

														TrackPlayability(unitSupport.player, "escort_weather")												--track playabilty criterium has been met								
														--get airbase position
														local airbasePoint = {																	--get the x-y coordinates of the airbase where the unit is located
															x = db_airbases[unitSupport.base].x,
															y = db_airbases[unitSupport.base].y,
															h = db_airbases[unitSupport.base].elevation,
														}

														local route = GetEscortRoute(airbasePoint, draft.route, sptTask, uSupportloadouts[l], unitSupport, draft)									--get the route to escort this sortie

														if isDebugModeB then
															debugLog(draft.id.." AtoG II pass B_16 weather_eligible route.lenght: "..tostring(route and route.lenght).. " <= "..tostring(uSupportloadouts[l].range * 2)
															.." (loadouts: )" ..tostring(uSupportloadouts[l].range)..") loadoutName: "..tostring(uSupportloadouts[l].name) )
														end

														if route and route.lenght <= uSupportloadouts[l].range * 2 then		--escort route lenght is within range capability of loadout

															addSupportToDraft(
																draft,
																unitSupport,
																uSupportloadouts[l],
																sptTask,
																route,
																side,
																playable_II,
																overideMP_B,
																isDebugModeB,
																remain_air_total,
																support_requirement,
																support_tot_from,
																support_tot_to,
																wk
																)--multiPlaneSet,

														else

															local details = {
																range = route and route.lenght or -1,
																maxRange = uSupportloadouts[l].range * 2,
																target = draft.target_name,
															}

															rejectStep(draft, "range", "support_no_range", details, "BLOCK_B", SafeGetLine())

															--Pourquoi: rattacher la raison au squad-escorte lui-meme (unitSupport), pas seulement
															--au draft demandeur ; une seule raison gardee par squad (evite le bruit)
															if not escortRejectReasons[unitSupport.name] then
																AddEscortRejectReason(
																	unitSupport.name,
																	"distance vers la cible ("..tostring(route and math.floor(route.lenght) or -1)
																	..") superieure au rayon d'action aller-retour du loadout '"..tostring(uSupportloadouts[l].name)
																	.."' ("..tostring(uSupportloadouts[l].range * 2)..")"
																)
															end

														end
													end
												end
											end
										end
									else
										-- print("ATO_G  Refused02 ||:if draft.loadout.support and draft.loadout.support[task] and "..debug.getinfo(1).currentline)
										-- print("    draft.type"..tostring(draft.type).."[task]?: "..tostring(task).." NbTotalSupport: "..tonumber(draft.support[task]["NbTotalSupport"]).." < "..tonumber(draft.support[task]["escort_max"]))
									end
									if i_timmer02 >= 1000  then io.write(".") i_timmer02 = 0 end
									wk = wk +1
								end
							end
						end
					end end
				end
			end
		end
	end
end

-- Tri final par `targetPriority` (ascendant), puis par `score` (descendant)
for side, sorties in pairs(draftSorties) do
    table.sort(sorties, function(a, b)
        if a.targetPriority ~= b.targetPriority then
            return a.targetPriority > b.targetPriority -- Plus grande priorité d'abord
        end
        return a.score > b.score -- Plus grand score d'abord
    end)
end

if Debug.Generator.affiche then

	debugLog("ATO Assigning Escorts (" .. status_counter_escorts.. ")")

	for sideName, drafts in pairs(draftSorties) do
		-- debuGenTxt = debuGenTxt.."\n\n\n"..( string.upper(sideName).." PART B")
		debugLog(string.upper(sideName).." PART B")

		local di = 1
		for draft_n, draft in pairs(drafts) do
			if  di < Debug.Generator.nb or draft.name == Debug.Generator.SpySquad  or draft.target_name == Debug.Generator.SpyTarget then

				debugLog(	"B N° " .. draft_n..
						-- " /support/ " ..tostring(draft.support)..
						" /Id " ..tostring(draft.id)..
						" /targetPriority/ " ..tostring(draft.targetPriority)..
						-- " /draft.priorityIni/ " ..tostring(draft.priorityIni)..
						" /Name/ " ..tostring(draft.name)..
						" /Nb/ " ..draft.number..
						" /flights/ " ..tostring(draft.flights)..
						" /Type/ "..draft.type..
						" /Name/ "..draft.name..
						" /thrtGrnd/ "..round(draft.threatsGround)..
						" /thrtA/ "..round(draft.threatsAir)..
						" /Score/ " ..round(draft.score)..
						" /NbTotSupt/ " ..tostring(draft.NbTotalSupport)..

						" /Task/ "..draft.task..
						" /Target/ "..draft.target_name..
						" /Sead_Of/ "..tostring(draft.route.threats.SEAD_offset)..
						" /main_overideMP/ " ..tostring(draft.main_overideMP)..
						" /loadout/ "..tostring(draft.loadout.loadout_name)
						)

				di = di +1
				for planeTask_N, supports in pairs(draft.support) do
					for taskName, support in pairs(supports) do

						if type(support) == "table" and support.target_name and support.loadout then

							debugLog(	"    ---> Nsupport " ..planeTask_N.." ".. taskName..
									" /Id/ " ..tostring(support.id)..
									" /Nb/ " ..support.number..
									" /escort_max/ " ..tostring(supports.escort_max)..
									" /SupportName/ "..support.name..
									" /Type/ "..support.type..
									" /Name/ "..support.name..
									" /Task/ "..support.task..
									" /NbTotSupt/ " ..tostring(support.NbTotalSupport)..
									" /Target/ "..support.target_name..
									" /overideMP_B/ "..tostring(support.overideMP_B)..
									" /loadout/ "..tostring(support.loadout.loadout_name)
									)
						end
					end
				end
				-- debuGenTxt = debuGenTxt.."\n\n"
			end
		end
	end

	-- debuGenTxt = debuGenTxt.."\n"

end

if Debug.Generator and Debug.debug then
	flushDebugLogs()
end

local function rejectDraft(draft, sujet, cause, line, reasonCode)
	local tabRejected = {}
	tabRejected["sujet"] = sujet
	tabRejected["cause"] = cause
	tabRejected["ligne"] = line --SafeGetLine()

	table.insert(draft["rejected"], tabRejected)

	--Pourquoi: rejectDraft (ici, dans createATO_table) et rejectStep/bestReject (dans processEligibleLoadout)
	--sont deux systèmes de suivi séparés qui ne communiquaient pas entre eux : un squad pouvait traverser
	--tout le pipeline avec succès puis être rejeté ICI (menace trop importante, firepower insuffisant, etc.)
	--sans que ça remonte nulle part dans le rapport final. On les raccroche au même wagon.
	--reasonCode (optionnel) : code court exploitable par ExplainPlayerRejectionSP (ATO_Generator_A_Debug.lua)
	--pour donner un message joueur propre, plutot que le texte de debug brut "sujet".
	if draft.name and not escortRejectReasons[draft.name] then
		AddEscortRejectReason(draft.name, tostring(sujet), reasonCode, cause)
	end

end

local function validSupportIterator(arg_supportTable, arg_dispoTmp)

	local result = {}

	for supportTask, supports in pairs(arg_supportTable) do

		if type(supports) == "table" then

			for supportName, support in pairs(supports) do

				if type(support) == "table"
				and support.name
				and support.number
				and arg_dispoTmp[support.name]
				and arg_dispoTmp[support.name].unassigned ~= nil then

					result[#result + 1] = {
						supportTask = supportTask,
						supportName = supportName,
						support = support,
					}
				end
			end
		end
	end

	return result
end

--table to store the final ATO
ATO = {
	blue = {},
	red = {}
}

--assign draft sorties to ATO and build packages/flights
local function createATO_table(draftPriority)
	for side, drafts in pairs(draftPriority) do
		if drafts and drafts ~= nil then
			for draftN, draft in pairs(drafts) do																					--iterate through all draft sorties beginning with the highest scored			

				if MemTick then MemTick("C draft") end
				
				local override_MP_C = false

				-- if draft.overideMP_B and draft.main_overideMP then
				if draft.overideMP_B then
					override_MP_C = true
				end

				local isDebugModeC =
					
					Debug.Generator.affiche
					and string.find(Debug.Generator.chapter, "C")
					and (
						(
							Debug.Generator.SpySquad
							and Debug.Generator.SpySquad == draft.name
							and Debug.Generator.SpyTask == draft.task
						)
						or (
							not Debug.Generator.SpySquad
							and (
								Debug.Generator.SpyTask == draft.task
								or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == draft.target_name)
							)
						)
					)

				if isDebugModeC then
					debugLog(draft.id.." AtoG passe C_00 "..draft.type.." "..draft.task.." "..draft.score)
				end

				--diminue le minscore en fonction du nombre de tentative de generation de mission
				--evite un blocage de generation
				if draft.loadout.minscore and MissionInstance >= 2 then
					draft.loadout.minscore = draft.loadout.minscore / ((MissionInstance )/10 +1)
				end

				--Pourquoi: si les escortes demandées sont là, en quantité demandée, on descend le minscore
				--pour autoriser la création du flight malgré une menace élevée. Reglage: ESCORT_MINSCORE_DISCOUNT (en tête de fichier).
				--Version un-seul-package : additionne la couverture sur toutes les tâches de support du draft
				--(Escort, SEAD, Escort Jammer, ...), pas seulement une.
				if draft.loadout.minscore and draft.support then

					local totalRequested = 0
					local totalAssigned = 0

					for sptTaskName, supportData in pairs(draft.support) do
						if type(supportData) == "table" and supportData["escort_max"] and supportData["escort_max"] > 0 then
							totalRequested = totalRequested + supportData["escort_max"]
							totalAssigned = totalAssigned + (supportData["NbTotalSupport"] or 0)
						end
					end

					if totalRequested > 0 then

						local escortCoverage = math.min(1, totalAssigned / totalRequested)

						draft.loadout.minscore = draft.loadout.minscore * (1 - ESCORT_MINSCORE_DISCOUNT * escortCoverage)

						if isDebugModeC then
							debugLog(draft.id.." AtoG passe C_00b escort coverage: "..tostring(totalAssigned).."/"..tostring(totalRequested)
								.." ("..tostring(math.floor(escortCoverage * 100)).."%) minscore ajusté: "..tostring(draft.loadout.minscore))
						end
					end
				end

				if draft.loadout.minscore == nil or draft.score >= draft.loadout.minscore then					--draft sortie has no minimum score requirement or minimum score requirement is satisified		

					-- if draft.multipack > 0 then												--target does not have a requirment for a specific number of packages, or still needs more packages		
					if multipackByTargetName[draft.target_name]["nbPack"] > 0 then

						if draft.target.firepower.max > 0 and draft.target.firepower.max >= draft.target.firepower.min then	--the target of this draft sortie must have a need for firepower above the minimum firepower threshold	
							local available_Main = AcftAvail[draft.name].unassigned											--shortcut for available aircraft for this draft sortie					

							--Pourquoi: available_Main ne reflétait que le pool GLOBAL du squad, jamais le cap PAR TACHE
							--(taskCap) -- résultat: un squad pouvait être accepté pour bien plus de packages "Strike"
							--que sa part réellement allouée, tant que le pool global (partagé avec CAP/Escort/...)
							--n'était pas totalement à sec. On clampe donc ici, AVANT toute décision d'accepter le
							--draft, pas seulement au moment de l'assignation réelle dans addFlight.
							if AcftAvail[draft.name].taskCap and AcftAvail[draft.name].taskCap[draft.task] ~= nil then

								local usedForTask = (AcftAvail[draft.name].taskUsed and AcftAvail[draft.name].taskUsed[draft.task]) or 0
								local capRemaining = AcftAvail[draft.name].taskCap[draft.task] - usedForTask

								if capRemaining < available_Main then
									available_Main = capRemaining
								end
							end

							local request_Main_Nb = draft.number -- copie locale de travail pour éviter de modifier le draft original et provoquer des effets de bord entre validations

							local passPackmax_C
							if draft.target.firepower and draft.target.firepower.packmax and draft.target.firepower.packmax > 1 then
								if available_Main >= draft.number then
									passPackmax_C = true
								end
							end

							--enough aircraft are available to satisfy minimum firepower requirement for target
							-- if (available * draft.loadout.firepower >= draft.target.firepower.min and draft.number * draft.loadout.firepower >= draft.target.firepower.min) or passPackmax_C then				
							local firepowerPackOK = (available_Main * draft.loadout.firepower >= draft.target.firepower.min ) or passPackmax_C

							--mode degrade : a partir de la 5e tentative infructueuse, on ignore ce manque de
							--firepower pour le draft du joueur plutot que de ne rien lui proposer (cf
							--RelaxGeneration, ATO_Generator_A_Debug.lua). available_Main > 0 : il reste au
							--moins un avion, on ne fabrique pas d'avion a partir de rien.
							if not firepowerPackOK and RelaxGeneration and isPlayerRelatedDraft(draft) and available_Main > 0 then

								recordRelaxedLimit(draft.name, "firepower", {
									required = draft.target.firepower.min,
									maxPossible = math.floor(available_Main * draft.loadout.firepower),
									target = draft.target_name,
									loadout = draft.loadout.name,
								})

								firepowerPackOK = true
							end

							if firepowerPackOK then

								--if the target has a minimum package number requirement, sufficient aircraft are available from this unit to satisfy it	
								local firepowerPackMultiOK =
									draft.target.firepower.packmin == nil
									or available_Main * draft.loadout.firepower >= (draft.target.firepower.packmin - 1) * draft.target.firepower.max + draft.target.firepower.min

								if not firepowerPackMultiOK and RelaxGeneration and isPlayerRelatedDraft(draft) and available_Main > 0 then

									recordRelaxedLimit(draft.name, "firepower", {
										required = (draft.target.firepower.packmin - 1) * draft.target.firepower.max + draft.target.firepower.min,
										maxPossible = math.floor(available_Main * draft.loadout.firepower),
										target = draft.target_name,
										loadout = draft.loadout.name,
									})

									firepowerPackMultiOK = true
								end

								if firepowerPackMultiOK then				

									local limitMP = true   --TODO a revoir, semble inutile

									local mpTask_Check = getMultiPlaneTask(side, draft.name, draft.type, draft.task)

									if isDebugModeC and mpTask_Check then
										debugLog(draft.id.." AtoG passe C_00_b  ".." "..draft.type
											.." available: "..tostring(available_Main)
											.." < NbPlane? ".. tostring(multiPlaneSet[side][draft.type][draft.name].NbPlane)
											.." main_overideMP?: "..tostring(draft.main_overideMP)
											.." overideMP_B?: "..tostring(draft.overideMP_B))
									end

									if (draft.flights == nil or draft.number <= available_Main or draft.main_overideMP or passPackmax_C) and limitMP then											--for targets with station time (multiple flights), continue only if sufficient aircraft are availabe. Additional lower scored sorties with less airctaft required will come later 

										if request_Main_Nb > available_Main and not draft.main_overideMP then

											request_Main_Nb = available_Main

											if isDebugModeC then
												debugLog(draft.id.." AtoG passe C_00_c requestedNumber "..tostring(request_Main_Nb))
											end

										end

										--check if there are enough supports available if supports are required		
										local support_available = true
										local need = {}																														--collect the total number of aircraft needed from each unit to complete the package
										need[draft.name] = request_Main_Nb
										local avail = {}																													--collect the maximal number of available aircraft from this unit (biggest number of all tasks)
										avail[draft.name] = AcftAvail[draft.name].unassigned

										--en fonction du learning des missions passé, interdit une mission si les task support ne sont pas present

										local tempInfo = " AtoG NbTotPlanePerTask CALCUL"
										local draft_availability = DeepCopy(AcftAvail)
										if camp.newTaskPerTarget then
											for tableTargetName, targetTask in pairs(camp.newTaskPerTarget) do
												if tableTargetName == draft.target_name and targetTask.tasks then

													for taskLearning, value in pairs(targetTask.tasks) do

														local nbTotPlanePerTask = 0

														for supportTask, supportPart in pairs(draft.support) do

															if supportTask == taskLearning then
																--avant d'interdire, on regarde si un squad possede la capacité du task
																local taskRequireInSide
																for squadN, squad in pairs(oob_air[side]) do
																	if not squad.inactive then
																		for task, taskValue in pairs(squad.tasks) do
																			if taskValue and task == taskLearning then
																				taskRequireInSide = true
																				break
																			end

																		end
																	end
																	if taskRequireInSide then break end
																end

																if taskRequireInSide and type(supportPart) == "table" then
																	for _plane, support in pairs(supportPart) do

																		if type(support) == "table" and draft_availability[support.name] then

																			if support.overideMP_B then
																				nbTotPlanePerTask = 9999
																			else

																				--enleve le nombre de plane du main si le meme type de plane est compté pour le support
																				tempInfo = tempInfo .."\n"..tostring(draft.name).." ==? "..tostring(support.name)
																				if draft.name == support.name then
																					draft_availability[support.name].unassigned = draft_availability[support.name].unassigned - draft.number
																					tempInfo = tempInfo .."\n AtoG NbTotPlanePerTask AA "..supportTask.." ".._plane.." "..support.name.." Need "..draft.number.." Dispo: "..draft_availability[support.name].unassigned
																				end

																				draft_availability[support.name].unassigned = draft_availability[support.name].unassigned - support.number

																				tempInfo = tempInfo .."\n AtoG NbTotPlanePerTask BB "..supportTask.." ".._plane.." "..support.name.." Need "..support.number.." Dispo: "..draft_availability[support.name].unassigned

																				if draft_availability[support.name].unassigned >= 0 then
																					nbTotPlanePerTask = nbTotPlanePerTask + support.number

																					tempInfo = tempInfo .."\nAtoG NbTotPlanePerTask CC "..supportTask.." NbTotPlanePerTask: "..nbTotPlanePerTask
																				end
																			end
																		end
																	end
																end
																if taskRequireInSide and nbTotPlanePerTask < 2 and not draft.overideMP_B then
																	support_available = false

																	tempInfo = tempInfo .."\nAtoG NbTotPlanePerTask REJETE DD "

																	local tabRejected = {}
																	tabRejected["sujet"]  = draft.id.." "..supportTask.." newTaskPerTarget  AVION TOTAL SUPPORT INSUFFISANT NbTotPlanePerTask <= 0 "
																	tabRejected["cause"] = { [1] = nbTotPlanePerTask, [2] = "newTaskPerTarget", }
																	-- tabRejected["ligne"]  = debug.getinfo(1).currentline
																	tabRejected["ligne"]  = SafeGetLine()
																	table.insert(draft["rejected"], tabRejected)
																end

															end

														end
													end
												end
											end
										end

										if isDebugModeC then
											debugLog(draft.id.." "..tempInfo)
										end

										--TODO bizarre, il s agit du nb d avion du main, pas du support
										for unitname,_ in pairs(need) do
												if need[unitname] > avail[unitname] then																						--more aircraft are needed from this unit across all package tasks than are available
												support_available = false																									--not enough support available
												local tabRejected = {}
												tabRejected["sujet"]  = draft.id.." type: "..draft.type.." AVION SUPPORT?Main? INSUFFISANT()support_available if need[unitname] > avail[unitname]"
												tabRejected["cause"] = { tostring(need[unitname]), tostring(avail[unitname]) }
												tabRejected["ligne"]  = SafeGetLine()
												table.insert(draft["rejected"], tabRejected)
											end
										end

										--[[ debut du strikeOnlyWithEscorte pur]]--

										-- ATO_G_adjustment01 escort mandatory or not
										-- regarde uniquement pour les bombardiers necessitant une escorte

										if mission_ini.strikeOnlyWithEscorte and not draft.loadout.self_escort then
											if (db_loadouts[draft.type]["Anti-ship Strike"] or db_loadouts[draft.type]["Strike"])  then
												-- local break_loop = false
												for squadN, squad in pairs(oob_air[side]) do

													if isDebugModeC then
														debugLog(draft.id.." ".." AtoG III passe SWE _01 "..draft.type.." "..squad.type)
													end

													if squad.tasks then
														if draft.main_overideMP or ((squad.tasks["Anti-ship Strike"]  or squad.tasks["Strike"] ) and squad.type == draft.type) then
															local needSupport = {}																														--collect the total number of aircraft needed from each unit to complete the package																							--number of main body aircraft 
															local availSupport = {}																													--collect the maximal number of available aircraft from this unit (biggest number of all tasks)

															if not needSupport[draft.name] then needSupport[draft.name] = 0 end
															if not availSupport[draft.name] then availSupport[draft.name] = 0 end
															
															-- needSupport[draft.name] = request_Main_Nb

															--TODO comment ça marche? ça a l'air inutile....
															availSupport[draft.name] =  AcftAvail[draft.name].unassigned

															for _p,_support in pairs(draft.support) do																							--iterate through support in draft sortie	
																if 	type(_support) == "table" then
																	for _a,support in pairs(_support) do
																		if 	type(support) == "table" then

																			if not needSupport[support.name] then needSupport[support.name] = 0 end
																			if not availSupport[support.name] then availSupport[support.name] = 0 end

																			needSupport[support.name] =  needSupport[support.name] + support.number																	--add number of support aircraft from same unit
																			availSupport[support.name] =  AcftAvail[support.name].unassigned

																		end
																	end
																end
															end

															-- --TODO encore utile ça?												
															-- for Sname,_ in pairs(needSupport) do
															-- 	if needSupport[Sname] - (needSupport[Sname] * 0.25)  > availSupport[Sname] then

															-- 		support_available = false																									--not enough support available

															-- 		local sujet = draft.id.." BOMBARDIER NECESSITANT ESCORTE()support_available if needSupport[Sname] - (needSupport[Sname] * 0.15) > availSupport[Sname]"
															-- 		local cause = { [1] =  needSupport[Sname] - (needSupport[Sname] * 0.25), [2] = availSupport[Sname], }

															-- 		rejectDraft(draft, sujet, cause, SafeGetLine())
															-- 	end
															-- end
														end
													end
												end
											end
										end

										--****************************************
										--[[ debut du strikeOnlyWithEscorte pur]]--

										-- s il n y a qu un avion d escorte, on bache la mission
										--obliger de regarder la demande total du package, par rapport aux existants

										local escortDiagnostic = {
												rejected = {},
												accepted = {},
											}

										local dispoTmp = DeepCopy(AcftAvail)

										--enleve deja l effectif du main (il peut y avoir 4 F18 strike et 2f18 sead ou escorte)
										-- dispoTmp[draft.name].unassigned = dispoTmp[draft.name].unassigned - draft.number
										dispoTmp[draft.name].unassigned = dispoTmp[draft.name].unassigned - request_Main_Nb

										for _, supportData in pairs(validSupportIterator(draft.support, dispoTmp)) do

											local supportTask = supportData.supportTask
											local supportName = supportData.supportName
											local support = supportData.support

											if support.number == nil or not support.name or not dispoTmp[support.name] or dispoTmp[support.name].unassigned == nil then
												if isDebugModeC then
													debugLog(draft.id.." AtoG bugA1 supportTask|"..supportTask.."|supportName:|"..tostring(supportName).."|"..tostring(support.name).." no unassigned "..tostring(support.number))
												end
											end

											--si c'est un task d'une demande MP, on chunte la restrition plus loin
											--TODO pourquoi le coef est plus important sur d'autre élément que lorsqu'on demande notre target?
											local MPOverride_C = false
											if multiPlaneSet[side] and multiPlaneSet[side][draft.name] then
												MPOverride_C = true
											end

											-- if passPackmax then

											-- end

											if support.support_requirement and mission_ini.strikeOnlyWithEscorte and 
											(support.number >= 2 and dispoTmp[support.name].unassigned < 2 and draft.task ~= supportTask) 
											and not MPOverride_C and not passPackmax_C
											and supportTask ~= "Escort Jammer"
											 then

												local txt_nb = nil
												if dispoTmp[support.name].unassigned <= 0 then
													txt_nb = " 0 "
												else
													txt_nb = " single "
												end

												if isDebugModeC then
													debugLog(draft.id.." AtoG passe C_00_h  we don't accept a "..txt_nb.." aircraft as escort supportTask "..supportTask.." draft.task "..tostring(draft.task))
												end

												escortDiagnostic.rejected[#escortDiagnostic.rejected + 1] =
													support.name
													.." task:"..tostring(supportTask)
													.." need:"..tostring(support.number)
													.." dispo:"..tostring(dispoTmp[support.name].unassigned)

												support_available = false																									--not enough support available

												local sujet = support.id.." type: "..support.type.." we don't accept a "..txt_nb.." aircraft as escort "..supportName
												local cause = { "support.number: ",support.number, "unassigned:" , tostring(dispoTmp[support.name].unassigned), " available: ", tostring(dispoTmp[support.name].aircraft_available), "supportName: ", tostring(supportName), " task: ", tostring(draft.task) , " supportTask: ", tostring(supportTask) }

												-- rejectDraft(draft, sujet, cause)
												rejectDraft(draft, sujet, cause, SafeGetLine())
												

											else
												escortDiagnostic.accepted[#escortDiagnostic.accepted + 1] =
													support.name
													.." task:"..tostring(supportTask)
													.." assigned:"..tostring(support.number)

												dispoTmp[support.name].unassigned = dispoTmp[support.name].unassigned - support.number
											end

										end
										

										local function validateEscortAvailability()

											if isDebugModeC then
												debugLog(draft.id.." AtoG passe C_01_a strikeOnlyWithEscorte number "..tostring(draft.number))
											end

											for supportTask,_support in pairs(draft.support) do

												if support_available and type(_support) == "table" then

													for supportUnitType, support in pairs(_support) do

														if supportUnitType ~= "escort_max_A_" and supportUnitType ~= "NbTotalSupport" and type(support) == "table" then

															if support.name and support.number > AcftAvail[support.name].unassigned then

																support_available = false

																local sujet = support.id .." type: "
																	..support.type .." (strikeOnlyWithEscorte) support.number > AcftAvail"

																local cause = {
																	[1] = support.number,
																	[2] = AcftAvail[support.name].unassigned,
																}

																rejectDraft(draft, sujet, cause, SafeGetLine())
																
																local details = {
																	aircraft_need = support.number or -1,
																	aircraft_disponible = AcftAvail[support.name].unassigned,
																}

																rejectStep(draft, "support", "support_no_aircraft", details, "BLOCK_C", SafeGetLine())
															end
														end
													end
												end
											end
										end

										local function validateMandatorySupports()

											if not support_available or not draft.loadout.support then
												return
											end

											for loadoutNeedTask, loadoutNeedTaskBool in pairs(draft.loadout.support) do

												if loadoutNeedTaskBool then

													local foundOnePlane = false

													if draft.support[loadoutNeedTask] then

														for planeSupport, support in pairs(draft.support[loadoutNeedTask]) do

															if planeSupport ~= "NbTotalSupport" and planeSupport ~= "escort_max"
															and type(support) == "table" and support.name then

																foundOnePlane = true
																break
															end
														end
													end

													if not foundOnePlane then

														support_available = false

														local sujet =
															draft.id
															.." type: any SUPPORT "
															..tostring(loadoutNeedTask)

														local cause = {
															[1] = tostring(loadoutNeedTask),
														}

														rejectDraft(draft, sujet, cause, SafeGetLine())

														local details = {
															loadoutNeedTask = loadoutNeedTask
														}

														rejectStep(draft, "support", "any_SUPPORT", details, "BLOCK_C", SafeGetLine())

														return
													end
												end
											end
										end

										local function validateSupportRemainingAircraft()

											if not support_available then
												return
											end

											for _,_support in pairs(draft.support) do

												if type(_support) == "table" then

													for _,support in pairs(_support) do

														if type(support) == "table" then

															if AcftAvail[support.name].unassigned <= 0 and not passPackmax_C then

																support_available = false

																local sujet =
																	draft.id
																	.." type: "
																	..support.type
																	.." SUPPORT aircraft <= 0"
																local cause = {
																	[1] = AcftAvail[support.name].unassigned,
																}
																rejectDraft(draft, sujet, cause, SafeGetLine())

																local details = {
																	aircraft_disponible = AcftAvail[support.name].unassigned
																}
																rejectStep(draft, "support", "support_no_aircraft", details, "BLOCK_C", SafeGetLine())

																return
															end
														end
													end
												end
											end
										end

										if support_available and not draft.main_overideMP and not passPackmax_C and mission_ini.strikeOnlyWithEscorte then

											validateEscortAvailability()

											if support_available then

												local support_available_before = support_available

												validateMandatorySupports()

											end

											if support_available then
												validateSupportRemainingAircraft()
											end
										end

										if isDebugModeC then
											debugLog(draft.id.." AtoG passe C_02b serviceable: "
												..tostring(AcftAvail[draft.name].serviceable)
												.." |available: "..tostring(AcftAvail[draft.name].available)
												.." >? "..tostring(AcftAvail[draft.name].available / denom_NeDonnePasTOUT))
										end

										-- interdit aux possible avion d'escorte de tout donner dans CAP ou Intercept

										if not override_MP_C and (draft.task == "CAP" or draft.task == "Intercept" ) then

											for n_squad, squad in pairs(oob_air[side]) do
												if squad.type == draft.type and squad.name == draft.name and ((squad.tasks["Escort"] and squad.tasks["Escort"] == true)
												or  (squad.tasks["SEAD"] and squad.tasks["SEAD"] == true) or  (squad.tasks["Strike"] and squad.tasks["Strike"] == true)  )
												then

													local test_Aircraftnumber = DeepCopy(draft.number)
													local needeMindAircraft = false

													if (AcftAvail[draft.name].unassigned - test_Aircraftnumber) >= (AcftAvail[draft.name].ready / 2) then
														-- test_Aircraftnumber = test_Aircraftnumber -2
														needeMindAircraft = true

														if isDebugModeC then
															debuGenTxt = debuGenTxt.."\n".." AtoG passe C_03_0a unassigned: "..AcftAvail[draft.name].unassigned.." - "..test_Aircraftnumber.." ready: "..AcftAvail[draft.name].ready .." /2"
															debuGenTxt = debuGenTxt.."\n".." AtoG passe C_03_0b result: "..(AcftAvail[draft.name].unassigned - test_Aircraftnumber).." <= "..(AcftAvail[draft.name].ready / 2)
														end
													elseif AcftAvail[draft.name].unassigned  > 0 then
														test_Aircraftnumber = math.floor(AcftAvail[draft.name].ready / 2)
														needeMindAircraft = true

													elseif AcftAvail[draft.name].unassigned  <= 0 then
														needeMindAircraft = false
													end

													-- draft.number = test_Aircraftnumber
													request_Main_Nb = test_Aircraftnumber

													if not needeMindAircraft then
														support_available = false

														if isDebugModeC then
															debuGenTxt = debuGenTxt.."\n"..(tostring(draft.id).." AtoG passe C_03  "..squad.type.." "..draft.task)
														end

														local tabRejected = {}
														tabRejected["sujet"]  = draft.id.." NE DONNE PAS TOUT en CAP ou Intercept ()support_available if AcftAvail[draft.name].unassigned - draft.number <= AcftAvail[draft.name].serviceable/3"
														tabRejected["cause"] = { " unassigned - draft.number: ", tostring(AcftAvail[draft.name].unassigned - draft.number), "serviceable/ denom_NeDonnePasTOUT: ", tostring(AcftAvail[draft.name].serviceable/ denom_NeDonnePasTOUT) }
														tabRejected["ligne"]  = SafeGetLine()
														table.insert(draft["rejected"], tabRejected)

													end
												end
											end
										end

										if isDebugModeC then
											debugLog(draft.id.." AtoG passe C_04  support_available "..tostring(support_available).." MPOverride_C: "..tostring(override_MP_C))
										end

										--add new package to ATO
										-- if support_available and draft.number > 0 then																		--continue if no support is required or enough support is available to create package
										if support_available and request_Main_Nb > 0 then

											local pack_n = #ATO[side]

											ATO[side][pack_n + 1] = {
												["main"] = {},																			--package main body
												["Escort"] = {},																		--Fighter escort
												["SEAD"] = {},																			--SEAD escort
												["Escort Jammer"] = {},																	--jammer escort
												["Flare Illumination"] = {},															--illumination flare
												["Laser Illumination"] = {},															--laser illumination
												["Strike"] = {},
												["Anti-ship Strike"] = {},
											}

											-- debugLog(draft.id.." AtoG passe C_04b Task: "..tostring(draft.task).." overideMP_B: "..tostring(draft.overideMP_B).." override_MP_C: "..tostring(override_MP_C).." draft.main_overideMP?: "..tostring(draft.main_overideMP) )
											if draft.main_overideMP and draft.task == "CSAR" then
												ATO[side][pack_n + 1]["CSAR"] = {}
												-- debugLog(draft.id.." AtoG passe C_04c")
											end

											pack_n = pack_n + 1

											--********************************************************************************************
											--********************************************************************************************
											--********************************AddFlight**********************************************
											--********************************************************************************************
											--********************************************************************************************

											--add flights of 1, 2 or 4 aircraft to package
											local function addFlight(arg_Assign, arg_Role, arg_Entry)

												if isDebugModeC then
													debugLog(draft.id.." AtoG passe C_10a |||BEFORE insert/create ATO table|||  _A_ arg_Assign: " ..tostring(arg_Assign).." \r\n _E_ arg_Role: "..tostring(arg_Role).." \r\n arg_Entry.task: "..tostring(arg_Entry.task))
												end

												local assigned
												while arg_Assign > 0 do																		--loop as long as there are aircraft to assign
													assigned = nil -- reset obligatoire à chaque itération sinon une ancienne valeur peut survivre et provoquer des break ou tailles de flights incohérents

													local debugA = ""
													local debugE = " _B_ arg_Entry.main_overideMP "..tostring(arg_Entry.main_overideMP)

													--for multiple flights with station time (CAP, AWACS, Tanker etc.)
													if arg_Entry.flights then
														local flightsize = math.ceil(draft.target.firepower.max / draft.loadout.firepower)	--how many aircraft should be in each flight
														debugA = "assign: "..arg_Assign.." >=? flightsize: "..flightsize
														if arg_Assign >= flightsize then													--if there are more aircraft left to assign than the size of one flight
															assigned = flightsize														--assign one full flight
															debugA = debugA .." ||if assign >= flightsize: assigned: "..assigned
														else																			--if there are less aircraft left to assign than size of one flight
															assigned = arg_Assign
															debugA = debugA .." ||else assigned: "..assigned												--assign whatever is left
														end

														if arg_Entry.task == "CAP" then
															if assigned < 2 then
																assigned = 2
															end
														else
															assigned = 1
														end

														arg_Entry.flights = arg_Entry.flights - 1												--one less flight to assign

														debugA = debugA .." ||result entry.flights: "..arg_Entry.flights

													elseif arg_Entry.task == "Escort Jammer" or arg_Entry.task == "Flare Illumination" or arg_Entry.task == "Laser Illumination" then		--for tasks with single aircraft
														assigned = 1																	--assign one aircraft per flight	
													elseif arg_Entry.task == "Transport" then
														-- local mpTask_Check_t = getMultiPlaneTask(side, draft.name, draft.type, arg_Entry.task)
														
														-- if multiPlaneSet and multiPlaneSet[side] and multiPlaneSet[side][draft.type]  and multiPlaneSet[side][draft.name][arg_Entry.task] then
														if mpTask_Check then
															assigned = arg_Assign
														else
															assigned = 1
														end

													elseif arg_Entry.task == "Intercept" then
														if arg_Assign >= 4 then																--if more than 2 aircraft are to be assigned
															assigned = 4																--assign flight of 2 aircaft
														-- if assign >= 2 then																--if more than 2 aircraft are to be assigned
														-- 	assigned = 2
														else
															assigned = 2																--else assign flight of 1 aicraft
														end
													--TODO revoir ça, pourquoi etre obligé de faire cela alors que ça devrait marcher comme les autres AWACS, pas seulement les S-3B et Hawkey?
													-- elseif arg_Entry.task == "AWACS" or arg_Entry.task == "Refueling" or arg_Entry.task == "AFAC" or arg_Entry.task == "Transport" then	--for bombers
													-- 	assigned = 1	
													-- elseif (entry.type == "S-3B" or entry.type == "F-117A" or entry.type == "B-1B" or entry.type == "B-52H" or entry.type == "Tu-22M3" or entry.type == "Tu-95MS" or entry.type == "Tu-142" or entry.type == "Tu-160" or entry.type == "MiG-25RBT")
													-- and entry.task ~= "Runway Attack" then	--for bombers	
													elseif (Data_divers[arg_Entry.type] and Data_divers[arg_Entry.type].flyingAlone) and arg_Entry.task ~= "Runway Attack" then	--for bombers
														assigned = 1																	--assigne one aircraft per flight
													elseif arg_Entry.task == "Reconnaissance" then											--for recon
														if arg_Assign == 1 then																--if there is one aircraft left to assign
															assigned = 1																--assigne one aircraft per flight
														elseif arg_Assign >= 4 then															--if more than 4 aircraft are to be assigned
															assigned = 4																--assign flight of 4 aircaft
														elseif arg_Assign == 3 then															--if more than 3 aircraft are to be assigned
															assigned = 3																--assign flight of 3 aircaft
														else
															assigned = 2																--else assign flight of 2 aicraft
														end
													elseif (arg_Entry.task == "SAR" or arg_Entry.task == "CSAR") and not arg_Entry.main_overideMP then											--for recon
														debugE = debugE.." _C_ AtoG SAR/CSAR assigned 1, override_MP_C: "..arg_Entry.target_name
														assigned = 1
													else																			--for everything else
														debugE = debugE .. " _D_ else BEFORE assigned: if assigned and assign == 1? "..arg_Assign

														if assigned and arg_Assign == 1 then												--if there is one aircraft left to assign and there was already a previous flight assigned, stop assigning (do not add leftover single-ships)
															break
														elseif arg_Assign >= 4 then															--if more than 4 aircraft are to be assigned
															assigned = 4																--assign flight of 4 aircaft
															debugE = debugE .." _E_ || elseif assign >= 4 then"
															else
															assigned = arg_Assign															--else assign flight size of what is left
														end
														debugE = debugE .. " _F_ || elseAFTER assigned: "..assigned
													end

													if arg_Assign >= 4 then															--if more than 4 aircraft are to be assigned
														assigned = 4																--assign flight of 4 aircaft
													-- else
													-- 	assigned = arg_Assign															--else assign flight size of what is left
													end

													--ATTENTION, le code plus bas est débile, et crée des flights de 6 (par exemple)
													-- if arg_Entry.main_overideMP then
													-- 	if multiPlaneSet[side][draft.type][draft.task] then
													-- 		assigned = arg_Entry.number
													-- 	end
													-- end

													if isDebugModeC then
														debugLog(draft.id.." AtoG passe C_11 |||BEFORE insert/create ATO table|||  _A_" ..debugA.." \r\n _E_ "..debugE.." \r\n assigned "..assigned)
													end

													local flight = {																	--build ATO flight entry
														name = arg_Entry.name,
														playable = arg_Entry.playable,
														type = arg_Entry.type,
														modification = arg_Entry.modification,
														callsign = arg_Entry.callsign,
														callsignId = arg_Entry.callsignId,
														helicopter = arg_Entry.helicopter,
														number = assigned,																--number of aircraft in flight
														country = arg_Entry.country,
														livery = arg_Entry.livery,
														sidenumber = arg_Entry.sidenumber,
														liveryModex = arg_Entry.liveryModex,
														base = arg_Entry.base,
														airdromeId = arg_Entry.airdromeId,
														parking_id = arg_Entry.parking_id,
														skill = arg_Entry.skill,
														task = arg_Entry.task,
														loadout = arg_Entry.loadout,
														route = {},																		--route is a table and connot be copied as a whole
														target = DeepCopy(arg_Entry.target),
														target_name = arg_Entry.target_name,
														firepower = assigned * arg_Entry.loadout.firepower,
														tot_from = arg_Entry.tot_from,
														tot_to = arg_Entry.tot_to,
														id = arg_Entry.id,
														score= draft.score,
														threatsGround = draft.threatsGround,
														threatsAir = draft.threatsAir,
													}
													for r = 1, #arg_Entry.route do															--make copy of route table
														flight.route[r] = {}
														for k,v in pairs(arg_Entry.route[r]) do
															flight.route[r][k] = v
														end
													end

			--######################################################################################################################################
			--######################################################################################################################################

			--######################################################################################################################################
			--#############"" START insert/create ATO table ##############################################################################################

													if ATO[side][pack_n][arg_Role] and ATO[side][pack_n][arg_Role] ~= nil then
														table.insert(ATO[side][pack_n][arg_Role], flight)

														local squadStatus = SquadGenerationStatus[flight.name]
														-- print("create flight AAA "..flight.name.." for role "..arg_Role.." in package "..pack_n.." with "..assigned.." aircraft, total firepower: "..flight.firepower)
														if squadStatus then
															squadStatus.mainGenerated = true
															-- print("SquadGenerationStatus BBB for "..flight.name.." mainGenerated set to true")
														end

													else
														-- if isDebugModeC then
															debugLog(draft.id.." AtoG passe C_12 ERROR ATO = nil arg_Role "..arg_Role)
														-- end
													end--add flight to package role (main, SEAD or escort)											

			--######################################################################################################################################
			--######################################################################################################################################

			--######################################################################################################################################

													if isDebugModeC then
														debugLog(draft.id.." AtoG passe C_13 |||AFTER insert/create ATO table||| type "..draft.type.." number "..assigned.." "..arg_Entry.task)
													end

													if draft.main_overideMP and mpTask_Check then

														-- multiPlaneSet[side][draft.type][draft.name].NbPlane = multiPlaneSet[side][draft.type][draft.name].NbPlane - assigned

														local mp_Data = getMultiPlane(side, draft.name, draft.type)

														if mp_Data then
															mp_Data.NbPlane = mp_Data.NbPlane - assigned
														end

														if isDebugModeC then
															debugLog(draft.id.." AtoG passe C_14 (NbPlane - assigned) "..multiPlaneSet[side][draft.type][draft.name].NbPlane)
														end
													end

													if not AcftAvail[arg_Entry.name] then
														debugLog(draft.id.." ERROR AcftAvail missing for "..tostring(arg_Entry.name))
														return
													end

													--Pourquoi: si ce squad a une répartition par tâche (tasksCoef), on plafonne "assigned" à ce qu'il
													--reste pour CETTE tâche précise, même si le pool global AcftAvail n'est pas épuisé -- sinon la
													--première tâche traitée peut engloutir tout le squad avant que les autres n'aient leur part.
													local taskForCap = (arg_Role == "main") and draft.task or arg_Role
													local assigned_avant_clamp = assigned

													if AcftAvail[arg_Entry.name].taskCap and AcftAvail[arg_Entry.name].taskCap[taskForCap] ~= nil then

														AcftAvail[arg_Entry.name].taskUsed = AcftAvail[arg_Entry.name].taskUsed or {}
														local usedSoFar = AcftAvail[arg_Entry.name].taskUsed[taskForCap] or 0
														local cap = AcftAvail[arg_Entry.name].taskCap[taskForCap]
														local remaining = cap - usedSoFar

														if remaining <= 0 then
															assigned = 0
														elseif assigned > remaining then
															assigned = remaining
														end

														AcftAvail[arg_Entry.name].taskUsed[taskForCap] = usedSoFar + assigned

														debugLog(draft.id.." AtoG TASKCAP squad: "..tostring(arg_Entry.name)
															.." arg_Role: "..tostring(arg_Role)
															.." taskForCap: "..tostring(taskForCap)
															.." cap: "..tostring(cap)
															.." deja_utilise_avant: "..tostring(usedSoFar)
															.." assigned_avant_clamp: "..tostring(assigned_avant_clamp)
															.." assigned_final: "..tostring(assigned)
															.." deja_utilise_apres: "..tostring(AcftAvail[arg_Entry.name].taskUsed[taskForCap]))

													else
														--Pourquoi: si on arrive ICI, le plafond n'a PAS été consulté du tout pour cet appel
														--(pas de taskCap pour ce squad, ou taskForCap ne correspond à aucune clé de taskCap)
														---> assigned part sans aucune limite par tâche, uniquement limité par le pool global.
														debugLog(draft.id.." AtoG TASKCAP_SKIPPED squad: "..tostring(arg_Entry.name)
															.." arg_Role: "..tostring(arg_Role)
															.." taskForCap: "..tostring(taskForCap)
															.." assigned_sans_plafond: "..tostring(assigned)
															.." taskCap_existe: "..tostring(AcftAvail[arg_Entry.name].taskCap ~= nil))
													end

													if assigned <= 0 then
														--plus de part disponible pour CETTE tâche précise (même si le pool global n'est pas vide)
														return
													end

													--Pourquoi: tracer précisément CHAQUE décrémentation réelle d'AcftAvail (la seule dans tout le
													--fichier), avec avant/après, pour repérer une éventuelle fuite de compteur sans avion en vol
													if Debug.debug then
														debugLog(
															draft.id.." AtoG DECREMENT_ACFTAVAIL squad: "..tostring(arg_Entry.name)
															.." role: "..tostring(arg_Role)
															.." draft.task: "..tostring(draft.task)
															.." target: "..tostring(draft.target_name)
															.." avant: "..tostring(AcftAvail[arg_Entry.name].unassigned)
															.." retire: "..tostring(assigned)
															.." apres: "..tostring(AcftAvail[arg_Entry.name].unassigned - assigned)
														)
													end

													AcftAvail[arg_Entry.name].assigned = AcftAvail[arg_Entry.name].assigned + assigned
													AcftAvail[arg_Entry.name].unassigned = AcftAvail[arg_Entry.name].unassigned - assigned		--remove assigned aircraft from total number of available aircraft for this unit
													arg_Assign = arg_Assign - assigned															--continue loop until are aircraft are assigned

													if isDebugModeC then
														debugLog(draft.id.." AtoG passe C_15   assign "..arg_Assign.." type: "..arg_Entry.type.." unassigned: "..AcftAvail[arg_Entry.name].unassigned)
													end

												end
											end

											if isDebugModeC then
												debugLog(draft.id.." AtoG passe C_05  |AddFlight MAIN| number "..tostring(draft.number))
											end

											--********************************************************************************************
											-- addFlight(draft.number, "main", draft)												--add main body flights to package
											local draftForFlight = DeepCopy(draft)
											draftForFlight.number = request_Main_Nb

											addFlight(request_Main_Nb, "main", draftForFlight)
											--********************************************************************************************

											--vol principal reellement ajoute a l'ATO : si ce package a beneficie du mode
											--degrade (RelaxGeneration), c'est le point fiable pour l'annoncer (cf le meme
											--hook au niveau du 1er circuit, processEligibleLoadout / buildDraftSorties).
											AnnounceRelaxedLimits(draft.name, draft.target_name, draft.loadout.name)

											-- for taskSupport, supportPart in pairs(draft.support) do										--iterate through all package support
											-- Ça stabilise :
											-- l’ordre d’allocation support,
											-- la consommation avion,
											-- les résultats ATO.
											-- Tu élimines une énorme part de non-déterminisme.
											local orderedSupportTasks = {}

											for taskSupport in pairs(draft.support) do
												table.insert(orderedSupportTasks, taskSupport)
											end

											table.sort(orderedSupportTasks)

											for _, taskSupport in ipairs(orderedSupportTasks) do
												local supportPart = draft.support[taskSupport]

												if taskSupport and type(supportPart) == "table" then
													-- for _plane, support in pairs(supportPart) do
													local orderedSupportPlanes = {}

													for planeName in pairs(supportPart) do
														table.insert(orderedSupportPlanes, planeName)
													end

													table.sort(orderedSupportPlanes)

													for _, _plane in ipairs(orderedSupportPlanes) do
														local support = supportPart[_plane]
														local number  = 0
														if type(support) == "table" and support.name then

															if isDebugModeC then
																debugLog(draft.id.." AtoG passe C_06a  |AddFlight SUPPORT?| _plane "..tostring(_plane))
															end

															if support.number >= AcftAvail[support.name].unassigned then
																number = AcftAvail[support.name].unassigned
															end
															if support.number < AcftAvail[support.name].unassigned then
																number = support.number
															end

															if isDebugModeC then
																debugLog(draft.id.." AtoG passe C_06  |AddFlight SUPPORT| numberFINAL "..tostring(number).." support_name: "..taskSupport.." unassigned: "..tostring(AcftAvail[support.name].unassigned))
															end

															--********************************************************************************************
															addFlight(number, taskSupport, support)										--add support flights to package
															--********************************************************************************************

															multipackByTargetName[draft.target_name].supporTotal = multipackByTargetName[draft.target_name].supporTotal + number

														else

														end
													end
												else
													local sujet = draft.id.." IN AddFlight type(supportPart) == table"
													local cause = { "support_available: ", tostring(support_available) }
													rejectDraft(draft, sujet, cause, SafeGetLine())
												end
											end

											--remove the firepower applied by package to target from maximum firepower of all other draft sorties to the same target
											local firepower_applied = 0																	--collect the amount of firepower combined by all main body flights of this package
											for f = 1, #ATO[side][pack_n].main do														--iterate through all main body flights
												firepower_applied = firepower_applied + ATO[side][pack_n].main[f].firepower				--sum firepower
											end

											if multipackByTargetName[draft.target_name] and multipackByTargetName[draft.target_name]["nbPack"] then
												multipackByTargetName[draft.target_name]["nbPack"] = multipackByTargetName[draft.target_name]["nbPack"] -1
											end

											--status report
											status_counter_ATO = status_counter_ATO + 1

										else
											local sujet = draft.id.." SUPPORT IMPOSSIBLE()if support_available"
											local cause = { "support_available: ", tostring(support_available) }
											rejectDraft(draft, sujet, cause, SafeGetLine())
										end
									else
										local sujet = draft.id.." AVIONS INSUFFISANT()if draft.number <= available and limitMP then {draft.number, limitMP}"
										local cause = {"draft.number: ", tostring(draft.number), "limitMP: ", tostring(limitMP)}
										rejectDraft(draft, sujet, cause, SafeGetLine(), "insufficient_aircraft_count")
									end
								else
									local sujet = draft.id.." FIREPOWER du PACKAGE INSUFFISANT()if  available * draft.loadout.firepower >= (draft.target.firepower.packmin - 1) * draft.target.firepower.max"
									local cause = { [1] = tostring(available_Main * draft.loadout.firepower), [2]  = tostring((draft.target.firepower.packmin - 1) * draft.target.firepower.max), }
									rejectDraft(draft, sujet, cause, SafeGetLine(), "insufficient_package_firepower")
								end
							
							else
								--available_Main == 0 : c'est le vrai "plus aucun avion", cas le plus parlant pour le joueur.
								--available_Main > 0  : il reste des avions mais leur puissance de feu cumulee ne suffit pas.
								local reasonCode = "insufficient_firepower_available"
								if available_Main <= 0 then
									reasonCode = "no_aircraft_available"
								end
								local sujet = draft.id.." "..tostring(draft.type).." AVION DISPONIBLE INSUFFISANT "..tostring(draft.name).." available: "..tostring(available_Main).." draft.loadout.firepower: "..tostring(draft.loadout.firepower.." firepowerMin: "..tostring(draft.target.firepower.min))
								local cause = { [1] = tostring(available_Main), [2]  = tostring(draft.target.firepower.min), }
								rejectDraft(draft, sujet, cause, SafeGetLine(), reasonCode)
							end
						else
							local sujet = draft.id.." FIREPOWER INSUFFISANT (a augmenter dans loadout)if draft.target.firepower.max > 0 and draft.target.firepower.max >= draft.target.firepower.min"
							local cause = { [1] = tostring(draft.target.firepower.max), [2]  = tostring(draft.target.firepower.max), }
							rejectDraft(draft, sujet, cause, SafeGetLine(), "loadout_firepower_too_low")
						end
					else
						local sujet = draft.id.." MultiPACKAGE A 0 (?)if draft.multipack == nil or draft.multipack > 0 || target_name: "..tostring(draft.target_name).." || multipack: " ..tostring(draft.multipack)
						local cause = { [1] = tostring(draft.multipack), [2]  = tostring(draft.multipack), }
						rejectDraft(draft, sujet, cause, SafeGetLine())
					end
				else
					local sujet = draft.id.." MENACE TROP IMPORTANTE (descendre minscore ou diminuer Menace AA AS) minscore  "..tostring(draft.loadout.minscore).." <score? "..tostring(draft.score)
					local cause = { [1] = tostring(draft.loadout.minscore), [2]  = tostring(draft.score), }
					rejectDraft(draft, sujet, cause, SafeGetLine())

				end

				if isDebugModeC and next(escortRejectReasons) then
					for squadName, reasons in pairs(escortRejectReasons) do
						debugLog(draft.id.." ESCORT_REJECT "..squadName.." => "..table.concat(reasons, " | "))
					end
				end

			end
		end
	end
end

-- _affiche(Draft_sorties.blue[1], "Draft_sorties.blue[1]")
-- _affiche(Draft_sorties.red[1], "Draft_sorties.red[1]")

local function showAtoSort(arg_newDraftByPriority, arg_tablePrio)

	local showSquad
	local showTarget

	if Debug.Generator.SpySquad then
		showSquad = Debug.Generator.SpySquad
	end
	if Debug.Generator.SpyTarget  then
		showTarget = Debug.Generator.SpyTarget
	end

	-- local showSquad = "111.Filo"

	for side, sorties in pairs(arg_newDraftByPriority) do
		local di = 1
		debugLog(side.." PART C ")

		for draft_n, draft in pairs(sorties) do
			local nameOK = false
			if draft.target_name == showTarget then
				nameOK = true
			end
			for _planeTask, PlaneTask in pairs(draft.support) do
				for taskName, task in pairs(PlaneTask) do
					if type(task) == "table" then
						if task.name == showSquad  then
							nameOK = true
						end
					end
				end
			end

			if di < Debug.Generator.nb or draft.name == showSquad or nameOK then
				debugLog("")
				debugLog(side.." tablePrio: "..arg_tablePrio.." C N° " .. draft_n..
						-- " /support/ " ..tostring(draft.support)..
						" /Id/ " ..tostring(draft.id)..
						" /targetPriority/ " ..tostring(draft.targetPriority)..
						-- " /draft.priorityIni/ " ..tostring(draft.priorityIni)..
						" /name/ " ..draft.name..
						" /Nb/ " ..draft.number..
						" /Type/ "..draft.type..
						" /Tot_to/ "..draft.tot_to ..
						" /threatsGround/ "..round(draft.threatsGround)..
						" /threatsAir/ "..round(draft.threatsAir)..
						" /Score/ " ..round(draft.score)..
						" /Task/ "..draft.task..
						" /Target/ "..tostring(draft.target_name)..
						" /LoadName/ "..tostring(draft.loadout.name)
						)
				di = di +1
				for _planeTask, supportPart in pairs(draft.support) do
					for taskName, support in pairs(supportPart) do
						if type(support) == "table" and support.target_name and support.loadout then
							debugLog(	"    ---> Nsupport " .._planeTask.." ".. taskName..
									" /Id" ..tostring(support.id)..
									" /name/ " ..support.name..
									" /Nb/ " ..support.number..
									" /escort_max/ " ..tostring(supportPart.escort_max)..
									" /SupportName/ "..support.name..
									" /Type/ "..support.type..
									" /Task/ "..support.task..
									" /NbTotSupt/ " ..tostring(support.NbTotalSupport)..
									" /Target/ "..support.target_name..
									" /LoadName/ "..tostring(support.loadout.name)
									)
						end
					end
				end
				if draft.rejected then
					for id, _rejected in pairs(draft.rejected) do

						--ecrit les causes:
						local causeTxt = ""
						for causeN, cause_ in ipairs(_rejected.cause) do
							causeTxt = causeTxt .. " |#"..causeN.."->| "..tostring(cause_)
						end
						debugLog(	" - - ----> rejected/ ".._rejected.sujet..
							" / cause " ..causeTxt..
							" / ligne " ..tostring(_rejected.ligne)
							)
					end
				end

			end
		end
	end
end

if #draftSorties.blue == 0 then
	print("AtoG ERROR no route could be generated in blue camp? ")
elseif #draftSorties.red == 0 then
	print("AtoG ERROR no route could be generated in red camp? ")
end

--creation de la table multipack (systeme cassé a cause du decoupage draft_sortie en plusieurs morceau/priorité)
multipackByTargetName = {}
for side, drafts in pairs(draftSorties) do
	for draftN, draft in ipairs(drafts)do
		multipackByTargetName[draft.target_name] = multipackByTargetName[draft.target_name] or {}
		multipackByTargetName[draft.target_name]["nbPack"] = multipackByTargetName[draft.target_name]["nbPack"] or 0

		multipackByTargetName[draft.target_name].supporTotal = multipackByTargetName[draft.target_name].supporTotal or 0

		if multipackByTargetName[draft.target_name]["nbPack"] < draft.multipack then
			multipackByTargetName[draft.target_name]["nbPack"] = draft.multipack
		end
	end
end

-- local priorityRef = {
-- 	blue =0,
-- 	red = 0,
-- }
-- local newDraftByPriority = {
-- 	blue = {},
-- 	red = {},
-- }

-- --creation du targetlist par ordre de priorité
-- local targetListPrio = {
-- 	blue = {},
-- 	red = {},
-- }
-- local targetListPrioCheck = {
-- 	blue = {},
-- 	red = {},
-- }
-- local targetNamePrio = {
-- 	blue = {},
-- 	red = {},
-- }
-- for targetSide, targets in pairs(tgtList_Gen) do
-- 	for targetN, target in pairs(targets) do
-- 		if not target.inactive and target.ATO then  --and (target.task == "Strike" or  target.task == "Anti-ship Strike" or target.task == "Runway Attack")

-- 			--util pour eviter de cibler les memes target
-- 			if not targetNamePrio[targetSide][target.priority] then targetNamePrio[targetSide][target.priority] = {} end
-- 			local tempValue = {
-- 				name = target.titleName,
-- 				check = false,
-- 				priority = target.priority,
-- 			}
-- 			table.insert(targetNamePrio[targetSide][target.priority], tempValue)

-- 			--necessaire pour trier par ordre de priorité
-- 			if not targetListPrioCheck[targetSide][target.priority] then
-- 				table.insert(targetListPrio[targetSide], target.priority)
-- 				targetListPrioCheck[targetSide][target.priority] = true
-- 			end

-- 			if priorityRef[targetSide] < target.priority  then
-- 				priorityRef[targetSide] = target.priority
-- 			end
-- 		end
-- 	end
-- end

for targetSide, targets in pairs(tgtList_Gen) do

	for _, target in ipairs(targets) do
		if not target.inactive and target.ATO then

			local priority = target.priority

			-- util pour eviter de cibler les memes target
			if not targetNamePrio[targetSide][priority] then
				targetNamePrio[targetSide][priority] = {}
			end

			table.insert(targetNamePrio[targetSide][priority], {
				name = target.titleName,
				check = false,
				priority = priority,
			})

			-- necessaire pour trier par ordre de priorité
			if not targetListPrioCheck[targetSide][priority] then
				table.insert(targetListPrio[targetSide], priority)
				targetListPrioCheck[targetSide][priority] = true
			end

			if priority > priorityRef[targetSide] then
				priorityRef[targetSide] = priority
			end

		end
	end

end



table.sort(targetListPrio["blue"], function(a,b) return a > b  end)
table.sort(targetListPrio["red"], function(a,b) return a > b  end)



-- for sidePrio, tableauPrio in pairs(targetListPrio) do
-- 	for tableN, value_prio in pairs(tableauPrio) do

-- 		for draftN, draft in pairs(draftSorties[sidePrio]) do
-- 			-- if draft.priorityIni == value_prio then
-- 			if draft.targetPriority == value_prio then
-- 				table.insert(newDraftByPriority[sidePrio], draft)
-- 			end

-- 		end

-- 		table.sort(newDraftByPriority[sidePrio], function(a,b) return a.score > b.score  end)

-- 		createATO_table(newDraftByPriority)

-- 		if Debug.Generator.affiche and newDraftByPriority ~= nil then
-- 			debugLog("\n"..debuGenTxt.." \n Side: "..sidePrio.."  tablePrio "..tostring(value_prio).."\n")
-- 			showAtoSort(newDraftByPriority, value_prio)
-- 		end

-- 		newDraftByPriority = {
-- 			blue = {},
-- 			red = {},
-- 		}
-- 	end
-- end

--PATCH ATO_Generator_C_Core.lua : preference pour le loadout a la portee la plus juste
--A coller a la FIN du fichier, juste apres les deux lignes :
--    table.sort(targetListPrio["blue"], function(a,b) return a > b  end)
--    table.sort(targetListPrio["red"], function(a,b) return a > b  end)
--et a la place de la boucle "for sidePrio, tableauPrio in pairs(targetListPrio) do ... end" actuelle.
-------------------------------------------------------------------------------------------------------

-- ============================================================================
-- REGLAGE : preference pour le loadout de portee juste suffisante
-- ============================================================================
--Pourquoi: quand un squad a plusieurs loadouts eligibles pour la meme cible (ex: un "light" sans
--reservoirs externes et un "lourd" avec reservoirs), leurs drafts ont presque le meme score et le
--choix devient quasi aleatoire. On pousse vers le bas les loadouts a grande portee, uniquement
--pour l'ORDRE de traitement : draft.score n'est pas modifie (minscore et le reste ne changent pas),
--et le loadout lourd reste dispo en secours si le light est refuse plus loin (escorte manquante...).
--
--0    = aucun effet (comportement identique a avant)
--0.5  = preference douce (portee x4 => cle de tri divisee par 2)
--1    = proportionnel (portee x3 => cle de tri divisee par 3)
--2    = tres marquee
--
--A ajuster ici, avec l'experience, sans toucher au reste du fichier.
LOADOUT_RANGE_PREFERENCE = 0

-- ============================================================================
-- LOG DEDIE : Debug/LoadoutRange.log (separe du log general du generateur)
-- ============================================================================
--Contient uniquement ce qui concerne le choix light / lourd : quelques lignes de detail du tri (RANGE_PREF),
--une ligne par flight de l'ATO (RANGE_REPORT) et le resume de la generation (RANGE_SUMMARY).
--Actif seulement si Debug.debug ET LOADOUT_RANGE_LOG = true.
--Le fichier est ECRASE a chaque generation : il ne contient que la derniere passe (celle qui a produit l'ATO utilise).
--Pour garder l'historique de plusieurs missions (comparer des reglages), mettre LOADOUT_RANGE_LOG_APPEND = true
--(le fichier est alors complete a chaque passe ; supprimer le fichier pour repartir de zero).
LOADOUT_RANGE_LOG = true
LOADOUT_RANGE_LOG_APPEND = false
LOADOUT_RANGE_LOG_FILE = "Debug/LoadoutRange.log"
LOADOUT_RANGE_LOG_MAX_DETAIL = 40		--nb max de lignes RANGE_PREF detaillees par generation (le total reste compte dans le resume)

local rangeLogBuf = {}
local rangeLogStats = { penalised = 0, detailShown = 0 }

local function rangeLog(msg)
	if Debug.debug and LOADOUT_RANGE_LOG then
		rangeLogBuf[#rangeLogBuf + 1] = tostring(msg)
	end
end

local function rangeLogFlush()
	if #rangeLogBuf == 0 then
		return
	end

	--en-tete place en tete du bloc (donc avant les lignes RANGE_PREF du tri, qui sont ecrites plus tot)
	table.insert(rangeLogBuf, 1, "")
	table.insert(rangeLogBuf, 2, "==== "..(os.date and os.date("%Y-%m-%d %H:%M:%S") or "").." | MissionInstance: "..tostring(MissionInstance)
		.." | GeneratorPass: "..tostring(GeneratorPass).." | CampTotalTimeH: "..tostring(CampTotalTimeH).." ====")

	local file = io.open(LOADOUT_RANGE_LOG_FILE, LOADOUT_RANGE_LOG_APPEND and "a" or "w")
	if file then
		file:write(table.concat(rangeLogBuf, "\n").."\n")
		file:close()
	else
		AddLog("AtoG RangeLog: cannot open "..tostring(LOADOUT_RANGE_LOG_FILE))
	end

	rangeLogBuf = {}
end

--Trie une liste de drafts (meme priorite de cible) par score decroissant.
--Pour un meme squad + meme tache + meme cible, le draft dont le loadout a la plus petite portee
--(parmi ceux qui ont deja passe le controle de portee) garde son score ; les autres sont
--penalises par (plus petite portee / leur portee) ^ LOADOUT_RANGE_PREFERENCE.
local function sortDraftsByScoreAndRange(draftList)

	local minRangeByGroup = {}
	local sortKey = {}

	local function groupKeyOf(draft)
		return tostring(draft.name).."|"..tostring(draft.task).."|"..tostring(draft.target_name)
	end

	local function rangeOf(draft)
		return (draft.loadout and tonumber(draft.loadout.range)) or 0
	end

	--plus petite portee de chaque groupe
	if LOADOUT_RANGE_PREFERENCE > 0 then
		for _, draft in ipairs(draftList) do
			local range = rangeOf(draft)
			if range > 0 then
				local key = groupKeyOf(draft)
				if not minRangeByGroup[key] or range < minRangeByGroup[key] then
					minRangeByGroup[key] = range
				end
			end
		end
	end

	--cle de tri de chaque draft
	for _, draft in ipairs(draftList) do

		sortKey[draft] = draft.score

		if LOADOUT_RANGE_PREFERENCE > 0 then

			local range = rangeOf(draft)
			local minRange = minRangeByGroup[groupKeyOf(draft)]

			if range > 0 and minRange and range > minRange then

				local factor = (minRange / range) ^ LOADOUT_RANGE_PREFERENCE
				sortKey[draft] = draft.score * factor

				rangeLogStats.penalised = rangeLogStats.penalised + 1

				if rangeLogStats.detailShown < LOADOUT_RANGE_LOG_MAX_DETAIL then
					rangeLogStats.detailShown = rangeLogStats.detailShown + 1
					rangeLog(tostring(draft.id).." RANGE_PREF squad: "..tostring(draft.name)
						.." task: "..tostring(draft.task)
						.." target: "..tostring(draft.target_name)
						.." loadout: "..tostring(draft.loadout.loadoutName or draft.loadout.name)
						.." range: "..tostring(range).." (min groupe: "..tostring(minRange)..")"
						.." factor: "..string.format("%.2f", factor)
						.." score: "..string.format("%.3f", draft.score)
						.." -> cle de tri: "..string.format("%.3f", sortKey[draft]))
				end
			end
		end
	end

	table.sort(draftList, function(a, b) return sortKey[a] > sortKey[b] end)
end

-- ============================================================================
-- LOG DE CONTROLE : la preference light / lourd est-elle efficace ?
-- ============================================================================
--Pourquoi: savoir, apres chaque generation, si le loadout choisi est bien le plus "juste" pour la distance.
--Aucun effet sur la generation : lecture seule de draftSorties et ATO, ecrit uniquement dans le debugLog
--(donc actif seulement si Debug.debug). A lancer avec les reglages a 0 puis a >0 et comparer les lignes RANGE_SUMMARY.
--
--Pour chaque flight principal (MAIN) et chaque flight de support (SUPPORT) de l'ATO :
--  UNIQUE    = un seul choix de portee etait possible pour ce squad/tache/cible -> le reglage ne sert a rien ici
--  LIGHT     = le loadout choisi est celui de plus petite portee parmi les eligibles     (bon choix)
--  FORCED    = un loadout plus court existait mais sa portee ne permettait pas la route (route > 2 x portee) : lourd obligatoire
--  HEAVY_ALT = un loadout plus court AURAIT suffi mais un plus lourd a ete pris (c'est le seul cas que le reglage peut corriger ;
--              detail affiche sur la ligne suivante : que sont devenus les drafts plus legers)
--fill = longueur de route / (2 x portee du loadout choisi) : proche de 1 = loadout juste, proche de 0 = surdimensionne.
--     (n/a pour Intercept et SAR : leur route est fictive)
--efficacite = LIGHT / (LIGHT + HEAVY_ALT) : c'est LE chiffre a comparer entre reglage 0 et reglage > 0.
--Objectif: en passant le reglage de 0 a 0.5 ou 1, l'efficacite monte et HEAVY_ALT baisse.
local function rangePrefReport(draftSortiesArg, atoArg)

	if not Debug.debug or not LOADOUT_RANGE_LOG then
		return
	end

	--le loadout est-il autorise pour ce pays ? (meme regle que dans la generation)
	local function countryOk(ltable, country)
		if ltable.country == nil then
			return true
		end
		if type(ltable.country) == "string" then
			return string.lower(ltable.country) == string.lower(country or "") or string.lower(ltable.country) == "all"
		end
		if type(ltable.country) == "table" then
			for _, countryLabel in pairs(ltable.country) do
				if string.lower(countryLabel) == string.lower(country or "") or string.lower(countryLabel) == "all" then
					return true
				end
			end
		end
		return false
	end

	--taches dont la "route" est une route fictive (rayon de la cible x2) : leur fill ne veut rien dire
	local STUB_ROUTE_TASKS = { ["Intercept"] = true, ["SAR"] = true }

	--1) index des drafts, des supports (avec leur draft principal) et des groupes (squad|tache|cible) cote MAIN
	local draftById = {}
	local supportById = {}
	local supportParent = {}
	local mainGroups = {}

	for _, drafts in pairs(draftSortiesArg) do
		for _, draft in ipairs(drafts) do

			draftById[draft.id] = draft

			local range = draft.loadout and tonumber(draft.loadout.range)
			if range and range > 0 then
				local key = tostring(draft.name).."|"..tostring(draft.task).."|"..tostring(draft.target_name)
				local g = mainGroups[key]
				if not g then
					g = { min = range, ranges = {}, nRanges = 0, drafts = {} }
					mainGroups[key] = g
				end
				if range < g.min then g.min = range end
				if not g.ranges[range] then
					g.ranges[range] = true
					g.nRanges = g.nRanges + 1
				end
				g.drafts[#g.drafts + 1] = draft
			end

			for _, supportPart in pairs(draft.support or {}) do
				if type(supportPart) == "table" then
					for _, support in pairs(supportPart) do
						if type(support) == "table" and support.id then
							supportById[support.id] = support
							supportParent[support.id] = draft
						end
					end
				end
			end
		end
	end

	--2) compteurs
	local CLASSES = { "UNIQUE", "LIGHT", "FORCED", "HEAVY_ALT" }
	local stats = { MAIN = {}, SUPPORT = {} }
	for kind, _ in pairs(stats) do
		for _, class in ipairs(CLASSES) do
			stats[kind][class] = { n = 0, fill = 0, nFill = 0 }
		end
	end
	local seen = {}

	--kind, flight, longueur de route, plus petite portee possible, nb de portees possibles, fonction de detail (HEAVY_ALT)
	local function record(kind, flight, routeLenght, minRange, nRanges, detailFn)

		local range = flight.loadout and tonumber(flight.loadout.range)
		if not range or range <= 0 or not routeLenght then
			return
		end

		local class
		if nRanges <= 1 then
			class = "UNIQUE"
		elseif range <= minRange then
			class = "LIGHT"
		elseif routeLenght > minRange * 2 then
			class = "FORCED"		--le loadout court ne pouvait pas faire cette route : le lourd etait obligatoire
		else
			class = "HEAVY_ALT"		--un loadout plus court aurait suffi
		end

		local fill = routeLenght / (range * 2)
		local fillTxt = "n/a"

		stats[kind][class].n = stats[kind][class].n + 1

		if not STUB_ROUTE_TASKS[flight.task] then
			stats[kind][class].fill = stats[kind][class].fill + fill
			stats[kind][class].nFill = stats[kind][class].nFill + 1
			fillTxt = string.format("%.2f", fill)
		end

		local detail = ""
		if class == "HEAVY_ALT" and detailFn then
			detail = "\n    -> "..detailFn()
		end

		rangeLog(tostring(flight.id).." AtoG RANGE_REPORT "..kind
			.." squad: "..tostring(flight.name)
			.." task: "..tostring(flight.task)
			.." target: "..tostring(flight.target_name)
			.." loadout: "..tostring(flight.loadout.loadoutName or flight.loadout.name)
			.." range: "..tostring(math.floor(range))
			.." route: "..tostring(math.floor(routeLenght))
			.." fill: "..fillTxt
			.." class: "..class
			.." (portees possibles: "..tostring(nRanges)..", min: "..tostring(math.floor(minRange or 0))..")"
			..detail)
	end

	--explique pourquoi un loadout plus leger n'a pas ete retenu cote MAIN : que sont devenus ses drafts ?
	local function mainDetail(g, chosenDraft, flight)
		local txt = "plus leger non retenu (choisi: score "..string.format("%.3f", chosenDraft and chosenDraft.score or 0)..") :"
		local shown = 0
		for _, d in ipairs(g.drafts) do
			local r = tonumber(d.loadout.range)
			if r and r <= g.min and d.id ~= flight.id then
				shown = shown + 1
				if shown <= 2 then
					txt = txt.." ["..tostring(d.loadout.loadoutName or d.loadout.name)
						.." score "..string.format("%.3f", d.score)
					if d.rejected and #d.rejected > 0 then
						txt = txt.." rejets: "
						for i = 1, math.min(2, #d.rejected) do
							txt = txt..string.sub(tostring(d.rejected[i].sujet), 1, 110).." | "
						end
					else
						txt = txt.." aucun rejet : le lourd est passe avant (ordre de traitement)"
					end
					txt = txt.."]"
				end
			end
		end
		if shown == 0 then
			txt = txt.." (aucun draft plus leger trouve)"
		end
		return txt
	end

	--explique pourquoi un loadout de support plus leger n'a pas ete retenu (criteres de la generation, simplifies)
	local function supportDetail(flight, parent, list, minRange)
		local txt = "loadouts plus legers possibles :"
		local chosenStandoff = tonumber(flight.loadout.standoff) or 0
		local shown = 0
		for name, l in pairs(list or {}) do
			local r = type(l) == "table" and tonumber(l.range)
			if r and r <= minRange and countryOk(l, flight.country) then
				shown = shown + 1
				local vOk = true
				if parent and parent.loadout and parent.loadout.vCruise and l.vCruise then
					vOk = (l.vCruise + parent.loadout.vCruise * 0.10) >= parent.loadout.vCruise
				end
				txt = txt.." ["..tostring(name)
					.." range "..tostring(math.floor(r))
					.." standoff "..tostring(tonumber(l.standoff) or 0).." (choisi "..tostring(chosenStandoff)..")"
					.." vitesse_ok "..tostring(vOk).."]"
			end
		end
		if shown == 0 then
			txt = txt.." aucun"
		end
		return txt
	end

	--3) parcours de l'ATO reel
	for _, packages in pairs(atoArg) do
		for packN, pack in pairs(packages) do
			for role, flights in pairs(pack) do
				if type(flights) == "table" then
					for _, flight in ipairs(flights) do

						if type(flight) == "table" and flight.id and flight.loadout and not seen[role..tostring(flight.id)] then

							seen[role..tostring(flight.id)] = true

							if role == "main" then

								local draft = draftById[flight.id]
								local key = tostring(flight.name).."|"..tostring(flight.task).."|"..tostring(flight.target_name)
								local g = mainGroups[key]

								if draft and draft.route and g then
									record("MAIN", flight, draft.route.lenght, g.min, g.nRanges,
										function() return mainDetail(g, draft, flight) end)
								end

							else

								local support = supportById[flight.id]

								if support and support.route then

									--portees possibles pour ce type d'avion / cette tache (loadouts autorises pour le pays)
									local minRange, nRanges, ranges = nil, 0, {}
									local list = LoadoutsList and LoadoutsList[flight.type] and LoadoutsList[flight.type][flight.task]

									for _, ltable in pairs(list or {}) do
										local r = type(ltable) == "table" and tonumber(ltable.range)
										if r and r > 0 and countryOk(ltable, flight.country) then
											if not ranges[r] then
												ranges[r] = true
												nRanges = nRanges + 1
											end
											if not minRange or r < minRange then minRange = r end
										end
									end

									record("SUPPORT", flight, support.route.lenght, minRange or 0, nRanges,
										function() return supportDetail(flight, supportParent[flight.id], list, minRange or 0) end)
								end
							end
						end
					end
				end
			end
		end
	end

	--4) resume
	local function line(kind)
		local s = stats[kind]
		local txt = kind..":"
		for _, class in ipairs(CLASSES) do
			local avg = "n/a"
			if s[class].nFill > 0 then avg = string.format("%.2f", s[class].fill / s[class].nFill) end
			txt = txt.." "..class.."="..s[class].n.." (fill moy "..avg..")"
		end
		--efficacite : parmi les choix ou un loadout plus court etait possible (hors UNIQUE et FORCED), part de choix corrects
		local choix = s.LIGHT.n + s.HEAVY_ALT.n
		if choix > 0 then
			txt = txt.." => efficacite "..string.format("%d%%", math.floor(s.LIGHT.n * 100 / choix))
				.." ("..s.LIGHT.n.."/"..choix..")"
		else
			txt = txt.." => efficacite n/a (aucun choix light/lourd evitable)"
		end
		return txt
	end

	rangeLog("AtoG RANGE_SUMMARY LOADOUT_RANGE_PREFERENCE="..tostring(LOADOUT_RANGE_PREFERENCE)
		.." SUPPORT_LOADOUT_PREFER_SHORT_RANGE="..tostring(SUPPORT_LOADOUT_PREFER_SHORT_RANGE)
		.." drafts_penalises="..tostring(rangeLogStats.penalised)
		.." | "..line("MAIN").." | "..line("SUPPORT"))

	rangeLogFlush()
end

for sidePrio, tableauPrio in pairs(targetListPrio) do
	for tableN, value_prio in pairs(tableauPrio) do

		for draftN, draft in pairs(draftSorties[sidePrio]) do
			-- if draft.priorityIni == value_prio then
			if draft.targetPriority == value_prio then
				table.insert(newDraftByPriority[sidePrio], draft)
			end

		end

		--avant : table.sort(newDraftByPriority[sidePrio], function(a,b) return a.score > b.score  end)
		sortDraftsByScoreAndRange(newDraftByPriority[sidePrio])

		createATO_table(newDraftByPriority)

		if Debug.Generator.affiche and newDraftByPriority ~= nil then
			debugLog("\n"..debuGenTxt.." \n Side: "..sidePrio.."  tablePrio "..tostring(value_prio).."\n")
			showAtoSort(newDraftByPriority, value_prio)
		end

		newDraftByPriority = {
			blue = {},
			red = {},
		}
	end
end


--log de controle de la preference light / lourd (lecture seule, actif si Debug.debug)

rangePrefReport(draftSorties, ATO)

WG_AirliftAfterATO(draftSorties, ATO, multipackByTargetName)		--wargame airlift : bilan des drafts airlift apres createATO_table (log append)

if Debug.debug then

	print("\n========== FINAL SQUAD REPORT ==========\n")

	local inactiveSquads = {}

	for squadName, status in pairs(SquadGenerationStatus) do

		if not status.mainGenerated and not status.supportGenerated then

			local bestReject = status.bestReject

			if bestReject and bestReject.dominantReason == "inactive" then

				-- squad inactif dès le premier contrôle (config squad/campagne) :
				-- aucune info de target/loadout à en tirer, on le compte à part
				inactiveSquads[#inactiveSquads + 1] = squadName

			else

				local taskListTxt = (status.tasks and #status.tasks > 0) and table.concat(status.tasks, ", ") or "aucune"
				local trackedReasonEntry = escortRejectReasons[squadName] and escortRejectReasons[squadName][1]
				local trackedReason = trackedReasonEntry and trackedReasonEntry.sujet

				if bestReject then

					print(
						squadName
						.." | "..status.unitType
						.." | tâches: "..taskListTxt
						.." | dominantReason: "
						..tostring(bestReject.dominantReason)
					)

				elseif trackedReason then

					-- raison précise trouvée (soit via processEligibleLoadout/addSupportToDraft, soit via
					-- createATO_table/rejectDraft - le draft a été construit avec succès puis rejeté plus tard)
					print(
						squadName
						.." | "..status.unitType
						.." | tâches: "..taskListTxt
						.." | raison: "..tostring(trackedReason)
					)

				elseif status.hasMainTask then

					-- a une vraie tâche principale (Strike/CAS/AWACS/Anti-ship/...), mais aucune raison
					-- n'a été trackée pour elle : à ne pas confondre avec un squad escorte pur
					print(
						squadName
						.." | "..status.unitType
						.." | tâches: "..taskListTxt
						.." | a une tâche principale mais aucune raison de rejet n'a été trackée (limite actuelle du tracking, pas un squad escorte)"
					)

				else

					print(
						squadName
						.." | "..status.unitType
						.." | tâches: "..taskListTxt
						.." | escort/support uniquement | a passé les contrôles de base (actif, base valide, appareils dispo) mais n'a jamais été sélectionné : soit sa tâche n'était pas demandée sur cette mission, soit un autre squad a été préféré"
					)
				end

				if bestReject and bestReject.finalReject then

					local fr = bestReject.finalReject

					local frTxt =
						"    -> bloqué à l'étape '"..tostring(fr.step)
						.."' | raison: "..tostring(fr.reason)
						.." | ligne: "..tostring(fr.line)
						.." | bloc: "..tostring(fr.bloc)

					if fr.data ~= nil then
						if type(fr.data) == "table" then
							for k, v in pairs(fr.data) do
								frTxt = frTxt.." | "..tostring(k)..": "..tostring(v)
							end
						else
							frTxt = frTxt.." | data: "..tostring(fr.data)
						end
					end

					print(frTxt)
				end

				if bestReject and bestReject.stats and next(bestReject.stats) then

					-- trie les raisons par nombre d'occurrences décroissant (la plus fréquente en premier)
					local sortedStats = {}
					for reasonKey, count in pairs(bestReject.stats) do
						sortedStats[#sortedStats + 1] = { key = reasonKey, count = count }
					end
					table.sort(sortedStats, function(a, b) return a.count > b.count end)

					print("    -> détail des raisons rencontrées (la plus fréquente en premier) :")
					for _, entry in ipairs(sortedStats) do
						print("       "..entry.key.." : "..entry.count.." fois")
					end
				end
			end
		end
	end

	if #inactiveSquads > 0 then

		local preview = {}
		for i = 1, math.min(5, #inactiveSquads) do
			preview[#preview + 1] = inactiveSquads[i]
		end

		local suffix = ""
		if #inactiveSquads > 5 then
			suffix = ", ..."
		end

		print("Inactive : "..#inactiveSquads.." squad(s) (tel que "..table.concat(preview, ", ")..suffix..")")
	end

	print("\n========================================\n")
end

local allFlightName_AtoG = {}

-- assigne un nom unique aux groupes
for _, packages in pairs(ATO) do
	for packN, pack in pairs(packages) do
		for _, flights in pairs(pack) do
			for flightN, flight in pairs(flights) do

				if type(flight) == "table" and flight.name then

					-- Nom commun  lisible
					local communBase =
						"Pack "
						.. tostring(packN)
						.. " - "
						.. tostring(flight.name)
						.. " - "
						.. tostring(flight.task)

					local duplicateIndex = 1
					local finalName = communBase .. " " .. duplicateIndex

					-- Tant qu'un doublon existe
					while allFlightName_AtoG[finalName] do
						duplicateIndex = duplicateIndex + 1
						finalName = communBase .. " " .. duplicateIndex
					end

					-- Validation définitive
					allFlightName_AtoG[finalName] = true

					flight.groupName = finalName

					-- debug éventuel
					-- print("AtoG assign flight G: groupName: " .. tostring(flight.groupName))

				end

			end
		end
	end
end

-- --remet la valeur de priority correct, si elle avait été changée par un choix multijoueur
-- -- for kGroupN, multiGroup in pairs(Multi.Group) do
-- for targetSide, targets in pairs(tgtList_Gen) do
-- 	for targetN, target in pairs(targets) do
-- 		if target.priorityINIT  then
-- 			target.priority = DeepCopy(target.priorityINIT)
-- 			target.priorityINIT = nil
-- 		end
-- 	end
-- end

if Debug.debug then
	local show = true

	if Debug.debug then
		-- print("AtoG outMemory check Z1")
		for side, packages in pairs(ATO) do
			for packN, pack in pairs(packages) do
				for role, flights in pairs(pack) do
					for flightN, flight in pairs(flights) do

						checkNbPlane[side]["thisMission"].used = checkNbPlane[side]["thisMission"].used + flight.number

					end
				end
			end
		end

		local resultPourcent = checkNbPlane.blue.thisMission.used / checkNbPlane.blue.beforMission.ready * 100

		local resultPourcent2 = checkNbPlane.blue.thisMission.used / (checkNbPlane.blue.beforMission.ready - checkNbPlane.blue.beforMission.alreadyInFlight) * 100

	end
end

if Debug.debug and Debug.Generator.affiche and string.find(Debug.Generator.chapter, "C") then

	-- local camp_str = "ATO = " .. TableSerialization(ATO, 0)
	-- local campFile = io.open("Debug/ATO_1_AtoGenerator.lua", "w")
	-- if campFile then
	-- 	campFile:write(camp_str)
	-- 	campFile:close()
	-- end

	local camp_str = "camp = " .. TableSerialization(camp, 0)
	local campFile = io.open("Debug/CAMP_Ato_Generator.lua", "w")
	if campFile then
		campFile:write(camp_str)
		campFile:close()
	end

end

if Debug.Generator and Debug.debug then
	flushDebugLogs()
end

if Debug.debug then
	local camp_str = "ATO_1_ATO_Generator = " .. TableSerialization(ATO, 0)
	local campFile = io.open("Debug/ATO_1_ATO_Generator.lua", "w") or error("Échec d'ouverture du fichier ATO_1_ATO_Generator")
	campFile:write(camp_str)
	campFile:close()

	

	camp_str = "PlayerAssignFailure_Generator = " .. TableSerialization(PlayerAssignFailure, 0)
	campFile = io.open("Debug/PlayerAssignFailure_ATO_Generator.lua", "w") or error("Échec d'ouverture du fichier PlayerAssignFailure_ATO_Generator")
	campFile:write(camp_str)
	campFile:close()

end

