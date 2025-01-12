--To update the targetlist (target position, alive precentage)
--Initiated by MAIN_NextMission.lua
------------------------------------------------------------------------------------------------------- 
-- last modification: cleancode_d debug_d
if not versionDCE then versionDCE = {} end
versionDCE["DC_UpdateTargetlist.lua"] = "1.11.49"
------------------------------------------------------------------------------------------------------- 
-- cleancode_d				(d springCleaning)
-- adjustment_a				(a GroundTarget.percent = 100 & Error_05 )
-- debug_d					(d updateAlive)(bc InsertBugList)(a -nan(ind))
-- modification M78_a		LatLon positions added and unit display removed on MAP F10 (camp.targetPos)
-- modification M74_a		mix static, vehicle and map elements in a Target.
-- modification M70_a		GroundZoneTarget (adds the possibility of counting unit completeness by zone) 
-- modification M66_e		bombOnRunway (e dead_last)(c runway.true_hdg)
-- modification M61_b		SAR (b: debug xy position moyenne)
-- modification M38_w		Check and Help CampaignMaker (w check error template too long)(g: only firstmission)(f: find in template file)(b: add debug info)
-- modification M26_a		destroys targets if below a certain value
-- modification M19_e		Repair GROUND
-------------------------------------------------------------------------------------------------------

if not targetlist.blue[1] then
	TargetlistToNum()
end

if not DC_UpdateTargetlist_counter then
	DC_UpdateTargetlist_counter = 1
else
	DC_UpdateTargetlist_counter = DC_UpdateTargetlist_counter + 1
end

local tabTemplates = {}

ListRequiredModules = {}

GroundTarget = {																				--count total and alive ground targets for each side
	["red"] = {
		total = 0,
		alive = 0,
		percent = 100,
	},
	["blue"] = {
		total = 0,
		alive = 0,
		percent = 100,
	},
}

GroundZoneTarget = {																				--count total and alive ground targets for each side
	["red"] = {},
	["blue"] = {},
}

-- modification M38 : Debug Name of TargetList 
local function checkBug(name, origine, category)

	if name == nil then
		print("DC_UT checkBug "..origine.." "..category..", ATTENTION: Name is empty: "..tostring(name))
	end

	if Debug.checkTargetName2Space then
		local i, j = string.find(name, "  ")
		if i then
			print("DC_UT checkBug "..origine.." "..category..", ATTENTION: Name whith Double Space: "..name)
		end
	end

	if Debug.checkTargetName then
		if string.sub(name, -1) == " " then print("DC_UT "..origine.." "..category..", ATTENTION: Name ending with a space|"..name.."|") end
		if string.sub(name, 1,1) == " " then print("DC_UT "..origine.." "..category..", ATTENTION: Name beginning with a space|"..name.."|") end
	end
end

local function checkBug2(txt)
	-- if Debug.AfficheSol and Firstmission_flag then
	if Debug.AfficheSol then
		print("DC_UT checkBug2 "..txt)
	end
end

local function checkBug3(txt)
	if Debug.checkTargetName  and DC_UpdateTargetlist_counter > 1 then
		-- table.insert(BugList, "DC_UT checkBug3 "..txt)
		InsertBugList("DC_UT checkBug3 :"..txt)
	end
end

local function checkElementXY(targetElement, targetside)
	--pour eviter les doubles target comme base strategique
	--recherche position xy dans oob_ground
	-- print("DcUT             MA"..tostring(targetElement.name))	

	local foundElement = false

	if targetElement.name then
		for country_n, country in pairs(oob_ground[targetside]) do
			for classname, class in pairs(country) do
				if type(class) =="table" and class.group then
					for group_n, group in pairs(class.group) do
						if group.name == targetElement.name then
							-- print("DcUT               MB return Found group.name")						
							return group.x, group.y, classname
						end
					end
				end
			end
		end
		if not foundElement then
			for country_n, country in pairs(oob_ground[targetside]) do

				for classname, class in pairs(country) do
					if type(class) =="table" and class.group then
						for group_n, group in pairs(class.group) do
							for unitN, unit in ipairs(group.units) do
								if unit.name == targetElement.name then
									-- print("DcUT               MC return Found group.name")	
									return unit.x, unit.y, classname
								end
							end
						end
					end
				end
			end
		end
	end

	-- if not foundElement then
	-- 	checkBug3("Error_3 : The x and y positions of this target are missing:  '" .. targetElement.name .. "!")

	-- end

end

local function updateAlive(target)
	local nbDead = 0
	local nbdead_last = 0
	local nbMainObjective = 0
	target.alive = 100
	target.dead_last = 0

	--si l'element comporte des nbMainObjective
	for _elementN, element in pairs(target.elements) do
		if element.mainObjective then
			nbMainObjective = nbMainObjective + 1
		end
		if element.dead and element.mainObjective then
			nbDead = nbDead + 1
		end
	end
	if nbDead > 0 then
		target.alive = 100 - (nbDead/ nbMainObjective)*100
	end


	for _elementN, element in pairs(target.elements) do
		if element.dead_last and element.mainObjective then
			nbdead_last = nbdead_last + 1
		end
	end
	if nbdead_last > 0 then
		target.dead_last =  (nbdead_last/ nbMainObjective)*100
	end

	if nbMainObjective == 0 then
		for _elementN, element in pairs(target.elements) do
			if element.dead then
				target.alive = target.alive - 100 / #target.elements
			end
		end

		for _elementN, element in pairs(target.elements) do
			if element.dead_last then
				target.dead_last = target.dead_last + 100 / #target.elements
			end
		end
	end

	if nbdead_last > 100 then nbdead_last = 100 end

	return target
end


-- -- Lua implementation of PHP scandir function
-- require "lfs"
-- function scandir(directory)
	-- local i, t, popen = 0, {}, io.popen
	-- local pfile = popen('ls -a "'..directory..'"')
	-- for filename in pfile:lines() do
		-- i = i + 1
		-- t[i] = filename
	-- end
	-- pfile:close()
	-- return t
-- end

-- tabTemplates = scandir("../Templates/")

	-- ["North Cyprus Force 2 move 1"] = {
		-- active = true,
		-- once = true,
		-- condition = 'Return.Mission() < 2 and Return.TargetAlive("North Cyprus Force 2") > 7',
		-- action = {
		-- [1] = 'Action.TemplateActive("North Cyprus Force 2 T1.stm")',
		-- [2] = 'Action.TargetActive("North Cyprus Force 2", true)',		
		-- [3] = 'Action.Text("North Cyprus columns crossed the No man s land and are coming from the north of Nicosia")',
		-- },
	-- },

