--=======================================================================================
-- ATO_FP_90_Final.lua  (appelé par ATO_FlightPlan.lua, via Include)
-- Etape finale du FlightPlan : après la boucle de génération des vols.
-- Contenu : GeWpindex, liaison datalink, sixpack / deck, CTLD, copie des packages,
-- ecriture des fichiers Debug...  Le code ci-dessous est celui d'origine ; seul debugTxt_AtoFP
-- est maintenant lu dans la table AtoFP (partagée avec le fichier principal).
--=======================================================================================

-- Pont avec ATO_FlightPlan.lua : les 'local' du fichier principal ne traversent pas Include.
-- Tables : même objet que dans le fichier principal (pas de copie).
local tempBaseAirStart = AtoFP.tempBaseAirStart
local testDeckPlace = AtoFP.testDeckPlace
local cv_deckReservations = AtoFP.cv_deckReservations
local cv_testSixPack = AtoFP.cv_testSixPack
local pack_L16_unitId = AtoFP.pack_L16_unitId
local pack_SADL_unitId = AtoFP.pack_SADL_unitId
local modify_Activate_GroupTime = AtoFP.modify_Activate_GroupTime
-- Valeurs : photographie prise à l'entrée de cette étape (le texte de debug, lui, est lu dans AtoFP.debugTxt_AtoFP).
local cv_nbPlanetDeck = AtoFP.cv_nbPlanetDeck
local debugStart = AtoFP.debugStart
local dbg = AtoFP.dbg
--= = = = = = = =  = = = = = = = = = =  = = = = = = = = = =  ==  = = =


function GeWpindex(groupIdCheck, wpLabel)

	for _side, side in pairs(mission.coalition) do
		for countryN, country in pairs(side.country) do
			for category, groups in pairs(country) do
				if type(groups) == "table" and groups["group"] then
					for Ngroup, group in pairs(groups["group"]) do
						if group.groupId == groupIdCheck then
							for unitN, unit in pairs(group.units) do
								for pointN, waypoint in pairs(group.route.points) do
									if waypoint.briefing_name and waypoint.briefing_name == wpLabel then
										return pointN
									end

								end

							end
						end
					end
				end
			end
		end
	end
end


-- following
for side, pack in pairs(ATO) do
	for p = 1, #pack do
		for role, flight in pairs(pack[p]) do
			for f = 1, #flight do
				if flight[f]["mustFolloW"] then

					flight[f]["mustFolloW_groupId"] = pack[p]["main"][1].groupId

					for countryN, country in pairs(mission.coalition[side].country) do
						for category, groups in pairs(country) do
							if type(groups) == "table" and groups["group"] then	--and groups[1].units							
								for Ngroup, group in pairs(groups["group"]) do

									if group.groupId == flight[f].groupId then

										for pointN, waypoint in pairs(group.route.points) do
											if waypoint["task"] and waypoint["task"]["params"] and waypoint["task"]["params"]["tasks"] then
												for taskN, task_ in pairs(waypoint["task"]["params"]["tasks"]) do
													if task_.id == "Follow" then
														task_["params"].groupId = flight[f]["mustFolloW_groupId"]
														task_["params"].lastWptIndex = GeWpindex(flight[f]["mustFolloW_groupId"], "Egress")
													end
												end
											end

										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
end


-- ajoute le warehouse des FARP ajouté par trigger
-- if camp.needWarehouse then
	for _side, side in pairs(mission.coalition) do
		for countryN, country in pairs(side.country) do
			for category, groups in pairs(country) do
				if category == "static" and type(groups) == "table" and groups["group"] then
					for groupN, groupData in pairs(groups["group"]) do
						for unitN, unit in pairs(groupData.units) do
							if unit.category and unit.category == "Heliports" then
								if not warehouses.warehouses[unit.unitId] then
									warehouses.warehouses[unit.unitId] = Data_warehouses
									print("AtoFP: add warehouse for FARP "..unit.unitId.." || "..unit.name)
								end
							end
						end
					end
				end
			end
		end
	end
