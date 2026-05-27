--To assign the player to a flight in the ATO
--Initiated by Main_NextMission.lua 
------------------------------------------------------------------------------------------------------- 
-- last modification:  debug_d
if not versionDCE then versionDCE = {} end
versionDCE["ATO_PlayerAssign.lua"] = "1.9.75"
------------------------------------------------------------------------------------------------------- 
-- cleancode_f				(f springCleaning)
-- adjustment_d				(b: use io.stdin:read)(a:robust form) 
-- debug_d					(d choix cahotique, entrainant un bug radio)(c package stats)(b number of aircraft assigned to MP)(a: supprime la table camp.player qui garde par erreur celle du dossier Active)
-- modification M61_a		SAR
-- modification M48_f		Accept result mission (d: garde en memoire le txt camp["Briefing_text"])
-- modification M38_t		Check and Help CampaignMaker (t id info)
-- modification M33			Custom Briefing (TargetName)
-- Zarbas modification Z01	Select Task possible
-- modification M11A_bf		Multiplayer (f: interceptor)(bd wingmen)(wxy: force same package)
------------------------------------------------------------------------------------------------------- 

if Debug.debug then
	print("START ATO_PlayerAssign.lua "..versionDCE["ATO_PlayerAssign.lua"].." =-=-=-=-=-=-=-=-=-=-=-=-=-=-=")
end

--Global 
HumainPack = {}
PlayerFlight = false
AllCoopPossible = false
camp.player = nil
camp.client = nil

if camp.MultiPlayer then
	camp.MultiPlayer.pack_n = {}
end

--local
-- local debugAssign = Debug.debug
local debugAssign = false
if DebugAssignAll then
	debugAssign = true
end
local playable = {}
PlayerAssignFailure = {}
local tab_doublon = {}

-- Tronque une chaine au milieu avec ".."
local function truncateMiddle(str, maxLen)
	if #str <= maxLen then return str end
	if maxLen <= 4 then return string.sub(str, 1, maxLen) end
	
	local part = math.floor((maxLen - 2) / 2)
	return string.sub(str, 1, part) .. ".." .. string.sub(str, -part)
end

-- Pad à droite
local function padRight(str, len)

	local missing = len - #str

	if missing <= 0 then
		return str
	end

	return str .. string.rep(" ", missing)
end



if not camp.MultiPlayer then camp.MultiPlayer = {} end
if not camp.MultiPlayer["pack_n"] then camp.MultiPlayer["pack_n"] = {} end