-- camp_triggers = {
 -- action[i]Action.TemplateActive

 -- }


local function TabFileTemplate()
	local ArrayFileTemplate = {}
	if camp_triggers == nil then
		local ArrayFileTemplate
		return ArrayFileTemplate
	end

	local ArrayFileTemplate = {}
	local camp_triggersTemPlaTe =  camp_triggers

	for nTrigger, trigger in pairs(camp_triggersTemPlaTe) do
		if type(trigger.action) == "table" then
			for n = 1, #trigger.action do
				-- [1] = 'Action.TemplateActive("North Cyprus Force 2 T1.stm")',

				if trigger.action[n] then
					if string.find(trigger.action[n], ".stm") then

						local str2 = trigger.action[n]
						local res2 = string.match(str2, '%b""')
						res2 = string.gsub(res2, '"', "")

						table.insert(ArrayFileTemplate, res2)
					end
				else
					print()
					print("********************ATTENTION******************")
					print("***************Note for the Campaign Maker***** the key: "..n.." is missing in the file camp_triggers_init.lua ****************")
					print("********************ATTENTION******************")
					print()
					print("after this ligne: ")
					print()
					print(tostring(trigger.action[n-1]))
					os.execute 'pause'
				end
			end
		end
	end
	return ArrayFileTemplate
end


local function findInTemplates(name, side, classT, debugDCUT)
	if not (Debug.checkTargetName and (Firstmission_flag or Skipmission_flag)) then return true end

	if  type(tabTemplates) == "table" then		--Debug.checkTargetName2Space  and 
		for i = 1 , #tabTemplates do
			dofile("Templates/"..tabTemplates[i])

			local DictKey = {}
			if staticTemplate.localization and staticTemplate.localization.DEFAULT then
				for dictNameId, key in pairs(staticTemplate.localization.DEFAULT) do
					DictKey[dictNameId] = key
				end

			end
			-- if debugDCUT then _affiche(DictKey, "DictKey DcUT") end

			for country_n, country in pairs(staticTemplate.coalition[side].country) do					--iterate through countries
				for classname, class in pairs(country) do
					-- if debugDCUT then print("DCUT A classname: "..tostring(classname).." classT: "..tostring(classT)) end

					if classname == classT  then
						-- if debugDCUT then print("DCUT B ") end

						for group_n, group in pairs(class.group) do				--iterate through groups in country.static.group table
							-- if debugDCUT then print("DCUT C ") end

							if group.name == name then				--if the target element is found in group table
								return true
							elseif string.find(group.name, "DictKey_") then
								-- if debugDCUT then print("DCUT D DictKey[group.name]: "..tostring(DictKey[group.name]).." name: "..tostring(name)) end

								if DictKey[group.name]  == name then
									-- if debugDCUT then print("DCUT E return true") end

									return true
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


-- ["requiredModules"] = 
-- {
-- 	["WWII Armour and Technics"] = "WWII Armour and Technics",
-- }, -- end of ["requiredModules"]

local function checkRequiredModules()
	if  type(tabTemplates) == "table" then
		for i = 1 , #tabTemplates do
			dofile("Templates/"..tabTemplates[i])

			if staticTemplate.requiredModules then
				for key, value in pairs(staticTemplate.requiredModules) do
					local entry = {
						["name"] = tostring(value),
						["origine"] = {
							"Template: "..tabTemplates[i],
						}
					}
					if ListRequiredModules[value] then
						table.insert(ListRequiredModules[value].origine, "Template: "..tabTemplates[i] )
					else
						ListRequiredModules[value] = entry
					end
				end
			end
		end
	end
	return false
end


checkRequiredModules()

if Debug.checkTargetName and (Firstmission_flag or Skipmission_flag) then
	tabTemplates = TabFileTemplate()
end

-- box = {
	-- ["min_x"] = 9999999,
	-- ["min_y"] = 9999999,
	-- ["max_x"] = -9999999,
	-- ["max_y"] = -9999999,
-- }
-- box = {	--caucasus
	-- ["min_x"] = -488954,
	-- ["min_y"] = 199450,
	-- ["max_x"] = 62058,
	-- ["max_y"] = 942610,
-- }

local box = {	--gulf
	["min_x"] = -289090,
	["min_y"] = -840909,
	["max_x"] = 790909,
	["max_y"] = 377272,
}

for coal_name,coal in pairs(oob_ground) do										--go through sides(red/blue)	
	for country_n,country in ipairs(coal) do									--go through countries
		if country.vehicle then													--country has vehicles
			for group_n,group in ipairs(country.vehicle.group) do				--go through groups
				if group.x < box.min_x then
					box.min_x = group.x
				end
				if group.x  > box.max_x then
					box.max_x = group.x
				end
				if group.y <box. min_y then
					box.min_y = group.y
				end
				if group.y  > box.max_y then
					box.max_y = group.y
				end
			end
		end

		if country.ship then													--country has ships
			for group_n,group in ipairs(country.ship.group) do					--go through groups
				if group.x < box.min_x then
					box.min_x = group.x
				end
				if group.x  > box.max_x then
					box.max_x = group.x
				end
				if group.y <box. min_y then
					box.min_y = group.y
				end
				if group.y  > box.max_y then
					box.max_y = group.y
				end
			end
		end
	end
end

for base_name,base in pairs(db_airbases) do

	if base.x and base.x ~= 9999999999 then
		if base.x < box.min_x then
			box.min_x = base.x
		end
		if base.x  > box.max_x then
			box.max_x = base.x
		end
	end
	if base.y and base.y ~= 9999999999 then
		if base.y <box. min_y then
			box.min_y = base.y
		end
		if base.y  > box.max_y then
			box.max_y = base.y
		end
	end
end


