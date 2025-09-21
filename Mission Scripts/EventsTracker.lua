--To run during mission to track destroyed static objects and trigger debriefing actions on mission end 
--Script attached to mission and executed via trigger
--Requires DCS os and io functions sanitizer to be deactivated
------------------------------------------------------------------------------------------------------- 
-- MBot version 20200111
-------------------------------------------------------------------------------------------------------
-- last modification  debug_q cleanCode_h
if not versionDCE then versionDCE = {} end
versionDCE["Mission Scripts/EventsTracker.lua"] = "1.13.76"
------------------------------------------------------------------------------------------------------- 

-- test_b 					(b: saved game on another DD)
-- Reglage_d 				(d modified TableSerialization)(c CVN to CV)(a: global pathD)
-- debug_q					(q CleanName)(op prohibited character of player names)(n getCategory)(m Pedro cycle)(n scene life0)(m escorte)(jkl wrong caratere in player names)(i: base.side = base.coalition)(b: n'affiche pas les messages d'error sauf � la fin de mission)
-- cleanCode_h				(g springCleaning)
-- modification M88_a		CheckRefuelProgress
-- modification M62_a		compatible Datacard Generator or CombatFlite
-- modification M61_j		SAR (j noSAR in wrongSide)
-- modification M50_c		Records landings for later use in logistics (C-130, Transport...) (bc: caractere interdit)
-- modification M40_i		Pedro Helicopter (i use new follow task)
-- modification M37_e		SuperCarrier
-- modification M35_d		(d: info log) version ScriptsMod
-- modification M18_g		despawn (g info bad coalition)(e: option confMod)(d: active unit) (cf despawn/destroy Plane on BaseAirStart) destroy Plane Landing CV + FARP 
------------------------------------------------------------------------------------------------------- 

env.info("DCE_EventT START LOADING EventsTracker.lua "..tostring(versionDCE["Mission Scripts/EventsTracker.lua"]))

env.info("DCE_EventT env.mission.theatre?: "..tostring(env.mission.theatre ))

_affiche(world.event, "DCE_EventT world.event ")

Info_event_C = {}

for eventName, eventId in pairs(world.event) do
	if not Info_event_C[eventId] then
		Info_event_C[eventId] = eventName
	end
end
_affiche(Info_event_C, "DCE_EventTInfo_event_C ")

Info_event_B = {}

local hit1sQueue = {}
local hit1sQueueTimerId = nil
local refuelStartByUnit = {}					--table used to store the start time of refueling for each unit
local refuelNotifyByUnit = {}				--table used to store the notification time for refueling for each unit
local tankerToPlane = {}		--table to store refueling units
local survey_EVENT_BDA = false	--

