--=======================================================================================
-- ATO_FP_Check.lua  (appelé par ATO_FlightPlan.lua, via Include)
-- Contrôle automatique du FlightPlan. Il ne modifie RIEN dans la mission : il observe.
--
-- Il écrit :
--   Debug\ATO_FlightPlan_LOG\FlightPlan_Check.txt   rapport de la génération (lire le VERDICT et le tableau des REGLES en haut)
--   Debug\ATO_FlightPlan_LOG\FlightPlan_Crash.txt   seulement si le FlightPlan plante : où (vol, phase), pourquoi, pile d'appels
-- et ajoute une ligne AddLog "|+FPCHK|" par problème grave.
--
-- Ce qu'il vérifie :
--   1. les fichiers ATO_FP_xx ont bien rendu tout ce que ATO_FlightPlan.lua attend (les "ponts")
--   2. aucune variable oubliée (lue sans exister) ni globale créée par erreur
--   3. REGLES : pour CHAQUE avion / hélicoptère de la mission (groupe, unités, waypoints, tâches,
--      cohérence ATO <-> mission). Le rapport donne pour chaque règle  "vérifiés / en échec"  + 3 exemples.
--   4. une signature de chaque groupe, à comparer avant / après
--
-- Pour le couper : CHECK_ACTIF = false.
-- Si ce contrôle plante lui-même, il est ignoré : il ne peut pas bloquer la génération.
--=======================================================================================

local CHECK_ACTIF = true

-- Dossier des fichiers de log du FlightPlan (créé s'il n'existe pas) : Debug\ATO_FlightPlan_LOG\
local DOSSIER_LOG = "Debug/ATO_FlightPlan_LOG"
local dossierPret = false
function AtoFP.LogPath(nom)
	if not dossierPret then
		dossierPret = true
		pcall(os.execute, 'mkdir "Debug\\ATO_FlightPlan_LOG" >nul 2>nul')		-- sans erreur si le dossier existe déjà
	end
	local chemin = DOSSIER_LOG .. "/" .. nom
	local test = io.open(chemin, "a")			-- le dossier n'a pas pu être créé : on retombe sur Debug/
	if test then test:close() else chemin = "Debug/" .. nom end
	return chemin
end

local globalLu = {}					-- noms globaux lus alors qu'ils n'existent pas (nil)
local globalCree = {}				-- noms globaux créés pendant le FlightPlan
local sousSurveillance = false

