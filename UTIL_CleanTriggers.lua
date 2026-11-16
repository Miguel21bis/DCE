--Nettoie Init/camp_triggers_init.lua (campaignMaker seulement, jamais pendant une partie).
--Supprime le BLOC ENTIER de tout trigger qui :
--  1) référence un groupe / une unité / un static absent de Init/base_mission.miz
--  2) ou utilise un template (Action.TemplateActive / Action.TemplateDeactivate)
--Active/ n'est pas touché.
--
--Ce fichier ne fait rien tout seul : il définit la fonction globale
--   ok, nbASupprimer, noms = CleanTriggersInit(apply)
-- apply = false/nil : AUDIT (rien n'est écrit, seulement un rapport)
-- apply = true      : suppression réelle
--Elle est appelée depuis le menu de BAT_FirstMission.lua (choix [K]) : audit, puis confirmation.
--En mode apply : sauvegarde Init/camp_triggers_init.lua.bak_AAAAMMJJ_HHMMSS, vérification
--du résultat en mémoire, écriture, relecture. Si un contrôle échoue, le fichier d'origine est remis.
-------------------------------------------------------------------------------------------------------

local PATH_TRIGGERS = "Init/camp_triggers_init.lua"
local PATH_MIZ      = "Init/base_mission.miz"
local PATH_REPORT   = "Debug/CleanTriggers_report.txt"

--Fonctions de trigger dont certains arguments sont des noms de groupe / unité / static.
--Les chiffres sont les positions des arguments à vérifier. Nouvelle Action ? Ajouter une ligne ici.
local FONCTIONS_NOMS = {
	["Return.UnitDead"]         = {1},
	["Return.GroupHidden"]      = {1},
	["Return.GroupProbability"] = {1},
	["Return.ShipGroupInPoly"]  = {1},
	["Action.KillPedro"]        = {1},
	["Action.GroupHidden"]      = {1},
	["Action.GroupProbability"] = {1},
	["Action.GroupMove"]        = {1},
	["Action.GroupSlave"]       = {1, 2},
	["Action.ShipMission"]      = {1},
}

--Tout trigger qui utilise une de ces fonctions est supprimé
local FONCTIONS_TEMPLATE = { "Action.TemplateActive", "Action.TemplateDeactivate" }


----- rapport -----
local report = {}

local function Log(msg)
	table.insert(report, msg)
	print("CleanTriggers " .. msg)		--pas AddLog : il remplit BugList et ouvre la fenêtre de bugs
end


----- lecture / écriture de fichier (binaire, pour garder exactement les fins de ligne) -----
local function LireFichier(chemin)
	local f = io.open(chemin, "rb")
	if not f then return nil end
	local s = f:read("*a")
	f:close()
	return s
end

local function EcrireFichier(chemin, texte)
	local f = io.open(chemin, "wb")
	if not f then return false end
	f:write(texte)
	f:close()
	return true
end


----- noms des groupes / unités / statics de base_mission.miz -----
local function NomsDuMiz()
	local ok, minizip = pcall(require, 'minizip')
	if not ok then return nil, "minizip not available" end

	local zip = minizip.unzOpen(PATH_MIZ, 'rb')
	if not zip then return nil, "cannot open " .. PATH_MIZ end
	zip:unzLocateFile('mission')
	local misStr = zip:unzReadAllCurrentFile()
	zip:unzClose()

	--la mission est lue dans un environnement à part, pour ne pas écraser la variable mission du moteur
	local chunk = loadstring(misStr or "")
	if not chunk then return nil, "mission file unreadable" end
	local env = {}
	setfenv(chunk, env)
	if not pcall(chunk) or type(env.mission) ~= "table" then
		return nil, "mission table not found"
	end

	local noms = {}
	local nb = 0
	local dictKey = false

	local function ajoute(nom)
		if type(nom) == "string" then
			noms[nom] = true
			nb = nb + 1
			if string.find(nom, "^DictKey_") then dictKey = true end
		end
	end

	for _, side in pairs(env.mission.coalition or {}) do
		for _, country in pairs(side.country or {}) do
			for _, categorie in pairs(country) do					--plane, helicopter, vehicle, ship, static
				if type(categorie) == "table" and categorie.group then
					for _, group in pairs(categorie.group) do
						ajoute(group.name)
						for _, unit in pairs(group.units or {}) do
							ajoute(unit.name)
						end
					end
				end
			end
		end
	end

	--garde-fou : si les noms ne sont pas lisibles, tout serait vu comme absent et tout serait supprimé
	if nb == 0 then return nil, "no group found in " .. PATH_MIZ end
	if dictKey then return nil, "names are DictKey_ (dictionary not handled), stopped for safety" end

	return noms, nb
end


----- découpe le fichier en blocs de triggers (chaque { ... } du premier niveau de camp_triggers) -----
local function TrouveBlocs(texte)
	local blocs = {}
	local profondeur = 0
	local ouv
	local i = 1
	local n = #texte

	while i <= n do
		local c = string.sub(texte, i, i)

		if c == "-" and string.sub(texte, i, i + 1) == "--" then
			--commentaire (ligne ou bloc --[[ ]])
			local long = string.match(texte, "^%-%-%[(=*)%[", i)
			if long then
				local _, e = string.find(texte, "]" .. long .. "]", i, true)
				i = (e or n) + 1
			else
				local e = string.find(texte, "\n", i, true)
				i = (e or n) + 1
			end

		elseif c == '"' or c == "'" then
			--chaîne : on saute jusqu'au guillemet fermant (les accolades dedans ne comptent pas)
			local j = i + 1
			while j <= n do
				local d = string.sub(texte, j, j)
				if d == "\\" then
					j = j + 2
				elseif d == c then
					break
				else
					j = j + 1
				end
			end
			i = j + 1

		elseif c == "[" and string.match(texte, "^%[=*%[", i) then
			--chaîne longue [[ ... ]]
			local long = string.match(texte, "^%[(=*)%[", i)
			local _, e = string.find(texte, "]" .. long .. "]", i, true)
			i = (e or n) + 1

		elseif c == "{" then
			profondeur = profondeur + 1
			if profondeur == 2 then ouv = i end
			i = i + 1

		elseif c == "}" then
			if profondeur == 2 then
				table.insert(blocs, { ouv = ouv, ferm = i })
			end
			profondeur = profondeur - 1
			i = i + 1

		else
			i = i + 1
		end
	end

	return blocs
end


----- zone de texte à effacer pour un bloc : lignes entières, virgule finale comprise -----
local function ZoneASupprimer(texte, bloc)
	--début de la ligne qui contient l'accolade ouvrante
	local debutLigne = bloc.ouv
	while debutLigne > 1 and string.sub(texte, debutLigne - 1, debutLigne - 1) ~= "\n" do
		debutLigne = debutLigne - 1
	end
	local avant = string.sub(texte, debutLigne, bloc.ouv - 1)

	local debut
	local ligneEntiere = true
	if string.find(avant, "}") then
		--un autre bloc est sur la même ligne : on part de l'accolade
		debut = bloc.ouv
		ligneEntiere = false
	else
		debut = debutLigne
		--clef écrite sur la ligne précédente :   ["nom"] =   puis { à la ligne
		if not string.find(avant, "%S") and debutLigne > 1 then
			local finPrec = debutLigne - 1
			local debutPrec = finPrec
			while debutPrec > 1 and string.sub(texte, debutPrec - 1, debutPrec - 1) ~= "\n" do
				debutPrec = debutPrec - 1
			end
			local lignePrec = string.sub(texte, debutPrec, finPrec)
			if string.find(lignePrec, "=%s*$") and not string.find(lignePrec, "^%s*%-%-") then
				debut = debutPrec
			end
		end
	end

	--fin : accolade fermante, virgule éventuelle, puis le retour à la ligne si la fin de ligne est vide
	local fin = bloc.ferm
	local reste = string.match(texte, "^[ \t]*,?", fin + 1)
	fin = fin + #reste
	if ligneEntiere then
		local suite = string.match(texte, "^[ \t]*\r?\n()", fin + 1)
		if suite then fin = suite - 1 end
	end

	return debut, fin
end


----- lit les arguments texte d'un appel de fonction (pos = juste après la parenthèse) -----
local function LitArguments(s, pos, nbMax)
	local args = {}
	for k = 1, nbMax do
		local _, e, guillemet = string.find(s, "^%s*([\"'])", pos)
		if not guillemet then break end				--argument qui n'est pas un texte : on ne peut pas l'analyser

		local debut = e + 1
		local j = debut
		while j <= #s do
			local d = string.sub(s, j, j)
			if d == "\\" then
				j = j + 2
			elseif d == guillemet then
				break
			else
				j = j + 1
			end
		end
		args[k] = string.sub(s, debut, j - 1)

		local _, e2 = string.find(s, "^%s*,", j + 1)
		if not e2 then break end
		pos = e2 + 1
	end
	return args
end


----- cherche, dans une condition ou une action, les références à supprimer -----
local function ChercheRefs(s, noms, resultat)
	for fonction, positions in pairs(FONCTIONS_NOMS) do
		local motif = string.gsub(fonction, "%.", "%%.") .. "%s*%("
		local maxPos = 0
		for _, p in ipairs(positions) do
			if p > maxPos then maxPos = p end
		end

		local init = 1
		while true do
			local _, e = string.find(s, motif, init)
			if not e then break end
			local args = LitArguments(s, e + 1, maxPos)
			for _, p in ipairs(positions) do
				local nom = args[p]
				if nom and not noms[nom] then
					table.insert(resultat, fonction .. ' "' .. nom .. '" not in base_mission.miz')
				end
			end
			init = e + 1
		end
	end

	for _, fonction in ipairs(FONCTIONS_TEMPLATE) do
		local motif = string.gsub(fonction, "%.", "%%.") .. "%s*%("
		if string.find(s, motif) then
			table.insert(resultat, fonction .. " (template)")
		end
	end
end


----- analyse un bloc : renvoie son nom et la liste de ses références à supprimer -----
local function AnalyseBloc(texte, bloc, noms)
	local info = { refs = {}, nom = "?" }

	local f = loadstring("return " .. string.sub(texte, bloc.ouv, bloc.ferm))
	if not f then
		info.illisible = true
		return info
	end
	setfenv(f, {})
	local ok, t = pcall(f)
	if not ok or type(t) ~= "table" then
		info.illisible = true
		return info
	end

	info.nom = tostring(t.name or "?")

	if type(t.condition) == "string" then
		ChercheRefs(t.condition, noms, info.refs)
	end
	if type(t.action) == "string" then
		ChercheRefs(t.action, noms, info.refs)
	elseif type(t.action) == "table" then
		for _, a in pairs(t.action) do
			if type(a) == "string" then
				ChercheRefs(a, noms, info.refs)
			end
		end
	end

	return info
end


----- compte les triggers d'un texte de camp_triggers_init.lua (nil si le texte ne se charge pas) -----
local function CompteTriggers(texte)
	local f = loadstring(texte)
	if not f then return nil end
	local env = {}
	setfenv(f, env)
	if not pcall(f) or type(env.camp_triggers) ~= "table" then return nil end
	local nb = 0
	for _ in pairs(env.camp_triggers) do nb = nb + 1 end
	return nb
end


----- fonction principale -----
function CleanTriggersInit(apply)
	report = {}
	Log("---- " .. os.date("%Y-%m-%d %H:%M:%S") .. " ----")
	Log("mode: " .. (apply and "APPLY" or "AUDIT (nothing is written)"))

	local noms, nbNoms = NomsDuMiz()
	if not noms then
		Log("ERROR " .. tostring(nbNoms))
		return false, 0, {}
	end
	Log(nbNoms .. " names (groups and units) read in " .. PATH_MIZ)

	local texte = LireFichier(PATH_TRIGGERS)
	if not texte then
		Log("ERROR cannot read " .. PATH_TRIGGERS)
		return false, 0, {}
	end

	local blocs = TrouveBlocs(texte)
	if #blocs == 0 then
		Log("ERROR no trigger block found in " .. PATH_TRIGGERS)
		return false, 0, {}
	end

	--analyse de chaque bloc
	local aSupprimer = {}
	local reussi = true
	local listeNoms = {}
	for n, bloc in ipairs(blocs) do
		local info = AnalyseBloc(texte, bloc, noms)
		if info.illisible then
			Log("SKIP block " .. n .. " : cannot be read, left untouched")
		elseif #info.refs > 0 then
			bloc.nom = info.nom
			table.insert(aSupprimer, bloc)
			table.insert(listeNoms, info.nom)
			Log("REMOVE \"" .. info.nom .. "\" : " .. table.concat(info.refs, " ; "))
		end
	end
	Log(#blocs .. " triggers, " .. #aSupprimer .. " to remove")

	if #aSupprimer == 0 then
		Log("nothing to do")
	elseif apply then
		--construction du nouveau texte, en partant de la fin pour ne pas décaler les positions
		local nouveau = texte
		for k = #aSupprimer, 1, -1 do
			local debut, fin = ZoneASupprimer(texte, aSupprimer[k])
			nouveau = string.sub(nouveau, 1, debut - 1) .. string.sub(nouveau, fin + 1)
		end

		--contrôles en mémoire : le texte se charge, le bon nombre de triggers reste, plus aucune référence
		local nbAttendu = #blocs - #aSupprimer
		local nbApres = CompteTriggers(nouveau)
		local blocsApres = TrouveBlocs(nouveau)
		local restes = 0
		for _, bloc in ipairs(blocsApres) do
			local info = AnalyseBloc(nouveau, bloc, noms)
			if #info.refs > 0 then restes = restes + 1 end
		end

		if nbApres ~= nbAttendu or #blocsApres ~= nbAttendu or restes > 0 then
			Log("ERROR check failed (triggers after: " .. tostring(nbApres) .. ", expected: " .. nbAttendu .. ", still invalid: " .. restes .. "), file NOT modified")
			reussi = false
		else
			local cheminBak = PATH_TRIGGERS .. ".bak_" .. os.date("%Y%m%d_%H%M%S")
			if not EcrireFichier(cheminBak, texte) then
				Log("ERROR cannot write backup " .. cheminBak .. ", file NOT modified")
				reussi = false
			elseif not EcrireFichier(PATH_TRIGGERS, nouveau) then
				Log("ERROR cannot write " .. PATH_TRIGGERS .. ", restoring backup")
				EcrireFichier(PATH_TRIGGERS, texte)
				reussi = false
			elseif LireFichier(PATH_TRIGGERS) ~= nouveau then
				Log("ERROR file read back is different, restoring backup")
				EcrireFichier(PATH_TRIGGERS, texte)
				reussi = false
			else
				Log("DONE " .. #aSupprimer .. " triggers removed, backup: " .. cheminBak)
			end
		end
	else
		Log("AUDIT only: run again in apply mode to remove them")
	end

	EcrireFichier(PATH_REPORT, table.concat(report, "\n") .. "\n")		--ignoré si le dossier Debug n'existe pas
	return reussi, #aSupprimer, listeNoms
end
