--ATO_Gen_90_RangePref.lua
--Sous-module de ATO_Gen_Main.lua : preference pour le loadout de portee juste suffisante (reglages LOADOUT_RANGE_*, log dedie Debug/LoadoutRange.log, tri des drafts, rapport de controle)
--Charge par ATO_Gen_Main.lua (Include) a la place ou le bloc se trouvait. Texte deplace tel quel ; seuls changements : sortDraftsByScoreAndRange et rangePrefReport sont devenues globales (etaient 'local' dans l'ancien fichier, mais Main les appelle)
-------------------------------------------------------------------------------------------------------
if not versionDCE then versionDCE = {} end
versionDCE["ATO_Gen_90_RangePref.lua"] = "1.21.137"
-------------------------------------------------------------------------------------------------------

if Debug.debug then
	print("START ATO_Gen_90_RangePref.lua "..versionDCE["ATO_Gen_90_RangePref.lua"].." =-=-=-=-=-=-=-=-=-=-=-=-=-=-=")
end

--PATCH ATO_Gen_Main.lua : preference pour le loadout a la portee la plus juste
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
function sortDraftsByScoreAndRange(draftList)

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
function rangePrefReport(draftSortiesArg, atoArg)

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