-- Ce que ATO_FlightPlan.lua doit avoir reçu des fichiers ATO_FP_xx
local attendu = {
	{ "function", "getCallsign" }, { "function", "Get_L16_Id" }, { "function", "Get_SADL_Id" },
	{ "function", "get_IDM_Id" }, { "function", "getTankerTACAN" }, { "function", "fct_movedBullseye" },
	{ "function", "modify_Activate_GroupTime" }, { "function", "spawnOn" },
	{ "function", "activate_Group_WithFlag" }, { "function", "activate_group_time_after" },
	{ "function", "start_Set_Ai_Task" }, { "function", "createBombingChapter" }, { "function", "dbg" },
	{ "function", "Task_Option" }, { "function", "Task_Script" }, { "function", "Task_EngageAir" },
	{ "function", "Task_Orbit" }, { "function", "Task_Service" }, { "function", "Task_CarpetBombing" },
	{ "function", "Task_AttackGroup" }, { "function", "Task_Bombing" }, { "function", "Task_FAC" },
	{ "function", "Task_Follow" }, { "function", "FlightTriggersAndDebug" }, { "function", "FlightDatalink" }, { "function", "LogPath" }, { "function", "FlightInsertInMission" }, { "function", "PrepBaseAndModules" }, { "function", "PrepParking" }, { "function", "PrepWeaponAndTask" }, { "function", "PrepTaskCheck" }, { "function", "WpBuild" }, { "function", "WpSpecialCases" }, { "function", "WpTypesSpeeds" }, { "function", "WpAltitudeLand" }, { "function", "WpDepartureSpawn" }, { "function", "WpAttackPrep" }, { "function", "WpIpAttack" }, { "function", "WpTaskByRole" }, { "function", "WpStationAssemble" }, { "function", "WpSeadEgressRecon" }, { "function", "WpHumanBriefing" }, { "function", "FlightAfterWaypoints" }, { "function", "FlightCreateUnits" }, { "function", "FlightFrequencyAndGroup" }, { "function", "FlightGroupAndSpawn" }, { "function", "FlightSarAlert" }, { "function", "FlightInterceptAwacs" }, { "function", "FlightPedroSar" }, { "function", "FlightStartAndCallsign" }, { "function", "FlightRecovery" },
	{ "table", "pack_L16_unitId" }, { "table", "pack_SADL_unitId" }, { "table", "pack_IDM_unitId" },
	{ "table", "callSignFlight" }, { "table", "callSignFlightUnite" }, { "table", "tacan_byTarget" },
	{ "table", "callSign_west_counter" }, { "table", "testDeckPlace" }, { "table", "cv_deckReservations" },
	{ "table", "cv_testSixPack" }, { "table", "tempBaseAirStart" }, { "string", "debugTxt_AtoFP" },
}
-- Fonctions qui doivent rester globales (utilisées par d'autres fichiers)
local attenduGlobal = { "GetSidenumber", "GeWpindex" }

-- Globales qui peuvent légitimement ne pas exister (lues avec "if X and ..." par d'autres fichiers)
local optionnel = {
	TypeAlias = "optionnel, défini dans Init/various_table.lua",
	BaseNameAlias = "optionnel, défini dans Init/various_table.lua",
}

-- Les REGLES. grave = true : une règle en échec est une ERREUR. grave = false : une ALERTE.
local listeRegles = {
	{ "G01", true,  "groupe aérien : name, groupId, x, y valides" },
	{ "G02", false, "groupe aérien : frequency > 0" },
	{ "G03", false, "groupe aérien : start_time et task définis" },
	{ "U01", true,  "unité aérienne : unitId, name, type, skill, x, y valides" },
	{ "U02", false, "unité aérienne : callsign et onboard_num définis" },
	{ "U03", false, "unité aérienne : payload (pylons, fuel) défini" },
	{ "U04", "info", "unité aérienne : fuel est un nombre et non un texte (ancien comportement, voir TODO)" },
	{ "W01", true,  "waypoint : x, y, alt sont des nombres" },
	{ "W02", false, "waypoint : speed > 0" },
	{ "W03", false, "waypoint : ETA est un nombre >= 0" },
	{ "W04", false, "route : ETA jamais décroissante d'un waypoint au suivant" },
	{ "W05", false, "waypoint : type et action définis" },
	{ "T01", "info", "tâches d'un waypoint : numérotées 1, 2, 3... (l'original met des numéros fixes à plusieurs endroits : simple observation, non comptée)" },
	{ "T02", true,  "tâche : id défini (+ params.task.id ou params.action.id selon le type)" },
	{ "T03", true,  "tâche Option : params.name et params.value définis" },
	{ "A01", false, "ATO : chaque vol a son groupe dans la mission (par nom)" },
	{ "I01", true,  "groupId et noms de groupes / unités uniques" },
	{ "I02", false, "unitId unique (DOUBLON CONNU, a traiter plus tard : voir la memoire du projet)" },
}

-- Rapport des règles
local regle = {}
local function initRegles()
	regle = {}
	for _, r in ipairs(listeRegles) do
		regle[r[1]] = { id = r[1], grave = r[2], texte = r[3], verifie = 0, echec = 0, exemples = {} }
	end
end
local function verif(id, ok, detail)
	local r = regle[id]
	r.verifie = r.verifie + 1
	if not ok then
		r.echec = r.echec + 1
		if #r.exemples < 3 then r.exemples[#r.exemples + 1] = tostring(detail) end
	end
end

local function nombre(v) return type(v) == "number" and v == v and v ~= math.huge and v ~= -math.huge end

--------------------------------------------------------------------------------
-- Début : on surveille les variables globales pendant le FlightPlan
--------------------------------------------------------------------------------
function AtoFP.CheckStart()
	if not CHECK_ACTIF then return end
	AtoFP.phase = "debut"
	if getmetatable(_G) ~= nil then return end			-- _G a déjà une metatable : on ne touche à rien
	globalLu, globalCree = {}, {}
	setmetatable(_G, {
		__index = function(t, k)
			local nom = tostring(k)
			globalLu[nom] = (globalLu[nom] or 0) + 1
			return nil
		end,
		__newindex = function(t, k, v)
			globalCree[tostring(k)] = type(v)
			rawset(t, k, v)
		end,
	})
	sousSurveillance = true
end

--------------------------------------------------------------------------------
-- Protection contre les plantages : AtoFP.Guard(function() ... end)
-- Si le FlightPlan plante, écrit Debug\FlightPlan_Crash.txt puis relance la MEME erreur (rien ne change
-- pour le reste du programme).
--------------------------------------------------------------------------------
local function texteSimple(t, maxCle)
	-- champs simples (texte / nombre / booléen) d'une table, triés : pour décrire le vol en cours
	local out = {}
	if type(t) ~= "table" then return tostring(t) end
	for k, v in pairs(t) do
		if type(v) == "string" or type(v) == "number" or type(v) == "boolean" then
			out[#out + 1] = tostring(k) .. " = " .. tostring(v)
		end
	end
	table.sort(out)
	return table.concat(out, "\n    ")
end

local function ecritCrash(msg, trace)
	local ok = pcall(function()
		if sousSurveillance then setmetatable(_G, nil); sousSurveillance = false end
		local ici = AtoFP.here or {}
		local f = io.open(AtoFP.LogPath("FlightPlan_Crash.txt"), "w")
		if not f then return end
		f:write("FlightPlan CRASH  " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n\n")
		f:write("ERREUR : " .. tostring(msg) .. "\n\n")
		f:write("OU : phase " .. tostring(AtoFP.phase) .. "  |  camp " .. tostring(ici.side) .. "  paquet " .. tostring(ici.pack)
			.. "  role " .. tostring(ici.role) .. "  vol n° " .. tostring(ici.f) .. "  waypoint n° " .. tostring(AtoFP.wp) .. "\n")
		f:write("    groupe : " .. tostring(ici.group) .. "\n")
		f:write("    (phases : A preparation | B waypoints+taches (B:Wp... = sous-etape) | C apres waypoints | D unites | E datalink | F frequences+groupe"
			.. " | G apparition | H SAR/Intercept/recuperation | I insertion mission | J triggers+debug)\n\n")
		f:write("VOL EN COURS (champs simples) :\n    " .. texteSimple(ici.flight) .. "\n\n")
		f:write("PILE D'APPELS :\n" .. tostring(trace) .. "\n\n")
		f:write("GLOBALES LUES ALORS QU'ELLES N'EXISTENT PAS (jusqu'ici) :\n")
		local noms = {}
		for nom in pairs(globalLu) do noms[#noms + 1] = nom end
		table.sort(noms)
		for _, nom in ipairs(noms) do f:write("    " .. nom .. " x" .. globalLu[nom] .. (optionnel[nom] and "  (normal)" or "") .. "\n") end
		f:write("\nDERNIERES LIGNES DU TEXTE DE DEBUG (dbg) :\n")
		local txt = tostring(AtoFP.debugTxt_AtoFP or "")
		local lignes = {}
		for l in string.gmatch(txt, "[^\n]+") do lignes[#lignes + 1] = l end
		for i = math.max(1, #lignes - 30), #lignes do f:write("    " .. lignes[i] .. "\n") end
		f:close()
	end)
	AddLog("|+FPCHK| CRASH in FlightPlan, phase " .. tostring(AtoFP.phase) .. ", group " .. tostring((AtoFP.here or {}).group)
		.. ": " .. tostring(msg) .. " -> Debug/ATO_FlightPlan_LOG/FlightPlan_Crash.txt")
	return ok
end

function AtoFP.Guard(corps)
	if not CHECK_ACTIF then return corps() end
	local ok, err = xpcall(corps, function(e)
		return { msg = e, trace = (debug and debug.traceback) and debug.traceback(tostring(e), 2) or tostring(e) }
	end)
	if not ok then
		ecritCrash(err.msg, err.trace)
		error(err.msg, 0)								-- même erreur, même message
	end
end

--------------------------------------------------------------------------------
-- Fin : rapport
--------------------------------------------------------------------------------
local function faitRapport()
	initRegles()
	local rapport = {}
	local nbErreur, nbAlerte = 0, 0
	local function ligne(t) rapport[#rapport + 1] = t end
	local function erreur(t)
		nbErreur = nbErreur + 1
		ligne("ERREUR  " .. t)
		AddLog("|+FPCHK| ERROR " .. t)
	end
	local function alerte(t)
		nbAlerte = nbAlerte + 1
		ligne("ALERTE  " .. t)
	end
	local function triees(t)
		local l = {}
		for k in pairs(t) do l[#l + 1] = tostring(k) end
		table.sort(l)
		return l
	end

	-- 1. fichiers ATO_FP_xx : tout est bien rendu ?
	for _, a in ipairs(attendu) do
		if type(AtoFP[a[2]]) ~= a[1] then
			erreur("AtoFP." .. a[2] .. " devrait etre '" .. a[1] .. "' mais vaut '" .. type(AtoFP[a[2]]) .. "' (fichier ATO_FP_xx non charge ou pont oublie ?)")
		end
	end
	for _, nom in ipairs(attenduGlobal) do
		if type(rawget(_G, nom)) ~= "function" then
			erreur("la fonction globale " .. nom .. " n'existe plus")
		end
	end

	-- 2. variables globales
	local ligneGlobales = {}
	if sousSurveillance then
		setmetatable(_G, nil)							-- on enlève la surveillance
		sousSurveillance = false
		ligneGlobales[#ligneGlobales + 1] = ""
		ligneGlobales[#ligneGlobales + 1] = "--- Globales LUES alors qu'elles n'existent pas (nil), nb de lectures : un nom qui ressemble a une variable locale = oubli de pont"
		for _, nom in ipairs(triees(globalLu)) do
			if rawget(_G, nom) == nil then
				ligneGlobales[#ligneGlobales + 1] = "  " .. nom .. "  x" .. globalLu[nom] .. (optionnel[nom] and "   (normal : " .. optionnel[nom] .. ")" or "")
			end
		end
		ligneGlobales[#ligneGlobales + 1] = "--- Globales CREEES pendant le FlightPlan (une variable locale devenue globale par erreur apparait ici)"
		ligneGlobales[#ligneGlobales + 1] = "    Déjà globales dans le fichier d'origine : CommonFreq, GeWpindex, GetSidenumber, Missionfunc, TableTransportPilotNames, trig_n (ligne 6182 d'origine)"
		for _, nom in ipairs(triees(globalCree)) do ligneGlobales[#ligneGlobales + 1] = "  " .. nom .. "  (" .. globalCree[nom] .. ")" end
	else
		ligneGlobales[#ligneGlobales + 1] = "(surveillance des globales non active)"
	end

	-- 3. REGLES + signature des groupes
	local idGroupe, idUnite, nomGroupe, nomUnite = {}, {}, {}, {}
	local nbGroupe, nbAvion, nbGroupeAir = 0, 0, 0
	local signature, alea = {}, {}
	local groupeParNom = {}
	local function texteIndicatif(c)
		if type(c) == "table" then return tostring(c.name or c[1]) end
		return tostring(c)
	end
	local function idsTache(task)
		local out = {}
		if type(task) == "table" and type(task.params) == "table" and type(task.params.tasks) == "table" then
			for _, t in ipairs(task.params.tasks) do
				if type(t) == "table" then out[#out + 1] = tostring(t.id) end
			end
		end
		return table.concat(out, ",")
	end

	for sideName, side in pairs(mission.coalition or {}) do
		for _, country in pairs(side.country or {}) do
			for categorie, cat in pairs(country) do
				if type(cat) == "table" and type(cat.group) == "table" then
					for _, group in pairs(cat.group) do
						nbGroupe = nbGroupe + 1
						local air = (categorie == "plane" or categorie == "helicopter")
						local nom = tostring(group.name)
						groupeParNom[nom] = true

						-- identifiants uniques (tous les groupes de la mission)
						verif("I01", not nomGroupe[nom], "nom de groupe en double: " .. nom)
						nomGroupe[nom] = true
						if nombre(group.groupId) then
							verif("I01", idGroupe[group.groupId] == nil, "groupId " .. group.groupId .. " en double: " .. nom .. " / " .. tostring(idGroupe[group.groupId]))
							idGroupe[group.groupId] = nom
						end

						local nbUnite = 0
						local texteUnite, texteAlea = {}, {}
						for _, unit in pairs(group.units or {}) do
							nbUnite = nbUnite + 1
							local unom = tostring(unit.name)
							if type(unit.name) == "string" and unit.name ~= "" then
								verif("I01", not nomUnite[unom], "nom d'unite en double: " .. unom)
								nomUnite[unom] = true
							elseif air then
								verif("U01", false, "unite sans nom dans " .. nom)
							end
							if nombre(unit.unitId) then
								verif("I02", idUnite[unit.unitId] == nil, "unitId " .. unit.unitId .. " en double: " .. unom .. " / " .. tostring(idUnite[unit.unitId]))
								idUnite[unit.unitId] = unom
							end
							if air then
								nbAvion = nbAvion + 1
								verif("U01", nombre(unit.unitId) and type(unit.name) == "string" and type(unit.type) == "string"
									and type(unit.skill) == "string" and nombre(unit.x) and nombre(unit.y), "unite " .. unom .. " (groupe " .. nom .. ")")
								verif("U02", unit.callsign ~= nil and unit.onboard_num ~= nil, "unite " .. unom .. " callsign=" .. tostring(unit.callsign ~= nil) .. " onboard_num=" .. tostring(unit.onboard_num))
								local pl = unit.payload
								verif("U04", type(pl) == "table" and nombre(pl.fuel), "unite " .. unom .. " fuel=" .. tostring(type(pl) == "table" and pl.fuel or nil) .. " (type " .. type(type(pl) == "table" and pl.fuel or nil) .. ")")
								verif("U03", type(pl) == "table" and type(pl.pylons) == "table" and tonumber(type(pl) == "table" and pl.fuel or nil) ~= nil, "unite " .. unom .. " payload=" .. type(pl) .. " pylons=" .. type(type(pl) == "table" and pl.pylons or nil) .. " fuel=" .. tostring(type(pl) == "table" and pl.fuel or nil))
							end
							texteUnite[#texteUnite + 1] = tostring(unit.type)
							texteAlea[#texteAlea + 1] = texteIndicatif(unit.callsign) .. "/" .. tostring(unit.onboard_num)
						end

						-- groupe aérien
						if air then
							nbGroupeAir = nbGroupeAir + 1
							verif("G01", type(group.name) == "string" and nombre(group.groupId) and nombre(group.x) and nombre(group.y), "groupe " .. nom)
							verif("G02", nombre(group.frequency) and group.frequency > 0, "groupe " .. nom .. " frequency=" .. tostring(group.frequency))
							verif("G03", nombre(group.start_time) and group.task ~= nil, "groupe " .. nom .. " start_time=" .. tostring(group.start_time) .. " task=" .. tostring(group.task))
							verif("G01", nbUnite > 0, "groupe sans unite: " .. nom)
						end

						-- waypoints et tâches
						local pts = {}
						local points = group.route and group.route.points
						if air then verif("G01", type(points) == "table" and #points > 0, "groupe sans waypoint: " .. nom) end
						local etaPrec = nil
						for i, p in ipairs(points or {}) do
							if air then
								verif("W01", nombre(p.x) and nombre(p.y) and nombre(p.alt), "groupe " .. nom .. " waypoint " .. i)
								verif("W02", nombre(p.speed) and p.speed > 0, "groupe " .. nom .. " waypoint " .. i .. " speed=" .. tostring(p.speed))
								local eta = p.ETA
								verif("W03", nombre(eta) and eta >= -0.001, "groupe " .. nom .. " waypoint " .. i .. " ETA=" .. tostring(eta))
								if nombre(eta) then
									if etaPrec then verif("W04", eta >= etaPrec - 0.5, "groupe " .. nom .. " waypoint " .. i .. " ETA " .. eta .. " < " .. etaPrec) end
									etaPrec = eta
								end
								verif("W05", type(p.type) == "string" and type(p.action) == "string", "groupe " .. nom .. " waypoint " .. i)
								-- tâches du waypoint
								local liste = p.task and p.task.params and p.task.params.tasks
								if type(liste) == "table" then
									local suite = true
									local nums = {}
									for n, t in ipairs(liste) do
										nums[#nums + 1] = tostring(type(t) == "table" and t.number)
										if type(t) ~= "table" or t.number ~= n then suite = false end
										local okId = type(t) == "table" and t.id ~= nil
										if okId and t.id == "ControlledTask" then okId = type(t.params) == "table" and type(t.params.task) == "table" and t.params.task.id ~= nil end
										if okId and t.id == "WrappedAction" then okId = type(t.params) == "table" and type(t.params.action) == "table" and t.params.action.id ~= nil end
										verif("T02", okId, "groupe " .. nom .. " waypoint " .. i .. " tache " .. n .. " id=" .. tostring(type(t) == "table" and t.id))
										if okId and t.id == "WrappedAction" and t.params.action.id == "Option" then
											local pa = t.params.action.params
											verif("T03", type(pa) == "table" and pa.name ~= nil and pa.value ~= nil, "groupe " .. nom .. " waypoint " .. i .. " tache " .. n .. " (" .. tostring(t.name) .. ")")
										end
									end
									verif("T01", suite, "groupe " .. nom .. " waypoint " .. i .. " numeros: " .. table.concat(nums, ","))
								end
							end
							local t = idsTache(p.task)
							pts[#pts + 1] = tostring(p.name or p.briefing_name or "?") .. ":" .. tostring(p.type) .. "/" .. tostring(p.action)
								.. (t ~= "" and ("{" .. t .. "}") or "")
						end

						local cle = tostring(sideName) .. "|" .. categorie .. "|" .. nom
						signature[#signature + 1] = cle .. "|" .. (texteUnite[1] or "?") .. " x" .. nbUnite .. "|" .. #pts .. "wp|" .. table.concat(pts, " ")
						alea[#alea + 1] = cle .. "|" .. table.concat(texteAlea, " ")
					end
				end
			end
		end
	end
	table.sort(signature)
	table.sort(alea)

	-- ATO <-> mission : chaque vol a-t-il son groupe ?
	-- (le premier SAR sur porte-avions est remplacé par un groupe "Group_Pedro_..." : voulu par l'original, pas une erreur)
	local aPedro = false
	for nomG in pairs(groupeParNom) do if string.sub(nomG, 1, 12) == "Group_Pedro_" then aPedro = true end end
	for sideName, packs in pairs(ATO or {}) do
		for packN, pack in pairs(packs) do
			if type(pack) == "table" then
				for role, flights in pairs(pack) do
					if type(flights) == "table" then
						for fN, fl in pairs(flights) do
							if type(fl) == "table" and fl.groupName then
								local remplaceParPedro = (fl.task == "SAR") and aPedro
								if not remplaceParPedro then verif("A01", groupeParNom[tostring(fl.groupName)] == true, "vol " .. tostring(fl.groupName) .. " (" .. tostring(fl.type) .. ", " .. tostring(fl.task) .. ")") end
							end
						end
					end
				end
			end
		end
	end

	-- Ponts : tables partagées vides alors que des avions existent
	if nbAvion > 0 then
		for _, nom in ipairs({ "callSignFlight", "pack_L16_unitId", "tacan_byTarget" }) do
			if type(AtoFP[nom]) == "table" and next(AtoFP[nom]) == nil then
				alerte("AtoFP." .. nom .. " est VIDE alors qu'il y a " .. nbAvion .. " appareils (normal seulement si aucun n'en a besoin)")
			end
		end
	end

	-- Règles en échec => erreurs / alertes
	for _, r in ipairs(listeRegles) do
		local x = regle[r[1]]
		if x.echec > 0 and x.grave ~= "info" then
			local txt = x.id .. " : " .. x.texte .. " -> " .. x.echec .. " en echec sur " .. x.verifie .. " | ex: " .. table.concat(x.exemples, " ; ")
			if x.grave then erreur(txt) else alerte(txt) end
		end
	end

	-- écriture du rapport
	local f = io.open(AtoFP.LogPath("FlightPlan_Check.txt"), "w")
	if f then
		f:write("FlightPlan check  " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n")
		f:write("VERDICT: " .. (nbErreur == 0 and "OK" or ("ECHEC (" .. nbErreur .. " erreur(s))")) .. "   alertes: " .. nbAlerte .. "\n")
		f:write("Groupes: " .. nbGroupe .. " (aeriens: " .. nbGroupeAir .. ")   Appareils: " .. nbAvion .. "\n\n")
		f:write("=== REGLES (verifies / en echec) ===\n")
		for _, r in ipairs(listeRegles) do
			local x = regle[r[1]]
			f:write(string.format("  %-4s %-3s %5d / %-4d  %s\n", x.id, (x.echec == 0) and "OK" or (x.grave == "info" and "i" or (x.grave and "ERR" or "!")), x.verifie, x.echec, x.texte))
			for _, e in ipairs(x.exemples) do f:write("            ex: " .. e .. "\n") end
		end
		f:write("\n=== DETAIL ===\n")
		for _, l in ipairs(rapport) do f:write(l .. "\n") end
		for _, l in ipairs(ligneGlobales) do f:write(l .. "\n") end
		f:write("\n=== SIGNATURE (comparable avant / apres, hors aleatoire) ===\n")
		for _, l in ipairs(signature) do f:write(l .. "\n") end
		f:write("\n=== PARTIE ALEATOIRE (indicatif/numero de fuselage) ===\n")
		for _, l in ipairs(alea) do f:write(l .. "\n") end
		f:close()
	end
	AddLog("|+FPCHK| FlightPlan check: " .. nbErreur .. " error(s), " .. nbAlerte .. " warning(s), " .. nbGroupe .. " groups -> Debug/ATO_FlightPlan_LOG/FlightPlan_Check.txt")
end

function AtoFP.CheckEnd()
	if not CHECK_ACTIF then return end
	local ok, err = pcall(faitRapport)
	if not ok then
		if sousSurveillance then setmetatable(_G, nil); sousSurveillance = false end
		AddLog("|+FPCHK| the check itself failed (ignored): " .. tostring(err))
	end
end
