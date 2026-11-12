--ATO_Gen_Main.lua
--Coeur du generateur de mission (ATO) : construction des draft sorties, assignation appareils/support/escorte, table ATO finale
--Charge par ATO_Generator.lua (point d'entree), APRES ATO_Gen_00_Debug.lua et ATO_Gen_01_Eval.lua
--Orchestrateur : charge (Include) les sous-fichiers ATO_Gen_10_State, 20_Eligibility, 30_Sorties, 40_WG_Plan, 41_WG_Audit, 50_Support, 60_Package, 90_RangePref a l'endroit ou leur code se trouvait ;
--garde ici : le reglage ESCORT_MINSCORE_DISCOUNT, les traces Ho*, la boucle de generation des drafts, le tri final, les dumps et l'appel de createATO_table
-------------------------------------------------------------------------------------------------------
if not versionDCE then versionDCE = {} end
versionDCE["ATO_Gen_Main.lua"] = "1.21.137"
-------------------------------------------------------------------------------------------------------

if Debug.debug then
	print("START ATO_Gen_Main.lua "..versionDCE["ATO_Gen_Main.lua"].." =-=-=-=-=-=-=-=-=-=-=-=-=-=-=")
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

-- ============================================================================
-- humainOnly : reserve a un joueur humain (Player ou Client)
-- ============================================================================
--Vrai si l'escadrille est humainOnly, OU si sa base / son FARP (db_airbases) est humainOnly.
--Un squad dont la base est humainOnly ne doit servir que pour un humain, comme un squad humainOnly.
function HumainOnlyUnit(unit)
	if not unit then return false end
	if unit.humainOnly then return true end
	local base = unit.base and db_airbases and db_airbases[unit.base]
	if base and base.humainOnly then return true end
	return false
end

-- ============================================================================
-- TRACE humainOnly : un fichier de log rien que pour comprendre pourquoi des vols IA
-- utilisent des appareils d'un squad humainOnly (airlift Solo, mais aussi le reste).
-- Fichier : Campaigns\<campagne>\Debug\Wargame\ScriptsModPart\HumainOnly_Trace.log
-- Ecrase au 1er passage du process, complete aux passes suivantes (tentatives de generation).
-- HO_TRACE = false : plus rien n'est ecrit.
-- ============================================================================
HO_TRACE = true
HO_TRACE_DIR = "Debug/Wargame/ScriptsModPart"
HO_TRACE_FILE = HO_TRACE_DIR.."/HumainOnly_Trace.log"
HO_TraceStarted = HO_TraceStarted or false

--ecrit une ligne (ouvre / ferme a chaque fois : le fichier survit a un plantage)
function HoLog(msg)
	if not HO_TRACE then return end

	local mode = "a"
	if not HO_TraceStarted then
		mode = "w"
		local dir = string.gsub(HO_TRACE_DIR, "/", "\\")
		os.execute('if not exist "'..dir..'" mkdir "'..dir..'"')
	end

	local f = io.open(HO_TRACE_FILE, mode)
	if f then
		HO_TraceStarted = true
		f:write(tostring(msg).."\n")
		f:close()
	end
end

--squad (table oob_air) a partir de son nom, nil si introuvable
function HoUnit(name)
	if not name then return nil end
	for _, squads in pairs(oob_air) do
		for _, sq in pairs(squads) do
			if sq.name == name then return sq end
		end
	end
	return nil
end

--etat des compteurs d'avions d'un squad (pour les lignes de log)
function HoAcft(name)
	local a = AcftAvail and AcftAvail[name]
	if not a then return "AcftAvail=nil" end
	return "AcftAvail available="..tostring(a.available).." assigned="..tostring(a.assigned).." unassigned="..tostring(a.unassigned)
end

--entete d'une passe : reglages + squads humainOnly (a appeler une fois par passe)
function HoHeader()
	if not HO_TRACE then return end

	HoLog("")
	HoLog("==================================================================================")
	HoLog("PASSE GENERATEUR "..tostring(GeneratorPass).." | MissionInstance="..tostring(MissionInstance).." | SinglePlayer="..tostring(SinglePlayer).." | Multi.NbGroup="..tostring(Multi and Multi.NbGroup).." | heure "..os.date("%H:%M:%S"))
	HoLog("REGLAGES airlift : PLAYER_FIRST="..tostring(WG_AIRLIFT_PLAYER_FIRST).." GENERATE="..tostring(WG_AIRLIFT_GENERATE).." MAX_N="..tostring(WG_AIRLIFT_MAX_N).." RANDOM="..tostring(WG_AIRLIFT_RANDOM).." IGNORE_SUPPORT="..tostring(WG_AIRLIFT_IGNORE_SUPPORT))

	local nb = 0
	for side, squads in pairs(oob_air) do
		for _, sq in pairs(squads) do
			if HumainOnlyUnit(sq) then
				nb = nb + 1
				local base = db_airbases and db_airbases[sq.base]
				local ready = "?"
				if sq.roster then ready = tostring(sq.roster.ready) end
				HoLog("SQUAD humainOnly : "..tostring(side).." "..tostring(sq.name).." type="..tostring(sq.type).." base="..tostring(sq.base).." | squad.humainOnly="..tostring(sq.humainOnly).." base.humainOnly="..tostring(base and base.humainOnly).." | player="..tostring(sq.player).." client="..tostring(sq.client).." inactive="..tostring(sq.inactive).." roster.ready="..ready.." | "..HoAcft(sq.name))
			end
		end
	end
	if nb == 0 then HoLog("(aucun squad humainOnly dans oob_air)") end
end

--liste les vols de l'ATO qui appartiennent a un squad humainOnly.
--apresAssign = false : avant ATO_PlayerAssign (les vols sont "candidat", personne n'est encore affecte)
--apresAssign = true  : apres ATO_PlayerAssign, avec le VERDICT (vol joueur / client / IA)
function HoDumpATO(titre, apresAssign)
	if not HO_TRACE then return end

	HoLog("")
	HoLog("---------- "..tostring(titre).." | passe "..tostring(GeneratorPass).." ----------")

	if apresAssign then
		local cp = camp and camp.player
		if cp then
			HoLog("camp.player : side="..tostring(cp.side).." pack_n="..tostring(cp.pack_n).." role="..tostring(cp.role).." flight="..tostring(cp.flight).." groupName="..tostring(cp.groupName).." squad="..tostring(cp.squadName).." task="..tostring(cp.task))
		else
			HoLog("camp.player : aucun (TaskRefused="..tostring(TaskRefused).." PlayerFlight="..tostring(PlayerFlight)..")")
		end
		if camp and camp.client then
			HoLog("camp.client : "..#camp.client.." entree(s)")
		end
	end

	for side, squads in pairs(oob_air) do
		for _, sq in pairs(squads) do
			if HumainOnlyUnit(sq) then
				local total, humain, ia, avionsIA = 0, 0, 0, 0
				local lignes = {}

				for s2, packs in pairs(ATO) do
					for p = 1, #packs do
						for role, flights in pairs(packs[p]) do
							if type(flights) == "table" then
								for f = 1, #flights do
									local fl = flights[f]
									if type(fl) == "table" and fl.name == sq.name then
										local qui = "candidat"
										if fl.player then
											qui = "JOUEUR"
										elseif fl.client then
											qui = "CLIENT"
										elseif apresAssign then
											qui = "IA"
										end

										total = total + 1
										if qui == "JOUEUR" or qui == "CLIENT" then
											humain = humain + 1
										end
										if qui == "IA" then
											ia = ia + 1
											avionsIA = avionsIA + (fl.number or 0)
										end

										lignes[#lignes + 1] = "   "..tostring(s2).." pack"..p.." "..tostring(role).."["..f.."] id="..tostring(fl.id).." groupName="..tostring(fl.groupName).." task="..tostring(fl.task).." cible="..tostring(fl.target_name).." nb="..tostring(fl.number).." playable="..tostring(fl.playable).." tot_from="..tostring(fl.tot_from).." -> "..qui
									end
								end
							end
						end
					end
				end

				HoLog("SQUAD "..tostring(sq.name).." ("..tostring(sq.type)..", base "..tostring(sq.base).."): "..total.." vol(s) dans l'ATO")
				for _, l in ipairs(lignes) do
					HoLog(l)
				end
				if apresAssign then
					local alerte = ""
					if ia > 0 then alerte = "   <== BUG : des vols IA utilisent ce squad humainOnly" end
					HoLog("VERDICT "..tostring(sq.name).." : "..humain.." vol(s) humain(s), "..ia.." vol(s) IA ("..avionsIA.." avion(s) IA)"..alerte)
				end
				HoLog("   compteurs : "..HoAcft(sq.name))
			end
		end
	end
end

-- ============================================================================
-- CORRECTION (vols IA sur un squad humainOnly) : nettoyage APRES ATO_PlayerAssign.
-- Pourquoi : un squad humainOnly passe le filtre "passHumain" des qu'il est le squad du joueur
-- (unit.player = true), donc TOUS ses drafts (ex : un airlift par cible WG_AIRLIFT_*) deviennent
-- des vols. Le joueur n'en choisit qu'UN ; les autres restaient dans l'ATO et volaient en IA,
-- ce que humainOnly doit interdire (trace : "VERDICT ... <== BUG : des vols IA utilisent ce squad").
-- On retire donc de l'ATO les vols (ni player, ni client) des squads humainOnly.
--   - un package dont le vol main est retire disparait en entier, sauf s'il contient un humain
--     ou s'il est reference par un autre package (target_pack) : il garde alors son vol main ;
--   - les numeros de package / de vol sont recalcules (camp.player, camp.client, HumainPack,
--     camp.MultiPlayer.pack_n, target_pack, init_packN).
-- A appeler dans MAIN_NextMission.lua juste apres Include("ATO_PlayerAssign.lua").
-- HUMAIN_ONLY_PRUNE = false : desactive le nettoyage (retour au comportement precedent).
-- ============================================================================
HUMAIN_ONLY_PRUNE = true

function PruneHumainOnlyAI()
	if not HUMAIN_ONLY_PRUNE then return end

	local humainOnlySquad = {}
	local nbSquad = 0
	for _, squads in pairs(oob_air) do
		for _, sq in pairs(squads) do
			if type(sq) == "table" and HumainOnlyUnit(sq) and not (IsHumainProhibited and IsHumainProhibited(sq)) then
				humainOnlySquad[sq.name] = true
				nbSquad = nbSquad + 1
			end
		end
	end
	if nbSquad == 0 then return end

	--retrouve l'objet vol (table) d'une reference {side, pack_n, role, flight}
	local function getFlightObj(ref)
		if type(ref) ~= "table" then return nil end
		local s = ATO[ref.side]
		local p = s and s[ref.pack_n]
		local r = p and p[ref.role]
		return r and r[ref.flight]
	end

	--on memorise les objets vol du joueur / des clients : leur index change si des vols sont retires
	local playerObj = getFlightObj(camp.player)
	local clientObjs = {}
	if camp.client then
		for i, cl in ipairs(camp.client) do clientObjs[i] = getFlightObj(cl) end
	end

	local packOldIndex = {}		--packOldIndex[side][table package] = ancien index
	local remap = {}			--remap[side][ancien index] = nouvel index (nil si package supprime)
	local anyDropped = false
	local nbRemoved = 0

	for side, packs in pairs(ATO) do
		local nOld = #packs
		packOldIndex[side] = {}
		for p = 1, nOld do packOldIndex[side][packs[p]] = p end

		--packages references par un vol d'un AUTRE package : on ne les supprime pas
		local referenced = {}
		for s2, packs2 in pairs(ATO) do
			for p2 = 1, #packs2 do
				for _, flights2 in pairs(packs2[p2]) do
					if type(flights2) == "table" then
						for f2 = 1, #flights2 do
							local fl2 = flights2[f2]
							if type(fl2) == "table" and fl2.target_pack and fl2.target_side == side and not (s2 == side and p2 == fl2.target_pack) then
								referenced[fl2.target_pack] = true
							end
						end
					end
				end
			end
		end

		local kept = {}
		remap[side] = {}

		for p = 1, nOld do
			local pack = packs[p]

			local protected = referenced[p] == true
			for _, flights in pairs(pack) do
				if type(flights) == "table" then
					for f = 1, #flights do
						local fl = flights[f]
						if type(fl) == "table" and (fl.player or fl.client) then protected = true end
					end
				end
			end

			local removedHere = 0
			for role, flights in pairs(pack) do
				if type(flights) == "table" then
					for f = #flights, 1, -1 do
						local fl = flights[f]
						if type(fl) == "table" and fl.name and humainOnlySquad[fl.name] and not fl.player and not fl.client then
							if role == "main" and protected and #flights <= 1 then
								--package protege : on garde au moins un vol main (ATO_Timing / DC_Briefing lisent main[1])
								HoLog("  PRUNE_GARDE (package protege) "..tostring(side).." pack"..p.." id="..tostring(fl.id))
							else
								HoLog("  PRUNE_RETIRE "..tostring(side).." pack"..p.." "..tostring(role).."["..f.."] id="..tostring(fl.id).." squad="..tostring(fl.name).." task="..tostring(fl.task).." cible="..tostring(fl.target_name))
								table.remove(flights, f)
								removedHere = removedHere + 1
							end
						end
					end
				end
			end
			nbRemoved = nbRemoved + removedHere

			if removedHere > 0 and not protected and (not pack.main or #pack.main == 0) then
				anyDropped = true
				HoLog("  PRUNE_PACKAGE_SUPPRIME "..tostring(side).." pack"..p)
			else
				if removedHere > 0 then
					--roles devenus vides : on retire la cle (sauf main)
					local empty = {}
					for role, flights in pairs(pack) do
						if type(flights) == "table" and #flights == 0 and role ~= "main" then empty[#empty + 1] = role end
					end
					for _, role in ipairs(empty) do pack[role] = nil end
				end
				table.insert(kept, pack)
				remap[side][p] = #kept
			end
		end

		if #kept ~= nOld then
			for p = 1, nOld do packs[p] = nil end
			for i = 1, #kept do packs[i] = kept[i] end
		end
	end

	if nbRemoved == 0 then return end
	HoLog("  PRUNE : "..nbRemoved.." vol(s) IA retire(s) des squads humainOnly")
	if AddLog then AddLog("PruneHumainOnlyAI: "..nbRemoved.." AI flight(s) removed from humainOnly squads") end

	--renumerotation des references a un numero de package
	if anyDropped then
		for side, packs in pairs(ATO) do
			for p = 1, #packs do
				for _, flights in pairs(packs[p]) do
					if type(flights) == "table" then
						for f = 1, #flights do
							local fl = flights[f]
							if type(fl) == "table" then
								if fl.target_pack and fl.target_side and remap[fl.target_side] then
									fl.target_pack = remap[fl.target_side][fl.target_pack] or fl.target_pack
								end
								if fl.init_packN and remap[side] then
									fl.init_packN = remap[side][fl.init_packN] or fl.init_packN
								end
							end
						end
					end
				end
			end
		end
	end

	--camp.player / camp.client : on retrouve chaque vol par son objet (numero de package ET de vol ont pu changer)
	local function locate(obj)
		if not obj then return nil end
		for side, packs in pairs(ATO) do
			for p = 1, #packs do
				for role, flights in pairs(packs[p]) do
					if type(flights) == "table" then
						for f = 1, #flights do
							if flights[f] == obj then return side, p, role, f end
						end
					end
				end
			end
		end
		return nil
	end

	local oldPlayerPack = camp.player and camp.player.pack_n
	local humainSide = camp.player and camp.player.side

	if camp.player and playerObj then
		local s, p, r, f = locate(playerObj)
		if s then camp.player.side, camp.player.pack_n, camp.player.role, camp.player.flight = s, p, r, f end
	end
	if camp.client then
		for i, cl in ipairs(camp.client) do
			local s, p, r, f = locate(clientObjs[i])
			if s then cl.side, cl.pack_n, cl.role, cl.flight = s, p, r, f end
		end
	end

	--HumainPack et camp.MultiPlayer.pack_n sont indexes par numero de package (camp du joueur)
	if anyDropped and humainSide and remap[humainSide] then
		local newHP, newMP = {}, {}
		for p, v in pairs(HumainPack or {}) do
			local np = remap[humainSide][p]
			if np then newHP[np] = v end
		end
		if camp.MultiPlayer and camp.MultiPlayer.pack_n then
			for p, v in pairs(camp.MultiPlayer.pack_n) do
				local np = remap[humainSide][p]
				if np then newMP[np] = v end
			end
			camp.MultiPlayer.pack_n = newMP
		end
		HumainPack = newHP
	end
end

local atoMainTaskFound = false

multiPlaneSet = {}
local multiSquadSet = {}
priorityMaxValue = {}

-- Etat final de génération par squad
SquadGenerationStatus = {}

local tgtList_Gen = DeepCopy(targetlist)

--firepower déjà assignée par target
--Pourquoi: éviter qu'un target continue à recevoir des packages inutiles
targetAssignedFirepower = {}

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

-- ============================================================================
-- ELIGIBILITE d'un draft (meteo, attributs, TOT) et contexte unite -- code deplace dans le dossier ATO_Generator\
-- ============================================================================
Include("ATO_Generator/ATO_Gen_20_Eligibility.lua")	--checkWeatherEligibility, checkAttributeEligibility, computeTOTWindow, prepareUnitContext

-- ============================================================================
-- ETAT DE DEPART (variables de suivi, jouabilite, AcftAvail) -- code deplace dans le dossier ATO_Generator\
-- ============================================================================
Include("ATO_Generator/ATO_Gen_10_State.lua")	--TrackPlayability, CheckAssignments, AcftAvail, debuGenTxt, multipackByTargetName...

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

--(prepareUnitContext et ses fonctions annexes sont dans ATO_Gen_20_Eligibility.lua, charge plus haut)

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

baseFARP = {
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
status_counter_sorties = 0
status_counter_escorts = 0
status_counter_ATO = 0

--table to store draft sorties (all valid unit/task/loadout/target combinations)
draftSorties = {
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

-- ============================================================================
-- DRAFTS DE SORTIE (getMultiPlane*, buildDraftSorties, processEligibleLoadout) -- code deplace dans le dossier ATO_Generator\
-- ============================================================================
Include("ATO_Generator/ATO_Gen_30_Sorties.lua")	--getMultiPlane, getMultiPlaneTask, buildDraftSorties, processEligibleLoadout

table.sort(targetlist["blue"], function(a,b) return a.priority > b.priority  end)
table.sort(targetlist["red"], function(a,b) return a.priority > b.priority  end)


-- ============================================================================
-- WARGAME : ravitaillement aerien (airlift) -- code deplace dans le dossier ATO_Generator\
-- ============================================================================
--Les REGLAGES WG_AIRLIFT_* sont maintenant en tete de ATO_Gen_40_WG_Plan.lua
Include("ATO_Generator/ATO_Gen_40_WG_Plan.lua")	--reglages, calcul des plans, menaces, contournements, reecriture de route
Include("ATO_Generator/ATO_Gen_41_WG_Audit.lua")	--audit, bilans (AfterATO / Finalize), donnees pour MAIN_NextMission



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

HoHeader()		--trace humainOnly : entete de passe

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

				--CORRECTION (bug 12) : playerRejectReason n'etait jamais appelee, donc PlayerMainTaskFailure restait vide.
				--On la branche ici : tache MAIN sans sortie generee = echec a rapporter (la fonction ignore les taches non demandees par un joueur).
				playerRejectReason(draftContext, draftContext.task, getDominantRejectReason(draftContext))

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

-- ============================================================================
-- SUPPORTS (escorte, SEAD, ...) -- code deplace dans le dossier ATO_Generator\
-- ============================================================================
--Le REGLAGE SUPPORT_LOADOUT_PREFER_SHORT_RANGE est maintenant en tete de ATO_Gen_50_Support.lua
Include("ATO_Generator/ATO_Gen_50_Support.lua")	--addSupportToDraft, sortSupportLoadouts

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
													if passIsClientCondition and HumainOnlyUnit(unitSupport) then
														--Multi : uniquement si ce support est celui demande par le joueur (overideMP_B)
														--Solo  : squad du joueur, les vols IA non choisis sont retires apres l'assignation
														if Multi and Multi.NbGroup and Multi.NbGroup >= 1 then
															passIsClientCondition = (overideMP_B == true)
														else
															passIsClientCondition = (unitSupport.player or unitSupport.client) and true or false
														end
														-- if isDebugModeB then
														-- 	debugLog(debuGenTxt1480.."\n"..(tostring(draft.id).." AtoG II pass B_15_g support_requirement passe: humainOnly "..tostring(unitSupport.humainOnly).." passIsClientCondition "..tostring(passIsClientCondition)))
														-- end
													end

													if HO_TRACE and HumainOnlyUnit(unitSupport) then
														HoLog("  SUPPORT_HUMAINONLY draft="..tostring(draft.id).." support_squad="..tostring(unitSupport.name).." reserveClient="..tostring(reserveClient).." overideMP_B="..tostring(overideMP_B).." unit.player="..tostring(unitSupport.player).." unit.client="..tostring(unitSupport.client).." -> passIsClientCondition="..tostring(passIsClientCondition))
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

-- ============================================================================
-- PACKAGES DE L'ATO (createATO_table) -- code deplace dans le dossier ATO_Generator\
-- ============================================================================
Include("ATO_Generator/ATO_Gen_60_Package.lua")	--rejectDraft, validSupportIterator, createATO_table

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

-- ============================================================================
-- PREFERENCE loadout de portee juste suffisante -- code deplace dans le dossier ATO_Generator\
-- ============================================================================
--Les REGLAGES LOADOUT_RANGE_* sont maintenant en tete de ATO_Gen_90_RangePref.lua
Include("ATO_Generator/ATO_Gen_90_RangePref.lua")	--reglages, log dedie, sortDraftsByScoreAndRange, rangePrefReport

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
			--CORRECTION (ordre des vols) : avant, pairs(flights) donnait un ordre indefini, d'ou "Strike 1" = x2 et "Strike 2" = x4.
			--On trie d'abord les vols du role du plus gros au plus petit (tri stable : a taille egale on garde l'ordre de creation),
			--puis on numerote avec ipairs : 6 avions -> 1:x4 2:x2 ; 10 avions -> 1:x4 2:x4 3:x2 (le dernier vol comble les trous), en solo comme en MP.
			if type(flights) == "table" and #flights > 1 then
				local orderRef = {}
				for i, f in ipairs(flights) do orderRef[f] = i end
				table.sort(flights, function(a, b)
					local na = (type(a) == "table" and tonumber(a.number)) or 0
					local nb = (type(b) == "table" and tonumber(b.number)) or 0
					if na ~= nb then return na > nb end
					return (orderRef[a] or 0) < (orderRef[b] or 0)
				end)
			end
			for flightN, flight in ipairs(flights) do

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

--trace humainOnly : etat de l'ATO a la fin du generateur (avant l'affectation du joueur)
HoDumpATO("FIN generateur (avant ATO_PlayerAssign) : vols candidats", false)

