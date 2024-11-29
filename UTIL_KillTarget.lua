-- helps the CampaignMaker 
--
------------------------------------------------------------------------------------------------------- 
-- Last Modification adjustment_b
if not versionDCE then versionDCE = {} end
versionDCE["UTIL_KillTarget.lua"] = "1.6.20"
------------------------------------------------------------------------------------------------------- 
-- Debug_c
-- cleanCode_a
-- adjustment_b				(b target boucle) (a Firstmission_flag
-- modification M61_a		SAR
-- modification M56_a		AssignCallnameSquad
-- modification M38_l		Check and Help CampaignMaker (l: naval environment)(k: enleve du targetlist les CAP inter etc)(j: debug) (h: activeInactiveTarget step by step)
------------------------------------------------------------------------------------------------------- 

local debugKT = true

local function activeInactiveGround(targetName, active, dead)
	-- print("UtilKT activeInactiveGround tostring "..tostring(targetName).." active " ..tostring(active).." dead "..tostring(dead))
	local inactive = true
	if active then
		inactive = false
	end

	for side_name,side in pairs(oob_ground) do
		for country_n,country in pairs(side) do
			if country.vehicle then
				for group_n, group in pairs(country.vehicle.group) do
					if targetName == group.name then
						for unit_n, unit in pairs(group.units) do


							if dead then
								unit.dead = true														--mark unit as dead in oob_ground
								unit.dead_last = true													--mark unit as died in last mission
								print("UKT oob_ground dead  vehicle "..unit.name)
							else
								unit.DCE_inactive = inactive
								print("UKT oob_ground PasseIn/Active vehicle "..unit.name)

							end
						end
						if not dead then
							group.DCE_inactive = inactive
							print("UKT oob_ground PasseIn/Active vehicle "..group.name)
						end
					end
				end
			end
			if country.static then
				for group_n, group in pairs(country.static.group) do
					if targetName == group.name then
						for unit_n, unit in pairs(group.units) do

							if dead then
								unit.dead = true														--mark unit as dead in oob_ground
								unit.dead_last = true													--mark unit as died in last mission
								print("UKT oob_ground dead  static "..unit.name)
							else
								unit.DCE_inactive = inactive
								print("UKT oob_ground PasseIn/Active static "..unit.name)

							end
						end
						if not dead then
							group.DCE_inactive = inactive
							print("UKT oob_ground PasseIn/Active static "..group.name)

						end
					end
				end
			end
			if country.ship then
				for group_n,group in pairs(country.ship.group) do
					if targetName == group.name then
						for unit_n,unit in pairs(group.units) do


							if dead then
								unit.dead = true														--mark unit as dead in oob_ground
								unit.dead_last = true													--mark unit as died in last mission
								print("UKT oob_ground dead  ship "..unit.name)
							else
								unit.DCE_inactive = inactive
								print("UKT oob_ground PasseIn/Active ship "..unit.name)
							end
						end
						if not dead then
							group.DCE_inactive = inactive
							print("UKT oob_ground PasseIn/Active ship "..group.name)
						end
					end
				end
			end
		end
	end
end

local function activeInactiveTarget(targetName, active, pourcent, side, dead)
	local inactive = true
	if active then
		inactive = false
	end

	if targetName ~= nil and not dead then
		activeInactiveGround(targetName, active)

		for side_name, targets in pairs(targetlist) do											--iterate through targetlist
			for targetN, target in pairs(targets) do										--iterate through targets
				if targetName == target.titleName then

					target["inactive"] = inactive
					print("UKT targetlist PasseIn/Active ship "..targetName)
				end
			end
		end
	elseif dead == true then
		for side_name, targets in pairs(targetlist) do											--iterate through targetlist
			for targetN, target in pairs(targets) do										--iterate through targets
				if targetName == target.titleName then
					if target.elements then
						for element_n,element in pairs(target.elements) do
							if element.dead then											--element was already dead previously
								element.dead_last = false									--mark element as not died in last mission
							else
								element.dead = true
								print("UKT targetlist dead target "..element.name)

								-- activeInactiveGround(targetName, active, dead)
								activeInactiveGround(element.name, 	nil, 	dead)

							end
						end
					end


				end
			end
		end

		-- activeInactiveGround(targetName, active, dead)
		activeInactiveGround(targetName, 	nil, 	dead)
	else
		local i = 1
		local nbDesactive = 0

		--compte le nombre de cible
		local nbCible = 0
		for targetN, target in pairs(targetlist[side]) do										--iterate through targets
			if target.task and target.task ~= "Intercept" and target.task ~= "CAP" and target.task ~= "AWACS" and target.task ~= "Refueling"  and target.task ~= "Transport"  and target.task ~= "SAR" then
				nbCible = nbCible+1
			end
		end

		local randomDesactive = math.random(1, nbCible)

		repeat
			i=i+1
			local iCible = 0
			for targetN, target in pairs(targetlist[side]) do										--iterate through targets
				if target.task and target.task ~= "Intercept" and target.task ~= "CAP" and target.task ~= "AWACS" and target.task ~= "Refueling"  and target.task ~= "Transport"  and target.task ~= "SAR" then
					iCible = iCible+1
					if iCible == randomDesactive and target["inactive"] ~= inactive then

						target["inactive"] = inactive
						activeInactiveGround(target.titleName, active)
						nbDesactive = nbDesactive + 1
						break

					end
				end
			end

		until (nbDesactive/nbCible *100 )> pourcent  or i>2000

	end
end


local function checkGroundFirst(pourcent, side, active )

	local inactive = true
	if active then
		inactive = false
	end

	local nbDesactive = 0

	--compte le nombre de cible
	local nbCible = 0
	for country_n, country in pairs(oob_ground[side]) do
		if country.vehicle then
			for group_n, group in pairs(country.vehicle.group) do

				nbCible = nbCible + #group.units

			end
		end
	end

	print("UtilKT nbCible "..nbCible.." pourcent: "..pourcent)

	repeat
		local randomCible = math.random(1, nbCible)

		-- print("UtilKT randomCible "..randomCible.." nbDesactive "..nbDesactive)
		local breakOn = false
		for country_n,country in pairs(oob_ground[side]) do

			local i_cible = 0

			if country.vehicle then

				for group_n, group in pairs(country.vehicle.group) do
					for unit_n, unit in pairs(group.units) do
						i_cible = i_cible + 1

						if i_cible == randomCible then

							if not unit.DCE_inactive or (unit.DCE_inactive ~= inactive) then
								unit.DCE_inactive = inactive
								nbDesactive = nbDesactive + 1

								print("UKT                                     activeInactiveGround PasseIn/Active "..unit.name)
								breakOn = true
							end
						end
						if breakOn then break end
					end

				end
			end
			if breakOn then break end
		end

		-- print("UtilKT nbDesactive "..nbDesactive)

	until (nbDesactive/nbCible *100 )> pourcent

	-- print("UtilKT nbDesactive "..nbDesactive.." nbCible: "..nbCible.." nbDesactive/nbCible "..tostring(nbDesactive/nbCible *100))


	--si tous les véhicules ont été desactivé et qu'ils font partie du targetlist, on desactive le target de targetlist
	for country_n, country in pairs(oob_ground[side]) do
		if country.vehicle then
			for group_n, group in pairs(country.vehicle.group) do

				local totalUnit = #group.units
				local sumUnitDesactive = 0

				for unit_n, unit in pairs(group.units) do
					if unit.DCE_inactive and  unit.DCE_inactive == true then
						sumUnitDesactive = sumUnitDesactive +1
					end
				end

				if sumUnitDesactive >= totalUnit then

					print("UKT activeInactiveTarget inactive "..group.name)
					activeInactiveTarget(group.name, false)
				end

			end
		end
	end


end

--===================================================================================
-- Ecran N 0 Choix Num mission
print("Actuel Num de mission "..camp.mission)
print("Change number of mission or press \"Enter\".\n")				--ask for user confirmation



local input, input2

input = tonumber(io.stdin:read())
if input and input ~= nil and input > 0 and input < 100 then
	camp.mission = input
end


repeat
	local tableTargetlist = {}
	local i = 1
	local tableTargetlist = {
			["blue"] = {},
			["red"] = {},
			}
	for side, targets in PairsByKeys(targetlist) do														--iterate through sides in targetlist						
		for targetN, target in PairsByKeys(targets) do												--iterate through all hostile targets
			if target.task and target.task ~= "Intercept" and target.task ~= "CAP" and target.task ~= "AWACS" and target.task ~= "Refueling"  and target.task ~= "Transport"  and target.task ~= "SAR" then
				local active = false
				if not target.inactive or target.inactive == nil  then
					active = true
				end
				if active then
					local draftTarget = {
							["name"] = tostring(target.titleName),
							["priority"] = tonumber(target.priority),
							["alive"] = tonumber(target.alive),
							["active"] = active,

							}

					table.insert(tableTargetlist[side], draftTarget)

					i = i +1
				end
			end
		end
	end

	for side, targets in PairsByKeys(targetlist) do														--iterate through sides in targetlist						
		for targetN, target in PairsByKeys(targets) do												--iterate through all hostile targets
			if target.task and target.task ~= "Intercept" and target.task ~= "CAP" and target.task ~= "AWACS" and target.task ~= "Refueling"  and target.task ~= "Transport"  and target.task ~= "SAR" then
				local active = false
				if not target.inactive or target.inactive == nil  then
					active = true
				end
				if not active then
					local draftTarget = {
							["name"] = tostring(target.titleName),
							["priority"] = tonumber(target.priority),
							["alive"] = tonumber(target.alive),
							["active"] = active,

							}

					table.insert(tableTargetlist[side], draftTarget)

					i = i +1
				end
			end
		end
	end

	-- table.sort(tableTargetlist["red"], function(a,b) return a.priority > b.priority  end)
	-- table.sort(tableTargetlist["blue"], function(a,b) return a.priority > b.priority  end)

	-- table.sort(tableTargetlist["red"], function(a, b) return a.type:upper() < b.type:upper() end)
	-- table.sort(tableTargetlist["blue"], function(a, b) return a.type:upper() < b.type:upper() end)

	-- table.sort(oobAirSide, function(a, b) return a.type:upper() < b.type:upper() end)

	local tabIndex = {}
	for side, Targetlist in PairsByKeys(tableTargetlist) do
		local jMax, ownerSide
		if side == "red" then
			ownerSide = "blue coalition"
			jMax = #tableTargetlist["red"]
		else
			ownerSide = "red coalition"
			jMax = #tableTargetlist["blue"]
		end
		local j = 1

		local Ckey = 0
		print() print(ownerSide..":")
		for key, value in PairsByKeys(Targetlist) do
			if  j <= jMax and value.active  then
				if side == "red" then
					Ckey = key + #tableTargetlist["blue"]															--permet de n'afficher qu'un nombre continue pour les 2 camps
				else
					Ckey = key
				end
				io.write(  Ckey.." "..tostring(value.name) .."  "..tostring(value.alive).." % Actif? "..tostring(value.active).."\n")
				if not tabIndex[Ckey]  then tabIndex[Ckey] = {} end
				tabIndex[Ckey]["side"] = side
				j = j+1
			end
		end

		for key, value in PairsByKeys(Targetlist) do
			if  j <= jMax and not value.active  then
				if side == "red" then
					Ckey = key + #tableTargetlist["blue"]															--permet de n'afficher qu'un nombre continue pour les 2 camps
				else
					Ckey = key
				end
				io.write(  Ckey.." "..tostring(value.name) .."  "..tostring(value.alive).." % Actif? "..tostring(value.active).."\n")
				if not tabIndex[Ckey]  then tabIndex[Ckey] = {} end
				tabIndex[Ckey]["side"] = side
				j = j+1
			end
		end
	end

	print()
	print("(dead)      : tue les targets")
	print("(actif)     : active/desactive les targets, ajoute/supprime les véhicules/static associé")
	print("(pourcentA) : desactive les TARGET en masse, par pourcentage")
	print("(pourcentB) : desactive n'importe quel VEHICULE en random et en masse, par pourcentage")
	print("(S)         : Stop script ")
	print()

	local active
	repeat
		dofile("../../../ScriptsMod."..versionPackageICM.."/DC_UpdateTargetlist.lua")							--ce n'est pas un doublon, il faut garder les 2 Update
		dofile("../../../ScriptsMod."..versionPackageICM.."/DC_CheckTriggers.lua")
		dofile("../../../ScriptsMod."..versionPackageICM.."/DC_UpdateOOBGround.lua")		-- add oob_ground in mission.coalition..... don't forget ^^



		local inputString = string.lower(io.stdin:read())
		if inputString == "s" then
			break
		elseif inputString == "pourcenta" then
			print(" entrer la valeur en pourcentage des groupes ROUGE au sol a désactiver (targetlist.blue)")
			inputString = string.lower(io.stdin:read())
			local pourcentDesactive = tonumber(inputString)
			active = false
			activeInactiveTarget(nil, active, pourcentDesactive, "blue")

			print(" entrer la valeur en pourcentage des groupes BLUE au sol a désactiver (targetlist.red)")
			inputString = string.lower(io.stdin:read())
			local pourcentDesactive = tonumber(inputString)
			active = false
			activeInactiveTarget(nil, active, pourcentDesactive, "red")

			print("(S) Stop script ?")

		elseif inputString == "pourcentb" then
			print(" entrer la valeur en pourcentage des groupes BLUE au sol a désactiver")
			inputString = string.lower(io.stdin:read())
			local pourcentDesactive = tonumber(inputString)
			active = false
			checkGroundFirst(  pourcentDesactive, "blue", active)

			print(" entrer la valeur en pourcentage des groupes RED au sol a désactiver")
			inputString = string.lower(io.stdin:read())
			local pourcentDesactive = tonumber(inputString)
			active = false
			checkGroundFirst(  pourcentDesactive, "red", active)

			print("(S) Stop script ?")

		elseif inputString == "dead" then
			print(" entrer le numero de la cible à Killer ")

			inputString = string.lower(io.stdin:read())

			input = tonumber(inputString)

			if (input == nil or input == "") then input = 999 end

			if input >  #tableTargetlist["blue"] then
				Ckey = input - #tableTargetlist["blue"]
			else
				Ckey = input
			end

			if  tabIndex[input] then
				local side = tabIndex[input]["side"]
				local dead = true

				print(" passe activeInactiveTarget? "..tostring(dead))

				--activeInactiveTarget(targetName,					 active, pourcent, side, dead)
				activeInactiveTarget(tableTargetlist[side][Ckey].name, nil, 	nil,	nil,  dead)

				print("\n"..tableTargetlist[side][Ckey].name.."\n")
			else
				print("\nInvalid entry.\n")
			end

			print("(S) Stop script ?")


		elseif inputString == "actif" then
			print(" entrer le numero de la cible à activer/desactiver ")
			print(" i: inactiver, a: activer ")
			print(" 37i: par exemple: desactiver la cible 37 ")

			inputString = string.lower(io.stdin:read())

			input = tonumber(inputString)

			local active

			active = string.sub (inputString, -1)

			if tostring(active) == "a" then
				active = true
				input = inputString:sub(1, -2)

			elseif tostring(active) == "i" then
				active = false
				input = inputString:sub(1, -2)

			end

			input = tonumber(input)

			if (input == nil or input == "") then input = 999 end
			if input >  #tableTargetlist["blue"] then
				Ckey = input - #tableTargetlist["blue"]
			else
				Ckey = input
			end

			if  tabIndex[input] then
				local side = tabIndex[input]["side"]

				--activeInactiveTarget(targetName,					 active, pourcent, side, dead)
				activeInactiveTarget(tableTargetlist[side][Ckey].name, active, 	nil,	nil,  nil)

				print("\n"..tableTargetlist[side][Ckey].name.."\n")
			else
				print("\nInvalid entry.\n")
			end

			print("(S) Stop script ?")


		else
			input = tonumber(inputString)
		end



		dofile("../../../ScriptsMod."..versionPackageICM.."/DC_UpdateTargetlist.lua")							--ce n'est pas un doublon, il faut garder les 2 Update
		dofile("../../../ScriptsMod."..versionPackageICM.."/DC_CheckTriggers.lua")
		dofile("../../../ScriptsMod."..versionPackageICM.."/DC_UpdateOOBGround.lua")		-- add oob_ground in mission.coalition..... don't forget ^^



	until  tabIndex[input] or inputString == "s"
	io.write( "\n")



	print("(S) Stop script ?")
	print("(enter) to start again.\n")
	input2 = string.lower(io.stdin:read())

until  input2 == "s"
io.write( "\n")

UTIL_KillTarget = false


--TODO ne permettre que la mise a jour du num mission