for side, pack in pairs(ATO) do															--iterate through sides in ATO
	for p = 1, #pack do																	--iterate through packages in sides
		for role,flight in pairs(pack[p]) do											--iterate through roles in package (main, SEAD, escort)
			for f = 1, #flight do														--iterate through flights in roles
				if flight[f].playable == true then										--if flight is playable by player
					
					if flight[f].tot_from == 0 then										--flight is allowed to fly at mission start
						
						TrackPlayability(flight[f].playable, "playerAssign_ATO")						--track playabilty criterium has been met
						if flight[f].task == "Intercept" then							--if the task is intercept, check if there is an enemy strike with target in range of player interceptor
							
							TrackPlayability(flight[f].playable, "playerAssign_intercept")

							local enemy = "blue"
							if side == "blue" then
								enemy = "red"
							end
							for enemyPackN, enemy_pack in pairs(ATO[enemy]) do							--iterate through enemy packages
								if enemy_pack and enemy_pack.main and enemy_pack.main[1]
									and enemy_pack.main[1].route and enemy_pack.main[1].tot_from == 0 then									--enemy package is allowed to fly at mission start
									for _, wp in pairs(enemy_pack.main[1].route) do						--iterate through waypoints of first enemy main flight
										if wp.id == "Attack" then											--waypoint is an attack waypoint (ignore target as enemy package might do a standoff attack)
											local dist = GetDistance(wp, flight[f].route[1])				--measure distance from interceptor base to target
											if dist <= flight[f].target.radius then							--target is in range for interception
												if not tab_doublon[flight[f].groupName] then	
													TrackPlayability(flight[f].playable, "playerAssign_intercept_hostile")			--track playabilty criterium has been met

													playable[#playable + 1] = {									--add flight to playable table
														side = side,
														packN = p,
														role = role,
														flight = f,
														base = flight[f].base,
														-- unitname = unitname_,
														groupName = flight[f].groupName,
														number = flight[f].number,
														target_side = enemy,
														target_pack = enemyPackN,
														type = flight[f].type,
														squadName = flight[f].name,
														task = flight[f].task,
														id = flight[f].id,
													}
													tab_doublon[flight[f].groupName] = true
												end

											end
										end
									end
								end
							end

						elseif flight[f].task == "SAR" then							--if the task is intercept, check if there is an enemy strike with target in range of player interceptor
							
							local enemy = "blue"
							if side == "blue" then
								enemy = "red"
							end

							-- if not tab_doublon[flight[f].groupName] then
							local uniqueFlightId = side .. "_" .. p .. "_" .. role .. "_" .. f

							if not tab_doublon[uniqueFlightId] then

								TrackPlayability(flight[f].playable, "playerAssign_SAR")			--track playabilty criterium has been met

								playable[#playable + 1] = {									--add flight to playable table
									side = side,
									packN = p,
									role = role,
									flight = f,
									base = flight[f].base,
									-- unitname = unitname_,
									groupName = flight[f].groupName,
									number = flight[f].number,
									target_side = enemy,
									type = flight[f].type,
									squadName = flight[f].name,
									task = flight[f].task,
									id = flight[f].id,
								}
								tab_doublon[uniqueFlightId] = true
							end

						elseif flight[f].task == "CAP" then													--if the task is CAP, check if enemy aircraft will enter the CAP area when player is on station
							TrackPlayability(flight[f].playable, "playerAssign_CAP")

							if Multi.NbGroup >= 1 or ((f == 1 and (#flight - 1) * flight[f].loadout.tStation < flight[f].tot_to - flight[f].tot_from) or (f == 2 and (#flight - 1) * flight[f].loadout.tStation >= flight[f].tot_to - flight[f].tot_from)) then	--allow only the first or second flight (relief on station) in package to be playable
								local enemy = "blue"
								if side == "blue" then
									enemy = "red"
								end

								for enemy_pack_n, enemy_pack in pairs(ATO[enemy]) do						--iterate through enemy packages
									if enemy_pack and enemy_pack.main and enemy_pack.main[1] and enemy_pack.main[1].route then
										for w = 1, #enemy_pack.main[1].route - 1 do								--iterate through waypoints of first enemy main flight
											if Multi.NbGroup >= 1 or ((enemy_pack.main[1].route[w].id ~= "Target" and enemy_pack.main[1].route[w + 1].id ~= "Target") or enemy_pack.main[1].loadout.standoff == nil or enemy_pack.main[1].loadout.standoff <= 15000) then		--Ignore target WP for aircraft with standoff > 15 km
												
												local dist = GetTangentDistance(enemy_pack.main[1].route[w], enemy_pack.main[1].route[w + 1], flight[f].target)		--get closest distance from CAP station to route between WP w and WP w+1																	
												if Multi.NbGroup >= 1 or dist <= flight[f].target.radius then							--route segement is in range of CAP station											

													if not tab_doublon[flight[f].groupName] then
														TrackPlayability(flight[f].playable, "playerAssign_CAP_hostile")
														playable[#playable + 1] = {									--add flight to playable table
															side = side,
															packN = p,
															role = role,
															flight = f,
															base = flight[f].base,
															-- unitname = unitname_,
															groupName = flight[f].groupName,
															number = flight[f].number,
															target_side = enemy,
															target_pack = enemy_pack_n,
															type = flight[f].type,
															squadName = flight[f].name,
															task = flight[f].task,
															id = flight[f].id,
														}
														tab_doublon[flight[f].groupName] = true
													end
												end
											end
										end
									end
								end
							end
						else
							
							if not tab_doublon[flight[f].groupName] then								--check for duplicate entries
							
								playable[#playable + 1] = {														--add flight to playable table
									side = side,
									packN = p,
									role = role,
									flight = f,
									base = flight[f].base,
									-- unitname = "Pack " .. p .. " - " .. flight[f].name .. " - " .. flight[f].task .. " " .. f .. "-" .. 1,
									-- unitname = unitname_,
									groupName = flight[f].groupName,
									number = flight[f].number,
									target_name = flight[f].target_name,										-- modification M33 	Custom Briefing (TargetName)
									type = flight[f].type,
									squadName = flight[f].name,
									task = flight[f].task,
									id = flight[f].id,
								}
								tab_doublon[flight[f].groupName] = true
							end
						end
					end
				end
			end
		end
	end
end

local groupNChoice
local choice
local unitNChoice = 1
TaskRefused = false

if Multi.Group then
	for i = 1, #Multi.Group do
		Multi.Group[i].counted = nil
		
		PlayerAssignFailure[i] = {
		requestedPlane = Multi.Group[i].PlaneType,
		requestedTask = Multi.Group[i].task,
		requestedNb = Multi.Group[i].NbPlane,

		foundFlights = 0,
		foundAircraft = 0,

		bestFlight = nil,
		bestAircraft = 0,

		reason = nil,
	}
	end
elseif SinglePlayer then

	PlayerAssignFailure[1] = {
		requestedPlane = PlayerPlane or "unknown",
		-- requestedTask = PlayerData and PlayerData.task or "unknown",
		requestedTask =  "unknown",
		requestedNb = 1,

		foundFlights = 0,
		foundAircraft = 0,

		bestFlight = nil,
		bestAircraft = 0,

		reason = nil,
	}
end

--fait une copie de Multi pour eviter de perdre le nombre d'avion
local multiBIS = DeepCopy(Multi)
local creaClientFlight = {}																									--crée une table pour dérouler plus tard les flight selectionnable
local sum

if debugAssign then
	_affiche(multiBIS, "MultiBIS AtoPA ")
	_affiche(playable, "playable AtoPA ")
end

-- Vérifie si on a bien des avions jouables et des groupes définis
-- if #playable == 0 or not multiBIS.NbGroup then
--     return
-- end
if not multiBIS.NbGroup then
    return
end

-- Parcours des slots jouables
for _, slot in ipairs(playable) do
    if not slot.counted then
        if SinglePlayer then
			break
		end
		for _, requestGroup in ipairs(multiBIS.Group or {}) do
           
			for failN, failData in pairs(PlayerAssignFailure) do

				if slot.type == failData.requestedPlane then

					failData.foundFlights = failData.foundFlights + 1

					if slot.number > failData.bestAircraft then
						failData.bestAircraft = slot.number
						failData.bestFlight = slot.groupName
					end

					if slot.task == failData.requestedTask then
						failData.foundAircraft = failData.foundAircraft + slot.number
					end
				end
			end

			if slot.type == requestGroup.PlaneType and not requestGroup.counted then
                
                -- Initialise le quota restant si nécessaire
                if requestGroup.NotAssigned == nil then
                    requestGroup.NotAssigned = requestGroup.NbPlane
                end

				if requestGroup.found == nil then requestGroup.found = 0 end

                -- Calcule combien d'avions peuvent être affectés
                local nbPlaneToAssign = math.min(slot.number, requestGroup.NotAssigned)

				for failN, failData in pairs(PlayerAssignFailure) do
					if failData.requestedPlane == requestGroup.PlaneType and failData.requestedTask == requestGroup.task then
						-- failData.found = failData.found + nbPlaneToAssign
						failData.found = (failData.found or 0) + nbPlaneToAssign
					end
				end

				slot.remaining = slot.remaining or slot.number
				slot.remaining = slot.remaining - nbPlaneToAssign

                requestGroup.NotAssigned = requestGroup.NotAssigned - nbPlaneToAssign

                -- Cherche une entrée existante dans creaClientFlight
                local entryFound = false
                for _, entry in ipairs(creaClientFlight) do
                    if entry.PlaneType == requestGroup.PlaneType
                        and entry.task == requestGroup.task
                        and entry.side == requestGroup.side then
                        
                        entry.NbPlane    = entry.NbPlane + nbPlaneToAssign
                        entry.NotAssigned = requestGroup.NotAssigned
                        entryFound = true
                        break
                    end
                end

                -- Si aucune entrée existante, on en crée une
                if not entryFound then
                    local tabTemp = DeepCopy(requestGroup)
                    tabTemp.NbPlane = nbPlaneToAssign
                    table.insert(creaClientFlight, tabTemp)
                end

                -- Marque comme traité si quota atteint
                if requestGroup.NotAssigned <= 0 then
                    requestGroup.counted = true
                    -- slot.counted  = true
					if slot.remaining <= 0 then
						slot.counted = true
					end
                end
            end
        end
    end
end


-- if #playable > 0 and multiBIS.NbGroup then
if multiBIS.NbGroup then
	if multiBIS.Group then
		AllCoopPossible = true
		for k=1, #multiBIS.Group do
			if multiBIS.Group[k].counted and multiBIS.Group[k].NotAssigned then
			else
				AllCoopPossible = false
				if PlayerAssignFailure[k] then
					PlayerAssignFailure[k].remaining = multiBIS.Group[k].NotAssigned or 0

					if #playable == 0 then
						PlayerAssignFailure[k].reason = "no_playable_flight_generated"
					else
						local foundPlane = false
						local foundTask = false

						for _, slot in ipairs(playable) do
							if slot.type == multiBIS.Group[k].PlaneType then
								foundPlane = true

								if slot.task == multiBIS.Group[k].task then
									foundTask = true
								end
							end
						end

						if not foundPlane then
							PlayerAssignFailure[k].reason = "no_aircraft_generated"

						elseif not foundTask then
							PlayerAssignFailure[k].reason = "task_not_generated"

						elseif PlayerAssignFailure[k].foundAircraft < PlayerAssignFailure[k].requestedNb then
							PlayerAssignFailure[k].reason = "insufficient_aircraft"

						else
							PlayerAssignFailure[k].reason = "unknown"
						end
					end
				end

				if Debug.debug then
					print("AtoPA   no flight possible or not NotAssigned:  "..tostring(multiBIS.Group[k].NotAssigned).." for this aircraft: "..tostring(multiBIS.Group[k].PlaneType))
					_affiche(multiBIS,"ATO_PA_MultiBIS: ")

					for sideName, units in pairs(oob_air) do
						for unitN, unit in pairs(units) do
							if unit.type == multiBIS.Group[k].PlaneType and not unit.inactive then
								
								_affiche(AcftAvail[unit.name], "Aircraft_availability[unit.name]")

							end
						end
					end
				end
			end
		end
	elseif #playable > 0 then
		AllCoopPossible = true
	end

	if debugAssign then
		-- _affiche(playability_Multi, "playability_Multi Before  AtoPA")
		_affiche(creaClientFlight, "creaClientFlight  AtoPA ")
		print("AtoPA AllCoopPossible "..tostring(AllCoopPossible))
	end
end

--enleve du rooster le nb d'avion que l'on a artificiellement augmenté pour le MP
if #playable > 0 and not AllCoopPossible then

	for i=1, #playable do
		local playableNb = playable[i].number

		if camp.Aircraft_availability[playable[i].squadName] then
			local testIme = 0
			--check la plus grande valeur, qui correspond certainement aux derniers ajouts
			for k  , _unavailable in pairs(camp.Aircraft_availability[playable[i].squadName].unavailable) do
				if _unavailable  > testIme then
					testIme = _unavailable
				end
			end

			for k  , _unavailable in pairs(camp.Aircraft_availability[playable[i].squadName].unavailable) do
				if _unavailable == testIme and playableNb > 0 then
					camp.Aircraft_availability[playable[i].squadName].unavailable[k] = 0
					camp.Aircraft_availability[playable[i].squadName].assigned = camp.Aircraft_availability[playable[i].squadName].assigned - 1
					camp.Aircraft_availability[playable[i].squadName].unassigned = camp.Aircraft_availability[playable[i].squadName].unassigned + 1
					playableNb = playableNb - 1
				end
			end
		end
	end
else

	if debugAssign then
		_affiche(Playability_criterium, "Playability_criterium AtoPA ")
		-- os.execute 'pause'
	end
end


if #playable > 0 and AllCoopPossible then																--there are playable flights

	if SinglePlayer and AllCoopPossible then														-- if solo flight
		-- Mod Zarbas Z01 Select Task possible
		----------------

		local tabIndex = {}
		repeat
			print("\n\n Day or Night? : "..Daytime)														-- info day or not
			print("\n\nAvailable tasks:")
			
			local indexTotal
			
			if WingmenPlayer then
				for index = 1, #playable do
					for unitN = 1, playable[index].number do
						indexTotal = index .. unitN
						io.write(indexTotal .. " : " .. AliasBaseName(playable[index].base) .. " | " .. AliasTypeName(playable[index].type) .. " | " .. playable[index].groupName.." - "..unitN)
						
						if unitN == 1 then  
							io.write(" (Leader) ") 
						else
							io.write("          ")
						end

						if playable[index].target_name ~= nil then  io.write(" | "..playable[index].target_name) end

						io.write("\n")
						tabIndex[indexTotal] = true
					end
				end
			else
				for index = 1, #playable do
					io.write(index .. " - " .. AliasBaseName(playable[index].base) .. " - " .. AliasTypeName(playable[index].type) .. " " .. playable[index].groupName)
					if playable[index].target_name ~= nil then  io.write(" | "..playable[index].target_name) end
					io.write("\n")
					tabIndex[tostring(index)] = true
				end
			end


			print("r - random task")
			print("s - skip mission")
			tabIndex["s"] = true
			tabIndex["S"] = true
			tabIndex["r"] = true
			tabIndex["R"] = true
			if #playable == 1 then
				print("Please select your task (1-r-s): ")
			else
				print("Please select your task (1-"..(#playable).."-r-s): ")
			end
			-- r = io.read()
			choice = io.stdin:read()

			if type(choice) == "string" and choice ~= "" and string.match(choice, "^%d+$") then	
				if WingmenPlayer then
					groupNChoice = math.floor(choice / 10)	-- dizaine
					unitNChoice = choice % 10				-- unité
				else
					groupNChoice = tonumber(choice)
				end
			elseif type(choice) == "string" then
				if string.lower(choice) == "s" then
					TaskRefused = true
					groupNChoice = math.random(1, #playable)
				elseif string.lower(choice) == "r" then
					groupNChoice = math.random(1, #playable)
				end
			end

			local stringChoice = tostring(choice)
			if not tabIndex[stringChoice] then
				print("\nInvalid entry.\n")
			end

		until tabIndex[stringChoice]

		if not TaskRefused then

			local selectedPlayable = playable[groupNChoice]

			if not selectedPlayable then
				print("ERROR: invalid playable flight selection.")
				TaskRefused = true
			else

				ATO[selectedPlayable.side][selectedPlayable.packN][selectedPlayable.role][selectedPlayable.flight].player = true
				ATO[selectedPlayable.side][selectedPlayable.packN][selectedPlayable.role][selectedPlayable.flight].unitPlayer = unitNChoice

				HumainPack[selectedPlayable.packN] = {
					humainTypePlane = selectedPlayable.type
				}

				camp.player = {
					side = selectedPlayable.side,
					pack_n = selectedPlayable.packN,
					role = selectedPlayable.role,
					flight = selectedPlayable.flight,
					groupName = selectedPlayable.groupName,
					target = ATO[selectedPlayable.side][selectedPlayable.packN][selectedPlayable.role][selectedPlayable.flight].target,
					tgt_side = selectedPlayable.target_side,
					tgt_pack = selectedPlayable.target_pack,
					tgt_wp = 1,
					airbase = selectedPlayable.base,
					squadName = selectedPlayable.squadName,
					task = selectedPlayable.task,
					type = selectedPlayable.type,
				}
			end
		end

		------------------
	elseif AllCoopPossible then	--si le multiplayerF1 est demandé

		local MpIdInterceptor = 1

		io.write( "\n")
		print("\n\n Day or Night? : "..Daytime)
		io.write( "\n")

		local tabSelect = {}																		--table pour afficher * devant chaque selection
		local badEntry = false
		local foundGoodMain = false

		for k=1, #creaClientFlight do																	-- si le multiplayer est demande
			local resteAPrendre = creaClientFlight[k].NbPlane		
			repeat
				local tabIndex = {}																		--table pour afficher uniquement les choix possibles

				repeat
					
					print(" -------------------------------------------------------> Note: Your plane Flight wishes: ")
					print(" -------------------------------------------------------> "..creaClientFlight[k].NbPlane.." "..creaClientFlight[k].PlaneType.." ("..creaClientFlight[k].side..") "..creaClientFlight[k].task)
					

					-- ========================================
					-- Construction des lignes avant affichage
					-- ========================================

					local MAX_LINE_LEN = 120
					local lines = {}

					for index = 1, #playable do

						local indexN = " "
						if tabSelect[index] then
							indexN = "*"
						elseif creaClientFlight[k].PlaneType == playable[index].type then
							indexN = tostring(index)
							tabIndex[index] = true
						end

						local col1 = indexN.."(Nb: "..playable[index].number..")"
						local col2 = AliasBaseName(playable[index].base)
						local col3 = AliasTypeName(playable[index].type)
						local col4 = playable[index].groupName or ""
						local col5 = playable[index].target_name or ""

						--  IMPORTANT : array simple, PAS c1= !
						table.insert(lines, {
							col1,
							col2,
							col3,
							col4,
							col5
						})
					end


					-- ========================================
					-- CONFIG
					-- ========================================

					-- largeur max par colonne (optionnel, extensible)
					local maxWidth = {
						12,  -- col1
						22,  -- col2
						12,  -- col3
						40,  -- col4
						40,  -- col5
						-- tu peux ajouter col6, col7 plus tard
					}

					-- ========================================
					-- CALCUL LARGEUR AUTO
					-- ========================================

					local colCount = 0

					if lines[1] then
						colCount = #lines[1]
					else
						colCount = 0
					end
					if colCount == 0 then
						print("No selectable flights available.")
						break
					end

					local widths = {}

					for c = 1, colCount do
						widths[c] = 0
					end

					-- calcule largeur max réelle
					for _, line in ipairs(lines) do
						for c = 1, colCount do
							local value = line[c] or ""
							if #value > widths[c] then
								widths[c] = #value
							end
						end
					end

					-- applique limites
					for c = 1, colCount do
						if maxWidth[c] then
							widths[c] = math.min(widths[c], maxWidth[c])
						end
					end

					-- affichage final
					for _, line in ipairs(lines) do
						
						local parts = {}
						
						for c = 1, colCount do
							local value = line[c] or ""
							value = truncateMiddle(value, widths[c])
							
							if c < colCount then
								value = padRight(value, widths[c])
							end
							
							table.insert(parts, value)
						end
						
						local finalLine = table.concat(parts, " | ")
						
						if #finalLine > MAX_LINE_LEN then
							finalLine = truncateMiddle(finalLine, MAX_LINE_LEN)
						end
						
						print(finalLine)
					end



					print("s - skip mission")
					tabIndex["s"] = true
					tabIndex["S"] = true
					if badEntry then print("\n\\WARNING, your previous choice was wrong. Do it again: ") end
					print("Please select your flight (1-"..(#playable).."): ")

					groupNChoice = io.stdin:read()

					if type(groupNChoice) == "string" and groupNChoice ~= "" and string.match(groupNChoice, "^%d+$") then
						groupNChoice = tonumber(groupNChoice)										-- si inférieur à 57 ASCII, c'est inférieur au chiffre 9, donc c'est un chiffre
					elseif type(groupNChoice) == "string" then
						if string.lower(groupNChoice) == "s" then
							TaskRefused = true
							groupNChoice = math.random(1, #playable)
						end
					end

					if not tabIndex[groupNChoice] then
						print("\nInvalid entry.\n")
						badEntry = true
					else
						tabSelect[groupNChoice] = true
						badEntry = false
					end

				until tabIndex[groupNChoice]

				if playable[groupNChoice] then print("Selected: "..playable[groupNChoice].groupName) end

				local selectedPlayable = playable[groupNChoice]

				-- if not TaskRefused then
				if not TaskRefused and selectedPlayable then

					resteAPrendre = resteAPrendre - selectedPlayable.number

					-- ajoute ce systeme pour avoir le briefing de tous
					if not camp.client then camp.client = {} end

					local tabClient = {
						side = selectedPlayable.side,
						pack_n = selectedPlayable.packN,
						role = selectedPlayable.role,
						flight = selectedPlayable.flight,
						groupName = selectedPlayable.groupName,
						target = ATO[selectedPlayable.side][selectedPlayable.packN][selectedPlayable.role][selectedPlayable.flight].target,
						tgt_side = selectedPlayable.target_side,
						tgt_pack = selectedPlayable.target_pack,
						tgt_wp = 1,
						airbase = selectedPlayable.base,
						squadName = selectedPlayable.squadName,
						task = selectedPlayable.task,
						type = selectedPlayable.type,
					}

					table.insert(camp.client, tabClient)

					HumainPack[selectedPlayable.packN] = {
						humainTypePlane = selectedPlayable.type
					}


					-- garde ce systeme pour ne faire un debriefing que sur un group, normalement celui du main
					-- local foundGoodMain
					if not foundGoodMain then
						camp.player = {
							side = selectedPlayable.side,
							pack_n = selectedPlayable.packN,
							role = selectedPlayable.role,
							flight = selectedPlayable.flight,
							groupName = selectedPlayable.groupName,
							target = ATO[selectedPlayable.side][selectedPlayable.packN][selectedPlayable.role][selectedPlayable.flight].target,
							tgt_side = selectedPlayable.target_side,
							tgt_pack = selectedPlayable.target_pack,
							tgt_wp = 1,
							airbase = selectedPlayable.base,
							squadName = selectedPlayable.squadName,
							task = selectedPlayable.task,
							type = selectedPlayable.type,
						}

						HumainPack[selectedPlayable.packN] = {
							humainTypePlane = selectedPlayable.type
						}

						if selectedPlayable.role == "main" then foundGoodMain = true end
					end


					ATO[selectedPlayable.side][selectedPlayable.packN][selectedPlayable.role][selectedPlayable.flight].client = true
					ATO[selectedPlayable.side][selectedPlayable.packN][selectedPlayable.role][selectedPlayable.flight].IdClient = #camp.client
					-- ATO[playable[r].side][playable[r].packN][playable[r].role][playable[r].flight].NbPlaneClient = creaClientFlight[#camp.client].NbPlane
					ATO[selectedPlayable.side][selectedPlayable.packN][selectedPlayable.role][selectedPlayable.flight].NbPlaneClient = creaClientFlight[k].NbPlane
					
					camp.MultiPlayer.pack_n[selectedPlayable.packN] = true
				end
			until resteAPrendre <= 0 or TaskRefused
		end
	end

	if Debug.debug and camp.client then
		local camp_str = "camp.client = " .. TableSerialization(camp.client, 0)
		local campFile = io.open("Debug/CAMPclient0.lua", "w") or error("Échec d'ouverture du fichier ATO_AtoG")
		campFile:write(camp_str)
		campFile:close()
	end

	if Debug.debug then
		if not AllCoopPossible then
			_affiche(playable, "playable: ")
		end
	end

	if TaskRefused == true then
		PlayerFlight = false																--set true to end mission generation loop
	elseif AllCoopPossible then
		PlayerFlight = true																	--set true to end mission generation loop
	end

	if not TaskRefused then
		if not playable[groupNChoice] then
			print("ERROR: invalid playable flight selection.")
			TaskRefused = true
			groupNChoice = nil
		end

		local selectedPlayable = playable[groupNChoice]

		if not selectedPlayable then
			print("ERROR: invalid playable flight selection.")
			TaskRefused = true
		end

		--for intercept task, modify target package spawn to enter EWR coverage at mission start		
		if groupNChoice and ATO[selectedPlayable.side][selectedPlayable.packN][selectedPlayable.role][selectedPlayable.flight].task == "Intercept" and ATO[selectedPlayable.target_side] then		--player task is intercept -- modification M11.j : Multiplayer
			local pack = ATO[selectedPlayable.target_side][selectedPlayable.target_pack]											--pointer to target package

			local selectedFlight =
					ATO[selectedPlayable.side]
					[selectedPlayable.packN]
					[selectedPlayable.role]
					[selectedPlayable.flight]
					
			--find point where target package enters EWR coverage
			for w = 1, #pack.main[1].route - 1 do																		--iterate through waypoints of first main flight
				if (pack.main[1].route[w].id ~= "Target" and pack.main[1].route[w + 1].id ~= "Target") or pack.main[1].loadout.standoff == nil or pack.main[1].loadout.standoff <= 15000 then				--Ignore target WP for aircraft with standoff > 15 km

					local base_route_distance = GetTangentDistance(pack.main[1].route[w], pack.main[1].route[w + 1], selectedFlight.route[1])	--get closest distance from interceptor base to route between WP w and WP w+1
					if base_route_distance <= selectedFlight.target.radius then		--route segement is in range of interceptor

						local detected = false
						local distance = 100000000																				--distance from WP w to point where EWR coverage is entered
						local heading = GetHeadingDegre(pack.main[1].route[w], pack.main[1].route[w + 1])							--heading between WP w and WP w+1

						for e = 1, #EWR_DB[selectedPlayable.side] do																	--iterate through all ewr/awacs

							local radar_route_distance = GetTangentDistance(pack.main[1].route[w], pack.main[1].route[w + 1], EWR_DB[selectedPlayable.side][e])		--get closest distance from radar to route between WP w and WP w+1
							if radar_route_distance < EWR_DB[selectedPlayable.side][e].range then										--if route passes radar range circle
								
								local p1_ewr_heading = GetHeadingDegre(pack.main[1].route[w], EWR_DB[selectedPlayable.side][e])				--heading from p1 to radar
								local alpha = math.abs(heading - p1_ewr_heading)												--angle beteen route and p1-ewr
								if alpha > 180 then
									alpha = math.abs(alpha - 360)
								end
								local p1_ewr = GetDistance(pack.main[1].route[w], EWR_DB[selectedPlayable.side][e])						--distance between p1 and ewr
								local p1_p90ewr = math.cos(math.rad(alpha)) * p1_ewr											--distance between p1 and point on route perpendicular to ewr
								local p90ewr_ewr = p1_ewr * math.sin(math.rad(alpha))											--distance between ewr and point on route perpendicular to ewr
								-- local p90t_pC = math.sqrt(math.pow(EWR_DB[selectedPlayable.side][e].range, 2) - math.pow(p90ewr_ewr, 2))	--distance between point on route perpendiculat to ewr and point on route intersecting ewr circle
								local sqrtValue = math.pow(EWR_DB[selectedPlayable.side][e].range, 2) - math.pow(p90ewr_ewr, 2)

								if sqrtValue < 0 then
									sqrtValue = 0
								end

								local p90t_pC = math.sqrt(sqrtValue)

								local p1_pC = p1_p90ewr - p90t_pC																--distance from p1 to point on route intersecting ewr circle

								local p1_base = GetDistance(pack.main[1].route[w], selectedFlight.route[1])	--distance between p1 and interceptor base
								local p1_p90base = math.cos(math.rad(alpha)) * p1_base											--distance between p1 and point on route perpendicular to base
								local p90base_base = p1_base * math.sin(math.rad(alpha))										--distance between base and point on route perpendicular to base
								-- local p90b_pB = math.sqrt(math.pow(ATO[selectedPlayable.side][selectedPlayable.packN][selectedPlayable.role][selectedPlayable.flight].target.radius, 2) - math.pow(p90base_base, 2))	--distance between point on route perpendiculat to base and point on route intersecting base circle
								sqrtValue = math.pow( selectedFlight.target.radius, 2) - math.pow(p90base_base, 2)

								if sqrtValue < 0 then
									sqrtValue = 0
								end

								local p90b_pB = math.sqrt(sqrtValue)
								
								local p1_pB = p1_p90base - p90b_pB																--distance from p1 to point on route intersecting base circle

								if camp.player then
									if p1_pC <= 0 then
										distance = 0
										camp.player.EWR_freq = EWR_DB[selectedPlayable.side][e].frequency
										camp.player.EWR_call = EWR_DB[selectedPlayable.side][e].callsign
									elseif p1_pC < distance then
										distance = p1_pC
										camp.player.EWR_freq = EWR_DB[selectedPlayable.side][e].frequency
										camp.player.EWR_call = EWR_DB[selectedPlayable.side][e].callsign
									end
									if distance < p1_pB then
										distance = p1_pB
									end
									detected = true	

								elseif camp.client then
									if p1_pC <= 0 then
										distance = 0
										camp.player.EWR_freq = EWR_DB[selectedPlayable.side][e].frequency
										camp.player.EWR_call = EWR_DB[selectedPlayable.side][e].callsign
									elseif p1_pC < distance then
										distance = p1_pC
										camp.player.EWR_freq = EWR_DB[selectedPlayable.side][e].frequency
										camp.player.EWR_call = EWR_DB[selectedPlayable.side][e].callsign
									end
									if distance < p1_pB then
										distance = p1_pB
									end
									detected = true	
								end

							end
						end


						if detected then																						--route entered EWR coverage

							--set package TOT
							local route_time = 0
							for n = w, #pack.main[1].route - 1 do																--iterate through waypoints again, starting from current WP
								local leg_speed																					--speed on route leg
								if pack.main[1].route[n].id == "IP" or pack.main[1].route[n].id == "Attack" then
									leg_speed = pack.main[1].loadout.vAttack													--attack speed
								else
									leg_speed = pack.main[1].loadout.vCruise													--cruise speed
								end
								local leg_time = GetDistance(pack.main[1].route[n], pack.main[1].route[n + 1]) / leg_speed		--time of flight for route leg
								route_time = route_time + leg_time																--collect complete route time
								if pack.main[1].route[n].id == "Attack" then													--continue until last leg to target
									break																						--stop second route loop
								end
							end

							local speed
							if pack.main[1].route[w].id == "IP" or pack.main[1].route[w].id == "Attack" then
								speed = pack.main[1].loadout.vAttack															--attack speed
							else
								speed = pack.main[1].loadout.vCruise															--cruise speed
							end

							route_time = route_time - distance / speed															--subtract time of flight for undetected part on detection route leg

							if route_time < (mission_ini.startup_time_player/2) then
								route_time = (mission_ini.startup_time_player/2)
							end
							pack.main[1].tot = route_time																		--set package TOT for spawn at mission start when entering EWR detection area

							break																								--stop first route loop
						end
					end
				end
			end
		end
	end
else
	TaskRefused = true
end

if Debug.debug then

	local camp_str = "playable_ATO_PA = " .. TableSerialization(playable, 0)						--make a string
	local campFile = io.open("Debug/playable_ATO_PA.lua", "w") or error("Failed to open debug file")
	campFile:write(camp_str)																		--save new data
	campFile:close()

	camp_str = "camp_ATO_PA = " .. TableSerialization(camp, 0)						--make a string
	campFile = io.open("Debug/camp_ATO_PA.lua", "w") or error("Failed to open debug file")
	campFile:write(camp_str)																		--save new data
	campFile:close()


	camp_str = "ATO_2_ATO_PlayerAssign = " .. TableSerialization(ATO, 0)						--make a string
	campFile = io.open("Debug/ATO_2_ATO_PlayerAssign.lua", "w")	 or error("Failed to open debug file")
	campFile:write(camp_str)																		--save new data
	campFile:close()

	-- _affiche(HumainPack, "HumainPack: ")
	-- os.execute 'pause'
end