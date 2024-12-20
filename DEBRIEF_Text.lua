--To create the Debriefing text for the mission
--Initiated by DEBRIEF_Master.lua
-------------------------------------------------------------------------------------------------------
-- last modification: cleancode_a adjustment_b
if not versionDCE then versionDCE = {} end
versionDCE["DEBRIEF_Text.lua"] = "1.4.4"
------------------------------------------------------------------------------------------------------- 
-- debug_a                  (a: neutral side) 
-- cleancode_a				(a springCleaning)
-- adjustment_b				(a priority numeric targetTable)
-- modification M61_a		SAR
------------------------------------------------------------------------------------------------------- 

Debriefing = ""

-- header ---------------------------------------------------------------------------------- 
do
	--mission number
	local s = "Mission " .. camp.mission

	--date
	s = s .. " - " .. FormatDate(camp.date.day, camp.date.month, camp.date.year) .. " (H+" .. camp.day .. "), " ..  FormatTime(camp.time, "hh:mm")

	--divider
	local divider_length = string.len(s)
	s = s .. "\n"
	for n = 1, divider_length do
		s = s .. "-"
	end

	Debriefing = Debriefing .. s .. "\n\n"
end


-- player package evaluation ---------------------------------------------------------------------------------- 
do

	local s = ""

	--function to build a list of the target and target element status
	local function targetStats(target_name)
		local t = ""

		local targetSelect = {}
		for targetN, target in ipairs(targetlist[camp.player.side]) do
			if target.titleName == target_name and  target.elements  then
				targetSelect = target
				break
			end
		end

		if targetSelect.elements then									--if the target is a scenery, vehicle or ship target
			local str_length = string.len(target_name)													--string lenght of target name
			for elementN, element in pairs(targetSelect.elements) do						--find string lenght of elements names to find the longest name for alignement of status amendment
				local ename = tostring(element.name)			--element name
				local i = string.find(ename, "#")													--position of # in string
				if i then
					if element.type then
						ename = element.type
					else
						ename = string.sub(ename, 0, i - 1) 											--only display part of element name before #
					end
				end
				if string.len(ename) + 2 > str_length then
					str_length = string.len(ename) + 2
				end
			end

			t = t .. target_name																	--Target name
			local space = str_length + 3 - string.len(target_name)									--calculate number of spaces that need to be added for alignement (string length of largest + 3 - length of current entry = number of spaces)
			for m = 1, space do
				t = t .. " "																		--add one space for every missing letter
			end
			t = t .. "(" .. tostring(targetSelect.alive) .. "%)\n"				--Target percentage of alive sub-elements 

			for elementN, element in ipairs(targetSelect.elements) do						--list all target elements
				local ename = element.name			--element name
				local i = string.find(ename, "#")													--position of # in string
				if i then
					if element.type then
						ename = element.type
					else
						ename = string.sub(ename, 0, i - 1) 											--only display part of element name before #
					end
				end
				t = t .. "- " .. ename
				space = str_length + 3 - string.len("- " .. ename)									--calculate number of spaces that need to be added for alignement (string length of largest + 3 - length of current entry = number of spaces)
				for m = 1, space do
					t = t .. " "																	--add one space for every missing letter
				end

				if camp.ShipHealth and camp.ShipHealth[ename] then														--element is a ship that took damage
					if camp.ShipHealth[ename] == 0 then												--ship is sunk
						t = t .. "(sunk)"
					elseif camp.ShipHealth[ename] < 33 then											--ship has less than 33% health
						t = t .. "(heavy damage)"
					elseif camp.ShipHealth[ename] < 66 then											--ship has less than 66% health
						t = t .. "(moderate damage)"
					elseif camp.ShipHealth[ename] < 100 then										--ship has less than 100% health
						t = t .. "(light damage)"
					end
					if camp.ShipDamagedLast[ename] then												--ship has taken damage in last mission
						t = t .. " (+)\n"
					else
						t = t .. "\n"																--make new line
					end
				elseif element.dead == true and element.dead_last then			--if the target element is destroyed in this mission
					t = t .. "(destroyed)(+)\n"														--mark as destroyed and make new line
				elseif element.dead == true then		--if the target element is destroyed in previous missions
					t = t .. "(destroyed)\n"														--mark as destroyed and make new line
				else
					t = t .. "\n"																	--make new line
				end
			end
			t = t .. "\n"
		end
		return t
	end



	--################################################################################
	--################################################################################


	--function to build a list of stats of all aircraft within a package
	local function packageStats()
		local t = "Package:\n"

		--define list entries
		local entries = {
			[1] = {
				header = "Callsign",
				values = {},
			},
			[2] = {
				header = "Type",
				values = {},
			},
			[3] = {
				header = "Task",
				values = {},
			},
			[4] = {
				header = "Kills Air",
				values = {},
			},
			[5] = {
				header = "Kills Ground",
				values = {},
			},
			[6] = {
				header = "Kills Ship",
				values = {},
			},
			[7] = {
				header = "Lost",
				values = {},
			},
			[8] = {
				header = "",
				values = {},
			},
		}
		--add list values
		local campPlayerData 

		if camp.client then
			campPlayerData = camp.client[1].pack
		elseif camp.player then
			campPlayerData = camp.player
		end

		for role_name, role in pairs(camp.player.pack) do
		-- for role_name, role in pairs(campPlayerData) do
			-- print("role_name "..role_name)
			for flight_n, flight in ipairs(role) do
				-- print("flight_n "..flight_n)
				for n = 1, flight.number do
					local unit_name = "Pack " .. camp.player.pack_n .. " - " .. flight.name .. " - " .. flight.task .. " " .. flight_n .. "-" .. n
					-- print("unit_name "..unit_name.." kills_air "..packstats[unit_name].kills_air)
					-- local unit_name = flight.name
					local callsign = string.sub(flight.callsign, 1, -2) .. n
					table.insert(entries[1].values, callsign)
					table.insert(entries[2].values, ReplaceTypeName(flight.type))
					table.insert(entries[3].values, flight.task)
					table.insert(entries[4].values, packstats[unit_name].kills_air)
					table.insert(entries[5].values, packstats[unit_name].kills_ground)
					table.insert(entries[6].values, packstats[unit_name].kills_ship)
					table.insert(entries[7].values, packstats[unit_name].lost)
					if flight.player and n == 1 then
						table.insert(entries[8].values, "(Player)")
					else
						table.insert(entries[8].values, "")
					end
				end
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
			t = t .. entries[e].header																--add header
			if e < #entries then																	--if this is not the last header, add spaces to the next header	
				local space = entries[e].str_length + 5 - string.len(entries[e].header)				--calculate number of spaces that need to be added for alignement (string length of largest entry of same type + 3 - length of current entry = number of spaces)
				for m = 1, space do
					t = t .. " "																	--add one space for every missing letter
				end
			end
		end
		t = t .. "\n"

		--build the list		
		for n = 1, #entries[1].values do															--iterate through number of values (number of units)
			for e = 1, #entries do																	--iterate through entries
				local writeValue = entries[e].values[n]
				if entries[e].values[n] == 0 then writeValue = "-" end
				t = t .. writeValue														--add value to list
				if e < #entries then																--if this is not the last header, add spaces to the next header	
					local space = entries[e].str_length + 5 - string.len(tostring(writeValue))	--calculate number of spaces that need to be added for alignement (string length of largest entry of same type + 3 - length of current entry = number of spaces)
					for m = 1, space do
						t = t .. " "																--add one space for every missing letter
					end
				end
			end
			t = t .. "\n"																			--make a new line after each unit
		end

		return t
	end

	--################################################################################
	--################################################################################





	local player_task = camp.player.pack[camp.player.role][camp.player.flight].task								--player task
	local target_name = camp.player.pack[camp.player.role][camp.player.flight].target_name						--name of player package target

	local target_alive = 0
	local target_hit = 0
	local targetSelect = {}
	for targetN, target in ipairs(targetlist[camp.player.side]) do
		if target.titleName == target_name and  target.elements  then
			target_alive = target.alive
			target_hit = target.dead_last
			targetSelect = target
			break
		end
	end

	-- local target_alive = targetlist[camp.player.side][target_name].alive										--alive percentage of player package target (if applicable)
	-- local target_hit = targetlist[camp.player.side][target_name].dead_last										--percentage destroyed in this mission
	local target_class = camp.player.pack[camp.player.role][camp.player.flight].target.class					--target class

	local pack_kills_air = 0
	local pack_kills_ground = 0
	local pack_kills_ship = 0
	local pack_lost = 0
	for k,v in pairs(packstats) do
		pack_kills_air = pack_kills_air + v.kills_air
		pack_kills_ground = pack_kills_ground + v.kills_ground
		pack_kills_ship = pack_kills_ship + v.kills_ship
		pack_lost = pack_lost + v.lost
	end


	--CAP
	if player_task == "CAP" then
		s = s .. "You have been tasked to perform a Combat Air Patrol at " .. target_name .. ". "
		if pack_kills_air == 0 then
			if pack_lost == 0 then
				s = s .. "Your package has not scored any kills nor sustained any losses.\n\n"
			else
				s = s .. "Your package has sustained " .. pack_lost .. " losses without scoring any kills.\n\n"
			end
		else
			if pack_lost == 0 then
				s = s .. "Your package has scored " .. pack_kills_air .. " air-air kills against no own losses.\n\n"
			else
				s = s .. "Your package has scored " .. pack_kills_air .. " air-air kills while sustaining " .. pack_lost .. " losses.\n\n"
			end
		end
		s = s .. packageStats() .. "\n\n"																			--add stats list for each aircraft in package

	--Intercept
	elseif player_task == "Intercept" then
		s = s .. "You have been tasked to perform an Intercept mission from " .. camp.player.target.base .. ". "
		if pack_kills_air == 0 then
			if pack_lost == 0 then
				s = s .. "Your package has not scored any kills nor sustained any losses.\n\n"
			else
				s = s .. "Your package has sustained " .. pack_lost .. " losses without scoring any kills.\n\n"
			end
		else
			if pack_lost == 0 then
				s = s .. "Your package has scored " .. pack_kills_air .. " air-air kills against no own losses.\n\n"
			else
				s = s .. "Your package has scored " .. pack_kills_air .. " air-air kills while sustaining " .. pack_lost .. " losses.\n\n"
			end
		end
		s = s .. packageStats() .. "\n\n"																			--add stats list for each aircraft in package
	--SAR
	elseif player_task == "SAR" then
		s = s .. "Add txt here "
	--SAR
	elseif player_task == "CSAR" then
	s = s .. "Add txt here "
	--Fighter Sweep
	elseif player_task == "Fighter Sweep" then
		s = s .. "You have been tasked to perform a Fighter Sweep in the area of " .. target_name .. ". "
		if pack_kills_air == 0 then
			if pack_lost == 0 then
				s = s .. "Your package has not scored any kills nor sustained any losses.\n\n"
			else
				s = s .. "Your package has sustained " .. pack_lost .. " losses without scoring any kills.\n\n"
			end
		else
			if pack_lost == 0 then
				s = s .. "Your package has scored " .. pack_kills_air .. " air-air kills against no own losses.\n\n"
			else
				s = s .. "Your package has scored " .. pack_kills_air .. " air-air kills while sustaining " .. pack_lost .. " losses.\n\n"
			end
		end
		s = s .. packageStats() .. "\n\n"																			--add stats list for each aircraft in package

	--Airbase Strike
	elseif target_class == "airbase" then
		local target_unit_name = camp.player.pack[camp.player.role][camp.player.flight].target.unit.name

		if player_task == "Strike" then
			s = s .. "You have been tasked with striking " .. target_name .. " hosting " .. ReplaceTypeName(camp.player.pack[camp.player.role][camp.player.flight].target.unit.type) .. " of the " .. target_unit_name .. ". "
		elseif player_task == "Escort" then
			s = s .. "You have been tasked with escorting a strike against " .. target_name .. " hosting " .. ReplaceTypeName(camp.player.pack[camp.player.role][camp.player.flight].target.unit.type) .. " of the " .. target_unit_name .. ". "
		elseif player_task == "SEAD" then
			s = s .. "You have been tasked with providing SEAD escort for a strike against " .. target_name .. " hosting " .. ReplaceTypeName(camp.player.pack[camp.player.role][camp.player.flight].target.unit.type) .. " of the " .. target_unit_name .. ". "
		elseif player_task == "Escort Jammer" then
			s = s .. "You have been tasked with providing jammer escort for a strike against " .. target_name .. " hosting " .. ReplaceTypeName(camp.player.pack[camp.player.role][camp.player.flight].target.unit.type) .. " of the " .. target_unit_name .. ". "
		elseif player_task == "Flare Illumination" then
			s = s .. "You have been tasked with providing battlefield flare illumination for a strike against " .. target_name .. " hosting " .. ReplaceTypeName(camp.player.pack[camp.player.role][camp.player.flight].target.unit.type) .. " of the " .. target_unit_name .. ". "
		elseif player_task == "Laser Illumination" then
			s = s .. "You have been tasked with providing target laser designation for a strike against " .. target_name .. " hosting " .. ReplaceTypeName(camp.player.pack[camp.player.role][camp.player.flight].target.unit.type) .. " of the " .. target_unit_name .. ". "
		end

		if pack_kills_air > 0 then
			for side_name,side in pairs(oob_air) do
				for unit_n,unit in ipairs(side) do
					if unit.name == target_unit_name then												--find target unit oob_air entry
						if unit.score_last.lost > 0 and unit.score_last.damaged > 0 then				--target unit has losses and damages in last mission
							s = s .. "The " .. target_unit_name .. " has suffered " .. unit.score_last.lost .. " aircraft lost and " .. unit.score_last.damaged .. " aircraft damaged. "
						elseif unit.score_last.lost > 0 then											--target unit has losses in last mission
							s = s .. "The " .. target_unit_name .. " has suffered " .. unit.score_last.lost .. " aircraft lost. "
						elseif unit.score_last.damaged > 0 then											--target unit has damages in last mission
							s = s .. "The " .. target_unit_name .. " has suffered " .. unit.score_last.damaged .. " aircraft damaged. "
						else																			--target unit has no losses or damages in last mission
							s = s .. "The " .. target_unit_name .. " has not sustained any damage. "
						end
						if unit.roster.ready > 0 then
							s = s .. "It retains " .. unit.roster.ready .. " aircraft ready for operations.\n\n"
						else
							if unit.roster.damaged > 0 then
								s = s .. "It retains no undamaged aircraft ready for immediate operations.\n\n"
							else
								s = s .. "It retains no additional aircraft and has been completely disabled.\n\n"
							end
						end
					end
				end
			end
			if pack_lost == 0 then
				s = s .. "Your package has scored " .. pack_kills_air .. " aircraft destroyed against no own losses.\n\n"
			else
				s = s .. "Your package has scored " .. pack_kills_air .. " aircraft destroyed while sustaining " .. pack_lost .. " losses.\n\n"
			end
		else
			if pack_lost == 0 then
				s = s .. "Your package has not achieved to destroy any enemy aircraft.\n\n"
			else
				s = s .. "Your package has sustained " .. pack_lost .. " losses without destroying any aircraft.\n\n"
			end
		end
		s = s .. packageStats() .. "\n\n"																			--add stats list for each aircraft in package

	--Strike
	elseif player_task == "Strike" then
		s = s .. "You have been tasked with striking " .. target_name

		local ship_hit
		-- if targetlist[camp.player.side][target_name].elements then
		-- 	for e = 1, #targetlist[camp.player.side][target_name].elements do
		-- 		if camp.ShipDamagedLast and camp.ShipDamagedLast[targetlist[camp.player.side][target_name].elements[e].name] then
		-- 			ship_hit = true
		-- 			break
		-- 		end
		-- 	end
		-- end

		if targetSelect.elements then
			for e = 1, #targetSelect.elements do
				if camp.ShipDamagedLast and camp.ShipDamagedLast[targetSelect.elements[e].name] then
					ship_hit = true
					break
				end
			end
		end

		if ship_hit then
			s = s .. ". The target has been hit and has taken damage.\n\n"
		elseif target_hit > 0 then
			s = s .. ". The target has been hit and sustained " .. target_hit .. "% damage. "
			if target_alive > 0 then
				s = s .. target_name .. " remains " .. target_alive .. "% intact.\n\n"
			else
				s = s .. target_name .. " has been completely destroyed.\n\n"
			end
		else
			s = s .. " but were unable to inflict any damage. " .. target_name .. " remains " .. target_alive .. "% intact.\n\n"
		end

		--list the target
		s = s .. targetStats(target_name)

		--air-air stats
		if pack_kills_air == 0 then
			if pack_lost == 0 then
				s = s .. "Your package has not scored any air-air kills nor sustained any losses.\n\n"
			else
				s = s .. "Your package has sustained " .. pack_lost .. " losses without scoring any air-air kills.\n\n"
			end
		else
			if pack_lost == 0 then
				s = s .. "Your package has scored " .. pack_kills_air .. " air-air kills against no own losses.\n\n"
			else
				s = s .. "Your package has scored " .. pack_kills_air .. " air-air kills while sustaining " .. pack_lost .. " losses.\n\n"
			end
		end
		s = s .. packageStats() .. "\n\n"																			--add stats list for each aircraft in package

	--Anti-ship Strike
	elseif player_task == "Anti-ship Strike" then
		s = s .. "You have been tasked with an anti-ship strike against "  .. target_name

		local ship_hit
		-- if targetlist[camp.player.side][target_name].elements then
		-- 	for e = 1, #targetlist[camp.player.side][target_name].elements do
		-- 		if camp.ShipDamagedLast and camp.ShipDamagedLast[targetlist[camp.player.side][target_name].elements[e].name] then
		-- 			ship_hit = true
		-- 			break
		-- 		end
		-- 	end
		-- end

		if targetSelect.elements then
			for e = 1, #targetSelect.elements do
				if camp.ShipDamagedLast and camp.ShipDamagedLast[targetSelect.elements[e].name] then
					ship_hit = true
					break
				end
			end
		end

		if ship_hit then
			s = s .. ". The target has been hit and has taken damage.\n\n"
		elseif target_hit > 0 then
			s = s .. ". The target has been hit and sustained " .. target_hit .. "% damage. "
			if target_alive > 0 then
				s = s .. target_name .. " remains " .. target_alive .. "% intact.\n\n"
			else
				s = s .. target_name .. " has been completely destroyed.\n\n"
			end
		else
			s = s .. " but were unable to inflict any damage. " .. target_name .. " remains " .. target_alive .. "% intact.\n\n"
		end

		--list the target
		s = s .. targetStats(target_name)

		--air-air stats
		if pack_kills_air == 0 then
			if pack_lost == 0 then
				s = s .. "Your package has not scored any air-air kills nor sustained any losses.\n\n"
			else
				s = s .. "Your package has sustained " .. pack_lost .. " losses without scoring any air-air kills.\n\n"
			end
		else
			if pack_lost == 0 then
				s = s .. "Your package has scored " .. pack_kills_air .. " air-air kills against no own losses.\n\n"
			else
				s = s .. "Your package has scored " .. pack_kills_air .. " air-air kills while sustaining " .. pack_lost .. " losses.\n\n"
			end
		end
		s = s .. packageStats() .. "\n\n"																			--add stats list for each aircraft in package

	--Escort
	elseif player_task == "Escort" then
		if target_class == "airbase" then
			s = s .. "You have been tasked with escorting a strike against " .. targetSelect.name .. ".\n\n"
		elseif targetSelect.task == "Reconnaissance" then
			s = s .. "You have been tasked with escorting a recon mission " .. targetSelect.text .. ".\n\n"
		else
			s = s .. "You have been tasked with escorting a strike against " .. target_name

			local ship_hit
			-- if targetlist[camp.player.side][target_name].elements then
			-- 	for e = 1, #targetlist[camp.player.side][target_name].elements do
			-- 		if camp.ShipDamagedLast and camp.ShipDamagedLast[targetlist[camp.player.side][target_name].elements[e].name] then
			-- 			ship_hit = true
			-- 			break
			-- 		end
			-- 	end
			-- end
			if targetSelect.elements then
				for e = 1, #targetSelect.elements do
					if camp.ShipDamagedLast and camp.ShipDamagedLast[targetSelect.elements[e].name] then
						ship_hit = true
						break
					end
				end
			end

			if ship_hit then
				s = s .. ". The target has been hit and has taken damage.\n\n"
			elseif target_hit > 0 then
				s = s .. ". The target has been hit and sustained " .. target_hit .. "% damage. "
				if target_alive > 0 then
					s = s .. target_name .. " remains " .. target_alive .. "% intact.\n\n"
				else
					s = s .. target_name .. " has been completely destroyed.\n\n"
				end
			else
				s = s .. ". No damage was inflicted. " .. target_name .. " remains " .. tostring(target_alive) .. "% intact.\n\n"
			end

			--list the target
			s = s .. targetStats(target_name)
		end

		--air-air stats
		if pack_kills_air == 0 then
			if pack_lost == 0 then
				s = s .. "Your package has not scored any air-air kills nor sustained any losses.\n\n"
			else
				s = s .. "Your package has sustained " .. pack_lost .. " losses without scoring any air-air kills.\n\n"
			end
		else
			if pack_lost == 0 then
				s = s .. "Your package has scored " .. pack_kills_air .. " air-air kills against no own losses.\n\n"
			else
				s = s .. "Your package has scored " .. pack_kills_air .. " air-air kills while sustaining " .. pack_lost .. " losses.\n\n"
			end
		end
		s = s .. packageStats() .. "\n\n"																			--add stats list for each aircraft in package

	--SEAD
	elseif player_task == "SEAD" then
		if target_class == "airbase" then
			s = s .. "You have been tasked with providing SEAD escort for a strike against " .. targetSelect.name .. ".\n\n"
		elseif targetSelect.task == "Reconnaissance" then
			s = s .. "You have been tasked with providing SEAD escort for a recon mission " .. targetSelect.text .. ".\n\n"
		else
			s = s .. "You have been tasked with providing SEAD escort for a strike against " .. target_name

			local ship_hit
			-- if targetlist[camp.player.side][target_name].elements then
			-- 	for e = 1, #targetlist[camp.player.side][target_name].elements do
			-- 		if camp.ShipDamagedLast and camp.ShipDamagedLast[targetlist[camp.player.side][target_name].elements[e].name] then
			-- 			ship_hit = true
			-- 			break
			-- 		end
			-- 	end
			-- end
			if targetSelect.elements then
				for e = 1, #targetSelect.elements do
					if camp.ShipDamagedLast and camp.ShipDamagedLast[targetSelect.elements[e].name] then
						ship_hit = true
						break
					end
				end
			end

			if ship_hit then
				s = s .. ". The target has been hit and has taken damage.\n\n"
			elseif target_hit > 0 then
				s = s .. ". The target has been hit and sustained " .. target_hit .. "% damage. "
				if target_alive > 0 then
					s = s .. target_name .. " remains " .. target_alive .. "% intact.\n\n"
				else
					s = s .. target_name .. " has been completely destroyed.\n\n"
				end
			else
				s = s .. ". No damage was inflicted. " .. target_name .. " remains " .. target_alive .. "% intact.\n\n"
			end

			--list the target
			s = s .. targetStats(target_name)
		end

		--air-air stats
		if pack_kills_air == 0 then
			if pack_lost == 0 then
				s = s .. "Your package has not scored any air-air kills nor sustained any losses.\n\n"
			else
				s = s .. "Your package has sustained " .. pack_lost .. " losses without scoring any air-air kills.\n\n"
			end
		else
			if pack_lost == 0 then
				s = s .. "Your package has scored " .. pack_kills_air .. " air-air kills against no own losses.\n\n"
			else
				s = s .. "Your package has scored " .. pack_kills_air .. " air-air kills while sustaining " .. pack_lost .. " losses.\n\n"
			end
		end
		s = s .. packageStats() .. "\n\n"																			--add stats list for each aircraft in package

	--Escort Jammer
	elseif player_task == "Escort Jammer" then
		if targetSelect.task == "Reconnaissance" then
			s = s .. "You have been tasked with providing jammer escort for a recon mission " .. targetSelect.text .. ".\n\n"
		else
			s = s .. "You have been tasked with providing jammer escort for a strike against " .. target_name

			local ship_hit
			-- if targetlist[camp.player.side][target_name].elements then
			-- 	for e = 1, #targetlist[camp.player.side][target_name].elements do
			-- 		if camp.ShipDamagedLast and camp.ShipDamagedLast[targetlist[camp.player.side][target_name].elements[e].name] then
			-- 			ship_hit = true
			-- 			break
			-- 		end
			-- 	end
			-- end
			if targetSelect.elements then
				for e = 1, #targetSelect.elements do
					if camp.ShipDamagedLast and camp.ShipDamagedLast[targetSelect.elements[e].name] then
						ship_hit = true
						break
					end
				end
			end

			if ship_hit then
				s = s .. ". The target has been hit and has taken damage.\n\n"
			elseif target_hit > 0 then
				s = s .. ". The target has been hit and sustained " .. target_hit .. "% damage. "
				if target_alive > 0 then
					s = s .. target_name .. " remains " .. target_alive .. "% intact.\n\n"
				else
					s = s .. target_name .. " has been completely destroyed.\n\n"
				end
			else
				s = s .. ". No damage was inflicted. " .. target_name .. " remains " .. target_alive .. "% intact.\n\n"
			end

			--list the target
			s = s .. targetStats(target_name)
		end

		--air-air stats
		if pack_kills_air == 0 then
			if pack_lost == 0 then
				s = s .. "Your package has not scored any air-air kills nor sustained any losses.\n\n"
			else
				s = s .. "Your package has sustained " .. pack_lost .. " losses without scoring any air-air kills.\n\n"
			end
		else
			if pack_lost == 0 then
				s = s .. "Your package has scored " .. pack_kills_air .. " air-air kills against no own losses.\n\n"
			else
				s = s .. "Your package has scored " .. pack_kills_air .. " air-air kills while sustaining " .. pack_lost .. " losses.\n\n"
			end
		end
		s = s .. packageStats() .. "\n\n"																			--add stats list for each aircraft in package

	--Flare Illumination
	elseif player_task == "Flare Illumination" then
		if targetSelect.task == "Reconnaissance" then
			s = s .. "You have been tasked with providing battlefield flare illumination for a recon mission " .. targetSelect.text .. ".\n\n"
		else
			s = s .. "You have been tasked with providing battlefield flare illumination for a strike against " .. target_name

			local ship_hit
			-- if targetlist[camp.player.side][target_name].elements then
			-- 	for e = 1, #targetlist[camp.player.side][target_name].elements do
			-- 		if camp.ShipDamagedLast and camp.ShipDamagedLast[targetlist[camp.player.side][target_name].elements[e].name] then
			-- 			ship_hit = true
			-- 			break
			-- 		end
			-- 	end
			-- end
			if targetSelect.elements then
				for e = 1, #targetSelect.elements do
					if camp.ShipDamagedLast and camp.ShipDamagedLast[targetSelect.elements[e].name] then
						ship_hit = true
						break
					end
				end
			end

			if ship_hit then
				s = s .. ". The target has been hit and has taken damage.\n\n"
			elseif target_hit > 0 then
				s = s .. ". The target has been hit and sustained " .. target_hit .. "% damage. "
				if target_alive > 0 then
					s = s .. target_name .. " remains " .. target_alive .. "% intact.\n\n"
				else
					s = s .. target_name .. " has been completely destroyed.\n\n"
				end
			else
				s = s .. ". No damage was inflicted. " .. target_name .. " remains " .. target_alive .. "% intact.\n\n"
			end

			--list the target
			s = s .. targetStats(target_name)
		end

		--air-air stats
		if pack_kills_air == 0 then
			if pack_lost == 0 then
				s = s .. "Your package has not scored any air-air kills nor sustained any losses.\n\n"
			else
				s = s .. "Your package has sustained " .. pack_lost .. " losses without scoring any air-air kills.\n\n"
			end
		else
			if pack_lost == 0 then
				s = s .. "Your package has scored " .. pack_kills_air .. " air-air kills against no own losses.\n\n"
			else
				s = s .. "Your package has scored " .. pack_kills_air .. " air-air kills while sustaining " .. pack_lost .. " losses.\n\n"
			end
		end
		s = s .. packageStats() .. "\n\n"																			--add stats list for each aircraft in package

	--Laser Illumination
	elseif player_task == "Laser Illumination" then
		if targetSelect.task == "Reconnaissance" then
			s = s .. "You have been tasked with providing target laser designation for a recon mission " .. targetSelect.text .. ".\n\n"
		else
			s = s .. "You have been tasked with providing target laser designation for a strike against " .. target_name

			local ship_hit
			-- if targetlist[camp.player.side][target_name].elements then
			-- 	for e = 1, #targetlist[camp.player.side][target_name].elements do
			-- 		if camp.ShipDamagedLast and camp.ShipDamagedLast[targetlist[camp.player.side][target_name].elements[e].name] then
			-- 			ship_hit = true
			-- 			break
			-- 		end
			-- 	end
			-- end
			if targetSelect.elements then
				for e = 1, #targetSelect.elements do
					if camp.ShipDamagedLast and camp.ShipDamagedLast[targetSelect.elements[e].name] then
						ship_hit = true
						break
					end
				end
			end

			if ship_hit then
				s = s .. ". The target has been hit and has taken damage.\n\n"
			elseif target_hit > 0 then
				s = s .. ". The target has been hit and sustained " .. target_hit .. "% damage. "
				if target_alive > 0 then
					s = s .. target_name .. " remains " .. target_alive .. "% intact.\n\n"
				else
					s = s .. target_name .. " has been completely destroyed.\n\n"
				end
			else
				s = s .. ". No damage was inflicted. " .. target_name .. " remains " .. target_alive .. "% intact.\n\n"
			end

			--list the target
			s = s .. targetStats(target_name)
		end

		--air-air stats
		if pack_kills_air == 0 then
			if pack_lost == 0 then
				s = s .. "Your package has not scored any air-air kills nor sustained any losses.\n\n"
			else
				s = s .. "Your package has sustained " .. pack_lost .. " losses without scoring any air-air kills.\n\n"
			end
		else
			if pack_lost == 0 then
				s = s .. "Your package has scored " .. pack_kills_air .. " air-air kills against no own losses.\n\n"
			else
				s = s .. "Your package has scored " .. pack_kills_air .. " air-air kills while sustaining " .. pack_lost .. " losses.\n\n"
			end
		end
		s = s .. packageStats() .. "\n\n"																			--add stats list for each aircraft in package

	--Reconnaissance
	elseif player_task == "Reconnaissance" then
		s = s .. "You have been tasked with reconnaissance of " .. target_name .. ".\n\n"
		s = s .. packageStats() .. "\n\n"																			--add stats list for each aircraft in package

	--AWACAS
	elseif player_task == "AWACS" then
		s = s .. "You have been tasked with an AWACS patrol at " .. target_name .. ".\n\n"
		s = s .. packageStats() .. "\n\n"																			--add stats list for each aircraft in package

	--Refuelling
	elseif player_task == "Refueling" then
		s = s .. "You have been tasked with a refuelling mission at " .. target_name .. ".\n\n"
		s = s .. packageStats() .. "\n\n"																			--add stats list for each aircraft in package

	--Transport
	elseif player_task == "Transport" then
		local from = camp.player.pack[camp.player.role][camp.player.flight].target.base
		local to = camp.player.pack[camp.player.role][camp.player.flight].target.destination
		s = s .. "You have been tasked with a transport  mission from " .. from .. " to " .. to .. ".\n\n"
		s = s .. packageStats() .. "\n\n"																			--add stats list for each aircraft in package

	--Ferry/Nothing
	elseif player_task == "Nothing" then
		local from = camp.player.pack[camp.player.role][camp.player.flight].target.base
		local to = camp.player.pack[camp.player.role][camp.player.flight].target.destination
		s = s .. "You have been tasked with a ferry flight from " .. from .. " to " .. to .. ".\n\n"
		s = s .. packageStats() .. "\n\n"																			--add stats list for each aircraft in package

	end

	Debriefing = Debriefing .. s ..  "\n"
