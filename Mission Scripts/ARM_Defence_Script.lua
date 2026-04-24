--ARM Defence Script
--by Marc "MBot" Marbot
--Version 21.12.2014
--This script gives radars a chance to detect anti-radar missiles launched against them and to shut down for self-preservation
------------------------------------------------------------------------------------------------------- 
-- last modification:  M83_c
if not versionDCE then versionDCE = {} end
versionDCE["Mission Scripts/ARM_Defence_Script.lua"] = "4.6.13"
------------------------------------------------------------------------------------------------------- 	

env.info("DCE_ARM START LOADING ARM_Defence_Script.lua "..tostring(versionDCE["Mission Scripts/ARM_Defence_Script.lua"]))


-- Cache global des jammers (mis à jour périodiquement)
local cachedJammers = {}

-- Intervalle de mise à jour des jammers (secondes)
local jammerRefreshInterval = 30

--  Table globale des missiles en cours de suivi
local activeMissiles = {}

--  Table des Jammers (actualisée à chaque tir de missile)
local jammers = {}

SAM_AMM = {
    ["Patriot str"] = true,
    ["S-300PS 40B6M tr"] = true,
    ["S-300PS 40B6MD sr"] = true,
    ["S-300PS 54K6 cp"] = true,
    ["S-300PS 64H6E sr"] = true,
    
}

OLD_SAM_Radar = {
    ["SNR_75V"] = true,
    ["snr s-125 tr"] = true,
}

local timingRadarOff = { 5, 15 }

ARM_Shot_EventHandler = {}

-- =========================
-- SA-10 RADAR MANAGEMENT
-- =========================

local sa10Sites = {}
local sa10CheckInterval = 15


-- Met à jour la liste des jammers actifs (optimisation performance)
-- Pourquoi : éviter de rescanner tous les avions à chaque tir de missile SAM
local function updateJammers()
	cachedJammers = {}

	for _, sideNum in ipairs({ coalition.side.BLUE, coalition.side.RED }) do
		local groups = coalition.getGroups(sideNum, Group.Category.AIRPLANE)
		for _, gp in pairs(groups) do
			if gp and gp:isExist() then
				for _, unit in ipairs(gp:getUnits()) do
					if unit and unit:isActive() and unit:inAir() then
						local typeName = unit:getTypeName()
						if campL.jammerOnBoard and campL.jammerOnBoard[typeName] then
							table.insert(cachedJammers, {
								unit = unit,
								range = campL.jammerOnBoard[typeName].range,
								efficiency = campL.jammerOnBoard[typeName].efficiency,
							})
						end
					end
				end
			end
		end
	end

	-- Relance périodique
	timer.scheduleFunction(updateJammers, {}, timer.getTime() + jammerRefreshInterval)
end

