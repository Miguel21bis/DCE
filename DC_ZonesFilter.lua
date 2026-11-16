--Retire du .miz de la mission les trigger zones dont personne ne se sert.
--Initie par MAIN_NextMission.lua, juste avant la serialisation de la mission (voir le bloc d'appel dans MAIN_NextMission.lua).
-------------------------------------------------------------------------------------------------------
--Pourquoi : base_mission.miz contient beaucoup de zones qui ne servent qu'a ScriptsMod pendant la
--generation (Refpoint : trajectoires de navires, points de CAP, tankers...). Une fois la mission
--generee elles ne servent plus a rien, mais elles etaient recopiees dans nomCampagne_first.miz /
--_ongoing.miz.
--
--ATTENTION : seule la copie ecrite dans le .miz est filtree.
--  - mission.triggers.zones (en memoire) reste complet pendant toute la generation
--  - Active/last_Mission.lua reste complet
--  - la liste complete est remise en place juste apres la serialisation (ZonesBackup)
--
--Une zone est GARDEE si une seule de ces regles s'applique (en cas de doute, on garde) :
--   1) zone visible (sauf si ZONES_DROP_ONLY_HIDDEN = false)
--   2) zone non circulaire, ou avec un champ inconnu (zone liee a une unite...), ou avec des properties
--   3) nom dans les reglages ci-dessous (prefixe, contient, nom exact)
--   4) numero de zone reference par la mission (triggers, taches des groupes...)
--   5) nom de zone cite entre guillemets dans un texte de la mission ou dans un script lua livre
--      avec la mission (Mission Scripts de ScriptsMod, scripts de base_mission.miz)
--Au moindre probleme (script illisible, erreur...) : le filtre est ignore et TOUTES les zones sont recopiees.
--Rapport : Debug/ZonesFilter_Report.txt (une ligne par zone, avec la raison).
-------------------------------------------------------------------------------------------------------

--REGLAGES (peuvent aussi etre poses avant, dans conf_mod.lua)
if ZONES_FILTER == nil then ZONES_FILTER = true end							--false = toutes les zones sont recopiees (comportement d'avant)
if ZONES_DROP_ONLY_HIDDEN == nil then ZONES_DROP_ONLY_HIDDEN = true end		--true = seules les zones CACHEES peuvent etre retirees
if ZONES_KEEP_PREFIX == nil then ZONES_KEEP_PREFIX = { "WG_", "SceneryDestroyZone" } end	--noms commencant par : toujours gardes
if ZONES_KEEP_CONTAINS == nil then ZONES_KEEP_CONTAINS = { "AvoidanceZone" } end			--noms contenant : toujours gardes
if ZONES_KEEP_NAMES == nil then ZONES_KEEP_NAMES = {} end					--noms exacts toujours gardes, ex : { "Ma zone" }
if ZONES_REPORT_FILE == nil then ZONES_REPORT_FILE = "Debug/ZonesFilter_Report.txt" end

ZonesBackup = nil		--liste complete des zones, remplie seulement si le filtre a ete applique

--champs normaux d'une zone ronde ; tout autre champ = zone particuliere, on la garde
local ZONE_STANDARD_KEYS = {
	color = true, heading = true, hidden = true, name = true, properties = true,
	radius = true, type = true, x = true, y = true, zoneId = true,
}

--------------------------------------------------------------------------------------------
-- 1) Ce que la mission reference deja
--------------------------------------------------------------------------------------------

--note les nombres trouves dans une valeur (nombre, texte "12", ou tableau de ceux-ci)
local function noteIds(value, ids, where, depth)
	if depth > 6 then return end
	if type(value) == "number" then
		if not ids[value] then ids[value] = where end
	elseif type(value) == "string" then
		local n = tonumber(value)
		if n and not ids[n] then ids[n] = where end
	elseif type(value) == "table" then
		for _, v in pairs(value) do
			noteIds(v, ids, where, depth + 1)
		end
	end
end

