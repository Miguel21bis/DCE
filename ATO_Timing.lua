--To define Time on target for all packages and ETA for all aircraft waypoints
--Initiated by Main_NextMission.lua
------------------------------------------------------------------------------------------------------- 
-- last modification:  Debug_l
if not versionDCE then versionDCE = {} end
versionDCE["ATO_Timing.lua"] = "1.7.70"
------------------------------------------------------------------------------------------------------- 
------------------------------------------------------------------------------------------------------- 
-- cleancode_d				(d springCleaning)
-- adjustment_i				(i subtract time for taxi)(h fuel consumption)(g add AFAC task)(f not standoff in cap)(d escort Transport)(c airstart for Fuel)(b attempts to "dilute" all packages throughout the duration of the mission)(a gives more time to set up the player flight (SP and MP))						
-- Debug_l					(l TOT main[2] etc)(k latest = nil)(j time between CAPs too long)(i client Transport)(h tot bug with same target_name)(g escort/transport)(f add offset role == Anti-ship Strike)(e retablit ate<0 jusqu'a wpt 1) (d: tot transport bug)(c: speed trop faible pour les escort : = flight[f].loadout.vCruise * (1 - 10/100)) (c: Spawn before Departure) (a: vCruise by default)
-- modification M53_b		automatic update of the conf_mod file (b conf_mod reconfiguration)
-- modification M17_b		Option F-14B
-- modification M11A_bi		Multiplayer (bi: clientETA>0 au sol)(b(dh): clientETA<0 au sol)(w: force same package)
-- modification M06_e		helicoptere playable

-- local Correction_startup_time_player = 0
local tempTxt = ""
local debugTxt_AtoT = ""
local timingQuarOccupation = {
	blue = {0,0,0,0},
	red = {0,0,0,0},
}
local TOT_TimeOccupation = {}

--table to store target TOT
local TOTtable = {
	red = {},
	blue = {},
	neutral = {},
}		

local function notIn(tab, val)
    for _, v in ipairs(tab) do
        if v == val then return false end
    end
    return true
end

for sideName, packs in pairs(ATO) do
	local pack_n = {}																							--table to store all package numbers. Numbe sequence needs to be adjusted to do timingh for player package ahead of all other packages
	local tabPackPrioritaire = 0																				--table pour prioriser les packages clients
	local tabPackStudied = {}

	for n = 1, #packs do
		if PlayerFlight and camp.player and sideName == camp.player.side and n == camp.player.pack_n then							--if p is the player package number

			table.insert(pack_n, 1, n)																			--insert at start of table
			tabPackStudied[n] = true
		elseif PlayerFlight and camp.client then

			for i=1, Multi.NbGroup do
				if sideName == camp.client[i].side and n == camp.client[i].pack_n and not tabPackStudied[n] then
					table.insert(pack_n, tabPackPrioritaire+1, n)
					tabPackPrioritaire = tabPackPrioritaire+1																			--insert at the end of table
					tabPackStudied[n] = true
				elseif  not tabPackStudied[n] then																								--if p is not th eplayer package number
					table.insert(pack_n, n)																				--insert at the end of table
					tabPackStudied[n] = true
				end
			end
		end

		if not tabPackStudied[n] then
			table.insert(pack_n, n)																				--insert at the end of table
			tabPackStudied[n] = true
		end
	end

	-- for n = 1, #pack do
		-- if PlayerFlight and camp.client then																				-- modification M11.j : Multiplayer
			-- for i=2, Multi.NbGroup do	
				-- if side == camp.client[i].side and n == camp.client[i].pack_n and not tabPackStudied[n] then
					-- table.insert(pack_n, tabPackPrioritaire+1, n)
					-- tabPackPrioritaire = tabPackPrioritaire+1																			--insert at the end of table
					-- tabPackStudied[n] = true
				-- end
			-- end																				--insert at the end of table
		-- end
	-- end

	--iterate through package numbers (player package always comes first)
	for k,p in ipairs(pack_n) do

		local player_start_shift = 0																			--waypoint time shift to start player at mission start

		--TODO ajouter encore du temps ici

		--TODO faire un player start uniquement client
		local tot = 0 																								--set time on target in seconds after mission start

		if packs[p].main and packs[p].main[1] and packs[p].main[1].tot then
			-- _affiche(pack[p].main, "AtoT pack[p].main")
		elseif not packs[p].main then
			print("DEBUG: pack["..tostring(p).."].main is nil")
			_affiche(packs[p], "AtoT pack[p] (main missing)")
		elseif not packs[p].main[1] then
			print("DEBUG: pack["..tostring(p).."].main[1] is nil")
			_affiche(packs[p].main, "AtoT pack[p].main (main[1] missing)")
		end

		--package already has a tot (target package for player intercept)
		if packs[p].main[1].tot then
			tot = packs[p].main[1].tot																			--set package tot
			TOTtable[sideName][packs[p].main[1].target_name] = tot															--store TOT for target
		elseif TOTtable[sideName][packs[p].main[1].target_name] then														--target already has a TOT assigned from another package
			if packs[p].main[1].loadout.standoff == nil or packs[p].main[1].loadout.standoff <= 15000 then		--if package overflies the target, add 15 seconds tot interval between multi-packages
				TOTtable[sideName][packs[p].main[1].target_name] = TOTtable[sideName][packs[p].main[1].target_name] + 15
			end
			tot = TOTtable[sideName][packs[p].main[1].target_name]															--give this package the same TOT

			local earliest = packs[p].main[1].tot_from + mission_ini.startup_time_player   --600														--earliest TOT is 10 minutes after tot_from to make sure it is at least 10 minutes after mission start
			if packs[p].main[1].loadout.standoff then															--for strikes 
				earliest = earliest + packs[p].main[1].loadout.standoff / packs[p].main[1].loadout.vAttack		--earliest TOT to make sure that aircraft always spawn 10 minutes ahead of IP at mission start
			end
			local latest = packs[p].main[1].tot_to																--latest TOT

			if tot < earliest then																				--if this tot is too early for this package
				-- tot = earliest
				local randtot = 0
				if earliest < latest/2 then
					randtot = math.random(earliest, latest/2)
				else
					randtot = math.random(earliest, latest)
				end

				tot = randtot
				print("AtoT Ab tot < earliest tot: "..tostring(tot).." |randtot: "..tostring(randtot) )

			elseif tot > latest	then																			--if this tot is too late for this package
				tot = latest																			--give package the latest possible tot
				print("AtoT Ac  tot > latest  "..tostring(tot) )
			end
			if earliest > latest then																			--if there is no valid TOT
				tot = earliest
				print("AtoT Ad earliest  "..tostring(earliest) .." >latest ".. tostring(latest))
			end
		else
			-- local earliest = pack[p].main[1].tot_from + 2400 + mission_ini.startup_time_player		--600	
			local earliest = packs[p].main[1].tot_from + mission_ini.startup_time_player		--600												--earliest TOT is 10 minutes after tot_from to make sure it is at least 10 minutes after mission start

			if packs[p].main[1].task == "AWACS" or packs[p].main[1].task == "Refueling" then
				earliest = packs[p].main[1].tot_from
			elseif packs[p].main[1].task == "AFAC" then
				earliest = earliest
			end

			if packs[p].main[1].loadout.standoff and  packs[p].main[1].task ~= "CAP"  then															--for strikes 
				earliest = earliest + packs[p].main[1].loadout.standoff / packs[p].main[1].loadout.vAttack		--earliest TOT to make sure that aircraft always spawn 10 minutes ahead of IP at mission start
			end

			-- local latest = pack[p].main[1].tot_to 
			local latest = packs[p].main[1].tot_to + mission_ini.startup_time_player 															--latest TOT
			-- local latest = pack[p].main[1].tot_to + mission_ini.mission_duration

			if latest > mission_ini.mission_duration   then
				latest = math.random(mission_ini.mission_duration - (mission_ini.mission_duration/3), mission_ini.mission_duration )
				-- print("AtoT BBBB earliest: "..tostring(earliest).." |latest: "..tostring(latest) )
			end
			-- print("AtoT C tot_to: "..tostring(pack[p].main[1].tot_to).." |startup_time_player: "..tostring(mission_ini.startup_time_player) )
			-- print("AtoT D earliest: "..tostring(earliest).." |latest: "..tostring(latest) )

			if earliest > latest then																			--if there is no valid TOT
				tot = earliest
				-- print("AtoT Ba  earliest > latest  "..tostring(earliest) .." > ".. tostring(latest))
			else

				--divise le temps possible par quartTime
				-- pour peupler chaque quart par un TOT, si c'est possible
				local randtot
				if packs[p].main[1].task ~= "AWACS" and packs[p].main[1].task ~= "Refueling" and packs[p].main[1].task ~= "SAR"
				and packs[p].main[1].task ~= "Intercept" then
					local i = 1
					local i_choice = 1
					repeat
						i_choice = math.random(1, 4)
						i=i+1
					until timingQuarOccupation[sideName][i_choice] == 0 or i > 20

					if i > 20 then
						-- print("AtoT i: "..i.." reset Quart ")
						TOT_TimeOccupation[#TOT_TimeOccupation+1]= Deepcopy(timingQuarOccupation)
						-- timingQuarOccupation = {blue = {0,0,0,0}, red = {0,0,0,0}}
						timingQuarOccupation[sideName] =  {0,0,0,0}
						repeat
							i_choice = math.random(1, 4)
							i=i+1
						until timingQuarOccupation[sideName][i_choice] == 0 or i > 40
					end
					local quartTime = (latest - earliest) / 4
					randtot = math.random(0, quartTime)
					randtot = ((i_choice - 1) * quartTime) + randtot + earliest
					timingQuarOccupation[sideName][i_choice] = randtot.." _ "..packs[p].main[1].target_name

					-- print("AtoT i: "..i)

					-- _affiche(timingQuarOccupation, "AtoT timingQuarOccupation")
					-- print("AtoT F else random(earliest, latest): "..tostring(randtot) )
					-- print("AtoT ----------------------------------------------------------------------  target_name: "..pack[p].main[1].target_name.." tot: "..randtot.." "..FormatTime(randtot, "hh:mm"))


				else
					randtot = math.random(earliest, latest)

				end

				-- local randtot = math.random(earliest, latest)
				-- randtot = math.random(earliest, latest)
				-- randtot = math.random(earliest, latest)																--set random tot
				tot = randtot
				-- print("AtoT Ba  tot   "..tostring(tot) )

			end
			TOTtable[sideName][packs[p].main[1].target_name] = tot															--store TOT for target

		end

		local main_vCruise = packs[p].main[1].loadout.vCruise															--set package cruise speed
		local main_vAttack = packs[p].main[1].loadout.vAttack															--set package attack speed

		-- --recherche la vitesse la plus faible du package
		-- local vCruiseMini = 999999
		-- local vAttackMini = 999999
		-- for role,flight in pairs(pack[p]) do
		-- 	for f = 1, #flight do	
		-- 		if flight[f].loadout.vCruise < vCruiseMini then
		-- 			vCruise = vCruiseMini
		-- 		end
		-- 		if flight[f].loadout.vAttack < vAttackMini then
		-- 			vAttack = vAttackMini
		-- 		end
		-- 	end
		-- end

		tempTxt ="AtoT_eta main[1]TYPE "..packs[p].main[1].type.." \n main[1]NAME "..packs[p].main[1].loadout.name
		--print(tempTxt)
		debugTxt_AtoT = debugTxt_AtoT ..tempTxt.."\n"

		tempTxt ="AtoT_eta vCruise "..tostring(main_vCruise).." \n vAttack "..tostring(main_vAttack)
		-- print(tempTxt)
		debugTxt_AtoT = debugTxt_AtoT ..tempTxt.."\n"

		local target_wp = 1																						--local variable to store the target waypoint number
		local partial_station = 0																				--local variable to hold time that an orbiting flight is already on station at mission start

		for role, flight in pairs(packs[p]) do																	--iterate through roles in package (main, SEAD, escort)
			--flight route offset within package (lateral and ETA)
			for f = 1, #flight do																				--iterate through flights in roles	

				if flight[f].loadout.vCruise then main_vCruise = flight[f].loadout.vCruise end
				if flight[f].loadout.vAttack then main_vAttack = flight[f].loadout.vAttack end

				flight[f].eta_offset = 0																		--ETA delay in seconds for longitudinal flight separation
				--not any of these tasks, as these do not operate with simultaneous flights on the same route
				-- définir une table de lookup une fois, en haut du fichier / avant la boucle
				local tasksInterdit = {"CAP", "AWACS", "Refueling", "Intercept", "SAR", "Transport"}

				if notIn(tasksInterdit, flight[f].task) then
					local tSeparation = 8																		--basic separation between flights in seconds at cruise speed
					local separation = tSeparation * main_vCruise													--basic separation between flights in meters
					local offset																				--lateral offset of flight route in meters from route of lead flight

					if role == "main" or  role == "Strike" or  role == "Anti-ship Strike" then
						if math.floor((f - 1) / 3) == (f - 1) / 3 then											--flight 1, 4, 7...
							offset = 0
							flight[f].eta_offset = tSeparation * ((f - 1) / 3 * 2)								--ETA delay in seconds for longitudinal flight separation
						elseif math.floor((f - 2) / 3) == (f - 2) / 3 then										--flight 2, 5, 8...
							offset = separation																	--to the right side of lead flight
							flight[f].eta_offset = tSeparation * ((f - 2) / 3 * 2 + 1)							--ETA delay in seconds for longitudinal flight separation
						elseif math.floor((f - 3) / 3) == (f - 3) / 3 then										--flight 3, 6, 9...
							offset = separation * -1															--to the left side of lead flight
							flight[f].eta_offset = tSeparation * ((f - 3) / 3 * 2 + 1)							--ETA delay in seconds for longitudinal flight separation
						end
					elseif role == "SEAD" then
						offset = separation / 2																	--all SEAD routes are offset slightly to the right
						if math.floor((f - 1) / 3) == (f - 1) / 3 then											--flight 1, 4, 7...
							flight[f].eta_offset = -60 + tSeparation * ((f - 1) / 3)							--ETA delay in seconds for longitudinal flight separation
						elseif math.floor((f - 2) / 3) == (f - 2) / 3 then										--flight 2, 5, 8...
							offset = offset - separation														--to the left side of lead flight
							flight[f].eta_offset = -60 + tSeparation * ((f - 2) / 3)							--ETA delay in seconds for longitudinal flight separation
						elseif math.floor((f - 3) / 3) == (f - 3) / 3 then										--flight 3, 6, 9...
							offset = offset + separation														--to the right side of lead flight
							flight[f].eta_offset = -60 + tSeparation * ((f - 3) / 3)							--ETA delay in seconds for longitudinal flight separation
						end
					elseif role == "Escort" then
						offset = separation / -2																--all escort routes are offset slightly to the left
						if math.floor((f - 1) / 4) == (f - 1) / 4 then											--flight 1, 5, 9...
							flight[f].eta_offset = -90 + tSeparation * ((f - 1) / 4)							--ETA delay in seconds for longitudinal flight separation
						elseif math.floor((f - 2) / 4) == (f - 2) / 4 then										--flight 2, 6, 10...
							offset = offset + separation * (3 + ((f - 2) / 4))									--to the right side of lead flight
							flight[f].eta_offset = tSeparation * ((f - 2) / 4)									--ETA delay in seconds for longitudinal flight separation
						elseif math.floor((f - 3) / 4) == (f - 3) / 4 then										--flight 3, 7, 11...
							offset = offset - separation * (3 + ((f - 3) / 4))									--to the left side of lead flight
							flight[f].eta_offset = tSeparation * ((f - 3) / 4)									--ETA delay in seconds for longitudinal flight separation
						elseif math.floor((f - 4) / 4) == (f - 4) / 4 then										--flight 4, 8, 12...
							flight[f].eta_offset = -240 + tSeparation * ((f - 4) / 4)							--ETA delay in seconds for longitudinal flight separation
						end
					elseif role == "Escort Jammer" then
						offset = 0
						flight[f].eta_offset = tSeparation														--escort jammer flies in the center of strike package
					elseif role == "Flare Illumination" then
						offset = 0
						flight[f].eta_offset = -120																--flare illumination flies 2 minutes ahead
					elseif role == "Laser Illumination" then
						offset = 0
						flight[f].eta_offset = tSeparation * 3													--laser illumination flies slightly behind strike package
					end

					--TODO, inutile ou bizarre, les transport sont interdit plus haut
					if packs[p].main[1].task == "Transport" or packs[p].main[1].task == "Nothing" then
                        for w = 3, #flight[f].route - 1 do                              --iterate through all waypoints that require lateral offset (taxi, departure and landing WP exluded)			
                            if flight[f].route[w].id ~= "Target" then                   --Target WP does not need lateral offset
                                local inbound_heading = GetHeading(flight[f].route[w - 1], flight[f].route[w]) --inbound heading to WP of lead flight
                                local outbound_heading = GetHeading(flight[f].route[w], flight[f].route[w + 1]) --outbound heading from WP of lead flight
                                local delta_heading = GetDeltaHeading(inbound_heading, outbound_heading) --amount of heading change at WP

                                if delta_heading < 66 and delta_heading > -66 then      --if heading change is small, flights stay at the present side of lead flight (check turn)
                                    local alpha = inbound_heading + 90 + (delta_heading / 2)
                                    local dist = offset / math.cos(math.rad(delta_heading / 2))
                                    local offset_WP = GetOffsetPoint(flight[f].route[w], alpha, dist)
                                    flight[f].route[w].x = offset_WP.x
                                    flight[f].route[w].y = offset_WP.y
                                else --if heading change is big, flights switch side from lead flight (tactical turn and cross turn)
                                    local alpha = outbound_heading - 90 + ((180 - delta_heading) / 2)
                                    local dist = offset / math.cos(math.rad((180 - delta_heading) / 2))
                                    local offset_WP = GetOffsetPoint(flight[f].route[w], alpha, dist)
                                    flight[f].route[w].x = offset_WP.x
                                    flight[f].route[w].y = offset_WP.y
                                    offset = offset * -1 --switch side
                                end
                            end
                        end

					else	-- tous les autres tasks

						if #flight[f].route >= 4 then
							for w = 3, #flight[f].route - 1 do															--iterate through all waypoints that require lateral offset (taxi, departure and landing WP exluded)			
								if flight[f].route[w].id ~= "Target" and flight[f].route[w].id ~= "WPT Before Landing" then --Target WP does not need lateral offset

									local inbound_heading, outbound_heading, delta_heading

									if packs[p].main[1].route[w] and packs[p].main[1].route[w+1] and packs[p].main[1].route[w-1] then
										inbound_heading = GetHeading(packs[p].main[1].route[w - 1], packs[p].main[1].route[w], packs[p].main[1])		--inbound heading to WP of lead flight
										outbound_heading = GetHeading(packs[p].main[1].route[w], packs[p].main[1].route[w + 1], packs[p].main[1])		--outbound heading from WP of lead flight
										delta_heading = GetDeltaHeading(inbound_heading, outbound_heading)			--amount of heading change at WP
									end

									if delta_heading then
										if delta_heading < 66 and delta_heading > -66 then									--if heading change is small, flights stay at the present side of lead flight (check turn)
											local alpha = inbound_heading + 90 + (delta_heading / 2)
											local dist = offset / math.cos(math.rad(delta_heading / 2))
											local offset_WP = GetOffsetPoint(flight[f].route[w], alpha, dist)
											flight[f].route[w].x = offset_WP.x
											flight[f].route[w].y = offset_WP.y
										else																				--if heading change is big, flights switch side from lead flight (tactical turn and cross turn)
											local alpha = outbound_heading - 90 + ((180 - delta_heading) / 2)
											local dist = offset / math.cos(math.rad((180 - delta_heading) / 2))
											local offset_WP = GetOffsetPoint(flight[f].route[w], alpha, dist)
											flight[f].route[w].x = offset_WP.x
											flight[f].route[w].y = offset_WP.y
											offset = offset * -1															--switch side
										end
									end
								end
							end
						else
							print("AtoT Bug role :"..role.." f: "..f)
							_affiche(flight[f], "ATO_Timing Bug with route length < 4 :")
							print("(↑↑↑...) ATO_Timing Bug with route length < 4  (...↑↑↑)")
							os.execute 'pause'

						end
					end
				end
			end


			--set WP ETAs going backwards from target to take off
			local startUp_time = 600
			for f = 1, #flight do
				
				if flight[f].player or flight[f].client then --for player flight
                    if mission_ini.startup_time_player then --if player value defined in camp -- modification M17.b Option F-14B, changement du temps avant start, possible � chaque mission plutot qu'au demarrage de la campagne
                        startUp_time = mission_ini.startup_time_player --use this value instead
                        -- elseif camp.startup then										--if player value defined in camp
                        -- 	start_up_time = camp.startup							--time for player start-up
                    else
                        startUp_time = startUp_time +  300               --if player start-up is undefined, add 5 minutes as default
                     end
				else
					if db_airbases[flight[f].base].startup then						--if there is a specific value defined for that airbase, use this instead
						startUp_time = db_airbases[flight[f].base].startup
					end

                end
				
				debugTxt_AtoT = debugTxt_AtoT ..tempTxt.."\n"

				if flight[f].loadout.vCruise then main_vCruise = flight[f].loadout.vCruise end
				if flight[f].loadout.vAttack then main_vAttack = flight[f].loadout.vAttack end

				--flight TOT for packages continously covering a station
				if  flight[f].task == "AWACS" or flight[f].task == "Refueling" or flight[f].task == "AFAC" then		--flight is part of a package that continously covers a station
					local available_station_coverage = #flight * flight[f].loadout.tStation							--total time that station can be covered
					local required_station_coverage = flight[f].tot_to - flight[f].tot_from	+ flight[f].loadout.tStation	--total time that station must be covered
					local station_uncovered = required_station_coverage - available_station_coverage				--total time that station is uncovered

					if station_uncovered <= 0 then																	--station can be covered continously
						if f == 1 then																				--for first flight in package
							partial_station = math.random(0, flight[f].loadout.tStation)													--set time that first flight was already on station at mission start
							if camp.time + flight[f].tot_from - partial_station < mission_ini.dawn and flight[f].loadout.night == false then		--if before dawn and not night capable
								partial_station = camp.time - mission_ini.dawn																		--make partial_station to match dawn
							elseif camp.time + flight[f].tot_from - partial_station < mission_ini.dusk and flight[f].loadout.day == false then		--if before dusk and not day capable
								partial_station = camp.time - mission_ini.dusk																		--make partial_station to match dusk
							end
						end

						tot = flight[f].tot_from + (f - 1) * flight[f].loadout.tStation + 1							--flight TOT (+1 second so that first flight spanwns at mission start a little ahead of station)
						tot = tot - partial_station																	--remove time that the first flight was already on station at mission start
						-- print("AtoT Ca  tot   "..tostring(tot) )
					else																							--station cannot be covered continously
						if f == 1 then																				--for first flight in package
							local from = flight[f].tot_from - flight[f].loadout.tStation							--first possible station start
							local to = flight[f].tot_to / #flight - flight[f].loadout.tStation						--last possible station start
							if from <= to then
								tot = math.random(from, to) + 1
							else
								tot = from + 1
							end
							if tot < 0 then																			--if tot is before mission start
								partial_station = tot * -1															--time on station until mission start
							else																					--tot after mission start
								partial_station = 0																	--time already on station is zero
							end
						else
							tot = tot + flight[f].tot_to / #flight
						end
						-- print("AtoT Cb  tot   "..tostring(tot) )
					end
				end

				if flight[f].task == "CAP" then
					if f == 1 then																				--for first flight in package
						tot = tot
					else
						tot = tot +  (flight[f].loadout.tStation * #flight) - flight[f].loadout.tStation
					end
				end

				--flight TOT for interceptors
				if flight[f].task == "Intercept" or flight[f].task == "SAR" then
					flight[f].route[1].eta = 0									--interceptors only have one waypoint and start at mission start (but idle until activated by EWR)
				end
				--find target WP
				if not tot then
					_affiche(flight[f], "Bug TOT with: ")
				end


				--***********************************////////////////////////////////////////////////////////////////////////////
				--Make ETA at target the TOT plus ETA offset for flight tSeparation within package
				--Déterminer l'heure d'arrivée prévue à la cible en ajoutant le décalage TOT et ETA pour la séparation des vols dans le cadre du package.
				--***********************************////////////////////////////////////////////////////////////////////////////

				local eta = tot + flight[f].eta_offset

				if role == "main" and f == 1 then
					TOTtable[sideName][packs[p].main[1].target_name] = eta
				end

				for w = 1, #flight[f].route do									--iterate through all waypoints of flight
					if flight[f].route[w].id == "Target" or flight[f].route[w].id == "Station" or flight[f].route[w].id == "Sweep" then	--if target WP is found (target or orbit start)
						flight[f].route[w].eta = eta							--set ETA for target WP
						target_wp = w											--store target WP number
						if flight[f].player then								--if this is the player flight
							camp.player.tgt_wp = w								--store the target wp for the player
						elseif flight[f].client then								--if this is the player flight
							camp.client[flight[f].IdClient].tgt_wp = w								--store the target wp for the player
						end

						flight[f].route[w]["debug"] = (flight[f].route[w]["debug"] or "")..
							"\n AtoT_TargetWPT  eta "..eta..
							"\n AtoT_TargetWPT w "..w..
							"\n AtoT_TargetWPT eta_offset: "..flight[f].eta_offset

						break
					end
				end

				--flight TOT for ferry flight (Nothing task)
				if flight[f].task == "Nothing" or flight[f].task == "Transport" then

					--store target WP number (destination WP)
					target_wp = #flight[f].route
					flight[f].route[target_wp].eta = eta					--set ETA for target WP (destination WP)
					flight[f].route[target_wp].speed = flight[f].loadout.vCruise or main_vCruise						--set NEWSPEED
			
					if flight[f].player then									--if this is the player flight
						camp.player.tgt_wp = target_wp - 1					--store the target wp for the player
					elseif flight[f].client then								--if this is the player flight
						camp.client[flight[f].IdClient].tgt_wp = target_wp - 1								--store the target wp for the player
					end

					flight[f].route[target_wp]["debug"] = (flight[f].route[target_wp]["debug"] or "")..
						"\n AtoT_TargetWPT ferry flight eta "..eta..
						"\n AtoT_TargetWPT  target_wp "..target_wp

				end



				--***********************************////////////////////////////////////////////////////////////////////////////
				--set WP ETAs going forward from target to landing
				--set WP ETAs going forward from target to landing
				--***********************************////////////////////////////////////////////////////////////////////////////

				local speed
				for w = target_wp + 1, #flight[f].route  do						--iterate through flight waypoints from target foward
					speed = main_vCruise												-- ATO_T_Debug01 vCruise by default 

					if flight[f].route[w].id == "Station" then					--if WP is the end point of an orbit station

						if not flight[f].loadout.tStation then
							flight[f].loadout.tStation = 3600
						end

						eta = flight[f].route[w - 1].eta + flight[f].loadout.tStation	--WP ETA is orbit start WP ETA plus on station time
						if eta > mission_ini.dawn and flight[f].loadout.day == false then	--if ETA after dawn and not day capable
							eta = mission_ini.dawn										--make dawn the orbit end ETA
						elseif eta > mission_ini.dusk and flight[f].loadout.night == false then	--if ETA after dusk and not night capable
							eta = mission_ini.dusk										--make dusk the orbit end ETA
						end
						flight[f].route[w].eta = eta							--set ETA at waypoint
						flight[f].route[w].speed = speed						--set NEWSPEED
					else
						if flight[f].route[w].id == "Egress" then
							speed = main_vAttack										--egress from target is at attack seed
						else
							speed = main_vCruise										--everything else is at cruise speed
						end

						if flight[f].loadout.vCruise then
							if speed < flight[f].loadout.vCruise then
								speed = flight[f].loadout.vCruise
							end
						end

						-- if pack[p].main[1].loadout.standoff and pack[p].main[1].loadout.standoff > 15000 and flight[f].route[w].id == "Egress" then		--if the package has a standoff from target bigger than 15 km, proceed from attack point directly to egress
						-- 	local tgt_ap_dist = GetDistance(flight[f].route[target_wp], flight[f].route[target_wp - 1])		--distance from target to attack point
						-- 	local ap_eta = eta - tgt_ap_dist / speed			--eta at attack point
						-- 	local ap_egress_dist = GetDistance(flight[f].route[target_wp - 1], flight[f].route[target_wp + 1])	--distance from attack point to egress point
						-- 	eta = ap_eta + ap_egress_dist / speed				--calculate ETA at egress
						-- else
							local leg = GetDistance(flight[f].route[w - 1], flight[f].route[w])	--measure lenght of the next route leg
							eta = eta + leg / speed								--calculate ETA at next waypoint
						-- end
						flight[f].route[w].eta = eta							--set ETA at waypoint
						flight[f].route[w].speed = speed						--set NEWSPEED
						flight[f].route[w]["debug"] = (flight[f].route[w]["debug"] or "") ..
							"\nAtoT_TargetToLanding eta " .. eta ..
							"\nAtoT_TargetToLanding w " .. w ..
							"\nAtoT_TargetToLanding leg " .. leg

					end
				end

				--***********************************////////////////////////////////////////////////////////////////////////////
				--set WP ETA landing
				--***********************************////////////////////////////////////////////////////////////////////////////
				-- local wptAfterTargetTxt
				if flight[f].task ~= "Nothing" and flight[f].task ~= "Transport" then
					if target_wp >= 2 and target_wp + 1 >= #flight[f].route then
						local wptLandind = #flight[f].route
						speed = main_vCruise										--everything else is at cruise speed
						
						local leg = GetDistance(flight[f].route[#flight[f].route - 1], flight[f].route[wptLandind])	--measure lenght of the next route leg
						
						eta = eta + leg / speed									--calculate ETA at next waypoint
						flight[f].route[wptLandind].eta = eta				--set ETA at waypoint
						flight[f].route[wptLandind].speed = speed						--set NEWSPEED

						flight[f].route[wptLandind]["debug"] = (flight[f].route[wptLandind]["debug"] or "") ..
							"\nAtoT_wptAfterTargetTxt  |speed: "..speed..
							"\nAtoT_wptAfterTargetTxt  |leg: "..leg.." |eta: "..eta

					end
				end
				-- --set WP ETAs going backwards from target to take off
				-- local start_up_time = 600										--default 5/10 minutes for AI start up, taxi and form-up
				-- if db_airbases[flight[f].base].startup then						--if there is a specific value defined for that airbase, use this instead
				-- 	start_up_time = db_airbases[flight[f].base].startup
				-- end

                -- if flight[f].player or flight[f].client then --for player flight
                --     if mission_ini.startup_time_player then --if player value defined in camp -- modification M17.b Option F-14B, changement du temps avant start, possible � chaque mission plutot qu'au demarrage de la campagne
                --         start_up_time = mission_ini.startup_time_player --use this value instead
                --         -- elseif camp.startup then										--if player value defined in camp
                --         -- 	start_up_time = camp.startup							--time for player start-up
                --     else
                --         start_up_time = start_up_time +  300               --if player start-up is undefined, add 5 minutes as default
                --      end
                -- end




				--***********************************////////////////////////////////////////////////////////////////////////////
				-- iterate through flight waypoints from target backwards
				-- Itérer les waypoints du vol en partant de target vers l’arrière 
				--***********************************////////////////////////////////////////////////////////////////////////////
				eta = tot + flight[f].eta_offset								--reset target WP ETA
				local etaSpawn = tot + flight[f].eta_offset

				for w = target_wp, 2, -1 do
					if flight[f].route[w] then
						speed = flight[f].loadout.vCruise or main_vCruise
						local debug_TgtToLand = "\nAtoT_TgtToLand speed_F "..speed

						if w == target_wp then
							speed = flight[f].loadout.vAttack or main_vAttack
							debug_TgtToLand = debug_TgtToLand.."\nAtoT_TgtToLand speed_G "..speed
						elseif flight[f].route[w].id == "Assemble" then
							speed = (flight[f].loadout.vCruise or main_vCruise) * 0.9
							debug_TgtToLand = debug_TgtToLand.."\nAtoT_TgtToLand speed_H "..speed
						end

						local minCruise = (flight[f].loadout.vCruise or main_vCruise) * 0.9
						if speed < minCruise then
							speed = minCruise
							debug_TgtToLand = debug_TgtToLand.."\nAtoT_TgtToLand speed_I "..speed
						end

						local leg = GetDistance(flight[f].route[w], flight[f].route[w - 1])
						eta = eta - leg / speed
						etaSpawn = etaSpawn - leg / speed

						flight[f].route[w-1]["debug"] = (flight[f].route[w-1]["debug"] or "")..
							debug_TgtToLand.."\nAtoT_TgtToLand eta J "..eta.." leg "..leg

						-- Sauvegarde systématique des deux valeurs
						flight[f].route[w-1].eta = eta
						flight[f].route[w-1].etaSpawn = etaSpawn

						-- Cas du premier WP
						if w - 1 == 1 then
							-- Spawn au sol, on ajoute le temps de startup/taxi
							eta = eta - startUp_time
							flight[f].route[w - 1].eta = eta

						elseif w - 1 == 2 then
							-- WP 2, form-up/taxi
							eta = eta - startUp_time
							flight[f].route[w - 1].eta = eta
						end

						flight[f].route[w-1]["debug"] = (flight[f].route[w-1]["debug"] or "")..
							"\nAtoT_TgtToLand eta K "..eta.." WPT: "..w..
							"\nAtoT_TgtToLand etaSpawn K "..etaSpawn.." WPT: "..w

						flight[f].route[w].speed = speed

						if (flight[f].player or flight[f].client) and w - 1 == 1 then
							player_start_shift = 0 - eta
						end
					end
				end


		-- 		--***********************************////////////////////////////////////////////////////////////////////////////
		-- 		-- iterate through flight waypoints from target backwards
		-- 		-- Itérer les waypoints du vol en partant de target vers l’arrière 
		-- 		for w = target_wp, 2, -1 do
		-- 			if flight[f].route[w] then
		-- 				speed = main_vCruise
		-- 				local debug_TgtToLand = "\nAtoT_eta speed_F "..speed

		-- 				if w == target_wp then

		-- 					speed = main_vAttack											--ingress to target is at attack seed
		-- 					debug_TgtToLand = debug_TgtToLand.."\nAtoT_eta speed_G "..speed
		-- 				elseif (flight[f].route[w].id == "Assemble") then		-- and not flight[f].helicopter			--WP is join point --M06.c and not flight[f].helicopter
		-- 					-- Vitesse réduite à 90 % de vCruise pour faciliter la montée vers le point de Assemble
		-- 					speed = main_vCruise * (1 - 10/100)
		-- 					debug_TgtToLand = debug_TgtToLand.."\nAtoT_eta speed_H "..speed
		-- 				end

		-- 				-- Assure une vitesse minimale de 90 % de la vitesse de croisière
		-- 				if speed < flight[f].loadout.vCruise * (1 - 10/100) then
		-- 					speed = flight[f].loadout.vCruise * (1 - 10/100)
		-- 					debug_TgtToLand = debug_TgtToLand.."\nAtoT_eta speed_I "..speed
		-- 				end

		-- 				local leg = GetDistance(flight[f].route[w], flight[f].route[w - 1])	--measure lenght of the previous route leg

		-- 				eta = eta - leg / speed										--calcualte ETA at previous waypoint
		-- 				etaSpawn = etaSpawn - leg / speed										--calcualte ETA at previous waypoint
						
		-- 				flight[f].route[w-1]["debug"] = debug_TgtToLand.."\nAtoT_eta eta J "..eta.." leg "..leg
						
		-- 				--si l eta passe negatif et que le flight spawn en vol, on recollera eta1calc
		-- 				if w - 1 == 1 then											--WP is first WP
		-- 					eta = eta - startUp_time								--subtract time for start up
		-- 					flight[f].route[w - 1].etaSpawn = etaSpawn
		-- 				end
		-- 				if w - 1 == 2 then											--WP is 2 WP
		-- 					-- eta = eta - 300								--subtract time for taxi
		-- 					eta = eta - startUp_time								--subtract time for form-up
		-- 					flight[f].route[w - 1].etaSpawn = etaSpawn
		-- 				end

		-- 				flight[f].route[w-1]["debug"] = flight[f].route[w-1]["debug"].."\nAtoT_eta eta K "..eta.." WPT: "..w

		-- 				flight[f].route[w - 1].eta = eta							--set ETA at previous waypoint
		-- 				flight[f].route[w].speed = speed							--set NEWSPEED
						
		-- 				if (flight[f].player or flight[f].client) and w - 1 == 1 then				--for player flight and first waypoint
		-- 					player_start_shift = 0 - eta											--time shift to start player at mission start
		-- 				end
		-- 			end
		-- 		end

				
			end

		end

		-- Ajuster le TOT pour toutes les occurences dans pack[p].main
		for i = 1, #packs[p].main do
			if packs[p].main[i].target_name and TOTtable[sideName][packs[p].main[i].target_name] then
				TOTtable[sideName][packs[p].main[i].target_name] = TOTtable[sideName][packs[p].main[i].target_name] + player_start_shift
			end
		end


		for _, flight in pairs(packs[p]) do
			for f = 1, #flight do

				if flight[f].loadout.vCruise then main_vCruise = flight[f].loadout.vCruise end
				if flight[f].loadout.vAttack then main_vAttack = flight[f].loadout.vAttack end

				for w = 1, #flight[f].route do
					if not flight[f].route[w].eta then
						flight[f].route[w].eta = 0
					end

					if flight[f].route[w].id == "Station" and flight[f].route[w].eta + player_start_shift < 0 then		--Start or end of a station would be shifted before mission start
						flight[f].route[w].eta = 1																		--adjust WP eta to mission start
					else
						flight[f].route[w].eta = flight[f].route[w].eta + player_start_shift							--adjust WP eta by time difference for player to start at mission start
						if flight[f].route[w].etaSpawn then
							flight[f].route[w].etaSpawn = flight[f].route[w].etaSpawn + player_start_shift
						end
						
						flight[f].route[w]["debug"] = (flight[f].route[w]["debug"] or "")..
							"\nAtoT_eta player_start_shift "..player_start_shift.." WPT: "..w..
							"\nAtoT_eta new eta "..flight[f].route[w].eta
					end
				end

				--Air starts
				local airstart = 0															--if TOT causes a take off before mission start, flight becomes air start and this variable gets the number of the spawn WP
				local deltaETA = 0
				
				for w = target_wp - 1, 1, -1 do													--iterate through waypoints backwards

					if flight[f] then
						if flight[f].route[w] then
						else
							print("Bug with flight[f].route[w] w: "..w)
							_affiche(flight, "flightAtoT ")
						end

					else
						print("Bug with flight[f] f: "..f)
						_affiche(flight, "flightAtoT ")
					end

					if flight[f].route[w].eta < 0 and not (flight[f].client or flight[f].player) then		--ETA before mission start
						deltaETA = flight[f].route[1].eta

						--find flight position at mission start and make it a WP
						local h = GetHeading(flight[f].route[w + 1], flight[f].route[w])		--heading from last WP with positive ETA
						local speed
						if flight[f].route[w].id == "IP" then
							speed = main_vAttack
						else
							speed = main_vCruise
						end

						if speed < flight[f].loadout.vCruise * (1 - 10/100) then
							-- print("AtoRG passe speed < flight[f]..vCruise "..tostring(speed).." < ".. flight[f].loadout.vCruise * (1 - 10/100) )
							speed = flight[f].loadout.vCruise * (1 - 10/100)
							-- print("AtoRG result: "..tostring(speed).." ==? ".. flight[f].loadout.vCruise * (1 - 10/100) )
						end

						local dist = flight[f].route[w + 1].eta * speed							--distance covered from mission start to first positive ETA
						if dist > GetDistance(flight[f].route[w], flight[f].route[w + 1]) then	--if distance is ahead of WP (caused by extra minutes at take off WP), keep spawn point over take off point but adjust id and alt for air spawn

							flight[f].route[w].id = "Spawn"
							flight[f].route[w].name = "Create Spawn Wp in AtoTiming "..tostring(debug.getinfo(1).currentline)
							flight[f].route[w].alt = flight[f].route[w + 1].alt
							flight[f].route[w].eta = 0											--ETA of WP is at mission start
							flight[f].route[w].speed = speed									--set NEWSPEED
						
						else																	--else move the spawn point to new location
							flight[f].route[w] = {
								x = flight[f].route[w + 1].x + math.cos(math.rad(h)) * dist,
								y = flight[f].route[w + 1].y + math.sin(math.rad(h)) * dist,
								eta = 0,														--ETA of WP is at mission start
								id = "Spawn",													--WP is spawn point
								name = "Create Spawn Wp in AtoTiming "..tostring(debug.getinfo(1).currentline),
								alt = flight[f].route[w + 1].alt,
								speed = speed,													--set NEWSPEED
							}
						end

						airstart = w															--store the number of the spawn WP (WPs ahead will be removed)
						break
					elseif flight[f].route[w].eta < 0 and (flight[f].client or flight[f].player) then
						InsertBugList("AtoT ALERT player SPAWNING ETA <0 "..tostring(flight[f].route[w].eta))
					end
				end

				if flight[f].route[1].id == "Spawn" then
					for w = 1, #flight[f].route do
						if flight[f].route[w].etaSpawn then
							flight[f].route[w].eta = flight[f].route[w].etaSpawn

							flight[f].route[w]["debug"] = (flight[f].route[w]["debug"] or "")..
							"\nAtoT_eta id == Spawn , WPT: "..w..
							"\nAtoT_eta new eta "..flight[f].route[w].eta
						end
					end
				end


				-- if flight[f].route[1].id == "Spawn" then
				-- 	for w = 1, #flight[f].route do	
				-- 		if w == 1 or w == 2 then
				-- 			flight[f].route[w].eta = flight[f].route[w].eta + flight[f].route[w].startUp_time
				-- 		elseif flight[f].route[w].eta1calc then
				-- 			flight[f].route[w].eta = flight[f].route[w].eta1calc
				-- 			-- flight[f].route[w_].eta1calc = nil
				-- 			flight[f].route[w].debug = flight[f].route[w].debug.."\nAtoT_eta1calc w "..w.." eta1calc: "..flight[f].route[w].eta1calc
				-- 		end


				-- 	end
				-- end


				--remove WPs ahead of spawn WP
				local flight_tgt_wp = target_wp													--local copy of the target waypoint number for this flight only
				if airstart ~= 0 then																--if the flight is an air start

					for w = airstart - 1, 1, -1 do												--iterate through all the WPs from airstart WP to first WP
						table.remove(flight[f].route, w)										--remove all WPs ahead of spwan WP
						flight_tgt_wp = flight_tgt_wp - 1										--adjust flight target_wp
					end
					flight[f].route[1].deltaETA = deltaETA
					flight[f].route[1].airstart = true
				end

				--remove target and attack WP for escort tasks
				if flight[f].task == "Escort" and ( packs[p].main[1].task ~= "Transport" and packs[p].main[1].task ~= "Nothing") then
					table.remove(flight[f].route, flight_tgt_wp)								--remove target WP from route
					if flight[f].route[flight_tgt_wp - 1].id ~= "Spawn" then
						table.remove(flight[f].route, flight_tgt_wp - 1)						--remove attack WP from route
					end
					if flight[f].player then													--if this is the player flight
						camp.player.tgt_wp = camp.player.tgt_wp - 2								--update the target WP (IP for Escort and SEAD)
					elseif flight[f].client then													--if this is the player flight
						camp.client[flight[f].IdClient].tgt_wp = camp.client[flight[f].IdClient].tgt_wp - 2								--update the target WP (IP for Escort and SEAD)
					end
				end
				

				-- if #flight[f].route > 2 then
				-- 	for w = 2 , #flight[f].route do

				-- 		local distance = GetDistance(flight[f].route[w-1], flight[f].route[w])
				-- 		local time = flight[f].route[w].eta - flight[f].route[w-1].eta
				-- 		local vi = distance / time

				-- 		if distance >= 1 and  flight[f].route[w].eta ~= 0   then

				-- 			if flight[f].loadout and flight[f].loadout.vAttack and math.floor(vi) > math.ceil(flight[f].loadout.vAttack)  then
				-- 				tempTxt = "AtoT_eta typeD "..flight[f].type.." target_name "..tostring(flight[f].target_name).."_"..f.."|_|"..flight[f].route[w-1].id.."|_|"..flight[f].route[w].id.."|_eta-1_|"..flight[f].route[w-1].eta.."|_eta_|"..flight[f].route[w].eta
				-- 				--print(tempTxt)
				-- 				debugTxt_AtoT = debugTxt_AtoT ..tempTxt.."\n"

				-- 				tempTxt = "AtoT_eta  loadName "..flight[f].loadout.name.."|_vAttack:_|"..flight[f].loadout.vAttack.."|_vi_|"..vi
				-- 				--print(tempTxt)
				-- 				debugTxt_AtoT = debugTxt_AtoT ..tempTxt.."\n"

				-- 				tempTxt = "AtoT_eta _______________________________________________distance_ "..distance.."|_time_|"..time.."|_vi_|"..vi
				-- 				--print(tempTxt)
				-- 				debugTxt_AtoT = debugTxt_AtoT ..tempTxt.."\n"

				-- 			end
				-- 		end
				-- 	end
				-- end


			end
		end
	end
end



for side, pack in pairs(ATO) do
	for p = 1, #pack do
		for role, flight in pairs(pack[p]) do
			for f = 1, #flight do
				-- print()
				for u = 1, flight[f].number do

					if not flight[f] or not flight[f].route[1] or not flight[f].route[1].eta then
						_affiche(flight, "flight[f].route[1].eta")
					end

					local operating_hours = 86400
					local time_to_next_mission = operating_hours / flight[f].loadout.sortie_rate	--time duration until aircraft can do the next mission based on its sortie rate

					-- if entry.loadout.tStation and #ATO[side][pack_n][role] == 1 then			--for a flight that has a station time and for the first flight in package
					-- 	time_to_next_mission = time_to_next_mission - entry.loadout.tStation	--remove station time from time to next mission, because flight could airstart current mission at close to end of its station time
					-- end

					local flightStartTime_hour = (CampTotalTimeS / 3600) + (flight[f].route[1].eta / 3600)
					local flightEndTime_hour = (CampTotalTimeS / 3600) + (flight[f].route[#flight[f].route].eta / 3600)

					--temps calculé par sortie_rate:
					local nextRate = flightStartTime_hour + time_to_next_mission

					-- --temps de remise en oeuvre:
					-- local remiseEnOeuvre = math.random(1800, 14400)/3600
					-- local downtime_hour = flightEndTime_hour + remiseEnOeuvre

					--temps de remise en oeuvre:

					local downtime_hour = flightEndTime_hour
					if downtime_hour < nextRate then
						downtime_hour = nextRate
					end

					-- print("AtoT AcftAvail ________________________ "..flight[f].name.." :flight "..f.."-"..u)
					-- print("AtoT AcftAvail ___________________________ "..flight[f].name.." CampTotalTimeH "..CampTotalTimeS/3600)
					-- print("AtoT AcftAvail ___________________________ "..flight[f].name.." flightStartTime_hour "..flightStartTime_hour)

					if (flight[f].task == "Refueling" or flight[f].task == "AWACS") then
						if downtime_hour < ((CampTotalTimeS  + mission_ini.idle_time_min)/ 3600 ) then
							-- print("AtoT AcftAvail _______table.insert Refueling__AWACS_____ "..flight[f].name.." downtime_hour "..downtime_hour)
							table.insert(AcftAvail[flight[f].name].unavailable, downtime_hour)
						else
							-- print("AtoT AcftAvail _______Refueling__AWACS____*******_______________ dont insert OVERTIME "..flight[f].name.." downtime_hour "..downtime_hour.."******************")
						end
					else
						-- if flightEndTime_hour < ((CampTotalTimeS  + mission_ini.mission_duration)/ 3600 ) then
							-- print("AtoT AcftAvail __________table.insert_________________ "..flight[f].name.." downtime_hour "..downtime_hour)
							table.insert(AcftAvail[flight[f].name].unavailable, downtime_hour)						--insert unavailable time into unavailable table of this unit
						-- else
						-- 	-- print("AtoT AcftAvail ___________________________*******_______________ dont insert OVERTIME "..flight[f].name.." downtime_hour "..downtime_hour.."******************")
						-- end						
					end
				end
			end
		end
	end
end

-- --complete unit unavailable table with zero entries for unassigned aircraft
-- for side,unit in pairs(oob_air) do																					--iterate through all sides
-- 	for n = 1, #unit do																								--iterate through all units
-- 		if AcftAvail[unit[n].name] and AcftAvail[unit[n].name].unavailable then
-- 			for u = 1, unit[n].roster.ready - #AcftAvail[unit[n].name].unavailable do					--for all ready aircraft that are not assigned to the ATO			
-- 				table.insert(AcftAvail[unit[n].name].unavailable, 0)									--insert a zero unavilable entry
-- 				print("AtoT AcftAvail __________table.insert_0________________ "..unit[n].name.." "..u)
-- 			end
-- 		end
-- 	end
-- end


if Debug.debug then
	local camp_str = "AtoTiming = " .. TableSerialization(ATO, 0)						--make a string
	local campFile = io.open("Debug/ATO_AtoTiming.lua", "w") or error("Failed to open debug file")
	campFile:write(camp_str)															--save new data
	campFile:close()


	-- print("AtoT #TOT_TimeOccupation " ..tostring(#TOT_TimeOccupation))
	if #TOT_TimeOccupation == 0 then
		table.insert(TOT_TimeOccupation, timingQuarOccupation)
	else
		-- _affiche(TOT_TimeOccupation, "TOT_TimeOccupation")
		-- _affiche(timingQuarOccupation, "timingQuarOccupation")
		table.insert(TOT_TimeOccupation, timingQuarOccupation)
	end

	camp_str = "TOT_TimeOccupation = " .. TableSerialization(TOT_TimeOccupation, 0)
	campFile = io.open("Debug/TOT_TimeOccupation_AtoT.lua", "w") or error("Failed to open debug file")
	campFile:write(camp_str)
	campFile:close()

	local test_str = "AcftAvail = " .. TableSerialization(AcftAvail, 0)
	local testFile = io.open("Debug/Aircraft_availability_AtoT.lua", "w") or error("Failed to open debug file")
	testFile:write(test_str)
	testFile:close()

	local debugTmp = StringToTxt(debugTxt_AtoT)
	local debugTmpFile = io.open("Debug/debugTxt_AtoT_AtoTiming.lua", "w") or error("Failed to open debug file")
	debugTmpFile:write(debugTmp)
	debugTmpFile:close()


end
-- local camp_str = "CAMPTiming = " .. TableSerialization(camp, 0)			
-- local campFile = io.open("Debug/CAMP_Timing_AtoFP.lua", "w")				
-- campFile:write(camp_str)													
-- campFile:close()

