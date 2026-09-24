--Synchronise les formations gérées par le wargame (DCE_Manager) depuis targetlist vers oob_ground.
--Initiated by MAIN_NextMission.lua, AVANT le premier DC_UpdateTargetlist.lua du cycle
--(pour que oobGroupIndex retrouve les groupes fraichement créés/déplacés dès CE cycle).
-------------------------------------------------------------------------------------------------------
if not versionDCE then versionDCE = {} end
versionDCE["DC_UpdateWargame.lua"] = "1.1.1"
-------------------------------------------------------------------------------------------------------
-- ScriptsMod ne décide jamais rien pour une formation wargame (position, force, vie/mort...) :
-- ce fichier ne fait QUE réconcilier oob_ground avec ce que targetlist contient déjà.
-- Ne touche JAMAIS un groupe qui n'a pas wargameFormationId.
--
-- Corrélation element <-> unité de template : par NOM EXACT (element.templateUnitName), fourni par
-- DCE_Manager. Un template peut contenir plusieurs country/category/group : chaque groupe-template
-- engendre un groupe oob_ground distinct, nommé target.name (1er groupe rencontré en parcourant le
-- template) puis target.name.."#"..n (suivants). Cf mémoire "DCE wargame sync" pour l'historique.
-------------------------------------------------------------------------------------------------------

if Debug.debug then
	print("START DC_UpdateWargame.lua "..versionDCE["DC_UpdateWargame.lua"].." =-=-=-=-=-=-=-=-=-=-=-=-=-=-=")
end

--log a la fois visible en console (pour debug immediat) ET conserve dans BugList (comme le reste du code)
local function dcuwLog(msg)
	print(msg)
	AddLog(msg)
end

--ordre fixe et arbitraire (mais déterministe) de parcours des catégories d'un country du template
--sert uniquement à numéroter les groupes de façon stable d'un cycle à l'autre, PAS à la corrélation des unités
local WARGAME_CATEGORY_ORDER = {"static", "vehicle", "ship"}

--cache des templates déjà chargés/analysés dans ce cycle (plusieurs formations peuvent partager un template)
local templateDataCache = {}

