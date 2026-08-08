--ATO_Generator_A_Debug.lua
--Sous-module de ATO_Generator : logs de debug, tracking structure des rejets et des echecs de generation (squad / player)
--A charger AVANT ATO_Generator_B_Eval.lua et ATO_Generator_C_Core.lua (ceux-ci utilisent debugLog/rejectStep/etc en globale)
-------------------------------------------------------------------------------------------------------
if not versionDCE then versionDCE = {} end
versionDCE["ATO_Generator_A_Debug.lua"] = "1.21.137"
-------------------------------------------------------------------------------------------------------

if Debug.debug then
	print("START ATO_Generator_A_Debug.lua "..versionDCE["ATO_Generator_A_Debug.lua"].." =-=-=-=-=-=-=-=-=-=-=-=-=-=-=")
end

-- Mettre a false pour couper l'affichage console de chaque echec joueur
PRINT_PLAYER_FAILURE = true

-- ============================================================================
-- ETAT PARTAGE (tables de tracking)
-- ============================================================================

-- CORRECTION 1 : Il faut déclarer la table de buffer de manière locale 
-- sinon Lua va planter dès le premier debugLog.
local debugLogs = {}

-- Cache ultra rapide des demandes joueurs MAIN
playerRequestedMainTask = {}

local playerFailureDedup = {}
-- Causes structurées d'échec de génération Player/Client
PlayerAssignFailure = {}

-- Report des échecs de génération MAIN pour les demandes joueurs
PlayerMainTaskFailure = {}

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

escortRejectReasons = {}

