--ATO_Gen_20_Eligibility.lua
--Sous-module de ATO_Gen_Main.lua : controles d'eligibilite d'un draft (meteo, attributs, fenetre TOT) et preparation du contexte unite (avions disponibles, base, repartition par tache)
--Charge par ATO_Gen_Main.lua (Include) a la place ou se trouvait le premier bloc. Texte deplace tel quel (2 blocs, dans l'ordre d'origine) ;
--seuls changements : checkWeatherEligibility, checkAttributeEligibility, computeTOTWindow et prepareUnitContext sont devenues globales (etaient 'local' dans l'ancien fichier, mais utilisees par Main / ATO_Gen_30_Sorties.lua).
--cleanupUnavailableAircraft, computeServiceableAircraft, SOLO_TASKS et allocateAircraftByTask restent locaux a ce fichier.
-------------------------------------------------------------------------------------------------------
if not versionDCE then versionDCE = {} end
versionDCE["ATO_Gen_20_Eligibility.lua"] = "1.21.137"
-------------------------------------------------------------------------------------------------------

if Debug.debug then
	print("START ATO_Gen_20_Eligibility.lua "..versionDCE["ATO_Gen_20_Eligibility.lua"].." =-=-=-=-=-=-=-=-=-=-=-=-=-=-=")
end

--Vérifie si le loadout est compatible avec la météo actuelle
--Pourquoi: sortir la logique météo du pipeline principal pour simplifier le draft
function checkWeatherEligibility(draftContext, currentLoadout, isDebugMode)
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

function checkAttributeEligibility(draftContext, currentLoadout, target, draftId, unit, isDebugModeA3)

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

function computeTOTWindow(draftContext, currentLoadout, Daytime, mission_ini, camp, task, draftId, isDebugModeA2)

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
function prepareUnitContext(draftContext, sideName)

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