end


-- Order of Battle Air ---------------------------------------------------------------------------------- 
do
	local s = "Order of Battle:\n----------------\n\n"												--make lists of the air order of battle for all sides

	local entries = {}
	for side_name,side in pairs(oob_air) do															--iterate through sides in oob_air

		--define list entries
		entries[side_name] = {
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
				header = "Kills Air",
				values = {},
			},
			[5] = {
				header = "Kills Ground",
				values = {},
			},
			[6] = {
				header = "Kills Ship",
				values = {},
			},
			[7] = {
				header = "Lost",
				values = {},
			},
			[8] = {
				header = "Damaged",
				values = {},
			},
			[9] = {
				header = "Ready",
				values = {},
			},
		}

		--add list values
		for unit_n,unit in ipairs(side) do																								--iterate through units
			if unit.inactive ~= true then																								--unit is active
				table.insert(entries[side_name][1].values, unit.name)																	--unit name
				table.insert(entries[side_name][2].values, ReplaceTypeName(unit.type))													--unit type
				table.insert(entries[side_name][3].values, ReplaceBaseName(unit.base))																	--unit base
				if unit.score_last.kills_air > 0 then
					table.insert(entries[side_name][4].values, unit.score.kills_air .. " (+" .. unit.score_last.kills_air .. ")")		--unit air kills plus score from this mission
				else
					table.insert(entries[side_name][4].values, unit.score.kills_air)													--unit air kills
				end
				if unit.score_last.kills_ground > 0 then
					table.insert(entries[side_name][5].values, unit.score.kills_ground .. " (+" .. unit.score_last.kills_ground .. ")")	--unit ground kills plus score from this mission
				else
					table.insert(entries[side_name][5].values, unit.score.kills_ground)													--unit ground kills
				end
				if unit.score_last.kills_ship > 0 then
					table.insert(entries[side_name][6].values, unit.score.kills_ship .. " (+" .. unit.score_last.kills_ship .. ")")		--unit ship kills plus score from this mission
				else
					table.insert(entries[side_name][6].values, unit.score.kills_ship)													--unit ship kills
				end
				if unit.score_last.lost > 0 then
					table.insert(entries[side_name][7].values, unit.roster.lost .. " (+" .. unit.score_last.lost .. ")")				--unit losses plus score from this mission
				else
					table.insert(entries[side_name][7].values, unit.roster.lost)														--unit losses
				end
				if unit.score_last.damaged > 0 then
					table.insert(entries[side_name][8].values, unit.roster.damaged .. " (+" .. unit.score_last.damaged .. ")")			--unit damaged aircraft plus score from this mission
				else
					table.insert(entries[side_name][8].values, unit.roster.damaged)														--unit damaged aircraft
				end
				if unit.score_last.ready > 0 then
					table.insert(entries[side_name][9].values, unit.roster.ready .. " (-" .. unit.score_last.ready .. ")")				--unit ready aircraft plus score from this mission
				else
					table.insert(entries[side_name][9].values, unit.roster.ready)														--unit ready aircraft
				end
			end
		end
	end

	--determine maximum string length for each entry
	for e = 1, #entries["blue"] do																	--iterate through entries
		entries["blue"][e].str_length = string.len(entries["blue"][e].header)						--store string length of header for this entry
		entries["red"][e].str_length = string.len(entries["red"][e].header)							--store string length of header for this entry
		for n = 1, #entries["blue"][e].values do													--iterate through values of this entry
			local l = ReplaceTypeName(string.len(tostring(entries["blue"][e].values[n])))			--get string length of value of this entry
			if l > entries["blue"][e].str_length then												--if the string length is larger than the previous
				entries["blue"][e].str_length = l													--make it the new length (find the largest)
				entries["red"][e].str_length = l													--make it the new length (find the largest)
			end
		end
		for n = 1, #entries["red"][e].values do														--iterate through values of this entry
			local l = ReplaceTypeName(string.len(tostring(entries["red"][e].values[n])))			--get string length of value of this entry
			if l > entries["red"][e].str_length then												--if the string length is larger than the previous
				entries["blue"][e].str_length = l													--make it the new length (find the largest)
				entries["red"][e].str_length = l													--make it the new length (find the largest)
			end
		end
	end

	--build list
	for side_name,side in pairs(entries) do															--iterate through sides in oob_air
		if side_name == "blue" then
			s = s .. "Blue Air Units:\n"															--side header
		else
			s = s .. "Red Air Units:\n"																--side header
		end

		--build the list header
		for e = 1, #entries[side_name] do															--iterate through entries
			s = s .. entries[side_name][e].header													--add header
			if e < #entries[side_name] and (side_name == "blue" or side_name == "red") then															--if this is not the last header, add spaces to the next header	
				local space = entries[side_name][e].str_length + 5 - string.len(entries[side_name][e].header)		--calculate number of spaces that need to be added for alignement (string length of largest entry of same type + 3 - length of current entry = number of spaces)
				for m = 1, space do
					s = s .. " "																	--add one space for every missing letter
				end
			end
		end
		s = s .. "\n"

		--build the list		
		for n = 1, #entries[side_name][1].values do													--iterate through number of values (number of units)
			for e = 1, #entries[side_name] do														--iterate through entries
				local writeValue = entries[side_name][e].values[n]
				if writeValue == 0 then writeValue = "-" end
				s = s .. writeValue											--add value to list
				if e < #entries[side_name] then														--if this is not the last header, add spaces to the next header	
					local space = entries[side_name][e].str_length + 5 - string.len(tostring(writeValue))		--calculate number of spaces that need to be added for alignement (string length of largest entry of same type + 3 - length of current entry = number of spaces)
					for m = 1, space do
						s = s .. " "																--add one space for every missing letter
					end
				end
			end
			s = s .. "\n"																			--make a new line after each unit
		end

		s = s .. "\n\n"																				--make a new line after each side
	end

	Debriefing = Debriefing .. s .. "\n"
