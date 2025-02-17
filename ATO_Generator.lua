--To create the Air Tasking Order
--Initiated by Main_NextMission.lua
------------------------------------------------------------------------------------------------------- 
-- last modification:  cleancode_d adjustment_Ab M11A_bk Debug_t
if not versionDCE then versionDCE = {} end
versionDCE["ATO_Generator.lua"] = "1.20.134"
------------------------------------------------------------------------------------------------------- 
-- cleancode_d				(d springCleaning)
-- adjustment_Ab			(b target priority (again))(low Red flight)(score & sort)(a country table)(z target priority)(y nb of Cap & Firepower)(v: depreciated variable capability)(u score & strikeOnlyWithEscorte)(minscore)(s tasks table)(op ne donne pas tout en CAP)(o info loadout)(N ne donne pas tout en CAP)(lM: MP) (ghi:donne une alti aléatoire) (f:altitude en fonction diff entre role)(e: random loadout temp)(cd:support équitable entre escadron)(b: TASK Coef)(a: escort mandatory or not)
-- Debug_t					(t boost priority in MP)(s no Choice Plane MP with SEAD)(r priority again)(q sort C broken)(p multipack broken)(o #Draft_sorties)(n db_loadouts)(m strikeOnlyWithEscorte)(l AltitudeFloorNew)(k too tanker&Awacs)(jk number entre 0 et1)(i info2000)(h:reecriture loadout_eligible) (f:interdit l'escorte avion/helico)(de:correction targetName)(c: mauvaise insertion dans la base)(b: haut score)(a: Fin de campagne)
-- modification M68_a		add AFAC task
-- modification M61_a		SAR
-- modification M56_b		AssignCallnameSquad (b: callsignId)
-- modification M53_b		automatic update of the conf_mod file (b conf_mod reconfiguration)
-- modification M49_c		big central db_loadout (c: loadout statistics)
-- modification M43			assignation des numeros de parking du type C08 
-- modification M42			liveryModex
-- modification M38_t		Check and Help CampaignMaker (t debug/debugGenerator)(r +)(o _affiche) (e: loadout Task?)
-- modification M16_b		SpawnAir B1b & B-52 need BaseAirStart = true in db_aibase
-- modification M13_e		Performance Scripting
-- modification M11A_bk		Multiplayer	(bk tente d obtenir ce que l'on souahite)(bj same target)(bi bug CAP)(bb: rapport entre escorte et cap)(wxy: force same package)(z: debug MP avec 1 Plane)(y: interdit l'escorte avion/helico) (x: EscorteTot-max) (w: choix EscorteMax) (v: interdit Strike sans escorte)(u: reserve avion Escorte) (t: different Type possible/task)
-- modification M06			helicopter playable
------------------------------------------------------------------------------------------------------- 	


DebugAssignAll = false
AltiHelicoMap = {}
AltitudeFloorNew = {}
PlayerSquad = {}

DebugRoute = false
local blockOnlyPriority = false
local denom_NeDonnePasTOUT = 1.5 --1.3		--nb, coef, dénominateur pour ne pas donner tous les chasseurs à l'escorte, en garder pour les intercepteur/cap
--plus le chiffre est petit, moins il y a de CAP et intercepteur
-- if Aircraft_availability[draft.name].unassigned - test_Aircraftnumber <= Aircraft_availability[draft.name].serviceable/denom_NeDonnePasTOUT then

-- ne donne pas tout aux Strike:
local testCode = false	-- false: petite campagne comme Tchad/ true: grande campagne

local multipackByTargetName = {}

local bias = 4 -- Pondération pour target.firepower : plus grand = plus proche de `min

--calcul le nb d'avion en tout
local nbBeforPlaneActifTotal = {
	blue = {
		ready = 0,
		reserve = 0
	},
	red = {
		ready = 0,
		reserve = 0
	},
}
--calcul le nb d'avion en tout
local nbAfterPlaneActifTotal = {
	blue = {
		used = 0,
		reserve = 0
	},
	red = {
		used = 0,
		reserve = 0
	},
}

local priorityRef = {
	blue =0,
	red = 0,
}
local newDraftByPriority = {
	blue = {},
	red = {},
}

--creation du targetlist par ordre de priorité
local targetListPrio = {
	blue = {},
	red = {},
}
local targetListPrioCheck = {
	blue = {},
	red = {},
}
local targetNamePrio = {
	blue = {},
	red = {},
}

if Debug.debug and oob_air then
	for side, units in pairs(oob_air) do																								--iterate through all sides	
		for unitN, unit in pairs(units) do
			if not unit.inactive or unit.inactive == nil then
				if not unit.roster then
					nbBeforPlaneActifTotal[side].ready = nbBeforPlaneActifTotal[side].ready + unit.number
					nbBeforPlaneActifTotal[side].reserve = nbBeforPlaneActifTotal[side].reserve + unit.reserve
				else
					if unit.roster.ready then
						nbBeforPlaneActifTotal[side].ready = nbBeforPlaneActifTotal[side].ready + unit.roster.ready
					else
						print("AtoG strange, no roster.ready on this unit ")
						_affiche(unit, "unit")
					end

					if unit.roster.reserve then
						nbBeforPlaneActifTotal[side].reserve = nbBeforPlaneActifTotal[side].reserve + unit.roster.reserve
					-- else
					-- 	print("AtoG strange, no roster.reserve on this unit ")
					-- 	_affiche(unit, "unit")
					end


				end
			end
		end
	end
end

--crer une table identique, en enlevant les infos des layers 
for mapName, layers in pairs(AltitudeFloor) do
	if string.lower(mapName) == string.lower(mission.theatre) then
		for alti, layer in pairs(layers) do

			if not AltitudeFloorNew then AltitudeFloorNew = {} end
			if not AltitudeFloorNew[alti] then AltitudeFloorNew[alti] = {} end

			--structure relevant des dessins de ligne de l editeur de mission
			if layer[1].mapY then
				for PolyN = 1, #layer do

					local tempAlti = {}

					for pointN, point in ipairs(layer[PolyN].points) do
						tempAlti[pointN] = {
							x = point.x + layer[PolyN].mapX,
							y = point.y + layer[PolyN].mapY,
						}

					end
					table.insert(AltitudeFloorNew[alti], tempAlti)
				end
			--structure épuré, issue d un plan de vol, avec un seul polygone
			else
				-- tempAlti = layer
				AltitudeFloorNew[alti] = layer
			end

			-- if not AltitudeFloorNew then AltitudeFloorNew = {} end
			-- if not AltitudeFloorNew[alti] then AltitudeFloorNew[alti] = {} end

			-- table.insert(AltitudeFloorNew[alti], tempAlti)

		end
	end
end


local totalPlanePerTask = {
	red = {},
	blue = {},
	neutral = {},
}

require("Active/Loadouts_archive")
local error = 0
oob_air = oob_air or {} -- Assurez que c'est une table, même après un reset
for side, units in pairs(oob_air) do																								--iterate through all sides	
-- db_loadouts = {
	-- ["AV8BNA"] = {
		-- ["Anti-ship Strike"] = {

	for unitN, unit in pairs(units) do
		if type(unit.tasks) == "table" then
			for task, task_bool in pairs(unit.tasks) do
				if task_bool and task ~= "Spotter" then

					local foundTaskAndCountry = false

					if db_loadouts[unit.type] and db_loadouts[unit.type] ~= nil then

						if db_loadouts[unit.type][task] and db_loadouts[unit.type][task] ~= nil then

							for loadout_name, ltable in pairs(db_loadouts[unit.type][task]) do
								if ltable and type(ltable) == "table" then

									local countryEligible = false
									if ltable.country == nil  then
										countryEligible = true
										foundTaskAndCountry = true
									elseif type(ltable.country) == "string" then
										if string.lower(ltable.country) == string.lower(unit.country) or string.lower(ltable.country) == "all" then
											countryEligible = true
											foundTaskAndCountry = true
										end

									elseif type(ltable.country) == "table" then
										for n, countryLabel in pairs(ltable.country) do
											if string.lower(countryLabel) == string.lower(unit.country) or string.lower(countryLabel) == "all" then
												countryEligible = true
												foundTaskAndCountry = true
												break
											end
										end
									end


									if countryEligible then
										--creation table du nombre d'avion dispo pour une task
										if unit.roster and unit.roster.ready then
											if not totalPlanePerTask[side][task] then totalPlanePerTask[side][task] = 0 end
											totalPlanePerTask[side][task] = totalPlanePerTask[side][task] +	unit.roster.ready
										end
									end
								else
									print("AtoG error: "..unit.type.." not found in db_loadouts")
									os.execute 'pause'
									error = error + 1
								end
							end

						elseif task ~= "Spotter" then

							print("AtoG error: no task |"..tostring(task).."| in the loadout for this unit:? "..tostring(unit.type))
							os.execute 'pause'
						end

					else
						print("AtoG error: "..unit.type.." not found in db_loadouts. A problem with the campaigns_code_loadout code? "..tostring(campConfMod.code_loadout))
						os.execute 'pause'
					end

					if not foundTaskAndCountry then
						print("AtoG error: "..unit.type.." "..task.." not found in db_loadouts for this country: "..tostring(unit.country))
						os.execute 'pause'
						error = error + 1
					end
				end
			end
		end
	end
end


-- for typeName, type in pairs(db_loadouts) do
-- 	print("AtoG __ db_loadouts typeName: "..tostring(typeName))

-- 	for task, Ltables in pairs(type) do
-- 		for loadoutName, Ltable in pairs(Ltables) do

-- 			print("AtoG __ __ db_loadouts task: "..tostring(task).." "..tostring(Ltable.standoff))

-- 			if Ltable.standoff == nil then Ltable.standoff = 0 end

-- 			-- _affiche(table, "table")
-- 			-- os.execute 'pause'



-- 			table.sort(Ltable, function(a,b) return a.standoff > b.standoff  end)
-- 		end
-- 	end
-- end


if error > 5 then
	if string.lower(campMod.selectLoadout) == "init" then

	else
		print()
		print("================================================ATTENTION====================================================")
		print("AtoG error: ".." With so many errors using the Central loadout, there may be a custom loadout in the /Init folder \n "
		.."To do this, set the \"selectLoadout\" variable to \"init\" in the conf_mod")
		os.execute 'pause'
	end
end

local function mysort(s)
    -- convert hash to array
    local t = {}
    for k, v in pairs(s) do
        table.insert(t, v)
    end

    -- sort
    table.sort(t, function(a, b)
        if a.players ~= b.players then
            return a.priorityIni > b.priorityIni
        end

        return a.score > b.score
    end)
    return t
end

local function table_move(src, start, stop, dest, tbl)
    tbl = tbl or src
    local offset = dest - start
    if offset > 0 then -- Décalage vers l'avant
        for i = stop, start, -1 do
            tbl[i + offset] = src[i]
        end
    else -- Décalage vers l'arrière
        for i = start, stop do
            tbl[i + offset] = src[i]
        end
    end
    return tbl
end


local function round(num)
local dec = 2
  local mult = 10^(dec or 0)
  return math.floor(num * mult + 0.5) / mult
end

--status report counters
local status_counter_sorties = 0
local status_counter_escorts = 0
local status_counter_ATO = 0


--to track what caused lack of playable sortie for the player
Playability_criterium = {}
function TrackPlayability(player_unit, criterium)																				--function that tracks whether a playability criterium has been met
	if player_unit == true then																									--unit in question is playable by player
		Playability_criterium[criterium] = true																					--set playability criterium to be met
	end
end

--table to hold availability of aircraft
if not camp.Aircraft_availability and not camp.aircraft_availability then
	camp.Aircraft_availability = {}
	-- print("passe A Aircraft_availability")
elseif  camp.aircraft_availability then
	camp.Aircraft_availability = Deepcopy(camp.aircraft_availability)
	camp.aircraft_availability = nil
	-- print("passe B Aircraft_availability")
end
Aircraft_availability = camp.Aircraft_availability																				--link to table for easier reference

--table to store draft sorties (all valid unit/task/loadout/target combinations)
Draft_sorties = {
	blue = {},
	red = {}
}


local multiPlaneSet = {}

for k=1, Multi.NbGroup do
	--TODO beurk, à refaire ça propre
	if not multiPlaneSet[Multi.Group[k].side] then multiPlaneSet[Multi.Group[k].side] = {} end
	if not multiPlaneSet[Multi.Group[k].side][Multi.Group[k].PlaneType] then multiPlaneSet[Multi.Group[k].side][Multi.Group[k].PlaneType] = {} end
	-- multiPlaneSet[Multi.Group[k].PlaneType][Multi.Group[k].task] = true

	if not multiPlaneSet[Multi.Group[k].side][Multi.Group[k].PlaneType][Multi.Group[k].task] then multiPlaneSet[Multi.Group[k].side][Multi.Group[k].PlaneType][Multi.Group[k].task] = {} end
	if not multiPlaneSet[Multi.Group[k].side][Multi.Group[k].PlaneType][Multi.Group[k].task]["NbPlane"] then multiPlaneSet[Multi.Group[k].side][Multi.Group[k].PlaneType][Multi.Group[k].task]["NbPlane"] = 0 end

	multiPlaneSet[Multi.Group[k].side][Multi.Group[k].PlaneType][Multi.Group[k].task].NbPlane = Multi.Group[k].NbPlane + multiPlaneSet[Multi.Group[k].side][Multi.Group[k].PlaneType][Multi.Group[k].task].NbPlane
	multiPlaneSet[Multi.Group[k].side][Multi.Group[k].PlaneType][Multi.Group[k].task].InitNbPlaneByTask =  multiPlaneSet[Multi.Group[k].side][Multi.Group[k].PlaneType][Multi.Group[k].task].NbPlane

	if not multiPlaneSet[Multi.Group[k].side][Multi.Group[k].PlaneType].InitNbPlane then multiPlaneSet[Multi.Group[k].side][Multi.Group[k].PlaneType].InitNbPlane = 0 end
			multiPlaneSet[Multi.Group[k].side][Multi.Group[k].PlaneType].InitNbPlane = multiPlaneSet[Multi.Group[k].side][Multi.Group[k].PlaneType].InitNbPlane + Multi.Group[k].NbPlane
end


if Debug.debug and Debug.Generator.affiche then
	_affiche(Multi, "ATO_G Multi")
	_affiche(multiPlaneSet, "ATO_G multiPlaneSet B")
	-- os.execute 'pause'
end

if Debug.debug then
	for side, units in pairs(oob_air) do
		if units and units ~= nil then
			for unitN, unit in pairs(units) do
				if unit.player then
					if Debug.debug then
						print("AtoG playable "..unit.type.." ready "..unit.roster.ready)
					end
				end
			end
		end
	end
end

if Multi and Multi.Group then
	for kGroupN, multiGroup in pairs(Multi.Group) do
		for side, units in pairs(oob_air) do
			if units and units ~= nil then
				for unitN, unit in pairs(units) do
					if not unit.inactive and unit.type == multiGroup.PlaneType and side == multiGroup.side and unit.roster.ready < multiGroup.NbPlane   then
						unit.roster.ready = multiGroup.NbPlane * 2
						if Debug.debug then
							print("AtoG set Nplane "..unit.type.." ready "..unit.roster.ready)
						end
					end
				end
			end
		end
	end

	--augmente la priority de la cible choisie
	for kGroupN, multiGroup in pairs(Multi.Group) do
		for targetN, target in pairs(targetlist[multiGroup.side]) do
			if not target.inactive and not target.priorityINIT and target.titleName == Multi.Target[multiGroup.side] then
				target.priorityINIT = target.priority
				target.priority = target.priority * 4
				break
			end
		end
	end


end

table.sort(targetlist["blue"], function(a,b) return a.priority > b.priority  end)
table.sort(targetlist["red"], function(a,b) return a.priority > b.priority  end)


--creat draft sorties
for side, units in pairs(oob_air) do																								--iterate through all sides

	--determine enemy side
	local enemy																													--determine enemy side (opposite of unit side)
	if side == "blue" then
		enemy = "red"
	else
		enemy = "blue"
	end
	local draftId = 1
	if Debug.Generator.affiche then
		DebuGenTxt = DebuGenTxt.."\n\n"..("AtoG passe A_0 chapter: "..Debug.Generator.chapter.." SpySquad:  "..Debug.Generator.SpySquad.." SpyTask: "..Debug.Generator.SpyTask)
		if Debug.Generator.SpyTarget then
			DebuGenTxt = DebuGenTxt.."\n\n"..Debug.Generator.SpyTarget
		end
	end

	if units and units ~= nil then
		for unitN, unit in pairs(units) do																											--iterate through all units

			if unit.inactive and unit.player then
				print("AtoG attention, the player's squad is inactive. Activate it via DCE_Manager or directly in Init\\oob_air and Active\\oob_air ")
				os.execute 'pause'
			end


			if unit.inactive ~= true then																						--if unit is active

				local ClientPlayer = false
				if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "A")
				and (Debug.Generator.SpySquad and Debug.Generator.SpySquad == unit.name )
				then
					DebuGenTxt = DebuGenTxt.."\n\n"..("AtoG passe A_00 "..unit.type.." Befor Airbase Condition  ")
				end

				TrackPlayability(unit.player, "active_unit")																		--track playabilty criterium has been met

				if db_airbases[unit.base] and db_airbases[unit.base].inactive ~= true and db_airbases[unit.base].x and db_airbases[unit.base].y then	--base exists and is active and has a position value (carrier that exists)

					if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "A")
					and (Debug.Generator.SpySquad and Debug.Generator.SpySquad == unit.name  )
					then
						DebuGenTxt = DebuGenTxt.."\n"..("AtoG passe A_01 "..unit.type.." Befor roster.ready Condition  ")
					end
					TrackPlayability(unit.player, "base")																		--track playabilty criterium has been met


					local overRideReady = false
					if multiPlaneSet and  multiPlaneSet[side] and  multiPlaneSet[side][unit.type] then
						if unit.roster.ready < multiPlaneSet[side][unit.type].InitNbPlane then
							unit.roster.ready = multiPlaneSet[side][unit.type].InitNbPlane + 1
						end
						overRideReady = true
					end

					if Multi.NbGroup == 0 then
						ClientPlayer = unit.player

						-- if ClientPlayer then			print("AtoG passe Ia  ClientPlayer "..tostring(ClientPlayer)) end
					end

					if unit.player then
						PlayerSquad = unit
					end
					-- if overRideReady or unit.roster.ready > 0 then																				--has ready aircraft
					-- if unit.roster.ready > 0 then

						if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "A")
						and (Debug.Generator.SpySquad and Debug.Generator.SpySquad == unit.name  )
						then
							DebuGenTxt = DebuGenTxt.."\n"..("AtoG passe A_02 "..unit.type.." Befor aircraft_available Condition")
						end

						if Multi and Multi.Group and Debug.debug then
							for k=1, #Multi.Group do
								if Multi.Group[k].PlaneType == unit.type then
									print("AtoG type: "..unit.type.." rosterReady: "..unit.roster.ready)
								end
							end
						end

						TrackPlayability(unit.player, "ready_aircraft")															--track playabilty criterium has been met

						if Aircraft_availability[unit.name] == nil then															--unit has no aircraft availability entry yet
							Aircraft_availability[unit.name] = {}																--make an aircraft availability entry for this unit
						end

						if Aircraft_availability[unit.name].unavailable == nil then												--unit has no unavailable table yet
							if unit.unavailable then																				--there are preset unavailabilities in oob_air
								Aircraft_availability[unit.name].unavailable = unit.unavailable								--use this as initial unavailability
							else
								Aircraft_availability[unit.name].unavailable = {}												--create an empty unavailable table
							end
						end


						--serviceable aircraft
						local aircraft_serviceable = 0																				--serviceable aircraft of unit
						local serviceability = 0.8																					--defaults unit serviceability rating
						if unit.serviceability then																				--if serviceability for unit is defined
							serviceability = unit.serviceability																	--use it instead
						end

						if multiPlaneSet and multiPlaneSet[side] and multiPlaneSet[side][unit.type]   then
							aircraft_serviceable = unit.roster.ready
						else
							for s = 1, unit.roster.ready do																			--iterate through ready aircraft
								if math.random(1, 100) <= serviceability * 100 then														--default 80% chance that it is mission ready
									aircraft_serviceable = aircraft_serviceable + 1														--sum serviceable aircraft
								end
							end
						end

						Aircraft_availability[unit.name].ready = unit.roster.ready											--store ready aircraft un availability table
						Aircraft_availability[unit.name].serviceable = aircraft_serviceable										--store serviceable aircraft in availability table

						if DebugAssignAll then
							print("AtoGen&PA CampTotalTimeS "..tostring(CampTotalTimeS).." CampTotalTimeS en H "..CampTotalTimeS / 3600)
						end
						--unavailable aircraft
						local u_entry = 0

						for u = #Aircraft_availability[unit.name].unavailable, 1, -1 do											--iterate backwards through unavailable aircraft from this unit
							u_entry = u_entry + 1

							if DebugAssignAll then print("AtoGen Aircraft_availability  "..unit.type.." || "..unit.name) end

							if Aircraft_availability[unit.name].unavailable[u] > ((CampTotalTimeS / 3600)*2)   then
								-- print("AtoGen Aircraft_availability ____***______ "..tostring(CampTotalTimeS / 3600).." >=? UnitUnavailable?? "..tostring(Aircraft_availability[unit.name].unavailable[u]))
								Aircraft_availability[unit.name].unavailable[u] = 0
								-- os.execute 'pause'
							end

							-- print("AtoGen Aircraft_availability ____***______ "..tostring(CampTotalTimeS / 3600).." >=? UnitUnavailable?? "..tostring(Aircraft_availability[unit.name].unavailable[u]))
							if (CampTotalTimeS / 3600) >= Aircraft_availability[unit.name].unavailable[u] then
								table.remove(Aircraft_availability[unit.name].unavailable, u)								--remove this entry
								if DebugAssignAll then  print("AtoGen Aircraft_availability     ____***______ REMOVE ") end
							end
						end

						local aircraft_available = unit.roster.ready - #Aircraft_availability[unit.name].unavailable			--number of available aircraft

						-- if aircraft_available < 1 then
						-- 	print("AtoGen "..tostring(unit.name))
						-- 	print("AtoGen CampTotalTimeS "..tostring(CampTotalTimeS))

						-- 	_affiche(Aircraft_availability[unit.name], "AtoG Aircraft_availability[unit.name]")
						-- 	os.execute 'pause'
						-- end
						if aircraft_serviceable < aircraft_available then
							aircraft_available = aircraft_serviceable
						end
						Aircraft_availability[unit.name].available = aircraft_available											--store available aircraft in availability table
						Aircraft_availability[unit.name].assigned = 0
						Aircraft_availability[unit.name].unassigned = aircraft_available											--store unassigned aircraft in availability table

						if aircraft_available > 0 then																				--unit has available aircraft

							if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "A")
							and (Debug.Generator.SpySquad and Debug.Generator.SpySquad == unit.name  )
							then
								DebuGenTxt = DebuGenTxt.."\n\n"..("AtoG passe A_03 ".." Befor tasks Boucle")
							end
							TrackPlayability(unit.player, "available_aircraft")													--track playabilty criterium has been met


							for task,task_bool in pairs(unit.tasks) do																		--iterate through all tasks of unit		

								-- local ClientPlayer = false
								if task_bool and task ~= "SEAD" and task ~= "Escort" and task ~= "Escort Jammer" and task ~= "Flare Illumination" and task ~= "Laser Illumination" then		--task is true and is no support task

									if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "A")
									and (Debug.Generator.SpySquad and Debug.Generator.SpySquad == unit.name  and  Debug.Generator.SpyTask == task)
									then
										DebuGenTxt = DebuGenTxt.."\n"..("AtoG passe A_04b "..unit.type.." Befor task Condition | task: "..task)
									end

									--get possible loadouts
									local unit_loadouts = {}																					--table to hold all loadouts for this aircraft type and task

									if db_loadouts[unit.type] and db_loadouts[unit.type][task] then																		--db_loadouts table has loadouts for this task

										for loadout_name, ltable in pairs(db_loadouts[unit.type][task]) do									--iterate through all loadouts for the aircraft type and task

											local countryEligible = false
											if ltable.country == nil  then
												countryEligible = true
											elseif type(ltable.country) == "string" then
												if string.lower(ltable.country) == string.lower(unit.country) or string.lower(ltable.country) == "all" then
													countryEligible = true
												end

											elseif type(ltable.country) == "table" then
												for n, countryLabel in pairs(ltable.country) do
													if string.lower(countryLabel) == string.lower(unit.country) or string.lower(countryLabel) == "all" then
														countryEligible = true
														break
													end
												end
											end

											-- if ltable.country == nil or ltable.country == unit.country then									--loadout is country unspecific or applies to unit country
											if countryEligible then
												ltable.name = loadout_name																		--store loadout name
												-- table.insert(unit_loadouts, ltable)																--add loadout to local table

												ltable["hCruiseREF"] = ltable.hCruise
												ltable["hAttackREF"] = ltable.hAttack

												--ceci est un anti PBO_Corse66 ^^
												-- donne une alti aléatoire pour éviter de connaitre le type d'avion pas l'altitude habituellement utilisée
												if ltable.hCruise and ltable.hCruise > 2000 then
													local altiRandom = 0
													local RandomChance = math.random(0,100)

													if RandomChance < 50 then										--20% de chance d'avoir une alti de 1000 à 2000m de difference 
														altiRandom = math.random(100 ,200)

													elseif RandomChance < 70 then									--30% de chance d'avoir une alti de 1000m de difference
														altiRandom = math.random(0,100)
													end																--50% de chance d'avoir une alti de 0 de difference

													altiRandom = altiRandom *10 * (math.random(0, 1)*2-1)			--choisi si c'est une diff positive ou negative												
													ltable.hCruise = ltable.hCruise + altiRandom
													if ltable.hCruise < 300 then
														ltable.hCruise = 300
													end


													if ltable.hAttack then
														ltable.hAttack = ltable.hAttack + (altiRandom /2)
														if ltable.hAttack < 300 then
															ltable.hAttack = 300
														end
													end
												end


												--ajoute une task obligatoire en fonction du learning des missions précédentes
												if camp.newTaskRequest then
													for rSide, rSides in pairs(camp.newTaskRequest) do
														if rSide == side then
															for rTypeName, rTypes in pairs(rSides) do
																if rTypeName == unit.type then
																	for rTaskEnCours, rNewTasks in pairs(rTypes) do
																		if rTaskEnCours == task then
																			for rNewTask, value in pairs(rNewTasks) do
																				if value then
																					if not ltable.support then ltable.support = {} end
																					ltable.support[rNewTask] = true

																					-- print("AtoG passe Integration newTaskRequest "..rTypeName.." "..rTaskEnCours)
																					-- _affiche(ltable, "ltable")

																				end
																			end
																		end
																	end
																end
															end
														end
													end
												end


												unit_loadouts[#unit_loadouts+1] = ltable
												unit_loadouts[#unit_loadouts]["loadout_name"] = loadout_name
											end
										end
									end

									-- local test_str = "unit_loadouts = " .. TableSerializationLoadout(unit_loadouts, 0, 0)						--make a string	
									-- local testFile = io.open("Debug/loadouts_unit_loadouts.lua", "w")								--open targetlist file
									-- testFile:write(test_str)															--save new data
									-- testFile:close()

									-- os.execute 'pause'
									-- ATO_G_adjustment.e (e: random loadout temp)
									--mix the list of available loadouts so that you don't always have the same ones 
									--https://programming-idioms.org/idiom/10/shuffle-a-list/1313/lua
									for i = #unit_loadouts, 2, -1 do
										local j = math.random(i)
										unit_loadouts[i], unit_loadouts[j] = unit_loadouts[j], unit_loadouts[i]
									end

									for l = 1, #unit_loadouts do																				--iterate through all available loadouts				
										-- print("AAA ")
										if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "A")
										and (Debug.Generator.SpySquad and Debug.Generator.SpySquad == unit.name  and  Debug.Generator.SpyTask == task)
										then
											DebuGenTxt = DebuGenTxt.."\n\n"..("AtoG passe A_05 "..unit.type.." "..unit_loadouts[l].loadout_name.." Befor Loadouts Day/Night Condition")
										end

										--get possible Time on Target
										local tot_from = 0																						--earliest Time on Target for this loadout
										local tot_to = 0																						--latest Time on target for this loadout
										-- local tot_to =mission_ini.mission_duration
										if unit_loadouts[l].day and unit_loadouts[l].night then													--loadout is day and night capable
											tot_from = 0																						--from mission start
											tot_to = mission_ini.mission_duration																		--to mission end
											if task == "Intercept" or task == "SAR" then																			--for interceptors, tot_to is not limitted by mission duration
												tot_to = 999999
											end
										elseif unit_loadouts[l].day then																		--loadout is day capable
											if Daytime == "night-day" then
												tot_from = mission_ini.dawn - camp.time																--from dawn
												tot_to = mission_ini.mission_duration																	--to mission end
												if task == "Intercept" or task == "SAR" then																		--for interceptors, tot_to is not limitted by mission duration
													tot_to = mission_ini.dusk - camp.time
												end
											elseif Daytime == "day" then
												tot_from = 0																					--from missiom start
												tot_to = mission_ini.mission_duration																	--to mission end
												if task == "Intercept" or task == "SAR" then																		--for interceptors, tot_to is not limitted by mission duration
													tot_to = mission_ini.dusk - camp.time
												end
											elseif Daytime == "day-night" then
												tot_from = 0																					--from mission start
												tot_to = mission_ini.dusk - camp.time																	--to dusk
											end
										elseif unit_loadouts[l].night then																		--loadout is night capable
											if Daytime == "day-night" then
												tot_from = mission_ini.dusk - camp.time																--from dusk
												tot_to = mission_ini.mission_duration																	--to mission end
												if task == "Intercept" or task == "SAR" then																		--for interceptors, tot_to is not limitted by mission duration
													tot_to = mission_ini.dawn - camp.time
												end
											elseif Daytime == "night" then
												tot_from = 0																					--from mission start
												tot_to = mission_ini.mission_duration																	--to mission end
												if task == "Intercept"  or task == "SAR" then																		--for interceptors, tot_to is not limitted by mission duration
													tot_to = mission_ini.dawn - camp.time
												end
											elseif Daytime == "night-day" then
												tot_from = 0																					--from mission start
												tot_to = mission_ini.dawn - camp.time																	--to dawn
											end
										end

										-- if tot_to == 0 then
										-- 	print("AtoG Daytime "..tostring(Daytime).." loadoutName: "..tostring(unit_loadouts[l].name))
										-- 	os.execute 'pause'
										-- end

										if tot_to < 0 then
											tot_to = tot_to + 86400
										end
										if tot_from < 0 then
											tot_from = tot_from + 86400
										end

										if tot_to ~= 0 then
											-- print("AAA BBB")
											-- if tot_from ~= 0 or tot_to ~= 0 then																	--loadout has an eligible time on target
											if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "A")
											and (Debug.Generator.SpySquad and Debug.Generator.SpySquad == unit.name  and  Debug.Generator.SpyTask == task)
											then
												DebuGenTxt = DebuGenTxt.."\n"..("AtoG passe A_06 ".." Befor targetlist Boucle")
											end

											if tot_from == 0 then																				--player is only allowed to start at mission start
												TrackPlayability(unit.player, "tot")															--track playabilty criterium has been met
											end

											local i_timmer01 = 0
											for target_side_name, target_side in pairs(targetlist) do											--iterate through sides in targetlist				
												i_timmer01 = i_timmer01 +1
												if side == target_side_name then																--if the target is hostile
													-- print("AAA BBB CCC")
													local totalTarget = 0
													for target_name, target in pairs(target_side) do
														totalTarget = totalTarget + 1
													end

													local iTarget = 0
													for targetN, target in pairs(target_side) do											--iterate through all hostile targets
														iTarget = iTarget + 1

														local target_name = target.titleName

														-- print("AtoG priority "..tostring(target.priority).." "..tostring(target.titleName))

														if target.inactive ~= true and target.ATO then											--if target is active and should be added to ATO
															if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "A")
															and (Debug.Generator.SpySquad and Debug.Generator.SpySquad == unit.name  and  Debug.Generator.SpyTask == task
															or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == target.titleName ))
															then
																DebuGenTxt = DebuGenTxt.."\n\n"..("AtoG passe A_07 :"..unit.type.." "..target.titleName.." Befor task Condition: "..target.task .." ==? task? "..task.." || "..target_name)
															end

															if target.task == task then															--if target is valid for aircaft-loadout															

																--ajoute la task au loadout du main pour que cette task/support devienne obligatoire

																-- print("AtoG newTaskPerTarget type"..unit.type)
																if camp.newTaskPerTarget then
																	for tableTargetName, targetTask in pairs(camp.newTaskPerTarget) do
																		if tableTargetName == target_name and targetTask.tasks then
																			-- print("AtoG tableTargetName"..tableTargetName)

																			for task, value in pairs(targetTask.tasks) do
																				-- print("    AtoG "..task)

																				if not unit_loadouts[l].support then unit_loadouts[l].support = {} end
																				unit_loadouts[l].support[task] = true
																			end
																		end
																	end
																end


																--check target/loadout attributes
																local loadout_eligible = true																					--boolean if loadout matches any target attributes (default true, because target might have no attributes)
																if target.attributes and target.attributes[1] and target.attributes[1] ~= "" then																					--target has attributes
																	loadout_eligible = false
																	for target_attribute_number, target_attribute in ipairs(target.attributes) do								--Iterate through target attributes																
																		for loadout_attribute_number, loadout_attribute in ipairs(unit_loadouts[l].attributes) do				--Iterate through loadout attributes												

																			if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "A")
																			and (Debug.Generator.SpySquad and Debug.Generator.SpySquad == unit.name  and  Debug.Generator.SpyTask == task
																			or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == target_name ))
																			then
																				DebuGenTxt = DebuGenTxt.."\n"..("AtoG passe A_10b Befor loadout_eligible: target_attribute?: "..tostring(target_attribute).."  || loadout_attribute: "..tostring(loadout_attribute).." || "..target_name.." || "..tostring(unit_loadouts[l].name) )
																			end

																			if target_attribute == loadout_attribute then														--if match is found													
																				loadout_eligible = true																			--set variable true
																				break																							--break the loadout attributes iteration
																			end
																		end
																	end
																end

																-- if Debug.Generator.SpySquad == unit.name then print() print("Passa AA loadout_eligible: "..tostring(loadout_eligible)) print() end


																if target.attributes and target.attributes[1] and target.attributes[1] ~= "" then
																	-- if Debug.Generator.SpySquad == unit.name then print("Passa A "..target.name) end

																	for tgt_attributeN, target_attribute in ipairs(target.attributes) do
																		-- if Debug.Generator.SpySquad == unit.name then print("Passa B "..target_attribute) end

																		if target_attribute == "Helicopter" and IsHelicopter[unit.type] then
																			-- if Debug.Generator.SpySquad == unit.name then print("Passa C "..target_attribute) end

																			if #target.attributes == 1 then
																				loadout_eligible = true
																				break
																			end
																		elseif target_attribute == "Helicopter" and not IsHelicopter[unit.type] then

																			-- if Debug.Generator.SpySquad == unit.name then print("Passa D "..target_attribute) end

																			loadout_eligible = false
																			break

																		elseif target_attribute == "Plane" and not IsHelicopter[unit.type] then

																			-- if Debug.Generator.SpySquad == unit.name then print("Passa E "..target_attribute) end

																			if #target.attributes == 1 then
																				loadout_eligible = true
																				break
																			end
																		elseif target_attribute == "Plane" and IsHelicopter[unit.type] then

																			-- if Debug.Generator.SpySquad == unit.name then print("Passa F "..target_attribute) end

																			loadout_eligible = false
																			break

																		end
																	end
																end

																-- if Debug.Generator.SpySquad == unit.name then print("Passa G loadout_eligible: "..tostring(loadout_eligible)) print() end

																if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "A")
																and (Debug.Generator.SpySquad and Debug.Generator.SpySquad == unit.name  and  Debug.Generator.SpyTask == task
																or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == target_name ))
																then
																	DebuGenTxt = DebuGenTxt.."\n"..("AtoG passe A_10c Befor Condition loadout_eligible?: "..tostring(loadout_eligible).." || "..target_name)
																end

																if loadout_eligible then
																--continue if loadout is eligible

																	if ( (task == "Intercept" and target.base == unit.base) or (task == "SAR" and target.base == unit.base) ) or (task == "Transport" and target.base == unit.base) or (task == "Nothing" and target.base == unit.base) or (task ~= "Intercept" and task ~= "Transport" and task ~= "Nothing" and task ~= "SAR") then	--intercept and transport missions are only assigned to units of a certain base as per targetlist	
																		TrackPlayability(unit.player, "target")																							--track playabilty criterium has been met
																		if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "A")
																		and (Debug.Generator.SpySquad and Debug.Generator.SpySquad == unit.name  and  Debug.Generator.SpyTask == task
																		or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == target_name ))
																		then
																			DebuGenTxt = DebuGenTxt.."\n"..("AtoG passe A_11 MultiPlayerOveRide? "..tostring(MultiPlayerOveRide).." Befor firepower Condition".." || "..target_name
																			.." "..unit.type
																			.." firepower.min? "..target.firepower.min
																			.." <= aircraft_available: ".. aircraft_available
																			.." * firepower "..unit_loadouts[l].firepower
																			)
																		end

																		if target.firepower.min <= aircraft_available * unit_loadouts[l].firepower or MultiPlayerOveRide then				--enough aircraft are available to satisfy minimum firepower requirement of target	
																			if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "A")
																			and (Debug.Generator.SpySquad and Debug.Generator.SpySquad == unit.name  and  Debug.Generator.SpyTask == task
																			or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == target_name ))
																			then
																				DebuGenTxt = DebuGenTxt.."\n"..("AtoG passe A_12  Befor weather Condition || overRideReady: "..tostring(overRideReady).." || "..target_name)
																			end

																			TrackPlayability(unit.player, "target_firepower")																			--track playabilty criterium has been met
																			--check weather
																			local weather_eligible = true
																			if mission.weather["clouds"]["density"] > 8 then																				--overcast clouds
																				if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "A")
																				and (Debug.Generator.SpySquad and Debug.Generator.SpySquad == unit.name  and  Debug.Generator.SpyTask == task
																				or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == target_name ))
																				then
																					DebuGenTxt = DebuGenTxt.."\n"..("AtoG passe A_13a "..unit_loadouts[l].loadout_name.." After weather Condition "..target_name)
																				end

																				local cloud_base = mission.weather["clouds"]["base"]
																				local cloud_top = mission.weather["clouds"]["base"] + mission.weather["clouds"]["thickness"]
																				if db_airbases[unit.base].elevation + 333 > cloud_base then																--cloud base is less than 1000 ft above airbase elevation
																					if unit_loadouts[l].adverseWeather == false then																		--loadout is not adverse weather capable
																						weather_eligible = false																							--not eligible for this weather
																					end
																				else
																					if unit_loadouts[l].hCruise and unit_loadouts[l].hCruise > cloud_base and unit_loadouts[l].hCruise < cloud_top then			--cruise alt is in the clouds
																						if unit_loadouts[l].adverseWeather == false then																	--loadout is not adverse weather capable
																							weather_eligible = false																						--not eligible for this weather
																						end
																					elseif unit_loadouts[l].hAttack and unit_loadouts[l].hAttack > cloud_base and unit_loadouts[l].hAttack < cloud_top then		--attack alt is in the clouds
																						if unit_loadouts[l].adverseWeather == false then																	--loadout is not adverse weather capable
																							weather_eligible = false																						--not eligible for this weather
																						end
																					end

																					if task == "Strike" or task == "Anti-ship Strike" or task == "Reconnaissance" then										--extra requirement for A-G tasks
																						if unit_loadouts[l].hAttack > cloud_base then																		--attack alt is above cloud base
																							if unit_loadouts[l].adverseWeather == false then																--loadout is not adverse weather capable
																								weather_eligible = false																					--not eligible for this weather
																							end
																						end
																					end
																				end
																			end
																			if mission.weather["enable_fog"] == true then															--fog
																				if db_airbases[unit.base].elevation < mission.weather["fog"]["thickness"] then					--base elevation in fog
																					if mission.weather["fog"]["visibility"] < 5000 then												--less than 5000m visibility
																						if unit_loadouts[l].adverseWeather == false then											--loadout is not adverse weather capable
																							weather_eligible = false																--not eligible for this weather
																						end
																					end
																				end
																			end

																			--selectionne une escadrille CSAR la plus proche de l'EjectedPilot
																			local proxiCSAR = true
																			if task == "CSAR" and target.selectedUnitSAR ~= "" then
																				if unit.name ~= target.selectedUnitSAR then
																					proxiCSAR = false
																					if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "A")
																					and (Debug.Generator.SpySquad and Debug.Generator.SpySquad == unit.name  and  Debug.Generator.SpyTask == task
																					or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == target_name ))
																					then
																						DebuGenTxt = DebuGenTxt.."\n"..("AtoG passe A_13b ".." proxiCSAR "..tostring(proxiCSAR).." ".. unit.name.." selectedUnitSAR: "..target.selectedUnitSAR)
																					end
																				end
																			end



																			if (weather_eligible and proxiCSAR) or overRideReady then																				--continue of this loadout is eligible for weather
																				if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "A")
																				and (Debug.Generator.SpySquad and Debug.Generator.SpySquad == unit.name  and  Debug.Generator.SpyTask == task
																				or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == target_name ))
																				then
																					DebuGenTxt = DebuGenTxt.."\n"..("AtoG passe A_14 ".." After weather_eligible Condition "..target_name)
																				end

																				TrackPlayability(unit.player, "weather")															--track playabilty criterium has been met

																				--get airbase position
																				local airbasePoint = {																				--get the x-y coordinates of the airbase where the unit is located
																					x = db_airbases[unit.base].x,
																					y = db_airbases[unit.base].y,
																					h = db_airbases[unit.base].elevation,
																					BaseAirStart = db_airbases[unit.base].BaseAirStart
																				}

																				local multipack = 1
																				if target.firepower.packmax  then	--and unit_loadouts[l].MaxAttackOffset								--target has a requirement for multiple packages and loadout is multipack capable (defined maximum attack offset)
																					multipack = target.firepower.packmax															--create draft sorties for this target for the requested amount of packages
																				end

																				for r = 1, multipack do																				--repeat draft sortie generation for the requirement amount of packages (may create different routes each time)
																					if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "A")
																					and (Debug.Generator.SpySquad and Debug.Generator.SpySquad == unit.name  and  Debug.Generator.SpyTask == task
																					or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == target_name ))
																					then
																						DebuGenTxt = DebuGenTxt.."\n"..("AtoG passe A_15 multipack "..tostring(multipack).." FOR multipack Boucle "..target_name)
																					end

																					--determine route variants depending on Daytime
																					local variant
																					if Daytime == "day" then
																						variant = 1
																					elseif Daytime == "night" then
																						variant = 2
																					elseif Daytime == "night-day" then
																						variant = 3
																					elseif Daytime == "day-night" then
																						variant = 4
																					end

																					if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "A")
																					and (Debug.Generator.SpySquad and Debug.Generator.SpySquad == unit.name  and  Debug.Generator.SpyTask == task
																					or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == target_name ))
																					then
																						DebuGenTxt = DebuGenTxt.."\n"..("AtoG passe A_16 "..tostring(variant).." "..tostring(Daytime).." Befor variant Condition "..target_name)
																					end

																					while variant > 0 do
																						draftId = draftId + 1
																						if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "A")
																						and (Debug.Generator.SpySquad and Debug.Generator.SpySquad == unit.name  and  Debug.Generator.SpyTask == task
																						or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == target_name ))
																						then
																							DebuGenTxt = DebuGenTxt.."\n"..("AtoG passe A_28 ".." After variant Condition "..target_name)
																						end

																						i_timmer01 = i_timmer01 +1
																						if i_timmer01 >= 10  then io.write(".") i_timmer01 = 0 end
																						--determine route
																						status_counter_sorties = status_counter_sorties + 1													--status report

																						local route = {}

																						if task == "Intercept" then																			--intercept task only get a stub route
																							route = {
																								[1] = {
																									['y'] = airbasePoint.y,
																									['x'] = airbasePoint.x,
																									['alt'] = 0,
																									['id'] = 'Intercept',
																								},
																								threats = {
																									SEAD_offset = 0,
																									ground_total = 0.5,
																									air_total = 0.5
																								},
																								['lenght'] = target.radius * 2,																--interception task radius *2 because below it is compared with range *2
																							}
																						elseif task == "SAR" then																			--intercept task only get a stub route
																							route = {
																								[1] = {
																									['y'] = airbasePoint.y,
																									['x'] = airbasePoint.x,
																									['alt'] = 0,
																									['id'] = 'SAR',
																								},
																								threats = {
																									SEAD_offset = 0,
																									ground_total = 0.5,
																									air_total = 0.5
																								},
																								['lenght'] = target.radius * 2,																--interception task radius *2 because below it is compared with range *2
																							}
																						else																								--all other tasks than intercept
																							local ToTarget = 9999999
																							if not airbasePoint.x then print("AtoG No Airbase position "..tostring(unit.base)) os.execute 'pause' end
																							if not target.x then
																								-- print("AtoG No target position "..tostring(target_name)) os.execute 'pause' 
																							else
																								ToTarget = GetDistance(airbasePoint, target)												--direct distance to target
																							end


																							if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "A")
																							and (Debug.Generator.SpySquad and Debug.Generator.SpySquad == unit.name  and  Debug.Generator.SpyTask == task
																							or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == target_name ))
																							then
																								DebuGenTxt = DebuGenTxt.."\n"..("AtoG passe A_28b "..tostring(ToTarget).." || LoadoutUnitRange: "..tostring(unit_loadouts[l].range).." "..tostring(unit_loadouts[l].name))
																								DebuGenTxt = DebuGenTxt.."\n"..("______________ToTarget "..tostring(ToTarget).." <=? "..tostring(unit_loadouts[l].range))
																								DebuGenTxt = DebuGenTxt.."\n"..("______________minrange? "..tostring(unit_loadouts[l].minrange))
																								DebuGenTxt = DebuGenTxt.."\n"..("______________ToTarget * 1.5 "..tostring(ToTarget * 1.5).." >? "..tostring(unit_loadouts[l].minrange))
																								-- DebugRoute = true
																							end

																							-- print("                    AtoG ToTarget "..tostring(ToTarget).." <=?? unit_loadouts[l].range: "..tostring(unit_loadouts[l].range) )
																							if ToTarget <= unit_loadouts[l].range and (unit_loadouts[l].minrange == nil or ToTarget * 1.5 > unit_loadouts[l].minrange) then	--basic feasibility check of range before performance intensive route calculations are done
																								-- print("                    AtoG variant" )
																								if variant == 1 or variant == 4 then
																									-- print("                    AtoG _1_4_route" )
																									route = GetRoute(airbasePoint, target, unit_loadouts[l], enemy, task, "day", r, multipack, unit, draftId)	or {}		--get the best route to this target at day-- modification M06 : helicopter playable(ajout variable helico pour generer une route )
																									-- print("                    AtoG      route_1_4_" )
																								elseif variant == 2 or variant == 3 then
																									-- print("                    AtoG _2_3_route" )
																									route = GetRoute(airbasePoint, target, unit_loadouts[l], enemy, task, "night", r, multipack, unit)	or {}	--get the best route to this target at night-- modification M06 : helicopter playable
																									-- print("                    AtoG      route_2_3_" )
																								end
																							end

																							DebugRoute = false
																						end

																						local altiPass = true
																						if 	unit_loadouts[l].hHover and target.z and target.z > unit_loadouts[l].hHover 	then
																							altiPass = false
																						end


																						if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "A")
																						and (Debug.Generator.SpySquad and Debug.Generator.SpySquad == unit.name  and  Debug.Generator.SpyTask == task
																						or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == target_name ))
																						then
																							DebuGenTxt = DebuGenTxt.."\n"..("AtoG passe A_28d ")
																							DebuGenTxt = DebuGenTxt.."\n"..("______________route.lenght "..tostring(route.lenght).." <=? "..tostring(unit_loadouts[l].range * 2))
																							DebuGenTxt = DebuGenTxt.."\n"..("______________minrange? "..tostring(unit_loadouts[l].minrange))
																							DebuGenTxt = DebuGenTxt.."\n"..("______________route.lenght "..tostring(route.lenght).." >? "..tostring(unit_loadouts[l].minrange).." *2")
																							DebuGenTxt = DebuGenTxt.."\n"..("______________altiPass? "..tostring(altiPass))
																							DebuGenTxt = DebuGenTxt.."\n"..("______________altiPass? target.z "..tostring(target.z).." >? hHover "..tostring(unit_loadouts[l].hHover))
																						end

																						if route and route.lenght and route.lenght <= unit_loadouts[l].range * 2 and (unit_loadouts[l].minrange == nil or route.lenght > unit_loadouts[l].minrange * 2) and altiPass then		--if sortie route lenght is within range of aircraft-loadout
																							if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "A")
																							and (Debug.Generator.SpySquad and Debug.Generator.SpySquad == unit.name  and  Debug.Generator.SpyTask == task
																							or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == target_name ))
																							then
																								DebuGenTxt = DebuGenTxt.."\n"..("AtoG passe A_29 ".." After Range Condition | firepower.max: "..tostring(target.firepower.max).." / loadoutFirepower "..tostring(unit_loadouts[l].firepower))
																							end

																							TrackPlayability(unit.player, "target_range")												--track playabilty criterium has been met

																							--determine number of aircraft needed for sortie
																							-- local aircraft_requested = target.firepower.max / unit_loadouts[l].firepower
																							-- local aircraft_requested = target.firepower.min / unit_loadouts[l].firepower					--how many aircraft are needed to satisfy the maximum firepower requirement of the target

																							-- print("min: "..tostring(target.firepower.min) .. " "..tostring(target.firepower.max))

																							local aircraft_requested = GetWeightedRandom(target.firepower.min, target.firepower.max, bias)
																							-- print(string.format("Valeur générée : %.2f", aircraft_requested))

																							if task == "Transport" then
																								if multiPlaneSet and multiPlaneSet[side] and multiPlaneSet[side][unit.type]  and multiPlaneSet[side][unit.type][task]
																								and task_bool
																								and aircraft_requested <  multiPlaneSet[side][unit.type][task].NbPlane
																								and task == "Transport"
																								then
																									aircraft_requested =  multiPlaneSet[side][unit.type][task].NbPlane
																									if aircraft_requested > 4 then aircraft_requested = 4 end
																								end
																							elseif task == "Strike" and aircraft_requested < 2 and aircraft_requested < 2  then
																								aircraft_requested = 2

																							end

																							local flights_requested
																							if  task == "AWACS" or task == "Refueling" or task == "AFAC" then									--multiple flights are required to continously cover a station for the duration of the mission
																								if not unit_loadouts[l].tStation then print("this variable <<tStation>> is missing  in this aircraft's "..task.." loadout "..unit.type) os.execute 'pause' end	
																								flights_requested = math.ceil((tot_to - tot_from) / unit_loadouts[l].tStation) + 1			--how many flights are needed to keep continous coverage of station, plus 1 for on station before mission start
																								aircraft_requested = aircraft_requested * flights_requested									--total number of requested aircraft is number of aircraft needed to statisfy firepower requirement of station * number of flights needed for continous coverage
																							end
																							if task == "CAP"  then									--multiple flights are required to continously cover a station for the duration of the mission
																								if not unit_loadouts[l].tStation then print("this variable <<tStation>> is missing in this aircraft's "..task.." loadout "..unit.type) os.execute 'pause' end
																							
																								local station = unit_loadouts[l].tStation * 0.75
																								flights_requested = math.ceil((tot_to - tot_from) / station)
																								aircraft_requested = aircraft_requested * flights_requested									--total number of requested aircraft is number of aircraft needed to statisfy firepower requirement of station * number of flights needed for continous coverage

																								if aircraft_requested < 2  then
																									aircraft_requested = 2
																								end

																							end

																							if task == "AWACS" or task == "Refueling" or task == "Transport" or task == "Nothing" or task == "Reconnaissance" or task == "AFAC" then
																								aircraft_requested = math.ceil(aircraft_requested)
																							-- elseif (unit.type == "S-3B" or unit.type == "F-117A" or unit.type == "B-1B" or unit.type == "B-52H" or unit.type == "Tu-22M3" or unit.type == "Tu-95MS" or unit.type == "Tu-142" or unit.type == "Tu-160" or unit.type == "MiG-25RBT")
																							-- 	and task ~= "Runway Attack"	then
																							-- 	aircraft_requested = math.ceil(aircraft_requested)	
																							elseif (Data_divers[unit.type] and Data_divers[unit.type].flyingAlone) and task ~= "Runway Attack"	then

																								aircraft_requested = math.ceil(aircraft_requested)
																							else
																								--aircraft_requested = math.ceil(aircraft_requested / 2) * 2								--round up to an even number
																								aircraft_requested = math.ceil(aircraft_requested)
																							end

																							local aircraft_assign
																							if aircraft_requested > aircraft_available then													--if more aircraft are requested than are available from this unit
																								aircraft_assign = math.floor(aircraft_available)														--assign all available aircraft
																							else																							--enough available aircraft to satisfy requested aircraft
																								aircraft_assign = math.floor(aircraft_requested)														--assign all requested aicraft
																							end

																							--garde en memoire remainingFirepower pour ajouter (ou non) un strike support
																							--
																							local remainingFirepower = target.firepower.max - ( unit_loadouts[l].firepower * aircraft_assign)
																							if remainingFirepower < 0 then remainingFirepower = 0 end

																							local debugMulti = ""
																							MultiPlayerOveRide = false
																							-- modification M11.o multiplayer
																							if multiPlaneSet then
																								debugMulti = debugMulti.."\n"..("AtoG passe A_AAb "..tostring(task).." "..unit.type.." aircraft_assign:"..tostring(aircraft_assign))

																								if multiPlaneSet[side] and multiPlaneSet[side][unit.type]  and multiPlaneSet[side][unit.type][task] and task_bool then
																									if Multi.Target and Multi.Target[side] then
																										debugMulti = debugMulti.."\n"..("AtoG passe A_AAe Multi.Target[side] "..tostring(Multi.Target[side]) .. " ==? target_name? " .. tostring(target_name))
																										if Multi.Target[side] == target_name  then
																											debugMulti = debugMulti.."\n"..("AtoG passe A_AAf Multi.Target[side] "..tostring(Multi.Target[side]) .. " ==? target_name? " .. tostring(target_name).." "..unit.type.." "..tostring(task))
																											MultiPlayerOveRide = true
																										end
																									else
																										debugMulti = debugMulti.."\n"..("AtoG passe A_AAg  " .. " ==? target_name? " .. tostring(target_name).." "..unit.type.." "..tostring(task))

																										Multi.Target = {}
																										Multi.Target[side] = target_name
																										MultiPlayerOveRide = true
																									end

																									--TODO a regarder si c'etait utile
																									if aircraft_assign > 4 and ( task == "CAP" ) then --or task == "Intercept"
																										aircraft_assign = 4
																									end

																									--M11.z
																									if MultiPlayerOveRide and aircraft_assign < multiPlaneSet[side][unit.type][task].NbPlane then
																										aircraft_assign = multiPlaneSet[side][unit.type][task].NbPlane
																										debugMulti = debugMulti.."\n"..("AtoG passe A_AAh "..unit.type.." aircraft_assign: "..tostring(aircraft_assign))
																									end
																									ClientPlayer = true
																								end
																							end

																							if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "A")
																							and  Debug.Generator.SpySquad and (Debug.Generator.SpySquad and Debug.Generator.SpySquad == unit.name  and  Debug.Generator.SpyTask == task
																							or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == target_name ))
																							then
																								DebuGenTxt = DebuGenTxt.."\n"..debugMulti
																							end


																							--self escort
																							if unit_loadouts[l].self_escort then															--if the loadout is capable of self-escort
																								route.threats.air_total = route.threats.air_total / 2										--reduce the fighter threat by half
																								if route.threats.air_total < 0.5 then
																									route.threats.air_total = 0.5
																								end
																							end

																							--build sortie entry
																							repeat																							--for tasks with station repeat to make entries for lesser amount of aircraft, repeat once for everything else
																								local idTemp = "id"..#Draft_sorties[side]+1

																								if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "A")
																								and (Debug.Generator.SpySquad and Debug.Generator.SpySquad == unit.name  and  Debug.Generator.SpyTask == task
																								or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == target_name ))
																								then
																									DebuGenTxt = DebuGenTxt.."\n"..("AtoG passe A_30a "..idTemp.." ClientPlayer: "..tostring(ClientPlayer) .. " MultiPlayerOveRide: " .. tostring(MultiPlayerOveRide).." idTemp: "..tostring(idTemp).." aircraft_assign: "..tostring(aircraft_assign))
																								end

																								local Draft_sorties_entry = {
																									name = unit.name,
																									playable = ClientPlayer, 					--unit.player,
																									type = unit.type,
																									modification = unit.modification,
																									callsign = unit.callsign,
																									callsignId = unit.callsignId,
																									helicopter = unit.helicopter,
																									number = aircraft_assign,
																									flights = flights_requested,
																									country = unit.country,
																									livery = unit.livery,
																									sidenumber = unit.sidenumber,
																									liveryModex = unit.liveryModex,
																									base = unit.base,
																									airdromeId = db_airbases[unit.base].airdromeId,
																									parking_id = unit.parking_id,
																									skill = unit.skill,
																									task = task,
																									tasks = unit.tasks,
																									loadout = unit_loadouts[l],
																									target = Deepcopy(target),
																									target_name = target.titleName,
																									targetPriority = target.priority,
																									route = route,
																									tot_from = tot_from,
																									tot_to = tot_to,
																									support = {
																										["Escort"] = {},
																										["SEAD"] = {},
																										["Escort Jammer"] = {},
																										["Flare Illumination"] = {},
																										["Laser Illumination"] = {},
																										["Strike"] = {},
																										},
																									multipack = multipack,
																									threatsGround = route.threats.ground_total,
																									threatsAir = route.threats.air_total,
																									id = "DraftId"..draftId.."_id"..#Draft_sorties[side]+1,
																									rejected = {},
																									MainMPOveRide = MultiPlayerOveRide,
																									remainingFirepower = remainingFirepower,
																									multiPlaneSet_B  = multiPlaneSet,
																									priorityIni = target.priority,
																								}


																								Draft_sorties_entry.target.titleName =  target_name													-- ATO_G_Debug04 correction targetName

																								--score the sortie
																								Draft_sorties_entry.scoreAdd = 0.000011
																								Draft_sorties_entry.scoreCoef = 1

																								local route_threat = route.threats.ground_total + route.threats.air_total						--combine route ground and air threat
																								if task == "CAP" or task == "Intercept" or task == "SAR" then
																									Draft_sorties_entry.score = target.priority	-- unit_loadouts[l].capability *				--route threat does not matter for CAP and intercept
																								else
																									Draft_sorties_entry.score =  target.priority / route_threat	--unit_loadouts[l].capability *	--calculate the score to measure the importance of the sortie
																								end

																								-- if route.threats.SEAD_offset == 0 then
																								-- 	Draft_sorties_entry.score = Draft_sorties_entry.score + 4
																								-- end

																								if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "A")
																								and (Debug.Generator.SpySquad and Debug.Generator.SpySquad == unit.name  and  Debug.Generator.SpyTask == task
																								or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == target_name ))
																								then
																									DebuGenTxt = DebuGenTxt.."\n"..("AtoG passe A_30b: " .. idTemp.." score: "..tostring(Draft_sorties_entry.score).." *T_priority "..tostring(target.priority).." /threat "..tostring(route_threat)
																									.." (ground_total "..route.threats.ground_total.." + air_total:"..route.threats.air_total.." )")
																								end

																								local reduce_score = 0																		--factor to reduce score for station missions with less aircraft than required to cover station
																								if task == "CAP" then																		--station tasks with flights of 2
																									-- reduce_score = flights_requested - aircraft_assign / math.ceil(target.firepower.max / unit_loadouts[l].firepower) --increase factor by one for each flight that is missing
																								elseif task == "AWACS" or task == "Refueling" or task == "AFAC"  then											--station tasks with flights of 1
																									reduce_score = flights_requested - aircraft_assign										--increase factor by one for each flight that is missing

																								end
																								Draft_sorties_entry.score = Draft_sorties_entry.score - reduce_score * 0.01					--reduce score slighthly for station missions with less aircraft than required to cover station
																								Draft_sorties_entry.scoreAdd =  Draft_sorties_entry.scoreAdd + reduce_score * 0.01

																								-- tasks = {
																								-- 	Strike = true,
																								-- 	SEAD = false,
																								-- 	["Anti-ship Strike"] = true,
																								-- 	["Runway Attack"] = true,
																								-- },--A 4 3
																								-- tasksCoef = {
																								-- 	Strike = 3,
																								-- 	SEAD = 1,
																								-- 	["Laser Illumination"] = 1,
																								-- 	Intercept = 1,
																								-- 	CAP = 0.2,
																								-- 	Escort = 0.5,
																								-- 	["Fighter Sweep"] = 0.2,
																								-- 	["Anti-ship Strike"] = 2,
																								-- 	["Runway Attack"] = 1,
																								-- },--A 4 3

																								--ATO_G_adjustment02
																								if unit.tasksCoef and unit.tasksCoef[task] then

																									local buildCoef = false
																									if unit.tasksCoefPourcent and not unit.tasksCoefPourcent[task] then
																										buildCoef = true
																									end

																									if not  unit.tasksCoefPourcent or buildCoef then


																										local minValue = 999999
																										local maxValue = -999999

																										for taskName, taskValue in pairs(unit.tasks) do
																											if taskValue and unit.tasksCoef[taskName] then
																												if minValue > unit.tasksCoef[taskName] then
																													minValue = unit.tasksCoef[taskName]
																												end
																												if maxValue < unit.tasksCoef[taskName] then
																													maxValue = unit.tasksCoef[taskName]
																												end
																											end
																										end

																										-- 3 -> 100
																										-- 0.1 -> 1
																										--
																										-- y = ax + b
																										--coef direc coefficient directeur = ( 1 − 100 ) / ( 0.3 − 3 )


																										-- print("AtoG task "..task)
																										-- _affiche(unit.tasks, "unit.tasks")
																										-- _affiche(unit.tasksCoef, "unit.tasksCoef")

																										local tasksCoefPourcent = 1
																										if minValue-maxValue ~= 0 then
																											-- print("AtoG minValue "..tostring(minValue).." maxValue "..tostring(maxValue))
																											local coefDir = (50-100) / (minValue-maxValue)

																											--k = 100 − 36.666666666667 × 3
																											local k = 100 - coefDir * maxValue
																											-- print("AtoG coefDir "..tostring(coefDir).." k "..tostring(k))

																											--y = 36.666666666667x − 10
																											tasksCoefPourcent = coefDir * unit.tasksCoef[task] + k

																										end

																										if not unit.tasksCoefPourcent then unit.tasksCoefPourcent = {} end
																										if not unit.tasksCoefPourcent[task] then unit.tasksCoefPourcent[task] = {} end
																										unit.tasksCoefPourcent[task] = tasksCoefPourcent

																										-- print("AtoG tasksCoefPourcent "..tostring(tasksCoefPourcent))

																										-- os.execute 'pause'

																									end

																									local randomCoef = math.random(1,100)

																									if unit.tasksCoefPourcent[task] <= randomCoef then
																										-- Draft_sorties_entry.score idem
																									else
																										Draft_sorties_entry.score = Draft_sorties_entry.score * (unit.tasksCoefPourcent[task] / 100)
																										Draft_sorties_entry.scoreCoef =  Draft_sorties_entry.scoreCoef * (unit.tasksCoefPourcent[task] / 100)
																									end

																									-- Draft_sorties_entry.score = Draft_sorties_entry.score * unit.tasksCoef[task]	
																									-- Draft_sorties_entry.scoreCoef =  Draft_sorties_entry.scoreCoef * unit.tasksCoef[task]

																								end

																								if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "A")
																								and (Debug.Generator.SpySquad and Debug.Generator.SpySquad == unit.name  and  Debug.Generator.SpyTask == task
																								or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == target_name ))
																								then
																									DebuGenTxt = DebuGenTxt.."\n"..("AtoG passe A_30d: " ..idTemp.." score: ".. tostring(Draft_sorties_entry.score).." "..unit.type.." "..tostring(task))
																								end

																								--augmente le score si l armement a une allonge, comme demandé par la cible
																								--target SA-2 45000
																								--loadoutStandoff 60000 JSAW
																								local DebuGenTxtTemp = ""
																								if unit_loadouts[l].standoff and target.range and unit_loadouts[l].standoff > 0 and target.range >0 then
																									-- print("AtoG AA.score __"..Draft_sorties_entry.score.."__ "..target.name)
																									-- print("AtoG 				AA1.range "..target.range.." standoff: "..unit_loadouts[l].standoff.." a/b "..tostring(target.range / unit_loadouts[l].standoff).." 1/: "..tostring(1/(target.range / unit_loadouts[l].standoff)))

																									DebuGenTxtTemp = "\n".."AtoG AA.score __"..Draft_sorties_entry.score.."__ "..target.name .."\n"
																									DebuGenTxtTemp = DebuGenTxtTemp .. "AtoG 				AA1 target.range "..target.range.." standoff: "..unit_loadouts[l].standoff.." a/b "..tostring(target.range / unit_loadouts[l].standoff).." 1/: "..tostring(1/(target.range / unit_loadouts[l].standoff)) .."\n"

																									local standOffCoef =  1/(target.range / unit_loadouts[l].standoff) * 10
																									if standOffCoef < 0.01 then
																										standOffCoef = 0.01
																									elseif standOffCoef > 100 then
																										standOffCoef = 100
																									end

																									Draft_sorties_entry.score = Draft_sorties_entry.score * standOffCoef
																									Draft_sorties_entry.scoreCoef =  Draft_sorties_entry.scoreCoef * standOffCoef
																									-- Draft_sorties_entry.scoreAdd =  Draft_sorties_entry.scoreAdd + 1000

																									-- print("AtoG BB.score__"..Draft_sorties_entry.score.."__ "..unit_loadouts[l].name)
																									DebuGenTxtTemp = DebuGenTxtTemp .."AtoG BB.score__"..Draft_sorties_entry.score.."__ "..unit_loadouts[l].name .."\n"
																								end

																								-- modification M11.q multiplayer

																								if multiPlaneSet[side] and  multiPlaneSet[side][unit.type] and  multiPlaneSet[side][unit.type][task] and task_bool and  multiPlaneSet[side][unit.type][task].NbPlane > 0 then
																									Draft_sorties_entry.score = Draft_sorties_entry.score + 1000
																									Draft_sorties_entry.scoreAdd =  Draft_sorties_entry.scoreAdd + 1000
																									if MultiPlayerOveRide then

																										-- Draft_sorties_entry.score = Draft_sorties_entry.score * 2 +1000
																										-- Draft_sorties_entry.scoreCoef =  Draft_sorties_entry.scoreCoef * 2
																										-- Draft_sorties_entry.scoreAdd =  Draft_sorties_entry.scoreAdd + 1000

																										Draft_sorties_entry.score = Draft_sorties_entry.score * 1.2 +1000
																										Draft_sorties_entry.scoreCoef =  Draft_sorties_entry.scoreCoef * 1.2
																										Draft_sorties_entry.scoreAdd =  Draft_sorties_entry.scoreAdd + 1000

																									end
																								-- elseif Multi.Target and Multi.Target[side] == target_name  then
																								-- 	Draft_sorties_entry.score = Draft_sorties_entry.score * 2
																								-- 	Draft_sorties_entry.scoreCoef =  Draft_sorties_entry.scoreCoef * 2
																								end

																								--augmente de 10% le score si l'avion peut etre joué
																								if unit.player then
																									Draft_sorties_entry.score = Draft_sorties_entry.score * 1.2
																									-- Draft_sorties_entry.scoreAdd =  Draft_sorties_entry.scoreAdd + 1000
																									Draft_sorties_entry.scoreCoef =  Draft_sorties_entry.scoreCoef * 1.2
																								end

																								if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "A")
																								and (Debug.Generator.SpySquad and Debug.Generator.SpySquad == unit.name  and  Debug.Generator.SpyTask == task
																								or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == target_name ))
																								then
																									DebuGenTxt = DebuGenTxt..DebuGenTxtTemp.."\n"..("AtoG passe A_30e: " ..idTemp.." score: ".. tostring(Draft_sorties_entry.score).." "..unit.type.." "..tostring(task))
																								end

																								-- --insert sortie entry into Draft_sorties table sorted by score (highest first)
																								-- if #Draft_sorties[side] == 0 then															--if Draft_sorties table is empty
																								-- 	-- table.insert(Draft_sorties[side], Draft_sorties_entry)
																								-- 	Draft_sorties[side][#Draft_sorties[side]+1] = Draft_sorties_entry
																								-- else
																								-- 	for d = 1, #Draft_sorties[side] do														--iterate through Draft_sorties
																								-- 		if Draft_sorties_entry.score > Draft_sorties[side][d].score then					--score is bigger than current table entry
																								-- 			-- table.insert(Draft_sorties[side], d, Draft_sorties_entry)						--insert at current position in table
																								-- 			Draft_sorties[side][#Draft_sorties[side]+1] = Draft_sorties_entry
																								-- 			break
																								-- 		elseif Draft_sorties_entry.score == Draft_sorties[side][d].score then				--score is same as current table entry
																								-- 			local sum = 1
																								-- 			for s = d + 1, #Draft_sorties[side] do											--iterate through subsequent table entries
																								-- 				if Draft_sorties_entry.score == Draft_sorties[side][s].score then			--if these entries also have the same score
																								-- 					sum = sum + 1															--sum them
																								-- 				else
																								-- 					break
																								-- 				end
																								-- 			end
																								-- 			table.insert(Draft_sorties[side], d + math.random(0, sum), Draft_sorties_entry)	--insert random position position in table
																								-- 			-- Draft_sorties[side][d + math.random(0, sum)] = Draft_sorties_entry
																								-- 			break
																								-- 		elseif d == #Draft_sorties[side] then												--if end of table is reached
																								-- 			-- Draft_sorties_entry["id"] = "id"..#Draft_sorties[side]+1
																								-- 			Draft_sorties[side][#Draft_sorties[side]+1] = Draft_sorties_entry
																								-- 		end
																								-- 	end
																								-- end

																								-- Ajouter à la fin de la table Draft_sorties[side]
																								Draft_sorties[side] = Draft_sorties[side] or {} -- Initialisez si nécessaire
																								Draft_sorties[side][#Draft_sorties[side] + 1] = Draft_sorties_entry


																								if  task == "AWACS" or task == "Refueling" or task == "AFAC"  then--task == "CAP" or
																									aircraft_assign = aircraft_assign - 1													--make additional draft sortie for lesser amount of aircraft
																								elseif MultiPlayerOveRide then
																									aircraft_assign = aircraft_assign - 4
																								else
																									aircraft_assign = 0																		--do not make additional draft sorties
																								end

																								if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "A")
																								and (Debug.Generator.SpySquad and Debug.Generator.SpySquad == unit.name  and  Debug.Generator.SpyTask == task
																								or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == target_name ))
																								then
																									DebuGenTxt = DebuGenTxt.."\n"..("AtoG passe A_30_INIT : "..idTemp.." aircraft_assign "..aircraft_assign)
																								end

																							until aircraft_assign <= 0																		--stop making more draft sorties
																						end

																						variant = variant - 2																			--determines if while-loop does another route variant depending on Daytime
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
							end
						end
					-- end
				end
			end
		end
	end
end

print("-")
print("ATO Generating Sortie (" .. status_counter_sorties .. ") - Complete")
DebuGenTxt = DebuGenTxt.."\n"..("ATO Generating Sortie (" .. status_counter_sorties .. ") - Complete")

local shuffled = {}
for i, v in ipairs(oob_air["blue"]) do
	local pos = math.random(1, #shuffled+1)
	table.insert(shuffled, pos, v)
end
oob_air["blue"] = shuffled

shuffled = {}
for i, v in ipairs(oob_air["red"]) do
	local pos = math.random(1, #shuffled+1)
	table.insert(shuffled, pos, v)
end
oob_air["red"] = shuffled



-- Tri final par `targetPriority` (ascendant), puis par `score` (descendant)
for side, sorties in pairs(Draft_sorties) do
    table.sort(sorties, function(a, b)
        if a.targetPriority ~= b.targetPriority then
            return a.targetPriority > b.targetPriority -- Plus petite priorité d'abord
        end
        return a.score > b.score -- Plus grand score d'abord
    end)
end


if Debug.Generator.affiche then

	-- DebuGenTxt = DebuGenTxt.."\n"..("BLUE PART A")

	for sideName, drafts in pairs(Draft_sorties) do
		local di = 1
		DebuGenTxt = DebuGenTxt.."\n\n\n"..(string.upper(sideName).." PART A")

		for draft_n, draft in pairs(drafts) do
			if  di < Debug.Generator.nb or draft.name == Debug.Generator.SpySquad  or draft.target_name == Debug.Generator.SpyTarget then		--if  di < Debug.Generator.nb and string.find(draft.task, "Strike") then
				DebuGenTxt = DebuGenTxt.."\n"..(	"A N° " .. draft_n..
						" /id/ " ..tostring(draft.id)..
						" /Prioriry/ " ..tostring(draft.priorityIni)..
						" /Nb/ " ..draft.number..
						" /flights/ " ..tostring(draft.flights)..
						" /Type/ "..draft.type..
						" /threatsGround/ "..round(draft.threatsGround)..
						" /threatsAir/ "..round(draft.threatsAir)..
						" /Score/ " ..round(draft.score)..
						" /Task/ "..draft.task..
						" /Target/ "..draft.target_name..
						" /Sead_Of/ "..tostring(draft.route.threats.SEAD_offset)..
						" /MainMPOveRide/ " ..tostring(draft.MainMPOveRide)..
						" /remainingFirepower/ " ..draft.remainingFirepower..
						" /multipack/ " ..draft.multipack

						-- .." /loadout/ "..tostring(draft.loadout.loadout_name)
						)
						DebuGenTxt = DebuGenTxt.."\n"

				di = di +1
			end
		end
	end
	DebuGenTxt = DebuGenTxt.."\n"
end

--create additional draft sorties with support flights assigned
local wk = 1
local i_timmer02 = 0
local uniqueBonus = false

--inversion des 2 boucles draft_sortie en premier, oob_air ensuite, pour homogeniser les chances de sortie de tous les escadrons support
for sideName, draftT in pairs(Draft_sorties) do
	-- for draft_n, draft in ipairs(Draft_sorties[sideName]) do													--iterate through all draft sorties beginning with the highest scored
	for draft_n, draft in ipairs(draftT) do

		if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "B")
		and ( Debug.Generator.SpySquad and Debug.Generator.SpySquad == draft.name
		or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == draft.target_name ))
		then
			DebuGenTxt = DebuGenTxt.."\n\n"..(tostring(draft.id).." AtoG II passe B_00 target_name draftType: "..draft.type.." "..tostring(draft.target_name) .." "..tostring(draft.score)  )
		end

		--determine enemy side
		local enemy																						--determine enemy side (opposite of unit side)
		if sideName == "blue" then
			enemy = "red"
		else
			enemy = "blue"
		end

		--rearange aléatoirement les unites pour que ne soit pas toujours les memes
		local shuffled = {}
		for i, v in ipairs(oob_air["blue"]) do
			local pos = math.random(1, #shuffled+1)
			table.insert(shuffled, pos, v)
		end
		oob_air["blue"] = shuffled

		shuffled = {}
		for i, v in ipairs(oob_air["red"]) do
			local pos = math.random(1, #shuffled+1)
			table.insert(shuffled, pos, v)
		end
		oob_air["red"] = shuffled

		--place en premier les unites des joueurs multi

		-- if multiPlaneSet.blue then
		-- 	for o = #oob_air["blue"], 1, -1 do
		-- 		if oob_air["blue"][o] and oob_air["blue"][o].type ==  multiPlaneSet.blue[oob_air["blue"][o].plane] 
		-- 		and oob_air["blue"][o].task ==  multiPlaneSet.blue[oob_air["blue"][o].task]  then	
		-- 			table.remove(oob_air["blue"], o)																		
		-- 		end
		-- 	end
		-- end


		if multiPlaneSet.blue then
			for o = 1, #oob_air["blue"] do
				local oob = oob_air["blue"][o]
				if multiPlaneSet.blue[oob.type] and oob and oob.tasks then
					for taskName, taskValue in pairs(oob.tasks) do
						if taskName == multiPlaneSet.blue.task then
							-- Décaler les éléments de la position 1 à o-1 vers la droite
							table_move(oob_air["blue"], 1, o-1, 2)
							-- Mettre l'élément trouvé en tête de la table
							oob_air["blue"][1] = oob
							-- Supprimer l'élément à sa position originale (qui a été décalée)
							table.remove(oob_air["blue"], o + 1)
							break -- Si un seul déplacement est requis, on peut quitter la boucle ici
						end
					end
				end
			end
		end

		if multiPlaneSet.red then
			for o = 1, #oob_air["red"] do
				local oob = oob_air["red"][o]
				if multiPlaneSet.red[oob.type] and oob and oob.tasks then
					for taskName, taskValue in pairs(oob.tasks) do
						if taskName == multiPlaneSet.red.task then
							-- Décaler les éléments de la position 1 à o-1 vers la droite
							table_move(oob_air["red"], 1, o-1, 2)
							-- Mettre l'élément trouvé en tête de la table
							oob_air["red"][1] = oob
							-- Supprimer l'élément à sa position originale (qui a été décalée)
							table.remove(oob_air["red"], o + 1)
							break -- Si un seul déplacement est requis, on peut quitter la boucle ici
						end
					end
				end
			end
		end


		--tag multiPlaneSet_B Présent pour l'avion MAIN

		local multiPlaneSet_B = draft.multiPlaneSet_B or {}

		if multiPlaneSet_B and multiPlaneSet_B[sideName] and multiPlaneSet_B[sideName][draft.type] and multiPlaneSet_B[sideName][draft.type][draft.task] then
			multiPlaneSet_B[sideName][draft.type][draft.task].checked = true
		end

		local remain_SEAD_offset = draft.route.threats.SEAD_offset
		local remain_air_total = draft.route.threats.air_total

		for side, units in pairs(oob_air) do																	--iterate through all sides						
			local NbTotalSupport = {}

			if units and units ~= nil then
				for unitN, unit in pairs(units) do																				--iterate through all units

					local SupportMPOveRide = false

					if draft.MainMPOveRide or (multiPlaneSet[side] and  multiPlaneSet[side][unit.type]) then
						SupportMPOveRide = true
					else
						SupportMPOveRide = false
					end

					if side == sideName and unit.inactive ~= true and db_airbases[unit.base] and db_airbases[unit.base].inactive ~= true and ( SupportMPOveRide or (Aircraft_availability[unit.name] and Aircraft_availability[unit.name].available > 0))  and db_airbases[unit.base].x  then	--if unit is active, its base is active and has available aircraft -- ATO_G_debug01 Fin de campagne					

						if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "B")
						and ( Debug.Generator.SpySquad and Debug.Generator.SpySquad == draft.name
						or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == draft.target_name ))
						then
							DebuGenTxt = DebuGenTxt.."\n\n"..(tostring(draft.id).." AtoG II passe B_02_a draft.: "..draft.type.." OOBunit: "..unit.type.." SupportMPOveRide?: "..tostring(SupportMPOveRide))
						end


						for task, task_bool in pairs(unit.tasks) do											--iterate through all tasks of unit
							local playable_II = false
							local aliasTask = ""

							if draft.MainMPOveRide or( multiPlaneSet[side] and multiPlaneSet[side][unit.type] and multiPlaneSet[side][unit.type][task] and task_bool) then

								SupportMPOveRide = true

								if not Multi.Target and draft.task ~= "SAR" and draft.task ~= "CAP" then
									Multi.Target = {}
									Multi.Target[side] = draft.target_name
									MultiPlayerOveRide = true
									if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "B")
									and ( Debug.Generator.SpySquad and Debug.Generator.SpySquad == draft.name
									or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == draft.target_name ))
									then

										DebuGenTxt = DebuGenTxt.."\n\n"..(tostring(draft.id).." AtoG II passe B_03 draft.: "..draft.type.." OOBunit: "..unit.type.." SupportMPOveRide?: "..tostring(SupportMPOveRide))

										--augmente de 10% le score si l'avion peut etre joué

										draft.score = draft.score * 20
										-- Draft_sorties_entry.scoreAdd =  Draft_sorties_entry.scoreAdd + 1000
										draft.scoreCoef =  draft.scoreCoef * 20

									end
								end

							else
								SupportMPOveRide = false
							end

							local temp_Draft_sorties = {}														--temporary table to hold additional draft sorties with escorts assigned
							-- if (SupportMPOveRide or (task == "SEAD" or task == "Escort" or task == "Escort Jammer" or task == "Flare Illumination" or task == "Laser Illumination")) and task_bool then	--task is a support task and is true
							if ( draft.task ~= "CAP" and draft.task ~= "Intercept" ) and (task == "SEAD" or task == "Escort" or task == "Escort Jammer" or task == "Flare Illumination" or task == "Laser Illumination" or task == "Strike") and task_bool then	--task is a support task --and is true and draft.task ~= "SAR"

								--get possible loadouts
								local unit_loadouts = {}														--table to hold all loadouts for this aircraft type and task

								for loadout_name, ltable in pairs(db_loadouts[unit.type][task]) do			--iterate through all loadouts for the aircraft type and task
									ltable.name = loadout_name
									if ltable.standoff == nil then ltable.standoff = 0 end

									local countryEligible = false
									if ltable.country == nil  then
										countryEligible = true
									elseif type(ltable.country) == "string" then
										if string.lower(ltable.country) == string.lower(unit.country) or string.lower(ltable.country) == "all" then
											countryEligible = true
										end

									elseif type(ltable.country) == "table" then
										for n, countryLabel in pairs(ltable.country) do
											if string.lower(countryLabel) == string.lower(unit.country) or string.lower(countryLabel) == "all" then
												countryEligible = true
												break
											end
										end
									end

									if countryEligible then
										unit_loadouts[#unit_loadouts+1] = ltable
									end

								end

								-- trie par standoff
								table.sort(unit_loadouts, function(a,b) return a.standoff > b.standoff  end)

								for l = 1, #unit_loadouts do													--iterate through all available loadouts				

									--get possible Time on Target
									local tot_from = 0															--earliest Time on Target for this loadout
									local tot_to = 0															--latest Time on target for this loadout
									if unit_loadouts[l].day and unit_loadouts[l].night then						--loadout is day and night capable
										tot_from = 0															--from mission start
										tot_to = mission_ini.mission_duration											--to mission end
									elseif unit_loadouts[l].day then											--loadout is day capable
										if Daytime == "night-day" then
											tot_from = mission_ini.dawn - camp.time									--from dawn
											tot_to = mission_ini.mission_duration										--to mission end
										elseif Daytime == "day" then
											tot_from = 0														--from missiom start
											tot_to = mission_ini.mission_duration										--to mission end
										elseif Daytime == "day-night" then
											tot_from = 0														--from mission start
											tot_to = mission_ini.dusk - camp.time										--to dusk
										end
									elseif unit_loadouts[l].night then											--loadout is night capable
										if Daytime == "day-night" then
											tot_from = mission_ini.dusk - camp.time									--from dusk
											tot_to = mission_ini.mission_duration										--to mission end
										elseif Daytime == "night" then
											tot_from = 0														--from mission start
											tot_to = mission_ini.mission_duration										--to mission end
										elseif Daytime == "night-day" then
											tot_from = 0														--from mission start
											tot_to = mission_ini.dawn - camp.time										--to dawn
										end
									end

									if SupportMPOveRide or (tot_from ~= 0 or tot_to ~= 0)   then										--loadout has an eligible time on target

										local _NbTotalSupport = 0

										if not draft.support[task] then draft.support[task] ={} end
										if not draft.support[task]["NbTotalSupport"] then draft.support[task]["NbTotalSupport"] = 0 end
										-- if not draft.support[task]["escort_max"] then draft.support[task]["escort_max"] = campMod.Setting_Generation.limit_escort end
										if not draft.support[task]["escort_max"] then draft.support[task]["escort_max"] = 999 end

										local MP_Game = false
										if multiPlaneSet then
											if multiPlaneSet[side] and multiPlaneSet[side][unit.type] and multiPlaneSet[side][unit.type][task] then

												if Multi.Target and Multi.Target[side]  then
													DebuGenTxt = DebuGenTxt.."\n"..(tostring(draft.id).." AtoG II passe B_9 Multi.Target[side]: "..tostring(Multi.Target[side]).." target_name: "..tostring(draft.target_name))
												end

												if Multi.Target and Multi.Target[side] and Multi.Target[side] == draft.target_name then

													if draft.task ~= "SAR" then
														MP_Game = true
													end


													-- --TODO faire en sorte qu'un seul score soit augmenté
													-- --augmente de 10% le score si l'avion peut etre joué
													-- -- if unit.player then
													-- draft.score = draft.score * 20
													-- -- Draft_sorties_entry.scoreAdd =  Draft_sorties_entry.scoreAdd + 1000
													-- draft.scoreCoef =  draft.scoreCoef * 20
													-- -- endroit

													if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "B")
													and (Debug.Generator.SpySquad and (Debug.Generator.SpySquad == unit.name or Debug.Generator.SpySquad == draft.name)  and  (Debug.Generator.SpyTask == draft.task or Debug.Generator.SpyTask == task)
													or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == draft.target_name ))
													then
														DebuGenTxt = DebuGenTxt.."\n"..(tostring(draft.id).." AtoG II passe B_10c MP_Game = true target_name: "..tostring(draft.target_name))
													end

												end
											end
										end


										i_timmer02 = i_timmer02 +1
										if SupportMPOveRide or (draft.loadout.support and draft.loadout.support[task])
											and ( (tonumber(draft.support[task]["NbTotalSupport"]) < tonumber(draft.support[task]["escort_max"])) or MP_Game ) then


											if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "B")
											and (Debug.Generator.SpySquad and (Debug.Generator.SpySquad == unit.name or Debug.Generator.SpySquad == draft.name)  and  (Debug.Generator.SpyTask == draft.task or Debug.Generator.SpyTask == task)
											or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == draft.target_name ))
											then
												DebuGenTxt = DebuGenTxt.."\n"..(tostring(draft.id).." AtoG II passe B_12 task "..task.." SEAD_offset  "..tostring(draft.route.threats.SEAD_offset))
												-- DebuGenTxt = DebuGenTxt.."\n"..TableSerialization(draft.route.threats, 0)
											end


											local support_requirement = false
											if task == "SEAD" then
												if draft.route.threats.SEAD_offset > 0 then												--draft sortie has a SEAD offset requirement
													support_requirement = true
												end
											elseif task == "Escort" then
												if draft.route.threats.air_total > 0.5 then												--draft sortie has an air threat
													support_requirement = true
												end
											elseif task == "Escort Jammer" then
												if draft.route.threats.SEAD_offset > 0 or draft.route.threats.air_total > 0.5 then		--draft sortie has either a SEAD offest requirement or an air threat
													support_requirement = true
												end
											elseif task == "Flare Illumination" or task == "Laser Illumination"then
												support_requirement = true
											end

											if draft.task == "SAR" then
												support_requirement = false
											end


											if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "B")
											and (Debug.Generator.SpySquad and (Debug.Generator.SpySquad == unit.name or Debug.Generator.SpySquad == draft.name)  and  (Debug.Generator.SpyTask == draft.task or Debug.Generator.SpyTask == task)
											or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == draft.target_name ))
											then
												DebuGenTxt = DebuGenTxt.."\n"..(tostring(draft.id).." AtoG II passe B_15 threats.SEAD_offset?: "..tostring(draft.route.threats.SEAD_offset).." support_requirement?: "..tostring(support_requirement).." "..unit.type.." MP_Game: "..tostring(MP_Game))
												-- DebuGenTxt = DebuGenTxt.._afficheTXT(draft.route.threats)
											end

											if support_requirement or MP_Game then																	--go ahead with this support task
												if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "B")
												and (Debug.Generator.SpySquad and (Debug.Generator.SpySquad == unit.name or Debug.Generator.SpySquad == draft.name)  and  (Debug.Generator.SpyTask == draft.task or Debug.Generator.SpyTask == task)
												or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == draft.target_name ))
												then
													DebuGenTxt = DebuGenTxt.."\n"..(tostring(draft.id).." AtoG II passe B_15b support_requirement passe: ")
												end


												if (unit_loadouts[l].day and draft.loadout.day) or (unit_loadouts[l].night and draft.loadout.night) then	--support can join package at either day or night
													TrackPlayability(unit.player, "tot")															--track playabilty criterium has been met
													--admet une vitesse (escort) 75% plus faible que la vitesse du Main
													if unit_loadouts[l].vCruise < draft.loadout.vCruise then


														if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "B")
														and (Debug.Generator.SpySquad and (Debug.Generator.SpySquad == unit.name or Debug.Generator.SpySquad == draft.name)  and  (Debug.Generator.SpyTask == draft.task or Debug.Generator.SpyTask == task)
														or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == draft.target_name ))
														then
															DebuGenTxt = DebuGenTxt.."\n"..(tostring(draft.id).." AtoG II passe B_15c unit_loadouts[l].vCruise : "..tostring(unit_loadouts[l].vCruise).." < "..tostring(draft.loadout.vCruise).. " | %: "..tostring(unit_loadouts[l].vCruise / draft.loadout.vCruise))
														end

														if (unit_loadouts[l].vCruise / draft.loadout.vCruise) * 100 >= 75 then
															draft.loadout.vCruise = unit_loadouts[l].vCruise
														end
													end

													if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "B")
													and (Debug.Generator.SpySquad and (Debug.Generator.SpySquad == unit.name or Debug.Generator.SpySquad == draft.name)  and  (Debug.Generator.SpyTask == draft.task or Debug.Generator.SpyTask == task)
													or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == draft.target_name ))
													then
														DebuGenTxt = DebuGenTxt.."\n"..(tostring(draft.id).." AtoG II passe B_15d support_requirement passe: ")
													end

													if unit_loadouts[l].vCruise >= draft.loadout.vCruise or SupportMPOveRide then										--support has a cruise speed equal or higher than main body
														TrackPlayability(unit.player, "target")													--track playabilty criterium has been met

														local DebuGenTxt1480 = "\n"..(tostring(draft.id).." AtoG II passe B_15e support_requirement passe: ")

														--check weather
														local weather_eligible = true
														if mission.weather["clouds"]["density"] > 8 then											--overcast clouds
															local cloud_base = mission.weather["clouds"]["base"]
															local cloud_top = mission.weather["clouds"]["base"] + mission.weather["clouds"]["thickness"]
															if db_airbases[unit.base].elevation + 333 > cloud_base then							--cloud base is less than 1000 ft above airbase elevation
																if unit_loadouts[l].adverseWeather == false then									--loadout is not adverse weather capable
																	weather_eligible = false														--not eligible for this weather
																end
															else
																if draft.loadout.hCruise > cloud_base and draft.loadout.hCruise < cloud_top then	--cruise alt is in the clouds
																	if unit_loadouts[l].adverseWeather == false then								--loadout is not adverse weather capable
																		weather_eligible = false													--not eligible for this weather
																	end
																elseif draft.loadout.hAttack > cloud_base and draft.loadout.hAttack < cloud_top then	--attack alt is in the clouds
																	if unit_loadouts[l].adverseWeather == false then								--loadout is not adverse weather capable
																		weather_eligible = false													--not eligible for this weather
																	end
																end
															end
														end
														if mission.weather["enable_fog"] == true then												--fog
															if db_airbases[unit.base].elevation < mission.weather["fog"]["thickness"] then		--base elevation in fog
																if mission.weather["fog"]["visibility"] < 5000 then									--less than 5000m visibility
																	if unit_loadouts[l].adverseWeather == false then								--loadout is not adverse weather capable
																		weather_eligible = false													--not eligible for this weather
																	end
																end
															end
														end

														if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "B")
														and (Debug.Generator.SpySquad and (Debug.Generator.SpySquad == unit.name or Debug.Generator.SpySquad == draft.name)  and  (Debug.Generator.SpyTask == draft.task or Debug.Generator.SpyTask == task)
														or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == draft.target_name ))
														then
															DebuGenTxt = DebuGenTxt..DebuGenTxt1480.."\n"..(tostring(draft.id).." AtoG II passe B_15e support_requirement passe: weather_eligible "..tostring(weather_eligible).." SupportMPOveRide "..tostring(SupportMPOveRide))
														end

														if weather_eligible or SupportMPOveRide then												--continue of this loadout is eligible for weather

															if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "B")
															and (Debug.Generator.SpySquad and (Debug.Generator.SpySquad == unit.name or Debug.Generator.SpySquad == draft.name)  and  (Debug.Generator.SpyTask == draft.task or Debug.Generator.SpyTask == task)
															or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == draft.target_name ))
															then
																
															end

															
															TrackPlayability(unit.player, "weather")												--track playabilty criterium has been met								
															--get airbase position
															local airbasePoint = {																	--get the x-y coordinates of the airbase where the unit is located
																x = db_airbases[unit.base].x,
																y = db_airbases[unit.base].y,
																h = db_airbases[unit.base].elevation,
															}

															local route = GetEscortRoute(airbasePoint, draft.route, task, unit_loadouts[l], unit, draft)									--get the route to escort this sortie

															if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "B")
															and (Debug.Generator.SpySquad and (Debug.Generator.SpySquad == unit.name or Debug.Generator.SpySquad == draft.name)  and  (Debug.Generator.SpyTask == draft.task or Debug.Generator.SpyTask == task)
															or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == draft.target_name ))
															then
																DebuGenTxt = DebuGenTxt.."\n"..(tostring(draft.id).." AtoG II passe B_16 weather_eligible route.lenght: "..tostring(route.lenght).. " <= "..tostring(unit_loadouts[l].range * 2)
																.." (loadouts: )" ..tostring(unit_loadouts[l].range)..") loadoutName: "..tostring(unit_loadouts[l].name)
																.."unit_loadouts[l].minrange: "..tostring(unit_loadouts[l].minrange))
															end



															if route.lenght <= unit_loadouts[l].range * 2 and (unit_loadouts[l].minrange == nil or route.lenght > unit_loadouts[l].minrange * 2) then		--escort route lenght is within range capability of loadout
																TrackPlayability(unit.player, "target_range")									--track playabilty criterium has been met

																local DebuGenTxt1545 = "\n"..(tostring(draft.id).." AtoG II passe B_17  ")

																--determine number of escorts
																local escort_num = 0
																local escort_max = 0

																if draft.support[task]["escort_max"] ~= 999 then
																	escort_max = draft.support[task]["escort_max"]
																else
																	escort_max = 0
																end

																if task == "SEAD" then
																	escort_num = draft.route.threats.SEAD_offset / unit_loadouts[l].firepower 		-- unit_loadouts[l].capability  capability determines amount of offset per aircraft
																	-- escort_num = remain_SEAD_offset / unit_loadouts[l].firepower
																	escort_num = math.ceil(escort_num / 2) * 2										--round up requested escorts to even number

																	--TODO revoir ça
																	-- if totalPlanePerTask[side][task] and totalPlanePerTask[side][task]/2 >= escort_num then
																	-- 	draft.score = draft.score + (1 * draft.loadout.firepower) * draft.target.priority
																	-- end

																	DebuGenTxt1545 = DebuGenTxt1545.."\n"..(tostring(draft.id).." AtoG II passe_SEAD B "..unit.type.." "..task.." "..escort_num.." NbTotalSupport: "..draft.support[task]["NbTotalSupport"].." draft.score: "..draft.score)
																	DebuGenTxt1545 = DebuGenTxt1545.."\n"..("-------------------- escort_num: "..(draft.route.threats.SEAD_offset / unit_loadouts[l].firepower).. "= SEAD_Offset: "..draft.route.threats.SEAD_offset.." /firepower "..unit_loadouts[l].firepower
																	)


																elseif task == "Escort" then
																	if draft.support[task]["escort_max"] ~= 999 then
																		escort_num = draft.support[task]["escort_max"] - draft.support[task]["NbTotalSupport"]	-- modification M11.x : Multiplayer	(x: EscorteTot-max)

																		DebuGenTxt1545 = DebuGenTxt1545.."\n"..(tostring(draft.id).." AtoG II passe_Escort B "..unit.type.." "..task.." "..escort_num.." NbTotalSupport: "..draft.support[task]["NbTotalSupport"])

																	else

																		local escort_offset_level =  unit_loadouts[l].firepower	--unit_loadouts[l].capability *--threat level that each fighter escort can offset
																		-- escort_num = (draft.route.threats.air_total - 0.5) / escort_offset_level		--number of escorts needed to offset total air threat (-0.5 because that is no air threat)
																		escort_num = (remain_air_total - 0.5) / escort_offset_level



																		if escort_num > draft.number * 2 then											--when more escorts 2 times escorts than escorted aircraft
																			escort_num = draft.number * 2												--limit escort number to 2 times escorted aircraft
																		end
																		-- if escort_num > campMod.Setting_Generation.limit_escort then
																		-- 	escort_num = campMod.Setting_Generation.limit_escort
																		-- end

																		escort_num = math.ceil(escort_num / 2) * 2										--round up requested escorts to even number

																		if escort_num > escort_max then
																			escort_max = escort_num
																			draft.support[task]["escort_max"] = escort_max
																		end

																		DebuGenTxt1545 = DebuGenTxt1545.."\n"..(tostring(draft.id).." AtoG II passe_Escort I "..unit.type.." "..task.." "..escort_num)

																	end

																elseif task == "Escort Jammer" then
																	escort_num = 1																	--escort jamming by single aircraft
																elseif task == "Flare Illumination" then
																	escort_num = 1																	--flare illumination by single aircraft
																elseif task == "Laser Illumination" then
																	escort_num = 1																	--laser illumination by single aircraft
																elseif task == "Strike" and not SupportMPOveRide then
																	-- escort_num = 4
																	escort_num = draft.remainingFirepower / unit_loadouts[l].firepower
																elseif task == "Strike"  then
																	escort_num = 4
																end

																--ici 4 Mi24 redemandé
																-- mais c'est 4 de trop, 4 sont déjà pris en main strike
																if escort_num > Aircraft_availability[unit.name].available then					--if more escorts are requested than available
																	escort_num = Aircraft_availability[unit.name].available						--reduce requested escorts to number of available escorts
																	escort_num = math.floor(escort_num / 2) * 2										--round down to even number

																	DebuGenTxt1545 = DebuGenTxt1545.."\n"..(tostring(draft.id).." AtoG II passe_Escort J "..unit.type.." "..task.." escort_num: "..escort_num.." available: "..Aircraft_availability[unit.name].available)

																end

																DebuGenTxt1545 = DebuGenTxt1545.."\n"..(tostring(draft.id).." AtoG II passe_Escort P "..unit.type.." "..task.." "..escort_num)


																--*********************************************************************************
																-- modification M11.o multiplayer**************************************************
																local txtDebug = ""
																if multiPlaneSet_B  then
																	txtDebug = txtDebug .. " passeA ".."/n"

																	-- if  multiPlaneSet_B[side] and multiPlaneSet_B[side][unit.type]  and multiPlaneSet_B[side][unit.type][task] then	
																	if MP_Game then

																		--si l'avion de support est déjà utilise en MAIN, on enleve la qté dejà utilisé
																		if multiPlaneSet_B and multiPlaneSet_B[side] and multiPlaneSet_B[side][draft.type] and multiPlaneSet_B[side][draft.type][draft.task] and task_bool then

																			-- print("AtoG II passe_Escort P2 side "..side.." draft.type: "..tostring(draft.type).." task "..tostring(task).." draft.task "..tostring(draft.task).."")

																			multiPlaneSet_B[side][draft.type][draft.task].NbPlane = multiPlaneSet_B[side][draft.type][draft.task].InitNbPlaneByTask - draft.number
																			txtDebug = txtDebug .. "    passeB NbPlane: "..multiPlaneSet_B[side][draft.type][draft.task].NbPlane.." draft.task: "..tostring(draft.task).."/n"

																		end


																		playable_II = true

																		if escort_num < multiPlaneSet_B[side][unit.type][task].NbPlane then
																			escort_num =  multiPlaneSet_B[side][unit.type][task].NbPlane
																			txtDebug = txtDebug .. "    passeC "..escort_num.."/n"
																		elseif escort_num > multiPlaneSet_B[side][unit.type][task].NbPlane then
																			escort_num =  multiPlaneSet_B[side][unit.type][task].NbPlane
																			txtDebug = txtDebug .. "    passeD "..escort_num.."/n"
																		end

																		txtDebug = txtDebug .. "    passeE "..draft.score.."/n"

																		draft.score = draft.score * 1.2 + 1000
																		draft.scoreAdd =  draft.scoreAdd + 1000
																		draft.scoreCoef =  draft.scoreCoef * 1.2

																		txtDebug = txtDebug .. "    passeF "..draft.score.."/n"

																		txtDebug = txtDebug .. "    passeG NbPlane "..multiPlaneSet_B[side][unit.type][task].NbPlane.."/n"
																		txtDebug = txtDebug .." InitNbPlaneByTask: "..tostring(multiPlaneSet_B[side][unit.type][task].InitNbPlaneByTask)

																		-- Marquer l'unité comme vérifiée
																		multiPlaneSet_B[side][unit.type][task].checked = true

																		-- Vérification si tous les éléments sont cochés
																		local fullMP_Plane = true
																		for typeM, tasksM in pairs(multiPlaneSet_B[side]) do
																			if type(tasksM) == "table" then
																				for taskM, value in pairs(tasksM) do
																					if type(value) == "table" and not value.checked then
																						fullMP_Plane = false
																						break  -- Arrêter la vérification dès qu'un élément n'est pas coché
																					end
																				end
																				if not fullMP_Plane then
																					break  -- Sortir complètement si un type n'est pas entièrement vérifié
																				end
																			end
																		end

																		-- Doubler le score si tous les éléments sont cochés
																		if fullMP_Plane and not uniqueBonus then
																			draft.score = draft.score * 2000
																			draft.scoreCoef =  draft.scoreCoef * 2000

																			uniqueBonus = true

																			-- print(tostring(draft.id).." "..draft.score)																			
																			-- os.execute 'pause'

																		end

																	end

																	-- DebuGenTxt1545 = DebuGenTxt1545.."\n"..(tostring(draft.id).." AtoG II passe B_20a2. escort_num "..tostring(escort_num).." txtDebug: "..txtDebug  )

																	if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "B")
																	and (Debug.Generator.SpySquad and (Debug.Generator.SpySquad == unit.name or Debug.Generator.SpySquad == draft.name)  and  (Debug.Generator.SpyTask == draft.task or Debug.Generator.SpyTask == task)
																	or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == draft.target_name ))
																	then
																		DebuGenTxt = DebuGenTxt..DebuGenTxt1545.."\n"..(tostring(draft.id).." AtoG II passe B_20a2. escort_num "..tostring(escort_num).." txtDebug: "..txtDebug  )

																	end

																end

																if Multi.NbGroup == 0 then
																	playable_II = unit.player
																end

																local wi = 1


																if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "B")
																and (Debug.Generator.SpySquad and (Debug.Generator.SpySquad == unit.name or Debug.Generator.SpySquad == draft.name)  and  (Debug.Generator.SpyTask == draft.task or Debug.Generator.SpyTask == task)
																or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == draft.target_name ))
																then
																	DebuGenTxt = DebuGenTxt.."\n"..(tostring(draft.id).." AtoG II passe B_21c Id "..tostring(draft.id).." "..unit.type.." "..unit.name.." escort_num "..tostring(escort_num).." "..draft.target_name.." NbTotalSupport: "..draft.support[task]["NbTotalSupport"])

																end

																TrackPlayability(unit.player, "target_firepower")							--track playabilty criterium has been met

																local entryEscortNum

																entryEscortNum = escort_num

																if not draft.support[task] then
																	draft.support[task] = {}
																end


																--add escort table to sortie															
																draft.support[task]["NbTotalSupport"] = draft.support[task]["NbTotalSupport"] + escort_num
																draft.support[task]["escort_max"] = escort_max

																if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "B")
																and (Debug.Generator.SpySquad and (Debug.Generator.SpySquad == unit.name or Debug.Generator.SpySquad == draft.name)  and  (Debug.Generator.SpyTask == draft.task or Debug.Generator.SpyTask == task)
																or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == draft.target_name ))
																then
																	DebuGenTxt = DebuGenTxt.."\n"..(tostring(draft.id).." AtoG II passe B_21d Id "..tostring(draft.id).." "..unit.type.." "..unit.name.."".." escort_num "..tostring(escort_num).." "..draft.target_name.." NbTotalSupport: "..draft.support[task]["NbTotalSupport"].." entryEscortNum: "..tostring(entryEscortNum))

																end


																if entryEscortNum >= 1 then

																	if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "B")
																	and (Debug.Generator.SpySquad and Debug.Generator.SpySquad == unit.name  and  (Debug.Generator.SpyTask == draft.task or Debug.Generator.SpyTask == task)
																	or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == draft.target_name ))
																	then
																		DebuGenTxt = DebuGenTxt.."\n"..(tostring(draft.id).." AtoG II passe B_21c Add In draft.support ")
																	end

																	if not draft.support[task][unit.type] then
																		draft.support[task][unit.type] = {}
																	end

																	draft.support[task][unit.type] = {
																		id = draft.id.."-"..wi.."-"..wk,
																		name = unit.name,
																		playable = playable_II,								--unit.player,
																		-- playable = unit.player,
																		type = unit.type,
																		modification = unit.modification,
																		callsign = unit.callsign,
																		callsignId = unit.callsignId,
																		helicopter = unit.helicopter,											-- modification M06 : helicopter playable
																		number = entryEscortNum,
																		country = unit.country,
																		livery = unit.livery,
																		sidenumber = unit.sidenumber,
																		liveryModex = unit.liveryModex,
																		base = unit.base,
																		airdromeId = db_airbases[unit.base].airdromeId,
																		parking_id = unit.parking_id,
																		skill = unit.skill,
																		task = task,
																		tasks = unit.tasks,
																		loadout = unit_loadouts[l],
																		route = route,
																		target = Deepcopy(draft.target),
																		target_name = draft.target.titleName,
																		tot_from = draft.tot_from,
																		tot_to = draft.tot_to,
																		rejected = {},
																		SupportMPOveRide = SupportMPOveRide,
																		priorityIni = draft.priorityIni,
																	}

																end

																--recalculate threat level for sortie adjusted by number of escort
																-- route.threats.ground_total_OLD = Deepcopy(route.threats.ground_total)
																-- route.threats.air_total_OLD = Deepcopy(route.threats.air_total)

																local route_threat_OLD = draft.route.threats.ground_total + draft.route.threats.air_total
																-- print()
																-- if draft.name == "VMA 311" then print("Atog A1 draft.id "..draft.id) end

																local route_threat_recalc = 0.5														--recalculated route threat with escort in place (0.5 == no threat)
																if task == "SEAD" then
																	local escort_offset = escort_num *  unit_loadouts[l].firepower					--* unit_loadouts[l].capability--number of available SEAD to offset threats
																	for k, tGround in pairs(draft.route.threats.ground) do									--iterate through route ground threats
																		if tGround.offset > 0 then														--if threat can be offset by SEAD
																			if escort_offset >= tGround.offset then										--some SEAD aircraft remain to offset the threat
																				route_threat_recalc = escort_offset - tGround.offset							--use these SEAD aircraft to offset and ignore the therat
																			else																	--no SEAD aircraft remain unassignedd
																				route_threat_recalc = route_threat_recalc + tGround.level					--sum route ground threat levels
																			end
																		else																		--threat cannot be offset by SEAD
																			route_threat_recalc = route_threat_recalc + tGround.level						--sum route ground threat levels
																		end
																		-- if draft.name == "VMA 311" then print("Atog A2 recalcul SEAD "..route_threat_recalc) end
																	end

																	if not draft.route.threats.ground_total_Init then
																		draft.route.threats.ground_total_Init = draft.route.threats.ground_total
																	end

																	if route_threat_recalc < 0.5 then
																		route_threat_recalc = 0.5
																	end

																	draft.route.threats.ground_total = route_threat_recalc			--recalculated total route grund threat

																elseif task == "Escort" then

																	local escort_offset_level =  unit_loadouts[l].firepower		--unit_loadouts[l].capability *--threat level that each fighter escort can offset
																	route_threat_recalc = draft.route.threats.air_total - escort_offset_level * escort_num			--recalculated total route air threat

																	if route_threat_recalc < 0.5 then
																		route_threat_recalc = 0.5
																	end

																	draft.route.threats.air_total = route_threat_recalc

																	-- if draft.name == "VMA 311" then print("Atog A3 recalcul Escort "..route_threat_recalc) end

																elseif task == "Escort Jammer" then
	--ADD RECALCULATED THREAT LEVEL WITH ESCORT JAMMERS
																end


																local route_threat_New = draft.route.threats.ground_total + draft.route.threats.air_total
																-- if draft.name == "VMA 311" then print("Atog A2 route_threat_OLD "..route_threat_OLD.." route_threat_New "..route_threat_New) end

																if route_threat_New ~= route_threat_OLD then
																	local oldScore = draft.score
																	draft.score = draft.priorityIni / route_threat_New

																	-- if draft.name == "VMA 311" then print("Atog "..draft.type.." target_name "..draft.target_name) end
																	-- if draft.name == "VMA 311" then print("AtoG                  Total AA id "..draft.id.." priorityIni: "..draft.priorityIni.." Oldscore: "..oldScore.." NewScore: "..draft.score.." route_threat_OLD "..route_threat_OLD) end


																	draft.score =  draft.score * draft.scoreCoef
																	draft.score =  draft.score + draft.scoreAdd

																	-- if draft.name == "VMA 311" then print("AtoG                  Total BB id "..draft.id.." priorityIni: "..draft.priorityIni.." Oldscore: "..oldScore.." NewScore: "..draft.score.." route_threat "..route_threat_New) end


																end

																-- if  multiPlaneSet[side] and  multiPlaneSet[side][unit.type] and  multiPlaneSet[side][unit.type][task] and task_bool and  multiPlaneSet[side][unit.type][task].NbPlane > 0 then
																-- 	draft.score = draft.score + 1000
																-- 	DebuGenTxt = DebuGenTxt.."\n"..(tostring(draft.id).." AtoG B passe multiPlaneSet B: score: " .. tostring(draft.score).." "..unit.type.." "..tostring(task))

																-- 	if draft.MainMPOveRide then
																-- 		draft.score = draft.score * 2 +1000
																-- 		DebuGenTxt = DebuGenTxt.."\n"..(tostring(draft.id).." AtoG B passe multiPlaneSet C: score: " .. tostring(draft.score).." "..unit.type.." "..tostring(task))
																-- 	end
																-- elseif  Multi.Target and Multi.Target[side] == draft.target_name  then
																-- 	-- draft.score = draft.score * 2   -- attention tout autre avion non multi augmente drastiquement ici
																-- 	draft.score = draft.score + 1 
																-- 	DebuGenTxt = DebuGenTxt.."\n"..(tostring(draft.id).." AtoG B passe multiPlaneSet D:  "..tostring(draft.id).." score: " .. tostring(draft.score).." "..unit.type.." "..tostring(task))
																-- end

																-- --augmente de 10% le score si l'avion peut etre joué
																-- if draft.playable then

																-- 	draft.score = draft.score * 2

																-- end

																--adjust sortie Time on Target
																if tot_from > draft.tot_from then									--if earliest escort Time on Target is later than main body TOT
																	draft.tot_from = tot_from							--make earliest escort TOT the draft sortie earliest TOT 
																end
																if tot_to < draft.tot_to then										--if latest escort Time on Target is sooner than main body TOT
																	draft.tot_to = tot_to								--make latest escort TOT the draft sortie latest TOT
																end

																--status report
																status_counter_escorts = status_counter_escorts + 1
																--DebuGenTxt = DebuGenTxt.."\n"..("ATO Assigning Escorts (" .. status_counter_escorts .. ")")	--DEBUG

																wi = wi + 1

																-- escort_num = escort_num - 4 

																-- escort_num = 0

																if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "B")
																and (Debug.Generator.SpySquad and Debug.Generator.SpySquad == unit.name  and  (Debug.Generator.SpyTask == draft.task or Debug.Generator.SpyTask == task)
																or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == draft.target_name ))
																then
																	DebuGenTxt = DebuGenTxt.."\n"..(tostring(draft.id).." AtoG II passe B_22 escort_num "..tostring(escort_num).." "..unit.type.." target_name: "..tostring(draft.target_name))
																end


															end
														end
													end
												end
											end
										else
											-- print("ATO_G  Refused02 ||:if draft.loadout.support and draft.loadout.support[task] and "..debug.getinfo(1).currentline)
											-- print("    draft.type"..tostring(draft.type).."[task]?: "..tostring(task).." NbTotalSupport: "..tonumber(draft.support[task]["NbTotalSupport"]).." < "..tonumber(draft.support[task]["escort_max"]).." or "..tostring(MP_Game))
										end
										if i_timmer02 >= 1000  then io.write(".") i_timmer02 = 0 end
										wk = wk +1
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
-- print()
-- print("ATO Assigning Escorts (" .. status_counter_escorts .. ")")	--DEBUG
DebuGenTxt = DebuGenTxt.."\n\n"..("ATO Assigning Escorts (" .. status_counter_escorts .. ")")


-- -- ATO_G_debug02b haut score

-- 	-- table.sort(Draft_sorties["blue"], function(a,b) return a.score > b.score  end)
-- 	-- table.sort(Draft_sorties["red"], function(a,b) return a.score > b.score  end)

-- 	Draft_sorties["blue"] = mysort(Draft_sorties["blue"])
-- 	Draft_sorties["red"] = mysort(Draft_sorties["red"])

-- 	-- table.sort(Draft_sorties["blue"], function(a,b) return a.priorityIni > b.priorityIni  end)
-- 	-- table.sort(Draft_sorties["red"], function(a,b) return a.priorityIni > b.priorityIni  end)

-- Tri final par `targetPriority` (ascendant), puis par `score` (descendant)
for side, sorties in pairs(Draft_sorties) do
    table.sort(sorties, function(a, b)
        if a.targetPriority ~= b.targetPriority then
            return a.targetPriority > b.targetPriority -- Plus grande priorité d'abord
        end
        return a.score > b.score -- Plus grand score d'abord
    end)
end

if Debug.Generator.affiche then

	-- DebuGenTxt = DebuGenTxt.."\n"..("BLUE PART B")

	for sideName, drafts in pairs(Draft_sorties) do
		DebuGenTxt = DebuGenTxt.."\n\n\n"..( string.upper(sideName).." PART B")

		local di = 1
		for draft_n, draft in pairs(drafts) do
			if  di < Debug.Generator.nb or draft.name == Debug.Generator.SpySquad  or draft.target_name == Debug.Generator.SpyTarget then

				DebuGenTxt = DebuGenTxt.."\n"..(	"B N° " .. draft_n..
						-- " /support/ " ..tostring(draft.support)..
						" /Id " ..tostring(draft.id)..
						" /Prioriry/ " ..tostring(draft.priorityIni)..
						" /Name/ " ..tostring(draft.name)..
						" /Nb/ " ..draft.number..
						" /flights/ " ..tostring(draft.flights)..
						" /Type/ "..draft.type..
						" /thrtGrnd/ "..round(draft.threatsGround)..
						" /thrtA/ "..round(draft.threatsAir)..
						" /Score/ " ..round(draft.score)..
						" /NbTotSupt/ " ..tostring(draft.NbTotalSupport)..

						" /Task/ "..draft.task..
						" /Target/ "..draft.target_name..
						" /Sead_Of/ "..tostring(draft.route.threats.SEAD_offset)..
						" /MainMPOveRide/ " ..tostring(draft.MainMPOveRide)..
						" /loadout/ "..tostring(draft.loadout.loadout_name)
						)

				di = di +1
				for _PlaneTask, PlaneTask in pairs(draft.support) do
					for taskName, task in pairs(PlaneTask) do

						if type(task) == "table" and task.target_name and task.loadout then


							-- local test = "\n"..(	"    ---> Nsupport " .._PlaneTask.." ".. taskName..
							-- " /Id/ " ..tostring(task.id)..
							-- " /Nb/ " ..task.number..
							-- " /escort_max/ " ..tostring(PlaneTask.escort_max)..
							-- " /Type/ "..task.type..
							-- " /Task/ "..task.task..
							-- " /NbTotSupt/ " ..tostring(task.NbTotalSupport)..
							-- " /Target/ "..task.target_name..
							-- " /SupportMPOveRide/ "..tostring(task.SupportMPOveRide)
							-- )

							-- print("AtoG " ..test)

							DebuGenTxt = DebuGenTxt.."\n"..(	"    ---> Nsupport " .._PlaneTask.." ".. taskName..
									" /Id/ " ..tostring(task.id)..
									" /Nb/ " ..task.number..
									" /escort_max/ " ..tostring(PlaneTask.escort_max)..
									" /SupportName/ "..task.name..
									" /Type/ "..task.type..
									" /Task/ "..task.task..
									" /NbTotSupt/ " ..tostring(task.NbTotalSupport)..
									" /Target/ "..task.target_name..
									" /SupportMPOveRide/ "..tostring(task.SupportMPOveRide)..
									" /loadout/ "..tostring(task.loadout.loadout_name)
									)
						end
					end
				end
				DebuGenTxt = DebuGenTxt.."\n\n"
			end
		end
	end


	DebuGenTxt = DebuGenTxt.."\n"
end


-- if Debug.Generator.affiche then	
-- 	local di = 1 
-- 	DebuGenTxt = DebuGenTxt.."\n"..("RED PART B")
-- 	for draft_n, draft in pairs(Draft_sorties["red"]) do	
-- 		if  di < Debug.Generator.nb or draft.name == Debug.Generator.SpySquad  or draft.target_name == Debug.Generator.SpyTarget  then
-- 			DebuGenTxt = DebuGenTxt.."\n"..(	"B N° " .. draft_n..
-- 					-- " /support/ " ..tostring(draft.support)..
-- 					" /Id" ..tostring(draft.id)..
-- 					" /Id/ " ..tostring(draft.id)..
-- 					" /Nb/ " ..draft.number..
-- 					" /flights/ " ..tostring(draft.flights)..
-- 					" /Type/ "..draft.type..
-- 					" /threatsGround/ "..round(draft.threatsGround)..
-- 					" /threatsAir/ "..round(draft.threatsAir)..
-- 					" /Score/ " ..round(draft.score)..
-- 					" /Task/ "..draft.task..
-- 					" /Target/ "..tostring(draft.target_name)..
-- 					" /Sead_Of/ "..tostring(draft.route.threats.SEAD_offset)..
-- 					" /MainMPOveRide/ " ..tostring(draft.MainMPOveRide)..
-- 					" /loadout/ "..tostring(draft.loadout.loadout_name)
-- 					)

-- 			di = di +1
-- 			for _PlaneTask, PlaneTask in pairs(draft.support) do
-- 				for taskName, task in pairs(PlaneTask) do	
-- 					if type(task) == "table" and task.target_name and task.loadout then	
-- 						DebuGenTxt = DebuGenTxt.."\n"..(	"    ---> Nsupport " .._PlaneTask.." ".. taskName..
-- 								" /Id/ " ..tostring(task.id)..
-- 								" /Nb/ " ..task.number..
-- 								" /escort_max/ " ..tostring(PlaneTask.escort_max)..
-- 								" /Type/ "..task.type..
-- 								" /Task/ "..task.task..
-- 								" /NbTotSupt/ " ..tostring(task.NbTotalSupport)..
-- 								" /Target/ "..task.target_name..
-- 								" /SupportMPOveRide/ "..tostring(task.SupportMPOveRide)..
-- 								" /loadout/ "..tostring(task.loadout.loadout_name)
-- 								)
-- 						-- print()
-- 					end
-- 				end
-- 			end
-- 			DebuGenTxt = DebuGenTxt.."\n\n"
-- 		end
-- 	end
-- 	DebuGenTxt = DebuGenTxt.."\n\n\n"	
-- end



--table to store the final ATO
ATO = {
	blue = {},
	red = {}
}



--assign draft sorties to ATO and build packages/flights
local function createATO_table(draftPriority)
	for side, drafts in pairs(draftPriority) do																		--iterate through all sides
		if drafts and drafts ~= nil then
			for draftN, draft in pairs(drafts) do																						--iterate through all draft sorties beginning with the highest scored			

				if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "C")
				and ( Debug.Generator.SpySquad and Debug.Generator.SpySquad == draft.name
				or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == draft.target_name ))
				then
					DebuGenTxt = DebuGenTxt.."\n"..(tostring(draft.id).." AtoG passe C_00 "..draft.type.." "..draft.task.." "..draft.score)
				end

				--diminue le minscore en fonction du nombre de tentative de generation de mission
				--evite un blocage de generation
				if draft.loadout.minscore and MissionInstance >= 2 then
					-- print("AtoG BEFOR minscore "..draft.loadout.minscore)
					draft.loadout.minscore = draft.loadout.minscore / ((MissionInstance )/10 +1)
					-- print("AtoG After minscore "..draft.loadout.minscore)
				end

				if draft.loadout.minscore == nil or draft.score >= draft.loadout.minscore then					--draft sortie has no minimum score requirement or minimum score requirement is satisified		
				-- if 1 == 1 then
					-- if draft.multipack > 0 then												--target does not have a requirment for a specific number of packages, or still needs more packages		
					if multipackByTargetName[draft.target_name] > 0 then

						if draft.target.firepower.max > 0 and draft.target.firepower.max >= draft.target.firepower.min then	--the target of this draft sortie must have a need for firepower above the minimum firepower threshold	
							local available = Aircraft_availability[draft.name].unassigned											--shortcut for available aircraft for this draft sortie					

							if available * draft.loadout.firepower >= draft.target.firepower.min and draft.number * draft.loadout.firepower >= draft.target.firepower.min then	--enough aircraft are available to satisfy minimum firepower requirement for target						

								if draft.target.firepower.packmin == nil or available * draft.loadout.firepower >= (draft.target.firepower.packmin - 1) * draft.target.firepower.max + draft.target.firepower.min then	--if the target has a minimum package number requirement, sufficient aircraft are available from this unit to satisfy it					

									--M11_z
									local limitMP = true   --TODO a revoir, semble inutile

									if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "C")
									and ( Debug.Generator.SpySquad and Debug.Generator.SpySquad == draft.name
									or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == draft.target_name ))
									and multiPlaneSet and multiPlaneSet[side] and multiPlaneSet[side][draft.type]
									and multiPlaneSet[side][draft.type][draft.task]
									then
										DebuGenTxt = DebuGenTxt.."\n"..(tostring(draft.id).." AtoG passe C_00_b  ".." "..draft.type
										.." available: "..tostring(available)
										.." < NbPlane? ".. tostring(multiPlaneSet[side][draft.type][draft.task].NbPlane)
										.." MainMPOveRide?: "..tostring(draft.MainMPOveRide)
										.." SupportMPOveRide?: "..tostring(draft.SupportMPOveRide)
									)
									end

									if (draft.flights == nil or draft.number <= available or draft.MainMPOveRide) and limitMP then											--for targets with station time (multiple flights), continue only if sufficient aircraft are availabe. Additional lower scored sorties with less airctaft required will come later 

										--adjust the number of requested aircraft to the number of available aircraft
										if draft.number > available and not draft.MainMPOveRide then
											draft.number = available


											if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "C")
											and ( Debug.Generator.SpySquad and Debug.Generator.SpySquad == draft.name
											or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == draft.target_name ))
											then
												DebuGenTxt = DebuGenTxt.."\n"..(tostring(draft.id).." AtoG passe C_00_c  number "..tostring(draft.number))
											end

										end

										--check if there are enough supports available if supports are required		
										local support_available = true
										-- local supportMandatory = true					

										local need = {}																														--collect the total number of aircraft needed from each unit to complete the package
										need[draft.name] = draft.number																								--number of main body aircraft 
										local avail = {}																													--collect the maximal number of available aircraft from this unit (biggest number of all tasks)
										avail[draft.name] = Aircraft_availability[draft.name].unassigned

										-- if multiPlaneSet_B  then
										-- 	if  multiPlaneSet_B[side] and multiPlaneSet_B[side][unit.type]  and multiPlaneSet_B[side][unit.type][task] then	

										-- 		if multiPlaneSet_B and multiPlaneSet_B[side] and multiPlaneSet_B[side][draft.type] and multiPlaneSet_B[side][draft.type][task] then

										-- 			multiPlaneSet_B[side][draft.type][task].NbPlane = multiPlaneSet_B[side][draft.type][task].InitNbPlaneByTask - draft.number
										-- 		end

										-- 	end

										-- end

										-- ["newTaskRequest"] = 
										-- {
										-- 	["red"] = 
										-- 	{
										-- 		["C-130"] = 
										-- 		{
										-- 			["Transport"] = 
										-- 			{
										-- 				["Escort"] = true,
										-- 			},

										-- 		},
										-- 	},
										-- },

										-- --ajoute une task obligatoire en fonction du learning des missions précédentes
										-- if camp.newTaskRequest then
										-- 	for rSide, rSides in pairs(camp.newTaskRequest) do
										-- 		if rSide == side then
										-- 			for rTypeName, rTypes in pairs(rSides) do
										-- 				if rTypeName == draft.type then
										-- 					for rTaskEnCours, rNewTasks in pairs(rTypes) do
										-- 						if rTaskEnCours == draft.task then
										-- 							for rNewTask, value in pairs(rNewTasks) do
										-- 								if value then
										-- 									for support_name, supportPart in pairs(draft.support) do										--iterate through all package support
										-- 										if type(supportPart) == "table" then	
										-- 											for _plane, support in pairs(supportPart) do
										-- 												if type(support) == "table" and not support.SupportMPOveRide then
										-- 													if  support.number > Aircraft_availability[support.name].unassigned then 
										-- 														support_available = false
										-- 														-- print("AtoG passe support_available FALSE "..draft.target_name.." "..support.name.." "..support.number)
										-- 														-- os.execute 'pause'

										-- 														local TabRejected = {}
										-- 														TabRejected["sujet"]  = draft.id.." type: "..support.type.." newTaskRequest  AVION SUPPORT INSUFFISANTsupport.number < unassigned "
										-- 														TabRejected["cause"] = { [1] = Aircraft_availability[support.name].unassigned, [2] = "newTaskRequest", }
										-- 														TabRejected["ligne"]  = debug.getinfo(1).currentline														
										-- 														table.insert(draft["rejected"], TabRejected)

										-- 													end
										-- 												end
										-- 											end
										-- 										end
										-- 									end	
										-- 									-- print("AtoG passe newTaskRequest "..draft.target_name.." "..rTypeName .." rTaskEnCours: "..rTaskEnCours.." rNewTask: ".. rNewTask)
										-- 									-- os.execute 'pause'

										-- 								end
										-- 							end
										-- 						end
										-- 					end
										-- 				end
										-- 			end
										-- 		end
										-- 	end
										-- end

										-- ["newTaskPerTarget"] = 
										-- {
										-- 	["EWR-Eyeball"] = 
										-- 	{
										-- 		["tasks"] = 
										-- 		{
										-- 			["SEAD"] = 1,
										-- 			["Escort"] = 2,
										-- 		},
										-- 		["difficult"] = 2,
										-- 		["lastNumMission"] = 2,
										-- 	},
										-- 	["North Cyprus-Turkish Force 4"] = 
										-- 	{
										-- 		["tasks"] = 
										-- 		{
										-- 			["SEAD"] = 1,
										-- 		},
										-- 		["difficult"] = 1,
										-- 		["lastNumMission"] = 3,
										-- 	},
										-- },


										
										--en fonction du learning des missions passé, interdit une mission si les task support ne sont pas present

										local tempInfo = draft.id.." AtoG NbTotPlanePerTask CALCUL"
										local draft_availability = Deepcopy(Aircraft_availability)
										if camp.newTaskPerTarget then
											for tableTargetName, targetTask in pairs(camp.newTaskPerTarget) do
												if tableTargetName == draft.target_name and targetTask.tasks then

													for taskLearning, value in pairs(targetTask.tasks) do
														
														local NbTotPlanePerTask = 0
												
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
																			
																			if support.SupportMPOveRide then
																				NbTotPlanePerTask = 9999
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
																					NbTotPlanePerTask = NbTotPlanePerTask + support.number

																					tempInfo = tempInfo .."\nAtoG NbTotPlanePerTask CC "..supportTask.." NbTotPlanePerTask: "..NbTotPlanePerTask
																				end
																			end
																		end
																	end
																end
																if taskRequireInSide and NbTotPlanePerTask < 2 and not draft.SupportMPOveRide then
																	support_available = false

																	tempInfo = tempInfo .."\nAtoG NbTotPlanePerTask REJETE CC "

																	local TabRejected = {}
																	TabRejected["sujet"]  = draft.id.." "..supportTask.." newTaskPerTarget  AVION TOTAL SUPPORT INSUFFISANT NbTotPlanePerTask <= 0 "
																	TabRejected["cause"] = { [1] = NbTotPlanePerTask, [2] = "newTaskPerTarget", }
																	TabRejected["ligne"]  = debug.getinfo(1).currentline
																	table.insert(draft["rejected"], TabRejected)
																end

																-- if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "C")
																-- and ( Debug.Generator.SpySquad and Debug.Generator.SpySquad == draft.name
																-- or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == draft.target_name ))
																-- then
																-- 	DebuGenTxt = DebuGenTxt.."\n"..tempInfo
																-- end

															end

															-- if supportTask == taskLearning then
															-- 	if type(supportPart) == "table" then	
															-- 		for _plane, support in pairs(supportPart) do

															-- 			if type(support) == "table" and not support.SupportMPOveRide then

															-- 				draft_availability[support.name].unassigned = draft_availability[support.name].unassigned - support.number

															-- 				if  draft_availability[support.name].unassigned >= 0 then 
															-- 					support_available = false

															-- 					local TabRejected = {}
															-- 					TabRejected["sujet"]  = draft.id.." "..supportTask.." type: "..support.type.." newTaskPerTarget  AVION SUPPORT INSUFFISANTsupport.number < unassigned "
															-- 					TabRejected["cause"] = { [1] = draft_availability[support.name].unassigned, [2] = "newTaskPerTarget", }
															-- 					TabRejected["ligne"]  = debug.getinfo(1).currentline														
															-- 					table.insert(draft["rejected"], TabRejected)

															-- 				end
															-- 			end
															-- 		end
															-- 	end
															-- end	
														end
													end
												end
											end
										end

										if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "C")
										and ( Debug.Generator.SpySquad and Debug.Generator.SpySquad == draft.name
										or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == draft.target_name ))
										then
											DebuGenTxt = DebuGenTxt.."\n"..tempInfo
										end

										--TODO bizarre, il s agit du nb d avion du main, pas du support
										-- if not draft.MainMPOveRide then
											for unitname,_ in pairs(need) do
												if need[unitname] > avail[unitname] then																						--more aircraft are needed from this unit across all package tasks than are available
													support_available = false																									--not enough support available
													local TabRejected = {}
													TabRejected["sujet"]  = draft.id.." type: "..draft.type.." AVION SUPPORT?Main? INSUFFISANT()support_available if need[unitname] > avail[unitname]"
													TabRejected["cause"] = { tostring(need[unitname]), tostring(avail[unitname]) }
													TabRejected["ligne"]  = debug.getinfo(1).currentline
													table.insert(draft["rejected"], TabRejected)
												end
											end
										-- end

										-- ATO_G_adjustment01 escort mandatory or not
										-- regarde uniquement pour les bombardiers necessitant une escorte

										-- if campMod.strikeOnlyWithEscorte and not draft.loadout.self_escort then
										-- 	if (db_loadouts[draft.type]["Anti-ship Strike"] or db_loadouts[draft.type]["Strike"])  then	
										-- 		local break_loop = false
										-- 		for n_squad, squad in pairs(oob_air[side]) do

										-- 			if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "C") 
										-- 			and ( Debug.Generator.SpySquad and Debug.Generator.SpySquad == draft.name 
										-- 			or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == draft.target_name ))
										-- 			then
										-- 				DebuGenTxt = DebuGenTxt.."\n"..(tostring(draft.id).." AtoG III passe SWE _01 "..draft.type.." "..squad.type ) 
										-- 			end

										-- 			if draft.MainMPOveRide or ((squad.tasks["Anti-ship Strike"]  or squad.tasks["Strike"] ) and squad.type == draft.type) then
										-- 				local needSupport = {}																														--collect the total number of aircraft needed from each unit to complete the package																							--number of main body aircraft 
										-- 				local availSupport = {}																													--collect the maximal number of available aircraft from this unit (biggest number of all tasks)

										-- 				if not needSupport[draft.name] then needSupport[draft.name] = 0 end
										-- 				if not availSupport[draft.name] then availSupport[draft.name] = 0 end
										-- 				needSupport[draft.name] =  Deepcopy(draft.number)	

										-- 				--TODO comment ça marche? ça a l'air inutile....
										-- 				availSupport[draft.name] =  Aircraft_availability[draft.name].unassigned

										-- 				for _p,_support in pairs(draft.support) do																							--iterate through support in draft sortie	
										-- 					if 	type(_support) == "table" then	
										-- 						for _a,support in pairs(_support) do											
										-- 							if 	type(support) == "table" then

										-- 								if not needSupport[support.name] then needSupport[support.name] = 0 end																															
										-- 								if not availSupport[support.name] then availSupport[support.name] = 0 end																

										-- 								needSupport[support.name] =  needSupport[support.name] + support.number																	--add number of support aircraft from same unit
										-- 								availSupport[support.name] =  Aircraft_availability[support.name].unassigned														

										-- 							end
										-- 						end
										-- 					end
										-- 				end		

										-- 				--TODO encore utile ça?												
										-- 				for Sname,_ in pairs(needSupport) do 
										-- 					-- print("AtoG NeedName"..Sname.." |Need| "..needSupport[Sname].." |dispo| "..availSupport[Sname])
										-- 					if needSupport[Sname] - (needSupport[Sname] * 0.25)  > availSupport[Sname] then	
										-- 					----more aircraft are needed from this unit across all package tasks than are available
										-- 						-- print("AtoG TabRejected: Necessaire: "..needSupport[Sname].." >  Dispo "..availSupport[Sname])
										-- 						support_available = false																									--not enough support available
										-- 							local TabRejected = {}
										-- 							TabRejected["sujet"]  = draft.id.." BOMBARDIER NECESSITANT ESCORTE()support_available if needSupport[Sname] - (needSupport[Sname] * 0.15) > availSupport[Sname]"
										-- 							TabRejected["cause"] = { [1] =  needSupport[Sname] - (needSupport[Sname] * 0.25), [2] = availSupport[Sname], }
										-- 							TabRejected["ligne"]  = debug.getinfo(1).currentline														
										-- 							table.insert(draft["rejected"], TabRejected)
										-- 					end
										-- 				end
										-- 			end
										-- 		end
										-- 	end	
										-- end


										-- s il n y a qu un avion d escorte, on bache la mission
										--obliger de regarder la demande total du package, par rapport aux existants

										local dispoTmp = Deepcopy(Aircraft_availability)

										--enleve deja l effectif du main (il peut y avoir 4 F18 strike et 2f18 sead ou escorte)
										dispoTmp[draft.name].unassigned = dispoTmp[draft.name].unassigned - draft.number

										for supportTask, supports in pairs(draft.support) do																							--iterate through support in draft sortie
											if support_available and type(supports) == "table" then
												for supportName, support in pairs(supports) do																							--iterate through support in draft sortie
													if 	type(support) == "table"  then --and support.name ~= nil	

														if support.number == nil or dispoTmp[support.name].unassigned == nil then
															print("AtoG bugA1 supportTask|"..supportTask.."|supportName:|"..tostring(supportName).."|"..tostring(support.name).." no unassigned "..tostring(support.number))

															-- local test_str = "draft = " .. TableSerialization(draft, 0)						--make a string
															-- local testFile = io.open("Debug/draft_support__AtoG.lua", "w")								--open targetlist file
															-- testFile:write(test_str)															--save new data
															-- testFile:close()

															os.execute 'pause'
														end


														--si c'est un task d'une demande MP, on chunte la restrition plus loin
														--TODO pourquoi le coef est plus important sur d'autre élément que lorsqu'on demande notre target?
														local MultiPlayerOveRide  = false
														if multiPlaneSet[side] and multiPlaneSet[side][draft.type] then
															MultiPlayerOveRide = true
														end

														if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "C")
														and ( Debug.Generator.SpySquad and Debug.Generator.SpySquad == draft.name
														or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == draft.target_name ))
														then

															DebuGenTxt = DebuGenTxt.."\n"..(tostring(draft.id).." AtoG passe C_00_h  we don't accept a single aircraft as escort supportTask "..supportTask.." draft.task "..tostring(draft.task))
														end

														if (support.number >= 2 and dispoTmp[support.name].unassigned < 2 and draft.task ~= supportTask) and not MultiPlayerOveRide and mission_ini.strikeOnlyWithEscorte then

															support_available = false																									--not enough support available

															local TabRejected = {}
															TabRejected["sujet"]  = support.id.." type: "..support.type.." we don't accept a single aircraft as escort "..supportName
															TabRejected["cause"] = { "support.number: ",support.number, "unassigned:" , tostring(dispoTmp[support.name].unassigned), " available: ", tostring(dispoTmp[support.name].aircraft_available), "supportName: ", tostring(supportName), " task: ", tostring(draft.task)  }
															TabRejected["ligne"]  = debug.getinfo(1).currentline
															table.insert(draft["rejected"], TabRejected)
														else
															dispoTmp[support.name].unassigned = dispoTmp[support.name].unassigned - support.number
														end

													end
												end
											end
										end

										if support_available and not draft.MainMPOveRide and mission_ini.strikeOnlyWithEscorte then

											local tracing = false
											local txtTracing = ""
											if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "C")
											and ( Debug.Generator.SpySquad and Debug.Generator.SpySquad == draft.name
											or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == draft.target_name ))
											then
												-- DebuGenTxt = DebuGenTxt.."\n".. TableSerialization(draft.loadout.support, 0)  
												-- DebuGenTxt = DebuGenTxt.."\n".. TableSerialization(draft.support, 0)

												DebuGenTxt = DebuGenTxt.."\n"..(tostring(draft.id).." AtoG passe C_01_a  strikeOnlyWithEscorte number "..tostring(draft.number))

												-- tracing = true
											end

											local tmpTxt = ""
											for _p,_support in pairs(draft.support) do																							--iterate through support in draft sortie
												tmpTxt = tmpTxt .."_A_ "

												if support_available and type(_support) == "table" then
													tmpTxt = tmpTxt .." _B_ "

													for supportName, support in pairs(_support) do																							--iterate through support in draft sortie
														tmpTxt = tmpTxt .." _C_supportName: "..tostring(supportName)

														if 	type(support) == "table" then
															tmpTxt = tmpTxt .." _D_support.number: "..tostring(support.number).." >? "..Aircraft_availability[support.name].unassigned

															if support.number > Aircraft_availability[support.name].unassigned then															--not enough aircraft available from this unit for this task
																tmpTxt = tmpTxt .." _E_ "
																if tracing then txtTracing = txtTracing .. "Passe 1E EJECT".."\n" end

																support_available = false																									--not enough support available

																local TabRejected = {}
																TabRejected["sujet"]  = support.id.." type: "..support.type.." (strikeOnlyWithEscorte) support_available if support.number > Aircraft_availability[support.name].unassigned "..supportName
																TabRejected["cause"] = { [1] =  support.number, [2] = Aircraft_availability[support.name].unassigned, }
																TabRejected["ligne"]  = debug.getinfo(1).currentline
																table.insert(draft["rejected"], TabRejected)

															end
														end
													end
												end
											end

											tmpTxt = tmpTxt .. "\n".."Passe 20 "..tostring(draft.type).." "..tostring(draft.target_name).."\n"

											--si escorte obligatoire(pévu dans le loadout main) et qu'il n'y en a pas de prévu, on shunt
											if support_available and draft.loadout.support then																									--main body loadout support requirements
												for loadoutNeedTask, loadoutNeedTaskValue in pairs(draft.loadout.support) do																		--iterate through support requirements of loadout
													if draft.loadout.support[loadoutNeedTask]   then
														local foundOnePlane = false
															for planeSupport, support in pairs(draft.support[loadoutNeedTask]) do
															tmpTxt = tmpTxt .. "Passe 2D "..tostring(planeSupport).."\n"

															if type(support) == "table" then
																tmpTxt = tmpTxt .. "Passe 2E ".."\n"

																if support.name  then
																	tmpTxt = tmpTxt .. "Passe 2H "..tostring(support.name).."\n"

																	foundOnePlane = true
																end
															end
														end

														if not foundOnePlane then
															tmpTxt = tmpTxt .. "Passe 2J EJECT".."\n"

															support_available = false																							--necessary support is not available

															local TabRejected = {}
															TabRejected["sujet"]  = draft.id.." type: ".." aucun SUPPORT "..tostring(loadoutNeedTask)
															TabRejected["cause"] = { [1] =  draft.support["support"], [2] = "", }
															TabRejected["ligne"]  = debug.getinfo(1).currentline
															table.insert(draft["rejected"], TabRejected)

															-- print("tmpTxt "..tmpTxt)
															-- os.execute 'pause'
														end
													end
												end
											end


											for _p,_support in pairs(draft.support) do																							--iterate through support in draft sortie
												tmpTxt = tmpTxt .."_B1_"
												if support_available and type(_support) == "table" then
													tmpTxt = tmpTxt .."_B2_"
													for _,support in pairs(_support) do																							--iterate through support in draft sortie
														tmpTxt = tmpTxt .."_B3_"
															if 	type(support) == "table" then
															tmpTxt = tmpTxt .."_B4_"

															if Aircraft_availability[support.name].unassigned <=0 then
																tmpTxt = tmpTxt .."_B5_"

																if tracing then txtTracing = txtTracing .. "Passe 3E EJECT".."\n" end

																support_available = false

																local TabRejected = {}
																TabRejected["sujet"]  = draft.id.." type: "..support.type.." (strikeOnlyWithEscorte) AVION SUPPORT INSUFFISANT()support_available if Aircraft_availability[support.name].unassigned <=0"
																TabRejected["cause"] = { [1] = Aircraft_availability[support.name].unassigned, [2] = "", }
																TabRejected["ligne"]  = debug.getinfo(1).currentline
																table.insert(draft["rejected"], TabRejected)
															end
														end
													end
												end
											end

											if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "C")
											and ( Debug.Generator.SpySquad and Debug.Generator.SpySquad == draft.name
											or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == draft.target_name ))
											then
												DebuGenTxt = DebuGenTxt.."\n"..txtTracing.."\n"..tmpTxt

												DebuGenTxt = DebuGenTxt.."\n"..(tostring(draft.id).." AtoG passe C_01_b strikeOnlyWithEscorte "..draft.type.." "..draft.task.." support_available: "..tostring(support_available) )

											end
										end

										--si c'est un task d'une demande MP, on chunte la restrition plus loin
										local MultiPlayerOveRide  = false
										if multiPlaneSet[side] and multiPlaneSet[side][draft.type] and multiPlaneSet[side][draft.type][draft.task]
											-- and support.number < Aircraft_availability[support.name].unassigned
										then
											MultiPlayerOveRide = true

											if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "C")
											and ( Debug.Generator.SpySquad and Debug.Generator.SpySquad == draft.name
											or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == draft.target_name ))
											then
												DebuGenTxt = DebuGenTxt.."\n"..(tostring(draft.id).." AtoG passe C_02a "..draft.type.." "..draft.task )
											end
										end

										if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "C")
										and ( Debug.Generator.SpySquad and Debug.Generator.SpySquad == draft.name
										or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == draft.target_name ))
										then
											
											DebuGenTxt = DebuGenTxt.."\n"..(tostring(draft.id).." AtoG passe C_02b serviceable: "
														..tostring(Aircraft_availability[draft.name].serviceable)
														.." |available: "..tostring(Aircraft_availability[draft.name].available)
														.." >? "..tostring(Aircraft_availability[draft.name].available / denom_NeDonnePasTOUT))
										end

										-- modification M11.u : Multiplayer	(u: reserve avion Escorte)
										-- interdit aux possible avion d'escorte de tout donner dans CAP ou Intercept
										
										if not MultiPlayerOveRide and (draft.task == "CAP" or draft.task == "Intercept" )   then

											for n_squad, squad in pairs(oob_air[side]) do
												if squad.type == draft.type and squad.name == draft.name and ((squad.tasks["Escort"] and squad.tasks["Escort"] == true)
												or  (squad.tasks["SEAD"] and squad.tasks["SEAD"] == true) or  (squad.tasks["Strike"] and squad.tasks["Strike"] == true)  )
												then
													
													local test_Aircraftnumber = draft.number
													local test = false

													if Aircraft_availability[draft.name].unassigned - test_Aircraftnumber < 4 then
														test_Aircraftnumber = test_Aircraftnumber -2
													else
														test = true
													end

													draft.number = test_Aircraftnumber

													if not test then
														support_available = false

														if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "C")
														and ( Debug.Generator.SpySquad and Debug.Generator.SpySquad == draft.name
														or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == draft.target_name ))
														then
															DebuGenTxt = DebuGenTxt.."\n"..(tostring(draft.id).." AtoG passe C_03  "..squad.type.." "..draft.task)
														end


														local TabRejected = {}
														TabRejected["sujet"]  = draft.id.." NE DONNE PAS TOUT en CAP ou Intercept ()support_available if Aircraft_availability[draft.name].unassigned - draft.number <= Aircraft_availability[draft.name].serviceable/3"
														TabRejected["cause"] = { " unassigned - draft.number: ", tostring(Aircraft_availability[draft.name].unassigned - draft.number), "serviceable/ denom_NeDonnePasTOUT: ", tostring(Aircraft_availability[draft.name].serviceable/ denom_NeDonnePasTOUT) }
														TabRejected["ligne"]  = debug.getinfo(1).currentline
														table.insert(draft["rejected"], TabRejected)

													end
												end
											end
										end

										-- ne donne pas tout aux strike si du sead est possible en task escadrille
										--bug avec de petite campagne comme le Tchad
										--TODO prevoir seulement si SEAD prévu, ou pas.
										-- if testCode then
										-- 	if not MultiPlayerOveRide and (draft.task == "Strike" or draft.task == "Anti-ship Strike" )   then	--and (Aircraft_availability[draft.name].serviceable > (Aircraft_availability[draft.name].available / 1.01 ))
										-- 		local break_loop = false
										-- 		for n_squad, squad in pairs(oob_air[side]) do
										-- 			if squad.type == draft.type and squad.name == draft.name and ( squad.tasks["Escort"] or squad.tasks["SEAD"] or squad.tasks["Laser Illumination"]   ) then --squad.tasks["Fighter Sweep"] or or squad.tasks["Fighter Sweep"]
										-- 				--Aircraft_availability[support.name].unassigned
										-- 				if Aircraft_availability[draft.name].unassigned - draft.number <= Aircraft_availability[draft.name].serviceable / 2 then
										-- 					support_available = false

										-- 					if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "C") 
										-- 					and ( Debug.Generator.SpySquad and Debug.Generator.SpySquad == draft.name 
										-- 					or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == draft.target_name ))
										-- 					then
										-- 						DebuGenTxt = DebuGenTxt.."\n"..(tostring(draft.id).." AtoG passe C_03  "..draft.type.." "..draft.task) 
										-- 					end
										-- 						local TabRejected = {}
										-- 						TabRejected["sujet"]  = draft.id.." NE DONNE PAS TOUT en Strike ()support_available if Aircraft_availability[draft.name].unassigned - draft.number <= Aircraft_availability[draft.name].serviceable/6"
										-- 						TabRejected["cause"] = { [1] = Aircraft_availability[draft.name].unassigned - draft.number, [2]  = Aircraft_availability[draft.name].serviceable/3, }
										-- 						TabRejected["ligne"]  = debug.getinfo(1).currentline														
										-- 						table.insert(draft["rejected"], TabRejected)	

										-- 					break_loop = true																		
										-- 					break
										-- 				end
										-- 			end
										-- 			if break_loop == true then
										-- 				break																							
										-- 			end
										-- 		end
										-- 	end
										-- end

										if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "C")
										and ( Debug.Generator.SpySquad and Debug.Generator.SpySquad == draft.name
										or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == draft.target_name ))
										then
											DebuGenTxt = DebuGenTxt.."\n"..(tostring(draft.id).." AtoG passe C_04  support_available "..tostring(support_available).." MultiPlayerOveRide: "..tostring(MultiPlayerOveRide))
										end


										if support_available  then																		--continue if no support is required or enough support is available to create package
											--add new package to ATO
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
											pack_n = pack_n + 1

											--add flights of 1, 2 or 4 aircraft to package
											local function AddFlight(assign, role, entry)

												local assigned
												while assign > 0 do																		--loop as long as there are aircraft to assign

													local debugA = ""
													local debugE = ""

													if entry.flights then																--for multiple flights with station time (CAP, AWACS, Tanker etc.)
														local flightsize = math.ceil(draft.target.firepower.max / draft.loadout.firepower)	--how many aircraft should be in each flight
														debugA = "assign: "..assign.." >=? flightsize: "..flightsize
														if assign >= flightsize then													--if there are more aircraft left to assign than the size of one flight
															assigned = flightsize														--assign one full flight
															debugA = debugA .." ||if assign >= flightsize: assigned: "..assigned
														else																			--if there are less aircraft left to assign than size of one flight
															assigned = assign
															debugA = debugA .." ||else assigned: "..assigned												--assign whatever is left
														end

														if entry.task == "CAP" then
															if assigned < 2 then
																assigned = 2
															end
														end

														entry.flights = entry.flights - 1												--one less flight to assign

														debugA = debugA .." ||result entry.flights: "..entry.flights

													elseif  entry.task == "Escort Jammer" or entry.task == "Flare Illumination" or entry.task == "Laser Illumination" then		--for tasks with single aircraft
														assigned = 1																	--assign one aircraft per flight	
													elseif entry.task == "Transport" then
														if multiPlaneSet and multiPlaneSet[side] and multiPlaneSet[side][draft.type]  and multiPlaneSet[side][draft.type][entry.task] then
															assigned = assign
														else
															assigned = 1
														end

													elseif entry.task == "Intercept" then
														if assign >= 4 then																--if more than 2 aircraft are to be assigned
															assigned = 4																--assign flight of 2 aircaft
														-- if assign >= 2 then																--if more than 2 aircraft are to be assigned
														-- 	assigned = 2
														else
															assigned = 2																--else assign flight of 1 aicraft
														end
													elseif (entry.type == "S-3B" or entry.type == "F-117A" or entry.type == "B-1B" or entry.type == "B-52H" or entry.type == "Tu-22M3" or entry.type == "Tu-95MS" or entry.type == "Tu-142" or entry.type == "Tu-160" or entry.type == "MiG-25RBT")
														and entry.task ~= "Runway Attack" then	--for bombers
														assigned = 1																	--assigne one aircraft per flight
													elseif entry.task == "Reconnaissance" then											--for recon
														if assign == 1 then																--if there is one aircraft left to assign
															assigned = 1																--assigne one aircraft per flight
														elseif assign >= 4 then															--if more than 4 aircraft are to be assigned
															assigned = 4																--assign flight of 4 aircaft
														elseif assign == 3 then															--if more than 3 aircraft are to be assigned
															assigned = 3																--assign flight of 3 aircaft
														else
															assigned = 2																--else assign flight of 2 aicraft
														end
													elseif (entry.task == "SAR" or entry.task == "CSAR") and not MultiPlayerOveRide then											--for recon
														assigned = 1
													else																			--for everything else
														debugE = "else BEFORE assigned: if assigned and assign == 1? "..assign

														if assigned and assign == 1 then												--if there is one aircraft left to assign and there was already a previous flight assigned, stop assigning (do not add leftover single-ships)
															break
														elseif assign >= 4 then															--if more than 4 aircraft are to be assigned
															assigned = 4																--assign flight of 4 aircaft
															debugE = debugE .." || elseif assign >= 4 then"
															else
															assigned = assign															--else assign flight size of what is left
														end
														debugE = debugE .. " || elseAFTER assigned: "..assigned
													end

													-- if assign >= 4 then															--if more than 4 aircraft are to be assigned
													-- 	assigned = 4																--assign flight of 4 aircaft
													-- else
													-- 	assigned = assign															--else assign flight size of what is left
													-- end

													if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "C")
													and ( Debug.Generator.SpySquad and Debug.Generator.SpySquad == draft.name
													or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == draft.target_name ))
													then
														DebuGenTxt = DebuGenTxt.."\n"..(tostring(draft.id).." AtoG passe C_04a   _A_" ..debugA.." \r\n _E_ "..debugE.." \r\n assigned "..assigned)
													end

													local flight = {																	--build ATO flight entry
														name = entry.name,
														playable = entry.playable,
														type = entry.type,
														modification = entry.modification,
														callsign = entry.callsign,
														callsignId = entry.callsignId,
														helicopter = entry.helicopter,
														number = assigned,																--number of aircraft in flight
														country = entry.country,
														livery = entry.livery,
														sidenumber = entry.sidenumber,
														liveryModex = entry.liveryModex,
														base = entry.base,
														airdromeId = entry.airdromeId,
														parking_id = entry.parking_id,
														skill = entry.skill,
														task = entry.task,
														loadout = entry.loadout,
														route = {},																		--route is a table and connot be copied as a whole
														target = Deepcopy(entry.target),
														target_name = entry.target_name,
														firepower = assigned * entry.loadout.firepower,
														tot_from = entry.tot_from,
														tot_to = entry.tot_to,
														id = entry.id,
													}
													for r = 1, #entry.route do															--make copy of route table
														flight.route[r] = {}
														for k,v in pairs(entry.route[r]) do
															flight.route[r][k] = v
														end
													end

													if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "C")
													and ( Debug.Generator.SpySquad and Debug.Generator.SpySquad == draft.name
													or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == draft.target_name ))
													then
														DebuGenTxt = DebuGenTxt.."\n"..(tostring(draft.id).." AtoG passe C_05a number "..assigned.." "..entry.task)
													end


													if multiPlaneSet and multiPlaneSet[side] and multiPlaneSet[side][draft.type]  and multiPlaneSet[side][draft.type][draft.task]  then

														multiPlaneSet[side][draft.type][draft.task].NbPlane = multiPlaneSet[side][draft.type][draft.task].NbPlane - assigned

														if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "C")
														and ( Debug.Generator.SpySquad and Debug.Generator.SpySquad == draft.name
														or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == draft.target_name ))
														then
															DebuGenTxt = DebuGenTxt.."\n"..(tostring(draft.id).." AtoG passe C_05b (NbPlane - assigned) "..multiPlaneSet[side][draft.type][draft.task].NbPlane)
														end
													end
			--######################################################################################################################################
			--######################################################################################################################################

			--######################################################################################################################################
			--#############"" insert/create ATO table ##############################################################################################

													table.insert(ATO[side][pack_n][role], flight)										--add flight to package role (main, SEAD or escort)											


													-- for prioriyN, testTargets in pairs(targetNamePrio[side]) do
													-- 	for i, testTarget in pairs(testTargets) do
													-- 		if testTarget.name == entry.target_name then
													-- 			testTarget.check = true
													-- 			print("AtoG BB   ?               __checked__: "..tostring(testTarget.name))
													-- 			break
													-- 		end
													-- 	end
													-- end

													-- table.insert(newDraftByPriority[sidePrio], draft)


			--#############"" insert/create ATO table ##############################################################################################
			--######################################################################################################################################

			--######################################################################################################################################
			--######################################################################################################################################
													-- --store time assigned aircraft are unavailable for future missions
													-- local operating_hours														--time the unit is operating each day
													-- if entry.loadout.day and entry.loadout.night then							--day/night loadout
													-- 	operating_hours = 86400													--full day in seconds
													-- elseif entry.loadout.day then												--day loadout
													-- 	operating_hours = mission_ini.dusk - mission_ini.dawn									--Daytime in seconds
													-- elseif entry.loadout.night then												--night loadout
													-- 	operating_hours = mission_ini.dawn + (86400 - mission_ini.dusk)						--nighttime in seconds
													-- end
													-- local time_to_next_mission = operating_hours / entry.loadout.sortie_rate	--time duration until aircraft can do the next mission based on its sortie rate
													-- if entry.loadout.tStation and #ATO[side][pack_n][role] == 1 then			--for a flight that has a station time and for the first flight in package
													-- 	time_to_next_mission = time_to_next_mission - entry.loadout.tStation	--remove station time from time to next mission, because flight could airstart current mission at close to end of its station time
													-- end

													--boucle transféré a la fin de ATO_Timing
													-- if daysfrom > Aircraft_availability[unit.name].unavailable[u] then
													-- local unavailable = current_time + time_to_next_mission 					--campaign time until this aircraft unavailable for new mission
													-- local unavailable = daysfrom + (time_to_next_mission / (24 * 60 * 60))		-- seconds in a day

													-- for a = 1, assigned do														--iterate through all assigned aircraft
													-- 	if #Aircraft_availability[entry.name].unavailable == 0 then
													-- 		table.insert(Aircraft_availability[entry.name].unavailable, unavailable)						--insert unavailable time into unavailable table of this unit
													-- 	else
													-- 		for u = 1, #Aircraft_availability[entry.name].unavailable do
													-- 			if unavailable > Aircraft_availability[entry.name].unavailable[u] then
													-- 				table.insert(Aircraft_availability[entry.name].unavailable, u, unavailable)				--insert unavailable time into unavailable table of this unit sorted from highest to lowest
													-- 				break
													-- 			elseif u == #Aircraft_availability[entry.name].unavailable then
													-- 				table.insert(Aircraft_availability[entry.name].unavailable, u + 1, unavailable)			--insert unavailable time into unavailable table of this unit sorted from highest to lowest
													-- 			end
													-- 		end
													-- 	end
													-- end

													Aircraft_availability[entry.name].assigned = Aircraft_availability[entry.name].assigned + assigned
													Aircraft_availability[entry.name].unassigned = Aircraft_availability[entry.name].unassigned - assigned		--remove assigned aircraft from total number of available aircraft for this unit
													assign = assign - assigned															--continue loop until are aircraft are assigned

													if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "C")
													and ( Debug.Generator.SpySquad and Debug.Generator.SpySquad == draft.name
													or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == draft.target_name ))
													then
														DebuGenTxt = DebuGenTxt.."\n"..(tostring(draft.id).." AtoG passe C_05b   assign "..assign.." type: "..entry.type.." unassigned: "..Aircraft_availability[entry.name].unassigned)
													end

												end
											end

											if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "C")
											and ( Debug.Generator.SpySquad and Debug.Generator.SpySquad == draft.name
											or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == draft.target_name ))
											then
												DebuGenTxt = DebuGenTxt.."\n"..(tostring(draft.id).." AtoG passe C_06b  |AddFlight MAIN| number "..tostring(draft.number))
											end

											AddFlight(draft.number, "main", draft)												--add main body flights to package

											for support_name, supportPart in pairs(draft.support) do										--iterate through all package support
												if type(supportPart) == "table" then
													for _plane, support in pairs(supportPart) do
														local number  = 0
														if type(support) == "table" and support.name  then--and (support.SupportMPOveRide or Aircraft_availability[support.name].unassigned >= 2)

															if support.number >= Aircraft_availability[support.name].unassigned then
																number = Aircraft_availability[support.name].unassigned
															end
															if support.number < Aircraft_availability[support.name].unassigned then
																number = support.number
															end

															if support.SupportMPOveRide then number = support.number end

															if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "C")
															and ( Debug.Generator.SpySquad and Debug.Generator.SpySquad == draft.name
															or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == draft.target_name ))
															then
																DebuGenTxt = DebuGenTxt.."\n"..(tostring(draft.id).." AtoG passe C_07  |AddFlight SUPPORT| numberFINAL "..tostring(number).." support_name: "..support_name.." unassigned: "..tostring(Aircraft_availability[support.name].unassigned))
															end

															AddFlight(number, support_name, support)										--add support flights to package

														else
															-- if type(support) ~= "table" then
															-- 	txt0 = "support != table "
															-- 		.." OveRide?: "..tostring(draft.MainMPOveRide)
															-- 		.." type: "..tostring(draft.type)
															-- 		.." key: "..tostring(_plane)
															-- 		.." supportPart(_plane): "..tostring(supportPart[_plane]) 
															-- 		.." support: "..tostring(support) 
															-- 		.." supportPart: "..tostring(supportPart) 
															-- 		.." || "

															-- 		if Debug.Generator.affiche and string.find(Debug.Generator.chapter, "C") 
															-- 		and ( Debug.Generator.SpySquad and Debug.Generator.SpySquad == draft.name 
															-- 		or (Debug.Generator.SpyTarget and Debug.Generator.SpyTarget == draft.target_name ))
															-- 		then
															-- 			DebuGenTxt = DebuGenTxt.."\n"..(tostring(draft.id).." AtoG passe C_08")
															-- 			DebuGenTxt = DebuGenTxt.."\n"..(txt0)
															-- 			-- _affiche(supportPart, "supportPart")
															-- 		end	



															-- txt0 = draft.id.." IN AddFlight: type(support) ~= table or support_name "
															-- 	.." OveRide?: "..tostring(draft.MainMPOveRide)
															-- 	.." "..tostring(draft.type) 
															-- 	.." support_name: "..tostring(support_name)
															-- 	-- .."\n".. TableSerialization(draft.loadout, 0)  



															-- local TabRejected = {}
															-- TabRejected["sujet"]  = txt0
															-- TabRejected["cause"] = { [1] = support_available, [2]  = "", }
															-- TabRejected["ligne"]  = debug.getinfo(1).currentline
															-- table.insert(draft["rejected"], TabRejected)

														end
													end
												else
													local TabRejected = {}
													TabRejected["sujet"]  = draft.id.." IN AddFlight type(supportPart) == table"
													TabRejected["cause"] = { "support_available: ", tostring(support_available) }
													TabRejected["ligne"]  = debug.getinfo(1).currentline
													table.insert(draft["rejected"], TabRejected)
												end
											end

											--remove the firepower applied by package to target from maximum firepower of all other draft sorties to the same target
											local firepower_applied = 0																	--collect the amount of firepower combined by all main body flights of this package
											for f = 1, #ATO[side][pack_n].main do														--iterate through all main body flights
												firepower_applied = firepower_applied + ATO[side][pack_n].main[f].firepower				--sum firepower
											end
											-- for allSide, allDrafts in pairs(Draft_sorties) do
											-- -- for m = 1, #draft do
											-- 	for allN, allDraft in pairs(allDrafts) do																		--iterate through all draft sorties again
											-- 		-- print("AtoG AA draft.target_name: "..draft.target_name.." allDraft "..allDraft.target_name)
											-- 		if draft.target_name == allDraft.target_name then									--if draft sortie with same target as present package is found
											-- 			print("AtoG   --> BB "..tostring(allDraft.multipack).." "..tostring(draft.target_name))

											-- 			if allDraft.multipack then															--target has a fixed requirement for number of packages 
											-- 				allDraft.multipack = allDraft.multipack - 1										--reduce number of packages per one
											-- 				if allDraft.target.firepower.packmin then											--target has a fixed requirement for minimal number of packages 
											-- 					allDraft.target.firepower.packmin = allDraft.target.firepower.packmin - 1		--reduce number of minimal packages per one
											-- 				end
											-- 			else																				--target is stricly firepower controlled
											-- 				allDraft.target.firepower.max = allDraft.target.firepower.max - firepower_applied	--remove the firepower applied by current package from maximum firepower for this sortie
											-- 				allDraft.number = math.ceil(allDraft.number - (firepower_applied / allDraft.loadout.firepower))	--reduce the number of aircraf to be assigned to this sortie as a result of the firepower reduction
											-- 			end
											-- 		end
											-- 	end
											-- end

											if multipackByTargetName[draft.target_name] then
												multipackByTargetName[draft.target_name] = multipackByTargetName[draft.target_name] -1
											end

											--status report
											status_counter_ATO = status_counter_ATO + 1
											--print("ATO Generation (" .. status_counter_ATO .. ")")	--DEBUG
										else
											local TabRejected = {}
											TabRejected["sujet"]  = draft.id.." SUPPORT IMPOSSIBLE()if support_available"
											TabRejected["cause"] = { "support_available: ", tostring(support_available) }
											TabRejected["ligne"]  = debug.getinfo(1).currentline
											table.insert(draft["rejected"], TabRejected)
										end
									else
										local TabRejected = {}
										TabRejected["sujet"]  = draft.id.." AVIONS INSUFFISANT()if draft.number <= available and limitMP then {draft.number, limitMP}"
										TabRejected["cause"] = {"draft.number: ", tostring(draft.number), "limitMP: ", tostring(limitMP)}
										TabRejected["ligne"]  = debug.getinfo(1).currentline
										table.insert(draft["rejected"], TabRejected)
									end
								else
									--if draft.target.firepower.packmin == nil or available * draft.loadout.firepower >= (draft.target.firepower.packmin - 1) * draft.target.firepower.max + draft.target.firepower.min
									local TabRejected = {}
									TabRejected["sujet"]  = draft.id.." FIREPOWER du PACKAGE INSUFFISANT()if  available * draft.loadout.firepower >= (draft.target.firepower.packmin - 1) * draft.target.firepower.max"
									TabRejected["cause"] = { [1] = tostring(available * draft.loadout.firepower), [2]  = tostring((draft.target.firepower.packmin - 1) * draft.target.firepower.max), }
									TabRejected["ligne"]  = debug.getinfo(1).currentline
									table.insert(draft["rejected"], TabRejected)
								end
							else
								local TabRejected = {}
								TabRejected["sujet"]  = draft.id.." "..tostring(draft.type).." AVION DISPONIBLE INSUFFISANT "..tostring(draft.name).." ()if available * draft.loadout.firepower >= draft.target.firepower.min and draft.number * draft.loadout.firepower >= draft.target.firepower.min"
								TabRejected["cause"] = { [1] = tostring(available * draft.loadout.firepower), [2]  = tostring(draft.target.firepower.min), }
								TabRejected["ligne"]  = debug.getinfo(1).currentline
								table.insert(draft["rejected"], TabRejected)
							end
						else
							local TabRejected = {}
							TabRejected["sujet"]  = draft.id.." FIREPOWER INSUFFISANT (a augmenter dans loadout)if draft.target.firepower.max > 0 and draft.target.firepower.max >= draft.target.firepower.min"
							TabRejected["cause"] = { [1] = tostring(draft.target.firepower.max), [2]  = tostring(draft.target.firepower.max), }
							TabRejected["ligne"]  = debug.getinfo(1).currentline
							table.insert(draft["rejected"], TabRejected)
						end
					else
						local TabRejected = {}
						TabRejected["sujet"]  = draft.id.." MultiPACKAGE A 0 (?)if draft.multipack == nil or draft.multipack > 0 || target_name: "..tostring(draft.target_name).." || multipack: " ..tostring(draft.multipack)
						TabRejected["cause"] = { [1] = tostring(draft.multipack), [2]  = tostring(draft.multipack), }
						TabRejected["ligne"]  = debug.getinfo(1).currentline
						table.insert(draft["rejected"], TabRejected)
					end
				else
					local TabRejected = {}
					TabRejected["sujet"]  = draft.id.." MENACE TROP IMPORTANTE (descendre minscore ou diminuer Menace AA AS) draft.loadout.minscore <= draft.score"
					TabRejected["cause"] = { [1] = tostring(draft.loadout.minscore), [2]  = tostring(draft.score), }
					TabRejected["ligne"]  = debug.getinfo(1).currentline
					table.insert(draft["rejected"], TabRejected)
				end
			end
		end
	end
end



-- _affiche(Draft_sorties.blue[1], "Draft_sorties.blue[1]")
-- _affiche(Draft_sorties.red[1], "Draft_sorties.red[1]")

local function showAtoSort(newDraftByPriority, tablePrio)

	local ShowSquad
	local ShowTarget

	if Debug.Generator.SpySquad then
		ShowSquad = Debug.Generator.SpySquad
	end
	if Debug.Generator.SpyTarget  then
		ShowTarget = Debug.Generator.SpyTarget
	end


	-- local ShowSquad = "111.Filo"

	for side, sorties in pairs(newDraftByPriority) do
		local di = 1
		DebuGenTxt = DebuGenTxt.."\n"..(side.."  PART C ")
		for draft_n, draft in pairs(sorties) do
			local NameOK = false
			if draft.target_name == ShowTarget then
				NameOK = true
			end
			for _PlaneTask, PlaneTask in pairs(draft.support) do
				for taskName, task in pairs(PlaneTask) do
					if type(task) == "table" then
						if task.name == ShowSquad  then
							NameOK = true
						end
					end
				end
			end

			if di < Debug.Generator.nb or draft.name == ShowSquad or NameOK  then
				DebuGenTxt = DebuGenTxt.."\n"..(	side.." tablePrio: "..tablePrio.." C N° " .. draft_n..
						-- " /support/ " ..tostring(draft.support)..
						" /Id" ..tostring(draft.id)..
						" /Prioriry/ " ..tostring(draft.priorityIni)..
						" /name/ " ..draft.name..
						" /Nb/ " ..draft.number..
						" /Type/ "..draft.type..
						" /Tot_to/ "..draft.tot_to ..
						" /threatsGround/ "..round(draft.threatsGround)..
						" /threatsAir/ "..round(draft.threatsAir)..
						" /Score/ " ..round(draft.score)..
						" /Task/ "..draft.task..
						" /Target/ "..tostring(draft.target_name)..
						" /LoadName/ "..tostring(draft.loadout.name)
						)
				di = di +1
				for _PlaneTask, PlaneTask in pairs(draft.support) do
					for taskName, task in pairs(PlaneTask) do
						if type(task) == "table" and task.target_name and task.loadout then
							DebuGenTxt = DebuGenTxt.."\n"..(	"    ---> Nsupport " .._PlaneTask.." ".. taskName..
									" /Id" ..tostring(task.id)..
									" /name/ " ..task.name..
									" /Nb/ " ..task.number..
									" /escort_max/ " ..tostring(PlaneTask.escort_max)..
									" /SupportName/ "..task.name..
									" /Type/ "..task.type..
									" /Task/ "..task.task..
									" /NbTotSupt/ " ..tostring(task.NbTotalSupport)..
									" /Target/ "..task.target_name..
									" /LoadName/ "..tostring(task.loadout.name)
									)
						end
					end
				end
				if draft.rejected then
					for id, _rejected in pairs(draft.rejected) do

						--ecrit les causes:
						local causeTxt = ""
						for causeN, cause_ in ipairs(_rejected.cause) do
							causeTxt = causeTxt .. " |#"..causeN.."->| "..tostring(cause_)
						end
						DebuGenTxt = DebuGenTxt.."\n"..(	" rejected/ ".._rejected.sujet..
							" / cause " ..causeTxt..
							" / ligne " ..tostring(_rejected.ligne)
							)
					end
				end
				DebuGenTxt = DebuGenTxt.."\n"
			end
		end
	end
end

if #Draft_sorties.blue == 0 then
	print("AtoG ERROR no route could be generated in blue camp? ")
	-- os.execute 'pause'
elseif #Draft_sorties.red == 0 then
	print("AtoG ERROR no route could be generated in red camp? ")
	-- os.execute 'pause'
end

--creation de la table multipack (systeme cassé a cause du decoupage draft_sortie en plusieurs morceau/priorité)
multipackByTargetName = {}
for side, drafts in pairs(Draft_sorties) do
	for draftN, draft in ipairs(drafts)do
		if not multipackByTargetName[draft.target_name] then  multipackByTargetName[draft.target_name] = 0 end

		if multipackByTargetName[draft.target_name] < draft.multipack then
			multipackByTargetName[draft.target_name] = draft.multipack
		end
	end
end


-- local priorityRef = {
-- 	blue =0,
-- 	red = 0,
-- }
-- local newDraftByPriority = {
-- 	blue = {},
-- 	red = {},
-- }

-- --creation du targetlist par ordre de priorité
-- local targetListPrio = {
-- 	blue = {},
-- 	red = {},
-- }
-- local targetListPrioCheck = {
-- 	blue = {},
-- 	red = {},
-- }
-- local targetNamePrio = {
-- 	blue = {},
-- 	red = {},
-- }
for targetSide, targets in pairs(targetlist) do
	for targetN, target in pairs(targets) do
		if not target.inactive and target.ATO  then  --and (target.task == "Strike" or  target.task == "Anti-ship Strike" or target.task == "Runway Attack")

			--util pour eviter de cibler les memes target
			if not targetNamePrio[targetSide][target.priority] then targetNamePrio[targetSide][target.priority] = {} end
			local tempValue = {
				name = target.titleName,
				check = false,
				priority = target.priority,
			}
			table.insert(targetNamePrio[targetSide][target.priority], tempValue)

			--necessaire pour trier par ordre de priorité
			if not targetListPrioCheck[targetSide][target.priority] then
				table.insert(targetListPrio[targetSide], target.priority)
				targetListPrioCheck[targetSide][target.priority] = true
			end

			if priorityRef[targetSide] < target.priority  then
				priorityRef[targetSide] = target.priority
			end
		end
	end
end

table.sort(targetListPrio["blue"], function(a,b) return a > b  end)
table.sort(targetListPrio["red"], function(a,b) return a > b  end)


for sidePrio, tableauPrio in pairs(targetListPrio) do
	for tableN, tablePrio in pairs(tableauPrio) do
		for draftN, draft in pairs(Draft_sorties[sidePrio]) do
			if draft.priorityIni == tablePrio then
				table.insert(newDraftByPriority[sidePrio], draft)
			end

		end

		table.sort(newDraftByPriority[sidePrio], function(a,b) return a.score > b.score  end)

		createATO_table(newDraftByPriority)

		if Debug.Generator.affiche and newDraftByPriority ~= nil then
			DebuGenTxt = "\n"..DebuGenTxt.." \n Side: "..sidePrio.."  tablePrio "..tostring(tablePrio).."\n"
			showAtoSort(newDraftByPriority, tablePrio)
		end

		newDraftByPriority = {
			blue = {},
			red = {},
		}
	end
end


--calcul le nb d'avion en tout
-- local nbAfterPlaneActifTotal = {
-- 	blue = {
-- 		ready = 0,
-- 		reserve = 0
-- 	},
-- 	red = {
-- 		ready = 0,
-- 		reserve = 0
-- 	},
-- }
-- for side, packages in pairs(ATO) do																								--iterate through all sides	
-- 	for packN, pack in pairs(packages) do
-- 		for task, flights in pairs(pack) do
-- 			for task, flights in pairs(pack) do




--remet la valeur de priority correct, si elle avait été changée par un choix multijoueur
-- for kGroupN, multiGroup in pairs(Multi.Group) do
for targetSide, targets in pairs(targetlist) do
	for targetN, target in pairs(targets) do
		if  target.priorityINIT  then
			target.priority = Deepcopy(target.priorityINIT)
			target.priorityINIT = nil
		end
	end
end


if Debug.debug then

	for side, packages in pairs(ATO) do
		for packN, pack in pairs(packages) do
			for role, flights in pairs(pack) do
				for flightN, flight in pairs(flights) do

					nbAfterPlaneActifTotal[side].used = nbAfterPlaneActifTotal[side].used + flight.number

				end
			end
		end
	end

	_affiche(nbBeforPlaneActifTotal, "nbBeforPlaneActifTotal")

	_affiche(nbAfterPlaneActifTotal, "nbAfterPlaneActifTotal")

	local show = false
	local resultPourcent =  nbAfterPlaneActifTotal.blue.used / nbBeforPlaneActifTotal.blue.ready * 100
	if resultPourcent < 40 then
		print("AtoG caution, not enough BLUE aircraft used compared to available aircraft. Maybe a bug? "..resultPourcent.." %")
		show = true
	end

	resultPourcent =  nbAfterPlaneActifTotal.red.used / nbBeforPlaneActifTotal.red.ready * 100
	if resultPourcent < 40 then
		print("AtoG caution, not enough RED aircraft used compared to available aircraft. Maybe a bug? "..resultPourcent.." %")
		show = true
	end

	if show then
		os.execute 'pause'
	end
end
-- local oldPriorityValue = 999999
-- --force la creation des package avec les priorite les plus hautes d'abord
-- for side, drafts in pairs(Draft_sorties) do	
-- 	local allPrioCompleted_N = true
-- 	local allPrioCompleted_N_1 = true


-- 	for draftN, draft in ipairs(drafts)do

-- 		if draft.priorityIni == nil then
-- 			_affiche(draft, "draft")
-- 		end

-- 		--il faut garder ce paragraphe en premier
-- 		--sinon un enregistrement qui ne fait pas partie de cette priority va s ajouter
-- 		if priorityRef[side] > draft.priorityIni  then
-- 			table.sort(newDraftByPriority[side], function(a,b) return a.score > b.score  end)

-- 			createATO_table(newDraftByPriority)

-- 			if Debug.Generator.affiche and newDraftByPriority ~= nil then	
-- 				DebuGenTxt = "\n"..DebuGenTxt.." Side: "..side.."  priorityRef "..tostring(oldPriorityValue).."\n" 
-- 				showAtoSort(newDraftByPriority)
-- 			end

-- 			newDraftByPriority = {
-- 				blue = {},
-- 				red = {},
-- 			}
-- 		end

-- 		local strikeTask = false
-- 		if (draft.task == "Strike" or  draft.task == "Anti-ship Strike" or draft.task == "Runway Attack") then
-- 			strikeTask = true
-- 		end

-- 		--cherche si toutes les priority 12(par ex) ont été effectué ou non
-- 		if strikeTask then
-- 			allPrioCompleted_N = true
-- 			if targetListPrio[side][priorityRef[side]] then
-- 				for i, testTarget in pairs(targetListPrio[side][priorityRef[side]]) do
-- 					if not testTarget.check then
-- 						allPrioCompleted_N = false
-- 						break
-- 					end
-- 				end
-- 			end

-- 		end


-- 		if priorityRef[side] > draft.priorityIni  then
-- 			priorityRef[side] = draft.priorityIni
-- 			allPrioCompleted_N_1 = Deepcopy(allPrioCompleted_N)

-- 		end

-- 		local overPasse = false
-- 		-- if not blockOnlyPriority then overPasse = true end

-- 		-- il faut que toutes les cibles de hautes priority soient en cours de traitement avant d'autoriser des cibles de moindre valeur
-- 		-- if not allPrioCompleted or (allPrioCompleted and priorityRef[side] < iPrioActual ) then

-- 		-- if not strikeTask or (allPrioCompleted_N_1 ) or overPasse then
-- 		if not strikeTask or (allPrioCompleted_N_1 ) or overPasse then
-- 			table.insert(newDraftByPriority[side], draft)
-- 			oldPriorityValue = draft.priorityIni
-- 		end
-- 	end
-- end


if Debug.debug and Debug.Generator.affiche and string.find(Debug.Generator.chapter, "C") then

	local camp_str = "ATO = " .. TableSerialization(ATO, 0)
	local campFile = io.open("Debug/ATO_AtoGenerator.lua", "w")
	if campFile then
		campFile:write(camp_str)
		campFile:close()
	end

	local camp_str = "camp = " .. TableSerialization(camp, 0)
	local campFile = io.open("Debug/CAMP_Ato_Generator.lua", "w")
	if campFile then
		campFile:write(camp_str)
		campFile:close()
	end
end

--place la clef occurence à tous les loadouts
Loadouts_archive = Loadouts_archive or {}
for plane, planeTab  in pairs(Loadouts_archive) do
	for taskName, loadout  in pairs(planeTab) do
		for loadoutName, value  in pairs(loadout) do
			if type(value) == "table" then
				if not value["occurence"] then value["occurence"] = 0 end
			end
		end
	end
end


-- modification M49.c big central db_loadout (c: loadout statistics)
local found = false
for side, pack in pairs(ATO) do
	for p = 1, #pack do
		for role,flight in pairs(pack[p]) do
			for f = 1, #flight do
				local found = false
				for plane, planeTab  in pairs(Loadouts_archive) do
					if plane == flight[f].type then
						for taskName, loadout  in pairs(planeTab) do
							for loadoutName, value  in pairs(loadout) do
								if loadoutName  == flight[f].loadout.name then
									if not value["occurence"] or value["occurence"] == nil or value["occurence"] == " " then value["occurence"] = 0 end
									value["occurence"] = value["occurence"] + 1
									found = true
									break
								end
								if found then break end
							end
							if found then break end
						end
						if found then break end
					end
					if found then break end
				end
			end
		end
	end
end


local s = ""
--place la clef occurence à tous les loadouts
for plane, planeTab  in pairs(Loadouts_archive) do
	for taskName, loadout  in pairs(planeTab) do
		for loadoutName, value  in pairs(loadout) do
			if type(value) == "table" then
				s = s.."\n"
				s = s..plane
				for i=1, 15 - string.len(plane) do
					s = s.." "
				end

				s = s..taskName
				for i=1, 20 - string.len(taskName) do
					s = s.." "
				end

				if value.occurence == 0 then
					value.occurence = " "
				end
				s = s..value.occurence
				for i=1, 5 - string.len(value.occurence) do
					s = s.." "
				end

				local minsCore = ""
				if value.minscore then minsCore = value.minscore end

				s = s..minsCore
				for i=1, 5 - string.len(minsCore) do
					s = s.." "
				end

				s = s..loadoutName
			end
		end
	end
end

if Debug.Generator and Debug.debug then
	local debugGenMFile = io.open("Debug/AtoGenerator_Debug.txt", "w") or error("Failed to open debug file")
	debugGenMFile:write(DebuGenTxt)
	debugGenMFile:close()
end

if debug.debug then
	local camp_str = "ATO_ATO_PA = " .. TableSerialization(ATO, 0)
	local campFile = io.open("Debug/ATO_AtoG.lua", "w") or error("Échec d'ouverture du fichier ATO_AtoG")
	campFile:write(camp_str)
	campFile:close()
end

--*****************ne pas effacer commenter**********************	
local loadoutSTR = StringToTxt(s)
local dloadoutFile = io.open("Active/loadout_stats.lua", "w") or error("Failed to open debug file")
dloadoutFile:write(loadoutSTR)
dloadoutFile:close()
--***************ne pas effacer commenter	**************************