-- end

--ajoute les modules necessaire dans le fichier mission
if ListRequiredModules then
	if not mission.requiredModules then mission.requiredModules = {} end
	for nameN, module in pairs(ListRequiredModules) do
		if not mission.requiredModules[nameN] then mission.requiredModules[nameN] = nameN end
	end
end

--mettre dans le for du pack ATO les avions link16 capa

for _side, side in pairs(mission.coalition) do
	for countryN, country in pairs(side.country) do
		for category, groups in pairs(country) do
			if type(groups) == "table" and groups["group"] then	--and groups[1].units
				for groupN, group in pairs(groups["group"]) do
					for unitN, unit in pairs(group.units) do

						if Data_divers[unit.type] and Data_divers[unit.type].datalinks and Data_divers[unit.type].datalinks.isReceiver then
							
							
							--ajoute déjà les membres du fligh/group
							local copyUnits = DeepCopy(group.units)

							-- _affiche(copyUnits, "copyUnits: ")
							-- _affiche(unit.datalinks, "unit.datalinks: ")

							local typeDataLink = Data_divers[unit.type].datalinks.type
							-- print("AtoFP: typeDataLink "..tostring(typeDataLink))

							if typeDataLink == "Link16" or typeDataLink == "SADL" then
								for n=1, #copyUnits do
									-- print("AtoFP: copyUnits[n].unitId "..tostring(copyUnits[n].unitId))
									-- print("AtoFP: copyUnits[n].unitId "..tostring(copyUnits[n].unitId))	
									local data = {
										["missionUnitId"] = copyUnits[n].unitId,
									}
									unit.datalinks[typeDataLink].network.teamMembers[n] = data
								end
							end

							for pack_N, listId in pairs(pack_L16_unitId) do
								local listIdCopy = DeepCopy(listId)

								for n=1, #listId do
									if unit.unitId == listId[n] then
										for key, value in pairs(listIdCopy) do
											local data = {
												["missionUnitId"] = value,
											}

											-- --cas avion RECOVERY, place ici l unitId dans le premier members
											-- if unit.datalinks[typeDataLink].network.teamMembers[1].missionUnitId ~= unit.unitId then
											-- 	unit.datalinks[typeDataLink].network.teamMembers[1].missionUnitId = unit.unitId
											-- end

											if #unit.datalinks[typeDataLink].network.teamMembers < Data_divers[unit.type].datalinks.hasTeamMembers then
												table.insert(unit.datalinks[typeDataLink].network.teamMembers, data )
											end

											if #unit.datalinks[typeDataLink].network.donors < Data_divers[unit.type].datalinks.hasDonors then

												--check si l'id du donor n'est pas déjà dans members
												local found = false
												for nMember, member in pairs(unit.datalinks[typeDataLink].network.teamMembers) do

													if member.missionUnitId == value then found = true break end
												end

												if not found then
													table.insert(unit.datalinks[typeDataLink].network.donors, data )
												end

											end
										end
									end
								end
							end

							for pack_N, listId in pairs(pack_SADL_unitId) do
								local listIdCopy = DeepCopy(listId)

								for n=1, #listId do
									if unit.unitId == listId[n] then
										--  n'ajoute que les avions du meme package
										for key, value in pairs(listIdCopy) do
											local data = {
												["missionUnitId"] = value,
											}

											-- --cas avion RECOVERY, place ici l unitId dans le premier members
											-- if unit.datalinks[typeDataLink].network.teamMembers[1].missionUnitId ~= unit.unitId then
											-- 	unit.datalinks[typeDataLink].network.teamMembers[1].missionUnitId = unit.unitId
											-- end

											if #unit.datalinks[typeDataLink].network.teamMembers < Data_divers[unit.type].datalinks.hasTeamMembers then
												table.insert(unit.datalinks[typeDataLink].network.teamMembers, data )
											end

											if #unit.datalinks[typeDataLink].network.donors < Data_divers[unit.type].datalinks.hasDonors then

												--check si l'id du donor n'est pas déjà dans members
												local found = false
												for nMember, member in pairs(unit.datalinks[typeDataLink].network.teamMembers) do
													if member.missionUnitId == value then found = true break end
												end

												if not found then
													table.insert(unit.datalinks[typeDataLink].network.donors, data )
												end

											end
										end
									end

								end
							end

						end
					end
				end
			end
		end
	end