end


-- Order of Battle Ground ---------------------------------------------------------------------------------- 
do
	local s = ""

	for side_name, targets in pairs(targetlist) do														--iterate through sides in targetlist
		if side_name == "blue" then																	--owner of the target is the opposite of targetlist side
			s = s .. "Red Ground Assets:\n"															--side header
		else
			s = s .. "Blue Ground Assets:\n"														--side header
		end

		-- --put targetlist in array and sort
		-- local sort_table = {}																		--array to sort the targetlist
		-- for k,v in pairs(side) do
		-- 	table.insert(sort_table, k)																--insert key into sort table
		-- end
		-- table.sort(sort_table)																		--sort the table

		-- table.sort(targetSide, function(a,b) return a.titleName < b.titleName  end)

		--define list entries
		local entries = {
			[1] = {
				header = "",
				values = {},
			},
			[2] = {
				header = "",
				values = {},
			},
			[3] = {
				header = "",
				values = {},
			},
		}

		--add list values
		-- for i, v in ipairs(sort_table) do															--iterate through sort table
		-- 	if side[v].inactive ~= true then														--target is active
		-- 		if side[v].hidden == nil or side[v].hidden == false then							--target is not hidden
		-- 			if side[v].alive then															--if target has an alive value it is a scenery, vehicle or ship target and should be listed
		-- 				table.insert(entries[1].values, v)										
		-- 				table.insert(entries[2].values, math.ceil(side[v].alive) .. "%")
		-- 				if side[v].dead_last > 0 then
		-- 					table.insert(entries[3].values, "(-" .. math.ceil(side[v].dead_last) .. "%)")
		-- 				else
		-- 					table.insert(entries[3].values, "")
		-- 				end
		-- 			end
		-- 		end
		-- 	end
		-- end

		for targetN, target in ipairs(targets) do															--iterate through sort table
			if target.inactive ~= true then														--target is active
				if target.hidden == nil or target.hidden == false then							--target is not hidden
					if target.alive then															--if target has an alive value it is a scenery, vehicle or ship target and should be listed
						table.insert(entries[1].values, target.titleName)
						table.insert(entries[2].values, math.ceil(target.alive) .. "%")
						if target.dead_last > 0 then
							table.insert(entries[3].values, "(-" .. math.ceil(target.dead_last) .. "%)")
						else
							table.insert(entries[3].values, "")
						end
					end
				end
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
		--[[for e = 1, #entries do																		--iterate through entries
			s = s .. entries[e].header																--add header
			if e < #entries then																	--if this is not the last header, add spaces to the next header	
				local space = entries[e].str_length + 3 - string.len(entries[e].header)				--calculate number of spaces that need to be added for alignement (string length of largest entry of same type + 3 - length of current entry = number of spaces)
				for m = 1, space do															
					s = s .. " "																	--add one space for every missing letter
				end
			end
		end
		s = s .. "\n"--]]

		--build the list		
		for n = 1, #entries[1].values do															--iterate through number of values (number of units)
			for e = 1, #entries do																	--iterate through entries
				local writeValue = entries[e].values[n]
				if writeValue == 0 then writeValue = "-" end	
				s = s .. writeValue														--add value to list
				if e < #entries then																--if this is not the last header, add spaces to the next header	
					local space = entries[e].str_length + 3 - string.len(tostring(entries[e].values[n]))	--calculate number of spaces that need to be added for alignement (string length of largest entry of same type + 3 - length of current entry = number of spaces)
					for m = 1, space do
						s = s .. " "																--add one space for every missing letter
					end
				end
			end
			s = s .. "\n"																			--make a new line after each unit

			local targetSelect = {}
			for targetN, target in ipairs(targetlist[camp.player.side]) do
				if target.titleName == entries[1].values[n] and  target.elements  then
					targetSelect = target
					break
				end
			end

			if targetSelect.expand then												--target should be displayed with expanded elements
				if targetSelect.elements then										--target has elements
					for e = 1, #targetSelect.elements do								--iterate through elements
						local element_name = targetSelect.elements[e].name
						s = s .. "   - " .. element_name															--add element
						if camp.ShipHealth and camp.ShipHealth[element_name] then									--ship has a health entry
							local space = entries[1].str_length - string.len(tostring("   - " .. element_name))		--calculate number of spaces that need to be added for alignement (string length of largest entry of same type + 3 - length of current entry = number of spaces)
							for m = 1, space do
								s = s .. " "																		--add one space for every missing letter
							end
							if camp.ShipHealth[element_name] == 0 then									--ship is sunk
								s = s .. "   (sunk)"
							elseif camp.ShipHealth[element_name] < 33 then								--ship has less than 33% health
								s = s .. "   (heavy damage)"
							elseif camp.ShipHealth[element_name] < 66 then								--ship has less than 66% health
								s = s .. "   (moderate damage)"
							elseif camp.ShipHealth[element_name] < 100 then								--ship has less than 100% health
								s = s .. "   (light damage)"
							end
						end
						s = s .. "\n"
					end
				end
			end
		end

		s = s .. "\n\n"																				--make a new line after each side
	end

	Debriefing = Debriefing .. s .. "\n"