if camp_ZoneSAR and camp_ZoneSAR ~= nil then
	for SideTL, targets in pairs(targetlist)	 do
		if camp_ZoneSAR[SideTL] then
			for zoneName, elementC in pairs(camp_ZoneSAR[SideTL]) do

				local AltiReference = 999999
				local referenceX = elementC[1].x2d
				local referenceY = elementC[1].y2d

				for i = 1, #elementC do

					local ePriority = 0
					if elementC[i].inTheEnemyCamp then
						ePriority = 5		--	10
					elseif elementC[i].inTheEnemyCamp == false then
						ePriority = 7		--	100
					elseif elementC[i].inTheEnemyCamp == nil then
						ePriority = 6		--	50
					end

					local foundZoneName = false
					for targetN, target in ipairs(targets) do
						if target.titleName == zoneName then
							local foundElement = false
							if target.elements then

								for elementN, element in pairs(target.elements) do
									if elementC[i].name == element.name then
										element.status = elementC[i].status
										element.x = elementC[i].x2d
										element.y = elementC[i].y2d
										element.z = elementC[i].z2d
										foundElement = true
									end
								end
							end

							if not foundElement then
								table.insert(target.elements, elementC[i] )
							end

							foundZoneName = true
							target.selectedUnitSAR = elementC[1].selectedUnitSAR
							break
						end
					end

					if not foundZoneName then
						local newElement = elementC[i]
						newElement.type = "Ejected Pilot"
						newElement.x = elementC[i].x2d
						newElement.y = elementC[i].y2d
						newElement.z = elementC[i].z2d

						local newTarget = {
							task = "CSAR",
							priority = ePriority,
							titleName = zoneName,
							type = "Ejected Pilot",
							firepower = {
								min = 1,
								max = 1,
							},

							elements = {
								[1] = newElement,
							},
							selectedUnitSAR = elementC[1].selectedUnitSAR
						}

						table.insert(targets,newTarget )

					end

					--repere le EjectedPilot ayant l'alti le plus bas
					if elementC[i].z2d < AltiReference and (elementC[i].status == "EVAC_possible" or elementC[i].status == "MIA" ) then
						AltiReference = elementC[i].z2d
						referenceX = elementC[i].x2d
						referenceY = elementC[i].y2d
					end
				end

				for targetN, target in ipairs(targets) do
					if target.titleName == zoneName then
						target.x = referenceX
						target.y = referenceY
						target.z = AltiReference
					end
				end
			end
		end
	end

	--suppression des éléments inutile (rescued ou POW)	
	repeat
		local findDeprecated = false
		for side, targets in pairs(targetlist)	 do
			for i = #targets, 1, -1 do
			-- for targetN, target in ipairs(targets) do
				if targets[i].elements then
					for elementN, element in ipairs(targets[i].elements) do
						if element.status and (element.status == 'rescued' or element.status == "POW") then
							-- _affiche(element, "element PW or Rescued DcUT ")

							table.remove(targets[i].elements, elementN)
							findDeprecated = true
								--supprime la zone SAR s'il n'y a plus d'élément dedans
								if targets[i].elements == nil or #targets[i].elements == 0 then
									table.remove(targets, i)
								end
							break
						end
					end
				end
				if findDeprecated then break end
			end
			if findDeprecated then break end
		end

	until findDeprecated == false

end


