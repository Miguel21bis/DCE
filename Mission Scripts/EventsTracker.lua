--To run during mission to track destroyed static objects and trigger debriefing actions on mission end 
--Script attached to mission and executed via trigger
--Requires DCS os and io functions sanitizer to be deactivated
------------------------------------------------------------------------------------------------------- 
-- MBot version 20200111
-------------------------------------------------------------------------------------------------------
-- last modification  M61_j cleanCode_g
if not versionDCE then versionDCE = {} end
versionDCE["Mission Scripts\EventsTracker.lua"] = "1.12.72"
------------------------------------------------------------------------------------------------------- 

-- test_b 					(b: saved game on another DD)
-- Reglage_d 				(d modified TableSerialization)(c CVN to CV)(a: global pathD)
-- debug_p					(op prohibited character of player names)(n getCategory)(m Pedro cycle)(n scene life0)(m escorte)(jkl wrong caratere in player names)(i: base.side = base.coalition)(b: n'affiche pas les messages d'error sauf � la fin de mission)
-- cleanCode_g				(g springCleaning)
-- modification M62_a		compatible Datacard Generator or CombatFlite
-- modification M61_j		SAR (j noSAR in wrongSide)
-- modification M50_c		Records landings for later use in logistics (C-130, Transport...) (bc: caractere interdit)
-- modification M40_i		Pedro Helicopter (i use new follow task)
-- modification M37_e		SuperCarrier
-- modification M35_d		(d: info log) version ScriptsMod
-- modification M18_g		despawn (g info bad coalition)(e: option confMod)(d: active unit) (cf despawn/destroy Plane on BaseAirStart) destroy Plane Landing CV + FARP 
------------------------------------------------------------------------------------------------------- 


env.info("DCETestingConstante: Unit.Category.AIRPLANE "..tostring(Unit.Category.AIRPLANE))
env.info("DCETestingConstante: Unit.Category.HELICOPTER "..tostring(Unit.Category.HELICOPTER))
env.info("DCETestingConstante: Unit.Category.GROUND_UNIT "..tostring(Unit.Category.GROUND_UNIT))
env.info("DCETestingConstante: Unit.Category.SHIP "..tostring(Unit.Category.SHIP))
env.info("DCETestingConstante: Unit.Category.STRUCTURE "..tostring(Unit.Category.STRUCTURE))

-- Last_AddSoldierAliasPilot = 0

-- EjectionSeatFrequency = {}
-- SumSoldierAliasPilot = 0
-- CustomLog = {}

local scenLog = {}
local eventIdTotal = {}
local tabEjection = {}
local despawn = {}
local eventHandlerDCE = {}



local function WarningText()
	local text = "WARNING:\n"
	text = text .. "sanitizeModule('os') in MissionScripting.lua has not been disabled. Mission results will not be accounted and campaign will not progress."
	text = text .. "\n\nMissionScripting.lua gets automatically restored to default state after every DCS update and has to be manually adjusted each time. Modification at your own risk."
	trigger.action.outText(text, 600)
end
local ErrorMessage = timer.scheduleFunction(WarningText, {}, timer.getTime() + 1)	--schedule output of warning text
local check = os.time()															--run random os function. If os functions are sanitized this will fail and stop the script
timer.removeFunction(ErrorMessage)												--if the script continues to here, os functions work and the sdchedzled warning message is removed

-----*********check path**************---------
env.info( "DCE_Bat_Path  "..tostring(camp.path) )

local pathDD = "c:"
--prepare campaign path
PathDCE = string.gsub(camp.path, "/", "\\")																		--replace slashes in campaign path with double-backslashes
if  string.sub (camp.path, 2, 2) ~= ":" then																		--si le chemin est differen de C:\Users ou D:\Users
	PathDCE = os.getenv('USERPROFILE') .. "\\" .. PathDCE																	--get path of windows userprofile and add to campaign path	
else
	pathDD = string.sub (camp.path, 1, 2)
end

PathDCE = PathDCE .."Mods\\tech\\DCE\\Missions\\Campaigns\\"..camp.title.."\\"											-- modification M35.b version ScriptsMod
env.info( "DCE_PathDCE "..tostring(PathDCE) )
env.info( "DCE_pathDD "..tostring(pathDD) )
-----*********check PathDCE**************---------

local function health1s(arg)

	local healthTemp = arg[1]
	local event = arg[2]

	-- PilotName = log_entry.targetPilotName,
	-- typeEvent = log_entry.type,
	-- objSujet
	-- life = life,
	-- health0 = init_life,
	-- health = log_entry.health,

	--TODO ajouter une condition d'existence de l'unite, inutile de demander à un dead

	-- Object.Category
	-- 	UNIT    1
	-- 	WEAPON  2
	-- 	STATIC  3
	-- 	BASE    4
	-- 	SCENERY 5
	-- 	Cargo   6

	local health1sCategory = Object.getCategory(healthTemp.objSujet)
	-- env.info( "DCE_EventT (health1s) targetCategory| "..tostring(health1sCategory))

	if health1sCategory ~= 0 then
		if health1sCategory and ( health1sCategory == 1 or health1sCategory == 3 or health1sCategory == 4)  then
			--Function also works with Unit, Static Object, Airbase
			local tempName = healthTemp.objSujet:getName()
			-- env.info( "DCE_EventT (health1s) |getName| "..tostring(tempName))

			if health1sCategory == 3 then
				local staticHealth1sCategory = event.target:getDesc().category
				-- env.info( "DCE_EventT (health1s) |staticHealth1sCategory| "..tostring(staticHealth1sCategory))
			end
		end

		local lifeActual1s = healthTemp.objSujet:getLife()		--651: Unit doesn't exist
		local lifePourcent = (lifeActual1s/healthTemp.health0) * 100
		local initDesc = healthTemp.objSujet:getDesc()

		local health1s_entry = {
			PilotName = healthTemp.PilotName,
			lifeActual1s = lifeActual1s,
			health0 = healthTemp.health0,
			lifePourcent = lifePourcent,
			event = healthTemp.typeEvent,
			description = initDesc,
		}

		table.insert(CustomLog, health1s_entry)
	end
end

--1s apres le hit, la valeur est plus proche de la réalité
local function addHit1s(hitTemp)

	if scenLog and scenLog[hitTemp.scenaryName] and scenLog[hitTemp.scenaryName].event == "S_EVENT_DEAD" then
		env.info( "DCE_EventT addHit1s  B return S_EVENT_DEAD "..tostring(hitTemp.scenaryName))
		return
	end

	local lifeActual1s = hitTemp.objScen:getLife()

	local lifePourcent = (lifeActual1s/hitTemp.hightLife) * 100

	scenLog[hitTemp.scenaryName] = {							--add scenery object to table
		scenaryName = hitTemp.scenaryName,
		lifeActual1s = lifeActual1s,
		hightLife = hitTemp.hightLife,
		objScen = hitTemp.objScen,
		health0 = hitTemp.health0,									--store initial health of scenery object
		lasthit = hitTemp.lasthit,					--store who hit the scenery object
		lifeHit = hitTemp.lifeHit,
		lifePourcent = lifePourcent,
		x = hitTemp.x,
		y = hitTemp.y,
		z = hitTemp.z,
		description = hitTemp.description,
		event = hitTemp.event,
	}
