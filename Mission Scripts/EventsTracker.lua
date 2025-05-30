--To run during mission to track destroyed static objects and trigger debriefing actions on mission end 
--Script attached to mission and executed via trigger
--Requires DCS os and io functions sanitizer to be deactivated
------------------------------------------------------------------------------------------------------- 
-- MBot version 20200111
-------------------------------------------------------------------------------------------------------
-- last modification  debug_q cleanCode_h
if not versionDCE then versionDCE = {} end
versionDCE["Mission Scripts/EventsTracker.lua"] = "1.12.75"
------------------------------------------------------------------------------------------------------- 

-- test_b 					(b: saved game on another DD)
-- Reglage_d 				(d modified TableSerialization)(c CVN to CV)(a: global pathD)
-- debug_q					(q CleanName)(op prohibited character of player names)(n getCategory)(m Pedro cycle)(n scene life0)(m escorte)(jkl wrong caratere in player names)(i: base.side = base.coalition)(b: n'affiche pas les messages d'error sauf � la fin de mission)
-- cleanCode_h				(g springCleaning)
-- modification M62_a		compatible Datacard Generator or CombatFlite
-- modification M61_j		SAR (j noSAR in wrongSide)
-- modification M50_c		Records landings for later use in logistics (C-130, Transport...) (bc: caractere interdit)
-- modification M40_i		Pedro Helicopter (i use new follow task)
-- modification M37_e		SuperCarrier
-- modification M35_d		(d: info log) version ScriptsMod
-- modification M18_g		despawn (g info bad coalition)(e: option confMod)(d: active unit) (cf despawn/destroy Plane on BaseAirStart) destroy Plane Landing CV + FARP 
------------------------------------------------------------------------------------------------------- 

env.info("DCE_EventT START LOADING EventsTracker.lua "..tostring(versionDCE["Mission Scripts/EventsTracker.lua"]))

_affiche(world.event, "DCE_EventT world.event ")

Info_event_B = {}

local hit1sQueue = {}
local hit1sQueueTimerId = nil

for eventName, eventId in pairs(world.event) do
	table.insert(Info_event_B, eventId, eventName)
end



if camp.debug then
	local logStr = "Info_event_B = " .. TableSerialization(Info_event_B, 0)
	local logFile = io.open(PathDCE.."Debug\\Info_event_B.lua", "w")
	if logFile then
		logFile:write(logStr)
		logFile:close()
	else
		env.info("DCE_EventT Info_event_B: Failed to open log file for writing.")
	end
end



env.info("DCET_testingConstante: Unit.Category.AIRPLANE "..tostring(Unit.Category.AIRPLANE))
env.info("DCET_testingConstante: Unit.Category.HELICOPTER "..tostring(Unit.Category.HELICOPTER))
env.info("DCET_testingConstante: Unit.Category.GROUND_UNIT "..tostring(Unit.Category.GROUND_UNIT))
env.info("DCET_testingConstante: Unit.Category.SHIP "..tostring(Unit.Category.SHIP))
env.info("DCET_testingConstante: Unit.Category.STRUCTURE "..tostring(Unit.Category.STRUCTURE))

local scenLog = {}
local eventIdTotal = {}
local tabEjection = {}
local despawn = {}
local eventHandlerDCE = {}
local refuelProgressTimerId = nil
-- EventHandler robuste pour détecter uniquement les bombes larguées
local bombTracker = {}
local trackedBombs = {}

local function WarningText()
	local text = "WARNING:\n"
	text = text .. "sanitizeModule('os') in MissionScripting.lua has not been disabled. Mission results will not be accounted and campaign will not progress."
	text = text .. "\n\nMissionScripting.lua gets automatically restored to default state after every DCS update and has to be manually adjusted each time. Modification at your own risk."
	trigger.action.outText(text, 600)
end
local ErrorMessage = timer.scheduleFunction(WarningText, {}, timer.getTime() + 1)	--schedule output of warning text
local check = os.time()															--run random os function. If os functions are sanitized this will fail and stop the script
timer.removeFunction(ErrorMessage)												--if the script continues to here, os functions work and the sdchedzled warning message is removed

local function debugBomb(msg)
    env.info("[DCE/BOMB] " .. msg)
end


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
		-- local initDesc = healthTemp.objSujet:getDesc()	--tooHeavy

		local health1s_entry = {
			PilotName = healthTemp.PilotName,
			lifeActual1s = lifeActual1s,
			health0 = healthTemp.health0,
			lifePourcent = lifePourcent,
			event = healthTemp.typeEvent,
			-- description = initDesc,	--tooHeavy
		}

		table.insert(CustomLog, health1s_entry)
	end
end

--1s apres le hit, la valeur est plus proche de la réalité
local function schedulHit(hitTemp)


	scenLog[hitTemp.scenaryName] = {							--add scenery object to table
		lifePourcent = 0,
		x = hitTemp.x,
		y = hitTemp.y,
		z = hitTemp.z,
		event = hitTemp.event,
	}

end