for side_name, targets in pairs(targetlist) do													--Iterate through all side
	for targetN, target in pairs(targets) do												--Iterat through all targets
		local maxRange = 0
		if not target.name then
			target.name = target.titleName
		end

		if not target.name then
			print("DcUT no target.name , voici le target.titleName: "..tostring(target.titleName) )
			_affiche(target, "DcUT TargetNoName")
			os.execute 'pause'
		end

		-- checkBug(target, "targetlist", "name")
		if target.titleName then checkBug(target.titleName, "targetlist", "target.titleName") end
		if target.name then checkBug(target.name, "targetlist", "target.name") end

		target.ATO = true																	--add target to ATO boolean

		if  target.task ~= "Runway Attack" then
			target.alive = nil																	--clear target alive value
		end

		local targetside = "red"															--variable which side the target is on
		if side_name == "red" then
			targetside = "blue"
		end

		--target position by refpoint 
		if target.refpoint then																--target coordinates are referenced by a refpoint
			if Refpoint then																--global Refpoint is not available when UpdateTargelist is called by DEBRIEF_Master. In this case updating the target coordinates can be ignored as this is not needed for Debriefing.

				if type(target.refpoint) == "table" then									--multiple refpoints
					target.MultiPoints = {}
					for n = 1, #target.refpoint do
						target.MultiPoints[n] = {}
						target.MultiPoints[n].x = Refpoint[target.refpoint[n]].x			--get x-coordinate
						target.MultiPoints[n].y = Refpoint[target.refpoint[n]].y			--get y-coordinate
					end
					target.x = target.MultiPoints[1].x										--for targets with multiple points use first point as target coordinates (proforma only, not needed for tasks with multiple points)
					target.y = target.MultiPoints[1].y
				else																		--only a single refoint
					if not Refpoint[target.refpoint] then
						print("DCE does not find the name of this reference (of targetlist) in the fields of baseMission.miz "..tostring(target.refpoint))
						os.execute 'pause'
						_affiche(Refpoint, "Refpoint")
						os.execute 'pause'
					end

					target.x = Refpoint[target.refpoint].x									--get x-coordinate
					target.y = Refpoint[target.refpoint].y									--get y-coordinate
				end
				if target.x == nil or target.y == nil then
					checkBug3(" Error_01: Refpoint '" .. target.refpoint .. "' of target '" .. target.name .. "' not found!")
				end
			end
		end

		--target position slaved to group/unit
		if target.slaved then																--target coordinates are slaved relative to a group/unit
			local master = target.slaved[1]
			local bearing = target.slaved[2]
			local distance = target.slaved[3]

			local master_x
			local master_y

			--find either master group or units (vehicle or ship) and get master  x-y coordinates
			for coal_name,coal in pairs(oob_ground) do										--go through sides(red/blue)	
				for country_n,country in ipairs(coal) do									--go through countries
					if country.vehicle then													--country has vehicles
						for group_n,group in ipairs(country.vehicle.group) do				--go through groups
							if group.name == master then
								master_x = group.x
								master_y = group.y
								break
							else
								for unit_n,unit in ipairs(group.units) do
									if unit.name == master then
										master_x = unit.x
										master_y = unit.y
										break
									end
								end
							end
						end
					end

					if country.ship then													--country has ships
						for group_n,group in ipairs(country.ship.group) do					--go through groups
							if group.name == master then
								master_x = group.x
								master_y = group.y
								break
							else
								for unit_n,unit in ipairs(group.units) do
									if unit.name == master then
										master_x = unit.x
										master_y = unit.y
										break
									end
								end
							end
						end
					end
				end
			end

			if master_x and master_y then													--a master was found
				target.x = master_x + math.cos(math.rad(bearing)) * distance				--update target position relative to master position
				target.y = master_y + math.sin(math.rad(bearing)) * distance				--update target position relative to master position
			else																			--no master was found
				checkBug3(" Error_02 target position slaved to group/unit : Master '" .. master .. "' of target '" ..  "' not found!")
			end
		end

		if target.task == "Strike" then
			if target.class == nil or  target.class == "vehicle" or  target.class == "static"  then														--For scenery object targets
				-- if target.CheckDay and target.CheckDay < CampTotalTimeS then
				-- 	target.dead_last = 0
				-- 	target.CheckDay = CampTotalTimeS
				-- end
				target.alive = 100															--Introduce percentage of alive target elements
				target.x = 0																--Introduce x coordinate for target
				target.y = 0																--Introduce y coordinate for target
				target.dead_last = 0														--Introduce percentage of elements that died in last mission (for Debriefing)

				-- print("DcUT targetName "..side_name.." "..tostring(target.name))
				if target.name == nil then
					_affiche(target, "target nil")
				end

				local checkGroup = {}
				checkGroup[target.name] = {
					MainObjective = true,
				}
				if target.additionalGroupName then
					for checkGroupN, checkGroupName in pairs(target.additionalGroupName) do
						checkGroup[checkGroupName] = {
							MainObjective = false,
						}
					end
				end
				if target.additionalGroupName_MainObjective then
					for checkGroupN, checkGroupName in pairs(target.additionalGroupName) do
						checkGroup[checkGroupName] = {
							MainObjective = true,
						}
					end
				end
				if target.elements then
					for _elementN, element_ in pairs(target.elements) do
						if element_.class and element_.class == "static" then
							checkGroup[element_.name] = {
								MainObjective = true,
							}
						end
					end
				end

				for country_n, country in pairs(oob_ground[targetside]) do					--iterate through countries
					for classname, classG in pairs(country) do								--iterate through classes in country 
						if classname == "vehicle" or classname == "ship" or classname == "static" then				--for vehicles or ships
							for group_n, group in pairs(classG.group) do						--iterate through groups in country.vehcile.group or country.ship.group table
								if checkGroup[group.name] then							--if the target is found in group table
									target.foundOobGround = true
									if group.probability and group.probability < 1 then		--if group probability of spawn is less than 100%
										target.ATO = false									--remove target to ATO
									end
									target.alive = 100										--Introduce percentage of alive target elements
									target.groupId = group.groupId							--store target group ID
									target.x = group.x										--add x coordinate of target
									target.y = group.y										--add y coordinate of target

									--TODO revoir ça et ajouter certainement un fix&noHidden dans les param des gros SAM
									if target.lat and target.lon then
										group.hidden = true
									end

									if not target.elements then target.elements = {} end	--add elements table
									-- target.dead_last = 0									--Introduce percentage of elements that died in last mission (for Debriefing)

									for unit_n, unit in pairs(group.units) do				--Iterate through all units of group
										local alreadyThere = false
										for elementN, element in pairs(target.elements) do
											if unit.name == element.name then

												element.dead = unit.dead								--store unit status
												element.dead_last = unit.dead_last					--store unit dead_last
												element.CheckDay = unit.CheckDay						-- M19 ajoute la date destruction/ravito pour les futurs check de ravitaillement
												element.x = unit.x
												element.y = unit.y
												element.class = classname
												element.fromGroupName = true
												element.type = unit.type
												element.mainObjective = checkGroup[group.name].MainObjective


												if element.dead then											--if target element is dead		
													target.alive = target.alive - 100 / #target.elements				--reduce target alive percentage	
												end
												-- if element.dead_last then
												-- 	target.dead_last = target.dead_last + 100 / #target.elements		--add target died in last mission percentage
												-- end

												alreadyThere = true
												break
											end
										end

										if not alreadyThere then

											local elementTemp = {							--add new element
												name = unit.name,								--store unit name
												dead = unit.dead,								--store unit status
												dead_last = unit.dead_last,						--store unit dead_last
												CheckDay = unit.CheckDay,						-- M19 ajoute la date destruction/ravito pour les futurs check de ravitaillement
												x = unit.x,
												y = unit.y,
												class = classname,
												fromGroupName = true,
												type = unit.type,
												mainObjective = checkGroup[group.name].MainObjective,

											}
											table.insert(target.elements, elementTemp)
										end

										--check range from threat
										if GroundthreatsAll then

											for elementN, element in pairs(target.elements) do
												for threatN, threat in pairs(GroundthreatsAll[ DCS_ENI_Side[side_name] ]) do
													if element.x  and element.x > math.floor(threat.x)-1 and  element.x < math.floor(threat.x)+1 then
														if element.y > math.floor(threat.y)-1 and  element.y < math.floor(threat.y)+1 then
															element.range = threat.range

															if not element.dead and  maxRange < element.range then
																maxRange = element.range
															end
														end
													end
												end
											end
										end

									end

									for unit_n, unit in pairs(group.units) do						--Iterate through all units of group
										if unit.dead then											--Unit is dead
											target.alive = target.alive - 100 / #target.elements	--reduce target alive percentage	
										end
										-- if unit.dead_last then
										-- 	target.dead_last = target.dead_last + 100 / #target.elements	--add target died in last mission percentage
										-- end
									end
									target.alive = math.floor(target.alive)
									-- target.dead_last = math.floor(target.dead_last)
									target.range = maxRange
								end
							end
						end
					end
				end

				if not target.foundOobGround then
					local InTemplate = findInTemplates(target.name, targetside, "vehicle")
					if InTemplate then
						target.foundOobGround = true
					end
				end

				-- if not target.foundOobGround then 
				-- 	print(" Error_7: this target |"..target.name.."| linked to this objective  (targetlist_ini.lua)|"..target.titleName.."| was not found in the file (oob_groud)") 
				-- 	-- checkBug3(" Error_8: this base |"..target.name.."| linked to this objective  (targetlist_ini.lua)|"..target.titleName.."| was not found in the file (db_airbase.lua)") 
				-- end

				target.range = maxRange

				if target.elements then
					--permet de rechercher les elements déjà present dans targetList, car renseigné par campaignMaker
					for elementN, element in pairs(target.elements) do									--Iterate through elements of target															
						if element.fromGroupName == nil and element.fromUnitName == nil  then  --and not element.class

							local temp = {x=0,y=0,class=""}
							temp.x, temp.y, temp.class = checkElementXY(element, targetside)

							if temp.x == nil then
								local elementTMP = Deepcopy(element)
								elementTMP.name = elementTMP.name.."-1"
								temp.x, temp.y, temp.class = checkElementXY(elementTMP, targetside)
								if temp.x ~= nil then

									element.name = element.name.."-1"
								end
							end



							if temp.x == nil then
								element.class = "MapObject"
							else
								element.class = temp.class
								element.x = temp.x										--add x coordinate of target
								element.y = temp.y										--add y coordinate of target
							end

							if  element.x then
								target.x = element.x										--add x coordinate of target
								target.y = element.y										--add y coordinate of target
							end

							if element.dead then											--if target element is dead		
								target.alive = target.alive - 100 / #target.elements				--reduce target alive percentage	
							end
							-- if element.dead_last then
							-- 	target.dead_last = target.dead_last + 100 / #target.elements		--add target died in last mission percentage
							-- end

						end
					end
				end

				if target.elements and not target.inactive then
					for elementN, element in pairs(target.elements) do
						if  (element.x == 0 or not element.x) then
							checkBug3(" Error_05 : this targelist item was not found in oob_ground or base_mission, a space character error or -1?:  |" .. element.name .. "|")
						end
					end
				end

				if (target.x == nil or target.x == 0) and not target.inactive then
					local totalGoodXY = 0
					local centre = {
						x=0,
						y=0,
					}
					if target.elements then
						for elementN, element in pairs(target.elements) do
							if element.x and element.y then
								centre.x = centre.x + element.x
								centre.y = centre.y + element.y
								totalGoodXY = totalGoodXY + 1
							end
						end
						if totalGoodXY > 0 then
							target.x = centre.x / totalGoodXY
							target.y = centre.y / totalGoodXY
						end
					else

						local txt = "DcUT no found xy "..target.titleName.." (normal message if it's a template activation)"
						InsertBugList("DC_UT checkBug_xy :"..txt)
						-- os.execute 'pause'
					end
				end

			elseif target.class == "airbase" then											--target consists of aircraft on ground
				target.ATO = false															--remove target from ATO (gets reverted further down if there are ready planes at target airbase)
				-- target.alive = 0
				for n = 1, #oob_air[targetside] do											--iterate through enemy aviation units
					checkBug(oob_air[targetside][n].base, "oob_air", "airbase")
					if oob_air[targetside][n].base == target.name then						--aviation unit is on target base
						if db_airbases[target.name] then									--if the target airbase has an entry in db_airbases table
							target.foundOobGround = true
							if oob_air[targetside][n].roster.ready > 0 then					--aviation unit has ready aircraft
								target.ATO = true											--add target to ATO
								-- target.alive =  oob_air[targetside][n].roster.ready
								target.unit = {												--add entry for aviation unit at target airbase
									name = oob_air[targetside][n].name,						--name of aviation unit at target airbase
									type = oob_air[targetside][n].type,						--type of aircraft at target airbase
									number = oob_air[targetside][n].roster.ready,			--ready aircraft of aviation unit at target airbase
								}
								target.x = db_airbases[target.name].x						--add x coordinate of target
								target.y = db_airbases[target.name].y						--add y coordinate of target
								if not target.x or target.x == nil then
									checkBug3(" Error_7: this base |"..target.name.."| linked to this objective  (targetlist_ini.lua)|"..target.titleName.."| was not found in the file (db_airbase.lua)")

								end
							end
						end
					end
				end
				if not target.foundOobGround then
					checkBug3(" Error_8: this base |"..target.name.."| linked to this objective  (targetlist_ini.lua)|"..target.titleName.."| was not found in the file (db_airbase.lua)")
				end

			end

		elseif target.task == "Anti-ship Strike" then										--For ship group targets
			for country_n, country in pairs(oob_ground[targetside]) do						--iterate through countries
				if country.ship then
					for group_n, group in pairs(country.ship.group) do						--Iterate through groups in country.ship.group table
						checkBug(group.name, "base_mission", "ship")
						if group.name == target.name then									--If the target is found in group table
							target.foundOobGround = true
							if group.probability and group.probability < 1 then			--if group probability of spawn is less than 100%
								target.ATO = false										--remove target to ATO
							end
							target.alive = 100											--Introduce percentage of alive target elements
							target.groupId = group.groupId								--store target group ID
							target.x = group.x											--add x coordinate of target
							target.y = group.y											--add y coordinate of target

							if target.lat and target.lon then
								group.hidden = true
							end

							target.elements = {}										--add elements table
							target.dead_last = 0										--Introduce percentage of elements that died in last mission (for Debriefing)
							for unit_n, unit in pairs(group.units) do					--Iterate through all units of group
								local temp = {x=0,y=0,class=""}
								temp.x, temp.y, temp.class = checkElementXY(unit, targetside)
								if temp.x == nil then
									temp.class = "MapObject"
								end
								target.elements[unit_n] = {								--add new element
									name = unit.name,									--store unit name
									dead = unit.dead,									--store unit status
									dead_last = unit.dead_last,							--store unit dead_last
									CheckDay = unit.CheckDay,							-- M19 ajoute la date destruction/ravito pour les futurs check de ravitaillement
									class = temp.class,
									x = temp.x,
									y = temp.y,
									type = unit.type,
									mainObjective = true,
								}
							end
							for unit_n, unit in pairs(group.units) do						--Iterate through all units of group
								if unit.dead then											--Unit is dead
									target.alive = target.alive - 100 / #target.elements	--reduce target alive percentage	
								end
								if unit.dead_last then
									target.dead_last = target.dead_last + 100 / #target.elements	--add target died in last mission percentage
								end
							end
							target.alive = math.floor(target.alive)
							target.dead_last = math.floor(target.dead_last)
							-- break
						end
					end
				end
			end

			if not target.foundOobGround then
				local InTemplate = findInTemplates(target.name, targetside, "ship", true)
				if InTemplate then
					target.foundOobGround = true
				end
			end


			-- if not target.foundOobGround then checkBug3("DC_UT Anti-ship Strike error Not Found "..target.titleName) end
			if not target.foundOobGround then checkBug3(" Error_9: this Ship |"..target.name.."| linked to this objective  (targetlist_ini.lua)|"..target.titleName.."| was not found in the file (base_mission.miz or template)") end

		elseif target.task == "Transport" or target.task == "Nothing" then					--For transport or ferry tasks
			if target.destination and not db_airbases[target.destination] then
				print("DcUT from targetlist/destination, no found |"..tostring(target.destination).."|  in db_airbases ")

			elseif target.destination and not db_airbases[target.destination].x then
				print("DcUT from targetlist/destination, no found |"..tostring(target.destination).."| xy position, in db_airbases ")
			end
			target.x = db_airbases[target.destination].x
			target.y = db_airbases[target.destination].y

		elseif target.task == "CSAR" then
			target.alive = 100															--Introduce percentage of alive target elements
			target.dead_last = 0														--Introduce percentage of elements that died in last mission (for Debriefing)
			for e = 1, #target.elements do												--Iterate through elements of target
				if not target.elements[e].x then
					checkBug3(" Error_10: The x and y positions of this SAR position are missing:  '" .. target.titleName .. "!")
					-- os.execute 'pause'
				end
				if target.elements[e].dead then											--if target element is dead		
					target.alive = target.alive - 100 / #target.elements				--reduce target alive percentage	
				end
				if target.elements[e].dead_last then
					target.dead_last = target.dead_last + 100 / #target.elements		--add target died in last mission percentage
				end
			end
			target.alive = math.floor(target.alive)
			target.dead_last = math.floor(target.dead_last)

		elseif target.task == "Runway Attack" then
			--creation des parties de Runway à bombarder, crée à partir des info runway.hdg et runway.length x et y
			-- la mise a jour du target runway se fait dans le fichier DEBRIEF_StatsEvaluation.lua
			-- en fonction du runway.life qui doit etre de 3600 point lorsqu'il est intacte.
			if db_airbases[target.db_airbaseName] then									--if the target airbase has an entry in db_airbases table

				target.foundOobGround = true

				target.x = db_airbases[target.db_airbaseName].x						--add x coordinate of target
				target.y = db_airbases[target.db_airbaseName].y						--add y coordinate of target

				if db_airbases[target.db_airbaseName].runways and db_airbases[target.db_airbaseName].runways[1] and db_airbases[target.db_airbaseName].runways[1].hdg then
					--pour le cas particulier des runway non detecté à l'impacte bombe, il faut s appuyer sur target.element.dead et non oob_ground dead
					if  target.elements == nil   then

						target.alive = 100
						target.dead_last = 0
						for iRunway, runway in ipairs(db_airbases[target.db_airbaseName].runways) do
							if runway.x and runway.x ~= 0 then
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
										if not target.elements then target.elements = {} end

										target.elements[#target.elements +1] = {
											name = target.db_airbaseName.." runway "..runway.name.." part "..e,
											x = newPos.x,
											y = newPos.y,
											mainObjective = true,
										}

									end

								-- elseif camp.theatre and string.lower(camp.theatre) == "syria" then 
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
										if not target.elements then target.elements = {} end

										target.elements[#target.elements +1] = {
											name = target.db_airbaseName.." runway part "..e,
											x = newPos.x,
											y = newPos.y,
											mainObjective = true,
										}

									end
									hdg = hdg + 180

									distance = 0
									for e = 5, 8 do
										distance = distance + interval
										local newPos = GetOffsetPoint({x=runway.x, y=runway.y}, hdg, distance)
										if not target.elements then target.elements = {} end

										target.elements[#target.elements +1] = {
											name = target.db_airbaseName.." runway part "..e,
											x = newPos.x,
											y = newPos.y,
											mainObjective = true,
										}

									end
								end
							end
						end
					else --si les element runway exite

						for elementN, element in pairs(target.elements) do
							element.mainObjective = true
						end

						if target.alive and target.alive < 50 then
							target.ATO = false										--remove target to ATO

							--rempli la table camp qui sera utilisé pour détruire artificiellement la piste pendant le jeux
							if not camp.runwayCratere then camp.runwayCratere = {} end
							if not camp.runwayCratere[target.titleName] then
								camp.runwayCratere[target.titleName] = target
							end
						end

						if not target.alive or target.alive == nil then
							target.alive = 100
						end


						--met à jour target_dead_last pour avoir le (-70%) par exemple dans le DEBRIEF_Text
						for e = 1, #target.elements do												--Iterate through elements of target
							if target.elements[e].dead_last then
								target.dead_last = target.dead_last + 100 / #target.elements		--add target died in last mission percentage
							end
						end

						target.dead_last = math.floor(target.dead_last)
					end

				else
					local txtBug = "DcUT The information runway hdg and lenght and position runway.x, runway.y are missing in the file db_airbases.lua to create the portions to attack.\n"
					txtBug = txtBug .."DcUT Bug related to the targetlist_init.lua file in the target: : "..target.titleName.."\n"

					InsertBugList(txtBug)

					if mission_ini.debug then
						print(txtBug)
						os.execute 'pause'
					end
				end

				if not target.x or target.x == nil then
					checkBug3(" Error_11: this base |"..target.db_airbaseName.."| linked to this objective  (targetlist_ini.lua)|"..target.titleName.."| was not found in the file (db_airbase.lua)")
				end
			end

			if not target.foundOobGround then checkBug3(" Error_12: this base |"..target.db_airbaseName.."| linked to this objective  (targetlist_ini.lua)|"..target.titleName.."| was not found in the file (db_airbase.lua)") end

		end

		if target.alive then																--target has an alive value (is a ground target)
		-- if 	target.task and target.task == "Strike" or target.task == "Anti-ship Strike" or target.task == "Runway Attack" then
			if not target.alive then
				_affiche(target, "not targetAlive")
			end
			if target.elements then
				target = updateAlive(target)
			end

			local attibut
			if target.attributes and target.attributes[1] then attibut = string.upper(target.attributes[1]) end

			-- modification M26  destroys targets if below a certain value
			if target.alive <= campMod.KillTargetValue and target.alive > 0 and attibut ~= "RUNWAY" then					--if target alive is lower than 0 (due to rounding errors)
				checkBug2("DC_UT target.name target.alive <= 20 "..target.titleName.." "..tostring(target.alive))
				KillTarget(target.titleName, target.name)															--set target alive 0
				target.alive = 0
				if target.elements then
					for element_n,element in pairs(target.elements) do
						if not element.dead then
							KillTarget(element.name, target.titleName)
						end
					end
				end
			end
			if target.elements then
				target = updateAlive(target)
			end
			if target.alive < 0 then														--if target alive is lower than 0 (due to rounding errors)
				target.alive = 0															--set target alive 0
			end
			if target.alive == 0 then														--target is destroyed
				target.ATO = false															--remove target from ATO
			end


			--calcul le nombre de cible encore intacte, pour stat DEBUG
			if target.inactive ~= true then													--target is active
				if 	target.task and target.task == "Strike" or target.task == "Anti-ship Strike" or target.task == "Runway Attack" then
					GroundTarget[side_name].total = GroundTarget[side_name].total + 1			--count the number of all ground targets for each side
					if target.alive > 0 then													--target is not destroyed
						GroundTarget[side_name].alive = GroundTarget[side_name].alive + 1		--count the number of all alive ground targets for each side
					else
						-- _affiche(target, "target non alive>0")
						-- os.execute 'pause'
					end
				else
					-- print("DcUT ignores this target: ".. target.titleName)
				end
			end

			if target.inactive ~= true then													--target is active
				if 	target.zone then

					if not GroundZoneTarget[side_name][target.zone] then
						GroundZoneTarget[side_name][target.zone] = {
							total = 0,
							alive = 0,
						}
					end
					GroundZoneTarget[side_name][target.zone].total = GroundZoneTarget[side_name][target.zone].total + 1			--count the number of all ground targets for each side

					if target.alive > 0 then													--target is not destroyed
						GroundZoneTarget[side_name][target.zone].alive = GroundZoneTarget[side_name][target.zone].alive + 1		--count the number of all alive ground targets for each side
					end
				else
					-- print("DcUT ignores this target: ".. target.titleName)
				end
			end

		end
	end

	checkBug2("DC_UT GroundTarget "..side_name.." "..GroundTarget[side_name].total.." Alive: "..GroundTarget[side_name].alive)


	if GroundTarget[side_name].total > 0 then
		GroundTarget[side_name].percent = math.ceil(100 / GroundTarget[side_name].total * GroundTarget[side_name].alive)	--calculate percentage of alive ground targets per side
		checkBug2("DC_UT GroundTarget "..side_name.." percent "..GroundTarget[side_name].percent)
	end

	for sideString, zones in pairs(GroundZoneTarget) do
		for zoneName, zone in pairs(zones) do
			if zone.total > 0 then
				zone.percent = math.ceil(100 / zone.total * zone.alive)	--calculate percentage of alive ground targets per side
				checkBug2("DC_UT GroundZoneTarget "..sideString.." zoneName: "..zoneName.." percent "..zone.percent)
			end
		end
	end