end

--###################  ######   #####################################
--###################  MAIN   #####################################
--###################  ######   #####################################

function eventHandlerDCE:onEvent(event)

	--custom events log
	local log_entry = {															--create a custom log entry for this event
		t = timer.getTime()														--store time of event
	}
	if event.id == world.event.S_EVENT_SHOT then								--1
		log_entry.type = "shot"
	elseif event.id == world.event.S_EVENT_HIT then								--2
		log_entry.type = "hit"
	elseif event.id == world.event.S_EVENT_KILL then							--28
		log_entry.type = "kill"
	elseif event.id == world.event.S_EVENT_UNIT_LOST then						--30
		log_entry.type = "unit lost"
	elseif event.id == world.event.S_EVENT_TAKEOFF then							--3
		log_entry.type = "takeoff"
	elseif event.id == world.event.S_EVENT_LAND then							--4
		log_entry.type = "land"
	elseif event.id == world.event.S_EVENT_LANDING_QUALITY_MARK then			--36
		log_entry.type = "land quality"
	elseif event.id == world.event.S_EVENT_CRASH then							--5
		log_entry.type = "crash"
	elseif event.id == world.event.S_EVENT_EJECTION then						--6
		log_entry.type = "eject"
	elseif event.id == world.event.S_EVENT_REFUELING then						--7
		log_entry.type = "refueling"
	elseif event.id == world.event.S_EVENT_DEAD then							--8
		log_entry.type = "dead"
	elseif event.id == world.event.S_EVENT_PILOT_DEAD then						--9
		log_entry.type = "pilot dead"
	elseif event.id == world.event.S_EVENT_DISCARD_CHAIR_AFTER_EJECTION then	--33
		log_entry.type = "pilot seat separation"
	elseif event.id == world.event.S_EVENT_LANDING_AFTER_EJECTION then			--31
		log_entry.type = "pilot land"
	elseif event.id == world.event.S_EVENT_DETAILED_FAILURE then				--17
		log_entry.type = "failure"
	elseif event.id == world.event.S_EVENT_BASE_CAPTURED then					--10
		log_entry.type = "base captured"
	elseif event.id == world.event.S_EVENT_MISSION_START then					--11
		log_entry.type = "mission start"
	elseif event.id == world.event.S_EVENT_MISSION_END then						--12
		log_entry.type = "mission end"
	elseif event.id == world.event.S_EVENT_TOOK_CONTROL then
		log_entry.type = "took control"
	elseif event.id == world.event.S_EVENT_REFUELING_STOP then					--14
		log_entry.type = "refueling stop"
	elseif event.id == world.event.S_EVENT_BIRTH then							--15
		log_entry.type = "birth"
	elseif event.id == world.event.S_EVENT_HUMAN_FAILURE then					--16
		log_entry.type = "human failure"
	elseif event.id == world.event.S_EVENT_ENGINE_STARTUP then					--18
		log_entry.type = "engine startup"
	elseif event.id == world.event.S_EVENT_ENGINE_SHUTDOWN then					--19
		log_entry.type = "engine shutdown"
	elseif event.id == world.event.S_EVENT_PLAYER_ENTER_UNIT then				--20
		log_entry.type = "player enter unit"
	elseif event.id == world.event.S_EVENT_PLAYER_LEAVE_UNIT then				--21
		log_entry.type = "player leave unit"
	-- elseif event.id == world.event.S_EVENT_WEAPON_ADD then						--34
		-- log_entry.type = "weapon add"
	else
		-- env.info( "EventT PASSE 00a event INCONNU, id: "..tostring(event.id))
		-- _affiche(event, "EventT  PASSE 00b event INCONNU")
	end

	Info_event = {
		[0] =  "S_EVENT_INVALID",
		[1] = "S_EVENT_SHOT",
		[2] = "S_EVENT_HIT",
		[3] = "S_EVENT_TAKEOFF",
		[4] = "S_EVENT_LAND",
		[5] = "S_EVENT_CRASH",
		[6] = "S_EVENT_EJECTION",
		[7] = "S_EVENT_REFUELING",
		[8] = "S_EVENT_DEAD",
		[9] = "S_EVENT_PILOT_DEAD",
		[10] = "S_EVENT_BASE_CAPTURED",
		[11] = "S_EVENT_MISSION_START",
		[12] = "S_EVENT_MISSION_END",
		[13] = "S_EVENT_TOOK_CONTROL",
		[14] = "S_EVENT_REFUELING_STOP",
		[15] = "S_EVENT_BIRTH",
		[16] = "S_EVENT_HUMAN_FAILURE",
		[17] = "S_EVENT_DETAILED_FAILURE",
		[18] = "S_EVENT_ENGINE_STARTUP",
		[19] = "S_EVENT_ENGINE_SHUTDOWN",
		[20] = "S_EVENT_PLAYER_ENTER_UNIT",
		[21] = "S_EVENT_PLAYER_LEAVE_UNIT",
		[22] = "S_EVENT_PLAYER_COMMENT",
		[23] = "S_EVENT_SHOOTING_START",
		[24] = "S_EVENT_SHOOTING_END",
		[25] = "S_EVENT_MARK_ADDED",
		[26] = "S_EVENT_MARK_CHANGE",
		[27] = "S_EVENT_MARK_REMOVED",
		[28] = "S_EVENT_KILL",
		[29] = "S_EVENT_SCORE",
		[30] = "S_EVENT_UNIT_LOST",
		[31] = "S_EVENT_LANDING_AFTER_EJECTION",
		[32] = "S_EVENT_PARATROOPER_LENDING",
		[33] = "S_EVENT_DISCARD_CHAIR_AFTER_EJECTION",
		[34] = "S_EVENT_WEAPON_ADD",
		[35] = "S_EVENT_TRIGGER_ZONE",
		[36] = "S_EVENT_LANDING_QUALITY_MARK",
		[37] = "S_EVENT_BDA",
		[38] = "S_EVENT_AI_ABORT_MISSION",
		[39] = "S_EVENT_DAYNIGHT",
		[40] = "S_EVENT_FLIGHT_TIME",
		[41] = "S_EVENT_PLAYER_SELF_KILL_PILOT",
		[42] = "S_EVENT_PLAYER_CAPTURE_AIRFIELD",
		[43] = "S_EVENT_EMERGENCY_LANDING" ,
		[44] = "S_EVENT_UNIT_CREATE_TASK",
		[45] = "S_EVENT_UNIT_DELETE_TASK",
		[46] = "S_EVENT_SIMULATION_START",
		[47] = "S_EVENT_WEAPON_REARM",
		[48] = "S_EVENT_WEAPON_DROP",
		[49] = "S_EVENT_UNIT_TASK_TIMEOUT",
		[50] = "S_EVENT_UNIT_TASK_STAGE",
		[51] = "S_EVENT_MAC_SUBTASK_SCORE",
		[52] = "S_EVENT_MAC_EXTRA_SCORE",
		[53] = "S_EVENT_MISSION_RESTART",
		[54] = "S_EVENT_MISSION_WINNER",
		[55] = "S_EVENT_POSTPONED_TAKEOFF",
		[56] = "S_EVENT_POSTPONED_LAND",
		[57] = "S_EVENT_MAX",
	}
	-- 0 =  S_EVENT_INVALID"
	-- 1 = "S_EVENT_SHOT"
	-- 2 = "S_EVENT_HIT"
	-- 3 = "S_EVENT_TAKEOFF"
	-- 4 = "S_EVENT_LAND"
	-- 5 = "S_EVENT_CRASH"
	-- 6 = "S_EVENT_EJECTION"
	-- 7 = "S_EVENT_REFUELING"
	-- 8 = "S_EVENT_DEAD"
	-- 9 = "S_EVENT_PILOT_DEAD"
	-- 10 = "S_EVENT_BASE_CAPTURED"
	-- 11 = "S_EVENT_MISSION_START"
	-- 12 = "S_EVENT_MISSION_END"
	-- 13 = "S_EVENT_TOOK_CONTROL"
	-- 14 = "S_EVENT_REFUELING_STOP"
	-- 15 = "S_EVENT_BIRTH"
	-- 16 = "S_EVENT_HUMAN_FAILURE"
	-- 17 = "S_EVENT_DETAILED_FAILURE"
	-- 18 = "S_EVENT_ENGINE_STARTUP"
	-- 19 = "S_EVENT_ENGINE_SHUTDOWN"
	-- 20 = "S_EVENT_PLAYER_ENTER_UNIT"
	-- 21 = "S_EVENT_PLAYER_LEAVE_UNIT"
	-- 22 = "S_EVENT_PLAYER_COMMENT"
	-- 23 = "S_EVENT_SHOOTING_START"
	-- 24 = "S_EVENT_SHOOTING_END"
	-- 25 = "S_EVENT_MARK_ADDED"
	-- 26 = "S_EVENT_MARK_CHANGE"
	-- 27 = "S_EVENT_MARK_REMOVED"
	-- 28 = "S_EVENT_KILL"
	-- 29 = "S_EVENT_SCORE"
	-- 30 = "S_EVENT_UNIT_LOST"
	-- 31 = "S_EVENT_LANDING_AFTER_EJECTION"
	-- 32 = "S_EVENT_PARATROOPER_LENDING"
	-- 33 = "S_EVENT_DISCARD_CHAIR_AFTER_EJECTION"
	-- 34 = "S_EVENT_WEAPON_ADD"
	-- 35 = "S_EVENT_TRIGGER_ZONE"
	-- 36 = "S_EVENT_LANDING_QUALITY_MARK"
	-- 37 = "S_EVENT_BDA"
					-- _affiche (a b)     time 3490.471
					-- _affiche(a c)           initiator id_
					-- _affiche(d)                16794881
					-- _affiche(a c)           target id_
					-- _affiche(d)                16883201
					-- _affiche(a c)           weapon id_
					-- _affiche(d)                16918785
					-- _affiche (a b)     id 37
					-- _affiche (a b)     weapon_name FAB_500

 -- S_EVENT_AI_ABORT_MISSION = 38
