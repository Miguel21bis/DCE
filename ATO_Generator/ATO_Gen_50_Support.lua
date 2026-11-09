--ATO_Gen_50_Support.lua
--Sous-module de ATO_Gen_Main.lua : ajout des supports (escorte, SEAD, ...) aux drafts : addSupportToDraft, et tri des loadouts de support (reglage SUPPORT_LOADOUT_PREFER_SHORT_RANGE)
--Charge par ATO_Gen_Main.lua (Include) a la place ou le bloc se trouvait. Texte deplace tel quel (le reglage est remonte en tete de fichier) ;
--seul changement : addSupportToDraft et sortSupportLoadouts sont devenues globales (etaient 'local' dans l'ancien fichier, mais Main les appelle).
--Ce fichier utilise les globales getMultiPlane, getMultiPlaneTask, multiPlaneSet, status_counter_escorts definies dans ATO_Gen_Main.lua AVANT cet Include.
-------------------------------------------------------------------------------------------------------
if not versionDCE then versionDCE = {} end
versionDCE["ATO_Gen_50_Support.lua"] = "1.21.137"
-------------------------------------------------------------------------------------------------------

if Debug.debug then
	print("START ATO_Gen_50_Support.lua "..versionDCE["ATO_Gen_50_Support.lua"].." =-=-=-=-=-=-=-=-=-=-=-=-=-=-=")
end

-- ============================================================================
-- REGLAGE : preference light / lourd cote SUPPORT (escortes, SEAD, ...)
-- ============================================================================
--Pourquoi: pour un meme squad et une meme tache, le PREMIER loadout qui passe tous les controles
--(portee, meteo, vitesse) prend la place (free_slot) et les suivants sont ignores. L'ordre de la liste
--decide donc du choix. Avant : standoff decroissant, puis ordre indefini (souvent light ou lourd au hasard).
--Apres : standoff decroissant, puis portee CROISSANTE -> le light est essaye en premier ; s'il est trop
--court pour la route d'escorte (route.lenght > range*2), il est refuse et le lourd est essaye ensuite.
--
--false = comportement identique a avant (seul le tri par standoff est applique)
--true  = a standoff egal, le loadout de plus petite portee est essaye en premier
SUPPORT_LOADOUT_PREFER_SHORT_RANGE = false

-- Ajoute effectivement un support au draft
function addSupportToDraft(
	draft,
	unitSupport,
	uSupportLoadout,
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
	wk,
	uniqueBonus
		)
	 -- multiPlaneSet_B, 

	TrackPlayability(unitSupport.player, "escort_target_range")									--track playabilty criterium has been met

	local debuGenTxt1545 = "\n"..(tostring(draft.id).." AtoG II_support() S1 pass B_17  ")

	--determine number of escorts
	local escort_num = 0
	local escort_max = 0

    -- local wk = 1

	if draft.support[sptTask]["escort_max"] ~= 999 then
		escort_max = draft.support[sptTask]["escort_max"]
	else
		escort_max = 0
	end

	if sptTask == "SEAD" then
		escort_num = draft.route.threats.SEAD_offset / uSupportLoadout.firepower 		-- uSupportLoadout.capability  capability determines amount of offset per aircraft
		-- escort_num = remain_SEAD_offset / uSupportLoadout.firepower
		escort_num = math.ceil(escort_num / 2) * 2										--round up requested escorts to even number

		if escort_num > 4 then
			escort_num = 4
		end	

		--TODO revoir ça
		-- if totalPlanePerTask[side][task] and totalPlanePerTask[side][task]/2 >= escort_num then
		-- 	draft.score = draft.score + (1 * draft.loadout.firepower) * draft.target.priority
		-- end

		debuGenTxt1545 = debuGenTxt1545.."\n"..(tostring(draft.id).." AtoG II_support() S2 pass_SEAD B "..unitSupport.type.." "..sptTask.." "..escort_num.." NbTotalSupport: "..draft.support[sptTask]["NbTotalSupport"].." draft.score: "..draft.score)
		debuGenTxt1545 = debuGenTxt1545.."\n"..("-------------------- escort_num: "..(draft.route.threats.SEAD_offset / uSupportLoadout.firepower).. "= SEAD_Offset: "..draft.route.threats.SEAD_offset.." /firepower "..uSupportLoadout.firepower
												)

	elseif sptTask == "Escort" then

		if draft.support[sptTask]["escort_max"] ~= 999 then
			escort_num = draft.support[sptTask]["escort_max"] - draft.support[sptTask]["NbTotalSupport"]	-- modification M11.x : Multiplayer	(x: EscorteTot-max)

			debuGenTxt1545 = debuGenTxt1545.."\n"..(tostring(draft.id).." AtoG II_support() S3 pass_Escort B "..unitSupport.type.." "..sptTask
						.." escort_num: "..escort_num.." = escort_max  "..draft.support[sptTask]["escort_max"].." - NbTotalSupport?: "..draft.support[sptTask]["NbTotalSupport"])

		else

			local escort_offset_level =  uSupportLoadout.firepower	--uSupportLoadout.capability *--threat level that each fighter escort can offset
			-- escort_num = (draft.route.threats.air_total - 0.5) / escort_offset_level		--number of escorts needed to offset total air threat (-0.5 because that is no air threat)
			escort_num = (remain_air_total - 0.5) / escort_offset_level

			if escort_num > draft.number * 2 then											--when more escorts 2 times escorts than escorted aircraft
				escort_num = draft.number * 2												--limit escort number to 2 times escorted aircraft
			end
			-- if escort_num > campMod.Setting_Generation.limit_escort then
			-- 	escort_num = campMod.Setting_Generation.limit_escort
			-- end

			escort_num = math.ceil(escort_num / 2) * 2										--round up requested escorts to even number

			if escort_num > escort_max then
				escort_max = escort_num
				draft.support[sptTask]["escort_max"] = escort_max
			end

			debuGenTxt1545 = debuGenTxt1545.."\r\n"..(tostring(draft.id).." AtoG II_support() S4 pass_Escort I "..unitSupport.type.." "..sptTask.." escort_num: "..escort_num)

		end

	elseif sptTask == "Escort Jammer" then
		escort_num = 1																	--escort jamming by single aircraft
	elseif sptTask == "Flare Illumination" then
		escort_num = 1																	--flare illumination by single aircraft
	elseif sptTask == "Laser Illumination" then
		escort_num = 1																	--laser illumination by single aircraft
	elseif sptTask == "Strike" and not overideMP_B then
		-- escort_num = 4
		escort_num = draft.remainingFirepower / uSupportLoadout.firepower
	elseif sptTask == "Strike"  then
		escort_num = 4
	end

	--ici 4 Mi24 redemandé
	-- mais c'est 4 de trop, 4 sont déjà pris en main strike
	if escort_num > AcftAvail[unitSupport.name].available then					--if more escorts are requested than available
		escort_num = AcftAvail[unitSupport.name].available						--reduce requested escorts to number of available escorts
		escort_num = math.floor(escort_num / 2) * 2										--round down to even number

		debuGenTxt1545 = debuGenTxt1545.."\r\n"..(tostring(draft.id).." AtoG II_support() S5 pass_Escort "..unitSupport.type.." "..sptTask.." escort_num: "..escort_num.." available: "..AcftAvail[unitSupport.name].available)

	end

	if escort_num <= 0 then
		rejectStep(draft, "aircraft_available", "no_aircraft_available", {requestedTask = sptTask}, "BLOCK_B", SafeGetLine())
	end

	debuGenTxt1545 = debuGenTxt1545.."\r\n"..(tostring(draft.id).." AtoG II_support() S6 pass_Escort "..unitSupport.type.." "..sptTask.." "..escort_num)

	local txtDebug = ""

	local mpSupportTask_Check = getMultiPlaneTask(side, unitSupport.name, unitSupport.type, sptTask)

	if mpSupportTask_Check  then

		txtDebug = txtDebug .. " passeA ".."\n"

		local mpMainTask_Check = getMultiPlaneTask(side, draft.name, draft.type, draft.task)
		local mpSupport_Data = getMultiPlane(side, unitSupport.name, unitSupport.type)

		if mpMainTask_Check then
			if mpSupport_Data then 
				mpSupport_Data.NbPlane = math.max(0, mpSupport_Data.NbPlane - draft.number)
				txtDebug = txtDebug .. "    AtoG II_support() S7 NbPlane: "..mpSupport_Data.NbPlane.." draft.task: "..tostring(draft.task).."\n"
			end
		end

		playable_II = true

		-- mpSupportTask_Check = getMultiPlaneTask(side, unitSupport.name, unitSupport.type, sptTask)

		txtDebug =  txtDebug.."    AtoG II_support() S8 mpSupportTask_Check: "
		.."mpSupport_Data "..tostring(mpSupport_Data)
		.."mpSupportTask_Check "..tostring(mpSupportTask_Check)
		.."side "..tostring(side)
		.."unitSupport.name "..tostring(unitSupport.name)
		.."unitSupport.type "..tostring(unitSupport.type)
		.."sptTask "..tostring(sptTask)
		.."\r\n"

		if mpSupport_Data and mpSupportTask_Check then
			escort_num = mpSupport_Data.InitNbPlane
			txtDebug =  txtDebug.."    AtoG II_support() S9 escort_num: "..escort_num.."\r\n"
		end

		if escort_num >= 1 then
			draft.score = draft.score * 1.2 + 1000
			draft.scoreAdd =  draft.scoreAdd + 1000
			draft.scoreCoef =  draft.scoreCoef * 1.2
			txtDebug = txtDebug.."    AtoG II_support() S10 "..draft.score.."\r\n"
		end

		txtDebug = txtDebug.."    AtoG II_support() S11 "..draft.score.."\r\n"

		txtDebug = txtDebug.."    AtoG II_support() S12 NbPlane "..multiPlaneSet[side][unitSupport.type][unitSupport.name].NbPlane.."\r\n"
		-- txtDebug = " 	AtoG II_support() S13 InitNbPlaneByTask: "..tostring(multiPlaneSet[side][unitSupport.type][unitSupport.name].InitNbPlaneByTask).." /n/r "..txtDebug

		-- Marquer l'unité comme vérifiée
		multiPlaneSet[side][unitSupport.type][unitSupport.name].checked = true

		-- Vérification si tous les éléments sont cochés
		local fullMP_Plane = true
		for typeM, tasksM in pairs(multiPlaneSet[side]) do
			if type(tasksM) == "table" then
				for taskM, value in pairs(tasksM) do
					if type(value) == "table" and not value.checked then
						fullMP_Plane = false
						break  -- Arrêter la vérification dès qu'un élément n'est pas coché
					end
				end
				if not fullMP_Plane then
					break  -- Sortir complètement si un type n'est pas entièrement vérifié
				end
			end
		end

		-- Doubler le score si tous les éléments sont cochés
		-- if fullMP_Plane and not uniqueBonus then
		if fullMP_Plane and not draft.uniqueBonusApplied then
			draft.score = draft.score + 2000				--draft.score * 2000
			draft.scoreCoef =  draft.scoreCoef + 2000		--draft.scoreCoef * 2000

			-- uniqueBonus = true
			draft.uniqueBonusApplied = true

			txtDebug =  "    AtoG II_support() S14 uniqueBonus "..draft.score.." /n/r "..txtDebug
		end

		if isDebugModeB then
			debugLog(debuGenTxt1545..draft.id.." AtoG II_support() S15 B_20 escort_num "..tostring(escort_num).." txtDebug: "..txtDebug   .." |score: "..tostring(draft.score))
		end

	end

	if Multi.NbGroup == 0 then
		playable_II = unitSupport.player
	end

	local wi = 1

	if isDebugModeB then
		debugLog(draft.id.." AtoG II_support() S16 pass B_21 Id "..tostring(draft.id).." "..unitSupport.type.." "..unitSupport.name.." escort_num "..tostring(escort_num).." "..draft.target_name.." NbTotalSupport: "..draft.support[sptTask]["NbTotalSupport"] )
	end

	TrackPlayability(unitSupport.player, "escort_target_firepower")							--track playabilty criterium has been met

	local entryEscortNum

	entryEscortNum = escort_num

	-- --TODO heuuuuuuuu, risqué ça
	-- if not draft.support[task] then
	-- 	draft.support[task] = {}
	-- end

	--add escort table to sortie															
	-- draft.support[sptTask]["NbTotalSupport"] = draft.support[sptTask]["NbTotalSupport"] + escort_num
	-- draft.support[sptTask]["escort_max"] = escort_max
	local futureNbTotalSupport = draft.support[sptTask]["NbTotalSupport"] + escort_num

	--regarde si l'enregistrement n'a pas encore eu lieu, sinon bloque avec la variable free_slot 
	--ceci doit etre vide draft.support[task][unitSupport.type]
	local free_slot = (draft.support[sptTask][unitSupport.type] == nil)

	if isDebugModeB then
		debugLog(draft.id.." AtoG II_support() S17 B_21 Id "..tostring(draft.id).." "..unitSupport.type.." "..unitSupport.name.."".." escort_num "..tostring(escort_num)
		.." "..draft.target_name.." entryEscortNum: "..tostring(entryEscortNum)
		.." free_slot: "..tostring(free_slot and " free_slot: true " or " free_slot: false ") )
	end

	if entryEscortNum >= 1 and free_slot then

		draft.support[sptTask]["NbTotalSupport"] = futureNbTotalSupport
		draft.support[sptTask]["escort_max"] = escort_max

		if isDebugModeB then
			debugLog(tostring(draft.id).." AtoG II_support() S18 pass B_9999 Add In draft.support ".." NbTotalSupport: "..draft.support[sptTask]["NbTotalSupport"])
		end

		if not draft.support[sptTask][unitSupport.type] then
			draft.support[sptTask][unitSupport.type] = {}
		end

		draft.support[sptTask][unitSupport.type] = {
			id = draft.id.."-"..wi.."-"..wk,
			name = unitSupport.name,
			playable = playable_II,								--unit.player,
			-- playable = unit.player,
			type = unitSupport.type,
			modification = unitSupport.modification,
			callsign = unitSupport.callsign,
			callsignId = unitSupport.callsignId,
			helicopter = unitSupport.helicopter,											-- modification M06 : helicopter playable
			number = entryEscortNum,
			country = unitSupport.country,
			livery = unitSupport.livery,
			sidenumber = unitSupport.sidenumber,
			liveryModex = unitSupport.liveryModex,
			base = unitSupport.base,
			airdromeId = db_airbases[unitSupport.base].airdromeId,
			parking_id = unitSupport.parking_id,
			skill = unitSupport.skill,
			task = sptTask,
			tasks = unitSupport.tasks,
			loadout = uSupportLoadout,
			route = route,
			target = DeepCopy(draft.target),
			target_name = draft.target.titleName,
			tot_from = draft.tot_from,
			tot_to = draft.tot_to,
			rejected = {},
			main_overideMP = draft.main_overideMP,
			overideMP_B = overideMP_B,
			-- priorityIni = draft.priorityIni,
			support_requirement = support_requirement,
			client = unitSupport.client,
		}

		local squadStatus = SquadGenerationStatus[unitSupport.name]
		-- print("create support AAA sortie for squad "..unitSupport.name.." with task "..sptTask.." escort_num: "..tostring(escort_num).." free_slot: "..tostring(free_slot and "true" or "false") 	)
		if squadStatus then
			squadStatus.supportGenerated = true
			-- print("create support BBB squadStatus.supportGenerated set to true for squad "..unitSupport.name)
		end

	end

	--recalculate threat level for sortie adjusted by number of escort
	-- local route_threat_OLD = draft.route.threats.ground_total + draft.route.threats.air_total
	local route_threat_OLD = draft.route.threats.ground_total + draft.route.threats.air_total
	local route_threat_recalc = 0.5
	--recalculated route threat with escort in place (0.5 == no threat)
	if sptTask == "SEAD" then
		local escort_offset = escort_num * uSupportLoadout.firepower					--* uSupportLoadout.capability--number of available SEAD to offset threats
		for k, tGround in pairs(draft.route.threats.ground) do									--iterate through route ground threats
			if tGround.offset > 0 then														--if threat can be offset by SEAD
				if escort_offset >= tGround.offset then										--some SEAD aircraft remain to offset the threat
					route_threat_recalc = escort_offset - tGround.offset							--use these SEAD aircraft to offset and ignore the therat
				else																	--no SEAD aircraft remain unassignedd
					route_threat_recalc = route_threat_recalc + tGround.level					--sum route ground threat levels
				end
			else																		--threat cannot be offset by SEAD
				route_threat_recalc = route_threat_recalc + tGround.level						--sum route ground threat levels
			end
		end

		if not draft.route.threats.ground_total_Init then
			draft.route.threats.ground_total_Init = draft.route.threats.ground_total
		end

		if route_threat_recalc < 0.5 then
			route_threat_recalc = 0.5
		end

		-- draft.route.threats.ground_total = route_threat_recalc			--recalculated total route grund threat
		draft.route.threats.ground_total = route_threat_recalc

	elseif sptTask == "Escort" then

		local escort_offset_level = uSupportLoadout.firepower		--uSupportLoadout.capability *--threat level that each fighter escort can offset
		route_threat_recalc = draft.route.threats.air_total - escort_offset_level * escort_num			--recalculated total route air threat

		if route_threat_recalc < 0.5 then
			route_threat_recalc = 0.5
		end

		draft.route.threats.air_total = route_threat_recalc

	elseif sptTask == "Escort Jammer" then
		draft.route.threats.ground_total = draft.route.threats.ground_total / 2
	end

	-- local route_threat_New = draft.route.threats.ground_total + draft.route.threats.air_total
	local route_threat_New = draft.route.threats.ground_total + draft.route.threats.air_total

	if route_threat_New ~= route_threat_OLD then

		-- local testScore = draft.priorityIni / route_threat_New
		local testScore = draft.targetPriority / route_threat_New

		local testScore_beforeCoef = testScore

		testScore = testScore * draft.scoreCoef + draft.scoreAdd

		if isDebugModeB then
			debugLog(draft.id.." AtoG SCORE_RECALC targetPriority: "..tostring(draft.targetPriority)
				.." route_threat_New: "..tostring(route_threat_New)
				.." testScore_avant_coef: "..tostring(testScore_beforeCoef)
				.." scoreCoef: "..tostring(draft.scoreCoef)
				.." scoreAdd: "..tostring(draft.scoreAdd)
				.." testScore_final: "..tostring(testScore)
				.." draft.score_avant: "..tostring(draft.score)
			)
		end

		if overideMP_B then
			if testScore > draft.score then
				draft.score = testScore
			end
		else
			draft.score = testScore
		end

	end

	--adjust sortie Time on Target
	if support_tot_from > draft.tot_from then
		draft.tot_from = support_tot_from
	end

	if support_tot_to < draft.tot_to then
		draft.tot_to = support_tot_to
	end

	--status report
	status_counter_escorts = status_counter_escorts + 1

	wi = wi + 1

	if isDebugModeB then
		debugLog(draft.id.." AtoG II_support() S19 pass B_22 draft.type: "..draft.type.." escort_num: "..tostring(escort_num)
		.." supportType: "..unitSupport.type.." Task: "..sptTask.." target_name: "..tostring(draft.target_name)  
		.." |score: "..tostring(draft.score))
	end

end

function sortSupportLoadouts(loadoutList)

	table.sort(loadoutList, function(a, b)

		--1) standoff decroissant (comme avant)
		if a.standoff ~= b.standoff then
			return a.standoff > b.standoff
		end

		--2) a standoff egal : portee croissante (light avant lourd), si le reglage est actif
		if SUPPORT_LOADOUT_PREFER_SHORT_RANGE then
			local rangeA = tonumber(a.range) or 0
			local rangeB = tonumber(b.range) or 0
			if rangeA ~= rangeB then
				return rangeA < rangeB
			end
		end

		return false
	end)
end
