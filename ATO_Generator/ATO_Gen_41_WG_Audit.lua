--ATO_Gen_41_WG_Audit.lua
--Sous-module de ATO_Gen_Main.lua : Wargame Airlift (ravitaillement aerien par helicopteres), 2/2 : audit des cibles, bilans (WG_AirliftAfterATO / WG_AirliftFinalize), donnees pour MAIN_NextMission (WG_AirliftBuildData)
--Charge par ATO_Gen_Main.lua (Include) APRES ATO_Gen_40_WG_Plan.lua. Code deplace tel quel, fonctions globales WG_*
-------------------------------------------------------------------------------------------------------
if not versionDCE then versionDCE = {} end
versionDCE["ATO_Gen_41_WG_Audit.lua"] = "1.21.137"
-------------------------------------------------------------------------------------------------------

if Debug.debug then
	print("START ATO_Gen_41_WG_Audit.lua "..versionDCE["ATO_Gen_41_WG_Audit.lua"].." =-=-=-=-=-=-=-=-=-=-=-=-=-=-=")
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

function WG_AirliftAfterATO(draftSortiesRef, atoRef, multipackRef)

	--(plus de sortie anticipee : WG_AirliftInATO doit etre rempli meme si le journal est desactive ;
	--WG_Log et WG_FlushLog ne font rien quand WG_AIRLIFT_LOG est false)
	WG_AirliftInATO = {}

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
				if place then
					nInAto = nInAto + 1
					if draft.target.name then WG_AirliftInATO[draft.target.name] = true end	--cible reellement presente dans l'ATO
				end

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

				local pk = WG_AirliftPick and WG_AirliftPick[t.name]
				if pk and not WG_AirliftDone[t.name] then
					WG_Log("AIRLIFT_ORPHELIN target: "..tostring(t.name).." choisie pour "..tostring(pk.unit).." mais aucun draft cree (rejet avant l'airlift : voir TRACE_A / rejets natifs du squad)")
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