--Traduction lisible des codes de rejet produits par rejectStep()/PlayerAssignFailure.
--priority sert a choisir la raison "dominante" quand plusieurs rejets ont ete tentes
--pour le meme escadron (cf getDominantRejectReason). Plus le chiffre est haut, plus
--la raison est consideree comme parlante/utile a afficher au joueur.
--NOTE : "texte" est le message montre aux joueurs -> style compte-rendu militaire,
--court (max ~10-12 mots), pas de tournure journalistique.
RejectReasonInfo = {

	--blocages de base (rien n'a ete tente ensuite)
	inactive               = { priority = 95, texte = "Squadron currently inactive." },
	invalid_airbase        = { priority = 95, texte = "Home base non-operational." },
	no_aircraft_available  = { priority = 90, texte = "No aircraft ready at this time." },

	--route / portee
	route_not_found        = { priority = 85, texte = "No valid route to target." },
	range_too_short        = { priority = 80, texte = "Target out of range." },
	support_no_range       = { priority = 80, texte = "Target out of range for escort tasking." },

	--meteo
	weather_not_eligible   = { priority = 70, texte = "Weather unsuitable for this airframe." },
	no_weatherEligible     = { priority = 70, texte = "Weather grounds all available targets." },

	--puissance de feu
	firepower_insufficient = { priority = 65, texte = "Insufficient firepower for this target." },

	--loadout / heure du jour
	loadout_day_only       = { priority = 55, texte = "Loadout restricted to daylight ops." },
	loadout_night_only     = { priority = 55, texte = "Loadout restricted to night ops." },
	HumainRequired         = { priority = 55, texte = "Tasking requires a human pilot slot." },

	--loadout / tache
	no_loadoutEligible     = { priority = 40, texte = "No eligible loadout for current conditions." },
	no_aircraft_loadout    = { priority = 40, texte = "No loadout configured for this airframe." },
	no_task_loadout        = { priority = 40, texte = "No loadout configured for this tasking." },
	no_loadout_country     = { priority = 40, texte = "No loadout configured for your coalition." },

	--cible
	no_full_target_attributes     = { priority = 25, texte = "No target meets mission requirements." },
	no_full_target_attributesCond = { priority = 25, texte = "No target meets mission conditions." },
	no_target_active               = { priority = 20, texte = "No active target for this tasking." },
	no_target_ATO                  = { priority = 20, texte = "No target assigned in the ATO." },
	["no_target.task == task"]     = { priority = 20, texte = "No target matches requested tasking." },

	--CAP / Intercept jouables mais sans opposition (flight.hostileFound == false)
	no_hostile_in_CAP_area   = { priority = 60, texte = "CAP airborne, no bandits expected in sector." },
	no_hostile_for_intercept = { priority = 60, texte = "Intercept airborne, no bogeys in range." },

	--raisons agregees multijoueur (ATO_PlayerAssign.lua)
	no_playable_flight_generated = { priority = 90, texte = "No playable flight generated this pass." },
	no_aircraft_generated        = { priority = 85, texte = "No aircraft of this type generated." },
	task_not_generated            = { priority = 60, texte = "Aircraft generated, wrong tasking assigned." },
	insufficient_aircraft         = { priority = 50, texte = "Insufficient aircraft generated for this request." },
	unknown                        = { priority = 0,  texte = "Cause undetermined." },
	
	--rejets remontes par rejectDraft() dans createATO_table (ATO_Generator_C_Core.lua) :
	--un 3e circuit, distinct de rejectStep/SquadGenerationStatus, qui intervient plus tard
	--dans la construction du package (apres qu'un loadout ait ete juge eligible).
	insufficient_aircraft_count   = { priority = 90, texte = "Not enough aircraft to fill this tasking." },
	insufficient_package_firepower = { priority = 65, texte = "Package firepower below required threshold." },
	insufficient_firepower_available = { priority = 65, texte = "Available aircraft can't generate required firepower." },
	loadout_firepower_too_low      = { priority = 55, texte = "Loadout firepower too low, adjust weapons load." },
}

-- ============================================================================
-- SÉCURITÉ & LOGS DE CONFIGURATION (En-tête du script)
-- ============================================================================

local logFilePath = "Debug/Generator_debugLogs.lua"
local logBufferSize = 1000  -- Nombre de lignes avant écriture disque

-- -- CORRECTION 1 : Il faut déclarer la table de buffer de manière locale 
-- -- sinon Lua va planter dès le premier debugLog.
-- local debugLogs = {} 

--Compteur de passes de generation.
--Ce fichier est rejoue a chaque tentative de generation : la variable est donc
--le moyen le plus simple de savoir combien de fois le generateur a tourne.
GeneratorPass = (GeneratorPass or 0) + 1

-- Réinitialiser le fichier au démarrage
local function initDebugLogs()
    -- On ne vide le fichier qu'au TOUT PREMIER chargement du process.
    -- Sinon, comme ce fichier est rejoue a chaque tentative de generation,
    -- on ne garderait que les logs de la derniere passe (et donc jamais ceux
    -- de la passe qui a reellement pose probleme).
    if GeneratorPass > 1 then
        local file = io.open(logFilePath, "a")
        if file then
            file:write("\n-- ================ PASSE DE GENERATION "..GeneratorPass.." ================\n")
            file:close()
        end
        return
    end

    local file = io.open(logFilePath, "w")
    if file then
        file:write("-- ================ PASSE DE GENERATION 1 ================\n")
        file:close()
    end
end

-- Écriture sur le disque
function flushDebugLogs()
    -- SÉCURITÉ : On vérifie s'il y a des logs à écrire pour éviter d'ouvrir le fichier pour rien
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
--  CORRECTION 2 : Cette fonction DOIT être déclarée SANS 'local' (donc globale) 
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
-- FONCTIONS DE TRACKING / REPORTING
-- ============================================================================

function isPlayerRelatedDraft(draft)

	if not draft then
		return false
	end

	if draft.player then
		return true
	end

	if draft.client then
		return true
	end

	if draft.unit and draft.unit.player and SinglePlayer then
		return true
	end

	if draft.unit and draft.unit.client then
		return true
	end

	if draft.main_overideMP then
		return true
	end

	return false
end

-- Enregistre une cause d'échec structurée limitée aux vols Player/Client
function registerPlayerFailure(data)

	if not data then
		return
	end

	local dedupKey =
		tostring(data.draftId)
		.."|"
		..tostring(data.stage)
		.."|"
		..tostring(data.reason)

	if playerFailureDedup[dedupKey] then
		return
	end

	playerFailureDedup[dedupKey] = true

	-- if not data.DraftId then
	-- 	return
	-- end

	PlayerAssignFailure[#PlayerAssignFailure + 1] = {

		draftId = data.draftId,
		unitType = data.unitType or "type_unknown",

		requestedPlane = data.requestedPlane,
		requestedTask = data.requestedTask,
		requestedNb = data.requestedNb,

		stage = data.stage,
		reason = data.reason,
		line = data.line,

		details = data.details or {},

		debugText = data.debugText or "",
	}

	--Trace immediate : on voit l'echec au moment ou il est enregistre, sans
	--attendre le tableau de fin qui, lui, arrive apres 50 tentatives.
	if PRINT_PLAYER_FAILURE then
		print("[FAIL] passe "..tostring(GeneratorPass)
			.." | draft "..tostring(data.draftId)
			.." | "..tostring(data.requestedPlane)
			.." | stage "..tostring(data.stage)
			.." | reason "..tostring(data.reason)
			.." | ligne "..tostring(data.line))
	end
end

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

--Affiche le diagnostic final des squads
--Pourquoi: comprendre pourquoi un squad ne vole jamais
--Affiche le diagnostic final des squads
--Pourquoi: comprendre précisément pourquoi un squad bloque
function printDraftProgressReport(argUnitName)

	print("\n========== DRAFT PROGRESS REPORT ==========")

	for unitName, data in pairs(DraftProgress) do

        local skip = argUnitName and argUnitName ~= unitName

        if not skip and not data.success then

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
function validateStep(ctx, stepName)

	updateDraftProgress(ctx, stepName, nil)

	return true
end

function rejectStep(draft, step, reason, data, bloc, line)

	if not draft.rejectReasons then
		draft.rejectReasons = {}
	end

	if not draft.rejectStats then
	draft.rejectStats = {}
	end

	-- draft.rejectStats[reason] =
	-- 	(draft.rejectStats[reason] or 0) + 1

	local rejectKey =
	tostring(step) .. "|" .. tostring(reason)

	draft.rejectStats[rejectKey] =
		(draft.rejectStats[rejectKey] or 0) + 1

	draft.rejectReasons[#draft.rejectReasons + 1] = {
		step = step,
		reason = reason,
		data = data,
		line = line,
		bloc = bloc,
	}

	local rejectPriority = {
		task = 1,
		target = 2,
		loadout = 3,
		firepower = 4,
		weather = 5,
		range = 6,
		route = 7,
		sortie = 8,
		support = 9,
		aircraft = 10,
	}

	local currentPriority = 0

	if draft.finalReject then
		currentPriority = rejectPriority[draft.finalReject.step] or 0
	end

	local newPriority = rejectPriority[step] or 0

	if not draft.finalReject or newPriority >= currentPriority then

		draft.finalReject = {
			step = step,
			reason = reason,
			data = data,
			line = line,
			bloc = bloc,
		}
	end

	
	-- if isPlayerRelatedDraft(draft) and draft.clientPlayer and not draft.playerFailureRegistered then
	-- if draft.clientPlayer and not draft.playerFailureRegistered then
	-- if isPlayerRelatedDraft(draft) and not draft.playerFailureRegistered then
	-- 	draft.playerFailureRegistered = true

	-- 	registerPlayerFailure({

	-- 		draftId = draft.draftId,
	-- 		unitType = draft.unitType,

	-- 		requestedPlane = draft.type,
	-- 		requestedTask = draft.task,
	-- 		requestedNb = draft.number,

	-- 		stage = bloc,
	-- 		reason = reason,
	-- 		line = line,

	-- 		details = data,

	-- 		debugText = reason,
	-- 	})
	-- end

	
end

function getDominantRejectReason(draft)

	if not draft.rejectStats then
		return nil
	end

	local bestReason
	local bestPriority = -1

	for rejectKey,_ in pairs(draft.rejectStats) do

		local reason =
			string.match(rejectKey, "|(.+)$")

		local info = RejectReasonInfo[reason]
		local p = info and info.priority or 0

		if p > bestPriority then
			bestPriority = p
			bestReason = reason
		end
	end

	return bestReason
end

-- Calcule un score représentatif d'échec
-- Pourquoi : conserver uniquement le rejet le plus significatif d'un squad
function computeRejectScore(draftContext)

	if not draftContext or not draftContext.rejectStats then
		return 0
	end

	local score = 0

	for reason, count in pairs(draftContext.rejectStats) do

		if reason == "no_loadoutEligible" then
			score = score + count * 100

		elseif reason == "range" then
			score = score + count * 80

		elseif reason == "weather" then
			score = score + count * 60

		elseif reason == "loadout_day_only" then
			score = score + count * 50

		elseif reason == "loadout_night_only" then
			score = score + count * 50

		elseif reason == "no_target_active" then
			score = score + count * 1
		end
	end

	return score
end

--Ajoute une raison de rejet dans le draft
--Pourquoi: comprendre pourquoi un draft/squad/target est refusé
--Ajoute une raison de rejet au draft courant
--Pourquoi: permettre d'expliquer pourquoi un draft/squad ne passe jamais
function addRejectReason(draftContext, reason)

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

-- Report uniquement des MAIN tasks demandées par joueur
local function playerRejectReason(draftContext, reason, rejectReason)

	local draft = draftContext.draft

	if draft and draft.type and draft.task and draft.side then

		local key =
			tostring(draft.side) .. "|" ..
			tostring(draft.type) .. "|" ..
			tostring(draft.task)

		local playerRequest = playerRequestedMainTask[key]

		if playerRequest then

			if not PlayerMainTaskFailure[key] then

				PlayerMainTaskFailure[key] = {
					side = draft.side,
					plane = draft.type,
					task = draft.task,

					totalReject = 0,
					reasons = {},
				}
			end

			local report = PlayerMainTaskFailure[key]

			report.totalReject =
				report.totalReject + 1

			if rejectReason then
				report.reasons[rejectReason] =
					(report.reasons[rejectReason] or 0) + 1
			end
		end
	end
end

--Synthese lisible de l'etat du suivi, a appeler depuis n'importe ou
--(ex: printGeneratorSummary() juste apres la generation) quand on veut savoir
--d'un coup d'oeil si le generateur a produit quelque chose a cette passe.
function printGeneratorSummary()

	local function compte(t)
		if type(t) ~= "table" then return 0 end
		local n = 0
		for _ in pairs(t) do n = n + 1 end
		return n
	end

	print("\n---------- GENERATOR SUMMARY (passe "..tostring(GeneratorPass)..") ----------")
	print(" squads suivis         : "..compte(DraftProgress))
	print(" echecs joueur         : "..compte(PlayerAssignFailure))
	print(" echecs MAIN demandees : "..compte(PlayerMainTaskFailure))
	print(" squads sans escorte   : "..compte(escortRejectReasons))

	local aucunSucces = true
	for _, data in pairs(DraftProgress) do
		if data.success then
			aucunSucces = false
			break
		end
	end

	if aucunSucces then
		print(" !! AUCUN squad n'a atteint l'etape sortie a cette passe.")
	end

	print("--------------------------------------------------------\n")
end


--Enregistre la raison de rejet d'un squad-escorte/support (une seule gardee par squad, la
--premiere rencontree, cf les appels avec "if not escortRejectReasons[...] then").
--sujet      : texte de debug brut (francais, garde pour le rapport FINAL SQUAD REPORT)
--reasonCode : cle optionnelle de RejectReasonInfo, pour un message joueur propre et court
--cause      : donnees brutes optionnelles associees (chiffres, etc.)
function AddEscortRejectReason(squadName, sujet, reasonCode, cause)
	if not escortRejectReasons[squadName] then
		escortRejectReasons[squadName] = {}
	end

	table.insert(escortRejectReasons[squadName], {
		sujet = sujet,
		reasonCode = reasonCode,
		cause = cause,
	})
end

--Cherche le flight du joueur dans l'ATO en cours (comparaison sur le nom d'escadron,
--identique a la logique de ATO_PlayerAssign.lua : flight[f].name == squadron name).
local function FindFlightByName(squadName)

	if not ATO or not squadName then
		return nil
	end

	for _, pack in pairs(ATO) do
		for p = 1, #pack do
			for _, flight in pairs(pack[p]) do
				for f = 1, #flight do
					if flight[f].name == squadName then
						return flight[f]
					end
				end
			end
		end
	end

	return nil
