--ATO_Gen_60_Package.lua
--Sous-module de ATO_Gen_Main.lua : transformation des drafts en packages de l'ATO (createATO_table : assignation des avions, des supports, des vols ; rejectDraft, validSupportIterator)
--Charge par ATO_Gen_Main.lua (Include) a la place ou le bloc se trouvait. Texte deplace tel quel ;
--seul changement : createATO_table est devenue globale (etait 'local' dans l'ancien fichier, mais Main l'appelle). rejectDraft et validSupportIterator restent locales a ce fichier.
--Ce fichier utilise les globales debuGenTxt, denom_NeDonnePasTOUT, multipackByTargetName, status_counter_ATO definies dans ATO_Gen_Main.lua AVANT cet Include, et cree la globale ATO.
-------------------------------------------------------------------------------------------------------
if not versionDCE then versionDCE = {} end
versionDCE["ATO_Gen_60_Package.lua"] = "1.21.137"
-------------------------------------------------------------------------------------------------------

if Debug.debug then
	print("START ATO_Gen_60_Package.lua "..versionDCE["ATO_Gen_60_Package.lua"].." =-=-=-=-=-=-=-=-=-=-=-=-=-=-=")
end

local function rejectDraft(draft, sujet, cause, line, reasonCode)
	local tabRejected = {}
	tabRejected["sujet"] = sujet
	tabRejected["cause"] = cause
	tabRejected["ligne"] = line --SafeGetLine()

	table.insert(draft["rejected"], tabRejected)
	if HO_TRACE and HumainOnlyUnit(HoUnit(draft.name)) then
		HoLog("  DRAFT_REJETE_C id="..tostring(draft.id).." squad="..tostring(draft.name).." task="..tostring(draft.task).." cible="..tostring(draft.target_name).." code="..tostring(reasonCode).." sujet="..tostring(sujet))
	end

	--Pourquoi: rejectDraft (ici, dans createATO_table) et rejectStep/bestReject (dans processEligibleLoadout)
	--sont deux systèmes de suivi séparés qui ne communiquaient pas entre eux : un squad pouvait traverser
	--tout le pipeline avec succès puis être rejeté ICI (menace trop importante, firepower insuffisant, etc.)
	--sans que ça remonte nulle part dans le rapport final. On les raccroche au même wagon.
	--reasonCode (optionnel) : code court exploitable par ExplainPlayerRejectionSP (ATO_Gen_00_Debug.lua)
	--pour donner un message joueur propre, plutot que le texte de debug brut "sujet".
	if draft.name and not escortRejectReasons[draft.name] then
		AddEscortRejectReason(draft.name, tostring(sujet), reasonCode, cause)
	end

end

local function validSupportIterator(arg_supportTable, arg_dispoTmp)

	local result = {}

	for supportTask, supports in pairs(arg_supportTable) do

		if type(supports) == "table" then

			for supportName, support in pairs(supports) do

				if type(support) == "table"
				and support.name
				and support.number
				and arg_dispoTmp[support.name]
				and arg_dispoTmp[support.name].unassigned ~= nil then

					result[#result + 1] = {
						supportTask = supportTask,
						supportName = supportName,
						support = support,
					}
				end
			end
		end
	end

	return result
end

--table to store the final ATO
ATO = {
	blue = {},
	red = {}
}