--1s apres le hit, la valeur est plus proche de la réalité
local function addHit1s(hitTemp)

	if scenLog and scenLog[hitTemp.scenaryName] and scenLog[hitTemp.scenaryName].event == "S_EVENT_DEAD" then
		env.info( "DCE_EventT addHit1s  B return S_EVENT_DEAD "..tostring(hitTemp.scenaryName))
		return
	end

	local lifeActual1s = hitTemp.objScen:getLife()
	local lifePourcent

	if hitTemp.lifeHit > lifeActual1s then
		lifePourcent = (lifeActual1s/hitTemp.hightLife) * 100
	else
		lifePourcent = ( hitTemp.lifeHit/hitTemp.hightLife) * 100
		env.info( "DCE_EventT addHit1s  C lifeActual1s ERROR "..tostring(hitTemp.scenaryName))
	end

	scenLog[hitTemp.scenaryName] = {							--add scenery object to table
		scenaryName = hitTemp.scenaryName,
		sceneryTypeName = hitTemp.sceneryTypeName,
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
		event = hitTemp.event,
		explosiveMass = hitTemp.explosiveMass,
		weaponName = hitTemp.weaponName,
	}
	if hitTemp.description and camp.debug then
		scenLog[hitTemp.scenaryName]["description"] = hitTemp.description	--tooHeavy
	end
end

local function destructionScenaryInZone(point, radius, launcherName)

	if radius > 1000 then
		env.info("DCE_EventT destructionScenaryInZone: radius too big, RETURN ")
		return
	end

	local function IfFound(obj)
		local objName = obj:getName()
		local objType = obj:getTypeName()
		local objVec3 = obj:getPoint()
		
		if not scenLog[objName] then

			-- Optimisation: évite de traiter les objets de forêt (très nombreux) pour économiser du CPU
			-- On ne fait la détection qu'une fois, et on saute le traitement si c'est une forêt
			if objType and objType:find("FOREST", 1, true) then
				return -- On sort immédiatement, on ne log pas les forêts
			end

			scenLog[objName] = {
				event = "BOMB_IMPACT_ZONE",
				-- weaponName = weaponName,
				-- explosiveMass = explosiveMass,
				x = objVec3.x,
				y = objVec3.y,
				z = objVec3.z,
				initiator = launcherName,
				time = timer.getTime(),
				-- valid = true,
			}
			
		end

	end

	local searchArea = {
		id = world.VolumeType.SPHERE,
		params = {
			point = {
				x = point.x,
				y = land.getHeight({x = point.x, y = point.z}),
				z = point.z
			},
			radius = radius
		}
	}
	world.searchObjects(Object.Category.SCENERY, searchArea, IfFound)
end

local function processhit1sQueue()
    local batchSize = 10
    local count = 0
    while #hit1sQueue > 0 and count < batchSize do
        local hitTemp = table.remove(hit1sQueue, 1)
        -- addHit1s(hitTemp)
		schedulHit(hitTemp)		--schedule hit 1s after the hit
        count = count + 1
    end
    if #hit1sQueue > 0 then
        return timer.getTime() + 0.7
    else
        hit1sQueueTimerId = nil -- plus rien à traiter, on arrête le cycle
        return nil
    end
end


-- Calcule le prochain intervalle de suivi selon l'altitude
local function getTrackingInterval(alt)
    if alt > 5000 then return 3.0 end     -- Haute altitude
    if alt > 1000 then return 2.0 end     -- Moyenne
    return 0.3                            -- Basse, proche sol
end

local function trackBomb(bomb, desc, initiator)
    -- Génère un ID unique même si bomb:getID() n'existe plus
    local id = (bomb and bomb.getID and bomb:getID()) or GenerateIdAleatoire()
    local lastPos = nil
    local weaponName = desc and (desc.displayName or (bomb and bomb.getTypeName and bomb:getTypeName()) or "unknown") or "unknown"
    local explosiveMass = desc and desc.warhead and desc.warhead.explosiveMass or 0
    -- local warheadMass = desc and desc.warhead and desc.warhead.mass or 0
    local launcherName = initiator and initiator.getName and initiator:getName() or "unknown"

    -- debugBomb("Tracking bombe : " .. weaponName .. " | ID: " .. tostring(id))

    local function checkBomb()
        if not bomb or not (bomb.isExist and bomb:isExist()) then
            if lastPos and lastPos.x and lastPos.y and lastPos.z then
                -- debugBomb(string.format(" Bombe %s tombée à %.1f / %.1f / %.1f", weaponName, lastPos.x, lastPos.y, lastPos.z))
                scenLog["BOMB_"..id] = {
                    event = "BOMB_IMPACT",
                    weaponName = weaponName,
                    explosiveMass = explosiveMass,
                    -- warheadMass = warheadMass,
                    x = lastPos.x,
                    y = lastPos.y,
                    z = lastPos.z,
                    initiator = launcherName,
                    time = timer.getTime(),
                    valid = true,
                }

				--ajoute ici une fonction pour detecter les batiments dans la zone de souffle
				local correctedRadius = 50
				if explosiveMass then
					local k_val = 4.0  -- k = 4 par défaut, typique pour bâtiments légers
					correctedRadius = k_val * (explosiveMass)^(1/3)
				end

				-- Ajoute la détection de destruction de bâtiments dans la zone de souffle avec un timer pour diluer les requêtes
				local delay = 120
				local function scheduleDestructionScenery(repeatCount)
					destructionScenaryInZone(lastPos, correctedRadius, launcherName)
					if repeatCount > 1 then
						timer.scheduleFunction(function()
							scheduleDestructionScenery(repeatCount - 1)
						end, {}, timer.getTime() + 0.9)
					end
				end
				-- Lance la première détection après 60s, puis 9 autres espacées de 0.1s (total 10 exécutions)
				timer.scheduleFunction(function()
					scheduleDestructionScenery(10)
				end, {}, timer.getTime() + delay)

            else
                -- debugBomb(" Bombe a disparu sans position finale.")
                scenLog["BOMB_"..id] = {
                    event = "BOMB_IMPACT",
                    weaponName = weaponName,
                    explosiveMass = explosiveMass,
                    -- warheadMass = warheadMass,
                    x = 0, y = 0, z = 0,
                    initiator = launcherName,
                    time = timer.getTime(),
                    valid = false,
                }
            end
            trackedBombs[id] = nil
            return
        end

        local success, pos = pcall(function() return bomb:getPoint() end)
        if success and pos and pos.x and pos.y and pos.z then
            lastPos = pos
        else
            -- debugBomb("Erreur sur getPoint(), bombe probablement supprimée trop tôt.")
        end

        local alt = lastPos and lastPos.y or 0
        local nextCheck = getTrackingInterval(alt)
        timer.scheduleFunction(checkBomb, {}, timer.getTime() + nextCheck)
    end

    trackedBombs[id] = true
    checkBomb()