end


local function af_spawnOn(where, groupName)
	dbg("AtoFp AF_spawnOn  "..groupName)

		local action = 'From Runway'
		local actionType = 'TakeOff'

	if where == "catapult" then
		action =  'From Runway'
		actionType = 'TakeOff'
	end

	for _side,side in pairs(mission.coalition) do
		for _country,country in pairs(side.country) do
			if country.plane then
				for Ngroup,group in pairs(country.plane.group) do
					if group.name ==  groupName then
						group.route.points[1]['action'] = action
						group.route.points[1]['type'] = actionType
						group['route']['points'][1]["ETA"] = 0
						group['uncontrolled'] = false
						dbg("AtoFp AF_spawnOn Find "..group.units[1].type.." "..group.name.." "..group.route.points[1]['type'])
					end
				end
			elseif country.helicopter then
				for Ngroup,group in pairs(country.helicopter.group) do
					if group.name ==  groupName then
						group.route.points[1]['action'] = action
						group.route.points[1]['type'] = actionType
						group['route']['points'][1]["ETA"] = 0
						group['uncontrolled'] = false
						dbg("AtoFp AF_spawnOn Find "..group.units[1].type.." "..group.name.." "..group.route.points[1]['type'])
					end
				end
			end
		end
	end
end


--nombre d'avion UNIQUEMENT sur le SIXPACK
local sommePlane = {}
for cv, sixPack in pairs(cv_testSixPack) do

	if #sixPack > 0 then

		table.sort(sixPack, function(a,b) return a.time < b.time  end)
		if debugStart then AtoFP.debugTxt_AtoFP = AtoFP.debugTxt_AtoFP.. _afficheTXT(sixPack, "SixPack") end

		local breakloop = false
		local placeOnSixPack_OK = false
		sommePlane[cv] = 0
		local n = 1
		repeat

			dbg("n: "..n)

			local sixpackWiner = sixPack[n]["groupName"]

			--affiche la note concernant le joueur:
				-- s'il est sur le Sixpack ET serveur dédié : commencer serveur sur pause
				-- s'il n'est pas sur sixpack ET serveur dédié: commencer serveur en resume


			sommePlane[cv] = 4													-- par defaut, le sixpack ne pourra etre utiliser à posteriorie, donc on estime que les 4 places sont occupé, cela evite les spawn derriere et le manque de place ensuite, sur tout le pont

			for _side,side in pairs(mission.coalition) do
				for _country,country in pairs(side.country) do
					if country.plane then
						for Ngroup,group in pairs(country.plane.group) do
							if group.name == sixpackWiner then
								if group.units[1]["type"] == "S-3B Tanker" or group.units[1]["type"] == "E-2C" then						-- cet endroit est bloqué par DCS pour ces 2 avions
									af_spawnOn("catapult", group.name)
									modify_Activate_GroupTime(group, -1, debug.getinfo(1).currentline)								--supprime le triger activate (vraiment?)
									-- modify_set_ai_task(group, -1, debug.getinfo(1).currentline) --supprime le triger start(vraiment?)
									group['tasks'] = {}
									break
								end
								if not placeOnSixPack_OK then
									group['route']['points'][1]["ETA"] = 0
									group['start_time'] = 0
									modify_Activate_GroupTime(group, -1, debug.getinfo(1).currentline) --supprime le triger activate(vraiment?)
									dbg("AtoFp SixPack Find "..group.name)
									breakloop = true
									placeOnSixPack_OK = true
								end
							end
						end
					elseif country.helicopter then
						for Ngroup, group in pairs(country.helicopter.group) do
							if group.name == sixpackWiner then
								group['route']['points'][1]["ETA"] = 0
								group['start_time'] = 0
								modify_Activate_GroupTime(group, -1, debug.getinfo(1).currentline)								--supprime le triger activate
								dbg("AtoFp SixPack Find "..group.name)
								breakloop = true
							end
						end
					end
				end
			end

			if breakloop or n > #sixPack then
				-- if sixPack[n]["client"] and SingleWithDServer then
				-- 	print()
				-- 	print("********************ATTENTION******************")
				-- 	print()
				-- 	print("        You MUST set the server to PAUSE")
				-- 	print("          (to appear on the SIXPACK) ")
				-- 	print()
				-- 	print("********************ATTENTION******************")
				-- 	print("ATTENTION")os.execute 'pause'


				-- elseif SingleWithDServer then	

				-- 	print()
				-- 	print("*****************************************ATTENTION***************************************************")
				-- 	print()
				-- 	print("				  You MUST set the server to RESUME ")
				-- 	print()
				-- 	print("(so that you don't appear on the Sixpack, you'd be annoying the AIs that will be driving before you) ")
				-- 	print()
				-- 	print("*****************************************ATTENTION***************************************************")
				-- 	print("ATTENTION") os.execute 'pause'
				-- end
			end

			n = n +1
		until breakloop or n > #sixPack
	end