end


--********************************************************************************************************
--Update targetList avec le fichier LL_KnownPositionsTable.lua
--adds GPS lat positions with the LL_KnownPositionsTable file, if it exists
--********************************************************************************************************

LL_KnownPositionsFileExit = false
local posFile = "Init/LL_KnownPositionsTable.lua"
local TestPath = io.open(posFile, "r")
if  TestPath ~= nil then
	LL_KnownPositionsFileExit = true
	io.close(TestPath)
	dofile(posFile) --LL_KnownPositions = {}
end

if LL_KnownPositionsFileExit then
	for campName, targets in pairs(targetlist) do
		for targetName, target in pairs(targets) do
			local foundTarget = false
			if target.x and target.x ~= 0 then
				local xKey = math.abs(math.floor(target.x))
				if LL_KnownPositions[xKey]  then
					local testX = math.floor(target.x)
					local testY = math.floor(target.y)
					for n, llPos in pairs(LL_KnownPositions[xKey] ) do
						if testX == llPos.x and testY == llPos.y then
							target.lat = llPos.lat
							target.lon = llPos.lon
							target.elevation = llPos.elevation
							foundTarget = true
							break
						end
					end
				end

				if not foundTarget then
					local distMin = 9999999
					local pointNearest = {}
					for nPos, llPositions in pairs(LL_KnownPositions ) do
						for n, llPos in pairs(llPositions ) do
							local dist = GetDistance(llPos,target)
							if dist < distMin then
								distMin = dist
								pointNearest = llPos
							end
						end
					end
					if distMin ~= 9999999 then
						local azimut = GetHeading(target, pointNearest)
						target.lat, target.lon = NewPosLatLon(pointNearest.lat, pointNearest.lon, distMin, azimut)
					end
				end

				if target.elements then
					for i, element in pairs(target.elements) do
						if element.x and element ~= 0 then

							local xKey = math.abs(math.floor(element.x))
							if LL_KnownPositions[xKey]  then
								local testX = math.floor(element.x)
								local testY = math.floor(element.y)
								for n, llPos in pairs(LL_KnownPositions[xKey] ) do
									if testX == llPos.x and testY == llPos.y then
										element.lat = llPos.lat
										element.lon = llPos.lon
										element.elevation = llPos.elevation
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