local function initSa10Sites()
    for _, side in ipairs({ coalition.side.RED, coalition.side.BLUE }) do
        local groups = coalition.getGroups(side, Group.Category.GROUND)

        for _, grp in pairs(groups) do
            if grp and grp:isExist() then
                local grpName = grp:getName()
                local units = grp:getUnits()

                local launchers = {}

                for _, u in ipairs(units) do
                    if u and u:isExist() then
                        local t = u:getTypeName()

                        if t == "S-300PS 5P85C ln" or t == "S-300PS 5P85D ln" then
                            table.insert(launchers, u)
                        end
                    end
                end

                if #launchers > 0 then
                    sa10Sites[grpName] = {
                        group = grp,
                        launchers = launchers,
                        maxAmmo = #launchers * 4, -- hypothèse SA-10 standard
                        radarOff = false,
                    }

                    env.info("DCE_SA10 INIT " .. grpName .. " launchers=" .. #launchers)

                end
            end
        end
    end
end

local function makeExplosion(posMissile)

	trigger.action.explosion(posMissile, 100)
	-- env.info("ARM_Jammer D Missile explosion !")
	-- trigger.action.outText("ARM_Jammer Missile explosion", 20)

end

local function missileDisappearTimer(missile)

	if missile and missile:isExist() then
		local missileVec3 = missile:getPoint()
		missile:destroy()

		timer.scheduleFunction(makeExplosion, missileVec3, timer.getTime() + 0.3)

		-- env.info("ARM_Jammer C Missile disparait proche du Jammer !")
		-- trigger.action.outText("Missile détruit proche du Jammer", 20)
	end
end

--  Fonction de surveillance active
local function checkMissileProximity()
	-- env.info("ARM_Jammer B0 ")

    if #activeMissiles == 0 then
        -- env.info("ARM_Jammer B99 Fin de la surveillance des missiles (plus de missiles actifs)")
        return -- On arrête la boucle si plus de missiles
    end

    -- Vérification des distances missile ↔ jammer
    for i = #activeMissiles, 1, -1 do
        local missile = activeMissiles[i]

        -- Vérification stricte : si le missile n'existe plus, on le supprime
        if not missile or not missile:isExist() or not missile.getPoint then
            table.remove(activeMissiles, i)
        else
            local missileVec3 = missile:getPoint()

			for _, jammer in ipairs(jammers) do

				if jammer.unit and jammer.unit:isExist() then  -- Protection contre les unités invalides

					local jammerVec3 = jammer.unit:getPoint()

					-- local dx = missileVec3.x - jammerVec3.x
					-- local dy = missileVec3.y - jammerVec3.y
					-- local dz = missileVec3.z - jammerVec3.z
					-- local distance = math.sqrt(dx * dx + dy * dy + dz * dz)

					-- if distance < jammer.range then

					local dx = missileVec3.x - jammerVec3.x
					local dy = missileVec3.y - jammerVec3.y
					local dz = missileVec3.z - jammerVec3.z
					local distance2 = dx * dx + dy * dy + dz * dz
					local range2 = jammer.range * jammer.range

					if distance2 < range2 then

						local valueRandom = math.random(0,100)
						-- env.info("ARM_Jammer B4 valueRandom "..tostring(valueRandom))

						if valueRandom <= jammer.efficiency then

							local vMissile = 1167 -- SA-2: 1 167 m/s.
							local tempsDeVol = math.floor(jammer.range / vMissile)

							-- env.info("ARM_Jammer B5 Missile tempsDeVol "..tostring(tempsDeVol))

							local deltaTimeUnit = math.random(0,tempsDeVol)
							local deltaTimeDiz = math.random(0,9)
							local deltaTime = tonumber(deltaTimeUnit.."."..deltaTimeDiz)

							timer.scheduleFunction(missileDisappearTimer, missile, timer.getTime() + deltaTime)

							env.info("ARM_Jammer B6 Missile sera détruit dans "..tostring(deltaTime).." valueRandom: "..tostring(valueRandom).." <=jammer.efficiency: "..tostring(jammer.efficiency))
							-- trigger.action.outText("ARM_Jammer Missile sera détruit dans "..tostring(deltaTime), 20)
						else
							env.info("ARM_Jammer B7 Missile ira au BUT ! ".." valueRandom: "..tostring(valueRandom).." <=jammer.efficiency: "..tostring(jammer.efficiency))
							-- trigger.action.outText("Missile ira au BUT", 20)
						end

						-- Suppression du missile suivi
						table.remove(activeMissiles, i)
						break
					end
				end
            end
        end
    end

    -- Relancer la vérification seulement s'il reste des missiles actifs
    if #activeMissiles > 0 then
        timer.scheduleFunction(checkMissileProximity, {}, timer.getTime() + 0.2)
    else
        env.info("ARM_Jammer B100 Surveillance arrêtée (plus de missiles actifs)")
    end
end



local function RadarOn(ctrl)																				--Function to turn radar back on after a riding out the attack
	if ctrl ~= nil then
		ctrl:setOption(AI.Option.Ground.id.ALARM_STATE, AI.Option.Ground.val.ALARM_STATE.AUTO)				--Turn radar on
		--trigger.action.outText("Radar On", 3)	--DEBUG
	end
end

local function RadarOff(arg)																				--Function to shut down radar of attacked unit/group
    if not arg or not arg[1] or not arg[1].getGroup then return end
    -- local grp = arg[1]:getGroup()																			--Get group of attached unit (radar can only be turned off for whole group)
	if arg[1] and arg[1]:isExist() then
        local grp = arg[1]:getGroup()
        if grp ~= nil then
            local ctrl = grp:getController()																	--Get controller of group
            if ctrl then
                ctrl:setOption(AI.Option.Ground.id.ALARM_STATE, AI.Option.Ground.val.ALARM_STATE.GREEN)				--Turn off radar
                --trigger.action.outText("Radar Off", 3)	--DEBUG
                -- timer.scheduleFunction(RadarOn, ctrl, timer.getTime() + math.random(120, 240))						--Schedule turning radar back on in 2 to 4 minutes
                timer.scheduleFunction(RadarOn, ctrl, timer.getTime() + math.random(360, 540))						--Schedule turning radar back on in 6 to 9 minutes
            end
        end
    end
end

-- Détection menace proche (avion uniquement)
-- Pourquoi : éviter scan lourd, suffisant pour déclencher le radar
local function isThreatNearby(site, range)
    local grp = site.group
    if not grp or not grp:isExist() then return false end

    local units = grp:getUnits()
    if not units or not units[1] then return false end

    local pos = units[1]:getPoint()
    local range2 = range * range

    for _, side in ipairs({ coalition.side.BLUE, coalition.side.RED }) do
        local groups = coalition.getGroups(side, Group.Category.AIRPLANE)

        for _, g in pairs(groups) do
            if g and g:isExist() then
                for _, u in ipairs(g:getUnits()) do
                    if u and u:isExist() and u:inAir() then
                        local p = u:getPoint()

                        local dx = pos.x - p.x
                        local dz = pos.z - p.z
                        local dist2 = dx * dx + dz * dz

                        if dist2 < range2 then
                            return true
                        end
                    end
                end
            end
        end
    end

    return false
end

local function updateSa10Radar()
    -- env.info("DCE_SA10 updateSa10Radar A ")

    for name, site in pairs(sa10Sites) do
        -- env.info("DCE_SA10 updateSa10Radar B")
        if site.group and site.group:isExist() then
            local totalAmmo = 0
            -- env.info("DCE_SA10 updateSa10Radar C")

            for _, u in ipairs(site.launchers) do
                -- env.info("DCE_SA10 updateSa10Radar D")
                if u and u:isExist() then
                    local ammo = u:getAmmo()
                    -- env.info("DCE_SA10 updateSa10Radar E")
                    -- _affiche(ammo , "ammo: ")

                    if ammo then
                        -- env.info("DCE_SA10 updateSa10Radar F")
                        for _, w in ipairs(ammo) do
                            -- env.info("DCE_SA10 updateSa10Radar G"..tostring(w.desc and w.desc.typeName) )
                            -- filtre missiles uniquement
                            -- if w.desc and w.desc.category == 4 then
                                -- env.info("DCE_SA10 updateSa10Radar H "..tostring(w.count))
                                totalAmmo = totalAmmo + (w.count or 0)
                            -- end
                        end
                    end
                end
            end

            local ratio = 0
            local threat = isThreatNearby(site, 20000)
            if site.maxAmmo > 0 then
                ratio = totalAmmo / site.maxAmmo
            else
                env.info("DCE_SA10 site.maxAmmo == 0 " .. name )
            end

            local ctrl = site.group:getController()
            if ctrl then
                -- PRIORITÉ : menace proche → ON
                if threat then
                    if site.radarOff then
                        ctrl:setOption(AI.Option.Ground.id.ALARM_STATE,
                            AI.Option.Ground.val.ALARM_STATE.AUTO)

                        site.radarOff = false
                        env.info("DCE_SA10 RADAR ON (THREAT) " .. name .. " ratio=" .. ratio)
                        env.info("DCE_SA10 "..name.." ammo="..totalAmmo.."/"..site.maxAmmo.." ratio="..ratio.." threat="..tostring(threat))
                    end

                    -- SINON logique stock
                else
                    if ratio < 0.33 then
                        if not site.radarOff then
                            ctrl:setOption(AI.Option.Ground.id.ALARM_STATE,
                                AI.Option.Ground.val.ALARM_STATE.GREEN)

                            site.radarOff = true
                            env.info("DCE_SA10 RADAR OFF " .. name .. " ratio=" .. ratio)
                            env.info("DCE_SA10 "..name.." ammo="..totalAmmo.."/"..site.maxAmmo.." ratio="..ratio.." threat="..tostring(threat))
                        end
                    else
                        if site.radarOff then
                            ctrl:setOption(AI.Option.Ground.id.ALARM_STATE,
                                AI.Option.Ground.val.ALARM_STATE.AUTO)

                            site.radarOff = false
                            env.info("DCE_SA10 RADAR ON " .. name .. " ratio=" .. ratio)
                            env.info("DCE_SA10 "..name.." ammo="..totalAmmo.."/"..site.maxAmmo.." ratio="..ratio.." threat="..tostring(threat))
                        end
                    end
                end
                -- -- OFF logique
                -- if ratio < 0.66 then
                --     if not site.radarOff then
                --         ctrl:setOption(AI.Option.Ground.id.ALARM_STATE,
                --             AI.Option.Ground.val.ALARM_STATE.GREEN)

                --         site.radarOff = true
                --         env.info("DCE_SA10 RADAR OFF " .. name .. " ratio=" .. ratio)
                --     end

                --     -- ON logique
                -- else
                --     if site.radarOff then
                --         ctrl:setOption(AI.Option.Ground.id.ALARM_STATE,
                --             AI.Option.Ground.val.ALARM_STATE.AUTO)

                --         site.radarOff = false
                --         env.info("DCE_SA10 RADAR ON " .. name .. " ratio=" .. ratio)
                --     end
                -- end
            end
        end
    end

    return timer.getTime() + sa10CheckInterval
end



--Event handler to look for launched ARM
function ARM_Shot_EventHandler:onEvent(event)

    if event.id == world.event.S_EVENT_SHOT then
		local t0
		if campL.debug then
			t0 = os.clock()
			Perf_M_N = Perf_M_N + 1
		end

        local wep = event.weapon    --Get the weapon of the launch event
        local tgt = wep:getTarget() --Get the target of the weapon
        local addTime = 0
        -- if not wep or not wep.getDesc then return end
        if not wep or not wep:isExist() or not wep.getDesc then return end

        -- if event.initiator and Object.getCategory(event.initiator) == Object.Category.UNIT  then										--initiator is a unit debug_ET01.h
        -- 	env.info("DCE_ARM_S_EVENT A SHOT getPlayerName "..tostring( event.initiator:getPlayerName()))
        -- end

        -- env.info("DCE_ARM_S_EVENT    B SHOT tgt "..tostring(tgt))
        if tgt and tgt:isExist() then
            local desc = wep:getDesc()
            -- env.info("DCE_ARM_S_EVENT       C ")
            -- _affiche(desc, "DCE desc weapon ArmDS")

            -- Weapon.MissileCategory = {
            -- 	AAM,
            -- 	SAM,
            -- 	BM,
            -- 	ANTI_SHIP,
            -- 	CRUISE,
            -- 	OTHER
            --   }

            -- Weapon.GuidanceType = {
            -- 	INS,
            -- 	IR,
            -- 	RADAR_ACTIVE,
            -- 	RADAR_SEMI_ACTIVE,
            -- 	RADAR_PASSIVE,
            -- 	TV,
            -- 	LASER,
            -- 	TELE
            --   }

            if desc.missileCategory == 6 and desc.guidance == 5 then --Check if the weapon is an ARM
                -- env.info("DCE_ARM_S_EVENT          D ")

                -- Object.Category
                -- UNIT    1
                -- WEAPON  2
                -- STATIC  3
                -- BASE    4
                -- SCENERY 5
                -- Cargo   6

                local objCat = Object.getCategory(tgt)

                if objCat ~= Object.Category.SCENERY then --target is not a scenery object
                    -- env.info("DCE_ARM_S_EVENT          E Object_Category: " .. tostring(Object_Category[objCat]))

                    local unitCat = tgt:getDesc().category
                    -- env.info("DCE_ARM_S_EVENT          E unitCat: " .. tostring(unitCat))
                    if unitCat ~= 3 then --target is not a ship	-- bug AGM-154 :31: in function 'getDesc' Static doesn't exist
                        -- trigger.action.outText("ARM Launch", 3)    --DEBUG
                        local name = tgt:getName()

                        -- env.info("DCE_ARM_               F1 Launch name tgt radar: " .. tostring(name))
                       
                        local descRadarSam = tgt:getDesc()

                        -- _affiche(descRadarSam, "descRadarSam: ")

                        env.info("DCE_ARM_               F2 Launch name tgt descRadarSam.typeName: " .. tostring(descRadarSam.typeName))


                        if math.random(1, 10) > 1 then --90% chance that ARM launch is detected by target
                            local probaTurnOff = 75

                            env.info("DCE_ARM_Radar SAM_AMM? " .. tostring(SAM_AMM[descRadarSam.typeName]))

                            if descRadarSam and descRadarSam.typeName and SAM_AMM[descRadarSam.typeName] then
                                -- probaTurnOff = 5
                                env.info("DCE_ARM_Radar return")
                                return
                            end

                            if math.random(1, 100) <= probaTurnOff then
                                trigger.action.outText("RadarOff", 3)	--DEBUG
                                env.info("DCE_ARM_RadarOff")

                                if OLD_SAM_Radar[descRadarSam.typeName] then
                                    addTime = 60
                                    env.info("DCE_ARM_Defence OLD_SAM_Radar detected addTime: " .. tostring(addTime))
                                end

                                timer.scheduleFunction(RadarOff, { tgt, wep },
                                    timer.getTime() + math.random(timingRadarOff[1], timingRadarOff[2]) + addTime) --Target reacts within 5 to 15 seconds after ARM launch with shutting down its radar
                            end
                        end
                    end
                end


            end
        end



        local desc = wep:getDesc()
        if desc.missileCategory == 2 and (desc.guidance == 3 or desc.guidance == 4) then
            -- Ajout du missile dans la table des missiles actifs
            table.insert(activeMissiles, wep)

            -- Utilisation du cache de jammers (optimisé)
            jammers = cachedJammers

            -- Démarrage de la surveillance si ce n'est pas déjà fait
            if #activeMissiles == 1 then
                env.info("ARM_Jammer Démarrage de la surveillance des missiles...")
                -- trigger.action.outText("ARM_Jammer Démarrage de la surveillance des missiles.",20)
                checkMissileProximity()
            end
        end

		if campL.debug then
			local dt = os.clock() - t0
			Perf_M = Perf_M + dt
		end
    end

end
world.addEventHandler(ARM_Shot_EventHandler)

-- Initialisation du cache des jammers
updateJammers()

env.info("DCE_ARM END OF LOADING ARM_Defence_Script ")

-- initSa10Sites()
-- _affiche(sa10Sites, "sa10Sites: ")
-- timer.scheduleFunction(updateSa10Radar, {}, timer.getTime() + 10)