end

if debugStart then AtoFP.debugTxt_AtoFP = AtoFP.debugTxt_AtoFP.. _afficheTXT(testDeckPlace, "testDeckPlace") end

-- nombre d'avion sur le pont total
-- limite le nombre d'avion sur le pont (permet de faire apparaitre les avions tardif, s'il y a de la place)
for cv, deckGroups in pairs(testDeckPlace) do

	if #deckGroups > 0 then

		table.sort(deckGroups, function(a,b) return a.time < b.time  end)
		if debugStart then AtoFP.debugTxt_AtoFP = AtoFP.debugTxt_AtoFP.. _afficheTXT(deckGroups, "testDeckPlace deck") end

		if cv_testSixPack[cv] and #cv_testSixPack[cv] > 0 then

			--cherche une place dispo sur le deck pour les avions tardif
			local counter = 0
			local testSomme = 0
			-- for n = 1 , #deckGroups do
			for groupN, deckGr in pairs(deckGroups) do
				if not deckGr.isHumain then
					repeat
						counter = counter +1

						local deckWiner = deckGr["groupName"]

						if not deckGr["LimitedParkNb"] then
							break
						else
							--enleve les 4 places du Sixpack
							--et aussi le nombre de place du pack client/joueur
							LimitedDeckNb = deckGr["LimitedParkNb"] - 4 - cv_nbPlanetDeck
						end

						dbg("AtoFp DeckWiner "..deckWiner)
						dbg("AtoFp DeckWiner "..tostring(deckGr["number"]) .." |LimitedDeckNb: "..tostring(LimitedDeckNb))

						testSomme = testSomme + deckGr["number"]
						dbg("AtoFp testSomme "..testSomme)
						if testSomme <= LimitedDeckNb and not deckGr["OnDeck"] then
							for _, side in pairs(mission.coalition) do
								for _, country in pairs(side.country) do
									if country.plane then
										for _, group in pairs(country.plane.group) do
											if group.name == deckWiner then
												group['uncontrolled'] = true
												group['lateActivation'] = true
												modify_Activate_GroupTime(group, 2, debug.getinfo(1).currentline)
												sommePlane[cv] = sommePlane[cv] + tonumber(deckGr["number"])
												deckGr["OnDeck"] = true
												dbg("AtoFp DeckWiner Find "..group.name.." +number: "..deckGr["number"])
											end
										end
									elseif country.helicopter then
										for _, group in pairs(country.helicopter.group) do
											if group.name ==  deckWiner then
												group['uncontrolled'] = true
												group['lateActivation'] = true
												modify_Activate_GroupTime(group, 2, debug.getinfo(1).currentline)
												sommePlane[cv] = sommePlane[cv] + tonumber(deckGr["number"])
												deckGr["OnDeck"] = true
												dbg("AtoFp DeckWiner Find "..group.name.." +number: "..deckGr["number"])
											end
										end
									end
								end
							end
						end

					until sommePlane[cv] >= LimitedDeckNb or counter >= 2
				end
			end
		end
	end
