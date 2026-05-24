--To create the Air Tasking Order
--Initiated by Main_NextMission.lua
------------------------------------------------------------------------------------------------------- 
if not versionDCE then versionDCE = {} end
versionDCE["ATO_Generator.lua"] = "1.21.137"
------------------------------------------------------------------------------------------------------- 
	

if Debug.debug then
	print("START ATO_Generator.lua "..versionDCE["ATO_Generator.lua"].." =-=-=-=-=-=-=-=-=-=-=-=-=-=-=")
end

-- Déclaration du module
local eval = {}

local atoMainTaskFound = false

-- ⚠️ CORRECTION 1 : Il faut déclarer la table de buffer de manière locale 
-- sinon Lua va planter dès le premier debugLog.
local debugLogs = {} 

DraftProgress = {}

DraftStepIndex = {
	base = 1,
	aircraft = 2,
	task = 3,
	loadout = 4,
	weather = 5,
	target = 6,
	range = 7,
	route = 8,
	firepower = 9,
	score = 10,
	sortie = 11,
}

--firepower déjà assignée par target
--Pourquoi: éviter qu'un target continue à recevoir des packages inutiles
local targetAssignedFirepower = {}

--Enregistre l'étape la plus avancée atteinte par un squad
--Pourquoi: comprendre exactement où un squad bloque
local function updateDraftProgress(ctx, stepName, rejectReason)

	if not ctx or not ctx.unit then
		return
	end

	local stepIndex = DraftStepIndex[stepName] or 0

	local current = DraftProgress[ctx.unit.name]

	if not current or stepIndex >= current.stepIndex then

	local alreadySuccess = current and current.success

		DraftProgress[ctx.unit.name] = {

			unit = ctx.unit.name,
			task = ctx.task,
			target = ctx.targetName,
			loadout = ctx.loadoutName,

			step = stepName,
			stepIndex = stepIndex,

			rejectReason = rejectReason,

			success = alreadySuccess or (stepName == "sortie"),
		}
	end
end

local escortRejectReasons = {}

--Affiche le diagnostic final des squads
--Pourquoi: comprendre pourquoi un squad ne vole jamais
--Affiche le diagnostic final des squads
--Pourquoi: comprendre précisément pourquoi un squad bloque
local function printDraftProgressReport()

	print("\n========== DRAFT PROGRESS REPORT ==========")

	for unitName, data in pairs(DraftProgress) do

		if not data.success then
				
			local txt =
				unitName
				.." | step: "..tostring(data.step)

			if data.task then
				txt = txt.." | task: "..tostring(data.task)
			end

			if data.loadout then
				txt = txt.." | loadout: "..tostring(data.loadout)
			end

			if data.target then
				txt = txt.." | target: "..tostring(data.target)
			end

			if data.rejectReason then
				txt = txt.." | reject: "..tostring(data.rejectReason)
			end

			print(txt)
		end
	end

	print("===========================================\n")
end


--Valide une étape
--Pourquoi: suivre la progression du squad
local function validateStep(ctx, stepName)

	updateDraftProgress(ctx, stepName, nil)

	return true
end

--Rejette une étape
--Pourquoi: mémoriser le point de blocage
--Enregistre un rejet détaillé du pipeline
--Pourquoi: connaitre précisément où et pourquoi un draft échoue
local function rejectStep(draftContext, step, reason, data)

	if not draftContext.rejectReasons then
		draftContext.rejectReasons = {}
	end

	draftContext.rejectReasons[#draftContext.rejectReasons + 1] = {
		step = step,
		reason = reason,
		data = data,
	}

	--garde le premier vrai blocage rencontré
	if not draftContext.finalReject then
		-- draftContext.finalReject = {
		-- 	step = step,
		-- 	reason = reason,
		-- 	data = data,
		-- }
		local rejectPriority = {
			task = 1,
			target = 2,
			loadout = 3,
			firepower = 4,
			weather = 5,
			range = 6,
			route = 7,
			sortie = 8,
		}

		local currentPriority = 0
		if draftContext.finalReject
			and not draftContext.generatedSortie then
			currentPriority = rejectPriority[draftContext.finalReject.step] or 0
		end

		local newPriority = rejectPriority[step] or 0

		if newPriority >= currentPriority then

			draftContext.finalReject = {
				step = step,
				reason = reason,
				data = data,
			}
		end
	end
end

--Ajoute une raison de rejet dans le draft
--Pourquoi: comprendre pourquoi un draft/squad/target est refusé
--Ajoute une raison de rejet au draft courant
--Pourquoi: permettre d'expliquer pourquoi un draft/squad ne passe jamais
local function addRejectReason(draftContext, reason)

	if not draftContext then
		return
	end

	if not draftContext.rejectReasons then
		draftContext.rejectReasons = {}
	end

	if not draftContext.rejectCount then
		draftContext.rejectCount = {}
	end

	--évite les doublons simples
	if not draftContext.rejectReasons[reason] then
		draftContext.rejectReasons[reason] = true
	end

	--compteur détaillé
	if not draftContext.rejectCount[reason] then
		draftContext.rejectCount[reason] = 0
	end

	draftContext.rejectCount[reason] = draftContext.rejectCount[reason] + 1
end


--Vérifie si le loadout est compatible avec la météo actuelle
--Pourquoi: sortir la logique météo du pipeline principal pour simplifier le draft
local function checkWeatherEligibility(draftContext, currentLoadout, isDebugMode)

	local unit = draftContext.unit
	local task = draftContext.task

	local weatherEligible = true

	if mission.weather["clouds"]["density"] > 8 then

		local cloud_base = mission.weather["clouds"]["base"]
		local cloud_top = mission.weather["clouds"]["base"] + mission.weather["clouds"]["thickness"]

		if db_airbases[unit.base].elevation + 333 > cloud_base then
			if currentLoadout.adverseWeather == false then
				weatherEligible = false
				addRejectReason(draftContext, "weather")
			end
		else
			if currentLoadout.hCruise and currentLoadout.hCruise > cloud_base and currentLoadout.hCruise < cloud_top then			--cruise alt is in the clouds
				if currentLoadout.adverseWeather == false then																	--loadout is not adverse weather capable
					weatherEligible = false																						--not eligible for this weather
					addRejectReason(draftContext, "weather")
				end
			elseif currentLoadout.hAttack and currentLoadout.hAttack > cloud_base and currentLoadout.hAttack < cloud_top then		--attack alt is in the clouds
				if currentLoadout.adverseWeather == false then																	--loadout is not adverse weather capable
					weatherEligible = false																						--not eligible for this weather
					addRejectReason(draftContext, "weather")
				end
			end

			if task == "Strike" or task == "Anti-ship Strike" or task == "Reconnaissance" then										--extra requirement for A-G tasks
				if currentLoadout.hAttack > cloud_base then																		--attack alt is above cloud base
					if currentLoadout.adverseWeather == false then																--loadout is not adverse weather capable
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
					end
				end
			end
		end
	end

	return weatherEligible
end



local function checkLoadoutEligibility(currentLoadout, target, draftId, unit, isDebugModeA3)
	
	local debugLocal = " "..currentLoadout.name
	local weatherEligible = true
	if target.attributes and target.attributes[1] and target.attributes[1] ~= "" then
		-- Il faut que TOUS les attributs du target soient présents dans le loadout
		for _, target_attribute in ipairs(target.attributes) do
			debugLocal = debugLocal .. " /n target_attribute: " ..target_attribute
			local found = false
			for _, loadout_attribute in ipairs(currentLoadout.attributes or {}) do
					
				if target_attribute == loadout_attribute then
					found = true
					break
				else
					debugLocal = debugLocal .. " /n loadout_attribute: " ..loadout_attribute
				end
			end
			
			if not found then
				weatherEligible = false
				break -- Un attribut manquant suffit à rendre le loadout inéligible
			end
		end
	end

	if target.attributesCond then
		weatherEligible = eval.group(target.attributesCond, unit, isDebugModeA3)
	end

	if isDebugModeA3 then
		debugLog("draftId"..draftId.." AtoG passe A_10 checkLoadoutEligibility() debugLocal: "..tostring(debugLocal))
	end

	return weatherEligible
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
Playability_criterium = {
    { key = "active_unit",           value = nil }, -- Player unit is not active
    { key = "base",                  value = nil }, -- Player airbase is not operational
    { key = "ready_aircraft",        value = nil }, -- Player unit has no ready aircraft
    { key = "tot",                   value = nil }, -- Player aircraft type cannot operate at this time of day
    { key = "target",                value = nil }, -- No eligible mission available for player
    { key = "target_firepower",      value = nil }, -- Not enough ready aircraft for this mission
    { key = "weather",               value = nil }, -- Player aircraft type cannot operate in this weather
    { key = "target_range",          value = nil }, -- No eligible mission available for player

	{ key = "escort_tot",            		      value = nil }, -- 
    { key = "escort_target",         			   value = nil }, -- 
	{ key = "escort_weather",                  		value = nil }, -- 
    { key = "escort_target_range",             		value = nil }, -- 
    { key = "escort_target_firepower",             value = nil }, -- 

	{ key = "playerAssign_ATO",            		      value = nil }, -- 
    { key = "playerAssign_intercept",         			   value = nil }, -- 
	{ key = "playerAssign_intercept_hostile",                  		value = nil }, -- 
    { key = "playerAssign_SAR",             		value = nil }, -- 
    { key = "playerAssign_CAP",             value = nil }, -- 
    { key = "playerAssign_CAP_hostile",             value = nil }, -- 

}
-- function TrackPlayability(player_unit, criterium)																				--function that tracks whether a playability criterium has been met
-- 	if player_unit == true then																									--unit in question is playable by player
-- 		Playability_criterium[criterium] = true																					--set playability criterium to be met
-- 	end
-- end
function TrackPlayability(player_unit, criterium)
    if player_unit == true then
        for i, crit in ipairs(Playability_criterium) do
            -- crit.key peut être "3_ready_aircraft" ou "ready_aircraft" selon ta déclaration
            if crit.key == criterium or tostring(i).."_"..crit.key == criterium then
                crit.value = true
                break
            end
        end
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

	if multiPlaneSet
		and multiPlaneSet[sideName]
		and multiPlaneSet[sideName][unit.type]
	then
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