end

--Construit les lignes d'explication pour le joueur solo.
--1) vol genere mais volontairement exclu (CAP/Intercept sans hostile a portee)
--2) sinon, aucun vol genere du tout -> SquadGenerationStatus[squadName].bestReject
--   (circuit rejectStep, dans processEligibleLoadout)
--3) sinon, squad rejete plus tard dans la construction du package -> escortRejectReasons[squadName]
--   (circuit rejectDraft, dans createATO_table -- un point de blocage different du n°2,
--   qui intervient APRES qu'un loadout ait ete juge eligible)
--Style volontairement court/compte-rendu militaire : 1 ligne, ~10-12 mots max.
function ExplainPlayerRejectionSP(squadName)

	local msg = {}

	local flight = FindFlightByName(squadName)

	if flight and flight.playable == true then

		if flight.task == "CAP" and flight.hostileFound == false then
			msg[#msg + 1] = RejectReasonInfo.no_hostile_in_CAP_area.texte
			return msg

		elseif flight.task == "Intercept" and flight.hostileFound == false then
			msg[#msg + 1] = RejectReasonInfo.no_hostile_for_intercept.texte
			return msg

		else
			msg[#msg + 1] =
				"Flight tasked to your squadron ("
				..tostring(flight.task or "?")
				.."), not slotted as playable this pass."
			return msg
		end
	end

	local status = SquadGenerationStatus and SquadGenerationStatus[squadName]

	if status and status.bestReject then

		local bestReject = status.bestReject

		local reasonKey =
			bestReject.dominantReason
			or (bestReject.finalReject and bestReject.finalReject.reason)

		local info = RejectReasonInfo[reasonKey]

		if info then
			msg[#msg + 1] = "Cause: "..info.texte
			return msg
		end
	end

	--rien trouve via rejectStep : on tente le 2e circuit (rejectDraft/createATO_table)
	local escortReason = escortRejectReasons and escortRejectReasons[squadName] and escortRejectReasons[squadName][1]
	local escortInfo = escortReason and escortReason.reasonCode and RejectReasonInfo[escortReason.reasonCode]

	if escortInfo then
		msg[#msg + 1] = "Cause: "..escortInfo.texte
		return msg
	end

	msg[#msg + 1] = "No blocking data logged for your squadron this pass."
	return msg
end

--A appeler depuis les lanceurs (BAT_FirstMission / BAT_SkipMission / DEBRIEF_Master) en solo.
function PrintPlayerRejectionSP()

	local squadName = playerInfo and playerInfo.squadBAT

	print("\nNo playable flight could be offered to you this pass.")

	for _, line in ipairs(ExplainPlayerRejectionSP(squadName)) do
		print(line)
	end

	print()
end

--A appeler depuis les lanceurs en multijoueur.
function PrintPlayerRejectionMP()

	if not (Multi.NbGroup and not PlayerFlight) then
		return
	end

	print("Mission generation failed:\n")
	print("ID  Aircraft     Base                Squadron        Tasks")
	print("----------------------------------------------------------------")

	if not PlayerAssignFailure then
		return
	end

	for _, failData in pairs(PlayerAssignFailure) do

		local shortTasks = failData.generatedTasksShort or "---"

		local line =
			string.format(
				"%-3s %-12s %-19s %-15s %s",
				tostring(failData.id or "?"),
				tostring(failData.requestedPlane or "---"),
				tostring(failData.baseShort or "---"),
				tostring(failData.squadronShort or "---"),
				shortTasks
			)

		print(line)

		local info = RejectReasonInfo[failData.reason]

		if failData.reason == "insufficient_aircraft" then
			print(
				" -> Generated "
				..tostring(failData.foundAircraft or 0)
				.." / "
				..tostring(failData.requestedNb or "?")
				.." aircraft."
			)
		elseif info then
			print(" -> "..info.texte)
		elseif failData.reason then
			print(" -> Unmapped reason code: "..tostring(failData.reason))
		else
			print(" -> Cause undetermined.")
		end

		if failData.debugReason then
			print("    -> "..tostring(failData.debugReason))
		end

		print()
	end

	CheckAssignments()
end

