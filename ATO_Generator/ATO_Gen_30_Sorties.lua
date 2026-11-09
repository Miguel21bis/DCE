--ATO_Gen_30_Sorties.lua
--Sous-module de ATO_Gen_Main.lua : construction des drafts de sortie (getMultiPlane, getMultiPlaneTask, buildDraftSorties, processEligibleLoadout)
--Charge par ATO_Gen_Main.lua (Include) a la place ou se trouvait le bloc. Texte deplace tel quel ; la ligne 'local bias' vient de ATO_Gen_Main.lua (utilisee seulement ici).
--seul changement de code : processEligibleLoadout est devenue globale (etait 'local', mais Main l'appelle). buildDraftSorties et pendingPackages restent locales a ce fichier.
--Utilise les globales de Main : multiPlaneSet, draftSorties, baseFARP, priorityMaxValue, targetAssignedFirepower, status_counter_sorties ; et celles de ATO_Gen_20_Eligibility.lua.
-------------------------------------------------------------------------------------------------------
if not versionDCE then versionDCE = {} end
versionDCE["ATO_Gen_30_Sorties.lua"] = "1.21.137"
-------------------------------------------------------------------------------------------------------

if Debug.debug then
	print("START ATO_Gen_30_Sorties.lua "..versionDCE["ATO_Gen_30_Sorties.lua"].." =-=-=-=-=-=-=-=-=-=-=-=-=-=-=")
end

local bias = 4 -- Pondération pour target.firepower : plus grand = plus proche de `min

--Retourne la config MP d'un side/type/task si elle existe
--Pourquoi: éviter les cascades de if et les accès nil dangereux
--Retourne la config MP d'un side/type/squad/task si elle existe
--Pourquoi: éviter les mélanges aléatoires entre plusieurs squads d'un même appareil
function getMultiPlaneTask(sideName, squadName, planeType, task)

	if not multiPlaneSet then
		return nil
	end

	if not multiPlaneSet[sideName] then
		return nil
	end

	if not multiPlaneSet[sideName][planeType] then
		return nil
	end

	if not multiPlaneSet[sideName][planeType][squadName] then
		return nil
	end

	if not multiPlaneSet[sideName][planeType][squadName][task] then
		return nil
	end

	return multiPlaneSet[sideName][planeType][squadName][task]
end

function getMultiPlane(sideName, squadName, planeType)

	if not multiPlaneSet then
		return nil
	end

	if not multiPlaneSet[sideName] then
		return nil
	end

	if not multiPlaneSet[sideName][planeType] then
		return nil
	end

	if not multiPlaneSet[sideName][planeType][squadName] then
		return nil
	end

	return multiPlaneSet[sideName][planeType][squadName]
end

-- --packages collaboratifs
-- --Pourquoi: permettre à plusieurs squads de cumuler leur firepower sur une même cible
local pendingPackages = {}

--Construit les draft sorties pour une combinaison valide
--Pourquoi: sortir le bloc de génération de sortie du pipeline principal et réduire fortement l'indentation
local function buildDraftSorties(
				draftContext,
				sideName,
				task,
				target,
				currentLoadout,
				flights_requested,
				multipack,
				unit,
				mpConfig,
				draftId,
				isDebugModeA3
			)

	repeat

		local idTemp = "id"..#draftSorties[sideName]+1

		if isDebugModeA3 then
			debugLog( "draftId"..draftId .." AtoG BUILD_SORTIE "
				..idTemp .." aircraft_assign: " ..tostring(draftContext.state.futureAircraftAssign)
			)
		end

		--firepower apportee par cette sortie
		--Pourquoi: cumuler plusieurs squads sur une meme cible
		local firepowerContribution = draftContext.state.futureAircraftAssign * currentLoadout.firepower

		if not pendingPackages[target.titleName] then
			pendingPackages[target.titleName] = {
				firepower = 0,
				required = target.firepower.min,
				sorties = {},
				completed = false,
			}
		end

		pendingPackages[target.titleName].firepower = pendingPackages[target.titleName].firepower + firepowerContribution

		local draftSortiesEntry = {
			name = unit.name,
			playable = draftContext.clientPlayer,
			side = draftContext.side,
			type = unit.type,
			modification = unit.modification,
			callsign = unit.callsign,
			callsignId = unit.callsignId,
			helicopter = unit.helicopter,
			number = draftContext.state.futureAircraftAssign,
			flights = flights_requested,
			country = unit.country,
			livery = unit.livery,
			sidenumber = unit.sidenumber,
			liveryModex = unit.liveryModex,
			base = unit.base,
			airdromeId = db_airbases[unit.base].airdromeId,
			parking_id = unit.parking_id,
			skill = unit.skill,
			task = task,
			tasks = unit.tasks,
			loadout = DeepCopy(currentLoadout),
			target = DeepCopy(target),
			target_name = target.titleName,
			targetPriority = DeepCopy(target.priority),
			-- priorityIni = DeepCopy(target.priority),
			route = draftContext.state.route,
			tot_from = draftContext.state.tot_from,
			tot_to = draftContext.state.tot_to,
			support = {
				["Escort"] = {},
				["SEAD"] = {},
				["Escort Jammer"] = {},
				["Flare Illumination"] = {},
				["Laser Illumination"] = {},
				["Strike"] = {},
			},
			multipack = multipack,
			threatsGround = draftContext.state.route.threats.ground_total,
			threatsAir = draftContext.state.route.threats.air_total,
			id = "DraftId"..draftId.."_id"..#draftSorties[sideName]+1,
			rejected = {},
			main_overideMP = draftContext.overideMP_A,
			remainingFirepower = draftContext.state.remainingFirepower,
			firepowerContribution = firepowerContribution,
			packageTarget = target.titleName,
			-- multiPlaneSet_B = multiPlaneSet,
			baseScore = 0,
			finalScore = 0,
		}

		draftSortiesEntry.target.titleName = target.titleName

		draftSortiesEntry.scoreAdd = 0.000011
		draftSortiesEntry.scoreCoef = 1

		if HO_TRACE and HumainOnlyUnit(unit) then
			HoLog("  DRAFT_CREE id="..tostring(draftSortiesEntry.id).." squad="..tostring(unit.name).." task="..tostring(task).." cible="..tostring(target.titleName).." nb_avions="..tostring(draftSortiesEntry.number).." playable="..tostring(draftSortiesEntry.playable).." multipack="..tostring(multipack).." main_overideMP="..tostring(draftSortiesEntry.main_overideMP).." airlift="..tostring(target.wargameLogistic))
		end

		local route_threat = draftContext.state.route.threats.ground_total
			+ draftContext.state.route.threats.air_total

		if task == "CAP" or task == "Intercept" or task == "SAR" then
			draftSortiesEntry.score = target.priority
		else
			draftSortiesEntry.score = target.priority / route_threat
		end

		if unit.player then
			-- draftSortiesEntry.score = draftSortiesEntry.score * 1.5
			draftSortiesEntry.score = draftSortiesEntry.score * 500
			draftSortiesEntry.scoreCoef = 500

			if Debug.debug then
				debugLog("draftId"..draftId.." AtoG PLAYER_SCORE_INIT "..unit.name
					.." target.priority: "..tostring(target.priority)
					.." route_threat: "..tostring(route_threat)
					.." score_apres_coef: "..tostring(draftSortiesEntry.score)
					.." scoreCoef: "..tostring(draftSortiesEntry.scoreCoef)
				)
			end
		end

		if draftContext.overideMP_A then
			
			if draftSortiesEntry.score < 100 then
				draftSortiesEntry.scoreAdd = draftSortiesEntry.score + 100
				
				draftSortiesEntry.score = draftSortiesEntry.score + 100
			end

			if not target.newPriority then
				
				local maxVal = priorityMaxValue[draftSortiesEntry.side]
				local coef = (maxVal / target.priority) + 0.1
                
                -- Si la priorite etait deja superieure ou egale au max, on s'assure que le coef soit au moins > 1
                if coef <= 1 then coef = 1.1 end
                
                -- Application du coefficient
                target.priority = target.priority * coef + 1
				target.newPriority = true
				draftSortiesEntry.targetPriority = draftSortiesEntry.targetPriority * coef + 1
                
				-- target.newPriority = true
				-- target.priority = target.priority * 6
				-- draftSortiesEntry.targetPriority = draftSortiesEntry.targetPriority * 6
			end
		end

		draftSortiesEntry.baseScore = draftSortiesEntry.score
		draftSortiesEntry.finalScore = draftSortiesEntry.score

		--Pourquoi (v1.21.138): draftContext.rejectReasons grandit a chaque rejet du squad (tous ses couples
		--cible/loadout/variante) ; le DeepCopy en entier a CHAQUE draft donnait un cout qui grossit au carre
		--(~420 Ko par draft, ~600 Mo en tout, memoire ET temps). Plus rien ne lit ce champ en dehors du debug :
		--on ne garde que le nombre total et les 10 derniers rejets, SANS copie (references partagees).
		local rejectList = draftContext.rejectReasons or {}
		local rejectRecent = {}
		for i = math.max(1, #rejectList - 9), #rejectList do
			rejectRecent[#rejectRecent + 1] = rejectList[i]
		end
		for rejectKey, rejectValue in pairs(rejectList) do
			if type(rejectKey) == "string" then
				rejectRecent[rejectKey] = rejectValue
			end
		end

		draftSortiesEntry.debugContext = {
			rejectReasons = rejectRecent,
			rejectReasonsTotal = #rejectList,
			overideMP_A = draftContext.overideMP_A,
			passPackmax = draftContext.passPackmax,
		}

		if not draftSorties[sideName] then
			draftSorties[sideName] = {}
		end

		draftSorties[sideName][#draftSorties[sideName] + 1] = draftSortiesEntry
		if MemTick then MemTick("A draft") end

		table.insert(
			pendingPackages[target.titleName].sorties,
			draftSortiesEntry.id
		)

		local packageData = pendingPackages[target.titleName]

		if packageData.firepower >= packageData.required then

			packageData.completed = true

			if isDebugModeA3 then
				debugLog(
					"draftId"..draftId
					.." A_10_E PACKAGE COMPLETE "
					..target.titleName
					.." packageData.firepower/packageData.required: "
					..math.floor(packageData.firepower)
					.."/"
					..math.floor(packageData.required)
				)
			end

		else

			if isDebugModeA3 then
				debugLog(
					"draftId"..draftId
					.." A_10_C PACKAGE PENDING "
					..target.titleName
					.." firepower: "
					..math.floor(packageData.firepower)
					.."/"
					..math.floor(packageData.required)
				)
			end
		end

		-- draftContext.generatedSortie = true
		draftContext.generatedSortie = true
		draftContext.anyMissionGenerated = true

		--annonce (console + briefing) si cette sortie a ete obtenue grace a RelaxGeneration ;
		--relaxAnnounced evite de repeter l'annonce a chaque tour de la boucle repeat ci-dessous.
		if not draftContext.relaxAnnounced then
			draftContext.relaxAnnounced = true
			AnnounceRelaxedLimits(unit.name, target.titleName, currentLoadout.name)
		end

		validateStep(draftContext, "sortie")

		if task == "AWACS" or task == "Refueling" or task == "AFAC" then
			draftContext.state.futureAircraftAssign = draftContext.state.futureAircraftAssign - 1

		elseif draftContext.overideMP_A then

			local splitSize = 4

			draftContext.state.futureAircraftAssign = draftContext.state.futureAircraftAssign - splitSize
		else
			draftContext.state.futureAircraftAssign = 0
		end

	until draftContext.state.futureAircraftAssign <= 0
end

--Traite un loadout entièrement validé jusqu'à la génération des sorties
--Pourquoi: supprimer une énorme profondeur d'indentation du pipeline principal
function processEligibleLoadout(draftContext, sideName, task, target, target_name, unit, currentLoadout, Daytime, airbasePoint, draftId, isDebugModeA3, i_timmer01 )

	validateStep(draftContext, "loadout")

	--attention, overideMP_A garde une ancienne valeur a true
	draftContext.overideMP_A = false

	if ( target.base and  ((task == "Intercept" and target.base == unit.base) or (task == "SAR" and target.base == unit.base) ) or (task == "Transport" and target.base == unit.base) or (task == "Nothing" and target.base == unit.base)
		) or (task ~= "Intercept" and task ~= "Transport" and task ~= "Nothing" and task ~= "SAR") then
		--intercept and transport missions are only assigned to units of a certain base as per targetlist	

		TrackPlayability(unit.player, "target")																							--track playabilty criterium has been met

		local mpTask_Check = getMultiPlaneTask(sideName, unit.name, unit.type, task)
		local mp_Data = getMultiPlane(sideName, unit.name, unit.type)

        local debugMulti = ""

		if mpTask_Check and mp_Data then

			if Multi.Target and Multi.Target[sideName] then
				debugMulti = debugMulti.."\n"..("AtoG passe A_AAe Multi.Target[side] "..tostring(Multi.Target[sideName]) .. " ==? target_name? " .. tostring(target_name))
				if Multi.Target[sideName] == target_name  then
					debugMulti = debugMulti.."\n"..("AtoG passe A_AAf Multi.Target[side] "..tostring(Multi.Target[sideName]) .. " ==? target_name? " .. tostring(target_name).." "..unit.type.." "..tostring(task))
					draftContext.overideMP_A = true
					if target.powerfire and target.powerfire.max then
						if target.powerfire.max < mp_Data.NbPlane then
							target.powerfire.max = mp_Data.NbPlane + 1
						end
					end
				end
			else
				debugMulti = debugMulti.."\n"..("AtoG passe A_AAg ==? target_name? " .. tostring(target_name).." "..unit.type.." "..tostring(task))

				Multi.Target = {}
				Multi.Target[sideName] = target_name
				draftContext.overideMP_A = true
			end

			draftContext.clientPlayer = true
		end

		if isDebugModeA3 then
			debugLog("draftId"..draftId.." "..debugMulti)
		end

		if isDebugModeA3 then
			debugLog("draftId"..draftId.." AtoG passe A_11 overRideMP_A? "..tostring(draftContext.overideMP_A).." Befor firepower Condition".." || "..target_name
			.." "..unit.type
			.." firepower.min? "..target.firepower.min
			.." <= aircraft_available: ".. AcftAvail[unit.name].available
			.." * firepower "..currentLoadout.firepower
			)
		end

		--squad humainOnly OU base/FARP humainOnly (voir HumainOnlyUnit) : ses vols ne doivent exister que pour un humain.
		--Multi : seul le vol demande par le joueur (draftContext.overideMP_A, pose plus haut) est autorise.
		--         Avant, le test "unit.player or unit.client" laissait passer TOUS les vols du squad
		--         des qu'un joueur l'avait choisi, donc des vols IA apparaissaient.
		--Solo  : on laisse passer le squad du joueur (il doit pouvoir choisir parmi ses vols).
		--         (pas de retrait automatique des vols IA non choisis : PruneHumainOnlyAI n'existe pas pour l'instant)
		local passHumain = true
		if HumainOnlyUnit(unit) then
			if Multi and Multi.NbGroup and Multi.NbGroup >= 1 then
				passHumain = (draftContext.overideMP_A == true)
			else
				passHumain = (unit.player or unit.client) and true or false
			end
		end

		if HO_TRACE and HumainOnlyUnit(unit) then
			HoLog("  PASS_HUMAIN squad="..tostring(unit.name).." task="..tostring(task).." cible="..tostring(target_name).." loadout="..tostring(currentLoadout.name).." Multi.NbGroup="..tostring(Multi and Multi.NbGroup).." overideMP_A="..tostring(draftContext.overideMP_A).." unit.player="..tostring(unit.player).." unit.client="..tostring(unit.client).." -> passHumain="..tostring(passHumain).." | "..HoAcft(unit.name))
		end

		--firepower individuelle apportée par ce squad
		--Pourquoi: permettre les packages collaboratifs
		local squadFirepower = AcftAvail[unit.name].available * currentLoadout.firepower

		local firepowerValid = false

		--cas normal: le squad peut satisfaire seul la cible
		if passHumain and squadFirepower >= target.firepower.min then
			firepowerValid = true
		end

		--cas MP joueur
		if draftContext.overideMP_A then
			firepowerValid = true
		end

		--package collaboratif
		--Pourquoi: autoriser les squads insuffisants seuls mais utiles collectivement
		if not firepowerValid and target.firepower.packmax and target.firepower.packmax > 1 then

			firepowerValid = true
			draftContext.passPackmax = true

		end

		--mode degrade : a partir de la 5e tentative infructueuse, on ignore ce manque de
		--firepower pour le draft du joueur plutot que de ne rien lui proposer (cf RelaxGeneration,
		--ATO_Gen_00_Debug.lua). L'ecart exact est garde pour etre annonce plus tard.
		if not firepowerValid and RelaxGeneration and isPlayerRelatedDraft(draftContext) then

			recordRelaxedLimit(unit.name, "firepower", {
				required = target.firepower.min,
				availableAircraft = AcftAvail[unit.name].available,
				loadoutFirepower = currentLoadout.firepower,
				maxPossible = AcftAvail[unit.name].available * currentLoadout.firepower,
				target = target.titleName,
				loadout = currentLoadout.name,
			})

			firepowerValid = true
		end

		if isDebugModeA3 then
			debugLog("draftId"..draftId.." AtoG passe A_11b passPackmax? "..tostring(draftContext.passPackmax).." ||target.firepower.packmax: "..tostring(target.firepower.packmax).." passHumain? "..tostring(passHumain).." firepowerValid? "..tostring(firepowerValid))
		end

		repeat

			if not passHumain then
				rejectStep( draftContext, "passHumain", "HumainRequired", nil)
				break
			end

			if not firepowerValid then
				rejectStep( draftContext, "firepower", "firepower_insufficient",
					{
						required = target.firepower.min,
						availableAircraft = AcftAvail[unit.name].available,
						loadoutFirepower = currentLoadout.firepower,
						maxPossible = AcftAvail[unit.name].available * currentLoadout.firepower,
						target = target.titleName,
						loadout = currentLoadout.name,
					},
					"BLOCK_A", 
					SafeGetLine()
				)
				
				break
			end

			if isDebugModeA3 then debugLog("draftId"..draftId.." AtoG passe A_13  Befor weather Condition  || "..target_name) end

			TrackPlayability(unit.player, "target_firepower")																			--track playabilty criterium has been met

			local weatherEligible = checkWeatherEligibility(draftContext, currentLoadout, isDebugModeA3)

			if not weatherEligible then
				rejectStep( draftContext, "weather", "weather_not_eligible",
					{
						target = target.titleName,
						loadout = currentLoadout.name,
						daytime = Daytime,

					},
					"BLOCK_A", 
					SafeGetLine()
				)
			end

			--selectionne une escadrille CSAR la plus proche de l'EjectedPilot
			local proxiCSAR = true
			if task == "CSAR" and target.selectedUnitSAR and target.selectedUnitSAR ~= "" then
				if unit.name ~= target.selectedUnitSAR then
					proxiCSAR = false
				end
			end

			if draftContext.overideMP_A or unit.player or unit.client then
				proxiCSAR = true
			end

			if isDebugModeA3 then
				debugLog("draftId"..draftId.." AtoG passe A_13__C ".." proxiCSAR "..tostring(proxiCSAR).." ".. tostring(unit.name).." selectedUnitSAR: "..tostring(target.selectedUnitSAR).." target.name: "..tostring(target.name))
				debugLog("draftId"..draftId.." AtoG passe A_13__D weatherEligible? "..tostring(weatherEligible).." overideMP_A? "..tostring(draftContext.overideMP_A))
			end

			if (weatherEligible and proxiCSAR) then																				--continue of this loadout is eligible for weather

				if isDebugModeA3 then
					debugLog("draftId"..draftId.." AtoG passe A_14 ".." After weatherEligible Condition "..target_name)
				end

				validateStep(draftContext, "weather")

				TrackPlayability(unit.player, "weather")															--track playabilty criterium has been met

				-- --get airbase position
				-- local airbasePoint = {																				--get the x-y coordinates of the airbase where the unit is located
				-- 	x = db_airbases[unit.base].x,
				-- 	y = db_airbases[unit.base].y,
				-- 	h = db_airbases[unit.base].elevation,
				-- 	BaseAirStart = db_airbases[unit.base].BaseAirStart,
				-- 	-- name = db_airbases[unit.base].base,
				-- 	name = unit.base,
				-- }

				local multipack = 1
				if target.firepower.packmax  then	--and unit_loadouts[l].MaxAttackOffset								--target has a requirement for multiple packages and loadout is multipack capable (defined maximum attack offset)
					multipack = target.firepower.packmax															--create draft sorties for this target for the requested amount of packages
				end

				if isDebugModeA3 then
					debugLog("draftId"..draftId.." AtoG passe A_15 multipack "..tostring(multipack).." FOR multipack Boucle "..target_name)
				end

				--determine route variants depending on Daytime
				-- local variant
				if Daytime == "day" then
					draftContext.state.variant = 1
				elseif Daytime == "night" then
					draftContext.state.variant = 2
				elseif Daytime == "night-day" then
					draftContext.state.variant = 3
				elseif Daytime == "day-night" then
					draftContext.state.variant = 4
				end

				if isDebugModeA3 then
					debugLog("draftId"..draftId.." AtoG passe A_16 "..tostring(draftContext.state.varian).." "..tostring(Daytime).." Befor variant Condition "..target_name)
				end

				draftContext.state.viaFARP = nil

				--create draft sortie for this target, loadout and route variant
				while draftContext.state.variant > 0 do
					if draftContext.state.variant ~= 1 then
						draftId = draftId + 1
					end
					if isDebugModeA3 then
						debugLog("draftId"..draftId.." AtoG passe A_18 ".." After variant Condition "..target_name)
					end

					local tempDebug = ""

					i_timmer01 = i_timmer01 +1
					if i_timmer01 >= 10  then io.write(".") i_timmer01 = 0 end
					--determine route
					status_counter_sorties = status_counter_sorties + 1													--status report

					draftContext.state.route = {}

					if task == "Intercept" then																			--intercept task only get a stub route
						draftContext.state.route = {
							[1] = {
								['y'] = airbasePoint.y,
								['x'] = airbasePoint.x,
								['alt'] = 0,
								['id'] = 'Intercept',
							},
							threats = {
								SEAD_offset = 0,
								ground_total = 0.5,
								air_total = 0.5
							},
							['lenght'] = target.radius * 2,																--interception task radius *2 because below it is compared with range *2
						}
					elseif task == "SAR" then																			--intercept task only get a stub route
						draftContext.state.route = {
							[1] = {
								['y'] = airbasePoint.y,
								['x'] = airbasePoint.x,
								['alt'] = 0,
								['id'] = 'SAR',
							},
							threats = {
								SEAD_offset = 0,
								ground_total = 0.5,
								air_total = 0.5
							},
							['lenght'] = target.radius * 2,																--interception task radius *2 because below it is compared with range *2
						}
					else																								--all other tasks than intercept
						local toTarget = 9999999
						if not airbasePoint.x then print("AtoG No Airbase position "..tostring(unit.base)) os.execute 'pause' end
						if not target.x then
							-- print("AtoG No target position "..tostring(target_name))
						else
							toTarget = GetDistance(airbasePoint, target)												--direct distance to target

							if IsHelicopter[unit.type] and toTarget > currentLoadout.range then
								for baseN, FARP in pairs(baseFARP[sideName]) do
									local toFARP = GetDistance(airbasePoint, FARP)

									if toFARP < (currentLoadout.range * 2) then

										local farpToTarget = GetDistance(FARP, target)

										if farpToTarget <= currentLoadout.range and farpToTarget < toTarget then
											toTarget = farpToTarget
											draftContext.state.viaFARP = FARP
										end
									end
								end
							end
						end

						--augmente le rayon d'action pour les helico client (ils peuvent se ravitailler sur des FARP occasionel)
						if draftContext.overideMP_A and IsHelicopter[unit.type] then
							currentLoadout.range = currentLoadout.range *2
						end

						if isDebugModeA3 then
							debugLog("draftId"..draftId.." AtoG passe A_25 "..tostring(toTarget).." || LoadoutUnitRange: "..tostring(currentLoadout.range).." "..tostring(currentLoadout.name)
							.."\n".."______________toTarget "..tostring(toTarget).." <=? "..tostring(currentLoadout.range)
							)
						end

						tempDebug = "\n"..("AtoG passe A_26                    AtoG toTarget "..tostring(toTarget).." <=?? currentLoadout.range: "..tostring(currentLoadout.range) )

						local rangeOK = toTarget <= currentLoadout.range

						--mode degrade : a partir de la 5e tentative infructueuse, on ignore le
						--depassement de portee pour le draft du joueur plutot que de ne rien
						--lui proposer (cf RelaxGeneration, ATO_Gen_00_Debug.lua).
						if not rangeOK and RelaxGeneration and isPlayerRelatedDraft(draftContext) then

							recordRelaxedLimit(unit.name, "range", {
								toTarget = math.floor(toTarget),
								range = math.floor(currentLoadout.range),
								target = target.titleName,
								loadout = currentLoadout.name,
							})

							rangeOK = true
						end

						if rangeOK then		--basic feasibility check of range before performance intensive route calculations are done

							validateStep(draftContext, "range")

							tempDebug = tempDebug.."\n"..("                    AtoG variant" )
							if draftContext.state.variant == 1 or draftContext.state.variant == 4 then
								tempDebug = tempDebug.."\n"..("AtoG passe  A_27a day")
															-- GetRoute(basePoint, target, profile,		sideName,	task, time,	multipackn,	multipackmax, unit,	viaFARP)
								draftContext.state.route = GetRoute(airbasePoint, target, currentLoadout, sideName, task, "day", math.random(1,multipack), multipack,    unit, draftContext.state.viaFARP)	or {}

							elseif draftContext.state.variant == 2 or draftContext.state.variant == 3 then
								tempDebug = tempDebug.."\n"..("AtoG passe  A_27b night")
								draftContext.state.route = GetRoute(airbasePoint, target, currentLoadout, sideName, task, "night", math.random(1,multipack), multipack,    unit, draftContext.state.viaFARP)	or {}
							end

							if draftContext.state.route then
								validateStep(draftContext.state.route, "route")
							else
								if not draftContext.state.route or not draftContext.state.route.lenght then
										rejectStep( draftContext, "route", "route_not_found",
											{
												target = target.titleName,
												loadout = currentLoadout.name,
												variant = draftContext.state.variant,
											},
											"BLOCK_A", 
											SafeGetLine()
										)
								end
							end

						else
							rejectStep( draftContext, "range", "range_too_short",
								{
									toTarget = math.floor(toTarget),
									range = math.floor(currentLoadout.range),
									target = target.titleName,
									loadout = currentLoadout.name,
									unit = unit.name,
								},
								"BLOCK_A", 
								SafeGetLine()
							)
						end

						DebugRoute = false
					end

					local altiPass = true
					if currentLoadout.hHover and target.z and target.z > currentLoadout.hHover then
						altiPass = false
					end

					if isDebugModeA3 then
						debugLog(tempDebug..draftId.."\n".."AtoG passe A_28d "
						.."\n".."______________route.lenght "..tostring(draftContext.state.route.lenght).." <=? "..tostring(currentLoadout.range * 2)
						.."\n".."______________altiPass? "..tostring(altiPass)
						.."\n".."______________altiPass? target.z "..tostring(target.z).." >? hHover "..tostring(currentLoadout.hHover))
					end

					--if sortie route lenght is within range of aircraft-loadout
					if draftContext.state.route and draftContext.state.route.lenght and draftContext.state.route.lenght <= currentLoadout.range * 2 and altiPass then
						if isDebugModeA3 then
							debugLog("draftId"..draftId.." AtoG passe A_29_A After Range Condition | firepower.max: "..tostring(target.firepower.max).." / currentLoadout.firepower "..tostring(currentLoadout.firepower))
						end

						TrackPlayability(unit.player, "target_range")												--track playabilty criterium has been met

						--firepower restante nécessaire pour ce target
						--Pourquoi: éviter l'overkill par accumulation de squads
						local assignedFirepower = targetAssignedFirepower[target_name] or 0

						local remainingFirepowerNeeded = target.firepower.max - assignedFirepower

						-- if remainingFirepowerNeeded <= 0 and not draftContext.overideMP_A then

						-- 	if isDebugModeA3 then
						-- 		debugLog(
						-- 			"draftId"..draftId .." A_29_B target already satisfied "
						-- 			..target_name .." assigned: "..assignedFirepower .." / "..target.firepower.max
						-- 		)
						-- 	end

						-- 	break
						-- end

						-- local firepowerRequest = GetWeightedRandom(target.firepower.min, target.firepower.max, bias)
						local firepowerRequest = GetWeightedRandom( target.firepower.min, remainingFirepowerNeeded, bias )
						draftContext.aircraft_requested = firepowerRequest / currentLoadout.firepower

						if task == "Transport" then
							if mp_Data and mp_Data.NbPlane
							and draftContext.aircraft_requested < mp_Data.NbPlane
							and task == "Transport"
							then
								draftContext.aircraft_requested = mp_Data.NbPlane
								if draftContext.aircraft_requested > 4 then draftContext.aircraft_requested = 4 end
							end
						elseif task == "Strike" and draftContext.aircraft_requested < 2 then
							draftContext.aircraft_requested = 2
						end

						local flights_requested
						if task == "AWACS" or task == "Refueling" or task == "AFAC" then									--multiple flights are required to continously cover a station for the duration of the mission
							if not currentLoadout.tStation then print("this variable <<tStation>> is missing  in this aircraft's "..task.." loadout "..unit.type) os.execute 'pause' end
							flights_requested = math.ceil((draftContext.state.tot_to - draftContext.state.tot_from) / currentLoadout.tStation) + 1			--how many flights are needed to keep continous coverage of station, plus 1 for on station before mission start
							draftContext.aircraft_requested = draftContext.aircraft_requested * flights_requested									--total number of requested aircraft is number of aircraft needed to statisfy firepower requirement of station * number of flights needed for continous coverage
						end
						if task == "CAP"  then									--multiple flights are required to continously cover a station for the duration of the mission
							if not currentLoadout.tStation then print("this variable <<tStation>> is missing in this aircraft's "..task.." loadout "..unit.type) os.execute 'pause' end

							local station = currentLoadout.tStation * 0.75
							flights_requested = math.ceil((draftContext.state.tot_to - draftContext.state.tot_from) / station)
							draftContext.aircraft_requested = draftContext.aircraft_requested * flights_requested									--total number of requested aircraft is number of aircraft needed to statisfy firepower requirement of station * number of flights needed for continous coverage

							if draftContext.aircraft_requested < 2  then
								draftContext.aircraft_requested = 2
							end

						end

						if task == "AWACS" or task == "Refueling" or task == "Transport" or task == "Nothing" or task == "Reconnaissance" or task == "AFAC" then
							draftContext.aircraft_requested = math.ceil(draftContext.aircraft_requested)
						-- elseif (unit.type == "S-3B" or unit.type == "F-117A" or unit.type == "B-1B" or unit.type == "B-52H" or unit.type == "Tu-22M3" or unit.type == "Tu-95MS" or unit.type == "Tu-142" or unit.type == "Tu-160" or unit.type == "MiG-25RBT")
						-- 	and task ~= "Runway Attack"	then
						-- 	aircraft_requested = math.ceil(aircraft_requested)	
						elseif (Data_divers[unit.type] and Data_divers[unit.type].flyingAlone) and task ~= "Runway Attack"	then

							draftContext.aircraft_requested = math.ceil(draftContext.aircraft_requested)
						else
							--aircraft_requested = math.ceil(aircraft_requested / 2) * 2								--round up to an even number
							draftContext.aircraft_requested = math.ceil(draftContext.aircraft_requested)
						end

						-- local aircraft_assign
						local logTmp = ""
						if draftContext.aircraft_requested > AcftAvail[unit.name].available then
							draftContext.state.futureAircraftAssign = math.floor(AcftAvail[unit.name].available)
							logTmp = logTmp .. " a "
						else
							draftContext.state.futureAircraftAssign = math.floor(draftContext.aircraft_requested)
							logTmp = logTmp .. " /b "
						end

						--garde en memoire remainingFirepower pour ajouter (ou non) un strike support
						draftContext.state.remainingFirepower = target.firepower.max - ( currentLoadout.firepower * draftContext.state.futureAircraftAssign)
						if draftContext.state.remainingFirepower < 0 then draftContext.state.remainingFirepower = 0 end

						-- local debugMulti = ""
						debugMulti = ""

						if draftContext.overideMP_A then

							debugMulti = debugMulti.."\n"..("AtoG_overideMP_A passe B "..tostring(task).." "..unit.type.." aircraft_assign:"..tostring(draftContext.state.futureAircraftAssign))

							--TODO a regarder si c'etait utile
							if draftContext.state.futureAircraftAssign > 4 and ( task == "CAP" ) then
								draftContext.state.futureAircraftAssign = 4
								logTmp = logTmp .. " /c "
							end

							--M11.z
							if mp_Data and mp_Data.NbPlane then
								if draftContext.state.futureAircraftAssign < mp_Data.NbPlane then
									draftContext.state.futureAircraftAssign = mp_Data.NbPlane
									logTmp = logTmp .. " /d "
									debugMulti = debugMulti.."\n"..("AtoG_overideMP_A passe C "..unit.type.." aircraft_assign: "..tostring(draftContext.state.futureAircraftAssign))
								end
							end

						end

						debugMulti = debugMulti.."\n"..("AtoG_overideMP_A passe D "..unit.type.." aircraft_assign: "..tostring(draftContext.state.futureAircraftAssign))

						if isDebugModeA3 then
							debugLog("draftId"..draftId.." "..debugMulti)
						end

						--self escort
						if currentLoadout.self_escort then															--if the loadout is capable of self-escort
							draftContext.state.route.threats.air_total = draftContext.state.route.threats.air_total / 2										--reduce the fighter threat by half
							if draftContext.state.route.threats.air_total < 0.5 then
								draftContext.state.route.threats.air_total = 0.5
							end
						end

						local assignedAircraft = draftContext.state.futureAircraftAssign

						buildDraftSorties(
							draftContext,
							sideName,
							task,
							target,
							currentLoadout,
							flights_requested,
							multipack,
							unit,
							mp_Data,
							draftId,
							isDebugModeA3
						)
						--mémorise la firepower déjà assignée à ce target
						--Pourquoi: empêcher les squads suivants de surcharger le target
						local generatedFirepower = currentLoadout.firepower * assignedAircraft

						--TODO ici, il ne faut mettre que les targets qui ont un packMax
						targetAssignedFirepower[target_name] = (targetAssignedFirepower[target_name] or 0) + generatedFirepower

						if isDebugModeA3 then
							debugLog(
								"draftId"..draftId .." AtoG passe A_30 = = = = = = = = = = = = >>>>>> buildDraftSorties()  "
								.." draftContext.state.futureAircraftAssign: "..draftContext.state.futureAircraftAssign
								.." logTmp : "..tostring(logTmp) 

						)
							
							
							debugLog(
								"draftId"..draftId .." AtoG passe A_30 = = = = = = = = = = = = >>>>>>  buildDraftSorties() PACKAGE COMPLETE "
								..target_name .." targetAssignedFirepower/target.firepower.max: "
								..targetAssignedFirepower[target_name] .."/" ..target.firepower.max
							)
						end

					end

					draftContext.state.variant = draftContext.state.variant - 2																			--determines if while-loop does another route variant depending on Daytime
				end

			end
		until true
	end
end