end


-- Fonction périodique pour notifier le joueur pendant le ravitaillement
local function CheckRefuelProgress()
    local anyRefueling = false
	env.info("DCE_EventT_Refuel PROGRESS_A0")

    for uid, unitFuel in pairs(RefuelStartByUnit) do
		env.info("DCE_EventT_Refuel PROGRESS_A1 uid "..tostring(uid).." fuelStart "..tostring(unitFuel.fuel))

		-- RefuelStartByUnit[uid] = {
		-- 	fuel = event.initiator:getFuel(),
		-- 	uName = uName,
		-- }

		env.info("DCE_EventT_Refuel PROGRESS_A2a unitFuel.uName "..tostring(unitFuel.uName).." unitFuel.fuel "..tostring(unitFuel.fuel))

		local unit = nil
		-- if unitFuel.uName.getByName then
			unit = Unit.getByName(unitFuel.uName)
			env.info("DCE_EventT_Refuel PROGRESS_A2b ")
		-- end
		env.info("DCE_EventT_Refuel PROGRESS_B0 eee uid "..tostring(uid).." unit "..tostring(unit))

		--  if unit then
		-- 	env.info("DCE_EventT_Refuel PROGRESS_B1 unit ")
		--  end
		-- if unit and unit.isExist and unit:isExist() then
		-- 	env.info("DCE_EventT_Refuel PROGRESS_B2 isExist ")
		--  end
		-- if unit and unit.inAir and unit:inAir() then
		-- 	env.info("DCE_EventT_Refuel PROGRESS_B3 inAir ")
		--  end

        if unit and unit.isExist and unit.inAir and unit:isExist() and unit:inAir() then
			

            anyRefueling = true
            local desc = unit:getDesc()
            local fuelMassMax = desc and desc.fuelMassMax or 0
            local fuelNow = unit:getFuel()
			env.info("DCE_EventT_Refuel PROGRESS_C fuelMassMax "..tostring(fuelMassMax).." fuelNow "..tostring(fuelNow))

            if fuelMassMax > 0 and fuelNow then
				env.info("DCE_EventT_Refuel PROGRESS_D")
                local fuelKg = (fuelNow > 1 and fuelMassMax or fuelNow * fuelMassMax)
                local fuelLbs = fuelKg * 2.20462
                if not RefuelNotifyByUnit[uid] then
					env.info("DCE_EventT_Refuel PROGRESS_E")
                    RefuelNotifyByUnit[uid] = math.floor(fuelKg * 2.20462 / 1000) * 1000 + 1000
                end
                while fuelLbs >= RefuelNotifyByUnit[uid] do
					
                    -- local playerName = unit.getPlayerName and unit:getPlayerName()
					local playerName = unit:getPlayerName()
					env.info("DCE_EventT_Refuel PROGRESS_F playerName "..tostring(playerName).." RefuelNotifyByUnit[uid] "..tostring(RefuelNotifyByUnit[uid]).." fuelLbs "..tostring(fuelLbs))
                    if playerName then
						env.info("DCE_EventT_Refuel PROGRESS_H")
                        trigger.action.outTextForUnit(uid,
                            string.format("Fuel on board: %.0f lbs", RefuelNotifyByUnit[uid]), 5)
                    end
                    RefuelNotifyByUnit[uid] = RefuelNotifyByUnit[uid] + 1000
                end
            end
        end
    end
    if anyRefueling then
		env.info("DCE_EventT_Refuel PROGRESS_Y scheduleFunction ")
        refuelProgressTimerId = timer.scheduleFunction(CheckRefuelProgress, nil, timer.getTime() + 5)
    else
		env.info("DCE_EventT_Refuel PROGRESS_Z NIL")
        refuelProgressTimerId = nil -- plus personne ne ravitaille, on arrête le cycle
    end
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

	--https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/DCS.html
	--https://wiki.hoggitworld.com/view/DCS_enum_world

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
		[51] = "S_EVENT_MAC_EXTRA_SCORE",
		[52] = "S_EVENT_MISSION_RESTART",
		[53] = "S_EVENT_MISSION_WINNER",
		[54] = "S_EVENT_RUNWAY_TAKEOFF",
		[55] = "S_EVENT_RUNWAY_TOUCH",
		[56] = "S_EVENT_MAC_LMS_RESTART",
		[57] = "S_EVENT_SIMULATION_FREEZE",
		[58] = "S_EVENT_SIMULATION_UNFREEZE",
		[59] = "S_EVENT_HUMAN_AIRCRAFT_REPAIR_START",
		[60] = "S_EVENT_HUMAN_AIRCRAFT_REPAIR_FINISH",
		[61] = "S_EVENT_MAX",
	}


	if event and event.id then
		if Info_event then

			if Info_event[tonumber(event.id)] then
				local idLabel = tostring(Info_event[tonumber(event.id)])

				if not log_entry.type then
					log_entry.type = idLabel
				end
				

				if camp.debug then
					-- env.info("DCE_EventsTracker event.id "..tostring(event.id).." " ..idLabel)

				end
			else
				if camp.debug then
					-- env.info("DCE_EventsTracker this is a  NEW ID "..tostring(event.id))
				end
			end
		end
	end

	if not eventIdTotal[event.id] then eventIdTotal[event.id] = 0 end
	eventIdTotal[event.id] = eventIdTotal[event.id] + 1

	--recupere le SIDE une fois pour toute:
	local initiatorSideName
	local targetSideName

	local initiatorObjCategory
	local targetObjCategory

	if event.initiator then
		initiatorObjCategory = Object.getCategory(event.initiator)
		--DCE_EventsTracker initiator Category 0 _: nil
		-- if camp.debug then env.info("DCE_EventsTracker initiator Category: "..tostring(initiatorObjCategory)) end
		if Object_Category[initiatorObjCategory] then
			-- if camp.debug then env.info("DCE_EventsTracker initiator Object_Category :  _:_ "..tostring(Object_Category[initiatorObjCategory])) end

			-- if initiatorObjCategory ~= Object.Category.SCENERY then
			-- 	local initiatorCoalition = event.initiator:getCoalition()
			-- 	initiatorSideName = coalitionIdNumeric[tonumber(initiatorCoalition)]
			-- end
			if event.initiator.getCoalition then
				local initiatorCoalition = event.initiator:getCoalition()
				initiatorSideName = coalitionIdNumeric[tonumber(initiatorCoalition)]
			end
		end
	end

	if event.target then
		targetObjCategory = Object.getCategory(event.target)

		-- if camp.debug then  env.info("DCE_EventsTracker target Category: "..tostring(targetObjCategory)) end

		if Object_Category[targetObjCategory] then
			local targetDesc = event.target:getDesc()
			
			local targetObjCategory2 = targetDesc.category
			-- if camp.debug then  env.info("DCE_EventsTracker target targetObjCategory2: "..tostring(targetObjCategory2)) end

			-- if camp.debug then  env.info("DCE_EventsTracker target Object_Category :  _:_ "..tostring(Object_Category[targetObjCategory])) end
			
			-- static:getDesc().category
			-- if targetObjCategory ~= Object.Category.SCENERY then
			-- 	if event.target:isExist() then
			-- 		local targetCoalition = event.target:getCoalition()
			-- 		targetSideName = coalitionIdNumeric[tonumber(targetCoalition)]
			-- 	end
			-- end

			if event.target.getCoalition then
				-- if event.target:isExist() then
					local targetCoalition = event.target:getCoalition()
					targetSideName = coalitionIdNumeric[tonumber(targetCoalition)]
				-- end
			end

		end
	end


	if log_entry.type == "eject"  then
		if event.initiator then
			local ptEvent = event.initiator:getPoint()
			local PilotEjection = {}
			local side
			if ptEvent and ptEvent.x then

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
						-- PilotEjection.initiatorPilotName = PilotEjection.initiatorPilotName:gsub('[%p]', '_')
						PilotEjection.initiatorPilotName = CleanName(PilotEjection.initiatorPilotName)
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

				-- _affiche(PilotEjection, " PilotEjection |log_entry.type == eject")

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

				-- table.insert(CustomLog, log_entry)

			end
			if initiatorSideName then
				log_entry.initiatorSideName = initiatorSideName
			end
			if targetSideName then
				log_entry.targetSideName = targetSideName
			end
		end

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

				-- _affiche(selectedEjection, " selectedEjection |pilot seat separation")

			end
			if initiatorSideName then
				log_entry.initiatorSideName = initiatorSideName
			end
			if targetSideName then
				log_entry.targetSideName = targetSideName
			end
		else
			env.info( "DCE_EventT  PASSE M pilot seat separation, id: "..tostring(event.id).."_type_"..tostring(log_entry.type))
			-- _affiche(event, "BUG pilot seat separation event ")
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

					log_entry.initiatorPilotName = selectedEjection.initiatorPilotName
					log_entry.initiator = selectedEjection.initiator

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

					selectedEjection.name = CleanName(selectedEjection.name)

					-- _affiche(selectedEjection, " selectedEjection |pilot land")

					CheckImmediatSAR(selectedEjection)

					env.info( "DCE_EvenT: createdSoldier? SurfaceType? "..tostring(selectedEjection.SurfaceType))
					-- trigger.action.outText("EvenT:  createdSoldier? SurfaceType? "..tostring(selectedEjection.SurfaceType), 30)

					if selectedEjection.SurfaceType ~= land.SurfaceType.WATER and selectedEjection.SurfaceType ~= land.SurfaceType.RUNWAY  then
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
	elseif log_entry.type == "land" then										--hit event with initiator or any other event (excludes hit events without initiator, like collisions)		
		
		if event.initiator then

			local playerName = event.initiator:getPlayerName()

			if event.place then

				local s =""
				s = s.."| Object.getCategory "..Object.getCategory(event.initiator)
				s = s.."| "..event.initiator:getName()
				-- s = s.." "..event.place:getCategory()
				s = s.."| Airbase.getCategory "..Airbase.getCategory(event.place)
				s = s.."| "..event.place:getName()
				s = s.."| "..event.initiator:getID()
				s = s.."| "..event.initiator:getTypeName()


				log_entry.place = event.place:getName()
				log_entry.placeTypeName = tostring(event.place:getTypeName())
				local baseCoalition = Airbase.getCoalition(event.place)
				log_entry.objCategory = Object.getCategory(event.initiator)

				local initDesc = event.initiator:getDesc()
				local placeDesc = event.place:getDesc()
				
				-- Airbase.Category = {
				-- 	AIRDROME = 0,
				-- 	HELIPAD = 1, 
				-- 	SHIP = 2,
				-- }
				-- if event.place:getCategory() == Airbase.Category.SHIP    and not event.initiator:getPlayerName() then 
				if not playerName then
					if placeDesc.category == Airbase.Category.SHIP then 											-- category ship
						
						--relance un Pedro si c'est un Pedro qui se pose
						if string.find(event.initiator:getName(), "Pedro") then

							--["name"] = "Unit_Pedro_CVN-71 Theodore Roosevelt_1",
							local cvName = event.initiator:getName()
							
							cvName = cvName:gsub( "Unit_Pedro_", "")
							cvName, _ = cvName:match("([^,]+)_([^,]+)")
							
							NeedPedro(cvName, event)

						end

						if initDesc.category == Unit.Category.HELICOPTER then
							table.insert(despawn, event.initiator)
						end

					elseif placeDesc.category == Airbase.Category.HELIPAD then 											-- category ship
						table.insert(despawn, event.initiator)

					end
				end

				
				if initDesc.displayName then
					log_entry.initiator = event.initiator:getName()																							--store initiator name
					log_entry.type_name = event.initiator:getTypeName()

					log_entry.placeTypeName = CleanName(log_entry.placeTypeName)
					log_entry.placeCoalition = Airbase.getCoalition(event.place)
					log_entry.place = CleanName(log_entry.place)

				end

				if Object.getCategory(event.initiator) == Object.Category.UNIT and playerName then			--initiator is a unit debug_ET01.h
					log_entry.initiatorPilotName = playerName
					log_entry.initiatorPilotName = log_entry.initiatorPilotName:gsub("['\"]", '')
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

				local life = event.initiator:getLife()																	--get current life of unit
				local init_life = event.initiator:getLife0()															--get initial life of unit
				log_entry.health = math.ceil(100 / init_life * life)												--store unit health to log entry

				local healthTemp = {
					PilotName = playerName,
					typeEvent = log_entry.type,
					life = life,
					objSujet = event.initiator,
					health0 = init_life,
					health = log_entry.health,
				}

				timer.scheduleFunction(health1s, {healthTemp, event}, timer.getTime() + 1)

			end
		end

	elseif log_entry.type and ((log_entry.type == "hit" and event.initiator) or log_entry.type ~= "hit" ) then												--hit event with initiator or any other event (excludes hit events without initiator, like collisions) 	

		if event.initiator and initiatorObjCategory ~= 0 then																													--event has an initiator	

			-- if event and event.id and Info_event and Info_event[tonumber(event.id)] then
			-- 	local idLabel = tostring(Info_event[tonumber(event.id)])
			-- end

			local initDesc = event.initiator:getDesc()
			if event.initiator.getName then
				log_entry.initiator = event.initiator:getName()
			end
			-- if initDesc.displayName then
			-- 	log_entry.initiator = event.initiator:getName()
			-- end

			if Object.getCategory(event.initiator) == Object.Category.UNIT  then										--initiator is a unit debug_ET01.h

				local unitCat = initDesc.category
				log_entry.initiatorPilotName = event.initiator:getPlayerName()

				if log_entry.initiatorPilotName then
					log_entry.initiatorPilotName = CleanName(log_entry.initiatorPilotName)
				end

				if log_entry.type == "unit lost" and camp.SAR and camp.SAR.pilotEjected then
					if unitCat and (unitCat == Unit.Category.HELICOPTER) then
						if log_entry.initiator and EjectedPilotOnBoard[log_entry.initiator] then
							-- Itérer en boucle inversée pour supprimer des éléments dans une table indexée numériquement
							for i = #EjectedPilotOnBoard[log_entry.initiator], 1, -1 do
								local ejectedPilot_OB_name = EjectedPilotOnBoard[log_entry.initiator][i]

								-- Parcourir les pilotes éjectés dans la campagne
								for pilotN, ejectedPilot_camp in pairs(camp.SAR.pilotEjected) do
									if ejectedPilot_camp.name == ejectedPilot_OB_name then
										-- Marquer le pilote dans la campagne comme "mort"
										ejectedPilot_camp.status = "dead"
										-- Supprimer l'entrée de la table
										table.remove(EjectedPilotOnBoard[log_entry.initiator], i)
										break -- Sortir de la boucle interne car le pilote est déjà traité
									end
								end
							end
						end
					end
				end
			end

			--util uniquement pour les AFAC?
			if log_entry.type == "unit lost" and initiatorObjCategory and (initiatorObjCategory == Object.Category.STATIC or initiatorObjCategory == Object.Category.UNIT) then
				local victimMissionID = event.initiator:getID()
				-- env.info( "DCE_EventT  unitLost_A  victimMissionID: "..tostring(victimMissionID) )

				if victimMissionID and AFAC_targetStatus[victimMissionID] then
					-- env.info( "DCE_EventT  unitLost_B  victimMissionID: "..tostring(victimMissionID) )

					trigger.action.setUserFlag("targetDestroyed_Flag_"..victimMissionID, 1)
					AFAC_targetStatus[victimMissionID] = nil
				end
			end

			-- if initDesc.category and (initDesc.category ~= 0) and Object.getCategory(event.initiator) ~= Object.Category.SCENERY and not initDesc.missileCategory  then				--initator is not a scenery object debug_ET01.h
			-- 	log_entry.initiatorMissionID = event.initiator:getID()
			-- end

			if event.initiator.getID then
				log_entry.initiatorMissionID = event.initiator:getID()																					--store IDs
			end

			if initiatorSideName then
				log_entry.initiatorSideName = initiatorSideName
			end
			if targetSideName then
				log_entry.targetSideName = targetSideName
			end

		end



		if event.target then																														--event has a target

			-- Object.Category
			-- UNIT    1
			-- WEAPON  2
			-- STATIC  3
			-- BASE    4
			-- SCENERY 5
			-- Cargo   6

			-- if targetObjCategory and ( targetObjCategory == Object.Category.UNIT or targetObjCategory == Object.Category.STATIC or targetObjCategory == Object.Category.BASE)  then
			-- 	--Function also works with UNIT, STATIC, BASE
			-- 	log_entry.target = event.target:getName()

			-- 	if targetObjCategory == Object.Category.STATIC or targetObjCategory == Object.Category.UNIT  or targetObjCategory == Object.Category.BASE then
			-- 		log_entry.targetMissionID = event.target:getID()
			-- 	end
			if event.target.getName  then
				--Function also works with UNIT, STATIC, BASE
				log_entry.target = event.target:getName()

				if event.target.getID then
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

			if targetObjCategory and targetObjCategory == Object.Category.UNIT then												--target is a unit
				log_entry.targetPilotName = event.target:getPlayerName()													--store player name
				local desc = event.target:getDesc()
				local unitCat = desc.category

				if log_entry.type == "hit" then																				--log entry is a hit event	
					if unitCat and (unitCat == Unit.Category.AIRPLANE or unitCat == Unit.Category.HELICOPTER) then
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
	end

	--*********************insert CustomLog ********************
	--*********************insert CustomLog ********************
	table.insert(CustomLog, log_entry)
	--*********************insert CustomLog ********************
	--*********************insert CustomLog ********************

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
		os.execute('start "Debriefing" cmd  /k "set \"DCSDIR=%cd%\" &  ' .. PathDD .. ' & cd ' .. PathDCE .. ' & call \"%DCSDIR%\\bin\\luae.exe\" ..\\..\\..\\ScriptsMod.'..camp.versionPackageICM..'\\DEBRIEF_Master.lua"')

	--collect destroyed scenery objects
	-- elseif event.id == world.event.S_EVENT_HIT then
	-- 	if event.target and event.initiator then
	-- 		if Object.getCategory(event.target) == 5 and event.target.getDesc then								--if target is a scenery object
	-- 			local descr = event.target:getDesc()
	-- 			if descr.life and descr.life > 9 then							--only store destroyed scenery that had an initial health bigger than 20
	-- 				local lifeHit = event.target:getLife()
	-- 				-- local live0 = event.target:getLife0()	--ne fonctionne pas avec scenery object
	-- 				local health0 = descr.life
	-- 				local hightLife = health0
	-- 				if lifeHit > hightLife and lifeHit > health0 then
	-- 					hightLife = lifeHit
	-- 				end
	-- 				local lifePourcent = (lifeHit/hightLife) * 100

	-- 				local initPoint = event.target:getPoint()				--get point of hit scenery object

	-- 				local scenaryName = event.target:getName()

	-- 				local wep = event.weapon
	-- 				local descWep = wep:getDesc()
	-- 				-- if descWep and camp.debug then
	-- 				-- 	_affiche(descWep, "DCE_EventsTracker hit descWep ")
	-- 				-- end

	-- 				local explosiveMass = 0
	-- 				if descWep and descWep.warhead and descWep.warhead.explosiveMass then
	-- 					explosiveMass = descWep.warhead.explosiveMass
	-- 				end

	-- 				local weaponName = "inc"
	-- 				if descWep and descWep.displayName then
	-- 					weaponName = descWep.displayName
	-- 				end

	-- 				local sceneryTypeName = "inc"
	-- 				if descr and descr.typeName then
	-- 					sceneryTypeName = descr.typeName
	-- 				end

	-- 				local hitTemp = {
	-- 					scenaryName = scenaryName,
	-- 					sceneryTypeName = sceneryTypeName,
	-- 					objScen = event.target,
	-- 					hightLife = hightLife,
	-- 					health0 = descr.life,									--store initial health of scenery object
	-- 					lasthit = event.initiator:getName(),					--store who hit the scenery object
	-- 					lifeHit = lifeHit,
	-- 					lifePourcent = lifePourcent,
	-- 					x = initPoint.x,
	-- 					y = initPoint.y,
	-- 					z = initPoint.z,
	-- 					-- description = descr,
	-- 					event = "S_EVENT_HIT",
	-- 					initiatorSideName = initiatorSideName,
	-- 					targetSideName = targetSideName,
	-- 					explosiveMass = explosiveMass,
	-- 					weaponName = weaponName,
	-- 					time = log_entry.t,
	-- 					log_equiv = log_entry,
	-- 				}

	-- 				if descr and camp.debug then
	-- 					hitTemp.description = descr
	-- 				end

	-- 				-- timer.scheduleFunction(addHit1s, hitTemp, timer.getTime() + 1)

	-- 				-- Ajoute à la file d'attente au lieu d'appeler directement
    --       			table.insert(hit1sQueue, hitTemp)
	-- 				if not hit1sQueueTimerId then
	-- 					hit1sQueueTimerId = timer.scheduleFunction(processhit1sQueue, nil, timer.getTime() + 0.1)
	-- 				end

	-- 			end
	-- 		end
	-- 	end
	elseif event.id == world.event.S_EVENT_HIT then
		if event.target and event.initiator then
			if targetObjCategory == Object.Category.SCENERY and event.target.getDesc then

				local lifePourcent = 0

				local initPoint = event.target:getPoint()

				local scenaryName = event.target:getName()

				local wep = event.weapon
				local descWep = wep:getDesc()
				

				local hitTemp = {
					scenaryName = scenaryName,
					lasthit = event.initiator:getName(),
					lifePourcent = lifePourcent,
					x = initPoint.x,
					y = initPoint.y,
					z = initPoint.z,
					event = "S_EVENT_HIT",
					
				}

				-- Ajoute à la file d'attente au lieu d'appeler directement
				table.insert(hit1sQueue, hitTemp)
				if not hit1sQueueTimerId then
					hit1sQueueTimerId = timer.scheduleFunction(processhit1sQueue, nil, timer.getTime() + 0.1)
				end
			end
		end
	elseif event.id == world.event.S_EVENT_DEAD then
		if event.initiator then
			if initiatorObjCategory == 5 then							--if initiator is a scenery object
				local scenaryName = event.initiator:getName()

				if scenLog[scenaryName] then
					local initPoint = event.initiator:getPoint()				--get point of dead scenery object
					scenLog[scenaryName].x = initPoint.x
					scenLog[scenaryName].y = initPoint.y
					scenLog[scenaryName].z = initPoint.z
					scenLog[scenaryName].event = "S_EVENT_DEAD"
					local initDesc = event.initiator:getDesc()																									--debug ET01	
					if initDesc then
						scenLog[scenaryName].Desc = initDesc
					end
				end
			end
		end
	elseif event.id == world.event.S_EVENT_UNIT_LOST then
		if event.initiator then
			if initiatorObjCategory == 5 then							--if initiator is a scenery object

				local scenaryName = event.initiator:getName()

				if scenLog[scenaryName] then
					local initPoint = event.initiator:getPoint()				--get point of dead scenery object
					scenLog[scenaryName].x = initPoint.x
					scenLog[scenaryName].y = initPoint.y
					scenLog[scenaryName].z = initPoint.z

					scenLog[scenaryName].event = "S_EVENT_UNIT_LOST"

					local initDesc = event.initiator:getDesc()																									--debug ET01	
					if initDesc then
						scenLog[scenaryName].Desc = initDesc
					end
				end
			end
		end
	elseif event.id == world.event.S_EVENT_KILL then
		if event.initiator then
			if initiatorObjCategory == 5 then							--if initiator is a scenery object
				local scenaryName = event.initiator:getName()

				if scenLog[scenaryName] then
					local initPoint = event.initiator:getPoint()				--get point of dead scenery object
					scenLog[scenaryName].x = initPoint.x
					scenLog[scenaryName].y = initPoint.y
					scenLog[scenaryName].z = initPoint.z

					scenLog[scenaryName].event = "S_EVENT_KILL"

					local initDesc = event.initiator:getDesc()																									--debug ET01	
					if initDesc then
						scenLog[scenaryName].Desc = initDesc
					end
				end
			end
		end
	elseif event.id == world.event.S_EVENT_REFUELING then
		if event.initiator and event.initiator.getFuel then
			local uid = event.initiator:getID()
			local uName = event.initiator:getName()
			RefuelStartByUnit[uid] = {
				fuel = event.initiator:getFuel(),
				uName = uName,
			}

			-- env.info("DCE_EventT_Refuel START_A for unit " .. event.initiator:getName() .. " / Fuel before refuel: " .. string.format("%.2f", RefuelStartByUnit[uid] * 100) .. "%")
			-- env.info("DCE_EventT_Refuel START_A2 refuelProgressTimerId: "..tostring(refuelProgressTimerId))

			-- Lance le cycle uniquement s'il n'est pas déjà lancé
			if not refuelProgressTimerId then
				env.info("DCE_EventT_Refuel START_B ")
				refuelProgressTimerId = timer.scheduleFunction(CheckRefuelProgress, nil, timer.getTime() + 5)
			end
		end

	elseif event.id == world.event.S_EVENT_REFUELING_STOP then
		env.info("DCE_EventT_Refuel STOP_A S_EVENT_REFUELING_STOP")

		if event.initiator and event.initiator.getFuel and event.initiator.isExist and event.initiator:isExist() then
			local uid = event.initiator:getID()
			local fuelBefore = RefuelStartByUnit[uid].fuel

			env.info("DCE_EventT_Refuel STOP_B1 uid: " .. tostring(uid) .. " / fuelBefore: " .. tostring(fuelBefore))
			_affiche(RefuelStartByUnit, "DCE_EventT_Refuel STOP_B2 RefuelStartByUnit")

			if fuelBefore then
				
				local fuelAfter = event.initiator:getFuel()
				local fuelTransferred = fuelAfter - fuelBefore
				local desc = event.initiator:getDesc()
				local fuelMassMax = desc and desc.fuelMassMax or 0
				local fuelTransferredKg = math.floor(fuelTransferred * fuelMassMax)
				local fuelTransferredLbs = math.floor(fuelTransferredKg * 2.20462 + 0.5)
				local playerName = event.initiator.getPlayerName and event.initiator:getPlayerName()
				env.info("DCE_EventT_Refuel STOP_C playerName: " .. tostring(playerName))
				if playerName then
					trigger.action.outTextForUnit(event.initiator:getID(),
							string.format("Fuel transferred: %.0f lbs", fuelTransferredLbs), 10)

					env.info("DCE_EventT_Refuel Stop for unit " .. event.initiator:getName()
						.. " / Fuel transferred: " .. string.format("%.0f kg (%.0f lbs)", fuelTransferredKg, fuelTransferredLbs))
				end
				RefuelStartByUnit[uid] = nil
				RefuelNotifyByUnit[uid] = nil
			end
			-- Le timer s'arrêtera tout seul si plus personne ne ravitaille (voir CheckRefuelProgress)
		end
	elseif event.id == world.event.S_EVENT_SHOT then
        local weapon = event.weapon
        if weapon and weapon.getDesc and weapon.isExist and weapon:isExist() then
            local desc = weapon:getDesc()
            if desc and desc.category == Weapon.Category.BOMB then
                trackBomb(weapon, desc, event.initiator)
            end
        end
	elseif event.id == world.event.S_EVENT_TAKEOFF then
        
		local flightName = "inc_"..timer.getTime()
		if event.initiator and event.initiator.getGroup then
			local group = event.initiator:getGroup()
			if group and group.getName then
				flightName = group:getName()
				-- flightName est maintenant le nom du groupe d'avion
			end
		end
		
		if not SatusGroupAircraft[flightName] then 
			SatusGroupAircraft[flightName] = {
				["spawn"] = false,
				["takeoff"] = false,
				["landing"] = false,
			}
		end

		SatusGroupAircraft[flightName]["takeoff"] = true

		-- if camp.debug then
		-- 	env.info( "DCE_Event S_EVENT_TAKEOFF "..flightName)
		-- 	_affiche(SatusGroupAircraft, "DCE_Event S_EVENT_TAKEOFF SatusGroupAircraft")
		-- end
		

    elseif event.id == world.event.S_EVENT_LAND then
        
		local flightName = "inc_"..timer.getTime()
		if event.initiator and event.initiator.getGroup then
			local group = event.initiator:getGroup()
			if group and group.getName then
				flightName = group:getName()
				-- flightName est maintenant le nom du groupe d'avion
			end
		end
		
		if not SatusGroupAircraft[flightName] then 
			SatusGroupAircraft[flightName] = {
				["spawn"] = false, 
				["takeoff"] = false, 
				["landing"] = false,
			}
		end

		SatusGroupAircraft[flightName]["landing"] = true

		-- if camp.debug then
		-- 	env.info( "DCE_Event S_EVENT_LAND "..flightName)
		-- 	_affiche(SatusGroupAircraft, "DCE_Event S_EVENT_LAND SatusGroupAircraft")
		-- end

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
											local distance = math.floor(math.sqrt(math.pow(base.x - unitAeroPoint.x, 2) + math.pow(base.y - unitAeroPoint.z, 2)))

											
											if distance <= 20000 then

												env.info( "DCE_CheckRtbAirbase despawn/destroy BaseAirStart "..tostring(group.units[n].name)
													.." ||Alti: "..tostring(alti)
													.." ||Fuel: "..tostring(unitAeroFuel)
													.." ||distance: "..tostring(distance)
												)
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
			-- env.info("DCE_despawn "..n)
			env.info("DCE_despawnIA despawn/destroy "..n)
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

env.info("DCE_EventT END OF LOADING EventsTracker script ")

