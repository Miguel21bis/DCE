--ATO_Gen_10_State.lua
--Sous-module de ATO_Gen_Main.lua : etat de depart du generateur (variables globales de suivi, remise a nil des filtres de debug, suivi de jouabilite TrackPlayability / CheckAssignments, lien AcftAvail vers la disponibilite des avions de la campagne)
--Charge par ATO_Gen_Main.lua (Include) a la place ou se trouvait le bloc. Texte deplace tel quel, AUCUN changement de code
--(tout y est deja global ; seule HostileContextKeys est locale, et n'est utilisee que dans ce fichier).
--Ce fichier est REJOUE a chaque generation (Include) : c'est voulu, il remet l'etat a zero comme le faisait l'ancien fichier unique.
-------------------------------------------------------------------------------------------------------
if not versionDCE then versionDCE = {} end
versionDCE["ATO_Gen_10_State.lua"] = "1.21.137"
-------------------------------------------------------------------------------------------------------

if Debug.debug then
	print("START ATO_Gen_10_State.lua "..versionDCE["ATO_Gen_10_State.lua"].." =-=-=-=-=-=-=-=-=-=-=-=-=-=-=")
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
--SquadGenerationStatus (ATO_Gen_00_Debug.lua), affichee via PrintPlayerRejectionSP/MP.
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

debuGenTxt = ""
-- local debugLogs = {}

denom_NeDonnePasTOUT = 1.5 --1.3		--nb, coef, dénominateur pour ne pas donner tous les chasseurs à l'escorte, en garder pour les intercepteur/cap
--plus le chiffre est petit, moins il y a de CAP et intercepteur
-- if AcftAvail[draft.name].unassigned - test_Aircraftnumber <= AcftAvail[draft.name].serviceable/denom_NeDonnePasTOUT then

multipackByTargetName = {}