--Prépare tout le contexte UNIT du draft
--Pourquoi: sortir les validations unit/base/availability de la cascade principale
local function prepareUnitContext(draftContext, sideName)

	local unit = draftContext.unit

	if unit.inactive then
		-- rejectStep(draftContext, "unit", "inactive")
		return false
	end

	TrackPlayability(unit.player, "active_unit")

	local base = db_airbases[unit.base]

	if not base
		or base.inactive == true
		or not base.x
		or not base.y
	then
		rejectStep(draftContext, "base", "invalid_airbase")
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

	draftContext.aircraft_available = aircraft_available

	if aircraft_available <= 0 then
		rejectStep(draftContext, "NbAircraft", "no_aircraft_available")
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


-- local logFilePath = "Debug/Generator_debugLogs.txt"
-- local logBufferSize = 1000  -- Nombre de lignes avant écriture disque




-- -- Réinitialiser le fichier au démarrage
-- local function initDebugLogs()
-- 	local file = io.open(logFilePath, "w")
-- 	if file then
-- 		file:close()
-- 	end
-- end

-- local function flushDebugLogs()
-- 	local file = io.open(logFilePath, "a")
-- 	if file then
-- 		file:write(table.concat(debugLogs, "\n"))
-- 		file:write("\n")
-- 		file:close()
-- 	end
-- 	debugLogs = {}  -- vider le buffer
-- end

-- local function debugLog(message)
-- 	table.insert(debugLogs, message)
-- 	if #debugLogs >= logBufferSize then
-- 		flushDebugLogs()
-- 	end
-- end

-- local function debugLogBeforeCrash(message)
-- 	table.insert(debugLogs, message)

-- 	flushDebugLogs()

-- end

-- -- Initialiser le fichier
-- initDebugLogs()

-- ============================================================================
-- SÉCURITÉ & LOGS DE CONFIGURATION (En-tête du script)
-- ============================================================================

local logFilePath = "Debug/Generator_debugLogs.txt"
local logBufferSize = 1000  -- Nombre de lignes avant écriture disque

-- -- ⚠️ CORRECTION 1 : Il faut déclarer la table de buffer de manière locale 
-- -- sinon Lua va planter dès le premier debugLog.
-- local debugLogs = {} 

-- Réinitialiser le fichier au démarrage
local function initDebugLogs()
    local file = io.open(logFilePath, "w")
    if file then
        file:close()
    end
end

-- Écriture sur le disque
local function flushDebugLogs()
    -- ⚠️ SÉCURITÉ : On vérifie s'il y a des logs à écrire pour éviter d'ouvrir le fichier pour rien
    if #debugLogs == 0 then return end 
    
    local file = io.open(logFilePath, "a")
    if file then
        file:write(table.concat(debugLogs, "\n"))
        file:write("\n")
        file:close()
    end
    debugLogs = {}  -- Vider le buffer
end

-- Ajouter un log classique au buffer
-- ⚠️ CORRECTION 2 : Cette fonction DOIT être déclarée SANS 'local' (donc globale) 
-- OU alors définie TOUT EN HAUT pour que ton module 'eval' (et le reste du script) puisse la voir !
function debugLog(message)
    table.insert(debugLogs, tostring(message)) -- Sécurité : force la conversion en chaîne
    if #debugLogs >= logBufferSize then
        flushDebugLogs()
    end
end

-- Forcer l'écriture immédiate (ex: avant une zone à risque ou une fin de script)
function debugLogBeforeCrash(message)
    table.insert(debugLogs, tostring(message))
    flushDebugLogs()
end

-- Initialiser le fichier au chargement du script
initDebugLogs()

-- ============================================================================
-- FIN DE L'EN-TÊTE LOGS - Ton module 'eval' ou la suite du code commence ici
-- ============================================================================

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

-- Une fonction de log locale par défaut si debugLog n'est pas globale
local function log(msg)
    if debugLog then debugLog(msg) else print(msg) end
end

-- 1️⃣ eval.test (Anciennement evalTest)
function eval.test(key, value, unit, DEBUG)
    -- Cas 1 : plusieurs valeurs → OU implicite
    if type(value) == "table" then
        for _, oneValue in ipairs(value) do
            -- Appel récursif via le module
            if eval.test(key, oneValue, unit, DEBUG) then
                if DEBUG then log("[TEST A return true Cas 1 : plusieurs valeurs → OU implicite "..key.."] OK (OR)") end
                return true
            end
        end
        if DEBUG then log("[TEST B "..key.."] FAIL (OR)") end
        return false
    end

    -- Cas 2 : valeur simple
    if DEBUG then
        log("[TEST C Cas 2 : valeur simple "..key.." = "..tostring(value).."]")
    end

    -- string.lower crée une nouvelle chaîne, on le fait après le check de la table
    local lowerKey = string.lower(key)

    -- Note : string.find utilise des expressions régulières. 
    -- Si tu cherches juste le mot exact, ajoute `true` en 4e argument pour désactiver le regex (plus rapide).
    if string.find(lowerKey, "playersquad", 1, true) then
        if DEBUG then log("[TEST D playersquad "..key.."] ") end
        return value == true and (unit.player or unit.client)

    elseif string.find(lowerKey, "category", 1, true) then
        value = string.lower(tostring(value))
        if DEBUG then log("[TEST D "..key.."] ") end

        if string.find(value, "helico", 1, true) then
            -- Sécurité au cas où IsHelicopter n'est pas défini globalement
            local isHeli = _G.IsHelicopter or {} 
            if DEBUG then log("[TEST E "..key.."] ??? "..tostring(isHeli[unit.type])) end
            return isHeli[unit.type] ~= nil

        elseif string.find(value, "plane", 1, true) then
            local isHeli = _G.IsHelicopter or {}
            if DEBUG then log("[TEST F "..key.."] ") end
            return isHeli[unit.type] == nil
        end

    elseif string.find(lowerKey, "planetype", 1, true) then
        if DEBUG then log("[TEST G "..tostring(value).." ==? ] "..tostring(unit.type)) end
        return unit.type == value

    elseif string.find(lowerKey, "squadname", 1, true) then
        if DEBUG then log("[TEST H "..tostring(value).." ==? ] "..tostring(unit.name)) end
        return unit.name == value
    end

    if DEBUG then log("[TEST Z "..key.."] UNKNOWN → FALSE") end
    return false
end

-- 2️⃣ eval.group (Anciennement evalGroup)
function eval.group(group, unit, DEBUG)
    local op = group.op or "AND"
    if DEBUG then log("== EVAL GROUP ("..op..") ==") end

    local result = (op == "AND")

    -- Tests simples (clés dictionnaires)
    for key, value in pairs(group) do
        if key ~= "op" and type(key) ~= "number" then
            local testResult = eval.test(key, value, unit, DEBUG)
            
            if DEBUG then
                log("   -> "..key.." = "..tostring(testResult))
            end

            if op == "AND" and not testResult then
                return false
            elseif op == "OR" and testResult then
                return true
            end
        end
    end

    -- Sous-groupes (index numériques)
    for _, subGroup in ipairs(group) do
        local subResult = eval.group(subGroup, unit, DEBUG)

        if DEBUG then
            log("   -> SUBGROUP = "..tostring(subResult))
        end

        if op == "AND" and not subResult then
            return false
        elseif op == "OR" and subResult then
            return true
        end
    end

    return result
end

-- 3️⃣ eval.attributesCond (Anciennement evalAttributesCond)
function eval.attributesCond(cond, unit, DEBUG)
    if not cond then return true end
    return eval.group(cond, unit, DEBUG)
end

-- return eval

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


-- local multiPlaneSet = {}
multiPlaneSet = {}

-- for k=1, Multi.NbGroup do
-- 	--TODO beurk, à refaire ça propre
-- 	if not multiPlaneSet[Multi.Group[k].side] then multiPlaneSet[Multi.Group[k].side] = {} end
-- 	if not multiPlaneSet[Multi.Group[k].side][Multi.Group[k].PlaneType] then multiPlaneSet[Multi.Group[k].side][Multi.Group[k].PlaneType] = {} end
-- 	-- multiPlaneSet[Multi.Group[k].PlaneType][Multi.Group[k].task] = true

-- 	if not multiPlaneSet[Multi.Group[k].side][Multi.Group[k].PlaneType][Multi.Group[k].task] then multiPlaneSet[Multi.Group[k].side][Multi.Group[k].PlaneType][Multi.Group[k].task] = {} end
-- 	if not multiPlaneSet[Multi.Group[k].side][Multi.Group[k].PlaneType][Multi.Group[k].task]["NbPlane"] then multiPlaneSet[Multi.Group[k].side][Multi.Group[k].PlaneType][Multi.Group[k].task]["NbPlane"] = 0 end

-- 	multiPlaneSet[Multi.Group[k].side][Multi.Group[k].PlaneType][Multi.Group[k].task].NbPlane = Multi.Group[k].NbPlane + multiPlaneSet[Multi.Group[k].side][Multi.Group[k].PlaneType][Multi.Group[k].task].NbPlane
-- 	multiPlaneSet[Multi.Group[k].side][Multi.Group[k].PlaneType][Multi.Group[k].task].InitNbPlaneByTask =  multiPlaneSet[Multi.Group[k].side][Multi.Group[k].PlaneType][Multi.Group[k].task].NbPlane

-- 	if not multiPlaneSet[Multi.Group[k].side][Multi.Group[k].PlaneType].InitNbPlane then multiPlaneSet[Multi.Group[k].side][Multi.Group[k].PlaneType].InitNbPlane = 0 end
-- 			multiPlaneSet[Multi.Group[k].side][Multi.Group[k].PlaneType].InitNbPlane = multiPlaneSet[Multi.Group[k].side][Multi.Group[k].PlaneType].InitNbPlane + Multi.Group[k].NbPlane
-- end

for k = 1, Multi.NbGroup do
    -- 1️⃣ Mise en cache locale du groupe courant (Énorme gain CPU)
    local group = Multi.Group[k]
    local side  = group.side
    local pType = group.PlaneType
    local task  = group.task
    local count = group.NbPlane or 0

    -- 2️⃣ Initialisation sécurisée de l'arbre de tables (Vivification)
    if not multiPlaneSet[side] then 
        multiPlaneSet[side] = {} 
    end
    
    if not multiPlaneSet[side][pType] then 
        multiPlaneSet[side][pType] = { InitNbPlane = 0 } 
    end
    
    -- Raccourci vers le niveau "PlaneType" pour simplifier la suite
    local planeTypeData = multiPlaneSet[side][pType]

    if not planeTypeData[task] then 
        planeTypeData[task] = { NbPlane = 0, InitNbPlaneByTask = 0 } 
    end
    
    -- Raccourci vers le niveau "task"
    local taskData = planeTypeData[task]

    -- 3️⃣ Accumulation des données
    taskData.NbPlane            = taskData.NbPlane + count
    taskData.InitNbPlaneByTask  = taskData.NbPlane  -- Copie la valeur cumulée courante
    
    planeTypeData.InitNbPlane   = planeTypeData.InitNbPlane + count
