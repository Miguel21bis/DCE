--To create the briefing for the next mission
--Initiated by MAIN_NextMission.lua
------------------------------------------------------------------------------------------------------- 
-- last modification: debug_j
if not versionDCE then versionDCE = {} end
versionDCE["DC_Briefing.lua"] = "1.24.157"
------------------------------------------------------------------------------------------------------- 
-- cleancode_d				(d springCleaning)						
-- adjustment_b				(b \\" to \")(a add AFAC task)
-- debug_j					(j tempPlayer.package)(i package stats)(h nbPasse)(g mission h)(f mission.maxDictId)(e intercept navigation) (d: affiche info MP)(c: camp.date.day)  (b: Mi8 & Mi24)(a: add Mig21 Channel 00)

-- modification M80_a		use various tables, such as base name or aircraft type aliases
-- modification M78_a		LatLon positions added and unit display removed on MAP F10 (a LL_KnownPositionsTable)
-- modification M61_a		SAR
-- modification M58_b		flight plan, heading, Dist, ETE (b bug, no view)
-- modification M53_b		automatic update of the conf_mod file (b conf_mod reconfiguration)
-- modification M51_d  		Moonphase (d: NVG info)
-- modification M48_g		Accept result mission (d: garde en memoire le txt camp["Briefing_text"]) (g: addImage trigger)(f: debug)
-- modification M47_d  		Keeps the history of the campaign files (d: Briefing part)
-- modification M41_b 		Sratchpad written in the Sratchpad file, if this modul is installed
-- modification M38_k 		Check and Help CampaignMaker (k: frequence)
-- modification M34_Bj  	custom FrequenceRadio (j inheritedType)(g pattern schedule)(f more Divert, more Coalition, bug list Freq)(e bug canal 0 ex Mig21)(Bd sautomatically selects the correct range ex Mig19)(z guard et reorganisation radio)(y supprime les n°indicatif AwacsTanker)(s: bug nb radio limited)(r: LVHF)(t: NameRadio)(s: Coalition)(s: debug R3)(r.o: all ATC freq in array)(n: bestCapability)(m: freq group bug)(l: bug (number expected, got string))(k: utilise les indicatifs WEST pour EWR)(i  3 frequency bands)
-- modification M33_m 		Custom Briefing (lm: use  DictKey_descriptionText)(ijk MP limite le nombre de briefing different)(h: only one time airlift info)(g: divert without freq)(f: divert CVN)(e: divers) (d: Divert)(c: Alignement du txt)(onBoardNum)
-- modification M27_b 		movedBullseye (b: bug if no Bullseye)
								-- modification M17.c Option F-14B
-- Modification M15_d 		info catapulte/pont dans briefing
-- modification M11B 		Multiplayer--briefing
-- modification M11_y		Multiplayer (y: force same package)							
-- modification M07_h		EWR toujours affiché dans le briefing
-- modification M06_b		helicoptere playable
-- modification M05_c		ajout picture Briefing + pictures Target  (c: debug {""})
-- modification M04_h		ajout d'une troisieme radio (g: helicopter recovery radio)(g: recovery radio)(f: set up radio channels for wing players )
------------------------------------------------------------------------------------------------------- 


local nbPasse = 0
local target_picture = {}

----- Mission Title -----
mission.sortie = camp.title .. " - " .. camp.mission


local function FreqCapability(TestFreq, RadioPlane, Nradio, info)
	local waves  = ""

	if type(TestFreq) == "table" then
		return false
	elseif type(TestFreq) == "string" then
		TestFreq = tonumber(TestFreq)
		if type(TestFreq) ~= "number" then
			return false
		end
	end
	if not RadioPlane[Nradio] or RadioPlane[Nradio] == nil then
		return false
	end
	-- modification M34.n (n: bestCapability)
	for wave, freqRange in pairs(RadioPlane[Nradio]) do
		if wave  == "HF" or wave  == "LVHF" or  wave  == "VHF" or  wave  == "UHF" then
			if type(freqRange)  == "table"  then
				if tonumber(TestFreq) < freqRange.max and  tonumber(TestFreq) > freqRange.min then
					if RadioPlane[Nradio] and RadioPlane[Nradio][wave] and (TestFreq > RadioPlane[Nradio][wave].min and TestFreq < RadioPlane[Nradio][wave].max)	 then
						return true
					end
				end
			end
		end
	end

	if TestFreq >= 225 then
		waves = "UHF"
	elseif TestFreq >= 100 and TestFreq < 225 then
		waves = "VHF"
	elseif TestFreq >= 20 and TestFreq < 100 then
		waves = "LVHF"
		if RadioPlane[Nradio] and not RadioPlane[Nradio][waves] then waves = "LVHF" end
	elseif TestFreq >= 1 and TestFreq < 20 then
		waves = "HF"
	else
		print()
		print("********************ATTENTION******************")
		print("***************Note for the Campaign Maker*****")
		print("Problem with frequency UFF? VHF? LVHF? HF? frequence: "..tostring(TestFreq).." Info: "..tostring(info))
		_affiche(RadioPlane, "RadioPlane")
		print("********************ATTENTION******************")
		print()
		os.execute 'pause'
	end

	if RadioPlane[Nradio] and RadioPlane[Nradio][waves] and (TestFreq > RadioPlane[Nradio][waves].min and TestFreq < RadioPlane[Nradio][waves].max)	 then
		return true
	else
		return false
	end
end


local function writeWordsNicelyTidy(entries)
	local txt = ""

	--determine maximum string length for each entry
	for e = 1, #entries do																		--iterate through entries
		entries[e].str_length = string.len(entries[e].header) + 1									--store string length of header for this entry
		for n = 1, #entries[e].values do														--iterate through values of this entry
			local l = string.len(tostring(entries[e].values[n])) + 1 								--get string length of value of this entry
			if l > entries[e].str_length then													--if the string length is larger than the previous
				entries[e].str_length = l														--make it the new length (find the largest)
			end
		end
	end

	--build the list header
	for e = 1, #entries do																		--iterate through entries
		if entries[e].header then
			txt = txt .. entries[e].header																--add header
			if e < #entries then																	--if this is not the last header, add spaces to the next header	
				local space = entries[e].str_length + 0 - string.len(entries[e].header)				--calculate number of spaces that need to be added for alignement (string length of largest entry of same type + 3 - length of current entry = number of spaces)
				for m = 1, space * 1.0 do
					txt = txt .. " "																	--add 1.5 spaces for every missing letter
				end
			end
		end
	end
	txt = txt .. "\n"

	--build the list		
	for n = 1, #entries[1].values do
		for e = 1, #entries do
			txt = txt .. tostring(entries[e].values[n])
			if e < #entries then
				local space = entries[e].str_length + 0 - string.len(tostring(entries[e].values[n]))	--calculate number of spaces that need to be added for alignement (string length of largest entry of same type + 3 - length of current entry = number of spaces)
				for m = 1, space * 1.0 do
					txt = txt .. " "																--add 1.5 spaces for every missing letter
				end
			end
		end
		txt = txt .. "\n"
	end

	return txt
end

--Order of Battle
do
	local s = ""

	s =  FormatDate(camp.date.day, camp.date.month, camp.date.year) .. ", " .. FormatTime(camp.time, "hh:mm") .. ":\n\n"		--add date and time header

	if AirLiftObjectif and next(AirLiftObjectif) ~= nil then
		s = "AirLift:\n\n"
		for place, airTxt in pairs(AirLiftObjectif) do
			s = s ..airTxt.. "\n"
		end
		s = s .. " \n\n"
	end


	s = s.."Order of Battle:\n\n"																--make lists of the air order of battle for all sides

	--air units
	for side_name,side in pairs(oob_air) do															--iterate through sides in oob_air
		if side_name == "blue" then
			s = s .. "Blue Air Units:\n"															--side header
		else
			s = s .. "Red Air Units:\n"															--side header
		end

		--define list entries
		local entries = {
			[1] = {
				header = "Unit",
				values = {},
			},
			[2] = {
				header = "Type",
				values = {},
			},
			[3] = {
				header = "Base",
				values = {},
			},
			[4] = {
				header = "Lst",
				values = {},
			},
			[5] = {
				header = "Dm",
				values = {},
			},
			[6] = {
				header = "Rdy",
				values = {},
			},
		}

		--add list values
		for unit_n,unit in ipairs(side) do															--iterate through units
			if unit.inactive ~= true then															--unit is active
				table.insert(entries[1].values, unit.name)											--unit name
				table.insert(entries[2].values, ReplaceTypeName(unit.type))							--unit type
				table.insert(entries[3].values, ReplaceBaseName(unit.base))											--unit base
				table.insert(entries[4].values, unit.roster.lost)									--unit lost aircraft
				table.insert(entries[5].values, unit.roster.damaged)								--unit damaged aircraft
				table.insert(entries[6].values, unit.roster.ready)									--unit ready aircraft
			end
		end

		--determine maximum string length for each entry
		for e = 1, #entries do																		--iterate through entries
			entries[e].str_length = string.len(entries[e].header)									--store string length of header for this entry
			for n = 1, #entries[e].values do														--iterate through values of this entry
				local l = string.len(tostring(entries[e].values[n]))								--get string length of value of this entry
				if l > entries[e].str_length then													--if the string length is larger than the previous
					entries[e].str_length = l														--make it the new length (find the largest)
				end
			end
		end

		--build the list header
		for e = 1, #entries do																		--iterate through entries
			s = s .. entries[e].header																--add header
			if e < #entries then																	--if this is not the last header, add spaces to the next header	
				local space = entries[e].str_length + 3 - string.len(entries[e].header)				--calculate number of spaces that need to be added for alignement (string length of largest entry of same type + 3 - length of current entry = number of spaces)
				for m = 1, space * 1.5 do
					s = s .. " "																	--add 1.5 spaces for every missing letter
				end
			end
		end
		s = s .. "\n"

		--build the list		
		for n = 1, #entries[1].values do															--iterate through number of values (number of units)
			for e = 1, #entries do																	--iterate through entries
				s = s .. entries[e].values[n]														--add value to list
				if e < #entries then																--if this is not the last header, add spaces to the next header	
					local space = entries[e].str_length + 3 - string.len(tostring(entries[e].values[n]))	--calculate number of spaces that need to be added for alignement (string length of largest entry of same type + 3 - length of current entry = number of spaces)
					for m = 1, space * 1.5 do
						s = s .. " "																--add 1.5 spaces for every missing letter
					end
				end
			end
			s = s .. "\n"																			--make a new line after each unit
		end

		--add oob description text (reinforcements and repairs)
		if PlayerFlight and camp.player and camp.player.side == side_name then										--only do it for player side
			if side_name == "blue" then
				if Briefing_oob_text_blue ~= "" then
					s = s .. "\n" .. Briefing_oob_text_blue .. "\n"
				else
					s = s .. "\n\n"
				end
			elseif side_name == "red" then
				if Briefing_oob_text_red ~= "" then
					s = s .. "\n" .. Briefing_oob_text_red .. "\n"
				else
					s = s .. "\n\n"
				end
			end
		elseif PlayerFlight and camp.client and camp.client.side == side_name then										--only do it for player side
			if side_name == "blue" then
				if Briefing_oob_text_blue ~= "" then
					s = s .. "\n" .. Briefing_oob_text_blue .. "\n"
				else
					s = s .. "\n\n"
				end
			elseif side_name == "red" then
				if Briefing_oob_text_red ~= "" then
					s = s .. "\n" .. Briefing_oob_text_red .. "\n"
				else
					s = s .. "\n\n"
				end
			end
		else
			s = s .. "\n\n"																		--make a new line after each side
		end
	end


	--ground targets
	for side_name, targetSide in pairs(targetlist) do														--iterate through sides in targetlist
		if side_name == "blue" then																	--owner of the target is the opposite of targetlist side
			s = s .. "Red Ground Assets:\n"														--side header
		else
			s = s .. "Blue Ground Assets:\n"														--side header
		end

		-- local sort_table = {}																		--array to sort the targetlist
		-- for k,v in pairs(side) do
		-- 	table.insert(sort_table, k)																--insert key into sort table
		-- end
		-- table.sort(sort_table)																		--sort the table

		local entries = {
			[1] = {
				header = "Name",
				values = {},
			},
			[2] = {
				header = "(pourcent)",
				values = {},
			},
			[3] = {
				header = "Position",
				values = {},
			},
		}

		for targetN, target in ipairs(targetSide) do															--iterate through sort table
			if target.inactive ~= true then														--target is active
				if target.alive and target.type ~= "Ejected Pilot" then																--target is a ground target
					if target.hidden == nil or target.hidden == false then						--target is not hidden
						-- s = s .. "- " .. target.titleName .. " (" .. math.ceil(target.alive) .. "%)"	--\n"		--add target name and alive percentage
						local entry =  "- " .. target.titleName 		--add target name and alive percentage

						table.insert(entries[1].values, entry)

						table.insert(entries[2].values, " (" .. math.ceil(target.alive) .. "%)")

						if target.expand then														--target elements should be displayed expanded
							if target.elements then												--target has elements
								local max_strl = 0
								for e = 1, #target.elements do										--iterate through elements
									local strl = string.len(target.elements[e].name)				--get elements name stringh lenght
									if strl > max_strl then
										max_strl = strl												--find longest string name
									end
								end
								for elementN, element in pairs(target.elements) do										--iterate through elements
									local space = max_strl - string.len(element.name) + 5
									s = s .. "   - " .. element.name					--list each element
									for m = 1, space do
										s = s .. " "												--add one space for every missing letter
									end
									if camp.ShipHealth and camp.ShipHealth[element.name] then		--ship has a health entry
										if camp.ShipHealth[element.name] == 0 then					--ship is sunk
											s = s .. "(sunk)"
										elseif camp.ShipHealth[element.name] < 33 then				--ship has less than 33% health
											s = s .. "(heavy damage)"
										elseif camp.ShipHealth[element.name] < 66 then				--ship has less than 66% health
											s = s .. "(moderate damage)"
										elseif camp.ShipHealth[element.name] < 100 then				--ship has less than 100% health
											s = s .. "(light damage)"
										end
									end
									s = s .. "\n"
								end
							end
						end
						if target.lat and target.lon then
							local dms_string = " " ..Format_dms(target.lat, target.lon, 4)
							table.insert(entries[3].values, dms_string)
						end
						-- s = s .. "\n"
					end
				end
			end
		end


		local txt = writeWordsNicelyTidy(entries)

		s = s .. txt .. "\n"

		s = s .. "\n\n"																			--make a new line after each side
	end


	if camp["Briefing_text"] and not TaskRefused then
		local briefTemp = camp["Briefing_text"]
		mission.descriptionText =  briefTemp
	else
		mission.descriptionText = "\n"
	end

	mission.descriptionText = mission.descriptionText .. "\n" .. s

end


-- modification M11B. : Multiplayer
local briefing = {
				  ["blue"] = "",
					["red"] = "",
				  }

local briefPlaneTaskTarget = {}																			--evite la répétition des briefings surtout en MP

for sideName, packs in pairs(ATO) do																		--iterate through sides in ATO
	for p = 1, #packs do																					--iterate through packages in sides
		for _role,flight in pairs(packs[p]) do															--iterate through roles in package (main, SEAD, escort)		
			for f = 1, #flight do

				local value = flight[f].type..""..flight[f].task..""..flight[f].target_name
				local allowedBrief = false																--evite la répétition des briefings surtout en MP

				-- inheritedFrom 
				local inheritedType = flight[f].type
				if Data_divers and Data_divers[flight[f].type] and Data_divers[flight[f].type].inheritedFrom then
					inheritedType = Data_divers[flight[f].type].inheritedFrom
				end

				if PlayerFlight and (flight[f].player or flight[f].client)  then

					if not briefPlaneTaskTarget[value] then
						allowedBrief = true
					end

					briefPlaneTaskTarget[value] = true													--evite la répétition des briefings surtout en MP

					local tempPlayer = {}

					--CLIENT************************************************
					if flight[f].client then

						-- local camp_str = "camp.client = " .. TableSerialization(camp.client, 0)						--make a string
						-- local campFile = io.open("Debug/CAMPclientBriefingCC.lua", "w")	 or error("Failed to open debug file")
						-- campFile:write(camp_str)																		--save new data
						-- campFile:close()

						--attention, ne pas enlever Deepcopy ici
						tempPlayer = Deepcopy(camp.client[flight[f].IdClient])

						-- local camp_str = "camp.client = " .. TableSerialization(camp.client, 0)						--make a string
						-- local campFile = io.open("Debug/CAMPclientBriefingDD.lua", "w")	 or error("Failed to open debug file")
						-- campFile:write(camp_str)																		--save new data
						-- campFile:close()

						-- local camp_str = "tempPlayer = " .. TableSerialization(tempPlayer, 0)						--make a string
						-- local campFile = io.open("Debug/CAMP_tempPlayer_clientBriefingEE.lua", "w")	 or error("Failed to open debug file")
						-- campFile:write(camp_str)																		--save new data
						-- campFile:close()

						-- print("DcB tempPlayer.pack_n "..tostring(tempPlayer.pack_n))


						tempPlayer.package = {
							[tempPlayer.pack_n] = Deepcopy(camp.client.package[tempPlayer.pack_n]),
						}

						local tagBreak
						--##parse mission table:
						for _side, side in pairs(mission.coalition) do
							for countryN, country in pairs(side.country) do
								for category, groups in pairs(country) do
									if (category == "plane" or category == "helicopter" ) and type(groups) == "table" and groups["group"]  then	--and groups[1].units
										for Ngroup, group in pairs(groups["group"]) do
											for unitN, unit in pairs(group.units) do
												if unit.name == tempPlayer.unitname then

													--attention, ne PAS mettre Deepcopy ici, sinon les canaux de frequence ne pourront se mettre à jour
													tempPlayer["waypoints"] = group.route.points
													tempPlayer["group"] = group
													tagBreak = true
													break
												end

											end
											if tagBreak then break end
										end
									end
									if tagBreak then break end
								end
								if tagBreak then break end
							end
							if tagBreak then break end
						end


					--*** PLAYER ************************************************
					elseif flight[f].player then

						local camp_str = "camp.player = " .. TableSerialization(camp.player, 0)						--make a string
						local campFile = io.open("Debug/CAMP_PlayerBriefingAA.lua", "w")	 or error("Failed to open debug file")
						campFile:write(camp_str)																		--save new data
						campFile:close()

						--attention, ne pas enlever Deepcopy ici
						tempPlayer = Deepcopy(camp.player)

						tempPlayer.package = {
							[tempPlayer.pack_n] = Deepcopy(camp.player.package[tempPlayer.pack_n]),
						}

						local camp_str = "tempPlayer = " .. TableSerialization(tempPlayer, 0)						--make a string
						local campFile = io.open("Debug/CAMPtempPlayerBriefingDD.lua", "w")	 or error("Failed to open debug file")
						campFile:write(camp_str)																		--save new data
						campFile:close()

						local tagBreak
						--##parse mission table:
						for _side, side in pairs(mission.coalition) do
							for countryN, country in pairs(side.country) do
								for category, groups in pairs(country) do
									if (category == "plane" or category == "helicopter" ) and type(groups) == "table" and groups["group"]  then	--and groups[1].units
										for Ngroup, group in pairs(groups["group"]) do
											for unitN, unit in pairs(group.units) do

												if unit.name == tempPlayer.unitname then

													--attention, ne PAS mettre Deepcopy ici, sinon les canaux de frequence ne pourront se mettre à jour
													tempPlayer["waypoints"] = group.route.points
													tempPlayer["group"] = group
													tagBreak = true
													break
												end

											end
											if tagBreak then break end
										end
									end
									if tagBreak then break end
								end
								if tagBreak then break end
							end
							if tagBreak then break end
						end
					end

					local s =""

					--ajoute air tasking Order seulement pour les joueurs solo
					-- if Multi.NbGroup <= 1 then
					if nbPasse < 1 then
						--*****Air Tasking Order******--

						s = "Air Tasking Order:\n"

						--define list entries
						local entries = {
							[1] = {
								header = "Sorties",
								values = {},
							},
							[2] = {
								header = "Type(main)",
								values = {},
							},
							[3] = {
								header = "Mission",
								values = {},
							},
							[4] = {
								header = "TOT",
								values = {},
							},
						}

						--sum together packages package sortie numbers
						local ATOList = {}
						for pack_n,pack in pairs(ATO[tempPlayer.side]) do												--go through ATO on player side

							--package time on target
							local tot = FormatTime(camp.time + pack.main[1].route[1].eta, "hh:mm:ss")				--time on target (use first wapoint if no Target or Station WP is found below)
							for wp_n,wp in pairs(pack.main[1].route) do												--iterate through waypoints of first main flight
								if wp.id == "Target" or wp.id == "Station" then										--if wp is target or station
									tot = FormatTime(camp.time + wp.eta, "hh:mm:ss")								--make this the time on target			
								end
							end

							--package sortie number
							local sortie_n = 0																		--number of aircraft (sorties) in package
							for role,flight in pairs(pack) do														--iterate through roles in package
								for n = 1, #flight do																--iterate through flights in role
									sortie_n = sortie_n + flight[n].number											--count number of aircraft
								end
							end

							if #ATOList == 0 then																	--ATOList is still empty
								ATOList[#ATOList + 1] = {
									target_name = pack.main[1].target_name,
									sortie_n = sortie_n,
									tot = tot,
									type = ReplaceTypeName(pack.main[1].type),
								}
							else																					--ATOList has content
								for a = 1, #ATOList do																--go through ATOList to see if there is already a package entered with same target
									if pack.main[1].target_name == ATOList[a].target_name then						--find packages with same target to combine them 
										ATOList[a].sortie_n = ATOList[a].sortie_n + sortie_n
										break
									end
									if a == #ATOList then															--no package with same target was found in ATOList
										ATOList[#ATOList + 1] = {
											target_name = pack.main[1].target_name,
											sortie_n = sortie_n,
											tot = tot,
											type = ReplaceTypeName(pack.main[1].type),
										}
									end
								end
							end
						end

						--add list values
						for pack_n,pack in pairs(ATOList) do														--iterate through packages
							table.insert(entries[1].values, pack.sortie_n)											--number of sorties in package
							table.insert(entries[2].values, pack.type)
							table.insert(entries[3].values, pack.target_name)										--package target
							table.insert(entries[4].values, pack.tot)												--package time on target
						end

						--determine maximum string length for each entry
						for e = 1, #entries do																		--iterate through entries
							entries[e].str_length = string.len(entries[e].header) + 1									--store string length of header for this entry
							for n = 1, #entries[e].values do														--iterate through values of this entry
								local l = string.len(tostring(entries[e].values[n])) + 1 								--get string length of value of this entry
								if l > entries[e].str_length then													--if the string length is larger than the previous
									entries[e].str_length = l														--make it the new length (find the largest)
								end
							end
						end

						--build the list header
						for e = 1, #entries do																		--iterate through entries
							s = s .. entries[e].header																--add header
							if e < #entries then																	--if this is not the last header, add spaces to the next header	
								local space = entries[e].str_length + 0 - string.len(entries[e].header)				--calculate number of spaces that need to be added for alignement (string length of largest entry of same type + 3 - length of current entry = number of spaces)
								for m = 1, space * 1.0 do
									s = s .. " "																	--add 1.5 spaces for every missing letter
								end
							end
						end
						s = s .. "\n"

						--build the list		
						for n = 1, #entries[1].values do															--iterate through number of values (number of units)
							for e = 1, #entries do																	--iterate through entries
								s = s .. tostring(entries[e].values[n])														--add value to list
								if e < #entries then																--if this is not the last header, add spaces to the next header	
									local space = entries[e].str_length + 0 - string.len(tostring(entries[e].values[n]))	--calculate number of spaces that need to be added for alignement (string length of largest entry of same type + 3 - length of current entry = number of spaces)
									for m = 1, space * 1.0 do
										s = s .. " "																--add 1.5 spaces for every missing letter
									end
								end
							end
							s = s .. "\n"																			--make a new line after each unit
						end
						nbPasse = nbPasse + 1
					end
					--Assign briefing text to mission file
					mission.descriptionText = mission.descriptionText .. s

					if allowedBrief then briefing[sideName] = briefing[sideName] .. s .. "\n\n" s="" end



					----- ******Task Briefing ******-----

					--recupere les units des instruments de l'avion
					local unitsUse = mission_ini.units
					-- print("DcB type "..tostring (tempPlayer.pack[tempPlayer.role][tempPlayer.flight].type))
					-- if Data_divers and Data_divers[tempPlayer.pack[tempPlayer.role][tempPlayer.flight].type] then
					-- 	if Data_divers[tempPlayer.pack[tempPlayer.role][tempPlayer.flight].type].instrumentUnits then
					-- 		if Data_divers[tempPlayer.pack[tempPlayer.role][tempPlayer.flight].type].instrumentUnits ~= nil then
					-- 			unitsUse = Data_divers[tempPlayer.pack[tempPlayer.role][tempPlayer.flight].type].instrumentUnits
					-- 		end
					-- 	end
					-- end
					if Data_divers and Data_divers[tempPlayer.type] then
						if Data_divers[tempPlayer.type].instrumentUnits then
							unitsUse = Data_divers[tempPlayer.type].instrumentUnits

						end
					end


					--Mission overview					
					-- local squad = tempPlayer.pack[tempPlayer.role][tempPlayer.flight].name
					-- local target_name = tempPlayer.pack[tempPlayer.role][tempPlayer.flight].target_name									--get the target of the player flight
					-- local player_task = tempPlayer.pack[tempPlayer.role][tempPlayer.flight].task											--get the task of the player flight
					-- local target = tempPlayer.pack[tempPlayer.role][tempPlayer.flight].target											--get target table
					local squad = tempPlayer.squadName
					local target_name = tempPlayer.target.titleName									--get the target of the player flight
					local player_task = tempPlayer.task											--get the task of the player flight
					local target = tempPlayer.target											--get target table
					local time_start = FormatTime(camp.time + tempPlayer.waypoints[1].ETA, "hh:mm")								--player spawn time
					local time_launch

					s = "\n\n\n\n".."\n"
					local sBrief = "_________________________________________ BRIEFING Part: _______________________________________\n"
					s = s..sBrief
					local sName = " "..tostring(flight[f].type).." "..squad.." "..player_task.." "
					local space = string.len(tostring(sBrief)) - string.len(tostring(sName))									--calculate number of spaces that need 
					for n = 1, (space / 2)-1  do
						s = s .. "_"
					end
					s = s..sName
					for n = 1, (space / 2)-1  do
						s = s .. "_"
					end
					s = s.."\n"
					s = s.."________________________________________________________________________________________________\n"
					s = s.."\n"

					if tempPlayer.target.picture  then
						if  type(tempPlayer.target.picture) == "table" and tempPlayer.target.picture[1]  ~= "" then
							if not target_picture[sideName] then target_picture[sideName] = {} end
							target_picture[sideName] = tempPlayer.target.picture						--get the target picture M05
						elseif  type(tempPlayer.target.picture) ~= "table" and tempPlayer.target.picture  ~= "" then
							if not target_picture[sideName] then target_picture[sideName] = {} end
							target_picture[sideName] = tempPlayer.target.picture						--get the target picture M05
						end
					end

					if tempPlayer.waypoints[2] then
						time_launch = FormatTime(camp.time + tempPlayer.waypoints[2].ETA , "hh:mm")								--player take off time
					end

					local time_target = FormatTime(camp.time + tempPlayer.waypoints[tempPlayer.tgt_wp].ETA, "hh:mm")					--player time on target

					--CAP
					if player_task == "CAP" then
						local time_station = FormatTime(camp.time + tempPlayer.waypoints[tempPlayer.tgt_wp + 1].ETA, "hh:mm")			--player time to leave stations (for CAP, AWACS and Refueling)
						s = s .. "You are tasked to perform a Combat Air Patrol " .. target.text .. " from " .. time_target .. " to " .. time_station .. ". Engage all hostile aircraft threatening friendly forces in your CAP area.\n"

					--Intercept
					elseif player_task == "Intercept" then

						local airbase = tempPlayer.airbase

						if tempPlayer.tgt_pack then	 --ATO[tempPlayer.tgt_side][tempPlayer.tgt_pack]

							local tgt_heading = GetHeading(tempPlayer.waypoints[1], ATO[tempPlayer.tgt_side][tempPlayer.tgt_pack].main[1].route[1])
							local tgt_distance = GetDistance(tempPlayer.waypoints[1], ATO[tempPlayer.tgt_side][tempPlayer.tgt_pack].main[1].route[1])
							local tgt_n = 0
							for role, flight in pairs (ATO[tempPlayer.tgt_side][tempPlayer.tgt_pack]) do
								for n = 1, #flight do
									tgt_n = tgt_n + flight[n].number
								end
							end
							if tgt_n == 1 then
								s = s .. "You are assigned to ground alert intercept duty at " .. ReplaceBaseName(airbase) .. ". Early warning radar has detected " .. tgt_n .. " target inbound to your sector at " .. math.floor(tgt_heading) .. "°/" .. FormatDistance(tgt_distance, unitsUse) .. ". Launch imediately for interception.\n"
							else
								s = s .. "You are assigned to ground alert intercept duty at " .. ReplaceBaseName(airbase) .. ". Early warning radar has detected " .. tgt_n .. " targets inbound to your sector at " .. math.floor(tgt_heading) .. "°/" .. FormatDistance(tgt_distance, unitsUse) .. ". Launch imediately for interception.\n"
							end
					else
							s = s .. "You are assigned to ground alert intercept duty at " .. ReplaceBaseName(airbase) .. " Wait for the GCI to scramble you..."

					end
					--Fighter Sweep
					elseif player_task == "Fighter Sweep" then
						s = s .. "You are tasked to perform a Fighter Sweep " .. target.text .. ". Your Time On Target is " .. time_target .. ".\n"

					--Airbase Strike
					elseif player_task == "Strike" and target.class == "airbase" then
						s = s .. "You are tasked to strike " .. target.name .. " which hosts the " .. target.unit.name .. " equipped with " .. ReplaceTypeName(target.unit.type) .. ". Attack any parked aircraft on the airbase. Your Time On Target is " .. time_target .. "."
						if target.LaserCode then
							s = s .. " Target designation laser code " .. target.LaserCode .. "."
						end
						s = s .. "\n"

					--Strike
					elseif player_task == "Strike" then
						s = s .. "You are tasked to strike " .. target_name .. " with a Time On Target of " .. time_target .. "."
						if target.LaserCode then
							s = s .. " Target designation laser code " .. target.LaserCode .. "."
						end
						s = s .. "\n"

					--Anti-ship Strike
					elseif player_task == "Anti-ship Strike" then
						s = s .. "You are tasked to strike " .. target_name .. " with a Time On Target of " .. time_target .. "."
						if target.LaserCode then
							s = s .. " Target designation laser code " .. target.LaserCode .. "."
						end
						s = s .. "\n"

					--Escort
					elseif player_task == "Escort" then
						if target.class == "airbase" then
							s = s .. "Escort a strike mission against " .. ReplaceBaseName(target.name) .. ". Engage all hostile aircraft posing a threat to the strike package. "
							--s = s .. "Man your aircraft at " .. time_start .. " and prepare to launch at " .. time_launch .. ". Your Time on Target is " .. time_target .. ". Good Luck."
						elseif target.task == "Strike" or target.task == "Anti-ship Strike" then
							s = s .. "Escort a strike mission against the " .. target_name .. ". Engage all hostile aircraft posing a threat to the strike package. "
							--s = s .. "Man your aircraft at " .. time_start .. " and prepare to launch at " .. time_launch .. ". Your Time on Target is " .. time_target .. ". Good Luck."
						elseif target.task == "Reconnaissance" then
							s = s .. "Escort a recon mission " .. target.text .. ". Engage all hostile aircraft posing a threat to the recon element. "
							--s = s .. "Man your aircraft at " .. time_start .. " and prepare to launch at " .. time_launch .. ". Your Time on Target is " .. time_target .. ". Good Luck."
						end
						s = s .. "\n"

					--SEAD
					elseif player_task == "SEAD" then
						if target.class == "airbase" then
							s = s .. "Provide SEAD escort for a strike mission against " .. target.name .. ". Engage all hostile air defense systems posing a threat to the strike package. "
							--s = s .. "Man your aircraft at " .. time_start .. " and prepare to launch at " .. time_launch .. ". Your Time on Target is " .. time_target .. ". Good Luck."
						elseif target.task == "Strike" or target.task == "Anti-ship Strike" then
							s = s .. "Provide SEAD escort for a strike mission against the " .. target_name .. ". Engage all hostile air defense systems posing a threat to the strike package. "
							--s = s .. "Man your aircraft at " .. time_start .. " and prepare to launch at " .. time_launch .. ". Your Time on Target is " .. time_target .. ". Good Luck."
						elseif target.task == "Reconnaissance" then
							s = s .. "Provide SEAD escort for a recon mission " .. target.text .. ". Engage all hostile air defense systems posing a threat to the recon element. "
							--s = s .. "Man your aircraft at " .. time_start .. " and prepare to launch at " .. time_launch .. ". Your Time on Target is " .. time_target .. ". Good Luck."
						end
						s = s .. "\n"

					--Escort Jammer
					elseif player_task == "Escort Jammer" then
						if target.class == "airbase" then
							s = s .. "Provide jammer escort for a strike mission against " .. target.name .. ". "
							--s = s .. "Man your aircraft at " .. time_start .. " and prepare to launch at " .. time_launch .. ". Your Time on Target is " .. time_target .. ". Good Luck."
						elseif target.task == "Strike" or target.task == "Anti-ship Strike" then
							s = s .. "Provide jammer escort for a strike mission against the " .. target_name .. ". "
							--s = s .. "Man your aircraft at " .. time_start .. " and prepare to launch at " .. time_launch .. ". Your Time on Target is " .. time_target .. ". Good Luck."
						elseif target.task == "Reconnaissance" then
							s = s .. "Provide jammer escort for a recon mission " .. target.text .. ". "
							--s = s .. "Man your aircraft at " .. time_start .. " and prepare to launch at " .. time_launch .. ". Your Time on Target is " .. time_target .. ". Good Luck."
						end
						s = s .. "\n"

					--Flare Illumination
					elseif player_task == "Flare Illumination" then
						if target.class == "airbase" then
							s = s .. "Provide battlefield flare illumination for a strike mission against " .. target.name .. ". "
							--s = s .. "Man your aircraft at " .. time_start .. " and prepare to launch at " .. time_launch .. ". Your Time on Target is " .. time_target .. ". Good Luck."
						elseif target.task == "Strike" or target.task == "Anti-ship Strike" then
							s = s .. "Provide battlefield flare illumination for a strike mission against the " .. target_name .. ". "
							--s = s .. "Man your aircraft at " .. time_start .. " and prepare to launch at " .. time_launch .. ". Your Time on Target is " .. time_target .. ". Good Luck."
						elseif target.task == "Reconnaissance" then
							s = s .. "Provide battlefield flare illumination for a recon mission " .. target.text .. ". "
							--s = s .. "Man your aircraft at " .. time_start .. " and prepare to launch at " .. time_launch .. ". Your Time on Target is " .. time_target .. ". Good Luck."
						end
						s = s .. "\n"

					--Laser Illumination
					elseif player_task == "Laser Illumination" then
						if target.class == "airbase" then
							s = s .. "Provide target laser designation for a strike mission against " .. target.name .. ". "
							s = s .. "Set your laser designator to code " .. target.LaserCode .. ". "
							--s = s .. "Man your aircraft at " .. time_start .. " and prepare to launch at " .. time_launch .. ". Your Time on Target is " .. time_target .. ". Good Luck."
						elseif target.task == "Strike" or target.task == "Anti-ship Strike" then
							s = s .. "Provide target laser designation for a strike mission against the " .. target_name .. ". "
							s = s .. "Set your laser designator to code " .. target.LaserCode .. ". "
							--s = s .. "Man your aircraft at " .. time_start .. " and prepare to launch at " .. time_launch .. ". Your Time on Target is " .. time_target .. ". Good Luck."
						elseif target.task == "Reconnaissance" then
							s = s .. "Provide target laser designation for a recon mission " .. target.text .. ". "
							s = s .. "Set your laser designator to code " .. target.LaserCode .. ". "
							--s = s .. "Man your aircraft at " .. time_start .. " and prepare to launch at " .. time_launch .. ". Your Time on Target is " .. time_target .. ". Good Luck."
						end
						s = s .. "\n"

					--Reconnaissance
					elseif player_task == "Reconnaissance" then
						s = s .. "You are tasked to perform reconnaissance " .. target.text .. ". Your Time On Target is " .. time_target .. ".\n"

					--AWACS
					elseif player_task == "AWACS" then
						local time_station = FormatTime(camp.time + tempPlayer.waypoints[tempPlayer.tgt_wp + 1].ETA, "hh:mm")		--player time to leave stations (for CAP, AWACS and Refueling)
						s = s .. "You are tasked to perform a AWACS patrol " .. target.text .. " from " .. time_target .. " to " .. time_station .. ".\n"

					--Refueling
					elseif player_task == "Refueling" then
						local time_station = FormatTime(camp.time + tempPlayer.waypoints[tempPlayer.tgt_wp + 1].ETA, "hh:mm")		--player time to leave stations (for CAP, AWACS and Refueling)
						s = s .. "You are tasked to perform tanker support " .. target.text .. " from " .. time_target .. " to " .. time_station .. ". Provide fuel to friendly aircraft in your patrol area.\n"

					--Transport
					elseif player_task == "Transport" then
						s = s .. "Fly a transport mission from " .. target.base .. " to " .. target.destination .. ".\n"

					--Nothing/Ferry
					elseif player_task == "Nothing" then
						s = s .. "Ferry flight from " .. target.base .. " to " .. target.destination .. ".\n"
					--SAR
					elseif player_task == "SAR" then
						local airbase = tempPlayer.airbase
						s = s .. "You are assigned to ground alert SAR duty at " .. airbase ..  ".\n"
					--CSAR
					elseif player_task == "CSAR" then
						s = s .. "You are tasked to Search and Rescue " .. target_name  ..  ".\n"

					end

					if (player_task == "Strike" or player_task == "Anti-ship Strike") then
						for targetN, target in ipairs(targetlist[tempPlayer.side]) do
							local precisionGPS = 8
							local attributMaster = ""
							if target.attributes then
								for attributN, attribut in pairs(target.attributes) do
									if string.lower(attribut) == "soft" or string.lower(attribut) == "static" then
										precisionGPS = 4
										attributMaster = "soft"
									end
								end
							end
							if attributMaster == "" and target.class and target.class == "static" then

								precisionGPS = 4
								attributMaster = "soft"

							end

							if target.titleName == target_name and target.elements  then									--if the target is a scenery, vehicle or ship target
								s = s .. "\nTarget:\n" .. target_name .. " (" .. math.ceil(target.alive) .. "%)"		--\n --Target name and percentage of alive sub-elements 

								if target.lat and target.lon then
									local dms_string = " " .. Format_dms(target.lat, target.lon, 4)
									s = s .. dms_string
								end

								s = s .. "\n"

								for elementN, element in pairs(target.elements) do						--list all target elements
									local ename = element.name			--element name
									local i = string.find(ename, "#")													--position of # in string
									if i then
										if element.type then
											ename = element.type
										else
											ename = string.sub(ename, 0, i - 1) 											--only display part of element name before #
										end
									end
									s = s .. "- " .. ename
									if element.dead == true then			--if the target element is destroyed
										s = s .. " (destroyed)\n"														--mark as destroyed and make new line
									else
										if element.lat and element.lon and attributMaster ~= "soft"  then

											local dms_string =  " " ..Format_dms(element.lat, element.lon, precisionGPS)

											s = s ..dms_string

										end
										s = s .. "\n"																	--make new line
									end
								end
							end
						end
					end
					-- modification M11B. : Multiplayer--briefing pour chaque camp 16 X briefing[sideName]
					if allowedBrief then briefing[sideName] = briefing[sideName] .. s .. "\n\n" s="" end									--add mission overview string to briefing string



					--Package overview ********************************************************************
					s = "Package:\n"																		--make a list of the details of all flights in the player package

					local entries = {																			--list entries that are making up the package overview
						[1] = {
							lookup = "task",																	--lookup in the ATO flight table
							header = "Task",																	--name which should be displayer in the list header
							str_length = 4,																		--string length of largest entry of this type (default the string length of the header)
						},
						[2] = {
							lookup = "number",
							header = "Num",
							str_length = 3,
						},
						[3] = {
							lookup = "type",
							header = "Type",
							str_length = 4,
						},
						[4] = {
							lookup = "base",
							header = "Base",
							str_length = 4,
						},
						[5] = {
							lookup = "callsign",
							header = "Callsign",
							str_length = 8,
						},
						[6] = {
							lookup = "player",
							header = "",
							str_length = 0,
						},
					}

					--collect the maximum string length of each entry in the list
					for role_name,role in pairs(tempPlayer.package[tempPlayer.pack_n]) do											--iterate through roles in the player package
						for flight_n,flight2 in pairs(role) do													--iterate through the flights in all roles
							for e = 1, #entries do																--iterate through all entries
								local value = ReplaceTypeName(flight2[entries[e].lookup])
								value = ReplaceBaseName(flight2[entries[e].lookup])
								local l = string.len(tostring(value))	 + 3										--get the string length of the current entry for this flight
								if l > entries[e].str_length then												--if the string length is larger than the previous
									entries[e].str_length = l													--make it the new length (find the largest)
								end
							end
						end
					end

					--build the list header
					for e = 1, #entries do																		--iterate through all entries
						s = s .. entries[e].header																--add entry of this flight to list
						if e ~= #entries then																	--if this is not the last entry of the flight, add spaces to the next entry	
							local space = entries[e].str_length + 0 - string.len(tostring(entries[e].header))	--calculate number of spaces that need to be added for alignement (string length of largest entry of same type + 3 - length of current entry = number of spaces)
							for n = 1, space * 1.0 do
								s = s .. " "																	--add 1.5 spaces for every missing letter
							end
						end
					end
					s = s .. "\n"

					--build the overview list with the entries of all flights
					for role_name,role in pairs(tempPlayer.package[tempPlayer.pack_n]) do											--iterate through roles in the player package	
						for flight_n,flight2 in pairs(role) do													--iterate through flights in all roles
							for e = 1, #entries do																--iterate through all entries
								if type(flight2[entries[e].lookup]) == "string" or type(flight2[entries[e].lookup]) == "number" then	--entry is a string or number
									local value = ReplaceTypeName(flight2[entries[e].lookup])
									s = s .. value																--add entry of this flight to list
									if e ~= #entries then																			--if this is not the last entry of the flight, add spaces to the next entry	
										local space = entries[e].str_length + 0 - string.len(tostring(value))	--calculate number of spaces that need to be added for alignement (string length of largest entry of same type + 3 - length of current entry = number of spaces)
										for n = 1, space * 1.0 do
											s = s .. " "														--add 1.5 spaces for every missing letter
										end
									end
								elseif flight2[entries[e].lookup] then											--entry is true (player marking)
									local client = ""
									if flight[f].player then client = "player" end
									if flight[f].client then client = "client" end
									s = s .. "("..client..")"															--add player flight marking
								end
							end
							s = s .. "\n"																		--make a new line after each flight
						end
					end

					if allowedBrief then briefing[sideName] = briefing[sideName] .. s .. "\n\n" s="" end													--add package overview string to briefing string

					--Flight overview*********************************************************************

					s = "Flight:\n"																		--make a list of the details of all flights in the player package
					s = s.."CallSign    Designated aircraft number \n"

					for role_name,role in pairs(tempPlayer.package[tempPlayer.pack_n]) do												--iterate through roles in the player package	
						for flight_n,_flight in pairs(role) do													--iterate through flights in all roles
							if _flight.units	 then
								for u=1 , #_flight.units do
									if type(_flight.units[u].callsign) == "table" then
										s = s.. tostring(_flight.units[u].callsign.name).."       "..tostring(_flight.units[u].onboard_num).. "\n"
									else
										s = s.. tostring(_flight.units[u].callsign) .."       "..tostring(_flight.units[u].onboard_num).. "\n"
									end
								end
							end
						end
					end
					if allowedBrief then briefing[sideName] = briefing[sideName] .. s .. "\n\n" s="" end




					-- modification M27 	movedBullseye
					if Brief[sideName] then
						if Brief[sideName].bullseye then
							s = "Bullseye:\n"
							s = s.." bullseye Name " .. ReplaceBaseName(Brief[sideName].bullseye.name)
							if Brief[sideName]["bullseye"].lat then
								s = s.." " .. Format_dms(Brief[sideName]["bullseye"].lat ,Brief[sideName]["bullseye"].lon ,4)  .." \n"
							end
							s = s.." \n"
							if allowedBrief then  briefing[sideName] = briefing[sideName] .. s .. "\n\n" s="" end
						else
							print("\r\n ***ATTENTION***.")
							print("You need to add the bulleyes parameters to your map, in the conf_mod, in the “movedBullseye” table.")
							os.execute 'pause'
						end
					end

					if player_task ~= "Intercept" and  player_task ~= "SAR" then
						--Navigation overview
						s = "Flightplan:\n"																	--make a list with details of the player waypoints

						entries = {																			--list entries that are making up the navigaion overview
							[1] = {
								lookup = "number",																	--lookup in the player.waypoints table
								header = "WP",																		--name which should be displayer in the list header
								str_length = 2,																		--string length of largest entry of this type (default the string length of the header)
							},
							[2] = {
								lookup = "briefing_name",
								header = "Descr",
								str_length = 5,
							},
							[3] = {
								lookup = "alt",
								header = "Altitute",
								str_length = 8,
							},
							[4] = {
								lookup = "speed",
								header = "Speed",
								str_length = 5,
							},
							[5] = {
								lookup = "ETA",																		-- M58 flight plan, heading, Dist, ETE
								header = "ETA",
								str_length = 3,
							},
							[6] = {
								lookup = "name",
								header = "    Cap   /   Dist   /   ETE  ",
								str_length = 28,
							},
						}

						--collect the maximum string length of each entry in the list	
						for w = 1, #tempPlayer.waypoints do														--iterate through the waypoints
							for e = 1, #entries do																	--iterate through all entries
								local entry																			--lookup of entry e of WP w
								if entries[e].lookup == "number" then
									entry = w - 1																	--waypoint number, starts with 0
								elseif entries[e].lookup == "ETA" then
									entry = FormatTime(camp.time + tempPlayer.waypoints[w][entries[e].lookup], "hh:mm:ss")	--format the time in the hh:mm:ss format
								elseif entries[e].lookup == "alt" then
									entry = FormatAlt(tempPlayer.waypoints[w][entries[e].lookup], unitsUse)					--format altitude in meters or feet
								elseif entries[e].lookup == "speed" then
									entry = FormatSpeed(tempPlayer.waypoints[w][entries[e].lookup], unitsUse)				--format speed in kph or kts
								else
									entry = tempPlayer.waypoints[w][entries[e].lookup]								--no special formating
								end
								local l = string.len(tostring(entry)) + 3 												--get the string length
								if l > entries[e].str_length then													--if the string length is larger than the previous
									entries[e].str_length = l														--make it the new length (find the largest)
								end
							end
						end

						--build the list header
						for e = 1, #entries do																		--iterate through all entries
							s = s .. entries[e].header																--add entry of this waypoint to list
							if e ~= #entries then																	--if this is not the last entry of the waypoints, add spaces to the next entry	
								local space = entries[e].str_length + 0 - string.len(tostring(entries[e].header))	--calculate number of spaces that need to be added for alignement (string length of largest entry of same type + 3 - length of current entry = number of spaces)
								for n = 1, space * 1.0 do
									s = s .. " "																	--add 1.5 spaces for every missing letter
								end
							end
						end
						s = s .. "\n"

						--build the overview list with the entries of all waypoints
						local WP_num = 0																			--waypoint number, starts with 0
						for w = 1, #tempPlayer.waypoints do														--iterate through all waypoints

							if tempPlayer.waypoints[w].briefing_name ~= "Taxi" then								--do not list taxi waypoint in overview
								for e = 1, #entries do																--iterate through all entries
									local entry
									if entries[e].lookup == "number" then
										entry = WP_num
										WP_num = WP_num + 1
									elseif entries[e].lookup == "ETA" then
										local modifiefDepartureETA = 0
										if tempPlayer.waypoints[w].briefing_name == "Departure" then
											modifiefDepartureETA = tempPlayer.waypoints[w].ETA + mission_ini.startup_time_player
										end
										
										-- entry = FormatTime(camp.time + tempPlayer.waypoints[w][entries[e].lookup], "hh:mm:ss")	--format the time in the hh:mm:ss format
										entry = FormatTime(camp.time + tempPlayer.waypoints[w][entries[e].lookup] + modifiefDepartureETA, "hh:mm")	--format the time in the hh:mm:ss format
									elseif entries[e].lookup == "alt" then
										entry = FormatAlt(tempPlayer.waypoints[w][entries[e].lookup], unitsUse)				--format altitude in meters or feet
									elseif entries[e].lookup == "speed" then
										entry = FormatSpeed(tempPlayer.waypoints[w][entries[e].lookup], unitsUse)			--format speed in kph or kts
									else
										entry = tempPlayer.waypoints[w][entries[e].lookup]							--no special formating
									end
									s = s .. tostring(entry)
									if e ~= #entries then															--if this is not the last entry of the waypoint, add spaces to the next entry	
										local space = entries[e].str_length + 0 - string.len(tostring(entry))		--calculate number of spaces that need to be added for alignement (string length of largest entry of same type + 3 - length of current entry = number of spaces)
										for n = 1, space * 1.0 do
											s = s .. " "															--add 1.5 spaces for every missing letter
										end
									end
								end
								s = s .. "\n"																		--make a new line after each waypoint
							end
						end
						-- M58 flight plan, heading, Dist, ETE
						if tempPlayer.waypoints[#tempPlayer.waypoints].briefing_name == "Land" and tempPlayer.waypoints[#tempPlayer.waypoints]["TotFlightDist"]then
							s = s.. "\n"
							s = s .. "                                                           TOTAL   "..tempPlayer.waypoints[#tempPlayer.waypoints]["TotFlightDist"] .." / "..tempPlayer.waypoints[#tempPlayer.waypoints]["TotFlightTime"] .. "\n"

						end
					end

					if allowedBrief then briefing[sideName] = briefing[sideName] .. s .. "\n\n"	s="" end													--add navigation overview string to briefing string


					local refuelable = true
					--flight[f].helicopter
					for side_name,side in pairs(oob_air) do
						for n,unit in pairs(side) do
							if unit.name == tempPlayer.unitname and (unit.helicopter or unit.refuelable == false)  then
								refuelable = false
							end
						end
					end

					--Radio navigation

					s = "Radio Navigation:\n"
					s = s .."Base: ".. ReplaceBaseName(tempPlayer.airbase)
					--homebase TACAN
					if db_airbases[tempPlayer.airbase].TACAN then
						s = s .. " TACAN: " .. db_airbases[tempPlayer.airbase].TACAN
					end
					if db_airbases[tempPlayer.airbase].tacan then
						s = s .. " TACAN: " .. db_airbases[tempPlayer.airbase].tacan
					end
					if db_airbases[tempPlayer.airbase].VOR then										--M33.d02
						s = s .. " VOR: " .. db_airbases[tempPlayer.airbase].VOR
					end
					if db_airbases[tempPlayer.airbase].NDB then
						s = s .. " NDB: " .. db_airbases[tempPlayer.airbase].NDB
					end
					if db_airbases[tempPlayer.airbase].ILS then
						s = s .. " ILS: " .. db_airbases[tempPlayer.airbase].ILS
					end
					--carrier ICLS
					if db_airbases[tempPlayer.airbase].icls then
						s = s .. " ICLS: Channel " .. db_airbases[tempPlayer.airbase].icls
					end
					s = s .. "\n"

					--Divert BASE	M33.d				
					if TabDivert[tempPlayer.pack_n] then
						for Divert, _base in pairs(TabDivert[tempPlayer.pack_n]) do
							if Divert ~= tempPlayer.unitname then
								s = s .."Divert: ".. ReplaceBaseName(_base)
								--Divert TACAN
								if db_airbases[_base].TACAN then
									s = s .. " TACAN: " .. db_airbases[_base].TACAN
								end
								--Divert TACAN
								if db_airbases[_base].tacan then
									s = s .. " TACAN: " .. db_airbases[_base].tacan
								end
								--Divert VOR
								if db_airbases[_base].VOR then
									s = s .. " VOR: " .. db_airbases[_base].VOR
								end
								--Divert NDB
								if db_airbases[_base].NDB then
									s = s.. " NDB: " .. db_airbases[_base].NDB
								end
								--Divert ILS
								if db_airbases[_base].ILS then
									s = s.. " ILS: " .. db_airbases[_base].ILS
								end
								--Divert ils
								if db_airbases[_base].ils then
									s = s.. " ILS: " .. db_airbases[_base].ils
								end
								--Divert icls
								if db_airbases[_base].icls then
									s = s.. " ICLS: Channel " .. db_airbases[_base].icls
								end
								s = s.. "\n"
							end
						end
					end

					--tanker TACAN
					local tanker_TACAN = {}
					if refuelable then
						for pack_n,pack in pairs(ATO[tempPlayer.side]) do																		--iterate through packages in player side
							for role_name, roles in pairs(pack) do																				--iterate through roles in package
								for n, role in pairs(roles) do	
									if role and role.task == "Refueling" then																	--if first flight is tanker
										if role.tacan then																						--tanker has a tacan channel
											s = s .. "Tanker " .. role.callsign .. ", TACAN " .. role.tacan .. "Y "..tostring(role.target.text).."\n"					--add TACAN informaion									
											tanker_TACAN[role.callsign] = role.tacan .. "Y"
										end
									end
								end
							end
						end
					end
					if allowedBrief then briefing[sideName] = briefing[sideName] .. s ..  "\n\n" s="" end


					--Communication
					s = "Communication:\n"																		--overview of relevant comms frequencies
					local MC = 0
					-- if  flight[f].type == "MiG-21Bis" or flight[f].type == "Mi-8MT" or flight[f].type == "Mi-24P"  then			-- add Mig21 Mi-8 Mi-24 Channel 00
						-- MC = -1										-- MC ModChannel
					-- end

					for u = 1, #tempPlayer.group["units"] do
						for n = 1, #camp.radio[sideName] do																		--do it for all the radios
							if 	frequency[inheritedType] then
								for ir=1, #frequency[inheritedType].radio do
									if frequency[inheritedType].radio[ir].nbCanal > 0 then
										if not tempPlayer.group["units"][u]["Radio"] then tempPlayer.group["units"][u]["Radio"] = {} end

										tempPlayer.group["units"][u]["Radio"][ir] = {
											["channels"] = {},
										}
									end
								end
							end
						end
					end

					local AWACS_freq = {}
					local AFAC_freq = {}																				--table to store AWACS frequencies
					local tanker_freq = {}																				--table to store tanker frequencies
					local EWR_freq = {}																					--table to store EWR frequencies
					local EWR_freqT = {}
					local CAP_freq = {}
					local ATC_Divert_freq = {}
					local All_freq = {}

					for pack_n,pack in pairs(ATO[tempPlayer.side]) do														--iterate through packages in player side
						for role_name,role in pairs(pack) do															--iterate through roles in package													--iterate through the flights in role
							if role[1] and role[1].task == "AWACS" then													--if first flight is AWACS
								for f = 1 , #role do
									local time = ""
									local occurence = 0

									for w , wpt in ipairs(role[f].route) do
										if wpt.id == "Station" and occurence == 0 then
											time = FormatTime(camp.time + wpt.eta, "hh:mm")
											occurence = occurence + 1
										elseif wpt.id == "Station" and occurence == 1 then
											time = time .. " "..FormatTime(camp.time + wpt.eta, "hh:mm")
											occurence = occurence + 1
										end
									end

									local tabElement = {
										['callsign'] = role[f].callsign,
										['freq'] = role[f].frequency,																	--store callsign and frequency
										['type'] = role[f].type,
										['time'] = time,
										['flight'] = f,
									}
									table.insert(AWACS_freq, tabElement)
								end
							elseif role[1] and role[1].task == "Refueling" then											--if first flight is tanker

								if Data_divers[tempPlayer.type] and Data_divers[tempPlayer.type].refuellingReceptacleType then

									-- print("DcB A1 role[f].type: "..tostring(role[f].type).." "..tostring(Data_divers[role[f].type].refuellingType))

									-- print("DcB A2 tempPlayer.type: "..tostring(tempPlayer.type).." "..tostring(Data_divers[tempPlayer.type].refuellingReceptacleType))
									

									if Data_divers[role[1].type] and Data_divers[role[1].type].refuellingType and
										Data_divers[role[1].type].refuellingType == Data_divers[tempPlayer.type].refuellingReceptacleType then

											-- print("DcB B ")

										for f = 1 , #role do
											
											
											local time = ""
											local occurence = 0

											for w , wpt in ipairs(role[f].route) do
												if wpt.id == "Station" and occurence == 0 then
													time = FormatTime(camp.time + wpt.eta, "hh:mm")
													occurence = occurence + 1
												elseif wpt.id == "Station" and occurence == 1 then
													time = time .. " "..FormatTime(camp.time + wpt.eta, "hh:mm")
													occurence = occurence + 1
												end
											end

											local tabElement = {
												['callsign'] = role[f].callsign,
												['freq'] = role[f].frequency,															--store callsign and frequency
												['type'] = role[f].type,
												['time'] = time,
												['flight'] = f,
												['text'] = role[f].target.text,
											}
											table.insert(tanker_freq, tabElement)
										end
									end
								end
							elseif role[1] and role[1].task == "AFAC" then											--if first flight is tanker
								for f = 1 , #role do
									local time = ""
									local occurence = 0

									for w , wpt in ipairs(role[f].route) do
										if wpt.id == "Station" and occurence == 0 then
											time = FormatTime(camp.time + wpt.eta, "hh:mm")
											occurence = occurence + 1
										elseif wpt.id == "Station" and occurence == 1 then
											time = time .. " "..FormatTime(camp.time + wpt.eta, "hh:mm")
											occurence = occurence + 1
										end
									end

									local tabElement = {
										['callsign'] = role[f].callsign,
										['freq'] = role[f].frequency,															--store callsign and frequency
										['type'] = role[f].type,
										['time'] = time,
										['flight'] = f,
										['LaserCode'] = role[1].target.LaserCode,
									}
									table.insert(AFAC_freq, tabElement)
								end

							elseif role[1] and role[1].task == "CAP" then												--if first flight is tanker
								CAP_freq[role[1].callsign] = role[1].frequency											--store callsign and frequency

							elseif role[1]  and  string.find(role[1].task,"Strike") and pack_n ~= tempPlayer.pack_n then								--and  string.find(role[1].task,"Strike")

								if not All_freq[role[1].callsign] then All_freq[role[1].callsign] = {} end

								if not All_freq[role[1].callsign].freq then All_freq[role[1].callsign].freq = role[1].frequency end
								if not All_freq[role[1].callsign].task then All_freq[role[1].callsign].task = role[1].task end

							end
						end
					end

					-- tanker_freq					
					local tempEWR = ewr[tempPlayer.side]

					-- modification M34.g change freq EWR + custom FrequenceRadio (g: utilise les indicatifs WEST pour EWR)
					local ComparePossible = true
					for z=1, #tempEWR do
						if type(tempEWR[z].callsign) ~= "number" then
							ComparePossible = false
						end
					end

					if ComparePossible then																				--sort by name, if name is a number
						table.sort(tempEWR, function(a,b) return a.callsign < b.callsign  end)
					end

					EWR_freq = {}
					for ewr_n,ewr in ipairs(tempEWR) do																	--iterate through EWR on player side
						if ewr.frequency and ewr.callsign then															--if EWR has a freqency and callsign
							--   modification EWR M07.g
							EWR_freqT = {}
							EWR_freqT[ewr.callsign] = {}

							EWR_freqT[ewr.callsign]["freq"] = ewr.frequency												--store callsign and frequency
							EWR_freqT[ewr.callsign]["callsign"] = ewr.callsign

							EWR_freq[#EWR_freq+1] = EWR_freqT
						end
					end

					-- frequency[inheritedType].radio[1].nbCanal					
					--reprend sous une forme plus simple les butées des radios
					local _radio = {}
					local radioP = {}

					if not frequency[inheritedType] then
						radioP[1] = {
							VHF = {
								min = 118,
								max = 173,
							},
							nbCanal = 0,
						}
					else
						for i=1, #frequency[inheritedType].radio do
							radioP[i] = frequency[inheritedType].radio[i]
						end
					end

					local RadName = {}																								--creation table des noms de radio
					for Nr = 1, 10 do
						if  radioP[Nr] and  radioP[Nr].name then
							RadName[Nr] = radioP[Nr].name
						elseif  radioP[Nr] then
							RadName[Nr] = "Radio "..Nr
						end
					end

					--Divert BASE	M33.d				
					if tempPlayer.divert then
						for Divert, _base in pairs(tempPlayer.divert) do
							if Divert ~= tempPlayer.unitname then
								local landingPossible = false
								local divertLowerStr = string.lower(Divert)
								if string.find(divertLowerStr, "farp") or  string.find(divertLowerStr, "lha") then
									if IsHelicopter[inheritedType] or inheritedType == "AV8BNA" then
										landingPossible = true
									end
								else
									landingPossible = true
								end

								if landingPossible then
									for i=1, #radioP do
										if db_airbases[_base].ATC_frequency and type(db_airbases[_base].ATC_frequency)~= "table" then
											if FreqCapability(db_airbases[_base].ATC_frequency, radioP, i, "Divert: ") then
												ATC_Divert_freq[Divert] = db_airbases[_base].ATC_frequency
											end
										elseif db_airbases[_base].ATC_frequency and type(db_airbases[_base].ATC_frequency)== "table" then
											for n , freq in ipairs(db_airbases[_base].ATC_frequency) do
												if FreqCapability(freq, radioP, i, "Divert: ") then
													ATC_Divert_freq[Divert] = db_airbases[_base].ATC_frequency
												end
											end
										end
									end
								end
							end
						end
					end

					--build list
					s = "Communication:\n"
					entries = {}
					local entry = {name = "", call = "", freq = "",radio = ""}
					local  u = 1

					local entriesRadio = {
						[1] = {},
						[2] = {},
						[3] = {},
						[4] = {},
						[5] = {},
					}
					--***************************************************************************
					--PACKAGE_freq***************************************************************

					-- for Nradio = 1, 3 do
					for Nradio = 1, #radioP do

						local freqA = tonumber(tempPlayer.group.frequency)
						entry = {name = "", call = "", freq = "",radio = ""}
						entry["name"] = "Package: "
						entry["call"] = ""
						entry["freq"] = string.format("%07.3f", freqA).. " MHz"

						if FreqCapability(freqA, radioP, Nradio, "") then
							if radioP[Nradio] and radioP[Nradio].nbCanal > 0 and #tempPlayer.group["units"][u]["Radio"][Nradio]["channels"] <  radioP[Nradio].nbCanal then
								if radioP[Nradio].startCanal == 0 then MC = -1 end
								-- if camp.radio[sideName][Nradio]  then
								table.insert(tempPlayer.group["units"][u]["Radio"][Nradio]["channels"], freqA)
								entry["radio"] = RadName[Nradio].." / Channel " .. #tempPlayer.group["units"][u]["Radio"][Nradio]["channels"]	 + MC
								local entryCopy = Deepcopy(entry)
								table.insert(entriesRadio[Nradio], entryCopy)
							elseif radioP[Nradio] and (radioP[Nradio].manual or radioP[Nradio].nbCanal == 0)  then
								local entryCopy = Deepcopy(entry)
								table.insert(entriesRadio[Nradio], entryCopy)
							end
						end
					end


					--***************************************************************************
					--ATC_freq*******************************************************************
					entry = {name = "", call = "", freq = "",radio = ""}
					--ATC_frequency = {"4.725", "40.350", "120.200", "251.900" }
					local ATC_freqTemp = db_airbases[tempPlayer.airbase].ATC_frequency
					local freqA = 0
					--M34.o (o: all ATC freq in array)
					if type(ATC_freqTemp) == "table" then
						for i=#ATC_freqTemp, 1, -1 do
							for n = 1, #radioP do
								for wave, freqTest in pairs(radioP[n]) do
									if type(freqTest) == "table" and freqTest.max and tonumber(ATC_freqTemp[i]) < freqTest.max and  tonumber(ATC_freqTemp[i]) > freqTest.min then
										freqA = tonumber(ATC_freqTemp[i]) or 0
									end
								end
							end
						end
					else
						freqA = tonumber(db_airbases[tempPlayer.airbase].ATC_frequency) or 0
					end

					for Nradio = 1, #radioP do
						entry = {name = "", call = "", freq = "",radio = ""}
						entry["name"] = "ATC: "
						entry["call"] = ReplaceBaseName(tempPlayer.airbase)
						entry["freq"] = string.format("%07.3f", freqA).. " MHz"

						if FreqCapability(freqA, radioP, Nradio, "") then
							if radioP[Nradio] and radioP[Nradio].nbCanal > 0 and #tempPlayer.group["units"][u]["Radio"][Nradio]["channels"] <  radioP[Nradio].nbCanal then
								if radioP[Nradio].startCanal == 0 then MC = -1 end
								-- if camp.radio[sideName][Nradio]  then
								table.insert(tempPlayer.group["units"][u]["Radio"][Nradio]["channels"], freqA)
								entry["radio"] = RadName[Nradio].." / Channel " .. #tempPlayer.group["units"][u]["Radio"][Nradio]["channels"]	 + MC
								local entryCopy = Deepcopy(entry)
								table.insert(entriesRadio[Nradio], entryCopy)
							elseif radioP[Nradio] and (radioP[Nradio].manual or radioP[Nradio].nbCanal == 0)  then
								local entryCopy = Deepcopy(entry)
								table.insert(entriesRadio[Nradio], entryCopy)
							end
						end
					end

					--***************************************************************************
					--COMMON_freq****************************************************************
					if mission_ini.MP_PlaneRecovery and Multi.NbGroup >= 1  then
						if CommonFreq[sideName]["UHF"][1] ~= 0 then
							for cf = 1 , #CommonFreq[sideName]["UHF"] do
								local freqA = tonumber(CommonFreq[sideName]["UHF"][cf])
								local call = ""
								local lib = ""
								if cf == 1 then lib = "A" else lib = "B" end

								for Nradio = 1, #radioP do
									local entry = {name = "", call = "", freq = "",radio = ""}
									entry["name"] = "Coalition UHF("..lib.."):"
									entry["call"] = call
									entry["freq"] = string.format("%07.3f", freqA).. " MHz"

									if FreqCapability(freqA, radioP, Nradio, "") then
										if radioP[Nradio] and radioP[Nradio].nbCanal > 0 and #tempPlayer.group["units"][u]["Radio"][Nradio]["channels"] <  radioP[Nradio].nbCanal then
											if radioP[Nradio] and radioP[Nradio].nbCanal > 0 then
												if radioP[Nradio].startCanal == 0 then MC = -1 end
												-- if camp.radio[sideName][Nradio]  then
												table.insert(tempPlayer.group["units"][u]["Radio"][Nradio]["channels"], freqA)
												entry["radio"] = RadName[Nradio].." / Channel " .. #tempPlayer.group["units"][u]["Radio"][Nradio]["channels"]	 + MC
												local entryCopy = Deepcopy(entry)
												table.insert(entriesRadio[Nradio], entryCopy)
											elseif radioP[Nradio] and (radioP[Nradio].manual or radioP[Nradio].nbCanal == 0)  then
												local entryCopy = Deepcopy(entry)
												table.insert(entriesRadio[Nradio], entryCopy)
											end
										end
									end

								end
							end
						end

						--***************************************************************************
						--COMMON_VHF_freq
						if CommonFreq[sideName]["VHF"][1] ~= 0 then
							for cf = 1 , #CommonFreq[sideName]["VHF"] do
								local freqA = tonumber(CommonFreq[sideName]["VHF"][cf])
								local call = ""
								local lib = ""
								if cf == 1 then lib = "C" else lib = "D" end

								for Nradio = 1, #radioP do
									local entry = {name = "", call = "", freq = "",radio = ""}
									entry["name"] = "Coalition VHF("..lib.."):"
									entry["call"] = call
									entry["freq"] = string.format("%07.3f", freqA).. " MHz"

									if FreqCapability(freqA, radioP, Nradio, "") then
										if radioP[Nradio] and radioP[Nradio].nbCanal > 0 and #tempPlayer.group["units"][u]["Radio"][Nradio]["channels"] <  radioP[Nradio].nbCanal then
											if radioP[Nradio].startCanal == 0 then MC = -1 end
											table.insert(tempPlayer.group["units"][u]["Radio"][Nradio]["channels"], freqA)
											entry["radio"] = RadName[Nradio].." / Channel " .. #tempPlayer.group["units"][u]["Radio"][Nradio]["channels"]	 + MC
											local entryCopy = Deepcopy(entry)
											table.insert(entriesRadio[Nradio], entryCopy)
										elseif radioP[Nradio] and (radioP[Nradio].manual or radioP[Nradio].nbCanal == 0)  then
											local entryCopy = Deepcopy(entry)
											table.insert(entriesRadio[Nradio], entryCopy)
										end
									end
								end
							end
						end

						--***************************************************************************
						--COMMON_HF_freq
						if CommonFreq[sideName]["HF"][1] ~= 0 then
							for cf = 1 , #CommonFreq[sideName]["VHF"] do
								local freqA = tonumber(CommonFreq[sideName]["HF"][cf])
								local call = ""
								local lib = ""
								if cf == 1 then lib = "G" else lib = "H" end
								for Nradio = 1, #radioP do

									local entry = {name = "", call = "", freq = "",radio = ""}
									entry["name"] = "Coalition HF("..lib.."):"
									entry["call"] = call
									entry["freq"] = string.format("%02.3f", freqA).. " MHz"

									if FreqCapability(freqA, radioP, Nradio, "") then
										if radioP[Nradio] and radioP[Nradio].nbCanal > 0 and #tempPlayer.group["units"][u]["Radio"][Nradio]["channels"] <  radioP[Nradio].nbCanal then
											if radioP[Nradio].startCanal == 0 then MC = -1 end
											table.insert(tempPlayer.group["units"][u]["Radio"][Nradio]["channels"], freqA)
											entry["radio"] = RadName[Nradio].." / Channel " .. #tempPlayer.group["units"][u]["Radio"][Nradio]["channels"]	 + MC
											local entryCopy = Deepcopy(entry)
											table.insert(entriesRadio[Nradio], entryCopy)
										elseif radioP[Nradio] and (radioP[Nradio].manual or radioP[Nradio].nbCanal == 0)  then
											local entryCopy = Deepcopy(entry)
											table.insert(entriesRadio[Nradio], entryCopy)
										end
									end
								end
							end
						end

						--***************************************************************************
						--COMMON_LVHF_freq
						if CommonFreq[sideName]["LVHF"][1] ~= 0 then
							for cf = 1 , #CommonFreq[sideName]["LVHF"] do
								local freqA = tonumber(CommonFreq[sideName]["LVHF"][cf])
								local call = ""
								local lib = ""
								if cf == 1 then lib = "E" else lib = "F" end

								for Nradio = 1, #radioP do
									local entry = {name = "", call = "", freq = "",radio = ""}
									entry["name"] = "Coalition LVHF("..lib.."):"
									entry["call"] = call
									entry["freq"] = string.format("%02.3f", freqA).. " MHz"

									if FreqCapability(freqA, radioP, Nradio, "") then
										if radioP[Nradio] and radioP[Nradio].nbCanal > 0 and #tempPlayer.group["units"][u]["Radio"][Nradio]["channels"] <  radioP[Nradio].nbCanal then
											if radioP[Nradio].startCanal == 0 then MC = -1 end
											table.insert(tempPlayer.group["units"][u]["Radio"][Nradio]["channels"], freqA)
											entry["radio"] = RadName[Nradio].." / Channel " .. #tempPlayer.group["units"][u]["Radio"][Nradio]["channels"]	 + MC
											local entryCopy = Deepcopy(entry)
											table.insert(entriesRadio[Nradio], entryCopy)
										elseif radioP[Nradio] and (radioP[Nradio].manual or radioP[Nradio].nbCanal == 0)  then
											local entryCopy = Deepcopy(entry)
											table.insert(entriesRadio[Nradio], entryCopy)
										end
									end
								end
							end
						end
					end
					--***************************************************************************
					--AWACS_freq				
					local copy_AWACS_freq = Deepcopy(AWACS_freq)
					for vN, value in pairs(AWACS_freq) do
						local freqA = tonumber(value.freq)
						-- local call = string.sub(value.callsign, 1, -3)
						local call = ""

						for copy_vN, copyValue in pairs(copy_AWACS_freq) do
							if tonumber(copyValue.freq) == freqA  then
								-- call = call .. " "..string.sub(copyValue.callsign, -2, -1).." ("..copyValue.time..")"
								call = call .. ""..copyValue.callsign.." ("..copyValue.time..")"
							end
						end

						if value.flight == 1 then
							for Nradio = 1, #radioP do
								entry = {name = "", call = "", freq = "",radio = ""}
								entry["name"] = "AWACS: "..value.type
								entry["call"] = call
								entry["freq"] = string.format("%07.3f", freqA).. " MHz"

								if FreqCapability(freqA, radioP, Nradio, "") then
									if radioP[Nradio] and radioP[Nradio].nbCanal > 0 and #tempPlayer.group["units"][u]["Radio"][Nradio]["channels"] <  radioP[Nradio].nbCanal then
										if radioP[Nradio].startCanal == 0 then MC = -1 end
										table.insert(tempPlayer.group["units"][u]["Radio"][Nradio]["channels"], freqA)
										entry["radio"] = RadName[Nradio].." / Channel " .. #tempPlayer.group["units"][u]["Radio"][Nradio]["channels"]	 + MC
										local entryCopy = Deepcopy(entry)
										table.insert(entriesRadio[Nradio], entryCopy)
									elseif radioP[Nradio] and (radioP[Nradio].manual or radioP[Nradio].nbCanal == 0)  then
										local entryCopy = Deepcopy(entry)
										table.insert(entriesRadio[Nradio], entryCopy)
									end
								end
							end
						end
					end

					--***************************************************************************
					--AFAC_freq				
					local copy_AFAC_freq = Deepcopy(AFAC_freq)
					for vN, value in pairs(AFAC_freq) do
						local freqA = tonumber(value.freq)
						-- local call = string.sub(value.callsign, 1, -3)
						local call = ""

						for copy_vN, copyValue in pairs(copy_AFAC_freq) do
							if tonumber(copyValue.freq) == freqA  then
								call = call .. ""..copyValue.callsign.." ("..copyValue.time..")"
							end
						end

						if value.flight == 1 then
							for Nradio = 1, #radioP do
								entry = {name = "", call = "", freq = "",radio = ""}
								entry["name"] = "AFAC: "..value.type .. " (laser: ".. tostring(value.LaserCode)..")"
								entry["call"] = call
								entry["freq"] = string.format("%07.3f", freqA).. " MHz"

								if FreqCapability(freqA, radioP, Nradio, "") then
									if radioP[Nradio] and radioP[Nradio].nbCanal > 0 and #tempPlayer.group["units"][u]["Radio"][Nradio]["channels"] <  radioP[Nradio].nbCanal then
										if radioP[Nradio].startCanal == 0 then MC = -1 end
										table.insert(tempPlayer.group["units"][u]["Radio"][Nradio]["channels"], freqA)
										entry["radio"] = RadName[Nradio].." / Channel " .. #tempPlayer.group["units"][u]["Radio"][Nradio]["channels"]	 + MC
										local entryCopy = Deepcopy(entry)
										table.insert(entriesRadio[Nradio], entryCopy)
									elseif radioP[Nradio] and (radioP[Nradio].manual or radioP[Nradio].nbCanal == 0)  then
										local entryCopy = Deepcopy(entry)
										table.insert(entriesRadio[Nradio], entryCopy)
									end
								end
							end
						end
					end
					--***************************************************************************
					--EWR_freq
					for ni,EWR_freq_ in ipairs(EWR_freq) do
						for call,freq in pairs(EWR_freq_) do
							local freqA = tonumber(freq.freq)

							for Nradio = 1, #radioP do
								entry = {name = "", call = "", freq = "",radio = ""}
								entry["name"] = "EWR: "
								entry["call"] = call
								entry["freq"] = string.format("%07.3f", freqA).. " MHz"

								if FreqCapability(freqA, radioP, Nradio, "") then
									if radioP[Nradio] and radioP[Nradio].nbCanal > 0 and #tempPlayer.group["units"][u]["Radio"][Nradio]["channels"] <  radioP[Nradio].nbCanal then
										if radioP[Nradio].startCanal == 0 then MC = -1 end
										table.insert(tempPlayer.group["units"][u]["Radio"][Nradio]["channels"], freqA)
										entry["radio"] = RadName[Nradio].." / Channel " .. #tempPlayer.group["units"][u]["Radio"][Nradio]["channels"]	 + MC
										local entryCopy = Deepcopy(entry)
										table.insert(entriesRadio[Nradio], entryCopy)
									elseif radioP[Nradio] and (radioP[Nradio].manual or radioP[Nradio].nbCanal == 0)  then
										local entryCopy = Deepcopy(entry)
										table.insert(entriesRadio[Nradio], entryCopy)
									end
								end
							end
						end
					end

					--***************************************************************************
					--tanker_freq			
					-- Display(tanker_freq, "DcB tanker_freq")
					local copy_tanker_freq = Deepcopy(tanker_freq)
					if refuelable then
						for vN, value in pairs(tanker_freq) do
							local callINI = value.callsign
							local freqA = tonumber(value.freq)
							-- local call = string.sub(callINI, 1, -3)
							local call = ""

							for copy_vN, copyValue in pairs(copy_tanker_freq) do
								if tonumber(copyValue.freq) == freqA  then
									-- call = call .. " "..string.sub(copyValue.callsign, -2, -1).." ("..copyValue.time..")"
									call = call .. ""..copyValue.callsign.." ("..copyValue.time..")"
								end
							end
							if value.flight == 1 then
								for Nradio = 1, #radioP do
									local postTxt = ""
									if value.text then postTxt = value.text end
									entry = {name = "", call = "", freq = "", radio = ""}
									entry["name"] = "Tanker: "..tostring(tanker_TACAN[callINI]).." "..value.type.." "..postTxt
									entry["call"] = call
									entry["freq"] = string.format("%07.3f", freqA).. " MHz"

									if FreqCapability(freqA, radioP, Nradio, "") then
										if radioP[Nradio] and radioP[Nradio].nbCanal > 0 and #tempPlayer.group["units"][u]["Radio"][Nradio]["channels"] < radioP[Nradio].nbCanal then
											if radioP[Nradio].startCanal == 0 then MC = -1 end
											table.insert(tempPlayer.group["units"][u]["Radio"][Nradio]["channels"], freqA)
											entry["radio"] = RadName[Nradio].." / Channel " .. #tempPlayer.group["units"][u]["Radio"][Nradio]["channels"] + MC
											local entryCopy = Deepcopy(entry)
											table.insert(entriesRadio[Nradio], entryCopy)
										elseif radioP[Nradio] and (radioP[Nradio].manual or radioP[Nradio].nbCanal == 0)  then
											local entryCopy = Deepcopy(entry)
											table.insert(entriesRadio[Nradio], entryCopy)
										end
									end
								end
							end
						end
					end

					--***************************************************************************
					--CAP_freq
					for call,freq in pairs(CAP_freq) do
						local freqA = tonumber(freq)

						for Nradio = 1, #radioP do
							entry = {name = "", call = "", freq = "", radio = ""}
							entry["name"] = "CAP: "
							entry["call"] = call
							entry["freq"] = string.format("%07.3f", freqA).. " MHz"

							if FreqCapability(freqA, radioP, Nradio, "") then
								if radioP[Nradio] and radioP[Nradio].nbCanal > 0 and #tempPlayer.group["units"][u]["Radio"][Nradio]["channels"] <  radioP[Nradio].nbCanal then
									if radioP[Nradio].startCanal == 0 then MC = -1 end
									-- if camp.radio[sideName][Nradio]  then
									table.insert(tempPlayer.group["units"][u]["Radio"][Nradio]["channels"], freqA)
									entry["radio"] = RadName[Nradio].." / Channel " .. #tempPlayer.group["units"][u]["Radio"][Nradio]["channels"]	 + MC
									local entryCopy = Deepcopy(entry)
									table.insert(entriesRadio[Nradio], entryCopy)
								elseif radioP[Nradio] and (radioP[Nradio].manual or radioP[Nradio].nbCanal == 0)  then
									local entryCopy = Deepcopy(entry)
									table.insert(entriesRadio[Nradio], entryCopy)
								end
							end
						end
					end

					--***************************************************************************
					--ATC_Divert_freq
					for call,freq in pairs(ATC_Divert_freq) do
						local freqA = tonumber(freq)
						if freqA and freqA ~= nil then
							for Nradio = 1, #radioP do
								entry = {name = "", call = "", freq = "", radio = ""}
								entry["name"] = "Divert: "
								entry["call"] = ReplaceBaseName(call)
								entry["freq"] = string.format("%07.3f", freqA).. " MHz"

								if FreqCapability(freqA, radioP, Nradio, "") then
									if radioP[Nradio] and radioP[Nradio].nbCanal > 0 and #tempPlayer.group["units"][u]["Radio"][Nradio]["channels"] <  radioP[Nradio].nbCanal then
										if radioP[Nradio].startCanal == 0 then MC = -1 end
										-- if camp.radio[sideName][Nradio]  then
										table.insert(tempPlayer.group["units"][u]["Radio"][Nradio]["channels"], freqA)
										entry["radio"] = RadName[Nradio].." / Channel " .. #tempPlayer.group["units"][u]["Radio"][Nradio]["channels"]	 + MC
										local entryCopy = Deepcopy(entry)
										table.insert(entriesRadio[Nradio], entryCopy)
									elseif radioP[Nradio] and (radioP[Nradio].manual or radioP[Nradio].nbCanal == 0)  then
										local entryCopy = Deepcopy(entry)
										table.insert(entriesRadio[Nradio], entryCopy)
									end
								end
							end
						end
					end
					--ATC all freq
					for Nradio = 1, #radioP do

						for baseName, base in pairs(db_airbases) do
							if base.side == sideName then
								local ATC_freqTemp = base.ATC_frequency
								local freqA = 0
								--M34.o (o: all ATC freq in array)
								if type(ATC_freqTemp) == "table" then
									for i=#ATC_freqTemp, 1, -1 do

										for wave, freqTest in pairs(radioP[Nradio]) do
											if type(freqTest) == "table" and freqTest.max and tonumber(ATC_freqTemp[i]) < freqTest.max and  tonumber(ATC_freqTemp[i]) > freqTest.min then
												freqA = tonumber(ATC_freqTemp[i]) or 0
											end
										end

									end
								else
									freqA = tonumber(base.ATC_frequency) or 0
								end

								if freqA and freqA ~= nil and freqA ~= 0 then
									entry = {name = "", call = "", freq = "", radio = ""}
									entry["name"] = "ATC"
									entry["call"] = ReplaceBaseName(baseName)
									entry["freq"] = string.format("%07.3f", freqA).. " MHz"

									if FreqCapability(freqA, radioP, Nradio, "ATC "..tostring(baseName)) then
										if radioP[Nradio] and radioP[Nradio].nbCanal > 0 and #tempPlayer.group["units"][u]["Radio"][Nradio]["channels"] <  radioP[Nradio].nbCanal then
											if radioP[Nradio].startCanal == 0 then MC = -1 end
											table.insert(tempPlayer.group["units"][u]["Radio"][Nradio]["channels"], freqA)
											entry["radio"] = RadName[Nradio].." / Channel " .. #tempPlayer.group["units"][u]["Radio"][Nradio]["channels"]	 + MC
											local entryCopy = Deepcopy(entry)
											table.insert(entriesRadio[Nradio], entryCopy)
										end
									end
								end
							end
						end
					end
					--***************************************************************************
					--All_freq
					for call,freq in pairs(All_freq) do
						local freqA = tonumber(freq.freq)
						if freqA and type(freqA) == "number" and freqA > 0 then

							for Nradio = 1, #radioP do
								entry = {name = "", call = "", freq = "", radio = ""}
								entry["name"] = freq.task..": "
								entry["call"] = call
								entry["freq"] = string.format("%07.3f", freqA).. " MHz"

								if FreqCapability(freqA, radioP, Nradio, "") then
									if radioP[Nradio] and radioP[Nradio].nbCanal > 0 and #tempPlayer.group["units"][u]["Radio"][Nradio]["channels"] <  radioP[Nradio].nbCanal then
										if radioP[Nradio].startCanal == 0 then MC = -1 end
										-- if camp.radio[sideName][Nradio]  then
										table.insert(tempPlayer.group["units"][u]["Radio"][Nradio]["channels"], freqA)
										entry["radio"] = RadName[Nradio].." / Channel " .. #tempPlayer.group["units"][u]["Radio"][Nradio]["channels"]	 + MC
										local entryCopy = Deepcopy(entry)
										table.insert(entriesRadio[Nradio], entryCopy)
									elseif radioP[Nradio] and (radioP[Nradio].manual or radioP[Nradio].nbCanal == 0)  then
										local entryCopy = Deepcopy(entry)
										table.insert(entriesRadio[Nradio], entryCopy)
									end
								end
							end
						end
					end


					for nn = 1, #entriesRadio do
						if RadName[nn] and RadName[nn] ~= nil then
							entries[#entries+1] = {name = "Radio: "..RadName[nn], call = "", freq = "", radio = ""}
							for mm = 1, #entriesRadio[nn] do
								entries[#entries+1] = entriesRadio[nn][mm]
							end
						end
					end

					s = s .."\n"

					-- recopie l'assignation radio aux autres ailier client
					for u = 2, #tempPlayer.group.units do
						if tempPlayer.group["units"][u]["skill"] == "Client" or tempPlayer.group["units"][u]["skill"] == "Player" then
							tempPlayer.group["units"][u]["Radio"] = tempPlayer.group["units"][1]["Radio"]
						end
					end

					-- recopie l'assignation radio aux recovery
					if mission_ini.MP_PlaneRecovery and Multi.NbGroup >= 1  then
						for coalition_name,coal in pairs(mission.coalition) do
							for country_n,country in pairs(coal.country) do
								if country.plane then
									for group_n,group in pairs(country.plane.group) do
										if group.name == "Recovery "..tempPlayer.group.name  then
											for w = 1, #group.units do
												group["units"][w]["Radio"] = tempPlayer.group["units"][1]["Radio"]
											end
										end
									end
								end
								if country.helicopter then
									for group_n,group in pairs(country.helicopter.group) do
										if group.name == "Recovery "..tempPlayer.group.name  then
											for w = 1, #group.units do
												group["units"][w]["Radio"] = tempPlayer.group["units"][1]["Radio"]
											end
										end
									end
								end
							end
						end
					end


					local struct = {																			--list entries that are making up the navigaion overview
						[1] = {
							lookup = "name",																	--lookup in the player.waypoints table
							header = "Name",																		--name which should be displayer in the list header
							str_length = 4,																		--string length of largest entry of this type (default the string length of the header)
						},
						[2] = {
							lookup = "call",
							header = "Call",
							str_length = 4,
						},
						[3] = {
							lookup = "freq",
							header = "Freq",
							str_length = 4,
						},
						[4] = {
							lookup = "radio",
							header = "Radio",
							str_length = 5,
						},
					}

					local TabHeader = {}
					for t = 1, #struct do
						for e = 1, #entries do																		--iterate through all entries
							for header, value in pairs(entries[e]) do															--if this is not the last entry of the waypoint, add spaces to the next entry	
								if header == struct[t].lookup then
									local str_length =  string.len(tostring(value)) + 3		--calculate number of spaces that need to be added for alignement (string length of largest entry of same type + 3 - length of current entry = number of spaces)
									if not  TabHeader[header] then TabHeader[header] = str_length end
									if str_length > TabHeader[header] then
										TabHeader[header] = str_length
									end
								end
							end
						end
					end

					--build the list header
					for e = 1, #entries do
						for t = 1, #struct do																		--iterate through all entries							
							local entry
							if struct[t].lookup == "name" then
								entry = entries[e][struct[t].lookup]
								if string.find(entry, "Radio: ") then s = s .. "\n" end
							elseif struct[t].lookup == "call" then
								entry = entries[e][struct[t].lookup]
							elseif struct[t].lookup == "freq" then
								entry = entries[e][struct[t].lookup]
							elseif struct[t].lookup == "radio" then
								entry = entries[e][struct[t].lookup]
							end
							s = s .. tostring(entry)
							local space = TabHeader[struct[t].lookup] + 0 - string.len(tostring(entry))				--calculate number of spaces that need to be added for alignement (string length of largest entry of same type + 3 - length of current entry = number of spaces)
							for n = 1, space * 1.0 do
								s = s .. " "																		--add 1.5 spaces for every missing letter
							end
						end
						s = s .. "\n"
						ScratchpadCom = s
					end
					if allowedBrief then  briefing[sideName] = briefing[sideName] .. s .. "\n\n" s="" end

					-- Modification M15 info catapulte/pont dans briefing	
					local tabNam = {}
					s = ""
					if PlacePA then
						for side , pPA in pairs(PlacePA) do
							if sideName == side then																	--if camp.player.side == side then
								for base , Tmn in pairs(pPA) do
									if base == tempPlayer.airbase then
										s = s..ReplaceBaseName(base).." Takeoff time on the platform at ...\n"
										for sec, name in PairsByKeys(Tmn) do
											if tabNam[name] ~= true then
												local catTime = camp.time + sec
												s = s.." "..FormatTime(catTime, "hh:mm").. " - "..tostring(name).."\n"
												tabNam[name] = true
											end
										end
									end
								end
							end
						end
					if allowedBrief then  briefing[sideName] = briefing[sideName] .. s .. "\n\n" s="" end
					end



					--Meteo
					--Debug_c camp.date.day
					local s = "Meteo:\n"																				--overview of Weather
					-- local remain = math.ceil((camp.weather.zoneEnd - ((camp.date.day - 1) * 86400 + camp.time)) / 3600)		--hours until end of weather zone					
					-- local duration = math.ceil((camp.weather.zoneEnd - camp.weather.zoneStart) / 3600)					--duration of the weather zone in hours
					-- local passed = 100 / duration * remain																--percentage of zone passage

					-- if camp.weather.zone == "high" then
					-- 	if mission.weather["enable_fog"] == false then
					-- 		s = s .. "Good flying weather due to influence of a high pressure system in theater of operations"
					-- 		if remain < 6 then
					-- 			s = s .. ". Change of general weather situation imminent. "
					-- 		elseif remain < 25 then
					-- 			s = s .. ", expected to remain in effect for next " .. remain .. " hours. "
					-- 		elseif remain < 48 then
					-- 			s = s .. ", expected to remain dominant for another day. "
					-- 		else
					-- 			s = s .. ", expected to remain dominant for next " .. math.floor(remain / 24) .. " days. "
					-- 		end
					-- 	else
					-- 		s = s .. "Ground fog conditions. "
					-- 	end

					-- elseif camp.weather.zone == "low front cold" then
					-- 	s = s .. "Low pressure system dominating theater of operations. Currently poor flying weather due to passage of cold front. Weather improvement expected within next " .. remain .. " hours. "

					-- elseif camp.weather.zone == "low front warm" then
					-- 	s = s .. "Low pressure system dominating theater of operations. "
					-- 	if passed < 50 then
					-- 		s = s .. "Currently increasingly poor flying weather due to the passage of warm front. Expected to clear up after " .. remain .. " hours. "
					-- 	else
					-- 		s = s .. "Weather expected to deteriorate within next " .. remain .. " hours due to approach of warm front. "
					-- 	end

					-- elseif camp.weather.zone == "low sector cold" then
					-- 	s = s .. "Low pressure system dominating theater of operations. Currently fair flying weather in cold sector"
					-- 	if remain < 6 then
					-- 		s = s .. ". Change of general weather situation imminent. "
					-- 	elseif remain < 25 then
					-- 		s = s .. ", expected to remain in effect for next " .. remain .. " hours. "
					-- 	elseif remain < 48 then
					-- 		s = s .. ", expected to remain stable for another day. "
					-- 	else
					-- 		s = s .. ", expected to remain stable for next " .. math.floor(remain / 24) .. " days. "
					-- 	end

					-- elseif camp.weather.zone == "low sector warm" then
					-- 	s = s .. "Low pressure system dominating theater of operations. Currently fair flying weather in warm sector"
					-- 	if remain < 6 then
					-- 		s = s .. ". Change of general weather situation imminent. "
					-- 	elseif remain < 25 then
					-- 		s = s .. ", expected to remain in effect for next " .. remain .. " hours. "
					-- 	elseif remain < 48 then
					-- 		s = s .. ", expected to remain stable for another day. "
					-- 	else
					-- 		s = s .. ", expected to remain stable for next " .. math.floor(remain / 24) .. " days. "
					-- 	end

					-- end


					s = s ..camp.weather.brief

					local lMetar = TabMetar[tempPlayer.airbase][unitsUse]

					print(lMetar)


					if allowedBrief then  briefing[sideName] = briefing[sideName] .. s .. "\n\n" ..tostring(lMetar) .. "\n"		 end
					if allowedBrief then  briefing[sideName] = briefing[sideName] .. tostring(MoonTxt).. "\n"			end

					--Assign briefing text to mission file
					if sideName == "blue" then
						mission.descriptionBlueTask = briefing[sideName]
					else
						mission.descriptionRedTask = briefing[sideName]
					end

					-- modification M41.b 	Sratchpad written in the Sratchpad file, if this modul is installed
					local ScratchpadPath = "../../../../../../Config/ScratchpadConfig.lua"
					-- local ScratchpadPath = "../../../../../../Config/ScratchpadConfig.lua"
					local TestPath = io.open(ScratchpadPath, "r")

					-- modification M41 	Scratchpad written in the Sratchpad file, if this modul is installed
					-- if mission_ini.WrittenOnScratchpadMod and TestPath ~= nil then 
					if TestPath ~= nil then
						io.close(TestPath)
						local ScratBriefTXT = StringToTxtBrief(briefing[sideName])
						config = {}
						dofile(ScratchpadPath)
						local ScratFil = io.open(ScratchpadPath, "w") or error("Failed to open Scratchpad file")
						config.content = ScratBriefTXT
						local ScratConfig = "config = " .. TableSerialization(config, 0)
						ScratFil:write(ScratConfig)
						ScratFil:close()
					end
				end
			end
		end
	end
end

dictionary.DictKey_descriptionText_1 = mission.descriptionText
mission.descriptionText = "DictKey_descriptionText_1"

dictionary.DictKey_descriptionRedTask_2 = mission.descriptionRedTask
mission.descriptionRedTask = "DictKey_descriptionRedTask_2"

dictionary.DictKey_descriptionBlueTask_3 = mission.descriptionBlueTask
mission.descriptionBlueTask = "DictKey_descriptionBlueTask_3"

-- ajoute les images permanentes du briefing
if not (EndCampaign or camp.endCampaign) then
	for side, file in pairs(pictureBrief) do
		if side == "blue" then
			for nb, filename in ipairs(file) do
				table.insert(BriefingImagesB, filename)
			end
		elseif side == "red" then
			for nb, filename in ipairs(file) do
				table.insert(BriefingImagesR, filename)
			end
		end
	end

	 -- ajoute les images du target selectionné
	if target_picture["blue"] then
		for TP_n, target_picture in ipairs(target_picture.blue) do
			local filename = target_picture
			table.insert(BriefingImagesB, filename)
		end
	end
	if target_picture["red"] then
		for TP_n, target_picture in ipairs(target_picture.red) do
			local filename = target_picture
			table.insert(BriefingImagesR, filename)
		end
	end
end

  -- ajout du BriefingImagesB/R sauvegardé dans le camp_status en cas de d'attente de generation de mission
if BriefingImagesB and camp.BriefingImagesB and not TaskRefused then
	for iCamp = 1, #camp.BriefingImagesB do
		local found = false
		for iBase = 1, #BriefingImagesB do
			if BriefingImagesB[iBase] == camp.BriefingImagesB[iCamp]  then
				found = true
				break
			end
		end
		if not found then
			table.insert(BriefingImagesB, camp.BriefingImagesB[iCamp])
		end
	end
	camp.BriefingImagesB = nil
end

if BriefingImagesR and camp.BriefingImagesR and not TaskRefused then
	for iCamp = 1, #camp.BriefingImagesR do
		local found = false
		for iBase = 1, #BriefingImagesR do
			if BriefingImagesR[iBase] == camp.BriefingImagesR[iCamp]  then
				found = true
				break
			end
		end
		if not found then
			table.insert(BriefingImagesR, camp.BriefingImagesR[iCamp])
		end
	end
	camp.BriefingImagesR = nil
end


for n = 1, #BriefingImagesB do
	mission.maxDictId = mission.maxDictId + 1
	mapResource["ResKey_ImageBriefing_" .. mission.maxDictId] = BriefingImagesB[n]     --define key in mapResource file
	table.insert(mission.pictureFileNameB, "ResKey_ImageBriefing_" .. mission.maxDictId)  --add picture to blue briefing
end

for n = 1, #BriefingImagesR do
	mission.maxDictId = mission.maxDictId + 1
	mapResource["ResKey_ImageBriefing_" .. mission.maxDictId] = BriefingImagesB[n]     --define key in mapResource file
	table.insert(mission.pictureFileNameR, "ResKey_ImageBriefing_" .. mission.maxDictId)  --add picture to blue briefing
end


local BriefingTmp = StringToTxt(dictionary.DictKey_descriptionRedTask_2)
BriefingTmp = BriefingTmp.."\n\n"..StringToTxt(dictionary.DictKey_descriptionBlueTask_3)
local debugBriefingFile = io.open("Debug/briefing.txt", "w") or error("Failed to open Debug/briefing.txt file")
debugBriefingFile:write(BriefingTmp)																		--save new data
debugBriefingFile:close()



local BriefingTmp = StringToTxt(dictionary.DictKey_descriptionText_1)
local debugBriefingFile = io.open("Debug/briefingDescriptionText.txt", "w")	 or error("Failed to open Debug/briefingDescriptionText file")
debugBriefingFile:write(BriefingTmp)																		--save new data
debugBriefingFile:close()