end

if debugStart then
	-- affiche  le timing des avions sur le pont/catapulte pour prévenir le/les joueurs que des IA seront dessus
	local tabNam = {}
	AtoFP.debugTxt_AtoFP = AtoFP.debugTxt_AtoFP.."\n"..("AtoFP startup_time_player: " ..FormatTime(mission_ini.startup_time_player, "hh:mm"))
	AtoFP.debugTxt_AtoFP = AtoFP.debugTxt_AtoFP.."\n"..("AtoFP NowTime: " ..FormatTime(camp.time, "hh:mm"))

	print("\n")
	if PlacePA and camp.player then
		for side , pPA in pairs(PlacePA) do
			if camp.player.side == side then
				for base , time_mn in pairs(pPA) do
					AtoFP.debugTxt_AtoFP = AtoFP.debugTxt_AtoFP.."\n"..(tostring(base).." taxiing schedule on the deck at ...")
					for s, name in PairsByKeys(time_mn) do

						if tabNam[name] ~= true then
							local catTime = camp.time + s
							AtoFP.debugTxt_AtoFP = AtoFP.debugTxt_AtoFP.."\n"..(" "..FormatTime(catTime, "hh:mm").. " - "..tostring(name).."\n")
							tabNam[name] = true
						end
					end
				end
			end
		end
	end
end


--ajoute les JTAC dans les triggers pour le fichier CTLD
-- modification M60_a		add CTLD
if mission_ini.load_CTLD then
	TableJTAC = {}
	for _side,side in pairs(mission.coalition) do
		for _country,country in pairs(side.country) do
			if country.vehicle then
				for Ngroup,group in pairs(country.vehicle.group) do
					if string.find(group.name, "JTAC") then

						TableJTAC[#TableJTAC+1] = {
							Predicate = "a_do_script",
							NameJTAC = group.name,
						}

					end
				end
			end
		end
	end

	if #TableJTAC >= 1 then
		AddFileTriggerTempo(nil, 10, "triggerOnce", TableJTAC)	-- modification M60 CTLD
	end