end

if Debug.debug and Debug.Generator.affiche then
	_affiche(Multi, "ATO_G_A Multi: ")
	_affiche(multiPlaneSet, "ATO_G_B multiPlaneSet: ")
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
					if not unit.inactive and unit.type == multiGroup.PlaneType and side == multiGroup.side and unit.roster.ready < multiGroup.NbPlane   then
						unit.roster.ready = multiGroup.NbPlane * 2
						if Debug.debug then
							print("ATO_G_E set Nplane "..unit.type.." ready "..unit.roster.ready)
						end
					end
				end
			end
		end
	end

	--augmente la priority de la cible choisie
	for kGroupN, multiGroup in pairs(Multi.Group) do
		for targetN, target in pairs(targetlist[multiGroup.side]) do
			if not target.inactive and not target.priorityINIT and Multi.Target and target.titleName == Multi.Target[multiGroup.side] then
				target.priorityINIT = target.priority
				target.priority = target.priority * 4
				if Debug.debug then print("ATO_G_F multiGroup target.priority "..target.priority.." titleName "..target.titleName) end
				break
			end
		end
	end
end

--Retourne la config MP d'un side/type/task si elle existe
--Pourquoi: éviter les cascades de if et les accès nil dangereux
local function getMultiPlaneConfig(sideName, unitType, task)

	if not multiPlaneSet then
		return nil
	end

	if not multiPlaneSet[sideName] then
		return nil
	end

	if not multiPlaneSet[sideName][unitType] then
		return nil
	end

	if not multiPlaneSet[sideName][unitType][task] then
		return nil
	end

	return multiPlaneSet[sideName][unitType][task]
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
			debugLog(
				"draftId"..draftId .." AtoG BUILD_SORTIE "
				..idTemp .." aircraft_assign: " ..tostring(draftContext.state.futureAircraftAssign)
			)
		end

		--firepower apportée par cette sortie
		--Pourquoi: cumuler plusieurs squads sur une même cible
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
			targetPriority = target.priority,
			priorityIni = DeepCopy(target.priority),
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
			multiPlaneSet_B = multiPlaneSet,
			baseScore = 0,
			finalScore = 0,
		}

		draftSortiesEntry.target.titleName = target.titleName

		draftSortiesEntry.scoreAdd = 0.000011
		draftSortiesEntry.scoreCoef = 1

		local route_threat =
			draftContext.state.route.threats.ground_total
			+ draftContext.state.route.threats.air_total

		if task == "CAP" or task == "Intercept" or task == "SAR" then
			draftSortiesEntry.score = target.priority
		else
			draftSortiesEntry.score = target.priority / route_threat
		end

		draftSortiesEntry.baseScore = draftSortiesEntry.score
		draftSortiesEntry.finalScore = draftSortiesEntry.score

		draftSortiesEntry.debugContext = {
			rejectReasons = DeepCopy(draftContext.rejectReasons),
			overideMP_A = draftContext.overideMP_A,
			passPackmax = draftContext.passPackmax,
		}

		if not draftSorties[sideName] then
			draftSorties[sideName] = {}
		end

		draftSorties[sideName][#draftSorties[sideName] + 1] = draftSortiesEntry

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

		draftContext.generatedSortie = true

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
local function processEligibleLoadout( draftContext, sideName, task, target, target_name, unit, currentLoadout, Daytime, airbasePoint, draftId, isDebugModeA3, i_timmer01 )

	validateStep(draftContext, "loadout")

	--attention, overideMP_A garde une ancienne valeur a true
	draftContext.overideMP_A = false

	
	if ( target.base and  ((task == "Intercept" and target.base == unit.base) or (task == "SAR" and target.base == unit.base) ) or (task == "Transport" and target.base == unit.base) or (task == "Nothing" and target.base == unit.base)
		) or (task ~= "Intercept" and task ~= "Transport" and task ~= "Nothing" and task ~= "SAR") then	
		--intercept and transport missions are only assigned to units of a certain base as per targetlist	

		TrackPlayability(unit.player, "target")																							--track playabilty criterium has been met

		local mpConfig = getMultiPlaneConfig(sideName, unit.type, task)

		local debugMulti = ""
			
		if mpConfig then
		

			if Multi.Target and Multi.Target[sideName] then
				debugMulti = debugMulti.."\n"..("AtoG passe A_AAe Multi.Target[side] "..tostring(Multi.Target[sideName]) .. " ==? target_name? " .. tostring(target_name))
				if Multi.Target[sideName] == target_name  then
					debugMulti = debugMulti.."\n"..("AtoG passe A_AAf Multi.Target[side] "..tostring(Multi.Target[sideName]) .. " ==? target_name? " .. tostring(target_name).." "..unit.type.." "..tostring(task))
					draftContext.overideMP_A = true
					if target.powerfire and target.powerfire.max then
						if target.powerfire.max < mpConfig.NbPlane then
							target.powerfire.max = mpConfig.NbPlane + 1
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

		if isDebugModeA3 then
			debugLog("draftId"..draftId.." AtoG passe A_11b passPackmax? "..tostring(draftContext.passPackmax).." ||target.firepower.packmax: "..tostring(target.firepower.packmax))
		end

		-- local firepowerValid = (passHumain and (target.firepower.min <= AcftAvail[unit.name].available * currentLoadout.firepower)) or draftContext.overideMP_A 
		-- or draftContext.passPackmax
		--firepower individuelle apportée par ce squad
		--Pourquoi: permettre les packages collaboratifs
		local squadFirepower =
			AcftAvail[unit.name].available
			* currentLoadout.firepower

		local firepowerValid = false

		--cas normal: le squad peut satisfaire seul la cible
		if passHumain
		and squadFirepower >= target.firepower.min
		then
			firepowerValid = true
		end

		--cas MP joueur
		if draftContext.overideMP_A then
			firepowerValid = true
		end

		--package collaboratif
		--Pourquoi: autoriser les squads insuffisants seuls mais utiles collectivement
		if not firepowerValid and target.firepower.packmax and target.firepower.packmax > 1 then

			--évite les contributions ridicules
			local minimumContribution = target.firepower.min / target.firepower.packmax

			if squadFirepower >= minimumContribution then

				firepowerValid = true
				draftContext.passPackmax = true

				if isDebugModeA3 then
					debugLog(
						"draftId"..draftId
						.." A_12_ packmax contribution accepted "
						..unit.name
						.." squadFirepower: "
						..math.floor(squadFirepower)
						.." / minimumContribution: "
						..math.floor(minimumContribution)
					)
				end
			end
		end
			
		repeat

			if not passHumain then
				rejectStep( draftContext, "passHumain", "HumainRequired",nil)
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
					}
				)
				break
			end

			if isDebugModeA3 then
				debugLog("draftId"..draftId.." AtoG passe A_13  Befor weather Condition  || "..target_name)
			end

			TrackPlayability(unit.player, "target_firepower")																			--track playabilty criterium has been met

			local weatherEligible = checkWeatherEligibility(draftContext, currentLoadout, isDebugModeA3)

			if not weatherEligible then
				rejectStep( draftContext, "weather", "weather_not_eligible",
					{
						target = target.titleName,
						loadout = currentLoadout.name,
						daytime = Daytime,
					}
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

				--HEING?
				-- draftContext.overideMP_A = false

				-- for r = 1, multipack do																				--repeat draft sortie generation for the requirement amount of packages (may create different routes each time)

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
							
							if toTarget <= currentLoadout.range then		--basic feasibility check of range before performance intensive route calculations are done
								
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
												}
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
									}
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

							if remainingFirepowerNeeded <= 0 then

								if isDebugModeA3 then
									debugLog(
										"draftId"..draftId .." A_29_B target already satisfied "
										..target_name .." assigned: "..assignedFirepower .." / "..target.firepower.max
									)
								end

								break
							end

							-- local firepowerRequest = GetWeightedRandom(target.firepower.min, target.firepower.max, bias)
							local firepowerRequest = GetWeightedRandom( target.firepower.min, remainingFirepowerNeeded, bias )
							draftContext.aircraft_requested = firepowerRequest / currentLoadout.firepower

							if task == "Transport" then
								if mpConfig and mpConfig.NbPlane
								and draftContext.aircraft_requested < mpConfig.NbPlane
								and task == "Transport"
								then
									draftContext.aircraft_requested = mpConfig.NbPlane
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
							if draftContext.aircraft_requested > AcftAvail[unit.name].available then
								draftContext.state.futureAircraftAssign = math.floor(AcftAvail[unit.name].available)
							else
								draftContext.state.futureAircraftAssign = math.floor(draftContext.aircraft_requested)
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
								end

								--M11.z
								if mpConfig and mpConfig.NbPlane then
									if draftContext.state.futureAircraftAssign < mpConfig.NbPlane then
										draftContext.state.futureAircraftAssign = mpConfig.NbPlane
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
								mpConfig,
								draftId,
								isDebugModeA3
							)
							--mémorise la firepower déjà assignée à ce target
							--Pourquoi: empêcher les squads suivants de surcharger le target
							local generatedFirepower = currentLoadout.firepower * assignedAircraft

							targetAssignedFirepower[target_name] = (targetAssignedFirepower[target_name] or 0) + generatedFirepower

							if isDebugModeA3 then
								debugLog(
									"draftId"..draftId .." A_30 PACKAGE COMPLETE "
									..target_name .." targetAssignedFirepower/target.firepower.max: "
									..targetAssignedFirepower[target_name] .."/" ..target.firepower.max
								)
							end

						end

						draftContext.state.variant = draftContext.state.variant - 2																			--determines if while-loop does another route variant depending on Daytime
					end
				-- end
			end
		until true
	end
end



--///////////////////////------------MAIN------------/////////////////////////////////////
--///////////////////////------------MAIN------------/////////////////////////////////////
--///////////////////////------------MAIN------------/////////////////////////////////////

