------------------------------------------------------------------------------------------------------- 
if not versionDCE then versionDCE = {} end
versionDCE["ATO_Generator_v2.lua"] = "1.1.1"
------------------------------------------------------------------------------------------------------- 


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


--Enregistre l'étape la plus avancée atteinte par un squad
--Pourquoi: comprendre exactement où un squad bloque dans le pipeline
function updateDraftProgress(ctx, stepName, rejectReason)

	if not ctx or not ctx.unit then
		return
	end

	local stepIndex = DraftStepIndex[stepName] or 0

	local current = DraftProgress[ctx.unit.name]

	if not current or stepIndex >= current.stepIndex then

		DraftProgress[ctx.unit.name] = {

			unit = ctx.unit.name,
			task = ctx.task,
			target = ctx.targetName,
			loadout = ctx.loadoutName,

			step = stepName,
			stepIndex = stepIndex,

			rejectReason = rejectReason,

			player = ctx.unit.player,

			time = os.time(),
		}
	end
end

--Valide une étape du pipeline
--Pourquoi: centraliser le suivi de progression
function validateStep(ctx, stepName)

	updateDraftProgress(ctx, stepName, nil)

	return true
end

--Rejette une étape du pipeline
--Pourquoi: mémoriser la dernière étape atteinte avant échec
function rejectStep(ctx, stepName, reason)

	updateDraftProgress(ctx, stepName, reason)

	return false
end

--========================================================
-- ATO Generator V2 Runtime
-- But:
-- Centraliser l'état runtime du générateur.
-- Pourquoi:
-- Eviter les globals implicites dispersées partout.
--========================================================

-- local generatorRuntime = {

-- 	stats = {
-- 		draftGenerated = 0,
-- 		draftRejected = 0,
-- 	},

-- 	debug = {
-- 		enabled = false,
-- 		chapter = "",
-- 	},

-- }

--========================================================
-- buildDraftContext
-- But:
-- Créer un contexte unique pour un draft.
-- Pourquoi:
-- Eviter les dizaines de variables locales implicites.
--========================================================

-- local function buildDraftContext(sideName, unit, task, loadout, target)

-- 	return {

-- 		sideName = sideName,

-- 		unit = unit,
-- 		task = task,
-- 		loadout = loadout,
-- 		target = target,

-- 		state = {
-- 			route = nil,
-- 			variant = nil,
-- 			tot_from = 0,
-- 			tot_to = 0,
-- 			remainingFirepower = 0,
-- 			futureAircraftAssign = 0,
-- 		},

-- 		flags = {
-- 			overideMP = false,
-- 			passPackmax = false,
-- 			playable = false,
-- 		},

-- 		rejects = {},
-- 		rejectCount = {},

-- 		score = {
-- 			base = 0,
-- 			final = 0,
-- 			add = 0,
-- 			coef = 1,
-- 		},

-- 	}
-- end

--========================================================
-- rejectDraft
-- But:
-- Enregistrer proprement une raison de rejet.
-- Pourquoi:
-- Comprendre immédiatement pourquoi un draft échoue.
--========================================================

-- local function rejectDraft(draftContext, reason)