--********************************************************************************************************
--creates a table of all targets' xy positions so that DCS can transform them into lat/lon GPS positions
--********************************************************************************************************


local qte = 1
local targetPosTemp = {}


for sideName, countries in pairs(oob_ground) do
	for countryN, country in pairs(countries) do
		if type(country) == "table" then
			for typeName, typeTable in pairs(country) do
				if typeName == "vehicle" or typeName == "ship" or typeName == "static" then
					for groupN, group in pairs(typeTable.group) do

						if group.x and group.y then

							local addItem = false

							local floor_x = math.floor(group.x)
							local floor_y = math.floor(group.y)
							local xKey = math.abs(floor_x)

							if not targetPosTemp[xKey] then
								targetPosTemp[xKey] = {}
								addItem = true
							else
								for n, pos in pairs(targetPosTemp[xKey]) do
									if floor_x == pos.x and floor_y == pos.y then
										break
									end
								end
							end

							if addItem == true then
								local posTemp = {
									x = floor_x,
									y = floor_y,
									-- from = "Ground_Groups",
								}
								table.insert(targetPosTemp[xKey], posTemp)
								-- print("DcUT #targetPosTemp:oob_ground "..qte.." "..typeName)
								qte = qte + 1
							end

							for unitN, unit in pairs(group.units) do
								if unit.x and unit.y then
									local addItemSub = false

									local floor_x = math.floor(unit.x)
									local floor_y = math.floor(unit.y)
									local xKey = math.abs(floor_x)

									if not targetPosTemp[xKey] then
										targetPosTemp[xKey] = {}
										addItemSub = true
									else
										for n, pos in pairs(targetPosTemp[xKey]) do
											if floor_x == pos.x and floor_y == pos.y then
												break
											end
										end
									end

									if addItemSub == true then
										local posTemp = {
											x = floor_x,
											y = floor_y,
											-- from = "Ground_Groups",
										}
										table.insert(targetPosTemp[xKey], posTemp)
										-- print("DcUT #targetPosTemp:oob_ground "..qte.." ")
										qte = qte + 1
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