--parcourt toute la mission (sauf la liste des zones elle-meme) et releve :
--  ids   : numeros de zone references    ids[numero] = chemin ou on l'a trouve
--  texts : textes contenant un guillemet (pour y chercher des noms de zone) { where, text }
local function scanMission(mission, zonesTable)

	local ids = {}
	local texts = {}
	local seen = {}

	local function walk(t, path, depth)
		if seen[t] or depth > 60 then return end
		seen[t] = true

		for k, v in pairs(t) do
			local p = path.."/"..tostring(k)

			--toute cle qui contient "zone" (zone, zoneId, zone_to, zones...) : ses nombres sont des numeros de zone possibles
			--(la liste des zones elle-meme s'appelle "zones" : on ne la compte surtout pas comme une reference)
			if v ~= zonesTable and type(k) == "string" and string.find(string.lower(k), "zone", 1, true) then
				noteIds(v, ids, p, 0)
			end

			if type(v) == "string" then

				--texte de trigger du genre a_scenery_destruction_zone(7, 100) : si le nom de la fonction
				--contient "zone" ou "scene", tous les nombres de ses parentheses sont des numeros possibles
				if string.find(v, "(", 1, true) then
					for fname, args in string.gmatch(v, "([%w_]+)%(([^%)]*)%)") do
						local low = string.lower(fname)
						if string.find(low, "zone", 1, true) or string.find(low, "scene", 1, true) then
							for n in string.gmatch(args, "%d+") do
								local num = tonumber(n)
								if not ids[num] then ids[num] = p.." ("..fname..")" end
							end
						end
					end
				end

				--texte avec guillemets : script possible, on pourra y chercher un nom de zone
				if string.find(v, "[\"']") then
					texts[#texts + 1] = { where = p, text = v }
				end

			elseif type(v) == "table" and v ~= zonesTable then
				walk(v, p, depth + 1)
			end
		end
	end

	walk(mission, "mission", 0)
	return ids, texts
end

--------------------------------------------------------------------------------------------
-- 2) Scripts livres avec la mission (pour y chercher des noms de zone)
--------------------------------------------------------------------------------------------

local function readAllText(path)
	local f = io.open(path, "rb")
	if not f then return nil end
	local s = f:read("*a")
	f:close()
	return s
end

--error() si quelque chose est illisible : l'appelant garde alors toutes les zones
local function scriptTexts()

	local out = {}

	--a) scripts livres par ScriptsMod (Mission Scripts)
	local dir = "../../../ScriptsMod."..tostring(VersionPackageICM).."/Mission Scripts"
	local p = io.popen('dir "'..string.gsub(dir, "/", "\\")..'" /b /a-d 2>nul')
	if not p then error("liste de "..dir.." impossible") end

	for name in p:lines() do
		if string.lower(string.sub(name, -4)) == ".lua" then
			local s = readAllText(dir.."/"..name)
			if not s then
				p:close()
				error("lecture impossible : "..dir.."/"..name)
			end
			out[#out + 1] = { where = "Mission Scripts/"..name, text = s }
		end
	end
	p:close()

	if #out == 0 then error("aucun script .lua trouve dans "..dir) end

	--b) scripts .lua deja presents dans base_mission.miz (l10n/DEFAULT)
	local minizip = require('minizip')
	local zf = minizip.unzOpen("Init/base_mission.miz", 'rb')
	if not zf then error("Init/base_mission.miz illisible") end

	zf:unzGoToFirstFile()
	repeat
		local fname = zf:unzGetCurrentFileName()
		if fname and string.find(fname, "^l10n/DEFAULT/.*%.lua$") then
			local s = zf:unzReadAllCurrentFile()
			if s then
				out[#out + 1] = { where = "base_mission.miz/"..fname, text = s }
			end
		end
	until not zf:unzGoToNextFile()
	zf:unzClose()

	return out
end

--le nom est-il cite entre guillemets dans ce texte ? ("nom"  'nom'  \"nom\")
local function nameQuotedIn(text, name)
	return string.find(text, '"'..name..'"', 1, true)
		or string.find(text, "'"..name.."'", 1, true)
		or string.find(text, '"'..name..'\\"', 1, true)
end

--------------------------------------------------------------------------------------------
-- 3) Decision zone par zone
--------------------------------------------------------------------------------------------

--retourne la raison de garder la zone, ou nil si elle peut etre retiree
local function whyKeep(zone, ids, texts)

	if type(zone) ~= "table" then return "entree qui n'est pas une zone" end

	local name = zone.name
	if type(name) ~= "string" or name == "" then return "zone sans nom" end

	if ZONES_DROP_ONLY_HIDDEN and zone.hidden ~= true then
		return "zone visible"
	end

	if zone.type ~= nil and zone.type ~= 0 then
		return "zone non circulaire (type "..tostring(zone.type)..")"
	end

	for k, _ in pairs(zone) do
		if not ZONE_STANDARD_KEYS[k] then
			return "champ inconnu : "..tostring(k)
		end
	end

	if type(zone.properties) == "table" and next(zone.properties) ~= nil then
		return "properties non vides"
	end

	for _, n in ipairs(ZONES_KEEP_NAMES) do
		if name == n then return "nom dans ZONES_KEEP_NAMES" end
	end
	for _, prefix in ipairs(ZONES_KEEP_PREFIX) do
		if string.sub(name, 1, #prefix) == prefix then return "prefixe "..prefix end
	end
	for _, part in ipairs(ZONES_KEEP_CONTAINS) do
		if string.find(name, part, 1, true) then return "nom contient "..part end
	end

	if zone.zoneId ~= nil and ids[zone.zoneId] then
		return "numero reference : "..tostring(ids[zone.zoneId])
	end

	for _, src in ipairs(texts) do
		if nameQuotedIn(src.text, name) then
			return "nom cite dans "..tostring(src.where)
		end
	end

	return nil
end

--retourne la nouvelle liste (tableau 1..n) ; error() en cas de doute
local function filterZones(zones, mission)

	local keys = {}
	for k, _ in pairs(zones) do
		if type(k) ~= "number" then error("liste de zones avec une cle non numerique : "..tostring(k)) end
		keys[#keys + 1] = k
	end
	table.sort(keys)

	local ids, texts = scanMission(mission, zones)

	local scripts = scriptTexts()
	for _, s in ipairs(scripts) do
		texts[#texts + 1] = s
	end

	local kept, removed = {}, {}
	local keptLines, removedLines = {}, {}

	for _, k in ipairs(keys) do
		local zone = zones[k]
		local reason = whyKeep(zone, ids, texts)

		if reason then
			kept[#kept + 1] = zone
			keptLines[#keptLines + 1] = "   id="..tostring(zone.zoneId).."  \""..tostring(zone.name).."\"  : "..reason
		else
			removed[#removed + 1] = zone
			removedLines[#removedLines + 1] = "   id="..tostring(zone.zoneId).."  \""..tostring(zone.name).."\"  (rayon "..tostring(zone.radius).." m, cachee)"
		end
	end

	--rapport
	local f = io.open(ZONES_REPORT_FILE, "w")
	if f then
		f:write("ZonesFilter : "..#keys.." zones dans base_mission + ajouts -> "..#kept.." gardees, "..#removed.." retirees du .miz\n")
		f:write("Reglages : DROP_ONLY_HIDDEN="..tostring(ZONES_DROP_ONLY_HIDDEN).." | scripts lus : "..#scripts.." | numeros de zone references : ")
		local nId = 0
		for _ in pairs(ids) do nId = nId + 1 end
		f:write(nId.."\n\nGARDEES :\n")
		f:write(table.concat(keptLines, "\n").."\n\nRETIREES :\n")
		f:write(table.concat(removedLines, "\n").."\n")
		f:close()
	end

	print("ZonesFilter : "..#keys.." zones -> "..#kept.." gardees, "..#removed.." retirees du .miz (rapport : "..ZONES_REPORT_FILE..")")

	return kept
end

--------------------------------------------------------------------------------------------
-- 4) Application : la liste filtree remplace la liste complete le temps de la serialisation
--------------------------------------------------------------------------------------------
if ZONES_FILTER and mission and type(mission.triggers) == "table" and type(mission.triggers.zones) == "table" then

	local ok, result = pcall(filterZones, mission.triggers.zones, mission)

	if ok and result then
		ZonesBackup = mission.triggers.zones
		mission.triggers.zones = result
	else
		print("ZonesFilter : filtre ignore, TOUTES les zones sont recopiees ("..tostring(result)..")")
		if AddLog then AddLog("ZonesFilter ignore : "..tostring(result)) end
	end
end