--aplatit le template dans un ordre déterministe : country[1..N] -> category fixe -> group[1..M]
--retourne une liste ordonnée de {country=, category=, group=}
local function flattenTemplateGroups(loadedTemplate, targetside)
	local flat = {}

	if not loadedTemplate.coalition or not loadedTemplate.coalition[targetside] then
		return flat
	end

	local countries = loadedTemplate.coalition[targetside].country
	if not countries then return flat end

	--les index de country[] dans un template ne sont PAS contigus à partir de 1 : ils reprennent la
	--numérotation d'origine de la liste de countries de la mission de base (seuls les countries
	--réellement présents dans le template ont une entrée). #countries / for=1,#countries est donc FAUX
	--ici (peut renvoyer 0 si country[1] n'existe pas) -> on trie les clés numériquement à la place,
	--pour garder malgré tout un ordre de parcours déterministe d'un chargement à l'autre.
	local countryKeys = {}
	for countryN, _ in pairs(countries) do
		table.insert(countryKeys, countryN)
	end
	table.sort(countryKeys)

	for _, countryN in ipairs(countryKeys) do
		local country = countries[countryN]
		for _, category in ipairs(WARGAME_CATEGORY_ORDER) do
			if country[category] and country[category].group then
				local groups = country[category].group
				for groupN = 1, #groups do
					table.insert(flat, {
						country = country,
						category = category,
						group = groups[groupN],
					})
				end
			end
		end
	end

	return flat
end

--tente de charger un fichier .stm depuis Templates/wargame_<side>/, sans logguer d'erreur
--(les échecs "attendus" - ex: tentative sur le mauvais côté - sont gérés par l'appelant)
local function tryLoadTemplateFile(side, fileName)
	local path = "Init/Wargame/Templates_"..side.."/"..tostring(fileName)
	local ok, err = pcall(dofile, path)

	if not ok or not staticTemplate then
		return nil
	end

	local loaded = staticTemplate
	staticTemplate = nil						--evite qu'un dofile suivant (hors wargame) ne retrouve une valeur perimee par erreur
	return loaded
end

--charge (ou récupère du cache) un template wargame pour une formation donnée : essaie d'abord le
--côté attendu (celui de la formation dans targetlist), puis l'autre côté en repli SILENCIEUX.
--Ce repli est actuellement nécessaire pendant la transition côté DCE_Manager sur la convention de
--rangement des formations wargame dans targetlist (cf mémoire "DCE wargame sync... targetside
--mapping") : une même campagne peut temporairement contenir des formations rangées selon l'ancienne
--ET la nouvelle convention. Ne logue une ERREUR que si les DEUX côtés échouent.
--Retourne templateData (flatGroups + unitIndex) ET le côté réellement résolu (peut différer de expectedSide).
local function getWargameTemplateData(expectedSide, fileName)
	local otherSide = (expectedSide == "red") and "blue" or "red"

	for _, side in ipairs({expectedSide, otherSide}) do
		local cacheKey = side.."|"..tostring(fileName)

		if templateDataCache[cacheKey] == nil then
			local loaded = tryLoadTemplateFile(side, fileName)

			if not loaded then
				templateDataCache[cacheKey] = false
			else
				local flatGroups = flattenTemplateGroups(loaded, side)

				if #flatGroups == 0 then
					templateDataCache[cacheKey] = false		--fichier trouvé mais rien d'exploitable pour ce côté (coalition[side] vide)
				else
					local unitIndex = {}
					for ordinal, entry in ipairs(flatGroups) do
						for _, unit in ipairs(entry.group.units) do
							if unitIndex[unit.name] then
								dcuwLog("DcUW ATTENTION: nom d'unite en double dans le template |Templates/wargame_"..side.."/"..tostring(fileName).."| : |"..tostring(unit.name).."| (occurrences suivantes ignorées)")
							else
								unitIndex[unit.name] = {
									ordinal = ordinal,
									unit = unit,
									group = entry.group,
									country = entry.country,
									category = entry.category,
								}
							end
						end
					end

					templateDataCache[cacheKey] = { flatGroups = flatGroups, unitIndex = unitIndex }
				end
			end
		end

		if templateDataCache[cacheKey] then
			return templateDataCache[cacheKey], side
		end
	end

	--échec sur les deux côtés: là, c'est une vraie erreur
	dcuwLog("DcUW ERREUR: impossible de charger le template wargame |"..tostring(fileName).."| (essayé sous Templates/wargame_"..expectedSide.."/ et Templates/wargame_"..otherSide.."/)")
	return nil, nil
end

--indexe tous les (sous-)groupes wargame déjà présents dans oob_ground,
--par wargameFormationId puis par wargameGroupOrdinal (lecture seule, utilisé pour l'upsert)
local function indexExistingWargameGroups()
	local index = {}
	for sideName, countries in pairs(oob_ground) do
		for countryN, country in pairs(countries) do
			for category, classG in pairs(country) do
				if (category == "vehicle" or category == "static" or category == "ship") and type(classG) == "table" and classG.group then
					for _, group in pairs(classG.group) do
						if group.wargameFormationId then
							index[group.wargameFormationId] = index[group.wargameFormationId] or {}
							index[group.wargameFormationId][group.wargameGroupOrdinal or 1] = group
						end
					end
				end
			end
		end
	end
	return index
end

--retrouve ou crée le country cible dans oob_ground[targetside], calqué sur le country déclaré dans le template
local countryIndexCache = {}
local function getOrCreateCountryGroupList(targetside, templateCountry, category)
	if not countryIndexCache[targetside] then
		countryIndexCache[targetside] = {}
		for countryN, country in pairs(oob_ground[targetside]) do
			if country.name then
				countryIndexCache[targetside][country.name] = countryN
			end
		end
	end

	local countryIndex = countryIndexCache[targetside]
	local countryN = countryIndex[templateCountry.name]

	if not countryN then
		local maxCountryN = 0
		for n, _ in pairs(oob_ground[targetside]) do
			if n > maxCountryN then maxCountryN = n end
		end
		countryN = maxCountryN + 1

		oob_ground[targetside][countryN] = {
			["id"] = templateCountry.id,
			["name"] = templateCountry.name,
			[category] = {
				["group"] = {},
			}
		}
		countryIndex[templateCountry.name] = countryN
	end

	if not oob_ground[targetside][countryN][category] then
		oob_ground[targetside][countryN][category] = {
			["group"] = {},
		}
	end

	return oob_ground[targetside][countryN][category].group
end

--reconstruit entièrement les units d'un groupe oob_ground depuis un paquet d'elements
--(ceux dont le templateUnitName pointe vers CE groupe de template précis)
--corrélation par NOM EXACT (element.templateUnitName -> unitIndex), plus d'index/ordre
local function rebuildUnitsFromBucket(group, elements, unitIndex)
	group.units = {}

	for _, element in ipairs(elements) do
		local entry = unitIndex[element.templateUnitName]
		local templateUnit = entry and entry.unit

		if templateUnit then
			local newUnit = DeepCopy(templateUnit)

			newUnit.name = element.name
			newUnit.x = element.x
			newUnit.y = element.y
			if element.heading then							--sinon on garde le heading du template (repli)
				newUnit.heading = element.heading
			end

			if UnitByName[newUnit.name] then
				newUnit.unitId = UnitByName[newUnit.name]			--meme nom => meme unite d'un cycle a l'autre, on garde son id
			else
				newUnit.unitId = GenerateIDUnit(newUnit.name, newUnit.type)
			end

			table.insert(group.units, newUnit)
		end
	end
end

--=====================================================================================================
-- 1) upsert: crée ou met à jour chaque (sous-)groupe de chaque formation wargame présente dans targetlist
--=====================================================================================================

local existingWargameGroups = indexExistingWargameGroups()
local wargameFormationSeen = {}				--[formationId][groupOrdinal] = true si toujours produit ce cycle

local dbgFormationsFound = 0					--nb de targets avec wargameFormation==true rencontrés dans targetlist
local dbgGroupsUpserted = 0					--nb de (sous-)groupes oob_ground créés ou mis à jour
local dbgGroupsRemoved = 0						--nb de (sous-)groupes oob_ground retirés

for sideName, targets in pairs(targetlist) do
	for target_key, target in pairs(targets) do
		if target.wargameFormation and target.wargameFormationId then

			dbgFormationsFound = dbgFormationsFound + 1

			--a ce point du cycle, targetlist n'a pas encore été passé par TargetlistToNum()
			--(1er appel de DC_UpdateTargetlist.lua, APRES ce fichier) : target.name/titleName
			--peuvent donc ne pas encore exister, seule la clé du dictionnaire est fiable
			if not target.name then target.name = target_key end
			if not target.titleName then target.titleName = target_key end

			--côté attendu, d'après la convention actuelle de rangement dans targetlist (cf mémoire
			--"DCE wargame sync... targetside mapping"). getWargameTemplateData essaiera aussi
			--l'autre côté en repli silencieux si besoin, et renverra le côté réellement résolu.
			local expectedSide = sideName

			local templateData, targetside = getWargameTemplateData(expectedSide, target.wargameTemplate)

			if not templateData then
				--erreur déjà loguée par getWargameTemplateData (échec sur les deux côtés)

			else
				--regroupe les elements du target par groupe-template d'origine (via templateUnitName)
				local buckets = {}							--ordinal -> liste d'elements

				if target.elements then
					for _, element in pairs(target.elements) do
						local key = element.templateUnitName

						if not key then
							dcuwLog("DcUW ERREUR: element |"..tostring(element.name).."| (formation |"..tostring(target.name).."|) n'a pas de templateUnitName, element ignoré")
						else
							local entry = templateData.unitIndex[key]
							if not entry then
								dcuwLog("DcUW ERREUR: templateUnitName |"..tostring(key).."| (element |"..tostring(element.name).."|, formation |"..tostring(target.name).."|) introuvable dans le template |"..tostring(target.wargameTemplate).."|")
							else
								buckets[entry.ordinal] = buckets[entry.ordinal] or {}
								table.insert(buckets[entry.ordinal], element)
							end
						end
					end
				end

				local mainGroupFound = false

				for groupOrdinal, templateEntry in ipairs(templateData.flatGroups) do
					local bucketElements = buckets[groupOrdinal]

					if bucketElements and #bucketElements > 0 then

						local templateGroup = templateEntry.group
						local templateCountry = templateEntry.country
						local category = templateEntry.category

						local oobGroupName = target.name
						if groupOrdinal > 1 then
							oobGroupName = target.name.."#"..groupOrdinal
						end

						local group = existingWargameGroups[target.wargameFormationId]
							and existingWargameGroups[target.wargameFormationId][groupOrdinal]

						if not group then
							--nouveau (sous-)groupe: on clone la structure du groupe du template (route, heading, task...)
							group = DeepCopy(templateGroup)
							group.groupId = GenerateIDGroup(oobGroupName)
							group.taskSelected = true							--convention reprise de Action.TemplateActive

							local groupList = getOrCreateCountryGroupList(targetside, templateCountry, category)
							table.insert(groupList, group)

							existingWargameGroups[target.wargameFormationId] = existingWargameGroups[target.wargameFormationId] or {}
							existingWargameGroups[target.wargameFormationId][groupOrdinal] = group
						end

						group.name = oobGroupName
						group.wargameFormationId = target.wargameFormationId
						group.wargameGroupOrdinal = groupOrdinal
						group.wargameTemplateGroupName = templateGroup.name		--traçabilité/debug: nom du groupe d'origine dans le .stm

						--position du groupe = position du 1er element du paquet
						local firstElement = bucketElements[1]
						group.x = firstElement.x
						group.y = firstElement.y

						if group.route and group.route.points and group.route.points[1] then
							group.route.points[1].x = group.x
							group.route.points[1].y = group.y
						end

						--heading du groupe = heading du 1er element du paquet (meme convention que x/y ci-dessus).
						--Uniquement si le groupe porte deja un heading de groupe (cas des groupes "static", qui
						--n'ont qu'une unite) : les groupes "vehicle" n'en ont pas dans le template, on ne
						--rajoute pas artificiellement un champ que DCS n'attend pas sur ces groupes-la.
						if group.heading and firstElement.heading then
							group.heading = firstElement.heading
						end

						rebuildUnitsFromBucket(group, bucketElements, templateData.unitIndex)

						dbgGroupsUpserted = dbgGroupsUpserted + 1

						wargameFormationSeen[target.wargameFormationId] = wargameFormationSeen[target.wargameFormationId] or {}
						wargameFormationSeen[target.wargameFormationId][groupOrdinal] = true

						if groupOrdinal == 1 then
							mainGroupFound = true
						end
					end
				end

				if mainGroupFound then
					target.foundOobGround = true			--le groupe #1 (nommé target.name) porte le lien principal utilisé par oobGroupIndex[target.name]
				else
					dcuwLog("DcUW ERREUR: formation |"..tostring(target.name).."| n'a produit aucun groupe principal (aucun element corrélé au 1er groupe du template ?)")
				end
			end
		end
	end
end

--=====================================================================================================
-- 2) retire d'oob_ground les (sous-)groupes qui ne sont plus produits ce cycle
--    (formation supprimée, ou groupe-template devenu vide côté targetlist)
--=====================================================================================================

for sideName, countries in pairs(oob_ground) do
	for countryN, country in pairs(countries) do
		for category, classG in pairs(country) do
			if (category == "vehicle" or category == "static" or category == "ship") and type(classG) == "table" and classG.group then
				for groupN = #classG.group, 1, -1 do
					local group = classG.group[groupN]
					if group.wargameFormationId then
						local seenGroups = wargameFormationSeen[group.wargameFormationId]
						local stillPresent = seenGroups and seenGroups[group.wargameGroupOrdinal or 1]

						if not stillPresent then
							if Debug.debug then
								print("DcUW retrait sous-groupe wargame disparu, formationId "..tostring(group.wargameFormationId).." ordinal "..tostring(group.wargameGroupOrdinal).." nom "..tostring(group.name))
							end
							table.remove(classG.group, groupN)
							dbgGroupsRemoved = dbgGroupsRemoved + 1
						end
					end
				end
			end
		end
	end
end

print("DcUW synthese: "..dbgFormationsFound.." formation(s) wargame trouvee(s) dans targetlist, "..dbgGroupsUpserted.." (sous-)groupe(s) cree(s)/mis a jour, "..dbgGroupsRemoved.." groupe(s) retire(s)")