--***************************************************************************
-- Lire le fichier targetlist pour ajouter les xy des elements de la map

if targetlist then
	for campName, targets in pairs(targetlist) do
		for targetName, target in pairs(targets) do
			if target.x and target.y then
				local addItem = false

				local floor_x = math.floor(target.x)
				local floor_y = math.floor(target.y)
				local xKey = math.abs(floor_x)

				if not targetPosTemp[xKey] then
					targetPosTemp[xKey] = {}
					addItem = true
				else
					for n, pos in pairs(targetPosTemp[xKey]) do
						if floor_x == pos.x and floor_y == pos.y then
							break
						end
					end
				end

				if addItem == true then
					local posTemp = {
						x = floor_x,
						y = floor_y,
						-- from = "TargetList_Groups",
					}
					table.insert(targetPosTemp[xKey], posTemp)
				end

				if target.elements then
					for i, element in pairs(target.elements) do
						if element.x and element.x ~= 0 and element.y and element.y ~= 0 then
							local addItemSub = false

							local floor_x = math.floor(element.x)
							local floor_y = math.floor(element.y)
							local xKey = math.abs(floor_x)

							if not targetPosTemp[xKey] then
								targetPosTemp[xKey] = {}
								addItemSub = true
							else
								for n, pos in pairs(targetPosTemp[xKey]) do
									if floor_x == pos.x and floor_y == pos.y then
										break
									end
								end
							end

							if addItemSub == true then
								local posTemp = {
									x = floor_x,
									y = floor_y,
									-- from = "TargetList_Elements",
								}
								table.insert(targetPosTemp[xKey], posTemp)
								-- print("DcUT #targetPosTemp: targetlist "..qte.." ")
								qte = qte + 1
							end

						end
					end
				end

			end
		end
	end
