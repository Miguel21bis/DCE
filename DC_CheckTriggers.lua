--To run the campaign triggers. Evaluate trigger conditions, run trigger actions and append briefing text
--Initiated by MAIN_NextMission.lua
------------------------------------------------------------------------------------------------------- 
------------------------------------------------------------------------------------------------------- 
-- last modification: cleanCode_g M33_n
if not versionDCE then versionDCE = {} end
versionDCE["DC_CheckTriggers.lua"] = "1.16.95"
------------------------------------------------------------------------------------------------------- 
------------------------------------------------------------------------------------------------------- 
-- cleanCode_g				(g springCleaning)
-- adjustment_m				(m add new country if template need)(L win totalAirUnitAliveBySide)(k \\" to \")(j moveToAnotherBaseOrDeactivate name & attributes)(i add moveToAnotherBaseOrDeactivate)(h taskSelected)(g airReinforceDelay)(f add targetIsActive)(e check found activate target)(d totalAirUnitAliveBySide)(c add automaticReinforce) (a boat CampTotalTimeS)
-- debug_g					(fg -nan(ind) Return.BaseAlive)(e link of briefing)(d: ensures that DCE chooses between several ship patrol areas)(a: n'ajoute pas le texte s'il existe d�j�)
-- modification M73_d		automatic squad transfer based on available/unavailable runways/bases (c disabledByDCE)
-- modification M71_b		PayloadRestricted (b Action.RestrictedLoadout(file))
-- modification M70_a		GroundZoneTarget (adds the possibility of counting unit completeness by zone) 
-- modification M66_d		bombOnRunway and ActivateBaseAndItsUnits (d <0 non réparable)
-- modification M53_cd		simplification of the "Reserves" variable (cd: debug)(b: add reserve in AirUnitAlive)
-- modification M51_a		kill Pedro when CV sink
-- modification M50_b		Records landings for later use in logistics (C-130, Transport...) (b: suivi en %)
-- modification M48_h		Accept result mission (h: debug firstNews) (g: addImage trigger)(f: debug)(d: garde en memoire le txt camp["Briefing_text"])
-- modification M40_l		Template Active GroundGroup moving front (l: TemplateDeactivate)(k: update route)(ij: bug insert) (fgh: sideBase)(e: heading unite & group)(d: movedXY bug) (c: new unitId) (b: bug 2.7)
-- modification M38_j		Check and Help CampaignMaker (ij more info)(h: KillTarget step by step)
-- modification M33_n 		Custom Briefing (n don't overwrite old briefing info)(lm: use  DictKey_descriptionText)
-- modification M19_f		RepairGround
-- modification M11			Multiplayer
------------------------------------------------------------------------------------------------------- 
------------------------------------------------------------------------------------------------------- 



--List of Return functions to build conditions:
--Return.Time()												returns time of day in seconds
--Return.Day()												returns day of month
--Return.Month()											returns month as number
--Return.Year()												returns year as number
--Return.Mission()											returns campaign mission number
--Return.CampFlag(flag-n)									returns value of campaign flag
--Return.AirUnitActive("UnitName")							returned boolean whether the air unit is active			
--Return.AirUnitReady("UnitName")							returns amount of ready aircraft in unit
--Return.AirUnitAlive("UnitName")							returns amount of ready and damaged aircraft in unit
--Return.AirUnitBase("UnitName")							returns the name of the airbase the unit operats from
--Return.AirUnitPlayer("UnitName")							returns boolean whether the air units is playable
--Return.TargetAlive("TargetName")							returns percentage of alive sub elements in target
--Return.UnitDead(unitname)									(ADD) return vehicle/ship units dead (ADD)
--Return.GroupHidden("GroupName")							returns group hidden status
--Return.GroupProbability("GroupName")						returns group spawn probability value between 0 and 1
--Return.ShipGroupInPoly(GroupName, PolyZonesTable)			(ADD) return boolean whether ship group is in polygon (ADD)

--List of Action functions for trigger actions:
--Action.None()
--Action.Text("your briefing text")
--Action.TextPlayMission(arg)																--add trigger text to briefing text of this mission only if it is playable
--Action.SetCampFlag(flag-n, boolean/number)												--
--Action.AddCampFlag(flag-n, number)														--
--Action.AddImage("filname.jpg")															--
--Action.CampaignEnd("win"/"draw"/"loss")													--
--Action.TargetActive("TargetName", boolean)												--
--Action.AirUnitActive("UnitName", boolean)													--

--Action.UnitResuscitateOrKill("UnitName", boolean, value)								--

--Action.AirUnitBase("UnitName", "BaseName")												--
--Action.AirUnitPlayer("UnitName", boolean)													--
--Action.AirUnitReinforce("SourceUnitName", "DestinationUnitName", destNumber)				--
--Action.AirUnitRepair()																	--
--Action.GroundUnitRepair()																	-- Repair Ground
--Action.AddGroundTargetIntel("sideName")													--
--Action.GroupHidden("GroupName", boolean)													--
--Action.GroupProbability("GroupName", number 0-1)											--
--Action.GroupMove(GroupName, ZoneName)														-- move vehicle group to refpoint (See the DC_CheckTriggers.lua file for more explanation)
--Action.GroupSlave(GroupName, master, bearing, distance)									-- (ADD)
--Action.ShipMission(GroupName, WPtable, CruiseSpeed, PatrolSpeed, StartTime)				-- assign and run a movement mission to a ship group (See the DC_CheckTriggers.lua file for more explanation)
--Action.TemplateActive(TabFile)															-- Template Active GroundGroup moving front (single file : active template) (if tab file: random activation)
--Action.SetWeather( "weather = { pHigh = 78, etc... }" )									-- modifies conf_mod weather parameters during the campaign


--Important notes:
--for condition and action strings: outside with single quotes '', inside with double quotes ""!

local debugKT = false

if not TaskRefused and not camp.waitingNextGen and not (EndCampaign or camp.endCampaign ) and not Firstmission_flag   then
	BriefingImagesB = {}                                         --reset stockImage
	BriefingImagesR = {}                                         --reset stockImage
end
----- campaign flags -----
if camp.flag == nil then
	camp.flag = {}
end

if not camp.automaticReinforce then
	camp.automaticReinforce = {
		blue = 0,
		red = 0,
		neutral = 0,
	}
end

if type(camp.automaticReinforce) ~= "table" then

	local tempValue = Deepcopy(camp.automaticReinforce)

	camp.automaticReinforce = {
		blue = tempValue,
		red = tempValue,
		neutral = tempValue,
	}
end

-- _affiche(camp.automaticReinforce, "camp.automaticReinforce")
-- os.execute 'pause'

local old_flag = Deepcopy(camp.flag)												--copy campaign flags, so that modifications of flags do not affect condition of subsequent campaign triggers in same mission


----- functions to return campaign information to build trigger conditions -----
Return = {}

	--return the time of day in seconds
	function Return.Time()
		return camp.time
	end

	--return day of month
	function Return.Day()
		return camp.date.day
	end

	--return month as number
	function Return.Month()
		return camp.date.month
	end

	--return year
	function Return.Year()
		return camp.date.year
	end

	--return mission number
	function Return.Mission()
		return camp.mission
	end

	--return campagn flag
	function Return.CampFlag(arg)
		return old_flag[arg]													--return old_flag (unmodified by other campaign trigger in same mission)		
	end

	--return if air unit is active
	function Return.AirUnitActive(name)
		for side_name,side in pairs(oob_air) do									--iterate through sides in oob_air
			for unit_n,unit in pairs(side) do									--iterate through units in side
				if unit.name == name then										--unit found
					if unit.inactive == true then
						return false
					else
						return true
					end
				end
			end
		end
	end

	--return if target is active
	function Return.targetIsActive(targetName)
		if debugKT then print(" 	 Return.targetIsActive---> : ".." "..tostring(targetName)) end
		for sidename, targets in pairs(targetlist) do
			for targetN, target in pairs(targets) do
				if target.titleName and  target.titleName == targetName then
					if target.inactive == true then
						if debugKT then print(" 	 Return.targetIsActive---> : return false") end
						return false
					else
						if debugKT then print(" 	 Return.targetIsActive---> : return true") end
						return true
					end
				end
			end
		end
	end

	--return number of ready aircraft for an air unit
	function Return.AirUnitReady(name)
		local found
		for side_name,side in pairs(oob_air) do									--iterate through sides in oob_air
			for unit_n,unit in pairs(side) do									--iterate through units in side
				if unit.name == name then										--unit found
					if unit.roster.ready then
						found = true
						if debugKT then print(" 	 Return.AirUnitReady---> : "..name.." "..tostring(unit.roster.ready)) end
						return unit.roster.ready									--return number of ready aircraft
					end
				end
			end
		end
		if not found then
			return 0
		end
	end

	--return number of ready + damaged aircraft for an air unit
	function Return.AirUnitAlive(name)
		for side_name,side in pairs(oob_air) do									--iterate through sides in oob_air
			for unit_n,unit in pairs(side) do									--iterate through units in side
				if unit.name == name then										--unit found
					local Reserves = 0
					if unit.roster.reserve then
						Reserves = unit.roster.reserve
					end
					return unit.roster.ready + unit.roster.damaged + Reserves	--return number of ready and damaged aircraft
				end
			end
		end
	end

	--return number of ready + damaged + reserve aircraft by side
	function Return.totalAirUnitAliveBySide(sideTest)
		local sum = 0

		for side_name, side in pairs(oob_air) do									--iterate through sides in oob_air
			if side_name == sideTest then
				for unit_n,unit in pairs(side) do									--iterate through units in side
					if not unit.inactive then										--unit found
						sum = sum + unit.roster.ready
						if unit.roster.reserve then
							sum = sum + unit.roster.reserve
						end
						if unit.roster.damaged then
							sum = sum + unit.roster.damaged
						end
					end
				end
			end
		end
		-- print("DcCT sideTest:A "..tostring(sideTest).." sum: "..tostring(sum).." nbMission "..tostring(camp.mission))
		-- os.execute 'pause'
		if sum == 0 and camp.mission <= 1 then
			sum = 9999
		end
		-- print("DcCT sideTest:B "..tostring(sideTest).." sum: "..tostring(sum).." nbMission "..tostring(camp.mission))
		return sum
	end

	--return air unit base
	function Return.AirUnitBase(name)
		for side_name,side in pairs(oob_air) do									--iterate through sides in oob_air
			for unit_n,unit in pairs(side) do									--iterate through units in side
				if unit.name == name then										--unit found
					return unit.base											--return base
				end
			end
		end
	end

	--return air unit player
	function Return.AirUnitPlayer(name)
		for side_name,side in pairs(oob_air) do									--iterate through sides in oob_air
			for unit_n,unit in pairs(side) do									--iterate through units in side
				if unit.name == name then										--unit found
					return unit.player											--return player
				end
			end
		end
	end

	--return alive percentage of target
	function Return.TargetAlive(targetName)
		local foundTarget = false
		for side_name, targets in pairs(targetlist) do								--iterate through sides in targetlist
			for targetN, target in pairs(targets) do							--iterate through targets in side
				if target.titleName and  target.titleName == targetName then								--target found
					foundTarget = true
					if target.alive then
						return target.alive											--return alive percentage of target
					else
						return 100
					end

				end
			end
		end
		if not foundTarget and Debug.debug  then
			print("DcCT no found |"..tostring(targetName).."| in targetList, from campTriggers condition ")
			os.execute 'pause'
		end
	end

	--Strategics bâtiments que j'ajoute parfois dans certaines campagnes (strategics : avec les noms des bâtiments)
	-- +
	--bâtiments de la carte (coordonnées) 

	--return alive percentage of target
	function Return.BaseAlive(basename)
		local foundBase = false
		local nTotal = 0
		local nElementDead = 0
		local returnValue

		for side_name, targets in pairs(targetlist) do								--iterate through sides in targetlist
			for targetN, target in pairs(targets) do							--iterate through targets in side
				if target.titleName and target.titleName == basename or basename == target.db_airbaseName then

					local rightAttribute = false
					foundBase = true

					-- print("DcCT DEBUT Return.BaseAlive(basename) "..basename.." "..tostring(rightAttribute))

					if  target.attributes then
						if tostring(target.attributes) == "Structure" then
							rightAttribute = true
						elseif type(target.attributes) == "table" then
							for n , attribute in  pairs(target.attributes) do
								if attribute == "Structure" then
									rightAttribute = true
								end
							end
						end
					end

					if type(target.elements) == "table" then
						if rightAttribute then
							nTotal = nTotal + #target.elements
						end
						for element_n, element in pairs(target.elements) do
							if rightAttribute and element.dead then
								nElementDead = nElementDead + 1
								-- print("DcCT Return.BaseAlive nElementDead "..nElementDead.." element.name: "..tostring(element.name).." rightAttribute: "..tostring(rightAttribute))
							end
						end
					end
				end
			end
		end

		-- if debugKT then
		-- 	print("DcCT Return.BaseAlive(basename) "..basename.." nElementDead: "..tostring(nElementDead).." nTotal: "..tostring(nTotal))
		-- end

		-- if foundBase then 
		if nTotal > 0 then
			returnValue = (1 - (nElementDead / nTotal)) * 100
			-- print("DcCT Return.BaseAlive() PASSE D ")
		else
			returnValue = 100
			-- print("DcCT Return.BaseAlive() PASSE E ")
		end



		-- print("DcCT Return.BaseAlive(basename) "..basename.." returnValue: "..tostring(returnValue))

		db_airbases[basename].baseAlive = returnValue

		return returnValue
	end

	--return vehicle/ship units dead
	function Return.UnitDead(unitname)
		for sidename,side in pairs(oob_ground) do								--iterate through sides in ground OOB
			for c = 1, #side do													--iterate through countries in side
				for typename,typetable in pairs(side[c]) do						--iterate through country table content
					if typename == "vehicle" or typename == "ship" then			--for vehciles or ships
						for group_n,group in pairs(typetable.group) do			--iterate through groups
							for unit_n,unit in pairs(group.units) do			--iterate through units
								if unit.name == unitname then					--unit found
									if unit.dead then							--unit is dead
										return true								--return true
									end
								end
							end
						end
					end
				end
			end
		end
		return false
	end

	--return vehicle/ship group hidden status
	function Return.GroupHidden(groupname)
		for sidename,side in pairs(oob_ground) do								--iterate through sides in ground OOB
			for c = 1, #side do													--iterate through countries in side
				for typename,typetable in pairs(side[c]) do						--iterate through country table content
					if typename == "vehicle" or typename == "ship" then			--for vehciles or ships
						for group_n,group in pairs(typetable.group) do			--iterate through groups
							if group.name == groupname then						--group is found
								return group.hidden								--return group hiden status
							end
						end
					end
				end
			end
		end
	end

	--return vehicle/ship group probability status
	function Return.GroupProbability(groupname)
		for sidename,side in pairs(oob_ground) do								--iterate through sides in ground OOB
			for c = 1, #side do													--iterate through countries in side
				for typename,typetable in pairs(side[c]) do						--iterate through country table content
					if typename == "vehicle" or typename == "ship" then			--for vehciles or ships
						for group_n,group in pairs(typetable.group) do			--iterate through groups
							if group.name == groupname then						--group is found
								local prob = group.probability
								if prob == nil then								--if the value is nil
									prob = 1									--then probability of spawn is 1
								end
								return prob										--return group probability of spawn value
							end
						end
					end
				end
			end
		end
	end

	--return boolean whether ship group is in polygon
	function Return.ShipGroupInPoly(GroupName, PolyZonesTable)
		for coal_name,coal in pairs(oob_ground) do												--go through sides(red/blue)	
			for country_n,country in ipairs(coal) do											--go through countries
				if country.ship then															--country has ships
					for group_n,group in ipairs(country.ship.group) do							--go through groups
						if group.name == GroupName then											--group found
							local point = {														--local table to store group position
								x = group.x,
								y = group.y
							}
							if #PolyZonesTable == 1 then										--if polygon has just one point
								if point.x == Refpoint[PolyZonesTable[1]].x and point.y == Refpoint[PolyZonesTable[1]].y then		--group is exactly on point
									return true
								else
									return false
								end
							elseif #PolyZonesTable == 2 then									--if polygon has two points
								local p1 = Refpoint[PolyZonesTable[1]]
								local p2 = Refpoint[PolyZonesTable[2]]
								if (point.x >= p1.x and point.x <= p2.x) or (point.x >= p2.x and point.x <= p1.x) then		--point.x is between x-component of p1 and p2
									if (point.y >= p1.y and point.y <= p2.y) or (point.y >= p2.y and point.y <= p1.y) then	--point.y is between y-component of p1 and p2
										local dx = p2.x - p1.x
										local dy = p2.y - p1.y
										if math.floor(dx / (point.x - p1.x) * 1000) == math.floor(dy / (point.y - p1.y) * 1000) then		--point is on line defined by p1 and p2
											return true
										else
											return false
										end
									end
								end
							else																--if polygon has more than two points
								local poly = {}													--table to store x-y coordinates of all points of polygon
								for n = 1, #PolyZonesTable do
									poly[n] = Refpoint[PolyZonesTable[n]]
								end
								return CheckPointInPolygon(point, poly)							--checks if point is in polygon, returns true or false
							end
						end
					end
				end
			end
		end
	end



		--returns the logistics of a base in weight
	function Return.PlaceLogistic(placeName)
		for db_baseName, base_ in pairs(db_airbases) do								--iterate through sides in oob_air		
			if db_baseName == placeName  then										--unit found
				if base_.logistic then
					return base_.logistic
				else
					return 0
				end
			end
		end
	end

	--return alive percentage of target
	function Return.LogisticObjectif(placeName, weightObjectif)
		for db_baseName, base_ in pairs(db_airbases) do								--iterate through sides in oob_air		
			if db_baseName == placeName  then										--unit found
				if base_.logistic then
					local result = math.ceil(base_.logistic / weightObjectif * 100)
					return result
				else
					return 0
				end
			end
		end
	end

----- functions to buld trigger actions -----
Action = {}

	--void action
	function Action.None()
	end

	--add briefing text
	function Action.Text(arg, clear)
		--n'ajoute pas le texte s'il existe deja

		if debugKT then
			print("DcCT PBriefing_text "..type(Briefing_text))
			print("DcCT arg "..type(arg))

			_affiche(Briefing_text, "Briefing_text DcCT")
			_affiche(arg, "arg")
		end

		if string.find(Briefing_text, arg) then
			-- print("DcCT PASSE B ")
			return
		end

		if clear then
			-- Briefing_status = ""												--clear briefing text from previous mission instances
			Briefing_text = Briefing_text .. arg .. " \n \n"					--add trigger text to briefing text of this mission instance with double new line
			-- print("DcCT PASSE C "..Briefing_text)
		else
			Briefing_text = Briefing_text .. arg .. " \n \n"					--add trigger text to briefing text of this mission instance with double new line
			-- print("DcCT PASSE D "..Briefing_text)
		end
	end

	--add briefing text
	function Action.TextPlayMission(arg)
		Briefing_text_playable = Briefing_text_playable .. arg .. " \n \n"		--add trigger text to briefing text of this mission only if it is playable
	end

	--add briefing picture
	function Action.AddImage(filename, side)
		if side == "blue"  then
			table.insert(BriefingImagesB, filename)									--add filename to briefing images table, will be added to mission file when this gets created
		elseif side == "red"  then
			table.insert(BriefingImagesR, filename)
		elseif side == "all" or side == "" or side == nil then
			table.insert(BriefingImagesB, filename)
			table.insert(BriefingImagesR, filename)
		end
	end

	--set campagn flag to value
	function Action.SetCampFlag(n, value)
		camp.flag[n] = value
	end

	--add or subtract to campaign flag
	function Action.AddCampFlag(n, add)
		camp.flag[n] = camp.flag[n] + add
	end

	--end campaign
	function Action.CampaignEnd(arg)
		EndCampaign = arg
		camp.endCampaign = arg
		if debugKT then print(" 	Action.CampaignEnd(arg)---> : "..tostring(arg)) end

		print()
		print("********************ATTENTION******************")
		print(" 	Action.CampaignEnd(arg)---> : "..tostring(arg))
		print(" 	Action.CampaignEnd(arg)---> : "..tostring(Briefing_text))
		print("********************ATTENTION******************")
		print("*************** Attention, take into account that the campaign is over, press to see the rest..****************")
		print("********************ATTENTION******************")
		print()
		os.execute 'pause'
	end

	--set target active/inactive
	local targetFound = false
	function Action.TargetActive(targetName, state)
		for sidename, targets in pairs(targetlist) do
			for targetN, target in pairs(targets) do
				if target.titleName and  target.titleName == targetName then
					if state == true then										--state argument is true
						target.inactive = false									--make inactive false
						targetFound = true
					elseif state == false then									--state argument is false
						target.inactive = true									--make inactive true
						targetFound = true
					end
				end
			end
		end
		if not targetFound then
			print("DcCT not found "..targetName.." in targetlist file")
			os.execute 'pause'
		end
	end

	--set target priority
	function Action.TargetPriority(targetName, priority)
		for sidename, targets in pairs(targetlist) do
			for targetN, target in pairs(targets) do
				if target.titleName and  target.titleName == targetName then
					target.priority = priority
					break
				end
			end
		end
	end

	--set target priority
	function Action.SetWeather(new_Weather)

		loadstring(new_Weather)()

		---@diagnostic disable-next-line: undefined-global
		if weather.pHigh then mission_ini.weather.pHigh = weather.pHigh end
		---@diagnostic disable-next-line: undefined-global
		if weather.pLow then mission_ini.weather.pLow = weather.pLow end
		---@diagnostic disable-next-line: undefined-global
		if weather.refTemp then mission_ini.weather.refTemp = weather.refTemp end
		---@diagnostic disable-next-line: undefined-global
		if weather.weatherChangeRate then mission_ini.weather.weatherChangeRate = weather.weatherChangeRate end

		UpdateConfMod(mission_ini.weather, nil)

	end



	--set unit active/inactive
	function Action.AirUnitActive(unitName, state)
		for side_name,side in pairs(oob_air) do									--iterate through sides in oob_air
			for unit_n,unit in pairs(side) do									--iterate through units in side
				if unit.name == unitName then									--unit found
					if state == true then										--state argument is true
						unit.inactive = false									--make inactive false
					elseif state == false then									--state argument is false
						unit.inactive = true									--make inactive true
					end
				end
			end
		end
	end

	--set unit active/inactive
	function Action.KillPedro(pedroName)
		for sidename,side in pairs(oob_ground) do								--iterate through sides in ground OOB
			for c = 1, #side do													--iterate through countries in side
				for typename,typetable in pairs(side[c]) do						--iterate through country table content
					if typename == "helicopter"  then							--for helicopter
						for group_n,group in pairs(typetable.group) do			--iterate through groups
							for unit_n,unit in pairs(group.units) do			--iterate through units
								if unit.name == pedroName then					--unit found
									unit.dead = true
								end
							end
						end
					end
				end
			end
		end
	end


	--Miguel21 modification M40.g : Template Active GroundGroup moving front (f: sideBase)
	--set side base
	function Action.SideBase(NewSide, baseName)

		if NewSide == "blue" then
			OldSide = "red"
		else
			OldSide = "blue"
		end

		for db_baseName, base in pairs(db_airbases) do							--iterate through sides in db_airbases
			if db_baseName == baseName then										--unit found
				base.side = NewSide												--set new airbase for unit
			end
		end

		--change de camp dans le target liste
		--attention, les camps sont inversé, c'est le camp du target, ou la targetlist d'un camp (trouc de ouf)
		for side_name, targets in pairs(targetlist) do													--Iterate through all side
			for targetN, target in pairs(targets) do												--Iterat through all targets
				if target.titleName and target.titleName == baseName and NewSide  == side_name then
					targetlist[OldSide][baseName] = targetlist[side_name][baseName]			--integration de ce target dans le camp oppos�				
					targetlist[side_name][baseName] = nil										--suppression de ce target de l'ancien camp		
				end
			end
		end

		--change de camp dans le oob
		for country_n, country  in pairs(oob_ground[OldSide]) do													--Iterate through all side
			if country.static then															--country has ships
				for group_n, _group in ipairs(country.static.group) do							--go through groups
					if  string.find(_group.name, baseName) then
						table.insert(oob_ground[NewSide][1].static.group, _group )
						table.remove(oob_ground[OldSide][country_n].static.group, group_n)
					end
				end
			end

			--Cef ne veut pas changer les vehicules de camp :( ^^
			-- if country.vehicle then															--country has ships
				-- for group_n, _group in ipairs(country.vehicle.group) do							--go through groups
					-- if  string.find(_group.name,baseName) then
						-- table.insert(oob_ground[NewSide][1].vehicle.group, _group )						
						-- table.remove(oob_ground[OldSide][country_n].vehicle.group, group_n)
					-- end
				-- end
			-- end
		end

	end

	--activates or deactivates a base and the units stationed on it 
	function ActivateBaseAndAssociatedTargets(baseName, active)
		local inactive
		if active then
			inactive = false
		else
			inactive = true
		end

		for db_baseName, base in pairs(db_airbases) do
			if db_baseName == baseName then
				base.inactive = inactive
				-- if debugKT then print(" 	ActivateBaseAndAssociatedTargets DcCT "..db_baseName.." "..tostring(active)) end
				break
			end
		end

		for sidename, targets in pairs(targetlist) do
			for targetN, target in pairs(targets) do
				if target.db_airbaseName == baseName then
					if target.alwaysActive == nil or target.alwaysActive == false  then
						if target.inactive ~= inactive then
							target.inactive = inactive
							-- if debugKT then print(" 	ActivateBaseAndAssociatedTargets DcCT "..tname.." "..tostring(active)) end
						end
					else
						if debugKT then print(" 	ActivateBaseAndAssociatedTargets DcCT alwaysActive=true impossible à désactiver "..baseName.." "..tostring(active)) end
					end
				end
			end
		end

	end

	--activates or deactivates a base and the units stationed on it 
	function Action.ActivateBaseAndItsUnits(baseName, activeBase)
		local inactive
		local baseMutation

		if activeBase then
			inactive = false
		else
			inactive = true
		end

		if debugKT then print(" 	->START function Action.ActivateBaseAndItsUnits   "..baseName) end

		for db_baseName, base in pairs(db_airbases) do
			if db_baseName == baseName and base.inactive ~= inactive then
				base.inactive = inactive
				if debugKT then print(" 		         ->ActivateBaseAndItsUnits db_airbases  "..baseName.." base.inactive? "..tostring(base.inactive)) end
				break
			end
		end

		for side_name, side in pairs(oob_air) do
			for unit_n, unit in pairs(side) do

				--parse toutes les unités qui sont stationnées sur la base en question
				--et regarde s'il est possible de les transferer ailleurs
				--ou alors, ces unités sont désactivée dans moveToAnotherBaseOrDeactivate
				if unit.base == baseName then

					local transfertPossible = false
					if unit.baseAlternative then
						if debugKT then print("		 		->ActivateBaseAndItsUnits baseAlternative oob_air.inactive? "..tostring(unit.inactive).." : "..tostring(unit.name)) end

						transfertPossible = Action.moveToAnotherBaseOrDeactivate(unit.name, unit.baseAlternative )

					else

						if unit.inactive ~= inactive then
							if inactive == true then

								unit.inactive = inactive
								unit.disabledByDCE = true

								if debugKT then print("		 		->ActivateBaseAndItsUnits oob_air.inactive "..tostring(unit.inactive).." : "..tostring(unit.name)) end

							elseif inactive == false and unit.disabledByDCE then

								unit.inactive = inactive
								unit.disabledByDCE = nil

								if debugKT then print("		 		->ActivateBaseAndItsUnits oob_air.inactive "..tostring(unit.inactive).." : "..tostring(unit.name)) end

							end
						end
					end
				end
			end
		end

		--attention, ce script active automatiquement les targets des bases, ce qui nest pas toujours voulue (NAM)
		-- for sidename, targets in pairs(targetlist) do
		-- 	for targetN, target in pairs(targets) do
		-- 		if target.db_airbaseName == baseName then
		-- 			if target.inactive ~= inactive then
		-- 				target.inactive = inactive
		-- 				if debugKT then print("		 		->ActivateBaseAndItsUnits targetlist "..baseName.." target.inactive?: "..tostring(target.inactive)) end
		-- 			end
		-- 		end
		-- 	end
		-- end

		if debugKT then print(" 	->FIN function Action.ActivateBaseAndItsUnits   "..baseName) end

	end


	--set unit base
		-- Action.AirUnitBase()

		-- bouger un squad en indiquant seulement la base de destination
		-- 'Action.AirUnitBase("28 GvIAP", {"Tiyas","Damascus Airbase"})',

	function Action.AirUnitBase(unitName, tab_baseName)

		local function AirUnitBaseInternal(unitName, baseDestination)
			if type(baseDestination) ~= "string" then
				print("DcCT AirUnitBase ERROR unitName: "..tostring(unitName).." the destination database is a table")
				_affiche(baseDestination, "DcCT baseDestination")
				os.execute 'pause'
			end

			for side_name, air in pairs(oob_air) do
				for unit_n, unit in pairs(air) do
					if unit.name == unitName and unit.base ~= baseDestination then
						unit.base = baseDestination										--set new airbase for unit
						-- ActivateBaseAndAssociatedTargets(baseDestination, true)
						Action.Text(unitName.."  moveToAnotherBase."..baseDestination)
					end
				end
			end
		end

		if type(tab_baseName) == "string" then
			AirUnitBaseInternal(unitName, tab_baseName )
		elseif type(tab_baseName) == "table" and #tab_baseName == 1 then
			AirUnitBaseInternal(unitName, tab_baseName[1] )
		elseif type(tab_baseName) == "table" and #tab_baseName > 1 then
			for n, baseName in ipairs(tab_baseName) do
				--TODO placeToBeFound n'est plus utiliser, pourquoi?
				-- placeToBeFound = AirUnitBaseInternal(unitName, baseName )
				break
			end
		end


	end



	--move a unit to another air base
		-- Action.moveToAnotherBaseOrDeactivate()

		-- bouger UN squad en indiquant seulement la base de destination
		-- 'Action.moveToAnotherBaseOrDeactivate("28 GvIAP", {"Tiyas","Damascus Airbase"})',


	function Action.moveToAnotherBaseOrDeactivate(unitName, tab_baseName)
		if debugKT then print(" ->START function Action.moveToAnotherBaseOrDeactivate unitName  "..unitName) end
		local transfertOk = false

		local typeAeronef
		local sideUnite
		local inactive

		--recupere le type d aeronef pour savoir si c'est un helico ou pas
		for side, squads in pairs(oob_air) do
			for squadN, squad in ipairs(squads) do

				if unitName == squad.name then
					if debugKT then print("				DcCT check  unitName : "..tostring(unitName).." ==squad.name: "..tostring(squad.name)) end
					typeAeronef = squad.type
					sideUnite = side
					inactive = squad.inactive
					break
				end
			end
		end

		if typeAeronef == nil then
			print("				DcCT the typeAeronef i not specified in this unit  oob_air : "..tostring(unitName))
			os.execute 'pause'
		end

		local function checkBaseCapacity(unitName, checkBase)

			if sideUnite == db_airbases[checkBase].side then

				if not db_airbases[checkBase].baseAlive then
					Return.BaseAlive(checkBase)
				end

				if not db_airbases[checkBase].runwayAlive then
					db_airbases[checkBase].runwayAlive = 100
				end

				if IsHelicopter[typeAeronef] then
					if db_airbases[checkBase].baseAlive >= 20  then  --and db_airbases[checkBase].runwayAlive > 20
						if debugKT then print(" 		-> moveToAnotherBaseOrDeactivate IsHelicopter baseAlive > 20 runwayAlive > 20 ") end
						return true
					else
						return false
					end

				else
					if db_airbases[checkBase].baseAlive >= 20 and db_airbases[checkBase].runwayAlive >= 50 then
						if debugKT then print(" 		-> moveToAnotherBaseOrDeactivate PLANE baseAlive > 20 runwayAlive > 50 ") end
						return true
					else
						return false
					end
				end
			else
				return false
			end
		end

		-- local placeToBeFound = false
		if type(tab_baseName) == "string" then
			if checkBaseCapacity(unitName, tab_baseName) then
				-- moveAllOrOneUnit(unitName, tab_baseName )
				Action.AirUnitBase(unitName, tab_baseName)
				-- Action.Text(unitName.."  moveToAnotherBase."..tab_baseName)
				transfertOk = true
			end
		elseif type(tab_baseName) == "table" and #tab_baseName == 1 then
			if checkBaseCapacity(unitName, tab_baseName[1]) then
				-- moveAllOrOneUnit(unitName, tab_baseName[1] 
				Action.AirUnitBase(unitName, tab_baseName[1])
				-- Action.Text(unitName.."  moveToAnotherBase."..tab_baseName[1])
				transfertOk = true
			end
		elseif type(tab_baseName) == "table" and #tab_baseName > 1 then
			-- local placeToBeFound = false
			for n, baseName in ipairs(tab_baseName) do
				if debugKT then print(" 		-> moveToAnotherBaseOrDeactivate table test baseName "..baseName) end
				if checkBaseCapacity(unitName, baseName) then
					-- moveAllOrOneUnit(unitName, baseName )
					Action.AirUnitBase(unitName, baseName)
					if debugKT then print(" 		-> moveToAnotherBaseOrDeactivate table OK baseName "..baseName) end
					-- Action.Text(unitName.."  moveToAnotherBase."..baseName)
					transfertOk = true
					break
				end
			end

		end

		if not transfertOk and not inactive then
			Action.AirUnitActive(unitName, false)
			Action.Text(unitName.."  this unit is deactivated.")
		end

		if debugKT then print(" ->FIN function Action.moveToAnotherBaseOrDeactivate transfertOk?  "..tostring(transfertOk).." "..unitName) end

		return transfertOk
	end


	--set unit playable
	function Action.AirUnitPlayer(unitName, state)
		for side_name,side in pairs(oob_air) do									--iterate through sides in oob_air
			for unit_n,unit in pairs(side) do									--iterate through units in side
				if unit.name == unitName then									--unit found
					unit.player = state											--set new playable state for unit
				end
			end
		end
	end


	--send reinforcement aircraft from one unit to another
	function Action.AirUnitReinforce(sourceName, destName)						--(sourceName, destName, destNumber) destNumber => deprecated
		-- print("DcCT passe 00 sourceName "..tostring(sourceName).." destName: "..tostring(destName))

		local sourceUnit
		local destUnit
		local destSide
		local sourceUnitRosterReserve
		local casA = false
		local casB = false
		for side_name,side in pairs(oob_air) do									--iterate through sides in oob_air
			for unit_n,unit in pairs(side) do									--iterate through units in side
				if unit.name == sourceName then									--source unit found
					sourceUnit = unit											--point source oob unit table to variable					
					-- if sourceUnit.roster.reserve then
					-- 	sourceUnitRosterReserve = sourceUnit.roster.reserve		--cas ou reserve est renseigné
					-- else
					-- 	sourceUnitRosterReserve = sourceUnit.roster.ready		--ancien cas ou il n'y a pas de reserve
					-- end
					sourceUnitRosterReserve = sourceUnit.roster.ready
					destSide = side_name
				end
			end
		end
		for side_name,side in pairs(oob_air) do									--iterate through sides in oob_air
			for unit_n,unit in pairs(side) do									--iterate through units in side
				if unit.name == destName then								--desitination unit found
					destUnit = unit												--point destination oob unit table to variable	
					destSide = side_name										--store side
				end
			end
		end
		--M53_a

		--si (sourceName, ..., ...)
		if destUnit == nil or destUnit == "" then

			if sourceUnit == nil then
				return
			end

			if  not sourceUnit.roster.trans then sourceUnit.roster.trans = 0 end
			destUnit = sourceUnit
			sourceUnitRosterReserve = sourceUnit.roster.reserve
			destName = sourceName
			sourceName = "Reserves"
			casA = true
		end
		--si (sourceName, destName, destNumber)
		-- si sourceName (et donc sourceUnit) n'est pas trouv�
		if sourceUnit == nil or sourceUnit == "" then
			if not destUnit.roster.trans then destUnit.roster.trans = 0 end
			sourceUnit = destUnit
			sourceUnitRosterReserve = sourceUnit.roster.reserve
			casB = true
		end

		if not sourceUnit.roster.trans then sourceUnit.roster.trans = 0 end
		if not destUnit.roster.trans then destUnit.roster.trans = 0 end


		if destUnit.roster.ready < destUnit.number then								--destination ready number is below nominal number
			if sourceUnitRosterReserve > 0 then									--source unit has ready aircraft
				local maxtrans = destUnit.number - destUnit.roster.ready				--maximal number of transferable aircraft
				local request = maxtrans
				-- if maxtrans > 4 then											--limit maxtrans to 4 aircraft
				-- 	maxtrans = 4
				-- end

				local minTrans = 0

				if maxtrans > 0 then											--limit maxtrans to 4 aircraft
					if maxtrans / sourceUnitRosterReserve < 0.5 then
						maxtrans = 8
						minTrans = 2
					elseif maxtrans / sourceUnitRosterReserve < 0.75 then
						maxtrans = 4
						minTrans = 1
					elseif maxtrans / sourceUnitRosterReserve <= 1 then
						maxtrans = 2
					else
						maxtrans = 2
					end
				end

				if maxtrans > request then
					maxtrans = request
				end

				if maxtrans > sourceUnitRosterReserve then
					maxtrans = sourceUnitRosterReserve
				end

				if minTrans > maxtrans then
					minTrans = maxtrans - 1
				end

				--reserve 20 demande 20 : possible faible 20/20 = 1
				--reserve 20 demande 1 : possible fort 20/1 = 20

				--demande 1 reserve 20 : 1/20 = 0.05
				--demande 15 reserve 20 : 15/20 = 0.75
				--demande 20 reserve 20 :  20/20 = 1




				maxtrans = math.ceil( maxtrans)
				-- local minTrans = math.ceil(maxtrans/4*3)


				local trans = math.random(minTrans, maxtrans)							--set random number of actual transferable aircraft
				destUnit.roster.ready = destUnit.roster.ready + trans			--transfer aircraft
				sourceUnitRosterReserve = sourceUnitRosterReserve - trans		--transfer aircraft

				if casA then
					-- print("DcCT passe 11 RosterReserve "..sourceUnitRosterReserve.." - "..trans)
					sourceUnit.roster.reserve = sourceUnitRosterReserve
					sourceUnit.roster.trans = sourceUnit.roster.trans +  trans
				elseif casB then
					-- print("DcCT passe 12 RosterReserve "..sourceUnitRosterReserve.." - "..trans)
					destUnit.roster.reserve = sourceUnitRosterReserve
					destUnit.roster.trans = destUnit.roster.trans +  trans
				else
					-- print("DcCT passe 13A RosterReserve "..sourceUnit.roster.ready.." - "..trans)
					sourceUnit.roster.ready = sourceUnit.roster.ready - trans
					sourceUnit.roster.trans = sourceUnit.roster.trans +  trans
					-- print("DcCT passe 13B RosterReserve "..sourceUnit.roster.ready)		
				end

				local text
				if trans == 1 then
					text = "" .. trans .. " replacement " .. ReplaceTypeName(destUnit.type) .. " has been transferred from " .. sourceName .. " to " .. destName .. ". \n \n"	--text to be added to briefing/oob
				elseif trans > 1 then
				-- else
					text = "" .. trans .. " replacement " .. ReplaceTypeName(destUnit.type) .. " have been transferred from " .. sourceName .. " to " .. destName .. ". \n \n"	--text to be added to briefing/oob
				end

				if text then
					if debugKT then print("DcCT "..tostring(text)) end

					if destSide == "blue" then										--side is blue
						Briefing_oob_text_blue = Briefing_oob_text_blue .. text		--add to blue briefing oob text
					elseif destSide == "red" then									--side is red
						Briefing_oob_text_red = Briefing_oob_text_red .. text		--add to red briefing oob text
					end
				end
			end
		end
	end

	--repair damaged aircraft in all air units
	function Action.AirUnitRepair(arg)
		local s = {}
		if arg == "blue" then														--repair only blue side
			s["blue"] = true
		elseif arg == "red" then													--repair only red side
			s["red"] = true
		else																		--repair both sides
			s["blue"] = true
			s["red"] = true
		end
		for side_name,side in pairs(oob_air) do										--iterate through sides in oob_air
			if s[side_name] then													--this side can repair aircraft
				for unit_n,unit in pairs(side) do									--iterate through units in side
					local repair = 0												--number of repaired aircraft un this round
					for n = 1, unit.roster.damaged do								--iterate through all damaged aircraft
						-- if math.random(1,20) == 1 then							--5% chance of repair
						if math.random(1,100) <= 10 then							--10% chance of repair
							repair = repair + 1
						end
					end
					if repair > 0 then												--if aircraft are repaird in this round
						unit.roster.damaged = unit.roster.damaged - repair

						if unit.roster.reserve and unit.roster.ready + repair >= unit.number then		-- les r�par�s ne doivent pas d�passer le stock initial
							 local returToReserve = unit.roster.ready + repair - unit.number
							unit.roster.reserve = unit.roster.reserve + returToReserve
							unit.roster.trans = unit.roster.trans - returToReserve
							unit.roster.ready = unit.number
						else
							unit.roster.ready = unit.roster.ready + repair
						end
						local text
						if repair == 1 then
							text = "" .. repair .. " damaged " .. ReplaceTypeName(unit.type) .. " from ".. unit.name .. " has been repaired and returned back to service. \n \n"	--text to be added to briefing/oob
						else
							text = "" .. repair .. " damaged " .. ReplaceTypeName(unit.type) .. " from ".. unit.name .. " have been repaired and returned back to service. \n \n"	--text to be added to briefing/oob
						end
						if side_name == "blue" then									--side is blue
							Briefing_oob_text_blue = Briefing_oob_text_blue .. text	--add to blue briefing oob text
						elseif side_name == "red" then								--side is red
							Briefing_oob_text_red = Briefing_oob_text_red .. text	--add to red briefing oob text
						end
					end
				end
			end
		end
	end


	if Debug.AfficheSol then
		print("DC CT GroundTarget BLUE: "..GroundTarget["blue"].percent)
		print("DC CT GroundTarget RED: "..GroundTarget["red"].percent)
	end


	function Action.UnitResuscitateOrKill(targettName, liveOrKill, liveValue)

		-- print()
		-- print("DcCT UnitResuscitateOrKill A0 check Target:  ... "..tostring(targettName) )

		for side_name, targets in pairs(targetlist) do

			local foundTarget

			local groundside = "red"
			if side_name == "red" then
				groundside = "blue"
			end

			for targetN, target in pairs(targets) do

				-- print("DcCT UnitResuscitateOrKill A1 target.name:  ... "..tostring(target.name).." ==? "..tostring(targettName) )

				if target.name == targettName then
					foundTarget = true
					local attribut

					-- print("DcCT UnitResuscitateOrKill A2 found Target:  ... "..tostring(targettName) )

					--dans le cas d'un ressucitage :
					if liveOrKill == true then


						-- if target.attributes then 
						-- 	for attributN, attributName in pairs(target.attributes) do
						-- 		-- print("DcCT A    attributName ... "..tostring(attributName) )
						-- 		attributName = string.lower(attributName)

						-- 		if Attribut2Target[attributName] then
						-- 			attribut = Attribut2Target[attributName]
						-- 			-- print("DcCT B    ASSIGN attribut ... "..tostring(attribut) )
						-- 			break
						-- 		end
						-- 	end
						-- 	if not attribut then
						-- 		for attributN, attributName in pairs(target.attributes) do
						-- 			-- print("DcCT C    attributName ... "..tostring(attributName) )
						-- 			attributName = string.lower(attributName)

						-- 			for key , correspondanceName in pairs(Attribut2Target) do
						-- 				-- print("DcCT D    attributName ... "..tostring(attributName) )

						-- 				if string.match(correspondanceName, attributName) then
						-- 					attribut = correspondanceName
						-- 					-- print("DcCT E    FOUND attribut ... "..tostring(attribut) )
						-- 					break
						-- 				end
						-- 			end

						-- 		end
						-- 	end
						-- end	
						-- if not attribut then
						-- 	attribut = "generic"	
						-- end

						-- print("DcCT UnitResuscitateOrKill A attribut ... "..tostring(attribut) )

						-- if attribut ~= "runway" and target.alive < 100  then
						if target.alive < 100  then

							if target.elements then

								local nbRessucitatMax = math.floor(#target.elements * liveValue/100)
								local nbLiving = 0

								--calcul le nb de mort à ressuciter
								for e = 1, #target.elements do
									if not target.elements[e].dead  then
										nbLiving = nbLiving + 1
									end
								end

								nbRessucitatMax = nbRessucitatMax - nbLiving

								for e = 1, #target.elements do

									local forcedReAlive = false

									if target.elements[e].dead then

										nbRessucitatMax = nbRessucitatMax - 1

										if nbRessucitatMax < 0 then
											break
										end

										forcedReAlive = true

										local text = "" .. target.elements[e].name .. " from ".. target.titleName .. " have been repaired and returned back to service. \n \n"

										if Debug.AfficheSol or debugKT then
											print("Dc_CT Debug Resurrection: "..target.titleName .. " "..target.elements[e].name)
											print("Dc_CT Debug "..text)
										end

										if side_name == "blue" then									--side is blue
											Briefing_oob_text_blue = Briefing_oob_text_blue .. text	--add to blue briefing oob text
										elseif side_name == "red" then								--side is red
											Briefing_oob_text_red = Briefing_oob_text_red .. text	--add to red briefing oob text
										end


										target.elements[e].dead = nil
										target.elements[e].CheckDay = nil

										target.alive = math.floor(target.alive + (1/#target.elements *100))
										if target.alive > 100 then  target.alive = 100 end

										if Debug.AfficheSol or debugKT then
											print("Dc_CT Debug D² : "..target.titleName .. " alive: "..target.alive)
										end

										target.alive_last = math.floor(target.alive_last -  (1/#target.elements *100))
										if target.alive_last < 0 then  target.alive_last = 0 end


									end

									if forcedReAlive then
										-- print("DcCT UnitResuscitateOrKill M1 cherche "..tostring(target.elements[e].name ))
										local endfunction = false

										for c = 1, #oob_ground[groundside] do
											for category, groups in pairs(oob_ground[groundside][c]) do
												if type(groups) == "table" and groups["group"]  then	--and groups[1].units
													for groupN, group in pairs(groups["group"]) do
														for unitN, unit in pairs(group.units) do
															if  target.elements[e].name == unit.name then

																-- print("DcCT UnitResuscitateOrKill ? Found  oob_ground..unit.name "..tostring(unit.name ))

																unit['dead'] = nil
																unit['dead_last'] = nil
																unit.CheckDay = nil

																endfunction = true
															end
															if endfunction then  break end
														end
														if endfunction then  break end
													end
													if endfunction then  break end
												end
												if endfunction then break end
											end
											if endfunction then  break end
										end
									end
								end
							end
						end
					elseif liveOrKill == false then

						if target.elements then

							for e = 1, #target.elements do
								target.elements[e].dead = true
								target.elements[e].CheckDay = CampTotalTimeS

								local endfunction = false
								for c = 1, #oob_ground[groundside] do
									for category, groups in pairs(oob_ground[groundside][c]) do
										if type(groups) == "table" and groups["group"]  then	--and groups[1].units
											for groupN, group in pairs(groups["group"]) do
												for unitN, unit in pairs(group.units) do
													if  target.elements[e].name == unit.name then
														if not unit['dead'] then
															unit['dead'] = true
															unit['dead_last'] = true
															unit.CheckDay = CampTotalTimeS
														end

														endfunction = true
													end
													if endfunction then  break end
												end
												if endfunction then  break end
											end
											if endfunction then  break end
										end
										if endfunction then break end
									end
									if endfunction then  break end
								end


							end
						end

					end
				end
				if foundTarget then return end
			end
		end
	end


	-- Miguel21 modification M19.f : Repair Ground
	function Action.GroundUnitRepair()

		for side_name, targets in pairs(targetlist) do
			local groundside = "red"
			if side_name == "red" then
				groundside = "blue"
			end

			for targetN, target in pairs(targets) do

				local attribut
				if target.attributes then
					for attributN, attributName in pairs(target.attributes) do
						attributName = string.lower(attributName)
						if Attribut2Target[attributName] then
							attribut = Attribut2Target[attributName]
							break
						end
					end
					if not attribut then
						for attributN, attributName in pairs(target.attributes) do
							attributName = string.lower(attributName)
							for key , correspondanceName in pairs(Attribut2Target) do
								if string.match(correspondanceName, attributName) then
									attribut = correspondanceName
									break
								end
							end

						end
					end
				end
				if not attribut then
					attribut = "generic"
				end

				local minimumRepairThreshold = campMod.RepairOption[DCS_ENI_Side[side_name]][attribut][1]

				local repairChance = campMod.RepairOption[DCS_ENI_Side[side_name]][attribut][4]

				if target.customRepairOption then
					minimumRepairThreshold = target.customRepairOption[1]
					repairChance = target.customRepairOption[4]
				end

				if target.alive and attribut ~= "runway"  then

					if target.elements then
						for e = 1, #target.elements do
							if target.elements[e] then
								
								
								local temp_dead = nil
								local temp_dead_last = nil
								local temp_CheckDay = nil
								local forcedReAlive = false

								if target.elements[e].dead then
									temp_dead = target.elements[e].dead
									temp_dead_last = target.elements[e].dead_last
									temp_CheckDay = target.elements[e].CheckDay
								end

								--TODO: 1. empecher que les réparations se fassent 2 fois entre chaque génération de misssion -tentative de génération
								-- TODO: 2. le % alive de l'ensemble d'un target n'est pas bon

								if  target.alive < 100 and target.alive >= minimumRepairThreshold then
									if target.elements[e].dead then
										if target.elements[e].CheckDay then
											local repairInterval = campMod.RepairOption[DCS_ENI_Side[side_name]][attribut][3] * 3600
											local lastCheck = target.elements[e].CheckDay

											-- Boucle sur chaque intervalle de réparation entre CheckDay et maintenant
											while lastCheck + repairInterval <= CampTotalTimeS do

												lastCheck = lastCheck + repairInterval
												local test_prob = math.random(1,100)

												if test_prob <= repairChance then
													forcedReAlive = true
													temp_dead = nil
													temp_dead_last = false
													temp_CheckDay = nil

													local text = "" .. target.elements[e].name .. " from ".. target.titleName .. " have been repaired and returned back to service. \n \n"

													if side_name == "blue" then
														Briefing_oob_text_blue = Briefing_oob_text_blue .. text
													elseif side_name == "red" then
														Briefing_oob_text_red = Briefing_oob_text_red .. text
													end

													target.elements[e].dead = nil
													target.elements[e].CheckDay = nil
													target.alive = math.floor(target.alive + (1/#target.elements *100))
													if target.alive > 100 then target.alive = 100 end

													target.alive_last = math.floor(target.alive_last -  (1/#target.elements *100))
													if target.alive_last < 0 then  target.alive_last = 0 end

													break -- On sort de la boucle si la réparation a réussi
												end
											end
											-- Si aucune réparation n'a eu lieu, on met à jour la date de check pour la prochaine fois
											if target.elements[e].dead then
												target.elements[e].CheckDay = lastCheck
											end
										end
									end
								end

								if forcedReAlive then
									local endfunction = false
									for c = 1, #oob_ground[groundside] do
										for class ,typetable in pairs(oob_ground[groundside][c]) do

											if class == "vehicle" or class == "ship" or class == "static" then
													for group_n,group in pairs(typetable.group) do
														for unit_n,unit in pairs(group.units) do
															if  target.elements[e].name == unit.name then

																if Debug.AfficheSol then
																	if temp_dead then print(" temp_dead "..tostring(temp_dead))  end
																	if temp_dead_last then print(" temp_dead_last "..tostring(temp_dead_last))  end
																	if temp_CheckDay then print(" temp_CheckDay "..tostring(temp_CheckDay))  end
																end

																group.units[unit_n]['dead'] = temp_dead
																group.units[unit_n]['dead_last'] = temp_dead_last
																group.units[unit_n].CheckDay = temp_CheckDay

																endfunction = true
															end
															if endfunction then  break end
														end
														if endfunction then  break end
													end
													if endfunction then  break end
												end
											end
										if endfunction then  break end
									end
								end
							end
						end


					-- elseif attibut == "RUNWAY" and target.alive  and  target.alive < 100 and target.alive > campMod.RepairBaseMinimumDestroyed and  target.CheckDay then
					elseif attribut == "runway" and target.alive and target.alive < 100 and target.alive > campMod.RepairOption[DCS_ENI_Side[side_name]]["airbase"][1] and target.CheckDay then
						local oldVAlive = target.alive
						if CampTotalTimeS >= target.CheckDay + 3600 then

							local repairRunwayPerDay = campMod.RepairOption[DCS_ENI_Side[side_name]]["runway"][5]

							if db_airbases[target.db_airbaseName] and db_airbases[target.db_airbaseName].customRepairRunwayPerDay then
								repairRunwayPerDay = db_airbases[target.db_airbaseName].customRepairRunwayPerDay
							end

							-- TODO, imbitable, a refaire, mais un saut temporel de plusieurs mois/jours est bien pris en comtpe
							target.alive = math.ceil(target.alive + repairRunwayPerDay * (((CampTotalTimeS - target.CheckDay )/ 3600)/24))
							target.CheckDay = CampTotalTimeS

							if target.alive > 100  then --or  target.alive >= 50
								target.alive = 100

							end

							Action.Text(target.name.." repair in progress, old value: "..oldVAlive.." new value "..target.alive)

							local nbRunwayPartDead = #target.elements -  (#target.elements * target.alive/100)

							if Debug.AfficheSol or debugKT then
								print("Dc_CT repair Runway "..target.name.." old value: "..oldVAlive.." new value "..target.alive )
								print("Dc_CT repairRunwayPerDay "..repairRunwayPerDay)
								print("Dc_CT RUNWAY repair: "..target.name.." new value: "..target.alive.." nbRunwayPartDead: "..nbRunwayPartDead )
								-- os.execute 'pause'
							end


							--raz tout
							for i=1, #target.elements do
								target.elements[i].dead = nil
								target.elements[i].dead_last = nil
								target.elements[i].CheckDay = nil
							end

							for i=1, #target.elements do

								if i > nbRunwayPartDead then break end

								target.elements[i].dead = true
								target.elements[i].dead_last = true
								target.elements[i].CheckDay = CampTotalTimeS

							end

							--runway réparé
							if oldVAlive < 50 and target.alive >= 50 then
								if attribut ~= nil  and attribut == "runway" then
									if debugKT then print(" 	->RUNWAY Action.ActivateBaseAndItsUnits  active: TRUE "..target.name) end

									Action.ActivateBaseAndItsUnits(target.db_airbaseName,true)
									Action.Text(target.db_airbaseName.." runway is repaired and can be used again.")
								end
							end

						end
					end
				end
			end
		end
	end

	--add ground target intel updates to briefing
	function Action.AddGroundTargetIntel(side)
		if MissionInstance == 1 then											--ground target intel updates are only added in first mission instance (to avoid duplication)
			for targetN, target in pairs(targetlist[side]) do				--iterate through targets in side

				if target.expand then											--target should be displayed with expanded elements
					if target.elements then										--target has elements
						for e = 1, #target.elements do							--iterate through elements
							local element_name = target.elements[e].name
							if camp.ShipDamagedLast and camp.ShipDamagedLast[element_name] then				--ship has taken damage during last mission
								if camp.ShipHealth[element_name] == 0 then									--ship is sunk
									Briefing_text = Briefing_text .. "Intel Update: " .. element_name .. " has been sunk. \n \n"
								elseif camp.ShipHealth[element_name] < 33 then								--ship has less than 33% health
									Briefing_text = Briefing_text .. "Intel Update: " .. element_name .. " has been heavily damaged. \n \n"
								elseif camp.ShipHealth[element_name] < 66 then								--ship has less than 66% health
									Briefing_text = Briefing_text .. "Intel Update: " .. element_name .. " has been moderately damaged. \n \n"
								elseif camp.ShipHealth[element_name] < 100 then								--ship has less than 100% health
									Briefing_text = Briefing_text .. "Intel Update: " .. element_name .. " has been lightly damaged. \n \n"
								end
							end
						end
					end
				end

				if target.alive and target.targetDead_last and not target.hidden then			--ground target was hit in last mission and should not be hidden
					if target.alive == 0 then									--target is dead
						Briefing_text = Briefing_text .. "Intel Update: " .. target.titleName .. " has been destroyed. \n \n"
					else														--target is still alive
						Briefing_text = Briefing_text .. "Intel Update: " .. target.titleName .. " has been reduced to " .. target.alive .. "%. \n \n"
					end
				end
			end
		end
	end

	--change vehicle/ship group hidden status
	function Action.GroupHidden(groupname, hidden_bool)
		for sidename,side in pairs(oob_ground) do								--iterate through sides in ground OOB
			for c = 1, #side do													--iterate through countries in side
				for typename,typetable in pairs(side[c]) do						--iterate through country table content
					if typename == "vehicle" or typename == "ship" then			--for vehciles or ships
						for group_n,group in pairs(typetable.group) do			--iterate through groups
							if group.name == groupname then						--group is found
								group.hidden = hidden_bool						--change group hidden status in ground OOB
								break
							end
						end
					end
				end
			end
		end
	end

	--change vehicle/ship group probability status
	--due to the way stats are reset for a new playrun upon completing a FirstMission, groups probability changed by trigger in first mission will not be carried over to second mission! Repeat trigger on second mission or use the trigger from mission 2 on only for flawless function.
	function Action.GroupProbability(groupname, prob_val)
		for sidename,side in pairs(oob_ground) do								--iterate through sides in ground OOB
			for c = 1, #side do													--iterate through countries in side
				for typename,typetable in pairs(side[c]) do						--iterate through country table content
					if typename == "vehicle" or typename == "ship" then			--for vehciles or ships
						for group_n,group in pairs(typetable.group) do			--iterate through groups
							if group.name == groupname then						--group is found
								group.probability = prob_val					--change group probability status in ground OOB
								break
							end
						end
					end
				end
			end
		end
	end

	--move vehicle group to refpoint
	--due to the way stats are reset for a new playrun upon completing a FirstMission, groups moved by trigger in first mission will not be carried over to second mission! Repeat trigger on second mission or use the trigger from mission 2 on only for flawless function.
	function Action.GroupMove(GroupName, ZoneName)
		for coal_name,coal in pairs(oob_ground) do								--go through sides(red/blue)	
			for country_n,country in ipairs(coal) do							--go through countries
				if country.vehicle then											--country has vehicles
					for group_n,group in ipairs(country.vehicle.group) do		--go through groups
						if GroupName == group.name then							--ship group found
							local newPoint = Refpoint[ZoneName]					--x-y coordinates of new group position
							local dx = group.x - newPoint.x						--delta x
							local dy = group.y - newPoint.y						--delta y
							group.x = newPoint.x								--new group position
							group.y = newPoint.y
							group.route.points[1].x = newPoint.x
							group.route.points[1].y = newPoint.y
							for u = 1, #group.units do
								group.units[u].x = group.units[u].x - dx		--new individual unit position
								group.units[u].y = group.units[u].y - dy
							end
						end
					end
				end
			end
		end
	end

	--move vehicle group relative to another group
	--due to the way stats are reset for a new playrun upon completing a FirstMission, groups moved by trigger in first mission will not be carried over to second mission! Repeat trigger on second mission or use the trigger from mission 2 on only for flawless function.
	function Action.GroupSlave(GroupName, master, bearing, distance)
		for coal_name,coal in pairs(oob_ground) do								--go through sides(red/blue)	
			for country_n,country in ipairs(coal) do							--go through countries
				if country.vehicle then											--country has vehicles
					for group_n,group in ipairs(country.vehicle.group) do		--go through groups
						if GroupName == group.name then							--ship group found

							--find master group and get master  x-y coordinates
							for m_coal_name,m_coal in pairs(oob_ground) do									--go through sides(red/blue)	
								for m_country_n,m_country in ipairs(m_coal) do								--go through countries
									if m_country.vehicle then												--country has vehicles
										for m_group_n,m_group in ipairs(m_country.vehicle.group) do			--go through groups
											if m_group.name == master then
												local newPoint = {}
												newPoint.x = m_group.x + math.cos(math.rad(bearing)) * distance		--update slave position relative to master position
												newPoint.y = m_group.y + math.sin(math.rad(bearing)) * distance		--update slave position relative to master position
												local dx = group.x - newPoint.x								--delta x
												local dy = group.y - newPoint.y								--delta y
												group.x = newPoint.x										--new group position
												group.y = newPoint.y
												group.route.points[1].x = newPoint.x
												group.route.points[1].y = newPoint.y
												for u = 1, #group.units do
													group.units[u].x = group.units[u].x - dx				--new individual unit position
													group.units[u].y = group.units[u].y - dy
												end
												break
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

	--assign and run a movement mission to a ship group: move group along waypoints/polygons at cruise speed and optionally patrol at last polygon at patrol speed
	--GroupName is a string with the name of the ship group to get a mission
	--WPtable is a set of trigger zone names acting as waypoints for the ship to follow. WPtable is an array of multiple waypoints (example: {"ZoneName1", ZoneName2"} ).
	--Each individual waypoint can in turn consist of an array of two or more trigger zones, creating polygons where the waypont is placed within randomly (example: {{"Zone1-1", "Zone 1-2", "Zone1-3"}, {"Zone2-1", "Zone2-2", "Zone2-3"}} ).
	--The first waypoint in a WPtable can be nil to use the ship group's current position as first waypoint.
	--CruiseSpeed is the speed in m/s at which the ship group will follow the route.
	--PatrolSpeed is the speed in m/s at which the ship group will randomly patrol a polygon at the end of the route. Ships won't patrol at the end of the route if the PatrolSpeed is nil or zero or if the last waypoint is a single point only (no polygon).
	--StartTime is the campaign time in seconds (time since campaign start) at which the mission was assigned. It is used to control progress along the route across multiple missions of the campaign. If nil, then current campaign time us used automatically.
	function Action.ShipMission(GroupName, WPtable, CruiseSpeed, PatrolSpeed, StartTime)
		-- print("DcCT GroupName "..GroupName)
		-- _affiche(WPtable, "DcCT WPtable")
		for coal_name,coal in pairs(oob_ground) do								--go through sides(red/blue)	
			for country_n,country in ipairs(coal) do							--go through countries
				if country.ship then											--country has ships
					for group_n,group in ipairs(country.ship.group) do			--go through groups

						if GroupName == group.name then							--ship group found							

							local firstWPT = "test"
							if type(WPtable) == "table" then
								if WPtable[1] == ""  then
									table.remove(WPtable, 1)
									firstWPT = ""
								end

								RandomWPtable = WPtable[math.random(1, #WPtable)]

								if firstWPT == "" then
									table.insert(RandomWPtable, 1, firstWPT)
								end
							end

							camp.ShipMissions[GroupName] = {					--store ship mission in camp for subsequent executions during later missions
								WPtable = WPtable,
								CruiseSpeed = CruiseSpeed,
								PatrolSpeed = PatrolSpeed,
								-- StartTime = StartTime
							}

							-- print("DcCT GroupName "..GroupName.." ShipGroupMovement")

							-- ShipGroupMovement(GroupName, RandomWPtable, CruiseSpeed, PatrolSpeed, StartTime)	--exectue ship mission
							ShipGroupMovement(GroupName, WPtable, CruiseSpeed, PatrolSpeed, CampTotalTimeS)	--exectue ship mission
						end
					end
				end
			end
		end
	end

	function Action.RestrictedLoadout(file)
		-- restricted_loadout.miz

		-- local missionFromBaseMission = mission  -- Sauvegarde la mission principale

		local PayloadRestricted = {}

		local restrictedPath = "Loadouts/" .. file
		local testPath = io.open(restrictedPath, "r")

		if testPath ~= nil then
			io.close(testPath)

			local zipFileResticted = minizip.unzOpen(restrictedPath, 'rb')

			zipFileResticted:unzLocateFile('mission')
			local misRestricted = zipFileResticted:unzReadAllCurrentFile()

			-- Création d'un environnement vide pour éviter d'écraser `mission`
			local env = {}
			local func = loadstring(misRestricted)
			if func then
				setfenv(func, env) -- Exécute dans un environnement isolé
				func()
			end

			-- La mission extraite est maintenant stockée dans env.mission
			if env.mission then
				for _side, side in pairs(env.mission.coalition) do
					for countryN, country in pairs(side.country) do
						for category, groups in pairs(country) do
							if type(groups) == "table" and groups["group"] then
								for Ngroup, group in pairs(groups["group"]) do
									for Nunit, unit in pairs(group.units) do
										if unit.payload and unit.payload.restricted then
											PayloadRestricted[unit.type] = unit.payload.restricted
										end
									end
								end
							end
						end
					end
				end
			end

			-- La mission principale reste inchangée, inutile de la restaurer
			-- mission = missionFromBaseMission  <-- Plus besoin !

			-- Sérialisation des restrictions et sauvegarde dans un fichier
			local data_str = "PayloadRestricted = " .. TableSerialization(PayloadRestricted, 0)
			local dataFile = io.open("Active/PayloadRestricted.lua", "w") or error("Failed to open debug file")
			dataFile:write(data_str)
			dataFile:close()

		end

	end


	--Miguel21 modification M40
	--TemplateActive
	function Action.TemplateActive(TabFile)
		if debugKT then print("	--> function Action.TemplateActive "..tostring( TabFile)) end

		local file

		--cherche la valeur UnitID la plus haute
		local CurrentUnitId = 0
		local CurrentGroupId = 0
		for Oside_name, Oside in pairs(oob_ground) do																--iterate through sides
			for Ocountry_n, Ocountry in pairs(Oside) do															--iterate through countries				
				for Ocategory, Ogroup in pairs(Ocountry) do
					if  type(Ogroup) == "table" then
						for Ngroup, O_group in pairs(Ogroup) do
							for g = 1, #O_group do
								if O_group[g].groupId > CurrentGroupId then
									CurrentGroupId = O_group[g].groupId
								end
								for u = 1, #O_group[g].units do											--iterate through units								
									if O_group[g].units[u].unitId > CurrentUnitId then
										CurrentUnitId = O_group[g].units[u].unitId
									end
								end
							end
						end
					end
				end
			end
		end

		-- print("DcCT AA CurrentGroupId: "..CurrentGroupId.." CurrentUnitId: "..CurrentUnitId)

		for side_name, side in pairs(mission.coalition) do																--iterate through sides
			for country_n, country_ in pairs(side.country) do															--iterate through countries
				for categorie, categorie_ in pairs(country_) do
					if type(categorie_) == "table" and categorie_.group then
						for _group, group in pairs(categorie_) do
							for groupN, group_ in pairs(group) do
								if group_.groupId > CurrentUnitId then
									CurrentUnitId = group_.groupId
								end
								for unitN, unit in ipairs(group_.units) do
									if unit.unitId > CurrentUnitId then
										CurrentUnitId = unit.unitId
									end
								end
							end
						end
					end
				end
			end
		end
		-- print("DcCT BB CurrentGroupId: "..CurrentGroupId.." CurrentUnitId: "..CurrentUnitId)

		-- local function FindUnit(Group_name, category)
		local function FindUnit(groupName, sideName, countryId, category)
			for O_sideName, O_countries in pairs(oob_ground) do																--iterate through sides
				if O_sideName == sideName  then
					for O_country_n, O_country in pairs(O_countries) do															--iterate through countries
						if O_country.id == countryId and O_country[category] and O_country[category].group then																			--country has vehicles
							for g = 1, #O_country[category].group do
								if O_country[category].group[g].name  == groupName then
									return true
								end
							end
						end
					end
				end
			end
		end

		local function movedXY(Unit, Category)
			local foundInGround = false
			for Oside_name, Oside in pairs(oob_ground) do																--iterate through sides
				for Ocountry_n, Ocountry in pairs(Oside) do															--iterate through countries
					if Ocountry[Category] then																			--country has vehicles
						for g = 1, #Ocountry[Category].group do
							for u = 1, #Ocountry[Category].group[g].units do											--iterate through units								
								if Ocountry[Category].group[g].units[u].name == Unit.name then

									if not Ocountry[Category].group[g].units[u].dead then
										-- print("DcCt update movedXY "..Unit.name.." "..Ocountry[Category].group[g].units[u].heading)
										Ocountry[Category].group[g].units[u].x = Unit.x
										Ocountry[Category].group[g].units[u].y = Unit.y
										Ocountry[Category].group[g].units[u].heading = Unit.heading

										if u == 1 then
											Ocountry[Category].group[g].heading = Unit.heading				--M40.e
											Ocountry[Category].group[g].x = Unit.x							--M40.e
											Ocountry[Category].group[g].y = Unit.y							--M40.e
											foundInGround = true
											-- print("[1]DcCt update movedXY "..Unit.name.." "..Ocountry[Category].group[g].units[u].heading)
										end
									end
								end
							end
						end
					end
				end
			end
		end

		function SetRouteXY(Groupname, Category, Route )
			local foundInGround = false
			for Oside_name, Oside in pairs(oob_ground) do																--iterate through sides
				for Ocountry_n, Ocountry in pairs(Oside) do															--iterate through countries
					if Ocountry[Category] then																			--country has vehicles
						for g = 1, #Ocountry[Category].group do
							if Ocountry[Category].group[g].name == Groupname then
								Ocountry[Category].group[g].route = Route
							end
						end
					end
				end
			end
		end


		-- cree une table identifiant des noms de pays
		local countryNameToN = {
			red = {},
			blue = {},
			neutrals = {},
		}
		for sideName, side in pairs(oob_ground) do
			for countryN, country in pairs(side) do
				if country.name then
					if not countryNameToN[sideName] then countryNameToN[sideName] = {} end
					if countryNameToN[sideName][country.name] == nil then
						countryNameToN[sideName][country.name] = countryN
					end
				end
			end
		end

		if type(TabFile) == "table" then
			file =  TabFile[math.random(1, #TabFile)]
		else
			file = TabFile
		end

		dofile("Templates/"..file)

		--ajoute le tag ["taskSelected"] = true,

		for side_name, side in pairs(staticTemplate.coalition) do
			for country_n, country in pairs(side.country) do
				for category_n, category in pairs(country) do

					if type(category) == "table" and category.group then

						for group_n, group in pairs(category.group) do

							group.taskSelected = true
							-- print("DcST "..group.name.." group.taskSelected = true")
							-- os.execute 'pause'
						end
					end
				end
			end
		end


		local tmp_ground = {}
		tmp_ground["blue"] = Deepcopy(staticTemplate.coalition.blue.country)											--copy mission data
		tmp_ground["red"] = Deepcopy(staticTemplate.coalition.red.country)												--copy mission data

		-- tmp_dictionary = Deepcopy(staticTemplate.localization.DEFAULT)

		--store group and unit names in oob_ground instead of pointers to dict table
		for sideName, countries in pairs(tmp_ground) do
			for countryN, country in pairs(countries) do
				for category, class in pairs(country) do
					if type(class) =="table" and class.group then
						for g = 1, #class.group do
							local groupname = class.group[g].name

							--TODO attention, un nom identique existe peut etre dans les autres SIDE
							local found = FindUnit(groupname, sideName, country.id, category)
							class.group[g].name = groupname

							if found then
								SetRouteXY(groupname, category, class.group[g].route )
							end

							for u = 1, #class.group[g].units do
								local unitname = class.group[g].units[u].name
								class.group[g].units[u].name = unitname
								if found then
									movedXY(class.group[g].units[u], category )
								else
									CurrentUnitId = CurrentUnitId + 1
									class.group[g].units[u].unitId = CurrentUnitId
									-- print("DcCT  vehicle CurrentUnitId: "..CurrentUnitId.." name: "..class.group[g].units[u].name)
								end
							end

							-- print("DcCT B found? "..tostring(found))

							if not found then
								CurrentGroupId = CurrentGroupId + 1													--actualise un groupId unique, evite les plantages
								class.group[g].groupId = CurrentGroupId
								local newCountryN = countryNameToN[sideName][country.name]

								if not countryNameToN[sideName][country.name] then

									-- countryNameToN[sideName][country.name] = #countryNameToN + 1
									local idMax = 1
									for key, value in pairs(countryNameToN[sideName]) do
										if idMax < value then
											idMax = value
										end
									end

									countryNameToN[sideName][country.name] = idMax + 1
									newCountryN = countryNameToN[sideName][country.name]

									oob_ground[sideName][newCountryN] = {
										["name"] = country.name,
										["id"] = country.id,
										[category] = {
											["group"] = {},
										}
									}

								else
									if not oob_ground[sideName][newCountryN][category] then
										oob_ground[sideName][newCountryN][category] = {
											["group"] = {},
										}
									end

								end

								table.insert(oob_ground[sideName][newCountryN][category]["group"], class.group[g])
								-- print("DcCT D category "..tostring(category).." g.name "..tostring(class.group[g].name))
							end
						end
					end
				end
				-- if country.ship then																			--country has ships
				-- 	for g = 1, #country.ship.group do															--iterate through ship groups	
				-- 		local groupname = country.ship.group[g].name								--find groupname in dictionary table			
				-- 		local found = FindUnit(groupname, "ship")
				-- 		country.ship.group[g].name = groupname												--give group the actual groupname instead of the pointer to the dictionary table						

				-- 		if found then
				-- 			SetRouteXY(groupname, "ship", country.ship.group[g].route )
				-- 		end

				-- 		for u = 1, #country.ship.group[g].units do											--iterate through units
				-- 			local unitname = country.ship.group[g].units[u].name					--find unitname in dictionary table
				-- 			country.ship.group[g].units[u].name = unitname									--give unit the actual unitname instead of the pointer to the dictionary table							
				-- 			if found then
				-- 				movedXY(country.ship.group[g].units[u], "ship" )
				-- 			else
				-- 				CurrentUnitId = CurrentUnitId + 1
				-- 				country.ship.group[g].units[u].unitId = CurrentUnitId
				-- 				-- print("DcCT  ship CurrentUnitId: "..CurrentUnitId.." name: "..country.vehicle.group[g].units[u].name)
				-- 			end
				-- 		end							

				-- 		if not found then
				-- 			CurrentGroupId = CurrentGroupId + 1													--actualise un groupId unique, evite les plantages
				-- 			country.ship.group[g].groupId = CurrentGroupId
				-- 			if not oob_ground[side_name][countryNameToN[country.name]]["ship"] then
				-- 				oob_ground[side_name][countryNameToN[country.name]]["ship"] = {
				-- 					["group"] = {},
				-- 				}
				-- 			end						
				-- 			table.insert(oob_ground[side_name][countryNameToN[country.name]]["ship"]["group"], country.ship.group[g])							
				-- 		end
				-- 	end
				-- end
				-- if country.static then																			--country has static objects
				-- 	for g = 1, #country.static.group do															--iterate through static groups	
				-- 		local groupname = country.static.group[g].name											--find groupname in dictionary table			
				-- 		local found = FindUnit(groupname, "static")

				-- 		for u = 1, #country.static.group[g].units do											--iterate through units
				-- 			-- local unitname = country.static.group[g].units[u].name								--find unitname in dictionary table
				-- 			-- country.static.group[g].units[u].name = unitname									--give unit the actual unitname instead of the pointer to the dictionary table							
				-- 			if found then
				-- 				movedXY(country.static.group[g].units[u], "static" )
				-- 			else
				-- 				CurrentUnitId = CurrentUnitId + 1
				-- 				country.static.group[g].units[u].unitId = CurrentUnitId
				-- 				-- print("DcCT  static CurrentUnitId: "..CurrentUnitId.." name: "..country.vehicle.group[g].units[u].name)
				-- 			end
				-- 		end							

				-- 		if not found then														
				-- 			CurrentGroupId = CurrentGroupId + 1													--actualise un groupId unique, evite les plantages
				-- 			country.static.group[g].groupId = CurrentGroupId						
				-- 			if not oob_ground[side_name][countryNameToN[country.name]]["static"] then
				-- 				oob_ground[side_name][countryNameToN[country.name]]["static"] = {
				-- 					["group"] = {},
				-- 				}
				-- 			end	
				-- 			table.insert(oob_ground[side_name][countryNameToN[country.name]]["static"]["group"],	country.static.group[g])												
				-- 		end
				-- 	end
				-- end
			end
		end
	end


	function Action.TemplateDeactivate(TabFile)

		if debugKT then print("	--> function Action.TemplateDeactivate "..tostring( TabFile)) end

		-- local function FindUnit(Group_name, category)
		-- 	for Oside_name, Oside in pairs(oob_ground) do																--iterate through sides
		-- 		for Ocountry_n, Ocountry in pairs(Oside) do															--iterate through countries
		-- 			if Ocountry[category] then																			--country has vehicles
		-- 				for g = 1, #Ocountry[category].group do							
		-- 					if Ocountry[category].group[g].name  == Group_name then
		-- 						return true
		-- 					end
		-- 				end
		-- 			end
		-- 		end
		-- 	end			
		-- end

		-- local countryNameToN = {}
		-- for side_name, side in pairs(oob_ground) do																--iterate through sides
		-- 	for country_n, country in pairs(side) do															--iterate through countries
		-- 		if country.name then
		-- 			if not countryNameToN[country.name] then countryNameToN[country.name] = country_n end

		-- 		end
		-- 	end
		-- end

		local file

		if type(TabFile) == "table" then
			file =  TabFile[math.random(1, #TabFile)]
		else
			file = TabFile
		end

		dofile("Templates/"..file)
		local tmp_ground = {}
		tmp_ground["blue"] = Deepcopy(staticTemplate.coalition.blue.country)											--copy mission data
		tmp_ground["red"] = Deepcopy(staticTemplate.coalition.red.country)												--copy mission data

		-- tmp_dictionary = Deepcopy(staticTemplate.localization.DEFAULT)

		--store group and unit names in oob_ground instead of pointers to dict table
		for sideName, countries in pairs(tmp_ground) do
			for countryN, country in pairs(countries) do
				for category, class in pairs(country) do
					if type(class) == "table" and class.group then
						for g = 1, #class.group do
							-- local groupnName = class.group[g].name		
							local tmpGroupName = class.group[g].name								--find groupname in dictionary table		

							-- local idDecativate = 0
							-- local groupDeactivate = {}

							for O_sideName, O_countries in pairs(oob_ground) do																--iterate through sides
								for O_countryN, O_country in pairs(O_countries) do															--iterate through countries
									if O_country[category] then																			--country has vehicles
										for o_g = #O_country[category].group, 1, -1  do
											if sideName == O_sideName and country.id == O_country.id and O_country[category].group[o_g].name  == tmpGroupName then
												-- idDecativate = o_g
												-- groupDeactivate = O_country[category].group

												table.remove(O_country[category].group, o_g)

											end
										end
									end
								end
							end

							-- if idDecativate ~= 0 then						
							-- 	table.remove(groupDeactivate, idDecativate)
							-- end		
						end
					end
				end
				-- if country.ship then																			--country has ships
				-- 	for tg = 1, #country.ship.group do															--iterate through ship groups	
				-- 		local tmpGroupName = country.ship.group[tg].name								--find groupname in dictionary table			

				-- 		local idDecativate = 0
				-- 		local groupDeactivate = {}
				-- 		local category = "ship"
				-- 		for Oside_name, Oside in pairs(oob_ground) do																--iterate through sides
				-- 			for Ocountry_n, Ocountry in pairs(Oside) do															--iterate through countries
				-- 				if Ocountry[category] then																			--country has vehicles
				-- 					for og = 1, #Ocountry[category].group do
				-- 						if Ocountry[category].group[og].name  == tmpGroupName then
				-- 							idDecativate = og
				-- 							groupDeactivate = Ocountry[category].group
				-- 						end
				-- 					end
				-- 				end
				-- 			end
				-- 		end	

				-- 		if idDecativate ~= 0 then					
				-- 			table.remove(groupDeactivate, idDecativate)
				-- 		end	
				-- 	end
				-- end
				-- if country.static then																			--country has static objects
				-- 	for tg = 1, #country.static.group do															--iterate through static groups	
				-- 		local tmpGroupName = country.static.group[tg].name											--find groupname in dictionary table			

				-- 		local idDecativate = 0
				-- 		local groupDeactivate = {}
				-- 		local category = "static"
				-- 		for Oside_name, Oside in pairs(oob_ground) do																--iterate through sides
				-- 			for Ocountry_n, Ocountry in pairs(Oside) do															--iterate through countries
				-- 				if Ocountry[category] then																			--country has vehicles
				-- 					for og = 1, #Ocountry[category].group do							
				-- 						if Ocountry[category].group[og].name  == tmpGroupName then
				-- 							idDecativate = og
				-- 							groupDeactivate = Ocountry[category].group
				-- 						end
				-- 					end
				-- 				end
				-- 			end
				-- 		end	

				-- 		if idDecativate ~= 0 then						
				-- 			table.remove(groupDeactivate, idDecativate)
				-- 		end												
				-- 	end
				-- end
			end
		end
	end

	if not AirLiftObjectif then
		AirLiftObjectif = {}
	end

	--return alive percentage of target
	function Action.LogisticObjectif(placeName, weightObjectif)
		for db_baseName, base_ in pairs(db_airbases) do								--iterate through sides in oob_air		
			if db_baseName == placeName  then										--unit found
				local liftText
				if base_.logistic then
					local result = math.ceil(base_.logistic / weightObjectif * 100)
					liftText = "The objective of the "..placeName.." airlift is "..result.."% of the "..weightObjectif.." Kg"
					AirLiftObjectif[placeName.."_"..weightObjectif] = liftText
				else
					liftText = "The objective of the "..placeName.." airlift is 0% of the "..weightObjectif.." Kg"
					AirLiftObjectif[placeName.."_"..weightObjectif] = liftText
				end
			end
		end
	end
----- run campaign triggers -----

--define variables to persist across multiple mission generation attempts
if Briefing_status == nil then													--if briefing status string does not exist yet it must be created
	Briefing_status = ""														--text string to be added to briefing
	Briefing_oob_text_red = ""													--text string to be added to next briefing (red repair and reinforcements)
	Briefing_oob_text_blue = ""													--text string to be added to next briefing (blue repair and reinforcements)
end

if not BriefingImagesB then
	BriefingImagesB = { }															--global table to hold information about briefing images to be added to miz mission file
end

if not BriefingImagesR then
BriefingImagesR = { }                             --global table to hold information about briefing images to be added to miz mission file
end

if camp.Briefing_text and camp.Briefing_text ~= "" then
	Briefing_text = camp.Briefing_text																--briefing text to be added this mission instance
else

	Briefing_text = ""

	-- print("DcCT reset Briefing_text 2")
	-- os.execute 'pause'
end

Briefing_text_playable = ""														--briefing text to be added only if this mission instance results in a playable mission

--go through campaign triggers
for trigger_name,trigger in pairs(camp_triggers) do								--iterate through triggers

	if debugKT then print("DcCT passe 00 trigger_name: "..tostring(trigger_name)) end

		if trigger.active then														--trigger is active

			if debugKT then print("DcCT passe 01 if trigger.active: trigger.condition: "..tostring(trigger.condition)) end

			local conditionStr = trigger.condition
			-- Remplace campMod.RepairMinimumDestroyed par une valeur numérique (exemple : 20)
			conditionStr = string.gsub(conditionStr, "campMod.RepairMinimumDestroyed", "20")


			local condition = loadstring("if " .. conditionStr .." then return true end")	--make a function from the string condition
			if type(condition) == "function" and condition() then														--if the trigger condition is true

			if debugKT then print(" -> :DcCT passe 02 passe  condition()trigger_name: "..tostring(trigger_name)) end

				if type(trigger.action) == "table" then								--multiple actions
					for i,action in ipairs(trigger.action) do
						if debugKT then print(" 	---> : "..tostring(trigger.action[i])) end
						local f = loadstring(action)()								--run the trigger action
					end
				else																--single action
					if debugKT then print(" 	---> : "..tostring(trigger.action)) end
					local f = loadstring(trigger.action)()							--run the trigger action
				end
				if trigger.once then												--trigger should only fire once
					trigger.active = false											--set trigger inactive
				end

			end
		end
	end


-- if debugKT then print("camp.automaticReinforce "..tostring(CampTotalTimeS).." >=? "..tostring(camp.automaticReinforce).." + "..tostring(campMod.airReinforceDelay).." *3600?".." cad: "..(camp.automaticReinforce + (campMod.airReinforceDelay * 3600))) end


--**********************************************************************************
--recompletement automatique des unités AIR
--**********************************************************************************
-- if CampTotalTimeS >= camp.automaticReinforce + campMod.airReinforceDelay * 3600 then

-- _affiche(camp.automaticReinforce, "camp.automaticReinforce")

for side_name, side in pairs(oob_air) do
	-- print("DcCT side_name "..tostring(side_name))
	-- print("DcCT camp.automaticReinforce "..tostring(camp.automaticReinforce[side_name]))
	if side_name ~= "neutral" and CampTotalTimeS >= camp.automaticReinforce[side_name] + campMod.RepairOption[side_name]["airUnit"][3] * 3600 then
		for unit_n, unit in pairs(side) do
			if unit.roster.reserve and unit.roster.reserve > 0 then -- not unit.inactive and 
				Action.AirUnitReinforce(unit.name, "")
				if debugKT then print("DcCT automaticReinforce "..tostring(unit.name)) end
			end
		end
		camp.automaticReinforce[side_name] = CampTotalTimeS
	end
end


-- --**********************************************************************************
-- --active/desactive une base et ses unites/target si le runway < 50% et si base <20% est detruit
-- --**********************************************************************************

--draft2
-- BaseAlive < 20 ou à "RepairBaseMinimumDestroyed" : base HS DEFINITIVEMENT (Base Inactive, Plane Off, Heli Off)
-- Runway < 20 ou à "RepairBaseMinimumDestroyed" : piste HS DEFINITIVEMENT, (Base Active, Plane Off, Heli On)
-- Runway >= 20 et <= 50 : la piste est HS pour les avions mais reste REPARABLE, (Base Active, Plane Off, Heli On)
-- Runway > 50 la piste est PRATICABLE, REPARATION en cours , (Base Active, Plane On, Heli On)


	-- Destruction d'une base : 
	-- BaseAlive < 20 ou à "minimumRepairThreshold" : base HS DEFINITIVEMENT (Base Inactive, Plane Off, Heli Off)
	-- XXXX airbase is destroyed and will not be able to support air units anymore.

	-- Destruction d'une piste : 
	-- Runway < 20 ou à "deathPoint" : piste HS DEFINITIVEMENT, (Base Active, Plane Off, Heli On)
	-- XXXX runway is completely destroyed and the base is not able to support planes  anymore ...

	-- Endommagement d'une piste :
	--  Runway >= 20 et <= 50 (ou runwayOk): la piste est HS pour les avions mais reste REPARABLE, (Base Active, Plane Off, Heli On)
	-- XXXX runway is badly damaged and it will require major repairs before it can be used again

	-- Réparation d'une piste :
	-- Runway > 50 (ou runwayOk)la piste est PRATICABLE, REPARATION en cours , (Base Active, Plane On, Heli On)
	-- XXXX runway is repaired and can be used again.


--recupere les valeurs dans targetlist, interressant les bases pour les coller à la table db_airbases
for side_name, targets in pairs(targetlist) do													--Iterate through all side
	for targetN, target in pairs(targets) do												--Iterat through all targets

		if target.db_airbaseName and db_airbases[target.db_airbaseName] then
			if target.task ~= "Runway Attack"  then

				--creation de db_airbases[target.db_airbaseName].baseAlive
				Return.BaseAlive(target.db_airbaseName)

			elseif target.task == "Runway Attack" and target.alive then
				db_airbases[target.db_airbaseName].runwayAlive = target.alive

			end
		end
	end
end

for baseName, base in pairs(db_airbases) do

	if not string.find(string.lower(baseName), "reserve")  then
		if not base.baseAlive then
			Return.BaseAlive(baseName)
		end

		if not base.runwayAlive and not base.BaseAirStart then
			base.runwayAlive = 100
		end
	end

	--base détruite

	if base.side then

		local baseDeathPoint = campMod.RepairOption[base.side]["airbase"][1]
		local runwayDeathPoint = campMod.RepairOption[base.side]["runway"][2]
		local runwayOk = campMod.RepairOption[base.side]["runway"][6]

		-- print("base.side: "..tostring(base.side))
		-- print("runwayOk: "..tostring(runwayOk))

		-- _affiche(campMod.RepairOption, "campMod.RepairOption")

		-- if base.baseAlive and base.baseAlive < campMod.RepairBaseMinimumDestroyed and not base.inactive   then
		if base.baseAlive and base.baseAlive < campMod.RepairOption[base.side]["airbase"][1] and not base.inactive then
			if debugKT then print(baseName.." 	airbase < 20 || airbase is destroyed and will not be able to support air units anymore. ") end

			Action.ActivateBaseAndItsUnits(baseName, false )
			Action.Text(baseName.." airbase is destroyed and will not be able to support air units anymore.")

		elseif base.runwayAlive then
			--runway gravement endommagé, irréparable
			-- if base.runwayAlive < campMod.RepairBaseMinimumDestroyed then
			if base.runwayAlive < runwayDeathPoint then
				if debugKT then print(baseName.." .runwayAlive < 20 || runway is completely destroyed and the base is not able to support planes  anymore.") end

				Action.ActivateBaseAndItsUnits(baseName, true )

				-- if base.runwayTxt == nil or base.runwayTxt ~= "<"..campMod.RepairBaseMinimumDestroyed then
				-- 	base.runwayTxt = "<"..campMod.RepairBaseMinimumDestroyed
				-- 	Action.Text(baseName.." runway is completely destroyed and the base is not able to support planes anymore.")
				-- end

				if base.runwayTxt == nil or base.runwayTxt ~= "<"..runwayDeathPoint then
					base.runwayTxt = "<"..runwayDeathPoint
					Action.Text(baseName.." runway is completely destroyed and the base is not able to support planes anymore.")
				end

				--runway endommagé mais base encore active (les avions ne peuvent plus décoller, les helico si)
			-- elseif  base.runwayAlive < 50 then
			elseif  base.runwayAlive < runwayOk then
				if debugKT then print(baseName.." .runwayAlive < 50 || runway is badly damaged and it will require major repairs before it can be used again.") end

				Action.ActivateBaseAndItsUnits(baseName, true )

				if base.runwayTxt == nil or base.runwayTxt ~= "<50" then
					base.runwayTxt = "<50"
					Action.Text(baseName.." runway is badly damaged and it will require major repairs before it can be used again.")
				end

				--réparation du runway
			elseif  base.runwayAlive >= runwayOk then
				if debugKT then print(baseName.." .runwayAlive >= 50 || runway is repaired and can be used again..") end

				Action.ActivateBaseAndItsUnits(baseName, true )

				-- if  base.runwayTxt == "<50" or base.runwayTxt == "<"..campMod.RepairBaseMinimumDestroyed then
				if  base.runwayTxt == "<50" or base.runwayTxt == "<"..runwayDeathPoint then
					base.runwayTxt = ">=50"
					Action.Text(baseName.." runway is repaired and can be used again.")
				end
			end
		end

		local testBaseAlive = Return.BaseAlive(baseName)
		if testBaseAlive then
			if testBaseAlive <= baseDeathPoint and not base.inactive then
				if debugKT then print(" 	airbase < RepairBaseMinimumDestroyed  active: FALSE "..baseName) end

				Action.ActivateBaseAndItsUnits(baseName, false)
				Action.Text(baseName.." airbase is destroyed and will not be able to support air units.")
			end
		end
	end
end


if debugKT then
	_affiche(camp.flag, "Marqueur ou  CampFlag")
end

if camp.endCampaign  then

	print()
	print("******************** ATTENTION ****************** "..tostring(camp.endCampaign))
	print("******************** ATTENTION ****************** "..tostring(camp.endCampaign))
	print()
	print("*************** Attention, take into account that the campaign is over, press to see the rest..****************")
	print(tostring(camp.endCampaign))
	print()
	print("******************** ATTENTION ****************** "..tostring(camp.endCampaign))
	print("******************** ATTENTION ****************** "..tostring(camp.endCampaign))
	print()

	local briefClean = Briefing_text:gsub("\n", "\n")
	print(" 	Briefing_text---> : ".."\n"..tostring(briefClean))
	print()
	print("******************** ATTENTION ******************")
	print("******************** ATTENTION ******************")

	print()

	local foundPlayer = false
	if not camp.playerSide then
		for side, units in pairs(oob_air)do
			for unitN, unit in pairs(units)do
				if unit.player then
					camp.playerSide = side
					break
				end
			end
			if foundPlayer then break end
		end
	end

	if camp.playerSide == "blue" then
		for imageN, image in pairs(BriefingImagesB) do
			os.execute('start "end_Campaign" "mspaint.exe" "Images\\' .. image .. '"')

			-- os.execute('start "end_Campaign" "ms-photos.exe" "Images\\' .. image .. '"')
		end
	elseif camp.playerSide == "red" then
		for imageN, image in pairs(BriefingImagesR) do
			os.execute('start "end_Campaign" "mspaint.exe" "Images\\' .. image .. '"')

			-- os.execute('start "end_Campaign" "ms-photos.exe" "Images\\' .. image .. '"')
		end
	end


		-- if side == "blue"  then
		-- 	table.insert(BriefingImagesB, filename)									--add filename to briefing images table, will be added to mission file when this gets created
		-- elseif side == "red"  then
		-- 	table.insert(BriefingImagesR, filename)
		-- elseif side == "all" or side == "" or side == nil then
		-- 	table.insert(BriefingImagesB, filename)
		-- 	table.insert(BriefingImagesR, filename)
		-- end	



	os.execute 'pause'
end

-- local trigStr = "camp_triggers = " .. TableSerialization(camp_triggers, 0)
-- local trigFile = io.open("Debug/camp_triggers.lua", "w")
-- trigFile:write(trigStr)
-- trigFile:close()