-- Paramètres globaux pour le flood BDA
local bdaTimestamps = {}
local BDA_WINDOW = 0.4      -- fenêtre de temps en secondes
local BDA_THRESHOLD = 15    -- nombre d'événements BDA tolérés dans cette fenêtre

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
local bombTracker = {}	--TODO pourquoi non utilisé?
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

	if healthTemp then
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

	local function if_found(obj)
		local objName = obj.getName and obj:getName() or "unknown"
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
				y = objVec3.z,
				z = objVec3.y,
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
	world.searchObjects(Object.Category.SCENERY, searchArea, if_found)
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
    local lastPosVec3 = nil
    local weaponName = desc and (desc.displayName or (bomb and bomb.getTypeName and bomb:getTypeName()) or "unknown") or "unknown"
    local explosiveMass = desc and desc.warhead and desc.warhead.explosiveMass or 0
    -- local warheadMass = desc and desc.warhead and desc.warhead.mass or 0
    local launcherName = initiator and initiator.getName and initiator:getName() or "unknown"

    -- debugBomb("Tracking bombe : " .. weaponName .. " | ID: " .. tostring(id))

    local function checkBomb()
        if not bomb or not (bomb.isExist and bomb:isExist()) then
            if lastPosVec3 and lastPosVec3.x and lastPosVec3.y and lastPosVec3.z then
                -- debugBomb(string.format(" Bombe %s tombée à %.1f / %.1f / %.1f", weaponName, lastPos.x, lastPos.y, lastPos.z))
                scenLog["BOMB_"..id] = {
                    event = "BOMB_IMPACT",
                    weaponName = weaponName,
                    explosiveMass = explosiveMass,
                    -- warheadMass = warheadMass,
                    x = lastPosVec3.x,
                    y = lastPosVec3.z,
                    z = lastPosVec3.y,
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
					destructionScenaryInZone(lastPosVec3, correctedRadius, launcherName)
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

        local success, posVec3 = pcall(function() return bomb:getPoint() end)
        if success and posVec3 and posVec3.x and posVec3.y and posVec3.z then
            lastPosVec3 = posVec3
        else
            -- debugBomb("Erreur sur getPoint(), bombe probablement supprimée trop tôt.")
        end

        local alt = lastPosVec3 and lastPosVec3.y or 0
        local nextCheck = getTrackingInterval(alt)
        timer.scheduleFunction(checkBomb, {}, timer.getTime() + nextCheck)
    end

    trackedBombs[id] = true
    checkBomb()
end


-- Fonction périodique pour notifier le joueur pendant le ravitaillement
local function CheckRefuelProgress()
    local anyRefueling = false
	
    for uid, plane in pairs(refuelStartByUnit) do

		-- env.info("DCE_EventT_Refuel PROGRESS_A2 plane.uName "..tostring(plane.uName).." plane.fuel "..tostring(plane.fuel))

		if refuelStartByUnit[uid].status == "REFUELING" then
			-- env.info("DCE_EventT_Refuel PROGRESS_A3 REFUELING OK ")

			local plane_obj = nil
			-- if plane.uName.getByName then	--ATTENTION, ça ne marche pas pour les string
			plane_obj = Unit.getByName(plane.uName)
				
			-- env.info("DCE_EventT_Refuel PROGRESS_B0 fff uid "..tostring(uid).." unit "..tostring(plane_obj))

			if (plane_obj and plane_obj.isExist and plane_obj.inAir and plane_obj:isExist() and plane_obj:inAir())  then	--and timerPass

				anyRefueling = true
				local fuelMassMax = plane.fuelMassMax
				local fuelNowPourcent = plane_obj:getFuel()
				-- env.info("DCE_EventT_Refuel PROGRESS_C fuelMassMax "..tostring(fuelMassMax).." fuelNow "..tostring(fuelNowPourcent))

				if fuelMassMax > 0 and fuelNowPourcent then
					
					local fuelNowKg = fuelNowPourcent * fuelMassMax
					local fuelNowLbs = fuelNowKg * 2.20462
					local fuel_now = Deepcopy(plane["unit_kg"] and fuelNowKg or fuelNowLbs)
					
					-- Initialisation si nécessaire
					if not plane.fuel_init_pourcent then
						plane.fuel_init_pourcent = plane_obj:getFuel()		--getFuel() returns pourcent
						-- env.info("DCE_EventT_Refuel PROGRESS_D1 make plane.fuel_init_pourcent "..tostring(plane.fuel_init_pourcent))
					end
					if not plane.fuel then
						plane.fuel_palier = 0
						plane.fuel = Deepcopy(fuel_now)

						-- env.info("DCE_EventT_Refuel PROGRESS_D2 make plane.fuel "..tostring(plane.fuel))
					end

					-- env.info("DCE_EventT_Refuel PROGRESS_D3 add start_time")
					plane.start_time = timer.getTime()

					-- env.info("DCE_EventT_Refuel PROGRESS_D5 fuel_now: "..tostring(fuel_now).." >=? .fuel "..tostring(plane["fuel"] + 1000))

					-- On affiche seulement les paliers de 1000 lbs ajoutés
					while fuel_now >= plane["fuel"] + 1000 do
						plane["fuel"] = plane["fuel"] + 1000
						plane["fuel_palier"] = plane["fuel_palier"] + 1000
						env.info("DCE_EventT_Refuel PROGRESS_F palier atteint ------------------===============>>>>>>>>>>: "..tostring(plane["fuel_palier"]))
						trigger.action.outTextForUnit(uid, string.format("%d lbs ajouté", plane["fuel_palier"]), 5)
					end
				end
			end

		else 	--refuelStartByUnit[uid].status == "REFUELING_STOP" 
		
			local plane_obj = nil
			plane_obj = Unit.getByName(plane.uName)

			-- env.info("DCE_EventT_Refuel PROGRESS_G REFUELING ")

			if (plane_obj and plane_obj.isExist and plane_obj.inAir and plane_obj:isExist() and plane_obj:inAir())  then
				
				anyRefueling = true

				-- env.info("DCE_EventT_Refuel PROGRESS_G2 REFUELING_STOP? "..tostring(refuelStartByUnit[uid].status).." PROGRESS_X getTime "..timer.getTime().." start_time + 120>? "..tostring(plane.start_time + 120))

				if plane.start_time and timer.getTime() > plane.start_time + 120 then

					anyRefueling = false

					env.info("DCE_EventT_Refuel PROGRESS_G3 Z88 = nil") 
					plane.fuel_palier = 0
					plane.fuel_init_pourcent = nil
					plane.fuel = nil
				end
			end
			
		end
    end
    if anyRefueling then
		-- env.info("DCE_EventT_Refuel PROGRESS_Y scheduleFunction + 5s ")
        refuelProgressTimerId = timer.scheduleFunction(CheckRefuelProgress, nil, timer.getTime() + 5)
    else
		env.info("DCE_EventT_Refuel PROGRESS_Z99 NIL")
        refuelProgressTimerId = nil -- plus personne ne ravitaille, on arrête le cycle
    end
end

local eventsSurvey = {

		[world.event.S_EVENT_MISSION_START] = true,--
		[world.event.S_EVENT_MISSION_END] = true,--

		[world.event.S_EVENT_PLAYER_ENTER_UNIT] = true,--
		[world.event.S_EVENT_PLAYER_LEAVE_UNIT] = true,--

		[world.event.S_EVENT_BIRTH] = true,--

		[world.event.S_EVENT_SHOT] = true,--
		[world.event.S_EVENT_HIT] = true,--
		[world.event.S_EVENT_BDA] = true,--
		

		[world.event.S_EVENT_DEAD] = true,--
		[world.event.S_EVENT_KILL] = true,--
		[world.event.S_EVENT_UNIT_LOST] = true,--

		[world.event.S_EVENT_TAKEOFF] = true,--
		[world.event.S_EVENT_LAND] = true,--
		[world.event.S_EVENT_CRASH] = true,--

		[world.event.S_EVENT_REFUELING] = true,--
		[world.event.S_EVENT_REFUELING_STOP] = true,--

		[world.event.S_EVENT_EJECTION] = true,--
		[world.event.S_EVENT_PILOT_DEAD] = true,--
		[world.event.S_EVENT_DISCARD_CHAIR_AFTER_EJECTION] = true,--
		[world.event.S_EVENT_LANDING_AFTER_EJECTION] = true,--

	}

Info_event = {
		[0] = "S_EVENT_INVALID",
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

--###################  ######   #####################################
--###################  MAIN   #####################################
--###################  ######   #####################################

function eventHandlerDCE:onEvent(event)

	if camp.debug then
		if event and event.id then
			if Info_event then
				if Info_event[tonumber(event.id)] then
					local idLabel = tostring(Info_event[tonumber(event.id)])
					env.info("DCE_EventsTracker event.id "..tostring(event.id).." " ..idLabel)
				else
					env.info("DCE_EventsTracker this is a  NEW ID "..tostring(event.id))
				end
			end
		end
	end

	-- on ne traite et surtout on n'enregistre pas les events interressant pour la DCE, sinon surchage CPU
	if eventsSurvey[event.id] then

		if camp.debug then
			env.info("DCE_EventsTracker event.id "..tostring(event.id).." "..tostring(Info_event[event.id]))
		end

		
        -- Anti-flood BDA (global, sans getID ni getName)
        if event.id == world.event.S_EVENT_BDA then

			if survey_EVENT_BDA then

				-- Vérification du flood BDA
				if not bdaTimestamps then
					bdaTimestamps = {}
				end

				env.info("[BDA-FLOOD A] S_EVENT_BDA detected ")

				local now = timer.getTime()
				table.insert(bdaTimestamps, now)

				-- Nettoyage des timestamps trop anciens
				local recent = {}
				for _, t in ipairs(bdaTimestamps) do
					if now - t < BDA_WINDOW then
						table.insert(recent, t)
					end
				end
				bdaTimestamps = recent

				-- Détection du flood
				if #recent >= BDA_THRESHOLD then
					trigger.action.outText("BDA FLOOD détecté : " .. #recent .. " événements en " .. BDA_WINDOW .. "s", 20)
					env.info("[BDA-FLOOD B] Seuil atteint : " .. #recent)
					
					local tgt = event.target
					
					if tgt then

						local tgtName = tgt.getName and tgt:getName() or "unknown"
						
						trigger.action.outText("BDA flood détecté tgtName : " .. tgtName ..  " sera upprimé", 20)
						env.info("[BDA-FLOOD C]BDA flood détecté tgtName : " .. tgtName ..  "  sera upprimé")

						local isPlayer = tgt.getPlayerName and tgt:getPlayerName()
						if not isPlayer and tgtName then
							isPlayer = Players[tgtName]
						end

						if tgt and tgt.isExist and not isPlayer then
							if tgt:isExist() then tgt:destroy() end
							env.info("[BDA-FLOOD C]BDA flood détecté tgtName : " .. tgtName ..  " supprimés OK")
						elseif isPlayer then
							env.info("[BDA-FLOOD C]BDA flood détecté mais la cible est un joueur : " .. tostring(isPlayer) ..  " ne sera pas supprimé")
						end
					end

					local init = event.initiator
					if init then

						local initName = init.getName and init:getName() or "unknown"

						trigger.action.outText("BDA flood détecté initName: "  .. initName .. " supprimé", 20)
						env.info("[BDA-FLOOD C]BDA flood détecté initName: " .. initName .. " supprimé")

						local isPlayer = init.getPlayerName and init:getPlayerName()
						if not isPlayer and initName then
							isPlayer = Players[initName]
						end

						if init and init.isExist and not isPlayer then
							if init:isExist() then init:destroy() end
							env.info("[BDA-FLOOD C]BDA flood détecté initName : " .. initName ..  " supprimés OK")
						elseif isPlayer then
							env.info("[BDA-FLOOD C]BDA flood détecté mais l initiateur est un joueur : " .. isPlayer ..  " ne sera pas supprimé")
						end

						
					end

					bdaTimestamps = {}
				end
			end
        end

   
		
		--custom events log
		local log_entry = {															--create a custom log entry for this event
			t = timer.getTime(),														--store time of event
			infoEvent = Info_event[event.id] or "S_EVENT_UNKNOWN",		--store event name
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
		elseif event.id == world.event.S_EVENT_BASE_CAPTURED then					--10
			log_entry.type = "base captured"
		elseif event.id == world.event.S_EVENT_MISSION_START then					--11
			log_entry.type = "mission start"
		elseif event.id == world.event.S_EVENT_MISSION_END then						--12
			log_entry.type = "mission end"
		elseif event.id == world.event.S_EVENT_TOOK_CONTROL then
			log_entry.type = "took control"
		elseif event.id == world.event.S_EVENT_BIRTH then							--15
			log_entry.type = "birth"
		elseif event.id == world.event.S_EVENT_ENGINE_STARTUP then					--18
			log_entry.type = "engine startup"
		elseif event.id == world.event.S_EVENT_ENGINE_SHUTDOWN then					--19
			log_entry.type = "engine shutdown"
		elseif event.id == world.event.S_EVENT_PLAYER_ENTER_UNIT then				--20
			log_entry.type = "player enter unit"
		elseif event.id == world.event.S_EVENT_PLAYER_LEAVE_UNIT then				--21
			log_entry.type = "player leave unit"
		end
		
		if camp.debug then
			env.info("DCE_EventsTracker log_entry.type: "..tostring(log_entry.type).." | "..tostring(log_entry.infoEvent))
		end

		if not eventIdTotal[event.id] then eventIdTotal[event.id] = 0 end
		eventIdTotal[event.id] = eventIdTotal[event.id] + 1

		--recupere le SIDE une fois pour toute:
		local initiatorSideName
		local initiatorName
        local targetSideName
        local initiatorVec3
		local initiatorId

		local initiatorObjCategory
		local targetObjCategory

		if event.initiator then
			initiatorObjCategory = Object.getCategory(event.initiator)
            initiatorName = event.initiator.getName and event.initiator:getName() or "unknown"
            initiatorVec3 = event.initiator.getPoint and event.initiator:getPoint()
			initiatorId = event.initiator.getID and event.initiator:getID() or "unknown"

			if Object_Category[initiatorObjCategory] then
				if event.initiator.getCoalition then
					local coalitionId = event.initiator:getCoalition()
					initiatorSideName = CoalitionIdToName[tonumber(coalitionId)]
				end
			end
		end

        if event.target then
            targetObjCategory = Object.getCategory(event.target)

           if Object_Category[targetObjCategory] then
                 if event.target.getCoalition then
                    if event.target.isExist and event.target:isExist() then
                        local targetCoalId = event.target:getCoalition() --779: Unit doesn't exist
                        targetSideName = CoalitionIdToName[tonumber(targetCoalId)]
                    else -- pour éviter --779: Unit doesn't exist
                        env.info("DCE_EventsTracker target Unit doesn't exist: Category: " .. tostring(targetObjCategory))
                        -- if event.target.getDesc then
                        -- 	local targetDesc = event.target:getDesc()
                        -- 	_affiche(targetDesc, "DCE_EventsTracker targetDesc ")
                        -- end
                    end
                end
            end
        end
		
		-- if log_entry.type == "birth"  then
		-- 	env.info( "DCE_EventT_birth A, id: "..tostring(event.id).." event.initiator "..tostring(event.initiator))


		-- end

		if log_entry.type == "eject"  then
			env.info( "DCE_EventT_eject A, id: "..tostring(event.id).." event.initiator "..tostring(event.initiator))
			if event.initiator then
				local pilotEjection = {}
				local sideName
				if initiatorVec3 and initiatorVec3.x then
					local altiLand = land.getHeight({ x = initiatorVec3.x, y = initiatorVec3.z })
					pilotEjection = {
						pos = {
							vec3x = initiatorVec3.x,
							vec3y = initiatorVec3.y,
							vec3z = initiatorVec3.z,
							unit = event.initiator,
							x = initiatorVec3.x,
							y = initiatorVec3.z,
							z = initiatorVec3.y,
							altiLand = altiLand,
						},
					}

					local playerName = event.initiator:getPlayerName()
					if playerName then
						local desc = event.initiator:getDesc()
						if desc.category == Unit.Category.HELICOPTER then
							local aircraftName = event.initiator:getName()
							timer.scheduleFunction(MonitorPlayerAircraftActivity, {"out", playerName, aircraftName, desc.category}, timer.getTime() + 1)
						end
					end

					if initiatorName then
						pilotEjection.initiator, log_entry.initiator = initiatorName, initiatorName
					end

					if initiatorObjCategory == Object.Category.UNIT then
						if event.initiator.getPlayerName then
							pilotEjection.pilotName = event.initiator:getPlayerName()
							if pilotEjection.pilotName then
								pilotEjection.pilotName = CleanName(pilotEjection.pilotName)
								log_entry.pilotName = pilotEjection.pilotName
							end
						end
						pilotEjection.coalitionId = event.initiator:getCoalition()
					end

					if initiatorObjCategory ~= Object.Category.SCENERY and event.initiator.getID then				--initator is not a scenery object debug_ET01.h
						pilotEjection.initiatorMissionID = initiatorId                 --store ID
						pilotEjection.coalitionId = event.initiator:getCoalition()
						sideName = CoalitionIdToName[tonumber(pilotEjection.coalitionId)]

						local countryId = event.initiator:getCountry()
						pilotEjection.countryId = countryId
						pilotEjection.countryName = string.lower(country.name[countryId])
					end

					-- land.SurfaceType 
					-- LAND             1
					-- SHALLOW_WATER    2
					-- WATER            3 
					-- ROAD             4
					-- RUNWAY           5
					-- local point = {
					-- 	x = pilotEjection.x,
					-- 	y = pilotEjection.z,
                    -- }
					
					pilotEjection.SurfaceType = land.getSurfaceType({ x = pilotEjection.pos.vec3x, y = pilotEjection.pos.vec3z })
					-- pilotEjection.grid = coord.LLtoMGRS(coord.LOtoLL(pilotEjection.unit:getPosition().p))
					pilotEjection.grid = coord.LLtoMGRS(coord.LOtoLL({x=pilotEjection.pos.vec3x, y=pilotEjection.pos.vec3y, z=pilotEjection.pos.vec3z} ))

					local closeRoad = {}
					-- Roadtype can be 'railroads' or 'roads'
					local x, y = land.getClosestPointOnRoads('roads', pilotEjection.pos.vec3x, pilotEjection.pos.vec3z)
					closeRoad.x = x
					closeRoad.y = y
					pilotEjection.closeRoad = closeRoad

					-- _affiche(pilotEjection, " pilotEjection |DCE_EventT_eject G")

					table.insert(tabEjection, pilotEjection)

                    if event.initiator and event.initiator.getPlayerName then
						env.info( "DCE_EventT_eject H :radioTransmission frequency A  "..tostring(camp.EjectedPilotFrequency[sideName].GuardEjection).." | "..tostring('GuardEjection'..pilotEjection.initiator))

						trigger.action.radioTransmission('l10n/DEFAULT/ejectionRadioBeacon.ogg', pilotEjection, 0, true, camp.EjectedPilotFrequency[sideName].GuardEjection, 0.1, 'GuardEjection'..pilotEjection.initiator)

						env.info( "DCE_EventT_eject I :radioTransmission frequency B  "..tostring(camp.EjectedPilotFrequency[sideName].GuardEjection).." | "..tostring('GuardEjection'..pilotEjection.initiator))
					end

					local ejectionSeatTemp = {
						radio_on = true,
						time_on = log_entry.t,
						name = pilotEjection.initiator,
					}

					table.insert(EjectionSeatFrequency, ejectionSeatTemp)


					--****************************************************************************
					--permet le spawn du soldat meme si le joueur ... s'ejecte d'un helico au sol
					if pilotEjection.pos.z - pilotEjection.pos.altiLand <= 5 then
						if event.initiator.getPlayerName and event.initiator.getGroup then
							-- local playerName = event.initiator:getPlayerName()
							local groupObj = event.initiator:getGroup()

							if playerName and groupObj then

								SumSoldierAliasPilot = SumSoldierAliasPilot + 1

								if pilotEjection.pilotName then
									pilotEjection.name = "Mis" ..
									camp.mission ..
									"_Pilot_" .. pilotEjection.pilotName .. "_Nb" .. tostring(SumSoldierAliasPilot)
								else
									pilotEjection.name = "Mis"..camp.mission.."_Pilot_"..pilotEjection.initiator.."_Nb"..tostring(SumSoldierAliasPilot)
								end

								pilotEjection.name = CleanName(pilotEjection.name)
								
								local distanceBase, baseName = ProxyBase(pilotEjection)
								if distanceBase then
									distanceBase = math.floor(distanceBase)
								else
									distanceBase = 0
								end
								env.info("DCE_EvenT: pilotLand_C G baseName "..tostring(baseName).." distanceBase "..tostring(distanceBase))

								-- if distanceBase > 6000 and pilotEjection.SurfaceType ~= land.SurfaceType.WATER and pilotEjection.SurfaceType ~= land.SurfaceType.RUNWAY  then
								if pilotEjection.SurfaceType ~= land.SurfaceType.WATER and pilotEjection.SurfaceType ~= land.SurfaceType.RUNWAY  then
									AddSoldierAliasPilot(pilotEjection)
									pilotEjection.createdSoldier = true

									--ajoute l'ejectedPilot dans la liste SAR, pour etre recupéré par le module SAR
									pilotEjection = Add_MGRS_Chute(pilotEjection)
									if pilotEjection.MGRS_Chute then
										if ZoneSAR[pilotEjection.MGRS_Chute] == nil then
											ZoneSAR[pilotEjection.MGRS_Chute] = {}
										end
										table.insert(ZoneSAR[pilotEjection.MGRS_Chute], pilotEjection)
									end
								end

								CheckImmediatSAR(pilotEjection)

								
                           		getOut({ groupObj, playerName })
							end
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

		elseif log_entry.type == "pilot seat separation"  then
			env.info( "DCE_EventT_seat A , id: "..tostring(event.id).."_type_"..tostring(log_entry.type))

			if event.initiator then
				if initiatorVec3 and initiatorVec3.x then

					--pour fumigene
					-- local pilotVec3 = {
					-- 	x = initiatorVec3.x,
					-- 	y = land.getHeight({ x = initiatorVec3.x, y = initiatorVec3.z }),
					-- 	z = initiatorVec3.z,
					-- }
					
					log_entry.initiatorMissionID = initiatorId
					log_entry.x = initiatorVec3.x
					log_entry.y = initiatorVec3.z
					log_entry.z = initiatorVec3.y

					--TODO revoir ça, normalement l'id du parachut devrait etre celui de plane, quid d'un biplace?
					--attention l'id disparait si le parachute tombe dans l'eau

					local selected_distance = 9999999
					local selectedEjection = {}

					for n=1, #tabEjection do
						if tabEjection[n] and tabEjection[n] ~= nil then						
							local distance = math.sqrt(math.pow(initiatorVec3.x - tabEjection[n].pos.vec3x, 2) + math.pow(initiatorVec3.z - tabEjection[n].pos.vec3z, 2))
							if distance < selected_distance and (not tabEjection[n].SumEjectedPilotDay) then
								env.info( "DCE_EventT_seat F , selected_distance: "..tostring(selected_distance))
								selected_distance = distance
								selectedEjection = tabEjection[n]
							end
						end
					end

					env.info( "DCE_EventT_seat G , selected_distance: "..tostring(selected_distance))

					if selected_distance <= 4000 then
						log_entry.pilotName = selectedEjection.pilotName
						log_entry.initiator = selectedEjection.initiator

						selectedEjection.pos.vec3x = initiatorVec3.x
						selectedEjection.pos.vec3y = initiatorVec3.y
						selectedEjection.pos.vec3z = initiatorVec3.z
						selectedEjection.pos.x = initiatorVec3.x
						selectedEjection.pos.y = initiatorVec3.z
						selectedEjection.pos.z = initiatorVec3.y
						selectedEjection.pos.altiLand = land.getHeight({ x = initiatorVec3.x, y = initiatorVec3.z })

						if selectedEjection.unit:isExist()  then
							selectedEjection.grid = coord.LLtoMGRS(coord.LOtoLL(selectedEjection.unit:getPosition().p))
						end
					end
				end
				if initiatorSideName then
					log_entry.initiatorSideName = initiatorSideName
				end
				if targetSideName then
					log_entry.targetSideName = targetSideName
				end
			else
				-- env.info( "DCE_EventT_seat, J ")
				-- _affiche(event, "BUG pilot seat separation event ")
			end

		elseif log_entry.type == "pilot land"  then
			env.info( "DCE_EventT_pilot_land A id: "..tostring(event.id))

			if event.initiator then
				if initiatorVec3 and initiatorVec3.x then
					--active fumigene
					-- local pilotVec3 = {
					-- 	x = initiatorVec3.x,
					-- 	-- y = land.getHeight({ x = initiatorVec3.x, y = initiatorVec3.z }),
					-- 	y = initiatorVec3.y,
					-- 	z = initiatorVec3.z,
					-- }
					
					--inscrit position et name dans le log
					log_entry.initiatorMissionID = initiatorId
					log_entry.x = initiatorVec3.x
					log_entry.y = initiatorVec3.z
					log_entry.z = initiatorVec3.y

					local selected_distance = 9999999
					local selPilotEject = {}
					local ejectN = 0
					for n = 1, #tabEjection do
						if tabEjection[n] and tabEjection[n].x then
                            if not initiatorVec3.x then
                                env.info("DCE_EvenT: pilotLand_I pb initiatorVec3.x nil")
								-- _affiche(initiatorVec3, "initiatorVec3 ")
                            end

                            if initiatorVec3.x and tabEjection[n].x then
                                local distance = math.sqrt(math.pow(initiatorVec3.x - tabEjection[n].x, 2) + math.pow(initiatorVec3.z - tabEjection[n].vec3z, 2))
                                if distance < selected_distance and (not tabEjection[n].createdSoldier) then
                                    selected_distance = distance
                                    ejectN = n
                                end
                            end
                        else

							env.info("DCE_EventT_pilot_land J pb tabEjection[n].x nil, n: " .. n .. " total tabEjection " .. #tabEjection)
							-- _affiche(tabEjection[n], "tabEjection[n] ")
							
							local locTime = timer.getTime()
							local logStr = "tabEjection = " .. TableSerialization(tabEjection, 0)
							local logFile = io.open( PathDCE .. "Debug\\tabEjection" .. "_" .. locTime .. "_" .. "tabEjection.lua",
								"w")
							if logFile then
								logFile:write(logStr)
								logFile:close()
							else
								env.info("DCE_EventT_pilot_land K: Failed to open log file for writing.")
							end
							
						end
					end

					env.info( "DCE_EventT_pilot_land L selected_distance: "..tostring(selected_distance))

					if selected_distance <= 8000 and ejectN ~= 0 then

						selPilotEject = tabEjection[ejectN]
						log_entry.pilotName = selPilotEject.pilotName
						log_entry.initiator = selPilotEject.initiator

						--on change la position, car le vent peut pousser le parachute de la mere vers la terre

						selPilotEject = {
							pos = {
								vec3x = initiatorVec3.x,
								vec3y = initiatorVec3.y,
								vec3z = initiatorVec3.z,
								x = initiatorVec3.x,
								y = initiatorVec3.z,
								z = initiatorVec3.y,
								altiLand = land.getHeight({ x = initiatorVec3.x, y = initiatorVec3.z }),
								surfaceType = land.getSurfaceType({x = selPilotEject.x, y = selPilotEject.z})
							}
						}

						SumSoldierAliasPilot = SumSoldierAliasPilot + 1

						if selPilotEject.pilotName then
							selPilotEject.name = "Mis" ..
							camp.mission ..
							"_Pilot_" .. selPilotEject.pilotName .. "_Nb" .. tostring(SumSoldierAliasPilot)
						else
							selPilotEject.name = "Mis"..camp.mission.."_Pilot_"..selPilotEject.initiator.."_Nb"..tostring(SumSoldierAliasPilot)
						end

						selPilotEject.name = CleanName(selPilotEject.name)
						
						local distanceBase, baseName = ProxyBase(selPilotEject)
						if distanceBase then
							distanceBase = math.floor(distanceBase)
						else
							distanceBase = 0
						end
						env.info("DCE_EvenT: pilotLand_C G baseName "..tostring(baseName).." distanceBase "..tostring(distanceBase))

						if distanceBase > 6000 and selPilotEject.SurfaceType ~= land.SurfaceType.WATER and selPilotEject.SurfaceType ~= land.SurfaceType.RUNWAY  then
							AddSoldierAliasPilot(selPilotEject)
                            selPilotEject.createdSoldier = true

                            --ajoute l'ejectedPilot dans la liste SAR, pour etre recupéré par le module SAR
                            selPilotEject = Add_MGRS_Chute(selPilotEject)
							if selPilotEject.MGRS_Chute then
								if ZoneSAR[selPilotEject.MGRS_Chute] == nil then
									ZoneSAR[selPilotEject.MGRS_Chute] = {}
								end
								table.insert(ZoneSAR[selPilotEject.MGRS_Chute], selPilotEject)
							end
						end

						CheckImmediatSAR(selPilotEject)

					end
				end

				if initiatorSideName then
					log_entry.initiatorSideName = initiatorSideName
				end
				if targetSideName then
					log_entry.targetSideName = targetSideName
				end
			end

		elseif log_entry.type == "pilot dead"  then

			if event.initiator then
				-- local ptEventVec3 = event.initiator:getPoint()
				if initiatorVec3 and initiatorVec3.x then
					--TODO les reste n'est pas utilisé, pourquoi?
					local PilotVec3 = {
						x = initiatorVec3.x,
						y = land.getHeight({ x = initiatorVec3.x, y = initiatorVec3.z }),
						z = initiatorVec3.z,
					}
				end
			end

			if initiatorSideName then
				log_entry.initiatorSideName = initiatorSideName
			end
			if targetSideName then
				log_entry.targetSideName = targetSideName
			end

		-- miguel modification M18.d destroy Plane Landing CV
		elseif log_entry.type == "land" then										--hit event with initiator or any other event (excludes hit events without initiator, like collisions)		
			
			if event.initiator then

				local playerName = event.initiator:getPlayerName()

				if event.place then

					-- local s =""
					-- s = s.."| Object.getCategory "..initiatorObjCategory
					-- -- s = s.."| "..event.initiator:getName()
					-- s = s .. "| " .. event.initiator and event.initiator:getName() or "unknown"
					-- -- s = s.." "..event.place:getCategory()
					-- s = s.."| Airbase.getCategory "..Airbase.getCategory(event.place)
					-- -- s = s.."| "..event.place:getName()
					-- s = s .. "| " .. event.place and event.place:getName() or "unknown"
					-- s = s.."| "..event.initiator:getID()
					-- s = s.."| "..event.initiator:getTypeName()


					log_entry.place = event.place and event.place:getName() or "unknown"
					log_entry.placeTypeName = tostring(event.place:getTypeName())
					-- local baseCoalitionId = Airbase.getCoalition(event.place)
					log_entry.objCategory = initiatorObjCategory

					local initDesc = event.initiator:getDesc()
					local placeDesc = event.place:getDesc()
					
					-- Airbase.Category = {
					-- 	AIRDROME = 0,
					-- 	HELIPAD = 1, 
					-- 	SHIP = 2,
					-- }
					-- if event.place:getCategory() == Airbase.Category.SHIP    and not event.initiator:getPlayerName() then 
					if not playerName then
						
						if env.mission.theatre ~= "Kola" then
							if placeDesc.category == Airbase.Category.SHIP then 											-- category ship
								
                                --relance un Pedro si c'est un Pedro qui se pose
								if initiatorName and string.find(initiatorName, "Pedro") then

									--["name"] = "Unit_Pedro_CVN-71 Theodore Roosevelt_1",
									local cvName = initiatorName
									
									cvName = cvName:gsub( "Unit_Pedro_", "")
									cvName, _ = cvName:match("([^,]+)_([^,]+)")

									--cherche le type d'helico et les parametres de store et autre à lui coller pour creer un autre Pedro identique
									if not TypePedroByCV[cvName] then

										for coalitionN, coalition in pairs(env.mission.coalition) do
											for countryN, state in pairs(coalition.country) do
												if state.helicopter then
													for groupN, _group in pairs(state.helicopter.group) do
														if _group.task == "Transport" and _group.name:find(cvName) and _group.name:find("Pedro") then
															
															TypePedroByCV[cvName] = {
																type = _group.units[1].type,
																payload = _group.units[1].payload,
																livery_id = _group.units[1].livery_id,
																AddPropAircraft = _group.units[1].AddPropAircraft,
																callsign = _group.units[1].callsign,
															}
															break
														end
													end
												end
											end
										end
									end
								
									NeedPedro(cvName, TypePedroByCV[cvName])
								end

								if initDesc.category == Unit.Category.HELICOPTER then
									table.insert(despawn, event.initiator)
								end

							elseif placeDesc.category == Airbase.Category.HELIPAD then 											-- category ship
								table.insert(despawn, event.initiator)

							end
						else
							table.insert(despawn, event.initiator)
						end
						
					end

					
					if initDesc.displayName then
						log_entry.initiator = initiatorName --store initiator name
						log_entry.type_name = event.initiator:getTypeName()

						log_entry.placeTypeName = CleanName(log_entry.placeTypeName)
						log_entry.placeCoalitionId = Airbase.getCoalition(event.place)
						log_entry.place = CleanName(log_entry.place)

					end

					if initiatorObjCategory == Object.Category.UNIT and playerName then			--initiator is a unit debug_ET01.h
						log_entry.pilotName = playerName
						log_entry.pilotName = log_entry.pilotName:gsub("['\"]", '')
					end

                    -- if initiatorObjCategory ~= Object.Category.SCENERY and event.initiator.getID then --initator is not a scenery object debug_ET01.h
                    --     log_entry.initiatorMissionID = event.initiator:getID()         --store ID
                    -- end
                    
					log_entry.initiatorMissionID = initiatorId --store ID

					-- local initPointVec3 = event.initiator:getPoint()
					if initiatorVec3 and initiatorVec3.x then
						log_entry.x = initiatorVec3.x
						log_entry.y = initiatorVec3.z
						log_entry.z = initiatorVec3.y
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

				local initDesc = event.initiator:getDesc()
				if event.initiator.getName then
					log_entry.initiator = initiatorName
				end
				
				if initiatorObjCategory == Object.Category.UNIT then										--initiator is a unit debug_ET01.h

					local unitCat = initDesc.category
					log_entry.pilotName = event.initiator:getPlayerName()

					if log_entry.pilotName then
						log_entry.pilotName = CleanName(log_entry.pilotName)
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
					-- local victimMissionID = event.initiator:getID()
					if initiatorId and AFAC_targetStatus[initiatorId] then
						trigger.action.setUserFlag("targetDestroyed_Flag_" .. initiatorId, 1)
						AFAC_targetStatus[initiatorId] = nil
					end
				end

				if event.initiator.getID then
					log_entry.initiatorMissionID = initiatorId --store IDs
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

							local posVec3 = event.target:getPoint()
							if posVec3 and posVec3.x then
								log_entry.x = posVec3.x
								log_entry.y = posVec3.z
								log_entry.z = posVec3.y

								local agl = posVec3.y - land.getHeight({x=posVec3.x, y = posVec3.z})
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

			camp.RunwayLife = RunwayLife

			env.setErrorMessageBoxEnabled(true)																					-- debug_ET02	n'affiche pas les messages d'error sauf � la fin de mission

			-- modification M35.d (d: info log) version ScriptsMod
			if camp.VersionPackageICM then
				env.info( "DCE_VersionPackageICM  "..tostring(camp.VersionPackageICM) )
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
			local SAR_Str = "zoneSAR = " .. TableSerialization(ZoneSAR, 0)
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
			os.execute('start "Debriefing" cmd  /k "set \"DCSDIR=%cd%\" &  ' .. PathDD .. ' & cd ' .. PathDCE .. ' & call \"%DCSDIR%\\bin\\luae.exe\" ..\\..\\..\\ScriptsMod.'..camp.VersionPackageICM..'\\DEBRIEF_Master.lua"')

		elseif event.id == world.event.S_EVENT_HIT then
			if event.target and event.initiator then
				if targetObjCategory == Object.Category.SCENERY and event.target.getDesc then

					local lifePourcent = 0
					local initPointVec3 = event.target:getPoint()
					local scenaryName = event.target:getName()

					local hitTemp = {
						scenaryName = scenaryName,
						lasthit = initiatorName,
						lifePourcent = lifePourcent,
						x = initPointVec3.x,
						y = initPointVec3.z,
						z = initPointVec3.y,
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
					local scenaryName = initiatorName

					if scenLog[scenaryName] then
						-- local initPointVec3 = event.initiator:getPoint()				--get point of dead scenery object
						scenLog[scenaryName].x = initiatorVec3.x
						scenLog[scenaryName].y = initiatorVec3.z
						scenLog[scenaryName].z = initiatorVec3.y
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

					local scenaryName = initiatorName

					if scenLog[scenaryName] then
						-- local initPointVec3 = event.initiator:getPoint()				--get point of dead scenery object
						scenLog[scenaryName].x = initiatorVec3.x
						scenLog[scenaryName].y = initiatorVec3.z
						scenLog[scenaryName].z = initiatorVec3.y

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
					local scenaryName = initiatorName

					if scenLog[scenaryName] then
						-- local initPointVec3 = event.initiator:getPoint()				--get point of dead scenery object
						scenLog[scenaryName].x = initiatorVec3.x
						scenLog[scenaryName].y = initiatorVec3.z
						scenLog[scenaryName].z = initiatorVec3.y

						scenLog[scenaryName].event = "S_EVENT_KILL"

						local initDesc = event.initiator:getDesc()																									--debug ET01	
						if initDesc then
							scenLog[scenaryName].Desc = initDesc
						end
					end
				end
			end
		elseif event.id == world.event.S_EVENT_REFUELING then
			-- env.info("DCE_EventT_Refuel START_A "..tostring(event.initiator))

			local uid ,uName ,fuelMassMax, playerName

			if event.initiator then
				local desc = event.initiator:getDesc()
				-- Détection si c'est un tanker
				if desc and desc.attributes and desc.attributes.Tankers then
					env.info("DCE_EventT_Refuel: START_C initiator est un TANKER, recherche du receveur...")

					local tanker = event.initiator
					local tankerPosVec3 = tanker:getPoint()
					local minDist = 99999
					local closestUnit = nil

					-- Récupère la coalition du tanker
					local tankerCoalitionId = tanker:getCoalition()
					local coalitionSide = tankerCoalitionId == coalition.side.BLUE and coalition.side.BLUE or coalition.side.RED

					-- Parcours uniquement les groupes aériens de la coalition du tanker
					local groups = coalition.getGroups(coalitionSide, Group.Category.AIRPLANE)
					for _, group in ipairs(groups) do
						for i = 1, group:getSize() do
							local unit = group:getUnit(i)
							if unit and unit:isExist() and unit ~= tanker then
								local posVec3 = unit:getPoint()
								local dx = posVec3.x - tankerPosVec3.x
								local dz = posVec3.z - tankerPosVec3.z
								local dist = math.sqrt(dx*dx + dz*dz)
								-- On ne prend que l’unité la plus proche à moins de 200m et en vol
								if dist < 200 and unit:inAir() then
									if dist < minDist then
										minDist = dist
										closestUnit = unit
										tankerToPlane[tanker:getID()] = closestUnit		-- Enregistre la relation tanker -> receveur
									end
								end
							end
						end
					end

					if closestUnit then
						env.info("DCE_EventT_Refuel: START_D Avion receveur trouvé: " .. closestUnit:getName())
						uid = closestUnit:getID()
						uName = closestUnit:getName()
						desc = closestUnit:getDesc()
						fuelMassMax = desc and desc.fuelMassMax or 0

						if not refuelStartByUnit[uid] then
							refuelStartByUnit[uid] = {
							uName = uName,
							fuelMassMax = fuelMassMax,
							fuel_init_pourcent = event.initiator:getFuel(),
							unit_lbs = true,
							unit_kg = false,
							obj_unit = closestUnit,		-- Ajout de l'objet unité pour référence
							}
							env.info("DCE_EventT_Refuel: START_D2 ")
						else
								
							refuelStartByUnit[uid].start_time = timer.getTime()
							env.info("DCE_EventT_Refuel: START_D3 ")
							
						end

						
					else
						env.info("DCE_EventT_Refuel: START_E Aucun receveur trouvé à proximité du tanker.")
					end
				else
					-- Sinon, comportement normal (initiator = receveur)
					uid = initiatorId
					uName = initiatorName
					fuelMassMax = desc and desc.fuelMassMax or 0
					if not refuelStartByUnit[uid] then
						refuelStartByUnit[uid] = {
							uName = uName,
							fuel_init_pourcent = event.initiator:getFuel(),
							fuelMassMax = fuelMassMax,
							unit_lbs = true,
							unit_kg = false,
							obj_unit = event.initiator,		-- Ajout de l'objet unité pour référence
							}
							env.info("DCE_EventT_Refuel: START_F1 ")
						else
								
							refuelStartByUnit[uid].start_time = timer.getTime()
							env.info("DCE_EventT_Refuel: START_F2 ")
						end
				end

				env.info("DCE_EventT_Refuel START_G -----------------==================> uid: " .. tostring(uid) .. " / uName: " .. tostring(uName))

				if refuelStartByUnit[uid].obj_unit.getPlayerName then
					playerName = refuelStartByUnit[uid].obj_unit:getPlayerName()
				end
				
				refuelStartByUnit[uid].status = "REFUELING"

				-- trigger.action.outTextForUnit(uid, "S_EVENT_REFUELING "..tostring(uName).." "..tostring(playerName), 20)

				if not refuelProgressTimerId then
					-- env.info("DCE_EventT_Refuel START_G ")
					refuelProgressTimerId = timer.scheduleFunction(CheckRefuelProgress, nil, timer.getTime() + 0.01)
				end
			end
	

		elseif event.id == world.event.S_EVENT_REFUELING_STOP then
			-- env.info("DCE_EventT_Refuel STOP_A S_EVENT_REFUELING_STOP")

			if event.initiator and event.initiator.getID and event.initiator.getFuel and event.initiator.isExist and event.initiator:isExist() then
				local tanker_uid = initiatorId
				local plane_obj
				local uid

				if tankerToPlane[tanker_uid] then
					
					plane_obj = tankerToPlane[tanker_uid]
					uid = plane_obj:getID()
					tankerToPlane[tanker_uid] = nil
					-- env.info("DCE_EventT_Refuel STOP_B1 tankerToPlane[uid] found on en deduit LE_Plane: " .. tostring(uid))
				else
					
					plane_obj = event.initiator
					uid = tanker_uid
					-- env.info("DCE_EventT_Refuel STOP_B2 tankerToPlane not found: c est donc LR_Plane " .. tostring(uid))
				end
			
				if refuelStartByUnit[uid] and refuelStartByUnit[uid].fuel_init_pourcent then

					local fuelBefore = refuelStartByUnit[uid].fuel_init_pourcent

					if fuelBefore then
						
						local fuelAfter = plane_obj:getFuel()
						
						-- env.info("DCE_EventT_Refuel STOP_D1 uid: " .. tostring(uid) .. " / fuelBefore: " .. tostring(fuelBefore).. " / fuelAfter: " .. tostring(fuelAfter))

						local fuelTransferred = fuelAfter - fuelBefore
						local fuelMassMax = refuelStartByUnit[uid].fuelMassMax
						local fuelTransferredKg = math.floor(fuelTransferred * fuelMassMax)
						local fuelTransferredLbs = math.floor(fuelTransferredKg * 2.20462 + 0.5)
						local fuelAfterKg = fuelAfter * fuelMassMax
						local fuelTotalLbs = math.floor(fuelAfterKg * 2.20462 + 0.5)

						refuelStartByUnit[uid].status = "REFUELING_STOP"
						
						local playerName = plane_obj.getPlayerName and plane_obj:getPlayerName() or nil
						
						if playerName then
							trigger.action.outTextForUnit(uid, string.format("Total: %.0f lbs, fuel transferred: %.0f lbs", fuelTotalLbs, fuelTransferredLbs), 20)

							env.info("DCE_EventT_Refuel outTextForUnit Stop for unit -----------------==================> " .. string.format("(outText_All) Total: %.0f lbs, fuel transferred: %.0f lbs", fuelTotalLbs, fuelTransferredLbs))
						end

					end
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
					local pointVec3 = u:getPoint()																--get position of ship
					local power = h0 / 100																	--explosive power is relatve to ship strenght
					--trigger.action.outText(counter .. " / Name: " .. name .. " / Power: " ..power .. " / Health: " .. health_current, 1)	--DEBUG
					trigger.action.explosion(pointVec3, power)													--apply explosion
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
										local unitAeroPointVec3 = unitAero:getPoint()
										local unitAeroFuel = unitAero:getFuel()
										local alti = unitAeroPointVec3.y - base.elevation
										if alti <= 1000 and unitAeroFuel <= 0.75 then
											local distance = math.floor(math.sqrt(math.pow(base.x - unitAeroPointVec3.x, 2) + math.pow(base.y - unitAeroPointVec3.z, 2)))

											
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

		env.info("DCE_try despawn "..n)
		if despawn[n].isExist and despawn[n]:isExist() then
			despawn[n]:destroy()
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