end

--*********************************************************************************
tabTemplates = TabFileTemplate()

if tabTemplates ~= nil then
	for i = 1 , #tabTemplates do
		dofile("Templates/"..tabTemplates[i])

		for sideName, sideTable in pairs(staticTemplate.coalition) do
			for labelCountry, countries in pairs(sideTable) do
				if type(countries) == "table" then
					for countryN, country in pairs(countries) do
						for typeName, typeTable in pairs(country) do
							if typeName == "vehicle" or typeName == "ship" or typeName == "static" then
								for groupN, group in pairs(typeTable.group) do

									if group.x and group.y then

										local addItem = false

										local floor_x = math.floor(group.x)
										local floor_y = math.floor(group.y)
										local xKey = math.abs(floor_x)

										if not targetPosTemp[xKey] then
											targetPosTemp[xKey] = {}
											addItem = true
										else
											for n, pos in pairs(targetPosTemp[xKey]) do
												if floor_x == pos.x and floor_y == pos.y then
													break
												end
											end
										end

										if addItem == true then
											local posTemp = {
												x = floor_x,
												y = floor_y,
												-- from = "Template_Group",
											}
											table.insert(targetPosTemp[xKey], posTemp)
										end

										for unitN, unit in pairs(group.units) do
											if unit.x and unit.y then
												local addItemSub = false

												local floor_x = math.floor(unit.x)
												local floor_y = math.floor(unit.y)
												local xKey = math.abs(floor_x)

												if not targetPosTemp[xKey] then
													targetPosTemp[xKey] = {}
													addItemSub = true
												else
													for n, pos in pairs(targetPosTemp[xKey]) do
														if floor_x == pos.x and floor_y == pos.y then
															break
														end
													end
												end

												if addItemSub == true then
													local posTemp = {
														x = floor_x,
														y = floor_y,
														-- from = "Template_Units",
													}
													table.insert(targetPosTemp[xKey], posTemp)
													-- print("DcUT #targetPosTemp: template "..qte.." ")
													qte = qte + 1
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


--*********************************************************************************

for baseName, base in pairs(db_airbases) do
	if base.x and base.y and base.x < 999999999 and base.x > -999999999 and base.y < 999999999 and base.y > -999999999 then
		local addItem = false

		local floor_x = math.floor(base.x)
		local floor_y = math.floor(base.y)
		local xKey = math.abs(floor_x)

		if not targetPosTemp[xKey] then
			targetPosTemp[xKey] = {}
			addItem = true
		else
			for n, pos in pairs(targetPosTemp[xKey]) do
				if floor_x == pos.x and floor_y == pos.y then
					break
				end
			end
		end

		if addItem == true then
			local posTemp = {
				x = floor_x,
				y = floor_y,
				-- from = "airbase",
			}
			table.insert(targetPosTemp[xKey], posTemp)
			-- print("DcUT #targetPosTemp:db_airbases "..qte.."")
			qte = qte + 1
		end
	end
end

--*********************************************************************************
-- cherche les points 
if mission and mission.triggers and mission.triggers.zones then
	for zoneN, zone in pairs(mission.triggers.zones) do
		if zone.x and zone.y  then
			local addItem = false

			local floor_x = math.floor(zone.x)
			local floor_y = math.floor(zone.y)
			local xKey = math.abs(floor_x)

			if not targetPosTemp[xKey] then
				targetPosTemp[xKey] = {}
				addItem = true
			else
				for n, pos in pairs(targetPosTemp[xKey]) do
					if floor_x == pos.x and floor_y == pos.y then
						break
					end
				end
			end

			if addItem == true then
				local posTemp = {
					x = floor_x,
					y = floor_y,
					-- from = "triggers.zones",
				}
				table.insert(targetPosTemp[xKey], posTemp)
				-- print("DcUT #targetPosTemp:zone "..qte.."")
				qte = qte + 1
			end
		end
	end
end

--*********************************************************************************
camp.targetPos = targetPosTemp
--*********************************************************************************


if Debug.debug then
	_affiche(GroundTarget, " DcUT GroundTarget")
	_affiche(GroundZoneTarget, " DcUT GroundZoneTarget")

	local camp_str = "target = " .. TableSerialization(targetlist, 0)						--make a string
	local campFile = io.open("Debug/targetlist_DcUT.lua", "w") or error("Failed to open debug file")
	campFile:write(camp_str)															--save new data
	campFile:close()


	local camp_str = "oob_ground = " .. TableSerialization(oob_ground, 0)						--make a string
	local campFile = io.open("Debug/oob_ground_DcUT.lua", "w") or error("Failed to open debug file")
	campFile:write(camp_str)															--save new data
	campFile:close()

	-- os.execute 'pause'
end