--assign draft sorties to ATO and build packages/flights
function createATO_table(draftPriority)
	for side, drafts in pairs(draftPriority) do
		if drafts and drafts ~= nil then
			for draftN, draft in pairs(drafts) do																					--iterate through all draft sorties beginning with the highest scored			

				if MemTick then MemTick("C draft") end
				
				local override_MP_C = false

				-- if draft.overideMP_B and draft.main_overideMP then
				if draft.overideMP_B then
					override_MP_C = true
				end

				local isDebugModeC =
					
					Debug.Generator.affiche
					and string.find(Debug.Generator.chapter, "C")
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

				if isDebugModeC then
					debugLog(draft.id.." AtoG passe C_00 "..draft.type.." "..draft.task.." "..draft.score)
				end

				--diminue le minscore en fonction du nombre de tentative de generation de mission
				--evite un blocage de generation
				if draft.loadout.minscore and MissionInstance >= 2 then
					draft.loadout.minscore = draft.loadout.minscore / ((MissionInstance )/10 +1)
				end

				--Pourquoi: si les escortes demandées sont là, en quantité demandée, on descend le minscore
				--pour autoriser la création du flight malgré une menace élevée. Reglage: ESCORT_MINSCORE_DISCOUNT (en tête de fichier).
				--Version un-seul-package : additionne la couverture sur toutes les tâches de support du draft
				--(Escort, SEAD, Escort Jammer, ...), pas seulement une.
				if draft.loadout.minscore and draft.support then

					local totalRequested = 0
					local totalAssigned = 0

					for sptTaskName, supportData in pairs(draft.support) do
						if type(supportData) == "table" and supportData["escort_max"] and supportData["escort_max"] > 0 then
							totalRequested = totalRequested + supportData["escort_max"]
							totalAssigned = totalAssigned + (supportData["NbTotalSupport"] or 0)
						end
					end

					if totalRequested > 0 then

						local escortCoverage = math.min(1, totalAssigned / totalRequested)

						draft.loadout.minscore = draft.loadout.minscore * (1 - ESCORT_MINSCORE_DISCOUNT * escortCoverage)

						if isDebugModeC then
							debugLog(draft.id.." AtoG passe C_00b escort coverage: "..tostring(totalAssigned).."/"..tostring(totalRequested)
								.." ("..tostring(math.floor(escortCoverage * 100)).."%) minscore ajusté: "..tostring(draft.loadout.minscore))
						end
					end
				end

				if draft.loadout.minscore == nil or draft.score >= draft.loadout.minscore then					--draft sortie has no minimum score requirement or minimum score requirement is satisified		

					-- if draft.multipack > 0 then												--target does not have a requirment for a specific number of packages, or still needs more packages		
					if multipackByTargetName[draft.target_name]["nbPack"] > 0 then

						if draft.target.firepower.max > 0 and draft.target.firepower.max >= draft.target.firepower.min then	--the target of this draft sortie must have a need for firepower above the minimum firepower threshold	
							local available_Main = AcftAvail[draft.name].unassigned											--shortcut for available aircraft for this draft sortie					

							--Pourquoi: available_Main ne reflétait que le pool GLOBAL du squad, jamais le cap PAR TACHE
							--(taskCap) -- résultat: un squad pouvait être accepté pour bien plus de packages "Strike"
							--que sa part réellement allouée, tant que le pool global (partagé avec CAP/Escort/...)
							--n'était pas totalement à sec. On clampe donc ici, AVANT toute décision d'accepter le
							--draft, pas seulement au moment de l'assignation réelle dans addFlight.
							if AcftAvail[draft.name].taskCap and AcftAvail[draft.name].taskCap[draft.task] ~= nil then

								local usedForTask = (AcftAvail[draft.name].taskUsed and AcftAvail[draft.name].taskUsed[draft.task]) or 0
								local capRemaining = AcftAvail[draft.name].taskCap[draft.task] - usedForTask

								if capRemaining < available_Main then
									available_Main = capRemaining
								end
							end

							local request_Main_Nb = draft.number -- copie locale de travail pour éviter de modifier le draft original et provoquer des effets de bord entre validations

							local passPackmax_C
							if draft.target.firepower and draft.target.firepower.packmax and draft.target.firepower.packmax > 1 then
								if available_Main >= draft.number then
									passPackmax_C = true
								end
							end

							--enough aircraft are available to satisfy minimum firepower requirement for target
							-- if (available * draft.loadout.firepower >= draft.target.firepower.min and draft.number * draft.loadout.firepower >= draft.target.firepower.min) or passPackmax_C then				
							local firepowerPackOK = (available_Main * draft.loadout.firepower >= draft.target.firepower.min ) or passPackmax_C

							--mode degrade : a partir de la 5e tentative infructueuse, on ignore ce manque de
							--firepower pour le draft du joueur plutot que de ne rien lui proposer (cf
							--RelaxGeneration, ATO_Gen_00_Debug.lua). available_Main > 0 : il reste au
							--moins un avion, on ne fabrique pas d'avion a partir de rien.
							if not firepowerPackOK and RelaxGeneration and isPlayerRelatedDraft(draft) and available_Main > 0 then

								recordRelaxedLimit(draft.name, "firepower", {
									required = draft.target.firepower.min,
									maxPossible = math.floor(available_Main * draft.loadout.firepower),
									target = draft.target_name,
									loadout = draft.loadout.name,
								})

								firepowerPackOK = true
							end

							if firepowerPackOK then

								--if the target has a minimum package number requirement, sufficient aircraft are available from this unit to satisfy it	
								local firepowerPackMultiOK =
									draft.target.firepower.packmin == nil
									or available_Main * draft.loadout.firepower >= (draft.target.firepower.packmin - 1) * draft.target.firepower.max + draft.target.firepower.min

								if not firepowerPackMultiOK and RelaxGeneration and isPlayerRelatedDraft(draft) and available_Main > 0 then

									recordRelaxedLimit(draft.name, "firepower", {
										required = (draft.target.firepower.packmin - 1) * draft.target.firepower.max + draft.target.firepower.min,
										maxPossible = math.floor(available_Main * draft.loadout.firepower),
										target = draft.target_name,
										loadout = draft.loadout.name,
									})

									firepowerPackMultiOK = true
								end

								if firepowerPackMultiOK then				

									local limitMP = true   --TODO a revoir, semble inutile

									local mpTask_Check = getMultiPlaneTask(side, draft.name, draft.type, draft.task)

									if isDebugModeC and mpTask_Check then
										debugLog(draft.id.." AtoG passe C_00_b  ".." "..draft.type
											.." available: "..tostring(available_Main)
											.." < NbPlane? ".. tostring(multiPlaneSet[side][draft.type][draft.name].NbPlane)
											.." main_overideMP?: "..tostring(draft.main_overideMP)
											.." overideMP_B?: "..tostring(draft.overideMP_B))
									end

									if (draft.flights == nil or draft.number <= available_Main or draft.main_overideMP or passPackmax_C) and limitMP then											--for targets with station time (multiple flights), continue only if sufficient aircraft are availabe. Additional lower scored sorties with less airctaft required will come later 

										if request_Main_Nb > available_Main and not draft.main_overideMP then

											request_Main_Nb = available_Main

											if isDebugModeC then
												debugLog(draft.id.." AtoG passe C_00_c requestedNumber "..tostring(request_Main_Nb))
											end

										end

										--check if there are enough supports available if supports are required		
										local support_available = true
										local need = {}																														--collect the total number of aircraft needed from each unit to complete the package
										need[draft.name] = request_Main_Nb
										local avail = {}																													--collect the maximal number of available aircraft from this unit (biggest number of all tasks)
										avail[draft.name] = AcftAvail[draft.name].unassigned

										--en fonction du learning des missions passé, interdit une mission si les task support ne sont pas present

										local tempInfo = " AtoG NbTotPlanePerTask CALCUL"
										local draft_availability = DeepCopy(AcftAvail)
										if camp.newTaskPerTarget then
											for tableTargetName, targetTask in pairs(camp.newTaskPerTarget) do
												if tableTargetName == draft.target_name and targetTask.tasks then

													for taskLearning, value in pairs(targetTask.tasks) do

														local nbTotPlanePerTask = 0

														for supportTask, supportPart in pairs(draft.support) do

															if supportTask == taskLearning then
																--avant d'interdire, on regarde si un squad possede la capacité du task
																local taskRequireInSide
																for squadN, squad in pairs(oob_air[side]) do
																	if not squad.inactive then
																		for task, taskValue in pairs(squad.tasks) do
																			if taskValue and task == taskLearning then
																				taskRequireInSide = true
																				break
																			end

																		end
																	end
																	if taskRequireInSide then break end
																end

																if taskRequireInSide and type(supportPart) == "table" then
																	for _plane, support in pairs(supportPart) do

																		if type(support) == "table" and draft_availability[support.name] then

																			if support.overideMP_B then
																				nbTotPlanePerTask = 9999
																			else

																				--enleve le nombre de plane du main si le meme type de plane est compté pour le support
																				tempInfo = tempInfo .."\n"..tostring(draft.name).." ==? "..tostring(support.name)
																				if draft.name == support.name then
																					draft_availability[support.name].unassigned = draft_availability[support.name].unassigned - draft.number
																					tempInfo = tempInfo .."\n AtoG NbTotPlanePerTask AA "..supportTask.." ".._plane.." "..support.name.." Need "..draft.number.." Dispo: "..draft_availability[support.name].unassigned
																				end

																				draft_availability[support.name].unassigned = draft_availability[support.name].unassigned - support.number

																				tempInfo = tempInfo .."\n AtoG NbTotPlanePerTask BB "..supportTask.." ".._plane.." "..support.name.." Need "..support.number.." Dispo: "..draft_availability[support.name].unassigned

																				if draft_availability[support.name].unassigned >= 0 then
																					nbTotPlanePerTask = nbTotPlanePerTask + support.number

																					tempInfo = tempInfo .."\nAtoG NbTotPlanePerTask CC "..supportTask.." NbTotPlanePerTask: "..nbTotPlanePerTask
																				end
																			end
																		end
																	end
																end
																if taskRequireInSide and nbTotPlanePerTask < 2 and not draft.overideMP_B then
																	support_available = false

																	tempInfo = tempInfo .."\nAtoG NbTotPlanePerTask REJETE DD "

																	local tabRejected = {}
																	tabRejected["sujet"]  = draft.id.." "..supportTask.." newTaskPerTarget  AVION TOTAL SUPPORT INSUFFISANT NbTotPlanePerTask <= 0 "
																	tabRejected["cause"] = { [1] = nbTotPlanePerTask, [2] = "newTaskPerTarget", }
																	-- tabRejected["ligne"]  = debug.getinfo(1).currentline
																	tabRejected["ligne"]  = SafeGetLine()
																	table.insert(draft["rejected"], tabRejected)
																end

															end

														end
													end
												end
											end
										end

										if isDebugModeC then
											debugLog(draft.id.." "..tempInfo)
										end

										--TODO bizarre, il s agit du nb d avion du main, pas du support
										for unitname,_ in pairs(need) do
												if need[unitname] > avail[unitname] then																						--more aircraft are needed from this unit across all package tasks than are available
												support_available = false																									--not enough support available
												local tabRejected = {}
												tabRejected["sujet"]  = draft.id.." type: "..draft.type.." AVION SUPPORT?Main? INSUFFISANT()support_available if need[unitname] > avail[unitname]"
												tabRejected["cause"] = { tostring(need[unitname]), tostring(avail[unitname]) }
												tabRejected["ligne"]  = SafeGetLine()
												table.insert(draft["rejected"], tabRejected)
											end
										end

										--[[ debut du strikeOnlyWithEscorte pur]]--

										-- ATO_G_adjustment01 escort mandatory or not
										-- regarde uniquement pour les bombardiers necessitant une escorte

										if mission_ini.strikeOnlyWithEscorte and not draft.loadout.self_escort then
											if (db_loadouts[draft.type]["Anti-ship Strike"] or db_loadouts[draft.type]["Strike"])  then
												-- local break_loop = false
												for squadN, squad in pairs(oob_air[side]) do

													if isDebugModeC then
														debugLog(draft.id.." ".." AtoG III passe SWE _01 "..draft.type.." "..squad.type)
													end

													if squad.tasks then
														if draft.main_overideMP or ((squad.tasks["Anti-ship Strike"]  or squad.tasks["Strike"] ) and squad.type == draft.type) then
															local needSupport = {}																														--collect the total number of aircraft needed from each unit to complete the package																							--number of main body aircraft 
															local availSupport = {}																													--collect the maximal number of available aircraft from this unit (biggest number of all tasks)

															if not needSupport[draft.name] then needSupport[draft.name] = 0 end
															if not availSupport[draft.name] then availSupport[draft.name] = 0 end
															
															-- needSupport[draft.name] = request_Main_Nb

															--TODO comment ça marche? ça a l'air inutile....
															availSupport[draft.name] =  AcftAvail[draft.name].unassigned

															for _p,_support in pairs(draft.support) do																							--iterate through support in draft sortie	
																if 	type(_support) == "table" then
																	for _a,support in pairs(_support) do
																		if 	type(support) == "table" then

																			if not needSupport[support.name] then needSupport[support.name] = 0 end
																			if not availSupport[support.name] then availSupport[support.name] = 0 end

																			needSupport[support.name] =  needSupport[support.name] + support.number																	--add number of support aircraft from same unit
																			availSupport[support.name] =  AcftAvail[support.name].unassigned

																		end
																	end
																end
															end

															-- --TODO encore utile ça?												
															-- for Sname,_ in pairs(needSupport) do
															-- 	if needSupport[Sname] - (needSupport[Sname] * 0.25)  > availSupport[Sname] then

															-- 		support_available = false																									--not enough support available

															-- 		local sujet = draft.id.." BOMBARDIER NECESSITANT ESCORTE()support_available if needSupport[Sname] - (needSupport[Sname] * 0.15) > availSupport[Sname]"
															-- 		local cause = { [1] =  needSupport[Sname] - (needSupport[Sname] * 0.25), [2] = availSupport[Sname], }

															-- 		rejectDraft(draft, sujet, cause, SafeGetLine())
															-- 	end
															-- end
														end
													end
												end
											end
										end

										--****************************************
										--[[ debut du strikeOnlyWithEscorte pur]]--

										-- s il n y a qu un avion d escorte, on bache la mission
										--obliger de regarder la demande total du package, par rapport aux existants

										local escortDiagnostic = {
												rejected = {},
												accepted = {},
											}

										local dispoTmp = DeepCopy(AcftAvail)

										--enleve deja l effectif du main (il peut y avoir 4 F18 strike et 2f18 sead ou escorte)
										-- dispoTmp[draft.name].unassigned = dispoTmp[draft.name].unassigned - draft.number
										dispoTmp[draft.name].unassigned = dispoTmp[draft.name].unassigned - request_Main_Nb

										for _, supportData in pairs(validSupportIterator(draft.support, dispoTmp)) do

											local supportTask = supportData.supportTask
											local supportName = supportData.supportName
											local support = supportData.support

											if support.number == nil or not support.name or not dispoTmp[support.name] or dispoTmp[support.name].unassigned == nil then
												if isDebugModeC then
													debugLog(draft.id.." AtoG bugA1 supportTask|"..supportTask.."|supportName:|"..tostring(supportName).."|"..tostring(support.name).." no unassigned "..tostring(support.number))
												end
											end

											--si c'est un task d'une demande MP, on chunte la restrition plus loin
											--TODO pourquoi le coef est plus important sur d'autre élément que lorsqu'on demande notre target?
											local MPOverride_C = false
											if multiPlaneSet[side] and multiPlaneSet[side][draft.name] then
												MPOverride_C = true
											end

											-- if passPackmax then

											-- end

											if support.support_requirement and mission_ini.strikeOnlyWithEscorte and 
											(support.number >= 2 and dispoTmp[support.name].unassigned < 2 and draft.task ~= supportTask) 
											and not MPOverride_C and not passPackmax_C
											and supportTask ~= "Escort Jammer"
											 then

												local txt_nb = nil
												if dispoTmp[support.name].unassigned <= 0 then
													txt_nb = " 0 "
												else
													txt_nb = " single "
												end

												if isDebugModeC then
													debugLog(draft.id.." AtoG passe C_00_h  we don't accept a "..txt_nb.." aircraft as escort supportTask "..supportTask.." draft.task "..tostring(draft.task))
												end

												escortDiagnostic.rejected[#escortDiagnostic.rejected + 1] =
													support.name
													.." task:"..tostring(supportTask)
													.." need:"..tostring(support.number)
													.." dispo:"..tostring(dispoTmp[support.name].unassigned)

												support_available = false																									--not enough support available

												local sujet = support.id.." type: "..support.type.." we don't accept a "..txt_nb.." aircraft as escort "..supportName
												local cause = { "support.number: ",support.number, "unassigned:" , tostring(dispoTmp[support.name].unassigned), " available: ", tostring(dispoTmp[support.name].aircraft_available), "supportName: ", tostring(supportName), " task: ", tostring(draft.task) , " supportTask: ", tostring(supportTask) }

												-- rejectDraft(draft, sujet, cause)
												rejectDraft(draft, sujet, cause, SafeGetLine())
												

											else
												escortDiagnostic.accepted[#escortDiagnostic.accepted + 1] =
													support.name
													.." task:"..tostring(supportTask)
													.." assigned:"..tostring(support.number)

												dispoTmp[support.name].unassigned = dispoTmp[support.name].unassigned - support.number
											end

										end
										

										local function validateEscortAvailability()

											if isDebugModeC then
												debugLog(draft.id.." AtoG passe C_01_a strikeOnlyWithEscorte number "..tostring(draft.number))
											end

											for supportTask,_support in pairs(draft.support) do

												if support_available and type(_support) == "table" then

													for supportUnitType, support in pairs(_support) do

														if supportUnitType ~= "escort_max_A_" and supportUnitType ~= "NbTotalSupport" and type(support) == "table" then

															if support.name and support.number > AcftAvail[support.name].unassigned then

																support_available = false

																local sujet = support.id .." type: "
																	..support.type .." (strikeOnlyWithEscorte) support.number > AcftAvail"

																local cause = {
																	[1] = support.number,
																	[2] = AcftAvail[support.name].unassigned,
																}

																rejectDraft(draft, sujet, cause, SafeGetLine())
																
																local details = {
																	aircraft_need = support.number or -1,
																	aircraft_disponible = AcftAvail[support.name].unassigned,
																}

																rejectStep(draft, "support", "support_no_aircraft", details, "BLOCK_C", SafeGetLine())
															end
														end
													end
												end
											end
										end

										local function validateMandatorySupports()

											if not support_available or not draft.loadout.support then
												return
											end

											for loadoutNeedTask, loadoutNeedTaskBool in pairs(draft.loadout.support) do

												if loadoutNeedTaskBool then

													local foundOnePlane = false

													if draft.support[loadoutNeedTask] then

														for planeSupport, support in pairs(draft.support[loadoutNeedTask]) do

															if planeSupport ~= "NbTotalSupport" and planeSupport ~= "escort_max"
															and type(support) == "table" and support.name then

																foundOnePlane = true
																break
															end
														end
													end

													if not foundOnePlane then

														support_available = false

														local sujet =
															draft.id
															.." type: any SUPPORT "
															..tostring(loadoutNeedTask)

														local cause = {
															[1] = tostring(loadoutNeedTask),
														}

														rejectDraft(draft, sujet, cause, SafeGetLine())

														local details = {
															loadoutNeedTask = loadoutNeedTask
														}

														rejectStep(draft, "support", "any_SUPPORT", details, "BLOCK_C", SafeGetLine())

														return
													end
												end
											end
										end

										local function validateSupportRemainingAircraft()

											if not support_available then
												return
											end

											for _,_support in pairs(draft.support) do

												if type(_support) == "table" then

													for _,support in pairs(_support) do

														if type(support) == "table" then

															if AcftAvail[support.name].unassigned <= 0 and not passPackmax_C then

																support_available = false

																local sujet =
																	draft.id
																	.." type: "
																	..support.type
																	.." SUPPORT aircraft <= 0"
																local cause = {
																	[1] = AcftAvail[support.name].unassigned,
																}
																rejectDraft(draft, sujet, cause, SafeGetLine())

																local details = {
																	aircraft_disponible = AcftAvail[support.name].unassigned
																}
																rejectStep(draft, "support", "support_no_aircraft", details, "BLOCK_C", SafeGetLine())

																return
															end
														end
													end
												end
											end
										end

										if support_available and not draft.main_overideMP and not passPackmax_C and mission_ini.strikeOnlyWithEscorte then

											validateEscortAvailability()

											if support_available then

												local support_available_before = support_available

												validateMandatorySupports()

											end

											if support_available then
												validateSupportRemainingAircraft()
											end
										end

										if isDebugModeC then
											debugLog(draft.id.." AtoG passe C_02b serviceable: "
												..tostring(AcftAvail[draft.name].serviceable)
												.." |available: "..tostring(AcftAvail[draft.name].available)
												.." >? "..tostring(AcftAvail[draft.name].available / denom_NeDonnePasTOUT))
										end

										-- interdit aux possible avion d'escorte de tout donner dans CAP ou Intercept

										if not override_MP_C and (draft.task == "CAP" or draft.task == "Intercept" ) then

											for n_squad, squad in pairs(oob_air[side]) do
												if squad.type == draft.type and squad.name == draft.name and ((squad.tasks["Escort"] and squad.tasks["Escort"] == true)
												or  (squad.tasks["SEAD"] and squad.tasks["SEAD"] == true) or  (squad.tasks["Strike"] and squad.tasks["Strike"] == true)  )
												then

													local test_Aircraftnumber = DeepCopy(draft.number)
													local needeMindAircraft = false

													if (AcftAvail[draft.name].unassigned - test_Aircraftnumber) >= (AcftAvail[draft.name].ready / 2) then
														-- test_Aircraftnumber = test_Aircraftnumber -2
														needeMindAircraft = true

														if isDebugModeC then
															debuGenTxt = debuGenTxt.."\n".." AtoG passe C_03_0a unassigned: "..AcftAvail[draft.name].unassigned.." - "..test_Aircraftnumber.." ready: "..AcftAvail[draft.name].ready .." /2"
															debuGenTxt = debuGenTxt.."\n".." AtoG passe C_03_0b result: "..(AcftAvail[draft.name].unassigned - test_Aircraftnumber).." <= "..(AcftAvail[draft.name].ready / 2)
														end
													elseif AcftAvail[draft.name].unassigned  > 0 then
														test_Aircraftnumber = math.floor(AcftAvail[draft.name].ready / 2)
														needeMindAircraft = true

													elseif AcftAvail[draft.name].unassigned  <= 0 then
														needeMindAircraft = false
													end

													-- draft.number = test_Aircraftnumber
													request_Main_Nb = test_Aircraftnumber

													if not needeMindAircraft then
														support_available = false

														if isDebugModeC then
															debuGenTxt = debuGenTxt.."\n"..(tostring(draft.id).." AtoG passe C_03  "..squad.type.." "..draft.task)
														end

														local tabRejected = {}
														tabRejected["sujet"]  = draft.id.." NE DONNE PAS TOUT en CAP ou Intercept ()support_available if AcftAvail[draft.name].unassigned - draft.number <= AcftAvail[draft.name].serviceable/3"
														tabRejected["cause"] = { " unassigned - draft.number: ", tostring(AcftAvail[draft.name].unassigned - draft.number), "serviceable/ denom_NeDonnePasTOUT: ", tostring(AcftAvail[draft.name].serviceable/ denom_NeDonnePasTOUT) }
														tabRejected["ligne"]  = SafeGetLine()
														table.insert(draft["rejected"], tabRejected)

													end
												end
											end
										end

										if isDebugModeC then
											debugLog(draft.id.." AtoG passe C_04  support_available "..tostring(support_available).." MPOverride_C: "..tostring(override_MP_C))
										end

										--add new package to ATO
										-- if support_available and draft.number > 0 then																		--continue if no support is required or enough support is available to create package
										if support_available and request_Main_Nb > 0 then

											local pack_n = #ATO[side]

											ATO[side][pack_n + 1] = {
												["main"] = {},																			--package main body
												["Escort"] = {},																		--Fighter escort
												["SEAD"] = {},																			--SEAD escort
												["Escort Jammer"] = {},																	--jammer escort
												["Flare Illumination"] = {},															--illumination flare
												["Laser Illumination"] = {},															--laser illumination
												["Strike"] = {},
												["Anti-ship Strike"] = {},
											}

											-- debugLog(draft.id.." AtoG passe C_04b Task: "..tostring(draft.task).." overideMP_B: "..tostring(draft.overideMP_B).." override_MP_C: "..tostring(override_MP_C).." draft.main_overideMP?: "..tostring(draft.main_overideMP) )
											if draft.main_overideMP and draft.task == "CSAR" then
												ATO[side][pack_n + 1]["CSAR"] = {}
												-- debugLog(draft.id.." AtoG passe C_04c")
											end

											pack_n = pack_n + 1

											--********************************************************************************************
											--********************************************************************************************
											--********************************AddFlight**********************************************
											--********************************************************************************************
											--********************************************************************************************

											--add flights of 1, 2 or 4 aircraft to package
											local function addFlight(arg_Assign, arg_Role, arg_Entry)

												if isDebugModeC then
													debugLog(draft.id.." AtoG passe C_10a |||BEFORE insert/create ATO table|||  _A_ arg_Assign: " ..tostring(arg_Assign).." \r\n _E_ arg_Role: "..tostring(arg_Role).." \r\n arg_Entry.task: "..tostring(arg_Entry.task))
												end

												local assigned
												while arg_Assign > 0 do																		--loop as long as there are aircraft to assign
													assigned = nil -- reset obligatoire à chaque itération sinon une ancienne valeur peut survivre et provoquer des break ou tailles de flights incohérents

													local debugA = ""
													local debugE = " _B_ arg_Entry.main_overideMP "..tostring(arg_Entry.main_overideMP)

													--for multiple flights with station time (CAP, AWACS, Tanker etc.)
													if arg_Entry.flights then
														local flightsize = math.ceil(draft.target.firepower.max / draft.loadout.firepower)	--how many aircraft should be in each flight
														debugA = "assign: "..arg_Assign.." >=? flightsize: "..flightsize
														if arg_Assign >= flightsize then													--if there are more aircraft left to assign than the size of one flight
															assigned = flightsize														--assign one full flight
															debugA = debugA .." ||if assign >= flightsize: assigned: "..assigned
														else																			--if there are less aircraft left to assign than size of one flight
															assigned = arg_Assign
															debugA = debugA .." ||else assigned: "..assigned												--assign whatever is left
														end

														if arg_Entry.task == "CAP" then
															if assigned < 2 then
																assigned = 2
															end
														else
															assigned = 1
														end

														arg_Entry.flights = arg_Entry.flights - 1												--one less flight to assign

														debugA = debugA .." ||result entry.flights: "..arg_Entry.flights

													elseif arg_Entry.task == "Escort Jammer" or arg_Entry.task == "Flare Illumination" or arg_Entry.task == "Laser Illumination" then		--for tasks with single aircraft
														assigned = 1																	--assign one aircraft per flight	
													elseif arg_Entry.task == "Transport" then
														-- local mpTask_Check_t = getMultiPlaneTask(side, draft.name, draft.type, arg_Entry.task)
														
														-- if multiPlaneSet and multiPlaneSet[side] and multiPlaneSet[side][draft.type]  and multiPlaneSet[side][draft.name][arg_Entry.task] then
														if mpTask_Check then
															assigned = arg_Assign
														else
															assigned = 1
														end

													elseif arg_Entry.task == "Intercept" then
														if arg_Assign >= 4 then																--if more than 2 aircraft are to be assigned
															assigned = 4																--assign flight of 2 aircaft
														-- if assign >= 2 then																--if more than 2 aircraft are to be assigned
														-- 	assigned = 2
														else
															assigned = 2																--else assign flight of 1 aicraft
														end
													--TODO revoir ça, pourquoi etre obligé de faire cela alors que ça devrait marcher comme les autres AWACS, pas seulement les S-3B et Hawkey?
													-- elseif arg_Entry.task == "AWACS" or arg_Entry.task == "Refueling" or arg_Entry.task == "AFAC" or arg_Entry.task == "Transport" then	--for bombers
													-- 	assigned = 1	
													-- elseif (entry.type == "S-3B" or entry.type == "F-117A" or entry.type == "B-1B" or entry.type == "B-52H" or entry.type == "Tu-22M3" or entry.type == "Tu-95MS" or entry.type == "Tu-142" or entry.type == "Tu-160" or entry.type == "MiG-25RBT")
													-- and entry.task ~= "Runway Attack" then	--for bombers	
													elseif (Data_divers[arg_Entry.type] and Data_divers[arg_Entry.type].flyingAlone) and arg_Entry.task ~= "Runway Attack" then	--for bombers
														assigned = 1																	--assigne one aircraft per flight
													elseif arg_Entry.task == "Reconnaissance" then											--for recon
														if arg_Assign == 1 then																--if there is one aircraft left to assign
															assigned = 1																--assigne one aircraft per flight
														elseif arg_Assign >= 4 then															--if more than 4 aircraft are to be assigned
															assigned = 4																--assign flight of 4 aircaft
														elseif arg_Assign == 3 then															--if more than 3 aircraft are to be assigned
															assigned = 3																--assign flight of 3 aircaft
														else
															assigned = 2																--else assign flight of 2 aicraft
														end
													elseif (arg_Entry.task == "SAR" or arg_Entry.task == "CSAR") and not arg_Entry.main_overideMP then											--for recon
														debugE = debugE.." _C_ AtoG SAR/CSAR assigned 1, override_MP_C: "..arg_Entry.target_name
														assigned = 1
													else																			--for everything else
														debugE = debugE .. " _D_ else BEFORE assigned: if assigned and assign == 1? "..arg_Assign

														if assigned and arg_Assign == 1 then												--if there is one aircraft left to assign and there was already a previous flight assigned, stop assigning (do not add leftover single-ships)
															break
														elseif arg_Assign >= 4 then															--if more than 4 aircraft are to be assigned
															assigned = 4																--assign flight of 4 aircaft
															debugE = debugE .." _E_ || elseif assign >= 4 then"
															else
															assigned = arg_Assign															--else assign flight size of what is left
														end
														debugE = debugE .. " _F_ || elseAFTER assigned: "..assigned
													end

													if arg_Assign >= 4 then															--if more than 4 aircraft are to be assigned
														assigned = 4																--assign flight of 4 aircaft
													-- else
													-- 	assigned = arg_Assign															--else assign flight size of what is left
													end

													--ATTENTION, le code plus bas est débile, et crée des flights de 6 (par exemple)
													-- if arg_Entry.main_overideMP then
													-- 	if multiPlaneSet[side][draft.type][draft.task] then
													-- 		assigned = arg_Entry.number
													-- 	end
													-- end

													if isDebugModeC then
														debugLog(draft.id.." AtoG passe C_11 |||BEFORE insert/create ATO table|||  _A_" ..debugA.." \r\n _E_ "..debugE.." \r\n assigned "..assigned)
													end

													local flight = {																	--build ATO flight entry
														name = arg_Entry.name,
														playable = arg_Entry.playable,
														type = arg_Entry.type,
														modification = arg_Entry.modification,
														callsign = arg_Entry.callsign,
														callsignId = arg_Entry.callsignId,
														helicopter = arg_Entry.helicopter,
														number = assigned,																--number of aircraft in flight
														country = arg_Entry.country,
														livery = arg_Entry.livery,
														sidenumber = arg_Entry.sidenumber,
														liveryModex = arg_Entry.liveryModex,
														base = arg_Entry.base,
														airdromeId = arg_Entry.airdromeId,
														parking_id = arg_Entry.parking_id,
														skill = arg_Entry.skill,
														task = arg_Entry.task,
														loadout = arg_Entry.loadout,
														route = {},																		--route is a table and connot be copied as a whole
														target = DeepCopy(arg_Entry.target),
														target_name = arg_Entry.target_name,
														firepower = assigned * arg_Entry.loadout.firepower,
														tot_from = arg_Entry.tot_from,
														tot_to = arg_Entry.tot_to,
														id = arg_Entry.id,
														score= draft.score,
														threatsGround = draft.threatsGround,
														threatsAir = draft.threatsAir,
													}
													for r = 1, #arg_Entry.route do															--make copy of route table
														flight.route[r] = {}
														for k,v in pairs(arg_Entry.route[r]) do
															flight.route[r][k] = v
														end
													end

			--######################################################################################################################################
			--######################################################################################################################################

			--######################################################################################################################################
			--#############"" START insert/create ATO table ##############################################################################################

													if ATO[side][pack_n][arg_Role] and ATO[side][pack_n][arg_Role] ~= nil then
														table.insert(ATO[side][pack_n][arg_Role], flight)

														if HO_TRACE and HumainOnlyUnit(HoUnit(flight.name)) then
															HoLog("  VOL_CREE side="..tostring(side).." pack="..tostring(pack_n).." role="..tostring(arg_Role).." index="..tostring(#ATO[side][pack_n][arg_Role]).." id="..tostring(flight.id).." squad="..tostring(flight.name).." task="..tostring(flight.task).." cible="..tostring(flight.target_name).." nb_avions="..tostring(flight.number).." playable="..tostring(flight.playable).." tot_from="..tostring(flight.tot_from).." reste_a_assigner="..tostring(arg_Assign))
														end

														local squadStatus = SquadGenerationStatus[flight.name]
														-- print("create flight AAA "..flight.name.." for role "..arg_Role.." in package "..pack_n.." with "..assigned.." aircraft, total firepower: "..flight.firepower)
														if squadStatus then
															squadStatus.mainGenerated = true
															-- print("SquadGenerationStatus BBB for "..flight.name.." mainGenerated set to true")
														end

													else
														-- if isDebugModeC then
															debugLog(draft.id.." AtoG passe C_12 ERROR ATO = nil arg_Role "..arg_Role)
														-- end
													end--add flight to package role (main, SEAD or escort)											

			--######################################################################################################################################
			--######################################################################################################################################

			--######################################################################################################################################

													if isDebugModeC then
														debugLog(draft.id.." AtoG passe C_13 |||AFTER insert/create ATO table||| type "..draft.type.." number "..assigned.." "..arg_Entry.task)
													end

													if draft.main_overideMP and mpTask_Check then

														-- multiPlaneSet[side][draft.type][draft.name].NbPlane = multiPlaneSet[side][draft.type][draft.name].NbPlane - assigned

														local mp_Data = getMultiPlane(side, draft.name, draft.type)

														if mp_Data then
															mp_Data.NbPlane = mp_Data.NbPlane - assigned
														end

														if isDebugModeC then
															debugLog(draft.id.." AtoG passe C_14 (NbPlane - assigned) "..multiPlaneSet[side][draft.type][draft.name].NbPlane)
														end
													end

													if not AcftAvail[arg_Entry.name] then
														debugLog(draft.id.." ERROR AcftAvail missing for "..tostring(arg_Entry.name))
														return
													end

													--Pourquoi: si ce squad a une répartition par tâche (tasksCoef), on plafonne "assigned" à ce qu'il
													--reste pour CETTE tâche précise, même si le pool global AcftAvail n'est pas épuisé -- sinon la
													--première tâche traitée peut engloutir tout le squad avant que les autres n'aient leur part.
													local taskForCap = (arg_Role == "main") and draft.task or arg_Role
													local assigned_avant_clamp = assigned

													if AcftAvail[arg_Entry.name].taskCap and AcftAvail[arg_Entry.name].taskCap[taskForCap] ~= nil then

														AcftAvail[arg_Entry.name].taskUsed = AcftAvail[arg_Entry.name].taskUsed or {}
														local usedSoFar = AcftAvail[arg_Entry.name].taskUsed[taskForCap] or 0
														local cap = AcftAvail[arg_Entry.name].taskCap[taskForCap]
														local remaining = cap - usedSoFar

														if remaining <= 0 then
															assigned = 0
														elseif assigned > remaining then
															assigned = remaining
														end

														AcftAvail[arg_Entry.name].taskUsed[taskForCap] = usedSoFar + assigned

														debugLog(draft.id.." AtoG TASKCAP squad: "..tostring(arg_Entry.name)
															.." arg_Role: "..tostring(arg_Role)
															.." taskForCap: "..tostring(taskForCap)
															.." cap: "..tostring(cap)
															.." deja_utilise_avant: "..tostring(usedSoFar)
															.." assigned_avant_clamp: "..tostring(assigned_avant_clamp)
															.." assigned_final: "..tostring(assigned)
															.." deja_utilise_apres: "..tostring(AcftAvail[arg_Entry.name].taskUsed[taskForCap]))

													else
														--Pourquoi: si on arrive ICI, le plafond n'a PAS été consulté du tout pour cet appel
														--(pas de taskCap pour ce squad, ou taskForCap ne correspond à aucune clé de taskCap)
														---> assigned part sans aucune limite par tâche, uniquement limité par le pool global.
														debugLog(draft.id.." AtoG TASKCAP_SKIPPED squad: "..tostring(arg_Entry.name)
															.." arg_Role: "..tostring(arg_Role)
															.." taskForCap: "..tostring(taskForCap)
															.." assigned_sans_plafond: "..tostring(assigned)
															.." taskCap_existe: "..tostring(AcftAvail[arg_Entry.name].taskCap ~= nil))
													end

													if assigned <= 0 then
														--plus de part disponible pour CETTE tâche précise (même si le pool global n'est pas vide)
														return
													end

													--Pourquoi: tracer précisément CHAQUE décrémentation réelle d'AcftAvail (la seule dans tout le
													--fichier), avec avant/après, pour repérer une éventuelle fuite de compteur sans avion en vol
													if Debug.debug then
														debugLog(
															draft.id.." AtoG DECREMENT_ACFTAVAIL squad: "..tostring(arg_Entry.name)
															.." role: "..tostring(arg_Role)
															.." draft.task: "..tostring(draft.task)
															.." target: "..tostring(draft.target_name)
															.." avant: "..tostring(AcftAvail[arg_Entry.name].unassigned)
															.." retire: "..tostring(assigned)
															.." apres: "..tostring(AcftAvail[arg_Entry.name].unassigned - assigned)
														)
													end

													AcftAvail[arg_Entry.name].assigned = AcftAvail[arg_Entry.name].assigned + assigned
													AcftAvail[arg_Entry.name].unassigned = AcftAvail[arg_Entry.name].unassigned - assigned		--remove assigned aircraft from total number of available aircraft for this unit
													arg_Assign = arg_Assign - assigned															--continue loop until are aircraft are assigned

													if HO_TRACE and HumainOnlyUnit(HoUnit(arg_Entry.name)) then
														HoLog("  CONSOMME squad="..tostring(arg_Entry.name).." role="..tostring(arg_Role).." retire="..tostring(assigned).." reste_a_assigner="..tostring(arg_Assign).." | "..HoAcft(arg_Entry.name))
													end

													if isDebugModeC then
														debugLog(draft.id.." AtoG passe C_15   assign "..arg_Assign.." type: "..arg_Entry.type.." unassigned: "..AcftAvail[arg_Entry.name].unassigned)
													end

												end
											end

											if isDebugModeC then
												debugLog(draft.id.." AtoG passe C_05  |AddFlight MAIN| number "..tostring(draft.number))
											end

											--********************************************************************************************
											-- addFlight(draft.number, "main", draft)												--add main body flights to package
											local draftForFlight = DeepCopy(draft)
											draftForFlight.number = request_Main_Nb

											addFlight(request_Main_Nb, "main", draftForFlight)
											--********************************************************************************************

											--vol principal reellement ajoute a l'ATO : si ce package a beneficie du mode
											--degrade (RelaxGeneration), c'est le point fiable pour l'annoncer (cf le meme
											--hook au niveau du 1er circuit, processEligibleLoadout / buildDraftSorties).
											AnnounceRelaxedLimits(draft.name, draft.target_name, draft.loadout.name)

											-- for taskSupport, supportPart in pairs(draft.support) do										--iterate through all package support
											-- Ça stabilise :
											-- l’ordre d’allocation support,
											-- la consommation avion,
											-- les résultats ATO.
											-- Tu élimines une énorme part de non-déterminisme.
											local orderedSupportTasks = {}

											for taskSupport in pairs(draft.support) do
												table.insert(orderedSupportTasks, taskSupport)
											end

											table.sort(orderedSupportTasks)

											for _, taskSupport in ipairs(orderedSupportTasks) do
												local supportPart = draft.support[taskSupport]

												if taskSupport and type(supportPart) == "table" then
													-- for _plane, support in pairs(supportPart) do
													local orderedSupportPlanes = {}

													for planeName in pairs(supportPart) do
														table.insert(orderedSupportPlanes, planeName)
													end

													table.sort(orderedSupportPlanes)

													for _, _plane in ipairs(orderedSupportPlanes) do
														local support = supportPart[_plane]
														local number  = 0
														if type(support) == "table" and support.name then

															if isDebugModeC then
																debugLog(draft.id.." AtoG passe C_06a  |AddFlight SUPPORT?| _plane "..tostring(_plane))
															end

															if support.number >= AcftAvail[support.name].unassigned then
																number = AcftAvail[support.name].unassigned
															end
															if support.number < AcftAvail[support.name].unassigned then
																number = support.number
															end

															if isDebugModeC then
																debugLog(draft.id.." AtoG passe C_06  |AddFlight SUPPORT| numberFINAL "..tostring(number).." support_name: "..taskSupport.." unassigned: "..tostring(AcftAvail[support.name].unassigned))
															end

															--********************************************************************************************
															addFlight(number, taskSupport, support)										--add support flights to package
															--********************************************************************************************

															multipackByTargetName[draft.target_name].supporTotal = multipackByTargetName[draft.target_name].supporTotal + number

														else

														end
													end
												else
													local sujet = draft.id.." IN AddFlight type(supportPart) == table"
													local cause = { "support_available: ", tostring(support_available) }
													rejectDraft(draft, sujet, cause, SafeGetLine())
												end
											end

											--remove the firepower applied by package to target from maximum firepower of all other draft sorties to the same target
											local firepower_applied = 0																	--collect the amount of firepower combined by all main body flights of this package
											for f = 1, #ATO[side][pack_n].main do														--iterate through all main body flights
												firepower_applied = firepower_applied + ATO[side][pack_n].main[f].firepower				--sum firepower
											end

											if multipackByTargetName[draft.target_name] and multipackByTargetName[draft.target_name]["nbPack"] then
												multipackByTargetName[draft.target_name]["nbPack"] = multipackByTargetName[draft.target_name]["nbPack"] -1
											end

											--status report
											status_counter_ATO = status_counter_ATO + 1

										else
											local sujet = draft.id.." SUPPORT IMPOSSIBLE()if support_available"
											local cause = { "support_available: ", tostring(support_available) }
											rejectDraft(draft, sujet, cause, SafeGetLine())
										end
									else
										local sujet = draft.id.." AVIONS INSUFFISANT()if draft.number <= available and limitMP then {draft.number, limitMP}"
										local cause = {"draft.number: ", tostring(draft.number), "limitMP: ", tostring(limitMP)}
										rejectDraft(draft, sujet, cause, SafeGetLine(), "insufficient_aircraft_count")
									end
								else
									local sujet = draft.id.." FIREPOWER du PACKAGE INSUFFISANT()if  available * draft.loadout.firepower >= (draft.target.firepower.packmin - 1) * draft.target.firepower.max"
									local cause = { [1] = tostring(available_Main * draft.loadout.firepower), [2]  = tostring((draft.target.firepower.packmin - 1) * draft.target.firepower.max), }
									rejectDraft(draft, sujet, cause, SafeGetLine(), "insufficient_package_firepower")
								end
							
							else
								--available_Main == 0 : c'est le vrai "plus aucun avion", cas le plus parlant pour le joueur.
								--available_Main > 0  : il reste des avions mais leur puissance de feu cumulee ne suffit pas.
								local reasonCode = "insufficient_firepower_available"
								if available_Main <= 0 then
									reasonCode = "no_aircraft_available"
								end
								local sujet = draft.id.." "..tostring(draft.type).." AVION DISPONIBLE INSUFFISANT "..tostring(draft.name).." available: "..tostring(available_Main).." draft.loadout.firepower: "..tostring(draft.loadout.firepower.." firepowerMin: "..tostring(draft.target.firepower.min))
								local cause = { [1] = tostring(available_Main), [2]  = tostring(draft.target.firepower.min), }
								rejectDraft(draft, sujet, cause, SafeGetLine(), reasonCode)
							end
						else
							local sujet = draft.id.." FIREPOWER INSUFFISANT (a augmenter dans loadout)if draft.target.firepower.max > 0 and draft.target.firepower.max >= draft.target.firepower.min"
							local cause = { [1] = tostring(draft.target.firepower.max), [2]  = tostring(draft.target.firepower.max), }
							rejectDraft(draft, sujet, cause, SafeGetLine(), "loadout_firepower_too_low")
						end
					else
						local sujet = draft.id.." MultiPACKAGE A 0 (?)if draft.multipack == nil or draft.multipack > 0 || target_name: "..tostring(draft.target_name).." || multipack: " ..tostring(draft.multipack)
						local cause = { [1] = tostring(draft.multipack), [2]  = tostring(draft.multipack), }
						rejectDraft(draft, sujet, cause, SafeGetLine())
					end
				else
					local sujet = draft.id.." MENACE TROP IMPORTANTE (descendre minscore ou diminuer Menace AA AS) minscore  "..tostring(draft.loadout.minscore).." <score? "..tostring(draft.score)
					local cause = { [1] = tostring(draft.loadout.minscore), [2]  = tostring(draft.score), }
					rejectDraft(draft, sujet, cause, SafeGetLine())

				end

				if isDebugModeC and next(escortRejectReasons) then
					for squadName, reasons in pairs(escortRejectReasons) do
						debugLog(draft.id.." ESCORT_REJECT "..squadName.." => "..table.concat(reasons, " | "))
					end
				end

			end
		end
	end
end