--Donnees de l'etape 3 (logistique aerienne) pour la mission : zones, vols, charges a elinguer.
--Appelee par MAIN_NextMission.lua juste avant la creation de campL. Resultat : global WG_AirliftData
--(nil si rien a transmettre). La mission retrouve elle-meme les groupes IA en comparant les coordonnees
--des waypoints Load / Drop avec load.x/y et drop.x/y ci-dessous.
WG_AIRLIFT_ZONE_RADIUS  = 300			--m, rayon des zones de chargement / depose
WG_AIRLIFT_HOLD_S       = 30			--s, delai de validation (vivant + pose ou stationnaire dans la zone)
WG_AIRLIFT_AI_HOVER_S   = 45			--s, duree du stationnaire IA a chaque point
WG_AIRLIFT_CARGO_KG     = { 1500, 1000, 750, 500, 500, 300, 250, 200, 150, 100 }	--poids des charges au point Load
WG_AIRLIFT_CARGO_MAX    = 10			--nb maximum de charges par point Load (entrepot principal), camp du joueur seulement
WG_AIRLIFT_CARGO_TYPE   = "ammo_cargo"	--type DCS de la charge (static cargo)
WG_AIRLIFT_CARGO_FARP_DIST = 600		--m, distance des charges a la FARP du joueur, sur le segment FARP -> entrepot (rayon du cercle de charges = 40 m : mini reel 560 m, donc > 500 m)
WG_AIRLIFT_CLEAR        = true			--true = degage les points de chargement / depose (arbres et batiments) au demarrage de la mission
WG_AIRLIFT_CLEAR_TREES  = true			--arbres : action DCS a_remove_scene_objects (meme action que "Remove trees" d'une mission)
WG_AIRLIFT_CLEAR_TREES_MASK = 1			--objects_mask de cette action (1 = valeur de la mission de reference "Remove trees Khe San")
WG_AIRLIFT_CLEAR_BUILDINGS = true		--batiments : action DCS a_scenery_destruction_zone (niveau 100), la meme que celle des decors detruits
WG_AIRLIFT_CLEAR_DESTROY_S = 5			--s, delai avant la destruction des batiments (les arbres partent au demarrage)
WG_AIRLIFT_CLEAR_LOAD_R = 70			--m, rayon degage autour du centre des charges (cercle des charges = 40 m)
WG_AIRLIFT_CLEAR_DROP_R = 80			--m, rayon degage autour du centre du point de depose (jamais plus que le rayon de la zone)
WG_AIRLIFT_CLEAR_ALL_SIDES = false		--false = camp du joueur seulement
WG_AIRLIFT_SIM_TYPES    = {}			--types d'helico dont le joueur utilise le menu F10 SIMULE (sans crochet ni cargo interne DCS). Ex: { "SA342M" }. Vide = tous en cargo DCS natif.

function WG_AirliftBuildData()

	WG_AirliftData = nil

	if not WG_AIRLIFT_GENERATE or type(targetlist) ~= "table" then
		return
	end

	local data = {
		radius = WG_AIRLIFT_ZONE_RADIUS,
		holdS = WG_AIRLIFT_HOLD_S,
		aiHoverS = WG_AIRLIFT_AI_HOVER_S,
		flights = {},
		zones = {},
		cargos = {},
		clear = {},		--zones a degager (arbres / batiments) : { kind, slot, side, x, y, radius }
		payload = {},
		simTypes = {},		--types d'helico dont le joueur utilise le menu F10 simule (pas de crochet / cargo interne DCS)
	}
	for _, typeName in ipairs(WG_AIRLIFT_SIM_TYPES) do
		data.simTypes[typeName] = true
	end

	local loadPoints = {}
	local playerSide = (camp and camp.player and camp.player.side) or "blue"

	for sideName, targets in pairs(targetlist) do
		local side = string.lower(tostring(sideName))

		for _, t in pairs(targets) do
			if type(t) == "table" and t.wargameLogistic == "airlift" and not t.inactive and t.ATO
				and tonumber(t.wargameLoadX) and tonumber(t.wargameLoadY) and tonumber(t.x) and tonumber(t.y) then

				local slot = t.wargameSlot
				if not slot then
					slot = string.gsub(tostring(t.name), "^WG_AIRLIFT_", "")
				end

				local load = { x = t.wargameLoadX, y = t.wargameLoadY }
				local dropX, dropY, dropR, dropSrc = WG_AirliftDropPoint(t)
				local drop = { x = dropX, y = dropY }
				if dropSrc == "wargameDrop" or dropR ~= data.radius then
					WG_Log("AIRLIFT_DATA depose "..tostring(slot).." : centre "..math.floor(dropX)..","..math.floor(dropY).." rayon "..math.floor(dropR).." m (source: "..dropSrc..")")
				end

				--zones : sur tous les points de ravitaillement, meme sans vol IA
				table.insert(data.zones, { slot = slot, side = side, kind = "load", x = load.x, y = load.y, radius = data.radius })
				table.insert(data.zones, { slot = slot, side = side, kind = "drop", x = drop.x, y = drop.y, radius = dropR })

				--point Load (entrepot principal) : les cibles qui partagent le meme point partagent aussi les charges
				local key = math.floor(load.x + 0.5).."_"..math.floor(load.y + 0.5)
				if not loadPoints[key] then
					loadPoints[key] = { x = load.x, y = load.y, side = side, slot = slot, need = 0, forced = 0, slotSet = {} }
				end
				loadPoints[key].need = loadPoints[key].need + (tonumber(t.wargameNeedKg) or 0)
				loadPoints[key].slotSet[slot] = true

				--supply depot de la FARP (DCE_Manager) : present seulement quand le chargement se fait a une FARP
				--wargameDepotX / wargameDepotY / wargameDepotName. Les charges sont alors posees autour du depot.
				local depX, depY = tonumber(t.wargameDepotX), tonumber(t.wargameDepotY)
				if depX and depY and not loadPoints[key].depotX then
					loadPoints[key].depotX = depX
					loadPoints[key].depotY = depY
					loadPoints[key].depotName = t.wargameDepotName
				end

				--vol : seulement si un vol a ete cree pour cette cible
				local pick = WG_AirliftPick and WG_AirliftPick[t.name]
				--seulement si le vol est dans l'ATO (un draft rejete a la creation de l'ATO n'existe pas dans la mission)
				if WG_AirliftDone and WG_AirliftDone[t.name] and pick and pick.plan
					and (not WG_AirliftInATO or WG_AirliftInATO[t.name]) then
					local human = pick.plan.human and true or false
					table.insert(data.flights, {
						slot = slot, target = t.name, side = side, squad = pick.unit,
						kgPlanned = math.floor(pick.plan.kgPlanned or 0), N = pick.plan.N or 1,
						load = load, drop = drop, dropRadius = dropR, human = human, type = pick.unitType,
					})

					--vol joueur : la base de depart (FARP) sert a eloigner les charges (voir plus bas)
					if human and pick.unitBase and db_airbases[pick.unitBase] and db_airbases[pick.unitBase].x then
						loadPoints[key].fx = db_airbases[pick.unitBase].x
						loadPoints[key].fy = db_airbases[pick.unitBase].y
						loadPoints[key].fname = pick.unitBase
					end

					--vol joueur : le plafond des charges du point Load est la charge utile de son helicoptere
					if human and pick.unitType and type(PayloadType) == "table" and tonumber(PayloadType[pick.unitType]) then
						local cap = tonumber(PayloadType[pick.unitType])
						if not loadPoints[key].capKg or cap < loadPoints[key].capKg then
							loadPoints[key].capKg = cap
						end
					end

					--vol joueur sur une cible sans besoin : on force quand meme des charges (a retirer plus tard)
					if human and WG_AIRLIFT_FORCE_PLAYER_CARGO then
						loadPoints[key].forced = math.max(loadPoints[key].forced, math.floor(pick.plan.kgPlanned or 0))
					end
				end
			end
		end
	end

	--charges a elinguer / charger : seulement dans le camp du joueur, WG_AIRLIFT_CARGO_MAX au plus par point Load
	local crateCentres = {}		--centre reel de chaque groupe de charges (pour le degagement)
	for key, lp in pairs(loadPoints) do
		local needEff = lp.need
		if needEff <= 0 and lp.forced > 0 then
			needEff = lp.forced
		end

		if lp.side == playerSide and needEff > 0 then
			local sum, n = 0, 0

			--centre des charges : par defaut le point Load.
			--1) Si DCE_Manager donne un supply depot de FARP (wargameDepotX/Y) : autour du depot.
			--2) Sinon, si on connait la FARP du joueur, sur le segment FARP -> entrepot, a WG_AIRLIFT_CARGO_FARP_DIST
			--   de la FARP (jamais plus pres), donc entre les deux.
			local cx, cy = lp.x, lp.y
			if lp.depotX and lp.depotY then
				cx, cy = lp.depotX, lp.depotY
				local dTxt = ""
				if lp.fx and lp.fy then
					local ddx, ddy = cx - lp.fx, cy - lp.fy
					dTxt = " (a "..math.floor(math.sqrt(ddx * ddx + ddy * ddy)).." m de "..tostring(lp.fname)..")"
				end
				WG_Log("AIRLIFT_DATA charges "..tostring(lp.slot).." : autour du supply depot "..tostring(lp.depotName or "?")..dTxt)
			elseif lp.fx and lp.fy then
				local dx, dy = lp.x - lp.fx, lp.y - lp.fy
				local D = math.sqrt(dx * dx + dy * dy)
				if D > 1 then
					local d = WG_AIRLIFT_CARGO_FARP_DIST
					if D < d then
						d = D
						WG_Log("AIRLIFT_DATA ATTENTION entrepot ("..math.floor(D).." m) plus pres de "..tostring(lp.fname).." que "..WG_AIRLIFT_CARGO_FARP_DIST.." m : charges poses sur l'entrepot")
					end
					cx = lp.fx + dx / D * d
					cy = lp.fy + dy / D * d
					WG_Log("AIRLIFT_DATA charges "..tostring(lp.slot).." : "..math.floor(d).." m de "..tostring(lp.fname).." (entrepot a "..math.floor(D).." m)")
				end
			end
			for _, kg in ipairs(WG_AIRLIFT_CARGO_KG) do
				if n >= WG_AIRLIFT_CARGO_MAX or (sum >= needEff and n >= 1) then break end
				if not lp.capKg or kg <= lp.capKg then		--sinon: trop lourde pour l'helicoptere du joueur (crochet / soute), on passe a la suivante
					n = n + 1
					sum = sum + kg
					local a = (n - 1) * (2 * math.pi / WG_AIRLIFT_CARGO_MAX)
					table.insert(data.cargos, {
						slot = lp.slot, side = lp.side, name = "WG_CARGO_SCPT_"..lp.slot.."_"..n, kg = kg,
						x = cx + 40 * math.cos(a), y = cy + 40 * math.sin(a),
						heading = 0, typeName = WG_AIRLIFT_CARGO_TYPE,
					})
				end
			end

			if n >= 1 then
				table.insert(crateCentres, { slot = lp.slot, side = lp.side, x = cx, y = cy })
			end

			--la zone Load du joueur (et son marquage) suit les charges, pas l'entrepot principal.
			--Les vols IA gardent leur point Load (flights[].load) : seule la zone change.
			if n >= 1 and (cx ~= lp.x or cy ~= lp.y) then
				for _, z in ipairs(data.zones) do
					if z.kind == "load" and z.side == lp.side and lp.slotSet[z.slot] then
						z.x, z.y = cx, cy
					end
				end
				WG_Log("AIRLIFT_DATA zone Load du joueur deplacee sur les charges : "..math.floor(cx)..","..math.floor(cy))
			end
		end
	end

	if #data.zones == 0 then
		WG_Log("AIRLIFT_DATA aucune cible airlift active : rien transmis a la mission")
		return
	end

	--zones a degager (arbres / batiments) : MAIN_NextMission en fait des trigger zones cachees + les actions DCS.
	--Load : seulement la ou des charges ont ete posees (jamais autour d'un entrepot nu) ; Drop : camp du joueur.
	if WG_AIRLIFT_CLEAR and (WG_AIRLIFT_CLEAR_TREES or WG_AIRLIFT_CLEAR_BUILDINGS) then
		local seen = {}
		local function addClear(kind, slot, side, x, y, radius)
			local key = kind.."_"..math.floor(x + 0.5).."_"..math.floor(y + 0.5)
			if seen[key] then return end
			seen[key] = true
			table.insert(data.clear, { kind = kind, slot = slot, side = side, x = x, y = y, radius = radius })
		end

		for _, c in ipairs(crateCentres) do
			addClear("load", c.slot, c.side, c.x, c.y, WG_AIRLIFT_CLEAR_LOAD_R)
		end

		for _, z in ipairs(data.zones) do
			if z.kind == "drop" and (WG_AIRLIFT_CLEAR_ALL_SIDES or z.side == playerSide) then
				addClear("drop", z.slot, z.side, z.x, z.y, math.min(WG_AIRLIFT_CLEAR_DROP_R, z.radius))
			end
		end

		for _, c in ipairs(data.clear) do
			WG_Log("AIRLIFT_DATA degagement "..c.kind.." "..tostring(c.slot).." : "..math.floor(c.x)..","..math.floor(c.y).." rayon "..c.radius.." m")
		end
	end

	--charge utile par type d'helicoptere (pour limiter le chargement du joueur)
	if type(PayloadType) == "table" and type(IsHelicopter) == "table" then
		for typeName, kg in pairs(PayloadType) do
			if IsHelicopter[typeName] then data.payload[typeName] = kg end
		end
	end

	WG_AirliftData = data
	WG_Log("AIRLIFT_DATA vols: "..#data.flights.." zones: "..#data.zones.." charges: "..#data.cargos)
	WG_FlushLog(true)
end