--creat draft sorties
for sideName, units in pairs(oob_air) do

	local draftId = 1
	if Debug.Generator.affiche then
		if Debug.Generator.SpyTarget then
			debugLog("draftId"..draftId.." \n\n"..Debug.Generator.SpyTarget)
		end
	end

	if units then

		for unitN, unit in pairs(units) do
			
			if unit.inactive and unit.player then
				print("AtoG attention, the player's squad is inactive. Activate it via DCE_Manager or directly in Init\\oob_air and Active\\oob_air ") os.execute 'pause'
			end

			--Contexte local du draft
			--Pourquoi: centraliser l'état du draft dès le début du pipeline
			local draftContext = {


				--debug
				debugId = draftId,
				rejectReasons = {},
				rejectCount = {},
				finalReject = nil,
				generatedSortie = false,

				--unit runtime
				unit = unit,
				unitName = unit.name,
				unitType = unit.type,

				--state runtime
				state = {},
			}

			--ATO_Generator_v2 :
			local unitReady = prepareUnitContext(draftContext, sideName)

			if unitReady then

				local isDebugModeA1 = Debug.Generator.affiche
					and string.find(Debug.Generator.chapter, "A")
					and (
						(Debug.Generator.SpySquad and Debug.Generator.SpySquad == unit.name)
						or (not Debug.Generator.SpySquad)
					)
	
				if isDebugModeA1 then debugLog("draftId"..draftId.." AtoG passe A_01 "..unit.type.." Befor roster.ready Condition  ") end

				-- local overRideReady = false
				local clientPlayer = false
				draftContext.clientPlayer = clientPlayer

				if Multi.NbGroup == 0 then clientPlayer = unit.player end
				if unit.player then PlayerSquad = unit end

				atoMainTaskFound = false
				for task, task_bool in pairs(unit.tasks) do																		--iterate through all tasks of unit		
					if isDebugModeA1 then
						debugLog("draftId"..draftId.." AtoG passe A_03b task: "..tostring(task).." task_bool: "..tostring(task_bool).."  available: "..tostring(AcftAvail[unit.name].available).." = ready:  "..tostring(unit.roster.ready) .." - unavailable: ".. tostring(#AcftAvail[unit.name].unavailable))
					end

					local MAIN_TASKS = {
						["Strike"] = true,
						["CAP"] = true,
						["Intercept"] = true,
						["CAS"] = true,
						["Transport"] = true,
						["SAR"] = true,
						["Runway Attack"] = true,
						["Anti-ship Strike"] = true,
						["Reconnaissance"] = true,
					}
					-- if task_bool and not BANNED_TASKS[task] then
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

									--ceci est un anti PBO_Corse66 ^^
									-- donne une alti aléatoire pour éviter de connaitre le type d'avion pas l'altitude habituellement utilisée
									if localLoadout.hCruise and localLoadout.hCruise > 2000 then
										local altiRandom = 0
										local RandomChance = math.random(0,100)

										if RandomChance < 50 then										--20% de chance d'avoir une alti de 1000 à 2000m de difference 
											altiRandom = math.random(100 ,200)

										elseif RandomChance < 70 then									--30% de chance d'avoir une alti de 1000m de difference
											altiRandom = math.random(0,100)
										end																--50% de chance d'avoir une alti de 0 de difference

										altiRandom = altiRandom *10 * (math.random(0, 1)*2-1)			--choisi si c'est une diff positive ou negative												
										localLoadout.hCruise = localLoadout.hCruise + altiRandom
										if localLoadout.hCruise < 300 then
											localLoadout.hCruise = 300
										end


										if localLoadout.hAttack then
											localLoadout.hAttack = localLoadout.hAttack + (altiRandom /2)
											if localLoadout.hAttack < 300 then
												localLoadout.hAttack = 300
											end
										end
									end


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
								end
							end
						end


						--mix the list of available loadouts so that you don't always have the same ones 
						--https://programming-idioms.org/idiom/10/shuffle-a-list/1313/lua
						for i = #unit_loadouts, 2, -1 do
							local j = math.random(i)
							unit_loadouts[i], unit_loadouts[j] = unit_loadouts[j], unit_loadouts[i]
						end

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

							--*****************************
							--get possible Time on Target
							draftContext = computeTOTWindow(draftContext, currentLoadout, Daytime, mission_ini, camp, task, draftId, isDebugModeA2)
							--*****************************

							if draftContext.state.tot_to ~= 0 then
								-- if tot_from ~= 0 or tot_to ~= 0 then																	--loadout has an eligible time on target
								if isDebugModeA2 then
									debugLog("draftId"..draftId.." AtoG passe A_06 ".." Befor targetlist Boucle")
								end

								if draftContext.state.tot_from == 0 then																				--player is only allowed to start at mission start
									TrackPlayability(unit.player, "tot")															--track playabilty criterium has been met
								end

								local i_timmer01 = 0
								for target_side_name, target_side in pairs(targetlist) do											--iterate through sides in targetlist				
									i_timmer01 = i_timmer01 +1
									if sideName == target_side_name then																--if the target is hostile
										local totalTarget = 0
										for target_name, target in pairs(target_side) do
											totalTarget = totalTarget + 1
										end

										local iTarget = 0
										for targetN, target in pairs(target_side) do											--iterate through all hostile targets
											iTarget = iTarget + 1
											if iTarget ~= 1 then
												draftId = draftId + 1
											end
											local target_name = target.titleName

											if not target.inactive and target.ATO then											--if target is active and should be added to ATO
												local isDebugModeA3 =
													Debug.Generator.affiche
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
													local loadoutEligible = checkLoadoutEligibility(currentLoadout, target, draftId, unit, isDebugModeA3)
													--**********************************************

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
														processEligibleLoadout( draftContext, sideName, task, target, target_name,
															unit, currentLoadout, Daytime, airbasePoint, draftId, isDebugModeA3, i_timmer01 )
														--**********************************************

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

			--debug final reject
			--Pourquoi: afficher précisément le dernier blocage rencontré pour ce squad
			if atoMainTaskFound
				and draftContext.finalReject
				and not draftContext.generatedSortie
			then

				local reject = draftContext.finalReject

				local txt =
					(unit and unit.name or "nil")
					.." | finalRejectStep: "..tostring(reject and reject.step or "nil")
					.." | reason: "..tostring(reject and reject.reason or "nil")
					.." | ==> | "

				if reject and reject.data and type(reject.data) == "table" then

					for k, v in pairs(reject.data) do
						txt = txt.." | "..tostring(k)..": "..tostring(v)
					end
				end

				print("\r\n"..txt)
			end

		end
	end
	
end
-- printDraftProgressReport()


print("-")
print("ATO Generating Sortie (" .. status_counter_sorties .. ") - Complete")
debugLog("\n"..("ATO Generating Sortie (" .. status_counter_sorties .. ") - Complete"))

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
						" /Prioriry/ " ..tostring(draft.priorityIni)..
						" /Nb/ " ..draft.number..
						" /flights/ " ..tostring(draft.flights)..
						" /Type/ "..draft.type..
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
local function addSupportToDraft( draft, unitSupport, uSupportLoadout, sptTask, route, side, playable_II,
     overideMP_B, isDebugModeB, multiPlaneSet_B, remain_air_total, support_requirement, support_tot_from, support_tot_to, wk)

	TrackPlayability(unitSupport.player, "escort_target_range")									--track playabilty criterium has been met

	local debuGenTxt1545 = "\n"..(tostring(draft.id).." AtoG II pass B_17  ")

	--determine number of escorts
	local escort_num = 0
	local escort_max = 0
    
    local uniqueBonus = false
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

		--TODO revoir ça
		-- if totalPlanePerTask[side][task] and totalPlanePerTask[side][task]/2 >= escort_num then
		-- 	draft.score = draft.score + (1 * draft.loadout.firepower) * draft.target.priority
		-- end

		debuGenTxt1545 = debuGenTxt1545.."\n"..(tostring(draft.id).." AtoG II pass_SEAD B "..unitSupport.type.." "..sptTask.." "..escort_num.." NbTotalSupport: "..draft.support[sptTask]["NbTotalSupport"].." draft.score: "..draft.score)
		debuGenTxt1545 = debuGenTxt1545.."\n"..("-------------------- escort_num: "..(draft.route.threats.SEAD_offset / uSupportLoadout.firepower).. "= SEAD_Offset: "..draft.route.threats.SEAD_offset.." /firepower "..uSupportLoadout.firepower
												)


	elseif sptTask == "Escort" then
		if draft.support[sptTask]["escort_max"] ~= 999 then
			escort_num = draft.support[sptTask]["escort_max"] - draft.support[sptTask]["NbTotalSupport"]	-- modification M11.x : Multiplayer	(x: EscorteTot-max)

			debuGenTxt1545 = debuGenTxt1545.."\n"..(tostring(draft.id).." AtoG II pass_Escort B "..unitSupport.type.." "..sptTask.." "..escort_num.." NbTotalSupport: "..draft.support[sptTask]["NbTotalSupport"])

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

			debuGenTxt1545 = debuGenTxt1545.."\n"..(tostring(draft.id).." AtoG II pass_Escort I "..unitSupport.type.." "..sptTask.." "..escort_num)

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

		debuGenTxt1545 = debuGenTxt1545.."\n"..(tostring(draft.id).." AtoG II pass_Escort J "..unitSupport.type.." "..sptTask.." escort_num: "..escort_num.." available: "..AcftAvail[unitSupport.name].available)

	end

	debuGenTxt1545 = debuGenTxt1545.."\n"..(tostring(draft.id).." AtoG II pass_Escort P "..unitSupport.type.." "..sptTask.." "..escort_num)


	--*********************************************************************************
	-- modification M11.o multiplayer**************************************************
	local txtDebug = ""
	if multiPlaneSet_B  then
		txtDebug = txtDebug .. " passeA ".."/n"

		if multiPlaneSet_B[side] and multiPlaneSet_B[side][unitSupport.type] and multiPlaneSet_B[side][unitSupport.type][sptTask] then	
		
			--si l'avion de support est déjà utilise en MAIN, on enleve la qté dejà utilisé
			if multiPlaneSet_B and multiPlaneSet_B[side] and multiPlaneSet_B[side][draft.type] and multiPlaneSet_B[side][draft.type][draft.task] then

				multiPlaneSet_B[side][draft.type][draft.task].NbPlane = multiPlaneSet_B[side][draft.type][draft.task].InitNbPlaneByTask - draft.number
				txtDebug = txtDebug .. "    passeB NbPlane: "..multiPlaneSet_B[side][draft.type][draft.task].NbPlane.." draft.task: "..tostring(draft.task).."/n"

			end


			playable_II = true

			if escort_num < multiPlaneSet_B[side][unitSupport.type][sptTask].NbPlane then
				escort_num =  multiPlaneSet_B[side][unitSupport.type][sptTask].NbPlane
				txtDebug = txtDebug .. "    passeC "..escort_num.."/n"
			elseif escort_num > multiPlaneSet_B[side][unitSupport.type][sptTask].NbPlane then
				escort_num =  multiPlaneSet_B[side][unitSupport.type][sptTask].NbPlane
				txtDebug = txtDebug .. "    passeD "..escort_num.."/n"
			end

			
			if escort_num >= 1 then
				draft.score = draft.score * 1.2 + 1000
				draft.scoreAdd =  draft.scoreAdd + 1000
				draft.scoreCoef =  draft.scoreCoef * 1.2
				txtDebug = txtDebug .. "    passeE "..draft.score.."/n"
			end

			txtDebug = txtDebug .. "    passeF "..draft.score.."/n"

			txtDebug = txtDebug .. "    passeG NbPlane "..multiPlaneSet_B[side][unitSupport.type][sptTask].NbPlane.."/n"
			txtDebug = txtDebug .." 	passeH InitNbPlaneByTask: "..tostring(multiPlaneSet_B[side][unitSupport.type][sptTask].InitNbPlaneByTask)

			-- Marquer l'unité comme vérifiée
			multiPlaneSet_B[side][unitSupport.type][sptTask].checked = true

			-- Vérification si tous les éléments sont cochés
			local fullMP_Plane = true
			for typeM, tasksM in pairs(multiPlaneSet_B[side]) do
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
			if fullMP_Plane and not uniqueBonus then
				draft.score = draft.score * 2000
				draft.scoreCoef =  draft.scoreCoef * 2000

				uniqueBonus = true

				-- print(tostring(draft.id).." "..draft.score)	
				txtDebug = txtDebug .. "    passeI uniqueBonus "..draft.score.."/n"																		
			end

		end


		if isDebugModeB then
			debugLog(debuGenTxt1545..draft.id.." AtoG II pass B_20a2. escort_num "..tostring(escort_num).." txtDebug: "..txtDebug   .." |score: "..tostring(draft.score))
		end

	end

	if Multi.NbGroup == 0 then
		playable_II = unitSupport.player
	end

	local wi = 1

	if isDebugModeB then
		debugLog(draft.id.." AtoG II pass B_21c Id "..tostring(draft.id).." "..unitSupport.type.." "..unitSupport.name.." escort_num "..tostring(escort_num).." "..draft.target_name.." NbTotalSupport: "..draft.support[sptTask]["NbTotalSupport"] )
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
		debugLog(draft.id.." AtoG II pass B_21d Id "..tostring(draft.id).." "..unitSupport.type.." "..unitSupport.name.."".." escort_num "..tostring(escort_num).." "..draft.target_name.." NbTotalSupport: "..draft.support[sptTask]["NbTotalSupport"].." entryEscortNum: "..tostring(entryEscortNum).." free_slot: "..tostring(free_slot and " free_slot: true " or " free_slot: false ") )
	end

	if entryEscortNum >= 1 and free_slot then

		draft.support[sptTask]["NbTotalSupport"] = futureNbTotalSupport
		draft.support[sptTask]["escort_max"] = escort_max

		if isDebugModeB then
			debugLog(tostring(draft.id).." AtoG II pass B_9999 Add In draft.support ")
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
			priorityIni = draft.priorityIni,
			support_requirement = support_requirement,
			client = unitSupport.client,
		}

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

		-- draft.route.threats.air_total = route_threat_recalc
		draft.route.threats.air_total = route_threat_recalc

	elseif sptTask == "Escort Jammer" then
		draft.route.threats.ground_total = draft.route.threats.ground_total / 2 
	end


	-- local route_threat_New = draft.route.threats.ground_total + draft.route.threats.air_total
	local route_threat_New = draft.route.threats.ground_total + draft.route.threats.air_total

	if route_threat_New ~= route_threat_OLD then
		
		local testScore = draft.priorityIni / route_threat_New
		testScore = testScore * draft.scoreCoef + draft.scoreAdd

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
		debugLog(draft.id.." AtoG II pass B_22 escort_num "..tostring(escort_num).." "..unitSupport.type.." target_name: "..tostring(draft.target_name)  .." |score: "..tostring(draft.score))
	end

end


--create additional draft sorties with support flights assigned
local wk = 1
local i_timmer02 = 0
-- local uniqueBonus = false

--inversion des 2 boucles draft_sortie en premier, oob_air ensuite, pour homogeniser les chances de sortie de tous les escadrons support
for sideName, draftT in pairs(draftSorties) do
	-- for draft_n, draft in ipairs(Draft_sorties[sideName]) do													--iterate through all draft sorties beginning with the highest scored
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

		--place en premier les unites des joueurs multi

		-- if multiPlaneSet.blue then
		-- 	for o = #oob_air["blue"], 1, -1 do
		-- 		if oob_air["blue"][o] and oob_air["blue"][o].type ==  multiPlaneSet.blue[oob_air["blue"][o].plane] 
		-- 		and oob_air["blue"][o].task ==  multiPlaneSet.blue[oob_air["blue"][o].task]  then	
		-- 			table.remove(oob_air["blue"], o)																		
		-- 		end
		-- 	end
		-- end


		if multiPlaneSet.blue then
			for o = 1, #oob_air["blue"] do
				local oob = oob_air["blue"][o]
				if multiPlaneSet.blue[oob.type] and oob and oob.tasks then
					for taskName, taskValue in pairs(oob.tasks) do
						if taskName == multiPlaneSet.blue.task then
							-- Décaler les éléments de la position 1 à o-1 vers la droite
							table_move(oob_air["blue"], 1, o-1, 2)
							-- Mettre l'élément trouvé en tête de la table
							oob_air["blue"][1] = oob
							-- Supprimer l'élément à sa position originale (qui a été décalée)
							table.remove(oob_air["blue"], o + 1)
							break -- Si un seul déplacement est requis, on peut quitter la boucle ici
						end
					end
				end
			end
		end

		if multiPlaneSet.red then
			for o = 1, #oob_air["red"] do
				local oob = oob_air["red"][o]
				if multiPlaneSet.red[oob.type] and oob and oob.tasks then
					for taskName, taskValue in pairs(oob.tasks) do
						if taskName == multiPlaneSet.red.task then
							-- Décaler les éléments de la position 1 à o-1 vers la droite
							table_move(oob_air["red"], 1, o-1, 2)
							-- Mettre l'élément trouvé en tête de la table
							oob_air["red"][1] = oob
							-- Supprimer l'élément à sa position originale (qui a été décalée)
							table.remove(oob_air["red"], o + 1)
							break -- Si un seul déplacement est requis, on peut quitter la boucle ici
						end
					end
				end
			end
		end


		--tag multiPlaneSet_B Présent pour l'avion MAIN

		local multiPlaneSet_B = draft.multiPlaneSet_B or {}

		if multiPlaneSet_B and multiPlaneSet_B[sideName] and multiPlaneSet_B[sideName][draft.type] and multiPlaneSet_B[sideName][draft.type][draft.task] then
			multiPlaneSet_B[sideName][draft.type][draft.task].checked = true
		end

		local remain_SEAD_offset = draft.route.threats.SEAD_offset
		local remain_air_total = draft.route.threats.air_total

		-- -- Variables temporaires anti-cascade
		-- local temp_ground_total = draft.route.threats.ground_total
		-- local temp_air_total = draft.route.threats.air_total
		-- local temp_score = draft.score
		-- local temp_tot_from = draft.tot_from
		-- local temp_tot_to = draft.tot_to

		for side, units in pairs(oob_air) do
			
			if units and units ~= nil then
				for unitN, unitSupport in pairs(units) do

					local overideMP_B = false
				
					if side == sideName and unitSupport.inactive ~= true and db_airbases[unitSupport.base] and db_airbases[unitSupport.base].inactive ~= true and (  (AcftAvail[unitSupport.name] and AcftAvail[unitSupport.name].available > 0))  and db_airbases[unitSupport.base].x  then	--if unit is active, its base is active and has available aircraft -- ATO_G_debug01 Fin de campagne					

						if isDebugModeB then
							debugLog(draft.id.." AtoG II pass B_02_a draft.: "..draft.type.." OOBunit: "..unitSupport.type 
							.." || "..tostring(unitSupport.base).." || "..tostring(unitSupport.name)
							.." "..tostring(draft.score)
							)
						end

						for sptTask, task_bool in pairs(unitSupport.tasks) do
							if task_bool then
								local playable_II = false
								local reserveClient = false

								if isDebugModeB then
									debugLog(draft.id.." AtoG II pass B_03 task.: "..tostring(sptTask))
								end


								--//**MULTIPLAYER--**//
								if multiPlaneSet[side] and multiPlaneSet[side][unitSupport.type] and multiPlaneSet[side][unitSupport.type][sptTask] then

									if not Multi.Target and draft.task ~= "SAR" and draft.task ~= "CAP" then
										Multi.Target = {}
										Multi.Target[side] = draft.target_name
										
										if isDebugModeB then
											debugLog(draft.id.." AtoG II pass B_04 draft.: "..draft.type.." OOBunit: "..unitSupport.type.." overideMP_B?: "..tostring(overideMP_B))
										end
									end

									if Multi.Target[side] == draft.target_name  then

										--ici, on reserve la place pour un type d'avion prevu pour le MP
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
								--//**MULTIPLAYER--**//

							
								--**cet overideMP_B donne trop d'avion
								if overideMP_B or (( draft.task ~= "CAP" and draft.task ~= "Intercept" ) 
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
									table.sort(uSupportloadouts, function(a,b) return a.standoff > b.standoff end)

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
												debugLog(draft.id.." AtoG II pass B_10 overideMP_B: "..tostring(overideMP_B).." task: "..tostring(sptTask) .." |draft.loadout.support[task]: "..tostring(draft.loadout.support[sptTask]).." draft.support[task][escort_max]: "..tostring(draft.support[sptTask]["escort_max"]).." draft.support[task][NbTotalSupport]: "..tostring(draft.support[sptTask]["NbTotalSupport"]))
											end

											i_timmer02 = i_timmer02 +1
											if (draft.loadout.support and draft.loadout.support[sptTask])
												and ( (tonumber(draft.support[sptTask]["NbTotalSupport"]) < tonumber(draft.support[sptTask]["escort_max"]) ) ) then

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
													if campMod.strikeOnlyWithEscorte then
														support_requirement = true
													end
												elseif sptTask == "Escort" then
													if draft.route.threats.air_total > 0.5 then												--draft sortie has an air threat
														support_requirement = true
													end
													if campMod.strikeOnlyWithEscorte then
														support_requirement = true
													end
												elseif sptTask == "Escort Jammer" then
													if draft.route.threats.SEAD_offset > 0 or draft.route.threats.air_total > 0.5 then		--draft sortie has either a SEAD offest requirement or an air threat
														support_requirement = true
													end
													if campMod.strikeOnlyWithEscorte then
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
																	
																	addSupportToDraft( draft, unitSupport, uSupportloadouts[l], sptTask, route, side, playable_II,
																						overideMP_B, isDebugModeB, multiPlaneSet_B, remain_air_total, support_requirement,
                                                                                        support_tot_from, support_tot_to, wk
																					)

                                                                    -- if result then
                                                                    --     temp_ground_total = result.ground_total
                                                                    --     temp_air_total = result.air_total
                                                                    --     temp_score = result.score
                                                                    --     temp_tot_from = result.tot_from
                                                                    --     temp_tot_to = result.tot_to
                                                                    -- end

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
							end
						end
					end
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
						" /Prioriry/ " ..tostring(draft.priorityIni)..
						" /Name/ " ..tostring(draft.name)..
						" /Nb/ " ..draft.number..
						" /flights/ " ..tostring(draft.flights)..
						" /Type/ "..draft.type..
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
				for planeTask_N, planeTask in pairs(draft.support) do
					for taskName, task in pairs(planeTask) do

						if type(task) == "table" and task.target_name and task.loadout then

							debugLog(	"    ---> Nsupport " ..planeTask_N.." ".. taskName..
									" /Id/ " ..tostring(task.id)..
									" /Nb/ " ..task.number..
									" /escort_max/ " ..tostring(planeTask.escort_max)..
									" /SupportName/ "..task.name..
									" /Type/ "..task.type..
									" /Task/ "..task.task..
									" /NbTotSupt/ " ..tostring(task.NbTotalSupport)..
									" /Target/ "..task.target_name..
									" /overideMP_B/ "..tostring(task.overideMP_B)..
									" /loadout/ "..tostring(task.loadout.loadout_name)
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

local function rejectDraft(draft, sujet, cause)
	local tabRejected = {}
	tabRejected["sujet"] = sujet
	tabRejected["cause"] = cause
	tabRejected["ligne"] = SafeGetLine()

	table.insert(draft["rejected"], tabRejected)
end

local function addEscortRejectReason(squadName, reason)
	if not escortRejectReasons[squadName] then
		escortRejectReasons[squadName] = {}
	end

	table.insert(escortRejectReasons[squadName], reason)
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

				local override_MP_C = false

				-- if draft.overideMP_B and draft.main_overideMP then
				if draft.overideMP_B then
					override_MP_C = true
				end


				local isDebugModeC = 
					-- Debug.Generator.affiche and string.find(Debug.Generator.chapter, "C")
					-- 	and ( Debug.Generator.SpySquad and Debug.Generator.SpySquad == draft.name
					-- 	or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == draft.target_name ))

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

				if draft.loadout.minscore == nil or draft.score >= draft.loadout.minscore then					--draft sortie has no minimum score requirement or minimum score requirement is satisified		
				
					-- if draft.multipack > 0 then												--target does not have a requirment for a specific number of packages, or still needs more packages		
					if multipackByTargetName[draft.target_name]["nbPack"] > 0 then

						if draft.target.firepower.max > 0 and draft.target.firepower.max >= draft.target.firepower.min then	--the target of this draft sortie must have a need for firepower above the minimum firepower threshold	
							local available = AcftAvail[draft.name].unassigned											--shortcut for available aircraft for this draft sortie					

							local requestedNumber = draft.number -- copie locale de travail pour éviter de modifier le draft original et provoquer des effets de bord entre validations

							--TODO ajouter ici la possibilité d'autre squad de les aider, donc leur qté d'avion dispo
							--pass packmax
							-- local passPackmax
							-- if multipackByTargetName[draft.target_name]["nbPack"] > 1 then
							-- 	if multipackByTargetName[draft.target_name].supporTotal >= 2 then 
							-- 		--TODO, ici il faut vraiment trouver le nb de support qu'il aura apres
							-- 		--c'est la clef
							-- 		passPackmax = true
							-- 	end
							-- end

							local passPackmax
							if draft.target.firepower and draft.target.firepower.packmax and draft.target.firepower.packmax > 1 then
								if available >= draft.number then 
									passPackmax = true
								end
							end

							
							if (available * draft.loadout.firepower >= draft.target.firepower.min and draft.number * draft.loadout.firepower >= draft.target.firepower.min) or passPackmax then	--enough aircraft are available to satisfy minimum firepower requirement for target						

								if draft.target.firepower.packmin == nil or available * draft.loadout.firepower >= (draft.target.firepower.packmin - 1) * draft.target.firepower.max + draft.target.firepower.min then	--if the target has a minimum package number requirement, sufficient aircraft are available from this unit to satisfy it					

									local limitMP = true   --TODO a revoir, semble inutile

									if isDebugModeC and multiPlaneSet and multiPlaneSet[side] and multiPlaneSet[side][draft.type] and multiPlaneSet[side][draft.type][draft.task] then
										debugLog(draft.id.." AtoG passe C_00_b  ".." "..draft.type
											.." available: "..tostring(available)
											.." < NbPlane? ".. tostring(multiPlaneSet[side][draft.type][draft.task].NbPlane)
											.." main_overideMP?: "..tostring(draft.main_overideMP)
											.." overideMP_B?: "..tostring(draft.overideMP_B))
									end

									if (draft.flights == nil or draft.number <= available or draft.main_overideMP or passPackmax) and limitMP then											--for targets with station time (multiple flights), continue only if sufficient aircraft are availabe. Additional lower scored sorties with less airctaft required will come later 

										--adjust the number of requested aircraft to the number of available aircraft
										-- if draft.number > available and not draft.main_overideMP then

										-- 	draft.number = available

										-- 	if isDebugModeC then
										-- 		debugLog(draft.id.." AtoG passe C_00_c  number "..tostring(draft.number))
										-- 	end

										-- end

										if requestedNumber > available and not draft.main_overideMP then

											requestedNumber = available

											if isDebugModeC then
												debugLog(draft.id.." AtoG passe C_00_c requestedNumber "..tostring(requestedNumber))
											end

										end

										--check if there are enough supports available if supports are required		
										local support_available = true
										-- local escortRejectReasons = {}
										-- local supportMandatory = true					

										local need = {}																														--collect the total number of aircraft needed from each unit to complete the package
										-- need[draft.name] = draft.number																								--number of main body aircraft 
										need[draft.name] = requestedNumber
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

										if campMod.strikeOnlyWithEscorte and not draft.loadout.self_escort then
											if (db_loadouts[draft.type]["Anti-ship Strike"] or db_loadouts[draft.type]["Strike"])  then	
												local break_loop = false
												for n_squad, squad in pairs(oob_air[side]) do

													if isDebugModeC then
														debugLog(draft.id.." ".." AtoG III passe SWE _01 "..draft.type.." "..squad.type)
													end

													if draft.main_overideMP or ((squad.tasks["Anti-ship Strike"]  or squad.tasks["Strike"] ) and squad.type == draft.type) then
														local needSupport = {}																														--collect the total number of aircraft needed from each unit to complete the package																							--number of main body aircraft 
														local availSupport = {}																													--collect the maximal number of available aircraft from this unit (biggest number of all tasks)

														if not needSupport[draft.name] then needSupport[draft.name] = 0 end
														if not availSupport[draft.name] then availSupport[draft.name] = 0 end
														-- needSupport[draft.name] =  DeepCopy(draft.number)
														needSupport[draft.name] = requestedNumber

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

														--TODO encore utile ça?												
														for Sname,_ in pairs(needSupport) do 
															if needSupport[Sname] - (needSupport[Sname] * 0.25)  > availSupport[Sname] then	
																
																support_available = false																									--not enough support available
																	
																local sujet = draft.id.." BOMBARDIER NECESSITANT ESCORTE()support_available if needSupport[Sname] - (needSupport[Sname] * 0.15) > availSupport[Sname]"
																local cause = { [1] =  needSupport[Sname] - (needSupport[Sname] * 0.25), [2] = availSupport[Sname], }

																rejectDraft(draft, sujet, cause)
															end
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
										dispoTmp[draft.name].unassigned = dispoTmp[draft.name].unassigned - requestedNumber


										
										-- for supportTask, supports in pairs(draft.support) do

										-- 	if not support_available then
										-- 		break
										-- 	end

										-- 	if type(supports) == "table" then

										-- 		for supportName, support in pairs(supports) do

										-- 			if not support_available then
										-- 				break
										-- 			end

										-- 			if type(support) == "table" then

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
											if multiPlaneSet[side] and multiPlaneSet[side][draft.type] then
												MPOverride_C = true
											end

											-- if passPackmax then

											-- end

											if support.support_requirement and mission_ini.strikeOnlyWithEscorte and (support.number >= 2 and dispoTmp[support.name].unassigned < 2 and draft.task ~= supportTask) and not MPOverride_C and not passPackmax then

												if isDebugModeC then
													debugLog(draft.id.." AtoG passe C_00_h  we don't accept a single aircraft as escort supportTask "..supportTask.." draft.task "..tostring(draft.task))
												end

												escortDiagnostic.rejected[#escortDiagnostic.rejected + 1] =
													support.name
													.." task:"..tostring(supportTask)
													.." need:"..tostring(support.number)
													.." dispo:"..tostring(dispoTmp[support.name].unassigned)
													
											
												support_available = false																									--not enough support available

												local sujet = support.id.." type: "..support.type.." we don't accept a single aircraft as escort "..supportName
												local cause = { "support.number: ",support.number, "unassigned:" , tostring(dispoTmp[support.name].unassigned), " available: ", tostring(dispoTmp[support.name].aircraft_available), "supportName: ", tostring(supportName), " task: ", tostring(draft.task)  }

												rejectDraft(draft, sujet, cause)

											else
												escortDiagnostic.accepted[#escortDiagnostic.accepted + 1] =
													support.name
													.." task:"..tostring(supportTask)
													.." assigned:"..tostring(support.number)
													
												dispoTmp[support.name].unassigned = dispoTmp[support.name].unassigned - support.number
											end

										end
										-- 		end
										-- 	end
										-- end

										-- for supportTask, supports in pairs(draft.support) do																							--iterate through support in draft sortie
										-- 	if not support_available then
										-- 		break
										-- 	end
										-- 	if support_available and type(supports) == "table" then
										-- 		for supportName, support in pairs(supports) do																							--iterate through support in draft sortie
										-- 			if 	type(support) == "table"  then --and support.name ~= nil	

										-- 				-- if support.number == nil or dispoTmp[support.name].unassigned == nil then
										-- 				if support.number == nil or not support.name or not dispoTmp[support.name] or dispoTmp[support.name].unassigned == nil then
										-- 					-- print("AtoG bugA1 supportTask|"..supportTask.."|supportName:|"..tostring(supportName).."|"..tostring(support.name).." no unassigned "..tostring(support.number))
										-- 					if isDebugModeC then
										-- 						debugLog(draft.id.." AtoG bugA1 supportTask|"..supportTask.."|supportName:|"..tostring(supportName).."|"..tostring(support.name).." no unassigned "..tostring(support.number))
										-- 					end
										-- 				end


										-- 				--si c'est un task d'une demande MP, on chunte la restrition plus loin
										-- 				--TODO pourquoi le coef est plus important sur d'autre élément que lorsqu'on demande notre target?
										-- 				local MPOverride_C = false
										-- 				if multiPlaneSet[side] and multiPlaneSet[side][draft.type] then
										-- 					MPOverride_C = true
										-- 				end

										-- 				-- if passPackmax then

										-- 				-- end

										-- 				if support.support_requirement and mission_ini.strikeOnlyWithEscorte and (support.number >= 2 and dispoTmp[support.name].unassigned < 2 and draft.task ~= supportTask) and not MPOverride_C and not passPackmax then

										-- 					if isDebugModeC then
										-- 						debugLog(draft.id.." AtoG passe C_00_h  we don't accept a single aircraft as escort supportTask "..supportTask.." draft.task "..tostring(draft.task))
										-- 					end

										-- 					escortDiagnostic.rejected[#escortDiagnostic.rejected + 1] =
										-- 						support.name
										-- 						.." task:"..tostring(supportTask)
										-- 						.." need:"..tostring(support.number)
										-- 						.." dispo:"..tostring(dispoTmp[support.name].unassigned)
																
														
										-- 					support_available = false																									--not enough support available

										-- 					local sujet = support.id.." type: "..support.type.." we don't accept a single aircraft as escort "..supportName
										-- 					local cause = { "support.number: ",support.number, "unassigned:" , tostring(dispoTmp[support.name].unassigned), " available: ", tostring(dispoTmp[support.name].aircraft_available), "supportName: ", tostring(supportName), " task: ", tostring(draft.task)  }

										-- 					rejectDraft(draft, sujet, cause)

										-- 				else
										-- 					escortDiagnostic.accepted[#escortDiagnostic.accepted + 1] =
										-- 						support.name
										-- 						.." task:"..tostring(supportTask)
										-- 						.." assigned:"..tostring(support.number)
																
										-- 					dispoTmp[support.name].unassigned = dispoTmp[support.name].unassigned - support.number
										-- 				end

										-- 			end
										-- 		end
										-- 	end
										-- end



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

																rejectDraft(draft, sujet, cause)
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

															if planeSupport ~= "NbTotalSupport"
															and planeSupport ~= "escort_max"
															and type(support) == "table"
															and support.name then

																foundOnePlane = true
																break
															end
														end
													end

													if not foundOnePlane then

														support_available = false

														local sujet =
															draft.id
															.." type: aucun SUPPORT "
															..tostring(loadoutNeedTask)

														local cause = {
															[1] = tostring(loadoutNeedTask),
														}

														rejectDraft(draft, sujet, cause)

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

															if AcftAvail[support.name].unassigned <= 0 and not passPackmax then

																support_available = false

																local sujet =
																	draft.id
																	.." type: "
																	..support.type
																	.." SUPPORT aircraft <= 0"

																local cause = {
																	[1] = AcftAvail[support.name].unassigned,
																}

																rejectDraft(draft, sujet, cause)

																return
															end
														end
													end
												end
											end
										end


										if support_available
											and not draft.main_overideMP
											and not passPackmax
											and mission_ini.strikeOnlyWithEscorte then

											validateEscortAvailability()

											if support_available then
												validateMandatorySupports()
											end

											if support_available then
												validateSupportRemainingAircraft()
											end
										end

										-- if support_available and not draft.main_overideMP and not passPackmax and mission_ini.strikeOnlyWithEscorte then

										-- 	local tracing = false
										-- 	local txtTracing = ""

										-- 	if isDebugModeC then
										-- 		debugLog(draft.id.." AtoG passe C_01_a  strikeOnlyWithEscorte number "..tostring(draft.number))
										-- 	end

										-- 	local tmpTxt = ""
										-- 	--draft.support[task][unit.type] = {
										-- 	for supportTask,_support in pairs(draft.support) do																							--iterate through support in draft sortie
										-- 		tmpTxt = tmpTxt .."\r\n_A_ supportTask: "..tostring(supportTask)

										-- 		if support_available and type(_support) == "table" then
										-- 			tmpTxt = tmpTxt .."\r\n _B_ "

										-- 			for supportUnitType, support in pairs(_support) do																							--iterate through support in draft sortie
										-- 				tmpTxt = tmpTxt .." \r\n_C_supportName: "..tostring(supportUnitType)

										-- 				if supportUnitType ~= "escort_max_A_" and supportUnitType ~= "NbTotalSupport" and type(support) == "table" then
										-- 					tmpTxt = tmpTxt .."\r\n _D_support.number: "..tostring(support.number).." >? "..AcftAvail[support.name].unassigned

										-- 					if support.name then
										-- 						if support.number > AcftAvail[support.name].unassigned then
										-- 							if supportTask == "Escort" then
										-- 								addEscortRejectReason(support.name, "support.number > unassigned ("..support.number.." > "..AcftAvail[support.name].unassigned..")")
										-- 							end
										-- 						end

										-- 						-- if support.number > AcftAvail[support.name].unassigned then															--not enough aircraft available from this unit for this task
										-- 						-- if not AcftAvail[support.name] or support.number > AcftAvail[support.name].unassigned then
										-- 						-- 	tmpTxt = tmpTxt .."\r\n _E_ "
										-- 						-- 	if tracing then txtTracing = txtTracing .. "Passe 1E EJECT".."\n" end

										-- 						-- 	support_available = false																									--not enough support available

										-- 						-- 	local tabRejected = {}
										-- 						-- 	tabRejected["sujet"]  = support.id.." type: "..support.type.." (strikeOnlyWithEscorte) support_available if support.number > AcftAvail[support.name].unassigned "..supportUnitType
										-- 						-- 	tabRejected["cause"] = { [1] =  support.number, [2] = AcftAvail[support.name].unassigned, }
										-- 						-- 	tabRejected["ligne"]  = SafeGetLine()
										-- 						-- 	table.insert(draft["rejected"], tabRejected)

										-- 						-- end

										-- 					end
										-- 				end
										-- 			end
										-- 		end
										-- 	end

										-- 	tmpTxt = tmpTxt .. "\n".."Passe 20 "..tostring(draft.type).." "..tostring(draft.target_name).."\n"


											
										-- 	-- vérifie que tous les supports demandés existent
										-- 	if support_available and draft.loadout.support and not passPackmax  then

										-- 		for loadoutNeedTask, loadoutNeedTaskBool in pairs(draft.loadout.support) do

										-- 			tmpTxt = tmpTxt .. "Passe 2B |||"..tostring(draft.loadout.name).."\n"

										-- 			if loadoutNeedTaskBool then

										-- 				tmpTxt = tmpTxt .. "Passe 2C |||"..tostring(loadoutNeedTask).."\n"

										-- 				local foundOnePlane = false

										-- 				if draft.support[loadoutNeedTask] then

										-- 					for planeSupport, support in pairs(draft.support[loadoutNeedTask]) do

										-- 						if planeSupport ~= "NbTotalSupport" and planeSupport ~= "escort_max" then

										-- 							tmpTxt = tmpTxt .. "Passe 2D "..tostring(planeSupport).."\n"

										-- 							if type(support) == "table" and support.name then

										-- 								tmpTxt = tmpTxt .. "Passe 2H "..tostring(support.name).."\n"

										-- 								foundOnePlane = true
										-- 								break
										-- 							end
										-- 						end
										-- 					end
										-- 				end

										-- 				-- si ce support n'a aucun avion disponible -> ECHEC
										-- 				if not foundOnePlane then

										-- 					tmpTxt = tmpTxt .. "Passe 2J EJECT\n"

										-- 					support_available = false

										-- 					local tabRejected = {}
										-- 					tabRejected["sujet"]  = draft.id.." type: aucun SUPPORT "..tostring(loadoutNeedTask)
										-- 					tabRejected["cause"]  = { [1] = draft.support["support"], [2] = "" }
										-- 					tabRejected["ligne"]  = debug.getinfo(1).currentline
										-- 					table.insert(draft["rejected"], tabRejected)

										-- 					break -- inutile de vérifier les autres supports
										-- 				end

										-- 			end
										-- 		end
										-- 	end

										-- 	--
										-- 	--[[ fin du strikeOnlyWithEscorte pur]]--


										-- 	for _,_support in pairs(draft.support) do																							--iterate through support in draft sortie
										-- 		tmpTxt = tmpTxt .."_B1_"
										-- 		if support_available and type(_support) == "table" then
										-- 			tmpTxt = tmpTxt .."_B2_"
										-- 			for _,support in pairs(_support) do																							--iterate through support in draft sortie
										-- 				tmpTxt = tmpTxt .."_B3_"
										-- 					if 	type(support) == "table" then
										-- 					tmpTxt = tmpTxt .."_B4_"

										-- 					-- if AcftAvail[support.name].unassigned <=0 and not passPackmax then
										-- 					if not AcftAvail[support.name] or (AcftAvail[support.name].unassigned <= 0 and not passPackmax) then
										-- 						tmpTxt = tmpTxt .."_B5_"

										-- 						if tracing then txtTracing = txtTracing .. "Passe 3E EJECT".."\n" end

										-- 						support_available = false

										-- 						local tabRejected = {}
										-- 						tabRejected["sujet"]  = draft.id.." type: "..support.type.." (strikeOnlyWithEscorte) AVION SUPPORT INSUFFISANT()support_available if AcftAvail[support.name].unassigned <=0"
										-- 						tabRejected["cause"] = { [1] = AcftAvail[support.name].unassigned, [2] = "", }
										-- 						tabRejected["ligne"]  = SafeGetLine()
										-- 						table.insert(draft["rejected"], tabRejected)
										-- 					end
										-- 				end
										-- 			end
										-- 		end
										-- 	end

										-- 	if isDebugModeC then

										-- 		local escortRejectedTxt = table.concat(escortDiagnostic.rejected, " | ")
										-- 		local escortAcceptedTxt = table.concat(escortDiagnostic.accepted, " | ")

										-- 		debugLog(
										-- 			draft.id
										-- 			.." AtoG passe C_01_a strikeOnlyWithEscorte"
										-- 			..txtTracing
										-- 			.."\n"
										-- 			..tmpTxt
										-- 			.."\nESCORT_ACCEPTED: "..escortAcceptedTxt
										-- 			.."\nESCORT_REJECTED: "..escortRejectedTxt
										-- 		)

										-- 		debugLog(
										-- 			draft.id
										-- 			.." AtoG passe C_01_b strikeOnlyWithEscorte "
										-- 			..draft.type
										-- 			.." "
										-- 			..draft.task
										-- 			.." support_available: "
										-- 			..tostring(support_available)
										-- 		)
										-- 	end
										-- end

										

										if isDebugModeC then
											debugLog(draft.id.." AtoG passe C_02b serviceable: "
												..tostring(AcftAvail[draft.name].serviceable)
												.." |available: "..tostring(AcftAvail[draft.name].available)
												.." >? "..tostring(AcftAvail[draft.name].available / denom_NeDonnePasTOUT))
										end

										-- modification M11.u : Multiplayer	(u: reserve avion Escorte)
										-- interdit aux possible avion d'escorte de tout donner dans CAP ou Intercept

										if not override_MP_C and (draft.task == "CAP" or draft.task == "Intercept" )   then

											for n_squad, squad in pairs(oob_air[side]) do
												if squad.type == draft.type and squad.name == draft.name and ((squad.tasks["Escort"] and squad.tasks["Escort"] == true)
												or  (squad.tasks["SEAD"] and squad.tasks["SEAD"] == true) or  (squad.tasks["Strike"] and squad.tasks["Strike"] == true)  )
												then

													local test_Aircraftnumber = DeepCopy(draft.number)
													local needeMindAircraft = false

													-- if AcftAvail[draft.name].unassigned - test_Aircraftnumber < 2 then
													-- 	test_Aircraftnumber = test_Aircraftnumber -2
													-- else
													-- 	test = true
													-- end
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
													requestedNumber = test_Aircraftnumber

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
										if support_available and requestedNumber > 0 then

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
														if multiPlaneSet and multiPlaneSet[side] and multiPlaneSet[side][draft.type]  and multiPlaneSet[side][draft.type][arg_Entry.task] then
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


													if draft.main_overideMP and multiPlaneSet and multiPlaneSet[side] and multiPlaneSet[side][draft.type]  and multiPlaneSet[side][draft.type][draft.task] then

														multiPlaneSet[side][draft.type][draft.task].NbPlane = multiPlaneSet[side][draft.type][draft.task].NbPlane - assigned

														if isDebugModeC then
															debugLog(draft.id.." AtoG passe C_14 (NbPlane - assigned) "..multiPlaneSet[side][draft.type][draft.task].NbPlane)
														end
													end

													if not AcftAvail[arg_Entry.name] then
														debugLog(draft.id.." ERROR AcftAvail missing for "..tostring(arg_Entry.name))
														return
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
											draftForFlight.number = requestedNumber

											addFlight(requestedNumber, "main", draftForFlight)
											--********************************************************************************************

											
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
													rejectDraft(draft, sujet, cause)
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
											rejectDraft(draft, sujet, cause)
										end
									else
										local sujet = draft.id.." AVIONS INSUFFISANT()if draft.number <= available and limitMP then {draft.number, limitMP}"
										local cause = {"draft.number: ", tostring(draft.number), "limitMP: ", tostring(limitMP)}
										rejectDraft(draft, sujet, cause)
									end
								else
									local sujet = draft.id.." FIREPOWER du PACKAGE INSUFFISANT()if  available * draft.loadout.firepower >= (draft.target.firepower.packmin - 1) * draft.target.firepower.max"
									local cause = { [1] = tostring(available * draft.loadout.firepower), [2]  = tostring((draft.target.firepower.packmin - 1) * draft.target.firepower.max), }
									rejectDraft(draft, sujet, cause)
								end
							else
								local sujet = draft.id.." "..tostring(draft.type).." AVION DISPONIBLE INSUFFISANT "..tostring(draft.name).." available: "..tostring(available).." draft.loadout.firepower: "..tostring(draft.loadout.firepower.." firepowerMin: "..tostring(draft.target.firepower.min))
								local cause = { [1] = tostring(available * draft.loadout.firepower), [2]  = tostring(draft.target.firepower.min), }
								rejectDraft(draft, sujet, cause)
							end
						else
							local sujet = draft.id.." FIREPOWER INSUFFISANT (a augmenter dans loadout)if draft.target.firepower.max > 0 and draft.target.firepower.max >= draft.target.firepower.min"
							local cause = { [1] = tostring(draft.target.firepower.max), [2]  = tostring(draft.target.firepower.max), }
							rejectDraft(draft, sujet, cause)
						end
					else
						local sujet = draft.id.." MultiPACKAGE A 0 (?)if draft.multipack == nil or draft.multipack > 0 || target_name: "..tostring(draft.target_name).." || multipack: " ..tostring(draft.multipack)
						local cause = { [1] = tostring(draft.multipack), [2]  = tostring(draft.multipack), }
						rejectDraft(draft, sujet, cause)
					end
				else
					local sujet = draft.id.." MENACE TROP IMPORTANTE (descendre minscore ou diminuer Menace AA AS) draft.loadout.minscore <= draft.score"
					local cause = { [1] = tostring(draft.loadout.minscore), [2]  = tostring(draft.score), }
					rejectDraft(draft, sujet, cause)

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

			if di < Debug.Generator.nb or draft.name == showSquad or nameOK  then
				debugLog("")
				debugLog(side.." tablePrio: "..arg_tablePrio.." C N° " .. draft_n..
						-- " /support/ " ..tostring(draft.support)..
						" /Id/ " ..tostring(draft.id)..
						" /Prioriry/ " ..tostring(draft.priorityIni)..
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
for targetSide, targets in pairs(targetlist) do
	for targetN, target in pairs(targets) do
		if not target.inactive and target.ATO  then  --and (target.task == "Strike" or  target.task == "Anti-ship Strike" or target.task == "Runway Attack")

			--util pour eviter de cibler les memes target
			if not targetNamePrio[targetSide][target.priority] then targetNamePrio[targetSide][target.priority] = {} end
			local tempValue = {
				name = target.titleName,
				check = false,
				priority = target.priority,
			}
			table.insert(targetNamePrio[targetSide][target.priority], tempValue)

			--necessaire pour trier par ordre de priorité
			if not targetListPrioCheck[targetSide][target.priority] then
				table.insert(targetListPrio[targetSide], target.priority)
				targetListPrioCheck[targetSide][target.priority] = true
			end

			if priorityRef[targetSide] < target.priority  then
				priorityRef[targetSide] = target.priority
			end
		end
	end
end

table.sort(targetListPrio["blue"], function(a,b) return a > b  end)
table.sort(targetListPrio["red"], function(a,b) return a > b  end)


for sidePrio, tableauPrio in pairs(targetListPrio) do
	for tableN, tablePrio in pairs(tableauPrio) do
		for draftN, draft in pairs(draftSorties[sidePrio]) do
			if draft.priorityIni == tablePrio then
				table.insert(newDraftByPriority[sidePrio], draft)
			end

		end

		table.sort(newDraftByPriority[sidePrio], function(a,b) return a.score > b.score  end)

		createATO_table(newDraftByPriority)

		if Debug.Generator.affiche and newDraftByPriority ~= nil then
			debugLog("\n"..debuGenTxt.." \n Side: "..sidePrio.."  tablePrio "..tostring(tablePrio).."\n")
			showAtoSort(newDraftByPriority, tablePrio)
		end

		newDraftByPriority = {
			blue = {},
			red = {},
		}
	end
end

local allFlightName_AtoG = {}
--assign le nom des packages
for _, packages in pairs(ATO) do
	for packN, pack in pairs(packages) do
		for _, flights in pairs(pack) do
			for flightN, flight in pairs(flights) do
				if type(flight) == "table" and flight.name then
				
					--pour eviter le pb du flight 2 du main(strike) qui peut etre en conflit avec une escorte strike 		
					local tempNumFlight = flightN
					flight.groupName = "Pack " .. packN .. " - " .. flight.name .. " - " .. flight.task .. " " .. tempNumFlight
					repeat
						flight.groupName = "Pack " .. packN .. " - " .. flight.name .. " - " .. flight.task .. " " .. tempNumFlight
						tempNumFlight = tempNumFlight + 1
					until not allFlightName_AtoG[flight.groupName]

					-- print("AtoG assign flight G: groupName: " .. tostring(flight.groupName))

				else
					-- _affiche(flight, "AtoG H flight:: ")
				end

			end
		end
	end
end




--remet la valeur de priority correct, si elle avait été changée par un choix multijoueur
-- for kGroupN, multiGroup in pairs(Multi.Group) do
for targetSide, targets in pairs(targetlist) do
	for targetN, target in pairs(targets) do
		if  target.priorityINIT  then
			target.priority = DeepCopy(target.priorityINIT)
			target.priorityINIT = nil
		end
	end
end

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
	
	local camp_str = "ATO = " .. TableSerialization(ATO, 0)
	local campFile = io.open("Debug/ATO_1_AtoGenerator.lua", "w")
	if campFile then
		campFile:write(camp_str)
		campFile:close()
	end

	camp_str = "camp = " .. TableSerialization(camp, 0)
	campFile = io.open("Debug/CAMP_Ato_Generator.lua", "w")
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
end