-- S_EVENT_DAYNIGHT = 39

	-- S_EVENT_FLIGHT_TIME = 40, 
	-- S_EVENT_PLAYER_SELF_KILL_PILOT = 41, 
	-- S_EVENT_PLAYER_CAPTURE_AIRFIELD = 42, 
	-- S_EVENT_EMERGENCY_LANDING = 43,
	 -- when AI aircraft lands on belly or ditch on water. Support for player will be added later
	-- S_EVENT_UNIT_CREATE_TASK = 44,
	-- S_EVENT_UNIT_DELETE_TASK = 45,
	-- S_EVENT_SIMULATION_START = 46,
	-- S_EVENT_WEAPON_REARM = 47,
	-- S_EVENT_WEAPON_DROP = 48,
	-- S_EVENT_UNIT_TASK_TIMEOUT = 49,
	-- S_EVENT_UNIT_TASK_STAGE = 50,
	-- S_EVENT_MAC_SUBTASK_SCORE = 51, 
	-- S_EVENT_MAC_EXTRA_SCORE = 52,
	-- S_EVENT_MISSION_RESTART = 53,
	-- S_EVENT_MISSION_WINNER = 54, 
	-- S_EVENT_POSTPONED_TAKEOFF = 55, 
	-- S_EVENT_POSTPONED_LAND = 56, 
	-- S_EVENT_MAX = 57,

	env.info( "DCE_EventsTracker  id: "..tostring(event.id).." _type_ : "..tostring(log_entry.type))
	-- _affiche(event, "event EventTracker")
	-- trigger.action.outText("EventT  id: "..tostring(event.id).."_type_"..tostring(log_entry.type), 3)

	if event and event.id and Info_event and Info_event[tonumber(event.id)] then
		local idLabel = tostring(Info_event[tonumber(event.id)])
		env.info("DCE_EventsTracker event.id "..tostring(event.id).." " ..idLabel)
	end

	if not eventIdTotal[event.id] then eventIdTotal[event.id] = 0 end
	eventIdTotal[event.id] = eventIdTotal[event.id] + 1

	--recupere le camp une fois pour toute:
	local initiatorSideName
	local targetSideName local initiatorObjCategory local targetObjCategory
	if event.initiator then
		initiatorObjCategory = Object.getCategory(event.initiator)
		--DCE_EventsTracker initiator Category 0 _: nil
		env.info("DCE_EventsTracker initiator Category: "..tostring(initiatorObjCategory))
		if Object_Category[initiatorObjCategory] then
			env.info("DCE_EventsTracker initiator Object_Category :  _:_ "..tostring(Object_Category[initiatorObjCategory]))

			if initiatorObjCategory ~= Object.Category.SCENERY then
				local initiatorCoalition = event.initiator:getCoalition()
				initiatorSideName = coalitionIdNumeric[tonumber(initiatorCoalition)]
			end
		end
	end

	if event.target then
		targetObjCategory = Object.getCategory(event.target)
		env.info("DCE_EventsTracker target Category: "..tostring(targetObjCategory))
		if Object_Category[targetObjCategory] then
			env.info("DCE_EventsTracker Object_Category :  _:_ "..tostring(Object_Category[targetObjCategory]))
			-- static:getDesc().category
			if targetObjCategory ~= Object.Category.SCENERY then
				if event.target:isExist() then
					local targetCoalition = event.target:getCoalition()
					targetSideName = coalitionIdNumeric[tonumber(targetCoalition)]
				end
			end
		end
	end


	if log_entry.type == "eject"  then
		if event.initiator then
			local ptEvent = event.initiator:getPoint()
			local PilotEjection = {}
			local side
			if ptEvent  and  ptEvent.x then

				PilotEjection = {
					x = ptEvent.x,
					y = land.getHeight({x = ptEvent.x, y = ptEvent.z}),
					z = ptEvent.z,
					unit = event.initiator,
				}

				local initDesc = event.initiator:getDesc()																									--debug ET01	
				if initDesc.displayName then
					PilotEjection.initiator = event.initiator:getName()
					log_entry.initiator = event.initiator:getName()																								--store initiator name
				end

				if Object.getCategory(event.initiator) == Object.Category.UNIT  then										--initiator is a unit debug_ET01.h
					PilotEjection.initiatorPilotName = event.initiator:getPlayerName()
					if PilotEjection.initiatorPilotName then
						PilotEjection.initiatorPilotName = PilotEjection.initiatorPilotName:gsub('[%p]', '_')
						log_entry.initiatorPilotName = PilotEjection.initiatorPilotName
					end
					PilotEjection.Coalition = event.initiator:getCoalition()
				end
				if Object.getCategory(event.initiator) ~= Object.Category.SCENERY and event.initiator:getID() then				--initator is not a scenery object debug_ET01.h
					PilotEjection.initiatorMissionID = event.initiator:getID()																					--store ID
					PilotEjection.initiatorSIDE = event.initiator:getCoalition()
					side = coalitionIdNumeric[tonumber(PilotEjection.initiatorSIDE)]

					local countryId = event.initiator:getCountry()
					PilotEjection.countryId = countryId
					PilotEjection.initiatorCountry = string.lower(country.name[countryId])
				end

				-- land.SurfaceType 
				-- LAND             1
				-- SHALLOW_WATER    2
				-- WATER            3 
				-- ROAD             4
				-- RUNWAY           5
				-- local point = {
				-- 	x = PilotEjection.x,
				-- 	y = PilotEjection.z,
				-- }
				PilotEjection.SurfaceType = land.getSurfaceType({x = PilotEjection.x, y = PilotEjection.z})

				PilotEjection.grid = coord.LLtoMGRS(coord.LOtoLL(PilotEjection.unit:getPosition().p))

				local CloseRoad = {}
				-- Roadtype can be 'railroads' or 'roads'
				local x, y = land.getClosestPointOnRoads('roads',PilotEjection.x, PilotEjection.z)
				CloseRoad.x = x
				CloseRoad.y = y
				PilotEjection.CloseRoad = CloseRoad
				table.insert(tabEjection, PilotEjection)

				_affiche(PilotEjection, " PilotEjection |log_entry.type == eject")

				-- local PilotVec3 = {
					-- x = ptEvent.x,
					-- y = land.getHeight({x = ptEvent.x, y = ptEvent.z}),
					-- z = ptEvent.z,
				-- }

				if event.initiator and event.initiator:getPlayerName()	then
					env.info( "DCE_EJECT EventT :radioTransmission frequency A  "..tostring(camp.EjectedPilotFrequency[side].GuardEjection).." | "..tostring('GuardEjection'..PilotEjection.initiator))

					trigger.action.radioTransmission('l10n/DEFAULT/ejectionRadioBeacon.ogg', PilotEjection, 0, true, camp.EjectedPilotFrequency[side].GuardEjection, 1, 'GuardEjection'..PilotEjection.initiator)

					env.info( "DCE_EJECT EventT :radioTransmission frequency B  "..tostring(camp.EjectedPilotFrequency[side].GuardEjection).." | "..tostring('GuardEjection'..PilotEjection.initiator))
				end

				local ejectionSeatTemp = {
					radio_on = true,
					time_on = log_entry.t,
					name = PilotEjection.initiator,
				}

				table.insert(EjectionSeatFrequency, ejectionSeatTemp)

				table.insert(CustomLog, log_entry)	

			end
			if initiatorSideName then
				log_entry.initiatorSideName = initiatorSideName
			end
			if targetSideName then
				log_entry.targetSideName = targetSideName
			end
		end
	-- end


	elseif log_entry.type == "pilot seat separation"  then
		env.info( "DCE_EventT  PASSE A pilot seat separation, id: "..tostring(event.id).."_type_"..tostring(log_entry.type))

		if event.initiator then
			-- env.info( "DCE_EventT  PASSE B pilot seat separation, id: "..tostring(event.id).."_type_"..tostring(log_entry.type))

			local ptEvent = event.initiator:getPoint()
			if ptEvent and ptEvent.x then

				-- env.info( "DCE_EventT  PASSE C pilot seat separation, id: "..tostring(event.id).."_type_"..tostring(log_entry.type))

				--active fumigene
				local PilotVec3 = {
					x = ptEvent.x,
					y = land.getHeight({x = ptEvent.x, y = ptEvent.z}),
					z = ptEvent.z,
				}
				-- trigger.action.smoke(PilotVec3, trigger.smokeColor.Green)

				log_entry.initiatorMissionID = event.initiator:getID()
				log_entry.x = ptEvent.x
				log_entry.y = ptEvent.y
				log_entry.z = ptEvent.z

				--TODO revoir ça, normalement l'id du parachut devrait etre celui de plane, quid d'un biplace?
				--attention l'id disparait si le parachute tombe dans l'eau
				local selected_distance = 9999999
				local selectedEjection = {}
				for n=1, #tabEjection do
					if tabEjection[n] and tabEjection[n] ~= nil then
                        local distance = math.sqrt(math.pow(PilotVec3.x - tabEjection[n].x, 2) + math.pow(PilotVec3.z - tabEjection[n].z, 2))
                        if distance < selected_distance and (not tabEjection[n].SumEjectedPilotDay) then
							selected_distance = distance
                            selectedEjection = tabEjection[n]
                        end
					end
				end

				local infoPilot = {}
				if selected_distance <= 4000 then
					-- log_entry.initiatorPilotName = selectedEjection.initiatorPilotName:gsub('[%c]', '_')
					log_entry.initiatorPilotName = selectedEjection.initiatorPilotName
					log_entry.initiator = selectedEjection.initiator

					selectedEjection.x = ptEvent.x
					selectedEjection.y = ptEvent.y
					selectedEjection.z = ptEvent.z
					selectedEjection.x2d = PilotVec3.x
					selectedEjection.y2d = PilotVec3.z
					selectedEjection.z2d = PilotVec3.y
					if selectedEjection.unit:isExist()  then
						selectedEjection.grid = coord.LLtoMGRS(coord.LOtoLL(selectedEjection.unit:getPosition().p))
					end
				end


				-- SumSoldierAliasPilot = SumSoldierAliasPilot + 1
				-- selectedEjection.SumEjectedPilotDay  = SumSoldierAliasPilot

				_affiche(selectedEjection, " selectedEjection |pilot seat separation")

				-- CheckImmediatSAR(event, selectedEjection)
			end
			if initiatorSideName then
				log_entry.initiatorSideName = initiatorSideName
			end
			if targetSideName then
				log_entry.targetSideName = targetSideName
			end
		else
			env.info( "DCE_EventT  PASSE M pilot seat separation, id: "..tostring(event.id).."_type_"..tostring(log_entry.type))
			_affiche(event, "BUG pilot seat separation event ")
		end
	-- end

	elseif  log_entry.type == "pilot land"  then
		if event.initiator then
			local ptEvent = event.initiator:getPoint()
			if ptEvent  and  ptEvent.x then
				--active fumigene
				local PilotVec3 = {
					x = ptEvent.x,
					y = land.getHeight({x = ptEvent.x, y = ptEvent.z}),
					z = ptEvent.z,
				}
				-- trigger.action.smoke(PilotVec3, trigger.smokeColor.Red) --****************************

				--inscrit position et name dans le log
				log_entry.initiatorMissionID = event.initiator:getID()
				log_entry.x = ptEvent.x
				log_entry.y = ptEvent.y
				log_entry.z = ptEvent.z

				-- _affiche(tabEjection, " tabEjection |pilot land AAA")

				local selected_distance = 9999999
				local selectedEjection = {}
				local ejectN = 0
				for n=1, #tabEjection do
					if tabEjection[n] and tabEjection[n] ~= nil then
                        local distance = math.sqrt(math.pow(PilotVec3.x - tabEjection[n].x, 2) + math.pow(PilotVec3.z - tabEjection[n].z, 2))

						if distance < selected_distance and (not tabEjection[n].createdSoldier) then
							selected_distance = distance
                            ejectN = n
                        end

					end
				end

				if selected_distance <= 8000 and ejectN ~= 0 then

					selectedEjection = tabEjection[ejectN]

					-- log_entry.initiatorPilotName = selectedEjection.initiatorPilotName:gsub('[%c]', '_')
					log_entry.initiatorPilotName = selectedEjection.initiatorPilotName
					log_entry.initiator = selectedEjection.initiator

					-- selectedEjection.x = ptEvent.x
					-- selectedEjection.y = ptEvent.y
					-- selectedEjection.z = ptEvent.z

					--on change la position, car le vent peut pousser le parachute de la mere vers la terre
					selectedEjection.x = PilotVec3.x
					selectedEjection.y = PilotVec3.y
					selectedEjection.z = PilotVec3.z

					selectedEjection.x2d = PilotVec3.x
					selectedEjection.y2d = PilotVec3.z
					selectedEjection.z2d = PilotVec3.y

					selectedEjection.SurfaceType = land.getSurfaceType({x = selectedEjection.x, y = selectedEjection.z})

					SumSoldierAliasPilot = SumSoldierAliasPilot + 1
					selectedEjection.SumEjectedPilotDay  = SumSoldierAliasPilot

					if selectedEjection.initiatorPilotName then
						selectedEjection.name = "Mis"..camp.mission.."_Pilot_"..selectedEjection.initiatorPilotName.."_Nb"..tostring(selectedEjection.SumEjectedPilotDay)
					else
						selectedEjection.name = "Mis"..camp.mission.."_Pilot_"..selectedEjection.initiator.."_Nb"..tostring(selectedEjection.SumEjectedPilotDay)
					end

					selectedEjection.name = selectedEjection.name:gsub('[%p]', '_')

					-- selectedEjection.grid = coord.LLtoMGRS(coord.LOtoLL(selectedEjection.unit:getPosition().p))

					_affiche(selectedEjection, " selectedEjection |pilot land")

					CheckImmediatSAR(selectedEjection)

					env.info( "DCE_EvenT: createdSoldier? SurfaceType? "..tostring(selectedEjection.SurfaceType))
					-- trigger.action.outText("EvenT:  createdSoldier? SurfaceType? "..tostring(selectedEjection.SurfaceType), 30)

					if selectedEjection.SurfaceType ~= 3 and selectedEjection.SurfaceType ~= 5  then

						AddSoldierAliasPilot(selectedEjection)
						selectedEjection.createdSoldier = true

					end
				end
			end
			if initiatorSideName then
				log_entry.initiatorSideName = initiatorSideName
			end
			if targetSideName then
				log_entry.targetSideName = targetSideName
			end
		end
	-- end


	elseif log_entry.type == "pilot dead"  then --log_entry.type == "pilot dead" or 

		if event.initiator then
			local ptEvent = event.initiator:getPoint()
			if ptEvent  and  ptEvent.x then
				--active fumigene
				local PilotVec3 = {
					x = ptEvent.x,
					y = land.getHeight({x = ptEvent.x, y = ptEvent.z}),
					z = ptEvent.z,
				}
				-- trigger.action.smoke(PilotVec3, trigger.smokeColor.Blue)
			end
		end

		if initiatorSideName then
			log_entry.initiatorSideName = initiatorSideName
		end
		if targetSideName then
			log_entry.targetSideName = targetSideName
		end

	-- end

	-- miguel modification M18.d destroy Plane Landing CV
	elseif (log_entry.type == "land" and event.place)  then										--hit event with initiator or any other event (excludes hit events without initiator, like collisions)		
		env.info("DCE_Landing Passe 00 ")

		if event.initiator then
			env.info("DCE_Landing Passe 01 ")

			local s =""
			s = s.." Object.getCategory "..Object.getCategory(event.initiator)
			s = s.." "..event.initiator:getName()
			-- s = s.." "..event.place:getCategory()
			s = s.." Airbase.getCategory "..Airbase.getCategory(event.place)
			s = s.." "..event.place:getName()
			s = s.." "..event.initiator:getID()
			s = s.." "..event.initiator:getTypeName()

			local BasePlace = tostring(event.place:getTypeName())

			env.info("DCE_Landing Passe A "..tostring(s))

			-- Airbase.Category = {
			-- 	AIRDROME = 0,
			-- 	HELIPAD = 1, 
			-- 	SHIP = 2,
			-- }
			-- if event.place:getCategory() == Airbase.Category.SHIP    and not event.initiator:getPlayerName() then 
			if Airbase.getCategory(event.place) == Airbase.Category.SHIP and not event.initiator:getPlayerName() then 											-- category ship
				env.info("DCE_Landing Passe C ")

				--relance un Pedro si c'est un Pedro qui se pose
				if string.find(event.initiator:getName(), "Pedro") then

					table.insert(despawn, event.initiator)

					--["name"] = "Unit_Pedro_CVN-71 Theodore Roosevelt_1",
					local cvName = event.initiator:getName()
					env.info("DCE_Pedro landing Passe D1 "..tostring(cvName))

					cvName = cvName:gsub( "Unit_Pedro_", "")
					cvName, _ = cvName:match("([^,]+)_([^,]+)")
					env.info("DCE_Pedro landing Passe D2 "..tostring(cvName))

					NeedPedro(cvName, event)

					env.info("DCE_TryStart Passe D3 NeedPedro cvName: "..tostring(cvName))
					-- trigger.action.outText("TryStart NeedPedro ", 30)

				elseif camp.CV_despawnAfterLanding then
					env.info("DCE_Despawn Add Table CV despawn "..s)
					table.insert(despawn, event.initiator)
				end

			elseif  string.find(event.place:getName(),"FARP")   and not event.initiator:getPlayerName() then 											-- category ship
				env.info("DCE_Despawn Add Table FARP despawn "..s)
				table.insert(despawn, event.initiator)

			end

			env.info("DCE_Landing Passe E ")

			-- modification M50.a Records landings
			local initDesc = event.initiator:getDesc()
			if initDesc.displayName then
				log_entry.initiator = event.initiator:getName()																							--store initiator name
				log_entry.type_name = event.initiator:getTypeName()
				log_entry.place = event.place:getTypeName()
				log_entry.place = string.gsub(log_entry.place, "'", "")
				-- log_entry.Desc = initDesc

			end
			if Object.getCategory(event.initiator) == Object.Category.UNIT and event.initiator:getPlayerName() then			--initiator is a unit debug_ET01.h
				-- log_entry.initiatorPilotName = event.initiator:getPlayerName()
				log_entry.initiatorPilotName = event.initiator:getPlayerName()
				if log_entry.initiatorPilotName then
					log_entry.initiatorPilotName = log_entry.initiatorPilotName:gsub("'", '')
					log_entry.initiatorPilotName = log_entry.initiatorPilotName:gsub("\"", '')
				end
				-- log_entry.initiatorPilotName = event.initiator:getPlayerName():gsub('[%c]', '_')																		--store player name
			end
			if Object.getCategory(event.initiator) ~= Object.Category.SCENERY and event.initiator:getID() then				--initator is not a scenery object debug_ET01.h
				log_entry.initiatorMissionID = event.initiator:getID()																					--store ID
			end

			local initPoint = event.initiator:getPoint()
			if initPoint and initPoint.x then
				log_entry.x = initPoint.x
				log_entry.y = initPoint.y
				log_entry.z = initPoint.z
			end

			table.insert(CustomLog, log_entry)
			env.info("DCE_Landing fin Passe Y ")
		end

	elseif (log_entry.type == "land")  then
		env.info("DCE_Landing Passe 11 ")

		if event.initiator then
			env.info("DCE_Landing Passe 12 ")

			local life = event.initiator:getLife()																	--get current life of unit
			local init_life = event.initiator:getLife0()															--get initial life of unit
			log_entry.health = math.ceil(100 / init_life * life)												--store unit health to log entry

			local healthTemp = {
				PilotName = event.initiator:getPlayerName(),
				typeEvent = log_entry.type,
				life = life,
				objSujet = event.initiator,
				health0 = init_life,
				health = log_entry.health,
			}

			timer.scheduleFunction(health1s, {healthTemp, event}, timer.getTime() + 1)
		end
	-- end

	-- debug ET01.g
	elseif log_entry.type and ((log_entry.type == "hit" and event.initiator) or log_entry.type ~= "hit" ) then												--hit event with initiator or any other event (excludes hit events without initiator, like collisions) 	
		if event.initiator and initiatorObjCategory ~= 0 then																													--event has an initiator	

			if event and event.id and Info_event and Info_event[tonumber(event.id)] then
				local idLabel = tostring(Info_event[tonumber(event.id)])
				env.info("DCE_EventsTracker event.id "..tostring(event.id).." " ..idLabel)
			end

			_affiche(event.initiator, "DCE_EventsTracker event.initiator")

			local initDesc = event.initiator:getDesc()																									--debug ET01	
			if initDesc.displayName then
				log_entry.initiator = event.initiator:getName()																							--store initiator name
			end
			if Object.getCategory(event.initiator) == Object.Category.UNIT  then										--initiator is a unit debug_ET01.h
				-- log_entry.initiatorPilotName = event.initiator:getPlayerName()
				log_entry.initiatorPilotName = event.initiator:getPlayerName()
				if log_entry.initiatorPilotName then
					log_entry.initiatorPilotName = log_entry.initiatorPilotName:gsub("'", '')
					log_entry.initiatorPilotName = log_entry.initiatorPilotName:gsub("\"", '')
				end
				-- log_entry.initiatorPilotName = event.initiator:getPlayerName():gsub('[%c]', '_')																		--store player name
			end

			if Object.getCategory(event.initiator) ~= Object.Category.SCENERY and not initDesc.missileCategory  then   --and event.initiator:getID()				--initator is not a scenery object debug_ET01.h
				log_entry.initiatorMissionID = event.initiator:getID()																					--store ID
			end

			if initiatorSideName then
				log_entry.initiatorSideName = initiatorSideName
			end
			if targetSideName then
				log_entry.targetSideName = targetSideName
			end
		end

		if event.target   then																														--event has a target

			-- Object.Category
			-- UNIT    1
			-- WEAPON  2
			-- STATIC  3
			-- BASE    4
			-- SCENERY 5
			-- Cargo   6

			local targetCategory = Object.getCategory(event.target)
			-- env.info( "DCE_EventT (type == hit) targetCategory| "..tostring(targetCategory))

			if targetCategory and ( targetCategory == 1 or targetCategory == 3 or targetCategory == 4)  then
				--Function also works with Unit, Static Object, Airbase
				log_entry.target = event.target:getName()
				env.info( "DCE_EventT (type == hit) |getName_716| "..tostring(log_entry.target))

				if targetCategory == 3 and log_entry.target ~= nil and log_entry.target ~= "" then
					-- StaticObject.Category = {
					-- 	"VOID": 0,
					-- 	"UNIT": 1,
					-- 	"WEAPON": 2,
					-- 	"STATIC": 3,
					-- 	"BASE": 4,
					-- 	"SCENERY": 5,
					-- 	"CARGO": 6 
					--    }

					env.info( "DCE_EventT (type == hit) |getName_729| "..tostring(log_entry.target))

					-- local staticDesc = StaticObject.getDesc(event.target)
					local staticDesc = event.target:getDesc()
					-- _affiche(staticDesc, "EventsT staticDesc")

					local staticCategory = event.target:getDesc().category

					log_entry.targetMissionID = event.target:getID()

					env.info( "DCE_EventT (type == hit) |staticCategory| "..tostring(staticCategory))

				elseif targetCategory and ( targetCategory == 1  or targetCategory == 4)  then

					log_entry.targetMissionID = event.target:getID()

				end
			else
				log_entry.target = ""
			end

			-- Group.Category = {
			-- 	AIRPLANE      = 0
			-- 	HELICOPTER    = 1
			-- 	GROUND        = 2
			-- 	SHIP          = 3
			-- 	TRAIN         = 4
			--   }

			if targetCategory and targetCategory == Object.Category.UNIT then												--target is a unit
				log_entry.targetPilotName = event.target:getPlayerName()													--store player name
				if log_entry.type == "hit" then																				--log entry is a hit event	
					-- if event.target:getGroup():getCategory() == 0 or event.target:getGroup():getCategory() == 1 then		--hit unit is aircraft or helo
					if Group.getCategory(event.target:getGroup()) == 0 or Group.getCategory(event.target:getGroup()) == 1 then
						local life = event.target:getLife()																	--get current life of unit
						local init_life = event.target:getLife0()															--get initial life of unit
						log_entry.health = math.ceil(100 / init_life * life)												--store unit health to log entry

						local healthTemp = {
							PilotName = log_entry.targetPilotName,
							typeEvent = log_entry.type,
							objSujet = event.target,
							life = life,
							health0 = init_life,
							health = log_entry.health,
						}

						timer.scheduleFunction(health1s, {healthTemp, event}, timer.getTime() + 1)

						-- local pos = Unit.getByName('whatever'):getPoint()
						-- local agl = pos.y - land.getHeight({x=pos.x, y = pos.z})

						local pos = event.target:getPoint()
						if pos and pos.x then
							log_entry.x = pos.x
							log_entry.y = pos.y
							log_entry.z = pos.z

							local agl = pos.y - land.getHeight({x=pos.x, y = pos.z})
							log_entry.agl = agl
						end

					end
				end
			end

		end
		table.insert(CustomLog, log_entry)																					--add log entry to custom log
	end

	--mission end
	if event.id == world.event.S_EVENT_MISSION_END then

		--collect health of ships
		if camp.ShipHealth == nil then																						--table to store ship damage does not exist yet
			camp.ShipHealth = {}																							--create table to store ship damage
		end

		camp.ShipDamagedLast = {}																							--table to collect ship names that took new additional damage during this mission
		for coalition_name,coal in pairs(env.mission.coalition) do															--iterate through coalitions in mission
			for country_n,country in pairs(coal.country) do																	--iterate through countries in coalitions
				if country.ship then																						--country has ships
					for group_n,group in pairs(country.ship.group) do														--iterate through groups in ships
						for unit_n,unit in pairs(group.units) do															--iterate through units in group
							local u = Unit.getByName(unit.name)																--get unit
							if u then																						--unit exists
								local health = u:getLife()																	--get current health of unit
								local health0 = camp.ShipHealth0[unit.name]													--get maximum health of unit
								local newhealth = math.floor(health / health0 * 100)										--health percentage of ship

								if camp.ShipHealth[unit.name] then
									if newhealth < camp.ShipHealth[unit.name] - 5 then										--new health is lower than previous health
										camp.ShipDamagedLast[unit.name] = true												--mark that ship has taken new damage during this mission
									end
								else
									if newhealth < 100 then
										camp.ShipDamagedLast[unit.name] = true												--mark that ship has taken new damage during this mission
									end
								end
								camp.ShipHealth[unit.name] = newhealth														--store new health of ship
							end
						end
					end
				end
			end
		end

		camp.runwayLife = runwayLife


		env.setErrorMessageBoxEnabled(true)																					-- debug_ET02	n'affiche pas les messages d'error sauf � la fin de mission

		-- modification M35.d (d: info log) version ScriptsMod
		if camp.versionPackageICM then
			env.info( "DCE_versionPackageICM  "..tostring(camp.versionPackageICM) )
		end
		if camp.MissionFilename then
			env.info( "DCE_MissionFilename  "..tostring(camp.MissionFilename) )
		end
		if camp.version then
			env.info( "DCE_versionCampaign  "..tostring(camp.version) )
		end


		--export custom mission log
		local logStr = "events = " .. TableSerialization(CustomLog, 0)
		local logFile = io.open(PathDCE .. "MissionEventsLog.lua", "w")
		if logFile then
			logFile:write(logStr)
			logFile:close()
		else
			env.info("DCE_MissionEventsLog: Failed to open log file for writing.")
		end

		--export data for destroyed static objects (this is not tracked in DCS's debrief.log)
		local scenDescr = "--Destroyed scenery objects\n\n"
		local scenStr = "scen_log = " .. TableSerialization(scenLog, 0)
		local scenFile = io.open(PathDCE .. "scen_destroyed.lua", "w")
		if scenFile then
			scenFile:write(scenStr)
			scenFile:close()
		else
			env.info("DCE_scen_destroyed: Failed to open log file for writing.")
		end



		if camp.debugTraceability then
			camp.debugTraceability = {}
		end
		if camp.Briefing_text then
			camp.Briefing_text = ""
		end

		--export camp stats file
		local campStr = "camp = " .. TableSerialization(camp, 0)
		local campFile = io.open(PathDCE .. "camp_status.lua", "w")
		if campFile then
			campFile:write(campStr)
			campFile:close()
		else
			env.info("DCE_camp_status: Failed to open log file for writing.")
		end

		--export zoneSAR file
		local SAR_Str = "zoneSAR = " .. TableSerialization(zoneSAR, 0)
		local SAR_File = io.open(PathDCE .. "zoneSAR.lua", "w")
		if SAR_File then
			SAR_File:write(SAR_Str)
			SAR_File:close()
		else
			env.info("DCE_zoneSAR: Failed to open log file for writing.")
		end



		--export eventIdTotal
		if camp.debug then
			local fileStr = "scen_log = " .. TableSerialization(eventIdTotal, 0)
			local fileFile = io.open(PathDCE.."Debug\\" .. "eventIdTotal.lua", "w")
			if fileFile then
				fileFile:write(fileStr)
				fileFile:close()
			else
				env.info("DCE_eventIdTotal: Failed to open log file for writing.")
			end



			local fileStr = "EWR_optionPlayer = " .. TableSerialization(EWR_optionPlayer, 0)
			local fileFile = io.open(PathDCE.."Debug\\" .. "EWR_optionPlayer.lua", "w")
			if fileFile then
				fileFile:write(fileStr)
				fileFile:close()
			else
				env.info("DCE_EWR_optionPlayer: Failed to open log file for writing.")
			end
		end

		-- os.execute('start "EventPath" cmd  /k "c: & cd '..path..' & call \Init\\path.bat && pause"')

		--Launch external LUA environment to evaluate debrief.log, update campaign status files and generate the next campaign mission
		os.execute('start "Debriefing" cmd  /k "set \"DCSDIR=%cd%\" &  ' .. pathDD .. ' & cd ' .. PathDCE .. ' & call \"%DCSDIR%\\bin\\luae.exe\" ..\\..\\..\\ScriptsMod.'..camp.versionPackageICM..'\\DEBRIEF_Master.lua"')

	--collect destroyed scenery objects
	elseif event.id == world.event.S_EVENT_HIT then
		if event.target and event.initiator then
			if Object.getCategory(event.target) == 5 then								--if target is a scenery object
				local descr = event.target:getDesc()
				if descr.life and descr.life > 19 then							--only store destroyed scenery that had an initial health bigger than 20
					local lifeHit = event.target:getLife()
					-- local live0 = event.target:getLife0()	--ne fonctionne pas avec scenery object
					local health0 = descr.life
					local hightLife = health0
					if lifeHit > hightLife and lifeHit > health0 then
						hightLife = lifeHit
					end
					local lifePourcent = (lifeHit/hightLife) * 100

					local initPoint = event.target:getPoint()				--get point of hit scenery object

					local scenaryName = event.target:getName()
					local hitTemp = {
						scenaryName = scenaryName,
						objScen = event.target,
						hightLife = hightLife,
						health0 = descr.life,									--store initial health of scenery object
						lasthit = event.initiator:getName(),					--store who hit the scenery object
						lifeHit = lifeHit,
						lifePourcent = lifePourcent,
						x = initPoint.x,
						y = initPoint.y,
						z = initPoint.z,
						description = descr,
						event = "S_EVENT_HIT",
						initiatorSideName = initiatorSideName,
						targetSideName = targetSideName
					}

					timer.scheduleFunction(addHit1s, hitTemp, timer.getTime() + 1)

					-- scenLog[timer.getTime()] = {							--add scenery object to table
					-- 	scenaryName = scenaryName,
					-- 	lifeHit = lifeHit,	
					-- 	objScen = event.target,	
					-- 	hightLife = hightLife,
					-- 	health0 = descr.life,									--store initial health of scenery object
					-- 	lasthit = event.initiator:getName(),					--store who hit the scenery object
					-- 	lifeActual = lifeActual,
					-- 	lifePourcent = lifePourcent,
					-- 	description = descr,
					-- 	event = "S_EVENT_HIT_multiple",
					-- }


					-- scenLog[scenaryName] = {							--add scenery object to table
					-- 	health0 = descr.life,									--store initial health of scenery object
					-- 	lasthit = event.initiator:getName(),					--store who hit the scenery object
					-- 	lifeActual = lifeActual,
					-- 	lifePourcent = lifePourcent,
					-- 	x = initPoint.x,
					-- 	y = initPoint.y,
					-- 	z = initPoint.z,
					-- 	description = descr,
					-- }
					-- scenLog[scenaryName].event = "S_EVENT_HIT"
				end
			end
		end
	elseif event.id == world.event.S_EVENT_DEAD then
		if event.initiator then
			if Object.getCategory(event.initiator) == 5 then							--if initiator is a scenery object
				if scenLog[event.initiator:getName()] then
					local initPoint = event.initiator:getPoint()				--get point of dead scenery object
					scenLog[event.initiator:getName()].x = initPoint.x
					scenLog[event.initiator:getName()].y = initPoint.y
					scenLog[event.initiator:getName()].z = initPoint.z
					scenLog[event.initiator:getName()].event = "S_EVENT_DEAD"
					local initDesc = event.initiator:getDesc()																									--debug ET01	
					if initDesc then
						scenLog[event.initiator:getName()].Desc = initDesc
					end
				end
			end
		end
	elseif event.id == world.event.S_EVENT_UNIT_LOST then
		if event.initiator then
			if Object.getCategory(event.initiator) == 5 then							--if initiator is a scenery object
				if scenLog[event.initiator:getName()] then
					local initPoint = event.initiator:getPoint()				--get point of dead scenery object
					scenLog[event.initiator:getName()].x = initPoint.x
					scenLog[event.initiator:getName()].y = initPoint.y
					scenLog[event.initiator:getName()].z = initPoint.z

					scenLog[event.initiator:getName()].event = "S_EVENT_UNIT_LOST"

					local initDesc = event.initiator:getDesc()																									--debug ET01	
					if initDesc then
						scenLog[event.initiator:getName()].Desc = initDesc
					end
				end
			end
		end
	elseif event.id == world.event.S_EVENT_KILL then
		if event.initiator then
			if Object.getCategory(event.initiator) == 5 then							--if initiator is a scenery object
				if scenLog[event.initiator:getName()] then
					local initPoint = event.initiator:getPoint()				--get point of dead scenery object
					scenLog[event.initiator:getName()].x = initPoint.x
					scenLog[event.initiator:getName()].y = initPoint.y
					scenLog[event.initiator:getName()].z = initPoint.z

					scenLog[event.initiator:getName()].event = "S_EVENT_KILL"

					local initDesc = event.initiator:getDesc()																									--debug ET01	
					if initDesc then
						scenLog[event.initiator:getName()].Desc = initDesc
					end
				end
			end
		end
	end
end
world.addEventHandler(eventHandlerDCE)


--collect initial health of ships
if camp.ShipHealth0 == nil then																						--table does not exist yet
	camp.ShipHealth0 = {}																							--create table
end
for coalition_name,coal in pairs(env.mission.coalition) do															--iterate through coalitions in mission
	for country_n,country in pairs(coal.country) do																	--iterate through countries in coalitions
		if country.ship then																						--country has ships
			for group_n,group in pairs(country.ship.group) do														--iterate through groups in ships
				for unit_n,unit in pairs(group.units) do															--iterate through units in group
					local u = Unit.getByName(unit.name)																--get unit
					if u then																						--unit exists
						local health = u:getLife()																	--get current health of unit
						camp.ShipHealth0[unit.name] = health														--store initial ship health
					end
				end
			end
		end
	end
end

--apply ship damage
if camp.ShipHealth then																						--table with ship health exists
	for name,health_stored in pairs(camp.ShipHealth) do														--iterate through ships in table
		if health_stored < 66 and camp.ShipHealth0[name] > 10 then											--health is less than 100% and ship has more than 10 health points (do not do for exteremly small boats)
			local u = Unit.getByName(name)																	--get unit
			if u then																						--unit exists
				local counter = 1
				repeat
					local h = u:getLife()																	--get current health of unit
					local h0 = camp.ShipHealth0[name]														--get maximum health of unit
					local health_current = math.floor(h / h0 * 100)											--store health percentage of ship
					local point = u:getPoint()																--get position of ship
					local power = h0 / 100																	--explosive power is relatve to ship strenght
					--trigger.action.outText(counter .. " / Name: " .. name .. " / Power: " ..power .. " / Health: " .. health_current, 1)	--DEBUG
					trigger.action.explosion(point, power)													--apply explosion
					counter = counter + 1																	--counter to prevent runaway repeat
				until health_current < health_stored + 5 or counter > 100										--repeat until ship health reaches dieserd level or for a maximum of 100 times
			end
		end
	end
end

-- modification M18.c despawn/destroy Plane on BaseAirStart
local function CheckRtbAirbase()

	-- BaseAirStart = {
		-- ['BA Wahda'] = {
			-- coalition = "blue"
			-- x = 00549355,
			-- y = -00892454, 
			-- elevation = 0,
			-- airdromeId = nil,
			-- ATC_frequency = "0",
			-- BaseAirStart = true,
		-- },
	-- }

	if camp.BaseAirStart then
		for base_name, base in pairs(camp.BaseAirStart) do
			if not base.side and base.coalition then base.side = base.coalition end
			if env.mission.coalition[base.side] then
				for country_n, country in pairs(env.mission.coalition[base.side].country) do
					if country.plane then
						for group_n,group in ipairs(country.plane.group) do
							local groupAero = Group.getByName(group.name)
							if groupAero then
								for n=1  , #group.units do
									local unitAero = groupAero:getUnit(n)
									if unitAero and unitAero ~= nil and unitAero:isActive() and unitAero:inAir() then
										local unitAeroPoint = unitAero:getPoint()
										local unitAeroFuel = unitAero:getFuel()
										local alti = unitAeroPoint.y - base.elevation
										if alti <= 1000 and unitAeroFuel <= 0.75 then
											env.info( "DCE_EventsTracker.lua file PASSE 11 SPAWN BaseAirStart "..tostring(group.units[n].name).." ||Alti: "..tostring(alti).." ||Fuel: "..tostring(unitAeroFuel))
											local distance = math.floor(math.sqrt(math.pow(base.x - unitAeroPoint.x, 2) + math.pow(base.y - unitAeroPoint.z, 2)))
											if distance <= 20000 then
												unitAero:destroy()
											end
										end
									end
								end
							end
						end
					end
				end
			else
				env.info( "DCE_INFO : ***WARNING***, the AIRSTART base "..tostring(base_name).." does not have a declared coalition and therefore cannot despawn aircraft arriving at its level. ")
			end
		end
	end

	return timer.getTime() + 30

end




local function despawnIA()

	local reset = false

	for n = 1, #despawn do

		-- _affiche(despawn, "DCE_despawn")

		env.info("DCE_try despawn "..n)
		-- trigger.action.outText("despawn "..n, 3)
		if despawn[n]:isExist() then
			despawn[n]:destroy()
			-- trigger.action.outText("despawn "..n, 30)
			env.info("DCE_despawn "..n)
		end
			reset = true
	end

	if reset then
		despawn = {}
	end

	return timer.getTime() + 30

end

timer.scheduleFunction(CheckRtbAirbase, nil, timer.getTime() + 5)

timer.scheduleFunction(despawnIA, nil, timer.getTime() + 10)