end


-- Clien scoreboard ---------------------------------------------------------------------------------- 
do
	local s = "Scoreboard:\n-----------\n\n"														--make lists of player scoreboard

	--define list entries
	local entries = {
		[1] = {
			header = "Name",
			values = {},
		},
		[2] = {
			header = "Missions",
			values = {},
		},
		[3] = {
			header = "Kills Air",
			values = {},
		},
		[4] = {
			header = "Kills Ground",
			values = {},
		},
		[5] = {
			header = "Kills Ship",
			values = {},
		},
		[6] = {
			header = "Crashed",
			values = {},
		},
		[7] = {
			header = "Ejected",
			values = {},
		},
		[8] = {
			header = "MIA",
			values = {},
		},
		[9] = {
			header = "Rescued",
			values = {},
		},
		[10] = {
			header = "POW",
			values = {},
		},
		[11] = {
			header = "Dead",
			values = {},
		},
	}

	-- clientstats = {
	-- 	['CEF'] = {
	-- 		['dead'] = 0,
	-- 		['score_last'] = {
	-- 			['dead'] = 0,
	-- 			['kills_ground'] = 0,
	-- 			['eject'] = 0,
	-- 			['crash'] = 0,
	-- 			['kills_ship'] = 0,
	-- 			['kills_air'] = 2,
	-- 			['mission'] = 1,
	-- 		},
	-- 		['kills_ground'] = 0,
	-- 		['eject'] = 0,
	-- 		['crash'] = 0,
	-- 		['kills_ship'] = 0,
	-- 		['kills_air'] = 2,
	-- 		['mission'] = 1,
	-- 	},
	-- }

	--add list values
	for clientname,client in pairs(clientstats) do												--iterate through clients
		table.insert(entries[1].values, clientname)
		if client.score_last.mission > 0 then
			table.insert(entries[2].values, client.mission .. " (+" .. client.score_last.mission .. ")")
		else
			table.insert(entries[2].values, client.mission)
		end
		if client.score_last.kills_air > 0 then
			table.insert(entries[3].values, client.kills_air .. " (+" .. client.score_last.kills_air .. ")")
		else
			table.insert(entries[3].values, client.kills_air)
		end
		if client.score_last.kills_ground > 0 then
			table.insert(entries[4].values, client.kills_ground .. " (+" .. client.score_last.kills_ground .. ")")
		else
			table.insert(entries[4].values, client.kills_ground)
		end
		if client.score_last.kills_ship > 0 then
			table.insert(entries[5].values, client.kills_ship .. " (+" .. client.score_last.kills_ship .. ")")
		else
			table.insert(entries[5].values, client.kills_ship)
		end
		if client.score_last.crash > 0 then
			table.insert(entries[6].values, client.crash .. " (+" .. client.score_last.crash .. ")")
		else
			table.insert(entries[6].values, client.crash)
		end
		if client.score_last.eject > 0 then
			table.insert(entries[7].values, client.eject .. " (+" .. client.score_last.eject .. ")")
		else
			table.insert(entries[7].values, client.eject)
		end

		if client.score_last.MIA > 0 then
			table.insert(entries[8].values, client.MIA .. " (+" .. client.score_last.MIA .. ")")
		else
			table.insert(entries[8].values, client.MIA)
		end

		if client.score_last.rescued > 0 then
			table.insert(entries[9].values, client.rescued .. " (+" .. client.score_last.rescued .. ")")
		else
			table.insert(entries[9].values, client.rescued)
		end

		if client.score_last.POW > 0 then
			table.insert(entries[10].values, client.POW .. " (+" .. client.score_last.POW .. ")")
		else
			table.insert(entries[10].values, client.POW)
		end

		if client.score_last.dead > 0 then
			table.insert(entries[11].values, client.dead .. " (+" .. client.score_last.dead .. ")")
		else
			table.insert(entries[11].values, client.dead)
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
			local space = entries[e].str_length + 5 - string.len(entries[e].header)				--calculate number of spaces that need to be added for alignement (string length of largest entry of same type + 3 - length of current entry = number of spaces)
			for m = 1, space do
				s = s .. " "																	--add one space for every missing letter
			end
		end
	end
	s = s .. "\n"

	--build the list		
	for n = 1, #entries[1].values do															--iterate through number of values (number of units)
		for e = 1, #entries do																	--iterate through entries
			local writeValue = entries[e].values[n]
			if entries[e].values[n] == 0 then writeValue = "-" end
			s = s .. writeValue														--add value to list
			if e < #entries then																--if this is not the last header, add spaces to the next header	
				local space = entries[e].str_length + 5 - string.len(tostring(writeValue))	--calculate number of spaces that need to be added for alignement (string length of largest entry of same type + 3 - length of current entry = number of spaces)
				for m = 1, space do
					s = s .. " "																--add one space for every missing letter
				end
			end
		end
		s = s .. "\n"																			--make a new line after each unit
	end

	Debriefing = Debriefing .. s
end