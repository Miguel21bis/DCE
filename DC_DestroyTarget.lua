-- No more destroying targets below 20% (default) or any other value decided in targetlist neutralization
-- Initiated by Debrief_Master.lua
------------------------------------------------------------------------------------------------------- 
-- last modification adjustment_a
if not versionDCE then versionDCE = {} end
versionDCE["DC_DestroyTarget.lua"] = "1.2.2"
------------------------------------------------------------------------------------------------------- 
-- adjustment_a				(a CampTotalTimeS)
-- modification M26_a : detruit les targets si inférieur à une certaine valeur --destroys targets if below a certain value
-- ------------------------------------------------------------------------------------------------------- 


function KillTargetOLD(Target_Name, TargetPName)

	for side_name,side in pairs(oob_ground) do														--side table(red/blue)											
		for country_n,country in pairs(side) do														--country table (number array)
			if country.vehicle then																	--if country has vehicles
				for group_n,group in pairs(country.vehicle.group) do								--groups table (number array)
					if group.name == Target_Name or group.name == TargetPName then
						for unit_n,unit in pairs(group.units) do										--units table (number array)					

							if Debug.AfficheSol then print("DC_DT Kill "..unit.name) end
						
							unit.dead = true														--mark unit as dead in oob_ground
							unit.dead_last = true													--mark unit as died in last mission
							unit.CheckDay = camp.date.CampTotalTimeS  
						end
					end
				end
			end
			if country.static then																--if country has static objects	
				for group_n,group in pairs(country.static.group) do								--groups table (number array)
					if group.name == Target_Name or group.name == TargetPName then
						for unit_n,unit in pairs(group.units) do									--units table (number array)
							if Debug.AfficheSol then print("DC_DT Kill "..unit.name) end
							
							if unit.dead ~= true then											--unit is not yet dead (some static objects that are spawned in a destroyed state are logged dead at mission start, these must be excluded here)
								group.dead = true												--mark group as dead in oob_ground (static objects can be set as group.dead and spawned in a destroyed state)
								group.hidden = true												--hide dead static object
								unit.dead = true												--mark unit as dead in oob_ground (this is for the targetlist)
								unit.dead_last = true
								unit.CheckDay = camp.date.CampTotalTimeS  
							end
						end
					end
				end
			end
			if country.ship then																--if country has ships
				for group_n,group in pairs(country.ship.group) do								--groups table (number array)
					if group.name == Target_Name or group.name == TargetPName then	
						for unit_n,unit in pairs(group.units) do									--units table (number array)	
							if Debug.AfficheSol then print("DC_DT Kill "..unit.name) end
							
							unit.dead = true													--mark unit as dead in oob_ground
							unit.dead_last = true												--mark unit as died in last mission
							unit.CheckDay = camp.date.CampTotalTimeS                              -- ajoute la date de destruction    Miguel21 modification M19 : Repair SAM   
						end
					end
				end
			end
		end
	end
	
	for side_name, targets in pairs(targetlist) do											--iterate through targetlist
		for targetN, target in pairs(targets) do										--iterate through targets
			if target.titleName == Target_Name or target.titleName == TargetPName then	
				if target.elements and target.elements[1].x then 						--if the target has subelements and is a scenery object target (element has x coordinate)
					for element_n,element in pairs(target.elements) do					--iterate through target elements
						-- if element.dead then											--element was already dead previously
						-- 	element.dead_last = false									--mark element as not died in last mission
						-- else
							if Debug.AfficheSol then print("DC_DT Kill __SCENERY__ "..element.name) end
							element.dead = true	
							element.dead_last = true
							element.CheckDay = camp.date.CampTotalTimeS  
						-- end
					end
				end
			end
		end
	end	
end