end
--ajoute les name helico dans la table CTLD transport
-- modification M60_a		add CTLD
-- ******************** Transports names **********************
-- Use any of the predefined names or set your own ones
-- ctld.transportPilotNames = {
    -- "helicargo1",
    -- "helicargo2",
    -- "helicargo3",

TableTransportPilotNames = {}
for _side,side in pairs(mission.coalition) do
	for _country, country in pairs(side.country) do
		if country.helicopter then
			for Ngroup, group in pairs(country.helicopter.group) do

				TableTransportPilotNames[#TableTransportPilotNames+1] = group.name

			end
		end
	end
end

if #TableTransportPilotNames >= 1 then
	camp["TableTransportPilotNames"] = TableTransportPilotNames	-- modification M60 CTLD
end


----- make a copy of player package for easy reference in briefing -----

if camp.player then
	if not camp.player.package then camp.player.package = {} end
	if not camp.player.package[camp.player.pack_n] then
		camp.player.package[camp.player.pack_n] = DeepCopy(ATO[camp.player.side][camp.player.pack_n])
	end

	--for multi-package strikes, add flights from other packages with the same target to player package to enrich the briefiing
	for p = 1, #ATO[camp.player.side] do										--iterate through packages in player side	
		for role,flight in pairs(ATO[camp.player.side][p]) do					--iterate through roles in package (main, SEAD, escort)		
			-- print("AtoFP role: "..role)
			for f = 1, #flight do												--iterate through flights in roles
				if flight[f].target_name == camp.player.target.titleName and camp.player.pack_n ~= p then	--flights that have the same target as player but are not in the player package
					table.insert(camp.player.package[camp.player.pack_n][role], DeepCopy(flight[f]))							--insert flight into player package to list it in player briefing
				end
			end
		end
	end
end


if camp.client then

	-- camp.client.pack = Deepcopy(ATO[camp.client.side][camp.client.pack_n])
	for c = 1, #camp.client do
		if not camp.client.package then camp.client.package = {} end
		if not camp.client.package[camp.client[c].pack_n] then
			camp.client.package[camp.client[c].pack_n] = DeepCopy(ATO[camp.client[c].side][camp.client[c].pack_n])	--pack_n
		end
	end

	local camp_str = "camp.client = " .. TableSerialization(camp.client, 0)						--make a string
	local campFile = io.open("Debug/CAMPclientBB.lua", "w")	 or error("Failed to open debug file")
	campFile:write(camp_str)																		--save new data
	campFile:close()

end


local function ShipFindByName(name)
	for coal_name,coal in pairs(oob_ground) do												--go through sides(red/blue)	
		for country_n,country in ipairs(coal) do											--go through countries
			if country.ship then															--country has ships
				for group_n,group in ipairs(country.ship.group) do							--go through groups
					for n = 1, #group.units do												--ship group found
						if name == group.units[n].name then
							return group.units[n]
						end
					end
				end
			end
		end
	end
end



-- modification M18.c despawn/destroy Plane on BaseAirStart
camp.BaseAirStart = tempBaseAirStart

-- local AtoFP.debugTxt_AtoFP = AtoFP.debugTxt_AtoFP
local debugGenMFile = io.open(AtoFP.LogPath("FlightPlan_FLIGHT_Debug.lua"), "w") or error("Failed to open debug file")
debugGenMFile:write(AtoFP.debugTxt_AtoFP)
debugGenMFile:close()

local camp_str = "TabLPark = " .. TableSerialization(TabLPark, 0)
local campFile = io.open("Debug/TabLPark_AtoFP.lua", "w") or error("Failed to open debug file")
campFile:write(camp_str)
campFile:close()

local testPosRunwayImpact = false

if testPosRunwayImpact then
	if not mission.coalition.blue.country[1].vehicle then
		mission.coalition.blue.country[1].vehicle.group = {}
	end

	mission_ini.PruneScriptConf.PruneScript  = false

	-- local nbGroup = #mission.coalition.country[1].vehicle.group
	for baseName, airbase in pairs(db_airbases) do
		if airbase.runways then

			for runwayN, runway in pairs(airbase.runways) do

				local tempTarget = {}
				tempTarget.db_airbaseName = baseName

				if runway.x and runway.x ~= 0 then
					-- print("AtoFP B baseName "..baseName)

					--pour la map caucasus
					if camp.theatre and (string.lower(camp.theatre)  == "caucasus" or string.lower(camp.theatre)  == "persiangulf") then
						local hdg = runway.hdg
						if not runway.true_hdg or runway.true_hdg == nil then
							hdg = runway.hdg + camp.variation
						end

						local runwayDecal  = GetOffsetPoint({x=runway.x, y=runway.y}, hdg+90, 30)

						runway.x = runwayDecal.x
						runway.y = runwayDecal.y

						local distance = 0
						local interval = runway.length / 9
						for e = 1, 8 do
							distance = distance + interval
							local newPos = GetOffsetPoint({x=runway.x, y=runway.y}, hdg, distance)
							if not tempTarget.elements then tempTarget.elements = {} end

							tempTarget.elements[#tempTarget.elements +1] = {
								name = tempTarget.db_airbaseName.." runway "..runway.name.." part "..e,
								x = newPos.x,
								y = newPos.y,
							}

						end

						-- _affiche(tempTarget.elements, "tempTarget.elements")
					else
						--pour la map Syria
						local hdg = runway.hdg
						if not runway.true_hdg or runway.true_hdg == nil then
							hdg = runway.hdg + camp.variation
						end
						local distance = 0
						local interval = runway.length / 9
						for e = 1, 4 do
							distance = distance + interval
							local newPos = GetOffsetPoint({x=runway.x, y=runway.y}, hdg, distance)
							if not tempTarget.elements then tempTarget.elements = {} end

							tempTarget.elements[#tempTarget.elements +1] = {
								name = tempTarget.db_airbaseName.." runway part "..e,
								x = newPos.x,
								y = newPos.y,
							}

						end
						hdg = hdg + 180

						distance = 0
						for e = 5, 8 do
							distance = distance + interval
							local newPos = GetOffsetPoint({x=runway.x, y=runway.y}, hdg, distance)
							if not tempTarget.elements then tempTarget.elements = {} end

							tempTarget.elements[#tempTarget.elements +1] = {
								name = tempTarget.db_airbaseName.." runway part "..e,
								x = newPos.x,
								y = newPos.y,
							}

						end
					end
				end

				local addGroup = {
					["visible"] = false,
					["tasks"] =
					{
					}, -- end of ["tasks"]
					["uncontrollable"] = false,
					["task"] = "Pas de sol",
					["taskSelected"] = true,
					["route"] =
					{
						["spans"] =
						{
						}, -- end of ["spans"]
						["points"] =
						{
							[1] =
							{
								-- ["alt"] = tonumber(target.z),
								["type"] = "Turning Point",
								["ETA"] = 0,
								["name"] = tostring(baseName).."_runway_"..runwayN,
								["alt_type"] = "BARO",
								["formation_template"] = "",
								["y"] = tonumber(runway.y),
								["x"] = tonumber(runway.x),
								["ETA_locked"] = true,
								["speed"] = 0,
								["action"] = "Off Road",
								["task"] =
								{
									["id"] = "ComboTask",
									["params"] =
									{
										["tasks"] =
										{
										},
									}, -- end of ["params"]
								}, -- end of ["task"]
								["speed_locked"] = true,
							}, -- end of [1]
						}, -- end of ["points"]
					}, -- end of ["route"]
					["groupId"] = GenerateIDGroup(),
					["hidden"] = false,

					["y"] = tonumber(runway.y),
					["x"] = tonumber(runway.x),
					["name"] = "Group_Runway_"..baseName.."_runway_"..runwayN,
					["start_time"] = 0,
				}

				print("AtoFP Ngroup AVANT   "..tostring(#mission.coalition.blue.country[1].vehicle.group))

				table.insert(mission.coalition.blue.country[1].vehicle.group, addGroup)
				local Ngroup = #mission.coalition.blue.country[1].vehicle.group

				print("AtoFP Ngroup APRES   "..tostring(#mission.coalition.blue.country[1].vehicle.group))

				if tempTarget.elements then
					print("AtoFP execute runway "..baseName.." "..tostring(Ngroup))

					for e, element in ipairs(tempTarget.elements) do
						print("AtoFP execute runway e "..tostring(e))
						-- _affiche(element, "AtoFP element")

						if not mission.coalition.blue.country[1].vehicle.group[Ngroup].units then mission.coalition.blue.country[1].vehicle.group[Ngroup].units = {} end
						local unitAdd =
						{

							["type"] = "Soldier M4",
							["unitId"] = GenerateIDUnit("AtoFP ".."UnitRunway_"..baseName.."_"..e, "Soldier M4"),
							["livery_id"] = "winter",
							["skill"] = "Average",
							["y"] = tonumber(element.y),
							["x"] = tonumber(element.x),
							["name"] = "UnitRunway_"..baseName.."_"..e,
							["heading"] = 0,
							["playerCanDrive"] = false,

						}


						table.insert(mission.coalition.blue.country[1].vehicle.group[Ngroup].units, unitAdd)
						-- print("AtoFP Nunits   "..tostring(#mission.coalition.blue.country[1].vehicle.group[Ngroup].units))
					end
				else
					DebugFLIGHT = DebugFLIGHT .. "\n"..("AtoFP bug runway "..baseName)
				end
			end
		end
	end
end


for _side, side in pairs(mission.coalition) do
	for countryN, country in pairs(side.country) do

		for category, groups in pairs(country) do

			if (category == "plane" or category == "helicopter" ) and type(groups) == "table" and groups["group"] then	--and groups[1].units
				for Ngroup, group in pairs(groups["group"]) do

					for pointN, point in pairs(group.route.points) do

						if not point.ETA_locked and not point.speed_locked then

							DebugFLIGHT = DebugFLIGHT .. "\n"..("AtoFP bug ETA and Speed not lock in "..pointN.." "..group.name)
						end
					end
				end
			end
		end
	end
end


local positionCentrale = {}
for _side, side in pairs(mission.coalition) do
	for countryN, country in pairs(side.country) do
		for category, groups in pairs(country) do
			if (category == "vehicule" or category == "static"  ) and type(groups) == "table" and groups["group"] then
				for Ngroup, group in pairs(groups["group"]) do
					if string.find(group.name, "ASTI") then
						positionCentrale.x = group.x
						positionCentrale.y = group.y
						positionCentrale.name = group.name
					end
				end
			end
		end
	end
end

-- --supprime les ["num"] = 1, des loadouts
-- --qui sont devenu inutile
-- for _, side in pairs(mission.coalition) do
-- 	for _, country in pairs(side.country) do
-- 		for _, groups in pairs(country) do
-- 			if type(groups) == "table" and groups["group"] then
-- 				for _, group in pairs(groups["group"]) do
-- 					for _, unit in pairs(group.units) do
-- 						if unit.payload and unit.payload.pylons  then
-- 							for _, pylon in pairs(unit.payload.pylons) do
-- 								if pylon and pylon.num then
-- 									pylon.num = nil
-- 								end
-- 							end
-- 						end
-- 					end
-- 				end
-- 			end
-- 		end
-- 	end
-- end



if Debug.debug then

	camp_str = "ATO_AtoFP = " .. TableSerialization(ATO, 0)						--make a string
	campFile = io.open("Debug/ATO_AtoFP.lua", "w")  or error("Failed to open debug file")
	campFile:write(camp_str)																		--save new data
	campFile:close()

	camp_str = "CommonFreq = " .. TableSerialization(CommonFreq, 0)						--make a string
	campFile = io.open("Debug/Radio_CommonFreq_FlightPlan.lua", "w")  or error("Failed to open debug file")
	campFile:write(camp_str)																		--save new data
	campFile:close()

	camp_str = "timingDeckCata = " .. TableSerialization(cv_deckReservations, 0)						--make a string
	campFile = io.open("Debug/CVN_timingDeckCata.lua", "w")  or error("Failed to open debug file")
	campFile:write(camp_str)																		--save new data
	campFile:close()

		camp_str = "testSixPack = " .. TableSerialization(cv_testSixPack, 0)						--make a string
	campFile = io.open("Debug/CVN_testSixPack.lua", "w")  or error("Failed to open debug file")
	campFile:write(camp_str)																		--save new data
	campFile:close()
	

	

	if camp.client then
		camp_str = "client = " .. TableSerialization(camp.client, 0)						--make a string
		campFile = io.open("Debug/camp_client_AtoFP.lua", "w")  or error("Failed to open debug file")
		campFile:write(camp_str)																		--save new data
		campFile:close()
	elseif camp.player then
		camp_str = "player = " .. TableSerialization(camp.player, 0)						--make a string
		campFile = io.open("Debug/camp_player_AtoFP.lua", "w")  or error("Failed to open debug file")
		campFile:write(camp_str)																		--save new data
		campFile:close()
	end

	-- _affiche(PlacePA, "AtoFp PlacePA")

	-- _affiche(channel_tacan, "Atofp channel_tacan ")

	-- _affiche(PointOfInterest, "Atofp PointOfInterest ")

end