-- 	draftContext.rejects[#draftContext.rejects + 1] = reason

-- 	if not draftContext.rejectCount[reason] then
-- 		draftContext.rejectCount[reason] = 0
-- 	end

-- 	draftContext.rejectCount[reason] =
-- 		draftContext.rejectCount[reason] + 1

-- 	return false
-- end

--========================================================
-- draftDebug
-- But:
-- Logger centralisé du générateur.
-- Pourquoi:
-- Remplacer les centaines de debugLog dispersés.
--========================================================

-- local function draftDebug(draftContext, chapter, text)

-- 	if not generatorRuntime.debug.enabled then
-- 		return
-- 	end

-- 	if not string.find(generatorRuntime.debug.chapter, chapter) then
-- 		return
-- 	end

-- 	local unitName = "nil"
-- 	local targetName = "nil"

-- 	if draftContext.unit then
-- 		unitName = draftContext.unit.name
-- 	end

-- 	if draftContext.target then
-- 		targetName = draftContext.target.titleName
-- 	end

-- 	debugLog(
-- 		"[ATO_V2]"
-- 		.."["..chapter.."] "
-- 		.."["..unitName.."] "
-- 		.."["..targetName.."] "
-- 		..text
-- 	)
-- end

--========================================================
-- validateRange
-- But:
-- Vérifier que la cible est atteignable.
-- Pourquoi:
-- Sortir rapidement les drafts impossibles.
--========================================================

-- local function validateRange(draftContext, distance)

-- 	local maxRange = draftContext.loadout.range

-- 	if distance > maxRange then
-- 		return rejectDraft(draftContext, "range")
-- 	end

-- 	return true
-- end

--========================================================
-- buildRoute
-- But:
-- Construire une route via le système historique.
-- Pourquoi:
-- Migrer progressivement sans casser DCE.
--========================================================

-- local function buildRoute(draftContext, airbasePoint, daytime)

-- 	local route =
-- 		GetRoute(
-- 			airbasePoint,
-- 			draftContext.target,
-- 			draftContext.loadout,
-- 			draftContext.sideName,
-- 			draftContext.task,
-- 			daytime,
-- 			1,
-- 			1,
-- 			draftContext.unit,
-- 			nil
-- 		)

-- 	if not route then
-- 		return rejectDraft(draftContext, "route")
-- 	end

-- 	draftContext.state.route = route

-- 	return true
-- end

--========================================================
-- registerDraftSortie
-- But:
-- Insérer un draft dans la liste finale.
-- Pourquoi:
-- Centraliser l'insertion des sorties.
--========================================================

-- local function registerDraftSortie(draftContext, draftSorties)

-- 	if not draftSorties[draftContext.sideName] then
-- 		draftSorties[draftContext.sideName] = {}
-- 	end

-- 	draftSorties[draftContext.sideName][
-- 		#draftSorties[draftContext.sideName] + 1
-- 	] = {

-- 		name = draftContext.unit.name,
-- 		task = draftContext.task,
-- 		target = draftContext.target,
-- 		loadout = draftContext.loadout,

-- 		score = draftContext.score.final,

-- 		debugContext = {
-- 			rejects = DeepCopy(draftContext.rejects),
-- 		},

-- 	}

-- 	generatorRuntime.stats.draftGenerated =
-- 		generatorRuntime.stats.draftGenerated + 1
-- end

--========================================================
-- generateDraftForTarget
-- But:
-- Pipeline principal d'un draft.
-- Pourquoi:
-- Séparer clairement chaque étape métier.
--========================================================

-- local function generateDraftForTarget(
-- 	sideName,
-- 	unit,
-- 	task,
-- 	loadout,
-- 	target,
-- 	draftSorties
-- )

-- 	local draftContext =
-- 		buildDraftContext(
-- 			sideName,
-- 			unit,
-- 			task,
-- 			loadout,
-- 			target
-- 		)

-- 	draftDebug(draftContext, "A", "draft start")

-- 	local airbasePoint = {
-- 		x = db_airbases[unit.base].x,
-- 		y = db_airbases[unit.base].y,
-- 	}

-- 	local distance =
-- 		GetDistance(
-- 			airbasePoint,
-- 			target
-- 		)

-- 	if not validateRange(draftContext, distance) then
-- 		return false
-- 	end

-- 	if not buildRoute(
-- 		draftContext,
-- 		airbasePoint,
-- 		"day"
-- 	) then
-- 		return false
-- 	end

-- 	registerDraftSortie(
-- 		draftContext,
-- 		draftSorties
-- 	)

-- 	return true
-- end

--========================================================
-- runValidators
-- But:
-- Exécuter toutes les validations d'un draft.
-- Pourquoi:
-- Centraliser tous les checks du générateur.
--========================================================

-- local function runValidators(draftContext)

-- 	local validators = {

-- 		validateUnitActive,
-- 		validateAirbase,
-- 		validateAircraftAvailability,
-- 		validateTask,
-- 		validateLoadout,
-- 		validateWeather,
-- 		validateRange,
-- 		validateTarget,
-- 	}

-- 	for i = 1, #validators do

-- 		local valid =
-- 			validators[i](draftContext)

-- 		if not valid then
-- 			return false
-- 		end
-- 	end

-- 	return true
-- end

-- local function validateSomething(draftContext)

-- 	if condition then
-- 		return rejectDraft(
-- 			draftContext,
-- 			"reason"
-- 		)
-- 	end

-- 	return true
-- end

--========================================================
-- validateAircraftAvailability
-- But:
-- Vérifier qu'il reste des avions disponibles.
-- Pourquoi:
-- Eviter les drafts impossibles.
--========================================================

-- local function validateAircraftAvailability(draftContext)

-- 	local available =
-- 		draftContext.runtime.aircraftAvailable

-- 	if not available then
-- 		return rejectDraft(
-- 			draftContext,
-- 			"no_aircraft_available"
-- 		)
-- 	end

-- 	if available <= 0 then
-- 		return rejectDraft(
-- 			draftContext,
-- 			"no_aircraft_available"
-- 		)
-- 	end

-- 	return true
-- end

--Affiche le diagnostic final des squads
--Pourquoi: comprendre pourquoi certains squads ne génèrent jamais de mission
function printDraftProgressReportOLD()

	print("\n")
	print("========== DRAFT PROGRESS REPORT ==========")

	for unitName, data in pairs(DraftProgress) do

		local txt =
			unitName
			.." | step: "..tostring(data.step)

		if data.rejectReason then
			txt = txt.." | reject: "..tostring(data.rejectReason)
		end

		if data.task then
			txt = txt.." | task: "..tostring(data.task)
		end

		if data.target then
			txt = txt.." | target: "..tostring(data.target)
		end

		print(txt)
	end

	print("===========================================")
	print("\n")
end

printDraftProgressReport()
