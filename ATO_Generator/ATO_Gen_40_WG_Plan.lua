--ATO_Gen_40_WG_Plan.lua
--Sous-module de ATO_Gen_Main.lua : Wargame Airlift (ravitaillement aerien par helicopteres), 1/2 : REGLAGES WG_AIRLIFT_*, calcul des plans, choix du meilleur, menaces et contournements, reecriture de route, WG_AirliftProcess
--Charge par ATO_Gen_Main.lua (Include) a la place ou le bloc se trouvait. Code deplace tel quel, fonctions globales WG_*
-------------------------------------------------------------------------------------------------------
if not versionDCE then versionDCE = {} end
versionDCE["ATO_Gen_40_WG_Plan.lua"] = "1.21.137"
-------------------------------------------------------------------------------------------------------

if Debug.debug then
	print("START ATO_Gen_40_WG_Plan.lua "..versionDCE["ATO_Gen_40_WG_Plan.lua"].." =-=-=-=-=-=-=-=-=-=-=-=-=-=-=")
end

-- ============================================================================
-- WARGAME : ravitaillement aerien par helicoptere  (sous-etape 2a)
-- ============================================================================
--Pourquoi: les cibles "WG_AIRLIFT_..." ecrites par DCE_Manager (task Transport, wargameLogistic = "airlift")
--n'ont pas de base : le test natif "target.base == unit.base" les ignorait en silence.
--Ici on les traite a part : on calcule combien de rotations (N) un helico de l'escadrille peut faire
--(portee du loadout, aller-retour, marge de securite), on LOG la decision, et on rejette proprement
--si aucun N >= 1 n'est possible.
--
--SOUS-ETAPE 2a = CALCUL + LOG SEULEMENT : tant que WG_AIRLIFT_GENERATE = false, aucun vol n'est cree.
--(la creation du plan de vol complet arrive en 2b)
--
--REGLAGES (a ajuster ici, sans toucher au reste du fichier)
WG_AIRLIFT_GENERATE        = true		--false = calcul + log seulement ; true = creation des vols (2b, pas encore codee)
WG_AIRLIFT_MARGIN          = 0.25		--marge de securite sur le rayon d'action aller-retour (0.25 = on n'utilise que 75%)
WG_AIRLIFT_DETOUR          = 1.15		--coef de detour applique aux distances a vol d'oiseau (en attendant la vraie route en 2b)
WG_AIRLIFT_MAX_N           = 4			--nb maximum de rotations par vol
WG_AIRLIFT_STOP_S          = 300		--secondes perdues par rotation (chargement + depose)
WG_AIRLIFT_V_DEFAULT       = 50			--m/s, vitesse de croisiere si le loadout n'en donne pas
WG_AIRLIFT_PAYLOAD_DEFAULT = 1000		--kg, si l'helico n'est ni dans PayloadType ni donne par wargameCargoKg
WG_AIRLIFT_RESET_ATO       = false		--true = remet ATO=false sur les cibles qu'aucun helico ne peut servir ; false = ATO reste true (la note est ecrite quand meme)
WG_AIRLIFT_AUDIT           = false		--true = ecrit dans le log l'etat de chaque cible airlift et de chaque squad helico (diagnostic)
WG_AIRLIFT_NOTE            = "(no helicopter squad close enough)"
WG_AIRLIFT_NOTE_FLEET      = "(no helicopter available)"
WG_AIRLIFT_IGNORE_MINSCORE = true		--true = les vols airlift ignorent le minscore du loadout (un ravitaillement n'a pas a "meriter" un score de menace)
WG_AIRLIFT_IGNORE_SUPPORT  = true		--true = les vols airlift ne demandent pas d'escorte obligatoire (support du loadout vide)
WG_AIRLIFT_LOG             = true		--ecrit Debug/WG_Airlift.log (ecrase a chaque generation)
WG_AIRLIFT_RANDOM          = true		--true = tirage au sort entre escadrilles a egalite d'utilisation ; false = toujours la premiere dans l'ordre alphabetique (tests reproductibles)
WG_AIRLIFT_PLAYER_FIRST    = true		--true = un squad joueur qui peut servir la cible est choisi avant l'IA ; false = squads joueur exclus (ancien comportement)
WG_AIRLIFT_FORCE_PLAYER_CARGO = true	--true = un vol joueur sur une cible sans besoin recoit quand meme des charges au point Load (test ; a retirer plus tard)
WG_AIRLIFT_AVOID           = true		--true = contourne les SAM / AAA ennemis connus (table des menaces) en inserant des points "Avoid" dans la route
WG_AIRLIFT_AVOID_MARGIN    = 1500		--m, marge ajoutee au rayon de la menace pour placer le point de contournement
WG_AIRLIFT_AVOID_MAX       = 30			--nb maximum de points Avoid par vol (N rotations repetent les detours)
WG_AIRLIFT_AVOID_HIDDEN    = true		--true = tient compte aussi des menaces mobiles "hidden" (les helicos voient tout, comme pour les SAM)
WG_AIRLIFT_LOG_DIR         = "Debug/Wargame/ScriptsModPart"		--dossier des logs wargame de scriptsMod (cree automatiquement)
WG_AIRLIFT_LOG_FILE        = WG_AIRLIFT_LOG_DIR.."/WG_Airlift.log"
WG_AIRLIFT_TRACE           = false		--true = ecrit aussi les lignes TRACE_A (diagnostic de la boucle Part A)

--etat de la generation en cours (remis a zero a chaque execution du fichier)
WG_AirliftBest   = {}		--par nom de cible : meilleur plan trouve
WG_AirliftSeen   = {}		--dedoublonnage du log (cible|escadrille|loadout)
WG_AirliftPick   = {}		--par nom de cible : escadrille + loadout choisis pour la generation (false = aucun)
WG_AirliftUsed   = {}		--par nom d'escadrille : nb de vols airlift deja attribues dans cette generation (pluralite)
WG_AirliftDone   = {}		--par nom de cible : true quand un vol a deja ete cree
WG_AirliftExcluded = {}		--"cible|escadrille" : escadrille dont le draft a echoue pour cette cible (repli sur une autre)
WG_AirliftLogBuf = {}

function WG_Log(msg)
	if WG_AIRLIFT_LOG then
		WG_AirliftLogBuf[#WG_AirliftLogBuf + 1] = tostring(msg)
	end
end

--cree le dossier du log si besoin (Windows ; ne fait rien s'il existe deja)
function WG_EnsureLogDir()
	local dir = string.gsub(WG_AIRLIFT_LOG_DIR, "/", "\\")
	os.execute('if not exist "'..dir..'" mkdir "'..dir..'"')
end

--append = true : complete le fichier existant (bilan apres creation de l'ATO) au lieu de l'ecraser
function WG_FlushLog(append)
	if not WG_AIRLIFT_LOG then
		return
	end

	local mode = append and "a" or "w"

	local file = io.open(WG_AIRLIFT_LOG_FILE, mode)
	if not file and WG_EnsureLogDir then
		WG_EnsureLogDir()
		file = io.open(WG_AIRLIFT_LOG_FILE, mode)
	end

	if file then
		if not append then
			file:write("==== WG_Airlift 2b | MissionInstance: "..tostring(MissionInstance)
				.." | GeneratorPass: "..tostring(GeneratorPass)
				.." | CampTotalTimeH: "..tostring(CampTotalTimeH)
				.." | GENERATE: "..tostring(WG_AIRLIFT_GENERATE).." ====\n")
		end
		if #WG_AirliftLogBuf > 0 then
			file:write(table.concat(WG_AirliftLogBuf, "\n").."\n")
		end
		file:close()
	else
		print("WG_Airlift : impossible d'ouvrir "..tostring(WG_AIRLIFT_LOG_FILE))
	end

	WG_AirliftLogBuf = {}
end

--trace de la boucle Part A pour les helicos Transport (1 ligne par squad/etape, dedoublonne)
--ecrit dans le log WG_Airlift (lignes "TRACE_A")
function WG_AirliftTrace(unit, task, stage, txt)
	if not WG_AIRLIFT_TRACE or not WG_AIRLIFT_LOG or not WG_AIRLIFT_AUDIT then return end
	if not unit or not IsHelicopter[unit.type] then return end
	local key = "TRACE|"..tostring(unit.name).."|"..tostring(task).."|"..tostring(stage)
	if WG_AirliftSeen[key] then return end
	WG_AirliftSeen[key] = true
	WG_Log("TRACE_A squad: "..tostring(unit.name).." | "..tostring(unit.type).." | etape: "..tostring(stage).." | "..tostring(txt))
end

--trace : que contient la copie tgtList_Gen (celle que lit la boucle Part A) comparee a la targetlist vivante ?
function WG_AirliftTraceTargets(copyList, sideName, unit)
	if not WG_AIRLIFT_TRACE or not WG_AIRLIFT_LOG or not WG_AIRLIFT_AUDIT then return end
	if not unit or not IsHelicopter[unit.type] then return end
	local key = "TGTLIST|"..tostring(sideName)
	if WG_AirliftSeen[key] then return end
	WG_AirliftSeen[key] = true

	local function count(list)
		local n, nTransport, nAirlift, nAirliftATO = 0, 0, 0, 0
		local noms = ""
		for _, t in pairs(list or {}) do
			n = n + 1
			if t.task == "Transport" then nTransport = nTransport + 1 end
			if t.wargameLogistic == "airlift" then
				nAirlift = nAirlift + 1
				if t.ATO and not t.inactive then nAirliftATO = nAirliftATO + 1 end
				noms = noms.." ["..tostring(t.name).." titleName="..tostring(t.titleName).." ATO="..tostring(t.ATO).." inactive="..tostring(t.inactive).." task="..tostring(t.task).."]"
			end
		end
		return n, nTransport, nAirlift, nAirliftATO, noms
	end

	local n1, t1, a1, k1, noms1 = count(copyList and copyList[sideName])
	local n2, t2, a2, k2, noms2 = count(targetlist and targetlist[sideName])
	WG_Log("TRACE_A TGTLIST side: "..tostring(sideName)
		.." | tgtList_Gen (copie): cibles="..n1.." Transport="..t1.." airlift="..a1.." airlift_actifs_ATO="..k1..noms1
		.." | targetlist (vivante): cibles="..n2.." Transport="..t2.." airlift="..a2.." airlift_actifs_ATO="..k2)
end

--plafond de rotations donne par le Manager (limite de flotte), s'il existe
--ordre de lecture : target.air.heli.sorties (bloc air), puis target.wargameSorties
function WG_AirliftGetCap(target)

	local cap = nil

	if type(target.air) == "table" and type(target.air.heli) == "table" then
		cap = tonumber(target.air.heli.sorties)
		if cap then
			return cap, "air.heli.sorties"
		end
	end

	cap = tonumber(target.wargameSorties)
	if cap then
		return cap, "wargameSorties"
	end

	return nil, "aucun"
end

--Calcule le plan de rotations d'un helico pour une cible airlift.
--Trajet pour N rotations : base -> chargement (Dbe), puis N x (chargement -> depose) et (N-1) x (depose -> chargement)
--soit (2N-1) x Ded, puis depose -> base (Dpb).  Distance totale = Dbe + (2N-1) x Ded + Dpb.
--Budget = portee x 2 x (1 - marge).   =>   N <= ( (budget - Dbe - Dpb) / Ded + 1 ) / 2
--Retourne une table : feasible (portee ok pour au moins 1 rotation), N, limitedBy, distances, charge, etc.
--Point de depose (Drop) d'une cible airlift : x, y, rayon, source.
--DCE_Manager peut donner wargameDropX / wargameDropY (centre du largage) et wargameDropRadius (rayon).
--Champs absents : on garde le point de ravitaillement (target.x / target.y) et le rayon par defaut, comme avant.
--UN SEUL endroit pour ce choix : calcul de portee, waypoint Drop de la route, zones et vols de la mission.
function WG_AirliftDropPoint(t)
	local r = tonumber(t.wargameDropRadius)
	if not r or r <= 0 then r = WG_AIRLIFT_ZONE_RADIUS or 300 end

	local dx, dy = tonumber(t.wargameDropX), tonumber(t.wargameDropY)
	if dx and dy then
		return dx, dy, r, "wargameDrop"
	end
	return tonumber(t.x), tonumber(t.y), r, "target"
end

function WG_AirliftComputePlan(target, unit, currentLoadout, airbasePoint)

	local plan = { N = 0, nRange = 0, feasible = false, limitedBy = "none" }

	if not target.wargameLoadX or not target.wargameLoadY or not target.x or not target.y then
		plan.reason = "point de chargement ou de depose manquant"
		return plan
	end

	local range = tonumber(currentLoadout.range) or 0
	if range <= 0 then
		plan.reason = "pas de range dans le loadout"
		return plan
	end

	local loadPoint = { x = target.wargameLoadX, y = target.wargameLoadY }
	local dpx, dpy = WG_AirliftDropPoint(target)
	local dropPoint = { x = dpx or target.x, y = dpy or target.y }
	local k = WG_AIRLIFT_DETOUR

	local Dbe = GetDistance(airbasePoint, loadPoint) * k		--base -> chargement
	local Ded = GetDistance(loadPoint, dropPoint) * k			--chargement -> depose
	local Dpb = GetDistance(dropPoint, airbasePoint) * k		--depose -> base

	plan.Dbe = Dbe
	plan.Ded = Ded
	plan.Dpb = Dpb
	plan.dist1 = Dbe + Ded + Dpb								--distance totale pour 1 seule rotation
	plan.range = range

	--charge utile d'UN helico : PayloadType en priorite, puis wargameCargoKg (indicatif), puis valeur par defaut
	local payload = PayloadType and PayloadType[unit.type]
	plan.payloadSource = "PayloadType"
	if not payload or payload <= 0 then
		payload = tonumber(target.wargameCargoKg)
		plan.payloadSource = "wargameCargoKg"
	end
	if not payload or payload <= 0 then
		payload = WG_AIRLIFT_PAYLOAD_DEFAULT
		plan.payloadSource = "defaut"
	end
	plan.payload = payload

	--1) limite de portee
	local budget = range * 2 * (1 - WG_AIRLIFT_MARGIN)
	local avail = budget - Dbe - Dpb
	local DedSafe = math.max(Ded, 500)							--evite une division par ~0 quand chargement et depose sont tres proches

	local nRange = 0
	if avail > 0 then
		nRange = math.floor((avail / DedSafe + 1) / 2)
	end
	plan.budget = budget
	plan.nRange = nRange

	plan.feasible = (nRange >= 1)

	--3) limites de besoin et de flotte : ne concernent que l'IA (le joueur peut en faire plus)
	local N = nRange
	local limitedBy = "range"

	local human = unit.player or unit.client
	plan.human = human and true or false

	local need = tonumber(target.wargameNeedKg)
	plan.need = need

	local cap, capSource = WG_AirliftGetCap(target)
	plan.cap = cap
	plan.capSource = capSource

	if not human then
		if need ~= nil then
			local nNeed = math.ceil(need / payload)
			plan.nNeed = nNeed
			if nNeed < N then
				N = nNeed
				limitedBy = "need"
			end
		end

		if cap ~= nil and cap < N then
			N = cap
			limitedBy = "cap"
		end
	end

	if N > WG_AIRLIFT_MAX_N then
		N = WG_AIRLIFT_MAX_N
		limitedBy = "max"
	end

	if N < 0 then N = 0 end

	plan.N = N
	plan.limitedBy = limitedBy
	plan.totalDist = (N >= 1) and (Dbe + (2 * N - 1) * Ded + Dpb) or plan.dist1
	plan.kgPlanned = N * payload

	return plan
end

--Choisit, pour une cible airlift, une escadrille helico + un loadout, avec PLURALITE entre les escadrilles :
--on prefere les escadrilles les moins utilisees dans cette generation (cible 1 : une escadrille, cible 2 : une autre,
--puis tirage au sort quand elles ont toutes servi autant). Ni la charge ni la distance ne donnent l'exclusivite a un type.
--Compte l'utilisation dans WG_AirliftUsed (a appeler UNE fois par cible, le resultat est memorise par l'appelant).
--Retourne { unit = nom du squad, loadout = nom du loadout, plan = plan } ou nil
function WG_AirliftPickBest(sideName, target)

	local cands = {}

	for _, unit in pairs(oob_air[sideName] or {}) do

		local isHeli = IsHelicopter and IsHelicopter[unit.type]
		local base = db_airbases[unit.base]
		local av = AcftAvail and AcftAvail[unit.name]
		local list = LoadoutsList and LoadoutsList[unit.type] and LoadoutsList[unit.type]["Transport"]
		local used = WG_AirliftUsed[unit.name] or 0
		local human = (unit.player or unit.client) and true or false
		local excluded = WG_AirliftExcluded[tostring(target.name).."|"..tostring(unit.name)]
		local humainOK = human or not HumainOnlyUnit(unit)		--squad ou base/FARP humainOnly : jamais pour l'IA
		if HO_TRACE and HumainOnlyUnit(unit) then
			HoLog("  AIRLIFT_CAND target="..tostring(target.name).." squad="..tostring(unit.name).." humain="..tostring(human).." humainOK="..tostring(humainOK).." PLAYER_FIRST="..tostring(WG_AIRLIFT_PLAYER_FIRST).." deja_utilise="..tostring(used).." excluded="..tostring(excluded))
		end

		if isHeli and not unit.inactive and (WG_AIRLIFT_PLAYER_FIRST or not human)
			and humainOK
			and not excluded
			and base and base.x and base.y and base.inactive ~= true
			and unit.tasks and unit.tasks["Transport"] and list
			and not (av and (av.available or 0) - used <= 0) then

			for lname, l in pairs(list) do
				if type(l) == "table" and WG_CountryOk(l, unit.country) and WG_AttrOk(target, l) then

					local plan = WG_AirliftComputePlan(target, unit, l, { x = base.x, y = base.y })

					if plan.N >= 1 then
						table.insert(cands, { unit = unit.name, unitType = unit.type, unitBase = unit.base, loadout = lname, loadoutName = l.loadoutName, loadoutName2 = l.name, plan = plan, used = used, human = human })
					end
				end
			end
		end
	end

	if #cands == 0 then return nil end

	--ordre stable (pour que WG_AIRLIFT_RANDOM = false donne toujours le meme resultat)
	table.sort(cands, function(a, b)
		if a.unit ~= b.unit then return a.unit < b.unit end
		return tostring(a.loadout) < tostring(b.loadout)
	end)

	--escadrille joueur prioritaire : si l'une peut servir la cible, l'IA ne la prend pas (le joueur doit avoir un vol jouable)
	--(un vol joueur non choisi au briefing reste un vol IA de la meme escadrille, comportement DCE habituel)
	local nbCandAvant = #cands		--trace humainOnly : nb de candidats avant le filtre joueur

	if WG_AIRLIFT_PLAYER_FIRST then
		local humans = {}
		for _, c in ipairs(cands) do
			if c.human then table.insert(humans, c) end
		end
		if #humans > 0 then cands = humans end
	end

	--on ne garde que les escadrilles les moins utilisees
	local minUsed = cands[1].used
	for _, c in ipairs(cands) do
		if c.used < minUsed then minUsed = c.used end
	end
	local pool = {}
	for _, c in ipairs(cands) do
		if c.used == minUsed then table.insert(pool, c) end
	end

	local chosen = pool[1]
	if WG_AIRLIFT_RANDOM and #pool > 1 then
		chosen = pool[math.random(1, #pool)]
	end

	--log : tous les candidats, pour voir pourquoi celui-ci
	local txt = {}
	for _, c in ipairs(cands) do
		table.insert(txt, c.unit.."/"..tostring(c.loadout).." (deja utilisee: "..c.used.." | N="..c.plan.N.." | kg="..math.floor(c.plan.kgPlanned).." | dist="..math.floor(c.plan.totalDist)..(c.human and " | joueur" or "")..")")
	end
	WG_Log("AIRLIFT_CANDIDATS target: "..tostring(target.name).." | "..table.concat(txt, " ; ").." | pool="..#pool.." random="..tostring(WG_AIRLIFT_RANDOM))

	WG_AirliftUsed[chosen.unit] = (WG_AirliftUsed[chosen.unit] or 0) + 1

	if HO_TRACE then
		HoLog("  AIRLIFT_PICK target="..tostring(target.name).." candidats_avant_filtre_joueur="..tostring(nbCandAvant).." apres="..tostring(#cands).." -> retenu="..tostring(chosen.unit).." humain="..tostring(chosen.human).." humainOnly="..tostring(HumainOnlyUnit(HoUnit(chosen.unit))).." N_rotations="..tostring(chosen.plan.N))
	end

	return chosen
end

--Menaces sol (SAM / AAA / zones d'evitement) de l'ENNEMI pour un vol de la coalition sideName, a l'altitude alt.
--Source : table groundthreats de ATO_ThreatEvaluation (groundthreats.red = menaces pour le camp blue, et inversement).
--Le rayon utilise est borne par l'horizon radar (un helico a basse altitude n'est pas vu a 90 km) :
--horizon (m) = 4120 x ( racine(hauteur capteur) + racine(altitude du vol) ).
function WG_AirliftThreats(sideName, alt)

	local list = {}
	local enemy = (sideName == "blue") and "red" or "blue"

	local src = nil
	if type(groundthreats) == "table" and type(groundthreats[enemy]) == "table" then
		src = groundthreats[enemy]
	elseif type(GroundthreatsAll) == "table" and type(GroundthreatsAll[enemy]) == "table" then
		src = GroundthreatsAll[enemy]
	end

	if not src then
		return list, false
	end

	for _, t in ipairs(src) do
		if type(t) == "table" and tonumber(t.x) and tonumber(t.y) and tonumber(t.range) and t.range > 0
			and (WG_AIRLIFT_AVOID_HIDDEN or not t.hidden)
			and alt >= (tonumber(t.min_alt) or 0) and alt <= (tonumber(t.max_alt) or 100000) then

			local horizon = 4120 * (math.sqrt(math.max(tonumber(t.elevation) or 5, 1)) + math.sqrt(math.max(alt, 1)))
			local effRange = math.min(t.range, horizon)

			table.insert(list, { x = t.x, y = t.y, range = effRange, type = t.type, class = t.class, name = t.name })
		end
	end

	return list, true
end

--distance du point p au segment ab, et point le plus proche du segment
function WG_AirliftPointSegment(p, a, b)

	local dx, dy = b.x - a.x, b.y - a.y
	local len2 = dx * dx + dy * dy
	local t = 0

	if len2 > 0 then
		t = ((p.x - a.x) * dx + (p.y - a.y) * dy) / len2
		if t < 0 then t = 0 elseif t > 1 then t = 1 end
	end

	local cx, cy = a.x + t * dx, a.y + t * dy
	local ex, ey = p.x - cx, p.y - cy

	return math.sqrt(ex * ex + ey * ey), cx, cy
end

--Contourne les menaces sur un trajet a -> b. Retourne la liste des points a inserer entre a et b (peut etre vide).
--Methode : on cherche la menace la plus penetree par le segment, on place un point sur un cercle un peu plus grand
--(range + marge), du cote ou passe deja le segment, puis on recommence sur les deux nouveaux segments (profondeur limitee).
--Si a ou b est DANS le cercle d'une menace, on ne peut pas l'eviter : cette menace est ignoree pour ce segment.
function WG_AirliftAvoidLeg(a, b, threats, alt, info, depth)

	local out = {}

	if depth > 4 or info.inserted >= WG_AIRLIFT_AVOID_MAX then
		return out
	end

	local worst, worstPen, wcx, wcy = nil, nil, nil, nil

	for _, t in ipairs(threats) do
		local da = GetDistance(a, t)
		local db = GetDistance(b, t)

		if da > t.range and db > t.range then
			local d, cx, cy = WG_AirliftPointSegment(t, a, b)
			if d < t.range then
				local pen = d / t.range
				if not worstPen or pen < worstPen then
					worst, worstPen, wcx, wcy = t, pen, cx, cy
				end
			end
		end
	end

	if not worst then
		return out
	end

	local R = worst.range + WG_AIRLIFT_AVOID_MARGIN
	local vx, vy = wcx - worst.x, wcy - worst.y
	local vl = math.sqrt(vx * vx + vy * vy)

	if vl < 1 then
		--le segment passe pile par le centre : on part sur le cote (perpendiculaire au segment)
		vx, vy = -(b.y - a.y), (b.x - a.x)
		vl = math.sqrt(vx * vx + vy * vy)
		if vl < 1 then return out end
	end

	local w = { x = worst.x + vx / vl * R, y = worst.y + vy / vl * R, id = "Avoid", alt = alt }
	info.inserted = info.inserted + 1
	info.names[#info.names + 1] = tostring(worst.type or worst.class)

	local left = WG_AirliftAvoidLeg(a, w, threats, alt, info, depth + 1)
	local right = WG_AirliftAvoidLeg(w, b, threats, alt, info, depth + 1)

	for _, p in ipairs(left) do out[#out + 1] = p end
	out[#out + 1] = w
	for _, p in ipairs(right) do out[#out + 1] = p end

	return out
end

--Applique l'evitement a toute une suite de points (le premier est conserve tel quel). Retourne la nouvelle suite + infos.
function WG_AirliftAvoidRoute(pts, sideName, alt)

	local info = { inserted = 0, names = {}, nThreats = 0, inside = {}, hasTable = false }

	if not WG_AIRLIFT_AVOID or #pts < 2 then
		return pts, info
	end

	local threats, hasTable = WG_AirliftThreats(sideName, alt)
	info.hasTable = hasTable
	info.nThreats = #threats

	if #threats == 0 then
		return pts, info
	end

	--points de la route deja DANS une menace (impossible a eviter : on le signale seulement)
	for i = 1, #pts do
		for _, t in ipairs(threats) do
			if GetDistance(pts[i], t) <= t.range then
				info.inside[#info.inside + 1] = tostring(pts[i].id).." dans "..tostring(t.type or t.class).." ("..tostring(t.name)..", rayon "..math.floor(t.range).." m)"
			end
		end
	end

	local newPts = { pts[1] }
	for i = 1, #pts - 1 do
		local extra = WG_AirliftAvoidLeg(pts[i], pts[i + 1], threats, alt, info, 1)
		for _, p in ipairs(extra) do newPts[#newPts + 1] = p end
		newPts[#newPts + 1] = pts[i + 1]
	end

	return newPts, info
end

--Remplace la fin de la route creee par le generateur (Assemble / Join / Split / Land sur la cible) par
--base -> chargement -> depose (x N) -> retour base.  On garde le debut (Taxi / Spawn / Departure).
--Puis (WG_AIRLIFT_AVOID) contourne les SAM / AAA ennemis connus de la table des menaces en inserant des points "Avoid".
--Retourne true si la route a ete reecrite.
function WG_AirliftRewriteRoute(entry, tgt, plan, airbasePoint, sideName)

	local route = entry.route

	if type(route) ~= "table" or #route < 2 then
		WG_Log("AIRLIFT_GEN ERREUR route du draft absente ou trop courte pour "..tostring(tgt.name))
		return false
	end

	local idsAvant = {}
	for i = 1, #route do idsAvant[#idsAvant + 1] = tostring(route[i].id) end

	--debut de route : jusqu'a Departure compris (sinon, juste le 1er point)
	local new = {}
	local iDep = nil
	for i = 1, #route do
		if route[i].id == "Departure" then iDep = i break end
	end
	if not iDep then iDep = 1 end
	for i = 1, iDep do
		new[#new + 1] = route[i]
	end

	--altitude de croisiere : celle du point qui suit Departure dans la route d'origine
	local cruise = 150
	if route[iDep + 1] and tonumber(route[iDep + 1].alt) then
		cruise = route[iDep + 1].alt
	end

	--partie "mission" : depuis Departure jusqu'a Land
	local dpx, dpy = WG_AirliftDropPoint(tgt)
	local tail = { new[#new] }
	for k = 1, plan.N do
		tail[#tail + 1] = { x = tgt.wargameLoadX, y = tgt.wargameLoadY, id = "Load", alt = cruise }
		tail[#tail + 1] = { x = dpx or tgt.x, y = dpy or tgt.y, id = "Drop", alt = cruise }
	end
	tail[#tail + 1] = { x = airbasePoint.x, y = airbasePoint.y, id = "Land", alt = airbasePoint.h or 0 }

	local function tailLength(pts)
		local l = 0
		for i = 1, #pts - 1 do l = l + GetDistance(pts[i], pts[i + 1]) end
		return l
	end

	local lenDirect = tailLength(tail)
	local tailAvoid, info = WG_AirliftAvoidRoute(tail, sideName or "blue", tonumber(cruise) or 150)

	if info.inserted > 0 then
		local lenAvoid = tailLength(tailAvoid)
		local rangeMax = (plan.range or 0) * 2
		if rangeMax > 0 and lenAvoid > rangeMax then
			WG_Log("AIRLIFT_AVOID target: "..tostring(tgt.name).." detour trop long ("..math.floor(lenAvoid).." m > "..math.floor(rangeMax).." m) : route directe conservee")
			tailAvoid = tail
		else
			WG_Log("AIRLIFT_AVOID target: "..tostring(tgt.name).." menaces prises en compte: "..info.nThreats
				.." | points Avoid ajoutes: "..info.inserted.." ("..table.concat(info.names, ", ")..")"
				.." | longueur directe="..math.floor(lenDirect).." m avec detour="..math.floor(lenAvoid).." m")
		end
	elseif not info.hasTable and WG_AIRLIFT_AVOID then
		WG_Log("AIRLIFT_AVOID target: "..tostring(tgt.name).." table des menaces absente (groundthreats) : route directe")
	else
		WG_Log("AIRLIFT_AVOID target: "..tostring(tgt.name).." aucune menace sur la route ("..info.nThreats.." menaces connues a "..tostring(cruise).." m)")
	end

	for i = 1, #info.inside do
		WG_Log("AIRLIFT_AVOID target: "..tostring(tgt.name).." ATTENTION point "..info.inside[i])
	end

	for i = 2, #tailAvoid do
		new[#new + 1] = tailAvoid[i]
	end

	--garde les champs non numeriques de la route (lenght...), puis recalcule la longueur
	for k, v in pairs(route) do
		if type(k) ~= "number" then new[k] = v end
	end

	local lenght = 0
	for i = 1, #new - 1 do
		lenght = lenght + GetDistance(new[i], new[i + 1])
	end
	new.lenght = lenght

	entry.route = new

	local idsApres = {}
	for i = 1, #new do idsApres[#idsApres + 1] = tostring(new[i].id) end

	WG_Log("AIRLIFT_ROUTE target: "..tostring(tgt.name).." avant: ["..table.concat(idsAvant, ",").."] apres: ["
		..table.concat(idsApres, ",").."] longueur="..math.floor(lenght).."m")

	return true
end

--Point d'entree appele a la place de processEligibleLoadout pour les cibles airlift du wargame.
--Helicopteres uniquement pour l'instant (les avions de transport viendront plus tard).
function WG_AirliftProcess(draftContext, sideName, task, target, target_name, unit, currentLoadout, airbasePoint, draftId, isDebugModeA3, nativeProcess, draftSortiesRef, Daytime, i_timmer01)

	if not IsHelicopter[unit.type] then
		return
	end

	local plan = WG_AirliftComputePlan(target, unit, currentLoadout, airbasePoint)

	--meilleur plan par cible (sert a decider si la cible reste ou non dans l'ATO)
	local best = WG_AirliftBest[target.name]
	if not best then
		best = { evaluated = 0, bestN = 0, feasibleAny = false }
		WG_AirliftBest[target.name] = best
	end
	best.evaluated = best.evaluated + 1
	if plan.feasible then best.feasibleAny = true end
	if plan.N > best.bestN then
		best.bestN = plan.N
		best.bestSquad = unit.name
		best.bestLoadout = currentLoadout.loadoutName or currentLoadout.name
	end

	--log (une ligne par cible / escadrille / loadout)
	local seenKey = tostring(target.name).."|"..tostring(unit.name).."|"..tostring(currentLoadout.loadoutName or currentLoadout.name)
	if not WG_AirliftSeen[seenKey] then
		WG_AirliftSeen[seenKey] = true

		local function m(v) return v and math.floor(v) or "nil" end

		WG_Log("AIRLIFT_PLAN target: "..tostring(target.name)
			.." squad: "..tostring(unit.name).." ("..tostring(unit.type)..(plan.human and ", joueur" or "")..")"
			.." base: "..tostring(unit.base)
			.." loadout: "..tostring(currentLoadout.loadoutName or currentLoadout.name)
			.." | N="..tostring(plan.N).." (limite: "..tostring(plan.limitedBy)
			..", portee="..tostring(plan.nRange)..")"
			.." | Dbe="..m(plan.Dbe).." Ded="..m(plan.Ded).." Dpb="..m(plan.Dpb)
			.." total="..m(plan.totalDist).." budget="..m(plan.budget).." range="..m(plan.range)
			.." | charge="..m(plan.payload).."kg ("..tostring(plan.payloadSource)..")"
			.." besoin="..tostring(plan.need).."kg cap="..tostring(plan.cap).." ("..tostring(plan.capSource)..")"
			..(plan.reason and (" | "..plan.reason) or ""))
	end

	if not plan.feasible then
		rejectStep( draftContext, "range", "range_too_short",
			{
				toTarget = math.floor(plan.dist1 or 0),
				range = math.floor(currentLoadout.range or 0),
				target = target.titleName,
				loadout = currentLoadout.name,
				unit = unit.name,
			},
			"BLOCK_A",
			SafeGetLine()
		)
		return
	end

	validateStep(draftContext, "range")

	if plan.N < 1 then
		--faisable mais rien a livrer (stock suffisant) ou flotte a 0 : pas d'erreur, juste pas de vol IA
		return
	end

	if not WG_AIRLIFT_GENERATE then
		return
	end

	--2b : creation du vol, une seule fois par cible, par l'escadrille choisie
	local loadoutName = currentLoadout.loadoutName or currentLoadout.name

	if WG_AirliftPick[target.name] == nil then
		WG_AirliftPick[target.name] = WG_AirliftPickBest(sideName, target) or false
		local p = WG_AirliftPick[target.name]
		if p then
			WG_Log("AIRLIFT_CHOIX target: "..tostring(target.name).." -> squad: "..p.unit.." loadout: "..tostring(p.loadout)
				.." N="..p.plan.N.." kg prevus: "..math.floor(p.plan.kgPlanned))
		else
			WG_Log("AIRLIFT_CHOIX target: "..tostring(target.name).." -> aucune escadrille (N>=1) disponible")
		end
	end

	local pick = WG_AirliftPick[target.name]

	local sameLoadout = false
	if pick then
		for _, k in ipairs({ currentLoadout.loadoutName, currentLoadout.name }) do
			if k ~= nil and (k == pick.loadout or k == pick.loadoutName or k == pick.loadoutName2) then sameLoadout = true end
		end
	end

	if not pick or pick.unit ~= unit.name or not sameLoadout then
		return
	end

	if WG_AirliftDone[target.name] then
		return
	end

	if type(nativeProcess) ~= "function" or type(draftSortiesRef) ~= "table" then
		WG_Log("AIRLIFT_GEN ERREUR target: "..tostring(target.name).." fonction native ou draftSortiesRef non transmis par le point d'appel")
		return
	end

	--copie de la cible pour le generateur : il croit a un transport "normal" (cible rattachee a la base du squad)
	--la vraie cible (targetlist) n'est pas touchee
	local tgt = DeepCopy(target)
	tgt.base = unit.base
	tgt.destination = unit.base
	tgt.wargameN = plan.N
	tgt.wargameKgPlanned = plan.kgPlanned
	tgt.wargameSquad = unit.name

	--le Manager ajoute une note "(no helicopter ...)" au titre ; comme un vol existe, on l'enleve sur la COPIE
	--que voient l'ATO et le briefing (la vraie cible de targetlist n'est pas touchee)
	if type(tgt.titleName) == "string" then
		tgt.titleName = string.gsub(tgt.titleName, "%s*%(no helicopter[^%)]*%)", "")
	end

	local nBefore = #(draftSortiesRef[sideName] or {})

	nativeProcess( draftContext, sideName, task, tgt, target_name,
		unit, currentLoadout, Daytime, airbasePoint, draftId, isDebugModeA3, i_timmer01 )

	local list = draftSortiesRef[sideName] or {}

	if #list <= nBefore then
		WG_Log("AIRLIFT_GEN ECHEC target: "..tostring(target.name).." squad: "..unit.name.." : le generateur n'a cree aucun draft (voir les rejets natifs)")

		--repli : on exclut ce squad pour cette cible, la prochaine escadrille evaluee re-choisira
		WG_AirliftExcluded[tostring(target.name).."|"..tostring(unit.name)] = true
		WG_AirliftUsed[unit.name] = math.max((WG_AirliftUsed[unit.name] or 1) - 1, 0)
		WG_AirliftPick[target.name] = nil
		WG_Log("AIRLIFT_REPLI target: "..tostring(target.name).." squad "..unit.name.." exclu, choix repris a la prochaine escadrille evaluee")
		return
	end

	for i = nBefore + 1, #list do
		WG_AirliftRewriteRoute(list[i], tgt, plan, airbasePoint, sideName)

		--un ravitaillement ne doit pas etre refuse pour un score de menace trop bas ni pour une escorte absente
		--(sinon createATO_table l'ecarte en silence : "MENACE TROP IMPORTANTE" / "any_SUPPORT")
		local lo = list[i].loadout
		if lo then
			local supTxt = ""
			if type(lo.support) == "table" then
				for k, v in pairs(lo.support) do
					if v then supTxt = supTxt..tostring(k).." " end
				end
			end

			WG_Log("AIRLIFT_LOADOUT draft: "..tostring(list[i].id).." minscore="..tostring(lo.minscore)
				.." support=["..supTxt.."] score="..tostring(list[i].score))

			if WG_AIRLIFT_IGNORE_MINSCORE then
				lo.minscore = nil
			end
			if WG_AIRLIFT_IGNORE_SUPPORT then
				lo.support = { Escort = false, SEAD = false }
			end
		end
	end

	WG_AirliftDone[target.name] = true

	if HO_TRACE then
		HoLog("  AIRLIFT_DRAFTS_CREES target="..tostring(target.name).." squad="..tostring(unit.name).." humainOnly="..tostring(HumainOnlyUnit(unit)).." drafts="..tostring(#list - nBefore).." N_rotations="..tostring(plan.N).." unit.player="..tostring(unit.player))
	end
	WG_Log("AIRLIFT_GEN OK target: "..tostring(target.name).." squad: "..unit.name.." loadout: "..tostring(loadoutName)
		.." drafts crees: "..(#list - nBefore).." N="..plan.N)
end

